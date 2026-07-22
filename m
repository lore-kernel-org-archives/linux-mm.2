Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5883DC44539
	for <linux-mm@archiver.kernel.org>; Wed, 22 Jul 2026 15:32:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 54DE26B00D7; Wed, 22 Jul 2026 11:32:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 526296B00DA; Wed, 22 Jul 2026 11:32:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 43CDD6B00DB; Wed, 22 Jul 2026 11:32:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1A7EB6B00D7
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 11:32:45 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A4A901C01A7
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 15:32:44 +0000 (UTC)
X-FDA: 85016805048.17.EEDF4F3
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf22.hostedemail.com (Postfix) with ESMTP id D5AFAC000C
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 15:32:42 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=B0aehDdF;
	spf=pass (imf22.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784734362;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=x2DEG0/lsSMe18330BYMAw9oq7fwFgPePemeHXeJCXM=;
	b=NxkFg4ZO5E8MFN/BdY4EN5vUYPJ5veQ0l1iNdOKDEVQrt3GLeQuCUA8U7VeLJrbokCQcyV
	8S5A9bTWtxLEe6QDqp6pw+9z7MGKFMH7M+64wXJshWgA9zQCRJaVeLRenZtR04QAh5zQkl
	tXaQmqGqFVXJXw6Dyp5z+Zl+Po9cIEE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784734362;
	b=ZB6d08L825NuvC4RLmIyir3gjR7kdd941Uj0/YRHAZOGC5ye8btv+FA67Ah1iExlnjH//q
	9RoqKFgR+7rAgRn6PXizp9BEd9Et4qskJOHYSuUZyOG24X9FnjiToCc8NugRl8zjiBvH+a
	BYi1RNjdutitfT3Zuni9hAp1lCDENKc=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=B0aehDdF;
	spf=pass (imf22.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id EBCC7168F;
	Wed, 22 Jul 2026 08:32:37 -0700 (PDT)
Received: from e129823.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 546693F66F;
	Wed, 22 Jul 2026 08:32:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1784734362; bh=7Ae9Beb4KeYHYFDO2fuqF6aoTpqIj0FluLW/seeBxD4=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=B0aehDdFvBfvBVIIp2zMH67Lgu5JuiYLh/bHJAAXod1jJVYAFkp5Bu1vG2YdKZCzM
	 M0aFKyio40bPpN9seoAqUpmyTQoj/5ClQV8N33uLEYbIpsyIyeUsQ7VEjiJsJYIlX2
	 a0pvoqex/lEfvtzADdbbAoF90e4wmb3qWVHWRIYw=
From: Yeoreum Yun <yeoreum.yun@arm.com>
Date: Wed, 22 Jul 2026 16:30:25 +0100
Subject: [PATCH RFC v2 17/20] mm/pgtable: disallow calling
 (pgd|p4d|pud)_page, pgd_page_vaddr() and (p4d|pud)_pgtable with dummy
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260722-dummy_ptxp3-v2-17-d9e4bad31e0a@arm.com>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2991; i=yeoreum.yun@arm.com;
 h=from:subject:message-id; bh=ZfOIqDcnxaLeCJmpu2GHcBUFS7H+BCZkr1Bq1FmACcE=;
 b=owEB7QES/pANAwAKAW3Vw9FaxTEzAcsmYgBqYOIXWFr4tS39OcpehK5ArSSuOGxsT8KERLcOY
 bFidb6RmOuJAbMEAAEKAB0WIQQtg+CS3QUzuFh1pJ1t1cPRWsUxMwUCamDiFwAKCRBt1cPRWsUx
 Mxl5C/4/Z1An+pql6k/RmbweehPJhZeYR2tquIfEoDvMBJSdPiyFbCFjDDF/KEPtFyRTltpsXmj
 nzAORhubLrsQB4dtTfHleQt6PMQdVMtlXRJulqNEPQ0lMVYC+Ja5vR6TgOM8Xt0xVRH9op3YXV6
 XVFwxUasE+yRlaMndg/VFQoVgZ0KZVsEOU5OVbb884+BEebDjXZrWL6y9ayYhKEb1s/ASnpJ40c
 jpBwvMakWgRS20jzRBXxCWzNF7S9I33l9S8IpU7Vdc4xGcut0KxmytlqFLElSSrXBpBq3hZbef0
 R3UlALA31tYedWIXhixSSbGujT4BeJDB6W/iKmmZCGoUR71JyBQyljLM+dNRMWR81Cc8kdEGno/
 RRj1wyhyGYC1/hC07KPBcGES4CJ9xA0DCuprgpOcy2/x7Fh6vYNpcPWpse086hcBs731SXQJzI1
 RubKkCaWr4hOc32pd3WmnGvIsyxbARqJAr5JzesTLBpGF4nd4m0X533vaNfqsfo8IK0d4=
X-Developer-Key: i=yeoreum.yun@arm.com; a=openpgp;
 fpr=2D83E092DD0533B85875A49D6DD5C3D15AC53133
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: D5AFAC000C
X-Stat-Signature: js46s67p6tdhfdikcoxngskhrmrh8d5h
X-HE-Tag: 1784734362-369925
X-HE-Meta: U2FsdGVkX18pOr98RtlabFhYEdgYUUKbOZeuZPt0YZv5dX6Lid4vnd5VRtV8UZB2cStmqLrZtFV33Vp4sRCCtsAOGNZuP1Fc6ZrdiOQZc414ZeVE+Jcs20ofZHejUJAzz5VwEpQN5xljg6jHqDClr1wk7SfXHES5w98UAVGj0KeT6JlHcomXJFBOUksPF7HgYHoKWGzAQmJ+5auWKweyYiNhLOpVbH9Rpo6N+EG95+NDk85EvZjwGaYEJakQSYVEVwv7ijsXUuyXGULOmCbAdB2eOYe3/UjiH6A/hyleLuF9ccpq8LoFrH9owb49wtfosf0ZRIC1x/x+QOALeYv+kQOV67e2IVOnLhoclyAwrbIlTuCRvDF+72ijfR5PSwsOCKboNBgL3Ll9mS96UJ6dB1pitvWhCDukrz9ZGZOI9idwJP1k/NyAjz/JoGGsAnDs+dCxC5qiW3KuWFCxNHsy+QC4uHY/+9qEzzWyJQCHfTZ1GjPTw2r0OAWmsXkP61xI6WyKC81cNAoSytsHmzONVX9P1ZyAnNhGgpLF6mmmqkm7x0l9WqH9L5sC0KDOZn0F6jacj9nw4iIZ/FuyPQx4NgR5PjN42j7O2OSqBxequS4b7xNYfYLjCbo1NQVzglgJDDs27E73J+/VrMonpWODO6TZa8kXFMZkDw+S1EWXqqC2VHH1G13xehNzTrV/heAk7IL+LdPnevV3bCX0phFjSQd+a2YGJ+pUoORpPIMCz7up6n6ULn5IEWX3GjOBbJ2udgPiqWqeh//v9fHFsd/K/k6XB4WgtpkZInEAnH9l9Iv0xvQxG48cjoitT74LyobFDqbNfWCJFyzfZw5okh0DmsPKOKC6Kor1CYTBBu++hVBpD9GF7tjv+33bjF62E8Xtvvc12Ax8A0grdDYOyNBzz/LeABcCXWgJVMeN89l2puv6g2rEbcYQIE5gvcFmm+IxLKUNglGpp7BVANZXlUZ
 RaUHAlxK
 MNpRQRugKvPaukNW0yChT/twrVFcl9KL5XJz4RweYLozRAbv5IStEBdkhewdY6NMpTIh5lHQH5OqWruKD62sdFHNbsH1ljp7EyKkKaJavg5e5yW/sbqWZtEt+SMQ+waxuI+XPLVCap37yQIA2RCAlR+81zh3uWQ6T2/RO0uRl30XRxUXaQjcX+xaxtTIT+FgpMPHDQ+7pL/DGiE4oiQJc0c+NPDKpcYHozjx71WzoR/qZBhRvRnHJgaSrVS7Kbh+LZuchrDtm/FBkcZQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "David Hildenbrand (Arm)" <david@kernel.org>

These helpers that silently fallback to the folded level
are dangerous, especially with some upcoming changes.

Make all code compile-out any calls to these helpers with dummy value.
So let's make the compiler complain if these helpers are abused with dummy pXdp value.

Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 include/asm-generic/pgtable-nop4d.h | 8 ++++++--
 include/asm-generic/pgtable-nopmd.h | 8 ++++++--
 include/asm-generic/pgtable-nopud.h | 8 ++++++--
 3 files changed, 18 insertions(+), 6 deletions(-)

diff --git a/include/asm-generic/pgtable-nop4d.h b/include/asm-generic/pgtable-nop4d.h
index 9e9e4557761d..05c3acc0884b 100644
--- a/include/asm-generic/pgtable-nop4d.h
+++ b/include/asm-generic/pgtable-nop4d.h
@@ -70,8 +70,12 @@ static __always_inline p4d_t *__p4d_offset_lockless(pgd_t *pgdp, pgd_t pgd,
 #define p4d_val(x)				(pgd_val((x).pgd))
 #define __p4d(x)				((p4d_t) { __pgd(x) })
 
-#define pgd_page(pgd)				(p4d_page((p4d_t){ pgd }))
-#define pgd_page_vaddr(pgd)			((unsigned long)(p4d_pgtable((p4d_t){ pgd })))
+#define pgd_page(pgd)				({ BUILD_BUG(); (struct page *)NULL; })
+#define pgd_page_vaddr(pgd)						\
+({ 									\
+	pgd_check_dummy(pgd);						\
+	(unsigned long)p4d_pgtable((p4d_t) { pgd });			\
+})
 
 /*
  * allocating and freeing a p4d is trivial: the 1-entry p4d is
diff --git a/include/asm-generic/pgtable-nopmd.h b/include/asm-generic/pgtable-nopmd.h
index f92ddcea444f..aa4902f63c0e 100644
--- a/include/asm-generic/pgtable-nopmd.h
+++ b/include/asm-generic/pgtable-nopmd.h
@@ -80,8 +80,12 @@ static __always_inline pmd_t *__pmd_offset_lockless(pud_t *pudp, pud_t pud,
 #define pmd_val(x)				(pud_val((x).pud))
 #define __pmd(x)				((pmd_t) { __pud(x) } )
 
-#define pud_page(pud)				(pmd_page((pmd_t){ pud }))
-#define pud_pgtable(pud)			((pmd_t *)(pmd_page_vaddr((pmd_t){ pud })))
+#define pud_page(pud)				({ BUILD_BUG(); (struct page *)NULL; })
+#define pud_pgtable(pud)						\
+({									\
+	pud_check_dummy(pud);						\
+	((pmd_t *)(pmd_page_vaddr((pmd_t) { pud })));			\
+})
 
 /*
  * allocating and freeing a pmd is trivial: the 1-entry pmd is
diff --git a/include/asm-generic/pgtable-nopud.h b/include/asm-generic/pgtable-nopud.h
index 7475d0bd0f2e..3264673c0c38 100644
--- a/include/asm-generic/pgtable-nopud.h
+++ b/include/asm-generic/pgtable-nopud.h
@@ -77,8 +77,12 @@ static __always_inline pud_t *__pud_offset_lockless(p4d_t *p4dp, p4d_t p4d,
 #define pud_val(x)				(p4d_val((x).p4d))
 #define __pud(x)				((pud_t) { __p4d(x) })
 
-#define p4d_page(p4d)				(pud_page((pud_t){ p4d }))
-#define p4d_pgtable(p4d)			((pud_t *)(pud_pgtable((pud_t){ p4d })))
+#define p4d_page(p4d)				({ BUILD_BUG(); (struct page *)NULL; })
+#define p4d_pgtable(p4d)						\
+({									\
+	p4d_check_dummy(p4d);						\
+	((pud_t *)(pud_pgtable((pud_t) { p4d })));			\
+})
 
 /*
  * allocating and freeing a pud is trivial: the 1-entry pud is

-- 
2.43.0


