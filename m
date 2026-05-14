Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 93C5DCD4F39
	for <linux-mm@archiver.kernel.org>; Thu, 14 May 2026 14:09:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 98F2F6B00A1; Thu, 14 May 2026 10:09:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8CA0F6B00A4; Thu, 14 May 2026 10:09:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 71B656B00A3; Thu, 14 May 2026 10:09:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 55D2A6B00A1
	for <linux-mm@kvack.org>; Thu, 14 May 2026 10:09:25 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 23AB11405B3
	for <linux-mm@kvack.org>; Thu, 14 May 2026 14:09:25 +0000 (UTC)
X-FDA: 84766207890.10.8409BD1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id 91AEF40013
	for <linux-mm@kvack.org>; Thu, 14 May 2026 14:09:23 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=RxjfHOW+;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778767763;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DDC4xujeS1dP6CGH2k8fNSsWur5RneuOkKC9Vyvw5R4=;
	b=L8NIIcKuF8yrkloW+QlNxoD+THxKgwJHGrF2dRazVJpJnhYLHo/0eu22BAWH4famur2+qp
	p8nybhceBhRqlUtnTjnJU5Wf/TDGf7M8UlsRcKNXVSfTD3iBWwtMy9WMrALfaZG3OqaJCM
	9pwRgq46hNJetMrzkIhVBigx1zvVDiA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778767763; a=rsa-sha256;
	cv=none;
	b=LiTWQE2LGz/5UoDr6RBWhQqZECjEcqRCUnG5mslY3aTKsk7d8j30eMHwWh3j47ESIKN23X
	78px6/BAxhe5J0HLDyD2oAQOpQzXYgK7vFSTsiEL0VT2RFbxEV6Rai0pI7ghliCcv+2WKx
	kOJJwWQecRG99Ltgbd1PrQSrbjzdOmA=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=RxjfHOW+;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 24BEA6013B;
	Thu, 14 May 2026 14:09:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3FBAC4AF09;
	Thu, 14 May 2026 14:09:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778767762;
	bh=zKIsD2XzT0n1kqH382+eAnv1kjGpY3pJ2uKfaHDPajo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RxjfHOW+Vg5aAyAkoRLmLfFLeFLfW0yOcT6eSI7K7UtQT5USik5RcrTbpPwxSnbUS
	 kkPN9aTKkyIvVTsggA+50SFOanNwEVZzmyDdqk6l8M+rnjvgpo4jvKDE5tKkff1AB/
	 LvRsM9VuE5RLpgy5KkyYS1UT0mPs7vk410m1VVvWFSCkApMlLKNbVJMZesPG4p1jUc
	 Gvu7PuRHgmVKdCtLyg92jyJxDUceeyE5Kjl5kHRTiSjCwyA4ypAR/XY9gGAQ1rmJHM
	 gf6EfEf6qm+j3oPPMXewDLBKhm257HZ+puYhKU++zW52EuIptJH/PvRZHolL4QVdkK
	 a4m3CR9wN+qMQ==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v2.1 14/28] mm/damon/sysfs: setup probes on DAMON core API parameters
Date: Thu, 14 May 2026 07:08:47 -0700
Message-ID: <20260514140904.119781-15-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260514140904.119781-1-sj@kernel.org>
References: <20260514140904.119781-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 91AEF40013
X-Stat-Signature: nesksionjf9m19ikjkda4yfohz8gsuuj
X-Rspam-User: 
X-HE-Tag: 1778767763-503168
X-HE-Meta: U2FsdGVkX1/GvWQB4Qz56OjFuF5+pEGCst21LF28qDCmWyFm0+ED9u1l6RHHjIROUpn/fkK4Uvzij0bS1n+qqletc2GeKwuLQcqYY59ppLmG9IdHrNmeMHmSDx8e8vPlXBCbIBBhlWA9g/XFnwtoMKRDuVyhGxK2lA/PcKwgUrA6QE3t2ks1QBILLT1f+KHfNOocWGFc2rPUVHnJ5Ya+8WyRO6BamCZx/db40gT/KCAzy9KPz7TgeXPpeSU1BK4XtwgWwBLEW12GOmJ2jJ2HwAjgiP3dFhXZbA9gSFp9y/3CuqIpsi9OiQ2khhOvlG3p/q7JW268wx43WXJNDOT64zWZ1+Wd+Mj4sBHV2tPEbaWEgq8emq5VJSlV3KxhESrnA4BgAUI4MuiaXQz/27SoAgYV25L7fadLfFph/gp0XLG/+ohR+gn8T74VLerlfxx12C8C8vHX+rNaoFr0i0Jr2fEVgrcho77LGLCsM+l/xjmCFG1AprMV/ivutkPy47ZMgh1Ii9uvCD1DMNz+3pEPnQQNtNC1CwCvc+yoHN9xcdt1mBjnroaFmQKbNOqZJRrbbJmSTGEeJ6fJkR9BxOEkiW0BCHteuJuk+r/XabmWPK7b2gw7OCMbTtrXNsBMqlKH4e4GLrgK62YphgGSWCzgBwaN6TfrJndu5yaBZRUOJ9Bg+KxNw52BMCnLWiJLSPoD91nN9sx38XJnkKzuw5faNrmfzHHuCrVsPZnBcmN/8V8Nj2d1rKdGWQ0TGCP6s6k52BF7SjEJdXKrjtSMFEY7OELGOmaGVCYEXjdwhKjhyGIZAjIGxDQLL6XWpcsB3LlUhKIj9QikneszurEMp/WpmR/RdSvJBUcSruv4DkDNscoxhGy2mCjZGFPVM13WgV3X9QoOJSZMzzfJXXTtOJRouyAo9bac/bNMiCjqlhGvYiJWBG8hMuIBxkn6hPab+q2VRbnKiH0pIQ/+ef9Cy4F
 DF1nmg+q
 19vyNSsXZBvNgeWxbmLVaNvO6fWXmWyWsKgzxOSk1raCyvB0JVUebEqa0YSivAIR6YSmAkggZY3IVH5lK3+KPoYOVIi59Mr+lVKT3cK2QPq7S9ExNi9/wPC/E9yaM/oJ6REtWV2Q2Yd1VRH1x4s23v3+s3KKN4Vea21+O231vfxqFxLf9mzdNSLVWIU6IiM5xo7fmPJqzBPN6lnFqZMJO7e6XPtd/iPxeW8wrvNAbjZ6Dr/M=
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

