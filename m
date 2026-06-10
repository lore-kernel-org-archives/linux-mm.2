Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B2004CD98CC
	for <linux-mm@archiver.kernel.org>; Wed, 10 Jun 2026 23:04:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 980B46B0092; Wed, 10 Jun 2026 19:04:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9581E6B0093; Wed, 10 Jun 2026 19:04:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 846EE6B0095; Wed, 10 Jun 2026 19:04:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6E3A96B0092
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 19:04:19 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E7685402BC
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 23:04:18 +0000 (UTC)
X-FDA: 84865533396.22.CEC61CF
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	by imf27.hostedemail.com (Postfix) with ESMTP id CCC6440014
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 23:04:16 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Z9a4OiD+;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf27.hostedemail.com: domain of dave.hansen@linux.intel.com designates 198.175.65.9 as permitted sender) smtp.mailfrom=dave.hansen@linux.intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781132657;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=nW/MkNqKpNcmdV8lFnGDIKZiDI67wlDbKABSFRbTi18=;
	b=YD6Pfnn7T9Z5q0Llt8eTW4zaY9Yf+Fv/c3oK1PheAhKciL5tWFtECJB7xMdcTCEuJwfGJv
	W2XnskczjyCV4YP3fjeRdE7wE7wL+hN6bxT4X3WTL6DhlpmsFP125hnncG9cwdNlrd7n6f
	/1s3WVp6VHSxsPdeexdkjFhGfJ+EHaY=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Z9a4OiD+;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf27.hostedemail.com: domain of dave.hansen@linux.intel.com designates 198.175.65.9 as permitted sender) smtp.mailfrom=dave.hansen@linux.intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781132657;
	b=U6jA2c2meJ+hDFasQQo8lCMgoUBG89WjZfhbSdO7Eyk7o8xH3g3F5MyjNR67aqUx+C2ARI
	5RWFqn4QP84g5szRpj+jTPGCWDQFaA4QSg6XZfmOOzXpzZ5FWZMCBr3XvpIoEbH8Zg7BHs
	WTWpsjLnrIZxK9J2ASQSmHzPcQ1sMJg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1781132657; x=1812668657;
  h=subject:to:cc:from:date:references:in-reply-to:
   message-id;
  bh=YMTGn3Jtq8t9a/GAlsJ7fAGE8GmUpxZi5v+8PMyag1I=;
  b=Z9a4OiD+nGBiFM+awvTuoZNd/q1MjGs+V+j8oUi5B4ThK/5YaPnp2xkJ
   jcII1vTfRiTSApOqBNyUuzM1UU4ENc2gJIJOJRyj5mQE7xM7Qdp+PRX0f
   H2EmCKa3Sk5MfrlL40veEt1JwS7RQPmCrHzJhF3TvbWjJKe3pABVRzAI6
   3GOFP7Mrh0B5OLofUgnNoIjjlXdsBXrroPrbE/9YSdGIsYyqNVNtwgIuB
   T0HgkvU2GhKm9DPnaPzQFs78SZc8h0shcbaiYaR6TomLUFTZKI/sa97qM
   yglNbtbo5vLK0wd90Li/QTjXerwyNyva+LB2EeoqANCkNyZdu6HexWGx9
   A==;
X-CSE-ConnectionGUID: PAhilGMKSZmLlE+TIrvhaQ==
X-CSE-MsgGUID: E+fDull7RlCHhh9hNp9U5A==
X-IronPort-AV: E=McAfee;i="6800,10657,11813"; a="104603453"
X-IronPort-AV: E=Sophos;i="6.24,197,1774335600"; 
   d="scan'208";a="104603453"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jun 2026 16:04:17 -0700
X-CSE-ConnectionGUID: VAoVMoCGTiu0MuNDStwDkw==
X-CSE-MsgGUID: ve2wlplyQh68zV5YbqGBxA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,197,1774335600"; 
   d="scan'208";a="251409782"
Received: from davehans-spike.ostc.intel.com (HELO localhost.localdomain) ([10.165.164.11])
  by fmviesa005.fm.intel.com with ESMTP; 10 Jun 2026 16:04:15 -0700
Subject: [PATCH v2 3/5] mm: Add RCU-based VMA lookup helper that waits for writers
To: linux-kernel@vger.kernel.org
Cc: Dave Hansen <dave.hansen@linux.intel.com>, Alice Ryhl <aliceryhl@google.com>, Andrew Morton <akpm@linux-foundation.org>, Arve Hjønnevåg <arve@android.com>, Carlos Llamas <cmllamas@google.com>, Christian Brauner <christian@brauner.io>, David Ahern <dsahern@kernel.org>, "David S. Miller" <davem@davemloft.net>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, linux-mm@kvack.org, Lorenzo Stoakes <ljs@kernel.org>, netdev@vger.kernel.org, Shakeel Butt <shakeel.butt@linux.dev>, Suren Baghdasaryan <surenb@google.com>, Todd Kjos <tkjos@android.com>, Vlastimil Babka <vbabka@kernel.org>
From: Dave Hansen <dave.hansen@linux.intel.com>
Date: Wed, 10 Jun 2026 16:04:15 -0700
References: <20260610230409.A44D29FA@davehans-spike.ostc.intel.com>
In-Reply-To: <20260610230409.A44D29FA@davehans-spike.ostc.intel.com>
Message-Id: <20260610230415.C0521C88@davehans-spike.ostc.intel.com>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: CCC6440014
X-Stat-Signature: 719e5dxbzcw41zme6foe4amesy73nzep
X-Rspam-User: 
X-HE-Tag: 1781132656-868211
X-HE-Meta: U2FsdGVkX19jSmSpB//CXkBXvvH8ydhgPl/5ZPYVqGnhsBCp/AHGHU2k+p1D5otrVZtBfev27pZjKEuBoyVvtByuO+pxlcgR9qhQHRHc+Hf8BGQuPPO40sWTd2T2CSbTB5MAMlh+0CNL/uLWijUL6loljqTs80ZX2yrmqd4pNkKZoR22IquSOfBIEN3zOZE+HJ+oAAg50MQcaJZPehVKkAXVlOxjvQlCjidASeU+ghQheWj7msrMHxpkfZcLE0ekvWifLf2XXwDg1Aop0VDXYvnsAOCo2+h52jD0zh4EW43mv5kurM5wg4zzur1L1DPxKiTF8cR8fdD2NJ2273oZHeMgR004mqnhPKOwxti1EM7pFXBj3F6LEOxXOre4z6zO5iTidOmNavMHHAbIY1xD9sYXeEvGq6YaOmtlF6SYw141akmgQ15ekFFV6tHcT8EZOZuzJm++0dUm593bMqD58Eu7wjkFbVVG2Ju+SH6jy6nYcLnilSoFWEMXIm6IIapW2ZgzVEqcTyKljAH5pLbV1sqKYJ7ziFPT9zhNd8A9yYOMqHPLs/gHQDBsJq+8kUo6hl05CPzmh1PPj3WaANQ3s8KN8M877H1mmuvdJ2ykli1vf/+AdUMu3ndTQ7FwF3wM3+iCS8cqv4PU8P4eTTkhT4/EFMTWLX87EY2RtoS4M8YEUqCQdSumU9IXT810Ux/XlMMC7DyDpWk/CD+Gfop0CPsRWNQhxEp4CcbLdJnzpraV1l/PeljfQyM2su1qcQas9bPtlT4mFltZyFCcObPkH+t9pg5p8u3kJd7dE4HuD7QZmG7MyWpEODje6jgwBylyTu5Hm27wi8Dh0rsKvt3Tm3fRAywvlZ0FERzZ6Atc6ahOAoPg2cZE0lMv2aH1fB8Bx8qPy7sU7lQ7n4++lhb5+RtrGeBhYM289LbqmttV28Gqa6dr/VUcNHbrcMDCNhG8+2LY5NWLWBTDt/AnXv7
 tL3yBrew
 8e8dRp+LESoefBQG+9y52eslJhwLhVnrd938Sjau/99TwOnAXkP3ne978e1HznGRTMWxYJhkyefRDRGvRQze0dtnR0BRf/wgEYGYioeZvDt/LsyB0qzL42LfJEpHc8oHg5MJBFQhlJFCwep2hKBgN8GvjN2fpyHdT/Aw3uUGcFpLuuP5juTcHNIwOEi8eJ0itLVqPEHeJR22Ov2WGGVmDUgx2HCneDlKmcpPNF8zU1cN7nJQ5QfcUa8vRAOK48K4+1atqULN6SjCr9ITGGCDfDRMj3xC4q68fN/Qq8XERgPrLsnYGW2siYj5V/RxvpvszZONmq6Qhu2+sXbRB/GPlpUXS25UhLxFl454o/Kf7ayA5G25f+f9Sf095DvVFFafPqWpyKByibZyarj/0SKb61t7o6SbugMDkj9X2KjudIRePMjEuzWdFrKY0eIVYWA1LwPkMEE0u4E6B8qvtxsOpPEUMXIZDo11RrMHBFIILTiBAEx7Xm4ip/2o43yZ2bVMVzMinCORjaA85+KKeMJ0c7j4e0WG0FBXdwdZGNqja+kN42wlJstMH53EACy/4D4h/bU8hnm12XaW3xohLOxcO1O4LUF7VQPC0FrEWByqr/gHvks84Sgy7ORPmVaNuPoZa+wphD/p01tdaPA0223lC45ARDg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


From: Dave Hansen <dave.hansen@linux.intel.com>

== Background ==

There are basically two parallel ways to look up a VMA: the
traditional way, which is protected by mmap_lock, and the RCU-based
per-VMA lock way which is based on RCU and refcounts.

== Problem ==

The mmap_lock one is more straightforward to use but it has a big
disadvantage in that it can not be mixed with page faults since those
can take mmap_lock for read, which can deadlock when mixed with page
faults. For example:

	mmap_read_lock(mm);
	// Another thread does mmap_write_lock().
	// New mmap_lock readers are blocked.
	vma = vma_lookup(mm, address);
	// This deadlocks on mmap_read_lock() if it faults:
	copy_from_user(address);
	mmap_read_unlock(mm);

The RCU one can be mixed with faults, but it is not available in all
configs, so all RCU users need to be able to fall back to the
traditional way.

== Solution ==

Add a variant of the RCU-based lookup that waits for writers. This is
basically the same as the existing RCU-based lookup, but it also takes
mmap_lock for read and waits for writers to finish before returning
the VMA. This has some advantages:

 1. Callers do not need to have a fallback path for when they
    collide with writers.
 2. It can be used in contexts where page faults can happen because
    it can take the mmap_lock for read but never *holds* it.
 3. Its fast path does not require taking mmap_lock for read.

Basically, when applied correctly, this approach results in faster
*and* simpler code.

Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: linux-mm@kvack.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Arve Hjønnevåg <arve@android.com>
Cc: Todd Kjos <tkjos@android.com>
Cc: Christian Brauner <christian@brauner.io>
Cc: Carlos Llamas <cmllamas@google.com>
Cc: Alice Ryhl <aliceryhl@google.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: David Ahern <dsahern@kernel.org>
Cc: netdev@vger.kernel.org

--

Changes from v1:
 * Add a comment explaining that this can not be mixed with other
   per-VMA lock or mmap_lock users. It is prone to deadlocks if so.
 * Add a FIXME about making the mmap_read_lock() killable
 * Add more chaneglog bits about the possibility for an infinite goto
   loop.
 * Adopt vma_start_read_unlocked() implementation from Lorenzo
---

 b/include/linux/mmap_lock.h |    3 +++
 b/mm/mmap_lock.c            |   27 +++++++++++++++++++++++++++
 2 files changed, 30 insertions(+)

diff -puN include/linux/mmap_lock.h~lock-vma-under-rcu-wait include/linux/mmap_lock.h
--- a/include/linux/mmap_lock.h~lock-vma-under-rcu-wait	2026-06-10 15:57:55.828431712 -0700
+++ b/include/linux/mmap_lock.h	2026-06-10 15:57:55.834431925 -0700
@@ -257,6 +257,9 @@ static inline bool vma_start_read_locked
 	return vma_start_read_locked_nested(vma, 0);
 }
 
+struct vm_area_struct *vma_start_read_unlocked(struct mm_struct *mm,
+					       unsigned long address);
+
 static inline void vma_end_read(struct vm_area_struct *vma)
 {
 	vma_refcount_put(vma);
diff -puN mm/mmap_lock.c~lock-vma-under-rcu-wait mm/mmap_lock.c
--- a/mm/mmap_lock.c~lock-vma-under-rcu-wait	2026-06-10 15:57:55.831431819 -0700
+++ b/mm/mmap_lock.c	2026-06-10 16:02:50.723860779 -0700
@@ -338,6 +338,33 @@ inval:
 	return NULL;
 }
 
+/*
+ * Find the VMA covering 'address' and lock it for reading. Waits for writers to
+ * finish if the VMA is being modified. Returns NULL if there is no VMA covering
+ * 'address'.
+ *
+ * Use only in code paths where no mmap_lock and no VMA lock is held.
+ *
+ * The fast path does not take mmap_lock.
+ */
+struct vm_area_struct *vma_start_read_unlocked(struct mm_struct *mm,
+					       unsigned long address)
+{
+	struct vm_area_struct *vma;
+
+	/* Fast path: return stable VMA covering 'address': */
+	vma = lock_vma_under_rcu(mm, address);
+	if (vma)
+		return vma;
+
+	/* Slow path: preclude VMA writers by getting mmap read lock. */
+	guard(rwsem_read)(&mm->mmap_lock);
+	if (!vma_start_read_locked(vma))
+		return NULL;
+
+	return vma;
+}
+
 static struct vm_area_struct *lock_next_vma_under_mmap_lock(struct mm_struct *mm,
 							    struct vma_iterator *vmi,
 							    unsigned long from_addr)
_

