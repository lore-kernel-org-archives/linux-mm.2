Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6266CA0EC4
	for <linux-mm@archiver.kernel.org>; Wed, 13 Aug 2025 03:53:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5550B8E01AC; Tue, 12 Aug 2025 23:52:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3C46C8E01AE; Tue, 12 Aug 2025 23:52:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 28B4C8E01AD; Tue, 12 Aug 2025 23:52:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id EE3FE8E01AC
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 23:52:41 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B78CF1A0237
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 03:52:41 +0000 (UTC)
X-FDA: 83770362522.29.6AE1DA3
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
	by imf04.hostedemail.com (Postfix) with ESMTP id 5DF0A40007
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 03:52:39 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=none;
	spf=pass (imf04.hostedemail.com: domain of yanquanmin1@huawei.com designates 45.249.212.189 as permitted sender) smtp.mailfrom=yanquanmin1@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755057160;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/N14Wv2Xz6Bd/pJRq7HG8hZChBxj9fG+V3OLKyykvPY=;
	b=Q3zC3jUNO7BEA6AWc/nofNmndXr/rvQwXFN3a32H7kSv6nUb0nG7PuLJBV8bl5HmsQ5xec
	AvndOnF+gIG4BljbdPUq3YnTJRx6arLW4YM7nBwbBe+UfnjghAZ042MDaLmnjzORNSAHMs
	ZYknDA8KD/S623EgoPFSPtZaftifplc=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=none;
	spf=pass (imf04.hostedemail.com: domain of yanquanmin1@huawei.com designates 45.249.212.189 as permitted sender) smtp.mailfrom=yanquanmin1@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755057160; a=rsa-sha256;
	cv=none;
	b=ZQrUMiN6dPov/ZiSU5r8GgLCdnJqKtqt6wYtmqq+8MLp6OVaYOPbZMVOXK7tBfzZiAeLux
	ug4A61NyLkB/u7BTOeTP/Onl8Wiu/pLdAxGmHdqv/IuSTTPknfdcq+aK3a861WHYd6Iyxb
	r0bOB8XoWf1KJCfHKu0Ry2gJFXjSgZ4=
Received: from mail.maildlp.com (unknown [172.19.163.252])
	by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4c1vV82RYxzdcD3;
	Wed, 13 Aug 2025 11:48:16 +0800 (CST)
Received: from dggpemf200018.china.huawei.com (unknown [7.185.36.31])
	by mail.maildlp.com (Postfix) with ESMTPS id 1B457180B62;
	Wed, 13 Aug 2025 11:52:36 +0800 (CST)
Received: from huawei.com (10.175.113.32) by dggpemf200018.china.huawei.com
 (7.185.36.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Wed, 13 Aug
 2025 11:52:35 +0800
From: Quanmin Yan <yanquanmin1@huawei.com>
To: <sj@kernel.org>
CC: <akpm@linux-foundation.org>, <damon@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
	<yanquanmin1@huawei.com>, <wangkefeng.wang@huawei.com>, <zuoze1@huawei.com>
Subject: [RFC PATCH -next 09/16] Docs/admin-guide/mm/damon/usage: document addr_unit file
Date: Wed, 13 Aug 2025 13:06:59 +0800
Message-ID: <20250813050706.1564229-10-yanquanmin1@huawei.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250813050706.1564229-1-yanquanmin1@huawei.com>
References: <20250813050706.1564229-1-yanquanmin1@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.175.113.32]
X-ClientProxiedBy: kwepems100002.china.huawei.com (7.221.188.206) To
 dggpemf200018.china.huawei.com (7.185.36.31)
X-Rspam-User: 
X-Rspamd-Queue-Id: 5DF0A40007
X-Rspamd-Server: rspam06
X-Stat-Signature: a1ygbgh37k8fws1b5r3sz8j6mth4ucar
X-HE-Tag: 1755057159-766582
X-HE-Meta: U2FsdGVkX18OO9MF12jnI2cqGeb0SejqtAwdNmqOjFoNzeaJq3yIN6l5IikwmX0gU/m2dEWBd09i1cHcpEYqTjYKtVMmXTtkPRNnXEDoZzut2JpwPyTT5ahbDvmFPeEvXwMYi8I1e/gf4Cm//JRNQE3fHS+SQVdD7n9DFkUhHriXbjO0ylRS6UcOPCEgHacmBaiQGuwTJftsNW8ehY/Ssdk5kgIw8IOHAMJ+nUNrzZ5RNHjoePtbgwo/4tllsSdbECbeGC3SagkY7EWL45GOoJVL8tgHD9c1lJ4PnxsLjcUbPcw7CWwBzZWV3OCbbEWtlE62uw9Pxz8yxPCwCS2DSDkMg4ef8miUlADr9QYkBgNVQcZvX/C9hCTOqfT1Pz078Kr45pboRMhlWcv/LCB/MKPl7UMYITLbmixgjiHobbtuWsABn1uWknswBDk7i+xwUxtB/ZbxbNZAJIhCLAtoWLzddfD0AHTR+G0yOg/yBUzEmvXH99iidEJCBRSopx2oCbL0qJOH9YLeFUHziv2aR02dxMDva3dnN9pKZY92JpMRT1z7VD/8ldbANrJ644ynXx1WIc7P9GenJYKHDuiKACHYoB8Ai3m7ajDi1fg2wbZMzbpXQ2r3iaFOL8DgdIRJLjuuQCtnv1O5vd0htzX43V7sh3LmJtDN9lVliAumSAZK3mzzZ0w0XSONFTEyVSseK7zcqd0rPpHTBQuEqFiMUKvkVfDkbSSXvhOF/9dZRpg3uNhk1fZrWn8hIp3h8Ukqe1l855mDfPYIwZxZPXBnHG0gAiMfMzOTeoiwiPWsNb6pjnp/N+iQ+TN10PDo9eF0CJexqt/RUEgOicGq5dyDg7xLkWhN74CjTRLsk6KCBAn0/YeHXGKVH1+140iUl4659A9xxfi+vqd6UposmFDgrMl7ixJ+7ETZKeKVKeZQeBPyM81UQqaiEoLrSFMsfqrZPrMFVMnpwPpucotcH1c
 1/yv2MU9
 yeUjFR7Ene+pcoiBgfIm9R+SzQ88nSaQ9MonIxvPVeAuhD/PZ3XhFejzrEaRDKlxI8silbrjDXIPm+g6wUVsX/xR+36ffj6BcFMO3WsfMf+pW5Wn2Br5k9VOe5IvG3QKDF4r3N3nQbiDlpbqa5qioBvF0W4vflYuUKn+F3+xyqLzyN6Vtz9YSUr3ZwRrDjCHHXGzlScSkLwfmL4Bg3CTPDpvvxAr0Nk1nnaRZYTnUzPyeXo6GGNf3+KuVWd1DlSvtekJmrac/upt3hDIVN8LMPrFWB+N0ctIJu96agDzdZkYYZPG34RueRI1GPg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: SeongJae Park <sj@kernel.org>

Document addr_unit DAMON sysfs file on DAMON usage document.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 Documentation/admin-guide/mm/damon/usage.rst | 11 +++++++----
 Documentation/mm/damon/design.rst            |  2 ++
 2 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/Documentation/admin-guide/mm/damon/usage.rst b/Documentation/admin-guide/mm/damon/usage.rst
index ff3a2dda1f02..2cae60b6f3ca 100644
--- a/Documentation/admin-guide/mm/damon/usage.rst
+++ b/Documentation/admin-guide/mm/damon/usage.rst
@@ -61,7 +61,7 @@ comma (",").
     │ :ref:`kdamonds <sysfs_kdamonds>`/nr_kdamonds
     │ │ :ref:`0 <sysfs_kdamond>`/state,pid,refresh_ms
     │ │ │ :ref:`contexts <sysfs_contexts>`/nr_contexts
-    │ │ │ │ :ref:`0 <sysfs_context>`/avail_operations,operations
+    │ │ │ │ :ref:`0 <sysfs_context>`/avail_operations,operations,addr_unit
     │ │ │ │ │ :ref:`monitoring_attrs <sysfs_monitoring_attrs>`/
     │ │ │ │ │ │ intervals/sample_us,aggr_us,update_us
     │ │ │ │ │ │ │ intervals_goal/access_bp,aggrs,min_sample_us,max_sample_us
@@ -188,9 +188,9 @@ details).  At the moment, only one context per kdamond is supported, so only
 contexts/<N>/
 -------------
 
-In each context directory, two files (``avail_operations`` and ``operations``)
-and three directories (``monitoring_attrs``, ``targets``, and ``schemes``)
-exist.
+In each context directory, three files (``avail_operations``, ``operations``
+and ``addr_unit``) and three directories (``monitoring_attrs``, ``targets``,
+and ``schemes``) exist.
 
 DAMON supports multiple types of :ref:`monitoring operations
 <damon_design_configurable_operations_set>`, including those for virtual address
@@ -205,6 +205,9 @@ You can set and get what type of monitoring operations DAMON will use for the
 context by writing one of the keywords listed in ``avail_operations`` file and
 reading from the ``operations`` file.
 
+``addr_unit`` file is for setting and getting the :ref:`address unit
+<damon_design_addr_unit>` parameter of the operations set.
+
 .. _sysfs_monitoring_attrs:
 
 contexts/<N>/monitoring_attrs/
diff --git a/Documentation/mm/damon/design.rst b/Documentation/mm/damon/design.rst
index cffa320ead88..fd183cd09ef2 100644
--- a/Documentation/mm/damon/design.rst
+++ b/Documentation/mm/damon/design.rst
@@ -135,6 +135,8 @@ the interference is the responsibility of sysadmins.  However, it solves the
 conflict with the reclaim logic using ``PG_idle`` and ``PG_young`` page flags,
 as Idle page tracking does.
 
+.. _damon_design_addr_unit:
+
 Address Unit
 ------------
 
-- 
2.34.1


