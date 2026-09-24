Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 009BAC98310
	for <linux-mm@archiver.kernel.org>; Thu, 24 Sep 2026 07:58:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B60D56B00A2; Thu, 24 Sep 2026 03:58:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B38616B00A5; Thu, 24 Sep 2026 03:58:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A4E2C6B00A6; Thu, 24 Sep 2026 03:58:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7337B6B00A2
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 03:58:17 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 08B47160271
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 07:58:17 +0000 (UTC)
X-FDA: 85247903034.05.F12634E
Received: from mail-pz2-f12.google.com (mail-pz2-f12.google.com [74.125.228.12])
	by imf04.hostedemail.com (Postfix) with ESMTP id A726B40002
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 07:58:14 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=G9dFjZzQ;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf04.hostedemail.com: domain of songmuchun@bytedance.com designates 74.125.228.12 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790236695;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ypgv34u1izH3x2bQ0aB2L9cYWw/W1JF39DJ+G9Ytha0=;
	b=MravtG3MhIeoeFn964ir2maZaBxSwmF39NkSU2cfPO/Mv02wZE3ILwN+pYMUsMzJnZyFLw
	fKdmoRSrgrCKWahPADX/vvtFXJc+vJRhlmay2Z/4Fj8AXoYHy2qyIU0psPwjwQ++waW9rQ
	OPvP6cYUF+PgwWmWhtCsRKt42ZxfGqs=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=G9dFjZzQ;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf04.hostedemail.com: domain of songmuchun@bytedance.com designates 74.125.228.12 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790236695;
	b=xCplcATR/3dePmET3EOaW3IoTxPal1NE3y1L+oaavw1wGREl5dSGqNbeSp+cO0OKEfA3lO
	G6oGp6vDhQQ8zGYZUSKuUkXTxUHMChPt2nymI6kDNo7urG40rsR7wHFCvhsSDEjNP2hOy0
	3Vw3MCflosFrph5qpDD4TpKYHjKP3xM=
Received: by mail-pz2-f12.google.com with SMTP id 41be03b00d2f7-cc1cea34ef3so1408269a12.0
        for <linux-mm@kvack.org>; Thu, 24 Sep 2026 00:58:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1790236693; x=1790841493; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ypgv34u1izH3x2bQ0aB2L9cYWw/W1JF39DJ+G9Ytha0=;
        b=G9dFjZzQul8/kX7jGF7mC1VtohaV9tGDlKoj91r17WfthH1Ujz86L6e53uI675d3HS
         yH/Zy1ZOhSO9Z18hTILBKJZT/RY1HIIEtVxheAC/enDW0MjEDIVN555FtkS/g/A2KrjW
         q3A33qVKa7fM3m3EF8egrll6kbhqZwsz8J5cwJtZRtjy6RB8PASCvyeoU7KPfWdnkcWX
         LZlsft/0wst9cN+thx0LyzWTbBfulZBre+BpmWPd2K0007rHE6IjRHIcXxQC5Zfasp0S
         KiTOO6NnMz6o0FgwC1OyJ4b9YbbSufRjqPgSpsJVoqsqypfZovaRJcZ9YMwWw2vI/2XA
         8c4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790236693; x=1790841493;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=ypgv34u1izH3x2bQ0aB2L9cYWw/W1JF39DJ+G9Ytha0=;
        b=ZmP9x/Nx4GlXCgJiYqFRj3HI19HebX0eEcEo/8AkdfYkWs85osRdrJlGzXYxB6Ij8D
         46PJ/f4vHdCVGC0fAu3ANo2gdSvwBWSXSkVPopb63+evEGZREqYTPj8K5A0t5ZYfLc6V
         v1P3f9NJYytFE5ri+K9aUoIyfzqt6iLKy5lx4KjQzgZbcaWIu2nDr8T3Gfy0YX0OJ7Pq
         3FN+SixWQRZWzTmY4BIyNX+f/xqCIumKFwow40zte0IF+A3mNXoNhA1eNSSmw7E9VOMI
         wa0NcStM1xgbpzenXPNHMJikCubTEERRHj5inPf0n7aA41sRiqUr05U5FEwOhLpai4tY
         eKDg==
X-Forwarded-Encrypted: i=1; AKwUvBzzZi34j6OvF6QqG/SRaofpTFfkc2ljjXnhY+7Ygi7XPxjMatgJss5zSiWqIM3U1ARBjbkVNgNsXw==@kvack.org
X-Gm-Message-State: AFuF++mOHUNvEBfQipsmyFrU/8mlWgPz6dcty133+iLWiSqZsf9DYm7T
	4/j/76rz+Kxig/PN2Lh0QE8liBFg2Di9CM5xWOUqRjyaq9n8PeXWx3Z5wacpoQXQD7I=
X-Gm-Gg: AYBFou0G1auFHT3MVXFPwoS01qIb+QqE5MPVhXUesmc8zjcH2A9HWTN4VoGxUsfBe6D
	NZ0CAfBiHzGb2zRNTgHWrp5HpieT+8HGSIQ3smk1RZaCpUw2aOHky4zFoxbTEPEvzSHU1ncl1d5
	IMe1j+kvH51lkC6t2KHQPbOtHiTYgrEgymYrz/wmS2f4NYzXZ0MrbRmKDwMd68fSDjfTYMW5os+
	vxv4Igbpss/kespXp8jSVhXg6lEnV3NC4fIfETqdTuRyQ9hrD6Lnary/TUuODKqYzqAwYuEybZg
	rXvSepVvcgxVrURkii/ZXEdW5ypbrZtwh6Mt2rvPQTtGpAJq+urMgm1KVWkIBDOFOZLZgfmTwHl
	QIaQGG12Nl6q+6N92lAdcJBbnU1ghFPtZgv5JK1ZHHrk47XsnDHzRu1L9dXtXfgHeegZNBwVCDQ
	FK+tNCcWGrzokactCYiot3Bz+TM3i855B0FbM6etZJcw67G5oERUZeEA4qbW4Wp0bkWdpQD1yDD
	/pjZNNi+lCP/SOJZcUR9ylu4ZE2Mw==
X-Received: by 2002:a17:90b:3852:b0:39d:f024:c7ec with SMTP id 98e67ed59e1d1-3a098d883b8mr1610039a91.16.1790236693438;
        Thu, 24 Sep 2026 00:58:13 -0700 (PDT)
Received: from n232-176-004.byted.org ([36.110.163.97])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a0972eec92sm3575622a91.7.2026.09.24.00.58.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Sep 2026 00:58:12 -0700 (PDT)
From: Muchun Song <songmuchun@bytedance.com>
To: Madhavan Srinivasan <maddy@linux.ibm.com>,
	Mike Rapoport <rppt@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <chleroy@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	linuxppc-dev@lists.ozlabs.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Muchun Song <songmuchun@bytedance.com>,
	muchun.song@linux.dev
Subject: [PATCH v2 2/6] mm/sparse-vmemmap: support device DAX in common vmemmap path
Date: Thu, 24 Sep 2026 15:52:55 +0800
Message-ID: <20260924075259.2013039-3-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260924075259.2013039-1-songmuchun@bytedance.com>
References: <20260924075259.2013039-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 9qweicciuhx5iwxn1f8sb9bsxdifj4mo
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: A726B40002
X-HE-Tag: 1790236694-258519
X-HE-Meta: U2FsdGVkX1+oBd44ubeg9z2edkIVS7RLHij4mogCnRBTdLuroAvVX5Tth+f0ppRINbfArOsJToML04hUxBUaCed+0AU6C+sogHtMja/9o0YD3wL4zYvT0UtGziMawxlSqIFlAhBdnGnWU11HzGGKqNuLqeHA1v6ld0uCfn/xbWJE1fq2zXNoInqzdPakWEUbGl/Zyd61e9J/GIkvttSzIUgzvDatBkQ/RE550k6OjFK8UwOckjFmD3LQ2x9n/c4+VTCmKWupBpbaVNhzKmeH2A3Jahn8b6HPIJY4mQtQXFWClNMISqFvsUo63lW3sWj3rzhRvKSOxTFYZFgnZPEBYn6Pxjjn+3n4o66EoAv1Pos4tK1qGzyeCeSFtTjoVf0Cj+S9HG7a6x6K6D2JtKU7/Y9hLQEZyme8qQTA1AMX3lkcPVGfNdJFISsZXOCsHC5z+dELLHGEmECwWNPFgW5d6iv4ek1cqcLazKzfKbWwr0CEJArEsgMcuqCnhE0tY7Layi5LP642ONiRD0lp6QazCqvmkJoBn5oFtBxPFSW+pFg+d0eA8KETtfsefvs04TXAaLDMBz47OgtAKhN9Fk4rHsdfDuaRiDHlRC6lMqJ5dV22rDEhkMzXP8JmSC+iybjY7y2LT9GDRNgm1sM2Otbc4SinKYHmT5e3pOmNjZX/Mer5YRV4YgSccLVV0gbG/FtVYoMVEEUKxxNVc3DxkEbDfgnAzGo+TLuGjmggY0fVMPLJL1i9VLf/Fdq2s4ZCMkysu9kptv4Pvn8WcirxhHvgNz4N9rVK87LI3n9eya9U/1iQcYV4imBsSsE3mCvKjdwi3X4LUuvgYMzpkSGmMKFDyupT2DJsPje/1pw7iy9chFM6zVxd3SXj+f00oMT95XY7zmUyPaGcCNSh85A+9SvFbWoO0aKnX3bmY+eajznXJJxEYPmAlCAX6glfrnKkBsnRL5I6OaUtWxXsXpm01T8
 WVgNl4HW
 DCM4oGoFjOCnf6XUqbfH0VtYJvyBoB7BGfxaBkSiMYfDsLx97xW2dc1otk0DZHXKC1iRyUITCSMxV/ZQxbWJOSGR1NrsYc2it4CtuhP9CVnsCMIV6HnQW0mCHVV/B/+NidjsHBbVHruXL0QM90rdy7MBdPSyXBCc4o5nJl8NCPhksdlNCJmgMkeISYFn7EQeBJN2Axz5PS1MUdvNHQCJIPfKEr52I6HDdpxwlLgDsDpAliBeKE33/poinoNz1xvqO7UkPV8lnrGUnH7hYdfraRS9amlmXA0xxoZrpe4MMzwGlZPuR0hHt6QGDOw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The common vmemmap population path cannot yet handle optimized Device DAX
mappings on its own. It uses pfn_to_zone() to find the shared tail page,
but Device DAX populates its vmemmap at runtime before the ZONE_DEVICE span
is initialized.

Teach the common path to use device_zone() for runtime optimized vmemmap
population while retaining pfn_to_zone() for early boot. This allows the
same path to support both early boot mappings and Device DAX.

The backing PFN supplied by the Device DAX-specific population path is no
longer used, allowing the redundant lookup and population code to be
removed later.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
---
v2:
- Expand comments around slab initialization to explain zone lookup and
  page refcounting (suggested by Qi Zheng)
---
 mm/sparse-vmemmap.c | 56 +++++++++++++++++++++++++--------------------
 1 file changed, 31 insertions(+), 25 deletions(-)

diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
index 919c94a36346..cdcc93714a9a 100644
--- a/mm/sparse-vmemmap.c
+++ b/mm/sparse-vmemmap.c
@@ -208,18 +208,39 @@ static __meminit void *vmemmap_alloc_pte(unsigned long pfn, int node,
 	struct page *page;
 	const unsigned int order = pfn_to_section_compound_order(pfn);
 
-	/*
-	 * Device DAX still relies on vmemmap_populate_compound_pages() for
-	 * head/first-tail allocation and tail-page reuse.
-	 */
 	if (!vmemmap_optimizable_pfn(pfn))
 		return vmemmap_alloc_block_buf(PAGE_SIZE, node, altmap);
 
-	zone = pfn_to_zone(pfn, node);
+	/*
+	 * Before slab is available, vmemmap optimization is used for early
+	 * system RAM, whose zone can be determined from the PFN.
+	 *
+	 * Once slab is available, only ZONE_DEVICE memory reaches this
+	 * optimized population path. Its zone span has not been initialized
+	 * while its vmemmap is being populated, so pfn_to_zone() cannot be
+	 * used. Obtain ZONE_DEVICE directly from the node instead.
+	 */
+	zone = slab_is_available() ? device_zone(node) : pfn_to_zone(pfn, node);
 	page = vmemmap_shared_tail_page(order, zone);
 	if (!page)
 		return NULL;
 
+	/*
+	 * During early vmemmap population, the shared tail vmemmap backing
+	 * page is allocated from memblock before its struct page can safely
+	 * participate in page refcounting. Therefore, no reference can be
+	 * held for each shared PTE mapping, and the mappings must be unshared
+	 * before the vmemmap is depopulated.
+	 *
+	 * Once slab is available, the shared backing page is allocated from
+	 * the buddy allocator and can be refcounted. Hold one reference for
+	 * each shared PTE mapping. The architecture vmemmap teardown drops
+	 * the reference through __free_pages() when removing the mapping,
+	 * preventing the backing page from being freed while it is shared.
+	 */
+	if (slab_is_available())
+		get_page(page);
+
 	return page_address(page);
 }
 
@@ -231,27 +252,12 @@ static pte_t * __meminit vmemmap_pte_populate(pmd_t *pmd, unsigned long addr, in
 
 	if (pte_none(ptep_get(pte))) {
 		pte_t entry;
+		void *p = vmemmap_alloc_pte(pfn, node, altmap);
 
-		if (ptpfn == (unsigned long)-1) {
-			void *p = vmemmap_alloc_pte(pfn, node, altmap);
-
-			if (!p)
-				return NULL;
-			ptpfn = PHYS_PFN(__pa(p));
-		} else {
-			/*
-			 * When a PTE/PMD entry is freed from the init_mm
-			 * there's a free_pages() call to this page allocated
-			 * above. Thus this get_page() is paired with the
-			 * put_page_testzero() on the freeing path.
-			 * This can only called by certain ZONE_DEVICE path,
-			 * and through vmemmap_populate_compound_pages() when
-			 * slab is available.
-			 */
-			if (slab_is_available())
-				get_page(pfn_to_page(ptpfn));
-		}
-		entry = pfn_pte(ptpfn, PAGE_KERNEL);
+		if (!p)
+			return NULL;
+
+		entry = pfn_pte(PHYS_PFN(__pa(p)), PAGE_KERNEL);
 		set_pte_at(&init_mm, addr, pte, entry);
 	} else if (WARN_ON_ONCE(vmemmap_optimizable_pfn(pfn)))
 		return NULL;
-- 
2.54.0


