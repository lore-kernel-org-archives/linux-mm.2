Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F194BFD3774
	for <linux-mm@archiver.kernel.org>; Wed, 25 Feb 2026 16:34:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8B9116B00C1; Wed, 25 Feb 2026 11:34:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 883A16B00C2; Wed, 25 Feb 2026 11:34:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6C6816B00C3; Wed, 25 Feb 2026 11:34:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5B2CE6B00C1
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 11:34:43 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 0C1631B71ED
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 16:34:43 +0000 (UTC)
X-FDA: 84483527646.24.AC28FB8
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	by imf15.hostedemail.com (Postfix) with ESMTP id 3F0B6A000C
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 16:34:40 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=bz1ljrZr;
	spf=pass (imf15.hostedemail.com: domain of 3nySfaQgKCLghYaikYlZemmejc.amkjglsv-kkitYai.mpe@flex--jackmanb.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3nySfaQgKCLghYaikYlZemmejc.amkjglsv-kkitYai.mpe@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772037281;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WDhIQvWuRYWeMcMrzum83Q6jG6Th3ZjaaGYgK9BTHd4=;
	b=dxUxYU9z6MqTnIbp716ootOpAE9obSIRgBfHxGkLQHWjTCW7/9X5cSKghaiKmJD2ND01WP
	TJU61/+Wou0ylHFtCREOotQD0KKBLwZ2Di+j4KJPmhWJZxQDeJDCoJLJy5LEktj9MU6fkE
	0t+iZBVrvzVD2P8gVeA7Hfxp7mHhQFU=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=bz1ljrZr;
	spf=pass (imf15.hostedemail.com: domain of 3nySfaQgKCLghYaikYlZemmejc.amkjglsv-kkitYai.mpe@flex--jackmanb.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3nySfaQgKCLghYaikYlZemmejc.amkjglsv-kkitYai.mpe@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772037281; a=rsa-sha256;
	cv=none;
	b=sRNmcUCUykUXjZ/RhGQqtNBHZg1zKRF+pk3MuZ4Ny6KbXLU2mUlxJ22vDdr4pFbSVc0QMo
	Z/JpE2/vCWUiwKH6Uqzz/dQCH7kZ22W5lyiqL67926EmCdhj0MtFFEuVpvtxhOMX8smZe1
	2U6DNh6s986qCWVYsUp3VLzk6H+zLGU=
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-483101623e9so60284505e9.3
        for <linux-mm@kvack.org>; Wed, 25 Feb 2026 08:34:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772037280; x=1772642080; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=WDhIQvWuRYWeMcMrzum83Q6jG6Th3ZjaaGYgK9BTHd4=;
        b=bz1ljrZr7uUylSnJ4olqg9EU4OAL0MVrVh3SjB5rVTmFEGjGqms5Z5AhsYTmWr/bBW
         PIIEkUchzwhzODc9I5n0x/H0lnvxyLa2xE6N8SFDaEG8LVw5wsV3GMvW57AV7nHBfgDJ
         2mZyuBDWELkf+EgJ9hOx/GV9raZCmF4EBIoDFSDPHQu+hOIHQHCr/fl5FDWIbdLXg08G
         WV+gzKGHMO2xyNauzoq9e0Cn9+6C3l6HgvQrEp2g5OCYLSx+ezubFCax3UdgBYwZSKDk
         WUBujetfjbXBlKhZJ3YejHPcVtH3bE6qbN8/MltZbNDW5qJx8iPbe27GuIWl+jXHjvdc
         vcSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772037280; x=1772642080;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WDhIQvWuRYWeMcMrzum83Q6jG6Th3ZjaaGYgK9BTHd4=;
        b=fD0bvz5rTkTDYfyeA0sw1/OQbyG8oZwKPLT0m4WgbA1EX9ubgl2plklPApANAiq3nB
         AOuwEHzZf1t3utD68f3MvKHYNJw1NXwdTAXAxjjjezu/F3IG/f6zcJEnSnJkIdkP8npU
         MoccuJp33Al3UXOhlRoD7zbSDWdZu+GX24nzrTTq7p90a/83Q3MDyw77yH7gDRNj0peG
         Q3Xiz/N4OU3lsktBiq03bWhFspgM8hhK9suttEJjpMvetHRjEFjL0hK8MhpgLHHHExUg
         h7Yy+/CBOX0fNEJeiHpQZBv9021LOOJDfuzSEnsAYOP8Lo0FJPgNuAor55l3ntQ9CMdY
         GOcg==
X-Gm-Message-State: AOJu0YzSy2mLvmKY0/8II4OqlZfwwN3MZ6R0oi6x4fIIu5zPk9aqfnjj
	3Ztm4iFLm4rgy/w0QNHq7FOiivhWiNZGmGRvgZUV3wZzYZaR+6P6Gg53oxlR/l0btvdy9yNzuxv
	idJ2nEbGOtmTxHQ==
X-Received: from wmbje2.prod.google.com ([2002:a05:600c:1f82:b0:480:6bd5:88b4])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:4e46:b0:483:a8e9:201b with SMTP id 5b1f17b1804b1-483a95a3851mr276690895e9.0.1772037279527;
 Wed, 25 Feb 2026 08:34:39 -0800 (PST)
Date: Wed, 25 Feb 2026 16:34:28 +0000
In-Reply-To: <20260225-page_alloc-unmapped-v1-0-e8808a03cd66@google.com>
Mime-Version: 1.0
References: <20260225-page_alloc-unmapped-v1-0-e8808a03cd66@google.com>
X-Mailer: b4 0.14.3
Message-ID: <20260225-page_alloc-unmapped-v1-3-e8808a03cd66@google.com>
Subject: [PATCH RFC 03/19] x86/tlb: Expose some flush function declarations to modules
From: Brendan Jackman <jackmanb@google.com>
To: Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, 
	Peter Zijlstra <peterz@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Vlastimil Babka <vbabka@kernel.org>, Wei Xu <weixugc@google.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, x86@kernel.org, 
	rppt@kernel.org, Sumit Garg <sumit.garg@oss.qualcomm.com>, derkling@google.com, 
	reijiw@google.com, Will Deacon <will@kernel.org>, rientjes@google.com, 
	"Kalyazin, Nikita" <kalyazin@amazon.co.uk>, patrick.roy@linux.dev, 
	"Itazuri, Takahiro" <itazur@amazon.co.uk>, Andy Lutomirski <luto@kernel.org>, 
	David Kaplan <david.kaplan@amd.com>, Thomas Gleixner <tglx@kernel.org>, 
	Brendan Jackman <jackmanb@google.com>, Yosry Ahmed <yosry.ahmed@linux.dev>
Content-Type: text/plain; charset="utf-8"
X-Rspam-User: 
X-Rspamd-Queue-Id: 3F0B6A000C
X-Rspamd-Server: rspam02
X-Stat-Signature: gd3bthysotpt7jpgzisnb3uh8mbfmiho
X-HE-Tag: 1772037280-923280
X-HE-Meta: U2FsdGVkX1/7zbPdsyNRSnvLUYkqIVIcBoo2wnXHuY9CIX0Hkrvof/n7A9ZYsLdGu1yDJjcG36BhtkkEGyItkdOVKJWLyNHS0R1iZrKdd34HylRqshA5MvfFYr8UZEzBJjwM/CpQxRuzsQLAK0JlZkBlLaxUdxxzbXwHkyljZZMevSwDhB0dMlsPTKny4LJ3mQiB9XG6tljhPayUp1F19f/iWAt62Giy69LycEYzcPszEx9fwyrISNqLYPOQB33el4v+rgPaIAH2UVe4IEQhUm35VAl3GvCfo930ixpw7c7by+J6LSnfT57ThzbdNZnDlVg1dtUwjLyOwl72jp7ZAY6L9TqSCUmfmXlEUpKcDz7FYYZ9O3VvGiQJd0Vb4FKu49ko62B4OkhF8GZo5crfdwOccxcBF+nE6AEiPkmpFiQ5xUEwmOxIXVPchaIly7qb0xOT6VLZVDJVl9+/UcNUVuteXu2U8vghrmoUNw7MAF5VlVwTIkb6MlhzpdeeR+TIj8jMTMP1ikD/GdkbrykNZPpkOSsoY+PWRguvtXtqo0XvbTi9FAYtUZkXlz7IRjK3gkAFcm6kKt+1MVM/b04TTnfY964RZeWqUN8/XB3N6h+OUKPfsztW20LRngY1NQx7Mv0FNcCjPRtqpG6JkHpEsLEXrSgmOCEJUQMtF2ZeTxNj1ACapaUuJ0ubnCbz7OUjkhoULSXO8IImG4HiK+J14ebOWwtOVe5ADwItlv0lXFoy+3rpAwY0CHn3RPB+/XaWZoOC4Tt5GwTV3KrW9csxqyr11sg0Cc6x291/PYBin3fjYWIyVQHaYTuKPIQ6o2sya7QVQYngRIS338+w1ZUPX7rnzngrmUddkJMh6yFYWhxpRUejnuupWB6ASYS7L+AAkFzlrr+KZLrdKAClkwozvPVxZVHecFnwSkbOAUqOcfq14bQvkwqiGHcpuQ4S8oXwN1L1Id3EvLVo1cfzPuU
 7cMUmZvZ
 Oaj0nmTUlAvrMtPD/xPmIeulM39yi5MMT1vjG0W1WakvYXgAhWVJ8CKneM9uzhKJx4jDHin9p3VIdpMZPKE4cUnai/Xw+dkbbDzehKby4vJ2OcxCQasOJPz1mjpF1Dh4zJTuyZqhRqEnUSQYqqQ2exGMOSlfhMBoi+hoVfh+e4QIttxSPkAuvKQgEZxsZeLGvjFjD7VMD7kXFrijggheSTSZufYW+zRs73RpdVaFDjCnGUhJdfGAkbutLWgHijzjJ58S1SPDqci54X9vvcfotQYEK/ujkNJAHhprIfsxrEDdtAqp3UZcbLXPzmwxljuj+a1/srpbBxtLZyOc14a3VkKDn/utPmp/YaVQhaB/gD4pKR7fqUJB5EgFJNvKdYl0MAQzf1ZHkEEvo7Zm3O2M5hTHrvFhsDMK8SoTkY7AbSJGbSW+3j7I6MXWwcBqdKL+Yyb/gdmc+BihDfKjtbntrbOv2+RzlvuGcHMUiDPnAuhcIwcIC6PWGgcIRgrhtp4PQK6B4weS9fhMZgzfUMWwUeewNkWeY08BFobMXuBgB2ubI9LO7iWrg8DquBZQUmAivtdpiyEo08ehH1TZUbJrcEGT4ITLLX/D7eKLek3Cs9Iyv9on0rXOSFFNZBg/NGTJ/8pD/dlq88WTXsZEfu7GYub+/5tg0SlnlDRqBULiUZZ2Np8Inq8YuI8mIQ8vh1r+E2+kH
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In commit bfe3d8f6313d ("x86/tlb: Restrict access to tlbstate") some
low-level logic (the important detail here is flush_tlb_info) was hidden
from modules, along with functions associated with that data.

Later, the set of functions defined here changed and there are now a
bunch of flush_tlb_*() functions that do not depend on x86 internals
like flush_tlb_info.

This leads to some build fragility: KVM (which can be a module) cares
about TLB flushing and includes {linux->asm}/mmu_context.h which
includes asm/tlb.h and asm/tlbflush.h. This x86 TLB code expects these
helpers to be defined (e.g. tlb_flush() calls flush_tlb_mm_range()).

Modules probably shouldn't call these helpers - luckily this is already
enforced by the lack of EXPORT_SYMBOL(). Therefore keep things simple
and just expose the declarations anyway to prevent build failures.

Signed-off-by: Brendan Jackman <jackmanb@google.com>
---
 arch/x86/include/asm/tlbflush.h | 43 +++++++++++++++++++++--------------------
 1 file changed, 22 insertions(+), 21 deletions(-)

diff --git a/arch/x86/include/asm/tlbflush.h b/arch/x86/include/asm/tlbflush.h
index 5a3cdc439e38d..ee49724403ef9 100644
--- a/arch/x86/include/asm/tlbflush.h
+++ b/arch/x86/include/asm/tlbflush.h
@@ -229,7 +229,6 @@ struct flush_tlb_info {
 	u8			trim_cpumask;
 };
 
-void flush_tlb_local(void);
 void flush_tlb_one_user(unsigned long addr);
 void flush_tlb_one_kernel(unsigned long addr);
 void flush_tlb_multi(const struct cpumask *cpumask,
@@ -303,26 +302,6 @@ static inline void mm_clear_asid_transition(struct mm_struct *mm) { }
 static inline bool mm_in_asid_transition(struct mm_struct *mm) { return false; }
 #endif /* CONFIG_BROADCAST_TLB_FLUSH */
 
-#define flush_tlb_mm(mm)						\
-		flush_tlb_mm_range(mm, 0UL, TLB_FLUSH_ALL, 0UL, true)
-
-#define flush_tlb_range(vma, start, end)				\
-	flush_tlb_mm_range((vma)->vm_mm, start, end,			\
-			   ((vma)->vm_flags & VM_HUGETLB)		\
-				? huge_page_shift(hstate_vma(vma))	\
-				: PAGE_SHIFT, true)
-
-extern void flush_tlb_all(void);
-extern void flush_tlb_mm_range(struct mm_struct *mm, unsigned long start,
-				unsigned long end, unsigned int stride_shift,
-				bool freed_tables);
-extern void flush_tlb_kernel_range(unsigned long start, unsigned long end);
-
-static inline void flush_tlb_page(struct vm_area_struct *vma, unsigned long a)
-{
-	flush_tlb_mm_range(vma->vm_mm, a, a + PAGE_SIZE, PAGE_SHIFT, false);
-}
-
 static inline bool arch_tlbbatch_should_defer(struct mm_struct *mm)
 {
 	bool should_defer = false;
@@ -487,4 +466,26 @@ static inline void __native_tlb_flush_global(unsigned long cr4)
 	native_write_cr4(cr4 ^ X86_CR4_PGE);
 	native_write_cr4(cr4);
 }
+
+#define flush_tlb_mm(mm)						\
+		flush_tlb_mm_range(mm, 0UL, TLB_FLUSH_ALL, 0UL, true)
+
+#define flush_tlb_range(vma, start, end)				\
+	flush_tlb_mm_range((vma)->vm_mm, start, end,			\
+			   ((vma)->vm_flags & VM_HUGETLB)		\
+				? huge_page_shift(hstate_vma(vma))	\
+				: PAGE_SHIFT, true)
+
+void flush_tlb_local(void);
+extern void flush_tlb_all(void);
+extern void flush_tlb_mm_range(struct mm_struct *mm, unsigned long start,
+				unsigned long end, unsigned int stride_shift,
+				bool freed_tables);
+extern void flush_tlb_kernel_range(unsigned long start, unsigned long end);
+
+static inline void flush_tlb_page(struct vm_area_struct *vma, unsigned long a)
+{
+	flush_tlb_mm_range(vma->vm_mm, a, a + PAGE_SIZE, PAGE_SHIFT, false);
+}
+
 #endif /* _ASM_X86_TLBFLUSH_H */

-- 
2.51.2


