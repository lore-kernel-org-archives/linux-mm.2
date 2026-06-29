Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 53C17C43638
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 14:43:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 86A4C6B008A; Mon, 29 Jun 2026 10:43:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 842E26B00F0; Mon, 29 Jun 2026 10:43:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 759616B00F1; Mon, 29 Jun 2026 10:43:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 488D86B008A
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 10:43:04 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B1CD9120128
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 14:43:03 +0000 (UTC)
X-FDA: 84933217446.02.7E659A8
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf11.hostedemail.com (Postfix) with ESMTP id 3C3894000E
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 14:43:02 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=alw+9xXW;
	spf=pass (imf11.hostedemail.com: domain of liam@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=liam@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782744182;
	b=0HSyugNJuHdRBnmPLJP8e7XSVacAfiDv0ocsd3t7rjdREPk9BuZ4wPnN9MGO02dq6FzYYN
	0vJSBYk4V8QUXvMxkYjYtHyWTfMwfLG/sjY95QMjDZhDQTSH/mchCG49150nT0O1WKuH86
	fNbcpMV3gL9oEo22gSs5yy0xEiGwp3o=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782744182;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=B1Ckdeltb95QFCGV04iFuxHQugOzeBjtc5c251+J6Es=;
	b=4OkjtpkDGJ56T42BEaGb9wnE/hYJrMyy8qokL9jOR/mAICQeksb9RD22nfLGHQKnlOzARN
	m1SnY95RvrsendhDAcSWpwGbIhwb/yAtkiTRehuG/Hi4izZBh/zUi0VuurV80LrikWL6dd
	9BQoxx4iB360dIh34W1HRKqF6vyLlgM=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=alw+9xXW;
	spf=pass (imf11.hostedemail.com: domain of liam@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=liam@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=B1Ckdeltb95QFCGV04iFuxHQugOzeBjtc5c251+J6Es=; b=alw+9xXWMdTxaibSc1faZFb44V
	nE8Z+84GTAXISWMVlfUiwcGJBiYuk0BvqtUunVvw/eybz4mdwwpzve8M53pozZQ4CqycaEUkrpa3/
	gbtwlUsjBtkxC7qKs5hiD8I/0h4G+KtoCt3EMzrCE8VIJPv/6aTCrYP/OvuKOni31FSBPMg50k3DO
	ydW0zh8LanBg0kOucKEiYB9ANvlaSnZSFDRnLUKgRRvKJ4CJNuqZgAhMTBPplyG/rFccryTMyWRLH
	FGEkGInd/rSlNSNtvaIW77vmlp1rOOtLNmZTkwKhdOM/bnwySNcw9qigASknzBECf/bj05tVGBmMV
	lB9HJvoA==;
Received: from [38.23.173.23] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1weDCP-0000000Euiy-13Vm;
	Mon, 29 Jun 2026 14:43:01 +0000
From: "Liam R. Howlett (Oracle)" <liam@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	maple-tree@lists.infradead.org,
	"Liam R. Howlett (Oracle)" <liam@infradead.org>
Subject: [PATCH 18/18] maple_tree: Avoid extra gap calculation
Date: Mon, 29 Jun 2026 10:41:45 -0400
Message-ID: <20260629144145.1572283-19-liam@infradead.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260629144145.1572283-1-liam@infradead.org>
References: <20260629144145.1572283-1-liam@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: o49yt5sr7fbm31iz537cs666rf888en6
X-Rspamd-Queue-Id: 3C3894000E
X-Rspamd-Server: rspam06
X-HE-Tag: 1782744182-570954
X-HE-Meta: U2FsdGVkX1+IPDc4TS43oDd4sP0Uq6/3rusZVGRI1c5I0diSAPC2Gzivxa/3HnHPBQjJmLgIk9arnTJa6+54slScWQmnlDUWJKPYxVPzRjOrijCn9A9cqmoKVbSCYV1+k8cXuvdXfanaxkU8JpJd+IA+qLLowmmWzw9TY0DMY9k8Q6hRNoxiW8MVcl0HTIB71XKLoqujqrhu5hGaIkCxBoUV13xywF3Q/vkPI2d2SlokosJ8IK4vkPK4Tq3bSYJ5AGUnOw7whWNWGTBSczh6692In+STlYlheFHUlxEg2t1V9SRWAF0CCvBDQT2/TjpuT+VX6T80CSilkLnKeRJgz8jCC+VjuQGqpO2GnJx+B2xBXpfbUbOJzGwsiYTuAIP/OkE+NiA6q43WcS1SA1HTfoYyjrXOWoBhTrqtAzddwVU4nC3lfJ+hV2HE1o6XG4m0KzLk2ZI0kataMf+Z671yoi09KGY3RIGvfFsXlNlmAryMJHuDGoGu9jewgHgwO0vXErUGO2mRYWUVG3vdy0ipyli7DFUt7qbIxAzwBgbkEdsHhDnF/kTIWUekyjvJiA/qsXsik+azUZ2txMNIFFyA3CoVYGFciSyEW1O5bZ95JpFtWuXhwJxv/Qe/8njQdtp+6fPX6VD0livAcuwEaDvBUnMy9HVv/RyZpw6wn7ATyOpAoIYAaCJvjzIX5nPPGBC5ouECfu7T9RgghU1uXk8X1uK3s5DPhexAyHGWOzVPjWPhS/r8DVYPtgLl012FEtlY1ZO9MVSss1f7Uiv+jXjD5LcGM0T44PvDiIoZwIwRiz+hc42NQNYC7Ywe7AyOPJrX1NSs3jhbkN4lxXBVu5ughl6D1CV6Gb5aIzM8vWcWXnTN4YSvOcfk8se9WnD5Xcd9r1IkxgUEXGQ+YSQPiAIEjBqXHRpdTna32VEyrWHY8X6VXrMAr3WLC29osHYBQe1vA6+WNHNbLXHZW6wzTBk
 JBFguUsY
 Ej+nf21OpUu7XPq4+eO15cnqLvi/JqeLq4qma+Doay3zK9o8ycYTju6XVVDnkyRbnnudYBfIaZrywb1hrmo4XnidhXomuw8hxYLvbfzMSHlMyE/dbJlZT1l5LtqHBpb7MVgRtwytrdm79hUn2aFgSS3ANVEjyAp71+wLbLc6h2JMRJ+OFMgu7Xh6/lbcVMrDC694b1qkPIWuuf1aKlqGdQVEmWFFalmRBvBy7cEoDxivr0foXc4PErheDdS9kTc02HX9qYzUrAPa897i2ijAKy5aonz+2Nc9VRR3fIHAJAvx3eCFIfddCtlFOLN8CFZE+Gf0UekJx7UvbO+JHDaa01ZhKJQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Prior to ending the ascension loop of larger operations like split,
rebalance, and spanning store the gap in the node had been calculated.
Once the node is inserted into the tree, the gap is recalculated in
mas_update_gap().  This can be avoided by creating a helper for
mas_update_gap() that accepts the known gap value, which reduces the
operations required for gap updating path.

Signed-off-by: Liam R. Howlett (Oracle) <liam@infradead.org>
---
 lib/maple_tree.c | 28 +++++++++++++++++-----------
 1 file changed, 17 insertions(+), 11 deletions(-)

diff --git a/lib/maple_tree.c b/lib/maple_tree.c
index 94f2d5b9bc881..6d71fdc414706 100644
--- a/lib/maple_tree.c
+++ b/lib/maple_tree.c
@@ -1602,14 +1602,26 @@ static inline void mas_parent_gap(struct ma_state *mas, unsigned char offset,
 	goto ascend;
 }
 
+static __always_inline void mas_update_gap_known(struct ma_state *mas,
+		unsigned long gap)
+{
+	unsigned char pslot;
+	unsigned long p_gap;
+
+	pslot = mte_parent_slot(mas->node);
+	p_gap = ma_gaps(mte_parent(mas->node),
+			mas_parent_type(mas, mas->node))[pslot];
+
+	if (p_gap != gap)
+		mas_parent_gap(mas, pslot, gap);
+}
+
 /*
  * mas_update_gap() - Update a nodes gaps and propagate up if necessary.
  * @mas: the maple state.
  */
 static inline void mas_update_gap(struct ma_state *mas)
 {
-	unsigned char pslot;
-	unsigned long p_gap;
 	unsigned long max_gap;
 
 	if (!mt_is_alloc(mas->tree))
@@ -1619,13 +1631,7 @@ static inline void mas_update_gap(struct ma_state *mas)
 		return;
 
 	max_gap = mas_max_gap(mas);
-
-	pslot = mte_parent_slot(mas->node);
-	p_gap = ma_gaps(mte_parent(mas->node),
-			mas_parent_type(mas, mas->node))[pslot];
-
-	if (p_gap != max_gap)
-		mas_parent_gap(mas, pslot, max_gap);
+	mas_update_gap_known(mas, max_gap);
 }
 
 /*
@@ -2173,8 +2179,8 @@ static inline void mas_wmb_replace(struct ma_state *mas, struct maple_copy *cp)
 	mas->node = mt_slot_locked(mas->tree, cp->slot, 0);
 	/* Insert the new data in the tree */
 	mas_topiary_replace(mas, old_enode, cp->height);
-	if (!mte_is_leaf(mas->node))
-		mas_update_gap(mas);
+	if (mt_is_alloc(mas->tree) && !mte_is_root(mas->node))
+		mas_update_gap_known(mas, cp->gap[0]);
 
 	mtree_range_walk(mas);
 }
-- 
2.47.3


