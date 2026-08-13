Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2407FC5CFCF
	for <linux-mm@archiver.kernel.org>; Thu, 13 Aug 2026 16:12:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 251466B029E; Thu, 13 Aug 2026 12:12:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 228EB6B029F; Thu, 13 Aug 2026 12:12:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 13F0A6B02A6; Thu, 13 Aug 2026 12:12:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id DDFE36B029E
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 12:12:55 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 4AD27A021F
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 16:12:55 +0000 (UTC)
X-FDA: 85096739910.05.7BAAEAD
Received: from cstnet.cn (smtp21.cstnet.cn [159.226.251.21])
	by imf16.hostedemail.com (Postfix) with ESMTP id 57019180002
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 16:12:51 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	spf=pass (imf16.hostedemail.com: domain of pengpeng@iscas.ac.cn designates 159.226.251.21 as permitted sender) smtp.mailfrom=pengpeng@iscas.ac.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786637573;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=KNFRYi+jGMx58hmsZ73pD7GwwiDILdflw7IXmGu8taQ=;
	b=QQdDACXbu0a3RpP571HhsNCxfszlwmVso6sYENkR5IlVRaojILtB4sM+DRLe+xjWGDU+8j
	aJqRRiYIqMA+0GwRxvBvjpI36zebiwHrETTDt4CcigDIVG82Pg3uqHnKYw+wDD7xqeKf96
	E+4xeGYuGoywbXcpIiFsh96xEokEE90=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf16.hostedemail.com: domain of pengpeng@iscas.ac.cn designates 159.226.251.21 as permitted sender) smtp.mailfrom=pengpeng@iscas.ac.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786637573;
	b=51WCguVlq/XPct4O9Ri3CguRT7maTFIvtq6oSFEq7cFEAqeqkDQF3ZlHCP83+RnzyTEXe8
	kFlzvRDBziVnF4B6AHXeFCwGxGvkRnAiqmtkHcYPbZIIl7IKG5nYVrtouqoWQPlVS/JH/h
	A3O8q5P3E3OkRSgA7l2tt5v/Cf1zvPA=
Received: from localhost.localdomain (unknown [111.196.241.250])
	by APP-01 (Coremail) with SMTP id qwCowACnffH87H1qu6l7BQ--.41802S2;
	Fri, 14 Aug 2026 00:12:45 +0800 (CST)
From: Pengpeng Hou <pengpeng@iscas.ac.cn>
To: Vlastimil Babka <vbabka@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-mm@kvack.org
Cc: Harry Yoo <harry@kernel.org>,
	Hao Li <hao.li@linux.dev>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Pengpeng Hou <pengpeng@iscas.ac.cn>
Subject: [PATCH v2 2/4] mm/slub: preserve one previous object lifetime
Date: Fri, 14 Aug 2026 00:12:44 +0800
Message-ID: <20260813161244.74476-1-pengpeng@iscas.ac.cn>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20260813160825.73031-1-pengpeng@iscas.ac.cn>
References: <20260813160825.73031-1-pengpeng@iscas.ac.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qwCowACnffH87H1qu6l7BQ--.41802S2
X-Coremail-Antispam: 1UD129KBjvJXoWxAF4fCryrKw1kAFW5JryUAwb_yoWrtryDpF
	W3G3W7JFWjqr47AFZxJ3ykCr1fA395A343AFWagayruFyYqw1kJFZ7tryjvFWUAryvvasr
	Aws09r1FkF42vaUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUU9a14x267AKxVW5JVWrJwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26r4j6ryUM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
	JVWxJr1l84ACjcxK6I8E87Iv67AKxVW8JVWxJwA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gr
	1j6F4UJwAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv
	7VC0I7IYx2IY67AKxVWUAVWUtwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r
	1j6r4UM4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02
	628vn2kIc2xKxwCY1x0262kKe7AKxVW8ZVWrXwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4
	IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1r
	MI8E67AF67kF1VAFwI0_GFv_WrylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUCV
	W8JwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F4UJwCI42IY6xAIw20EY4v20xvaj40_
	Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8Jr
	UvcSsGvfC2KfnxnUUI43ZEXa7sRiKsUtUUUUU==
X-Originating-IP: [111.196.241.250]
X-CM-SenderInfo: pshqw1xhqjqxpvfd2hldfou0/
X-Stat-Signature: ncgrrdnjh7onxbqk6qwqrwge7gqwyn9c
X-Rspamd-Queue-Id: 57019180002
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1786637571-698755
X-HE-Meta: U2FsdGVkX19YCMw4yGxFGVicrUy3rM7TaLGg+/Jr/m49ZBFo84RO5gaCFIZ+NV9Pc6YoTpVlDYecugsD2iuML3kUKjrML7pb/7kGsgCqn3oUWDzzPz/hDVGYpJCFN0dh1y0G0W7gXShnt48fIGa1GzcSl+KkgGkSVILEdLcWuDHVWMuqVUF7QDRItu4IiDki50RMS0Bd/pGkvm/dGNB423j8bOCjMht9yHiCTRODYQ2WYR9EwADVwBqogSRwR/70ARFWARn/yoBMVlCpsjYhOXI0zZPVsMpRYlPXcwc5uHfi/TiJG0Q+liTsXpWRqSfFvAdqYQa75L9ZZPP3y+MHmOZlgjfMOS9tYULz1Oi4lJVIGwfXK3hQdaFaM76EWQp/DinvCTonXr70Z6XxBHwBUx2oaT6iTbCCVjrVzUKZcAts1q5kyOiP1MPOc6l6bOUUSd915+JxL6pXBjRM5IklIad8POHRv+ZMvStE2tCZUQaMAv+l8vK2rudNz+rTAH61Gsgd7D2RyYPS+TGTIammWk83lnScqVXV3rZwZUC872LbPDgNWVnoWgNOQcIjGByR/guThjr6yG2aTHdmfvPwNjlrtIDu8bW0HfKh1wnZdcndsolShGt41R0PeNtZc74PcKXQSSn9zDGRA/VCpxSAjFcJLS1b9e5z8WfpHOywG0DajH7ZmLoqSdkWLP7ZiFQpUOordrM/12GKdDwWSWdj25+17S5h2LgYqx8z1Iy5abLLBVU+1MotazgxEE2uOiTWLn8HHnkkNWDAaQwnbQbp4jV+4vjggnZX0W1+QtfO2duHhCHiGbNoaFCO8dTLmjSTl1rUPttXJhHohXSDAKuqBuY1ngZqAnQJQUGoI7A8ga4ekQn2RHij26g6rCRLQ5HYIGmjJ1mOjYBP2uyfoFeMVjHUVpFb5wjjQoRytAXJDZ88WmfzxxxLwjbluWuYE/Cg5CAxDRSptUGveCun2Xh
 CoPZqoze
 Byb4PgzuFpikwLqAJwS/aZQoG95S19M6QV0b6zak+Vc9dmBKmzI5uVO9wdn0bHkcFcekveZ8+tCQm7jL+7iAv1Ku7QWDdj6rLGL2CFsZ4uKIQG1D9z+aXaTT6TVYQRc7Gu/59nvdx5pgEjyXyKcVZich0iPi1Y+2w306B
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

SLAB_STORE_USER replaces the allocation track when an object is reused.  A
later stale free can then replace the free track as well, leaving the
report without the completed lifetime that created the stale reference.

Store one additional alloc/free pair.  Before recording a new allocation,
copy the current pair to the previous slots only when both records exist.
Keep the current free track intact to preserve existing SLAB_STORE_USER
behavior during the reuse window.

Print the previous pair when available.  These records are diagnostic
history and do not infer semantic ownership.

Assisted-by: Codex:gpt-5
Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
---
 mm/slub.c | 45 ++++++++++++++++++++++++++++++++++++---------
 1 file changed, 36 insertions(+), 9 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index 0653def0fe36..355fbffb981f 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -329,7 +329,13 @@ struct track {
 	unsigned long when;	/* When did the operation occur */
 };
 
-enum track_item { TRACK_ALLOC, TRACK_FREE, TRACK_NR };
+enum track_item {
+	TRACK_ALLOC,
+	TRACK_FREE,
+	TRACK_PREV_ALLOC,
+	TRACK_PREV_FREE,
+	TRACK_NR,
+};
 
 #ifdef SLAB_SUPPORTS_SYSFS
 static int sysfs_slab_add(struct kmem_cache *);
@@ -1074,12 +1080,23 @@ static void set_track_update(struct kmem_cache *s, void *object,
 	p->when = jiffies;
 }
 
-static __always_inline void set_track(struct kmem_cache *s, void *object,
-				      enum track_item alloc, unsigned long addr, gfp_t gfp_flags)
+static __always_inline void set_alloc_track(struct kmem_cache *s, void *object,
+					    unsigned long addr, gfp_t gfp_flags)
 {
 	depot_stack_handle_t handle = set_track_prepare(gfp_flags);
+	struct track *alloc = get_track(s, object, TRACK_ALLOC);
+	struct track *free = get_track(s, object, TRACK_FREE);
+	struct track *prev_alloc;
+	struct track *prev_free;
+
+	if (alloc->addr && free->addr) {
+		prev_alloc = get_track(s, object, TRACK_PREV_ALLOC);
+		prev_free = get_track(s, object, TRACK_PREV_FREE);
+		*prev_alloc = *alloc;
+		*prev_free = *free;
+	}
 
-	set_track_update(s, object, alloc, addr, handle);
+	set_track_update(s, object, TRACK_ALLOC, addr, handle);
 }
 
 static void init_tracking(struct kmem_cache *s, void *object)
@@ -1113,12 +1130,22 @@ static void print_track(const char *s, struct track *t, unsigned long pr_time)
 
 void print_tracking(struct kmem_cache *s, void *object)
 {
+	struct track *prev_alloc;
 	unsigned long pr_time = jiffies;
+
 	if (!(s->flags & SLAB_STORE_USER))
 		return;
 
 	print_track("Allocated", get_track(s, object, TRACK_ALLOC), pr_time);
 	print_track("Freed", get_track(s, object, TRACK_FREE), pr_time);
+
+	prev_alloc = get_track(s, object, TRACK_PREV_ALLOC);
+	if (!prev_alloc->addr)
+		return;
+
+	pr_err("Previous object lifetime:\n");
+	print_track("Allocated", prev_alloc, pr_time);
+	print_track("Freed", get_track(s, object, TRACK_PREV_FREE), pr_time);
 }
 
 static void print_slab_info(const struct slab *slab)
@@ -1366,8 +1393,8 @@ check_bytes_and_report(struct kmem_cache *s, struct slab *slab,
  *
  * [Metadata starts at object + s->inuse]
  *   - A. freelist pointer (if freeptr_outside_object)
- *   - B. alloc tracking (SLAB_STORE_USER)
- *   - C. free tracking (SLAB_STORE_USER)
+ *   - B. current alloc/free tracking (SLAB_STORE_USER)
+ *   - C. previous alloc/free tracking (SLAB_STORE_USER)
  *   - D. original request size (SLAB_KMALLOC && SLAB_STORE_USER)
  *   - E. KASAN metadata (if enabled)
  *
@@ -2024,8 +2051,8 @@ static inline void slab_pad_check(struct kmem_cache *s, struct slab *slab) {}
 static inline int check_object(struct kmem_cache *s, struct slab *slab,
 			void *object, u8 val) { return 1; }
 static inline depot_stack_handle_t set_track_prepare(gfp_t gfp_flags) { return 0; }
-static inline void set_track(struct kmem_cache *s, void *object,
-			     enum track_item alloc, unsigned long addr, gfp_t gfp_flags) {}
+static inline void set_alloc_track(struct kmem_cache *s, void *object,
+				   unsigned long addr, gfp_t gfp_flags) {}
 static inline void add_full(struct kmem_cache *s, struct kmem_cache_node *n,
 					struct slab *slab) {}
 static inline void remove_full(struct kmem_cache *s, struct kmem_cache_node *n,
@@ -4493,7 +4520,7 @@ static void *___slab_alloc(struct kmem_cache *s, gfp_t gfpflags, int node,
 
 success:
 	if (kmem_cache_debug_flags(s, SLAB_STORE_USER))
-		set_track(s, object, TRACK_ALLOC, ac->caller_addr, gfpflags);
+		set_alloc_track(s, object, ac->caller_addr, gfpflags);
 
 	return object;
 }
-- 
2.50.1 (Apple Git-155)


