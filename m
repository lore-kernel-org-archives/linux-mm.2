Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 19576C43458
	for <linux-mm@archiver.kernel.org>; Mon, 13 Jul 2026 16:29:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CCEE46B0127; Mon, 13 Jul 2026 12:29:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CA5C76B0129; Mon, 13 Jul 2026 12:29:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BBBE26B012A; Mon, 13 Jul 2026 12:29:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8186E6B0127
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 12:29:41 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 57BDE14019D
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 14:03:13 +0000 (UTC)
X-FDA: 84983920266.10.773A282
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf12.hostedemail.com (Postfix) with ESMTP id 92D264000F
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 14:03:11 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=YTUUB7fF;
	spf=pass (imf12.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783951391;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yWPMv2j9FH8o/M2S5c+Ucbb28xm4zlRfMd9LAFi6IrE=;
	b=BlIoBfsTQPtroBb26CrTpX/9UAP8mE4PQwxmuYf2n+UdffDVSEO/ZzvulJ18GA4rtq/i7H
	bMNbDt39KLSEj2GxiFi1u0jZ4iLSlYPE7phm6bIgvmsiIk1WH5jQ39gARlzbLnowDVYKY5
	dJ5trAJW5oP42YmXXklZQOSQ6dOveW8=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=YTUUB7fF;
	spf=pass (imf12.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783951391;
	b=LBS7DBOHsbn0YTbvhjl/grIDhrU7eHb2h3z1o8XPMngS5v+2rOTl8+o9/1fc7MTmmgs8bf
	gnS2r0kC2bcqdqgUQBZXsfHAj9/VZcAeUM/zc6pAHjz4tF1dSjIf5ygl36/EDyRQ4U2zMG
	uVsoZ4PPPNOhS7ok37tKo+0i2kKgIWU=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8D5F62309;
	Mon, 13 Jul 2026 07:03:06 -0700 (PDT)
Received: from e129823.cambridge.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 8FE1A3F7B4;
	Mon, 13 Jul 2026 07:02:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1783951390; bh=ol7IsdSpR9IFlqcrKFYieMiq9FZeVGRrGFMQo0OPo8I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YTUUB7fFZSADZ3nNnK5VIYq6XJ5LHipDLKVAO1Jr7GLVRn2lz0fP34mlfCdApi3Xo
	 gr7DozS/TjpMi/YVQUgMBQlHH0BFjPQPoE9VdPst9IJGDMgzZvV47FgkPmMzAgwbE2
	 xLEcrrtKDKAnhfxFiombDYvVgRp+548HsUjx2dmc=
From: Yeoreum Yun <yeoreum.yun@arm.com>
To: linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-mips@vger.kernel.org,
	linux-arch@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	linux-riscv@lists.infradead.org,
	x86@kernel.org,
	linux-mm@kvack.org,
	kasan-dev@googlegroups.com,
	linux-csky@vger.kernel.org,
	linux-m68k@lists.linux-m68k.org,
	linux-openrisc@vger.kernel.org
Cc: david@kernel.org,
	linux@armlinux.org.uk,
	akpm@linux-foundation.org,
	ankur.a.arora@oracle.com,
	rppt@kernel.org,
	linmag7@gmail.com,
	chleroy@kernel.org,
	klarasmodin@gmail.com,
	chenhuacai@kernel.org,
	kernel@xen0n.name,
	kas@kernel.org,
	zhangtianyang@loongson.cn,
	wangyuli@aosc.io,
	tsbogend@alpha.franken.de,
	ljs@kernel.org,
	jgg@ziepe.ca,
	catalin.marinas@arm.com,
	will@kernel.org,
	arnd@arndb.de,
	ryan.roberts@arm.com,
	pasha.tatashin@soleen.com,
	rmclure@linux.ibm.com,
	baolin.wang@linux.alibaba.com,
	tj@kernel.org,
	kevin.brodsky@arm.com,
	anup@brainfault.org,
	atish.patra@linux.dev,
	pjw@kernel.org,
	palmer@dabbelt.com,
	aou@eecs.berkeley.edu,
	alex@ghiti.fr,
	dave.hansen@linux.intel.com,
	luto@kernel.org,
	peterz@infradead.org,
	tglx@kernel.org,
	mingo@redhat.com,
	bp@alien8.de,
	hpa@zytor.com,
	hannes@cmpxchg.org,
	mhocko@kernel.org,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	kasong@tencent.com,
	baohua@kernel.org,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	ryabinin.a.a@gmail.com,
	glider@google.com,
	andreyknvl@gmail.com,
	dvyukov@google.com,
	vincenzo.frascino@arm.com,
	anshuman.khandual@arm.com,
	yang@os.amperecomputing.com,
	chaitanyas.prakash@arm.com,
	ardb@kernel.org,
	guoren@kernel.org,
	yang.li85200@gmail.com,
	viro@zeniv.linux.org.uk,
	dinguyen@kernel.org,
	schuster.simon@siemens-energy.com,
	wangruikang@iscas.ac.cn,
	junhui.liu@pigmoral.tech,
	muchun.song@linux.dev,
	vishal.moola@gmail.com,
	namcao@linutronix.de,
	pavel@kernel.org,
	djbw@kernel.org,
	yu-cheng.yu@intel.com,
	baolu.lu@linux.intel.com,
	Jonathan.Cameron@huawei.com,
	coxu@redhat.com,
	andreas@gaisler.com,
	liam@infradead.org,
	vbabka@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	geert@linux-m68k.org,
	shorne@gmail.com,
	jonas@southpole.se,
	stefan.kristiansson@saunalahti.fi,
	Yeoreum Yun <yeoreum.yun@arm.com>
Subject: [RFC PATCH 32/34] openrisc/pgtable: drop __pmd_offset()
Date: Mon, 13 Jul 2026 14:56:11 +0100
Message-ID: <20260713135614.1618183-33-yeoreum.yun@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260713135614.1618183-1-yeoreum.yun@arm.com>
References: <20260713135614.1618183-1-yeoreum.yun@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 92D264000F
X-Stat-Signature: eu1mi3siutxz5kwehisjauwtb94dsr34
X-HE-Tag: 1783951391-685569
X-HE-Meta: U2FsdGVkX1+T1v34VBOkaOfcpxJXdeYMBsLU27HhuFRem/tF+0bFJffDL1XvQY1EczUlYUD0Jj1u4UXOOzbxbYuoKLt64VfFAQlRz4Rehfdb1mllTxINoG6qlvFfXA858Szj1lANSDjekBQdH7/3QCj3MU6/hzGNDxQf+ymzxVJ9HsTwkoQj8cuDhoOD+XGrpB48KblBMcz7WtJJmV92lD8YEk7Uh0jDE0CVy1EGr1gt81Dkx24C3YFXqNR64f1+MuI6Xx7/qFWKtyZ997xk0IL2FqJB8vMXGchiy+ZAx0lauO0aPe392nuDwPUIWsTa3aEojJJRbtBMj1FECWDBdF8Lv2Fruh8U2I1tgTjV+f0eB6oU0MabvV83QZvM9YNEWKYfnVGo6pD3YL1AEIO+U0XV5pP0X5g3ADI+sZMfQF8MyDtHUUA8p0xXjvOy7jqRTRRJerc9iNN4QCCaxSp7FJwBOqUH7kGFo+bwewnFgXzJKNAQFQdeYOlycVzAM1LW4KUkh9ZegKeVjeOZ2+KivcQE8X11MGGKh0Yu8Hl2hZZLjP0MNz38wLFHsyJKjQ36vBCV2HraQKOBdq7uV+UF6vjAKbHvXM5WdN06VRq8Q+G20EvrJQ/ALba9M8AA3diSifd2q88tYwwr+3jEJv1LNzCiABZms/0WaQE02rzlSWvS56RJN7Bg2SOeC4wdZSyWm8RoppBR5GkBPl03i496mOvYBiaw0UKYXwSbOEVO2Gya6+rH8BrRfyi/KQ4L4ZKGfqBHE0dArJEr58jJQl+NfAPAxzPSK4rJBSx+iCtr7vCGsPt4rvLH6dMrRaT2CKDTO2cqMMaiebKyvjZ49AI2XD8V+QPHBHlwGIU84qeTcpVpFlniHdE461kj/lCXviSYocwNvPUCgJ+OcQDpGMKvydXQlk5eFvxi1teNL/zwWZf8wfQg1iI0wnYx2cDLArYWdwveuN7bMvGXH3Wfn1v
 MUxZktAR
 tZZLl+W0eHa6qT1ZJZrNcNCSJ6KYW4P8JusSmczrY/OfxhcrLWXsz8aimxzb5u0iswi3yQsYVXaH1MqgVsNzlLRd9K5/WSuxEwS9Q0fHdDxtnhl63rrgx+CJGs7tydQCQoMe/Ks0qyMsiY7W+i6s8iW6vA7OhkAfLELmZL3dt9ssxjmzpDnzXuaUoThJC5/HpTnAbbfsuTFMk4tmJGEtCEXjEX+X9At4p/HTMTzFeP1iTdQtfLAz8QfwXlko7idbPQvEBdgUEYiQtrM8hD4Kwo4ozn47Xe7wuK/OMW0Y5Zi5cEgFP6cC5XiJRU9g1ZNaHCo+L4aQ+mAvssvkCM2dXLPGtpYjLVgM4sQh3+cZa/GHGkrc//2HRtsEjubRYBPf4uirv
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
Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
---
 arch/openrisc/include/asm/pgtable.h | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/arch/openrisc/include/asm/pgtable.h b/arch/openrisc/include/asm/pgtable.h
index 6b89996d0b628..5a491cd0f0086 100644
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
LEVI:{C3F47F37-75D8-414A-A8BA-3980EC8A46D7}


