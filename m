Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8564BFD9E2E
	for <linux-mm@archiver.kernel.org>; Fri, 27 Feb 2026 02:57:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 70A276B008C; Thu, 26 Feb 2026 21:57:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 694136B0093; Thu, 26 Feb 2026 21:57:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 48E4E6B008C; Thu, 26 Feb 2026 21:57:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 23C916B0093
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 21:57:25 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D1A591A04A0
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 02:57:24 +0000 (UTC)
X-FDA: 84488725608.27.8FCAFD0
Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	by imf07.hostedemail.com (Postfix) with ESMTP id 66D8B4000F
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 02:57:21 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	spf=pass (imf07.hostedemail.com: domain of yebin@huaweicloud.com designates 45.249.212.56 as permitted sender) smtp.mailfrom=yebin@huaweicloud.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772161042;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=s5C42Lm5V6+dT+2z0ztDPr2VqISCcjqSYDQgTtNoI/o=;
	b=jP3ef/+JtZ6yX5FArbA+6TMDxBKw2f5ExmIhs9UtyslO4+eqjWZRSG+vJH25aGA3RqmUI4
	oEsIcH7OIkAQSWAb4RlDwTL9GPumye1MabtyrbW86VVVpyrOFqfyiPtvCDATd7lhPFYisi
	nCeijHhf4OIdYc3kwlmQ5HXRfLtNwnw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772161042; a=rsa-sha256;
	cv=none;
	b=3m1wBlZcxubFVVvud79X5Y7EcX5rPu/yjdHqKYGVpTtCjHcfV0A7+IpkFIGcQUQ6nNUqM+
	ROBRLyKUQjLMEKsRL+5qx7G3ZTQHy2HRyB56tEUP3tBza1GzM42AgsH8j4Kvta1qawHbF1
	Fd3X8pOsirOXPhxA1yRCYC1eqeT4FSo=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=none;
	spf=pass (imf07.hostedemail.com: domain of yebin@huaweicloud.com designates 45.249.212.56 as permitted sender) smtp.mailfrom=yebin@huaweicloud.com;
	dmarc=none
Received: from mail.maildlp.com (unknown [172.19.163.198])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4fMXym5sJBzKHMSp
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 10:56:16 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 1391840576
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 10:57:15 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.87.132])
	by APP4 (Coremail) with SMTP id gCh0CgBXuPgJCKFpsEGdIw--.32070S6;
	Fri, 27 Feb 2026 10:57:14 +0800 (CST)
From: Ye Bin <yebin@huaweicloud.com>
To: viro@zeniv.linux.org.uk,
	brauner@kernel.org,
	jack@suse.cz,
	linux-fsdevel@vger.kernel.org
Cc: akpm@linux-foundation.org,
	david@fromorbit.com,
	zhengqi.arch@bytedance.com,
	roman.gushchin@linux.dev,
	muchun.song@linux.dev,
	linux-mm@kvack.org,
	yebin10@huawei.com
Subject: [PATCH v3 2/3] sysctl: add support for drop_caches for individual filesystem
Date: Fri, 27 Feb 2026 10:55:47 +0800
Message-Id: <20260227025548.2252380-3-yebin@huaweicloud.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260227025548.2252380-1-yebin@huaweicloud.com>
References: <20260227025548.2252380-1-yebin@huaweicloud.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgBXuPgJCKFpsEGdIw--.32070S6
X-Coremail-Antispam: 1UD129KBjvJXoWxJw1fJryDtry3Gw1kWF1ftFb_yoWrWw48pF
	Wa9Fy5KrWrAF13tr9xAr4vvF1S93yktw17Kwnru34Ikw1Svr1vq3Z2yryYqF45JrWUurW7
	WF4DKF1DW3yDXFJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUPFb4IE77IF4wAFF20E14v26rWj6s0DM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28IrcIa0xkI8VA2jI8067AKxVWUXw
	A2048vs2IY020Ec7CjxVAFwI0_Xr0E3s1l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxS
	w2x7M28EF7xvwVC0I7IYx2IY67AKxVWDJVCq3wA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxV
	W8Jr0_Cr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I0E14v2
	6rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMc
	Ij6xIIjxv20xvE14v26r106r15McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_
	Jr0_Gr1lF7xvr2IYc2Ij64vIr41lFIxGxcIEc7CjxVA2Y2ka0xkIwI1lc7CjxVAaw2AFwI
	0_Jw0_GFyl42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG
	67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MI
	IYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E
	14v26r4j6F4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJV
	W8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjxUob18
	DUUUU
X-CM-SenderInfo: p1hex046kxt4xhlfz01xgou0bp/
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 66D8B4000F
X-Stat-Signature: 18qua8x8zipuu9weem3xq6jxwurfuxfy
X-Rspam-User: 
X-HE-Tag: 1772161041-48580
X-HE-Meta: U2FsdGVkX1+Nd8d1woQRhpKzDOKlI112XeTxtVTjHx1t0dLtw4hlHqkaKWhMIFOPBprnVGjpZXA0EcV/nRGRwjMZRqxJiYw21UhVHyT8Fxsestw+oum3cXExFY+tU3xMIhWFv9qLxW9txL/3UhEle547RPhtXTIb82AHnieZh3X6aGrR7doEIM0lvBQdJEJVR0gNWVfpTgixp2+1W+wC1l7yvkTu/zCGyd6ZGnXmTLIwu5hr7JXkKmDh2JS45IOEFqgPDJnPORBbcc3NdxJhxwcHeNvBbkLzGXoxz8StnfykLATNM8I3eDBdzey4ZyRsaUQuxz7331dPtTqCfRbtk/i4rfxkqIG/4vmg2qbAuPJmhdJNq8NkgAxQDQb7zijZU2ot7J78kkQpU1qIdAgIkHxxOevCCJFeFEqPfS5e6o5559s3h4Rz3/4ouazHtFaz6KYMMlCLSmwPHKv+/PtQUe5wgjDNIflCaKJ5lHpqrNoGvxhtRckD9SlkWk8K/8LA9Fkppp3RHZHDGWVROCYUhHArDpC2PRtlcDa9WzXY4k8MRC6NbsYCcoMZ+BTuDasN2oGci6xhy8H89hbRmKb4Fswq8isOSKIulB57omIdkOcbrnGkI5HS/evm2Nurxes/hvkXn+gZz0v/4b8G2oOnvSYfgj0Nm7YAdQ/6v4mTL7o7y0aT28HC55F345dR8pqF3bnsZT8WIt5G969mBdHW4wh0aKA3Oi9W+yPBvcWedUgNhsM6E/p1h9MtFaU6HjoE92pCVEgFoycRN77NYoW3IU3e/X1V685FBr1g3M5cNXBn7PeJJqbRZHRMi8J/WvHsG9J4KxNalfwv5EM5/TiurbIoGJlLj96mMTt7iRtelk2JMjSFLTA49255qNBgA9Z1DAKhRPuNRB2SaKOM7KY6TsLOxfllC3G8INwCDG4sCtY1+VAEohL0uZTQcxrSrG+skKYCLIJe/kiXWLpubbK
 N5gMLGzT
 k5iDLEj8m1PPWbNZCTG4yRb2a3Ygrt136wiFTxF0st7bn+9dovMv50i/hIqswF1tcZeJCaA55/gw7rQa0fo0hz+vtsFJi4oolRCmeIvMMcA2gZcJsPOb1gQwJAuDMQA98uVhiKaU0qrfbVtezszNQesVnJDLSCJjqmpSwV4Nwh07PVHBGXOMlB21GNw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ye Bin <yebin10@huawei.com>

In order to better analyze the issue of file system uninstallation caused
by kernel module opening files, it is necessary to perform dentry recycling
on a single file system. But now, apart from global dentry recycling, it is
not supported to do dentry recycling on a single file system separately.
This feature has usage scenarios in problem localization scenarios.At the
same time, it also provides users with a slightly fine-grained
pagecache/entry recycling mechanism.
This patch supports the recycling of pagecache/entry for individual file
systems.

Signed-off-by: Ye Bin <yebin10@huawei.com>
---
 fs/drop_caches.c | 125 +++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 125 insertions(+)

diff --git a/fs/drop_caches.c b/fs/drop_caches.c
index 49f56a598ecb..0cd8ad9df07a 100644
--- a/fs/drop_caches.c
+++ b/fs/drop_caches.c
@@ -11,6 +11,8 @@
 #include <linux/sysctl.h>
 #include <linux/gfp.h>
 #include <linux/swap.h>
+#include <linux/task_work.h>
+#include <linux/namei.h>
 #include "internal.h"
 
 /* A global variable is a bit ugly, but it keeps the code simple */
@@ -78,6 +80,124 @@ static int drop_caches_sysctl_handler(const struct ctl_table *table, int write,
 	return 0;
 }
 
+struct drop_fs_caches_work {
+	struct callback_head task_work;
+	dev_t dev;
+	char *path;
+	unsigned int ctl;
+};
+
+static void drop_fs_caches(struct callback_head *twork)
+{
+	int ret;
+	struct super_block *sb;
+	static bool suppress;
+	struct drop_fs_caches_work *work = container_of(twork,
+			struct drop_fs_caches_work, task_work);
+	unsigned int ctl = work->ctl;
+	dev_t dev = work->dev;
+
+	if (work->path) {
+		struct path path;
+
+		ret = kern_path(work->path, LOOKUP_FOLLOW, &path);
+		if (ret) {
+			pr_err("%s (%d): %s: failed to get path(%s) %d\n",
+			       current->comm, task_pid_nr(current),
+			       __func__, work->path, ret);
+			goto out;
+		}
+		dev = path.dentry->d_sb->s_dev;
+		/* Make this file's dentry and inode recyclable */
+		path_put(&path);
+	}
+
+	sb = user_get_super(dev, false);
+	if (!sb) {
+		pr_err("%s (%d): %s: failed to get dev(%u:%u)'s sb\n",
+		       current->comm, task_pid_nr(current), __func__,
+		       MAJOR(dev), MINOR(dev));
+		goto out;
+	}
+
+	if (ctl & BIT(0)) {
+		lru_add_drain_all();
+		drop_pagecache_sb(sb, NULL);
+		count_vm_event(DROP_PAGECACHE);
+	}
+
+	if (ctl & BIT(1)) {
+		drop_sb_dentry_inode(sb);
+		count_vm_event(DROP_SLAB);
+	}
+
+	if (!READ_ONCE(suppress)) {
+		pr_info("%s (%d): %s: %d %u:%u\n", current->comm,
+			task_pid_nr(current), __func__, ctl,
+			MAJOR(sb->s_dev), MINOR(sb->s_dev));
+
+		if (ctl & BIT(2))
+			WRITE_ONCE(suppress, true);
+	}
+
+	drop_super(sb);
+out:
+	kfree(work->path);
+	kfree(work);
+}
+
+static int drop_fs_caches_sysctl_handler(const struct ctl_table *table,
+					 int write, void *buffer,
+					 size_t *length, loff_t *ppos)
+{
+	struct drop_fs_caches_work *work = NULL;
+	unsigned int major, minor;
+	unsigned int ctl;
+	int ret;
+	char *path = NULL;
+
+	if (!write)
+		return 0;
+
+	if (sscanf(buffer, "%u %u:%u", &ctl, &major, &minor) != 3) {
+		path = kstrdup(buffer, GFP_NOFS);
+		if (!path) {
+			ret = -ENOMEM;
+			goto out;
+		}
+
+		if (sscanf(buffer, "%u %s", &ctl, path) != 2) {
+			ret = -EINVAL;
+			goto out;
+		}
+	}
+
+	if (ctl < 1 || ctl > 7) {
+		ret = -EINVAL;
+		goto out;
+	}
+
+	work = kzalloc(sizeof(*work), GFP_KERNEL);
+	if (!work) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	init_task_work(&work->task_work, drop_fs_caches);
+	if (!path)
+		work->dev = MKDEV(major, minor);
+	work->path = path;
+	work->ctl = ctl;
+	ret = task_work_add(current, &work->task_work, TWA_RESUME);
+out:
+	if (ret) {
+		kfree(path);
+		kfree(work);
+	}
+
+	return ret;
+}
+
 static const struct ctl_table drop_caches_table[] = {
 	{
 		.procname	= "drop_caches",
@@ -88,6 +208,11 @@ static const struct ctl_table drop_caches_table[] = {
 		.extra1		= SYSCTL_ONE,
 		.extra2		= SYSCTL_FOUR,
 	},
+	{
+		.procname	= "drop_fs_caches",
+		.mode		= 0200,
+		.proc_handler	= drop_fs_caches_sysctl_handler,
+	},
 };
 
 static int __init init_vm_drop_caches_sysctls(void)
-- 
2.34.1


