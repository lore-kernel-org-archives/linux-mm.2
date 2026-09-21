Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E4184C982E1
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 12:07:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 02BEA6B00E1; Mon, 21 Sep 2026 08:07:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 003516B00E2; Mon, 21 Sep 2026 08:07:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E351C6B00E3; Mon, 21 Sep 2026 08:07:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id AD3A06B00E1
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 08:07:54 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 9B7F41C0A68
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 12:07:20 +0000 (UTC)
X-FDA: 85237644240.11.B66ED65
Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	by imf25.hostedemail.com (Postfix) with ESMTP id 99E0AA0005
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 12:07:18 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b="i/1dWtCG";
	spf=pass (imf25.hostedemail.com: domain of sunjunchao@bytedance.com designates 209.85.210.180 as permitted sender) smtp.mailfrom=sunjunchao@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789992438;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=P0BhgCT09QkgxSYiuPM6SIpincAZrzVbnzV7okAgnX8=;
	b=duYFoGQQuZcvCq8r+6EColAuGguHdfNzXXjKmKUq2D1KimllNoLYb1JvjxUcePF46xOQy2
	NwZ0c9BqykYggbJCFM2keAXqrSZsOzs0NnySNtKpX1redCztUUAMMPG9HyD/7EgWMMPSE+
	c70Hptg3bHd6FG0tuxth0Rw15SVZHTs=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b="i/1dWtCG";
	spf=pass (imf25.hostedemail.com: domain of sunjunchao@bytedance.com designates 209.85.210.180 as permitted sender) smtp.mailfrom=sunjunchao@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789992438;
	b=q4zxux+2O54o6CrO6LcgsvcM9usZTHHG3reocCuEk6ZIqqYKII0sDM2S3f2FGgGC+//bai
	NaB4tzyUrnoEqTjrSy/o1V/l9xPJ6zjlJQA7Ysx+8RyzlzJY/eF9jcUzkN2XcSdAHiCVB5
	9XYjcazdbTq+WoKOEqa6XjDcMCb0bvc=
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-853e2610bb4so2152632b3a.0
        for <linux-mm@kvack.org>; Mon, 21 Sep 2026 05:07:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1789992437; x=1790597237; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=P0BhgCT09QkgxSYiuPM6SIpincAZrzVbnzV7okAgnX8=;
        b=i/1dWtCGz1KBgXHzzmmeJVHtLWpSdK/TxA8kcr2q9+TjqcCPkXOoK/616LugDPjaRZ
         UVpJcNsMhPmgPcnqVX1oppX82y49DIBBKFdZi4TPe0AKsm5Afu+g26+jljGYtC/bR+wt
         ZnpQ2nvdxufalmM4ZgXv7Xtnyx4ANjdWsVa4xc2ZfhgYcfGxyjzEL81jnUuaQbe2Xouf
         jyHyApXj9WAnSmXPe9xnNxjg7S9KFasL46y8Ln3/gSnGVZUoaAR5HJGKJs66NICyvsmR
         1VbXkEI7vMvxo2dN1mzJJMIAU1NOk8tXbAA8iaYmJapuup2FXOvabrZZRv6kpm3Rx/4Z
         MrTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789992437; x=1790597237;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=P0BhgCT09QkgxSYiuPM6SIpincAZrzVbnzV7okAgnX8=;
        b=bIXQ1gY3ETwvdMHc3resJLpas/oZupzek6qP2nqdnVb1fVTkEvFx4iWl1mfAdyDsvD
         TjPYY4XsIteSEiT7M8npv8R/NYXKDt+D2DUh8qDfjzw2oe7pQwOIBPb0cQW8iC6UbGhH
         YYiDVovXjY6BH2FCB7BvD18pnI4S3Cavc/J6Ih55teTC9iEh9FpjR4CNMIVKUM7qtk95
         lW6WFegFUuMnsAECON5QzbhT4Bff5SmpTR/Sd81Tp0nNppE0I54Y5jdt/j9qIjWSy205
         m/FtNp7if+sQlWts8O/1y5C1viQZ5ryaqQDUWGnHrdIV6Ob/P6+n1JxoOF0PADzFUn0O
         hPoQ==
X-Forwarded-Encrypted: i=1; AKwUvByC0QTLn0SrJsezZNhVFtUzfvwesdghM2byPJ0dHOdC+ed1d6DeuudjVgPzPHMDdb0BIJcs9hEK4w==@kvack.org
X-Gm-Message-State: AFuF++lnYvLhBD5hIkE8tMtXdYBmYsvGzhoYDfAxEfVikFgpMuJqNs/I
	Bpix2Hp7MLiIfo1FVgr4Ng3g57uskYPTBsJ6JWwZo/5Goibz7upR9JDW/dN3uutL7mo=
X-Gm-Gg: AYBFou3HyEmPk5sDTwIDCw7JE8aHP68mr/afTUuQ7AqdjnfxD48lSYG6+F73cdpuNBg
	U+gX+OdHzdEZhbgLBoEiRokhL3Q9HWotVXDgfDf9xNI7AEAZO6rEosCrjBHuGK3PBdEzDIR0g+c
	8HAuiYZJDrAd+pX7OJDfcaIQIrnqKZXDousmJatkeWcRl/eHgsl1DakKnQMwhV7fSEjP+ek14UG
	/6dxqUCDw7mHQiv/qPGs/LTlqZdRjZ7AaAAFJjMcTmLFb0WOhewOV7zzTgvlr+HE20akRE8I2V9
	w3Cto2qhlQc8jdYvm25hzKsWGaO2K9MqGIFW196qikjV4FKd/2H47KAQNeoCsaaIFktg3A0bOYd
	DkP27Ltk+BSldexSbjEfzynvrlQ143VMNRmsUD/vcKcaVajQEoKk+b2ikhFZYkNsFOp8YmG6V+s
	57ZLB9xxZZ5JW1YOH1gCJOnlNmGuo5Ph+yRn+reSfuhRYuO9vcTqxH7uiCZubs4TCBIDsy4xFL7
	S8=
X-Received: by 2002:a05:6a00:3d0a:b0:837:f111:b70 with SMTP id d2e1a72fcca58-87341085fb9mr17288545b3a.4.1789992437273;
        Mon, 21 Sep 2026 05:07:17 -0700 (PDT)
Received: from localhost ([106.38.226.177])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-877aa108e58sm3104740b3a.48.2026.09.21.05.07.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Sep 2026 05:07:16 -0700 (PDT)
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
Subject: [PATCH v7 3/3] writeback: record bdev targets in foreign writeback tracepoints
Date: Mon, 21 Sep 2026 20:06:58 +0800
Message-Id: <20260921120658.1627992-4-sunjunchao@bytedance.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20260921120658.1627992-1-sunjunchao@bytedance.com>
References: <20260921120658.1627992-1-sunjunchao@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 99E0AA0005
X-Stat-Signature: 3bwgrm9gj7enxeh59hrxd8mysigpjdnj
X-Rspam-User: 
X-HE-Tag: 1789992438-942762
X-HE-Meta: U2FsdGVkX18Q0TqZJhqrL0y832U6NkOjF+AVG1t5nzz51FscISkDi5fNzEBaPooqVCkzWRK5NLNP8tR9kYLddC0axfJWi5kKe5mmEF4gSDegsakG7a8iWOR/l4w7y9EzsSgy5hNuT0sZX0+EkC95n5MeTMiXoRMlu40scfJkSjDL6NKw02aobhycWHcKt2/+y75cs3eSLz3k7XVh+XlduRD3q3mNgSMTw1OTwtKY68SkMOHZKN2eB0a+m7B6KQtZB+MxOU2/bIF+r8r+rUbovPZ19C5lIxXjeHddSl0O1BQyo57tkzFfVhF0zxwpVidxrCMrzLR/9XGVtwQgmnSCP9ZgZ7i074DW0wJdQqIXfpXroNOvFn9zkjgZHutLmQTNChukjk08UVoLOHtZcGBhULeLQWT8A27dMJnwGU0L97lZmUK8G+Nv76Bz74XxlR7czXQG/MUETz/zt1RfmvxGW7vAY/qG/Dotu3SbHyUJI1TLNd0ntJPKYob41ELH74esYvxSH3KyUX04ZwJm9qQQz0RGlc5U4M+5nzxSV0qeP9QOBBIgrWAtfvzhXSTKxFmYETH+lFe8NGYvU0LM+keC75d1Y3bSDVz+xWRMwMAuXMpgxIPi67AQviDg8DzX2IRWxSmcvBjVD73zwv0KynwpTR55wI1Rcrn5LonGmL9eVXXvdvPsz8e0yAAEVsWiTBhply6UMRfItbHPLoFiEuRFY8JLbGsFovAFi3D/fRblBTBCzU9J9p9q9II6nq5wETTowo9NpQa1xO8jBuvMtmMyvRTC+R4NJRyFOcOuvGD1KhnZJP0erscyvwW5G9naskJ4VL3oyKxpceHyOy6DQCSyOh/qjycGqJbzd27Eei5pdg8EYL8/fqYYSx2qtCvjqbI73XAJtPvQRXN3v00C34rYSVqfcmVX2cLIi67dGJzpX/dVoLfWH+icpNDoJwmstDzpNLPAAZ0MKQEapsi3cVv
 zrcxTQFD
 RqaTheTNJQFSk0hu4mj4igHVA3L9bV9ems0Nmc4qgO8qnMjthRhDXd3P4JeVQRcd2h2MQSpCjrjCfKHjq/iDwWJbjhdJRVhoWiAV40/p7lkIP4HKFWhnRmrwuQgLnWAwC2/nm1B7oQ0h3bX5Iq1IzRfeFtNaEYTSlIk6rXAXunPJU4gIgNb+eILcWURA1wu52s4s++wiOcYVkvHpVYUnekmSNDGQMlm6xc+jhb2as2/AjLHFJOS0oRIrpU736sLUUkq1AztNhBkqd8zeKj85UQHAhm1LKtL/2JB+HjqbZL4gnjVRVHJh0jBcx+ADd3WqCTk+eVj4OSI+Y+9VeDy7rixgFhCz/8CzsNGylTJSRb1HIZxQ=
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
 mm/memcontrol.c                  |  7 +++++--
 2 files changed, 19 insertions(+), 10 deletions(-)

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
index 494540cf6278..6c3083fcc063 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -3959,11 +3959,12 @@ void mem_cgroup_track_foreign_dirty_slowpath(struct folio *folio,
 
 	if (memcg_bdev_frn_wq && bdev_inode &&
 	    sb_is_blkdev_sb(bdev_inode->i_sb)) {
+		trace_track_foreign_dirty(folio, wb, bdev_inode->i_rdev);
 		mem_cgroup_track_foreign_bdev(memcg, bdev_inode->i_rdev);
 		return;
 	}
 
-	trace_track_foreign_dirty(folio, wb);
+	trace_track_foreign_dirty(folio, wb, 0);
 
 	/*
 	 * Pick the slot to use.  If there is already a slot for @wb, keep
@@ -4029,6 +4030,7 @@ void mem_cgroup_flush_foreign(struct bdi_writeback *wb)
 		if (memcg_bdev_frn_wq && time_after64(ctx->at, now - intv) &&
 		    atomic_cmpxchg(&ctx->inflight, 0, 1) == 0) {
 			ctx->at = 0;
+			trace_flush_foreign(wb, 0, 0, ctx->dev);
 			queue_work(memcg_bdev_frn_wq, &ctx->work);
 		}
 	}
@@ -4045,7 +4047,8 @@ void mem_cgroup_flush_foreign(struct bdi_writeback *wb)
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


