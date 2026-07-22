Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 87527C44536
	for <linux-mm@archiver.kernel.org>; Wed, 22 Jul 2026 15:31:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 87FDF6B00C2; Wed, 22 Jul 2026 11:31:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 858266B00C4; Wed, 22 Jul 2026 11:31:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 76DFC6B00C5; Wed, 22 Jul 2026 11:31:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5201C6B00C2
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 11:31:19 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D597F1A0239
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 15:31:18 +0000 (UTC)
X-FDA: 85016801436.14.182A8DF
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf12.hostedemail.com (Postfix) with ESMTP id 05AA540005
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 15:31:16 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=MPNrLQ+Y;
	spf=pass (imf12.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784734277;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jNw+iX1JUykfA1+rp0I9G68gkvtupCgKe0+JAIislx8=;
	b=Hi9nk9H/WS380W/ztXCv5tY1N6b9OgUhFPlHkixif7U9sMdwVMAuY6QGE/qsJDCu5NV15K
	0lBvabuz9yNwkBnav6ek5WIkotlm3IORGhTxWKN+KpYmkprFlnbbRzO94N4hZhsu2yT2Cy
	rCctsVdC8IP/grFE2Tj7kcRoDquoRZI=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=MPNrLQ+Y;
	spf=pass (imf12.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784734277;
	b=5znoiwCe9Ah9oi1puo6KL6XD7j5QjTCMyxfAbNS4U440e40OST68SZD+XQUGkSXfm2yFNZ
	484t2qnk7TltCBGLBx+EC6r8Y8iK8Il1OqkPHGw4uEIlee7H4Vy/ezjis0CdmJy4RS9hy3
	sPVnLzVNprJGAXm3lRBSndFffhUUPZE=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id DF1B51691;
	Wed, 22 Jul 2026 08:31:11 -0700 (PDT)
Received: from e129823.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 43CC43F66F;
	Wed, 22 Jul 2026 08:31:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1784734276; bh=hiWrXKZl3HSQimA2aMCTib+KVKF++dHLJJBYh+lph9o=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=MPNrLQ+YsrzFiOpSP9SWG7N/+MHgnknKNZkXq4aPF58fJCxXjdRe8DHJBZU1yH/gb
	 Hz/yrfkTsAkIA/ai9FsVtwg3y7MKal7n0Ve6mdFNF8PditHoNSpER1jfZuPa1LaR0O
	 RKS15ZaEJK8eMHTb91p12+ZneLnHBLh7wAv66T/M=
From: Yeoreum Yun <yeoreum.yun@arm.com>
Date: Wed, 22 Jul 2026 16:30:13 +0100
Subject: [PATCH RFC v2 05/20] MIPS: mm: define pud_leaf() only when PUD
 exists
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260722-dummy_ptxp3-v2-5-d9e4bad31e0a@arm.com>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=954; i=yeoreum.yun@arm.com;
 h=from:subject:message-id; bh=H+H/wmu4330VwmFZtb9J1sA2hSnEoaKRqGEvxUP6qx4=;
 b=owEB7QES/pANAwAKAW3Vw9FaxTEzAcsmYgBqYOIRWk1b7HFDPY1VFchgF5Cds4RBwgntIkDQd
 5jEN4eIWxmJAbMEAAEKAB0WIQQtg+CS3QUzuFh1pJ1t1cPRWsUxMwUCamDiEQAKCRBt1cPRWsUx
 M6wGDAC2lHq5x8fgh5N3V0oN64yuI0v5l4DrbkPQqL3r9rW2b0FNVBd8zIJiTJmI0CpqtAOemH4
 07Hnd7BkZnZpKDbHohJSPnUdu086S156nZ5ujv4kOhoHf8KmNwkqeHp18R78FvRHCex06Ri81uu
 vfeUTcJSNH5iNsf9kMiwUlTIsfEcXZA4/xSPo54Qe2vfVKC28/Y9VXC4xeiT92Sx0XyUgD5cQdu
 5sGaCdBzlMbyiAdTA4BA0bjCbVvtvdaz0mihbWktNtc5Ep0aa57zWF54tpr7+vdIp3Hl7AFudJz
 bf3BBQPe4rLdeg2tMCLgcXy2dUxCbFZJRH/oGKD8u59MwaVyGN5z4J01wLxQap/KzJi5ux9/KiP
 Mf4bjM2FpSXqbhPa479cy4ItfK3JCYLe+rXwrUEmg9zfiY2DG7BfXN3hY99ee4pjgVHIswn26Gy
 LkGQcigk9fzVC8V+gFi2TGvn5JttPDqyJr8QzSiXoSgwRxNuqZEx+nlFB5lY+w/pxZ7YA=
X-Developer-Key: i=yeoreum.yun@arm.com; a=openpgp;
 fpr=2D83E092DD0533B85875A49D6DD5C3D15AC53133
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 05AA540005
X-Stat-Signature: 6i1dhiupd1f55dyir3nrpoy513tcb19h
X-HE-Tag: 1784734276-556600
X-HE-Meta: U2FsdGVkX19Fasg3nniFxRSZTtIoszAy8Vpy6AsC1Qua8KJq+cxn0/dVnNCBcER8BnEqU3h5/th86JBXKgzJLl7v2lEaSzt+FsAU86lqkZPPo/X1qn5M6qAxEDiQoyn1ENmJl2zAXh+uFyJn/wraWVeGflfKHiJF63DxbPl4Fi/zqaia8wH3kVZ69NqCKaC7wQzqKACAxnNZlOY6+dFqpMUSBSZIPTsbwSqcoGvtd/hBuDKWVA6qOzcFgHDqH08EO15eGx3PvV93Tif+1gVHa6sjj6b/8k89fp2tLntk0m85i8XkNvZFE/O0qZ4Rp4ZbvgXl01RLDu5iuJwBn9mmg++p1bjAjBsYWbkblf7dbB9WKxYdqnkiV3iWvgZ7CvvOxFYMlWtGxh81/Vi7LjAYxD0YeutoXJ6h7daCinF5zX7FsWbH27/cLMbhNd6Sgxd8q2qJC0XUDidaCwE3eCnG4PBrQ1ZNn7IqWlWWSCu5TrOqXo10TKEZpPr39gA+j4MipvjLN3kVGjnQNch27aXWZJ6SabHeMqPvONcv5v/fQrBvo5fmUHAF1QmXZrosejSMi6FlG4S5ab7s+z9YFoWQXDpZydSNAGSdk6GCEJA1O1v2Bw7XyDfJ+Luw1kQ/Vac1QkNwBvn2koDMZpjXSW3Si0kuqNijeHq4OFYkPfxN4wjq08vqnSQ/wbF91RgE9PtPdKy+wtsoORwy0FPfRzQzrcMP8wRYDgdpoIJ6XkCfjFaayMrr7Hn1k91TyUvJ5Fjy5gyuc7whFHvD4ADBdv7QbDjnBN9tN9ChgMwDYITuMqfj36EiHTOce7gM1Iu65TO42drjYG8pezdsYLf5+BSs0apVqx2dS4Kd9tMntT2pVGSsCzAFkhtYekxmUsYqqUyzcTKlP1U5ygjbII3V0JjgxvYWp6NNNnndOrpdFDy8woA0eer2mR2ehp86aH2B19HxlTPCYOsywqduc2dTnp7
 mFIg+ee0
 zSSUQWtlk+mnYFI2U3QLGg4q8wzKT1otVaKXLBWKV5Rur29OTCScKKkpgnmPlLae1qqO8UaiwpUxq5CT7Xw2HaMNclqSrws928EfXi1LoBjwL2RhI1UegC1E7xr97otKXwVDeG7NgbA9lr0UMRuGtsY++BgtR82ZJKEsocDSRgLldqqb73ovY2R5ExAn105tGq0KhxHD9r2lZNTq+OZ8yZcoohfy1rj0pIVc9L4XBjHGuADILcv3C73bUMuh7ipKg008kmhYKjua1hhw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "David Hildenbrand (Arm)" <david@kernel.org>

In include/asm-generic/pgtable-nopmd.h, we do have a hard-coded
pud_leaf()=false inline function, but we miss the "define pud_leaf
pud_leaf" part.

 To prepare for fixing that, define pud_leaf() only if we don't have
 __PAGETABLE_PMD_FOLDED.

Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 arch/mips/include/asm/pgtable.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/mips/include/asm/pgtable.h b/arch/mips/include/asm/pgtable.h
index fa7b935f947c..151f4d15bd12 100644
--- a/arch/mips/include/asm/pgtable.h
+++ b/arch/mips/include/asm/pgtable.h
@@ -745,8 +745,10 @@ static inline pmd_t pmdp_huge_get_and_clear(struct mm_struct *mm,
 
 #ifdef _PAGE_HUGE
 #define pmd_leaf(pmd)	((pmd_val(pmd) & _PAGE_HUGE) != 0)
+#ifndef __PAGETABLE_PMD_FOLDED
 #define pud_leaf(pud)	((pud_val(pud) & _PAGE_HUGE) != 0)
 #endif
+#endif
 
 #define gup_fast_permitted(start, end)	(!cpu_has_dc_aliases)
 

-- 
2.43.0


