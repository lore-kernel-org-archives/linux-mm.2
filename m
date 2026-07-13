Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C6F56C43458
	for <linux-mm@archiver.kernel.org>; Mon, 13 Jul 2026 16:25:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A02EF6B00E5; Mon, 13 Jul 2026 12:24:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9DA3A6B00E6; Mon, 13 Jul 2026 12:24:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 82D4E6B00E7; Mon, 13 Jul 2026 12:24:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5141A6B00E6
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 12:24:42 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 1DD2214017F
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 13:56:57 +0000 (UTC)
X-FDA: 84983904474.06.3F242F8
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf26.hostedemail.com (Postfix) with ESMTP id 3FFE714000C
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 13:56:55 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=FxTyvS8q;
	spf=pass (imf26.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783951015;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NBumCcqkEk1nXALcAuJ8IwdtYImAh6IGMiaTxHR4lpw=;
	b=fd3oOd7VMr6xIXnm0heY9FzdIcujMm8SM0zGSKmsWyY4+pqnkKmkjeTrBja+9+H9O+o0OU
	Psr3MoweIF11xh2Q+40+vmoSSYdWeeNE6yONjuOPI6N7LFYwINP33ERdCefizIUjFIfDL1
	Gc357FwheGyZV8AnJ4AqxBMFMAVXS+w=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=FxTyvS8q;
	spf=pass (imf26.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783951015;
	b=jExG0BRzAThGPWGtWqE7vz9pDXrIkb3q4k4Qa8wVSxwpCdFsmAJbKsDGhANfV6KvEbaC2B
	lY2RQT6xyjIG1s/FgYOLAtUJQRL7465kF/Wx91Or1e9YA01Qgw9KTQyba1+G4sPK68yJqR
	h7apyAfpSXejoClv1Ng+2+Yuk8skTOo=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 076881688;
	Mon, 13 Jul 2026 06:56:50 -0700 (PDT)
Received: from e129823.cambridge.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 142EB3F7B4;
	Mon, 13 Jul 2026 06:56:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1783951014; bh=44z1wBJifkHFimU5xGRNMG/SbMPtbykrozIR+gUI3Nw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FxTyvS8qe2nR1wDA6bZf9hyifEUuooXjQ3QH6FJgDkDMtu51FrZ9fyaVHohjsKzs7
	 JrbpYKfSMFGrWkdX/8WN///JYZVuY1cZWpYJFpKgXYaleaoed56OSowZ2fwKwkw0Qf
	 PHqx6TGBqcJPBCOAmqYNZpK951O2pgmMU5517rI0=
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
Subject: [RFC PATCH 02/34] ARM: mm: make 2-level pgd_t a scalar
Date: Mon, 13 Jul 2026 14:55:41 +0100
Message-ID: <20260713135614.1618183-3-yeoreum.yun@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260713135614.1618183-1-yeoreum.yun@arm.com>
References: <20260713135614.1618183-1-yeoreum.yun@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: xsicncskgsizhz3a5d57suie13fop3yz
X-Rspamd-Queue-Id: 3FFE714000C
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1783951015-524434
X-HE-Meta: U2FsdGVkX18K17sMHKMMPtzjeAeOZqhG2y/mazeGhvMTSG1cnfTAn/+9LFomNHeBrxnU8SWctPdKgxxsxrjhD2e0+N3GjXeWMiofVgcPxV2bc0x7pg4+RdFKeXrHc74DGM2M9zH7E6nUXqtVOTml9guFgOJzlIfExMnDmS7Ktvuq+jbn30OkA7Po8ek+4FtfKJeTzJnbgP7xIHANjZU6yncaAmNRcYlZytYmcVxwn/t+CBR+3FH6LwsTbu4jo07auwiSAgE2xPCFLwegS87aai2Sn7sQ0Bt4t/IVTRJpeot9gamnxCSt+ApQRLVA8LeLexZ+r4ZqJzYBe6k1QS2Oic9V1RYM0dxyq8Bd+8ReYV5y/esXOXPTdyoRzZHMb6oSLHF6r4z2HfxWcsg7vdzCIUBhP9COZA6swefDMOKJeq1dyb5WlXprxwR7qo6NE/JBG+gEki1KgP0RE35QJ9kKuNUNGdCb3MnayZIsdqXFiZOcMsRj3Zzmus6PS+FytkEOe+ahkjeUbDEgCowcaxhFCS+EofqyK0ZENkWt006Kq3UKmziJlbGr8nAqIJthHZ6WuM8Jy6v20XP+TD0xTS5O5TzkFtyOcR79iZubXwognDsy1qZmLntj7xMwyiHZf7C5XkPbqcmVJKdxwO5Zc24ZhGjADvY3mJ875VTlAQbgeT5Zow5eGq3EwTueQMDKtSKQ5wWejI7QTS2h6mj9pmAfFoOJvZO26p8qkatblBj8sHWRB5lxhxAOZoo9ZdDDya0IzhGf+5+XQKUZpBtlVgm9Hx6vlLCg8mpD3BfbvybsNAQORNrxh7R2evfxPAt3HIBOgb5mzyzep075WLR0qIvHB5tNZnFv7TtYBFOKHuER44ugqgI5mFjSwAc3JnjtPohepdH0mRIqL+iZ3WqtVh4dBNy8lZFFDbHu6pzY1TfMf0nmxMWExB2IdBDssBKmDYAr9Kv23LN0lFtxeX7KYx5
 HoWiCkNp
 R/jJF41tEGGZReRjup/+pNJaT/ezFBJAAKMY+Vj2MML4dQYjCcac4lJntOQsuc3Rf0a5OJZXN179kAUIju/ufGkzCIqWGbU4e0QNxcSTyu6AbGzr5lT41PghwNspKhjmZ9l2uNUruvWPWAwnm245prNCsd9NlXV92KwjScnmCSF3U4ShoGush7/YGzUWB8Q0wHwNFNQWZ84ZXwKEVqvY2tCfHJcc60CiflM8d5ZORYqAm/9bHnOMTm+slkFJCnhQFHdzXQGuj5kHEGZx/opQmpkXXbNOQrMtwfJ08IaE/FDTCBpog9nMj5EGFoWIaBGoQDL71SRDVsaV9bzXPYiqLhij7tyRjj6lPjgAAOSwEah733qe541cTF58nEw7Jof/WtL6ZFnHZi4U/0Qk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "David Hildenbrand (Arm)" <david@kernel.org>

We don't want pgd_t to be an array, as it prohibits returning it from a
function, like pgdp_get().

So let's just use an u64, and extract the right 32bit value in
pgd_val().

Leave the STRICT_MM_TYPECHECKS case alone for now.

As an alternative, we could use the STRICT_MM_TYPECHECKS approach here
as well, but using an u64 looks conceptually cleaner, even though
pgd_val() gets a bit more involved.

Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
---
 arch/arm/include/asm/pgtable-2level-types.h | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/arch/arm/include/asm/pgtable-2level-types.h b/arch/arm/include/asm/pgtable-2level-types.h
index 650e793f41429..02052cef9437a 100644
--- a/arch/arm/include/asm/pgtable-2level-types.h
+++ b/arch/arm/include/asm/pgtable-2level-types.h
@@ -25,7 +25,7 @@ typedef struct { pteval_t pgprot; } pgprot_t;
 
 #define pte_val(x)      ((x).pte)
 #define pmd_val(x)      ((x).pmd)
-#define pgd_val(x)	((x).pgd[0])
+#define pgd_val(x)      ((x).pgd[0])
 #define pgprot_val(x)   ((x).pgprot)
 
 #define __pte(x)        ((pte_t) { (x) } )
@@ -36,14 +36,21 @@ typedef struct { pteval_t pgprot; } pgprot_t;
 /*
  * .. while these make it easier on the compiler
  */
+typedef u64 pgdval_t;
+
 typedef pteval_t pte_t;
 typedef pmdval_t pmd_t;
-typedef pmdval_t pgd_t[2];
+typedef pgdval_t pgd_t;
 typedef pteval_t pgprot_t;
 
 #define pte_val(x)      (x)
 #define pmd_val(x)      (x)
-#define pgd_val(x)	((x)[0])
+
+static inline pmdval_t pgd_val(pgd_t pgd)
+{
+	return (*(pmdval_t (*)[2])&pgd)[0];
+}
+
 #define pgprot_val(x)   (x)
 
 #define __pte(x)        (x)
-- 
LEVI:{C3F47F37-75D8-414A-A8BA-3980EC8A46D7}


