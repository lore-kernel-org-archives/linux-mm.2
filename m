Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4910FC54FDF
	for <linux-mm@archiver.kernel.org>; Thu, 30 Jul 2026 09:07:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C711E6B00A4; Thu, 30 Jul 2026 05:07:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C22406B00A5; Thu, 30 Jul 2026 05:07:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AEB106B00A6; Thu, 30 Jul 2026 05:07:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8696A6B00A4
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 05:07:23 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 194CE160926
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 09:07:23 +0000 (UTC)
X-FDA: 85044864366.30.178345D
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	by imf28.hostedemail.com (Postfix) with ESMTP id 580A1C0006
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 09:07:21 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="j7b/FXE2";
	spf=pass (imf28.hostedemail.com: domain of xueyuan.chen21@gmail.com designates 209.85.214.182 as permitted sender) smtp.mailfrom=xueyuan.chen21@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785402441;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5hdCu1wf2k5fVGlVM7jRlnxeinlriHXvmsiXxLfmcKs=;
	b=KpYVhROdVRu7mDse+RTh004GlxTi2/qFfz1+6VlAqFSaTX+yGWBOJsqm97ngBO8/AYtQWA
	92rAwACFsEP/0pe+QbVz7of6muAb/kBeYvCe2fsdTq0C0gV4ZnfZxQ94h30PoXUKCq8YBy
	YGMn8OpdWJb1nHjaXrVSAqhqFz2hVYk=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="j7b/FXE2";
	spf=pass (imf28.hostedemail.com: domain of xueyuan.chen21@gmail.com designates 209.85.214.182 as permitted sender) smtp.mailfrom=xueyuan.chen21@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785402441;
	b=mGUgKgrIi5pIqNvhAWAlvth2ovCdsI/ax+r18rzGysTg5AE3hm4fvObhg+RT/5ajvXGq1R
	lceQkEj8pxtiEIu4AuT6ENh9Duh1emgssTGaGITi7fRcvSccN0Aj55HlB6phykU1Vtd2Fw
	d+Aj2LADVcO0lQ+hArptRkgp4VMZVu4=
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-2ccae46de39so2279635ad.3
        for <linux-mm@kvack.org>; Thu, 30 Jul 2026 02:07:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785402440; x=1786007240; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=5hdCu1wf2k5fVGlVM7jRlnxeinlriHXvmsiXxLfmcKs=;
        b=j7b/FXE2tZqFxE/rn1gjF8aHI8GHHEN7hZaBN51q1EyHE5drqERm+ZJiU7WNduTu77
         vQn0vhLB8zNfBOvszE8aFFccXYnswFVwF5wjCADRqbVWGSzoEXVhZ0WbV+Blqueq+lAN
         6e8gaoM9L/VHCBwH2ZJp7QTf4d7sVGx4/8WZc2ixHr3uUEV1wwl1sgBt6EfrwWzPasUw
         BBKrK2NFKKu322/uenKqTjsdHNHhwqdUR5X8R0YE8R7heXdUW6qyq9MmFSFS5eo4tkM5
         0WCW9eLoRKmeHmHJ1AxhzBntnyUsLpONysDHOuS790OGv/DqVi44sHBakwsh2Kj7hOJS
         jIOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785402440; x=1786007240;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=5hdCu1wf2k5fVGlVM7jRlnxeinlriHXvmsiXxLfmcKs=;
        b=Ke3M0k+HX5jMsChvNuw9lbdrYmTpvMLNwLxQktmM3d5I8zv4vho9FoEfjgkQnSh1oS
         RGBtuPD0u/BMUsuNDw8X9p1Vy9gMG/gfjTi8kEUIjf9ImywpJRicrIeZq+3J12X/1M+E
         hZuZVta7HlgQSsF3ay+mluPAsBqdAxdUzjf0JvzyAUNNZq/eHbQcmXuTtFwXxN0seDE8
         RuQ7YCKUhrhHihi0YtShIDuDONgmdfHS1fTYdBkELhujvQs1d0PNyuiNEgdA66OZVdch
         TArewG1yujwAdi1kFNy+PNE9u1Qh96YAViEengXUvFZ4ITylc7BppG7JDZPiIVYFIa76
         lmUg==
X-Forwarded-Encrypted: i=1; AHgh+Rqf50A4VC/QqoXM7fL6JJgFfxK9MXMdP+5gQG09JyVIu9GUu4a1+EvyqAdbfQeZn61buAy0WYu1mw==@kvack.org
X-Gm-Message-State: AOJu0Yznl/QV/nwD+VEM5UmhFhMePirgV2wRWFnUtyFgVX97wtwsje9v
	jh0pkK9+w6gvpelWozWApAqlVx0QmBXw1lrfH2DGQtVNJRRKQL51xsE5
X-Gm-Gg: AR+sD12B2jKpAQHIe47Kvw58Jj7en7faV8R6wrM/2lZYk7h8fnztQHjAeYraVu2lIxc
	fmU5q8GBkmYU21Bw0b5vp3+v+meoD26Z/sKK4jEklIZl8q1152hwrfxVfIbhpuofObIZ4XJcrep
	BvahiF4aWZbGPAEkxVR9J3DnB1vw81tczmcD7EkOOSU/RVidsDSVF9yGfoDsPn3xduJfr3IbjaM
	B7oFWq3NHISP5cVc/Xwki70KCncWehFFqFhBlip4uizT3jkOytKxWYH+W5ygECaLVqvf0n3FUWW
	1Fi/fR5Mvomj/4pGBlC64b41RZdvuyhIEVd788jmI+4jvwW0E+Xqt0yNnVo3dfwR3ShM7it4jdm
	VLehphU6+zX9yfqeYdnOfyvaJZ0THWYZzVX9z60It2MuaMa8hoD5bYSEmwQdgt22D3IbLcrRgFq
	FlNGhjXbsY3Zi+BYlJZ53Zv9VlSjy+qvEPgdVeMmvAcVoeHYAfjgylAT01ZoMbfoWFMjpWttiY8
	rMl+4XsA+STahSshhUj7vvYPlxEZADqM48/wUe6O/l/NLj+FPnu
X-Received: by 2002:a17:90b:1c03:b0:381:2788:a437 with SMTP id 98e67ed59e1d1-38f9bcf6724mr2133282a91.1.1785402440025;
        Thu, 30 Jul 2026 02:07:20 -0700 (PDT)
Received: from debian.lan ([155.117.85.23])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cbdba447107sm1902510a12.21.2026.07.30.02.07.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Jul 2026 02:07:19 -0700 (PDT)
From: Xueyuan Chen <xueyuan.chen21@gmail.com>
To: akpm@linux-foundation.org
Cc: david@kernel.org,
	ljs@kernel.org,
	usama.arif@linux.dev,
	catalin.marinas@arm.com,
	will@kernel.org,
	linux-arm-kernel@lists.infradead.org,
	tglx@kernel.org,
	mingo@redhat.com,
	bp@alien8.de,
	dave.hansen@linux.intel.com,
	x86@kernel.org,
	hpa@zytor.com,
	rppt@kernel.org,
	ryan.roberts@arm.com,
	ziy@nvidia.com,
	baohua@kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Xueyuan Chen <xueyuan.chen21@gmail.com>,
	Lance Yang <lance.yang@linux.dev>
Subject: [PATCH v6 3/3] x86/mm: add set_direct_map_ro_noflush()
Date: Thu, 30 Jul 2026 17:06:47 +0800
Message-ID: <20260730090647.2401252-4-xueyuan.chen21@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260730090647.2401252-1-xueyuan.chen21@gmail.com>
References: <20260730090647.2401252-1-xueyuan.chen21@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 580A1C0006
X-Rspam-User: 
X-Stat-Signature: hcbtdbx7jr7ks1y5af6pmme46wr7hazo
X-Rspamd-Server: rspam04
X-HE-Tag: 1785402441-580192
X-HE-Meta: U2FsdGVkX1+tmRQt5Yrj2CKDUJySb9PDZryYHM/KhplskWwlwRWRHvuc91SqHfn6ldGLE/t1QqMQxFRFauV/yA6qZpm4U9G8cFPUGio8+bHSLb5DOMBrzZ9C4WM/MRWi6D7HM0f7N2HmJi386/sQ59eLMvZMTMLSJgmBy68X8Hh828Rgs2CL5nkPWPVS1jTsVhtizgt0UJXyXhCzgHl8pU46A4C6+AddKF2od7dPXcnHdx5M1ceHDXhh2mASEALtEUUmXLK78cSsxvtnAVE9vax2ObEH2hY1Jz5iw0MfPBXXKmikY6sQnoV5KGVDQFzgLn9IQaPopcXlLYXFfkuyryLSyxpP7eNPv98YF5kYsSV1OudqzXGnvH/3oFrXUbzkYKU2alb9mnY1WcTF8cGwgnjwB+fP/aqOjjsavjbbaLZKLAazTEK3kRFfBOLeKuU9NNP4RY0I0InGZNdQtF0bXUUdPcZAY9SBSUol/sIVBvJEyMd0ewWKJuhiJEr+aeW4QecjlqauNaV1BKE67P6CP27IPP5Sp/MeadDshD8YT1Zvc7HTZItoG/eDE6Hagd//y2pWsmI6ZxJO0TCG7M2cKuAP861gCjUMT0OxIDBEZfSY1U7BYvy5NBapg41Dn6/1pPvciUx3W8aL27NXS4pnpC9BSK5rHNqUBM+M5iS9Imins8yijqB8FTfFplR4k4tUP37DIWn+POYLHRzgbanWR6jxW3nGM9OvjWeVZIyXi1gchXWkfAaS8x4bv9yT9wrB8hhobPotx+xLEK4SeBzPdiYygU//FMqmGC3z3gMMLgtZ2+HQcSp7FuEE6+P9rpw7W1U18/Kznml5Ko9VKfWRkD99WgjQOtdIsOKgT+bICDdnRqSNSjSnM0A9uBqULO4c+XkJ0lbv82aC1KwXKt596+7F5q9nvJL8uG6bKAHCox5yuy4eNiYK6TrSNo//AiGErL7u4vdCq24i4Ceu1eI
 Gy2XnE7a
 Us74DTdrySbalGFo6r1i6C+PodEkTZPQqbCYHG+1zU06Y/CdBDRk4fy5oz4chdDeIz8BYZhenbroDa96mai+jp9xGfCYyDge12/5ku9PtwHaeCZIKx5BUAWiZ2ntx15TShIKeJt/pJlUiyH0tVL9ig/auOd633yDe+XDpW50Gc4adby8O3wDGzzf8wGwgKpKXL9GrEk+11P/BpNHYGkRFe6eM6Nw951lvfXJRQmWI3Bl9nWgY76nXZYIYc8XCVxxvX1W3EaMpONPlN6uWTQJPfxDiRAk7w31UPHN4m9uPlMp6KSqoMIPtvBt6IYmBj9CxGNzudEj5J3Z5A/JVWPf+LtknWI5SKyI2ZvZR5LTTXECOsTn03o7Q7tvubuAJNTLh/K+oobuFymcN4CVbeiQOT8rba+GNLWhWTBRr2M74Kmd5unwJM8JgydrfduzxdazGLZZA7NOLolDR6M4PpmoIKRe5z20HhOIPzYmUXIEroGCYKTcHqUIKzx5PasXC2VO6q0M/OmOybZ+dNw2f60AAEjouMOKU4HtpfHiz
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Implement set_direct_map_ro_noflush() for x86 using CPA directly on the
passed direct-map address. Clear _PAGE_RW and _PAGE_DIRTY, keep alias
checks disabled like the existing direct-map _noflush helpers, and leave
TLB invalidation to the caller.

Co-developed-by: Lance Yang <lance.yang@linux.dev>
Signed-off-by: Lance Yang <lance.yang@linux.dev>
Signed-off-by: Xueyuan Chen <xueyuan.chen21@gmail.com>
---
 arch/x86/include/asm/set_memory.h |  2 ++
 arch/x86/mm/pat/set_memory.c      | 15 +++++++++++++++
 2 files changed, 17 insertions(+)

diff --git a/arch/x86/include/asm/set_memory.h b/arch/x86/include/asm/set_memory.h
index 4362c26aa992..bd3817e06052 100644
--- a/arch/x86/include/asm/set_memory.h
+++ b/arch/x86/include/asm/set_memory.h
@@ -89,6 +89,8 @@ int set_pages_rw(struct page *page, int numpages);
 int set_direct_map_invalid_noflush(struct page *page);
 int set_direct_map_default_noflush(struct page *page);
 int set_direct_map_valid_noflush(struct page *page, unsigned nr, bool valid);
+int set_direct_map_ro_noflush(const void *addr, unsigned long nr_pages);
+#define set_direct_map_ro_noflush set_direct_map_ro_noflush
 bool kernel_page_present(struct page *page);
 
 extern int kernel_set_to_readonly;
diff --git a/arch/x86/mm/pat/set_memory.c b/arch/x86/mm/pat/set_memory.c
index d023a40a1e03..5987f4c84f6f 100644
--- a/arch/x86/mm/pat/set_memory.c
+++ b/arch/x86/mm/pat/set_memory.c
@@ -2662,6 +2662,21 @@ int set_direct_map_valid_noflush(struct page *page, unsigned nr, bool valid)
 	return __set_pages_np(page, nr);
 }
 
+int set_direct_map_ro_noflush(const void *addr, unsigned long nr_pages)
+{
+	unsigned long tempaddr = (unsigned long)addr;
+	struct cpa_data cpa = {
+		.vaddr = &tempaddr,
+		.pgd = NULL,
+		.numpages = nr_pages,
+		.mask_set = __pgprot(0),
+		.mask_clr = __pgprot(_PAGE_RW | _PAGE_DIRTY),
+		.flags = CPA_NO_CHECK_ALIAS,
+	};
+
+	return __change_page_attr_set_clr(&cpa, 1);
+}
+
 #ifdef CONFIG_DEBUG_PAGEALLOC
 void __kernel_map_pages(struct page *page, int numpages, int enable)
 {
-- 
2.47.3


