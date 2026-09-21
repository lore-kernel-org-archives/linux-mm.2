Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9D16EC982E1
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 10:57:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A80416B0095; Mon, 21 Sep 2026 06:57:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A310C6B00B5; Mon, 21 Sep 2026 06:57:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9464A6B00F2; Mon, 21 Sep 2026 06:57:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6E4D46B0095
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 06:57:47 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C7165A35E8
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 10:57:46 +0000 (UTC)
X-FDA: 85237468932.18.1A20758
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf19.hostedemail.com (Postfix) with ESMTP id 028D01A0002
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 10:57:44 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=acOOrhxG;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf19.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=acOOrhxG;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf19.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789988265;
	b=MNKTbtcOUOm6shwYww8sEjLnGbH8s3LopvkOVp3PeyY58NRfnIKL/cO/GUc6gk/mNbM5/a
	z0h2vu32dkI18xpRZAQr17C93cJ+GHxfT7s2zykPX2MwB/kdJb5+JDiVJ5SgmWyUV0mf+u
	aAe1lgxMHuE8Rdni7sGovyaIHJjEU64=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789988265;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=82BJI6A8XCw5pgeMRqqkm4wPSCmFiUv1o26AYX6KC4M=;
	b=XUDDY7liUdp72i+WSWhehb/kUI7Jx+m4utsTIEJhXT2J/taeuEkL5ArFPkQiR+4wqOPR1N
	1+e7ZQp3Slo33TPAOyENxIDBmQccKykiT3Qrio1dkZ89a3Ru2siFtC6o6/Tb9czB7QPmWL
	uvFJIibhWI5YxrqHeRSENzrJT7rZwhI=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id BBDEA1D13;
	Mon, 21 Sep 2026 03:57:40 -0700 (PDT)
Received: from e129823.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 091B03F86C;
	Mon, 21 Sep 2026 03:57:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1789988264; bh=KiXQHGuhfMlh69+vDPC8O/k2WRfNJbgSm7Gu8QYG2aY=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=acOOrhxGt24gm0TRAbQDXTQ9bBBp3Bj56XEBgnVOotqP+qiG7YJVhkcGW+xrwcb2a
	 USmOAWcGi1YbzXXz+GFEN3it02D0/yYErePOTiGnto1f4lTnlkzD119S+FRZwhYPnm
	 tRzn3ffsctlJfSwSOqlNejAXL1s2WdK0ogZ6I3bk=
From: Yeoreum Yun <yeoreum.yun@arm.com>
Date: Mon, 21 Sep 2026 11:55:32 +0100
Subject: [PATCH 10/21] riscv: kvm: remove stack copy address of pXd in
 pXd_offset()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260921-dummy_ptxp3-v1-10-cd40cf68242e@arm.com>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2080; i=yeoreum.yun@arm.com;
 h=from:subject:message-id; bh=KiXQHGuhfMlh69+vDPC8O/k2WRfNJbgSm7Gu8QYG2aY=;
 b=owEB7QES/pANAwAKAW3Vw9FaxTEzAcsmYgBqsQ1P/lW6m6B1mTpRP6bpmebttNlScQQ9pFLGp
 +TLi5+fe6mJAbMEAAEKAB0WIQQtg+CS3QUzuFh1pJ1t1cPRWsUxMwUCarENTwAKCRBt1cPRWsUx
 MzRxDACbWH4JATwoeni8FvpOIlAtj13UB3cW+c35hpt9oGzmcDZ+kjukMqctT6h2L2N5pHpsDgV
 vmayApcPPlarU6k8ZQpvBb7KJ1cYGUNPU474TxmX2vBVITXF3mbHMgRoEbIqhbltrGT8uBoVyCo
 KgDVi+KDgkbOrzeKUfL6m7D9VLVgLaNDamzt7DvVVqiCTUJRUSmv5DxuOqilRyUUWgRg66cEh0f
 fNgaSTYxDBBBOqd6xi9vA+7R/D8gaYslxHah31gen9zR/KRiSCVO8oSWE7qao685EtRbhlF8C/w
 3me3Bkz4+kVb6rnCMuV0mt4yG2kuNCmzvgORQC8TBdutWp1pmcamhxcvxqCjL3WpVuFoo+iztFK
 qrF8TVoPbY7wwUVBdeD8kZ/Lg3FUZf4niWpEI3+/yEQZqeiImeTuLoEd2uelVxIt79PiLiF5ED/
 4IEDN1fi5/NH35mcjNFuUFg9VZ1c9qX2muen0gS+XMIvV6EzYFJk5Fv4kXIUQGEyvngIk=
X-Developer-Key: i=yeoreum.yun@arm.com; a=openpgp;
 fpr=2D83E092DD0533B85875A49D6DD5C3D15AC53133
X-Rspam-User: 
X-Rspamd-Queue-Id: 028D01A0002
X-Stat-Signature: p9wp8i7cjwopiapnnj8inwzg9piuu5ez
X-Rspamd-Server: rspam01
X-HE-Tag: 1789988264-166732
X-HE-Meta: U2FsdGVkX1/SCW+N2x/5dY/Pz1DpKH7c5LnqcAu1rL8AZ/CMznKJSl7u6FpThT6XD7HvyTtDDQcMWfaDlW0PezxG79gCysHusaHUyCZh5Ffa5If5HJzk1nLPXjWRJqEcqBKzl1zKrl1XX8OFGGa0/3wVa9lhjPQj0V/xJexECzLvbyNgjswR1I88kXpNKlHbhMoKmarnSb9/USP151eRy8WbRkTxiUePOodn4uysfSxDLr5k2sHNYmewRaT4QzdE2aSyikeBLwCUiipwDc8s99lvdVDBCrxtx+jhVsqN4ChM44S+zGAgpUDLxW6r288AEi+s9/W4JgBVIh6qOX/dXpZKlXGzfh6ytmupjIhfAjDt4qPuC/YVbQWWboZV5KY5jRpoRM1ARdUvWxKRwzYw1Mo6KCemfBP55b5JQsekBLUmVqu6jgqA0HBO5oKyiNbcqD8qrSS4Lx9G2FehSMYxlF0EiUIlC2mpuQRwAxADV7nlfUc1LDp657lOw/8egZNHSB7gBHg1EDhCYorrzmcFMh7xMhVYg5exCssBHMs9PNiUlT8RWp8T/4QXde88eFb6ScEosXvAssvX6O3fBGiyEJU223zgEEWg/hz2EPjeCzvfMS2BS0XXHyVNm3AfFBGNZfIiXkCUueiRCe27uWHS4FH7/Y7SViaHcC5iakNoMBj/3G/9lqB4AKVEh9HiaFHOELtRHtdywXn7/xtMqopfP15hewiFE84RjNQ7a0XOqLAalOI+lzyr2/JR1+ZqsT+0XDrX5eMMsT09BPpa1rslluRyZswpc2Uedc6g4qUf+HrKiuglBJHSApa6luN0+WAcGos++nMcwGKQL4jBRI/G8hr9rmUWFj4+5iwHGW9AXZSCv51AFOFuCJzhWkyB6zrE9cpeyF7Z1QnMFb+GxKeh5/C8Ur0HDdtn8WTFHqXqIGvj7ER8npajl7Jcz0CNCHa6i1QMglWOnsRwisoTpZz
 unBxnNLR
 zQrVB0huuAjHrstPf6vrIYPOvQoHhaHmb2OtEDqsNpU6StzIFhiiHrOyfHu5CqJLaCeMhwErWQzP5WvxebiMzbEu0+aY1p2HvIOmRyF/cCxeTnk2DPj7DumWjMUV84HVdcoLehlPV4iw0mNbjQ4ILt4/JQrmE4Ht+nt7rzBSYu0GMb+wc4b29LuZkOggqCbbrmdqds9BFq/nBZ+x5q5Fuw1gLrYoxgDhlaYn/8CNIUOj9BUShktcV6JYasMKfDBByEUvKzn7KRkh/cJ9337lBAwnAF9AG9hr0JGxk06jyX93MxVjnQWau20Fb80fpGdufnLXvQsJgbrdTKOM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The behaviour of pXdp_get() will change with generic compile-time folded
page tables. To prepare for that, rework get_hva_mapping_size() to avoid
use of a stack copy of a pXd and pass it as argument to pXd_offset() so that
the folded entries value is ignored.

Replace direct uses of stack-based pXd values with pXd_offset_lockless()
and there should be no functional change.

Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
---
 arch/riscv/kvm/mmu.c | 20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

diff --git a/arch/riscv/kvm/mmu.c b/arch/riscv/kvm/mmu.c
index 5c5c77f98bf0f..b97224e14fc16 100644
--- a/arch/riscv/kvm/mmu.c
+++ b/arch/riscv/kvm/mmu.c
@@ -450,10 +450,10 @@ static int get_hva_mapping_size(struct kvm *kvm,
 {
 	int size = PAGE_SIZE;
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
 	 * Disable IRQs to prevent concurrent tear down of host page tables,
@@ -469,15 +469,18 @@ static int get_hva_mapping_size(struct kvm *kvm,
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
 
@@ -486,7 +489,8 @@ static int get_hva_mapping_size(struct kvm *kvm,
 		goto out;
 	}
 
-	pmd = pmdp_get(pmd_offset(&pud, hva));
+	pmdp = pmd_offset_lockless(pudp, pud, hva);
+	pmd = pmdp_get(pmdp);
 	if (pmd_none(pmd) || !pmd_present(pmd))
 		goto out;
 

-- 
2.43.0


