Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BA69AC43458
	for <linux-mm@archiver.kernel.org>; Mon, 13 Jul 2026 16:25:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CEC0E6B00ED; Mon, 13 Jul 2026 12:25:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CC3846B00EF; Mon, 13 Jul 2026 12:25:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B8BEC6B00ED; Mon, 13 Jul 2026 12:25:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9585E6B00EB
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 12:25:43 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D4B0E1C7F09
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 13:57:21 +0000 (UTC)
X-FDA: 84983905482.11.E3CEA5F
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf10.hostedemail.com (Postfix) with ESMTP id 2ECE0C000D
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 13:57:19 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=BjUetTWK;
	spf=pass (imf10.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783951040;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7f9c3q5ndIFbtxXEVA4NAWdjQ0ZuwV/Dolb2pHCkLgc=;
	b=u9rpmenrcAWEijx1bC5MIikE+3r5N5Pf7/WtmcvBP5M9iJ8iPKsWxT2mj4XSigpHPywX0+
	jcfZcN9b2UFooQftAMs3qNG9+HtP/vsn6yUkIR6iyRnBofUBwmhE0yf8+askNLc37DpjQQ
	9+WWpbVGj7GMbFL5NLeKi6Hk8+cUEQ4=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=BjUetTWK;
	spf=pass (imf10.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783951040;
	b=duu54ps7FSwghreg+5a7z2ROanQBDWUqZqen/lQp8C71mZC02bUxs2X8fMEHwucniBsTBV
	7kdZb9Tzbz3ErLB73LGJsDd23/Wq0O2hP+W4pRJIL0xu7pXhhxtQ0MMtVGDGS9qPSTCRgM
	UhVvWvEJVPGj/qrferFlncFsk+gkO5U=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 21B261713;
	Mon, 13 Jul 2026 06:57:15 -0700 (PDT)
Received: from e129823.cambridge.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 310683F7B4;
	Mon, 13 Jul 2026 06:57:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1783951039; bh=rWnh71eP4ExKejhtZMDlAoDG+E13CnFWq7MJbiy4Prg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BjUetTWKI+nFC6Nb4ya683onv52KMTRNW2dVnNgT8le31HCD8GqM+yxsQ7Xn9inlp
	 BJwD2Sxlmir5mOjCFoMbNwgdOl1hgNAdS8x3+8JhdyHZ0gJlQfi6DP+vPi7SoI9phc
	 9Vq5JzPmq8OqLNQQBIhWm1+azrXVisoqqRFDxEc4=
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
Subject: [RFC PATCH 04/34] LoongArch: mm: define pud_leaf() only when PUD exists
Date: Mon, 13 Jul 2026 14:55:43 +0100
Message-ID: <20260713135614.1618183-5-yeoreum.yun@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260713135614.1618183-1-yeoreum.yun@arm.com>
References: <20260713135614.1618183-1-yeoreum.yun@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 2ECE0C000D
X-Stat-Signature: ft5d16a94bbfekthzsmos8xzaua5h493
X-HE-Tag: 1783951039-151839
X-HE-Meta: U2FsdGVkX1/B8B5fQ99wa7Bc6ksZhboXlIC5TT8CO3XHEShQBKyfQLY/USXd17ecahlIFfZes/GLkwI3RTXEmV8Xl/e05V9sRJSwZ3RRBgz2zgozZMUjCj7nD+o+QOjJMT5N5eGtnPkYISHc/SDloXYRmifc752XBBRwbmKqY4jK57Na01gJCiaOYALDRlne2BlmWOc09af8L/AzN0AsoCOG++2+y0BF1/ONUgU59URx+pBjyx98QOnto2kv+MvMEn2tcxrYcJ8cZ/7pRHTbNiBepYnCSUPRtUh5UduURfyEo1QpBcAISq4kbF3jSlJDUq9y5g+cz10pWkdanV+s1bJhFuc7F3h4GWTLMqp8osuoy04n0MC/nGpdjOKbQAXZZdawYTS1oae84u5vkR8k1tMFNBvCxM/oUlNHrGnHsIXspgr2h8xcflwGgutzxcI+V7spk9odmSVsMKTqqTL7h0/4OZnocVx/GeZp2VAelhmkbMZefHu5kr8PLkEDsO1fY6lysrwa9H6/v6F4/JdCTGVDujwgqMP8Za9ePKTOpICRN9f/MwlN6lW0cRzEJ2pLRGb44y0iq6Ht5znmz4t6hUPxK2yiW47YxkOIGGT/YSJisOKhnouuB2Bj+xTIt9NmjuOssjIGUXjVVd7DvJtw16yIoYNKII56ARwSC88E39JiVD973e5tybxBM9Gm6Us5i3ED3cUS8MyAczRJukrU8vb7GfxY48gwtnyl684XpfmmR0GYmXKT6SjRUbH9HMwJ7jPwvNY1L1lHIBCWjBC02pMo4OZRp8p71HmnE8ClIQG5MA/XFMQq73R6LkS3JCLgqXCS1dJ/QdZ+8I6qOnv+NKauawVTT4Vz9j++nRMSQvXgJeh2tBfXQza42dLGN8YSAq2e7kMY8GXVupmFerkRo6IPu6fsO4K3F2SjaWl+kI47ns+qpvjmKAV6VGM7tV8mIuNjhOqh70cQoSsQ4uU
 9UxTQpfq
 G0cz64IhrU3Z4L9ccB8Fm7zM9elm4e8TRYntogdqIw8C1kbZVCFXiPs0SrFtDSu02TKOYtR18ImXt+u3jRJgucnsjl6vu80tpMd0BKyClcaslerDZD2evlTXvjBnskOIRDfK7lNU2xyKlJm0DsL5cttis4No7Hg7qoogrgOdlkaglyRz7aIR8JO5RXow/77K9bc4CQIGGFDx2cuuEI6FMroFG5dcnRAuXPUQXTpVEqAPmvDmP+E9uvB9STWPiLbdBzPA58d8lAA6IuqkhEd5GutQXGWYYIRiLNRyh5kQqb/fOoGQ7EwkXy+KunFlwnPj3W0hx3K8fVx5YRfqjW1PfzyHs9O66Ta6w2k/z8tbCqrPgo5Pqpdq/ovzi6+ifecITn8N+
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
Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
---
 arch/loongarch/include/asm/pgtable.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/loongarch/include/asm/pgtable.h b/arch/loongarch/include/asm/pgtable.h
index 1952e34bc8ee0..434e5b4834664 100644
--- a/arch/loongarch/include/asm/pgtable.h
+++ b/arch/loongarch/include/asm/pgtable.h
@@ -636,7 +636,9 @@ static inline long pmd_protnone(pmd_t pmd)
 #endif /* CONFIG_ARCH_HAS_PTE_PROTNONE */
 
 #define pmd_leaf(pmd)		((pmd_val(pmd) & _PAGE_HUGE) != 0)
+#ifndef __PAGETABLE_PMD_FOLDED
 #define pud_leaf(pud)		((pud_val(pud) & _PAGE_HUGE) != 0)
+#endif
 
 /*
  * We provide our own get_unmapped area to cope with the virtual aliasing
-- 
LEVI:{C3F47F37-75D8-414A-A8BA-3980EC8A46D7}


