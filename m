Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EA44AC43458
	for <linux-mm@archiver.kernel.org>; Mon, 13 Jul 2026 16:25:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 242506B00EC; Mon, 13 Jul 2026 12:25:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1C6316B00F1; Mon, 13 Jul 2026 12:25:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 019386B00EF; Mon, 13 Jul 2026 12:25:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C72D16B00EC
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 12:25:43 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 0E7381C7F74
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 13:57:48 +0000 (UTC)
X-FDA: 84983906616.18.B1F631E
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf14.hostedemail.com (Postfix) with ESMTP id 58464100003
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 13:57:46 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=J5MkpaCa;
	spf=pass (imf14.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783951066;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NH3NJXVcYB/WleHYcgDXFRAEi8/G4vFeJM6falZVP1Y=;
	b=KoEJG9ZsWYH9DLp9TozzsJttXbJgoOoaWbVbga0Me3r8Ar/a7Wyu99XeIl74FH4m8Ojq7T
	QpKXufh7Lk7p9ON4+X4eFLpxyfW3+KUK5M/9NgLLDOJXwnHuUI/QNjBlVj7y2jR0Ig3FRx
	g3mfs/IGija1+Cow9xA2jlJxH8v9JlM=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=J5MkpaCa;
	spf=pass (imf14.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783951066;
	b=m0bz/LRsGIFiUgDF+PCeS974uOoGeHCBx/mbF2+rl3LQRXkQ/0mW1WmFZ0me/n2RY6fFVY
	+KX/gcKTg5mfc0imWJn2Sq1yJL1Qz069Zu6raspZhKmx5/G0fArntqRGxku8ZrrMm5N3QO
	cp2xJ2HnP1kyJX1uzz/lnjfE2+5wusE=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3AEAC19F6;
	Mon, 13 Jul 2026 06:57:40 -0700 (PDT)
Received: from e129823.cambridge.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 4970C3F7B4;
	Mon, 13 Jul 2026 06:57:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1783951064; bh=+wlkvTnUhNj5X+Jcus2Dg3eJDK2S2S29W5HpBiFUdRY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J5MkpaCaSv3kFtqaQdEe0MdW+p2gEX5+XB6f8GLT2O9yjzlcPk5t+tUUhBCiT83/h
	 acN+MOOvsX6N5cQ1AzaIvPrte5DvovLtAlnQBbqqmWwiamEimxB/2A3wgvvQ8JWF4k
	 8VfOKrj6G8/0Ii6qdT8ATQ/tvsryMfs1XmyXthBk=
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
Subject: [RFC PATCH 06/34] mm/pgtable: define (pgd|p4d|pud)_leaf() for folded page tables
Date: Mon, 13 Jul 2026 14:55:45 +0100
Message-ID: <20260713135614.1618183-7-yeoreum.yun@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260713135614.1618183-1-yeoreum.yun@arm.com>
References: <20260713135614.1618183-1-yeoreum.yun@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 58464100003
X-Stat-Signature: fdtuno6gxiprebom8kgoefo15sbpd656
X-HE-Tag: 1783951066-107969
X-HE-Meta: U2FsdGVkX19zrqHauL4r1TuKjIprLY/qYPXCLHvSg6sJbwe0taeldBnbyhZj7DsMcHy2nzQl4PborVngGof5JzXyGgkLcj6uTzXHS+5R9N2r4BIIshhhNyJAjuaUB7GVcHIwgxKVkH3G1hyyyZyu1khq5C3pgZjIQHnqSiIkrPaaZESIkaF/iWKWShIFjyO62/Hqb6VhQmlNzlntMAToKcB3hlQgYcm0h2rTpjo9g26WbCxHA9DOSY3GL2vKJFPmhBil8pOG9tfFRND5evaOtyZEJ5fxhXRjgv7GWLVfcCIpxl2bSQi8oqa2G1BIXW4Y2qgk3Bv+D431cmEoqLSOKq4Tn3U6Fifl5FtHudPnF3eiKRf2oUUua1uarbe129l/hjm9WHjxzw13B46WAZQcRqvEfXkspN3QCiovoHe8x12+S8Z2Row5/BLuFRBePXxeHtdEmcEq5E3p0kTEO4RQHNAm6O4sXwoGSJ4o//puVZAnaTDPssEqZpAGMCUrTfNDUgtK0lpDK1Zu1QUwtchbNBixfKcf9tqClDsNtdyiiwRakZz7h7UO5Eupajl5bxqzadWA+UaH7+ZNGukcnBRouY+EJlKCs7lC3bf2QWDTnwjbaPYRFWnZfYVsx84FmmEiLChwMPIkEImZDQgoi//LIQE0oDidaIlpMfDUJGUXj/qXC1xNItqOdmKitER32XfTMj5E8cMAtLiG/Mqi5+758Sk7MZ+y/tjA+VL+MJVIa2lFPmz7qjBXJVeEDFNydrUXhPiziTpsstXmDuF/E1H7/VFVdDF0R6jkpm0UPJQ3HAb2SKI8fi4Y7MBLWX8jgknZxxB24k7rebvWAAqRe9JlfQ+xUXNrZRz5hw7gsJRPe5v0MKjF0Pa23jzc4qaEsycYZrqsEmWHQOzHb9lELOSUh7wDKs2dNGeuYh0B5B8mkts1BNQ5FXa6UNFTinM6Y2epRjHywGtpzVF1NIeU71I
 UkdQ4PZm
 wz3e+zyTD2sTd0WtqgFrB4S9W3R9vbw/1EsRjnFqwZmMmUOFWX2Yodalj+IPVJi6kfihKNIusaskxDq8Eq30esc3RfSR5ioUd32SKvDK9bgMp0x0WUkoLwKtIIJKhcwDkRvm5TPit4pHPXUAFINi3CQCLhLh4OVl9p4UEzHMMDAFlL32iZMjQOSYSMcE2MsIQqZ/dkBj1cBeLLXpHPAZD6LiGtVWcVAC2vdirPDJzoe7yxs2DgGJQQUjF++Vn4fTsLa+xHuA3TJttNumVxF5MhqndqdWuXc7afBO4fZK12utHdBZ7omhrdy7cHDDi4lmZqCzv252e4c/vixSiu1OB96Oyueqgu0Rb1dh/PJJVl0svkj2OpioBOJZbrViZT4GxdF7Ixhzem0C1s2k=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "David Hildenbrand (Arm)" <david@kernel.org>

Let's define (pgd|p4d|pud)_leaf(), hard-coding it to "false". Note
that we missed to define pud_leaf() before, allowing architectures to
unknowingly overwrite it.

Still use static inline functions (type checking), and while at it, just
use "bool" as a return value.

We can now drop the arm64 custom variant that did that. As it documents:

	Note: reusing the original pointer means that we may
	dereference the same (live) page-table entry multiple times.
	This is safe because it is still only loaded once in the
	context of each level and the CPU guarantees same-address
	read-after-read ordering.

We now have the same situation. Don't document that, as we will be
removing the double read next.

Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
---
 arch/arm64/include/asm/pgtable.h    | 23 -----------------------
 include/asm-generic/pgtable-nop4d.h |  2 ++
 include/asm-generic/pgtable-nopmd.h |  3 ++-
 include/asm-generic/pgtable-nopud.h |  2 ++
 4 files changed, 6 insertions(+), 24 deletions(-)

diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
index a2681d7553584..6185fc291fd7d 100644
--- a/arch/arm64/include/asm/pgtable.h
+++ b/arch/arm64/include/asm/pgtable.h
@@ -1188,29 +1188,6 @@ static inline bool pgtable_l5_enabled(void) { return false; }
 #define p4d_clear_fixmap()
 
 #define p4d_offset_kimg(dir,addr)	((p4d_t *)dir)
-
-static inline
-p4d_t *p4d_offset_lockless_folded(pgd_t *pgdp, pgd_t pgd, unsigned long addr)
-{
-	/*
-	 * With runtime folding of the pud, pud_offset_lockless() passes
-	 * the 'pgd_t *' we return here to p4d_to_folded_pud(), which
-	 * will offset the pointer assuming that it points into
-	 * a page-table page. However, the fast GUP path passes us a
-	 * pgd_t allocated on the stack and so we must use the original
-	 * pointer in 'pgdp' to construct the p4d pointer instead of
-	 * using the generic p4d_offset_lockless() implementation.
-	 *
-	 * Note: reusing the original pointer means that we may
-	 * dereference the same (live) page-table entry multiple times.
-	 * This is safe because it is still only loaded once in the
-	 * context of each level and the CPU guarantees same-address
-	 * read-after-read ordering.
-	 */
-	return p4d_offset(pgdp, addr);
-}
-#define p4d_offset_lockless p4d_offset_lockless_folded
-
 #endif  /* CONFIG_PGTABLE_LEVELS > 4 */
 
 #define pgd_ERROR(e)	\
diff --git a/include/asm-generic/pgtable-nop4d.h b/include/asm-generic/pgtable-nop4d.h
index 89c21f84cffbe..c6a5a43899b50 100644
--- a/include/asm-generic/pgtable-nop4d.h
+++ b/include/asm-generic/pgtable-nop4d.h
@@ -22,6 +22,8 @@ static inline int pgd_none(pgd_t pgd)		{ return 0; }
 static inline int pgd_bad(pgd_t pgd)		{ return 0; }
 static inline int pgd_present(pgd_t pgd)	{ return 1; }
 static inline void pgd_clear(pgd_t *pgd)	{ }
+static inline bool pgd_leaf(pgd_t pgd)		{ return false; }
+#define pgd_leaf pgd_leaf
 #define p4d_ERROR(p4d)				(pgd_ERROR((p4d).pgd))
 
 #define pgd_populate(mm, pgd, p4d)		do { } while (0)
diff --git a/include/asm-generic/pgtable-nopmd.h b/include/asm-generic/pgtable-nopmd.h
index 36b6490ed1808..dbd38b4c3a056 100644
--- a/include/asm-generic/pgtable-nopmd.h
+++ b/include/asm-generic/pgtable-nopmd.h
@@ -31,7 +31,8 @@ static inline int pud_none(pud_t pud)		{ return 0; }
 static inline int pud_bad(pud_t pud)		{ return 0; }
 static inline int pud_present(pud_t pud)	{ return 1; }
 static inline int pud_user(pud_t pud)		{ return 0; }
-static inline int pud_leaf(pud_t pud)		{ return 0; }
+static inline bool pud_leaf(pud_t pud)		{ return false; }
+#define pud_leaf pud_leaf
 static inline void pud_clear(pud_t *pud)	{ }
 #define pmd_ERROR(pmd)				(pud_ERROR((pmd).pud))
 
diff --git a/include/asm-generic/pgtable-nopud.h b/include/asm-generic/pgtable-nopud.h
index 356cbfbaab247..6c9bca78047c4 100644
--- a/include/asm-generic/pgtable-nopud.h
+++ b/include/asm-generic/pgtable-nopud.h
@@ -29,6 +29,8 @@ static inline int p4d_none(p4d_t p4d)		{ return 0; }
 static inline int p4d_bad(p4d_t p4d)		{ return 0; }
 static inline int p4d_present(p4d_t p4d)	{ return 1; }
 static inline void p4d_clear(p4d_t *p4d)	{ }
+static inline bool p4d_leaf(p4d_t p4d)		{ return false; }
+#define p4d_leaf p4d_leaf
 #define pud_ERROR(pud)				(p4d_ERROR((pud).p4d))
 
 #define p4d_populate(mm, p4d, pud)		do { } while (0)
-- 
LEVI:{C3F47F37-75D8-414A-A8BA-3980EC8A46D7}


