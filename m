Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 941DFC982ED
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 10:57:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8D0EE6B00E8; Mon, 21 Sep 2026 06:57:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 881F76B00E9; Mon, 21 Sep 2026 06:57:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 749B76B00EA; Mon, 21 Sep 2026 06:57:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4D7F76B00E8
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 06:57:07 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B448A1C0185
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 10:57:01 +0000 (UTC)
X-FDA: 85237467042.06.BB85E74
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf03.hostedemail.com (Postfix) with ESMTP id D4AD720004
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 10:56:59 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=Erxu0w3k;
	spf=pass (imf03.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789988220;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=w5YKXD51aBuoUFlXrfBZHkfjjfmBHgY/nOO32xh++hM=;
	b=JZ9hsUvq6zr9L233z3t+NwNuhozQSrGQ4Ha8Yy8Z+QUKB3tRK6cP/s5httaEwPojgRh+8/
	EmcrTtI0Rxy8iBh0az5nzfjsAjOypGPv2ng1loqLU6xF+E2J5Oj2vjvxw2HwTcosMlm4F3
	d51EqPVCqvv4fdHxX9/gkTwxTRpaanI=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=Erxu0w3k;
	spf=pass (imf03.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789988220;
	b=KyLktXfwa4n5JEon9+qrpCS2FYsynTfns83SPAZNk3OyuQ4azcfcqwr9xAF2jdsuKJrFId
	poOpeLUsUmLdctrVizPDjyOeS9v3Pqyb5tGtHJgByMGs8/QSGQCU8L+c3FGuJHLfYwMw+p
	RbTogDNVb5o1AaVAD7fQzJVLrSjgwHU=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7B0B41CE0;
	Mon, 21 Sep 2026 03:56:55 -0700 (PDT)
Received: from e129823.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id DA2C53F86C;
	Mon, 21 Sep 2026 03:56:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1789988219; bh=rnI7y0Fpi9EpSaKs0zPg/sympiblJU7quGD2p5tv2as=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=Erxu0w3k0j6ub5hHfj+RN6pEhjSNKHkKz8ooYKskXllnoLVwJ8Ut4DZ7NeEJ5/rDP
	 SPY3vbUR4axOfHnsqT+sZBjZVHL/E9nsVWbpsXIhcl8s27YOeWUOZEH7qpSiFxdsmr
	 myTCIU+NKUGM4uM3qVejSjvoXD/mXvabuVl3WG3g=
From: Yeoreum Yun <yeoreum.yun@arm.com>
Date: Mon, 21 Sep 2026 11:55:26 +0100
Subject: [PATCH 04/21] LoongArch: mm: define pud_leaf() only when PUD
 exists
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260921-dummy_ptxp3-v1-4-cd40cf68242e@arm.com>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=993; i=yeoreum.yun@arm.com;
 h=from:subject:message-id; bh=uHP3fCujvTA7teOGPJseRh4165tfxVj1UjkqwzmtCWQ=;
 b=owEB7QES/pANAwAKAW3Vw9FaxTEzAcsmYgBqsQ1MsnYSzGCrfSvMhPR2nenqzfaOWd2TWY08B
 FS8dv7UCUWJAbMEAAEKAB0WIQQtg+CS3QUzuFh1pJ1t1cPRWsUxMwUCarENTAAKCRBt1cPRWsUx
 MwVVDADY86GBwYvZ/9NRAVbtoFfHEGdfPzdSbaqYPaX2rteHd+ssXS7FQyNXF7l/1y5jgMN6f8T
 u7ZaYgOKw41FfG1EJ8ZIDiu9bHuqzDTTvuRML+XcjRwJXrhPRAztnbXo/OZ1RTqo729jpcB5Xl9
 9PS3DceEj++x8zDzmyN8uxazCUfLRsT6GzwULKx9ysQ+5jUUhYPliUTuPjjCAry4VEjHRk2u0Ed
 vQh9FTH94HI/jFBfC4SZtHDWf6T1x5Mb0/CSBtnqPk4Pme3fbJMuU2FsPfmyKx2KBuYHJkBfRDZ
 2znp1ATgR9+XFXRZo4l/N1jmwBMxYXnA63Q4aLVjuDFyHKRaqnvXBv39ZW6q6spPgH9F7MIAiZ8
 X6kHCzMocHrCdxMnZwrD4R9ifssomtcBwjrY1xxB7PCNiew50qsZ9SlhqunzUmYP5D4KRNdR9Eu
 yEbDNwJYCgqoM0+XH0D/u8DleX7OGnVzPCTqimSGz40CcsWXg4oKF9+WTv4QSQoYAQubY=
X-Developer-Key: i=yeoreum.yun@arm.com; a=openpgp;
 fpr=2D83E092DD0533B85875A49D6DD5C3D15AC53133
X-Rspam-User: 
X-Stat-Signature: e7g6fo4s1gdj5htun8wb64o5dtkk9qho
X-Rspamd-Queue-Id: D4AD720004
X-Rspamd-Server: rspam07
X-HE-Tag: 1789988219-943689
X-HE-Meta: U2FsdGVkX180nDOVfwjstQD2VKb68ZSnc5ZSjX2pAfJa3W+SNb97l1DGMs0YIQyNgZgOf6BGzpRLdAdl/AL6D78Up5OjjzV8gFCbU6P2K/qZXbp/ySbqliOx3BmIaXpvvu+RckdY2DUKvWI9kbi1i4V4WBgyY5USNvh8DuZnqyB4qUYbeWzaGHBakyG20Y1pgWjAqMBOx+pIQZlDJKtdXjQDHEs/+cFeQgXYKnwxpDHJ1mcLC5MNMh49RrCgrBaaiajZdJBk9H6KJ3gv5sPHHDg5uMdFS6rFgeH0UIuQYxMFGKSgNyJfoi6rKrZVDMdJe3ZgJpu0sH/D9UzHHJ0qSFB32TbrXrnM0RqzN2pFJ07Xihujum8LScsFfVU63E+jWwrXmW+tRjTGhug6sKJzvb+VL2tjQ2qtLQSL0aSEkSzvoH1hItjZrdXEH+HN9dOrHj0cHxjF8vQzDBbEvEg59q79TZ6KkEgtstodCxiV87f12UiMae3J6yLVJS+zMBv6UEbLAsal/ejiKTDZjt4/WiQMQaESDarnQePfy9uGF1RfRQxcppC1GIw98HEaeLfHjiN8+DDs4QE6B3dfgUcAN1FyW95Vdiaa/swcgfNTBMA3Zh+ItbNNm/3QHy6h+6EF7bNMXVtvf2f7NPikLy8++vISO9+3nLvqIaQtGbZEue5lCvRCMDN2GbgXZZh90XbBaxLuF/lXnlsbm5RPjUrtMkcLv4AaENOyk2OLibUJbkQWe4QanzgszFW73xDs412zlyBj1JDsYImvlq13FhiS1AzoeviB5R+ke1pwdNTOMFadKa4mjv1R8Co0AMKImNeetPjv/aQLQlKeZ35dOULVTOwADrhvE0wSdYE5elI6Ca8vgu0ESZgGtwvfSy7ul5FGPc/ka9RD3Qr/OMQ2WYQ1f0nKTz4OaM2zNI428FROXGoleD9rC3lrCSXQDVwwt7ryCNMiZ1Xt0ms/nDMdh5n
 mDUZZwr+
 t0xUq1qbJKUrugJMtSZ59S6gb0veoWq1g1z2T9+yj1owgrPNpaFqcJP6bznG0G3I4JrRFo2CdXeUO8BaanyWcsZLO4LBktiV2bdn39PTQbhkbtdQUV/6TLgsbLt2zf05QZ+CJI5wZfIBJ2GJP+OS/FIPOJlAxyzorV8gW4sYWWHeAtUYCAKhnb0ZdWLGAZrFNmeusnO/43t7oTVsGgdVac6gpdiKkHLgMFlbeBIYx+C8wBkKBnkYelFQ6QdIHrZVjnH34TJlMxMkoBLA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "David Hildenbrand (Arm)" <david@kernel.org>

In include/asm-generic/pgtable-nopmd.h, pud_leaf() is hardcoded
to return false as inline function, but it misses the "define pud_leaf
pud_leaf" part.

To prepare for fixing that, define pud_leaf() only when
__PAGETABLE_PMD_FOLDED isn't defined.

Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 arch/loongarch/include/asm/pgtable.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/loongarch/include/asm/pgtable.h b/arch/loongarch/include/asm/pgtable.h
index cf29a4c8ac593..8aee4fc27a26e 100644
--- a/arch/loongarch/include/asm/pgtable.h
+++ b/arch/loongarch/include/asm/pgtable.h
@@ -630,7 +630,9 @@ static inline long pmd_protnone(pmd_t pmd)
 #endif /* CONFIG_ARCH_HAS_PTE_PROTNONE */
 
 #define pmd_leaf(pmd)		((pmd_val(pmd) & _PAGE_HUGE) != 0)
+#ifndef __PAGETABLE_PMD_FOLDED
 #define pud_leaf(pud)		((pud_val(pud) & _PAGE_HUGE) != 0)
+#endif
 
 /*
  * We provide our own get_unmapped area to cope with the virtual aliasing

-- 
2.43.0


