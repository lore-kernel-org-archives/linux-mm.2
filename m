Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 59E85CA6017
	for <linux-mm@archiver.kernel.org>; Sat, 10 Oct 2026 07:59:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4F4156B009B; Sat, 10 Oct 2026 03:59:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4CA7F6B009D; Sat, 10 Oct 2026 03:59:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3E1836B009E; Sat, 10 Oct 2026 03:59:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 13AAC6B009B
	for <linux-mm@kvack.org>; Sat, 10 Oct 2026 03:59:05 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 5E16C1A07DC
	for <linux-mm@kvack.org>; Sat, 10 Oct 2026 07:59:03 +0000 (UTC)
X-FDA: 85305965766.08.62BF3DA
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	by imf30.hostedemail.com (Postfix) with ESMTP id 9512D80007
	for <linux-mm@kvack.org>; Sat, 10 Oct 2026 07:59:01 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=XNjGH5mS;
	spf=pass (imf30.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.214.179 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791619141;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=41VYVIz+zTmPkAQO5l9k2UXneMzLxonPZ50UDfJ1RYo=;
	b=otcunu89GRjCnFlKG8IE1+wuCvCiZCaU3HRDle7jqYolDj5BZooUVXolnv15VCx26/0nmF
	Q6WhHhRPSo7TYXRuhE9lxpkXE+Nh8Xl1meZlYtYetwAgMANQYzRIMPs6Y1z7UIUIcIUfzH
	as5PhekQ0I2u5aTE4So56VvyAYv7mRU=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=XNjGH5mS;
	spf=pass (imf30.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.214.179 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791619141;
	b=T1iRHoN5zDH46+35eaNwE5195cr3DDngnBWpFO/6u2s9m+5mdp0ULJNDIuhTshp/+DPoG/
	LXT5FGsyCJAW7zOV0CR5NQ0b4CKYgZ25EIEoa2St3TuSK1xij589NpKYtKSl976Qoi83SR
	tMPCA+AHtVOKsLLpAJUAg0XkwkPuu0o=
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-2d71d1cc8b2so2263535ad.1
        for <linux-mm@kvack.org>; Sat, 10 Oct 2026 00:59:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1791619140; x=1792223940; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=41VYVIz+zTmPkAQO5l9k2UXneMzLxonPZ50UDfJ1RYo=;
        b=XNjGH5mSnibSATVNuukct5efi0mWokQcBpSoasSQXWnn7g2Dr69Qp1aPxrGKIPR+23
         ZQ6586u5uXF+3yZMfSXQVcyTdz/XuB0Xa7uT3cYXwiSwApF/bOjxXhED8TopbwwyvqPt
         nvXUjkmxrJ7qHIgUCnbOl50X05pUKLTDXx99l0UO9ShM/C9rb1knV+BaPPJQrW2yRdDF
         o07YwhgsiAE8TaOCI3HYNt9v5WBr23S196xcpojnuVsPY1DDSdKJsVfRD/vt7BwcyV9K
         6mLHZgjlDrTOpW2OOZrO6iAuUl00vhnH8DkiiCRTZV5+1uYRJMTIn95uDhCReU6g9/v6
         d4qA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791619140; x=1792223940;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=41VYVIz+zTmPkAQO5l9k2UXneMzLxonPZ50UDfJ1RYo=;
        b=Wh144LsU4004ekaPipzZKnxxR+8ivKCBuXjimA3FxJ+lUX4wXV34WFxK0jhsGq1KTA
         xMj5HUrRimd9L0CPeqKU05IdMaELgh8RgyJCVxuR8pKogxak9mcvTA1E+BeUt8c2H91q
         1aEOFdD8me7fEME+zhzixdGvXtz5bmfp3AzVfDDX7RV2kRCC8QPFM0KTdtmn7jTlb0wn
         1qg60XhJLMnCZXwl56K2vreCdgqlzsd70tT9/5XZMOWNGLjOFJHsHH8YKFCp6M9fW2r7
         CVtbT9fAipE+ZMV4YmPXHCSYjy3yG6e4/G5+pWPEdDBsPky/+YUgtw1bJ7PfQSK+4rFe
         QcdA==
X-Forwarded-Encrypted: i=1; AKwUvByhZHZz2wOsq/7S++niDEpOsMOtSRF4/gM1nY9qEQYhpNt9YNN6GMf3g7YvmNo2+bNdyUIA5Y+cvg==@kvack.org
X-Gm-Message-State: AFq9FYKC8Q0mCnu3dQWiwsLyyugoFEwnF14p9AIbRTBC0HLKrAh4pVhf
	jzA120kYSBSwBRj/FFRS/DiHxsSJ7h7rNa2ZC8G20DIgikcc7Rzdc/jDKSlJRB0T/ms=
X-Gm-Gg: AYBFou3KGUEIleSoufqVsf4NqN9uW231X8UXp1A6Y1dzi8wgx0bTiZxXc3tjuCDastY
	ZF3ma5Fv0sQkyL29pQVpLwmVvv9ycRPgUGukvUzUnDiQDto3TGnfY4SK6YBjvOY/XrjC3G/NlIr
	9t/vJuXh5Jh5AJhYKtTALwkhykr8r4R7yu3L2WTPZJbF78AttoA11Ux1YLsKFcU6/7gJ3R7V4mq
	t9KeNQ7mx4TNVRYRP+NpLFJJQZ2/AT2xyVZo0alIXw9gUSUG9ZFs/YA7Eh8bUXYaWtYn97tyqTY
	rkhBsPJoHQ/ijR6X8duyy2UyHbN9PrWFbGzLMygF5yOOuUCx498RviEBRgunimtVIlvFmCSCftO
	Y48R03nbW70lp3Qp+hSGDdYTfRWnpEU4OpO8M+Rrg/RSFh3DcgsazVd8fCrBNMoWCNmecBTf9pZ
	9hp0qf5OOLywX4h7BP/gSYcx4/acBmDC/UwQhOc+0U8bcrlAGN1rx2kpVJ7oBtsFJJIC0iK1hnz
	eXDKejTmw71wILNRdltxhuHbwigX3C92/3eSg==
X-Received: by 2002:a17:90a:d604:b0:3aa:f4af:1e12 with SMTP id 98e67ed59e1d1-3ab3a736ac8mr3952987a91.11.1791619140221;
        Sat, 10 Oct 2026 00:59:00 -0700 (PDT)
Received: from G6L4RL2QG9.bytedance.net ([139.177.225.249])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ab57c05724sm3473569a91.4.2026.10.10.00.58.50
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sat, 10 Oct 2026 00:58:58 -0700 (PDT)
From: Muchun Song <songmuchun@bytedance.com>
To: Madhavan Srinivasan <maddy@linux.ibm.com>,
	Mike Rapoport <rppt@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <chleroy@kernel.org>,
	Ritesh Harjani <ritesh.list@gmail.com>,
	Shrikanth Hegde <sshegde@linux.ibm.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	Lance Yang <lance.yang@linux.dev>,
	linuxppc-dev@lists.ozlabs.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Muchun Song <songmuchun@bytedance.com>,
	muchun.song@linux.dev
Subject: [PATCH v4 4/6] mm/sparse-vmemmap: remove the unused ptpfn argument
Date: Sat, 10 Oct 2026 15:57:53 +0800
Message-ID: <20261010075755.83339-5-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261010075755.83339-1-songmuchun@bytedance.com>
References: <20261010075755.83339-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 9512D80007
X-Rspam-User: 
X-Stat-Signature: 7q7371i7tk54nrbriy3j8inq58618cxh
X-HE-Tag: 1791619141-461409
X-HE-Meta: U2FsdGVkX1+j7G05I9dpVpgiWKPshdbvXDQCVVDJV/2b43MfCIiWF5iVN7L13p7/6/ZrgOgG9wetAciFHBe2ppP5Qwzkc26u/uFV1+FCTOSmbt94U6ZHVdzzqULB5V0QHZX92yTaDzoJ1TqlZrMHcYUYgMON1jVvdcppxiUuJhG1Jo7zoxTeuzivBkImVDrx25Hka74HnpKsqdHbVQBcfTUIPDElgKFEDrXI1H6IuPEx6DQQRghDcQoI6edbRy/eYLBlJ4j7FhZtzI8C917h0WcPC72zNVp53EzySm0685g/nuLDklw7y/ydmxaLGoWKopFnCJWig0kH2tAanmpslSj/xI2cv1JbPfo+/sCmdJk4EJUlLKmpKZFnvPJfBGJLzC1zTuA2ggBg0D0ovzwdt/3iE/TlqZ9zq5JXDwnqkAxcwV8XWmL90x+F5t3hNbU/WbWZqYKGRG/GacLgpgIkAVshK3UhpbuGhcsHpacmd0zLmyLUoiMFJns0pdNaVJ1OdCtHZkJv9KZDvlC9dzoFEKAUndd8bu8qecgubNMjn5/3GjQzgSgeX3HEPQcHyLsRR5ojiPM3v0yc1MbH+AqR9//klWZYFdzE8skSSpUR0XAlweNaIe2lGWgI7bzJUKOeAdzZARzR8uAS7ti4ZLueDtxGO87/HVKPiESXoFupHQ/oRPAJXs4Apo9+3BUlttLd9YmFGsEnsHBrV5yIl3QHllaS3/CL3Xh6PrpKSBE3nTMtX4tCEJ0b27+hXC+swh710l92RzW3yaxBN1ExVr6W9QixK0RatWdxvsewzdKwAoP2+OXDX4ZLOY8F81wIWts9msimVX8LUpSJTS/6IiCVu9GdF4VtRnGZsTmgeFln/RJmcxm1g+a4lZsHouyyHQLLTvLfGR2NkgwXkSh/GBNBr1vwsQYMjRaU+NcYPiU2wuODgjBWl4mInmlsaSIUVQZOohT3R23aqY+i/KoNCAa
 V2rWn39e
 wz/TogFSOgRkmc8NxTRTO0Gyd9f22/lBz4VXMh2No8rrPzeC6lrUOiw6228myZ0ZhGu928VBtYyv0Rt4wdZCHRkNkUNlP11Y2LfaH5SjYPe9FsVybeIfJrBCadShUXcHY394Rw+Nw5BjulX4XlkqZgGpm14CK4U1jJch9J7OPILST/Az+D9SAzXvjo+bXSaS3Mj4hz6dnymEwg3PYkC84mnm+rL7ud0k+qhWrY4ZY+R4xUceWQXUAEYWgmBF4CunfW0zji8V0hxvF9vj1BXviNbU4jUpL1QwukNWo+8P8nrVmeDtfnYc9HhstrffeE/RrV6qGTbcVIWOoFaL3fdOPKXFxYRB3OJfFi9PxJc4A8tCwx/AV6ax17/QFHU77f3n+IWLy
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

vmemmap_pte_populate() no longer uses ptpfn as an input. Drop the
argument to simplify the code.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Acked-by: Qi Zheng <qi.zheng@linux.dev>
---
v4:
- Collect Reviewed-by from Lance Yang

v2:
- Collect Acked-by from Qi Zheng
---
 mm/sparse-vmemmap.c | 15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
index 270b5def58e1..07188cdf00f6 100644
--- a/mm/sparse-vmemmap.c
+++ b/mm/sparse-vmemmap.c
@@ -282,7 +282,7 @@ static __meminit void *vmemmap_alloc_pte(unsigned long pfn, int node,
 }
 
 static pte_t * __meminit vmemmap_pte_populate(pmd_t *pmd, unsigned long addr, int node,
-		struct vmem_altmap *altmap, unsigned long ptpfn)
+		struct vmem_altmap *altmap)
 {
 	pte_t *pte = pte_offset_kernel(pmd, addr);
 	unsigned long pfn = page_to_pfn((struct page *)addr);
@@ -353,8 +353,7 @@ static pgd_t * __meminit vmemmap_pgd_populate(unsigned long addr, int node)
 }
 
 static pte_t * __meminit vmemmap_populate_address(unsigned long addr, int node,
-					      struct vmem_altmap *altmap,
-					      unsigned long ptpfn)
+						  struct vmem_altmap *altmap)
 {
 	pgd_t *pgd;
 	p4d_t *p4d;
@@ -374,7 +373,7 @@ static pte_t * __meminit vmemmap_populate_address(unsigned long addr, int node,
 	pmd = vmemmap_pmd_populate(pud, addr, node);
 	if (!pmd)
 		return NULL;
-	pte = vmemmap_pte_populate(pmd, addr, node, altmap, ptpfn);
+	pte = vmemmap_pte_populate(pmd, addr, node, altmap);
 	if (!pte)
 		return NULL;
 	vmemmap_verify(pte, node, addr, addr + PAGE_SIZE);
@@ -384,15 +383,13 @@ static pte_t * __meminit vmemmap_populate_address(unsigned long addr, int node,
 
 static int __meminit vmemmap_populate_range(unsigned long start,
 					    unsigned long end, int node,
-					    struct vmem_altmap *altmap,
-					    unsigned long ptpfn)
+					    struct vmem_altmap *altmap)
 {
 	unsigned long addr = start;
 	pte_t *pte;
 
 	for (; addr < end; addr += PAGE_SIZE) {
-		pte = vmemmap_populate_address(addr, node, altmap,
-					       ptpfn);
+		pte = vmemmap_populate_address(addr, node, altmap);
 		if (!pte)
 			return -ENOMEM;
 	}
@@ -403,7 +400,7 @@ static int __meminit vmemmap_populate_range(unsigned long start,
 int __meminit vmemmap_populate_basepages(unsigned long start, unsigned long end,
 					 int node, struct vmem_altmap *altmap)
 {
-	return vmemmap_populate_range(start, end, node, altmap, -1);
+	return vmemmap_populate_range(start, end, node, altmap);
 }
 
 /*
-- 
2.54.0


