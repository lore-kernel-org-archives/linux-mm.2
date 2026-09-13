Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 754AEC88E5C
	for <linux-mm@archiver.kernel.org>; Sun, 13 Sep 2026 15:27:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AA70D6B008C; Sun, 13 Sep 2026 11:26:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A012E6B0096; Sun, 13 Sep 2026 11:26:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 809986B0092; Sun, 13 Sep 2026 11:26:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 495F56B0088
	for <linux-mm@kvack.org>; Sun, 13 Sep 2026 11:26:57 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 4E39580749
	for <linux-mm@kvack.org>; Sun, 13 Sep 2026 15:26:56 +0000 (UTC)
X-FDA: 85209116832.14.113CFDC
Received: from danaos.cslab.ece.ntua.gr (danaos.cslab.ece.ntua.gr [147.102.3.1])
	by imf16.hostedemail.com (Postfix) with ESMTP id 01582180002
	for <linux-mm@kvack.org>; Sun, 13 Sep 2026 15:26:53 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=cslab.ece.ntua.gr header.s=smtp-cslab header.b=kd07l0bK;
	spf=pass (imf16.hostedemail.com: domain of dchar@cslab.ece.ntua.gr designates 147.102.3.1 as permitted sender) smtp.mailfrom=dchar@cslab.ece.ntua.gr;
	dmarc=pass (policy=none) header.from=cslab.ece.ntua.gr
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789313214;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=udgB25o9rMSPCKbe98tIq5wnQKI06vFGZyGncNgKJ7k=;
	b=FjM854BbD6N0KvSd+3YLJAh33tek46QE3ejz/paygRsCe+VoPc5va3nX4MwZVhPSIIe0H/
	XE7vIMyTJHGTPUAIHYLHn24PUwdgzA3ZdKk4ZGoFOO91AfZMYsqR43yRLhVEWjA1LsjRgo
	eWGlfSBD91xNbV77hQwxlXnIjwlmdyY=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=cslab.ece.ntua.gr header.s=smtp-cslab header.b=kd07l0bK;
	spf=pass (imf16.hostedemail.com: domain of dchar@cslab.ece.ntua.gr designates 147.102.3.1 as permitted sender) smtp.mailfrom=dchar@cslab.ece.ntua.gr;
	dmarc=pass (policy=none) header.from=cslab.ece.ntua.gr
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789313214;
	b=4S6HAC3gOUqV81faUyAhAt+nW1LJ6otI7w4LRyxVML2NCRxrfTQn+KZlc8DCE4xo/CGlSv
	xIbO/eCAnmyil/++XYtYF30331zAU4Rpdfk5Wt3n5/FNJcAchQCNpsPCJLCaWRWGWrUf+n
	nEqAMMtw8u2ecMVp02vRveR9V0xFz1M=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=cslab.ece.ntua.gr;
	s=smtp-cslab; t=1789313206;
	bh=Y1SFoLhBIFd6pX1RkY73sxEGVjFfj6zsBKMG2Gysrbc=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=kd07l0bKVrHrxtGQePg3sP3LRUf8BDXbw9XltDmpNMaL2i+odUQ5ekCVhs4NV80O/
	 fa+pqbIOTnJRKdq2MWBStVOn0do5NMtzBjRc5IR+sQP4CelCgD43OYrieZdUxtR2LL
	 MpoEb/L1qUD8xqHohdy8xlRWmaruyOYu6oZ/LSeI=
Received: from [127.0.0.1] (armor.cslab.ece.ntua.gr [147.102.4.33])
	by danaos.cslab.ece.ntua.gr (Postfix) with ESMTPSA id B3FB7120B7C;
	Sun, 13 Sep 2026 18:26:46 +0300 (EEST)
From: Dimitris Charisis <dchar@cslab.ece.ntua.gr>
Date: Sun, 13 Sep 2026 15:26:18 +0000
Subject: [PATCH 1/2] maple_tree: remove mt_clear_meta() to fix a pointer
 corruption
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260913-fix-maple-tree-range64-rcu-v1-1-31a130bb8cbf@cslab.ece.ntua.gr>
References: <20260913-fix-maple-tree-range64-rcu-v1-0-31a130bb8cbf@cslab.ece.ntua.gr>
In-Reply-To: <20260913-fix-maple-tree-range64-rcu-v1-0-31a130bb8cbf@cslab.ece.ntua.gr>
To: Andrew Morton <akpm@linux-foundation.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Alice Ryhl <aliceryhl@google.com>, 
 Andrew Ballance <andrewjballance@gmail.com>, 
 Suren Baghdasaryan <surenb@google.com>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: maple-tree@lists.infradead.org, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, Dimitris Charisis <dchar@cslab.ece.ntua.gr>
X-Mailer: b4 0.14.2
X-Rspam-User: 
X-Stat-Signature: ps6kkmr57x184t8x5tf87wgea9c79rct
X-Rspamd-Queue-Id: 01582180002
X-Rspamd-Server: rspam07
X-HE-Tag: 1789313213-713858
X-HE-Meta: U2FsdGVkX18UCP+7IaxPK+1ce9n1ZS/xdrJWuvGhgkExSr212acdyvNYgYd3QgYC1ifr8RcU1X4bzE51Ya0rs+1o3kLfIOvvXBPO/bmOO979ZO6YL+ITnx6CzHxjcyhd3NwJnD0fFIRe8aVzXA8PkEG+mWb9G0YUu/r+0Swbcnbh9bKf//iJOLVXFod99z8e9RUm1945uti0WielPLPEtSRWHbofKy4Eiz2h2f7KsViwyZiR8AZIM9Zvkx+eCX3ELb/KeWe6GRADjWZd1IG+CgbAxGTl/qGPD9XIJnYTQQnrt5SB+eii4js58Aup/l8sPHSYyrAYloiWpPXrvaWm2VfffHtlYFKwGEPsIcnt8BgEuE5tpGawvAWm85RfFPHI+bwzyoB3QU2HRbQPZzBI5wvUUsFsDUXlF4ZIm1xSfOlbGMTBoLu+XPaBAGuO85Cjvz7fchuwoeTJgC0NHLBZ72WThPbwXy8cuZxddYqMep4WBE2b3AMomdFPU6R1wSQgbEfEQBJlWNOdLqDiVn6/rlYLG/HXD4w5h9EKCjuTic6PWNpf7sx3RcUMypqxOG+1qUuzsfsLqjNscIsVfWiLARwqm4x69jbyEAkBM/AiMs8DhYG61HZXzMDkQQsgN3ShACJvsG4pHV5kXtDqIDn1yJcv0x+c4JdPjL16WUQA59ynmLv2EnBOXenYmGdpSdCzai+gVxK65Vu10vAOhOrQwrk2bZDhGbHaxvghnCdB0tDie79JjkV0bYmThhijGSNYcW4SU37FNtvMoCfxAkVLn4pCmA14amQ7bue/Tn5DiPm72XjJtNHPH0hK72f1c8HGKgMS3n0gvE89vOGZbaTlLus6Hvp9WN6tcd89q/QCow9L5REWalHE0feQypoJDzlA7HXCK5Dp3/FK70K2odTddobpk/fVRYVPZekQrAwj9ljXXxyfKCs+nQZJTYvdB/Wev5IUz8YbFho9Kcku7qR
 f7ep/42g
 iQIkbp4ixwqYRVZX9d0yH7b7uW51tjpM30A4PC2YVPN40RlX0HHtcZtpdsrDC3tkqcyrVSouSDmRPbFZ7mpmqvy27E6I0ldXXCpInT3X0sHsX6NxV+4Uh6lnY6pflH3ZFjf1MTqUh8SwWmQT5JLD/snhzv5F5Wy/9ri2oeQl+AfgRbkG8T3exMxqP40nB+n3a+VXUVBz2oIU70rumLyRJCeFuj5gEi5DiFkSTm6pSiTaDS70R9QsUFDUjMdKOjp26lX6ZmrBzBUE4wUffCqsE/AIf5+IYVMYhpp/llbsVunzYhImommGyYtAcH1MwvQPYemecrpnpWTF2sVp5OtluQ+rv/OZptXuHi34eYXt3CWeGr0J0dBJZQdSPoQ==
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


