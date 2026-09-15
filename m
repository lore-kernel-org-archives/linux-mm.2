Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 99E0EC88E53
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 08:34:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6F4E06B009F; Tue, 15 Sep 2026 04:34:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6CC906B00A0; Tue, 15 Sep 2026 04:34:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 594CD6B00A1; Tue, 15 Sep 2026 04:34:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3BBF46B009F
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 04:34:26 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 91D5A1C1801
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 08:34:25 +0000 (UTC)
X-FDA: 85215334890.01.1DF783E
Received: from mail-pj2-f12.google.com (mail-pj2-f12.google.com [74.125.227.140])
	by imf21.hostedemail.com (Postfix) with ESMTP id 680591C0003
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 08:34:23 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=FG7Yklyz;
	spf=pass (imf21.hostedemail.com: domain of sunjunchao@bytedance.com designates 74.125.227.140 as permitted sender) smtp.mailfrom=sunjunchao@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789461263;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0/yQgHlhdL4OluQwF11kwgzbIv6YOPTPPpwWaUVKRIw=;
	b=1zW+vRsXqY+29aArfxiMUlp9LQeLIhsUBJoovGtFsWXgLsQjVY1nDthv5z/aJU2BMNvxpg
	CBnv9DicSreZqWKe4v0tWdGD/jAm9iDBp/tGCC0GfyIRNtGK7qucABzB64ls5trnvDjhJu
	bxaIX5gxkEJSxLurvx+aE+FHEHQKCcI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789461263;
	b=g8NTpx/18bz+G1DG/LUtdvOyYd7fEo0EOs1oCPg0J98iBMY5IOnM0QXIo1EfjnE3SD4AVb
	uqXEIQxqVUl3+ekRfnntxDaBgNErmb2t7Ix2YjefHZq9hzhS+JNMm5CpEdRKljGp1euhEX
	ja2DheDBK0BDjcNMU8nuGw4EHLeRXgU=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=FG7Yklyz;
	spf=pass (imf21.hostedemail.com: domain of sunjunchao@bytedance.com designates 74.125.227.140 as permitted sender) smtp.mailfrom=sunjunchao@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
Received: by mail-pj2-f12.google.com with SMTP id 98e67ed59e1d1-398beb616f5so1156358a91.1
        for <linux-mm@kvack.org>; Tue, 15 Sep 2026 01:34:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1789461262; x=1790066062; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=0/yQgHlhdL4OluQwF11kwgzbIv6YOPTPPpwWaUVKRIw=;
        b=FG7YklyzsG6UgNQcEXpSct87FM73CjJVQK7BV5bAy66H0n8q2QF9wT7G4qKzxkKM2k
         gsXGQkDYGjxCN1NWvmXKF2L47GFccpGyANTVElhE7y7IVXemwKbWZdARDf1qXHqGyzJJ
         zVXcpN9qLRceEacPIDcyL12slfo25WE5BHQ9DzZ9LPjvkzwW18uZGaLFlqsHxvh/0Fhg
         4+e26bL8c6+TLX/FQS6co7bhxdvcnPKcM27hjgYDQUSrsQxTMSJBv5/IMLqrHzCmDR9w
         0wSrc9g4LUcoFYjVr2piAg2qZeGVbKJmwWAQD8QsKDuZgudINtHO35Ijyo4PubB/lHoE
         iglg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789461262; x=1790066062;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=0/yQgHlhdL4OluQwF11kwgzbIv6YOPTPPpwWaUVKRIw=;
        b=tCkWYqrZ8NABl0bevHlk3uecVXI9EXgzFTqGPcu0666+piU/keWP/Dxt4yaw4igzpH
         yiPNMv7yFU9XEQo0EzXRTqQmO+UXs+X5N+xpg9Zir23p5ngXY3xF6k+BVFV8xbgDYxdw
         VNzrW1Uc1WZ/nasbIhdHjiJ6neUUYjlB5KdkpGU1Ds1235Fk08PqMbXpRrwvPEx8Buk2
         tmfIAJO1fgusehcJz4TJHfC9KH3j51EWHbOw2tQTQXcjzAzXdD8vxNb4pax/XOQ4cvxS
         WxIuFfoJjT79LjyfH6I+7XTGufYPZF7qL61iiZl8o6zwqliNdNC5zAKG527Goj5lCEph
         adwA==
X-Forwarded-Encrypted: i=1; AKwUvBzFjKWpfYvq44JL2YS439u8HcqBz5P+dBFE8BHKrGDxw90H1kF56UeExKhSsJZlx1pMsPM2VDM7/Q==@kvack.org
X-Gm-Message-State: AFuF++ngZk3OJu3Nzv5/Y9Yzk4g30VFwgqKj2xm2YBZxPPUp6ekFiJGL
	r4RjmkmWEhb/nkw5YgsdLDa9GDBhElO8RlYe371Dyd3YHMDsawdjFWsBUjhqiAQGLYk=
X-Gm-Gg: AYBFou1A4Mirwxoi13S4Fs3dzQYiYRWbXcZr6bmKCrlVaZ9lYDL2m8cdsL+VQTEebQh
	MjabGUp+0023CLU+cme1zZYAz5gq334yl2CR7JP8YXv+V/JR9kl9b+oYCpO8nuc4QRqQrV7joHY
	7HKMx6O0JktGVdvSpg8d5QPGFDlzhCdyT78ALBKlREQZpc+41OMrJA8YpRXYlbFW/MONarXQA7b
	g3C5XOYlRx/1QOKDMU9U1/v+J+q0qYLAjpkcS2IU84fVHgX9CDO7gUvw48QB5XwycgSG/mIFXBb
	tZV52zogsO2C0QEWFVhwltk2QJXZ/Qnb1k1Cohj1sm/ni2oW0JoNm3KSyAOPi4bt2F4I6iGKdOE
	x54kKHIxZHz+PdtkTc/zoecxaEUaYWYAzqNQdrkSzE8swOHEElCof+tK7KhJiqpmxtXxKU+kKtP
	cVZJHj6TtP/denO2WEKBhYWPnldvYpnKrSYOgjw7gorveEEaCGXYDRbWI2Q+uaXC9LcnyOCbVxd
	g==
X-Received: by 2002:a17:90b:3842:b0:39e:b0d:d274 with SMTP id 98e67ed59e1d1-39e0b0dd4c1mr680798a91.10.1789461261990;
        Tue, 15 Sep 2026 01:34:21 -0700 (PDT)
Received: from localhost ([106.38.226.80])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39dfdd28acbsm3920243a91.10.2026.09.15.01.34.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Sep 2026 01:34:21 -0700 (PDT)
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
Subject: [PATCH v5 3/3] writeback: record bdev targets in foreign writeback tracepoints
Date: Tue, 15 Sep 2026 16:34:06 +0800
Message-Id: <20260915083406.3471036-4-sunjunchao@bytedance.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20260915083406.3471036-1-sunjunchao@bytedance.com>
References: <20260915083406.3471036-1-sunjunchao@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 680591C0003
X-Stat-Signature: 1gizhbhps6pgs89ym81yqxpu6pjfdy3r
X-Rspam-User: 
X-HE-Tag: 1789461263-886285
X-HE-Meta: U2FsdGVkX19pcnkZ5kcHKYKNPEKmMNnLOaHICy/cq+p2cSDbMU2yw+iKsiBbKZkCJvpEAbXghj6pwk2e+9oPgJvavJ2CWIeGBHo5ApqJ3WGlWzSyT61SB7OPcy8sergjQmOopcsikstiCwrq8hKdY+PBWqoxFSgP1sIL1nqhfiPewqRPtjPJzylWartUPckIzQD9x1zhegjDvnphNEwzMV8G6lD7QuTrAwUFes7jWhY4IxAGN8rK9FQ9dp4TSeCYGldz0Rx8CLpUpwiyQQ4VLgaGgZT8UU+XHxSgAzox4Qvxh1/uFTgj/fMrDem5Fe5JdfxDWjsguRSXavr+dRkH2V/uRxoMi2krhfu7BXrFeGi8bwtyzF7Zzrc0lPt4qayRUA6PzHYB4RL3z5yjTTvkZ/YbbIpOvkLvqfLJ7H68FLUTsxEUvjndjXm1hlFIw753UTilBOoP+1GiHFJ2Nfq0dxcQVyapO2BkYemkJTrUoa29B1h7ELE/kqzeVX3Vqeu2awUILHSz55Z2OLXcY4r3iUovVG2n23C7CBBLPQkymHmp37xa1WaLTxf80KxEOwLIhLwgpI2LbyokJ0LWXnluPi8I1Z6IZSVxtvWmMQdzdFrCDGvPnWS98AQDpUZruEhJTBOQOCFVT/MRcVF2QCSUpADJr5PCSNS0Ux73vt8pO4xJRE8KScR13EJbG3DUBDYSTOyzy3faqdjCOmA/tkNE35R19WyApCHgl74jCYC1fsHWKX7O7WQGaNbQZSNgCgbgAg5nsDNOWmrWZj3Dd1LQJOdz1Izlgj6pWuX97Dq6nTTFNHNJDY/CArr3i135AhFV0Ulo8t6iC4Zxm/CzP8b6WHZGyE8bCLQRd/1C1cdMdiK8EWJBBv9KLosf3VOJe2sbFNCRA2JbNIVPx+c3s1DWh9H9GWnIGhTgR4gCpPFBZpZ35S1hNF38LZN1fbs4dQFda/Cj021amACLhq52zbl
 6inzjExQ
 zei9sBxPZKXMut4PC6lZQloXlcVR2loUFiawph8glc7OByadNNOAHv8VrFqe8w864azOGGgz6hzw0kd1vsOozUPhDpDOjySAojZAvA5tdxOkJvqly15v+wfH3OfRsqZJ6YXRd5mh/YOiSSodmCHUXtfo8qnTfksDWMo4EKD9bRMH/+F/53WBn/Jk+KWyo5wiBL6g/yvVlp9cyplR8VBDV9soIs+e47M3I3OZqm8ZbDABMJEolbaKVGF0hHbqTr0rRtLtO/46cuuQ7YkgLyi2lsw+gVyNJI5mu6fVQ5AyxzbvwFDhOJPPOneCTfrn1YL6t/+Aky0Snz/EopeMoGIddkVh4TF7rLLngOOmx65RnNInx73VRvK1DK4Iz/Cg77f9HYztSj8N6Furze96B0YgD4gStlgqzVM/HszHjYNxAjcnQnuDI6dTECNgCWY4ONg0BMRig
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
index 61ebe4ab744f..74bc94826392 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -3938,14 +3938,15 @@ void mem_cgroup_track_foreign_dirty_slowpath(struct folio *folio,
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
@@ -4020,6 +4021,7 @@ void mem_cgroup_flush_foreign(struct bdi_writeback *wb)
 		spin_lock_irqsave(&memcg->frn_lock, flags);
 		if (!ctx->inflight && ctx->dev) {
 			ctx->inflight = true;
+			trace_flush_foreign(wb, 0, 0, ctx->dev);
 			queue_work(memcg_bdev_frn_wq, &ctx->work);
 		}
 		spin_unlock_irqrestore(&memcg->frn_lock, flags);
@@ -4037,7 +4039,8 @@ void mem_cgroup_flush_foreign(struct bdi_writeback *wb)
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


