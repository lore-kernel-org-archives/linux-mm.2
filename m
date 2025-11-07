Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AAB43CCF9F8
	for <linux-mm@archiver.kernel.org>; Fri,  7 Nov 2025 09:59:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DE2AE8E0009; Fri,  7 Nov 2025 04:59:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DBA4A8E0002; Fri,  7 Nov 2025 04:59:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CF70E8E0009; Fri,  7 Nov 2025 04:59:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BB4918E0002
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 04:59:50 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 5D9164B7F5
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 09:59:50 +0000 (UTC)
X-FDA: 84083364540.25.7F34B5C
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by imf10.hostedemail.com (Postfix) with ESMTP id 1BB0FC000B
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 09:59:47 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	spf=pass (imf10.hostedemail.com: domain of chenhuacai@loongson.cn designates 114.242.206.163 as permitted sender) smtp.mailfrom=chenhuacai@loongson.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762509588;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=CYFmY/+Q1UIq0AeMj4qDY4EyyQZLSwgnI8hCxFWC0Nw=;
	b=luIpsBlKrkeiP+FR1qC+an7a3BbeIv8C2oGdbNglooFwhXe9qc0JGi2iN7xCdGFBaV/LNa
	GUUpTIO3on6DzJATLeZ5G/reZpXDis0gEf0jCW217a5ioNJwC71Y8jPfCQqpnKD3VEqpA+
	PX2O7Uhcn8bv2s6Whp4LkBhaoTCSKqU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762509588; a=rsa-sha256;
	cv=none;
	b=0+0+78Khp1MUpGYjdtk2qJI9PTuemxPXNbz5obUvPl29PSGUK2AzC/49FAMbxF977SeJKX
	32jUo/VbZ6P3Wsq/YpbEPfZEeFTgP8SjwT/oOMpUR0KwQ9H/5kiJogQf8NUy34Z+0HUeqt
	13xT7NJ9K1zHslHUjuJA1I+qgiiRERQ=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=none;
	spf=pass (imf10.hostedemail.com: domain of chenhuacai@loongson.cn designates 114.242.206.163 as permitted sender) smtp.mailfrom=chenhuacai@loongson.cn;
	dmarc=none
Received: from loongson.cn (unknown [223.64.68.45])
	by gateway (Coremail) with SMTP id _____8CxbNILww1ptkIgAA--.4952S3;
	Fri, 07 Nov 2025 17:59:39 +0800 (CST)
Received: from localhost.localdomain (unknown [223.64.68.45])
	by front1 (Coremail) with SMTP id qMiowJAx_8EGww1ptL4qAQ--.58299S2;
	Fri, 07 Nov 2025 17:59:38 +0800 (CST)
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
Subject: [PATCH Resend] mm: Refine __{pgd,p4d,pud,pmd,pte}_alloc_one_*() about HIGHMEM
Date: Fri,  7 Nov 2025 17:59:22 +0800
Message-ID: <20251107095922.3106390-1-chenhuacai@loongson.cn>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowJAx_8EGww1ptL4qAQ--.58299S2
X-CM-SenderInfo: hfkh0x5xdftxo6or00hjvr0hdfq/
X-Coremail-Antispam: 1Uk129KBj93XoW7uw1fGryUXF4rKr1xAr43urX_yoW8CryxpF
	s7C3y8X398JFyrWa10y3Z7Cr17tw45GF47AF42gFy5Z3W3tw1xGFyDtFW7ZFZrZFZ5ZFW5
	Wrsxtay3AFnIvrcCm3ZEXasCq-sJn29KB7ZKAUJUUUU5529EdanIXcx71UUUUU7KY7ZEXa
	sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
	0xBIdaVrnRJUUUk0b4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
	IYs7xG6rWj6s0DM7CIcVAFz4kK6r1Y6r17M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
	e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Xr0_Ar1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
	0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_
	GcCE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqjxCEc2xF0cIa020Ex4CE44I27wAqx4
	xG64xvF2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_Jw0_WrylYx0Ex4A2jsIE14v2
	6F4j6r4UJwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IYc2Ij64vIr41l42xK82IYc2Ij64
	vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8G
	jcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIYrxkI7VAKI48JMIIF0xvE2I
	x0cI8IcVAFwI0_Xr0_Ar1lIxAIcVC0I7IYx2IY6xkF7I0E14v26r4j6F4UMIIF0xvE42xK
	8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVW8JVWxJwCI42IY6I8E87Iv6xkF7I
	0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjxU7eT5DUUUU
X-Stat-Signature: 1815ybptrqncbgpqh8ujugaqwzuykjbg
X-Rspam-User: 
X-Rspamd-Queue-Id: 1BB0FC000B
X-Rspamd-Server: rspam01
X-HE-Tag: 1762509587-216001
X-HE-Meta: U2FsdGVkX18h/FvqCVfFy6C/GU7q+2uJUhcV3JccxEQoELjEP7eMVbEu7IxrcT3C5woTNQCV9goIQ4JcePGoEP7Jatv996ySptbCgN9d2Zi5J+UtG1odE/lt6eU7faZSqV3qE0WKXhbh+NiqGWnQ6R5HH36eoSxu7oxlxB1/GLQEMHraFvQNpH77YaS3s7ViOVCkJoaQs9E/yg8hp7bG09hx/HJrtzUUc0ciHHGbtayT21XF+/ejIf0pRTwiZey8cQpwNj4RyrCz4shLQtVejNJAQiqHWtfBs26xPTugNbck6Clc7Bf6JJRcq+Xh8uauB2vOHxTY5tSr0Wx67jbi4PoRLe5vw2Ed40X+lLGEodNjLSeGoH/dAWJjlXKYMi5r2m4Dk8LqTWWh+NZvR/J3w+4ohEOQrx+RNNimcA1zk3Zdnelhwz9xibuQRhQ1ANWMSN/axRBpwEn0T8bSGWXYnGNMmcR4MOZ0U6NpHtUEkC8bEAhqQHoLh89qoY4TDNHczesbREhxECq+/SFGKv5f6AGWo5xOVowOY5Mhf1bBpQoXec6ibMO89bkVYcK1erCrxPXJ7cI2K10gVaWvapfk9BXuuNvFic7wvzSXDJT958yywHCB+FOzAOlRClebkBMTTHXtSWg0nIW6GMBXm4o4vmi9ADq70Rbj/n3dfzDrLKQKp1e++ZMSdl5ZD0So4JXFj5pzRzcFwoPRi2T6Eh0/vGX88kdrHED4kxewYxnEHAA5k0MUpEUkh/TIiXCEPEOPPdXuY7vzw3vWwEK70xHndyKaVeb6eie0Z5k19qqzHFiy5AefSDpUoooOGuYJmpcNeUfAsjJvbF2t3Sb1nTncP/mBNnv0IxIAfUIsX9EDy41L1mRxT5+VaaMvhbDYObZ6Uh6j1vADNvouM2a3P03dT7Hdrvz8kmpypOKaNqyfly4Av3ptPK53QR65rt3Eq7ZbTtLBrDsvzMgujwyBZWV
 jsWV582f
 f1QehdoOn3F6kE1EdxJIiHyGKMHk2k6YfjvKdPFojebfZ0b6BX8qwdVkaoR8A6FocOxMWwD5G7zcSdcYLTDbxnGkLhQADmCf6d9rkwuVCaUV+6OiHy+intq8alW1Y5Ovrkni1YK0Q2OgbGZ+Ka3QxLfWMdFrmCxOjW02s
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

 #define GFP_PGTABLE_KERNEL	(GFP_KERNEL | __GFP_ZERO)
 #define GFP_PGTABLE_USER	(GFP_PGTABLE_KERNEL | __GFP_ACCOUNT)

There is no __GFP_HIGHMEM in them, so we needn't to clear __GFP_HIGHMEM
explicitly.

Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
---
Resend because the lines begin with # was eaten by git.

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


