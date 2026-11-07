Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 36F5A606A331
	for <linux-mm@archiver.kernel.org>; Sat,  7 Nov 2026 02:29:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=google header.b=fmr4uXm6
Received: by kanga.kvack.org (Postfix)
	id 4BF306B05B7; Fri,  6 Nov 2026 21:29:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 449036B05B8; Fri,  6 Nov 2026 21:29:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 337966B05B9; Fri,  6 Nov 2026 21:29:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id F3E6C6B05B7
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 21:29:37 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 81B59120214
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 02:29:37 +0000 (UTC)
X-FDA: 85406741994.21.A072EBE
Received: from mail-dy1-f180.google.com (mail-dy1-f180.google.com [74.125.82.180])
	by imf03.hostedemail.com (Postfix) with ESMTP id 84B2720003
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 02:29:35 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=fmr4uXm6;
	spf=pass (imf03.hostedemail.com: domain of songmuchun@bytedance.com designates 74.125.82.180 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794018575;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=D84DQ1ZFsGbaB0tFJcBVbDhJujxa9iUHJke70Js0NP4=;
	b=ULzvzzeaM4J7tUohoMxzX5o/03Usu7oDXD7LAXl5njmOVz/lNctDEubcW+4PFEXY7qE+tL
	qFu/+yEX+aglOBtA8IxtvYMfnpDKPz/WCv/C6uIFbPOHdFfz6BoP691PhN5JI4pjBXKmot
	lr/J1UT9dcJh8jqeIRczWDKGDKFm1Ss=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794018575;
	b=N6ujYPdN5qI2imJoya4BOEZlFcbnR3ZOEiqai1JLanTQh+vC3hfX1AgaARewPQILymLLhP
	is5LkBNfrU01yXLEml4XE/YRhwSbOjul9ep5vcy7OIgkIhGXaEf6AVPvEUqGQLpLsIP9Zu
	sZEk73tM4Ulm1JvxrqIEtsZeSk6eJHA=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=fmr4uXm6;
	spf=pass (imf03.hostedemail.com: domain of songmuchun@bytedance.com designates 74.125.82.180 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
Received: by mail-dy1-f180.google.com with SMTP id 5a478bee46e88-3712b6d9843so36669eec.1
        for <linux-mm@kvack.org>; Fri, 06 Nov 2026 18:29:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1794018574; x=1794623374; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=D84DQ1ZFsGbaB0tFJcBVbDhJujxa9iUHJke70Js0NP4=;
        b=fmr4uXm6SF5ze/XEgkBtLHtExxYhn5IUoUJnvu3RW2hcoybWa8AlmBI+3OzxkEC5pT
         QfzbWp0BCdmP8a99dsuTTRthNnoFbYQ1rxqHwAIUgH+3PfRKiQkYfaLRuUctQm7ldFY1
         fin84b4wKpogQujo6IUTJvFhYY72hbkCV/K1BdpHcTu7aejBf6aG/aOmwgElE9hEGhRl
         7oXUmcK+8G6DJnxaE98ytY8jxDywzVBzTjywBPIIMkxDyWKS81HcMPHb1mBAF7aZv7xu
         Z8bKhAAWM1b2ZghOgcSVP6TJ/Ax1v+rXne0HUBv4kIN8FcF1ZfxmZ+dHvRzgvvquzyrl
         CxWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794018574; x=1794623374;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=D84DQ1ZFsGbaB0tFJcBVbDhJujxa9iUHJke70Js0NP4=;
        b=IUMvc+tpuQz92mk5hhm+OaPkuMw0i1EwVLt993inIRQkw3HoQjlrjK359Ha7pDhh7J
         vSdbTRrc5UzmSQvm1R97dj8emp/Nrk+67SFBtqMyBt8EirNzZ5dakrmRk4WWSpDjiM+I
         DKyLYPak8oXVb4kLdtpXP+QrqaU16vH+9CPT04f86W0CgVE95uc94uXKaE2PGMK/WmUM
         lfhGu6159ACHvU6GJhkIDppBAkm8fYWXb9b5CiaQxL0AhJNbtmRxw9rH693RjI7ELk0T
         Q9jOGMmt1urOArM7dT+cRe8B6W8kiu8yPon141hjhH632V1A8nUu6tuZ3sORvIVuk8s3
         OfEA==
X-Forwarded-Encrypted: i=1; AL+hErGCHTV5Xs5fv55A3BvnA9CRaG0aiBKfu+82/OhuO7FKUaMuQPFzQOF1bAwG/H3ayL9TGY4ycxwd1g==@kvack.org
X-Gm-Message-State: APuU4Z8scZlzNPC76LXlMxibNlEkzdhRuvQ5xR4M5JKsW8pBzToefVlv
	IApWY3Q2pOdZ6JT7QggzFJcohbyYI4i8FThmDYRgrwUnv5Kq5oVf2xo58BTlyV+OBy0=
X-Gm-Gg: AYBFou0bSjC5tACeF0xJSLq6Ssj4o36+SugLvvx22i/BG63B4z649e0DMh06AQMYGYz
	T9/RK+0FZFuy+Gng877g6gG4EH24sxjfYWEIuPvVv5JN+IFg1IerSHJdbydyOcvcGtFka9C1U2x
	iGCf63VKwTeL0Wy5kGq76DL/HuzP3qLg3aZguLoNTijWXXfzOp1c1+nK+1Sl79+0HRYfjbKO+qX
	UZiKOp5pEe0zW/Va+oAqBwKfI8yOr/EFkCVUDkhBognu1byPmhYD5funqLJzINELfAVUr5AqjDt
	trqTv5x74Onl8gkoeG9cACFiQ8WBeD/jpz5bY8Et0YCf7WHRw1WMD2rFXY4WNeBtqz1rbh1edih
	oq8nuUNviICWBcChZfW/gILTlaI85rcky1vW2DXzlPJP0b5FwQsENb3uNpt47dhsiyKn3H/E3eF
	T1uqJUnQl1dtP2TazxyjlDcxXawJxf++RULuGW5L0JsyFUqztHgDnghDfZ+N8App5IP9UXK6Vwg
	2YoVkWQ0nL07Eu611rPAY0oDk7Agphst6c7uNg9Aw3UqELU5rH/iLox+LMzI8CWyFY9foIUVszy
	ZXiTerlTFT+sRRG2MNeb8djyPh2WM3QiBu5qkgZfmRSrNE22789eoID75iJc
X-Received: by 2002:a05:7301:c88:b0:36e:1fbe:357a with SMTP id 5a478bee46e88-36f75443c1cmr5569721eec.13.1794018574075;
        Fri, 06 Nov 2026 18:29:34 -0800 (PST)
Received: from G6L4RL2QG9 ([2409:8a00:1832:6900:c8de:13da:804b:a0fa])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-36faa4b8aacsm10457077eec.23.2026.11.06.18.29.28
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 06 Nov 2026 18:29:33 -0800 (PST)
From: Muchun Song <songmuchun@bytedance.com>
To: Oscar Salvador <osalvador@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Mike Rapoport <rppt@kernel.org>
Cc: Qi Zheng <qi.zheng@linux.dev>,
	Lance Yang <lance.yang@linux.dev>,
	James Houghton <jthoughton@google.com>,
	David Hildenbrand <david@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Yili Zhang <zhangyili01@baidu.com>,
	Kiryl Shutsemau <kas@kernel.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>
Subject: [PATCH v4 04/13] mm: hugetlb_vmemmap: simplify vmemmap head page handling
Date: Sat,  7 Nov 2026 10:27:47 +0800
Message-ID: <20261107022756.77731-5-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261107022756.77731-1-songmuchun@bytedance.com>
References: <20261107022756.77731-1-songmuchun@bytedance.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 84B2720003
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: oejisax6w64rwp5g7jhjg441upoagoj9
X-Rspam-User: 
X-HE-Tag: 1794018575-115473
X-HE-Meta: U2FsdGVkX18JtV3Bq7oldN/T6JuSnMVf+J1zJnsoXiQL2P4QQF+I/gMhOOfMub7nOcwXCCOJwREEeSTkJt338Ytsqqw1h+EPal819BZOhsZCjOS+TX4fsiz+x5Ct1cKCkO2w6Y43tUik0khn7VZSwSIxaFe8iBycLd1dIK33RzfGZJHKA3krdVgYy60UPSmPUYHiJ3i58e0pO7A01zpQCc78r1B3RQIYChJwld+HfavfXfplVktwm4XA0rUkjP7TTgjkoUHXzlVvrYSXbOErQMWQOuU4/1sBlpWBX7aA8KtQ0Ns+SRDb4wD9+krsK3VUFW15/o8nIo42yJxGmu1E0xFUsm3V/LgEFcez/BceMGK4xdA2Yqh4vHdnAqsvd4CVEim1ONfFk+Q6f7bh+Kl2SCipYzeP1hY7GrPSOzPrPLtL8GqrTnmZ1B4ZVc+JrYQxZymassPxD8NqCroZTY/3W9PyXEbFDh+SynykHu5U/x0YkgeUMkMupq5dvIM9ailRMuHUOx7j6SxRXiAxbwtJVabm7RSH8AUsf3EDpjwi7BVzgaD6nYeQXouKIVp8SMzzvPvvfXaPg5i6dHcqCR2YfP2/89FJXAMYgtzgVMtRXdYpI2zknuI60OxogDVNADi8RKZsw6f15h1ZqufQAfmkfApMeLgGpC3cSR+3P2sm5IwEEvDQXH1dUknSE4f67L5Ptj4vx3+XMsxFlegAwsn8wE23nIxoKjMUO/yfVS3ozdfj4iESINvFJeFfU0/GphxbR+nITh7zEP1N45dB/8PzUT4oP6DhyV56X+uDi7jRmtx8tZSMUkvWTYWKGhIkkdIAjOjWGgxbKwcGbklVZe8SuNzLJh0ac36+Xihbf0Gq75NENf2taiJRGOGJSwYiOaEIkLpQaTRLXeJBOji1zn1NhurgIiqE0TjWSe0llHInEchiT0xdy8PQ1DSQe3wm5NMSpAdriE4GQxMPboD1L2q
 ERCOjf67
 rPcqLuQsdC3Ou1Eu8uHShBRYHrLg7VT3hKs3nibqqTqRdenDZB1UPUToLvoXGz/TVml2c4higLa6MXx07Ld5BFzympCMc2kLvXu7oUmixARSLuY9JokUAlRB4r7ux9NiNwHsDOUoQUdoRAm5CvlNoDjPHAR2Ct8Q7m/dp9plvbtEPa7Z4C9C1Zq4iFom2eLbk+1cYzQF20ktynSOqpF/JipHOQq2XySMwhs4arj/lrC/rus5x891HpTwQIZqTvkAIYBR1fPEOX5V9qHR6k2X8fayQPOwL42AfYi21OFqfEOxXBJix04WXh0vPCTs2adkq+P4KvlDgNNbiU5Aww4PlGqwfp1XFMAFGaN3s2e4A5x+2OMW1aA4ObdXonHNielsKOvz5a4+LWZ3MAT7r2r8TmP5Gzxgv4HdRtXquU3XfJRQUGBHkf3+cRyUllvKOD9PzCDAb
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

The new head page is already tracked on the vmemmap page list before
remapping starts.  Passing it separately gives the remap walker two
ways to refer to the same page and unnecessarily complicates its
interface.

Use the page list as the single handoff mechanism for the head page,
removing the redundant state from the walker.

No functional change intended.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Reviewed-by: Qi Zheng <qi.zheng@linux.dev>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Tested-by: Andrew Morton <akpm@linux-foundation.org>
---
v4:
- Collect Reviewed-by from Oscar Salvador
- Collect Tested-by from Andrew Morton

v3:
- Collect Reviewed-by from Mike Rapoport

v2:
- Remove outdated head-page wording from vmemmap_remap_free() kernel-doc
  (suggested by Lance Yang)
- Document the vmemmap page list contract (suggested by Qi Zheng)
- Collect Reviewed-by from Lance Yang and Qi Zheng
---
 mm/hugetlb_vmemmap.c | 30 +++++++++++++-----------------
 1 file changed, 13 insertions(+), 17 deletions(-)

diff --git a/mm/hugetlb_vmemmap.c b/mm/hugetlb_vmemmap.c
index c436db31c6c5..beb420c57ddc 100644
--- a/mm/hugetlb_vmemmap.c
+++ b/mm/hugetlb_vmemmap.c
@@ -25,10 +25,9 @@
  *
  * @remap_pte:		called for each lowest-level entry (PTE).
  * @nr_walked:		the number of walked pte.
- * @vmemmap_head:	the page to be installed as first in the vmemmap range
  * @vmemmap_tail:	the page to be installed as non-first in the vmemmap range
- * @vmemmap_pages:	the list head of the vmemmap pages that can be freed
- *			or is mapped from.
+ * @vmemmap_pages:	list supplying replacement pages for the remap and
+ *			receiving displaced backing pages for the caller to free.
  * @flags:		used to modify behavior in vmemmap page table walking
  *			operations.
  */
@@ -37,7 +36,6 @@ struct vmemmap_remap_walk {
 					     struct vmemmap_remap_walk *walk);
 
 	unsigned long		nr_walked;
-	struct page		*vmemmap_head;
 	struct page		*vmemmap_tail;
 	struct list_head	*vmemmap_pages;
 
@@ -208,10 +206,13 @@ static void vmemmap_remap_pte(pte_t *pte, unsigned long addr,
 	pte_t entry;
 
 	/* Remapping the head page requires r/w */
-	if (unlikely(walk->nr_walked == 0 && walk->vmemmap_head)) {
+	if (unlikely(walk->nr_walked == 0)) {
+		struct page *head;
+
 		VM_WARN_ON_ONCE(!PageHead((const struct page *)addr));
 
-		list_del(&walk->vmemmap_head->lru);
+		head = list_first_entry(walk->vmemmap_pages, struct page, lru);
+		list_del(&head->lru);
 
 		/*
 		 * Makes sure that preceding stores to the page contents from
@@ -220,7 +221,7 @@ static void vmemmap_remap_pte(pte_t *pte, unsigned long addr,
 		 */
 		smp_wmb();
 
-		entry = mk_pte(walk->vmemmap_head, PAGE_KERNEL);
+		entry = mk_pte(head, PAGE_KERNEL);
 	} else {
 		VM_WARN_ON_ONCE(!PageTail((const struct page *)addr));
 
@@ -284,23 +285,20 @@ static int vmemmap_remap_split(unsigned long start, unsigned long end)
 }
 
 /**
- * vmemmap_remap_free - remap the vmemmap virtual address range [@start, @end)
- *			to use @vmemmap_head/tail, then free vmemmap which
- *			the range are mapped to.
+ * vmemmap_remap_free - remap a vmemmap range and collect old backing pages
  * @start:	start address of the vmemmap virtual address range that we want
  *		to remap.
  * @end:	end address of the vmemmap virtual address range that we want to
  *		remap.
- * @vmemmap_head: the page to be installed as first in the vmemmap range
  * @vmemmap_tail: the page to be installed as non-first in the vmemmap range
- * @vmemmap_pages: list to deposit vmemmap pages to be freed.  It is callers
- *		responsibility to free pages.
+ * @vmemmap_pages: input/output list whose first entry supplies the new backing
+ *		page for @start; replaced backing pages are added to the list for
+ *		the caller to free.
  * @flags:	modifications to vmemmap_remap_walk flags
  *
  * Return: %0 on success, negative error code otherwise.
  */
 static int vmemmap_remap_free(unsigned long start, unsigned long end,
-			      struct page *vmemmap_head,
 			      struct page *vmemmap_tail,
 			      struct list_head *vmemmap_pages,
 			      unsigned long flags)
@@ -308,7 +306,6 @@ static int vmemmap_remap_free(unsigned long start, unsigned long end,
 	int ret;
 	struct vmemmap_remap_walk walk = {
 		.remap_pte	= vmemmap_remap_pte,
-		.vmemmap_head	= vmemmap_head,
 		.vmemmap_tail	= vmemmap_tail,
 		.vmemmap_pages	= vmemmap_pages,
 		.flags		= flags,
@@ -550,8 +547,7 @@ static int __hugetlb_vmemmap_optimize_folio(const struct hstate *h,
 	 * they can be freed by the caller.
 	 */
 	ret = vmemmap_remap_free(vmemmap_start, vmemmap_end,
-				 vmemmap_head, vmemmap_tail,
-				 vmemmap_pages, flags);
+				 vmemmap_tail, vmemmap_pages, flags);
 out:
 	if (ret)
 		folio_clear_hugetlb_vmemmap_optimized(folio);
-- 
2.54.0


