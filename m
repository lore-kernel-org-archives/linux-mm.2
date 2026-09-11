Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 16908C88E4D
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 19:44:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3D1BD6B00B2; Fri, 11 Sep 2026 15:44:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3AA396B00B3; Fri, 11 Sep 2026 15:44:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2B0836B00B4; Fri, 11 Sep 2026 15:44:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0E8126B00B2
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 15:44:48 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 7DFFCA45E0
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 19:44:47 +0000 (UTC)
X-FDA: 85202509014.18.0AECEDC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id E301140004
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 19:44:45 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=icT4G9Ac;
	spf=pass (imf07.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789155885;
	b=sPzULv09M1ZUZiFiRh0ESHdhWnfV1FDEn8deh4fxtJKa17SjYS8AkgCURwaed37x/dbaic
	i6Fzupc5XQs1r6xqlMCtnrY5NB9xMwfTVV/M2i/GTWE0zzUyef8hnHEvd1l3pwPGRJ6cM3
	Aev2YyCMF0SkMbHSRBdEish+lj7AaZc=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=icT4G9Ac;
	spf=pass (imf07.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789155885;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5OcUSagNaUBhj4BbAAxcxYgxkiEGrm2ed7kX7n6+jgk=;
	b=cMIwfeXtHC6khXOI1LO5SOMcDP41nuoQLks8hlwIUFpFN/Rtw24V125XwxBGK5/Y9VRzsG
	bBYydXseGpFMjo71V4WKHBqMpdTuvSYfbh2b1PCqFW6+w5vhn907xv5bv+aK6/JPxarNZN
	vBmn8R5TPFms06aSdcqgRNvuYdkeWVc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1A45641AE0;
	Fri, 11 Sep 2026 19:44:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E08531F000FF;
	Fri, 11 Sep 2026 19:44:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789155885;
	bh=5OcUSagNaUBhj4BbAAxcxYgxkiEGrm2ed7kX7n6+jgk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=icT4G9AcYaLezGUDQHBa5NegYm9Q04ZyBGRpaB3aGsWpZG6wHHm9v7eVkCBpf9P1D
	 BRIRFQ3nWYw48L0IXBXSfNsWrJC2HWmtReplQb8Bi0GGS6WlXdzP40UtIeJuIbfDV8
	 bp3Q32x0FXWFgUt3qxXONTpNjJCocjchBgQxp+Pg1HizPgWRaRRXSeK/5qs6Qv0khm
	 FWuvjs55cBAl6FXVh/FWfGXF7ZLZL6Ls6/Xf72D/FNbNXCojINU9RH1IjCewhIMPu4
	 41951JspIbSRFYq7lj7mmO1C+q43ZdQjw39QoGAVNSecd0O+X2xQ1FjzhWa7M42hWC
	 a05jWq/SgCdXQ==
Date: Fri, 11 Sep 2026 20:44:39 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Suren Baghdasaryan <surenb@google.com>
Cc: akpm@linux-foundation.org, liam@infradead.org, vbabka@kernel.org, 
	david@kernel.org, willy@infradead.org, jannh@google.com, paulmck@kernel.org, 
	pfalcato@suse.de, xueyuan.chen21@gmail.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v4 3/7] proc/task_mmu: clarify shmem mapping walk
 conditions in smap_gather_stats()
Message-ID: <aqRZ6xPaNLAGgbXk@gremlin>
References: <20260911194145.1781926-1-surenb@google.com>
 <20260911194145.1781926-4-surenb@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260911194145.1781926-4-surenb@google.com>
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: E301140004
X-Stat-Signature: yxzee64xhgr9oza6ndpy7ugqobbga54n
X-HE-Tag: 1789155885-243128
X-HE-Meta: U2FsdGVkX1/R8WxGVcBKCew7jf35mD6huYBsNYzSPjgMynK0B0QRCx795ryK0U5Or3xusO/gXp3IEGEiv0FjeAFFAlHLy2uMoC/NdjtGhoE8TNORTVUxnQH5ByyQQ28aj46Cz6THXOLqTRBMkjTev2kKic7xDtD/FR+quk6F/iqlOxr0HLtnOYVe/D4+enwnkML9MtMK/EO0Fq68g5SCQHgAFfNOFQ3yClU0ddinWyQg3MEnF+MyzOXl38Cl6Wug/loOMlydzVLUOL+Gc1xaHpZ9sdVNTOWkRGABfxVNZheDOug0WMrgCoMlmb0JiBSBFEM3NpIb2We7bL0d7MWUiuIckGPsOTtf3TlyKVQXyRXqqKO1Y5uV6VPvG64+KMwX/RAhKQr4d5o9F7wKiWtrJ48qcnCNl9oXtFTOVJG7gtrNBhfgo+Zy9kVEs11I9xnuyA5n+N/Xvmhe5Xz8WZNdLj9Q87qU3dieaAl4mBaEM6M3y05MNHnGWAmVcWNo+d+zFv6f+KtMiuuO6cPNCIM/jBw4tgbaKPPYaZY0AiHoP1as4ZSAslOxjos4bVVhCUX0Pxk3Ih4TqNHCImo4f3hiuzQkvcMCiSTYGvlka/pZ+qvTTl6UF5ns9AGZLOwGdvAyRQkJxJ0N1bUVD5PJFVo2UOcJ8QOoDCq+5kEmn1TfA3VdZyIGBadrF9irYNvS4vqLx2SIHKcbrpfqBeioPTQAfFQKOzDfZXRs+QRWTMZv2MzOx9cwD/HvlyeDIxaTbS/7IqxevVvF5pAMfe4wNhdJbE/6409ZrdWWx8G1xNNVYbMzuvW/a2pEPzCOP1CcOefKJ3saZmCqklHoGd0FQ9cfWPVsoW1lBEJJqQTqvrb08qQ1kNM/v0qB/D/dD1C5L7rzApiuuSJP2XCFB2aST8RjCBxs+AX6PJ7nKg2JO6OKvZ0hcbqJnjffpwVQMKJZOxSYzdHV/zFl2mslulE9jbc
 bzIuoBWM
 3+E1sShsCQWTGvLFjQazxX7LU0BV5L/FL1LfKUhPUl3XuUpxf8VR5LW4HRzysJSRmrfxC1qcqtXsHLjfQ0aOZEgP1NW8Z/wNhrkMZb+aSwYAIuFmzSDCbIfRfoeyodor+rNZEkXlhdZhdml3+j4xd8MPaD7vW+WypKcquR9Tx0LfA6FAzgkP01ZHKT3IvXFkd2uziiJCr7TVIA/iB6SQC/XbJ55gZyC1VTJMOUTRgdp6vS9Zeqo3YWxP1OlWB7jgzEZG6IDrHDrzkSbAkRD1x6zrZQu1SDsIa2GCjD69Xmcfed2CuuuLA4n+LRgyoFOU3vBdHVTBYYfo+/WbbvuYOMjcqgdp59ejuplyANMakaagId+WnzlOByTEgilMR0jGX2EgHtVGqa2dpesUJt61nqUYg5TVqJDhjopen8yp7cUPNfrs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 11, 2026 at 12:41:41PM -0700, Suren Baghdasaryan wrote:
> smap_gather_stats() optimizes stats gathering by skipping the walk for
> shmem mappings in certain conditions. Update the comment to clarify
> these conditions and use vma_is_cow_mapping() for CoW identification
> instead of open-coding it.
>
> No functional change intended.
>
> Suggested by: David Hildenbrand (Arm) <david@kernel.org>
> Signed-off-by: Suren Baghdasaryan <surenb@google.com>

LGTM so:

Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

> ---
>  fs/proc/task_mmu.c | 23 +++++++++--------------
>  1 file changed, 9 insertions(+), 14 deletions(-)
>
> diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
> index cfc7af1b551d..0e53eb065a3e 100644
> --- a/fs/proc/task_mmu.c
> +++ b/fs/proc/task_mmu.c
> @@ -1270,23 +1270,18 @@ static void smap_gather_stats(struct proc_maps_private *priv,
>
>  	if (vma->vm_file && shmem_mapping(vma->vm_file->f_mapping)) {
>  		/*
> -		 * For shared or readonly shmem mappings we know that all
> -		 * swapped out pages belong to the shmem object, and we can
> -		 * obtain the swap value much more efficiently. For private
> -		 * writable mappings, we might have COW pages that are
> -		 * not affected by the parent swapped out pages of the shmem
> -		 * object, so we have to distinguish them during the page walk.
> -		 * Unless we know that the shmem object (or the part mapped by
> -		 * our VMA) has no swapped out pages at all.
> +		 * CoW mappings might map anon folios that do not belong to
> +		 * shmem. Perform a less efficient page table walk in this
> +		 * situation, unless we know that the shmem object (or the
> +		 * part mapped by our VMA) has no swapped out pages at all.
>  		 */
> -		unsigned long shmem_swapped = shmem_swap_usage(vma);
> +		const unsigned long shmem_swapped = shmem_swap_usage(vma);
> +		const bool is_cow = vma_is_cow_mapping(vma);
>
> -		if (!start && (!shmem_swapped || (vma->vm_flags & VM_SHARED) ||
> -					!(vma->vm_flags & VM_WRITE))) {
> -			mss->swap += shmem_swapped;
> -		} else {
> +		if (start || (shmem_swapped && is_cow))
>  			ops = get_smaps_shmem_walk_ops(priv);
> -		}
> +		else
> +			mss->swap += shmem_swapped;
>  	}
>
>  	if (!start)
> --
> 2.55.0.1007.g17ff1f9808-goog
>

--
Cheers, Lorenzo

