Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BD0D6C43458
	for <linux-mm@archiver.kernel.org>; Mon, 13 Jul 2026 16:24:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D37066B00E2; Mon, 13 Jul 2026 12:24:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CE7A16B00E4; Mon, 13 Jul 2026 12:24:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BB0636B00E5; Mon, 13 Jul 2026 12:24:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8EDDE6B00E2
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 12:24:41 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C2B3D140119
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 13:59:14 +0000 (UTC)
X-FDA: 84983910228.17.08E88C7
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf04.hostedemail.com (Postfix) with ESMTP id 2960940006
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 13:59:13 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=gePevjeD;
	spf=pass (imf04.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783951153;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=alvRB/kEf5KBnIq6vBb2HIbmo6kikR2ueqiQiaekOUs=;
	b=4qAEvwJ443YH1v0l2Ir30SZOA5NJ+aD9fkDmiVGFA0AnHEbM+l6Vbdo0pqU/1GjwzwAPXY
	opH5DeuzmIF/POXrBMCMKmObbCBPdyzk0BatGLuj6zsDiLJVNAfwz+O89EJJ3JH9H5T6y/
	ZZZw7QBTcm9uYN507DT863BaevNmtxc=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=gePevjeD;
	spf=pass (imf04.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783951153;
	b=7Ib21jfOnWeF14NUCyTFG5NVb2Sp6UTT8/8dd35xqoMdYzIDbnYL4n+SWPpQAYMJvrEPqN
	Q4nBcdBeBkX1ofhRW+nRvk0yNCPV9s7Whk2rVaZNx0t1Z1UWKg8CMB7JYCquvv9ECmUgio
	zw7bh9oMVawgyKBZsAqmiLKJH296uHw=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0C33E1C01;
	Mon, 13 Jul 2026 06:59:08 -0700 (PDT)
Received: from e129823.cambridge.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 1A7FD3F7B4;
	Mon, 13 Jul 2026 06:58:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1783951152; bh=+q1+jVG4qiXP8+QAW/pUXiKb/SEJWzXOaTflpzs0DZc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gePevjeDuKLoRMZmfzHjYkzWSKoEGuVpmgjzflwig2lWsm15B2lGzrzuukWVG7sID
	 cbx3Drp/v+dDpqd8T5PLNJBiZyLiQAZB9lO2Q7lXawJekgjfljVLChVm5B9o+4Of6+
	 29N01/WeRa4WzJeB2s2Oht7oYvLM1S/H6/T24fIo=
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
Subject: [RFC PATCH 13/34] arm64: mm: define pud_set_huge() when __PGTABLE_PMD_FOLDED not defined
Date: Mon, 13 Jul 2026 14:55:52 +0100
Message-ID: <20260713135614.1618183-14-yeoreum.yun@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260713135614.1618183-1-yeoreum.yun@arm.com>
References: <20260713135614.1618183-1-yeoreum.yun@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: pw3mcyd1y4ycjyka7pdnso5tp1qspm5z
X-Rspamd-Queue-Id: 2960940006
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1783951153-74347
X-HE-Meta: U2FsdGVkX18sQvjvXdPwbSu4mQMC4jKk6HurwvzIy/m9VO8cAI5pglVN7G3ytpNGY1xy8sMaSidZweUEaMPTbk0XVnDKACXWEp5G3DGeSsN2/ik41SlZ7+yOe3j7+Pz/G9JC7v6Yo8pq3JSiIVklGBlDwgww+KRKYLMMf36MAEerxQalqICUHP5Opfn292vY+ILMsXjyXEmYjbTAo+2/FIFmSNdMh15IHetH8HIwfZ0zC1gXABdykuwaODSKxG1C1TJbl/a1+eEN+wXVcnC8XZT93Lto9n1wcUXhI0T+n2VBC70mL7xFTR2nqJMPoW4ol3bRibeUoEl57/H/o84R9jIgu8K4Ho/noNFero8XLrCcQqsaaKWs79CiC7onofcf29WsC7pmf1dMaMQbVIiE1QbpPbA5/Ur7Z6kBHtcAyKnxCKiLIlFE9GpYPkVoQVoEYqJjBN1ZSyZ83XhwuJ8kUkeh+xTWAiRw2FQJ9l2jlfG649Wtbf8RYocHJuzWwTrCFOd5hGs5Mx9InNGQYbc0IZJ60cllEOwgcAcEGpy21k21Gf1C2X7xzJWFGCzNjMKYRZy8jGiphDBETlC86bfrG7YppE5UGJGmgsRN1lg4HNjNGfLP9sxCV3AhnnDWAuUzStr06s4xmJOakTKnp7GBP63pr+70+TQHvjXkl/OgfZrUzJR3nudjkU0LmIiWn5VPoZU1NbYwGXerd17sZ7mnaBecH6jk9w6OXfDcYvPYqSx56ZW3fkGwcZCwlOQHMfhqvP4oz7lIzpY0VirR6+/bKmo+cC4z43rrfnKi7oojg99MmAmWX3bumcKaQH1Kbe9SgzvUJqVUJlG6kZ7msRCm2nShLs5pDRZ7ka3rhpBO/NEq8WVjGikftI0yelN9u5khZPpTXcMDggw290QkVdHo+4hjp9Yv/fpnpz3E1UbiZRpTkVePUkbf63yV/TLIDRYs6BMqGRAYCLBld3mJqct
 1cOHqHXs
 kSLGqcgRrLnaEZHIo6lSsgIPDLEGgQlNkja1WoBiouXGxY5LgS/BqxMxgl3e8IUi9dtGtNeP/ESz8OcZCI8O1dgMRh/Ty2qGLxEImvt4Q1DpbzyHJ72FJedy75e5Oin3x7C7hUYHLYuIHP0qv8se/KLGUDTePVy8fe5Ym9ftwelYCgSCaKiFBWAhaKpvX3oDc4WhkREEoTPRZriE8pWhcKouMlnPQPCijsn/H/j1fis5iJUqFsBLmO1Pc1F1Ijiiv3GUle95FQ2MM15LfGFNnrQ3Bh31+A8YXXgjAohi5CPmVWyT4RW6yMxXwTeFAnfGpEP9BCYanD0oy2fae3LpU2lx108wTa2DYk0j1VLivAnw7yPs=
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

As using set_pud() is invalid when __PGTABLE_PMD_FOLDED,
pud_set_huge() is also invalid. Therefore, define it when
__PGTABLE_PMD_FOLDED is not defined.

There should be no functional change.

Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
---
 arch/arm64/mm/mmu.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
index f2be501468ce5..194b62c528de9 100644
--- a/arch/arm64/mm/mmu.c
+++ b/arch/arm64/mm/mmu.c
@@ -1807,6 +1807,7 @@ void vmemmap_free(unsigned long start, unsigned long end,
 }
 #endif /* CONFIG_MEMORY_HOTPLUG */
 
+#ifndef __PAGETABLE_PMD_FOLDED
 int pud_set_huge(pud_t *pudp, phys_addr_t phys, pgprot_t prot)
 {
 	pud_t new_pud = pfn_pud(__phys_to_pfn(phys), mk_pud_sect_prot(prot));
@@ -1820,6 +1821,7 @@ int pud_set_huge(pud_t *pudp, phys_addr_t phys, pgprot_t prot)
 	set_pud(pudp, new_pud);
 	return 1;
 }
+#endif
 
 int pmd_set_huge(pmd_t *pmdp, phys_addr_t phys, pgprot_t prot)
 {
-- 
LEVI:{C3F47F37-75D8-414A-A8BA-3980EC8A46D7}


