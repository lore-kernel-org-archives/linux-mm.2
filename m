Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 963F1D2502F
	for <linux-mm@archiver.kernel.org>; Sun, 11 Jan 2026 09:09:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 094586B00A1; Sun, 11 Jan 2026 04:09:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0378E6B00A2; Sun, 11 Jan 2026 04:09:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EAF646B00A4; Sun, 11 Jan 2026 04:09:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DC9FF6B00A1
	for <linux-mm@kvack.org>; Sun, 11 Jan 2026 04:09:22 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 76C601ACA2F
	for <linux-mm@kvack.org>; Sun, 11 Jan 2026 09:09:22 +0000 (UTC)
X-FDA: 84319109364.29.D9FB35D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id D76AA1C0002
	for <linux-mm@kvack.org>; Sun, 11 Jan 2026 09:09:20 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=vDDXkkr9;
	spf=pass (imf21.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768122561;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vL7gjUqvfCxhSt1TP11CCNuny296CJlfvFtlxrXBLKg=;
	b=kHxWFmz2U9jUL0LBgrnIxOwv37RfsqPTCd6DuJpsaXX8FI2wvNEPCm4hKrSQoLFfF/tYUj
	+9BUOY+NTChJOWMGnHwjMBpxVoqXkeylrtIcIcD1Wex6mvh/SL9XDhT7Lu4wAygz2BTRIq
	9F6V8ZRRIqomS0UWrJQgOkKreZ3CoFU=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=vDDXkkr9;
	spf=pass (imf21.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768122561; a=rsa-sha256;
	cv=none;
	b=bGWSLMfUns1aFzeHakfUrHBce2yS6NR7xQKTH4ywBwh4JWgE1K0aMoNoDO+VAyv4aKCzst
	ejrPRIFnQEf0zSTGkKN6HprZCy6eMkhDEBGAEXk2Vx8PF63OXkG77BC70IRhVJ/GF2wmr5
	n4OHazC/jR0WirGuP3MXfHDDlxRDkLk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id F3A5640DC8;
	Sun, 11 Jan 2026 09:09:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C796C4CEF7;
	Sun, 11 Jan 2026 09:09:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768122559;
	bh=GKu46ZcISn2tp5RrNUF5UFQMSBQBVWLCndgFjMo1l2k=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=vDDXkkr98Nhx5GtCAFY7rD9krnI3oR+m+tM1lenZeIb7ueLcAlFcRX0LJeytZHDfR
	 H8Z84hnHqinsNLD1d9Zi/HdKhLZcSSAzaWl/ZcdmQA3iNp9oSVQi6E/2gVrSXYNW9b
	 xoK8QJkSfYjcuHXwOGIDLGgkzkd9NgjgdhykyYdlWaZrKRScl7ejptOjy6YJI1hhxy
	 OqZGUW+CBYo6y5CHHfWdlH1uI+lYW+Any5/uuHuaDcHeVSNwCzlwbxqJfFjPK1NiJD
	 G80e8pS0xF19hkJFwbgMG8QXobXZJEMLU0sVchmc+EEMGXU7KpFRFPO/B+iT6Phj8A
	 j0cnmXBTNKaBg==
Date: Sun, 11 Jan 2026 11:09:12 +0200
From: Mike Rapoport <rppt@kernel.org>
To: ranxiaokai627@163.com
Cc: graf@amazon.com, pasha.tatashin@soleen.com, pratyush@kernel.org,
	akpm@linux-foundation.org, surenb@google.com,
	kexec@lists.infradead.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, ran.xiaokai@zte.com.cn
Subject: Re: [PATCH] kho: init alloc tags when restoring pages from reserved
 memory
Message-ID: <aWNouDKhjUzHGXks@kernel.org>
References: <20260109104251.157767-1-ranxiaokai627@163.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260109104251.157767-1-ranxiaokai627@163.com>
X-Stat-Signature: eofcxeajnomhm486xk1hwn9gkbhiao1f
X-Rspamd-Queue-Id: D76AA1C0002
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1768122560-984273
X-HE-Meta: U2FsdGVkX19e4XDOxpR4rNfIzos/48qP3PJDr8ryScNmhRNS6p4UDVt83y8x8lYsi4TKmiyIIuwBO5Xl6QNkFlLJuvvYH5wehRzllfLfVfLKIr4c+z/3DZiXSYIanFfKvYOeOFS56YCFwpsY9W3h9wOLfF0NlKBWADuGYVwpV0kSJjrpaJJm/dv278KCljeiyuB+ecjU31NkiuvscLkWpNp8jgBzgD5RsNjmJLSCiFctPXlllKEVyB8f12r7Y1iKscZANi/4UWiu9gtwwVLcuA+iGWSgkg07u0ChUCP4cxfLqBq34z52nz8fLaG9itOgEMix1qUhfeOXgRphoasfh4Sp9UyKuPvBUGHXFkAQ6EwLYxHlRHQlhymNg7E2olkeoTlDhSjOVBr9SMytVLycrPcmwvOWZzQtkpphh44RZtagcgAgdIS3ymUGU0hLGCIfuSJdGjvNqV8DvcnPVvtUlTqYlDcpxusRwhDuajU7qFtO9ngLB7Hyze62cjqKKcTHULqYzkIB+a1sCM0zfLls0eBF7w16vYgOAlA5Hau2usyhhordnSVbzHu2vSMmR9L7kEbahB0zDtwRsUh85wNR02EEOcbLGQai6eGBCCpn4Tr7OnuITo7mqAdluyPW+BTTEWI9c9VfJMOk/1PmFe4PA6x9GAwGAAavva7sS3qMXU/1Pl+kDtzhKQc7WFNByibRFrpLD47zQq+F9M6LDdrpYBDy+5u5HvbMvRUxzDiXKtB/iKgf3wKIpbYyOJ04rwwIJQOkdcV4Sb3gpn1pVSYDFRExhLDUn0+VkyH2wPI6sx6umU1AAT0RYshYHUuHGEslg4g2F5EDUvw3H23MS5k1EX0N3amHNyPiO5Z7FEAdMM4VOYwLpIJDZv8Xzv7GMKQwGW4oCOlCWpbgqdH4RUcTtVYHo/ju2FJ7kLIe07hs2RRqQ5KLWNgjJ7tMRfZYRoCq+HN6VZg7HWWO+x3vH2l
 JvxRbjQn
 10+HrYnHcL7UqkQe40L1tGFtvYwTNiz8ltZZQD7IiS8rdwWpuxs7Q7SYRd9ouRVdhMQ+ozu0KuW6oijqvWlYQbtotV4UJqAKAp/N9eteU8yjmO5szQwzHSnJYxeCJyBpKNcExgA9zZEV48qBdcefxIVqFziMEGcI+HuToDc6DW+MiOfkGDCmitkmi6A7ZHTGHDh3fllMgHGQ7uAMp7gxrp+XkRv7+hDOC5F7RrmT7dyh/xl7aBhhG4+c3RD4yflONLOuOYR5/GFHMJHqyLN1WQZSwbgYCgRBmk6MNb8tHiPaHvV2nXK9sy5EHdUdlqZvrRQq0mWFUjFWC/U/NIcdOz51NopxB+WR5CPdYaa2+hhI6z+M=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jan 09, 2026 at 10:42:51AM +0000, ranxiaokai627@163.com wrote:
> From: Ran Xiaokai <ran.xiaokai@zte.com.cn>
> 
> Memblock pages (including reserved memory) should have their allocation
> tags initialized to CODETAG_EMPTY via clear_page_tag_ref() before being
> released to the page allocator. When kho restores pages through
> kho_restore_page(), missing this call causes mismatched
> allocation/deallocation tracking and warning message:
> alloc_tag was not set.
> 
> Add missing clear_page_tag_ref() annotation in kho_restore_page() to
> fix this.
> 
> Signed-off-by: Ran Xiaokai <ran.xiaokai@zte.com.cn>

Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

> ---
>  kernel/liveupdate/kexec_handover.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
> index cd6b3fb9dcae..2d47f2c50bd8 100644
> --- a/kernel/liveupdate/kexec_handover.c
> +++ b/kernel/liveupdate/kexec_handover.c
> @@ -268,6 +268,7 @@ static struct page *kho_restore_page(phys_addr_t phys, bool is_folio)
>  	else
>  		kho_init_pages(page, nr_pages);
>  
> +	clear_page_tag_ref(page);
>  	adjust_managed_page_count(page, nr_pages);
>  	return page;
>  }
> -- 
> 2.25.1
> 
> 

-- 
Sincerely yours,
Mike.

