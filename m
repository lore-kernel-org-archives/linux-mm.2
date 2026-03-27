Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BCA6810ED66D
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 12:42:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ED4106B0092; Fri, 27 Mar 2026 08:42:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E85246B0095; Fri, 27 Mar 2026 08:42:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D9ABA6B0096; Fri, 27 Mar 2026 08:42:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C626F6B0092
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 08:42:09 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 653E98D9E4
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 12:42:09 +0000 (UTC)
X-FDA: 84591805578.14.F1A8571
Received: from mail-lf1-f43.google.com (mail-lf1-f43.google.com [209.85.167.43])
	by imf11.hostedemail.com (Postfix) with ESMTP id BD09240008
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 12:42:07 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=WHUjynaS;
	spf=pass (imf11.hostedemail.com: domain of mikhail.v.gavrilov@gmail.com designates 209.85.167.43 as permitted sender) smtp.mailfrom=mikhail.v.gavrilov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774615327;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=vnEhmrhTPA7Nd81/VP3XZfiniWMenGZwrrUyIBlvmYM=;
	b=sfypFYvhheoQWnFfA8SLMZGeUKGXNWBLGL7S8dL1TLsnHH4a3O1qHUFeqnwZ9ktsAzmAOV
	flxSuQRg+8Y0ttAg4hD6CgVyTg0dvSuPtCMc2xWuEZafhrCuReVNfgWBOW/oCNwRBIX8Dz
	TBQYKZmmlzo+mRtX23ihEtF0H5yT/4o=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=WHUjynaS;
	spf=pass (imf11.hostedemail.com: domain of mikhail.v.gavrilov@gmail.com designates 209.85.167.43 as permitted sender) smtp.mailfrom=mikhail.v.gavrilov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774615327; a=rsa-sha256;
	cv=none;
	b=DQO3NTLOu7H4bz014oas19aPAHIkxNdwH16p8DyX0NOD3JqydmoJmFZ6fl8D/Vz+2gyWjN
	YcLlVUvDqotiFfWbwDPZSeDi2xtp/2ZoimOPY5T/epIiLFa2gCJP+9eGccnFsO4srkLSTC
	/aHJ17D4k1WSiKJVUgm8op/FCtUeJQI=
Received: by mail-lf1-f43.google.com with SMTP id 2adb3069b0e04-5a0ff30b240so2394989e87.0
        for <linux-mm@kvack.org>; Fri, 27 Mar 2026 05:42:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774615326; x=1775220126; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=vnEhmrhTPA7Nd81/VP3XZfiniWMenGZwrrUyIBlvmYM=;
        b=WHUjynaSp9QsUsjpNmxLGlhPaPw8qZa2W2dWffL4QsK1vPnmiN0RDgPgvBJ3BH7ZNp
         LRayS/Ddc5aO2w0pf36A/1KDFmyfI7TZ/7L6LOl4l306Qtci634LwxJI5Lh/u69P7XXW
         Ee9OlMHdqMeFY3nc1gLytKOrg5RUV+/YtH2s3+qywwr4ca9ABn+IWpSXiazNx9gJhr81
         cSjfHJyhSw/Dahe3lFYRXXO88lc8OUtHvMEmS7cxNzvBSRLs6M0VV4gcv8ZQHvV8uauX
         wwCx/8gIS1FUWo/Z57tS09zuVpfYYJWs0UMtFPq1+tJ3gIAYJSvaJ321nGNovrUOdsns
         KmvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774615326; x=1775220126;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vnEhmrhTPA7Nd81/VP3XZfiniWMenGZwrrUyIBlvmYM=;
        b=mQo8dCYwcS7nq4B+5o5LwFnx+PORzNmdNSDsJfsiNp9u+6lcj36bmKXirOHzIv+4bS
         z3L+AfsQ5d7PHEVey0Ri6RxqbPw5ZWZikGqjUikCO/AEAW64Ftl10sbF82PmRycpCSBn
         Ap9533uIloES7aogRCZ71pgVXb5PcWSLZs97NnG89B6QXQwES5DQqzyHsgm7zyrSRYL7
         KIhpf3C2TjUqjRvg07udJi4bxOZ1WwaOSrkv/bLGEoY6HbU1Xx/X3ijktpdmggBsQcwl
         GcToXOPYNJX5qj/UtcvrpqadyQKydHpkZ/i0CXVnRXEkvK0pifohrPPTcZKx1cDCt90B
         PBGw==
X-Forwarded-Encrypted: i=1; AJvYcCVN+QrtLnZZbjWDnX5hF5nKMYm9mGai3VxYgqgulM5XDXMKqgmRV7r5ZCh+UCj5gy/1ipmvqulxgA==@kvack.org
X-Gm-Message-State: AOJu0Yw/KpZkUWOIr10gfR1lQeu3OMtIvNCt3hiVt2JxrscVdZU7I+Yk
	ILn5P04XAXcLDGv/Ikj0TfwNrHda+fPusU1i8iAQxg0+rkKaC7LTSHhP
X-Gm-Gg: ATEYQzxaKIY4XSlJp4p94TIutE+/FWX3QBm/o4tsWdvGBn0H450p/uwuZfcvY1ozVAO
	XVmTD9PwXLeUT9cjA7JlifOKjpFcs9SD5waoWSdCqapQlvvBRIiLlPJijf9EcYGy6gAH8fM+SFt
	BSUEwwVh6wu0UQQ75797POO8/hwIqbiaT01u1uR3qUawdOWLBi/VvA5EOxk1D+w+8oboYyjLSGk
	aQpNegHCnG06kqE4G+yIUqH8a1OTsLIU9xXOWwqsB6o6dcd/+9DnFmxmwxmwSva9ni/sv0JqNKy
	zdQP3P30pjgyBUb6jgTo+i633Ca+YvKEyN5Xx5MSMRb1FclL9HOYeEcvoCw6wDqLrfSpcjswUlG
	s6XEVZGQ+zddYBmzPO4IwkndyGKgiAVEIZRJtVY1+hNhM3fNZeDBuNkAWug+u6I41fHVfBHuKg4
	wFON/o9jYqvxxKm3juO/Fs46/KjQnHhOGOgw==
X-Received: by 2002:a05:6512:6c8:b0:5a2:5b88:a8a3 with SMTP id 2adb3069b0e04-5a2ab92854fmr1015552e87.31.1774615325628;
        Fri, 27 Mar 2026 05:42:05 -0700 (PDT)
Received: from localhost ([188.234.148.119])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5a2a063efbasm1336127e87.14.2026.03.27.05.42.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Mar 2026 05:42:04 -0700 (PDT)
From: Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>
To: m.szyprowski@samsung.com,
	robin.murphy@arm.com
Cc: iommu@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-usb@vger.kernel.org,
	linux-mm@kvack.org,
	harry@kernel.org,
	vbabka@kernel.org,
	akpm@linux-foundation.org,
	stern@rowland.harvard.edu,
	linux@roeck-us.net,
	andy.shevchenko@gmail.com,
	hch@lst.de,
	Jeff.kirsher@gmail.com,
	catalin.marinas@arm.com,
	Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>
Subject: [PATCH v2] dma-debug: suppress cacheline overlap warning when arch has no DMA alignment requirement
Date: Fri, 27 Mar 2026 17:41:56 +0500
Message-ID: <20260327124156.24820-1-mikhail.v.gavrilov@gmail.com>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: BD09240008
X-Stat-Signature: i4mnp7zhnx1eu99qqsym3846bopfcxan
X-Rspam-User: 
X-HE-Tag: 1774615327-306586
X-HE-Meta: U2FsdGVkX1+bv5Q0JxmyqQRyYbehwAwgfhzck3MntuM4d2P/bLWuVNViGT8fo4gS9TJ+2fx/68VrtWLbGkvydGye8t86wU/oYEQGUDlBszylOsfhUHEQbX8d1EzCcjVEEJfAadIbkpGVTg+adBg+C62318MO2o3TsltFUfCgExyo4/pa22Nf8JAW4Ba5PMZmBfVYseKhMriB8qkauYKMTZifobSC/EBqs3Yrvp9ys7PtAqlKyEc6ycQXAfF4bi7RC8uKvrdpJCKi+0Ud7D9lp/jG1hkZVsHSvEt6VpgAXhmSj4LkzoBD4jvhfODKJTfph7x53beG+XJRNsKa21f+6PenqEsveaCfzNfLt+75M7JrCNPHp+z3QPFswoL5PD1BGnve1UH7dfjiim9Z88KVLVpM7y/nTauC6f3t3471qTASXeE4Om3SPqA9mYmJG8kKrEZXLLA3tZER9gNOCTxvV/9DCqgeZxTWxA71f9yhu3MOlDhG2UuVLPi9x76jXHR0is+Pw2G5pxydWBZM0dApBcSrmEbYt0PZsZATHql0DrJRIFNs5NHu7fSaRsIf1z/8jo4+oL72s3eHjyhQnhTphZyNXTHZYmWHJQiqgNL5bW8rmxm2santOW3cQCsng1ZG4V9yTVZQDeu8PDCQ7neseoeYozhQyZgR/nOXhExdY9JBfvnfhgGooM9xhsOQ7gsC6qoFna3hPK/GQKk25Xl+17w+P0kr6H00tsrMLSpqliBLH+3NVXNaaVLLk7n7CsVcJg4qV7fCQXldRGFie6asx/lMdYSsC7RxoJ4P4uImGMkDTPSah2EtI9UGhDI2SpiZW1cgmREDGxDgFwxhE4U77gpIq+Cw3rMUJIzRZ377Tkb3IiZYmqAYxZ7qOTEYV0PgFB5kUotVo+m8l6eC8/yKmhP4tvAiBQNCWxqPyrK4momFXKI9uxs2tClikDJkmvnvI6hI7FWWIm8SiJgCJkp
 GM6SMHgt
 akTYOtznEpVCAfv2dx5ESo9lyxLgUH09jR+vc+UCU0RSiXfbXoE98BvabYL7pOuR6Sq9UYsENCTdSQwjIOWzb3389fOUNnmnTwlDDqrOHmUQwXtq6zqVTsh7ZpGusxwChzkTmvPW9VSi9He8tLVZLL3nMlerAJV+2N84kglHdt8nRSZkB0I3R+3pkripUJJFQBtNHbmSZoKi1cYme884qVnTQ/qLT3wrQ3RW9n764h6YGHoulAjxm5yuPCfw+dOQyGJUn4XNobxl29ufnHs6rvlbsIHXeuDnPxYXV8/v+IDGYqz6VgX7y7gx8Og==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When CONFIG_DMA_API_DEBUG is enabled, the DMA debug infrastructure
tracks active mappings per cacheline and warns if two different DMA
mappings share the same cacheline ("cacheline tracking EEXIST,
overlapping mappings aren't supported").

On x86_64, ARCH_KMALLOC_MINALIGN defaults to 8, so small kmalloc
allocations (e.g. the 8-byte hub->buffer and hub->status in the USB
hub driver) frequently land in the same 64-byte cacheline.  When both
are DMA-mapped, this triggers a false positive warning.

This has been reported repeatedly since v5.14 (when the EEXIST check
was added) across various USB host controllers and devices including
xhci_hcd with USB hubs, USB audio devices, and USB ethernet adapters.

The cacheline overlap is only a real concern on architectures that
require DMA buffer alignment to cacheline boundaries (i.e. where
ARCH_DMA_MINALIGN >= L1_CACHE_BYTES).  On architectures like x86_64
where dma_get_cache_alignment() returns 1, the hardware is
cache-coherent and overlapping cacheline mappings are harmless.

Suppress the EEXIST warning when dma_get_cache_alignment() is less
than L1_CACHE_BYTES, indicating the architecture does not require
cacheline-aligned DMA buffers.

Verified with a kernel module reproducer that performs two kmalloc(8)
allocations back-to-back and DMA-maps both:

  Before: allocations share a cacheline, EEXIST fires within ~50 pairs
  After:  same cacheline pair found, but no warning emitted

Fixes: 2b4bbc6231d7 ("dma-debug: report -EEXIST errors in add_dma_entry")
Link: https://bugzilla.kernel.org/show_bug.cgi?id=215740
Suggested-by: Harry Yoo <harry@kernel.org>
Tested-by: Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>
Signed-off-by: Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>
---

v1 -> v2:
  - Moved fix from include/linux/slab.h (ARCH_KMALLOC_MINALIGN)
    to kernel/dma/debug.c per Harry Yoo's suggestion.
  - Instead of forcing cacheline-aligned allocations, suppress
    the warning when the architecture has no DMA alignment
    requirement (dma_get_cache_alignment() < L1_CACHE_BYTES).

v1: https://lore.kernel.org/all/20260327055846.248829-1-mikhail.v.gavrilov@gmail.com/

Reproducer module that triggers the bug reliably:
  https://bugzilla.kernel.org/attachment.cgi?id=309769

 kernel/dma/debug.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/dma/debug.c b/kernel/dma/debug.c
index 0677918f06a8..1a725edbbbf6 100644
--- a/kernel/dma/debug.c
+++ b/kernel/dma/debug.c
@@ -615,6 +615,7 @@ static void add_dma_entry(struct dma_debug_entry *entry, unsigned long attrs)
 	} else if (rc == -EEXIST &&
 		   !(attrs & DMA_ATTR_SKIP_CPU_SYNC) &&
 		   !(entry->is_cache_clean && overlap_cache_clean) &&
+		   dma_get_cache_alignment() >= L1_CACHE_BYTES &&
 		   !(IS_ENABLED(CONFIG_DMA_BOUNCE_UNALIGNED_KMALLOC) &&
 		     is_swiotlb_active(entry->dev))) {
 		err_printk(entry->dev, entry,
-- 
2.53.0


