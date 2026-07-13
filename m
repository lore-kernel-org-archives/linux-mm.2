Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0308EC43458
	for <linux-mm@archiver.kernel.org>; Mon, 13 Jul 2026 16:28:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 06E816B0113; Mon, 13 Jul 2026 12:28:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 01E2C6B0114; Mon, 13 Jul 2026 12:28:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D8C386B0115; Mon, 13 Jul 2026 12:28:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 9C4646B0114
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 12:28:07 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 73058C05D7
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 13:59:52 +0000 (UTC)
X-FDA: 84983911824.17.ABF3313
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf15.hostedemail.com (Postfix) with ESMTP id C7C33A0003
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 13:59:50 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=ZPr6uIZS;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf15.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783951190;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kYKqDC64EtdDPB+h/buce3AiHZeNWwTAXVj0booe4O0=;
	b=VMsxecrXABr4EXaCXamHQIjoL0vd1aYmU0ql82MYTQtoTWmmECvJnGVbovsg2oyrVfRiRs
	EJ4mRQZnkjJdcs1n6zJ52xkUU8LrbGg40GWGTgPONvYSK+hz/l519Pgf/fC/Z5uh/iMj3V
	l5It/iKwd9OFaERCO2gpNf2O6pmHZM8=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=ZPr6uIZS;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf15.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783951190;
	b=tTsVR79O3ntlz498fg+abBXzt2pFQtZli9HQvx5rM1EdR1c+a5jDiMbhBqwJo83n/nRVqg
	JHTOh6oYBsXjmAxJIXBNiZZQiSLL5EtDhTQjqBeveOtAk5bc1h18s9EgW1rcyeCh16NkKk
	xKQPBChnZr8vfH4WRJVtFnksnEJwaXQ=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id AB7A01DB5;
	Mon, 13 Jul 2026 06:59:45 -0700 (PDT)
Received: from e129823.cambridge.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id B08443F7B4;
	Mon, 13 Jul 2026 06:59:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1783951189; bh=YqnJQyc9CrzYpyp6gWjknvIiJBuEo4b4nmLN5r/zhR4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZPr6uIZSUfuQyR/dBUHjcIk7LcANOKrIDpUnnXvitbMXbT2PO3nSzM8sPM+AmgFSh
	 oEYY6m6leU6Z90DVlRyAPnZWbTAQdvt43qG1RNc/JG10d4j0cTl4zhpHBmeYz/DeiC
	 gY5pxSreFEjqd85ky2RlKPv4w2j6RM2bSTCQi2Ho=
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
Subject: [RFC PATCH 16/34] nios2: mm: use proper set_pXd() for generic compile-time folded patable in vmalloc_fault path
Date: Mon, 13 Jul 2026 14:55:55 +0100
Message-ID: <20260713135614.1618183-17-yeoreum.yun@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260713135614.1618183-1-yeoreum.yun@arm.com>
References: <20260713135614.1618183-1-yeoreum.yun@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: C7C33A0003
X-Stat-Signature: kh7z8iq5ahwa7jdunh3fpd655uc1pit9
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1783951190-584798
X-HE-Meta: U2FsdGVkX18u/DqYkdwXbWa0Zowck9Wm6ZcAtrtj44ApZrSdrUMOLlMv+XjHqAumAzfFmTKtLCIoZEB42ZaZCVeueA58s45zi/tg0IeFYYbr+D6OLugRtUYdTZ5+t62k3pskBmkv++eP+2ZCFT0vQz4ChFb1nLjCLh1mrw5DlNHjkdjlks9L20vhWg0gMtjcV/WyJPK6S7c1ET7liHKV+ZcDYtsZ2HJsF6zSwUweBkJeQTbL2gKV+GlyDCQKGIl3D4e2tfw51gWzc/C9E+0FaYwK+Zehn+4/e8FA5u+Q/VqYTl5JsFrDShYjPcTGJmiq+YoiwE1dKA+DZGXXWdqY2OUX4puluEP2JPBsDZYlpRc+H3CNuEYhJe8AfPob8KRnUIuEXptp/1PQh8eEgRo5tGn8qbJ54Sb6OkpKvZ8KnRjNIXNdPU/khDCYjdfXyXI31SR9a+y4RkTJn6jmPyiylJcGFc4ge2MUeTsiDPT+HJt6H/DnqRK5qA9/0NxZ6QBjf9meVnW04kPIE6bzb5nT1yIKZ3ubU0C9GUl2KWUMtFg2Ot2InkvSvcPbuwsimkIWsJlSxkhRpYGp6/AiPqvY+sKzRGa2TgPs6yEPnMrWma4q9ctSPdCMGF1QMriiDUPcaMCXVpA6kJw/R3KjJfMUiqlRDNNkGj9gtWEaT/7sEEs2YI+YtXO4FujK4DqYeZcj+o1Zkw/nZtd2dbL3sM60yEj0MrlQgEkbUn+5d/G55U4dZOGf3esFC0IpqZ4xwyp83Akul96U4WX1xkZDxtxQn1M2W/mwCMZuPRRmzIAN9iGG5c6IWEySX79zIj1JykN7DwU8L+rR8qrsL8yPAAGoRof2VrMDA99TJHAPXNaM+6kFfvjIAosyFGIN/6Pn1fa6/Si7qLIrtX/jJGHdypVGNBkHKSFGuKr+cL7Eu+RKpIniK/PYlUFZ85pL9ElT3ahW1RIquyngjIBw/6W1wZr
 GPKPMxY2
 p+WvMXKIUP8C5rGAF7+pA74f8UEr0jQeYJnJf/eHC+7bGFikl9YWiilIaSAdOEEljPAUtKDEcTH1tISuSEhE3JHbcGuxugQuhkgSkHQd7V9NNT1W/KLt7Yrond1pII+tb+4JrloG7up0r1aKOT7o5y3LECxa7SbdMyxQpuXW3lTJgSOfQO1znKoZEuEIErzFBtEswnAEFmVX/JcH3Uok8ObogX5301+o1JhDtrbBkkvhezBq/iUA2iJ/3tNafda8wvh7sYwmxo6RyeMHeRp0XcXOb4wfO2bI18l7HKtmmkiucPtQnDWrM0OcOoFrF/brqPy2dZZb4xeeXC/zCzzqV5XPmU+ogHpBAi7gaYpnViHVoXvc=
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

Since nios2's PGTABLE_LEVELS is 2 always, usage set_pmd() instead of
set_pgd() to handle vmalloc_fault case.

There should be no functional change.

Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
---
 arch/nios2/mm/fault.c | 36 ++++++++++++------------------------
 1 file changed, 12 insertions(+), 24 deletions(-)

diff --git a/arch/nios2/mm/fault.c b/arch/nios2/mm/fault.c
index e3fa9c15181df..f67d599115e9e 100644
--- a/arch/nios2/mm/fault.c
+++ b/arch/nios2/mm/fault.c
@@ -227,35 +227,23 @@ asmlinkage void do_page_fault(struct pt_regs *regs, unsigned long cause,
 		 * an interrupt in the middle of a task switch..
 		 */
 		int offset = pgd_index(address);
-		pgd_t *pgd, *pgd_k;
-		p4d_t *p4d, *p4d_k;
-		pud_t *pud, *pud_k;
-		pmd_t *pmd, *pmd_k;
-		pte_t *pte_k;
 
-		pgd = pgd_current + offset;
-		pgd_k = init_mm.pgd + offset;
+		BUILD_BUG_ON(CONFIG_PGTABLE_LEVELS != 2);
 
-		if (!pgd_present(*pgd_k))
-			goto no_context;
-		set_pgd(pgd, *pgd_k);
+		pmd_t *pmdp, *pmdp_k, pmd_k;
+		pte_t *ptep_k;
 
-		p4d = p4d_offset(pgd, address);
-		p4d_k = p4d_offset(pgd_k, address);
-		if (!p4d_present(*p4d_k))
-			goto no_context;
-		pud = pud_offset(p4d, address);
-		pud_k = pud_offset(p4d_k, address);
-		if (!pud_present(*pud_k))
-			goto no_context;
-		pmd = pmd_offset(pud, address);
-		pmd_k = pmd_offset(pud_k, address);
-		if (!pmd_present(*pmd_k))
+		pmdp = (pmd_t *)(pgd_current + offset);
+		pmdp_k = (pmd_t *)(init_mm.pgd + offset);
+		pmd_k = *pmdp_k;
+
+		if (!pmd_present(pmd_k))
 			goto no_context;
-		set_pmd(pmd, *pmd_k);
 
-		pte_k = pte_offset_kernel(pmd_k, address);
-		if (!pte_present(*pte_k))
+		set_pmd(pmdp, pmd_k);
+
+		ptep_k = pte_offset_kernel(pmdp_k, address);
+		if (!pte_present(*ptep_k))
 			goto no_context;
 
 		flush_tlb_kernel_page(address);
-- 
LEVI:{C3F47F37-75D8-414A-A8BA-3980EC8A46D7}


