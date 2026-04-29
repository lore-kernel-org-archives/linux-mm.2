Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 351BACD13D2
	for <linux-mm@archiver.kernel.org>; Wed, 29 Apr 2026 18:20:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D8DAA6B008C; Wed, 29 Apr 2026 14:20:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CF2A46B0092; Wed, 29 Apr 2026 14:20:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C09156B0093; Wed, 29 Apr 2026 14:20:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id AAB986B008C
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 14:20:03 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 6DD601C03CA
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 18:20:03 +0000 (UTC)
X-FDA: 84712407486.10.A7EFFDE
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	by imf17.hostedemail.com (Postfix) with ESMTP id 5537F40008
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 18:20:01 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Rn80yLxV;
	spf=pass (imf17.hostedemail.com: domain of dave.hansen@linux.intel.com designates 192.198.163.8 as permitted sender) smtp.mailfrom=dave.hansen@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777486801;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=TqrbVhzF5sYhQ3XVwQ9/EV7j+9XCkuZiQaJT5XSGPc8=;
	b=KYQNfJXcCgXg6ztW5S4tRJtwF/D3LZD3wD2NiXV7q6TSNEsrDJCUXbxQg3J+tMk7tMQxyD
	RbfZX0Wt+lt52NwuW4z67asZsej/Z8gxXdEcetZc1MicH+PZWSzxSz+v49DQXRcPJ0wHH7
	AE78CVFLJYNpl4n/el7KUlocwFMVb3I=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Rn80yLxV;
	spf=pass (imf17.hostedemail.com: domain of dave.hansen@linux.intel.com designates 192.198.163.8 as permitted sender) smtp.mailfrom=dave.hansen@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777486801; a=rsa-sha256;
	cv=none;
	b=nzS3H7g+ENyTpsCYSssMkm4hJtmGKy861U87UyzmTod3fWnYfx57uAQrtV28eIBuqm8lU2
	VGouezbfBG2WQchqSIsI+KoPZGAb/YtShliW/Fly0M2Iu9vjNP0e3UwTam9wo6413qrjAp
	PbWSY2+Rnuz8Dlj3nCWu4NRiJHjWtuk=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1777486801; x=1809022801;
  h=subject:to:cc:from:date:references:in-reply-to:
   message-id;
  bh=MZR0sgC0OINAhIfiXWTKQMo/83zXaasXTmCU+0qPmhA=;
  b=Rn80yLxVC1Mva54LtJHzyMLWOvIt2zmVN6PVwMxnCUbX+onHspl3qcVQ
   YWIj0TkqslTIeBZfA/4rer/FptZmvgYgDnikzMa/TASvAg0ZBDdlxR6Rm
   6zUpcuPZ6jJcAoK5j4TnTMpSbESrrV95m2JDw2CxxnpaviIRtk0Cgpf0H
   wMnEOT8lwagXJuuACEvAal3JdGxvTLUO699s8QZpbTO7MB5f6wbdMngnc
   rPVorcfLOUMudcCINcZylAG3IKO26udoO07i4DIdTv1nw+5xgEE6GVVn0
   xKgEgEPn06UuvvS8wZsfMnzXo7yF3Z+CBOUN/Og36l9or/Eogq6SU/lGe
   Q==;
X-CSE-ConnectionGUID: VlkNvbCoQxWXGV5vn2+1JA==
X-CSE-MsgGUID: nrEHrJl+TrmhyC3Io/wtZA==
X-IronPort-AV: E=McAfee;i="6800,10657,11771"; a="95990100"
X-IronPort-AV: E=Sophos;i="6.23,206,1770624000"; 
   d="scan'208";a="95990100"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Apr 2026 11:19:58 -0700
X-CSE-ConnectionGUID: 5RlAuTAYS/eiJAWm9uHIOA==
X-CSE-MsgGUID: pKdk/cmhSf+g6DM4PSZ6bg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,206,1770624000"; 
   d="scan'208";a="239336394"
Received: from davehans-spike.ostc.intel.com (HELO localhost.localdomain) ([10.165.164.11])
  by fmviesa005.fm.intel.com with ESMTP; 29 Apr 2026 11:19:58 -0700
Subject: [PATCH 2/6] binder: Make shrinker rely solely on per-VMA lock
To: linux-kernel@vger.kernel.org
Cc: Dave Hansen <dave.hansen@linux.intel.com>, Andrew Morton <akpm@linux-foundation.org>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, linux-mm@kvack.org, Lorenzo Stoakes <ljs@kernel.org>, Shakeel Butt <shakeel.butt@linux.dev>, Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@kernel.org>
From: Dave Hansen <dave.hansen@linux.intel.com>
Date: Wed, 29 Apr 2026 11:19:57 -0700
References: <20260429181954.F50224AE@davehans-spike.ostc.intel.com>
In-Reply-To: <20260429181954.F50224AE@davehans-spike.ostc.intel.com>
Message-Id: <20260429181957.7511C256@davehans-spike.ostc.intel.com>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 5537F40008
X-Rspam-User: 
X-Stat-Signature: paorq41cigci9wfbdpdn1hzzomomyiuo
X-HE-Tag: 1777486801-568482
X-HE-Meta: U2FsdGVkX1+hstkGXxvc8R7ir9rtAeUbxnDlG7hPGHmxdFggK/rusgIZR0HrBdQed/6hw29J7iv0JLSd9hCo1kOs1N5YG8i7QY9caTgEeFbqCa3vsljljCevt5nKdwjv0pM67R/dSR8rrQ/N+rtW0W+1uL/xVuwlACHd8jXR/o5vM5LxLnRd/9Mq7OAnjNy73aCbqwHeyYrZ92j7H/1YPqCLKAy0CrFKKZDk/jOQn7bVpc/2spoQjZwFK7FSId2UUMYWi20cR0T/fmPZEF6CXk1ymTwvFQkEOa0G+lT5dsLbj/VPKXHK+qv24GbwN/IT7tTjumxFQkQYzkWna3noDZujp835bNmtfnMNYb9kYSJ18rDO9EQj3rJ7paIPeUOBoRD1IWZxC8mYdXYOITuojRFAw33WhTELNztzaxuYmvg0jxmuRx3M53RKtKhb61r/X+DkJcTp6D8AIlTN5l4AEFhhbUOWhRgj99tpdv+I13tGhqYtXIDX9+OmRB1lW3kVdGRiJwRDHhICA2IG/o1gyXDKUyUsTmWtivnVWR8L9AtOMD7IOZVlrdNTq7aDCxnn7zNepVLfNuIeDEJzPy+cqwvKLhx5j1VOEQIyMG+hzAUZ9p9DFebZ9by8j0SRzKisu/XE/atobls++5lcDfjugbkgEyBDpMgT4WfWbqefVz8k/k4o2tyn1cwLL57l94TtfVEgEV4jg5RdgvbsZ2QJvPmrTgecLXtnSvQDlDwKvaZezBZnbNAPZ+ziGQycHbPrX1j8oef16uNQo8q5wHQYE2riAtZNrjhBbA/tHSw+QPDRlkFYxxST38JCxBlRejshuOTbs23+3XVVICO5nPBCnUbRNy+bepF7GPxGnDBEyuE95fml9v8l1tLH9wX7akavYPrVw9/X+CVE9jY7ybXzHnA2EUxi/fcdBw/MGf7ke3gxjNVZk92dgr4NSp6/xhuAn0DABs9U1HuwYw0yLyF
 iu8QhNgp
 HnSxKpFuatiPBrHFmE4y+T2P2KYcrBydelWMbrxaOP46exCsgyKmdjLXy9dhfoADoSygAkk1pMtYshbZ9sV4TNFkHLct+CaQEJSWKez8ljqiL3bT0+VR5LzGrX1d1fK7d8xa8DiG9jedY8/ca9t1xygaVLFCzDkOP2QFRIZhbrtUoysp+AGRbUAwtyUJNed+bbBkRyFaDBZcamnJeDKGvFppGjDm2N3SqRZVlAVFCgAdBJLr9LUuFjEcWev5ouEE/dmllsu0C18ARhqdk7ikq6kwyAQFKtEASgrhQHCh7Yf1gNnuOETsOJaM8OdBnREyEQhWEfySN1pCCfuk4OIw7knMGvlU+bYEdUH89+2LnEtS5v0E=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


From: Dave Hansen <dave.hansen@linux.intel.com>

tl;dr: lock_vma_under_rcu() is already a trylock. No need to do both
it and mmap_read_trylock().

Long Version:

== Background ==

Historically, binder used an mmap_read_trylock() in its shrinker code.
This ensures that reclaim is not blocked on an mmap_lock. Commit
95bc2d4a9020 ("binder: use per-vma lock in page reclaiming") added
support for the per-VMA lock, but but left mmap_read_trylock() as a
fallback.

This was presumably because the per-VMA locking can fail for several
reasons and most (all?) lock_vma_under_rcu() callers have a fallback
to mmap_read_trylock().

== Problem ==

The fallback is not worth the complexity here. lock_vma_under_rcu() is
essentially already a non-blocking trylock. The main reason it fails
is also the reason mmap_read_trylock() fails: something is holding
mmap_write_lock().

The only remedy for a collision with mmap_write_lock() is to wait,
which this code can not do. So the "fallback" after
lock_vma_under_rcu() failure is not really a fallback: it is really
likely to just be retrying in vain. That retry in an of itself isn't
horrible. But it adds complexity.

== Solution ==

Now that per-VMA locks are universally available, lock_vma_under_rcu()
will not persistently fail. Rely on it alone and simplify the code.

Full disclosure: I originally tried to do this with
lock_vma_under_rcu_wait(), but it did not fit well with the mmap_lock
trylock semantics. Claude caught this in a review and suggested the
approach in this path. It seemed sane to me. So, Suggesed-by: Claude,
I guess.

Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: linux-mm@kvack.org
---

 b/drivers/android/binder_alloc.c |   22 +++++-----------------
 1 file changed, 5 insertions(+), 17 deletions(-)

diff -puN drivers/android/binder_alloc.c~binder-try-vma-lock drivers/android/binder_alloc.c
--- a/drivers/android/binder_alloc.c~binder-try-vma-lock	2026-04-29 11:18:50.066607065 -0700
+++ b/drivers/android/binder_alloc.c	2026-04-29 11:18:50.069607180 -0700
@@ -1142,7 +1142,6 @@ enum lru_status binder_alloc_free_page(s
 	struct vm_area_struct *vma;
 	struct page *page_to_free;
 	unsigned long page_addr;
-	int mm_locked = 0;
 	size_t index;
 
 	if (!mmget_not_zero(mm))
@@ -1151,15 +1150,10 @@ enum lru_status binder_alloc_free_page(s
 	index = mdata->page_index;
 	page_addr = alloc->vm_start + index * PAGE_SIZE;
 
-	/* attempt per-vma lock first */
+	/* attempt per-vma lock */
 	vma = lock_vma_under_rcu(mm, page_addr);
-	if (!vma) {
-		/* fall back to mmap_lock */
-		if (!mmap_read_trylock(mm))
-			goto err_mmap_read_lock_failed;
-		mm_locked = 1;
-		vma = vma_lookup(mm, page_addr);
-	}
+	if (!vma)
+		goto err_mmap_read_lock_failed;
 
 	if (!mutex_trylock(&alloc->mutex))
 		goto err_get_alloc_mutex_failed;
@@ -1191,10 +1185,7 @@ enum lru_status binder_alloc_free_page(s
 	}
 
 	mutex_unlock(&alloc->mutex);
-	if (mm_locked)
-		mmap_read_unlock(mm);
-	else
-		vma_end_read(vma);
+	vma_end_read(vma);
 	mmput_async(mm);
 	binder_free_page(page_to_free);
 
@@ -1203,10 +1194,7 @@ enum lru_status binder_alloc_free_page(s
 err_invalid_vma:
 	mutex_unlock(&alloc->mutex);
 err_get_alloc_mutex_failed:
-	if (mm_locked)
-		mmap_read_unlock(mm);
-	else
-		vma_end_read(vma);
+	vma_end_read(vma);
 err_mmap_read_lock_failed:
 	mmput_async(mm);
 err_mmget:
_

