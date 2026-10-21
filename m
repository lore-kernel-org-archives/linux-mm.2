Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1226F60A262E
	for <linux-mm@archiver.kernel.org>; Wed, 21 Oct 2026 06:05:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=ZUv1SPEc
Received: by kanga.kvack.org (Postfix)
	id 6C0976B061C; Wed, 21 Oct 2026 02:05:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5FDBE6B061D; Wed, 21 Oct 2026 02:05:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 475886B061E; Wed, 21 Oct 2026 02:05:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 157886B061C
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 02:05:50 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 6234112045D
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 06:05:49 +0000 (UTC)
X-FDA: 85345597218.03.D9524BC
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf31.hostedemail.com (Postfix) with ESMTP id 9005720003
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 06:05:47 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ZUv1SPEc;
	spf=pass (imf31.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792562747;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cRp11JQAq7GQu9HIl0KlaLyGmrFE0h6wJDEFiX0LaJY=;
	b=ISPCRN0duRMsxih3ILT4eiAeTA6O3rHoqJDJee+QVv+C/4cLAKCCD6CTg/z/ydkD7FVmIa
	bCAaC3Dn2MgoYLfNsujq+mGCynUOPwwpuxkRtwrp1hTtQ9pjMYnJx+xoiucc6Nuge1atgL
	5nM40O6W42Nynz2Q115iFY32ZLbFqBk=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ZUv1SPEc;
	spf=pass (imf31.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792562747;
	b=cwqCGGlAwBzYOYfLgg26JlThwGzwbm4YE4TFyUhMBVfElpnYkkk4RIVbuY6mS1kzkK7Quo
	03n/Ay8pOTiJ+dpsBWW8VfLsopXv2fJ0BpAJBP1db+kbQ/xH7Qur/Hu0VX/JtEr+/epa55
	3ozDuC4oJZBWWLhCOWWvL7B/vtrNtqk=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1792562746;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cRp11JQAq7GQu9HIl0KlaLyGmrFE0h6wJDEFiX0LaJY=;
	b=ZUv1SPEcxNq+KylGKCpKLZZjGGC7XSqZFxO3iIQzC+M0QW0KNnGySnczaUZpxH52x25tgx
	5Eq6sT1JxU3kgqXNHiCSrvuK17qMEGtsy/ulaTrej00GgMQxv6bJ0jixEQ5fZ/+a6wsNCY
	CcqU96T8wXp8ys76TnGWHXu3JUEbO7s=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-584-Yt6aOYB_MS-DEtPkfC2Nrw-1; Wed, 21 Oct 2026 06:05:45 +0000
X-MC-Unique: Yt6aOYB_MS-DEtPkfC2Nrw-1
X-Mimecast-MFC-AGG-ID: Yt6aOYB_MS-DEtPkfC2Nrw_1792562744
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-48e0389d6f9so153609f8f.1
        for <linux-mm@kvack.org>; Tue, 20 Oct 2026 23:05:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792562744; x=1793167544;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=cRp11JQAq7GQu9HIl0KlaLyGmrFE0h6wJDEFiX0LaJY=;
        b=BHnvLBOUaTViNLtrPxtLuZFMerUM5SUUP5lUFUFIusRbISiAJ2hpAWylUZWaXEylt/
         iLulWiyUJAiOZsV0wFfTMEbL0CKLWBSJl1OdnrUuYmhdFbDN+l7fyjw1Xzf+A+1W0tr7
         helnzTssUnEqWUMLnXFn8FPnvHyD5C9sOVZoaxa2BBfOiHC7tpBqvSisr+U4Z4vdzBQ2
         dd6vG/8ZgEAlbuqizWof7CtYaj51V30jGL4q6R8RutNLfDZnJksvGpErDXGjM9wTA+Dl
         jntOM00cceNs+UdL51g6lWHdMezFkxiWc94Po/JztagVsA5j4r22PgXQWSlpmsQa0Z/z
         o+Yw==
X-Gm-Message-State: AFq9FYJHK46fmGl/qXY/7fz4b7CuhAf6nf/JHtBXtYXlxAZsf9YCkqXV
	oXrfAHmCm4jHX1PQgllUECHALspglWxMemrBrrGVckKfMZ/6fJYFGztBXgvTPhA+Xhc63O6vw4d
	3gNPp38Y18zAo5FTxHKOpzHBbTph9G0jiaIOwV2DjD3OmEAFEVvyJhognBFvhvvH020bvkT2uZo
	K+DTxWGX0d8zEMZ6ksMCvb3gErG/Se37a2TXHCCg==
X-Gm-Gg: AYBFou354+PcxsnJyMBy9AaXIQw3v/toEvf3VG8b+r9m1M6Kn5DIrPk8GsaKU66RiV0
	8u9nHJkHCdkPYh807NwT2eEGkqJZTtuseX6YTZCWMaINtWOP/iAvclzrYMXsZ8gMXWn/0g85hB5
	Sn2fvn4NRPoleaAgE2TWQvAJsAX1rnpD4bGH01ewHDCdQTPfbCXVtw7DEy59la0j6WEkE/38PQn
	QB7i38OXZVwB730/AjWe956B/9t8PEWpCnhCglrWUlNxy8enk/qC36cPloRySnXEBvH+m+9anSx
	WgU494gkYSczOnuyVMukzpdofVmtW/52Ssq8zovHuTN08nnsJjLrhluTr91BAyjH/h3XlyQq9VT
	Hq8H4/YIwOj0SGUu4aJmy2QiTYUhLZ6061JOv
X-Received: by 2002:a05:6000:2612:b0:48d:f9a4:bd68 with SMTP id ffacd0b85a97d-48e264e3068mr1528363f8f.27.1792562743483;
        Tue, 20 Oct 2026 23:05:43 -0700 (PDT)
X-Received: by 2002:a05:6000:2612:b0:48d:f9a4:bd68 with SMTP id ffacd0b85a97d-48e264e3068mr1528301f8f.27.1792562743063;
        Tue, 20 Oct 2026 23:05:43 -0700 (PDT)
Received: from fedora.redhat.corp (89-27-86-246.bb.dnainternet.fi. [89.27.86.246])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e254f02f1sm3413741f8f.3.2026.10.20.23.05.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Oct 2026 23:05:42 -0700 (PDT)
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
	Michal Hocko <mhocko@suse.com>,
	Lyude Paul <lyude@redhat.com>,
	Danilo Krummrich <dakr@kernel.org>
Subject: [PATCH v16 07/12] mm/hmm: add lazy MMU mode support for migration in HMM pagewalk
Date: Wed, 21 Oct 2026 09:05:01 +0300
Message-ID: <20261021060506.2377545-8-mpenttil@redhat.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261021060506.2377545-1-mpenttil@redhat.com>
References: <20261021060506.2377545-1-mpenttil@redhat.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 9aQ3WErC9f47MK_VQGcyr1FFymgSbNwZsynUTwjs0Kc_1792562744
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 9005720003
X-Stat-Signature: uwegahrhi7tcjjfoie353snh3yx74tzw
X-Rspam-User: 
X-Spam-Status: No, score=-19.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1792562747-457441
X-HE-Meta: U2FsdGVkX19cO7nyzlhQTgJsHcV8xQMsxkB6jYvD0QJbNp574/DJ3h9ACLNsTMwu0/fTg441aTZ8146ap9VUy9RssrL4h8Vnul76wt2ftjpWmIPu10cejsn17LaFqg7mTP7trwIoiDASYQAZTFCG68HLW/Slvtvs6kzvMyLY/jMZz2s2gbc0oqnrCF+UvtrgS6ftvuUhhDpeyxObnlGe9slc+7DmZGQULxhITwd8UHh3RQ16X3IPqqmV9nb+N3Ur6m+t/n7euw4u0LzZA35nl2BKscWWj0rBT/umVo8xra2b/TAYg6RvPT8fsvjpaNENoaswgNgaopUZ0UfUj4IixPIAuCI7gOSETmaxRmQjPMikf5zDcBBXvpq4VYLlD2DVnQS50FO0XyH/o8Szy8dPizMMLKCHYaWS9Puzrm9zgz5zjd+c5dF28Dyjkq0I+h+KfRg1/kUpTEUbM/4CZfrVaz5nFk0OrnBESY03H+hTclf8WE4J3wLfETz9W9of8do6aeQgRASDdKBM37Sm3kYDJiOya6tgB20Bd3ytags/JYGM32SBWQwkh4G3bj+T0ESqMcFjXgY1iEYhjl5d9nu67vPTrNOnjwbnCUuBIYTg+6Ir4EVIK2yvCmJ95tcnWsYNDmWdPKdKoH8UmPg1FuQhul5B8LJ+P7X9YDEokOh0rf7tdOC0g+nUZuZpaRWEXaMqY4G1T1ynaN+kz1tAnP5V+VhjPpRo8+ISeO0Ulici0K0n45HcXaBZcuVM6xL+ZyactlqW/IXnaOTM3hCvviKA8fFuQMy2VR6Lz4ZrzGptnqlTJ1cdZIOP4J4Y3/YB/c3wQpZJJtjCzDW9F63vVkJ4figW4qgxewsk8cLpAxI6orIs80Q/5X388JLCAbrCpwGW8DIEHUF3qNY1L+6mQkiMD6irFBtYyuSzRGf1Ni2UA7Rja/sHFKfSQzNWFv2G+DwHzALyKlveLKASPAQoAz5
 wBLZvGgw
 MW/4fVmRG5EJyVldCJ1u7Sv0PR3RmeSFGW/I9wCGgOwDTKF5OwXturM0EMzNC3Y0UvYSVBuBwoFtvLuAxEecEDGSL0XWHCKXvwM+XMbzpbX+ZwtT5LIv1KndfrKoXWMleN9Ln6XTpS8KqTS4Smf053C6Yi9FLvHl2adrQMY1mE2621Z0UWub8ZO7CsPwn04Dqd0DbyqW79dNY2sQwAStbTxKZ0L2qPlGUibHONL4GDgzlsZ4ehY98WbXZ45JtqC33Cb/2jWzAIT/mcyG0BLoNWVu6xMgOWpE2QsinlRsT/+a5RrLChlTrev+WQUasFUjwLZXjWtanrx0s7NJZtPA2c4acM6sxN6glCRsczTn7brgEStnfCfXZ1XFzfnaWPZ46LUGwlvi44CrGZXaOw6EUr/B3JiYn/c/UB0bYQAimzX3ElQ+v8lKlwXcLu942BR3T9FUUCjK1OodRXZ9C4AMiC+6bmE47QzmUh/6r7paNlIfwJw8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

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
index 5891efee3e18..36a4edde9823 100644
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


