Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F626CA0EED
	for <linux-mm@archiver.kernel.org>; Wed, 20 Aug 2025 08:20:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 156EF8E0035; Wed, 20 Aug 2025 04:20:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 108CD8E002D; Wed, 20 Aug 2025 04:20:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EEB6E8E0035; Wed, 20 Aug 2025 04:20:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id D32C28E002D
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 04:20:14 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 633C5140379
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 08:20:14 +0000 (UTC)
X-FDA: 83796438348.16.1F9EDDC
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	by imf22.hostedemail.com (Postfix) with ESMTP id 269B2C0002
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 08:20:10 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=none;
	spf=pass (imf22.hostedemail.com: domain of yanquanmin1@huawei.com designates 45.249.212.188 as permitted sender) smtp.mailfrom=yanquanmin1@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755678012;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jD5g75TsKywUFQAP6VzGnGpAmJUMhYARTRfrMlFFycU=;
	b=epZpwm7D+DIqXLkoVbS8H0PNBIivA2jOimglPTzDftM9+12xwUVQK/PzTyRfZhlaRuCHpm
	tx++uSo12EYLF6wpgs56gH/uCuQvux9UqxR0pJN6aq+pzfRj1HCqbFoXJsz1z+xVlnFTzp
	/L7Vfma2OYPvsvS4UZTOVYhl/PIP2CI=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=none;
	spf=pass (imf22.hostedemail.com: domain of yanquanmin1@huawei.com designates 45.249.212.188 as permitted sender) smtp.mailfrom=yanquanmin1@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755678012; a=rsa-sha256;
	cv=none;
	b=MeqKQYaqjYggwyPzkbF1NF6g08zs5gmkJyMWnF6rAPq7vxHWdxSQ1j0L2x32BFWlSgqe3K
	z00wdltM8KklDYGWrEL6SnbAEjxKAC0IMDKVmsnfCExPRAQ/nOl33SsyQqiI+X5ACi/Kgw
	g4CP0J/t+LYVcTMdTx6l65NtM8eFEYc=
Received: from mail.maildlp.com (unknown [172.19.88.194])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4c6K9T4fFnztTRl;
	Wed, 20 Aug 2025 16:19:09 +0800 (CST)
Received: from dggpemf200018.china.huawei.com (unknown [7.185.36.31])
	by mail.maildlp.com (Postfix) with ESMTPS id 97306140123;
	Wed, 20 Aug 2025 16:20:08 +0800 (CST)
Received: from huawei.com (10.50.85.135) by dggpemf200018.china.huawei.com
 (7.185.36.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Wed, 20 Aug
 2025 16:20:07 +0800
From: Quanmin Yan <yanquanmin1@huawei.com>
To: <sj@kernel.org>
CC: <akpm@linux-foundation.org>, <damon@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
	<yanquanmin1@huawei.com>, <wangkefeng.wang@huawei.com>, <zuoze1@huawei.com>
Subject: [RFC PATCH mm-next v2 09/12] Docs/admin-guide/mm/damon/usage: document addr_unit file
Date: Wed, 20 Aug 2025 16:06:19 +0800
Message-ID: <20250820080623.3799131-10-yanquanmin1@huawei.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250820080623.3799131-1-yanquanmin1@huawei.com>
References: <20250820080623.3799131-1-yanquanmin1@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.50.85.135]
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 dggpemf200018.china.huawei.com (7.185.36.31)
X-Rspamd-Queue-Id: 269B2C0002
X-Rspam-User: 
X-Stat-Signature: qzsjk7cjmt4d481pe8z4yq9ui6rs516u
X-Rspamd-Server: rspam09
X-HE-Tag: 1755678010-414431
X-HE-Meta: U2FsdGVkX18dD+K4oSn0ywclLG1LUCb0qqYZo/9MsHBGjJbtVfovSDGFi0ykHAAKOIZNMGFSlTztobcQgollS1PFWgUQOclMitpB1ub/ynMr01OHx27t3WD2VMSjfFvg68SNR2h68q1/2CwRx+Zn3ekE0WaFBgtvWgb65X45Eie57ZKFWzuZ5xUpLO4pXvTwq64F4KvPisqYupo6+4bbWnd8DuDhyB0ZUun4qPx8q2dPmTPFgwa2dyIM66zKmO8cQUao/T31GPRDa3zyh9VEHDGBiAcheqYuqsXYXYCFIqby4ory0GDv1KIcQ/lNTEbWkZqykRROBFTeRq4dsr/wiokuVBzE6ay/yZ47PqrCWUhJ21RfVdXF0bvNa4z1sStjv1IXsAIcKQUlv+REJs2DhFuBWn2Jxp+KfG5xEsvZqc5FOkm4NPIH9XF8ffIduR18n0Di0U2mwL39Qiy0WO4UwwvkAwZQoan/X5X8kmKhmdB8Uv3WgG07Tq1tchf2xFVMyw5lPqExRMOLWB7QY5e6EGiO+DyAAZew+RnZCGlG6G3wXQAB/zERj+bXZLbY/dqXpyU07786gpRWrGmfbIZYUIwCZzzdHYYUf9Q3TkOBChDfFndgAamBEymCPsf2FW3CLkEO4xRFnWGAPZ7pN9KmzQ78xUI/wL3Le2RaEHkH/INC2bPfgxtPJ4hGokjlJT4ag0bj3uEbQcNhHcLyq2SH7eNSrWEORLaSfBeJTJvOKEHpilcYJTjPN+cxZhexr3UunyRrP1NaSEHSnqmqeuozJy5qJhlIeqp3ym7K+R76cRJamYYfbvr8jbBC7+eRzi3pUUPOJK4i2K2B1EV4wT3hYY/+aJli5hOsjLYN5XOZ5/Z18DCqsmFH3Nn7tsVtdjSk4lHQ0FR/FZeQZjQOeeGVhFSom2OEtmwa17iJ4qAXNkxRc+OyEhIQXITJkjiz6+b4lqefpinZkatt2UxzCpA
 /z2U/6FC
 pbibLjChUHE73Tm81nqIOJ7ggT4ULNm0x3QbIheLuBsfJ+Bj0be0TPA0z8twXRD7+qmmI4OlBmJpB7XaUeB65LmmPcnaARhmPfPoFvlimvgKyBP9ELgJYGpjqSZwbMjKguX8cGij//xFPQD+IO6TQvF+AZy0kXqzgP/gNOZp2pSpIfCPe9bEt1I13gtl/JLqAHt3K6zHw/7y0ZHg94LvrI03XTcr3QtwwOXXD1KW/EY1QHni88bShIb4lyo7rtMZk/BU7lSwn2aXWRLYkOpYSXTh+9gOflWdm/VlVFUSymzb1e88=
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


