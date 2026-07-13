Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 57451C43458
	for <linux-mm@archiver.kernel.org>; Mon, 13 Jul 2026 16:28:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3064D6B0111; Mon, 13 Jul 2026 12:28:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2B7976B0113; Mon, 13 Jul 2026 12:28:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1584A6B0112; Mon, 13 Jul 2026 12:28:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D90F46B0110
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 12:28:06 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id BED88C019A
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 14:00:18 +0000 (UTC)
X-FDA: 84983912916.06.A3F31A4
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf16.hostedemail.com (Postfix) with ESMTP id DE40D18000C
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 14:00:16 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=f7EldcMF;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf16.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783951217;
	b=2y5xe6HPLys36x5csfsBuP+B3PfdKdwXXzYv9cLI558WYKa5yQDrNv9212UuoYEUuwtkky
	Vok81MvYywYzavXefLiWyn56s5Mg/zu2GzaCOEX5yzmH92+4RbfsgM+Dywt1fXVqad5jom
	Lo8tgIkvkf1507/bN7kudQA0RzdXYv0=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=f7EldcMF;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf16.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783951217;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TXvdvZ2eLoaZIoXA5oMVYOLwDSTuaBij3FbMTbYWE/s=;
	b=KSWJ3kDP8mV1FPcV5gcxshYt62UIFnOkihHBHGVYklx1zaveaDZuzxmMsreBq9uvXZeUb1
	0BT/uVHFcM1uMpIIyIZhU2xTjMkPLQA8/oa2UmOMHqHOZzSQGWIAJyBTKRB9wBUqAsfrEy
	N04xfhpo9cavOFsL1Y8Cis93/E1bfcI=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C824B202C;
	Mon, 13 Jul 2026 07:00:10 -0700 (PDT)
Received: from e129823.cambridge.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id CD5DA3F7B4;
	Mon, 13 Jul 2026 07:00:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1783951215; bh=Paq3n4cO8HdYy4FFfkUp6FGCvWu1boCvdBHEQkzpEzo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f7EldcMFAotp2m+ZhFGMuVYzDzUE1W3xYD2M61Z32+4Lp6LM2uG0bFpTaMxAUabky
	 GXRnAFeDJZQABUA65JAt+2/I+UMycHxGaMD0oKMyNfBY1Wx5aC0cEO7Fj/aGoXMZAY
	 tYNv5K6voYS794ZDDPyqysxYS3g7IcY1aTIJ4qUY=
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
Subject: [RFC PATCH 18/34] riscv: mm: use proper set_pXd() for generic compile-time folded patable in setup_vm_final()
Date: Mon, 13 Jul 2026 14:55:57 +0100
Message-ID: <20260713135614.1618183-19-yeoreum.yun@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260713135614.1618183-1-yeoreum.yun@arm.com>
References: <20260713135614.1618183-1-yeoreum.yun@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: DE40D18000C
X-Rspam-User: 
X-Stat-Signature: 9t9zbes7a67zwdcrq1ofp7os4fdu3pkd
X-Rspamd-Server: rspam03
X-HE-Tag: 1783951216-966948
X-HE-Meta: U2FsdGVkX1/q5XtHo8M7KFSrTOcff+Z29EmyojC5Opgl/RjcoRwK2iClffjWxZ7jextjowqiWosWbXq9KvsgbN+hJwbXJqgGbFJ/nT3PTo72gu2Jh0bY9bIlIfhRz25VO/MVUjC6ztSet668Affy665m9NIbh1PAUjRA9wzSKbcl49Ky/OpDVvr8NmHEVo75EqM9F9m3al2ZJDOoCgJSwJ1Lc2ziTUW5FTxvfxLfJzq/MFd9HchLGWTOE0VZnH4U7sT5RHW2/Ym1zgDA/IhCrEiuwIr5NACebAUW9f8TPTp7OPBaDNf/vxXA1TqpdQaw3nWFLpkcSJdcoqEckIVPm8uTWLnCdEPmTLII+cf+tGB/qN4Kg+oRxhRGVp7zlaVKn35zsl0p0CfFqB12Yh6PYFnNMY87Vtocevuq1yexzsGCknuWuMIqR3R0vdREuqKhfrgH/+R3vR2TkePFymBiPf9T0p9dQqq0tZeQx/RfPThb5mbDcV2WHY1mEoVuITPYgov3xjtpu8TrX34XglPFjVPSAYzt4Se5N0zpNwL11v2fHkduwgRV3K2HXMWTt2+jZzRbRVj3k2FhshF42wkgQ/lyhtv7bPOel+X9h7c7UH4Lgc7hGCYEmBrnsI0I2NSpGCYhyazgaDfQRH5y+SN1Rw41FJcmmabj+oib49I6yCOwCTVMQ1myO7IdOVOv0WYEmscWszvleKhmV4+WVsYWCJMYOhy9x42bDoxQ1EJVu4FCqXavFvM84js3UUGgwrL7LknbLr5P0/Gh92tDYl0wUIhJIp/N+k5laCQttU227Zye1GwRJyLacJJNvWRYBVnvkWEi1yDMDjBH2GN/UvCSLiFmC8hsRv4TSaSMRTX/SelOa3qNs5TDztG+XbHqJ9jHPqbZ2eFXADQecTwWK6LuOm+LtfPMmJ5T3gd4c59CBRJU5sni8iNWG7FimHMTPIGo1CMsXee1+5RcI9BMbc3
 kTokbObr
 edKHEtNwsrCy4OoQK2+x+2/uIbqJ5zDnRP6FO7ycZ3z3LtJMA5f6cyAfpzdnJvXyQj1uAimT/aTob8eSyPEJkGs9ftyqbxpZzL2dq2jG94YnrRNcRAegLepUR/ECpGEXo+sny1vuKmqQcXOPkTmAW9eTzWoPkOAnnIMzfi/m6YBQh/D8cGNAzA6D23Ltn5KelhO7Br1NsnkJzxCqb6pAvELrAMEZlIEzV1SeIYCYjLYTvc/rpVjCYnbFrVADR1XmN/Aci/7CV9aTjAWP8IeiHwbMr0Bpwx9UnKrPhqPvfESDoCa5VkEmufQbXKEMe9UDSyaMgMKQcmBSb9tk6i6eC6FLeksSMDCLw740R3P2xdLclcmk=
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

Therefore, replace set_pgd() with set_pmd() to setup swapper_pg_dir
in setup_vm_final() since PGTABLE_LEVELS is always 2 in CONFIG_32BIT.

There should be no functional change.

Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
---
 arch/riscv/mm/init.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/arch/riscv/mm/init.c b/arch/riscv/mm/init.c
index 5b1b3c88b4d13..78017edf7c343 100644
--- a/arch/riscv/mm/init.c
+++ b/arch/riscv/mm/init.c
@@ -1264,7 +1264,12 @@ static void __init setup_vm_final(void)
 	 */
 	unsigned long idx = pgd_index(__fix_to_virt(FIX_FDT));
 
-	set_pgd(&swapper_pg_dir[idx], early_pg_dir[idx]);
+	BUILD_BUG_ON (CONFIG_PGTABLE_LEVELS != 2);
+
+	pmd_t *pmdp_s = (void *)&swapper_pg_dir[idx];
+	pmd_t *pmdp = (void *)&early_pg_dir[idx];
+
+	set_pmd(pmdp_s, pmdp_get(pmdp));
 #endif
 	create_pgd_mapping(swapper_pg_dir, FIXADDR_START,
 			   __pa_symbol(fixmap_pgd_next),
-- 
LEVI:{C3F47F37-75D8-414A-A8BA-3980EC8A46D7}


