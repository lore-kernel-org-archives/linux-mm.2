Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2E967606A330
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 10:12:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=PwxPLG5U;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=7tbgkPtz;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=PwxPLG5U;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=7tbgkPtz
Received: by kanga.kvack.org (Postfix)
	id 56C7A6B05BA; Mon,  9 Nov 2026 05:12:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 545BE6B05BC; Mon,  9 Nov 2026 05:12:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4353F6B05BF; Mon,  9 Nov 2026 05:12:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1C4236B05BA
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 05:12:21 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B53ABA0641
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 10:12:20 +0000 (UTC)
X-FDA: 85415165640.10.6D6618D
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf21.hostedemail.com (Postfix) with ESMTP id 81B6E1C0006
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 10:12:18 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=PwxPLG5U;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=7tbgkPtz;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=PwxPLG5U;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=7tbgkPtz;
	spf=pass (imf21.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794219138;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CcNnVVf8GaxnGaipb5Ipmx75ZcIBQfMWDRTlKTdY4Y0=;
	b=DEjXv5QIrOFkg03aAF15CqtqBFiIlibGJY4ayoKjTqfuuULVrf+lkcNcaz56vtIg49juFg
	77FJI687M9PM2IX2Q3FsBsQa/1MPaalIBVeIjDAGgVKIWujUn1Vf+KTeUQcLYRhiXLsdjc
	ZRlZvrN9sNH4pCdPiWe5tDQqJiLZ3uo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794219138;
	b=AIz+o3niArSVU59kzN9CIC30tfLLd8rnftOO8OjYVhLUFbjzHLoAO2hfOSguBHk/kWqVU2
	P7B1/DguqkMT0BEPT8YcPe6cOoP9i9kEj/muF5dB1oIBE8UiSUTVy1j1GFuKGZF19re2ui
	JIh7pOF1N90J38osBDaq7tRLgXQfeNc=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=PwxPLG5U;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=7tbgkPtz;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=PwxPLG5U;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=7tbgkPtz;
	spf=pass (imf21.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 1F60821F99;
	Mon,  9 Nov 2026 10:12:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1794219137; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=CcNnVVf8GaxnGaipb5Ipmx75ZcIBQfMWDRTlKTdY4Y0=;
	b=PwxPLG5UHtTluzJwz9PeJgwQ1XCnDltU6H8jm39PKA8+7wwFU74rMssjdsBRKWsOrGIqWZ
	Mc8HVSiF/2fLR7zwbKBzgbWe76rMiJ5Kr9e+cbi0wjMqr9VOr/rCWVDztFcA6Ucm1uHv4B
	ASdH6bY1K0n7mY8IkCDXiX76LaJ+oDE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1794219137;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=CcNnVVf8GaxnGaipb5Ipmx75ZcIBQfMWDRTlKTdY4Y0=;
	b=7tbgkPtzYszADqt4XU0z2mqJfahPafpXMV3iiA9q1E6AJJnGZoXd9dgyd3znwiolmfKTnV
	kGvhHvYk/OpvvjDg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1794219137; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=CcNnVVf8GaxnGaipb5Ipmx75ZcIBQfMWDRTlKTdY4Y0=;
	b=PwxPLG5UHtTluzJwz9PeJgwQ1XCnDltU6H8jm39PKA8+7wwFU74rMssjdsBRKWsOrGIqWZ
	Mc8HVSiF/2fLR7zwbKBzgbWe76rMiJ5Kr9e+cbi0wjMqr9VOr/rCWVDztFcA6Ucm1uHv4B
	ASdH6bY1K0n7mY8IkCDXiX76LaJ+oDE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1794219137;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=CcNnVVf8GaxnGaipb5Ipmx75ZcIBQfMWDRTlKTdY4Y0=;
	b=7tbgkPtzYszADqt4XU0z2mqJfahPafpXMV3iiA9q1E6AJJnGZoXd9dgyd3znwiolmfKTnV
	kGvhHvYk/OpvvjDg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id D96F613319;
	Mon,  9 Nov 2026 10:12:15 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 0Q0dKX+c8WpKVwAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Mon, 09 Nov 2026 10:12:15 +0000
Date: Mon, 9 Nov 2026 10:12:14 +0000
From: Pedro Falcato <pfalcato@suse.de>
To: Shivank Garg <shivankg@amd.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Ankur Arora <ankur.a.arora@oracle.com>, 
	Peter Zijlstra <peterz@infradead.org>, Borislav Petkov <bp@alien8.de>, Bharata B Rao <bharata@amd.com>, 
	Hrushikesh Salunke <hsalunke@amd.com>, K Prateek Nayak <kprateek.nayak@amd.com>, x86@kernel.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] mm/memory: drop PROCESS_PAGES_NON_PREEMPT_BATCH
Message-ID: <avGbPpm3-Yrapry8@pedro-suse.tail5790ac.ts.net>
References: <20261109-clear-pages-batch-v2-1-2e62c4f84f94@amd.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261109-clear-pages-batch-v2-1-2e62c4f84f94@amd.com>
X-Spam-Level: 
X-Spam-Score: -13.30
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: 8j4suytdfddxsh4kyf4fs5ske9yokifa
X-Rspamd-Queue-Id: 81B6E1C0006
X-Rspam-User: 
X-HE-Tag: 1794219138-495415
X-HE-Meta: U2FsdGVkX19uifbOlNfCZK+KMNUzJDAFiFfd6zI+noq5xj8UxRuS37snGoNFdWzIDWGWJ/5mTBE3BwDPe3ZyVRQCUZteaahnA0nz2CPtZ0x7BYquQ/RAkadnh8uieI6NA31/7f9glLI1mzLpqH7n1ByWRY8Y7L4X2WT+HprsR01GDyyEnOrfVxfVgjvwJplX3w1/lc+NUTP3ykRrDNuY+dUvrW1NZl01YytY7tgp+YGG3cnlfbYsbZxenXMh/t2TDCpvBwmN0MBBppOWhsD32bzq++8SyBI5FkHDHUmLp3ZlN/OJqp3Lm0BlMLola2SRtqrKgrSF/6cHr+RazbLO1+fv5lsZKkrC8r/wDELEFRYPoGq2rgSKpixiEvCIODvtM/LI35jz9tqk5TyGkxycuBI38WpWp0vKAUqTQJ3TLfAFWdg4jGSCgxorFhWAqJ4sjLsBmQUOrA1yklV9Jvf+9h3tdel3DukUOmyorU7ogvbhWVVZE6E+uQqmomvQAGVA7B7dQ0NC2bKbEg4hHtZECOFRkhE5Xy3eOVdO33FKXMGqJpR+4oc/uHw2VlUYjHOit13leOuf1vw8OZliEGC4Xsc6toegdvEwAabcigiYFAdqd7P2pfAroYQ+9uVc5UnvMekKFxESTq55iJC9oKIQTV+GG/lRlmvfeKnmh35MU+DVBwMaB6cZEFBY7iz7BdNYFJxEwRw5/WXFG9qGECU93m/fo+xjm9p7ySb47xo4VU89VYQ5siqnEiQ9t8cGVeRc//o08Qvwt+0dhn8YLCSEcYUODhyOIlSSmTOjbQMpS4/+ogrXdeMpcUPnzCTduKCBRHmIJ1jBQpIC8nc6XJbGnKcRNwjWh5wumNKD0+V/SzKU0CQZwHdCu1FikYtd7ZaHlwarvcHNiiPV3lT8PALHd7DeUWWVzzbiWFSolxz/mVX97INbWUi1rdFmfNXNw37JaZJ7JJzW0dQnb+jEAie
 fQp5pfPy
 x4Lo9c+TZswedf+r/IlMmeofvdGm/Bj/iECXV1ZG0P30QbDsT8k5nr259/Imp1lHrYnBgb2fqIvr/XPNcsDKy8VGrsJqqu7BMzQKFwWomeQzboE+WTFVo5ycRqor11/yCcyTkNsnxs9VWPRyL8c/slUGkED8hcWHQHKMS8RSr33vg9baqr06eLISUAf4f1MumfJJuiHSYqGdOyhnVpTScVmSo5cftG2VqDDxQ8HAa/aQ7NDIMzqsV8V7E49J9g9oONdt//dqM2NLFLHyv7+QZBdatWmcCQjo+QaKkuqOX21sXHpbVZbYFYQkN0Y5Acy2xm7MmgquR/jlGbdEUi9SkKwD/sIBe+IPVzX+MJ2q681YHmwY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Nov 09, 2026 at 06:51:07AM +0000, Shivank Garg wrote:
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
> Signed-off-by: Shivank Garg <shivankg@amd.com>

Reviewed-by: Pedro Falcato <pfalcato@suse.de>

with a question below.

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
> Changes in v2:
> - Rebased on mm-next/for-next, and drop RFC tag.
> - Link to v1: https://lore.kernel.org/r/20261022-clear-pages-batch-v1-1-13d3bd0b876e@amd.com
> ---
>  include/linux/mm.h | 28 +---------------------------
>  mm/memory.c        | 29 ++++++++++++++++-------------
>  2 files changed, 17 insertions(+), 40 deletions(-)
> 
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index d89e6f823c9f..59bc3685aac5 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -5242,7 +5242,7 @@ static inline void clear_page_guard(struct zone *zone, struct page *page,
>   *
>   * When running under preemptible models this is not a problem. Under
>   * cooperatively scheduled models, however, the caller is expected to
> - * limit @npages to no more than PROCESS_PAGES_NON_PREEMPT_BATCH.
> + * clear one page at a time and call cond_resched() in between.
>   */
>  static inline void clear_pages(void *addr, unsigned int npages)
>  {
> @@ -5253,32 +5253,6 @@ static inline void clear_pages(void *addr, unsigned int npages)
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
>  #ifdef __HAVE_ARCH_GATE_AREA
>  extern struct vm_area_struct *get_gate_vma(struct mm_struct *mm);
>  extern int in_gate_area_no_mm(unsigned long addr);
> diff --git a/mm/memory.c b/mm/memory.c
> index c46482e35418..9bfd49ea990f 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -7612,27 +7612,30 @@ static inline int process_huge_page(
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
> +		clear_user_highpages(page + i, addr + i * PAGE_SIZE, 1);

I think we can use clear_user_highpage() here. I don't know if that's
necessarily desirable, but it would make this a little simpler.

-- 
Pedro

