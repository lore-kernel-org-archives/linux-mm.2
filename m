Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 51290C4451C
	for <linux-mm@archiver.kernel.org>; Sat, 18 Jul 2026 09:57:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5476E6B00A7; Sat, 18 Jul 2026 05:57:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 51BDE6B00AA; Sat, 18 Jul 2026 05:57:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3E5EA6B00AB; Sat, 18 Jul 2026 05:57:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0EC3A6B00A7
	for <linux-mm@kvack.org>; Sat, 18 Jul 2026 05:57:14 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 8CC45A0342
	for <linux-mm@kvack.org>; Sat, 18 Jul 2026 09:57:13 +0000 (UTC)
X-FDA: 85001444346.20.099CE03
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	by imf16.hostedemail.com (Postfix) with ESMTP id CDD8F180003
	for <linux-mm@kvack.org>; Sat, 18 Jul 2026 09:57:11 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=LGTBj2w4;
	spf=pass (imf16.hostedemail.com: domain of xueyuan.chen21@gmail.com designates 209.85.214.171 as permitted sender) smtp.mailfrom=xueyuan.chen21@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784368631;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ObdtBSjlBwpgFGsbg/wrosB7LM91UtGEZki+/E5+WZ0=;
	b=h3mbcxOSM0/r/jD6MCOJa0vkogdalvhiTlVtHtqOUlfOHIvAA1gAOSoe6SFG1VA/GNPGE5
	pABfmGixtw2DY+ef61lpIJmsYoMt1INaX5S0DGPjSh4+MnzZiXcUVNzG1j36xP8uRTilUF
	LKXLDCtPwlBwhLYKdmN5t9C3YOQSohE=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=LGTBj2w4;
	spf=pass (imf16.hostedemail.com: domain of xueyuan.chen21@gmail.com designates 209.85.214.171 as permitted sender) smtp.mailfrom=xueyuan.chen21@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784368631;
	b=U8W8jQZYE7N3LY7xAjSeS1nzYd+f+NN1knrNZQht15LP0J27PfM0P2nPTxNDLVSYm7ThPD
	6No4Hnq7XD7PSA6OPQNjUApo9+n6b67wP4ice2hzcClXKYKfdppPLsUAQjYTh6upq5FHt0
	swd/fGa6VxWGlLSiZBNUBJQYzNovqbs=
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-2cc7a269ca1so17989275ad.3
        for <linux-mm@kvack.org>; Sat, 18 Jul 2026 02:57:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784368631; x=1784973431; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ObdtBSjlBwpgFGsbg/wrosB7LM91UtGEZki+/E5+WZ0=;
        b=LGTBj2w44K9EWhEIEcBQAu+piPK4Bp6UmcmJxTSjP7POODQJsIdM1fqTn8WpNJttNN
         Xt+Nkl+fwfdASy/a/Z5jzMrBcMbdhICdW4zPKaM0nVpJ98H1zL8/v5YeqoK4zj7vCrDh
         4FeVZNi9I4E0Kq9qBW2FlFttQptyvMhrQJ1gU5/WOrKHJ5925dyGjZkLQfAga8FRFEcm
         G3sok8MEm2/AM5vH00r9kZ7C1f8LfzSrGpjcWJTh2bLaPnJP/diGO5QIvccDfKhMCPc6
         oe2blOfhMdinnwJOUu3Mr9jQdeJxc7RaTiQeZGYrFh1oG6093S/XXGSA7JgYIfb6JIsC
         DXBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784368631; x=1784973431;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=ObdtBSjlBwpgFGsbg/wrosB7LM91UtGEZki+/E5+WZ0=;
        b=iRrJ+6rweoYVIqiWeQzCj2Pr56qf765u3+H94HV2NbzWS/PBxP+xcCizUCiFqDf0z9
         dlr7qx6OJo0HFZADvLSIf+BNb4eAP6vOlZtmO4lcGyCd00bAOnCB1L0H5LpfKZjasiz1
         yljvjcNYco66x6APakngAPTZjD9+Wt6I7jTVI3jpFInMPhlLrZNKz/QB6C+Z12oQjZcN
         bf75rXlK5po5kf+iVWR8eZnsoMWWZQ+Ee1RAQvk9SVNM/A9yL3IKQgZvZN2BYa8Zl18l
         Ha6lKM4sJhY74XY8t+KldGLoEZdiisHdsn+V0ex5un7A3wLySDLvzfSmgOdjtysWe1rd
         GaKQ==
X-Gm-Message-State: AOJu0Yw+hHz7Wp7j8ZEKoXs15uZrPXaGTZ9z34t05lochSUh+j9BsN33
	lAuZDzoYLvFnhp75J/lBCpJjyxEc1NC0qR0QkjCbVx31bpcMdGcKustHqCHNkAFCMkDpeA==
X-Gm-Gg: AfdE7cl+zk8x/+1gk1Q0OboKzJ9qXtzKZmg5PGl2H9RJN+6y0GLRujZR6ris347Tplv
	TNTNCT1O4IhleNYdg0gI/pwwgwhti4hKfhaSfz94CWi237dpO2vxwc0Fzgxnv3EBqTFbk5p6YtO
	NYxlm3kuFvu9Ym0KrBVnCVa/8RbBLEMEnOKCW9Hn9xNViGKtpx6XxcHZZxEEWWIUaWARX9BTcVz
	IFt0CDNWu5zdEAZwUjHJ2aOMI3XYwb2wtHrgbDtGoDdnPlaQ6IJBmTvuc0f2Q3XxOhJq7MqCD70
	gUPGnkUUBjNbvKdtFWe05SY412qh3EzBCwFnGjg8rKWV9J5puxbCe8GCvLcXhKzTWMO/RQ3tmsz
	XOBIDh0cDQmPsUth5vqJ4g+GI/imCXQ+9j7hf/lmT/XgC0f4qs/Z0gYADAdZ7WTVJPKDB8BxQcx
	5VDkLxY9t3aLG7/8Z/Id1BYwcgHvawi+UwbsUJNSWFvjQF
X-Received: by 2002:a05:6a20:9397:b0:3b4:7aae:1eed with SMTP id adf61e73a8af0-3c3ad91f768mr4682057637.4.1784368630603;
        Sat, 18 Jul 2026 02:57:10 -0700 (PDT)
Received: from debian.lan ([240e:391:eb4:a240::1])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84c2af317c8sm2417248b3a.30.2026.07.18.02.57.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 Jul 2026 02:57:10 -0700 (PDT)
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
Subject: [RFC PATCH v4 2/3] arm64/mm: add set_direct_map_ro_noflush()
Date: Sat, 18 Jul 2026 17:56:46 +0800
Message-ID: <20260718095647.182592-3-xueyuan.chen21@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260718095647.182592-1-xueyuan.chen21@gmail.com>
References: <20260718095647.182592-1-xueyuan.chen21@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: CDD8F180003
X-Stat-Signature: gwhx9z1cd67dfqios8epba84auk5ggh1
X-HE-Tag: 1784368631-589294
X-HE-Meta: U2FsdGVkX1/Qe1FE5I/LvzKeTbHQVygabON3lqG7hu50ZxFAfICRJl31z9brJhtUsMPUPMbPROANXcHhU4YTpiSbLSbL91XUKd434Py4eFZvpdh7UPK8Hdcc4jMPKUP4+OLIj3LOCkaYKTK4NfQ1ROWsonTicnXcRH43fkhpAmALmxI6znAoibCHqtvP5wbU3CQxcJqqPisF0/i55H56fJgQ+L5Rnj/eRhBDpHGSaNkWlNfCMF60VE2ZovhyQkbcjCsFqYwC+v6kmfCbOwgvQWKguvgIPZDjL6AeMPZkiQnC16WZka/Cc5RMWvoiWDjYRRxL1f8MhHg6wg9gRPyvGh+EgnS3qlx9M4lAjMUfeVmk9ldNBsuRWWOvzQWb7sU9953FMR9eOPC2t9tvaQWn1w3nvP+TCEuuSVIgzH0eRu+IPdDXe+HOUYncXl4ldqtRO1rfYGVSfLv/UmYhy8zAez8N4255RqH1UAlSn23LlgW7WqZ0FVfBpdQlaKhXLxpu/PDdeoCbiY44O3aZHxXXGr5OX0vQ65qIZCpiqT6wiHzT41LRXAQW5GzxW1nTVT+g8DVjANxHNnwqz9msHn9SluFInqIULyCc0xv+jfV3c51YZouljpO4ecoZjs5lTZn+ExfFU/ZxHmyvKVB6YxG/yetejG1jT7aOemLd4Hj+ckkufxxyJ+iYA8R0eXng3uSt19HIge/Dd1Wz4lStymiyvPzcRpJ/trbURG/X5T0V8i0VFG9ethIZ8vdtu8U3bQmY6Jwmh+gYppGsvpcl/RXnfEgThtRVy/tBJ6y44xr1n4XMdaLmLIazk9wlBsiWJFTaTuEXF+uruhGaMWbjMEBD1ZG8tPo69USM/0dWJvP4PdaREEVYsH4pv0EjKD3ghJNaA/HxD/zrFcISM6zOF1Ek0H9nE3vSe4ZdE9bP116wAIY9dPkSPNYnAEz3rXqIWIlTEZj91DFC9ZXuYpSOe22
 4JER6ywY
 GqUamvdL1+P5TK8lacHJMnYEC3p3BuDYxorx00XOyzVmYQqEovfPwef5XplzPJ2BrIGElhkadfvkBywhI4YjTC6xMuiKSaZVjMBFq1OcEWymQfhi/RQRyccwUUsbFImUJbxF+4zqSnjb368b142kf2YlOeIzlxKl7LzpLZ73rAU7OGiuGEVLaWx/bpaDTTZxdLbAr+pQmU6Ks1uTufcsF+MHOD4Qgb+obPeSupM5mbK1/n3eSQ3oD+0FeTY/xbrxH435xbtWWoRxBMNvSANnqeKFZJEE/FXdQzICD138MOV3bdz0C7sPkEi3e28SMBn57ItIxFB8JcHPBFlNurRrGRBgEZWeIY8+2xf4muu8cA4noL882RpMUksc232cdEtekXlcavx7ZeIEMp5qbKY/U2MpeEl/ZvTPNaJ+23SqNfdWkDSE9LRTudcMqZQh4e0l+p/GBWnwFSFvK1ImbCsJcQEzi3tMVMCd+i9ieD2wUz9t1aW9HYRLUjNGUKeos2MpCo6nkrccTVnJL5O9tncTrWID5jxFkJ5/rLd+9
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Implement set_direct_map_ro_noflush() for arm64 with update_range_prot() on
the linear map, setting PTE_RDONLY and clearing PTE_WRITE. Keep the
existing can_set_direct_map() guard and leave TLB invalidation to the
caller.

Co-developed-by: Lance Yang <lance.yang@linux.dev>
Signed-off-by: Lance Yang <lance.yang@linux.dev>
Signed-off-by: Xueyuan Chen <xueyuan.chen21@gmail.com>
---
 arch/arm64/include/asm/set_memory.h |  2 ++
 arch/arm64/mm/pageattr.c            | 10 ++++++++++
 2 files changed, 12 insertions(+)

diff --git a/arch/arm64/include/asm/set_memory.h b/arch/arm64/include/asm/set_memory.h
index 90f61b17275e..7083260303c3 100644
--- a/arch/arm64/include/asm/set_memory.h
+++ b/arch/arm64/include/asm/set_memory.h
@@ -14,6 +14,8 @@ int set_memory_valid(unsigned long addr, int numpages, int enable);
 int set_direct_map_invalid_noflush(struct page *page);
 int set_direct_map_default_noflush(struct page *page);
 int set_direct_map_valid_noflush(struct page *page, unsigned nr, bool valid);
+int set_direct_map_ro_noflush(const void *addr, unsigned long nr_pages);
+#define set_direct_map_ro_noflush set_direct_map_ro_noflush
 bool kernel_page_present(struct page *page);
 
 int set_memory_encrypted(unsigned long addr, int numpages);
diff --git a/arch/arm64/mm/pageattr.c b/arch/arm64/mm/pageattr.c
index ce035e1b4eaf..c51236b61651 100644
--- a/arch/arm64/mm/pageattr.c
+++ b/arch/arm64/mm/pageattr.c
@@ -365,6 +365,16 @@ int set_direct_map_valid_noflush(struct page *page, unsigned nr, bool valid)
 	return set_memory_valid(addr, nr, valid);
 }
 
+int set_direct_map_ro_noflush(const void *addr, unsigned long nr_pages)
+{
+	if (!can_set_direct_map())
+		return 0;
+
+	return update_range_prot((unsigned long)addr, PAGE_SIZE * nr_pages,
+				 __pgprot(PTE_RDONLY),
+				 __pgprot(PTE_WRITE));
+}
+
 #ifdef CONFIG_DEBUG_PAGEALLOC
 /*
  * This is - apart from the return value - doing the same
-- 
2.47.3


