Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C2B76C624D0
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 11:57:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 82E5D6B00AB; Wed,  2 Sep 2026 07:57:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 806416B00AD; Wed,  2 Sep 2026 07:57:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 71D1D6B00AF; Wed,  2 Sep 2026 07:57:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4225C6B00AB
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 07:57:54 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B629AC01B7
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 11:57:53 +0000 (UTC)
X-FDA: 85168673226.15.C90E8C3
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf05.hostedemail.com (Postfix) with ESMTP id E4BEC100006
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 11:57:51 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=KwVckYUF;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf05.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788350272;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=T4ZC5NFVeQY99+PVp2UJl7URx3a4Ea9PI7M+v45bZsw=;
	b=jOqC+BvFkShjqRsJDUk5EYIqA1tTBXuBKAVDwR0TCCAGkxlEmJ49WUED609YUF3yMIs1fr
	ar1JbmjFYR9u1IaUg0dUKZMXBmIwF+Uo52PBx5nJFXj9hHtgdbg+QIBGZbmm3xfIH4mA7Q
	awcNHjb9poSvacJDnanyDDuKj1V9Z0s=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=KwVckYUF;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf05.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788350272;
	b=AgdonvdE10/tRPGwfqbYCJr2bui5xaEKm7qslRDk84abS+hKoL2KDRMxQ0NBG1FyqTZntp
	Slmor+shruJUInT5W4a/Jcv4ncb8BtOARJJrAjx6NUT+mhVrKX4WnedMZGpxf58OTpqqfT
	y55ekCUSHW1v87Hetp0mQ0tXp8w+Cww=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 569A31E32;
	Wed,  2 Sep 2026 04:57:47 -0700 (PDT)
Received: from e129823.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D20183F85F;
	Wed,  2 Sep 2026 04:57:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1788350271; bh=u1Z77HcuVhsn6YhXUmkFsPEbxxF45OV6fwB+pGKvXaw=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=KwVckYUFD0lh0ySdrjYJ96Swie3hj5sqm3vMY81r3S03FnG0fxHPzd0qowq8aZG5g
	 IKesnnrhaDKSBya7uksmJfX5kn32Lpqri7nZkx6IJdyAEy0gh9YyZGvb8St62p+VF+
	 jHU2x45mp/UblfZisQApAggIrhQmd+H9mASJWRUg=
From: Yeoreum Yun <yeoreum.yun@arm.com>
Date: Wed, 02 Sep 2026 12:56:12 +0100
Subject: [PATCH RFC v3 10/21] riscv: kvm: remove stack copy address of pXd
 in pXd_offset()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260902-dummy_ptxp3-v3-10-5d8f5b17c25c@arm.com>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2078; i=yeoreum.yun@arm.com;
 h=from:subject:message-id; bh=u1Z77HcuVhsn6YhXUmkFsPEbxxF45OV6fwB+pGKvXaw=;
 b=owEB7QES/pANAwAKAW3Vw9FaxTEzAcsmYgBqmA7mT8hWwbLEAfZ37PxMdkX2SXibeCCh04uq4
 LVfmdutif2JAbMEAAEKAB0WIQQtg+CS3QUzuFh1pJ1t1cPRWsUxMwUCapgO5gAKCRBt1cPRWsUx
 M+PqC/40X13zsXs8BTi8kV5papAGh8OSIhs97QZRguA2644nXsxQL0KWVabFVdCiD01eIXjwiwK
 xc28n/yQ0VytaKVRoLdH2uaCikWav9oZ9XDLjMzQLSF1EWLel4YSmV+pQdtzVzQsSoi9YTysn3x
 JkUT86wqAghgrmHxTDoQ6TjpqsBNziVpG+FIHDJt0oyS1A5b6+50SiwZpCxoJktIFfQqctIE67X
 pOpT704P02sdCZmz5tnhqEEANwjL1IDJy5g7ax557FSOnEeb1fqbAiC5aA32WSWn00wvg29OODg
 QEENRDtdwmzRDVlc6E6KtCngcNjmmnYj3BBEb6ma3mwUfahX0QMDHlGAEFkBKP7JbWcXpjz6UMh
 O7HhjVbbW6duC29hFpC0g4D0iBai5cCFlp4WKlyC5tzjeOm6WUg2qQJObDgIEGd6t/v+1NGFPg+
 7gtTrSnpWjJSAYpwvyDrtlfK3hO9M/URw/sMGNUnH2v1a6efUQCi9kCBVlEsxT7nPtlCo=
X-Developer-Key: i=yeoreum.yun@arm.com; a=openpgp;
 fpr=2D83E092DD0533B85875A49D6DD5C3D15AC53133
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: E4BEC100006
X-Stat-Signature: t6ibaoboeyrjnh4964gm3dui1xqyqogz
X-Rspam-User: 
X-HE-Tag: 1788350271-252472
X-HE-Meta: U2FsdGVkX18ztu0S4DHJsXZ07Tax8gC6oMdFgale5G+xJunjczQky1ohK5HV+G8+uf2KAaXgRRdBRBzUOuBgBp2ozL8kMwm7U+UGvM82l+KFBbGfx0OZL0QkBkKm6hOLri3UrUVx1f0f2zJkmCkgnYrcqH6UHel2WgKLek5+MwGIa/BpbGj51GeEaV80ZXa5pDT98C2wBnPV+W31yuxXWxpUJ5/NutzJFS6a1EYzhdndTesIUGg3acjijnQTgj0N6FrChKktzdCA3R7MQXxiDWqgXv6ABpVOjmhL/ZRcH2b87gAfowFbV4cFBb4iiKiGVrlg/HvJl/WkGn4fhoStFRf3aBr8pt+ETm/GkGJ0qumfWb2DKd6ZI/RGxdlDeiImP2LYls1wRYCaMSV2e0tLhvtnHrt5dbLOFjXckRhnEtwVTI8wSC9tWcKGuOPJlvooeWCFbO6Qk6srQaWrfKTsnnuQZ81pM/yG+R8mDYPjsH+Hx3s3G5oxNtmg/nyXWn7YQ6vmj2g5tQmyNZFiafHvmlviclFZRzuXTrP+UHjqN8qK6QPvNLBKnk2VJXxfklFALOIzd+LVnp4PYKRBL7rp7U7kqlno9QfraHTCowZpLtCrmgZZuIiRDD3LPVkNEFK3xV03Y4C7nXSt/gcClJ5jxxUIfobow2RO1t0jl5iZMQlP/ale6Vr/IIrQq4l3sorWuT7SqzEVW/PQNhkAfQS/j26O4wGk4wi2aZwYeZhECU6DyHF7DIXbcOOl1mh69zZFemGgpHtuJkIcTtr7yEMBgd9Nh7AxOVio4oRcpgitVPdfOlajEuMSlUQ63bUIoAKoVEEI4Jyt6yRUgQkovMV+VCg71YcHk+uiRGfgjvb7JtLcRRYdWZ3ZxkTxYbJQucQx6zMKnfN8OfrHmDaL5LByyTLppB/5VW6Lo2tH25oOhCpi+7YscMQ9TLTr78spNNAgCXRE71K3wwvs1aUsui2
 6R8bJet1
 SCZz4kWET2gk+k2NAoQQllsq2ujb6M10kJ+vlK/w7+4JONK46YiZifoUxz8owfXx3PqRxuCHxbPxJhIvSWdNe/sf+U9BcbO6M/GtoNHrPT1yQnAInbiWNTafuNLDF9/LywuRz2hhUKOJj5VvQSq0LU+EYIODSV1cMZ3zr/PjOXWLdz9vi6/G7bIJuqc1ObJ5BkjNpRr3+GdGo7/5kQBRVIVw6LkEWGwWa1tDHNbsI6+suQCgtt7+U5DsPALNvWZpTw1WBIyt5wklEutYaXe1J+BlIXx4EWfTDQGURZ9Y4QfuigvmOHV8wXLSHZ33tyE3FbLuJ8GDjA01tGhM=
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
index 6035b5ec9503..dd5a7b0bd084 100644
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


