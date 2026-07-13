Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BCC8FC44501
	for <linux-mm@archiver.kernel.org>; Mon, 13 Jul 2026 16:25:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 105FC6B00EB; Mon, 13 Jul 2026 12:25:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0B5446B00EC; Mon, 13 Jul 2026 12:25:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EE5C26B00F0; Mon, 13 Jul 2026 12:25:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C71D86B00EB
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 12:25:43 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B86691C7EA1
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 13:58:24 +0000 (UTC)
X-FDA: 84983908128.13.B2CCAAC
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf29.hostedemail.com (Postfix) with ESMTP id E5071120008
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 13:58:22 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=Dz8TsGvo;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf29.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783951103;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eFb4FtDqjOFtSKJuE2vK7ffPsn6ZedHbJe97WX8Cmhg=;
	b=Q9B78OE3V+gp8whYeR1UJjzedKrEnqpKHHx4OxUXDpg2SXjWNBPuaLQqXLp11Vb7B+pdwO
	UjgWMruu+6Qf1kbkdWguXl8xaDZYWU9++eoB9XbRYc1h9uIzAtjTv7pzFC2FUFq6RczQ+8
	QtwHod5/Igya6GZGumxiyD+GA/p6yyw=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=Dz8TsGvo;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf29.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783951103;
	b=4YafeBU1HEKtJNOQh+a9PgvaQ11B9UzymCRmHzwy0Y7cbvudoMYEtyvgM6adk60SIqBdl5
	dzs6KqAJh274+3AcwEVBTETsOaaNx3og4arom90eP8cWGa+pllLXOX35ctOlZ2w9B9yLph
	bkwFspeZm3efuqE1n1RDGianeOo844E=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D47DD1AC1;
	Mon, 13 Jul 2026 06:58:17 -0700 (PDT)
Received: from e129823.cambridge.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id E1DC73F7B4;
	Mon, 13 Jul 2026 06:58:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1783951102; bh=BGsfhjHwglNJ8takg97xfz6u1VYDa2ALCLHL7YdtZVY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Dz8TsGvoiFCjSE9z1oywYVBzDQTRnVTBd1MrzH3foNMVyPE9dAvo6/Vmp2r1CP3Iq
	 dYS8FrDpbH32e1UYPU6fcNuLmNE0xLD77xr5QXu44Aa9wPIPj4v7t5wmVOLYCmlFUF
	 JVFxTL7j0+jeFL2ci92qPOtagM5QvVFicmyJBbgs=
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
Subject: [RFC PATCH 09/34] riscv: kvm: remove stack copy address of pXd in pXd_offset()
Date: Mon, 13 Jul 2026 14:55:48 +0100
Message-ID: <20260713135614.1618183-10-yeoreum.yun@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260713135614.1618183-1-yeoreum.yun@arm.com>
References: <20260713135614.1618183-1-yeoreum.yun@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: E5071120008
X-Stat-Signature: tbd9me7iex3jzkj9p4rqb7tbzenuyy5n
X-Rspam-User: 
X-HE-Tag: 1783951102-138724
X-HE-Meta: U2FsdGVkX1/XWbDRMpdYWe8qudW/mRf30QZnY9i1oWMbj5o9lPr9VE0MCtl7sykv45Jue+tfV7EKCF98Ub9YpYQy+ryl0+uTt4s7oAGRxHYMEJHXol8+8kd25XvVTaX7q1e3urT+jRTzumD5zP10a1z7oz4kYqO+FVbiHWEwMo3GHZQy3lsy++mRtaRNC+dZjNkFWVlZVn3fSiW/8kNaH0DNJ4j1PhqxOdIPDWqdQVmmYDe68MfpsW6ZDidum2cWuaJE5UDxonTD50BxwI528W5+fUaxNoFfVDdP32uUhCITPqmYUgRt0ckx9043Ju2/sU9L2bfK0Je6vVH7mnO1Gr3i+dYVuCUipE7ji6cce55dyaaf1QAVu6nSqbx0rn8eOWAsDjXAC904DiCJnXII2Cu8nnduCIl0AvgQXXuwRj+c0DXR1VQjmasxPaZzPCY5Vw65I5ZH2Os41Yzj5pGuQrpVJcVT87ZR8Xook83IIAN//Ppwwz/W+Zf3KEgWyuSFBEPxzagovxMxhDKRbNNcCq8fKoVDo9T9FOfCBxtWJorpJmN47NDSpsGB1FEOWFhUCv9aiiy4Pkgbg2QukxxeyoLo6b5lSUPftV61/WROkkXDiviah3/gcwEbhbs8KUVpzXBGf8ZDcScTM7uEwz3FPjgsANoCM+fyohAqnGz4a4WenldpIcZaALpkXNAybFAhHevdOlD9gInamefGp2YxDN7Ohk3Cm1Tu6JFt0d+ERGoAATOHEZAyWwfMbltS9TEPXQLbp3ZcHB7NDLPLJPlQDIv6hpiffdv2S7XCpTVA3jITYIoq5sOVr5b7YghMWAeWbuahNByF2w5ZWJvPVy2kDf2waN7XCQkkJ0/wFlrwzGJgsv/eUkw8yQZtCOUJtV58sbkGjj2vKYmcdfmmKQSvvFpz8/kwp2FEQ4Qi8sCGgZXmdNxxftNHHG+RHj3GD/rxHOqcwMf9GFdt60czL2M
 sv8y4dZe
 edeLsMG0C6PvaFmG0IaE/IbaoG7z0WI7bUF8+OysYuR3w0GuZK+pEiTHwutpzBikDmx4fCEfyc/222xmC2mHP8+USmVSkmfbmJLd4ZP1Q8ktgImYLzJZcToEKTo9NB8ApkzBQ6VSrRPvXRxrF1AOGadz4nlyeoYas8id9lE4B4fuhjmCVgPeHOEnykKyH3x3NnnkbK0hShkvhehN24OKhKLa4emOccjwoutvQcHBy6J5eLTcMWkDD44W2ox6J6+F66w4rZSlDonSBHMpsYov+gfZN4snVOM8mIWxbebp9r/ZZmp9USPOahCcWttwF61wwjPRRkOyEERUAQWEdYWyf1iNyEeAl8ugijFJspb1berOZubg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

We want to change how pXdp_get() works with generic compile-time folded
page tables. To prepare for that, rework get_hva_mapping_size() to avoid
use of a stack copy of a pXd and pass it as argument to pXd_offset() so that
the folded entries value is ignored.

Replace direct uses of stack-based pXd values with pXd_offset_lockless()
and there should be no functional change.

Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
---
 arch/riscv/kvm/mmu.c | 20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

diff --git a/arch/riscv/kvm/mmu.c b/arch/riscv/kvm/mmu.c
index 082f9b2617338..6d6042b81d790 100644
--- a/arch/riscv/kvm/mmu.c
+++ b/arch/riscv/kvm/mmu.c
@@ -362,10 +362,10 @@ static int get_hva_mapping_size(struct kvm *kvm,
 {
 	int size = PAGE_SIZE;
 	unsigned long flags;
-	pgd_t pgd;
-	p4d_t p4d;
-	pud_t pud;
-	pmd_t pmd;
+	pgd_t *pgdp, pgd;
+	p4d_t *p4dp, p4d;
+	pud_t *pudp, pud;
+	pmd_t *pmdp, pmd;
 
 	/*
 	 * Disable IRQs to prevent concurrent tear down of host page tables,
@@ -381,15 +381,18 @@ static int get_hva_mapping_size(struct kvm *kvm,
 	 * value) and then p*d_offset() walks into the target huge page instead
 	 * of the old page table (sees the new value).
 	 */
-	pgd = pgdp_get(pgd_offset(kvm->mm, hva));
+	pgdp = pgd_offset(kvm->mm, hva);
+	pgd = pgdp_get(pgdp);
 	if (pgd_none(pgd))
 		goto out;
 
-	p4d = p4dp_get(p4d_offset(&pgd, hva));
+	p4dp = p4d_offset_lockless(pgdp, pgd, hva);
+	p4d = p4dp_get(p4dp);
 	if (p4d_none(p4d) || !p4d_present(p4d))
 		goto out;
 
-	pud = pudp_get(pud_offset(&p4d, hva));
+	pudp = pud_offset_lockless(p4dp, p4d, hva);
+	pud = pudp_get(pudp);
 	if (pud_none(pud) || !pud_present(pud))
 		goto out;
 
@@ -398,7 +401,8 @@ static int get_hva_mapping_size(struct kvm *kvm,
 		goto out;
 	}
 
-	pmd = pmdp_get(pmd_offset(&pud, hva));
+	pmdp = pmd_offset_lockless(pudp, pud, hva);
+	pmd = pmdp_get(pmdp);
 	if (pmd_none(pmd) || !pmd_present(pmd))
 		goto out;
 
-- 
LEVI:{C3F47F37-75D8-414A-A8BA-3980EC8A46D7}


