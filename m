Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1BF16606A33C
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 15:07:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=EvQQp3du
Received: by kanga.kvack.org (Postfix)
	id 40F4A6B05CA; Tue, 10 Nov 2026 10:07:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3E6016B05D4; Tue, 10 Nov 2026 10:07:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2FBB06B05D5; Tue, 10 Nov 2026 10:07:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 033CE6B05CA
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 10:07:09 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 8C3F71C4267
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 15:07:08 +0000 (UTC)
X-FDA: 85419537336.23.89558A4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id AEDB2120019
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 15:07:06 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EvQQp3du;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794323227;
	b=WQ+aUAI7NKkZDgcr2gauFDrES+MyQPbAesK3To9rywT9Y4Y2QKShByA+ohwZjzP1RyRM+S
	WIRjO+GNIBO9xV9pMxCpdRPxAVvNO7R1qQ+wUqon1BnINhHgkRSUIf4YIz1+ERo4++IOzf
	rjROYA+cMyj0V5HTE7yqH9yke0VZGAY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794323227;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3fnjfujQ/pzlwEGTHqO6MVLdM4zSJpqzQo1FTTutvu0=;
	b=MkTpVv4NSy2Nmxp/n+snyWKYx1UlpZfqN29D5GdmMEayKs6KFx4oiWoQ6GwGR0iOuaHfeg
	Y2RAiheUFRfdL34UOez90v8F84XOUkW/nWYQ9x4c11sgs+9xZfQgdLo5RJazZNZgOt+Zi2
	MzuS28e/XvbyAZXAbDjxRn8ibY3KlLo=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EvQQp3du;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id EA29B417DF;
	Tue, 10 Nov 2026 15:07:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 097EE1F0089F;
	Tue, 10 Nov 2026 15:07:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794323225;
	bh=3fnjfujQ/pzlwEGTHqO6MVLdM4zSJpqzQo1FTTutvu0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=EvQQp3duvHQl6jDz5kOlsTmP08H/wuHF5yTsADpur58rOhzYTHwx/0MyO8PkLd6Cx
	 NEYAMPMQy18BPZperR1LssjjyHjqm72z9DYiLM1M0y8Qyzry60CcYsbcCS3KIsaJBB
	 MJIkmJ9YDXFgAVaCl7MrfZVnmC20DZHNW2uHbx+l0AYzBXSAgD7yBhpSk311ewXeCZ
	 lEw8M0EhNlQoBsSZ5kcQhsfGZUxMnCtAegkOfqDsthAkHA9kN1Tio4G3VhU3UMbzzY
	 6nChIB7vKDdkXv0mTBCq/YRroxhgr+FQVaTYkjSY1HgWZgViqY8sucXoN4B7mx7ttN
	 rDGdYdpEscetQ==
Date: Tue, 10 Nov 2026 15:06:58 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Shivank Garg <shivankg@amd.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Ankur Arora <ankur.a.arora@oracle.com>, Pedro Falcato <pfalcato@suse.de>, 
	Peter Zijlstra <peterz@infradead.org>, Borislav Petkov <bp@alien8.de>, Bharata B Rao <bharata@amd.com>, 
	Hrushikesh Salunke <hsalunke@amd.com>, K Prateek Nayak <kprateek.nayak@amd.com>, x86@kernel.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] mm/memory: drop PROCESS_PAGES_NON_PREEMPT_BATCH
Message-ID: <avMxawZfHRAqgKA4@gremlin>
References: <20261109-clear-pages-batch-v3-1-6693efe18dff@amd.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261109-clear-pages-batch-v3-1-6693efe18dff@amd.com>
X-Rspamd-Queue-Id: AEDB2120019
X-Rspamd-Server: rspam12
X-Stat-Signature: pjewuzoc5x5793dfsmpzynjmg8yfmwwm
X-Rspam-User:
X-Spam-Status: No, score=-20.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794323226-562971
X-HE-Meta: U2FsdGVkX1+QWdY5n5i72Uv2S9enKl+lZVNaD41TZ99h0islXkNFn8D5PljEncFiOgDYlzsBm/3UH1IMoD2fkWqQsFNHuwlXgh8G/FftIjtI3pAi2UGoYLotGlV7NbPFhcDPjble4LgkdO1UlUHRDbS713rGMrAmlN9eyAgEBs+AsL+D2e0QPtFAaEi4Jcj3oNMXiM/VukAwNz/rNBLJ0YS4ogYi2qWRdrEFIWNIW1VNJBwPSksiFYyX6WCHnWRnhZ9D5aWQDoxApVLkp369a+dUfjJpolF5DAfwl2RMV8eXk4yp2SvgCZQK7oOzzX7kfTKPwnnJbS+L6UCZXmUhPsXxgt6m6QM2LWcJN0w2+97DWmT+MTkWB4/muBSTndjXgLJayPkOw/CmLNuRIDizf3sy/u+2K6wO8ijDR8cUUymcW72gHOfRmIxwyNjiCLG4q5NrFY8efl6IMWXz+9HziEzuXBUdfkJgeO4z8xrNkXxVGY0U1sfSKoQbvIKUTx4R0fTSlYwTgRamFb45QsyW81FSOs96+FQhnSAXz25/JqOwpl7G1kDl2jTCE9moTgnXWu21iHrO1KjvN/dGvx/QkHzNDkkkYkk48eCdELjO8ENg0JRA/V8Wh9n10uR+V1SO0hf8l/Ycc/QCz5KAQd/VD673IfUeAfadxQhevRwWsepoq5tOqgQfHotiVrgtY95Oz6Ux1qidRztIr4k3icYXr3R5+fogh+s69GM/NnPK00/H2SJDj5duLTZrS3bVurdlezV/+v8SrKElCmTUd+LLc38tl1GnQsMJfiOBWEr0psJh8gnXUh/SlvEweXC5Orhwq8p6W0OoLBcCBWZPxs69BXiBImRfpi12s+UPKvnmM/cDo3ddmgeopw3X9mgWgflRTdO1/gX4S0tCrQjdzQrPG8Qzpw9s6f70Eg4ZavbqYchnsbtjG/R702JdJGq9yoQJkl3kSqdgvBeT/Lqm8PB
 qsO85ReX
 /e6E9lmKm+NP0MWZuYsCaoEkaG23idCSeM0jVaR5nHnwV1AczMxI+AOAMA5x1In8DpXrv/n+QosSjukP15odrsDGGkWMYjKP2xSYwIxFzMa4dVcaIuVdQJlKYVOICbqhmfQrZZK8I7CWvWrB4Gy7akRVGxyoXvsiPTRtctid7d3CKtjdY0IEQvaijDFjNml8DCCDLU/tizdu3h1tOJxGVS/0F107DhvIy/tiU1BFYDS3r66V1QuEbl7et0dQppVHVbeJXLUbYot4u11mMBnydegtcDpskSqkgTzvsRpEloKbNfQ4Jt6Q/Dsg8nLgnkMggU2S751Fh5cGOrbWlr3/h0nVgYip21t0/sHtrPf6ZTQNX+H26v73yc8/UAzrtNYlt0YINw61mWwqOft5dRFOloAqjJfLQFveFUUVraq09JVt+bpA4ZqNNRX3KPja8IDxOcPyhzHVYn2YhmvyhYEj7JeBIv/72C36zBmKAqdUeifaI7Nq4gte4VQ+pfw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Nov 09, 2026 at 07:15:51PM +0000, Shivank Garg wrote:
> clear_contig_highpages() clears the whole range at once under
> preemptible models. Otherwise it clears PROCESS_PAGES_NON_PREEMPT_BATCH
> pages at a time, with a cond_resched() in between. The batch is 32MB if
> the architecture defines clear_pages(), and one page otherwise.
>
> Since commit 7dadeaa6e851 ("sched: Further restrict the preemption
> modes"), architectures that support lazy preemption only offer the
> full, lazy and RT preemption models, also with PREEMPT_DYNAMIC. x86 is
> one of them, and it is the only architecture that defines
> clear_pages(). So the 32MB batch is never used: whenever
> clear_contig_highpages() runs under a cooperative model, the batch is
> one page.
>
> Make that explicit. Clear the whole range when CONFIG_PREEMPTION is
> set, and one page at a time with cond_resched() in between otherwise.
> Drop PROCESS_PAGES_NON_PREEMPT_BATCH, which has no other users.
>
> PREEMPT_DYNAMIC kernels also have CONFIG_PREEMPTION set, and
> cond_resched() does nothing on any of these kernels. So a build-time
> CONFIG_PREEMPTION check is enough, and preempt_model_preemptible() is
> not needed.
>
> No functional change intended.
>
> Suggested-by: David Hildenbrand <david@kernel.org>
> Reviewed-by: Pedro Falcato <pfalcato@suse.de>
> Signed-off-by: Shivank Garg <shivankg@amd.com>

Nice cleanup! LGTM so:

Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

> ---
> This came up in review of the copy_mc_highpages() series [1]. Pedro
> pointed out that most architecture run with full or lazy preempt, so mm
> does not need to check the preemption model at runtime or batch the copy
> for cond_resched(), and a simple per-page fallback is enough for
> non-preemptible models.
> David suggested doing the same for the zeroing path, and this patch
> does that.
>
> [1] https://lore.kernel.org/all/20261019-batpagecopy-v2-1-d75e7d0dfaae@amd.com
> ---
> Changes in v3:
> - Use clear_user_highpage() in the per-page loop (Pedro).
> - rebase on mm/core.git/for-next.
> - Link to v2: https://lore.kernel.org/r/20261109-clear-pages-batch-v2-1-2e62c4f84f94@amd.com
>
> Changes in v2:
> - Rebased on mm/linux.git/for-next, and drop RFC tag.
> - Link to v1: https://lore.kernel.org/r/20261022-clear-pages-batch-v1-1-13d3bd0b876e@amd.com
> ---
>  include/linux/mm.h | 28 +---------------------------
>  mm/memory.c        | 29 ++++++++++++++++-------------
>  2 files changed, 17 insertions(+), 40 deletions(-)
>
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index e6da76fbe8e8..8d14e45fcf24 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -5250,7 +5250,7 @@ static inline void clear_page_guard(struct zone *zone, struct page *page,
>   *
>   * When running under preemptible models this is not a problem. Under
>   * cooperatively scheduled models, however, the caller is expected to
> - * limit @npages to no more than PROCESS_PAGES_NON_PREEMPT_BATCH.
> + * clear one page at a time and call cond_resched() in between.
>   */
>  static inline void clear_pages(void *addr, unsigned int npages)
>  {
> @@ -5261,32 +5261,6 @@ static inline void clear_pages(void *addr, unsigned int npages)
>  }
>  #endif
>
> -#ifndef PROCESS_PAGES_NON_PREEMPT_BATCH
> -#ifdef clear_pages
> -/*
> - * The architecture defines clear_pages(), and we assume that it is
> - * generally "fast". So choose a batch size large enough to allow the processor
> - * headroom for optimizing the operation and yet small enough that we see
> - * reasonable preemption latency for when this optimization is not possible
> - * (ex. slow microarchitectures, memory bandwidth saturation.)
> - *
> - * With a value of 32MB and assuming a memory bandwidth of ~10GBps, this should
> - * result in worst case preemption latency of around 3ms when clearing pages.
> - *
> - * (See comment above clear_pages() for why preemption latency is a concern
> - * here.)
> - */
> -#define PROCESS_PAGES_NON_PREEMPT_BATCH		(SZ_32M >> PAGE_SHIFT)
> -#else /* !clear_pages */
> -/*
> - * The architecture does not provide a clear_pages() implementation. Assume
> - * that clear_page() -- which clear_pages() will fallback to -- is relatively
> - * slow and choose a small value for PROCESS_PAGES_NON_PREEMPT_BATCH.
> - */
> -#define PROCESS_PAGES_NON_PREEMPT_BATCH		1
> -#endif
> -#endif
> -

Nice to remove this :)

>  #ifdef __HAVE_ARCH_GATE_AREA
>  extern struct vm_area_struct *get_gate_vma(struct mm_struct *mm);
>  extern int in_gate_area_no_mm(unsigned long addr);
> diff --git a/mm/memory.c b/mm/memory.c
> index c9d64170e47a..fcc7ea2a00d1 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -7650,27 +7650,30 @@ static inline int process_huge_page(
>  }
>
>  static void clear_contig_highpages(struct page *page, unsigned long addr,
> -				   unsigned int nr_pages)
> +		unsigned int nr_pages)
>  {
> -	unsigned int i, count;
> +	unsigned int i;
> +
> +	might_sleep();
> +
>  	/*
>  	 * When clearing we want to operate on the largest extent possible to
>  	 * allow for architecture specific extent based optimizations.
>  	 *
> -	 * However, since clear_user_highpages() (and primitives clear_user_pages(),
> -	 * clear_pages()), do not call cond_resched(), limit the unit size when
> -	 * running under non-preemptible scheduling models.
> +	 * clear_user_highpages() (and primitives clear_user_pages(),
> +	 * clear_pages()) do not call cond_resched(). That is fine on
> +	 * preemptible kernels, where the scheduler can preempt the clearing
> +	 * at any point, so clear the whole range at once. Otherwise, clear
> +	 * one page at a time and reschedule in between.
>  	 */
> -	const unsigned int unit = preempt_model_preemptible() ?
> -				   nr_pages : PROCESS_PAGES_NON_PREEMPT_BATCH;
> -
> -	might_sleep();
> +	if (IS_ENABLED(CONFIG_PREEMPTION)) {
> +		clear_user_highpages(page, addr, nr_pages);
> +		return;
> +	}
>
> -	for (i = 0; i < nr_pages; i += count) {
> +	for (i = 0; i < nr_pages; i++) {
>  		cond_resched();
> -
> -		count = min(unit, nr_pages - i);
> -		clear_user_highpages(page + i, addr + i * PAGE_SIZE, count);
> +		clear_user_highpage(page + i, addr + i * PAGE_SIZE);
>  	}

Very lovely :)

>  }
>
>
> ---
> base-commit: 2683df3b7eac1d91380194955ad0c9751454610c
> change-id: 20261021-clear-pages-batch-77f72ef808e4
>
> Best regards,
> --
> Shivank Garg <shivankg@amd.com>
>

--
Cheers, Lorenzo

