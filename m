Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8B75D60A4AD8
	for <linux-mm@archiver.kernel.org>; Tue, 20 Oct 2026 11:59:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=google header.b=UX7dDNnY
Received: by kanga.kvack.org (Postfix)
	id A442C6B04AA; Tue, 20 Oct 2026 07:59:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A19C36B04AC; Tue, 20 Oct 2026 07:59:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9089B6B04AD; Tue, 20 Oct 2026 07:59:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 65EB66B04AA
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 07:59:07 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 003621C1197
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 11:59:06 +0000 (UTC)
X-FDA: 85342858734.03.BAFA562
Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	by imf02.hostedemail.com (Postfix) with ESMTP id 4343180005
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 11:59:05 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=UX7dDNnY;
	spf=pass (imf02.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.50 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792497545;
	b=p2HGQSzh5U+VaAmo45oqU55UlRK9IyBiBNZJvmvxtfa5kdmTBqHLH6VcHJHiMfZriXMUG/
	E0D3bLklMs/f7cV9Ki92FIcKLHrq4Bj3IpcrHvN047PhBqb4GP4nQZjIxAM4TDDYawo0a8
	k9qob9OiOefXIjUHmM9PxM37MlWi7Xk=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=UX7dDNnY;
	spf=pass (imf02.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.50 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792497545;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0/kLuwranRIcc6BAkD4t9DaufgZSf9Rq+8qNPAMIVhU=;
	b=glYybU2iJhft7nq5/GaK8PF0P/VTuF1qmgA5WD0snkI+YBKoeuwNIYavt4MVsmkzQFs68u
	2SOwBHFrty4tjVxuvWmdcqGyOeQmYmt7LHdqjRV+/G74tWlAaRQzYlqYldYME1Vkdipa9q
	4Lst0R+5U57fwkk/qqp3pacUXpjS86Y=
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-38ec1402b05so2019125a91.2
        for <linux-mm@kvack.org>; Tue, 20 Oct 2026 04:59:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1792497544; x=1793102344; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=0/kLuwranRIcc6BAkD4t9DaufgZSf9Rq+8qNPAMIVhU=;
        b=UX7dDNnYvu2UDyj+MFOHv4WbVXLtEsm+gEadCO9+2p+H0HUPmTdwQlv5pFIk9xFWR4
         jxB12HaE7QIoaqpRSAj0Hxf/BSksasTavg7PkM8xMtkogokSI3uKsdzDCA9pBxzGHkM0
         fqtPV8arLH8c/L/ceJy0gok6gYhgWdw8uiSazJsGppoMLlOwu5cT9IWsrM5oQOyB9LqI
         U461llNv+b4osXro7w/IVsbZsm/J5sFmSrx92DQFLJzXdVzEZO1jszDbmaqG0Ls2rFaa
         9FqkTtY/waEvfsAWvgZahWL6w60/Tb5KnfFjVg2BITDhXdSEendFXb3KlbWC5nU4RNRB
         78Yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792497544; x=1793102344;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=0/kLuwranRIcc6BAkD4t9DaufgZSf9Rq+8qNPAMIVhU=;
        b=Zpc5cAk8BYZfEUx2pun2bkuhQEQJjKSjR6jGgCTOEG+BVdB194gAWm7hCrtYRb38Mr
         I0JeShTRM27vz3OUpg6Ld04a4mh7FKiMwB6HS3pCDuqGZ/Acn6WFTlkB5WLZX08+Uleq
         k0Zso3DCTBBV7i8xL2zFO9HFwJl15NpozmMQXlkyK1lLyvUuMMC1KxSjUSuYwn3Fup11
         LYrhAiz44bUB/Yi7IHzp7u8AtV2828oPjT8yUWw79tzaBOOlVyiadvxPHtAN++Wsrs6p
         PegwAIxvg23jrmU90VwUrHZaU3yI3632r8bN+EzppbfnCVCSj58jgldv0FCKZKh0a/5m
         htAw==
X-Forwarded-Encrypted: i=1; AKwUvBw/5Gk77B8a2/cGdThqEAe2mWJutF1oKWRqUK5PcRtFQW+oARl5mpRnEKvy6chv6WH0F0hW7IiZOQ==@kvack.org
X-Gm-Message-State: AFq9FYKhwtWD83RZ1XLFOrSeelI4/QDXHkZZw/jEkJTf2PnfuTIO6PXU
	SD4jh9l7McNEhSZPVEnHZAdZBEP0R0UDtZx+YRyuLJqSni6Q2ZxTG6P/XVYcXTA79FU=
X-Gm-Gg: AYBFou3m0+/yOIOa2pzLzkhmtUNQisEJcvr6AewHn8yMUBqpqGj2oF40zXR59Ao10NI
	jpPf1xXl1C2YSb3KFQxIueU9ZVUYpPCpNxiIKWLQlLE2caNEX06ecnteo+aEiBdhFKuvQc7PXC1
	Mx+dqSe0CyEwJvQ10B+df2slI/UzeycdxPgZtvaLsmjDqadx5gegViyJneDOso0CNieQD92AZVY
	+Z9mfshpipQuSyXU6yERmi95W1PeLVI/eo8/4RXph/ieQa90JpCVNmUlSKL8jFy+39pz25azFrb
	e7RLdh07NKPWr/tAoFydb0SYVfJz39MM7sy4BSir6SMTvcu30dvjSxvs6yqRqZCgyufBPvAS0uc
	KdjLNnnc4dDq74LKRXLsRBPP9EhxeFxvrOWClUdS9KkO0g46myk4hoh9nBswu0YUFoTJV3icQhi
	yIFCVV7Bh9Urfe5tZ+dCzc8mKSVIbxfHbtRWe1yt21Wig491GnH3nU+C2sCfwlFpY2b4YBG84wV
	9UXDXW3P4t+j5nLqWth
X-Received: by 2002:a17:90b:2ec3:b0:3a0:b312:1fbe with SMTP id 98e67ed59e1d1-3acef134d96mr8468531a91.23.1792497544021;
        Tue, 20 Oct 2026 04:59:04 -0700 (PDT)
Received: from n232-176-004.byted.org ([36.110.163.102])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ad60274fc1sm3448095a91.0.2026.10.20.04.59.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Oct 2026 04:59:03 -0700 (PDT)
From: Muchun Song <songmuchun@bytedance.com>
To: Oscar Salvador <osalvador@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Mike Rapoport <rppt@kernel.org>
Cc: Qi Zheng <qi.zheng@linux.dev>,
	Lance Yang <lance.yang@linux.dev>,
	James Houghton <jthoughton@google.com>,
	David Hildenbrand <david@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>
Subject: [PATCH 10/12] mm: hugetlb_vmemmap: make vmemmap restoration folio-oriented
Date: Tue, 20 Oct 2026 19:58:22 +0800
Message-ID: <20261020115824.823278-9-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261020115824.823278-1-songmuchun@bytedance.com>
References: <20261020115306.813483-1-songmuchun@bytedance.com>
 <20261020115824.823278-1-songmuchun@bytedance.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 4343180005
X-Stat-Signature: 9e1z8ij5ytcrcfmxb1xg8eytbcjy6jbb
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1792497545-487629
X-HE-Meta: U2FsdGVkX19p882pJdgnMCrEPiU9Y6WFcLGwF8FawSxOXa3n2k3fgS35/sE/4FHISyip7CMTiUP8eviugUHlP+F53aV5tMRiKu4dUw5z71t88z1v6lbhGKeSyhak+XKoNqg/1dBVhn3NUhuif7B6W2BmOSkuPEtxopz0gVhToJ+Hw5eDUfobxc6zbSL4H/k+jCXI9XkqVwhlShqBItVMu+R1T9PjQWr5Hsq9KjF3tLHmVQhaKP48d+24h/nuXR44Wxii1+IBm6ZrYQjtibyC2RThPI4KQJ5zTr3I4CvmVBOuDrSBBhHh8yVYVdEwuT1t2pdJeDV60jkdJbCaxBRbbuhqfgLbF/CO6Ex0Tq+bwLcpM6oMOTu54epvWfPI+tVeV9vnhrf0Tt/GJKIKQWZzD9Rx0DZaMne5pTqAWbK0E7ZyDX2f8VYeAuX2EdDLb4na74EuoBW9nWisSKzGCSSOxiS0JuGgt7VpdnZ/3B7J9Q+4bw04yVOEl3Gl45UkZuU2I7a8lQ/WqbWlFX7ivmFR276bl3fbMPv/31XuSIXs0m5n1e03wtbKo3mbyPFbLMceQ3CSURaqlpaUJbXHSY20H59IeQfmYzliLRfN7HA14d85C3uTCLThdfpVw88ZJfvFC6mKQKtzHvTRpYsKrXY2S8nkYfSCQz2KRe06Q0hzRfniJ0GZCVdikI0BgswcZisNMyPmd+SNthboMCKFoQyodRsBVipLS12Yw/W/VVqql8sv+8h+rL7jCkkT/3WPKNz+vKXtGEtKqTi4RrhsvHhYuUWLyPjqY8BnfjVZJpS6p7mJ+b0kea5rWiiJxTzb9ofcuMOPiM0cMlu3XwK0erb7WFf7Ntqtgw+LmMKfVd3RmHrcpgnRf8naIxpXgeLZ3tJYdQMokLTQcVlr267M5aWC/vYI3XSBb7eKPR+PEsKmYj8QXUyRgFdouHEEXG81yRHUteeIYEYNvgpz8Wlbcm8
 wA40XPci
 G0BbLGrGyuJPyQxtaYV9OxEzu1Gf7tkO6PW9BLgo/i0YjZEIsgcZzmHGzbo3BUlSUx76GjN1V1hD3vednIcykfrDsbCPtVLVv4KP2pS/ycKwF/IgaAlrfCGWifKhSBcbi64AYFA2YFllwYStvBMydglLcycNzfr4pefEPY8TlttQTHon96HXT+bfXdnm9XDavMvWFv++rnR9KU4qEAYiDcGOCHiK0FR2XkES8Nq3PcN8UT2Juec4Ohcd2Q2nnmm61FSTipvcta0iv/6hFPlyKsLLnYDjbmVGadmpaOQUH6yKm2pD/FHuDv4afs6V+Thm5Qh2JeP92E1As+wXKKlUv41tEk9QC117xFR0+l/zjvmXGD20=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Like optimization, vmemmap restoration operates on one folio at a time,
but the current interface exposes a raw address range and requires the
HugeTLB caller to prepare part of the operation.  This splits the common
mechanism across layers and obscures its natural unit of work.

Make the folio the unit of vmemmap restoration and move the common
mechanics behind a folio-oriented interface.  This keeps HugeTLB-specific
eligibility and state in the caller and gives both directions of HVO
consistent folio-level interfaces.

No functional change intended.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
---
 mm/hugetlb_vmemmap.c | 37 +++++++++++++------------------------
 1 file changed, 13 insertions(+), 24 deletions(-)

diff --git a/mm/hugetlb_vmemmap.c b/mm/hugetlb_vmemmap.c
index b76203e34881..97748a9cefe2 100644
--- a/mm/hugetlb_vmemmap.c
+++ b/mm/hugetlb_vmemmap.c
@@ -360,28 +360,29 @@ static int vmemmap_optimize_folio(const struct folio *folio,
 }
 
 /**
- * vmemmap_remap_alloc - remap the vmemmap virtual address range [@start, end)
- *			 to the page which is from the @vmemmap_pages
- *			 respectively.
- * @start:	start address of the vmemmap virtual address range that we want
- *		to remap.
- * @end:	end address of the vmemmap virtual address range that we want to
- *		remap.
- * @flags:	modifications to vmemmap_remap_walk flags
+ * vmemmap_restore_folio - restore the vmemmap backing of a folio
+ * @folio:	folio whose vmemmap pages should be restored.
+ * @flags:	vmemmap remap control flags passed to vmemmap_remap_walk.
+ *
+ * Remap @folio's vmemmap so optimizable entries are restored from the shared
+ * tail page back to distinct backing pages allocated for @folio, while
+ * non-optimizable entries remain unchanged.
  *
  * Return: %0 on success, negative error code otherwise.
  */
-static int vmemmap_remap_alloc(unsigned long start, unsigned long end,
-			       unsigned long flags)
+static int vmemmap_restore_folio(const struct folio *folio, unsigned long flags)
 {
 	LIST_HEAD(vmemmap_pages);
-	int nid = page_to_nid((struct page *)start);
+	int nid = folio_nid(folio);
+	unsigned long start = (unsigned long)folio_page(folio, 0);
+	unsigned long end = start + folio_vmemmap_size(folio);
 	struct vmemmap_remap_walk walk = {
 		.remap_pte	= vmemmap_restore_pte,
 		.vmemmap_pages	= &vmemmap_pages,
 		.flags		= flags,
 	};
 
+	start += VMEMMAP_OPTIMIZATION_SIZE;
 	if (alloc_vmemmap_page_list(&vmemmap_pages, (end - start) / PAGE_SIZE, nid))
 		return -ENOMEM;
 
@@ -399,7 +400,6 @@ static int __hugetlb_vmemmap_restore_folio(const struct hstate *h,
 					   struct folio *folio, unsigned long flags)
 {
 	int ret;
-	unsigned long vmemmap_start, vmemmap_end;
 
 	VM_WARN_ON_ONCE_FOLIO(!folio_test_hugetlb(folio), folio);
 	VM_WARN_ON_ONCE_FOLIO(folio_ref_count(folio), folio);
@@ -407,18 +407,7 @@ static int __hugetlb_vmemmap_restore_folio(const struct hstate *h,
 	if (!folio_test_hugetlb_vmemmap_optimized(folio))
 		return 0;
 
-	vmemmap_start	= (unsigned long)&folio->page;
-	vmemmap_end	= vmemmap_start + hugetlb_vmemmap_size(h);
-
-	vmemmap_start	+= VMEMMAP_OPTIMIZATION_SIZE;
-
-	/*
-	 * The pages which the vmemmap virtual address range [@vmemmap_start,
-	 * @vmemmap_end) are mapped to are freed to the buddy allocator.
-	 * When a HugeTLB page is freed to the buddy allocator, previously
-	 * discarded vmemmap pages must be allocated and remapping.
-	 */
-	ret = vmemmap_remap_alloc(vmemmap_start, vmemmap_end, flags);
+	ret = vmemmap_restore_folio(folio, flags);
 	if (!ret)
 		folio_clear_hugetlb_vmemmap_optimized(folio);
 
-- 
2.54.0


