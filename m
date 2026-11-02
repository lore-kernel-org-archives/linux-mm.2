Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 50F7860A261F
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 11:22:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=NGzAi2YU
Received: by kanga.kvack.org (Postfix)
	id 7E3926B05C1; Mon,  2 Nov 2026 06:22:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7941C6B05C2; Mon,  2 Nov 2026 06:22:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 635146B05C3; Mon,  2 Nov 2026 06:22:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3EC0A6B05C1
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 06:22:36 -0500 (EST)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id CC06B40C6A
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 11:22:35 +0000 (UTC)
X-FDA: 85389941070.04.4BAC092
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf16.hostedemail.com (Postfix) with ESMTP id F2486180009
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 11:22:33 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=NGzAi2YU;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf16.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793618554;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HLNvHrR0Fpj6ftr47GYXDwUrEMv6CUTbezLhLSAnnFs=;
	b=1jwfZMDTXQIo9fLoJAtZizf/F+xozFtNBToqFqfx5Qcs4w8D2R3/I1loGn/lnmeHnYDgqb
	4j9/2KGjmLBZGtGtQPSLgtkQ4Muo/ZFXOvCy1SD74Lcfn1EGnZkLRUu0JQZIqbh2J7sjAK
	jf41X/zFq/trGMrCVE+MatvQBAIGUSA=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=NGzAi2YU;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf16.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793618554;
	b=vta5W2bpIGYfQIoLbLmgMGK73DmjdMj6u0xhbjAW9Gu3BPclJAFv/TktpZgEOnpl5HBXXV
	iEgC97UADKoSskPoTbjwx0hk8MHOfSrNMpWxnWhd2HDkxoJbFpJgHvwTv5zAYjTuxKKCIY
	6aa+RwOon0mrxojfTllThKrlt9QnJi8=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 092802A68;
	Mon,  2 Nov 2026 03:22:30 -0800 (PST)
Received: from e129823.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 00DBA3F632;
	Mon,  2 Nov 2026 03:22:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1793618553; bh=QYmfwdLe215hLGuFdCj5safJ8gxdq3zlW1ht1LiurFo=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=NGzAi2YUuhqkVXhnAdJL2xqwg1sWWuNnmUOJc6WYMvcZsOaHYodWzzAQDylogAHGF
	 sAlnvTGEoaWaY/k2K8WvP84MmxrLyH3UL6M62DxDMZKwAFnAf1wnmUlSt9sVt9I0mu
	 Q2N9zAaDmNiAxl2O123nlIpmLVp78QCa6wl12pEo=
From: Yeoreum Yun <yeoreum.yun@arm.com>
Date: Mon, 02 Nov 2026 11:21:22 +0000
Subject: [PATCH RESEND v2 09/21] loongarch: kvm: remove stack copy address
 of pXd in pXd_offset()
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261102-dummy_ptxp3-v2-9-78840b2ec73c@arm.com>
References: <20261102-dummy_ptxp3-v2-0-78840b2ec73c@arm.com>
In-Reply-To: <20261102-dummy_ptxp3-v2-0-78840b2ec73c@arm.com>
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
 h=from:subject:message-id; bh=QYmfwdLe215hLGuFdCj5safJ8gxdq3zlW1ht1LiurFo=;
 b=owEB7QES/pANAwAKAW3Vw9FaxTEzAcsmYgBq6HIzqxNaFzhvjoxpWT/tFvwVycvQLXxje++RP
 KuCMEyxm3SJAbMEAAEKAB0WIQQtg+CS3QUzuFh1pJ1t1cPRWsUxMwUCauhyMwAKCRBt1cPRWsUx
 MwUIDACW8rDfN4PXoaycRrecOSJ5P2sV/Skn8cOJ9F/ArQxVMCOkJHu/jozzrN/5ZWRoyfVV6qI
 hDxzX47bfW4GqsHO5E1uaj6xJ9OnTVdhFE4l/Z+UE2LIN2XI1Bin4FtP4AUH6tjSrIcQmyrNuOY
 XpIxrn+T3hDCqyoo51zdCIbgMvWpEbTre5IJV1a6Mqp1c9cAMKvBQOnCovyb5XsRcbIXCK8GBUL
 2aP3pPNFUvXRH3QTlxhUPhWul1wCFo4bQXDbwm3jT1xU3N3aXNrX3vH+jBPPeM7le+WT+nLhcpw
 JPwBBCr35AoUF9s0nSKAF8CEAIqpWUI4RFhNipztYZBEkGzzdx93KCdMunXOhPaOscVKbSwRRW1
 mKOv00ylFBZKNhssbxn6+dLKmk1it/0MZ4POP9C9XuNAa2KUbJdt9fNpzJ29FeV5L8d5guM5A+f
 InDzrZ916vWbbdE91pO/GFYPPVhW3wBYZ+/6ONFGYaYRLD9E0AY3bJ6iH3q3dxINcdz1c=
X-Developer-Key: i=yeoreum.yun@arm.com; a=openpgp;
 fpr=2D83E092DD0533B85875A49D6DD5C3D15AC53133
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: F2486180009
X-Stat-Signature: b6sdw3hmu77ofeo4xz6cgw1q5ni5bcct
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793618553-195557
X-HE-Meta: U2FsdGVkX1+xZY1VgpEzdxQVx4+DaZsiSIjIQZHzdmMMAAkCfD2UUvLUanNo5s+Yond7jSxF6TAHmgsG3C3/WDdiuZitz8ZsVQuMbG71k9tC0CCNfZAo1yZANfO9wStpddGur9q++VpeqKrkSaBgLeuwRg2ZY0PgJaVAJaJOyIdZPn4pU0Wl1lL7w3dEmOC8KmMB5npalJ5fGyyuATJV9dpy2/0ZXLIKeRHyZEnUxPe/39iT43l9KVsblhFTlb8kvVDI89TuW6R5Wi/Piz2P3yWLFg31VQXzeLG7H2zgj/1N5fHjxHHGVKiDUvTJhk1cuwQQ1fbjg6YFcZLGtmLNYgpEPH5VGSiFlVqvMhZE+kvzpIHa/ZstuMU6qFBmOURSrDZ3a1DKPYUNTV1Eqc79WjzWHGyiGR491hSdJQQ57XopUDl4UEd7eXVYH9/cyjHiGLck/DnxiVDKkuHHuDdOQB8VpuXLNHf/tsAcXEWDVEY6k6FueYYsMerXx96j0ia0l0Rxe4MSW0iSuLyMspv81metOkAeXvZkZqkemy/aH6iv3HwpZNi94F3OTC7vzmvh4zRb54byGE7GO7B6gLK4Tcw7g+/Cy7a7qvDiUDbCYULG76jH/eTCx/IUiscaDqKEGNknKlGsaNqRgNaLh2xonW/ruEq8yQIbg6gVfbOAHNHVjtdIiPxC7N3hyieXOZOxADN2UavD7Hpyymb+qVsaTwgjKmvRgEYe8VFUZUbTH9mEZos631jb+S+qANBJbNrTPYsPd5f1rln8P+wTIO+IQKquJ8gHvvL0gEg6t0VADuzG+ac64QDuJMJqdUgKQ/ruzRoMrgz4ocJkEiZkwwEpDgowpv/rP3Dtst+N6GRlRnIq0vflG2qTnSgAC6T3TrjODgmlhl7cf6itbpxRJEjhRcapPuAe/9clPA5bPis3SorBzpgO37o4r0zAM6/X9oCxU7PG1vUUyjEx7FPbHuM
 NrnouyJG
 fywWKajZYlMakY7Uj26V/L4NxtCJJ23swyiPwBjaswj0ePjdf7gY4uzd3IvxOHMumC+TeeajEvHIUVeq6jVcgZUidNR8WFv261fkLCGqQaGbTwBo9ZhMIpBAyDDTNwPJmciwEOvGQ+dsnzBOODQgoOM/+j7ydEibbnmpK1DO3POA8XqWIdnFCDb9ObKqiyoCEo+V1qSXKaWQ5otBoxyZXoqCLgG9RC/iUiz2utX2Hz5ueDY55epLm+g8cLG0t5GdM874SW1qgmpKwFFY2OY+fyvo81tIsTnHLnfzSSe3U8NPWj1NIZHpVqJc5bl4ebjdo8mOLegrd3W/dWNA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

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
index 64fddd9f0ada1..ab0a06b73e8d3 100644
--- a/arch/loongarch/kvm/mmu.c
+++ b/arch/loongarch/kvm/mmu.c
@@ -679,10 +679,10 @@ static int host_pfn_mapping_level(struct kvm *kvm, gfn_t gfn,
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
@@ -708,19 +708,23 @@ static int host_pfn_mapping_level(struct kvm *kvm, gfn_t gfn,
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


