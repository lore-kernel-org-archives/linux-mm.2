Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 18FC1C79F82
	for <linux-mm@archiver.kernel.org>; Sun,  6 Sep 2026 01:18:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 984AF6B00B5; Sat,  5 Sep 2026 21:18:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 935F36B00B6; Sat,  5 Sep 2026 21:18:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 824596B00B7; Sat,  5 Sep 2026 21:18:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4178C6B00B5
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 21:18:49 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id AB9B040439
	for <linux-mm@kvack.org>; Sun,  6 Sep 2026 01:18:48 +0000 (UTC)
X-FDA: 85181577936.23.093C2A5
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	by imf23.hostedemail.com (Postfix) with ESMTP id CEDEE14000A
	for <linux-mm@kvack.org>; Sun,  6 Sep 2026 01:18:46 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=k16lM3iF;
	spf=pass (imf23.hostedemail.com: domain of zhangbo0325@gmail.com designates 209.85.214.172 as permitted sender) smtp.mailfrom=zhangbo0325@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788657526;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ywe2sHtINpj8rB0jtyYuL7DLOlKzJ3vQHaEJq2LOGaw=;
	b=ckzUGOEtvsd5bX6Bk++BRkW3QTdREdVqPOEOmPmxDUFTsz1lxnCGwZ7raDfrgIPekvAhni
	kQKUtDG99zpOtklVwU8PvycDbbLJDJ0hf1QBt4TgvOhWsQ4OkyQnu2wEQyZ0+4+qXkrI1H
	UX5OTgkDejBP0up/e6XWUR/v8IZ2EVc=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=k16lM3iF;
	spf=pass (imf23.hostedemail.com: domain of zhangbo0325@gmail.com designates 209.85.214.172 as permitted sender) smtp.mailfrom=zhangbo0325@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788657526;
	b=mDxkcMDvgVyQ2llcE1NQJWY9ZrQ3PSH4VZiFO+D9vbgFsWZC4+mgIu43tZYt0GMCRwfQWO
	lWlFmAwAM9WH1+Uq2hV5JoDaMxNWIP0W4o+2P7LlO3b8qEzYdNvUOJR1lQNDbjS/FgsRcM
	7H+lM8gXlRZYJud8+1pP0hWdZ60+Lf4=
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-2d715f4a587so33406445ad.2
        for <linux-mm@kvack.org>; Sat, 05 Sep 2026 18:18:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788657525; x=1789262325; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Ywe2sHtINpj8rB0jtyYuL7DLOlKzJ3vQHaEJq2LOGaw=;
        b=k16lM3iFIXkJTwa1IMuldvIp8NCJjcUFOGYpU0MKtiJSfXGQI/uUqpgfHZFz1EQoIx
         CoPOB1qVL05RRZzngWWu8oP+60sGjoFCz3RnldkuB3aOGG8FG6c81Yz2gZEZV+G2rnCB
         z1pKcuxGtv5ibxTHczbF23t5ogTV2QKRZEWKoEHCdGjYp2FU789Mmz1dpU4XimRUVY7w
         5+2iYFqBJ5QMYazybgCjmr15KrcqhAXWTflU4ns5CRr8LGPEPbGnGBJxIRHAGmVsBKGk
         LaiUdxIVWcipobVWUxjKlmuxxG7h67WsUzvNYYJ+zHeK0r63NKOB4F/W/ZHDngq+FKbR
         bNKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788657525; x=1789262325;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Ywe2sHtINpj8rB0jtyYuL7DLOlKzJ3vQHaEJq2LOGaw=;
        b=n0F+mmuxtdadWxNRiYnV/j+AD/nytF/qpurCfBgQQa1J4VPbNaixlPoizOI4t75hcV
         FBx4PWFLxRwsIw5ieMCT3wDjn+okhKW2NJiN/BIhwSTzg2AAUD2oAuO6QWrTu4H2rdmn
         XDZ4sSY8KeFrVXaSctpppne+eGWyso/R5MD4x1REpWCaDhJYVrjnFyt9MHo9rQMv5Yy/
         aivH+2kvRNIzm/1VMDfpa6X2IhcBbjMAc3Z4eFJY3sypWVFO2s6ATqmpub7/1N31TdEj
         l6Ysd6dmBLICrbOEC89J1Tsz/lUGiJov1iA1WJ12Zygbo/wFKaTTOKZvOsk6Genvhe4Q
         cQ6g==
X-Forwarded-Encrypted: i=1; AKwUvBxgrB9MX1z5QudUZeWSJEy8x/GbXNqY53lSMdenKKx3L/kzt9G3po7dI6rmiHOdFAmh+jEbS4cu+A==@kvack.org
X-Gm-Message-State: AFuF++l6ncSjmjcWTyGyuX9NCNvWfp6yxlDhMNpfAJzX2G4ThLblnTp/
	lVdiH4zCMXkThHKh0UZf5TTsNLe5LKZCr1eiVbw+C3DUoBkzecgtgiyh
X-Gm-Gg: AYBFou0TMf9Res5mr8qU3Z3n7TfGSsr3xfc+6ynPzUIIdn7LWHUzRQERPsCRfwoMe1S
	9kIBp+1QZLBpgl4iHVXt5/Z9AIjWykhCXb3w+A9WrVUcWvRMfz7bRl+wRhztK4LoQ+bYho4tKe5
	TpxXLHDA5tMXGHWXBY0BRydGxcob5uAVscZMpj4vyeeTR2UfoEYRoKDfSK509nQ+IobkBt6U31j
	u94LetFUffxvzXxgTfn6Gu4yBcUYPfFWSVFk3xwyGdqnzIL7Imh03ZScBRMrkuqVKK2KeXIH1ug
	QCullhu5PxZeIOxTXIKY8T1K5YWobepBQ6nHC4pMBcghdogYiOIqY1cAkPieTyRjgU508MV2NpE
	44JWrYS8f9w/1UHRn5O/1XPqGObsJVcECU9pQ4PEP680NTEopoLUVlLI/fLCs0D50EWgKjF/bOp
	tLoh4r0rY5pN5mf+eKd7L7768laFxlIxBvPX+WZIeYgNAI7S2CIeioiZM55iWJvVrH3vv2BLb/V
	zOMtE9sRMs/R7dZ
X-Received: by 2002:a17:903:2b0d:b0:2d9:1dee:43db with SMTP id d9443c01a7336-2db1284b6dfmr222969445ad.15.1788657525544;
        Sat, 05 Sep 2026 18:18:45 -0700 (PDT)
Received: from zhangbo56-PC.mioffice.cn ([43.224.245.235])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2db149c3b80sm26905965ad.63.2026.09.05.18.18.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 05 Sep 2026 18:18:45 -0700 (PDT)
From: Bo Zhang <zhangbo0325@gmail.com>
X-Google-Original-From: Bo Zhang <zhangbo56@xiaomi.com>
To: akpm@linux-foundation.org,
	hannes@cmpxchg.org
Cc: baohua@kernel.org,
	kasong@tencent.com,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	david@kernel.org,
	mhocko@kernel.org,
	ljs@kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Bo Zhang <zhangbo56@xiaomi.com>
Subject: [PATCH v2] mm: vmscan: avoid anon scanning for GFP_NOIO with low swapcache
Date: Sun,  6 Sep 2026 09:18:20 +0800
Message-Id: <20260906011820.382381-1-zhangbo56@xiaomi.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260903040131.4016290-1-zhangbo56@xiaomi.com>
References: <20260903040131.4016290-1-zhangbo56@xiaomi.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 9wuadxjifdxgcrotr8mrgzxjfhb8ry9t
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: CEDEE14000A
X-Rspam-User: 
X-HE-Tag: 1788657526-151876
X-HE-Meta: U2FsdGVkX1+EiFlc4hOKAi2GuJMPfsJ1AoBX2TQ36aa5CEGGHGg9vr3uqC3gjx13dNokFwIwa/kfo11ApiIFLpsuMJFybSRTnMb3dalCQcoSZ+3o9q93o5GWvSVd4Ga8sSyTSbLK9g4m2hF5n0QUZkKNGbk0OD9HZFo4f/b+WJDv5zUUTuWdNdysiC10y8UI/8o8u4ZVnhcV8o3p4oYWqTuTuklq2xMPSJxxzgIrmGv/01gTKq7Vuv5W1B754tWV8PJeLy2sxtqIx4XiGDmA15L/ZtmrAt59H0Rm0AlhW/55oAJjg2+fkQj6e61UKHErI/7NiEjVLTZKW1CcO5L7PIwxFQtIH/2qhxcM/tCIVdZ+aZtv+A2w5EshN47hFHeARQgwztbkBtmtBxo8J/MCl7a7w+SuR81+OUWbPXQ850xl1zt9K9aIldw8BQibJcyEJ9vn1Rbn+jMo8p2QjzfLCI/jVjERs/9p56MRNinAtc3sMuPSu/pVbsmMURd4XBOTl4jtcRTQI/D5ljcZ4d3r1Nu5WHkbaFAOhnmFBhnZrb2LNGtvixZHO7oR9Si7nxoZSuZsPbmGHudL9rOooRBu8YhPJ+4PF50mJo9gPpvcc0/ZTz+htnGy3XS1EpjoLFzeoZVzPAlxr2IJ3w+YqeWvRnAC5HEwibsi3RjUfjOFFzJMWzX9ErxbeSfQl10S2SI+flmY0f6LoPF1nrT7ZO22ymYoCTiArcXQhGqZAjP0CvNyLg++E9pW4gZkLVyT+cYcjjj3jfMvs9jH+XeQz9gC4YOOKlvM1MHDB9Uo/Z7MpTxoIvnkbeonVMj+ZjKi4G1+ZxsxTWt7C+SCs150zM/qH6+qVMyGe2VY0xAHKK6D2AXGOemRCYo0Qrm3fU3JEo40xSL6ZIGAasauwvXcBmm2G8s59v0WLc1DCM5LwPqRKpr0WNKSXTHGQVev+wQA3ETHCJIWqqmH0GIBeHdoYvS
 livUZqff
 eYMz68+1gzysJ0VAZMwKpuPbe0kHy/owoW0BiLP/zrB7xENnKiMOmQBnH0R9SjrnkLud8AIT1/uZbT59rk1Dpxc3ue8ysOk0Om/TV2QlLfRFmdjzAVIyztt3Eh6s42XJOkxUoBQ4EPI6vIpg7bugg3fygWLuuqx/pS9LETHitlPFPawA4Ps5OVkwaVxNHq/KIy0FwGkqilYQ7ib1iOuql2r1Lzw4rejoXioeOvt1RFiGtr35uXP1yc/cKWCim+xKJ+x8eQvP8ySokkhkgo64+Tz2ihbcXYDsmiTsC2W4Fr4tJUoNnpibSuj3Kq/lFvfvOrsarqFGgXC+uXUAgdC+fuWaehpk5I6ygVQVSruMXLaMDUkk00PG6SGGK/tKwA+TzUdX7WFfdndWnBubpp3251Dz7HMTA40hLwWuS
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

We have observed some cases where memory is allocated with GFP_NOIO, so
we cannot reclaim any anon folios unless they are in swapcache. We can
end up spending more than 150 ms looping in `shrink_folio_list()` scanning
non-swapcache folios without reclaiming a single folio. This is pure
overhead.

This is particularly true on systems using zRAM, where swapcache is
relatively rare. So let's check whether anon reclaim is allowed by
GFP_IO and whether there is enough swapcache to make it worthwhile. If
the swapcache is extremely low, we're essentially searching for a
needle in a haystack, so let's avoid scanning anon in the first place.

On Android this is triggered by dm-verity hash-block reads through
dm-bufio, which use GFP_NOIO:

  verity_verify_io -> verity_hash_for_block -> verity_verify_level
    -> dm_bufio_read_with_ioprio -> new_read -> __bufio_new
      -> alloc_buffer
         gfp: GFP_NOIO | __GFP_NORETRY | __GFP_NOMEMALLOC | __GFP_NOWARN

Such a reclaimer can land on a memcg with a large, unswapped anon LRU and
a tiny file LRU (e.g. inactive_anon ~335 MB vs inactive_file ~4 MB, with
negligible swapcache). shrink_lruvec() then keeps feeding that huge anon
list into shrink_folio_list() - ~2400 shrink_folio_list() calls, ~93,000
anon folios scanned - where every folio is kept because it needs IO. The
150+ ms above is one such single shrink_lruvec() pass (not accumulated
across a reclaim cycle), and it reclaims nothing; the actual progress
comes entirely from the file side.

Aging anon alongside file does have some value for a later __GFP_IO
reclaimer, so it is not strictly pure overhead. But that aging is only
deferred, not lost: kswapd and other __GFP_IO reclaimers still walk and
age anon. Spending ~168 ms aging memory that this context cannot reclaim
is not a worthwhile trade-off in a latency-sensitive path.

To stay conservative, this only skips anon when the swapcache is really
tiny - below 1/64 of the anon LRU - i.e. when essentially no anon on the
list can be reclaimed without IO. Whenever there is a meaningful amount of
swapcached anon, the normal path is used and anon is scanned and aged as
before.

Signed-off-by: Bo Zhang <zhangbo56@xiaomi.com>
---
v1 -> v2:
 - Use mem_cgroup_lruvec() instead of get_lruvec(), which returns the raw
   node lruvec for a NULL memcg and would be misinterpreted by
   lruvec_page_state()'s container_of() during global reclaim. This also
   drops the get_lruvec() move. (reported by the sashiko bot, suggested
   by Barry Song)
 - Drop the SWAP_CLUSTER_MAX cap on the threshold; the check is purely
   proportional now (swapcache below 1/64 of the anon LRU).
 - Expand the changelog with the workload, the dm-verity/dm-bufio NOIO
   stack, the ~168 ms single shrink_lruvec() breakdown, and the aging
   trade-off discussed with Johannes Weiner.

 mm/vmscan.c | 23 +++++++++++++++++++++--
 1 file changed, 21 insertions(+), 2 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 245f68c75b28..e20ac2cb4dd5 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -362,6 +362,23 @@ static bool can_demote(int nid, struct scan_control *sc,
 	return !nodes_empty(allowed_mask);
 }
 
+static inline bool reclaimable_anon_is_low(struct mem_cgroup *memcg,
+		int nid, struct scan_control *sc)
+{
+	struct lruvec *lruvec;
+	unsigned long anon_pages, swapcache;
+
+	if (!sc || (sc->gfp_mask & __GFP_IO))
+		return false;
+
+	lruvec = mem_cgroup_lruvec(memcg, NODE_DATA(nid));
+	anon_pages = lruvec_page_state(lruvec, NR_INACTIVE_ANON) +
+		     lruvec_page_state(lruvec, NR_ACTIVE_ANON);
+	swapcache = lruvec_page_state(lruvec, NR_SWAPCACHE);
+
+	return swapcache < (anon_pages >> 6);
+}
+
 static inline bool can_reclaim_anon_pages(struct mem_cgroup *memcg,
 					  int nid,
 					  struct scan_control *sc)
@@ -371,11 +388,13 @@ static inline bool can_reclaim_anon_pages(struct mem_cgroup *memcg,
 		 * For non-memcg reclaim, is there
 		 * space in any swap device?
 		 */
-		if (get_nr_swap_pages() > 0)
+		if (get_nr_swap_pages() > 0 &&
+		    !reclaimable_anon_is_low(memcg, nid, sc))
 			return true;
 	} else {
 		/* Is the memcg below its swap limit? */
-		if (mem_cgroup_get_nr_swap_pages(memcg) > 0)
+		if (mem_cgroup_get_nr_swap_pages(memcg) > 0 &&
+		    !reclaimable_anon_is_low(memcg, nid, sc))
 			return true;
 	}
 
-- 
2.34.1


