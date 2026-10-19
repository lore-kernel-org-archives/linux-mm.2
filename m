Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 876B2CCF2DA
	for <linux-mm@archiver.kernel.org>; Mon, 19 Oct 2026 09:53:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 57D276B0190; Mon, 19 Oct 2026 05:53:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 52E6F6B0192; Mon, 19 Oct 2026 05:53:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 41C7C6B0193; Mon, 19 Oct 2026 05:53:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 0C0736B0190
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 05:53:35 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 3998BC0648
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 09:53:34 +0000 (UTC)
X-FDA: 85338913548.16.A69893E
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf05.hostedemail.com (Postfix) with ESMTP id 1D78D100005
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 09:53:31 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=TNiH6jAG;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=IMKWDODb;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=TNiH6jAG;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=IMKWDODb;
	spf=pass (imf05.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792403612;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DKiqBw8kgNDEliDnoLY6tY5aR14ZoTfXZiHIpRU4Bno=;
	b=Wka9hLsJnXVTuVdSTCdcxCyBgjj5aX2nOFXcollglC65LeTewdS2maDCl7Pct+l6v/4daT
	N5KAOh+R4wLBn+bumX75rV4ee3vEzwC9WJxRihPHV2AJ2BDOiQugnbJOEI9qll8+bCU4my
	IYqRdN5I9e18eAS6OqqcPq8zKl6GVEc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792403612;
	b=8pp6+cQrZvMb31rJZI7O9mPunn49rtvP7NW/rWNwBK1oUhG+b1PoOH6CZE5xQqqy3Clu8M
	DrJNK/LRL32jfOWo00JXrBxws8fioZYUIBzNxOH3+Tirmg3aEXEdLAi2kk3vZ+ef+fspMd
	IaP4Tzu1xl6wqP3X9sY+FZ0z3Pw8F/Q=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=TNiH6jAG;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=IMKWDODb;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=TNiH6jAG;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=IMKWDODb;
	spf=pass (imf05.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 3BB3121AC0;
	Mon, 19 Oct 2026 09:53:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1792403610; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=DKiqBw8kgNDEliDnoLY6tY5aR14ZoTfXZiHIpRU4Bno=;
	b=TNiH6jAGWzJ+CcphCjW4j7aj5U0zeU2N7JUCu5ljMtqB9zQxmzOq8YRau0SpCDN/Tnb02Q
	ahicBwHrHCw5SO2pH6kRe68ZDqSaS7aHEX9UPBg8P5zUXJ7Puj/y+xTRwvkrsHE4jTNiAB
	kRcd3Vn7S05FSmK01RYD+x5vtTkQBUk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1792403610;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=DKiqBw8kgNDEliDnoLY6tY5aR14ZoTfXZiHIpRU4Bno=;
	b=IMKWDODbku31f9X+imJzQOexZonmmj16TZ2NhoXcsP1S/iPoyWMdMHJAmLh+ZIE4EYWEan
	6BsoR6hGM5kS4FCA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1792403610; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=DKiqBw8kgNDEliDnoLY6tY5aR14ZoTfXZiHIpRU4Bno=;
	b=TNiH6jAGWzJ+CcphCjW4j7aj5U0zeU2N7JUCu5ljMtqB9zQxmzOq8YRau0SpCDN/Tnb02Q
	ahicBwHrHCw5SO2pH6kRe68ZDqSaS7aHEX9UPBg8P5zUXJ7Puj/y+xTRwvkrsHE4jTNiAB
	kRcd3Vn7S05FSmK01RYD+x5vtTkQBUk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1792403610;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=DKiqBw8kgNDEliDnoLY6tY5aR14ZoTfXZiHIpRU4Bno=;
	b=IMKWDODbku31f9X+imJzQOexZonmmj16TZ2NhoXcsP1S/iPoyWMdMHJAmLh+ZIE4EYWEan
	6BsoR6hGM5kS4FCA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 0BBCD134B3;
	Mon, 19 Oct 2026 09:53:28 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id Hk4/NZjo1Wo2OwAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Mon, 19 Oct 2026 09:53:28 +0000
Date: Mon, 19 Oct 2026 10:53:27 +0100
From: Pedro Falcato <pfalcato@suse.de>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Suren Baghdasaryan <surenb@google.com>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Shakeel Butt <shakeel.butt@linux.dev>, 
	David Hildenbrand <david@kernel.org>, Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>, 
	Jonathan Corbet <corbet@lwn.net>, Randy Dunlap <rdunlap@infradead.org>, 
	Jann Horn <jannh@google.com>, linux-mm@kvack.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, "Jose A. Perez de Azpillaga" <azpijr@gmail.com>, 
	Daehyeon Ko <4ncienth@gmail.com>
Subject: Re: [PATCH v2] mm/vma: avoid spurious write locks when
 mm->mm_lock_seq overflows
Message-ID: <atXjbsDn7DJybsHU@pedro-suse.tail5790ac.ts.net>
References: <20261016-fix-vma-lock-overflow-v2-1-9eb778b79b58@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261016-fix-vma-lock-overflow-v2-1-9eb778b79b58@kernel.org>
X-Stat-Signature: 7muo7n3p691xenwuipytdopijk5uazue
X-Rspam-User: 
X-Rspamd-Queue-Id: 1D78D100005
X-Rspamd-Server: rspam10
X-HE-Tag: 1792403611-313316
X-HE-Meta: U2FsdGVkX1+DhoR55dS+Ba6W+9FuwoOkvhRz/go3It467FQs8viHuxAPKkXmDWxSPsxLi+dK0KBtLOY0iBAV/xZtv4RN4gahWlaJskbsKdGvlA6ihQN3bQdeA5yWVyT4KTDd9v3vvcZ1I03kq/PGQcPWwoSdCFZFGa9nDN7PljN7h9IBzxEg1XefMc9zG05TIw2cH85GZ8+ScJymeKGJRJq5GeS5r1+pjjDKuTEqyhEWRZKKX58+59O88KWSgZ8nVT49yXNrxYxtVL6h1UVF78wdkO99E2zEAZdRjMRwkR1nSqKdKcGgAa/qruiJrNtwSpLOOiNGLMZtkWxgI/cbSCfH3xe1O7Ev+m45eMzK2YqGX4oomDTJq9U5NBpd+tDztzFS9h160t4sSXTT8+cJOn+k1RzTvD9FBCPVbzaTH+Z/krJRkhmXznihd5RrTgv1kiexv3+8QMyv8mxDyOlqrLah9b0DZ3XHF8TevBcRdnAyzjCHXpdsrEqi+B9ai8pFMAJxmebQ7YtzYYck6+MS4W+0qKFuxHShyiU3x+nqcaVQRyPGcV9Jy2g5Qti2/JQ3fj3oeXJ52dQAaYaxe6vJb2HtIgizGkYQ2jUVXdhk0gwxVDQHc+7bsTX1JdbMIEquUrIefrs6YwYZQo1S1pOiZyE7DJHB/uctXZRmUZ23xafNdE9kFaC9+X9NEJROGa+12PgV1GTf1h2PCwGUh73Kdk8zCR9CeMBpIxM+fDGSoY+MLukmSPxUxTY969LkQf5fe6oHYOQyE40bf5Ma6P8PAfuF6RB3cFRdV/TFIam/JXL09lr7xvD0I5uVMIepV7wpuUkIwK7DfakUpdMmF3m+6I57McUMOJfxVtjWJFYwI65jroty18hnL9VS8cdYapMaulo+qOQW2/5jTEeMBDkaaGj/uSegZIicUvL/inTJek585jUBFKvIESUnA79blSYS6OBwfHNYhe3Bn2sDswJ
 pO4kMr9x
 JFZ/JDX6jMCGSPWzElD0NBMvCHpAcvTWJWIOoD0zyQSmRoYroLhY8b5zmuq/k04Q4zl4Iph85Z+rTWmvgCSEb5RUAz6oI5OhTmY9tWVpbpkMUtUIA/20znyf5qAS4fojav/4WdVz6DvCQ1hWigMnqY6kZzAqO0jkqg/khBO+xFUlBlIlxpCafGGsl2vLMhmNagBcweuXM5ujNhtfGxvvOnV0wYbiY/424Rxps7MX3+7mDJStIyJahErPdZsyqT6J0H8iJ65dVNCAf4kghwmiAmGh/BbgF9Px7ypXDX7vWVlSoLskdTUIqrUVHY0XXX6etsAU7iVOaRNVmp4JWMoR96FJ4vyd1eS/YEyyHQJwqnanwUiA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 16, 2026 at 12:34:33PM +0100, Lorenzo Stoakes (ARM) wrote:
> So far the assumption has been that mm->mm_lock_seq overflow is benign,
> resulting only in readers spuriously falling back to the mmap lock, however
> it turns out that this was an unsafe assumption.
> 
> If a VMA can be spuriously considered write locked that means read lock
> exclusion does not take place, and thus a VMA can end up write-locked with
> concurrent readers.
> 
> Since overflow only occurs every 2^31 write lock/unlock cycles, resolve the
> issue by resetting every VMA's vma->vm_lock_seq each time such an overflow
> occurs.
> 
> This is done in vma_end_write_all(), which is called when the mmap write
> lock is released, i.e. in mmap_write_unlock() and mmap_write_downgrade().
> 
> Care must be taken, as resetting the sequence count at overflow means
> changing the seqcount of VMAs which are already attached and observable.
> 
> The mm's seqcount is guaranteed to be odd when a write lock is held, and
> thus any write locked VMA will have an odd seqcount assigned.
> 
> Therefore resetting to an even value prevents spurious write locks, since
> these can only occur with the mmap write lock held, at which point the mmap
> seqcount will be odd.
> 
> However, vma_start_read() also checks vma->vm_lock_seq == mm->mm_lock_seq,
> bailing if so (indicating a write lock).
> 
> This would cause any even reset value chosen to prevent VMA read locks from
> being taken - avoid this by also checking whether the VMA seqcount is odd
> before bailing on the read lock.
> 
> So far, vma->vm_lock_seq has defaulted to UINT_MAX, but this has been
> unnecessary since commit e5e7fb278e59 ("mm: convert mm_lock_seq to a proper
> seqcount"), since this is assigned when the VMA is still detached, and
> cannot be observed.
> 
> Therefore perform both reset and initialisation of vma->vm_lock_seq by
> simply setting vma->vm_lock_seq to zero.
> 
> The reset, performed in __mm_reset_vma_seqcounts(), only needs to
> WRITE_ONCE() the value.
> 
> However the read of vma->vm_lock_seq in vma_start_read() needs to have
> acquire semantics to pair with the smp_wmb() in do_raw_write_seqcount_end()
> so a reader reading a reset value also observes VMA modifications made
> under the write lock.
> 
> Since all VMA write locks were just released and the mmap write lock is
> still held, there are no concurrent VMA writers.
> 
> Concurrent VMA readers are unaffected. New VMA readers observe either zero,
> never a write lock, or the prior seqcount, behaving as before the reset.
> 
> Since this only occurs every 2^31 write lock/unlock cycles, the time taken
> to update all VMAs is considered to be acceptable.
> 
> Also update comments, documentation and VMA userland tests to reflect the
> change.
> 
> User facing effects are - dangerous races that could cause memory
> corruption or NULL pointer derefences (especially on page table traversal)
> are avoided.
> 
> Reported-by: Daehyeon Ko <4ncienth@gmail.com>
> Closes: https://lore.kernel.org/all/20261015143735.1630957-1-4ncienth@gmail.com/
> Fixes: 5e31275cc997 ("mm: add per-VMA lock and helper functions to control it")
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> ---
> Andrew - no stable tag please.
> 
> I will do the stable backports manually, they can be solved with a different
> approach.
> 
> Also, since, we're so close to the merge window I'm applying this against
> mm-unstable.
> 
> So I think it's fine to just send it (early :) in the merge window.
> ---
> v2:
> * Updated comment in vma_seqcount_is_write_locked() to mention the VMA
>   being attached.
> * Renamed reset_vma_seqcounts() to __mm_reset_vma_seqcounts().
> * Used acquire semantics in vma_start_reads() to avoid race with reset -
>   there is another acquire immediately after this one so it should just be
>   noise perf-wise.
> * Removed stable tag, will do the backports manually (just make the value
>   64 bits...)

I guess you're fitting this where __vm_anon_pgoff_lo now sits? If so, then
this patch probably wants backporting to 7.3.

> * Updated comments to reflect changes.
> * Added user-facing effects as per Vlasta ;)
> 
> v1:
> https://lore.kernel.org/r/20261015-fix-vma-lock-overflow-v1-1-01beb245d9da@kernel.org
> ---
>  
> +/*
> + * Called with mmap write lock held after mm->mm_lock_seq just overflowed (and
> + * therefore zero), with all VMA write locks now released.
> + *
> + * The stores below follow the smp_wmb() in do_raw_write_seqcount_end(), so
> + * a reader that observes a reset value also observes this cycle's VMA
> + * modifications (ordered by the ACQUIRE on vma->vm_lock_seq in
> + * vma_start_read()).
> + */
> +void __mm_reset_vma_seqcounts(struct mm_struct *mm)
> +{
> +	struct vm_area_struct *vma;
> +	VMA_ITERATOR(vmi, mm, 0);
> +
> +	mmap_assert_write_locked(mm);
> +	VM_WARN_ON_ONCE(mm->mm_lock_seq.sequence);
> +
> +	/*
> +	 * Failing to reset means stale vma->vm_lock_seq values could result in
> +	 * those VMAs becoming spuriously write locked when mm->mm_lock_seq
> +	 * happens to match their values.
> +	 *
> +	 * This is problematic, as it causes the VMA write lock to not exclude
> +	 * readers, which can result in concurrent readers while a VMA write
> +	 * lock is held.
> +	 *
> +	 * Avoid this by resetting to an even value (indicates no write lock
> +	 * held).
> +	 *
> +	 * Readers will either observe zero (not write locked) or the previous
> +	 * value, so this is safe.
> +	 */
> +	for_each_vma(vmi, vma)
> +		WRITE_ONCE(vma->vm_lock_seq, 0);

I'm concerned by the possible latency when doing this to many VMAs. Do you
have any numbers?

-- 
Pedro

