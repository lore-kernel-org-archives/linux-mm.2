Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 02851C982E1
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 10:58:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1D0396B00FC; Mon, 21 Sep 2026 06:58:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 17FB96B00FD; Mon, 21 Sep 2026 06:58:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 06EB36B00FE; Mon, 21 Sep 2026 06:58:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DE8916B00FC
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 06:58:32 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 7EE1A40145
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 10:58:32 +0000 (UTC)
X-FDA: 85237470864.04.D6CDFB6
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf31.hostedemail.com (Postfix) with ESMTP id A060F20003
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 10:58:30 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="X3s/HhVM";
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf31.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789988310;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=61mOQB/NPnyS6WFT1v6qj3vnbL64UK7nj4+n5n9dFHw=;
	b=q5QfM7hANj+FAEFBRbP0yRvh5b5/Ysi2VlOYuN8mnaTM0BbSi0WYmEYXXj+Bm05j0c/8Id
	sx06jZTz7S6r6u/Lqn4ZSkUHr57lzEaJr2IYRa0dh+gTc6MyIzD6uj6stDfzoPZkCO8QnH
	ITIxkjqssIPA6/OqOMOOEWIXexl/gng=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789988310;
	b=4RgH+FOakmhwUSCLUDgfjD8Hdmk+xX70EHdrUhb6x9uMs1B7H28f2lpKqKYrKjtNc8FSiY
	hNRLgLRaO1ZovOX1YMSb+l2RDNolmYHF2QHWJ2KJ9IyPEQVyfHL80drxZMKvcziQ+gy83p
	xOEMxQorcgQqcKOaKbZgAzv5Qi0pTq4=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="X3s/HhVM";
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf31.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4D1441CE0;
	Mon, 21 Sep 2026 03:58:26 -0700 (PDT)
Received: from e129823.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id AD2943F9AB;
	Mon, 21 Sep 2026 03:58:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1789988309; bh=fSF1q0uZ2D6D7eSotmHP8T3BZdnaiPG7UdplRIp/5/4=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=X3s/HhVMmwzSQHhqq9MFWj0m6FUOVQG5sixXBNURROyV6ePF/1f5WSnJzpvwZBNK1
	 QqsYNRvkgifOqK8lofwytBap6NlT+LrwggMFa6+2446aU5pOoBTY1kIi1cGTtqCZTN
	 uHkua1WMDV/dmcg1aD+uOrvLGLVf0dKrwSWDm1Ag=
From: Yeoreum Yun <yeoreum.yun@arm.com>
Date: Mon, 21 Sep 2026 11:55:38 +0100
Subject: [PATCH 16/21] openrisc/pgtable: drop __pmd_offset()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260921-dummy_ptxp3-v1-16-cd40cf68242e@arm.com>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=883; i=yeoreum.yun@arm.com;
 h=from:subject:message-id; bh=HHmjFCiPkfuAa6Yg+gCAN1VqpmgkbnXOKSW8+pCvqDs=;
 b=owEB7QES/pANAwAKAW3Vw9FaxTEzAcsmYgBqsQ1SPbcNzmztqXWyqwma14L9CzqkX4tJ7x7vo
 vWbJ/HD30CJAbMEAAEKAB0WIQQtg+CS3QUzuFh1pJ1t1cPRWsUxMwUCarENUgAKCRBt1cPRWsUx
 M4PADAC4wQdqV+mgxWbIBoHOjsRsIdJ4n1uUYYBv3wqYHNgh5+2Lk0XLqzv6zPlZye8658zEGXj
 vgxv0IMjozo9kMQmRzUvCUgqElgfOwU8DUeEQsA3jlvHIGAwe+qRaQ0TO2J/59o6qpcHgJbdXh+
 z/NlcJc72jKMSnH9rNqp4ajPHyXuddYrsjENQBZPndlr23wfYGGcWekO6uC2NH2OLbvRUOOySX9
 FdxnXJVw3frabk+zVNtsYakl4/mWXZrhXG/zWh3Jnvq+4m6Dv0K4EUAtlRwizkYXph78QlNH4I1
 R63HWezZlORLk45PXkp9zwMCQmssS+rzDgQf5tMm3+uvh8QGnqinH/0+s+zCmR4NZSeFg0JYM/9
 Y2NbE8DNZ95kpUtUWkPyYG/9VYQNEejRP8eCknF95Fy7xSmh1ANcZfr515q2JunHbDNQJBtNjpr
 g4qJObrzFSR+5ZGT/ylRR9xgwQuj6B6Ug3pDRerJOBlq011A/stSkRMHiOCGWaN60k+y8=
X-Developer-Key: i=yeoreum.yun@arm.com; a=openpgp;
 fpr=2D83E092DD0533B85875A49D6DD5C3D15AC53133
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: A060F20003
X-Stat-Signature: i5wej163tw1npy4b9rk33pyx5au5qaob
X-HE-Tag: 1789988310-588463
X-HE-Meta: U2FsdGVkX1+fFP465lN2SA5P42R4+cU+aq34IdZuqNGrVi2wEW/Ag2v4KE3oVBjzbBxUz5QZb/F3kChusMWJiMkqTRkwY4U9zkHNZE/6CXGASL2obob2xNIAg9TpsV5rUIoJuGdJLpfPUl745KHxgaHBwu7SY1RqfWtxSpO7cmFIxhB9ScwQ/FTbNPNnQoAsYbpWSGw2atNj8hO/vXURr7LRYmUYEJbgBFC7YG7W1CrkDD0YzhJtoTB3JBqDsRmip/UA1aT5GxvTYOIAabqDCJhfxeHvHNnbeAnufCatqD2MUQFGQmqJBGKoafOJ0Z89oZQMXim9+AhSTvjofCOmbQkODmg10fsVtulOAeUJbCW7xvX/gPQxBZI6eqbgtfuFwFvDGseDIM5KrFcfOVlr/bo3v6ZBYDUITWL6F7tKprnNF1a56umMguB4ik5fYv/2snFnlEcLzagFjqPaZrjOfbZkgS9NVo1Ox03On0msyhHtaP/Jt0LPsJcz0YnnzQVBQsr1Ge9B2Zec+Ql9t+0nY4rKkc0b6oLdtxDLTg9iaplm+T372oymsWhvxG9ChePtoTGSgZx2+QTvslTFBdUqyCrexxcb6n5v2OadinNd7PWt5/bcone+kD4s3jmulYq64iOrzHwar09g2HBd5nHjtCFk+C3rEiqvGy02TYXFObLsr90Y2EXznNyXdk67HGpLOGwVZukdgLZNMvfSdglO6F5JIiQ4lf54g+2cRanqCPNVMJsIhQY4Dd+ylHUwx76G5iQR5FHZXaDlZJJKZSwoFEZkFyt/NUF+PimGQpPlM0J1byRbU6R02BovTxw2TSTc7JyJQgn5rSeLWn8GTXtZGdimgSpyr1uqDa5RqAdjmFwlLiiAavYeDA8jS0Jj1C3JquhvgE7KXI/ngOhotlTLpo9rshdPI8/UHl5q3LQgl2BEm5IoRN826v4MvysXXUHVtaULEfBMJoZmvKQr9p0
 XtKYZjjg
 DnI1bja2v7fy7RZQbMjoJm1oaQHaWTAa/z9/3I7nRnjqf5/KMODtpk9eEyc/7QBn3hsRtwCgU5Grq5Ixtyn6FVmlhmFC3Wwru1W9DUs85Po2KZVFezcuH0indSdLYhFvw/FXomrm+jfzWz0daF8+kTQ4YGDnyIhGg0w0PK5n1rKQecUbNnawbYcp14lv5Ci6R1lySJmi4rJ1vY6aOxTJFEFFTcRxxAIMPiiCzhSDAamg5zkdAS9prHB7QecEIjZLn8HvClLOTOSNfMoU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "David Hildenbrand (Arm)" <david@kernel.org>

The macro is unused, and will collide with a folded page table helper.
Let's just remove it.

Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 arch/openrisc/include/asm/pgtable.h | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/arch/openrisc/include/asm/pgtable.h b/arch/openrisc/include/asm/pgtable.h
index 13afcc0bd8631..7fceed641610c 100644
--- a/arch/openrisc/include/asm/pgtable.h
+++ b/arch/openrisc/include/asm/pgtable.h
@@ -331,9 +331,6 @@ static inline unsigned long pmd_page_vaddr(pmd_t pmd)
 	return ((unsigned long) __va(pmd_val(pmd) & PAGE_MASK));
 }
 
-#define __pmd_offset(address) \
-	(((address) >> PMD_SHIFT) & (PTRS_PER_PMD-1))
-
 #define PFN_PTE_SHIFT		PAGE_SHIFT
 #define pte_pfn(x)		((unsigned long)(((x).pte)) >> PAGE_SHIFT)
 #define pfn_pte(pfn, prot)  __pte((((pfn) << PAGE_SHIFT)) | pgprot_val(prot))

-- 
2.43.0


