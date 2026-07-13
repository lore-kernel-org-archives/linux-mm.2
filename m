Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6A25EC44501
	for <linux-mm@archiver.kernel.org>; Mon, 13 Jul 2026 16:26:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 65DB76B00BB; Mon, 13 Jul 2026 12:26:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5E6C56B00F5; Mon, 13 Jul 2026 12:26:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4AE7D6B00BB; Mon, 13 Jul 2026 12:26:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 18A506B00F0
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 12:26:11 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C1F471A0188
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 14:01:07 +0000 (UTC)
X-FDA: 84983914974.10.7293FC0
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf13.hostedemail.com (Postfix) with ESMTP id 18B2920010
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 14:01:05 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=jQFofxhr;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf13.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783951266;
	b=ROM/FAVlc7J5g6D/SFl3psytRIm0poS5Z9jLLkL5/s2mcX+XwsMeQOGADLIVR68fjCndkk
	7Aevmt3Zy5cDEQK/wshffMqyzfDp02A/ymC4y9FxWe4grHFmLiZvUSStZ2x0OjHGgziUCi
	xYb42HEHjCsZE8sb8O2L892CSJKtEfo=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=jQFofxhr;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf13.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783951266;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XODR0DLFMAasX2k3OQcGxT82RYcB26wTIaaFE1uMq2Q=;
	b=OWmTjomQsEmCREQwlow5noSCtPrzAT3Zl/cCP1f/9RCq5XDlcnguqO/tLZu6bczeglRjuW
	Rigx+9MzQrqOIWxTTQxhISP+j4EeVq+zeeSIyWgm15c+5ZWhrcLaLpjRJYBzZCcKbSreD4
	w9XOmGJWCOKQitV3O6mN/omEmf/3QFQ=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 01BDE1FC7;
	Mon, 13 Jul 2026 07:01:01 -0700 (PDT)
Received: from e129823.cambridge.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 0FC353FAF5;
	Mon, 13 Jul 2026 07:00:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1783951265; bh=3LP3kSBkF9WZ5FN+GThlw2ZrRbb/NM3CavuBMu2UCX8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jQFofxhrlY9xhPCZ1KjOb60Oo8vAAMeW3u9/kR3kEqBO6OD+WGUbi6FH+GoBuTLyI
	 oSdIVLUVAjxaEDlOi7+HOeEkX3qQLhK46xPY7D5gKofzHDHQHSoEVb/gRv4q0kvsfj
	 z/WGz+7bjb/oyahedBcZbasHVxrEPI9iv40gFe5k=
From: Yeoreum Yun <yeoreum.yun@arm.com>
To: linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-mips@vger.kernel.org,
	linux-arch@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	linux-riscv@lists.infradead.org,
	x86@kernel.org,
	linux-mm@kvack.org,
	kasan-dev@googlegroups.com,
	linux-csky@vger.kernel.org,
	linux-m68k@lists.linux-m68k.org,
	linux-openrisc@vger.kernel.org
Cc: david@kernel.org,
	linux@armlinux.org.uk,
	akpm@linux-foundation.org,
	ankur.a.arora@oracle.com,
	rppt@kernel.org,
	linmag7@gmail.com,
	chleroy@kernel.org,
	klarasmodin@gmail.com,
	chenhuacai@kernel.org,
	kernel@xen0n.name,
	kas@kernel.org,
	zhangtianyang@loongson.cn,
	wangyuli@aosc.io,
	tsbogend@alpha.franken.de,
	ljs@kernel.org,
	jgg@ziepe.ca,
	catalin.marinas@arm.com,
	will@kernel.org,
	arnd@arndb.de,
	ryan.roberts@arm.com,
	pasha.tatashin@soleen.com,
	rmclure@linux.ibm.com,
	baolin.wang@linux.alibaba.com,
	tj@kernel.org,
	kevin.brodsky@arm.com,
	anup@brainfault.org,
	atish.patra@linux.dev,
	pjw@kernel.org,
	palmer@dabbelt.com,
	aou@eecs.berkeley.edu,
	alex@ghiti.fr,
	dave.hansen@linux.intel.com,
	luto@kernel.org,
	peterz@infradead.org,
	tglx@kernel.org,
	mingo@redhat.com,
	bp@alien8.de,
	hpa@zytor.com,
	hannes@cmpxchg.org,
	mhocko@kernel.org,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	kasong@tencent.com,
	baohua@kernel.org,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	ryabinin.a.a@gmail.com,
	glider@google.com,
	andreyknvl@gmail.com,
	dvyukov@google.com,
	vincenzo.frascino@arm.com,
	anshuman.khandual@arm.com,
	yang@os.amperecomputing.com,
	chaitanyas.prakash@arm.com,
	ardb@kernel.org,
	guoren@kernel.org,
	yang.li85200@gmail.com,
	viro@zeniv.linux.org.uk,
	dinguyen@kernel.org,
	schuster.simon@siemens-energy.com,
	wangruikang@iscas.ac.cn,
	junhui.liu@pigmoral.tech,
	muchun.song@linux.dev,
	vishal.moola@gmail.com,
	namcao@linutronix.de,
	pavel@kernel.org,
	djbw@kernel.org,
	yu-cheng.yu@intel.com,
	baolu.lu@linux.intel.com,
	Jonathan.Cameron@huawei.com,
	coxu@redhat.com,
	andreas@gaisler.com,
	liam@infradead.org,
	vbabka@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	geert@linux-m68k.org,
	shorne@gmail.com,
	jonas@southpole.se,
	stefan.kristiansson@saunalahti.fi,
	Yeoreum Yun <yeoreum.yun@arm.com>
Subject: [RFC PATCH 22/34] x86: mm: use proper set_pXd() for generic compile-time folded patable in one_md_table_init()
Date: Mon, 13 Jul 2026 14:56:01 +0100
Message-ID: <20260713135614.1618183-23-yeoreum.yun@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260713135614.1618183-1-yeoreum.yun@arm.com>
References: <20260713135614.1618183-1-yeoreum.yun@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 18B2920010
X-Rspam-User: 
X-Stat-Signature: de6j8p5y5ewswxtc1fto9fbys6qnfojq
X-Rspamd-Server: rspam03
X-HE-Tag: 1783951265-848375
X-HE-Meta: U2FsdGVkX1/yuYxvh4Fnta49lnJxSti5tx9sre3dQ3OFxSHUqfc/Un6HA2/WnRf0rapGoMu4ip6bmArbtFPpjsUi+KNrF7otpp8Qk4dfSp7DSEMTqspw5TjdYm9arf+K9zeFSSzm/28FJm3kzZ9WAtherkHDR9aJ79V51ocWkLlvZ2HCago9MErC7bspiuB+7bKyu1g4Zvh/rZ/IkmgAN6dEiEEQxcqN3EcUa3HQX6cDwnUkvS8YgrUGxY98uPpnqjrAEVXlIgBGRIdokAlCKSnnmHTvLqoMTUTYKqrByVZySbvnCVOCSsOTqT3mqRAFwWQJPx2ow6ncJJKpaKCp6liZ4usShdiFNCD7YV3uc6L8UB5huTycyV9sekes6+EnFGloCPH96GLEZwnWQDPq9XG5Q9GVpsdNMpBhutRHAEExVCtHL6ygtF4ggBFtGNuKT2rh1zN+4XgYejogJ100EAjP/C7Yiu6CBTQbDctENBPK2ag2mw2W3kEZ3HjbhOeYU9SJdKYwZPtqBthQi5aN95MXU12XmDQ5z/Vr0UeoxNw45O0KRmYKXpxCNs0+v72lrmUU00IiMqeVwlXR1iWffcn1EHpfOBniuY5pFdE/pp2fOTL16u0mkDi/BDkmoP76FtCpcHLeI3YPoXlsin15jNNpcHggQx1LFxIsorauw81eZ4aoN0V/IIAtaItB/pA9HpTQ8iYYUtdW7zI2SlV2jZt7rbxqnJsTNj+JQK1iYd31diwghs0a68KcnNw+BaMkxRp6uLwswKm8vkHUuUdSb3aZBN+zEEuyiqXjM7AEU0IuMm9dWakLQLy1eOiKa9AumEfvrR2hr0qY9QelGLZPbugg2xNW4ApcXzGoGDrM6bXSBncAWFJKIU5dJxawh+eRBZ2MdeUZDmvZRwl5zE5ELeoiFNfTOQKiFWqALma/FGczGxHWpmNAnusdhEIe+KjsQCee3rfx4PRTiqqN8Kn
 I+HKf/eq
 hHV7kZ0gysDZ/40ohPqSmIwED6R6F+4+LAYTAusLqIJWh27Wz8KUopw/bZaylB6E2JAz0H22Vj6V3cG69C+gFNgNkgzyuGi4MnOHcB4Ccgbi3gAfc8+ejHSKgozDGBhOIECcHxDr+pL9DYV3jXHr/cYIGKQ8v7cbEZrwn98u+MUtgWFb2mXSerni9x1XorRlS9I8mg9iMnUl7B/VY6AtbklO+Eii4dp+MymJCw/vNf1+wrbT21Q/J436ACdrW0w339YAG6sm8M2Vo3lqRD4ZHo2/0zvvuug/hLek+Cecbtfr2na1PfkSgqhAzQTQ2z7IJJpF5hcRAbNMcFem02tomp/eXPf5fQWDuL1g9EEcNraFJQoI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

We want to rework how set_pXd() behaves for generic compile-time folded
page tables by disallowing its use and triggering a compile-time error
when it is used improperly, ensuring that the actual first-level
set_pXd() function is used instead.

Therefore, replace set_pgd() with set_pud() to setup first-level pgtable
in case of X86_PAE.

There should be no functional change.

Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
---
 arch/x86/mm/init_32.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/arch/x86/mm/init_32.c b/arch/x86/mm/init_32.c
index 0908c44d51e6f..690afa27a631b 100644
--- a/arch/x86/mm/init_32.c
+++ b/arch/x86/mm/init_32.c
@@ -70,19 +70,17 @@ static pmd_t * __init one_md_table_init(pgd_t *pgd)
 	pud_t *pud;
 	pmd_t *pmd_table;
 
+	p4d = p4d_offset(pgd, 0);
+	pud = pud_offset(p4d, 0);
 #ifdef CONFIG_X86_PAE
-	if (!(pgd_val(*pgd) & _PAGE_PRESENT)) {
+	if (!(pud_val(*pud) & _PAGE_PRESENT)) {
 		pmd_table = (pmd_t *)alloc_low_page();
-		set_pgd(pgd, __pgd(__pa(pmd_table) | _PAGE_PRESENT));
-		p4d = p4d_offset(pgd, 0);
-		pud = pud_offset(p4d, 0);
+		set_pud(pud, __pud(__pa(pmd_table) | _PAGE_PRESENT));
 		BUG_ON(pmd_table != pmd_offset(pud, 0));
 
 		return pmd_table;
 	}
 #endif
-	p4d = p4d_offset(pgd, 0);
-	pud = pud_offset(p4d, 0);
 	pmd_table = pmd_offset(pud, 0);
 
 	return pmd_table;
-- 
LEVI:{C3F47F37-75D8-414A-A8BA-3980EC8A46D7}


