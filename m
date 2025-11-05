Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 006F5CCF9F8
	for <linux-mm@archiver.kernel.org>; Wed,  5 Nov 2025 17:30:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5D85D8E000F; Wed,  5 Nov 2025 12:30:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5AFE08E0002; Wed,  5 Nov 2025 12:30:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4C58B8E000F; Wed,  5 Nov 2025 12:30:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 39EF78E0002
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 12:30:42 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D9A62B91E4
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 17:30:41 +0000 (UTC)
X-FDA: 84077243082.20.60C42D7
Received: from mail-ot1-f44.google.com (mail-ot1-f44.google.com [209.85.210.44])
	by imf15.hostedemail.com (Postfix) with ESMTP id E18C1A0011
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 17:30:39 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=BzvobUrk;
	spf=pass (imf15.hostedemail.com: domain of pedrodemargomes@gmail.com designates 209.85.210.44 as permitted sender) smtp.mailfrom=pedrodemargomes@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762363839;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HtG8m3lKC5YzUVxybdhftXK279x1q4y+tfqJb0ojn9g=;
	b=pEoRjWe7zyM1833psdCKryD6eMTNaE0nqljcbQwlVaqAJ27MeGv6ofeNl+RpLGl1E4WsPL
	swKAl9cqiood7T1C+MLvu3/QN0D5McqSwSaFHk7m9BrAd5ynQxWHB9f/v36jHHxwH2E7JJ
	u2nr8ucLGhJMEeVYI8S34dGNJGb5Nzk=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=BzvobUrk;
	spf=pass (imf15.hostedemail.com: domain of pedrodemargomes@gmail.com designates 209.85.210.44 as permitted sender) smtp.mailfrom=pedrodemargomes@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762363839; a=rsa-sha256;
	cv=none;
	b=0OfNH5+7jJZK5fWOnO8WfaLXSgDD2sQgNxNQUaJ7JO3kPFnP+/Od9SFdEJM85F9mWaMVtl
	yeFRwQygO+xU5PPn0Y9qBxPAyO7GV2ux8VoPpbXS1hOs3X8ojJ0xYmmGTthTmAy9g2+nRo
	NlmtNqhb7zqYyNVdindetpMbsbz2prk=
Received: by mail-ot1-f44.google.com with SMTP id 46e09a7af769-7c2878bdf27so3928151a34.2
        for <linux-mm@kvack.org>; Wed, 05 Nov 2025 09:30:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762363839; x=1762968639; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HtG8m3lKC5YzUVxybdhftXK279x1q4y+tfqJb0ojn9g=;
        b=BzvobUrkemZ2UyRaVxmpwVsRSqNU+LmXtCs52AkO2UtLJIqf1qzlL1wdb34HKqw6hD
         r6v7dPy2Yrf/uNcL+NaRLBJMuhfxAhDIsaS6sE+rRw0YI3n7jtnyJwgTMySTloVv6e7D
         X7X6n5cjsJZmEmDlLivS7IfLNXRvtSNDIzbGqFkjNl5fJJPHtQaLA8p4hK82juNs7mxW
         H3hLWkIUlAtM0Mazw13AL5v/T4n9Gi0N3XqQAFiNXfQgm27GBmBU9w850cvxJDcxCLig
         f0ljPiQri7raJ6L52P1UG+sW7mFqsmubhdx6qQ5rbDUF8+7LJtDEjU+WL1buolECIeFn
         rUVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762363839; x=1762968639;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HtG8m3lKC5YzUVxybdhftXK279x1q4y+tfqJb0ojn9g=;
        b=u7V4WCHXrXFfoB1n5dC59e0r9NDwdsm168oFZClWYkbUcxwikEUzp1WZBQnw2RkADC
         Y6TUlAGuUP6QqM0P1R3mKi4ITvTparr52Z62+n9iNnd824xKzshAQfyN80ZsGlE88TqV
         zEy1SMxTzREC6nvzpSw+ubzuLhurAMbKjnk3RtucFSW1HIQGevpp3Gmq/avF/XJ8qOmu
         d0B3B281gkSK4d57/TCmKxJ24J7xFDBPlsACxqf6fHe0wxaPkgPJ9421oQ7zTocyOYNM
         YONUNDvRya7zo4fPkPTbDV/9TaIk1bki/EJNAnAed4AV9wWyBx0d8jq7FYRahqbkBZzM
         svZQ==
X-Forwarded-Encrypted: i=1; AJvYcCV3o4LGfQMo25zJ7ORt44P3R7xPkeFVlhGOiQNSSK2d9g3sId0+rGMWRe1kgnwRZJDyMrgrG4nhSA==@kvack.org
X-Gm-Message-State: AOJu0Yzad+P0O2Gct61ZiZ+YCpCuoGG4EGS1BHJcl+CRqf8mbYWjxWjb
	LPf8REuHSPFwWPYPBwhiPFesAoIK6x73qdu2gE2WWcS0c+r51tOlQUwg
X-Gm-Gg: ASbGncu6MCXiF+O6JbryN6kMF5X+O7D/ylY6piHAAbnPJO3GM6BiW6C0hTs4+qwTU97
	Nt4JHfUbjGuKS55xtzlVAUHVmNQGVO1mgK0/dYIzraXDhSOYoPgUgPDvCSQl2qTn5pwO4qDVkX4
	ogXhvemLSqE7tK4SHgzuSmPLWRzGrKh/+wbMzOu1dan4uXCcsKwjm7U1ni0vHJcB/fM2TN7siw2
	lqEpiv7TR5+BsAzMJTENX3n/u9ZKOb7ux0oiJY+btIyRZTI+DyOjpAu2kMatvLepZTrqQ1xl6rQ
	yg2gkjZwYFiwG6OBDaLchxCG4wOwzgntLmtQnRage/ARokc4EPkfrlc6eJACF036NU+1e4nsylR
	D9s/syP+VdqnPWfDPJ0Xi4GODEVXGnIouWIYTy5fpRrSuKyLm4/ZdbW3lcR1BSxRw2ey4WX0KGb
	0F70c01p6rXIIegR9QPO4hxsdMBDUzP/S1op0/ZluwD1uLak0m6nwZ6H9m
X-Google-Smtp-Source: AGHT+IFsqa3f21t/TPiouRwC1NNyll3RzLZxNHIyUXMLTJDkC0oghDxR3kOoLF+y4ihKIeUnycY3mA==
X-Received: by 2002:a05:6830:3155:b0:7c5:411a:9204 with SMTP id 46e09a7af769-7c6d1106516mr2563202a34.0.1762363838805;
        Wed, 05 Nov 2025 09:30:38 -0800 (PST)
Received: from weg-ThinkPad-P16v-Gen-2.. ([177.73.136.69])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7c6c25108b3sm2248313a34.30.2025.11.05.09.30.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Nov 2025 09:30:38 -0800 (PST)
From: Pedro Demarchi Gomes <pedrodemargomes@gmail.com>
To: David Hildenbrand <david@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Xu Xin <xu.xin16@zte.com.cn>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Pedro Demarchi Gomes <pedrodemargomes@gmail.com>
Subject: [PATCH v3 3/3] ksm: replace function unmerge_ksm_pages with break_ksm
Date: Wed,  5 Nov 2025 14:27:56 -0300
Message-ID: <20251105172756.167009-4-pedrodemargomes@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251105172756.167009-1-pedrodemargomes@gmail.com>
References: <20251105172756.167009-1-pedrodemargomes@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: E18C1A0011
X-Stat-Signature: gdgtf3hok1o86cfj7ycakkkc3w11fbki
X-Rspam-User: 
X-HE-Tag: 1762363839-727030
X-HE-Meta: U2FsdGVkX1+iFIeM8xaP4DKhp8QEtg9oT234gOYma+DvDA1Db1s+acBz2DEEoxvz41vPKgSGt4sUjiDTHDxh12o/TgZCQ0fTvHUPXgO8wOOYvr3UeTcBDmK+ZGsnMxAkqE2Z5SNtYIDvriB4H9gFvJ/bfu6pBKsvx/jKNMrnEa4bzduN1TJ7OJL0kpVMI16+4Y36XOQ1esGsOOLbkDf4m5Z0VMljMWhV0kB/n3OFArI6tHjBeYl6k6jjF56o9JJl7Hb+63G1DLl63c0t9lF55DOqnM0P1FVyqKcIPEKwV4t9oCoqU7uKGNybawJeDjj2KXQgj3nHmrB9sQZKQd7kIVpej6mbtpE3SXQdByk0W6yUMSFQDnJuM1NSHINy2grQJqbAHVyfadM3C5ilGTAyQ8T3sdyTYVsQ0f3QBEJvQMyqsYCPZQBtW66/DBltm4IRAB7diB7VtoXUdoz1uGzeTAmBQdn7WJMGxkPDlE1Ls9GC6OQcFFcJCRB4DJJUfh/3WBKmEgQ5n1Zf07NmVvIuWxt6vETxpvbVt2db/mrLq8b7bFUJiNUJLBx0Ej+gGvrOFIX694PBUtBxWDRu2u8dpdKRBrRBZeenIqHCAXV65s/yWKoxhRQahql2No2tdAElj7iG4Y0z5TQbp+iYx8y8P61kPGKu3HIrC3ZFd28DuI5IRSPdb/lzi3AiBDUDTN/eEnjDe+CsVz0oWYATQ9weqT0NWoT6saZ+Bi5DeUEYxSaze9HVY008AYQ6LBsZ8/wrzyHalB19x5jkNwrCbyRdoeMiD1QVgYrOm9O59CiVvzHP2cc3cTKg4FZA7GtjOV10Lk13jIVp+N5mhDN+I8fyQG+Iwq72UkjDzvqtqt10WvTyoeoFcPMt4ZWg41P6jkVgkRj9shC9yYESv0ZZTOtV8tyuKPJKNjnMOy1dP2/IjRpekv74JaYx4f5Xs68nTr+L0+xVzfyW09XKaA3oRSx
 8IhTVAKz
 HYzeZuC7s+DHzDuS433vPyJC+2hsHR1l4hVQP8KOooqLNUHZNsnyO49dqb25EzliOx3uwHj1zkwq2fhAwzaFV5NjPmvk+qMh72aTNi0+z7FCmtQv7xh4HHniyjKf68adE6o5Mgdy1eTHL8h5AYRTjaeagB35KyVK498Zdic69I4kHXV4WSjvCBsnRTVLeauYH6LnuCaXIV5OFI2FoejGs/GSpnRqbK1Jk0ytKPU5olst8ih/HCJ4qBjUy+eVme03ZFW8B2e6gzCI+nzm3R3a8ASW1ZDcvytsLJr7K108G+vSwYVnfPbmt/N5KN4GKvuGtUOLQilfuQu2CYMMuaCSkmETDYVLRGQjrcEMhofqYkY2z4K4RoC8yQaHiteXKTpvuL3Ik0Y9yMM2AQVY2PWEmQv0VxkpEb8QBow+o2xdRrXjTxtSJbR8kAICNnQ9yGaMwxSC9pOTjncg6ssYet/u64pGKJv/RQiTNlUdWX84kkXCdiSI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Function unmerge_ksm_pages() is unnecessary since now break_ksm() walks
an address range. So replace it with break_ksm().

Suggested-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Pedro Demarchi Gomes <pedrodemargomes@gmail.com>
---
 mm/ksm.c | 40 ++++++++++++++++------------------------
 1 file changed, 16 insertions(+), 24 deletions(-)

diff --git a/mm/ksm.c b/mm/ksm.c
index 5fe3d9c2cd20..a78346bfeb91 100644
--- a/mm/ksm.c
+++ b/mm/ksm.c
@@ -665,6 +665,18 @@ static const struct mm_walk_ops break_ksm_lock_vma_ops = {
 };
 
 /*
+ * Though it's very tempting to unmerge rmap_items from stable tree rather
+ * than check every pte of a given vma, the locking doesn't quite work for
+ * that - an rmap_item is assigned to the stable tree after inserting ksm
+ * page and upping mmap_lock.  Nor does it fit with the way we skip dup'ing
+ * rmap_items from parent to child at fork time (so as not to waste time
+ * if exit comes before the next scan reaches it).
+ *
+ * Similarly, although we'd like to remove rmap_items (so updating counts
+ * and freeing memory) when unmerging an area, it's easier to leave that
+ * to the next pass of ksmd - consider, for example, how ksmd might be
+ * in cmp_and_merge_page on one of the rmap_items we would be removing.
+ *
  * We use break_ksm to break COW on a ksm page by triggering unsharing,
  * such that the ksm page will get replaced by an exclusive anonymous page.
  *
@@ -1071,25 +1083,6 @@ static void remove_trailing_rmap_items(struct ksm_rmap_item **rmap_list)
 	}
 }
 
-/*
- * Though it's very tempting to unmerge rmap_items from stable tree rather
- * than check every pte of a given vma, the locking doesn't quite work for
- * that - an rmap_item is assigned to the stable tree after inserting ksm
- * page and upping mmap_lock.  Nor does it fit with the way we skip dup'ing
- * rmap_items from parent to child at fork time (so as not to waste time
- * if exit comes before the next scan reaches it).
- *
- * Similarly, although we'd like to remove rmap_items (so updating counts
- * and freeing memory) when unmerging an area, it's easier to leave that
- * to the next pass of ksmd - consider, for example, how ksmd might be
- * in cmp_and_merge_page on one of the rmap_items we would be removing.
- */
-static int unmerge_ksm_pages(struct vm_area_struct *vma,
-			     unsigned long start, unsigned long end, bool lock_vma)
-{
-	return break_ksm(vma, start, end, lock_vma);
-}
-
 static inline
 struct ksm_stable_node *folio_stable_node(const struct folio *folio)
 {
@@ -1227,8 +1220,7 @@ static int unmerge_and_remove_all_rmap_items(void)
 		for_each_vma(vmi, vma) {
 			if (!(vma->vm_flags & VM_MERGEABLE) || !vma->anon_vma)
 				continue;
-			err = unmerge_ksm_pages(vma,
-						vma->vm_start, vma->vm_end, false);
+			err = break_ksm(vma, vma->vm_start, vma->vm_end, false);
 			if (err)
 				goto error;
 		}
@@ -2855,7 +2847,7 @@ static int __ksm_del_vma(struct vm_area_struct *vma)
 		return 0;
 
 	if (vma->anon_vma) {
-		err = unmerge_ksm_pages(vma, vma->vm_start, vma->vm_end, true);
+		err = break_ksm(vma, vma->vm_start, vma->vm_end, true);
 		if (err)
 			return err;
 	}
@@ -3007,7 +2999,7 @@ int ksm_madvise(struct vm_area_struct *vma, unsigned long start,
 			return 0;		/* just ignore the advice */
 
 		if (vma->anon_vma) {
-			err = unmerge_ksm_pages(vma, start, end, true);
+			err = break_ksm(vma, start, end, true);
 			if (err)
 				return err;
 		}
@@ -3389,7 +3381,7 @@ static int ksm_memory_callback(struct notifier_block *self,
 		 * Prevent ksm_do_scan(), unmerge_and_remove_all_rmap_items()
 		 * and remove_all_stable_nodes() while memory is going offline:
 		 * it is unsafe for them to touch the stable tree at this time.
-		 * But unmerge_ksm_pages(), rmap lookups and other entry points
+		 * But break_ksm(), rmap lookups and other entry points
 		 * which do not need the ksm_thread_mutex are all safe.
 		 */
 		mutex_lock(&ksm_thread_mutex);
-- 
2.43.0


