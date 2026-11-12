Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 78D9F606A33A
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 05:15:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.a=rsa-sha256 header.s=amazoncorp2 header.b=ieVenugN
Received: by kanga.kvack.org (Postfix)
	id 988776B05B7; Thu, 12 Nov 2026 00:15:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 95FA06B05B9; Thu, 12 Nov 2026 00:15:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 84E2B6B05BA; Thu, 12 Nov 2026 00:15:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 638FF6B05B7
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 00:15:10 -0500 (EST)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D25D2A04E5
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 05:15:09 +0000 (UTC)
X-FDA: 85425303138.15.DD629CD
Received: from pdx-out-012.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-012.esa.us-west-2.outbound.mail-perimeter.amazon.com [35.162.73.231])
	by imf14.hostedemail.com (Postfix) with ESMTP id AA7A5100008
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 05:15:07 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=ieVenugN;
	spf=pass (imf14.hostedemail.com: domain of "prvs=76985aab9=farbere@amazon.com" designates 35.162.73.231 as permitted sender) smtp.mailfrom="prvs=76985aab9=farbere@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794460508;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=k8j/OBe89YYV4DfbOTa44RgiIx6OZueLRbrVytuzecA=;
	b=bSZBDCrpriHcjnGF5yzRyQqdvFMIii/KbtffSNMHBYIKlahvEagoixLkM1pa0sDu54lhtO
	1P1NEPxIZR/TuVmjZqNRlZWrndv4L6CQznpbOgbw3KnFGLyJaZvAHn8a07cwqNzylCuPbP
	zxR2IR5HwsNNIZgBOEyRyFxILyz03w0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794460508;
	b=TovPIXoOEmMyCu/E3m8L3QDeJ+JJUJS6sap9bJKJ+64Bql1/QL5DIJTWYCuselhM2XimbT
	GLvMoT7cfde92aA0cluFiEgSm+ei6GT5WSfWW8CW9N5TpyfwK0d/0K6YmDG7/D0mQ3DGc9
	4pd6ooXEFRoABWMEbV/3nheD8H4DnIg=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=ieVenugN;
	spf=pass (imf14.hostedemail.com: domain of "prvs=76985aab9=farbere@amazon.com" designates 35.162.73.231 as permitted sender) smtp.mailfrom="prvs=76985aab9=farbere@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1794460507; x=1825996507;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=k8j/OBe89YYV4DfbOTa44RgiIx6OZueLRbrVytuzecA=;
  b=ieVenugNQn4RiUwEpRAsy5fR1o7QZ2m+KbsznO5c2XogPMw5lkNi4JbL
   RN8NqgxK01kspQWXR8sq11wsuFU2asFsczYA9KSX0pyQLH2d96Rwk61N9
   cW2YpMNFxTZA5o5xeUyD6iRDwHOUfJgbb2hRoHfL+qryFJlztDgiZ5vdD
   Tgip9G1t5LXT7uKwBq0DjfTA4IeC93iW6Itnzx2l/MYJ6EatpnkCz5pr/
   aVvLoqFEZ2Rhy3uEDxd+CmpELI0oGhe51ez0caHsgmNEKA6lpCyL9t9wK
   o4aljEbCjBvhb8XfwqhmtTSdVdA8BminEdvprOJJwufAWKbKZnZdvIqRy
   g==;
X-CSE-ConnectionGUID: Xs8mvpSKSvuwGfCiYAVX1g==
X-CSE-MsgGUID: wwsc9zVVQE+bwyXN4Eqfmg==
X-IronPort-AV: E=Sophos;i="6.27,209,1787011200"; 
   d="scan'208";a="33593800"
Received: from ip-10-5-9-48.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.9.48])
  by internal-pdx-out-012.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Nov 2026 05:15:03 +0000
Received: from EX19MTAUWC001.ant.amazon.com [205.251.233.53:5388]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.5.141:2525] with esmtp (Farcaster)
 id cd8d8c80-8c0e-49f7-a2f8-97ee32f9de81; Thu, 12 Nov 2026 05:15:02 +0000 (UTC)
X-Farcaster-Flow-ID: cd8d8c80-8c0e-49f7-a2f8-97ee32f9de81
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWC001.ant.amazon.com (10.250.64.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.56;
 Thu, 12 Nov 2026 05:15:02 +0000
Received: from dev-dsk-farbere-1a-46ecabed.eu-west-1.amazon.com
 (172.19.116.181) by EX19D001UWA001.ant.amazon.com (10.13.138.214) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.56; Thu, 12 Nov 2026
 05:14:57 +0000
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
Subject: [PATCH v2 3/4] mm/huge_memory: don't warn when a page table blocks a huge pfn insert
Date: Thu, 12 Nov 2026 05:14:39 +0000
Message-ID: <20261112051440.16140-4-farbere@amazon.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261112051440.16140-1-farbere@amazon.com>
References: <20261112051440.16140-1-farbere@amazon.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: EX19D031UWC001.ant.amazon.com (10.13.139.241) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)
X-Rspamd-Server: rspam06
X-Stat-Signature: rgjnoo4dcepntibt4j7yqzbchjku7nop
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: AA7A5100008
X-Rspam-User: 
X-HE-Tag: 1794460507-423438
X-HE-Meta: U2FsdGVkX18/+t3TfTvCgUxSI7bOhslGyfJAH/mcUWyiE2COsITePoLXpDeKdtnwy+48JIycj3zQtVoi4mkNcN0VZFu0NcOkLgVQsfmeAITx8efl9MI9afXw4Hr6T0bNZRtF9f1uy4p80NJqo8c+i1gK7krgs8bsrPylccfwR4XiZ7MDOgQBhOzpTIrnOvz8R1rcdPmf7jEesjoi280Xm3Gsy0mkZQ323N0xpiHdziDdWlsFhVP20Pwf33W2mN2GHoHo7DxKtcf3gOqGRGoM28UXezQmNGmxsig5Umorwt5VfJgK/fRhBESaY3C9YIpgTeOg5NGg+cApzxfSp5iKKpvZZPfltz6I7Ddkwh6rOqGGpuH3Xfq+C8HIXq1TJGDJzS9tCURMbeCDt5nDpdzZGcl1aDeUy0C+pAJGOkCQorNHsKIVxtxNyMX9Bn4amx7wN+DTbStf8gA0mPbizcgeczrWl0XyeY2YRatfm8v6jDlFThvVVaEe2t82fGzm1xHoj48f09PP9tgF1eFcPs7r4u3M3FQAFpG+G0Lr+Dmgbygbfvq91zIcks3fFo8HOipJ3IMkAoB8l9JKVLp4jSmybhxnh//EVjn9Pj7RCgXZh08D87cuRsLQZ6DL5C75JHu4/j9ifmp78XhDyMvxaL/cmgPqKtCQdi3X8tjZDBT6Ti2pDQJoVe61dM0vpN3tAnyjU+nR+1Ts1+1QILvzp0qUdED5CytB6485aQ/1QoZENCrR5QLt9scYAwu3RSIEuPQfMyzxm0jK8ZMrcOt4OCIaXHH79IjFbU5vooI/OV2H6nCqGhfoqN8GAkGUUF5d1Frn0k9TBs9u//9rVrxeKoflHM9u2I0ykK1c6+rgrOfxON4OsnVLC3G2INB1+iyvncSevwNKi6uKfPNjGGWVBZk+OuR+MPzLdsG+S/YcXpDWl15RI3swz0kIrAzpY6FIj94IlYZ+0oPIz9oCJkwReEu
 Xw5pHE9t
 yeaKVWL5jxQzNtJPr+KmVYG4GFCegbu7RT5K9U6DlAeGKgmX5ENhnA279ILy3FcCRwJhubdtkO6+0U8bPS3KzT095wb8yWwFGvvrc6aaWr6MLwJRVwQlyFHD9V8E+RdkrFph5N6peOE2tNqNQDvlKRWPcqxiwTGe9TJg/xmOcKchTPXkfIu0N8u/bLGviYOHnHGGboVQLotICXW71pgiLinr7Qlqxb3AVoIt66XPP3szhkkZgmSV0ij1sg3cVGv1IjmckBmgk6WlnNI6DEo2ZKRayfjSgCAYY31Hxr2Ko52BZ0RSi3qtyexIWysmhcYMH/wYtUlaiFfJbGIICJ6GaeL8XtFyU1X6l/k3deULOTurEj8OLjyAtrZyfeGKy1ynreb+Fbwtv0DN4YQFlNLrLJmV+R6PlRd3hPQofPLpFtseV5FTjGSr6sun17/tMVYnyXSVH4hqkf7uB7/zzldEiKu/RTHg+hxBdKLZMcUb8SRZ5/mwsULlED4oik4n8EvWURGmKbgro7/IT3Ts+fxmWSV3nsJ8nt1E1yhTtLA/8EPPI1vVeyW3BWmZlroQabNDv8mCywmqvd5zkwYmKdjeRIdMQuvIvEikSyqrhrg7E5zmwleXdyFPMB4KyLpRrM8OgXXSEpXflCGPa0k5G/8aths1eRf4SHrzqJFGlDt+TafpFSL0CTFGuRHjMnXketVf3MyZRMGp+4+OqTZN8enJ+4q0/qkuNX9rOGUmMxn3Zw51IsFXKEuR5TKV5ZVw+CPmRaeO+qQTWlimQOOrrnpBVYZB8A9+IUP7npF90C8oOwnLDF3uNBuwQ6Ab8icXeAbSy5WXJTPhB5WMTEKt2jCrf/tlgnlaZXKHyVxa7
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
Reviewed-by: Jose A. Perez de Azpillaga <azpijr@gmail.com>
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


