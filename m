Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DD738C9832A
	for <linux-mm@archiver.kernel.org>; Tue, 29 Sep 2026 05:33:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DEA476B0095; Tue, 29 Sep 2026 01:33:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DC17F6B0096; Tue, 29 Sep 2026 01:33:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C89876B0098; Tue, 29 Sep 2026 01:33:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A6EE66B0095
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 01:33:28 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 3221B402E3
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 05:33:28 +0000 (UTC)
X-FDA: 85265682096.16.FD6C8C9
Received: from mail-pj2-f43.google.com (mail-pj2-f43.google.com [74.125.227.171])
	by imf13.hostedemail.com (Postfix) with ESMTP id 2DA8D20004
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 05:33:26 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=gLEXeOgp;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf13.hostedemail.com: domain of songmuchun@bytedance.com designates 74.125.227.171 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790660006;
	b=c0HRmc64S/3eqNmOr/ndBtibRtJblTCSNYh9b/DQw8HYKpiI7Wd2Q4u9rA3yJo+IBXSORz
	SLOiqGzvkPMCoz5ztJe5jJGGretalR36MTn6pKWsYT5z2o7foBJwN01qyY297XX5SRPFQW
	0KQsHbR2HhbpY0BsSDUkjYDPLHOouwU=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=gLEXeOgp;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf13.hostedemail.com: domain of songmuchun@bytedance.com designates 74.125.227.171 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790660006;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EmCovH5RnTA7rUGZy7nldketI90h2YRpy62dJPhw5NA=;
	b=VIOADXVDKWHL+SvJtHYaE/Zn+JKplF4sx12KhGObWWDlDhKWW2dBeh6Xq914yzb8DpoNG7
	mMfueZqW8rqADiZtbh5ECSNBSDjQoAi4ZnTbjN797MA+ocCWqtcDRhjl9T8FWofds2pOvb
	zZYu+1IDjLAy9nhXF8bdGea8bZKSxPM=
Received: by mail-pj2-f43.google.com with SMTP id 98e67ed59e1d1-3a49573b8bdso496891a91.2
        for <linux-mm@kvack.org>; Mon, 28 Sep 2026 22:33:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1790660005; x=1791264805; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=EmCovH5RnTA7rUGZy7nldketI90h2YRpy62dJPhw5NA=;
        b=gLEXeOgpukrg+ZE/cHEHEf0SRT1FoHLaxjHO1bs3dk+rhbURWt54G7Fme/VMEXR6kl
         tLipnuVAukz4OYRX3lZRTCXpGxkE2ZXZbQRiUmHVYOX8FZuUZX0LjMNBwLv2yCBjSc0m
         fnbxrhvDvWqqFiWNjRWFPAv6Xenu0a9A3gwzFTQXDYwO6208d0qbnlyhiRGborj8NrUk
         pug0MT6SsirWGDAWUsfN+3bNipbxbETmtJkP8kEOmrD3DXWMrMj2m72AOxm4ew06o449
         bkAGq7F5jUlxqFezuWULFAJj6HY/Qo0cM5NLnm4nS28n034cR+VHUtrhtp8K4Yp609dK
         tCfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790660005; x=1791264805;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=EmCovH5RnTA7rUGZy7nldketI90h2YRpy62dJPhw5NA=;
        b=FV85IV+/mX4UBBhTP6ZNWd8idkZczXXd4l2Lr735uQPrE2H97dUG6mcRPYjw9wxXsX
         eDTOB1v+fXkpbLHx0pPmTv8pfG6Lp6aBUfhzh38vUs/4ruOayOsSG9ghh9rAMQScaR0V
         +2zs+jhVoYWlAo4X2NjlzYE6qH24/9f+gOsUgL01UC0qtVw6RytwiSpDkjNubidi/b/H
         schxCBOy3b2CRUNDPiCd5IuiJYtLRh9KomleaFh4x2nX+0/Y+LaTpRDF5UHRnTec9lla
         +P7VtjiQPK84WNgQ0zqu5nzovwkCBlgHaR8NqEx6uK25MxZIUAtPT/e1oVDEgZIhbJ2n
         Onvg==
X-Forwarded-Encrypted: i=1; AKwUvBw5PnOD1Wh7uiTLT4aHocz6yFC5OE0QypttzwM6dKlbbS/l8UmobYRbErmuNGSdDaSnnQbcEqyzTA==@kvack.org
X-Gm-Message-State: AFq9FYJICK2hEcNHmiqSiZRf7Pa6Im/06H17PUXSXl+gYnswpuwBlHab
	ACQdzKpE9obnrmyCJBzpVlT7BKSv2CYdTAq6vcwZnHbxafMMoccUgmgu9Y4pN9f1AuY=
X-Gm-Gg: AYBFou3Cc9uhDdCeee7dwodiNxL41IdWjgIY48Db0tgg9ywvvBaYbZdcdIeIrqPIzSg
	lz0b09vKtgPgEYucvcrWzka8zIrbULA87+t75sHO971PuYG4nEyOsbTFqpP+JxYTNE1WOjjWgmY
	UmwORu8hebN12tGEK3L7mFi6KtXIiQdumYJCRJQCrVyWMXU8+Beo0f7NIz1HHMm5LPEQfc1usWt
	2FzUsnzMgfrQxmgF5MVY4nhamDdIdnr4YjxfoakkKZsg7GCBzfMW1gST0nn43IpdVrI0+WIVTB8
	3Y9T/UDP7nfGG+FUuWIQgOybGdINrK30PWxqB2rG7V6hsi8VzgQ3Wl0Rqp85j0wrvTaf/4aofge
	JctqvFGyHeV3Wqxvf/fBpffy6fHMxceJG/4rLFPs9oxkvEAR/8TzM2yw1Cf8wHBVItHY8kOWNhS
	7UM86XCLfU340ty6BhI1Ap2wEiDdInCArqOk+YJsLQGZARZAaO7aydLHQSogCxkxIWkPsKD3Bty
	vZQ6XqFLWNfYBJYlZw=
X-Received: by 2002:a17:90b:2682:b0:39e:6a80:b795 with SMTP id 98e67ed59e1d1-3a0bb60b2f7mr9941647a91.37.1790660004661;
        Mon, 28 Sep 2026 22:33:24 -0700 (PDT)
Received: from G6L4RL2QG9 ([139.177.225.254])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2df9142bafesm49251765ad.51.2026.09.28.22.33.16
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 28 Sep 2026 22:33:24 -0700 (PDT)
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
Subject: [PATCH v3 2/6] mm/sparse-vmemmap: support device DAX in common vmemmap path
Date: Tue, 29 Sep 2026 13:32:27 +0800
Message-ID: <20260929053231.66085-3-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260929053231.66085-1-songmuchun@bytedance.com>
References: <20260929053231.66085-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Stat-Signature: tmn8n9h3ttqm1zf5op1psb9t8ibsiuw4
X-Rspam-User: 
X-Rspamd-Queue-Id: 2DA8D20004
X-HE-Tag: 1790660006-718421
X-HE-Meta: U2FsdGVkX194rOq0xGj5H0BVlrTHeRUWJt0IyIWWVfc/DbizKh3oISPRAF1vRgrDPHYIpiaJ57TvDLk84JtZcBtERDaHr6CnW/wC3sQkMOjTAN0sXIeJYosthq+7dUQoglP53s43l082QbJK8t8n+l4S0wgJgK2SXYqkYbiilRrvW9fx0q6A/i5z8HEAdYafHPQ7OXx8MVPm76fGmlKkcYzQc+Qa17Plf/2HkYhNRpv0u/+Y5rYFwPIIKz9IBDwCYMzWBcy8vVSpF1F1ng1RLYHIgKeX/PPiOB0Rg3MWCOtlQLsShbdCA+ilHx3cGpQB/YjVSARxHNBEneKqaIPJ656WxOiRRAERrzrb3TqOmWFZWvZKO75CkscVMabzo2mbRc7++jIPzEmyBAM9rzfVRqPnMCK/fB1REvkt9q5xENzmfcPJzHky0GiXtvGj4+B/DkBraUcdMXob9qYiRKdPG9nvkhw4gkzQbM7vffhQo6c73NyPGZyklQf1zqG8F0is5IEuFVrSkyKJA0jCcLBca4AxNBZ6Mqy8PamosRvKXgTzhaLu4IiwZXpAchfGjKEVM5gGqbLCxZeCwmcq/Z4lswyve6HjBOeDki9Hvv19eaXplMYhSSwqXlpm3/o7SM3ww8qZdCQIVxFZ4nz34kcgnO9hN0I4zMOis5hkdicSCGSJJx5tasFbEblxFAkgC4ViwR0dZGSYpozmcVm6qSqrm8f4EHRj6EKNLqQ/iOtllhNzbC6qZOKh/vYbKZerenoIuY0FMDwb3LI4HxF29zbS/t99uzuz4/nGM96+QI9ttta2SaXwB7zm0u9FaaQaAleIm3nWJkwe4we890yvRNq/mBX3NJmMtgLH3nkZE9v9OOx5Q7wJamoHmgFblURj5aAJNH2M9bEvRBTA29jgggKL/FpZwEaV6+59TNWw3TL5MUuOPsbD4/Nj1o5w3n9HQ0jmw3Z4Pw1p3LnsLjyk61a
 uwl2fHEm
 kXlT9EplEwSWFMoQlpSolFOZD6BU7FC/ciCCuLPFe2ZWH+rhMkO6FfRYsHXo/8eda/OdROy2irOi7zPPXkRLXVA3yrZz+E/rH0xLEaHNYkJuQrVO4jhmlcFCS4fqEtJPBDM/nHFfaN0UVEt0MSToaJeaI9z7hpYy8ZpKp+6Pxr/KQQ0HinP86yja+lzs7mhrlTsYv3C9ogDnN9ZW2dzjBLVoKhqSWltVCNkNfuQzTMglpE2qTkR72ksmN2KNdyYDANqOEGHJ0Of/yeqpgdofV6ZvyDRJd0hhN7TFvreBfhzjyGo8LJX1jqDzae98f+764KwmQEaLYcEWv+P3fkg1TM0O/MNBL4hhwCFKdWT0G8TlsIk/MAEzIjGZytEXI6/DtseRK
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The common vmemmap population path cannot yet handle optimized Device DAX
mappings on its own. It uses pfn_to_zone() to find the shared tail page,
but Device DAX populates its vmemmap at runtime before the ZONE_DEVICE span
is initialized.

Teach the common path to use device_zone() for runtime optimized vmemmap
population while retaining pfn_to_zone() for early boot. This allows the
same path to support both early boot mappings and Device DAX.

The backing PFN supplied by the Device DAX-specific population path is no
longer used, allowing the redundant lookup and population code to be
removed later.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: Qi Zheng <qi.zheng@linux.dev>
---
v3:
- Collect Acked-by from Qi Zheng

v2:
- Expand comments around slab initialization to explain zone lookup and
  page refcounting (suggested by Qi Zheng)
---
 mm/sparse-vmemmap.c | 64 +++++++++++++++++++++++++--------------------
 1 file changed, 35 insertions(+), 29 deletions(-)

diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
index 8219abc6c3e5..ee4c113ca938 100644
--- a/mm/sparse-vmemmap.c
+++ b/mm/sparse-vmemmap.c
@@ -237,18 +237,43 @@ static __meminit void *vmemmap_alloc_pte(unsigned long pfn, int node,
 	struct page *page;
 	const unsigned int order = pfn_to_section_compound_order(pfn);
 
-	/*
-	 * Device DAX still relies on vmemmap_populate_compound_pages() for
-	 * head/first-tail allocation and tail-page reuse.
-	 */
 	if (!vmemmap_optimizable_pfn(pfn))
 		return vmemmap_alloc_block_buf(PAGE_SIZE, node, altmap);
 
-	zone = pfn_to_zone(pfn, node);
+	/*
+	 * Before slab is available, vmemmap optimization is used for early
+	 * system RAM, whose zone can be determined from the PFN.
+	 *
+	 * Once slab is available, only ZONE_DEVICE memory reaches this
+	 * optimized population path. Its zone span has not been initialized
+	 * while its vmemmap is being populated, so pfn_to_zone() cannot be
+	 * used. Obtain ZONE_DEVICE directly from the node instead.
+	 */
+	zone = slab_is_available() ? device_zone(node) : pfn_to_zone(pfn, node);
 	page = vmemmap_shared_tail_page(order, zone);
 	if (!page)
 		return NULL;
 
+	/*
+	 * During early vmemmap population, the shared tail vmemmap backing
+	 * page is allocated from memblock before its struct page can safely
+	 * participate in page refcounting. Therefore, no reference can be
+	 * held for each shared PTE mapping, and the mappings must be unshared
+	 * before the vmemmap is depopulated.
+	 *
+	 * Once slab is available, the shared backing page is allocated from
+	 * the buddy allocator and can be refcounted. Hold one reference for
+	 * each shared PTE mapping. The architecture vmemmap teardown drops
+	 * the reference through __free_pages() when removing the mapping,
+	 * preventing the backing page from being freed while it is shared.
+	 *
+	 * The backing page may be shared by enough PTE mappings to exhaust
+	 * the positive range of its reference count. Stop populating the
+	 * vmemmap if another reference cannot be acquired.
+	 */
+	if (slab_is_available() && !try_get_page(page))
+		return NULL;
+
 	return page_address(page);
 }
 
@@ -260,31 +285,12 @@ static pte_t * __meminit vmemmap_pte_populate(pmd_t *pmd, unsigned long addr, in
 
 	if (pte_none(ptep_get(pte))) {
 		pte_t entry;
+		void *p = vmemmap_alloc_pte(pfn, node, altmap);
 
-		if (ptpfn == (unsigned long)-1) {
-			void *p = vmemmap_alloc_pte(pfn, node, altmap);
-
-			if (!p)
-				return NULL;
-			ptpfn = PHYS_PFN(__pa(p));
-		} else {
-			/*
-			 * When a PTE/PMD entry is freed from the init_mm
-			 * there's a free_pages() call to this page allocated
-			 * above. Thus this try_get_page() is paired with the
-			 * put_page_testzero() on the freeing path.
-			 * This can only called by certain ZONE_DEVICE path,
-			 * and through vmemmap_populate_compound_pages() when
-			 * slab is available.
-			 *
-			 * Use try_get_page() to prevent the shared page refcount
-			 * from overflowing.
-			 */
-			if (slab_is_available() &&
-			    !try_get_page(pfn_to_page(ptpfn)))
-				return NULL;
-		}
-		entry = pfn_pte(ptpfn, PAGE_KERNEL);
+		if (!p)
+			return NULL;
+
+		entry = pfn_pte(PHYS_PFN(__pa(p)), PAGE_KERNEL);
 		set_pte_at(&init_mm, addr, pte, entry);
 	} else if (WARN_ON_ONCE(vmemmap_optimizable_pfn(pfn)))
 		return NULL;
-- 
2.54.0


