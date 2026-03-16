Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CAB19F53D69
	for <linux-mm@archiver.kernel.org>; Mon, 16 Mar 2026 16:09:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 600DE6B02FE; Mon, 16 Mar 2026 12:09:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 572616B0300; Mon, 16 Mar 2026 12:09:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 45EF46B02FE; Mon, 16 Mar 2026 12:09:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 27D716B02FE
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 12:09:27 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id DEE561A0282
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 16:09:26 +0000 (UTC)
X-FDA: 84552411132.15.78007C5
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by imf20.hostedemail.com (Postfix) with ESMTP id 3DDDC1C0002
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 16:09:25 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux.microsoft.com header.s=default header.b=FB3cdTRf;
	spf=pass (imf20.hostedemail.com: domain of tballasi@linux.microsoft.com designates 13.77.154.182 as permitted sender) smtp.mailfrom=tballasi@linux.microsoft.com;
	dmarc=pass (policy=none) header.from=linux.microsoft.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773677365;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VcslTGd7Gwos3Z8Yii274STD1R1lKDBM+pUFy34ylok=;
	b=ToSMTEaWSaVFRBI9STqhzr327eWqUQ6BOqjwvLHJglxWtjGWMOvhnkeEIqKkTb46sESH/G
	EbxiEgQa6ZfJuGpRFSEIU1y9aCTS6yzorjPuB3Y9GLI+agjO2JT1YP0IWG5pr09FAmgKeF
	oTK87UP8SWwXl5Ol1Co9l0bEwgdRwmY=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux.microsoft.com header.s=default header.b=FB3cdTRf;
	spf=pass (imf20.hostedemail.com: domain of tballasi@linux.microsoft.com designates 13.77.154.182 as permitted sender) smtp.mailfrom=tballasi@linux.microsoft.com;
	dmarc=pass (policy=none) header.from=linux.microsoft.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773677365; a=rsa-sha256;
	cv=none;
	b=ZK6fkLW+cuM1Vj4sQk+q5qYAawd+PcLnp/geehW2gVZ3DyfKI+6NMHahuhaqYZQzsHyI5A
	HbceWXFebsv8alLBQkFfP/rTv3xBEBQ2iC1QAmmR8yw/cXftxBFxWN6cJZu8JNWP/KC3GO
	1judObtKuP19oLMicLk1uMh7yzmefHw=
Received: from LAPTOP-U3CCR7C6.lan (unknown [20.236.10.206])
	by linux.microsoft.com (Postfix) with ESMTPSA id C9F7020B6F12;
	Mon, 16 Mar 2026 09:09:23 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com C9F7020B6F12
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1773677364;
	bh=VcslTGd7Gwos3Z8Yii274STD1R1lKDBM+pUFy34ylok=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FB3cdTRfo3+snO46oMEGmJXEAuozyG8yA+S+kxdnoj/rjSJxeeCwC8n6x4JvSRfEz
	 aSCn5sQzAcOzLMEQ0U5O/oxpOjV/Bc/zTn0BCBuW93O8Ew4QESji7iisuaobP1l6OZ
	 kcmkcnNYQoMmQhkFnqHTqkmH2dCMseIe2uj/RiwU=
From: Thomas Ballasi <tballasi@linux.microsoft.com>
To: tballasi@linux.microsoft.com
Cc: akpm@linux-foundation.org,
	axelrasmussen@google.com,
	david@kernel.org,
	hannes@cmpxchg.org,
	linux-mm@kvack.org,
	linux-trace-kernel@vger.kernel.org,
	lorenzo.stoakes@oracle.com,
	mhiramat@kernel.org,
	mhocko@kernel.org,
	rostedt@goodmis.org,
	shakeel.butt@linux.dev,
	weixugc@google.com,
	yuanchu@google.com,
	zhengqi.arch@bytedance.com
Subject: [PATCH v8 3/3] mm: vmscan: add PIDs to vmscan tracepoints
Date: Mon, 16 Mar 2026 09:09:08 -0700
Message-Id: <20260316160908.42727-4-tballasi@linux.microsoft.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260316160908.42727-1-tballasi@linux.microsoft.com>
References: <20260223171544.4750-1-tballasi@linux.microsoft.com>
 <20260316160908.42727-1-tballasi@linux.microsoft.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 3DDDC1C0002
X-Rspamd-Server: rspam08
X-Stat-Signature: k56u5yetdr4fp5fmh8swnweh5318bzmh
X-HE-Tag: 1773677364-845192
X-HE-Meta: U2FsdGVkX1+F/d8e/7nGARc56AKK8NxbPhMrUdrD0b3hHCrFtBpjfHwquUypOnNfsl+0L3ui64sI1jWn8CDKcIUW8QEEdDVrt/8pobceQ5lKnW36JmhBg49f4wet3LFnwLUQP9OIHqEytsI/g3CQftt7PVghEleDJpRKiZnyzTYvNN9zYaF9AVEha1gTb+/hbRp/0OVNKzn3sUY8QJkgprcw/AlqDFkFsZ19zShe8zkLCQjEvTy8MBSE41G8Xlpsyim4W5JJbgxHCsrHtTtco+n99FTBBhvmXbw6hwOaa3s66ntBGXwD73CdzS7lGY4q+Q9Fzx8KhA5rIgOGlFa3rsAU3giu3ccUbpui5UipW4xZHo5VzQaM3yRV49sPFaA0Kly7QIwGNiH5npQw+dEK+oEfHnI7mhcFStEzVJq21jipWdDqeWs1H+Emd2MfeZ5lqL+2r9efPvAAZHIM+KEvCfs06q9Oxst9AbP+sXE7xs9xZ01B+BL9ThXbe1WDzarnGRUGl4trthKN2ETrSC8GcEFYXDDGIcBtiQjv2qZgjKUXpe3GxNK3IuUnM92sGvshYw973oJ5udcrdtvR+35ki7m2iE9zIQh1oau20VoH/S8i9md6BKgv2X9OBORUlMnKbEhn9aDu+R3VXY6oCYXI+ym4UZhucBCuL/ExYXzVAgvfp3sUuMrJcaDlihGu242EF1mMhOpbhQcIM7fe67l5OLJly5duqmUgwALJQIpLL1vwUsG2OMbVqi4xhloffewl8+WmDgQ9yCha84l6UG1nJGw/BoXjIyCN2fNv/ei2m7c/6Z2tQ/lpL+jHPojhl1Wo52/Ko6h9Hhw4xdjT1lQcuSvURBl+5UbeDA4rHcaxtW3yTAn5N+/nGS9xr5e9p4b3E9enI6oRy8SmU7QeqVLBKNjDId3hdj0dF2k6HMTYf1c85mWeTzwriGUZ1pmXLrnZbah8aeZsb5A4fKUBx3w
 Sz+eFBS0
 REzqBk8SPt7vY9i/554pPoUQBlg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The changes aims at adding additionnal tracepoints variables to help
debuggers attribute them to specific processes.

Signed-off-by: Thomas Ballasi <tballasi@linux.microsoft.com>
---
 include/trace/events/vmscan.h | 24 ++++++++++++++++--------
 1 file changed, 16 insertions(+), 8 deletions(-)

diff --git a/include/trace/events/vmscan.h b/include/trace/events/vmscan.h
index 1212f6a7c223e..645b036572707 100644
--- a/include/trace/events/vmscan.h
+++ b/include/trace/events/vmscan.h
@@ -130,10 +130,12 @@ DECLARE_EVENT_CLASS(mm_vmscan_direct_reclaim_begin_template,
 		__entry->memcg_id	= mem_cgroup_id(memcg);
 	),
 
-	TP_printk("order=%d gfp_flags=%s memcg_id=%llu",
+	TP_printk("order=%d gfp_flags=%s pid=%d memcg_id=%llu %s",
 		__entry->order,
 		show_gfp_flags(__entry->gfp_flags),
-		__entry->memcg_id)
+		__entry->ent.pid,
+		__entry->memcg_id,
+		__event_in_irq() ? "(in-irq)" : "")
 );
 
 DEFINE_EVENT(mm_vmscan_direct_reclaim_begin_template, mm_vmscan_direct_reclaim_begin,
@@ -175,9 +177,11 @@ DECLARE_EVENT_CLASS(mm_vmscan_direct_reclaim_end_template,
 		__entry->memcg_id	= mem_cgroup_id(memcg);
 	),
 
-	TP_printk("nr_reclaimed=%lu memcg_id=%llu",
+	TP_printk("nr_reclaimed=%lu pid=%d memcg_id=%llu %s",
 		__entry->nr_reclaimed,
-		__entry->memcg_id)
+		__entry->ent.pid,
+		__entry->memcg_id,
+		__event_in_irq() ? "(in-irq)" : "")
 );
 
 DEFINE_EVENT(mm_vmscan_direct_reclaim_end_template, mm_vmscan_direct_reclaim_end,
@@ -238,17 +242,19 @@ TRACE_EVENT(mm_shrink_slab_start,
 		__entry->memcg_id = mem_cgroup_id(memcg);
 	),
 
-	TP_printk("%pS %p: nid: %d memcg_id: %llu objects to shrink %ld gfp_flags %s cache items %ld delta %lld total_scan %ld priority %d",
+	TP_printk("%pS %p: nid: %d pid: %d memcg_id: %llu objects to shrink %ld gfp_flags %s cache items %ld delta %lld total_scan %ld priority %d %s",
 		__entry->shrink,
 		__entry->shr,
 		__entry->nid,
+		__entry->ent.pid,
 		__entry->memcg_id,
 		__entry->nr_objects_to_shrink,
 		show_gfp_flags(__entry->gfp_flags),
 		__entry->cache_items,
 		__entry->delta,
 		__entry->total_scan,
-		__entry->priority)
+		__entry->priority,
+		__event_in_irq() ? "(in-irq)" : "")
 );
 
 TRACE_EVENT(mm_shrink_slab_end,
@@ -280,15 +286,17 @@ TRACE_EVENT(mm_shrink_slab_end,
 		__entry->memcg_id = mem_cgroup_id(memcg);
 	),
 
-	TP_printk("%pS %p: nid: %d memcg_id: %llu unused scan count %ld new scan count %ld total_scan %ld last shrinker return val %d",
+	TP_printk("%pS %p: nid: %d pid: %d memcg_id: %llu unused scan count %ld new scan count %ld total_scan %ld last shrinker return val %d %s",
 		__entry->shrink,
 		__entry->shr,
 		__entry->nid,
+		__entry->ent.pid,
 		__entry->memcg_id,
 		__entry->unused_scan,
 		__entry->new_scan,
 		__entry->total_scan,
-		__entry->retval)
+		__entry->retval,
+		__event_in_irq() ? "(in-irq)" : "")
 );
 
 TRACE_EVENT(mm_vmscan_lru_isolate,
-- 
2.45.3


