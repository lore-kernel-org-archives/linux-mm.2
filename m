Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1D1E7C982E1
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 10:58:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 41A066B00D9; Mon, 21 Sep 2026 06:58:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3F0AC6B0101; Mon, 21 Sep 2026 06:58:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 306CB6B00E1; Mon, 21 Sep 2026 06:58:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 027916B0101
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 06:58:47 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 7E602C011F
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 10:58:47 +0000 (UTC)
X-FDA: 85237471494.14.24A830A
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf07.hostedemail.com (Postfix) with ESMTP id 7D07B40004
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 10:58:45 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=M69yt9JN;
	spf=pass (imf07.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789988325;
	b=q88C59jxbIwFJg+11KOFvWrDRvqF9aX1HlKVMTc59X85ivBlBhojAaFUWfhzvWyIvCyGXr
	40DCDc2h4qaz3545U1vC2iD/n/2BB57rvoSR/4qgP8kIfFn0UH69z86dLuvhuTpw5eKS9F
	bGhUNsrhJWVjb/t5xWc6K43G4fX+qKc=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=M69yt9JN;
	spf=pass (imf07.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789988325;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uKK5tiF0Agsvoxq6PuilGLIE+2qkeMucLJBKKyIWDK0=;
	b=ozvDv9DgZShhmGAFm47BNXAXeVtDTCSdmCIWchQMiYAwO4LBDDlAG7lKy3oz6HwR5aI7e/
	3eZvFcm/c/sTV6rVh8ovd+AsTDN7/Q03upUW035N0gTY1RmcwPdKVJVBsZwYMcSvfbCI8V
	y3AHv0GlHNjCTMnbOzYeUuhIsy3rHmc=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 34A151D13;
	Mon, 21 Sep 2026 03:58:41 -0700 (PDT)
Received: from e129823.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 97C853F86C;
	Mon, 21 Sep 2026 03:58:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1789988324; bh=wV1Rko2jO3CBq2XkkZPZAq0K5FwAUXTua1cF3CtPA0Q=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=M69yt9JNZZOu07m2eMUXUE7kOouVrZ1x/HOoeFBr+noA27ltzymcz/8DIQ6+nWmeA
	 Kl3YQM/RF8UVLyxHtt3QuNclLtl3PDdDABqDQoBAZLOMcsdrQA4rXueqGUmFuELMoB
	 9zMg9PMSynQbdAYiXfxLlCV+wg7YHxMgGrf3BDy8=
From: Yeoreum Yun <yeoreum.yun@arm.com>
Date: Mon, 21 Sep 2026 11:55:40 +0100
Subject: [PATCH 18/21] mm/pgtable: catch abuse of folded dummy
 pgd_t/p4d_t/pud_t
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260921-dummy_ptxp3-v1-18-cd40cf68242e@arm.com>
References: <20260921-dummy_ptxp3-v1-0-cd40cf68242e@arm.com>
In-Reply-To: <20260921-dummy_ptxp3-v1-0-cd40cf68242e@arm.com>
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
 h=from:subject:message-id; bh=l+aFtD+gf169DFuCaai5cwdW0dtCP9VrudnD5mceiXU=;
 b=owEB7QES/pANAwAKAW3Vw9FaxTEzAcsmYgBqsQ1TVJ8WMEBMvMxpLmee8FhBXqTgwIAqkv6F1
 pZhimntkJuJAbMEAAEKAB0WIQQtg+CS3QUzuFh1pJ1t1cPRWsUxMwUCarENUwAKCRBt1cPRWsUx
 M4WLC/sEXXfDYkutq+XAp2eq4pnDsW6DCLQnTbXxUpR54sRfzZL7IThTi7dm/8TREnCeAjQzxSb
 kIEls9cerKZbqCqvoo1jxqfAow3waQ7/FpfR3e0QBaKEGCVcOXbUkfZZWme1N1fIZs/5+T1FMM/
 Wmno7S+8Qmijp4q76nSESjDriWdGU45ti1Gddg0VHaL4Ge1gjs2m8fjk8fQ2zm44AYbJF6QQype
 07q+r9nZBtf283PQwCq+ujgtbmj0quciFUubtzKIEftdItMvCx4D6aFGlWt+xl7NNnjVXMIoIZM
 gt3foVK/bmLXFR9La90KMSAFxgXzS9YScthuZoL/8m5YdttG8nj+VUuQLBgZrXRgXiYwY74HCui
 x4bKpVVRItDotIL4T6torQgNsStmEkdDf8yASZ0OxkhEpIjSDLWHoD83ROEl9Vi5hatDNf6ua9t
 S2qYUC7sUdkPljmrhJZ3t7h+vrNE+C81GHrh7eq0o3aM1EqMeCg95MTIGsPmP+lkqMc+c=
X-Developer-Key: i=yeoreum.yun@arm.com; a=openpgp;
 fpr=2D83E092DD0533B85875A49D6DD5C3D15AC53133
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 7D07B40004
X-Rspam-User: 
X-Stat-Signature: a91sip34idrbfx93i9mxgyspmgewouq5
X-HE-Tag: 1789988325-601747
X-HE-Meta: U2FsdGVkX1+0K3JY0cnknVWhBZuT/I4FzB2IPT9WzohLUZyMUeo9xuMe+uuLqX2e6M+lYbWcfi/uKPmbThoPlBe93B67PqNg3+oaw1NsAHIc2F2L/Nu2Pnm1+dv8HAxoEUp0QYPLQNqAmT77JXPBB9z3rGqNNbWIOI1YBmNKznNj9X07Bf9BH04VKYQ440rL2JWP6Tp9XDU9vndYJf81OjnQG5ZEki9m2NIx6xKizil10ZQ1w3jNuv4cTPYu/nQeSdFFYOzduSrN1m7MfKYBVZSgfuHW0TxjXFuDc0TF8vMZafG3NFCSp4YXWXWuIxXTUQAOMYRv9iczt+BmKoeoA9Vz400Jnxx7CBENsA2MsCXs75DSxvTVv+AYnGi/4TX10PfGsX6cnrHj9H0bdg/JkOj0WDFRSMenOZE0oSRDEEmN1BA1MdIZQfi5E0k6bvZ2UDR3r+IUgXISdGEPycZqec+zgk31M7eAkM5pqdbZqHfs2HI31pPE8co+eKlupuVSX8YxIYWBfPIcCaj957wN77PthdOZZJvar/DQvSuyuk5XMDSgk/eiwmyK/MQIvzqR2AkWtM5x1FAhB9H80W+4PA6zc636S2q0JqmsG7nohA4bl40Dk37fkSLovre+pfr9yIbzSHQQOdpsSSTKxbiyc+tFF3UrnzJnX30M6EDcYW54akwQ0DyatXpTlqM+Xz6VxKV5ZvLD1rUYNJHU37eFpF4GHmGVqcfzOrRFL4NrqTcZ68OP7LPIY3Ufycb1beSt5koFtPIyFUfFaklP3JqMKY0Yn/ps7iiFwoW+7S5VuImd3BxOxanGn2IqozL83RMiUPa+voj6vVivDw81XQCKXxS88BOPIqsfnyVh5cjha2hD0JpkjbVhhlpt6ILUN7/eGqI4o9km3TFMDlq2AFq1Qsgpq8c44QlZi8/DIthArwiwAK/Z3a0NZ1HRPL71MF9sUMA3p9TRDqCJpAQ2YGf
 WL6sRijG
 gfHRiuTPfccY7bIN5Qe9d3mUBKbO6wWG0RPqPwPE9B+zWd5lPUhW/9XsNZns24Gf+7DGs7aLlfhR6u2KpRP4bwzPtMRxtODSKlIot8Q/rGFNgHNE0Lj5D0DTiFbW/oUWs8twUSU73PBO0sGOjqskECvaity+XiGJopLZfH9II5ifT1Z5PqR67C/oExTPzyUHPhyFFxS7qO9q49M9xnK1+d58oQfEDPnyk20VZSK3CxlKeKwlR1TE8Z28Qdm22L/KkR5Xw+y8R+hM6vSU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "David Hildenbrand (Arm)" <david@kernel.org>

Catch and prevent all abuse with dummy values on the stack
similar to:

	pud_t pud = pudp_get(pudp);
	pmd_t *pmdp = pud_offset(*pud, addr);

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


