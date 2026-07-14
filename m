Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F16F1C4450A
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 17:15:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9907A6B00BA; Tue, 14 Jul 2026 13:15:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 940F66B00BD; Tue, 14 Jul 2026 13:15:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8303E6B00BE; Tue, 14 Jul 2026 13:15:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 488606B00BA
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 13:15:16 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id CB7FD140415
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 17:15:15 +0000 (UTC)
X-FDA: 84988032990.21.B58B462
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	by imf28.hostedemail.com (Postfix) with ESMTP id 2FF90C0003
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 17:15:14 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="uq60Fh4/";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf28.hostedemail.com: domain of 3n25WagcKCDAbdMfYMXSaaSXQ.OaYXUZgj-YYWhMOW.adS@flex--pratmal.bounces.google.com designates 209.85.215.201 as permitted sender) smtp.mailfrom=3n25WagcKCDAbdMfYMXSaaSXQ.OaYXUZgj-YYWhMOW.adS@flex--pratmal.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784049314;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=HQl/YhNIycgwR9ahJpRcbgcx4L53MFsyko1Sj3ozvDU=;
	b=wlNLufFwC2s0G53/MBoVEGv9Fj6vktqzmBaJEx2739+GRUIUfSLgDJft+Vh1RIyZNN0D5O
	FhtjYbY1GJ6fhwS7OsJKnlMRLRWKWm9yxT/h1z73X3qLuP6at7y99PKRcozAyZN4NL0vl6
	ffVpAt2vfH+95/sDO5YOu3B9e2eWHp0=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="uq60Fh4/";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf28.hostedemail.com: domain of 3n25WagcKCDAbdMfYMXSaaSXQ.OaYXUZgj-YYWhMOW.adS@flex--pratmal.bounces.google.com designates 209.85.215.201 as permitted sender) smtp.mailfrom=3n25WagcKCDAbdMfYMXSaaSXQ.OaYXUZgj-YYWhMOW.adS@flex--pratmal.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784049314;
	b=OK6/CdIeHDNUgcuG6MvUIVFWXE/GnrZaTnJODGvgr7qw+TcIDP7nOeZlfyRDuNfDZYzKGN
	WC04gD7AchJy+Om2AocviqizZq5J98JwHKDg9A51snYNvRluzw85MrYvukO+hD4aU7OA5y
	RIWWbqtM6Ey3QOJCJzBnfYQpwtjEuos=
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-caf5fa127d4so1800100a12.0
        for <linux-mm@kvack.org>; Tue, 14 Jul 2026 10:15:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1784049313; x=1784654113; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=HQl/YhNIycgwR9ahJpRcbgcx4L53MFsyko1Sj3ozvDU=;
        b=uq60Fh4/OoHDTMNI1fFp4HVtzq23lvz3fC7aLefKBGTyCBrIduuvY/xKH4cGvo6M3D
         CRMTFzpoRDobjZ8WTIDbGViaMJ5Vbh3HceYB+GtDJs/U4im/rO3KGMgJqLWL0lWKF8+m
         d1uiq4XSh3J15jryg4lG3MBvu7RMaj5GZ2Up6gsnbDq0kshuFl3CkIjOg9Xleg04mRd0
         0gxI4DD3PanvKg2T9/xsZ5W9LXUjvz1Mh7blqS+2j8OCWICASpBcg/n6o3Lxro8mqc0x
         oRvii4UCwx9lIAnu0RhNksQDqw0WnWjee2XqsjERfOHwasOpnzXmMb3B7MtjVUQK47u1
         K73Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784049313; x=1784654113;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=HQl/YhNIycgwR9ahJpRcbgcx4L53MFsyko1Sj3ozvDU=;
        b=PSAuIcWwEBGi7oIMfU7WJStsr0HX+UKMyVMahEgcor3lZQA8Klc1STBwnk3StQHyF/
         z+jc12GISAV3B+GBqyxdDhOIo/xwQNunbNakbyfTAhGYYoyS+dmgXGGuYmRpqL0vzx1P
         rNOnBNlBTj8tA+JJ5lETBcaJyLjVQMdE8hSmR8trZ/crYxIFDE9500C3j75/Zm3eKrEH
         D+QV58DRBMibIYNapRUfMEaYv8w1jQfRKrj4I8rAM0gh5tXu5rCzQebj475fGyTqp86K
         cgP7TPC/fBtlLifVB9YgmDkVtpZU1McKjEgETckckzUFGCxVVudoNCl9tKql0h5PXsqC
         dHZQ==
X-Forwarded-Encrypted: i=1; AHgh+RrlH8LqbszO0O+W1g7nxpDv6dm/HTkKcvy0JMu54x0pCA4H3nqYUzhEtYt4MM5Vxx5dJ5x8vYvvFA==@kvack.org
X-Gm-Message-State: AOJu0YzEQYKvv/XvfSAVsKeGDtSmPZhHAQUYGs+YxYhFxPrMJpEoha/X
	pVSI1BxqB/IA/viBQwCbp100qqSJqu4igjQ8LAsqACMxGiRfSdz8w74KHy8vIIBllPiz79nWlfY
	hvSCzzr2sbA==
X-Received: from dled1-n2.prod.google.com ([2002:a05:701b:42c1:20b0:13b:9e9c:c86a])
 (user=pratmal job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:3394:b0:3a8:21e0:1ffa
 with SMTP id adf61e73a8af0-3c110160cabmr18302925637.27.1784049311355; Tue, 14
 Jul 2026 10:15:11 -0700 (PDT)
Date: Tue, 14 Jul 2026 17:14:55 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.55.0.141.g00534a21ce-goog
Message-ID: <20260714171456.2350037-1-pratmal@google.com>
Subject: [RFC PATCH] mm/page_reporting: Add page_reporting_delay sysctl
From: pratmal@google.com
To: Andrew Morton <akpm@linux-foundation.org>, Vlastimil Babka <vbabka@kernel.org>
Cc: David Hildenbrand <david@kernel.org>, Greg Thelen <gthelen@google.com>, 
	Pratyush Mallick <pratmal@google.com>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: 6b9rnk1n1psaw4ws746byd1podpp88kk
X-Rspamd-Queue-Id: 2FF90C0003
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-HE-Tag: 1784049314-616119
X-HE-Meta: U2FsdGVkX1+qo5KZ6lF6hpng2uA8BtozUsxJwFauFq9ProWv+rs58wUifHovE22Lv36tQ+EpLWqpduncL5BQslxZeUA7/a1Ki/8X6/zRH+hhm0Nw1F8fXYXf8SwuGgrncqIhI2uWGUqS0FHydAUBxOK0+47FAgjzbvUU1pudmnzVdvHnDPH+4FYVDFqX/C8gKZK/4ykdW4Dk4TpP7n07tGTayE+27HQKCQiV1YhZJnT5DbrH+dTEb5twLP7yxnp3+uPodTFAPOox/qyfUk2qo460Z7S6kpvbxQIWhjfpUIrp2IxI3dvKTvHvuLs5ee/NeXoBrCBlfM/VSkVywzFt4JHax9QvIxk1lcVb1jCQ2RPCT5hJN3MgiefTPP3rlnJUjcRWbVncDvqZuOzKm1xAy73WLjsBT/w2ksMrPAYAl8I7ggHgqbH+Djf40lqr0aenzWQC2cbAuISMNUpPgrtjBioSrkuNOI9n6vsQcPJ2AfZYAmgCf94wqd7m1Mql9ud6C9ew2wvPAhRmxHhBE0984Nge7QCnPwhpe0TMoQqxGSbaVU0XMomY46bTV6XTrLKyzZwJ8s6BWPljTmZNikAYmHzsqZvuTW3wlaXBmPtojzIc5hVjhsgtUi4H6VcmBimCXuNm8wewVsLHRfzAoV1tSQxRod5eCPc8dRVrgoUWyRd5X9lGY3eShCCxyYASEp0384TnIDmyNwZ+51WE9O50aQkmXvuc/BGPyqCKeG018jlPQKB0n4wHRSJwNhwIW5uqH+nf/63sOI7JNCRw6/I9YQRF6Jw4NvCdN+QReGBwtmMvNhj3MrVMSflDPCJfSAkV5ZKV1xhL+x3sznlGInoF6ECiwPAvGR48F1G4XkHnblXRG7lQTrHmBjryV8BdSJ8ysQiu4o1cUKg/pdeldTEBNy/pNKjXlGBPvuNjw5rwfzK4sshkBJ2/o6ZIF5FX8DWN7vVtNwwDjHggNZZDyju
 FxvYuois
 xFzwkNR9/p/AuS+FU1+731O6BA4DbJ1wETQMltlFA74Nv0pFmY84gxEGZtIfV3QvP9N5LiaB7slJuLeeauGyWblBuu3k8Wfk+UGfPy6wbgxCDidwlOktQP3r8IoLx25TtBRF7KLn08BUky3xocNMgop9U4Wi0JB2L6sHJN0cScMWbluPumbiWXRGGflcS2ZJCfA9wjWkWNkmn4WrlzLYymu7O33f1OGJeVupIclvL+I6xOKPzoPmLwSICR4EIJ9ZF0DS3wOt0ry9i5Nd20XrgnPu20ms5MURc8GLs/ob5uI8UEx5GvD0yFeEL3R7Tsx/2CTm2x3waAJR2Npq4Zq4OnJnqgsigDsBpBmJcT0rHFya7QNa8NaOAlkmQD2cH7frAZ6bbBvKllFdD9eLBF8ApCH0dfOV6Sbe5OVytMICTdDcp1whRjRlSSx4D4EgBXIKYH8ZMsyG0gzMSlXaj/Z24q07P2zXKpoO+GV/2d2DIvM1I1SDMimOFFQR8hPvbR1BFxpN3MI+ttxTgOlAA6BTlJX4Bss8WLzHqJ0w+pak58oMWDiWT2Cz+FJoySzy0YYtPDYTVcr7uo98++duPW83FpnHyNb50auYHIsiVLi4OlrCmiB3WGZshrD+K4Kkzb0iEWa7OjRPFWYe+lmm4/KfM9JSyAD6WyM+8oCBidWag8MdqZT1PfBPBwYPQ0fRCko2m1EkXuTfsYWOh3TBQvis+zBkjbg==
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
pages to the hypervisor as quickly as possible. However, during spiky
allocation/free churn, this immediate reporting can lead to a severe
performance penalty (nested page faults) as the guest re-allocates memory
that the hypervisor has just unmapped. In these scenarios, there is benefit
from increasing the delay to batch free pages over a longer window,
absorbing the churn without hypercall and re-fault overhead.

This patch refactors the delay into a dynamically tunable sysctl,
/proc/sys/vm/page_reporting_delay, measured in milliseconds. The value
defaults to 2000ms to precisely match the original (2 HZ) behavior.
If the sysctl is modified across reporting windows, the sysctl handler
immediately issues a mod_delayed_work() to honor the new configuration
without waiting for the prior timeout to lapse.

Signed-off-by: Pratyush Mallick <pratmal@google.com>
---

Sending this as an RFC to get thoughts on exposing this delay as a sysctl. 
                                                                           
Benchmark Results:
We kill a process allocated with 10GB memory within the VM and mesure the
time it takes to report all the memory to host as well the delay in
initiating the reporting.
 
default(2s delay): https://drive.google.com/file/d/1Ouxm_raj4xPNthc_ryk0Mdbo-c_zXKiP/view?usp=sharing
Tuned to 0s delay: https://drive.google.com/file/d/1mk58LPiYgIF4Yk6kmX5JHplhrwIw0NbC/view?usp=sharing
                                                                           
The data shows (sysctl.vm.page_reporting_delay=0) that within ~2 seconds,
the guest reports ~10 GiB and the reporting is initiated as soon as 100ms. 
With the default 2s delay, it takes around ~7 sec to report the same and
initiation delay is around 2 sec.

 mm/page_reporting.c | 47 ++++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 42 insertions(+), 5 deletions(-)

diff --git a/mm/page_reporting.c b/mm/page_reporting.c
index f0042d5743af..6fde542cbe09 100644
--- a/mm/page_reporting.c
+++ b/mm/page_reporting.c
@@ -6,6 +6,7 @@
 #include <linux/export.h>
 #include <linux/module.h>
 #include <linux/delay.h>
+#include <linux/sysctl.h>
 #include <linux/scatterlist.h>
 
 #include "page_reporting.h"
@@ -47,15 +48,44 @@ MODULE_PARM_DESC(page_reporting_order, "Set page reporting order");
  */
 EXPORT_SYMBOL_GPL(page_reporting_order);
 
-#define PAGE_REPORTING_DELAY	(2 * HZ)
-static struct page_reporting_dev_info __rcu *pr_dev_info __read_mostly;
-
 enum {
 	PAGE_REPORTING_IDLE = 0,
 	PAGE_REPORTING_REQUESTED,
 	PAGE_REPORTING_ACTIVE
 };
 
+static unsigned int page_reporting_delay = 2000;
+static struct page_reporting_dev_info __rcu *pr_dev_info __read_mostly;
+
+static int page_reporting_delay_sysctl(const struct ctl_table *table, int write,
+				       void *buffer, size_t *lenp, loff_t *ppos)
+{
+	int ret;
+	struct page_reporting_dev_info *prdev;
+
+	ret = proc_dointvec(table, write, buffer, lenp, ppos);
+	if (ret < 0 || !write)
+		return ret;
+
+	rcu_read_lock();
+	prdev = rcu_dereference(pr_dev_info);
+	if (prdev && atomic_read(&prdev->state) == PAGE_REPORTING_REQUESTED)
+		mod_delayed_work(system_wq, &prdev->work, msecs_to_jiffies(page_reporting_delay));
+	rcu_read_unlock();
+
+	return 0;
+}
+
+static struct ctl_table page_reporting_sysctls[] = {
+	{
+		.procname	= "page_reporting_delay",
+		.data		= &page_reporting_delay,
+		.maxlen		= sizeof(unsigned int),
+		.mode		= 0644,
+		.proc_handler	= page_reporting_delay_sysctl,
+	},
+};
+
 /* request page reporting */
 static void
 __page_reporting_request(struct page_reporting_dev_info *prdev)
@@ -80,7 +110,7 @@ __page_reporting_request(struct page_reporting_dev_info *prdev)
 	 * now we are limiting this to running no more than once every
 	 * couple of seconds.
 	 */
-	schedule_delayed_work(&prdev->work, PAGE_REPORTING_DELAY);
+	schedule_delayed_work(&prdev->work, msecs_to_jiffies(page_reporting_delay));
 }
 
 /* notify prdev of free page reporting request */
@@ -343,7 +373,7 @@ static void page_reporting_process(struct work_struct *work)
 	 */
 	state = atomic_cmpxchg(&prdev->state, state, PAGE_REPORTING_IDLE);
 	if (state == PAGE_REPORTING_REQUESTED)
-		schedule_delayed_work(&prdev->work, PAGE_REPORTING_DELAY);
+		schedule_delayed_work(&prdev->work, msecs_to_jiffies(page_reporting_delay));
 }
 
 static DEFINE_MUTEX(page_reporting_mutex);
@@ -415,3 +445,10 @@ void page_reporting_unregister(struct page_reporting_dev_info *prdev)
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
2.55.0.141.g00534a21ce-goog


