Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8B931C624D0
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 11:59:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A2CA56B00DB; Wed,  2 Sep 2026 07:59:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A04C86B00DD; Wed,  2 Sep 2026 07:59:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 91B326B00DF; Wed,  2 Sep 2026 07:59:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6AF876B00DB
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 07:59:09 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 0A53C401AA
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 11:59:09 +0000 (UTC)
X-FDA: 85168676418.10.C1E2733
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf19.hostedemail.com (Postfix) with ESMTP id 40AEB1A0009
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 11:59:07 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=t99y+xgy;
	spf=pass (imf19.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788350347;
	b=dRrpjEpuvrL/JMWhloG/83nv4lz0MXftwYR5Li5Y0fT8OLs1KHHtSCKuGNKFUmy59de+zC
	apb0XKWHc45bnIVoXtZ/R6pcaPxAO3ZQhB5Ga/ZCpae4Q5WeFmAfIKj5V86LdOn295PSEV
	zuAnAYUL13Q1W5mAv4/iySYezn1MyOk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788350347;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9eB+ckADl6cNZSWU+azu196Av1opZMRhWv857WroVYg=;
	b=4yODhvC9A0E5LQ1HQsaLD4d1aGBTdfdQRCFaHGoecNYa6TP2aa+L2zCA5QHeC4o+CgpOm+
	W43jFGcet6DIeiRgEPb3gV+VuywUvJp2+f6fdXozcvDbZK7FFto/3ypSJ0niAvSjM1EYVI
	xwqDuSKAzYKO36dGIfyQVyKz85rMRr0=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=t99y+xgy;
	spf=pass (imf19.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id CF2F91D70;
	Wed,  2 Sep 2026 04:59:02 -0700 (PDT)
Received: from e129823.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 56F7C3F85F;
	Wed,  2 Sep 2026 04:58:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1788350346; bh=AfwOXSEHMTQsnG2+qWsR4+w3Q4/ql0WTR/iHlOKjwaI=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=t99y+xgyLegCQNYEHLqIP1/4h51JZeASaITofkJ+uqtcnjVBOwDz220u8Kq+eRfGY
	 GnRjjt56vNhz6+VrhW6JOdO6LVlc8nFY5XIeyl26nMP2KZU5TsZCORV8vVd72ygs9A
	 8XEICkOS9ziFjCyhFlw063vS0574g7wl2P4smJ3s=
From: Yeoreum Yun <yeoreum.yun@arm.com>
Date: Wed, 02 Sep 2026 12:56:22 +0100
Subject: [PATCH RFC v3 20/21] mm/pgtable: disallow calling folded
 set_pgd/set_p4d/set_pud with dummy
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260902-dummy_ptxp3-v3-20-5d8f5b17c25c@arm.com>
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
 linux-openrisc@vger.kernel.org, Yeoreum Yun <yeoreum.yun@arm.com>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3417; i=yeoreum.yun@arm.com;
 h=from:subject:message-id; bh=9L1q4F5kPd3azF2pD0kiOqnAVRIpN920wuNvT7C/1AA=;
 b=owEB7QES/pANAwAKAW3Vw9FaxTEzAcsmYgBqmA7rB7zMDTJiWjAJpFJrQOzF3ZWkpsd/OFNQX
 B7+gQ6qR7mJAbMEAAEKAB0WIQQtg+CS3QUzuFh1pJ1t1cPRWsUxMwUCapgO6wAKCRBt1cPRWsUx
 M9ShDADCzv6zsjlAV5TzwCcUdqbNBXk1JjPzUyfDC+vb7W9bj2Ta2yGc/81HofWsmyx9kuhVsnT
 CXpHFei3Q2/ZYfQ6S0QwakGaA/NEjRDvU3LnV7JGb+UKNAXsACT02nLqR6NwNjP+aM1KBPp9rE1
 qnmlv7mrg849enZixHGNAMVNSfzDIAX6eQV2HhbAnqfatjuB6QXfD+EqC1Pw2E+rKryr4Un2a0s
 SRK7v4I8nAxccfMBHnX6aKgX2Bm0T2wAPyUOQExlQ7M5MPOwPynM/E1NYUpVvCnoMlRqcGFM9vn
 G18AewtF84hchri946QSiUxbliKRd9DyKB01EJwtFrykJmwJShwtxsDXqR3oBAoywTjnosH/Pth
 1U8tMzqBhyS/nHfubwvnGd9VWkmqfBnqY7S/VQ3q8stNtv32OfwTMVd1OYgtAjc0bCqO9HRycPf
 imeYM8+4OUhsTHXDwVrJjJUU6J0g7YqhDEBoNQmfCTF/QlvZdX1AF/BzeE6Nq6Z9Y66HU=
X-Developer-Key: i=yeoreum.yun@arm.com; a=openpgp;
 fpr=2D83E092DD0533B85875A49D6DD5C3D15AC53133
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 40AEB1A0009
X-Stat-Signature: 1pbgycj6cn4ezukgogi1tkcra3ui8itn
X-HE-Tag: 1788350347-178064
X-HE-Meta: U2FsdGVkX1/Jbt8wJT7ZmhrCZEkErE8S4oA7ECOD9yHfM/tyU4rOy4u4Fv7PEMmu2nf+OT/+M4valiuH2eUUAHXQpqww2kM3brFj87c+Tm1QXVD+iFpmTPAw+4IOYmm0XnX8SfoP5fCH2I3Ah/E+7UcuXlDlUcoZzF6Yq1e3/f2jNzaEg/8M1N7wYZXDRfFPl9TorcSrWNKcJbygIdZs0rrK7XuCWqF6PaSUP6x4gwLWTumIJQQ7m5SANvwho8yyKuoYXWpdhW3h7gyRssICNQNhxd85G6s2rowON8MlJK3pptjUIDF3C7zv0oWugo0Pd2ayUxxoMRomnsKV3AyVkQKoMmMZBKstfBRuqsZL5zTz7jK3LCXsHXD7cv7169c1uF0VyCqPhio8Nc6v37HjScfK9wTQ27fL3Cp6YJSqHls7R22B3uQMhIl6FE9DdOU81n3lXoPfsk72a5lrXv1u+eOEE3Jslxxery7BNtzEQYvgqa1xmkcHD8AuO9VbLewIlRzy9MK6B6PJjYx7F/XgV0A6lnQ1eH7dCrTLfk5bGwVYohak/V3mjDInTim+LUi7+EnIPZZ1nuwX2h3LjB+ueZYGbo7f69RxoqpgpCqVrsICzIOPBge0TyRvVAh+W91wJ/rTS245GQerpzcLplqGholy5gV5gKuuDpI4yKzud5imCO/pTwJt8lqBX1w5/vNgT+k4pi7HhbweJ6a6/K9ioxPB5+AjU36YVvnNdfiCI4JLQCUlR+tSuTDNF3k2O5Lf6ChZB1Sdt0w5drFLvSZv8y6px6kqPJL8ktais4AmOvSYLR1HfcNHttO/cz9SHAaKc5x/egqvhjQK+d4g30jIZ3/QHKGHlifA9Roclu5rBe9ZO6qxJiHVNb31EWCI4ddhCUhJgWtCTHNknFnywXsG0lPTEMOp6LGjqeDnn3oB9Qkz76EA8b2OOiGtEt7ryR25cWYookV7DATCt25NBvP
 Y2gsREgq
 TfZo+e7Vw0JTVx9djYZdQVVzBWM0+JnmWgtJ/paY+RhEz+9ZhiFIarEpRtKlNeq5u/72AfYQmA7vCLeE+E0UwWmZGZ55ylICR4vbgoywDjdTzH7uio2hZaQdwqIUjtDTfKiVWIRRyANLTESAjlvJZE4eZe3JLQM+T/JY+6RcOKrD0fm0KTahaBC1mBXRSxD/DctIDFAE4DyU7WsWtL15EwwvGwx1meyC7UgQuo8gt+wkPx/XMLT32zNHrFbhNK5UGyTV+gPltaS39J9gvygauxbeP5poR/DiXfDpMn9mETzUbJNUBUu5jg38LBwR9EOZfaAYcRkl+sdoZhtE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "David Hildenbrand (Arm)" <david@kernel.org>

pXdp_get() could return a dummy value for a page-table level folded at
compile time. Passing this value to set_pXd() could cause unexpected
behavior.

Prevent this at compile time by ensuring that all calls to
set_pgd()/set_p4d()/set_pud() are compiled out for folded page-table
levels. Make the compiler complain if these helpers are called with
dummy values.

Since there are places where set_pXd() is called even when
the corresponding page-table level is folded at compile time,
drop the incorrect comments for set_pXd().

Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Co-developed-by: Yeoreum Yun <yeoreum.yun@arm.com>
Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
---
 include/asm-generic/pgtable-nop4d.h | 11 ++++++-----
 include/asm-generic/pgtable-nopmd.h | 10 +++++-----
 include/asm-generic/pgtable-nopud.h | 12 +++++++-----
 3 files changed, 18 insertions(+), 15 deletions(-)

diff --git a/include/asm-generic/pgtable-nop4d.h b/include/asm-generic/pgtable-nop4d.h
index d2dccf7542da..12b01768134b 100644
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
 
 static __always_inline pgd_t pgdp_get(pgd_t *pgdp)
 {
diff --git a/include/asm-generic/pgtable-nopmd.h b/include/asm-generic/pgtable-nopmd.h
index 2afbf2d8659d..11b04c107129 100644
--- a/include/asm-generic/pgtable-nopmd.h
+++ b/include/asm-generic/pgtable-nopmd.h
@@ -37,11 +37,11 @@ static inline void pud_clear(pud_t *pud)	{ }
 
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


