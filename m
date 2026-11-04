Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EF90E606A32F
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 02:36:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=google header.b=EwhwUjkC
Received: by kanga.kvack.org (Postfix)
	id B61586B05B4; Tue,  3 Nov 2026 21:35:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B11F46B05B5; Tue,  3 Nov 2026 21:35:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9D9696B05B6; Tue,  3 Nov 2026 21:35:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5BE2E6B05B4
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 21:35:54 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1F2B84062B
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 02:35:53 +0000 (UTC)
X-FDA: 85395871386.27.026C46E
Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	by imf04.hostedemail.com (Postfix) with ESMTP id 23B8140003
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 02:35:51 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=EwhwUjkC;
	spf=pass (imf04.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.210.181 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793759751;
	b=WI40cL/6k9fR7wl4q3hobJ3Cwmq3Krs2sdhkgLNASclA6+l6HD5cd7WwZd7NpHmDc+sH0s
	5JG94IlpmfVaUCXqJvIQe8Tp4ScPW0uxIiUJfDNUDiZ5NuvwF1s6GgFO9MzGvStt0r8o45
	BGCRybe4RPeFYatgMUxoBuYcaap9MJY=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=EwhwUjkC;
	spf=pass (imf04.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.210.181 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793759751;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hOa7vqp2KlJWIdXBbWPx3RR6P0EHXGn9DPhaIIX40Uk=;
	b=zE0PrEoqctSBBcckQvmCaXmV5HiNnsgbNwY+/KWO4Cs/4kEPY8vCTM8B0vGtHKlQ2EaN7O
	IIruhIKpSZsFLJfzNlqxlNcktZkcBsJeoTRDXCWz/Ha5Oyq0OXsS9Cu1q4XKa+OcdVhQDz
	qrGNtZTVFxNXXASml3guFiU50biPekQ=
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-886e61fa30fso126879b3a.1
        for <linux-mm@kvack.org>; Tue, 03 Nov 2026 18:35:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1793759750; x=1794364550; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=hOa7vqp2KlJWIdXBbWPx3RR6P0EHXGn9DPhaIIX40Uk=;
        b=EwhwUjkC3av8pF8hbEvtIkjAvS/rBnlHdNwvpvwB2X06ehyx7pZJ8jXSPa+3LWzP+n
         U+X5cItFDWlnpMdFlcI4cKM2I5RBKMqd6QVzGI+eO+I+i+nN6UKQ8ytfkVNRYHOJUfUE
         OnKaA5aEdMryHkDVp3F0rNU1w+xum4GUoQ7XiJ8hqKZklZ8aURDqMwx5vQMztFg8fZAT
         kxGwl4F9+WLfTokJW3R3yyINY2QSnAPNYznatfdBfjgccxzHW4dSSFjvW7duyNmYBekV
         tRX+3WmFCFV177wVESnsI38nj01w/Zaft4ZonFF1ZlWwf88KFI+C51apa4E+AtzjIXjk
         QPfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793759750; x=1794364550;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=hOa7vqp2KlJWIdXBbWPx3RR6P0EHXGn9DPhaIIX40Uk=;
        b=pq7Oe1vx63kblsZpMB9reCVDQJX0FH3yHCRK1F3M6ZFsyP8Ud6/FnmnrV55koaIfor
         fFEcab9s+UHJW4AMxQJWfbvPfjSojzRavWJUu0wiUV25k/rnqXB1ZMq+HNmB6rawsxYM
         KoVeyOVlcVLHiRUKZhS8vYWx0HGIQ/tWRFee2heSA3Wmip8g8b2FvC4+8tNssZ0I0dFF
         V1s92yqW7un7l0XB4njYv9PORnL7YmjNm0ngiGfPWA/jGf4DPVG6xs9gDRjefU0ptUod
         TxHRAzaxgXEeNnnjA1NSOaH2fj/ZBFbkDyQ9GwEJWQDYX7VLcoD6g0U0KV19mrRYduRz
         FKBQ==
X-Forwarded-Encrypted: i=1; AKwUvBySKO+mgZ8DFCYWso9O2Xky1/nZgoDYHkUjNlMx/c1EJ2cheYphjkZgREdVywEdqkWBAjZC89aWVA==@kvack.org
X-Gm-Message-State: APuU4Z/6euEzUCWI6OHKc58koja6IB+w4a9RMzr0E23pKBlZ4CHFBBis
	llZ1GY+7yZ4N9mVHpcL4h27HkqYKe2jV4qYLQHaK6wE7CHrx2pg6VD+m04kBkO1zZQTptoPluVF
	wy88v9iQ=
X-Gm-Gg: AYBFou1OmsjphIwwTLT/VG6oN+mHv/a97ku2jQSaKeIsqxtN3MFV+mLTVIbQ0PR3TzM
	SaZoerlVwg8arnbMu8/UzR6rz9euHqmVi9XmY/fUC7lZK7+7NZE8Zfqv9Hs+Gg+7gFZNCaYzTrL
	kB4uGBWbNdsbAGleqweWnPNG0VngTMbSnguwUX40o+8fID/msu3HjiSo6q53TwPrUj09wzAOjuf
	jWnf7oE4kgxGW02muBKa9ztGqF/oPVJzDVzGoSwoI1DA5fyJPw3SILGw4gv/L6n46FHBJjyfsak
	v17bXiY4G+Zc0PsoNDSOAglTkMeEwr3xwAx0ErE0HJPccAr4pVCxJFShBkmwlNVGaGDrna1IZpm
	ybbqxeBZi3VHO/VYMU0nbWAyrSJ1pcEtkVeJHylEpSS2fRJa/c+x35D6ZxiuZ+EaCsQEsEVE+7M
	Ty0xFdzrls7g4awoQVJlLL4lLBMLKEJTEdaIg+LwoqL1gOOzpsUH9dirrW0ZgVbeZPJz+ikWJ2H
	ml1cmXFkdLYtGUd1H6OmJvQU0admutHA9bt++Z+zOeT+H0HWlllW1Pr9aIqN+91dQ3pUfzl4Gci
	EFhqBTEbjTSfc0zuMBbqsQHguFqvNHFWT6Vn0WCeqYZxkrtOpB4sJkijmd+uskE3BoafOb8=
X-Received: by 2002:a05:6a00:600a:b0:8a0:f375:d1c0 with SMTP id d2e1a72fcca58-8a9bf047eb5mr11162027b3a.33.1793759749961;
        Tue, 03 Nov 2026 18:35:49 -0800 (PST)
Received: from n232-176-004.byted.org ([36.110.163.99])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8b09bc3d1f2sm240815b3a.50.2026.11.03.18.35.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2026 18:35:49 -0800 (PST)
From: Muchun Song <songmuchun@bytedance.com>
To: Oscar Salvador <osalvador@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Mike Rapoport <rppt@kernel.org>
Cc: Qi Zheng <qi.zheng@linux.dev>,
	Lance Yang <lance.yang@linux.dev>,
	James Houghton <jthoughton@google.com>,
	David Hildenbrand <david@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>
Subject: [PATCH v3 03/12] mm: hugetlb_vmemmap: simplify vmemmap head page handling
Date: Wed,  4 Nov 2026 10:35:01 +0800
Message-ID: <20261104023510.260766-4-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261104023510.260766-1-songmuchun@bytedance.com>
References: <20261104023510.260766-1-songmuchun@bytedance.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 4j1jsbb1dakx3s13p9a1s9e137hnu99p
X-Rspamd-Queue-Id: 23B8140003
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793759751-885145
X-HE-Meta: U2FsdGVkX1/K1BhSC3GYHEtuDUiEgk3013BZTe8V0hzJS4oIidMPnD/HANh0eGzq0oV8FDo99bYnyM8P3UXp0IgzRVbUNQbkUujTc0jsq8dKncKeYZno4i61tvC3nEJuXo+jEuCwFLHQhbrqJxKYOdNQYzahmuZdaesrqTCkg1ubj8+j3jg6O0V6uJplQ4kflhaODX2jLjHbGi7Vnc4Lf8KgqAypbLUIXrETKBn7aHbVQcPRORiYvtKT9oh5e+BGDA71dbko0lyhTT1P3cehFd0e80GEZcg6TBFFsrdf532nXHh+j03848sJLEEbbFed+mpwoeOZbBg9HW2H8l2PFu5EK5+wj7Cz4aJlINkMBCCVBqBLG4DBN9IqAFBXjmcMC/vrGZkFNfmNwTV+9IWy8Xjya9o/aBo1xix7aYZkCTzr+mFGPpRZc+63Exai5q+M0vuxlJz40KreeC+cYPR/OJmYmQd6j7A4kuOpOHSiiKSzVpH9SdFL7sd8gkFyIaBpg12YyogiICmx7W4jJmCKFZJPHJhJJo+qbNx50MuKXYI1UH6V8QtSI3gK4M4Nn9kYel5mjLmIhUobn5KinQZBk8ah66EYNg8UyVy0Yae/9eQjwxXqrTlXrssWAtYPP1jiMtP35Tq0eFsiJuXnxAnzQLhI5QiuKjhNOiVNost9TxAg37D7Y/kaiLDu0otjyXf/JDqhdfo95UwwI770JwglhMumFDNPnd5r3BAdeyAnJXlT3dx+gknub4NhhZiv0XaKJru+dLjABM4F5Ce9V4p+syaHMe2WMsitOPC0C8e/mpSlyJo18osHYeM3FParjg80uMhdva8Vi2MfcZXYSPRI5GoFw8bKKtpcwzwC+wuPRYuQXfyzYsODAX1ncVHDnsOfRBuYMkSJ+cKflzGbJRZ0b6JWfRyn45QRvcXtvwmNwmSSSYb3QAHH0KnDAawUEoCSVpLoCVqUQab5m2+UsIy
 +hgNMHyN
 UdfncmapgKqO8NkoHdNHUGHasaDuBoncuyuU12n28vkroW9N1gmBXSFCv9QYvxk9LSonPZz5WmzJoM9SJbxWTTRnmY20u5KrhP4HhtfTS3Rxz2OSBAUjUHmI9Jy1ZYfYGc0URME3uuAwUkblCeAr/fNh6LZ3fBr/bMVizfTDhk5oZ3yMMP4Ud6jXOLXWYVH0/62YNerpmhg1TUrwrIa6hlSY43GJOrqZmZjcmQXQkdLO4y7y7VJU39ghK5OdUsdGnY40ahCER4VOq6MzErunncN5Lq78ofDU9VfdnQry0Tnd7NpHcgvE+4j5BKn2AklC+Dz8w4jmfmkRlgOcREZulvXts/dlyLf5z3D6e8hjoOfN8mMgDgnsZHfBjWWI8p7AGemPJ
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
---
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
index 63e899cfaac3..0e5b2b182d1b 100644
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
@@ -549,8 +546,7 @@ static int __hugetlb_vmemmap_optimize_folio(const struct hstate *h,
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


