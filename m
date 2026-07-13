Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 81037C43458
	for <linux-mm@archiver.kernel.org>; Mon, 13 Jul 2026 16:28:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A0A6A6B010F; Mon, 13 Jul 2026 12:28:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9E3646B0110; Mon, 13 Jul 2026 12:28:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8D0B46B0111; Mon, 13 Jul 2026 12:28:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5DCEA6B010F
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 12:28:04 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 0FC1E40175
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 13:58:37 +0000 (UTC)
X-FDA: 84983908674.16.88AB316
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf04.hostedemail.com (Postfix) with ESMTP id 6990040002
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 13:58:35 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=CHlkydzV;
	spf=pass (imf04.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783951115;
	b=5exSuj3Txvz+eHhhk0KsBDVp9aTizkOv1Qxe0dL0/HkeEpNf5taRw3EubYfne+GTSq/Lhp
	rHms/hUS7rVLodrwg+swX7oBkfaoRhJztJZtR238FgljWGrtcS6QZ9mZnCaU2nF/cfY60n
	UgOw+fwipJ6WhUL2vW/WSQOvXV5f+1c=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=CHlkydzV;
	spf=pass (imf04.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783951115;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xpXZhmbiVuKVrLvZ80LTV1Vrpobd07xhsGjtQDwZJbs=;
	b=ixz+kiQzs9KoWuW6QkzvDllwP/IQOEEC9fCUKVLFueCmEQYccauQVzKGny0PTpJ+aj5wuW
	8OEXPR67LK4ESxuM6jEtwKoz/D9R1QZyfaWehuE+BH4Yzo7if9sbrfQtNcUodr+hU8dQEc
	+JUMso1Nl54HFaEG8RNL4Ku2MjBJYbs=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 626221AC1;
	Mon, 13 Jul 2026 06:58:30 -0700 (PDT)
Received: from e129823.cambridge.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 722843F7B4;
	Mon, 13 Jul 2026 06:58:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1783951114; bh=ijbMFumg8P8gGkdSIJoBYbLSyYeD/Vjhz9UbWDLoy8k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CHlkydzVCllPoGxzxcQSUErvYXIAGBQ595+NL7G7e1sqPROHhsxJ8MBiTiSYo8eIB
	 Mu0LCgbjUkOW4pofPbQVpr3Y0M6KWgdVpaR90WouabYCqysQ0cuW4q7ADzrIlktriy
	 gEX7NRAFqIzU5fkSuMPNTtCBJn75XvGeTJjmc76Q=
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
Subject: [RFC PATCH 10/34] x86: mm: carve out the generic compile-time folded pgtable case in effective_prot()
Date: Mon, 13 Jul 2026 14:55:49 +0100
Message-ID: <20260713135614.1618183-11-yeoreum.yun@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260713135614.1618183-1-yeoreum.yun@arm.com>
References: <20260713135614.1618183-1-yeoreum.yun@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 6990040002
X-Stat-Signature: dc5qcr4wuahz9b8ja48fccz17ajgyhtw
X-HE-Tag: 1783951115-691738
X-HE-Meta: U2FsdGVkX1/l26knxXCJndadQAjKuk6Nck7jJAymgmkNZ0gD1G2mrs3lXeuj0jwPdeAzI9OsPxr5wUTwM2wXcjT1uUXhBg3TFBZHQtKDW6Je7jSAjEKhAVVe3S0km1QbM1uLyfNbb8wlzZ50+laUU+x6wyB70iwceOHSoNeD/9uwLllX4wBsSiLnMXib6ldmOh6AfkUylxEmJg6kA3oVbWg5H7J+Oo1RALZ4AwJOm/Rg8Oc3RbLaRFLP4C1mINR4XPvsDJkgrKS+bu3soQf66jmFT0ycZVBpXjssumUbq7IJKoxCdIHJihU4h8Ze7ErlsJ3mKLm+dygaRQa14DMMjfd9pBVypukMbiy31rIsqs/ABphfUFhKY6UQ76Dn/PvZePA5o5If8D3Nk0TzWmPY3IswdsxvEsXaysDGo87dbAJNJ4nXF0B6BEAozrygboAHXjdsa7lcWsGPQq4Mzh3j0n1nGjcV31Mpbf2dUlnhxklwwGUuVXkZlVuWK1jHs7x+9tgwvSRhf4KaimjKyFh/lsqpLDjE5Ql/0yfAmjCyQt7Ava1jeeRPnJJSyEyGm06XEXVEAwR1qzelFARNc0xq7viv9QLiNsh9r/erac9xEfnZXglKoVD1Mohx4LeDHsX8QRdhg0P0tN1Qw56XA0+TAiB6NGmkT8fRHcNZkxCjjwPv1Pd5tNop+Gsj9mR9/OhOt6bla6XYVz78xH+ix0eCqI0BFaIJOXSinX3JKI+wOFQq2hMuQGL9xSiT1iS2CoHDeRvVdv0qcp6IezSfZo00pVkAMqB/NhHm0yH49shh0N7LsaGQL82CdaQxXCGBQJhzODr7Ut1PhHST3zRAPrako9kdd4kyuMyE5Wn9gavPkiDPEpDw6wlH+o9ehn6aHmZbCx3EFK+ggxehtONI87ZlYMT+93GQfvoeIUti3xjMDUG/Qrw1OunjwI4Lps2IREiUWgKa1xMAkVwFptP3r9m
 Z8fftwDm
 q+r3MlpzrXj5dt6YOlPbBZWsYQbOQQ2YnHQVZbRY5kmTEFeHLKzZJgPq7Kq2fbld2ARAnhh/SAsulbdsOhBdtmYxOvN2Rg6u0NnRTk4OnY3GQ+sfyeiOWawnsDD8Jp1ek8HGkQyWZakQKwlVaqmSs4PzAhtjHRrhkcTN6/ynu+YPDYyOvSTlwNlnm4LT0walt+2gLzmXJjQqvGBexy/N1Eoevusv4k+BzfH8CZqxrvF+kVRQvl3VtfrEEw+3FNOMoZHLRCQBxH6kVCjFCJwhqr50lIKNEo4LKC1+PJ4p75k7arCwozuPvmUcPTL4O6xltltjaWbA/mJKrGZGirlF2JF1UkiUpZSDRklFCU2xDB6nHBvGI+cxW7QZXrXWXJy1Yo1hN
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "David Hildenbrand (Arm)" <david@kernel.org>

We want to change how pXdp_get() works with generic compile-time folded
page tables. To prepare for that, rework effective_prot() to ignore any
folded page tables entries, as it will unconditionally get called by
ptdump core with pXd_val(pXdp_get()), and we really should be ignoring
that value for folded entries.

For this, identify the first real page-table level and
update effective_prot only when the current entry is not folded.

There should be no functional change.

Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
---
 arch/x86/mm/dump_pagetables.c | 18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

diff --git a/arch/x86/mm/dump_pagetables.c b/arch/x86/mm/dump_pagetables.c
index 2afa7a23340e9..e32848c7f26d4 100644
--- a/arch/x86/mm/dump_pagetables.c
+++ b/arch/x86/mm/dump_pagetables.c
@@ -27,6 +27,7 @@
  */
 struct pg_state {
 	struct ptdump_state ptdump;
+	struct mm_struct *mm;
 	int level;
 	pgprotval_t current_prot;
 	pgprotval_t effective_prot;
@@ -253,8 +254,22 @@ static void effective_prot(struct ptdump_state *pt_st, int level, u64 val)
 	struct pg_state *st = container_of(pt_st, struct pg_state, ptdump);
 	pgprotval_t prot = val & PTE_FLAGS_MASK;
 	pgprotval_t effective;
+	bool first_level = false;
 
-	if (level > 0) {
+	/* Ignore folded levels ... */
+	if (((level == 0) && mm_p4d_folded(st->mm)) ||
+	    ((level == 1) && mm_pud_folded(st->mm)) ||
+	    ((level == 2) && mm_pmd_folded(st->mm)))
+		return;
+
+	/* ... and make the actual first level remember the protection. */
+	if (((level == 0)) ||
+	    ((level == 1) && mm_p4d_folded(st->mm)) ||
+	    ((level == 2) && mm_pud_folded(st->mm)) ||
+	    ((level == 3) && mm_pmd_folded(st->mm)))
+		first_level = true;
+
+	if (!first_level) {
 		pgprotval_t higher_prot = st->prot_levels[level - 1];
 
 		effective = (higher_prot & prot & (_PAGE_USER | _PAGE_RW)) |
@@ -449,6 +464,7 @@ bool ptdump_walk_pgd_level_core(struct seq_file *m,
 			.effective_prot_pgd = effective_prot_pgd,
 			.range		= ptdump_ranges
 		},
+		.mm		= mm,
 		.level = -1,
 		.to_dmesg	= dmesg,
 		.check_wx	= checkwx,
-- 
LEVI:{C3F47F37-75D8-414A-A8BA-3980EC8A46D7}


