Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1EC58C4451B
	for <linux-mm@archiver.kernel.org>; Sat, 18 Jul 2026 12:34:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2E94D6B0099; Sat, 18 Jul 2026 08:34:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 272EC6B009D; Sat, 18 Jul 2026 08:34:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 113736B009E; Sat, 18 Jul 2026 08:34:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C82846B0099
	for <linux-mm@kvack.org>; Sat, 18 Jul 2026 08:34:47 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 5880FA03D0
	for <linux-mm@kvack.org>; Sat, 18 Jul 2026 12:34:47 +0000 (UTC)
X-FDA: 85001841414.01.7EF899A
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	by imf16.hostedemail.com (Postfix) with ESMTP id 8A135180002
	for <linux-mm@kvack.org>; Sat, 18 Jul 2026 12:34:45 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Awt84QJq;
	spf=pass (imf16.hostedemail.com: domain of liavalb@gmail.com designates 209.85.128.49 as permitted sender) smtp.mailfrom=liavalb@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784378085;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fyK9obKyx21C+ZaaJV9CzkRR6fotaVHFrnIZl4e1n9w=;
	b=kIG2wVajDU582WWnVaK+ZtqzWVoH54HjNUTbntK4fUXJ8nxgTK+Jqn6m1p7/kHFX9bGN1j
	eAS57VuCroiRnLXImWbwyfiGXF/Arw/1bLkiI/XNHCrLm63UrH6Q4BkMeiqQvEw5S02awO
	HFTPtamp9dMEmrMaLgP1ayFBPpcpzJw=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Awt84QJq;
	spf=pass (imf16.hostedemail.com: domain of liavalb@gmail.com designates 209.85.128.49 as permitted sender) smtp.mailfrom=liavalb@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784378085;
	b=w7wWmh6J4ilwrDK8McTaauRflmyuMpxBF1H0anoyXhnECNFpEFeRxj03uP8qxw2TdrMbfh
	Nv56KvR+59uS96hUDrN7gJ6LE+dAyorA8w9NIcDXSEuDcwA0H83NS5PtQQWA5oao1rnUO4
	hXooarU6ZCWTMJR2H3un8DNaJ6Rfi5k=
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-49555a0e68bso604095e9.2
        for <linux-mm@kvack.org>; Sat, 18 Jul 2026 05:34:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784378084; x=1784982884; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=fyK9obKyx21C+ZaaJV9CzkRR6fotaVHFrnIZl4e1n9w=;
        b=Awt84QJqSi0pju93Rp66jkkNu7iT1vvRELK060kFtVp528vAgyfawyJSWC9tFai7Eq
         uQMvqnVB3z5YaKv47Vhu5kpZSvmdcq41BgV6wRpPht8axdZ99avAigYaUtqkv+7WGM1D
         UdDTZ10HwKe5PdfnkCK7SlXUCCW3tkpuMF/cXUbb+7Cpay7NkQP+VxnFaqK0dzlgCEj7
         lVIa2aS9QX9Ym3w8i8RMoOFbrTjWi7UaK787sC576+DvElLO/xU8Q0j6HdGKL6IsL9yO
         84sVuVH0K7L+HITiaTSUKD0KjzHv2Z252FiKraVUKRv9OPP70ovN36KI+dK3/1WpAR1N
         /yAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784378084; x=1784982884;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=fyK9obKyx21C+ZaaJV9CzkRR6fotaVHFrnIZl4e1n9w=;
        b=av3Jv9wWvOGoOZAGveZE4RFEDMl1CR5iJe6Zxpu/JF7hf3wzNizqadQPGVAtEwnj3/
         HB5/OseGu2rtD6QZkQOAmrS+LS8ww3vAoxx8f/Qud5WfQTN4qxQ1UOqqs6nHQo75dDAL
         FjKNMtY9XQxeYnB3eIbs5ykeQHjC8fRhM7P2CRCtf3gK/Es0o1yRoC+HqBoK1B3yfjPf
         zbIToVUBPeo3CZxdqHYL241NobJqZtwXVDaqCeQdc6FzzJN4v61kaSwSuUBFFKWbWvLG
         iVJpK9UCUgkFgsen7ZM9/yGAFJXRCfcOmYgFt829XrY7ZAWSn9tKqtSWVqgn64/FEWMT
         vsYA==
X-Forwarded-Encrypted: i=1; AHgh+RrXc2AM1pPU0SJAGyXKpIItcJpRChexRSwXW5hLAbuWeP+s4eYlziEW8SMREsKVVgc1JG4ErxSbXg==@kvack.org
X-Gm-Message-State: AOJu0Yy5FyMr5gurtLa2R4bdX6SFSD463y0EQgpBNTFUffNkg5RDg4Wm
	ITldm1k62P5CNmWXfU47nyL/OBVyICLX4bgg78X1dAEfYe1qmVQXN5of
X-Gm-Gg: AfdE7clBzTXe+nTuSr2iw1meRIxSlIkg8VpXtVA6DJmg0tCBZ6KVKmGDmhOagNz4kKJ
	Bq9qLyChZBx2HmPNQFzsOR0B9gGVy2GQHh58LqEx4xToAAWS3da8Ictk1s6DscpEhm1u2zO7xqq
	6qSM5WUYoiWM8lSowthvaYAJrdGYueO0wrl6joniw7P+9fHS7EPcjzM8IRiP4o3vd/nFoNkFgXF
	3C0Ale5hSzrs61pYOdssSxSFBQSTJzthU9zLF/6LhLY1nrO+14GTrMQ+r2ofPVBIlPNFU37YcuV
	zq5KJ9PAKjj45ZAija27Tmhf/yU1NmrAawsHReEJq54ZlY/qni6PCy2ZJgnILm1T5UV24QRHsxX
	vNrerYK/YspuriMG5bp4WlnHySEGZKl+WQy5BYBevA+RYYUya/9avTV5FneJOW3+asKb8VLnxWu
	oKN5JXFHgiunz9
X-Received: by 2002:a05:600c:c0c3:10b0:493:72d3:4a81 with SMTP id 5b1f17b1804b1-4954a3dc87bmr55989155e9.16.1784378084218;
        Sat, 18 Jul 2026 05:34:44 -0700 (PDT)
Received: from liavpc.localdomain ([2a06:c701:4900:1700:d578:12e4:b9d6:6e36])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49549a35830sm129041165e9.3.2026.07.18.05.34.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 Jul 2026 05:34:43 -0700 (PDT)
From: Liav Albani <liavalb@gmail.com>
To: akpm@linux-foundation.org
Cc: david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	jannh@google.com,
	pfalcato@suse.de,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Liav Albani <liavalb@gmail.com>
Subject: [PATCH] mm/vma: fix imbalanced file reference count, properly abort mmap_prepare
Date: Sat, 18 Jul 2026 15:34:17 +0300
Message-ID: <20260718123417.16339-2-liavalb@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260718123417.16339-1-liavalb@gmail.com>
References: <20260718123417.16339-1-liavalb@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 8A135180002
X-Stat-Signature: m3dd6qaf8gxe3pz5n6i7skpr43f69m1j
X-HE-Tag: 1784378085-565491
X-HE-Meta: U2FsdGVkX19yxLAwAKmuYtX3UKJNb/K33/GBFzE8QNJIuFtzArOcV/pvdKvoipDqkItQoS+DmMW/EjJ5A6MIWzVnpZVkzu87TjCO+MoDUwDQfvEmnVJAP6Jk/a58CN3ORep1aMSYf73T8bMQTTfYkZomvUMeX5h3N7L62QmC08O9i95mxlYL46gqJDJFUjLJ/6SF1Iu2O2XNpQyD/h6q/H4jGV7wAmkWcUMyV8KWazhewqQY5Dkfy0yUCGaRJkg2KzyDow+Dfp/+8uUtm6ufQecTn4g4ZhBgVqMl2effi+wEf8xvrcKbcIGk4Ga/B+lVY4Mcf7OMY6h6YaEvQD87jtGGWCyNC1kEJVsN/2TP08/o8Gcp+7Y9zx4AEuqhN/bG5TI3mp6VDMoasB12cxkxfaSRWqAnocn4dnnb4BKNOZr7Kl3j+vdTz3wfZAGLFHMSkBBvbtn9NrkJZu0OXWHNx9cqm5kQbzuunlS6pqHucAk9n5BgXigjQiP8ApI4qmmdFebQ+oj2Tji1NqYvU6dndRcklOa0nC1X2e8/BW6q4Dbn3AckgVPKL6Ca3hrvovt6gfnE2J/HSL1CWd0o8w4bdnigam1WxvhYWZA1tDBxG1hTEWULs6ryDJMp9DVTIE3khd6kIx9yh8EY18Qm1929htTZJk5hKStsDgXTnK3C3TvE5mZJePy1siOJc1Q3UTBs38uqw+lRE4cMKdC1ZReR/U0moMpVVKdhcgWAcrzqI+Ig5nzUMvHVbZlVRdroXzOt5S/Yk6tzl4a9Yyob3OY/RpAR4P4UtpNDyfk5kc69oic3BbKMOeTaYnJNNyDHnMLCF/Rq3Oa4UtmV3cyOcUjyK6Q/fZt9K0eJZFBO3UnmVUVWogLSw8Dv13/x/7rNvhnOtmTX/WlhLn84xVcrQ2rod3tXnErCH4USVPo5pWkFR9Rr/W7sIhFEdidI4xw5lGTGIPn8hXLP0aejhF0zjag
 mqWxFIpF
 OpbrfBwu2hhnoYmMmKpKi5wGeJB0jXaMh1EwQzJmHBvkhBBq1Oa5VLaeRYNmI2KoKA38AETFrdN/e7VolKq6/ZAKcHw+9oxICOxCJoASslQ5GAhK+wK7H3h6CSznL54LXbwhOhW4BC4cUoqfHSgwRlprJFHFyZfPDXxxBIapV4g4gwVv1qBVgIDrf5aN2QjdpJe/S2NyFX+PbMpuGA6ggfx0u+Mf0ySXnDsSYMu97l9U9SqLuGzME5c8kfWA1rfJPeQm6jvNm2T7gm48JggeQKRK69URHI++rfH/YcimqzopncjHdCI+XapISXVlMAZ15Cm4+dO4jtI9pgloqOW99wpXF9KSpsi6eDyjMFkTx4rtei+GLxCvxWJACJMKZ8b5JvTuW9kVDUBdiLP0bujZshQpJVtW9nvatFlXC1vj4OH49YNhfjKToXXHrshDQ1rY1kgMDtM61bJ8kKZfWf5L4GsxK8A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Under the new `vm_area_desc` struct, a driver may change the vm_file
to provide a different backing VM file.

In such case, it became apparent during testing of this capability, that
a remove_vma() may drop a refcount on a VM file that we didn't call
get_file() upon.

In addition to that, calling vms_abort_munmap_vmas when we didn't do
actual work is wrong, because mmap_prepare hook is about preparing the
mmap state and not performing any actual mapping (yet).

A kernel stack (before of this patch) could look like this:

imbalanced put on file reference count
WARNING: fs/file.c:36 at __file_ref_put_badval.isra.0+0x3f/0x60, CPU#1: test_proxy_mmap/116
Modules linked in: ufedm(OE) virtio_net net_failover failover nandsim nand nandcore bch mtd
CPU: 1 UID: 0 PID: 116 Comm: test_proxy_mmap Tainted: G           OE       7.2.0-rc3-gaf5e34a41cd6 #1 PREEMPT(full)  bdadc55b51524b311c430c1536a97e7071150fd3
Tainted: [O]=OOT_MODULE, [E]=UNSIGNED_MODULE
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS Arch Linux 1.17.0-2-2 04/01/2014
RIP: 0010:__file_ref_put_badval.isra.0+0x3f/0x60
Code: 85 f6 78 05 c3 cc cc cc cc 48 b8 00 00 00 00 00 00 00 a0 48 89 07 c3 cc cc cc cc 48 83 ec 08 48 89 3c 24 48 8d 3d 61 bc 30 02 <67> 48 0f b9 3a 48 ba 00 00 00 00 00 00 00 e0 48 8b 04 24 48 89 10
RSP: 0018:ffffc900006bbae8 EFLAGS: 00010296
RAX: bfffffffffffffff RBX: ffff88810409a180 RCX: 0000000038748000
RDX: ffff888100a44480 RSI: dfffffffffffffff RDI: ffffffff83b12730
RBP: ffffc900006bbbf8 R08: 0000000000000000 R09: 00007f8b49f8f000
R10: ffffc900006bbba0 R11: ffff88810409a208 R12: ffffc900006bbba0
R13: 00007f8b4a179000 R14: ffff888102222440 R15: 0000000000015040
FS:  0000000038726400(0000) GS:ffff8881b77d1000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000038728618 CR3: 0000000104a1c006 CR4: 0000000000370ef0
Call Trace:
 <TASK>
 __file_ref_put+0x30/0x40
 fput+0x4f/0x80
 remove_vma+0x42/0x60
 vms_complete_munmap_vmas+0x179/0x230
 do_vmi_align_munmap+0x225/0x2a0
 do_vmi_munmap+0xe6/0x1c0
 __vm_munmap+0x113/0x200
 __x64_sys_munmap+0x1b/0x30
 do_syscall_64+0xaa/0x660
 ? ksys_mmap_pgoff+0x168/0x200
 ? do_syscall_64+0xaa/0x660
 ? vfs_write+0x281/0x560
 ? ksys_write+0x7b/0x110
 ? do_syscall_64+0xaa/0x660
 ? do_syscall_64+0x5f/0x660
 ? clear_bhb_loop+0x30/0x80
 ? clear_bhb_loop+0x30/0x80
 entry_SYSCALL_64_after_hwframe+0x76/0x7e
RIP: 0033:0x440bcb

Signed-off-by: Liav Albani <liavalb@gmail.com>
---
 include/linux/mm_types.h |  1 +
 mm/vma.c                 | 24 +++++++++++++-----------
 2 files changed, 14 insertions(+), 11 deletions(-)

diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index b18c2b2e7d2c..5db0894e6064 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -981,6 +981,7 @@ struct vm_area_struct {
 	unsigned long vm_pgoff;		/* Offset (within vm_file) in PAGE_SIZE
 					   units */
 	struct file * vm_file;		/* File we map to (can be NULL). */
+	bool vm_file_doesnt_need_put; /* Do fput only if we did get_file... */
 	void * vm_private_data;		/* was vm_pte (shared mem) */
 
 #ifdef CONFIG_SWAP
diff --git a/mm/vma.c b/mm/vma.c
index 9eea2850818a..0c2e71fc09be 100644
--- a/mm/vma.c
+++ b/mm/vma.c
@@ -467,7 +467,7 @@ void remove_vma(struct vm_area_struct *vma)
 {
 	might_sleep();
 	vma_close(vma);
-	if (vma->vm_file)
+	if (vma->vm_file && !vma->vm_file_doesnt_need_put)
 		fput(vma->vm_file);
 	mpol_put(vma_policy(vma));
 	vm_area_free(vma);
@@ -2487,6 +2487,7 @@ static int __mmap_new_file_vma(struct mmap_state *map,
 	int error;
 
 	vma->vm_file = map->file;
+	vma->vm_file_doesnt_need_put = map->file_doesnt_need_get;
 	if (!map->file_doesnt_need_get)
 		get_file(map->file);
 
@@ -2497,7 +2498,14 @@ static int __mmap_new_file_vma(struct mmap_state *map,
 	if (error) {
 		UNMAP_STATE(unmap, vmi, vma, vma->vm_start, vma->vm_end,
 			    map->prev, map->next);
-		fput(vma->vm_file);
+
+		/*
+		 * We set vma->vm_file to map->file, so if we didn't increase
+		 * the refcount, don't decrease it in this path.
+		 */
+		if (!map->file_doesnt_need_get)
+			fput(vma->vm_file);
+
 		vma->vm_file = NULL;
 
 		vma_iter_set(vmi, vma->vm_end);
@@ -2757,7 +2765,7 @@ static unsigned long __mmap_region(struct file *file, unsigned long addr,
 	if (!error && have_mmap_prepare)
 		error = call_mmap_prepare(&map, &desc);
 	if (error)
-		goto abort_munmap;
+		goto abort_mmap_prepare;
 
 	if (map.check_ksm_early)
 		update_ksm_flags(&map);
@@ -2795,15 +2803,9 @@ static unsigned long __mmap_region(struct file *file, unsigned long addr,
 unacct_error:
 	if (map.charged)
 		vm_unacct_memory(map.charged);
-abort_munmap:
-	/*
-	 * This indicates that .mmap_prepare has set a new file, differing from
-	 * desc->vm_file. But since we're aborting the operation, only the
-	 * original file will be cleaned up. Ensure we clean up both.
-	 */
-	if (map.file_doesnt_need_get)
-		fput(map.file);
+
 	vms_abort_munmap_vmas(&map.vms, &map.mas_detach);
+abort_mmap_prepare:
 	return error;
 }
 
-- 
2.55.0


