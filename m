Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C0F69C88E5C
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 11:39:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9394F6B008C; Wed, 16 Sep 2026 07:39:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8FDF46B0099; Wed, 16 Sep 2026 07:39:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 727AE6B0096; Wed, 16 Sep 2026 07:39:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5051E6B008C
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 07:39:09 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id BA0E81C2C94
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 11:39:08 +0000 (UTC)
X-FDA: 85219429176.20.8A9168A
Received: from danaos.cslab.ece.ntua.gr (danaos.cslab.ece.ntua.gr [147.102.3.1])
	by imf02.hostedemail.com (Postfix) with ESMTP id 994AB80003
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 11:39:06 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=cslab.ece.ntua.gr header.s=smtp-cslab header.b=am3FPyaP;
	spf=pass (imf02.hostedemail.com: domain of dchar@cslab.ece.ntua.gr designates 147.102.3.1 as permitted sender) smtp.mailfrom=dchar@cslab.ece.ntua.gr;
	dmarc=pass (policy=none) header.from=cslab.ece.ntua.gr
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789558747;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=udgB25o9rMSPCKbe98tIq5wnQKI06vFGZyGncNgKJ7k=;
	b=r1aJUsbe8NCjtecqKLxjwx8IlRTXvf1UEHOkFZwpxQmwCzrBMnBlE+OR6POuVhjxNOkSrM
	LBT/jxwT5ku/mJ3ygM9+96K3iRGXsesq52k763uUg5BfC8ogKEIgNUfqwxMI77RZI4KJ1e
	o2I9X8idYeM4I0ucit28LFT9CDA80HE=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=cslab.ece.ntua.gr header.s=smtp-cslab header.b=am3FPyaP;
	spf=pass (imf02.hostedemail.com: domain of dchar@cslab.ece.ntua.gr designates 147.102.3.1 as permitted sender) smtp.mailfrom=dchar@cslab.ece.ntua.gr;
	dmarc=pass (policy=none) header.from=cslab.ece.ntua.gr
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789558747;
	b=lvTza8a+zIgKzYMO4+rSVrcqcKGb8pEerBmQehUvA+1oKsvRoxXzeHUoNi9FiZa8zPA0Z8
	643UdGXRtpuMGRo8O1nyIGboAlcPo26y+QoCmZHZmDMt4bkll2ej1RjBCjC28qZWWLX4AE
	QuGvb+3IJ3GcmMmSg0nN+ZKEVUvNvlA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=cslab.ece.ntua.gr;
	s=smtp-cslab; t=1789558743;
	bh=Y1SFoLhBIFd6pX1RkY73sxEGVjFfj6zsBKMG2Gysrbc=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=am3FPyaPipHW4yX/qhIBiB5rBHVCCgYrVvR5SqtJPa9iSeMr8VPph3LDHi6EOXYpB
	 s0Wa3dIj0xBT7vXVWvPd1UKqgpMqJiLry8OmcvSeYEum6F4N0INbzu3xaR/3el0fIC
	 fSSSRo1RyjZYPYtqc9Y3TdQM4w5A3kisb/jPoHWs=
Received: from [127.0.0.1] (armor.cslab.ece.ntua.gr [147.102.4.33])
	by danaos.cslab.ece.ntua.gr (Postfix) with ESMTPSA id CA559120B7D;
	Wed, 16 Sep 2026 14:39:03 +0300 (EEST)
From: Dimitris Charisis <dchar@cslab.ece.ntua.gr>
Date: Wed, 16 Sep 2026 11:38:42 +0000
Subject: [PATCH v2 1/4] maple_tree: remove mt_clear_meta() to fix a pointer
 corruption
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260916-fix-maple-tree-range64-rcu-v2-1-0b09de37eb69@cslab.ece.ntua.gr>
References: <20260916-fix-maple-tree-range64-rcu-v2-0-0b09de37eb69@cslab.ece.ntua.gr>
In-Reply-To: <20260916-fix-maple-tree-range64-rcu-v2-0-0b09de37eb69@cslab.ece.ntua.gr>
To: Andrew Morton <akpm@linux-foundation.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Alice Ryhl <aliceryhl@google.com>, 
 Andrew Ballance <andrewjballance@gmail.com>, 
 Suren Baghdasaryan <surenb@google.com>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: maple-tree@lists.infradead.org, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, Dimitris Charisis <dchar@cslab.ece.ntua.gr>
X-Mailer: b4 0.14.2
X-Rspam-User: 
X-Stat-Signature: naq8aykdb7phyqxmeaaeynt1eqq4b5k8
X-Rspamd-Queue-Id: 994AB80003
X-Rspamd-Server: rspam07
X-HE-Tag: 1789558746-929620
X-HE-Meta: U2FsdGVkX1/wUbDY84TeFQqpPt1RAe89nK5jD4Yvwwj6nRFt3HlrXAjBTA+8+7gpeGkqsZQedSvWPEQl09xx7SJyTRjxRd3PGP6HUaMH4iF771zUGI9rIULsvhePpB2/52qOJEY+ZJbGwnVhn2GCL8187V88AZSapFy8Kg5V77yHh/DtRUIx3DzNgZ2xg6NR0+iB+cEt9i7jHgEtGfB4dyq/YjpbnAsJkJa0vH1CX/nm3qp2rd1FYjWAbUXOC5zwF8ozXmHsrWYHRmgWHjtFqPazTubaED+kvdkHJMTDeARRqmBVfGiHXIMqlZFfy1O5dWK6JFu3cPqK5gOKZt/oBXnpxyE4IsgMf4r6ttk2JmN/3JYwzBzIIufjiLPTMKc0qg+15Zo+1A9/4ejv7b5h50P872BmGpZzFJOZHS6dRxLxIV3qQH2lK4jmuQHSCOWVtpNIMkG7wK3r2Cb2AFnBM2QVzMMrGSWQTYrQskO9K6K7T9fFTm9mX3cYUr2XagBxoqPvEOuZ4MZ8i+TCLIxX992kWGWdFQRSlPsBj6deGePYcCkQ0w92p/GcKengVr26kKd+8M16w0YazTziAPDubgB10Ek6WqwEmLSdS30FH/Q+3oBdDkpvSVpOleHiuSAwktkChnP0zUTmEN/byFuSRqa/iwnXaekql5Fnyp5WeAFYiC1hgB+vbeKIeGkUNp4PMeOSVT6H3SAqZqCeS0pt82+um11XjK/gpnVDEvOZBD1YZp3AxcrHm9WCLNX4+pDWysJJIA3cUcgVKgu0sKLL1oIwdSyzu4Dq8/k9ON8CSXpDghpCV1GQHk1tVgIyN2287n0glcNx9R5G//7SmKjnO1pE+9yiF32o2vCTFZpeAxyILmV/DcipAwlz9vW9C+CxiVGlNc8IHMaLScyjGGPmhcwB/gpSepYJBhYEN2gr7LlQXj/eL7EuLBmqNrrcRrcwDNFA21HHh5ghInH5EVl
 PX26tKBb
 pnbMvJwaral7sBpaqOWaxCi5OI0dW0nn2skCwMWR6v7GYw6xkDh3vkcEW6q7rgl4t3UvCifnCKYjl2mjONGHFOwehvt39FS2CRcZpJBKLxgYU4hDWjnhG2ZBC7/JP5uowztXx5rE1DyqNx5mo2DOmmJN0GmPum7cJCK4cdAHj051cuXwPQFxh0bKJZO23W8WH5DhxQ5TOi7nMB7PFVtvRqYRtop5vOAwjz+uvOalD9RRcsv1Z/tnTnztdSwgRDx8JUEufUk1j/otsAHzMhvvAz6SylWGWYq0BIH+oqisyT6iQyUyc09Y8CItCCbiFvpxwFWHlZPiEsPyeG5ChavbrkZX0FMnWbObbXiPm60JLjL7+M3dUsMeozY3JKQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

mt_clear_meta() decides whether the last slot of a maple_range_64 node
holds a child pointer or a struct maple_metadata with the check

        if (unlikely((mte_to_node(next) &&
                      mte_node_type(next))))
                return; /* no metadata, could be node */

The check expects the pointer to be encoded.  But the only callsite of
mt_clear_meta() is mt_destroy_walk() on the RCU destroy path, and by the
time it runs, mte_dead_leaves() has overwritten every slot on a full
node with a raw pointer, stripping the type information. Thus, the check
above never returns early for a full node as it should. It falls through
and then:
        meta->gap = 0;
        meta->end = 0;
zeroes two bytes of a valid child pointer. Later, mt_free_walk()
dereferences the corrupted pointer.

Fix this by removing mt_clear_meta() along with its only callsite.
mt_clear_meta() is only called for the root of each sub-tree destroyed
under RCU. Descendant nodes retain their metadata until they are freed.
RCU readers may use the metadata while traversing a node, but do not use
cleared metadata to detect that a node has been removed. They detect a
dead node via ma_dead_node().

Fixes: 2e5b4921f8ef ("maple_tree: fix freeing of nodes in rcu mode")
Signed-off-by: Dimitris Charisis <dchar@cslab.ece.ntua.gr>
---
 lib/maple_tree.c | 39 ---------------------------------------
 1 file changed, 39 deletions(-)

diff --git a/lib/maple_tree.c b/lib/maple_tree.c
index 1aba6cced71307245cbbca26986e14e74b35a14f..e86eee43aa0ada6963995cd74495d9344f6ccd06 100644
--- a/lib/maple_tree.c
+++ b/lib/maple_tree.c
@@ -763,43 +763,6 @@ static inline void ma_set_meta(struct maple_node *mn, enum maple_type mt,
 	meta->end = end;
 }
 
-/*
- * mt_clear_meta() - clear the metadata information of a node, if it exists
- * @mt: The maple tree
- * @mn: The maple node
- * @type: The maple node type
- */
-static inline void mt_clear_meta(struct maple_tree *mt, struct maple_node *mn,
-				  enum maple_type type)
-{
-	struct maple_metadata *meta;
-	unsigned long *pivots;
-	void __rcu **slots;
-	void *next;
-
-	switch (type) {
-	case maple_range_64:
-		pivots = mn->mr64.pivot;
-		if (unlikely(pivots[MAPLE_RANGE64_SLOTS - 2])) {
-			slots = mn->mr64.slot;
-			next = mt_slot_locked(mt, slots,
-					      MAPLE_RANGE64_SLOTS - 1);
-			if (unlikely((mte_to_node(next) &&
-				      mte_node_type(next))))
-				return; /* no metadata, could be node */
-		}
-		fallthrough;
-	case maple_arange_64:
-		meta = ma_meta(mn, type);
-		break;
-	default:
-		return;
-	}
-
-	meta->gap = 0;
-	meta->end = 0;
-}
-
 /*
  * ma_meta_end() - Get the data end of a node from the metadata
  * @mn: The maple node
@@ -4885,8 +4848,6 @@ static void mt_destroy_walk(struct maple_enode *enode, struct maple_tree *mt,
 free_leaf:
 	if (free)
 		kfree(node);
-	else
-		mt_clear_meta(mt, node, node->type);
 }
 
 /*

-- 
2.47.3


