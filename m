Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 60857CD4F56
	for <linux-mm@archiver.kernel.org>; Mon, 18 May 2026 23:41:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3CD0F6B00A3; Mon, 18 May 2026 19:41:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2DD5B6B00A8; Mon, 18 May 2026 19:41:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EF0996B00A3; Mon, 18 May 2026 19:41:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B98876B00A2
	for <linux-mm@kvack.org>; Mon, 18 May 2026 19:41:27 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 800E2A0B0D
	for <linux-mm@kvack.org>; Mon, 18 May 2026 23:41:27 +0000 (UTC)
X-FDA: 84782164614.28.8FF36B2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id BD3DE120003
	for <linux-mm@kvack.org>; Mon, 18 May 2026 23:41:25 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="bjMok+L/";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779147686;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1EJUFMRnvaVdJRL4lAz10e96zvvvSg+wUvPv3eVhy+w=;
	b=RopuReFPkr64FkZd814M6ANT01Pyg3V/V4aAKqN+W1vIs90Nf6aFYIqANMSfCMngWiOs3A
	Ns/Y+WCMaP9pjBGITtqzYzlt5tQ25WMSaohTQDuuI6o0fh17cnhA1nPT0IPMUCKmmx/KdO
	huWvh0gEjiZGTXyNmEQaoic9ea7IIk8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779147686; a=rsa-sha256;
	cv=none;
	b=Uf8aTSjzO1Zq+3AHV5Qm+N5cNlOqu9yIDn6QfyQOs3/8Y4O1QLxq+yih+NB2W+B04Y1VRZ
	a8aMmARLkAUTsqgeaK3LmGK2ZTVOlmLcHeMahELn/FISG8AkqXUVcgMRZbP/TjYIqzrE+j
	fJbPJysZDeNtzPEcumiCzy3d+hjQZtc=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="bjMok+L/";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id C410E4452C;
	Mon, 18 May 2026 23:41:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81597C2BCC7;
	Mon, 18 May 2026 23:41:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779147684;
	bh=94Qr9IFKkWG9Mojgz+bl9B4vZnOt7au8kRAVlKYdFQA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bjMok+L/UpJK1v8J5IfXwSLOAwkOflKm3vr+Jrr+AC2hKG5kEuhbMy+5QW1dvkuwM
	 5wwIJ5iewvKVep/IpsYA4aIppO9GLKqH/ne77X6KuZX2ekF3H1FmwCApMD0U9Nuo7i
	 KNKjuY6b8goJGXBvREVbWc2/yDPfodSenFLox4x8mPtUsEGPaMMH0E2+AnZNel9M8r
	 cYPWVqJFcKOwSrwMIrWzAiT8aOSyQpd7AHfiR6m8FnnB6s1n/rE/AMZlJF35dgLuRX
	 KOMV6h8vU/ULk+SeUqzdAlblFF5LVXL1+/dkn/VEI5AtrXi5SGMertHWs6sM0cCMkD
	 XI8HGVOYdXcqQ==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 02/28] mm/damon/core: embed damon_probe objects in damon_ctx
Date: Mon, 18 May 2026 16:40:50 -0700
Message-ID: <20260518234119.97569-3-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260518234119.97569-1-sj@kernel.org>
References: <20260518234119.97569-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: BD3DE120003
X-Stat-Signature: 6d6mgyyz7hijhtit3xxbftjfuhx1378m
X-Rspam-User: 
X-HE-Tag: 1779147685-973098
X-HE-Meta: U2FsdGVkX1826IsfUSdo9a6YAkqA/PUzi3L0cN2Z9CaMCdpMMCL31jAMbKQt3cPS14R9ACkj7WwNpu9nCsctxG7Vfx1FcLosFTuGIFiEa2arZcCd42V4usiLswlL/p7w78qFIWrE7KDS2oI6TILsDVn6kb4NjUmZNVk1AabraRvwHS2R0MZf3KbXAhLwxt+gUrxzBkHBeBfefiwMHtIz5UqlLn9OXxy7lah/C8gim3ZbSUHEGsXkAWJzhpwnq9QLoOVNJBfJQnIwPHD+mQ56lHUxWovolbjngNFEXVhxGOrnsekmIFqYAcoPb2n0cSi6dV22bkXeGNiZl/c0zJtCPVG3qJ4nUmly6ip2k6IkC2dyNXc1Y73uokVuTNtElGm3NSWqO1xs21us+c8Dmfr0PoiZZ7sL7qp4LcRx3ihFkIaBvRtjL+Lj8QwX6nfsdMkQZHpxIJfM4ZnMbtBQQJMUaaxds0C4kisRzJToNdXrfYu6GXsqE1Mlh4jgyhPOqIKWAVlj73CcZt0w+Cp44JJwO5R0oWOE2KsHqGGyBVVPOinfF8IV154tmPTyODkwJX+64WJnH1BKuf9pmJx+MHt5LRLzhqgTpES5fhBLRQHoFlaT/98fvUl3ayb9ad4+Yf6yGfps0erk+wDWbzutR0XPKGgsGYd746RztAy+Y6EQc4UDaO04i2rpOm2LK0KYYFyIwgFHxgurcVCv8B9sQ0N+IreDpk6VNa5s1ySkfW1wXGi1plGKHrdIp60yc1ryxYDlSFc3qbQRuVbZdFApo84qk8vdx/MP+3ftnTjnpvcUpvqX9bzf8XvTCKfLDVWmYvlPcsLWvPprXjOLup+uWiSNlCTXsuZsxxRrTJ0f4OKGGkOc7wROigp17qrhf2HbpqADyKPminxRnQLYDg+9UTxu0qNzlQ7mkiBpchzHdvpHAwsxS6Qrl5Ce0mpuAExurd4Wf/TJTLI07O0yvdARQrB
 5BLZsJ6P
 X+bsuaPJQR4cAuwNG58cf5BgkQbLG7ba0G9OFRudZwKpSST8+m69XiHVeUhwEzzXopgBac/r7YwgARiTmSoHxXDimmKNDjbj4GjO0Ed4v4nvEPoH0AmClf+7AGYHJyMC7saHkSH/eNFZaRG/DXzLh8nnCP+Obi++hH5FSSn4kL4/S4VL6KrmKJr76cNqn8o3LU1/AhPGCcG/V+ip29hetEzTrjLjxnM5j5r9ushuZRyaWbJg7rxZbcm79JJhijSx3HzABrTk2OtViu/OpxfW38Qj6FQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Let damon_probe objects be able to be installed on a given damon_ctx, by
adding a linked list header for storing the objects.  Add initialization
and cleanup of the new field with helper functions, too.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 include/linux/damon.h |  9 +++++++++
 mm/damon/core.c       | 38 ++++++++++++++++++++++++++++++++++++++
 2 files changed, 47 insertions(+)

diff --git a/include/linux/damon.h b/include/linux/damon.h
index 4794931fa2ea3..43d71eb24ccb6 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -857,6 +857,7 @@ struct damon_ctx {
 
 /* public: */
 	struct damon_operations ops;
+	struct list_head probes;
 	unsigned long addr_unit;
 	unsigned long min_region_sz;
 	bool pause;
@@ -909,6 +910,11 @@ static inline unsigned long damon_sz_region(struct damon_region *r)
 	return r->ar.end - r->ar.start;
 }
 
+#define damon_for_each_probe(p, ctx) \
+	list_for_each_entry(p, &(ctx)->probes, list)
+
+#define damon_for_each_probe_safe(p, next, ctx) \
+	list_for_each_entry_safe(p, next, &(ctx)->probes, list)
 
 #define damon_for_each_region(r, t) \
 	list_for_each_entry(r, &t->regions_list, list)
@@ -951,6 +957,9 @@ static inline unsigned long damon_sz_region(struct damon_region *r)
 
 #ifdef CONFIG_DAMON
 
+struct damon_probe *damon_new_probe(void);
+void damon_add_probe(struct damon_ctx *ctx, struct damon_probe *probe);
+
 struct damon_region *damon_new_region(unsigned long start, unsigned long end);
 
 /*
diff --git a/mm/damon/core.c b/mm/damon/core.c
index 59e51134d0ed0..6ce1b949efaa7 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -113,6 +113,38 @@ int damon_select_ops(struct damon_ctx *ctx, enum damon_ops_id id)
 	return err;
 }
 
+struct damon_probe *damon_new_probe(void)
+{
+	struct damon_probe *p;
+
+	p = kmalloc_obj(*p);
+	if (!p)
+		return NULL;
+	INIT_LIST_HEAD(&p->list);
+	return p;
+}
+
+void damon_add_probe(struct damon_ctx *ctx, struct damon_probe *probe)
+{
+	list_add_tail(&probe->list, &ctx->probes);
+}
+
+static void damon_del_probe(struct damon_probe *p)
+{
+	list_del(&p->list);
+}
+
+static void damon_free_probe(struct damon_probe *p)
+{
+	kfree(p);
+}
+
+static void damon_destroy_probe(struct damon_probe *p)
+{
+	damon_del_probe(p);
+	damon_free_probe(p);
+}
+
 #ifdef CONFIG_DAMON_DEBUG_SANITY
 static void damon_verify_new_region(unsigned long start, unsigned long end)
 {
@@ -605,6 +637,8 @@ struct damon_ctx *damon_new_ctx(void)
 	ctx->attrs.min_nr_regions = 10;
 	ctx->attrs.max_nr_regions = 1000;
 
+	INIT_LIST_HEAD(&ctx->probes);
+
 	ctx->addr_unit = 1;
 	ctx->min_region_sz = DAMON_MIN_REGION_SZ;
 
@@ -627,12 +661,16 @@ static void damon_destroy_targets(struct damon_ctx *ctx)
 void damon_destroy_ctx(struct damon_ctx *ctx)
 {
 	struct damos *s, *next_s;
+	struct damon_probe *p, *next_p;
 
 	damon_destroy_targets(ctx);
 
 	damon_for_each_scheme_safe(s, next_s, ctx)
 		damon_destroy_scheme(s);
 
+	damon_for_each_probe_safe(p, next_p, ctx)
+		damon_destroy_probe(p);
+
 	kfree(ctx);
 }
 
-- 
2.47.3

