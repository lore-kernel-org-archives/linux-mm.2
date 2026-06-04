Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B79BDCD6E6D
	for <linux-mm@archiver.kernel.org>; Thu,  4 Jun 2026 15:04:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 86B206B0092; Thu,  4 Jun 2026 11:04:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 81C3C6B0095; Thu,  4 Jun 2026 11:04:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 70B816B0098; Thu,  4 Jun 2026 11:04:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5F7116B0092
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 11:04:40 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 23E5540153
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 15:04:40 +0000 (UTC)
X-FDA: 84842551920.29.907DC21
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	by imf01.hostedemail.com (Postfix) with ESMTP id 5271140027
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 15:04:30 +0000 (UTC)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780585470;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1RteInx86sePvuvcbd5ot78grkb4cpvOZ0dj8V9OSlk=;
	b=X9u+FQ3asENAjNqpcng6Oek5LzDgmxfbS8HOCKT7+eWDRhk6CIMkD1xWuT+3dv7QrbGEqc
	4cGr6PrcPVcPbbcRFUfh+3V4nYuTYK4X293wp82DAoK0eOlrin8Z4+LyJaZCRWI1PFwkHC
	5x6Sans37zxnqT2HTqJUJzPYqXtowIM=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei-partners.com;
	spf=pass (imf01.hostedemail.com: domain of gutierrez.asier@huawei-partners.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=gutierrez.asier@huawei-partners.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780585470;
	b=WiCxGCLHvROh2gcBlmp9eYE4+i/CcTBMb4EqIvvWunvnDdpesg89ll1n1jxOqytlnktJEq
	u9J9P0EXoWtas29LUUAlYblg4TDG8ltqPE+m5VMsUJkSIG+BosDoUfUzD7p/LM1lkJeIle
	stZmWbuThU+zNwGjx7/gyW0kNMEZXHA=
Received: from mail.maildlp.com (unknown [172.18.224.83])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4gWSX60SCWzJ468w;
	Thu,  4 Jun 2026 23:04:22 +0800 (CST)
Received: from mscpeml500003.china.huawei.com (unknown [7.188.49.51])
	by mail.maildlp.com (Postfix) with ESMTPS id BAB9A4057A;
	Thu,  4 Jun 2026 23:04:25 +0800 (CST)
Received: from mscphis01197.huawei.com (10.123.65.218) by
 mscpeml500003.china.huawei.com (7.188.49.51) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 4 Jun 2026 18:04:25 +0300
From: <gutierrez.asier@huawei-partners.com>
To: <gutierrez.asier@huawei-partners.com>, <artem.kuzin@huawei.com>,
	<stepanov.anatoly@huawei.com>, <wangkefeng.wang@huawei.com>,
	<yanquanmin1@huawei.com>, <zuoze1@huawei.com>, <damon@lists.linux.dev>,
	<sj@kernel.org>, <akpm@linux-foundation.org>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>
Subject: [RFC PATCH v3 4/4] Documentation/admin-guide/mm/damon: add DAMON-based Hugepage Management
Date: Thu, 4 Jun 2026 15:03:37 +0000
Message-ID: <20260604150338.501128-5-gutierrez.asier@huawei-partners.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260604150338.501128-1-gutierrez.asier@huawei-partners.com>
References: <20260604150338.501128-1-gutierrez.asier@huawei-partners.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.123.65.218]
X-ClientProxiedBy: mscpeml100003.china.huawei.com (10.199.174.67) To
 mscpeml500003.china.huawei.com (7.188.49.51)
X-HE-Tag: 1780585470-791948
X-HE-Meta: U2FsdGVkX1+EqjqfarCuJar6LEVchsKFBYgAkMR1hKlNTL/yT19tutBHjxDghaaEQjlGLkzsyIct5ImgH5K6sUSWc9lXLlVAG2G71RQaM4M4hlnJW2aRK7TO+UpYCORQzm0LceQmBjAEwo/BdoUCgVLdtatDceZkbc+MWi7ISh9WwrQszf5THq4W9C+HzrQSL/6JibLQn4PCmLY3ETq/Swe7QPOQ0Z2adxcNMluNhCtFSbYpfJ0jS7gt9a6EXj/R/y9qotiNekSWXL2MxgIy3yIG2PpvDfwlmuS5TXwf9E0G7YnzJF6guRWhqLmYNNxCSxA8QRqC3fL9Rl7NAT+IQ3Fw5XS/HCVtFRSYTWQKWfcMjaIlG3PiqFmrG0NFsINfmnpW/IhyTFVPyWgdOK7dVw==
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
 .../admin-guide/mm/damon/hugepage.rst (new)   | 271 ++++++++++++++++++
 1 file changed, 271 insertions(+)

diff --git a/Documentation/admin-guide/mm/damon/hugepage.rst b/Documentation/admin-guide/mm/damon/hugepage.rst
new file mode 100644
index 000000000000..86104aaa4d1c
--- /dev/null
+++ b/Documentation/admin-guide/mm/damon/hugepage.rst
@@ -0,0 +1,271 @@
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
+1. Large enough to be backed by huge pages (``PMD_SIZE`` or larger)
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
+``damon_hugepage.<parameter>=<value>`` on the kernel boot command line or write
+proper values to ``/sys/module/damon_hugepage/parameters/<parameter>`` files.
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
+commit_inputs
+-------------
+
+Make SAMPLE_DAMON_HUGEPAGE reads the input parameters again, except ``enabled``.
+
+Input parameters that updated while SAMPLE_DAMON_HUGEPAGE is running are
+not applied by default.  Once this parameter is set as ``Y``,
+SAMPLE_DAMON_HUGEPAGE reads values of parameters except ``enabled`` again.
+Once the re-reading is done, this parameter is set as ``N``.  If invalid
+parameters are found while the re-reading, SAMPLE_DAMON_HUGEPAGE will be
+disabled.
+
+Once ``Y`` is written to this parameter, the user must not write to any
+parameters until reading ``commit_inputs`` again returns ``N``.  If users
+violate this rule, the kernel may exhibit undefined behavior.
+
+min_age
+-------
+
+Time threshold for hot memory regions identification in microseconds.
+
+100 milliseconds by default.
+
+quota_ms
+--------
+
+Limit of time for the collapse in milliseconds.
+
+SAMPLE_DAMON_HUGEPAGE tries to use only up to this time within a time
+window (quota_reset_interval_ms) for trying collapse hot pages.  This can
+be used for limiting CPU consumption of SAMPLE_DAMON_HUGEPAGE.  If the
+value is zero, the limit is disabled.
+
+10 ms by default.
+
+quota_reset_interval_ms
+-----------------------
+
+The time/size quota charge reset interval in milliseconds.
+
+The charget reset interval for the quota of time (quota_ms) and size
+(quota_sz).  That is, SAMPLE_DAMON_HUGEPAGE does not try collapsing for
+more than quota_ms milliseconds or quota_sz bytes within
+quota_reset_interval_ms milliseconds.
+
+1 second by default.
+
+quota_sz
+--------
+
+Limit of size of memory for the reclamation in bytes.
+
+SAMPLE_DAMON_HUGEPAGE charges amount of memory which it tried to collapse
+regions into huge pages within a time window (quota_reset_interval_ms) and
+makes no more than this limit is tried. This can be used for limiting
+consumption of CPU and IO.  If this value is zero, the limit is disabled.
+
+128 MiB by default.
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
+monitored_pid
+----------------
+
+PID of the task that is going to be monitored for hot regions.
+
+quota_percentage_hugepage
+-------------------------
+
+Huge page consumption to total memory anonymous memory consumption ratio goal
+in bp ``(10,000)``. SAMPLE_DAMON_HUGEPAGE automatically increases and
+decreases page collapse aggressiveness in order to achieve the given value.
+
+sample_interval
+---------------
+
+Sampling interval for the monitoring in microseconds.
+
+The sampling interval of DAMON for the hot memory monitoring.  Please refer to
+the DAMON documentation (:doc:`usage`) for more detail.
+
+aggr_interval
+-------------
+
+Aggregation interval for the monitoring in microseconds.
+
+The aggregation interval of DAMON for the hot memory monitoring.  Please
+refer to the DAMON documentation (:doc:`usage`) for more detail.
+
+min_nr_regions
+--------------
+
+Minimum number of monitoring regions.
+
+The minimal number of monitoring regions of DAMON for the hot memory
+monitoring.  This can be used to set lower-bound of the monitoring quality.
+But, setting this too high could result in increased monitoring overhead.
+Please refer to the DAMON documentation (:doc:`usage`) for more detail.
+
+Note that this must be 3 or higher. Please refer to the :ref:`Monitoring
+<damon_design_monitoring>` section of the design document for the rationale
+behind this lower bound.
+
+max_nr_regions
+--------------
+
+Maximum number of monitoring regions.
+
+The maximum number of monitoring regions of DAMON for the cold memory
+monitoring.  This can be used to set upper-bound of the monitoring overhead.
+However, setting this too low could result in bad monitoring quality.  Please
+refer to the DAMON documentation (:doc:`usage`) for more detail.
+
+addr_unit
+---------
+
+A scale factor for memory addresses and bytes.
+
+This parameter is for setting and getting the :ref:`address unit
+<damon_design_addr_unit>` parameter of the DAMON instance for
+SAMPLE_DAMON_HUGEPAGE.
+
+``monitor_region_start`` and ``monitor_region_end`` should be provided in this
+unit.  For example, let's suppose ``addr_unit``, ``monitor_region_start`` and
+``monitor_region_end`` are set as ``1024``, ``0`` and ``10``, respectively.
+Then SAMPLE_DAMON_HUGEPAGE will work for 10 KiB length of physical address range
+that starts from address zero (``[0 * 1024, 10 * 1024)`` in bytes).
+
+``bytes_hugepage_tried_regions`` and ``bytes_hugepage_regions`` are also in
+this unit.  For example, let's suppose values of ``addr_unit``,
+``bytes_hugepage_tried_regions`` and ``bytes_hugepage_regions`` are
+``1048576``, ``42``, and ``32``, respectively.  Then it means
+SAMPLE_DAMON_HUGEPAGE tried to collapse 42 MiB memory and successfully collapse
+32 MiB memory in total.
+
+If unsure, use only the default value (``1``) and forget about this.
+
+
+kdamond_pid
+-----------
+
+PID of the DAMON thread.
+
+If SAMPLE_DAMON_HUGEPAGE is enabled, this becomes the PID of the worker thread.
+Else, -1.
+
+nr_hugepage_tried_regions
+-------------------------
+
+Number of memory regions that tried to be collapsed by SAMPLE_DAMON_HUGEPAGE.
+
+bytes_hugepage_tried_regions
+----------------------------
+
+Total bytes of memory regions that tried to be collapsed by SAMPLE_DAMON_HUGEPAGE.
+
+nr_hugepage_regions
+--------------------
+
+Number of memory regions that successfully be collapsed by SAMPLE_DAMON_HUGEPAGE.
+
+bytes_hugepage_regions
+-----------------------
+
+Total bytes of memory regions that successfully be collapsed by SAMPLE_DAMON_HUGEPAGE.
+
+nr_quota_exceeds
+----------------
+
+Number of times that the time/space quota limits have exceeded.
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
+    # cd /sys/module/damon_hugepage/parameters
+    # echo 100000 > min_age
+    # echo $((1 * 1024 * 1024 * 1024)) > quota_sz
+    # echo 1000 > quota_reset_interval_ms
+    # echo 1234 > monitored_pid
+    # echo Y > enabled
+
+Note that this module (SAMPLE_DAMON_HUGEPAGE) cannot run simultaneously
+with other DAMON-based special-purpose modules.  Refer to
+ :ref:`DAMON design special purpose modules exclusivity
+ <damon_design_special_purpose_modules_exclusivity>` for more details.
\ No newline at end of file
-- 
2.43.0


