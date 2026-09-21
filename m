Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 39FF7C982E1
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 10:57:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4168A6B00BC; Mon, 21 Sep 2026 06:57:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3C6DA6B00EC; Mon, 21 Sep 2026 06:57:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2B57E6B00ED; Mon, 21 Sep 2026 06:57:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id ED5CF6B00EC
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 06:57:16 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 7A3408013B
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 10:57:16 +0000 (UTC)
X-FDA: 85237467672.05.E0EA344
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf12.hostedemail.com (Postfix) with ESMTP id 9F14840004
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 10:57:14 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=Xin7nkqt;
	spf=pass (imf12.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789988234;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1XXfVIkNP4nITGpfyLSUIpM9B8UBbVvkEA7ohODjLRw=;
	b=YHVlPwVMV8zlrLMTxMa6C2XTZYWdOQEVvglElBCPz1pU9Ap0PO3kY8WcOgX3PekDHN4hv0
	SzUIUU4WlL/iQzjqrrS5oyOd8Aora1rUvbADjdi7Z8fZ72VpQiVuUzheN6GlLhPmRGW/cE
	ceY8jVoXXzxBCgNyp/RgYsplRjBDA2w=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=Xin7nkqt;
	spf=pass (imf12.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789988234;
	b=AWVFVFcYoJVSAiYEFRWuMKQWm+j2fCQKxZBNFhATnw+VEKX6R3ad0aVEjRC/FbgpdqmnKB
	wN10WBsQXA8UZ4CvNarQ7irTZnejrUiq0SwwCH242PPGNzHG/L6NAKsOqq9Knp/3VRO9iT
	XLpS8irkcKZV8F3RBJtwhuvm8lbB7Vg=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 60C1A1CE0;
	Mon, 21 Sep 2026 03:57:10 -0700 (PDT)
Received: from e129823.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C61543F86C;
	Mon, 21 Sep 2026 03:57:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1789988233; bh=evfeL7lk1yM+NSCKYrKsUpK8FtfFqKH2c2v1uANMiZA=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=Xin7nkqtoZA/IKaN1bsZASwfU+1NECaZN6VEF7DCQgeeZsASTdyE/P29B2ESqDwcR
	 3PrnBYPE/iqT9P6uIvyqAv78zmz38U4I100s9VY7jCzhFHAKe9uNEexPk71cCPA/I8
	 rPv9w1Vloof+Vj/9mT37AC9r1STb2mNCpt1D2qq4=
From: Yeoreum Yun <yeoreum.yun@arm.com>
Date: Mon, 21 Sep 2026 11:55:28 +0100
Subject: [PATCH 06/21] mm/pgtable: define (pgd|p4d|pud)_leaf() for folded
 page tables
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260921-dummy_ptxp3-v1-6-cd40cf68242e@arm.com>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2651; i=yeoreum.yun@arm.com;
 h=from:subject:message-id; bh=MsUi6fKiy4C8DH1qxUfB7PhJ8/xMmbWjYscC+NJ7HZ8=;
 b=owEB7QES/pANAwAKAW3Vw9FaxTEzAcsmYgBqsQ1NMAsihcMqWtTNq8wXGlyLqx/OjaZfBDhWO
 BQRXRP3kPaJAbMEAAEKAB0WIQQtg+CS3QUzuFh1pJ1t1cPRWsUxMwUCarENTQAKCRBt1cPRWsUx
 M1JWC/4oEz21sKhzCLwgY6I/1KB5pft90w3HXdaylhrNZwNhAioe8Je0Oz2Rjw8hBIMkvhd3e0w
 zA69tHAwWWTuBHTswnnt0DeIqTvlxzCwlA48r0Z7UkYQkkd1IK5dTX+29BumgcET7QxrdKuGFc8
 8RI08NCJyK3BuFSev/59cyoZFG0OX6kdSx9hMs3055MvaT8IVAv9XSclmUpwINFPH1qeA8l3/Jm
 JTv+7Cgpp9VtbAss1UR0jmvFTjHEyFbVvzemKonJiLlgg2DGpEZjwSU7hkvNUm+6Ni/AqDrrHJK
 D1EaTGvZDnm+C8lMK1IDSiqwgTJKIUIAUrgVzEh4QIp7qyoMLw2GuKIv+1Ztdzoi6z+CYqlpDUj
 L5tiwukcbc94p3teYqPPwP+UnafkHm0JuyqywJaziI4mD1XrAKI1OMPviw0mfqXOwyjjB/BggSq
 20fhyXt51a2D5K+CexmOCQ/jx9XLyZmEWUJInumOy6SrMuxQhUsc9KzqpJGjAszheuAWA=
X-Developer-Key: i=yeoreum.yun@arm.com; a=openpgp;
 fpr=2D83E092DD0533B85875A49D6DD5C3D15AC53133
X-Rspam-User: 
X-Stat-Signature: 4mw56ds7ims8rsg3qks9gw38r4cambro
X-Rspamd-Queue-Id: 9F14840004
X-Rspamd-Server: rspam07
X-HE-Tag: 1789988234-833078
X-HE-Meta: U2FsdGVkX1/ey/IhQNGbCborEBiqmSlaTmzNmGJtoDQx/Mae35qU1dNMdKBUWVrUbzfefY1IShW8gEaPjfwbDXi0E3TQMX1UaKYnbLx4LmM53Ucm+zariBoBAcyIRGZLdMAAXSVy2LtAqDdsBuIvys+4zeux8xSpHaHM3f93jzg3YLSzOV6k7e+n8cEZMjpQD1LIbGzs/D4bt9Uxffog8JGhbm1ZXYlvtQFSyAYJ026T8YtMxaHA86fuFZ0vjVLXizkJZ5tTSk+NsXKXCxcnb6H3NoDK0+VypdTXSpE72EIheZopbXIKsxD2a3T5GxVFMe7TwCWzZhYUxNNO9OKMpc+zgOtZ506rPnGmJMt7iQum+Ly8lhvhOlL2I3qY2Y2xS2lMCgZRhSixQtg7yC+GjLFKD+apjosWAHs5bhc7wZFgogRD4dWFtoGUW64FSY08X3166s68ArTE93Gbh/P7k3ZDoHtnsZYCLzhCxYtC5qkK+LAV+i5Y0qM/IH0TRYugA5t1RVk8YORkwxTGRZiLVs++RiQDjCMgPe08TF/zWEgKK5THRWh/MbVuVfcVn26q1nXjMW3Edz7Qq5vEc142C+0N8d9acsnvqE5ynjmrKYZCjzt9fvkrQPgODlMhh+deihe7WSRDuU3YZhYI/PxnIzJoc/nVjWQjg1lGYadGduUr9JDIpctjjBD39F73Tv/eZ/0HSKxxPfhwoYVSPALoU2Bolg02LzTXmnqz5oGILE293TJ81lYQYACtmmyaJzMhHiQfQsrrDanQdZFY4eIQMLr4LTefRXfw0OlI+LENvEqRQWlS06sj0l3xJq1EiMlZUmHZ1ek/1wm2F8VebM/9rWarJqWxhNLu/VHDJQOwSoPwABqQMhXIPVNwSDH6Wkwm0S3Au4S2xrKVpOrwQ7TIYMBUEB9K6NHFcDiLJsSI9XZJ3dV90jvmmsoKZHwXkjjlq1g+vNxF+n8np4d6qiY
 KQ9e02Ud
 YHaelYt3b97eBHhm3/6nafbOtVRMTM9kgKXSaellq5ugeg7iWApUrnqf/9sHRKODJSb2bWzqgSRzlVlnrmigfwOne2uhHO4xVC81sB2dkXytfYTds/gvQ16Ly3WwFXlDs9GoMJIyW3nbox9ObcBeDXWSi5+cae47HHq+u3Rn/rKE6eOF6lLnO/DIaFB4ueKzC4SYF0ceXSOxCc7mexYKO4rZRDtmfurF9t1lCv43p1lZ6T7G3Mzv9AyLCcsuU9633PePw7FUjQUlVgQo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "David Hildenbrand (Arm)" <david@kernel.org>

Define (pgd|p4d|pud)_leaf(), hard-coding it to "false". Note
that it's missed to define pud_leaf() before, allowing architectures to
unknowingly overwrite it.

Still use static inline functions (type checking), and while at it, just
use "bool" as a return value.

Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 include/asm-generic/pgtable-nop4d.h | 3 +++
 include/asm-generic/pgtable-nopmd.h | 3 ++-
 include/asm-generic/pgtable-nopud.h | 3 +++
 3 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/include/asm-generic/pgtable-nop4d.h b/include/asm-generic/pgtable-nop4d.h
index 1cf739ee38aa1..c6a5a43899b50 100644
--- a/include/asm-generic/pgtable-nop4d.h
+++ b/include/asm-generic/pgtable-nop4d.h
@@ -22,6 +22,9 @@ static inline int pgd_none(pgd_t pgd)		{ return 0; }
 static inline int pgd_bad(pgd_t pgd)		{ return 0; }
 static inline int pgd_present(pgd_t pgd)	{ return 1; }
 static inline void pgd_clear(pgd_t *pgd)	{ }
+static inline bool pgd_leaf(pgd_t pgd)		{ return false; }
+#define pgd_leaf pgd_leaf
+#define p4d_ERROR(p4d)				(pgd_ERROR((p4d).pgd))
 
 #define pgd_populate(mm, pgd, p4d)		do { } while (0)
 #define pgd_populate_safe(mm, pgd, p4d)		do { } while (0)
diff --git a/include/asm-generic/pgtable-nopmd.h b/include/asm-generic/pgtable-nopmd.h
index ff4235cf84d77..4e5aaf253b6a5 100644
--- a/include/asm-generic/pgtable-nopmd.h
+++ b/include/asm-generic/pgtable-nopmd.h
@@ -31,7 +31,8 @@ static inline int pud_none(pud_t pud)		{ return 0; }
 static inline int pud_bad(pud_t pud)		{ return 0; }
 static inline int pud_present(pud_t pud)	{ return 1; }
 static inline int pud_user(pud_t pud)		{ return 0; }
-static inline int pud_leaf(pud_t pud)		{ return 0; }
+static inline bool pud_leaf(pud_t pud)		{ return false; }
+#define pud_leaf pud_leaf
 static inline void pud_clear(pud_t *pud)	{ }
 
 #define pud_populate(mm, pmd, pte)		do { } while (0)
diff --git a/include/asm-generic/pgtable-nopud.h b/include/asm-generic/pgtable-nopud.h
index eedee8e3ad68f..6c9bca78047c4 100644
--- a/include/asm-generic/pgtable-nopud.h
+++ b/include/asm-generic/pgtable-nopud.h
@@ -29,6 +29,9 @@ static inline int p4d_none(p4d_t p4d)		{ return 0; }
 static inline int p4d_bad(p4d_t p4d)		{ return 0; }
 static inline int p4d_present(p4d_t p4d)	{ return 1; }
 static inline void p4d_clear(p4d_t *p4d)	{ }
+static inline bool p4d_leaf(p4d_t p4d)		{ return false; }
+#define p4d_leaf p4d_leaf
+#define pud_ERROR(pud)				(p4d_ERROR((pud).p4d))
 
 #define p4d_populate(mm, p4d, pud)		do { } while (0)
 #define p4d_populate_safe(mm, p4d, pud)		do { } while (0)

-- 
2.43.0


