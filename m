Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E9EC3C5AD2C
	for <linux-mm@archiver.kernel.org>; Sat,  8 Aug 2026 09:02:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8FECF6B00A6; Sat,  8 Aug 2026 05:02:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8D6596B00A9; Sat,  8 Aug 2026 05:02:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7C57A6B00AA; Sat,  8 Aug 2026 05:02:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 551976B00A6
	for <linux-mm@kvack.org>; Sat,  8 Aug 2026 05:02:11 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E2A61A20D5
	for <linux-mm@kvack.org>; Sat,  8 Aug 2026 09:02:10 +0000 (UTC)
X-FDA: 85077510420.15.2D9905E
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf17.hostedemail.com (Postfix) with ESMTP id CFCEB4000E
	for <linux-mm@kvack.org>; Sat,  8 Aug 2026 09:02:08 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=BVdRq9Ub;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf17.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786179729;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=i25+lI2q8WnrC5a18HSJkcZlF/JN3MlaxK8/+QXZiCY=;
	b=W4TcGnXEXtEeHkLBoXHJfthBhZTHMhaRwDiO/U+5IbSLxzLVwTon10hky9nhwIIL9Fk+cP
	Qu5kpagEV7KU7jgUp/bcsZo0F+yvH6aPd2Vgwgh/leUk1Im74QGjfj6kU0oeIsaiipnn7p
	HE10ebhXHMNntQ0pNG/N1ilXnCNYygg=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=BVdRq9Ub;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf17.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786179729;
	b=k9KERSk1rFl2vuCcZx8Cr0GIVX7itqGCfQjKviTdNc+CbOwu1Yl5AXGARUp98z01EyWmaA
	2Sk1tsvzfVZg+XgDQyEZsvxr+7MKleL65inpm1/N2YN8MWF51E7yQGaME0NkJnA7YPKVvI
	7sRzsWX3SBdfTZbXZJgyp4u1ozd26Xw=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=i25+lI2q8WnrC5a18HSJkcZlF/JN3MlaxK8/+QXZiCY=; b=BVdRq9UbvI/M0u/TLUL0NocVdk
	HVYbTisDtERvwSWi5Yz70hqfKSdSwIl8E5T/mUHS+0yZkaJUWss0RcOqTTdPiqCn8/a+Rjd5Clao8
	FwBXwUmMDAVSegrqXQTE7tNrU9iTzbG/+vPy8XpZ9NcX7ebZdp0KODA2ftyba4dQMkQL+v/nuAmRf
	7p1UjWBIxBrjRXPltK8BgrfsiycNfZvEgcBd7QVeMotqnKgz278HcnIwG19zTs6klmDttFJnhmGYx
	TVnL6O4bV55W1EI/CUy2vhFFSqtfaK3hmH3uv1C9cDiAhEBZQlavkiWgl8iS5s5idgMHpVglcsbv+
	P8KgkxHw==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wsbPr-00000004jNh-11E4;
	Sat, 08 Aug 2026 07:24:23 +0000
Date: Sat, 8 Aug 2026 08:24:23 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Suren Baghdasaryan <surenb@google.com>
Cc: akpm@linux-foundation.org, dave.hansen@linux.intel.com,
	Liam.Howlett@oracle.com, ljs@kernel.org, david@kernel.org,
	shakeel.butt@linux.dev, vbabka@kernel.org, jannh@google.com,
	aliceryhl@google.com, arve@android.com, cmllamas@google.com,
	christian@brauner.io, tkjos@android.com, dsahern@kernel.org,
	davem@davemloft.net, gregkh@linuxfoundation.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	netdev@vger.kernel.org
Subject: Re: [PATCH v4 3/5] mm: Add RCU-based VMA lookup helper that waits
 for writers
Message-ID: <anbZpzFbtYG7Ngit@casper.infradead.org>
References: <20260806200548.3124802-1-surenb@google.com>
 <20260806200548.3124802-4-surenb@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260806200548.3124802-4-surenb@google.com>
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: CFCEB4000E
X-Stat-Signature: 64bernqkozoqirgcjgibj36gw5dushtc
X-Rspam-User: 
X-HE-Tag: 1786179728-1444
X-HE-Meta: U2FsdGVkX1+8jBFqgqXc5bcnsEnOtb2EEIWBeyU03zfkgHXFGCRna4gq1LUHGALjY1YZJY36xnWV/sAvwH7jVUDcR5s4WhIYYnfaJ28ie45d2EAkwOgCRQ77IA6NkJj6WivvPic5+99Ohotwgmr2svlZNRO0peOR2jk9dvk4QDvlzc5uxSpg04AzXLECXnZjBH+AdnXpFNn/3K8I60XqASOfWkzPG/g1XHFAwbm3LMwF/HajAG9e/m4qJDuaGtbcKNuzrdcwRWg90r79izLS8vDVqjiAqZmyvx/jQ/RE4ydW18ze5g9TD+50tbla3Yio6LQkD8p7YLLa0FoMnNX3wh8wzooFfucZdSaoJgyKOskaUu9hazqdRJkxtonv/564jW8Mft0VZBHmp+smuRKEz5qOgnvYjwrl6/tBNssNrRoz7ChUme7XUL+vUhDe4aO9skbNGuzw8B/uxbnv63w347e67qDQUhEsMIpFidDfHpGHmCeh+j07E81Fdr+2SXVWKxJEwlJW/8ryviigH8e0+c+T34A+2yXwYAccKsBmDQT4GVIMhkxwrCwYePn0G6QWr8qaJnnFlmx4vmFX69R8vy+wa5s5xo5bPuMWZvT36nIS8+j5TDxxR9NNLu4hz+5VwNWfT84pqEr8IhYgFd3S6Y52mW2aXLCyLK/uRrOSawlH62poesU5SyJ3v8zyRELXTJMKKqQ+/tBjixYcyyEcN68HWz37n50KTR6CgG4EH9wakYC9LAR3EVPdSLb5Kv/s5ZfHysojpRyqYfyjbvGi3Vbb+LIsOmXwPVca6DQWKQ/jwi0kQ5oxakPEzyms+Aoa4matd6jnWvkjXukNtaWwnBI4QU5FVd1d7R5v31YlJVE6WAgl4QHr6+KYtP2ry+Q5qUAUJsB6hOO3HzKz1elgvRyAID2p2skzL4D/pTM+4gtKwrnrBnh4J1Q9p9uK6aheF7aRmuVVDEM3jdEMeB9
 1tIPrnJq
 CH96XUcVmE3u4adxE5tqMn2gn7S2stePPT4+hFCKPO5Fpr7GdAne2if0Ve4wQYq+8zRNu6oMYwzzwE45PmBfEZiuliq+Ec3C6pN+pRlQrHSiCKwt+gpNj+X67KYIFxtgYjg6IB9mPibl92AMAy0xpcMrjS15ftMla0rDo7UPIpdIMDvQr6gYzzwQOy3SNtv77XzRBRrXugHXjRvTld/MhGvSUUUOmoNLGniCmghMQPrKgWD1BU/emH6mYngtFfmiCRHAJ1I53RG+jhQU7gj6zBVE+YkIQkgQCKkzOi6YbjMUd03OUdJNMGEy6EtKw3njbv/qtRSK9BPGw1oGizFzlh9H0kg==
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

I think we can do without the headings?

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

Umm.  I don't see how this avoids deadlock.  Assuming the next patch
converts copy_from_user() to use the VMA lock, surely the following
situation would obtain:

A takes mmap_read_lock
B tries to take mmap_write_lock, blocks
A calls copy_from_user()
A calls vma_start_read_unlocked() (because it doesn't know A actually
holds the mmap_read_lock() already)
A does a lookup under RCU, but gets NULL back (maybe it's calling
c_f_u() with an invalid address?)
A tries to take the mmap_read_lock again to make sure.  Deadlock
because B is waiting for A to release the mmap_read_lock.
 
Am I missing something?

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

