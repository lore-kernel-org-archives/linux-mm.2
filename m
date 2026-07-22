Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2D301C44536
	for <linux-mm@archiver.kernel.org>; Wed, 22 Jul 2026 15:31:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 351FF6B00CE; Wed, 22 Jul 2026 11:31:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 329AB6B00CF; Wed, 22 Jul 2026 11:31:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 217D36B00D0; Wed, 22 Jul 2026 11:31:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F2F0D6B00CE
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 11:31:54 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 9018A14020D
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 15:31:54 +0000 (UTC)
X-FDA: 85016802948.02.05E5298
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf22.hostedemail.com (Postfix) with ESMTP id 97F67C0007
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 15:31:52 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=jM1S8iz1;
	spf=pass (imf22.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784734312;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=22aw7Np2cGzGcNH8zMseikuNj2a/GNpyekBmCh7fIZU=;
	b=AUGRMhOFdJ7lcm/6KWwEu2mbIc+vy7JlVGHXu4iuXVWGgWf/g/FF4oqt7UR1+Bu63M0M9f
	B+ReQNTdlwmAMhf60VgXJIhzkB5X9H+ECjU7KSkiCSaaSGH5kZZXTMjtXeebA4CkaKF0Bq
	SXEj9sXEqFTUmUxFBdbArEUeG1x34K8=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=jM1S8iz1;
	spf=pass (imf22.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784734312;
	b=7vXROs8rOfIE7W3gMekOFD1Box6YOZhWc7y8CkGUiE3ihgTMhEVtnotezPkv1Y/YG89/9C
	hfFriy9skEQbgWD+HUSPGgouNdHkM+UNNkPlhJ1KLqS2WYk42UequuBtQbkUsxBPVcz4t+
	J7LgbMgxXER5gSIPw9/J2f7lSsbKpvU=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id BD20C168F;
	Wed, 22 Jul 2026 08:31:47 -0700 (PDT)
Received: from e129823.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 072B93F66F;
	Wed, 22 Jul 2026 08:31:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1784734311; bh=46CYi8oneBLiNJ3cpNNEyn5Md6GOQd0YanozKiYt8po=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=jM1S8iz1iTRGQItlX7bp8OqSO+oyVlfDJ/6Wqo+ecZp0Q3yjOq9RZ8usX0UOKAqdB
	 P1f36++X8N0WL6V+n6HXyLwlbTy47ZEMBHANTZ8C2zg8NPIobT6lNhpIt2el4T+mN4
	 SN2z2ausZnra+HPuPGgyYdAGZU1O+gsTpQ7G4F04=
From: Yeoreum Yun <yeoreum.yun@arm.com>
Date: Wed, 22 Jul 2026 16:30:18 +0100
Subject: [PATCH RFC v2 10/20] riscv: kvm: remove stack copy address of pXd
 in pXd_offset()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260722-dummy_ptxp3-v2-10-d9e4bad31e0a@arm.com>
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
 linux-openrisc@vger.kernel.org, Yeoreum Yun <yeoreum.yun@arm.com>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2021; i=yeoreum.yun@arm.com;
 h=from:subject:message-id; bh=46CYi8oneBLiNJ3cpNNEyn5Md6GOQd0YanozKiYt8po=;
 b=owEB7QES/pANAwAKAW3Vw9FaxTEzAcsmYgBqYOIUt6bDSgi5vKRp2azbTZnUNQ0o4jrxwlulo
 USuBIe0QHeJAbMEAAEKAB0WIQQtg+CS3QUzuFh1pJ1t1cPRWsUxMwUCamDiFAAKCRBt1cPRWsUx
 MzgLC/sFSR+PPsMxGI/0F4kx4qmYYrHefAszi306MKilHpWfr54K5HusUgi3Hq5dAjcstdBJy/x
 p1yWh1Srqlg6E2HoaitTgTj8dMzpHaPLDNaE6GE9Qnk4xCdQa6i1NQj/ZP44ObsaENtoz2Knk6R
 BOWFfE4FG1OmUrUlP5v96/nsrrgnkgOhkFYccJoF18wq7vSKczb2+tfmJT6EcRaOVAaQarYNUY3
 Bt9oAkJwM11kRKYLdAgHc29lOOYSv1Ou2BJzMZhLhJdnEkkGrCeWUiwoTr0EryFm0TIuwksIzjj
 x5Q2OiKJ0RcsLn4GBIqjHv21HGQrlNj3+qhLW2pGQSJq/Q2+IhIdof/ABN6LeigvATALLiHjnZW
 dr6e5gcgPjESIQqXASzCMKKfV3u3K50pAbwkaSmopLDcVQIIs7nkSXViLg2qoBq4dXZJUzsQNnl
 FnhiLenc7K1rXADF+6WMJqqL2IHJyIUqPFJoMJ9fk09X+WGNlXwmEnc5wq081TwA5jk5o=
X-Developer-Key: i=yeoreum.yun@arm.com; a=openpgp;
 fpr=2D83E092DD0533B85875A49D6DD5C3D15AC53133
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 97F67C0007
X-Stat-Signature: 94picuc1pbao1maxkt6eub53jhp9bpgy
X-HE-Tag: 1784734312-607567
X-HE-Meta: U2FsdGVkX197LMM3E0/lS7FkUulzSus+ACT19ckyfoqhPrzuLDgZbTbyoR8gEC48ByaLy/BkFl9ojcioKNCSOZmN3fcbBh4ArJd9SZI5PRGRfwPs8V4igu1y5Ez7xw6/c5xP9OSt7Ce2HfiWn/mwcDzj8UuCPvhW0Vf0khSmRArYqcpy3jUuHz3/DsBELFMy63ZRQIePn+erxsy2+mo+LflYpz83SyjOpqEq1Lk/Q7KUBK/265XtE7Vw8zOT6SjCLpjrlV62oyrdrN+GTuu71Y5XpKbUSUhF81x1RLuQesZjBx/6RJ/4l8ZBRHIwBOATTNTWe/gEqMM9JPgOv6gxpr7kQK0AQY5NPxab+iBoIqUnCFfU5Lz6nFurnLdKWQhBdGNirJpryhV58Qae7zDS+VhCgB6DL0vo0Vrp5KmSZxALRLCDgAwiY1/M2VHVZianeOQO+LaBjStdHjhpRelAbd+WtfKfrsKGIu0MVQgBFjTAP7p1NLXj4F+5WTh+VeLCowEaM8pbDQPvxthBrXFxIJ7Ap0tO8ixSZrmZkFpbxSkeocaPGGbeDYCg9DKFPAgvUrOKGUkMyPGwuz3vWyckDqfnsVz3Y7PdurQdp9FHcl1UcvP3UXUzbdNS7HVeZf4tHgTsnoIpmcgHOYXmJy2B2gxvhdKv5VvvIwQH4X1dDfA7SkN5/QsCd4DDoVvQ3hAnBD3dPAsjS7C8DTGLNdoW07paNTKxO/DREqkYhRgPloZGew/tGcc/4Dq10aJpoFPF7ndRZZs22ioWcso4KauRN4BjZ3Vt7Z8XB5DQjQHyONXDb2M5Ivl1TNcLcp9KmKJJu4Dq1FMajYT0P3/l0EYu7tIOrHC8q8f1w2UOq5cNYvlpgQ+DlSugoBUJrHQ797v9lDvlaZ4yohz456ZodkYd0lSnY56mXGBGTry8vew0z1BBmNLXBqlXWISzjBs0QyhhnQ6826UXmf3g8SC4jY1
 mhIPIjHY
 lqnbrJD5mzDj+wLBq9y06o+QWonFwGWDH7ron0Pv1LGCLQmu0yPeroiaILxOJtYFAipicT8vXk2gV8wVQUuhCjJ7aQAMHqZp1rWqjFcTyUCOxGzNo8jJANsioOQ5ocIfz3lYjYaTDOct3rnma0Ey+mZjBBa3itrX3z80XuZUbXVmoLhidytfx/OYfk2VSHp7tz2ngQWGsXmddUenyvisvXctlhpEA39cuLJLaB791N/YHuKWx2A8xNzG0xXKgQS132l4hNtgHnMKt/TA9chtCzNZyNZUiMC+PN7+0hpSeYh87LZM=
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

Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
---
 arch/riscv/kvm/mmu.c | 20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

diff --git a/arch/riscv/kvm/mmu.c b/arch/riscv/kvm/mmu.c
index 082f9b261733..6d6042b81d79 100644
--- a/arch/riscv/kvm/mmu.c
+++ b/arch/riscv/kvm/mmu.c
@@ -362,10 +362,10 @@ static int get_hva_mapping_size(struct kvm *kvm,
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
@@ -381,15 +381,18 @@ static int get_hva_mapping_size(struct kvm *kvm,
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
 
@@ -398,7 +401,8 @@ static int get_hva_mapping_size(struct kvm *kvm,
 		goto out;
 	}
 
-	pmd = pmdp_get(pmd_offset(&pud, hva));
+	pmdp = pmd_offset_lockless(pudp, pud, hva);
+	pmd = pmdp_get(pmdp);
 	if (pmd_none(pmd) || !pmd_present(pmd))
 		goto out;
 

-- 
2.43.0


