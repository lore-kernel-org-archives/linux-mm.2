Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1AAE2C43458
	for <linux-mm@archiver.kernel.org>; Mon, 13 Jul 2026 16:30:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3F7166B009B; Mon, 13 Jul 2026 12:30:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3CE696B00A1; Mon, 13 Jul 2026 12:30:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2E6E16B00A3; Mon, 13 Jul 2026 12:30:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0BB336B009B
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 12:30:44 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 798CA1C7F1A
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 14:01:20 +0000 (UTC)
X-FDA: 84983915520.10.CF906CC
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf07.hostedemail.com (Postfix) with ESMTP id AEA8F40018
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 14:01:18 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=GAoyiDy3;
	spf=pass (imf07.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783951278;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Mgg4AxTbIvWGpBzw8PA5RCq5W28aRH0DxqHB/NvCldY=;
	b=ZFiJ14Jvea9On2G0mEbir5MV3TT5uDHv5RsWpNUJ4p21OAq5JHuSfvQ61VFFxLWcwwmNnp
	LCrXMkSyTXIQyEjOoZ5+dx3uNdOzRnOXedJLO6cueSb2fY5pRL5B+t9H+qyYmoh5cFuu8F
	GthXI/aCK19xwPu2IOnsfDTiw9DKTn8=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=GAoyiDy3;
	spf=pass (imf07.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783951278;
	b=w3XZLHldcYRYIpTDFYSlRCLYKmHdBoJi58XtCG3dj1BlTgUAMhQvt6W/q2kJKJ2YjmFG/W
	qu+1lhE9gr29RYjLktTW3/XSnPjj9p5ewIJuOu/mKeTucdEbmpZilIsPwExuKNT+eeUWih
	MFjAvCvgMS4jvQd8UzNEzU2My9MF5CE=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 870EA2050;
	Mon, 13 Jul 2026 07:01:13 -0700 (PDT)
Received: from e129823.cambridge.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 9427A3F7B4;
	Mon, 13 Jul 2026 07:01:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1783951277; bh=fo69NRGTbHPdRvMyzMnGDIUWtNXuhxqOSbA3GBc5Vfk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GAoyiDy3vQ1X7bdgWU7XAqeF1NKi8cZXbh0Pcm7PEb8ix60O+FJhN+xRdssvSqs1z
	 QUdqoUMHf+/1uEN0SYPKe9v1SzW67hzTIIH7Bt1jnn7qbYXsKmfGK0AWyBU4GfbNGV
	 9+KtfQlIc1qITAsw0F6XCnotwh3TKW8ydrkXRCY0=
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
Subject: [RFC PATCH 23/34] x86: mm: skip pud setup when using generic compile-time folded pagetable
Date: Mon, 13 Jul 2026 14:56:02 +0100
Message-ID: <20260713135614.1618183-24-yeoreum.yun@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260713135614.1618183-1-yeoreum.yun@arm.com>
References: <20260713135614.1618183-1-yeoreum.yun@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: zh7tmniyqnprheg19fsbtu9pcdk8sd4i
X-Rspamd-Queue-Id: AEA8F40018
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1783951278-240880
X-HE-Meta: U2FsdGVkX18gaanFuSzpW9aibRuJ2xg31UKU/UW9Z0sTpjvOTolcd+IzqEnnYd8zP+4Ghtp2d8AeolOSdt2Uj1GjymC5Hxg/QppjiCmifyiP76FFQ1Mnkx51Bxk0kxm76bWP6y07XCGBMjUw4K3kbp2dBj3DrX2mWkvmtFbxEDeKGSxhJJF6N5JbB5FbbqLdmTk/Ci9QJzVkPwwRsl6y/wD3XR8io0rrbaCaUMl31nxCklYh142mK4A4MQDuEDxPGAWu/NIA77Mhw3C+dQ2ufGM5J8hgTxjnTNpl2D92enFnSjCyxPPtbjuJF5QpIZMuxw6tb4UhPqvy/DHonUKjlxC9hyuDrjjhC/itUzGjKcn20C6f6EieiCsKl+k3Q8Hxo4s95T6fhcZlmj0erRqtp7baaUhKi8XOtcagHaTOBAkpx+3N+duzP4dOjt+duS/wUPkXIpoC/AUr5/uZtzdbU5G75o3eEoZKcZwNqA4VlXSNe+eoTncuqOfMW9f5ocUISdgXcGvxGd/172v9+1/TpXktzoWz3OOwkW19waZNGu9w8L5pG79DQEQ0exXU/fFD+vSyTNOSBeSZi4xdzA5ghQNbqxZecYWMd8OurRRvCCjTKr9OTVULTkUgQzBwmvfXnGyDgU8O6dj7Iciarwze94d8xlBk84bX4s1HMV4552q2byifjj7tnq7kOiVzU4ettEJOBDOb0pZYnWT30lGByGwpQkRtYBEBjQtV5DwGnre46A0C7oN7R/CT1b7FsI2eMYUYC33FKQSENspfk7JiSjqqYCOABl3rehnUnB6cgl7tcS66sv3E6oE0N6YGPPhQ29bGNybua6AjBCZ7ROmBEg1nRarVcFZ5sAijLEisObt4eBj4CZWqP8PFRhxb8xkPfZknEKC8Uu5F7qhHlujzOVkE6JGP8FwWB6/t1XbIBtqPb737Tk4D2sgMdbJ71XT50LqGAm/jpmPYtsQCopw
 a7uPpZZf
 c3+0jrEA+DXNCXr6Uyl3B6mQpT+5/2/vq0ltPBRel1g9JcKsLBu/COoaZ92IkFWirDmJ0X5zCGyw3IcbeU+HhCd7hliXeH4Zr4Ypidrp4hz48IaS9cWIjBa4CmRFJaKWWFKtSjnfw1RTMvpbdQlPge0MwuYsX9s5HnOD9fMl8elZK/V+xPhKRMcjztY+VStbKq7vHuN0VhvxjWYViLidkK6bXLmi6eTr4zZCA8zBYWgrcmK1tHz72KDw7tQdr4GnIDxCKQYIolLjzSA79cUeVT4+6VnsJ8OIs/CW2pIS5M6NmP5EmuQSWshRS7Qw8NQI5gbjN
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

We want to rework how set_pXd() behaves for generic compile-time folded
page tables by disallowing its use and triggering a compile-time error
when it is used improperly, ensuring that the actual first-level set_pXd()
function is used instead.

Therefore, skip collapse_pud_page() and populate_pud() according to
CONFIG_PGTABLE_LEVELS.

There should be no functional change.

Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
---
 arch/x86/mm/pat/set_memory.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/x86/mm/pat/set_memory.c b/arch/x86/mm/pat/set_memory.c
index d023a40a1e034..cffb1cef869cc 100644
--- a/arch/x86/mm/pat/set_memory.c
+++ b/arch/x86/mm/pat/set_memory.c
@@ -1326,7 +1326,7 @@ static int collapse_pud_page(pud_t *pud, unsigned long addr,
 	pmd_t *pmd, first;
 	int i;
 
-	if (!direct_gbpages)
+	if (CONFIG_PGTABLE_LEVELS == 2 || !direct_gbpages)
 		return 0;
 
 	addr &= PUD_MASK;
@@ -1710,7 +1710,8 @@ static int populate_pud(struct cpa_data *cpa, unsigned long start, p4d_t *p4d,
 	/*
 	 * Map everything starting from the Gb boundary, possibly with 1G pages
 	 */
-	while (boot_cpu_has(X86_FEATURE_GBPAGES) && end - start >= PUD_SIZE) {
+	while (CONFIG_PGTABLE_LEVELS > 3 && boot_cpu_has(X86_FEATURE_GBPAGES) &&
+	       end - start >= PUD_SIZE) {
 		set_pud(pud, pud_mkhuge(pfn_pud(cpa->pfn,
 				   canon_pgprot(pud_pgprot))));
 
-- 
LEVI:{C3F47F37-75D8-414A-A8BA-3980EC8A46D7}


