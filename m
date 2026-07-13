Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 81E46C43458
	for <linux-mm@archiver.kernel.org>; Mon, 13 Jul 2026 09:47:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 82D8B6B0095; Mon, 13 Jul 2026 05:47:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7E3F16B0098; Mon, 13 Jul 2026 05:47:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6F61D6B009B; Mon, 13 Jul 2026 05:47:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 45AA36B0095
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 05:47:14 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D2D081A043E
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 09:47:13 +0000 (UTC)
X-FDA: 84983275146.10.5406B54
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf10.hostedemail.com (Postfix) with ESMTP id D8AF7C0006
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 09:47:09 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	spf=pass (imf10.hostedemail.com: domain of husong@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=husong@kylinos.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783936031;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=PevrcelE81NNGM+FN+mjDMHyBEWX4U4DKuxIUeoVbRk=;
	b=IugHphDXxa+LJ+bK77UNK3P8SAmVmfbB01S3C2/uBLG5R2DE7PfX56ceJfWWxZ7rJ13w+j
	gP9p3AD3IOzUmXoDh+p7Xh8m7U2Sw1HJ0Gdo1Q9b0yv0gpCubU3u9gdygAlMV6bRu2D4bD
	kfsNpXp16/3x6ussH46pmjRlWF/rwBk=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=none;
	spf=pass (imf10.hostedemail.com: domain of husong@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=husong@kylinos.cn;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783936031;
	b=VsrRagfBQ6hScosk0a+UCrVknQMNxRXrIUtwxq9pJUQWuL09LGrYYdzmxMsbA8Ktw+hmNJ
	K11Lhy47mjWwFGyXCq4Hcp5ujT/+QQr5+hQ1vvXDPI32eZeRCk1UbfuUK1b0+fjk2PUb2a
	Id8IzddkmOaLIRrdpx5dBzBjLt/0Pn4=
X-UUID: cc00c1f67e9f11f1aa26b74ffac11d73-20260713
X-CTIC-Tags:
	HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NAME, HR_CC_NO_NAME, HR_CTE_8B
	HR_CTT_MISS, HR_DATE_H, HR_DATE_WKD, HR_DATE_ZONE, HR_FROM_NAME
	HR_SJ_DIGIT_LEN, HR_SJ_LANG, HR_SJ_LEN, HR_SJ_LETTER, HR_SJ_NOR_SYM
	HR_SJ_PHRASE, HR_SJ_PHRASE_LEN, HR_SJ_WS, HR_TO_COUNT, HR_TO_DOMAIN_COUNT
	HR_TO_NO_NAME, IP_TRUSTED, SRC_TRUSTED, DN_TRUSTED, SA_EXISTED
	SN_UNTRUSTED, SN_LOWREP, SN_EXISTED, SPF_NOPASS, DKIM_NOPASS
	DMARC_NOPASS, CIE_GOOD, CIE_GOOD_SPF, GTI_FG_BS, GTI_RG_INFO
	GTI_C_BU, AMN_GOOD, ABX_MISS_RDNS
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.12,REQID:707452e3-6bdc-42b7-a307-f99e573fba5c,IP:10,
	URL:0,TC:0,Content:0,EDM:25,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTIO
	N:release,TS:35
X-CID-INFO: VERSION:1.3.12,REQID:707452e3-6bdc-42b7-a307-f99e573fba5c,IP:10,UR
	L:0,TC:0,Content:0,EDM:25,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:35
X-CID-META: VersionHash:e7bac3a,CLOUDID:45f03bc318b5c2a89ee2ca66b1a07fef,BulkI
	D:260713174704KM5LZ185,BulkQuantity:0,Recheck:0,SF:17|19|66|78|102|127|865
	|898,TC:nil,Content:0|15|50,EDM:5,IP:-2,URL:0,File:nil,RT:nil,Bulk:nil,QS:
	nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,AR
	C:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_FAS,TF_CID_SPAM_FSD
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: cc00c1f67e9f11f1aa26b74ffac11d73-20260713
X-User: husong@kylinos.cn
Received: from ctao-book.. [(223.70.159.239)] by mailgw.kylinos.cn
	(envelope-from <husong@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 85431330; Mon, 13 Jul 2026 17:47:01 +0800
From: Song Hu <husong@kylinos.cn>
To: sj@kernel.org
Cc: akpm@linux-foundation.org,
	shu17az@gmail.com,
	jiayuan.chen@shopee.com,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Song Hu <husong@kylinos.cn>
Subject: [PATCH v2] mm/damon/tests/core-kunit: test damon_nr_accesses_mvsum()
Date: Mon, 13 Jul 2026 17:46:48 +0800
Message-ID: <20260713094648.897239-1-husong@kylinos.cn>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: D8AF7C0006
X-Stat-Signature: kar9s8oaidz963mwt9xqc564p98xc9rr
X-HE-Tag: 1783936029-511698
X-HE-Meta: U2FsdGVkX19CpbxXQBud+1kj4KdIkKM5al9UfjecS19RnGswFP4SwJpL3w+lFWWMrvYiLeUrsPacuKncDHtnEeWSovAfl54sfh2cXVaKifINN8LV0almXnjhX8JjXpTkMM0d6SIONfeltc0p+ub3rjN7USLHG+oVqSA4o+Tcdl7o4IYmpViXfgxWqtf7OU8ItB3cH2XP1+kv7khHaCckOjFoTBcP0d0J8bFXdWlm4P/PDBJ51S8tEOVHt3ApXYjy78T8GY+BTaiUiSknAKJATKTPL31dUtC6u35COpuHF7KzOYam8Q/XqIL4dbF0tPbsog8medU/kEDR2qYPt0MBLTSQ2RQ/hvqoHeqx9q0CjGCljXriV82ZcENFAOn8D+KjiWUNIVTpY4xae2fL+9N8xB0hCMkQCJqutkh7h0vO/1iipfulTMiXXhD+aSVLmbbbBSBrtq7iFNsTJ09p02F/IxueTh7htJRlYlwZ/aGouCBSn1qaSkIzqXSyzgbuNlFErjnPhV0tTGbq1aOGUhDp4wioYkajPlpLCIGIOw2HLx7pbbL0VkhVPB5njQDxPEEIuFQhUd8st4+wPO4YrJqZXO/N4C9G40Nwav3yUqGd7RmW3ozYAeiCqVea+xqiGt6cKzPV//3TvPGimQBPzUYYvzM2NTTitxO0isPWepMaN7NdEoBLCphsnYiQdwVyH7TB1cSftNovF9IxKIPopU8m/gR5XH3yspSC5jIBs7i61gAmUnYkta0p8TJIGdy7OMIzPf2kasgA2xKf4gAuAVVlgKywfhuFPAcet7WGkH38nm1NaihCfpvpS5XYXMXkQVueY+yF4DxR7jHBkvfx0+qo3w5wwkbfnTjgJKIclft5R8Xw952r/MmdSEqeoQSPdPcO5zVbgzSIwpDGQFD68OLOInZvlk84t0rO0GO7NBlrbUwIzkLajRRwQkltZsrV6T3ROCqQIfccagYAyeqjco+
 KyWxNSsP
 Qg0RMzV6kl8ht2nf5gRo9gx27xkxWgjRY+Zf+DfNwdPRNMR4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damon_nr_accesses_mvsum() wraps damon_mvsum() with the monitoring
intervals of the context to compute the pseudo moving sum of a region's
access frequency, with a special case for when the whole aggregation
window remains. damon_mvsum() itself is already covered by
damon_test_mvsum(), but the wrapper is not.

Add a table-driven KUnit test that exercises the full-window-remaining
boundary (with both reset and not-yet-reset nr_accesses), partially
elapsed windows, and the no-window-remaining case.

Signed-off-by: Song Hu <husong@kylinos.cn>
---
Changes in v2:
- Drop the confusing 'bp=...:' annotation from each test-case comment.
- Wrap the function documentation comment to the 80-column limit.
---
 mm/damon/tests/core-kunit.h | 49 +++++++++++++++++++++++++++++++++++++
 1 file changed, 49 insertions(+)

diff --git a/mm/damon/tests/core-kunit.h b/mm/damon/tests/core-kunit.h
index 0124f83b39b8..d085c90484d3 100644
--- a/mm/damon/tests/core-kunit.h
+++ b/mm/damon/tests/core-kunit.h
@@ -683,6 +683,54 @@ static void damon_test_mvsum(struct kunit *test)
 	}
 }
 
+/*
+ * Test damon_nr_accesses_mvsum(), which wraps damon_mvsum() with the
+ * monitoring intervals of the context.  With a sample interval of 1 and an
+ * aggregation interval of 10, an aggregation window is 10 sample intervals
+ * long.  Each row below specifies the passed sample intervals, the next
+ * aggregation time in sample intervals, the current and last nr_accesses of a
+ * region, and the expected return value.
+ */
+static void damon_test_nr_accesses_mvsum(struct kunit *test)
+{
+	unsigned long input_expects[] = {
+		/* passed, next_aggr, nr_accesses, last_nr_accesses, expect */
+		0, 10, 5, 3, 3,		/* full window left, unreset */
+		0, 10, 0, 7, 7,		/* full window left, reset */
+		5, 10, 3, 10, 8,	/* half window left */
+		8, 10, 3, 10, 5,	/* 20% window left */
+		10, 10, 42, 49, 42,	/* no window left */
+	};
+	struct damon_ctx *c = damon_new_ctx();
+	struct damon_region *r;
+	int i;
+
+	if (!c)
+		kunit_skip(test, "ctx alloc fail");
+
+	r = damon_new_region(0, 4096);
+	if (!r) {
+		damon_destroy_ctx(c);
+		kunit_skip(test, "region alloc fail");
+	}
+
+	c->attrs.sample_interval = 1;
+	c->attrs.aggr_interval = 10;
+
+	for (i = 0; i < ARRAY_SIZE(input_expects); i += 5) {
+		c->passed_sample_intervals = input_expects[i];
+		c->next_aggregation_sis = input_expects[i + 1];
+		r->nr_accesses = input_expects[i + 2];
+		r->last_nr_accesses = input_expects[i + 3];
+
+		KUNIT_EXPECT_EQ(test, (unsigned int)input_expects[i + 4],
+				damon_nr_accesses_mvsum(r, c));
+	}
+
+	damon_free_region(r);
+	damon_destroy_ctx(c);
+}
+
 static void damos_test_new_filter(struct kunit *test)
 {
 	struct damos_filter *filter;
@@ -1576,6 +1624,7 @@ static struct kunit_case damon_test_cases[] = {
 	KUNIT_CASE(damon_test_update_monitoring_result),
 	KUNIT_CASE(damon_test_set_attrs),
 	KUNIT_CASE(damon_test_mvsum),
+	KUNIT_CASE(damon_test_nr_accesses_mvsum),
 	KUNIT_CASE(damos_test_new_filter),
 	KUNIT_CASE(damos_test_commit_quota_goal),
 	KUNIT_CASE(damos_test_commit_quota_goals),
-- 
2.43.0


