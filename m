Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 83B0BCDB466
	for <linux-mm@archiver.kernel.org>; Thu, 25 Jun 2026 05:08:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 215E76B00A2; Thu, 25 Jun 2026 01:08:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1C8DF6B00A3; Thu, 25 Jun 2026 01:08:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0DCD66B00A4; Thu, 25 Jun 2026 01:08:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CF2BA6B00A2
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 01:08:29 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 66BE4405B6
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 05:08:29 +0000 (UTC)
X-FDA: 84917254338.05.F8BC760
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id D4664180003
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 05:08:27 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MAaXcJYy;
	spf=pass (imf06.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782364107;
	b=ZCFSY9FvikWDd9zLUs4onCnzJqohOjIbkCipboEJAGIqWdKCsNfEvsG+nJ5j+aANECtZnH
	lR/fHvrKL6rX9/vgqjMoQSMJ/2OBj4/9MCLkXP7qQvDjEdCJhMnvBbcRjal6cEXpdveQEE
	zJU3yCRarmf1ygpSpNAnth6VKJZG/oI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782364107;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QU3Mdz0QWuS68FFe2kfHvyIPhX+22pphhD8CNUTJFTE=;
	b=ByZ7NdmzC7hp5X3QkVsOZ4rGwYy8TV7kHbJ0G+ekSxqRiLp28fe791FNZaAmSrbEl8R6fE
	Mn/fOMer+JLdV8RCHmaTS/TWpdGb7roIhIP2o1xj64YOvuSsJygj9fjEDTeWd4vKcI/CVA
	Sib8bksxySZPWDOq7hSrGy6xsZwnBDk=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MAaXcJYy;
	spf=pass (imf06.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 2D185407C1;
	Thu, 25 Jun 2026 05:08:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 419571F00A3E;
	Thu, 25 Jun 2026 05:08:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782364107;
	bh=QU3Mdz0QWuS68FFe2kfHvyIPhX+22pphhD8CNUTJFTE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MAaXcJYyEtQEueJLO/n8K9/UB7R2lm3O+yqiiBrNDseZgWoCAyOoWnaTXQMFBw2kU
	 OCiDajI6Ciumy2p0ZI8b9sOR9AW5FpSH7h/z5HrImTuOxaPLVD8SC8CG7rjM83NkKY
	 LIg6JkDyi+yGNW52qbt/jmy/5Mhv0UH96ijuhBEZxV+fxIr/19/tbCxC7UTimTNk2j
	 pfJCTDHqFfiCS6biAc6yjNXUIAsmFaSqfsC3UAD0Sh262N1ixys7K3EEoWdK4yD1tu
	 iTzmbVHxT9i+2TFhveDZ0jLkm6QRPVe8700pTWtd8bw9Hnc+eAe4PTdQndb46RaTgd
	 y1Nc8VM4NcA5g==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v1.1 10/11] mm/damon/sysfs: split out filters setup function
Date: Wed, 24 Jun 2026 22:07:53 -0700
Message-ID: <20260625050756.91115-11-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260625050756.91115-1-sj@kernel.org>
References: <20260625050756.91115-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: D4664180003
X-Stat-Signature: igcao44baakwfj9s9fqyb6mj5dzddcw6
X-HE-Tag: 1782364107-794731
X-HE-Meta: U2FsdGVkX1+nRozPyj6naW8c0nT5oPiD8397K9UJfAc+BO1UCk9E4Y69Wbbf7HYYk6OwtYJNlIe6y2b4YtPET091H3ikArIoh0IqL4ln04bUnNPyoMoK+AeUzt+a39qoXNz/Y5w2/qCJMOCV2UkfTVfYYjsxh//hh9fwa9NV/TdWOYm0Lnxm7WzmvzPGOVWXzULMj5voXJp7+CNlrqW18InEtcRIeHNe3suiGDa2gvRXBbUgPrK57mc3gAywWgViqTqR8leqQqDQWOwNGCmhE6hpY+V1k5iUTkJ+iBrPrxg1mu6OtaZ2ySwqNDVxO6bgMTab2ibhBoNE/bL9+leqiAJBOp3hdTAImTzkugWFlUUiiJUAoVrIABXj57vDgipOcENvyA3k8W7B3Vjq5L8OmaIDEYPNMuMJxxejOauMfOjGjSbFNKqx5uXMMGPp7i+LuK/m009qrYr3s0NsCfaPSHhM/1sqkR215HNdqZ/yg9Ui5nfZYxRSRdtiKrdTdZtBov8NfY855HsHSSo2kK1irRbEPZAsHvW500wfquJI++a9NXu/GQR923PcDSLFfxDesLMxPd/qcYFc7EuS5W7BNegmyBNmImK8scGm2X15TWYC1IsAsfr47uyLubZOgLY2spkue0dGYj1lK2HgQHcS8Apj/53vE1FOw3SjjZewUS3GJ582fu93EyrH9+GAVOfmRF7rRmADQqlqv4wSjRXV8FiVMqkBefd/8emM/p+2NzGom4vsVDuSpqhw1c9O3UpR0gO85PEv1YJqXyJhr8FcFoyT8SZU686Jy25+npkf47WFEVSDxsgmYpEWoml64RNkM9JL7/OV6PZD/01Qb3tVsMjb1IAoJ4Ly82q2Dzm0aHGbx9/QBrh5bwI7TejQmyZA1q6cpiD/CpwIlIldo5ZeP8SxtmksZ0/z2pvp6O1Q8wUvyrd4rlYsdWkMz7QPpceev+2LSEbkiXjXxxX0Wqr
 +Cn6rmPq
 r/DthBpuAnvo7X9z1Tf4A91WMSapMbNDT2PDInKDT1oFEPzvAgqrLP0LL8TOKHEVlC7mwFAxHy5gft2Rs8bHp8g1JDAIRJFBe85Dj6Pwd8CqIffcvC32aFJn7F1H4/HineEJouvFb7GRfaj4RxO1ELQob2gg8pzxGWkAi+hsWBe0X3hgYHbEeDnaJocgCtCCLsRMVdrOt53Df+15rd0w9B2SnLw3SMiqeJ0fQC1ffB5vyE1s=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damon_sysfs_set_probe() is doing not only probe setup but also filters
setup.  Split out filters setup for readability.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/sysfs.c | 20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

diff --git a/mm/damon/sysfs.c b/mm/damon/sysfs.c
index 982d824f63c21..f3bb146b204df 100644
--- a/mm/damon/sysfs.c
+++ b/mm/damon/sysfs.c
@@ -1899,16 +1899,11 @@ static int damon_sysfs_set_attrs(struct damon_ctx *ctx,
 	return damon_set_attrs(ctx, &attrs);
 }
 
-static int damon_sysfs_set_probe(struct damon_probe *probe,
-		struct damon_sysfs_probe *sys_probe)
+static int damon_sysfs_set_filters(struct damon_probe *probe,
+		struct damon_sysfs_filters *sys_filters)
 {
-	struct damon_sysfs_filters *sys_filters;
 	int i;
 
-	sys_filters = sys_probe->filters;
-	if (!sys_filters)
-		return 0;
-
 	for (i = 0; i < sys_filters->nr; i++) {
 		struct damon_sysfs_filter *sys_filter =
 			sys_filters->filters_arr[i];
@@ -1935,6 +1930,17 @@ static int damon_sysfs_set_probe(struct damon_probe *probe,
 	return 0;
 }
 
+static int damon_sysfs_set_probe(struct damon_probe *probe,
+		struct damon_sysfs_probe *sys_probe)
+{
+	struct damon_sysfs_filters *sys_filters;
+
+	sys_filters = sys_probe->filters;
+	if (!sys_filters)
+		return 0;
+	return damon_sysfs_set_filters(probe, sys_filters);
+}
+
 static int damon_sysfs_set_probes(struct damon_ctx *ctx,
 		struct damon_sysfs_probes *sys_probes)
 {
-- 
2.47.3

