Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 40D88CD4F3E
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 13:10:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A8C336B00D7; Wed, 13 May 2026 09:10:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A63476B00D8; Wed, 13 May 2026 09:10:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 979616B00D9; Wed, 13 May 2026 09:10:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 86F216B00D7
	for <linux-mm@kvack.org>; Wed, 13 May 2026 09:10:54 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 521991C0017
	for <linux-mm@kvack.org>; Wed, 13 May 2026 13:10:54 +0000 (UTC)
X-FDA: 84762431628.07.2BD459F
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	by imf17.hostedemail.com (Postfix) with ESMTP id 58FA94000C
	for <linux-mm@kvack.org>; Wed, 13 May 2026 13:10:52 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b="ipHtu/Zh";
	spf=pass (imf17.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.214.174 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778677852;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8LL1KUkSPgRngQo7FrouyGUEJqkrJiFH1mc8jZNgwIM=;
	b=krw2qJ96UooXr7yufo4U/1D8l1tzc6wBpLOKDQS3Zo2zgHIC+F5GdVCJLFVTYJuGwuj5r9
	F1j9PJ8aHOdYqZxZj4E66swmy5OwIx4Q4qRWXEbWsds3mXqrjZWOvPRFmd+gYOdJfxlqHN
	67zd/kt1ecNL3fImPh4ABUC+NB4kOXk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778677852; a=rsa-sha256;
	cv=none;
	b=L1p/4kpuBPr1YCMOmBBIcr6KlCM6a7poER4g6aI5eOUXYw324lzP/CSuMRrW5fMMhzcemu
	PoFFYRcCCSlWZuHQPdxpxZfZkYqE8aR4cuAmyWIuOCR17R80+Ohc2fq4OWZStXPxnj3Qwa
	1LH5U2xwOs+H5WwuISVCm5dSFYxuEKY=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b="ipHtu/Zh";
	spf=pass (imf17.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.214.174 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-2baca4df358so41254195ad.2
        for <linux-mm@kvack.org>; Wed, 13 May 2026 06:10:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1778677851; x=1779282651; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8LL1KUkSPgRngQo7FrouyGUEJqkrJiFH1mc8jZNgwIM=;
        b=ipHtu/Zhf5xfzWxFVD45TL+nfrzi7dU8kkW3gO+U+VFoz0pTFqMl4OaVvAfaB/Iq/+
         +kouAgr3O7uIYftmRRxhGxR+SBsx5IOyHdN8dFvrS+OnlA9Q7BBLjnKp8Bq1tbOyzWtO
         o03W9Nu8rTpg43ez9ZygS37TT3bU/xIBpktkuaeQoP3hCjpNN+fwjVuklpCMcJs2DtAK
         pHKsfId+DTSSftua73fGGHQwZ5eT2S7Rjkt0r5tiCfxkmcz3zJFv434D+q/z7ydlkP+r
         2GqftSc8/GfxVYQ55/s5wLJWSHbmwNtaOjTO/ECW5r5TFXvm6O0546bZvXcNdgAtJnKL
         VbWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778677851; x=1779282651;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=8LL1KUkSPgRngQo7FrouyGUEJqkrJiFH1mc8jZNgwIM=;
        b=RarVUhbKImJAIZLDl+3Z4Lde2a5JIi3oZmTZ+/1sj+ur/8MSpLaVzu1r+kNQjoUNMM
         Z5Tqwc5F4tA+vcl0nxVP3W3K9EK2l2WU3Y1ZJzlgCdX2qu0tLYWrMQagSAzP3s2i1Ckt
         t8s0nlK6960Q2cb8EaAiR5b3ix9jYcX3pQKRI9x11a9eSus32jtNXiQiHanD2sZ/XbaO
         3eFCrwZs8Y1GZAsXKBsySG5FIMZMMwcjcbwT+wkxEdX0H0NOdFd2AydOKCg1oWWtbJa3
         w2B+zwEdfhWrcV8jZ+C/eFSAMeaX2vcLbW+GTvZIxhMNGm1/0P2Vf7VqXiMkFF0Pmcpj
         VNEQ==
X-Forwarded-Encrypted: i=1; AFNElJ/j/k56Nj4GF/xBdrPLtBuHuUgajNCPJdCGCUJAPOyeckrNti0nVF7AeI/FW9Q1LgDQYKEumm4Btw==@kvack.org
X-Gm-Message-State: AOJu0YyZ2vab87EnMTTf5owURFqIdMWiLjYn7XtDygJrQfY4Qrpe7i36
	I2n6kyeSfuj4Yg9HGtjpsfc/Yl+krVn4l/bJeOi5sRB30AXNIf6vu+vgJadnD40VsTM=
X-Gm-Gg: Acq92OGbFSsxBKwe5ZkzzbIR3Kq2flJecQojYBdMPmf7pfJE8plbYC3GRzTQB1J7+zE
	fXW3y9cNywVU2/Wf6DW0Obvn1Agdgvd9Nm9lHKu5hwKF73zIzztoJlGo1nfAZr1tPq5EHDbwnd1
	iOUC8qG8uAHKSjvPP+VK87lXcOiPGni2+HKOmqPs4FiAfBCzSYxhT21LW4eYsYiFV4Sch1l/JBq
	iBJaRgEgu9hbGH2zT6w5VLzNDUEVyA2/v23rPWmtZKAqpoNkHWZdW1TfPYo0y3AAcPZap3GkIBE
	LZKSwvh1lrMMlKgd/mLAYZ9tetP/5THc47zpgPVsYxSOvqh3BxXszxgyAC90jfCALTRvaWkLFKX
	DO1k/2+BqE16qHximVsE2Enn4aUcB1Ax1/GE9hmHD8vKZLFB0vlL7+PyiX7QW+M2c8Z0gR2XE+u
	5zTua6mj9uWqyVnexT33NDJ48TA3qUTNXUKPv2syUl7mzxiWlBgQwbQOm+VM0=
X-Received: by 2002:a17:902:b401:b0:2bc:fe65:4e9e with SMTP id d9443c01a7336-2bd275d95bdmr26715515ad.27.1778677851113;
        Wed, 13 May 2026 06:10:51 -0700 (PDT)
Received: from PXLDJ45XCM.bytedance.net ([61.213.176.6])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2baf1e90854sm166641925ad.66.2026.05.13.06.10.46
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 13 May 2026 06:10:50 -0700 (PDT)
From: Muchun Song <songmuchun@bytedance.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <chleroy@kernel.org>,
	Ackerley Tng <ackerleytng@google.com>,
	Frank van der Linden <fvdl@google.com>,
	aneesh.kumar@linux.ibm.com,
	joao.m.martins@oracle.com,
	linux-mm@kvack.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-kernel@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>
Subject: [PATCH v2 36/69] mm/hugetlb: Remove HUGE_BOOTMEM_CMA
Date: Wed, 13 May 2026 21:05:04 +0800
Message-ID: <20260513130542.35604-37-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20260513130542.35604-1-songmuchun@bytedance.com>
References: <20260513130542.35604-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 58FA94000C
X-Stat-Signature: os8wtqewe49xin46b3h5e1tepeobcs8j
X-Rspam-User: 
X-HE-Tag: 1778677852-105394
X-HE-Meta: U2FsdGVkX1/dJi43gHeaFzELd4LbZtSyBmrg03Wg2aFOU8XHs9p7cgt9QxaZBm4sAQTBNtXG728PddjTSgGmNV9CvuuCL8+Q+ld8LuDImD3isQ0oos40vvb0C8SD5RALBOga6gOXrPyc6/PWxD4KLSPhn88z8RtABMBFmH3Brf4qUKljOwCE7Zr9bdn/9ikfClicokLKXEG4HKKVNXV6IvW7//qxs+Jsot35B6i1YPxDeYzIRDkLyp1GLD7gB27+p2GPfn5K0rmwqQowWnKSf0VaBD9Emeq4PctDyCaz+MWUft/ROt8TgslEZYlj8WkX3YfmkYW9k2POrYYLdVE1FGhaUH60FDDUyui+J4fV4Oz2Q0Iuo5pFsDp7ZiXg9vdEK0KIae4fyjvsX/9ZO6ytZrTLUIBqKO2mxgFZZ26uDL9EIdUHrJjW0D5oT12PrTu6oCBBXx2sTgUcOAo3jsPFZa7vtBatLnxpe7RjgxW1TreDxIqdC2f3TpqV6v3/Jirkui6bqKP476klNddWA2/SfbqFR1IlcvjBGxBuRtoTCaG59e/Vw6nbbK8UedKey0JgBOqm8ILtjudyPnyVIxTAupIPOjVuopktq2Zd3j0ZtHINQZYuyd6zyg/c1Ktyfie8k4CaP4Abb2Im/lgyDHwSpdVxZDdKJskR3k0O1sZE/z326NHNE3F7WF605ZLWkrikqfWVWdlsxJz3rTFnpOpOQmudy9ggp24X4zsH4Xv6hT05EpPJgmzduUmZQm7bOPsy+lzwMTtny0Uyrfqm4HwzNblA3ynznE/TnBYt8OhYofWBdUMBoCI3PtFl6t6/ssqSaZ1GPYNOVy3k3dNAyadU+5H6E+I8+4lvXjKJtooXfM34EdwbOTvPFrHKH9ValXtoZYdGKAwfOkdObO9u8yKTD4NTQnFcg3N/OuvHzpyM5oxd0VlB6zH0pP2SSkCYKFFMah54FDOnku5AvPW3VX0
 8jxGTK2P
 L5+yCxPqkwbUPIV3zCnkgw2qgjxSFbjGWsc8tysakPjbWczAPpQqtQgxNv2C7fvHzIORtq4g1DA5wL3RpJ+FoL9kVC/bkp2H1NnPao5gIkGakANNevadYMXFWkqJmjR/UO39lR3I2Mg7xDyjSKOLvUkjh3D/9ewGYQFUFn6u3Tjw4lHWjC8ny2ritdIje4/Db/C7PihjNlaRsbP472Yz9uYmYK+/XnCQJnKy7Z8DTyOcmmE5gyhyDyEKtxtO415oHK0ornRWuW9TsYoaamAJs9DiUYT1fMoNanKACy2BzttBnqiXcsiii/uNzHHzoiYB8yIMCIW/oa05ZqVpkdJS4YYbS54NYKM64unLLEKnJ3Jb1GAA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Track early CMA hugetlb pages from the hstate instead of storing a
redundant bootmem flag. This removes the unused helper and keeps the
bootmem metadata minimal.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
---
 include/linux/hugetlb.h | 1 -
 mm/hugetlb.c            | 9 ++-------
 2 files changed, 2 insertions(+), 8 deletions(-)

diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
index 18af8f304b95..82dbb9ebead8 100644
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -696,7 +696,6 @@ struct huge_bootmem_page {
 };
 
 #define HUGE_BOOTMEM_ZONES_VALID	BIT(0)
-#define HUGE_BOOTMEM_CMA		BIT(1)
 
 int isolate_or_dissolve_huge_folio(struct folio *folio, struct list_head *list);
 int replace_free_hugepage_folios(unsigned long start_pfn, unsigned long end_pfn);
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index abd79bb85b1c..74770c1648fc 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -3093,7 +3093,7 @@ static bool __init alloc_bootmem_huge_page(struct hstate *h, int nid)
 	 */
 	INIT_LIST_HEAD(&m->list);
 	m->hstate = h;
-	m->flags = hugetlb_early_cma(h) ? HUGE_BOOTMEM_CMA : 0;
+	m->flags = 0;
 
 	/* CMA pages: zone-crossing is validated in hugetlb_cma_reserve(). */
 	if (!hugetlb_early_cma(h) &&
@@ -3169,11 +3169,6 @@ static void __init hugetlb_folio_init_vmemmap(struct folio *folio,
 	prep_compound_head(&folio->page, huge_page_order(h));
 }
 
-static bool __init hugetlb_bootmem_page_earlycma(struct huge_bootmem_page *m)
-{
-	return m->flags & HUGE_BOOTMEM_CMA;
-}
-
 /*
  * memblock-allocated pageblocks might not have the migrate type set
  * if marked with the 'noinit' flag. Set it to the default (MIGRATE_MOVABLE)
@@ -3265,7 +3260,7 @@ static void __init gather_bootmem_prealloc_node(unsigned long nid)
 			section_set_order_range(folio_pfn(folio), folio_nr_pages(folio), 0);
 		}
 
-		if (hugetlb_bootmem_page_earlycma(m))
+		if (hugetlb_early_cma(h))
 			folio_set_hugetlb_cma(folio);
 
 		list_add(&folio->lru, &folio_list);
-- 
2.54.0


