Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D2133C44539
	for <linux-mm@archiver.kernel.org>; Wed, 22 Jul 2026 15:32:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CEFAD6B00A0; Wed, 22 Jul 2026 11:32:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C9F786B00D7; Wed, 22 Jul 2026 11:32:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B92086B00D9; Wed, 22 Jul 2026 11:32:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 899DF6B00A0
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 11:32:38 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A5E7C1201F8
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 15:32:37 +0000 (UTC)
X-FDA: 85016804754.20.C453282
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf06.hostedemail.com (Postfix) with ESMTP id B35A8180003
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 15:32:35 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=NfkiC7Lv;
	spf=pass (imf06.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784734355;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YIM7wDvIQeaO8P2vQoKEceIFnuLM1m2h9nq5Ees/pW8=;
	b=D52ZlbOP10nzqTxcv7vfimYUy122c8uyN+Lggbs4+HBoJ/br8NhuwE7mrnhf2WY2hECtgi
	O/N4hMlFDzWGcp3lWeFvsTfry8rUqQ8Y33spVLk8wzIDURCxR/Zodq98MY9zPZdq6zfpyP
	jYMc5CIBBM8YPgckpcXXZd6lG4XkD/E=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=NfkiC7Lv;
	spf=pass (imf06.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784734355;
	b=UwnvAqVILvldFC0fG4+KGgHLHQotV1ObmO2ciNufUdrzwPnFSupg5DbvB3XANv0ViEaB5B
	bjnIdI5/myEpNZVHkL4WKe7i3zx2pCY9+MChrIonve1D76tOFGUMvLTs1nolTofSpxcL9P
	xNF4wvsS8hToQcxEHc0E9rfHfJBEgto=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D8349168F;
	Wed, 22 Jul 2026 08:32:30 -0700 (PDT)
Received: from e129823.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 3C2C03F66F;
	Wed, 22 Jul 2026 08:32:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1784734355; bh=N+0eZVFONFvivh04pFsm3rodZPvFa4H4Z1CBMvqzBeM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=NfkiC7LvatbDCd8IFEJKF8ZzQvZpBgqSmEPN51LJZE/OVmfXd6Kf1RV8u98QdiPgM
	 Sc3KDmdXbmurBey1D3Gyec/7xVyT3SIr25WtNoBCd9mJQh5P1yBqO0wtbOkeEBaQJY
	 Rncag8lETm5J/fsgOKHBCJ7HAGeOqUsoIfiGTItA=
From: Yeoreum Yun <yeoreum.yun@arm.com>
Date: Wed, 22 Jul 2026 16:30:24 +0100
Subject: [PATCH RFC v2 16/20] mm/pgtable: catch abuse of folded dummy
 pgd_t/p4d_t/pud_t
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260722-dummy_ptxp3-v2-16-d9e4bad31e0a@arm.com>
References: <20260722-dummy_ptxp3-v2-0-d9e4bad31e0a@arm.com>
In-Reply-To: <20260722-dummy_ptxp3-v2-0-d9e4bad31e0a@arm.com>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=5534; i=yeoreum.yun@arm.com;
 h=from:subject:message-id; bh=RbMQD5F2uNPQ+fzfq37nX2jXCxvoUCfqc4r8FAi/UD4=;
 b=owEB7QES/pANAwAKAW3Vw9FaxTEzAcsmYgBqYOIXMUxfLBwQNA0FIBBhvMbs4KRRARRynD3JT
 HzuiToRWiyJAbMEAAEKAB0WIQQtg+CS3QUzuFh1pJ1t1cPRWsUxMwUCamDiFwAKCRBt1cPRWsUx
 M0SKC/9z/oLmRXpGI7R7NVtOGVIq9NNiulEe16gBiTJgA46ihrPkasRKG52jT80AXsQVVbZaXT9
 i3X4aW4yt4fTJxnu3ko1a/XelioY0dgfCQ4sDg0fUz15D8f2+v4Y2PYvMR3pIQD3N7C/ggOgGIb
 9Q3TJOAiiJYJVqrnXo6KtJWn5tSUjn9PswQL7/IDQXKX9vgqT5l3KdJZfTNE5I7sfHF6K7ttu7+
 zMT5/cnS1/2UesAImhBoDEff0L0eOaF96/68J3JOjgwvWhLK9J/canHwnJfAkTAmSRVipqNZ6cX
 4LdenlvLBRDPOTjZMfgQAy9BgoDbuDQo1L5QhNfO1GbpWqo5j47OK3SQtZG/1sn9xYz6sY7CNwv
 fw8Up6GkUZ878lkind26TxxiLVtbKbeQWHxU9ydtsx8CO9k9TlJ9TOATr2Lg0v051sNz0bLQGGK
 0OQmLx2FO+zKWoPqe9xZRdRVl0zbG9UWFnQI47+7vThDXlp3iAUIFDBzJQ+TuPZwxkhQY=
X-Developer-Key: i=yeoreum.yun@arm.com; a=openpgp;
 fpr=2D83E092DD0533B85875A49D6DD5C3D15AC53133
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: B35A8180003
X-Stat-Signature: qqtzadg13ds18d48kpfih3qseo5gcngq
X-HE-Tag: 1784734355-828521
X-HE-Meta: U2FsdGVkX1/2aZfjaUc/3SfAqHxeV1WbF9TEdUjs9TM9n++WcTu7j21NmkW2EUL991r/dbA5NGYIj5QKP9TTgDpMqPJzcxi9CDbebSkp2xfr85KsetqH0sj9aNdHjIkkhtMlfHcmXRiKEs5GOENO/rGhrXDkVcTETeAawZv4R0cZ0vYVjAO82UqivgBXxqxi2SR1XBxHwSMFUjnUjYhSSIepBK8fx9qRWJ7Sa8BHszyDmfoumeb1P2MZbXmOXRAlnETj48nL0Wnjl1gfg7rZSTeG79VrqG5+sIGLTPJqfclOx71Z8A1o06xrsehopF1FMC7TTFHH4o5sWj0V330dw7+m74BXIrsALafkbTdCcYiRPJOLmq9DV8NY696KVNuvIO/Z8NSbe+sj6RxyeBjebJ2iHn3YF4qYGALT6L24m6ANtNBknLMdYIfjguVXubDxHrsnVHDcec9ot2hef7kjsJ0fBGKTharXl0/6hJP7XIqnrgMzs998d5AkXWZNtUmkCLTIEvO1II0S6TPAqS+YOx9NjNLFKnOxgW+HEw0UpM7qqnqE8JJVldrrcun09gEHEEQSK55Ou4/RXUXRaiK2DiK1m8uRoiKdiBDUdkSsR2KVyRXpUK/iKNIBcDDmcZTcAorVb25pDK+PwIJWcpJToBH1QYnuleUM2K6cs9ejIvNO5cP8TtfkFa6dVGVXVuicO/Uzfc2nTebrvLK3zcWxIkF28aXWQONen6CFybycyC4HdbpzZMlZ5FxVizdZLceu65icI7IdWo9apOs+e0ay54jzQCExYJAZa/MJsECJfpBnP7gO2slGk6vZATj9uRoOEqw4FR3KaFC/7cfBEp+6LqKSzh1YoE2qN2GMbCzXx9QBvXWKNHOUiPybZTbV7n+BG2BbrFxZ97d2Fboi0e5HsCMQ5wmx/xm0EbaHf8ezvHNDPayEtiJktOf3LskW/HalX57yYQjy9BMJv1l7BmD
 AKIHrraH
 HMu0d7jmxoNFG0Lr3CeqvMM52kXKS5hMSzB1MPE3KI+NImtaTFa3Pt+BDjyhbfA0UOLYDWMD6040Z60if6AQuFSLKOhcv4wUvp5x4vW/op8ixdsjNE//VxSUOPV8279NCnM91yjOrOEv3fNVn33L4yatJAu/SLtLqbsm/Qv2iMnvIh2yrQejSEW37pKeRZjCAA+Nn4QuOreK7XTaHlzfKdBMCifbh+YGJ6dOegS46s9a4UZBs1QJfoZSgoEONf+zSIcAsm2DTTM8zQec=
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
---
 include/asm-generic/pgtable-nop4d.h | 23 ++++++++++++++++++-----
 include/asm-generic/pgtable-nopmd.h | 24 ++++++++++++++++++------
 include/asm-generic/pgtable-nopud.h | 24 ++++++++++++++++++------
 3 files changed, 54 insertions(+), 17 deletions(-)

diff --git a/include/asm-generic/pgtable-nop4d.h b/include/asm-generic/pgtable-nop4d.h
index ab4a826b3404..9e9e4557761d 100644
--- a/include/asm-generic/pgtable-nop4d.h
+++ b/include/asm-generic/pgtable-nop4d.h
@@ -34,7 +34,7 @@ static inline bool pgd_leaf(pgd_t pgd)		{ return false; }
  */
 #define set_pgd(pgdptr, pgdval)	set_p4d((p4d_t *)(pgdptr), (p4d_t) { pgdval })
 
-static inline pgd_t pgdp_get(pgd_t *p4dp)
+static __always_inline pgd_t pgdp_get(pgd_t *p4dp)
 {
 	pgd_t dummy = { 0 };
 
@@ -42,17 +42,30 @@ static inline pgd_t pgdp_get(pgd_t *p4dp)
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
index 711e12e5d180..f92ddcea444f 100644
--- a/include/asm-generic/pgtable-nopmd.h
+++ b/include/asm-generic/pgtable-nopmd.h
@@ -44,7 +44,7 @@ static inline void pud_clear(pud_t *pud)	{ }
  */
 #define set_pud(pudptr, pudval)			set_pmd((pmd_t *)(pudptr), (pmd_t) { pudval })
 
-static inline pud_t pudp_get(pud_t *pudp)
+static __always_inline pud_t pudp_get(pud_t *pudp)
 {
 	pud_t dummy = { 0 };
 
@@ -52,18 +52,30 @@ static inline pud_t pudp_get(pud_t *pudp)
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


