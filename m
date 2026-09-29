Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4FC66C9832A
	for <linux-mm@archiver.kernel.org>; Tue, 29 Sep 2026 05:33:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 622126B009E; Tue, 29 Sep 2026 01:33:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5F94E6B009F; Tue, 29 Sep 2026 01:33:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5363A6B00A0; Tue, 29 Sep 2026 01:33:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 30D2D6B009E
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 01:33:46 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id BA7ACA03C9
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 05:33:45 +0000 (UTC)
X-FDA: 85265682810.12.D55682D
Received: from mail-pj2-f42.google.com (mail-pj2-f42.google.com [74.125.227.170])
	by imf24.hostedemail.com (Postfix) with ESMTP id 8F2C8180007
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 05:33:43 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b="jMZ0c/qM";
	spf=pass (imf24.hostedemail.com: domain of songmuchun@bytedance.com designates 74.125.227.170 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790660023;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YJAndcCm6vhI/WUnYbFErakp824Wpkra2IAgLjHGuUY=;
	b=5bWzgnYuOsFIyPFkcuOZmiti9wrwPOW4nhQhB6ub1bSFRVwCpqr04cypnA4l9Mt3dRf9ZX
	BoARujzvBAYbGqMHW8cAztfaKSvdpwKtrJGznHmf8xJ9nPpqkIxfdTGhKfa2bPgeZons4T
	ADmminOs/CuwsYnESQPmEnFgtsSaZoE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790660024;
	b=opxQgqAftpr+VZmJJoCLt930Qpl0WM8fWiOlbpweiue7PV6vFysIX+LqiU2NI0AhU8Y3Y8
	tDLUzp3YTJGVzR9ldTfs+CCC4Hn7JAewBhmGEIwRxFI3o5DwH71OtuzadodhfxW0RjRZ7Q
	hstmyBrsB32XZvcEabQqv0qmybwVZpo=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b="jMZ0c/qM";
	spf=pass (imf24.hostedemail.com: domain of songmuchun@bytedance.com designates 74.125.227.170 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
Received: by mail-pj2-f42.google.com with SMTP id d9443c01a7336-2ddaa08c890so15488625ad.0
        for <linux-mm@kvack.org>; Mon, 28 Sep 2026 22:33:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1790660022; x=1791264822; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=YJAndcCm6vhI/WUnYbFErakp824Wpkra2IAgLjHGuUY=;
        b=jMZ0c/qMGcHXrcHtsxA7hhrji1FG994tb7YD/dusFutwu8djjPOWJX1cN2l65I0EmV
         fJr4/pCkgvr1XMwnkzxALr0mCctt+5Sr6XeCCVlBXi3rPjgwFZV67hshWi9obvt3qPw/
         vBYC7UgWOq3shmlcz3OFGcUFVNdMDKHIv1DpvxLNUGzuWUtCIe+yOzLIq6dD8/M+AnxV
         4505OuaJd0uJ4thzPhdUmiAwf64tzOSIdVx0mDIi6WKdT82DNbYsaAnrilLPvz03McLt
         ACPTPvgkqJf7vwHP0TKjb9msnkqeLqgg1TvAh2CNbvVKYqZSDuVUy7nYabHBvBYeI2tm
         HiLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790660022; x=1791264822;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=YJAndcCm6vhI/WUnYbFErakp824Wpkra2IAgLjHGuUY=;
        b=H1XsQf5aJWohbnC3ab+5SOufycyz6ZtHc4wcv4AIgum8JGW5ld8czRt4qRp0sWycYJ
         uQZI4monsJL7wn3/13tLJIKfGZBHERKYRg1+pQXq3G0Ug0eoxIaRBLdvRlIe3S/9DuOx
         tBW1wlqixxsBAVZLALru35Nqw30BUxhias8UNgAzbmpuhCRgQwZ7g1UzAqt8eXNpCow4
         rc6Xtee/B3iJ8+W85tjeDeQGWPGNfTpk+lUg/iI/6CEL05prPcZaVHoBcQ+bL8nPl5p8
         tduuXlWJ0UqMJFByLSG76gRP9uKQo18F5g3WwDO51ka2bMNNdS4uXZofeeqEE0krO72/
         iniQ==
X-Forwarded-Encrypted: i=1; AKwUvBw3ilFAKaRA1gd5ga62L2UrFIvqbbHp8x4rRYrWm+T1c3XNm3uWE3GVTa0WE8wHmZ1FWajmw176DA==@kvack.org
X-Gm-Message-State: AFq9FYI3GNGpV23AFAUZRGtBk/EhEf/6CpfWawHMW4MDCjYkj1mjxfix
	JA0LHW0k9ISAJlfVHiOzgIXsDcaZe+T5wYygmRWMt08KtTmjssa7LMIrlAuv75vnz8M=
X-Gm-Gg: AYBFou2cJN2HrjW6z50Zk7Gk+YP9GD7K+xNb+9/7F8nnNJvMCDl6+5M3BeLP28j/wor
	89SLHC8kwLGmiDMg0HfprO6Ir3GoSFSZ1lu98kO1i98yl119MoIeRtg13BYBZVq940C1kXgBjit
	cWCIXo1rVwoYko24mAq5fRWTTMnLCUc4eRJaRv29oZxDINa5YO8xB8qNwCRTegMxeYqAAqqhXAJ
	mJ4Vebn/A/A0TTeWL3vXxSgX7HsAbCkD4BPQjhTbbw0bPkg9bX5AceMdg7A6LpH/+Qx6AXtqjTd
	C71bkUhI4BJPhWmE5cnEfDvw4VEo+8hMWfptJ+gYN8AQuO31xT3Z0EiArro6am02bIMpOX2pTXU
	16m9Z7BUG8gprbZDDlU/ZgLIqyUE0qlmoSKPdp023g6Py7xvE2AETTN5bCr26cTpe0SoIzMQMMd
	ySCwkihGypWr8tRswNSqvWSiSsLfIYJuVm8H0VJDnIQJTwegmHTe9+Y0XwimIAazWJM6mce1WwF
	DZEFJrwfO09BqneJjA=
X-Received: by 2002:a17:902:d54f:b0:2dd:c100:7ccd with SMTP id d9443c01a7336-2df7dd8bb87mr125260505ad.73.1790660022267;
        Mon, 28 Sep 2026 22:33:42 -0700 (PDT)
Received: from G6L4RL2QG9 ([139.177.225.254])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2df9142bafesm49251765ad.51.2026.09.28.22.33.33
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 28 Sep 2026 22:33:41 -0700 (PDT)
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
	linuxppc-dev@lists.ozlabs.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Muchun Song <songmuchun@bytedance.com>,
	muchun.song@linux.dev
Subject: [PATCH v3 4/6] mm/sparse-vmemmap: remove the unused ptpfn argument
Date: Tue, 29 Sep 2026 13:32:29 +0800
Message-ID: <20260929053231.66085-5-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260929053231.66085-1-songmuchun@bytedance.com>
References: <20260929053231.66085-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: 9mao564ynyay486767b9u6rewsbbxjjg
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 8F2C8180007
X-HE-Tag: 1790660023-275635
X-HE-Meta: U2FsdGVkX1/lVgftzZk4MzAy0Vb4cLQx0vEMTbYeJC5A6QSbcmUd6jUtonNGiEvybTFtW/m7j18WnFO7PuSw5QHgaXMvm21BBVMaohInKMZzAnSHbkZWxF8IEpmPFeyFQo6Fv9sfOwuG6gb5xpB3o4q+8QCeQzTtYhalGaZqwTRYzExhvLBxFZlfhp2wS1YLYQrPbTZ4Ef1v9jw7KJG8B7Wb3dRxgmmA+A927e+aW2qJ05t51tnu0Px0PoCQPaXJ33fi/CaCyeSxJWf+W1ZAFqD5WTrfBh80Za3tqYWDClUCI6UAOsFet9YKM+Oh39NF6UOBsAspjgjDhLZPfcb5BnAninN3tiZ2p4Z1NJqEoYG9PfgAfuQSxmirgx5bTSFTpq+AGWHyv+0O+0lG80jTBvEXgOv4TZ9CkzUGqbwlVTeDT+pNDUwXzzukZoneXCdQ/4SPKg6X7aTEMUvg/c6yZO4+fYsn43azUnmRyRqQ1+9M6ITJsuNGRUdWzBPh1Tnpc7JmOED7fxcXR/kvAs4Dyx9HKU1cvBllOlufan0rSvhvaletHzOsGvVO+/dhemGn7ed8Yj8sUrQgy3Rv9rBuzsBQmHiYlPM4OOBlp+pyBge7t5246DQ6qawGmcBX+JKkpo2F1BCO6lcyCIUZIAKR0sZqy2qcHdeUJHFHO6si1EWJTJ+nPC3yqa+N07hRYmPJ2VLuUW3xaWN9YNx5UZ+smhztDtWBcf7rHs2RPHOgn4mx7iatVNum/0IFTGCS6gXdKL5C//dVIFvkjwP9GP7HI18HGidTeQqBNDUXlnOgDY3TuIS9auRyOPCuSo8H0qLjgL9AThc0WHDQZZHOsXrhlIFXEPiY6wYJdrEYW+m5VMkQFEtaVyN18hnXQUkFzmY1oCGyjDywtdjS0XJNqWy2wndYJICh8x0BC6KwYBk7nLbf8uwZ11+shXO2E0ck0T40reWZL454SUe2FhYbUG9
 kGpyF7HV
 r4ZH52Sgw96UBD10QbD7DmfocaU8cemiz8hARiAEM+XlTS9QowvQIkR4/Pv5ANoRek7+SzeRX4ZAqRuO0egV43Smjz9ULB3jtKoMGDXptQPfm6prUIv6AoGeUv4YlHOJ+limRyCdJqIrYostETytjpdcn/BAylA5fK3NHxblMnhGPjWA6gNOYUmDBu8X7eRU/7KdSPf73lXll0YLR8VSNLKX+wtZC3yXIoly0eS/afL8yJF03UAq9dgCI7ylFBeDohO+7LJOE311PFER4MPWE2ykkcxqUO1MZj5OFeWmIn2TdIbx5e0kszLGFMTu4fOqIaWLmbHuc5bS78nVR1jEkkkIiUxqVT8ZCQ87IUEezg/JESVgQ64CzHLVVBSXCXqu0Cuz/
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
index dee95e520376..5fd2df2b516f 100644
--- a/mm/sparse-vmemmap.c
+++ b/mm/sparse-vmemmap.c
@@ -278,7 +278,7 @@ static __meminit void *vmemmap_alloc_pte(unsigned long pfn, int node,
 }
 
 static pte_t * __meminit vmemmap_pte_populate(pmd_t *pmd, unsigned long addr, int node,
-		struct vmem_altmap *altmap, unsigned long ptpfn)
+		struct vmem_altmap *altmap)
 {
 	pte_t *pte = pte_offset_kernel(pmd, addr);
 	unsigned long pfn = page_to_pfn((struct page *)addr);
@@ -349,8 +349,7 @@ static pgd_t * __meminit vmemmap_pgd_populate(unsigned long addr, int node)
 }
 
 static pte_t * __meminit vmemmap_populate_address(unsigned long addr, int node,
-					      struct vmem_altmap *altmap,
-					      unsigned long ptpfn)
+						  struct vmem_altmap *altmap)
 {
 	pgd_t *pgd;
 	p4d_t *p4d;
@@ -370,7 +369,7 @@ static pte_t * __meminit vmemmap_populate_address(unsigned long addr, int node,
 	pmd = vmemmap_pmd_populate(pud, addr, node);
 	if (!pmd)
 		return NULL;
-	pte = vmemmap_pte_populate(pmd, addr, node, altmap, ptpfn);
+	pte = vmemmap_pte_populate(pmd, addr, node, altmap);
 	if (!pte)
 		return NULL;
 	vmemmap_verify(pte, node, addr, addr + PAGE_SIZE);
@@ -380,15 +379,13 @@ static pte_t * __meminit vmemmap_populate_address(unsigned long addr, int node,
 
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
@@ -399,7 +396,7 @@ static int __meminit vmemmap_populate_range(unsigned long start,
 int __meminit vmemmap_populate_basepages(unsigned long start, unsigned long end,
 					 int node, struct vmem_altmap *altmap)
 {
-	return vmemmap_populate_range(start, end, node, altmap, -1);
+	return vmemmap_populate_range(start, end, node, altmap);
 }
 
 /*
-- 
2.54.0


