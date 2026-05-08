Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 34091CD37AC
	for <linux-mm@archiver.kernel.org>; Fri,  8 May 2026 17:27:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5B5E16B020A; Fri,  8 May 2026 13:27:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 566A76B020B; Fri,  8 May 2026 13:27:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 47C3C6B020C; Fri,  8 May 2026 13:27:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 36EF96B020A
	for <linux-mm@kvack.org>; Fri,  8 May 2026 13:27:01 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id CCA4F14022A
	for <linux-mm@kvack.org>; Fri,  8 May 2026 17:27:00 +0000 (UTC)
X-FDA: 84744933000.15.9415C50
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id 2D9B8140009
	for <linux-mm@kvack.org>; Fri,  8 May 2026 17:26:59 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=nVAov2zG;
	spf=pass (imf23.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778261219;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AFvclB+3Khbb3syyRk3OR5Tv8yujwQKR4GmM+2hKkKQ=;
	b=tO8aFZDhslo7HHujZKhk4/9JaKmLUD2WvKyVs7zC9AL+P0AM84mIV6wHy0V7Q6fo8F6uw1
	0ZyOh1ag+SNsMOUtj0fb3LG+XCdHR+1ZfzC3l84+78tnlGLbQ+ydSx2DBGdhxcIiuXINoy
	bkuJDuf9pGAHpwm36DZGOkMaV8wGjlc=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=nVAov2zG;
	spf=pass (imf23.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778261219; a=rsa-sha256;
	cv=none;
	b=BOzp1yLhMXmqo2bZ+qNxAvVGPRMG1jZWdOGlNvhwXgiM5BrnS8YgkPD7to95Y+Sw1KObW6
	8FrWOpR3f4hd7lDB6ZFv+2rsrh5ocn5Vp2KLQoSK7n9nrOX/aHJoOzdxpA9IZ02pfzDY8/
	d73ejSRl4sNAbZFPDLTMPF4PSLCKFQc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 8EAA360052;
	Fri,  8 May 2026 17:26:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A4A3C2BCB0;
	Fri,  8 May 2026 17:26:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778261218;
	bh=ldwPmyn++xeXa2y+rf2fbdlKgqflWX5XNaVgw3l8qkg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=nVAov2zGJkcYAFjCf23xDaugbKvhaEwFMZQ50HcimdX+Ie2fl+DnK4uKX3p9qufGB
	 EuESuBzJCrFoSeydMXlBfzc8qGsylKLLXDmIye2VApIn7a/yzQmeS/0P4nCu8WUubW
	 kwcmc1a4D18wIvWDYRm/03Itvvm3RVxsw1BY1JdfzBOlofg5UYEobtI21WDJhHouIn
	 Acz8nRHGn82c1ycR7Z//zOyrENXISqauoKX9MrMxM/fRr30Y7RlnhxQ/KMRlJBzrwM
	 M7kFsal9BaofCSRGda6J2627YTmfqLkKQEk3xn9PkjgRAGGgQPajsaNpq9W6dGCXpP
	 dzj8gSVa5eO1Q==
Date: Fri, 8 May 2026 18:26:51 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Dave Hansen <dave.hansen@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, 
	Andrew Morton <akpm@linux-foundation.org>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, linux-mm@kvack.org, 
	Shakeel Butt <shakeel.butt@linux.dev>, Suren Baghdasaryan <surenb@google.com>, 
	Vlastimil Babka <vbabka@kernel.org>
Subject: Re: [PATCH 3/6] mm: Add RCU-based VMA lookup that waits for writers
Message-ID: <af4Zx0gJIWbdDeY2@lucifer>
References: <20260429181954.F50224AE@davehans-spike.ostc.intel.com>
 <20260429181959.BC9DABC5@davehans-spike.ostc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260429181959.BC9DABC5@davehans-spike.ostc.intel.com>
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 2D9B8140009
X-Stat-Signature: 44kmsp4ge5r1s7qk6bt8hf6o53cfw4q1
X-HE-Tag: 1778261219-858626
X-HE-Meta: U2FsdGVkX1/xIsaJT8ChLR9GZ8X66ZRCDWkTIe32LFw/RHbbzG0STjbPHnwze+WIn7J7rn4x9poYHdr5tdSC0Q9JFU+AChIZMzlFvYbMMTQRfgILCk5Y61z9XAzhHH099EOJfdjN4wbziRtwtXbu6goaoivP9ZAGskWpB3x9dEaerCZeXiycqu5yZyAIcUY6jX9bGi5ydSaVaqgUh31SlwN1ud/FMSzHbgHvIBptjn5nYLywrZrUSDsRNE+r9aAS+UQL8mhE/z8TNelVESda2HInBG2gLCDZkEusypDuxl8DlC+xvI+aThVZqJPdC1/lKLkj+e6bG3kyzt2eYG5Bnafo9W2mAYnyPCdzyOrXEsDz6DAdAIiL88UPr2/XNZRMPQ6DWp0jnGYfFpxI2aBtzPpbC6ivoC/jDMWRQrDoZM698GG/SGiyGW87IRNUmhHyUwTP+dBVLkN1weLdgyb/ORNKyXkOwDNSryhyUh6TjFQ231Wa5lWZBQ2B4XoTaEk1f0tNXv0HTQjSXD/FsP0whA3qZB2h3ANKGxW9rd3nBqWoeR+TCLcf7B35lnMRmEe26JfBg8jMNtJD9gEA6vxb3To10oG63ujoxU+jac+KjFKuwIMWJL+C+XDUTux94Ltbh8sc3urW9PVmAnqnC4fOUDVCnIwZvkIdEAWkk6tewVpbrAu0qW+N7Np2VCjT/Fa036B/Mp8itFfi+Xxx5wh+UYefAjY1M1hmCGOzyaDwtd//T2qLdlawO2h1BDKcxKs0WuKYltvg39LBKjL8mX0Vq+NI3+F3lPTvWXRMdU+DeeeIK1p+V3fGTwDxtjFCJZNvCEXrI/89dOdTTTCsnC0ZxOafzIiNrdHbHtADTmhTjYqiyCO6nYlGIJhat4KBCobTukCgVbPxyD9Kv8bw1Btsu9nas4jh36htShxkiYSlGEmQ7/hJWfahmwN4SmymR+Nl2CK+QKZhCMLnQK7j2M5
 b9qEG4R+
 KM9+AFrv0IO4AEy7h4EXJcNUeElnD+9kvX68BQzQGHZBu7BjqkS4saBd66+C6Ktvb7/yP++XEwL6wdK6mm11I8m0d9rg8gBy5IFOUDxOSNRM8879QGlg/WIZJ0niniEHm9KJID9EGPfAsphHpxpxdBJDZS7Qcw8bedPqL9darqfLufJV0PmzVCsqaE9erdPQVd+snC0kXsEIBM9bOOGcM8eRhNQi97fT+L0FBHaADnlnJc4bRnU3W4bL70APEWZpouk3CxSuLXSAky5x9l5N0KDex+NM2ycCtebesmAgRCNGw0Ix4UuSF/IvgXcpUKb+fYkIT+6Ks00cgQ+5Mzt/V/BgmkWyAy41LUPVn5BNHCiqpavn5CWKULbp0OknZdjmzrdFikup2sh2ti6cfALF8xIS8VETJVWG4zryenb14g6GJhZ3Kah6JUnehXI6IzfQY/kSo0ISNUP6aJrk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Apr 29, 2026 at 11:19:59AM -0700, Dave Hansen wrote:
>
> From: Dave Hansen <dave.hansen@linux.intel.com>
>
> == Background ==
>
> There are basically two parallel ways to look up a VMA: the
> traditional way, which is protected by mmap_lock, and the RCU-based
> per-VMA lock way which is based on RCU and refcounts.
>
> == Problems ==
>
> The mmap_lock one is more straightforward to use but it has a big
> disadvantage in that it can not be mixed with page faults since those
> can take mmap_lock for read.
>
> The RCU one can be mixed with faults, but it is not available in all
> configs, so all RCU users need to be able to fall back to the
> traditional way.
>
> == Solution ==
>
> Add a variant of the RCU-based lookup that waits for writers. This is
> basically the same as the existing RCU-based lookup, but it also takes
> mmap_lock for read and waits for writers to finish before returning
> the VMA. This has two big advantages:
>
>  1. Callers do not need to have a fallback path for when they
>     collide with writers.
>  2. It can be used in contexts where page faults can happen because
>     it can take the mmap_lock for read but never *holds* it.
>
> == Discussion ==
>
> I am not married to the naming here at all. Naming suggestions would
> be much appreciated.
>
> This basically uses mmap_lock to wait for writers, nothing else. The
> VMA is obviously stable under mmap_read_lock() and the code _can_
> likely take advantage of that and possibly even remove the goto. For
> instance, it could (probably) bump the VMA refcount and exclude future
> writers. That would eliminate the goto.
>
> But the approach as-is is probably the smallest line count and
> arguably the simplest approach. It is a good place to start a
> conversation if nothing else.
>
> Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
> Cc: Suren Baghdasaryan <surenb@google.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
> Cc: Lorenzo Stoakes <ljs@kernel.org>
> Cc: Vlastimil Babka <vbabka@kernel.org>
> Cc: Shakeel Butt <shakeel.butt@linux.dev>
> Cc: linux-mm@kvack.org
> ---
>
>  b/include/linux/mmap_lock.h |    2 ++
>  b/mm/mmap_lock.c            |   43 +++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 45 insertions(+)
>
> diff -puN include/linux/mmap_lock.h~lock-vma-under-rcu-wait include/linux/mmap_lock.h
> --- a/include/linux/mmap_lock.h~lock-vma-under-rcu-wait	2026-04-29 11:18:50.633628887 -0700
> +++ b/include/linux/mmap_lock.h	2026-04-29 11:18:50.707631737 -0700
> @@ -470,6 +470,8 @@ static inline void vma_mark_detached(str
>
>  struct vm_area_struct *lock_vma_under_rcu(struct mm_struct *mm,
>  					  unsigned long address);
> +struct vm_area_struct *lock_vma_under_rcu_wait(struct mm_struct *mm,
> +					  unsigned long address);
>
>  /*
>   * Locks next vma pointed by the iterator. Confirms the locked vma has not
> diff -puN mm/mmap_lock.c~lock-vma-under-rcu-wait mm/mmap_lock.c
> --- a/mm/mmap_lock.c~lock-vma-under-rcu-wait	2026-04-29 11:18:50.704631622 -0700
> +++ b/mm/mmap_lock.c	2026-04-29 11:18:50.707631737 -0700
> @@ -340,6 +340,49 @@ inval:
>  	return NULL;
>  }
>
> +/*
> + * Find the VMA covering 'address' and lock it for reading. Waits for writers to
> + * finish if the VMA is being modified. Returns NULL if there is no VMA covering
> + * 'address'.
> + *
> + * The fast path does not take mmap lock.
> + */
> +struct vm_area_struct *lock_vma_under_rcu_wait(struct mm_struct *mm,
> +					       unsigned long address)
> +{
> +	struct vm_area_struct *vma;
> +
> +retry:
> +	vma = lock_vma_under_rcu(mm, address);
> +	/* Fast path: return stable VMA covering 'address': */
> +	if (vma)
> +		return vma;
> +
> +	/*
> +	 * Slow path: the VMA covering 'address' is being modified.
> +	 * or there is no VMA covering 'address'. Rule out the
> +	 * possibility that the VMA is being modified:
> +	 */
> +	mmap_read_lock(mm);
> +	vma = vma_lookup(mm, address);
> +	mmap_read_unlock(mm);
> +
> +	/* There was for sure no VMA covering 'address': */
> +	if (!vma)
> +		return NULL;
> +
> +	/*
> +	 * VMA was likely being modified during RCU lookup. Try again.
> +	 * mmap_read_lock() waited for the writer to complete and the
> +	 * writer is now done.
> +	 *
> +	 * There is no guarantee that any single retry will succeed,
> +	 * and it is possible but highly unlikely this will loop
> +	 * forever.
> +	 */
> +	goto retry;
> +}

Hmm yeah this is not ideal :)

You don't have to do any of this we already have logic to help out here -
vma_start_read_locked().

That uses the fact the mmap read lock is held to pin the VMA lock, because VMA
write locks require an mmap write lock, and the mmap read lock prevents them.

That way you can eliminate the retry.

So instead:

/*
 * Tries to lock under RCU, failing that it acquires the VMA lock with the mmap
 * read lock held.
 */
struct vm_area_struct *vma_start_read_unlocked(struct mm_struct *mm,
					       unsigned long address)
{
	struct vm_area_struct *vma;

	might_sleep();

	vma = lock_vma_under_rcu(mm, address);
	if (vma)
		return vma;

	/* Slow path: preclude VMA writers by getting mmap read lock. */
	guard(rwsem_read)(&mm->mmap_lock);
	vma = vma_lookup(mm, address);
	/* VMA isn't there. */
	if (!vma)
		return NULL;

	return vma_start_read_locked(vma);
}

(Untested, not even build tested code)

Not sure if we can use the linux/cleanup.h guard here, because mmap_read_lock()
also does some trace stuff, but the guard makes it WAY nicer so (when it goes
out of scope the mmap read lock is dropped).

Maybe we could add a custom mmap lock guard to cover that too?

Suren - I actually wonder if vma_start_read_locked() actually needs to return a
boolean? The failure cases for __refcount_inc_not_zero_limited_acquire() are -
detached or excluding readers on write/detach.

But in both of those cases, vma_lookup() would surely not find the VMA, and
since we're precluding writers (so no write lock, no detach possible) that means
we should never hit it?

Wonder if we should make it a void and add a VM_WARN_ON_ONCE()?


> +
>  static struct vm_area_struct *lock_next_vma_under_mmap_lock(struct mm_struct *mm,
>  							    struct vma_iterator *vmi,
>  							    unsigned long from_addr)
> _

Cheers, Lorenzo

