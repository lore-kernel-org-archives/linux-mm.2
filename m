Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D7E20C79FBF
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 17:16:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 880566B0092; Thu, 10 Sep 2026 13:16:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 858196B0093; Thu, 10 Sep 2026 13:16:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 76D726B0095; Thu, 10 Sep 2026 13:16:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 437336B0092
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 13:16:34 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 60DC1A061F
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 17:16:33 +0000 (UTC)
X-FDA: 85198506666.16.B661FAA
Received: from mail-yx2-f8.google.com (mail-yx2-f8.google.com [74.125.224.136])
	by imf24.hostedemail.com (Postfix) with ESMTP id 724AF180002
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 17:16:31 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=GyGAzbFn;
	spf=pass (imf24.hostedemail.com: domain of ravis.opensrc@gmail.com designates 74.125.224.136 as permitted sender) smtp.mailfrom=ravis.opensrc@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789060591;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=U8F+pCWHvp6Bk2nFVk5sf15ui0cPT96FgZ/ARqD+0QM=;
	b=qXacOC7vIl84A+hgNcdMmc8GgypIbjFHyjtn3QDL5xjMjHi1Zyp/317xzgh3DNT5lR58mi
	54EcayseY9r0JULcZVnxmS8P4BAlUdv1ix+tlDBoGZmt9vgovbFURSAwskYG1j8TU7aV7c
	0gexdob0dEabOh4Ddxrpsim55hdIsC0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789060591;
	b=UUDFMwYmmvsue6sBQztlYoN8AqgRBGhxXZdbo8AwcAN7kw8fx2CcVroMO3M/j7ACHTSfgw
	JxAmnvj+N2lVw6/zUSzVFoGfUkmQNHhZxx+9OMfLXVk4WWJ7oe76NkLLvEBAd/2bdF+z6x
	rcM0wCKoHtIIZljR8uMPZAEFUxIUVnE=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=GyGAzbFn;
	spf=pass (imf24.hostedemail.com: domain of ravis.opensrc@gmail.com designates 74.125.224.136 as permitted sender) smtp.mailfrom=ravis.opensrc@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-yx2-f8.google.com with SMTP id 00721157ae682-854f090ff98so38506067b3.0
        for <linux-mm@kvack.org>; Thu, 10 Sep 2026 10:16:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789060590; x=1789665390; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=U8F+pCWHvp6Bk2nFVk5sf15ui0cPT96FgZ/ARqD+0QM=;
        b=GyGAzbFnKYTqewNcIPUznUWKWisW0oT664r8o8KH2GKpmIsO5VZmwcdyEoF8N+Rkos
         HTDVQATU8Kf3sQ7t071pBM/brGN2ObXR7bpNEZ+4gQdbAykwy97UUYLU+YBsAOwRFFf6
         jZJXhoyZpC8B/f+3n0mtKy6niYWcCg9G09LwbfDWCCcJEp3Q17xRTjZ5x99oWFYhMWdX
         Ih+ceF3I9pi7q4A2HlPOZgWkqis58dWsHpiW5E3YmbxY0QH4p0KN89UF2RAfndRk0+4h
         KJrH3cTsaTa2TMQFviaTnlXBibcGOhWW0LX1hVPzOktRQroPdCyI0u/UjI6Bpbgsl/AH
         YzXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789060590; x=1789665390;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=U8F+pCWHvp6Bk2nFVk5sf15ui0cPT96FgZ/ARqD+0QM=;
        b=aO+gPyYnTOTmOCkUeEGVYN8e/FYolZd2sQmfyqJkV7ni53z4pACTe5FG2J2+iE657/
         +dWaKwLBXZpBEErRhWg1BHMgU4A3ANTpQQ73YVPvGd7F8445GUXn6UQ0HLrW6/uwra9k
         iSeP8ng4WswadPFeeG4Bm3g/6wLffIwlgyBg4Ku04rBhQ6v3jmffezL3jFeM12UeBfHQ
         gPcrA9qbi09Ja0lFDeCmvMCVtWUpWv/jAIiOoylhmTv8u1zo+FUGoQZ/E8pRV5NRSOby
         59p3aJ/G0dpdE4P0OQ9R5TXueYYnqvK4cGIBuEhays/O0x72Y0VGwIlfDc/3twNKv/AA
         juTw==
X-Forwarded-Encrypted: i=1; AKwUvByOdjUw2+XeqAVK5hYmY+DtQ0ixVrT5f+hWieolBkT8iGTyKFb80eY+yo9qOy+3p9yExADJKRVZ/g==@kvack.org
X-Gm-Message-State: AFuF++lWFhcPYSHyFFA3efz8On31kHDujSjrvIzH8pdcUyFpKDR510hE
	E/NoqJEjLKeJc6VHL6BsYPMQnXpPJ7BI9efka0oxBUZefIwu1AP5aEw=
X-Gm-Gg: AYBFou1gOSuElldOnbo9pN9E7dsPVjdG8O1LNiJKxjlaAEBcfXNkc/ER5Sa9Y5bUXh9
	WejsHsg7YYvJPmpZnEp5H+TQ/dDbvSjQ8u74k/clt8On9B+0eT4vo6sXfBjsztNGf6oQOyLIPfC
	BQYDIxP7Lt4W6GsXbYZpa1GZ+V+KIXH3aicIF01my38LB+JWD5fBIzfpMRxkU8hHYLkc3K8nScX
	uguxXHmP2tv0XaCkMaWx5QGrRrTWmLQGWLp1PxBmQ9ydXDz2pb0EEYyjuuRcrQH0+yDkbpH8nYe
	kE868cKfnLdsdlrJagZP+tbnWlXfXC201yUctWJB6JXAcopV2dxgWaVaQJwMkjrCSr6QxEzKDys
	ECdede6a3WdOJGom8tXJdYv665aARw94u17M0A8r0C4kaKd7Ghcbf4F44kra92IoKTYHTutKZGX
	LqQ7ehmZE0jMcGp8tsdCXW5IW18vQXVtNGxMGLSLIUF2/UBoZ9EMh3DdYm11p3N0coKxbdJYWZw
	pnIwkejKk8RBirqn2kFdXyCicgJvKrPQ1P7QnndySHa3mGyw7at1OGw1laL
X-Received: by 2002:a05:690c:d83:b0:865:838f:485b with SMTP id 00721157ae682-884ad14f632mr2358197b3.4.1789060590335;
        Thu, 10 Sep 2026 10:16:30 -0700 (PDT)
Received: from localhost (23-116-43-216.lightspeed.sntcca.sbcglobal.net. [23.116.43.216])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-884890160bbsm2241007b3.42.2026.09.10.10.16.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Sep 2026 10:16:29 -0700 (PDT)
From: Ravi Jonnalagadda <ravis.opensrc@gmail.com>
To: sj@kernel.org,
	akinobu.mita@gmail.com,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org
Cc: akpm@linux-foundation.org,
	corbet@lwn.net,
	bijan311@gmail.com,
	ajayjoshi@micron.com,
	honggyu.kim@sk.com,
	yunjeong.mun@sk.com,
	ravis.opensrc@gmail.com,
	rientjes@google.com,
	weixugc@google.com,
	jic23@kernel.org,
	gourry@gourry.net
Subject: [RFC PATCH v2 1/9] mm/damon/vaddr: support page fault access check primitive
Date: Thu, 10 Sep 2026 10:16:15 -0700
Message-ID: <20260910171623.6638-2-ravis.opensrc@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260910171623.6638-1-ravis.opensrc@gmail.com>
References: <20260910171623.6638-1-ravis.opensrc@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: okfao8d91tuoyq9b8cnf5yd8af84m6bu
X-Rspam-User: 
X-Rspamd-Queue-Id: 724AF180002
X-Rspamd-Server: rspam03
X-HE-Tag: 1789060591-86486
X-HE-Meta: U2FsdGVkX1+QcYaOpU9A/Xdnnhwg1KbXO+FGH5ykt8PEsm+G/BwP7/UCDn9J25/ZailSTH4ltCjndKbc5zcRw/7J4UM1GeoBFz4g8XBOsHhI2+P7KixJQ4OnvHQQr5naIZ6myyL9yzB6hvCwJBU8tpnWghRsbV6UQ8dKZ2tLEXRJtBtDR3z+cs02Hr654am6Pn1EobmnJee6woMK3Ox8FcY3J+24oTbTJlaB8sUa/apF65uWac5a4+ENtFMELdrq0PVJubxLnNisdtYHWuYu2+8F39lxz7MZQjo4wVvY53/o4Cd82sV0n8RNl/N6DkwsgMKoC35GNS9BYF2VwLIiqVlY65x8lQiK2Zu1twh0dLdZ2D0ji89r9t7tCQqtzHwUawMVQL7u75slwsUG+Fwt8GX83ReKs7rl+4tUEeSjmixnBnHk3he5QLQi05J8cAcObfrEcmO2hsI2Z+fr2sw1MYr8zBcQnWXfF+jgsSIktDMGOy4oy2d7MfsWIHwTupHFzi5levseQmZQ++Iv7PGIzaMrvQzatzN/svFs2iL/53dAC57GrYBSUYvqP45Fdx9y29szUmcCEAmPzPwHR/3wnasEx70LHvBrDU8hQPzo8uQCSjguskTG76+QP/HRrZ+xGk24PizFG6Ajz1v4RLLpPCpmb33AoG89HjC55NZfVkcPtl6vmDnefkkfWRK/jCQLq9vh59xuKAU4rFYE6HHJ9qqiS2aEMrLQuECjNB6pRrYFkusJoOvnP/HfCuioMQuvb+CoSFnn7lfUnu1XMm8Vgz3rDSg3VqCBL/BaxAW+ZRw9J5R5JyaUHgeKyXVYhuJEeOljybCOFTpxsvLLx1N7fj8+NTh2/QSeKFPYYPmbm4g5CGRHfe8KTMMJocRFIycb0C3uWUgXqd7kCBJizX8jq50mFevI4Wj2AWMFpXdBJhWgR1qNDYweCvHg79oTN+/KR/TJdjhzBYc7TGqeGym
 JTC0JAL/
 NyTKVw9Nt0JRVT7to8zRdjic7Ytak/W26dH6FgeFljTV4aSU8UF8kunSNf7wA98qj9EfvBLJpXVkitDqVeCbpfiUKPeICJJzUtDlyAAvIChP7MCM7aOxEftaKyCQvgvrEOsBIqVXHZ9qvVXAbiw/xqaqkNdQJWKiYnBSNi3xJXRFPkP94pKElzYmS+SPmWLsRnvRKWga0YshHFQGpp7mIO/MaRZS/ZpHgYNTQJq+OJ8t4l5mpqs7ryiDVVviwCA4Ntc9RzJSEHTzN73ey1xw1j5p9fBW6CsFcolyLEgLsiMNflfacHAQ45oZ/8t0SW24nWuey6e+pGqj86Xgls8D6ZaFZL2ilPWBZF92WphJTo1WYV1+HNe0ZjgkMSmSrJepElbL7bi6V329uFDcmgDfPr6N/0toSdQrw1tdrxBgMcWKFUUdBN4F/Qt+8FBDwJrsEABjVGOeB8gH13RdYVY+nAiFX4ZvU2o59EC6P8Vc1eVApJDYDmkU+36i2vb7V/b5dGB++4gEiHTWJ7nFVMlAMWGO7TKIOWdpzSd7Hn5L3N11WtqEOY3HJgc+PippPCGflRvUo
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The page-fault sampling primitive was implemented for the physical
address space only, so a virtual address space context had no way to
enable it.

Implement it for the virtual address space.  The prep installs the marker
whose fault reports the access on the sampling address of each region,
mirroring the physical address space primitive, and prepare_access_checks()
now dispatches on the enabled primitive as the physical address space one
does.

The target mm and the vma of the sampling address are both available
here, so the marker is installed on the mapping directly.  The physical
address space primitive has only a physical address and reaches its
mappings through a reverse mapping walk.

Signed-off-by: Ravi Jonnalagadda <ravis.opensrc@gmail.com>
---
 mm/damon/vaddr.c | 65 +++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 64 insertions(+), 1 deletion(-)

diff --git a/mm/damon/vaddr.c b/mm/damon/vaddr.c
index d5dde97b3cd0d..1f2d923e569d6 100644
--- a/mm/damon/vaddr.c
+++ b/mm/damon/vaddr.c
@@ -13,6 +13,7 @@
 #include <linux/pagemap.h>
 #include <linux/pagewalk.h>
 #include <linux/sched/mm.h>
+#include <asm/tlb.h>
 
 #include "../internal.h"
 #include "ops-common.h"
@@ -329,7 +330,8 @@ static void __damon_va_prepare_access_check(struct mm_struct *mm,
 	damon_va_mkold(mm, r->sampling_addr);
 }
 
-static void damon_va_prepare_access_checks(struct damon_ctx *ctx)
+/* Use page table accessed bits */
+static void damon_va_prepare_access_checks_abit(struct damon_ctx *ctx)
 {
 	struct damon_target *t;
 	struct mm_struct *mm;
@@ -345,6 +347,67 @@ static void damon_va_prepare_access_checks(struct damon_ctx *ctx)
 	}
 }
 
+/*
+ * Install the page table marker whose fault reports the access.  The target
+ * mm and the vma of the address are available here, so the marker is set on
+ * the mapping directly, without a reverse mapping walk.
+ */
+static void damon_va_change_protection(struct mm_struct *mm,
+		unsigned long addr)
+{
+	struct vm_area_struct *vma;
+	struct mmu_gather tlb;
+
+	/*
+	 * The sampling address is a random offset within the region, so round
+	 * it down to the page it falls in.  change_protection() walks whole
+	 * page table entries and expects a page aligned range.
+	 */
+	addr = ALIGN_DOWN(addr, PAGE_SIZE);
+
+	mmap_read_lock(mm);
+
+	vma = vma_lookup(mm, addr);
+	if (!vma || !vma_is_accessible(vma) || (vma->vm_flags & VM_PFNMAP))
+		goto unlock;
+
+	tlb_gather_mmu(&tlb, mm);
+	/* todo: batch or remove tlb flushing */
+	change_protection(&tlb, vma, addr, addr + PAGE_SIZE, MM_CP_DAMON);
+	tlb_finish_mmu(&tlb);
+
+unlock:
+	mmap_read_unlock(mm);
+}
+
+/* Use page faults */
+static void damon_va_prepare_access_checks_faults(struct damon_ctx *ctx)
+{
+	struct damon_target *t;
+	struct mm_struct *mm;
+	struct damon_region *r;
+
+	damon_for_each_target(t, ctx) {
+		mm = damon_get_mm(t);
+		if (!mm)
+			continue;
+		damon_for_each_region(r, t) {
+			r->sampling_addr = damon_rand(ctx, r->ar.start,
+					r->ar.end);
+			damon_va_change_protection(mm, r->sampling_addr);
+		}
+		mmput(mm);
+	}
+}
+
+static void damon_va_prepare_access_checks(struct damon_ctx *ctx)
+{
+	if (ctx->sample_control.primitives_enabled.page_table)
+		damon_va_prepare_access_checks_abit(ctx);
+	if (ctx->sample_control.primitives_enabled.page_fault)
+		damon_va_prepare_access_checks_faults(ctx);
+}
+
 struct damon_young_walk_private {
 	bool young;
 };
-- 
2.43.0


