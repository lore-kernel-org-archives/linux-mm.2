Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9EFB1CA0EC4
	for <linux-mm@archiver.kernel.org>; Wed, 13 Aug 2025 03:52:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D8E878E019E; Tue, 12 Aug 2025 23:52:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CEB7A8E01A6; Tue, 12 Aug 2025 23:52:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B17178E019E; Tue, 12 Aug 2025 23:52:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 94BD88E01A4
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 23:52:36 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0BD2E81EC4
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 03:52:36 +0000 (UTC)
X-FDA: 83770362312.15.25D9E3B
Received: from szxga05-in.huawei.com (szxga05-in.huawei.com [45.249.212.191])
	by imf12.hostedemail.com (Postfix) with ESMTP id A85AB40008
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 03:52:33 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf12.hostedemail.com: domain of yanquanmin1@huawei.com designates 45.249.212.191 as permitted sender) smtp.mailfrom=yanquanmin1@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755057154;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wYJjPR3H5s7b+u6ihT4QhpY3Y1a2vCryKerUG7/UeRA=;
	b=Hn5pgaBXYW3AUzH42OPXSmmYDaiM+u4TV7WPEvPIBkAMqt0M/rrx7qhkRbmltuSFkT6GYD
	TvAIpAs0FDuaEAaYg3LofgFZP9inNJRE4dbiGiXhrJFZj4DoW8Pr7YHNdy6ornqPYVrPiG
	3LKlG89rOqmIeOP8VFv3fxp51zXSXBs=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf12.hostedemail.com: domain of yanquanmin1@huawei.com designates 45.249.212.191 as permitted sender) smtp.mailfrom=yanquanmin1@huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755057154; a=rsa-sha256;
	cv=none;
	b=Cbo2nJe22rgH1O6pmufVL3uJwSfBTgli2qjD/Tftiv2LYmbjvJa8kAy5RZ7yDOnCqnpob5
	oPPc0041c/9KbyH+PJCcAVYTqhBMT/nvDHqmSlnTLxw8A2nGL+5SHGHX+PYRnzTiFAod09
	V1wN2zvbq9zNpK7DItn+3rQqEvZ4J4o=
Received: from mail.maildlp.com (unknown [172.19.163.17])
	by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4c1vWl71b9z1R90b;
	Wed, 13 Aug 2025 11:49:39 +0800 (CST)
Received: from dggpemf200018.china.huawei.com (unknown [7.185.36.31])
	by mail.maildlp.com (Postfix) with ESMTPS id CC95D1A0188;
	Wed, 13 Aug 2025 11:52:29 +0800 (CST)
Received: from huawei.com (10.175.113.32) by dggpemf200018.china.huawei.com
 (7.185.36.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Wed, 13 Aug
 2025 11:52:29 +0800
From: Quanmin Yan <yanquanmin1@huawei.com>
To: <sj@kernel.org>
CC: <akpm@linux-foundation.org>, <damon@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
	<yanquanmin1@huawei.com>, <wangkefeng.wang@huawei.com>, <zuoze1@huawei.com>
Subject: [RFC PATCH -next 01/16] mm/damon/core: add damon_ctx->addr_unit
Date: Wed, 13 Aug 2025 13:06:51 +0800
Message-ID: <20250813050706.1564229-2-yanquanmin1@huawei.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250813050706.1564229-1-yanquanmin1@huawei.com>
References: <20250813050706.1564229-1-yanquanmin1@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.175.113.32]
X-ClientProxiedBy: kwepems100002.china.huawei.com (7.221.188.206) To
 dggpemf200018.china.huawei.com (7.185.36.31)
X-Stat-Signature: kmymkwspewo7wwoqx7onwguc7s6f7383
X-Rspam-User: 
X-Rspamd-Queue-Id: A85AB40008
X-Rspamd-Server: rspam01
X-HE-Tag: 1755057153-395440
X-HE-Meta: U2FsdGVkX184MeKkvee/zpNMTKtuTLit5/CyJmURjA0HAADNavjUMswH0lrUPeqLjrAgKod/AVEg5XR3iq5cjUhgKvATijdfueBGrg9IbhOEgMPTn3FA2G/4IMN1AUAPyvaHW+NVku84zzz5nPNN7QuxsE79QsuAcgWusDuvtvTndecyRdNfVCu1OBjJcPDY/t3Is1Xr6xPR+RJHo360UULgYly7SkoSj1XEGwW1kypSd8+oKTQwkoX6UPEv8mi4NB/US4f+UCmBvDMq0yJzrAMq+pXu1n3oY19Q38eV9PDj7pQFSIB9UMEl/ClDmM4CrWqNnVuR7NvkXHE3DkaltOTPnvXeAa5U9nNmXM9Y4B90bqF7hyB0TX9ccJTFiBbacLx6YPMy+3ZrSqgTPijnTBhqLQTW2LV/7Jya27xfkJVmlV88hZ37scyVnQWl4kGFjpqunUI7u4Xk13KnvtiVXZZTCdLrBAgB0zXlh2XheOR4iiZSI3K15wO5dIuzAa0WqTccwGSVUFPy+4GDi2DzLYOIUDozuFGaqEPlHtJxtyfVqCO2gsJbX/D8V2LS1ZpmPwlP4wLSVbsOPFxnhE3L9q/M6g00d4mOKiE1EBvpU7LpTep8hbOhdTVdL8NPuon1zR3Kyi6mZdi9ksbmBqtFddblASjHjkvZ1XsYBgrsbw8e4bkgT8fpIOyiKEIruZVSmqJy3OcWvqpj/xMtO2mVmE6ykWbGNmS1/CSz+UmyHSScFA6B029qwLk1CXf/mKyH8jBrVwZEeS34JXLgTcLM2osiaQywYtX/+M8dHUee9lEN+HW6rqOf69RZGn19avBncfPaHSKx9x57x8arZunzh+3vsCmFZlTHPzYgiK+TzRjRrm33aHHOSy7PXqIueNwL4kid4sPI+qh3rLwxt+q2C6oAYtYe9eC2HZOf+5OUKnuMiFE3s4hbnCcAVJPa60eZq9pb2921rrUXbjY4b+Z
 6ll0xBUI
 VGpPr24UHH/AV4TpVmIP7mdKpz883gZByt4fgji34gc3G7VCYXRV3yHU6ekOgu2QRtwLxt1Dv0JL5/7vR9oeGHJkfvmsayaOIPxt7dRtrohHXza96vxNIu/phoBnjB1Fbk42/aOrs0pMyLTzjmoaAwqU+fw7RwB9FNY2jQkXxxy5fgy1eHq2PU27/G9/kqMfVqi1ZG3kDhmlz2VTe2Elxk9225Do5CVImHPiQSPHLcOSFgugfQhHGIcJHrg4J0Kmz0En0
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: SeongJae Park <sj@kernel.org>

In some cases, some of the real address that handled by the underlying
operations set cannot be handled by DAMON since it uses only 'unsinged
long' as the address type.  Using DAMON for physical address space
monitoring of 32 bit ARM devices with large physical address extension
(LPAE) is one example[1].

Add a parameter name 'addr_unit' to core layer to help such cases.
DAMON core API callers can set it as the scale factor that will be used
by the operations set for translating the core layer's addresses to the
real address by multiplying the parameter value to the core layer
address.  Support of the parameter is up to each operations set layer.
The support from the physical address space operations set (paddr) will
be added with following commits.

[1] https://lore.kernel.org/20250408075553.959388-1-zuoze1@huawei.com

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 include/linux/damon.h | 3 ++-
 mm/damon/core.c       | 3 +++
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/include/linux/damon.h b/include/linux/damon.h
index f13664c62ddd..b85c6c669cd0 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -746,7 +746,7 @@ struct damon_attrs {
  * Accesses to other fields must be protected by themselves.
  *
  * @ops:	Set of monitoring operations for given use cases.
- *
+ * @addr_unit:	Scale factor for core to ops address conversion.
  * @adaptive_targets:	Head of monitoring targets (&damon_target) list.
  * @schemes:		Head of schemes (&damos) list.
  */
@@ -788,6 +788,7 @@ struct damon_ctx {
 	struct mutex kdamond_lock;
 
 	struct damon_operations ops;
+	unsigned long addr_unit;
 
 	struct list_head adaptive_targets;
 	struct list_head schemes;
diff --git a/mm/damon/core.c b/mm/damon/core.c
index 52a48c9316bc..1a8d3009d606 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -544,6 +544,8 @@ struct damon_ctx *damon_new_ctx(void)
 	ctx->attrs.min_nr_regions = 10;
 	ctx->attrs.max_nr_regions = 1000;
 
+	ctx->addr_unit = 1;
+
 	INIT_LIST_HEAD(&ctx->adaptive_targets);
 	INIT_LIST_HEAD(&ctx->schemes);
 
@@ -1213,6 +1215,7 @@ int damon_commit_ctx(struct damon_ctx *dst, struct damon_ctx *src)
 	if (err)
 		return err;
 	dst->ops = src->ops;
+	dst->addr_unit = src->addr_unit ? : 1;
 
 	return 0;
 }
-- 
2.34.1


