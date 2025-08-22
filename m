Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E9C45CA0EEB
	for <linux-mm@archiver.kernel.org>; Fri, 22 Aug 2025 09:48:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 12C558E008D; Fri, 22 Aug 2025 05:48:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 10A8B8E008C; Fri, 22 Aug 2025 05:48:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E70CC8E008D; Fri, 22 Aug 2025 05:48:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D35BF8E008C
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 05:48:16 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 93B0FC06CA
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 09:48:16 +0000 (UTC)
X-FDA: 83803917792.04.0EC7C59
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	by imf29.hostedemail.com (Postfix) with ESMTP id 34737120010
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 09:48:13 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf29.hostedemail.com: domain of yanquanmin1@huawei.com designates 45.249.212.187 as permitted sender) smtp.mailfrom=yanquanmin1@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755856094;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lE55YGWAQ6Jw6zuanxQZWGEb8lUWvJaGpVYZBtzkJRk=;
	b=sNnB0pAGpu8BFYXzXALb74yuJ/48QuwZzUYeLxDFcBRQtbUmQWcj4Ke3XFP0EAFo60fxzC
	7vBZK9XL2S1xwNe6ayTcsgwAETnzATZ1xfb6EFw+D+q5RQgUO+9mPQp24XjTPwNp28+iJp
	jbnNemGJjTaR36CgASYCBNxKr3Gq/NI=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf29.hostedemail.com: domain of yanquanmin1@huawei.com designates 45.249.212.187 as permitted sender) smtp.mailfrom=yanquanmin1@huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755856094; a=rsa-sha256;
	cv=none;
	b=1qBCVWkAeLab+37ZkX/ZiTJl3MDlqFQNCqCF2wB+coJQXNsZzdFhh1KQr4000g/g6UFH6a
	W32t7BFZCYo0I44Tirna8JpsU8s9CFwdYPikgHnlz7RFnXcNswTuSNqIEPUdxVJrlY9gIo
	AAUPkVfJwpFblsqfP9mOT4pKRPcfcKc=
Received: from mail.maildlp.com (unknown [172.19.162.254])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4c7b3B5g00z14MWC;
	Fri, 22 Aug 2025 17:48:06 +0800 (CST)
Received: from dggpemf200018.china.huawei.com (unknown [7.185.36.31])
	by mail.maildlp.com (Postfix) with ESMTPS id 75914180495;
	Fri, 22 Aug 2025 17:48:11 +0800 (CST)
Received: from huawei.com (10.50.85.135) by dggpemf200018.china.huawei.com
 (7.185.36.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Fri, 22 Aug
 2025 17:48:10 +0800
From: Quanmin Yan <yanquanmin1@huawei.com>
To: <sj@kernel.org>
CC: <akpm@linux-foundation.org>, <damon@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
	<yanquanmin1@huawei.com>, <wangkefeng.wang@huawei.com>, <zuoze1@huawei.com>
Subject: [PATCH v2 09/11] Docs/admin-guide/mm/damon/usage: document addr_unit file
Date: Fri, 22 Aug 2025 17:34:17 +0800
Message-ID: <20250822093420.2103803-10-yanquanmin1@huawei.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250822093420.2103803-1-yanquanmin1@huawei.com>
References: <20250822093420.2103803-1-yanquanmin1@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.50.85.135]
X-ClientProxiedBy: kwepems500002.china.huawei.com (7.221.188.17) To
 dggpemf200018.china.huawei.com (7.185.36.31)
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 34737120010
X-Stat-Signature: k5ug8913wy3suth1a4os6f7th56un3h3
X-Rspam-User: 
X-HE-Tag: 1755856093-101572
X-HE-Meta: U2FsdGVkX192gRkIyY1/7HJvg+vFBiBpRQlh6HZdki+HlkMpKdGehKkB4x3iN0vWIi6ArAqxmEDiMC9EFE/AafFxqWtjFQPcf8XayQxrAlvU+pAAj1SUzlIaX7+fW09LWvRlINxOaAR8ieFIb7QJ0O4m0AlM0gEufgVf2IckBAsoYM+aJQVQ09U1AGNZhiIyw2GMdZ6kWKNmHCCra91dRHhsO6uIO2AmVvxGcboYrK0LSxSPbihVe7xhe8irLJiY2P6e9YV/e+1eGeNVOTiJGBhQy1ZYKU85uGszlilz34/mZQFZbM4qdeWbLEhMMCtl8RmPVg4cMUM5MWOghVS7PEbsSxF/7PZw2DKKC0Xqi428KPzetz0ydc6sS+jl2Gd9AuPmHANL9VmyHj6KiiCZePh/kNNljj1+vRK0nn/hIRsfqqrqQx7P9Atid2AhPK5OhZVhLMPRdDOy4yaozrJX6v15cC2D6kQ1qJIIl42XgNn/bSZxcuXHmI/AfsqohoxhzDkvOYSfJVpv1oGgvq1kTlo7VmfWOBVm98PigLzMaSRBfcvhnahTP62MSjlO/kOw/HjcUl31gJeNR5hmwY8CnQw4FmYPiqS8OV1D3L5ueS5h0agnTJrDOdEmt3lZjU5jRAgTQ4QXGrG6gN12hMk6laC6W5Mcezc2o6rtxAWmOagBRlunBnS0juG6NiTB3qtfiHhRGBqpGlOpA9G7wqK5jqB/g1SOT+B0o23xtxE3z/bBZzKzLZtqQYh1EOmOvFCePD+RsplWKunka1/0e5CLnLwWOhfaGAma0bTqqPGZ08TSsdq4CqfxQZ22SsWSI8h7Vt3nd6w3S7S4m3bvU6NDGZo7SCsrNz4WUlt7jFgnH9q5NXUbaiEv4NQMObsVYQipBOwvwFltTtvZrOVsCICFFCGcOLFlETAyORue1YYbp/b3IbU0mhXpMhXEsbZYzV6cQDA6u+o4d0d93Ycj/0h
 E7x7gGIM
 bJcUpeeqhh3nURWwvV0Duz8LhuQypohytJafvWQx1hSUcj5QEL4SxA6VaEhRaL2xfFIHo5VjVMrZVQyCInaZvuEXTefgYk814CAFiefq15+gIQWM9GLR6ppJkk72u/OmS9r6IkdPwt8opo/ITEtp8S2fjwHfPvL4XpA6BiZ21Wx3xTthYnZHRfxdYtche7iaYG/aG0ggyy1J+Ufo6gOr3ec+laWCMfNiU6bVT10I1CJe/cGFK6rFNRH13pbTjYWqsL1NtQxPK2O0Kuzlt5ohNKo5PZs3ZwCn4/nXQ9fTz7CVNN08=
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
Signed-off-by: Quanmin Yan <yanquanmin1@huawei.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
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
index d9d5baa1ec87..80354f4f42ba 100644
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
2.43.0


