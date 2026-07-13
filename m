Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7F928C43458
	for <linux-mm@archiver.kernel.org>; Mon, 13 Jul 2026 16:28:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 501BD6B010E; Mon, 13 Jul 2026 12:28:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4D9A16B010F; Mon, 13 Jul 2026 12:28:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3A1FF6B0110; Mon, 13 Jul 2026 12:28:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0A0476B010E
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 12:28:04 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 3173940185
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 13:59:27 +0000 (UTC)
X-FDA: 84983910774.09.F1B49FD
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf05.hostedemail.com (Postfix) with ESMTP id 94131100004
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 13:59:25 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=jDXnfQY+;
	spf=pass (imf05.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783951165;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xGiXDkb4A/KsxOzkzn5Erz3/NI+B1th4FVyYzO+8c40=;
	b=iBpJa0KsRpurGwDq1lkbDiMCNMgLu0iGjtwrt0Zqd6nF1f+oK4i3aPAGQgSBdyPRfagHSL
	F+2W10buASfeaaipN/eziLfYBwbEM2FTZF+iva0N2sQm3ilwiIb3uRWvc8QWEeDtCpjsdt
	LJS9dF49XBUHtEFPXGTrEV7KkRciw34=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=jDXnfQY+;
	spf=pass (imf05.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783951165;
	b=1DjEqKLEgix+Te+LL+10Sp6mim+lQSTCxXgSkXLc5n55DSfHE/4rrTjdR3xUCbfUr3qSfv
	Js8xvw4qMX4yLQylotZd/4MW8b3veVe2twvkK1hUWi7YLYrug+jeTXGNOqEY2HMysfYi8i
	V8OePlioHG09v06PeoVLf4GpoFatvuU=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9058F1CE0;
	Mon, 13 Jul 2026 06:59:20 -0700 (PDT)
Received: from e129823.cambridge.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 9EAB63F7B4;
	Mon, 13 Jul 2026 06:59:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1783951164; bh=fdM8eSOX1vnuRDMyBnXZwm7qppeDWgURrDmpSOBVWR0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jDXnfQY+Em6qUw19QR+A2ZpcQLw1YaP4AJnqCk8v0z4XvE4pF7ZqjOYmqZLgAzlmW
	 J9+MQcHN/tAismdmH0XnV6rUl+JUh5fFUDrudzYvzY6voWv4q0XV1xax1IvfrdY41C
	 KqRnsffjQ/7q71iySWPSNMiArk3b5UNcIT3kGQag=
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
Subject: [RFC PATCH 14/34] csky: mm: use proper set_pXd() for generic compile-time folded patable in vmalloc_fault()
Date: Mon, 13 Jul 2026 14:55:53 +0100
Message-ID: <20260713135614.1618183-15-yeoreum.yun@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260713135614.1618183-1-yeoreum.yun@arm.com>
References: <20260713135614.1618183-1-yeoreum.yun@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 7bmyk13gmefkcrptttc73h8etsrngc3d
X-Rspamd-Queue-Id: 94131100004
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1783951165-306088
X-HE-Meta: U2FsdGVkX1/46fji8quTNuYi+W1KhLhD7LfIHHaXPabGBQPHKQie1b6kZQvmTfqkq1WW7H/Tsc5fwMygCaoVJdTKyUgTA2QtZZSyeplpr1iKNXV+q+ewVgi8R3J7vud0Ja3DNbloDZMxU7CVcyiA/m8QW5eBJeU9jWIlGruXwCJ1LAb222ki/FhPfr3f76DmJEHREPhN9gb+2vA3U+JHuHZY/2EVCV5QFiop0O9KlvRcYqiz9iWrltVBg/h4yVQWa/gTXgKEmOr1lI1FMwa7Vci5IK2wNzwLxosmhpeZbak4ZHJIakQ32My8UULn5zLQ0GoV7dMXtzenWqaXktZmJlEPW+0ocEZjLKl4hFDWIxUkq8kMyEsY0te6J9m+3buQG0BX49Xq6FVk7eXcpYPw6rubrynCuvuDb2cgmId+0nAtE7O36yr6tw0b2uSJO9IuEBmBQMqJpJkgJbligcdUT10skf8hLH8lXZHjcBOoTwUIvI4ULZD+3pZWTSr5/zCdbb8ZkdiQYKotG0BHPxREBNAYMuoSobZSHcZM/8HdNb7lup0tuG4Huz6qgZSd98TQKMar/o3kpHjQDnvba04dVHrMs4uPqkw8OHi1XSsHeZolD5SU0koczKe6/CLmCyJX4w2qam0/lZuVH9GMv7OL/4MTeXdCMr5Fx7HG1hrQJ9QzIur5seqvkewGF0+IvuIrRp9RUq0e4HOgaNhhs9PKKXfE8EIVoXYEuUds8W2Y1QVX+aSRBZI/XouAEKTODkebnsxhl2Nb4WbGCHOX01mzNM0j4Q3F2Xvr6QtM0ZJDJDzsPjCm8vOqVjiwhXEaWU6LeA69yw4lrwVM8Deh++t+Y1GrvtEnfcIuRRTpXnwfxB2GJ5Z0CwbV3l0ucF8fUeRn7TFVuXl21COxrNtT7k8z9RDBmGYWThx2TSyh8vDugfXTkiMLAzRmw5hhCr3LIxmBLDp9zAIFWpE+0yeyKJM
 awbHbky5
 e+yKSRkuNdBu7dXtAuhwm7wWWu+hgY2XD0B9H5iGRoHALk6HEl0Xr3tnhzlgb2D9T9sNrF2E0trEH11v/AZA0QlaTvliMGGQmGAdAIMfDEa3HXmkJPXt6K8YlomATcL1yfQs8AbGtLOOpW74CMk0VTI8sxqKLftP1bEqPRKOr0AMVHtInU2E4YZ+35O1X8roeKhwTahHaAYBNV7FpUQhjj2RaXFZ/xc2iP7O9BlPUJYh7DDH9SbRdHrJqeQ8aj2cc2T0QVtk/cKgwsTlVtUTL3lvkyTSvkNr4cMX+qlDhfrO9qUF7KQ2QbmDjN4dU1CZGktJp+I0Swq3hIgamsS2p4MtQTPmc5HoXI/QDqdWaO4eKlCk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

We want to rework how set_pXd() behaves for generic compile-time
folded page tables by disallowing its use and triggering a
compile-time error when it is used improperly, ensuring that the actual
first-level set_pXd() function is used instead.

Since csky's PGTABLE_LEVELS always is 2, use set_pmd() instead of
set_pgd() to handle vmalloc_fault().

There should be no functional change.

Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
---
 arch/csky/mm/fault.c | 35 +++++++++++------------------------
 1 file changed, 11 insertions(+), 24 deletions(-)

diff --git a/arch/csky/mm/fault.c b/arch/csky/mm/fault.c
index 7ff4011089850..1467ea963806c 100644
--- a/arch/csky/mm/fault.c
+++ b/arch/csky/mm/fault.c
@@ -114,12 +114,12 @@ static inline void bad_area_nosemaphore(struct pt_regs *regs, struct mm_struct *
 
 static inline void vmalloc_fault(struct pt_regs *regs, int code, unsigned long addr)
 {
-	pgd_t *pgd, *pgd_k;
-	pud_t *pud, *pud_k;
-	pmd_t *pmd, *pmd_k;
-	pte_t *pte_k;
+	pmd_t *pmdp, *pmdp_k, pmd_k;
+	pte_t *ptep_k;
 	int offset;
 
+	BUILD_BUG_ON(CONFIG_PGTABLE_LEVELS != 2);
+
 	/* User mode accesses just cause a SIGSEGV */
 	if (user_mode(regs)) {
 		do_trap(regs, SIGSEGV, code, addr);
@@ -135,32 +135,19 @@ static inline void vmalloc_fault(struct pt_regs *regs, int code, unsigned long a
 	 */
 	offset = pgd_index(addr);
 
-	pgd = get_pgd() + offset;
-	pgd_k = init_mm.pgd + offset;
-
-	if (!pgd_present(*pgd_k)) {
-		no_context(regs, addr);
-		return;
-	}
-	set_pgd(pgd, *pgd_k);
+	pmdp = (pmd_t *)(get_pgd() + offset);
+	pmdp_k = (pmd_t *)(init_mm.pgd + offset);
 
-	pud = (pud_t *)pgd;
-	pud_k = (pud_t *)pgd_k;
-	if (!pud_present(*pud_k)) {
+	pmd_k = *pmdp_k;
+	if (!pmd_present(pmd_k)) {
 		no_context(regs, addr);
 		return;
 	}
 
-	pmd = pmd_offset(pud, addr);
-	pmd_k = pmd_offset(pud_k, addr);
-	if (!pmd_present(*pmd_k)) {
-		no_context(regs, addr);
-		return;
-	}
-	set_pmd(pmd, *pmd_k);
+	set_pmd(pmdp, pmd_k);
 
-	pte_k = pte_offset_kernel(pmd_k, addr);
-	if (!pte_present(*pte_k)) {
+	ptep_k = pte_offset_kernel(pmdp_k, addr);
+	if (!pte_present(*ptep_k)) {
 		no_context(regs, addr);
 		return;
 	}
-- 
LEVI:{C3F47F37-75D8-414A-A8BA-3980EC8A46D7}


