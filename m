Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ADC42606A31E
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 11:06:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=google header.b=TkACi4YB
Received: by kanga.kvack.org (Postfix)
	id AE6326B0679; Tue, 24 Nov 2026 06:06:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A70486B067B; Tue, 24 Nov 2026 06:06:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 95F726B067C; Tue, 24 Nov 2026 06:06:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5B5836B0679
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 06:06:42 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 55F0E80AE8
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 11:06:40 +0000 (UTC)
X-FDA: 85469734560.29.9827F1B
Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	by imf07.hostedemail.com (Postfix) with ESMTP id 09A6640009
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 11:06:37 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=TkACi4YB;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf07.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.52 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795518398;
	b=zfmviwXRwjQp0TCZs4VNlxGQWSdnJ0Py9XCuc7axY39P6wrA5I3xmq8fK/r9l1Db2Ru4b4
	tCaxIxFez3vm/A9w6cKZdKW0P8NexGUXE0sHGBUDwAtH87D6zMstQUTt7Pxk5tx8JsWncU
	PfoNQc81H6CqTwkz7lOnJM9Y6X42bPk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795518398;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mv0XTlLAMOAtsOotlKcZg4weW3RW0GUSWsaCSp95mRA=;
	b=vsGTVDbYf9Jjvm4jaWrjKzx2a92zHR45+NpsNad/TtUM5VIqTdlu3binhn4clm9nm1TzYN
	oPxXW2OIderWF6UUYy2soaWsoprgkR3/jV7Vih7BHVvcEoQWMVtCS8J4kUM1ux80DhaO7I
	8ULAZJzsN+DoBb9d7zRE0Se7KOyUxE0=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=TkACi4YB;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf07.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.52 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-3b40470fdd8so2112865a91.1
        for <linux-mm@kvack.org>; Tue, 24 Nov 2026 03:06:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1795518396; x=1796123196; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=mv0XTlLAMOAtsOotlKcZg4weW3RW0GUSWsaCSp95mRA=;
        b=TkACi4YBw2+fGXpvalWptZD3qb6DdulA9jVnQYM5hx4CG+fhiV5pq8GVb86OEkMEMM
         3GD6ghIOE/VRAP/ub3fBe0V/bQXmN3oSH4w5UmR35vH8Vnx8qY4rX6XapbPIDuyvzL6d
         QVN4kXN0iqmCVwJZhUJJE/YL0ztVK8a1m9+h9aqA5PICge6GLLK9d5NDn00rj01JTMKy
         NkTtS5wVLIS+aafTxH8sIa/ewSxac6vVUmGr5VRwUESQ9gqhQT1MtDiGRPJPffigZm2v
         KO02EF3nFBMX2BZSFXMun/7WMm9Cqt357ceHcj9jpZxwTQwWv0oDHP1bZpWw9FF8axCo
         6MKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795518396; x=1796123196;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=mv0XTlLAMOAtsOotlKcZg4weW3RW0GUSWsaCSp95mRA=;
        b=b/P19Y5m5+90MegVM1iUm6WphB/73Bc/VbM60qenCAnHWGY+n64wMEybS6fJi7TeNT
         Jj8kKzPmRdwRxBdKMxtd86c1ONrTO+MiexFGGW9H0kqPSxcCmg7qIf5OEAo5gIjBBvsT
         4JA6JMRllzFi4nr1mR80rxSPC8ox43RVUFpHlLco4S1vqWprbBqiL5lWeGqpnqgyX0eL
         YdevPs1tW0PXG86mugnrvZdhPTDzgeWh2Hnw5lU5kS3OCqb/bBCLc27Yn/1/qypngO/7
         Fcmr50I66boN5RzDvs6e8ikMaDf+75EB3LemhChnjk2szzPWLQrqPUwmQ40lkhKLLAPZ
         vtUw==
X-Forwarded-Encrypted: i=1; AL+hErHeRskSIEFWvdBy9jpISEkqM2ln6SI6ORfXsAbR55a59lKJmViOYW9xeHiI/kmf0/FwJ7jqjZhbgg==@kvack.org
X-Gm-Message-State: APuU4Z+A5djxWMaVRq3cXLCU7BuThyTEd1vAYpY4QEsi4JLiPZq4W9BV
	shLGkIfULQ3EM8DaLiSMSt41e+qBdvpZEyI2xv/QaU8kXdD1930wsWmVehvlVNnBYuM=
X-Gm-Gg: AZFdTZdv3J3sJKzvuPTzBNlF8T7S3r1boCAP4g4fMJvylLy4N9Q2XMyhB5r4EMF7Zho
	hx86RFu45I4vWohdIbJZllxQ0KjiyDQWZKFDsR+twsl47KgvnLHqhWKyD2qjVMXLLhf1Q3H5aAL
	bWSfSRSL+aX0a7+oEGCIbkeS96BhVGZJstPJ8CrOdGkGht0Y8ni9rbyOWRwGEwAgJfEcRVWFlJv
	pxwdJSSqDfubhrVOJx5DEfPTdj65wA3r60H+9giOSVnaUwYfAMaixXDQGIqZStMcvZ2G52v2GNh
	akgR0q/rBxm0y7ZfdEkn+LRCyVHD1Cz4J89IfwM31IUcE3TQCofODMMyUgV7oiQKy+Ba5yco4ff
	5Lg5V37Q+8VD4UeGJRENUxWkYipN8iz9SG5XVrVhBsdasMWiHZbpZ4GhhC5SSGnWz4+WVC4Wcw3
	yXMKLp1bDq7sfHt1De5xkHMYnnz85FKA6y5+8gaE/zKXNNFVccABgyxEGJkT+KETbiebZTY6Pgs
	NcjFOjsbhBp6ycF3HMYpir0/AK5FH/EKqGEYqwPGyvQ0uXHy6UToaTfF9jI3A2oETvwAT5sXnEi
	CBGr/k05xIYwk5q3YHYZQ9zdYrr3xGVoWosCTWzty9eNAEMFBw==
X-Received: by 2002:a17:90b:384d:b0:3b3:be94:8dce with SMTP id 98e67ed59e1d1-3b41c9d2026mr11778318a91.31.1795518396465;
        Tue, 24 Nov 2026 03:06:36 -0800 (PST)
Received: from n232-176-004.byted.org ([36.110.163.98])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b41ad0a33fsm22909735a91.6.2026.11.24.03.06.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Nov 2026 03:06:35 -0800 (PST)
From: Muchun Song <songmuchun@bytedance.com>
To: Oscar Salvador <osalvador@suse.de>,
	Mike Rapoport <rppt@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Muchun Song <muchun.song@linux.dev>,
	Lance Yang <lance.yang@linux.dev>,
	Qi Zheng <qi.zheng@linux.dev>,
	linux-mm@kvack.org,
	Muchun Song <songmuchun@bytedance.com>
Subject: [PATCH 2/6] mm/hugetlb_vmemmap: fold vmemmap_should_optimize() into its callers
Date: Tue, 24 Nov 2026 19:05:26 +0800
Message-ID: <20261124110530.3004071-3-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261124110530.3004071-1-songmuchun@bytedance.com>
References: <20261124110530.3004071-1-songmuchun@bytedance.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 09A6640009
X-Stat-Signature: bm5hmgtsosqn6frd8geqda7egiemngru
X-Rspam-User:
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam06
X-HE-Tag: 1795518397-753362
X-HE-Meta: U2FsdGVkX1+wb8I4F7J8g//N4ATxO6WwSU7SL22dkdqtkeS1z/AHkW6WETqdKSJPKZRVYGNfIrNsNDkZ66pIqnaXa/91XNtPvbWam919NOQ+DA1FILsw9h3M7KlNefRYs5855gTo8CuzKNcRXNc/qhHUh/q6QF8xvUic5nwmEYzwYbLkKau3ULndxdjFTfPFbRwVoCx3sFQmKLQhBcQr/RMQLEj7vEoRbQcpcO4bFZ7J30/8E5HQQxHAbCt08ij4MOGtc2w0wZymuebb71Lt6fohL775xgRenmOiHROaW7Ey9HNS5mFfkqAkp27QnhuiBTQxxwpWBAuYunvI0uZgCDmi4JjeIhytvekpdzc24MPzqfP9ZW3ldnCZgkCgo3nsbSIW7HIvoRw+sDH0zZ2byEuoZp/UD+lvFuD99W9KGTIorxgCFQaI0EkAVbS6yV/9Nyic3OQK//py74eLBAWxu3fHvIdVEAUbzUkUyDlzgerMtp5LI1W58wUX64FCJcvJHWb/hze5PzUiUFay1J08rIlUL5e4NnMSzUixYyikekdhwyaL9hAkpYsG9vCsn+shQv7l6zepZTetvR9CGVS61QY7Na2vbwDE7Kdo3L4q4y+FpMRl3Z/PNrm1UNtI0k6v184EXDELdx/YkOASN0YxU98mn8QWPMydt8eSr1LgrqOo9sC44hwnaNGeKKWxmd9C2ReecM/2/OkBeQlOKxRleMWB3jnUkl+ecKhxh44paAQW77iemQuFaACy0+UOS+XYIhiD35sMqUE6IF1lUgUU8oC6Ndh43Wn8O2X/ghWKN1R/q77ypzFExO3OpTOy90+E+EJCCwbVUeR9tA4g5wFFM38wPIjI8uteSysNb7vBeqbpm0Xncf9HATYR258ds79L18+pE8RuP9OH4o5QDcQznnTnQOkNRhrIeyB0siD4LqJ70/Wakv9ltKdZh2+pP1NScjdtu/36uUYRsJxSQ4+
 1PxcL77L
 Ljag0rq4ct6ijE8SrXJWiPTqvY7vQQVim3kVHQoXImJ5qUxsHhyhFm5rAKc1qfhYfxbT4SkJCLuLyuNh1vrnzS4X/h4nTuGIWmfeu2WwtMEe/T1TCEmSMNmoxek1GIXAyY9fLyBAxccT2RKDatpgM6Lhou6vJuZk3pvi/HGnH1VF7njqHO4f1b3mfj2bAiyVg/l3xcnno0t3l2Dm3u3ijKiTJ4YvCC/Xq76LwtZDxI5z43+dM0J9AGEFhJ6tCMrun7w8UfKH4tLM5T0BSx6U1GM/F5SZcA86C0fVbLQx+6C24CJ7LVg4HXVqrpKfh4bODV8iClg7jv4lPVyTUEIUAxSAv3ivSef43dkyl6TDK8h3vQNxnCt85WxeXTAkfSl9QIZOJHXAKJxvMxlEZsRSQq+vRDk4VG0PSjSKfqQNPV7LMo75N/4et1aqxlvttxn/4Ppjs0gA568f9R783ANCknzzNQ/qGMnkjfT8MK5MlPFu49hG3fnaXJZH9aKk6FeWM0R86SFISEF2/zwVPd76ZGyJ84ENP84trlAW+jTPoQKQLcnuQGU9qlocHZtTWeVNwAhLYk9MieQzNVjk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

vmemmap_should_optimize_folio() combines the global HVO policy,
per-hstate eligibility, and the already-optimized state. The latter two
do not need to gate the normal flow: generic folio and section helpers
check order eligibility, while optimization entry points only receive
freshly initialized folios. Thus, only the global enable policy must be
checked at every entry point.

Fold the global enable check into each caller. Retain the per-hstate
check in hugetlb_vmemmap_optimize_folios() only as an optimization, so
an ineligible hstate is rejected before iterating the entire folio
list.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
---
 mm/hugetlb_vmemmap.c | 38 ++++++++++----------------------------
 1 file changed, 10 insertions(+), 28 deletions(-)

diff --git a/mm/hugetlb_vmemmap.c b/mm/hugetlb_vmemmap.c
index 09b9fd83c198..71aa340cce55 100644
--- a/mm/hugetlb_vmemmap.c
+++ b/mm/hugetlb_vmemmap.c
@@ -488,21 +488,6 @@ long hugetlb_vmemmap_restore_folios(const struct hstate *h,
 	return ret;
 }
 
-/* Return true iff a HugeTLB whose vmemmap should and can be optimized. */
-static bool vmemmap_should_optimize_folio(const struct hstate *h, struct folio *folio)
-{
-	if (folio_test_hugetlb_vmemmap_optimized(folio))
-		return false;
-
-	if (!READ_ONCE(vmemmap_optimize_enabled))
-		return false;
-
-	if (!hugetlb_vmemmap_optimizable(h))
-		return false;
-
-	return true;
-}
-
 static int __hugetlb_vmemmap_optimize_folio(const struct hstate *h,
 					    struct folio *folio,
 					    struct list_head *vmemmap_pages,
@@ -512,9 +497,6 @@ static int __hugetlb_vmemmap_optimize_folio(const struct hstate *h,
 
 	VM_WARN_ON_ONCE_FOLIO(!folio_test_hugetlb(folio), folio);
 
-	if (!vmemmap_should_optimize_folio(h, folio))
-		return 0;
-
 	/*
 	 * Very Subtle
 	 * If VMEMMAP_DEFER_TLB_FLUSH is set, TLB flushing is not performed
@@ -548,32 +530,32 @@ void hugetlb_vmemmap_optimize_folio(const struct hstate *h, struct folio *folio)
 {
 	LIST_HEAD(vmemmap_pages);
 
+	if (!READ_ONCE(vmemmap_optimize_enabled))
+		return;
+
 	guard(rwsem_read)(&vmemmap_remap_rwsem);
 	__hugetlb_vmemmap_optimize_folio(h, folio, &vmemmap_pages, 0);
 	free_vmemmap_page_list(&vmemmap_pages);
 }
 
-static int hugetlb_vmemmap_pteify_folio(const struct hstate *h, struct folio *folio,
-		unsigned long flags)
-{
-	if (!vmemmap_should_optimize_folio(h, folio))
-		return 0;
-
-	return vmemmap_pteify_folio(folio, flags);
-}
-
 void hugetlb_vmemmap_optimize_folios(struct hstate *h, struct list_head *folio_list)
 {
 	struct folio *folio;
 	LIST_HEAD(vmemmap_pages);
 	unsigned long flags = VMEMMAP_DEFER_TLB_FLUSH;
 
+	if (!READ_ONCE(vmemmap_optimize_enabled))
+		return;
+
+	if (!hugetlb_vmemmap_optimizable(h))
+		return;
+
 	if (list_empty(folio_list))
 		return;
 
 	down_write(&vmemmap_remap_rwsem);
 	list_for_each_entry(folio, folio_list, lru) {
-		int ret = hugetlb_vmemmap_pteify_folio(h, folio, flags);
+		int ret = vmemmap_pteify_folio(folio, flags);
 
 		/*
 		 * Splitting the PMD requires allocating a page, thus let's fail
-- 
2.54.0


