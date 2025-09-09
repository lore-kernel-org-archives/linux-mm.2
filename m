Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8D2CDCAC582
	for <linux-mm@archiver.kernel.org>; Tue,  9 Sep 2025 01:00:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B55A38E0012; Mon,  8 Sep 2025 21:00:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B05488E0002; Mon,  8 Sep 2025 21:00:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9CCB08E0012; Mon,  8 Sep 2025 21:00:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 8679B8E0002
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 21:00:21 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 333E81A0379
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 01:00:21 +0000 (UTC)
X-FDA: 83867905842.06.C3DC471
Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
	by imf04.hostedemail.com (Postfix) with ESMTP id 4B2B540006
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 01:00:19 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Phy8YQJk;
	spf=pass (imf04.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.216.49 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757379619;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lweQth/eoeP4wh/Y1X6sTVK7tPaLR6fCtzruOPdl+ns=;
	b=FlA3Waw9wh6m5X9Nf8VoRwDbT6p9Fc3VOT/Jh7TbJoGZKrAiIPZaKeBm52C5gdgy2dvhUL
	b1VUienJ/Nc/oCtI93vzoZh7Dk1seRz8F5W05YCWNtCQ0mM/9sYoU3E2kc+qZu9gnheZAi
	d8Yg+8P0FgmnT2p0rZvio4VG9azz5+Y=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Phy8YQJk;
	spf=pass (imf04.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.216.49 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757379619; a=rsa-sha256;
	cv=none;
	b=ivL3m1hQE44CD0Gz/DjP+yQI3wDXlZxPmvxJaV/f3Dgkt77IDrg3fKT6W1caKr4FcXbL9r
	QOXxYpsnyzMGEGOjwWEE/w54+t3ed6/7Hqj0m/8+OkaCfqfuRAEKrgPo8Mcqa2zkwkXond
	Ufq25f534Q42yaUgz/gpZf87Iwp+P3Q=
Received: by mail-pj1-f49.google.com with SMTP id 98e67ed59e1d1-32326e8005bso4581374a91.3
        for <linux-mm@kvack.org>; Mon, 08 Sep 2025 18:00:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757379618; x=1757984418; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lweQth/eoeP4wh/Y1X6sTVK7tPaLR6fCtzruOPdl+ns=;
        b=Phy8YQJkNz0DHK6NZcf9gBG8JBWm/sXdELEI1xQkFa5ljBiHb6g7QO1+U1YlWepbm0
         5B0bkImrOV1d1jTgRs4uJet9EMhVEJ7+KW5Avt4fep3avmVqCbLJVK5Afc7zisQcy+Bv
         zdaYHmoLVY5fqmSW9RGnXIXrzxPLZHkDRJMCXq7qF8T8+BaIfLyCpTjVLCAG/1l9QtuH
         31foMPpbOcO8ZC+tgDpgUgjHQNRwWoZbMX/lbfwVZOhei0kPS8msvsMwVF4vxYRNC+h6
         OTEJgau/fsltKKv3r7Nx854NsPKcpmo7V5N6FXkohdBgCm7Jc9tUErnUIXDsUuvL2YHP
         Pjxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757379618; x=1757984418;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lweQth/eoeP4wh/Y1X6sTVK7tPaLR6fCtzruOPdl+ns=;
        b=aqFVSMjk+wJqN19baionl//PBLfkQ0SLDExUwXGu1yCC2MvQYxsUTJ5CwLY9ZtCpc6
         SOIecwUhS0oG4q9eh5Jo9iLM950pmVQT3QEFCPro2LJGXQ2Lu2XxVvnaoqoe5+PaoYuz
         /pZX8oxbqLhmWybAxnLjzgCFj3gaVmjZ515QPb+T0eCrW/NgKbNAAZyJtyjqweAJV02M
         km9wL9mlrlVEHigloL8JuoRJaQ9LKqnt4E9PSgpP6T5Q2ny1dunwQj7mzl47jtKoiQWk
         cuhQZ9pFpb0AU51e73S1sPWbKUDamcnmaPg+jmYC67wRHEy8b/B1IFOqmbrOsb4D8hQy
         se7Q==
X-Forwarded-Encrypted: i=1; AJvYcCU/eAgZmk8ErRPHGtFkwSriARa9KwvregYOISgd+5uD0zNif1F+/FxO+LfVf21b2p4gdfwQ2hf5Tw==@kvack.org
X-Gm-Message-State: AOJu0Yx/D7rdk4cjA5UyRgLIvVqXv/8jb4JIJ/f5GykyLB+uWuBPUjYp
	s7UOhGk009cLOGzISw1xyG97T67QZLQZ5GLD/Rl4EZ/RVedTEdU8PojNwmP0sg==
X-Gm-Gg: ASbGnctWxbyZiEQhvJPnqxbq9I8sTkEe24gvXMIhShffe0RFlI14e+/EDu6pWVOmVrx
	yhapy73upSmuLpDBjr27UmBoHbqi3410rF0gcJM3EGxHD3dHVH3DI9h8VoKqshJiXyKkcrruoZo
	w00E3GA/vsLIFY4jKJHQVecVzBKwIp8JfgFbUgbJ9tmiibHVCapwMmgBCZRoNiuIfObccqxiw3n
	qKleE9NeqZaPWQpFJ1n0MlNywdot2c9imcrCeDzIzMfuApEtCuZFJQ3iPN73LQxrkuM3wlrrNdn
	8x7n+wv30hv4AAZvHjpOrm4UJRO5vd3gRDMsqwGhBIyQne9wmLkXi5Nq1tsiSuUG0Ughu23lZsd
	/84VEKiCaHCm2Sds7qWcQjPUsU5q/Ha1bmpIeC/dkzHl9gYZG65+qqeqMkNSX9kC1vo18N4pyJ+
	mduty43Pft
X-Google-Smtp-Source: AGHT+IGcC1Pn9CL6jai0UNiIjOeh56a1f273MfYqECSfhc//Nu1mCQn/YDNIhWHyr7s7smQBh7K17Q==
X-Received: by 2002:a17:90b:2883:b0:32b:97ff:c944 with SMTP id 98e67ed59e1d1-32d43f93d9bmr11748116a91.28.1757379617901;
        Mon, 08 Sep 2025 18:00:17 -0700 (PDT)
Received: from localhost.localdomain ([2001:558:600a:7:44e6:767e:cc5a:a060])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-32b694f5120sm16166651a91.0.2025.09.08.18.00.17
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 08 Sep 2025 18:00:17 -0700 (PDT)
From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
To: bpf@vger.kernel.org,
	linux-mm@kvack.org
Cc: vbabka@suse.cz,
	harry.yoo@oracle.com,
	shakeel.butt@linux.dev,
	mhocko@suse.com,
	bigeasy@linutronix.de,
	andrii@kernel.org,
	memxor@gmail.com,
	akpm@linux-foundation.org,
	peterz@infradead.org,
	rostedt@goodmis.org,
	hannes@cmpxchg.org
Subject: [PATCH slab v5 3/6] mm: Introduce alloc_frozen_pages_nolock()
Date: Mon,  8 Sep 2025 18:00:04 -0700
Message-Id: <20250909010007.1660-4-alexei.starovoitov@gmail.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
In-Reply-To: <20250909010007.1660-1-alexei.starovoitov@gmail.com>
References: <20250909010007.1660-1-alexei.starovoitov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 4B2B540006
X-Stat-Signature: femsr3kca53p1zdcfeek4gqzb9zx8yf6
X-HE-Tag: 1757379619-451853
X-HE-Meta: U2FsdGVkX19uKDbePKndTGINMYXfig0Lk1FSnhXff4xX2MrLHH6tvQ5Rw/6gMlQGSexg3+jXiI+foL5dY44Qp4H8snkHchORqu+o+fLJzxc/c86D6XVSC1YlUYStqmp42dtjzLVGmgvZJ4IMPnkK6dycscrPpNG3FMpLPReOE1x5DvcGTQc0G3inDQ5aD+4UdKXG+vLuqn7SNMEngIFSqRq/eCUSVEBSjeOASvb5wxKcHS5BsD07/G/RYwOuhWB63knw/oiVOT6bKVmaICgz843KIc34SCK9qux4LYh7L5EsAZVJTKT6jMxhhdaQpD2rwp6CDlto6nsiCx+Ru9IGUYq+Wx8161xLyWzYxxIh2he61rcTNVyRKtMYCKufcXPL23et7LO1eZIxFPnqTrKLEp7rmYhj7KnJlnQkBKOcc5UbHheFeusOEK6Zwoy1WN1Zvu0CWLiF7C36UXG1vbLG01tf+Ga68fLNjEGstQJrIHTXxJ05DFbJm0lOcy2jVbNI8oeZGf4r52c8ovapJQr3XmAJN+aprM4bRW5DxFSoYkJRre8xod3e0wWRb0eFw7GxRHq3CLWWfL7ler6gMBGCYBMxhXb5Org0qRrtCNCS/RPY1MvcfkHzuconEaE/8+hbUAAS1dMn1wkWdzIdT2cWxoljIT3c8u7ivLLJksUfTV9iCINgpquckTcMxAsa4COQcjg5IwO0aV5Xwo6YA/Y2gurHiwqgoWemAX+0NgWvJGbt4WFl2qypPiOCf0sUFru14WQIBnUN7Fg0gPRuxDzI5lcmc7Q49zccsr1UaqcUv3w2MI0mrTKNd1Bqc+cFFQy6cGhdLnbXU3MgoVVyGt5ZijmDg7SXEdhklA6EkStg22ksWlAthcAm4MQvRlm7pUCef1evf2ctQRSWDcZQFxMjdmLVUlg0Av1q+blM/wYLRjFkw6hnVnmDSOpjYzP90oawemqnIpIYY4pnR0Dz7JI
 KereCgHN
 WT+3Vzmj7qmpB+aXD/UIxWYfgJvIsXpcePyCqP8pVk1DR8aPDIYlMpbZOcYcruMlk5VGpxRzqMiAY1CUuyiCxx2aIacrUOV+PBLWEOFKXHT2u6ubgzKLUUzzda2FazvFMGOoLRUnWTNlIp6hiCl7CcJN+eJBOByytnEXuGjqw86Rg5t/FwbWiuztLZbRchtbUIZgTfUb77uiXr/8BSZwe1qKZwztg/qyS1E/3M13Q3HJSHs3eENDmLzh5Aq/Qkb0pbnYFccS/SsYrf6wXAZKvkCUbneLTXypb6F8zLF2djxddYGRrGcPDJUAc/j8lOCeRUJusTVfFWrrTBGi8QSqgDURG9y0/QGN6KjyGEFlBJTU2owXFfq1OjDTIvuO5L1/focDytlXefDc4Im/7dZST6lqdVa5B/4xl5SLXxAucpRtZfYv8AvIF9BsNwvyVvEIN9v47AIK91jIECvSy+HVUC3TrstTZofg04Q1bmNbmQZfoHfqS+xJeZ8EGGujbAJkAV0OGnqynHgr/OSpAuVgF2dpk+5Y/wNcedl3k
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Alexei Starovoitov <ast@kernel.org>

Split alloc_pages_nolock() and introduce alloc_frozen_pages_nolock()
to be used by alloc_slab_page().

Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
---
 mm/internal.h   |  4 ++++
 mm/page_alloc.c | 49 ++++++++++++++++++++++++++++---------------------
 2 files changed, 32 insertions(+), 21 deletions(-)

diff --git a/mm/internal.h b/mm/internal.h
index 45b725c3dc03..9904421cabc1 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -842,6 +842,10 @@ static inline struct page *alloc_frozen_pages_noprof(gfp_t gfp, unsigned int ord
 #define alloc_frozen_pages(...) \
 	alloc_hooks(alloc_frozen_pages_noprof(__VA_ARGS__))
 
+struct page *alloc_frozen_pages_nolock_noprof(gfp_t gfp_flags, int nid, unsigned int order);
+#define alloc_frozen_pages_nolock(...) \
+	alloc_hooks(alloc_frozen_pages_nolock_noprof(__VA_ARGS__))
+
 extern void zone_pcp_reset(struct zone *zone);
 extern void zone_pcp_disable(struct zone *zone);
 extern void zone_pcp_enable(struct zone *zone);
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 30ccff0283fd..5a40e2b7d148 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -7478,23 +7478,7 @@ static bool __free_unaccepted(struct page *page)
 
 #endif /* CONFIG_UNACCEPTED_MEMORY */
 
-/**
- * alloc_pages_nolock - opportunistic reentrant allocation from any context
- * @gfp_flags: GFP flags. Only __GFP_ACCOUNT allowed.
- * @nid: node to allocate from
- * @order: allocation order size
- *
- * Allocates pages of a given order from the given node. This is safe to
- * call from any context (from atomic, NMI, and also reentrant
- * allocator -> tracepoint -> alloc_pages_nolock_noprof).
- * Allocation is best effort and to be expected to fail easily so nobody should
- * rely on the success. Failures are not reported via warn_alloc().
- * See always fail conditions below.
- *
- * Return: allocated page or NULL on failure. NULL does not mean EBUSY or EAGAIN.
- * It means ENOMEM. There is no reason to call it again and expect !NULL.
- */
-struct page *alloc_pages_nolock_noprof(gfp_t gfp_flags, int nid, unsigned int order)
+struct page *alloc_frozen_pages_nolock_noprof(gfp_t gfp_flags, int nid, unsigned int order)
 {
 	/*
 	 * Do not specify __GFP_DIRECT_RECLAIM, since direct claim is not allowed.
@@ -7557,15 +7541,38 @@ struct page *alloc_pages_nolock_noprof(gfp_t gfp_flags, int nid, unsigned int or
 
 	/* Unlike regular alloc_pages() there is no __alloc_pages_slowpath(). */
 
-	if (page)
-		set_page_refcounted(page);
-
 	if (memcg_kmem_online() && page && (gfp_flags & __GFP_ACCOUNT) &&
 	    unlikely(__memcg_kmem_charge_page(page, alloc_gfp, order) != 0)) {
-		free_pages_nolock(page, order);
+		__free_frozen_pages(page, order, FPI_TRYLOCK);
 		page = NULL;
 	}
 	trace_mm_page_alloc(page, order, alloc_gfp, ac.migratetype);
 	kmsan_alloc_page(page, order, alloc_gfp);
 	return page;
 }
+/**
+ * alloc_pages_nolock - opportunistic reentrant allocation from any context
+ * @gfp_flags: GFP flags. Only __GFP_ACCOUNT allowed.
+ * @nid: node to allocate from
+ * @order: allocation order size
+ *
+ * Allocates pages of a given order from the given node. This is safe to
+ * call from any context (from atomic, NMI, and also reentrant
+ * allocator -> tracepoint -> alloc_pages_nolock_noprof).
+ * Allocation is best effort and to be expected to fail easily so nobody should
+ * rely on the success. Failures are not reported via warn_alloc().
+ * See always fail conditions below.
+ *
+ * Return: allocated page or NULL on failure. NULL does not mean EBUSY or EAGAIN.
+ * It means ENOMEM. There is no reason to call it again and expect !NULL.
+ */
+struct page *alloc_pages_nolock_noprof(gfp_t gfp_flags, int nid, unsigned int order)
+{
+	struct page *page;
+
+	page = alloc_frozen_pages_nolock_noprof(gfp_flags, nid, order);
+	if (page)
+		set_page_refcounted(page);
+	return page;
+}
+EXPORT_SYMBOL_GPL(alloc_pages_nolock_noprof);
-- 
2.47.3


