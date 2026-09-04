Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 190B9C79F87
	for <linux-mm@archiver.kernel.org>; Fri,  4 Sep 2026 15:11:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B201C6B00A3; Fri,  4 Sep 2026 11:10:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AF72F6B00A5; Fri,  4 Sep 2026 11:10:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A0A8C6B00A3; Fri,  4 Sep 2026 11:10:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7B5B96B00A3
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 11:10:54 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B8A08A3C2D
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 15:10:50 +0000 (UTC)
X-FDA: 85176417060.13.3CC9F6D
Received: from fout-a1-smtp.messagingengine.com (fout-a1-smtp.messagingengine.com [103.168.172.144])
	by imf04.hostedemail.com (Postfix) with ESMTP id D4F8B40003
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 15:10:48 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="b IU4zTk";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=d9Cl+Dxs;
	spf=pass (imf04.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.144 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788534648;
	b=CWD1DXeNNWJKEDLQX0O0t0sz2fHwwcp5CAPNH4K3VixzPxN5jaG1EMhBwEgA8UetS3+8Td
	sDeDH9ycgSVss5+scfxH2ZDSMNzXz/PhAlifZkg+xcuCjdMTM6+zCa48Oro3W6ARl+F3/Z
	PBvX765KEOWyVuuw8DqsBM2mspcbmUY=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="b IU4zTk";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=d9Cl+Dxs;
	spf=pass (imf04.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.144 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788534648;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ma/0lPtOSoslW4rYZfqjpQhzgHNyjT+wt2R0Nf4TT/U=;
	b=0ZXDZuSS7qoKN3Pll6hHTbnipXhtYoFr93f9mxmCHawwAokjXOPOqHFUZh5Rfi5qgl4uff
	vylcDGHikvpGuCfrQBwBxvTiOtKADJHjsBG5mzTpSKCXtTAxv9A3FiBF/+acYaePVxSYi/
	SE+SHHVJgJYYjgOe4iK4EHx+XbuYY2U=
Received: from phl-compute-12.internal (phl-compute-12.internal [10.202.2.52])
	by mailfout.phl.internal (Postfix) with ESMTP id 7C86DEC017D;
	Fri,  4 Sep 2026 11:10:48 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-12.internal (MEProxy); Fri, 04 Sep 2026 11:10:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm2; t=1788534648; x=
	1788621048; bh=Ma/0lPtOSoslW4rYZfqjpQhzgHNyjT+wt2R0Nf4TT/U=; b=b
	IU4zTkXENwyseuVnQjybnGe65B69eUWUOwK8UJXoIIsALtveXfw1vPCstx4U5KPM
	GQoU2CCdLR8vdGxIf7r/t3AkKFWCQma4lgGk30jtY/wLZ3zS/hDnDGw0WJUlaajf
	EgrIOdClltmhZxUB6D9HslXuTO470f079WRJg4coEJtnU/2aE9rBi+maKi0tFQGW
	G8H8oUlItqn/b/YcbC+AosHawuRdUsDkdo8vhrg08zh5bPrAfyK7VUglzvxmHiwO
	TmlD37/1VDx3Eobfl6f+n7VsyOobOmsgIQF7AD9FCqZ4lLsdwVhJiF+YvlQ0rn+A
	dN235UZfb5knGo4AiPSGg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm1; t=1788534648; x=1788621048; bh=M
	a/0lPtOSoslW4rYZfqjpQhzgHNyjT+wt2R0Nf4TT/U=; b=d9Cl+DxsYmUg1Ee/7
	4PDuV1s/RgmbFlB6XysOAJBzkDbJSvkg9qYYohZlX8RqfZ1h2z3/jMrdBQevGYVq
	z20uVUAnCqcB2GWw3KqxhIR9yNpiWhLlQxHrtskUGtCPJe+43+yLM8DZONRMO14u
	zWuYnwuYQvre/y0hblzZB8+DBtGZX35pQIvjAClFVQEXLuHRpPZ68y/6Avb72FwP
	OUeyo/txuMrXCZspIDRc10Z1RNQpTHgGZi8CbRxJsEzydRrgS+AkorXpKZ4qu7Q1
	gr9dBbJKZaudFvLgrXicV71E9B/hc21det3soxqDFaLiZONw0lxJib3S28x5nhbZ
	ekF4Q==
X-ME-Sender: <xms:eN-aamziLij75wW8MSuMnCviMVVEcTKMxqzkDB7V97yR_hDMRROIPw>
    <xme:eN-aauMuOOiWriLWu1xo_E-QtHsCfbRgm2NhJxVCSaxCoPIsZvjoogmtNwdNLT2RU
    yKPCsXCoUH68KCfmcZYrBSgsb8z_zsfzvoKgcGnnw_AEkUcVsGmTElA>
X-ME-Received: <xmr:eN-aaueEMTACZkqjuHWpdmxh5EsHVAKgtrcbR5g1KMjP9yOjANljJJxleuo>
X-ME-Proxy-Cause: dmFkZTET6cjphBfz4H8Wg4Mwj3Q2fsO4rbzY0RZa6uwdK6ABZ7pEhWaf3DWE0Wh23XozXl
    YXqBYYUtwtfZ1qQ9wX2bCqZqo/yq027VrzWqESBcvph06bOS8vyiOGOCS0fh2RY7A/kSFI
    L9MElk4eZ3HddGFY9A2GQHzM4/P7C4mhUDQ1iVikEtpcmuF5W8uFTm0u0CjZbROqFnINk4
    xO1zzX/Hj74YRRcHjJyG4ygWf0Hx5RhGZptpxeuVNBh7kD8dz0lfmQnwRvV5yZ57YM54K9
    KH8vVIjAAxpTayQfOZqnAJ2Uka0rmt6zQ0IYLz8TzxO+2W2OgPHZMW2lenfH2WoNpxg3sE
    8WblxGqVLg0Bt0AT1lOybodMq55HcpaAOi4fb66mrBF11B+c0n5/ojcCMLj8yggFMpmyba
    xujKgPZLnfVEWUbWBZx1XQ7s2f6iC/rOAs1I7ckFmM651lWFpY8JYD0q0ZxqV3OL/Ru7ZZ
    ECq6jlG1PNY6qNadUsT5HJ3ABpnq0T1BEeV4Hayg3rBdK0Rowfn9nEkDsoUnNpqY8SMj3D
    fC05ebHO439F/wozaYoHJF11vPLoaSBLsqYTnkgdVjYcNpY4ZvJTeifXJA3WIJfdvsvVu6
    cv46LP2/YfqvlXGYPih0MAwTB3Aiarl5KveB17/HJsdLGUkRo5vmp5NbosNA
X-ME-Proxy: <xmx:eN-aai75Fvw0MhzKhnJWdqUcg9YKujPrb9UDGs2EIkXsd573U8JwJQ>
    <xmx:eN-aamIfz6Bss5EYAgWsSn0WaafrUxTIKezAB6f8QqgzYu_ycr0LGg>
    <xmx:eN-aam4E4xW3e1Vads0KbBtzqGhjrJQK7VeFA9dV-bAQwy90QolKRQ>
    <xmx:eN-aalbWqgttv2G8HCibRP45YPJmi2v30JYomz4EPNtqpZz0VjnmVw>
    <xmx:eN-aauqpirDInKt7XlK5UIWgAobmuIh_jfAIkt9MXSnW2bFBJYHOb5cF>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 4 Sep 2026 11:10:47 -0400 (EDT)
From: Kiryl Shutsemau <kirill@shutemov.name>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R . Howlett" <liam@infradead.org>,
	Nico Pache <nico.pache@linux.dev>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Usama Arif <usama.arif@linux.dev>,
	Vlastimil Babka <vbabka@kernel.org>,
	Jann Horn <jannh@google.com>,
	"Kiryl Shutsemau (Meta)" <kas@kernel.org>
Subject: [PATCH 10/12] mm/collapse: work out the orders a VMA allows once per VMA
Date: Fri,  4 Sep 2026 16:10:24 +0100
Message-ID: <3ce85bb56f2bc60f91bf4e9645f247460f3c3f1e.1788533997.git.kas@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <cover.1788533997.git.kas@kernel.org>
References: <cover.1788533997.git.kas@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: D4F8B40003
X-Stat-Signature: oh1asnak671ciy53ft1kxtojmd6cztgu
X-HE-Tag: 1788534648-492551
X-HE-Meta: U2FsdGVkX19mVrvdQFqwG34nQTv3O0FYTmNnNy4gm8k4ofkSiAqkH2QHclrm7brU5JVA8RyBZJLenKydkFlkBv6CWtoWb2+MySGhG6YaEWh58XnL9BN4bD05AsFy07jY3qvVhZHY+oYxWoSJAOxE98fX5vMBJbu51+rYlWxcZ3WyROdxlxjRUK54y2m3ZjrzsoFWZR7aiUM1hiKjyS1WTDaF+CEw3kdvU6G3bkg7u9JSFr3UPnn/aXxTrEPS+44i7L7gwaB2raukHcE7cZT7X2EpOsws4OTpIYmMOQGYsE5UMll8JsPPmGu5NXOVnBczc8PMCLP2L1oAM5rHDG8E9Wxfsf7mAndH5HOo+8IOb2l1SbXfE9fc0zKdWh2JlGkmvrmvDSVIQeeKMPGJodbNFPk5CZpyLfc5nt15zofbbu2aL9tkSfhfwu3DOUcaf77rHsa/LzRS8FH3qKo79kK9JT4D/5Qmz5zjE41+ltpA9dGhOYpEl5sKcs8YWBojAmBSb+28sMjN0jiCLpCfC/Ud1gJBVLoL+Vnzg6aLDGgfWO9K82SrMSZZ+r+1iPzSGLJ0P/7w1CTNypPcsmKX0IgAuDHzd515LKtbTla7J2FZOdVo2uItyTZ5VRnCes1VEv6mVlIs5HoVM13R415kiw7yaSoPHQLtzfYnY56xkqnpcmIcXz5wtMDzW1Goy6A/xP/+ntKxqr6KdKuJ/XmuMYfawt8AdG/AGLdCp6uMSWrYq7uOWD5FVbqaYLU/Ml+f+0O1KsYySEyFv0vz1FOIJ5mns7CUau4r7x/FgO+v0P77fB9oiBVvyNugBbxgk6rn7JDCsF5Ot52gDGkCHsFrPPz5iiF8wU1o9gvt2n4d3s65DWpNywVs9OS0J1iQK7i0n0KQZYRH/8ojY77qw3GkKh6CGcR+AxU6TQ7FJg/RKZe/Kw0mqxMgmMY5Eyr50XNGHPzbcJjM+PDPV+M0bHaLq7C
 EWKOlQTe
 aWfHFpbQe01Tuf9hWig4wOnG33cayUkmrUJi5A4X734oM5Q4tnsjKIibOChfLVMN5r0QHctLKlwLWA/ojqvDzYqG6szI7wumJ6fZUlf4YVOcukX/cukBzIhtndEFnSp+FhdkYYvOZlzKHlBMYP/tYNx4sTsz9lIe1iMhxsTKgo72WORbuP8QGFIg+FO1IHR+lUn+3XKYbPjv2NcZYO/P6tk+KmnD5m/bS8X+gzFXZxcU1xJ1wAwadAvK0tanpgQ7iKgNljT1TaUkUhoyvfLjcwDug/OSE3cBET/RPYK6gG7AoRZlAJ6IxnLSLirm4z7MiHDZAsKSDbl1sgCltyI6g/PnwOJF3SX8MYaC9zPgAUf3XYfXQeiSUlhXjFsXyxSSNVOMKNlqbdEf89gziSOpN7+LbFZKiSkOHuXrMqj+d/QIO9XQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>

The scan asked collapse_possible_orders() for every PTE table, for an
answer that is a property of the VMA.  Both callers walk a VMA a table at
a time, so let them work it out once and pass the mask in.  It is only
good while the lock that produced it is held, so madvise_collapse() takes
it again after every collapse.

The mask is then sampled once per VMA rather than once per table.  A thp
enabled knob written during a walk takes effect one VMA later, and cannot
widen a collapse: hugepage_vma_revalidate() tests the order again under
the lock the collapse retakes.

Assisted-by: Claude-Code:claude-opus-5
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
---
 mm/khugepaged.c | 32 ++++++++++++++++++--------------
 1 file changed, 18 insertions(+), 14 deletions(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 40fcdd4f2712..f862abb1dbbd 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -1551,12 +1551,12 @@ static enum scan_result mthp_collapse(struct mm_struct *mm,
 }
 
 static enum scan_result collapse_scan_anon_pmd(struct vm_area_struct *vma,
-		unsigned long start_addr, struct collapse_control *cc)
+		unsigned long start_addr, struct collapse_control *cc,
+		unsigned long enabled_orders)
 {
 	const unsigned int max_ptes_shared = collapse_max_ptes_shared(cc, HPAGE_PMD_ORDER);
 	const unsigned int max_ptes_swap = collapse_max_ptes_swap(cc, HPAGE_PMD_ORDER);
 	unsigned int max_ptes_none = collapse_max_ptes_none(cc, vma, HPAGE_PMD_ORDER);
-	enum tva_type tva_flags = cc->policy.tva_type;
 	struct mm_struct *mm = vma->vm_mm;
 	pmd_t *pmd;
 	pte_t *pte, *_pte, pteval;
@@ -1567,7 +1567,6 @@ static enum scan_result collapse_scan_anon_pmd(struct vm_area_struct *vma,
 	struct folio *folio = NULL;
 	unsigned long failed_pfn = -1;
 	unsigned long addr;
-	unsigned long enabled_orders;
 	spinlock_t *ptl;
 	int node = NUMA_NO_NODE, unmapped = 0;
 
@@ -1581,8 +1580,6 @@ static enum scan_result collapse_scan_anon_pmd(struct vm_area_struct *vma,
 
 	collapse_scan_reset(cc);
 
-	enabled_orders = collapse_possible_orders(vma, vma->vm_flags, tva_flags);
-
 	/*
 	 * If PMD is the only enabled order, enforce max_ptes_none, otherwise
 	 * scan all pages to populate the bitmap for mTHP collapse. The bitmap
@@ -2773,7 +2770,8 @@ static void collapse_control_release(struct collapse_control *cc)
 }
 
 static enum scan_result collapse_scan_pmd(struct vm_area_struct *vma,
-		unsigned long addr, struct collapse_control *cc)
+		unsigned long addr, struct collapse_control *cc,
+		unsigned long orders)
 {
 	mmap_assert_locked(vma->vm_mm);
 	/* Whatever the last scan found has to have been run by now */
@@ -2783,7 +2781,7 @@ static enum scan_result collapse_scan_pmd(struct vm_area_struct *vma,
 	}
 
 	if (vma_is_anonymous(vma))
-		return collapse_scan_anon_pmd(vma, addr, cc);
+		return collapse_scan_anon_pmd(vma, addr, cc, orders);
 
 	/*
 	 * A file collapse works on the page cache and never sees a VMA, so take
@@ -2877,15 +2875,17 @@ static void collapse_scan_mm_slot(unsigned int progress_max,
 
 	vma_iter_init(&vmi, mm, khugepaged_scan.address);
 	for_each_vma(vmi, vma) {
-		unsigned long hstart, hend;
+		unsigned long hstart, hend, orders;
 
 		cond_resched();
 		if (unlikely(collapse_test_exit_or_disable(mm))) {
 			cc->progress++;
 			break;
 		}
-		if (!collapse_possible_orders(vma, vma->vm_flags,
-					      TVA_KHUGEPAGED)) {
+		/* One mask for the whole VMA */
+		orders = collapse_possible_orders(vma, vma->vm_flags,
+						  cc->policy.tva_type);
+		if (!orders) {
 			cc->progress++;
 			continue;
 		}
@@ -2914,7 +2914,7 @@ static void collapse_scan_mm_slot(unsigned int progress_max,
 			/* move to next address */
 			khugepaged_scan.address += HPAGE_PMD_SIZE;
 
-			*result = collapse_scan_pmd(vma, addr, cc);
+			*result = collapse_scan_pmd(vma, addr, cc, orders);
 			/* Nothing to collapse here, and the lock is still ours */
 			if (*result != SCAN_SUCCEED) {
 				if (cc->progress >= progress_max)
@@ -3198,14 +3198,16 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
 {
 	struct collapse_control *cc;
 	struct mm_struct *mm = vma->vm_mm;
-	unsigned long hstart, hend, addr;
+	unsigned long hstart, hend, addr, orders;
 	enum scan_result last_fail = SCAN_FAIL;
 	int thps = 0;
 
 	BUG_ON(vma->vm_start > start);
 	BUG_ON(vma->vm_end < end);
 
-	if (!collapse_possible_orders(vma, vma->vm_flags, TVA_FORCED_COLLAPSE))
+	orders = collapse_possible_orders(vma, vma->vm_flags,
+					  TVA_FORCED_COLLAPSE);
+	if (!orders)
 		return -EINVAL;
 
 	hstart = ALIGN(start, HPAGE_PMD_SIZE);
@@ -3243,9 +3245,11 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
 			}
 			vma = found;
 			hend = min(hend, vma->vm_end & HPAGE_PMD_MASK);
+			orders = collapse_possible_orders(vma, vma->vm_flags,
+							  cc->policy.tva_type);
 		}
 
-		result = collapse_scan_pmd(vma, addr, cc);
+		result = collapse_scan_pmd(vma, addr, cc, orders);
 		/* Nothing to collapse here, and the lock is still ours */
 		if (result != SCAN_SUCCEED)
 			goto tally;
-- 
2.54.0


