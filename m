Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 205BEF588C2
	for <linux-mm@archiver.kernel.org>; Mon, 20 Apr 2026 12:50:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EBDC16B0098; Mon, 20 Apr 2026 08:50:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E22E86B0099; Mon, 20 Apr 2026 08:50:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D37976B009B; Mon, 20 Apr 2026 08:50:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id BEB1A6B0098
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 08:50:52 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 8E535C30F5
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 12:50:52 +0000 (UTC)
X-FDA: 84678918744.26.28A7975
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf25.hostedemail.com (Postfix) with ESMTP id 58237A000C
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 12:50:50 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=dX8tmDHn;
	spf=pass (imf25.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776689450; a=rsa-sha256;
	cv=none;
	b=N1McYxMjQD5tBikS40F7Df/SQ4rFODLqy0/pqeekl8wT8g4fO8c8pISWECbeEW3J6oBqzK
	pH0vSJkApCSJzT6Fg6B9M9X8ZFe42i29axu9JXVgnhuhoPLPNWNpst2wacNj5bjyyn4t3L
	2I0vJsA0Z8qYdIOWb5yEXQ8TUt/5hVA=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=dX8tmDHn;
	spf=pass (imf25.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776689450;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RqSLZ/IXDnoMvKzd+RuDqnZVTelRyZJIHxTKtL1QEDg=;
	b=PWq4ZobrGOSNQmx6J9tSq2zCCmFvKp+abUIon0pmDqy2IQNCMQWgKg+9y13QDaL9FZBnqC
	4dFO+oWXd0L/2/k2r99/8ajL3sKJPtMKeFA5riFAXuDF62oPinoCNgkrREOa4WqydLodmf
	IH/QPY/VmPZOKWcCvihJmJagMRGcgEQ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1776689449;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=RqSLZ/IXDnoMvKzd+RuDqnZVTelRyZJIHxTKtL1QEDg=;
	b=dX8tmDHnrOp6lSC4rYJdvzI6fp6NBbYQXIpqSI6KydVGMNZlQWp3FWMac6tquG1XP0oSPd
	A8wye8hr1mXSAUb5Tg6TOC/cSl4LmcvO2rv6ghiX+QFDomeuN9fJ/JlCImMCii7WmyVKTN
	Gtkg31ufzuOWHzJfzBk2clT8pJqs9ZM=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-178-tFKc4HT6M2KuNf45icK_Fg-1; Mon, 20 Apr 2026 08:50:48 -0400
X-MC-Unique: tFKc4HT6M2KuNf45icK_Fg-1
X-Mimecast-MFC-AGG-ID: tFKc4HT6M2KuNf45icK_Fg_1776689447
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-4411a1f9601so832218f8f.0
        for <linux-mm@kvack.org>; Mon, 20 Apr 2026 05:50:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776689447; x=1777294247;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RqSLZ/IXDnoMvKzd+RuDqnZVTelRyZJIHxTKtL1QEDg=;
        b=TBONu35jZ5r7gkt6bEjqS4o/azaiMSinPLX+Y3k6zwEFNmxxvR5ZhLtPwhWm5wD2A/
         YNJmzd47aB1ToTE2PoQVyfLXH9lxL7oGJFq98boeV3HweZJBIYPazLdtNq6P2B/vPTxi
         oU0TPKJ49Xn5Vh74BIAoLQmjOlLaOB3M1bOgo3NZhS0QAdzRYiMyKfJBSiXTmwQTqOJW
         3CZxphRdy9iczPoosSBgnWzqA2gMPXiaaRQB30ReY16WuadlAFRpgOw3BXdyMcanlkSI
         HHss9E022UHHQTOd7R2LMnrQHds4jSCq3SwS40ngFaNyhyI651Io/tljZFTM7e8QJsTa
         AUsw==
X-Forwarded-Encrypted: i=1; AFNElJ9+sKJm9cOFgqe0GRV65yQYjDNffBbJh3GZQtHy7g2QLIFdagbVOaCbLKaWhvVQR9dpxyl4Fj1scA==@kvack.org
X-Gm-Message-State: AOJu0Yx2NAZgqjBTF1ZIIFenFgfQGRrCBJ8lNNn1Xqfw/bF1fbEkhidY
	baAXUnS7g8HQ2tey+PGgMauZdpRahykP+LAMc42JjKc+/ZNHNfWueHZSBm6jBPIn2/5z3qbgkuj
	kAkEODrKWwWGvMUbvijim+1f2kCqRlPrVtyvfQTxn2uwUHk66ZgVY
X-Gm-Gg: AeBDietlr1XBKnSCxZPH+xILvnIDmdFjcXIwlGJrQBq+kZR03874C7puE2E+nVBYjEj
	qMzl/8tc9BxkC0yC/fQwjgIp1zTzFJTGbtBhkVtD72IbrT0B6IawlwMckeXxLLgSL0MrR9M2lIL
	jCsvEVd8B6zQBmKwzT/1GttpPqU2JHu9G6RX2pFJ9YVUT6KXQNu0hRFaoQLyOm6dh586F2OSJom
	Cc2rJRVVr8pwzDP6vQ2WToN5xrle9kGdmQIrrTNyC0PcbPN1SIFM7MOgoRQRJEieuJ2fYSzFMjj
	4Si2dLXRZNIhW1YwIhkZ4iZ+Xfp3UitZ0qOC8zpa0bv3oX4pusefasZ9pbsN2KevBdGJMj6hqp1
	F6jXCZiIK/UpBGrNCIINyzDw0NkJyUNZelQmLF96RuYVKqEkGQlklXg==
X-Received: by 2002:a05:600c:888b:b0:488:c40b:c8bf with SMTP id 5b1f17b1804b1-488fb73d234mr157904095e9.2.1776689447024;
        Mon, 20 Apr 2026 05:50:47 -0700 (PDT)
X-Received: by 2002:a05:600c:888b:b0:488:c40b:c8bf with SMTP id 5b1f17b1804b1-488fb73d234mr157903665e9.2.1776689446452;
        Mon, 20 Apr 2026 05:50:46 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-25-21.inter.net.il. [80.230.25.21])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48a4b329542sm43629625e9.3.2026.04.20.05.50.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Apr 2026 05:50:46 -0700 (PDT)
Date: Mon, 20 Apr 2026 08:50:43 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Brendan Jackman <jackmanb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Jason Wang <jasowang@redhat.com>,
	Andrea Arcangeli <aarcange@redhat.com>, linux-mm@kvack.org,
	virtualization@lists.linux.dev, Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>
Subject: [PATCH RFC v2 09/18] mm: hugetlb: use PG_zeroed for pool pages, skip
 redundant zeroing
Message-ID: <cb29348b99c742e10ac9147ce781fa56dabf9600.1776689093.git.mst@redhat.com>
References: <cover.1776689093.git.mst@redhat.com>
MIME-Version: 1.0
In-Reply-To: <cover.1776689093.git.mst@redhat.com>
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: HOisB1ehO-PPRcA-kQLG84HFk9LpkO4mxzdMsLE-MG8_1776689447
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Queue-Id: 58237A000C
X-Stat-Signature: aoq84rugndmnspxao8z1txk1cwpwpfc7
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1776689450-960433
X-HE-Meta: U2FsdGVkX19srv36ObD/4gfg7k0RlYAh0Y+6G4QYW/nfeQbv4gDTr14ge+M7gDloXxBmhgaJu7DcwNwHWQi50HA61nZUnzMhj6o1YVqJs3JbpleReIgxe2q5kU6gqXREibHQUckG4JCRvDpmSjxZRHRDBFxCCKeFnFev7nhWWHOxyiAfneY/2KCLoPs5n2gYxvPzkYMLBIZa8Kayx7hjs8GES+ZOTfb3JD2/aJOazo3XHkgm7ai1BGBEZR/Afl68A9+AmTAWWm8iwtag4zMuju4JKn7EdrwbeY31L60bwb49iEM2EJrBGd5kz5fzzPsPcJy3ToEooU82Y49QKJrIikOSwxpG9BRX/uHn7hLRxv+DmAQOsNKZ/2n3KZPJcWUDKjsxNmURvkHzC2aDRKa4gn9VVGY9zUp4O4xNVvpusX8cbn7xww37ucs0iVr+br5wHBkHmg0aahE/DcvpdsVx5tsGbI9Sg+qLUL0EaVJhlHf3jMzizxyFzOJOCJvCcp54bjmyttqfjZ3AgoxeMZoyzWP/h5tEnsVSpxbCjIzcv+C/Lo1VacTSdzkDkQ9vjh15vvH4QZiqURnq8D+yfGYCBlmSeCTwQGfvpokjC3/rA/2hnyuPSjmkESXg/O9mjwSpfeyITsriNsgp+BFaAWPDwElVrh1SkAY8x2nP/zgqvtCGsK0giZD+eMMo60le4bVWDveJYgewSMlKwbwMYukHdbAFXFe4m/f/pP9cpvhTq4teg6KJ5sTvw7WoPqGSWIkRcZrrksq8e2F59lsSyetOW67x3ZpkwNx7upYioWBFlKmGPJwMGkFqmukcPB5Mg3ipUrewHu0Ay21zIdHhGxp+uWfiv0A4Obzl3bobdqpticbiDFxNfDY8MOfv0XmL6NrR+ILVsyslA0BD/j4u6AztoaQDZ7rrQfFKhTbakIEWSTvf/xGlqvs9hcDqtp2Oo/a7Tj5CJF319OfC5O0fHTa
 y3GKTha2
 zpX8ZuJeSFXNdXHuyD2d6StLZl3rPfXSaYHf6ouuGG0hwEI/MQWpRx9K4g5qQOM8gJNO1IeXxcH36+x0TJ4qgc0bP8+qhoUsrlpz8f8zJiWnnbFa60URXsq1RzOK9gPZJVmYzU3yXHwPLZGFdLndP/Sq9JMCt20WUmixe2+CVlTXsi0H/VGtKcwxlZIQg6BoYto0dqn1HZiJIXJ00Xa7M+p3fJKWv8cdxpQlp3v+0DczKdUWK9rulE938u/3/r/oXXvWdgVN+iCy2P3fG5qLjuKmSzzkb4eOi3ERm/qPhQ52cYrJ1r7iyfs4Bbaixcdda0kD8Z6Urg9VFR6ZlDvDBaWFuNog0xn3NjyMMslw5a/uVmrUuCPw9botlCw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Set PG_zeroed on surplus hugetlb pages when buddy-allocated with
PGHINT_ZEROED (indicating the page was pre-zeroed by the host).
Clear PG_zeroed in free_huge_folio() when a user-mapped page
returns to the pool.

Check PG_zeroed at fault and fallocate callers to skip redundant
folio_zero_user().

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Assisted-by: Claude:claude-opus-4-6
Assisted-by: cursor-agent:GPT-5.4-xhigh
---
 fs/hugetlbfs/inode.c |  5 ++++-
 mm/hugetlb.c         | 31 +++++++++++++++++++++----------
 2 files changed, 25 insertions(+), 11 deletions(-)

diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
index 3f70c47981de..3f9bdb5a7c85 100644
--- a/fs/hugetlbfs/inode.c
+++ b/fs/hugetlbfs/inode.c
@@ -828,7 +828,10 @@ static long hugetlbfs_fallocate(struct file *file, int mode, loff_t offset,
 			error = PTR_ERR(folio);
 			goto out;
 		}
-		folio_zero_user(folio, addr);
+		if (PageZeroed(&folio->page))
+			__ClearPageZeroed(&folio->page);
+		else
+			folio_zero_user(folio, addr);
 		__folio_mark_uptodate(folio);
 		error = hugetlb_add_to_page_cache(folio, mapping, index);
 		if (unlikely(error)) {
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index faa94a114fd4..704ec0817c5e 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -1746,6 +1746,8 @@ void free_huge_folio(struct folio *folio)
 	bool restore_reserve;
 	unsigned long flags;
 
+	__ClearPageZeroed(&folio->page);
+
 	VM_BUG_ON_FOLIO(folio_ref_count(folio), folio);
 	VM_BUG_ON_FOLIO(folio_mapcount(folio), folio);
 
@@ -1919,12 +1921,13 @@ static struct folio *only_alloc_fresh_hugetlb_folio(struct hstate *h,
  * pages is zero, and the accounting must be done in the caller.
  */
 static struct folio *alloc_fresh_hugetlb_folio(struct hstate *h,
-		gfp_t gfp_mask, int nid, nodemask_t *nmask)
+		gfp_t gfp_mask, int nid, nodemask_t *nmask,
+		pghint_t *hints)
 {
 	struct folio *folio;
 
 	folio = only_alloc_fresh_hugetlb_folio(h, gfp_mask, nid, nmask,
-					      NULL, NULL);
+					      NULL, hints);
 	if (folio)
 		hugetlb_vmemmap_optimize_folio(h, folio);
 	return folio;
@@ -2137,6 +2140,7 @@ static struct folio *alloc_surplus_hugetlb_folio(struct hstate *h,
 				gfp_t gfp_mask,	int nid, nodemask_t *nmask)
 {
 	struct folio *folio = NULL;
+	pghint_t hints;
 
 	if (hstate_is_gigantic_no_runtime(h))
 		return NULL;
@@ -2146,10 +2150,13 @@ static struct folio *alloc_surplus_hugetlb_folio(struct hstate *h,
 		goto out_unlock;
 	spin_unlock_irq(&hugetlb_lock);
 
-	folio = alloc_fresh_hugetlb_folio(h, gfp_mask, nid, nmask);
+	folio = alloc_fresh_hugetlb_folio(h, gfp_mask, nid, nmask, &hints);
 	if (!folio)
 		return NULL;
 
+	if (hints & PGHINT_ZEROED)
+		__SetPageZeroed(&folio->page);
+
 	spin_lock_irq(&hugetlb_lock);
 	/*
 	 * nr_huge_pages needs to be adjusted within the same lock cycle
@@ -2189,7 +2196,7 @@ static struct folio *alloc_migrate_hugetlb_folio(struct hstate *h, gfp_t gfp_mas
 	if (hstate_is_gigantic(h))
 		return NULL;
 
-	folio = alloc_fresh_hugetlb_folio(h, gfp_mask, nid, nmask);
+	folio = alloc_fresh_hugetlb_folio(h, gfp_mask, nid, nmask, NULL);
 	if (!folio)
 		return NULL;
 
@@ -2242,9 +2249,6 @@ struct folio *alloc_hugetlb_folio_reserve(struct hstate *h, int preferred_nid,
 {
 	struct folio *folio;
 
-	if (hints)
-		*hints = (pghint_t)0;
-
 	spin_lock_irq(&hugetlb_lock);
 	if (!h->resv_huge_pages) {
 		spin_unlock_irq(&hugetlb_lock);
@@ -2253,8 +2257,12 @@ struct folio *alloc_hugetlb_folio_reserve(struct hstate *h, int preferred_nid,
 
 	folio = dequeue_hugetlb_folio_nodemask(h, gfp_mask, preferred_nid,
 					       nmask);
-	if (folio)
+	if (folio) {
 		h->resv_huge_pages--;
+		if (hints)
+			*hints = PageZeroed(&folio->page) ? PGHINT_ZEROED : 0;
+		__ClearPageZeroed(&folio->page);
+	}
 
 	spin_unlock_irq(&hugetlb_lock);
 	return folio;
@@ -2748,7 +2756,7 @@ static int alloc_and_dissolve_hugetlb_folio(struct folio *old_folio,
 			spin_unlock_irq(&hugetlb_lock);
 			gfp_mask = htlb_alloc_mask(h) | __GFP_THISNODE;
 			new_folio = alloc_fresh_hugetlb_folio(h, gfp_mask,
-							      nid, NULL);
+							      nid, NULL, NULL);
 			if (!new_folio)
 				return -ENOMEM;
 			goto retry;
@@ -5820,7 +5828,10 @@ static vm_fault_t hugetlb_no_page(struct address_space *mapping,
 				ret = 0;
 			goto out;
 		}
-		folio_zero_user(folio, vmf->real_address);
+		if (PageZeroed(&folio->page))
+			__ClearPageZeroed(&folio->page);
+		else
+			folio_zero_user(folio, vmf->real_address);
 		__folio_mark_uptodate(folio);
 		new_folio = true;
 
-- 
MST


