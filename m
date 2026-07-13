Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 24201C44501
	for <linux-mm@archiver.kernel.org>; Mon, 13 Jul 2026 16:30:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AAE126B00A3; Mon, 13 Jul 2026 12:30:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A84D36B00A4; Mon, 13 Jul 2026 12:30:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 926BD6B00C4; Mon, 13 Jul 2026 12:30:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 61B356B00A3
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 12:30:45 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A54161C7FED
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 14:03:00 +0000 (UTC)
X-FDA: 84983919720.26.1E14E19
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf09.hostedemail.com (Postfix) with ESMTP id E85F5140009
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 14:02:58 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="tWYyPQT/";
	spf=pass (imf09.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783951379;
	b=zX2nbmpy6SP039ZmMzljq4EPJWqll4QESNU8RDME9yswl5H9pRW18U0S7SC3GoaIr2sAXN
	CndUtjbOktxp/lyByI9rZFmrqnT6slBMh49HkkjowzunhlNPrr5Oupg2E7OoqYocvfjeoP
	GT5+etiZyLzJZ2LCNNyo278E60Kj9ew=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="tWYyPQT/";
	spf=pass (imf09.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783951379;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8A7faOuZXmEAVIRdtZgLYH7Z0dNhaCCspMFEMiHVhXM=;
	b=OFlLFqH7IggZKnWILYU6r1XM5f+/dT7SgQjmL+ONxzT/EJUCYAMJuXY4KLrrjHWSW28RLM
	rpZCf93TrRuJGwW9MRop/FO0nTU784uCC1QRJSRmkdXvv7ySwH4+Njepitrt2RJiaVl3QU
	4w2jakDr1FF23eYeki/bxbX5IXv+QR4=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id F40312309;
	Mon, 13 Jul 2026 07:02:53 -0700 (PDT)
Received: from e129823.cambridge.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 0A2613F7B4;
	Mon, 13 Jul 2026 07:02:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1783951378; bh=Wb3EDgPFs5yteOunBQrcCkQDf3F9lsz4u6v0rE/RQe8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tWYyPQT/4oiojuix1Q3/fWMtFxNunqtzs/ViWRtTeS8smwkUIPeAKI7T5PLwKwHNU
	 p/T/N5uvmTUBna5JDgL/6rvh2pM3O8oZ1iX8Z2vBH1HHz5yRfhmDcE0pm/IMf9wibZ
	 XCsJzbBdBmYW60FV78EgDKmG1puDET54+GkAgMO8=
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
Subject: [RFC PATCH 31/34] mm/pgtable: optimize pmdp_get() and friends for folded pagetable levels
Date: Mon, 13 Jul 2026 14:56:10 +0100
Message-ID: <20260713135614.1618183-32-yeoreum.yun@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260713135614.1618183-1-yeoreum.yun@arm.com>
References: <20260713135614.1618183-1-yeoreum.yun@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: E85F5140009
X-Stat-Signature: tae7kp1cuqo4yei61okzj44h794izjen
X-HE-Tag: 1783951378-63782
X-HE-Meta: U2FsdGVkX1+Yul238nPVT7cvpwepsdc91lx951j7wYuFhL77z+ne7JXeCr5PC38ronypJheWkBnGlGcb0xzAIjo011dEJoL9/DSfp5o2i63+w3+0x+Uhp11T/Ga6aZ+D0TBjfpAIee9+8sHw39Z5aZ4YeigI/B/Il9h5h/9KOfoU5FXZybUVa3QeXgzUmri9pInN4gvtUjq+VM61+czQGzhzvhDgkGOKEawCCluAvnXHjAjunVFBrSgR4ALErjNDHpM+lZIR/Trz3+yc+zoL803wqYRVcJ3NiSeFRmg5jsSq0IGfgArRIg955UHkR2bRENCaR1PKOIXgu8/zCQk6JnLRXidjrDPa2fC/6Nl+DO8BOl4LvcjIZB6hKYTqbtYNolz2eJY72IuvgORVXC7Fm6CjKDqtqDGqWphuulHABYhLUhQkQhudqjxhyIt+uhCo6NeLE9Xke5biEVG+Nku6Ut6ZlSrGOZ/kOMV9jU9PGMDrNGUF96Ih410Kkd+SuaIGAwDu+NyCihFIJ+8rH49wNEJ0ovGxLF/JK/KQW/kuLXJpOgwMZ1+/Pz54mraEBnIS6yl5Vdy8JRl7duqZqUie933W1XrnraiocsyNyItjNiGf8becQW6i5S2WaGMvpdadX/s+sxqPn32Z/FHZB6BlJiekfOp7DeSTxTe3Cw385DXpc37wwA1lrnN4trZD8Rw0moXwGYaECPk7QTABQ5QKxJ8d0fcaZ2XrM0jm10h9HZj+emyYprmMydgnfZnglg+UkUCMo8U+YdOFk0whzsECiqRGmhfmBHtbwiSxB1ezz/UdbtsX1tt7cBvsljPTz9NBeUmSjF2sx2z+QUrM8TznAwTH68rD5PeYGPbkTxxyhK/JhM3lkRr3Tbbk73wZeSNiusN8QLlsBzuY73q5gqbVTeOsf97oOZnB2mtFJz8FG+3+ztD2HECm06cs6k7yPrfVIpCgNc2VhsIp2CVbWG0
 ojUvLEC1
 KKgWJshEM6JsZDJY997IUHGsy9mSbFE9BHgemoxLXCvZVSP/9MafDE43kLUJ7Ty2QLI7apswSIez2/JXnwQKYNAzQHtgjxq1oW8bRWDUGS/BbXBNM9bVX2k8QKwrp/aXXYidy3xrKTvl4Yfk+45p8nWJaXMQ1GW+wgkQpQHsJZkJ1QTL2NR6m0K8W7dQpl3mWosfMK05w7kQOPSCA7LmRJPtp1BaXp1WIQU5xy7vabT3JrkJN6ABc07cTcDM6W6CcTrJ0fQtlwxZ+CMjjRTqF8K+kgIQbsX/9BquzqvAerifpaQLSxt5xOZjUeM/1R3qR07Hv+94gFu182MfEG5cXEYD/y1XXq3Ah3mldKkJ49fdJwsfgN7IiMeK4qvtT6mszUcY6rFFZoaxYlpU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "David Hildenbrand (Arm)" <david@kernel.org>

Using pmdp_get() and friends in common code on a kernel config with
folded page tables is suboptimal: they default to a READ_ONCE(), forcing
the compiler to actually read that value even though it will not actually
be used afterwards.

This was recently reported by Christophe Leroy [1] and block conversion
of more common code to pmdp_get() and friends.

(using pgdp_get() as one example)

Most of the code ignores the result from pgdp_get() on configs with
folded page tables entirely, as we hardcode:

        pgd_present()==1 && pgd_leaf()==false

Common code will just treat it as a "this is a page table" and call
p4d_offset() or p4d_offset_lockless() for the next lower level, where
we just ignore the obtained pgdp_get() result entirely.

So we can just return a dummy value and avoid any memory reads.

There is a catch, though:

1) If code calls pgd_val() and somehow relies on the data, it would now
   see dummy values. The code really must be aware of folded page table
   levels. Fortunately, code usually ignores pgd_val() completely for
   page tables (with ptdump being one exception when calculating
   effective permissions). We checked + fixed the x86 ptdump mechanism.

2) If code passes the pgd_t to a function that would work on the result,
   it would now see dummy values. The only concern is really passing
   the pgd_t on the stack as a pointer to p4d_offset(). Most code that
   would do that, should actually use p4d_offset_lockless(), which
   handles this properly. We checked + fixed problematic instances.

As an example, this is the generated code for perf_get_page_size() with
PGTABLE_LEVELS=3 on arm64:

Before:
00000000000052a0 <perf_get_page_size>:
    ...
    52dc: d53b4234      mrs     x20, DAIF
    52e0: d50343df      msr     DAIFSet, #0x3
    ...
    52fc: d35e9a69      ubfx    x9, x19, #30, #9        /* pud_offset_lockless() */
    5300: f9403508      ldr     x8, [x8, #0x68]
    5304: f869790a      ldr     x10, [x8, x9, lsl #3]   /* pudp_get() */
    5308: f90007ea      str     x10, [sp, #0x8]
    530c: f8697908      ldr     x8, [x8, x9, lsl #3]    /* pudp_get() */
    ...
    5360: 90000009      adrp    x9, 0x5000 <perf_prepare_sample+0x548>
    5364: 92746908      and     x8, x8, #0x7ffffff000
    5368: d3557675      ubfx    x21, x19, #21, #9       /* pmd_offset_lockless() */
    ...
    5394: f8757ac8      ldr     x8, [x22, x21, lsl #3]  /* pmdp_get() */

After:
0000000000052a0 <perf_get_page_size>:
    ...
    52dc: d53b4234      mrs     x20, DAIF
    52e0: d50343df      msr     DAIFSet, #0x3
    ...                                                 /* no pud_offset_lockless() and pudp_get() */
    5318: 90000009      adrp    x9, 0x5000 <perf_prepare_sample+0x548>
    531c: 92746908      and     x8, x8, #0x7ffffff000
    5320: d3557675      ubfx    x21, x19, #21, #9       /* pmd_offset_lockless() */
    ...
    5334: f8757ac8      ldr     x8, [x22, x21, lsl #3]  /* pmdp_get() */

[1] https://lore.kernel.org/all/0019d675-ce3d-4a5c-89ed-f126c45145c9@kernel.org/

Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
---
 include/asm-generic/pgtable-nop4d.h | 8 ++++++++
 include/asm-generic/pgtable-nopmd.h | 8 ++++++++
 include/asm-generic/pgtable-nopud.h | 8 ++++++++
 3 files changed, 24 insertions(+)

diff --git a/include/asm-generic/pgtable-nop4d.h b/include/asm-generic/pgtable-nop4d.h
index 25c26a587b512..84a529df27ee3 100644
--- a/include/asm-generic/pgtable-nop4d.h
+++ b/include/asm-generic/pgtable-nop4d.h
@@ -31,6 +31,14 @@ static inline bool pgd_leaf(pgd_t pgd)		{ return false; }
 
 #define set_pgd(pgdptr, pgdval)			BUILD_BUG()
 
+static inline pgd_t pgdp_get(pgd_t *p4dp)
+{
+	pgd_t dummy = { 0 };
+
+	return dummy;
+}
+#define pgdp_get pgdp_get
+
 static inline p4d_t *p4d_offset(pgd_t *pgd, unsigned long address)
 {
 	return (p4d_t *)pgd;
diff --git a/include/asm-generic/pgtable-nopmd.h b/include/asm-generic/pgtable-nopmd.h
index 75650fa9111cd..96f3fccd22fda 100644
--- a/include/asm-generic/pgtable-nopmd.h
+++ b/include/asm-generic/pgtable-nopmd.h
@@ -40,6 +40,14 @@ static inline void pud_clear(pud_t *pud)	{ }
 
 #define set_pud(pudptr, pudval)			BUILD_BUG()
 
+static inline pud_t pudp_get(pud_t *pudp)
+{
+	pud_t dummy = { 0 };
+
+	return dummy;
+}
+#define pudp_get pudp_get
+
 static inline pmd_t * pmd_offset(pud_t * pud, unsigned long address)
 {
 	return (pmd_t *)pud;
diff --git a/include/asm-generic/pgtable-nopud.h b/include/asm-generic/pgtable-nopud.h
index b592fff18887a..faa0233bcde80 100644
--- a/include/asm-generic/pgtable-nopud.h
+++ b/include/asm-generic/pgtable-nopud.h
@@ -38,6 +38,14 @@ static inline bool p4d_leaf(p4d_t p4d)		{ return false; }
 
 #define set_p4d(p4dptr, p4dval)			BUILD_BUG()
 
+static inline p4d_t p4dp_get(p4d_t *p4dp)
+{
+	p4d_t dummy = { 0 };
+
+	return dummy;
+}
+#define p4dp_get p4dp_get
+
 static inline pud_t *pud_offset(p4d_t *p4d, unsigned long address)
 {
 	return (pud_t *)p4d;
-- 
LEVI:{C3F47F37-75D8-414A-A8BA-3980EC8A46D7}


