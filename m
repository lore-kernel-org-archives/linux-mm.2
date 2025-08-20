Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD997CA0EDC
	for <linux-mm@archiver.kernel.org>; Wed, 20 Aug 2025 11:19:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 81DBB8E005D; Wed, 20 Aug 2025 07:19:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7CDBD8E0003; Wed, 20 Aug 2025 07:19:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 66F7C8E005D; Wed, 20 Aug 2025 07:19:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4E3078E0003
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 07:19:58 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 119CC140437
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 11:19:58 +0000 (UTC)
X-FDA: 83796891276.23.76F8C11
Received: from mail-pg1-f174.google.com (mail-pg1-f174.google.com [209.85.215.174])
	by imf13.hostedemail.com (Postfix) with ESMTP id 2D11820007
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 11:19:55 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=XtPKcn1m;
	spf=pass (imf13.hostedemail.com: domain of sunjunchao@bytedance.com designates 209.85.215.174 as permitted sender) smtp.mailfrom=sunjunchao@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755688796;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=H0sra2AN3siCOY/j4YATSW1j6v/rnanIT2GxrMhLaB8=;
	b=ni+BMLbEfTb71oHaU4f53x2w5klgmPF/zR3mmy2viydMPIKihkDvwh8g4+p5NphnrANQL9
	sAeogTXhEELoQSuLkw2lQ+qviGrBD0AXJVpY5dAyI+hhN/4YKwnii3AttsmmoNHjXH88HK
	l3OLUr014WlpntSXt/JmhGt1O1OpSho=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=XtPKcn1m;
	spf=pass (imf13.hostedemail.com: domain of sunjunchao@bytedance.com designates 209.85.215.174 as permitted sender) smtp.mailfrom=sunjunchao@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755688796; a=rsa-sha256;
	cv=none;
	b=UOcBmFoNMIRbSalCdNdAwLBTbrHhLQa17zp6ritVSB7NAcdOAiCN2HUDj++DEQJzfEClAx
	dEPYbOSUCycX8mFe7/JyN3mq3z3AHt7+K6qwRErgovhlU72DZVQGN4qOaaqDQGS55o0HF3
	WibimTZUcbcz/sEel0PyPzOqFXDajcI=
Received: by mail-pg1-f174.google.com with SMTP id 41be03b00d2f7-b47174beccfso5343164a12.2
        for <linux-mm@kvack.org>; Wed, 20 Aug 2025 04:19:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1755688795; x=1756293595; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=H0sra2AN3siCOY/j4YATSW1j6v/rnanIT2GxrMhLaB8=;
        b=XtPKcn1mp4W4eIdEtpILkoorAzVFTCVTq2H7rjXkmHYFVIWqE/GAqm2Fsx+STtlyYr
         mN4xegN/AqgveWgH2gLYxh6ZISHABaWKVJJfeXhQiPi4rMTkRpQrbkmAD19Ee2nbSDf6
         L0JXwGbthH0VfNppAkVmID6N7TUwZ9eES2cucnUmQpth9zmvYse6mgoelNM82e7Wkl6H
         tTYn58y2GUW34drO/03s8Sp9jTCvyOv8rnVMndwjgWvZW3lH4cKddZQ7qAptDMKrEdQp
         bW/w4s/F33EzJ1vSu1Mh5Ah/C67/cbBMmEz9UXGERXOvRA+Jf/kElMRTlT9ghl+PIojE
         +l4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755688795; x=1756293595;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=H0sra2AN3siCOY/j4YATSW1j6v/rnanIT2GxrMhLaB8=;
        b=Z8AxDzuW8VsoEv9RMUvGcMcbkoPaNti5/Yriu43MK0LNvGXULDW4BPkneFpFP26ILy
         75KEg0r/5fwb7ldTGeoeaO+NUCtuXaFX9NYoRAsBxfVRGHXD+BTm8rsSmXdkB+zHiCvz
         IwIQMOcxZnQnvvTYaNH6oRQdgyhhzLy2Hb9ILK1cYHjIwPmPMIne4zzmCTw1gJj2KvX2
         JNIHlccntWCFNA+4KgkJ1zmBa+P2u3wFExR1Dku4yLJqP752EAdKaqmiYW+mtJ7oiPFQ
         s5acotojG/SUc16GHWB61D1Bm9I+pW2n7JC+Kd8n+UU31g+QeLftghHfu3VyZgYEGYi+
         l+xg==
X-Forwarded-Encrypted: i=1; AJvYcCWTVlXRp5spHHCVjZbWns4s8OnmM34ha05edRGL/OFeJ+yaEq4xIFMgujG0oDruKxzA4IakZoE/EQ==@kvack.org
X-Gm-Message-State: AOJu0YxIsuTsAXI8Pia2izg0VGqeckaSIGLdxiUSyXVXB8RlAHty5nOA
	1WCPy7tkQVMZgg6MiDUbqambJ3XjGFKOXYksUx/0oc2ue566mIKiDsuDAUTiGSVQob8=
X-Gm-Gg: ASbGncu/tjtoTZq5peN6baL5ZqQv5T669TDgL4ugeIawOf2PgiGjCO/lh9rn5IQrOHw
	CYHaUTRdv7A40AitnPNdvyrTlxJpesVWzJXNOaaRsE5sqtuA4u358CEQz/UbyrFHnIWY9EEl8jU
	vxLCsk38eoLuLLjFbBLwI/iA2qoXpkDXLc4Gcwn/7wR1p1IgBlXTqJAbVOvko9Jg92qYJyjT4Hs
	omxtW8ufI0h9f0g7qDN9gpAZ7KTRD9eOZncCP90uM7gGYsSI8lLakjAkUmZbueR/s/o/kn31A6N
	nnF8yQc55PAwMJBHl7GH+RQ5la93FOQgA+oxDvAb1Ic2yML2+ZgvHtzPonGcu09vcKYJ91/X5r8
	qkENia2vnNllzuGqSENLm/6xeA+awsMI=
X-Google-Smtp-Source: AGHT+IFElDAZuo1wYAZ9DSpXz5PMAnw229u8a3n2AOhgQWMMLXXcL79GdXnqls6Uh8xCnu+cW2L85w==
X-Received: by 2002:a17:903:248:b0:235:15f3:ef16 with SMTP id d9443c01a7336-245ef11112amr30391975ad.13.1755688794886;
        Wed, 20 Aug 2025 04:19:54 -0700 (PDT)
Received: from localhost ([106.38.226.128])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-245ed33a76asm24187645ad.32.2025.08.20.04.19.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Aug 2025 04:19:54 -0700 (PDT)
From: Julian Sun <sunjunchao@bytedance.com>
To: linux-fsdevel@vger.kernel.org,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org
Cc: viro@zeniv.linux.org.uk,
	brauner@kernel.org,
	jack@suse.cz,
	hannes@cmpxchg.org,
	mhocko@kernel.org,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	muchun.song@linux.dev,
	axboe@kernel.dk,
	tj@kernel.org
Subject: [PATCH] memcg: Don't wait writeback completion when release memcg.
Date: Wed, 20 Aug 2025 19:19:40 +0800
Message-Id: <20250820111940.4105766-4-sunjunchao@bytedance.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20250820111940.4105766-1-sunjunchao@bytedance.com>
References: <20250820111940.4105766-1-sunjunchao@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 2D11820007
X-Stat-Signature: nbiyrkajkhu9d5xd5wkc7onf7jd6d493
X-Rspam-User: 
X-HE-Tag: 1755688795-190226
X-HE-Meta: U2FsdGVkX18CYQapsKKAlHDDUVn27nRfvk5PElJdGcKoaQ9JcOWDWC/EIi31pNKcrAP99bputCkl/qWgBTCZ/OfGdTtpN3GsFUDpm8WLvLjwhhkt9FdeZqSuB9zCYwnGZcSgv1A6sVm/ITpvxGI2gW5jzeOMhqyy8UqhSJH80HR3ONbVsgrg2qBDUw+QQSBPxIherGVnWrlC76aYb5SoiceMO8f6o6nzA1h0p5GzPSP9tynT4a0P2W7Dn4Ujl4qai1Uw9S7wvF/HZJTB1ewoCQHthZyfGdBwVhebyD33gun0IP/42fIBhyLChMaMxUQn3PknSQJe8D172B8thAyx2IhgDKDrHRZPQWBNZZDJpdM7gtP0/WifYCjju1MWJva9Yt4b9wUyj8eorW44Y34Da9JfkLnF4DxoMGdPAMkUgaEWrgV/C8kEkg/Q71mJQpDnE8KyT9poc9YGO90A/epsnLJsLQypg2yqreT9rMTa+4UAriq70keW1ynFF6yLgCfQWhVvIc7AAB9w+SBcfvEtjBo4qK3dkovbdGf2ohl2Ns+fSVA/Lo/xkO17KskabLS0WHkt9quyk8quBc3hixEVUvGPh0K1tRcf/to92QV4D9BYf4hChEbFQOtZOzhJnOehun+ROHd1JuoatqpEwu2H7w3hbxvEDyt+dNXEKrdNiehJnJnawMXR4NxSxC9w3WscSgTcQG4lgVMA+hRHVzp4SHyvkje4uRy3jloqUkU2SAcN1IhtCUKyG/8O9/MdQtxPMdA1EdTQYQz3CDv+VbZbBBkXEdCC6IYV6h0SGT9dnHWpwaFrFvTKY/YI57P1fTSmpoS99CRWMS5IdnF2qyJ9tREnNgfunLbEU+l7WySNJd6B2TX/Qk/T7u5sObdkT07AjpqG1CJc1/mXQy9f1CyH6EcAl0SzhGdPA2+RbM4CduKCK/1UEremXp2u3sC1m7fwxr/KMY1ZJnRFEuQfJ5u
 mRk4h+8q
 f83Bw01J8selJAIIYPkpxgCF2P4Jkm+J4rxqFiQ0X4VJRk4asAXCXZ61C4sNbfbZ2o5v53gwh3QGLYTqlUdZr755vsLlZbJxF1/1SryqKssz/IO3vfXhvUrACkk469uxsmUQzETxQjvxYSzgb0lVr6tTSjXtalrybcQHfgQ8YMIhCdT43IaRT56npWEhecJkJtAbsWMwcwhPWxMy84rkK+Dmx7i5tHFCJCqXvKePpsGemEdeMXX0culBIhpnNWE106AJrn1/joC3SpcM1GxktNi71OhPZX0bk16E0e9BCGWV9mO/2vC2+x18Ud27WvP6kfka9
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Recently, we encountered the following hung task:

INFO: task kworker/4:1:1334558 blocked for more than 1720 seconds.
[Wed Jul 30 17:47:45 2025] Workqueue: cgroup_destroy css_free_rwork_fn
[Wed Jul 30 17:47:45 2025] Call Trace:
[Wed Jul 30 17:47:45 2025]  __schedule+0x934/0xe10
[Wed Jul 30 17:47:45 2025]  ? complete+0x3b/0x50
[Wed Jul 30 17:47:45 2025]  ? _cond_resched+0x15/0x30
[Wed Jul 30 17:47:45 2025]  schedule+0x40/0xb0
[Wed Jul 30 17:47:45 2025]  wb_wait_for_completion+0x52/0x80
[Wed Jul 30 17:47:45 2025]  ? finish_wait+0x80/0x80
[Wed Jul 30 17:47:45 2025]  mem_cgroup_css_free+0x22/0x1b0
[Wed Jul 30 17:47:45 2025]  css_free_rwork_fn+0x42/0x380
[Wed Jul 30 17:47:45 2025]  process_one_work+0x1a2/0x360
[Wed Jul 30 17:47:45 2025]  worker_thread+0x30/0x390
[Wed Jul 30 17:47:45 2025]  ? create_worker+0x1a0/0x1a0
[Wed Jul 30 17:47:45 2025]  kthread+0x110/0x130
[Wed Jul 30 17:47:45 2025]  ? __kthread_cancel_work+0x40/0x40
[Wed Jul 30 17:47:45 2025]  ret_from_fork+0x1f/0x30

The direct cause is that memcg spends a long time waiting for dirty page
writeback of foreign memcgs during release.

The root causes are:
    a. The wb may have multiple writeback tasks, containing hundreds of
       thousands of dirty pages, as shown below:

>>> for work in list_for_each_entry("struct wb_writeback_work", \
				    wb.work_list.address_of_(), "list"):
...     print(work.nr_pages, work.reason, hex(work))
...
900628  WB_REASON_FOREIGN_FLUSH 0xffff969e8d956b40
1116521 WB_REASON_FOREIGN_FLUSH 0xffff9698332a9540
1275228 WB_REASON_FOREIGN_FLUSH 0xffff969d9b444bc0
1099673 WB_REASON_FOREIGN_FLUSH 0xffff969f0954d6c0
1351522 WB_REASON_FOREIGN_FLUSH 0xffff969e76713340
2567437 WB_REASON_FOREIGN_FLUSH 0xffff9694ae208400
2954033 WB_REASON_FOREIGN_FLUSH 0xffff96a22d62cbc0
3008860 WB_REASON_FOREIGN_FLUSH 0xffff969eee8ce3c0
3337932 WB_REASON_FOREIGN_FLUSH 0xffff9695b45156c0
3348916 WB_REASON_FOREIGN_FLUSH 0xffff96a22c7a4f40
3345363 WB_REASON_FOREIGN_FLUSH 0xffff969e5d872800
3333581 WB_REASON_FOREIGN_FLUSH 0xffff969efd0f4600
3382225 WB_REASON_FOREIGN_FLUSH 0xffff969e770edcc0
3418770 WB_REASON_FOREIGN_FLUSH 0xffff96a252ceea40
3387648 WB_REASON_FOREIGN_FLUSH 0xffff96a3bda86340
3385420 WB_REASON_FOREIGN_FLUSH 0xffff969efc6eb280
3418730 WB_REASON_FOREIGN_FLUSH 0xffff96a348ab1040
3426155 WB_REASON_FOREIGN_FLUSH 0xffff969d90beac00
3397995 WB_REASON_FOREIGN_FLUSH 0xffff96a2d7288800
3293095 WB_REASON_FOREIGN_FLUSH 0xffff969dab423240
3293595 WB_REASON_FOREIGN_FLUSH 0xffff969c765ff400
3199511 WB_REASON_FOREIGN_FLUSH 0xffff969a72d5e680
3085016 WB_REASON_FOREIGN_FLUSH 0xffff969f0455e000
3035712 WB_REASON_FOREIGN_FLUSH 0xffff969d9bbf4b00

    b. The writeback might severely throttled by wbt, with a speed
       possibly less than 100kb/s, leading to a very long writeback time.

>>> wb.write_bandwidth
(unsigned long)24
>>> wb.write_bandwidth
(unsigned long)13

The wb_wait_for_completion() here is probably only used to prevent
use-after-free. Therefore, we manage 'done' separately and automatically
free this memory in finish_writeback_work().

This allows us to remove wb_wait_for_completion() while preventing
the use-after-free issue.

Fixes: 97b27821b485 ("writeback, memcg: Implement foreign dirty flushing")
Signed-off-by: Julian Sun <sunjunchao@bytedance.com>
---
 fs/fs-writeback.c                |  1 +
 include/linux/backing-dev-defs.h |  6 ++++++
 include/linux/memcontrol.h       |  2 +-
 mm/memcontrol.c                  | 31 ++++++++++++++++++++++---------
 4 files changed, 30 insertions(+), 10 deletions(-)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index 56faf5c3d064..fac3ef7e95ae 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -1136,6 +1136,7 @@ int cgroup_writeback_by_id(u64 bdi_id, int memcg_id,
 		work->reason = reason;
 		work->done = done;
 		work->free_work = 1;
+		work->free_done = 1;
 		wb_queue_work(wb, work);
 		ret = 0;
 	} else {
diff --git a/include/linux/backing-dev-defs.h b/include/linux/backing-dev-defs.h
index 2ad261082bba..bf28dd9a4783 100644
--- a/include/linux/backing-dev-defs.h
+++ b/include/linux/backing-dev-defs.h
@@ -208,6 +208,12 @@ struct wb_lock_cookie {
 	unsigned long flags;
 };
 
+static inline void wb_completion_init(struct wb_completion *done, struct wait_queue_head *waitq)
+{
+	atomic_set(&done->cnt, 1);
+	done->waitq = waitq;
+}
+
 #ifdef CONFIG_CGROUP_WRITEBACK
 
 /**
diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 785173aa0739..80a6bafbb24a 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -161,7 +161,7 @@ struct memcg_cgwb_frn {
 	u64 bdi_id;			/* bdi->id of the foreign inode */
 	int memcg_id;			/* memcg->css.id of foreign inode */
 	u64 at;				/* jiffies_64 at the time of dirtying */
-	struct wb_completion done;	/* tracks in-flight foreign writebacks */
+	struct wb_completion *done;	/* tracks in-flight foreign writebacks */
 };
 
 /*
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 8dd7fbed5a94..6e6a1ce7589a 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -3459,7 +3459,7 @@ void mem_cgroup_track_foreign_dirty_slowpath(struct folio *folio,
 		    frn->memcg_id == wb->memcg_css->id)
 			break;
 		if (time_before64(frn->at, oldest_at) &&
-		    atomic_read(&frn->done.cnt) == 1) {
+		    atomic_read(&frn->done->cnt) == 1) {
 			oldest = i;
 			oldest_at = frn->at;
 		}
@@ -3506,12 +3506,12 @@ void mem_cgroup_flush_foreign(struct bdi_writeback *wb)
 		 * already one in flight.
 		 */
 		if (time_after64(frn->at, now - intv) &&
-		    atomic_read(&frn->done.cnt) == 1) {
+		    atomic_read(&frn->done->cnt) == 1) {
 			frn->at = 0;
 			trace_flush_foreign(wb, frn->bdi_id, frn->memcg_id);
 			cgroup_writeback_by_id(frn->bdi_id, frn->memcg_id,
 					       WB_REASON_FOREIGN_FLUSH,
-					       &frn->done);
+					       frn->done);
 		}
 	}
 }
@@ -3708,7 +3708,7 @@ static struct mem_cgroup *mem_cgroup_alloc(struct mem_cgroup *parent)
 	struct memcg_vmstats_percpu __percpu *pstatc_pcpu;
 	struct mem_cgroup *memcg;
 	int node, cpu;
-	int __maybe_unused i;
+	int __maybe_unused i = 0;
 	long error;
 
 	memcg = kmem_cache_zalloc(memcg_cachep, GFP_KERNEL);
@@ -3763,9 +3763,14 @@ static struct mem_cgroup *mem_cgroup_alloc(struct mem_cgroup *parent)
 	INIT_LIST_HEAD(&memcg->objcg_list);
 #ifdef CONFIG_CGROUP_WRITEBACK
 	INIT_LIST_HEAD(&memcg->cgwb_list);
-	for (i = 0; i < MEMCG_CGWB_FRN_CNT; i++)
-		memcg->cgwb_frn[i].done =
-			__WB_COMPLETION_INIT(&memcg_cgwb_frn_waitq);
+	for (i = 0; i < MEMCG_CGWB_FRN_CNT; i++) {
+		struct memcg_cgwb_frn *frn = &memcg->cgwb_frn[i];
+
+		frn->done = kmalloc(sizeof(struct wb_completion), GFP_KERNEL);
+		if (!frn->done)
+			goto fail;
+		wb_completion_init(frn->done, &memcg_cgwb_frn_waitq);
+	}
 #endif
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 	spin_lock_init(&memcg->deferred_split_queue.split_queue_lock);
@@ -3775,6 +3780,10 @@ static struct mem_cgroup *mem_cgroup_alloc(struct mem_cgroup *parent)
 	lru_gen_init_memcg(memcg);
 	return memcg;
 fail:
+#ifdef CONFIG_CGROUP_WRITEBACK
+	while (i--)
+		kfree(memcg->cgwb_frn[i].done);
+#endif
 	mem_cgroup_id_remove(memcg);
 	__mem_cgroup_free(memcg);
 	return ERR_PTR(error);
@@ -3912,8 +3921,12 @@ static void mem_cgroup_css_free(struct cgroup_subsys_state *css)
 	int __maybe_unused i;
 
 #ifdef CONFIG_CGROUP_WRITEBACK
-	for (i = 0; i < MEMCG_CGWB_FRN_CNT; i++)
-		wb_wait_for_completion(&memcg->cgwb_frn[i].done);
+	for (i = 0; i < MEMCG_CGWB_FRN_CNT; i++) {
+		struct wb_completion *done = memcg->cgwb_frn[i].done;
+
+		if (atomic_dec_and_test(&done->cnt))
+			kfree(done);
+	}
 #endif
 	if (cgroup_subsys_on_dfl(memory_cgrp_subsys) && !cgroup_memory_nosocket)
 		static_branch_dec(&memcg_sockets_enabled_key);
-- 
2.20.1


