Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9A303606A319
	for <linux-mm@archiver.kernel.org>; Wed, 21 Oct 2026 02:40:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=lovLgu/T
Received: by kanga.kvack.org (Postfix)
	id 2F15E6B05B0; Tue, 20 Oct 2026 22:39:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2A1B16B05B2; Tue, 20 Oct 2026 22:39:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 143206B05B1; Tue, 20 Oct 2026 22:39:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E2AF56B05AF
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 22:39:53 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 730AEA7EE6
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 02:39:53 +0000 (UTC)
X-FDA: 85345078266.04.A28BCFB
Received: from mail-qv1-f54.google.com (mail-qv1-f54.google.com [209.85.219.54])
	by imf30.hostedemail.com (Postfix) with ESMTP id B0CC780005
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 02:39:51 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b="lovLgu/T";
	spf=pass (imf30.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.54 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792550391;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/jQfbSOqJoBgAbQs/XcGflZND2lk7u6m7SNdjISK0qQ=;
	b=WfZyBzH5WozALpkvSTucr18Q7kM7c83D7DmVcVsdr5n9bfJLh8KKnRVHnomBgpoIXeR7ga
	klyVrCI5mZpPd/UbY9G0HeU8dPl/xtACgkkqOOAbX9Z365wz27OhnpNDesP74S++S5hERx
	qtPzF6Hk3uWIu7E72zBBoW25oXyddE0=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b="lovLgu/T";
	spf=pass (imf30.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.54 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792550391;
	b=UZlDJvhMM2m6/rrYJc4IsI3CcYgvfUW/hX81HH3AIKV7v3SznWhdXJdc9GwVU1eQt4i6Qq
	XrYlH2uyAPCESdPSgUjQto2xoitRpZ5tSzrZgUzeQE4IzukCKxWB2coLL+1w3hxcfxwvIR
	4otxq3HWKri/dsuulE3VH4cV3Xx4lvI=
Received: by mail-qv1-f54.google.com with SMTP id 6a1803df08f44-91b83459526so3423106d6.2
        for <linux-mm@kvack.org>; Tue, 20 Oct 2026 19:39:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1792550391; x=1793155191; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=/jQfbSOqJoBgAbQs/XcGflZND2lk7u6m7SNdjISK0qQ=;
        b=lovLgu/T5zDOvHGotB9o9kqlajZvspw4YM8DkmoIes/uyzexC7U7p53WulOkX52e13
         0CCrKaKl+kk3ItHtHZY2lUSJVX+u/ci8cpzsH3ysL2I310xP2NnldjudvJ1u7wgKQxtf
         8Fr+2qjC/RM5WF7ugqq8kmB3yCIHY1Bvy3NqRyWp0PTlCujr/RvRyOcpqjA8FUI6V3i3
         PW5CWzGKtt7y7s3wT664VGMkOexSx9mXYrt7pmR/3Uo/wWSGVuiw0nwgu9pA24Z0L61X
         VcLVFoy3gpd1gVamf2UiORzcXntrzZYh3UO9ZSqAdZebl8vfodVwLiMTPtAA2stJYgg1
         yNaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792550391; x=1793155191;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=/jQfbSOqJoBgAbQs/XcGflZND2lk7u6m7SNdjISK0qQ=;
        b=PTCRo5FNMJ/JzGPeakc1HDtFNmhR1XHqS+Vf7OvDSJjyc+I3gsuMt7tt7dJuBd6JEy
         zom8KcO+FZoj/itSVgwhuC6AMtUcFdkRUs+SguX+Zb5mrNqAXSoAevArZVYCAls80pSf
         T50sZZzQ2lYh7p0YEitZuLLUWQWzYWxrUjSwAye6qjUPOtxQjSKywcWWB0J5aQwmfd0d
         k6/+0p9kO1DElxH15NA+ECoH4LX0tsDID0GarPSoJVkpIDt0ZnZOH/EvhRMerSPdu+Jm
         iKBKFsxCx/BeKACmDZ34ETQTcdLRHOLGac24UygEnF5mpE2Zb5a4MEe4vkoi+DDucrHy
         sh5g==
X-Gm-Message-State: AFq9FYJ5OKiRCi/kRgdB6bs2Rj9y5nNe3WtZAL53zg07vK6uXCih3LEX
	QQHLLJsNBtDIx3OuqnFOO1kjPB/iPGw4v04FV0M7qpT0VylBg6OxK0sWRHILHvKCNTaIb8RvGo7
	xSFoN
X-Gm-Gg: AYBFou31gBxHUk1SW6dN6tGq1hUfuzERbJgjDZKWoqLjL+q4fiLDb5NI0rTrKuGXo1I
	ruq2BBVFoLln1tTUEjaNJLCh2bnfpthA5Uy7Djmdg46p7+7w7njV5tnBV6kHZJc4PkMh0NTMOTh
	o7tCWNjI9PlyKf593GLAfg3jfN0N7sDgeMTr8vgTqhbmfLW0PM68fYdwywx+H5B7bQ3ZllMPoBD
	ZEzt4//J91K7k6Qu7zTjEaHJA+iFx2QGPFHAnInsOwjUvpy8GwowrJ3rIHOnQKZfnnSwYEm+FHN
	+c7efOPkkeWyoaAuc6jBfg0lK2UwnJo0ZzfrKEekIkurnmSsC9IJxKPKzXqpro0wGPpRl/naa/W
	02x0vWSTc7KQsRoxZakITxvaWsCcTepVumSFwwV2EjA26dmYMv4u1Esicoh0EblAbilwOSy1B5E
	ORmCZ3Qx1VIDY1kQUu4GPrJHHAXHMMgAwAP7kCN8mhn6Zb8EPwjDKyq2rELYKNJoVUJCFnUWhuI
	jueHDNAp5Uc7rtbYlRIyCpn/nmce3wPUtlgR84x+zFlQr+Lg/wTwJ3BIZ/Jr9UvrfX3M7jZUZ1J
	gRaSMf3BCv2GCvhzj2VKxGq7CsiHzmJO59gb1CJdQw==
X-Received: by 2002:a05:6214:20e5:b0:919:5a24:d77c with SMTP id 6a1803df08f44-91c12f1d462mr11333536d6.31.1792550390950;
        Tue, 20 Oct 2026 19:39:50 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91c10a45336sm13819426d6.3.2026.10.20.19.39.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Oct 2026 19:39:50 -0700 (PDT)
From: "Gregory Price (Meta)" <gourry@gourry.net>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org,
	linux-rt-devel@lists.linux.dev,
	kernel-team@meta.com,
	akpm@linux-foundation.org,
	mhocko@suse.com,
	rientjes@google.com,
	shakeel.butt@linux.dev,
	rostedt@goodmis.org,
	mhiramat@kernel.org,
	mathieu.desnoyers@efficios.com,
	muchun.song@linux.dev,
	osalvador@suse.de,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	brendan.jackman@linux.dev,
	hannes@cmpxchg.org,
	ziy@nvidia.com,
	bigeasy@linutronix.de,
	clrkwllms@kernel.org,
	mgorman@techsingularity.net,
	anshuman.khandual@arm.com,
	Bessel.Wang@huawei.com,
	jiang.liu@huawei.com,
	stable@vger.kernel.org
Subject: [PATCH v3 4/8] mm/page_alloc: pass the zone, not the zoneref, to reclaim_retry_zone
Date: Tue, 20 Oct 2026 22:39:36 -0400
Message-ID: <20261021023940.1940971-5-gourry@gourry.net>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261021023940.1940971-1-gourry@gourry.net>
References: <20261021023940.1940971-1-gourry@gourry.net>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: B0CC780005
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: zqe4qccjdibw64e1iejxreeupdmy56zx
X-HE-Tag: 1792550391-342044
X-HE-Meta: U2FsdGVkX1+me30uq6ZNbDHUKnhIwh5/+DqiJluLPug6V2470kNqC5OPTo/A7BoWL921+hOLG93G36wVIFvWGRyiABVEa8zivT3ZR+7Jfw7QC6hdFbRkJI/dK1V7JCjaa+ixbsPMnwgWimhQ1hLJ1gnvYNHPf/F23KF5LNPJ/ikTbH7NFPJNpthys+J/rv8Hn+368GRgE0XIfels8bSCgwJ1gPqTUTXAXq41g9wnODvjAii6OUuhdf83HNgiBzWbNGboffJtnAbItyzbZwk+bVbBLFcRRG6mOCYRSQawBalWI5bRjawTNPsPR36TRysM+bpJ29ncVFhhy3MR+ucHrux/9O7Y2wWDrVHMoqfmRec0pssw+lqyJ2PLLt3Pkt9WzBtI893GrACngimaO0qsqDCt4nKfvQKTOhFDCBa/+A0ep+sfGdFDsOuOpxSIkow8XiUrE77mkD1p9/OkKLHZH7cbxUX7Cd9xyJQqpxw+LBoNcGVhTpwrS05U+QyFFddFiYrqt1l+5vAx4LmHl80LVArwLfcNcL5zF5OQntFpvpsHfsxJcGN4SiPmS6JjMgCYJtwVa8fzcDPTW7aTR8/mp21y57BuongHkVuBmib7UCqbVD/ESL0DdBnWbnTRTu4WVtyBchx1nsUfWFA+N3/b+6Q13PjRe+l2AkGjgqxzFM/JYGmCwx2rrspIQbgih9jahkWnAeALlejKT8Aiv6QSIdLuWfrNFmeha1GnkU0U6xKFKal8tRwcdgRq7uY3P9J2bIwkEoSiGyBkphal7ylJAR4P4+vKGWNrPYhwcHgipWybeZGIT4OI7ePjlVqf+2zrq/smcciqV7zuQi+HLk/fmsGQTQvxqLnkrj66bDTFBY05OMTHDswxXPhcnBQBJkk6Cdd/lMHRpyvxbuBsc6Ufz+c/gc1ttH0V1xAP12d2U3Jd1PFd4iycImmbQl8CyC5djKMEvVy09Q979K7vOxa
 crKOcOYZ
 HCTVzIF2U+JTKHVKq9VyJ0KMx3dv/O+qhFf8ffqApnsbIh4DhiV2dSrVjv3UD3w5kehX3rzUo2tqV1mbUFqyIkBhGlMK6NcQXQ/X8ujZaVOjixZnd5Rc3d5w9r6jAgrLeM7/6nWVeqc+QkR4juaH+OaCaL2bUA5ZuBBWrnfZmdmIZYT1Dkwoj9LbiUNq770JER2KYqLjlaBHK1a/PRjfmcgl7FUJauVjfMsJGDyAXUSHeXITugZtgr8TfI0BOY1lCBRFcmRKOhXDLMYMj/c+e9vs9fvSiei6Mof6dAwrAopSXHHzaqN60RpNFJmvYUOtYG3CBpV9ExXRXKgsY0IKG0cYwhwQfHA3u0bhZIvyrMWygbYtExlK9Vr0cbp5WO1/jph3c7kJjjvdjixuoqhy403OiXzi+yQTDLKo4CEITPe02FrosFnWWkQOaIrfnlS63iRe1
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

should_reclaim_retry() hands the reclaim_retry_zone tracepoint the
zoneref it is walking, and the tracepoint reads the slot again for the
zone's node and index. Offlining a zone's last block rebuilds the
zonelists in place, and the shrunk list's NULL terminator can land on
that slot in between:

  CPU 0                             CPU 1
  should_reclaim_retry()
    zone = zonelist_zone(slot 1)    /* NORMAL1 */
    zone_reclaimable_pages(zone)
                                    offline_pages()
                                      build_all_zonelists()
                                        [MOVABLE1, NORMAL1, NULL]
                                        -> [NORMAL1, NULL]
    trace_reclaim_retry_zone(slot 1)
      zonelist_node_idx(slot 1)
        zone_to_nid(NULL)

  BUG: kernel NULL pointer dereference, address: 0000000000000060
  RIP: 0010:trace_event_raw_event_reclaim_retry_zone+0x57/0xd0
  Call Trace:
   __alloc_pages_slowpath.constprop.0+0xa80/0x16d0
   __alloc_frozen_pages_noprof+0x2d5/0x360
   alloc_pages_node_noprof+0x53/0xe0

The second read follows zone_reclaimable_pages() and a per-CPU vmstat
snapshot, so unlike the iterator's double read no compiler merges it.

Pass the zone the loop already loaded. The event's fields are unchanged.

With the tracepoint enabled and kprobes holding should_reclaim_retry()
across the offline, the base kernel oopsed in 3 of 3 runs and this
change in none.

Fixes: 11cd8638c37f ("mm, page_alloc: remove stop_machine from build_all_zonelists")
Cc: stable@vger.kernel.org
Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
---
 include/trace/events/oom.h | 8 ++++----
 mm/page_alloc.c            | 2 +-
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/include/trace/events/oom.h b/include/trace/events/oom.h
index 9f0a5d1482c44..cbcf6fe4cc615 100644
--- a/include/trace/events/oom.h
+++ b/include/trace/events/oom.h
@@ -33,7 +33,7 @@ TRACE_EVENT(oom_score_adj_update,
 
 TRACE_EVENT(reclaim_retry_zone,
 
-	TP_PROTO(struct zoneref *zoneref,
+	TP_PROTO(struct zone *zone,
 		int order,
 		unsigned long reclaimable,
 		unsigned long available,
@@ -41,7 +41,7 @@ TRACE_EVENT(reclaim_retry_zone,
 		int no_progress_loops,
 		bool wmark_check),
 
-	TP_ARGS(zoneref, order, reclaimable, available, min_wmark, no_progress_loops, wmark_check),
+	TP_ARGS(zone, order, reclaimable, available, min_wmark, no_progress_loops, wmark_check),
 
 	TP_STRUCT__entry(
 		__field(	int, node)
@@ -55,8 +55,8 @@ TRACE_EVENT(reclaim_retry_zone,
 	),
 
 	TP_fast_assign(
-		__entry->node = zonelist_node_idx(zoneref);
-		__entry->zone_idx = zonelist_zone_idx(zoneref);
+		__entry->node = zone_to_nid(zone);
+		__entry->zone_idx = zone_idx(zone);
 		__entry->order = order;
 		__entry->reclaimable = reclaimable;
 		__entry->available = available;
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 4cf2982c5b107..1bb308296fcdc 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -4679,7 +4679,7 @@ should_reclaim_retry(gfp_t gfp_mask, unsigned order,
 		 */
 		wmark = __zone_watermark_ok(zone, order, min_wmark,
 				ac->highest_zoneidx, alloc_flags, available);
-		trace_reclaim_retry_zone(z, order, reclaimable,
+		trace_reclaim_retry_zone(zone, order, reclaimable,
 				available, min_wmark, *no_progress_loops, wmark);
 		if (wmark) {
 			ret = true;
-- 
2.53.0-Meta


