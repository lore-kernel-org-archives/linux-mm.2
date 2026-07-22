Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 172E2C44536
	for <linux-mm@archiver.kernel.org>; Wed, 22 Jul 2026 19:29:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D7A626B00C0; Wed, 22 Jul 2026 15:29:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D29CE6B00C1; Wed, 22 Jul 2026 15:29:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C400D6B00C2; Wed, 22 Jul 2026 15:29:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 97E016B00C0
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 15:29:45 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 2774A1602D2
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 19:29:45 +0000 (UTC)
X-FDA: 85017402330.27.1F9FCD9
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com [209.85.215.197])
	by imf23.hostedemail.com (Postfix) with ESMTP id 8614914000E
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 19:29:43 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=mPHXug+N;
	spf=pass (imf23.hostedemail.com: domain of 3JhphagcKCDkkmVohVgbjjbgZ.Xjhgdips-hhfqVXf.jmb@flex--pratmal.bounces.google.com designates 209.85.215.197 as permitted sender) smtp.mailfrom=3JhphagcKCDkkmVohVgbjjbgZ.Xjhgdips-hhfqVXf.jmb@flex--pratmal.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784748583;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=KLXoX1ivD/mB2jEq+v6b3gqtvL3+A1iZJXkH/v2MOCg=;
	b=BOOVBS51KZUIArxPdR90JbjEdaJOgwuSOWhMgiFe2eKk3kFEmpq3uuVD8C90DUb51f3vPP
	x8BDVJQUTUAuI7mM47OzZGMdO4z4DP2HK1oGhy4dQ1j8DoHjacHQxqwPSotl+au5VY7Eth
	qKLDJ/1iZjF2LVIaR8dGbTsK0AtvbD8=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=mPHXug+N;
	spf=pass (imf23.hostedemail.com: domain of 3JhphagcKCDkkmVohVgbjjbgZ.Xjhgdips-hhfqVXf.jmb@flex--pratmal.bounces.google.com designates 209.85.215.197 as permitted sender) smtp.mailfrom=3JhphagcKCDkkmVohVgbjjbgZ.Xjhgdips-hhfqVXf.jmb@flex--pratmal.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784748583;
	b=5m//1lqlndbWn/CQ4IEJBv/eiFCaecvF0HM2memog2phYx0MMoJlp1qrPRmPEAk2szKpsb
	eXlHSx3yqoFV0zPRmpGk6cfoMhIn2Sj8x+/B51M3/os7BiWPyYh7p7d8P6hQpMT0ptZQG3
	dmaAJ4RBlDO6nOD+29CoaepUQm3CseM=
Received: by mail-pg1-f197.google.com with SMTP id 41be03b00d2f7-cb733fc5024so6120675a12.2
        for <linux-mm@kvack.org>; Wed, 22 Jul 2026 12:29:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1784748582; x=1785353382; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=KLXoX1ivD/mB2jEq+v6b3gqtvL3+A1iZJXkH/v2MOCg=;
        b=mPHXug+NLekq9FCTAyjlQRdDSREG9v21agfm99xVmcAkwnmFHdGjJxx0zXUqPqyH45
         XXdZPvpGPNjLJ38Q8DO9UNIob1khqoQx5iuXymrgcsSkVCw8DdXWqPGNy0oq0lE3UVMb
         fT5CEjBHOymNlyThpF7hogJ8/SR5iMJj2ltXIq617y4SW8S/u83K3oSS1o8aldgqY0Xu
         wk/xm35QTlWJgt3Y50u1IvoOM7ou9NrA0x6ah3um3POWZVglhxrOjtona7uu4nB2jE9m
         gSqYZ1TBpo2gGQUiK3RuuZxS0+JsqZvMqm1nTG1CptvhsEpyUdyruPzv6dBfYJTvsuWO
         wiHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784748582; x=1785353382;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=KLXoX1ivD/mB2jEq+v6b3gqtvL3+A1iZJXkH/v2MOCg=;
        b=DdQwyjwjbS6T0OypjBHdmi0/7ge5iDUnivpV5mZBUm2CuRhAVt3YZhtqaqql14kwJW
         vgqL23kqt3Tt0NMxJcHDFqoTjDHSZF15HUmg9z9Wz9roSNlShUJUDISA3ZOz2uiSScs8
         kNDFUSRkur2ZgMt5mptx/aHFOPih7a1mXIbgVDlaG0f2v5e7CbYsZHVb6INrMt0C15DX
         Gc+ERuaHZAkAfS1racbyPRjQUUHCvB82MssG0sxn4iOPdvQi58Xc16tbtQFQJowtNvy6
         7YIOCkBJkt+aZ6x6MyTcccOfWdrBEacywT5eplhsMz6LNWhgDEZaO40mnjr1/VWCmK52
         MzzQ==
X-Forwarded-Encrypted: i=1; AHgh+Rr6FYuyCRwJ53/q8lyfUFGtOa1lf+doXWZuRsuHWFSNDcupGafXMml5QLktFZ5CRnyvNtACvn1x7g==@kvack.org
X-Gm-Message-State: AOJu0YxPc81q8vZ5pP4d1RdWbKnZ5PtmeENmBgXkz0Na9O7rqB4jI9bg
	YHYwSj8SKc2wMkS7JDWEU0riAb7AiOz0dO6u1cXug4UXEUBKcSY28vgkXFMYUH19wbDlYd3hZ6J
	/PtDOEs7Nkg==
X-Received: from dybsi15.prod.google.com ([2002:a05:7301:488f:b0:314:77c5:40b])
 (user=pratmal job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:60c4:b0:3c0:9c1a:8936
 with SMTP id adf61e73a8af0-3c3ad9ec55fmr27111478637.62.1784748582166; Wed, 22
 Jul 2026 12:29:42 -0700 (PDT)
Date: Wed, 22 Jul 2026 19:29:35 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.55.0.229.g6434b31f56-goog
Message-ID: <20260722192935.1646848-1-pratmal@google.com>
Subject: [PATCH v1] mm/page_reporting: Add page_reporting_delay_ms sysctl
From: pratmal@google.com
To: Anshuman Khandual <anshuman.khandual@arm.com>, David Hildenbrand <david@redhat.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Vlastimil Babka <vbabka@kernel.org>
Cc: Greg Thelen <gthelen@google.com>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Brendan Jackman <jackmanb@google.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Pratyush Mallick <pratmal@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 8614914000E
X-Rspam-User: 
X-Stat-Signature: bsobwmsiiboguiauf8n5ko9i6ga6tf93
X-Rspamd-Server: rspam04
X-HE-Tag: 1784748583-848875
X-HE-Meta: U2FsdGVkX18jmZSNgzi95A5jV92IMs7wKxjGMTkhg/8hXbGFNblarh5rpi+69Sw5EFos2fg8+R9oYWxuTw5gZDgiWM5Xs/WRrACZKBhpLQ9WZIO6XzGsJayGa/9zhscNYCFnWS8AE4bckx01IW9/O9KC1ZRKbg+62BhRQsFiM4sNt+acvKbM3N9J4ZmZEP3DRxLaTeybvYH3sDS8WbZwZrjFQI02SWO7tjB4J9LzVhpRE7fRO2529h/A8jZAiS5Iwja9gUGJeCe3ffw+g/3nDhoh8H1Ly6l4Bx8jETo7NEBzfyibrVnB2SLXnlz21XpmRUGv3nNLP8X7O80iv3/XP5kYWZH025DFD3CZ5m4gD4tya27VeaPwpz0RcEYkbeS1IDYlc7qfzx3ZT5/ACKBe+UKMWUkck/hGjPgIeQmqYE1U6x++q9Ue4r/FLmunaCEvjkXKh87b4IeN8G8ANz6yoq1CNgem5lopNLIqGMgQZydKnIiUdWbqN0WB+E2pzg/ETY+VfEB5lBLT9JixVlgS172Sz0JvR92OqllpImfJhmx1Sky0PDHQf5iNauyBMmtKH+N247CKxgJqgjlFskbXAkO/wGdz7hJ7q71QLbuzy8LvRO02vB7sK1el2SBaiAR7BiP7nb4NDkl5WR0Gk+r4WsM6h7Hy8yxbGbpyrTh++FsXg05EkQYh40G0m0eVCjVqXi3DMygLnFleRsV1flTUlRYicq8NFmi7ts8rzLPMS0GQxE1fZRr5gLNhDjKovNGBJXdY3CGEp8yTYhydwJ6Z/9tli8n/kq3wpWz28ySPB9jj8TFcWXsVxTN/ETy1Fhh4YuU2cmayhsp9trvVpaaa4dDIHL6yxC3GvJ0eCvuLwBSr4vIYEZo2sfCjb2KDWdk+TJcjFj3pAVjnlg6uHFTz0u/IERIlQSCpzgBaBdFJuQR6zo4FLKbCViPTKa8gezzPP9h83nS1AMjC0HvbM4U
 b57MyY0I
 4eWxUP0kszktV/AA/zTC5WOBRfcbhQGp0GbMJIiGwx5Y/g2vL2/RlnJjao35eA2eH9jkeF5GAGjEo+FDRXU/nj0tAJ91UyNqY/WF22QLjiwhCB+JIbWzi+CuXY4uIhyVs7Iro1yNTQW58JlHAK8b8JYTnQ8/yDW4oEaNuGml9me7ym6ThdU4ND7QiJ+ng6P4vDpVdT70EvmzfjaW2LwlxoCbEJBdZ4CzBXQIhiLwzAPVKvj11oVlfNDSOU2N+Wb2A5VNwIyxNp8jdd02YXKsMuh41Mzd+7mCr47szaDlEZYMQdPqze9IsbNC4HX+J5UBg1tIsDL0yohBiFP/XXj3PQc+b50JMe5QWMz1X9xEuvGqnYlPxqshOHJmpbcM8HYwotL3ZvdA1GfFQc+Q/a7X5wm+KvhLL3FMLF08Vg9ZgUAh2dd4wse0e0YhVVcgjDlFnVhnliL8Cv3qTTEZEvzgDGdW2IR2DOlT/2IH2UrMwykG3oB3ID6VKcouoy6eaIYAOazaiQQMFYz8jzt4m3khZwSQgXWkD6RUT67T/BquionTBnCMLb1qI2yqJLJlEUGBYRXVmTv4mLA9CFaiM60ox9M5D0kX+JahTa1bQkPqcbgcDb9sll7cGZ/75e5PDHKoX6/LWwIeIt3/oZmxEleJq/sB9PQ==
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
/proc/sys/vm/page_reporting_delay_ms, measured in milliseconds. The value
defaults to 2000ms to precisely match the original (2 HZ) behavior.

Signed-off-by: Pratyush Mallick <pratmal@google.com>
---
  v1: Fixed feedback from RFC.
  - Added lower and upper cap to sysctl value.
  - Reverted the reordering on page_reporting_delay_ms.
  - Droped the mod_delayed_work() change. 
  - https://lore.kernel.org/linux-mm/20260714171456.2350037-1-pratmal@google.com/T/#u

 mm/page_reporting.c | 29 ++++++++++++++++++++++++++---
 1 file changed, 26 insertions(+), 3 deletions(-)

diff --git a/mm/page_reporting.c b/mm/page_reporting.c
index 942e84b6908a..4ca15afd06da 100644
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
@@ -56,6 +60,18 @@ enum {
 	PAGE_REPORTING_ACTIVE
 };
 
+static struct ctl_table page_reporting_sysctls[] = {
+	{
+		.procname	= "page_reporting_delay_ms",
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
@@ -80,7 +96,7 @@ __page_reporting_request(struct page_reporting_dev_info *prdev)
 	 * now we are limiting this to running no more than once every
 	 * couple of seconds.
 	 */
-	schedule_delayed_work(&prdev->work, PAGE_REPORTING_DELAY);
+	schedule_delayed_work(&prdev->work, msecs_to_jiffies(page_reporting_delay_ms));
 }
 
 /* notify prdev of free page reporting request */
@@ -340,7 +356,7 @@ static void page_reporting_process(struct work_struct *work)
 	 */
 	state = atomic_cmpxchg(&prdev->state, state, PAGE_REPORTING_IDLE);
 	if (state == PAGE_REPORTING_REQUESTED)
-		schedule_delayed_work(&prdev->work, PAGE_REPORTING_DELAY);
+		schedule_delayed_work(&prdev->work, msecs_to_jiffies(page_reporting_delay_ms));
 }
 
 static DEFINE_MUTEX(page_reporting_mutex);
@@ -416,3 +432,10 @@ void page_reporting_unregister(struct page_reporting_dev_info *prdev)
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


