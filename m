Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9B742CA1013
	for <linux-mm@archiver.kernel.org>; Fri, 19 Sep 2025 03:50:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 051448E0122; Thu, 18 Sep 2025 23:50:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 001538E0008; Thu, 18 Sep 2025 23:50:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E0C358E0122; Thu, 18 Sep 2025 23:50:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C92088E0008
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 23:50:12 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 8967F1A050D
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 03:50:12 +0000 (UTC)
X-FDA: 83904621864.18.6A41C99
Received: from mail-pg1-f180.google.com (mail-pg1-f180.google.com [209.85.215.180])
	by imf14.hostedemail.com (Postfix) with ESMTP id CE9A3100002
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 03:50:10 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=ZCNT3glG;
	spf=pass (imf14.hostedemail.com: domain of zhengqi.arch@bytedance.com designates 209.85.215.180 as permitted sender) smtp.mailfrom=zhengqi.arch@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758253810;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Dh3BXMCVe/uDP+wP9LS7p/Pcrlb4d1sLNbOVo2rnZMs=;
	b=tVlAFh9kLK7ktgG+Qze0eS7W4uuTrwREFd/uHLDpqlaYZKUDksCg1qgLS8d95t5ZPDQpFD
	2WDq2PJoeOvhvAfdMymIKYOsUiFV5ybprDsk3d9+A2Kbvr9p2ZU8OuZe62DSB5+Mor4s9m
	KCeo0PW2a+K5rHXP7Bkzc58oxSOKT4g=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758253810; a=rsa-sha256;
	cv=none;
	b=jthsV5tVVd1uLRdk0LIuVothVTADISFYVAW4kXdqPSO+pU5bKyRGHK0RPyfm9iitXZ45xh
	GlXIAB16e038DqQm1cXuYtxRvM65SlZCJ7/8T++K+SnIaLluGOMG/FlYE0t4V5t4scZgrK
	KYDISba01x/HdVunwTgqVQHJbLSZxXQ=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=ZCNT3glG;
	spf=pass (imf14.hostedemail.com: domain of zhengqi.arch@bytedance.com designates 209.85.215.180 as permitted sender) smtp.mailfrom=zhengqi.arch@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
Received: by mail-pg1-f180.google.com with SMTP id 41be03b00d2f7-b4f9d61e7deso1105573a12.2
        for <linux-mm@kvack.org>; Thu, 18 Sep 2025 20:50:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1758253810; x=1758858610; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Dh3BXMCVe/uDP+wP9LS7p/Pcrlb4d1sLNbOVo2rnZMs=;
        b=ZCNT3glG8bmw0WLxXTgEyMSCBtU5fTdVjK5gnDTkzlLIs9DV/cUvZdKYHJcgUqcoZj
         q85fM5YrEYtFh2mkyI+rv1QJZT7uwj8rUgabNRaWVY4tVrL98sHdEopvEd9vjR4cFAV6
         QkO/IZee6d3KIfw3GwpeiwrWCOlgnLYIewa9MEiTzhsK8yv+OXjY1tX3RGcT/irmEpRf
         GR/U97Q+E4AaC7RyvAg4bZ3VAtFlX3W2IPDA3l8nl5SFuccdKRTr4fDnQqsdGKMt5X4g
         U+Xikx2BiuPONQCtebbNK8qOYLn08KOb2tYVrM6jHhukccNf+5nDc8McIFCggA1zT3lh
         Lpvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758253810; x=1758858610;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Dh3BXMCVe/uDP+wP9LS7p/Pcrlb4d1sLNbOVo2rnZMs=;
        b=dTMXPdVEHO5QPPxGCGmitRR6SGGZgb56ZkF2wl5VKYtS7ethxBkBm7O4UCkS27AS5z
         fORyTTQwTTbswCTQ3tuTkAm/Bzok+hligt/bGGzpYmpf27ipaTXZg45LqURzJhAdtCS9
         gtKa3urlzhLqLnX/6XdvTqYLmdpb7kYjaHEB20e+F06HUsVIk1AxI2zgeVLndeBXlHNt
         /tSiGLUuyC3U/Qy0rH3UXFcJgkG6t5x+0KnrUJKe+D0WBFectr0iOumA9axiePU4nrx0
         C/Z3YuvEuCefYW5wj8sr6ANw5TNY8BiVjv111fgyyqbCA2rBmA3xJZIMwfh5YSuezYLY
         NnTQ==
X-Gm-Message-State: AOJu0YwKllvb/yinDbAvWqWtG22GCR9H3xrD1O8MHYGZk/weHORb2h2P
	Ow7H+lhHjFGyq54tH+AfOgGz+GueuYPKo5YTenLkKXtC92fE2e5LwVqkyl9BBHlj1Yo=
X-Gm-Gg: ASbGncvwG70YpCA9FshhMbUOir2DBrO00DNBirbi4LlloEpcnl6lhCdJ3u7ErrOBmdC
	ng+nIOsb43kEsyYURi+h5lqRumGMyR26JomywqvL7QjyEOCQGMwADBCLdK3y2qoYzUVR72mBc6j
	38rMXPAkjoL1ihD4tKvgNQCdgnuGjEDBgy+ECb6Ezw77AiIVvW3lnLFqpHvQN1JNmVoWDDZuS5m
	cKsgtP6sRIj118zqlIXNW84QbBTDnQX4QfGOShOPHgTzeuTPAIZ0Yt+yK+jsGl8GN6YfP3fgu4L
	OwTFiAarH8AylHz5Nm2539Ey7+FVcIiO08qrxk8USZMXVDZvl9x60Sup5Epoyftw8knbFDNCVSI
	W1TUGiPi/JxIJYDnrtFralDx4mBULkpfPqqIvewfEUp5icfzuqTa3Vrw+q1Cdfu6EmG5etoQ=
X-Google-Smtp-Source: AGHT+IHXW8cvX8V+aWHxCFgC0rEAHufiYcxbAIJngIiMTSD/3JE4z6oIJUCUUjulr4OnA4Onw52AMw==
X-Received: by 2002:a17:903:6c3:b0:262:661d:eb1d with SMTP id d9443c01a7336-269ba3c2c39mr19727495ad.1.1758253809733;
        Thu, 18 Sep 2025 20:50:09 -0700 (PDT)
Received: from G7HT0H2MK4.bytedance.net ([63.216.146.178])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-269802de5e9sm39629235ad.72.2025.09.18.20.50.02
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 18 Sep 2025 20:50:08 -0700 (PDT)
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
Subject: [PATCH 4/4] mm: thp: reparent the split queue during memcg offline
Date: Fri, 19 Sep 2025 11:46:35 +0800
Message-ID: <bbe3bf8bfce081fdf0815481b2a0c83b89b095b8.1758253018.git.zhengqi.arch@bytedance.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <cover.1758253018.git.zhengqi.arch@bytedance.com>
References: <cover.1758253018.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: CE9A3100002
X-Stat-Signature: mnq8e3bteqzmtqg79cjxmcek7rfh919b
X-Rspam-User: 
X-HE-Tag: 1758253810-783331
X-HE-Meta: U2FsdGVkX19ZJ0SgLi8B4eTDhy1wjmrKtqoONsy1E7POEaN8b6MyMGQEhd3Zq9x05l2SvEYFBerdFbXxiDhHfZUVWXhNqi2xruOztAZs/JkvkKO4Ydk0PqT+yyGXJoXrqNSmoH8G50ibXF1RuzPxq7j4yyJmXL356TjwNJVrl9oyLvtkQqv438hWK8DfYK3Gw/5eWdBt2ExYACV/6fBQsZIELNvkd69FcVmK6r1K2yB0DpDvY7J+kmaHq9NK8I1yWGKnyKe4P3NxC0ecNId/cQo/JISvK9FvQq6ppQA6aWLoBn+szHPE7X9w9vjNudY+18LIEAw6KTaHwPN5YHVC3XCCKaL8+W0jPmOyjFs8rVEJ7egJVhSvLEuPixwUpwmxnMaowXRPnkSRXOqTpijrqNezAmY9LkvJlNllClHDFh9v8lrMyvRqKgYaq9EyIazb/nJkAKTnEaF99/L+NpDSlTXG18zNVoVAVRSgErpS/ta6htLDNyrbbfdAEJJFaBBRqtu1xBNmDpYySq7fJax74lzmedlrzR19Zv/pS9y+0y5R++ZiaveCHE3qQ+wJkfZrHMxmSjk6Njr8Dw6TVE7/ustsEhVzBv9NW/fnoBA/6QhcTOqEJTAjtNkJLqWAWPiZ7DKK6GjgExhPQRWnKsa/s1kmOnZlCpxTUa1dN9FH5CkN7+fPC5Qulh3eUCaFvFsCfVgrQRaegsA7luOIRutK5DnPFfUElg8nIsOsJo3VAGo6uCRZy5b968KA/XRSwIL50AWhaBLBWWhq5Dx5cOZb1M33exSt7lyRWIIYtfKBBKFupFI6fCeZCBSPosEgvmEw3W1RqjV26ZzNSprgXwgjC6KZjTP5vaMyFsvj+M+47ofOjJL0TqO7i1Vvsj0INFrsMtWLb/0jOnIl5yP2LKEtNn9RWCLAszKR7+7ypxm0hWf4Z3CuMjuTsULsrRb+bPOPHs83a2ysGgzh12hmzhp
 ycnWmx2I
 C2PUr4lx2h4kHRHrwDm5Fe1iGbjvUBJO5wcnfGzDGM32ECc3vxMQc5Mg3xzqVy5W2X9+ap4UPbPEvcOA=
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
 include/linux/huge_mm.h |  1 +
 include/linux/mmzone.h  |  1 +
 mm/huge_memory.c        | 39 +++++++++++++++++++++++++++++++++++++++
 mm/memcontrol.c         |  1 +
 mm/mm_init.c            |  1 +
 5 files changed, 43 insertions(+)

diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
index f327d62fc9852..3215a35a20411 100644
--- a/include/linux/huge_mm.h
+++ b/include/linux/huge_mm.h
@@ -417,6 +417,7 @@ static inline int split_huge_page(struct page *page)
 	return split_huge_page_to_list_to_order(page, NULL, ret);
 }
 void deferred_split_folio(struct folio *folio, bool partially_mapped);
+void reparent_deferred_split_queue(struct mem_cgroup *memcg);
 
 void __split_huge_pmd(struct vm_area_struct *vma, pmd_t *pmd,
 		unsigned long address, bool freeze);
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
index ab16da21c94e0..72e78d22ec4b2 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1102,9 +1102,15 @@ static struct deferred_split *folio_split_queue_lock(struct folio *folio)
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
@@ -1116,9 +1122,15 @@ folio_split_queue_lock_irqsave(struct folio *folio, unsigned long *flags)
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
@@ -4267,6 +4279,33 @@ static unsigned long deferred_split_scan(struct shrinker *shrink,
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


