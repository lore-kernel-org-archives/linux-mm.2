Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 34784606A32D
	for <linux-mm@archiver.kernel.org>; Sat,  7 Nov 2026 04:32:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=google header.b=epSrMiP0
Received: by kanga.kvack.org (Postfix)
	id 17F886B05B1; Fri,  6 Nov 2026 23:32:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0E1A96B05B2; Fri,  6 Nov 2026 23:32:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EC5426B05B3; Fri,  6 Nov 2026 23:32:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C86676B05B1
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 23:32:10 -0500 (EST)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 4A59B8028E
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 04:32:10 +0000 (UTC)
X-FDA: 85407050820.18.935D9B1
Received: from mail-pg1-f181.google.com (mail-pg1-f181.google.com [209.85.215.181])
	by imf09.hostedemail.com (Postfix) with ESMTP id AD55A140009
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 04:32:07 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=epSrMiP0;
	spf=pass (imf09.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.215.181 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794025928;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=K3n9ukDrxII5BXz/7vbmrUFxcX10DGV7r2as+LtHfBI=;
	b=4eXPczqUXeFXtVeMF18q5FYl0DSqYLbmfRBCBgmXcfbDzaRV55ScWk3DrXTdKXiEY4VM2b
	eP0CRTztvZM9in/a6h2wJKFIMD4SNC3mYwrAAyZM/gU0fBU4iARJYesL4CIHoM3E+CdAv8
	Rja1XXj9PbdnQFU0UAhP0NVgXF5/Ry0=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=epSrMiP0;
	spf=pass (imf09.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.215.181 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794025928;
	b=Lbn26Ec2LNRnuzEuwr1tFc/ym6uNOzMTtE2j8a5Qhiw/228AyKvicv6q59QgSbya6pezba
	TC0bwOIpsIEyobDme9zngHEHKHDw54wy+OTIfF3w70vHXv6AOcKInwtCC+YO7CZ4Gzlgi3
	jjY61E4B61Uno7ZcicoW2EEY3LtCOqM=
Received: by mail-pg1-f181.google.com with SMTP id 41be03b00d2f7-cdb2dfcca94so530616a12.1
        for <linux-mm@kvack.org>; Fri, 06 Nov 2026 20:32:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1794025926; x=1794630726; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=K3n9ukDrxII5BXz/7vbmrUFxcX10DGV7r2as+LtHfBI=;
        b=epSrMiP0oVxIRCAZKqRyaX7sh0w41r+WqOSnQew1BqR6NxBJjp17XOI+56csWGQmJA
         6UbdDQam4WyZ7eQwC6QhIq6V9oPJDfjlJI6olgWpti/loRpbQ97aSaXlmVv2L8Y+EgAH
         lVsOe+FE1BHLbh91p+9bygewyzFIVq6l0edJEma2FEDEDk14KInUiErxDJJSIz+CTTtt
         6xi9RHJudDY9ZPDx0DctcBLgfd1DtdJDZ1iyA0x3/rmAhdjHtExz4tQ5bKgyzfkMGzcQ
         RyH0CQGQ5ik94+R4T6swaGjUKmATjUZZm31uIIW52kYpX+AqSB5g4bV5jok+MbFRMFHA
         nEMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794025926; x=1794630726;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=K3n9ukDrxII5BXz/7vbmrUFxcX10DGV7r2as+LtHfBI=;
        b=bZXRmT9vFWfrJHFoo6mJmEOZ2sje0OGaVJ//UIbDOnhYz6EzMEvkhvi+MsmB8ywpTm
         crqsrwpjBBlJDnfHPNfBI0glSdiNoI71BJamtWg7QZKQ7+J3BjojlM6cC6gonojafLCa
         oWrKX5r8ODh2ftffDGNub76dDSghn7rga9Q61HydylDIgXw5En41GKicGuL3t+tb2Ug2
         HxkDymghgrmGEimfm81R34ZYWO+/1zndKv8uRXs6gkp5wCl4PH61i02f2F8LkVOD/EXK
         GErvdV+r5302r09yHhvb/smd2vqjBmSDFWcdf59p/U7Zl2aJel2PLRRPE+BSDtXugsQN
         iB1w==
X-Forwarded-Encrypted: i=1; AL+hErGzCyVqDrBlqRm7oehviI0HJcMUKM6pQLTZTcKqHoAKRoX8LBhRlIrc5dyTyH29X8MsAZRo9nQrIA==@kvack.org
X-Gm-Message-State: APuU4Z+ILTkmA/0JLxq2cdjDSH1p/ZWjTS6iUixveXB9I5hg8uyUPzBa
	YW7K4nTH5jwQVQFAJ84Bxx3dsSAQSC4pJfr0Qr3g+K3n4pl8rY20u8D7EdlMa+bn/Q4=
X-Gm-Gg: AYBFou05kgzr8/djnSx5Txxfw2QoG473VNgopQX+Uzhje2iVw/Beankm2hQBjTXNS/3
	e6CqDLObT4DBmZoNldNUVb8mWyPA6OWI8Y/TvYjPGoiCRZDSjzVYT2CPmCfDJ6y4OR2qrtHPRw8
	jwbGuz2+W9//nI9SOFCR7W8nlgS0H7gq5rDV5cOzfKymp3gI/pdXYsXwuTNY3PUgkexm+Y1/eBj
	DnjA09B7n4yKZRzo4n5GbGBwcZZGvz0KrkrQHLY5c1qn7UWit76Iy3Por87GLobLOAxWlR121vM
	78e2CVuS9ZHlrK6CD6fjRvEMyyS8cBCvFCVpYIRgz68WjRukT1kGUKFvBT6rbgQDgMzXS7jThIl
	YP/VJkYw6/3MA34c/U0SwkW3jRFKBNRfybe0L61HJtP1ffhS0mR1cznld0mZGQBRxlwba0IiH3/
	AXWS/9PVyOYyfbpfBhe1OxjrX80igWUjhTlP4w8SE3ecejAMw34wUmlv0XIstm4LYK2bU1kJPIB
	4K8wDbK2JmbU+40fsA3zRHWJYYcM89W4/sD9jIqs9ZcI5oa7Rj5idxDgci1tjv9NfIAUl0Y3gMM
	aEpjC7oXCvYA4pW08fR4n4OReiAvJRpn6BNDA7zZI2xAni0eWZhwkaW+BFfm
X-Received: by 2002:a17:90a:c107:b0:3ab:36c4:b4ff with SMTP id 98e67ed59e1d1-3b0db6b8083mr4981632a91.24.1794025926246;
        Fri, 06 Nov 2026 20:32:06 -0800 (PST)
Received: from G6L4RL2QG9 ([2409:8a00:1832:6900:c8de:13da:804b:a0fa])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b10584b66bsm1578451a91.14.2026.11.06.20.31.57
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 06 Nov 2026 20:32:04 -0800 (PST)
From: Muchun Song <songmuchun@bytedance.com>
To: David Hildenbrand <david@kernel.org>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Mike Rapoport <rppt@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Lance Yang <lance.yang@linux.dev>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <chleroy@kernel.org>,
	Ritesh Harjani <ritesh.list@gmail.com>,
	Shrikanth Hegde <sshegde@linux.ibm.com>,
	Oscar Salvador <osalvador@suse.de>,
	Qi Zheng <qi.zheng@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Huacai Chen <chenhuacai@kernel.org>,
	WANG Xuerui <kernel@xen0n.name>,
	linux-mm@kvack.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-riscv@lists.infradead.org,
	x86@kernel.org,
	loongarch@lists.linux.dev,
	linux-s390@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>
Subject: [PATCH v3 1/5] powerpc/mm: make vmemmap_populate_compound_pages() static
Date: Sat,  7 Nov 2026 12:31:18 +0800
Message-ID: <20261107043122.25650-2-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261107043122.25650-1-songmuchun@bytedance.com>
References: <20261107043122.25650-1-songmuchun@bytedance.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: syd6rfxf7obp9rc5do6is3yjiusxkp8w
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: AD55A140009
X-HE-Tag: 1794025927-783983
X-HE-Meta: U2FsdGVkX1+72NpqzI158gcehLNU0qwYXP9rDAtIDV+qXWCN0DJt1BXRxw+fmu01G0WYoHurzOm2/gASH8cPoG0tqEpu3wzFDueHidCnvo0xib0thpoPHWhDSATfe+h43Z9puPEodK/fvH43tevtFe7wz1hM6vtUMVX8FJUYKCALUXrplf9hnZRJRSlAoK0sqzIGYjiIBC9O/URCoT6BJDymuh+CeTbiqzwl+BwUqNSsI4WZ7883tdt60JNNFzTicXzy9jEwrmaqhGhV0GGW/4GJswDlbsH4znpoY70ed89+kt0+e6JUcbxLAlXVA6mfBnbMEmxnufoYGwYE+8B32fBItmCW8vHrTpzdiKUdYujlW4yR5/uk6wnB3gJfDxMFOl3lIMekXF6i5MHqMjezGch/xoqjaR0I3Jeft2VKOR9ygz0Gt/O4ae8CgATfHNgBKYB9/Lid3KkdYZ8ekjXDdg5V+kaWUjatqMELyhwzYmPMZIrpuYzN1WTKmd1+Nzuy3A+xLn2HfsKLowJyrVIonwvn8MCoKyLaB46Jboxm0jy55Qruxr3+CW0rPC1BMd5fUItSbTR/Em6J0d4fwau0/SUcry5CcipKhfkY5dmj6vPuvVSSTogj5VfeWkTzPAl04VsBP7no/9gCWWiTbvTX4hN7V/zsA2+gzSkODk749P6W6/xdJlQiPL9FwMSpUfZPANWq5y0/TpsGPt+4zv2NitRBe9wm2XW8K6nrowc0VToB6oOPJH0gzPk/Pp5sSFFs13Dp8XcK8br8bFvrbEBgJVqtmhp7JSOAWTBovN5/7IE9mLyc+0rjKEVjcAHiSPO+guyZpkm9ydSaHs90/fp86953Cf3wnBQsE1RNxLaVl/Uga5yNfjy4uMwspgvl27RhhHxH7nmo6T08zTfDzLj6Ei1IVhFQ1sqk7zmHGLZTVoR6d3J9pBRBsxtpCdlTJtgwAnSxjYglE3Vg/YUb9WS
 cA7mR4LI
 qjJFD49rixY/IQo7Nwg2iS1bOsdH+dX+OQb8/9SBecDuhGdugLr45udPi26nXBF1ei4IkulTpy7NdaPN9I6KFMYcFYF7ofuFMwITkxtTFQ/aN7nJI868vcpZsmo2bik2ePhTGoOEh+XVYqwEwpu4pit5QG6pMiwvp8FKmrwL2sfCRr0BOgr3Osnc8tE4mlSFTdfOn7V4eunYRi0E3eDSyOpuDhqmtZJLfrQG+cD6p2UFMAdaUtoaUzGkUcLjNWMs8XTOStBMtewXV11RpeMSBRD8yUFdHPIUcnbS87cSdMi1I3IEM8Fdx8n9GH2XZazGevaIfy6IhRzHPwAbPG04xMHwG72it1Xf36RK2M7KH0rJxHnp5z3NELNND2DUQp3kM4KTbxiQ1TgIzZF7PbI50wHQ8uLlboMcJSqazHcBoc2scGUOlrb4ebMBUmKS8RdBlJfdY
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

vmemmap_populate_compound_pages() is no longer used outside
radix_pgtable.c.

Make it static and drop the unused dev_pagemap argument from
its only remaining caller to simplify the code.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: Qi Zheng <qi.zheng@linux.dev>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
---
v3:
- Collect Reviewed-by from Lance Yang
---
 arch/powerpc/include/asm/book3s/64/radix.h |  6 ------
 arch/powerpc/mm/book3s64/radix_pgtable.c   | 13 +++++++------
 2 files changed, 7 insertions(+), 12 deletions(-)

diff --git a/arch/powerpc/include/asm/book3s/64/radix.h b/arch/powerpc/include/asm/book3s/64/radix.h
index da954e779744..8452a2714cb1 100644
--- a/arch/powerpc/include/asm/book3s/64/radix.h
+++ b/arch/powerpc/include/asm/book3s/64/radix.h
@@ -356,11 +356,5 @@ int radix__remove_section_mapping(unsigned long start, unsigned long end);
 #define vmemmap_can_optimize vmemmap_can_optimize
 bool vmemmap_can_optimize(struct vmem_altmap *altmap, struct dev_pagemap *pgmap);
 #endif
-
-#define vmemmap_populate_compound_pages vmemmap_populate_compound_pages
-int __meminit vmemmap_populate_compound_pages(unsigned long start_pfn,
-					      unsigned long start,
-					      unsigned long end, int node,
-					      struct dev_pagemap *pgmap);
 #endif /* __ASSEMBLER__ */
 #endif
diff --git a/arch/powerpc/mm/book3s64/radix_pgtable.c b/arch/powerpc/mm/book3s64/radix_pgtable.c
index ebac5f9058f6..2924604fbb38 100644
--- a/arch/powerpc/mm/book3s64/radix_pgtable.c
+++ b/arch/powerpc/mm/book3s64/radix_pgtable.c
@@ -1117,7 +1117,9 @@ static inline pte_t *vmemmap_pte_alloc(pmd_t *pmdp, int node,
 	return pte_offset_kernel(pmdp, address);
 }
 
-
+static int __meminit vmemmap_populate_compound_pages(unsigned long start_pfn,
+						     unsigned long start,
+						     unsigned long end, int node);
 
 int __meminit radix__vmemmap_populate(unsigned long start, unsigned long end, int node,
 				      struct vmem_altmap *altmap)
@@ -1132,7 +1134,7 @@ int __meminit radix__vmemmap_populate(unsigned long start, unsigned long end, in
 	unsigned long pfn = page_to_pfn((struct page *)start);
 
 	if (vmemmap_optimizable_order(pfn_to_section_compound_order(pfn)))
-		return vmemmap_populate_compound_pages(pfn, start, end, node, NULL);
+		return vmemmap_populate_compound_pages(pfn, start, end, node);
 	/*
 	 * If altmap is present, Make sure we align the start vmemmap addr
 	 * to PAGE_SIZE so that we calculate the correct start_pfn in
@@ -1228,10 +1230,9 @@ int __meminit radix__vmemmap_populate(unsigned long start, unsigned long end, in
 	return 0;
 }
 
-int __meminit vmemmap_populate_compound_pages(unsigned long start_pfn,
-					      unsigned long start,
-					      unsigned long end, int node,
-					      struct dev_pagemap *pgmap)
+static int __meminit vmemmap_populate_compound_pages(unsigned long start_pfn,
+						     unsigned long start,
+						     unsigned long end, int node)
 {
 	/*
 	 * we want to map things as base page size mapping so that
-- 
2.54.0


