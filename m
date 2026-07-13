Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1E1F0C43458
	for <linux-mm@archiver.kernel.org>; Mon, 13 Jul 2026 16:24:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 45DDE6B00E4; Mon, 13 Jul 2026 12:24:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3E75F6B00E5; Mon, 13 Jul 2026 12:24:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 261466B00E6; Mon, 13 Jul 2026 12:24:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E8C2C6B00E4
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 12:24:41 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 416CC14017E
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 13:58:13 +0000 (UTC)
X-FDA: 84983907666.16.F57C307
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf18.hostedemail.com (Postfix) with ESMTP id 7E7051C0003
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 13:58:11 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=DdR3X9Wl;
	spf=pass (imf18.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783951091;
	b=xoojeQQd3lehPLd3YS4nCGUCDQh1xkiPut3vSGYtb/eEkAWuz37escuIwBwRI2oJK5T1K6
	b9VpMIul/rO2dI6poj81lrpnQeOKATCqK8H7ng1X1Z2Y/VLV2724Jvw86rQKk69Dq34eSE
	CMoxyt7kB8tIEC3VTrLhqq5w7JjHl3Q=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=DdR3X9Wl;
	spf=pass (imf18.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783951091;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=l5w6oE5HEe8JIc+W2w0R2W00rFA/SoX1+BMHA86Llgw=;
	b=fbRKGAf3vubCO3GEUFQqoPFa0WITrQEanvdwkHi1ZGlOz+UmplO/rke2Eq+gxX+GCF7vw+
	OGJXSK4Xk3egGDnjWbS4v6K7lSA/fWAljHlk/7SOVgABM4YQ9crb4R0+WrmuHZ/7ppT6Mu
	Tnn86e+IZojo+XY99WmZEfp0nLmWh5w=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4FCE11AC1;
	Mon, 13 Jul 2026 06:58:05 -0700 (PDT)
Received: from e129823.cambridge.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 5ED463F7B4;
	Mon, 13 Jul 2026 06:57:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1783951089; bh=mBLNA1RE5nPCRMeMUYy6R3x/DliVq4xqj6BcbDOXlgY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DdR3X9WlWDBXQwBp9CVeqesFty3i4K5sZKZNlRdOz5UoLB9G7ZsZnElI8UvLgmr7z
	 LQoj/SHrsI4Iu0SVJkfyZL8I3gCj8zhHB623W1Cp5BARJIHJEcYjK1lMJfqALKP6Tz
	 EmINtx38d14EKEwmKPBLuaizTFavA4hWgv4Uhow8=
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
Subject: [RFC PATCH 08/34] loongarch: kvm: remove stack copy address of pXd in pXd_offset()
Date: Mon, 13 Jul 2026 14:55:47 +0100
Message-ID: <20260713135614.1618183-9-yeoreum.yun@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260713135614.1618183-1-yeoreum.yun@arm.com>
References: <20260713135614.1618183-1-yeoreum.yun@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 7E7051C0003
X-Stat-Signature: to759bko9s9x7ntr5ynp7gkhbyf3486f
X-HE-Tag: 1783951091-680094
X-HE-Meta: U2FsdGVkX18PdG7Zv/kE6oNn35NsmylLwDGaMdNUhoA7jF7hSkYm+Ii23pDpmN0/no66imNFEiBo6e/CoPpqEAVcgfsO4En4onLfLz6D55dbHBeDODrEkPF+9C8tZqGbKk6cLzDcNom+osbMG7cTkQE5h5ucjxhJ1wgun1U2Wclyqw/xWTjcLpuk+OtfrwUKCXRz7O2QTKoAMP1qtE7jcgQ4VUu7FxikUkSyBHPp1ib8i20TegCgS7SfwsxJqeUBRrCD6a/Tp22gxYwIljWzrrFb5J5sFWmCjjUsbJU62IStAqR+EoBT7pBhTh1sJVxy/mr0WQ8pScQ3jrpOBn1ULpe51M1o3seWoAJt42MMoWU+p1MzKqqBeQBNoYuRkKrH7BJE86c7L5CihquFtk11oAbUgjA8GD0w9fy5BdGnhRdLunSXDPfvxweSEm+19gmTp0vUQatphwyCrj3J96R3lskIj39Mei+qWZncxMoplTGMDZgKO9jaW0GppMuN8rZ8W2zJ4jX6s5s4RgQIvii4+U53V+cTHlchmZHDRYUhl3+NUWxmfz2ixtfvT52Py5G/l9+LF8bBFrbpE/fMFUoCsf8MOGcbyht2WUJJI1XaRAu5pOpXoBmnDJQJaVrNdYaNeyGUhaXg731ZJYFA8zKfwq0wCPeQB5BFtnpzWBWPJJWHDlSExkIQc2Woh62/bDgu+HaQwlxclQ254NtR+wK9mkVOQ7xdgUtbPwd+MF4s8GMNUfoArRluL1WEXbMbMowJnG/AO+m7+gIOG204zTM7KXC0g91PExyq3ZPHD8awfcS+GDc9zkXC50QzIwk43HLq8Ch3qr8nEOyT9I2z44FkfQWlLKz2YA7SVp6EG6nI1UvzfG0UQDen7UCo+9+vkxBrNp7kpm3vo/ejlW6cleNnJ8ny5dwgmHL2m7/AS8jKIZl58qJ1wuzco7hqNc0tCj30OLGPexiRh/RTIhX3um1
 LEC02Yyn
 UNOUJytrg6gCiqHUZ/RbTViOix2ycWhYhmlgFGYXVeE4gXfzz4Hk1WCJ2pptf/HrdH0k5Ek57k0D5aHX0nMfifN+SR5mVOG+ksw09lSvumS3DpMoMcFhouRMZEjF0qp88/8ODPjqKE0D0o+Z6jzgh5RngPQzJsQR0rj4tMTG0gulAa8YJcZd4ha7LjWP7jhTJDgR/rtyMWCygBnlnvsmAGtJcuvlFXBOJedsik5pjHdGL2U38z457h1gtumCxAoBCdBtPtNIyakNfJkG9rQkBsSPlBeyIh81fENvFBafPt6Buk0dyqVpCzo8dhCoxHvMP7AU3rN6bsbjY3mcdKizrGIctW+c6MtcA5hWnCJlVYeD3Ml4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

We want to change how pXdp_get() works with generic compile-time folded
page tables. To prepare for that, rework host_pfn_mapping_level() to avoid
use of a stack copy of a pXd and pass it as argument to pXd_offset() so that
the folded entries value is ignored.

Replace direct uses of stack-based pXd values with pXd_offset_lockless()
and there should be no functional change.

Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
---
 arch/loongarch/kvm/mmu.c | 20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

diff --git a/arch/loongarch/kvm/mmu.c b/arch/loongarch/kvm/mmu.c
index e104897aa5328..837b40bb694f4 100644
--- a/arch/loongarch/kvm/mmu.c
+++ b/arch/loongarch/kvm/mmu.c
@@ -669,10 +669,10 @@ static int host_pfn_mapping_level(struct kvm *kvm, gfn_t gfn,
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
@@ -698,19 +698,23 @@ static int host_pfn_mapping_level(struct kvm *kvm, gfn_t gfn,
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
LEVI:{C3F47F37-75D8-414A-A8BA-3980EC8A46D7}


