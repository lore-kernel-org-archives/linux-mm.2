Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DD244CCF9E0
	for <linux-mm@archiver.kernel.org>; Tue, 28 Oct 2025 03:43:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 495B38010A; Mon, 27 Oct 2025 23:43:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 46C2B800E4; Mon, 27 Oct 2025 23:43:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 30CB68010A; Mon, 27 Oct 2025 23:43:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1EE66800E4
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 23:43:57 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A6880160210
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 03:43:56 +0000 (UTC)
X-FDA: 84046129272.02.F66E849
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf15.hostedemail.com (Postfix) with ESMTP id B5989A000C
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 03:43:54 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=h5aBxcAQ;
	spf=pass (imf15.hostedemail.com: domain of bhe@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=bhe@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761623034;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VRkPfGqvOn/0+N8GQL6/hUa8S4ruDLqceo5D9dfxni8=;
	b=AAzDON6tVbMXLcspXPakQi0J6/M4BLCplSEUx+GkAsJptF67ygugz+7mYhPJY7BlH75qVT
	ftE4Ibd906qSocvy/NPS9SaiFoQvbuHn155tGwThRI0bNANBknSjQ9MibA2+S3Jnr4XCfi
	m/N+EGKeaDnzmJn2tBD/MIQsgk9GJ6M=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=h5aBxcAQ;
	spf=pass (imf15.hostedemail.com: domain of bhe@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=bhe@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761623034; a=rsa-sha256;
	cv=none;
	b=e5cRlCXku2PK7aU771P7qSA0tbnbw1ziBkpob4PM+QV0Fi4n9wMEm4DaQYz3tInKqMFZL1
	eMC9i/bzjn0r9Jc1xL1+AWnN3Qm0Ul9RHwJ5KQ5/UCxWZhFAHnSP+sUH4mPaQtfeZTXQrJ
	H3Nomh3NnEEpAi3a2SSmvElhbNwnT3A=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1761623034;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VRkPfGqvOn/0+N8GQL6/hUa8S4ruDLqceo5D9dfxni8=;
	b=h5aBxcAQhJVmHsdimaCzhniX3LdM1CGKIU+2EFP9yeQhg8TY+slkSE/f8TL0suQjLPW1+u
	f+iUXbqX9cqj1i6/SQUS5PZh9HSOOpdGoMjyEW5z9C5C9NTYwl9AQ3Sgf56ZtJu1b2CHBv
	jH22MPvmmrDl9J0yAybStQoipu+fosg=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-558-AQ7v-yUOOxi4qlAldFGw4Q-1; Mon,
 27 Oct 2025 23:43:50 -0400
X-MC-Unique: AQ7v-yUOOxi4qlAldFGw4Q-1
X-Mimecast-MFC-AGG-ID: AQ7v-yUOOxi4qlAldFGw4Q_1761623029
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E8C8519539A9;
	Tue, 28 Oct 2025 03:43:48 +0000 (UTC)
Received: from MiWiFi-R3L-srv.redhat.com (unknown [10.72.112.212])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 0C5281800298;
	Tue, 28 Oct 2025 03:43:43 +0000 (UTC)
From: Baoquan He <bhe@redhat.com>
To: linux-mm@kvack.org
Cc: akpm@linux-foundation.org,
	chrisl@kernel.org,
	youngjun.park@lge.com,
	kasong@tencent.com,
	baohua@kernel.org,
	shikemeng@huaweicloud.com,
	nphamcs@gmail.com,
	Baoquan He <bhe@redhat.com>
Subject: [PATCH v5 mm-new 2/2] mm/swap: select swap device with default priority round robin
Date: Tue, 28 Oct 2025 11:43:08 +0800
Message-ID: <20251028034308.929550-3-bhe@redhat.com>
In-Reply-To: <20251028034308.929550-1-bhe@redhat.com>
References: <20251028034308.929550-1-bhe@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: aHb5Zxsei3vUjQUNMQMPL9UJi6jr-PieEP_krXaXCcE_1761623029
X-Mimecast-Originator: redhat.com
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Stat-Signature: wkq7sfg6gpmrskyzg3me9fcusaw7caup
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: B5989A000C
X-HE-Tag: 1761623034-546681
X-HE-Meta: U2FsdGVkX1+l81rsYPVGWM8O6w2y7dm1iMvRG266+kLI+ipjq6exRCayNf6cjOidsLvjfmiqabrKPZ/k/NouM64sq4etpZeEXNV4IBwXNX01uhwTIg4jTUHT09kseibFDB3BPo666VHyhY7Yz/xjJVbWtdsd/fgnYSiTM07T2F/6OJ2nwQtVyjTd832Qeq2MQ78Tp8+WdL/hmTDAxhCbgHhtIR9T2srUz7dndaREXprfiiMviom5PQnj9HpkgXnzi99Npo4szbNk05lTPCEjCsEkbl/PTUzSZAPxy2Jm9suLqjnd2AGNaoMfHdcmBdQCKHO7o4PfhhnXtZFAmgLznXd5eX3vZ+LW62L+xOUyeUphZDlilYnZTk8PFJvNQL4PTQ5KHG6tGEeA9tyZK6IdH6eqe/stpMkY+1ZGRSqctABg7Cp7l30D/v+qVRNxBgNE/xfW8xIYcVbAV+YZIyTJxUKg5PchIBr2OMmZAxcP2A/QKYrkrNRjrOlQl292hSVc+sQ5kN/Hspq6LkcL+nARqLeZHuUcZ12t9e6gflNWkjrAIu1pZPrL/2laC//YD0xxba7Sxp/+rd2cLLmRM4QeTMbEFhVCA40Xk8JERniGmObL6rZECSnY/Zc7f05sCn/jHlombKHv3Zy+WMnDA2UybyPdXxM0bz3Jnc+6NhFtiKhGz/o6jxWdTvtXOJkaBzLCxYkmC9Xjev8eOIb8A0YsWjYqxm9Nj7e/LzKZKIGTgoOmd9sLNrdbniMh7joKfvLhp62d254wjq1OEup7zY3hKqGvBlnQVbZWAeT0oSJIjXl3TxJKpLl/Us1XcFVDhwWpPXJJD74p3Ty69CU+wbT4uqruyPRweE4cuqhHoG7izMr2O7L9yMyLL7P6DE6ZxoYkB02cjQRlK8RtTpmYYX0EF+BolInLkkOWM+tl8zAwb50LL8VntfSKxBc2CgM5EeiVfheQMnaL4pgdCJCsz3y
 5N2W/a/C
 iRwBGXBebxiFNLNlUPTYrf0XvjDyIxEeEWIY0EF/lgaWgd2ZIynDOPVWo7q3ZaF0X3h40+gBdaPhgPgALHesB7iAWQ4kVIRrRUOKCSJutZhB6udnrwR4HWhPhVdheusU0zXcBA76LAnVft4uhtPNdoSzPx4mjOs3PLFb4uxbjqB5UaMkNglgYLtXCWValptecK3kcAdOjukpQVkFjzlf9pn3Ch6cYaL8+Xz3xUWAP5Ms6t9kBHu4DQkNjptt2xLCpri8GYCgYcEAIh99LH6axOWVWgSMdbrk3XeQ3nkV54nePw1RT14aiP4VzUf61D9yh+tNRrq5w+w2zYeKlQ8L2801FEwaBps6USIl8U5JBA1yRsQ3xEFs7zn7Z6VLOI55FPwy3QTmKzOMSO+g=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Swap devices are assumed to have similar accessing speed when swapon
if no priority is specified. It's unfair and doesn't make sense just
because one swap device is swapped on firstly, its priority will be
higher than the one swapped on later.

Here, set all swap devicess to have priority '-1' by default. With this
change, swap device with default priority will be selected round robin
when swapping out. This can improve the swapping efficiency a lot among
multiple swap devices with default priority.

Below are swapon output during the processes when high pressure vm-scability
test is being taken:

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

With the change, about 18% efficiency promotion relative to node based
way as below. (Surely, the pre-commit a2468cc9bfdf way is the worst.)

vm-scability test:
==================
Test with:
usemem --init-time -O -y -x -n 31 2G (4G memcg, zram as swap)
                            one by one:      node based:      round robin:
System time:                1087.38 s        637.92 s         526.74 s     (lower is better)
Sum Throughput:             2036.55 MB/s     3546.56 MB/s     4207.56 MB/s (higher is better)
Single process Throughput:  65.69 MB/s       114.40 MB/s      135.72 MB/s  (high is better)
free latency:               15769409.48 us   10138455.99 us   6810119.01 us(lower is better)

Suggested-by: Chris Li <chrisl@kernel.org>
Acked-by: Chris Li <chrisl@kernel.org>
Signed-off-by: Baoquan He <bhe@redhat.com>
---
 mm/swapfile.c | 30 ++++--------------------------
 1 file changed, 4 insertions(+), 26 deletions(-)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index ce3580e2f4f4..c35bb8593f50 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -74,7 +74,7 @@ atomic_long_t nr_swap_pages;
 EXPORT_SYMBOL_GPL(nr_swap_pages);
 /* protected with swap_lock. reading in vm_swap_full() doesn't need lock */
 long total_swap_pages;
-static int least_priority;
+#define DEF_SWAP_PRIO  -1
 unsigned long swapfile_maximum_size;
 #ifdef CONFIG_MIGRATION
 bool swap_migration_ad_supported;
@@ -2707,10 +2707,7 @@ static void setup_swap_info(struct swap_info_struct *si, int prio,
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
@@ -2728,16 +2725,7 @@ static void _enable_swap_info(struct swap_info_struct *si)
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
@@ -2887,16 +2875,6 @@ SYSCALL_DEFINE1(swapoff, const char __user *, specialfile)
 	}
 	spin_lock(&p->lock);
 	del_from_avail_list(p, true);
-	if (p->prio < 0) {
-		struct swap_info_struct *si = p;
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
@@ -3607,7 +3585,7 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
 	}
 
 	mutex_lock(&swapon_mutex);
-	prio = -1;
+	prio = DEF_SWAP_PRIO;
 	if (swap_flags & SWAP_FLAG_PREFER)
 		prio = swap_flags & SWAP_FLAG_PRIO_MASK;
 	enable_swap_info(si, prio, swap_map, cluster_info, zeromap);
-- 
2.41.0


