Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A8C48C44536
	for <linux-mm@archiver.kernel.org>; Wed, 22 Jul 2026 15:32:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A7FAC6B00DA; Wed, 22 Jul 2026 11:32:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A564B6B00DC; Wed, 22 Jul 2026 11:32:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 945D86B00DD; Wed, 22 Jul 2026 11:32:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 6AAD96B00DA
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 11:32:52 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 006FAC0245
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 15:32:51 +0000 (UTC)
X-FDA: 85016805342.07.3D8CAB1
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf08.hostedemail.com (Postfix) with ESMTP id 20A3B16000C
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 15:32:49 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=Z9iQmzRI;
	spf=pass (imf08.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784734370;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HnJ4+dHf8jsBzBjQ9rsg2ZSJwrG4H1yPEKkLqaEtc2I=;
	b=xHPS06lzzZZ3v/nP6nhrAPi/ZJCh9w0eG5zq+rSzytm+G8b/tMUPagJFV/9YmaAqDBjRfw
	SIpUbYN97N/beALiNj5ntq12SoGgoAy347QR1E4DLcyqsPA49j65yCaZb8juer54nOVtaH
	rX3rRhhcScUHD+Gs5XnwP8vJ/2dKJfs=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784734370;
	b=qGYdAovQ8JxlZVcbzZJJ5SfIBJzahuq8NPTVPmfWLe8vvnrO4I3Xnvtgl6auN4n6IYEQDe
	DEH0NSiT2prmjgX9x2ApdY3p8n6IibnNrqA9YnlzJ1yvk0dYz6kplUflt7/fZ5oTPYv5ru
	xsolHyAUBWIcqn5oc0b5pzutAWZAT+w=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=Z9iQmzRI;
	spf=pass (imf08.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0DDC5168F;
	Wed, 22 Jul 2026 08:32:45 -0700 (PDT)
Received: from e129823.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 6AB133F66F;
	Wed, 22 Jul 2026 08:32:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1784734369; bh=32SOK5uh9E5GblRgaV7XM5xO+tgYklgQI1N792ThLp8=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=Z9iQmzRIV9pJnoh2hiGVa9ykrtfqzzjDRhpsVG7HB9mUxK1Ydq79kvbnesR5P85vg
	 l5qCgCFo61s2z6vCbkE9bR3zFUgYTlJwz83TKSEc0aENmhFNGRIAQ3EbNpHzJLxnGS
	 JEq4PENZLBxO5Ajnd4KcJxsDCzfyRWplfYCjcNpI=
From: Yeoreum Yun <yeoreum.yun@arm.com>
Date: Wed, 22 Jul 2026 16:30:26 +0100
Subject: [PATCH RFC v2 18/20] mm/pgtable: disallow calling folded
 set_pgd/set_p4d/set_pud with dummy
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260722-dummy_ptxp3-v2-18-d9e4bad31e0a@arm.com>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2943; i=yeoreum.yun@arm.com;
 h=from:subject:message-id; bh=72r/KAfsnxC0TtxtNsnKFwa+EPFsf1mj7ooxl5Dvfk4=;
 b=owEB7QES/pANAwAKAW3Vw9FaxTEzAcsmYgBqYOIYpRCL2kb+SSUvVch8xReBRMPEyqCZIVn8X
 b/zh0aeNKWJAbMEAAEKAB0WIQQtg+CS3QUzuFh1pJ1t1cPRWsUxMwUCamDiGAAKCRBt1cPRWsUx
 M+pbC/9CtkmpOcQ9F4GGyLnOuiLOEo5b2ROwD1I5zPd1cPHGuVTNUZXHqOLTTLv+feYvEaRNS3Z
 IURhne2r5mprDEF78/YPTYMXnMHtqv2lrbabG6OVkp8cC54ISx13HX75MGXoTZnKz4kVIuTHDQN
 iy95ZvXGHln787hkEX1cila15mNcOBZRLTpB5wTUPuo2xeaQxEUwN5tBg578CXt3rFT2Z0kTDDm
 aDJnKlAyUDoc9zOFK7KHnYUvXU2myPODDiuJXp3rWmAZjMBvarSdGTkbAww6NLEBebM7kGyl4KN
 AF460tD32ygD8fYb2KRxPuECIt8Kw0VVf2M0wcJmMfOIHiUFl8FXcatscWKDuEqDy6vFa7+cPcJ
 yw9ypwNhnSgFVejzmjhJqtSzTppFlH0iH4p0RQNUGe+i1lo+NCeNyetGLAdAbcNug3p+7MvZoaN
 f+L0PmWXEePXWK4caevkf2aHZEHRkD4ToFUz3RuAB9s9Do544YGwAjEdmnP5hpsMi6da4=
X-Developer-Key: i=yeoreum.yun@arm.com; a=openpgp;
 fpr=2D83E092DD0533B85875A49D6DD5C3D15AC53133
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 20A3B16000C
X-Stat-Signature: 9p9bw7wy3y7x4gqiju749hti86kkbpfi
X-HE-Tag: 1784734369-291079
X-HE-Meta: U2FsdGVkX1/2l2b4fHCpKFMMrt/xtskkhU2sfoIj4sLc54qQwJQFhbptK/cwgnCpbTuBn8o6Tea2uiyEdfHRSb1W7+IKTKGWNejE8rAtgZySq/NY2v02F0afvZeB5HMdexvStEDdrjydG73MdWILYSd8OAn9Zl6+wABF8ORoyv1MCj/vxyl+N5phPFVHqfJyAOLpz/IJB4pljJyv8TktNa7b8mPH8D57f1VVSvKTqFnGGAgPlRycheEvE5l7kQe5oOWMne/X8ZHZ9z9zl77OCdz9gLNWd0s7bmPwgCnTPUFyxINmDkdClJs2Wjoc7b3/IHpNUVczl/p+JaYxxsk4BEDMrx7j+Ff9tkjU7ExLml22eRprX+vL73UwyAw0QIizmBlmcZWe6fXKXcPs9+2MMiE80cpoObIsSwKm7n1Z4m+/N63bE1x7xLFRAU1p0sLmUw53XjJXE9NMXwxjDI1LZbDGn7TsjHBNfggoheIBI4ru/Ep7I1fT4fueIcwAA05Brbe/bwGceqV/D0+62N3zXMxjvWK1vPeBW6jmDgvcPHgSjQzhXVgeg2pmtlQOTIi9CtWQ/G/E7tOsVovW6flcsI7XOC7YshOEhKVuLUEmUEXWZHx/H0ZDcFVqY9aUmRbEPJtiXnRxGdhjdtodjQFy4LZIrTEUXNcS0pknPbqCiEqTzE/PrQF/qUq2812ixTjL4nCJBv2tNpRlInmBksaStAQkMB1MIpLt3+pWkbBDxogoP/zR5DgUs3DbRlHDDm8vXU95nqM3Tlvq6xPSUtNoLrox2KlLLnHukfU5ZXninkMdGIBz5h7E1lDM+S8fA0XWSRaZW6eiSrpp+nM2+lpzkY6pN+UZgU9YQKo+B2iM0r+det4zyYoJPKf6x2y8A9yoWQpzkLctlM0JNq/GCoCHwjSF/5JWk5vwXkPV11cHrBkg40skOlXxBCQsZr8cgbG23P1tfNAXBomdTGfggwh
 fd8mHRxq
 yeQgqz4I8zoMV8MPm75OJlUhKZq+Gl8tSsEvFldy230lLU1L6GJDR6JUQRDuCAApc9L/DGwB0V4oxTIb/8sSQb3iLIyxlwhXi72Iy/bPks6b51fZ7h0erfWYfy1aoTxPqjCHjIo9X/KWureatuug2bJdBALrYdQI6Mcx4363F4h+Mfivv1f+FxMHijpO6/nULTa5HpFb2vFwrWQLdcecgJXJ1wvFjoAylFUmEWI//ehbTMQ68ZKsHs45bl6Uk55Ctv6jygemjYqpsQTQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "David Hildenbrand (Arm)" <david@kernel.org>

Make all code compile-out any calls to set_pgd/set_p4d/set_pud for
folded page tables. So let's make the compiler complain if these helpers
are abused with dummy.

Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 include/asm-generic/pgtable-nop4d.h | 11 ++++++-----
 include/asm-generic/pgtable-nopmd.h | 10 +++++-----
 include/asm-generic/pgtable-nopud.h | 12 +++++++-----
 3 files changed, 18 insertions(+), 15 deletions(-)

diff --git a/include/asm-generic/pgtable-nop4d.h b/include/asm-generic/pgtable-nop4d.h
index 05c3acc0884b..19f5a6eda76c 100644
--- a/include/asm-generic/pgtable-nop4d.h
+++ b/include/asm-generic/pgtable-nop4d.h
@@ -28,11 +28,12 @@ static inline bool pgd_leaf(pgd_t pgd)		{ return false; }
 
 #define pgd_populate(mm, pgd, p4d)		do { } while (0)
 #define pgd_populate_safe(mm, pgd, p4d)		do { } while (0)
-/*
- * (p4ds are folded into pgds so this doesn't get actually called,
- * but the define is needed for a generic inline function.)
- */
-#define set_pgd(pgdptr, pgdval)	set_p4d((p4d_t *)(pgdptr), (p4d_t) { pgdval })
+
+#define set_pgd(pgdptr, pgdval)						\
+({									\
+	pgd_check_dummy(pgdval);					\
+	set_p4d((p4d_t *)(pgdptr), (p4d_t) { pgdval });			\
+})
 
 static __always_inline pgd_t pgdp_get(pgd_t *p4dp)
 {
diff --git a/include/asm-generic/pgtable-nopmd.h b/include/asm-generic/pgtable-nopmd.h
index aa4902f63c0e..61852eb4b150 100644
--- a/include/asm-generic/pgtable-nopmd.h
+++ b/include/asm-generic/pgtable-nopmd.h
@@ -38,11 +38,11 @@ static inline void pud_clear(pud_t *pud)	{ }
 
 #define pud_populate(mm, pmd, pte)		do { } while (0)
 
-/*
- * (pmds are folded into puds so this doesn't get actually called,
- * but the define is needed for a generic inline function.)
- */
-#define set_pud(pudptr, pudval)			set_pmd((pmd_t *)(pudptr), (pmd_t) { pudval })
+#define set_pud(pudptr, pudval)						\
+({									\
+	pud_check_dummy(pudval);					\
+	set_pmd((pmd_t *)(pudptr), (pmd_t) { pudval });			\
+})
 
 static __always_inline pud_t pudp_get(pud_t *pudp)
 {
diff --git a/include/asm-generic/pgtable-nopud.h b/include/asm-generic/pgtable-nopud.h
index 3264673c0c38..5ee8f1852cd8 100644
--- a/include/asm-generic/pgtable-nopud.h
+++ b/include/asm-generic/pgtable-nopud.h
@@ -35,11 +35,13 @@ static inline bool p4d_leaf(p4d_t p4d)		{ return false; }
 
 #define p4d_populate(mm, p4d, pud)		do { } while (0)
 #define p4d_populate_safe(mm, p4d, pud)		do { } while (0)
-/*
- * (puds are folded into p4ds so this doesn't get actually called,
- * but the define is needed for a generic inline function.)
- */
-#define set_p4d(p4dptr, p4dval)	set_pud((pud_t *)(p4dptr), (pud_t) { p4dval })
+
+#define set_p4d(p4dptr, p4dval)						\
+({									\
+	p4d_check_dummy(p4dval);					\
+	set_pud((pud_t *)(p4dptr), (pud_t) { p4dval });			\
+})
+
 
 static __always_inline p4d_t p4dp_get(p4d_t *p4dp)
 {

-- 
2.43.0


