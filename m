Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A8E28C982E1
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 10:57:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CF1A56B00C3; Mon, 21 Sep 2026 06:57:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CA2206B00C9; Mon, 21 Sep 2026 06:57:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B927E6B00F1; Mon, 21 Sep 2026 06:57:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 979786B00C3
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 06:57:39 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 2AD331C0261
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 10:57:39 +0000 (UTC)
X-FDA: 85237468638.28.2D88817
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf04.hostedemail.com (Postfix) with ESMTP id 6C62640006
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 10:57:37 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=r3qQ0wEn;
	spf=pass (imf04.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789988257;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Kqu7jR4LZ6KFKtyM96Yqa71AZjrybXBKCvKDll9J4VY=;
	b=Cb4WvXN5yHYVtvxqUaVc1Io3WqtvleaHuhAmAHpMu08wpZyaTdMB7oJgO+S1mSggCr2rTY
	1aVmZrXfZUXhL1MYbIJA2t4BzZn/GiPU2tGdQHV2KwTBhLULqzrGomR9KggmiQ8rHCSY7j
	qWoQPDgkeRiMoPBbw8utXtjE5kAPbfY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789988257;
	b=nIU6muWCeixEczFf1CBCGyXDNrzxBp0jzEKrzp6lSxadxvfooxpwVLuucKOX8BdOG+lUrZ
	X2ZywUzWPvZqfzWqWdV1boRT8LHp9aKLIqoi2f4L6Y9jM/iUkv26vjmITLeGqUinD1YPy4
	rjf2fvSgnv1FrvLpW8Dd2EUBN5yR85M=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=r3qQ0wEn;
	spf=pass (imf04.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 293551570;
	Mon, 21 Sep 2026 03:57:33 -0700 (PDT)
Received: from e129823.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 6DC153F86C;
	Mon, 21 Sep 2026 03:57:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1789988256; bh=tenWdx/UAPDDmgqvhn1jTW0rtV2ElcnA6e+1jtwaJs8=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=r3qQ0wEnceoNCSAemMvOXk/eg6xJzFlkI2IyMBaatbiz4/x7s7q8hXTaO0Vl8MDQ4
	 rS0/4H24aYxcUvmqdedXNG5j5+laQn70ovdDLv2Urbd3WHUzthrh0Kec8w0w+ul6hy
	 3zGTSf1mygcnWXtKW69QPNHlW0tU/7g+HwsoV8R8=
From: Yeoreum Yun <yeoreum.yun@arm.com>
Date: Mon, 21 Sep 2026 11:55:31 +0100
Subject: [PATCH 09/21] loongarch: kvm: remove stack copy address of pXd in
 pXd_offset()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260921-dummy_ptxp3-v1-9-cd40cf68242e@arm.com>
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
 linux-openrisc@vger.kernel.org, Yeoreum Yun <yeoreum.yun@arm.com>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2052; i=yeoreum.yun@arm.com;
 h=from:subject:message-id; bh=tenWdx/UAPDDmgqvhn1jTW0rtV2ElcnA6e+1jtwaJs8=;
 b=owEB7QES/pANAwAKAW3Vw9FaxTEzAcsmYgBqsQ1PJaEMk0o9SRiHZSjHIfm+GrA188fN+4hRU
 6wJUgjEtAaJAbMEAAEKAB0WIQQtg+CS3QUzuFh1pJ1t1cPRWsUxMwUCarENTwAKCRBt1cPRWsUx
 M8LxC/9j9lKenvxhbWb1SDdCXY3s7kZnCDH1casxpL2CIqsMn1jRkSXlvvWc0FK7/ooO4WCtNPY
 isddhbQdba3tQ14ARwFYleVeWNNmiT05JGvjASoPg50ySoGJaDe19OE4hZWOghnmxjkdc86g7jL
 gcCOPOwe9mQY4LNYG8oZF9///bcv3szPoREYgWxSzP1vxiY0prT9Dyfrv3zTgfStuBUY4ntnptW
 G6zFnDbNPzkifb/jVOuDI1ksUJyOcnJzCCWQh8wAul/S21IO6AC6udNQZCpR4UHngkTh0e7kUgq
 arNAcFyIjLTCw2utF3PQlxLJylHPboWGN6Qby0dJF/WPvfwiMZ5ZqM7rzEP8W0iKnUglDk7bkpP
 V87UdgAwIoTi1oSvrjliTDJV5yEBgdqYWHvSXN54WMH8yzs8AO3xWzAryfmg1jwsGVfcCNvBtRA
 5hUpniFYmqdNtZll1Rh6ljx/ikMnaZyFYSHYscH16HGIFR1qU5Wck0IPfXF0jYchNE1jQ=
X-Developer-Key: i=yeoreum.yun@arm.com; a=openpgp;
 fpr=2D83E092DD0533B85875A49D6DD5C3D15AC53133
X-Stat-Signature: ei1winoa193x8muyc4t1ykicca5yfchx
X-Rspam-User: 
X-Rspamd-Queue-Id: 6C62640006
X-Rspamd-Server: rspam03
X-HE-Tag: 1789988257-469439
X-HE-Meta: U2FsdGVkX1/uJUKYVd6seb0PEIpDoAX4eVR4we/g5vtLU/0GqCAknGZz22CJj8bm8UUKXVhfXiCd/WJxei0zVRRiLsJ2IwQYxo2BAB18KQh/NdLFTueiqsgvCm4xIo+1M7Bi+i4JFzSOtK679GPwqxOi5Ex4zMDnnWdLTbRpqS2wEYxwoZfFcQYxzkGyO7DgidViYNnA7lFDkeaiDLt12wWD2XeGTSR+IJkBgnusae/9WFS+qzuybWX756NQnG/hUfJl+pZ+8gpi2iR35jH5j5OHr+CmAKfd5YlIBBQNFXIsjtzo3jwl0xPyMmXHcs6q9V//AwpQ1wdQ21CIwcA9yCxsALrZs0Z0F+oxiu9Z3QLiO0hK8m+L3G9OHmRzCTkxSa+IegFhX5w3gLicbALofQPGgctjrKvUmXMMx7nElKCQ/yJngCb1NboAWJ0debs07+7j7+OCSWQD/L2klfr4/TJM1mEvbti/TM+RYLG/9PnoEokrmKDDZFrwnBAi7ZPzwTs4/5qcuhkMyVqbZMNpvjkqx6xdTZi2QsrBzSDQddQotRk1ruE5Y9sTdjn7hnasyW7/tzQkdAWGOeQFc8+ap4IVHnD0+YPQYsMJ+K9OYFroEPxtMaP95XfOxbLCZo5+Lbkv1IqZa1Ssx/bMytmDgiWgso5yh4+6F1A3AMWfff9fOaynprIJTzgkhBy6z+Y5pBUwIy9N1XftjNCdN4XPCJg2ICL4AeN8lSQ0k8V++RWtidtLlOYfMiKw7gu4Gr+hnVfWBGtjfZIRZUIC9r747IYbKyBNk36GVBkB8Rhm5cclXtXQ9Nmn2IGI6KP7xdYzR0tDcP3yfQ4PFZmTOkTF1vyBMhmbipZdX+BVCV6N48mHys043XoPBDacY0E8nm8hR5Zf6jq+V6ADJG3PIDNaPkiMwMbgsUc5qisv1H3J7asFEK1r/b7rbihEz4/AyWl18YSk6Oytni8+ovsre5D
 PeoYxMYs
 rrT7iatELz0IkJWDhLqtaTTABfbmnXcf7Y1T3olO7NXEvcJK+BBivOLez2S7IkrV9T1kyulw5xd6lZIetazPapjgHpQkHf6qfrDTLzWJnTqc2IUqOJFMESTFFzELaexuWy0aMnMtxfiqHknPMzWvFx0P7hQaHAPxUiCAE4p5IYMmTYiy8DONdnchsBP7nRsjP89hxuEzncdmrULXVr43RdwJC5JRRJjAnGLMg8VhzNrZusAIInVWVcBEJ7DqcGTodeTigF829VLZop3WCX12Nd7JylVxYRXn3tZDxNwKQhCJtrKNaYhB7g97qUClch9sdhtfbay6gg9lMN+Y=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The behaviour of pXdp_get() will change with generic compile-time folded
page tables. To prepare for that,  rework host_pfn_mapping_level() to avoid
use of a stack copy of a pXd and pass it as argument to pXd_offset() so that
the folded entries value is ignored.

Replace direct uses of stack-based pXd values with pXd_offset_lockless().
And there should be no functional change.

Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
---
 arch/loongarch/kvm/mmu.c | 20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

diff --git a/arch/loongarch/kvm/mmu.c b/arch/loongarch/kvm/mmu.c
index e104897aa5328..837b40bb694f4 100644
--- a/arch/loongarch/kvm/mmu.c
+++ b/arch/loongarch/kvm/mmu.c
@@ -669,10 +669,10 @@ static int host_pfn_mapping_level(struct kvm *kvm, gfn_t gfn,
 	int level = 0;
 	unsigned long hva;
 	unsigned long flags;
-	pgd_t pgd;
-	p4d_t p4d;
-	pud_t pud;
-	pmd_t pmd;
+	pgd_t *pgdp, pgd;
+	p4d_t *p4dp, p4d;
+	pud_t *pudp, pud;
+	pmd_t *pmdp, pmd;
 
 	/*
 	 * Note, using the already-retrieved memslot and __gfn_to_hva_memslot()
@@ -698,19 +698,23 @@ static int host_pfn_mapping_level(struct kvm *kvm, gfn_t gfn,
 	 * value) and then p*d_offset() walks into the target huge page instead
 	 * of the old page table (sees the new value).
 	 */
-	pgd = pgdp_get(pgd_offset(kvm->mm, hva));
+	pgdp = pgd_offset(kvm->mm, hva);
+	pgd = pgdp_get(pgdp);
 	if (pgd_none(pgd))
 		goto out;
 
-	p4d = p4dp_get(p4d_offset(&pgd, hva));
+	p4dp = p4d_offset_lockless(pgdp, pgd, hva);
+	p4d = p4dp_get(p4dp);
 	if (p4d_none(p4d) || !p4d_present(p4d))
 		goto out;
 
-	pud = pudp_get(pud_offset(&p4d, hva));
+	pudp = pud_offset_lockless(p4dp, p4d, hva);
+	pud = pudp_get(pudp);
 	if (pud_none(pud) || !pud_present(pud))
 		goto out;
 
-	pmd = pmdp_get(pmd_offset(&pud, hva));
+	pmdp = pmd_offset_lockless(pudp, pud, hva);
+	pmd = pmdp_get(pmdp);
 	if (pmd_none(pmd) || !pmd_present(pmd))
 		goto out;
 

-- 
2.43.0


