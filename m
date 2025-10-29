Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A6C94CCF9EB
	for <linux-mm@archiver.kernel.org>; Wed, 29 Oct 2025 20:07:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 34CB18E00EB; Wed, 29 Oct 2025 16:07:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2FC2B8E00B2; Wed, 29 Oct 2025 16:07:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1EB9B8E00EB; Wed, 29 Oct 2025 16:07:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 0410A8E00B2
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 16:07:15 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id BDE9C12AF39
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 20:07:14 +0000 (UTC)
X-FDA: 84052235988.19.2A0E4B6
Received: from mail-4316.protonmail.ch (mail-4316.protonmail.ch [185.70.43.16])
	by imf18.hostedemail.com (Postfix) with ESMTP id B61811C000A
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 20:07:12 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=pm.me header.s=protonmail3 header.b=Q8fbvGeL;
	spf=pass (imf18.hostedemail.com: domain of m.wieczorretman@pm.me designates 185.70.43.16 as permitted sender) smtp.mailfrom=m.wieczorretman@pm.me;
	dmarc=pass (policy=quarantine) header.from=pm.me
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761768433;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ORgS5h+xBvFClF5iXcyTXC092gY8CGZFTCYy/D6hFpU=;
	b=r9MeOs1SMmw756KnLIIn6pPorTUYXDb93pfXnchBZiW88N5zsp7RxxDlraYViBl/gUG1Y+
	57bmkwj3HffFAbatRjKs1jfERbM7zBZHjUqDON5It4mcEguwYKBg53ZGrQOWaWXCRYJqE+
	5gAQBLwXe/o/BUe43iEJGUK4ip+XBAQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761768433; a=rsa-sha256;
	cv=none;
	b=EdOSialonsJgySkeqQWxX6dNjrdIXj7/IJ++V2PuE9yBtb4GrxyZ+rJKI0gCA/RFjPRLQy
	VbS6jGn+sit42HsFqrO6Oc4ZDeyKCmzutvkMFIlvJIsyQGdOJODev5/hnsp9MUwOA6POL5
	pdPmzQiwiOZdGk3O8TQmtsAStaZUZjc=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=pm.me header.s=protonmail3 header.b=Q8fbvGeL;
	spf=pass (imf18.hostedemail.com: domain of m.wieczorretman@pm.me designates 185.70.43.16 as permitted sender) smtp.mailfrom=m.wieczorretman@pm.me;
	dmarc=pass (policy=quarantine) header.from=pm.me
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me;
	s=protonmail3; t=1761768428; x=1762027628;
	bh=ORgS5h+xBvFClF5iXcyTXC092gY8CGZFTCYy/D6hFpU=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector;
	b=Q8fbvGeL2ExKLfg1F1thHnRQ92jM0SfvidRW/4ypa4lolos8RCX0lLu+i2H6kTK6S
	 MaA1nBDNDQPyyfdcKvl+1OcEfLMV2Viqk9a+x2KT3lXIr9hXFR4fmSs0XylD1sTGie
	 tsO96krT1yWQpKu1JBZ1xoqT/Am1AJerQd1O8H4fUA92e+JgBxhZqZgpSkBFj0QbBY
	 kK5jeFm7SA2QiUwxKEOqXSEioeBK0pAcc9z8/Bx7JbdabNmBwQBKWD9VAd4AMK2nqH
	 tn//iBIEYCz7O+2enlz2b7WX/VCaIyvT/kkUpw3q6WdAghPk/Ks4hSNUdaZmzn+OT9
	 2SUvjbSgsrkKQ==
Date: Wed, 29 Oct 2025 20:07:02 +0000
To: xin@zytor.com, peterz@infradead.org, kaleshsingh@google.com, kbingham@kernel.org, akpm@linux-foundation.org, nathan@kernel.org, ryabinin.a.a@gmail.com, dave.hansen@linux.intel.com, bp@alien8.de, morbo@google.com, jeremy.linton@arm.com, smostafa@google.com, kees@kernel.org, baohua@kernel.org, vbabka@suse.cz, justinstitt@google.com, wangkefeng.wang@huawei.com, leitao@debian.org, jan.kiszka@siemens.com, fujita.tomonori@gmail.com, hpa@zytor.com, urezki@gmail.com, ubizjak@gmail.com, ada.coupriediaz@arm.com, nick.desaulniers+lkml@gmail.com, ojeda@kernel.org, brgerst@gmail.com, elver@google.com, pankaj.gupta@amd.com, glider@google.com, mark.rutland@arm.com, trintaeoitogc@gmail.com, jpoimboe@kernel.org, thuth@redhat.com, pasha.tatashin@soleen.com, dvyukov@google.com, jhubbard@nvidia.com, catalin.marinas@arm.com, yeoreum.yun@arm.com, mhocko@suse.com, lorenzo.stoakes@oracle.com, samuel.holland@sifive.com, vincenzo.frascino@arm.com, bigeasy@linutronix.de, surenb@google.com,
	ardb@kernel.org, Liam.Howlett@oracle.com, nicolas.schier@linux.dev, ziy@nvidia.com, kas@kernel.org, tglx@linutronix.de, mingo@redhat.com, broonie@kernel.org, corbet@lwn.net, andreyknvl@gmail.com, maciej.wieczor-retman@intel.com, david@redhat.com, maz@kernel.org, rppt@kernel.org, will@kernel.org, luto@kernel.org
From: Maciej Wieczor-Retman <m.wieczorretman@pm.me>
Cc: kasan-dev@googlegroups.com, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, x86@kernel.org, linux-kbuild@vger.kernel.org, linux-mm@kvack.org, llvm@lists.linux.dev, linux-doc@vger.kernel.org, m.wieczorretman@pm.me
Subject: [PATCH v6 10/18] x86/mm: Physical address comparisons in fill_p*d/pte
Message-ID: <da6cee1f1e596da12ef6e57202c26ec802f7528a.1761763681.git.m.wieczorretman@pm.me>
In-Reply-To: <cover.1761763681.git.m.wieczorretman@pm.me>
References: <cover.1761763681.git.m.wieczorretman@pm.me>
Feedback-ID: 164464600:user:proton
X-Pm-Message-ID: 931b8bb7920f3633ea9d19d797d43379e99d4838
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam05
X-Stat-Signature: 16pausnzsqjyn98bzaaq99qb8sumy7yw
X-Rspam-User: 
X-Rspamd-Queue-Id: B61811C000A
X-HE-Tag: 1761768432-958365
X-HE-Meta: U2FsdGVkX19RRs0nNehcOzG0RFtxktw3W47vzh0EgbBdZjjCtDF/0sPxsmD570uAsgcrkNsFkEj5eKFPlcj+G6YCjRpiDpw3p7nTHfHxzldV6yl4ZkSxSpy141FVJinpqsINlRjgcbAQxJD1CqlIc1VCJ5unQ8E3rd8IjksfWPFuypzs44Z6k0aQU+k7b8WmAxcWDn7qJp3yjUhASP1Ux82xrobrR/EEdtSlb+3uj0tbh0hBeom1Zhlkl4zshltGesknB7E7JkuCLuTOR8vugCAGs1iBeTNZjPQ+ey9HIfW2GDweheV5Rm++6Jl/XqWUXaZ4UFgICVXG/Osy+xya7UdHQZ40REExlLafjbiidisZRK0vTOqt5gHoYuzw+i9S57BzwnXVJVp+GuOjf/fHnaY9c3PCnd1YNKOkKMJO0NR1XGNSy+Q8SLo624BZ3YW3KSwTWioXEIvboBDvluhRak0Iihl70GavxarzbR0JfeWgXU6DpOV2VlGrFYrtkS8AczKtFbkSa0DsJe2bAbklHZXVLYDKeqKK7P0oeA9feVHZ1vBheCW/ha7dDSPlQ4qpTzUawP4T1OWj29bCyt/tcSwYcbIPhDz7wxsRToXcwR+WxmdYpm3c5UZUfMl0mseGjLwcM1qrxTl1k1dRiWMBr58hzOkuhBJGXdxc4CIN3ywHSA/0kwaLsEI8ZIXUroy5FaJQwzJILuMo31wlIfoOIvRRLhhvb7U3TBT7ijKqQbjs5cUxte0ehj3GlYfthHSVq2Qfeeij3XeROe/07fLvroCXfjDmzD+HE7/1TXn7ArtWghoxtYOaN8UC+Fb8m1bDe+Stxo7rrHk0ZyIxfJN129++2e01oJvD0q+o6NOZiKG9gH0SKp0spQAnUanXCwqYa95VxKcIYH9t6hRt+meWie3TvINZkj06dyN4vX4IDkkSBAWZqY3Cy6yv5cJFePfZyGg2U9dhrTdbP3pKj9u
 C7lGK8bz
 98A3Y7ktTduO/uwWuPeExTjmf5PTOkcwdj3Xd7nu0ssceeFcEocEIAxK3nxxjBv5XcNrGH6iE0GEiwTb5YnRK7A8W95VDd10qPIIUtHF7Og6tmushb8Wkk2Et2L9qVbgpuMkmkidINysvJrPFhs33Xc39AmDvhnvujXq9DriM+7T+sjoPMUD2cAOb3tl+o8A73OcOaxrWdbM5oGzslucopg4TTh4SUDQpQT8fBWsyYce/szjacF9krhNZAPc/oWs1IqocGAkbejd1nD6gddH91xGv3dia94i2BQp+Uo3FTY8IWpM/9RRKR4hNzI9Zp4u3XP0KCZQ7Zyxj1I75IVrUOmp76q1FXm3f5YGz
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>

Calculating page offset returns a pointer without a tag. When comparing
the calculated offset to a tagged page pointer an error is raised
because they are not equal.

Change pointer comparisons to physical address comparisons as to avoid
issues with tagged pointers that pointer arithmetic would create. Open
code pte_offset_kernel(), pmd_offset(), pud_offset() and p4d_offset().
Because one parameter is always zero and the rest of the function
insides are enclosed inside __va(), removing that layer lowers the
complexity of final assembly.

Signed-off-by: Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>
---
Changelog v2:
- Open code *_offset() to avoid it's internal __va().

 arch/x86/mm/init_64.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index 0e4270e20fad..2d79fc0cf391 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -269,7 +269,10 @@ static p4d_t *fill_p4d(pgd_t *pgd, unsigned long vaddr=
)
 =09if (pgd_none(*pgd)) {
 =09=09p4d_t *p4d =3D (p4d_t *)spp_getpage();
 =09=09pgd_populate(&init_mm, pgd, p4d);
-=09=09if (p4d !=3D p4d_offset(pgd, 0))
+
+=09=09if (__pa(p4d) !=3D (pgtable_l5_enabled() ?
+=09=09=09=09  __pa(pgd) :
+=09=09=09=09  (unsigned long)pgd_val(*pgd) & PTE_PFN_MASK))
 =09=09=09printk(KERN_ERR "PAGETABLE BUG #00! %p <-> %p\n",
 =09=09=09       p4d, p4d_offset(pgd, 0));
 =09}
@@ -281,7 +284,7 @@ static pud_t *fill_pud(p4d_t *p4d, unsigned long vaddr)
 =09if (p4d_none(*p4d)) {
 =09=09pud_t *pud =3D (pud_t *)spp_getpage();
 =09=09p4d_populate(&init_mm, p4d, pud);
-=09=09if (pud !=3D pud_offset(p4d, 0))
+=09=09if (__pa(pud) !=3D (p4d_val(*p4d) & p4d_pfn_mask(*p4d)))
 =09=09=09printk(KERN_ERR "PAGETABLE BUG #01! %p <-> %p\n",
 =09=09=09       pud, pud_offset(p4d, 0));
 =09}
@@ -293,7 +296,7 @@ static pmd_t *fill_pmd(pud_t *pud, unsigned long vaddr)
 =09if (pud_none(*pud)) {
 =09=09pmd_t *pmd =3D (pmd_t *) spp_getpage();
 =09=09pud_populate(&init_mm, pud, pmd);
-=09=09if (pmd !=3D pmd_offset(pud, 0))
+=09=09if (__pa(pmd) !=3D (pud_val(*pud) & pud_pfn_mask(*pud)))
 =09=09=09printk(KERN_ERR "PAGETABLE BUG #02! %p <-> %p\n",
 =09=09=09       pmd, pmd_offset(pud, 0));
 =09}
@@ -305,7 +308,7 @@ static pte_t *fill_pte(pmd_t *pmd, unsigned long vaddr)
 =09if (pmd_none(*pmd)) {
 =09=09pte_t *pte =3D (pte_t *) spp_getpage();
 =09=09pmd_populate_kernel(&init_mm, pmd, pte);
-=09=09if (pte !=3D pte_offset_kernel(pmd, 0))
+=09=09if (__pa(pte) !=3D (pmd_val(*pmd) & pmd_pfn_mask(*pmd)))
 =09=09=09printk(KERN_ERR "PAGETABLE BUG #03!\n");
 =09}
 =09return pte_offset_kernel(pmd, vaddr);
--=20
2.51.0



