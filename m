Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 20ADDCCF9E3
	for <linux-mm@archiver.kernel.org>; Thu, 30 Oct 2025 15:56:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 68FF628000C; Thu, 30 Oct 2025 11:56:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6400D280003; Thu, 30 Oct 2025 11:56:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5569428000C; Thu, 30 Oct 2025 11:56:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3F673280003
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 11:56:26 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D0043856A0
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 15:56:25 +0000 (UTC)
X-FDA: 84055232730.06.B32183A
Received: from akranes.kaiser.cx (akranes.kaiser.cx [152.53.16.207])
	by imf06.hostedemail.com (Postfix) with ESMTP id F3B6C180007
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 15:56:23 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	spf=pass (imf06.hostedemail.com: domain of postmaster@kaiser.cx designates 152.53.16.207 as permitted sender) smtp.mailfrom=postmaster@kaiser.cx
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761839784; a=rsa-sha256;
	cv=none;
	b=n0oanb+bZexipkpLWWC/TClszsOE+6ebfCTw6DQYV6WEzvXmFDLAg73k5dl14yDTdJpnVy
	mCWkje0aWewhUDrx/a3bB4bsDuFDTXrrvxsRIsybTR2+4ldq1oMVFOSvLr1qjAKNIXxT2d
	+rq/AYkyrS0G55ksP1b0fpP7HcAFpjo=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf06.hostedemail.com: domain of postmaster@kaiser.cx designates 152.53.16.207 as permitted sender) smtp.mailfrom=postmaster@kaiser.cx
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761839784;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=3WZkVwNh4oSD4qdsKRsgE30RmVLPPZlGnWQm5FqqgbY=;
	b=ZTlNslEZI5OOeC8uwVxUYspj/LYgCdV8bqvxS8Sj7vrWKijZRxB6GPZ75ynVzkGVg+eLuQ
	BPDSk6qyg+7Flnfc4nuCVGhhb3aWODNa5kk9CIVeTXO4bU+zg7YwR5SfdCNhz+4uJsYeUn
	VvHNsX0l+hHRur3pMLfVS+EjBwQsJu8=
Received: from ipservice-092-210-203-096.092.210.pools.vodafone-ip.de ([92.210.203.96] helo=martin-debian-3.kaiser.cx)
	by akranes.kaiser.cx with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <martin@kaiser.cx>)
	id 1vEV0H-005zMp-2O;
	Thu, 30 Oct 2025 16:55:57 +0100
From: Martin Kaiser <martin@kaiser.cx>
To: Andrew Morton <akpm@linux-foundation.org>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>
Cc: maple-tree@lists.infradead.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Martin Kaiser <martin@kaiser.cx>
Subject: [PATCH] maple_tree: fix tracepoint string pointers
Date: Thu, 30 Oct 2025 16:55:05 +0100
Message-ID: <20251030155537.87972-1-martin@kaiser.cx>
X-Mailer: git-send-email 2.43.7
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: F3B6C180007
X-Stat-Signature: j9ptcnqs9szu5ieznbd8urkihdyk3r1i
X-HE-Tag: 1761839783-303747
X-HE-Meta: U2FsdGVkX1+UrkYR9PaJXzjfOZQvS2O9dxgfu3QBPTIys07sOuFUd6207T7bxsig93Pe5AvWR7CZLUHDOOKiUJ2NZ77yEg6V39IbLsnUPz9+yy9BF878WTGXTR1B13eFOVYekRbrujVN/aRheOcNw7pbIRcGjq1eM9/Gtn2p2GmoBZT2BdsyDtNJHbZxOk8Jks5TvOcCUu1wsu5K+RR0QfUnAlPCx6dy1U45OHDakXzsDhHt0YfkLFLzO0W9UTkZIYpZaK6IPFap3wzUl5ksURCMoasZwcdIvvn/BrZjCYpMTdhOXd+PbfOQ9KAJCx7KMDePwP0mJCW2SXDRHiB9t3roub70tfosmi8ZVysRq8r2sHOxg3Zn+DPT8JK0mrdoSz7AAljRaAjA4vKvDk+RpGROoOw2IX2L+LujTVaLrpGpXpH8U6bGpv1T2PCtCUG4a1fahctHlKOl//gTfFL0FxMAZiimSnnQyU67JJyeh6aSaQjfVp4LfafhpkSj4UdqA+xxuwoIYkw5m5gdvrMth60wJwM7H8oilUWfYBUwc/BtyZ00WtOvEtMetd8ATdU39XQmKeMTTUkUsyC7ReUusyeFibH14UHNcyttgwUfG9gb/oorByCzHlivcEKlGCC9Ufipwog+s2Phg6BpflQrad1gH7DIz9R86oL5JFkOyPEBAuPe66G/PLKjl/HOCtLyuMFhZR5m7BAXlOP3NuoUePmw3gQTMXO41rk8gOE6tU1VMvhJu03sN6lC5EbTwCa9Utiy17/gbdURF7o0wUfjXxjMt/5WCG/9qbO+e7sM6IWW3vr/jS4KnBT88WmBJ+0KDsY2oOZ/lg6oZyCpRI7CDZl9NUSOUDm+bC9dMagtBkF+KQCHxmxJRTTyTbNPif5MAVPcQDDuIXhbk6Rq1Lj4lCIsyFIG911Qbbi9Tv7E0MXXetZ+tVXLjhfIuQPTX+THKApQHxOA+ELZhI3PcXj
 igDhlMsH
 AQ6qqyqOCEWFOuGclFgsSdKL3Qenl3g2Y9U/uLnTkOjfD//QIx+t9wQYtoq2Kr2A+Ar3bW3pnSnH7AZXnK4RGkAB9yNzrzgUel2cXNnxAQBAEoL0qOupdZNVxILfUYVgCSjFsz/DhukQR0vqV4RmYJ+x8zWtlvWwfWGuZvNx+vXuV5Vd8TIzl4JgpFXWDLXunA+wi4oeq5jDU8a4o7aM1GZ3jw5h3MzJ8UWQO4GFlvE4qY3s=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

maple_tree tracepoints contain pointers to function names. Such a pointer
is saved when a tracepoint logs an event. There's no guarantee that it's
still valid when the event is parsed later and the pointer is dereferenced.

The kernel warns about these unsafe pointers.

	event 'ma_read' has unsafe pointer field 'fn'
	WARNING: kernel/trace/trace.c:3779 at ignore_event+0x1da/0x1e4

Mark the function names as tracepoint_string() to fix the events.

Signed-off-by: Martin Kaiser <martin@kaiser.cx>
---
 lib/maple_tree.c | 30 ++++++++++++++++--------------
 1 file changed, 16 insertions(+), 14 deletions(-)

diff --git a/lib/maple_tree.c b/lib/maple_tree.c
index 39bb779cb311..5aa4c9500018 100644
--- a/lib/maple_tree.c
+++ b/lib/maple_tree.c
@@ -64,6 +64,8 @@
 #define CREATE_TRACE_POINTS
 #include <trace/events/maple_tree.h>
 
+#define TP_FCT tracepoint_string(__func__)
+
 /*
  * Kernel pointer hashing renders much of the maple tree dump useless as tagged
  * pointers get hashed to arbitrary values.
@@ -2756,7 +2758,7 @@ static inline void mas_rebalance(struct ma_state *mas,
 	MA_STATE(l_mas, mas->tree, mas->index, mas->last);
 	MA_STATE(r_mas, mas->tree, mas->index, mas->last);
 
-	trace_ma_op(__func__, mas);
+	trace_ma_op(TP_FCT, mas);
 
 	/*
 	 * Rebalancing occurs if a node is insufficient.  Data is rebalanced
@@ -2997,7 +2999,7 @@ static void mas_split(struct ma_state *mas, struct maple_big_node *b_node)
 	MA_STATE(prev_l_mas, mas->tree, mas->index, mas->last);
 	MA_STATE(prev_r_mas, mas->tree, mas->index, mas->last);
 
-	trace_ma_op(__func__, mas);
+	trace_ma_op(TP_FCT, mas);
 
 	mast.l = &l_mas;
 	mast.r = &r_mas;
@@ -3172,7 +3174,7 @@ static bool mas_is_span_wr(struct ma_wr_state *wr_mas)
 			return false;
 	}
 
-	trace_ma_write(__func__, wr_mas->mas, wr_mas->r_max, entry);
+	trace_ma_write(TP_FCT, wr_mas->mas, wr_mas->r_max, entry);
 	return true;
 }
 
@@ -3416,7 +3418,7 @@ static noinline void mas_wr_spanning_store(struct ma_wr_state *wr_mas)
 	 * of data may happen.
 	 */
 	mas = wr_mas->mas;
-	trace_ma_op(__func__, mas);
+	trace_ma_op(TP_FCT, mas);
 
 	if (unlikely(!mas->index && mas->last == ULONG_MAX))
 		return mas_new_root(mas, wr_mas->entry);
@@ -3552,7 +3554,7 @@ static inline void mas_wr_node_store(struct ma_wr_state *wr_mas,
 	} else {
 		memcpy(wr_mas->node, newnode, sizeof(struct maple_node));
 	}
-	trace_ma_write(__func__, mas, 0, wr_mas->entry);
+	trace_ma_write(TP_FCT, mas, 0, wr_mas->entry);
 	mas_update_gap(mas);
 	mas->end = new_end;
 	return;
@@ -3596,7 +3598,7 @@ static inline void mas_wr_slot_store(struct ma_wr_state *wr_mas)
 		mas->offset++; /* Keep mas accurate. */
 	}
 
-	trace_ma_write(__func__, mas, 0, wr_mas->entry);
+	trace_ma_write(TP_FCT, mas, 0, wr_mas->entry);
 	/*
 	 * Only update gap when the new entry is empty or there is an empty
 	 * entry in the original two ranges.
@@ -3717,7 +3719,7 @@ static inline void mas_wr_append(struct ma_wr_state *wr_mas,
 		mas_update_gap(mas);
 
 	mas->end = new_end;
-	trace_ma_write(__func__, mas, new_end, wr_mas->entry);
+	trace_ma_write(TP_FCT, mas, new_end, wr_mas->entry);
 	return;
 }
 
@@ -3731,7 +3733,7 @@ static void mas_wr_bnode(struct ma_wr_state *wr_mas)
 {
 	struct maple_big_node b_node;
 
-	trace_ma_write(__func__, wr_mas->mas, 0, wr_mas->entry);
+	trace_ma_write(TP_FCT, wr_mas->mas, 0, wr_mas->entry);
 	memset(&b_node, 0, sizeof(struct maple_big_node));
 	mas_store_b_node(wr_mas, &b_node, wr_mas->offset_end);
 	mas_commit_b_node(wr_mas, &b_node);
@@ -5062,7 +5064,7 @@ void *mas_store(struct ma_state *mas, void *entry)
 {
 	MA_WR_STATE(wr_mas, mas, entry);
 
-	trace_ma_write(__func__, mas, 0, entry);
+	trace_ma_write(TP_FCT, mas, 0, entry);
 #ifdef CONFIG_DEBUG_MAPLE_TREE
 	if (MAS_WARN_ON(mas, mas->index > mas->last))
 		pr_err("Error %lX > %lX " PTR_FMT "\n", mas->index, mas->last,
@@ -5163,7 +5165,7 @@ void mas_store_prealloc(struct ma_state *mas, void *entry)
 	}
 
 store:
-	trace_ma_write(__func__, mas, 0, entry);
+	trace_ma_write(TP_FCT, mas, 0, entry);
 	mas_wr_store_entry(&wr_mas);
 	MAS_WR_BUG_ON(&wr_mas, mas_is_err(mas));
 	mas_destroy(mas);
@@ -5882,7 +5884,7 @@ void *mtree_load(struct maple_tree *mt, unsigned long index)
 	MA_STATE(mas, mt, index, index);
 	void *entry;
 
-	trace_ma_read(__func__, &mas);
+	trace_ma_read(TP_FCT, &mas);
 	rcu_read_lock();
 retry:
 	entry = mas_start(&mas);
@@ -5925,7 +5927,7 @@ int mtree_store_range(struct maple_tree *mt, unsigned long index,
 	MA_STATE(mas, mt, index, last);
 	int ret = 0;
 
-	trace_ma_write(__func__, &mas, 0, entry);
+	trace_ma_write(TP_FCT, &mas, 0, entry);
 	if (WARN_ON_ONCE(xa_is_advanced(entry)))
 		return -EINVAL;
 
@@ -6148,7 +6150,7 @@ void *mtree_erase(struct maple_tree *mt, unsigned long index)
 	void *entry = NULL;
 
 	MA_STATE(mas, mt, index, index);
-	trace_ma_op(__func__, &mas);
+	trace_ma_op(TP_FCT, &mas);
 
 	mtree_lock(mt);
 	entry = mas_erase(&mas);
@@ -6485,7 +6487,7 @@ void *mt_find(struct maple_tree *mt, unsigned long *index, unsigned long max)
 	unsigned long copy = *index;
 #endif
 
-	trace_ma_read(__func__, &mas);
+	trace_ma_read(TP_FCT, &mas);
 
 	if ((*index) > max)
 		return NULL;
-- 
2.43.7


