Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2F711CA9EC0
	for <linux-mm@archiver.kernel.org>; Sat, 10 Oct 2026 07:59:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 20EAA6B009D; Sat, 10 Oct 2026 03:59:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1E5016B009E; Sat, 10 Oct 2026 03:59:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0FB916B009F; Sat, 10 Oct 2026 03:59:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D42416B009D
	for <linux-mm@kvack.org>; Sat, 10 Oct 2026 03:59:12 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 48D19A0613
	for <linux-mm@kvack.org>; Sat, 10 Oct 2026 07:59:12 +0000 (UTC)
X-FDA: 85305966144.12.3BE514F
Received: from mail-pg1-f181.google.com (mail-pg1-f181.google.com [209.85.215.181])
	by imf21.hostedemail.com (Postfix) with ESMTP id 7705F1C0002
	for <linux-mm@kvack.org>; Sat, 10 Oct 2026 07:59:10 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=U+gT2Q8q;
	spf=pass (imf21.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.215.181 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791619150;
	b=rDsfwPyBX9LnnCCexpSdDEZshgUMtrTtNct3ln3lr5RP++deNXSqBfwYdXpLAHpZjYwav8
	Y1iiaSP0M0obJzZVamHNtgXHPZ3OCS8ZiPFcTJPaVicixp5m6ao8u0soT+8P/VEtMoScWW
	SfvtJm8Ma4tw6gpWNXSELEUW0O86Ygs=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=U+gT2Q8q;
	spf=pass (imf21.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.215.181 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791619150;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JUYV9kBM40++h+Iuf/kFSxpEvNiJz1Gg8/l7n+m9rxI=;
	b=niICuNW3D0QusrnDhc5hB2F468lkrJIHch8E5PnHxsAwE6jM/531vw3sSNcP9mlDqe4uwW
	Za3MuUv5Rj2w5VQMR1h27R8LNGC4xS1jJ5HpgPfjySb8k8mLbzPD/BOq8rCzmCaOJVRh8i
	63fNF4/CeJnghC0DSdKVsXauRj03IDg=
Received: by mail-pg1-f181.google.com with SMTP id 41be03b00d2f7-cd5c9e52398so146560a12.1
        for <linux-mm@kvack.org>; Sat, 10 Oct 2026 00:59:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1791619149; x=1792223949; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=JUYV9kBM40++h+Iuf/kFSxpEvNiJz1Gg8/l7n+m9rxI=;
        b=U+gT2Q8qDqm8ka/yJixzUjXmO7hn/+QxNv4THanXxF9tIfZZMHBmhnqRjcs8i+Qf2L
         ltkCQKZ7W7+YTuegwIvmz4pZaxcN64ljnv+3/83nuDboRcyJQR193iKNpeUK5jJbOfTo
         E+WSZhZupWd9AgQ7JGCQ+5hxc1R3x9iQmG8/yYSz9jLhDI0EZ9yo6cULtXUY8VF2icxm
         GcavON/QTVQL8rFOMoiXax3DJOcaNsEfsJAaW6pWIKO8lNyDwWKsA9m2mr8fntFr/kq2
         rNZKawf9PqjR30faZLv0Za2qq9H9bnhLcbhJ3KlpS3u9d82pveR0Tni09a6EJEGZwvQr
         Ninw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791619149; x=1792223949;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=JUYV9kBM40++h+Iuf/kFSxpEvNiJz1Gg8/l7n+m9rxI=;
        b=dHzwwW5lfTAcaOPuf8hTIUl+HHXaoX7xsMNBqTLPGROCmZ+1SV3bn9C9VnQSXSs5sR
         two6oDZJBPI1QYGwqEsD70/3gijHg3bWGmUAcRpFCpaE4WrQs5Lx8PdRpr8UDGNRq1ZZ
         EmUzG2laeGJplm8hVESA7yM10vUYI2smCQnX7xc1alk6K5nYEzxWfdNO3rU121Habud+
         E05VCnVBDu2UzBlSYQ8RHkkvUUAnzUQo/tgk7UQFEjdsqBiFGeZWu9ns+2ZvTCdTDH6v
         LsxhP5TbJbFr8oXJ/0GtjlAY4bPCLf8ZYJowSKznovNjoBplILn5aWm7S2VrrKKmPzlZ
         o+rQ==
X-Forwarded-Encrypted: i=1; AKwUvBxjD3qfknWf6Yr5skfvIYHeXXD+8f5IwH8L2WNP00QZcjuHkUcpNqtuOROQ/dvlnxN9DBETVzQbbQ==@kvack.org
X-Gm-Message-State: AFq9FYKOtvZBZK7lYFH4lpZcoCMT/1TjBB0aTjw47xUKOBjD3oqBQDty
	JNxjweF5cCs0i1q2YiG/Nahtml7xt8Z1QYNhoCKcjMv2EpweXWOAn1EmcP/n6ItxfVaQypLFv9C
	U0IEdKwk=
X-Gm-Gg: AYBFou1XXvuf35KCL0yNFC8nZGGQB4TW2g2kpVg31DzcDwQvwI4bf1XUjs2Ae6ReIAs
	/YEFA/SZg6ze4AGNtN6w2xZi/zAdjQrfyRgphHm6LEvDPwW7kosdJ66oNX6BqDcfPFnMy128cv/
	EMGF3rnlWcFAPOKEKO6Zqmiataadq6PPTRMDiaN4gTNeKNq6Lu2vR4GQIVeTp4Bk1afFo/KuB3f
	gIYxaC/UUuPLg1eYqZvvud6P1uU0BoaAarQXML/I3IkZVMQCtUwO6FBMYMjJE6o3VaceWZ7YwTc
	wT67fIhCpJFI5UIbltCXdGy7Tdmu1wl7wXpLLx/BFS/Ca+0SYC3zYcIwbmXPd524ffdzwankN+A
	D6BY0fzIRapfGMpvT5dR2tMX9vdIK3xbXcezZ1EOoDQ0hribDpS5gTzUreGXSOz5iXoK85fZxDV
	9CF16BHGd61xQpt+fFnueRV/yRJcixKoO/2bWl2ChWKUg1xYughYOf/SYPJbmrKUugrznn++JAz
	e7QKfGLfF1npT6TM4TP5PNFzDmndnP232GdYA==
X-Received: by 2002:a17:90b:2d86:b0:3a7:d2b5:2e99 with SMTP id 98e67ed59e1d1-3ab3a60d1eamr3205394a91.20.1791619149216;
        Sat, 10 Oct 2026 00:59:09 -0700 (PDT)
Received: from G6L4RL2QG9.bytedance.net ([139.177.225.249])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ab57c05724sm3473569a91.4.2026.10.10.00.59.00
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sat, 10 Oct 2026 00:59:08 -0700 (PDT)
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
Subject: [PATCH v4 5/6] mm/sparse-vmemmap: open-code vmemmap_populate_address()
Date: Sat, 10 Oct 2026 15:57:54 +0800
Message-ID: <20261010075755.83339-6-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261010075755.83339-1-songmuchun@bytedance.com>
References: <20261010075755.83339-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: iws8rorjfiy4juirqo7xq9koaijn38cm
X-Rspamd-Queue-Id: 7705F1C0002
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1791619150-288069
X-HE-Meta: U2FsdGVkX19fr9orwkqWCIg4peY0WnsMa9im6O3nHdJ0R8TjM615pwan1UbxUTYIF/WXCu75+zSQD49sOdA8tXUf96AyaLttsDdcJEQEplUIMwl533WZtvQWob6IilLLpaGyWbzCRtNzB0Y5XqAdFCQgTh8u01Ugp8ewGKkSTimg1hDdjNobAox+8KLAwMXYzneFoKRszA9I32px/qczmxjw/RW7eHkA8pvQGV2BrJKjpUtCZ6wx0/FscpliJIpQqXnL9chBHNOWsL16WomxRiRGPiDU1h6ftscumddabWvketGU9XdTwwcCxgwMjyaVnsVTcI9OaGtiwqwjjv8HY6d3qby4sg6Qb2+hPHarvgLzKsYL2RmS97Dwe7rQIr5I+VuRlHc/aGyivdBb8SZiVUwwaeZ/ePBb5xswCecXJc71/8uOWUE/jfOOXbAKQt16lSxyNEimXgq3vTf7Y1H3UQiWa0wpWtSu2PFTYAKykN6nJ9zRtWH/Xe1cFfKxPANLQTkhVeNw+0Rad/gb6rDVX+AcHBOwDzABhDnW9nXsSAv2uCxvmq75JdTYj15/PYWPkhMRIRAG3viOs11ocY000cpdS7FONggkC2E9xPH5Bz1X5h8+MCyZxVCDKl+A1o/42b12/hiRTmw0d4LFD7P20TiNGRraHCNELtco8tH7bMSCFahH9+r4MxREKcy/3LZ6KPJRZAfJ7AkCpgm8LHeVWuTwzsWJ4yuusr64ZhajOjlk2JOhnat1TZl8F5B0zE3HjM2rxpJqaIt8vkYE8/1xDvvs1UZ6mVZprhAUdE0XCUZoRa6JVMKVt3gfj0TrqUUtnNg+mPp0Z3PrJEWVkFh4IB/ofg5Lzh3ENHSFKSY3l4sn50f0gQ7oKYOL8UHSom6kGZywq/NscVz20GRuo+pn4PXYcGQ519ZiBOrFBWMs4sTxbO+Q8oSaSdEwGV3tHziAAQMtw0P2s8pqScRVvAp
 eRGOUwra
 gHu7uGsRnZgyD8mBBjLMU06JnxQ1vc1TcWwPQ/F+4vc/77PZyCrXYW9RXBKfANORcNcgc+TrkWfI0/NiFArDZsthOEedXY3FKK2nzaOqbSEJLYw7ae3NpyMso92S/6KJUrbC1jG97HQ9FGsEAJvGZX2wKdq5B02hgBOhZ7960XKDfiF4o+/9aM23T8MOQELIDHRZ36LiCRIZ0pGx2OKhwpPJBmRb03tvIwTK0hxET5oc1J2Jyp5DPhg25YjAVekBiqcr7Aqkwc+i7+bElCYuTf30AaepOkJpYjrSy0hG0c8H2MZqkILbD0lGcId5VSMHmbNYHgLTpv4r6iF1moAS5vZsN0xra8NdI5q+y9ocu7KEUBTId9LmLytwlqSu1sBfgd0+DFXcGRmzLs1QtXyfcKV/ZobME0SGPjdDEFvSX6lFlM37Y/4HbE6N3+g==
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
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Acked-by: Qi Zheng <qi.zheng@linux.dev>
---
v4:
- Collect Reviewed-by from Lance Yang

v2:
- Collect Acked-by from Qi Zheng
---
 mm/sparse-vmemmap.c | 54 ++++++++++++++-------------------------------
 1 file changed, 17 insertions(+), 37 deletions(-)

diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
index 07188cdf00f6..40eba70c0048 100644
--- a/mm/sparse-vmemmap.c
+++ b/mm/sparse-vmemmap.c
@@ -352,8 +352,8 @@ static pgd_t * __meminit vmemmap_pgd_populate(unsigned long addr, int node)
 	return pgd;
 }
 
-static pte_t * __meminit vmemmap_populate_address(unsigned long addr, int node,
-						  struct vmem_altmap *altmap)
+int __meminit vmemmap_populate_basepages(unsigned long start, unsigned long end,
+					 int node, struct vmem_altmap *altmap)
 {
 	pgd_t *pgd;
 	p4d_t *p4d;
@@ -361,48 +361,28 @@ static pte_t * __meminit vmemmap_populate_address(unsigned long addr, int node,
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


