Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E4BB3C43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 19:09:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4D6636B00B1; Tue, 30 Jun 2026 15:09:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4AB166B00B2; Tue, 30 Jun 2026 15:09:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 34DC36B00B4; Tue, 30 Jun 2026 15:09:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0B8E56B00B1
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 15:09:06 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 93EA01C3813
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 19:09:05 +0000 (UTC)
X-FDA: 84937516650.29.E2FE435
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf10.hostedemail.com (Postfix) with ESMTP id 6B43EC0011
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 19:09:03 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=DN1i6EsS;
	spf=pass (imf10.hostedemail.com: domain of liam@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=liam@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782846544;
	b=lObm/z9dr/CC+u9990zT14wvLXzcLQER4XQIM5ZbPWPWs8XZs/q7nKRkzypUJxe2GrEvZQ
	LccqeCuXxTDqCs4XRTjTZox0YMbdkpDXk7W1xlZeVqA2kpv3DLzJ60cbIxsnj74AztSvQG
	1YnRF3bmdI1D08L+hMEmI9HEN+1eeHg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782846544;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UXutp8Kq6mfQ34jQx0qtQAgm1oKAPTTpjQhpDOqSy/s=;
	b=7DxYaAFPaUgZLI6prUOpv1x2CYpjaOS0/tF/xObNJCVvfBaodvvQdfWVgVUBx8u4MwSco/
	HY0DRmSeZSu10i1qp9DNFmuB2YZdR96nW5QcszVQMaM1ZV1lJMekEha+v8PmADIDxHXnVx
	HoGRNI4Y5HPuEjFfCjYOqjh+0XFXAXA=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=DN1i6EsS;
	spf=pass (imf10.hostedemail.com: domain of liam@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=liam@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=UXutp8Kq6mfQ34jQx0qtQAgm1oKAPTTpjQhpDOqSy/s=; b=DN1i6EsSiLU0IuSKqEjc9GtJ0Z
	C5NN283rS3lWfB1CSBAnz6GI2rbQOJmKT3Hu4uv2/WstRfaFxw16iWa1qgjJaJdme/XJ5uyuePXK9
	nGTAUBDMY7w1acOGgKx5+qbZT/qJg9ERhS6EEygCEafuw5AvEEdX3AqmMbJHGp8QJAg5fPzIWrKHd
	4hrvlVOtgSk8tnid/QSE86//rvFsgNlFaZgKr8v0kn3EX5QmbL9ZdO0MA9KcN/dn9AkA8zFFq/cF7
	LaMXcfSozTiOZfVIm4jiJN6ar65EU7YrF+q7nTX9RQIDCDcg9y0SMdi2CpXpLWtQUYiCoIRNONjgR
	zMH7bSLQ==;
Received: from [38.23.173.23] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wedpO-000000005us-1iZk;
	Tue, 30 Jun 2026 19:09:02 +0000
From: "Liam R. Howlett (Oracle)" <liam@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	maple-tree@lists.infradead.org,
	"Liam R. Howlett (Oracle)" <liam@infradead.org>
Subject: [PATCH v2 09/19] maple_tree: Optimise mas_wr_node_store() when not in rcu mode
Date: Tue, 30 Jun 2026 15:08:33 -0400
Message-ID: <20260630190843.3563858-10-liam@infradead.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260630190843.3563858-1-liam@infradead.org>
References: <20260630190843.3563858-1-liam@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 6B43EC0011
X-Stat-Signature: n44sxpiwxzout3kbyt9oi3stm1kydcar
X-HE-Tag: 1782846543-735991
X-HE-Meta: U2FsdGVkX19BSTDL3WAnlKHFh+KKPGCLS6zFnbTf3/S4yfARvHV4B2HfjV5nseQsnM0SJwWy76iJ5LUueK6ZOJLdd/LD7/b9eqeRJlbiUZqigFfQJbQSVU+FcveO2A3Rfyx6bLdR7f54J4b9zo7v70RT9NTtUio/SR9EvjEQuLLIJTExZ7aspexdq5H6G2BhTTbcRAoJz2/sOX4K4u9lls0IHx25CXwqbRiMq1I8vuGgq7d/xO9T+9ZotfpJ/8c3hifQ1Q62QqU37PSSDVS+BeoU/05CODjcGJD7q+QgduxaA+pODoOYZzeKyUFIE9mNWPPiOGSk6xB7rNq4Yq4hlm3Q8kBEbzVcpOsgBD5t7eknPUyurSY9yVuG2gn+8bKn2TihGNcQvbjsE99J+jSqQleyLTk3zOnT6RLm6nLw+cbg6jGGXpeJRvujUkLIhlomkJnjxKAqX7WpgJDQH2RSHbxT+5DmZFGEEXyOF2McQcHlQggbuzp3la0pjKlh4ikFfbwCj9j2ff2TjIsdYQiHolOh86FW7+MDBW1ZzTYi1xhVy8YIiZVRPHR7gvzypzu9xInOFQhp0tqRqqv+e7XprvzUJ6QVdKG1Y8KykAOCpFV53ihr5IL9d2lnVmnI3139HrjgCXwStYhUsmWGJNfVEHTy4ww+T6e2EBeYKL6AW86zQ1HjcrVJPZqKCYNbIT9wpM/GjiazRMtRsCSy75rL8Xd5l+KGEi480fS4NclLszLxAjP2QpAN4PzP+8gcVzEn0R44hI0OAF7WZQmbv1389TwXd6D7XHnCV6WWVktyeQMoAkj8KOr2vMAP3I2wbxzuTLoYtX/EdjCKtspu7WwZfo2cV8g+BylXiFKD5FZB68+Z7NMSZIP3HX2SmngU68Dw2/fxKkTlz98BC1P9tkoLGjSsmXLfOVzfvNO1mZ1Ywk9LlPwKj4UuupZuZrSSESTFbInHpgehRzPLtrZKO+f
 k0W67bsi
 s2CCTWNeVJ3BmoIkcL9Tx9oiRl432dSRh8n4CYrZju1PDEx+1wKhFqzfxQX+gRNtQvrxohtiFTGgq1CUOYMZKrvNOAXAe9+EFg25B/Gec42f5j7xgCG8qnH5i2jD9IFST7N/8TTDCfpeLYtMGeBPDBAqTKXzqIL1e3FiYyuij1Uhs8FbLtcQoMWiv6dZPkRlRqoivbnADUPvnhncNrA7hzKtGXtCPQ8JylYv4eXTfofzLtIc6Isn2v598ItEn+LgHOu2aXA9I3gb9aAL7Q7y3+ZBdejHOI3D12RyNx6dPtpbxQblv+jzE+x+rfgboqmPF8B8aYUadxl5hinK5wxhiGTc97Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Clearing the entire node on the stack is unnecessary since most of the
node will be overwritten anyways.  Just clear what isn't used after the
data is in place.

Benchmarking shows a speedup of 0.67% on a height 4 tree with 2048
entries.

Signed-off-by: Liam R. Howlett (Oracle) <liam@infradead.org>
---
 lib/maple_tree.c | 20 +++++++++++++++++---
 1 file changed, 17 insertions(+), 3 deletions(-)

diff --git a/lib/maple_tree.c b/lib/maple_tree.c
index 8f5a7fa10cf4c..1c96b3a5dab60 100644
--- a/lib/maple_tree.c
+++ b/lib/maple_tree.c
@@ -3186,7 +3186,7 @@ static void mas_wr_spanning_store(struct ma_wr_state *wr_mas)
 static inline void mas_wr_node_store(struct ma_wr_state *wr_mas)
 {
 	unsigned char dst_offset, offset_end;
-	unsigned char copy_size, node_pivots;
+	unsigned char copy_size, node_pivots, node_slots;
 	struct maple_node reuse, *newnode;
 	unsigned long *dst_pivots;
 	void __rcu **dst_slots;
@@ -3199,6 +3199,7 @@ static inline void mas_wr_node_store(struct ma_wr_state *wr_mas)
 	in_rcu = mt_in_rcu(mas->tree);
 	offset_end = wr_mas->offset_end;
 	node_pivots = mt_pivots[wr_mas->type];
+	node_slots = mt_slots[wr_mas->type];
 	/* Assume last adds an entry */
 	new_end = mas->end + 1 - offset_end + mas->offset;
 	if (mas->last == wr_mas->end_piv) {
@@ -3210,7 +3211,6 @@ static inline void mas_wr_node_store(struct ma_wr_state *wr_mas)
 	if (in_rcu) {
 		newnode = mas_pop_node(mas);
 	} else {
-		memset(&reuse, 0, sizeof(struct maple_node));
 		newnode = &reuse;
 	}
 
@@ -3254,7 +3254,21 @@ static inline void mas_wr_node_store(struct ma_wr_state *wr_mas)
 		dst_pivots[new_end] = mas->max;
 
 done:
-	mas_leaf_set_meta(newnode, maple_leaf_64, new_end);
+	if (!in_rcu && new_end + 2 < node_slots) {
+		unsigned char clear_from = new_end + 1;
+
+		/*
+		 * Note that the last slot is never cleared, since the metadata
+		 * will be stored there or it has a value.
+		 */
+		memset(dst_slots + clear_from, 0,
+		       sizeof(void __rcu *) * (node_slots - clear_from));
+		if (clear_from < node_pivots)
+			memset(dst_pivots + clear_from, 0,
+			       sizeof(unsigned long) * (node_pivots - clear_from));
+	}
+
+	mas_leaf_set_meta(newnode, wr_mas->type, new_end);
 	if (in_rcu) {
 		struct maple_enode *old_enode = mas->node;
 
-- 
2.47.3


