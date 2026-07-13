Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3A175C43458
	for <linux-mm@archiver.kernel.org>; Mon, 13 Jul 2026 16:27:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E9E796B010C; Mon, 13 Jul 2026 12:27:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E27396B0109; Mon, 13 Jul 2026 12:27:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CA05C6B010C; Mon, 13 Jul 2026 12:27:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 96BD26B0109
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 12:27:41 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 77BFD168BFF
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 14:02:10 +0000 (UTC)
X-FDA: 84983917620.03.4324D66
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf04.hostedemail.com (Postfix) with ESMTP id CE5C24001E
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 14:02:08 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=ASMMRSEE;
	spf=pass (imf04.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783951329;
	b=w/RRyih1M8T+XOOqiWtl74WySrZYeGLNOT+/eCiYvC5xD6H2TM+BBnVqZ/7YVinMZ0k+2q
	/jlBO8ytGILS8jLN9NelcNn6UFs2bORt7hNhLSlwAfPFUaA9AXnVXzHl10hwljcxt+A916
	biw1zqjWeeKkUrikPywFJNaOgHVx1q8=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=ASMMRSEE;
	spf=pass (imf04.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783951328;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+RCDGrorkyNOOuJOjX5fZBtuLdr9gFJ37Diu3XLCTDo=;
	b=R+nT+0hDzMAvITfnCXZOBXMNzhzc7Tm3wXWXavSGCbOJIc9bQUWWKDSP8PFV1TldD3Xgsy
	FFH82kGOPSDkb4Y2lVsO2N+3KVDqEN5t9deWXL1hC2xoKP3rnR4PTXfTIdFzrDp7wnFZx4
	1Xi0qXA0ANiIo9sfrM9wXOm+uSM4F0I=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B917F2050;
	Mon, 13 Jul 2026 07:02:03 -0700 (PDT)
Received: from e129823.cambridge.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id CA4093F7B4;
	Mon, 13 Jul 2026 07:01:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1783951328; bh=ROB8+gk0/dcoXkR4gcvO5thlCnhrFywn7RQWaf7FRNk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ASMMRSEElZbqH3kcSv3cgBHwRCD0y7h1wgH3UWFgn/baB5FeIwo7Xk+LbUkFullBo
	 ek3GdG2jwdbkGcS6tjY0I29itz5ZOSbh5hHu9lh1E6V9LwiKw1W6kVKW+GJRoc6YC2
	 dPS2W1hLic9wNvgpjDdvMv047vveZPnluRUq3ZWI=
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
Subject: [RFC PATCH 27/34] m68k: mm: remove usage of pgd_page_vaddr() for CONFIG_PGTABLE_LEVELS=3
Date: Mon, 13 Jul 2026 14:56:06 +0100
Message-ID: <20260713135614.1618183-28-yeoreum.yun@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260713135614.1618183-1-yeoreum.yun@arm.com>
References: <20260713135614.1618183-1-yeoreum.yun@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: CE5C24001E
X-Stat-Signature: areaz3jaotyxao8qtjfyfkk5hxnnaypw
X-HE-Tag: 1783951328-534181
X-HE-Meta: U2FsdGVkX191w37APmIyIQKbxddp1IDrR3VuPokDc1gRPKpZTPsLb3sDD3H5EkOSDhTE+cAzGx6FBoTOjyKnmrNeDZRaz8XNCWD+E+sw9kopRSlh2yEpdwDQgorzkZb/TJNz7R+TyVz4BE4PN4wt6M2FRsNNcvMtD+G+vRsVwYWixHLdphvmETXSFwZyvZltnR9nYZXk94fUINvT6+ObWXbqSIBT8bhXNIBOfkCd2+b4xf69QwYayuU8NhAcg0vhdbnMKQjN1+Vf7L5pqo75P8ViGQIje4GnEIpMFVP73VdR2ZcotR/LpmR5+tyHaDBJukymDns93a4g+ni2Dx/Zq1b+2GDJ89MwgMDt6qIXQsjtIUmof5SV1SKsaI8sSI7gPeUPmXgtM0vFFw6gdm1+j3CfQ2D74otIKw0YigY7/enmE4YbSPVcbJlojpT0M39zD/hOtyvBZ2TFW0AtqkHsWGoJi8tofruLX9Axbe9XiZAuQY6QWbTz0eSWSuYsWdg3Kq58yM2ImxNyjFj+keeb6qt2OZB71yvbWgtwETzvODnA+GeToaJJzDWlniWVBc2BmBul+4EDwKEwA/jwj4PJ6aUoYZatEC9c814WmwpbZISIlyJF4zW2atoDlYOlZxpNzDciekpvkyHONzg/mQESn5+4L0kxTI94I9DYZjOfYmPb4E8MrBHd5TDw+lC6cZdC5AQJov/amJDOIDmb9ToQYMpNQAMRgxh7W1//oW6j2DWWkllo6ABorCZFzY444J3xS7rRA6bdQJc4q+KHhTQXVFOFbu6UaNStFr1cG1WPwVyPbZAB3xudtBqDSZZpzyRx5itU8suF9B3uTqzWKbtG8nUxPRSRvkvoqTayvMGq05qfmMWa5x2EIvjFoSDA6gJe8GvyDWKJ3d+7cfQQ+YAwL7dFeoj27kM91zkxhpfotqQ+aAXzjE+fvK+ERQINcfnbJX+CJMbxrlE4riotDhw
 Qp7NXuBy
 ZlXshuSO5pLvNFqHxE/+S2Tm8G6iZfSdjYhLFMAWUle5wNKWOob9NjslqJ2QXPDYX1jpkwyATWW8eAMHHli9YV12JFFw/dfc5LAFmQIeccoGC7I8puXZp+Hb27AxH8NSIgAbt5kUXA54P20G30hz3NfpBFvnMR+vvGMDOcsEwC0hGqMe+6yDj6crHj09GtSNKXTfaoOhFQFrq0lLkNneyrZBDt++F/LomF8L+75aXQ32Q74qIPdu/zXpMY6zxDqLVuhzA4XCMconLDkFKrjgmmL1v5mEd7N7dNlfK1SPbq+avbspckkgWY1UoIldp9qPiSdnwMwUTpr6/0lPR2UwOAQOMvgJ+BGAmWJ9G/2R7U8q/WNw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

We want to rework how pgd_page_vaddr() behaves for generic compile-time
folded page tables by disallowing its use and triggering a compile-time
error when it is used improperly, ensuring that the actual first-level
pXd_pgtable() function is used instead.

For this, change usage of pgd_page_vaddr() to pud_pgtable() for
the functions used when PGTABLE_LEVELS=3.

There should be no functional change.

Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
---
 arch/m68k/mm/init.c     | 2 +-
 arch/m68k/mm/motorola.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/m68k/mm/init.c b/arch/m68k/mm/init.c
index 3b88c0dd1616d..d8351c210f58d 100644
--- a/arch/m68k/mm/init.c
+++ b/arch/m68k/mm/init.c
@@ -95,7 +95,7 @@ static inline void init_pointer_tables(void)
 		if (!pud_present(*pud))
 			continue;
 
-		pmd_dir = (pmd_t *)pgd_page_vaddr(kernel_pg_dir[i]);
+		pmd_dir = pud_pgtable(*pud);
 		init_pointer_table(pmd_dir, TABLE_PMD);
 
 		for (j = 0; j < PTRS_PER_PMD; j++) {
diff --git a/arch/m68k/mm/motorola.c b/arch/m68k/mm/motorola.c
index b30aa69a73a6a..03235d0618ef0 100644
--- a/arch/m68k/mm/motorola.c
+++ b/arch/m68k/mm/motorola.c
@@ -273,7 +273,7 @@ static pmd_t * __init kernel_ptr_table(void)
 
 			if (!pud_present(*pud))
 				continue;
-			pmd = pgd_page_vaddr(kernel_pg_dir[i]);
+			pmd = (unsigned long)pud_pgtable(*pud);
 			if (pmd > last)
 				last = pmd;
 		}
-- 
LEVI:{C3F47F37-75D8-414A-A8BA-3980EC8A46D7}


