Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9CE7BCD4851
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 14:37:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 42D706B00A8; Tue, 12 May 2026 10:37:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 386516B00AB; Tue, 12 May 2026 10:37:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0CA076B00A6; Tue, 12 May 2026 10:37:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C123D6B00A7
	for <linux-mm@kvack.org>; Tue, 12 May 2026 10:37:05 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 89A0DA04DC
	for <linux-mm@kvack.org>; Tue, 12 May 2026 14:37:05 +0000 (UTC)
X-FDA: 84759020010.03.8B91266
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id D7C204000B
	for <linux-mm@kvack.org>; Tue, 12 May 2026 14:37:03 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=kkxKTfbE;
	spf=pass (imf11.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778596624;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DDC4xujeS1dP6CGH2k8fNSsWur5RneuOkKC9Vyvw5R4=;
	b=wlnp3UC17ymtpZ1jQAD7hnKFSRncmu+qaKhT4icnD4ICnfPa377U/0JezRb5NhurgFvmo5
	z1h6RlONxviJ4txdFelU8/tgLBMq/yZ6vBkDMedbfi7eDr4K2hbjhI3ru6ktATr/nL9MV+
	rxYh/v4D9oqzlHDBJR1lMIdkFDUD3AM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778596624; a=rsa-sha256;
	cv=none;
	b=2KlKHX+d5jaud3l8Jfq+raSSH5Fmx2xLkw9dyqpQzYvCY94elpbFDnD9/bjIQ06/CQR4tl
	lC+KVk+OhRvVXBaDFNrMS/r2SSp7Zklfh6Am8MzN1FlqnCFFFsGafXwob3HaP+dsbTiJJL
	213b6BlBcAO4j8bmiry2FOb8G2sdBU4=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=kkxKTfbE;
	spf=pass (imf11.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id D9BEF44ADE;
	Tue, 12 May 2026 14:37:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94E30C2BD04;
	Tue, 12 May 2026 14:37:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778596622;
	bh=zKIsD2XzT0n1kqH382+eAnv1kjGpY3pJ2uKfaHDPajo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kkxKTfbEGdR12BcEFjd8QaEFjwCBGpqhwHJ+e0n6xuObobVTgDrPTD+XrPEY7ZG9I
	 wC4T98O4CwDSXie8I8b9AdXv1C7wq2iKFzjRHfgJiThE3yX/m0hSAodjE64xRePwWO
	 Nvi4ZvHGS6Puu31DfzmilaD2i80BAkr6GlA3odf0o7sw8pC8qjxJY7fcb2nzN3koAs
	 OuJrVx+tRwUDFCvu0fjeh4oPDrfiU+d8c90aIS+3Gt6ie/rJ65kZBXqa1ZWns/7lYv
	 oWVHJb8QGkouXMZr10Ak1SsGXvHMC8CYcYRyCw9Rk3fzVXk1MKHan5FxaxSouVpRH8
	 7l117rTFnQoZQ==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v2 14/28] mm/damon/sysfs: setup probes on DAMON core API parameters
Date: Tue, 12 May 2026 07:36:29 -0700
Message-ID: <20260512143645.113201-15-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260512143645.113201-1-sj@kernel.org>
References: <20260512143645.113201-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: D7C204000B
X-Stat-Signature: pbr37aimip4cpinzpdxeh6eoqeokn53o
X-Rspam-User: 
X-HE-Tag: 1778596623-737917
X-HE-Meta: U2FsdGVkX1/j83CXzqVTANVlv7mxUt7gTscGOYuPlanRtjOb804FIS1OJyjoxKgvQI25BysDo06AmMxNYmtjRrxEo53dPVX6EIAlhHBhfb5kcK5si54bw/fzsH8yZ02lqzR4Hf2bm9cxSL83nsd9YW1VpQriRWv6xUJLwqoOg6faexZkIEJ5JPQshMLngh2KFltZm86rgSuPc5QPOPoRClmiHxd0wiQQgBK1wJN83aasQxrUcLNez8e9Z00JBBtirHEdiRUhv0ezxh4ZyJyRkgF416cU+qiQBNNEHkQjWSS4FiSmojwd91ASdLThJikcoJzzQOkIXlU1+tIxB9yLRT8Et5uvANTOxA9wPq9z0I2qeZImdxdKGcXixU0UEBtwMAMv76GguuEr4z/nIqL97bxL9jWH4DNNqGjK7wKtIOScZFKOBf8pGLVh6hLBEOZ6qC2UYmpXok2MOepCfH5l2Uu+wC4yXJ4Y6ayRnSDzmCaISzIQ/oCdxBh/CYLxvdJtbkaTQWD9a85vz/ECCD+gvIQvsHpEhIqOMS7fbO2jnVB9JK4bNKSl8z2PeUflm3FzxRTzpeUuP8Mhyn8zodc/Xhs9FpXofeETI70vtIJqoTx3ptWDQGZKG91yI45wcsZsrSMNtAcgJOn/TQoLASlHU2LQh3gBC0M/lecOSziACM0GnIZBm1YfazXjxmjXk86OG6uV3xCBfJ/0xquLas0cy1DNtoCOmfBUSXnvBSuP8md7o1cjiY6OvpTqk9StMj7DSKJK1MJpL9qR/28ul5Gvhb5lghSC7T80VH15epqn9dorlmjNkhaftMuOvnp1D4bhtY2ua2J42gONNZ3/2MHxuNsoGQf4GTODXTiKVEDSZPCW7wJ+kNpBaUrl+8OGqd3SyFhIesYtoXlut9wXGV1yskeu/nvw6ouaFWYuAEn1IFQ/feljq942jz26w9nUFh8RoVghGIiK9A6/yehovY0
 S9+QFQm5
 LzumSvXECyt5PWqs6r0P8Jsxi/WZKgZrOerZyR78X1yOxlMukpUagFtvHwQI57GtSJqkL0GUCJ+4mfs7kjL287LdAr+cp2MB5rRc1hcsiBksptDIQX87L+iMTLlL7e0kqcZRB3NUcnEMf+Ws5vKsqbB8lk16/t4ORY6CEHdNmGBbH4RAl0mMEPf7BWWT4y3kuWaR3G690EMpjvcDFFy/rm+S3GL+Bz8PeXfjvzUOWaqBr9QI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add user-installed data probes to DAMON core API parameters, so that
user inputs for data probes are passed to DAMON core.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/sysfs.c | 37 +++++++++++++++++++++++++++++++++++++
 1 file changed, 37 insertions(+)

diff --git a/mm/damon/sysfs.c b/mm/damon/sysfs.c
index ed7bb734a236b..e4dbf85feadc2 100644
--- a/mm/damon/sysfs.c
+++ b/mm/damon/sysfs.c
@@ -1855,6 +1855,40 @@ static int damon_sysfs_set_attrs(struct damon_ctx *ctx,
 	return damon_set_attrs(ctx, &attrs);
 }
 
+static int damon_sysfs_set_probes(struct damon_ctx *ctx,
+		struct damon_sysfs_probes *sys_probes)
+{
+	int i;
+
+	for (i = 0; i < sys_probes->nr; i++) {
+		struct damon_sysfs_filters *sys_filters =
+			sys_probes->probes_arr[i]->filters;
+		struct damon_probe *c;
+		int j;
+
+		if (!sys_filters)
+			continue;
+		c = damon_new_probe();
+		if (!c)
+			return -ENOMEM;
+		damon_add_probe(ctx, c);
+
+		for (j = 0; j < sys_filters->nr; j++) {
+			struct damon_sysfs_filter *sys_filter =
+				sys_filters->filters_arr[j];
+			struct damon_filter *filter;
+
+			filter = damon_new_filter(sys_filter->type,
+					sys_filter->matching,
+					sys_filter->allow);
+			if (!filter)
+				return -ENOMEM;
+			damon_add_filter(c, filter);
+		}
+	}
+	return 0;
+}
+
 static int damon_sysfs_set_regions(struct damon_target *t,
 		struct damon_sysfs_regions *sysfs_regions,
 		unsigned long min_region_sz)
@@ -1967,6 +2001,9 @@ static int damon_sysfs_apply_inputs(struct damon_ctx *ctx,
 				DAMON_MIN_REGION_SZ / sys_ctx->addr_unit, 1);
 	ctx->pause = sys_ctx->pause;
 	err = damon_sysfs_set_attrs(ctx, sys_ctx->attrs);
+	if (err)
+		return err;
+	err = damon_sysfs_set_probes(ctx, sys_ctx->attrs->probes);
 	if (err)
 		return err;
 	err = damon_sysfs_add_targets(ctx, sys_ctx->targets);
-- 
2.47.3

