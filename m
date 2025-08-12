Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 635FDC87FCB
	for <linux-mm@archiver.kernel.org>; Tue, 12 Aug 2025 13:28:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 075B58E0133; Tue, 12 Aug 2025 09:28:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 04E1D8E00E5; Tue, 12 Aug 2025 09:28:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E7ED78E0133; Tue, 12 Aug 2025 09:28:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id D79058E00E5
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 09:28:05 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A0F2AC0329
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 13:28:05 +0000 (UTC)
X-FDA: 83768183730.18.580917D
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	by imf06.hostedemail.com (Postfix) with ESMTP id 61A1E18000D
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 13:28:03 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=RWRSvSNu;
	spf=pass (imf06.hostedemail.com: domain of maciej.wieczor-retman@intel.com designates 198.175.65.15 as permitted sender) smtp.mailfrom=maciej.wieczor-retman@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755005283;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8Yt/OTgZ/9yEnA4n8YiO4smWuTjOCRRH+QOana0DyvQ=;
	b=pj3B/Oip6+srbVA3aVvy62VQighIIpc2s6VUqoHpRSx7hJ/krUQG1ZQDbvcBnH7TwC2ewQ
	JT4CBAdqJbEjolcr71heBcEzLjOof4KMMJPnW/EoqMK9FVNODpX9J22jfsB/8eHa6Bbiwu
	QqifkWg5L/LAkpvMuMikGY4lkD1y5hU=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=RWRSvSNu;
	spf=pass (imf06.hostedemail.com: domain of maciej.wieczor-retman@intel.com designates 198.175.65.15 as permitted sender) smtp.mailfrom=maciej.wieczor-retman@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755005283; a=rsa-sha256;
	cv=none;
	b=N4zF653HfdPWR0MJiYOcMhZzwEY/ZTDOBDa0sZanY/fpJYRwmCx2QRLJoLmpo31Xk537gV
	SXM8YgQYkYSV0ODTr65HiP+1Hd0m7Rvj/SSWiJfUET1ro4WTx/Svl6amwwiUm2RXn90ZWa
	oiE8MGrstwmgpUMKubojfjBmhAMRgd0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1755005284; x=1786541284;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=lO1wQ1uF80MsG8cgULvpACCbJsuEPvTrA5VlE9nVfaY=;
  b=RWRSvSNux+R9BDMXkB5Tnu/1Y7qgOJqnGx6Hr+boLqoFPfRoC2f9dVae
   RSSi9kL3L8k/U5Dx5DDDQpNXuSDsLNtO6JKbieQFCFEq9WOxNRT5VAJwh
   atQYqheTeQuR/3zCmRaWthmbCN36hLAQmpWmapnyJ/GicmhC7QTBx1KvD
   PDLm7xrQDwQDwxMk1GXmxHKrjO/hW3cuAWzvBrdB8zdnXb/bmjSQemSAi
   KaJyk0Gb99qwO/ruUP4m2l+brDu0UPFN7APOe3S2e4aWM8qngHtUSFuRf
   ktR/1zvdvH63e/NFmnFSjC3ThuUCa8cdSNnkmSucc8x5g/dJ4Ie0dXaM7
   A==;
X-CSE-ConnectionGUID: K8Bgb5ALR/+py0MARHisnQ==
X-CSE-MsgGUID: fi3VfKyvTwWUZ8tbFNj+Mg==
X-IronPort-AV: E=McAfee;i="6800,10657,11520"; a="60903587"
X-IronPort-AV: E=Sophos;i="6.17,284,1747724400"; 
   d="scan'208";a="60903587"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Aug 2025 06:28:02 -0700
X-CSE-ConnectionGUID: 63q+EOftQWWQMSotLrPagg==
X-CSE-MsgGUID: fl7/gRLpTkieCVLNXAAdgQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,284,1747724400"; 
   d="scan'208";a="165831460"
Received: from vpanait-mobl.ger.corp.intel.com (HELO wieczorr-mobl1.intel.com) ([10.245.245.54])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Aug 2025 06:27:38 -0700
From: Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>
To: nathan@kernel.org,
	arnd@arndb.de,
	broonie@kernel.org,
	Liam.Howlett@oracle.com,
	urezki@gmail.com,
	will@kernel.org,
	kaleshsingh@google.com,
	rppt@kernel.org,
	leitao@debian.org,
	coxu@redhat.com,
	surenb@google.com,
	akpm@linux-foundation.org,
	luto@kernel.org,
	jpoimboe@kernel.org,
	changyuanl@google.com,
	hpa@zytor.com,
	dvyukov@google.com,
	kas@kernel.org,
	corbet@lwn.net,
	vincenzo.frascino@arm.com,
	smostafa@google.com,
	nick.desaulniers+lkml@gmail.com,
	morbo@google.com,
	andreyknvl@gmail.com,
	alexander.shishkin@linux.intel.com,
	thiago.bauermann@linaro.org,
	catalin.marinas@arm.com,
	ryabinin.a.a@gmail.com,
	jan.kiszka@siemens.com,
	jbohac@suse.cz,
	dan.j.williams@intel.com,
	joel.granados@kernel.org,
	baohua@kernel.org,
	kevin.brodsky@arm.com,
	nicolas.schier@linux.dev,
	pcc@google.com,
	andriy.shevchenko@linux.intel.com,
	wei.liu@kernel.org,
	bp@alien8.de,
	ada.coupriediaz@arm.com,
	xin@zytor.com,
	pankaj.gupta@amd.com,
	vbabka@suse.cz,
	glider@google.com,
	jgross@suse.com,
	kees@kernel.org,
	jhubbard@nvidia.com,
	joey.gouly@arm.com,
	ardb@kernel.org,
	thuth@redhat.com,
	pasha.tatashin@soleen.com,
	kristina.martsenko@arm.com,
	bigeasy@linutronix.de,
	maciej.wieczor-retman@intel.com,
	lorenzo.stoakes@oracle.com,
	jason.andryuk@amd.com,
	david@redhat.com,
	graf@amazon.com,
	wangkefeng.wang@huawei.com,
	ziy@nvidia.com,
	mark.rutland@arm.com,
	dave.hansen@linux.intel.com,
	samuel.holland@sifive.com,
	kbingham@kernel.org,
	trintaeoitogc@gmail.com,
	scott@os.amperecomputing.com,
	justinstitt@google.com,
	kuan-ying.lee@canonical.com,
	maz@kernel.org,
	tglx@linutronix.de,
	samitolvanen@google.com,
	mhocko@suse.com,
	nunodasneves@linux.microsoft.com,
	brgerst@gmail.com,
	willy@infradead.org,
	ubizjak@gmail.com,
	peterz@infradead.org,
	mingo@redhat.com,
	sohil.mehta@intel.com
Cc: linux-mm@kvack.org,
	linux-kbuild@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	x86@kernel.org,
	llvm@lists.linux.dev,
	kasan-dev@googlegroups.com,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v4 08/18] x86: Physical address comparisons in fill_p*d/pte
Date: Tue, 12 Aug 2025 15:23:44 +0200
Message-ID: <ef6496efec1b978c0f479a5cc62ff92edce82912.1755004923.git.maciej.wieczor-retman@intel.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <cover.1755004923.git.maciej.wieczor-retman@intel.com>
References: <cover.1755004923.git.maciej.wieczor-retman@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: hbznmgs9m1hhadqhqoaizodp1n6gsexr
X-Rspam-User: 
X-Rspamd-Queue-Id: 61A1E18000D
X-Rspamd-Server: rspam05
X-HE-Tag: 1755005283-998627
X-HE-Meta: U2FsdGVkX1/aUae0E9nLFakbC3enMpm9jZvIGbTbNxZ0HAYzJhUQVmcytz0DA+Ui9WIVJ4lDJbAHELR294+WdaDil6sTvQlQxG7MaetXukgwxt6pIlnGHD/DB6+Uu55z+q6oo5iupLhtFspbld61pcqIFKuo8UOIIU5wPc2RREz3VV/cFeWsPbhJ47eZ3SteLyDcwuqWWOVvtWEZeiX4RgPZ5p5HleOU6pxnOlSr0TrActRQdLQptGhin/ewF9nLOT2c0O9QBhfGpAkS3lsVajyqS6eptar9RPtv54l/8MK6huxBvBzM0yXZq46UA4L1WRvApsfP4j5l9gJeT8aIauT1KpszUDxfTjvJ8YFUfiYxB3V4909chLtEVCreH3LeY17x7lPAszgcXcZXsIg6+fcOWloqS6NINobu0aN+09w71YnMOsegw0fJzIx1BOeX7dipuS9PfwOkSaw7lGOt3tDk/Y4n41b04DEdM7TadU89KzUaNuGwNiUsfxFoAO2IfYalkOScpztbGhANtR6ZcUL9Hao7NWqNIyDy/g8D91rXKaNFJm5MT8KZPrLT/fEPsGr/Vjc+9haq434nfsTqUfiX/oh7Jmr/DkCr7/5ev/QxH4NV+kSXuHCEeoT/QElHH8rco2WzC2HduzqHfnR9rui9sO4j9IrHXy6Broc+qBQKHydBypN5BfEPUxo/yj3Z+t/bcAKMpjd/IloXZ9S7jOoHJ29v3lwQeu20JwlNDj1cZBy1f2QViDuHDpkvvUhuSDARunsc+jf1J9LYaqHDfdNvgtnz4iTnGxS/xiqw/zEkw34mekrk+jOSJ/cQfOkca9Gn+4kmzyzRrpPIp77nMrw8ljiqJYQY+cDQ2UZoSaceAuhsE6GmCyhLFXADZT0r7QjE4rNW+Sb3dm4QEy4Ij8XOzu+lj7iU38Moo+3vBuhz+2h8h/iGUV94J3m3BM0HtU280btj2cEx3i2j7O3
 WeQFBmTT
 6pEo8DsSFl6ztD2v1hnF7juVI1E4x7N0qYILt1HAsaE8pL3xuw3W8anSjE3RyFgCbLIpQEEYIpqEsMRO1TmyUfPj3d9hDROHNnOVYnrdH+XjCYvcNBmqM5Yj0Tst0pMgaoKnON3G0tQ5SeTXOBjNKpXkb+yHb9Gpnr5HsLIkoHLH5mJ/pBc6aHnZkAPHnBmC+TudZRUoFChH3oxzSEsCRUZ72BTEfHsZXifCPfPg1jZBfzJChpW0UQ3ppanqQ6Ccasb0DMm9/LVhyntxOHana7PdfXxJQMc7gONsBWUOo0nNUrjQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Calculating page offset returns a pointer without a tag. When comparing
the calculated offset to a tagged page pointer an error is raised
because they are not equal.

Change pointer comparisons to physical address comparisons as to avoid
issues with tagged pointers that pointer arithmetic would create. Open
code pte_offset_kernel(), pmd_offset(), pud_offset() and p4d_offset().
Because one parameter is always zero and the rest of the function
insides are enclosed inside __va(), removing that layer lowers the
complexity of final assembly.

Signed-off-by: Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>
---
Changelog v2:
- Open code *_offset() to avoid it's internal __va().

 arch/x86/mm/init_64.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index 76e33bd7c556..51a247e258b1 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -251,7 +251,10 @@ static p4d_t *fill_p4d(pgd_t *pgd, unsigned long vaddr)
 	if (pgd_none(*pgd)) {
 		p4d_t *p4d = (p4d_t *)spp_getpage();
 		pgd_populate(&init_mm, pgd, p4d);
-		if (p4d != p4d_offset(pgd, 0))
+
+		if (__pa(p4d) != (pgtable_l5_enabled() ?
+				  __pa(pgd) :
+				  (unsigned long)pgd_val(*pgd) & PTE_PFN_MASK))
 			printk(KERN_ERR "PAGETABLE BUG #00! %p <-> %p\n",
 			       p4d, p4d_offset(pgd, 0));
 	}
@@ -263,7 +266,7 @@ static pud_t *fill_pud(p4d_t *p4d, unsigned long vaddr)
 	if (p4d_none(*p4d)) {
 		pud_t *pud = (pud_t *)spp_getpage();
 		p4d_populate(&init_mm, p4d, pud);
-		if (pud != pud_offset(p4d, 0))
+		if (__pa(pud) != (p4d_val(*p4d) & p4d_pfn_mask(*p4d)))
 			printk(KERN_ERR "PAGETABLE BUG #01! %p <-> %p\n",
 			       pud, pud_offset(p4d, 0));
 	}
@@ -275,7 +278,7 @@ static pmd_t *fill_pmd(pud_t *pud, unsigned long vaddr)
 	if (pud_none(*pud)) {
 		pmd_t *pmd = (pmd_t *) spp_getpage();
 		pud_populate(&init_mm, pud, pmd);
-		if (pmd != pmd_offset(pud, 0))
+		if (__pa(pmd) != (pud_val(*pud) & pud_pfn_mask(*pud)))
 			printk(KERN_ERR "PAGETABLE BUG #02! %p <-> %p\n",
 			       pmd, pmd_offset(pud, 0));
 	}
@@ -287,7 +290,7 @@ static pte_t *fill_pte(pmd_t *pmd, unsigned long vaddr)
 	if (pmd_none(*pmd)) {
 		pte_t *pte = (pte_t *) spp_getpage();
 		pmd_populate_kernel(&init_mm, pmd, pte);
-		if (pte != pte_offset_kernel(pmd, 0))
+		if (__pa(pte) != (pmd_val(*pmd) & pmd_pfn_mask(*pmd)))
 			printk(KERN_ERR "PAGETABLE BUG #03!\n");
 	}
 	return pte_offset_kernel(pmd, vaddr);
-- 
2.50.1


