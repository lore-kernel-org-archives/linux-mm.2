Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B7F7DE937EE
	for <linux-mm@archiver.kernel.org>; Sun, 12 Apr 2026 19:01:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1E0D76B00A9; Sun, 12 Apr 2026 15:01:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1B8856B00AB; Sun, 12 Apr 2026 15:01:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0CE936B00AC; Sun, 12 Apr 2026 15:01:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E939F6B00A9
	for <linux-mm@kvack.org>; Sun, 12 Apr 2026 15:01:18 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id AFE821B8F47
	for <linux-mm@kvack.org>; Sun, 12 Apr 2026 19:01:18 +0000 (UTC)
X-FDA: 84650821836.03.604F301
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id D221CA000F
	for <linux-mm@kvack.org>; Sun, 12 Apr 2026 19:01:16 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=BKqWaEcJ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776020477;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pfP4XnZDsnDT810wJI1lXar2Fs2sH3hmNjKuIvWox04=;
	b=2Q3S0S9NX6dW84PepTtc0DEK+ZbW9Y+c3tY2k84v8pEqEv9wVi4EwrQ3Q+J5HhMuWabOWd
	T6EVFI0ID0wj0o9FtVzif/zgjuZ4ksl2RUw76ZDzat+0+4i8f3oJ3ccWOLtZOvbB7+Xkwm
	FoI1HEumWh4S8+jmyJgBKp9EgHR+iW8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776020477; a=rsa-sha256;
	cv=none;
	b=MaXY4MioIVZ6+bQSuZxPogZXQAJhlAl5wkM/x+0wLKk6An7jsvAkESJWkjEdK1p+aIxYRJ
	gu/QFlLVS8Z2ZKaBiyT8nVOI9dqqJQboQouCJxs2vblSFOASoSSFv4OlfHqeiDdW+VmD5A
	6WeAJwjuG9xVf7a5jeBVoOrJ7pCIE8E=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=BKqWaEcJ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 059A94064B;
	Sun, 12 Apr 2026 19:01:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0F8AC19425;
	Sun, 12 Apr 2026 19:01:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776020475;
	bh=75B3Sn7MVipkRyt3ca6vBN0Fy65OWdrpROiMT2it6RU=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=BKqWaEcJ+ZORRiArbkuZkg8xbXuXikiCRf0z1gsWnrRW3aTdA5Cl9LCAVkUrEVf7H
	 LrpkE2RhqWvU4XhQxq3sfsOfxpF8DjYFlOlBTZqWLcco/EwF4+LS2uhcMjBA60Lstq
	 XXUkYUi+z1JQ6IclXGlZtzdWaPB7g2GMV2zmssLvnpCOTGWCdGVmKQqs5E7KCTZlag
	 4M2rT9q26kl6qhuiBzhZUwHEwmSGXMJfw0kTKUyGtj74WKZ2hyPyOuHYw4gn+O1c9I
	 EJdjEcpRHat1Uwh/DHSRj8IeQEKOORylIVHfK6Py1xb7eOkbsT6mzx8+ur1G/8G4nd
	 srNY+Zm28Otwg==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Sun, 12 Apr 2026 20:59:43 +0200
Subject: [PATCH RFC 12/13] mm/rmap: large mapcount interface cleanups
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260412-mapcount-v1-12-05e8dfab52e0@kernel.org>
References: <20260412-mapcount-v1-0-05e8dfab52e0@kernel.org>
In-Reply-To: <20260412-mapcount-v1-0-05e8dfab52e0@kernel.org>
To: Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
 =?utf-8?q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>, 
 Jann Horn <jannh@google.com>, Brendan Jackman <jackmanb@google.com>, 
 Zi Yan <ziy@nvidia.com>, Pedro Falcato <pfalcato@suse.de>, 
 Matthew Wilcox <willy@infradead.org>
Cc: cgroups@vger.kernel.org, linux-doc@vger.kernel.org, 
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
 linux-fsdevel@vger.kernel.org, "David Hildenbrand (Arm)" <david@kernel.org>
X-Mailer: b4 0.13.0
X-Rspamd-Queue-Id: D221CA000F
X-Stat-Signature: futwao83qhqraz4uo3ghx1s7q73eautg
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1776020476-195112
X-HE-Meta: U2FsdGVkX18cFlSDmyIg6QMfnTpRNCUh4mx2wnhdbe+oiaZayb5qQAzaoWs4FShu2CpLRKVwHX9AT7j3rkOrVSat3dKJOGhJskUjMtYUNR1xnj9fIGxrNw/q6kJu4JNxivSwRdjkYnIfnrexHzvo66OavOx0DDnmFZBAbv6Dy4hTpzMZKrLyhFCuXQulpKlp7ssFvl2jL15YpcZLMvFVfObZpzQMpqReO6PSkiW/tdG8avB+hWaQ9e2bZbPXqBidM1oRpL4yz4D4p0jcIsKVXxNt0sH4ghN9hCfRtmzNwCrFRQ6M3ptb2vs6LthV6gyA/1GQK/X1Cjm2NQ86bmvdxZZ2o/iMcGCGcn8sabm7Vz0jqiT08jI2ceqVyJO8qsSt805M2DELw2adauC+lu8je7go6+eGSFSl2eSQkNmd/oW3SK4X+SOjqh/oOtDgBVjCL4pRAWb/oo5qR6BIUvxsaFgofD1ov1Ysd2ZD+nedGf2LFx/JAYtEanTvOy3DbpPXtvObAmS1rv6lvzGyMHFsHE1t7zcdtK/Ku0Y6vvRbVaHblAPCD24ZN1guYLzufejjrVLr9xe0USU5stwuBVODo6GMHMIMGELtatgmW3xD7t8goPp0FO+GSsDSYidOQkjK9t4NblG1pew0IyAdWOxebim9ShRj+tzAwz12Z8WvbhB8/2h8z1nEEjHlohqk7klc6vIondTiAeXIJsnGL1r4BVKFakelWqgdyhhFFUdo66DI2wQoC2c1Am2LxE9x7BDAvj98MDj2S3Tmj67rQ4kKMIVBGe8zYZMZtlP02iZdcBz5y8qyKfilKZMZv39uEiyVbdbNw8Pqegosxnl6Ir/cyrMJx7Kxz5vPlm5tXzK5GzHnv6axRUpWa8h8wdCN7vFSPdFXj4zAhdEy/4Kbftv/eptYGXkCn+X165yHTeAq7IbdLHaQLAwKSbQcYfwSc4EzgpxVsHUaEXTV7T95iOx
 dNT5ogFw
 zKbo5z7saFKi4dTWeXc3sd57xk81bbTH1k5FagOvMfPV94sv2mKOZWvDzHX+aybdXiaaCEX6Ejik8AHs2b57ziNMlXocwgqX6rCHK8NzfE1gVDGtP7seDUnjwNBvGHwgSsHmYt5oa2qguK4UkJg0dPnaZGrhWpss2PnURNDVFauYJHfRJO4ovi2bkh0/+9TM2N3mQXihWiwyYXgY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Let's prepare for passing another counter by renaming diff/mapcount to
"nr_mappings" and just using an "unsigned int".

Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 include/linux/rmap.h | 61 ++++++++++++++++++++++++++--------------------------
 1 file changed, 31 insertions(+), 30 deletions(-)

diff --git a/include/linux/rmap.h b/include/linux/rmap.h
index b81b1d9e1eaa..5a02ffd3744a 100644
--- a/include/linux/rmap.h
+++ b/include/linux/rmap.h
@@ -133,10 +133,10 @@ static inline void folio_set_mm_id(struct folio *folio, int idx, mm_id_t id)
 }
 
 static inline void __folio_large_mapcount_sanity_checks(const struct folio *folio,
-		int diff, mm_id_t mm_id)
+		unsigned int nr_mappings, mm_id_t mm_id)
 {
 	VM_WARN_ON_ONCE(!folio_test_large(folio) || folio_test_hugetlb(folio));
-	VM_WARN_ON_ONCE(diff <= 0);
+	VM_WARN_ON_ONCE(nr_mappings == 0);
 	VM_WARN_ON_ONCE(mm_id < MM_ID_MIN || mm_id > MM_ID_MAX);
 
 	/*
@@ -145,7 +145,7 @@ static inline void __folio_large_mapcount_sanity_checks(const struct folio *foli
 	 * a check on 32bit, where we currently reduce the size of the per-MM
 	 * mapcount to a short.
 	 */
-	VM_WARN_ON_ONCE(diff > folio_large_nr_pages(folio));
+	VM_WARN_ON_ONCE(nr_mappings > folio_large_nr_pages(folio));
 	VM_WARN_ON_ONCE(folio_large_nr_pages(folio) - 1 > MM_ID_MAPCOUNT_MAX);
 
 	VM_WARN_ON_ONCE(folio_mm_id(folio, 0) == MM_ID_DUMMY &&
@@ -161,29 +161,29 @@ static inline void __folio_large_mapcount_sanity_checks(const struct folio *foli
 }
 
 static __always_inline void folio_set_large_mapcount(struct folio *folio,
-		int mapcount, struct vm_area_struct *vma)
+		unsigned int nr_mappings, struct vm_area_struct *vma)
 {
-	__folio_large_mapcount_sanity_checks(folio, mapcount, vma->vm_mm->mm_id);
+	__folio_large_mapcount_sanity_checks(folio, nr_mappings, vma->vm_mm->mm_id);
 
 	VM_WARN_ON_ONCE(folio_mm_id(folio, 0) != MM_ID_DUMMY);
 	VM_WARN_ON_ONCE(folio_mm_id(folio, 1) != MM_ID_DUMMY);
 
 	/* Note: mapcounts start at -1. */
-	atomic_set(&folio->_large_mapcount, mapcount - 1);
-	folio->_mm_id_mapcount[0] = mapcount - 1;
+	atomic_set(&folio->_large_mapcount, nr_mappings - 1);
+	folio->_mm_id_mapcount[0] = nr_mappings - 1;
 	folio_set_mm_id(folio, 0, vma->vm_mm->mm_id);
 }
 
 static __always_inline int folio_add_return_large_mapcount(struct folio *folio,
-		int diff, struct vm_area_struct *vma)
+		unsigned int nr_mappings, struct vm_area_struct *vma)
 {
 	const mm_id_t mm_id = vma->vm_mm->mm_id;
 	int new_mapcount_val;
 
 	folio_lock_large_mapcount(folio);
-	__folio_large_mapcount_sanity_checks(folio, diff, mm_id);
+	__folio_large_mapcount_sanity_checks(folio, nr_mappings, mm_id);
 
-	new_mapcount_val = atomic_read(&folio->_large_mapcount) + diff;
+	new_mapcount_val = atomic_read(&folio->_large_mapcount) + nr_mappings;
 	atomic_set(&folio->_large_mapcount, new_mapcount_val);
 
 	/*
@@ -194,14 +194,14 @@ static __always_inline int folio_add_return_large_mapcount(struct folio *folio,
 	 * we might be in trouble when unmapping pages later.
 	 */
 	if (folio_mm_id(folio, 0) == mm_id) {
-		folio->_mm_id_mapcount[0] += diff;
+		folio->_mm_id_mapcount[0] += nr_mappings;
 		if (!IS_ENABLED(CONFIG_64BIT) && unlikely(folio->_mm_id_mapcount[0] < 0)) {
 			folio->_mm_id_mapcount[0] = -1;
 			folio_set_mm_id(folio, 0, MM_ID_DUMMY);
 			folio->_mm_ids |= FOLIO_MM_IDS_SHARED_BIT;
 		}
 	} else if (folio_mm_id(folio, 1) == mm_id) {
-		folio->_mm_id_mapcount[1] += diff;
+		folio->_mm_id_mapcount[1] += nr_mappings;
 		if (!IS_ENABLED(CONFIG_64BIT) && unlikely(folio->_mm_id_mapcount[1] < 0)) {
 			folio->_mm_id_mapcount[1] = -1;
 			folio_set_mm_id(folio, 1, MM_ID_DUMMY);
@@ -209,13 +209,13 @@ static __always_inline int folio_add_return_large_mapcount(struct folio *folio,
 		}
 	} else if (folio_mm_id(folio, 0) == MM_ID_DUMMY) {
 		folio_set_mm_id(folio, 0, mm_id);
-		folio->_mm_id_mapcount[0] = diff - 1;
+		folio->_mm_id_mapcount[0] = nr_mappings - 1;
 		/* We might have other mappings already. */
-		if (new_mapcount_val != diff - 1)
+		if (new_mapcount_val != nr_mappings - 1)
 			folio->_mm_ids |= FOLIO_MM_IDS_SHARED_BIT;
 	} else if (folio_mm_id(folio, 1) == MM_ID_DUMMY) {
 		folio_set_mm_id(folio, 1, mm_id);
-		folio->_mm_id_mapcount[1] = diff - 1;
+		folio->_mm_id_mapcount[1] = nr_mappings - 1;
 		/* Slot 0 certainly has mappings as well. */
 		folio->_mm_ids |= FOLIO_MM_IDS_SHARED_BIT;
 	}
@@ -225,15 +225,15 @@ static __always_inline int folio_add_return_large_mapcount(struct folio *folio,
 #define folio_add_large_mapcount folio_add_return_large_mapcount
 
 static __always_inline int folio_sub_return_large_mapcount(struct folio *folio,
-		int diff, struct vm_area_struct *vma)
+		unsigned int nr_mappings, struct vm_area_struct *vma)
 {
 	const mm_id_t mm_id = vma->vm_mm->mm_id;
 	int new_mapcount_val;
 
 	folio_lock_large_mapcount(folio);
-	__folio_large_mapcount_sanity_checks(folio, diff, mm_id);
+	__folio_large_mapcount_sanity_checks(folio, nr_mappings, mm_id);
 
-	new_mapcount_val = atomic_read(&folio->_large_mapcount) - diff;
+	new_mapcount_val = atomic_read(&folio->_large_mapcount) - nr_mappings;
 	atomic_set(&folio->_large_mapcount, new_mapcount_val);
 
 	/*
@@ -243,13 +243,13 @@ static __always_inline int folio_sub_return_large_mapcount(struct folio *folio,
 	 * negative.
 	 */
 	if (folio_mm_id(folio, 0) == mm_id) {
-		folio->_mm_id_mapcount[0] -= diff;
+		folio->_mm_id_mapcount[0] -= nr_mappings;
 		if (folio->_mm_id_mapcount[0] >= 0)
 			goto out;
 		folio->_mm_id_mapcount[0] = -1;
 		folio_set_mm_id(folio, 0, MM_ID_DUMMY);
 	} else if (folio_mm_id(folio, 1) == mm_id) {
-		folio->_mm_id_mapcount[1] -= diff;
+		folio->_mm_id_mapcount[1] -= nr_mappings;
 		if (folio->_mm_id_mapcount[1] >= 0)
 			goto out;
 		folio->_mm_id_mapcount[1] = -1;
@@ -275,35 +275,36 @@ static __always_inline int folio_sub_return_large_mapcount(struct folio *folio,
  * See __folio_rmap_sanity_checks(), we might map large folios even without
  * CONFIG_TRANSPARENT_HUGEPAGE. We'll keep that working for now.
  */
-static inline void folio_set_large_mapcount(struct folio *folio, int mapcount,
+static inline void folio_set_large_mapcount(struct folio *folio,
+		unsigned int nr_mappings,
 		struct vm_area_struct *vma)
 {
 	/* Note: mapcounts start at -1. */
-	atomic_set(&folio->_large_mapcount, mapcount - 1);
+	atomic_set(&folio->_large_mapcount, nr_mappings - 1);
 }
 
 static inline void folio_add_large_mapcount(struct folio *folio,
-		int diff, struct vm_area_struct *vma)
+		unsigned int nr_mappings, struct vm_area_struct *vma)
 {
-	atomic_add(diff, &folio->_large_mapcount);
+	atomic_add(nr_mappings, &folio->_large_mapcount);
 }
 
 static inline int folio_add_return_large_mapcount(struct folio *folio,
-		int diff, struct vm_area_struct *vma)
+		unsigned int nr_mappings, struct vm_area_struct *vma)
 {
-	return atomic_add_return(diff, &folio->_large_mapcount) + 1;
+	return atomic_add_return(nr_mappings, &folio->_large_mapcount) + 1;
 }
 
 static inline void folio_sub_large_mapcount(struct folio *folio,
-		int diff, struct vm_area_struct *vma)
+		unsigned int nr_mappings, struct vm_area_struct *vma)
 {
-	atomic_sub(diff, &folio->_large_mapcount);
+	atomic_sub(nr_mappings, &folio->_large_mapcount);
 }
 
 static inline int folio_sub_return_large_mapcount(struct folio *folio,
-		int diff, struct vm_area_struct *vma)
+		unsigned int nr_mappings, struct vm_area_struct *vma)
 {
-	return atomic_sub_return(diff, &folio->_large_mapcount) + 1;
+	return atomic_sub_return(nr_mappings, &folio->_large_mapcount) + 1;
 }
 #endif /* CONFIG_MM_ID */
 

-- 
2.43.0


