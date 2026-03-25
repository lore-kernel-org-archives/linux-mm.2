Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9C8D5106B506
	for <linux-mm@archiver.kernel.org>; Wed, 25 Mar 2026 12:07:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C8D2E6B008C; Wed, 25 Mar 2026 08:07:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C64BF6B009F; Wed, 25 Mar 2026 08:07:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B54586B00A1; Wed, 25 Mar 2026 08:07:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A4F7F6B008C
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 08:07:16 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 344E01408AB
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 12:07:16 +0000 (UTC)
X-FDA: 84584460072.24.52C11EB
Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	by imf11.hostedemail.com (Postfix) with ESMTP id 2E36840008
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 12:07:13 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=WBZrculv;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf11.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.216.48 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774440434; a=rsa-sha256;
	cv=none;
	b=0az/GZvqDDg81dRTsZINDkO9ehFaisY7fmGJ2ZifmRYkqSvg59V04btEuROqW6QzzzLTjr
	5eFkV2ZFJlpu5WGgD+kcbxWRkBGuztGWihPqIt3ooxDRezcxRbMo7TtCIXqjYH9L2X5o+r
	0epToPmEY4d7OhNBeQvHX/ndioKQN9Q=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=WBZrculv;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf11.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.216.48 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774440434;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=T06KxTkTHY1FoDWVlOdOBzrqwWq1zVmsnyJu+pu2wIk=;
	b=r1ysWs/NNVC9whVksqTO2E8IWBzQepetkQv60K7OwLHXzR2e+X9a0J1wRDYbvr+JgMZgE4
	btlorioiTCQlz/ArwQqecZx6XARx1WMh1/p2kHQR+YQQcH/6I1wdUU9WVs3req8DPQLvKz
	1IByIiXQqRD37K24a1IZKQscHLbNLtk=
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-35a1d4a095bso588116a91.0
        for <linux-mm@kvack.org>; Wed, 25 Mar 2026 05:07:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774440433; x=1775045233; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=T06KxTkTHY1FoDWVlOdOBzrqwWq1zVmsnyJu+pu2wIk=;
        b=WBZrculvnQPlAwqD8PJ+CV9WtREE8QmSxw/q0IGZVna8bPGTX4uHnmTa2ftY6qPNFw
         2DcPjjgGtGhWBgYlcSWQbUob00lcH/r4IFJSziBRZuWfql6I7/7pYUMBO9CUTiCj+Uvo
         OoUecR62rs6/I7T02IytM3akXjN1HHJ+kyRnEdusTzsbYXtcvQXPCsqrj9o4vbjmHWRo
         wyllo0A74VDHPbpXDmQM0d9l5E3UV+OQKaXju1MeCVt8H5s/QB4YIEIEQWEGqFtmED++
         QAOsCgDZxcWFzhbzzNOq5kgaEucEnD/A7vZPlzndF5GD6zdG4gpwAGjNf/vqbVLv57TO
         tlRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774440433; x=1775045233;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=T06KxTkTHY1FoDWVlOdOBzrqwWq1zVmsnyJu+pu2wIk=;
        b=XUAVhiXOjfFERocJi+pBLybiTBmqXrWTW3pZLd4ccX8QdGabU1y2foOblkNo90EAeD
         HrKIVCQuR2l/QqFXNrELHfpJb+LMKUlkz9EW7BZzH3+QYaLuskOCD6KBlPT6m32QB2i+
         qcPFDgBQ9gpSNL8d9qMhWXj4F7k5lf3IGsSwgshmlNFEQEF76dEQoLz5goevocEdVioe
         PdMfwgRXPPZejDJ8UtiUL88fnup+8IwVV8YsauWuwuUeHCNvFWSzcAzTnQiJ0nsmB7im
         MxlhRN+XGVIPTWwVrWbvy7zbtPdBVo6+qZctkqOyeeQafoI4r6+y+vH+GZBivKwfrTN8
         yGAA==
X-Forwarded-Encrypted: i=1; AJvYcCWKo+n9k1fSOaLaqyO89/3cVW1EYNWfdcMbUiA1fr3Gqxw2cY4kCCSWfYc9GHjPx0M7TMxsInAg6g==@kvack.org
X-Gm-Message-State: AOJu0YwLZrtQNAy09WaK4C0CX/yxGwgVAXLQGCfr6fD7vQwTdSoHr8kX
	eicBAaKxz4D9+DriptMIolm8CM80ua1oZjxLYRyvHw/fiMUNU/2evrOa
X-Gm-Gg: ATEYQzz3umwmrBVylGe5NdD3itnCs0P6s4J+SSvjXjrNZwPlpt6PJFeWR+KNfwUKS7+
	ZpLTEkj7HBzAO6GW1xxUdjGkcgASJ2gasP/lcuK6MprgcyPPlED0n1a/YHq1MVuaYhVM/Eces3y
	2UVpH7X0xWtuk3heR4py+sgP6D1ZWPmgwpQMnZ4vbjgXrn5gH8oJ+NpHJxNW+GBU8LBqat4f808
	xQQ+TG100Q1SHo7/TtVSkEO7/aomjl3uvsD/YhFaA8dAvIFximNOnMDSLFGsvNRUOHRU67t/QmG
	11zlafT3HI+xEK8nJOU/y+98E66kWRgdgj8+3YFrLxccY2TR5CqRs59kiC9HYk6qOKZemG8bst7
	nBjZjPQbSNU9+3CANMSu0r0OMpgMHlAoK8g0L4gUNBm1H5omBZ003k8eB3mDvtTXRYj5qFIbRZJ
	EiJEFrcuEIl7KHTKe+8UfH4hPjpy3ps72xrAu1dUwFZcBV05o6ifRXVoZLBFkWRr4/OP2P4w==
X-Received: by 2002:a17:90b:1dcd:b0:35c:69c:2a12 with SMTP id 98e67ed59e1d1-35c0cffc5eemr2959300a91.0.1774440432756;
        Wed, 25 Mar 2026 05:07:12 -0700 (PDT)
Received: from KASONG-MC4 ([101.32.222.185])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-35c0db12e2bsm1085438a91.0.2026.03.25.05.07.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Mar 2026 05:07:12 -0700 (PDT)
Date: Wed, 25 Mar 2026 20:07:06 +0800
From: Kairui Song <ryncsn@gmail.com>
To: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: akpm@linux-foundation.org, hannes@cmpxchg.org, david@kernel.org, 
	mhocko@kernel.org, zhengqi.arch@bytedance.com, shakeel.butt@linux.dev, 
	axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com, baohua@kernel.org, 
	kasong@tencent.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] mm: vmscan: fix dirty folios throttling on cgroup v1
 for MGLRU
Message-ID: <acPOn07xah2eh0WU@KASONG-MC4>
References: <bf40a20cd93b6c21f10db95657928fdae185e843.1774438978.git.baolin.wang@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bf40a20cd93b6c21f10db95657928fdae185e843.1774438978.git.baolin.wang@linux.alibaba.com>
X-Stat-Signature: c5fmudmn55iktq93j55qc5ahejxb6kuk
X-Rspamd-Queue-Id: 2E36840008
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1774440433-610813
X-HE-Meta: U2FsdGVkX19zK3eKnFTTnenUlp/jmxZpRX6v781gKTvWQn8KR3s0QDnuYgREpvIDKM5qlijJRv6DFwgSNL6I9TyWoajZUtiNDsU6Jto9xdzf7qRB1Sdc4qLpMYNOJLuEddM/LQ3P61XqtxjF1JVUhqLjCeoc8yiPBIxUisUQd+75b2faKPeBt+QwPLMycvVq1N09KwYDX+wurYKtBMyZRBuns5n194Y8ksTfqpjIYgmGM7xtRUCEcrgjkTMM0R5iGd2tBbdwLiL2mCW8L66Pu++0rH3PbJDogHQrplQ4Aav/d2dxvasIX7oe4lc9QUvgBNI/vtgLV1/F3Y6p2Z4XGRi68bhcCmx65U5AvN3qzDwP26W0zMwneOMTx7EbvPDt3sG0X9jccl5R5pRdAExHgpD+hDudaY7fmuLytkhkNq5LjhsEiVxTc0PL44fqOCxM9BIUsJV3HT3fCg1kPn/4YzA5pHSUND3mw3GSeWMGWZOGAnx+EbspHv9k5eoNnFpAH0nsV+9Gz/udZTg4n8tI84YecEbBqH3MTllutrudS7OhCc+mZ8DywxMhQSUCGbznilmr+FKwLGUJ4c+bhZcxUBUDRqDXYQOd0t2XGFtr4F6ndtIscq251bkm3+cXRMIk4ipkXHeGvYK09Nq8XsKy9iNs3U82WWuvFdhJj6LnukbTZQCj3X2NrgMhKFsV0y/70G5xGq4HQp+NvP95XFLjSsVkzRxv5C9bMMZr9QyxRpieX9hpaPeDFTAAuvWW43vp45qySKRoZKkaSw5sabqwIiQSTafBPA876VoShA5JSS6UFf8YnDcF7tgfGnGXFU0FUwgzc+fRuo5DTZyp8NKYwchFakmoIwjX9p0C42FfNFJHIiM8ORyN4a95kPctntJQIjV2hrIS/71bsL0W8/Y9xhUyYdyDqcXfjInUdtzrr3aTh6zO1sfU7/XVXCgxgcNLNqfSL7dY4pSA8FAT9Zg
 /0ZIdq8P
 osvAqMm7wOr3aZFN61h5yg8YKhthHKGJijYDoxQqZ6Q6W+ADeWSFZzzDNkX6Fa8b/buTsXvOoyNQOkwpQBz+sJCHWqrqx7cLN9uYRMrPzYLwCal7njlKFroav5Ek9vdKXZjSl6S8N2YkvZL2I79DX0w02hxtInKikvI2eMRVDyqOecMRhlWiW+bnXkyYBzhwUPQeBRdd3vtZ+ZPwsUe1LlYRzP2a3MgXU+Gg/Dzq+esaoRZltMnXHt4x6eoUuuQP4lXqfuMDMeJUvSVCatwXCxdQw8itC9jaPHn+yMxoyY1VfcFkAdRNtLWx9H4siU/pdeFtEumtoA83BwLjNtkxOUXy0lRihkcoITrajbulioYsjHJq7UrOmgQkY669cvIL+PqaULmS+pgkMAqCTAknOUceUkQkPAROXbtm79SDqIawivnrCtcKvQdyWoaPq90bnKuadrt1wsG4qfdvosZBBaFKMwCC78WCD2N613tGDqkTCqsdOIKeLqQWhEg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Mar 25, 2026 at 07:50:40PM +0800, Baolin Wang wrote:
> The balance_dirty_pages() won't do the dirty folios throttling on cgroupv1.
> See commit 9badce000e2c ("cgroup, writeback: don't enable cgroup writeback
> on traditional hierarchies").
> 
> Moreover, after commit 6b0dfabb3555 ("fs: Remove aops->writepage"), we no
> longer attempt to write back filesystem folios through reclaim.
> 
> On large memory systems, the flusher may not be able to write back quickly
> enough. Consequently, MGLRU will encounter many folios that are already
> under writeback. Since we cannot reclaim these dirty folios, the system
> may run out of memory and trigger the OOM killer.
> 
> Hence, for cgroup v1, let's throttle reclaim after waking up the flusher,
> which is similar to commit 81a70c21d917 ("mm/cgroup/reclaim: fix dirty
> pages throttling on cgroup v1"), to avoid unnecessary OOM.
> 
> The following test program can easily reproduce the OOM issue. With this patch
> applied, the test passes successfully.
> 
> $mkdir /sys/fs/cgroup/memory/test
> $echo 256M > /sys/fs/cgroup/memory/test/memory.limit_in_bytes
> $echo $$ > /sys/fs/cgroup/memory/test/cgroup.procs
> $dd if=/dev/zero of=/mnt/data.bin bs=1M count=800
> 
> Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> ---
>  mm/vmscan.c | 13 ++++++++++++-
>  1 file changed, 12 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 33287ba4a500..a9648269fae8 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -5036,9 +5036,20 @@ static bool try_to_shrink_lruvec(struct lruvec *lruvec, struct scan_control *sc)
>  	 * If too many file cache in the coldest generation can't be evicted
>  	 * due to being dirty, wake up the flusher.
>  	 */
> -	if (sc->nr.unqueued_dirty && sc->nr.unqueued_dirty == sc->nr.file_taken)
> +	if (sc->nr.unqueued_dirty && sc->nr.unqueued_dirty == sc->nr.file_taken) {
> +		struct pglist_data *pgdat = lruvec_pgdat(lruvec);
> +
>  		wakeup_flusher_threads(WB_REASON_VMSCAN);
>  
> +		/*
> +		 * For cgroupv1 dirty throttling is achieved by waking up
> +		 * the kernel flusher here and later waiting on folios
> +		 * which are in writeback to finish (see shrink_folio_list()).
> +		 */
> +		if (!writeback_throttling_sane(sc))
> +			reclaim_throttle(pgdat, VMSCAN_THROTTLE_WRITEBACK);
> +	}
> +
>  	/* whether this lruvec should be rotated */
>  	return nr_to_scan < 0;
>  }

Hi Baolin

Interesting I want to fix this too, after or with:
https://lore.kernel.org/linux-mm/20260318-mglru-reclaim-v1-0-2c46f9eb0508@tencent.com/

With current fix you posted, MGLRU's dirty throttling is still
a bit different from active / inactive LRU. In fact MGLRU
treat dirty folios quite differently causing many other issues too,
e.g. it's much more likely for dirty folios to stuck at the tail
for MGLRU so simply apply the throttling could cause too
aggressive throttling. Or batch is too large to trigger the
throttling.

So I'm planning to add below patch to V2 of that series (also this
is suggested by Ridong), how do you think? There are several
other throttling things to be fixed too, more than just the
V1 support. I can have your suggested-by too.

commit e9fc6fe9c1236f7f70eeb45d9c47c56125d14013
Author: Kairui Song <kasong@tencent.com>
Date:   Tue Mar 24 19:45:26 2026 +0800

    mm/vmscan: unify writeback reclaim statistic and throttling
    
    Currently MGLRU and non-MGLRU handles the reclaim statistic and
    writeback handling, especially throttling differently. For MGLRU the
    throttling part is basically ignore.
    
    Let just unify this part so both setup will have the same behavior.
    
    Signed-off-by: Kairui Song <kasong@tencent.com>

diff --git a/mm/vmscan.c b/mm/vmscan.c
index bdf611544880..fcb91a644277 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1943,6 +1943,44 @@ static int current_may_throttle(void)
 	return !(current->flags & PF_LOCAL_THROTTLE);
 }
 
+static void handle_reclaim_writeback(unsigned long nr_taken,
+				     struct pglist_data *pgdat,
+				     struct scan_control *sc,
+				     struct reclaim_stat *stat)
+{
+	/*
+	 * If dirty folios are scanned that are not queued for IO, it
+	 * implies that flushers are not doing their job. This can
+	 * happen when memory pressure pushes dirty folios to the end of
+	 * the LRU before the dirty limits are breached and the dirty
+	 * data has expired. It can also happen when the proportion of
+	 * dirty folios grows not through writes but through memory
+	 * pressure reclaiming all the clean cache. And in some cases,
+	 * the flushers simply cannot keep up with the allocation
+	 * rate. Nudge the flusher threads in case they are asleep.
+	 */
+	if (stat->nr_unqueued_dirty == nr_taken && nr_taken) {
+		wakeup_flusher_threads(WB_REASON_VMSCAN);
+		/*
+		 * For cgroupv1 dirty throttling is achieved by waking up
+		 * the kernel flusher here and later waiting on folios
+		 * which are in writeback to finish (see shrink_folio_list()).
+		 *
+		 * Flusher may not be able to issue writeback quickly
+		 * enough for cgroupv1 writeback throttling to work
+		 * on a large system.
+		 */
+		if (!writeback_throttling_sane(sc))
+			reclaim_throttle(pgdat, VMSCAN_THROTTLE_WRITEBACK);
+	}
+
+	sc->nr.dirty += stat->nr_dirty;
+	sc->nr.congested += stat->nr_congested;
+	sc->nr.writeback += stat->nr_writeback;
+	sc->nr.immediate += stat->nr_immediate;
+	sc->nr.taken += nr_taken;
+}
+
 /*
  * shrink_inactive_list() is a helper for shrink_node().  It returns the number
  * of reclaimed pages
@@ -2006,39 +2044,7 @@ static unsigned long shrink_inactive_list(unsigned long nr_to_scan,
 	lruvec_lock_irq(lruvec);
 	lru_note_cost_unlock_irq(lruvec, file, stat.nr_pageout,
 					nr_scanned - nr_reclaimed);
-
-	/*
-	 * If dirty folios are scanned that are not queued for IO, it
-	 * implies that flushers are not doing their job. This can
-	 * happen when memory pressure pushes dirty folios to the end of
-	 * the LRU before the dirty limits are breached and the dirty
-	 * data has expired. It can also happen when the proportion of
-	 * dirty folios grows not through writes but through memory
-	 * pressure reclaiming all the clean cache. And in some cases,
-	 * the flushers simply cannot keep up with the allocation
-	 * rate. Nudge the flusher threads in case they are asleep.
-	 */
-	if (stat.nr_unqueued_dirty == nr_taken) {
-		wakeup_flusher_threads(WB_REASON_VMSCAN);
-		/*
-		 * For cgroupv1 dirty throttling is achieved by waking up
-		 * the kernel flusher here and later waiting on folios
-		 * which are in writeback to finish (see shrink_folio_list()).
-		 *
-		 * Flusher may not be able to issue writeback quickly
-		 * enough for cgroupv1 writeback throttling to work
-		 * on a large system.
-		 */
-		if (!writeback_throttling_sane(sc))
-			reclaim_throttle(pgdat, VMSCAN_THROTTLE_WRITEBACK);
-	}
-
-	sc->nr.dirty += stat.nr_dirty;
-	sc->nr.congested += stat.nr_congested;
-	sc->nr.writeback += stat.nr_writeback;
-	sc->nr.immediate += stat.nr_immediate;
-	sc->nr.taken += nr_taken;
-
+	handle_reclaim_writeback(nr_taken, pgdat, sc, &stat);
 	trace_mm_vmscan_lru_shrink_inactive(pgdat->node_id,
 			nr_scanned, nr_reclaimed, &stat, sc->priority, file);
 	return nr_reclaimed;
@@ -4848,17 +4854,11 @@ static int evict_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
 retry:
 	reclaimed = shrink_folio_list(&list, pgdat, sc, &stat, false, memcg);
 	sc->nr_reclaimed += reclaimed;
+	handle_reclaim_writeback(isolated, pgdat, sc, &stat);
 	trace_mm_vmscan_lru_shrink_inactive(pgdat->node_id,
 			type_scanned, reclaimed, &stat, sc->priority,
 			type ? LRU_INACTIVE_FILE : LRU_INACTIVE_ANON);
 
-	/*
-	 * If too many file cache in the coldest generation can't be evicted
-	 * due to being dirty, wake up the flusher.
-	 */
-	if (stat.nr_unqueued_dirty == isolated)
-		wakeup_flusher_threads(WB_REASON_VMSCAN);
-
 	list_for_each_entry_safe_reverse(folio, next, &list, lru) {
 		DEFINE_MIN_SEQ(lruvec);
 
@@ -4901,6 +4901,7 @@ static int evict_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
 
 	if (!list_empty(&list)) {
 		skip_retry = true;
+		isolated = 0;
 		goto retry;
 	}

