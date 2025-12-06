Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2F4A2D3B7E1
	for <linux-mm@archiver.kernel.org>; Sat,  6 Dec 2025 23:03:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9AF7E6B0011; Sat,  6 Dec 2025 18:03:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 95F386B0012; Sat,  6 Dec 2025 18:03:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 84FA56B0022; Sat,  6 Dec 2025 18:03:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 748286B0011
	for <linux-mm@kvack.org>; Sat,  6 Dec 2025 18:03:52 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 32A5FC06AE
	for <linux-mm@kvack.org>; Sat,  6 Dec 2025 23:03:52 +0000 (UTC)
X-FDA: 84190575504.20.B598423
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 7103840012
	for <linux-mm@kvack.org>; Sat,  6 Dec 2025 23:03:50 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=pRMaTXNP;
	spf=pass (imf01.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765062230;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EKAEEiFJgIdASU/B+GZlPyvBV0AGHYeBWxkZujJmE+E=;
	b=Pc3SP/5vIfFMOqOt2n9oPWzUcJahzw69Opk0Jf/2wXkJko0Jpki39txJ5aOufyDb8wPPno
	ORK3lck9xZ0EYrGJrsea0+F0Ch4+dl++VCtjOZyWyXzGhDo/v6tjndMDPwnBXySSDDwsgb
	koPuZLKuM4hNqAj5f+cJTegGBoonrQ0=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=pRMaTXNP;
	spf=pass (imf01.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765062230; a=rsa-sha256;
	cv=none;
	b=Sz5nUvj9GBGojev+3Pq2jjD4rj3QVOs1QVQGV4AO6Xtsoh/NlIVKlwrRAumuLTPUfQktlZ
	Vk7XdYwCYJI2mJrz2MUtmJba5YX0Hj+nPrLevv1p4zqg+XNoSuGPcJSjPM7yU9qDhxdo56
	Y6J0McHrdlQbRhLYy0NJkWGQm2MPgvQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 9A0A743CEA;
	Sat,  6 Dec 2025 23:03:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5ED7C4CEF5;
	Sat,  6 Dec 2025 23:03:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765062229;
	bh=ep+jrIbVv9vGa6SgBSTj5ivMOs2gsXD3lJ0J4ipWtJ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pRMaTXNPuKpEz/bwr3yXklWljScvY8Jj5BQFKIAxjk2h0Dms2ugjoSTkH+4VcK1pG
	 i1Ai1LIN5A1c0f69RUgbYPpxvrSr3j7B88iR/40S7Lp5TeF7eozVr2jBLcghpIRdfd
	 /bvn5NfR8DMyi+2hcVDyY+awVnxHJYRxidOpE3RssOTu/Hjp2v1o8P8BPxOA4TSCgk
	 /WVrS+pMMcmEhIiyCPZPzzKU7WVzkGlQJOA7X/Mp/mlUCQeuVuFTa+dfb9Lja/gxGk
	 ZMjxWcn9ubImioTY5hhg/RkWq5DfVPu8dVpk7zdLWbaJ4Mdgn9mJc2HPLSm08L7v6K
	 kSaDK0M9Vnq3A==
From: Pratyush Yadav <pratyush@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>,
	Mike Rapoport <rppt@kernel.org>,
	Pratyush Yadav <pratyush@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Alexander Graf <graf@amazon.com>,
	David Matlack <dmatlack@google.com>,
	David Rientjes <rientjes@google.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Samiullah Khawaja <skhawaja@google.com>,
	Vipin Sharma <vipinsh@google.com>,
	Zhu Yanjun <yanjun.zhu@linux.dev>
Cc: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-doc@vger.kernel.org,
	kexec@lists.infradead.org
Subject: [RFC PATCH 07/10] mm: hugetlb: don't allocate pages already in live update
Date: Sun,  7 Dec 2025 00:02:17 +0100
Message-ID: <20251206230222.853493-8-pratyush@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251206230222.853493-1-pratyush@kernel.org>
References: <20251206230222.853493-1-pratyush@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: yqfeujkzia3f5fp31an339p44fb1p1g4
X-Rspamd-Queue-Id: 7103840012
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1765062230-401721
X-HE-Meta: U2FsdGVkX1+B65Ediwhx3hRcCTd6S5QSxD6Yyvg/MpmkKaeIR13qQWNhl5LehzGTpmC/L/kWYXerLlaRzdt6CxF2lPw90FI+YJnb7ExtTkzl93Q+fSWS1Nvoi9bxKl7qFzfxeWeo8rdV1b4+rDay7vHSS6xXatCPrIY1kIiWoKg+KZBbL+lnU4AZI83IhqyacoEsCT1DaHc+I488DnPi+I6eIqPFYW2YsvwbAoORhD23QNKB3v+ug2kpvScH1nvRxeFC1CuSD00x/D/5yvm//8SQ5GERI5omohwt9adYYGXUuJOwYkWobmfOWo51XhaLAZWSRHVKMm+XYiYP7Bz6yyNr9VCJtTo0u/YnzW7CwUxx6qzdEh41MqTzLJ6vCrzOOiTfVo1vClB0Rq3bKTnB1Wk8okE53KOkq6/F4tHdezrLQSnmhSVMQM1bkbPEsHWCDnZgGK1i5ksXX4KSm8P8FEk/NA3O8tEfKjZen79MsMRbDEWJOIdt2RKM/wd1shtAFLElBWpvbmIM80VMwGzVbiYyia2Stm/868VawF+P6ve2DSgQvTkldIuUghN3V6CrLyMHy9uK1GThEjrYhZ76qqMIPqWwaPjqeRZkqeTZmHmnPA7bi7tcD8tJ1k1C1jKpgNS8XGYGB+Nqt2h3fxLmjtrsXJgxlxgEDMm6y/WVAzXG52UflvAyvJZS+whomu/ehPiRyCZ7pOGwNMmoOtEEJWQni3CemIjruBpj5PIeVAPUKKNFWriSONV9gtuFk8SmMzv+e/6mOAQCUBmII5Sq3RPO/yI24JmvgyxgTwHIb7J9e4GhvputGheneT8dbrMKiaIIRN4+8eHG2x8U76wv3INHHRmM07fk0aaNWjXKnIGEfJa6q6Gh2QW/ckqDy0FjMlRooNw2sipELO18wdV1i0XvkB+lQk93HFXskXNYAGh0fHa/hpQ0rBZYVoZRdTd1yu/IOUvztZ/DlZm+hzV
 kZQyv8N5
 /9eDgBCiMfkt4jMr/ErSVUyIgLdqp0kvcR68nICKaFEB8c5wMxjcUCAsUgn5KXTVtk/z/XDgwm7ZNc0oIrXfMSlvNx39ZsI9PjzsfjWBNElc3A3ybCOFXZOX2mpsFqQ0EZ0sAnMLJNKFCwT63FSXl0cxFGxSji0bGqqNhNNXYl9kZMEFGhxHOHZULcopB8FziheI+zg6RPrwQeP0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

To support live update for a hugetlb-backed memfd, it is necessary to
track how many pages of each hstate are coming from live update. This is
needed to ensure the boot time allocations don't over-allocate huge
pages, causing the rest of the system unexpected memory pressure.

For example, say the system has 100G memory and it uses 90 1G huge
pages, with 10G put aside for other processes. Now say 5 of those pages
are preserved via KHO for live updating a huge memfd.

But during boot, hugetlb will still see that it needs 90 huge pages, so
it will attempt to allocate those. When the file is later retrieved,
those 5 pages also get added to the huge page pool, resulting in 95
total huge pages. This exceeds the original expectation of 90 pages, and
ends up wasting memory.

Check the number of hugepages for the hstate already coming from live
update using hstate_liveupdate_pages(). Subtract that number from
h->max_huge_pages and pass that to the allocation functions. The
allocation functions currently directly use h->max_huge_pages, so update
them to take a parameter for number of pages to allocate instead.

Also update the error and status reporting function to deal with
liveupdated pages, report the right number, and handle errors.

Node-specific allocation is not supported with liveupdate currently.
This is because the liveupdate FLB data does not contain per-node
allocation numbers, so it is not possible to know how many live updated
pages each node has.

Signed-off-by: Pratyush Yadav <pratyush@kernel.org>
---
 mm/hugetlb.c | 79 +++++++++++++++++++++++++++++++++++++++-------------
 1 file changed, 59 insertions(+), 20 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index ff90ceacf62c..22af2e56772e 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -39,6 +39,7 @@
 #include <linux/memory.h>
 #include <linux/mm_inline.h>
 #include <linux/padata.h>
+#include <linux/liveupdate.h>
 
 #include <asm/page.h>
 #include <asm/pgalloc.h>
@@ -64,6 +65,7 @@ struct hstate hstates[HUGE_MAX_HSTATE];
 __initdata nodemask_t hugetlb_bootmem_nodes;
 __initdata struct list_head huge_boot_pages[MAX_NUMNODES];
 static unsigned long hstate_boot_nrinvalid[HUGE_MAX_HSTATE] __initdata;
+static unsigned long hstate_boot_nrliveupdated[HUGE_MAX_HSTATE] __initdata;
 
 /*
  * Due to ordering constraints across the init code for various
@@ -3484,13 +3486,19 @@ static void __init hugetlb_hstate_alloc_pages_onenode(struct hstate *h, int nid)
 	h->max_huge_pages_node[nid] = i;
 }
 
-static bool __init hugetlb_hstate_alloc_pages_specific_nodes(struct hstate *h)
+static bool __init hugetlb_hstate_alloc_pages_specific_nodes(struct hstate *h,
+							     unsigned long liveupdated)
 {
 	int i;
 	bool node_specific_alloc = false;
 
 	for_each_online_node(i) {
 		if (h->max_huge_pages_node[i] > 0) {
+			if (liveupdated) {
+				pr_warn("HugeTLB: node-specific allocation not supported with liveupdate. Defaulting to normal\n");
+				return false;
+			}
+
 			hugetlb_hstate_alloc_pages_onenode(h, i);
 			node_specific_alloc = true;
 		}
@@ -3499,15 +3507,25 @@ static bool __init hugetlb_hstate_alloc_pages_specific_nodes(struct hstate *h)
 	return node_specific_alloc;
 }
 
-static void __init hugetlb_hstate_alloc_pages_errcheck(unsigned long allocated, struct hstate *h)
+static void __init hugetlb_hstate_alloc_pages_errcheck(unsigned long allocated,
+						       unsigned long liveupdated,
+						       struct hstate *h)
 {
-	if (allocated < h->max_huge_pages) {
-		char buf[32];
+	char buf[32];
 
-		string_get_size(huge_page_size(h), 1, STRING_UNITS_2, buf, 32);
+	string_get_size(huge_page_size(h), 1, STRING_UNITS_2, buf, 32);
+
+	if (liveupdated > h->max_huge_pages) {
+		pr_warn("HugeTLB: got %lu of page size %s from liveupdate, requested pages are %lu\n",
+			liveupdated, buf, h->max_huge_pages);
+		h->max_huge_pages = liveupdated;
+	} else  if (liveupdated + allocated < h->max_huge_pages) {
 		pr_warn("HugeTLB: allocating %lu of page size %s failed.  Only allocated %lu hugepages.\n",
-			h->max_huge_pages, buf, allocated);
-		h->max_huge_pages = allocated;
+			h->max_huge_pages - liveupdated, buf, allocated);
+		if (liveupdated)
+			pr_warn("HugeTLB: %lu of page size %s are from liveupdate\n",
+				liveupdated, buf);
+		h->max_huge_pages = allocated + liveupdated;
 	}
 }
 
@@ -3542,11 +3560,12 @@ static void __init hugetlb_pages_alloc_boot_node(unsigned long start, unsigned l
 	prep_and_add_allocated_folios(h, &folio_list);
 }
 
-static unsigned long __init hugetlb_gigantic_pages_alloc_boot(struct hstate *h)
+static unsigned long __init hugetlb_gigantic_pages_alloc_boot(struct hstate *h,
+							      unsigned long nr)
 {
 	unsigned long i;
 
-	for (i = 0; i < h->max_huge_pages; ++i) {
+	for (i = 0; i < nr; ++i) {
 		if (!alloc_bootmem_huge_page(h, NUMA_NO_NODE))
 			break;
 		cond_resched();
@@ -3555,7 +3574,8 @@ static unsigned long __init hugetlb_gigantic_pages_alloc_boot(struct hstate *h)
 	return i;
 }
 
-static unsigned long __init hugetlb_pages_alloc_boot(struct hstate *h)
+static unsigned long __init hugetlb_pages_alloc_boot(struct hstate *h,
+						     unsigned long nr)
 {
 	struct padata_mt_job job = {
 		.fn_arg		= h,
@@ -3594,14 +3614,14 @@ static unsigned long __init hugetlb_pages_alloc_boot(struct hstate *h)
 
 	jiffies_start = jiffies;
 	do {
-		remaining = h->max_huge_pages - h->nr_huge_pages;
+		remaining = nr - h->nr_huge_pages;
 
 		job.start     = h->nr_huge_pages;
 		job.size      = remaining;
 		job.min_chunk = remaining / hugepage_allocation_threads;
 		padata_do_multithreaded(&job);
 
-		if (h->nr_huge_pages == h->max_huge_pages)
+		if (h->nr_huge_pages == nr)
 			break;
 
 		/*
@@ -3612,7 +3632,7 @@ static unsigned long __init hugetlb_pages_alloc_boot(struct hstate *h)
 			break;
 
 		/* Continue if progress was made in last iteration */
-	} while (remaining != (h->max_huge_pages - h->nr_huge_pages));
+	} while (remaining != (nr - h->nr_huge_pages));
 
 	jiffies_end = jiffies;
 
@@ -3636,7 +3656,7 @@ static unsigned long __init hugetlb_pages_alloc_boot(struct hstate *h)
  */
 static void __init hugetlb_hstate_alloc_pages(struct hstate *h)
 {
-	unsigned long allocated;
+	unsigned long allocated, liveupdated, nr_alloc;
 
 	/*
 	 * Skip gigantic hugepages allocation if early CMA
@@ -3648,20 +3668,31 @@ static void __init hugetlb_hstate_alloc_pages(struct hstate *h)
 		return;
 	}
 
-	if (!h->max_huge_pages)
+	/*
+	 * Some huge pages might come from live update. They will get added to
+	 * the hstate when liveupdate retrieves its files. To avoid
+	 * over-allocating, subtract the liveupdated pages from the total number
+	 * of pages to allocate.
+	 */
+	liveupdated = hstate_liveupdate_pages(h);
+	hstate_boot_nrliveupdated[hstate_index(h)] = liveupdated;
+	if (liveupdated >= h->max_huge_pages) {
+		hugetlb_hstate_alloc_pages_errcheck(0, liveupdated, h);
 		return;
+	}
+	nr_alloc = h->max_huge_pages - liveupdated;
 
 	/* do node specific alloc */
-	if (hugetlb_hstate_alloc_pages_specific_nodes(h))
+	if (hugetlb_hstate_alloc_pages_specific_nodes(h, liveupdated))
 		return;
 
 	/* below will do all node balanced alloc */
 	if (hstate_is_gigantic(h))
-		allocated = hugetlb_gigantic_pages_alloc_boot(h);
+		allocated = hugetlb_gigantic_pages_alloc_boot(h, nr_alloc);
 	else
-		allocated = hugetlb_pages_alloc_boot(h);
+		allocated = hugetlb_pages_alloc_boot(h, nr_alloc);
 
-	hugetlb_hstate_alloc_pages_errcheck(allocated, h);
+	hugetlb_hstate_alloc_pages_errcheck(allocated, liveupdated, h);
 }
 
 static void __init hugetlb_init_hstates(void)
@@ -3710,14 +3741,22 @@ static void __init report_hugepages(void)
 	unsigned long nrinvalid;
 
 	for_each_hstate(h) {
+		unsigned long liveupdated;
 		char buf[32];
 
 		nrinvalid = hstate_boot_nrinvalid[hstate_index(h)];
 		h->max_huge_pages -= nrinvalid;
 
 		string_get_size(huge_page_size(h), 1, STRING_UNITS_2, buf, 32);
-		pr_info("HugeTLB: registered %s page size, pre-allocated %ld pages\n",
+		pr_info("HugeTLB: registered %s page size, pre-allocated %ld pages",
 			buf, h->nr_huge_pages);
+
+		liveupdated = hstate_boot_nrliveupdated[hstate_index(h)];
+		if (liveupdated)
+			pr_info(KERN_CONT ", %ld pages from liveupdate\n", liveupdated);
+		else
+			pr_info(KERN_CONT "\n");
+
 		if (nrinvalid)
 			pr_info("HugeTLB: %s page size: %lu invalid page%s discarded\n",
 					buf, nrinvalid, str_plural(nrinvalid));
-- 
2.43.0


