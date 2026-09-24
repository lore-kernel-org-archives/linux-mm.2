Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 77DD4C98314
	for <linux-mm@archiver.kernel.org>; Thu, 24 Sep 2026 06:54:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6F00A6B00A1; Thu, 24 Sep 2026 02:54:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 69F596B00A2; Thu, 24 Sep 2026 02:54:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5683B6B00A4; Thu, 24 Sep 2026 02:54:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 27FA46B00A1
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 02:54:07 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 955801A0268
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 06:54:05 +0000 (UTC)
X-FDA: 85247741250.24.5F77D07
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf30.hostedemail.com (Postfix) with ESMTP id 6527A80005
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 06:54:03 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Sl23vWiK;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf30.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790232843;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vz+W5yHAoWI5ZxzvIYZX65gg07ZvreXTcI/Y7c3cDnc=;
	b=6GPLmOJH50/iqqMQsq9tGB2DAN1+q5ZlDAgBU9S1DmsVXa5tv+NMw34eo90VZ4iMu1i5me
	IICZkYf+boxsS7+gEiSpX1ljeWryhmJWQbKT9OEDy6PtjXx3tt1wkT8w01eOYfTDQ0Fscz
	66GSkwdYtV6riZOa3/F6slza0NHSQUE=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Sl23vWiK;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf30.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790232843;
	b=dIDFFOXWzA3HqmpGh7VQDGxXc3I0T7IYdotbG9Y5Cm1jk1TTEm5Jcr0iTSiRrNHJH0vclR
	d9wWxAfO63eSb6d10YBiMdpsPYgZU9so9PzzvDoqDJ/L/FIlYlcIxSe6TbWlh9eaKOUjpv
	SPlCmj/0XtiiWF5Esv+iOqdvoJhA7Bo=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1790232842;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vz+W5yHAoWI5ZxzvIYZX65gg07ZvreXTcI/Y7c3cDnc=;
	b=Sl23vWiK1SlrSeVkszoxOCTdUzwfOSoLlgVwHCcRdZtGbic/c8a9RcLBoeLAqQIHuHOqjA
	+Q84cYwobS+/ZYsFIYK2Si7sgsRidcEpL9p0JtC2HE8Zatx/5ldJndVoG3fR6chhPm6bbs
	vTjlTUJCUJFS8RkXTfI+hdXZAuGEvf0=
Received: from mail-lj1-f198.google.com (mail-lj1-f198.google.com
 [209.85.208.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-258-eW7XPIEJNgm4ZKXpB-UFfQ-1; Thu, 24 Sep 2026 02:54:01 -0400
X-MC-Unique: eW7XPIEJNgm4ZKXpB-UFfQ-1
X-Mimecast-MFC-AGG-ID: eW7XPIEJNgm4ZKXpB-UFfQ_1790232839
Received: by mail-lj1-f198.google.com with SMTP id 38308e7fff4ca-3a58fef21b3so6898531fa.0
        for <linux-mm@kvack.org>; Wed, 23 Sep 2026 23:54:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790232839; x=1790837639;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=vz+W5yHAoWI5ZxzvIYZX65gg07ZvreXTcI/Y7c3cDnc=;
        b=n9uuVPQtBIPxB9FCe3Ut8LRQRQZPf1e5D4VD1YZFDNYeyTy+sHdzKYJczdy55Aqnty
         5LmXxAZygvF/ZbeA0FLxU+JnnkMWpnfoorIamka9STsn/6s4eZg48pGUy3aTttVlI4Ao
         zs7UPR7awxgEx1qLdFL7K+rnR+QJvA3IC6bV/779X4Osr7l4bengM4U9BVc9JirR/url
         tah1q4uwKdFv/DQCPBeXEK/9pIHUvAJX/e0HNqu943Nlp/bJx0Tzh+/2nddosWJXlbh1
         applTQ1NI1LcEhGW5ps6QzxBZPLaMBIU39Wv3x7Fkn9ZjUtps+C/uCZEmyTzYEM2hcXD
         wikA==
X-Gm-Message-State: AFuF++k3J7XFMgS5GrczaxFvUVwAe9CdHM+U6ZcG1LkhZTaJkejb7FQt
	JyuNuQa6iOI3BaO/CRmv393AH5wY741Nq6vKiC2l90bED9eTnfQSvXWjz5ddQxaSllN7fbRbSk0
	cwO4f7EwefE3lJB6MG3PUcCcC5OQziQyskl4bxhFX+3yl73R7odVK/lJkiinYCOQPwLoejM/+0m
	xlLYdxxOB0jNBZePm/VF78Ob+52k5/10Z3dmDSbA==
X-Gm-Gg: AYBFou0vCso/W2VFrctC0aVZPbth+uWj0sWgBuDEIepu/8pl4Uq9X2APNcU7oj2BEVA
	8dI6K8nh98/+YYmDzQkOBiJhMyFMWxhVyKDvjZz3Nr3qYW5a9Xa+03K35EKVDppRRlz7icsyBpJ
	Y7Xx1CFxekruwidkxB9ngivGTYrSZoThGsRRZ3pmRCGl/cm9z9VEQPVY60/RLX/6BEOY04qwcKp
	8uw97O8uTSCLNx4BnZbyCauH0QmYhFLkRkPHYWfCiOn0I7aNAcVpdhkKiWeoxIG7WoGoV6Qtuvg
	i1EVOJeWy+CF7lCH52xLqGfJyJxt7fMrAZsKVoeBzAnwv3aCMzqs4O8xiBhPcRhPCjmHDfdgHKX
	B3XspSdkn/E/B4Dy7lxny
X-Received: by 2002:a05:651c:a209:20b0:3a3:7680:67fc with SMTP id 38308e7fff4ca-3a63c2ffcbemr2309011fa.27.1790232839348;
        Wed, 23 Sep 2026 23:53:59 -0700 (PDT)
X-Received: by 2002:a05:651c:a209:20b0:3a3:7680:67fc with SMTP id 38308e7fff4ca-3a63c2ffcbemr2308741fa.27.1790232838723;
        Wed, 23 Sep 2026 23:53:58 -0700 (PDT)
Received: from fedora (89-27-86-246.bb.dnainternet.fi. [89.27.86.246])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-3a63bf57909sm4803141fa.29.2026.09.23.23.53.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Sep 2026 23:53:57 -0700 (PDT)
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
Subject: [PATCH v15 07/11] mm/hmm: add lazy MMU mode support for migration in HMM pagewalk
Date: Thu, 24 Sep 2026 09:53:09 +0300
Message-ID: <20260924065313.899730-8-mpenttil@redhat.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260924065313.899730-1-mpenttil@redhat.com>
References: <20260924065313.899730-1-mpenttil@redhat.com>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: mdy8coTvZ9UvuGjkEYXdGKQorpoyOWAS_CksYBChx6Y_1790232839
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: qa3bdf7jrddjefu8goo8fo43fcgpasuh
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 6527A80005
X-HE-Tag: 1790232843-720967
X-HE-Meta: U2FsdGVkX1+JcB2j+SD9XQqdnHh9/4KFmpnC5GqfjGZaQHeCRtHZk5mPQ87VbHfXDVRmXZ/je2smavBFRxtFy/trzUNm9U+cb8Dy8NIT+ETjEp+3gRNS2OAUc2Lqypw4gf7UJIHApgYFjxQ5lN8QRfBAK2ExKVqNMu9kuVtpWEbdwAmdYXk6xUTATW4w3P9tCes2VFk+lAiZVDtVN74LdHigrJWWOl+hds+X/L7+EEiXgaNyOaSI6vCQkhjDl2teX2Ynq+YSsSJrzPoOTMScynUiBRZDRY84VeEEVhVF5vzEArsfsHtW2xG/zhdZUKrQ1fxu2pifASJYKdtuaIjYbFsJH7n7seCkqqDjv+OSWIz5HdltFjGMiLlAQH6HDu8ikfovbevTtgSkNpZbWhKipmW3OvCvArIeNdjVMLTNGF6zvYKwo0KthxT4AGoF5JZcKDvWp+cEartSRn3CudPM/eyomMJnNkt0yJCy+6YE2j1Hu6sDZ9tkPwlfShZpKzGS1AXbC8MwIdc2Zw9ojkQ+8oaLhKtiFM1s+jZqlIxtE/3XfxJAhqMwKNsjo3oVAQE/LjYTKKykQ5B2c43T79gVJp+JC7KTYoB6rHgz1Dt1Dli8JPIg4K+NTEvjvmbrWdjymyEOblIEiY6Z9Srow5mHXTLf7S5JHF+3GFaZP4msVKqlTqEpCw+4o6Cv0O7gxDWC8J2hmCrW/tTTUzvhvgtn0U2j/+IWZ11FsxR9jDuIWDA6GIGlMc71jCeqhCUyGTcsnST3HfApZTwr4b6MbngZZkX4WQ0vKbcWnjSo2oBCsaNHoI4THU4UWML0+F7nT/b1pnhDcHkRrBYFXparfIcXf1l9BN1S1+lYT6eJQCCNT6YXCayN++qgWbTJdtoQ6uvJOcFzhi0pSguOlKH7TDXCq5v4h0cmEuZXqU+OEULAbNIXE3368ker7ehrQO/ZIeZm5iaTnm9Uy+WQHcv2Xv0
 t+7Ds5jp
 sHLz7raW3XNuqTs8aGQEOxuBsH60v17+NoDM+F5XH00IK/JCZfm7hFNqWjJO2FKGhmzfUFMKmmayGEhK7ketgWiDDhZpE3hJ4QG+w0z9fl5duVFl2nlyOrmHYZ5rHU9lfcN5M8QcV4ucsR9sVZmMDzje/ueFjzv49Q95mBIuUx4pqEuqyzv2GsOmh7jjdpng5LAv69R4G3DiWY8g/A5eGzUPogrfEJLzi/qm0AL1UO28MSgNL9x67BrcmV6WYx8Cpyffb+JcmRs6kEJfNFlVRRfEGRkqi4L8CIEp/Blx+90NrdKsFdlnm9jxMb6LL6Xd5hLzR9QriKCoD4i9bxD6GeSmCQAT+Y7VOCtuNERbcnmR2SWn4ieRnT2ooObdbp+Lcfii6vQC0y4pecKry6EBRq1iIanFMSbvmcMz4fZBCFj8rgIrmBMs90tuX9HhBxgwJEWBEy8o4CjZnX75epTXsymI0RZIe0RcnQ104ZcrcvcdqO40=
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
index ea77429c5178..9fdd945cc026 100644
--- a/mm/hmm.c
+++ b/mm/hmm.c
@@ -373,6 +373,7 @@ static int hmm_vma_handle_pte(struct mm_walk *walk, unsigned long addr,
 		/* Report error for everything else */
 
 		if (hmm_vma_walk->ptelocked) {
+			lazy_mmu_mode_disable();
 			pte_unmap_unlock(ptep, hmm_vma_walk->ptl);
 			hmm_vma_walk->ptelocked = false;
 		} else {
@@ -396,6 +397,7 @@ static int hmm_vma_handle_pte(struct mm_walk *walk, unsigned long addr,
 	    !is_zero_pfn(pte_pfn(pte))) {
 		if (hmm_pte_need_fault(hmm_vma_walk, pfn_req_flags, 0)) {
 			if (hmm_vma_walk->ptelocked) {
+				lazy_mmu_mode_disable();
 				pte_unmap_unlock(ptep, hmm_vma_walk->ptl);
 				hmm_vma_walk->ptelocked = false;
 			} else {
@@ -415,6 +417,7 @@ static int hmm_vma_handle_pte(struct mm_walk *walk, unsigned long addr,
 
 fault:
 	if (hmm_vma_walk->ptelocked) {
+		lazy_mmu_mode_disable();
 		pte_unmap_unlock(ptep, hmm_vma_walk->ptl);
 		hmm_vma_walk->ptelocked = false;
 	} else {
@@ -555,6 +558,7 @@ static int migrate_vma_split_folio(struct folio *folio,
 	if (folio != fault_folio)
 		folio_get(folio);
 
+	lazy_mmu_mode_disable();
 	pte_unmap_unlock(ptep, hmm_vma_walk->ptl);
 	hmm_vma_walk->ptelocked = false;
 
@@ -1110,8 +1114,10 @@ static int hmm_vma_walk_pmd(pmd_t *pmdp,
 
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
@@ -1155,6 +1161,7 @@ static int hmm_vma_walk_pmd(pmd_t *pmdp,
 		flush_tlb_range(walk->vma, start, addr);
 
 	if (hmm_vma_walk->ptelocked) {
+		lazy_mmu_mode_disable();
 		pte_unmap_unlock(ptep - 1, hmm_vma_walk->ptl);
 		hmm_vma_walk->ptelocked = false;
 	} else {
-- 
2.55.0


