Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9F509FEA839
	for <linux-mm@archiver.kernel.org>; Wed, 25 Mar 2026 09:55:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CD7EF6B008C; Wed, 25 Mar 2026 05:55:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C8E0E6B0092; Wed, 25 Mar 2026 05:55:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B778A6B0093; Wed, 25 Mar 2026 05:55:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A6AB26B008C
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 05:55:33 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 5249EBAEBD
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 09:55:33 +0000 (UTC)
X-FDA: 84584128146.08.A847AEB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id 675E0160002
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 09:55:31 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=imBvzxX9;
	spf=pass (imf08.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=imBvzxX9;
	spf=pass (imf08.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774432531; a=rsa-sha256;
	cv=none;
	b=4uH1fDS3N4I0x3+Z3t/hnIrVoSxcbXDOv/cOP/b+PgMPVJoAO3Ol9mclkm8KyRJvhI8uk5
	O3I+Am7gKwlyIWwKjMHIMydqGMJJd8UPCmCbMk4/MxBprx/Y8Mnxi+VAb/vyLQ8a1Oqqbp
	tSquPvD9DnYhrwcDAT3RQEMgP5n4EoU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774432531;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=H7vJC7UCokahSY6oGz+pBo6t4W8MPgVxZKg0ZaMQp0I=;
	b=N6SG5vO91lbSTLua/UAWmxO1ZDo8CadPhcKxG8b7peNtyg0bTx9iHRsFqnKesK2tDQfZso
	JIP7nNdPvpOI4xPhY2xoPyikvzY0mOBx7gv1LGhcWvob+cJxmYzFM96EytzgnRgpwS0FFt
	o2JG5yfJGw1WYo+nwjzuSlgLEMPPubU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 6485043345;
	Wed, 25 Mar 2026 09:55:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09D20C4CEF7;
	Wed, 25 Mar 2026 09:55:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774432530;
	bh=9SU+G1pzNfkJYWyyJavSVZlDryVqXa7NO/5Yp1+Hwuw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=imBvzxX9+0+DnwBNDpet8fwln6JuraH8UeljdObUd/dreDGMpuVgki8GeZzzgA0ZH
	 UEEHqQjM5U224ArxpDQG887GBml3c6f2iUD/NMT3IGXrr0NyWJ/HKXxSjaONu1/BY6
	 MpNC+qIVdA6Cpxm18N8FeJe8hHeJL+S0Mhr/+C94T//PXLsSQruYgfnb/qUwKPZFs5
	 nAOdvVFm4risE9RhLWvnNsAblgkSRqz+4Ag+TeUglGR/y/J1hLhB+6+StjGhdpE47F
	 SB5PEOKIc7sLFnTTVUf/+K1+x8sbYVgZjGuwCK2Gs/KxDlcSjel2O5nE2ef+qpPWT8
	 shCfc/A8KpMow==
Message-ID: <44dd86c0-1845-4dd9-b4b4-2cef6d1c6357@kernel.org>
Date: Wed, 25 Mar 2026 10:55:23 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 1/2] mm: make lazy MMU mode context-aware
To: Alexander Gordeev <agordeev@linux.ibm.com>,
 Kevin Brodsky <kevin.brodsky@arm.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
 Heiko Carstens <hca@linux.ibm.com>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Vasily Gorbik <gor@linux.ibm.com>
Cc: linux-s390@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <cover.1774420056.git.agordeev@linux.ibm.com>
 <de89fd353a8dcd5e3bef4d91e9b6682d132ed9a0.1774420057.git.agordeev@linux.ibm.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <de89fd353a8dcd5e3bef4d91e9b6682d132ed9a0.1774420057.git.agordeev@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 675E0160002
X-Stat-Signature: xz8mnzu6rgepjcuqiyoshoboapbdugjz
X-Rspam-User: 
X-HE-Tag: 1774432531-201287
X-HE-Meta: U2FsdGVkX1+1iz0hQ0zpROw5RCtuU92QXMYOfVFFHEcrANs72kusgi3RHhT/wtbO3YoDEhMPXKqeVfCmR2dGnZa0SY1XCCadR5kMpJox2JmJdY+WFoPAI9XXPgVDyzFT7RKOE5avkXcMbm+HhnqzSJXdaurf4146zIcmA2X006oJh8GSu8EIVuu2y16dPmMu/BAUaSG8/MozCTmSRdKJGTJQxUhSpGJAyp6gzu0g+4IwO4K/iV1OLa4ArY3AEN3dn1Vy4wFBK09DKiHe8ouIGZwWC5JQX1OT/d97tqDl9l8ydQ/gRvLnmpsJXDRUOmit8AcxLcRJfWXRGzUiteJKja8qTDNzXIUHb2LSQ/1tqOO6GhsznNhg2HhxQW77DP86WXMa36DvIzDd9LAZEpKgGls01MkkRGFxUWO9RWbD205pUGamd6xw8Wrr6ewoj1zWfJ44ptXcXOjWmoXNAXz1G83GDPUbnQfRqKJI3Ibg9QDPOo6CxukmHfcZlAV2ncYMr0uQ7M5j/i2FFxvWN5uS2q1FAe6doltEJQW5X2oX6vrS5Q6C8DQF8ObTXCwTGLx9tXrC0KTG0FkemiFCE/59HYEq0p6DCdc4fDGax4Nx8Tb6+iUghZ91NroB0uKL8clO2nPoxUasf8Ud+sKdBcnje8Ln5UIlB/PbemYIToctwtV1V6t/G2BBry8nnyJzOwDJNULtEIE85bpYQADJR7YQDGtWhmIJaluNyIj3ROkneqttpIjqL/sIsXuv1QsbrateZSAnM6Y5N4RvCuFP0q3nFochGzqs4eQyXGBM/rR2Hna9un+y5plKS+/XSNBSQHxg4gU3TrAPfI3JmVX0viMigLPTEPZ3+fUSCffDQKr80u98pVoTJcYWms7IYKD0YSjZ60e1OoPZmLG7aMRLdaQ+JCVzNaq+ZMmVR6kAnzsNA3Zyi5CvUWS5Apj6B03A90P6vUGuBzBmvD9G1oPcjCd
 HxgYKRjL
 gz/yBOBWd3TypXdFP2PSk+tZiRrxlS/aP8pM03kREp0wufxkSHZhMFMjzOSZTTGLO0FLp5bnjrLDtLHlVJAn55TaJwZNHFLwFRDQCoTqSyh/A6/Ojtg0jnefjF5/X7LUpwHbWOOaGQRReNKcOL6KmkB7cDBIZOF1evoh5GRR8zQj4ht6q055cqAjgJUhdxfO1lSHZsaJPTp1GrMboEoSkrpz27GLCGw1VyZjT9Wxr+AbJAeNSDYfHkuk0AyO/GKZF+0JrHfS43fKI06eL4ciUJLsIPbbxd39rhyCshbBWA4M4YR2LHNrN8FFBM0v6RPjfs4kY
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/25/26 08:41, Alexander Gordeev wrote:
> Lazy MMU mode is assumed to be context-independent, in the sense
> that it does not need any additional information while operating.
> However, the s390 architecture benefits from knowing the exact
> page table entries being modified.
> 
> Introduce lazy_mmu_mode_enable_pte(), which is provided with the
> process address space and the page table being operated on. This
> information is required to enable s390-specific optimizations.
> 
> The function takes parameters that are typically passed to page-
> table level walkers, which implies that the span of PTE entries
> never crosses a page table boundary.
> 
> Architectures that do not require such information simply do not
> need to define the arch_enter_lazy_mmu_mode_pte() callback.
> 
> Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
> ---
>  fs/proc/task_mmu.c      |  2 +-
>  include/linux/pgtable.h | 42 +++++++++++++++++++++++++++++++++++++++++
>  mm/madvise.c            |  8 ++++----
>  mm/memory.c             |  8 ++++----
>  mm/mprotect.c           |  2 +-
>  mm/mremap.c             |  2 +-
>  mm/vmalloc.c            |  6 +++---
>  7 files changed, 56 insertions(+), 14 deletions(-)
> 
> diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
> index e091931d7ca1..4e3b1987874a 100644
> --- a/fs/proc/task_mmu.c
> +++ b/fs/proc/task_mmu.c
> @@ -2752,7 +2752,7 @@ static int pagemap_scan_pmd_entry(pmd_t *pmd, unsigned long start,
>  		return 0;
>  	}
>  
> -	lazy_mmu_mode_enable();
> +	lazy_mmu_mode_enable_pte(vma->vm_mm, start, end, start_pte);
>  
>  	if ((p->arg.flags & PM_SCAN_WP_MATCHING) && !p->vec_out) {
>  		/* Fast path for performing exclusive WP */
> diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
> index a50df42a893f..481b45954800 100644
> --- a/include/linux/pgtable.h
> +++ b/include/linux/pgtable.h
> @@ -271,6 +271,44 @@ static inline void lazy_mmu_mode_enable(void)
>  		arch_enter_lazy_mmu_mode();
>  }
>  
> +#ifndef arch_enter_lazy_mmu_mode_pte
> +static inline void arch_enter_lazy_mmu_mode_pte(struct mm_struct *mm,
> +						unsigned long addr,
> +						unsigned long end,
> +						pte_t *ptep)

Two tab alignment please. (applies to other things hwere as well)

> +{
> +	arch_enter_lazy_mmu_mode();
> +}
> +#endif
> +
> +/**
> + * lazy_mmu_mode_enable_pte() - Enable the lazy MMU mode with parameters

You have to be a lot clearer about implications. For example, what
happens if we would bail out and not process all ptes? What are the
exact semantics.

> + *
> + * Enters a new lazy MMU mode section; if the mode was not already enabled,
> + * enables it and calls arch_enter_lazy_mmu_mode_pte().
> + *
> + * Must be paired with a call to lazy_mmu_mode_disable().
> + *
> + * Has no effect if called:
> + * - While paused - see lazy_mmu_mode_pause()
> + * - In interrupt context
> + */
> +static inline void lazy_mmu_mode_enable_pte(struct mm_struct *mm,
> +					    unsigned long addr,
> +					    unsigned long end,
> +					    pte_t *ptep)

It can be multiple ptes, so should this be some kind of "pte_range"/

lazy_mmu_mode_enable_for_pte_range()

A bit mouthful but clearer.

> +{
> +	struct lazy_mmu_state *state = &current->lazy_mmu_state;
> +
> +	if (in_interrupt() || state->pause_count > 0)
> +		return;
> +
> +	VM_WARN_ON_ONCE(state->enable_count == U8_MAX);
> +
> +	if (state->enable_count++ == 0)
> +		arch_enter_lazy_mmu_mode_pte(mm, addr, end, ptep);
> +}

I'm wondering whether that could instead be some optional interface that
we trigger after the lazy_mmu_mode_enable. But looking at
lazy_mmu_mode_enable() users, there don't seem to be cases where we
would process multiple different ranges under a single enable() call, right?

-- 
Cheers,

David

