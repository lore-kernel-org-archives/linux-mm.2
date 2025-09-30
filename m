Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6A34FCAC5B8
	for <linux-mm@archiver.kernel.org>; Tue, 30 Sep 2025 06:33:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C3C3C8E0030; Tue, 30 Sep 2025 02:33:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B9ED18E0002; Tue, 30 Sep 2025 02:33:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9CABA8E0030; Tue, 30 Sep 2025 02:33:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 705328E0002
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 02:33:53 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 3D5161A05D7
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 06:33:53 +0000 (UTC)
X-FDA: 83944951146.27.05C9EC7
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf18.hostedemail.com (Postfix) with ESMTP id 5CFC31C0005
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 06:33:51 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="KlifIr/3";
	spf=pass (imf18.hostedemail.com: domain of bhe@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=bhe@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759214031;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6TIT1FLJBTtkr/lqKHFpfAQFI3X55fNk3SQfyh38ojI=;
	b=oyBJR8kJQMyo7ItmC5TYaNZ1Hnna600U5E3pVyhGIzcgzRgSTbYVijj3y/04g/OGtB5G9D
	EDxWMyloCcPUEHm0i126S7qD/XoFvlmcHfwgT/O+uNgdAoscm8m2w51fM0PuTuPWkpB4pm
	XZEJXUncXYoAkvwPETaOQUosePfzNsk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759214031; a=rsa-sha256;
	cv=none;
	b=8QJSwvCXwdD8vGTtychZczugvAw4rZ1T4zOUNzXAE5gOvGy2vJ7O27CnGCWyxJfadABTsF
	qgtz0AEhVmAlNNYCRCUaFZ1lPk/dTX6ScE/Y6MtODsCbFL8WA1nvo3R4nTAI46H7TxVo2X
	v1BItMoO5HsRyeIfWP/X98wtjr2Ap4Q=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="KlifIr/3";
	spf=pass (imf18.hostedemail.com: domain of bhe@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=bhe@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1759214030;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6TIT1FLJBTtkr/lqKHFpfAQFI3X55fNk3SQfyh38ojI=;
	b=KlifIr/3omFu5t3pELDjhnjOUXl4bXpBY/ZYE1Ic/C9K4RzULn5SDQtB+aMIuJzTsxm9O2
	fidXuUubnv1gE8//LD16V5ITlW6DNmqCtlFFiZEQvJKeAnXpMvkcDZAoNjYeo6ImYQyCyt
	768o+/1GZLLI6Pa8mgcV2MwAlOX3zSs=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-295-8RVsAT1iNIeaeQPobpIFig-1; Tue,
 30 Sep 2025 02:33:47 -0400
X-MC-Unique: 8RVsAT1iNIeaeQPobpIFig-1
X-Mimecast-MFC-AGG-ID: 8RVsAT1iNIeaeQPobpIFig_1759214025
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B4B26180062F;
	Tue, 30 Sep 2025 06:33:30 +0000 (UTC)
Received: from MiWiFi-R3L-srv.redhat.com (unknown [10.72.112.181])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id D5EBB180035E;
	Tue, 30 Sep 2025 06:33:25 +0000 (UTC)
From: Baoquan He <bhe@redhat.com>
To: linux-mm@kvack.org
Cc: akpm@linux-foundation.org,
	chrisl@kernel.org,
	kasong@tencent.com,
	youngjun.park@lge.com,
	aaron.lu@intel.com,
	baohua@kernel.org,
	shikemeng@huaweicloud.com,
	nphamcs@gmail.com,
	Baoquan He <bhe@redhat.com>
Subject: [PATCH v3 2/2] mm/swap: select swap device with default priority round robin
Date: Tue, 30 Sep 2025 14:33:10 +0800
Message-ID: <20250930063311.14126-3-bhe@redhat.com>
In-Reply-To: <20250930063311.14126-1-bhe@redhat.com>
References: <20250930063311.14126-1-bhe@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 4evSe4jsv4pWN0KUN2ODMhZVgZCj9J3XCp1ld8rcAvU_1759214025
X-Mimecast-Originator: redhat.com
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 5CFC31C0005
X-Stat-Signature: 469k3z6i3nnpsubtzpo9xtkk7sxjwrz5
X-Rspam-User: 
X-HE-Tag: 1759214031-19728
X-HE-Meta: U2FsdGVkX19Qb0kZfhdk3kvM30zs9sdv34LmVoYzhfQ3VMoTSUKfleCby9ag4KEbvGZUbJeglElzVjZMsOsTudB/5+AZnFMz9FB4Iiuz8L7VUUXS0aFX/7GL+u+hP4Wso3P59peSio6qSjabXE10sQ8CyR6stzzZV+KXyG0gBV/QIVjjJCdp1ZFH9d6TKLr+VY7l2BQKx5L5ZP5+nY9qHg0eJ4BZuuc3EO1s3oS2T5ysrWt423r0IqPr6/OGL2R9rI3ykmgrrkJmJvgrPSYJeRpgHGmWwcf89a2Hu1n5mSo0ahK3hGxk9lsgKuxAgrNAsozDEEpSidshKi8S0WJlGzgCj+F061kC8PMVmUmievH2S56eHB/gs+g8b2Yu1JQ8k8DQXQgODWndd/O8ymNvIrNNcA/v665uSFT79h9iuiU5cUEwncQqL7wDnUG94DLNJKdu7b1FAlEhYXExk79E0Aa2XTU9Gxdt18o0i/VBfoAQdZtFSjezArYjuz88+mezf/Mv/dQ+SqR3/DhT5UFmZM1xa4vNsNgG19p7p8f5VlyjkHV58b73gowxFYNV13TAZQiCLr2Y7ZcDLKMpcJuG+EFzSv5I1aI5VQ3r2kjqLM27JMS7ycvvEJ3uhbclFNxJ+pygsoDNJLHfSeEOuwSwcG0iSW0D0Yuqry/S2g/jGscV5dZtAWrc7oL0XDllzJPpaiPo9A3MrG+AnzzJnONE13jC9TyzFE+zzyw3QbmFmwdBI5BWr4IlJKUEjbszh2wvLnpp+CLL2fotVCYKEd5ltngC5WUOG5HBp3FaFL7aEyJ+lVOIRWp1Wd7OlTR+i48BI3QI/HrOHVHQLQYaDSmXyzVdWi/IZ/2nFQaEcwXnW6rokneMRJauzvNGjEfW1+q/kApVirrW78WzPs+N+5pLcFcNsIjvPNIOhXMY/gZwmFzYIzLQtfUGYXu4rQErv7bcthTnMxqm3Q1r3MvCtje
 PRNYZUVf
 0GULKiYWZTojGHOtY6vQjo04M2WGnHPfV6ZkVtKrDCGmX2dik05Xz00DFPUosOIr3lg+7UF73Ndnt+fsfSqPiXHjQvOvfMZ1uVWFVfSadJ1jmjMj+yj8N96neK4Gl+lN6KVFxpOpU9khTIBM/Eae/9/R/QdDQh5nGIjKTAtz33vlHtRKxU9M4kuVq54JhhGYhuT2jBlawitlhr6broy4ZueygYRmMeQCDTScoLccRUOFvv4HnsxdKViDrizTID8NuXlDMhIzZwRB1L0unzYJjxqvXwpbLrJDSxb84PdzjhOy7LkjrxMVx/jO6hI0QSAenpFvBdLpELFgl14ZV3MjhdQK7WN9SA/WxtgKDKKz/3hrOWaZT4MsxKBCrVhc3L6O1Z7u/VFLEJdSotFb1y9dRZsAncdKMGXcCiS7e
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Swap devices are assumed to have similar accessing speed if no priority
is specified when swapon. It's unfair and doesn't make sense just because
one swap device is swapped on firstly, its priority will be higher than
the one swapped on later.

Here, set all swap devicess to have priority '-1' by default. With this
change, swap device with default priority will be selected round robin
when swapping out. This can improve the swapping efficiency a lot among
multiple swap devices with default priority.

Below are swapon output during processes high pressure vm-scability test
is being taken:

1) This is pre-commit a2468cc9bfdf, swap device is selectd one by one by
   priority from high to low when one swap device is exhausted:
------------------------------------
[root@hp-dl385g10-03 ~]# swapon
NAME       TYPE      SIZE   USED PRIO
/dev/zram0 partition  16G    16G   -1
/dev/zram1 partition  16G 966.2M   -2
/dev/zram2 partition  16G     0B   -3
/dev/zram3 partition  16G     0B   -4

2) This is behaviour with commit a2468cc9bfdf, on node, swap device
   sharing the same node id is selected firstly until exhausted; while
   on node no swap device sharing the node id it selects the one with
   highest priority until exhaustd:
------------------------------------
[root@hp-dl385g10-03 ~]# swapon
NAME       TYPE      SIZE  USED PRIO
/dev/zram0 partition  16G 15.7G   -2
/dev/zram1 partition  16G  3.4G   -3
/dev/zram2 partition  16G  3.4G   -4
/dev/zram3 partition  16G  2.6G   -5

3) After this patch applied, swap devices with default priority are selectd
   round robin:
------------------------------------
[root@hp-dl385g10-03 block]# swapon
NAME       TYPE      SIZE USED PRIO
/dev/zram0 partition  16G 6.6G   -1
/dev/zram1 partition  16G 6.6G   -1
/dev/zram2 partition  16G 6.6G   -1
/dev/zram3 partition  16G 6.6G   -1

With the change, we can see about 18% efficiency promotion relative to
node based way as below. (Surely, the pre-commit a2468cc9bfdf way is
the worst.)

vm-scability test:
==================
Test with:
usemem --init-time -O -y -x -n 31 2G (4G memcg, zram as swap)
                            one by one:      node based:      round robin:
System time:                1087.38 s        637.92 s         526.74 s     (lower is better)
Sum Throughput:             2036.55 MB/s     3546.56 MB/s     4207.56 MB/s (higher is better)
Single process Throughput:  65.69 MB/s       114.40 MB/s      135.72 MB/s  (high is better)
free latency:               15769409.48 us   10138455.99 us   6810119.01 us(lower is better)

Signed-off-by: Baoquan He <bhe@redhat.com>
---
 mm/swapfile.c | 31 ++++---------------------------
 1 file changed, 4 insertions(+), 27 deletions(-)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index f9b3667fb08a..2bd8bd76ea28 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -73,7 +73,7 @@ atomic_long_t nr_swap_pages;
 EXPORT_SYMBOL_GPL(nr_swap_pages);
 /* protected with swap_lock. reading in vm_swap_full() doesn't need lock */
 long total_swap_pages;
-static int least_priority;
+#define DEF_SWAP_PRIO  -1
 unsigned long swapfile_maximum_size;
 #ifdef CONFIG_MIGRATION
 bool swap_migration_ad_supported;
@@ -2534,10 +2534,7 @@ static void setup_swap_info(struct swap_info_struct *si, int prio,
 			    struct swap_cluster_info *cluster_info,
 			    unsigned long *zeromap)
 {
-	if (prio >= 0)
-		si->prio = prio;
-	else
-		si->prio = --least_priority;
+	si->prio = prio;
 	/*
 	 * the plist prio is negated because plist ordering is
 	 * low-to-high, while swap ordering is high-to-low
@@ -2555,16 +2552,7 @@ static void _enable_swap_info(struct swap_info_struct *si)
 	total_swap_pages += si->pages;
 
 	assert_spin_locked(&swap_lock);
-	/*
-	 * both lists are plists, and thus priority ordered.
-	 * swap_active_head needs to be priority ordered for swapoff(),
-	 * which on removal of any swap_info_struct with an auto-assigned
-	 * (i.e. negative) priority increments the auto-assigned priority
-	 * of any lower-priority swap_info_structs.
-	 * swap_avail_head needs to be priority ordered for folio_alloc_swap(),
-	 * which allocates swap pages from the highest available priority
-	 * swap_info_struct.
-	 */
+
 	plist_add(&si->list, &swap_active_head);
 
 	/* Add back to available list */
@@ -2692,17 +2680,6 @@ SYSCALL_DEFINE1(swapoff, const char __user *, specialfile)
 	}
 	spin_lock(&p->lock);
 	del_from_avail_list(p, true);
-	if (p->prio < 0) {
-		struct swap_info_struct *si = p;
-		int nid;
-
-		plist_for_each_entry_continue(si, &swap_active_head, list) {
-			si->prio++;
-			si->list.prio--;
-			si->avail_list.prio--;
-		}
-		least_priority++;
-	}
 	plist_del(&p->list, &swap_active_head);
 	atomic_long_sub(p->pages, &nr_swap_pages);
 	total_swap_pages -= p->pages;
@@ -3428,7 +3405,7 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
 	}
 
 	mutex_lock(&swapon_mutex);
-	prio = -1;
+	prio = DEF_SWAP_PRIO;
 	if (swap_flags & SWAP_FLAG_PREFER)
 		prio = swap_flags & SWAP_FLAG_PRIO_MASK;
 	enable_swap_info(si, prio, swap_map, cluster_info, zeromap);
-- 
2.41.0


