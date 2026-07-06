Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6F88FC43458
	for <linux-mm@archiver.kernel.org>; Mon,  6 Jul 2026 13:06:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6949F6B009E; Mon,  6 Jul 2026 09:06:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 66B356B00BC; Mon,  6 Jul 2026 09:06:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 580E56B00BF; Mon,  6 Jul 2026 09:06:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2C3866B009E
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 09:06:34 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A9DE41C2ACC
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 13:06:33 +0000 (UTC)
X-FDA: 84958375866.24.10FCF6B
Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	by imf28.hostedemail.com (Postfix) with ESMTP id DCD3DC000F
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 13:06:31 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=IDfHODXG;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf28.hostedemail.com: domain of xueyuan.chen21@gmail.com designates 209.85.221.48 as permitted sender) smtp.mailfrom=xueyuan.chen21@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783343191;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=d8qKUeLq0Xc1diZzeHtvK61x/Xi1I1bUFpJGekusuPQ=;
	b=I2CB2QlouNs3ZqQ1FFGzvHiEcgUvPfkDZIB7pwaJTnL/vW6OXTC2u1nWpClEQxfv6FIovL
	sqhzwMTfrLMT5vXcULQ8uozPoKwYhMv/wKhOyO4NJOh6Q1aGh+ALdma7iAU32AoDz/xrf1
	ASygYid/sC03AkDzFjACEBETCYkXQSY=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=IDfHODXG;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf28.hostedemail.com: domain of xueyuan.chen21@gmail.com designates 209.85.221.48 as permitted sender) smtp.mailfrom=xueyuan.chen21@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783343191;
	b=fOAnJZkAyc2/ZNx5Q1WlYHJ1v4l8bC5fa4PjI6hYWdwShv0rNhc/vcUJpN0ZD9IPGIJ06e
	DAKyuM80Me4Tpt+TQ4UFW6eoTPbKhU9ksE2gQ2e//0b2VwuXjX4wQnbLrXDz+65RQwt3qG
	Bf8wLJsIZfzYTGsq3UpiGqrgTK+bKnE=
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-472c021a608so281291f8f.3
        for <linux-mm@kvack.org>; Mon, 06 Jul 2026 06:06:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783343190; x=1783947990; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=d8qKUeLq0Xc1diZzeHtvK61x/Xi1I1bUFpJGekusuPQ=;
        b=IDfHODXGMtqqr1D9twPP/lBVEaTDQ72yFXm2vXO7JwZFRwnhgJuQnyN7WiyzumGmtW
         1NkLZvhcf7pbj1gs1StzHjy+ZwTDnam2vnYmKi6TFPhOGahTagyDBBcBu9dOCjJEB7lC
         F4dKd5+0tc4WnuBvJsenAQDfHpZiIlwsCFJkQw4U8cyBZ1IApbFPc1/2nhrJTwYMBctn
         YP/1ziKTsx8twjx6DzD+fg38yDBuoo2wNLskDMGgW8eFinojCTBcFbLTO8sNDv0oQt1V
         xAuioLYpIJ/nOyE1v5FiYhQE4NbCqIzeoZ0xvkx4g9WkjqADC2kpu50/tmFMVdCK8LQ9
         cIUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783343190; x=1783947990;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=d8qKUeLq0Xc1diZzeHtvK61x/Xi1I1bUFpJGekusuPQ=;
        b=tY6M8kvCnYS5gZcR6r/fXPbhCmMLbx8Fkt6+2QWmN7y2ncPJKPrwbPEwfm0DUfVJcY
         Qx5H7v5HXOs3yM+spyPDkFd9QPjZkS05RMkqhZnjX0SvUSTVpgapUvZ6M8sb5ZoKbuU8
         QBc9NPxtdPCZt42b22f5Gr8gs07E/ATPFId5jHy3UNZ5wTmALveHV+0fIMpE/gp8fbYe
         QehF+Tv82V5stdTR3fCjpIaMXg+4dfVtv1D8/X7L7DsjOjSzIiy83zn8bEQvm0xw/kOH
         DzMelkpbfnFnpHLwZkPyAQGLjDc9wt9HzcN2d/9gP6awToxLX8LdC/+7uypUTVPQ0yBD
         4u+w==
X-Forwarded-Encrypted: i=1; AHgh+RoAqj3qkeSx1PnE30m5h9uWHMHC1T72QW3wd/qnWmsLW+JuEKrSM1/XQVa+PP4I0FGHfxHUNcPwpA==@kvack.org
X-Gm-Message-State: AOJu0Yxucb9aVa/3pZAW3LO8Ytx3zYcMQnW4bakV/hk3PkkCosyatTd4
	3K11uM5ZvyM3106gJfZ8EWLMC8jaYTEBEVgJOSejmRbP9+3scPGEHO2w
X-Gm-Gg: AfdE7cn63vz9XOOfFOK9948CG/WBNWSPS/TmjeQRQSJXhC0ToJEC6YkxcGMSveN1OaX
	xy47h7+zh3Ezj5xujqCoqADaxkBPnywphKtbBRjWXUFkQmfDaDo6a3D0DCOKOxJPC+KxVJV+bM9
	/Kui65p8exNSPQDi0REAcG0BFcT05lISRiBsjOVfhXsiw4EjiObRlYKIDk4jOLaslYzdycS1vVs
	dp4N+9eyZxq4cL/XseuiKfhIqBcvHcSq+b2b4yxCgLEgQL4xjeH3KF3EWMQiRLuXbpPmgNrH1BQ
	ss3KGp1uoElJz7vCT/XOrqTikGfmkS7e4XsXrp46ogjQHB24hmpXO8vDAomqS6rtHZ4eH+1sUxz
	VsGcBPZ9C4LSotsdOuOOxFbJMoiuBwXDRXmdUrP5DWsri4kmDiTwIn6fP+09NgmK8Z5uu8SeAMa
	tvAuAzuNxr4STp9pHfT8YaECnA0rb11otTQpDMjcR6xjfEWsD+kM7gU9mvQIk2HpTA6ckciXLzR
	9gBzr/uRwfV+wqbWGgbOdcj+ADLWR+iadc=
X-Received: by 2002:a05:6000:38a:b0:47d:2a79:a2eb with SMTP id ffacd0b85a97d-47d2a79a429mr3756010f8f.5.1783343189936;
        Mon, 06 Jul 2026 06:06:29 -0700 (PDT)
Received: from debian.lan (vmi1894487.contaboserver.net. [154.26.158.71])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47a9de1d8f1sm24515956f8f.3.2026.07.06.06.06.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Jul 2026 06:06:29 -0700 (PDT)
From: Xueyuan Chen <xueyuan.chen21@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org,
	linux-mm@kvack.org,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Cc: Lance Yang <lance.yang@linux.dev>,
	Jann Horn <jannh@google.com>,
	Yang Shi <yang@os.amperecomputing.com>,
	Mike Rapoport <rppt@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R . Howlett" <liam@infradead.org>,
	Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	"H . Peter Anvin" <hpa@zytor.com>,
	Andy Lutomirski <luto@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Xueyuan Chen <xueyuan.chen21@gmail.com>
Subject: [RFC PATCH v3 1/3] mm: make persistent huge zero folio read-only
Date: Mon,  6 Jul 2026 21:04:38 +0800
Message-ID: <20260706130440.9295-2-xueyuan.chen21@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260706130440.9295-1-xueyuan.chen21@gmail.com>
References: <20260706130440.9295-1-xueyuan.chen21@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: DCD3DC000F
X-Stat-Signature: gae6q91wzheuty1pf3gu3titw9gyyudd
X-Rspam-User: 
X-HE-Tag: 1783343191-313870
X-HE-Meta: U2FsdGVkX19pNUTRyzXyYR6wzbyjzeps0j8l3f4kR8ATXIUFK6dRxZlIc1Swvj++C23fW3PYsWRYN8SkO7y3XZ62Zc4xbgujbhADi9oqfnJm3EzDOu31HaSdUQyypqjHUBhinUs14sTHWt8vxEnPSp8NCpWIHtyKgZbAF6g1JqMr6hAhuNZ/YGlv9MGV7JSdB8fDmBv+eZyqEy8Bga1QKgy73SwtjBzuCoOeppVU7kAcAXiHLPuOZpN4h/9oO2zSGKHRTD/NLRs0PR1y2pxFEQm9+sDTcVIzbBmN26M6KZmrzqK75fVe2l3IIXXsaIiTTF80GaxyWIHnEM+ehtkbzkvfEhOMpSdZVp58gZklbIfJN+apUFvhgyqJM+4hbkwtTsHjsY55WW2H6jFJ9fs4XDYWRLA/G+IZeUikb3azTvW2C1SDUEKOZ2m4Uor7b9jtvA4cFQ0o6bpPFTlyN2ZTjB3V3a3refxRmpy+6HE2gYiM8V2Fbs9YdGIr9G60Uvlfs0LHoKxfpiTwILoVm7MFqMhBTyrSICvh7Go46mb1dfZfmXgm/QVgktRzyrlWh0kV6Cr5vpSuAdC4etzelOQuqPuhIIgSdxF88mYE8cCOhHpGXPhxex63Rj4JkIHDXOOF3kxQoysrg4omFjcn2ujfk61OeWLY2iW+yilQEU1zvWtE+gKAxp7y+JpbIuLetaHMbJs7ZykZzoVwaC2MgbavttGkuAS8ob+vMtUZ8bF8MmOMLNv5V4Y5QgHCmN+51N0UdnddrR/Wha8TAVAr2UlkwaRFhR/SE6UY6ohDeALLYkWI8/wfym6UP12tIWRnFrGjHU2xyTbobqVA1yaLVIMKVVTLWzoS+sUYU9IUDHqnTrRjvL64peSoRKwvYdktwVqUxgxVk9Rn63ZMB7/R2z9z7gMFHqb/FfuOZGV0Gj4o9zRuXledMujW3LNYp291xd3KzayzRNjRnI5pxOj2nmw
 vnc6pw+b
 XQzMhPuCBZaJSPxsq0HSAQVuluXuOTujjjHUx8PQDb1n3sADX7E5kppvfrxdTaHsLxlxuaE1sIukJ3uavLlw1XYs49UJ1H9lcpQS/J3zKyDxk3RFgIhg/93FTji8IRKWCJ31Pf11dilfV35Jl2YLvkRJP2VWJcZUsI+UKzLO90zD8xOVbuH4eltuk5RTkyWRMiV5syQsqf6s9+r1coyiiEF//A37T9Dw2+S4N0+LFaEu2TbIeld0By8uvnREqNaX6lFOkDTSf6DJMKe3Vclhyf/cWjV1lMYp2YWLlpfhNYCgOsw8DjeGSPtXiIjgcQEeM6foqhTIiCUs1C1/Wrxh3J5Mcs242tbqlhut4qRQg9mT5Y5AiybMCSlHMUXRgWfgVLTAEO8SoaKXl1+WpJqVhApauO6xteu+6iu8Qot+zFEZW/INjlC5NT5I1MgfdEv+NS/rheTDPTTeixvHN7iA6pIK9Misn2ySNNU5K0xx35A/NFBfbLa6Lajkf/Jq4Zv9R6EZN8RC7W8IHQ5b6TzJItvZA8HfNj4pmNoUb
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Xueyuan Chen <xueyuan.chen21@gmail.com>

The persistent huge zero folio is shared globally and should stay zero
after initialization. As Jann Horn pointed out[1], kernel bugs have ended
up writing to pages that were meant to be read-only, including in
security-sensitive cases. Making the persistent huge zero folio read-only
in the direct map turns such writes into faults instead of silent zero-page
corruption.

Add set_direct_map_ro_noflush() so mm code can make a direct-map range
read-only. Use an address-based signature to match ongoing direct-map
helper work[2], where existing page-based helpers may move the same way.
The helper is direct-map specific and does not flush TLBs. Architectures
without direct-map permission support keep existing behavior through the
generic stub.

Persistent huge zero folio setup happens during early boot, so no explicit
TLB flush is needed.

Inspired by Jann Horn's read-only zero page work[1] and follow-up
discussion[3] with Yang Shi.

[1] https://lore.kernel.org/linux-mm/20260508-ro-zeropage-v1-1-9808abc20b49@google.com/
[2] https://lore.kernel.org/linux-mm/0e5b23a6-4895-454a-9dfa-6dc21adc2991@kernel.org/
[3] https://lore.kernel.org/linux-mm/CAHbLzkrXXe7r3n3jXgDKtwZhRqj=jDx9E6dLOULohnhBguvi9A@mail.gmail.com/

Suggested-by: David Hildenbrand <david@kernel.org>
Co-developed-by: Lance Yang <lance.yang@linux.dev>
Signed-off-by: Lance Yang <lance.yang@linux.dev>
Signed-off-by: Xueyuan Chen <xueyuan.chen21@gmail.com>
---
 include/linux/set_memory.h | 26 ++++++++++++++++++++++++++
 mm/huge_memory.c           |  9 ++++++++-
 2 files changed, 34 insertions(+), 1 deletion(-)

diff --git a/include/linux/set_memory.h b/include/linux/set_memory.h
index 3030d9245f5a..a905074fb21d 100644
--- a/include/linux/set_memory.h
+++ b/include/linux/set_memory.h
@@ -40,6 +40,22 @@ static inline int set_direct_map_valid_noflush(struct page *page,
 	return 0;
 }
 
+/**
+ * set_direct_map_ro_noflush - make direct-map mappings read-only
+ * @addr: start address in the direct map
+ * @nr_pages: number of pages starting at @addr
+ *
+ * Make the direct-map mappings for @nr_pages pages starting at @addr
+ * read-only, without flushing TLBs.
+ *
+ * Return: 0 on success or when unsupported, negative error code on failure.
+ */
+static inline int set_direct_map_ro_noflush(const void *addr,
+					    unsigned long nr_pages)
+{
+	return 0;
+}
+
 static inline bool kernel_page_present(struct page *page)
 {
 	return true;
@@ -56,6 +72,16 @@ static inline bool can_set_direct_map(void)
 }
 #define can_set_direct_map can_set_direct_map
 #endif
+
+#ifndef set_direct_map_ro_noflush
+static inline int set_direct_map_ro_noflush(const void *addr,
+					    unsigned long nr_pages)
+{
+	return 0;
+}
+
+#define set_direct_map_ro_noflush set_direct_map_ro_noflush
+#endif
 #endif /* CONFIG_ARCH_HAS_SET_DIRECT_MAP */
 
 #ifdef CONFIG_X86_64
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index bdd8635922f9..6633217b10dc 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -41,6 +41,7 @@
 #include <linux/pgalloc.h>
 #include <linux/pgalloc_tag.h>
 #include <linux/pagewalk.h>
+#include <linux/set_memory.h>
 
 #include <asm/tlb.h>
 #include "internal.h"
@@ -981,8 +982,14 @@ static int __init thp_shrinker_init(void)
 		 * that get_huge_zero_folio() will most likely not fail as
 		 * thp_shrinker_init() is invoked early on during boot.
 		 */
-		if (!get_huge_zero_folio())
+		if (!get_huge_zero_folio()) {
 			pr_warn("Allocating persistent huge zero folio failed\n");
+			return 0;
+		}
+
+		/* Set up during early boot; no explicit TLB flush is needed here. */
+		set_direct_map_ro_noflush(folio_address(huge_zero_folio),
+					  HPAGE_PMD_NR);
 		return 0;
 	}
 
-- 
2.49.0


