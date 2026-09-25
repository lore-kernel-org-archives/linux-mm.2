Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5E7E2C9830D
	for <linux-mm@archiver.kernel.org>; Fri, 25 Sep 2026 06:45:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B9C636B0093; Fri, 25 Sep 2026 02:45:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B74196B0095; Fri, 25 Sep 2026 02:45:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A8B426B0096; Fri, 25 Sep 2026 02:45:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 703E76B0093
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 02:45:03 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id CDE5B120550
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 06:45:02 +0000 (UTC)
X-FDA: 85251347244.04.D2BE84A
Received: from mail-pz2-f42.google.com (mail-pz2-f42.google.com [74.125.228.42])
	by imf25.hostedemail.com (Postfix) with ESMTP id D07C8A0007
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 06:45:00 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=ZhVf8HZF;
	spf=pass (imf25.hostedemail.com: domain of sunjunchao@bytedance.com designates 74.125.228.42 as permitted sender) smtp.mailfrom=sunjunchao@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790318700;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=46ObzkJeR9Z1Ibx349d8JNyWVlYaD40DttrTljPNkhM=;
	b=H9YW2Qo9nqFj+e+djKLp3uYspWDkwJWXtI5BX8e/kPDCaqGENuvo4UPBsbeRGAi7Yqkv/8
	d0Y4PLqNoA7LFstnIvACNFmOtnK+bTMJYWUWtIhq3C/eTvTvePq7AqCKLHVooMhm6eb/Xa
	VpXfDTRiBUWnKCjcHBdH4FRqKFSdtUA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790318700;
	b=dkISC6osE2KPgA8fFPv7UfWyazZAy0D2ClfL3tbtzRds7pU4QH2Sx8/wLshiAdfPW20eIq
	pCiD/AdLTTvB9NJI1uSMxww0qDlwco2Z3NYxrOZxPeSl3RAqk5bhzQ9ZsT9WgFIOtnlyo7
	bFSmiS4Mk8vvgU1t4AwLLoebM/Sy2MY=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=ZhVf8HZF;
	spf=pass (imf25.hostedemail.com: domain of sunjunchao@bytedance.com designates 74.125.228.42 as permitted sender) smtp.mailfrom=sunjunchao@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
Received: by mail-pz2-f42.google.com with SMTP id 41be03b00d2f7-cc1cea4ae2dso187297a12.3
        for <linux-mm@kvack.org>; Thu, 24 Sep 2026 23:45:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1790318699; x=1790923499; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=46ObzkJeR9Z1Ibx349d8JNyWVlYaD40DttrTljPNkhM=;
        b=ZhVf8HZFkNxmku1a0kX16ohl6367Y4Xrwcj/lpL0K50phwXiLQLudCZLlvh6SJUPl7
         q/tu6I9C0jnhisYMYmwZLoEP9JoeFkUkPxHjOREZDYIHpsTccbhnTQWavSNeBM5mYn/P
         6Auk/0oBtvagjW3W5+pcgoaaD4O+OthullN7rMcLrDlvTt04VsMxtk4SGhCjQAcGKWUM
         Oi/dJme59OHELnJt8AniafqAxz0GLalkP5vPsg5w7PR7Sdok++EOfAum8F4JazsrGIEb
         ZPTR0kuofytiQpY//3HfqCpPrw/giHtFcANvYV+ri1xxUAQBJkz57u+ApFoIRRrauZ9b
         wE5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790318700; x=1790923500;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=46ObzkJeR9Z1Ibx349d8JNyWVlYaD40DttrTljPNkhM=;
        b=tpI5B0PSKRexHj06pVfj85YJSfQ6mSVXctFWowcRQZ16WogeEITxSjb56K6nrSyNBw
         fYY7fzGzSk51uXGF1wIJf2wmk/SEqfZq36mLN0rLbpcBdyXCYn+so9tgU+xCcrDwTEKC
         zDPOb1ZCII5ItYuy3BBXvRInVZJ+T/qDfOFBtQzvgI5VOyl4u/rAccGQWvic6UAcUEwD
         +VHg+6qCny1+zEy95mrXxKnypHD69ya+enMZowayQQPySgX0q8Z6q1lIHUGSFfmZlTGU
         gF0uVkQcYc50nFF9ladEYzU7Ync61HTFobBN5PL2sNbryoxxmo/rGMHH2yZwomwhiyTH
         xWlA==
X-Forwarded-Encrypted: i=1; AKwUvBxHpxqOIlLuAmfWhvKRt6vatjhe0uVvKgij+i0aSIvf6dkIcmUjT0CzGoiovCv7gkrhqX33+UAP1Q==@kvack.org
X-Gm-Message-State: AFuF++mEumcNdaC0Wwk7TGDt6vGgMIil/DtNDU0o23vmLBYZb8MtDltA
	APRH75m0ImCgfWu740vNfDPTX2o9KbBE5ProdgCJWlvZwu3NnRfeazG7Q2mf4cROJZc=
X-Gm-Gg: AYBFou369HjZlozdTHjK8UgJADAeIdRdRvGkXLsDHNK/bRp7bbvyPAFlwkDb/4JiUZW
	y5WsMxKkV3AlvrMl26x4QmVaKQZb+R2knNM0dJ3jCg1R5III83Wh/OWgOh4khajarCW0j8MWdlF
	91NxmPsGBUOJow0vvjH6YHWvtn2TBByRMPZqIcq/lbF19EkJu/IYvE8Fi+b8NysmqBCKXL6MhR1
	EbSmhHZFxjT2iA2uzuar49QYTZlEsZglpd3tfhJdj7UxXGTHC59FQ04D9MCi+plnV+PfialDOq6
	eeBrJXlnQgcdobkdW0Fodd2OMXr/3qtzbQFwAMJuNrPmWH6bX97bwJ/uG0doH0E0C60HlPJfmRp
	k4B6Bq5b9j8ThyW/I9UtfpmnxXwyRwxCfXrHqiIgUCeEiOBpiH3j1fCQAHf3SThGAjD9bXHtY0Q
	EkfGHjCWhhH4MPFiOoJZ/mciZVkNj65dii2uIA4CT2KYAMzRTBjk01Rfo1qlr9ppY8rHqyPGnFR
	C8=
X-Received: by 2002:a17:90a:c08:b0:3a0:b3f3:a2df with SMTP id 98e67ed59e1d1-3a0b3f3a396mr1192901a91.13.1790318699459;
        Thu, 24 Sep 2026 23:44:59 -0700 (PDT)
Received: from localhost ([106.38.226.222])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a0b8efb156sm2776224a91.1.2026.09.24.23.44.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Sep 2026 23:44:59 -0700 (PDT)
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
Subject: [PATCH v9 3/3] writeback: add tracepoints for foreign bdev writeback
Date: Fri, 25 Sep 2026 14:44:44 +0800
Message-Id: <20260925064444.3944820-4-sunjunchao@bytedance.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20260925064444.3944820-1-sunjunchao@bytedance.com>
References: <20260925064444.3944820-1-sunjunchao@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: j6n9dtfwdt4habtussu7y7pcrd9ipfd8
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: D07C8A0007
X-HE-Tag: 1790318700-37800
X-HE-Meta: U2FsdGVkX1+q6R9zVPx1eDEtDjJ9yFQU5t7YRIELJmCIYKq7A88D8SvJwFWtLfBNUQKKBO5sMMDtnpWh+a7o4ywHLMNkSmIXcUVhstqdUizCkB+5shtY4CvkDdNJufuHTFN0+Zg6Yj/LL3A4Ty9a3nhJbZVr73TfzMGCPz40f+CaK0Fyy8GI2W4B/K/svj2pJAxoEUQAKpxV1qMWu0j5NQ7ntg2yipvjoo55z+a6X3o0cNWRZn5JAQk6BxwvhFOBpftMAKp18hPR3z5kIrhb6eyCNDcbt+JXx6A41Y4krmsDvH2LM088y23NM5l8Aqc2pZqe5VaogiPxXhZa+6AD91tHQGhbwooezts8OZ3HuVWkVVwTQp5TKiFDDy+1gH8WLx2TZEcfh0wpAwl2d2ZOoYMrGRmZtRZumka5QisbkYO8Yu2MMvuDLbvGo0zVsYlQOI/bb7dk70gx/VnN5EDooKQV/956/aPgaQiCSYjjYOVYt5I3au+XF9j0Wu/MC4PReEzYy/7OlghJimH9sqt9wEhQ1/W05eLJoPmlgunSDWkjsG6rOHhopVlAp+og6/idVIWJ9OUarBBpVgPGq+9QndKUumy5XiUa4XzSOUWy5oW6L17jgQOs2Gp1uDpWTT9JL6TjwhLpRjBVpdHw8n1z93ASXOLAbZDwjUnZwU0ZEDP3kl4ZKm65/1MBd5pqdDl7FcCt2qPpKJ97Uqh5Hjxg205wuEFK3Tc84c7BVnUqp67iIF6jkribGwp/pvJ5nw45GgrEgUDkRGltFhdrwuA3M71TwI1H6Lf5oAP9n1d1zZARNzAaTkUNvV9W2FgByVIjxZf+sv5azz/AzpyvbZFjx21POUo/Ztk0v5QZ2GPWVzwpgntjhsPIFEQACYSFzkDxwmzAa/SgUZpPI9c8bBf7TmAx/BDeM/xwxO2w2YH6lnJXRPfeIl9XN0HJWvhNTFxsKiznbou+n4iSvys/4Ks
 FPJjhUHt
 1OtF8CTqrgOglLKpzZ9j6viQizuW9Rw72lzqGlIJ7lF2PzuxODRQK6ZJ76XHoOov8+ziYjk7e0MRbVojnYO02Wg9m2Kvhc1v3NbrhYN18eqY1I3kLNj9HbsW8Ekmag2+xFWSp4dzNsu7v44jbyLWrdBgOhaR7V3u2rpzbbuy/pXZiMBgHC6yPH9QBjtQF1SoMGkRdvPD0Tws37n7jirUheVs1momsYyYpAQ2hs9go10FvWcxUrRfrT7pUa9cp4rE1ElMlj7pTFWUcHQ1s1HyomUxFPntC2jxcu6s3FEqYy6FWv7Z1yKhZtGG+w6MpFEPskbb5c/FTQcaLQcqmpLJyyb3FLYqD4dYYcTWbVD9L/KzWxdk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add track_foreign_bdev_dirty and flush_foreign_bdev to trace foreign
bdev dirty tracking and flush requests separately from the existing
foreign-wb path. Record the target device number as major:minor while
leaving the existing tracepoint interfaces unchanged.

Signed-off-by: Julian Sun <sunjunchao@bytedance.com>
---
 include/trace/events/writeback.h | 67 ++++++++++++++++++++++++++++++++
 mm/memcontrol.c                  |  3 +-
 2 files changed, 69 insertions(+), 1 deletion(-)

diff --git a/include/trace/events/writeback.h b/include/trace/events/writeback.h
index 13ee076ccd16..4a85883fb8a0 100644
--- a/include/trace/events/writeback.h
+++ b/include/trace/events/writeback.h
@@ -339,6 +339,73 @@ TRACE_EVENT(flush_foreign,
 		__entry->frn_memcg_id
 	)
 );
+
+TRACE_EVENT(track_foreign_bdev_dirty,
+
+	TP_PROTO(struct folio *folio, struct bdi_writeback *wb, dev_t dev),
+
+	TP_ARGS(folio, wb, dev),
+
+	TP_STRUCT__entry(
+		__array(char,		name, 32)
+		__field(u64,		bdi_id)
+		__field(u64,		ino)
+		__field(u64,		cgroup_ino)
+		__field(u64,		page_cgroup_ino)
+		__field(unsigned int,	memcg_id)
+		__field(dev_t,		dev)
+	),
+
+	TP_fast_assign(
+		struct inode *inode = folio_mapping(folio)->host;
+
+		strscpy_pad(__entry->name, bdi_dev_name(wb->bdi), 32);
+		__entry->bdi_id		= wb->bdi->id;
+		__entry->ino		= inode->i_ino;
+		__entry->memcg_id	= wb->memcg_css->id;
+		__entry->cgroup_ino	= __trace_wb_assign_cgroup(wb);
+		__entry->dev		= dev;
+
+		rcu_read_lock();
+		__entry->page_cgroup_ino = cgroup_ino(folio_memcg(folio)->css.cgroup);
+		rcu_read_unlock();
+	),
+
+	TP_printk("bdi %s[%llu]: ino=%llu memcg_id=%u cgroup_ino=%llu page_cgroup_ino=%llu dev=%u:%u",
+		__entry->name,
+		__entry->bdi_id,
+		__entry->ino,
+		__entry->memcg_id,
+		__entry->cgroup_ino,
+		__entry->page_cgroup_ino,
+		MAJOR(__entry->dev), MINOR(__entry->dev)
+	)
+);
+
+TRACE_EVENT(flush_foreign_bdev,
+
+	TP_PROTO(struct bdi_writeback *wb, dev_t dev),
+
+	TP_ARGS(wb, dev),
+
+	TP_STRUCT__entry(
+		__array(char,		name, 32)
+		__field(u64,		cgroup_ino)
+		__field(dev_t,		dev)
+	),
+
+	TP_fast_assign(
+		strscpy_pad(__entry->name, bdi_dev_name(wb->bdi), 32);
+		__entry->cgroup_ino	= __trace_wb_assign_cgroup(wb);
+		__entry->dev		= dev;
+	),
+
+	TP_printk("bdi %s: cgroup_ino=%llu dev=%u:%u",
+		__entry->name,
+		__entry->cgroup_ino,
+		MAJOR(__entry->dev), MINOR(__entry->dev)
+	)
+);
 #endif
 
 DECLARE_EVENT_CLASS(writeback_write_inode_template,
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 74677078f9b4..0108b4177833 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -3965,7 +3965,7 @@ void mem_cgroup_track_foreign_dirty_slowpath(struct folio *folio,
 	struct inode *inode = mapping->host;
 
 	if (memcg_bdev_frn_wq && sb_is_blkdev_sb(inode->i_sb)) {
-		trace_track_foreign_dirty(folio, wb);
+		trace_track_foreign_bdev_dirty(folio, wb, inode->i_rdev);
 		mem_cgroup_track_foreign_bdev(memcg, inode->i_rdev);
 		return;
 	}
@@ -4041,6 +4041,7 @@ void mem_cgroup_flush_foreign(struct bdi_writeback *wb)
 			 * the timestamp for a later flush.
 			 */
 			frn->at = 0;
+			trace_flush_foreign_bdev(wb, frn->dev);
 			queue_work(memcg_bdev_frn_wq, &frn->work);
 		}
 	}
-- 
2.39.5


