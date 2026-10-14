Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 24374CA9EBD
	for <linux-mm@archiver.kernel.org>; Wed, 14 Oct 2026 03:59:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E95136B00A1; Tue, 13 Oct 2026 23:59:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E6DBA6B00A2; Tue, 13 Oct 2026 23:59:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D831E6B00A3; Tue, 13 Oct 2026 23:59:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id AD3856B00A1
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 23:59:27 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 3BE3F1203FD
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 03:59:27 +0000 (UTC)
X-FDA: 85319877174.01.789BA27
Received: from mail-pg1-f170.google.com (mail-pg1-f170.google.com [209.85.215.170])
	by imf19.hostedemail.com (Postfix) with ESMTP id BF5781A0002
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 03:59:24 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=HQs9cGqd;
	spf=pass (imf19.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.215.170 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791950365;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=f+FSgGJMK2coGisR/hIoDuCVxcBu6Hr0f49QmgHJmrk=;
	b=W/NIdiS3G0wlspYDUXuIS4OtkXvYAu9OseXSei31vC7V7xN/DH8rrIaCLtUk1vopXOQ2C2
	bTdPg3DqkpmwVt/KNll/iJJtNfDfKsCiVR3UM8PaEE+3gNg85tduENv/ecYFM+Bmrjv9Hd
	qOq83kXKhNflzDaRQjEzjbfqYR9dGZI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791950365;
	b=o2PophUBqRdYnw7RZu+Abu61jMIWZDldJfRavH0UaSMNty29I/YywdLA7UN10ifVWCUNOZ
	d//xpcyLxF08v4hGHQwrLpzInGAe4oXH3/NACoL0HYELdJcu5fUSTwe6UauhwwAjaJ8B2U
	e7UD/2aM3JMCqWP9XLLO7lSfUvgzYl0=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=HQs9cGqd;
	spf=pass (imf19.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.215.170 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
Received: by mail-pg1-f170.google.com with SMTP id 41be03b00d2f7-cc4b1f7e8f4so2197752a12.1
        for <linux-mm@kvack.org>; Tue, 13 Oct 2026 20:59:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1791950363; x=1792555163; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=f+FSgGJMK2coGisR/hIoDuCVxcBu6Hr0f49QmgHJmrk=;
        b=HQs9cGqdWx9AlpYW4H6Ej4L50Unc1s9CdPKZv78z/i+17DJqh0EbGdAM29TLzVEQRF
         uiIt/juVn2MYwpAaCAO/Ucx6m/Q6nynlKvtOHRjr8gW7YPn5gTHn7WW8niLKVU0iXn/d
         FK/lIqL+2IvNekzDfn4gLAGbnsf3IGG50HyRuxKDIT5hnFNOukQ5CCLCaPymK9XMAhjJ
         UWfeMDhC2Qgf/12zY4wdzA0OGLo7Lg72F/cy/b6LN23IDzK6nf41WMXcYLq3Axi/DoGI
         +1Ew9fj+sLJi6ynnIIj4+SW6NLAYKm+stvhuA5j21xuCrBs58q7evb0gtZVPDufEb+s0
         m3pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791950363; x=1792555163;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=f+FSgGJMK2coGisR/hIoDuCVxcBu6Hr0f49QmgHJmrk=;
        b=dsQC7kn7/dW/jwSIlVZ5IwHLFdEjVeOtKkbWaokrYKRZ8INGBRmPyQ4rAfEzXpyz8T
         H8SWX2bqNFejGqtMpWsEixjZeUz7hYeLvJloHGZoCZwgCY9eyPw4dsxPSHGLuQKeGxH9
         dkVxISkBF7KrbA9iqAepo3UMoyUtri+72x9kUx7jDL8rG28NR2XIq5LH1aPJXYEmbQfP
         OT5k1sjqVgxXUYS8oy+56HTGN0h0DEoMV9KT5BGtGTcEgx1g4y+ZYSQl9m9AR/22Ev54
         h/e2k71O0jAq0vTNysj3/PSyRUC1VTSVUGAIMp9q/sJ80cUqKerb6rtqSZrP7IY8KvFB
         0zfA==
X-Forwarded-Encrypted: i=1; AKwUvByGG4aiP159aDUVzTlRo1UrR+a94rippILxP0qLbBzX/RRocSDXlwZFkSsEBPyFUzoslnXenHuasA==@kvack.org
X-Gm-Message-State: AFq9FYKEhbQyPx6gQq4NvaLF3886lyrU01Oe0Qr/iLFxjmb9KVUp5imD
	1sxzna5jSxKt8Hb8aKtZlG1WtVB/zqnjxYeJLke8B0XjnHakn4EzAU0pj2D+tVxx91o=
X-Gm-Gg: AYBFou1/fum1JuzNBgtcifKaBl3/sL3sRMjhClbM1w1UzQGGBx2xBE3hUMcLkVX0gcL
	aKFkWd1/Zhd1zJT5/QYPDPfcCiyAZb1fr2Mzk3KeY5CZrM5gYd952/5WfnSKxQf0gfbFK6njC37
	bWSfitKe7Tlq18BAU72Jg+EpCkMz5s5kLRm/ZSmSs6HuYmN4nUhLy2jsczwz/ng/uft3MBIqquQ
	F0YRZxGTggiAY5B9MBuX9FLTS4yEz2zhagvBmWF3SMJwxsd9fUN1ukkZ3y3tlz9oMoiT7sI3n8b
	IHzcdd08QEmR6iIrXpGcNTg/kYlGCdlDQ1jatkX9cEUcuFO0MkMPIla6bVG7AUxvyoPJtgLZIs6
	vKJKN0l64XCY+1XwbcUXJKwR61OW+5Th4FGh8pdfPxBDhMJxz4wGN1CBvcNyfREIUbLaLTBEk9y
	GupRGDur3CQ8qoY1Dg7L7JOJS4NuPjMHA7PauXSEBEWZjJ6c27ksI0WLzCC0KAeKeDOor+6UEt6
	4d4r3QKsgYor/01hu2U
X-Received: by 2002:a17:90b:1dd1:b0:3a7:e0f4:2857 with SMTP id 98e67ed59e1d1-3ab3a359dd3mr10523369a91.1.1791950363442;
        Tue, 13 Oct 2026 20:59:23 -0700 (PDT)
Received: from n232-176-004.byted.org ([36.110.163.103])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ac5f24a538sm2492305a91.9.2026.10.13.20.59.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Oct 2026 20:59:22 -0700 (PDT)
From: Muchun Song <songmuchun@bytedance.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>,
	Muchun Song <songmuchun@bytedance.com>,
	Arnd Bergmann <arnd@arndb.de>,
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>,
	Huacai Chen <chenhuacai@kernel.org>,
	WANG Xuerui <kernel@xen0n.name>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Helge Deller <deller@gmx.de>,
	linux-mm@kvack.org,
	linux-arch@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-mips@vger.kernel.org,
	linux-parisc@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] mm: generalize kernel PTE table allocation
Date: Wed, 14 Oct 2026 11:59:08 +0800
Message-ID: <20261014035910.687847-2-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261014035910.687847-1-songmuchun@bytedance.com>
References: <20261014035910.687847-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: BF5781A0002
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: 6xaeex9xq57mcqj18jzxwjuet68dejqs
X-HE-Tag: 1791950364-188417
X-HE-Meta: U2FsdGVkX1/vxYA1TMqfg6MCkJdSnqvlBZMwHS+JewyNNW9HrlvkGfz/Qa5In8v5xz3P8WVRn2RbGT9wEbCIM8L/8y2E4IoHtwXE9Yb61FZrVqK/wod2h0XFtoqk7DuqSShsHNBv+YeHJH4xver9OkMw6NKCRtDPBVEyJM/OmMYJ/yG0ZBQgQEfHMWIQqiW/pXiAQjdb3zAG8Lluz+MI5cktKi1RrlNJJ64gvYjslbc///+wUZqY602CD0OBZCgHl77YPT/YnirFiY2eDi2C87JxFGwZC0uBruR4QRDj7fa8Btof4+sUJRo1uvbxkcw/ArjeJrDDDPNwy37MXOm3jQaWCgs/SiAQIUKfXQAXyK5QjhtnxIyac8W+tXHCmPf6AKLOnEXdpGGoXp5Jb+h2aIuA16O5sleCeAt4nmaMA2cOJoamK2RWaYu6MT/hlBBAaMVcktNGdjrOO82qNqffLpu1H/lz8YCVicOmO0xzDAEFOwt0mtxzIR+2j3JeisYhQ7GhrovN/P4cJktvNtyheYqz9eBg7XiS549zWFvuNid7p2M9y2RHTWtM1kMcmOKAYxaxakEBZ2v//u3fn1dT2PqSc6ERPmHS/N+0uwPHALjQIRkRd/qkyVrgexoycmGYBxu2eDUi21o91rdrkq5UQgpuDCtwegYLpuJIuQyE/7L74gXr5n0GtpmC2kklC7Vf/SP2J0xPZ94YEmsuOPB/1oQhWe6MiV0j68YTBUCBXK/ZJtM9kklfcs7TZvi+dcnBoScGkfEEAIj8qMQUlt0zh+feDIdK6+J7Xp8ARqN1T1PNXqhHTZLy9Kf+kNeIWkEkh1/l6/+fwmwgDqt4N/aV/yQpKTKZ/delkbZ3rQXbOsWb7EtyYfP9eaHuQ29OzMh4z+x+6sdqZ2YsQSmiyxXluBlT0VC8A04Mi19fp1nHLDNb7YXBOiCQ8LawVDAyXww2JTqiLC1hj9XfL+EQauR
 yYa3KLcw
 tV4reSWk2CNyRMYwVtuwgniYRsitAbNCqdJWRrH91TQp8c/x/DqWohifRJfIOfOPPRXoQehdO+jmEyzBeVLBHQd9kg1iZ4ouTrZi+KoPwfgcwynf7ElipjIZeGCywUj1+wo7pzZBHp5Tv7ZhxtA3qxmXULY6RCkYiOs8KKL+H2Vf6vfcvareuJd8d/WcVhieaS3qGGmSnKqFygH8Ujb09/+gQzcMtb2HvZESIKmOvVc2yNqyfyZ7YztRVKMxR/xgeJx3hZJ+61AsZ4QAN0JK2+exuFl08UrhwrG+SJspHuNjmxd7Gk70ZP8wFsoUtnlOr2kQmLUPVM4JKtmYII0zXJKOawCtRjtBcNl5vyTW1WMJKDtbIMj8YzBtZHvfOWLMhUA2l
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Architectures whose empty kernel PTE representation is not all zero must
initialize new kernel PTE tables. LoongArch therefore wraps
__pte_alloc_one_kernel() solely to call kernel_pte_init().

Call the architecture initialization hook from the generic allocator so
LoongArch can use it directly. The default hook is empty, so this does not
change other architectures.

Assisted-by: LLM
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
---
 arch/loongarch/include/asm/pgalloc.h | 11 -----------
 include/asm-generic/pgalloc.h        |  6 +++++-
 2 files changed, 5 insertions(+), 12 deletions(-)

diff --git a/arch/loongarch/include/asm/pgalloc.h b/arch/loongarch/include/asm/pgalloc.h
index 248f62d0b590..a3f93a8b58be 100644
--- a/arch/loongarch/include/asm/pgalloc.h
+++ b/arch/loongarch/include/asm/pgalloc.h
@@ -10,7 +10,6 @@
 
 #define __HAVE_ARCH_PMD_ALLOC_ONE
 #define __HAVE_ARCH_PUD_ALLOC_ONE
-#define __HAVE_ARCH_PTE_ALLOC_ONE_KERNEL
 #include <asm-generic/pgalloc.h>
 
 static inline void pmd_populate_kernel(struct mm_struct *mm,
@@ -45,16 +44,6 @@ extern void pagetable_init(void);
 
 extern pgd_t *pgd_alloc(struct mm_struct *mm);
 
-static inline pte_t *pte_alloc_one_kernel(struct mm_struct *mm)
-{
-	pte_t *pte = __pte_alloc_one_kernel(mm);
-
-	if (pte)
-		kernel_pte_init(pte);
-
-	return pte;
-}
-
 #define __pte_free_tlb(tlb, pte, address)	tlb_remove_ptdesc((tlb), page_ptdesc(pte))
 
 #ifndef __PAGETABLE_PMD_FOLDED
diff --git a/include/asm-generic/pgalloc.h b/include/asm-generic/pgalloc.h
index 051aa1331051..a1de7d246754 100644
--- a/include/asm-generic/pgalloc.h
+++ b/include/asm-generic/pgalloc.h
@@ -19,6 +19,7 @@
 static inline pte_t *__pte_alloc_one_kernel_noprof(struct mm_struct *mm)
 {
 	struct ptdesc *ptdesc = pagetable_alloc_noprof(GFP_PGTABLE_KERNEL, 0);
+	pte_t *pte;
 
 	if (!ptdesc)
 		return NULL;
@@ -29,7 +30,10 @@ static inline pte_t *__pte_alloc_one_kernel_noprof(struct mm_struct *mm)
 
 	ptdesc_set_kernel(ptdesc);
 
-	return ptdesc_address(ptdesc);
+	pte = ptdesc_address(ptdesc);
+	kernel_pte_init(pte);
+
+	return pte;
 }
 #define __pte_alloc_one_kernel(...)	alloc_hooks(__pte_alloc_one_kernel_noprof(__VA_ARGS__))
 
-- 
2.54.0


