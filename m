Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5B569606A327
	for <linux-mm@archiver.kernel.org>; Sat, 14 Nov 2026 00:30:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=z+4P+Xcv
Received: by kanga.kvack.org (Postfix)
	id 453416B05B2; Fri, 13 Nov 2026 19:29:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3E2F56B05B3; Fri, 13 Nov 2026 19:29:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2CB226B05B4; Fri, 13 Nov 2026 19:29:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id DF0E66B05B2
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 19:29:58 -0500 (EST)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 43067C0253
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 00:29:58 +0000 (UTC)
X-FDA: 85431842076.05.B4C908D
Received: from mail-yw1-f174.google.com (mail-yw1-f174.google.com [209.85.128.174])
	by imf12.hostedemail.com (Postfix) with ESMTP id 7631840006
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 00:29:56 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=z+4P+Xcv;
	spf=pass (imf12.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.128.174 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794616196;
	b=7FDA5LJ7cHwqkPGr4yN22+ExSap5H16osllkPeW0PeF1ERZ/E9Dr88jdOJoW7W+U1phywC
	ODMRT9PLkcgruqoYqvbRabJ6JH9vBL+ebc0yH+Xqf8m6V5NAb7jMU88vEVM/GBmWY+n3Tu
	MtKz8EZYHbBdARMx5JIo5LwGZMpXxC0=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=z+4P+Xcv;
	spf=pass (imf12.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.128.174 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794616196;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5FJmlfLnnVicFf7gaLIa4+dhDlQzv/f7mdEhi2RvUz0=;
	b=FKFSNLsLtwuDZ0wV5yagXyw7Y/PXRgSLnoL8qPuW52ehGUpXWWzDyFxIX2d0plIK6GrN95
	t5rw4fKf7pREmB4QJkZF1zjk+AgmhgiV7327Zo02ZxT2qDAxD4oxXFmJGh5SkEWIKQH3vR
	t0MjeZcK9phXQEfE3Ryp3pf1b5OCUwI=
Received: by mail-yw1-f174.google.com with SMTP id 00721157ae682-8b0dba37a7fso17369337b3.0
        for <linux-mm@kvack.org>; Fri, 13 Nov 2026 16:29:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794616195; x=1795220995; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=5FJmlfLnnVicFf7gaLIa4+dhDlQzv/f7mdEhi2RvUz0=;
        b=z+4P+XcvAaELdJ/uW+m8li2C7p2GBYXGIVkRvjbjhIYdSNyMlGDL9mPWr9UEtjamSF
         E4hSDFCp9AR0mgvmbYzyCeH3DHdv/PUytznsAhz8Byq2OGBPI/4PL2i/KpM8fYQZ0e4v
         L55pOSKJbdzXrgu3S6eJ8E4xWZ/oZLgtCuYomjlslqY2MX5HKi7vbwfVU1J09jkwyQTk
         h8INdnU7DNE3gSVkZ6BN2YznBMcetayO3ZacfeoOXoxxbtFU0w3GmcBxe/dUM27ojsW+
         EL3HlSNFDOqUq8T3twYYFo/2nRHLpqfw4j7j/LzuY0J0IBpik25FYa0SrE2EminU3UDn
         EaYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794616195; x=1795220995;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=5FJmlfLnnVicFf7gaLIa4+dhDlQzv/f7mdEhi2RvUz0=;
        b=roi8G+8sXNm3x1TBw/4nK+1YWu4KxjyAEqonL/0wKc9/0j7P4yHlemSUqeZWa09xFQ
         rpZLHl4wT9qTuibFP/lO7b2G9wApOmLj0Lw7GvPB+YM0klfluK+FxTG/YzM6yIOTCe5b
         BUNE/ZmFxlutJpWBtJu/BXO3D9By0w0D64qCoeiBdtbIz+wGduRj0ky9fQcPSa4uii84
         7/l0SAooIz3LrCEN73DgolzT8/2MMK7qHy1nrGJPGDHaxJIqPPi9mQmAO+nJWksYG4sd
         Mi8DeuuYc5PBqwDZXhYm/z5F249EhaLzrDOo+mzNCQR88oaAyBB4dNHrsCQiSDu1ax5v
         sLEQ==
X-Forwarded-Encrypted: i=1; AL+hErEeE3l0bglRJLCFgDciYGPUxswXXevvmahqkShVL8qnrlj5DSTS2F4zDmmdm1V6JOb3LFfjUdKswA==@kvack.org
X-Gm-Message-State: APuU4Z/6hobw1VhzgZ3U3sqIXz2kBJ8M+4/xsfVkeWwBxUA3RNFJ75YP
	otOA223pxDXvN7HZBXM2b1J7SaSuY7ty5cfOaHRbO4/ruA01zhydOwCO
X-Gm-Gg: AYBFou0iiE+idRWH1mInau4raFxl/Ye5xYFj/Zt2YLhYRA7xY/MDVCUQsoKIHogVvRC
	e7+oTE5fZzUSu0/o9t+6ARKwKgln6jOMJ2WqlllLGL2HWTpjqo/AigPqxFnCRwQVaPw7RQ724d8
	b4IrWih2KMSxlPCpd5H7Z4GMCnHZ7I7/2P0kJWqGKlspMZKC44Pm3tqOqyj2AEeRDcjeH9MHPr8
	YrMKwbuU5dq93lQWEAe7VV/IwTzzAHxAdTBh/QwDEil1dL7uFVB0OBgejUqJdMO9otGhzaitrEJ
	YjFjmFcwPhfndJi31IWiSP93t5yala/9k9N72+E7DOl56QXJJEUoHys6Zq8UnvcpJcDcaMqx0LP
	tDVUJuQyRE7bYbZvvx+0rj7IOFtb4wgh4IlIp3Yi6Cm2oXpk0x1N7Vnlj3QZoRpjEjZZZMxF38D
	S/FpgSBnDwGS2uILK9lBxhTAM0frDjZXBnP59aeevLBIlxLF1bG6RsA/Lpa+Gn8pB+E4+5zwXq7
	gqT1IzIJgJI0Ktxwsw1vH4XgZvfpDtvRtxTLcfQ4EHSJ1ptAjrd6ZuYcEyXCyob+xT9poACGchD
	VdzGpVvtdfnf3TK3+X7vvUoJxHes1eFHphC7aVAlj28gglIhlHIrYqJ/hsremTCuCeeQXASz82c
	p8HvVsw==
X-Received: by 2002:a05:690c:3181:b0:8ae:1acc:ad33 with SMTP id 00721157ae682-8b4aa305fd1mr20901977b3.58.1794616195554;
        Fri, 13 Nov 2026 16:29:55 -0800 (PST)
Received: from localhost ([2a03:2880:ff:73::])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-8b4aa958d0asm33763867b3.22.2026.11.13.16.29.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 16:29:54 -0800 (PST)
From: Joanne Koong <joannelkoong@gmail.com>
To: akpm@linux-foundation.org,
	david@kernel.org
Cc: yosry@kernel.org,
	mkoutny@suse.com,
	shakeel.butt@linux.dev,
	hannes@cmpxchg.org,
	mhocko@kernel.org,
	roman.gushchin@linux.dev,
	muchun.song@linux.dev,
	nphamcs@gmail.com,
	chengming.zhou@linux.dev,
	sj@kernel.org,
	ljs@kernel.org,
	linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	damon@lists.linux.dev
Subject: [PATCH v3 1/4] mm: zswap: fix shrinker count for the root memcg
Date: Fri, 13 Nov 2026 16:28:19 -0800
Message-ID: <20261114002822.1043378-2-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.52.1
In-Reply-To: <20261114002822.1043378-1-joannelkoong@gmail.com>
References: <20261114002822.1043378-1-joannelkoong@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 1px91b5ud8rshkbe4a66bbwi4ph36gbs
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 7631840006
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794616196-454627
X-HE-Meta: U2FsdGVkX19ETizOAnoYhnBYTBLiShcPB0g1b2n7inzbOieuKMP6qYp81ZuEBZ5WVi5Rz98v+AG6TR8QEK6RG5PZFj2TPUt0KVME/Ta/d+esVJqhmG/d5bbfWJMf/aOKdnPeG69U6hBpiEpO3Jyy2ax6Xu6xrjXdS98m5OowzVJ9ZUGJPYp51Tcn/WG9lPdZFww54rWoXopqVy75DUsNyY1qGexinUP9Xpoi+Ce8gxoT3cXQpBemTveGFFWwdIr2LFmnkSBwsP0EQKU68D4T4+BsArAkvV2kFJrxOLRQ4x6vJRVpf6VF2uIXLs16jsorxAQUGwI/nr2xJLrrD+0dCCp5mAz9DUox11MRCm99th+mcOs4pGNNi4PinaG1SXsUM/nrBGjDscgD6RatX6phG8TS0nIUps3ou82x17hIH8RhQKx4ycmHP+k+dIXXRuxgJmgXj42tO9BxoG1XLmn0ErTQkjlESQWmJmTkAP4jDE2zRFK6FZqNjlibG7hWJD+hFs601Xlp2anqxdiLQnM6WN6CxJ5G9OGLX4E+iy2AvtkeXAITeucXHb+c61cDen+kds4vN2Xj2yosmEZ7faIUg+fZKgmuJPr8iisMDju1Sj3BMLhx1xoFLLvrXOcuxlJx2X7tQGErLX1E+0PBmje4V4x0otaUtuZIT1W9gwgy/8No6M9Ma7tOSlSHZf/gYD54UzUdqd5KGfPoI43J1qz3NefkP2rroh26Q5udIC/9Xza3CsAFsfZ8TrmO9E7xfPnoUcMLtQxl1tJBnqp5aVKu+aeNb36ZbHD6wZK82nzVm5IHCjIb8feUATX62MMa6rUptIqdpe3piD67044he0OJdO1aU/paXAuiFWmHNEpHa6qkt9ZVeaMi4hYps7gxmqux7d52RQxFa6T/qb18isKr9sYRaDd5K7Ae6yA5lvgXErBnrYsbemWWdgc8CTH8wiFoAPmHCKf5PJhKP1JYdhs
 Wg9x7rmW
 crxD3Jmk4gqTAAby3lXQx0fOGEYE20IB7s0QlyLMaZBmVbZ5MCw2q5k3N7mC5+r0+qmG6ulOkc/wW2e3hwC27IrTLjx6MNiju636FKhqsa7OMW227hg5VwQotNK/GtWZ22oPsZM1QXdtwwVdQ3LK6RjBITv7AvoRU+fb0heYOrKGAa2e2a1QW8aRD0tmwJGNN2B7dVBZT6rvD+85dT50ewPFjhWjjB3YUZFS60OgcDeN0Dz+v6LF/XKltVxCaegcZc1TXQKpU2vsEiiQUIpntIKpmht6eziyiwalWVUlYUSNOB0jHf3hor0M4DyxDy4dbOAJ9a3Xc1Ae9JUAyb3Y5mBBoUOCmewox3BJeIFkRcelxLlCpRVNG2++FdhSpM5gMr1tKQhrac3BilJA1F2LHBgxV3ahIvCsu/u0OGukJzEkMmIp6jStHWqzxGWCYZssl8qN7yISXii8JKDYDKntAjjEepNgiDMQOUzi4r1mNnlza6BKfNiXqKZgq9/OrAUCF3gmhHyLF359gOgglPnEm/jqSuVIYBrnXgbId9zwwenCfDtU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

zswap_shrinker_count() scales the number of freeable entries on a
memcg's zswap LRU by the memcg's compression ratio. That compression
ratio is computed from the memcg's MEMCG_ZSWAP_B and MEMCG_ZSWAPPED
stats.

However, for the root memcg, the zswap entries owned by the root memcg
itself are never accounted for in the stats (obj_cgroup_charge_zswap()
skips the root objcg, and before the root memcg had an objcg, its
entries weren't charged at all). The stats only reflect the entries
owned by the root memcg's descendants. When the root memcg's descendants
have no zswap entries (eg when the whole workload runs in the root
cgroup), the shrinker reports nothing to reclaim for the root memcg, and
its zswap entries are never written back by the shrinker. When its
descendants do have entries, the root memcg's entries are scaled by the
descendants' compression ratio instead of a ratio that includes them.

Fix this by using the zswap pool-wide counters for the root memcg
instead. The zswap pool-wide counters cover every zswap entry, including
those owned by the root memcg.

This also gets rid of having to flush the root memcg's stats, which
flushes every cgroup in the system.

In a VM running a reclaim-heavy workload in the root cgroup with the
zswap shrinker enabled, the shrinker wrote back no pages before this
change (zswpwb stayed at 0) and 1016 pages with it.

Fixes: b5ba474f3f51 ("zswap: shrink zswap pool based on memory pressure")
Acked-by: Yosry Ahmed <yosry@kernel.org>
Reviewed-by: SJ Park <sj@kernel.org>
Acked-by: Nhat Pham <nphamcs@gmail.com>
Reviewed-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
---
 mm/zswap.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/mm/zswap.c b/mm/zswap.c
index a2e0314db1cf..6e1cd3e482f7 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -1330,9 +1330,12 @@ static unsigned long zswap_shrinker_count(struct shrinker *shrinker,
 	 * runtime-disabled: we can get sc->memcg == NULL, which is ok
 	 * for the lruvec, but not for memcg_page_state().
 	 *
-	 * Without memcg, use the zswap pool-wide metrics.
+	 * Without memcg, or for the root memcg, use the zswap pool-wide
+	 * metrics. The root memcg's stats don't count the entries it owns
+	 * itself (obj_cgroup_charge_zswap() skips the root objcg), whereas the
+	 * pool-wide metrics cover every entry and don't need a flush.
 	 */
-	if (!mem_cgroup_disabled()) {
+	if (!mem_cgroup_disabled() && !mem_cgroup_is_root(memcg)) {
 		mem_cgroup_flush_stats_ratelimited(memcg);
 		nr_backing = memcg_page_state(memcg, MEMCG_ZSWAP_B) >> PAGE_SHIFT;
 		nr_stored = memcg_page_state(memcg, MEMCG_ZSWAPPED);
-- 
2.52.1


