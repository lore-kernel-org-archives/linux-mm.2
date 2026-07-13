Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 916A8C44507
	for <linux-mm@archiver.kernel.org>; Mon, 13 Jul 2026 16:23:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BFB866B00DA; Mon, 13 Jul 2026 12:23:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BD2C36B00DC; Mon, 13 Jul 2026 12:23:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A4CBF6B00DD; Mon, 13 Jul 2026 12:23:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 66CC86B00DA
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 12:23:10 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 60BD4C0A5B
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 13:57:59 +0000 (UTC)
X-FDA: 84983907078.17.2F5408D
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf17.hostedemail.com (Postfix) with ESMTP id BC2974000B
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 13:57:57 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=dWHgmUWY;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf17.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783951077;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=L8QhEekflZGU6lXrfq5/In7olrm+orLnVPkzmY3O28E=;
	b=LGmx4/QuzQ8hO/1mAqkYqMjOcnlUPNGls/ewJGY8A/MflRzYPZqX/00BPpr2+a+bdyeqfr
	3QbNLYewjJkrppByvKkySQ5kicGDg7g6n+natjS7KjFvQRvflpj0HnO3gn+OLtdVZQCjVU
	4hcdt+k+P0MYNNrCTMoBH12mVUYWgVo=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=dWHgmUWY;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf17.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783951077;
	b=5kj6HNDgl5G5CNy09v2BBLigp8iJqjtKxiox3VWuXFan1Nm5JxHJT7L6Dbw0EbB0jLzst8
	M2ABtmY/goLNxvYoHunaUej7KEXyochcWSguskdDd9gllTnb/b12A69XMuSgk5WPBGU1qF
	UOxW4d0quUph+VmzT6P0skCd8ydT3Qg=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C2AF719F6;
	Mon, 13 Jul 2026 06:57:52 -0700 (PDT)
Received: from e129823.cambridge.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id CE6973F7B4;
	Mon, 13 Jul 2026 06:57:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1783951077; bh=Kej26z+gBagG9HQ6WbTine/W5VcGxHGbASgZAOow16A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dWHgmUWYOHd4ghoMSrk0Xlu1ZLiyieBUVrKIzBFBNoEXXlquVPK8mzC3CvwKKIamc
	 aUt3VH6A7Jp04fkfcylTei7ubrfjcTRqPGsZmZCBL6ATbvAZy9tqUe1ecybQrYrSYV
	 A0sH2EH+D2P8v0DRt072FUB07yWqdhKRW9iEyhPU=
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
Subject: [RFC PATCH 07/34] mm/pgtable: define (pgd|p4d|pud)_offset_lockless() for folded page tables
Date: Mon, 13 Jul 2026 14:55:46 +0100
Message-ID: <20260713135614.1618183-8-yeoreum.yun@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260713135614.1618183-1-yeoreum.yun@arm.com>
References: <20260713135614.1618183-1-yeoreum.yun@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: BC2974000B
X-Stat-Signature: n7wfgom8gx17gd17m8ekxx8na83sfnr9
X-Rspam-User: 
X-HE-Tag: 1783951077-525926
X-HE-Meta: U2FsdGVkX1/Q0bEkojE0YZGQKSGqk57YMciWnPdKJEwzrr4Yjcdh/XE5eJMjC+6mZ1Gnen7QjGujq0r1RHnxpfZQ2h8uJMmeRliOCy5vmBKkA+EwvBo56SeFU/0Ed6nO7mjs/oidy/QRylJuJsqxpEEvasgD3WWXAMSAtmW3N4Dq9AqgMIF6QCQco3GpVaQuetRfgwGmc83glqwlYS3N88C4jBDW5kPhUHRLSBc+pasGYswBvwrdbDrnisl2J/THIH8+vyQtlJRxSK/KJgNeoFPAZDF8Jxgx1zpVfs8Bqh8QPHUl328rrRnrMk8qHSWzVW/OS5k3oyHnjlt4w7VDbuWIj35dIMucYmATUfQ+82Y5/6aVYkPczvGCm32gbkfbU9YoNSjaQwOvRjSZExFMMf4vkDpVVAaNkSafUnnxdvXF3PRpl5mmOjs2Kl9t+g2lL+jqcVoh6plmCdCINuKdpJVOmh1uhkOeOzAblil5+NiqkZrpkYXt5zHXGegrypSqd/nEmzhqIOXERe2YI8yZM42ERJDgLpsLjI3PNfpkKM3xnrf/aLAh9K5Vgv20QBtET76WrXzrUzq0etx/AV8rfXCoz413hdA4op5og+QYswRcFjU4ddHp9XX32UbrIpxKzfcpBfqdvZ6SP3tZ0m+bqLpX3eWaLUXfMWuhG9wSZMuhF75E6FHsUqIETt4WrkxkRytbivruQ3CShXn2dN5p5KxOrcbZC5l5+bRA4kuBWZCs4GCe8C2CXxgkEhzxfn2HsMPPvsw3QduLSyAQnA1RmdBdXPenZoTohLC4LPYTdpAyjnDlC9uzG8GCu6alMkhkGs6RuNvgwtrfE96pdYUf1jcHvFdBDckr7HZiOF+szl4Fv5cpkEz76fsOk4NEg6xm/6wOzT+DXemyfwPwajW+gHazx+XmpardLKgUKBx+0dSlhcZUKTauvuS1N7KxLOQ5ufnVNTsYf6lrAGpBLth
 GDvniQQq
 KHHNa64CdpgLITjqAdr7F5fNhS/iq1Pc3/qOxPn7/7DRRYroJHISMyyz1fTn9g7fpIHHY+I8DRQw0FAMXzYbpQCDiCLDRFtofnmcLlysUjsgot7bDsOVJrQz5Da9Ifnb6jitHMblKjzFRySwrCpnHLhHol3pB1IR3Iw9OjLFSHp0Q+BkoNQ8IGfDHZSfjWjwhllhjwklOXwaynq6rIv2LY6fiHiedUvZgcROcKroA2WRW7UJzraHLtQP5VbIcqdGy6JtXzjBTKJHhzHu08wqTretRKJKOJL7S2fqzFUMBAfzBQv3PurmaMLRwOmw6Iokd3l1w/ZhKFXx5gOVV3bBPBXlQKGZ00ASeKgMza+Zt3DVlWz+t1UN/YPil7M5TB7Mwchfr
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "David Hildenbrand (Arm)" <david@kernel.org>

The default helpers fallback to pud_offset(), passing a pointer to the
stack value.

Let's provide variants that do exactly what (pgd|p4d|pud)_offset() do,
but ignore the passed pgd_t/p4d_t/pud_t, consequently not working on a
pointer to the stack value like the default handlers would.

Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
---
 include/asm-generic/pgtable-nop4d.h | 7 +++++++
 include/asm-generic/pgtable-nopmd.h | 7 +++++++
 include/asm-generic/pgtable-nopud.h | 7 +++++++
 3 files changed, 21 insertions(+)

diff --git a/include/asm-generic/pgtable-nop4d.h b/include/asm-generic/pgtable-nop4d.h
index c6a5a43899b50..019c3f074b771 100644
--- a/include/asm-generic/pgtable-nop4d.h
+++ b/include/asm-generic/pgtable-nop4d.h
@@ -39,6 +39,13 @@ static inline p4d_t *p4d_offset(pgd_t *pgd, unsigned long address)
 	return (p4d_t *)pgd;
 }
 
+static inline p4d_t *p4d_offset_lockless(pgd_t *pgdp, pgd_t pgd,
+		unsigned long address)
+{
+	return (p4d_t *)pgdp;
+}
+#define p4d_offset_lockless p4d_offset_lockless
+
 #define p4d_val(x)				(pgd_val((x).pgd))
 #define __p4d(x)				((p4d_t) { __pgd(x) })
 
diff --git a/include/asm-generic/pgtable-nopmd.h b/include/asm-generic/pgtable-nopmd.h
index dbd38b4c3a056..ae2eff44889ac 100644
--- a/include/asm-generic/pgtable-nopmd.h
+++ b/include/asm-generic/pgtable-nopmd.h
@@ -50,6 +50,13 @@ static inline pmd_t * pmd_offset(pud_t * pud, unsigned long address)
 }
 #define pmd_offset pmd_offset
 
+static inline pmd_t *pmd_offset_lockless(pud_t *pudp, pud_t pud,
+		unsigned long address)
+{
+	return (pmd_t *)pudp;
+}
+#define pmd_offset_lockless pmd_offset_lockless
+
 #define pmd_val(x)				(pud_val((x).pud))
 #define __pmd(x)				((pmd_t) { __pud(x) } )
 
diff --git a/include/asm-generic/pgtable-nopud.h b/include/asm-generic/pgtable-nopud.h
index 6c9bca78047c4..5a2b0a81ae197 100644
--- a/include/asm-generic/pgtable-nopud.h
+++ b/include/asm-generic/pgtable-nopud.h
@@ -47,6 +47,13 @@ static inline pud_t *pud_offset(p4d_t *p4d, unsigned long address)
 }
 #define pud_offset pud_offset
 
+static inline pud_t *pud_offset_lockless(p4d_t *p4dp, p4d_t p4d,
+		unsigned long address)
+{
+	return (pud_t *)p4dp;
+}
+#define pud_offset_lockless pud_offset_lockless
+
 #define pud_val(x)				(p4d_val((x).p4d))
 #define __pud(x)				((pud_t) { __p4d(x) })
 
-- 
LEVI:{C3F47F37-75D8-414A-A8BA-3980EC8A46D7}


