Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78A66C87FCB
	for <linux-mm@archiver.kernel.org>; Wed,  6 Aug 2025 16:18:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 02D778E0009; Wed,  6 Aug 2025 12:18:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F202C8E0003; Wed,  6 Aug 2025 12:18:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DE7538E0009; Wed,  6 Aug 2025 12:18:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id CE84A8E0003
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 12:18:44 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A0CE758EFD
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 16:18:44 +0000 (UTC)
X-FDA: 83746840968.13.6917FCA
Received: from mail-qk1-f176.google.com (mail-qk1-f176.google.com [209.85.222.176])
	by imf09.hostedemail.com (Postfix) with ESMTP id C9BE4140004
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 16:18:42 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=IZxjelBx;
	spf=pass (imf09.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.222.176 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754497122;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sMTOIN9uA6FtHcEuuMQ+RGlJRjFH2hc2yLEqKn8nGIg=;
	b=kvBTVop4wxbrmjhkc2LeqQ0upapPa/JT1ZuhYYGa1f+5oGt3aiFo8e86ZgKTGCshzL1BmP
	zKhdf3IXEd8dxqFzNHGGKu6E01uTswduGHfw46NevwdHGlnsaWAunLR9zE/40tGk77m3cx
	nvXkMc01IyQLvoQSaNJQH/hDFpQNz8Q=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=IZxjelBx;
	spf=pass (imf09.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.222.176 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754497122; a=rsa-sha256;
	cv=none;
	b=I3NetEWJLRWtryNmDQA+9VrhFh9pkM2DghwR9wfUACcHlIi1sUT5gwgua63KvEWh0SkxMl
	sXTfN/ud/wGb3Yf1EW6jHrPaH03mtnTnNrV8SRhF8B7NjVOFAUiriTvn3b1y2tUiVRmBO3
	g5+Sb1tdGW4C8A0SSKAQs4vwz1daM8M=
Received: by mail-qk1-f176.google.com with SMTP id af79cd13be357-7e638975262so7825385a.0
        for <linux-mm@kvack.org>; Wed, 06 Aug 2025 09:18:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754497121; x=1755101921; darn=kvack.org;
        h=content-transfer-encoding:mime-version:reply-to:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to;
        bh=sMTOIN9uA6FtHcEuuMQ+RGlJRjFH2hc2yLEqKn8nGIg=;
        b=IZxjelBx9Y4siZtXW5jEJD7DWrAqfT+DMGA0CwvR+GXTDovkR92XgmQnZD5aY5Kl6H
         B2wztq9p/x3hROFr/bOfo/SPHN9XfOypJkDqZqAE98m6EMf6mQrB5kWP17JFyl+e871H
         BOot6PyIbIY9qMQOp0/TU9MEokbAphViM7M+SyhfGay2AO/0ifpu3+G50HBWPYEPtrkn
         IawqMLq9xZ2uwDDYl/J+r2V22coKLvV98RIlF8t3tqx04glXJnZ8aBEcUNsXNdaMahTi
         Gy+1R6iG7G0TSG3GXLka8hF73l4ojZTasRDKrim/vhIdaAoQycbfxR9YgU+YRXUxhb+D
         Sidg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754497121; x=1755101921;
        h=content-transfer-encoding:mime-version:reply-to:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=sMTOIN9uA6FtHcEuuMQ+RGlJRjFH2hc2yLEqKn8nGIg=;
        b=F3L7bBOGwGPO17oDUp7m7nZZGdxv8SXhxWHyWyNOijGW6VxCezjbq+RNC3pgu1sRbC
         jvDCw6XVxOA0O4CZxEbn+L4vH3EUIA8shYObSGb4bZ7rj0/gm40vhMtACKkAIQNijCUK
         giWx2ZnW2u6ty+ZJWxurN1dhuMCBpCmDSggkpSNvzf8FjG3cogbWDh7bidoipnkfm8gr
         oUvrgr2JqPsDPA89rJ0fwVI7LsuGJPrtQQ9wOwwUq+Nj6Jh7ILnNxHKjtVUB827pB4ZU
         9a4Vzax7Vwest211fKcQeJK5VhD1J+uNa/JYVVvjYoOFYDG8KUU95xvnXQHwEDFGZVVo
         BiTA==
X-Gm-Message-State: AOJu0YycNAjLjBic5Np/zOw3pVR2oAFF/REj0tvjS/0+IFZ3OlENCgr6
	Wpz0XifZdkWrtsqLlkUQNpePUVWWf3cv5VW7XhYZbMGWIv7ve1RONRdfkVwHZ0CkUfE=
X-Gm-Gg: ASbGncvkjwBiuKhxHa8B9h0tAh405G+g/xZimHpHyt6k1cLuvKMuLbPXp6E09WTvTi2
	7psLN43L/9wGLIJkB7rX6QZzHAcQYmslyPjGKHCWH16zjuGKs+u6tJuu+vsYfTz55K3Ypu8gC3I
	ZBPiev0u0nWO0OlQViElPgT/X5pZxD3pajb+NlNjHWCQso/ks0AIhUgTz0TiNN8SnAzCd95qpkv
	0mUE5ucy0nw3aQ5qsdBeJhR0s/Q7rvc3UcjhVem0DSlQotOXykCK3n4vXWbkz/chpdsXV02FJ4/
	Dg7Mh7SbEwOWzK7VVWh3Mx+7QR5XKfttdxFKpXjAUPqve7jrEwsJvkqLeWq3aw06Alz3Y4R62kR
	hjezXbvOECkKbFvOABuOw7VD53Xg=
X-Google-Smtp-Source: AGHT+IH2ToR5PB3gBgQpmqW6rQV+H4WJbPvMMoHldmsha2gx+ZjR+coMJuG5GMek6CdkUTk9HM3ITA==
X-Received: by 2002:a05:620a:1a1b:b0:7e0:6402:bece with SMTP id af79cd13be357-7e814df809dmr410774185a.38.1754497121240;
        Wed, 06 Aug 2025 09:18:41 -0700 (PDT)
Received: from KASONG-MC4 ([101.32.222.185])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7e7fa35144esm464081885a.48.2025.08.06.09.18.37
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 06 Aug 2025 09:18:40 -0700 (PDT)
From: Kairui Song <ryncsn@gmail.com>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Chris Li <chrisl@kernel.org>,
	Nhat Pham <nphamcs@gmail.com>,
	Baoquan He <bhe@redhat.com>,
	Barry Song <baohua@kernel.org>,
	"Huang, Ying" <ying.huang@linux.alibaba.com>,
	linux-kernel@vger.kernel.org,
	Kairui Song <kasong@tencent.com>
Subject: [PATCH v2 2/3] mm, swap: remove fragment clusters counter
Date: Thu,  7 Aug 2025 00:17:47 +0800
Message-ID: <20250806161748.76651-3-ryncsn@gmail.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250806161748.76651-1-ryncsn@gmail.com>
References: <20250806161748.76651-1-ryncsn@gmail.com>
Reply-To: Kairui Song <kasong@tencent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: drqwgqgf6jc7c5cc444ppqw65fxaebag
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: C9BE4140004
X-Rspam-User: 
X-HE-Tag: 1754497122-444228
X-HE-Meta: U2FsdGVkX18KXft8WOn+jeUwabaVJIwYsqOdXAAc2zx3tZDAFfYcniO5QpNjdx5AefxxjD9L9dnzAZzOK7gWzvVZCJ4002JfRApxgy6L3Vz+AxadzUF/gTnzUSxYYIHrMD4SpBJcY2TrwYDzFZ75bRehP1N4of7RxuTWMOoxpHwGXygL3Uo7jKebBD3IdzGlmJS6pzY/OGGtj/7Bdrkw/X4Zn+xNEhzDKBy2BB1LUNbyl3v/T8YzFOZtUnYl5MFb+xAOmlz3Wh63gxBrkefoen4fEsPA7whWYAnxIZ98RGx8fi0aJE5rwD43USgcLM5jS1bGekrS605O7TLbXq5OLIgwMjxi+0VSst9LwV1osTjWpD3pK6LJWToqTn9Y8lfPER1bUrhcYZxXMkRefIoaBpSy0Jb55Wtmydayk5PodfV5frcCNW2X43okF7NuF+Ns/Doeqx2WUHlyLvZ0pJVu1SH0TIK7L1htNgaTJ0SDktHlC6KhzvfLDXzeqDrkimJDaRk046BEyOysVbSe9dyrEX/NuKx9WihqBRMfRj3vy45m6zu8U6Q6lmkprKWRTSC6D3Y7KbUCStTSy6Al4LqU2cTsJlMZh+aCjML89Cf9P1UQyuHRBokzI78vZ3v5U6UHlw8JmJoW0isuaFuyec+ckcHv8H6Uq7JyqZ1aOJ6vBHqEsdilHxkWiDnY9oBbNbG1l/d72rCvpVe4pepkTkAsRZrQXKqB96s0ZrDJKl8FkXMWG+J2VtskHkebhmhSzAINZwW+AhZCHKD/0rF04LdfYuIZkyaLhIJu8hhX9Lq2h571EDTgkKDwvwj0QDFWSbUqSwWN256s90He5+kO1a3Po2cj/W4LzQ66H5Cg6l6ngvwInOStFdJtjjpGh6FTUOz0cZsVMxPMvlHO2ryfQE+UDYtW70E3BwTJOi68tWWxaUdoB1OdhtHOXBkWsmoAR0wFgOICajAi2mhNHq4BzpJ
 9lQWzJ7F
 DBY3xj0sabJ1DuvAKEr5nkQYfA0P+9r3F06QJhYPC4Xv2cFxZtu66xbFsa8CMhzIS6FHHqdwoUeAHYDCXF2NvCO4Kf+oNNzONRBHvpQ80y1de+zJN8Wo6p4fbwnD+npFPMU9idjbXJ3bB1cR3jipDVCdoUPX3TiZY+dGmdkBxYrEVSOX9J+kjLJmzk7o+hV56i0LFmvAzIDa1ccw86BMUTvB8PZgsOh/+es2Xh1Xc2QMlID9OpAAC+2WH/5vkrAekJcnBTKOId2M8n4hQTu9LNconCvvVK3EdhhcWJDKdNspcAtCOemOSRGg5sc6xsVdl8PF45I8HOgldiBn1/GC6VG6OYG0Y27oysZ6MBB37Nyyv/s9sZLxtfeRa51MHoaR9PaquWc29EdAcKQADT2QBcU8wxrzwz0l+EokAfFzay0ekQgKq4updjWWbkdraWoIryS8SxQx9BY4ztg1Hud7hXeKv8B8UV5NVHcIQeZ4qRook4zSuTsOmqlaZkEnOqril8aTLjhJbukYwc/oC6YwdSstTJFtLdIA6A3u7A04/DBwRtIGoIUYRZ5f42PqxmtmPm2kJRqpYh30XaEg+4KmBHtxHIWjWcUzo1iodMrv3wklgWcj3sFm5leSJAep9ACvZR72N
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

It was used for calculating the iteration number when the swap allocator
wants to scan the whole fragment list. Now the allocator only scans one
fragment cluster at a time, so no one uses this counter anymore.

Remove it as a cleanup; the performance change is marginal:

Build linux kernel using 10G ZRAM, make -j96, defconfig with 2G cgroup
memory limit, on top of tmpfs, 64kB mTHP enabled:

Before:  sys time: 6278.45s
After:   sys time: 6176.34s

Change to 8G ZRAM:

Before:  sys time: 5572.85s
After:   sys time: 5531.49s

Signed-off-by: Kairui Song <kasong@tencent.com>
---
 include/linux/swap.h | 1 -
 mm/swapfile.c        | 7 -------
 2 files changed, 8 deletions(-)

diff --git a/include/linux/swap.h b/include/linux/swap.h
index 2fe6ed2cc3fd..a060d102e0d1 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -310,7 +310,6 @@ struct swap_info_struct {
 					/* list of cluster that contains at least one free slot */
 	struct list_head frag_clusters[SWAP_NR_ORDERS];
 					/* list of cluster that are fragmented or contented */
-	atomic_long_t frag_cluster_nr[SWAP_NR_ORDERS];
 	unsigned int pages;		/* total of usable pages of swap */
 	atomic_long_t inuse_pages;	/* number of those currently in use */
 	struct swap_sequential_cluster *global_cluster; /* Use one global cluster for rotating device */
diff --git a/mm/swapfile.c b/mm/swapfile.c
index 1f1110e37f68..5fdb3cb2b8b7 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -470,11 +470,6 @@ static void move_cluster(struct swap_info_struct *si,
 	else
 		list_move_tail(&ci->list, list);
 	spin_unlock(&si->lock);
-
-	if (ci->flags == CLUSTER_FLAG_FRAG)
-		atomic_long_dec(&si->frag_cluster_nr[ci->order]);
-	else if (new_flags == CLUSTER_FLAG_FRAG)
-		atomic_long_inc(&si->frag_cluster_nr[ci->order]);
 	ci->flags = new_flags;
 }
 
@@ -965,7 +960,6 @@ static unsigned long cluster_alloc_swap_entry(struct swap_info_struct *si, int o
 		 * allocation, but reclaim may drop si->lock and race with another user.
 		 */
 		while ((ci = isolate_lock_cluster(si, &si->frag_clusters[o]))) {
-			atomic_long_dec(&si->frag_cluster_nr[o]);
 			found = alloc_swap_scan_cluster(si, ci, cluster_offset(si, ci),
 							0, usage);
 			if (found)
@@ -3217,7 +3211,6 @@ static struct swap_cluster_info *setup_clusters(struct swap_info_struct *si,
 	for (i = 0; i < SWAP_NR_ORDERS; i++) {
 		INIT_LIST_HEAD(&si->nonfull_clusters[i]);
 		INIT_LIST_HEAD(&si->frag_clusters[i]);
-		atomic_long_set(&si->frag_cluster_nr[i], 0);
 	}
 
 	/*
-- 
2.50.1


