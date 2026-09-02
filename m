Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D4989C624D5
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 11:57:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F38A36B0096; Wed,  2 Sep 2026 07:57:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EBB606B0099; Wed,  2 Sep 2026 07:57:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DA9E46B009B; Wed,  2 Sep 2026 07:57:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BA2CC6B0096
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 07:57:08 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 5DFDA1601BC
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 11:57:08 +0000 (UTC)
X-FDA: 85168671336.12.683F4AF
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf03.hostedemail.com (Postfix) with ESMTP id 963AB2000A
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 11:57:06 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=f884vSlO;
	spf=pass (imf03.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788350226;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=d8NEmUxm+Zls97ZfmDvJbhtMifHsmuWfvyiaRxS6jiY=;
	b=acvn/xX43gI3/Iz0yelFdudTCMBXY6HROe36YNLOEFNlbHCgt9iwgtl/aTV+3bMTr6UuVG
	Gxg3z4Cvr6CCa5cX1sV3SfYSxc5fz7SpJ83cc8aYKYj7jIgGRWJ2fM0zuELPXYqfZbvXl/
	tgJBz21w1NJcG1revlrIMRuSy6Q1IEE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788350226;
	b=wX9wcBLg9dK2bLrTOI2qtYBsmuNe30SNNNEtpghtNx5a8M3CalM2EjBy0OC5Tq8xK4vN6o
	ko73jONS458c48sn//xFNdxObm1zfJyy/sY48qT7CbeVMQX59mVc3bC/4HryuINOZ3OA1L
	W49faXh/BP/iglN/6T/X4/TOzaBqAwE=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=f884vSlO;
	spf=pass (imf03.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1327F1D70;
	Wed,  2 Sep 2026 04:57:02 -0700 (PDT)
Received: from e129823.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id AF15D3F85F;
	Wed,  2 Sep 2026 04:56:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1788350225; bh=j5KZYcW3oeEza4wEEPuE0tmGJJW/8LJA7zNPUWzIuhk=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=f884vSlO+uAcSOf6hpsG5kaWDJDu6ROVeqIxakx81gtXhm/KayFYQx3b0SCK781i+
	 ZSk6qtseiictiBC97Kr4v1QHtwtGjl/atFe3flG+GhuG+wfBXuUBazoiBAngDR8fvR
	 tKEl/qlZ1BbKg9E51TqNwea+bodKg9gJ9tMXlYsY=
From: Yeoreum Yun <yeoreum.yun@arm.com>
Date: Wed, 02 Sep 2026 12:56:06 +0100
Subject: [PATCH RFC v3 04/21] LoongArch: mm: define pud_leaf() only when
 PUD exists
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260902-dummy_ptxp3-v3-4-5d8f5b17c25c@arm.com>
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
 linux-openrisc@vger.kernel.org
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=991; i=yeoreum.yun@arm.com;
 h=from:subject:message-id; bh=MeOlGX5zz7TlceiZpHJLSajwL3IbIwIyElnPnwNLJYM=;
 b=owEB7QES/pANAwAKAW3Vw9FaxTEzAcsmYgBqmA7jTpyCvz3weXiiloXvIu0HwGyNZYxNUOeR8
 zzOVDDHkf+JAbMEAAEKAB0WIQQtg+CS3QUzuFh1pJ1t1cPRWsUxMwUCapgO4wAKCRBt1cPRWsUx
 M3FsDACKI0amFDWitWwqgh1X55KBW3r2psT1svJy9ACAY/TLdpJ2t6SqKg8N3iwOgav6tFmT1XU
 86PQMGlakmgCrVcxwGzFtiDfDMkcWhmxqA/hhBGByyFv3V8gAiqsIoTquASbDXeL6LoJdJ5A/xg
 IebsQSd4VBxzbzb0gOXKeqBB+7iXnGt0wae0LXAeHWxCPmG9kDER4VE2c68yCvvDMmeoYfzr1BH
 +OFsMihMBsPX8/ZK/6nTeTCYg8IPT+9DnZPLlxl0lP+VsQbT0ev47AJ3nVeUHxgAOk8zPIY9K9I
 dCABHAruCzWiJw+oV/AwPm/soI68/eQC5VVhARWFqQbPX19ouqoqsU7X4HJpSm751C8/KxvRCja
 Xy/x/jEo2crwE3wqLwygg1u2ZnbLaY8I5NsAH2gLHc3J9pcUSFUnPbsXlRmoFcDcVLAZVj5ic6J
 mm/ikE8OecbRalNsAOP1gdwZSr3I6i2GxLBhGHvtVWYZUt6+GxdiXpV3MblQM1dbfU9L8=
X-Developer-Key: i=yeoreum.yun@arm.com; a=openpgp;
 fpr=2D83E092DD0533B85875A49D6DD5C3D15AC53133
X-Stat-Signature: a7ycwp6mjx5bgkbgmab94fpg1ewi96ge
X-Rspamd-Queue-Id: 963AB2000A
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1788350226-543466
X-HE-Meta: U2FsdGVkX18wud1jqnntK6lXt/uEkpNe9E/Fld3mUj4EWcEf4EaPMihMnkvbMb9ZdoZhMJEJE0mE2wyNj3sP6jA+vRB4RPGFamh6XqjUwYm7Qz+Z4EyypfTalwHYwnxJi2/PESdiZCSrFnFXYX/qI0PW6+Eirehjn3XB6TH5uExFvhId4Kz/bO5xkt6l3LZ/rYEsygLYUC85CZz9pVxGLNHq+wxRIahDQ6yh3LQaWYzzbASgBgYD25n93Kedd4ZloCg8/DdnKJRSRE6liz4tOD4coUsQQtbmKYtSoOatEojx1DQJz1xNMwPcWDsgXFKMB4uJg4Roa3o7BPwl1N2Yn93kK/ApuY+smK2fk0rkiooLOZlfbvb9vJdpjb6pPdw2jRtlO68AxiNN6J1afxCdp2DD05ELBWwLTu+OgAkUoGGzeTyvqQkBMZqIYXNR/5H0CNDJRPSxn0Un0tL0EmK57TmJCrqbx/m08EZBPr7rNTDBnXNdM1P6GQo+e26dVy9uEo+zOREaC3Q+QUItG4/zNv7luvQxiEbec2WTiTsNiiGUFFnvkvzlDC15vQGJeHaGktg9czBaBEWaeaX80frWuBpvFMz4GRfuLe3KgovLwr2xSSmoFQEydbkiAlx/53wpBM9rlsEFNikOOjCEgtWhzL6/nFIeEnPf2XPHMPvIQdryTWSmgNPsjuiLjHcSgXc/c9SjSzh40wA/9nxy8B/uhDgylW+BxsFHANj6bW6hY8XMCuD4jg6tuSjQBj8/ThAaMFji0fuvdgI9BCX3Mo+p3JxDYG2LL7IyUl+nZ8LB2+/dFofTb9i0g2OGTttakjCA2z1aMXAN1Te7VCEGa1FJbvBSjWVlGcAIUZyDV2zBjlhjHVy+HyrOhdonasWsFkp/l/Hu/1Y565fVYhIGGhD51ls052EQ9sgH5ixfk7N6YMVRIY0HVgrj4n8nCReMNtHBfw2Rr72/7STL8f8XQ14
 6iF3uF5f
 F6ptyaNhlRGFIRoYwPtPqcOge2Bk5FpW30ipaH/8G11O+epatywn9q8lDz/Z+0P7NPPtOmjOfvOEflmqqWlpCxIRH5VHVW/ASaps/9DHXHLHJzrInE2+g6e5WgRHCeXwncWGHdvs975Z58s9duOZdAz8Xl3K8++xnS2vbW6MJGYaGaUJRV1Ykit/2XqIaEBVVZmErVRPYN9G2BDoLrc7t0ddrBcB+Q+/WxDam2w+4AUrnunelUa6lBBgHgjYhyd4aUIW0XpRNarUMB3E=
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
index cf29a4c8ac59..8aee4fc27a26 100644
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


