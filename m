Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EECD5EA3C36
	for <linux-mm@archiver.kernel.org>; Thu,  9 Apr 2026 10:33:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 645A66B0088; Thu,  9 Apr 2026 06:33:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5CF7B6B008A; Thu,  9 Apr 2026 06:33:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4BE9D6B008C; Thu,  9 Apr 2026 06:33:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 3B0086B0088
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 06:33:51 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E3D4CC1AB4
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 10:33:50 +0000 (UTC)
X-FDA: 84638656620.21.BCFA91C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id 541A380008
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 10:33:49 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=orvo0MZx;
	spf=pass (imf02.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=orvo0MZx;
	spf=pass (imf02.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775730829; a=rsa-sha256;
	cv=none;
	b=RxenvOkSFNacA5kapeQoeJAoqkeRmZWcSNafEFXiezy/f9MU3c+ZGToj9eMijmqwhsmR88
	874R94/4Y2fmZkXIyjHhGk0EGu4VumWFPq2C4AcQz5S4G998H9LerRQGVvfy5+MoaDjUOM
	0lh99scZ9LoRuwjBo/0mWUhoNIZOsIk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775730829;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aCoI6i+DnPocxOUwqSH9KXFV1m27WvxSYZQ8ms3/tSs=;
	b=Pt+aa+l+ElGF6RCN7cfBU8FjggxgFGuDYfRes3vkoY5LS/kVfZmrGdTHfkUmB6dK88lYAw
	FZU0S27v0gQYRxKWh6Vqcgqp/I9pQredmC5/rcs7ZMXtI1E67X+NscveZ5c75UiT7MhZ/h
	/joHDaqnEXnx/Uo0T8BMVELAxdHOQl8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id C26A2600CB;
	Thu,  9 Apr 2026 10:33:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0B1CC19424;
	Thu,  9 Apr 2026 10:33:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775730828;
	bh=TNpoG6jI5tUlUTjT6ng/gxK0PSSrOAvTDidVFPbVzI4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=orvo0MZx+9BgWSKdcdjIjZM78aRRqk52xsQRs/dx4vvzLle+gsk275Dc2SFF0l16c
	 iXiyU6gWr5G+gjcSqa1AxqUl1CS06FnZyI50l/0f+ZoGS1AgwJrmfePzeyTpf+h+/L
	 quTJs6pzboQRHwuZfUFx/RrVRnNsWwuWPXL75BficN9lewEnKvzx7aVpEON50Ssg6z
	 3/ox1uad544T+pg543Lv/nByorHBIxlZmrW/RcM3vrxNXhgmpGpGemo5LVN4JD9uRz
	 B7XyNXv6xVbmrCfNSxP7GAnQpRS5x7U60UxwASry2gvxTISV3rowKMPC13VMb9uByq
	 z/qpI/Pm4z38Q==
Date: Thu, 9 Apr 2026 13:33:41 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: linux-arm-kernel@lists.infradead.org,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Ryan Roberts <ryan.roberts@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Linu Cherian <linu.cherian@arm.com>, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [RFC V1 01/16] mm: Abstract printing of pxd_val()
Message-ID: <adeAhYW-hJ7-6-Xy@kernel.org>
References: <20260224051153.3150613-1-anshuman.khandual@arm.com>
 <20260224051153.3150613-2-anshuman.khandual@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260224051153.3150613-2-anshuman.khandual@arm.com>
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 541A380008
X-Stat-Signature: pr5zzydctb4krm38m4r45owxh6d3i54w
X-Rspam-User: 
X-HE-Tag: 1775730829-796297
X-HE-Meta: U2FsdGVkX19edPOVaLr4YeY5vbiUczu5PsHOyVn76o6ndBfdHEN/OJ1GKkR56SKnjG+skVyHNlCRXVbJoCwlwFC7wandwkiAiM5mhLmpOV9u9uHx2URw93bbJNs7OY5x8A0lXxc3e1BJ5YH9Y4PY17UxWMF8afzyxxT2ae+0xb252KCPgEpwaDkAbRttZSXWeOkf8q/LMapj3ITQdM9CTEP7Rw2SG3DIbAdayTSUkoodsx2Oj9c6emWGa5J+klGm9teIGhAUkTYU6Dc9PiAa8+xvTcKIA/CPJNAmvzADQNDOeHQrLqy1qVDP6KeeyBjEG7GZK8NGObc4i5GlwzbFDnyDJIGQm9vvjZg2zqOoD5muUQdf1Tx06J34Qm8iyz8t6Ha7x1CBB71HB8SNkUkRiSOBQQ83Hv/LzOx3zTQ4qtlheg1miImHyqDI99VTfLTNSqS4e1V6BnSyggtsDG7ouAi6nhqV2pYVH1dWy58lDRYU2Fej7Zfque+n7DgrAoW4vJKs4+04nsLZwivGq4XeXlJI1U5j7D2Z0H++FvKr2zBzetg2f8wo2ApMZPtkG97RXOHRu8w8KpRvU1I0P3wZelG8pQmlrI7sXnW9thYDtU4PfHLZZJ/7R8yN1GPUO8Q6CpZyNEfGtle48nKuteH4hovGo8dbmBgeqMEQevJJ8AV2mMWBCNJuAY2NvhyITzljgE1ONw+cCmEWmMLTG36uVLtBbM6T77mXgFrh/GKeOJp6UJmWkAKRprk5di34eMsMoHcq5IQiqJnPFStNtYz3gVGiTMfIQ4usItO4gUO/sOAGnuivKZWYBK76ZIpSUImqi/MkJAZpgSqXRLtk0ScZmMmXACVEKFcSiOOs5Yxfqobu47ZNsqTZgpJsFoXy8t5/wDJ4EmBrlEKgvYSuXC8BmwpXIHb5dLWF27Pl5bw9R6GRmMCDIVHX7iTzp2n/64lF7oBpjziw844coV3wG/3
 KzIbO/99
 ZJJCD4XwR+FxnV20nOaPUmYOw+Ocdh/vcSLA5KscL6GY4K94XbrSvtTeohsX5aADZ2fLeUXRXNDoGB61JaLEObX1ujjIjMWq7eMoqjak1Ot0IpUbEs5KuAtALnjiq/B5s8r1/xvRAkXQpbQ7EirTLY4dlZ1aJHr5HiredQBlNM/qPU3qYbAlpj9jPQy4TsapgCL3HSK3a9NkKDy1ONxp6/84TFa1JRRJ4DJ3IiWN+fy8xjgF0hMGfSLzHB0rWQu0Ld8z8qLQlISBNEWz+JOgTCZ8Lh5JLt7wyLcUyz1EbO1HIcEcvcZGT9hLwqn/x1sP22OZCrGK76czKXvPTBcuer11IWwoAqfa6q1XtMEoSfMqKbDv9Ga5pJ+wl3SK8AOdZsdYO53/rZhpJfSDRt8+n57jO+4NwsVU5C7Fwt3CCGamTj9GHmeEwJ1vV+kItvT0+zWNBnlM4gaO+tMc4La+0PXcKWcW2Z2kAfGUbNY7o0JQDw7BXuZgJPCXh3RtAi86ePy31GhWY1odz0vM55uKa3CJYa3BMDTV5F8NxY0w4Yl1Vs0hPSPRRksHIyw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Anshuman,

On Tue, Feb 24, 2026 at 10:41:38AM +0530, Anshuman Khandual wrote:
> Ahead of adding support for D128 pgtables, refactor places that print
> PTE values to use the new __PRIpte format specifier and __PRIpte_args()
> macro to prepare the argument(s). When using D128 pgtables in future,
> we can simply redefine __PRIpte and __PTIpte_args().
> 
> Besides there is also an assumption about pxd_val() being always capped
> at 'unsigned long long' size but that will not work for D128 pgtables.
> Just increase its size to u128 if the compiler supports via a separate
> data type pxdval_t which also defaults to existing 'unsigned long long'.
> 
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: David Hildenbrand <david@kernel.org>
> Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Cc: Mike Rapoport <rppt@kernel.org>
> Cc: linux-mm@kvack.org
> Cc: linux-kernel@vger.kernel.org
> Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
> ---
>  include/linux/pgtable.h |  5 +++++
>  mm/memory.c             | 29 +++++++++++++++++++----------
>  2 files changed, 24 insertions(+), 10 deletions(-)
> 
> diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
> index a50df42a893f..da17139a1279 100644
> --- a/include/linux/pgtable.h
> +++ b/include/linux/pgtable.h
> @@ -17,6 +17,11 @@
>  #include <asm-generic/pgtable_uffd.h>
>  #include <linux/page_table_check.h>
>  
> +#ifndef __PRIpte
> +#define __PRIpte		"016llx"
> +#define __PRIpte_args(val)	((u64)val)
> +#endif
> +
>  #if 5 - defined(__PAGETABLE_P4D_FOLDED) - defined(__PAGETABLE_PUD_FOLDED) - \
>  	defined(__PAGETABLE_PMD_FOLDED) != CONFIG_PGTABLE_LEVELS
>  #error CONFIG_PGTABLE_LEVELS is not consistent with __PAGETABLE_{P4D,PUD,PMD}_FOLDED
> diff --git a/mm/memory.c b/mm/memory.c
> index 07778814b4a8..cfc3077fc52f 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -532,9 +532,15 @@ static bool is_bad_page_map_ratelimited(void)
>  	return false;
>  }
>  
> +#ifdef __SIZEOF_INT128__
> +	typedef u128 pxdval_t;

I don't think the typedef should be indented.

> +#else
> +	typedef unsigned long long pxdval_t;
> +#endif

Don't we want this in, say, include/linux/pgtable.h?

-- 
Sincerely yours,
Mike.

