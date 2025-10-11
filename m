Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C5DFACCD18E
	for <linux-mm@archiver.kernel.org>; Sat, 11 Oct 2025 08:16:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 19EDA8E003B; Sat, 11 Oct 2025 04:16:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 176AE8E000E; Sat, 11 Oct 2025 04:16:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0B3C78E003B; Sat, 11 Oct 2025 04:16:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id ECC1B8E000E
	for <linux-mm@kvack.org>; Sat, 11 Oct 2025 04:16:53 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id AA724160113
	for <linux-mm@kvack.org>; Sat, 11 Oct 2025 08:16:53 +0000 (UTC)
X-FDA: 83985127506.11.B51D040
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf01.hostedemail.com (Postfix) with ESMTP id C185F4000F
	for <linux-mm@kvack.org>; Sat, 11 Oct 2025 08:16:51 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=PlgwtfHl;
	spf=pass (imf01.hostedemail.com: domain of bhe@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=bhe@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760170611;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=au5KyC0gtq7vyHqJ99pjilo107TCnr2Eu0wXl07UYWI=;
	b=bjvk1YVKrA5PZeJGq97oI2IKzkDRzDUXhHmMWRE5WBUGzLD9s06GgHC0VExsnFLroqp55y
	lktoEZnWo49TZ2u+DOolvY/NMaQm7G1LOIeWexNkha1umrwzb3vBawhYMQ222lWp1JqEU8
	mTLHqbcI5KSBUZHXiPqKfS3szoiOiv4=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=PlgwtfHl;
	spf=pass (imf01.hostedemail.com: domain of bhe@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=bhe@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760170611; a=rsa-sha256;
	cv=none;
	b=HuvpvttEleIHl2qdtLyl+x6DADPC4xVVSHF6KJxKmuzHsaXUl2vWTK0prf7fl971ATFpdJ
	AZS/hOuyaNlRue+c7/MONcROjcOnbvjHEmrwdIjxmerzRS6YFUHGudaJ7JiXjpt2EZBd49
	jkO01nA21tY930dREzkrRlOJc0YvzbU=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1760170611;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=au5KyC0gtq7vyHqJ99pjilo107TCnr2Eu0wXl07UYWI=;
	b=PlgwtfHlHvRWMHMAqOX+mwbK3x+vVVUvzc5tD5dNmwq1LCiaHPSiSiTEiDo0LYQLSPw/rm
	FxhGDQJ81GxKwSD3+XaiSCyN9Z67wHmCxcGS6oaT86WQNAY/PR/miRdOtztdFIGTnqET1N
	0tTu7hVr4Cy2lHwdnh6FIic2JzNhWn8=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-372-gYn_LoIUMU-rW9xsr5UFPA-1; Sat,
 11 Oct 2025 04:16:47 -0400
X-MC-Unique: gYn_LoIUMU-rW9xsr5UFPA-1
X-Mimecast-MFC-AGG-ID: gYn_LoIUMU-rW9xsr5UFPA_1760170605
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 0D80E195609F;
	Sat, 11 Oct 2025 08:16:45 +0000 (UTC)
Received: from MiWiFi-R3L-srv.redhat.com (unknown [10.72.112.60])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id DA39A1955F21;
	Sat, 11 Oct 2025 08:16:39 +0000 (UTC)
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
Subject: [PATCH v4 mm-new 2/2] mm/swap: select swap device with default priority round robin
Date: Sat, 11 Oct 2025 16:16:24 +0800
Message-ID: <20251011081624.224202-3-bhe@redhat.com>
In-Reply-To: <20251011081624.224202-1-bhe@redhat.com>
References: <20251011081624.224202-1-bhe@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 7iYJJ-K1TeC9oXqSDfbBg3plo_SCMBgVyQ-60BKlHrA_1760170605
X-Mimecast-Originator: redhat.com
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: C185F4000F
X-Stat-Signature: wzyqc3cm4px4q4a8kheptwtcxjyakfmr
X-Rspam-User: 
X-HE-Tag: 1760170611-524254
X-HE-Meta: U2FsdGVkX18yMNCxfMwEtfKW8uTPduQq3S9A695U2UKhb5V4DQlUatyTCcjvKPFPGsFwPubEugrO8W4hSZSJAoi4TQiSNxH+BxLsghbZP7TDKjVe/GpVg+wSINkQmKXDRnl4YbMYmYyHJtneIfod0wpHizBAIQFdbShCtja3KTwvBtdIO/B8CHrVWq15lxjhwlvvNZEfqLN0l+MEAt9z9heTWJqx9RORYZ6YXEeZx2yu4V+m/YPpB8yP8NmEwkxIJYauCyiEGe8+OdLwgagEcPkt/KTSvksGA0rYINOejDC2x/l0+MZy5g6FwWoz0C/s6j5V3wiqIOa2StspKY2TkMK3sow8hMKCX6Qk5kJRzDpuUSVCZqyqPxja/Hpu6xvtYG4VrPCauEetxLifm02Vtf0TpIUhcjIIzkyHf8xPozrMLiH2egk+qUFjZn2XsB6rFAyQygS5TSKk9J0wa3Kq2mKx3gLqJRFfF/Mld8ZqAIdTrGrc42X/u9MbttmyUOf+yoJHHkUj+D6c654uutE5dhr7zwgi4J/DXoKEElGgSyznsx+p94zG32zBWG+rF/UsBW3O7yptxMch0M1Bpr1UFS2lLt/TzGej4UcHKpx4HQ813gXCvvQMVokz7uD/IA0A2V8oEb4SXT03uaRO2pDEXYfYFnNTpzWUK+9PaCEZry92HuI+CALpMclhqWXLB6OG+lVuWXExUZ2i1l+ZUZsnQdWJHxL8cMJZ0umEzCTTsFx06is1FxmLGbp+X/MO7rS9S0YnA9JacZ00o6WQYdyJCqLRpFMwJXM7KESJzBnFpqrQ8wo0eAEIpfmLcqUJXcFPpYrHaM20EsVFKVlVjzCsgkvxyQFqkzAMyAAW3P9aK4akEzrawg9uF4vgooVQBK2/XADbk6w4J+5h3FiXO4pIL+ydIlmv90EndousYqo+ooGJ7f4IDuKCJJpOZmuvM1gMvcfFmVXMbyLmV0Z3fan
 +JTEdSuq
 EL30Z2AzJk5MgH/G7H4Z59Sb7zyMuKJ2IO2TjGrPgK0vqDwdEqPJiK0vaCVcQmR8gfTVZ8Ot/FqSS5vw+IkkCFyJtfRzbEoolYIlIcKABrBfD4y0EykisUgOy0ohmZsSmn2tTSDsqyAQGer1YraKsOYzHeogrOPO7U8BLLHaiNIlCcvr6SJuXuwg5BqjRxLUhb2a2+wHPBBqOEIV5MghTiYaHANi8u5M65KHQOWVnpkWabNMEu1rte2LHhCSQDwvbu+zUuefVbWOkhqUQj6mQ7ocxL/D8ti6oekbseAZM+6kWkERUz0DCeXAtxKB9U7wWZQU1iOmQVRNVMfTAQ+2Z8ZC1TiK0Z/BiomZt8Dr6lADnapJDkCSp5Y8eGJ4vaAkF2upWdgEnJT/YbVGzDjW9CVCBmg==
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

Suggested-by: Chris Li <chrisl@kernel.org>
Signed-off-by: Baoquan He <bhe@redhat.com>
Acked-by: Chris Li <chrisl@kernel.org>
---
 mm/swapfile.c | 31 ++++---------------------------
 1 file changed, 4 insertions(+), 27 deletions(-)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index 4a36ea15de2b..5bd65cb56a77 100644
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
@@ -2708,10 +2708,7 @@ static void setup_swap_info(struct swap_info_struct *si, int prio,
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
@@ -2729,16 +2726,7 @@ static void _enable_swap_info(struct swap_info_struct *si)
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
@@ -2888,17 +2876,6 @@ SYSCALL_DEFINE1(swapoff, const char __user *, specialfile)
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
@@ -3609,7 +3586,7 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
 	}
 
 	mutex_lock(&swapon_mutex);
-	prio = -1;
+	prio = DEF_SWAP_PRIO;
 	if (swap_flags & SWAP_FLAG_PREFER)
 		prio = swap_flags & SWAP_FLAG_PRIO_MASK;
 	enable_swap_info(si, prio, swap_map, cluster_info, zeromap);
-- 
2.41.0


