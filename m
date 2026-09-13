Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0A36EC88E56
	for <linux-mm@archiver.kernel.org>; Sun, 13 Sep 2026 08:41:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 252FD6B0096; Sun, 13 Sep 2026 04:41:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 22BAB6B0098; Sun, 13 Sep 2026 04:41:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 11B2D6B0099; Sun, 13 Sep 2026 04:41:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E39F16B0096
	for <linux-mm@kvack.org>; Sun, 13 Sep 2026 04:41:01 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C12F3805F0
	for <linux-mm@kvack.org>; Sun, 13 Sep 2026 08:41:00 +0000 (UTC)
X-FDA: 85208093880.07.73FB112
Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	by imf02.hostedemail.com (Postfix) with ESMTP id 081FF80005
	for <linux-mm@kvack.org>; Sun, 13 Sep 2026 08:40:54 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=Ostf3VfZ;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf02.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.210.174 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=Ostf3VfZ;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf02.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.210.174 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789288855;
	b=Tf7t8Bq5BXIUT4FDDpW7OuajjNV3j8s58D98S2UaJMyXyPkP8I53X0E+Z7tiFQgazGFR4b
	7ZDcwDzeNTxA3brKLACA72yiotZUGDWKnpF0PraBB+hB/NMd25ZxM2IyN71R9b1vW6pcHd
	VhFXRe8UAdMxHqT38EveCkizKevhcd8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789288855;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kHX0G+rfBcj3IGbPNWjgGAyawAROo7044LYJmYZedOU=;
	b=dDHE8hz9PdbmVpQST6ozCJKX1PKlrM6hMNLSOHTlkh35nDbBH72pH42zM8xOtuIdO0eyfV
	zeZ8DVra+0X7aBHCNax0F4fB9/BFVVOwWcj7FZaKJkzOG6d8P8ngJd/WaLyn9ZdSiGCWiu
	ZrIbe00w7Kb6t2Zy1VUL73GzGDn7Bf8=
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-86959a6f7f6so1800080b3a.2
        for <linux-mm@kvack.org>; Sun, 13 Sep 2026 01:40:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1789288854; x=1789893654; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=kHX0G+rfBcj3IGbPNWjgGAyawAROo7044LYJmYZedOU=;
        b=Ostf3VfZj1SXxPuww+iTG/ZUNrKSgxwI/qD5qbyfcDIU0Byyg2dC8RkBEvZnpBXzsM
         Mp91VLG02Fv2w+QeWkT9c/kcU8B4Lml+drpkRDwjYiVZJj1d5TVLZ+l4LPsABeQXrQHF
         m3t0UX819XltZoeHkPX9JCayOKjDC08DYkrZVFDv02/tiDI2UXR1CrRBGuNoRX1lIUAQ
         l6QMB+b75a5yrSXjhr7AtTkoXtK4MKNSfRM9Ifxc5aqmiDvAdXzrXonH7Dl5RuRJYBV7
         w9zlblTMbeTMyOpOc20MR1fcwHw5N/9p0bgfcN84x0hjRkoJ//5qba6ieJPqeD6pVXCD
         NBbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789288854; x=1789893654;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=kHX0G+rfBcj3IGbPNWjgGAyawAROo7044LYJmYZedOU=;
        b=SctC7RhbwgDfPa9J+W5i3trSQh8wsG3HHV8ymd6IkxbEqbMXjWDG2wmt0oj+pasAty
         Qup/VnteU3M7X7KY8+kAmB/4NLC+Ge8pRIKoUJ3vYiDe+4fu+KAHcA/FjedQ3SulIwrv
         POznp8pl6hrBHmgjJIYGIy7DWJm7NEN+2abNDPauU2O3T2zK4c8J+TSh7pqvJnLhnzEP
         TxxRG16e/iHnrm56DOyC/SYARDrgTe9D00sEy7IpwCEsk64bjjiCHbjrpGgQzuJ0XJA/
         0CRly1mRAWMK5R1aROwoglMRSGAZkmxGX3GOwnrrSwMWgGJe/Mo3Rimc4gRg7PcQznRZ
         0uMw==
X-Forwarded-Encrypted: i=1; AKwUvBx/kb2vHEkC0DE2/GfzudLfkSi52hkwH71T4ShMIGYK9mmJJ48e0uU5L09pcAa60kgCd/F2bIqv1g==@kvack.org
X-Gm-Message-State: AFuF++lUzrs9bXW+gqwXDQv/Kksg3qgQaoK2sECVRsYC51KrnAMq5zYK
	F2yjxLYXPtfPAFFsIkRF16NpvIOZMwjdIaE9bcqYIphxWPpLLfKSJWGGPqgjOlDWW7Y=
X-Gm-Gg: AYBFou3HEtyQuGWsRoNAosx7GiMPDf8eZzuazKirQNVLwVy2fKC8xd/sbRJnaOlp/lS
	cqjwEkRLOBViy01nbtpTKVAtiRHKWOHgUCtTBeBm2UNZlLKcQXryNDyDKocAs4BJKYUSqdpUR7G
	wcuZ0uqUSirLbMLHCmwP41+Sp8qL9nOu46yo+VgetvbMwirIc1vzG6pgZG36+9NcSxrtRDuMlpT
	rNRl8y0Ix0WhAGAJue2KahKusc4U1qfR35jg0wdvatKbrfzgKQl2v0nax3pWvwyhZ1zouyPeDSt
	IISp5kVY48STDiDMoSjhKypz4MHxMJiym013DQSKiHzSxcDsjoZZWvdn8fCyTRuJdxU+XN4SpL1
	gFDBTs3FBo2KOjZokVuPeITPc086C9E/SL0TSlmdEW0QrwdQeF662N5FVfSBQ8M0jzO43goGifh
	ybLkGP4u7yxIeZnZJ3dKd4NMBsywFoH7n2scZm4Y6XHxkC1AZ1eLYaFd/OmEoqJD4vuj7scJLid
	Z4zQ0eXJuUCUSng1fCmCwcGM1A=
X-Received: by 2002:aa7:9304:0:b0:86a:9be:6bf3 with SMTP id d2e1a72fcca58-86b31704588mr20617548b3a.23.1789288853781;
        Sun, 13 Sep 2026 01:40:53 -0700 (PDT)
Received: from G6L4RL2QG9 ([2409:8a00:1832:cf0:5137:990:100e:cc7e])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-86b29cbb0d3sm3070531b3a.42.2026.09.13.01.40.45
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sun, 13 Sep 2026 01:40:53 -0700 (PDT)
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
Subject: [PATCH 4/6] mm/sparse-vmemmap: remove the unused ptpfn argument
Date: Sun, 13 Sep 2026 16:37:32 +0800
Message-ID: <20260913083734.86802-5-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260913083734.86802-1-songmuchun@bytedance.com>
References: <20260913083734.86802-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 081FF80005
X-Stat-Signature: 34g8nn6wftskc3r56rufnmb5ky1jj5bc
X-Rspamd-Server: rspam01
X-HE-Tag: 1789288854-297509
X-HE-Meta: U2FsdGVkX1/HQgT4JndZe4WiEjM6LuSmP6RdQKWBZrFj6w3yHQ54qnjHi4leNEdBYQEQ9UTp2v1UgCyhFDbxKbQJV70c2VKhlL2KE2tojDKPTChRmGAdySB0mqu7zMhZBkn2iA9v1FUcbXhWmD6JgdN7ljjKXWF4+KMGNEPHjZetd3/2jDdAwrf8nHDR0imjfV8caDYalFApxHquKZv3IXzTdCvrjlgmW5GnqARfgIshaePdh0L32c0bvwgUKwrBLsJeALcEKSqADn2PBcoXzQ93G9raLdC3RZTHCtqPAxqQYybfEgY2vu2zqSoslG5ClpDnZJVN/WLgjiul/010pnsFCjVQcgOY3OAFbA/IP4yPTIqupPQYaQLjM05emqxlbDwqLctI4la+KkP4n27hGWxqKS3dCyKh5/YdBUU9ZbMV8Hl44vn8X2Tzs/lWKt41KVxDBEGIwpUnmDR5XG2pyQodqFQxUCbdDj+Fntp48aTvaR5A+lDG/yHQN78lqE/9gaW2RXvTuVdg0JLQDLYRqoG9kKi1B04KrTED/6GISM8s9ewGFBkxLJ2NJ0zAzOmF3AY4wk+wQi3cSafODbOJHnaIR8a48iU+LlnWajjFDjVUz3BChqg7fhAPFckNGd23WhwU6UeA7i72vnTxsbggWoiA56cFFqadTPA/Ze5gyHvFkd46PF5GsQeFZfgZRvAkyF7PIpx3iH1pYKosRCpgR5X6ya0njrNRti6vMRVQn6EmQIkuKQGiTNLUgQDsQoYpTZiT5AftAmE8Q0JLWjTKx+XVpksdKY1VOxg3ZcNSxGNvzVSX14mTFecM4sY8AcC9Q9wnq5AlJIlKeun7kzDzAgiBwt5YdZVLRb8u51g2/UEKmjRn4M72WFVh+TK6p7q9R4kv03N3oOlGx4v1iI7Bojdgc9mWtKMsMYz6ezFnf3ufYU1LFUIiAAnevHc4JECHwJ0jnXoq7hQ5DOyvKx2
 hWsjmEIa
 ji1+vEwd0J7o8js42XQf+hZkC4n6gT4Ua8/fLYMI8bNIiJxc3prLjlT69sc2A6IMKTxS33flXawxmY0F8EqoyLfN+iBaGiYArQm0/w6y23NjyZpBeMrUQaLoXE2w+EnVZDakJTusATgfuhYQG7SOXfqZaiaehFUbZwwDqzCbFkKlmuUiL/KRvNwchWiRJ2rZIk7DYKY8PDfnIKNqGhSQvF0+kxb+OBJ2lsXcubZLGjLUM5LW+vEKimgRgOA+eCdHSzUjkViCYw8ADNjHVhEC4ClVSrCsUXY6tjlfQLXtOGSNMX/3S4FN8AzGo1/eYVxUg7NID
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

vmemmap_pte_populate() no longer uses ptpfn as an input. Drop the
argument to simplify the code.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
---
 mm/sparse-vmemmap.c | 15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
index 028f844c90f5..8b4904d9c65e 100644
--- a/mm/sparse-vmemmap.c
+++ b/mm/sparse-vmemmap.c
@@ -233,7 +233,7 @@ static __meminit void *vmemmap_alloc_pte(unsigned long pfn, int node,
 }
 
 static pte_t * __meminit vmemmap_pte_populate(pmd_t *pmd, unsigned long addr, int node,
-		struct vmem_altmap *altmap, unsigned long ptpfn)
+		struct vmem_altmap *altmap)
 {
 	pte_t *pte = pte_offset_kernel(pmd, addr);
 	unsigned long pfn = page_to_pfn((struct page *)addr);
@@ -304,8 +304,7 @@ static pgd_t * __meminit vmemmap_pgd_populate(unsigned long addr, int node)
 }
 
 static pte_t * __meminit vmemmap_populate_address(unsigned long addr, int node,
-					      struct vmem_altmap *altmap,
-					      unsigned long ptpfn)
+						  struct vmem_altmap *altmap)
 {
 	pgd_t *pgd;
 	p4d_t *p4d;
@@ -325,7 +324,7 @@ static pte_t * __meminit vmemmap_populate_address(unsigned long addr, int node,
 	pmd = vmemmap_pmd_populate(pud, addr, node);
 	if (!pmd)
 		return NULL;
-	pte = vmemmap_pte_populate(pmd, addr, node, altmap, ptpfn);
+	pte = vmemmap_pte_populate(pmd, addr, node, altmap);
 	if (!pte)
 		return NULL;
 	vmemmap_verify(pte, node, addr, addr + PAGE_SIZE);
@@ -335,15 +334,13 @@ static pte_t * __meminit vmemmap_populate_address(unsigned long addr, int node,
 
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
@@ -354,7 +351,7 @@ static int __meminit vmemmap_populate_range(unsigned long start,
 int __meminit vmemmap_populate_basepages(unsigned long start, unsigned long end,
 					 int node, struct vmem_altmap *altmap)
 {
-	return vmemmap_populate_range(start, end, node, altmap, -1);
+	return vmemmap_populate_range(start, end, node, altmap);
 }
 
 /*
-- 
2.54.0


