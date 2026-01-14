Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A3CC5D38FEF
	for <linux-mm@archiver.kernel.org>; Wed, 14 Jan 2026 16:55:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0A4EE6B0096; Wed, 14 Jan 2026 11:55:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0529A6B009B; Wed, 14 Jan 2026 11:55:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EC1FA6B009E; Wed, 14 Jan 2026 11:55:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id DE13F6B0096
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 11:55:37 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A6F6D160587
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 16:55:37 +0000 (UTC)
X-FDA: 84331170714.23.921E83D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id D8D7F4000A
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 16:55:35 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=l9cMh3NY;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768409736; a=rsa-sha256;
	cv=none;
	b=pkR8n5QyrK15qDN/wgvQSno6LcURzuCd4usFUIuW61galKxP+0Jc9jrkWNF0PFEG1CIK+u
	uSc79ygpeKkd2TLJzVBRqt2pdmbisApsPG5Lhe0qQV0TcijdZJMfnDAdKzkEYmIW5rfkm+
	Wa640LZnkxDtQ9uS1cmOjG6Lg09n1TY=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=l9cMh3NY;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768409736;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OR56xfz3n/ClMDrLNpxJLgxI1KhaD39Tup7yEi4XmY8=;
	b=nto1/U77f6Td+yix50Z/NhhzrjLbgDn/TMsjV7Q1nlMEGjHGbJbgAfGW8YKspCbHLyygwC
	xSVzpS1m5g+qWkG9YOCVMj0H93QNEzhzsdBrq3qVqQ4Fj6xavb2/3TApf93OOhVgNCBx2k
	sObxARj4aVc5ylqmUGoTPIAZSnW3Duc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id CB68B41A6C;
	Wed, 14 Jan 2026 16:55:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D462FC4CEF7;
	Wed, 14 Jan 2026 16:55:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768409734;
	bh=QejQhjBMM5h7AWsceCq9AC06bxVTWkjs0XH1r2FG920=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=l9cMh3NYa7Vune+62JflcUh/D6FsoXVcIncMsmx9m1uHAvsMOsJ0VBRtSWsQFkdKm
	 q0T25Zpz+3L4U/qdB52PuM4TlLl+mjHslNNC7rdsTvueMvj7IBx5xeELmQA887Kd5g
	 r/q9ZVcRQ0R+CN78HxplGXk6u4WGm9V78oge/WgY1Hfj5jHls+HGsSNf2zbxjeofIU
	 AObRipt1LcQligXXB7KD5EId1Uxf2f0HlyyrVCqRZ359G5WK9QXr8zkf8f2jsIAdp+
	 R1aioUFFtCTyNUDXeCUHpLv+sVv0QTbmluTuGvLNDU4qyXX2RDmwLe7uHgSjkMxJ4z
	 rn3xvM2v3P6ag==
From: Pratyush Yadav <pratyush@kernel.org>
To: ranxiaokai627@163.com
Cc: graf@amazon.com,  rppt@kernel.org,  pasha.tatashin@soleen.com,
  pratyush@kernel.org,  akpm@linux-foundation.org,  surenb@google.com,
  kexec@lists.infradead.org,  linux-mm@kvack.org,
  linux-kernel@vger.kernel.org,  ran.xiaokai@zte.com.cn
Subject: Re: [PATCH v2] kho: init alloc tags when restoring pages from
 reserved memory
In-Reply-To: <20260113033403.161869-1-ranxiaokai627@163.com> (ranxiaokai's
	message of "Tue, 13 Jan 2026 03:34:03 +0000")
References: <20260113033403.161869-1-ranxiaokai627@163.com>
Date: Wed, 14 Jan 2026 16:55:31 +0000
Message-ID: <2vxztswoi16k.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Queue-Id: D8D7F4000A
X-Rspamd-Server: rspam06
X-Stat-Signature: 9bkheephtfhnrqidcwfxawaib5xur5uq
X-Rspam-User: 
X-HE-Tag: 1768409735-405101
X-HE-Meta: U2FsdGVkX19xUSBtXIIEB3269NoBR2uWgj9JfcA/GG0YhKtgZYJzYWDEyrZG6CRyYd7x1Z0gIV0e0rMTxtTF42eWbAM+LTG7Fxx0aUjMTiOZwVgJ9RySO46eWwHAJKueO8GZ9rYJ9k0f/LliEHhdbhD9sXv6boRyvnW/XwmyZczhvc6IAnDdlHnfKD7v+MSEmmFJZBd5h2HQLqKXDbqaswesKShVKZltAudfglFgIHLqjsMDRhnZ0fQcDTLzI6LamGTj7Qgt5aseA3WvaoDqbRVxNynQKGe9l7f6Bq7MR7MKKHP5e7IzToMMRqrFHhavrK30VWp034rkamlJs1sR1MOMCbQhqjX//3gGAijr+gguBE70tWY3hAhuXdcbjW7zF7F4u8wZ0F5Sz8+DMiXus5b7KVXNTYflyR1luAucRNlMJ1I+L1uiEOIS+FK/F/LxCQ5GEhAsNQai9d3Ma9MAn5C7q5S4zluMT5Sh+t9bTntVtQC4W/1JmujLrB3m74AvckT3Bd4HZx95TVt19N1iLDwZOW4FYrkF4MYg392XM9ab934UOWBogSDxTEG4IzFWQs9UHMS+AEFBkTRhRXhinNkLAIm2WkxfFqKEwhzkbARGebiDXG3d1Px5P91Y5xjwxeO+p6C5mghdsMpJ0MxEChET9uuX5d1VmfEhBXTnapkIlpZp98hdThXURQIf04cHrFwR3QfhNpoV+MIDw2HhSoLH8KoZ97JPm1al+1w635pbDZI3Juw88/x+JmdrxDfhfb1AoXiFTMshgkyuO/C9DsIZXqBNDfutAFvSUuthduEqAX3V/4ugxqKK96gVIJTOHIWefC4Rd2yZpRTfLVzdAZ4gQ7+Te6C/0ONUyqOzPZ6EAluqPlxbHDsV7VQ+Uj6UkVtUmux+JTDVvQHeOAGZgHBR2WAVb3W0ZnQ0PczIsLdhSL97xwu82Z5GSnzFIEVWYNoUXAVyexx9mnKbaEC
 U7pmYDdC
 ArbPzO+Ihrn5kZryd0ujJPTyxCAMH2e1ELXTqItEopD4jFlCpZRgEcwwZdBixgMhK9jxGfOFZJaJmweH09KTJRyqNGg8Zk42x8RVqIyqd35/pm96ZA5N3uqgGVwIQRYlfPw5Ii1raBcMDLTGBdT4uCxjOShyLH4l4gvVjWZT99BHmSfGkBx4pHFNkPs/pX8An92VuPTQvsQLqcVhmgeK2FsM77DArrpK3mbIeFV+0Rl28ZBJ2s9c6z6SRqkwy8lorTvS+dI/ysMxkSJSEOvbkQkkmGdbjZo8HIHGJVKYyDMWyvi4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Ran,

On Tue, Jan 13 2026, ranxiaokai627@163.com wrote:

> From: Ran Xiaokai <ran.xiaokai@zte.com.cn>
>
> Memblock pages (including reserved memory) should have their allocation
> tags initialized to CODETAG_EMPTY via clear_page_tag_ref() before being
> released to the page allocator. When kho restores pages through
> kho_restore_page(), missing this call causes mismatched
> allocation/deallocation tracking and below warning message:
> alloc_tag was not set
> WARNING: include/linux/alloc_tag.h:164 at ___free_pages+0xb8/0x260, CPU#1: swapper/0/1
> RIP: 0010:___free_pages+0xb8/0x260
>  kho_restore_vmalloc+0x187/0x2e0
>  kho_test_init+0x3c4/0xa30
>  do_one_initcall+0x62/0x2b0
>  kernel_init_freeable+0x25b/0x480
>  kernel_init+0x1a/0x1c0
>  ret_from_fork+0x2d1/0x360
>
> Add missing clear_page_tag_ref() annotation in kho_restore_page() to
> fix this.
>
> Fixes: fc33e4b44b27 ("kexec: enable KHO support for memory preservation")
> Signed-off-by: Ran Xiaokai <ran.xiaokai@zte.com.cn>
> Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> Reviewed-by: Suren Baghdasaryan <surenb@google.com>
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

You are only clearing the tag for the head page. The tail pages are
still un-initialized. Is that intentional?

What about non-compound pages (the ones you get from
kho_restore_pages(), aka when is_folio is false)? Do we need to clear
the tag on all pages in that case?

>  	adjust_managed_page_count(page, nr_pages);
>  	return page;
>  }

