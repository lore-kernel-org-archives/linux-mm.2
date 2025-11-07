Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CEF0ACCF9F8
	for <linux-mm@archiver.kernel.org>; Fri,  7 Nov 2025 09:55:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1F5BE8E0007; Fri,  7 Nov 2025 04:55:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1A6048E0002; Fri,  7 Nov 2025 04:55:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0953F8E0007; Fri,  7 Nov 2025 04:55:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id E4FB98E0002
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 04:55:57 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 88284C0410
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 09:55:57 +0000 (UTC)
X-FDA: 84083354754.25.00B8BA8
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by imf15.hostedemail.com (Postfix) with ESMTP id DC998A0006
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 09:55:54 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	spf=pass (imf15.hostedemail.com: domain of chenhuacai@loongson.cn designates 114.242.206.163 as permitted sender) smtp.mailfrom=chenhuacai@loongson.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762509356;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=d0yQA+pYRjwFUipM7pk/ki12LNmNsVIQWo4kNvtDv9E=;
	b=0NIKC7ak/Ue6wlZHUwnWHDr3I/Ik6afQm7AzoleYzT97edouQic2ZRUTpk76qz2P7/hfGx
	xoTZQChxmmhtvk5SoQo8l+/S4ZNlrA/G1Jij0Laj3ukWj9vVZ8brwRSHsuGxywCcRzLNre
	yo56NIuOxwyEFw3jjbzdoKh7zxhbUqc=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf15.hostedemail.com: domain of chenhuacai@loongson.cn designates 114.242.206.163 as permitted sender) smtp.mailfrom=chenhuacai@loongson.cn
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762509356; a=rsa-sha256;
	cv=none;
	b=hhFa1UOrtRBf/ZTtn3KnDxDXKcVk/hqsbzikA+TmiX02Jkc+wTMaLvsQu0dUoE6UhdWo9c
	eJIyVFaf/lD3zgGO4wPzWaafoKsMgfsDZfcjLROVBd/Q4uDoLn1T1AdSjDgZaJ0a0H4Pzw
	Y/La9O2bKg7ihFvs5AuIRwQLCXSBfF0=
Received: from loongson.cn (unknown [223.64.68.45])
	by gateway (Coremail) with SMTP id _____8Bxnr8nwg1pYkIgAA--.2751S3;
	Fri, 07 Nov 2025 17:55:51 +0800 (CST)
Received: from localhost.localdomain (unknown [223.64.68.45])
	by front1 (Coremail) with SMTP id qMiowJCx3sEhwg1pBL4qAQ--.58318S2;
	Fri, 07 Nov 2025 17:55:50 +0800 (CST)
From: Huacai Chen <chenhuacai@loongson.cn>
To: Huacai Chen <chenhuacai@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Arnd Bergmann <arnd@arndb.de>,
	Vishal Moola <vishal.moola@gmail.com>,
	Kevin Brodsky <kevin.brodsky@arm.com>,
	Jan Kara <jack@suse.cz>,
	linux-mm@kvack.org,
	linux-arch@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH] mm: Refine __{pgd,p4d,pud,pmd,pte}_alloc_one_*() about HIGHMEM
Date: Fri,  7 Nov 2025 17:55:36 +0800
Message-ID: <20251107095536.3101371-1-chenhuacai@loongson.cn>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowJCx3sEhwg1pBL4qAQ--.58318S2
X-CM-SenderInfo: hfkh0x5xdftxo6or00hjvr0hdfq/
X-Coremail-Antispam: 1Uk129KBj93XoW7uw1fGry3Wr1kZw4rJrW7Jrc_yoW8WFWxpF
	s7C3y8Z398GFyfWa1jy3Z7Cr17tw45GFW7AF429Fy5Z3W3t34fGa4DtrW7ZFZrAFZ5ZFW5
	Wrsxta9xArnIvrcCm3ZEXasCq-sJn29KB7ZKAUJUUUUr529EdanIXcx71UUUUU7KY7ZEXa
	sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
	0xBIdaVrnRJUUU9jb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
	IYs7xG6rWj6s0DM7CIcVAFz4kK6r1Y6r17M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
	e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
	0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_
	GcCE3s1ln4kS14v26r1Y6r17M2AIxVAIcxkEcVAq07x20xvEncxIr21l57IF6xkI12xvs2
	x26I8E6xACxx1l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r1q6rW5
	McIj6I8E87Iv67AKxVWxJVW8Jr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcxkI7VAKI4
	8JMxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMxCIbckI1I0E14v26r1Y
	6r17MI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7
	AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r4j6ryUMIIF0xvE
	2Ix0cI8IcVCY1x0267AKxVW8JVWxJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcV
	C2z280aVAFwI0_Gr0_Cr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2Kfnx
	nUUI43ZEXa7IU829aPUUUUU==
X-Rspamd-Queue-Id: DC998A0006
X-Stat-Signature: yfm9requhpbr4th3kmfhhmkkheodro4k
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1762509354-974920
X-HE-Meta: U2FsdGVkX1+BoDXhVaO3b1ZbQscQU+YRCLWrcTz98itDu5gMR6ZrAUdMal8AiXkXT6vxV8EiJvDYPy/D+HdtOk8FE/j4jsHVt1sHGXKMa+Mfbt4DkrI2LKRgFNsQkCBxLioZgU72XdSuMvLf0pBQJBli/bff7ZprCH0DhFbshiUlZuMZtDUvTHbpdAKvu03qPk2uUgvly/W+k0ukotv13h0/Xes39LDM7Lv7mN5VHRWZVb8kOExh/jCyuEF3s8i5vBAlsptWSk70R4RLn72xwDZbn3sezj8inp50Yuri3/y0K5CQ1efX0dA2T/gpxCJdpr2qm0ujjqxC/pBNQ1JgbogHNig48mvSzZwKEal4hYryXIdd9KDGX+QJvBMyZoKYmA9Ij7iMXe4EfkRqjcAjfQlRp7nh6DlUU6TCT0ox6daNBuZJJ/sBzM2JuHX4gsD1Oo6QSQ6DTmGHpazOhhoMtnJAiK2C3fOaJ9FrcrqGeYpiDeb0BpNWxR6PaUODSSTxkKJ20LPRU/TXdRSytyfJLT6sKY46BkTnF5nl40/Vifyw58Xy44Gv9kqP4gzj5e0rjp74o261laFnpq25HABI9DK9qWtD0vovLJmWTW5HQkyKl8ME15lHRMBi3fPNHKV1PwLwH5aPXH0336UNhPeYEoinFrD5p7v+vTB/08aBM0ZQlXmCh1I2bvufcm/pXkBRYvubsvlohas0qp1OeN2KunXR4YO0urHQQHcNozOJeOB0hxZk8b44N+fML7OdZ/WTf01x3ykT5WWUplA0rPGYGXnLlh6Jzqp3fkkRnPmBf99IKGIgrSrFWXbAE0zHdX6YVezV3uXY45N9UbTrl/jJc1K52bMAeOol3UaGOamEcUchljFJwLLyRANVHwwwoLNJTPboqkuAk/N28vdw1vwW+D+nBRoDZ0qbylcsVlZzZzkmlfPIfAPYFDvecO/Ca2IJYWUt6dAEOe6A5fibKTl
 xi1DMTFo
 USwSjxM4O8/WeY2dWWWDqoKHA39nxCn5N7buvR4+WSe1OA/msAHpo+l6YAlogD+IWireb87zSSdySqnRMB1FmBMHWhuE8OTDuGdX4hRhCe1LiHVNWnmBOqvvonCV/bA8yr1+a5haWHrT/0mGhyS56wM8jsyhibZeITlUc
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

__{pgd,p4d,pud,pmd,pte}_alloc_one_*() always allocate pages with GFP
flag GFP_PGTABLE_KERNEL/GFP_PGTABLE_USER. These two macros are defined
as follows:

There is no __GFP_HIGHMEM in them, so we needn't to clear __GFP_HIGHMEM
explicitly.

Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
---
 include/asm-generic/pgalloc.h | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/include/asm-generic/pgalloc.h b/include/asm-generic/pgalloc.h
index 3c8ec3bfea44..706e87b43b19 100644
--- a/include/asm-generic/pgalloc.h
+++ b/include/asm-generic/pgalloc.h
@@ -18,8 +18,7 @@
  */
 static inline pte_t *__pte_alloc_one_kernel_noprof(struct mm_struct *mm)
 {
-	struct ptdesc *ptdesc = pagetable_alloc_noprof(GFP_PGTABLE_KERNEL &
-			~__GFP_HIGHMEM, 0);
+	struct ptdesc *ptdesc = pagetable_alloc_noprof(GFP_PGTABLE_KERNEL, 0);
 
 	if (!ptdesc)
 		return NULL;
@@ -172,7 +171,6 @@ static inline pud_t *__pud_alloc_one_noprof(struct mm_struct *mm, unsigned long
 
 	if (mm == &init_mm)
 		gfp = GFP_PGTABLE_KERNEL;
-	gfp &= ~__GFP_HIGHMEM;
 
 	ptdesc = pagetable_alloc_noprof(gfp, 0);
 	if (!ptdesc)
@@ -226,7 +224,6 @@ static inline p4d_t *__p4d_alloc_one_noprof(struct mm_struct *mm, unsigned long
 
 	if (mm == &init_mm)
 		gfp = GFP_PGTABLE_KERNEL;
-	gfp &= ~__GFP_HIGHMEM;
 
 	ptdesc = pagetable_alloc_noprof(gfp, 0);
 	if (!ptdesc)
@@ -270,7 +267,6 @@ static inline pgd_t *__pgd_alloc_noprof(struct mm_struct *mm, unsigned int order
 
 	if (mm == &init_mm)
 		gfp = GFP_PGTABLE_KERNEL;
-	gfp &= ~__GFP_HIGHMEM;
 
 	ptdesc = pagetable_alloc_noprof(gfp, order);
 	if (!ptdesc)
-- 
2.47.3


