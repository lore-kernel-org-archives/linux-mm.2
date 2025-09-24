Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E0137CAC5A5
	for <linux-mm@archiver.kernel.org>; Wed, 24 Sep 2025 09:18:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1F6878E0002; Wed, 24 Sep 2025 05:18:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1CDEE8E0001; Wed, 24 Sep 2025 05:18:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0E4248E0002; Wed, 24 Sep 2025 05:18:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E30228E0001
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 05:18:05 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 959ED1DFEE3
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 09:18:05 +0000 (UTC)
X-FDA: 83923592130.12.C4AEB6B
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf30.hostedemail.com (Postfix) with ESMTP id AD13F80005
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 09:18:03 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=jEzOnJVw;
	spf=pass (imf30.hostedemail.com: domain of bhe@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=bhe@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758705483;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=CQfjef4kEb8JhiSk4N7cSk1E0nFKYC18vxJZDtNCbWk=;
	b=AN1Vuwz5+kRnCmMdnhM8k75sqcNK3YaVjrJBxmA8x4AtAPc3ZUvwNa9zYbC7UaIJmyFUqY
	C84bhc4j1x9lSDRMrlcFin53oD1BKuZRmBdZvRnibapWynuW24+pNAXC9zX6v4E2uzEryA
	0RpBirL6scKaO2ATUCd2b7e30dVE1WE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758705483; a=rsa-sha256;
	cv=none;
	b=45C7xTO6DIAqYBInx93b/THWnTKifxOBzP535oAGKv+p1niFVUc7la6qxvL/NMahYvCvN+
	W7k/XO4+TY5mCHpQP0ECH2SmcbflNCFkREfIDXK3JAkixJ0HoX4x6KwQXNO9I7EGv7Dcfp
	milh8yPn5kWIxKB2vMd2at7TOztcRzI=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=jEzOnJVw;
	spf=pass (imf30.hostedemail.com: domain of bhe@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=bhe@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758705483;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=CQfjef4kEb8JhiSk4N7cSk1E0nFKYC18vxJZDtNCbWk=;
	b=jEzOnJVw5Lllxva7Q2QIX2wmw6kLD1tfVmURVM/3GB8mxLvSzLdW2RybMGpcPBmtghvPN8
	HoH83ejhA2sw9emymMRFt8fzUSmUa4OhJuhbZLnzHjD0MIokB28sVvchDloqWXDvkzDGUn
	VsXfHBP8CoPgUTh3GbSzca1GEBpMHUQ=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-532-_7XxDVmNPf2-bQDbbBwAxg-1; Wed,
 24 Sep 2025 05:17:59 -0400
X-MC-Unique: _7XxDVmNPf2-bQDbbBwAxg-1
X-Mimecast-MFC-AGG-ID: _7XxDVmNPf2-bQDbbBwAxg_1758705478
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id ADA90195605C;
	Wed, 24 Sep 2025 09:17:57 +0000 (UTC)
Received: from MiWiFi-R3L-srv.redhat.com (unknown [10.72.112.54])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 5095C180035E;
	Wed, 24 Sep 2025 09:17:52 +0000 (UTC)
From: Baoquan He <bhe@redhat.com>
To: linux-mm@kvack.org
Cc: akpm@linux-foundation.org,
	chrisl@kernel.org,
	kasong@tencent.com,
	baohua@kernel.org,
	shikemeng@huaweicloud.com,
	nphamcs@gmail.com,
	Baoquan He <bhe@redhat.com>
Subject: [PATCH] mm/swapfile.c: select the swap device with default priority round robin
Date: Wed, 24 Sep 2025 17:17:46 +0800
Message-ID: <20250924091746.146461-1-bhe@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: fjtZ_1V1H4Mavxe_HvDW29kc-u02RZ-COFc9usyMLXs_1758705478
X-Mimecast-Originator: redhat.com
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: AD13F80005
X-Stat-Signature: odcfpj847nrh5hpeh8b744f5m89h4r75
X-Rspam-User: 
X-HE-Tag: 1758705483-585738
X-HE-Meta: U2FsdGVkX18eIzIiM8zNCex1FGWRwHrSF0RzQ8zJXUFtbUYwbaNXQu6iFEhcKA5ML40CwSodqo3Jc2L9ZC9jLU+lL+Dwx1jn4taSVyYhVcp6Cg4G1clUd8xf3GVXqO/kf3KObQVENIeufLUEVYqClGiq/j+VyAJNthQmVpTrzcfaTTyIWKsG6syJ7dftwOoaU9T36Ayu8KvEn2RvJ4mKCS3+sD31g+9PdcV+CaBblEzBgeM0a9OcqqDVsoIqwWPC5C4sYmTOfqORHV0Hr6XS5cWXGCy5gtKjgHaWd/KezPS019XicjkGZSBFEjHq3PoymGIh3AjlMX9JB+MgfulOnj+XKaCJ+oACsuwVAZk7aFNYFYZZsL9IpvBLera1j6c/nGitq/QXXfRwmkj2QngiuxiC83vCrcId1Q1lXX4QttkbV/OJBddW8eQBfx0mxpGHa/+XM55barHBl440ZzUf7JOSsQ3ytEtGdZFgQoSVjIsfjhTArA+YOGT0ef7epioGFJelcNYlPU7U8ppUdNV1dQ5ORwevIqvTz69q/mqt0Ezjto1jtRLQiSI3fyGAanXuZ3KSkcMiTewnB6cnN5392fHOE5VbBM6iqFW2K4b0QU3qO2acFJJhAU3aNKp5PFQmzigutngXpeX9lardfy9OeOOnFhT4USdy4URrKWa/dQg04esj9Iy9kQSJ+TfbldNXtzuAmOiwW4w9ewpnveEmXdz3thLBL2j6jFk+tWvagWt64LM1SK+xVvwIxqjXr9OLmuP+My1UliWyse7YYPw3wb3Yx/TAQV/76JLEthk1DkCoxDjJBDzDQ4TXy2BBdzQcJJ6rSsVK3Xk92sDCuDyr3UHk/Ettxe4NI9LFR/Z20meD0uAKVnA5EAXD+UulKwwU61j5hG/++lRkrDqPUg4Qbe3AYrTSk0HIVNmZiavdH09mn1X3XnblfCPwbnnWv1GPhyO+jBhkxGM4p2HHqBm
 UJNB5xkX
 LY9xfZ5dT4GqhIM5VHEIZHbRyUvIll66bs7tDSWsxAhsLzTa/XVV5OXr2IcdTRYbe8uNTEfOg+dP4jQnOah4qduTy5YEeDpMIYOAjVf9xMMzWUADXW2LYHODlHAkOGYqMY0i4t69H6Gl+zCpYa/0uYqwWHNriGKUBnWD5YZq599AGVyBuQMHuna7F6bdr8byJPNPm2dqeyjHF9a/5gYtuDsRq+Z7Hrjo73PZUcJ6r2HYy41ShZrNukyunpIt663aTCumoVFqSaU1ZzapkWM8ZcCzOuUltYpdMPFPzqoNzR22MQ6QpnewyV+ozuR9lbZ6tvUI9KBTNvtjT19/PnFJ7Y6z5rgGpHKD71IdVTUZY3IYrdpIfYwr+K/zyL7DiPS8anEhgH4hruPJn6bM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Currently, on system with multiple swap devices, swap allocation will
select one swap device according to priority. The swap device with the
highest priority will be chosen to allocate firstly.

People can specify a priority from 0 to 32767 when swapon a swap device,
or the system will set it from -2 then downwards by default. Meanwhile,
on NUMA system, the swap device with node_id will be considered first
on that NUMA node of the node_id.

In the current code, an array of plist, swap_avail_heads[nid], is used
to organize swap devices on each NUMA node. For each NUMA node, there
is a plist organizing all swap devices. The 'prio' value in the plist
is the negated value of the device's priority due to plist being sorted
from low to high. The swap device owning one node_id will be promoted to
the front position on that NUMA node, then other swap devices are put in
order of their default priority.

E.g I got a system with 8 NUMA nodes, and I setup 4 zram partition as
swap devices.

Current behaviour:
their priorities will be(note that -1 is skipped):
NAME       TYPE      SIZE USED PRIO
/dev/zram0 partition  16G   0B   -2
/dev/zram1 partition  16G   0B   -3
/dev/zram2 partition  16G   0B   -4
/dev/zram3 partition  16G   0B   -5

And their positions in the 8 swap_avail_lists[nid] will be:
swap_avail_lists[0]: /* node 0's available swap device list */
zram0   -> zram1   -> zram2   -> zram3
prio:1     prio:3     prio:4     prio:5
swap_avali_lists[1]: /* node 1's available swap device list */
zram1   -> zram0   -> zram2   -> zram3
prio:1     prio:2     prio:4     prio:5
swap_avail_lists[2]: /* node 2's available swap device list */
zram2   -> zram0   -> zram1   -> zram3
prio:1     prio:2     prio:3     prio:5
swap_avail_lists[3]: /* node 3's available swap device list */
zram3   -> zram0   -> zram1   -> zram2
prio:1     prio:2     prio:3     prio:4
swap_avail_lists[4-7]: /* node 4,5,6,7's available swap device list */
zram0   -> zram1   -> zram2   -> zram3
prio:2     prio:3     prio:4     prio:5

The adjustment for swap device with node_id intended to decrease the
pressure of lock contention for one swap device by taking different
swap device on different node. However, the adjustment is very
coarse-grained. On the node, the swap device sharing the node's id will
always be selected firstly by node's CPUs until exhausted, then next one.
And on other nodes where no swap device shares its node id, swap device
with priority '-2' will be selected firstly until exhausted, then next
with priority '-3'.

This is the swapon output during the process high pressure vm-scability
test is being taken. It's clearly shown zram0 is heavily exploited until
exhausted.
===================================
[root@hp-dl385g10-03 ~]# swapon
NAME       TYPE      SIZE  USED PRIO
/dev/zram0 partition  16G 15.7G   -2
/dev/zram1 partition  16G  3.4G   -3
/dev/zram2 partition  16G  3.4G   -4
/dev/zram3 partition  16G  2.6G   -5

This is unreasonable because swap devices are assumed to have similar
accessing speed if no priority is specified when swapon. It's unfair and
doesn't make sense just because one swap device is swapped on firstly,
its priority will be higher than the one swapped on later.

So here change is made to select the swap device round robin if default
priority. In code, the plist array swap_avail_heads[nid] is replaced
with a plist swap_avail_head. Any device w/o specified priority will get
the same default priority '-1'. Surely, swap device with specified priority
are always put foremost, this is not impacted. If you care about their
different accessing speed, then use 'swapon -p xx' to deploy priority for
your swap devices.

New behaviour:

swap_avail_list: /* one global available swap device list */
zram0   -> zram1   -> zram2   -> zram3
prio:1     prio:1     prio:1     prio:1

This is the swapon output during the process high pressure vm-scability
being taken, all is selected round robin:
=======================================
[root@hp-dl385g10-03 linux]# swapon
NAME       TYPE      SIZE  USED PRIO
/dev/zram0 partition  16G 12.6G   -1
/dev/zram1 partition  16G 12.6G   -1
/dev/zram2 partition  16G 12.6G   -1
/dev/zram3 partition  16G 12.6G   -1

With the change, we can see about 18% efficiency promotion as below:

vm-scability test:
==================
Test with:
usemem --init-time -O -y -x -n 31 2G (4G memcg, zram as swap)
                           Before:          After:
System time:               637.92 s         526.74 s
Sum Throughput:            3546.56 MB/s     4207.56 MB/s
Single process Throughput: 114.40 MB/s      135.72 MB/s
free latency:              10138455.99 us   6810119.01 us

Suggested-by: Chris Li <chrisl@kernel.org>
Signed-off-by: Baoquan He <bhe@redhat.com>
---
 include/linux/swap.h | 11 +-----
 mm/swapfile.c        | 94 +++++++-------------------------------------
 2 files changed, 16 insertions(+), 89 deletions(-)

diff --git a/include/linux/swap.h b/include/linux/swap.h
index 3473e4247ca3..f72c8e5e0635 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -337,16 +337,7 @@ struct swap_info_struct {
 	struct work_struct discard_work; /* discard worker */
 	struct work_struct reclaim_work; /* reclaim worker */
 	struct list_head discard_clusters; /* discard clusters list */
-	struct plist_node avail_lists[]; /*
-					   * entries in swap_avail_heads, one
-					   * entry per node.
-					   * Must be last as the number of the
-					   * array is nr_node_ids, which is not
-					   * a fixed value so have to allocate
-					   * dynamically.
-					   * And it has to be an array so that
-					   * plist_for_each_* can work.
-					   */
+	struct plist_node avail_list;   /* entry in swap_avail_head */
 };
 
 static inline swp_entry_t page_swap_entry(struct page *page)
diff --git a/mm/swapfile.c b/mm/swapfile.c
index b4f3cc712580..d8a54e5af16d 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -73,7 +73,7 @@ atomic_long_t nr_swap_pages;
 EXPORT_SYMBOL_GPL(nr_swap_pages);
 /* protected with swap_lock. reading in vm_swap_full() doesn't need lock */
 long total_swap_pages;
-static int least_priority = -1;
+#define DEF_SWAP_PRIO  -1
 unsigned long swapfile_maximum_size;
 #ifdef CONFIG_MIGRATION
 bool swap_migration_ad_supported;
@@ -102,7 +102,7 @@ static PLIST_HEAD(swap_active_head);
  * is held and the locking order requires swap_lock to be taken
  * before any swap_info_struct->lock.
  */
-static struct plist_head *swap_avail_heads;
+static PLIST_HEAD(swap_avail_head);
 static DEFINE_SPINLOCK(swap_avail_lock);
 
 static struct swap_info_struct *swap_info[MAX_SWAPFILES];
@@ -995,7 +995,6 @@ static unsigned long cluster_alloc_swap_entry(struct swap_info_struct *si, int o
 /* SWAP_USAGE_OFFLIST_BIT can only be set by this helper. */
 static void del_from_avail_list(struct swap_info_struct *si, bool swapoff)
 {
-	int nid;
 	unsigned long pages;
 
 	spin_lock(&swap_avail_lock);
@@ -1007,7 +1006,7 @@ static void del_from_avail_list(struct swap_info_struct *si, bool swapoff)
 		 * swap_avail_lock, to ensure the result can be seen by
 		 * add_to_avail_list.
 		 */
-		lockdep_assert_held(&si->lock);
+		//lockdep_assert_held(&si->lock);
 		si->flags &= ~SWP_WRITEOK;
 		atomic_long_or(SWAP_USAGE_OFFLIST_BIT, &si->inuse_pages);
 	} else {
@@ -1024,8 +1023,7 @@ static void del_from_avail_list(struct swap_info_struct *si, bool swapoff)
 			goto skip;
 	}
 
-	for_each_node(nid)
-		plist_del(&si->avail_lists[nid], &swap_avail_heads[nid]);
+	plist_del(&si->avail_list, &swap_avail_head);
 
 skip:
 	spin_unlock(&swap_avail_lock);
@@ -1034,7 +1032,6 @@ static void del_from_avail_list(struct swap_info_struct *si, bool swapoff)
 /* SWAP_USAGE_OFFLIST_BIT can only be cleared by this helper. */
 static void add_to_avail_list(struct swap_info_struct *si, bool swapon)
 {
-	int nid;
 	long val;
 	unsigned long pages;
 
@@ -1067,8 +1064,7 @@ static void add_to_avail_list(struct swap_info_struct *si, bool swapon)
 			goto skip;
 	}
 
-	for_each_node(nid)
-		plist_add(&si->avail_lists[nid], &swap_avail_heads[nid]);
+	plist_add(&si->avail_list, &swap_avail_head);
 
 skip:
 	spin_unlock(&swap_avail_lock);
@@ -1211,16 +1207,14 @@ static bool swap_alloc_fast(swp_entry_t *entry,
 static bool swap_alloc_slow(swp_entry_t *entry,
 			    int order)
 {
-	int node;
 	unsigned long offset;
 	struct swap_info_struct *si, *next;
 
-	node = numa_node_id();
 	spin_lock(&swap_avail_lock);
 start_over:
-	plist_for_each_entry_safe(si, next, &swap_avail_heads[node], avail_lists[node]) {
+	plist_for_each_entry_safe(si, next, &swap_avail_head, avail_list) {
 		/* Rotate the device and switch to a new cluster */
-		plist_requeue(&si->avail_lists[node], &swap_avail_heads[node]);
+		plist_requeue(&si->avail_list, &swap_avail_head);
 		spin_unlock(&swap_avail_lock);
 		if (get_swap_device_info(si)) {
 			offset = cluster_alloc_swap_entry(si, order, SWAP_HAS_CACHE);
@@ -1245,7 +1239,7 @@ static bool swap_alloc_slow(swp_entry_t *entry,
 		 * still in the swap_avail_head list then try it, otherwise
 		 * start over if we have not gotten any slots.
 		 */
-		if (plist_node_empty(&next->avail_lists[node]))
+		if (plist_node_empty(&si->avail_list))
 			goto start_over;
 	}
 	spin_unlock(&swap_avail_lock);
@@ -2535,44 +2529,18 @@ static int setup_swap_extents(struct swap_info_struct *sis, sector_t *span)
 	return generic_swapfile_activate(sis, swap_file, span);
 }
 
-static int swap_node(struct swap_info_struct *si)
-{
-	struct block_device *bdev;
-
-	if (si->bdev)
-		bdev = si->bdev;
-	else
-		bdev = si->swap_file->f_inode->i_sb->s_bdev;
-
-	return bdev ? bdev->bd_disk->node_id : NUMA_NO_NODE;
-}
-
 static void setup_swap_info(struct swap_info_struct *si, int prio,
 			    unsigned char *swap_map,
 			    struct swap_cluster_info *cluster_info,
 			    unsigned long *zeromap)
 {
-	int i;
-
-	if (prio >= 0)
-		si->prio = prio;
-	else
-		si->prio = --least_priority;
+	si->prio = prio;
 	/*
 	 * the plist prio is negated because plist ordering is
 	 * low-to-high, while swap ordering is high-to-low
 	 */
 	si->list.prio = -si->prio;
-	for_each_node(i) {
-		if (si->prio >= 0)
-			si->avail_lists[i].prio = -si->prio;
-		else {
-			if (swap_node(si) == i)
-				si->avail_lists[i].prio = 1;
-			else
-				si->avail_lists[i].prio = -si->prio;
-		}
-	}
+	si->avail_list.prio = -si->prio;
 	si->swap_map = swap_map;
 	si->cluster_info = cluster_info;
 	si->zeromap = zeromap;
@@ -2721,20 +2689,6 @@ SYSCALL_DEFINE1(swapoff, const char __user *, specialfile)
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
-			for_each_node(nid) {
-				if (si->avail_lists[nid].prio != 1)
-					si->avail_lists[nid].prio--;
-			}
-		}
-		least_priority++;
-	}
 	plist_del(&p->list, &swap_active_head);
 	atomic_long_sub(p->pages, &nr_swap_pages);
 	total_swap_pages -= p->pages;
@@ -2972,9 +2926,8 @@ static struct swap_info_struct *alloc_swap_info(void)
 	struct swap_info_struct *p;
 	struct swap_info_struct *defer = NULL;
 	unsigned int type;
-	int i;
 
-	p = kvzalloc(struct_size(p, avail_lists, nr_node_ids), GFP_KERNEL);
+	p = kvzalloc(sizeof(struct swap_info_struct), GFP_KERNEL);
 	if (!p)
 		return ERR_PTR(-ENOMEM);
 
@@ -3013,8 +2966,7 @@ static struct swap_info_struct *alloc_swap_info(void)
 	}
 	p->swap_extent_root = RB_ROOT;
 	plist_node_init(&p->list, 0);
-	for_each_node(i)
-		plist_node_init(&p->avail_lists[i], 0);
+	plist_node_init(&p->avail_list, 0);
 	p->flags = SWP_USED;
 	spin_unlock(&swap_lock);
 	if (defer) {
@@ -3282,9 +3234,6 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
 
-	if (!swap_avail_heads)
-		return -ENOMEM;
-
 	si = alloc_swap_info();
 	if (IS_ERR(si))
 		return PTR_ERR(si);
@@ -3465,7 +3414,7 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
 	}
 
 	mutex_lock(&swapon_mutex);
-	prio = -1;
+	prio = DEF_SWAP_PRIO;
 	if (swap_flags & SWAP_FLAG_PREFER)
 		prio = swap_flags & SWAP_FLAG_PRIO_MASK;
 	enable_swap_info(si, prio, swap_map, cluster_info, zeromap);
@@ -3904,7 +3853,6 @@ static bool __has_usable_swap(void)
 void __folio_throttle_swaprate(struct folio *folio, gfp_t gfp)
 {
 	struct swap_info_struct *si, *next;
-	int nid = folio_nid(folio);
 
 	if (!(gfp & __GFP_IO))
 		return;
@@ -3923,8 +3871,8 @@ void __folio_throttle_swaprate(struct folio *folio, gfp_t gfp)
 		return;
 
 	spin_lock(&swap_avail_lock);
-	plist_for_each_entry_safe(si, next, &swap_avail_heads[nid],
-				  avail_lists[nid]) {
+	plist_for_each_entry_safe(si, next, &swap_avail_head,
+				  avail_list) {
 		if (si->bdev) {
 			blkcg_schedule_throttle(si->bdev->bd_disk, true);
 			break;
@@ -3936,18 +3884,6 @@ void __folio_throttle_swaprate(struct folio *folio, gfp_t gfp)
 
 static int __init swapfile_init(void)
 {
-	int nid;
-
-	swap_avail_heads = kmalloc_array(nr_node_ids, sizeof(struct plist_head),
-					 GFP_KERNEL);
-	if (!swap_avail_heads) {
-		pr_emerg("Not enough memory for swap heads, swap is disabled\n");
-		return -ENOMEM;
-	}
-
-	for_each_node(nid)
-		plist_head_init(&swap_avail_heads[nid]);
-
 	swapfile_maximum_size = arch_max_swapfile_size();
 
 #ifdef CONFIG_MIGRATION
-- 
2.41.0


