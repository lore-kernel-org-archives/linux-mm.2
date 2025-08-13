Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DFE66CA0EC4
	for <linux-mm@archiver.kernel.org>; Wed, 13 Aug 2025 03:53:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BDC168E01B1; Tue, 12 Aug 2025 23:52:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B8C8F8E01AD; Tue, 12 Aug 2025 23:52:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A7C508E01B1; Tue, 12 Aug 2025 23:52:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 909B08E01AD
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 23:52:44 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 56F12577E2
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 03:52:44 +0000 (UTC)
X-FDA: 83770362648.26.CC634AB
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	by imf14.hostedemail.com (Postfix) with ESMTP id 3A3FF100006
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 03:52:41 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf14.hostedemail.com: domain of yanquanmin1@huawei.com designates 45.249.212.188 as permitted sender) smtp.mailfrom=yanquanmin1@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755057162;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=83TI4bBZmIPLGNc5dM/TYI5Dfb3gm1eacMgg7tXx/w4=;
	b=KAWKZW8sbpb+ueK0dJY01R3br39kGLCVNxzJqWX78nH023vz5setNtSaKnVP3U8+SzmoHi
	aHnnkVbfmmkYX/8yJJDqWAaGcQcz32ARgYM8G3e2I7MIKuZZUadVqKFAVAewELxia9apaR
	My8vnxYfnipGjvFby3V+0sIgcIrMjcM=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf14.hostedemail.com: domain of yanquanmin1@huawei.com designates 45.249.212.188 as permitted sender) smtp.mailfrom=yanquanmin1@huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755057162; a=rsa-sha256;
	cv=none;
	b=YvBBIIGhFyNg8r3UD4Mad+k5/Dhr6uQrs2HYPSnuhvA+OZM67weOqdxdiJ/GMwY++YSlE8
	1UJOSu9w40sTmqrZmpzWEmv8ndgIQTUzLidVonRVp7BGd4q24Y3wjqXbEPX6hzjWVZNHsS
	2Lgeb/zS7oLrW6m8vHpkuqx9l5SiHNc=
Received: from mail.maildlp.com (unknown [172.19.88.105])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4c1vZ26v1JztTC0;
	Wed, 13 Aug 2025 11:51:38 +0800 (CST)
Received: from dggpemf200018.china.huawei.com (unknown [7.185.36.31])
	by mail.maildlp.com (Postfix) with ESMTPS id 37FD5140202;
	Wed, 13 Aug 2025 11:52:39 +0800 (CST)
Received: from huawei.com (10.175.113.32) by dggpemf200018.china.huawei.com
 (7.185.36.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Wed, 13 Aug
 2025 11:52:38 +0800
From: Quanmin Yan <yanquanmin1@huawei.com>
To: <sj@kernel.org>
CC: <akpm@linux-foundation.org>, <damon@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
	<yanquanmin1@huawei.com>, <wangkefeng.wang@huawei.com>, <zuoze1@huawei.com>
Subject: [RFC PATCH -next 13/16] mm/damon/sysfs: ensure valid addr_unit setting in damon_sysfs_apply_inputs()
Date: Wed, 13 Aug 2025 13:07:03 +0800
Message-ID: <20250813050706.1564229-14-yanquanmin1@huawei.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250813050706.1564229-1-yanquanmin1@huawei.com>
References: <20250813050706.1564229-1-yanquanmin1@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.175.113.32]
X-ClientProxiedBy: kwepems100002.china.huawei.com (7.221.188.206) To
 dggpemf200018.china.huawei.com (7.185.36.31)
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 3A3FF100006
X-Stat-Signature: qkto5j19u86bqa3wuizdibfniqkae3zr
X-Rspam-User: 
X-HE-Tag: 1755057161-514366
X-HE-Meta: U2FsdGVkX182YS+a3aRudVuHWLT3xBIIsyq0Kj3B9QSiFv9rDV7ezDU1IB6vQsZHDCTfPQdJIofuecdPpNW3EE/qF5atc1980dB3gWK2di0Iv0/RDPwEmd48+HfYcaeOGlOBCk4AOhk10v/99r8x4HZUk77KRWYuOTH6faKWeNCxpUQQnUocHxmT8Sgd0qrO8vKB/D/MHL6PDi0pNvClqfjOAEBU4dqeiDVjYNKZJZ0owwMiW+oridFirAmOgP7QD9stJ2riyIAug0bs8yH42MnBpExtzR/vWLP5nw7oQog4x8XhmFTx+vs2toh6kJ1jPHlLVtgw1yTqeh9OgiBcqQXt3WSN6Q6PQYB4b2bvfNw++XaHPwtFSh5K0jfmuDaL9v2eXoDNeeMDkzId3VTauynrb9ezvM01Mb1BEgJfnNKnQp5vNeZnCLzGm3p2dZB9r/xFY8x3MjH9ijEp6pKZ0UrvuuyOu8d5zJSZ9aJU79z+0GJInZvBZfnJMJS84ImzRYj6u9twpdLNr8h6iMNQz+vvxLIWpz/Rmjzmv1oC42A8a5xSivq6qB4PmeyYa8QwUz8pxDnZLRuaO65ozzbzYXxNsZap4BHfMLVs/bbn9R9D1KKAiajkaIYQKGBL/65Auw7KtSQX2BMhA86TfchXz728U5eXpVusfuJh5YIWO7PJBPNQgXawiE+BT1/nCblZdII8H3mlTIdK4Hhpojl6+pfvbPAbUWqUVEvb1SI5vYlu09u2+sguoW4q7djkcmQaEftB+EQyb+gYoiw2pEk3MSNUMiu7DRFyIb8l7l/SRVH6sfBoEO+7OdpAnZoCE9V7beCFmLGOjYBEq7tc3zdR+B6kjrMH+v6mQav7H1ZmanJaZ1foEqiTRwmpm3cvMFrQsIK8Q7p/9vQFRrqzcURsgVxBxfnO6OlcxOYf4WgL5Vx2Dn7ICQqU43WXkz4B/oNNZHj2DBPQjsd/kGJw3IF
 faDw1cfK
 BoYDCC7GEe5kPZerY1ZIhzXV7bnXk5yYVaLJvpmaNXOS706Yo8a2tD6zuYiKwPhkAi2A+9euGCNQztNjEGSJycX273ZPxLswhgpxNZWQ+7FCTO9JO+J8xz1kiZGTD5dQVIeFl6XcG5Sbcsm066hEaHv2PB89tuKCuwrcMD6P4ua6/xB6N4kJ+fMRR79B8RDfSl/G4vDSpEGpGORaNmZkLtCFe6UC9fl/TDsF4
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

By calling damon_sysfs_turn_damon_on(), the execution of damon_commit_ctx()
can be bypassed. Therefore, it is necessary to prevent ctx->addr_unit from
being set to 0 in damon_sysfs_apply_inputs() and update min_region to avoid
potential issues.

Signed-off-by: Quanmin Yan <yanquanmin1@huawei.com>
---
 mm/damon/sysfs.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/mm/damon/sysfs.c b/mm/damon/sysfs.c
index bea782b0a711..122824776c1d 100644
--- a/mm/damon/sysfs.c
+++ b/mm/damon/sysfs.c
@@ -1422,7 +1422,8 @@ static int damon_sysfs_apply_inputs(struct damon_ctx *ctx,
 	err = damon_select_ops(ctx, sys_ctx->ops_id);
 	if (err)
 		return err;
-	ctx->addr_unit = sys_ctx->addr_unit;
+	ctx->addr_unit = sys_ctx->addr_unit ? : 1;
+	ctx->min_region = max(DAMON_MIN_REGION / ctx->addr_unit, 1);
 	err = damon_sysfs_set_attrs(ctx, sys_ctx->attrs);
 	if (err)
 		return err;
-- 
2.34.1


