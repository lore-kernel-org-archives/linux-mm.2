Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7653ECA6004
	for <linux-mm@archiver.kernel.org>; Sat, 10 Oct 2026 11:26:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 566AF6B0092; Sat, 10 Oct 2026 07:26:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 53E806B0095; Sat, 10 Oct 2026 07:26:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 42DFE6B0096; Sat, 10 Oct 2026 07:26:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 157226B0092
	for <linux-mm@kvack.org>; Sat, 10 Oct 2026 07:26:11 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8EB434064B
	for <linux-mm@kvack.org>; Sat, 10 Oct 2026 11:26:10 +0000 (UTC)
X-FDA: 85306487700.28.A3B5228
Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	by imf15.hostedemail.com (Postfix) with ESMTP id 1AB03A000B
	for <linux-mm@kvack.org>; Sat, 10 Oct 2026 11:26:07 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b="N8vD/IHx";
	spf=pass (imf15.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.51 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791631568;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cPrbN6fNnAjfl8a6kAKqWueJEJ1qRXmGBrgomj1Gs8U=;
	b=xBUJYOBVsL+JyiagSZgk7hlThMnKH9I8O2+77bnoYmSEPnfnylCUVn3Nz2W1fVsMUK0S9X
	ONFc3WptdPSNdL2/8kzgcFjngA3zSB3J4GZcugBlT/kCZKrAHan7dC9wxXB7206ZWDW7rb
	G7Q1Cc3J/gL+ricfHInArULBozvqbE4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791631568;
	b=4IIAhwLTts099HUJuVhElNNtfDnsdTvFChny58um5KR5VcckUbvL7ASkNuLchXO5+5R38R
	y6430OggxUEfflgqP4Y3BOPZ7yVSxxsEaMPAvi0ZLJd145+BR6Kpt/nu9Vg/zgq3Y2G5Iy
	DPtVs7/LKnCs98JKWIKg5wpWge2/4wY=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b="N8vD/IHx";
	spf=pass (imf15.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.51 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-3ab41538192so347245a91.0
        for <linux-mm@kvack.org>; Sat, 10 Oct 2026 04:26:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1791631567; x=1792236367; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=cPrbN6fNnAjfl8a6kAKqWueJEJ1qRXmGBrgomj1Gs8U=;
        b=N8vD/IHxp9/7yjl6rcmmoP6r7/bRv6HOCUeTapMx7aILTO0s2DEHUhqdnXARKbkGcr
         TcKVoXM3MbqJmg6qr9AJy4sG+pMGDF7dAyPvEB37QejP20QmTNP8snijBWwZVSq9Klfq
         MGQJ9EtcspKxkXp7RzMbPxiY1CH3nnVH/jPl/wzAz/ayGkZBYi6xRz7c3KjjIJNKGElW
         aVRGXANlhALBeyLdw4wVd/ecisUKP1jty0RP8QwhK9M5O8cc1Xa2IR/UH8r4QGFvdpAt
         MPS1C7NXwl8YC2ZnzxIXlyy2ejVQ+u3kJqs/oAO/X6TcwYeRPALcYcZYy7q6JhNEj9st
         uU4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791631567; x=1792236367;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=cPrbN6fNnAjfl8a6kAKqWueJEJ1qRXmGBrgomj1Gs8U=;
        b=gQI5Dpy4Hl8LLvMIwMPln7RnyWzyfO+PDSbboS8OF4UmpLKAJPvOsKDQ//dLu6vONR
         R50w3qg90+OAfT/wwSPxE9yAEz3pvkOt1dPtanCw1Is4fSfeJy70wyDvystYtedpdwVe
         sJN1OuZexudSgLActUCPrboJ5wRDhWdiXSZ+QWGwrWg91z5rpO6V6CaJx4m/fnwS0Gkp
         LC0OUgdnUjoOdBWcIhZJayQ0l22teQyw+JwfXuPGpGB9RQDjH1gHtXU6gBlE8b83bOGI
         Wv+by4q/RNER8gvSg1tFpiCBQptLSE9UHzh+rtYFtlst455eQO/JG/kCD4dNAHA1a6tc
         LTyw==
X-Forwarded-Encrypted: i=1; AKwUvBweA32cOff6zw1h8A7cjM38Sgnqa2XsYNiQl2K919ecV3JnUyKyl078LI6U+3UnOc+0W6LhB/VhQA==@kvack.org
X-Gm-Message-State: AFq9FYKBw0+OHGfmvWO7pVkHkCgeV175A+1tOIftoTZDCJ9lcdLcwEXw
	MLQYba6qe5iYhGXuCZEoEC6uUgmE1X2uLyCptxpfka9RGw2pOg4URPWeRRJRSuI4JYo=
X-Gm-Gg: AYBFou1nAtEoIIJOpu3GC1swNud33HUZbnA4Pv47fh7UpsKXFt48+ZmoLyASgGKKCUF
	1Z5IDTbH+YCvm0Cjy671iGHzme/4d0su+9GvNvSG8PupJY7hm6La28kTK4iF02BhYXX7KcqXvPy
	XEPvk7xjHdocEHaq7OZ+AZyeLIWf7L//B10HMuSn6U8RZVRTFRZyg+seCUmV2SouID+gLQxX5Wl
	KwVhNzCrDptkA0pIBMraAdjwcrUS7grUCEWqFSI2A5mItuE3+BMQKV894lOT4vv6t39/vzwgqGB
	+FB2QgE68Qy9+xOCedh80yNS0SfX/ptE7TZVi+nD1i7ofG+DO/wY5cTwBZYm5ItfTSORuisxKUh
	T/r3z7c5gLColugkNNMrsSIiLucTrLfm6ooOgnmK7zo3cE1omKs0O8qx/cwGEfVjvplMoymsz1O
	eXlrzpvHD7P6O0tuuisYympaAj0G9eioWGdtwxPEy1LHEbJ52vw4WC9rFUmotezpBAtPoqqvuJz
	XKOzkBtX18oTBzqZLHFcCuuZHOqrEIiqdDA+g==
X-Received: by 2002:a17:90b:384a:b0:3a8:c0cd:57f7 with SMTP id 98e67ed59e1d1-3ab3a735f76mr3813182a91.23.1791631566480;
        Sat, 10 Oct 2026 04:26:06 -0700 (PDT)
Received: from G6L4RL2QG9.bytedance.net ([139.177.225.249])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ab3690474esm7900233a91.0.2026.10.10.04.25.57
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sat, 10 Oct 2026 04:26:05 -0700 (PDT)
From: Muchun Song <songmuchun@bytedance.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>,
	Oscar Salvador <osalvador@suse.de>,
	Dave Hansen <dave.hansen@intel.com>,
	Paul Walmsley <pjw@kernel.org>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Alexandre Ghiti <alex@ghiti.fr>,
	=?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@rivosinc.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Kevin Brodsky <kevin.brodsky@arm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Alistair Popple <apopple@nvidia.com>,
	linux-mm@kvack.org,
	linux-riscv@lists.infradead.org,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	Muchun Song <muchun.song@linux.dev>,
	Muchun Song <songmuchun@bytedance.com>
Subject: [PATCH v2 2/4] riscv/mm: fix hotplug page-table destructor handling
Date: Sat, 10 Oct 2026 19:24:55 +0800
Message-ID: <20261010112457.49485-3-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261010112457.49485-1-songmuchun@bytedance.com>
References: <20261010112457.49485-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 1AB03A000B
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: im9h4okrhd33x46no76jbmggiq1oa9yp
X-HE-Tag: 1791631567-503934
X-HE-Meta: U2FsdGVkX19RGqbqH2uMhnuUdsXy9B7629Xkdc6fKWpZSNOqDOqtgKtFei5WkOLwn7aMtnLXzMy0FjYykslvUn2MpJ1FNevLAdAn3TTUNctghw78j9UCwWL5dW4OZ8Ch97VL7KX79cLDrsys6tFm2trPxYAJMldCsHtxmOrpWsV0UuCU2DiE4Q8NFULZg4nkVGnz6HFnkB6mkZlkkEJ3ZvDkIYC3b7gm8ArkxFEcmGGw1R0/aTlSOfOQgcE31NBoHRlXu9DN2dbkbDA0f3SsP+H/AHTHzHnPZrnQJl6fcVy71FfJgLkTZmz6uF7t7tv4Va3S/q4U3dOxg4zNGX2Z9bAJYS4gOz+8Gko4T532SQyPQfocOx465uR+0YGwZZYY/IXEEXcg+tETZOq8EfPjQorUUwfrUMEoxl1ZtBXYSOdU0xHsxZGMu+BmdP4BzesgXphDnzrBWuUuxY908TBgjLXX6LcuuHl9QpAe6W8e2QCOrMiQh2J7M8avzZOGhvPyktteqh/Cb5R5U+fnei3TIz4eXBAh8iUJh2/IIb2GwfmRbJEK0XECHT+JKouECNFwr9vDRPG0rw42fonW+dDK4PLMR7RkesjJS/AF3AvcCzmkfcH3LPXCyt+1whf613A3G7aiWAqyJ/eAU5LiWaj2eyKmIrGcDs8UBRrek+yGSIQrKi2oQdtEuo0EKpiOW2PbNMb79X9QdYfOJsi+WRaPtCFdBqW0fl16VnFST2gPbNSODSh9JmftlomSMiV2T8t9FgZzVfKjgisFIto8BbEALtH8HduMzVruDkLYtDwgTGg4fW7j26KXzyxW+rQzDnYSqqWTxBxoOfU8aEnWI/5jEDB3iQzzIRURhhaWro/LZKP4MLXnnrSVPcDOkOvmmseLdmg4kJsQDZQ71ZJkFe1sN6+CwxGfaN6YIJJ1GwCHJu4PpwoaGLlPOf7DVKGO8q7hzG/6Np7Rtr8NCZyA1L/
 tZJximN5
 +EVn2rN1VHBUYMEhZEmX0i81jdkIRExalo8k6V7tn+KpaX+QrfP9Ry53CbCsfRZV5Vb8rYl0m8Kpowyj6aB1S5WybSeuIpkw+Fu7l9t+55zsqojL4zt0+HkgNeAQukGSdcn0XqVt+Ltqr9hGDdDEb37StiiaZedXR2gI9OOozRCRuknSkTTKbm3SRpEcfniNN5HYAygj8R3n/Huao1+GYZ+2ZpQdUwD5L4sxveY1LLrj3ptquQUHx/C7+2QFXEpbxCFLgq/JUi+jdO9bJGbtZK9POYe51HE/YJb5lkwW+9BXHz33gzlkHNahE2oQlYeVeuWxva1pH8yvofVI5MxLLIsMs1w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

RISC-V uses the same memory-hotplug teardown code for linear-map and
vmemmap page tables. Late linear-map allocations run page-table
constructors, while vmemmap and early allocations may not.

free_pte_table() unconditionally calls pagetable_dtor(), corrupting
NR_PAGETABLE accounting for constructor-free tables. free_pmd_table()
avoids that for vmemmap using is_vmemmap, but mapping type is not a
reliable proxy for constructor state. In particular, it becomes invalid
once runtime vmemmap tables use the normal pgalloc helpers.

Introduce free_pgtable_page() to select free_reserved_page() for reserved
pages and pagetable_free() otherwise. The latter runs the destructor only
when PageTable() is set, handling both constructor-backed and
constructor-free tables.

Fixes: c75a74f4ba19 ("riscv: mm: Add memory hotplugging support")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
---
v2:
- Use pagetable_free() for non-reserved tables (suggested by David
  Hildenbrand)
- Simplify reserved-page handling
---
 arch/riscv/mm/init.c | 27 ++++++++++++---------------
 1 file changed, 12 insertions(+), 15 deletions(-)

diff --git a/arch/riscv/mm/init.c b/arch/riscv/mm/init.c
index 857f9a55039c..151eb197cb09 100644
--- a/arch/riscv/mm/init.c
+++ b/arch/riscv/mm/init.c
@@ -1486,10 +1486,17 @@ struct execmem_info __init *execmem_arch_setup(void)
 #endif /* CONFIG_EXECMEM */
 
 #ifdef CONFIG_MEMORY_HOTPLUG
+static void __meminit free_pgtable_page(struct page *page)
+{
+	if (PageReserved(page))
+		free_reserved_page(page);
+	else
+		pagetable_free(page_ptdesc(page));
+}
+
 static void __meminit free_pte_table(pte_t *pte_start, pmd_t *pmd)
 {
 	struct page *page = pmd_page(*pmd);
-	struct ptdesc *ptdesc = page_ptdesc(page);
 	pte_t *pte;
 	int i;
 
@@ -1499,18 +1506,13 @@ static void __meminit free_pte_table(pte_t *pte_start, pmd_t *pmd)
 			return;
 	}
 
-	pagetable_dtor(ptdesc);
-	if (PageReserved(page))
-		free_reserved_page(page);
-	else
-		pagetable_free(ptdesc);
+	free_pgtable_page(page);
 	pmd_clear(pmd);
 }
 
-static void __meminit free_pmd_table(pmd_t *pmd_start, pud_t *pud, bool is_vmemmap)
+static void __meminit free_pmd_table(pmd_t *pmd_start, pud_t *pud)
 {
 	struct page *page = pud_page(*pud);
-	struct ptdesc *ptdesc = page_ptdesc(page);
 	pmd_t *pmd;
 	int i;
 
@@ -1520,12 +1522,7 @@ static void __meminit free_pmd_table(pmd_t *pmd_start, pud_t *pud, bool is_vmemm
 			return;
 	}
 
-	if (!is_vmemmap)
-		pagetable_dtor(ptdesc);
-	if (PageReserved(page))
-		free_reserved_page(page);
-	else
-		pagetable_free(ptdesc);
+	free_pgtable_page(page);
 	pud_clear(pud);
 }
 
@@ -1645,7 +1642,7 @@ static void __meminit remove_pud_mapping(pud_t *pud_base, unsigned long addr, un
 		remove_pmd_mapping(pmd_base, addr, next, is_vmemmap, altmap);
 
 		if (pgtable_l4_enabled)
-			free_pmd_table(pmd_base, pudp, is_vmemmap);
+			free_pmd_table(pmd_base, pudp);
 	}
 }
 
-- 
2.54.0


