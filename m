Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 348F9CAC5B0
	for <linux-mm@archiver.kernel.org>; Tue, 23 Sep 2025 09:17:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 923788E001A; Tue, 23 Sep 2025 05:17:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8D3C88E0001; Tue, 23 Sep 2025 05:17:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7C3148E001A; Tue, 23 Sep 2025 05:17:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 65F1A8E0001
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 05:17:23 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 28F3F140429
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 09:17:23 +0000 (UTC)
X-FDA: 83919961566.21.DDC47E4
Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	by imf15.hostedemail.com (Postfix) with ESMTP id 66C2EA0006
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 09:17:21 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=SqhJpHS2;
	spf=pass (imf15.hostedemail.com: domain of zhengqi.arch@bytedance.com designates 209.85.210.169 as permitted sender) smtp.mailfrom=zhengqi.arch@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758619041;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fsqflaZCptn+OqUf7yzOdIjdD2+Qx392fdtpQO1y/sE=;
	b=CNXiDdt9SvGDPvcBDz/JqsfC+cdEVtkasn6/8xhzpdgiKW2EM/mU6A5snuLsRKfZ/G6k+b
	Fen/Fdh/une+IApHygmK/K1i77SZnbVjOPH9MEyFxof4heTQXRCKB0O/J6sbBWGdTmbNd7
	cCIwqpq2RivlxWDe2JrGnZ4eIrLud40=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=SqhJpHS2;
	spf=pass (imf15.hostedemail.com: domain of zhengqi.arch@bytedance.com designates 209.85.210.169 as permitted sender) smtp.mailfrom=zhengqi.arch@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758619041; a=rsa-sha256;
	cv=none;
	b=2N0u9HGg+qjhCyM8l0Mo+H5M1DcH8t6VGVnCIV9hKWVUZdn0BtuRMdXQ8/tKzEFJfDMDFy
	xbxWm+zWJ5minFeYMZFqTXfPUxChrmHIFee+DZNlzt7929nHXVqGgP77x7yqn7s/6TgXDJ
	xbf2f+3M5LM+7Pz0IaxWcLoaf938H1A=
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-76e4fc419a9so5343101b3a.0
        for <linux-mm@kvack.org>; Tue, 23 Sep 2025 02:17:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1758619040; x=1759223840; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fsqflaZCptn+OqUf7yzOdIjdD2+Qx392fdtpQO1y/sE=;
        b=SqhJpHS2RJMt49iUgPEQWPWfnySGxpQm98ED8+8ufufXJhZSDh3TqZurYRF5StR2/p
         vJCL2NIFXeI/tcVxllSTDCecF+EVgdPd6s2phtvF1KGz9OkxcYYQdm7uQl/WGFXKo9WH
         w0lh61Z6KaZcpNJuxNtx2CVDNkuGI8+S27JLBd2nVY/4FzhAwopyTx9pKYhH3c98LEou
         misqSErdH9oj86ZGoIOfb11ajJ6Hbxspd+uL9iDujO9uyTXkPQR28HGuaQ9F2rrHMIkL
         WAotxWpyti0knF/LbpzJfluhQOOab7tYj+F6hdTRKA4KQPxarNPI3dezrXDwLE32P8uI
         iK2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758619040; x=1759223840;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fsqflaZCptn+OqUf7yzOdIjdD2+Qx392fdtpQO1y/sE=;
        b=pJb5sEIRoM25IXAtQmw9A5FC2WfsZLPh+B9g7wdjhIs0eUksdAnmjeMzqyUqGavLQ1
         ovs8cMTOjl1VBmw/gxV2zQODkFwS+BXGeWRggPAJNG6rw5p30n6gfYs+KxZMMPvrmwP+
         I03LAnBgpi7gOsqKYCIb3NdR/5sxjmwITKlhf5gOhImmatv9Fm5EvhZnBvCUEeXefJeG
         PS7cGNlFIjGYoWkxAcE4rAFBCs6felRBCRzx/Ln+0y6wNdcAg61DgmFJtjZZjiNb1Qzv
         JqOhOcq9DBANo8XJzIlYVpEv4LglwN3zTVvBP+GBA9uweYEU0HOnwgaMgX0uVOZDrH0d
         Y6EQ==
X-Gm-Message-State: AOJu0YwnZ3/y2+FJoOV4v29pAwgKJ8jCT8t3tWbCaIu968o6BWVZAzeH
	T5sFaWV5C41WrCmLVQKIcoHGx4MnIXchnI79J3MvVR94mEIP/7+oGI5xIL8tYnAE1/w=
X-Gm-Gg: ASbGncu/AML8fnfmkkAGlppRnefKo1voEdDcWrTOP3I6bF0yJ9p0NSIhmLdHVqKfG85
	lJ46AfKSvzbUwIodUwyw2nVpdOPIAlmyWLiVcbGLGwBgM+t6ftFeJiDR98sITBzrd+o4JWqdZFb
	/QM9PnAIuP40WEETUNabQyLX8Wg2021+bGD49ePW2DOXcFAeAYhKY8bKKeHzgrIASBLTdThQq6S
	06gGvOWHVWU6xqh5IjVYJ3kemsYhZP6lhfH7oEOp5rwQfpV9jQoAUAmkWlvRNxKF7MAaS6kv+e6
	lQSO67qcglpnk4EEogSTGbXPL70CzN4B4daUBWAUvARDab0dW7QVWCWHYn0s3mJ8bVjOvr521JZ
	LZbnQm6kNYZ/p1oBYoYU3+oB+9shGx9lfXzRozEWO/YzJBlYjS8FbnlyrSMar8Vw5HVDTf6k=
X-Google-Smtp-Source: AGHT+IF8RvtbGMLomOdXVkDJ+YxzFvLcecwxKm+jrWt7odK5vRmlP4nv8ElQjsO9rstnUpRj/Gaa/w==
X-Received: by 2002:a05:6a20:a122:b0:2ba:e2c5:7281 with SMTP id adf61e73a8af0-2cfe903f449mr2771078637.35.1758619040289;
        Tue, 23 Sep 2025 02:17:20 -0700 (PDT)
Received: from G7HT0H2MK4.bytedance.net ([63.216.146.178])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-32ed26a9993sm18724713a91.11.2025.09.23.02.17.12
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 23 Sep 2025 02:17:19 -0700 (PDT)
From: Qi Zheng <zhengqi.arch@bytedance.com>
To: hannes@cmpxchg.org,
	hughd@google.com,
	mhocko@suse.com,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	muchun.song@linux.dev,
	david@redhat.com,
	lorenzo.stoakes@oracle.com,
	ziy@nvidia.com,
	harry.yoo@oracle.com,
	baolin.wang@linux.alibaba.com,
	Liam.Howlett@oracle.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	akpm@linux-foundation.org
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	Qi Zheng <zhengqi.arch@bytedance.com>
Subject: [PATCH v2 4/4] mm: thp: reparent the split queue during memcg offline
Date: Tue, 23 Sep 2025 17:16:25 +0800
Message-ID: <55370bda7b2df617033ac12116c1712144bb7591.1758618527.git.zhengqi.arch@bytedance.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <cover.1758618527.git.zhengqi.arch@bytedance.com>
References: <cover.1758618527.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 66C2EA0006
X-Stat-Signature: osfjdn66k4bmm88dj93s7mk4ofhrzuto
X-HE-Tag: 1758619041-549303
X-HE-Meta: U2FsdGVkX1/M6H9CZVJ80ggPD2qpTS0vIRv7xYZZW0EBW/E2fGvvXMHfNOQtL1YLUKcgYfEjXPsTd15CxIC2f9t6ciQzBoYEiFwpv/n2PohP6hbnwsXyX5e2a49SZYncYT6IS+adxCodF7Gk3QgrHag1YqzVob65CNLavEkJh1+obqg7EAK6BGChI/OhGizWe3AugXEJRebCSt6HDHmU2Zu+0Km9jxwKiWoxoIuk3HLvkSStE4d6pf9x9t2ca2QRtJzcPmaWcB7KSmd5F1Hj0X4naoSG6DvWRz6BWfVAjqOEGONJvnmMLKMfSSYvvm0/WS2bVadS5DR2FY3idqMTO2tsFld8QIx8QOWslA2Nk6QZ5/BkGSUkbM/PFKoLOnZkjp7j041n3ze6JQSjJAeU2l2+rT69qtlEgljY63c7izxEwkjLYv7r+Vwm4cv+MdDyB3jZFkz4OKnR25j1O6LHocyUVz5zHe6CPzJff267QIhKObApoL4FeNPOMDhjCh6Z1xzjfrc1MsCofq1TkelmCUzpqScnjxIRk6nssM+95zhPG1mSPahgu+mYoIq9v9DpwNdMuFQpqegq3Q+S8WNVtoyUbIYR8/4aSGr/mwZGPUBnifxpr+spysDSydFNcwdutVLlB7YvghcQ+Sh4k1Q9iLaYmH8tf7gxzuYUT/Hw/nkbB8d6ewPnd1E0VH5f2OQpY11YbQsGYZwbeDjO2cq6dE428PkYifLudn6psjhjk/9DAAXJKdQ6fdgCbM+R7+mIPVmuDHueMuLwtcpu5n4+rMM/3lE05uM/Vk52jb2Ej4XPxilegh3jKwo7zkVQj43I4GZL4mq1X4MtK8BYqDj3PZG+CQwCgyFL6Sk/n9YrdJyfM6wWALRWFrCvYeQCwrI0SBst6NIU063fVRVJSVwn7ZJf/L33xWZgYA1N9DoUAnDDeJvsPtUmBGtYLKS4JWw+soVImX7L0MjgNpN6zUe
 hJnmVxPw
 MC29Ty6do+ea+wVN0ZmHtb2PP86Imw7RObm/mHE17NRlBmE70GokfvpbHKQjj6qd5PegqexszQgZcg1jYEAAupkd/rXGK4I9XwX7ELIROECX2Bqo8ws3rFg6bSOVM7IhJIZR6A1v32oiwGm/a1RgrB0PRaNP3gsLd6J1wgHQYGSTa1C1DA/C1bVWHRywNwnmb5ph45n+P+m69rZjRjAWiHN+NiCN1yVRIsMcRtWuuIGpZW/nd5I/ccWHDmoMwL5cRDALgG0SztHXeSKzahinHigjCGUuFXBWZAXhHb2MbDF5DwDVqtZhib0ETeXbgVwFIZMQNEebrCC6qCWlNhiVFPCyLvA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In the future, we will reparent LRU folios during memcg offline to
eliminate dying memory cgroups, which requires reparenting the split queue
to its parent.

Similar to list_lru, the split queue is relatively independent and does
not need to be reparented along with objcg and LRU folios (holding
objcg lock and lru lock). So let's apply the same mechanism as list_lru
to reparent the split queue separately when memcg is offine.

Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
---
 include/linux/huge_mm.h |  2 ++
 include/linux/mmzone.h  |  1 +
 mm/huge_memory.c        | 39 +++++++++++++++++++++++++++++++++++++++
 mm/memcontrol.c         |  1 +
 mm/mm_init.c            |  1 +
 5 files changed, 44 insertions(+)

diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
index f327d62fc9852..a0d4b751974d2 100644
--- a/include/linux/huge_mm.h
+++ b/include/linux/huge_mm.h
@@ -417,6 +417,7 @@ static inline int split_huge_page(struct page *page)
 	return split_huge_page_to_list_to_order(page, NULL, ret);
 }
 void deferred_split_folio(struct folio *folio, bool partially_mapped);
+void reparent_deferred_split_queue(struct mem_cgroup *memcg);
 
 void __split_huge_pmd(struct vm_area_struct *vma, pmd_t *pmd,
 		unsigned long address, bool freeze);
@@ -611,6 +612,7 @@ static inline int try_folio_split(struct folio *folio, struct page *page,
 }
 
 static inline void deferred_split_folio(struct folio *folio, bool partially_mapped) {}
+static inline void reparent_deferred_split_queue(struct mem_cgroup *memcg) {}
 #define split_huge_pmd(__vma, __pmd, __address)	\
 	do { } while (0)
 
diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 7fb7331c57250..f3eb81fee056a 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -1346,6 +1346,7 @@ struct deferred_split {
 	spinlock_t split_queue_lock;
 	struct list_head split_queue;
 	unsigned long split_queue_len;
+	bool is_dying;
 };
 #endif
 
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 48b51e6230a67..de7806f759cba 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1094,9 +1094,15 @@ static struct deferred_split *folio_split_queue_lock(struct folio *folio)
 	struct deferred_split *queue;
 
 	memcg = folio_memcg(folio);
+retry:
 	queue = memcg ? &memcg->deferred_split_queue :
 			&NODE_DATA(folio_nid(folio))->deferred_split_queue;
 	spin_lock(&queue->split_queue_lock);
+	if (unlikely(queue->is_dying == true)) {
+		spin_unlock(&queue->split_queue_lock);
+		memcg = parent_mem_cgroup(memcg);
+		goto retry;
+	}
 
 	return queue;
 }
@@ -1108,9 +1114,15 @@ folio_split_queue_lock_irqsave(struct folio *folio, unsigned long *flags)
 	struct deferred_split *queue;
 
 	memcg = folio_memcg(folio);
+retry:
 	queue = memcg ? &memcg->deferred_split_queue :
 			&NODE_DATA(folio_nid(folio))->deferred_split_queue;
 	spin_lock_irqsave(&queue->split_queue_lock, *flags);
+	if (unlikely(queue->is_dying == true)) {
+		spin_unlock_irqrestore(&queue->split_queue_lock, *flags);
+		memcg = parent_mem_cgroup(memcg);
+		goto retry;
+	}
 
 	return queue;
 }
@@ -4284,6 +4296,33 @@ static unsigned long deferred_split_scan(struct shrinker *shrink,
 	return split;
 }
 
+void reparent_deferred_split_queue(struct mem_cgroup *memcg)
+{
+	struct mem_cgroup *parent = parent_mem_cgroup(memcg);
+	struct deferred_split *ds_queue = &memcg->deferred_split_queue;
+	struct deferred_split *parent_ds_queue = &parent->deferred_split_queue;
+	int nid;
+
+	spin_lock_irq(&ds_queue->split_queue_lock);
+	spin_lock_nested(&parent_ds_queue->split_queue_lock, SINGLE_DEPTH_NESTING);
+
+	if (!ds_queue->split_queue_len)
+		goto unlock;
+
+	list_splice_tail_init(&ds_queue->split_queue, &parent_ds_queue->split_queue);
+	parent_ds_queue->split_queue_len += ds_queue->split_queue_len;
+	ds_queue->split_queue_len = 0;
+	/* Mark the ds_queue dead */
+	ds_queue->is_dying = true;
+
+	for_each_node(nid)
+		set_shrinker_bit(parent, nid, shrinker_id(deferred_split_shrinker));
+
+unlock:
+	spin_unlock(&parent_ds_queue->split_queue_lock);
+	spin_unlock_irq(&ds_queue->split_queue_lock);
+}
+
 #ifdef CONFIG_DEBUG_FS
 static void split_huge_pages_all(void)
 {
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index e090f29eb03bd..d03da72e7585d 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -3887,6 +3887,7 @@ static void mem_cgroup_css_offline(struct cgroup_subsys_state *css)
 	zswap_memcg_offline_cleanup(memcg);
 
 	memcg_offline_kmem(memcg);
+	reparent_deferred_split_queue(memcg);
 	reparent_shrinker_deferred(memcg);
 	wb_memcg_offline(memcg);
 	lru_gen_offline_memcg(memcg);
diff --git a/mm/mm_init.c b/mm/mm_init.c
index 3db2dea7db4c5..cbda5c2ee3241 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -1387,6 +1387,7 @@ static void pgdat_init_split_queue(struct pglist_data *pgdat)
 	spin_lock_init(&ds_queue->split_queue_lock);
 	INIT_LIST_HEAD(&ds_queue->split_queue);
 	ds_queue->split_queue_len = 0;
+	ds_queue->is_dying = false;
 }
 #else
 static void pgdat_init_split_queue(struct pglist_data *pgdat) {}
-- 
2.20.1


