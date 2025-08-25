Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D9AFCC8303F
	for <linux-mm@archiver.kernel.org>; Mon, 25 Aug 2025 20:28:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 36B778E0074; Mon, 25 Aug 2025 16:28:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 31CE88E0038; Mon, 25 Aug 2025 16:28:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1E3BC8E0074; Mon, 25 Aug 2025 16:28:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 077D78E0038
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 16:28:24 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 9E8E11A057A
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 20:28:23 +0000 (UTC)
X-FDA: 83816417286.23.E2DF669
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	by imf03.hostedemail.com (Postfix) with ESMTP id 776F82000B
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 20:28:21 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=BVCpFbD7;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf03.hostedemail.com: domain of maciej.wieczor-retman@intel.com designates 192.198.163.11 as permitted sender) smtp.mailfrom=maciej.wieczor-retman@intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756153701; a=rsa-sha256;
	cv=none;
	b=XsXnfMp5mYzEu8b3uyyyr8s1pZs3YzSjKhnoTZ62gg/Z3c3UIJ55KEOoxsUEkFZp0NRqDE
	Wp1Ia7+naZVfoi9gS0J/2Rwc4foEYd3cplotGaLFTgbRW3ihlB9mPGuk4elBuN5rzIROQU
	O9IHUI2CIiWNe5qzCCrM/c9udHRfYaE=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=BVCpFbD7;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf03.hostedemail.com: domain of maciej.wieczor-retman@intel.com designates 192.198.163.11 as permitted sender) smtp.mailfrom=maciej.wieczor-retman@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756153701;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8Yt/OTgZ/9yEnA4n8YiO4smWuTjOCRRH+QOana0DyvQ=;
	b=DBrC5Zo7w3saFyARln2UOhEW6sBu+oN3FMXig66VBKHLwc6HkjqYc1mATnaQbxNcYyydXh
	ZJlkqtXHkv4DbIjdjiCwkct9lV9qe+pa09AwqCmUH5XOQDhWup8rvoU8PzV2C9GlLq2irF
	po8hP1mOwcMOxN13VnSZLk2WUUiBtPA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1756153701; x=1787689701;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=lO1wQ1uF80MsG8cgULvpACCbJsuEPvTrA5VlE9nVfaY=;
  b=BVCpFbD77G5kGVyyU8uCwnV00XF5Be5KPWwwlZCPDAi5hsNdKs5mHvSj
   7mT+yW0IfNXMU++CkhMM+wXiyTPK5/mrvoV5v9vutqECF27bVgMJuh/DY
   ASewFHhwRumn6dagx44NZsc3MJmDVD8Vwh4LD+R8qSztkiOfKxOnbB0YA
   odkXBNMZG01lkxkW2Obl+ruWzVT+FLdXP6k0xCwP+agcQQuY6Ksuwpqi8
   +OgYo1jJkVdR4UpjJf36OYjkdSluxzFaPynSHRcveptfL3iAh30BamqIn
   QxNH2HmNV6/0wbP1zSEcMTgZhBI0gHgM7UR7Zzl7+vGlnT/gAxVWcAMHE
   g==;
X-CSE-ConnectionGUID: Wu/R9d9mTViMq6akL+LoTg==
X-CSE-MsgGUID: bb4m3QXbQgSG/DNYgI9UsQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11533"; a="68970608"
X-IronPort-AV: E=Sophos;i="6.18,214,1751266800"; 
   d="scan'208";a="68970608"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Aug 2025 13:28:20 -0700
X-CSE-ConnectionGUID: BTOD3xT1SsCYAVcn5cBJcQ==
X-CSE-MsgGUID: Ag3FqLySS2u86QrmhSMmLQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,214,1751266800"; 
   d="scan'208";a="169780435"
Received: from bergbenj-mobl1.ger.corp.intel.com (HELO wieczorr-mobl1.intel.com) ([10.245.245.6])
  by fmviesa008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Aug 2025 13:27:59 -0700
From: Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>
To: sohil.mehta@intel.com,
	baohua@kernel.org,
	david@redhat.com,
	kbingham@kernel.org,
	weixugc@google.com,
	Liam.Howlett@oracle.com,
	alexandre.chartre@oracle.com,
	kas@kernel.org,
	mark.rutland@arm.com,
	trintaeoitogc@gmail.com,
	axelrasmussen@google.com,
	yuanchu@google.com,
	joey.gouly@arm.com,
	samitolvanen@google.com,
	joel.granados@kernel.org,
	graf@amazon.com,
	vincenzo.frascino@arm.com,
	kees@kernel.org,
	ardb@kernel.org,
	thiago.bauermann@linaro.org,
	glider@google.com,
	thuth@redhat.com,
	kuan-ying.lee@canonical.com,
	pasha.tatashin@soleen.com,
	nick.desaulniers+lkml@gmail.com,
	vbabka@suse.cz,
	kaleshsingh@google.com,
	justinstitt@google.com,
	catalin.marinas@arm.com,
	alexander.shishkin@linux.intel.com,
	samuel.holland@sifive.com,
	dave.hansen@linux.intel.com,
	corbet@lwn.net,
	xin@zytor.com,
	dvyukov@google.com,
	tglx@linutronix.de,
	scott@os.amperecomputing.com,
	jason.andryuk@amd.com,
	morbo@google.com,
	nathan@kernel.org,
	lorenzo.stoakes@oracle.com,
	mingo@redhat.com,
	brgerst@gmail.com,
	kristina.martsenko@arm.com,
	bigeasy@linutronix.de,
	luto@kernel.org,
	jgross@suse.com,
	jpoimboe@kernel.org,
	urezki@gmail.com,
	mhocko@suse.com,
	ada.coupriediaz@arm.com,
	hpa@zytor.com,
	maciej.wieczor-retman@intel.com,
	leitao@debian.org,
	peterz@infradead.org,
	wangkefeng.wang@huawei.com,
	surenb@google.com,
	ziy@nvidia.com,
	smostafa@google.com,
	ryabinin.a.a@gmail.com,
	ubizjak@gmail.com,
	jbohac@suse.cz,
	broonie@kernel.org,
	akpm@linux-foundation.org,
	guoweikang.kernel@gmail.com,
	rppt@kernel.org,
	pcc@google.com,
	jan.kiszka@siemens.com,
	nicolas.schier@linux.dev,
	will@kernel.org,
	andreyknvl@gmail.com,
	jhubbard@nvidia.com,
	bp@alien8.de
Cc: x86@kernel.org,
	linux-doc@vger.kernel.org,
	linux-mm@kvack.org,
	llvm@lists.linux.dev,
	linux-kbuild@vger.kernel.org,
	kasan-dev@googlegroups.com,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Subject: [PATCH v5 08/19] x86: Physical address comparisons in fill_p*d/pte
Date: Mon, 25 Aug 2025 22:24:33 +0200
Message-ID: <308f29aa95ebf7b293b6c2970384a2c2b34a64ef.1756151769.git.maciej.wieczor-retman@intel.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <cover.1756151769.git.maciej.wieczor-retman@intel.com>
References: <cover.1756151769.git.maciej.wieczor-retman@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: 776F82000B
X-Stat-Signature: pz6t1qef9tiqpsy1yzoxobcpkxunns7r
X-HE-Tag: 1756153701-444663
X-HE-Meta: U2FsdGVkX1/OnJ0I+l4D4Vjy3mZdlPh3RnIHymx9SIXcHz/hgeT+/o+Vmtq2Mdv1nHWDMMA0HFy5grDhXzqU5xBCbjZRb9hgmSADS16bafQzv9f2yTtHDLoCHfVkNO2dhnP3YRbxwagbjfIfz+YUFFKa6Mvfu/KZ8/NOGdByiZSuctummMjObVZslKaujhoV5rBIIt28nvI9TZQdbNiDkgOCgUK/mWC5adD0ink6rLdivnsIxVGOI+OyYTuYcL/pivrH9sfcEBsJkRnYGeP/QDHf2aPCkuuxM9fF7u/wimDfj34+04u7sng0QpweG3KKQifJjtZrlqew+XHZnDVJgfRiCse6gGRNa6T/t7o/Ixe2xdzFcdy095Q2mmisRjyDvkCJyikO5N9ogLQCxGR6iCk+J2qVr1xojFj+RdWs+s7kYCWq+ZFQTnR/syqy38H0XwNWRPxRsxU7+LKypjSTVmFrOCfhTW4mYJ9t0H3cgw8tJOgcqAjjM5KjxMD9uAyDqvIUBLFaOGFacmi5fsk7/z+UQWuZv5O76ap3D4HttV4IlxGK6bqgz/haLtUOxxg3Wauk2Vynaog8YEPkqlwyyAwhJhE7mtEyBGhrpL2MvGCcq2r0HXz+dyedOrE//pKT/qJBne03KNBqoWvc5tFIzXljBeZXVpFV3doTi7KMR5rIPSNKy/6pcTeVKtv0/I8XkW7bzoh0iHn59dcYRMy0qAO/BDPB4DzB+rHu/qjvH4c0ehLI5ESvjbubmmcgg96pxxYaKUjvNIRV1tcYrkoEDECTFzbSn8neEsDpIkLf/g3l16Cfd5rkIAy0LgrMn+BCFgXLg22DI2E+65PbrXV05ohpL7KRnHNL8lBEY9ndviFispMt96xtLXqSVesJssCe0cGakndihYcY9Ly/BCuTcyMUQtKtahpnSytPSCCnK3QP81G5FmYKWlf+855wYJKPwae4X7hyVfrWC2Qe91Y
 rVQbb/AL
 tk/m9t4tFXGNmgJdpo4MImsZITZF8aoevz6JloqAnAZIfdeWnvQBRdwgBRngQoRHS0HApvuKj3gO5u9YktEgaTPUi8eLc4HfNoar51Y1AUbYeNXJ8Ap66vBwnn8mTo1D5c8F4MqcKOReLobi4HTqlWwMHwuCGBQZQpmMejGG1SlJczaBvBxnPGJnaKCpXJ1Aa7dzZdCpiwmWm5iZQEpm6/30Eb+fhBeZMj5yYxd2/m3XslG77SVGX4yPQFxKld8uAoBlno0PYklRYfWncwWv6mQhCvsC/hBLnQzXfSH3v8xDYia0=
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


