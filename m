Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 231D3CA1016
	for <linux-mm@archiver.kernel.org>; Tue,  9 Sep 2025 00:06:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 44DB96B0008; Mon,  8 Sep 2025 20:06:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 425A06B000D; Mon,  8 Sep 2025 20:06:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 363076B000E; Mon,  8 Sep 2025 20:06:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 23E606B0008
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 20:06:55 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E15F8C0365
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 00:06:54 +0000 (UTC)
X-FDA: 83867771148.28.CB3E201
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 2C22840004
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 00:06:52 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=I2nSe9qC;
	spf=pass (imf17.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757376413;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=L1dN8mhUwncXUbZoBXV/zInq23pbUrWI2fWcuhmdYLg=;
	b=R7DbNJIG4x3SCV1nG3GY6jrOwYKjVaOplwMDwh5mNjRgXsy/2PlQkm3guaTuf4Hri2PVMs
	H0d+ZDhPkQ32qU+Aa/b0CSrN8ZoP53/MHXXONfqtrzworscZA1hbpsR1L4MGXvsHeTLEG7
	S/m6VogBK6to+qntzb5hXI+54VH+qZc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757376413; a=rsa-sha256;
	cv=none;
	b=dkGdTq6jQ1k+VrcC6fmw02yrf52L+aEwX9Q7nvejRBCeysTzmJO9yAAhkkgxlHBlP15Ns3
	vZYJLsAz88uaY4Ys9B9zIr774AyjV4VHiwuS8rXTItUneee5QmnKQ8voRflR0xd8JkjKLO
	VIXWjZxO528MkmtRlxsY0vrm+LXN9Mc=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=I2nSe9qC;
	spf=pass (imf17.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id D29A644590;
	Tue,  9 Sep 2025 00:06:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C258C4CEF1;
	Tue,  9 Sep 2025 00:06:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1757376411;
	bh=W7ol01lPQCi9U0PzekdKliJMNYlWPZdelv3Gv7IpeyA=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=I2nSe9qC01GSe7mwpS8oGS/2GQ+9h7D00mXiH8V25ANgBEAEGCtWHot8cAkGokvqR
	 kHLnjUasBBPh8aAIHEpcikfsMgnu2NGhSP3CD8uL0sieEDCbQluja2GF8D5AA82mHI
	 JQKFiUzQ5KhIHpbuiaklwqgYqYvJh/AcKtcEvo2U=
Date: Mon, 8 Sep 2025 17:06:50 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Chanwon Park <flyinrm@gmail.com>
Cc: vbabka@suse.cz, surenb@google.com, mhocko@suse.com, jackmanb@google.com,
 hannes@cmpxchg.org, ziy@nvidia.com, david@redhat.com,
 zhengqi.arch@bytedance.com, shakeel.butt@linux.dev,
 lorenzo.stoakes@oracle.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: re-enable kswapd when memory pressure subsides or
 demotion is toggled
Message-Id: <20250908170650.8ede03581f38392a34d0d1f7@linux-foundation.org>
In-Reply-To: <aL6qGi69jWXfPc4D@pcw-MS-7D22>
References: <aL6qGi69jWXfPc4D@pcw-MS-7D22>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 2C22840004
X-Stat-Signature: nrqc1rbzeby6x6c47w6rc9qifb9cyfqj
X-Rspam-User: 
X-HE-Tag: 1757376412-13216
X-HE-Meta: U2FsdGVkX19cb6DlIhUyaK40ntqk60tynC65lx7eyjXjwS8EG5w8EpGZ1SLAdupjl3IaH3klN41OC9J6Q9dzHP6fFO3+DhAJWYM/DJA2UncpDQkmqGzXOTEY8LvoKBlo8GqPfvdPtGGNX8+0ZkarK1ql7QgnS4fN0I9Q37zhJmsTZASeZQJE72k5U0Q3n7P4b11LQCQc66cUpXeT/F8s9JRGS4lzKV3tiBz43WRQnqcomRA4zMb5pFWNMbg+/m5K4d/DU0b69auz5dUZ6ALnz9zp/G9UQIi6i0+Zx9fE6LqCU7BFwbdkB4Qj7+zHc8uuu8q+yUO/Kdo/bOJp98XdecpIHCtdM1RYVGHCOPhH0ciWaKpl6BOHQwPp4OqtC2rdSr66qYOKBT2MEqdWlp7huQtbM8KAIiUm/BhwoCsgnepUpFh4AR/rKszbdFPY2PTlPzcqF47Vr0BPpAUymC4R9E6wVSERpxQL5xxUayaA1bgKw9Mc24awKUlJ8mbVhbXSPXGUBEOFgmUawm0PNSPj6GG/GHRMeIhwNbUZU8+xqT7j3y/suxXhBFNzyr4G9POyJNwyl9s7g7kHS/6LDD/mTuVbAH1tRYiN1dI4pkRhAqu1IRsfs4Ihd1X36cNrIsaZpUwudrImnnne39iPHKxE9matw/qV1z+qcAp7BasQBkKc7M/3PFPI4VsLXZnWZ2jdInZHQyaiCrqeNL0ZwXNqYBKlSk3g0J2R6B0wrIJ27R4obrK9OIWKN6P1RQ9mUXr5xAcIaRR+KZOG/bIikw7JMuHg3vWSCtmp/Qzm1uJJdPnsc5tdAzYMFl8RSDQFLnruCiAeEIaVuJdMNJy9cY43uek3LlVDHiJpTRl9fBSiZmPfGOTMPEi1Kc4GuGCqWYDV5z3kuafqarjdUmNAAuGCZ9jn7B7zqXRj6fWwo84ZMi4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 8 Sep 2025 19:04:10 +0900 Chanwon Park <flyinrm@gmail.com> wrote:

> If kswapd fails to reclaim pages from a node MAX_RECLAIM_RETRIES in a
> row, kswapd on that node gets disabled. That is, the system won't wakeup
> kswapd for that node until page reclamation is observed at least once.
> That reclamation is mostly done by direct reclaim, which in turn enables
> kswapd back.
> 
> However, on systems with CXL memory nodes, workloads with high anon page
> usage can disable kswapd indefinitely, without triggering direct
> reclaim. This can be reproduced with following steps:
> 
>    numa node 0   (32GB memory, 48 CPUs)
>    numa node 2~5 (512GB CXL memory, 128GB each)
>    (numa node 1 is disabled)
>    swap space 8GB
> 
>    1) Set /sys/kernel/mm/demotion_enabled to 0.
>    2) Set /proc/sys/kernel/numa_balancing to 0.
>    3) Run a process that allocates and random accesses 500GB of anon
>       pages.
>    4) Let the process exit normally.

hm, OK, I guess this is longstanding misbehavior?

> 
> Since kswapd_failures resets may be missed by ++ operation, it is
> changed from int to atomic_t.

Possibly this should have been a separate (earlier) patch.  But I
assume the need for this conversion was inroduced by this patch, so
it's debatable.

> --- a/include/linux/mmzone.h
> +++ b/include/linux/mmzone.h
> @@ -1411,7 +1411,7 @@ typedef struct pglist_data {
>  	int kswapd_order;
>  	enum zone_type kswapd_highest_zoneidx;
>  
> -	int kswapd_failures;		/* Number of 'reclaimed == 0' runs */
> +	atomic_t kswapd_failures;	/* Number of 'reclaimed == 0' runs */

This caused a number of 80-column horrors!  I had a fiddle, what do you
think?

--- a/mm/page_alloc.c~mm-re-enable-kswapd-when-memory-pressure-subsides-or-demotion-is-toggled-fix
+++ a/mm/page_alloc.c
@@ -2860,29 +2860,29 @@ static void free_frozen_page_commit(stru
 		 */
 		return;
 	}
+
 	high = nr_pcp_high(pcp, zone, batch, free_high);
-	if (pcp->count >= high) {
-		free_pcppages_bulk(zone, nr_pcp_free(pcp, batch, high, free_high),
-				   pcp, pindex);
-		if (test_bit(ZONE_BELOW_HIGH, &zone->flags) &&
-		    zone_watermark_ok(zone, 0, high_wmark_pages(zone),
-				      ZONE_MOVABLE, 0)) {
-			struct pglist_data *pgdat = zone->zone_pgdat;
-			clear_bit(ZONE_BELOW_HIGH, &zone->flags);
+	if (pcp->count < high)
+		return;
 
-			/*
-			 * Assume that memory pressure on this node is gone
-			 * and may be in a reclaimable state. If a memory
-			 * fallback node exists, direct reclaim may not have
-			 * been triggered, leaving 'hopeless node' stay in
-			 * that state for a while. Let kswapd work again by
-			 * resetting kswapd_failures.
-			 */
-			if (atomic_read(&pgdat->kswapd_failures)
-			    >= MAX_RECLAIM_RETRIES &&
-			    next_memory_node(pgdat->node_id) < MAX_NUMNODES)
-				atomic_set(&pgdat->kswapd_failures, 0);
-		}
+	free_pcppages_bulk(zone, nr_pcp_free(pcp, batch, high, free_high),
+			   pcp, pindex);
+	if (test_bit(ZONE_BELOW_HIGH, &zone->flags) &&
+	    zone_watermark_ok(zone, 0, high_wmark_pages(zone),
+			      ZONE_MOVABLE, 0)) {
+		struct pglist_data *pgdat = zone->zone_pgdat;
+		clear_bit(ZONE_BELOW_HIGH, &zone->flags);
+
+		/*
+		 * Assume that memory pressure on this node is gone and may be
+		 * in a reclaimable state. If a memory fallback node exists,
+		 * direct reclaim may not have been triggered, causing a
+		 * 'hopeless node' to stay in that state for a while.  Let
+		 * kswapd work again by resetting kswapd_failures.
+		 */
+		if (atomic_read(&pgdat->kswapd_failures) >= MAX_RECLAIM_RETRIES &&
+		    next_memory_node(pgdat->node_id) < MAX_NUMNODES)
+			atomic_set(&pgdat->kswapd_failures, 0);
 	}
 }
 
--- a/mm/show_mem.c~mm-re-enable-kswapd-when-memory-pressure-subsides-or-demotion-is-toggled-fix
+++ a/mm/show_mem.c
@@ -278,8 +278,8 @@ static void show_free_areas(unsigned int
 #endif
 			K(node_page_state(pgdat, NR_PAGETABLE)),
 			K(node_page_state(pgdat, NR_SECONDARY_PAGETABLE)),
-			str_yes_no(atomic_read(&pgdat->kswapd_failures)
-				   >= MAX_RECLAIM_RETRIES),
+			str_yes_no(atomic_read(&pgdat->kswapd_failures) >=
+				   MAX_RECLAIM_RETRIES),
 			K(node_page_state(pgdat, NR_BALLOON_PAGES)));
 	}
 
_


