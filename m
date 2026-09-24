Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6BD77C98315
	for <linux-mm@archiver.kernel.org>; Thu, 24 Sep 2026 07:58:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8F0836B00A7; Thu, 24 Sep 2026 03:58:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8C79D6B00AA; Thu, 24 Sep 2026 03:58:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7DD7A6B00AB; Thu, 24 Sep 2026 03:58:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5E0076B00A7
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 03:58:27 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 00A85A56C8
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 07:58:26 +0000 (UTC)
X-FDA: 85247903454.25.4525B29
Received: from mail-pj2-f13.google.com (mail-pj2-f13.google.com [74.125.227.141])
	by imf23.hostedemail.com (Postfix) with ESMTP id D58F8140007
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 07:58:24 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=IpRTMT36;
	spf=pass (imf23.hostedemail.com: domain of songmuchun@bytedance.com designates 74.125.227.141 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790236705;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vIuII5z6VGpIszxqYOaYyPM2+uByFb+jC50FCk2K+v0=;
	b=UEAFKac9W4sUEIKsQvj6hEjtpSguEeQe1HOonkYL7DBaQYNGzqTMXeUbWEJJXrTABB+QSb
	HPBz4Nv3Te83suorVPoER3j0JMs2TqpBLm6vxP2xJ94OJ8DPxc1HCqfiyO/v/7cTffQA0S
	O+0dI6duDTj6u9cpEka9iC77gzuIfO4=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=IpRTMT36;
	spf=pass (imf23.hostedemail.com: domain of songmuchun@bytedance.com designates 74.125.227.141 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790236705;
	b=j5kveIPSA935rrNLxsBv5EfptOTFtK1Ihcg50T+slrnGqS8u8/aQz8gvopnR+S6tX+4G1G
	1o6qjRneQx5UxV7va45uuS8LNJu0Zl7IlS1+2/ntiMsboCavnD/SwLqEfkh1SU8rgHKyZE
	eN5V6YXLoOtJ68GZPQGt5xQquz0An4c=
Received: by mail-pj2-f13.google.com with SMTP id 98e67ed59e1d1-39b31b4281eso1284263a91.2
        for <linux-mm@kvack.org>; Thu, 24 Sep 2026 00:58:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1790236704; x=1790841504; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=vIuII5z6VGpIszxqYOaYyPM2+uByFb+jC50FCk2K+v0=;
        b=IpRTMT368wSDHo6QtY93m7rwdKFdGET59HLJeib+x9RroW7z3UOOvO//uWxqmZgYaj
         /QuWY608HHlUNk6KC5mvjmH2aNillnsuGK95q5YTwGrXNejg3h8M3wNz1Nxu9wtuiHb5
         3KVTq0V7rI6bEYoagxbI5p1L2Ny0X4UyXiN+dwNiuMBbyaRo9vfxzFo6oW95jIvXqbI/
         eEzK4YcKq8bMguG1qtn6yr9KCmpaC0gjL25xsnVJODTcoBVoNyQX134f3Sw48duW5yp5
         RGYG1P2WFqiNPD7xx+71jQl+7EYEKxTzNOUGf5sTQ2JTF4IRkeKCz+5qMrEI5/T6lgWY
         S9Tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790236704; x=1790841504;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=vIuII5z6VGpIszxqYOaYyPM2+uByFb+jC50FCk2K+v0=;
        b=tUhc0RyOBlwu5hPKTcbQnhc6o9x1jYQeHik8jDUXKcIFoRBbr6gpoWPksItDOMwAkE
         ez0iQwWVoq4G4Y5WzHz//0wo4DXKw98vTtCUU6ybUB68eGQVHX7STJPDnTMs/dZBi2IG
         BlLxhMKlj2JQLADJIAQUrPy2zUlfXSfOjbb2XlRchmXB9DA7F0OoZwGgwJwYbvy0dZz4
         GX7taP3O8c7yP/DPmsIwImlRXZYauOwKVCg3uJqA5Sx9NnvIy4cedG86oh/N0ebKRFp9
         e3KIJw5S/oJLN1+Ivp5KJf8MaIg+GDYt5eS40KgF4sGiJtmRb31DbcUHj85izo6RbSAy
         jK/Q==
X-Forwarded-Encrypted: i=1; AKwUvBwUQxTFfwDqENCmolNDc0QdyG2JVwIfU0WWWyTACNCVzKnv5kqGPxI+dm0y/Zm6EfTWfECSw8s+pg==@kvack.org
X-Gm-Message-State: AFuF++nQLe9JSFCpO0B8HA89tfI6R6zaIazJCCAdXHGatddV4mXmKYW5
	MACzXucVk98weOxWyn4H46m1Ib5NNyTwA2yV4cIbDVlZGvfkMlIUntwD+BUwL4gQpZQ=
X-Gm-Gg: AYBFou3/dMVKeszKBhiiFwmyrQR/n4bWXe9X/E9GyF5A3JK0jSHLkewUFxrRPTSUy6x
	lIfKjGiy2zmuKgmUWJEGiocxAkFG96GP1DbkRyOOHfxY29gIapinSeU6m8u31M+6Gaup07jfOzn
	rjMa3FJ2wdfmMeth9KsfFFTC8OIVoTN0C5vNWwmOeSS8BIpxidrrtQiDRfKkrgx5cU71fukY4IS
	y7gLn15CTTB4cW2499eg2V0LdCXUCmnkZhLWSxTxh+sOCCcPhy0Bs+z4ZBtik/3vyUAfCBG6ENi
	8wQHT/q/Q56DSUGXeLx30728BUaHCxWvBDYcqccOZjVAZPFc2uWhMguIwpHQfGrbVNgHY9Eg6hd
	eOZQjYSwx6L4htsrw6BnQ22nchGdbPEmBPuiILx5XRTVlXXc+MdmwZZkcAMX87VBBkajCSxx+eg
	bv5wp2brxGHNyQs268ndxOY4b/hPrJNf2leMcfk2v0aBo7cSi3NXZpPYDaIs0F3IQkGKHdgtRCn
	JZdr2CF1yI1W6PYMsrX
X-Received: by 2002:a17:90a:e7ce:b0:3a0:2662:815a with SMTP id 98e67ed59e1d1-3a098db8c10mr1546074a91.43.1790236703641;
        Thu, 24 Sep 2026 00:58:23 -0700 (PDT)
Received: from n232-176-004.byted.org ([36.110.163.97])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a0972eec92sm3575622a91.7.2026.09.24.00.58.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Sep 2026 00:58:23 -0700 (PDT)
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
Subject: [PATCH v2 4/6] mm/sparse-vmemmap: remove the unused ptpfn argument
Date: Thu, 24 Sep 2026 15:52:57 +0800
Message-ID: <20260924075259.2013039-5-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260924075259.2013039-1-songmuchun@bytedance.com>
References: <20260924075259.2013039-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 3wiczyiiywp7rwdu34as6kn1ok8y4g4w
X-Rspamd-Queue-Id: D58F8140007
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1790236704-309499
X-HE-Meta: U2FsdGVkX19mkC1nNy8iPjlCBdKacHI+gx4N45l1Ju8wdFDSEduKV3IrG82AclnKHznSSakcM7YezsNCujnozVbJV4yh6B3zhLoOOPfu+5l51gvzYbxZS9/1+hMVa9g2IlTigVkDEArGQvB2mLSQwkQNTbaNjkOnaLETEKxYF6PdMxxeCnHow89LK+DwnEfSDSWRGEZ7d/xNx2wPG7kFal8OKrg3lzhTvrisb190YLyZ698lLPGUU+xAItm3jtWRd/JHNE2cKHfWnvc1lHv5rXMZrareaMAC6maM4uqSdRR/Z+Vn0f0oZSeXMeMHcM/ILD3krxI6aezntkpAFH6kXKPexn+PvTDdl4WhFrfbNU8i93Zxaby0ZbTf7HN5shZ7DgMZPvh2Q9mFNYPrB/8kIlkAeDJH9XU6E9L5sbywj4KQa1WazwNOUxpV9j/hj+tBRJp+inN6dxRScStD6wb1IeOYrJlTktvFJsfbMvPPLgPpdUdyH8RrYj3FoqS8Uzeze+0w7DdUgrJZpj7tlBFzaadbi8QoCIuI+CjTOz14vrwT//qF+GpzPWeNsqK9+8TQTSqI0UoZuO1ceo5qHNYZHsugyjXLxHOX3g5Ylm7IiSq4xeyrFGiNt63VtsdYPt1HamhNK2kINvf/FtMKC/zOJ6tvPkh2DLYL8gEmKzBZAOKvcnjEXToSRTTVeI7d7LJRIHi8lYdGrgZ5jh3x3OPjRLBY0jXKDAbp39MCRnWKyx47hJkqUqnpElb0D9loJgCQj6iTapvLxuERifWBevtmfMstgGWLurY1u91K0gjtP97H4e5rRH8pcNoD/lbTn6Ef0kAhekgvpJ7xyB4L69CXbS0W6Qdt//OXv1AyCUs0ZzQVY+nbOUudDL1huWcPgqa2+hbLfYblxosoYOQ/EldJ4uYh6+szhKWynCwVq8wGsNO+VDOtjmBq4RmSEcnabMo4was15rajs+Ttz3vn141
 l38E9oER
 wkK1oX5pWEj5gGxUGK6Z2vjOz9bo6ZQSqcXJCOTSCGMcvJQJ7GNq7TU0jeg6Ttz4I14qWIFfpXhriInWm/2sP4dN9ztLIKZ5sN4JtbOd9NYv39g1mVBgXetfrvptnG+55WyS1WTtuCidYi2pPHyUd/S0O7O7dST7akkOBhLgDP018oV+KNw0GDHeSuNGfxZDdkqriZZByPPUMORkaL+qh2U+qAdH4zJo0rOzw25pgcB6jZjRJuq8xS/oDqqeypAYOILnmBHYYQcZfFiPhd+p0vc+eg/MJK5LYrJovb61TiqyXD73dhbCXAGXTbQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

vmemmap_pte_populate() no longer uses ptpfn as an input. Drop the
argument to simplify the code.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: Qi Zheng <qi.zheng@linux.dev>
---
v2:
- Collect Acked-by from Qi Zheng
---
 mm/sparse-vmemmap.c | 15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
index 4aae22beca21..a5b47e496322 100644
--- a/mm/sparse-vmemmap.c
+++ b/mm/sparse-vmemmap.c
@@ -245,7 +245,7 @@ static __meminit void *vmemmap_alloc_pte(unsigned long pfn, int node,
 }
 
 static pte_t * __meminit vmemmap_pte_populate(pmd_t *pmd, unsigned long addr, int node,
-		struct vmem_altmap *altmap, unsigned long ptpfn)
+		struct vmem_altmap *altmap)
 {
 	pte_t *pte = pte_offset_kernel(pmd, addr);
 	unsigned long pfn = page_to_pfn((struct page *)addr);
@@ -316,8 +316,7 @@ static pgd_t * __meminit vmemmap_pgd_populate(unsigned long addr, int node)
 }
 
 static pte_t * __meminit vmemmap_populate_address(unsigned long addr, int node,
-					      struct vmem_altmap *altmap,
-					      unsigned long ptpfn)
+						  struct vmem_altmap *altmap)
 {
 	pgd_t *pgd;
 	p4d_t *p4d;
@@ -337,7 +336,7 @@ static pte_t * __meminit vmemmap_populate_address(unsigned long addr, int node,
 	pmd = vmemmap_pmd_populate(pud, addr, node);
 	if (!pmd)
 		return NULL;
-	pte = vmemmap_pte_populate(pmd, addr, node, altmap, ptpfn);
+	pte = vmemmap_pte_populate(pmd, addr, node, altmap);
 	if (!pte)
 		return NULL;
 	vmemmap_verify(pte, node, addr, addr + PAGE_SIZE);
@@ -347,15 +346,13 @@ static pte_t * __meminit vmemmap_populate_address(unsigned long addr, int node,
 
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
@@ -366,7 +363,7 @@ static int __meminit vmemmap_populate_range(unsigned long start,
 int __meminit vmemmap_populate_basepages(unsigned long start, unsigned long end,
 					 int node, struct vmem_altmap *altmap)
 {
-	return vmemmap_populate_range(start, end, node, altmap, -1);
+	return vmemmap_populate_range(start, end, node, altmap);
 }
 
 /*
-- 
2.54.0


