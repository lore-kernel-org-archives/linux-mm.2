Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DF51C606A32E
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 03:26:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=google header.b=gkcbPuHE
Received: by kanga.kvack.org (Postfix)
	id 9773B6B05B4; Sun,  1 Nov 2026 22:26:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 928986B05B5; Sun,  1 Nov 2026 22:26:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 753486B05B6; Sun,  1 Nov 2026 22:26:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4C37C6B05B4
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 22:26:37 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C12E680AF8
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 03:26:36 +0000 (UTC)
X-FDA: 85388741592.08.C4BBDE3
Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
	by imf02.hostedemail.com (Postfix) with ESMTP id B5CE780003
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 03:26:34 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=gkcbPuHE;
	spf=pass (imf02.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.53 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793589995;
	b=PL9XPcfagKZsEiNqI5j2tZEyNF/7ZrrbwMsTV+bFUxsaZgfRlGC1q6YFP27r8ZyGi00opS
	AM6aIBL+kKAkeXDAyNEHKGdcO16PZO3eUi3SObnWA7v4adrWK+/67cRjCCVoqfVv4kZVqP
	VprJiVhcwPOG43n2gKTkvqozWN0R0Ac=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=gkcbPuHE;
	spf=pass (imf02.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.53 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793589995;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WBkp68rV0/lZxrO5waWBGU0MnUd67ZX+BTZGzOmvwqI=;
	b=PSHbXcJ1qecKaOkd16PWCqdZm7HP1gdMh+6U7iCVUWLTxTxIzWu7S9+rhjdyArD8bRXsMc
	8htnkArDwoCIScqjK2qEXpPczDFN3+c3JIBme++GxWIqtYxNhR0nY+cWkcc9tJYou8sYhf
	u1yvB4tZuXYeUfFtgwYuXhrMT5ziLGc=
Received: by mail-pj1-f53.google.com with SMTP id 98e67ed59e1d1-3ad787b79ffso1423336a91.1
        for <linux-mm@kvack.org>; Sun, 01 Nov 2026 19:26:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1793589994; x=1794194794; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=WBkp68rV0/lZxrO5waWBGU0MnUd67ZX+BTZGzOmvwqI=;
        b=gkcbPuHE4ufCuNrowqOwqPiZsuNvoSRmewWxGRupV53jDLXUdk05bWcfuwgBzjEeR/
         MP3OXXkR/UQtLztRKUMFDs3zH6r7ZIdPqWJ1w/uweei8vwLkBWLceMVlXll6mU8Xt5jG
         x0FUWOmzoszXC/+4lqlINxgaOUuB8HUx6MrBTF62ZkWW5Org9/zleDFmm44Mh7s/4ivO
         jnMIslMkgyDdr4o615+3zmZ9klfmeUsv3VIaHX2F/36T2egUP01wgGDOvVd4iN2wZ7t4
         Xd7np8rxlh82O0ye5/bv2jFiSWl4it4+a0TzJLjm7P5nrU8iG5C/W2kqebg9suXPjRRc
         A/xQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793589994; x=1794194794;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=WBkp68rV0/lZxrO5waWBGU0MnUd67ZX+BTZGzOmvwqI=;
        b=xZKTwSlYiUqDj0+8lhGInZxxcV9LSN/tOUZgW5OgYF4NRaQCbXeLIfYbPfpPDNZ615
         tGeILD+cqrgQAQokd4DCVsj8c1IPfxsH9TvKH98B3/PVxZ9vLYSuOaroALJG+q/AY/sb
         KUIj2fQ3coaNZ9zWgrBQTP3jZ6/TZA/7uZ901HUh6WvuhqNP3c+vFyE5cbGxS8KnRy7i
         bLp2oaGt5/bpuUJcMOSZYXb+UoQ0G3lMQXU6e3AcXYWg8A1ApOlaxKn3irIV1NRUV0Qd
         ZCUdfEaREUXNdQ7QWhFctrXBDwQRptCZ2dyzDvfPb15JcKSp6CwPs0NlFbIJPf0MvGkP
         DJJw==
X-Forwarded-Encrypted: i=1; AKwUvBwTQ3cL1yhVPTQrPvWpyfUWPx+JhJ+M6JPP8uXdWwFI6rlsiUToQPXyLDFtDepeKJYnZeCO+c+XrA==@kvack.org
X-Gm-Message-State: APuU4Z+QYe6KClFXvDKHOljhc8DDmlsL42FPLS6f4IiULOgti5fKalto
	HnYafBIpcvNHrlzXmzgTuRXeS4u9pkNClDUFZ7HmD2do0yM7PEM0CxRH3zndCmmqLjs=
X-Gm-Gg: AYBFou32pXiYf16rOJkMsPv2ENfgGzP3Obhg9D+rw06yQ35WiPpTEZZLKr77B2kIsUj
	PwMxkAZG+Hr88mKctwpfTKRQUeJiT+vy3XawT6QbsDgcr0UccQcfIwv2UfPxDphytUgff9zncF2
	hf5MoLZ8onwB0sOxiGOSczMLtMsXof/Zog4WX/Kh3AWOs2g9CVsh4k0NZdKxylSf0epj9+4fnCF
	Ffp9YVttZAovrjSqfGz7se7TdbH4PgScJc78kNMg2omRCu9h1XIAOBo5durxb9mcWp9Org6JcX3
	XTcn5c72vNfIMIk5uj29MnP8bqcThDTfx5sg6wgtedjJ5GQGAVQKU2xchFIt7BJoZgsN4q6xuQ2
	/fYVfsjAVFXuk74Q5qyhrGddlv8g80rp12EPwXy6nuapHuxtR9fkDOPcXtTBWQ/ooabTrUCGuA8
	LBsuePRGbg5etk38ZxHt8+qEi1XGC88CJNMB66j4clXSAaKR5xh5DbMt0/8ZMkH0BkBVIb/+aN3
	EdqfU322JA3V8uMs710sdRrZ12MC+6d+1j9uc4xh/TvZjQQzYNcGoMRYqcPkxTr5OeHlKdWL/0D
	pU0hkX9Utzo/+VSdJTg47wLBzvMd0CvminedN9JGS9xeBC2kLBlcyCcvlOZ6IWW8mYlpGM0=
X-Received: by 2002:a17:90b:2891:b0:3ac:7c52:fb04 with SMTP id 98e67ed59e1d1-3ae897ab44emr6749741a91.44.1793589993498;
        Sun, 01 Nov 2026 19:26:33 -0800 (PST)
Received: from n232-176-004.byted.org ([36.110.163.99])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ae845984absm12303317a91.10.2026.11.01.19.26.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 Nov 2026 19:26:32 -0800 (PST)
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
Subject: [PATCH v2 03/12] mm: hugetlb_vmemmap: simplify vmemmap head page handling
Date: Mon,  2 Nov 2026 11:25:16 +0800
Message-ID: <20261102032525.3597743-4-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261102032525.3597743-1-songmuchun@bytedance.com>
References: <20261102032525.3597743-1-songmuchun@bytedance.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: he4zp9ocbcyn9msqrt1h13xgr8cypazs
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: B5CE780003
X-Rspam-User: 
X-HE-Tag: 1793589994-834615
X-HE-Meta: U2FsdGVkX1+QuxwwoNAvW5c6nCq/LdJa1WmKa4md11XKJqJQWdBi8bbJabWgC3K0H06d9G7zMUHNdoD2GTUaCDuTVt+ss5uNnjXrF99tihfBhJmBf8JLqaHAESnd/WPh42S0vaILKOWUz3j9wEh58q9T2cUYdABoXV2//JvQYUodSdFchB09uOnz7TRgiRstutMrOv+1Pdi4HSAANaReQdYg941sIsAZg6gUl1ce9wh8BcUlnhFmzwh8hbEILVwDqzjjE6sdtRO1C7kAYeCulHhx9Jh89KsY1JauwLvT396eK0JorCw9wkqHJxa+3GXZ/LGaJ/sP1NWCH3lXilISWq59LPCrO1Hor+FMaz2TNG+tT4TjNyRkG75RbzBQ4HKbjSaCwB9J9FgsXIsvjtZLq2aDIjaZsVm2xZXQnfguuAfH3vBM0YCYcqDYCdYrWkuC3pCTm7vuosda0IZm6IJzpAHIQWtCVceF6dpYXEKW4XpzmSXRJd/EP6q6dKLHzvtcSWikXdyeQFqtkcrrCBibqN5k5tAucrFDhwfcc7Ec/UXBJj1aPTMbK35CTOPvdKquG6Q/nfyX0eJ/fxC6NHGfyxI0pKDwi+z6yT8K2TqqjkqeE6uDU8KM4J8HVb8dwVxFMPxEFe09O/a8Sc/NoofGQ+esaGsr250K/iWUGd8mP1GFqdt3glhVdGcGAqpzxmRyZFFs9u8uFeZFRmhK9X2FDQLpyL4Iur5Dm+3Bac+uQmQbVNrt9vO/dVcSt6Fm3S87s4d/z+y41WxmmV9UdA2OCknpedKWPSYrM6wiz5dpYMQW3DF6NZ4Hm4wjkDkyDgH++0+9tCEJD4VF5H9NgE6DKruZSiIubHwB4NUVz/OJGmg2YdDipgtpIAtwqf6dgtiHUoOPK+mjSGfOlbq15/Wjy9szxXUkV8H4u1otgNaBcqbD4FL3fEHCInaai2ikIAe3Y3s+0v9Xr8NwfvF2VT3
 JsthvM+j
 hvVFMyFRFSWGPRVV2KHF6aFILeA/NS7/rmcoAHeqcoLfZt+EvhHHXTnAN+VGin7x49qtdPL3kxGO6jLXXueQYkgIXLfz+Ew5ehnhDF9VrLhEyW4a1zrpjOi3HlpSaz1lmjwovChnPFKE82g/r+Vtq4tHmINDQhu1QgODAXXepM6UCGguCWDAtxoPBpLcZRpwGnWatomkjtHEVM1M2F7QI84sHYHWTrr7n9vGJrnj3p6e4udlKWkzvHX8JWe+ZbpstIdvZ7zpbFqoZARqdr3qFUXc3ZkiWUf7h2AtVhW/2AQhwjtoxrR1if6vsOB/SbNS4OE+Kvzc2j17r4KB8LhT/tK1C6F8JUAnOKbBaLxCPu2XOCzp3dvDZGjaZv9VZ3znNCqtAXmRT7A3ifxECfv1VcoRVgYyX1zLp/05UeYXB8PgiH1a0gppLKAvsJoJdomJigdJ4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

The new head page is already tracked on the vmemmap page list before
remapping starts.  Passing it separately gives the remap walker two
ways to refer to the same page and unnecessarily complicates its
interface.

Use the page list as the single handoff mechanism for the head page,
removing the redundant state from the walker.

No functional change intended.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Reviewed-by: Qi Zheng <qi.zheng@linux.dev>
---
v2:
- Remove outdated head-page wording from vmemmap_remap_free() kernel-doc
  (suggested by Lance Yang)
- Document the vmemmap page list contract (suggested by Qi Zheng)
- Collect Reviewed-by from Lance Yang and Qi Zheng
---
 mm/hugetlb_vmemmap.c | 30 +++++++++++++-----------------
 1 file changed, 13 insertions(+), 17 deletions(-)

diff --git a/mm/hugetlb_vmemmap.c b/mm/hugetlb_vmemmap.c
index 63e899cfaac3..0e5b2b182d1b 100644
--- a/mm/hugetlb_vmemmap.c
+++ b/mm/hugetlb_vmemmap.c
@@ -25,10 +25,9 @@
  *
  * @remap_pte:		called for each lowest-level entry (PTE).
  * @nr_walked:		the number of walked pte.
- * @vmemmap_head:	the page to be installed as first in the vmemmap range
  * @vmemmap_tail:	the page to be installed as non-first in the vmemmap range
- * @vmemmap_pages:	the list head of the vmemmap pages that can be freed
- *			or is mapped from.
+ * @vmemmap_pages:	list supplying replacement pages for the remap and
+ *			receiving displaced backing pages for the caller to free.
  * @flags:		used to modify behavior in vmemmap page table walking
  *			operations.
  */
@@ -37,7 +36,6 @@ struct vmemmap_remap_walk {
 					     struct vmemmap_remap_walk *walk);
 
 	unsigned long		nr_walked;
-	struct page		*vmemmap_head;
 	struct page		*vmemmap_tail;
 	struct list_head	*vmemmap_pages;
 
@@ -208,10 +206,13 @@ static void vmemmap_remap_pte(pte_t *pte, unsigned long addr,
 	pte_t entry;
 
 	/* Remapping the head page requires r/w */
-	if (unlikely(walk->nr_walked == 0 && walk->vmemmap_head)) {
+	if (unlikely(walk->nr_walked == 0)) {
+		struct page *head;
+
 		VM_WARN_ON_ONCE(!PageHead((const struct page *)addr));
 
-		list_del(&walk->vmemmap_head->lru);
+		head = list_first_entry(walk->vmemmap_pages, struct page, lru);
+		list_del(&head->lru);
 
 		/*
 		 * Makes sure that preceding stores to the page contents from
@@ -220,7 +221,7 @@ static void vmemmap_remap_pte(pte_t *pte, unsigned long addr,
 		 */
 		smp_wmb();
 
-		entry = mk_pte(walk->vmemmap_head, PAGE_KERNEL);
+		entry = mk_pte(head, PAGE_KERNEL);
 	} else {
 		VM_WARN_ON_ONCE(!PageTail((const struct page *)addr));
 
@@ -284,23 +285,20 @@ static int vmemmap_remap_split(unsigned long start, unsigned long end)
 }
 
 /**
- * vmemmap_remap_free - remap the vmemmap virtual address range [@start, @end)
- *			to use @vmemmap_head/tail, then free vmemmap which
- *			the range are mapped to.
+ * vmemmap_remap_free - remap a vmemmap range and collect old backing pages
  * @start:	start address of the vmemmap virtual address range that we want
  *		to remap.
  * @end:	end address of the vmemmap virtual address range that we want to
  *		remap.
- * @vmemmap_head: the page to be installed as first in the vmemmap range
  * @vmemmap_tail: the page to be installed as non-first in the vmemmap range
- * @vmemmap_pages: list to deposit vmemmap pages to be freed.  It is callers
- *		responsibility to free pages.
+ * @vmemmap_pages: input/output list whose first entry supplies the new backing
+ *		page for @start; replaced backing pages are added to the list for
+ *		the caller to free.
  * @flags:	modifications to vmemmap_remap_walk flags
  *
  * Return: %0 on success, negative error code otherwise.
  */
 static int vmemmap_remap_free(unsigned long start, unsigned long end,
-			      struct page *vmemmap_head,
 			      struct page *vmemmap_tail,
 			      struct list_head *vmemmap_pages,
 			      unsigned long flags)
@@ -308,7 +306,6 @@ static int vmemmap_remap_free(unsigned long start, unsigned long end,
 	int ret;
 	struct vmemmap_remap_walk walk = {
 		.remap_pte	= vmemmap_remap_pte,
-		.vmemmap_head	= vmemmap_head,
 		.vmemmap_tail	= vmemmap_tail,
 		.vmemmap_pages	= vmemmap_pages,
 		.flags		= flags,
@@ -549,8 +546,7 @@ static int __hugetlb_vmemmap_optimize_folio(const struct hstate *h,
 	 * they can be freed by the caller.
 	 */
 	ret = vmemmap_remap_free(vmemmap_start, vmemmap_end,
-				 vmemmap_head, vmemmap_tail,
-				 vmemmap_pages, flags);
+				 vmemmap_tail, vmemmap_pages, flags);
 out:
 	if (ret)
 		folio_clear_hugetlb_vmemmap_optimized(folio);
-- 
2.54.0


