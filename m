Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CA70CC5AC82
	for <linux-mm@archiver.kernel.org>; Mon, 10 Aug 2026 10:42:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8382F6B007B; Mon, 10 Aug 2026 06:42:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7E8EA6B008A; Mon, 10 Aug 2026 06:42:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6D7BA6B008C; Mon, 10 Aug 2026 06:42:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 385946B007B
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 06:42:13 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 2A2501A0101
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 10:42:12 +0000 (UTC)
X-FDA: 85085020104.08.704294B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id 82290A0006
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 10:42:10 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lPvKTRDH;
	spf=pass (imf25.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786358530;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TfDEpbXj9Skvq0RQ7XQBYjnmsLgpmOAdrHJWVqiBMAo=;
	b=5SjYWXOE/aIfoSe5uSa9OwFD62zVxGgw9GyZ3006HgHGd+7NS4RC/Xp1zx6rfjUrS2SsnK
	1ZEu7ehvLImwLLU7Sg0cDaljqERgS3+9J3XamFbRgJch2qc6ubd91JREKP0nTky7DuIkiV
	/fVr9jK0CDsFGbWK/eN+ieNBdi/JAwU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786358530;
	b=sJ/qPKCcrCo1Jzdqss34LH01PlGtHYae0A11Whoo8l1mEJNiTXanVC9Av6R0adgv0swmrL
	BdS07mB0FvPYw5UDnLAyjgF2/KoXhXjMz/URfxwIW5kUse3D4ssW40SrtDwGyo5rD+M5bU
	oyGS4e1eVOzfBF5WzgsmqFhops/H1SY=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lPvKTRDH;
	spf=pass (imf25.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 1300D60052;
	Mon, 10 Aug 2026 10:42:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8495C1F00A3A;
	Mon, 10 Aug 2026 10:42:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786358529;
	bh=TfDEpbXj9Skvq0RQ7XQBYjnmsLgpmOAdrHJWVqiBMAo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=lPvKTRDHEB+uKRPoWeR6D/YeT/rUTkGXFwbDrQ98m/iDDJ3bmK8saddWm4WCwXZFm
	 u6IH48pvyLJSgRM2ghH3EGYffp7eSbJUnO3fow7dFpesG8pD0hIta+fN2wXlJI7JD9
	 Oe33b54M+bQ/tWbVs0kVjEM1r1m1XTbBHHb016T01AyQpv1hH6KjHpigL1IvqVDF8/
	 Ku8lpLAHZ0bn2GJBqzs6SNnvMl18qhHPXfRRaKkBRnIuN2BOP1OPcgTPGVZZpH03qD
	 bLkOf0Pu728XFi7TISj4VGlk9QffTfjPuiFRBQLhhTGSxj5w6ofVFiBiLOG8QNQr+U
	 uRk940HN2pIgQ==
Date: Mon, 10 Aug 2026 11:41:50 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Suren Baghdasaryan <surenb@google.com>
Cc: akpm@linux-foundation.org, dave.hansen@linux.intel.com, 
	Liam.Howlett@oracle.com, david@kernel.org, willy@infradead.org, shakeel.butt@linux.dev, 
	vbabka@kernel.org, jannh@google.com, aliceryhl@google.com, arve@android.com, 
	cmllamas@google.com, christian@brauner.io, tkjos@android.com, dsahern@kernel.org, 
	davem@davemloft.net, gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, netdev@vger.kernel.org
Subject: Re: [PATCH v4 3/5] mm: Add RCU-based VMA lookup helper that waits
 for writers
Message-ID: <anmm18_pG4HXMZo_@lucifer>
References: <20260806200548.3124802-1-surenb@google.com>
 <20260806200548.3124802-4-surenb@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260806200548.3124802-4-surenb@google.com>
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 82290A0006
X-Stat-Signature: a7c51sfp8e3e3xmyfax8rhuh3gkxmjme
X-Rspam-User: 
X-HE-Tag: 1786358530-578557
X-HE-Meta: U2FsdGVkX19gbJwcZULEEsrDqAkWGNlRQTJNep0CfL4xHWVYmyEZH2HOugUNqBhBuKkKM6H1+1SaZI8KeS1fjz2DGbZ0ioaVDVxbWo2xQC+4UL+mVDZKr9hjqI3OgqGop6lLGV4CxixsRgsOjHcZZqezysvRUrCQDD3DMdUakSVdNMGjrXBtgNJ3PpcuUlcyW6+ulCM2vsHpRfKFtoWvcnFvHFQPinNgeaj2YQcs/MazCPmEMDLrtvBcimgFx7ieuy/tmbA6C/EpGKmilQ79/nPo+LuuOQZI5Ie6x6ojCSihsFGkxTsIukNZcFGo5XkOZSQvdzP3WBDZQzksVxmns/rC2GRsRCOS5pLBih6Eyq12AP6/+hokNAZgSaEL5NaZmcTJmFFQN19sj0JgPd59niZC6alziVRozwkmBZV9m9u5+k0EvGSX+FNP2zKmk2pCTDcx31QaRxjoYrIhDHofHfC6xeZAFkfLUfTcmdsJpwrCnMI0jTQuaNiQFnwUW3CnXnHcUfrhg6tRF0ipXSI+yfGwr+58Z1G33HbZm94g1xJ0uXBEjIm1ZjElqCM8jBZm3JcFDQ+DkCDZ19GDx+qyU32QEh7glIV7++Yo1vRG2cLcAX2bO3h+dr/CeaCPYTj4wbM44r/gYk/oerVG8msvsYZ/VoLGpl5wpaJY24fVuul8Ov/FOBtbCggAn5KwRWJJ1vkDmq0zk5mBsy9bv76z2yL9pP2br5n0+UeLtIR1EHqZbLBxS+jM6ZZrlf4NsxHaJfH7/VUk7rhd/uCWKzWm/WJZzukgOQGfT4qiaHJSZejg6NID0/dauPJHKHJldEk+k2XcfKT0Q7kQ9ufreRhPvwU9kunCfF+xnFxZsIKpDLXhANAlntPNmPLlPgM7ZiIYqNZwSdM/qAsLTf75DiDPZlNCvqODXPv2nVRoRfSZUJFsTTOzZAUBrPLxBi83V/Qy8U5NzOa6I3SdtIT0hz1
 MlRU/N4h
 vAG5tuYsqXOI6NGphqI54pvRnSLJ7X6kcx4pd329uJ0a/2EqkrWP9avHEVCs1sFEpU1dw9ti+EKSELcYPVYQfIQZx0zMjntnmW/7Td7dH6IBtT74dX5EtsqrtIYG8uj5uOi6fIE1m7V62JZYZOHkn61ziAuaucSOw+bbcXLlqHHoJT647sAGBRADxP23RBBSkjFUFr7ijFu7+8ZgnNyPPECnXakxQOCQ7apfF18AW5ShV6I50UdZO8oDN22mExX8ifnKKmS4eve2dbzyAjQaaQCItUYO1UCLKbUXz47n2NemRcLEaTygLXSKydB3woCZUGhDSWyKwx2zYILsOZjQfYIGhATdM8aUPPuxeY6pTwcym6kM4AvYE3HNr0sNr+F5xlZU+WPPIYc9sHQrtGYwS7PNnwKshq9ulJtWuNj9LBE8bXP13FyOSjlntHkmIOu3ntu9cg71VESSGu9qY9KvUpmJiSjnZJD6gjZSlT4Q3NVwhIel6rozlYDG+4Mu41rzIpDDcBkjSUhlbLUNdilLjG0oMwCivENnyNGpdGUOfbbMwjqCZ6w4KWG8BUHAuSvKcExHz/RTFZSLNdDpEUxKHS3PzHw6VSF6F8Dt1K0mhpJUr0qfjxsJFMiAaZ4LVgnI9OqYfoq/Sw6jOu8hArHenmb3dRPIHgE4WQXPwli4vHPheVYpC/WYbqWffxvmIzx6dWTOdpa4RnxbBS/Y=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 06, 2026 at 01:05:46PM -0700, Suren Baghdasaryan wrote:
> From: Dave Hansen <dave.hansen@linux.intel.com>
>
> == Background ==
>
> There are basically two parallel ways to look up a VMA: the
> traditional way, which is protected by mmap_read_lock, and the RCU-based
> per-VMA lock way which is based on RCU and refcounts.
>
> == Problem ==
>
> The mmap_lock one is more straightforward to use but it has a big
> disadvantage in that it can not be mixed with page faults since those
> can take mmap_lock for read, which can deadlock when mixed with nested
> page faults and parallel writers.
> For example:
>
> 	mmap_read_lock(mm);
> 	// Another thread does mmap_write_lock().
> 	// New mmap_lock readers are blocked.
> 	vma = vma_lookup(mm, address);
> 	// This deadlocks on mmap_read_lock() if it faults:
> 	copy_from_user(address);
> 	mmap_read_unlock(mm);
>
> The per-VMA lock can be mixed with faults, but they can fail and need to
> be able to fall back to the traditional way.

As discussed in reply to Matthew, this isn't so useful to have here I don't
think.

>
> == Solution ==
>
> Add vma_start_read_unlocked() - a variant of the RCU-based lookup that
> waits for writers. This is basically the same as the existing RCU-based
> lookup, but on a failure to lock it temporarily takes mmap_lock for read
> and waits for writers to finish before locking the VMA, dropping the
> mmap_lock and returning the locked VMA. This has some advantages:

Nitty but maybe reads better as something like:

	..., on failing to acquire the VMA lock it waits for writers to
	finish by temporarily acquiring the mmap read lock and taking the
	VMA lock with it held via vma_start_read_locked() before dropping
	it again.

>
>  1. Callers do not need to have a fallback path for when they
>     collide with writers.
>  2. It can be used in contexts where page faults can happen because
>     it can take the mmap_lock for read but never *holds* it.
>  3. Its fast path does not require taking mmap_lock for read.
>
> Basically, when applied correctly, this approach results in faster
> *and* simpler code.

I think this suffices as justification for the function with the above
deadlock scenario simply excised.

>
> While at it, fix the comments for vma_start_read_locked(),
> vma_start_read_locked_nested(), and uffd_lock_vma().
>
> Suggested-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Thanks :>)

> Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
> Signed-off-by: Suren Baghdasaryan <surenb@google.com>

LGTM, so with the changes to commit message applied feel free to add:

Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

> Cc: Suren Baghdasaryan <surenb@google.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
> Cc: Lorenzo Stoakes <ljs@kernel.org>
> Cc: Vlastimil Babka <vbabka@kernel.org>
> Cc: Shakeel Butt <shakeel.butt@linux.dev>
> Cc: linux-mm@kvack.org
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Arve Hjønnevåg <arve@android.com>
> Cc: Todd Kjos <tkjos@android.com>
> Cc: Christian Brauner <christian@brauner.io>
> Cc: Carlos Llamas <cmllamas@google.com>
> Cc: Alice Ryhl <aliceryhl@google.com>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: David Ahern <dsahern@kernel.org>
> Cc: netdev@vger.kernel.org
> ---
>  include/linux/mmap_lock.h | 19 +++++++++++++++----
>  mm/mmap_lock.c            | 35 +++++++++++++++++++++++++++++++++++
>  mm/userfaultfd.c          |  6 ++++--
>  3 files changed, 54 insertions(+), 6 deletions(-)
>
> diff --git a/include/linux/mmap_lock.h b/include/linux/mmap_lock.h
> index 7b2bbb09a952..a23fe6cbe301 100644
> --- a/include/linux/mmap_lock.h
> +++ b/include/linux/mmap_lock.h
> @@ -228,10 +228,14 @@ static inline void vma_refcount_put(struct vm_area_struct *vma)
>  }
>
>  /*
> - * Use only while holding mmap read lock which guarantees that locking will not
> - * fail (nobody can concurrently write-lock the vma). vma_start_read() should
> + * Use only while holding mmap read lock which guarantees that vma lock is not
> + * contended (nobody can concurrently write-lock the vma). vma_start_read() should
>   * not be used in such cases because it might fail due to mm_lock_seq overflow.
>   * This functionality is used to obtain vma read lock and drop the mmap read lock.
> + *
> + * VMA can't be detached while we are holding mmap lock, therefore in practice this
> + * function can fail only when there are so many readers that vm_refcnt overflows.
> + * The failure case is very unlikely and is already annotated as such internally.
>   */
>  static inline bool vma_start_read_locked_nested(struct vm_area_struct *vma, int subclass)
>  {
> @@ -247,16 +251,23 @@ static inline bool vma_start_read_locked_nested(struct vm_area_struct *vma, int
>  }
>
>  /*
> - * Use only while holding mmap read lock which guarantees that locking will not
> - * fail (nobody can concurrently write-lock the vma). vma_start_read() should
> + * Use only while holding mmap read lock which guarantees that vma lock is not
> + * contended (nobody can concurrently write-lock the vma). vma_start_read() should
>   * not be used in such cases because it might fail due to mm_lock_seq overflow.
>   * This functionality is used to obtain vma read lock and drop the mmap read lock.
> + *
> + * VMA can't be detached while we are holding mmap lock, therefore in practice this
> + * function can fail only when there are so many readers that vm_refcnt overflows.
> + * The failure case is very unlikely and is already annotated as such internally.
>   */
>  static inline bool vma_start_read_locked(struct vm_area_struct *vma)
>  {
>  	return vma_start_read_locked_nested(vma, 0);
>  }
>
> +struct vm_area_struct *vma_start_read_unlocked(struct mm_struct *mm,
> +					       unsigned long address);
> +
>  static inline void vma_end_read(struct vm_area_struct *vma)
>  {
>  	vma_refcount_put(vma);
> diff --git a/mm/mmap_lock.c b/mm/mmap_lock.c
> index e20d01e8d38f..1c4902131e98 100644
> --- a/mm/mmap_lock.c
> +++ b/mm/mmap_lock.c
> @@ -338,6 +338,41 @@ struct vm_area_struct *lock_vma_under_rcu(struct mm_struct *mm,
>  	return NULL;
>  }
>
> +/**
> + * vma_start_read_unlocked() - Find the VMA covering 'address' and read-lock it.
> + * @mm: the mm_struct of the address space to search
> + * @address: address that the vma should contain
> + *
> + * The fast path does not take mmap_lock. Waits for writers to finish if the
> + * VMA is being modified by taking mmap_lock.
> + * Use when mmap_lock is not held, otherwise use vma_start_read_locked().
> + * Nothing prevents VMAs being unmapped/mapped before or after the VMA is
> + * looked up, if a stronger guarantee is required, take an mmap_lock.

Great thanks!

> + *
> + * Return: If a VMA exists which spans @address, return that VMA, read-locked.
> + * If no VMA is mapped there or, very unlikely, a reference count overflow
> + * occurred, return NULL.
> + */
> +struct vm_area_struct *vma_start_read_unlocked(struct mm_struct *mm,
> +					       unsigned long address)
> +{
> +	struct vm_area_struct *vma;
> +
> +	/* Fast path: return stable VMA covering 'address': */
> +	vma = lock_vma_under_rcu(mm, address);
> +	if (vma)
> +		return vma;
> +
> +	/* Slow path: preclude VMA writers by temporarily getting mmap read lock. */
> +	mmap_read_lock(mm);
> +	vma = vma_lookup(mm, address);
> +	if (vma && !vma_start_read_locked(vma))
> +		vma = NULL;
> +	mmap_read_unlock(mm);
> +
> +	return vma;
> +}
> +
>  static struct vm_area_struct *lock_next_vma_under_mmap_lock(struct mm_struct *mm,
>  							    struct vma_iterator *vmi,
>  							    unsigned long from_addr)
> diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
> index edd90892f8cc..c3a0c38a3dc3 100644
> --- a/mm/userfaultfd.c
> +++ b/mm/userfaultfd.c
> @@ -129,8 +129,10 @@ struct vm_area_struct *find_vma_and_prepare_anon(struct mm_struct *mm,
>   *
>   * Should be called without holding mmap_lock.
>   *
> - * Return: A locked vma containing @address, -ENOENT if no vma is found, or
> - * -ENOMEM if anon_vma couldn't be allocated.
> + * Return: A locked vma containing @address, -ENOENT if no vma is found,
> + * -ENOMEM if anon_vma couldn't be allocated, or -EAGAIN if vma refcount
> + * overflow happened due to high number of readers and the caller should
> + * retry later.
>   */
>  static struct vm_area_struct *uffd_lock_vma(struct mm_struct *mm,
>  				       unsigned long address)
> --
> 2.55.0.654.g21b8a5bc05-goog
>

--
Cheers, Lorenzo

