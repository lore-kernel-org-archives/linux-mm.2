Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4178CC43458
	for <linux-mm@archiver.kernel.org>; Mon, 13 Jul 2026 16:26:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9917F6B00FF; Mon, 13 Jul 2026 12:26:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 942C46B0103; Mon, 13 Jul 2026 12:26:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 71F476B00FF; Mon, 13 Jul 2026 12:26:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 450C86B0101
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 12:26:24 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 92D6E1C1167
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 13:57:34 +0000 (UTC)
X-FDA: 84983906028.17.C00AF6E
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf15.hostedemail.com (Postfix) with ESMTP id DCF5FA0003
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 13:57:32 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=K66vVOhB;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf15.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783951053;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fno9qj1ZAILbTT3TRIKZZEeZ4LbSpNCCThGF1ahJtpE=;
	b=8TcIRdr6AN+3hpPPHa01SYuvg4gwoxXYuu+Ko1to7uw0iA93EL6KIv2Z2rCrIgXUM/2Fg5
	03Qz9FzCC1sLMXVEOCrU4HyYMIGmgrjf4xBKjsoY7KaUbvFn2GINxTJEgP1R/1Gc0Rdt0e
	JRNdz3pJ58+khuGn2D2lyX7236KyxsA=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=K66vVOhB;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf15.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783951053;
	b=S/GlXujqbcGM9ToiQTk1tEquZ6NgNa4QwTDMGCgKxtwvoOVbuj5AHzqUb6ZxlC38cXkEW5
	/KzJ9xiO38w9wMew7gnlT2Jw5pJvCUxX/eujhx6j0bsPKTKwCjPz3tY8M8wj5VU+I1uBRp
	SESoEWCxgzBdoqEbCgv1SXeVmtY+5mw=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id AAE3C1762;
	Mon, 13 Jul 2026 06:57:27 -0700 (PDT)
Received: from e129823.cambridge.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id B722D3F7B4;
	Mon, 13 Jul 2026 06:57:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1783951051; bh=oSezCrKL2Fk7poSDNawI1oGiL0c4tvCRcuxmLXVbtSQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K66vVOhBLzzxW23h+F5Tho08YRxhhBDqZaVIwqzzKmxHxjFFfOTH39HIQn9UubZB9
	 ostz+VD+rNqz3d1AIRrmBFuhT8Dz+J436yj1g/aksCCRtwL4cnhHD6Y41NzMibYLax
	 4UW+8HiauiTZaLk62sJwJVSuoF95kYl1EtAPrS8U=
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
Subject: [RFC PATCH 05/34] MIPS: mm: define pud_leaf() only when PUD exists
Date: Mon, 13 Jul 2026 14:55:44 +0100
Message-ID: <20260713135614.1618183-6-yeoreum.yun@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260713135614.1618183-1-yeoreum.yun@arm.com>
References: <20260713135614.1618183-1-yeoreum.yun@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: DCF5FA0003
X-Stat-Signature: wh3ginskxmnz71niq3ujjr5ucfuwdq8g
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1783951052-979664
X-HE-Meta: U2FsdGVkX1+qYDtM6QqMGehcsuZHFlIwIhUDrG/dos503Owlu1KnGjAmfBFsMb6L/AgDysqV4C0MbUH67K0aSm+iAwkgc1/0wx2QSltOe6ghC9S5AEYH5kKhC+nmADO/QvYbvuy5WChZKHGfEz945KYdCaD0uuGGGJfBn9PrevmXwibUKScKLArNh2BhR16/gbOhzckUp951jNM4xxQfqiiTUKxQpFYXtWpFNSBVe3vd/M9lu58o848taM5lnNwnjECd+6/QKxa/zZGaDv6cNJAkb85wI69jKkZ4v5Bvy11PIext2TDNsCtPdCWCLUpIIyYu+jGs+YDY1nwGuHGmjFzBKtF3rdcXsSHQ1CKkNs4uZNe5CxN3Lhi3sZRLUUHENesK5w8t4AphdJgk0HBvEaarORvWcde9xio5LwNnGlIqJoOfTmTU82nm7jZZcUSWWF8pWt9V6nxDrNYRHSoUfwybR1Xw8wjGgQRy1ki3Um6CLnlwuK5/oRkFhV0LnJWJrs09j+BcC4JaMpZHQJvoSVfixWQiikr3oDwbFwu7GlQUiK1YgxSoXEDZ/AtyrwVHhmi4d9a8XEyc1fB6s7QFA7n5aWiIJamMIfl1+yEgOlVGBRORareJykjDJ4mVp23oD6NEa/Vy0QP+ix0qsgFvmPSvFRgH6SjRn8+RVtn+8k8m9bkZY0i2ER5LhMORHYaaWMe6J0IMgCJjt3zxmYxDEIOO8vxlddO7Ocx3G3Rtsr9WyDm6mTQfB0IVnMoZIHPvvrwpxOVbNiZPMszniOxPXj9+KKvzcANYNxgE+v1PMmUblLuCvatdtKZxRGN2tiq4VoL1A3qN/hRJFiQBSaaGKBQbKVR9RilmRNS1jYLIW5L/StaHLhF7oxV+JzQWcH9UqQrj6chdBfuldYa+VMoez2c8Tb9DOoE9j3GX802BahoG4rLcesQO4x2CuwdyGWX94H2lhCMjblvj2EeWzvW
 kdOxz1Lr
 Y6FEs9J94o3ETGz514nsnYjX5tezzGq8DbrWqnYnzB21NtflkGkIc7OvYyH6u1hCXR4xFKzr01S7fl8eiROliG67xaxf1hh2nTBqCTUx5hQbVBrua5J5zZv9AYPF/0njqlsrpeG2a8cw8J/TUFWBvQMm4r7hTzQDVReLptqNfIS9EDhRVZ3xgP6ZjyYtHvE4v9oKHU77nONTkdFDrEqTxWg7lJ94RgurBjrWo6VqQJxJ+D1wzvupCntb7LqahlomRBWtLSJCOGc+AhQv5CwXWKzQY9osbS7SIiYv3Dg3qDibQJTPp1egrH8muse/ghVLEr77iUGnyca7JiOifoRFyE33Yd2uMlM3SjUDzaYHBaV+2Zi69a8SXRsyyEJsq+pyULXKn
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
 arch/mips/include/asm/pgtable.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/mips/include/asm/pgtable.h b/arch/mips/include/asm/pgtable.h
index fa7b935f947ca..151f4d15bd12b 100644
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
LEVI:{C3F47F37-75D8-414A-A8BA-3980EC8A46D7}


