Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6DAFE606A330
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 14:07:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.a=rsa-sha256 header.s=amazoncorp2 header.b=rBfAHPfB
Received: by kanga.kvack.org (Postfix)
	id 9716A6B05B9; Wed, 11 Nov 2026 09:07:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9223E6B05BA; Wed, 11 Nov 2026 09:07:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 811526B05BB; Wed, 11 Nov 2026 09:07:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 57C776B05B9
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 09:07:19 -0500 (EST)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id DE332A0306
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 14:07:18 +0000 (UTC)
X-FDA: 85423015356.03.F278451
Received: from pdx-out-003.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-003.esa.us-west-2.outbound.mail-perimeter.amazon.com [44.246.68.102])
	by imf30.hostedemail.com (Postfix) with ESMTP id AD74080012
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 14:07:16 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=rBfAHPfB;
	spf=pass (imf30.hostedemail.com: domain of "prvs=768118434=farbere@amazon.com" designates 44.246.68.102 as permitted sender) smtp.mailfrom="prvs=768118434=farbere@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794406037;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2nFQxlo0WMfzc/ouZWAGOsuVuCa8LalnVe14afCjtJo=;
	b=qf474qyehKdJJ60ikV7CrvKWXpYbO+PyTN47IzDeF2oDWGeV8K+U1nZ/arJevazja3JoFl
	eIb81Hiic3CBuNhfJlZEwjO6utTZywVCFtT8/RMs1T2EvXKN1yvMNL9nX9pf8urzssXOLT
	I52UHGVMDTp6x52ZEsCoIgr38xL7lvE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794406037;
	b=vLUYiBa6PCXUa3XwEOZByaUBFoY7H8MM6lMMZci9YFioh7CI09aucjSShNQktfSXSZOLcX
	M2P2vJ1to4t7EJHPc8lOrhTpl6DR3Jq6obvJzHcVogPoA1R+UlioKa7KSdQndj9fZXidIi
	n7iKaw7S2ca7UgjSze3su8IrY0JOMUc=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=rBfAHPfB;
	spf=pass (imf30.hostedemail.com: domain of "prvs=768118434=farbere@amazon.com" designates 44.246.68.102 as permitted sender) smtp.mailfrom="prvs=768118434=farbere@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1794406036; x=1825942036;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=2nFQxlo0WMfzc/ouZWAGOsuVuCa8LalnVe14afCjtJo=;
  b=rBfAHPfBfJxqhJM06lOYj7yXt9IFA6+6Mnrz0HWVfIq9fMi9fQ+k9k6Q
   wVgHNsL53SRPl0D0TaM/sAAFHXp4dZsV3mtn2Msu2s9AZoUuUvOKPkLYn
   EvVre1a4OwWgTwNGj3QQ+zo2kI2N2sqH0clNTWZurznbEvMz6MwOUK0HA
   RD7ygwVsfzNuuKvMIknumnHxGr3v1j8HeTqIjL9fPJxRYJ+FSf+XXSEHF
   iTM3vNwAMn2x0kcHemIV44yZFnCaKRb20MoexeXyhlfT3NqEbys9ym2oR
   0ONHH/avAEvtnp/0NhZEW15Fll2hGYyijH+IMd0Uw62K8JCKMo7I+m2Zv
   A==;
X-CSE-ConnectionGUID: 1rvQUTH7Qs29miH1ZlGQ+w==
X-CSE-MsgGUID: PEphMCXXQhe4miT7lqeZrQ==
X-IronPort-AV: E=Sophos;i="6.27,207,1787011200"; 
   d="scan'208";a="33633297"
Received: from ip-10-5-6-203.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.6.203])
  by internal-pdx-out-003.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Nov 2026 14:07:13 +0000
Received: from EX19MTAUWB001.ant.amazon.com [205.251.233.104:15918]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.55.227:2525] with esmtp (Farcaster)
 id d9f5ddbb-985e-42d8-a21a-50778d7c1bf6; Wed, 11 Nov 2026 14:07:12 +0000 (UTC)
X-Farcaster-Flow-ID: d9f5ddbb-985e-42d8-a21a-50778d7c1bf6
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWB001.ant.amazon.com (10.250.64.248) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.56;
 Wed, 11 Nov 2026 14:07:12 +0000
Received: from dev-dsk-farbere-1a-46ecabed.eu-west-1.amazon.com
 (172.19.116.181) by EX19D001UWA001.ant.amazon.com (10.13.138.214) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.56; Wed, 11 Nov 2026
 14:07:08 +0000
From: Eliav Farber <farbere@amazon.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Zi Yan <ziy@nvidia.com>, Baolin Wang
	<baolin.wang@linux.alibaba.com>, Nico Pache <nico.pache@linux.dev>, "Ryan
 Roberts" <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song
	<baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, Usama Arif
	<usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, Thomas Gleixner
	<tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov
	<bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, "H. Peter Anvin"
	<hpa@zytor.com>, <x86@kernel.org>, William Kucharski
	<william.kucharski@linux.dev>, Vishal Moola <vishal.moola@gmail.com>, "Alex
 Williamson" <alex@shazbot.org>, Peter Xu <peterx@redhat.com>,
	<linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>, Eliav Farber
	<farbere@amazon.com>
Subject: [PATCH 2/4] mm: don't report OOM when a huge PMD race blocks a pfn insert
Date: Wed, 11 Nov 2026 14:06:53 +0000
Message-ID: <20261111140655.34281-3-farbere@amazon.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261111140655.34281-1-farbere@amazon.com>
References: <20261111140655.34281-1-farbere@amazon.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: EX19D031UWA002.ant.amazon.com (10.13.139.96) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)
X-Stat-Signature: ymy1xxzmegff68piokcy8b6xr3ep35hi
X-Rspamd-Queue-Id: AD74080012
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794406036-526421
X-HE-Meta: U2FsdGVkX1/Qj/HqPQ+DcbUZrPZ9AUj82HU9cISikjyzAGHymgBx1SMovurEF54uEHWkFmj5FV+lxL5N0TerQQd1c9HUFCnpw/TOCeeEBMw/ZEC1csWZOvXRvVixg1S7ordNFaT47+eVUDOt+ea8D7FTLWajnk6WOD3wXwmjxH+Apob6rOq4gP++jsaGKJYLwLjBuqv42EHK685uRT9Fd5IXBOYP737hzqfkah8AKleJ+U5TZZiiDJVNJGdxSOCoEkgCx9SCvBogTc2CXmfbAkyNQZN9DI1a64nPJdBWLwiJ4W7Yc3EPEcS3CsU5bjQnWkSbSPU5YREbcPVj1Z2qpsD59FJDdBw1GvK2+ziJas4qK4v/ZxC4OTHIC+CIIUAAVfYrXRkl04M2OLWheP+noK328auV3DHO58U3inYHKiQQCKp219IFdjNWWD9YchBj0LNZwpCPjGjFZ9WuGfFSH8JUEMZdHWnCfegU0cxTD2Np22sI2+Z/73d5UbWnRB7gDU7Eh7uOOcaiYCLikPtD3GEEww2+RXD2TclDRSXxNnKzHJLj/n59EbSNrHF8Jl7pTROGBRwJc4hxWIU7lMAaKOfXuj/SOkn/BCm010rYrwT7NQY6qeUarOKZL4kTEh9w2AYpSQHJ+kj/IzqY2T19ghaaO1jpTP6+OIwGIg4bnP2PPXFdFHez0GPpdXvmPzKW7y39Ro1fnWh/nTjWS+uoLm1fsip/RhvsQYpYhQBnhRoaZKxuRmdILXOWLmEKrCvfxCMpgx1Akxlnor4lQ7Q5cDwgQjOvUCSkAZFjwUKELJnwO+Csb40BObpDIrsgb1EWZHl9A49WuaaQo+mXhPyEAFkmM0l0nPmwYQS7bwAG3gGYJMYFTKcQKWzndl9th5s7oq0DOxgmCBF9fMoomXSUsQDM8wZKDaeUf47IloD0bFhCmwWzQirBMQ051g0T0Dr5nFU99wNLp7RoYZLRXVA
 Vr5jbrQN
 ECxqULLmlmYT8HVJzwMZScJbOY6SbW4XTCHsiT5rdeAo/Mv3zSjv78JJd50fCfxhssOVbUyQDA8TPnp2c5BvO9x2iHT1n0uIwVTfQHmUxOTTlembqYUssMDmFYuOpk5fMKlgQERgXVEK9M6VMQ5s/eyjlfc3DruYDVLxkQ34CGhztY1H3wfMokZlZ4nuly/bYVyKHekO+D+G6BpDHrnGE8+0lu5ei0Fr0we56nWBKrBY+GnTzTSTOE/BMmwG6o5U1OV/txNU+zhRqqGdnUXmTnTk9BU97lx/fFIHz7yPUkRndn0s57N2fEPUNg/OjbfHYTjTw3xbmYmdAE36m8RefHyECDyNYICsETCL7XZXYej4yv/LIwtMNkZIght1Wsn6lYMwyTvw4kctJBCZbE5ap1eEOJw+PK0iucqXtTzu1Ms6bRmWFgFFBZ/EHK51ppwAYSdaBV4m18alteOHpF8Xcch5k9TpAR9ArA2c+du+/9t3MV27SQz4byMHoy6dthjy8gqAl0VTfw8rOCJQKmys4pcHe5wIbfMobZ/3fJ6NkCcZZd8rcjJ+jmJzTNZACJ7IgNzyXC4EAqwtuI7sgoj1yfZPvetvSyqg4rto4wHl5NRmMIO68Zw+jD7kjKNMKzEHC/BMrF9QESzOtZ6K5ta2FIMMSMkP7zb2yMIwbVeuNTS/iPqxtOYg9Ho90NLhn9lbofLJF/BKFd5BQsL+2gdJuw0iFJo0MRnnUtdtzKtDRVlsO2J5X10FyEoOwZ3zUolwgX7YFiANpsmXbNThGrsxlZV3I4A==
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

Walk to the PMD first and tell the two cases apart: a failed PTE
allocation stays VM_FAULT_OOM, while a PMD leaf returns VM_FAULT_NOPAGE
so that the access refaults onto the huge entry.

Fixes: f9e54c3a2f5b ("vfio/pci: implement huge_fault support")
Signed-off-by: Eliav Farber <farbere@amazon.com>
---
 mm/memory.c | 19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index 0f54ee0a6d88..b7b89d041f42 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -2866,10 +2866,25 @@ static vm_fault_t insert_pfn(struct vm_area_struct *vma, unsigned long addr,
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
+	pte = pte_alloc_map_lock(mm, pmd, addr, &ptl);
+	if (!pte) {
+		/*
+		 * A concurrent ->huge_fault may have installed a PMD leaf over
+		 * addr, which pte_offset_map_lock() refuses to walk. The
+		 * mapping is fine, so let the access refault instead of
+		 * reporting a failed allocation.
+		 */
+		if (pmd_trans_huge(pmdp_get_lockless(pmd)))
+			return VM_FAULT_NOPAGE;
 		return VM_FAULT_OOM;
+	}
+
 	entry = ptep_get(pte);
 	if (!pte_none(entry)) {
 		if (mkwrite) {
-- 
2.47.3


