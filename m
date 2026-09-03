Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F1AF2C61DD3
	for <linux-mm@archiver.kernel.org>; Thu,  3 Sep 2026 04:10:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C68BE6B0088; Thu,  3 Sep 2026 00:10:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C41066B008A; Thu,  3 Sep 2026 00:10:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B56BD6B008C; Thu,  3 Sep 2026 00:10:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 8A65A6B0088
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 00:10:24 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 2841EA043C
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 04:10:24 +0000 (UTC)
X-FDA: 85171123968.04.A5D4187
Received: from mail-oi1-f176.google.com (mail-oi1-f176.google.com [209.85.167.176])
	by imf17.hostedemail.com (Postfix) with ESMTP id 6130C40002
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 04:10:22 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="oZmxMI/G";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf17.hostedemail.com: domain of zhangbo0325@gmail.com designates 209.85.167.176 as permitted sender) smtp.mailfrom=zhangbo0325@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788408622;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=c2j9BPK7EzJ6AgBVF36vfvt7WxuniwU8KIatWFyFN8M=;
	b=TMeTujZa/YsWENwfQgg8Vy0GTuriOxHdJOnRxuNj1L63hN2JkOAXEf8DM+khF9GW11NbSO
	/Q4LrWVBm3XklX1YjMErjuV5cu/YnOKPXZMrLR6Y8GOqtE+vFKpZ1dKhDwBlwsOJYFUXQH
	CqYXaV8Xds7SYP4KjlUQ4PgC99oV1LA=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="oZmxMI/G";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf17.hostedemail.com: domain of zhangbo0325@gmail.com designates 209.85.167.176 as permitted sender) smtp.mailfrom=zhangbo0325@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788408622;
	b=hAX75AKS3/PWJwzlLGgoC6jswvjk/8Hq1omJAgSScgdz8MIyD1a/vrvtsEmTX9NIOr7mvr
	f279qLPfcHIwR9NkysAJz4/vJA/lRurhEf6StPTVw7SGr/1Wzu3SCQoNWvX5rTNx2q1e7g
	RmFQnbhVHsMJjOvrkXoOsHrWFWaXaGc=
Received: by mail-oi1-f176.google.com with SMTP id 5614622812f47-4b381337e1fso1330266b6e.1
        for <linux-mm@kvack.org>; Wed, 02 Sep 2026 21:10:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788408621; x=1789013421; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=c2j9BPK7EzJ6AgBVF36vfvt7WxuniwU8KIatWFyFN8M=;
        b=oZmxMI/GyQu012gdGgyfDcFFbeAFQit1hCH0OSzGjgSl48plywi5aur5uNInAzONj3
         yjsF1ne3Rr/f+RyVyIG8jqn0fXVCK3QfFQLetVKN1iP6r9yFAbolwnVmpnzLuaSVTsk+
         qdZJ0XH2nCnJHfN1EQxzuGg60UtDEBAIZXfyLaxVIkcb1no/ATew88YoIqhBDF8uYfsh
         MxB2eZQkElftDE5XTZQqoU0xwKA+QOw5SmEfq43vko3UTLJS2qWCzVNyiBKPC7YZPV3n
         eLQZq/IjjjRYo+/7/8V2AUvuHynpuj1g1HZj/iS4DaKrCpMWx39SBYC2oA87vqIifll7
         YFbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788408621; x=1789013421;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=c2j9BPK7EzJ6AgBVF36vfvt7WxuniwU8KIatWFyFN8M=;
        b=KY1PqHYIsG5EFFYrd8lmy2cqL2MEK3255CkNO3T2VlWR9D/+rmw4w5pwCuICexID5s
         piQg/4RvS2yCOIzEh5ZO9oWbdm0mtE8DBd1NsRQNJWbr26LAe5ZgwH0NmzQcd+olhtlw
         b9Yi2vdGp4HzrZEkcDuNvTPUwu3wcaIJ8QI2pFrrH0XN3JEbudoe8sWaEway+4X0HD/+
         hhMNQ9yK0/RJzF+IiN5eaaVBTCm5BUWoeFmtvtXM1D+dDZwHWsRZ4e+Ko78siGwRHuDH
         xaVojzQS39SZkXSP7L0HRqhhO7RFcDBL3NYnPrRnN7P3bCDM5DhLdw9zV4s0ZBrINTvw
         5R5g==
X-Forwarded-Encrypted: i=1; AKwUvBwSrVHWe1X1KMt6971LjyTBafZOonAop5+wdz7ckBhXS+/GKR1hTul310JiO9h9W1rp/vpeeix+2g==@kvack.org
X-Gm-Message-State: AFuF++kMeU2BzVW8x2GYqq2SvcJLZcSr4RQ/MUW/h1oHb40sECGJhkQC
	8djL8YrOmxfrB8Imv+WLriAz6dLkIh3x0pzIRB3wxkrNnN72xDKVw+B4ZfZbpFHR
X-Gm-Gg: AYBFou2ONBZSHpOBFNB9hJ9KQwAEsu7QwS0vLWvdCQuAGJCpeaJg8aygSGJ/K68HrC6
	JBO/tiLlwk44otTXre3c/E+bstkR+VlGYP/81KnRGn8Pw7O6cQ7QqphU2Weu3vnCM/OkJ1KQCdU
	yLAL5WA2kpBQXFEYnNnpbUGdCkOfW9e867XKifobFD3phODRK8B+n3JTxfzLBBw0PtQqIc2otn7
	RQcO6NSZypK4J9bG5WbvUqDyiGQa3F0ikoBCiqg9pnN3C9dwepWOmMdLfnk1+pVA34gldWMUPBP
	ygR9wKIi+TXTLqBMnaqIISjbFi2zEBZRnq8Abv4oqShgodehPLmW3gGQCAcOFcrM/ZTp91hlSBz
	+MJWU4JIHCtOr5VuUpKTbdeuk6svqgU4d8WgTU+Vpc9UHwNDQ0igOuqVx7syJIM+C2MytqK+K9f
	bS0vXmKVZ78VNplu4beH5ZOxD0NUW+BvJqxbQ15HqnK8uonUJD7ik6P2GkpnQnEwXuG15QJJAnN
	KJKdQ==
X-Received: by 2002:a17:903:37c6:b0:2da:f7ad:cfea with SMTP id d9443c01a7336-2daf7add0a9mr82421215ad.8.1788408122363;
        Wed, 02 Sep 2026 21:02:02 -0700 (PDT)
Received: from zhangbo56-PC.mioffice.cn ([43.224.245.235])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2dafe62d1d1sm3185025ad.24.2026.09.02.21.01.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Sep 2026 21:02:01 -0700 (PDT)
From: Bo Zhang <zhangbo0325@gmail.com>
X-Google-Original-From: Bo Zhang <zhangbo56@xiaomi.com>
To: akpm@linux-foundation.org,
	hannes@cmpxchg.org
Cc: kasong@tencent.com,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	baohua@kernel.org,
	david@kernel.org,
	mhocko@kernel.org,
	ljs@kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Bo Zhang <zhangbo56@xiaomi.com>
Subject: [RFC PATCH] mm: vmscan: avoid anon scanning for GFP_NOIO with low swapcache
Date: Thu,  3 Sep 2026 12:01:31 +0800
Message-Id: <20260903040131.4016290-1-zhangbo56@xiaomi.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: qhm4ffg9csp98n1zfqe837ng5zfzeeb1
X-Rspamd-Queue-Id: 6130C40002
X-HE-Tag: 1788408622-54742
X-HE-Meta: U2FsdGVkX18eAxKnzmrnvRWGgwEZNpCdCZTLiJ8aBbmH+M+WEVrcx1uP0Q+4gTgksGJ6YjBPFQ5wjNQi1Oja5k+6Sfgw5JHcCBxpTmK2L2lTRqWMAF4SiWopNiL1aKvcumD8ND7v19vE9KD/SXfFgdPJhBfMFEnAhl57AUR4G9HDdHvL7DHhAnMbNB7v/0dyyAxKohWsYYF5jt0hsrGXm6zi6tzboNf9VgePo79KzNkXcK2j5oKNS2w/d/ffs+miFNpUe9/5EhjCpgzILkBeWvlVwZOxSkmAmYi0BVxS/TuJFFO6toOMk6FOYCRC1XLMoW/7NlIMe1hZ/6kIVdSZ6ZQH/ECfErjEDc7ZiU3Qt63+4xcFNA+BCvYT4xkwFH0M5LQrIwPhwXRyHUdslG2n4yEhR2fFP1ZlVRpIR/G8k9hyI5I7WVDEOYzWLHlxTuUaxusJ1tG2GevstSmds22E5gC/Qax+k2galbdeCqsI2ckHzH8zkR9cePLfFHS0Fn2vEIYdWHjo8mFqQflWx+YtdqOCGVY6LbgjOkjSuDXsV4/CYGHcAFKNeLiZ3DDc07f+8ozp1rA4ejC9ZElMUwy3+r81bn1xUCnQdVDzSqzAaXQJCnYxTU7FBb8aZz/rm6sVsYVD0O4LZvRLx55GkvPuSxH25DfBhnDcQUOWAs2r6LEgWMAHWxUsj/fOFJ5ERPjV1eYlENUx6B37YA75h8CSYNEeWZupdVl+XdROIhBQQyyb7mS+wKtBJL65DsQvrijZKvLebE8K9XJqef3fTaFNFjtvmePKeQ84K6feoo+poh31AhK4QD1Z6VlU/V2duUj9m29zHKxDn7rm1OtjwuJ5LptBneY8xow821BIXlWoOpaaaYbrxPVv1DBOw5sdLS/WHdKt5BRusqMgBQZ8FlyO8S0ROsxwamBNldPNnFHEo1MYrGz/U4o/m8LOD4CIIuWsnKc3n6IN9byYJv+qkZX
 kIaft0Me
 qeN2C/qFIqtUmlbo5B96AxKSMWdMUhvgslTAjPHbVaWZMsGZUszP5aLoQkfmyvO5mCbp9/yid0pUHr19STmdzOp50p0jbmVE46U/nQToqkKp/4VvBGaCvLD+lHS0p2TZdUbSzfLbymNsZuUpdeEeFWPH+9PF2fozbhBZAe+uCoJp9DegWvXmj1JQi5+0MDTKBmGKbRX9dyXpsxepKSOcW08RW1iVMsYARqzduv7VDgr98ZUt3qGkae2BWR0bYQDngBmB6RltfLwQYUKMJl9CC+UW8UgErnUw+m+iJQXbrLHkjWKzSTG7SDHgZUVNm2ZllYe7LE+yANkiMGb1YIOQXLGD9sbmpjUXoWgL7Z7BrsXVRLxhxrCwT68BG+EmqOeCE3km1M4fPDBhOpbxq+4ENebBfN242cRozEgKvKznBN6xFoj4=
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

Signed-off-by: Bo Zhang <zhangbo56@xiaomi.com>
---
 mm/vmscan.c | 62 ++++++++++++++++++++++++++++++++++-------------------
 1 file changed, 40 insertions(+), 22 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 56708d1d2dfd..192bd0980121 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -339,6 +339,42 @@ static bool can_demote(int nid, struct scan_control *sc,
 	return !nodes_empty(allowed_mask);
 }
 
+static struct lruvec *get_lruvec(struct mem_cgroup *memcg, int nid)
+{
+	struct pglist_data *pgdat = NODE_DATA(nid);
+
+#ifdef CONFIG_MEMCG
+	if (memcg) {
+		struct lruvec *lruvec = &memcg->nodeinfo[nid]->lruvec;
+
+		/* see the comment in mem_cgroup_lruvec() */
+		if (!lruvec->pgdat)
+			lruvec->pgdat = pgdat;
+
+		return lruvec;
+	}
+#endif
+	VM_WARN_ON_ONCE(!mem_cgroup_disabled());
+
+	return &pgdat->__lruvec;
+}
+
+static inline bool reclaimable_anon_is_low(struct mem_cgroup *memcg,
+		int nid, struct scan_control *sc)
+{
+	struct lruvec *lruvec = get_lruvec(memcg, nid);
+	unsigned long anon_pages, swapcache;
+
+	if (!sc || (sc->gfp_mask & __GFP_IO))
+		return false;
+
+	anon_pages = lruvec_page_state(lruvec, NR_INACTIVE_ANON) +
+		     lruvec_page_state(lruvec, NR_ACTIVE_ANON);
+	swapcache = lruvec_page_state(lruvec, NR_SWAPCACHE);
+
+	return swapcache < min(anon_pages >> 6, SWAP_CLUSTER_MAX);
+}
+
 static inline bool can_reclaim_anon_pages(struct mem_cgroup *memcg,
 					  int nid,
 					  struct scan_control *sc)
@@ -348,11 +384,13 @@ static inline bool can_reclaim_anon_pages(struct mem_cgroup *memcg,
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
 
@@ -2674,26 +2712,6 @@ static bool should_clear_pmd_young(void)
 #define get_memcg_gen(seq)	((seq) % MEMCG_NR_GENS)
 #define get_memcg_bin(bin)	((bin) % MEMCG_NR_BINS)
 
-static struct lruvec *get_lruvec(struct mem_cgroup *memcg, int nid)
-{
-	struct pglist_data *pgdat = NODE_DATA(nid);
-
-#ifdef CONFIG_MEMCG
-	if (memcg) {
-		struct lruvec *lruvec = &memcg->nodeinfo[nid]->lruvec;
-
-		/* see the comment in mem_cgroup_lruvec() */
-		if (!lruvec->pgdat)
-			lruvec->pgdat = pgdat;
-
-		return lruvec;
-	}
-#endif
-	VM_WARN_ON_ONCE(!mem_cgroup_disabled());
-
-	return &pgdat->__lruvec;
-}
-
 static int get_swappiness(struct lruvec *lruvec, struct scan_control *sc)
 {
 	struct mem_cgroup *memcg = lruvec_memcg(lruvec);
-- 
2.34.1


