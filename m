Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 217B6606A331
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 04:22:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=HqFNjDls
Received: by kanga.kvack.org (Postfix)
	id 2E3346B05B3; Tue, 27 Oct 2026 00:22:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2BA206B05B4; Tue, 27 Oct 2026 00:22:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1CFA46B05B5; Tue, 27 Oct 2026 00:22:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E75D96B05B3
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 00:22:18 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 60C14A059F
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 04:22:18 +0000 (UTC)
X-FDA: 85367109156.05.FCBA21B
Received: from mail-qv1-f45.google.com (mail-qv1-f45.google.com [209.85.219.45])
	by imf28.hostedemail.com (Postfix) with ESMTP id A36D9C0004
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 04:22:16 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=HqFNjDls;
	spf=pass (imf28.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.45 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793074936;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CfcYGaJ4tkbNnhjQHfn5dtEgiZ6cd5xAnQKhOyf0Ms4=;
	b=uB3+swl20sl5wyvcX8UtV968sHPe7AZd9jECreHKhjkCis0eP0VZMBsOMpruHxgXRBxRtM
	oPqvL4N5mhuaQBt4bG8ah/J4HNcNuctkoBVmdSk3Bh0JX1Twb7vUh/Rrv9FOlGiGc4U4Qn
	QfcavC8L7Z9blpdP1uQomkzvm/ZlA3A=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793074936;
	b=RupyrcfTQrzeTa3PfhZi8mZ7Rwg2s1F1/ycrug6asFQ7ZSN64wRK+yRkmzBDk4dHe6fckx
	B5/r657a0eVRVwLB7gD8JKaAsVNysW17BBUNT3TAW2iu/7GoGOTMP8z98pZSkw7v7sI+AN
	FUI0vj05ZIaFmbDv2DdsUxgpoEE4Txc=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=HqFNjDls;
	spf=pass (imf28.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.45 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
Received: by mail-qv1-f45.google.com with SMTP id 6a1803df08f44-917997ab0d9so40455976d6.3
        for <linux-mm@kvack.org>; Mon, 26 Oct 2026 21:22:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1793074936; x=1793679736; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=CfcYGaJ4tkbNnhjQHfn5dtEgiZ6cd5xAnQKhOyf0Ms4=;
        b=HqFNjDls4D8EjkMY99/sX1I5Ix3iPrclvq4IiEcD1LbqbV+G6O9K6LDoOxcfgUtRpi
         cxcVgDpiXfDGsXfMBIfxot2GW1Q3cgYZrT7c0B5lRZ48siBsQLU02OiMQ5YctNlTJLQ9
         4rI8lNpJxW7FM1iKTaVQPaHkSHE/ElvyNaTIFCK009uj7SQl1x581129WTxbQidnoVPn
         KYSEeztB+NNAYfbsonbHfU3dp46Dg96vH7MDTxTqbMVfnc0sw5d99p7QZxPdwy/jYiXO
         CA5XAAL11x4Lg0988wXTHRMfeCp1M491hErP6PSxkH/ENwM4nYq72e88PXySJAPcncph
         0D7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793074936; x=1793679736;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=CfcYGaJ4tkbNnhjQHfn5dtEgiZ6cd5xAnQKhOyf0Ms4=;
        b=d8hQwwB2eXk2Jq3a+hxPt0kG3kdFCtKliIaqcJoyzJCkFouqIT2frH8TkAalq6OjUq
         5wegGcRjW+ajpMbQe+c7FbaWSg7gPjsAqP9X+NHdR036Ww7Rnw/sBKtQNPt7N/xXde07
         nJa9VPKUehA/meRH2wX3zxNtVCbOKWdocjR5jvXaviMS1YM2KqzJJFQ+/vznsZZ782Hj
         giAUyiaouAKDrO4CCOiRVMwmdircd3iJWfoZCeB0hz5RKArcwZHCgyYnRGUA35x5Hfmt
         2A1xJRZyRBiN0bLJOjB0PGCJp4mtH2Cf+ay+Ckk5TRQ3XAccNCo6UQBRAbXgfs/NLFrj
         owvQ==
X-Gm-Message-State: AFq9FYK4nVj2Dl7U98B2bgMvfZcLAs2N3rqJuPw2T09TIVKsrV2V1O9Y
	exncM5wQIJyKrjsfI8J/s8tg1Ytm8k15jW7WwCydmDH3Yj33q00qNwJIE+KhV9mryw5q3dv7ade
	cZ2rahzE=
X-Gm-Gg: AYBFou2Ncf+2915sEgfNNlcfF+yDeTxtaIKBJuowvGtO2QokAquCb3/eWkEv5Ul0mjV
	ZKaR9d6+Dy4vheJM/Jo7CEBoNy7pn7qoGuiEr8pfmqk7GgfZZ/shi6WZgNCpVLcFi16yZfdcBw7
	DyIN0TyCoPu1eHniXr06WM4yb0qN+zwC90QFmvog00OSKMTiBJP2PeU/w5JnccjcvHKtxzAebnn
	PNFntr6QUGiUglMZ9PKQzPSFkuARUNm0mDWW36l3LD3VzVaJfUg114CXN3rO0EI8MqBLKJ7qDfs
	wILVtUzqk5mUBernBgjdRligQvxxjON0N6I0SAldcGVulFhM3CA7ExVr0Gflq60geJ3JeKajKWv
	ooL8EAsCEmc+wcc5AvRHaQHHNtLbCuzMI+MMFRLgvJ87bDH9l9QiLH2j1IpeaIfjAelzB4wnnpp
	5yeaRkjTgPOjbi6O0H91/sk1OdbYXTUMizkE0PzJCyO8NntBzyUQK9gZjcBVTk8g1mqRZgNM/Fu
	LXftKjuYOdq6XbUgMdY8Qm87rB3qD13oBjY0y8pYKsHcyR3spckXHJJf9WhTLNbxS5ec+3JoJhJ
	EfCto/c4pJoScEIcXXJvvKDcCAW671mlgQ5A0Ds61g==
X-Received: by 2002:ad4:5c8d:0:b0:917:92c7:ce45 with SMTP id 6a1803df08f44-91c48e5705dmr159481776d6.37.1793074935786;
        Mon, 26 Oct 2026 21:22:15 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91c47bd01cdsm91139676d6.7.2026.10.26.21.22.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Oct 2026 21:22:13 -0700 (PDT)
From: "Gregory Price (Meta)" <gourry@gourry.net>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	linux-cxl@vger.kernel.org,
	kernel-team@meta.com,
	akpm@linux-foundation.org,
	vbabka@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	brendan.jackman@linux.dev,
	hannes@cmpxchg.org,
	ziy@nvidia.com,
	linmiaohe@huawei.com,
	nao.horiguchi@gmail.com,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	rppt@kernel.org,
	osalvador@suse.de,
	muchun.song@linux.dev,
	iamjoonsoo.kim@lge.com,
	anshuman.khandual@arm.com,
	stable@vger.kernel.org
Subject: [PATCH 1/6] mm/compaction: wait for pfn walkers before poisoning offlined memmap
Date: Tue, 27 Oct 2026 00:21:59 -0400
Message-ID: <20261027042204.3741307-2-gourry@gourry.net>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261027042204.3741307-1-gourry@gourry.net>
References: <20261027042204.3741307-1-gourry@gourry.net>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: A36D9C0004
X-Stat-Signature: tkchzo8i53c3jxd4bu7ngg8ngmru44im
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793074936-61860
X-HE-Meta: U2FsdGVkX1+rFHwubnXrrmWrj0oivkS1Yy9HtTyP05AOieO5NvySLxyhWIQLUMAQphxlWZKXN5cciSKTFvYxVSWzj8ravtIpEPjXlrexRxHTIGy9zS8Lgb8C2WjB6GAu7JgiNKgRGGyvKGxGfHvFLiFm5KDn+PsG7YBYk25ETHLZVgZLbQM5FI4OwIOMQqelrFXGMNl6ki4RW8Lhhx4sYKzwJmcuM/VceWojIu7F0rKdexhiMCvCcctaCWCdgZ4cpr14Yk8YD2HNJin7cuNORAY8ccebtVyZR2CcNopxnDpdHk8EZYc4sR9B6wJB+iMVkIsLbgKfGngvZuKWmZZGaVBmujPwKaNgyRUzS3EFo/mS/3XNWX1mko5sQ+4h4G+rBPekuubwfTXhOgh5oezX6j2COOjk+Js+I8JBtyoncQYeYn/qx+2HNtVO/qPT5Z36yhCY1d+SX6EacqtcVDEDhEll9d5Y8OxDLiVIo4VoadkaorrUDge89YuDXguwTKh4Y6RksnroNhThhnsBdLifQFDfP3Mzv4Na2iiJWy3cBn8uSTbcnSpDNOA/dIqRKQnsO1UlOHLdgfwmv4f1t/yFk2U6wIMRyKRQW4Iat50qPtxMiN6vEwi/C0SjE8480eG+IqyLRQd1rUrnBbj/+XU7DkzYNZfYIoH+jbeFtSFGcX6AHV0gyuvEHbKDjR2ipN+/adC6fT8jquLQDCJU4nyFvOKB5Az5XMHpMZvJVtufJmFJEMqmWPUi6wyNVXWpXJGxXWh3UGduIFW+OVmLqQ6t2BiFpyw+B4c/JwYRrLsCKNP84l6OxQaW2IfWrt9Pu7PQUuc1KVLDOP05mtnbUHZLFyRUxcUbrBA1+oZe5xlEyfJ/LqMIBnP+rMCVY9dFRtC3ih6prQtBomSA99vxknKY5M+/8XRHIZ8na1eqYricxSccmpKA8ao/cv/eJGhxZGvN+aTOLFHGLM+pDcBY2C4
 HvQYVJsL
 N6Pgt7xFuN8k83ObvZpYm3ZNJM1PothrthcL1s4U8RUWHHBrbLKf1Qphzj7adPm4sKFtpgHU4igmt+0GiXoRRzeWODVuAk/przujZ4EaVl7fz5p9slUyj8mevUeYot/3ReNuv8/W+NSlEnd/Cv8+/qfCHv4Xvxx0qE1Dcee33h7Aus/uhxzuGEEHzMmJLHuKl0wd5zYXu92hyifCqeSoplsPppwIMw7ltg/d9RCiyoH+JxvoLp4gONhlOD2YVEh206+Gk4XKgqRBjJsfPSE8nVE6Z78uJG8GfDdqvZLnfDba5khbYntyeJdffiwQw9a7yyZjPGGuiXqZeN3AVMjb7fKPethDF0CKTiOPMAsleLBHa+RBmS2oMWkriM/GXPprrfgoZNsEzIraQqq8mkYe+h7RFSg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Compaction checks that a pageblock is online, then uses its pages across
lock drops and sleeps.  If offline poisons the memmap meanwhile, a
DEBUG_VM kernel faults:

  CPU 1 (compaction)                  CPU 2 (offline_pages)
  pageblock_pfn_to_page()
    block is online
  isolate_migratepages_block()
    cond_resched()
                                      offline_mem_sections()
                                      remove_pfn_range_from_zone()
                                        page_init_poison()
    set_pageblock_skip(valid_page)
      reads the zone of a poisoned page

  Oops: general protection fault, probably for non-canonical address 0xdffffc00000006a2
  RIP: 0010:set_pfnblock_bit+0xa6/0x2b0
   isolate_migratepages_block+0x2456/0x3c80
   compact_zone+0x1638/0x3900
   compact_node+0x12a/0x1f0
   sysctl_compaction_handler+0xec/0x160

The free scanner faults the same way.  A contiguous zone skips the
online check, since offline clears zone->contiguous only after
poisoning.

Hold an SRCU-fast read section (pfn_walk) from the block check to the
last use of its pages, and make remove_pfn_range_from_zone() clear
zone->contiguous and wait for it before poisoning.  Offline pays one
grace period per range.

Scanner positions outlive the section, and offline can shrink the zone
meanwhile, so take the contiguous fast path only inside the current
span, publish zone->contiguous with release, and keep the migrate
scanner inside the zone.

With a kprobe parking the migrate scanner across the offline, base
faults in 3 of 3 runs and this patch in none.  Unforced offline/online
cycling under compaction faults in 8 of 24 runs on base and 0 of 12 with
this patch.

Fixes: d33695b16a9f ("mm/memory_hotplug: poison memmap in remove_pfn_range_from_zone()")
Cc: stable@vger.kernel.org
Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
---
 mm/compaction.c     |  8 ++++++++
 mm/internal.h       | 41 +++++++++++++++++++++++++++++++++++++++++
 mm/memory_hotplug.c | 14 ++++++++++++--
 mm/mm_init.c        |  4 ++--
 mm/page_alloc.h     |  7 ++++++-
 5 files changed, 69 insertions(+), 5 deletions(-)

diff --git a/mm/compaction.c b/mm/compaction.c
index f1b2060eb2016..2aeb18b6d54dd 100644
--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -360,6 +360,7 @@ static void __reset_isolation_suitable(struct zone *zone)
 	if (!zone->compact_blockskip_flush)
 		return;
 
+	guard(pfn_walk)();
 	zone->compact_blockskip_flush = false;
 
 	/*
@@ -716,6 +717,7 @@ isolate_freepages_range(struct compact_control *cc,
 	unsigned long isolated, pfn, block_start_pfn, block_end_pfn;
 	int order;
 
+	guard(pfn_walk)();
 	for (order = 0; order < NR_PAGE_ORDERS; order++)
 		INIT_LIST_HEAD(&cc->freepages[order]);
 
@@ -1340,6 +1342,7 @@ isolate_migratepages_range(struct compact_control *cc, unsigned long start_pfn,
 	unsigned long pfn, block_start_pfn, block_end_pfn;
 	int ret = 0;
 
+	guard(pfn_walk)();
 	/* Scan block by block. First and last block may be incomplete */
 	pfn = start_pfn;
 	block_start_pfn = pageblock_start_pfn(pfn);
@@ -1732,6 +1735,7 @@ static void isolate_freepages(struct compact_control *cc)
 	unsigned long low_pfn;	     /* lowest pfn scanner is able to scan */
 	unsigned int stride;
 
+	guard(pfn_walk)();
 	/* Try a small search of the free lists for a candidate */
 	fast_isolate_freepages(cc);
 	if (cc->nr_freepages)
@@ -2099,6 +2103,7 @@ static isolate_migrate_t isolate_migratepages(struct compact_control *cc)
 		(cc->mode != MIGRATE_SYNC ? ISOLATE_ASYNC_MIGRATE : 0);
 	bool fast_find_block;
 
+	guard(pfn_walk)();
 	/*
 	 * Start at where we last stopped, or beginning of the zone as
 	 * initialized by compact_zone(). The first failure will use
@@ -2116,6 +2121,9 @@ static isolate_migrate_t isolate_migratepages(struct compact_control *cc)
 	 */
 	fast_find_block = low_pfn != cc->migrate_pfn && !cc->fast_search_fail;
 
+	/* Offline may have shrunk the zone start past an old migrate_pfn */
+	low_pfn = max(low_pfn, block_start_pfn);
+
 	/* Only scan within a pageblock boundary */
 	block_end_pfn = pageblock_end_pfn(low_pfn);
 
diff --git a/mm/internal.h b/mm/internal.h
index d497c35ee7833..8a2faa74403b5 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -18,6 +18,7 @@
 #include <linux/rmap.h>
 #include <linux/swap.h>
 #include <linux/leafops.h>
+#include <linux/srcu.h>
 #include <linux/tracepoint-defs.h>
 
 /* Internal core VMA manipulation functions. */
@@ -1206,6 +1207,46 @@ struct tlbflush_unmap_batch;
  */
 extern struct workqueue_struct *mm_percpu_wq;
 
+/*
+ * Compaction checks that a pageblock is online and then uses its pages,
+ * possibly across sleeps.  remove_pfn_range_from_zone() waits for these
+ * readers before it poisons the memmap of a range taken offline.
+ */
+#ifdef CONFIG_MEMORY_HOTREMOVE
+extern struct srcu_struct pfn_walk_srcu;
+
+static inline struct srcu_ctr __percpu *pfn_walk_lock(void)
+{
+	return srcu_read_lock_fast(&pfn_walk_srcu);
+}
+
+static inline void pfn_walk_unlock(struct srcu_ctr __percpu *scp)
+{
+	srcu_read_unlock_fast(&pfn_walk_srcu, scp);
+}
+
+static inline void pfn_walk_synchronize(void)
+{
+	synchronize_srcu(&pfn_walk_srcu);
+}
+#else
+static inline struct srcu_ctr __percpu *pfn_walk_lock(void)
+{
+	return NULL;
+}
+
+static inline void pfn_walk_unlock(struct srcu_ctr __percpu *scp)
+{
+}
+
+static inline void pfn_walk_synchronize(void)
+{
+}
+#endif
+
+DEFINE_LOCK_GUARD_0(pfn_walk, _T->scp = pfn_walk_lock(),
+		    pfn_walk_unlock(_T->scp), struct srcu_ctr __percpu *scp)
+
 #ifdef CONFIG_ARCH_WANT_BATCHED_UNMAP_TLB_FLUSH
 void try_to_unmap_flush(void);
 void try_to_unmap_flush_dirty(void);
diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index 796af1028ee23..b5d9e367b893d 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -543,6 +543,16 @@ void remove_pfn_range_from_zone(struct zone *zone,
 	struct pglist_data *pgdat = zone->zone_pgdat;
 	unsigned long pfn, cur_nr_pages;
 
+	/*
+	 * The range is offline, but compaction may still use pages it found
+	 * online.  Make new scans check the online state instead of trusting
+	 * zone->contiguous, and wait for the old ones before poisoning.
+	 */
+	if (!zone_is_zone_device(zone)) {
+		clear_zone_contiguous(zone);
+		pfn_walk_synchronize();
+	}
+
 	/* Poison struct pages because they are now uninitialized again. */
 	for (pfn = start_pfn; pfn < end_pfn; pfn += cur_nr_pages) {
 		cond_resched();
@@ -563,8 +573,6 @@ void remove_pfn_range_from_zone(struct zone *zone,
 	if (zone_is_zone_device(zone))
 		return;
 
-	clear_zone_contiguous(zone);
-
 	shrink_zone_span(zone, start_pfn, start_pfn + nr_pages);
 	update_pgdat_span(pgdat);
 
@@ -1783,6 +1791,8 @@ bool mhp_range_allowed(u64 start, u64 size, bool need_mapping)
 
 #ifdef CONFIG_MEMORY_HOTREMOVE
 
+DEFINE_SRCU_FAST(pfn_walk_srcu);
+
 static int check_no_memblock_for_node_cb(struct memory_block *mem, void *arg)
 {
 	int nid = *(int *)arg;
diff --git a/mm/mm_init.c b/mm/mm_init.c
index 01ced0553ce9b..db610ddc37398 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -2270,8 +2270,8 @@ void set_zone_contiguous(struct zone *zone)
 		cond_resched();
 	}
 
-	/* We confirm that there is no hole */
-	zone->contiguous = true;
+	/* We confirm that there is no hole; pairs with pageblock_pfn_to_page() */
+	smp_store_release(&zone->contiguous, true);
 }
 
 /*
diff --git a/mm/page_alloc.h b/mm/page_alloc.h
index 53df6b8a0c00a..7e185326b80ab 100644
--- a/mm/page_alloc.h
+++ b/mm/page_alloc.h
@@ -216,7 +216,12 @@ extern struct page *__pageblock_pfn_to_page(unsigned long start_pfn,
 static inline struct page *pageblock_pfn_to_page(unsigned long start_pfn,
 				unsigned long end_pfn, struct zone *zone)
 {
-	if (zone->contiguous)
+	/*
+	 * Offline can shrink the zone under a caller's old pfns and then set
+	 * zone->contiguous again, so only trust it inside the current span.
+	 */
+	if (smp_load_acquire(&zone->contiguous) &&
+	    zone_spans_pfn(zone, start_pfn) && zone_spans_pfn(zone, end_pfn - 1))
 		return pfn_to_page(start_pfn);
 
 	return __pageblock_pfn_to_page(start_pfn, end_pfn, zone);
-- 
2.53.0-Meta


