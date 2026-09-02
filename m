Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BA408C624D0
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 11:58:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C4FE06B00D6; Wed,  2 Sep 2026 07:58:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C270E6B00D9; Wed,  2 Sep 2026 07:58:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AF6EC6B00DA; Wed,  2 Sep 2026 07:58:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 826F76B00D6
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 07:58:54 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 13CD5801A6
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 11:58:54 +0000 (UTC)
X-FDA: 85168675788.27.3ED0AAA
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf16.hostedemail.com (Postfix) with ESMTP id 3630E180007
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 11:58:52 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=LlZFY9Zu;
	spf=pass (imf16.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788350332;
	b=p5oHfKiUZkqk4kyyu5tC5bbQwkbq8sUoysmbpYOdy9622ruObTG5Tu3CBhbMGrDvuuXrrm
	1UfAteaRzEDX2BlEQLpGVTNx3lY6MZLWllPgIp6BHcmvX8QCnO1CVXl3EzcRbD+bR6Ms+j
	pYOAEyyEII9sh7X0QovE3rSum5fPg0c=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=LlZFY9Zu;
	spf=pass (imf16.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788350332;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/GEX+b/EG654g5ZBX1T3eHjkA6GsCqfSs0yD896S7Ys=;
	b=vfhSADrxZIr7neJxUzUwJOrm2e5mbHB+J36Rn5qzlUqulaCywwUC59iWOJZxpGtRlfxhbJ
	KY7derD92hGb8UP/FSTNWjMjz4NSo4F6q5w5qFqIxVr1r70Z9u4yHDoB0pciHINxCW0sgk
	9Mf/eYEKt2X2xxI2yr622TDH6RacgZk=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A27EB1E4D;
	Wed,  2 Sep 2026 04:58:47 -0700 (PDT)
Received: from e129823.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 4C8F23F85F;
	Wed,  2 Sep 2026 04:58:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1788350331; bh=umnYd1J6xWmWFbnXzi3vz83x/xuEZGuwLZioU2+M5Ww=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=LlZFY9Zu2ujRoZsjVc5Ynf2s++UIneYX6haXrd56wziFajt7R1Vz7bs5m5ByxWxwX
	 gAf8HR+B/ZejTvZgWMMsSDjiH+aScSDD0TNx49sKtqrpKW9d2X4/EzCi6sP1blOQHa
	 aavxMs32nXDjC5vLPAu44ffpYuzHK4DMVZu1JVKw=
From: Yeoreum Yun <yeoreum.yun@arm.com>
Date: Wed, 02 Sep 2026 12:56:20 +0100
Subject: [PATCH RFC v3 18/21] mm/pgtable: catch abuse of folded dummy
 pgd_t/p4d_t/pud_t
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260902-dummy_ptxp3-v3-18-5d8f5b17c25c@arm.com>
References: <20260902-dummy_ptxp3-v3-0-5d8f5b17c25c@arm.com>
In-Reply-To: <20260902-dummy_ptxp3-v3-0-5d8f5b17c25c@arm.com>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=5530; i=yeoreum.yun@arm.com;
 h=from:subject:message-id; bh=7qpVYfxo11somdb5c6gV0/kDLH5Q0BihBtrikdiezoA=;
 b=owEB7QES/pANAwAKAW3Vw9FaxTEzAcsmYgBqmA7qXyQcD9iPBpTAnFU7GV5yNh6YjDdTUtbl6
 Oaf4xiT/C6JAbMEAAEKAB0WIQQtg+CS3QUzuFh1pJ1t1cPRWsUxMwUCapgO6gAKCRBt1cPRWsUx
 M7U/C/9ttzpnHb2yuUInkeTRmPl+W6MUdZoaQgEgVwirYFKv8HTBBKYt1YtRNLgvU7BnrSZ1IUl
 PH8YpM1am665hB4A6ZAcgleVTJi+AXCJhojS3SLVU8PhXIm4Eg377aRV19FLkxBoUO0PuabsaSg
 DAED7y2NRXHu5bzGlPIwBjnQg4tGgvlunv6WWcfKf9YsOZ8fk30CJrCnF7BJWiUNaKxXZVZynqf
 s5YET0ss2IoKdc98daxynC3ihV/f3kTtZIVI/Y03MSMY0GeoKmuoEJ9orEzecNOaidHj6eRoAn6
 u+4PCHan2eyLMWAZ1vzaMKQOIBPweR9bEghuKkZiJTqvllEbSJzSlltvfB1gMwKJ4Q1jl01305/
 39eZR59gF0NdnouqIHDnJNx7CVKpv4IT99mguwOGthGa/m1AdiehZZCyE1K7uc/srgCE6su6XHN
 RejUTesdu1qQ2qP6zrtBmjKc+NFH1Y6KRdTeESR8unmk3Km9Ahc/tfCxTGiZF8GNb0ny8=
X-Developer-Key: i=yeoreum.yun@arm.com; a=openpgp;
 fpr=2D83E092DD0533B85875A49D6DD5C3D15AC53133
X-Rspam-User: 
X-Stat-Signature: g7wiogy9yk678cs1u5i7kbnxwj788yto
X-Rspamd-Queue-Id: 3630E180007
X-Rspamd-Server: rspam06
X-HE-Tag: 1788350332-548443
X-HE-Meta: U2FsdGVkX19mE35G3TTVzN8l+9PF+p10wV8OQlT0KWsbYVm3y9T5wyxkrsh+uYZajrf8CQpoc72KcgQysW3FcM47lxvuq2jvhKjowWWd865koqFKcUAZzBB+r6LhJfDIQKan4oczIx1fgkvC9MWmW7D+XTpIUyT1K73b0IL8HP1wGOpkAwLZP45guBF/nBiFB2z3zNtVE58VgzNYKX4SBxzKus/+Pt1/F91hz9znv2piuOjtOUMymikjhO36P8h0BF4ODAhLohtmmXmu6DSaYaWfwfIOpPK0Gj48v6N/b+wT0qARFzysUYp/7uxCXyaeHRz1OwHQ4ha6vjVUANS7iM65hZ9uium4xoe8WsUKZ4xOdND8fa9UwLlZyTedwVl5Mb3pcLEJXzNtDRQJgnAOuc+1JIrCYT6eGGEyZt/g7fvq3v3fPUTh7AleJZ6+1o2QBv53U4+hHzVYgn2zqvyMEwZbtG8+k4l4fp9tJz0WMk0U84tWoqwADJF83hK6bKgJ94OzUiObz3BL6H8IhIM8WUuWCCB0AyhJ8Cpr29cKoujiv3TI83JRyO9lzaEgmt9fpuSreNpapJoSjdcGSLpVuBYqH8CwEzWjyRryu4S8Zj/NjCQJ0llVT2TgKlVdAbPTitXfIZyvyeHHUZ5n2o1WJMv3V9FVNdKbHK6T7h8jIJmxJ2OE8gwWPd8M7ZrrYNDWhGmSunF9pAdmL7R8H06CJoB2xe/mFp75Ddc22fYD4y1c0TOMKi/AWzC7zbPehmUPeb/5vohN5mjrr5I5dn06t1AIJSGty8VudYGq7r1CFOMOiD7B2JTAt4fTuFb+m605GVfZjluSPwFuCzQVAAVXA3ciqi5DX0x7XH5q+777NuEWIDfapkOKsHdHfGYZYN2zvWSaaNRgUImwwx/uVGTSR7COg3sEG+VnLYod4xSRlh3HLkkvU5q7mZ5ydaEUGU0ueTZvzM4yZwt1hEBtlYf
 GYE793JA
 HJH4b46+FVB7krP5C6xt5LXykzvNltkvPMVClVr2fQzUxGRTizBPqjAvF+J4608sG6jof9mM/h+MbbyKHyIGgfaxXM31eTeAtpgKkz/C/Sfaz/Pv7N8WfI5IUqxa+qEbCjb0qZzJbB62jz47CivWspuih0PCZQF/kIoTFvubfHrGAJDd0wncT9xE2hBnPXZj8BdMd284n/ayv+OPhbjz+2sLISliwOEUAnRVn1ZKTDttt3dO5N513Ch/H/hmPWYIpeWW6zzyjdeAVfIE=
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
index acd62ee23353..2d86325235da 100644
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
index 9322f07ddf1e..bd40d3a5743f 100644
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
index 8f01abbb0050..7475d0bd0f2e 100644
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


