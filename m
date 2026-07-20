Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2EF25C4451B
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 03:03:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C64B86B0092; Sun, 19 Jul 2026 23:03:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C17496B0093; Sun, 19 Jul 2026 23:03:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B05416B0095; Sun, 19 Jul 2026 23:03:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6C0C76B0092
	for <linux-mm@kvack.org>; Sun, 19 Jul 2026 23:03:57 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B89391C0994
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 03:03:56 +0000 (UTC)
X-FDA: 85007660472.08.C513D3A
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	by imf03.hostedemail.com (Postfix) with ESMTP id EB8FC20009
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 03:03:54 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Sa0ZOvLx;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf03.hostedemail.com: domain of lianux.mm@gmail.com designates 209.85.214.169 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784516634;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=X+CN3F8GNJ49+wMCUtm6B3zkpBPb78+r1IbCrOzeLVY=;
	b=Lrkci4ytf/ZpWIEpfmmNQ+MzipzkMxNHnuwqWdsygASzCILCbA6L1qmKmjt6wvgWxOCgTK
	7NaDuOXqdZD3g5tC8daBcOuY2e+JBpM5j0d8d9QCLKGAajc0NEPUERdLeVM++3UOrBfUi1
	z6CP48uL9/fTgB4hdfWSc6EFk8spKKE=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Sa0ZOvLx;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf03.hostedemail.com: domain of lianux.mm@gmail.com designates 209.85.214.169 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784516634;
	b=bz8wajfY96U6fK7Ik/c19WnmbUr2hRXZWD/PcNESU8vnVs5bJaq7uPO9wZjoajyw/cbqmw
	TlnR2OfUG83oFNV7Q2lF/Fz4gfY4tNMNhRBZ80Y+qeBz1GyCYZu6F6jn+N7oV54ZRNkFH9
	G9LYu2bxy8r6dXHQDaeUL+mwpioeT9Q=
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-2cc73e322dbso113438905ad.1
        for <linux-mm@kvack.org>; Sun, 19 Jul 2026 20:03:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784516634; x=1785121434; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=X+CN3F8GNJ49+wMCUtm6B3zkpBPb78+r1IbCrOzeLVY=;
        b=Sa0ZOvLxyiTbFiMo9s25ap4qb13dUH3/vvJd7600i0GtYro5PDLQZJ18jh8g6vPvQD
         oOZTKQ9LVca0c8BoERdXGFfFPkYD39G9BYhUxbH8eYqImvx+K3O6zG4r9IUdrsKk1+RG
         xkt94wxndttJGjV316+UgNwcUbHOCGa0/gXZEBjUXGAgNMhUVXitEe1HrN6vB7BpUC8o
         huskeg8Sf3QG9Xj2VXR+/m7aC+gOHAQ4gh6tHXlr7/HCSi8WjWIAKTCU4xJWOjGRi+Jj
         C+ef9D55u/0NGydi4mM6LkYPBOIYuiqN5B5GaX3IvrEeHfkcgtG8aUX5bTbqzjowk0XU
         uGkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784516634; x=1785121434;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=X+CN3F8GNJ49+wMCUtm6B3zkpBPb78+r1IbCrOzeLVY=;
        b=gqysvysOwvxxL1uZNF0olEmCPRqRsLL+6GiLcTOZTQFXcQThz9bZsHDRzJftIof480
         ySeAnEmwYCr78mJJFX+5HN8UHibmB1QjuDmVf4blJtTgmFDr2LwpNmYyz8XyAeqtRIRn
         M/rSf4haE/auz0qSClgUBwNsgNkjQRkXK3loBVvGHXoWP12Y6FYFhLEdlV10FDCUfzqn
         lZmHf0suO+s7O2AdTKdowuYL53YhQ70nPa2BbIdmwNloJRwv5mBn242jqjUHnMms6oBn
         p38bvJwaxcnYP7gpXZwzsNMPT3+1f6MpTwJm3uwWYIYo6r++5+IAn/VzNXXFrXx3XsGO
         PWfg==
X-Forwarded-Encrypted: i=1; AHgh+Rosp4KV7J4oIi35Ods7ySVbbhW6IAtwflEk5MbQlXamM2HWIhkCmXl3KDV8lQXZU0d1XQy4EfycQA==@kvack.org
X-Gm-Message-State: AOJu0YwNNGr/dXp+1tS4Kj7F5vPag6YuPkOkaHo5H43N4qMq0RGl8qc6
	Rt0vmtIn4OBYtul4JWaBwa9zkety1j0c7AxG/5ZA8Ib2of2s6JDlqgsr
X-Gm-Gg: AfdE7ckMy8r6guLee2Ms8oLEgaJsP4RBfx6sgqDneT9t1xr9GahvxSEdipCp2IZJXos
	OvbNe4z4MdX4t0RL9TDIKn9xKH7+0X/zNBX8aPLWq9LFWGXnFl0GCIl4Q5igQo8HtBfyekSdlwq
	Wn1a8/bhTFskUIFGi5cdsmxUhEywj8pTD6NtG0/EqvBqQQ9BJxOCyVx3119Pu3moch+s5zMAZLu
	vTvg8S8VPgyVWVLuWrh7USVuZvfhJQPxCs4jJIHntVFqAlQMMv7czu4ngDO6d1uCAtBHp9rc2KQ
	raIG5da7aAgShLYea/5ucMZcyoBs/YNFBs2W6TWVqMdvKotx6wBmKNpbk0oNQi5cYOXU7ocS7Bb
	Gs7o2C8280BqWijZ8GpaCmF6xlRO0Ind3zEKZ852NYDk/TUlDFCYEvsfi4ETB2quQolid/uw9pR
	ornlt8i3N1GpK/9LddpExkmibLugg=
X-Received: by 2002:a17:902:e54b:b0:2c9:b48c:fdec with SMTP id d9443c01a7336-2cf348547d0mr141397945ad.12.1784516633659;
        Sun, 19 Jul 2026 20:03:53 -0700 (PDT)
Received: from localhost.localdomain ([112.65.87.25])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2cf344d80e6sm47783065ad.29.2026.07.19.20.03.46
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sun, 19 Jul 2026 20:03:53 -0700 (PDT)
From: Lian Wang <lianux.mm@gmail.com>
To: damon@lists.linux.dev,
	linux-mm@kvack.org
Cc: sj@kernel.org,
	akpm@linux-foundation.org,
	linux-kernel@vger.kernel.org,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	npache@redhat.com,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	ryan.roberts@arm.com,
	daichaobing@sangfor.com.cn,
	wangkefeng.wang@huawei.com,
	gutierrez.asier@huawei-partners.com,
	zengheng4@huawei.com,
	kasong@tencent.com,
	corbet@lwn.net,
	skhan@linuxfoundation.org,
	linux-doc@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	lianux.mm@gmail.com,
	lianux.wang@processmission.com,
	kunwu.chan@linux.dev
Subject: [RFC PATCH v3 2/3] mm/damon/vaddr: implement DAMOS_SPLIT handler
Date: Mon, 20 Jul 2026 11:03:26 +0800
Message-ID: <20260720030327.80153-3-lianux.mm@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260720030327.80153-1-lianux.mm@gmail.com>
References: <20260720030327.80153-1-lianux.mm@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: EB8FC20009
X-Stat-Signature: 3xejukr5u69xpombfye7am3nicnikwhh
X-Rspam-User: 
X-HE-Tag: 1784516634-447290
X-HE-Meta: U2FsdGVkX18XJb+NS+3vb/7R0oya7u713z6X1I30kmebkKtoGpOCeUwMk0nDgdLshm+wATaTnIGCuAko9PDXXvgKeaLt34GcRNzoNhraPVLduCD9f0PHJUGeDcr+7IL9gVNxokc8sgMSz5XTBnnOYmnz2CIQyizTJknsyYFNdHSuVSdIYY4uHayelnuJeZuEM9iy7XVaJqjR2ToGQjRvttw5hBtmMf8Z7qXRHABMCf2RQ7GuN9Wzbg867+lll1Z8M5VOuZNzmePzd2Hy4naSOMWc1T8rxpFORKRFUjPVKDbr29NZktKKmBXuTvLDAM1aP1flUs6fz2aILio51OIYYmqdVeObAaoBP1yc7ezDQyof0PazL5bB69OVLykADD0aKo6nPaFGwZ1uujBVA1TCR2oVHJNKGcFcZ20b36Nlrh6G1zUpoCROY18mBETFAgRxjh/erF7Df5bjaQEUjYrz5p4ZWp5fZuaz38aHzwIlNBRlV2HOqG6uJYbbLSSRExFs81O8+FJvn32nKmjrRtox0ostn/S623ydL2ejMGWlMswb1wzyMd3yrCmBv5oDgALuTTcTbAiLx5Gw03iAkDZ4yPrTvhU81oCOqjI9kuuZxfplXNndhJMJgWWBUFvfPKE2e9U5AX+ay+IOQnvWcZ5qToe1dO2jV7DgiLBg/FiCpsDN8ZbcoTAP7HyAzshxiNFyAqkwo2ark5hYitktKLXnnUiEmCVmnJQR+gVQDX1ANuWTl7rSsP2wmjnZFnaPrl7P+aYtelZbymg2DU+GTiKPFbBjBTX+Z51ZbmE8eNZruD+gCyRqzVmGa8pJQ/eUDHAxsTwzD8wuKIDFOny02/vgFeUJCNlafVl2uRIx1RMPU6yXBY3sPD3hJq9Uvc/1GLeHi0N+o5G/XDyHk8qlE9CGejAlzoZPdzx5062YMbOVBQJl1Mp4SujPaF22SeWAMErF2xV2vqOn7f4fxWQMrNX
 j/ai5KD6
 hPMqCeZ0AHrbgD6pQhuIWDTYRac3G86P5TsIoohCOe3zXFkLTe1kuFE4buDWYVySFwSwq/3JIpiwtzxcfsx+Ogh9IQOh6eVcdyBEF9f9U43J1d2eV322/5pdqPNwiDNWCs+edEQT7q762Yq/77C3VAvHJuje+q+G4UXSn5Tu+2KrEPhmqGDSJpgntZe3cU26pB+SkJ/apXEPVpDyGyoNkI5YcQHuUbyF5QLIUZzIEYXnZjTh6uYNOYXz8mpfpzCdxn94gpmtpqAt6wFJ51wuOaH5GxcOAiUj0CFNvML5NFCezyqAjaaFzezuotsJ3CZrN2m87IC/UcTG/xYqUXCEezZiU4M1hLLOAVB+u9rbey2Jo8igwDD9647KAluVqAcQp3QHHOFVFecrjSeTUfPTHslK7PkuPG1J3bFgZG6iShpLwq7WZKeNSWxGGSLYLLZW1WYxkwY1G1BsPBBR7rU5sLIDfi7qI/1XvKbh5DWcCKu/PE/VhQFp6WP8bn8eCpqX5DEM5MqkgQSabIudoJEGQK/iePajaZPINpHPk
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Implement DAMOS_SPLIT for the vaddr and fvaddr operations sets.  For
each large folio in the target region whose order exceeds the scheme's
order, split it down using split_folio_to_order() -- the same helper
used by truncation, migration, ksm and shmem.  No new core-mm code or
exported symbols are introduced.

split_folio_to_order() must not run under the page table lock, so the
folio is pinned (folio_trylock + folio_get), the walk is ended to drop
the page table lock, and the split runs while holding only mmap_read_lock.

The scheme's operations-layer filters are honoured, and the amount of
memory that passed those filters is reported via sz_filter_passed.



Co-developed-by: Kunwu Chan <kunwu.chan@linux.dev>
Signed-off-by: Kunwu Chan <kunwu.chan@linux.dev>
Signed-off-by: Lian Wang (Processmission) <lianux.mm@gmail.com>
---
 mm/damon/vaddr.c | 108 +++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 108 insertions(+)

diff --git a/mm/damon/vaddr.c b/mm/damon/vaddr.c
index d10b8042adb5..a8607448584d 100644
--- a/mm/damon/vaddr.c
+++ b/mm/damon/vaddr.c
@@ -6,6 +6,7 @@
 #define pr_fmt(fmt) "damon-va: " fmt
 
 #include <linux/highmem.h>
+#include <linux/huge_mm.h>
 #include <linux/hugetlb.h>
 #include <linux/mman.h>
 #include <linux/mmu_notifier.h>
@@ -896,6 +897,111 @@ static unsigned long damos_va_stat(struct damon_target *target,
 	return 0;
 }
 
+/*
+ * damos_va_split() - Split large folios in a region down to @target_order
+ * using the existing split_folio_to_order().
+ *
+ * Locking: folio_walk_start() returns the folio with the page table lock
+ * held.  split_folio_to_order() must not run under the page table lock,
+ * so we pin the folio (reference + lock), end the walk to drop the page
+ * table lock, and split while holding only mmap_read_lock.
+ * split_folio_to_order() returns -EBUSY for a raced or pinned folio;
+ * we skip such folios.
+ */
+static unsigned long damos_va_split(struct damon_target *target,
+		struct damon_region *r, struct damos *s,
+		unsigned long *sz_filter_passed)
+{
+	unsigned int target_order = s->order;
+	unsigned long addr = ALIGN_DOWN(r->ar.start, PAGE_SIZE);
+	unsigned long end = r->ar.end;
+	unsigned long applied = 0;
+	struct mm_struct *mm;
+
+	mm = damon_get_mm(target);
+	if (!mm)
+		return 0;
+
+	while (addr < end) {
+		struct vm_area_struct *vma;
+		struct folio *folio;
+		struct folio_walk fw;
+		unsigned long folio_sz = 0;
+
+		if (mmap_read_lock_killable(mm))
+			break;
+
+		vma = vma_lookup(mm, addr);
+		if (!vma) {
+			/* Skip the gap to the next VMA, if any. */
+			vma = find_vma(mm, addr);
+			mmap_read_unlock(mm);
+			if (!vma || vma->vm_start >= end)
+				break;
+			addr = vma->vm_start;
+			continue;
+		}
+
+		/* Folios in these VMAs are not our business. */
+		if (vma->vm_flags & (VM_HUGETLB | VM_MIXEDMAP)) {
+			addr = vma->vm_end;
+			mmap_read_unlock(mm);
+			continue;
+		}
+
+		folio = folio_walk_start(&fw, vma, addr, 0);
+		if (!folio) {
+			mmap_read_unlock(mm);
+			addr += PAGE_SIZE;
+			continue;
+		}
+
+		folio_sz = folio_size(folio);
+
+		/*
+		 * For file-backed folios, @target_order may be below the
+		 * filesystem's minimum folio order (mapping_min_folio_order()).
+		 * split_folio_to_order() will simply fail in that case and
+		 * we skip the folio.  This is a safe no-op; future work can
+		 * adjust target_order upward like split_huge_pages_in_pid()
+		 * does when a specific filesystem needs it.
+		 */
+
+		/* Honour the scheme's operations-layer filters. */
+		if (damos_ops_has_filter(s)) {
+			if (damos_va_filter_out(s, folio, vma, addr,
+					fw.level == FW_LEVEL_PTE ? fw.ptep : NULL,
+					fw.level == FW_LEVEL_PMD ? fw.pmdp : NULL)) {
+				folio_walk_end(&fw, vma);
+				mmap_read_unlock(mm);
+				goto next;
+			}
+			*sz_filter_passed += folio_sz;
+		}
+
+		if (folio_order(folio) > target_order && folio_trylock(folio)) {
+			folio_get(folio);
+			/* Drop the page table lock before splitting. */
+			folio_walk_end(&fw, vma);
+
+			if (!split_folio_to_order(folio, target_order))
+				applied += folio_sz;
+
+			folio_unlock(folio);
+			folio_put(folio);
+		} else {
+			folio_walk_end(&fw, vma);
+		}
+		mmap_read_unlock(mm);
+next:
+		addr = ALIGN_DOWN(addr, folio_sz) + folio_sz;
+		cond_resched();
+	}
+
+	mmput(mm);
+	return applied;
+}
+
 static unsigned long damon_va_apply_scheme(struct damon_ctx *ctx,
 		struct damon_target *t, struct damon_region *r,
 		struct damos *scheme, unsigned long *sz_filter_passed)
@@ -926,6 +1032,8 @@ static unsigned long damon_va_apply_scheme(struct damon_ctx *ctx,
 		return damos_va_migrate(t, r, scheme, sz_filter_passed);
 	case DAMOS_STAT:
 		return damos_va_stat(t, r, scheme, sz_filter_passed);
+	case DAMOS_SPLIT:
+		return damos_va_split(t, r, scheme, sz_filter_passed);
 	default:
 		/*
 		 * DAMOS actions that are not yet supported by 'vaddr'.

