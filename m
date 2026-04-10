Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4C7CDF44842
	for <linux-mm@archiver.kernel.org>; Fri, 10 Apr 2026 11:26:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B5B0D6B0089; Fri, 10 Apr 2026 07:26:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B0BDF6B008A; Fri, 10 Apr 2026 07:26:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A21816B0092; Fri, 10 Apr 2026 07:26:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 8D8346B0089
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 07:26:26 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 55DBC8BB92
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 11:26:26 +0000 (UTC)
X-FDA: 84642417972.03.CAC1D78
Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.4])
	by imf05.hostedemail.com (Postfix) with ESMTP id E0A23100003
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 11:26:23 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b="mnQfO/NX";
	spf=pass (imf05.hostedemail.com: domain of create0818@163.com designates 220.197.31.4 as permitted sender) smtp.mailfrom=create0818@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775820384;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=QK5aDz/JApH7Hqn3dICtUg98ezuf5oFq92vgm9PsAPo=;
	b=yuxNripyRxb1y9Gg/7lsAaFfUhXho1JCXMlRpLzbLf8ZxYNZVMJ97MbBl7LkdsAVY/9Jsk
	0doBEkWTuoRGRHc0TRmEgQzPIXXgHEp8Zc55Fl7JgwZs/faYP2OOpIdlQGls9j87wCDgIs
	dZOd33UKb6LZupQ6zo/c2G3EVHlugtU=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b="mnQfO/NX";
	spf=pass (imf05.hostedemail.com: domain of create0818@163.com designates 220.197.31.4 as permitted sender) smtp.mailfrom=create0818@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775820384; a=rsa-sha256;
	cv=none;
	b=C1/X1aHelgWbti4KDPPc1MHMGcUsicA/Lnv73ppV0WzpGMiSuCuA5NmBsTVsaAivysFqjs
	h08zAcPLZSee2R2HxMCKQnmc6dXMRDtGQ1h5yX3DMTcNYtNRqC7+xerloymoMCQ043MULA
	vUl7gkC4dshYDBee26J5we3FyIPvbfQ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=QK
	5aDz/JApH7Hqn3dICtUg98ezuf5oFq92vgm9PsAPo=; b=mnQfO/NXtWz4oqGhtV
	T9N9oAffotp8XN4AHWrxVXHyKkgw6RdjfaBl77vDYGtMNfKespaAIZAS9FKjPRvF
	QxtAHgLRbxUOgp+sDnJ0Qjj4RaICSoxIquR7q76tnyTk12Nc6e6R49sf1vaiN/Jq
	F+4Yksmz2hv7Z8RJunjleQ/pc=
Received: from localhost.localdomain (unknown [])
	by gzsmtp4 (Coremail) with SMTP id PygvCgDHJatD3thpkDE+Vg--.269S2;
	Fri, 10 Apr 2026 19:25:59 +0800 (CST)
From: Cao Ruichuang <create0818@163.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	linux-mm@kvack.org
Cc: David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	linux-kernel@vger.kernel.org,
	Cao Ruichuang <create0818@163.com>
Subject: [PATCH] mm/vmstat: reject invalid stat_interval values
Date: Fri, 10 Apr 2026 19:25:54 +0800
Message-Id: <20260410112554.23165-1-create0818@163.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:PygvCgDHJatD3thpkDE+Vg--.269S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7Kr4kXFyUAryxuF4xur1kAFb_yoW8KF1xp3
	98GryUtw45G3WSganxAF4UZr4akrs7u34jkrnrJ34Sq3Z8K343Zrn5GrW2yF17Cry8XF1f
	X3yqy3s8uayYyFDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0JUj9akUUUUU=
X-Originating-IP: [39.156.194.234]
X-CM-SenderInfo: pfuht3jhqyimi6rwjhhfrp/xtbC6Ahak2nY3kgRbwAA3w
X-Rspam-User: 
X-Rspamd-Queue-Id: E0A23100003
X-Stat-Signature: qy74af4qjw3ss4k9h33obquhnzwxsegw
X-Rspamd-Server: rspam06
X-HE-Tag: 1775820383-815061
X-HE-Meta: U2FsdGVkX192HNJgT+MzsC/K3IiUDAleM/j+KjzVOPlVqxL30wjZ1f6t7cVpmNAdSA2Ml5IvJNkCkaS8DMDyqJW/llu8RCdcFT9QDZPMsyCO5z8KbkyGXGBImRShsjwxSJWHY3hxTWZ0hf25CqzXEbW7Xdlfe7V1xons632EgbSgtzFNOxn3kgAYbKUUxBa8BC8KtTKp3DgqwrDbRmiraaTJ3FQPkrMlNYMIDkG5eciCDd/SI3ptizHRLXJSBK/vnI3MeHQTbOG7IXKxy/F42S+RYmFLP+oGMBsBsQ22eU33H00yw/bplEWOTUsNDYZXTmGEWusdaKFJ7wC6QBrvVR8TLkjCUcufbgjc+HwgOj60zgaDPjOBLIsA+VwKUPTr/xR61QbX5sU85xPOOFE4cgjw0giqGGOXv2ySXiAPaHuJ+pVGSIoIVed7LUmF3VzEAP6adXbJOH1TVtmuvAAt6vbbTmtsYUnmaQmLzpbLCDBXoBliu0Kv48TZoY4H+SXnKdT8sS8LYPfM4nwDusLvjJ2DcfuM9cDlBclNhVUVUReQemfmpipQAKgWJnWS8NHHAkZwB199DvUKeVVM09We65svG5qdu1t6ygc0uoRFnjzkLDh5wnqKzA2pLh0xLPOGgC3Tdut90ayG0Oa9EBEuJvc+Gzhzx/l8ky75z+Ifmx1KUEVVx//jgyXPaFWaOq5lNUV86bk/R7oPaSmyH5jVSK8Mv+9EVkyryF8LLIfHKGp3AEHUPxNAEEployAh+fY4jDVzW9U+ojwLm05+WRgzZhKXGieFfE0vEJl9ii0CbV8NOyrK3gLzyEVcyq9YqFjO5CDTNOqq22KBcUnLi77sT8TdSMkomIIpv9u6HcVCU6XBBjCXCrM7uMZj8QfjqYOiz7glLyGoJWxySI5MtA2RROybvonQOrXRh2h2Qvs+bXa6J/nvRiRyQpl8Zw0GBpMNXVrBIUubnaWzujltbPd
 GWvCv/OX
 ieLwIXxHZsmc6Mw5cr326V+WRVQXm8uscyejZpy5CWMyZQ0/kG+xbp7iE9PQ2hvAXzdF8ITukDyH90IUOoZAMkN4fcFobiCzslh48iuNN9szXC4zHVhx2KeBaV3DjvR/QYDjGXCgmR8GIMm1CGZL7I524nBvdpaoIbgANLXWOFpPd6Nt+nE1oo5q6lOP+b+2Afqsjf8E6HEhX14D0mOkJvL7Gu5PWZMrNLr/lPSilt+E8vO3+aCcaPI5ipduSSZX7vRgdBdXzZwUZwX+ayI461rNa6DekdZg4tH8ELSBj/pPZG1SpSimtBQ0R14AsJKH+cLeqcdOz47YaC4arYnso9EYhltJ9v+KTQDebfhqFx8jhQNODAj8mGunVEQDJVDPs/FBs/KYvNTpP99Jl+3c5ogFZACa5Z0LzVPiwcIbxz1oqj7PHEo0Mv5hO9g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

vm.stat_interval is exposed in seconds, but proc_dointvec_jiffies()
currently accepts zero and negative values. In the current tree,
writing 0 succeeds and leaves /proc/sys/vm/stat_interval at 0.

vmstat_update() uses the stored jiffy interval directly when it
requeues its delayed work, so a zero interval can drive excessive
kworker CPU usage. Negative values are not meaningful either.

Switch vm.stat_interval to a small custom sysctl handler that keeps
the existing seconds-based userspace ABI while rejecting values below
1 and capping the upper bound at INT_MAX / HZ.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=220226
Signed-off-by: Cao Ruichuang <create0818@163.com>
---
 mm/vmstat.c | 23 ++++++++++++++++++++++-
 1 file changed, 22 insertions(+), 1 deletion(-)

diff --git a/mm/vmstat.c b/mm/vmstat.c
index 86b14b0f77b..f48d3bdad64 100644
--- a/mm/vmstat.c
+++ b/mm/vmstat.c
@@ -1964,6 +1964,7 @@ static const struct seq_operations vmstat_op = {
 #ifdef CONFIG_SMP
 static DEFINE_PER_CPU(struct delayed_work, vmstat_work);
 static int sysctl_stat_interval __read_mostly = HZ;
+static const int sysctl_stat_interval_max = INT_MAX / HZ;
 static int vmstat_late_init_done;
 
 #ifdef CONFIG_PROC_FS
@@ -1972,6 +1973,26 @@ static void refresh_vm_stats(struct work_struct *work)
 	refresh_cpu_vm_stats(true);
 }
 
+static int vmstat_stat_interval_handler(const struct ctl_table *table, int write,
+					void *buffer, size_t *lenp, loff_t *ppos)
+{
+	int interval = sysctl_stat_interval / HZ;
+	const struct ctl_table tmp = {
+		.data	= &interval,
+		.maxlen	= sizeof(interval),
+		.mode	= table->mode,
+		.extra1	= SYSCTL_ONE,
+		.extra2	= (void *)&sysctl_stat_interval_max,
+	};
+	int ret;
+
+	ret = proc_dointvec_minmax(&tmp, write, buffer, lenp, ppos);
+	if (!ret && write)
+		sysctl_stat_interval = interval * HZ;
+
+	return ret;
+}
+
 static int vmstat_refresh(const struct ctl_table *table, int write,
 		   void *buffer, size_t *lenp, loff_t *ppos)
 {
@@ -2236,7 +2257,7 @@ static const struct ctl_table vmstat_table[] = {
 		.data		= &sysctl_stat_interval,
 		.maxlen		= sizeof(sysctl_stat_interval),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec_jiffies,
+		.proc_handler	= vmstat_stat_interval_handler,
 	},
 	{
 		.procname	= "stat_refresh",
-- 
2.39.5 (Apple Git-154)


