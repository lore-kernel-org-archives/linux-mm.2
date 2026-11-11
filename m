Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 13A2A606A89E
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 14:07:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.a=rsa-sha256 header.s=amazoncorp2 header.b=cf5LT6pS
Received: by kanga.kvack.org (Postfix)
	id 37EE36B05BB; Wed, 11 Nov 2026 09:07:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 308076B05BC; Wed, 11 Nov 2026 09:07:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1D0A06B05BD; Wed, 11 Nov 2026 09:07:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E57236B05BB
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 09:07:23 -0500 (EST)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 7F3851C34EE
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 14:07:23 +0000 (UTC)
X-FDA: 85423015566.15.2D0E9D4
Received: from pdx-out-011.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-011.esa.us-west-2.outbound.mail-perimeter.amazon.com [52.35.192.45])
	by imf07.hostedemail.com (Postfix) with ESMTP id 569F44000E
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 14:07:21 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=cf5LT6pS;
	spf=pass (imf07.hostedemail.com: domain of "prvs=768118434=farbere@amazon.com" designates 52.35.192.45 as permitted sender) smtp.mailfrom="prvs=768118434=farbere@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794406041;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=S9c0kHmWhtbQRoNZApI47WWaUyszWbsXJ+Tgf0zaouM=;
	b=KUFHbt1ufucTasW1LyYvksC23UDJeCpd3Xq57LKvx/whSq9U6K5jWhiNAYyj2QduDA2bch
	hcv8Y87QeyQUZyonjYMa+WMepF+HrGFH9bumcjaku3oJBJHBaiBirc4PvKEoq7kmj84ohB
	3STbmRPamsN+qQPFTbJf7bl3Veoq0bY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794406041;
	b=jOyFCsFOTXHtYR3tXXl6p079nr8XdhnWV1Cu4GMW2d8mO6xNqHcFClKpimpEqQrEw7X8sY
	V0qgaXJEFLIg9DNgylTSaf1shhB5Rg8jVUGeaFrDhXA/FWitWM+UHILYHzO7SzSeJ0pIWU
	Vb8rBoPtR/GmpFDGvjTvIDUiFmXp430=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=cf5LT6pS;
	spf=pass (imf07.hostedemail.com: domain of "prvs=768118434=farbere@amazon.com" designates 52.35.192.45 as permitted sender) smtp.mailfrom="prvs=768118434=farbere@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1794406041; x=1825942041;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=S9c0kHmWhtbQRoNZApI47WWaUyszWbsXJ+Tgf0zaouM=;
  b=cf5LT6pSkjZKQ/VHjBTRXQl8Hm26ssflXm5wc8k11S8InoyStv/nj+6X
   Qk1p16ExVroXGaxZjDfvVcxslNji1jjacj7FccLQ9utS8JmuKhnicufyx
   NpAL366UxAQW+VE6ijADxJXw1tpUnAByVohfV90xf7LvnXcfiPYqy4RWD
   hYBRxYn+LnIgMbvJbdLMTonzluoUzTypRlXyDyYsiEJbIiQWLjjRpPcuz
   qzcFfmCD8BdO6sT3PFKrTZotdCkFYiPrXlOC7PVJPOI/3QfnqPs40FHJa
   wkRkegKa/1zMH0HT2mx5EIsGXpxsd8SWTo7W22CY0k7SEGgVFt9LY5mD+
   g==;
X-CSE-ConnectionGUID: Rmi/CTU4SR+CRvBDzFrD9w==
X-CSE-MsgGUID: ScqG5yqcSbuqVHkEROIo6w==
X-IronPort-AV: E=Sophos;i="6.27,207,1787011200"; 
   d="scan'208";a="33488621"
Received: from ip-10-5-0-115.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.0.115])
  by internal-pdx-out-011.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Nov 2026 14:07:17 +0000
Received: from EX19MTAUWC002.ant.amazon.com [205.251.233.111:4609]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.46.128:2525] with esmtp (Farcaster)
 id 511131ff-4110-43f7-bbc8-5fbf339e8155; Wed, 11 Nov 2026 14:07:17 +0000 (UTC)
X-Farcaster-Flow-ID: 511131ff-4110-43f7-bbc8-5fbf339e8155
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWC002.ant.amazon.com (10.250.64.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.56;
 Wed, 11 Nov 2026 14:07:16 +0000
Received: from dev-dsk-farbere-1a-46ecabed.eu-west-1.amazon.com
 (172.19.116.181) by EX19D001UWA001.ant.amazon.com (10.13.138.214) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.56; Wed, 11 Nov 2026
 14:07:12 +0000
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
Subject: [PATCH 3/4] mm/huge_memory: don't warn when a page table blocks a huge pfn insert
Date: Wed, 11 Nov 2026 14:06:54 +0000
Message-ID: <20261111140655.34281-4-farbere@amazon.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261111140655.34281-1-farbere@amazon.com>
References: <20261111140655.34281-1-farbere@amazon.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: EX19D031UWA002.ant.amazon.com (10.13.139.96) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: karcsw3pz9ozra511o8n4qi3os8kdac8
X-Rspamd-Queue-Id: 569F44000E
X-Rspam-User: 
X-HE-Tag: 1794406041-776413
X-HE-Meta: U2FsdGVkX18UziUditvw9o3Ts7GJuJG93XdPtVHnhgSy2sgiR7UL63EyvPky//r0MURta8VF6eR2VM/Wc622LXH/v07H5o4cxXvg0nsFK/Ld6dIquWwU8sJByuokhSfxUpOH3QtmkkH0z5yl5FoKkWoTx5Ec/ld5kR/KfcSmpDKD8FJ5V41yTNd/F2pso6odttE15gUMrZqK5FjPBFkRhiFb/lDy+vjV/ZZvWQH3VE92NYE207PY2v0VlCI0Fluoc0RCCCSJaprBNoZonjtObVsUJmb1AERockrU2/yxk1ZIYYOW0dOJy8IMLRQcP3DHdswr/azcXT++e4AsgZ85r8yOBxfqJdtartjipOtsokShq3nKnVe0lc51sMu9msy68SS3CFy9w2/Q44yFApPBmePShMQoDo1wqhuiqf3P7cmW+gLWAGVGcJuaR3NuLPTcM/BxKIDMc19EvfKwV1WdbbZ71mTF0ThRteDjB9+9WM6hiiQvjFXV6RYPi6x9VlIwcKQ0Xz2DFP8tnkj7s5yt2yVfgTSgyYH4T2vY1+rmt2PbjLBQVPXfe13W/ayjlvoLEGWFWoeefGkJVg7Z92ftjcfIlb+4msrleGuhVBt2mZV5HqKXI4o1N9ZcdT4eIN8n7gOUXrz0Sgwhlv1a6GXJBKgYeIIiw9vQXlm4yRocWpKFo16ihcrr6Ahkh5anIC/sRPl6TlEf2pbAC1e6HQ/hwz98i2U4/PahoiyUvdBzVa1vU7e32NdVAT79LmlH5Y7PDf5naVan6DSjnKrHWRoWuV6NsUeeMeCbsvZaRwX6vDtASU7u7y+pozyLa03Fu+QPT4zTk8aS9IjOkqwzvAgzhJl3boEuqO1qXimF5KMNmTIDEmuJOOBDpCHeQUs4m1FyT6152BWedRAkeGnkcqcsmbz/AsAYeozb2sP1iP76ZUuK5Q63RTlYNL9oK5qWFe94t6R9KGaOPq/lT66zHGW
 FN+sGL2C
 aVgjho6zXNMRx1NdNu7h69hjgJb8ZPG1BMG/8sotu3ZCjhPwytrDewMbrQUe5BzZLpQ5Ay3ZkcQJI6Qx9MiLuM9aT/jv3ywBla6tr7wv4GvZ6PirsZCG9yUKeUhMVjOPzqgOpCUNw4N0hV0AzSi8wYVSuTGyazjMKJbuClu5n1YaeqomoYdDuzePuBwPag230G2X986RzedVYKAjcmNoo3ZRfUt1iGEXApDuqtgd7nkxpvsN4DILzEYYs+2cB5QFP89rAo2wb2G5aatKeKLVbIpadd5U8P1AY6eGjwQoWYgUpw7yQiY1ixX4PnrdT8yjq7lXMhnzcRGiMkaSlSwQd52AI2lvA8FXBBHcAGZfwIuPuTDrtW6XLkUTMJOlcELSxp8RdL7vT8rpM0P1OpkOdZpS5Q8n+qg/CPRON7WwL0jgKWq1GUDQh4D29VvbeyV+G8m/Zy1TGozxYCbwxOQPtmK4Do/YPwPL0lN9sF261RWOii60ltX2JNbse3bzReyh2hStSEYzrvmqo/9O9nwH4c9aQEbcUmofEstzkn8WwSNPlIrNi3465Ej8s8qzn27APSC1gZXVy+9cEI8wzA1gsffjhq51HcL19ocXCtcZo/ZYn4/PRjONgFkZQCbSFIsoLCmyYJFhWXmFKFkOcp8nVgWA0awu/BeWN0oJimMZ0pFE1UtYuFNT3EjIfijfybbXEXSlxU+rwgiKJoXaQ47A3STJ+JtkW1wZMIoKDnlhXWxg+OhBo5CdiLpBXn0I9LMbj9D3XzHhPL0M5xKOyrSUn8qtLsz5IotdAolNrrwzaXkg4IAFCsRjQIxyFOlRZIkohWBnR
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

insert_pmd() and insert_pud() treat a non-empty entry at their own level
as a leaf and compare its PFN against the one being inserted. A page
table installed by a concurrent order-0 fault also makes the entry
non-empty, and pmd_pfn()/pud_pfn() then report the PFN of that table,
which never matches. insert_pmd() warns unless the entry is the huge
zero PMD, and insert_pud() warns on any mismatch.

A VM_PFNMAP mapping with both ->fault and ->huge_fault can produce the
mixed orders: an order-0 fault installs a page table over an address
while a concurrent huge fault on the same address reaches insert_pmd().
Changing an mm's THP policy while another thread faults the same PMD,
for example with prctl(PR_SET_THP_DISABLE), is enough to do it.

Compare the PFN only for a leaf entry. A page table is not an error, so
take the existing out_unlock path, which returns VM_FAULT_NOPAGE and
lets the access refault onto the smaller entry.

Fixes: f9e54c3a2f5b ("vfio/pci: implement huge_fault support")
Signed-off-by: Eliav Farber <farbere@amazon.com>
---
 mm/huge_memory.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index eb913acb03b7..052c50dadc48 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1643,6 +1643,14 @@ static vm_fault_t insert_pmd(struct vm_area_struct *vma, unsigned long addr,
 		const unsigned long pfn = fop.is_folio ? folio_pfn(fop.folio) :
 					  fop.pfn;
 
+		/*
+		 * A concurrent order-0 fault may have installed a PTE table
+		 * here, which pmd_pfn() would report as the PFN of the table
+		 * itself. Only a leaf entry can be compared.
+		 */
+		if (!pmd_leaf(*pmd))
+			goto out_unlock;
+
 		if (write) {
 			if (pmd_pfn(*pmd) != pfn) {
 				WARN_ON_ONCE(!is_huge_zero_pmd(*pmd));
@@ -1770,6 +1778,14 @@ static vm_fault_t insert_pud(struct vm_area_struct *vma, unsigned long addr,
 		const unsigned long pfn = fop.is_folio ? folio_pfn(fop.folio) :
 					  fop.pfn;
 
+		/*
+		 * A concurrent order-0 fault may have installed a PMD table
+		 * here, which pud_pfn() would report as the PFN of the table
+		 * itself. Only a leaf entry can be compared.
+		 */
+		if (!pud_leaf(*pud))
+			goto out_unlock;
+
 		if (write) {
 			if (WARN_ON_ONCE(pud_pfn(*pud) != pfn))
 				goto out_unlock;
-- 
2.47.3


