Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4779CA0EF8
	for <linux-mm@archiver.kernel.org>; Thu, 21 Aug 2025 11:06:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 22C658E001A; Thu, 21 Aug 2025 07:06:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1DBE28E0003; Thu, 21 Aug 2025 07:06:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0CAC98E001A; Thu, 21 Aug 2025 07:06:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EADFE8E0003
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 07:06:06 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B97D2B8BBD
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 11:06:06 +0000 (UTC)
X-FDA: 83800485132.26.FDAC3BE
Received: from szxga05-in.huawei.com (szxga05-in.huawei.com [45.249.212.191])
	by imf05.hostedemail.com (Postfix) with ESMTP id 39686100010
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 11:06:03 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf05.hostedemail.com: domain of yanquanmin1@huawei.com designates 45.249.212.191 as permitted sender) smtp.mailfrom=yanquanmin1@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755774364;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jD5g75TsKywUFQAP6VzGnGpAmJUMhYARTRfrMlFFycU=;
	b=tSPGVJX8Gd0XEqzmlW67E+4oHzfsyrDdDVJlfqVxumwr4/fyhIw8LUOAIUdD67BPCoE2PV
	EnUYH5piMaEXanlx7k+4Pn3GuFZKYzgQcIs5oZ6vJTMFVrQ+EDxL19hcnABxUbtIrhb7bA
	+aIiT5HvLJQeoYcvSEbSfhvkdMV3sI8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755774364; a=rsa-sha256;
	cv=none;
	b=YA4ESC689d1/jOpsECThPl3V/CURRMxVGyAh0nw8CzdT91t41zqsM4OGirbpt3mLyicWFw
	iw9hiWKxI1p9bfcB6udcH6PwYCbpt2WNLHy3WlZEgzeZ3Qk4EG8n7SYKtSrH7yhZ4dKsxV
	DDNzmSVkFwF2zeUb5A0kz5o93NwhXZk=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf05.hostedemail.com: domain of yanquanmin1@huawei.com designates 45.249.212.191 as permitted sender) smtp.mailfrom=yanquanmin1@huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.44])
	by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4c70lz2Ltkz2gL7C;
	Thu, 21 Aug 2025 19:02:55 +0800 (CST)
Received: from dggpemf200018.china.huawei.com (unknown [7.185.36.31])
	by mail.maildlp.com (Postfix) with ESMTPS id E2B15140148;
	Thu, 21 Aug 2025 19:05:48 +0800 (CST)
Received: from huawei.com (10.50.85.135) by dggpemf200018.china.huawei.com
 (7.185.36.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Thu, 21 Aug
 2025 19:05:48 +0800
From: Quanmin Yan <yanquanmin1@huawei.com>
To: <sj@kernel.org>
CC: <akpm@linux-foundation.org>, <damon@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
	<yanquanmin1@huawei.com>, <wangkefeng.wang@huawei.com>, <zuoze1@huawei.com>
Subject: [PATCH 09/11] Docs/admin-guide/mm/damon/usage: document addr_unit file
Date: Thu, 21 Aug 2025 18:51:57 +0800
Message-ID: <20250821105159.2503894-10-yanquanmin1@huawei.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250821105159.2503894-1-yanquanmin1@huawei.com>
References: <20250821105159.2503894-1-yanquanmin1@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.50.85.135]
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 dggpemf200018.china.huawei.com (7.185.36.31)
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 39686100010
X-Stat-Signature: pjibj9hceqk9wtc6e1mt51gknyq4j48u
X-HE-Tag: 1755774363-539081
X-HE-Meta: U2FsdGVkX1//0ziYtHRAsb0hilEqe393kdQ9JBJr7KboLg8jrE2CeEDvvLZa5iU7J4FgdxOdZDlvAHvS16gPymYQzv0cRe4v993DoWrTaSq6l/OCxYadUafuklIyV5h9ql5YkvcH9wDgu80opK1snpAWvVlxb1RrbceqDKN+K4tLURqtGLg3mhMINCnQscsUBIMFL3Sapn9YuHCP0l4nc5SO9HrU28js9hS1JmEP7DZ9DmVl2iTjvfWL/a4TTF8GW5csrL93LQk+xvNWlrNN6+R6c/aawPXJoLJr64ntuJD251mId7tOzMrUGeWLfpUCdRu/Q0kVPMXiHc9VJU/YU17gIlvPvUf9mxvaDBwisEBovuN4wcinkgyeqLpsLxPht7jtIcap4lBmwWXMVIY81a4s+L0dirW8zfpSZEmdCfjvCxnjrdPu3q2voEc3j0fEJWvwa57C9vug8wkjobVSlJQmLo+zeuw2txyRjSV4SlxR7M4Esdf+GNHpDBmvN83plUwoWOYhltgv1CoHWBPUSFwzgOJVtdg0Tn9AsDQgN+UYWqqJHWvJF5O6ZWC04ODXmqJUq/lpomXqwv813sFmhkpCI1ZDiafqn7FD8UbYN876jN7nfcyZ9UMfyTcZef5UBZFUVgHjwRm24xaS0x2B3UKDxS8y8t8Nj/rFqHLTyvvDo2/8FVCe6IXRo38luh0W+ZNWgMIbB27EO5+3qpuBCNtO3o9B9yYqmElPIcJKQU83C2ITZ0hYhFyad2Vtu4rmCVZwpe+DSvdFALURyYkzhyjCC0CHsnkmVcOpBWWBwyu0KnTqcocbojEP+Mk4fK0idNrisheEe3VeJLEKRey8PujJIDkX/0+xpYmMR/lwdS+3ztqa95AN/E21jh8dnca1UEgzojfXnmIUeZ04+F3Ecm0xBhozTa1DAQB6im9D+8NAQd7qbpq8h04vpFQLZ9OVI86TNVWPSwH2g6zZfKR
 4c7GgLh2
 p8juvngCCh78cPnQAOyEJI2DbXUa7hJGyle2DXhSBvbpBuBYO2bjQQp0t5iHrJmOaIszkbBe3WbPtisglIfoTymCYgRf0PABbQOHucHVDXXCqpV6Vih0IYSHu3s5Fx7QmXCyAQcCPoDDVKshE+aJf/Dwa2HAdMBKg311cLyRosJUsgba5T/DwUkYyRWk2o73j3UDKsLqK9Q8eMPeA9p2XSC+VRlIGlKFh4ZYuLGiwgtK4nLM94Frd1P438dAFBdSgNOKMdWArn/wXOQOcvz983mmoG27YdEXm54VH
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


