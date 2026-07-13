Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 37709C43458
	for <linux-mm@archiver.kernel.org>; Mon, 13 Jul 2026 16:27:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 193956B0109; Mon, 13 Jul 2026 12:27:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1587F6B010B; Mon, 13 Jul 2026 12:27:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DCE776B010A; Mon, 13 Jul 2026 12:27:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 94A436B0105
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 12:27:41 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 857EB168BB1
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 14:02:35 +0000 (UTC)
X-FDA: 84983918670.27.DE8733E
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf18.hostedemail.com (Postfix) with ESMTP id DD2F41C000F
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 14:02:33 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=kQi5KYkL;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf18.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783951354;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=A7ONkW6MIPHl3djkHN6197TlCJ1WOxcpYlUNKhpTqHA=;
	b=pTH3mIIJZIisuBKEZ3xKwqr/GOhSr13AvBbbP3ox+nfGpoZj/v4PqMMtaslvMJPx5BQE53
	hxvN7yeoFxVsXiIwshe+DowM+nznL2f1ZjtBfNwEDKU1YCJ1Q4gjA5ut+TLiXkvmd4rSoL
	6sX9tdfhWFLNxtQSgQ3gxR6YLqpevsk=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=kQi5KYkL;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf18.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783951354;
	b=ftBRAcUxVF7zrqyCOFxJBW8G3mifmc73H8bEEsW7PLdLD5OEeuT1gNs4Q3QLlHUFhd69nb
	tbKxQGGuH0eYwmy2kR6uTkVcNVbaJin/5Z4LtVrz6gdXnQtPDpB8PzCvhk7GndB33Uxpjh
	4X3inV/MYs5J41t0KSAIVYCYo25DxX8=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D18E822FA;
	Mon, 13 Jul 2026 07:02:28 -0700 (PDT)
Received: from e129823.cambridge.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id DCD6F3F7B4;
	Mon, 13 Jul 2026 07:02:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1783951353; bh=+NT3cTeI21UAw19SApYQa9wvOem7QSZHxFow4rdsqrQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kQi5KYkL3fHUQ5wzM7nbpmj1EtHhLRPjBJnrkYS9Zzqf0kFPLCsSqU6cUypYE4xrs
	 aDmelYX1ib2gx0LZfNu8Ej1VKfxxq7gw6N5EX8GpuqZWWWG/hmARmOMI4JXrGrMdBC
	 xRXONdbm0dRfh+5IGK2weG5JUL+Uqhwoup6EF75g=
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
Subject: [RFC PATCH 29/34] mm/pgtable: disallow calling folded set_pgd/set_p4d/set_pud
Date: Mon, 13 Jul 2026 14:56:08 +0100
Message-ID: <20260713135614.1618183-30-yeoreum.yun@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260713135614.1618183-1-yeoreum.yun@arm.com>
References: <20260713135614.1618183-1-yeoreum.yun@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: d1xytfmbkoerjkr1ehe75tr6dpg8577r
X-Rspamd-Queue-Id: DD2F41C000F
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-HE-Tag: 1783951353-418446
X-HE-Meta: U2FsdGVkX1/V7BDoIfdoYcGPU1MCDLCSmnW6968Mx9WFZeUHlYuqzcxt0OuWg5a9zWnVTwEuGm7p6Wey47ObZN5az8QEGz3imtDRva2gCrZWWdp0bnD47kWJ1/bUQibJgttJUEiVhj2EZKqyDhy6q7Daojt5CwFFqHOLOuKjyEc0Ft2MzSThKypPDnY6gtQJqgknbJBqs5ghgUqcbl7JtLa2lifRvqtuc2k1oVCotixBrs+lHUe4L9GLXGdsUBEblatfXaF4XMRDvbbFglt0ckiYF5Q33569RaIHfYMTMs/Cw9JY08GO7Y/Bt2j8+7DjpcQVYee0+AuuOJIv+ziG+PZ63DGEIr+hvBnkXWQfFottshUND11+jnIhgAMHCWzyh+wItIjFkJT32bgK3xIe6MbOrMNsFx8r2GvXdlp7NngWWI/hRbrtczCsHlHCqyRDULtx7254BK3aJodbmlsh8fgQBqcttz+DCbCI++Ztswcv5KNopWaLK9ccOHRZmP9OntM5VAgyASDScxW1w7VnWmyO1GbiDlJlit/tjHEfs62paQAbGK9wQF/4TZZYVmgYN+mWFE1FZE5NOvXWCfFKRsas1mzPyIu+LMBIzj8/oVIjCSzDyUK3b2bp7eCVm8kueNEeVBu3vYidLbFWoI2J5Qvb+JwYJ2MIxtC29QqsF9Jo9OvvvoQRYwmQpJL4yRVXRAfabbUrEUnwXDhUtDqOs7kAS0dO9H6DczaW6vp7jDl/7oSNqAqlBBoPYM2syXHeWDgyz2HudkfUjTFm3w0ZJ2aMyQhMY4sryJXKm6Df9Fc6OVygsNlRTlS3IN0zk2n5dEgvbKKw9eHkLzCs7+yTmi7MbmSljwDizluunyW/xVJRNuF4zyQsh1CjdoNUIjGh5heGK6tWwxLyv1K9lMwftIYJmgQ/mJ2r/Im+o5Um4K16/LsodDbrQ2Q838nzU8qtet4bXyZ4TVGSIFk6RMn
 NKTvkLAG
 OElKM3lmD5oUoVlXLOm0zCryQutb09Plf4tO3mIKJyeTK81rQDGbAo5bJNHA1z65PeNAycDQpfoDcscBhQjhnbqnc9pmOQ7kjaI1OGn64MUU4d7ApkwdD9nJmhLecGIY8YIenGKY6zPEd9tRQ7eqr6HE908LF7DwCNkIovyxQzJMiNrKw1sfEvaYgyILxZZ9vqvsHkQEt+7CqnXBUPO5XchCTCOjiActuF9KMfcd8PDuLPaAGBhBkSDGzm6RW/8YmhIfjtqjJBNnNbheXlQytSQVHe1ind2zZ5q/1ebLtkGavl1QzFXxiQRW9nymHf1ACjldFV7h+HzUm0WPn/QqTT24e+C1lvwj+ARm7grnssPreoiVp/ZvLQ9tX4yPpVb7yw5ig
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "David Hildenbrand (Arm)" <david@kernel.org>

The stubs are documented to "doesn't get actually called", which was
false for a couple of instances.

The helpers are dangerous, especially with some upcoming changes.

We made all code compile-out any calls to set_pgd/set_p4d/set_pud for
folded page tables. So let's make the compiler complain if these helpers
are abused in wrong context.

Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
---
 include/asm-generic/pgtable-nop4d.h | 7 ++-----
 include/asm-generic/pgtable-nopmd.h | 6 +-----
 include/asm-generic/pgtable-nopud.h | 7 ++-----
 3 files changed, 5 insertions(+), 15 deletions(-)

diff --git a/include/asm-generic/pgtable-nop4d.h b/include/asm-generic/pgtable-nop4d.h
index 019c3f074b771..0f3b56deaa165 100644
--- a/include/asm-generic/pgtable-nop4d.h
+++ b/include/asm-generic/pgtable-nop4d.h
@@ -28,11 +28,8 @@ static inline bool pgd_leaf(pgd_t pgd)		{ return false; }
 
 #define pgd_populate(mm, pgd, p4d)		do { } while (0)
 #define pgd_populate_safe(mm, pgd, p4d)		do { } while (0)
-/*
- * (p4ds are folded into pgds so this doesn't get actually called,
- * but the define is needed for a generic inline function.)
- */
-#define set_pgd(pgdptr, pgdval)	set_p4d((p4d_t *)(pgdptr), (p4d_t) { pgdval })
+
+#define set_pgd(pgdptr, pgdval)			BUILD_BUG()
 
 static inline p4d_t *p4d_offset(pgd_t *pgd, unsigned long address)
 {
diff --git a/include/asm-generic/pgtable-nopmd.h b/include/asm-generic/pgtable-nopmd.h
index ae2eff44889ac..9d854211a55a5 100644
--- a/include/asm-generic/pgtable-nopmd.h
+++ b/include/asm-generic/pgtable-nopmd.h
@@ -38,11 +38,7 @@ static inline void pud_clear(pud_t *pud)	{ }
 
 #define pud_populate(mm, pmd, pte)		do { } while (0)
 
-/*
- * (pmds are folded into puds so this doesn't get actually called,
- * but the define is needed for a generic inline function.)
- */
-#define set_pud(pudptr, pudval)			set_pmd((pmd_t *)(pudptr), (pmd_t) { pudval })
+#define set_pud(pudptr, pudval)			BUILD_BUG()
 
 static inline pmd_t * pmd_offset(pud_t * pud, unsigned long address)
 {
diff --git a/include/asm-generic/pgtable-nopud.h b/include/asm-generic/pgtable-nopud.h
index 5a2b0a81ae197..aa8a6ce139e47 100644
--- a/include/asm-generic/pgtable-nopud.h
+++ b/include/asm-generic/pgtable-nopud.h
@@ -35,11 +35,8 @@ static inline bool p4d_leaf(p4d_t p4d)		{ return false; }
 
 #define p4d_populate(mm, p4d, pud)		do { } while (0)
 #define p4d_populate_safe(mm, p4d, pud)		do { } while (0)
-/*
- * (puds are folded into p4ds so this doesn't get actually called,
- * but the define is needed for a generic inline function.)
- */
-#define set_p4d(p4dptr, p4dval)	set_pud((pud_t *)(p4dptr), (pud_t) { p4dval })
+
+#define set_p4d(p4dptr, p4dval)			BUILD_BUG()
 
 static inline pud_t *pud_offset(p4d_t *p4d, unsigned long address)
 {
-- 
LEVI:{C3F47F37-75D8-414A-A8BA-3980EC8A46D7}


