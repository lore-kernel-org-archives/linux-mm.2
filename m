Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 825D4C4453A
	for <linux-mm@archiver.kernel.org>; Wed, 22 Jul 2026 21:15:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 20BDC6B00A4; Wed, 22 Jul 2026 17:15:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1BC9D6B00A7; Wed, 22 Jul 2026 17:15:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0D55F6B00A9; Wed, 22 Jul 2026 17:15:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C06126B00A4
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 17:15:24 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 2253C402E9
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 21:15:23 +0000 (UTC)
X-FDA: 85017668526.13.0D50D12
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com [209.85.214.197])
	by imf10.hostedemail.com (Postfix) with ESMTP id 70487C0002
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 21:15:21 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=mSYlxCXy;
	spf=pass (imf10.hostedemail.com: domain of 35zJhagcKCCwXZIbUITOWWOTM.KWUTQVcf-UUSdIKS.WZO@flex--pratmal.bounces.google.com designates 209.85.214.197 as permitted sender) smtp.mailfrom=35zJhagcKCCwXZIbUITOWWOTM.KWUTQVcf-UUSdIKS.WZO@flex--pratmal.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784754921;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=gbj5OI5PlzQDQcxOYA0/WolD08NrjVoBr7kUzAyBAz0=;
	b=bu6gxhqBNcH48uy/1s0tBr7eFtutGzYqxrTsNa+Fe23/zNfFk5avzKIT2AP7/bXhaf5ylr
	LqHhOf9FRs++jHPy/dVcy1NRVZvUd4UB7zyqJHOi4WdF6InsgkCtZhla7hiDHcZYZcq8pr
	C+EpvpVmsDfJE2TgHUVna3LxHVutRqI=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=mSYlxCXy;
	spf=pass (imf10.hostedemail.com: domain of 35zJhagcKCCwXZIbUITOWWOTM.KWUTQVcf-UUSdIKS.WZO@flex--pratmal.bounces.google.com designates 209.85.214.197 as permitted sender) smtp.mailfrom=35zJhagcKCCwXZIbUITOWWOTM.KWUTQVcf-UUSdIKS.WZO@flex--pratmal.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784754921;
	b=eg8GhNs5KttiANHpM10GBFXFvogMRCzcYLhKkE3rg3G5BGpVJpln5r6jgkzXSogCVDxA50
	GGGhcuZr3aNYf+2n7e9OXTosq2Crq/OkUErUjSu+knexOXLLXa+BIN8uK5oNmoU0fWTxYh
	erZvtJzSPNkUZ47MpkN9h3m0WYxWOX0=
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-2c7f385887bso313937455ad.0
        for <linux-mm@kvack.org>; Wed, 22 Jul 2026 14:15:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1784754920; x=1785359720; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=gbj5OI5PlzQDQcxOYA0/WolD08NrjVoBr7kUzAyBAz0=;
        b=mSYlxCXy/vHPT5osjznvYnHM1T0fNEKryhqp77T4sLqZMI0140q8AkM8/pBxeXkHpr
         OhQ2Oxh2c+9lZ5lEtqLYKtpzpdi84o/cHe4RFHxX05PdOvK3cojNx9ioUKBpX3x0P8GT
         GKRz/Egpef7TzAypsKThxQrPUWphWQus0zrH/LRqoeSn/5hN6PE91kL9vCyWcp1PJZQC
         VRzqLaWE7tTdCHuXkDW74bBbsF4XRlLkXt3xgHvp4voIQns45/obMTUzTS9Hlq/KCGP7
         nan3CyHQ7b4moQTCezN2GwHAAunAFVf3dQTC6IP9ZCPtH4+qicVFgGEwze2rJaXyOt6G
         TkWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784754920; x=1785359720;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=gbj5OI5PlzQDQcxOYA0/WolD08NrjVoBr7kUzAyBAz0=;
        b=XRIxixzjbP3ZJvxKM3PBda/Og0rwl4SFEId4yySOZClJajOI3pFnslG/pz8gRqvuh/
         qv3SVfpv4TCG7xM463dYYdcqYbZmgLAeohcTikKbZ7NfrM1GcA08j5yzO8N7wtGiEUrY
         hAP6ivRffh9MxouY5C1Tg20+JQSfesnz7itWBeAlQwYSgrCXIpVzlERV4jr0dZ6HXnv9
         G634Bxu//tUO6lDHW7RjW9PNIsx6YGuM5SOmHubvPqQZbi9hZrlF/nJczsVwp1sehzoc
         97xtZwZarPSeqvJR+WdWEaMllaPt8Ti4sX+6lQ+pEU0eycOpNRC/QFT8w55ZABZu6KIO
         rGWg==
X-Forwarded-Encrypted: i=1; AHgh+RqMs/wEigpWkXawYS8kWPnBwQ0pQgWk1x2saNonUwHpg5c80vQOb6oN1615xa4gNNsreTHTQcvNow==@kvack.org
X-Gm-Message-State: AOJu0YwAqRKhhvtK0fAMVJdiubALIbUL066lxU9Al/L7c/03TUK+o9hh
	aQ6nFWueb+Av3gLYrauFlZA+V73qee55iA5aSigQPpnhYN8TuQ3/0I7Ccl9inNtDq5IlyUanC8r
	IXUF021JE6Q==
X-Received: from dybb28.prod.google.com ([2002:a05:693c:609c:b0:30f:26b4:89f6])
 (user=pratmal job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:f544:b0:2cc:7c36:2c23
 with SMTP id d9443c01a7336-2cfa6f8eee1mr5312055ad.43.1784754919719; Wed, 22
 Jul 2026 14:15:19 -0700 (PDT)
Date: Wed, 22 Jul 2026 21:15:17 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.55.0.229.g6434b31f56-goog
Message-ID: <20260722211517.1898228-1-pratmal@google.com>
Subject: [PATCH v2] mm/page_reporting: Add page_reporting_delay_ms sysctl
From: pratmal@google.com
To: Anshuman Khandual <anshuman.khandual@arm.com>, David Hildenbrand <david@redhat.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Vlastimil Babka <vbabka@kernel.org>
Cc: Greg Thelen <gthelen@google.com>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Brendan Jackman <jackmanb@google.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Pratyush Mallick <pratmal@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 70487C0002
X-Rspam-User: 
X-Stat-Signature: 41fwdgo7zi7sccmojp3hbr5ozk5a9ybj
X-Rspamd-Server: rspam04
X-HE-Tag: 1784754921-29379
X-HE-Meta: U2FsdGVkX18HgKcqaJP6HFYui92vbDvMOr+L/1zvz1r71WnklbXKHrvMONbYCm6tKlUDhy1lydbXo9dagfp0/21UrCTMP3m9tl3hV760LJPtoy0X8UJ37R/S98nJSFQVAXcb+TIVmoGDF75XmJPAMbwBvy2DrTPSSnSi4LKIin5mwFIDY39H/Hw5rswiGU83He1UD8B+J+xuSdohZu48SYwvPAFSVaGnM/KIWmo0R4Fsnv4z+DMctTzvF0OPhRpizWQzyk139Q0gfnphAChfpFthtm2r+J1Y7n1/liK+HP5GNbmWtB8d5hbZR7zNqxWvlhvswU1JGfqtQVphbc+Y3kf0PLIOw0RcYjwxRR+z/mq71+dZKDcFoux/szOnLiCohIfIZbDULMdUWB8q3csH7l5QW9imssi5eQGW8nMJqMIl3/II7DJ9h4uvghVlM5OmEPSJpWlOzc20HasDb82W671Ny3E4wFRgUrodSyEHzeQ4qbF6vxtLCSeXYn4apRTr47z5NF4ac0TrZVP/TvsZ/kTJ7SwbpOvuAIEBwpJCd/xbvH2xZgQCxCiq6WHQxWkGG30M0Auk9gd2m3v25h7Wa1o+wnjJjMbseF7T6m4z1vl+YJM7Spqf6VJF6shQSjVvv6+uoAjSEnSbEtPhbEA95rC/DXv+sXbyBgfTi+tbsz42Rl/gThhJseNSGsSAe9M3Wp4Yh0kyFdlJ1a1N8WsszMKLMpB3pBEVcDtVRTSQPTSk4Ysu0bFvciBCEosWSYSI4eHtRoAPcm2zM4VdIcSzmz6rebatzOwEfidRkFKl0RNUibfRXVxlqY7vK2r8+cGRac/AFNvACZnfCK+SZGEdIrXp/tO1FFPCYwaKywCGBxpTP8wce6x+6frD8epJFwNJng7ZIRf0z4FzXD1UYbi4U9OFM8XnU7Qv/HOQAvhiDDLlsd/vX22s3ARZMjNle/1hWMx+8E0DmGUrJPwVSZ3
 8GDUBII8
 ZGVEONJ0xRSy51b2Fm0mM6TaRTNVW9FGsb0eivFSOfTCTT+4JmGYM7PkC6Gr48KGwJubJN13wpiGPeQPxj9vYnpKkcfqgrePzEKY7YKewlczNa9McSpjAv1wpHiAEi9H2wl1blbQjr+20UytHXnrV5DJmubTFJAzOISexx2iQUZlD3vgDzaIdZslwf3KLl2AycIc+he33MyVah4Ou9NbP15BlhqNNXQU4WRCtvhJXId5R3A2fCByrnejTqle/OV4cH1TAkZNdTPjwLV6evnHMJZ9hkMHWZHJNPJdNAdIZ1SrfGOaSG9QK6Xq4putxNoSmdI3BqR4qse0iDHWjnc3JUetkCkCf7vmb4CkcpCiONd+ZCqyw1WPYU1D9GH9Ttr5e1qsnZKAAneMB5t4ytTo+1zZSZN9rcWWCYtCyY6WMNxHWr/ve+RkTAJMOx6xtHSGlG2eQxeqnRPbbHn9z7V4AkkB4w42qxkSVxXvCbckWpZFvebExtg5o5EO57MxxDpq/5bNAv2ECMz+JCqmM679dTNLi3YJUDjG4iIYVa3dawgdKyqBDmtdX3p3K5G7vfz2lWku0DGJVbDQ6qnFzyDeWI+B5qsZTP794iCWMq+L3ex5b9JvfuSe6v5uVf9bAKQ331mWKM6Q5oPgvH+KbOPCjq3J/qw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Pratyush Mallick <pratmal@google.com>

Currently, the free page reporting daemon uses a hardcoded delay of
(2 HZ) between reporting intervals. While this is a reasonable
default, it lacks the flexibility to adapt to varying guest workloads.

A low delay allows aggressive memory reclamation, returning unused
pages to the host as quickly as possible. However, during spiky
allocation/free churn, this immediate reporting can lead to a severe
performance penalty (nested page faults) as the guest re-allocates memory
that the host has just unmapped. In these scenarios, there is benefit
from increasing the delay to batch free pages over a longer window,
absorbing the churn without hypercall and re-fault overhead.

This patch refactors the delay into a dynamically tunable sysctl,
/proc/sys/vm/page_reporting_delay_ms, measured in milliseconds. The value
defaults to 2000ms to precisely match the original (2 HZ) behavior.

Signed-off-by: Pratyush Mallick <pratmal@google.com>
---
v2:
 - Documented page_reporting_delay_ms in Documentation/admin-guide/sysctl/vm.rst.
 - v1: https://lore.kernel.org/linux-mm/20260722192935.1646848-1-pratmal@google.com/T/#u
v1: Fixed feedback from RFC.
 - Added lower and upper cap to sysctl value.
 - Reverted the reordering on page_reporting_delay_ms.
 - Dropped the mod_delayed_work() change.
 - RFC: https://lore.kernel.org/linux-mm/20260714171456.2350037-1-pratmal@google.com/T/#u
 Documentation/admin-guide/sysctl/vm.rst | 13 +++++++++++
 mm/page_reporting.c                     | 30 ++++++++++++++++++++++---
 2 files changed, 40 insertions(+), 3 deletions(-)

diff --git a/Documentation/admin-guide/sysctl/vm.rst b/Documentation/admin-guide/sysctl/vm.rst
index b9b0c218bfb4..6efa460b4547 100644
--- a/Documentation/admin-guide/sysctl/vm.rst
+++ b/Documentation/admin-guide/sysctl/vm.rst
@@ -66,6 +66,7 @@ Currently, these files are in /proc/sys/vm:
 - overcommit_ratio
 - page-cluster
 - page_lock_unfairness
+- page_reporting_delay
 - panic_on_oom
 - percpu_pagelist_high_fraction
 - stat_interval
@@ -896,6 +897,18 @@ stolen from under a waiter. After the lock is stolen the number of times
 specified in this file (default is 5), the "fair lock handoff" semantics
 will apply, and the waiter will only be awakened if the lock can be taken.
 
+page_reporting_delay
+=======================
+
+This value determines the delay in milliseconds between free page
+reporting intervals. A lower delay allows aggressive memory
+reclamation by returning unused pages to the host quickly, while a
+higher delay helps to batch free pages over a longer window, absorbing
+allocation/free churn without hypercall and re-fault overhead.
+
+The default value is 2000 (2 seconds). The minimum allowed value is
+0 (immediate reporting) and the maximum allowed value is 10000 (10 seconds).
+
 panic_on_oom
 ============
 
diff --git a/mm/page_reporting.c b/mm/page_reporting.c
index 942e84b6908a..805da4bc1101 100644
--- a/mm/page_reporting.c
+++ b/mm/page_reporting.c
@@ -6,6 +6,7 @@
 #include <linux/export.h>
 #include <linux/module.h>
 #include <linux/delay.h>
+#include <linux/sysctl.h>
 #include <linux/scatterlist.h>
 
 #include "page_reporting.h"
@@ -47,7 +48,10 @@ MODULE_PARM_DESC(page_reporting_order, "Set page reporting order");
  */
 EXPORT_SYMBOL_GPL(page_reporting_order);
 
-#define PAGE_REPORTING_DELAY	(2 * HZ)
+#define PAGE_REPORTING_DELAY_MS_MAX	(10 * MSEC_PER_SEC)
+
+static unsigned int page_reporting_delay_ms = 2 * MSEC_PER_SEC;
+static unsigned int page_reporting_delay_ms_max = PAGE_REPORTING_DELAY_MS_MAX;
 static struct page_reporting_dev_info __rcu *pr_dev_info __read_mostly;
 
 enum {
@@ -56,6 +60,19 @@ enum {
 	PAGE_REPORTING_ACTIVE
 };
 
+
+static struct ctl_table page_reporting_sysctls[] = {
+	{
+		.procname	= "page_reporting_delay",
+		.data		= &page_reporting_delay_ms,
+		.maxlen		= sizeof(unsigned int),
+		.mode		= 0644,
+		.proc_handler	= proc_douintvec_minmax,
+		.extra1		= SYSCTL_ZERO,
+		.extra2		= &page_reporting_delay_ms_max,
+	},
+};
+
 /* request page reporting */
 static void
 __page_reporting_request(struct page_reporting_dev_info *prdev)
@@ -80,7 +97,7 @@ __page_reporting_request(struct page_reporting_dev_info *prdev)
 	 * now we are limiting this to running no more than once every
 	 * couple of seconds.
 	 */
-	schedule_delayed_work(&prdev->work, PAGE_REPORTING_DELAY);
+	schedule_delayed_work(&prdev->work, msecs_to_jiffies(page_reporting_delay_ms));
 }
 
 /* notify prdev of free page reporting request */
@@ -340,7 +357,7 @@ static void page_reporting_process(struct work_struct *work)
 	 */
 	state = atomic_cmpxchg(&prdev->state, state, PAGE_REPORTING_IDLE);
 	if (state == PAGE_REPORTING_REQUESTED)
-		schedule_delayed_work(&prdev->work, PAGE_REPORTING_DELAY);
+		schedule_delayed_work(&prdev->work, msecs_to_jiffies(page_reporting_delay_ms));
 }
 
 static DEFINE_MUTEX(page_reporting_mutex);
@@ -416,3 +433,10 @@ void page_reporting_unregister(struct page_reporting_dev_info *prdev)
 	mutex_unlock(&page_reporting_mutex);
 }
 EXPORT_SYMBOL_GPL(page_reporting_unregister);
+
+static int __init page_reporting_sysctl_init(void)
+{
+	register_sysctl_init("vm", page_reporting_sysctls);
+	return 0;
+}
+late_initcall(page_reporting_sysctl_init);
-- 
2.55.0.229.g6434b31f56-goog


