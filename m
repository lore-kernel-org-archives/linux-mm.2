Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D7D0CC5DF7D
	for <linux-mm@archiver.kernel.org>; Fri, 21 Aug 2026 20:13:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C35166B009F; Fri, 21 Aug 2026 16:13:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BEA286B00A0; Fri, 21 Aug 2026 16:13:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B20B06B00A1; Fri, 21 Aug 2026 16:13:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 8F8206B009F
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 16:13:22 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 29517A0265
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 20:13:22 +0000 (UTC)
X-FDA: 85126376244.12.F769DF6
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf22.hostedemail.com (Postfix) with ESMTP id 95ED0C000B
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 20:13:20 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=KkrpeCqP;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf22.hostedemail.com: domain of liam@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=liam@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787343200;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=s7XvHKqluwtAwKNSJOQ6OxYbkemecBatRbSPiv+AXJc=;
	b=CoNF9tPkb3Ohscmtiv+8/P2YT4aWPSRFeDb//30Mw9czwRI1Tz0mX2ZyfMnHG/JbSBcmDE
	ZOF53TfOSBjaJuOqJg8nCx3eK+PIZvDIuNPV1H9GDRFgunr50LQ+3VE/IJ4UQkR4tUuvTq
	h7edBzsM+M+6eBEqR03rJzTF9aixJyc=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=KkrpeCqP;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf22.hostedemail.com: domain of liam@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=liam@infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787343200;
	b=W5csVDMNsJHlPGRTxjrDQR7c7u92XnVkcMO9YaH9BXGPX31lQubcH2u/XUJMRcODEg1sE2
	OQF2c4qThuNyHJuqDJ+HMco6//8exu9aRRDki57MJ4qx0GNWoUvUODec3zpdI7ddFrfG1o
	9Fb4a9/o3QiQ9gbsO9sOr4tewEpKFJs=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=s7XvHKqluwtAwKNSJOQ6OxYbkemecBatRbSPiv+AXJc=; b=KkrpeCqP54zVTNvPzrW30XaDvi
	h7Rqq0W1cah7m6RxPfkg2HxoIbEM5SNLSGmaZCIImsU67NQY9dieT47/+3aHPenK7P+AOu+iYnxr5
	4kRSZqCjcqZSc1noJRvIPguVsW13/YZE/CKpLXSEBzH4lMBBL41rW23da/oYfW7ba4QWxBofQdppM
	+8Qwe6yI6RQCA5X0ypqwAJHhf/6UZrhjMUT/hAHxLnTFnpWiv6DfVbjXb/CuF6Ct4s32JS4xcU2oi
	0r3zobDrKLKN9CxPEx/1qvxOvl2dqFH6KNRLQwEPZf5v4Xjgrgr9m+7sb9FzaR+s1eMlOgLn9IxG2
	8696Q2eQ==;
Received: from [38.23.173.23] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wxUtT-0000000E0sW-1EHU;
	Fri, 21 Aug 2026 19:27:11 +0000
From: "Liam R. Howlett (Oracle)" <liam@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	maple-tree@lists.infradead.org,
	"Liam R. Howlett (Oracle)" <liam@infradead.org>
Subject: [PATCH v3 19/19] maple_tree: Add helper mas_make_walkable()
Date: Fri, 21 Aug 2026 15:26:27 -0400
Message-ID: <20260821192627.4085470-20-liam@infradead.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260821192627.4085470-1-liam@infradead.org>
References: <20260821192627.4085470-1-liam@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 9ok3tsk79ngsisto489i6wdzbdrckdoy
X-Rspamd-Queue-Id: 95ED0C000B
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1787343200-393836
X-HE-Meta: U2FsdGVkX1+nhcys8XzR2vWPeiqRcu9cO/6Ybfn9wX07ZhMCbAzMaCCfmt434cyf80ttl6dM6XXe1UwyTbemo9thr6ifYItP56K6+BxvLi8/MXfzTFq+XOzPDpP3Vi4gUaGit5jfnPtwRER6DJMgkihHFDUGGsLg/GXSKflpRtRBR+OkpYpGk9hsCxh2OIj3/cRBJjVybUD+8Q/Q4xBtTFxp/Z3p1PzGqXASJSSgM9nmuzCbYvaB0xT0cLvatTv65bu1mnmGCrtSbOkNiIVhr0vqXVGYM8uo/CX3P8nYeGhxEqLWfuX7wg2V910KeZAr6qdGaTGuIMFDzOEYPlXX3oMn5OsGBcgD3vfKxhGQdYIOQ/r3K+UBQyFWtBRtp5Mg6fg2FQa/6/LeybVn1y96+/NBj7EBsl07CoSFndhjT1QkxHvsjSrPLPvyO5O9Uo2Who6pmZAXAG1DEVk5Rn/Jo0uAjsAmWhmCP716o6W1mMOb67tqKJtnRzgY+DlP85r0L5ZGIJtVxii7IiVvRlpmRuWMlaTQ6HXCXSB4NVNeb4yZy4UaKlZ8GX4l+ZtATJeraHrvhnrirptBCWD/XDkRupmHWsRCUcC2r30+G0JktinwoAe6Ge2d5j8IhM2CWu+L0U9+6e3FLMWeXTNxCDEeQQZZIrUjZIBiCGbt0tq30AbMIpsejd0/Eot83ZprrHxkp0PVJTgIO8k8hE934G+ix8UDLB/0ySRbkNRvX2SWIc2MSPriKj3g76lWtro5383IOrHM1NEVSsCd7ZMSrFBvAJkj0//GPfYjG2kl23LJE11hJbQBDWUZU7BHgZxdvRybJudQpx0h73R7y0O5kSjOHpBrV+nhEaxO2/FsF01zHD2KqrBekXau6keLw5/CEC4hicj04TXDo6k9BQSz8LQ3SCpEeWvzLeYrwQfrqd2ZnP03Y+4nfFBUrLzjzIayXEuitZJ2S/xMpJ3qgEyojez
 dHbK8rTm
 fqeqvlAPcqzvYCWDna6axZIvLNxDIJTBodxWqRu7OH1OOB7UVg1W9oOPNwPadqgTs8B3+p6WmNZTJt7n8PJFgl/grTIH0YoYQQhUx5Rk6Lvv2QtXM492+N6Qbu79UviuCcpsvphRnpaZj4I7pw0o6pbztb0+rxqKeijzUkpExKLNtVnwcsEFcyMzltONf/Mjde3nC6TF/+usFfzxupO96VKIuhDQW9Zt27mP5qcTy6pRYxc06GXWzz7Ci043fR8LiQ6AP+wsX8dg6ev/Wkak+0iBFta/dxwiVh4gPCghYmWuP/+X548qurD6Gf+VYq/VmLucDunbP5w3oJbdn+T00DqcjLA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

A check in mas_walk() was incorrect and caused inefficient use of the
maple state.  The same issue existed in mas_erase(), but was left
unfixed.  Making a helper function is the obvious answer.

Signed-off-by: Liam R. Howlett (Oracle) <liam@infradead.org>
---
 lib/maple_tree.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/lib/maple_tree.c b/lib/maple_tree.c
index b43e2ce129b30..1aba6cced7130 100644
--- a/lib/maple_tree.c
+++ b/lib/maple_tree.c
@@ -261,6 +261,12 @@ static inline bool mas_is_underflow(struct ma_state *mas)
 	return mas->status == ma_underflow;
 }
 
+static inline void mas_make_walkable(struct ma_state *mas)
+{
+	if (!mas_is_active(mas) && !mas_is_start(mas))
+		mas->status = ma_start;
+}
+
 static __always_inline struct maple_node *mte_to_node(
 		const struct maple_enode *entry)
 {
@@ -4447,8 +4453,7 @@ void *mas_walk(struct ma_state *mas)
 	void *entry;
 
 	mas_may_init_lock_check(mas);
-	if (!mas_is_active(mas) && !mas_is_start(mas))
-		mas->status = ma_start;
+	mas_make_walkable(mas);
 retry:
 	entry = mas_state_walk(mas);
 	if (mas_is_start(mas)) {
@@ -5685,9 +5690,7 @@ void *mas_erase(struct ma_state *mas)
 	if (mt_external_lock(mas->tree))
 		might_alloc(GFP_KERNEL);
 
-	if (!mas_is_active(mas) || !mas_is_start(mas))
-		mas->status = ma_start;
-
+	mas_make_walkable(mas);
 write_retry:
 	entry = mas_state_walk(mas);
 	if (!entry)
-- 
2.47.3


