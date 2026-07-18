Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1FADFC4451B
	for <linux-mm@archiver.kernel.org>; Sat, 18 Jul 2026 09:57:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F0AD76B00AA; Sat, 18 Jul 2026 05:57:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EE2B96B00AB; Sat, 18 Jul 2026 05:57:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DD1C16B00AC; Sat, 18 Jul 2026 05:57:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A65D86B00AA
	for <linux-mm@kvack.org>; Sat, 18 Jul 2026 05:57:20 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id BF2CA160385
	for <linux-mm@kvack.org>; Sat, 18 Jul 2026 09:57:19 +0000 (UTC)
X-FDA: 85001444598.19.532F89E
Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	by imf15.hostedemail.com (Postfix) with ESMTP id 04FC8A0006
	for <linux-mm@kvack.org>; Sat, 18 Jul 2026 09:57:17 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=XAHW+fLJ;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf15.hostedemail.com: domain of xueyuan.chen21@gmail.com designates 209.85.210.178 as permitted sender) smtp.mailfrom=xueyuan.chen21@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784368638;
	b=e1FDwz/Iw4QIgfbPDM4qVasQmputwZiecs888hwXVyEynfa6RK4qZ4/mXW+OEV0+CmZIja
	3jsb5vsY0sDcKbwUtonkmF0/Vuk+9T4V3sNTllutKD/v6gB7owEsqGx2+TmTQgeJuq6UNS
	o/t4rosFAy+MCe4DEwNEVOwyUZzZl/U=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=XAHW+fLJ;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf15.hostedemail.com: domain of xueyuan.chen21@gmail.com designates 209.85.210.178 as permitted sender) smtp.mailfrom=xueyuan.chen21@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784368638;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5hdCu1wf2k5fVGlVM7jRlnxeinlriHXvmsiXxLfmcKs=;
	b=ofCYSac+BeNeGPbkA2tG9Ls0HDfcQkt5lTZ67B9ogdBL5E32OtCyBAnV8Zg3bAV29SkHj8
	ZuyaUJCSn9snBVzwcRBPaMw/8VvZtzImp9VnVk2124oWycPNGgQyCsWoqxl5zERbKesoPd
	67vWE8EBQ2+4ciG41NaKofa+JBsf6os=
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-8423f52cd57so1185389b3a.2
        for <linux-mm@kvack.org>; Sat, 18 Jul 2026 02:57:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784368637; x=1784973437; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=5hdCu1wf2k5fVGlVM7jRlnxeinlriHXvmsiXxLfmcKs=;
        b=XAHW+fLJGRXrd4BJvRGRA3ou9O43eE+cRS9IiZK0SdkD8jLZycS+QMVqMaAzfLD5dW
         MuGhqmDnWnrh6Z8mmwyoyTXnUIRmLOEV5OMiTsT1RhJM3r94p8dNFNUEqWrh7vpoj4wA
         7jeyYcLDv6TjHxDkvmnVhT9y2YXENjx3nKG5uCY/qVI/RkKERSbJuLNGXil18EmuoDzu
         4eWwRoxgBWjJ6HsQgo1z8RYXfl3YuIqXAWXNLxmeKvTW1aSF3EmK/eOpqsu9oU0J15do
         La6RVV9YpRxNaVRmf2MY2E3BGUAWNbQ2G3p4chasK2WbnBUrjcpRj5/nUbJpFH7s0uYm
         kPZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784368637; x=1784973437;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=5hdCu1wf2k5fVGlVM7jRlnxeinlriHXvmsiXxLfmcKs=;
        b=jRp6Z9yZvbLGsuUVaeZt2BHu9MQ7OYXakhsmT7l36TlbJ3DtUcO3XT3bNW9d5dzjkF
         xXAXQb7jRsN9lew+1Dvg+te6joDy2uqkMbwWxQbYyG17IwNNRFz4sLJxPPN6JM+OWYBS
         gzHjhDD34MUHvivWQmlATqvnFLVc3lSTyCwlURdyJFF2+E/0jGR+WjIsyuVXO5JnMC+S
         TcwLuTYHB8+glbA7Gkn84nG/8E3Kw7h8puNoFSbbv8goNYUdqPmGQZ1u4LE1QLPXV/4q
         t5oQu8Prxi8O/gMdiPmwcLscvd1cGi2pAl3hMGG6Ono/GF1NDUP+FTPabEQMuhHhZf5a
         4i1g==
X-Gm-Message-State: AOJu0YxsMCbXaKM8Sc9799+CfKHoBp1jIyh7ICNx07qEOVHldSu0CjqU
	zWFl1Gv/dobGnOzcR+AQQQe+T+qfoc/vkYW+GXNX0dlYT1D0gkMYQ3ISj78LKepdPkJLZg==
X-Gm-Gg: AfdE7clS+cXfJ8U+1aHyL1d6gu8q5AtlTmYrXGktLq/Og4O2i/g8IJIspufm4YQKSMi
	hepOeb0t1Ky7rOe9EpcUfnqfMFwSZqZQUqf5tGkzwLJeWqQvy+ytHv89q50IByYUMhApsOuKZzS
	ohHlY1oit9+muxi4b/z/R6ySx7xJvHvqVKCvAQzAs102Ix2SJYg5zd3wrnTkUjPggPENcAzdp6d
	hNZhzVcw4V/KmprqnYbXPYtyp7WiTDi0uKKWKgu0bJij5apsgguBdndHOxs4GBAHpM3bsQW2TIF
	lwQlKonXOT+upS2dTJyqx73Ce/yZ5dJ+NsC+9jIWN5HPSNUIcWB3c0Z95IY22aGo6BxxnZgSE7i
	1mEBLINxe+tD6K87AesuVOFVhiyzl8b+PHmTtbf29VkBg5hjSkvDgYpYfBCug/tWLUXCOdgwjde
	FHET2w7l6SmNCxl1eCDMvQbCmsD8GloAYjCecgWYyO7tdR
X-Received: by 2002:a05:6a00:9499:b0:842:5a18:9af0 with SMTP id d2e1a72fcca58-84c2917f212mr4248164b3a.0.1784368636739;
        Sat, 18 Jul 2026 02:57:16 -0700 (PDT)
Received: from debian.lan ([240e:391:eb4:a240::1])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84c2af317c8sm2417248b3a.30.2026.07.18.02.57.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 Jul 2026 02:57:16 -0700 (PDT)
From: Xueyuan Chen <xueyuan.chen21@gmail.com>
To: linux-mm@kvack.org,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>
Cc: linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org,
	"H . Peter Anvin" <hpa@zytor.com>,
	Andy Lutomirski <luto@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Lance Yang <lance.yang@linux.dev>,
	Usama Arif <usama.arif@linux.dev>,
	Jann Horn <jannh@google.com>,
	Yang Shi <yang@os.amperecomputing.com>,
	Mike Rapoport <rppt@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R . Howlett" <liam@infradead.org>,
	Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Xueyuan Chen <xueyuan.chen21@gmail.com>
Subject: [RFC PATCH v4 3/3] x86/mm: add set_direct_map_ro_noflush()
Date: Sat, 18 Jul 2026 17:56:47 +0800
Message-ID: <20260718095647.182592-4-xueyuan.chen21@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260718095647.182592-1-xueyuan.chen21@gmail.com>
References: <20260718095647.182592-1-xueyuan.chen21@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 04FC8A0006
X-Rspam-User: 
X-Stat-Signature: d61q5o8c9jpyb8idaqfshwtsrwqdgzqr
X-Rspamd-Server: rspam03
X-HE-Tag: 1784368637-516643
X-HE-Meta: U2FsdGVkX1/6ctsE0U7y6CIrmBTp83XkdXaC9bWEINBy59lYrv6U886cU8yGCc4aWJz2fWFznbnwWvqoInAtvmYlV7+9TYMuKAYe1v8TH0wZprnqU/E15zK0xMUBpATKr+URe8pZAOzXrcb29GlTIh5WhXgapHP2m7J1qTioIAr1ExWbSW6+Z88XUu0+XprEQbPhwK32m3UjRRACQhnuG1pC6iAwb1ZPytsR3fuIVXj13GCslVVRvwbNJjD/D8SK8fS7B+0YzTnzRdOwdoTemgnqearqwUD8veeeuBxZ9NQezTFjjvtSaUu6zJUiTVOjHPC8IDbeUyHLa3FsYpr+NuhmnYqKafM3uUOuNcAhG821YAyU9IzqGJFUOoXMzMDfpdqiuiptrhR8mtuPrqH7HzSQBZPxDJSSoro0G4vbS0JTM5o7nt0op/FucB9iRCbc9PfVyDK8K6RjGMDj2cIGjw8QpLfjHVL2PlP4MVCyd6pVt7Vqee6qw4kTsV12j+HaSm+QjA0fVetjR+FoIJl9iT8/4MOCeI1Iqm/wZAnag2uhKjMKc/rElQm+kAkweLrtICY6hXCaDyaEQ2hJWHSOuY740ojit9mnrapBx63WJCaJPysqTMZF8B6Gj4a1OartBWaPqqBN85d7/6L49sqQ/RmrX4xXv1bN2mJ7V+oWCYOblZknskiZXqBRJAv0Zcn69qiPQrqYW/ENxVsXCxR4XodPPxeOrEzWCVTawLMyJ19ex0ME4SjIeavT7PD2GRCX/m02ORLTjtg4jXKWT98bTdHKl2Ll8JR6c66sJC0oZXz+6fIjNxtddy9cDBvZwn/1HymTCrcVJVSs9609xfoKZoi9O063NptVVHEqP99vlVoBquO6lLwA1Uzih50TvO8E3h0IymO9h0P144yiRtg1Ryd7ZHGkQmW7dujm5nXO/1wq12xErd86UbVtvt5w6JXJ2gbshgEqv0tkhs/7wIS
 D8pzw/DU
 e/hb3K08DgW8bdgJUFzuaHs6xArirTUBP6WgaUCTx/CKFVGGnddNG8O/NxqmMcefXNnA3SZ/QTCuWsly9m++/VfgwJ7fTkT37CavQBgTjL3QhUvX9RmaK7HTk6w7/7368GdKS750nhlaR/NDR/3/ltKDPzx8515Wpd/GF4H5gwZAEtjGLismT7Sne2ixesQaqxyCDpQIzweuU/FKOnuzpGlC9p27QNOxn6Yd3e2PX17oZhQWt0Tovsk5TCMnGHQxxCx6ORvgVA/Qryl9ex2jlEMXUH7d5WVmLOUZjYzYCZliZra/Axr8ZuleSlDAsANl29kSYEgPt+zGFvd8JA04gvmNqkzXgUz0C+h1kfbKWLHE/bNpnCzNtPU8ItN8JU0WGD1/WBNBy9X88TVD+S7JDUOZurFGpMsJA7BDmpOzNLNl608bkxhNFYsyQ19hQWnbyp8F/gUtqfcS4eZUbzAJBZ0tr+/OQoJkhdJXjL0ewMVlkQCgwpMkEuUFE19VwJcS+PeWKszySpGXJuTZUxijPVTXZB+JRz0tDWeH9
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


