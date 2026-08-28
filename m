Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 72331C61DBD
	for <linux-mm@archiver.kernel.org>; Fri, 28 Aug 2026 10:16:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 278CE6B008C; Fri, 28 Aug 2026 06:16:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 229A76B0092; Fri, 28 Aug 2026 06:16:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 140F26B0095; Fri, 28 Aug 2026 06:16:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E16ED6B008C
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 06:16:40 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 61659802BD
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 10:16:40 +0000 (UTC)
X-FDA: 85150274160.18.5D2E860
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 927F580002
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 10:16:38 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=j8RMXenG;
	spf=pass (imf02.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787912198;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IDNDGA/QN1kZCKHpcgE6g/Ng+sRR0OCsnBMk8IBkH5M=;
	b=St09pLOFUxwU2d6HNm9bV32BtyB2eboo6xhPBoRI9GzB5V3qo2O50j0ZPsLNZ5ryPwKG6I
	GaM5EyJn4oFlIs1IJBF+YR5vZTJ8V3f5gzKrJ4Jt0dWU88sK2Tbj73sfax4Q28hC0CERBL
	Gk6o2LXqsjOywiDnAb4KXQMQLIe+xPw=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=j8RMXenG;
	spf=pass (imf02.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787912198;
	b=CxNyybyaaLnQJQOtczm93Egc4/rai85x6GiKbl9zckUF/BQixzSkaH5dSffxEZQPzRyr5Q
	1LDtZT54lgPUPNKDdfAWtd1Ly8KmLyRgnWzasBUVL6OTiIHUiDJppWWKmGuJ2IytJeq9lS
	7g6QNzwP2Qh9cFyLfQLDlxW30Ha9gig=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B40EA402E6;
	Fri, 28 Aug 2026 10:16:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E8DB1F00A3A;
	Fri, 28 Aug 2026 10:16:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787912197;
	bh=IDNDGA/QN1kZCKHpcgE6g/Ng+sRR0OCsnBMk8IBkH5M=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=j8RMXenGB2gQNPG3vT/Qlw2fo1sD9YsGDD10XoJp1SaLD1SSldoNOenju912vj/Lv
	 y1HyOofWWmaPRUzhIwpzPSOq7Oe/qrwot5ZPEX5WCRroefzcv4ohqeg7Nv2Rs9JyfU
	 YDYC16GL+YNCD8HSkdg3C+/++c1liSLjowwnRbRpYVW5tMx3XC5MckHsmr8vk70QjZ
	 arXPoXFuRacQoEUnQ8zVh8N77xIpCM+PUNcC/nny5be4zJlytCRVimDK/o6ylN80wm
	 OX+0Wn0lRplLq4PO229v6TpN3ae9ocpUg+FXi3YmMLWcGAu9IolQVHgR4bh7Rondf/
	 alBQie2IXPt4Q==
Date: Fri, 28 Aug 2026 11:16:32 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Kunwu Chan <kunwu.chan@gmail.com>
Cc: akpm@linux-foundation.org, liam@infradead.org, vbabka@kernel.org, 
	jannh@google.com, pfalcato@suse.de, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] mm/mremap: fix locked_vm accounting for MREMAP_DONTUNMAP
Message-ID: <apFa2eTBzBP0RPeb@gremlin>
References: <20260828094823.594279-1-kunwu.chan@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260828094823.594279-1-kunwu.chan@linux.dev>
X-Stat-Signature: qukiunciwoer45jzxaax9ku5xthpwwsw
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 927F580002
X-Rspam-User: 
X-HE-Tag: 1787912198-541335
X-HE-Meta: U2FsdGVkX1+wXYxIv6Lxg1bBPVgtwYm7uPS8ri8fN0Pp1+5J0UaXNDNsM40Nm3fZMxQ++CUDH012OXMNFdKGgCEQ8wzaWfB2LmGsjCfuD2MF/Flnhbnque2CT7WVY+yKNqRSF434A5/tQFencWlWiW3X3QPDXFufxlfEdF8H2zWlSIuFmHgVReqgM21VS9+LiP2GK/CGklm/2dldMe6woTLnjatGzxEx7mQaKk95bbfxtSLR1L9lEPQC4pfNeb1zzpWnQk3YBHTukVp0/ZqwZtF67qft3h8ueAvAS6ujjj4SiRUBV2wJji7MWqhmPbTdKrcpmPRUSQ1aaNi7sOpWGdrJPOdlWtBUb/xEGARdkDGwhD6bNNyyKOVhCuA6MJrHwDw5Wa0K5QM6BJEKwJYmVk5CFI2NKq9OYCcKWqtdcpvGkuzw3d0nXCLZ6c1FDztzvXnukG4ae8sggfrq2tZtC88EeUmGUieJmYh9kmT4drWKFJm1KJdWBtI5qOqGPx3oocHi7dhSJ/AiVurw5y3mjEo1+1XN3mc03uzj5Yy9PRv/hRuigXkXTGYS7aEUafoTczOnCeISplimTomvkaFsu43+3zQ3k5u1PpzbY6xj5E5/wJhTc7+OOMmuDh77OauBtq85J7fqGlpBV0hfu2YqLgMHRHYgxb/P6b1gK+kMg/LggumzmHks6haOSK1iD4jlwWXFqaCt4iXTHqAJJKDqyLQ+dAbFIbZDYOlm5oXV1e7U2XRCkxi60PPai1/3AxpZfy1QH5MYB10Z8RMCk6GA6f8L/smXzglxE09DLjVBWYE3KlyHitHGgsxYogyimmE6WF9MwiivpeKVrVG/PedBUCu32iJesSxzPJ/cH3mBEv9KDPCdlbh4CYAfirbnzxrI2NhfTh7jS8D301VGD14HveaCsEjYAUEARS2I/9vs2/TarJChU9Ubp4iR7SlWe9WZLJZkmwrraU/JjP2SIom
 HQcyuasE
 7GqYmF/7n/uWRE1XCrRK8/Vhmxn79tVZWT82SvkXWcyZhjrSnRr3T0q3lt5M5PF1IcDYrI/+DH7HGTNUxs/0sQ5ubO7tWanWI50lWBF3MDvR8xYeuqjD2vkVzQixqPb8LT91Slcg79uHQ23a3+QowLFbuiVafnRJt8ULUe6S0SbGCI15pJDS5Vz67UAs2Si1jb2dMoI2yVCTIY2oPAeL+dLkD/Pt7Gt5M7+3JLwimmKXXw6ze+TuvpL/Zld9Nq+uR5SVlgnUe+aYUrpdCIZt/9lFTrUV1Rf/Tj7H+BTOY/KZJs9WMduryo5z7FuK/8WMQnZoZRXe/I7h5Fp+bVJ1hUbzmF2IMcrCDammdtpsXdJ9t62tRd/5CGavv+eruXb4u1+R7OzsCykhZW34mZ5nR+NJmtQr4jGkcRapCDyp2vbTmf/Lg/6NNgYhhyQhPBnKrUSZ8
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 28, 2026 at 05:48:22PM +0800, Kunwu Chan wrote:
> From: Kunwu Chan <kunwu.chan@gmail.com>
>
> When mremap() is called with MREMAP_DONTUNMAP on a locked VMA,
> vrm_stat_account() increments mm->locked_vm for the new VMA while the
> source VMA is still marked VM_LOCKED.
>
> For a normal mremap(), the source VMA is subsequently unmapped and the
> munmap path decrements mm->locked_vm, balancing this accounting.
>
> With MREMAP_DONTUNMAP, the source VMA is left in place and
> dontunmap_complete() clears VMA_LOCKED_MASK.  When the source VMA is
> subsequently unmapped, VMA_LOCKED_BIT is already clear, so the munmap
> path does not undo the increment from vrm_stat_account().  This leaves
> mm->locked_vm over-accounted.
>
> Undo the locked_vm increment in dontunmap_complete() before clearing
> VMA_LOCKED_MASK.  MREMAP_DONTUNMAP requires old_len == new_len, and
> only VMA_LOCKED_BIT is checked to match the accounting performed by
> vrm_stat_account().

Hmm I don't love this approach.

>
> Fixes: b714ccb02a76 ("mm/mremap: complete refactor of move_vma()")

Are you certain that my rework patch was what introduced it?

> Cc: stable@vger.kernel.org
> Signed-off-by: Kunwu Chan <kunwu.chan@gmail.com>

In general while the patch doesn't seem super AI-y I do see a sudden upswing in
patches from you in 2026 so I do have to ask whether LLMs were used? If so
please follow https://docs.kernel.org/process/coding-assistants.html

(I hate having to say these things but hey, it's 2026, so.)

I'm kind of inclined to do a fix myself a different way here.

Given it's going to be a backported patch and you're relatively new to mm, I
feel like this is the safer route, sorry about that.

Happy to add a Reported-by/Closes for this however.

> ---
>  mm/mremap.c | 10 ++++++++--
>  1 file changed, 8 insertions(+), 2 deletions(-)
>
> diff --git a/mm/mremap.c b/mm/mremap.c
> index e8df5cdb0ac..37ea5ee1986 100644
> --- a/mm/mremap.c
> +++ b/mm/mremap.c
> @@ -1334,6 +1334,14 @@ static void dontunmap_complete(struct vma_remap_struct *vrm,
>  	unsigned long old_start = vrm->vma->vm_start;
>  	unsigned long old_end = vrm->vma->vm_end;
>
> +	/*
> +	 * vrm_stat_account() accounted the new VMA while the source VMA
> +	 * was still locked.  Since DONTUNMAP leaves the source VMA in
> +	 * place after clearing VMA_LOCKED_MASK, undo that accounting here.
> +	 */
> +	if (vma_test(vrm->vma, VMA_LOCKED_BIT))
> +		vrm->vma->vm_mm->locked_vm -= vrm->old_len >> PAGE_SHIFT;
> +

I don't love this as an approach in general.

As above, I think I will address this slightly differently.

>  	/* We always clear VMA_LOCKED[ONFAULT]_BIT on the old VMA. */
>  	vma_clear_flags_mask(vrm->vma, VMA_LOCKED_MASK);
>
> @@ -1343,8 +1351,6 @@ static void dontunmap_complete(struct vma_remap_struct *vrm,
>  	 */
>  	if (new_vma != vrm->vma && start == old_start && end == old_end)
>  		unlink_anon_vmas(vrm->vma);
> -
> -	/* Because we won't unmap we don't need to touch locked_vm. */
>  }
>
>  static unsigned long move_vma(struct vma_remap_struct *vrm)
> --
> 2.43.0
>

--
Cheers, Lorenzo

