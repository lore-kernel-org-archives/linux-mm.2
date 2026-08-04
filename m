Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7C536C55ABC
	for <linux-mm@archiver.kernel.org>; Tue,  4 Aug 2026 04:27:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 978066B00CB; Tue,  4 Aug 2026 00:27:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 928B56B00CC; Tue,  4 Aug 2026 00:27:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 817B56B00CD; Tue,  4 Aug 2026 00:27:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5BD6F6B00CB
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 00:27:35 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E7D48A2379
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 04:27:34 +0000 (UTC)
X-FDA: 85062303228.29.74CC5B1
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf11.hostedemail.com (Postfix) with ESMTP id A24B940008
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 04:27:32 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Lkj5FDX7;
	spf=pass (imf11.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785817652;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lxWvLz6f1rN1o4scxqJnXGGSQRdc4CCCHPneXFEhe/4=;
	b=rD2J9pF9EHJKVPSAo3JZAjRTOJNwMtt1lZkRLmWU3TQRMqN4wQrqKwy1IYPnEParEJndCt
	CvM0b7LXB58QuJayLQ7lljbtz4yLsR1UOlEtKCbU1lgZqMpNAU7aqZcA4J07aUS0zJ7bYt
	hlLyoIaVOkhAfrVjbftfrCtI22MKKUo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785817652;
	b=WYCuuvWokAHzJgw66Ykbfcx+DhGIKTSszVditQ/TnDrU2EJ23uyokE0Hwhe3AfZ7aty25h
	8Ovrsl4KvwKxzQEd0OVb2oaOMMjD1KqlIKgs2AHA0fq9692UO1KuVDv/ORW/01873mhbVJ
	sH9oWFqwZ+6aj0F8YJ8NwtFwo/33GEM=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Lkj5FDX7;
	spf=pass (imf11.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1785817652;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lxWvLz6f1rN1o4scxqJnXGGSQRdc4CCCHPneXFEhe/4=;
	b=Lkj5FDX7aTCGZr8HUVe4QfoBGDDtkJRQ8iQHkg2yTBD9nTNInzyceJ2sMMZgUem9aMsFNg
	ZgRyWuixMEHAcWAB1z8858ZjPREa8Xi7lM2sAXVLf0sSjN4vJG1dR599qKx2Kdj0+wwhLh
	9GDTa+NEaUBiZ0Zecjh8irkjZQzzwjM=
Received: from mail-lf1-f70.google.com (mail-lf1-f70.google.com
 [209.85.167.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-272-nuKruXF7NCSQAogcqZVq-w-1; Tue, 04 Aug 2026 00:27:30 -0400
X-MC-Unique: nuKruXF7NCSQAogcqZVq-w-1
X-Mimecast-MFC-AGG-ID: nuKruXF7NCSQAogcqZVq-w_1785817649
Received: by mail-lf1-f70.google.com with SMTP id 2adb3069b0e04-5b2d7c7ec76so1826120e87.1
        for <linux-mm@kvack.org>; Mon, 03 Aug 2026 21:27:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785817649; x=1786422449;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=lxWvLz6f1rN1o4scxqJnXGGSQRdc4CCCHPneXFEhe/4=;
        b=grMgcoYM/jA7dyStXr/n3B/XfG+9HmwvdDCS5csKnJFNLQdJpJZNwogz1QhSfBS8sI
         ds4+ND4l8uBNcTHRWGEb3q5yD12U/8FkeaoUWqdv9AXV5/aGrZ3oKW9jFiQ0vemo+FR/
         QhZbej/tnVnEB3cOtM6BkQ8N5zIxSZN+yZmAw73sossDuM+UwjYg+7hd0GWTj/k/jKsf
         /PUbKVjgRmvxkS4JQuMj3KxCK+Y4VCoKgFSU+Pn9ftdRawgna0TNW3gt8oyVrFJRc8nv
         UiJDK0VUfZS1MTmzuSP7e9ohFRzn+BcxyhRS/3/mhDxdJ12pFFJYpwxCwRwY+RgSj/CH
         52ZQ==
X-Gm-Message-State: AOJu0YwINkf8p6OpYfShrBkoTq/DmBIFVf5rBad+1hSeALGRkwQfb0uT
	RzP/zL5e3hT2M63mQTp0lcanFLa2BUAhkbR2bJIZZ9NrCbrIQ1xo4ANWZnh3D8AHaJ7Zkp0lg6P
	m096r9ZX8ALC6pBmQ9L3j9wIUuFO0UiHw+8X4TURgOJqB2pXjE5PMyNYt9gUXEiEfT+0ZuLj678
	tGLx046+6tKHU5VMulBkYnhlba5GfHiRJ9Q5ApYA==
X-Gm-Gg: AR+sD11kg8EL4Gyszg2tJ3qT7uvPRGWxvibikWYVtJNe0poRQeJ2iorjqKKvsDKgh62
	Ak6bNNsyBtquFaKHpw/ZaVpUnM8NPBZqX+pf+uZm0yiGX9HxritGhEkIj4+5vYsqKAeIjk1EirI
	uHOIPq69RtinMr9eb6ySkHpKtCZJfyypVRPXlo183EyCM2AxlmodxRUXFSj1/jbbKD/WLr61Yw/
	09RPugtPclNvhXt8srK4G2dTjMNuV7PBRyWTgUWs2JkaMtSROXder0Y/UCvsQg30z1SOQJr0Fln
	xEggL+0LoeMPCGGRh9MHZHjiTWvAuP8m4+vgDZ81oyDO2mJ7QKp4C6Z7FnJgoWhyW6xttiqe0t1
	ckmYaw41GjayfdAoI
X-Received: by 2002:a05:6512:8051:b0:5ae:b86b:71ee with SMTP id 2adb3069b0e04-5b2e4f6d5c4mr1858481e87.38.1785817648668;
        Mon, 03 Aug 2026 21:27:28 -0700 (PDT)
X-Received: by 2002:a05:6512:8051:b0:5ae:b86b:71ee with SMTP id 2adb3069b0e04-5b2e4f6d5c4mr1858457e87.38.1785817648175;
        Mon, 03 Aug 2026 21:27:28 -0700 (PDT)
Received: from fedora (85-23-51-1.bb.dnainternet.fi. [85.23.51.1])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5b2e23c46c4sm2311351e87.17.2026.08.03.21.27.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Aug 2026 21:27:26 -0700 (PDT)
From: mpenttil@redhat.com
To: linux-mm@kvack.org
Cc: dri-devel@lists.freedesktop.org,
	intel-xe@lists.freedesktop.org,
	linux-kernel@vger.kernel.org,
	=?UTF-8?q?Mika=20Penttil=C3=A4?= <mpenttil@redhat.com>,
	David Hildenbrand <david@kernel.org>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	Alistair Popple <apopple@nvidia.com>,
	Balbir Singh <balbirs@nvidia.com>,
	Zi Yan <ziy@nvidia.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>
Subject: [PATCH v13 08/11] mm/hmm: add lazy MMU mode support for migration in HMM pagewalk
Date: Tue,  4 Aug 2026 07:26:28 +0300
Message-ID: <20260804042631.2175585-9-mpenttil@redhat.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260804042631.2175585-1-mpenttil@redhat.com>
References: <20260804042631.2175585-1-mpenttil@redhat.com>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: Z3JEhQH1wNFpA0bq3PJVaFlArC5Xzd4FFkrCMVOciOg_1785817649
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-Stat-Signature: o6crurnhtqsa8zjzipfq4b497yfxji3p
X-Rspamd-Queue-Id: A24B940008
X-HE-Tag: 1785817652-426811
X-HE-Meta: U2FsdGVkX1++Y3c6IeUQfFi/0atIbVQvbifQ6Bh2wmKuw7jGD99iV6IXWgugOAJX1QjjOg1Zft2CYcpUZKAEspCEbn5GxEV29BTRFwZ30iNk/eWpRKIR3eBrYcO7tlAu7W4/LeGl2E5WHzXGQy7TpSvGmS4pEI0jGMlORCtRySDsJXfUfGH3aKhYLWCDzGBLZVHhxg7L+AcBwjqYrGd+Kqo/5ig4fKCM5fcWS1SSp4uAb5fRQ6XXm9aAyNFazPx0+M/Br2DAseXBZF9okUXZWu7Ofe06VuKpXWbcVQ5rE2CG6S+G8epGYRiEtis1plR83sFXwqQ8w4egPO+o+c/NCQdSphgHRMXLzzM+a6qzBpQzGlqM21wJxz3QNMfUUB8E/tnd+RcEuwkjwwCpyetNUMlUIjfJ/xEr4bZpI7b7qoon5pZ4W3TC21bI5ZnqAhtnsE+lnbhE2afZgjtORqOAf/nm+SM7gkXz0aa6N9sJssgZCXo9PkK53gN9CiV1vHyKFdVKCdY2wGuQo7CeK/7n8mujyIPJXcOTj+pzOuUJIth9JE0L14BqiyUvOQ6Ag74+sxPyxQ6nN9brhUHhY1qzcK7HS7Euyz05jW0PJs0LzGblAe3otPE7HXuGpDxqcEvO0zunNL9SPWf3Wv4Arnf7i+Ox9UMC93VwpcMz3fLzCv8UtwEfSrqssirIGlMPs5eyhBI2A8AljnWc2rfiOfdyV1aIOdUUn/uCb6MAWktRit3Q99jhHoSZI3JsQqXFeJNnfPQ3q+S/EXABrdZu/vCNq6vGjit+QSMVb6+SqvsMUAaIUthf6p4km2QW51gAbQ4O1K+uWLRo6uq9XvSkaP6UD6zgCduFAAHcPGYVrDh0JxgRmbDRZe5RnHRICpGoAA/DCNHpGSSI7njRvRcyw7Tul9PJH0bvov/qka7SVDYMFSnFjXSMCTx/uuXrlR3wU8qE0naZWdS3TMjA/YKGik0
 rbZrkFrK
 Wxe+Lldqdv/II6Rdm3h4m++67hGffHH3P2nCNLiAc48Mi2v6u6kQlwXiAM+csOuOsqa/7AU1N8DZk6lXxJxVCwJeJ+zELsANW/tARuXmlD+o6TI/kqIs5lY6LeJkjr6+5auntiE+jBbaj52IeyXo9e44dWGUSjlKCQDPQX/idB8uKJpxQxBuR/QUED9nSo7WnqCSSsEYci/k1vCpCFKgsVreN7a1+fuB66h8aEDHskJjOokyYq8XKyehYe1Bf6UrhiBqWgUF7SyTsWv3AIP+XTs08sAmoaSVqNhzbETRKsqbMBNThdYRe809xWwqF7vhlXkf3+USSe0Q2100igruQ7BLDYXtNDFUxBZw6WCWAtHO7py77bPoK59PzBaepqlJKs5lKzlTweCd7zh1ZfEyeTwfzJCscvw+3fS6IiGhX0nzMlrlYGnztrNR2y5YP7zbk56K53MrNf+v65/DwbvwwU3j5RkXewqPFQdJ/XbzoYBRe3NQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Mika Penttilä <mpenttil@redhat.com>

Add calls to lazy_mmu_mode_enable() and lazy_mmu_mode_disable()
while doing migration.

Cc: David Hildenbrand <david@kernel.org>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Leon Romanovsky <leonro@nvidia.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Balbir Singh <balbirs@nvidia.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Matthew Brost <matthew.brost@intel.com>
Suggested-by: Alistair Popple <apopple@nvidia.com>
Signed-off-by: Mika Penttilä <mpenttil@redhat.com>
---
 mm/hmm.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/mm/hmm.c b/mm/hmm.c
index 61b9147fd8ed..631f6b4d52fc 100644
--- a/mm/hmm.c
+++ b/mm/hmm.c
@@ -368,6 +368,7 @@ static int hmm_vma_handle_pte(struct mm_walk *walk, unsigned long addr,
 		/* Report error for everything else */
 
 		if (hmm_vma_walk->ptelocked) {
+			lazy_mmu_mode_disable();
 			pte_unmap_unlock(ptep, hmm_vma_walk->ptl);
 			hmm_vma_walk->ptelocked = false;
 		} else {
@@ -391,6 +392,7 @@ static int hmm_vma_handle_pte(struct mm_walk *walk, unsigned long addr,
 	    !is_zero_pfn(pte_pfn(pte))) {
 		if (hmm_pte_need_fault(hmm_vma_walk, pfn_req_flags, 0)) {
 			if (hmm_vma_walk->ptelocked) {
+				lazy_mmu_mode_disable();
 				pte_unmap_unlock(ptep, hmm_vma_walk->ptl);
 				hmm_vma_walk->ptelocked = false;
 			} else {
@@ -410,6 +412,7 @@ static int hmm_vma_handle_pte(struct mm_walk *walk, unsigned long addr,
 
 fault:
 	if (hmm_vma_walk->ptelocked) {
+		lazy_mmu_mode_disable();
 		pte_unmap_unlock(ptep, hmm_vma_walk->ptl);
 		hmm_vma_walk->ptelocked = false;
 	} else {
@@ -507,6 +510,7 @@ static int migrate_vma_split_folio(struct folio *folio,
 	if (folio != fault_folio)
 		folio_get(folio);
 
+	lazy_mmu_mode_disable();
 	pte_unmap_unlock(ptep, hmm_vma_walk->ptl);
 	hmm_vma_walk->ptelocked = false;
 
@@ -1132,8 +1136,10 @@ static int hmm_vma_walk_pmd(pmd_t *pmdp,
 
 	if (minfo) {
 		ptep = pte_offset_map_lock(mm, pmdp, addr, &hmm_vma_walk->ptl);
-		if (ptep)
+		if (ptep) {
+			lazy_mmu_mode_enable();
 			hmm_vma_walk->ptelocked = true;
+		}
 	} else {
 		ptep = pte_offset_map(pmdp, addr);
 	}
@@ -1169,6 +1175,7 @@ static int hmm_vma_walk_pmd(pmd_t *pmdp,
 		flush_tlb_range(walk->vma, start, addr);
 
 	if (hmm_vma_walk->ptelocked) {
+		lazy_mmu_mode_disable();
 		pte_unmap_unlock(ptep - 1, hmm_vma_walk->ptl);
 		hmm_vma_walk->ptelocked = false;
 	} else {
-- 
2.55.0


