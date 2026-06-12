Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7DDABCD8C9D
	for <linux-mm@archiver.kernel.org>; Fri, 12 Jun 2026 03:59:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E04FF6B0092; Thu, 11 Jun 2026 23:59:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D2C3D6B0093; Thu, 11 Jun 2026 23:59:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B6CD26B0095; Thu, 11 Jun 2026 23:59:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A7E076B0092
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 23:59:29 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 76662404F2
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 03:59:29 +0000 (UTC)
X-FDA: 84869906058.03.095AFD1
Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	by imf15.hostedemail.com (Postfix) with ESMTP id A2C67A0002
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 03:59:27 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b="O/vAQxQM";
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf15.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.210.179 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781236767;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=A38edv4qBFIhST2C0H/v4DfDnWwAK1V2ZV54LtDXngc=;
	b=iwaGN9pdRZ8Og4sEio/btfw1EPRRG0vRFqz8X7owz0d13O7IQK4HMmZ9fhngVTmhZe5oCh
	SOQaWbjZTLls+rjtxZkhTOXeSh+zeb53iHRFXrjHDccwOvM8k6kkzo6NwJhRCbT2y8Jxg+
	i06GLxG74FD99qYhIwIM9rkHrLzGkPc=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b="O/vAQxQM";
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf15.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.210.179 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781236767;
	b=G7tOxsEll0RlOwyI5huiayomHi5bgq4AVklowBlSBWc97P32WWf+oiwZIyDrs1YRoxAZ6b
	7lFNd8R9vGbP48VpK/XkOpVBUzuEyXXOwOAK1ycsi4V5Bhvu5XH9kqeTN6lk3FB0hEnvLA
	tMk1Fi+/z/P5R7Oirn9Tk+w24CxG8wc=
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-842307473b5so454807b3a.2
        for <linux-mm@kvack.org>; Thu, 11 Jun 2026 20:59:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1781236766; x=1781841566; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=A38edv4qBFIhST2C0H/v4DfDnWwAK1V2ZV54LtDXngc=;
        b=O/vAQxQMjm8DnjK6KA01KW+vHakb65GjNC0yuY+Zv6FTdtFk1kfrHtKa4EWk4aMkBW
         MAApWDlvWfUnYxdN30fItbnA4krL7rGNvjFREzRb9D+oRgRJk9ObAKOtV9yAIsnz/X8I
         tzzVJmRA7iCAsVEq6oJK/G5ac71PfSMq/qPlhSYgzWUikevKxTzUfsOKVefKt/8AXDrP
         rzxKIUc9Yga3SM+K9yRmxWDQJrrCIYxbrSRBro2BcFTOwg5MLXSGY09Hol+LRYvMoWnr
         tM4MjVef9fIgGcaAVhZ5OqKNDfh3TtPH1LZtoiTswNMh26ZYQC7AFs10ZMIUaxs4IXyY
         dE1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781236766; x=1781841566;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=A38edv4qBFIhST2C0H/v4DfDnWwAK1V2ZV54LtDXngc=;
        b=Z29IFODbxJYciFyDrq/L+Xxb/4VelXS/dMYvI6Ye6LzuteHVoDjKTDQ8O46Lqupx2v
         MI+2Xnco3yzPV2kjIKoGnw0h5Vm/WZn3qQM/pKrIS4kErLRVy5L5qCHib4szFcCnuWiz
         ggd9f+RrXsnIuyDu40luGz9RvDm3839/bfflzaraU5vyQ3t0C9Bjg869rJtF6VBf77Qp
         t0lbeTo+lbJ7k0BE9fIQQP+A4LW8D7z9jSL7yhFUI95KCTGSh4huMcBraaaKEDugXhnZ
         IwTPUoHv4luQ2uRc6s0aah/keTZEKdcyV5Jp7lw6C9Ivvd57RcbBSzfLIFO04l11wSEn
         Yydw==
X-Forwarded-Encrypted: i=1; AFNElJ9tO//dG4cw9k26VGxpriTr4tn+2rC4Y1N3zhWM2ezsb57eK39XhdslhsiDLLFYG9ICLheoT0BKHw==@kvack.org
X-Gm-Message-State: AOJu0YwXcks1fy1rJ1zqi7ImkZj0KSno730DDOE3NCt1fpj4PXZPq2/u
	DW4zXG/2yCigpfb2l77HojO9E4eTFqBkGACE6a97KoEuQOiEZkfQymnASZiUzUX8n30=
X-Gm-Gg: Acq92OENpwjA8ApWm4ZjULwwGpMUWwA/RfoJzeFepgE++51zuCbT5IzlInshGPdfBEf
	IVwWG6phWsUiFtey2ylwWVLyPZZ6SFHTpKa29clfFIVfp9piUtXcFFkS+T8c68lIp2aXjDvHsXf
	f98H3CGmQJR6f/m2BhXVU9y8Fm0aXILCZdoYLQfVMfyS7wx1kvnYMI/jw8FwjSi8Ya9D4YjoqTe
	fnp1c0LWSLCmlpcVrUvIrfr1fd2bUGIoROwInBQdWdi+xqK95Oq638Tz27HXLMThfUww1qpw3ck
	24nM2GbF6u7NN77TbSLmiXMcbadvvcnY+1L8aX1XIY0/nYy39ZjZcVLbHKpY/yjo8JIJCJHXJDx
	DOh9zHfg8uSzQmvLl3j9TWjrZtIEedt2S5QLc8wv15bYwKTC9cBJYrxzR8QzWJ27BvGjU5L4z1i
	p/oBZVkpsMpL3777GEetx67engVTyWdct6UXlIsjqrFu8=
X-Received: by 2002:a05:6a00:2288:b0:842:5988:470b with SMTP id d2e1a72fcca58-8434cc161cfmr1136338b3a.1.1781236766275;
        Thu, 11 Jun 2026 20:59:26 -0700 (PDT)
Received: from n232-176-004.byted.org ([36.110.163.99])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8434ad03fdcsm643352b3a.24.2026.06.11.20.59.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Jun 2026 20:59:25 -0700 (PDT)
From: Muchun Song <songmuchun@bytedance.com>
To: Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>
Cc: Muchun Song <muchun.song@linux.dev>,
	Mike Rapoport <rppt@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <chleroy@kernel.org>,
	Ritesh Harjani <ritesh.list@gmail.com>,
	"Aneesh Kumar K . V" <aneesh.kumar@linux.ibm.com>,
	linuxppc-dev@lists.ozlabs.org,
	Mike Kravetz <mike.kravetz@oracle.com>,
	Muchun Song <songmuchun@bytedance.com>,
	stable@vger.kernel.org
Subject: [PATCH v4 03/19] powerpc/mm: Fix wrong addr_pfn tracking in compound vmemmap population
Date: Fri, 12 Jun 2026 11:58:47 +0800
Message-ID: <20260612035903.2468601-4-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260612035903.2468601-1-songmuchun@bytedance.com>
References: <20260612035903.2468601-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: 96j5xjbgp4ps7ttwkei9hqhimzpym531
X-Rspamd-Queue-Id: A2C67A0002
X-HE-Tag: 1781236767-129181
X-HE-Meta: U2FsdGVkX1+7656BFjDWTk4Fz9F3fQlLziRAmCejzMsIjIMVH35d1nELt1k8I0ThVoDJe8kRUTJ6Dco8I6bByz6OeQvdQlXQlO2AcNf+iyCYniefWjrQy9sPmijR/1+BpMzEs+7GaY8GT8ECTViDQjfD5dLybj16FPj1CqstY/5bQmL7dvko/8djDT032+dB6yHT/ZPdLBB6b78Mvokz0LWtnHaF/vNUgu8vZAN6B+jd05X7Mw6tiqR9kWpVy5ueOncEvAF3azbTVhAcGhLQ3449u8ZDswde+vdt3nKZCz/RyVJgJVxvbsBB5leIgr/AsmYUxPKkCwrg1zQ7BuZj4xj5h8fPtRW7kQ7WjaUgrVOCp64Hz3AQmzlIMnH646Vl02ZXWi04wa+8S2mNcekMmvZx0DzQsQEF63C4XbHkdyMbltTLSQp+7J70ZbLq+4rdiKdStSDuBuwa/co4q5S2gBZZGDTtu4QFweTzggFrE3rx9uO5ycdQsQl60x7AJg/OieSWxv2rGIkZaKhsyFeq2RudTsezDxAZ6Zu8aVE8FNSje8OI5kqBa8uhKB+lTi23as8EeA61fUUHkChBGQe1Bc2XVFUAzAlQWXzjDl+Xlj3tUSSPyeYWyTb1nS7ATPQVv0wjifTQgtMCAX18sEmBmzsNjbk2bO0FYC1u7QgB1A5MFouz5hsbaYx5ywsDtafH3DjEvB5ym4+1H++FTlLyBfNwIFrFhpBl0NtcE0K1hOrlZuti4Rk4OmuT+XCxgNI4jrsJG5bwwwUZJWfFflvQ8ofO1unKPPhPiuB/Epo+cvAUy1wkFIzSqQtleTXnnuaeJ+Gw+k41sxEK/soxfSMn8elzJ5lEiZR1PYOAuYsEBk4S1n/ezUTZB/jxd7URulJJfaZgflZJfA1Xk+0URN/v1z6AEVAgnZat9nle3tt2hiq1yOPIBZJ5D20LPPDZgxACDSkhwVpfS7LE1Pw6qQy
 n0TD3U98
 RQxLFq+4+j7r7By3iHfzGOX8kxzxulSxMU1wEB7CVDw6GjQzdhiGAu3NeRoeNhF5WAfi6nYP546nrgUrT11xTNnS4iZkTd/Fmf9BRZKHhd92/j6Qbn6lDBh+vx7a3GDfR25+TItRUM+X+vJfQ8HLcj066xlYSEC8WK5ADTFGpIdlcqS6au1m8O7lxE78Pc7kLrSX+ku4/EbiqEU7mMmmVBGWJfbl1osryeL/UtIIJayH8JJ7qcin6lZ7w5+AQ8u2XYt/r4AK8gGgdxd2xK7zBgXAsp1/FbajkEpPwD7cRUTjFTTo13Brpyw2XNFIWfmCldqRYTCauph2Y5O6yrtuLEZQnp+A7QR34EgMhfY636iXfsd97Lhd0lKIoR4VC361QNpuj/CGv3tDTNxL9Hrqo4FFj6q5xJxTNNwtHYNdz/D+3RxqjQaWKgC4/Yy+rSmp1b5pXCa0dG9sjbkRWsP6hNQqrWmDesAJqElLg
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

vmemmap_populate_compound_pages() uses addr_pfn to determine the PFN
offset within a compound page and to decide whether the current
vmemmap slot should be populated as a head page mapping or should reuse
a tail page mapping.

However, addr_pfn is advanced manually in parallel with addr.  The loop
itself progresses in vmemmap address space, so each PAGE_SIZE step in
addr covers PAGE_SIZE / sizeof(struct page) struct page slots.  Since
addr_pfn is compared against nr_pages in data-PFN units, it should
advance by the same number of PFNs.  The existing manual increments do
not match that and therefore do not reliably track the PFN
corresponding to the current addr.

As a result, pfn_offset can be computed from the wrong PFN and the code
can make the head/tail decision for the wrong compound-page position.

Fix this by deriving addr_pfn directly from the current vmemmap address
instead of carrying it as loop state.

Fixes: f2b79c0d7968 ("powerpc/book3s64/radix: add support for vmemmap optimization for radix")
Cc: stable@vger.kernel.org
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: Oscar Salvador <osalvador@suse.de>
Reviewed-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>

---
v3->v4:
- Add Cc: stable@vger.kernel.org (suggested by Ritesh Harjani)
- Collect Reviewed-by from Ritesh Harjani
---
 arch/powerpc/mm/book3s64/radix_pgtable.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/arch/powerpc/mm/book3s64/radix_pgtable.c b/arch/powerpc/mm/book3s64/radix_pgtable.c
index 10aced261cff..cf692b2b5f7b 100644
--- a/arch/powerpc/mm/book3s64/radix_pgtable.c
+++ b/arch/powerpc/mm/book3s64/radix_pgtable.c
@@ -1314,7 +1314,6 @@ int __meminit vmemmap_populate_compound_pages(unsigned long start_pfn,
 	 * covering out both edges.
 	 */
 	unsigned long addr;
-	unsigned long addr_pfn = start_pfn;
 	unsigned long next;
 	pgd_t *pgd;
 	p4d_t *p4d;
@@ -1335,7 +1334,6 @@ int __meminit vmemmap_populate_compound_pages(unsigned long start_pfn,
 
 		if (pmd_leaf(READ_ONCE(*pmd))) {
 			/* existing huge mapping. Skip the range */
-			addr_pfn += (PMD_SIZE >> PAGE_SHIFT);
 			next = pmd_addr_end(addr, end);
 			continue;
 		}
@@ -1348,11 +1346,11 @@ int __meminit vmemmap_populate_compound_pages(unsigned long start_pfn,
 			 * page whose VMEMMAP_RESERVE_NR pages were mapped and
 			 * this request fall in those pages.
 			 */
-			addr_pfn += 1;
 			next = addr + PAGE_SIZE;
 			continue;
 		} else {
 			unsigned long nr_pages = pgmap_vmemmap_nr(pgmap);
+			unsigned long addr_pfn = page_to_pfn((struct page *)addr);
 			unsigned long pfn_offset = addr_pfn - ALIGN_DOWN(addr_pfn, nr_pages);
 			pte_t *tail_page_pte;
 
@@ -1376,7 +1374,6 @@ int __meminit vmemmap_populate_compound_pages(unsigned long start_pfn,
 				if (!pte)
 					return -ENOMEM;
 
-				addr_pfn += 2;
 				next = addr + 2 * PAGE_SIZE;
 				continue;
 			}
@@ -1392,7 +1389,6 @@ int __meminit vmemmap_populate_compound_pages(unsigned long start_pfn,
 					return -ENOMEM;
 				vmemmap_verify(pte, node, addr, addr + PAGE_SIZE);
 
-				addr_pfn += 1;
 				next = addr + PAGE_SIZE;
 				continue;
 			}
@@ -1402,7 +1398,6 @@ int __meminit vmemmap_populate_compound_pages(unsigned long start_pfn,
 				return -ENOMEM;
 			vmemmap_verify(pte, node, addr, addr + PAGE_SIZE);
 
-			addr_pfn += 1;
 			next = addr + PAGE_SIZE;
 			continue;
 		}
-- 
2.54.0


