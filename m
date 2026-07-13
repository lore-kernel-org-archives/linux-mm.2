Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 09A38C43458
	for <linux-mm@archiver.kernel.org>; Mon, 13 Jul 2026 16:31:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 224336B0135; Mon, 13 Jul 2026 12:31:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1FBA56B0137; Mon, 13 Jul 2026 12:31:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0EA6D6B0138; Mon, 13 Jul 2026 12:31:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D9AA56B0135
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 12:31:23 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3E4498BD55
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 14:02:48 +0000 (UTC)
X-FDA: 84983919216.15.9D1C08D
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf19.hostedemail.com (Postfix) with ESMTP id 91C551A0003
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 14:02:46 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=WULz4y4Y;
	spf=pass (imf19.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783951366;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gEA1+2QZ39+w8tSd3ml5+acKOYA+ukDm4jJCZw8YYDM=;
	b=kBzgTqZvGkql/2ovgHAYMFpwoqjA7mcMtGczoiRcIVe2fwqzI5ZT02T1E9PcKCXpOMwz5j
	HpTdlGgprl7W4dmnn9H48Y0+vggIfs3oG0tUt31qE7nHnmg5eBKUUV3L+lNzdaF9qx+9yM
	oXG8Qtr92IwkDFbFJ8wtGX7zvQHbkew=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783951366;
	b=43OOpkvu0UUOWzzUXbQQW58t/i4HP/bzpGQfrfO3B9wFa9r51g7oMQNtbyrQIAiRpXiGe7
	LB/3Yg0tIYyZr4b0CX1xpk+glSqFdKy1dsgGOQ/fTE0RgR7lAQKQn2Qt5CI+LVlFFGEE8I
	ZTx8Q/ztmwQp77AG/ZeJP65Jc5cmQdA=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=WULz4y4Y;
	spf=pass (imf19.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6B7FD2308;
	Mon, 13 Jul 2026 07:02:41 -0700 (PDT)
Received: from e129823.cambridge.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 6F3783F7B4;
	Mon, 13 Jul 2026 07:02:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1783951365; bh=bIKoPb0bNMxSfp09kSEpc6GfFg6xieua9pE2L9NCvH0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WULz4y4YGBEo8OxYiDQxjd3ysksN4y37aXjVMj1APMpW6oYyyzlT2yQ9xycWe8eq1
	 JbXFkQQYvjUOrSyYV49ZYubVKBtMB+ARWadXw+OMlzoS2V4DZrO9+UJT10fnE4iycW
	 mu1W2yH62wJX/KyaBePfncLl5wroe1c443crwqTc=
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
Subject: [RFC PATCH 30/34] mm/pgtable: disallow calling folded (pgd|p4d|pud)_page, pgd_page_vaddr() and (p4d|pud)_pgtable
Date: Mon, 13 Jul 2026 14:56:09 +0100
Message-ID: <20260713135614.1618183-31-yeoreum.yun@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260713135614.1618183-1-yeoreum.yun@arm.com>
References: <20260713135614.1618183-1-yeoreum.yun@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 91C551A0003
X-Stat-Signature: wf7hb9bhyukjd8ghg4tjjk3ysh67uuks
X-HE-Tag: 1783951366-830585
X-HE-Meta: U2FsdGVkX18dPPxlcsDIZ6/jatW+i7Voo+TWptlL3ZxpjtxqmtrdezRs82wckHZBi2jANQc2dL3mgGg2gz1alM+maydrUHH7GigpJuUrSTp0QnnDp0j7IiFoJikrTuT+VRR2ku/ltls3T7seRBYxv1zL8L+KR9CeE9zOXISiprvU9tQ/47ij5Nrn9Sj/J+69gSACww4E2/BBtUMnMaK01uo3XfZksoHLwZuMBAtX50ftnqKWQTVYtMeMqY1x4eK1yjJauKHycUtmUcghmtXrmEWJzJ7KGgWCblejbhIuqkT3kZlYOhbIJG+jKkvVcwJs2pMR7SJOj4NZvKEcIeOQwks58M9BZiEg7QVV5rw6WPXTQyYltsuDrm17Vi4/BQ82XDRYEcYjobXhKFOvSchikfg9a5Rumsw0elRSfQIOcpGWzFNoDZOe08bTyDGcvCzfkQQAdrKcJrQl20S4Om/+18h/176KbYk8KCMUbaEnh23aiwpWbSxs3rirBwdZoUVKjQTbbip+xyYnuFIbG2mVhqbxQ31Q6Cjuomw7SIWwcR8oPlJDCxh/wWK4+POxSPX59fIzYUH/MSBjqg2RD1FEI6XT/c/sUnVEJb1v2FHKw4k7E9pvzA9YyXVxuamiWkna3SEoYAwFGxTorhv9SgBYibncEQQIRzbxieWtfBl09TiOgkUJCTcvf5Adf87ry0W8LYHy4mOncXQQPws8XrwFBxjH59IU11OmUtxMiPoAQANQfDAmATzgJ0UJWtJNIaJgdz55xlBoIBPSttDsPwbJWAd0PzODgU0BbAjY5c2gZ1m84HXbiHEyQBJTl7UDjT1AlMbJ3QA/ARGjL/Lno9FlQhGLENJdegYMlaBxnhLYTlTVAvlavN8Zmr6/Un5LvAK66En/MV6PXuhZGBmuUYBz0Ryx4vswmkRomiUcigd6ZCIxNAxg2/hvGJON+rRpVBYE3XPBAczuFedwFP8q8Gf
 I586oyRj
 7Wvp5eX0aC8Ulxa2IucwWjy+TmAgFG/dLBYFuNpWV7YzELYUzjnPCyMAvDq1dZEi+0Q24NyYPhvSQcGX9WlJFMMhx+OcZL6Q8lwqW5OQfe9ZubFKyXozP/ouZx+0wv7oSY0j3BFYboteOwhmyxhB+v9ZT3cOAthnrivrRLfDfIVvvJxTp/EzBuKQQNaB8MoIrPsXrzHFrFGvH6NPi66nckKzmRniqsBcv0dccI0KZvPnSLYWyCyhMaPaVJ4RiJ6wYkMpB4bGdTgDH1cu8h/l+lNRUSjH0Ydnw2qpU2LYjx9ezGIELvEbi1EmVuxYKug1hSHKow5MRhz6kaqA8JCzn5T+HkZ+rUYYLnbq46AHvrMcb7MKg2Jjn6vR+fupzWbjTe0zl
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "David Hildenbrand (Arm)" <david@kernel.org>

These helpers that silently fallback to the folded level
are dangerous, especially with some upcoming changes.

We made all code compile-out any calls to these helpers. So let's make the
compiler complain if these helpers are abused in wrong context.

Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
---
 include/asm-generic/pgtable-nop4d.h | 4 ++--
 include/asm-generic/pgtable-nopmd.h | 4 ++--
 include/asm-generic/pgtable-nopud.h | 4 ++--
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/include/asm-generic/pgtable-nop4d.h b/include/asm-generic/pgtable-nop4d.h
index 0f3b56deaa165..25c26a587b512 100644
--- a/include/asm-generic/pgtable-nop4d.h
+++ b/include/asm-generic/pgtable-nop4d.h
@@ -46,8 +46,8 @@ static inline p4d_t *p4d_offset_lockless(pgd_t *pgdp, pgd_t pgd,
 #define p4d_val(x)				(pgd_val((x).pgd))
 #define __p4d(x)				((p4d_t) { __pgd(x) })
 
-#define pgd_page(pgd)				(p4d_page((p4d_t){ pgd }))
-#define pgd_page_vaddr(pgd)			((unsigned long)(p4d_pgtable((p4d_t){ pgd })))
+#define pgd_page(pgd)				({ BUILD_BUG(); (struct page *)NULL; })
+#define pgd_page_vaddr(pgd)			({ BUILD_BUG(); 0UL; })
 
 /*
  * allocating and freeing a p4d is trivial: the 1-entry p4d is
diff --git a/include/asm-generic/pgtable-nopmd.h b/include/asm-generic/pgtable-nopmd.h
index 9d854211a55a5..75650fa9111cd 100644
--- a/include/asm-generic/pgtable-nopmd.h
+++ b/include/asm-generic/pgtable-nopmd.h
@@ -56,8 +56,8 @@ static inline pmd_t *pmd_offset_lockless(pud_t *pudp, pud_t pud,
 #define pmd_val(x)				(pud_val((x).pud))
 #define __pmd(x)				((pmd_t) { __pud(x) } )
 
-#define pud_page(pud)				(pmd_page((pmd_t){ pud }))
-#define pud_pgtable(pud)			((pmd_t *)(pmd_page_vaddr((pmd_t){ pud })))
+#define pud_page(pud)				({ BUILD_BUG(); (struct page *)NULL; })
+#define pud_pgtable(pud)			({ BUILD_BUG(); NULL; })
 
 /*
  * allocating and freeing a pmd is trivial: the 1-entry pmd is
diff --git a/include/asm-generic/pgtable-nopud.h b/include/asm-generic/pgtable-nopud.h
index aa8a6ce139e47..b592fff18887a 100644
--- a/include/asm-generic/pgtable-nopud.h
+++ b/include/asm-generic/pgtable-nopud.h
@@ -54,8 +54,8 @@ static inline pud_t *pud_offset_lockless(p4d_t *p4dp, p4d_t p4d,
 #define pud_val(x)				(p4d_val((x).p4d))
 #define __pud(x)				((pud_t) { __p4d(x) })
 
-#define p4d_page(p4d)				(pud_page((pud_t){ p4d }))
-#define p4d_pgtable(p4d)			((pud_t *)(pud_pgtable((pud_t){ p4d })))
+#define p4d_page(p4d)				({ BUILD_BUG(); (struct page *)NULL; })
+#define p4d_pgtable(p4d)			({ BUILD_BUG(); NULL; })
 
 /*
  * allocating and freeing a pud is trivial: the 1-entry pud is
-- 
LEVI:{C3F47F37-75D8-414A-A8BA-3980EC8A46D7}


