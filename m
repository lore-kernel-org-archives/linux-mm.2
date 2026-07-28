Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3D4F4C54F4C
	for <linux-mm@archiver.kernel.org>; Tue, 28 Jul 2026 08:05:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E3E666B0088; Tue, 28 Jul 2026 04:05:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DEE5B6B008C; Tue, 28 Jul 2026 04:05:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D04C06B0093; Tue, 28 Jul 2026 04:05:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A286D6B0088
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 04:05:28 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id EE9E3802BA
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 08:05:27 +0000 (UTC)
X-FDA: 85037450694.07.DA5457D
Received: from canpmsgout02.his.huawei.com (canpmsgout02.his.huawei.com [113.46.200.217])
	by imf02.hostedemail.com (Postfix) with ESMTP id 20C648000C
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 08:05:23 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=vANbt9qT;
	spf=pass (imf02.hostedemail.com: domain of yujiacheng3@huawei.com designates 113.46.200.217 as permitted sender) smtp.mailfrom=yujiacheng3@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785225926;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=qeEHNIkKfEE/MPymA/wgyzwl3wWMgxhik29ZB4abPLY=;
	b=XVHJ8AUwbIuyK9ARDlYdsU6rKwenIZOxQBGGgJteH0aKQFXoWx2E2eo5nEyH/Xs5mREKNc
	2QmFGp7X7UyoJtkekMQN7ixX+nu+v8TLF7SRTXwWD0xGdPrsJDluT3LHswdcKPEftAkC6i
	85XmfGg5Qyq1zAE4YxE0GPvdgoEzRcM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785225926;
	b=3GGNjidgAF9eEn8zYVDileSDq5e+/mj0ixoAWQ/KXo/d9Khox8XjuY0vtm8U+tBjGNHkJN
	W0t5H8Dd2RCEaBwoh4XVRlhEsGWGanYT27zzbThQlJCPxNQekpW769p8dfgQ89SDoW6tEz
	wXt1yrdgeR9lkufsYb7uUmPBJC8q6VU=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=vANbt9qT;
	spf=pass (imf02.hostedemail.com: domain of yujiacheng3@huawei.com designates 113.46.200.217 as permitted sender) smtp.mailfrom=yujiacheng3@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=qeEHNIkKfEE/MPymA/wgyzwl3wWMgxhik29ZB4abPLY=;
	b=vANbt9qTV/QGqyMwh475XxbonwsxoysdOKmwwjiaJDeC+KYaDOGVKf8SDboKX4ZuT5qMOGGjR
	8th46FCD/LwydHda1SzVwRE23Julu/mL0c7+PoLPHrjxMnikAT00oDOm1skgRiTmMZjnek4gVSK
	h0y36SjtEkJz6d1GxS//zJg=
Received: from mail.maildlp.com (unknown [172.19.162.140])
	by canpmsgout02.his.huawei.com (SkyGuard) with ESMTPS id 4h8SST24Grzcb0W;
	Tue, 28 Jul 2026 15:55:37 +0800 (CST)
Received: from whupemo500009.china.huawei.com (unknown [7.152.184.116])
	by mail.maildlp.com (Postfix) with ESMTPS id E581A202E6;
	Tue, 28 Jul 2026 16:05:16 +0800 (CST)
Received: from localhost (10.50.87.202) by whupemo500009.china.huawei.com
 (7.152.184.116) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Tue, 28 Jul
 2026 16:05:15 +0800
From: Jiacheng Yu <yujiacheng3@huawei.com>
To: <hughd@google.com>
CC: <baolin.wang@linux.alibaba.com>, <akpm@linux-foundation.org>,
	<linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
	<liuyongqiang13@huawei.com>, Jiacheng Yu <yujiacheng3@huawei.com>
Subject: [PATCH] mm/shmem: downgrade final i_blocks check in shmem_evict_inode() to pr_warn()
Date: Tue, 28 Jul 2026 09:10:14 +0000
Message-ID: <20260728091014.3876715-1-yujiacheng3@huawei.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.50.87.202]
X-ClientProxiedBy: kwepems500002.china.huawei.com (7.221.188.17) To
 whupemo500009.china.huawei.com (7.152.184.116)
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 20C648000C
X-Stat-Signature: 4nrq8difu6firwij86e73gnmuy6u6xm8
X-HE-Tag: 1785225923-210700
X-HE-Meta: U2FsdGVkX19gcEWN3HG8IiSpCD+jKhsLZXY/9eJFUuKiadsJcyyeWvlPNT/WqCKezhtEUqWngpjp1gxesoAcZRib+p2hnGJreJwksIan6Wm2lX3n5Oelee5uArBsgwGZ+ZnTgYF3W6ykvbBXqPTFsW2VmA1ziziVu0i42X8Rd/09rXqB4PW11D2x57TlZkCYnNXrdt5mu5djZkXgaKH/dcEnClRJstjhCm7cbcLzsB2Xau1nIuiLzAbZZapQSpzbPdD0bkLLLdAiPF+1G45CNxJ8XtJvtyqLtdkpWmARd+E99d9IS8qoZOlG6QgNbJXUNthA2N+hGIJIU4uwm4jivMS56UiUx9WYu4dKwyRpfhxm15wU1IzTgTwU15wjMIta0hiUog9z8cb8O/omKoe0UGmlxVvWP1ozXxsS6Oc4/Eumnlacpc8wpzC7pWgmPIDGFkFvYF6a14aRzlPfnnLBChCjVQwxu4tMyhChSHBAvTGVnwrfnn0pleTGWE96FvdWRA9uJLS28nyVZfMAcDcApR9cksFIJizbght2f+8M1rdz7IQQpHVh9fahO3QZkZNRUK26Si7U/DNdrM/uq977PGnYgeNtF9AZGppOKeVgcudljl1lWDesiqfnDbZUHfrGQ3sXN5uux2wBM/Kv2Pa6SE3kzfPz/2YZDGnTq4J9cYG1G+eW2hRANhWkwb6yt79oNFIt1mkdeOK69KBOf5HIQY00V+jcz7MPM/0wjcbHKvYGBLpuqv9j48a5XD6An1F4MWO/EGjnY4DBdhRo9cnCO0DCglVgc9bL19cW1YUyzGhLaycw0XTBvuu903jMINghpkIO7faZrzmBVMdC6SxTjGwgG4mUua7g3DSWGcTjSd3WlJrRy1wSSzKV05oDyKAG58kzjplpz+R2WutiYCUhzki4uiAS5MSUXLtCGX6G46OoKfio6Ofd4La4dozKQl9ZiM7xqwLdtfXUdcfjzN9
 ZQUBbiDQ
 rtqB8GIQjBkxxBGyYiqQDsZnLCgg7D+h2WeIE0YMtsIZLD9HbvEv6+RhR/VCgc0vAEBW4IiiaWBlpUnjJJCpzl8LgqSA5kFkjEI/RjbsvKJOh81rPcI5NfUmzs/7y74L18KoGGkhL2YoyuhagRcsjXSBuZmv/BQsLxMuoovBW6hjy234bbAKKYSOzmyFeAbdVXfY7kdD9Oiq5hzjhMRqqXWNIwHtxSyS3o/P5Kf9M0Noy/l/bPoj2qXutB/1dhtMl2+5ap/FeJnU48HaeOqgEcSpl6ls8jTCsCAnDfbpNtyNYaaI5DSu5/29MoiCJI6xgsR5jxWmXxVrIl6WMebj/aRDbtOtmMYhO785DiLwyJZBE3ZLuS9LQWUXwkn7Qb96g3now
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

shmem_evict_inode() ends with WARN_ON(inode->i_blocks) as a final
consistency check of shmem's block accounting.  When it fires, the
inode-local counters die with the inode; what may linger is a small
residue in accounting kept outside the inode, such as per-mount or
per-user charges.  No data is lost, and no corruption follows.

On kernels running with panic_on_warn=1, this accounting inconsistency
escalates to a full machine panic, which is disproportionate to the impact.

Downgrade the WARN_ON() to a pr_warn() that reports the inode together
with its accounting counters (i_blocks, alloced, swapped, nrpages),
keeping the inconsistency visible in the logs.

The accounting bugs this check has caught over the years -- the
swapout race described in commit 0f3c42f522dc ("tmpfs: change
final i_blocks BUG to WARNING") and the error recovery race fixed
in commit 267a4c76bbdb ("tmpfs: fix shmem_evict_inode() warnings
on i_blocks") -- are real and should still be fixed; this change
only removes the disproportionate escalation.

Fixes: 0f3c42f522dc ("tmpfs: change final i_blocks BUG to WARNING")
Signed-off-by: Jiacheng Yu <yujiacheng3@huawei.com>
---
One way to hit this race: soft_offline_in_use_page()'s fast path drops
a clean, unmapped shmem folio via mapping_evict_folio(), where the
xas_store() and the nrpages decrement are not atomic against a
concurrent shmem_evict_inode(); the final shmem_recalc_inode() can
then read the pre-decrement nrpages, compute freed = 0, and leave one 
page charged.  Same class as the races in 0f3c42f522dc and            
267a4c76bbdb, this time in the under-count direction; reproduced on   
7.2-rc4 with madvise(MADV_SOFT_OFFLINE) racing MAP_FIXED replacement  
of a shared-anonymous VMA.

 mm/shmem.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index b51f83c970bb..223484cdc8f2 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1428,7 +1428,11 @@ static void shmem_evict_inode(struct inode *inode)
 	simple_xattrs_free(&sbinfo->xa_cache, &info->xattrs, sbinfo->max_inodes ? &freed : NULL);
 
 	shmem_free_inode(inode->i_sb, freed);
-	WARN_ON(inode->i_blocks);
+	if (inode->i_blocks)
+		pr_warn("%s: ino=%llu i_blocks=%llu alloced=%lu swapped=%lu nrpages=%lu\n",
+			__func__, (unsigned long long)inode->i_ino,
+			(unsigned long long)inode->i_blocks,
+			info->alloced, info->swapped, inode->i_mapping->nrpages);
 	clear_inode(inode);
 #ifdef CONFIG_TMPFS_QUOTA
 	dquot_free_inode(inode);
-- 
2.34.1


