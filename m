Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 04F5BCD8CA8
	for <linux-mm@archiver.kernel.org>; Fri, 12 Jun 2026 03:59:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 63E086B0099; Thu, 11 Jun 2026 23:59:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 615926B009B; Thu, 11 Jun 2026 23:59:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 52B016B009D; Thu, 11 Jun 2026 23:59:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 43D4D6B0099
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 23:59:45 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D0A211C3A38
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 03:59:44 +0000 (UTC)
X-FDA: 84869906688.15.DE34660
Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	by imf02.hostedemail.com (Postfix) with ESMTP id EF3E780008
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 03:59:42 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=L+Ra8xf3;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf02.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.210.176 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781236783;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dEbLew8Y02WMzZJgEmHXqmt5ZtOiSFYiY5ZmDDudBcc=;
	b=KTYFC7r1uqZLXfYr3ph8RSpPn/hS+Q1DHrsMSgsD17cQdnMnJbcN5IC2txSgmQd88TiPE0
	X6Kwo9Cz59ld5bujOlR8gK4zmexP2bbk1dpVtzDSnWtfcngLAs1Zc/nmm8BI09gqQpn6Nc
	RkFKGE3p7/fVMlnArzY/sCKnMJC+gOY=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=L+Ra8xf3;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf02.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.210.176 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781236783;
	b=PqdJhDdZ0wLPQmgqHEjMwcIIHa1/QBzG4ZilrQ0AOrAXHllsX3xsQC5i7mHPV4ikOOf6m0
	OmrLVdG/THhtv6nItHv5e1V01g1g9S+ZKdAXE1WC2I9BryZ2Ga1wIgwpi0sP+fIM8gStbT
	h1ZR5v2dETjlCv5/uqObSq+hB1nm69Q=
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-84234c83142so280954b3a.1
        for <linux-mm@kvack.org>; Thu, 11 Jun 2026 20:59:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1781236782; x=1781841582; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dEbLew8Y02WMzZJgEmHXqmt5ZtOiSFYiY5ZmDDudBcc=;
        b=L+Ra8xf3WM69pjaRsLHzZ9nzGgXQYwwcsQfi8x/FOg/0aXmG3p8e5BJOUYHm8rdXUK
         AO3ET6E4fs8M7c7oObY5ztFH1UW7YQ/voaN5rsCScacaQP2rw8x6rqAgbvfFv4JkUcev
         8sBjZE+J05AmFpdXP9BvGO/BycUdcmfn0Z6KiaMxWYg7/4HQwGyM/hMmLPWVxBnddhCn
         LScYuBEO17I+/826qpmMKpWYEvkhz3UrE++Dj+C4qKpu5mYW7jGaWst0y2ON0ogfL0Rm
         VoSJ5tjfQ636bmb1YDmWhntIIAsXxhSvXCOwq6M85thZj5sPJ6KlSTGOOrhgNXsXe9W3
         denQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781236782; x=1781841582;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=dEbLew8Y02WMzZJgEmHXqmt5ZtOiSFYiY5ZmDDudBcc=;
        b=HUggnlbRjF87cJ98ADwwSIObQiuQvu+eZlQTVoQbyda+tqnUF+AffjRCDFO1Ox+Yxr
         9b1R31czEfMXYDJQpGNyMIJo3ex5QAL26BiBcXo6lcS+fjD28nG+rRznw5L2EcsgMXTV
         KomA+5rwFo829XE0Q75WOv/JFZmWZADGIc8y63PXmXxfZ9T99F4svaVHZ+TzzHITjsP7
         m9RodoZD721nl1OoeJy7hek5ZypSP8Xz+livMj86Vxrxc1Anpepa1DVK8cw/Rt4DbyNK
         yYtFQMkqU23e+7J+LBkpg7wETgU0jcGZQiFZgofOc0HSL3eUkyHu7G8uM2fbaP7+PcJa
         z9HA==
X-Forwarded-Encrypted: i=1; AFNElJ/+Dve+uf+a7jgqR7jwEoEwUAa0f/EFX9wKQbfLRe4FSQr8tP21DKl4VDVzSdIYsSWStWVqKgaP3w==@kvack.org
X-Gm-Message-State: AOJu0YzVhwUSzBbvYwtoYlKd80qqi2gGgHtivUp+7M/k6jAGMzKsL1ls
	IMybbzlDdx+PHXHWouXcDbXOn69MVsaveBkPSOa6/BESRKWiJuZ0LpKD9mn1LddF74E=
X-Gm-Gg: Acq92OFBbrbhFP0kJdVmJdsRKo5k5rR3FMDS7fryY5pLPwTy6eJUaM+m0tcnlhqox9L
	qYVz00p7KzP1RRvOXub0Yn+/HBU5Dd3PHfrHLILTnN0W1x1mWdu0NQdbx5ZZkcp2VsziZUCBT5g
	f8VfXA5pmqe/Vilif2BMnYkxCoPdOufox4gVUO0fo+2fo98zuUIvZ3ZA0knFbz9UcZKrYtXY5Ij
	pua0luUFHWz3lGvNMZ8Qg7MsCdpYzapMUVbm+VQSfeMmWc73rO7PPnuk5wef0ahTVJtkYnaGrfd
	ACFDSULnPqKnooNY4lr1+stgY6k89q0t3lpFECijsAJT3Id9FxBYUjbJKZ9kxiL0zwXPSHJi8i/
	88j21d4fSVHizTw6BLoPhx5pDDhTxhM0etOwxGJG72+ScvHtsRXH97N9mDTjFV8VLhOL2TDJT8H
	qSAGVFSST6tYVe1zTNKmbjs6ZcLtC9PqSWsU+eJja9tco=
X-Received: by 2002:a05:6a00:f95:b0:842:4a39:6047 with SMTP id d2e1a72fcca58-8434ce93db8mr1116163b3a.29.1781236781794;
        Thu, 11 Jun 2026 20:59:41 -0700 (PDT)
Received: from n232-176-004.byted.org ([36.110.163.99])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8434ad03fdcsm643352b3a.24.2026.06.11.20.59.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Jun 2026 20:59:41 -0700 (PDT)
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
	Muchun Song <songmuchun@bytedance.com>
Subject: [PATCH v4 06/19] mm/sparse: Panic on memmap and usemap allocation failure
Date: Fri, 12 Jun 2026 11:58:50 +0800
Message-ID: <20260612035903.2468601-7-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260612035903.2468601-1-songmuchun@bytedance.com>
References: <20260612035903.2468601-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: 9iapzfrn9fmdmfng6inpxdae3p3anhsf
X-Rspamd-Queue-Id: EF3E780008
X-HE-Tag: 1781236782-825493
X-HE-Meta: U2FsdGVkX19HMp1ZgPl9XGW66u1dFAbeBvMzmwj/UmTcs53frIfrdvPdot3BGTObEgpORT0/qu/ba4CfOGzc4zYRA72X3eBN9j9Bx76RhWaURb2SbStDJ0WPXGXGiZ+C6kmOW6lJy+CDq6ztWk95DUJ4Qhq31e/8B9AaX4U/ty7rBv8tTkp4gwHQpauQ5iCPnZXE/fhBG8OWbar0dKZ2TA06nmpURXGpBYrZKjVtz7uGI7sVEZ5kRTJwbsgjdVTcWHBMFr8JdWwcmVdySwYtUk9hrejHI5SMIPsZh9OToZ6v3u7uJP3nFLhWvSUR2i8fGUpFrX72hCPZ/V6BLurItlbGK6xKqnWEITCAt0/Wnmb5vQgsGojQ6rGnq0oKpxLKpRn9pegNSonRRnr1QOiKxq1llZ3LTf/z9KMVrEMImGtKkQueYo7fpA2KukgZQD39toai9gQ5py6Kfj4+BG2IAVjExUCxFvmPlkJfzP6Ht7sMQFc0f2EJaZ6zLJPnzL5ggDjllGfTcdTv2pnB6kfItqix989Jtgf9B/TEmwPpf/4Q88iAc+dY75eHR6EHGxNTHb3iYaSbZYMV3KepruKCqKxOiom7SSRw0hzlL+q5l6PAOwLsCaElcRegsOrIde03gBNVvErtNWsh+5QEzAH/nSGJziABf1faszbR6ItYDevbiddrumrYdy08nqBXZgged1vkkTgqw17d4dcTx5gDCyTyygxRSfWZjyOXhOeB7ow5eiGSaFsbMWSiNDtzcBDHkLK1D/lIhDTKa7UtlHDGipN3tPXYCXFnSpyJWsBt4rv7wLIm1FM7mgZZ+IDXcWGtj4tH1qg7Vah+tjikxwPe7CfTi59sbcN4a027npQXz5UxDad6TWeoODGfnujFlJi37neCHzgalJGdQq4d0WeCUSTXUK50LqqrGhrTJwPprr7APQYCN3nyhsp8HPV5wEyEdjZ0A2pyE2FwpgTVMsT
 JjQ0qnQp
 Php6OapDrHcDENGHprMy0tTddNjUCS393oKZQjQPw6dT7ZjPkQliP6AGFRCCANLWvVb1iyghTqKpvvoiinR1HSOVPQyn3mY29zQbxzSgGaksdC7xsUKreC1vwkwzDgBLlwQaWzAGcp8mtyoO/JzHP7sBU75OIazAX7g7ZGVlbq+DMlP9iWL2BZFmZySW8HngP79gmOqE8AaYYZfo8OdjRyGUpKwdwqYz3jp6WNrukhfpl5OsoowNMYlgFwKbgUQI6RBftgQzZU2ca3mfNnAWDd508FUfsinh5SwsiDCvmBGEETk1wztKP5oU8pOCWAZjOBHCNVP0+nu4TJNg57rhHtxygIeiosq7PtA41uXCIuMNEGM5lSlzJrkrclzCFXvBB/LqSMI68Ds+Ffk5UKzMd5ej1EU1ApGbmzYrD
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When vmemmap or usemap allocation fails, sparse_init_nid() currently
marks the section non-present and continues. Later boot-time code can
still walk PFNs in that section without checking for this partial setup,
which leads to invalid accesses. subsection_map_init() can also touch an
unallocated usemap.

Auditing and fixing all early PFN walkers for this case is not worth the
complexity. These allocation failures are expected to be fatal anyway,
and other memory models already treat them that way.

Make memmap and usemap allocation failures panic immediately instead of
trying to recover and crashing later in less obvious ways. This is also
consistent with how other memory model configurations handle memmap
allocation failures.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Acked-by: Oscar Salvador <osalvador@suse.de>
---
 mm/sparse.c | 44 +++++++++-----------------------------------
 1 file changed, 9 insertions(+), 35 deletions(-)

diff --git a/mm/sparse.c b/mm/sparse.c
index 16ac6df3c89f..c92bbc3f3aa3 100644
--- a/mm/sparse.c
+++ b/mm/sparse.c
@@ -239,15 +239,8 @@ struct page __init *__populate_section_memmap(unsigned long pfn,
 		struct dev_pagemap *pgmap)
 {
 	unsigned long size = section_map_size();
-	struct page *map;
-	phys_addr_t addr = __pa(MAX_DMA_ADDRESS);
 
-	map = memmap_alloc(size, size, addr, nid, false);
-	if (!map)
-		panic("%s: Failed to allocate %lu bytes align=0x%lx nid=%d from=%pa\n",
-		      __func__, size, PAGE_SIZE, nid, &addr);
-
-	return map;
+	return memmap_alloc(size, size, __pa(MAX_DMA_ADDRESS), nid, false);
 }
 #endif /* !CONFIG_SPARSEMEM_VMEMMAP */
 
@@ -300,17 +293,14 @@ static void __init sparse_init_nid(int nid, unsigned long pnum_begin,
 				   unsigned long map_count)
 {
 	unsigned long pnum;
-	struct page *map;
-	struct mem_section *ms;
 
-	if (sparse_usage_init(nid, map_count)) {
-		pr_err("%s: node[%d] usemap allocation failed", __func__, nid);
-		goto failed;
-	}
+	if (sparse_usage_init(nid, map_count))
+		panic("Failed to allocate usemap for node %d\n", nid);
 
 	sparse_vmemmap_init_nid_early(nid);
 
 	for_each_present_section_nr(pnum_begin, pnum) {
+		struct mem_section *ms;
 		unsigned long pfn = section_nr_to_pfn(pnum);
 
 		if (pnum >= pnum_end)
@@ -318,34 +308,18 @@ static void __init sparse_init_nid(int nid, unsigned long pnum_begin,
 
 		ms = __nr_to_section(pnum);
 		if (!preinited_vmemmap_section(ms)) {
+			struct page *map;
+
 			map = __populate_section_memmap(pfn, PAGES_PER_SECTION,
-					nid, NULL, NULL);
-			if (!map) {
-				pr_err("%s: node[%d] memory map backing failed. Some memory will not be available.",
-				       __func__, nid);
-				pnum_begin = pnum;
-				sparse_usage_fini();
-				goto failed;
-			}
+							nid, NULL, NULL);
+			if (!map)
+				panic("Failed to allocate memmap for section %lu\n", pnum);
 			memmap_boot_pages_add(DIV_ROUND_UP(PAGES_PER_SECTION * sizeof(struct page),
 							   PAGE_SIZE));
 			sparse_init_early_section(nid, map, pnum, 0);
 		}
 	}
 	sparse_usage_fini();
-	return;
-failed:
-	/*
-	 * We failed to allocate, mark all the following pnums as not present,
-	 * except the ones already initialized earlier.
-	 */
-	for_each_present_section_nr(pnum_begin, pnum) {
-		if (pnum >= pnum_end)
-			break;
-		ms = __nr_to_section(pnum);
-		if (!preinited_vmemmap_section(ms))
-			ms->section_mem_map = 0;
-	}
 }
 
 /*
-- 
2.54.0


