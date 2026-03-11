Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D7325104C00D
	for <linux-mm@archiver.kernel.org>; Wed, 11 Mar 2026 12:09:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2F33C6B0089; Wed, 11 Mar 2026 08:09:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 28E856B0095; Wed, 11 Mar 2026 08:09:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0CAC56B0089; Wed, 11 Mar 2026 08:09:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id CDF246B0092
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 08:09:48 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5AD04139064
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 12:09:48 +0000 (UTC)
X-FDA: 84533663256.25.C9B6A9C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 407EF180011
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 12:09:46 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=UYRl4yvJ;
	spf=pass (imf16.hostedemail.com: domain of devnull+lenohou.gmail.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+lenohou.gmail.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773230986;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fQfBx1d18iCcvkLiGqjBF027ddFJUBvJQ40fNsY+Q6k=;
	b=dYk+jCpIzN6q1nOwVq+RW4WgfctKzQyhWeDJ55u75UbafYIUKCgGn5DetMAldWtG+fj92U
	wpHuldROQ4+n8QFKMC7HPuANnQ/kesq4tvytmg2+kLAw7YWtcaO9/dQhbOe9a6QgpQkJzE
	K3FAW/DQ+UVnY9ALoWbBezw2Yxv3mGo=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=UYRl4yvJ;
	spf=pass (imf16.hostedemail.com: domain of devnull+lenohou.gmail.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+lenohou.gmail.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773230986; a=rsa-sha256;
	cv=none;
	b=LC7piRqzo+4LDJv7F3tSiuRXKXCB715Qm/NB8cqYrFVWOPVtx23eObSgQiHzM8Mxc38VG7
	gEowZSRHbCtoDmTI434ZmHa8/bn0yJg8iqaml16Ex4G1sEfT72C9EUMej8GzuDS2hCa1O3
	jP+fJs0mSNwObS+j0Y5KBrj5H3QuKjE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 3B9E7444BD;
	Wed, 11 Mar 2026 12:09:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 0F8F7C116C6;
	Wed, 11 Mar 2026 12:09:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773230985;
	bh=rC4pO0IWDnF30bVsp69mvTMcZsws+nEtxbxlusOjQe0=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=UYRl4yvJ1o4wr+mqNseUyHMbQOZURSNHbP4V4dIZl3aZ0sIr866pecEB7LC+GkH66
	 P7fmi3kYTdCBkV9apJ+2jzqAEoZ0jKUbqQRNZ8gxAoNcegC0fbdlw7MefpE10Ya10s
	 f37nIaa836ItyxNF6I/aWcnb0dysRdFLY677hYIKbShDb95Ma2x3wnMBA+jZMQfp+n
	 Xlf6BFnXXhPEpCy+Ni1tdppTXFd2zAk2dlrzMvtMrCidOzOi/i6m/uFbGfKekcWcCQ
	 xs6GPZXZMA/oFd0AqfYoPzLaNVDaZTdh4TLBAoRDDgUGqfZbeeKNocE2+8Jm0JrXil
	 yBfB2Vxo2PK4A==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F38861062874;
	Wed, 11 Mar 2026 12:09:44 +0000 (UTC)
From: Leno Hou via B4 Relay <devnull+lenohou.gmail.com@kernel.org>
Date: Wed, 11 Mar 2026 20:09:43 +0800
Subject: [PATCH v2 2/2] mm/mglru: maintain workingset refault context
 across state transitions
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260311-b4-switch-mglru-v2-v2-2-080cb9321463@gmail.com>
References: <20260311-b4-switch-mglru-v2-v2-0-080cb9321463@gmail.com>
In-Reply-To: <20260311-b4-switch-mglru-v2-v2-0-080cb9321463@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>, 
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
 Wei Xu <weixugc@google.com>, Jialing Wang <wjl.linux@gmail.com>, 
 Yafang Shao <laoar.shao@gmail.com>, Yu Zhao <yuzhao@google.com>, 
 Kairui Song <ryncsn@gmail.com>, Bingfang Guo <bfguo@icloud.com>, 
 Barry Song <baohua@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Leno Hou <lenohou@gmail.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1773230982; l=5011;
 i=lenohou@gmail.com; s=20260311; h=from:subject:message-id;
 bh=mpnWMW6S89qGDIwaKivQjNoGDsv2soTWaW1Gf6K14EE=;
 b=xcndljvTygCcwBzsgj8nOw/iRC7PBqzNOjNrqjCnt1Bogi0UldgGc+rLPInShme/2seEjuxVE
 5txGqDKNySACcCOr+H31oDye4fgESyq3o03RYnnnbcViC1fsrV+Y3ed
X-Developer-Key: i=lenohou@gmail.com; a=ed25519;
 pk=8AVHXYurzu1kOGjk9rwvxovwSCynBkv2QAcOvSIe1rw=
X-Endpoint-Received: by B4 Relay for lenohou@gmail.com/20260311 with
 auth_id=674
X-Original-From: Leno Hou <lenohou@gmail.com>
Reply-To: lenohou@gmail.com
X-Stat-Signature: uuqaf3a5hc1qpqkbt3ra3te9jxkdpxq1
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: 407EF180011
X-HE-Tag: 1773230986-415515
X-HE-Meta: U2FsdGVkX1/kauxTGGJjZ+5297FeiDP81yYMAutpmZUTwvVUq4Sh5Zyzh5r4uTFesGrrLgR+agExnDiRwYALVx/6Nlmh90xK5R9HcTnLtu+yLpeRWF9XSl581uD/BBrcQSjjOMkSIe2fy4FEEt4tscCxvgZDQymxQuwttBVSy8w7oqAkT5nP8sC2Cz8XyT5RNKTkbosZ8I6tPxDmzw5O748joYqU0pf6gqpIS7PXKjamH2gBBa5LXXgrU9L3eWzBi/NkPXbXp6jITt141nkL7PBhU8LZvTDYx7VUtZLBuOnGIJM/OLRVXtsaxuIQOoaeX68rEt3GBxpmIRjoEAZTSJck24t/aomz6UbebJy+j0MhFgrJdwaBC7rx62Pc+Dv3pqqFxS6/GS7ROhyOiozboTFWJJ204fv23DgjvAtCIHNbJsBOxRl8rioqIF89mY3zQ+LO4iTtSK/quaqq0mvOC2cZfExi0KrQs94L5TtD76S4RxFatBPTtEb7pUFZ4Lf4Xe3gpAMYpxSUtO27A3KHoW8q/JZ35gwnRql4rtaqY7DTQLzA8sUVrVvbm+K56u5fU6xJfvctJ6ceUNiliKLcvdxwGBrchNpEE9lafEAk0tFDu4Tckz+Q9OdP+r05yAUg1Oa2Y1Fdx3bJLkIbzbhVI4uRW4uLmLI3mfVntDwACajhq1zKUU60oi9O/eD4HnZLGMoYvxyiF/OqoWi0Z3aBX+IXOtWtMlQfFZKl+UEEsYF6iiUz0R0KUnKT0LNA00WjlzgVGgjhlpon2g86j1YTyMQ7tpqflZMeol5t3sa0hmXVD5i55zBI0KTpTT8OJCV5DvMgjnzXOMf20NG0hiDKoJPzY3lacjWv7+RxsVm9pcMVEl47yVdQOgFEYl5ZV8xSdnm4gKmV09bH2JQYY0d1R/vSh9ke8wHsFbawS0MLIAL9SEOOljWR3kza/xS2Z6xxFdqkBsJa1u8WkD+Cood
 /VbbCmkp
 SIgczUP3SRYy5lRR5p37OKov/gBT1lbEEULHgbFRwZaX415Js3xCabju3vmZmI9oGtxU1gm0rFri3R06VuFAqABu8aqcxf/MlIwOi8Rd/w7Bt8YnLeVBku+qqvSU0LxwQQxH2sKhpASQxaQTjHWmbEjIpzwHAMAsNEBHdwjStVJhSem6kPMsVsf4qJpxZImDhNV+AKkfaAsoIBL2Qoq9uWS1QQmZGGPcLx4QobAt71W1bPRYO0gmQKUI4Q6MB1/oPtiMjNaQNPSAxpVAzvq8LdA+SJrNGvR92GOewKavhb6gYHIZiOBbvXcLc6zHXNjHm0FYdIb/Y5CcM8AxaG1PBYgMbA4HcmfkXWV7+6fs4Anex9Fo6EGhr6ihu112Akz9n4i8yEtj1O1eA9I/gFPdA+O83AMnSjqXvhZry2dFfqsa/1F5JgMQCwbL5a+Xw2G/t6/G0YHTC3abY2AuprBBxHD/4O5bpp2/I0AV8VNxwiPSQsE84xCMXNuXCjLQhW5mzFqpgSSM6oON8UCquhK3bVb53DNOFW+z2VfVpe9Z4S23tB9VMXk3sMr1qC2zo2gzuTa50/Pa9XrWKHwl8mObX0cFgqpOme6jDs3MCNjozGQvlUP4iY1Mbd7AVbFo8U8vgQwdsO1eBTnmAWq4SfE9XB10OijgqXdO5k0dgtfLq27+cyNQo5mw79X3Z9ybNZoxmZ8aYbBq/Kp70Bk0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Leno Hou <lenohou@gmail.com>

When MGLRU state is toggled dynamically, existing shadow entries (eviction
tokens) lose their context. Traditional LRU and MGLRU handle workingset
refaults using different logic. Without context, shadow entries
re-activated by the "wrong" reclaim logic trigger excessive page
activations (pgactivate) and system thrashing, as the kernel cannot
correctly distinguish if a refaulted page was originally managed by
MGLRU or the traditional LRU.

This patch introduces shadow entry context tracking:

- Encode MGLRU origin: Introduce WORKINGSET_MGLRU_SHIFT into the shadow
  entry (eviction token) encoding. This adds an 'is_mglru' bit to shadow
  entries, allowing the kernel to correctly identify the originating
  reclaim logic for a page even after the global MGLRU state has been
  toggled.

- Refault logic dispatch: Use this 'is_mglru' bit in workingset_refault()
  and workingset_test_recent() to dispatch refault events to the correct
  handler (lru_gen_refault vs. traditional workingset refault).

This ensures that refaulted pages are handled by the appropriate reclaim
logic regardless of the current MGLRU enabled state, preventing
unnecessary thrashing and state-inconsistent refault activations during
state transitions.

To: Andrew Morton <akpm@linux-foundation.org>
To: Axel Rasmussen <axelrasmussen@google.com>
To: Yuanchu Xie <yuanchu@google.com>
To: Wei Xu <weixugc@google.com>
To: Barry Song <21cnbao@gmail.com>
To: Jialing Wang <wjl.linux@gmail.com>
To: Yafang Shao <laoar.shao@gmail.com>
To: Yu Zhao <yuzhao@google.com>
To: Kairui Song <ryncsn@gmail.com>
To: Bingfang Guo <bfguo@icloud.com>
Cc: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Leno Hou <lenohou@gmail.com>
---
 mm/workingset.c | 19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

diff --git a/mm/workingset.c b/mm/workingset.c
index 13422d304715..baa766daac24 100644
--- a/mm/workingset.c
+++ b/mm/workingset.c
@@ -180,8 +180,10 @@
  * refault distance will immediately activate the refaulting page.
  */
 
+#define WORKINGSET_MGLRU_SHIFT  1
 #define WORKINGSET_SHIFT 1
 #define EVICTION_SHIFT	((BITS_PER_LONG - BITS_PER_XA_VALUE) +	\
+			 WORKINGSET_MGLRU_SHIFT + \
 			 WORKINGSET_SHIFT + NODES_SHIFT + \
 			 MEM_CGROUP_ID_SHIFT)
 #define EVICTION_MASK	(~0UL >> EVICTION_SHIFT)
@@ -197,12 +199,13 @@
 static unsigned int bucket_order __read_mostly;
 
 static void *pack_shadow(int memcgid, pg_data_t *pgdat, unsigned long eviction,
-			 bool workingset)
+			 bool workingset, bool is_mglru)
 {
 	eviction &= EVICTION_MASK;
 	eviction = (eviction << MEM_CGROUP_ID_SHIFT) | memcgid;
 	eviction = (eviction << NODES_SHIFT) | pgdat->node_id;
 	eviction = (eviction << WORKINGSET_SHIFT) | workingset;
+	eviction = (eviction << WORKINGSET_MGLRU_SHIFT) | is_mglru;
 
 	return xa_mk_value(eviction);
 }
@@ -214,6 +217,7 @@ static void unpack_shadow(void *shadow, int *memcgidp, pg_data_t **pgdat,
 	int memcgid, nid;
 	bool workingset;
 
+	entry >>= WORKINGSET_MGLRU_SHIFT;
 	workingset = entry & ((1UL << WORKINGSET_SHIFT) - 1);
 	entry >>= WORKINGSET_SHIFT;
 	nid = entry & ((1UL << NODES_SHIFT) - 1);
@@ -254,7 +258,7 @@ static void *lru_gen_eviction(struct folio *folio)
 	hist = lru_hist_from_seq(min_seq);
 	atomic_long_add(delta, &lrugen->evicted[hist][type][tier]);
 
-	return pack_shadow(mem_cgroup_private_id(memcg), pgdat, token, workingset);
+	return pack_shadow(mem_cgroup_private_id(memcg), pgdat, token, workingset, true);
 }
 
 /*
@@ -390,7 +394,7 @@ void *workingset_eviction(struct folio *folio, struct mem_cgroup *target_memcg)
 	VM_BUG_ON_FOLIO(folio_ref_count(folio), folio);
 	VM_BUG_ON_FOLIO(!folio_test_locked(folio), folio);
 
-	if (lru_gen_enabled())
+	if (folio_lru_gen(folio) != -1)
 		return lru_gen_eviction(folio);
 
 	lruvec = mem_cgroup_lruvec(target_memcg, pgdat);
@@ -400,7 +404,7 @@ void *workingset_eviction(struct folio *folio, struct mem_cgroup *target_memcg)
 	eviction >>= bucket_order;
 	workingset_age_nonresident(lruvec, folio_nr_pages(folio));
 	return pack_shadow(memcgid, pgdat, eviction,
-				folio_test_workingset(folio));
+				folio_test_workingset(folio), false);
 }
 
 /**
@@ -426,8 +430,10 @@ bool workingset_test_recent(void *shadow, bool file, bool *workingset,
 	int memcgid;
 	struct pglist_data *pgdat;
 	unsigned long eviction;
+	unsigned long entry = xa_to_value(shadow);
+	bool is_mglru = !!(entry & WORKINGSET_MGLRU_SHIFT);
 
-	if (lru_gen_enabled()) {
+	if (is_mglru) {
 		bool recent;
 
 		rcu_read_lock();
@@ -539,10 +545,11 @@ void workingset_refault(struct folio *folio, void *shadow)
 	struct lruvec *lruvec;
 	bool workingset;
 	long nr;
+	unsigned long entry = xa_to_value(shadow);
 
 	VM_BUG_ON_FOLIO(!folio_test_locked(folio), folio);
 
-	if (lru_gen_enabled()) {
+	if (entry & ((1UL << WORKINGSET_MGLRU_SHIFT) - 1)) {
 		lru_gen_refault(folio, shadow);
 		return;
 	}

-- 
2.52.0



