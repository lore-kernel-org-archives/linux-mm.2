Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A1BBEC982FF
	for <linux-mm@archiver.kernel.org>; Tue, 22 Sep 2026 12:50:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ABB4A6B00A9; Tue, 22 Sep 2026 08:50:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A6C336B00AA; Tue, 22 Sep 2026 08:50:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 95B016B00AB; Tue, 22 Sep 2026 08:50:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 657C06B00A9
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 08:50:37 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 6462A1A0465
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 12:50:36 +0000 (UTC)
X-FDA: 85241382072.02.04CFF8E
Received: from mail-pz2-f41.google.com (mail-pz2-f41.google.com [74.125.228.41])
	by imf16.hostedemail.com (Postfix) with ESMTP id 953C0180006
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 12:50:34 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=PU7oMtNO;
	spf=pass (imf16.hostedemail.com: domain of sunjunchao@bytedance.com designates 74.125.228.41 as permitted sender) smtp.mailfrom=sunjunchao@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790081434;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=juILZvA/W9TMtNBQ/eIZx9CWcsdMz7oCJkpEETYimaY=;
	b=0YOUgTZVXSxnpzyta+8vn4dzSK+/arbvlOq+LQDeQd3F0P8o8SncXthSTEPOQsXiMqBL7B
	HnTiWgCOjYYkl0v9fZKblx2avLBNpEZwZP77Unwghy9Gx/7avM2evUnfukYUYgErIIMzZj
	qpkyUso4B6Fz/mzpE9fQuAPm0Qqk4Ng=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=PU7oMtNO;
	spf=pass (imf16.hostedemail.com: domain of sunjunchao@bytedance.com designates 74.125.228.41 as permitted sender) smtp.mailfrom=sunjunchao@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790081434;
	b=TRQyEYJ44C51kVgwTdBzw03LnwS+1S/FYvuo1gDrtRW1Dsd6Zq6uEZ2YQ2LGBApYEBBIMs
	EunUs9RiKzNRky4vk4KLxM6xCzNATqW7mmw3dcsennbqo4bTvJ1vS9UOy9TU1MI/9QGHHU
	KiplwJ5CZYW2D7PEJXIZVn5xThiaiOg=
Received: by mail-pz2-f41.google.com with SMTP id d2e1a72fcca58-8686f46e4adso3474821b3a.0
        for <linux-mm@kvack.org>; Tue, 22 Sep 2026 05:50:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1790081433; x=1790686233; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=juILZvA/W9TMtNBQ/eIZx9CWcsdMz7oCJkpEETYimaY=;
        b=PU7oMtNO/bVUIZzwnnOWhpM7xK+Qu4fgFdZJOcI6ofulxJNtk9SI/RvlMxYRhvn3Oi
         AWqtjcsaP5KvQtUWvZ/mP/zYlB4XdGIgKJzhsd5+49HaLRlK/VNwxd4RYdaT1KxmTK98
         37mUzYgm8JHQPIncQVJ5wsFBubn5v+7T1R1G3r+DWh/afv6YdqrQJWVsoqA7iSRsghDk
         9Fpt+QCZ+7yylTt1NBHad8Cus9unaDKG/FxH19QyPWgXZfdoSzANjtKmYJ9Gk54i9lRN
         EnT8Shuddav05RSkFxFiHvRccMHY4Z0SDce5JNXv8stEFPjSeAAcDaXFH87zxhvodw9r
         EIBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790081433; x=1790686233;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=juILZvA/W9TMtNBQ/eIZx9CWcsdMz7oCJkpEETYimaY=;
        b=0rNl3FotmTt2SDOD4nekmC0tGYxAUuxPYku1ieBHrdGYZDFPg5bSMGssprVTwvi6Mc
         CKlm+GZ3U1I4TfXaV96Q6m512bb7GTWRgUOikvITjdcRFPygmQD/vYcRQFiLQpDwVJOv
         sn52wmuNjzkoZR7f+NKEstBUybFi2irK0TNc0FhvrrlGQKrZ7LTOfe/5hGlxxMauXqzO
         HWnF/pQt05CS7/rtbhD6uDe4PfuSAoqW43UbbOatMbcE3A3v0asJpN+sl+8kA7tmYKxe
         ib43q/0wOn+U4k6f3qtk7np29+L0nXu/O4N+VB87GP5Y3K3F/417rXl38UPALhzA4aB5
         iEig==
X-Forwarded-Encrypted: i=1; AKwUvBypIj7w2F6Qe2YfQWLHG7V72HmCrlSUuIoYN4k/MQX11hfc40N8vOwpF44UJpvYDoAEvDIEo/0gVA==@kvack.org
X-Gm-Message-State: AFuF++kWgwImkuSiG9aNY6ZoMGEffwg+KUAw9wXX18HAFuARrh/ZEHqg
	0vynpNNnpUH1rSmlNSYQSsQbv9vpjvn3kyzVWzDc8NBmqjBVbxU6ygeFVzTeRLZyff4=
X-Gm-Gg: AYBFou3N8YFuPW0drg00E9E8e0qvqKW10HOCe0svAWZgjYJWwryxVN/FDgpj6Nbrur+
	Z+U0WV+kRvBZaCasmGRI4bzxl+Lqed9t9qKIOH2obA718bxO7WuUKjalTyeZs1yLyQ2iWxQtdql
	gCSl1SZ4SFaSUiOpvgd8ysqby25JkMCD4eP9aRP4eXGTASpg8pXbi/zF3c8CE1b7zkorEXTAJ2h
	JUdbZBhBvr5EmRltzf+QocoEwlyeTcd0/UxFX0AQ/vK+cmpc3rrtndSCgMIs5l5PizxA3/qLjec
	XH9En16X3FSDeO2R7kZIta+s/JAPIqsClh8Ic8kfNn+cv4zbAqi/EmY5qY+CpQd2uoMC2dgQyJk
	354sOym4ofrMvbl4cKAN52Pd56qIWhrqgRUwNLDwtfhUauS1SkOxBJNbRyFcOz/INK5LToAIMrc
	y3OM1NT/h6Bv9EZLNeUTWxt7HLFDoz1PawtDXRPhITb2cD9mafPl89J17c/oHnxtTT8C1HeWMlg
	LA=
X-Received: by 2002:a05:6a00:3c95:b0:879:531d:199 with SMTP id d2e1a72fcca58-87c84043665mr1114410b3a.39.1790081433323;
        Tue, 22 Sep 2026 05:50:33 -0700 (PDT)
Received: from localhost ([106.38.226.138])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-87c331b0629sm774868b3a.51.2026.09.22.05.50.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Sep 2026 05:50:33 -0700 (PDT)
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
Subject: [PATCH v8 3/3] writeback: record bdev targets in foreign writeback tracepoints
Date: Tue, 22 Sep 2026 20:50:15 +0800
Message-Id: <20260922125015.3435215-4-sunjunchao@bytedance.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20260922125015.3435215-1-sunjunchao@bytedance.com>
References: <20260922125015.3435215-1-sunjunchao@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 953C0180006
X-Rspam-User: 
X-Stat-Signature: mg4fkkmjw1h9tbmbwim5a331k9qyrt96
X-HE-Tag: 1790081434-905113
X-HE-Meta: U2FsdGVkX19ntTg7RF/KtZt7YWtIxdPxV3mWJFVBWYd51LXqjLmvFg9wE6tyCNyVxOlmYNOIUSiy+Wc7fzeMasvOMHDt/aGef3UgkQiSeFKhHRObFWvxv1K1vtCwF7gKUwO8LYuhDh1l6p27rk6kjOkZJyOdBQV6xZr7wtGW2WrEV2YfNGPTsSK8yCtvUe2X9JIOMruwZC5neJ4T2RI1Ns7A3L2c5I6VFRP6YzOaz9Emi/wYf56QnRHWAscydGJbxIt16+3hY0sJ8qbASMNRCjG0uDeXYm3KcQ+t61Na5hOM2LJ2tMLS5OtaXHj+Ix7uZcmSiFfhq9v9BOdFKaSUeBfslWUUagwLxkWXhiB9e4xJzcNMyzxfViE0ggYcSU0e6riqX9vPVNd8pJGRmEs3WQQ7l2w8eDR8ZMUUBNUOD2sIsoiYoSkTbCbUt3kqJ83elZMoQ9xwaY13CMNENrtlTACbPM9+r8BbFo6aym1T+hKa2P67E56v6V3Srzd+Ndq8G3dBkxCD+THGS/M3ZM5fZk19BhXrgtqDcepvmuILZEO/dezvOueMghUe5FzWncdLh5ylBWf/B3nicIm2MB+2QeUlDyEVvBnvhml78+gYylHk81dBOLXF3C2zyNHpxq24kRra8KOHjTICXV4+5gg/t7pn17xdTrUhFXhxHHEPUe8vRqIYBZeDhMxm57yklh5Z1CR7gh3iP5U1pFbAuzAXJom59t3PyEUdQ5r0IA9jmW7M+5xGdL9nIaMWc+QlppaY4ivUiXN11YWhiaTkKiUi5qluPrDZDQTv88ko6jggLyvmWagCX49TMHT3gDCBvzEM/b8Wjx66MTAOwG68SQATk9uFZskKzqmVa075YbQDvyiexAAFkuwWFbsIULNqiYjG5L4BUNgzIC8cRRlRfU9oYww1v23quEUrb9z9f6+EUDKB6V6pDNJh70HrtpsmMPhbjXA3TybheYfFG2X+vjj
 2wlFhPmW
 3e+cMCvi8W2H31cPDcjVo0EhepgccL9g/wJlpvGixT0JK9lLXe7hep7G72jX/WN+b01BtVpu8MWJLaFABZf3tvFdMxiGSNLy2E8I8BwrWm/b16t/MAWFxZY+cdmx0iB0rc0YWrhPrsVymHY7YGCrPPOZRDH44ikiNxX5XUJsAaFUUvcyTujqeuwjO3tRAqhVt+HYb3TK/4UUUMqtgCocG0ykqozoznRSKIJ2LzcoqxYtcmUXXM80th3ej5eb27/EBtZ9uumxsJR4K1uJ1TyTdV69/vmpd44i7KbUaIf5LxSWb0aL7Pl0RECOkOm+kFWZBdUgBYQJ0anzwdQDuadj2ZUU0CAvO2E1BsMZ14voafBp196c=
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
 mm/memcontrol.c                  |  8 +++++---
 2 files changed, 19 insertions(+), 11 deletions(-)

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
index 6042c694d56c..534b0d537a09 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -3956,12 +3956,12 @@ void mem_cgroup_track_foreign_dirty_slowpath(struct folio *folio,
 	struct inode *inode = mapping->host;
 
 	if (memcg_bdev_frn_wq && sb_is_blkdev_sb(inode->i_sb)) {
-		trace_track_foreign_dirty(folio, wb);
+		trace_track_foreign_dirty(folio, wb, inode->i_rdev);
 		mem_cgroup_track_foreign_bdev(memcg, inode->i_rdev);
 		return;
 	}
 
-	trace_track_foreign_dirty(folio, wb);
+	trace_track_foreign_dirty(folio, wb, 0);
 
 	/*
 	 * Pick the slot to use.  If there is already a slot for @wb, keep
@@ -4032,6 +4032,7 @@ void mem_cgroup_flush_foreign(struct bdi_writeback *wb)
 			 * the timestamp for a later flush.
 			 */
 			frn->at = 0;
+			trace_flush_foreign(wb, 0, 0, frn->dev);
 			queue_work(memcg_bdev_frn_wq, &frn->work);
 		}
 	}
@@ -4048,7 +4049,8 @@ void mem_cgroup_flush_foreign(struct bdi_writeback *wb)
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


