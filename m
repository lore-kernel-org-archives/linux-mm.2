Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 42C86C5AD5A
	for <linux-mm@archiver.kernel.org>; Sat, 15 Aug 2026 05:20:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 551EF6B033C; Sat, 15 Aug 2026 01:20:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 52B0B6B033D; Sat, 15 Aug 2026 01:20:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4674D6B033F; Sat, 15 Aug 2026 01:20:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1E9886B033C
	for <linux-mm@kvack.org>; Sat, 15 Aug 2026 01:20:18 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 812E0A2A4A
	for <linux-mm@kvack.org>; Sat, 15 Aug 2026 05:20:17 +0000 (UTC)
X-FDA: 85102352874.17.F3D108C
Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	by imf29.hostedemail.com (Postfix) with ESMTP id BB608120004
	for <linux-mm@kvack.org>; Sat, 15 Aug 2026 05:20:15 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="Tt+ygB/F";
	spf=pass (imf29.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.216.47 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786771215;
	b=l45dzmYZ49JoM11LQDJW67FNJq2OXrMYzjv2J0XoIBUeoIoniGwRu3Mjj9ya5+ZnHh194h
	2tt8d6jt3nPDHLLd9cwpCe2B9hfhHZlR1qZMkSPo5zW8vq8LCrvTTJ7CcHj6yHUqRmLcYH
	Z4lM6L586XMQvfLkypbUe3a5D4Q5gmA=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="Tt+ygB/F";
	spf=pass (imf29.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.216.47 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786771215;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MGLWuLEG0kDSgM2QRoCYSrx2dw3K2Ihdk1BDWCYkYo4=;
	b=S11ZSPzR0wXxQhaJQ0E8WHR763h/Y8F9VE05Y0GMU8ub9ga2l4V5yKd2UndBIwISSomJZx
	SlzmtDdEgDz4ZEQM7/zdVPqZ/149v1hD4rrmTz2ZjqbaUsnufP70cM/zweJyTrfUQK/Fa3
	ET4rRmwJi1qlUC/3IR0lSjmZt/Nubqs=
Received: by mail-pj1-f47.google.com with SMTP id 98e67ed59e1d1-3810c5d691bso1321216a91.1
        for <linux-mm@kvack.org>; Fri, 14 Aug 2026 22:20:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786771215; x=1787376015; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=MGLWuLEG0kDSgM2QRoCYSrx2dw3K2Ihdk1BDWCYkYo4=;
        b=Tt+ygB/FyGgBUyh02X0z7vq3mn8pgaOTlFRCF8OBDwH3lgUNJ3pPOECuoKmyzHvH2U
         9P1t7OrKQC/UOw2uHzXQQT5ipFxivZ23LfRTvPuW51ZbH9h2MKCQVJmsxDji4cyslPqt
         5ppX8pTOg4AvSN14xlq/6ylGTjp/6vYBk3UXcEl3NEQrwQSoS8Irm53fz91oZcALapvt
         O0q7ZHCXQmDFj7ps67WeU67RPpvi6iIJM1j2i6qAQs8OetJi3mMFbVNa64iJIUa2qDtV
         haNObQ9k4CWr3//vPrCwknN1YgQKCL+EYwrjDpGQYcuEsEEgpQ8G+9NxV7rkidpQYLd1
         C1Rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786771215; x=1787376015;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=MGLWuLEG0kDSgM2QRoCYSrx2dw3K2Ihdk1BDWCYkYo4=;
        b=XulfPUNzq/JKGW1wI5yWnKDQRQbxwk1dBDLWc2XdvJW5YTss2ZDbwjgRuRhBdnRG+5
         CAp4fJo2lRqoeFUduTuQwTPCcpiPQ0Wj0um4+2/NJWs//27jx3FXNGyUx3SlD9MqGnhZ
         fUlJoUywdNmxXt7xJOTpIf043LkxHKa4afwbCOV83ZAGNDuKn4+NpBGAY2K34KE2mDbO
         mBsMtfwMl/7DSoUBJfGDpCqwyHQe/kr0NzHOuTBK5YxVkB+SL+eFVuvBOy3wYOitNBlT
         itBU1z6GkBNj9ihVhFf4isZ2fbDX8NGsDqHWDwaGxVOleggyvRZqN51+0FSrPs+X7LUm
         58EQ==
X-Forwarded-Encrypted: i=1; AHgh+Rox/V2Ike7tFjbOosy4gd5My/UjgliUDjVBxnNCbhvnKl6veXznCVYX9XedCodV2lni31jb+MP+Wg==@kvack.org
X-Gm-Message-State: AOJu0YxTDqxpxU49iooy98v6vDHoqHzCvvwSaZis/7NpQDkx5+nK8VK+
	IAbvcuYqvAtmUMfWqSyk0x3JX4Uy9ziZ9qRas+fEyUk3eG1FmLOYJRpz
X-Gm-Gg: AR+sD12Isi+pAVnA6MARdB6GUuxI2wUcbJKQ4+epl/Oj6q7tg2Pw2pOoqLrOBehQw9v
	+KSRLVqcuZRT2j4tkXqP5ZFW6pqy4Dz6E0Vbox39kVCPmb3uOQRdZ85aUQUgCmG3F7gCtOyL3+n
	YKcVjAQFl7Rt/yrd6Z9b+9dRsTfNEryHDDyJzphTRoWvzF1NXWdSclAYVqN9a2zScdZ/1CfHlC8
	eiyUUHj/bG7WMWRRZoW0XCvktgE32y0tJ57fqWHyYNmA6/8ZS24kvyfZJ5e7jDSknzJiNfi7I3C
	6ib/Jruu4jYbuZxBrrjX5wnFoeixFayvG0zqgY8sXa608BfYF9t5/piJ1pIODZ5Ik6xeb0MoPeY
	G+JZ7jjFbx/uXlBk23X8mnDEyYGClCQSysRVeF2HFdxp+BM9yvPrHGv8qs+BN+2Oqsma3xCY/+M
	lrGFzw5yWo+6Xrm6XnG0XNNdN7cJXhZpyFXnrcBlqkntqgA+b2LZzB6ymqzmvIQXHlwC6K/Yjz
X-Received: by 2002:a17:90b:4a8c:b0:381:bc4c:da56 with SMTP id 98e67ed59e1d1-3933b95158dmr10890633a91.19.1786771214559;
        Fri, 14 Aug 2026 22:20:14 -0700 (PDT)
Received: from localhost.localdomain ([49.79.111.198])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-394ea96c7fcsm5269702a91.3.2026.08.14.22.20.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Aug 2026 22:20:14 -0700 (PDT)
From: Vernon Yang <vernon2gm@gmail.com>
To: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org
Cc: nico.pache@linux.dev,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	usama.arif@linux.dev,
	zokeefe@google.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Vernon Yang <yanglincheng@kylinos.cn>,
	stable@vger.kernel.org
Subject: [PATCH v2 3/3] mm: khugepaged: fix folio is used after folio_put/unlock()
Date: Sat, 15 Aug 2026 13:19:24 +0800
Message-ID: <20260815051924.194810-4-vernon2gm@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260815051924.194810-1-vernon2gm@gmail.com>
References: <20260815051924.194810-1-vernon2gm@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: BB608120004
X-Stat-Signature: z8cnozjbpx9u51usy1qznswgqiat1cck
X-HE-Tag: 1786771215-931495
X-HE-Meta: U2FsdGVkX1+bDs+0NVUZ4ykvboOQ49IdVsbNWWNYPamqoeqW/FijLvnVLtuX7a2RA4gk1c9UdcKpZ8i3yoKozkX5/Hp7PX025Bdj0PWmc71tRsK+DF3K3gsHPY66K53VaC2w7jOO2LrGq9r3peFuBE7o6yxEHD39R8Kn+auqon0IfcZvmdrSlqTEoCPh010UCuvE0IV9Tlh5baHvj6Kj2/N6Pqe2OyjdQQQQedbK+B+ssCW00y7RYybFYh1wdC6R4wt9JDVe6gnjv//5ncxee2zOGZmEXKq0+e4ThR7mS64vF6R7ng02UUkiOQ4DnAT2kSJiYOaUPsoi079486fK91SuItX3DDCbt5bIyyWCMql4mDBngcWiLypoJY0dM5Ys4s2iG3nIHtaTio+6Bbd4k5qTH3y5xHiIenJqIgGhOTvt1ueYJA4jSKL3gYrlxn2aFBWVoeVIJjpkSo0yKsARmx6EsQ/NT+b3QCuM51a4CNlQhhzVOrDCAOTkMlnuXeWinBQnCTgM3HYDOVvJp7LIrogNw8O14FOMDy0x4v1q9sKN80v7Wyb2fcRC4NgLlm6XXaGsuohw1a3vNk6GBlHUJcnaLyU9QWYNr8bzN+1FFKMY9SIR93Ao+mCXlqjgyXXx59aUCFo6VvO8SQcpr2POVjeoanNoNwRyYnK4uKYuHBcOs4YvQ/Vdm2lScaMZUj2GqyBVvCiohQ2BHZL6PhOnwIAUFwunu3jeRcIhmDlR9G4gNbpnc12ddjQ4NeCJ4wqUbWTJzzqeAd4MoTNzYhUiUbF3fk/KObuXeODcYmmqqkWjj2bo60FfDLfok0k2mrRmVdOY8HV2Pdn2c1zmJYAhaxwoYAAcNR/s07n8pc/t7uHbNCqNVpTcNirOPtmfFKWtzxhValTKCMiVbnxubRJHzxs6/ko5yyKK6HPiQRLkDWx5d4lkBq1i+64zTXiWKD0qI/8IoWcBOXKsl7kqx5X
 tb3JZiNx
 qsvZxKna23Ulc7z2neTCC1czH3YoQCzR7HHwahMs7yzx3J/PBjfsjTqJLNoOBJVmhlTTWhK101sd6LDnnyxmmkOtuva+oDpNSFmxXIoTjFv1sa8n/sKa0uRsQ+dSJJnZzEvqKgDb1VAjcy5946LhA9QNZq3oDkBHHcF7wisd7eAcClbTK2Vd7X+9Ly3yIfxyWdxUr63qheQ7x3IIXp6RCXZ6Mmxbf+XaaLwxUxuHs65CCqdf1TSwj9a5Gh6/gT7rOCQxYoQKAZnCaNaLv51Nz/5rsFFDUoncDoIJ0om92nkRkF8AGbLC9PsP9uwtkxclJcQlwCjjJEeusySe6OcpuELpt2V/0grCkv1PfeDCnHVqdYFHHCM/DjEXrCYpdeK4lGyUQW5XvVCg4If1wPgBQCD++lywuhU3UCiip3LGN3lLPSyiMPUt81ZuoGu6mhtOsGcz4vpAEw13OQ9E=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Vernon Yang <yanglincheng@kylinos.cn>

On the rollback path, folio_put() has already dropped the last reference
of new_folio. On the success path, new_folio is already unlocked and can
be freed concurrently. The trace_mm_khugepaged_collapse_file() is left
with a dangling folio pointer.

So using the folio_pfn() before dropping the reference, closing
use-after-free window.

Fixes: 4c9473e87e75 ("mm/khugepaged: add tracepoint to collapse_file()")
Cc: stable@vger.kernel.org
Signed-off-by: Vernon Yang <yanglincheng@kylinos.cn>
---
 include/trace/events/huge_memory.h | 6 +++---
 mm/khugepaged.c                    | 5 ++++-
 2 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/include/trace/events/huge_memory.h b/include/trace/events/huge_memory.h
index 5dc71d292f47..1b301d4e2dba 100644
--- a/include/trace/events/huge_memory.h
+++ b/include/trace/events/huge_memory.h
@@ -211,10 +211,10 @@ TRACE_EVENT(mm_khugepaged_scan_file,
 );
 
 TRACE_EVENT(mm_khugepaged_collapse_file,
-	TP_PROTO(struct mm_struct *mm, struct folio *new_folio, pgoff_t index,
+	TP_PROTO(struct mm_struct *mm, unsigned long new_pfn, pgoff_t index,
 			unsigned long addr, bool is_shmem, struct file *file,
 			int nr, int result),
-	TP_ARGS(mm, new_folio, index, addr, is_shmem, file, nr, result),
+	TP_ARGS(mm, new_pfn, index, addr, is_shmem, file, nr, result),
 	TP_STRUCT__entry(
 		__field(struct mm_struct *, mm)
 		__field(unsigned long, hpfn)
@@ -228,7 +228,7 @@ TRACE_EVENT(mm_khugepaged_collapse_file,
 
 	TP_fast_assign(
 		__entry->mm = mm;
-		__entry->hpfn = new_folio ? folio_pfn(new_folio) : -1;
+		__entry->hpfn = new_pfn;
 		__entry->index = index;
 		__entry->addr = addr;
 		__entry->is_shmem = is_shmem;
diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 7c8c48577408..7df0fd2d2fdc 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -2247,6 +2247,7 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
 	struct address_space *mapping = file->f_mapping;
 	struct page *dst;
 	struct folio *folio, *tmp, *new_folio;
+	unsigned long new_pfn = -1;
 	pgoff_t index = 0, end = start + HPAGE_PMD_NR;
 	LIST_HEAD(pagelist);
 	XA_STATE_ORDER(xas, &mapping->i_pages, start, HPAGE_PMD_ORDER);
@@ -2626,6 +2627,7 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
 	retract_page_tables(mapping, start);
 	if (cc && !cc->is_khugepaged)
 		result = SCAN_PTE_MAPPED_HUGEPAGE;
+	new_pfn = folio_pfn(new_folio);
 	folio_unlock(new_folio);
 
 	/*
@@ -2664,12 +2666,13 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
 	}
 
 	new_folio->mapping = NULL;
+	new_pfn = folio_pfn(new_folio);
 
 	folio_unlock(new_folio);
 	folio_put(new_folio);
 out:
 	VM_BUG_ON(!list_empty(&pagelist));
-	trace_mm_khugepaged_collapse_file(mm, new_folio, index, addr, is_shmem, file, HPAGE_PMD_NR, result);
+	trace_mm_khugepaged_collapse_file(mm, new_pfn, index, addr, is_shmem, file, HPAGE_PMD_NR, result);
 	return result;
 }
 
-- 
2.53.0


