Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A3AA0E7DEF0
	for <linux-mm@archiver.kernel.org>; Mon,  2 Feb 2026 14:57:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7EA366B00BA; Mon,  2 Feb 2026 09:57:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 78A4D6B00BD; Mon,  2 Feb 2026 09:57:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3FC356B00BE; Mon,  2 Feb 2026 09:57:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 0C2EA6B00BB
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 09:57:38 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B291D1AFF76
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 14:57:37 +0000 (UTC)
X-FDA: 84399820554.29.997E5CF
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	by imf28.hostedemail.com (Postfix) with ESMTP id 5F89CC000D
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 14:57:34 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei-partners.com;
	spf=pass (imf28.hostedemail.com: domain of gutierrez.asier@huawei-partners.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=gutierrez.asier@huawei-partners.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770044254;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RkvfrVIl2Ac8QKJHdgeUZa44MgcC/w2OXvtxCE7JHRA=;
	b=lYRoBp8HUKHTNJqyanfCukyF+9ePPq76e4B/ti3wyS1s2VoyXxIND+zXKkXG/lSXLWGGew
	TH6hC08Kt4SoX9QRyRzgv0cPP38z/1eoRuozltGAZTPdL5J0wLpa5YqMfKHonpMEexB4Lt
	9Ze9i5NkwJu1+hyhAz88Z603ekBQDEg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770044254; a=rsa-sha256;
	cv=none;
	b=Zw03tx8/yTfocMLlcJ2Svrj8u9P3rfLWly0r5KP+WH//gl/CSbZqa+yC7s8JXB79b1POdW
	eaohp4qrA8WEyAie1yIA80dR9GTq7E6mL9fp4AqntEyTKo2XmshKK5u1K+Peo2BPZvNQd2
	LU0eL7J9KdxPK7TfkjaBV7XQPfvlsmM=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei-partners.com;
	spf=pass (imf28.hostedemail.com: domain of gutierrez.asier@huawei-partners.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=gutierrez.asier@huawei-partners.com
Received: from mail.maildlp.com (unknown [172.18.224.150])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4f4V7g0ZwwzJ46cb;
	Mon,  2 Feb 2026 22:56:47 +0800 (CST)
Received: from mscpeml500003.china.huawei.com (unknown [7.188.49.51])
	by mail.maildlp.com (Postfix) with ESMTPS id EF3A740539;
	Mon,  2 Feb 2026 22:57:32 +0800 (CST)
Received: from mscphis01197.huawei.com (10.123.65.218) by
 mscpeml500003.china.huawei.com (7.188.49.51) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Mon, 2 Feb 2026 17:57:32 +0300
From: <gutierrez.asier@huawei-partners.com>
To: <gutierrez.asier@huawei-partners.com>, <artem.kuzin@huawei.com>,
	<stepanov.anatoly@huawei.com>, <wangkefeng.wang@huawei.com>,
	<yanquanmin1@huawei.com>, <zuoze1@huawei.com>, <sj@kernel.org>,
	<damon@lists.linux.dev>, <akpm@linux-foundation.org>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>
Subject: [RFC PATCH v1 4/4] documentation/mm/damon: Documentation for the dynamic_hugepages module
Date: Mon, 2 Feb 2026 14:56:49 +0000
Message-ID: <20260202145650.1795854-5-gutierrez.asier@huawei-partners.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260202145650.1795854-1-gutierrez.asier@huawei-partners.com>
References: <20260202145650.1795854-1-gutierrez.asier@huawei-partners.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.123.65.218]
X-ClientProxiedBy: mscpeml100003.china.huawei.com (10.199.174.67) To
 mscpeml500003.china.huawei.com (7.188.49.51)
X-Rspamd-Queue-Id: 5F89CC000D
X-Stat-Signature: 5p46n5yfu7iyg87hb9thdpjiyohpcw5m
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1770044254-219571
X-HE-Meta: U2FsdGVkX1+MLf7dJ7flBOik/AuOSiuEGy+UFBFUOfJIpLdrOqunOQzpoJ9mvsDcAbvs4Qm1gEn3P9I1yEKWKJG2e72rjSRnF45iciruQHVIEXxoow2/l2f+0yKjU+YNEGIN3LhoUtyQIKKRJ6JD9xWmDIzc+a5Ozx2dJZzVZITGZTZlCZLezvtdzQwPOeya/ISIt11+FPlvQtNhbJVw+qq2K6mWQOO4QG1ql2SF/zsjlYCejKMqSABicdbDw0mVvWcW7aJawg4f21MFVq+OXPaMxw/hIFaIvKAjcolnw5LnsAFfCGYg0UaXV6mgEzZSoGMKxbUkY8D6100UBHZIQV1CFZUJ3nX5n0jjkVJ1hNuRh+hOMxNx9b0z4SAoeFvw2/ok4nVT7yBAC17ZjWpssYqgZIIEMN4pdVyF663MLjmXBqjeMD9TYbgvKAfNA1TcVlJp1fuiE0pspr0c+Jq2Tw5XWT5T1SKCPDXjoL2S/0xI//S5uHMtFGJPNtdHhK6TZWZ0AqPqWVFx3FEAPEcXboIIsFe+rvssnybvsml3ts62dyVSIt6vViVK3Q7zVtEA2KYWAMQm+TVJk8FVKotnMxTqMR/kkmIWlSKIsnOW3ndwjEwRlWAg9BeAQozT85IPGpgjNzRw1TDie78M+v19edD/8WOMG8/sTP9ETR/ojDlZdnZfNfTVSVvXitIfZ8Eau4Fg7orowuJmqd7iPsGZp5djhHJE77kJaOX/bEGGhOr2Nt4CpSyfWXmFU8K7mqXQcdJKzTwIb8ZEjemG23hn3y2H36Mhl+gotSfXX6j11G2ucFp9duruRc0Lm226sPj60FahEY5hmplWMKv6MX1w2m4vKTsCjycvkHji21brGHTKT4N1rXixYn9SR+Zdtb2DDmfLiL9ed8z/xmr4cXgJgCw0iJq6mvZSgQE1rk6zB0Ab3vtr76mf5wMTzf9+n4eBDqz9MJ0FvUakF+nRbEK
 sxaiTBRh
 +mR3CpqEvYm2SpbKEvf87WTLjRRqt7hDqu/qtF1Rj2AhDU4X8Piwpw3J1il8b6/Ui6SVzodEllmjOP53t8p5sQcboCNUgGHCTRmzO7Kd+jPxfHAnrGUw78bPKzwtSnmGD35zzcq1okXrm5h95wVuKWVlRXnB0ZBOqQ0C1tv1AnTpjGd8clrlEdC6uqISWgFcjV+K2YpT4lce01cBjt95kUuHnZ2PuJOrQxpJ4f/Gq3LBba1UWPUd8v+Rk6Y7ghfWzyLbAkXMplBY1RKWbCc6j48c8+aRx/3G1BaSCg8BGeYF4Eik=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Asier Gutierrez <gutierrez.asier@huawei-partners.com>

Documentation for dynamic_hugepage DAMON module.

Signed-off-by: Asier Gutierrez <gutierrez.asier@huawei-partners.com>
Co-developed-by: Anatoly Stepanov <stepanov.anatoly@huawei.com>
---
 .../mm/damon/dynamic_hugepages.rst (new)      | 173 ++++++++++++++++++
 1 file changed, 173 insertions(+)

diff --git a/Documentation/admin-guide/mm/damon/dynamic_hugepages.rst b/Documentation/admin-guide/mm/damon/dynamic_hugepages.rst
new file mode 100644
index 000000000000..a6afb0910661
--- /dev/null
+++ b/Documentation/admin-guide/mm/damon/dynamic_hugepages.rst
@@ -0,0 +1,173 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+=========================================
+DAMON-based Dynamic Huge Pages Collapsing
+=========================================
+
+
+DAMON-based dynamic hugepages collapsing (DAMON_HOT_HUGEPAGE) is a kernel module
+that monitors the system and picks the 3 most active tasks. Then, it starts a
+new DAMON thread for each of those 3 tasks, which will collapse hot regions into
+huge pages.
+
+Where Dynamic Huge Pages Collapsing is Required?
+================================================
+
+As main memory availability increases, the number of TLB entries does not
+increase proportionally. This adds more pressure to TLB. Huge pages are a
+solution. However, since turning on transparent huge pages globally may lead to
+fragmentation and memory waste, it is usually turned off.
+
+This module allows to automatically detect hot applications and collapse VMA
+that are hot.
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
+monitored_pids The PIDs of the tasks that are being actively monitored by DAMON
+threads
+
+Example
+=======
+Below runtime example commands make DAMON_HOT_HUGEPAGE to find memory regions in
+the 3 most active tasks. It also asks DAMON_HOT_HUGEPAGE to do nothing if the
+system's free memory rate is more than 50%, but start the real works if it
+becomes lower than 40%.
+
+    # cd /sys/module/damon_dynamic_hotpages/parameters/
+    # echo 10 > quota_ms
+    # echo 1000 > quota_reset_interval_ms
+    # echo 500 > wmarks_high
+    # echo 400 > wmarks_mid
+    # echo 200 > wmarks_low
+    # echo Y > enabled
\ No newline at end of file
-- 
2.43.0


