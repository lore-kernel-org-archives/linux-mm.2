Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A9B2A606A327
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 05:15:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.a=rsa-sha256 header.s=amazoncorp2 header.b=P94Xi3X4
Received: by kanga.kvack.org (Postfix)
	id C6E236B05B5; Thu, 12 Nov 2026 00:15:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C45906B05B7; Thu, 12 Nov 2026 00:15:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B34606B05B9; Thu, 12 Nov 2026 00:15:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 82DFA6B05B5
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 00:15:04 -0500 (EST)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 21A9C16046A
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 05:15:04 +0000 (UTC)
X-FDA: 85425302928.13.C0624E8
Received: from pdx-out-010.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-010.esa.us-west-2.outbound.mail-perimeter.amazon.com [52.12.53.23])
	by imf20.hostedemail.com (Postfix) with ESMTP id E67721C0004
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 05:15:01 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=P94Xi3X4;
	dmarc=pass (policy=quarantine) header.from=amazon.com;
	spf=pass (imf20.hostedemail.com: domain of "prvs=76985aab9=farbere@amazon.com" designates 52.12.53.23 as permitted sender) smtp.mailfrom="prvs=76985aab9=farbere@amazon.com"
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794460502;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8rfSGSkxIfkOmnWsHXfluOeh5Z9UW/hnjrCjmA9e3OM=;
	b=ft6z9F9obnwOujPZLyPR5HZHiIYJnypcQ1ywwd2T7LVKk+AB0lcTjjozxHlahpT+7KwDqt
	KRJPSKkAK9EKJ2TKNoVWStFoPjK8KgDjbl4igGhrN5J3K30m6m4/T+TywMKfpU2vF31FVL
	VuuWFmXAssDiYfmb7Rzrqd/LdB9c5PQ=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=P94Xi3X4;
	dmarc=pass (policy=quarantine) header.from=amazon.com;
	spf=pass (imf20.hostedemail.com: domain of "prvs=76985aab9=farbere@amazon.com" designates 52.12.53.23 as permitted sender) smtp.mailfrom="prvs=76985aab9=farbere@amazon.com"
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794460502;
	b=aU2Zfy0SA9rMUHlao55Mkn8jPeLnNobvZTuMR6s0/LmAgYyXuCrw4mrunfVRHXU5qZIk5j
	2t0SZivlwJu/Ex5wjUMadDOZW5TqfwjwWN7EPPioFxIYen1kjr7MDWlCGUKEEo67oFbNP2
	5/S2wnQR36HoloytSWfEKAhQKdfae8M=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1794460502; x=1825996502;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=8rfSGSkxIfkOmnWsHXfluOeh5Z9UW/hnjrCjmA9e3OM=;
  b=P94Xi3X4YRHyB3KUKD8XLB9hurjep0w49nNT04CqbvcPpo7OeI0xId5f
   1hrQkU4bDwIBiNh5rMswh4ojNC8GPzUfVA5P/2NlGRexN1phY2MFoyrJE
   YrMI+l4ZAyHXXwsgDz/Pd5q4s8qJd5l4FQVL4bi6a611cJwjxV9lwhnq0
   ZyjaYia/ARSwjDFYCESF4eMa4XCcRD3sZwJwFWZ7PNFJeecc1HTtw3XbV
   TDs73RK2TYhoamvibiN8dy/ZI7vJM0UacBMftsftFmhUprsx0kULZUtWH
   tSIVjNcaU7yMLU7JiocId/TLfkp9pm8rHmNvmjuG6kxl1rsUUjiIcMk3S
   Q==;
X-CSE-ConnectionGUID: GF1K5NqyRTKIENaSMqBImQ==
X-CSE-MsgGUID: TOsHFUtKRaOsUsJWXgndgQ==
X-IronPort-AV: E=Sophos;i="6.27,209,1787011200"; 
   d="scan'208";a="33650572"
Received: from ip-10-5-12-219.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.12.219])
  by internal-pdx-out-010.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Nov 2026 05:14:58 +0000
Received: from EX19MTAUWA001.ant.amazon.com [205.251.233.236:2589]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.12.127:2525] with esmtp (Farcaster)
 id a305790e-e190-4555-8e59-2a4cbae2ff0f; Thu, 12 Nov 2026 05:14:58 +0000 (UTC)
X-Farcaster-Flow-ID: a305790e-e190-4555-8e59-2a4cbae2ff0f
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWA001.ant.amazon.com (10.250.64.218) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.56;
 Thu, 12 Nov 2026 05:14:58 +0000
Received: from dev-dsk-farbere-1a-46ecabed.eu-west-1.amazon.com
 (172.19.116.181) by EX19D001UWA001.ant.amazon.com (10.13.138.214) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.56; Thu, 12 Nov 2026
 05:14:53 +0000
From: Eliav Farber <farbere@amazon.com>
To: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand
	<david@kernel.org>, Zi Yan <ziy@nvidia.com>
CC: Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, "Suren
 Baghdasaryan" <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Baolin
 Wang <baolin.wang@linux.alibaba.com>, Nico Pache <nico.pache@linux.dev>,
	"Ryan Roberts" <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry
 Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, Usama Arif
	<usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, Thomas Gleixner
	<tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov
	<bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, "H. Peter Anvin"
	<hpa@zytor.com>, <x86@kernel.org>, William Kucharski
	<william.kucharski@linux.dev>, Vishal Moola <vishal.moola@gmail.com>, "Alex
 Williamson" <alex@shazbot.org>, Matthew Wilcox <willy@infradead.org>, Peter
 Xu <peterx@redhat.com>, "Jose A. Perez de Azpillaga" <azpijr@gmail.com>,
	<linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>, Eliav Farber
	<farbere@amazon.com>
Subject: [PATCH v2 2/4] mm: don't report OOM when a huge PMD race blocks a pfn insert
Date: Thu, 12 Nov 2026 05:14:38 +0000
Message-ID: <20261112051440.16140-3-farbere@amazon.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261112051440.16140-1-farbere@amazon.com>
References: <20261112051440.16140-1-farbere@amazon.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: EX19D031UWC001.ant.amazon.com (10.13.139.241) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: E67721C0004
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: pdk5cbaz9ofirdama33m3o48ed4gaxsp
X-HE-Tag: 1794460501-438837
X-HE-Meta: U2FsdGVkX18u1z3vnrI99jEaYOniwrECm9gQYUySSANVyu8E9S6DGV8F1UqI8EAVIwJbMGP77EQOGojG2ArPzMKh88dhw3L7TTj9apyJv/rA8T9NO3csP6hSx26rvYih9l+RCOiZX9Mmf41/G15FH7dCkDx2sMRDZ+NOsPSkRXy7qOy0uv7EDwuPJuYfas4Rz1xgqKzwU2WtEVPrN4a/Y+uEbmXNyvaymx1ikzniekBXx5+K5Oy/K7b/7qvsLYSYnvnSxi7RQv2gEl1FGM+Ep2tbIrOreBvtU+H9Hv2xoK5gLLn6YUrTC0EMoHdsxrtsDqMz8RzA3zts2f1a0gz/qin+H2muwSO5Tnxb95S/W66yca3cO9bAy9Bc12zIgYYqq2C+wFgLQqUwKZJalojyyMrr+pqx7WLYTtKiNd0VBxs0KT+eL53muH0Cuh9QZsGFiB4ZXToGahtFArz0HmgOuKYNTUbD8rSy4NVk5jLnzmkQ4/j1pXFhWxbNy8gwxON3kRZaRO5K8re+7fOC9fMl1jC9tluohJDG7LdE3Ui/BoTgsx0q09rCSmuXYLlUgbRZrfDyD03E3I/OBAwsmH2NLC+Cac7XbetHX4KaTXIRzVGD95qOXNDwjxHxm3hBZBjtKoQivGSW/LpknFCcxac16yHJLMisyzVXQEVAeM0C94nEcPxZnn8uUCSivkvsQGeGEGS+a0vxsOAfrCnMst7lXTmnTixH5asH8bN2YtANh/ostLoWFNC43Oq1OJlIhvLbv8/FWM/CwmUFezHdcS+HozoVOTocPmlgK3Z11xk3hGA8tLBWIv5ujsnq5qGT2qrbk7pYcTWN+HShVlfEOh0j+3sels7QnbHFH9z9lN4aGOTmFyivdl4Ysg4KoOl+SkpgPfsSMYCj+YeLTPa0da7wxhGz7WL4mSAmsfxkKU1ONpPthwYrbiKHTqfMCa71zaQIFOs2EnCAQTpLscJLe5D
 hN2bsVBH
 yPj45NzCaSnewJ1WvMTv8y4S1JGoGJeiiD8tsp7gVZRPglvJGiGtRPo5w3Ly8PAhw9CinMiEKvQProSM9w9Sq2bulJ5xsGKhsK4tus8SxjYRvQ+i8KtChrA51PffAiEPPSrmuemfUVgkiOpnHuOZYak0uKuz9HZnbnOhQ8rQwfvVk1xQiMYpWrWItaf/Fm9MaCnILdK4T/swqp5pZpjShu/QjkxCQS9dcjhT8WZgOtGmB/BM894P4bsIlKUvMXmbBGAUtRfgWgAMk8gWxfsTKk9YruidCIuE+WjSXqhnCxjd0Ee7cSOhnk/AekxLEoO6WEfvZjTGlIlqX+Z9AtsAlYsGCrtPL0ReA3MA/mxxBwvpDDzIR2zKeI50thoNRjivReQ1D2pnxpp501xW9jbu/M7UDDiQpodzeMVqA74kDbZ5zF2bCH7MObGd4ydgD2UX5AFBI0+Hn+3i4WIr9fPDrkgDX0NvDXTZ784hUlWeF687oV2VsZBGoGrGsj7d9TCYIo4wf6CoTQLYA+f3JcUAO4hn538Y9crJ04HCbmJtmReOH47cUKOoJ00GVeQqqZWlHAQ4n4PoMdu7AOHUspSF7c+RwtQ1OYkIiCXbuRctxJ83gy8GXswdPx8iPMLle6PaXOqOfVhhYHRSsLF7RqGE2iG9wC+q8tXAGPehnYUWA0rb1FE16UWvQZDkPeYcTo1dY2AlB/MGiv+WPjX+AN+YiVa1rxq8KFkzhSN4Z9YqAIFayeZEH6TsHJcFfV+/9oJi0h2pPZIPCZMgIvjmm0nO1ElmsVrxcjis2KJvlOFcLM5XENl0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

insert_pfn() maps the PTE with get_locked_pte() and treats a NULL return
as an allocation failure. pte_offset_map_lock() also returns NULL when
the PMD is a leaf, which a VM_PFNMAP mapping with both ->fault and
->huge_fault can hit: an order-0 fault that passed handle_pte_fault()'s
pmd_none() check can reach insert_pfn() after a concurrent huge fault
installed a PMD leaf over the same address. The task then takes a
VM_FAULT_OOM for a mapping that is perfectly healthy. Changing an mm's
THP policy while another thread faults the same PMD, for example with
prctl(PR_SET_THP_DISABLE), is enough to produce the mixed orders.

get_locked_pte() cannot tell the two apart, because pte_alloc_map_lock()
folds the allocation and the map into one call. Walk to the PMD,
allocate, and map as three steps, so that only a failed allocation
returns VM_FAULT_OOM. A NULL from the map returns VM_FAULT_NOPAGE and
the access refaults, which is what a PMD leaf, a PMD that is not present
and a bad PMD that __pte_offset_map() cleared all want.

Fixes: f9e54c3a2f5b ("vfio/pci: implement huge_fault support")
Signed-off-by: Eliav Farber <farbere@amazon.com>
Suggested-by: Jose A. Perez de Azpillaga <azpijr@gmail.com>
---
v2: Split pte_alloc_map_lock() into pte_alloc() followed by
    pte_offset_map_lock(), so that only a failed allocation returns
    VM_FAULT_OOM and a NULL from the map returns VM_FAULT_NOPAGE. v1
    called pte_alloc_map_lock() and then re-read the PMD with
    pmd_trans_huge() to tell the two apart, which left the non-present
    and bad-PMD cases reported as OOM. Suggested by Jose A. Perez de
    Azpillaga.

 mm/memory.c | 18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index 0f54ee0a6d88..05ae87518206 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -2866,10 +2866,24 @@ static vm_fault_t insert_pfn(struct vm_area_struct *vma, unsigned long addr,
 	struct mm_struct *mm = vma->vm_mm;
 	pte_t *pte, entry;
 	spinlock_t *ptl;
+	pmd_t *pmd;
 
-	pte = get_locked_pte(mm, addr, &ptl);
-	if (!pte)
+	pmd = walk_to_pmd(mm, addr);
+	if (!pmd)
+		return VM_FAULT_OOM;
+
+	if (pte_alloc(mm, pmd))
 		return VM_FAULT_OOM;
+
+	/*
+	 * A concurrent ->huge_fault may have installed a PMD leaf over addr,
+	 * which pte_offset_map_lock() refuses to walk. The mapping is fine, so
+	 * let the access refault instead of reporting a failed allocation.
+	 */
+	pte = pte_offset_map_lock(mm, pmd, addr, &ptl);
+	if (!pte)
+		return VM_FAULT_NOPAGE;
+
 	entry = ptep_get(pte);
 	if (!pte_none(entry)) {
 		if (mkwrite) {
-- 
2.47.3


