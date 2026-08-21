Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 518D4C5DF7D
	for <linux-mm@archiver.kernel.org>; Fri, 21 Aug 2026 19:27:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 635206B00A7; Fri, 21 Aug 2026 15:26:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5E5D86B00A9; Fri, 21 Aug 2026 15:26:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 522A56B00AA; Fri, 21 Aug 2026 15:26:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2855B6B00A7
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 15:26:59 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 83FC8C023C
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 19:26:58 +0000 (UTC)
X-FDA: 85126259316.04.8348B80
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf24.hostedemail.com (Postfix) with ESMTP id 0533A180003
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 19:26:56 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=tMLRcrtc;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf24.hostedemail.com: domain of liam@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=liam@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787340417;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4lvNvcVkXjeJSX/bJKiTiyE3aeJDISmDpXcWfTd+q7s=;
	b=mxyFulaic4+z5BKfppRJw5PAQ8E6v1KkZeUP86lpU7s3s8Q6IQRXdxPMzb/Wx6oaSveKib
	hjwp1rtFEHCki+S3bi6C873InSmPTJ/iSe8S/MiCKr9UQG5qXQMQd1rbN8DDpHH371TQRN
	0hRUHe4yMZHWUs1isOppp81jXTj3xXQ=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=tMLRcrtc;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf24.hostedemail.com: domain of liam@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=liam@infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787340417;
	b=xjvLkB4TfWlELLmfmD/Iyzy04GAEb37BHGeouoM3DuKL9iSbPTgy/vrf46LynWEEcRXMPB
	DK4SVWI01UpkosptRIUsQWfkoqrfiLZZ00o7TJRr9f09hib5r8RtoXTCNTROL9bRTjs/Kr
	VZ+yay1MSkYpfWL40xtd38712CDsUx4=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=4lvNvcVkXjeJSX/bJKiTiyE3aeJDISmDpXcWfTd+q7s=; b=tMLRcrtcEUpVdicE7qbOk6pS1v
	bBQ3HNHStLVVKfIBFlFDG8VEIdOnLfMeWT+WWpIS3LNkRbBm8nP9EDlspExkErPJhMUR5gkOj1k/L
	aIv2RK/Av74U1mBfNTsD666YM0N1TF2e6/CbNIFIjCP8eGbkrUJt/iSrQgb3rCJ97y8paA9GL/S98
	dtc+xRzPJ/OPye/D9/t0uLsYJLim2ccXHx0geldZj1diUyVQ7pOWp7dRaaPHHjy+k8RprGMV5sQMl
	P7cy7dbkQy0RJKMPdwUH6BDab9kylls5JznmVsVIsCv2eE9fg/6XGp1TnrQ3EVNb+FTiPL6iKssPv
	1JUvBkHQ==;
Received: from [38.23.173.23] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wxUtD-0000000E0lu-46Ad;
	Fri, 21 Aug 2026 19:26:56 +0000
From: "Liam R. Howlett (Oracle)" <liam@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	maple-tree@lists.infradead.org,
	"Liam R. Howlett (Oracle)" <liam@infradead.org>
Subject: [PATCH v3 10/19] maple_tree: micro optimisation of mas_wr_store_type()
Date: Fri, 21 Aug 2026 15:26:18 -0400
Message-ID: <20260821192627.4085470-11-liam@infradead.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260821192627.4085470-1-liam@infradead.org>
References: <20260821192627.4085470-1-liam@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 85xijt56ngrj4k4k7kz5byirbzj7jmte
X-Rspamd-Queue-Id: 0533A180003
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1787340416-93920
X-HE-Meta: U2FsdGVkX1/FLkEgqjt3B/tfcsRC0Xb+RJbZ0j7GgQmeWVNdUoRhbqejY9sMy6KAQOjBB9HxzmH2IAUXgPiRBagxdmpKUQeVAFXjLTMpFhxhHbHqQBnIuEfGtnu1XvcU3NhuLV18ubld8MEPTwCEoiIEKtoymeydnp0/PRDEHh9uOhuGCmCQ7YFqAstcY0cgrxr7g8GusmROqUmCAecHbYKmP1cSlyXO6LZ9CPwAcVF7QJ0JacsiJxtg0RAtgWkY9QMOl4eVavPa+i34CrgznOlbNOYFWlqPDLABewMKXVRhem+erga6Fk9fTeRVBMNvpBhilleBbPW6+2O0ezSthVUEbqm9h/wGq+gP63ItO/OqzNLQGDyFBpwQNHKAd7I/qMIV+QD5Dsk4/AHX37Z+NURwjrLjc8zTyMOqWH/ytRPylgzdJByyk9GZC4L9XwZ6X3HwxuAlm7EDA+zxnBBqHEv8OLLE/RDdUTvFi8e4N12pW58i0KHh5msvngysrLlZtk/lo8o3I9he7DgXjZw7dHj1PqoWSP5Exa0LPSPczPQNg6C4RhOj+HqDEPswhuoEFjyT2Obh2NGmsZU18R+QzCSlE63wmc6+R2fy5m4vS96+Vn+YGq7HuevK97qTZ+OqogllhIh8OV0LmMo/A0DhiaTuJP4HoQUC0aduYiThcvlxh4xN0/T4TAoXUNatscTb9Ctjcs1FQ/7kSoRDR+P1rka58lHxo+itpir0ICVb4SScm7lceZgq4N7DfG67E2FlCRJ88gaSJdMRB6F+EnFmc4BXnM98wtQqEQbiH29/fLnBCKflJP9jv28hpFsviyrgZlwj5kOBuBlT4q2nG/rE1o0mtKPvBDsNlzH98E7oaSSMyJvldE+bxzqw2mOz7uePQzePSOxULOkgRhTioNVNaaJGRJANRn3gBtdEaAgkRP6s2GVgNStV8eEAsYAz+wGIwCO6mFRCXbsfNIqdSl/
 qcukfDwb
 M5++7LZEMaSGLB0sZ28TigbodB7YgeVw0sN2Jnt/2ay8+MmSoz0mk4rr2p+gOcgSpZw7MHkNN13PHxoTnpjtBv8AaEGInHZMnMBlbhujfdY4jYfaURzzwBTbi5qZ7PP7zejt5DWDttvRaS3x16EbYGwJ5VSIOmQuxErPoE4Q2mMHyWYdPkkI1+TRQaGD8LsRSOHGnFycBH1VGq3ZEQle45NCaZGCrVhmX5k2euTuCsd9Czu15nPj9bindlRvBUW3YF2yhrjr/ly/JGMh/bwBVKtyJ111CkNgI54/s+QpLmr2L0vLqj1F2nkx3BpKlNYWIL971r10m8gjB6z3F4bRhIDs9Aw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Use three new local booleans instead of reading other structures.  This
has shown an increase of 0.62% on a 2048 entry tree of height 4.

Signed-off-by: Liam R. Howlett (Oracle) <liam@infradead.org>
---
 lib/maple_tree.c | 18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

diff --git a/lib/maple_tree.c b/lib/maple_tree.c
index 56812db8b0efe..e2c780a64c9c1 100644
--- a/lib/maple_tree.c
+++ b/lib/maple_tree.c
@@ -3737,6 +3737,9 @@ static inline enum store_type mas_wr_store_type(struct ma_wr_state *wr_mas)
 {
 	struct ma_state *mas = wr_mas->mas;
 	unsigned char new_end;
+	bool appending;
+	bool one_slot;
+	bool in_rcu;
 
 	if (unlikely(mas_is_none(mas) || mas_is_ptr(mas)))
 		return wr_store_root;
@@ -3756,21 +3759,30 @@ static inline enum store_type mas_wr_store_type(struct ma_wr_state *wr_mas)
 		return wr_new_root;
 
 	new_end = mas_wr_new_end(wr_mas);
+	in_rcu = mt_in_rcu(mas->tree);
+	appending = mas->offset == mas->end;
+	one_slot = wr_mas->offset_end - mas->offset == 1;
+
 	/* Potential spanning rebalance collapsing a node */
 	if (new_end < mt_min_slots[wr_mas->type]) {
 		if (!mte_is_root(mas->node))
 			return  wr_rebalance;
+		if (!in_rcu) {
+			if (appending)
+				return wr_append;
+			else if (mas->end == new_end && one_slot)
+				return wr_slot_store;
+		}
 		return wr_node_store;
 	}
 
 	if (new_end >= mt_slots[wr_mas->type])
 		return wr_split_store;
 
-	if (!mt_in_rcu(mas->tree) && (mas->offset == mas->end))
+	if (!in_rcu && appending)
 		return wr_append;
 
-	if ((new_end == mas->end) && (!mt_in_rcu(mas->tree) ||
-		(wr_mas->offset_end - mas->offset == 1)))
+	if (new_end == mas->end && (!in_rcu || one_slot))
 		return wr_slot_store;
 
 	return wr_node_store;
-- 
2.47.3


