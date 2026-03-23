Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CB44AF4613F
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 23:15:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 81DF96B009B; Mon, 23 Mar 2026 19:15:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 70F016B0096; Mon, 23 Mar 2026 19:15:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5F9D76B0099; Mon, 23 Mar 2026 19:15:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 4A2E56B0096
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 19:15:47 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 1326CBDFDB
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 23:15:47 +0000 (UTC)
X-FDA: 84578887134.05.08633D5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 6E9564000E
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 23:15:45 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=eNqinUsu;
	spf=pass (imf01.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774307745; a=rsa-sha256;
	cv=none;
	b=RkjclPThYWFsjnEVkSvO1WS/4vFEX2R06HBoVEKxKvSvZeDhQaN4dvXbyJX/Bk7gMpOxIe
	PeQiEcdVcrYiWlckpTfBEMf06KXPhIgqP88Y4/EerX1wrAe0QgKTTk6MwwoBtmGskqKdXw
	tcpwp7og6kvE5SRUrJ1VjscyimE1MQc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774307745;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mB4UoVanGjJ0b6Z/rtgw22+7a2ViKkbvDoer3Kj9isQ=;
	b=8OvuP168XJBiRAztMJg3iyuBSrP75RNBv+bltclmlxE9GTvQO7jk/rqJDesKlFnKahkGs7
	4eE1wq56SbJFYoXgabNYQXEQCCMReB1dGnfF8y2O33bMsIfNpz3dv15hup4H5utWL4Vveh
	LFZNC71o5T8qsD7GfJIfn0UN8J7xxO4=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=eNqinUsu;
	spf=pass (imf01.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 9749F44522
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 23:15:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 604B4C2BCB5;
	Mon, 23 Mar 2026 23:15:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774307744;
	bh=TJXeffpmshBn5e3s77gk9ewA/YmV5afqYkZ0L4RsmNM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eNqinUsuiogjYHI1OaDQYljy/pynstj5DRWXkS8+qVtB9giaSeRU+M//H5Er5vicG
	 +B+hvUro+CkWmFCRcuJVzzZ+qt9qNrFiOmeHTop4Lvyq98qTOxNIx0ZWlO77e599EH
	 1dhUGMO/zMT8e+kZ5gGnByxZehl/W7zNOfgr6GcgQHSbJZmDTcheu9ncJgyCyURNST
	 yDf1zQJHFdIg9QWami6JphQlBr+gpWDsgxWS0L9oaRU1TmPPf6qfqKWyiiT2PC7ocM
	 RqwWgk6YC1fFh6MKUMa6dYJsRjxrgf5EmS6AfYMKH2Yeay3Jsi1UYqH+XK8BVBNDgl
	 T4AjfArJH4zDQ==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Shuah Khan <shuah@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v5 07/10] selftests/damon/_damon_sysfs: support pause file staging
Date: Mon, 23 Mar 2026 16:15:32 -0700
Message-ID: <20260323231538.84452-8-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260323231538.84452-1-sj@kernel.org>
References: <20260323231538.84452-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 6E9564000E
X-Stat-Signature: r8r4n67iyq33ddfast6s4zsb17x8w4ei
X-HE-Tag: 1774307745-781773
X-HE-Meta: U2FsdGVkX19bSXTeOv8q0JwgdEUnKQ4qhUaMZIg5h8pWRuKbUKrWs1qseTdrR7+VC/zb8eywSrxCsHvR4FSBjAPhw7aAGWMvFlgC4ZpoV5bos9uo+O2MW8lYYR43fXWtaUEDcRBp9zH6bxP0sy33/OMtdAp+kXJrvc1eYtj2ohu09jVglyne0JhxYB0592rIFtgfxh3sz5Fklumq1+6cWcYtGqD08kGnIO7FyO1KBPg8NWDVoUXZmd0RfRzZ7mgVm7acNczelN4+s/lWMyZfTA22b7FKgxQ7vA936ozkrghp8BABIN4uTnw9/15qx1zMDzdEuvt/oZe/+6413fqRjU49yeVHz0uiqPXGfFi2JouGgQiY3kcAS53zbMR2jiYEw5V/BJJYZR6eZsnP4D3qY+cYhyDFj7V/mE+EH4bCaUVrshQfDdtSc1AOPLpph+3uQAAZdPh9gNbFLfdIOxz3lJ+CV/yUB9Q644t38RWxo7pMrCs8JE8RV2n7ncaARJFCM+VgXXKrhToduf7ZRTc8oG8uh0Ql85E0GslGCJPn2MU0zAbq97yTMaq4TQpVqO2kJiBtptGkUuxWe1wDr5rwjeMWyZv3pJIiidf6vJaa9nhePlNGxlF7aOgAvilmqEB2PLAwYZ+pHFwU0Bws3FUV/zrKZsTDasez/8n9SYld/ExaPxl89JjpKUNatIc6f6GFlgWKL3X/9oZZF48M2/VSzYet7nV4epITCweEEra2/u41HirqzKoYdG1njBVJUB4ZNfawrVbVP4vN6bm4KYWRyjp5SmuiHri0IBNVimacPhCBF0mL4qUC77lRAQ4A8NDMgKMUXAE28KhR9SiZM1lVtN2k44uzoiWaqDiFx3IkoGvzJqB1jGPO+N1J5zJrxj9ooorD0qXVGZV2Mv8IpC/mq4vPyD49yk5mLgIWQzR7TN29x8lSbVewJsAQgB++/+ZH1h+Cgq8wPAGgZCcs4yB
 KENo0sQe
 9zq8cj3Gpp4zpgOsIriHsvGsCkqA/27FKYYaB6e8nU22N684wpcUVXYLu2aUVPyLQMspci/Az/9T+TJLUWNr+zC2VS3BjpWhOQiitRRS67U8OZGDP45X4Qq1DX3SlaudRQY7DyXCfNNcAVspm/0djndrf8Ii6CDZDzFn3lz+H58hnfcQMox3ChgEU8S4ERtopxiYYuMUgxrOjiwsLs+KP6PGBNyE7Qol7u8Uj7YhDaxujXioGrZ1ZZbcuWywPliJktIhgBTTS6uCxJyiEX9GiynZ6261gDuPMQv0iKq2/7Bbscn0IyGL+4leUlm48gml0XZNHPYHFO9sBzhFIAiSpyFyBboZ7UgE84vex
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

DAMON test-purpose sysfs interface control Python module, _damon_sysfs,
is not supporting the newly added pause file.  Add the support of the
file, for future test and use of the feature.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 tools/testing/selftests/damon/_damon_sysfs.py | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/damon/_damon_sysfs.py b/tools/testing/selftests/damon/_damon_sysfs.py
index 2b4df655d9fd0..120b96ecbd741 100644
--- a/tools/testing/selftests/damon/_damon_sysfs.py
+++ b/tools/testing/selftests/damon/_damon_sysfs.py
@@ -604,10 +604,11 @@ class DamonCtx:
     targets = None
     schemes = None
     kdamond = None
+    pause = None
     idx = None
 
     def __init__(self, ops='paddr', monitoring_attrs=DamonAttrs(), targets=[],
-            schemes=[]):
+            schemes=[], pause=False):
         self.ops = ops
         self.monitoring_attrs = monitoring_attrs
         self.monitoring_attrs.context = self
@@ -622,6 +623,8 @@ class DamonCtx:
             scheme.idx = idx
             scheme.context = self
 
+        self.pause=pause
+
     def sysfs_dir(self):
         return os.path.join(self.kdamond.sysfs_dir(), 'contexts',
                 '%d' % self.idx)
@@ -662,6 +665,11 @@ class DamonCtx:
             err = scheme.stage()
             if err is not None:
                 return err
+
+        err = write_file(os.path.join(self.sysfs_dir(), 'pause'), self.pause)
+        if err is not None:
+            return err
+
         return None
 
 class Kdamond:
-- 
2.47.3

