Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 28CA3FD4F07
	for <linux-mm@archiver.kernel.org>; Tue, 10 Mar 2026 16:25:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 45F136B009B; Tue, 10 Mar 2026 12:25:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 416BA6B00A0; Tue, 10 Mar 2026 12:25:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 210296B009E; Tue, 10 Mar 2026 12:25:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 01C1E6B009B
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 12:25:39 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B8FE41B714C
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 16:25:39 +0000 (UTC)
X-FDA: 84530679198.14.9FF9805
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	by imf20.hostedemail.com (Postfix) with ESMTP id 999A21C0015
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 16:25:37 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=none;
	spf=pass (imf20.hostedemail.com: domain of gutierrez.asier@huawei-partners.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=gutierrez.asier@huawei-partners.com;
	dmarc=pass (policy=quarantine) header.from=huawei-partners.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773159938;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=HnQI7YHnqipZ6r3ShlzkTDQM32jPv115xws16APUJ90=;
	b=2sqRyKAvW46A1MVvtJ/g+cQ0qIXRr0AaJeNDHPhuOIenDKtnD76sz1FMUcEifQCsGidgAD
	L/NE7K3YdFsHy2bQKdaV4Y7O2z2aa4WLJCE+0eTLNtCJcXsqYt0Ytlq1KXKfxOgb052G6w
	Vep8wDhGNzIZi59/GzWiWdH+c5j54rQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773159938; a=rsa-sha256;
	cv=none;
	b=ZmFj/3bJGbm0Ix6gz889Ypwi7kqkYSfJUk+kl8g/CSE6vhsEvQUDnTtWaedOaT8pEnoOCO
	CcEtdfoaTqpcsSfG7E6/Ya/RY1+eu2H9gqdJVqhFdA4PDKmM7d+iSzenMdmVX9yWlD+YLc
	As8S026DKDkm2P5HAm1QEAMQyFRS6bM=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=none;
	spf=pass (imf20.hostedemail.com: domain of gutierrez.asier@huawei-partners.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=gutierrez.asier@huawei-partners.com;
	dmarc=pass (policy=quarantine) header.from=huawei-partners.com
Received: from mail.maildlp.com (unknown [172.18.224.150])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4fVfNd5FYPzJ467L;
	Wed, 11 Mar 2026 00:24:49 +0800 (CST)
Received: from mscpeml500003.china.huawei.com (unknown [7.188.49.51])
	by mail.maildlp.com (Postfix) with ESMTPS id 8AF044056B;
	Wed, 11 Mar 2026 00:25:34 +0800 (CST)
Received: from mscphis01197.huawei.com (10.123.65.218) by
 mscpeml500003.china.huawei.com (7.188.49.51) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 10 Mar 2026 19:25:34 +0300
From: <gutierrez.asier@huawei-partners.com>
To: <gutierrez.asier@huawei-partners.com>, <artem.kuzin@huawei.com>,
	<stepanov.anatoly@huawei.com>, <wangkefeng.wang@huawei.com>,
	<yanquanmin1@huawei.com>, <zuoze1@huawei.com>, <damon@lists.linux.dev>,
	<sj@kernel.org>, <akpm@linux-foundation.org>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>
Subject: [RFC PATCH v2 4/4] DAMON_HOT_HUGEPAGE documentation
Date: Tue, 10 Mar 2026 16:24:20 +0000
Message-ID: <20260310162420.4180562-5-gutierrez.asier@huawei-partners.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260310162420.4180562-1-gutierrez.asier@huawei-partners.com>
References: <20260310162420.4180562-1-gutierrez.asier@huawei-partners.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.123.65.218]
X-ClientProxiedBy: mscpeml500004.china.huawei.com (7.188.26.250) To
 mscpeml500003.china.huawei.com (7.188.49.51)
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 999A21C0015
X-Stat-Signature: kw8u6nihmfxu7q3ua6fqxuyh3wn9ufcp
X-HE-Tag: 1773159937-64157
X-HE-Meta: U2FsdGVkX19DpyHz8Fgli9HPiTf8Prb+b26v1Qts9uDH0hzdGlnKvFkrFfePjz3TDZ7S1dFPmy3UWJ08zmNHOqA2idVLxkje4KKjZ2MbBa1nM3RMa900X8Qf9ulnF8xY0S7yQzju8cTBkrbbK41F/RTsmmxXZsydOzqzJWaiaGaJ6J8ip97tC4s3dIf6Lqc50PIRMxvavjX1ufo7Q8A977s370tWR5wdCcGGGPsQ9JI+/VIcK/Z0wlZRgxW2JJ+i2lHvpgwPYCPiV4RixhHECkq/ak+qH8S4DjKPBuGA4W5/UxvNggRxq9Zwn8VNwkwvpHKlX3D8FuS2Aqpv0/K903BAE2jr497/vHCHHQfIc9nR84PkqHAc/Ukalruy6iqIVlYViF1f7LTc2eN0/8EdzbRT0ilQmsQ0O8yI4/M9WN7BIoibSVSv4VhDpwdSw78EEg814zosoFxlOhsSNfG1cAjz0YxwzS6Jmggb2pERRcrTnzpH4j9ac3R4TsKJiUmzhE3v1YgN0PvAOKuVon8AWZ4Nbbc54mTYrF+W5viY8oKWCXpbuiBi/xRTm7ySSiLS/R88ysQCCziDf77m3p3TgHt4q21GqkstGrAJMzJmXejrdz1t3LRS6TY+InGC2EONUQ+C3b5zUh8PHaWuB64fSchNPo0IijNgdwlO0Rr6a7TCMOty9dJdtAxRPVjZU93omyvYEjQe6C2GYhvr8Ig1ENLHF5e4K4f7g4J+EkCIgnwRZLlI+TY0Ots2CCVhACREY3sQlrrA3cuC5PZYvjzkSR7FEb0tfIzlJU6D0XhD3XnLem/AetUAOfLg8IuGlPS8J10FOfajoepyhZC4EWgyPOGJPTeYm6vjI588OEQZ0X4d5ET0lbZu61qCbqGAJlWFvEKsH257IeHVyTqWtJVr93R3lsE/Z15Ef+ZXBBl1qJ9PQnxBEKLz9TqOEyQK/1yXHF+/ufkb3mLzxYG96Mf
 q0DJkK7G
 HdWe1ihvAsJqmxCOegeQqch0lp5YDxekFZ7uv0kxgjaKH7grijqyHrkCmz280A4KNpq5melNjpzQJrY6GPDvb6QoOtrPqNdGXRssfU0yOQ0DfvogfxH7SI/iB6HAJaInrGdNdVH9/jNenWmRd4dFov085bd4Zoy6TBu2nixSxA4uhXxI5AX85OBBnzI7pGhKNPQ2A0B5mQrt2apFOm5poCPBJEBleaF2B0Yav4i3tAuL0YAk02nI5DGPYTLB7Q1+RzKqDi928lFJ13Un9suLRM/sP2dxhbc0Ur8myLHhcSPD3UH6QLqT5r2ybv6QxRM89CwS6uf1NjMFZ2ZU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Asier Gutierrez <gutierrez.asier@huawei-partners.com>

Documentation for hugepage DAMON module.

Signed-off-by: Asier Gutierrez <gutierrez.asier@huawei-partners.com>
Co-developed-by: Anatoly Stepanov <stepanov.anatoly@huawei.com>
---
 .../admin-guide/mm/damon/hugepage.rst (new)   | 186 ++++++++++++++++++
 1 file changed, 186 insertions(+)

diff --git a/Documentation/admin-guide/mm/damon/hugepage.rst b/Documentation/admin-guide/mm/damon/hugepage.rst
new file mode 100644
index 000000000000..a7b20a670824
--- /dev/null
+++ b/Documentation/admin-guide/mm/damon/hugepage.rst
@@ -0,0 +1,186 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+=========================================
+DAMON-based Huge Pages Collapsing
+=========================================
+
+
+DAMON-based dynamic hugepages collapsing (DAMON_HOT_HUGEPAGE) is a kernel module
+that monitors a number of tasks simultaneously. The hot regions are collapsed
+into huge pages.
+
+Where Hot Region Huge Pages Collapsing is Required?
+================================================
+
+As main memory availability increases, the number of TLB entries does not
+increase proportionally. This adds more pressure to TLB. Huge pages are a
+solution. However, since turning on transparent huge pages globally may lead to
+fragmentation and memory waste, it is usually turned off.
+
+This module allows to automatically detect hot regions and collapse VMA that are
+hot.
+
+How It Works?
+=============
+
+DAMON_HOT_HUGEPAGE spawns a new kthread which will monitor the applications in
+the system. The monitor thread will calculate the moving average of the sum of
+utimes of all the threads for all the processes. Then, pick the top three and
+launch a damon process to monitor the hot regions in those tasks.
+
+Since we don't know the minaccess number in advance, we set it to 90 initially,
+and we keep decreasing that minaccess until a collapse happens.
+
+If a task turns cold, the monitor thread will detect it (it will not fall in the
+top three hot tasks), and stop the damon thread for that task.
+
+Interface: Module Parameters
+============================
+
+To use this feature, you should first ensure your system is running on a kernel
+that is built with CONFIG_DAMON_HOT_HUGEPAGE=y.
+
+To let sysadmins enable or disable it and tune for the given system,
+DAMON_HOT_HUGEPAGE utilizes module parameters. That is, you can put
+damon_dynamic_hotpages.<parameter>=<value> on the kernel boot command line or
+write proper values to /sys/module/damon_dynamic_hotpages/parameters/<parameter>
+files.
+
+Below are the description of each parameter.
+
+enabled
+-------
+
+Enable or disable DAMON_HOT_HUGEPAGE.
+
+You can enable DAMON_HOT_HUGEPAGE by setting the value of this parameter as Y.
+Setting it as N disables DAMON_HOT_HUGEPAGE. Note that, although
+DAMON_HOT_HUGEPAGE monitors the system and starts damon threads, those threads
+could do no real monitoring due to the watermarks-based activation condition.
+Refer to below descriptions for the watermarks parameter for this.
+
+quota_ms
+--------
+
+Limit of time for collapsing memory regions in milliseconds.
+
+DAMON_HOT_HUGEPAGE tries to use only up to this time within a time window
+(quota_reset_interval_ms) for trying memory collapse. This can be used for
+limiting CPU consumption of DAMONHOT_HUGEPAGE. If the value is zero, the limit
+is disabled.
+
+10 ms by default.
+
+quota_reset_interval_ms
+-----------------------
+
+The time quota charge reset interval in milliseconds.
+
+The charge reset interval for the quota of time (quota_ms). That is,
+DAMON_HOT_HUGEPAGE does not collapse memory for more than quota_ms milliseconds
+or quotasz bytes within quota_reset_interval_ms milliseconds.
+
+1 second by default.
+
+wmarks_interval
+---------------
+
+The watermarks check time interval in microseconds.
+
+Minimal time to wait before checking the watermarks, when DAMON_HOT_HUGEPAGE is
+enabled but inactive due to its watermarks rule. 5 seconds by default.
+
+wmarks_high
+-----------
+
+Free memory rate (per thousand) for the high watermark.
+
+If free memory of the system in bytes per thousand bytes is higher than this,
+DAMON_HOT_HUGEPAGE becomes inactive, so it does nothing but periodically checks
+the watermarks. 200 (20%) by default.
+
+wmarks_mid
+----------
+
+Free memory rate (per thousand) for the middle watermark.
+
+If free memory of the system in bytes per thousand bytes is between this and the
+low watermark, DAMON_HOT_HUGEPAGE becomes active, so starts the monitoring and
+the memory collapsing. 150 (15%) by default.
+
+wmarks_low
+----------
+
+Free memory rate (per thousand) for the low watermark.
+
+If free memory of the system in bytes per thousand bytes is lower than this,
+DAMON_HOT_HUGEPAGE becomes inactive, so it does nothing but periodically checks
+the watermarks. 50 (5%) by default.
+
+sample_interval
+---------------
+
+Sampling interval for the monitoring in microseconds.
+
+The sampling interval of DAMON for the cold memory monitoring. Please refer to
+the DAMON documentation (:doc:usage) for more detail. 5ms by default.
+
+aggr_interval
+-------------
+
+Aggregation interval for the monitoring in microseconds.
+
+The aggregation interval of DAMON for the cold memory monitoring. Please refer
+to the DAMON documentation (:doc:usage) for more detail. 100ms by default.
+
+min_nr_regions
+--------------
+
+Minimum number of monitoring regions.
+
+The minimal number of monitoring regions of DAMON for the cold memory
+monitoring. This can be used to set lower-bound of the monitoring quality. But,
+setting this too high could result in increased monitoring overhead. Please
+refer to the DAMON documentation (:doc:usage) for more detail. 10 by default.
+
+max_nr_regions
+--------------
+
+Maximum number of monitoring regions.
+
+The maximum number of monitoring regions of DAMON for the cold memory
+monitoring. This can be used to set upper-bound of the monitoring overhead.
+However, setting this too low could result in bad monitoring quality. Please
+refer to the DAMON documentation (:doc:usage) for more detail. 1000 by defaults.
+
+monitored_pids
+--------------
+
+List of the tasks that are being actively monitored by DAMON threads.
+
+commit_inputs
+-------------
+
+Make DAMON_HOT_HUGEPAGE reads the input parameters again, except ``enabled``.
+
+Input parameters that updated while DAMON_HOT_HUGEPAGE is running are not
+applied by default. Once this parameter is set as ``Y``, DAMON_HOT_HUGEPAGE
+reads values of parametrs except ``enabled`` again. Once the re-reading is done,
+this parameter is set as ``N``.  If invalid parameters are found while the
+re-reading, DAMON_HOT_HUGEPAGE will be disabled.
+
+Example
+=======
+Below runtime example commands make DAMON_HOT_HUGEPAGE to find memory regions in
+the 3 tasks. It also asks DAMON_HOT_HUGEPAGE to do nothing if the system's free
+memory rate is more than 50%, but start the real works if it becomes lower than
+40%.
+
+    # cd /sys/module/damon_dynamic_hotpages/parameters/
+    # echo 3811,10123,12111 > monitored_pids
+    # echo 10 > quota_ms
+    # echo 1000 > quota_reset_interval_ms
+    # echo 500 > wmarks_high
+    # echo 400 > wmarks_mid
+    # echo 200 > wmarks_low
+    # echo Y > enabled
\ No newline at end of file
-- 
2.43.0


