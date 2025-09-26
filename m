Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 916AACAC5B8
	for <linux-mm@archiver.kernel.org>; Fri, 26 Sep 2025 15:55:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EE1028E0016; Fri, 26 Sep 2025 11:55:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EB7858E0001; Fri, 26 Sep 2025 11:55:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DCD4A8E0016; Fri, 26 Sep 2025 11:55:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C88328E0001
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 11:55:29 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 84CF714074A
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 15:55:29 +0000 (UTC)
X-FDA: 83931851178.01.4FD2378
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf14.hostedemail.com (Postfix) with ESMTP id 96D52100009
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 15:55:27 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ZZFQNBUN;
	spf=pass (imf14.hostedemail.com: domain of bhe@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=bhe@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758902127;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=p9WEXd+Ltep0wbh3CWXr84CCxvWDzE8gNF6w1eNYErA=;
	b=gnVu/SuTXreI6dgXAlRiDh3GJuHr/w0EnATc+0HxiQI7uSFWREt5C1/XLF9YDkHmo23EcN
	H2tP1awNUIeaUSo24rweS6yTjaCL/g6X/iNlXg2S1cjxDuiv26XzNBILL2jZIWNCMQg5qn
	7/rfzqfktkhwfFqhfVv12sFXeSlcIs0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758902127; a=rsa-sha256;
	cv=none;
	b=5KycBOQRNohF5gcgCC5B02WZFOHsrgEFBJ5NtUnHP5JWoBl3rlgEKbpKp12PkcU6e+0eKJ
	EZzn4Bt2QET4o772Pj+DXkyMcmrWb5jgw5CvHSCl3VTFwJCwnI2Q7HlTm7MA4PeffhhFHZ
	CVc1VgT+5J57qXO738iCDAPUoB6lhTg=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ZZFQNBUN;
	spf=pass (imf14.hostedemail.com: domain of bhe@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=bhe@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758902127;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=p9WEXd+Ltep0wbh3CWXr84CCxvWDzE8gNF6w1eNYErA=;
	b=ZZFQNBUN//OtXGujLvw9IlXCgY6BnSv2mrJ8muPDSoYhclvRDWbRPlq1zxc47jF8UlC714
	eHr/LyHeExCW1VXWpZJJIrnXQLUinkJzrr6RVqyaRYgyzF3r34uaPuNzbTlSxdFBcMApbP
	xmRdGM5AC8Pac4T1DHmmmxpygEM+3A0=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-94-L1pQ_dcjO0a-rntClioUKg-1; Fri,
 26 Sep 2025 11:55:23 -0400
X-MC-Unique: L1pQ_dcjO0a-rntClioUKg-1
X-Mimecast-MFC-AGG-ID: L1pQ_dcjO0a-rntClioUKg_1758902121
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E429F1800378;
	Fri, 26 Sep 2025 15:55:20 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.72.112.25])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 116471800983;
	Fri, 26 Sep 2025 15:55:14 +0000 (UTC)
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
Subject: [PATCH v2 1/1] mm/swapfile.c: select the swap device with default priority round robin
Date: Fri, 26 Sep 2025 23:55:04 +0800
Message-ID: <20250926155504.5122-2-bhe@redhat.com>
In-Reply-To: <20250926155504.5122-1-bhe@redhat.com>
References: <20250926155504.5122-1-bhe@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: jHmiBJ6zRrx_jChVTixA9tkMPJXitr0o1qfsYe3xVS8_1758902121
X-Mimecast-Originator: redhat.com
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 96D52100009
X-Stat-Signature: h6iqi9s3n6ys5hc6576w7ntapujcdnw6
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1758902127-912547
X-HE-Meta: U2FsdGVkX18y5bkH3/nY8gUOFP9N3dRAaK2J1YLcx8n8OHnEzAqYmDXR7WEd4W6YUmTaGMw34bLEm0z5wpsWJ7FGOGouTIygYyfTAzXi16fGHezXTgQZ2LnJC3UcYsy+viRJelebwTuvmqID6wGwxd7JEU8HxpS0i+vqnfdg0SC9fJ91GHHOKUYhbhnXSmwQWCGNEiAyIFzVcM7BAoy/RaTJJCyWtanBv8e4TECeXnCkg1xntt/vNRQkAwNSq4S7gBbLU8FLwXBqzVG6sMGqP0Ks1Ys9odTsSHDH3b3lquZu5gSJHuJC6c+GGWBnykbGKI1VX73SNAy0FjmSeKbq4cg2pokiOmNd0lPIuEbPNlhPNdatvD75CShPZC/fVmP3vGFghn35br4GYZ/bqAUQe1HT35eTSqd+niTz60q26mC2q0uj0JnfRFUypuv25irEmZ1C8tv3piCAllxS4X4axZeXQZvRQKKyL9Cn6lkCBXWzCpMwnvnyydrCeiqSC1XKyeAWhx6gtVPMycuAnDVdlZjoAoVpbYI5ciyFAopDqaHoR7nN2k7H509PZUHIDlWKGmMClIdk1PfgbU6RjcvaTXdcM/QYYWMSxOszufvjoIMZd0MiPzcizcUIevrXEiVbA+ayWS7seBZjFqkK9ehXQwu40v2x12Awki4s+O40ri8bL3Qg+z5WUjGrR5i7lT1+0XkmS09RBUZn1+w+1plrjCEVNMpGLsaRGtfHuER2AWBWsPSBwGcdInfFwtUBDjAfqe9ILuzYA+UsuPKp5WrjO42pHnViJYf5K+DuuTCQMNd/jvrzBHoN5QmctL36hIUloy1C5c/3DwhLo/t7K5uevPNT7nZXqlDm9revQTs8oa3iBOHI9UtUUVce6k5gBoPBNRssbLVHiITYS4jcVt1ZbP8K3g5qpWi3Sex3/uLhqmsbAKhnzzqDbyDSvP/BzrYmjZt130fskX4VXilpTqU
 PBxON5pc
 Dbnplg5ZppY51Qw82WAIhgTWh1cLrcPwwjz867RsADizG9aY1a/gc9Cssohv05cmKWKWJ8f2ZpYYF06lEp+1Ae+xd/11LmCRhZJwj5bTqNMHzkSfRWhEg+WuJjgKnRV4n9BuoMSycP9YTfjw40scDUsLqw84wDhqcI3U9f3TJ96I4iaRJdz5Inmlq5hfonUYI2xf/FcWT3HmKXd47DO4LdGzxO8a+N/3PICMEMh3RR3EI7USAUWIwOaOOSxcBOXSzcgjhMOFw79oRnWgKH/vl58A7LD+ZO3EnNRZkgdXYvVT4vaxyZzEbLeVtlIx2tEzWHouVm09A3YtIDu6Kl8CGcuu/RlRSXv7kepGMLoUO0plG6wDBHoeT8HpyOQ==
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
swap device on different node. The adjustment was introduced in commit
a2468cc9bfdf ("swap: choose swap device according to numa node").
However, the adjustment is a little coarse-grained. On the node, the swap
device sharing the node's id will always be selected firstly by node's CPUs
until exhausted, then next one. And on other nodes where no swap device
shares its node id, swap device with priority '-2' will be selected firstly
until exhausted, then next with priority '-3'.

This is the swapon output during the process high pressure vm-scability
test is being taken. It's clearly showing zram0 is heavily exploited until
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
with a plist swap_avail_head which reverts commit a2468cc9bfdf. Meanwhile,
on top of the revert, further change is taken to make any device w/o
specified priority get the same default priority '-1'. Surely, swap device
with specified priority are always put foremost, this is not impacted. If
you care about their different accessing speed, then use 'swapon -p xx' to
deploy priority for your swap devices.

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
System time:               637.92 s         526.74 s      (lower is better)
Sum Throughput:            3546.56 MB/s     4207.56 MB/s  (higher is better)
Single process Throughput: 114.40 MB/s      135.72 MB/s   (higher is better)
free latency:              10138455.99 us   6810119.01 us (low is better)

Signed-off-by: Baoquan He <bhe@redhat.com>
---
 Documentation/admin-guide/mm/swap_numa.rst |  78 ---------------
 include/linux/swap.h                       |  11 +--
 mm/swapfile.c                              | 109 +++------------------
 3 files changed, 16 insertions(+), 182 deletions(-)
 delete mode 100644 Documentation/admin-guide/mm/swap_numa.rst

diff --git a/Documentation/admin-guide/mm/swap_numa.rst b/Documentation/admin-guide/mm/swap_numa.rst
deleted file mode 100644
index 2e630627bcee..000000000000
--- a/Documentation/admin-guide/mm/swap_numa.rst
+++ /dev/null
@@ -1,78 +0,0 @@
-===========================================
-Automatically bind swap device to numa node
-===========================================
-
-If the system has more than one swap device and swap device has the node
-information, we can make use of this information to decide which swap
-device to use in get_swap_pages() to get better performance.
-
-
-How to use this feature
-=======================
-
-Swap device has priority and that decides the order of it to be used. To make
-use of automatically binding, there is no need to manipulate priority settings
-for swap devices. e.g. on a 2 node machine, assume 2 swap devices swapA and
-swapB, with swapA attached to node 0 and swapB attached to node 1, are going
-to be swapped on. Simply swapping them on by doing::
-
-	# swapon /dev/swapA
-	# swapon /dev/swapB
-
-Then node 0 will use the two swap devices in the order of swapA then swapB and
-node 1 will use the two swap devices in the order of swapB then swapA. Note
-that the order of them being swapped on doesn't matter.
-
-A more complex example on a 4 node machine. Assume 6 swap devices are going to
-be swapped on: swapA and swapB are attached to node 0, swapC is attached to
-node 1, swapD and swapE are attached to node 2 and swapF is attached to node3.
-The way to swap them on is the same as above::
-
-	# swapon /dev/swapA
-	# swapon /dev/swapB
-	# swapon /dev/swapC
-	# swapon /dev/swapD
-	# swapon /dev/swapE
-	# swapon /dev/swapF
-
-Then node 0 will use them in the order of::
-
-	swapA/swapB -> swapC -> swapD -> swapE -> swapF
-
-swapA and swapB will be used in a round robin mode before any other swap device.
-
-node 1 will use them in the order of::
-
-	swapC -> swapA -> swapB -> swapD -> swapE -> swapF
-
-node 2 will use them in the order of::
-
-	swapD/swapE -> swapA -> swapB -> swapC -> swapF
-
-Similaly, swapD and swapE will be used in a round robin mode before any
-other swap devices.
-
-node 3 will use them in the order of::
-
-	swapF -> swapA -> swapB -> swapC -> swapD -> swapE
-
-
-Implementation details
-======================
-
-The current code uses a priority based list, swap_avail_list, to decide
-which swap device to use and if multiple swap devices share the same
-priority, they are used round robin. This change here replaces the single
-global swap_avail_list with a per-numa-node list, i.e. for each numa node,
-it sees its own priority based list of available swap devices. Swap
-device's priority can be promoted on its matching node's swap_avail_list.
-
-The current swap device's priority is set as: user can set a >=0 value,
-or the system will pick one starting from -1 then downwards. The priority
-value in the swap_avail_list is the negated value of the swap device's
-due to plist being sorted from low to high. The new policy doesn't change
-the semantics for priority >=0 cases, the previous starting from -1 then
-downwards now becomes starting from -2 then downwards and -1 is reserved
-as the promoted value. So if multiple swap devices are attached to the same
-node, they will all be promoted to priority -1 on that node's plist and will
-be used round robin before any other swap devices.
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
index b4f3cc712580..bc1b9c847ff6 100644
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
@@ -84,12 +84,6 @@ static const char Unused_file[] = "Unused swap file entry ";
 static const char Bad_offset[] = "Bad swap offset entry ";
 static const char Unused_offset[] = "Unused swap offset entry ";
 
-/*
- * all active swap_info_structs
- * protected with swap_lock, and ordered by priority.
- */
-static PLIST_HEAD(swap_active_head);
-
 /*
  * all available (active, not full) swap_info_structs
  * protected with swap_avail_lock, ordered by priority.
@@ -102,7 +96,7 @@ static PLIST_HEAD(swap_active_head);
  * is held and the locking order requires swap_lock to be taken
  * before any swap_info_struct->lock.
  */
-static struct plist_head *swap_avail_heads;
+static PLIST_HEAD(swap_avail_head);
 static DEFINE_SPINLOCK(swap_avail_lock);
 
 static struct swap_info_struct *swap_info[MAX_SWAPFILES];
@@ -995,7 +989,6 @@ static unsigned long cluster_alloc_swap_entry(struct swap_info_struct *si, int o
 /* SWAP_USAGE_OFFLIST_BIT can only be set by this helper. */
 static void del_from_avail_list(struct swap_info_struct *si, bool swapoff)
 {
-	int nid;
 	unsigned long pages;
 
 	spin_lock(&swap_avail_lock);
@@ -1024,8 +1017,7 @@ static void del_from_avail_list(struct swap_info_struct *si, bool swapoff)
 			goto skip;
 	}
 
-	for_each_node(nid)
-		plist_del(&si->avail_lists[nid], &swap_avail_heads[nid]);
+	plist_del(&si->avail_list, &swap_avail_head);
 
 skip:
 	spin_unlock(&swap_avail_lock);
@@ -1034,7 +1026,6 @@ static void del_from_avail_list(struct swap_info_struct *si, bool swapoff)
 /* SWAP_USAGE_OFFLIST_BIT can only be cleared by this helper. */
 static void add_to_avail_list(struct swap_info_struct *si, bool swapon)
 {
-	int nid;
 	long val;
 	unsigned long pages;
 
@@ -1067,8 +1058,7 @@ static void add_to_avail_list(struct swap_info_struct *si, bool swapon)
 			goto skip;
 	}
 
-	for_each_node(nid)
-		plist_add(&si->avail_lists[nid], &swap_avail_heads[nid]);
+	plist_add(&si->avail_list, &swap_avail_head);
 
 skip:
 	spin_unlock(&swap_avail_lock);
@@ -1211,16 +1201,14 @@ static bool swap_alloc_fast(swp_entry_t *entry,
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
@@ -1245,7 +1233,7 @@ static bool swap_alloc_slow(swp_entry_t *entry,
 		 * still in the swap_avail_head list then try it, otherwise
 		 * start over if we have not gotten any slots.
 		 */
-		if (plist_node_empty(&next->avail_lists[node]))
+		if (plist_node_empty(&si->avail_list))
 			goto start_over;
 	}
 	spin_unlock(&swap_avail_lock);
@@ -2535,44 +2523,18 @@ static int setup_swap_extents(struct swap_info_struct *sis, sector_t *span)
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
@@ -2584,16 +2546,7 @@ static void _enable_swap_info(struct swap_info_struct *si)
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
@@ -2721,20 +2674,6 @@ SYSCALL_DEFINE1(swapoff, const char __user *, specialfile)
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
@@ -2972,9 +2911,8 @@ static struct swap_info_struct *alloc_swap_info(void)
 	struct swap_info_struct *p;
 	struct swap_info_struct *defer = NULL;
 	unsigned int type;
-	int i;
 
-	p = kvzalloc(struct_size(p, avail_lists, nr_node_ids), GFP_KERNEL);
+	p = kvzalloc(sizeof(struct swap_info_struct), GFP_KERNEL);
 	if (!p)
 		return ERR_PTR(-ENOMEM);
 
@@ -3013,8 +2951,7 @@ static struct swap_info_struct *alloc_swap_info(void)
 	}
 	p->swap_extent_root = RB_ROOT;
 	plist_node_init(&p->list, 0);
-	for_each_node(i)
-		plist_node_init(&p->avail_lists[i], 0);
+	plist_node_init(&p->avail_list, 0);
 	p->flags = SWP_USED;
 	spin_unlock(&swap_lock);
 	if (defer) {
@@ -3282,9 +3219,6 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
 
-	if (!swap_avail_heads)
-		return -ENOMEM;
-
 	si = alloc_swap_info();
 	if (IS_ERR(si))
 		return PTR_ERR(si);
@@ -3465,7 +3399,7 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
 	}
 
 	mutex_lock(&swapon_mutex);
-	prio = -1;
+	prio = DEF_SWAP_PRIO;
 	if (swap_flags & SWAP_FLAG_PREFER)
 		prio = swap_flags & SWAP_FLAG_PRIO_MASK;
 	enable_swap_info(si, prio, swap_map, cluster_info, zeromap);
@@ -3904,7 +3838,6 @@ static bool __has_usable_swap(void)
 void __folio_throttle_swaprate(struct folio *folio, gfp_t gfp)
 {
 	struct swap_info_struct *si, *next;
-	int nid = folio_nid(folio);
 
 	if (!(gfp & __GFP_IO))
 		return;
@@ -3923,8 +3856,8 @@ void __folio_throttle_swaprate(struct folio *folio, gfp_t gfp)
 		return;
 
 	spin_lock(&swap_avail_lock);
-	plist_for_each_entry_safe(si, next, &swap_avail_heads[nid],
-				  avail_lists[nid]) {
+	plist_for_each_entry_safe(si, next, &swap_avail_head,
+				  avail_list) {
 		if (si->bdev) {
 			blkcg_schedule_throttle(si->bdev->bd_disk, true);
 			break;
@@ -3936,18 +3869,6 @@ void __folio_throttle_swaprate(struct folio *folio, gfp_t gfp)
 
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


