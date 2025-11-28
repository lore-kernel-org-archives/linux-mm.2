Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D60D6D116F3
	for <linux-mm@archiver.kernel.org>; Fri, 28 Nov 2025 02:54:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 060C16B0010; Thu, 27 Nov 2025 21:54:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F25946B0026; Thu, 27 Nov 2025 21:54:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C66446B0012; Thu, 27 Nov 2025 21:54:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A26886B0010
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 21:54:26 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 4C1B31A02F9
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 02:54:26 +0000 (UTC)
X-FDA: 84158497332.19.10C276C
Received: from mta21.hihonor.com (mta21.hihonor.com [81.70.160.142])
	by imf06.hostedemail.com (Postfix) with ESMTP id F259A18000B
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 02:54:23 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=none;
	spf=pass (imf06.hostedemail.com: domain of wangzicheng@honor.com designates 81.70.160.142 as permitted sender) smtp.mailfrom=wangzicheng@honor.com;
	dmarc=pass (policy=none) header.from=honor.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764298464;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lhVnYJtU+w8oYeHRjg3nxZTL93WhJPWogIwM03jzqTA=;
	b=SPHRoYanill5iLUkKdwaXotZ8BkWNdYSZOHvx3e2+5wOt9SfxCKCoTCiTQkAMpCOFZGBot
	zXgdLMvhFR1a+oHA072rNzriehd4mbQa3cVzGk4DLY5AnnO/PdYomCnx65k0HvsPIxNYX9
	2wigobaZx9+Z7z8fsRAlcq3XEXPfHfc=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=none;
	spf=pass (imf06.hostedemail.com: domain of wangzicheng@honor.com designates 81.70.160.142 as permitted sender) smtp.mailfrom=wangzicheng@honor.com;
	dmarc=pass (policy=none) header.from=honor.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764298464; a=rsa-sha256;
	cv=none;
	b=TyjwBcRtcHquxYXld1h567VuT02xJ6Egj8Gb5vEvU+ZVNmKp/rtJFZeq8HqlKZJXolYhaA
	DcRLahH26ntvWqTTh5b7VhqiUGum00+vvEHrfQc9Vs93x1PqCzbHYgkM8av1UCuF5qVdAE
	cUz4UFjXV3OJbHz5L/BNmX9WyWEvzZ8=
Received: from w002.hihonor.com (unknown [10.68.28.120])
	by mta21.hihonor.com (SkyGuard) with ESMTPS id 4dHdBy1DhFzYmZ9w;
	Fri, 28 Nov 2025 10:52:58 +0800 (CST)
Received: from localhost.localdomain (10.144.5.36) by w002.hihonor.com
 (10.68.28.120) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Fri, 28 Nov
 2025 10:54:19 +0800
From: Zicheng Wang <wangzicheng@honor.com>
To: <akpm@linux-foundation.org>, <hannes@cmpxchg.org>, <david@redhat.com>,
	<axelrasmussen@google.com>, <yuanchu@google.com>
CC: <mhocko@kernel.org>, <zhengqi.arch@bytedance.com>,
	<shakeel.butt@linux.dev>, <lorenzo.stoakes@oracle.com>, <weixugc@google.com>,
	<Liam.Howlett@oracle.com>, <vbabka@suse.cz>, <rppt@kernel.org>,
	<surenb@google.com>, <mhocko@suse.com>, <corbet@lwn.net>,
	<linux-mm@kvack.org>, <linux-doc@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Zicheng Wang <wangzicheng@honor.com>
Subject: [PATCH 1/3] mm/lru_gen: add procfs support for lru_gen interfaces
Date: Fri, 28 Nov 2025 10:53:13 +0800
Message-ID: <20251128025315.3520689-2-wangzicheng@honor.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20251128025315.3520689-1-wangzicheng@honor.com>
References: <20251128025315.3520689-1-wangzicheng@honor.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.144.5.36]
X-ClientProxiedBy: w012.hihonor.com (10.68.27.189) To w002.hihonor.com
 (10.68.28.120)
X-Rspamd-Queue-Id: F259A18000B
X-Rspamd-Server: rspam02
X-Stat-Signature: fyc6pzfzahitar3t35rujgipmbfhbtha
X-Rspam-User: 
X-HE-Tag: 1764298463-527351
X-HE-Meta: U2FsdGVkX183Nc0HxJ48m44gjpXyIiY/sztQOO4fy+pLDdcDlNx0efmEV07/VVMURy3xkMqfMIqkY1dQ0D5DpPrYbTJ1Nz7tMGd4ZBPcvkuouppy0C0NG6xSD6BHqKdlCJYGJ8ejiE00oGZGYkJbRIuftd/lvKx1y54vKs5qylQbWhufTwLVxZyNLfADz7WAjANm42MZqug/NwKxtDyUVrRh21JMFGb8BNjoL8HrpBS4s+1nSC5YPUR6Q4vFq+5drm0BFcKRZCu3yF/EIBGWlzCCeUi35dEadETlMqXjGChECMzLHfCztnsBQefS2j59huQAn3FtySt1growsJ+xOmwh6HSc0X43jUaxBFpXhABmXMMD18tqAYE5Z/1sjzErxAfjbbEAG1vdBd/6v76xEpfS6OAHYj4o0V/O9JoGdjp83vHg3I6duC+nme6kQgHLl6Pr+8MMMaIvtxjOcrhwC3HWOzRc7xwTIH171KIBVecbau6SolibDl4Q4OzqKTIRvR6ckr9uc+fSuxc0rU+8XVmNqGfDdkHObUkZSRHr63OCxBykShnOTlFYRJP901Aprm1EJtCnV4NPMBWalIkuLU/mNk1CV61LAymMdTjLDGshWYZC+Q9YU355TxHaTZMrAElS9bfaByMz89FJ9qejT3PcHYDpeM7rt2TwAdB8uP1KfxJcn6/1xEsXMpyOcoH9mTkIH7hHFOjqRPaoZKzGi8XTunQr9KvrBLjXnhiL/uqo+2slryVKl014yM5nvaRG+0/8CO13+CEMmHBYXb2380W9DqdIG8xWkRTT58gUlNlNuAG6prYOorGW5ptS8ElOS0k13Rz6d+wLERFjV9oRj4KB/za1UZaPu73HOrbweRkxoEz0T2j0w5dqNqxiBGVXXcl7O2BEvNcrFGJNkZ38wGZp8kgnMGsGjYq6vZcP9Ez3Vxb06BVThTfhZfGIC+4YGWukLrNk0laLaOfsdwX
 GeSwK/F1
 1/Cwn32OUuy9PDUxLNpVwjQpMBXvWPaVoCkXmDopdVyIYMZ7i418p2UTl8T1AgRuRVNNhgveCcMdB7FUZpjLMOtsnxdtaJsf29tTRdYHMp9dZc2U4mANgbkaafqtt8zaQQRATh9DSEiW7FTqlKX21KZpOsGxdL6wA3FFc34DDw8/BtPhxoW21lGLhElSxghzPrI/BxiiGjN3UfxXU/WJA5sPCshtvP1Cf4UFnFLcVaqEUoLGrXYk2sbubmSXzpbrbPdSSK7wK4MupteNF+tv/ebq6zJwObiO0ZBbIulqMgAaooxs=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This patch refactors the lru_gen and lru_gen_full control files to allow
their interfaces to be exposed under either debugfs or procfs.

Two main changes:
1. minimal code modification by reusing the existing seq_operations.
2. lru_gen file mode update from 0644 to 0664, so that Android's group
"system" can write to the file when procfs interface is enabled.

Signed-off-by: Zicheng Wang <wangzicheng@honor.com>
---
 mm/vmscan.c | 37 +++++++++++++++++++++++++++++++++++--
 1 file changed, 35 insertions(+), 2 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 674999999..dd30f3949 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -58,6 +58,7 @@
 #include <linux/random.h>
 #include <linux/mmu_notifier.h>
 #include <linux/parser.h>
+#include <linux/proc_fs.h>
 
 #include <asm/tlbflush.h>
 #include <asm/div64.h>
@@ -5324,9 +5325,17 @@ static const struct attribute_group lru_gen_attr_group = {
 };
 
 /******************************************************************************
- *                          debugfs interface
+ *                          lru_gen interface
  ******************************************************************************/
 
+static inline bool lru_gen_show_is_full(const struct file *file)
+{
+    /* procfs: i_private = (void *)1 means full
+     * debugfs: also works because debugfs sets i_private
+     */
+	return file->f_inode->i_private != NULL;
+}
+
 static void *lru_gen_seq_start(struct seq_file *m, loff_t *pos)
 {
 	struct mem_cgroup *memcg;
@@ -5435,7 +5444,7 @@ static void lru_gen_seq_show_full(struct seq_file *m, struct lruvec *lruvec,
 static int lru_gen_seq_show(struct seq_file *m, void *v)
 {
 	unsigned long seq;
-	bool full = debugfs_get_aux_num(m->file);
+	bool full = lru_gen_show_is_full(m->file);
 	struct lruvec *lruvec = v;
 	struct lru_gen_folio *lrugen = &lruvec->lrugen;
 	int nid = lruvec_pgdat(lruvec)->node_id;
@@ -5671,6 +5680,7 @@ static int lru_gen_seq_open(struct inode *inode, struct file *file)
 	return seq_open(file, &lru_gen_seq_ops);
 }
 
+#ifndef CONFIG_LRU_GEN_PROCFS_CTRL
 static const struct file_operations lru_gen_rw_fops = {
 	.open = lru_gen_seq_open,
 	.read = seq_read,
@@ -5685,6 +5695,22 @@ static const struct file_operations lru_gen_ro_fops = {
 	.llseek = seq_lseek,
 	.release = seq_release,
 };
+#else
+static const struct proc_ops lru_gen_proc_rw_ops = {
+	.proc_open    = lru_gen_seq_open,
+	.proc_read    = seq_read,
+	.proc_write   = lru_gen_seq_write,
+	.proc_lseek   = seq_lseek,
+	.proc_release = seq_release,
+};
+
+static const struct proc_ops lru_gen_proc_ro_ops = {
+	.proc_open    = lru_gen_seq_open,
+	.proc_read    = seq_read,
+	.proc_lseek   = seq_lseek,
+	.proc_release = seq_release,
+};
+#endif
 
 /******************************************************************************
  *                          initialization
@@ -5772,10 +5798,17 @@ static int __init init_lru_gen(void)
 	if (sysfs_create_group(mm_kobj, &lru_gen_attr_group))
 		pr_err("lru_gen: failed to create sysfs group\n");
 
+#ifndef CONFIG_LRU_GEN_PROCFS_CTRL
 	debugfs_create_file_aux_num("lru_gen", 0644, NULL, NULL, false,
 				    &lru_gen_rw_fops);
 	debugfs_create_file_aux_num("lru_gen_full", 0444, NULL, NULL, true,
 				    &lru_gen_ro_fops);
+#else
+	proc_create_data("lru_gen", 0664, NULL,
+					&lru_gen_proc_rw_ops, NULL);
+	proc_create_data("lru_gen_full", 0444, NULL,
+					&lru_gen_proc_ro_ops, (void *)1);
+#endif
 
 	return 0;
 };
-- 
2.25.1


