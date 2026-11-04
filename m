Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 820DB606A335
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 02:36:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=google header.b=fhSQpUo8
Received: by kanga.kvack.org (Postfix)
	id 8A9AD6B05B6; Tue,  3 Nov 2026 21:36:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 853076B05B7; Tue,  3 Nov 2026 21:36:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6305C6B05B8; Tue,  3 Nov 2026 21:36:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 21E956B05B6
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 21:36:05 -0500 (EST)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8E4661405FE
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 02:36:04 +0000 (UTC)
X-FDA: 85395871848.28.219C640
Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	by imf29.hostedemail.com (Postfix) with ESMTP id 82FAF120005
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 02:36:02 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=fhSQpUo8;
	spf=pass (imf29.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.210.178 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793759762;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2TFuv5HPs97W4rn6iXQiGwNXy4Qy4yQskKS9otILqUg=;
	b=GKMjGhSZlBzhQLhRGfM8LDG0A1mZ5UbF513htwFGRkpD+GeNU72YUamt27ir0M3ETr7rip
	yop+xgCnPxMwMCdraCQqL7xommsu/OBG1FEFJrfAPq4DGlSGngPnlItNx5l/t9JKOqM2Wl
	PHMeDVNo9uJs2CzOR3VlOhx/t/BLA4w=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=fhSQpUo8;
	spf=pass (imf29.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.210.178 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793759762;
	b=gaAO2OUrH+EMAOyE6koJJNyMI1wXHxYPQLS9ADIFBmiW5OnRX+5k8tzHHi3EWqyV6FeCnO
	5SyRfF6GHrkK0OvjRsEf4B0HXqKHq4ioMZ+jZ1pVY93xRGqH/gWIfcrKuNE1xZzOtwpX2R
	EPEF19kbMHZM3XDR36TjThNaOFHn9D0=
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-8a058315c79so114064b3a.3
        for <linux-mm@kvack.org>; Tue, 03 Nov 2026 18:36:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1793759761; x=1794364561; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=2TFuv5HPs97W4rn6iXQiGwNXy4Qy4yQskKS9otILqUg=;
        b=fhSQpUo8+Laxnurv4tlRTAvDoQMq/iI0Hv7o9r2sllfW08TFYmzneYdFA1p/fYdOdE
         dbAFFG43msM0wTvL5xDgKq2/cGo7O2MGOCurm70NwoWB+T3MSHzzlaxUCIjwBFoq9vGV
         VUOqsZSeXQvaLJUYI8aLwMyfk6MhYZdAgRcKdMZlWr9odQ9NBWcHuR1C1grTCqHY4o3z
         NLZ8riB7wPbUak06vWtDJRYv1FBaMoUla5gKY6bI8ieknz6pPCLYMFyysWPfTrHhAs1M
         tdn3PXwB4zfF+FWfWI4DNNvZ5WTMiG4e1onC2A0ZaDpLnylymZTMVcHQ/o0DkJ4UNSGR
         tBCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793759761; x=1794364561;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=2TFuv5HPs97W4rn6iXQiGwNXy4Qy4yQskKS9otILqUg=;
        b=FJH2kdMIWH9yRBhRmNL3jaR1HIhngihGJY5MZnpMVKq82mVKOSwg/ZeXL6wKOd0h6A
         0scSQa/5Fv3YyjRp/bfNj7ULZJX6NFZ8i7omQ0zdnxdORW3iiKvHRLNdKygUz9Of1PgP
         AJbDJAOA8LEtMQNy3HqEXgfooj4zDEBem4GM3zhYkZg1Qb+tX6lTnkNtJWULJqtr1uQP
         /AkKPbdV86QCoXKlEc16BOdgHE9fiuxuYiGqRyKZHeu18x1qqjiHc6YMEgPAVIpj0p3L
         oMEZbQAMmfpzbz/+xmgD9vrTOjHc8rCAfxrZZMdXifk8e4lPNT40IUtt2VQdcNcLDse9
         s9Fg==
X-Forwarded-Encrypted: i=1; AKwUvByiBJqbFWDRPkVsE5gKGd4OeMFqtOiD/EZOuebfwomhWFazTXQxqKMyHw5JlLn+5oHjcrGVY3xCIA==@kvack.org
X-Gm-Message-State: APuU4Z97MSMiwCwmAgEEEO/Jfe7PERZbrD2ZPG9PxjGZ3iUWaIXw5767
	+iBUkna+Q6YSNHo+/AvmM3foMwM91Tva3LYYZj0CC50efMEqYI95ZHJsGJidkvCUCgM=
X-Gm-Gg: AYBFou3NkWvDt2xlSNUteJ37OCOL0dnyVP3rBOVRcW9GTqiXjDzAnkF4/AMczzDKmit
	TRnuVxfFuEtGDCYtxqLmxpplbJnymyp1YxrFGF4i922f//vioVq8iBfICMufSG4DOqDNC7h2Upn
	JBnNu2Muo3pQh2zMMV7mV9RW3lyOobFMuZuH4KTQvQ9RDv9lfGwEbOqOpi3/Pq/Fs+oEh0ZN+fy
	DuZypAObMo+8z8aX3hzpsiIGCkeCZ/OxjDr3GGWm/q9H45JNehM+9i2Ua4ERRgCzZ+9U0iQx8/p
	DPTrqyxAsMR8Xiu7lMGVyB9PzBvxp723Jr4PIn7lq9VE7B0tl3ViZ3OyZEuQbpA/M6IiRA41CDS
	xE1Tul0gGAGHuxkWmLx5RjJg6z2Yu3pjHGjk2JVybfd5VxbBe409o3VRh7riFV2/Vl+X4Drzump
	im0GE+mTi3UAXq+9jYb/HZeg/OtSoBPSvtP9lCmFqzsMuxnRjapB9ASAcq85W798IiUpAYcQbp5
	VjS8oycTmm8/axHsB1lhoexkxlFognD7fUOBXpmlx7Hu2TJZlvNBczTYqXqSdT4yud5TDh/tNnK
	vI9AruMBZHy7Gmjix10ZmOakvjGTFad7G+qAfp2hJ0tM3l12DDc=
X-Received: by 2002:a05:6a00:12ce:b0:880:5fe5:a818 with SMTP id d2e1a72fcca58-8a9bef522b2mr12097630b3a.59.1793759760840;
        Tue, 03 Nov 2026 18:36:00 -0800 (PST)
Received: from n232-176-004.byted.org ([36.110.163.99])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8b09bc3d1f2sm240815b3a.50.2026.11.03.18.35.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2026 18:36:00 -0800 (PST)
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
Subject: [PATCH v3 05/12] mm: hugetlb_vmemmap: unify writable vmemmap page preparation
Date: Wed,  4 Nov 2026 10:35:03 +0800
Message-ID: <20261104023510.260766-6-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261104023510.260766-1-songmuchun@bytedance.com>
References: <20261104023510.260766-1-songmuchun@bytedance.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 9nf7pdg6cocegc9cfb1yjahajsoetiak
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 82FAF120005
X-HE-Tag: 1793759762-201316
X-HE-Meta: U2FsdGVkX18lZwNqL9eT2nhrzOleGUlSHT+KfEEWKYAUAfBVNMf1F1KwXulXOai51aS1lKvj83orsTJeEQr/0Ymki5gJRsjitlqC9kS4fowMf9OSLfsuyP0kOCAU0xyqWRAtd3FG7jzh/SivutMU1wDGodUmFATXK8QnBkFrT2m6SaxKCkM8ObH04g7Ba5wQS7hvNFGrvY+4q8i8lq5I1LJ5pNVxwq4F/YNA+NiK13u6r9yK5Msis6rgmzanQ7CnuCuLsY9Qk7z0uzG6qm9Uwib9Of0kjxaOeo++EFiNAEjfCchrABfw9YoTR5+KFXreqLEFbqwCQDru697txF+e3UiW5ONsC0msoQ61aFP2LcaqWHOhWNL8z9CiQpLK+tU6ePjAOE19e+ud/xNOv6+A3Y4bvPTJQnCYKTUyDsluvVZIpDLT79wES7FVm5YSBt9HQCbwwVtPF/8RaeX2qNddeyYIIuMy/Ye56Z7dHHHJKMawSZnw1NvBJD4ICaCukVDRkDoUj467iMHLIVZg7/e8G02skCh1s6776y44teDYkNjauL0TbSFVoICaq94i93TrF3R/sc97NyPpLOGDDwWfoBMYMgHH0KZOVi13n4mP6EbSVDe5AiMjMtvG7AlYKwvgmWRH+VNtQYOrgRGgFQk788hTpBTPGbMtfy0Vj6oX83e8UEPxzPVLJgThhjqo8EUsygbt6/+1JsnG28fFVy/QtR2vY81CH9DUZ3a179BMzwOFLOripXRy6QHZtwQMl8he6uCvdl6I0asf5oJJxjQPLdoeLpFq2eqTo0j5kex4+grhct8yOgkXk/cN6/PdASa65WCsAX+9h8gqZBsCxfwo0oX/RWNeutl6TIyZdbRMOcv0cQnVXc303jViAJ9xFrOEwtv1uCjs9BzZCglhANT7X7+dFI+cDr8CRNZBa/WSMvlsnY8fzSYg9AazinyLFHlHMTomL9Tkx1gS0sUjNSa
 qQEW1XOT
 +QgU2AYcD5juMRRYnSrxPfppJEVx46GZuExDRBunSlNM1mo4vhjuZVNfcpyonjHOMS0mnU2WyO0uz+hPsLbSYwg+agC2AKBOy5PdJDnYD5+bGKNjG1Jz9giG32hd/lQR6BtHxxqbXwGwLGJ/2cWmlxnIf7Xz54eQEVey/ofuknyUAFG+KNdKaUVR/h26YxsAAMA1TMq1aUHQ9KLrsr2JZ7r6hER5He45d+NMHlgesfEu8yEzT26ic+oOkXLM8lArzz4rNjtsCaAttEPRGY8Ev5T+3MYyFFt1zPMAj3l4pNnjYXfPsVEJ6PNljIxrA405LVjRhv9MAXGIcWZ4/aYbsKwB7bmmMFMLdVhMunxekrii7iIOYB4Ezp82WfCE0wlz74BlH
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Installing a writable vmemmap page requires consuming a replacement page,
copying the current contents into it and making the copy visible before
publishing the new mapping.  HVO currently splits this sequence between
the page-table walker and its caller depending on the remap path.

Centralize the sequence in the walker so all writable replacements follow
the same copy-and-publish protocol.  This keeps page preparation with the
mapping update and removes path-specific handling from higher-level HVO
code.

No functional change intended.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Reviewed-by: Qi Zheng <qi.zheng@linux.dev>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
v3:
- Use two tabs for the new helper parameter continuation (suggested by Mike
  Rapoport)
- Collect Reviewed-by from Mike Rapoport

v2:
- Collect Reviewed-by from Lance Yang and Qi Zheng
- Replace page_to_virt() with page_address()
---
 mm/hugetlb_vmemmap.c | 40 +++++++++++++++++-----------------------
 1 file changed, 17 insertions(+), 23 deletions(-)

diff --git a/mm/hugetlb_vmemmap.c b/mm/hugetlb_vmemmap.c
index d3058e106795..531150870aac 100644
--- a/mm/hugetlb_vmemmap.c
+++ b/mm/hugetlb_vmemmap.c
@@ -199,6 +199,20 @@ static void free_vmemmap_page_list(struct list_head *list)
 		free_vmemmap_page(page);
 }
 
+static struct page *vmemmap_dup_page_from_list(const struct page *src,
+		struct list_head *vmemmap_pages)
+{
+	struct page *dst = list_first_entry(vmemmap_pages, struct page, lru);
+
+	list_del(&dst->lru);
+	copy_page(page_address(dst), page_address(src));
+
+	/* Ensure updates to @dst page are visible before set_pte_at(). */
+	smp_wmb();
+
+	return dst;
+}
+
 static void vmemmap_remap_pte(pte_t *pte, unsigned long addr,
 			      struct vmemmap_remap_walk *walk)
 {
@@ -211,16 +225,7 @@ static void vmemmap_remap_pte(pte_t *pte, unsigned long addr,
 
 		VM_WARN_ON_ONCE(!PageHead((const struct page *)addr));
 
-		head = list_first_entry(walk->vmemmap_pages, struct page, lru);
-		list_del(&head->lru);
-
-		/*
-		 * Makes sure that preceding stores to the page contents from
-		 * vmemmap_remap_free() become visible before the set_pte_at()
-		 * write.
-		 */
-		smp_wmb();
-
+		head = vmemmap_dup_page_from_list(page, walk->vmemmap_pages);
 		entry = mk_pte(head, PAGE_KERNEL);
 	} else {
 		VM_WARN_ON_ONCE(!PageTail((const struct page *)addr));
@@ -253,15 +258,7 @@ static void vmemmap_restore_pte(pte_t *pte, unsigned long addr,
 
 	VM_WARN_ON_ONCE(PageHead((const struct page *)addr));
 
-	dst = list_first_entry(walk->vmemmap_pages, struct page, lru);
-	list_del(&dst->lru);
-	copy_page(page_to_virt(dst), page_to_virt(src));
-
-	/*
-	 * Makes sure that preceding stores to the page contents become visible
-	 * before the set_pte_at() write.
-	 */
-	smp_wmb();
+	dst = vmemmap_dup_page_from_list(src, walk->vmemmap_pages);
 	set_pte_at(&init_mm, addr, pte, mk_pte(dst, PAGE_KERNEL));
 }
 
@@ -499,7 +496,7 @@ static int __hugetlb_vmemmap_optimize_folio(const struct hstate *h,
 					    unsigned long flags)
 {
 	unsigned long vmemmap_start, vmemmap_end;
-	struct page *vmemmap_head, *vmemmap_tail;
+	struct page *vmemmap_tail;
 	int nid, ret = 0;
 
 	VM_WARN_ON_ONCE_FOLIO(!folio_test_hugetlb(folio), folio);
@@ -531,9 +528,6 @@ static int __hugetlb_vmemmap_optimize_folio(const struct hstate *h,
 		goto out;
 	}
 
-	vmemmap_head = list_first_entry(vmemmap_pages, struct page, lru);
-	copy_page(page_to_virt(vmemmap_head), folio);
-
 	vmemmap_start	= (unsigned long)&folio->page;
 	vmemmap_end	= vmemmap_start + hugetlb_vmemmap_size(h);
 
-- 
2.54.0


