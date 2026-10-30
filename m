Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DC9E3606A324
	for <linux-mm@archiver.kernel.org>; Fri, 30 Oct 2026 14:08:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=google header.b=Q1AzlaQD
Received: by kanga.kvack.org (Postfix)
	id ED67E6B05B1; Fri, 30 Oct 2026 10:08:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E636C6B05B2; Fri, 30 Oct 2026 10:08:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D28506B05B3; Fri, 30 Oct 2026 10:08:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AB7E96B05B1
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 10:08:39 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 20ACD806B0
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 14:08:39 +0000 (UTC)
X-FDA: 85379473158.20.C7EB53A
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	by imf12.hostedemail.com (Postfix) with ESMTP id A1F8440006
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 14:08:36 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=Q1AzlaQD;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf12.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.214.180 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793369317;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZM306HbMXxWJth45MNpskHOeaLxazIrhxWXy+ExQUgY=;
	b=Zyo6ZjUWcrAvEj4vvbzR1wgmR/vKbGQKKvEK2ITTCY28BGZlo8fZzsGduAOGz0BpFk7wg4
	x1HN1k8Duj3aFAKeMpAk+ntX14/UWkoXCj/s55yc4m03UnA8BqD18FKqP3xIJBgf4mzZpH
	/WACrlRMznmJUK0ZDgxhPYWAod4wY68=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=Q1AzlaQD;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf12.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.214.180 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793369317;
	b=M/4m1dMpIWUlpwkgwj4Wzq6ywMfl3YTN7gYkWLEBgJXsmTwceaJPiCWnQbwgnKU2RIXgJR
	GrgTfucOMCUf5FXGLBgz0bihYB/c9o8V/C43l3uoLSkiZ4h1JPU7tb1r20ADq/gR7AasA3
	FpOyOwSSCtjYuFyA4L0oDk0WFIRflHg=
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-2ea7987517aso5617035ad.0
        for <linux-mm@kvack.org>; Fri, 30 Oct 2026 07:08:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1793369315; x=1793974115; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ZM306HbMXxWJth45MNpskHOeaLxazIrhxWXy+ExQUgY=;
        b=Q1AzlaQDIG6FTa2Tf4aSjsx0W1W0sVs6kJMjjoSkWTCjMcKwJddqQD4Zj4dmm1zijw
         RITWNwVqX9RBj1oz1qyMciyA7/1fDSa9CKYU7Flz3EwoKSV68LhIHNSK337P5QmYtF1q
         iKo24iEgEut44zV8CWiv9X79Fb24c/z35c5+plhizYEZv8icTbTx7W7aazq/fGDT2bJ3
         kcJVqKa5pLsrXWGDyJnA+fwL24scagmxHjldnf+IqMpUQJAWNeZCePi/VLuHbgJ3LKYu
         j9MzuhojQ4RRblVA6yeHC/XtkIdQ8RSXTxk8jrlSADZCa4/JdP3gJK2LPzIgo6l+3Rij
         eoaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793369315; x=1793974115;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=ZM306HbMXxWJth45MNpskHOeaLxazIrhxWXy+ExQUgY=;
        b=F6bcnWi4NjdaVLdlA+Lq+VI1zhYfTOwEUWrD8CZlV5N5mz7xfQHNPebVcqZQzPKzvZ
         T22mpBPn81cf/B/Bp8iXBE7O5MkufpIyi2b/8SYqzmw1uSS9YyYuXZBX2jEx0B7MSWCg
         vqHI2KBMocUFplq9GVvaaZt+yds16UvoI0Y9aFvcooVgtivaB/hmeuW0ynZVqpwTuoay
         Wi0ct1C1WZH4jdvB/182sufd24HW/bsIJl4+iHqKZcwWF+JOfPkAQzL9SjZwiNKtXmHM
         rtr+Yjj+wfSreh0nGbZxiUN2lNBO0fO8enwalRautYx1i+GkcAGFgHZ0nn36xfAwkjxQ
         SnIA==
X-Forwarded-Encrypted: i=1; AKwUvBzJ7/XWaAOJX7gIDWEMZ3qYx64jxw2l6Cz7xhnGqqnmiyd+pGcP2DurLqbUIBGiZIamCU7mUGJPfw==@kvack.org
X-Gm-Message-State: AFq9FYIAWERHiJEUCyV/YM3tCgHH1sHBf/q0ZZh4AnwcRcVy3ZuqAkpV
	SAdCUCcPnPu1e/xVzDwfhsIOta8GjcFoh7d5aZiAk9PJFVXhnctWBfFMFbB/bonJ2Vk=
X-Gm-Gg: AYBFou0e84/oSo/zeEbqsNoGtOY6S3rF7T4GazXHHY3YFOvEIHBkujLVT79IYXrZn04
	WEtcWip+owHwDplv4ugJGxsRXwyjnIBp6B9eBbNq668l7K9EguR5WA30nx7mgV1S8/DO4WNv/4g
	dIe7/JaODN7SnxyMv+AXrXOT44bycrBY6KEJPaj2p0T7i8MUzRBSANlpdV1OTaTf+eDGGPjRWoY
	BApbgKjnmwE0ULMK7TmPyFwxaEoI3zOl7uqdZ6W1Rst10ZZFPtJsDpG3dlcJpQDhhTeasV8bXRb
	xiW4pkWcNDEG2fzFovrnTjPtk2BmiBULlXM5Q6h37e5LUdnfL49OInJbbdVesrsCNAjbur0AX5C
	758MVlZHtUYxzXDoiy5Vi16wGWRP28O3+9Wkr2dwZHL4E0RDXQzKBfyzul3FhsqesiZcYpcROdP
	FKedriErVkr05ab8Qgfg0JfNxp03fBCfF5T/kthvJpGsgU8Yj+jhnowWj9DgC9nz7NoUxQZktga
	N1mS/+qTL2n90NfXCh5+/gGG/CShwhjBsbv+TLXvxCaP61A1S9u5Ixg3t7n6ip5w44ZF4R1AEG2
	M6QAuiNUAA6M/81lXmLrrWh+UrtsKVPOAtQU7wVFerIPo1+/xME=
X-Received: by 2002:a17:902:e5c1:b0:2d6:e9f3:9305 with SMTP id d9443c01a7336-2eb36414ef0mr26789535ad.5.1793369315295;
        Fri, 30 Oct 2026 07:08:35 -0700 (PDT)
Received: from n232-176-004.byted.org ([36.110.163.100])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2eb3929b27bsm7601795ad.62.2026.10.30.07.08.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Oct 2026 07:08:34 -0700 (PDT)
From: Muchun Song <songmuchun@bytedance.com>
To: David Hildenbrand <david@kernel.org>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Mike Rapoport <rppt@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Lance Yang <lance.yang@linux.dev>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <chleroy@kernel.org>,
	Ritesh Harjani <ritesh.list@gmail.com>,
	Shrikanth Hegde <sshegde@linux.ibm.com>,
	Oscar Salvador <osalvador@suse.de>,
	Qi Zheng <qi.zheng@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	linux-mm@kvack.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-riscv@lists.infradead.org,
	x86@kernel.org,
	loongarch@lists.linux.dev,
	linux-s390@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>
Subject: [PATCH 1/4] powerpc/mm: make vmemmap_populate_compound_pages() static
Date: Fri, 30 Oct 2026 22:07:17 +0800
Message-ID: <20261030140720.1256062-2-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261030140720.1256062-1-songmuchun@bytedance.com>
References: <20261030140720.1256062-1-songmuchun@bytedance.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: A1F8440006
X-Stat-Signature: gzpbsbuuuzprgwgb6b6zy6hbuejm1oau
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793369316-273943
X-HE-Meta: U2FsdGVkX199VvbkVhuw6SSIEkq8QAVv3UWP5VZEtd1ZDDCN522lZom7Ixv3NpRPknDuup212v+1M1mC59GPwPkhfgf0CaWn8FBJpETxnuMa0eqr+5bSME7rlMtPJDPy6/tAUZKbubKW+LFSm03wXsz54Si+NWcLNLh4HcFzs8bBhuj0iutq/LI2e8DPqeR73V+Z3dAwuXUgs4b1VffKjuqZKFp+CPWIwSiK7+x/+ZDgi6ciubuhOGssELma9tHTxTEpjh73nFTWwETMGLr96ajWZkVQiWhwfRQj/0mC5Jz+GTz9FEw2B0ApnOuJ6XruQZ7OtietYqS+8VFpPyq/3yeLO0Nh7JgqgRVrQs1mMhjd1PlRh+SODDI4UvsCnLaL7GuKLMEYuc+A04RCPcm1X3Rla9sa9TjZvqHSeamQjtwuBmIwSn7id3GqHTdDgxoBZNHWs8TsmjV2Fs4V+QW59ZUFPUxQtRkHaQA9JjTdiljo+aGLyBNaZXuRV6nLPY0qMh58OMq25913qfHJCGZYBeizgyCUB/Uhs1+RTPasnYR+AGGiwCuCxpee2mlMAsTO6aEdUw9XV9pUhnbS0YsZkEGW2/XF7Wl2WaqmP0LsUEkYRzioG2d8Pt+bb9YMBX07SAoHN5dP3pklU7ts/s8NjOjEzxpw7F8j6Y1J9gb5qASMMuB52VBTViWF8OGQNxOGuACqXylgVp2bAqVAUC2fcab1Erwpyd7E8OQXh5muqaUa/La/xIUVjkoLLmYFjym0Lq8IpXoLQvBIlUgtM2FeZJom23uPFQnhq9kRkgchEj69GXehh3lTFmQacnu7rqGIiErW4UUUGWyjJXbPQRGKE+iDh8Bhg05zOXBl3sJBco95gqjRB3Hy4y+E18xxAHxTJfqf+9FdFXvzTD18I0FCdN5r1o3jDbBM7jeyGfPpwE3ahRabJ/IqV5HkiE3wjo+ozt8m2whuZNkluh8/NCo
 Ey1Z/bfi
 H3vMiOeIoQqxwuc+KVERt2hyROljHlcKZ9PQjfBCtCDuMUtlWHTvDFaT6P5I9GLCwg0Bv5snsmJDMDbKM1nxtLQjbha5zqgJ4eJT1qbvEfr9FrwhOmAAabJHx/dBWFjvshgpEiMcNwVONRaQtVut+H+dZdui/ZxkW5d2GI0maewZg6FqpgxzdYDTpXYgdbIN3MWjncqBS+H8nGsG7osDqS5wwOE0w4zb6grRF8fbPBOrGgW/6ba6C+WhQMVqt/fGJqA4b7OiJbeacAsMiEs5xJjRCI8TSLp/yRGLKuvfYy8hBytDeLCTS/bZ/TOke7nT1hFsjuNfZ9VriId032vGppFK/dqHV8+fAjH/mPIgQ+Ls8Bi3HfTF4Q8WKZ5YqnREO/Dvwxdh8sOMUdNN8Hl7QfVStwrPnGL14Mwx1PGA0TzCIRri12M+7HOyZaA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

vmemmap_populate_compound_pages() is no longer used outside
radix_pgtable.c.

Make it static and drop the unused dev_pagemap argument from
its only remaining caller to simplify the code.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: Qi Zheng <qi.zheng@linux.dev>
---
 arch/powerpc/include/asm/book3s/64/radix.h |  6 ------
 arch/powerpc/mm/book3s64/radix_pgtable.c   | 13 +++++++------
 2 files changed, 7 insertions(+), 12 deletions(-)

diff --git a/arch/powerpc/include/asm/book3s/64/radix.h b/arch/powerpc/include/asm/book3s/64/radix.h
index da954e779744..8452a2714cb1 100644
--- a/arch/powerpc/include/asm/book3s/64/radix.h
+++ b/arch/powerpc/include/asm/book3s/64/radix.h
@@ -356,11 +356,5 @@ int radix__remove_section_mapping(unsigned long start, unsigned long end);
 #define vmemmap_can_optimize vmemmap_can_optimize
 bool vmemmap_can_optimize(struct vmem_altmap *altmap, struct dev_pagemap *pgmap);
 #endif
-
-#define vmemmap_populate_compound_pages vmemmap_populate_compound_pages
-int __meminit vmemmap_populate_compound_pages(unsigned long start_pfn,
-					      unsigned long start,
-					      unsigned long end, int node,
-					      struct dev_pagemap *pgmap);
 #endif /* __ASSEMBLER__ */
 #endif
diff --git a/arch/powerpc/mm/book3s64/radix_pgtable.c b/arch/powerpc/mm/book3s64/radix_pgtable.c
index ebac5f9058f6..2924604fbb38 100644
--- a/arch/powerpc/mm/book3s64/radix_pgtable.c
+++ b/arch/powerpc/mm/book3s64/radix_pgtable.c
@@ -1117,7 +1117,9 @@ static inline pte_t *vmemmap_pte_alloc(pmd_t *pmdp, int node,
 	return pte_offset_kernel(pmdp, address);
 }
 
-
+static int __meminit vmemmap_populate_compound_pages(unsigned long start_pfn,
+						     unsigned long start,
+						     unsigned long end, int node);
 
 int __meminit radix__vmemmap_populate(unsigned long start, unsigned long end, int node,
 				      struct vmem_altmap *altmap)
@@ -1132,7 +1134,7 @@ int __meminit radix__vmemmap_populate(unsigned long start, unsigned long end, in
 	unsigned long pfn = page_to_pfn((struct page *)start);
 
 	if (vmemmap_optimizable_order(pfn_to_section_compound_order(pfn)))
-		return vmemmap_populate_compound_pages(pfn, start, end, node, NULL);
+		return vmemmap_populate_compound_pages(pfn, start, end, node);
 	/*
 	 * If altmap is present, Make sure we align the start vmemmap addr
 	 * to PAGE_SIZE so that we calculate the correct start_pfn in
@@ -1228,10 +1230,9 @@ int __meminit radix__vmemmap_populate(unsigned long start, unsigned long end, in
 	return 0;
 }
 
-int __meminit vmemmap_populate_compound_pages(unsigned long start_pfn,
-					      unsigned long start,
-					      unsigned long end, int node,
-					      struct dev_pagemap *pgmap)
+static int __meminit vmemmap_populate_compound_pages(unsigned long start_pfn,
+						     unsigned long start,
+						     unsigned long end, int node)
 {
 	/*
 	 * we want to map things as base page size mapping so that
-- 
2.54.0


