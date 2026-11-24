Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 841DA606A327
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 13:15:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.a=rsa-sha256 header.s=amazoncorp2 header.b=MKTh0vWg
Received: by kanga.kvack.org (Postfix)
	id B48256B06D1; Tue, 24 Nov 2026 08:15:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B28126B06D2; Tue, 24 Nov 2026 08:15:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A3D0D6B06D2; Tue, 24 Nov 2026 08:15:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6A6436B06CF
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 08:15:32 -0500 (EST)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A8627A87DE
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 13:15:30 +0000 (UTC)
X-FDA: 85470059220.03.4A9B599
Received: from pdx-out-001.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-001.esa.us-west-2.outbound.mail-perimeter.amazon.com [44.245.243.92])
	by imf25.hostedemail.com (Postfix) with ESMTP id 6D24AA000C
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 13:15:28 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=MKTh0vWg;
	dmarc=pass (policy=quarantine) header.from=amazon.com;
	spf=pass (imf25.hostedemail.com: domain of "prvs=7818f1f3e=farbere@amazon.com" designates 44.245.243.92 as permitted sender) smtp.mailfrom="prvs=7818f1f3e=farbere@amazon.com"
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795526128;
	b=IPcGSlKlVCTpzfsjMwTFr1epmetuFJyX+sd3EaASLC8lIPiErDgQ/rTEzPBaYyDTMfHwSQ
	LTdRAQ2QzPoBGK5k7xnIUDRVZlfPlZ4fGBkqH02bFZT3UWQzAxm+z9Otc8ocLKXKkb6qBC
	0L+eyzI04ULZYmEPhD0Fa7DMIFjPTjU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795526128;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VNuS0lBjIFijyu46SepBHc+tPpnYKfW52FKxyqAg/Cw=;
	b=hGDeO3O7SSi3gOAWc/PMNRRzARmme1ZrdJ1Sir35NUuzSD2v4otEJy9R421BXgDHQBnHJs
	0KjuQCkkKzGyK14VmWgX991I/hUX4IBAnE8kLAnS3CIl/Gxh1+V4P3H/XY7hMQY77pqvTr
	Y0/WvuOaUjMHQji8QAzhoI//SgVxxKI=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=MKTh0vWg;
	dmarc=pass (policy=quarantine) header.from=amazon.com;
	spf=pass (imf25.hostedemail.com: domain of "prvs=7818f1f3e=farbere@amazon.com" designates 44.245.243.92 as permitted sender) smtp.mailfrom="prvs=7818f1f3e=farbere@amazon.com"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1795526128; x=1827062128;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=VNuS0lBjIFijyu46SepBHc+tPpnYKfW52FKxyqAg/Cw=;
  b=MKTh0vWgLAJJozKxtvHvmb+3o0BBmXMMNGxNSl5B8AIihBdIZbj6uEWt
   18wXga/txTogOXIsw9Fsaea0GickZggSlXdD4RcQ38W1cVbdvs28/SNf6
   5CtHAjcFBeyAyoA2u1uGpyAuimO2puUuqn0jJ7sOo8vL1oWevk3rAzJId
   71OOSiSucevhHwMA3ydq5WYArUxyODeuNQMA2hS4CaBugOUcznMagPr2Z
   JqifV6qS95FIoq77vLOvZJOKU5PReWrqMCYVh1Nd7bHRyPRkyn6RgzVwe
   Fqm+V96p21z6GYVPprw9l3DQip4eislE3GTRA/Edu2SWarqJyB90LFdTQ
   Q==;
X-CSE-ConnectionGUID: An0KgjPjSQGsqnVwoTzS5Q==
X-CSE-MsgGUID: 5COEIKYLRxmN9KNooaAD5A==
X-IronPort-AV: E=Sophos;i="6.27,230,1787011200"; 
   d="scan'208";a="34527308"
Received: from ip-10-5-9-48.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.9.48])
  by internal-pdx-out-001.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2026 13:15:25 +0000
Received: from EX19MTAUWA001.ant.amazon.com [205.251.233.182:9909]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.8.86:2525] with esmtp (Farcaster)
 id aec97299-e563-4f7d-b58f-1bdd4e0c26b7; Tue, 24 Nov 2026 13:15:24 +0000 (UTC)
X-Farcaster-Flow-ID: aec97299-e563-4f7d-b58f-1bdd4e0c26b7
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWA001.ant.amazon.com (10.250.64.217) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.57;
 Tue, 24 Nov 2026 13:15:24 +0000
Received: from dev-dsk-farbere-1a-46ecabed.eu-west-1.amazon.com
 (172.19.116.181) by EX19D001UWA001.ant.amazon.com (10.13.138.214) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.57; Tue, 24 Nov 2026
 13:15:21 +0000
From: Eliav Farber <farbere@amazon.com>
To: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand
	<david@kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Zi Yan
	<ziy@nvidia.com>
CC: Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, "Suren
 Baghdasaryan" <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Jann Horn
	<jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, Baolin Wang
	<baolin.wang@linux.alibaba.com>, Nico Pache <nico.pache@linux.dev>, "Ryan
 Roberts" <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song
	<baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, Usama Arif
	<usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>,
	<linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>, Eliav Farber
	<farbere@amazon.com>
Subject: [PATCH v3 2/5] mm/huge_memory: check the window and the pfn alignment before inserting
Date: Tue, 24 Nov 2026 13:15:07 +0000
Message-ID: <20261124131510.38745-3-farbere@amazon.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261124131510.38745-1-farbere@amazon.com>
References: <20261124131510.38745-1-farbere@amazon.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: EX19D031UWC004.ant.amazon.com (10.13.139.246) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: oae3areznfriaecorypde7kdc3wxatk4
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 6D24AA000C
X-Rspam-User:
X-HE-Tag: 1795526128-111692
X-HE-Meta: U2FsdGVkX18qINeOZhwVq7CIidpFsherjbdDOmjPg5t+B6JSFDrde8fMQcYf/huu/l9hsc9WVdeOJ/VdySfsZUV2usanNCFFK4+SODuzcmynTqEmww6C+NliZjG3ClpttQ0/7QU+BjX8nlXKJj+usyzsLhL4deP/2gXo2GToKlIYntrx2D+Ps1XTEtwqRY7l5S4Ex4WH8Po22ml6kjFpkkf7b5R74yKCNnCpSM60fnypghVu5gE/1yurpdKu0bcgSGBANnz6d2xmmSfuSWi0WiMIYU1LN7NukW/R5YzDOK+JyVQnih5XeKm95kHBNnvZ/AtPYk9gTEWfNUSninpkn5V+C+PnFZeP5PYRBtoBVcYrSE0Fm189x2wA50c2uJ7o11DO25typY2tGmKvuZvG/eYvBq3bP6xxMW7uq+Qo6KAy6NzkW4GHuqXzxz8PkY2Kbivaw3+IY4BxilzprMtiAyzVIDnEXEyAbbqrv+zt0v/J3q+g6xdJwyvemQv69nfK5y+XMDXzOrA0C9Dz+JRe9x2CYpITUUT8t64THlmbJFpq0a3yvgAefJoGRTcLfSFubUzA9H0rnbvqAN07ESVYHelgMIgAO8VWWnxPxgCzxgX78KmVAinxzvExTu7KrBwC3kHcYBGod+Axf014vSw9Gs2k9ofhQkjM6boSsxUwJ0Wqtx5bvQbwTaqdjlq7Xaw6N/coac/l7tHv3e2rxpJkagkDoLwhkpbnmzSV7tqAi7EjjoAhhuM3tSxCqBL029zDV5bcM+mjEFdh5Z1pffdTK94iDHz5wADrFfWnKjWlIiNXLMOiOBdIfqclEAQC7JvrjsFGWcY+QvhBUUG3mY56ljOwJdZcF52pAj5PzZz7ICqpxujsm6svONnGh+G8EI0Nikx7CTkmRZt+PsdQ8zl3qj1OszBRkbgmQRiO5EoLVSPSUxlRHrDr2Uk0cVhIha/nJs8IHPM0SX1BdzR1s60
 LRTZPLgy
 LaKG9lMt6PHVbUABjNFYoeU7xDE8Muu/wQrRmfNr/6UXhHvdfC+rXbXO4B9v4Sqlo8bYIv+dkXQ/7UQWfiKJQI7ax//uDgKztsDTTfMvCdwEitizIpFLtDRrPVrZPLCi1E+hEon9o019QvSGUxfieWju4NqpWO8Uh9rkOB6yTRN83+5gbafg3Yi4I/luGIKQiKRiSjUp52/3ZqIKKQ15Z1zwIYxaD0g1RqVZYFIY3xn7p8dLL690afcSI5yDB5p9JVsHGWcN+cnImL98j1ao1uP2+pK9xgDXgrsNLv007eam/4Hx1PQHZwbMf5CZdd2pmjrwppdYdDvQAGFaZH/kjxOPEGFHvrEPGKIBL+sRsSnrDCP1b23i+silvRfURQQQ2+2Z9Dlf4A12uMHTt5t1DFCUgpMcaw4MvDguvjT9J15d69iODCyNyIrMEELgk2LIPYjJqXppiE7L9zszJmC84nbkk/sdWWIXnMph+tt+6aV+RarvSlA51uPPusn4jukBTinQJP7ZDAh6Qs2i+6fsRs970B8ik3Ggekg4r8CBU8RgsZK8DRKxyt0oEbOPoY34SuSKsRK7lzMQxaIkXGlVdB6iUQ/gN4dpQiexrAU+1VdTBOFdvYzJKm2RTrKFhsu6DQMyv1wiGDpA/j1u2ar29l+JFQj8Sg3pDCxUXXJOV9eXvb8sqhW66tXoX2os+79fIZEdxG9uTLQtYBbcBSpAP09ekGxPUZtWV5e5rKydq7GgocLr+kp45G5zUfKB8LC5abiJlXf/IPvQlL2XnI7SjfwSP7Y7YqF0FYxdswgiH1eY9j3RTO0xt6e1MNZJEq6zMGMr/CwagIxEXldby1ik8dXiYsn6Av+cGBjAkzSauk80fvIwF/Gyz72ECuotLpjLdpslnYlF1UnBCxDuihlcoc8rod8onMSyBf6bHDgATzFqkOQJEsIvizIPc+tsuwknqyx2Y6T70QOrxPsq08V0JbbTJEsHh
 AXmeKgwh
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

insert_pmd() and insert_pud() check that addr is inside the VMA, but not
that the whole PMD or PUD is. A VMA ending part-way through one gets
mapped past its end. Neither checks the pfn, and pfn_pmd() on x86 rounds
an unaligned pfn down, mapping the wrong memory.

No caller can reach either case today; each checks the geometry first.
The next patch adds vmf_insert_pfn_order(), whose callers do not.

Check both ends of the window, and the pfn alignment in
vmf_insert_pfn_pmd() and vmf_insert_pfn_pud(). Fall back rather than
SIGBUS: a VMA that does not span a whole PMD is ordinary.

Several callers open-code the same test; vfio-pci and nvgrace-gpu share
one as is_aligned_for_order() in a vfio-private header. The callers'
checks stay: some do more than mm can, as device-dax turns a window
failure into SIGBUS and the fsdax check also gates its PMD-order mapping
entry.

Signed-off-by: Eliav Farber <farbere@amazon.com>
---

New in v3. In v2 these checks sat in vmf_insert_pfn_order(), where only
my own callers got them.

 mm/huge_memory.c | 18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 75e8641bf9ff..909db70aeba2 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1630,8 +1630,9 @@ static vm_fault_t insert_pmd(struct vm_area_struct *vma, unsigned long addr,
 	spinlock_t *ptl;
 	pmd_t entry;
 
-	if (addr < vma->vm_start || addr >= vma->vm_end)
-		return VM_FAULT_SIGBUS;
+	/* If the whole PMD doesn't fit in the VMA, fall back to 4KiB pages */
+	if (addr < vma->vm_start || addr + HPAGE_PMD_SIZE > vma->vm_end)
+		return VM_FAULT_FALLBACK;
 
 	if (arch_needs_pgtable_deposit()) {
 		pgtable = pte_alloc_one(vma->vm_mm);
@@ -1729,6 +1730,10 @@ vm_fault_t vmf_insert_pfn_pmd(struct vm_fault *vmf, unsigned long pfn,
 	if (unlikely(is_huge_zero_pfn(pfn)))
 		return VM_FAULT_SIGBUS;
 
+	/* pfn_pmd() would round an unaligned pfn down and map the wrong memory */
+	if (!IS_ALIGNED(pfn, HPAGE_PMD_NR))
+		return VM_FAULT_FALLBACK;
+
 	pfnmap_setup_cachemode_pfn(pfn, &pgprot);
 
 	return insert_pmd(vma, addr, vmf->pmd, fop, pgprot, write);
@@ -1768,8 +1773,9 @@ static vm_fault_t insert_pud(struct vm_area_struct *vma, unsigned long addr,
 	spinlock_t *ptl;
 	pud_t entry;
 
-	if (addr < vma->vm_start || addr >= vma->vm_end)
-		return VM_FAULT_SIGBUS;
+	/* If the whole PUD doesn't fit in the VMA, fall back to smaller pages */
+	if (addr < vma->vm_start || addr + HPAGE_PUD_SIZE > vma->vm_end)
+		return VM_FAULT_FALLBACK;
 
 	ptl = pud_lock(mm, pud);
 	if (!pud_none(*pud)) {
@@ -1842,6 +1848,10 @@ vm_fault_t vmf_insert_pfn_pud(struct vm_fault *vmf, unsigned long pfn,
 						(VM_PFNMAP|VM_MIXEDMAP));
 	BUG_ON((vma->vm_flags & VM_PFNMAP) && vma_is_cow_mapping(vma));
 
+	/* pfn_pud() would round an unaligned pfn down and map the wrong memory */
+	if (!IS_ALIGNED(pfn, HPAGE_PUD_NR))
+		return VM_FAULT_FALLBACK;
+
 	pfnmap_setup_cachemode_pfn(pfn, &pgprot);
 
 	return insert_pud(vma, addr, vmf->pud, fop, pgprot, write);
-- 
2.47.3


