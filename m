Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0A1D2C44515
	for <linux-mm@archiver.kernel.org>; Thu, 16 Jul 2026 15:07:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 144DC6B012A; Thu, 16 Jul 2026 11:07:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0F6646B012B; Thu, 16 Jul 2026 11:07:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E889B6B012C; Thu, 16 Jul 2026 11:07:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id BADE66B0120
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 11:07:49 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D28BB120190
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 13:52:00 +0000 (UTC)
X-FDA: 84994778400.08.7FF0B3D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id 48D71C0007
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 13:51:59 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JNCDiMmr;
	spf=pass (imf22.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784209919;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=upS5dAIhqaeNkD4Y215zZ+qqauX1huW7BJD20LHOgmI=;
	b=07B2E4y4YNOrPZA509wOnESI4RLIUsBjqE6L8vdPdUZQiQ8TMtPREnhm5nvEr30rl4NgbS
	cHg0DBnryeGYY9wVV4hdUsq/5c/0JcoMaH8FXH09UWCpVNdFTY5IXDiCnXa991+im+mD3g
	rSLJvCy2b3t9GD1ZKBkbyoef16spovU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784209919;
	b=S11YrigwRPK8sFWPuyEAs7WnO2VPBzQa5J+WAibKkWnkBD+B25RULWu4rbA1HiZAjYv/tW
	MYxov58vBxBR5llib/nW+zpeYM1aQAqdjziRj3AdiZA958My6SDgYZ7BKJhuZ9kxNVqmTS
	/zrvY/coovc4+JY6XcEH3CikkY49vcQ=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JNCDiMmr;
	spf=pass (imf22.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A2C3E60051;
	Thu, 16 Jul 2026 13:51:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 012261F00A3A;
	Thu, 16 Jul 2026 13:51:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784209918;
	bh=upS5dAIhqaeNkD4Y215zZ+qqauX1huW7BJD20LHOgmI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=JNCDiMmr1ueHBLvBy3MYHFTMFeo5yJ5AzXu+ouiki7cfoMixmPoMHunzb4dN7S78z
	 1oBhDZccLk3T5PHQPKeXKzqdckE5Ej5kM0VTCEFf549WMrBwUa+nYLFjFcrSk5cdXe
	 kFA+SBK3rFwjNo9nlxFvi3shGjhb7bAHW2KlpBZ2lPnZeJiW8d+HRQWkiHCxxa7+xM
	 JrH90vMWFUJ3hN3bPdiKp0CzQ3Ewy4YB9eharf0q7HgO0b6vTS/Y1gfn3Y1xaqRHag
	 ux5ueYDs+oBJlDBaR3CoI8HTz0qsPmt0Z8cSBYwfiOuZs/aSvc3wcILdYV2DEgJUBN
	 vVn4r3kSRM1mw==
Date: Thu, 16 Jul 2026 14:51:43 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Kiryl Shutsemau <kirill@shutemov.name>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R . Howlett" <liam@infradead.org>, 
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
	Usama Arif <usama.arif@linux.dev>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	"Kiryl Shutsemau (Meta)" <kas@kernel.org>
Subject: Re: [PATCH 1/2] mm/huge_memory: remove unused can_split_folio()
Message-ID: <aljhxuco3YxxZ7zk@lucifer>
References: <20260716100345.473473-1-kirill@shutemov.name>
 <20260716100345.473473-2-kirill@shutemov.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260716100345.473473-2-kirill@shutemov.name>
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 48D71C0007
X-Stat-Signature: exds7iuqokdicsx9phgn78ckg3zzgjin
X-HE-Tag: 1784209919-729738
X-HE-Meta: U2FsdGVkX1/Kn88xb6o7yBLgDCgpRlF/mS8bHf0hTyJqDkAF9d/ZAnI97GpQWjS2f4kGzDX+ElCQawgGi4p1CZ2m1cipcn+29vAB+gvFsZKRwT9Mk9AbuodbUfAmlO7s4mWwttGJ2KfwJEllTKRueI25AoHkYascFKVNwUTG291KuBPw0WXwlLrP2TywvZo2cm1GYk4KUpEqoq9MnLtjQPgcycnKjK+q7i0e0BIJZJ4vDeiDiul/KlH3s2VSfyNVhNlfsALxnOSAHFwow+uHL2YZXTd6cnbahdCzziELcJN2bC/96uck0ch1SKL7VwZCb4Mpjm12ItP+ZzAgMGZf+5TLoaTNIPZo9fiqXtTpr1ctUGz5MV1iEfluPqzxfnL0noRbpMIJcmkGDq0ceZMS+nG7NvVQ7KQwCopCZkrGHJ4U3bHDD9O2pXY8TWDjb1LT3xqq9c8LcaTvO0dmKv9VsfzJorHBe5WRlNFnE1ulNbZqJ52DDfd6eqbgVMaK3jpwu6kaLN5hN03spwdx6foH/38ebWKDAFJIx94S95aeO9P4gImtPLqbmpdCLsnYhmyxcECgsohcLb2NhRIqTrbOfF5yJaI7FkZdcTRbpi3mf22e1LJDciHk5SniRYl8/vPMOf8UoJ6wUiQ8mIbOstiCUEtfjJXIwXXC0XlnuGqdrv3m54OEF0o1XgzOB81fkojP0J0H+oaPBdUJljRuQaq6r8oINA6aK/wv2060HNyW2q0PSJ0UZNhcemLkn6LtUauffYrhQ8pYknOYkqipOdsK6WtWj806yl8wHxAzUOeGyurQhXvM/F79msmt2Ku/wCEsKF17GIxrgAt6Qix0HdpjI14d3BpOFDaesB4niuNxdTzCJT4vJWZGtlsRaHZqiqVQ6gQFxCc5gIQ358zwd/focB1b6bQ7wndU9zBaC0Z1zSeKOCHLvkDsmlmoAKQi6szkNoxHRBlCNEJuzJC+zI+
 wz9q56jy
 DW8Y1pQ/RVZBgu27CWJNKwUC/QfwhcXQfvZOL7Vqv9Zjsc+1vmuGCTsHxu9jCJAyxnU/zOqwn/HjojloW43uFzbFafKjmm/duC4/JXnCUg60jd+9eh8+BCPPMAVb1SdwaDITXa8yvr+8ncsTDiBsFztLrlObTA//yCNVZaWzXEUneMwGJXvZllC5sAvxZ1MJmETUZqFojBRxCIcLoZzmL0MBpQRN8kv6rkO316hns/+k0UffXD7osZjofZKNNuEkRPes8ktQTqN6+5o/e6pEbnNnXjv+holZeQG+unsqBqLLqJHhofDNzdkH+kj2JTV6Idjnu
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 16, 2026 at 11:03:44AM +0100, Kiryl Shutsemau wrote:
> From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
>
> can_split_folio() has no callers and no definition under
> CONFIG_TRANSPARENT_HUGEPAGE; only the !THP stub remains, left behind by an
> earlier cleanup.  Remove it.
>
> No functional change.
>
> Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>

LGTM, so:

Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

> ---
>  include/linux/huge_mm.h | 5 -----
>  1 file changed, 5 deletions(-)
>
> diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
> index ad20f7f8c179..6961db4d1591 100644
> --- a/include/linux/huge_mm.h
> +++ b/include/linux/huge_mm.h
> @@ -621,11 +621,6 @@ thp_get_unmapped_area_vmflags(struct file *filp, unsigned long addr,
>  	return 0;
>  }
>
> -static inline bool
> -can_split_folio(struct folio *folio, int caller_pins, int *pextra_pins)
> -{
> -	return false;
> -}
>  static inline int
>  split_huge_page_to_list_to_order(struct page *page, struct list_head *list,
>  		unsigned int new_order)
> --
> 2.54.0
>

Cheers, Lorenzo

