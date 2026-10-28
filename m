Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B7101606A320
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 15:43:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key, unprotected) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=nkmMZXJf
Received: by kanga.kvack.org (Postfix)
	id F41806B05C0; Wed, 28 Oct 2026 11:42:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EEEA36B05BF; Wed, 28 Oct 2026 11:42:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D97A46B05BF; Wed, 28 Oct 2026 11:42:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A5D5C6B05BF
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 11:42:52 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 30F4EA0142
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 15:42:52 +0000 (UTC)
X-FDA: 85372452984.27.6D8DD2E
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf20.hostedemail.com (Postfix) with ESMTP id 006B91C0009
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 15:42:49 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=nkmMZXJf;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf20.hostedemail.com: domain of liam@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=liam@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793202170;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=laIB3FyK7mnPgkdSTmIIOXUp7l8bl3ekGNuGdqFlOuU=;
	b=Z9VrPuE7InpWJd9SnqeHNt+/jNecXyPQs1MWs7ACni+9BdrMk5gqoPvy6k9oSgAk0XIA54
	UCJ/AapROWbV4aynjbCj27de2aO1gVU7tbnyA6eTGtPUzYA/7jH4/edKzWFcJnZIwIIhOt
	gc8ViC8q006Yt1F9qyt/fXASu0Oy4Eg=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=nkmMZXJf;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf20.hostedemail.com: domain of liam@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=liam@infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793202170;
	b=mZc276gPZMtVjgIJPCdpvemKQ+8tofcVB7OvmdC8VwEhqQrvzJPSLm7jQ4g8ZuB6+xdQol
	3yY9CJaiFZFhLIDW5A8jHG7WqlGRLiCpc67FL9OC9Ig8bX5b8HriMfhj/6WYjigGYlOZoT
	dHMObpfZ6zTmEM9SyFAH5unpi8kb9KY=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=laIB3FyK7mnPgkdSTmIIOXUp7l8bl3ekGNuGdqFlOuU=; b=nkmMZXJfeGqa7UScd2rHUQdC+A
	dsV0cxZYlPh1r37Yh6z4vUoKYuinfS+v/XHrjmBV7mEZo4VeAzSz/TsOjw62Wn7wXMX3KhU3cEDX5
	hZWyvcOirsc/PgH4DmrxNkhFOqShkMGDGO7RszWaDIVl6kCdkO6gvZIf6ZEJyZwXmwFitw5o4jm77
	bFEN//pS/GhetmM5UMMKQFYnhrG5TJ14Xa0zJt/7rtq8AP/OgPPJU6v+FpaPWnRmtR8rhHQ8sMGt3
	xb+C/W5TwSGBfVGmxLGp+0vU9g+JCd7533QORT3HzIcEjcMWzGE7rBsf01364yRKvXO/ruZWWT5Z2
	fZDQfB4g==;
Received: from [38.23.173.23] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xM5nc-00000007Qqk-3bP3;
	Wed, 28 Oct 2026 15:42:49 +0000
From: "Liam R. Howlett (Google)" <liam@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	Thomas Graf <tgraf@suug.ch>,
	Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	maple-tree@lists.infradead.org,
	Lorenzo Stoakes <ljs@kernel.org>,
	Chris Mason <mason@kernel.org>,
	Alice Ryhl <aliceryhl@google.com>,
	Andrew Ballance <andrewjballance@gmail.com>,
	stable@vger.kernel.org,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	"Liam R. Howlett (Google)" <liam@infradead.org>
Subject: [PATCH 4/4] rhashtable: fix vmalloc() deadlock in atomic rehash
Date: Wed, 28 Oct 2026 11:42:18 -0400
Message-ID: <20261028154218.1668182-5-liam@infradead.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261028154218.1668182-1-liam@infradead.org>
References: <20261028154218.1668182-1-liam@infradead.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 006B91C0009
X-Stat-Signature: 6dcikbgn8sujqchscmtmk34c8sneou9j
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1793202169-859899
X-HE-Meta: U2FsdGVkX19JTUYlyNsETJIP9zuOxMH9sCwObqUYhlgtV6xn3FKLCutj8p4272vRGM5RrV8aIZfUPZjIE3PFf/WaxcLi2xjnxmmPfoZobslel361H6deshhU50i5vxGKgHxDQ2vTmY7hiOO9W7qma8jIJX2/CWgY5hjp6Jz24jC9KVqJv8fqqK4EKrePfeyO3Gh1xD0CNtIn8tef39WcgZCZMrNICI4x0C3GoN334lQmWw3B9QNXqqMmoiamUQI9k6GhhMeX6NcawmVKRVwpaE0o15k2nFCclWfv6dv1opj2/XQN/c9I1EHdZmRkM+duO9s0XE1VpXGVzc/cVVmuNsrIrEuNIZRrHDmq5rRr4/1tD6S6fDngbuwG8LauPNa7TPNyJUUotQ57FqMjo1fg9v2xkHkpCHjDtjonEIKGpwo/r64KVnjexznsA1JcGxlW/Uu5gZ1S7NQP3iQdL4bgQVpdW40gMTa1h8dkBJqxh2D6FCrpvrHH7QE4BlaR/kkHRNwoCWNtHl2k7mn4ZZ2GBaJy3haee2AWF9ehRyEWo9gpYVezSCH3uqiMJIrL+CJl5PiIwOIm2IyAtIH+tXKlP44KOZglLSrphM/xGPKdo1WrHDJ6xeaxuH1vpTMyaAphGPUiwvB2iZxviaeQ4zpyqi6edGhDENsExOuBSs6vwQqM+stNg9nnT74l4jSvX+3Y8Q0QJ2vYQMf0rqppGEtumLhd7svmRIcjbRXG4cS0b4U/mQ70+SZG9k+MSOCWuoAGF24oGXx8DVox6caoSW6Lxj+YPXZiTuc1q5VHvJa6bWtD5KxoDJvCw3NonjB3Mv1XZoMBI53h2XSyyNqyq4NBDpNO56hQl8z8Zz2GdmNMbfoJdU6uiwT+WFkVB00R/+SA5Q884BGW29JheizcBFw5U1AkYNg7qi5SXBP3aOjDLyoBt+w4ZNahEblijIVquayWpAyD0zk5C1Qw9XR4EKA
 Ku+NTrAw
 zvmm6OkQZ7XE0EPt8Y/FOgPPzyZ3vd1zyFGouqaJHfGO7+sw+xW1X5zR5UzoPMahYPZrZA58jbGyCOQb6FHpD2gwPXDT3z0Br37NSFApcJFLHbxBLS4bcqnh206kV1Ms/sAVQz4lLXLfkdER0cLW4oVSHUBtrecgKE7Are767w4UJuvQo5xx/IQ6mb/FwTDqrIUaEKlFiZkP75GuXY0alwbtiaa9bwZQp/F18AhEKpcCuEnsA6ZZPN5P55C2Ub7iOu8JzwWi3kfRcaP/OmxfLx02QTB+34KSfltSY+Up5vr8HIsp5EsnG23J3rBFpES622r0+
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Chris Mason <mason@kernel.org>

An unprivileged user can deadlock two CPUs by filling the forwarding
database (FDB) of a bridge in their own network namespace. A peer that
floods a bridge port with frames from new source addresses can fill the
FDB too. The flood alone was never seen to cause a deadlock. Together
with local tasks that call vmalloc() in a loop on the CPU that receives
the frames, it can deadlock that CPU. Other CPUs that call vmalloc() or
vfree() after that can hang too.

The FDB holds the MAC addresses that the bridge knows. It is an
rhashtable, a hash table that grows as it fills.

An rhashtable normally grows from a worker. If an insert finds the table
too full before the worker has run, rhashtable_insert_rehash() allocates
the larger table immediately, with GFP_ATOMIC, in the context of the
insert. bucket_table_alloc() uses kvmalloc() for that.

kvmalloc() tries kmalloc() first. Since v6.19, if kmalloc() fails, it
falls back to vmalloc() for non-blocking GFP flags too, and kmalloc()
always fails above KMALLOC_MAX_SIZE.

vmalloc() and vfree() take their spinlocks with bottom halves enabled.
Such a lock must not be taken in a softirq, or while holding a lock that
a softirq takes. In the bridge, an insert that falls back to vmalloc()
breaks the second rule: the bridge inserts into its FDB under
br->hash_lock, and its receive softirq takes br->hash_lock as well.

Below, one CPU adds an FDB entry for an RTM_NEWNEIGH netlink request,
while another CPU is inside vmalloc() or vfree():

    RTM_NEWNEIGH                      vmalloc() or vfree()
    ============                      ====================
    spin_lock_bh(&br->hash_lock)
                                      spin_lock(&vn->busy.lock)
    rhashtable_insert_rehash()
      kvmalloc(GFP_ATOMIC)
        vmalloc()
          spin_lock(&vn->busy.lock)
            waits for the other CPU
                                      softirq: a frame for the bridge
                                        spin_lock(&br->hash_lock)
                                          waits for RTM_NEWNEIGH

The receive softirq also inserts into the FDB itself: on a learning
port, br_fdb_update() adds the source address of a frame if the FDB does
not have it yet. If that insert falls back to vmalloc(), it breaks the
first rule. The CPU then deadlocks with itself if the softirq has
interrupted a task that holds the same vmalloc lock.

Reproduced on x86-64 under emulation, with three things going on at the
same time:

- RTM_NEWNEIGH requests filled an FDB past 262,144 entries, where the
  next table is too large for kmalloc() on x86-64.
- Frames arrived on a veth port.
- Tasks called vmalloc() in a loop.

Two CPUs ended up spinning on each other's lock.

The softirq path was reproduced too, on x86-64 under emulation and with
RPS set by root. Repeated floods of 280,000 source addresses on a veth
port, while tasks called vmalloc() in a loop on the CPU that received
the frames, ended in a soft lockup in alloc_vmap_area() in 6 of 6 boots.
Without these tasks, on a kernel with no debug options, none of 33
floods reached vmalloc().

Fix this by calling kmalloc() instead of kvmalloc() in
bucket_table_alloc() if the GFP flags do not allow blocking.

Known gaps:
- By code inspection, bpf_iter_tcp_realloc_batch() and the dm-bufio
  clients that set no_sleep also call a non-blocking vmalloc() under
  spin_lock_bh(), and can still deadlock in the same way. The later
  commit "mm/vmalloc: fix deadlock in softirq and BH-off callers" fixes
  them.
- If kmalloc() fails, the atomic rehash falls back to a nested table, as
  before v6.19. A nested table is built from single pages, so it needs
  no large allocation. An insert then fails in two cases. If the nested
  table cannot get a page, the insert fails with -ENOMEM or -EBUSY. If
  the new table has 512 buckets, that is too few for a nested table, and
  the insert fails with -ENOMEM.
- A lookup in a nested table follows up to three more pointers until the
  worker has rehashed once more.

Changes from the LLM patch:

Dropped the __GFP_NOWARN from the kmalloc_noprof() when
gfpflags_allow_blocking() is false since the only non-blocking caller
already sets the flag.

Tried to make the alloc_hooks_tag() multi-line call more readable
(whitespace changes only).

Cc: <stable@vger.kernel.org>
Fixes: c6307674ed82 ("mm: kvmalloc: add non-blocking support for vmalloc")
Assisted-by: LLM
Signed-off-by: Chris Mason <mason@kernel.org>
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Liam R. Howlett (Google) <liam@infradead.org>
---
 lib/rhashtable.c | 18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

diff --git a/lib/rhashtable.c b/lib/rhashtable.c
index 6362896e4f099..f8ec85bc6e8af 100644
--- a/lib/rhashtable.c
+++ b/lib/rhashtable.c
@@ -193,9 +193,21 @@ static struct bucket_table *bucket_table_alloc(struct rhashtable *ht,
 	int i;
 	static struct lock_class_key __key;
 
-	tbl = alloc_hooks_tag(ht->alloc_tag,
-			kvmalloc_node_align_noprof(struct_size(tbl, buckets, nbuckets),
-					     1, gfp|__GFP_ZERO, NUMA_NO_NODE));
+	/*
+	 * vmalloc() takes locks that are not safe against interrupts, and the
+	 * emergency rehash runs in whatever context the insert runs in. So a
+	 * caller that cannot block gets slab memory, or else a nested table.
+	 */
+	if (gfpflags_allow_blocking(gfp))
+		tbl = alloc_hooks_tag(ht->alloc_tag,
+				      kvmalloc_node_align_noprof(
+					struct_size(tbl, buckets, nbuckets),
+					1, gfp | __GFP_ZERO, NUMA_NO_NODE));
+	else
+		tbl = alloc_hooks_tag(ht->alloc_tag,
+				      kmalloc_noprof(
+					struct_size(tbl, buckets, nbuckets),
+					gfp | __GFP_ZERO));
 
 	size = nbuckets;
 
-- 
2.47.3


