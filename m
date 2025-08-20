Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B6D8CA0EDC
	for <linux-mm@archiver.kernel.org>; Wed, 20 Aug 2025 08:20:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9BE698E0036; Wed, 20 Aug 2025 04:20:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 96CE08E002D; Wed, 20 Aug 2025 04:20:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 834478E0036; Wed, 20 Aug 2025 04:20:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 67CA18E002D
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 04:20:15 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 2C016C0459
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 08:20:15 +0000 (UTC)
X-FDA: 83796438390.05.B3D0165
Received: from szxga04-in.huawei.com (szxga04-in.huawei.com [45.249.212.190])
	by imf13.hostedemail.com (Postfix) with ESMTP id 0344D20007
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 08:20:12 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf13.hostedemail.com: domain of yanquanmin1@huawei.com designates 45.249.212.190 as permitted sender) smtp.mailfrom=yanquanmin1@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755678013;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=EOqAHCCnne4tZFCuaA+8CJ0LVyGAompJozhcI9k5d90=;
	b=LoKceMkNO+uA4h77uzhDkk82Yvq06gtRYsBRLyqdfHWrRL6VJ0kMIit+vJMmSiiQXLtSua
	vQRKX6kKsxII8pe6q+GUV+do9ScWjTkHFb951em9czT1IcQC3WkdwsKTQK5oV55+biKzYI
	U5KBOCq6GtEMqTIqWef+waNdCzCkfn8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755678013; a=rsa-sha256;
	cv=none;
	b=MbOGilR4ex465cB0UavuG3Xni+OdNAqR13ZPLJ5S6Fe+SuzvJko7k3bmy3FASabxEkU7rd
	jzRjb0BfxCn2zCwXGampE/b5l+EmDbjljAqTECFl7OSRM73tdKPxXsTHEcpg606wsanSQC
	ka9TYdL02gGuNr1F9wtqWtSs7Mtijzc=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf13.hostedemail.com: domain of yanquanmin1@huawei.com designates 45.249.212.190 as permitted sender) smtp.mailfrom=yanquanmin1@huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.234])
	by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4c6K7P2Lnyz2TTFP;
	Wed, 20 Aug 2025 16:17:21 +0800 (CST)
Received: from dggpemf200018.china.huawei.com (unknown [7.185.36.31])
	by mail.maildlp.com (Postfix) with ESMTPS id 63597140277;
	Wed, 20 Aug 2025 16:20:10 +0800 (CST)
Received: from huawei.com (10.50.85.135) by dggpemf200018.china.huawei.com
 (7.185.36.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Wed, 20 Aug
 2025 16:20:09 +0800
From: Quanmin Yan <yanquanmin1@huawei.com>
To: <sj@kernel.org>
CC: <akpm@linux-foundation.org>, <damon@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
	<yanquanmin1@huawei.com>, <wangkefeng.wang@huawei.com>, <zuoze1@huawei.com>
Subject: [RFC PATCH mm-next v2 12/12] mm/damon/core: prevent unnecessary overflow in damos_set_effective_quota()
Date: Wed, 20 Aug 2025 16:06:22 +0800
Message-ID: <20250820080623.3799131-13-yanquanmin1@huawei.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250820080623.3799131-1-yanquanmin1@huawei.com>
References: <20250820080623.3799131-1-yanquanmin1@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.50.85.135]
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 dggpemf200018.china.huawei.com (7.185.36.31)
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 0344D20007
X-Stat-Signature: qbwwc5rfibpo71patfnw77z47wmqt79n
X-HE-Tag: 1755678012-85575
X-HE-Meta: U2FsdGVkX19wtedQRm14Xp6Q0NR3XUiQPFsvbIz6KLAwBVjs1LPLgQAM5XAnLSSOsGqDXt+TtQv/teO2Wm4I8iV0wPK34FVYRnu2TFN3icHxyaFx0/8iKIa5LsA+4Ub2yhsNIYllHdopGH7amvjmRWWMt/wNege03Hk4PdLWuaZClHNZJxG3jGEE+cTFSUwqpYRGx7C8EEt6/WN4b3Q91oxTykyDvBkL/7l2smUs2YU62I+DDlehc9/WM+dtgwmQTdCCsgoGUlP+h1hH1/OXvhllqv0uQkFA0SlK7pL8B/aJ2oDT5ZB5GO0RbcjO2ov8Bkj3K7VsFf/qaV1n1DaQV+kkFVo9y2ReS6EkocqqVDkAfU517PRpQFcyOk9zIpyApFiWnr9zmuvGgafhShLq14VtMI+N2+0HbrdVRxOjkRP5+aW3NkQGQYuQoNShD8qYNCwPJfk6qYVy4DSibBj9sLIfENWBGtIYuccaYIqvO0pnOkMQI5lH6EvhjgOtsss5upPW3fbfEhG9tpV1ZLvOljPlPIehytee7XcrbESP7BZGBUAhHU/xSRKy/xRrh+kQvGmLgEzNqm9aNow631VI/enZGV41OO3s/in8L0mwg4rvO8ENPxlx1CbSyt+yif6iDYdk0DBwE5i0wMs12Dr5dTyILzK7whFd9LulCWuhdW6GBmZKrF2W2mo4qKgpMuA4ogITTj9AOLMj1uPOaqH9KznkEx/LzTuo08KuwocjuhahH9M/hAdZUg80TgKIUupeSC0RrsSlFbbCqhCas248rvltn4PiT29xZRS1z3WjZ9jMky9kVyNeSwt6u7AYaftLRBPqnG1PPdg/tBUIbISdqjYhlFcOJwDmNsZowYZzi5Zj1LAsgL2SIdiCr3/IHBbsB28wNnz6HaWPba1wgynYoHGbRs0mKNB0to1AjR30alWyGBJr5IAyoZRV9k1vtgqveDpyq8i043FbAqclOFM
 NJIuu4rH
 QjVbDiYiSvaBHtRYMWQdxNnKO65wo7ZRXmLdoP/sYIoxD3D1PJxiYBK1dnZ6v3aWO0ndvJMoHQF+mgok0oa4ZwEi8mTWwlXyZeL1wZxu+VM7rZ6CL+YPAu3VolC4sxPq84qHbIkmpEsq0DPK/ymJH7LdL2zw15s0p+RDN090DheRBfD41x7AyXVM+zL7cjESo1gFQSpwAg/nE5Ur0NdPj2yl02zrbALDBzDYA8IA+mgRAb+7l6AZB1F1aeObqvtKfwZhzxqA30TzsBRq1azwtIwosDA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 32-bit systems, the throughput calculation in function
damos_set_effective_quota() is prone to unnecessary
multiplication overflow. Using mult_frac() to fix it.

Signed-off-by: Quanmin Yan <yanquanmin1@huawei.com>
---
 mm/damon/core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 980e271e42e9..38b5f842ef30 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -2102,8 +2102,8 @@ static void damos_set_effective_quota(struct damos_quota *quota)
 
 	if (quota->ms) {
 		if (quota->total_charged_ns)
-			throughput = quota->total_charged_sz * 1000000 /
-				quota->total_charged_ns;
+			throughput = mult_frac(quota->total_charged_sz, 1000000,
+							quota->total_charged_ns);
 		else
 			throughput = PAGE_SIZE * 1024;
 		esz = min(throughput * quota->ms, esz);
-- 
2.43.0


