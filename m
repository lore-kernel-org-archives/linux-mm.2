Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D8442C43458
	for <linux-mm@archiver.kernel.org>; Mon, 13 Jul 2026 16:24:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F33F46B00DE; Mon, 13 Jul 2026 12:24:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EE4566B00DF; Mon, 13 Jul 2026 12:24:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DAD546B00E1; Mon, 13 Jul 2026 12:24:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B44196B00DE
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 12:24:34 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C1A8FA0181
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 13:56:44 +0000 (UTC)
X-FDA: 84983903928.13.2430684
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf22.hostedemail.com (Postfix) with ESMTP id D2E4BC0002
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 13:56:42 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=NtKweSPB;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf22.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783951003;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Qz+pbAUHTE5qkzjllCGGQn3S8bfWwsMlfKBN2epVohk=;
	b=zbj91d5SQ8Ukq8M2yyKOgjFK+bg9CZrAtNxii8Ua/N/NPiIl92p6TgcoE3yCX1EfXJKQC3
	HPFsl71VLRE/xrgaC5mDy0pIv5HahcXyYMU+R0IgMStLdHzBT1cSvWHp2HQ2nVQyGHoqRi
	2ierdW9AJlwi9gllibb5SxMJ6SQxvNQ=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=NtKweSPB;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf22.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783951003;
	b=j+cdoWrf0WAgiHN6jhRShQ/91bn+0JJk7gAi9irSusU68fABkzNsrmsGqs+HEn4p8UVd1x
	lP+37pCUGP3UuZp2QjN6QNTHC1R0Mpv6mZWaOzW5I3v5w0FEKVXK9/pGsfGx+Niw2HSjVY
	l1uBUftQ+UlWcarEsjyyw9Jmy/78a0g=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 748D31595;
	Mon, 13 Jul 2026 06:56:37 -0700 (PDT)
Received: from e129823.cambridge.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 821263F7B4;
	Mon, 13 Jul 2026 06:56:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1783951001; bh=fhtk2Xbf5M20Fxp59EylK3EnVtDC1Q/eeV1ASjlJfRc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NtKweSPBJrXSpruqKL8D3x+JeiFzhsYRAqoppMDvPH1+z+gBaMYJrhxqE2/Axq7Hj
	 B2j/+nweOkOaE5PxSeWVRUeh4V8VRfIU8trmx3TCZAiPfWyIc/PW5GR+ysVbs5MA5r
	 LFYf1KUJXku0EHVhXV74N8EhZamEA79TBKfQ11+4=
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
Subject: [RFC PATCH 01/34] ARM: mm: make nommu pgd_t a scalar
Date: Mon, 13 Jul 2026 14:55:40 +0100
Message-ID: <20260713135614.1618183-2-yeoreum.yun@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260713135614.1618183-1-yeoreum.yun@arm.com>
References: <20260713135614.1618183-1-yeoreum.yun@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: D2E4BC0002
X-Stat-Signature: rrotnc5ujgnqkfmjm11b14yc8gxmodgz
X-Rspam-User: 
X-HE-Tag: 1783951002-921819
X-HE-Meta: U2FsdGVkX1/xcCxPdcQswcS2A7oJ3/pcVHrQF6Sl1nH3onDcidEyBcVh2g7jbLIMBvS3oEafBPW4vSQ+o10sejzIgfqbzNoAJnMDygc2+H/kVRsMSNUhUxgkUdU5J3Dpz/8X4Aia0osNER1CTJZG+cCw+TYuVEIeLk82WiW3Gxt78YOrEHIhhzgZ/RUiR+fGLsWn9ukIQhqqf5nbYOjgxTVs1pKAzOS8wwZmTIpCfOsVXZPldBqLlykomizBeTTN+EGYImleXXyBEX9wVRv8oldxCTOKuOP3wMooB27LPbbYbkccA+ruQipg66jz6swPswQF0f2IteOqwUDpFqjuNWimI2af7s3fugZ99uO6h3lA+qcRLFbGQyOQedwqqzOUbhTKF0PV49Ri49e3hKd72zEyVws0HqmMCDzRx3JRFj4YSEKcE92n40DivHFxg5HCW/yyAutVPYPHOIsriWMvvGuLcc77B3SMXq4tXnv/1G/Rp9baw/84nKGye2sVpcdBvqV5cxDpeZe8HC1jWz3bRHGiWsTumjB5ygYUvw1dw4L6kfsAK95Hu0IIjIOZsP+2U+jdRgwyjkuBjkNRwDvvEqmiywQfTE4Ojr5vemD1YpzHkbPukHwN1Q1gV+7SwA8zA/chqoWsLBcA4r8cQda2MpYB13gHk9J7+ee23pYlgW9XT3FvXGLh3H34qlbW7gKRlyXQxGhi5p+ntSkoTTESp4F2QY7CsIwilHVaywt96IwmlL0wZBq9pTVOdB3DLQtbFG184oFZzuRilJSMQ8AGR5GeJWQqmNH3fIO6pd+4zQY6OM6NOjQOo34e8kploGj3647p2Ciqu1ib+tS/4TAlGe25F2OCqJH/VIk8RdE55LTDPWvkmxWV+gQ+AmzeaZSQ4CCKFxlPLoMa8dgijgmz2KnJdRyaHRmSj//ifeeY6LKUZzV7K1jjawiKirjnOf+vJ+IWp3If2zpaLw+DwsW
 k5655x6V
 NypmjfGZKq1Fmj6aho2iXOXD7wqBTt7Dj2t7iko4b4TZxRUo5+Rv9OFUplY7JBLozotes3Gl6Z+YZhU+OhRi6pqWA2r9FtzmmqsPvTNtmw7+RIiJokPUW2K6ufduYBFVkKnpWsel3jG7nAR8fTlg+XCOBobtcohSwjNqOFrH4kc2eAZhs1ByFfb6TUGZUdClnbEDNHJdA2aH96Vlt5hxyxnILmuRSFx0WZt1FDCwy7iSd29sgZChsYOXwRRQXmtqTLdj9MlCR828beOxsEM3PZah7e+HqoD0Br8DoQGSRKlQmJGpA4054utCjCmvuIIErqnKc7L1ZQUX76WUbHeZ2BGw1knrm8YBSN5Q7pwPtAD/1tkqtvLwZntFVCpUP0hyC+M3Z
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "David Hildenbrand (Arm)" <david@kernel.org>

We don't want pgd_t to be an array, as it prohibits returning it from a
function, like ptep_get().

There is no need to match the actual arm page tables, because with nommu
there are no page tables. It's all just in place to make the compiler
happy. Making it a scalar will make the compiler happy.

So let's just use an u32.

Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
---
 arch/arm/include/asm/page-nommu.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/include/asm/page-nommu.h b/arch/arm/include/asm/page-nommu.h
index e74415c959bea..88659b38e2364 100644
--- a/arch/arm/include/asm/page-nommu.h
+++ b/arch/arm/include/asm/page-nommu.h
@@ -18,12 +18,12 @@
  */
 typedef unsigned long pte_t;
 typedef unsigned long pmd_t;
-typedef unsigned long pgd_t[2];
+typedef unsigned long pgd_t;
 typedef unsigned long pgprot_t;
 
 #define pte_val(x)      (x)
 #define pmd_val(x)      (x)
-#define pgd_val(x)	((x)[0])
+#define pgd_val(x)      (x)
 #define pgprot_val(x)   (x)
 
 #define __pte(x)        (x)
-- 
LEVI:{C3F47F37-75D8-414A-A8BA-3980EC8A46D7}


