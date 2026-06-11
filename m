Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EEA19CD98CF
	for <linux-mm@archiver.kernel.org>; Thu, 11 Jun 2026 15:03:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3CD6F6B0092; Thu, 11 Jun 2026 11:03:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 37E856B0093; Thu, 11 Jun 2026 11:03:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 246CA6B0096; Thu, 11 Jun 2026 11:03:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 06DDA6B0092
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 11:03:47 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id BBEDCA0694
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 15:03:46 +0000 (UTC)
X-FDA: 84867951252.08.97E3D2C
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	by imf26.hostedemail.com (Postfix) with ESMTP id 981D2140005
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 15:03:44 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei-partners.com;
	spf=pass (imf26.hostedemail.com: domain of gutierrez.asier@huawei-partners.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=gutierrez.asier@huawei-partners.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781190224;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=fBL34ElJNAGmW1y1qrov52atV+/JHsBxV8I34oDQOCs=;
	b=iqmlIb1iEYjWeYLmVHMXpHcvHxbow4rLiCo44yDOZPdR5bXHz7U5ALtMEhN1lpKNQzbl8r
	F1TnhKszw0JOXubR/4pGH3IdlAiu2Iv7blftfIRbIKtKBGLTuCIvaxq5ugNvJKCNq2SV5r
	0IzRl26aJVTsgMnsHzPS2rvR3Ioq1AY=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei-partners.com;
	spf=pass (imf26.hostedemail.com: domain of gutierrez.asier@huawei-partners.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=gutierrez.asier@huawei-partners.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781190224;
	b=5z2vG4QdYqi4c60padcWvDT+9QE7w1c1kbvPzqW/xLxXNLkndFlTJD7NAUwkNtIBnumrin
	AeD6B57YBQDH4sGmCu8Wg1luzK5hASjKbPjByEX3LukmODY5NaSIyDAzZymt+stftwZnXT
	VAVP9eMuV73Uq6T7Y9Ks7azm+KUyfV0=
Received: from mail.maildlp.com (unknown [172.18.224.150])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4gbm9l4D8SzJ46bR;
	Thu, 11 Jun 2026 23:03:23 +0800 (CST)
Received: from mscpeml500003.china.huawei.com (unknown [7.188.49.51])
	by mail.maildlp.com (Postfix) with ESMTPS id D175F40571;
	Thu, 11 Jun 2026 23:03:38 +0800 (CST)
Received: from mscphis01197.huawei.com (10.123.65.218) by
 mscpeml500003.china.huawei.com (7.188.49.51) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 11 Jun 2026 18:03:38 +0300
From: <gutierrez.asier@huawei-partners.com>
To: <gutierrez.asier@huawei-partners.com>, <artem.kuzin@huawei.com>,
	<stepanov.anatoly@huawei.com>, <wangkefeng.wang@huawei.com>,
	<yanquanmin1@huawei.com>, <zuoze1@huawei.com>, <damon@lists.linux.dev>,
	<sj@kernel.org>, <akpm@linux-foundation.org>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>
Subject: [RFC PATCH v4 4/4] Documentation/admin-guide/mm/damon: add DAMON-based Hugepage Management
Date: Thu, 11 Jun 2026 15:02:44 +0000
Message-ID: <20260611150244.3454699-5-gutierrez.asier@huawei-partners.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260611150244.3454699-1-gutierrez.asier@huawei-partners.com>
References: <20260611150244.3454699-1-gutierrez.asier@huawei-partners.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.123.65.218]
X-ClientProxiedBy: mscpeml500003.china.huawei.com (7.188.49.51) To
 mscpeml500003.china.huawei.com (7.188.49.51)
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: f4bkmecdxcdb6qjmhc5qf6tebjddgfpp
X-Rspamd-Queue-Id: 981D2140005
X-HE-Tag: 1781190224-994348
X-HE-Meta: U2FsdGVkX1+qT42sdR6Em2FkFgxQjUvkPWEyOESy9c/IQ5hDzwZQ0xNxuf4SZdUj11VkB2SyonU8TxPdip+ZmngA+csQ7iUCMdGk1CZkRwxc4aVEITg9lSlCeRDwFViQST18Lpw+dauIRcnxmmPropY5uj/mySI4q2nslQaTwsS+EDL+9aCPwkvfjGUXwOVTIWelehnhsVmm36fmCPVF4maxosyLYIGAdKsh3QSeleUkZpJ9IkdT7Z6rsEKMKubmjlEKG3UtbErszn5bl4QCx4ERT+i9ZUikBU/mwSpjil11Vj3DhR6lz1/g6I+JHyT3Yh1j3QVZncaxtxESp4d1EQ8zn07zgQad9m2R3roSjexLvu4t/Cu1ulusyv2FLHziRxWjK2T3JObAkJ7cehdB9Ow8+BvzL+Zrh/DROfR0i2Dr6BHCkNJmvH0bVHtiLDV566gYnOW/lg6lmvifEUuZIYfW6wgAV3YZfL7sgP6wvdyFIOVt1j9F4suePpJYeOX3zHBc1ld8TRwO62CaCs6jaywWZS13d5Tu/YfMamgSNTt5w4zJ9sChMD7GXadR+iPHHahYmDXrP2xIsU+fNykSEBlw18IYun+yj5JQZVDVjioeKujBDytg0tCv7HVeM+yPNwbPyG0HW8/CmrXwWe71z/13ODsah7ZmPA+3DGGRj542mrnbjToC8JtoxnQcnmClGzcJQkkhJTdsNsiX+J7L2JH4rcLm89Kf/EJyLoIkZSY4a9Wj4C73QcwAIrRtzKwW2zUS2IWhPjaRQgCR1cEHC2ckiP5fQaAxTz8ci354GXioRkzGMaCrMc15C3ZwCW1f2lP0D9jW7fa5XcqKBp3TpRcGXEGJjG+6WlpVSY/s1zU6zR3AADVii56PLfE8HoGo35xh183gexgBvozw/GFywv5OItWxNjSZN7YvM7HqT5SnqGl5+Hn2BzutO+cVLHH07u3AF8aMoM/qM9NgcbS
 L/4NybfG
 xebtvYy9/8hFGYxycSzbwoGXCF1MJfCjYm8oqVq7hM+uy09aNtzQAi4+xf4+tWIuVUl+B/KS/IfFsiZJY49/YA9a/Km0Bdchgaxr5t2JSue9x1LenVwZr/OG7xoSXUCb5vcZD5+tLNtcTOEEc903iwhGw6LS7kKAtoTmllNkwcRFarNFhFzjrTpA88ium2PKEq58DpXCIHs46BTIiggveFyc2rKJmzgeVjOSOOcRKOeHt273W1gGgmyv+VrbO237j3HyghbGjLKT4h70=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Asier Gutierrez <gutierrez.asier@huawei-partners.com>

Add documentation for the DAMON-based Hugepage Management
(SAMPLE_DAMON_HUGEPAGE) feature, which automatically manages
huge pages by identifying hot memory regions and collapsing
them back to regular pages. The documentation covers the
module's features, operation, and all available module
parameters.

Signed-off-by: Asier Gutierrez <gutierrez.asier@huawei-partners.com>
---
 .../admin-guide/mm/damon/hugepage.rst (new)   | 113 ++++++++++++++++++
 Documentation/admin-guide/mm/damon/index.rst  |   1 +
 2 files changed, 114 insertions(+)

diff --git a/Documentation/admin-guide/mm/damon/hugepage.rst b/Documentation/admin-guide/mm/damon/hugepage.rst
new file mode 100644
index 000000000000..470ae2bc8cc3
--- /dev/null
+++ b/Documentation/admin-guide/mm/damon/hugepage.rst
@@ -0,0 +1,113 @@
+================================
+DAMON-based huge page collapsing
+================================
+
+DAMON-based huge page collapsing (SAMPLE_DAMON_HUGEPAGE) is a static kernel
+module that aims to collapse hot regions into huge pages.
+
+Where Proactive huge page collapsing is Required?
+=================================================
+
+The amount of available memory grows faster than the amount of TLB entries.
+This leads to higher amount of TLB misses and excessive cycle wastes. Huge
+pages are meant to solve this problem. However, huge pages usually lead to
+memory fragmentation and memory waste.
+
+Collapsing selectively hot regions in a specific process can avoid big
+memory fragmentation, while increasing TLB performance.
+
+SAMPLE_DAMON_HUGEPAGE solves this by:
+
+- Identifying hot regions that have been accessed for a configured time
+- Automatically collapsing the regions into huge pages back
+- Auto tune the huge page usage ratio to meet desired targets
+- Controlling the collapse rate with configurable quotas to avoid performance
+  degradation
+
+
+How It Works?
+=============
+
+SAMPLE_DAMON_HUGEPAGE uses kdamond to identify anonymous memory regions that
+are:
+
+1. Large enough to be backed by huge pages (``HPAGE_PMD_SIZE`` or larger)
+2. Have been accessed for a configured time period
+
+Once identified, SAMPLE_DAMON_HUGEPAGE triggers synchronous partial collapse
+of those regions. The collapse operation is controlled by quotas to limit the
+impact on system performance.
+
+The module also supports automatic tuning of the collapse rate to achieve a
+desired huge page usage ratio. Administrators can configure a target percentage
+of huge page usage vs total anonymous memory usage.
+
+Additionally, the module accepts manual feedback from system administrators to
+adjust the effective quota level based on observed system behavior.
+
+Interface: Module Parameters
+============================
+
+To use this feature, you should first ensure your system is running on a kernel
+that is built with ``CONFIG_DAMON_HUGEPAGE=y``.
+
+To let sysadmins enable or disable it and tune for the given system,
+SAMPLE_DAMON_HUGEPAGE utilizes module parameters.  That is, you can put
+``damon_sample_hugepage.<parameter>=<value>`` on the kernel boot command line or
+write proper values to ``/sys/module/damon_sample_hugepage/parameters/<parameter>``
+files.
+
+Below are the description of each parameter.
+
+enabled
+-------
+
+Enable or disable SAMPLE_DAMON_HUGEPAGE.
+
+You can enable SAMPLE_DAMON_HUGEPAGE by setting the value of this parameter as ``Y``.
+Setting it as ``N`` disables SAMPLE_DAMON_HUGEPAGE.  Note that SAMPLE_DAMON_HUGEPAGE
+could do no real monitoring and collapse due to the activation condition.
+
+quota_autotune_feedback
+-----------------------
+
+User-specifiable feedback for auto-tuning of the effective quota.
+
+While keeping the caps that set by other quotas, SAMPLE_DAMON_HUGEPAGE
+automatically increases and decreases the effective level of the quota
+aiming receiving this feedback of value ``10,000`` from the user.
+SAMPLE_DAMON_HUGEPAGE assumes the feedback value and the quota are positively
+proportional.  Value zero means disabling this auto-tuning feature.
+
+Disabled by default.
+
+quota_percentage_hugepage
+-------------------------
+
+Huge page consumption to total memory anonymous memory consumption ratio goal
+in bp ``(10,000)``. SAMPLE_DAMON_HUGEPAGE automatically increases and
+decreases page collapse aggressiveness in order to achieve the given value.
+
+target_pid
+----------
+
+PID of the task that is going to be monitored for hot regions.
+
+
+Example
+=======
+
+Below runtime example commands make SAMPLE_DAMON_HUGEPAGE to find memory
+regions of  the task with PID 1234 that have been accessed in the last 100
+milliseconds or more and collpases those pages into huge pages. The page
+collapsing is limited to be done only up to 1 GiB per second to avoid
+SAMPLE_DAMON_HUGEPAGE consuming too much CPU time for the collapse operation. ::
+
+    # cd /sys/module/damon_sample_hugepage/parameters
+    # echo 1234 > target_pid
+    # echo Y > enabled
+
+Note that this module (SAMPLE_DAMON_HUGEPAGE) cannot run simultaneously
+with other DAMON-based special-purpose modules.  Refer to
+:ref:`DAMON design special purpose modules exclusivity
+<damon_design_special_purpose_modules_exclusivity>` for more details.
\ No newline at end of file
diff --git a/Documentation/admin-guide/mm/damon/index.rst b/Documentation/admin-guide/mm/damon/index.rst
index 3ce3164480c7..6f2cad21a2da 100644
--- a/Documentation/admin-guide/mm/damon/index.rst
+++ b/Documentation/admin-guide/mm/damon/index.rst
@@ -15,3 +15,4 @@ access monitoring and access-aware system operations.
    reclaim
    lru_sort
    stat
+   hugepage
-- 
2.43.0


