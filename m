Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CF31DC531FC
	for <linux-mm@archiver.kernel.org>; Mon, 27 Jul 2026 14:35:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 996F86B00A4; Mon, 27 Jul 2026 10:35:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 946F16B00A6; Mon, 27 Jul 2026 10:35:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 80F0E6B00AA; Mon, 27 Jul 2026 10:35:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 48D506B00A4
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 10:35:27 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B83D740770
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 14:35:26 +0000 (UTC)
X-FDA: 85034804652.26.47B7883
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	by imf26.hostedemail.com (Postfix) with ESMTP id D201214000B
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 14:35:24 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=RhMpncZT;
	spf=pass (imf26.hostedemail.com: domain of xueyuan.chen21@gmail.com designates 209.85.214.177 as permitted sender) smtp.mailfrom=xueyuan.chen21@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785162924;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ObdtBSjlBwpgFGsbg/wrosB7LM91UtGEZki+/E5+WZ0=;
	b=Z61XSgw+hPdi8bTdfnjfkDuC34qpZSuQdv++wspc0NSl9D3dj1/YFZd7kf5yuOUCC4mY5q
	UMzhfPUakDxUQRvYh1tgojebkJd8ADxEvYmT7HxVkfpcLpFZZIFk8B5C68fe94MuALd+CS
	nkWQIE5u29p1YMdZkYl2Ujcv2d3DuTM=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=RhMpncZT;
	spf=pass (imf26.hostedemail.com: domain of xueyuan.chen21@gmail.com designates 209.85.214.177 as permitted sender) smtp.mailfrom=xueyuan.chen21@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785162924;
	b=OBtMak6FfCocwaTDNdE2xzp+Ww9Y6L++hCosOTkSNk19ktpfsdoCGOROJtS7GMh06q+kNM
	ZZ4so+KcTVfCO9HeFcHGbFP48eEJYjufjIHc1CfXe/YaG4ngUmyi/gWgcV48fQCGuOSaDU
	8z8Y7dr23w/6HSIMfl0Ab7Rf1MKmoCc=
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-2cf4c37dbe6so2180345ad.2
        for <linux-mm@kvack.org>; Mon, 27 Jul 2026 07:35:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785162924; x=1785767724; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ObdtBSjlBwpgFGsbg/wrosB7LM91UtGEZki+/E5+WZ0=;
        b=RhMpncZTX79bhuaUx7CCKyEesiDQgQBO0TNQpmcsMWoNNJXjODPdjaUFk4XznX8ypF
         b6H0Rfhe75Fd5nWiVuCcEs+b7bG9sT4YeroEWJl+C5omFHBuOdb8qsGQR2JDXT7XvOwU
         CHQ1ufshQsxZwEMUsB9G3tNoo6/GFZYNGZuEU7qqwJGNxecRxwo0MH3k5WVkxoY0CUJ7
         E9E2kCGiHmXw70FQ5vBVaLH2kVUjOM/tpaBCzTnAzRGc/bVSMm01Qn43gTHkRwSFlQxK
         8JyFu1dR3AKcC4OahEENFnVbDl9y5TYfzXFAotNz706m+pEtHbJWwgN9fmK3AEPD1Hri
         gAPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785162924; x=1785767724;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=ObdtBSjlBwpgFGsbg/wrosB7LM91UtGEZki+/E5+WZ0=;
        b=JUsUwTaflqIN9GBcdkHsaC89G7GlhPBsSU/kwk3RACKgcbgObsTdJWg0q+9GRl/AXc
         yfw613C7ikPQH17y3V8+QDlgZc0W3nVTN0QeiOyu3lctBoDcEPVYzS8byiHrMCEIXpmw
         9GH4XJd1M6OBuHJTGcAhlV9ngWxk3e9EZL874/NEi/8hXHfq94HoKzWVNf8Kz9gybVeu
         A3N6nwQMdatpZdnqIpvKsTNjI0ih3zLARcjgY3uDGLAVRZCIjw2r/WhlKB880pvFx8jE
         Vwwlxh3sMKFNKLsI67obshEyZlGfL/jpuM31L0HNrn+fIJ8cYBqSD8zJ1T/Xxbu1QgLQ
         CRhA==
X-Gm-Message-State: AOJu0YyadP0Cu7cfrGi6v6XQMZJX+fAI95zNvrL/zovHDY+RuU+vbaJR
	IpqZ5UVU4VcSzwRQ6WeP3M4QcHHcuzekzvm202ljgDfrn6Od7rDtmQj2eAuK6DIMPECEH6/H
X-Gm-Gg: AR+sD132IhpF3fY2zhhiqb0gFmKNpO0llY4SbTDY3r8SR+C1Ngy7pdzJj1lTjaTFpuh
	/3ljooOdwYm4ICzoVFRtjllhg+bX5TG9lh8V0jmyW9f7YZ6/mmJJONZn2hIt1IPT4SqOq4nWGkO
	EaVzFC4VmOwM96v9d5ra6142m24g6Ks48JCM7m0zEn0RIa/R8wMlb25BRvjPHbXcspL37RwBNtX
	ID0EZj9cP2WJQZF72W1ehD59ndacHlJidkTkhj8LzCxb2JzPrhww03AZY3BUDNaS0IicXHgkkas
	bkOxRmLZtE/hHxDjaf3//EnaDFkNmlAc31OtVSGWX4rW02Da8CoUD8FfcfWt1DbKHbpJn6Ua2jx
	dEy+RvHW2KGbAdN+eyQZz1vBFojt0MNRn5SLjoaVJfDvEpz4fhjevb79BATUdQPM8Ezzzx0WThh
	sNEwc/oV5jPfrN4t/gH+Q5zGdi/N/yuZtjlw1wVCpR8QAD+xOgtAbLGMQAu92EvWUS
X-Received: by 2002:a17:902:d48a:b0:2ca:bca8:109b with SMTP id d9443c01a7336-2d00b84c43cmr3891855ad.5.1785162923760;
        Mon, 27 Jul 2026 07:35:23 -0700 (PDT)
Received: from debian.lan ([141.11.42.65])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2cfde7d5297sm36877485ad.56.2026.07.27.07.35.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jul 2026 07:35:23 -0700 (PDT)
From: Xueyuan Chen <xueyuan.chen21@gmail.com>
To: linux-mm@kvack.org,
	akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org
Cc: linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	catalin.marinas@arm.com,
	will@kernel.org,
	tglx@kernel.org,
	mingo@redhat.com,
	bp@alien8.de,
	dave.hansen@linux.intel.com,
	x86@kernel.org,
	hpa@zytor.com,
	luto@kernel.org,
	peterz@infradead.org,
	lance.yang@linux.dev,
	usama.arif@linux.dev,
	jannh@google.com,
	yang@os.amperecomputing.com,
	rppt@kernel.org,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	liam@infradead.org,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org
Subject: [PATCH v5 2/3] arm64/mm: add set_direct_map_ro_noflush()
Date: Mon, 27 Jul 2026 22:34:25 +0800
Message-ID: <20260727143426.1077133-3-xueyuan.chen21@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260727143426.1077133-1-xueyuan.chen21@gmail.com>
References: <20260727143426.1077133-1-xueyuan.chen21@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: D201214000B
X-Stat-Signature: fzazprimnbzyakaozgc5zsr3g73a45h4
X-HE-Tag: 1785162924-595976
X-HE-Meta: U2FsdGVkX1/9QMuOrtf8n9/09q3wAtzoT2M+9qCfmjFo4fC5ZZGleXAl9d42Cwu5H6ia5fgBxlHB/1WcTGLksQjI9xQ+WZkDnitx5Y6qYehZxRzjUC+ZaO3v4tg94wEs+DoMbleKSEecsGQIglFbitUh06f+xpZKDAn4LjuRMV0uim8cFikeHi3L+PVrT7gn4KGlcnB6TSGoo9AyNYusjGGSemaAzO5pk2ny82z1094MAzDufw74ZMERgv4GF1wf0spTletZncJRapd7CTEbQIR5pZVLsZtfVW8VMPrsV2FRWyGrjoOh5vzlkGroZv/BE9PLhMvpl0Lvns+OTO1wtaFQgFZqdLlIDfnNY/Guiky8ysbkwSiNGHZlbf2PqJVIVoVJtKcVgGs8muokhUDZPQpJSuvq+BqyDmMUkL5dIrvkm+ncrL8vc4dQB2s/qrBSsY4LasA7aZHWF0+BJTxTbpRNvWGhCqfNzNkeOcrypW/15K4eo9lExixP3vLeQt/k3Y9KxwERpFZjb6ESf9ZEkdZ9UDJdOxJb+4TZnhYSKvOlPMfX/zTCuYdB6R3rPI/aZoAg9Gf32ng2oF99gzTDIyJ3i3HM1p83fTEUXdzg6Pi+SNFBB3qFbgTn8pA9ETar5tsffQh3J52OgP7/kY3aN75JE6ODsARzITk+fd+ku2KFgtLNfYqcnBkFjeTZqm72QuhaVJV69Wyo89TcONnmzRJO3JgcJwnLi8/mPvw1OcUQRnAOl76w9ebQGl8ZlWVKnk7NbwV8Bn7UziwzcERc1+lCqvddlKsdatvLcEU+zg785j8nWXKRuDcuuhsZ3hXiOoI8MC9iKNTKEEtTUmrNeE7KsafnFTJge9PHlELLbBdbmtTkMUrEZl692Et7cuSCE88Wza+phP9TyGuWgnTzanOZ0ylx6BqEOBEGzfnoR4+qZpIHf3KpfSi/SmtKIojmaTikzbk0HTT8q4EUNkT
 x08SsCRR
 lNgHsTRXhzPclIuNY4H4GgSSWY0lejXocJEKETjFYZc7ZJMkvCjWdWeVmOFwQrGbPKD+/vScOZ0hGNg1UhHDLSSZXXCY0J9y/c4oLYLlJwGJRFT+F21DUM0EFaktWfRsIu8If2NRwdn8ggoJdX6Qb2RcctMTAYdCabBReTJlY+Q10AD4PDRkeq8pmqeohNsCwGMl2sA5HI5aDlHfmtwwvc6Nov8YPi1tzr0e8+wumOGux7zFmRZRtSMwTbpxlpz0DoEngfkKgXCRZMTlSZcTuNbtWV0Ii46qpP/dbbhdQwPrtvvkmjufmBu46q6QyeybqBQhq17SWF/zV7+0NgyX2mZw5+Mz6zIj2w1NjrOSPJ0PymjnAHtUozvCJKwNYKky4qlFrrH+hv7ijUA/Hdx4rKo85EqVsIEKbYB03quYZ9quQnDeQG807lZLqYzeQGt4lUpJMU7Vyj43GWEWkkytP/tS8cxp9AOEUGGam4BkmPUJE/GfkAITOZ8XQOg==
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


