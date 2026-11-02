Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 33DFD60A2610
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 11:23:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=L5j3S2qm
Received: by kanga.kvack.org (Postfix)
	id 377C06B05CF; Mon,  2 Nov 2026 06:23:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3290E6B05D0; Mon,  2 Nov 2026 06:23:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 218066B05D1; Mon,  2 Nov 2026 06:23:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D8F686B05CF
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 06:23:33 -0500 (EST)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 70A5FA8B2C
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 11:23:33 +0000 (UTC)
X-FDA: 85389943506.02.24F303E
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf31.hostedemail.com (Postfix) with ESMTP id 9AEBC2000D
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 11:23:32 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=L5j3S2qm;
	spf=pass (imf31.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793618611;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IeiusvcN//HYTYvtTON+UwfbtKPYQ1WsySCM+ju+JhY=;
	b=ov4fx/mW7vbOkolL/Ksf0imafoHNvBkn5SN13fsjDEeaDWniEhrFsZGD3UyahRJEyUDI4t
	8rRPG30b1hbsQgO4Y9TTqlH+qwEDU+Fszphs+J0vK2en9M7CJTFRjxyXXg+Muenuw830aU
	uWclaPF4kWxqJffCUjb8UdvnAt9x9Zw=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=L5j3S2qm;
	spf=pass (imf31.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793618611;
	b=7RnSr8w5ih3J5tdF2d8LLZhbJNMoSBmvnXn7zJSE9K6YZN6aPHkRZrCQwS4pEORXMXRhup
	ZCZMO2uv6Sq4vidGpNppldMEVwtAqlzBskKmFBQuPn0hkc4OmylNpvBJjNaolxd/QyIEjj
	OXktV0yUuqlSnrPr+HSr3ws7xBdHkyw=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 79DD42A31;
	Mon,  2 Nov 2026 03:23:27 -0800 (PST)
Received: from e129823.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 89B4C3F632;
	Mon,  2 Nov 2026 03:23:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1793618610; bh=9p0dJer5accV7E9pXDd7DTUz4Dg0mJc0MW7cEdf4VMA=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=L5j3S2qm8erUkEnuGpQ+xZoox86f9aM0Yh+vfWn9rT6rT3HYiCekGcPdgKtV/eHGU
	 cOzdKjfWTtmrj2Yem7njZ9d/jGjmN11KDgzoGy2hRRBQ/O0+Lj5Zuab/DFFScOf59K
	 4X4dWPJh/ihgTTm3pK0IjJ/JoVR7h8Xos6Wr3vBo=
From: Yeoreum Yun <yeoreum.yun@arm.com>
Date: Mon, 02 Nov 2026 11:21:31 +0000
Subject: [PATCH RESEND v2 18/21] mm/pgtable: catch abuse of folded dummy
 pgd_t/p4d_t/pud_t
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261102-dummy_ptxp3-v2-18-78840b2ec73c@arm.com>
References: <20261102-dummy_ptxp3-v2-0-78840b2ec73c@arm.com>
In-Reply-To: <20261102-dummy_ptxp3-v2-0-78840b2ec73c@arm.com>
To: Russell King <linux@armlinux.org.uk>, 
 Huacai Chen <chenhuacai@kernel.org>, WANG Xuerui <kernel@xen0n.name>, 
 Thomas Bogendoerfer <tsbogend@alpha.franken.de>, 
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
 Arnd Bergmann <arnd@arndb.de>, Andrew Morton <akpm@linux-foundation.org>, 
 Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Barry Song <baohua@kernel.org>, 
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
 Wei Xu <weixugc@google.com>, Johannes Weiner <hannes@cmpxchg.org>, 
 David Hildenbrand <david@kernel.org>, Michal Hocko <mhocko@kernel.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, Tianrui Zhao <zhaotianrui@loongson.cn>, 
 Bibo Mao <maobibo@loongson.cn>, Anup Patel <anup@brainfault.org>, 
 Atish Patra <atish.patra@linux.dev>, Paul Walmsley <pjw@kernel.org>, 
 Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
 Alexandre Ghiti <alex@ghiti.fr>, Dave Hansen <dave.hansen@linux.intel.com>, 
 Andy Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>, 
 Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
 Borislav Petkov <bp@alien8.de>, x86@kernel.org, 
 "H. Peter Anvin" <hpa@zytor.com>, "Liam R. Howlett" <liam@infradead.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Jonas Bonn <jonas@southpole.se>, 
 Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>, 
 Stafford Horne <shorne@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
 loongarch@lists.linux.dev, linux-mips@vger.kernel.org, 
 linux-arch@vger.kernel.org, linux-mm@kvack.org, kvm@vger.kernel.org, 
 kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
 linux-openrisc@vger.kernel.org
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=5536; i=yeoreum.yun@arm.com;
 h=from:subject:message-id; bh=RaNq1OzclUEkYVVkonyr81I//WUCo0pQ53h1961FIzo=;
 b=owEB7QES/pANAwAKAW3Vw9FaxTEzAcsmYgBq6HI35LQrwLJTJ6JHFqKa5WNjGsjc9SCCBxZ91
 V5ViWPS3ImJAbMEAAEKAB0WIQQtg+CS3QUzuFh1pJ1t1cPRWsUxMwUCauhyNwAKCRBt1cPRWsUx
 M5CXDAC5wcFzP5HHs/20OLo/fEv0r+XaQDjC0DAJwcDl0jfQa5A9j234lqJcFQ2J3UF5aj4jVZu
 sJe0FGfp6mVD4y/ZdJeadQTJG7x1t6cxs1VGc83wL1G2NdN8NdBoAP/23a+KrO9hojG2crw1zYL
 NH41zJ6inULqk0Asfw/J56fwREX6K4F1nLJtPYEG0xHwUyzRwjcKPZjgVrim6gRiPDFwl77zT1O
 BNcM/4sON+rTiP1b0OpoP14EccvL7OJTp1JfCll/KJJhbQZwz27DVDNfzVMaYlHiFjrGlE7AFSI
 Z3TqFvckPUPKqoY1QqjnCxoiLaVuX7/WWlCKdmj08IOVAohulKhFiI/GNdhN6RO+JCtKNNuwE3T
 oVyP2vI/YF3KVazeRdNDp8yHcZg6ZR3ZYTDyWbtlojKD1zkvrm59hNA/XTxs1Us/8BWMvAe45tF
 P0TXfrBvEC9mSeI50hhAF8Kdgc8z5fNItEOx7/JZB/e8FiFZCY+RGyoyOH/SvHTY+ufFc=
X-Developer-Key: i=yeoreum.yun@arm.com; a=openpgp;
 fpr=2D83E092DD0533B85875A49D6DD5C3D15AC53133
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 9AEBC2000D
X-Stat-Signature: qkb7y1dx4b1p9udsaeknu7rhq1j71fyt
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793618612-40600
X-HE-Meta: U2FsdGVkX19XjaIvx2IRHnC3SvJz3mQQajy7/Yh++zoetsdecsJEpMB8vNo9Xfq+XTh7vG9kh0iBwoqP4KPfQTjT9ZJHAudy5dGQt07VQF2qe54u14f//eJVmoQ3ygNRfFP+1j7TS1/qS1MALg58piuwbDsJ5x++KYS6oS4+yGlvhdr91xAMr5XH3gRJOMgqu7KP9OfGQjzvNpTXWAMc9FTP+9iqc+RaOYkk6NZ13XlanijSwrs/IEnv6JcGQqfMwgyP2fC7h7FdXXUZx/wgqhrb8Jt6LpWfcOvkkD5VdLej/hFOIJ/H4BLv21Sl5P0E5fQ9KWWYB2l/Ze4/TFbJFpgsvRoY/phCL/GofEmxomYLO7uzi9KHE6KQVBldPDhIpsVHmqJXQ8a7koD35HAzrMWWJ+OF8l0kVJdL9VsWbk+LuWdygCPcqs3zU5PA5+aV7DFq2BhIiP+LLJ4raIucqhnFZPY6fLhzJa0Tjjejzkg0KTqux+aKQwD813os4uAnDopncU2zsAuETzyAPamGJQo6D1uLPwXTfBc+RNHsC9eNIjC9OtMtSjXv2jUQHfyu2Tp3moYQkEah9CkFIlWruZse45Hl4Pj2owK9uOO+8DhjFf1AqfRt+3QXR33NuRjhPwDXII2HUcVxNmnNAkz9/8NlTsRCBACvninqYY59uREWRWtIIIVc25LwUnxoKW7CbwU1SFqMgMP5W7JHExB00VdCUADTEfJ5C3/LTUKSx5MIYNt5d6BNBpnso23Bu1A5NRN7ugSOAJrvPF5TVFfDQ78lfeH5Eo6vHWweTyySM53+B2yCzs8d5JgsFIwg/RwEH5NRwyi611adlj868JWjQNoxJHnVijDLSB/WhQKSagwh5GKA81iziqcU2zwo2YB1i8B4hxmJ2oOC/G6FPmYRdCMOU1PnC7A4TkMnmCkrUu3yNxSic4XMPV8EIC9BiHawiq1qfvZaysUyM1ZbPDE
 pPXOjfau
 mw4F4oOIvavXrlgYvlLWhq3i9ZzqIGeXLKtPz1kYvhIcvL1FvfZWTICjDR44ZhHaFsn9Bj9Xn3+eegKzaFRqSGVyTUmKVrrMEUENDAzglnWf359rxQ5sLCpthektmYWeqNU9hGq9x8Zl6E0JizuKh5zMM3YEVQA0dtIArRdIAn9kHRafmeQ4wA0NtTToRgIqAbOY7A/3wFbqgtmlfecwgDLZZBStNoYEvFygFA0oWrO89V5gDDqGCLngnmD16ICfYpAjNirkG9ym4Pb4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: "David Hildenbrand (Arm)" <david@kernel.org>

Catch and prevent all abuse with dummy values on the stack
similar to:

	pud_t pud = pudp_get(pudp);
	pmd_t *pmdp = pud_offset(&pud, addr);

While this approach relies on the compiler propagating constants, it
should catch most of the issues in practice. It would have caught all
the issues were found through manual inspection.

To avoid build issues particularly on x86, where pgd_val() might not be
around in some inclusion paths, perform the new checks from wrapper
macros.

Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 include/asm-generic/pgtable-nop4d.h | 23 ++++++++++++++++++-----
 include/asm-generic/pgtable-nopmd.h | 24 ++++++++++++++++++------
 include/asm-generic/pgtable-nopud.h | 24 ++++++++++++++++++------
 3 files changed, 54 insertions(+), 17 deletions(-)

diff --git a/include/asm-generic/pgtable-nop4d.h b/include/asm-generic/pgtable-nop4d.h
index acd62ee233536..2d86325235da5 100644
--- a/include/asm-generic/pgtable-nop4d.h
+++ b/include/asm-generic/pgtable-nop4d.h
@@ -34,7 +34,7 @@ static inline bool pgd_leaf(pgd_t pgd)		{ return false; }
  */
 #define set_pgd(pgdptr, pgdval)	set_p4d((p4d_t *)(pgdptr), (p4d_t) { pgdval })
 
-static inline pgd_t pgdp_get(pgd_t *pgdp)
+static __always_inline pgd_t pgdp_get(pgd_t *pgdp)
 {
 	pgd_t dummy = { 0 };
 
@@ -42,17 +42,30 @@ static inline pgd_t pgdp_get(pgd_t *pgdp)
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
index 9322f07ddf1ef..bd40d3a5743ff 100644
--- a/include/asm-generic/pgtable-nopmd.h
+++ b/include/asm-generic/pgtable-nopmd.h
@@ -43,7 +43,7 @@ static inline void pud_clear(pud_t *pud)	{ }
  */
 #define set_pud(pudptr, pudval)			set_pmd((pmd_t *)(pudptr), (pmd_t) { pudval })
 
-static inline pud_t pudp_get(pud_t *pudp)
+static __always_inline pud_t pudp_get(pud_t *pudp)
 {
 	pud_t dummy = { 0 };
 
@@ -51,18 +51,30 @@ static inline pud_t pudp_get(pud_t *pudp)
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
index 8f01abbb00503..7475d0bd0f2e0 100644
--- a/include/asm-generic/pgtable-nopud.h
+++ b/include/asm-generic/pgtable-nopud.h
@@ -41,7 +41,7 @@ static inline bool p4d_leaf(p4d_t p4d)		{ return false; }
  */
 #define set_p4d(p4dptr, p4dval)	set_pud((pud_t *)(p4dptr), (pud_t) { p4dval })
 
-static inline p4d_t p4dp_get(p4d_t *p4dp)
+static __always_inline p4d_t p4dp_get(p4d_t *p4dp)
 {
 	p4d_t dummy = { 0 };
 
@@ -49,18 +49,30 @@ static inline p4d_t p4dp_get(p4d_t *p4dp)
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
2.43.0


