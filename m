Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C80CDC44501
	for <linux-mm@archiver.kernel.org>; Mon, 13 Jul 2026 16:29:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 15C076B0123; Mon, 13 Jul 2026 12:29:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 10D836B0127; Mon, 13 Jul 2026 12:29:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F3EB26B0128; Mon, 13 Jul 2026 12:29:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BF0796B0123
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 12:29:40 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 0F7D614018A
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 14:03:27 +0000 (UTC)
X-FDA: 84983920854.28.F58E98D
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf11.hostedemail.com (Postfix) with ESMTP id 297C54000E
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 14:03:25 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=kFAmuy6H;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf11.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783951405;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=THHvBJpYcPy1Mpw8uFtQehVOiWGJNgy1d8m15UYA4Vk=;
	b=dnHc3Vjo4fJLZI4Gle9XS5tzPTXt5hmZa7khjJjHmsxzff/FUQ9BBh9giAUsjc156JYPxX
	f0e81+wuyz90KOHm6UYc51ui02WyEitC7rl6bnYEIOOQG0epra0i80+dnhY3cRGJ3FdMJn
	39UdalkDx72Wir16qKi9vshq1b0BJf0=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=kFAmuy6H;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf11.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783951405;
	b=mUU0vR4XEnyGOZVg/+cLP8r/o1AIQsqzi5fxyiWtEsd2DwSlVClvX5fglXZhiMIup4RVLu
	sgK0TPqhJvvChftQeFIxPdmx7FKLQU+gBKiSmZyiuwpHb4beZW3WL//Eq4k5iA99n/q1Zl
	HFNnDgaplIe2DidTN4nixL0l4jOReiI=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 19BE32309;
	Mon, 13 Jul 2026 07:03:19 -0700 (PDT)
Received: from e129823.cambridge.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 2BAB13F7B4;
	Mon, 13 Jul 2026 07:03:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1783951403; bh=gAIMmlF71mzMP0yYJWwgqqjvoec5KnaBkukv+jUXMrU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kFAmuy6HCrMZ6tSuvjtTYo85hlb7PNx9Wx6sIRts9SRAquBqiQgqOfIlCRlJ9B4Tp
	 d3jU1pzNDXQyK6LYap+DEJjC3rZKNQjaAN3bou87+5KbSGg+CkVydZQYAug8b2BRDO
	 wVSck9EvYickuztkf+XvT3t4Mi2M0L8sZriC0bvI=
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
Subject: [RFC PATCH 33/34] mm/pgtable: catch abuse of folded dummy pgd_t/p4d_t/pud_t
Date: Mon, 13 Jul 2026 14:56:12 +0100
Message-ID: <20260713135614.1618183-34-yeoreum.yun@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260713135614.1618183-1-yeoreum.yun@arm.com>
References: <20260713135614.1618183-1-yeoreum.yun@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 297C54000E
X-Stat-Signature: wifc1rycug195maa14omyfen68uwxxat
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1783951405-840726
X-HE-Meta: U2FsdGVkX1+GHiFxDIbK98HrzJTSWIS07MW1nMyLTWDTC67ComxyaQ1pNEcKILVlukY+zBSkluQQBthq0Pwlh/I3ewyJTjwRuFcrNPMuBmyQTuoJ6GZ8sks7JIseqDTpcnLIFlMvysv8SvFkQKhKK1W4x33XtaIvFhGNcWkVDn7im48fAQQc2LNzfFHFRXgOpYKdzeu0hGTm9M8yD9P/uiQNu+4x1hUSANnXxlOa/xdDmqxZqUztEO1UzljDmtgdpQ6SWJlODdX9D2VrNALryIlusesB3qKM5YZUc9cVgJwYqhjfQPUW1csaVEDJS56M8RVEanHP92HSDA61PHhJ4hYN8aPqHEfrHErcPGQ+qYWd6gqV3LOl7aitZGI1aSoo0SbC6gFG209xbqQxLZE72vPsT0zeRa+ByuOyR5WCxHLMkjsbMdXaAK64iKk1K0J3s9RW9JB/DpfAIqI/o0sq+Y1JbwOd7PfWIAARM7JPJedT/6jQvqSJ5uW3Jd+c0ONh/t78D4z1ZnIpcM6MS0Qy8He2vvgquGCmvLXmu3EmYAj2uA3DivuG1iOyGB8eJDpArpOjnZzPpqLGlsYUmwfWKONGqM+wHHmRpj+5Ssd0u/cnpoi8w5ev3M6D9c3DogQuXaHVVEhImAGzJlSKY1vdKyJBHuZS8a0yS9s9cmR0NCn9fHy3c2ZJ/kE167gASSHVFkliqhA1Pppea5hfidd9/KupXwEJjxKFdi3GGBrmDgQ2zeM1sq+JD7kEYmippEfwtWQ+DdNPtzIjDca61A9iNvQ7zoWI0yF9vRi1C9w8qzlBSm+wN/gAEyXfWDSLm9ZdQs+DdOQ7UYdg3hBW1woO9TuoYwUcfOTrz1CeB4ZobmOzkciV+QILHTxA+wkh2BBVEoDawpXOd84o3C6q02APsVdiEyX8ZbYYfuoiq7WIVtvGWKTiY2ReWXTpyf7eeE8nA/T6ua3SUgsZ1sapcRO
 4zeFBrv3
 IImJ+UkfcX7+Qi8H9c1MnCjY6Bl/UaoW322UKPqtkeoqTcQXVbttJwoEfOYOtQHqZQaUUm5GvFCKIHm9uUBs5YovD6s6zdoMhX/O3Cznp+zIFkCm+r5UvLvHLbQDA7neIXWCqP8uBvvQErg8j+R9lke+n7QSd92x1s7olPE68wYv0b9l8Jc+J9EK/krj93iWb3MrDUYBFaHlqjJPa0V3OTYWjO8r7vaSmtxH8aWsQM2qIOy5aAgx55GVt6zTYmSejs/jIFY1uXsx6OZlaM0P8kVq4fdlARBDfCiBxOfHAo5l7Xka0MuEKJjuOCIu3AizLN1ErQ85P+y1gHCbfYoBGqkBUcAN0mLtY6rpr5YEYNFHm8+jcJ5t1Xfe4ySyF18H5jYyG
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "David Hildenbrand (Arm)" <david@kernel.org>

Let's catch and prevent all abuse with dummy values on the stack
similar to:

	pud_t pud = pudp_get(pudp);
	pmd_t *pmdp = pud_offset(*pud, addr);

While this approach relies on the compiler propagating constants, it
should catch most of the issues in practice. It would have caught all
the issues we found through manual inspection.

To avoid build issues particularly on x86, where pgd_val() might not be
around in some inclusion paths, perform the new checks from wrapper
macros.

Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
---
 include/asm-generic/pgtable-nop4d.h | 23 ++++++++++++++++++-----
 include/asm-generic/pgtable-nopmd.h | 24 ++++++++++++++++++------
 include/asm-generic/pgtable-nopud.h | 24 ++++++++++++++++++------
 3 files changed, 54 insertions(+), 17 deletions(-)

diff --git a/include/asm-generic/pgtable-nop4d.h b/include/asm-generic/pgtable-nop4d.h
index 84a529df27ee3..fcd86aabc592c 100644
--- a/include/asm-generic/pgtable-nop4d.h
+++ b/include/asm-generic/pgtable-nop4d.h
@@ -31,7 +31,7 @@ static inline bool pgd_leaf(pgd_t pgd)		{ return false; }
 
 #define set_pgd(pgdptr, pgdval)			BUILD_BUG()
 
-static inline pgd_t pgdp_get(pgd_t *p4dp)
+static __always_inline pgd_t pgdp_get(pgd_t *p4dp)
 {
 	pgd_t dummy = { 0 };
 
@@ -39,17 +39,30 @@ static inline pgd_t pgdp_get(pgd_t *p4dp)
 }
 #define pgdp_get pgdp_get
 
-static inline p4d_t *p4d_offset(pgd_t *pgd, unsigned long address)
+#define pgd_check_dummy(pgd) BUILD_BUG_ON(__builtin_constant_p(pgd_val(pgd)))
+
+static __always_inline p4d_t *__p4d_offset(pgd_t *pgdp, unsigned long address)
 {
-	return (p4d_t *)pgd;
+	return (p4d_t *)pgdp;
 }
 
-static inline p4d_t *p4d_offset_lockless(pgd_t *pgdp, pgd_t pgd,
+#define p4d_offset(pgdp, address)					\
+({									\
+	pgd_check_dummy(*(pgdp));					\
+	__p4d_offset(pgdp, address);					\
+})
+
+static __always_inline p4d_t *__p4d_offset_lockless(pgd_t *pgdp, pgd_t pgd,
 		unsigned long address)
 {
 	return (p4d_t *)pgdp;
 }
-#define p4d_offset_lockless p4d_offset_lockless
+
+#define p4d_offset_lockless(pgdp, pgd, address)				\
+({									\
+	pgd_check_dummy(*(pgdp));					\
+	__p4d_offset_lockless(pgdp, pgd, address);			\
+})
 
 #define p4d_val(x)				(pgd_val((x).pgd))
 #define __p4d(x)				((p4d_t) { __pgd(x) })
diff --git a/include/asm-generic/pgtable-nopmd.h b/include/asm-generic/pgtable-nopmd.h
index 96f3fccd22fda..ef6dd5895e7ba 100644
--- a/include/asm-generic/pgtable-nopmd.h
+++ b/include/asm-generic/pgtable-nopmd.h
@@ -40,7 +40,7 @@ static inline void pud_clear(pud_t *pud)	{ }
 
 #define set_pud(pudptr, pudval)			BUILD_BUG()
 
-static inline pud_t pudp_get(pud_t *pudp)
+static __always_inline pud_t pudp_get(pud_t *pudp)
 {
 	pud_t dummy = { 0 };
 
@@ -48,18 +48,30 @@ static inline pud_t pudp_get(pud_t *pudp)
 }
 #define pudp_get pudp_get
 
-static inline pmd_t * pmd_offset(pud_t * pud, unsigned long address)
+#define pud_check_dummy(pud) BUILD_BUG_ON(__builtin_constant_p(pud_val(pud)))
+
+static __always_inline pmd_t *__pmd_offset(pud_t *pudp, unsigned long address)
 {
-	return (pmd_t *)pud;
+	return (pmd_t *)pudp;
 }
-#define pmd_offset pmd_offset
 
-static inline pmd_t *pmd_offset_lockless(pud_t *pudp, pud_t pud,
+#define pmd_offset(pudp, address)					\
+({									\
+	pud_check_dummy(*(pudp));					\
+	__pmd_offset(pudp, address);					\
+})
+
+static __always_inline pmd_t *__pmd_offset_lockless(pud_t *pudp, pud_t pud,
 		unsigned long address)
 {
 	return (pmd_t *)pudp;
 }
-#define pmd_offset_lockless pmd_offset_lockless
+
+#define pmd_offset_lockless(pudp, pud, address)				\
+({									\
+	pud_check_dummy(*(pudp));					\
+	__pmd_offset_lockless(pudp, pud, address);			\
+})
 
 #define pmd_val(x)				(pud_val((x).pud))
 #define __pmd(x)				((pmd_t) { __pud(x) } )
diff --git a/include/asm-generic/pgtable-nopud.h b/include/asm-generic/pgtable-nopud.h
index faa0233bcde80..873940f9d3f9b 100644
--- a/include/asm-generic/pgtable-nopud.h
+++ b/include/asm-generic/pgtable-nopud.h
@@ -38,7 +38,7 @@ static inline bool p4d_leaf(p4d_t p4d)		{ return false; }
 
 #define set_p4d(p4dptr, p4dval)			BUILD_BUG()
 
-static inline p4d_t p4dp_get(p4d_t *p4dp)
+static __always_inline p4d_t p4dp_get(p4d_t *p4dp)
 {
 	p4d_t dummy = { 0 };
 
@@ -46,18 +46,30 @@ static inline p4d_t p4dp_get(p4d_t *p4dp)
 }
 #define p4dp_get p4dp_get
 
-static inline pud_t *pud_offset(p4d_t *p4d, unsigned long address)
+#define p4d_check_dummy(p4d) BUILD_BUG_ON(__builtin_constant_p(p4d_val(p4d)))
+
+static __always_inline pud_t *__pud_offset(p4d_t *p4dp, unsigned long address)
 {
-	return (pud_t *)p4d;
+	return (pud_t *)p4dp;
 }
-#define pud_offset pud_offset
 
-static inline pud_t *pud_offset_lockless(p4d_t *p4dp, p4d_t p4d,
+#define pud_offset(p4dp, address)					\
+({									\
+	p4d_check_dummy(*(p4dp));					\
+	__pud_offset(p4dp, address);					\
+})
+
+static __always_inline pud_t *__pud_offset_lockless(p4d_t *p4dp, p4d_t p4d,
 		unsigned long address)
 {
 	return (pud_t *)p4dp;
 }
-#define pud_offset_lockless pud_offset_lockless
+
+#define pud_offset_lockless(p4dp, p4d, address)				\
+({									\
+	p4d_check_dummy(*(p4dp));					\
+	__pud_offset_lockless(p4dp, p4d, address);			\
+})
 
 #define pud_val(x)				(p4d_val((x).p4d))
 #define __pud(x)				((pud_t) { __p4d(x) })
-- 
LEVI:{C3F47F37-75D8-414A-A8BA-3980EC8A46D7}


