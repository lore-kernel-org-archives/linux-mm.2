Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E58FAC43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 19:09:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1061A6B00B2; Tue, 30 Jun 2026 15:09:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0194F6B00B4; Tue, 30 Jun 2026 15:09:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DFBE96B00B5; Tue, 30 Jun 2026 15:09:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B579E6B00B2
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 15:09:07 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 3DA4112060F
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 19:09:07 +0000 (UTC)
X-FDA: 84937516734.12.054A5D6
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf29.hostedemail.com (Postfix) with ESMTP id AC38D120002
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 19:09:05 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=3bncAdR+;
	spf=pass (imf29.hostedemail.com: domain of liam@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=liam@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782846545;
	b=fIu7iL/67tCevrVU7i77Xr3krAaMHmzpAwpTeYS2cAHWSnSOCIMJ1U0as7SBcLRBcg5YTh
	68AqgEKd+pSRuj23Cpivp1nilRtLYy7cE5GEFKPTg+XY/OlIz9sgTLziYIaaiw1FLsU7uR
	VsHdB8aBmJsiZldSZPVlxwi0CaWkLpk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782846545;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IEh6mKqSChyP6nlTu9460jgHkPhuMRjj4FVGibEoyXE=;
	b=FAUzihQbUeqbQA3L53BPL0Q/IK8eWGkLxlzyoKN1PLfLkjC0E7fHO2ZeLjukhEgPYR+Fgm
	Ci2PnF6SCIDGJf0cqzlqO9eTJxyE3m5w0TDnBgphf6gsGNf1bTfxWNjIgyeftRKdk2XjKD
	RnKQe4kFc/lMsMMdP1+FYezHQELSzfY=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=3bncAdR+;
	spf=pass (imf29.hostedemail.com: domain of liam@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=liam@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=IEh6mKqSChyP6nlTu9460jgHkPhuMRjj4FVGibEoyXE=; b=3bncAdR+RCglPPzy90z05Z+dKy
	xTOxtAjFoamH2C7k8m/cCmza9kRFJmi2beXPldDauiYsxvqxJ6YrKL3iGlNGXDsZzV9dU4KeOHluP
	fcHqnVh5cxhKDiRi1evXkEppdb7P7zpwJt4u6+xJpk2LglHj4BRO5d5oKVWGlH0/tmcPVXkkVGLsc
	YwUbBh0sQRy4kQbFJxX6+O0cUUcO2ZXVvCHAbFIcHyNJdw8KVySlgCY3nvpFpt3J9QIDCoi90sfOp
	IPAi9Cvn4KAlaq5CrvnoJbD3G3mAgHD/mC9vGTiArHXXEwVc5ggErgYbNtgcrFN5VMM6QefiTIVmy
	4tdndmBg==;
Received: from [38.23.173.23] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wedpQ-000000005vq-0HLl;
	Tue, 30 Jun 2026 19:09:04 +0000
From: "Liam R. Howlett (Oracle)" <liam@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	maple-tree@lists.infradead.org,
	"Liam R. Howlett (Oracle)" <liam@infradead.org>
Subject: [PATCH v2 10/19] maple_tree: micro optimisation of mas_wr_store_type()
Date: Tue, 30 Jun 2026 15:08:34 -0400
Message-ID: <20260630190843.3563858-11-liam@infradead.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260630190843.3563858-1-liam@infradead.org>
References: <20260630190843.3563858-1-liam@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: AC38D120002
X-Stat-Signature: gser8uygd6q5e5uw3jjdfee3cszrm5is
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1782846545-324146
X-HE-Meta: U2FsdGVkX1/I+MvCnk5qOFrQtM/doUXPkahkEyFF095zJIp3oYNGcyRh7fqVObUl625T+ANN5lh7Y/tpsRXWUs1uYqcrQ/rKS4VEdtrMZ5OXoUPWxCjDdq3ZAxePRvo3usBrCC7JhUUS+S+3CvKBNv96aae5bzBm3W7d68U4GLXZJ6pOSxiQdWuj+TrrPDh3LLYRKPuTKekFMV7F+UC0z6/AAq2/7zk9v2DjF90qk1iwnyriLzNTNaaZaCnxpABro+szJ+VOH0ruqmWQPcH7HnuFE9cF6jz8RTRPguMSV+qnhp2tH07KzuOB726tll0/39wpYnsqB5AukL7ACmfl3ak7ybTM/AI7GtSPki9ZMY9WztbIoG8tzEL7Js8nLTzgNRdE4XmHEUK7qiEXroYFrOxZjGfafmxMwtVZTNqGmvmbWX9OKCwzDvW4IxJWBeh+Jqz7p5VZhzGUH8Zn13y3V76lskJiq9ulJoQpzXBVQff6cLEZeqqXN05dX4jKzEWjx4XfRtuTPVisyZmGkXEC0hDJLzgBAmyrF27Y8vKEbYvfRyHM8MszsefMs9/vSX946XPCVsL4M78hXG94wCIMHIsdiyDSJJ8o+uGzmVN0bJ3OZfC2lbbRePjYIgVkKdlr+yQ5H05JaXh9cCVpc2QKrjdO82F78y4vzKckGEh63uo1rgvjBttKHF2MI8mRoDuDnzgWEuC2GCesSOorNdk28/Z3vM3P3KL3lEKkzRIdkhjyYr9nvbFAHsvMWN0ntqWa5tU8vTQ+C6FIE11MGc/IoBK6z3JP2ZE7a7S9UiHIjEcjLuWJPYZmpXtednUco9JP0q09QEhTEsSO6oiS/8c/DJ79fBaf2B6ee6gXBz2KaBJ2bbyZ55ugzyWzSkMwpyGeeVs6tNmG0cI7YKNrKeOkMJxrmr8+JRszJgvzFrGVAVlW01+8bDZr7lQnUbQKgOaePFQ5hLTQciaEg80f4b/
 mosuJW7r
 XH87/8ZoVW7UxxNJhDxuNdaN+bgnb/7wx9BvtizWbyZYihhoIi0wi1c5v1wwWFpiMaLkZ73QxgwG5GfnVb6C7KDuwkbn4Sw1q++tKfFuxTPJXgqO1u0IFIkzTQqkDspBlAR8wi4+exmMGLXU25jpaj6hOQSK36jdVWfDIBYduLEqDskenbHHo0OpJpCx5zIjLZ/oF37L48SJE7Yl+S8IXx5HF1z2W6Sp3kQVepfjM6wgK522zYH19EIhElnF66TNR821hzq6ReinxvB1FaBDtqsgGjsfQ8M4WdlbNOXc9O3f0L2IWJx3f+GHELrZw4KDAcujFPDa7lLRdZ+tM9tZcZ1KUUQ==
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
index 1c96b3a5dab60..999a1d095e369 100644
--- a/lib/maple_tree.c
+++ b/lib/maple_tree.c
@@ -3736,6 +3736,9 @@ static inline enum store_type mas_wr_store_type(struct ma_wr_state *wr_mas)
 {
 	struct ma_state *mas = wr_mas->mas;
 	unsigned char new_end;
+	bool appending;
+	bool one_slot;
+	bool in_rcu;
 
 	if (unlikely(mas_is_none(mas) || mas_is_ptr(mas)))
 		return wr_store_root;
@@ -3755,21 +3758,30 @@ static inline enum store_type mas_wr_store_type(struct ma_wr_state *wr_mas)
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


