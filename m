Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3F0F7CD6E57
	for <linux-mm@archiver.kernel.org>; Tue,  2 Jun 2026 10:11:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A3D2F6B00BB; Tue,  2 Jun 2026 06:11:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9C8646B00BD; Tue,  2 Jun 2026 06:11:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8B65D6B00BF; Tue,  2 Jun 2026 06:11:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 70C8F6B00BB
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 06:11:08 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3FBB39238A
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 10:11:08 +0000 (UTC)
X-FDA: 84834554616.16.62A1137
Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	by imf08.hostedemail.com (Postfix) with ESMTP id 1217F16000D
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 10:11:05 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=ZY6EJc7E;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf08.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.210.181 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780395066;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Y0lfog+XMb7vxf8z5NRAN8W4fHvuXnUL6M7vrh2PtXs=;
	b=VY/WMweGYgvaoqx9BWvSwur6lQpKTifBzuCV9hbp/glk1DKfneN+V0yqM90aDfRRAxc8g/
	ujp1CWg2hK34wtjTZiQI/sfsFfMRJoIdC+HghZMt+zYIbE8H6SeOWRq19o8K1gInTJT2pc
	i8fjXbg2Yr9lj+FWvLLWPF5js9tmMvs=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=ZY6EJc7E;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf08.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.210.181 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780395066;
	b=rfGwGvgDrLIXNSZK9tXOAqzviB070cN2vssZjQA/BmZpE/56e0oRBfiE4ypzd4KMCNGniZ
	53z+NZuIyhtqBPIKhz//iEjt3zBrw0NUGd4rhSSWHlhEpd+Mk3YZLdo7+q14k0OAFB4r/i
	xxNYH23djQN23UqYnq0XHZnrw4Or56s=
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-84229481d44so1079267b3a.0
        for <linux-mm@kvack.org>; Tue, 02 Jun 2026 03:11:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1780395065; x=1780999865; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Y0lfog+XMb7vxf8z5NRAN8W4fHvuXnUL6M7vrh2PtXs=;
        b=ZY6EJc7EUW4wG/h4nYP6sOGLdHo08mXAGd5aF1H7vKXkfZdxQM4/eSIZFp2VtvKsjY
         JWvgpmmSz2hbpyzsDe6qOrZNoHTaUeEDuYGHUFAqxKVQIlBbjsaCBah40KTSNeYJ8nGv
         0KrEh4d0woiX52DNlDmS1HbULiVCN+5CBh8iyt5my2Nx+KaJmsMUoPvoHqbU0rl5aIAL
         RQWHeg6fA4fdejjuhsqeWPFL6FUTXKzq+rmNrELbzzbLALtM4pYTSq670FrjQlcuuFr4
         YrgObYIjJWZVhkirtckfe6/herOuXsHM/UOD1SL7rsNnH8Pay5//gFqRJhl/yPjSbqsH
         NMUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780395065; x=1780999865;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Y0lfog+XMb7vxf8z5NRAN8W4fHvuXnUL6M7vrh2PtXs=;
        b=N1p7QAvr2Q+WNrkHZfvZCqObGusXbk0cmFMU/gWEBYpWhU78o/QkuZmeKSiowwQ6Ev
         cyL7xWPip40fE7ljOoEfsswSexMb8H0vsfPpwipIpI60sjgvC6wa23gNalgUULdJdtYl
         mwXJVgHleO5RWlo2hRUdNwJnrfGR7kfGyWB0ZhsTGkS80Ap6o7X/vCtz88SjLw3w6XAv
         xUpbn/ONgr9+3RBB8XFQzThxiGxD/xkTqXFB1+SQF2wdqyFzmWad2v7MHhDoDrUpm2Cl
         1Kzl3n6uHZGTH4nIAVX8OV1r6HD8JbagvnZabuHrtb0CFyXRgIjNrQyT060eRS9+HnQe
         t2jA==
X-Forwarded-Encrypted: i=1; AFNElJ9mA4/aXEk2J31M0rrhJNvwk+puotGWsubeVBbSPo74mq5LsEfb42BwT4hOboWh+Jd/PkxCQObWIA==@kvack.org
X-Gm-Message-State: AOJu0YyPCEUuKd5Koo6Wndo/XaFSviTSnKCFILgsrz2IFwrtg0iRVNnU
	9xIZWhoCbiAX4tcS7bKmwuhxXQhAo5Kw0Q5PIBkGboBZDrI3m+BEq6t4EIPB2bdA6GQ=
X-Gm-Gg: Acq92OFoK1dX8rlYzAVKc4X9E8SGiGDbUUvKcTsxhkntnUb8+uj6ASVI3ZCbscw7d9O
	Aa/74B9kloX0J6alzW0BxEZTzj08dh/UsJGCg4rBchs8P9YkQBC3+HG10mewLGgb1ds3NbCkMzr
	hXL6yJAqt/aJpb7L8+bFgfBSq0yNXtZ2QU/TiNzo+ciiA5z2lYc60JzeFr0mRHK6isX2VNDolm7
	kkLGZm4U0q8EFlcbFHE4R8EtvsHONT+6Bh3GreCPfBE792a4ubY+pkbGQIy8lsUqcF5e2cBv4+U
	fP27iigit/QCGwhdIV/uoFelhoQo1TneTLW893ITebctxJh3cCFH1/11tkEJD5exMqP4wQeHcnl
	8ahILzzZFJIPMTJfRrj9napskzIbO54ULhXT0VuaK6s72XZeP82yFr/N3hNFvZruV3JsWZZ5nhe
	0+p6o2afmxkTZhnNlDylU4BZsZUpY8rha56ySg7DiJZMqoj387ErceODY=
X-Received: by 2002:a05:6a00:1a86:b0:83a:7565:3505 with SMTP id d2e1a72fcca58-842253d0cb1mr14807615b3a.8.1780395064752;
        Tue, 02 Jun 2026 03:11:04 -0700 (PDT)
Received: from n232-176-004.byted.org ([36.110.163.102])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84214d018fcsm12015507b3a.60.2026.06.02.03.11.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Jun 2026 03:11:04 -0700 (PDT)
From: Muchun Song <songmuchun@bytedance.com>
To: Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>
Cc: Muchun Song <muchun.song@linux.dev>,
	Mike Rapoport <rppt@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Nicholas Piggin <npiggin@gmail.com>,
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>,
	linuxppc-dev@lists.ozlabs.org,
	Mike Kravetz <mike.kravetz@oracle.com>,
	Muchun Song <songmuchun@bytedance.com>
Subject: [PATCH v3 03/19] powerpc/mm: Fix wrong addr_pfn tracking in compound vmemmap population
Date: Tue,  2 Jun 2026 18:10:23 +0800
Message-ID: <20260602101039.1867613-4-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260602101039.1867613-1-songmuchun@bytedance.com>
References: <20260602101039.1867613-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 1217F16000D
X-Rspam-User: 
X-Stat-Signature: nqjjkob4tkpdwbdi69jsq56dpwxraw9p
X-Rspamd-Server: rspam09
X-HE-Tag: 1780395065-811420
X-HE-Meta: U2FsdGVkX19M0jAjVWEEm1FZQSEoI5PARbkOwDPmOiGOXLnaYHTLS5knK36xcciZt9AE6C1rvChZVFjcN3fWDs0b7zWq/LSPbp9MaQfOp0p/57n3nMCSJLiD0d4VtXxiaifzwkjA+vhncupPIjaKRts56HmutqTftrV+RxVd2ArrOXx48ueROEGmaIpDNOw32o3qgt1iDGjqQ3hkkVuAB37QV+m1yGVkDh8mQ+MR0iavhn5bigYfkXl0lg/r5f36mpPLiUTNT6LJutAPI/+cwhTS21/VYtOszpE2G5Wbz8N+Hg6uDb5opFfvuJNNiAwZM+7TAF54b7VpH4IAxkiYhs3rOrQ/6PKTF99iSPK4qRQ4kSSWJh1PNbvxZNY+35yp/bS9ACKh1vxFTwNq+9LAckKmAcNriO4mURy3iO96qmUBDgZV4mxUFZiJ4zOAsFDYiP8KeTdRQTGkWmK63vMO2JlPSGfm7GWGGrFG/pJWc6EDWSNI3ZzrE9tqQMRd/Gvp/e+nJ0t384gxiyUuloB2t1tp6s+yuV2Hg5/+USIM40zTe+vEQ7JXuYK/UHl61JET+NpZOytOujnCM2741vVvI2WU2+JeS0+39m24bJkoLaWSdLqlgS4qfWpZiMBnWq64MCT1u8TT4jnEWY+VUY00GFWvHBrK5b5ln4OEKaZ1lRrubikud0JOG0E1AkTaMDZYF4JkVFDC2w9OlpAwCjGG/9nolvGFtyIThCZSgeqdGorp+bklfJHxdl7s7S7GFq/SL2zfm/iUCIT/5KimDu3+aWorRHSqGiPDylnAZPA9/9tlNw8kPv9/l5v8sDiiH/1AvnRMtR2oyXzBpzr3KUidxXsrrZFj4+ELKOYCJVntOsQxU7CMVDA75VpEDo0WdbFH+ho/krXzlQNmvESstLLy7eohBd6I9+7RV2AReZdfgXKZFcOpRg92Vt+kar41rxadC0kVsWY9JlOTQgJ7Wy4
 PzKC4mBw
 BDkq02y5S//3eyupiLKblWgZ2moV/IHF8PJP+SPjPtvIvla4h4F6IXYdl7LI5oo2rL5Ld6ai7j4Vk3QgudBR3QyNhrZNa6LpjpMH1s3L22Nr0ssWEJU83OOKUda44gQPbVyYsA57ElSlaFPv1l4oDMkLopjWjrHtum4sEepF6o8teoLFnu93VsQpgTIl1as+0QqRB4brcPbVplE4PO5n631kcqBMq2bw2iCt3z6mLVEMWyLgRPTfKn/v64T8zjKO1ubabzgbZ242Zj6q/DkgFoKLWk+rlwPyWgElqkxqkaMZbmThnq6aWNyOfezedbrkiXVX+BVH67q/gJZ5aNrcAb24xACb7F5l2CxOCwB7jpLfnuEhs1NJOKS6rSTBKn6bxObd31yd125rn4pVj2SuG1EgXnZf5ZodVQ7HeWNcQGv9cIay/AkuLYuAW7Q==
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
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: Oscar Salvador <osalvador@suse.de>
---
v2->v3:
- collect Acked-by from Oscar Salvador
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


