Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 49CCAC43458
	for <linux-mm@archiver.kernel.org>; Mon, 13 Jul 2026 16:26:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4B0376B00F0; Mon, 13 Jul 2026 12:26:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 487766B00F4; Mon, 13 Jul 2026 12:26:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3520F6B00F3; Mon, 13 Jul 2026 12:26:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0ACCE6B00BB
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 12:26:11 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 95B361A016C
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 13:57:09 +0000 (UTC)
X-FDA: 84983904978.03.4FCF237
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf12.hostedemail.com (Postfix) with ESMTP id C1CFA4000B
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 13:57:07 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=IT+wndoz;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf12.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783951028;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nrof2z7JTiq9XROF282iFWiammbCWEnvpepqOjnkrTk=;
	b=0rXZftR1S5EOnYZHDqY7QcVwvdyR0UsL+mifa9qcHRcux/LZ9ExgsRaALyxrI/rInSqIzs
	lVDUbfpIYXB+5xMTcjCQcPihOB1p6WiGvs/fSBjsyMP+qZxOhnu3SXTlP2wxTkLx8XDPBs
	wv6j6zXVpJG5DckY3omZM0l/X1m0Bk0=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=IT+wndoz;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf12.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783951028;
	b=WbwL0e+AwU4C/yQ6KID5A9yuSJOBV0cyxsUk1RGtdubs8DN+L56zxVHRXLGoTj/N38MDGl
	eOutBQOk9dXTmaHD4hN3vix1Z1opASVXw1Zy6u/STf2aW+YQjbp/H5H8zZrfHmIV1ZOeIA
	Z3mGznsotrCWBQBZRkSLENG4pe8/ENs=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 94063165C;
	Mon, 13 Jul 2026 06:57:02 -0700 (PDT)
Received: from e129823.cambridge.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 9ACA33F7B4;
	Mon, 13 Jul 2026 06:56:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1783951026; bh=61pfZh3L2BFiEUYO9pwGf4QNoQBqRqpHE9XdwbRRZTI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IT+wndoznhcd9BNCrm+AgnU6xmr98dNBoR+A0JbldC+T/kd+yOTHE0zGhmeE/Ahx9
	 5leuluMVUsbCTPRSRUOYSApj4ZaPZHw/345XsBhpuJa2E68Xb/VtE7kkomxszQ95pm
	 pPIAfSJw3UXhlpSfK2wWgq2ACUJatIHGEhpHr5Q4=
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
Subject: [RFC PATCH 03/34] ARM: mm: remove custom pgdp_get()
Date: Mon, 13 Jul 2026 14:55:42 +0100
Message-ID: <20260713135614.1618183-4-yeoreum.yun@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260713135614.1618183-1-yeoreum.yun@arm.com>
References: <20260713135614.1618183-1-yeoreum.yun@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: C1CFA4000B
X-Stat-Signature: ebxqazmyi89mdc854ytqrk8cf5t83bus
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1783951027-778967
X-HE-Meta: U2FsdGVkX1+iWVyyKBrZtq0zYymf16H0PYvdXkwhQL2w7qvvWhA85ApRVMn/rTarvmnabbDJLqLtg6a4fvQlntLjrr5NW8S6eqUTnO62uxwRCQUiCjrMFjqJMc23t22X116yQvZHaEpjnZo9ChGDJy+Bkgrv5o3GHD03s55KyOpL5XsuwJEYG9fQYTMSr8HN72826p6+lcOSICbG2dF5MdMyorG0TLEJ2XaZ/O9jpGNV7iYY/T8Qs8hV7nqjv16CBRE1m+LzUXXlzekaEQV672zFMbiBb/nVWCsS3+mi3oygiwAcfIWUmlBiBo1J4/x3RrrTuqEd5Kitn7mmemltbDCZP6azAgrstOBNiQooPw97ueNkmzCZ4pHXcaVgxpqaCc8KE0wleRIvN9kaHtdcmH5VwM/XD/yhErOtC7/73IT9MrLfs9XWM107Gs2teEcAeIxUzzSVHrrgqcPi+266sv8U3wLCWkWvqHbbxji8s5B2YIy8wI910LMxdZ0+BWlTn2Nah+CtE7Ep8e09cI8KxznATwekunnutq9NzjIATvw5NF5I7CC+Ua2e2nbDFxL9ROTCrqP1yCuLs6HGs21YqWbaUgo5fXm2e5Ovzz6ekGToPxlK0uxuc0H5l7ex4l9jJY9aetXNFz6Xwg50iV7VvZp1X5Mfj4nmHPx1bYZ/oH26Br7HZ1A/ZFFum8LYdcNJb8HYBD4WgrTqIs/MuHhxQHPBLjgKitUFvUMwHcTQZDsD5/gNn271I7NHrztptKb2Pd+VvpHyCHZrim4n767D9Wfj2Te/d5xRP7BLAiYotYGGWkxewcpDz8vwObvUxhw10VTfVpXkCnKjUVC0HmMpRFM4jI3oe/BIRQMNkCRQ+kzFMTl/+wQ2M1NQNJYl84TNFsRZ/LU2a9kKXXfPVBSoErmpEbUZK7/u7hYcqWyA8rqhbWckEjodjBuKKAl4hHVcvaNAqPBTwmP1954hNHo
 SGjohKgk
 GlayLpum6GZsqk43ID/e61UrvGcH82424ggJjomL1veO89BOPvmPD1wtiPyuTxIMNfyWXFMvPP/tYzw5PLWWEUqv288Vjbvx34YWRfIU3ANAs0RiK40lBLLNktjGZUOxAwZWX3suuyIbcc5RkLOij0M9sui9jxZSnDxH0cqcIgDhEs9kkNB/+zkoBSKWmSHemIlp2/gGTB/ebhU+JV0yx907w9+6K2ba+6dAWaJYubM0BSYlQMocqQQmQWOGlLIYRu3InkCiBvL7bXcPLrTq9klIINRsIiBwWddPDmzv2cZ5q7Tw927lXbzby8Mr+UGSD/SGq4b5ZuioK520QN211dm2lrBl6Yh4Ws+IHv8BChyEeaMwDOZr1Sd/qaLz/B28OVlgy
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "David Hildenbrand (Arm)" <david@kernel.org>

Now that pgd_t is no longer an array, we can just rely on the common
code pgdp_get(), which is a static inline function that returns pgd_t.

Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
---
 arch/arm/include/asm/pgtable.h | 2 --
 1 file changed, 2 deletions(-)

diff --git a/arch/arm/include/asm/pgtable.h b/arch/arm/include/asm/pgtable.h
index 982795cf45637..eadd027fe0ee4 100644
--- a/arch/arm/include/asm/pgtable.h
+++ b/arch/arm/include/asm/pgtable.h
@@ -141,8 +141,6 @@ extern pgprot_t phys_mem_access_prot(struct file *file, unsigned long pfn,
 
 extern pgd_t swapper_pg_dir[PTRS_PER_PGD];
 
-#define pgdp_get(pgpd)		READ_ONCE(*pgdp)
-
 #define pud_page(pud)		pmd_page(__pmd(pud_val(pud)))
 #define pud_write(pud)		pmd_write(__pmd(pud_val(pud)))
 
-- 
LEVI:{C3F47F37-75D8-414A-A8BA-3980EC8A46D7}


