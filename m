Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1B0F6C44507
	for <linux-mm@archiver.kernel.org>; Mon, 13 Jul 2026 16:29:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3F3CA6B0125; Mon, 13 Jul 2026 12:29:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3A4AB6B0127; Mon, 13 Jul 2026 12:29:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2BB2E6B0126; Mon, 13 Jul 2026 12:29:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E90D86B0123
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 12:29:34 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C858BA019D
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 14:00:55 +0000 (UTC)
X-FDA: 84983914470.10.CA60349
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf31.hostedemail.com (Postfix) with ESMTP id DA40B20007
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 14:00:53 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=WVe8Kgnz;
	spf=pass (imf31.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783951254;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Wej6IEPSrDrt+i6qxhBm98b038EBwA6u88V9iAQiCb4=;
	b=TxRCsN/fYipkoVdBLIP3C41Qtu7lhLC+ujUB1QbaQDRVNrPUB9tKMy+9JlB45a6XeRBokl
	DGdO0PBw5evaZn47w+QUV0qdLbGyOLpZeSTeaLoc32eBefyQH0iLeswJWQFn9R3ntwoDrd
	EsDlTzW73iQAM40Nh5AlLorAzHLWz3Y=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=WVe8Kgnz;
	spf=pass (imf31.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783951254;
	b=DuOVy/Xv1ReBboxybBPG+qiqslg7kCBveP1N/L5dBleo7rLX1WOoJd/p0CIZXLHyMMzagJ
	kfmImR1WpuTo9MAoO7D/j7EVJ5y4uUttoPOpUe7LhDH0clI4kNSSykD0JAjOKWX+8GWEZz
	uq+T+7BaTxgcZuhX4zvyVzIlfA4IhOk=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 971C51FC7;
	Mon, 13 Jul 2026 07:00:48 -0700 (PDT)
Received: from e129823.cambridge.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 7F9D83F7B4;
	Mon, 13 Jul 2026 07:00:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1783951252; bh=zdjn+EW1ROhTZfts/8Ej8q/66MoM0Wrm75ll8cq/xrc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WVe8KgnzPlTqjaFSNOJggiBlZUKA4QzXTglCdSnJ8z0qtfTC+2NauNkQ9xF6xK0T8
	 Q6suiP8pQXc7vC+GC4uQ3umZoj/pzGbV50HTuH8+YBS6SgTUORLDFjNvq2Ef8jXD0U
	 YvN50Q+z9X5WyBym+Du0GGc3K2jSEmPZ/vnr64EM=
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
Subject: [RFC PATCH 21/34] x86: platform: use proper set_pXd() for generic compile-time folded patable in setup_olpc_ofw_pgd()
Date: Mon, 13 Jul 2026 14:56:00 +0100
Message-ID: <20260713135614.1618183-22-yeoreum.yun@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260713135614.1618183-1-yeoreum.yun@arm.com>
References: <20260713135614.1618183-1-yeoreum.yun@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: DA40B20007
X-Stat-Signature: q9rzk7urq7pfr8f9i3nwpc8dj5ad6x3b
X-HE-Tag: 1783951253-228207
X-HE-Meta: U2FsdGVkX18lg31oOZgFu8y4xVQFHTgHQaHf1s4BoVcA08DkFswvohRp9jWVNJF2Tr3pnyF1LKWg/bwaANvPM4FbFDquWtuogxFGvR9+G36Y8VPUHaE4YBprf4DkTGB0NEOnV0wPwUS8dZVbcaY09T6wMG5lpDNNug9mtjjPduyATt3E7xF2cXJfLIDm+ePi1EayDICeFEcDAEjuKRf24kBfQy1PiMIIB3UOC/g5XXzmyUqqtwlogbbDbjnByB+Kdi/mpFJmo0ps46LK8Mpkcc143uLpWZ5jbI/iAeFlGvxz/JOERhk4VzkaEdG0eLd+vOB2ufudoZv2/Y+ciS693OMaVxVAChGrwBn4w0RtSxLtFEFOYDS0SPCacGaxLI+EroNxd4KRTe9xyPecjOe/4Kouv6vnPGvZn3szgABsHre828SSU82Cjd4Ypssa+er8AOsoST+wx0Jn7mTdhIPFVOyW0Um3v5D8ym8J92T2KNyCkdXZ7eiyHDzinmiWwbK78XZmerCIqSbvx2pwGVUIETiGQAxh0yw/oSzsZKoO7r+zR5zxLNfjXCXuKJeZ7g1HExXn/LWSEtnRUarWhXZc5Z4Z9LixhAjMcGDs7dSSdv1TnZVAEb/UgqozVSYO2jkPEtkDmr7PCsVqzm0iGPM3QZRGibycEPfjMgH1Ea7SBWiLEP4Cx/7ZiT2p917VIm4XD9tIB+YfDBMt4Rk244ByasYCAS2MGfXbr6pKn7U8XvY1FZdHzPy3MTmzfa9OaQCPE5wpbA25uRM2NwESogRcc6IsJizTrGYAMihThsQGumby+fgUGBcGqQAKVyIp7O7WbD6mT6q5luVd1dsOXgGIRDsOog1ZcjyshnB/0XXS8ruvufYKCDLEY3jnXNTqSD0Etuzbt7qNBUhlPDxuNUhFsoUVXC6lOVncjTmHpFPrebA96Zre1himefgSqjGwdrMw68jVlpOyyX8QWH/efwr
 Hq/WL4lv
 UiHikhj8HKiiFQ2B1R+flGz8+l2/0rZDEdXP89o8rr1zGSkEnKd+qUL+DpTyVJGYOzWdF8xkGkn+1Y03lDC0rFm+vavUyyfd6uZIgnt2mvyMMREQDOQ/xp4KAjLpqJCqAypneccERuSfcIY7iGMrW8KpV1BHOaE74GeZ/nibnqzwqg1mqA93XPEBTWfglL32R5WyeN+eeHEDIz01UveZna7o57cGNZ53HtLJhWZuc0WP2udZKNNBpRzrqEPLiH4cu9jBipn4E9wD9pUnzWEYJ5UVm2YX+pBBZf5HtVhm7GeYY8+y7hLyjbkUaSK8uq1xDVaEhhRYiRtFF6YjCYmCPUhK5AcyNH2Ojt669+cniKhmL8PA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

We want to rework how set_pXd() behaves for generic compile-time folded
page tables by disallowing its use and triggering a compile-time error
when it is used improperly, ensuring that the actual first-level
set_pXd() function is used instead.

Therefore, replace set_pgd() with set_pmd() when CONFIG_PGTABLE_LEVELS=2.

There should be no functional change.

Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
---
 arch/x86/platform/olpc/olpc_ofw.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/x86/platform/olpc/olpc_ofw.c b/arch/x86/platform/olpc/olpc_ofw.c
index 6bab0f0aa8f3e..d709534d48373 100644
--- a/arch/x86/platform/olpc/olpc_ofw.c
+++ b/arch/x86/platform/olpc/olpc_ofw.c
@@ -25,6 +25,8 @@ void __init setup_olpc_ofw_pgd(void)
 {
 	pgd_t *base, *ofw_pde;
 
+	BUILD_BUG_ON(CONFIG_PGTABLE_LEVELS != 2);
+
 	if (!olpc_ofw_cif)
 		return;
 
@@ -38,7 +40,8 @@ void __init setup_olpc_ofw_pgd(void)
 	ofw_pde = &base[OLPC_OFW_PDE_NR];
 
 	/* install OFW's PDE permanently into the kernel's pgtable */
-	set_pgd(&swapper_pg_dir[OLPC_OFW_PDE_NR], *ofw_pde);
+	set_pmd((pmd_t *)&swapper_pg_dir[OLPC_OFW_PDE_NR],
+		*(pmd_t *)ofw_pde);
 	/* implicit optimization barrier here due to uninline function return */
 
 	early_iounmap(base, sizeof(olpc_ofw_pgd) * PTRS_PER_PGD);
-- 
LEVI:{C3F47F37-75D8-414A-A8BA-3980EC8A46D7}


