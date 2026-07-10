Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1B2ABC43458
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 04:16:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0407D6B008C; Fri, 10 Jul 2026 00:16:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 018406B0092; Fri, 10 Jul 2026 00:16:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E973D6B0093; Fri, 10 Jul 2026 00:16:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C579E6B008C
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 00:16:00 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 487381A028D
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 04:16:00 +0000 (UTC)
X-FDA: 84971554080.29.F16916E
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf28.hostedemail.com (Postfix) with ESMTP id E6818C0003
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 04:15:54 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	spf=pass (imf28.hostedemail.com: domain of husong@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=husong@kylinos.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783656958;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=BYezaF9YuINPLSIwZWHqbXqT8z7sOpw+eOJRIT+msIA=;
	b=HvXcXknHL3DE/uG0stFWXxynaBYLFasjori6RHt1DpXjSQRQ4VXnWR/t3na2mcffeqKsCe
	9ahAnjw2SjItVrqGMMIcXS3STl1dclK6u0DWRxEm4ssAh3kykwVe75UiP37LBpZkuqxXQo
	M20J0xmsHHq4ohim/l8fYVVVN0+bvL4=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf28.hostedemail.com: domain of husong@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=husong@kylinos.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783656958;
	b=cH4nTmcn3o6vcl52NjYPfznQH8HHYU18ZrdbwHi0pfV7pUyrcsi0cObIBK53bAXg5PuF7Q
	cdcx6Mjfz37JPJXhxSSXf2bWinmM1k20w3DT5+5ghvp7lJTWMQzC61R28rqf74Mc47xtah
	TZyCy+vRZKPHZ6kWg+kUwnnENFUlFSo=
X-UUID: 045c12ee7c1611f1aa26b74ffac11d73-20260710
X-CTIC-Tags:
	HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NAME, HR_CC_NO_NAME, HR_CTE_8B
	HR_CTT_MISS, HR_DATE_H, HR_DATE_WKD, HR_DATE_ZONE, HR_FROM_NAME
	HR_SJ_LANG, HR_SJ_LEN, HR_SJ_LETTER, HR_SJ_NOR_SYM, HR_SJ_PHRASE
	HR_SJ_PHRASE_LEN, HR_SJ_WS, HR_TO_COUNT, HR_TO_DOMAIN_COUNT, HR_TO_NO_NAME
	IP_TRUSTED, SRC_TRUSTED, DN_TRUSTED, SA_EXISTED, SN_UNTRUSTED
	SN_UNFAMILIAR, SPF_NOPASS, DKIM_NOPASS, DMARC_NOPASS, CIE_GOOD
	CIE_GOOD_SPF, GTI_FG_BS, GTI_RG_INFO, GTI_C_BU, AMN_GOOD
	ABX_MISS_RDNS
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.12,REQID:fd994086-c493-4c72-b1db-2b690073c017,IP:10,
	URL:0,TC:0,Content:0,EDM:25,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTIO
	N:release,TS:35
X-CID-INFO: VERSION:1.3.12,REQID:fd994086-c493-4c72-b1db-2b690073c017,IP:10,UR
	L:0,TC:0,Content:0,EDM:25,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:35
X-CID-META: VersionHash:e7bac3a,CLOUDID:d75f8329d6be75e53ff2f0d667151fff,BulkI
	D:260710121545M08Y2OKM,BulkQuantity:0,Recheck:0,SF:17|19|66|78|102|127|865
	|898,TC:nil,Content:0|15|50,EDM:5,IP:-2,URL:0,File:nil,RT:nil,Bulk:nil,QS:
	nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,AR
	C:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_FAS,TF_CID_SPAM_FSD
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 045c12ee7c1611f1aa26b74ffac11d73-20260710
X-User: husong@kylinos.cn
Received: from ctao-book.. [(223.70.159.239)] by mailgw.kylinos.cn
	(envelope-from <husong@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 154396007; Fri, 10 Jul 2026 12:15:42 +0800
From: Song Hu <husong@kylinos.cn>
To: sj@kernel.org
Cc: akpm@linux-foundation.org,
	shu17az@gmail.com,
	jiayuan.chen@shopee.com,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Song Hu <husong@kylinos.cn>
Subject: [PATCH] mm/damon/tests/core-kunit: test damon_nr_accesses_mvsum()
Date: Fri, 10 Jul 2026 12:15:30 +0800
Message-ID: <20260710041530.557455-1-husong@kylinos.cn>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 4xkfa9ry7wk4xc17wt61tbiww6tgnxd8
X-Rspamd-Queue-Id: E6818C0003
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-HE-Tag: 1783656954-925313
X-HE-Meta: U2FsdGVkX18MfFGPbT5p2Yz8G+Fn1BiJEwYT6TY8sWfVV8zidP++u9He+WpAXwC5Cjlrxp/ZACa1lRzywhg1jMgSvUOl/IFKzMdQ2L7wPLyizMZPJiaUlBaoFfWrC4gvIKUgkLIC97D++k2PbWhN5i+jII2NZFdXgYN/HVxpqCOvT55yV9UL98Zq+6TPi/9LHK7SFRGydAkZ9u3UhIkz98lCwIYpkxITlwz4pf9HUM85/1+8qCD3BLG6o3MU8d5ivR2tP/Y0AWd+y5dvYyaS3FFakOINbbS7aTHGxKaiw5NFTWg2/HrYo9QQyvxn0vCPy9vYb0F4Q60Nc47m4O+GU8SqgBr+Go13xNufF6vjNUBd03rfs/XkDQ3MQxfVlK6Dj/t2CIDFd2vlwijQLCaQrLMENZKk4WRJHrizmfOEqsjPSK8aAIK5QhhY5F2ddocUxdwpXJGyAWvBq66rYMC6nFvzKBLDHsvfmVx6T1zVy6ufRZfBa9Zy6DPtWEH6uGySuocLgqiIGj0soP+nWjZZ1LUbs0Kp1ludPoc5Qd0FVMyhxNKg4LviDKrPZPdX/h/u2j+inw9HEWODIG8yFcQIn/mDgytO2syKj6bdqenc6Qohajveu26JHi1k68rMQLFXf2Bqp4wv7uViAjPbsW7MzevIe7d8j1tBhOh0m5uOHQiNMxg3nCHiaMgGaHUiHOJBzFKIaEGqm0n488tEsHwWHG6XoQEegLqhWs3qW572KpBlT7lmxIBjiH7jhPIXU8UvDOfbe2/dbUImGBaC70tttheKdfo0MaMhTPLuP6E28Og8lzhkGbWgJWSrILfAIrcSyQoL2KlybzB/4ZLCgOlnu2ezpxZQksobkQHAEP7UoWFYtRx47NYdVHlhBK8upssrUJbFT+TCxRmN59w/Pb+j8d2diHOztEBx0Yim2DKcJQHmbeBLA96M+ptjlQ23gYZ8UP8zL0XyL4oaId7Fg6r
 hSATL/hj
 RFkytipH8iWDgnzYY5k36GOTQVO3BbzjO6jOrUS0ysDwfIek=
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
 mm/damon/tests/core-kunit.h | 49 +++++++++++++++++++++++++++++++++++++
 1 file changed, 49 insertions(+)

diff --git a/mm/damon/tests/core-kunit.h b/mm/damon/tests/core-kunit.h
index 0124f83b39b8..8c030282a638 100644
--- a/mm/damon/tests/core-kunit.h
+++ b/mm/damon/tests/core-kunit.h
@@ -683,6 +683,54 @@ static void damon_test_mvsum(struct kunit *test)
 	}
 }
 
+/*
+ * Test damon_nr_accesses_mvsum(), which wraps damon_mvsum() with the monitoring
+ * intervals of the context.  With a sample interval of 1 and an aggregation
+ * interval of 10, an aggregation window is 10 sample intervals long.  Each row
+ * below specifies the passed sample intervals, the next aggregation time in
+ * sample intervals, the current and last nr_accesses of a region, and the
+ * expected return value.
+ */
+static void damon_test_nr_accesses_mvsum(struct kunit *test)
+{
+	unsigned long input_expects[] = {
+		/* passed, next_aggr, nr_accesses, last_nr_accesses, expect */
+		0, 10, 5, 3, 3,		/* bp=10000: unreset nr_accesses ignored */
+		0, 10, 0, 7, 7,		/* bp=10000: reset nr_accesses */
+		5, 10, 3, 10, 8,	/* bp=5000: half window left */
+		8, 10, 3, 10, 5,	/* bp=2000: 20% window left */
+		10, 10, 42, 49, 42,	/* bp=0: no window left */
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


