Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 389D1CC6B34
	for <linux-mm@archiver.kernel.org>; Thu, 15 Oct 2026 13:58:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 423206B0092; Thu, 15 Oct 2026 09:58:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3D3696B009E; Thu, 15 Oct 2026 09:58:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2C25C6B009F; Thu, 15 Oct 2026 09:58:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0B0776B0092
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 09:58:20 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 89909120A00
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 13:58:19 +0000 (UTC)
X-FDA: 85325015118.01.EAE2CC4
Received: from flow-a8-smtp.messagingengine.com (flow-a8-smtp.messagingengine.com [103.168.172.143])
	by imf31.hostedemail.com (Postfix) with ESMTP id 7F9BE20005
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 13:58:17 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=s-joshi.in header.s=fm1 header.b="K 6F5aK+";
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b=ZyFd6SQk;
	spf=pass (imf31.hostedemail.com: domain of suhaas@s-joshi.in designates 103.168.172.143 as permitted sender) smtp.mailfrom=suhaas@s-joshi.in;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792072697;
	b=xTBuJtkW9YX362vwyppvWUghmO/uaGroG8F5zm08weUIvPRI+/vr70xcNcx0OTaS7NDXt4
	1DEhV5euiTuxg6WcDmOeV+clqEDhGW+/PlkLZ1pDUiLloeBdKN4A2VQfZKNSHCDOYUYDs8
	/uZ0fkX91b7ebSRr7/qZyst8v9lWuD8=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=s-joshi.in header.s=fm1 header.b="K 6F5aK+";
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b=ZyFd6SQk;
	spf=pass (imf31.hostedemail.com: domain of suhaas@s-joshi.in designates 103.168.172.143 as permitted sender) smtp.mailfrom=suhaas@s-joshi.in;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792072697;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CnO8Z6h9zpO/QTub1B+RFdiy6XB7flbUP5VcPsb88+8=;
	b=1IbnL3dYgOMT/LLMWuoKuDvS6whQ7ix7zh57LXc7Xtbs1oDaNTylr6q26Ls/oO5hSwoIeh
	TehajgxNvfSUqxW+z3urCOJUs4YUfIT0ysiIKQGanU6qMIoEhTPecDeINLSV13vlJLFOP5
	BbRDZ7dgnKc6jO/Gtip2ZRxRp19OK4c=
Received: from phl-compute-12.internal (phl-compute-12.internal [10.202.2.52])
	by mailflow.phl.internal (Postfix) with ESMTP id 14A9B1380283
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 09:58:17 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-12.internal (MEProxy); Thu, 15 Oct 2026 09:58:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=s-joshi.in; h=cc
	:cc:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm1; t=1792072697; x=
	1792076297; bh=CnO8Z6h9zpO/QTub1B+RFdiy6XB7flbUP5VcPsb88+8=; b=K
	6F5aK+NfLqoqTsZdXarXaIgI2UEHWLUAVRLtF7QjmhL46+nVHdW88jDdLyNjpf94
	YSo+9nhAzmOkjiGFr0DrKcmmLinWaHtftM1N5XjEWzzQ56bTG6dk20+wCAz/MK8a
	FqjUQCSHcJLVbl12sNL7JUnw2caMjLl5pOb3QEWRodanu5LXy+Yqm8p5k5UVMcqH
	aPh8rDxgJ0CqHl69L/ZVs0F015ImkRkG/dcB/Ulm9jOaXOaVVM0KjdcHnXPjK1mz
	J73phcvEEMVAlt3CuAfwbXzCccXZPHpHc6CsWnyQJnsCeS9SRCqUId2WBcjFyc/k
	AnzwIWyR9xp10WZL2IuUg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm2; t=1792072697; x=1792076297; bh=C
	nO8Z6h9zpO/QTub1B+RFdiy6XB7flbUP5VcPsb88+8=; b=ZyFd6SQkm2PWBGE8L
	Mh+hzm4BthoRgot8Gg19Buf9wtsKQ4TXySByy+1sLRWgASsD8aZhD8cAHx6uPwtc
	4M/uDFbfWzpVcS8PHNfHrIq1CI4oGN2Cs3Q96L+3aJR5+AuIWe+IeGKQkasM4KAo
	Z6pzZo5P2lEcj61TdOe1vXcQ0XGMIMCJvgypj9Jn06Zv5h0DZUqoptDyzDwaiw2V
	2kVkup1Jy89QcTdbzbtrgYcEiCBDwtZ+JYLyjau2NLz+UXWxqwMNTyXdAJKz7Mxw
	zoxhfx4sXGyAI4nlA9arzlJwXgkOgHDdzYyNnSX4zQKmPAITHxINBuocNQNp6BSF
	/sfdQ==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-06;
	repo=github.com/dkim2wg/interop; date=2026-10-04; sw=lmtpprox;
	action=sign d=s-joshi.in a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1792072697; d=s-joshi.in;
	mf=PHN1aGFhc0BzLWpvc2hpLmluPg==;
	rt=PGxpbnV4LW1tQGt2YWNrLm9yZz4=;
	s=fm1:rsa-sha256:yZrGqZcK0uKBlLUrP5G/bSBlRjJAAzLEUPKNlOobeaqbugb
	wo1moY7oVjOHrvWbIYHo38PRem8tTIID5krKN6oBCvtEMG97L1g3XSKzf/d9N150
	8cl/crFBYnrSwrucOXmRFsWCsVR5lRLwrBRFpDrjKsZWf8TlfsZBaJpDiovgde6E
	EareLsqw7MLF6k/e7LtHuyjxkTuJcsflkHRCJHQU9nxyujb93F048JPAgHCOLaoJ
	yF0pOuiglPO9iG5O52FKhASC7mslNxKou7YDGYiCIseUW0XKw5DRVk9TGv5hbwYH
	5lbgbaXbtOUAaNYHpPlrhSww0J5ZhiB4HacWFjQ==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-06;
	repo=github.com/dkim2wg/interop; date=2026-10-04; sw=lmtpprox;
	action=mi-m=1; hc=11;
	hn=cc,content-transfer-encoding,date,feedback-id,from,
	in-reply-to,message-id,mime-version,references,subject,to;
Message-Instance: m=1; h=sha256:ki8EbvuJseo+uOuHf5DKuwHpBlH2h/odU2Bm6ibMO4s=:XCLZISSAltF//O6t+IpR0eamKchFx2zNh3GL/j8aZwA=;
X-ME-Sender: <xms:-NvQarjtjYk26pu96rBeAf5Y6Kd5uT1BJVbRf_AN9v3404waI8ErKQ>
    <xme:-NvQahX3jq4LoFsdwXUkeXNb1nF0jpauLsqaBCO4-jkt1rm9J5x-DHcoKWN27CYY4
    Vx1pC-D7o5ntSOlXTw-n9ggcRy1eaymZAGFC-5tExez5Xr2GgTy_w>
X-ME-Received: <xmr:-NvQaiXhrSiDSpxmszIUkHI0fVPEkKM2_GP6-b6PmGHU2JRLZeXMRiNL9g>
X-ME-Proxy-Cause: dmFkZTEjMW0FdWGU8vE5FR9XXFJ5ToXQmBEsNYZLPQzkZOcxhgH5+QmoDYPjPP5vf1P5tk
    kOcza6G+URvZkSkJwB3YDQH7dUAAd0ZqfyynQ+1E1OsJDPUdK8Dt+uHyXhep3EiaQSJOlD
    o+1BM+m08TR/PRN9ZQlF7oiURKLnSX7EXyfWtjN2YHEnbBobd7MH10qZ7W2ZuArD3zNNlE
    nmHUnz0iCIoupLsV+aLjo6/JKRnPJMQK2CE8YB/7Dr/g1XtEoeayJBQ2G7RbKsER8qQbOH
    f/Q+uoMEYrxVTutGmIUoXlCCcH7fCEsxm+CChuG+68dwGDfFwaO7ltAIXC5KOOvtwtTTL6
    O37Cb5VY/wojXloYrzxPvucWr/OG7C1Gf8KizWJOplNZbi58ppZmMyg6SwJx0n80UPt9SA
    95qeubFsW8a88vOIWJ91d5waLkDzM63YhJYxAYZhOVJgs3bFIO10B1Cj/dD6rquhNCZlT1
    asipMEhPo7aKazxpKRzYVcawkEw+PSkzChOmDFxDaSwPzzCbmnFWN3XJxt0J/hPf1NbrMi
    W3+bY6MGuxPDj7XGS8Y87nX64TZRTeelfT64/w2uCF2Tdopj7oaYOKxzN+xPc6WwPwAomX
    EMpNhsXrtl42nClgOLgTt0Iy2qzOTpRmWdR9nthyCm+wPyUBRty/5iPfAaTg
X-ME-Proxy: <xmx:-NvQapg5nL0Cl44MsMhVceea3-Maqn-ANcP289BE8pPm-lxO3nvoXg>
    <xmx:-NvQalaMaw0jZYgsSvyjA7SZ9a_kKoHyagc7OYuR6-tBfwMj_jRMHA>
    <xmx:-NvQauoI9khiOpQ7V10oFrcD_eoDfVfKgFTDJIRzQtJYdzfiuDwiyg>
    <xmx:-NvQaqPjvyuts3pYmP5Dy-UtvTjx2AMaQVNcbzMTTQ_h-FUFJkn1DA>
    <xmx:-NvQag6HeMn7JSEAbTCnHSit0Lu7HjWeT6w_1WCqY5wn7IWW3XxCUwEV>
Feedback-ID: ia9504abf:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 15 Oct 2026 09:58:15 -0400 (EDT)
From: Suhaas Joshi <suhaas@s-joshi.in>
To: sj@kernel.org,
	akpm@linux-foundation.org
Cc: damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v4 1/2] mm/damon/core: Use only installed probe in damon_merge_two_regions()
Date: Thu, 15 Oct 2026 19:27:53 +0530
Message-ID: <20261015135801.19326-1-suhaas@s-joshi.in>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261015135533.18761-1-suhaas@s-joshi.in>
References: <20261015135533.18761-1-suhaas@s-joshi.in>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 7F9BE20005
X-Stat-Signature: xqka8whkew3x56xm6nx5dunu8antyu7c
X-HE-Tag: 1792072697-167937
X-HE-Meta: U2FsdGVkX18ckI3JejsHhaMk7KJRX5Ayjf7jTcosgl+0EIgymhqaLrNXXp0iIzLmPenxCJxJrfXFTpeex/U8czaXgT8bfsMM5c+oF1g33C/Adx0tPZeI/fmo+wDAWCk/QQ0e3soPFrqJSZdNZuTco69jyssN/Hc+bOpmXHQ+JRHhEAEz1c0QpBgHO0y+tg/PDgS8HtrZMHaithYaADPfpHShotBZp56ZnD3H5MY8IzPis0bkAR6NrYYZ+uXPq/a9RwcIDgPs+ZEFLjpZangxnAEcVq0NQcDVyhTuTVWBuFIVlPiFumTxJ8s6INC5ZzQP/W9fEU1xwoe9dQiHF22ZDHghhMV81+x7IaY5AOnIs/sMz0LyX6QuZ8qsm1HiPdL2uoWulEWQ5u5uYYPnydtsv5RjXNTX6emgOia3lPnw3CvOhUeeT9aVWCqvYoHb7DveQygjRMMqKY8SoWzNS7TidVT+JEV/qqpDlpdXg4+7yHeDAHejf8a1o41ANn3WS2PgYfk/5s9PhAEUOgmYMDxaEBy9pjcb3edRvE/9H1D+nLt2FZxDRjI6rdbX1cd+CYLM38VbhTsUaxHMz7+/NiRVwZJzGHbaqzsU0abACNONWL/x6+C8IrVLfWeCu8taOGZVKD1OuVTahQaJBKtl1HNNWCjQnqIOIYU+CdxHPMTAQ/B/3J/9kfKB23NSB3hbEc/PdkkfKTZWeHlWe7IWyFBKe1Qu++7D03v6tJDzj6ThNnWsUzDbQ0H5t9nnqQic7MhyuNasHPCuMohhIJJaeq4mEeQsk8DB5ArP3KZ20j7GJFOyk0+EIa7lPY8UgVy4w7qMHRnenepw01XTei+DGQecqDVRz8R+o6VYUVC/6A+wO2pC5RevIXAP518PDU+nfbWTuQBvwmd62UCa0mh1PfhSEPEnWV+V3JDK16ihCYtl60chymgBpkCYcBA1enujyEtTMwjp2agFunIZYxlWDkr
 31p8NLLe
 hQH1rpqzkZ7LnSbQopxCcRxHM1el5VYB7Fzw3/l4aDtYNaq8Eqmitn7IX9I+O/RodhD6kW8B57pMAU4UpzB5sZGYkk3/DFu1FWt/IfWSmnO8BabmmBakuyX9dH90qUjHt+Yp54R79ilXfwCUv8zzUFBzS65rOZS1BwWf4He0lncO/j0VQjYtFUGLnDl9X6dGT6leS0feoHcAr55Hi4InVHKSlqBKmWewc39u/+BMyUkSrQSuNvdQ9HvJ3dHnWFuYAi8opIwNG8Gd1+UteDiThz/dRLjGP2V0m63cf+auoY1GQEYwvuCMqCbfs03Ozind8lW6f7mZBM4PfIJkT9qKPDNUlHfet1cx7RZ8863xw6Ag466evGWUjnDTGxyNJqn9iNNQeP9/x6PX36SPtzcjduRSccg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

While merging 2 regions, we iterate over the entire probe_hits[] array,
whose size is determined by the DAMON_MAX_PROBES macro. However, it is
possible that we have fewer probes installed than DAMON_MAX_PROBES. In such
cases, we end up making redundant iterations. Therefore, to remedy this,
iterate over the list of installed probes instead of iterating over the
entire array. For doing this, start accepting a struct damon_ctx in
damon_merge_two_regions(), and update calling functions to pass this
argument.

Update the damon_test_merge_two() test to use this new signature for
damon_merge_two_regions() as well.

Signed-off-by: Suhaas Joshi <suhaas@s-joshi.in>
---
 mm/damon/core.c             | 15 ++++++++++-----
 mm/damon/tests/core-kunit.h | 20 ++++++++++++++++++--
 2 files changed, 28 insertions(+), 7 deletions(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index b63e60ef8990..bebd2889c2c8 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -3524,20 +3524,25 @@ static void damon_verify_merge_two_regions(
 /*
  * Merge two adjacent regions into one region
  */
-static void damon_merge_two_regions(struct damon_target *t,
-		struct damon_region *l, struct damon_region *r)
+static void damon_merge_two_regions(struct damon_ctx *ctx,
+		struct damon_target *t, struct damon_region *l,
+		struct damon_region *r)
 {
 	unsigned long sz_l = damon_sz_region(l), sz_r = damon_sz_region(r);
 	int i;
+	struct damon_probe *p;
 
 	l->nr_accesses = (l->nr_accesses * sz_l + r->nr_accesses * sz_r) /
 			(sz_l + sz_r);
 	l->age = (l->age * sz_l + r->age * sz_r) / (sz_l + sz_r);
 	l->ar.end = r->ar.end;
-	/* todo: do this for only installed probes */
-	for (i = 0; i < DAMON_MAX_PROBES; i++)
+
+	i = 0;
+	damon_for_each_probe(p, ctx) {
 		l->probe_hits[i] = (l->probe_hits[i] * sz_l + r->probe_hits[i]
 				* sz_r) / (sz_l + sz_r);
+		++i;
+	}
 	damon_verify_merge_two_regions(l, r);
 	damon_destroy_region(r, t);
 }
@@ -3590,7 +3595,7 @@ static void damon_merge_regions_of(struct damon_target *t, unsigned int thres,
 			goto set_prev_continue;
 		if (damon_sz_region(prev) + damon_sz_region(r) > sz_limit)
 			goto set_prev_continue;
-		damon_merge_two_regions(t, prev, r);
+		damon_merge_two_regions(ctx, t, prev, r);
 		continue;
 set_prev_continue:
 		prev = r;
diff --git a/mm/damon/tests/core-kunit.h b/mm/damon/tests/core-kunit.h
index 3fbb4e4e36fa..849cf61cb828 100644
--- a/mm/damon/tests/core-kunit.h
+++ b/mm/damon/tests/core-kunit.h
@@ -182,6 +182,8 @@ static void damon_test_merge_two(struct kunit *test)
 {
 	struct damon_target *t;
 	struct damon_region *r, *r2, *r3;
+	struct damon_probe *p;
+	struct damon_ctx *ctx;
 	int i;
 
 	t = damon_new_target();
@@ -206,7 +208,21 @@ static void damon_test_merge_two(struct kunit *test)
 	r2->age = 21;
 	damon_add_region(r2, t);
 
-	damon_merge_two_regions(t, r, r2);
+	p = damon_new_probe();
+	if (!p) {
+		damon_free_target(t);
+		kunit_skip(test, "probe alloc fail");
+	}
+	ctx = damon_new_ctx();
+	if (!ctx) {
+		damon_destroy_probe(p);
+		damon_free_target(t);
+		kunit_skip(test, "context alloc fail");
+	}
+	damon_add_probe(ctx, p);
+	damon_add_target(ctx, t);
+
+	damon_merge_two_regions(ctx, t, r, r2);
 	KUNIT_EXPECT_EQ(test, r->ar.start, 0ul);
 	KUNIT_EXPECT_EQ(test, r->ar.end, 300ul);
 	KUNIT_EXPECT_EQ(test, r->nr_accesses, 16u);
@@ -220,7 +236,7 @@ static void damon_test_merge_two(struct kunit *test)
 	}
 	KUNIT_EXPECT_EQ(test, i, 1);
 
-	damon_free_target(t);
+	damon_destroy_ctx(ctx);
 }
 
 static struct damon_region *__nth_region_of(struct damon_target *t, int idx)
-- 
2.55.0


