Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C81B6C88E4D
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 16:28:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 87F826B008A; Fri, 11 Sep 2026 12:28:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 856B46B008C; Fri, 11 Sep 2026 12:28:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 793D86B0099; Fri, 11 Sep 2026 12:28:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4B71F6B008A
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 12:28:23 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 44FF31202A8
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 16:28:22 +0000 (UTC)
X-FDA: 85202014044.18.779370C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id AB5B6A000A
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 16:28:20 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JCTJZeai;
	spf=pass (imf15.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789144100;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FnYVewSH1HCSqZpF/ajuG7xvpdDrzWPlljC0TTqhOrs=;
	b=oiSJn90GeGEEPZ46bLIFlFpDsDLjK1sxNvwMmiOkkUjmVKjg8m9U1Lf3sGr98q3/YyIaEW
	4e87IEGFEp4g854Cqd4mI8SBzK9yCqJ9KgS4+prsGj40OAeQNuwyPYVJTk79icZ2dprBSd
	x54GI9l8F1TLUgO2IQ0rzmD9TrHlrCA=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JCTJZeai;
	spf=pass (imf15.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789144100;
	b=F97lkq/a7yzql2190+pCjidUEicW9B6wx7nV8fkYgHRG09AFlqI25tr9pSOaZeL0T+MHeO
	asXUYanjKMUBhHJdrtBViovSATOvXGs8orxbgMe2Z/kutXggU4Pscde47YqGWveoWKGySx
	bBJOhmEdp/YnptyallTTK+Y0hqd08Lg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 41D6F60008;
	Fri, 11 Sep 2026 16:28:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBAE01F000FF;
	Fri, 11 Sep 2026 16:28:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789144100;
	bh=FnYVewSH1HCSqZpF/ajuG7xvpdDrzWPlljC0TTqhOrs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=JCTJZeais1k7SJtwRXhrgSSr0A8El3HxjkRjWAgtr2p8twOGvppmDxre4GZu85XWc
	 64pKGLoVJ7KtwjplDqEXOk0qIeM4o1eyIXBbXuYn/jb70gL+UJVK9QwAJEGjVVa5wc
	 oAGLMRSpFkraFQ89d5tLaIjv+tUL7d5OZtZ2sPnk7PPqYzNfVEzujyVqP1kyf61EyM
	 RXL2y8XZecHntb0kXxOgZXWS6kJnHRnnSd7Ft4f941WyOTfEXBAK/JuhP6mignHG9u
	 Rn33iplVFhtcRAhcOTP8Ph580+9li8swYB2LTNJEw60L9BTO2LgVYUArc2H0iQVdc1
	 3AdOc7Z7S7c2g==
Date: Fri, 11 Sep 2026 17:28:14 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Suren Baghdasaryan <surenb@google.com>
Cc: akpm@linux-foundation.org, liam@infradead.org, vbabka@kernel.org, 
	david@redhat.com, willy@infradead.org, jannh@google.com, paulmck@kernel.org, 
	pfalcato@suse.de, xueyuan.chen21@gmail.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v3 3/7] proc/task_mmu: clarify shmem mapping walk
 conditions in smap_gather_stats()
Message-ID: <aqQoPTTUC9M5HkYb@gremlin>
References: <20260910234737.1340642-1-surenb@google.com>
 <20260910234737.1340642-4-surenb@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260910234737.1340642-4-surenb@google.com>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: AB5B6A000A
X-Stat-Signature: quhpqk3fphohwnw4p9mojbytduyauf5m
X-Rspam-User: 
X-HE-Tag: 1789144100-880809
X-HE-Meta: U2FsdGVkX18HZfJgONq/G1z1jfIf0aofglAf67d3FXOSRJuYNF6d0BnR6UgbGWJEMNRV2IjtvKbADqr/ckvekbTGwx2x+KOGZePwjFhPJvNhpC5XYhv2MoTidMd2j0cB/wBqvx9q7sERGyVmPruTuOeo2gbbqXx9kGxCd7m+wLCF9/3Iik/7dExQ/tDbdShJ20CkhKVOkGrWR7sby7L1g0qWxg+1KGLoFajeMV2pt7GqGEra/NImjxSbL6e+Mrv+ICtepIFnEvlyABebJS2ENMsd+76a2IXgd0ZHHjkM8PyNeTJwFKatAFLUxn9Y8lORNZLNeM8Y//46hKn9Zdp0+3yg2VY2nIfHYmsMBjJ4BB9tS3h4vTqbnANdLIaxJeG3xkqmrBX3ak39RZiDAUbS0xTrf0cOf8dP8ZW2BY4eWeTjfPuYVQrsdsXfiUGAczX2UlxPWPKsTF+jja6KzvT4CdYDzYe7HFl+PzqCwsMuh1j3tCNi8FFwFOaeiUzJ7Z3ct7kgoOno283dsbxt7+ou2iIoB/lvSky0Ss7dk5q1d+4Qu1aB+lT9n9Z5zxf0MJlmVOqEPgOzK18gp8e7TNRtjZwjMAzu/wdQw8S2WL+a9S1H35o1u1zu/KaQaD35uEBKTCt3ezHCUYhUB7EbAr6ER1B3qxRBjkfc69HKaVCk725nYWImyqL1FjJgGtTCpNXAcqq/cIVX3GVzmKgVBrqTsHm001wywitKVD4vcpA7R7PyQno/B+1lfAnSZopxVivv7lqnRbpNR7onrS5GVLuR3P0OEi7NzwkuQht3TfvA9ucXNZ1AV31WVdpKm/R1jRqR3mPIs7cszPXjiJAKyPDcYru/vyRmAnvoFJpFh8/SjBk4GYDvPBNRa9AOY9oWy9h7ThEd5QNu3drP0WBlzhk9NYBob8O7kC4G9Exk4pSiBIznhPwz368Mqd32LYX7o5joGhpwoSNSMuMOcr4TbC9
 eSGmOeXK
 850DnyEznUuR0om+NWAaGoZQ+5TM8jHQtq8s2iwhi5vZESsygVeRzbZUp3KVQ/NAYUnmHt5J0oZwLxAdoC6q5OY/yOvzD+JIACbPz7f7HzRGRtJhBWMdCaIGZSBLfUl+pMDDpyHcpd3TmEnsO0Z7PZvZGv3/0R9aYRsiW7u26RfFRjcl0uSqYVrDPrJQx9o1RVP0zW6LTERwhffJq2HkHfN6GniByc9QU2Ic2kKSC0OkS+ih/8vCq2XneUM6cA4mqZ2Tt8SiC/5nvg8wI4DStzD36mprQNGxxHgeC3t2ABNJXxusgHO4vRn5Ji9iYsRrC3mF9lDJuNBrTDDECNbflkq+2ElQNPUNPRV7MTc3VUWsMxnoHWUFbJFhXkPJX6XOR696H4yRZyeHLufQVo6mEsrTTdE8M7iCPO6yuaHdexu8CHKc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 10, 2026 at 04:47:33PM -0700, Suren Baghdasaryan wrote:
> smap_gather_stats() optimizes stats gathering by skipping the walk for
> shmem mappings in certain conditions. Update the comment to clarify
> these conditions and use vma_is_cow_mapping() for COW identification
> instead of open-coding it.
> Instead of using (start != 0) condition to identify partial walks, use
> more semantically correct (start > vma->vm_start) check.

I don't agree what you're doing is semantically correct, it's a hack really.

Callers are passing start=0 to indicate that the entire VMA should be
processed and that happens to fulfil your criteria but in a surprising way.

And the start in these cases is corrupted.

>
> No functional change intended.
>
> Suggested by: David Hildenbrand (Arm) <david@kernel.org>
> Signed-off-by: Suren Baghdasaryan <surenb@google.com>
> ---
>  fs/proc/task_mmu.c | 24 ++++++++++--------------
>  1 file changed, 10 insertions(+), 14 deletions(-)
>
> diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
> index cfc7af1b551d..3c40c9cbb9c9 100644
> --- a/fs/proc/task_mmu.c
> +++ b/fs/proc/task_mmu.c
> @@ -1257,6 +1257,7 @@ static void smap_gather_stats(struct proc_maps_private *priv,
>  			      struct mem_size_stats *mss, unsigned long start)
>  {
>  	const struct mm_walk_ops *ops = get_smaps_walk_ops(priv);
> +	const bool is_partial = start > vma->vm_start;

Yeah not in love with this, without changing how it's called.

If you're reworking it all already, the actually semantically correct thing
I think would be to do something like:

static void smap_gather_stats_range(struct proc_maps_private *priv,
		struct vm_area_struct *vma, struct mem_size_stats *mss,
		unsigned long start)
{
	...
}

Then to drop a parameter in smap_gather_stats() like:

static void smap_gather_stats_range(struct proc_maps_private *priv,
		struct vm_area_struct *vma, struct mem_size_stats *mss)
{
	smap_gather_stats_range(priv, vma, mss, vma->vm_start);
}

And then you remove the hack and make is_partial not be accidentally true for an
invalid start parameter.

>
>  	/* Invalid start */
>  	if (start >= vma->vm_end)
> @@ -1270,23 +1271,18 @@ static void smap_gather_stats(struct proc_maps_private *priv,
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

Nice to see this helper naturally slot in to new stuff :)

>
> -		if (!start && (!shmem_swapped || (vma->vm_flags & VM_SHARED) ||
> -					!(vma->vm_flags & VM_WRITE))) {
> -			mss->swap += shmem_swapped;
> -		} else {
> +		if (is_partial || (shmem_swapped && is_cow))
>  			ops = get_smaps_shmem_walk_ops(priv);
> -		}
> +		else
> +			mss->swap += shmem_swapped;
>  	}
>
>  	if (!start)

Also not absolutely in love with the fact you only use is_partial above and
leave:

	if (!start)
		walk_page_vma(vma, ops, mss);
	else
		walk_page_range(vma->vm_mm, start, vma->vm_end, ops, mss);

As-is.

Should be:

	if (is_partial)
		walk_page_range(vma->vm_mm, start, vma->vm_end, ops, mss);
	else
		walk_page_vma(vma, ops, mss);

But I also wonder whether, with start not being corrupted (!) you could
just replace this with:

	walk_page_range_vma(vma, start, vma->vm_end, ops, mss);

Looking at the pagewalk.c implementations I don't know why
walk_page_range_vma() doesn't just forward [vma->vm_start, vma->vm_end) to
walk_page_range_vma()... but that's another thing :)

> --
> 2.55.0.1007.g17ff1f9808-goog
>

--
Cheers, Lorenzo

