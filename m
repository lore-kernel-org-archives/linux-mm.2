Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 13A7EC98310
	for <linux-mm@archiver.kernel.org>; Thu, 24 Sep 2026 07:58:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2FD1C6B00AA; Thu, 24 Sep 2026 03:58:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2D5266B00AC; Thu, 24 Sep 2026 03:58:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1751F6B00AD; Thu, 24 Sep 2026 03:58:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D713F6B00AA
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 03:58:31 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 740CC12025E
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 07:58:31 +0000 (UTC)
X-FDA: 85247903622.30.73A4503
Received: from mail-pj2-f13.google.com (mail-pj2-f13.google.com [74.125.227.141])
	by imf31.hostedemail.com (Postfix) with ESMTP id 997472000A
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 07:58:29 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b="L4/WdVJi";
	spf=pass (imf31.hostedemail.com: domain of songmuchun@bytedance.com designates 74.125.227.141 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790236709;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=olGfWlX6xVbhFK+fX2D0BitKwIFHB7YuSmffyiYh0rE=;
	b=C5xg/m0b5F/J5UTwCcZqXvkVCw31fKrTlR8rdljgNBQnJMQAOPsMNT28oFnrygilfoCkyv
	cYP7olqlJAwG7TLA5VfOBZzC421jYYp+7T604mTkUiR/nxy1nJUhwRBa4eIcGGqdsD6b1H
	j9CyfmQoHjoRsEtyQ2HHrr57Hdnz0BY=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b="L4/WdVJi";
	spf=pass (imf31.hostedemail.com: domain of songmuchun@bytedance.com designates 74.125.227.141 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790236709;
	b=gWd1n2dIjX2hMX4LE/ChBH6RvOuR9AKGTAJe/FCO6Nz9RRmW6RZbn54+9rhonxsmbePB5n
	UB4FDTKYEnnv3A15v8nj+sFAlkGaGXuuPdqBDHGrh9tEo77UEr/R7+4Wfje8awTYz6VppI
	iU/0iAo8QeGMbzdBroYGe8FG6rr7KMM=
Received: by mail-pj2-f13.google.com with SMTP id 98e67ed59e1d1-39dbdfaef3cso976739a91.1
        for <linux-mm@kvack.org>; Thu, 24 Sep 2026 00:58:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1790236708; x=1790841508; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=olGfWlX6xVbhFK+fX2D0BitKwIFHB7YuSmffyiYh0rE=;
        b=L4/WdVJiJpmSgTnt95sMSaLs2tzEahwZxBp5LuL0luUmUMZJesRPHPoOEQt9FGHKeI
         3b+gOpygSmZrr5BX7g1sA560LcTl0LelhxkJj0KEEzRV1TkNqp7emhEVW4VbWxlOwaEj
         +U+IrF57QPMO2fF7+4Ac+d52a3u/Z3FBfDgF4piDppeeUdXqsblNahSacASgPESeAsUj
         brWBvej4GDsAyApcNwY4uvVbmJmz/gXTvTKqvrGi+JuG05A5isXgJGygv6GcH6WUspUx
         2MHI2Jw9Z91zxhft2r65t1mW3DdJzIYmg7Av7jZej6de6aJsZACnH7vIoCIH7YO+k7oc
         pfMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790236708; x=1790841508;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=olGfWlX6xVbhFK+fX2D0BitKwIFHB7YuSmffyiYh0rE=;
        b=nC/Oofdpjafy/o393Bm5uxxNyUpn5PBuY0pbrdGGWVtdXzdxsY7DuDpBC2vbov2q0D
         7LrA5tWGwZvNLaXD/iacSX6hVzm3+hoz/4hCBmULOHP1kjsPFUPXFtwQpXbBqR0TK9g/
         YRINUrfV+hTosq4LZZJyuWm8MpcmTpndr3bBHkw7Sf3sw8MDjVR/S5+EQ3iIE+cAFawn
         rDZWw9PHlpx82Whs5vqIl7w/PsFKdVbn+EiLy+OalPQ+Sv9OiDcCTsbSHQGFRizmCrJ8
         /fMicLVMR7qhchpwuYARej4KuYSdXFZ+SQKqCWlT9a2ecdyDOWcCwKG1vWFyqJlcDxNW
         97eQ==
X-Forwarded-Encrypted: i=1; AKwUvBwRs+YvTB3KpRGO9pUI6y5FizR6Bjy593aXfX/z+k/0AX+MDKbb+t+29A0yeh5TlKTHYiAdtR33yA==@kvack.org
X-Gm-Message-State: AFuF++ndgmjamVwOxIzVR89F6/4rh6N9hUVNrfB3qMJbbkOLtYLdWz74
	LJm4bnzyMJDjI6IXbiMGijVrr3aGew9CHy3bRyYt5IeeV3lKX02zhS+ZxLrKH7ab9p0=
X-Gm-Gg: AYBFou2L7u/PwbQaITf+CGmLJrJEtGmZISdXC+aHJtB/2UyS3mcKG3vlxZVTw6GMYqX
	kVh3FFrQkXFArzJ5hXt4IQQuiIq3PprOKjGbu7p3N1j6LjMCnIHz1DSnLRoJ+Sh6aJGQrijcUaB
	gxFWGyMfeOL4ZAoXb1LTwmBJ8DJQforEQ9xQ9VyOieSClIWPYsSZDupbO1zTP1ZtomZzgTxt7An
	UFJwz9OJ9sc30gBqKnJ0nkAKgR+dDScXVwvNhIsevJIAwWd37c03LOkuCqB6Xf7BEvHAIyRzOva
	gmc1VTRO/W0DyO3xiRFNOktcnRQ+6cS9/ZgT1Sa/A0RtSZ6oHkVzNcYn7hQ1SQm4Q03PryNyLsc
	iN2VyGiDEBk5P1kJdgdO1OAtyZxbqFShJG471x99spdURbRikMDVNICBihjLkzy9sGZqY+41/d2
	BWwJpgp1zSGuZJAzA3JH3WEusYqtUt6gJIT4TJQO9u1oixE5QFEf+WqLv7JsMH6HLGhx2b6YVft
	waD1sT/0ev2igwAWTM=
X-Received: by 2002:a17:90a:2ce6:b0:3a0:a055:1741 with SMTP id 98e67ed59e1d1-3a0a0552127mr324523a91.27.1790236708461;
        Thu, 24 Sep 2026 00:58:28 -0700 (PDT)
Received: from n232-176-004.byted.org ([36.110.163.97])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a0972eec92sm3575622a91.7.2026.09.24.00.58.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Sep 2026 00:58:28 -0700 (PDT)
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
Subject: [PATCH v2 5/6] mm/sparse-vmemmap: open-code vmemmap_populate_address()
Date: Thu, 24 Sep 2026 15:52:58 +0800
Message-ID: <20260924075259.2013039-6-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260924075259.2013039-1-songmuchun@bytedance.com>
References: <20260924075259.2013039-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 997472000A
X-Stat-Signature: 86ca7i6cnqkrazkf9yhouk6kjc93ctua
X-Rspam-User: 
X-HE-Tag: 1790236709-924185
X-HE-Meta: U2FsdGVkX1+g/5kPjT9N+TaJDrQGODir9te8nIz3JxKEn8JWWivw8HsCJzhktBOGTqTYNz7DYe+2TQ9lWLCJ+QbcCzzZ9JRJNLM48Ini7Qw5fvpPtxy2ChdcdzDTJwZn25kahBR4TVl7Lysa3FB9PaHmJpdeKhtwc5HYzUT7BsBlmZEXCra861KBpX8Qps75Wr2Ly5qJP26PUcDI0RlIW35m1yOyUitcsERht/zPOElVvH5s2xQCKVZDRKNx9g3RiXXInmkG0FPTwZ5UAnU3wYlG5CO1mDzb7cdWLvF/Bqa4LDIbmle7AUMl6JctM3w2Gz3JppjyZCBbez1XIJj0I2EGzI9O1UjBpzyOA/2yaOd/HTN+Ja3qNG8QUyAM5pvpwa8mhE+JOVzvmFwGG44UYsS86XcaqLtBKXIsZga+tW0+OjkVbWz+jBam6fcOT2E0zgsWDe3V3s6S1aL1mc73799q28lOri6HwDsi+z/DUEjWxtAtJtgSH0EQco+t33A9ecXbVFz685pu5I18slEOEUMGo9lK7fRCdVVcOiW4mrh6E/kD3CpXVILtNmt32nCyONDJSuyjVnKr+GRfxbsq7imhCJCmH5Uopv37KqVpwwv1eeriuRYXVHI9ZI6Zo5NktgoOypDD9S+Z4ce3DdlJFyiOyDDD0JiHPxsr+Qaixm0Wh6Kxr5atKH+8Ivwx/rST/HY4Nd33wQmgmOaj92Q03sTARGtELCMRrIplmsG1ibm4zdDptChX6XYZ8ImtV1kp46ADjjUcDdVxYIhDcQNat55J4U4nedgUzBRvvHDegOi7+jfcbifnO3wwvhh4lXGpKpfKEB5m+AdlWgCNZiZ0+wscqTrEqqrPJvsH5DprJ7NCLT3CmECiIFEWQ7CmvOI5RnQYzJIfaSQNfZO+1+X8h2IX4MwTdq9YdzmWktQNe94MsKaD3R38a9VLd6JJn9+XjVjqGyoFS8RcOQDwTQV
 fkWt/LEd
 UCEE8aP0r4sRLMl8tjcP4jTqogqOr2GTaChSgGlQ7tFVd+NULWFFvqKn9YyW7v/vH54EeTqe+8MSOCzEXOdK4KS0vVTuROcC4qx9BngxtwKndEAoHNij5BQ1EW5Q8A+9opsrEzsULrMOnBQm8zbLupuO+C6O26Jb/wVfHJnR+U5YqgwlIR/P2mH45H2BmRzt7XF6B8ahj8fz03y4AsqQsSTsowLOw6aT8aTmxNnYZZhH3/dU0P3N83PH2Yy/9OyRlU5/ODHVhRu44bgYQj8U8/8rURkq0qlh69i6gmmstfQCdvdJEdr5rA3pb0wsgiXF15hXPg65GGm/qy9DQeQdbv4FgSdRtro/SfqtdiJZ8y8fEZoo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

vmemmap_populate_address() no longer has any callers that need the
returned PTE.  Its only remaining user, vmemmap_populate_range(), only
checks whether population succeeded.

Open-code vmemmap_populate_address() directly in
vmemmap_populate_basepages(), remove the now-redundant range helper,
and return -ENOMEM directly on failure.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: Qi Zheng <qi.zheng@linux.dev>
---
v2:
- Collect Acked-by from Qi Zheng
---
 mm/sparse-vmemmap.c | 54 ++++++++++++++-------------------------------
 1 file changed, 17 insertions(+), 37 deletions(-)

diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
index a5b47e496322..f5364c1cafe5 100644
--- a/mm/sparse-vmemmap.c
+++ b/mm/sparse-vmemmap.c
@@ -315,8 +315,8 @@ static pgd_t * __meminit vmemmap_pgd_populate(unsigned long addr, int node)
 	return pgd;
 }
 
-static pte_t * __meminit vmemmap_populate_address(unsigned long addr, int node,
-						  struct vmem_altmap *altmap)
+int __meminit vmemmap_populate_basepages(unsigned long start, unsigned long end,
+					 int node, struct vmem_altmap *altmap)
 {
 	pgd_t *pgd;
 	p4d_t *p4d;
@@ -324,48 +324,28 @@ static pte_t * __meminit vmemmap_populate_address(unsigned long addr, int node,
 	pmd_t *pmd;
 	pte_t *pte;
 
-	pgd = vmemmap_pgd_populate(addr, node);
-	if (!pgd)
-		return NULL;
-	p4d = vmemmap_p4d_populate(pgd, addr, node);
-	if (!p4d)
-		return NULL;
-	pud = vmemmap_pud_populate(p4d, addr, node);
-	if (!pud)
-		return NULL;
-	pmd = vmemmap_pmd_populate(pud, addr, node);
-	if (!pmd)
-		return NULL;
-	pte = vmemmap_pte_populate(pmd, addr, node, altmap);
-	if (!pte)
-		return NULL;
-	vmemmap_verify(pte, node, addr, addr + PAGE_SIZE);
-
-	return pte;
-}
-
-static int __meminit vmemmap_populate_range(unsigned long start,
-					    unsigned long end, int node,
-					    struct vmem_altmap *altmap)
-{
-	unsigned long addr = start;
-	pte_t *pte;
-
-	for (; addr < end; addr += PAGE_SIZE) {
-		pte = vmemmap_populate_address(addr, node, altmap);
+	for (unsigned long addr = start; addr < end; addr += PAGE_SIZE) {
+		pgd = vmemmap_pgd_populate(addr, node);
+		if (!pgd)
+			return -ENOMEM;
+		p4d = vmemmap_p4d_populate(pgd, addr, node);
+		if (!p4d)
+			return -ENOMEM;
+		pud = vmemmap_pud_populate(p4d, addr, node);
+		if (!pud)
+			return -ENOMEM;
+		pmd = vmemmap_pmd_populate(pud, addr, node);
+		if (!pmd)
+			return -ENOMEM;
+		pte = vmemmap_pte_populate(pmd, addr, node, altmap);
 		if (!pte)
 			return -ENOMEM;
+		vmemmap_verify(pte, node, addr, addr + PAGE_SIZE);
 	}
 
 	return 0;
 }
 
-int __meminit vmemmap_populate_basepages(unsigned long start, unsigned long end,
-					 int node, struct vmem_altmap *altmap)
-{
-	return vmemmap_populate_range(start, end, node, altmap);
-}
-
 /*
  * Write protect the mirrored tail page structs for HVO. This will be
  * called from the hugetlb code when gathering and initializing the
-- 
2.54.0


