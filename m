Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CB075C55179
	for <linux-mm@archiver.kernel.org>; Mon,  3 Aug 2026 13:54:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E959A6B00CF; Mon,  3 Aug 2026 09:54:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E45CA6B00D9; Mon,  3 Aug 2026 09:54:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D32226B00DA; Mon,  3 Aug 2026 09:54:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A9CA96B00CF
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 09:54:25 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id DB0031406D6
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 11:28:46 +0000 (UTC)
X-FDA: 85059735852.20.7234B3A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf31.hostedemail.com (Postfix) with ESMTP id 226AF20005
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 11:28:45 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kOZ8+suY;
	spf=pass (imf31.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785756525;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ou4sT2BujwFMitQRzviT5KLE0YM4++tuPCN0yYss9us=;
	b=fxCCMi+mrS2Pao/cK8zxzDLUOrpxUXcpl27/3brhzS/Gfn/73rJBgMlZ+xLnExT/lKNKlQ
	esILMfn0VUZY+D3BUavk+T5L5CernzwitQyoI3AwvnL2eoi3vDotYwoEedvWtG9kzoTjht
	5OW9B/tqUzsJDjBO5D1cvzeSYyTObQI=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kOZ8+suY;
	spf=pass (imf31.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785756525;
	b=iIYjewr7bzcZgxaHeC0oHkGEugeQyC+7DGPSBBH7BPf//EfNAd+hBtLMWnoe6iBItqd95X
	jwr6zaGMbzaklxi6leT6aNkf/lVGkYZKa7Sa4xZP7vPxBpE4uLxBEgOnwbS9JsyID7lMKa
	oTKAy0d/Ooy5NHZyWR0Z50bWGGMyxN8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 387F440930;
	Mon,  3 Aug 2026 11:28:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80B171F000E9;
	Mon,  3 Aug 2026 11:28:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785756524;
	bh=ou4sT2BujwFMitQRzviT5KLE0YM4++tuPCN0yYss9us=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=kOZ8+suYI9tE4kDLma/Id4gIZCQraiBxxVBj72UObGWTFLsPQdKqiOUvN9dPgO7v6
	 wj+ICfXbZ1+gkoV7monhhWSIJK2aUP6Q0FJQFUSq6xmuuU0gKQI4y5Mi/JwwenyKt2
	 uKcQ/oCiZRWyZAbsoWqv/us2EvZ2aWlHu+YXzqFSBv2jnijERqhH7tB2uEdkyxmBcb
	 cdGIHuo9FMvI85PpMjc3uF2KaL2Sue11k+aBav1hsQ0Dp1yNsH60aXl/X59lYf15Rc
	 +42vYqDTTuFyeLqHnETFPN+66oSpN2IaWkO1yqdUDjlOtdF4U6Mf2HF17brF6WbuAt
	 3HHRES+JV7Akw==
Date: Mon, 3 Aug 2026 12:28:25 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Suren Baghdasaryan <surenb@google.com>
Cc: akpm@linux-foundation.org, dave.hansen@linux.intel.com, 
	Liam.Howlett@oracle.com, david@redhat.com, willy@infradead.org, shakeel.butt@linux.dev, 
	vbabka@kernel.org, jannh@google.com, aliceryhl@google.com, arve@android.com, 
	cmllamas@google.com, christian@brauner.io, tkjos@android.com, dsahern@kernel.org, 
	davem@davemloft.net, gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, netdev@vger.kernel.org
Subject: Re: [PATCH v3 3/5] mm: Add RCU-based VMA lookup helper that waits
 for writers
Message-ID: <anB4uxEbKsa1Re0w@lucifer>
References: <20260802215459.2769283-1-surenb@google.com>
 <20260802215459.2769283-4-surenb@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260802215459.2769283-4-surenb@google.com>
X-Rspamd-Queue-Id: 226AF20005
X-Rspam-User: 
X-Stat-Signature: zk8ba8w5hdb54ocnf6uxt11m9yp8owrh
X-Rspamd-Server: rspam04
X-HE-Tag: 1785756525-388137
X-HE-Meta: U2FsdGVkX1/NO+kP1Bpc6KuMLKIl5E4sfwx1MbPZG43R+S7hcQ9AlS72lEa1rnk3MPWZSzkwOUu56/moUZLxdcAqO+AQ0vWNLdJeS0ZsWUg2RlPjF3cWBmWyIGILiOBl8+fYV5ecjPSAo1E2KG1MojkYDmOi8myPHAvGljKkLd+rGOuGRsvFe3XyS7hduImOW2+PdUsJOnUZvVDumm8K7qcXHcc1mRnylFPW1Q6BXBDh4oRupJ2obJM6ozprIEIdiuKpwrAuryHghZgQtAcfroregVCz1YT3S24BeS14z5lQVVlWK5DAKBagumBXDTLFv2djVUdTWh8nI9o6Ch77VBfKaUUjOpeYa7YNS5Z87gks1B9x03MHj6bvV6hv1YfKNPryWACF1K3/N5zjUmYgGGuBL3hLN+H4a/oBH0sMnNZKO031865WAqeDISSwO1rElpq05y6Xvm350AHFV8lehVcEb4AbdqLMny5hziQ1C87xDi8SnnwV4Xzp04XHN18oySmYyGa+k1PBXmKCRIBJ8AQC4VgDe7V0GcD60PU3TcJxyBjT3zo/ENPUxTq+XpGOLFoGTgMKcE05tj3YndiWGLoHMIneq2VzAa57ULwOgr9oiIxkyv2q8SdpqwEALGzZ0q+EiBB5Sq2cSK+Bx1d8LwgTR120K2rPh+VB4GQgj0Fp1EPe+3pMfvyD23G4gB+e+wSMizAKQXYYU44sIAmBnTmCUSpJ6ZN/85cwcigcAztFfpeFbxbjKzFUeb0LP+Sa6kjW4AsrpM9pQ97ZWCa98lE7L5CMms2iJgMDeI5bkRIHHhonkxuRE8IMGTpYCx/C6O7OIG2JDERdgsEAkPAOkEOIxSjW359NEM46wWdnEDXy97V0nIR/EuBcFZAen5zdORO90djbTWZPzuuulUF7RxNqivphTfOAB09rbgzeVtx/FILAhxTFUnYkUENuDEkTxsXxOita59IzPGdqJVj
 ABtjnvmP
 x9gs4xGb4y/qyXLn8Fh0YD3S6OCQeLClnI221yPvUu8qg2xFLCGSbGgwJHabJ5RrJPDorDONNb1R5jGzBi/1/faDFs630mMlEj9POe4uNf33QCfOFhQ7qG0BRazunKdjtlPn0HBeIBn0Ksx9CdPjwt2V6msk/zpbywhBGuLnN5mBvB4qotsI9LVUOZlENug1qhdIFVUEnRgVnJUUMZUJFFENU0Sx52lfZm0/623sR5J3SrgDsRXb7cJO2arTXhvIhq+xDVlegjA0IwoyX93sP1f6rhJrCTma0/MZaQoAwukMjAQQMXXSr9R777s2mk+pqIdCEbmSoUbv7zv99cYVlfJ/FBYusdwt966P/TiuV8XXYSqfTAOR+Y0QRh7UBT5krEPQS1JoUPpTQxw6etnt7jAzRVNJisKj+q4w9/LEoe7LmoeDDLMKwd/KI+zUEy3ckyufsbg8tBFGiPReKyVC0af+aNVEzEPCWwBGCjdPoT5tXzwCWEmnLUgM5kEmkw/SitRy7Tl85NiZmSRF6500qAOY9zQUy4St3M+sPRqCmqF/mTd6WlThvXaEliANuEpLyJ3ap4NCPu3JkaUdyzllFWHo051P+y4afUNWygpKwNG0UWJt+97isVLc2Ic2mXmubwSlCTL/OHeRbedvHNOay3si5/bjCv68g51/yPYu8dKGGkvX30/6kLrpEJWzVIywGmMoc8y57zX73c70=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Aug 02, 2026 at 02:54:57PM -0700, Suren Baghdasaryan wrote:
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
>
> == Solution ==
>
> Add a variant of the RCU-based lookup that waits for writers. This is
> basically the same as the existing RCU-based lookup, but on a failure to
> lock it temporarily takes mmap_lock for read and waits for writers
> to finish before locking the VMA, dropping the mmap_lock and returning
> the locked VMA. This has some advantages:
>
>  1. Callers do not need to have a fallback path for when they
>     collide with writers.
>  2. It can be used in contexts where page faults can happen because
>     it can take the mmap_lock for read but never *holds* it.
>  3. Its fast path does not require taking mmap_lock for read.
>
> Basically, when applied correctly, this approach results in faster
> *and* simpler code.
>

Would be nice to have a:

Suggested-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Here given https://lore.kernel.org/linux-mm/af4Zx0gJIWbdDeY2@lucifer/ :)

> Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
> Signed-off-by: Suren Baghdasaryan <surenb@google.com>
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
>  include/linux/mmap_lock.h | 15 +++++++++++----
>  mm/mmap_lock.c            | 29 +++++++++++++++++++++++++++++
>  mm/userfaultfd.c          |  6 ++++--
>  3 files changed, 44 insertions(+), 6 deletions(-)
>
> diff --git a/include/linux/mmap_lock.h b/include/linux/mmap_lock.h
> index eb32b482434e..fdd8f5cf5722 100644
> --- a/include/linux/mmap_lock.h
> +++ b/include/linux/mmap_lock.h
> @@ -228,10 +228,12 @@ static inline void vma_refcount_put(struct vm_area_struct *vma)
>  }
>
>  /*
> - * Use only while holding mmap read lock which guarantees that locking will not
> - * fail (nobody can concurrently write-lock the vma). vma_start_read() should
> + * Use only while holding mmap read lock which guarantees that vma lock is not
> + * contended (nobody can concurrently write-lock the vma). vma_start_read() should
>   * not be used in such cases because it might fail due to mm_lock_seq overflow.
>   * This functionality is used to obtain vma read lock and drop the mmap read lock.
> + * VMA can't be detached while we are holding mmap lock, therefore in practice this
> + * function can fail only when there are so many readers that vm_refcnt overflows.
>   */
>  static inline bool vma_start_read_locked_nested(struct vm_area_struct *vma, int subclass)
>  {
> @@ -247,16 +249,21 @@ static inline bool vma_start_read_locked_nested(struct vm_area_struct *vma, int
>  }
>
>  /*
> - * Use only while holding mmap read lock which guarantees that locking will not
> - * fail (nobody can concurrently write-lock the vma). vma_start_read() should
> + * Use only while holding mmap read lock which guarantees that vma lock is not
> + * contended (nobody can concurrently write-lock the vma). vma_start_read() should
>   * not be used in such cases because it might fail due to mm_lock_seq overflow.
>   * This functionality is used to obtain vma read lock and drop the mmap read lock.
> + * VMA can't be detached while we are holding mmap lock, therefore in practice this
> + * function can fail only when there are so many readers that vm_refcnt overflows.
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
> index e20d01e8d38f..6ff05e68e61b 100644
> --- a/mm/mmap_lock.c
> +++ b/mm/mmap_lock.c
> @@ -338,6 +338,35 @@ struct vm_area_struct *lock_vma_under_rcu(struct mm_struct *mm,
>  	return NULL;
>  }
>
> +/*

Why not a kdoc comment?

> + * Find the VMA covering 'address' and lock it for reading. Waits for writers to
> + * finish if the VMA is being modified. Returns NULL if there is no VMA covering
> + * 'address'.
> + *
> + * Use only in code paths where no mmap_lock and no VMA lock is held.

Well, a VMA read lock can be held which would make this a noop essentially.

If a VMA write lock is held you're also ok as the mmap read lock will preclude
an mmap write lock, meaning vma_end_write_all() will have been called and the
write lock released.

So I think you can just drop this line?

> + *
> + * The fast path does not take mmap_lock.
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

This maybe warrants an unlikely() given it can only happen if refcount
overflows? Also worth having a comment to that effect here?

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

I'm guessing you're fixing this up as part of the patch? But it feels a bit
random, I mean fine but you should mention this change in the commit message +
explain why.

>   */
>  static struct vm_area_struct *uffd_lock_vma(struct mm_struct *mm,
>  				       unsigned long address)
> --
> 2.55.0.508.g3f0d502094-goog
>

--
Cheers, Lorenzo

