Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7622EC982CD
	for <linux-mm@archiver.kernel.org>; Thu, 17 Sep 2026 07:01:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 76C2F6B009D; Thu, 17 Sep 2026 03:01:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6F6036B009E; Thu, 17 Sep 2026 03:01:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5BE8F6B009F; Thu, 17 Sep 2026 03:01:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 35E856B009D
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 03:01:32 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id BF72C1A0264
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 07:01:31 +0000 (UTC)
X-FDA: 85222358382.28.B95DF81
Received: from mail-pj2-f12.google.com (mail-pj2-f12.google.com [74.125.227.140])
	by imf27.hostedemail.com (Postfix) with ESMTP id 6D0B140007
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 07:01:28 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b="FAx7/NTE";
	spf=pass (imf27.hostedemail.com: domain of sunjunchao@bytedance.com designates 74.125.227.140 as permitted sender) smtp.mailfrom=sunjunchao@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789628488;
	b=uxQJ3iW9mLXRhabt0rDXSFopuRYiWVBm9BiqM2IMR48rlZhyxLgLym2HIUUoMCnDbrsWSP
	c4biQBzqxxf/me1SDZUadXb5pLyzIWgI9NCVR+dXkKlCX4IwK7noJE2ESqyufxS5n4JYsU
	gO4hm7NQgzSuzarotpWczqI6+MksXu4=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b="FAx7/NTE";
	spf=pass (imf27.hostedemail.com: domain of sunjunchao@bytedance.com designates 74.125.227.140 as permitted sender) smtp.mailfrom=sunjunchao@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789628488;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CWcZ32DEcvckTxaHfwF/iY9dOheOeLm1G2879tq/8J0=;
	b=jkcIu4bhEyFYs3cfddLydWCAmLv9z7Dzym02gsnWGlifNArbtb1uB6HA/eDfBqn1LIMGas
	7qeVbIWqAbwDNBLcV2CQIc5JIdMv4YcGaJ3xmIkM8QRvGguH4NqWUFiIUUPpuN2NeJseKF
	kIwKj7BLeQg9zzkHsxHU5wuu9HOYNsI=
Received: by mail-pj2-f12.google.com with SMTP id 98e67ed59e1d1-396ccafb74fso488029a91.3
        for <linux-mm@kvack.org>; Thu, 17 Sep 2026 00:01:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1789628487; x=1790233287; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=CWcZ32DEcvckTxaHfwF/iY9dOheOeLm1G2879tq/8J0=;
        b=FAx7/NTEHQEtxNRrl9b8ngncrnC5RJbNIFki58u3PIBInuWT8iK80HiVD6h9LwXku7
         qDUbwNDgI/k266DtZpSc4PY0dhFAvfAErkzEcbs9W61HQ9GJu/rcoEbDXY4xguNX8ROZ
         XpMMps6ZsxCGbYMQAG2VgI377+JdvOjvCbgyebcPTSWNdkeDgKOdJeT6DLu2cezICTBP
         v144IPZ6QKFxqX7H4JBpwBRkKwpqWoxSXcFr2sP8dShYgr4ehYGUp/WQlAbsial5ZYHQ
         0v/StyRLlBeyI2q/Xchct787h5rskXxJojxEIARd4rIZyuhsBqkHT3uiq5logN58u1H8
         dkxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789628487; x=1790233287;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=CWcZ32DEcvckTxaHfwF/iY9dOheOeLm1G2879tq/8J0=;
        b=CjQkW7c/nORE3m2beDcREUHMv+IkgIk5nQGin8hTEUeZju64CCDUQY8Or72EMprbQy
         CUgKIfspQUIzn278ZN1C0I+vnHRZ11pwvrNtUc95l1V5QJF2W7S0+Rm8Lx5GWtK0a3qS
         amU4Wd/dVIq1U1UgLGGMBBFF/N7ILROkbfSzwJ7fnndf3dUbaOnMGO0na/59nemGGCxe
         37TrkQBGSxlZ6DHvXmtOmm21hkV5MN66t+Np0pwTeBuITruespRde1jHxKYZ6akAwpGw
         EP3YJrzvpZpnQJ1mTZsdxbP60U3yQc9RepQcqD8ac9RE4u2OriTITyyNTwS/vLcwgOmT
         Z10Q==
X-Forwarded-Encrypted: i=1; AKwUvBzSMSvPGf0LLPdk4twCW6Cztp6KgPBgydSpzfG90rDA6CY2hnp0a+HilZNsE3HTga6E1zD+3uR7rg==@kvack.org
X-Gm-Message-State: AFuF++lux78xGSJJ9LKw/4xCNMSlx+7StnsXts2hy1cRId7rI7OeiXq1
	qBBQCEoF26LL1MqEZPUPeUg3tRvJqlPcOetUIg6r0sJfa2kaCed6oAOrTxLZW4kystI=
X-Gm-Gg: AYBFou15vPW74EZEsX0Ybru5xN2KOVutoJg37wH25FEmea1LJ9y4HEGxluBuH8L1fRg
	xB4NlmSRnkIlq++zs0vLuVEs+G1PWjMO14fjBiWOTIkqyyLFVdX16joOqg0xsXDMXMvMUmYTzVy
	goQ6zPXp1aTbEiPKaB5ioOsJI1UqSrgfEUoejMitwtE4DOOnnUBgQDNer6taBdSmPXkm2g3LLE5
	Vs6C8Bm+ghkX+0WpMT+3CHWvr6K7qfEQvOj1pQBci/rolcaoL5bAU9awMXjyVVFD0HQhcQ1Nwz9
	XQDDla7pBp3m6ow9sZFkLF2pRm3PqoGfm3UgGSUbpW31zD6YX02Zvrgs0FOYYE3E/zRGGTrc53+
	xBuHoHuxo9or/rHDi70pFL6Twrr7BTazbIGRsznaytD0V5b6C2YHAnsMtylcHcagPQdZmKBQBhS
	1+w/Tbjoi5aU0gXZ67Ts/F8XsZ9y1CARH0YOrLIHIXg6VhFUBJwixMh7DU+5RqIn7vy2RgB+68D
	g==
X-Received: by 2002:a17:90b:390e:b0:39e:8d5:fcee with SMTP id 98e67ed59e1d1-39e1e4d750emr15487090a91.17.1789628487085;
        Thu, 17 Sep 2026 00:01:27 -0700 (PDT)
Received: from localhost ([106.38.226.93])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39e361b3a39sm3418041a91.11.2026.09.17.00.01.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Sep 2026 00:01:26 -0700 (PDT)
From: Julian Sun <sunjunchao@bytedance.com>
To: linux-block@vger.kernel.org,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org
Cc: axboe@kernel.dk,
	hannes@cmpxchg.org,
	mhocko@kernel.org,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	muchun.song@linux.dev,
	willy@infradead.org,
	jack@suse.cz,
	tj@kernel.org,
	akpm@linux-foundation.org
Subject: [PATCH v6 3/3] writeback: record bdev targets in foreign writeback tracepoints
Date: Thu, 17 Sep 2026 15:01:19 +0800
Message-Id: <20260917070119.2648123-2-sunjunchao@bytedance.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20260917065759.2643940-1-sunjunchao@bytedance.com>
References: <20260917065759.2643940-1-sunjunchao@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 6D0B140007
X-Stat-Signature: 8a7939wn38t8d8spsa749ud4iqgrswz3
X-Rspam-User: 
X-HE-Tag: 1789628488-4964
X-HE-Meta: U2FsdGVkX188jlDYKIXHTr0e1NWyjmaXR14jNYj2V+LOfHgKp9rkZf3OjKK02X3DL1NpkMBLgWvx9rySFOi++UbknHqUjfpYs/PzTPaLNg5ZXV+ijMcmV6XNdgKztU3+hEhWSICeV5t7lMvRkaXymSZ6tIXSUh5i3v4Ph46Vu3/6SmM1xIz6L8wkJT95yxLPUMyUF8qu1RnV4zGeCGCZiT5reM9AcxvXrpUMeBeeFPfPmV0oMiZhhepr6RJ1GEn3ahYfgVw9j2y0loKNLOZw9SJ2seDCen7IhTWGINekCBX598pCIFUROIdNVMLB3AX/l4Frknt3lo+jtGiUVHz4D6S+RtqSQcBL/WmynpAQdrsBSVCCXZQbfEBi2ePaNDohbSBy9mdyxJELdeavErya3uwGPeyBEvUNh5JpJxIqR2grHihru9wrYupQRD8HdCHMOxn5x6LnloOgxIRhnf/BlB/LiZHohKEGiwhZoSqv3QbeeMnz6P30eKUsuEUXOuFMsofHwtWG2wf5Bqbdy8e/3cNyuDTE+08c5lMAmV+e5Yy69ub66zWyWzeD7EP1mmaYu0n6uWjxF5mwL61e5F/eRM1N+WSa20fq1JE+LdjSvdSievJm+nPpWsdysNA5LIJpzfg3s2+GthPrx+YHn3ja5Mt89+8Z49hvkQbKu3EdSgCZhYMjWxE9ouG9fwN6LkvrXMiw7+CROMHgJPeccSbEoDfBQE6HJWA1xem0acv4hJLt3NFmofAfouCLUdNzPy5rvy3Um1IbrkbuqXJaWF9TvJbfwCjB/2cX5GZ4FvU158fCBuNKQurLXDvEUKKD0fCtFE/SAlRf7daMONu7ng9koplmpIrlQZtC9D47oXQvYrbTKs5wKv1ijJ0W+jz5PZvbgESPMueXUVGe+fyoNllrQaYxnaN6wz3i+Chw9gK5AZREdjyavCcCqN6qidEe5GyZT/mVkQH0OkB2x0inDKz
 ZNHcg1dO
 3jEP3O4dsR5jqZ2iobLQM2jReP+CkWmUQFrcO2oFOlmlehahbrnUW7l6xt/YvEKEYSz+yvqRFf092tN5npV9N+K9gNhdVkK6A0KdME9czf5As28ue/rITQYdS253lHXLUUIiDZy5ZEDuHEeuk4Ex9wWFKu0dCDWiHri6BLTQ3RRE3WebczudaIOqJt7wWZh3LzzE6xPHF62cfJDOGXp5FYO0YgMrkgaluRbSOgMUV1D4sgNWY33Y44eqeYAI1SJBD6W13KgAUV+vo5ySCAoz5c++Us8ZeKd9Xdw229/RGhVUxXjiWADT3mUmv4NUo/hzjUe6TwxgQaak517G3qRZvzUvBC+m67/KtqwuxSvSJ4St1nTQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add dev to track_foreign_dirty and flush_foreign so traces can
distinguish foreign-wb tracking from the bdev-only path. Append the
field to each event and print it as major:minor; zero denotes the
normal foreign-wb path.

Signed-off-by: Julian Sun <sunjunchao@bytedance.com>
---
 include/trace/events/writeback.h | 22 ++++++++++++++--------
 mm/memcontrol.c                  |  9 ++++++---
 2 files changed, 20 insertions(+), 11 deletions(-)

diff --git a/include/trace/events/writeback.h b/include/trace/events/writeback.h
index 13ee076ccd16..ffd1b8df4231 100644
--- a/include/trace/events/writeback.h
+++ b/include/trace/events/writeback.h
@@ -273,9 +273,9 @@ TRACE_EVENT(inode_switch_wbs,
 
 TRACE_EVENT(track_foreign_dirty,
 
-	TP_PROTO(struct folio *folio, struct bdi_writeback *wb),
+	TP_PROTO(struct folio *folio, struct bdi_writeback *wb, dev_t dev),
 
-	TP_ARGS(folio, wb),
+	TP_ARGS(folio, wb, dev),
 
 	TP_STRUCT__entry(
 		__array(char,		name, 32)
@@ -284,6 +284,7 @@ TRACE_EVENT(track_foreign_dirty,
 		__field(u64,		cgroup_ino)
 		__field(u64,		page_cgroup_ino)
 		__field(unsigned int,	memcg_id)
+		__field(dev_t,		dev)
 	),
 
 	TP_fast_assign(
@@ -295,34 +296,37 @@ TRACE_EVENT(track_foreign_dirty,
 		__entry->ino		= inode ? inode->i_ino : 0;
 		__entry->memcg_id	= wb->memcg_css->id;
 		__entry->cgroup_ino	= __trace_wb_assign_cgroup(wb);
+		__entry->dev		= dev;
 
 		rcu_read_lock();
 		__entry->page_cgroup_ino = cgroup_ino(folio_memcg(folio)->css.cgroup);
 		rcu_read_unlock();
 	),
 
-	TP_printk("bdi %s[%llu]: ino=%llu memcg_id=%u cgroup_ino=%llu page_cgroup_ino=%llu",
+	TP_printk("bdi %s[%llu]: ino=%llu memcg_id=%u cgroup_ino=%llu page_cgroup_ino=%llu dev=%u:%u",
 		__entry->name,
 		__entry->bdi_id,
 		__entry->ino,
 		__entry->memcg_id,
 		__entry->cgroup_ino,
-		__entry->page_cgroup_ino
+		__entry->page_cgroup_ino,
+		MAJOR(__entry->dev), MINOR(__entry->dev)
 	)
 );
 
 TRACE_EVENT(flush_foreign,
 
 	TP_PROTO(struct bdi_writeback *wb, unsigned int frn_bdi_id,
-		 unsigned int frn_memcg_id),
+		 unsigned int frn_memcg_id, dev_t dev),
 
-	TP_ARGS(wb, frn_bdi_id, frn_memcg_id),
+	TP_ARGS(wb, frn_bdi_id, frn_memcg_id, dev),
 
 	TP_STRUCT__entry(
 		__array(char,		name, 32)
 		__field(u64,		cgroup_ino)
 		__field(unsigned int,	frn_bdi_id)
 		__field(unsigned int,	frn_memcg_id)
+		__field(dev_t,		dev)
 	),
 
 	TP_fast_assign(
@@ -330,13 +334,15 @@ TRACE_EVENT(flush_foreign,
 		__entry->cgroup_ino	= __trace_wb_assign_cgroup(wb);
 		__entry->frn_bdi_id	= frn_bdi_id;
 		__entry->frn_memcg_id	= frn_memcg_id;
+		__entry->dev		= dev;
 	),
 
-	TP_printk("bdi %s: cgroup_ino=%llu frn_bdi_id=%u frn_memcg_id=%u",
+	TP_printk("bdi %s: cgroup_ino=%llu frn_bdi_id=%u frn_memcg_id=%u dev=%u:%u",
 		__entry->name,
 		__entry->cgroup_ino,
 		__entry->frn_bdi_id,
-		__entry->frn_memcg_id
+		__entry->frn_memcg_id,
+		MAJOR(__entry->dev), MINOR(__entry->dev)
 	)
 );
 #endif
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 55bd5d100caa..f634874bbcef 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -3949,14 +3949,15 @@ void mem_cgroup_track_foreign_dirty_slowpath(struct folio *folio,
 	struct address_space *mapping = folio_mapping(folio);
 	struct inode *bdev_inode = mapping ? mapping->host : NULL;
 
-	trace_track_foreign_dirty(folio, wb);
-
 	if (memcg_bdev_frn_wq && bdev_inode &&
 	    sb_is_blkdev_sb(bdev_inode->i_sb)) {
+		trace_track_foreign_dirty(folio, wb, bdev_inode->i_rdev);
 		mem_cgroup_track_foreign_bdev(memcg, bdev_inode->i_rdev);
 		return;
 	}
 
+	trace_track_foreign_dirty(folio, wb, 0);
+
 	/*
 	 * Pick the slot to use.  If there is already a slot for @wb, keep
 	 * using it.  If not replace the oldest one which isn't being
@@ -4031,6 +4032,7 @@ void mem_cgroup_flush_foreign(struct bdi_writeback *wb)
 		spin_lock_irqsave(&memcg->frn_lock, flags);
 		if (!ctx->inflight && ctx->dev) {
 			ctx->inflight = true;
+			trace_flush_foreign(wb, 0, 0, ctx->dev);
 			queue_work(memcg_bdev_frn_wq, &ctx->work);
 		}
 		spin_unlock_irqrestore(&memcg->frn_lock, flags);
@@ -4048,7 +4050,8 @@ void mem_cgroup_flush_foreign(struct bdi_writeback *wb)
 		if (time_after64(frn->at, now - intv) &&
 		    atomic_read(&frn->done.cnt) == 1) {
 			frn->at = 0;
-			trace_flush_foreign(wb, frn->bdi_id, frn->memcg_id);
+			trace_flush_foreign(wb, frn->bdi_id, frn->memcg_id,
+					    0);
 			cgroup_writeback_by_id(frn->bdi_id, frn->memcg_id,
 					       WB_REASON_FOREIGN_FLUSH,
 					       &frn->done);
-- 
2.39.5


