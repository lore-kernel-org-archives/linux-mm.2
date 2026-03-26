Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4609B106F2E7
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 07:56:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8AF906B0005; Thu, 26 Mar 2026 03:56:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 839536B0088; Thu, 26 Mar 2026 03:56:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6DEE06B0089; Thu, 26 Mar 2026 03:56:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 54CAE6B0005
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 03:56:23 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id F178C1608D4
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 07:56:22 +0000 (UTC)
X-FDA: 84587456604.02.9D36B0E
Received: from canpmsgout07.his.huawei.com (canpmsgout07.his.huawei.com [113.46.200.222])
	by imf29.hostedemail.com (Postfix) with ESMTP id 1092612000A
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 07:56:18 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=5KP2guBT;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf29.hostedemail.com: domain of yangyingliang@huawei.com designates 113.46.200.222 as permitted sender) smtp.mailfrom=yangyingliang@huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774511781; a=rsa-sha256;
	cv=none;
	b=FfNJdsJPBn+HpksPLxsLmNvghbHiBbmN4jEMgFih58JJb4s27jQ8RtOo5/J5jWi/2JZSIh
	hi0UatWBFat/Bfk4cT0F9aBWWgnZEiDRoOeRpyvUjlPYWLiRCKoZPuZt61y25GJWomw4Fx
	oUQP/WzD6jmOunG4Bs+2JJ3/o59RgtA=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=5KP2guBT;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf29.hostedemail.com: domain of yangyingliang@huawei.com designates 113.46.200.222 as permitted sender) smtp.mailfrom=yangyingliang@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774511781;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=KeGe31pnWU9sNlgHOU08IcjrMTmyK9AVvW8hheCO5Vg=;
	b=kScXNCfZRwBbBJ+cHu5kpQHD0Mjrk4b+WrezNd02AThNU/QcAcltoUYiaW9Po+VJ0GPQZI
	ddTDqDXIeYX++8gTuFN3jiBCheQV0BGSiTMJSOTJz0WXJ6Bb9lmDCwr2b5zjkxBo3qG4yA
	c/B1kWMzMTjhoJ6JlD9QNlBc8jlHw+g=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=KeGe31pnWU9sNlgHOU08IcjrMTmyK9AVvW8hheCO5Vg=;
	b=5KP2guBTNY9EPm3IfhFvAiVTNpoS3bd7gvfWq35qe7MpWYcTGkA7i8+0bXkF3ihNoBiphWjpw
	kCOnIeK6N+Fd4ZnahR6I+jryyngzyHlVOrFYazy1aXUNPdA6m7S4FRwPMKtgB4UyF9zQAnfvI26
	4vLPTVKzQh0MG6IlXoiytqk=
Received: from mail.maildlp.com (unknown [172.19.163.214])
	by canpmsgout07.his.huawei.com (SkyGuard) with ESMTPS id 4fhGCH6lmCzLlT0;
	Thu, 26 Mar 2026 15:50:03 +0800 (CST)
Received: from dggpemf200002.china.huawei.com (unknown [7.185.36.244])
	by mail.maildlp.com (Postfix) with ESMTPS id 4D2B140561;
	Thu, 26 Mar 2026 15:56:09 +0800 (CST)
Received: from huawei.com (10.50.87.109) by dggpemf200002.china.huawei.com
 (7.185.36.244) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Thu, 26 Mar
 2026 15:56:08 +0800
From: Yang Yingliang <yangyingliang@huawei.com>
To: <akpm@linux-foundation.org>, <david@kernel.org>, <ljs@kernel.org>,
	<Liam.Howlett@oracle.com>, <vbabka@kernel.org>, <rppt@kernel.org>,
	<surenb@google.com>, <mhocko@suse.com>, <liushixin2@huawei.com>,
	<hucool.lihua@huawei.com>, <yangyingliang@huawei.com>
CC: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH -next] mm: vmstat: make refresh interval take effect immediately
Date: Thu, 26 Mar 2026 15:55:46 +0800
Message-ID: <20260326075546.3357901-1-yangyingliang@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.50.87.109]
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
 dggpemf200002.china.huawei.com (7.185.36.244)
X-Stat-Signature: 3roqhcuwh8e5mg8nhak6zkft48p1yc14
X-Rspamd-Queue-Id: 1092612000A
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1774511778-614426
X-HE-Meta: U2FsdGVkX18uKoyYZkYMJFbhmixFi2gLU29nYPKn+VyWyJxO/ia6e4i76QNGecqeEX/2DiqXtZqk9lTL7UU0O/+r4x57y0O1mIAghPadVveHsp2ITgcZbIvVLLB2O5etVP3wKdviqbaSm3t3tMKi96BFFXGgQ38Wn266e7SqSTEengERnSpsNUOPA3KhPfiEudX7tQmAXDnjeaQv6VYIjaXsTc3KxOZIpsMUDjNmiCa4n7DAYTQ1wpHvfQJyUo45ZT5qTGwodl/jU9gdZSO36q8dwPt78oJRdJTVTiqFI+r8Lo44bUrcVmFNaRTTwXHdolTALD1gusLklzDxwp291gQoEx3HIjA08bsZNt1voUKyPYE2J0scgKMXNvbMajAn7Fh9pKZ6MHtNgYG0XS6h/x31oN9fcRDLnEEMM57khL6xRmeBrmgHhMyxpv/JGg+xM3UZDeK2ltH9jWfhXIkgf5AuOv5cl0SJlUvEFtuvS6tK/NAF0sTN/k8Lym9A4yEmZoTAJKUSVah7VFoOX7IYLDqplB17w8E3t9k0eSAYSCS2nTYUAq94Wz50J4aAEuYXfsdsBpypaC3+zrIcCVGX48BNsGcJYFT6id89axbX9m4y95g0dq4xEWSAdQwvfZDXAVYC3SqouzbUok9Xi4eIY75PTjHAPsWApaL/7pHcdhqkLXjfSvi/LNtlm9cVp8AFgozWZgnZLS1ziCdMJAcf8ZL/+WisC7NXTylyS1r9zx3nxLC8+kHtY0apwY4cnLZAdl/re9WokyAylWcy8f42eLxPR+rfrZaO8JFMuSWAGLck1hRwxP+YZYXxmN3EanRi2WnaCOB9x74jdtKwGjTQrCoapwMXGBVUGy5YP2B4CcZt5MW4Ne6JsRw39DDrBH7dOJ+O4H5E2ibU+wm6daYW5FUD0dOcS95+Zvet+YcFsuDBHzEsfcbZCMFFdS1uZnAW4aAWuHaFMQN4Yfk7b0G
 iSPiKDMZ
 0qedtepGzv0RUAsu4hEhXTG6ZS9E2RrFK/ryFUjni5KZzI+xAtfp6gwwH93sYNCIyCcgrHjVxZeUoXXm4brhWB758MPxBJriD2liDg/ewyEnVNfee4Qj5WaASXQnvZDV4kd1/KFRb26ek1xA/X3f4W5cgEfhUHPAXZv0+r+eX9eNj0w+PKDByR1RbiEqmNaSWUDL6zdFOObFO0isc24fGwuvaKHnyAUcXQ7xId+5aq8ota7oACO+G51ikC6w5PDmelCjKSzgGzcFOZbRUlTczrfmFpJw4BnRdK8VF
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The refresh workqueue is re-queued after last timer is triggered, so when
the refresh interval is set, it doesn't take effect immediately.

It leads a problem like this: if current interval is 8640000s (100 days),
and we want changing it to 1s, the new interval can't take effect until
100 days later.

So call mod_delayed_work() after updating interval to make the new value
take effect immediately.

Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
---
 mm/vmstat.c | 37 ++++++++++++++++++++++++++++++++++++-
 1 file changed, 36 insertions(+), 1 deletion(-)

diff --git a/mm/vmstat.c b/mm/vmstat.c
index 2370c6fb1fcd..7b4a9c30cc80 100644
--- a/mm/vmstat.c
+++ b/mm/vmstat.c
@@ -1968,6 +1968,9 @@ static int sysctl_stat_interval __read_mostly = HZ;
 static int vmstat_late_init_done;
 
 #ifdef CONFIG_PROC_FS
+static int sysctl_stat_interval_handler(const struct ctl_table *table, int write,
+					void *buffer, size_t *length, loff_t *ppos);
+
 static void refresh_vm_stats(struct work_struct *work)
 {
 	refresh_cpu_vm_stats(true);
@@ -2151,6 +2154,38 @@ static void vmstat_shepherd(struct work_struct *w)
 		round_jiffies_relative(sysctl_stat_interval));
 }
 
+#ifdef CONFIG_PROC_FS
+static int sysctl_stat_interval_handler(const struct ctl_table *table, int write,
+					void *buffer, size_t *length, loff_t *ppos)
+{
+	int cpu;
+	int ret = proc_dointvec_jiffies(table, write, buffer, length, ppos);
+
+	if (ret || !write)
+		return ret;
+
+	cpus_read_lock();
+	for_each_online_cpu(cpu) {
+		struct delayed_work *dw = &per_cpu(vmstat_work, cpu);
+
+		scoped_guard(rcu) {
+			if (cpu_is_isolated(cpu))
+				continue;
+
+			if (delayed_work_pending(dw))
+				mod_delayed_work(system_wq, dw, round_jiffies_relative(sysctl_stat_interval));
+		}
+
+		cond_resched();
+	}
+	cpus_read_unlock();
+
+	mod_delayed_work(system_wq, &shepherd, round_jiffies_relative(sysctl_stat_interval));
+
+	return ret;
+}
+#endif
+
 static void __init start_shepherd_timer(void)
 {
 	int cpu;
@@ -2237,7 +2272,7 @@ static const struct ctl_table vmstat_table[] = {
 		.data		= &sysctl_stat_interval,
 		.maxlen		= sizeof(sysctl_stat_interval),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec_jiffies,
+		.proc_handler	= sysctl_stat_interval_handler,
 	},
 	{
 		.procname	= "stat_refresh",
-- 
2.25.1


