Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 98D29C43458
	for <linux-mm@archiver.kernel.org>; Wed,  8 Jul 2026 23:49:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EADE46B009B; Wed,  8 Jul 2026 19:49:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E128E6B009D; Wed,  8 Jul 2026 19:49:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C16406B009E; Wed,  8 Jul 2026 19:49:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 92DE26B009B
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 19:49:05 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E9FC9120307
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 23:49:04 +0000 (UTC)
X-FDA: 84967252608.29.192686E
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	by imf17.hostedemail.com (Postfix) with ESMTP id 4CDAF40002
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 23:49:03 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=kmleJHVB;
	spf=pass (imf17.hostedemail.com: domain of 37eFOaggKCEY0spi4iriowwotm.kwutqv25-uus3iks.wzo@flex--skhawaja.bounces.google.com designates 209.85.215.202 as permitted sender) smtp.mailfrom=37eFOaggKCEY0spi4iriowwotm.kwutqv25-uus3iks.wzo@flex--skhawaja.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783554543;
	b=fH1ox2wMy+wkX7DAM8jodtMOFkpCJLwVqMtYCbrEl+P3gq7N05yBtcqSv6+8rk/+UPXz7y
	Mi+8yz3g/OB+aGYLbTqrpkKQwkVvxzyw7o07hM42adb4W+l1uHFX21SBreq0xC7CdIgBLV
	S37ZbBE5SqIqGn3c/CUGl48YM/DEyws=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=kmleJHVB;
	spf=pass (imf17.hostedemail.com: domain of 37eFOaggKCEY0spi4iriowwotm.kwutqv25-uus3iks.wzo@flex--skhawaja.bounces.google.com designates 209.85.215.202 as permitted sender) smtp.mailfrom=37eFOaggKCEY0spi4iriowwotm.kwutqv25-uus3iks.wzo@flex--skhawaja.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783554543;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=S36ZhlE0su/Uhwn2a42SI+N6oTSNT9EqACGdaCh7Irk=;
	b=jAUBSPnLAStzufbLma/vrKUXrozQcqHu1diUyocOTxN5twzD52IiNu6vI12UhdkYy+N4KX
	KFFo+C/fjvpq0faFf8fZuJG+zE/mPLh/e0aumRqcfZVnAanYU02EyYLVSjABHyp4gZww7F
	n3CqVqVWK/7rNln+g/9LqGTBVaUnZnM=
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-c916d17dd43so1886941a12.3
        for <linux-mm@kvack.org>; Wed, 08 Jul 2026 16:49:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1783554542; x=1784159342; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=S36ZhlE0su/Uhwn2a42SI+N6oTSNT9EqACGdaCh7Irk=;
        b=kmleJHVBIhQXRw7n8VnexP+kwDz9TXuS5jUEflGH8ji1nSXE95rMpoDOoH0tp1bBy0
         G3Acmg9QZR2gtABtWRQvoDEkn1oG/pbInM6JOT3cZ2gBOg16S78TN0YFxHiRLY7rsysv
         8qwqpcJXxfLyobLOkvpuCq0WFhjD4ATa43rS6TTkz3x3SQF8cZaOeK2UJRqPz9abn8wf
         0rixHdQV1RzHlV0oW3arOQjIvbEl6tFnPjnxRSDFQJkX5HwYqosD09WzrCAajta8i9Jg
         pXDiKqNKplf2GI8pfKanbeIIjO+JxzQLgcrcaHjWsthJCXSBGPy1oGslhqCe5XEiEdtN
         +OMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783554542; x=1784159342;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=S36ZhlE0su/Uhwn2a42SI+N6oTSNT9EqACGdaCh7Irk=;
        b=oRdbeHykTvmf/FgblzT7vlEiAD97+CkZvlA+BkG+EcfL/dH+etVYlfWrDwIUKoqpg3
         U6Cc0aLLU2EwHUS62/Y8gzK9wL89BPdBfnAKRslR9Re6K2YElluneGvk611efZMg+8kp
         TKdDt5+3zAkOBbAVxQKaVo02cDqYD80ICECgoYsKJ7Jtl+/m3cZ+mj6DE1xe9OjRLLPx
         asdaw29rePvPiLFOA8U1I76Lsi4p6Nm+/Uhi0AlBepj2WnGgCCVOZ28VIgoBP31K0KY+
         fUUmql5Odu7tyMJToiXyyP3EVF9K6EtTGoO+MZ88+bbULZnK7yeZmuYRHVH5QhAYM4q/
         Jo6A==
X-Forwarded-Encrypted: i=1; AHgh+RrldcmEhwKEGoQrs/+l82d/VEdbQnlDh6EPVyu7nCOA2t5blyCOMHBlP2Jq8TNSH222u9v1Ng+pTA==@kvack.org
X-Gm-Message-State: AOJu0YzmbAcyti5q7xjVI8idF5mRjFb6waO7UMaHn2/O5oZlraUYd2YP
	lkH5eHJXk3VvAdcH6vxumHfXfyInu4Og2KoRpphXnssyCgit3/XW7tcPfLV1lKB9wz5brzwMwey
	Vdeh3sFKE2fAYtA==
X-Received: from pgcn4.prod.google.com ([2002:a63:7204:0:b0:c99:3b68:c9c6])
 (user=skhawaja job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a21:4d8e:b0:3c0:b766:74f4 with SMTP id adf61e73a8af0-3c0bca47d59mr5364528637.31.1783554541947;
 Wed, 08 Jul 2026 16:49:01 -0700 (PDT)
Date: Wed,  8 Jul 2026 23:48:52 +0000
In-Reply-To: <20260708234854.4044652-1-skhawaja@google.com>
Mime-Version: 1.0
References: <20260708234854.4044652-1-skhawaja@google.com>
X-Mailer: git-send-email 2.55.0.795.g602f6c329a-goog
Message-ID: <20260708234854.4044652-9-skhawaja@google.com>
Subject: [RFC PATCH v2 08/10] dma: contiguous: Export is_from_cma helper for kunit
From: Samiullah Khawaja <skhawaja@google.com>
To: Marek Szyprowski <m.szyprowski@samsung.com>, Will Deacon <will@kernel.org>, 
	Jason Gunthorpe <jgg@ziepe.ca>
Cc: Samiullah Khawaja <skhawaja@google.com>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	Mike Rapoport <rppt@kernel.org>, Pratyush Yadav <pratyush@kernel.org>, Alexander Graf <graf@amazon.com>, 
	Robin Murphy <robin.murphy@arm.com>, Kevin Tian <kevin.tian@intel.com>, iommu@lists.linux.dev, 
	kexec@lists.infradead.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	David Matlack <dmatlack@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Pranjal Shrivastava <praan@google.com>, Vipin Sharma <vipinsh@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 4CDAF40002
X-Stat-Signature: 8ndxmjq6nx4nqjr3twg586j7qrwcf8gz
X-HE-Tag: 1783554543-906052
X-HE-Meta: U2FsdGVkX18nzjA/aqIZhOdwzTKESwrJIsp16aE4T4pHfdAVZ7HtvU5x90uAVvH1ZuRYhvCAUoWn2Y5gartuKWUvEmdHkC9vvnGlgFPm5uyKYm5h6llZW04Se3HSI6J8it+QGmRaZFIHQ1M4J7GIBVB0iUvzlEgb0CfoUFTVigUCtkFgyeGo+MsdCSM6W+IT/78eb5o/fonrUHmr5ylGDuMBCJxQbCtfxNSu7HudmQZ5ca/vBSzAL0VVXKwrq/0pxpHfrzUmo1sH2thsmbq7mYEMHGHzt5OcFyBX5FRUt/oucbUJ9zKbXIgCjBvVQZgWCHo+/EP4XNa6MQsIKiOqotnK6SvuHkBxC16bjcNvYvoJpcoNn9w9ax+Pg7N8iWzXFv3gVy6ibeabIqvgoahhmTtoNvlrZ4ov9bwuLa1uE4mONreSKob86I+E+GAX/Eadn1XI8r/t9DlOysTP8VxMok6s5o4U+83jmXHe1Lh4Wy5S/GA9jNqbgOLDgy9pjYPX2Q0l25mrmyOPDx8uOEdUp/Iap/c7+tJms7iLHXXG3ssDdxYqheaMloDhG+MRMgzsyAywbgCE9Xr7F8pjWCtP16jXD6Lko1mLBj72vLRJFnTCLFqqRHvdQmd1gH6ktkx1644OvfWsdtFqB38JtRP7r8FnTHtFuL56q8eKZXIP293QrJWALQaaQH9kZ9/Z2g+M5fDa1A/0iSuH6+Y7fBeKO7Z+HSiSKKh+/uMVvQsW+nduAUsY8oO7NKqgqAOtj3xcsOa8hqyGpFE1qC/6uGGmI9ZrnxleG0x3kqasLLD0lTUEFRgopMI3xNy+egsQiYNVCcsV6HbhTWWmjwCc+680ujWhlBZ7FsII2vqBCvhL721uAcYV3tI+/G/9Aagdo2ykH/AKW1163a6EV/yxxw+i3Atqi/zTDEexQ7zgzFvWvjzk3Uv46U9NlVSPwEJsQuHpOeHGH6OtdU7I4QhhxSQ
 mXAsW/uy
 +p931xFIdX9sTPojXLmnCfFFC2gZFCJmud6m00MsPtMMKuVhqgyF25OjLdyCSXYAYfoh1EfwnDZ3CzOWBjKRbaZ84KndvVyKN086UjaDIzBALLDdJ/hjHg7X6mLX45tyInkpGj43LPOq/MIF/kkg428I9GQHro4F2LSXph6v278WI9O9CnSTLoz3Bawc3ZukqokJlvUPEBKi19Fgydr7w4hkculmr6+vSOAOLXORlHj3gyWnyRO+Jz4NtH5aoqvIVAaV2XrfP+hDjaEVS9M9Zu4rpN7IEpVwYqLIHJjNtqnNoWqjXzlgJsjQWwQn6x+rm9bKe4/oiPgB/HrEYDGQkATm3kilfL3ZMi8ncdfxbl0GLDYpzbTyiXobPHHXm1haQb40jIAXc1FvDr6xoDO55SgGVICvGWMvzBn0PyOQJPMZtucVD8pLR65xTRJqLEcIKymlTe4vPtHvI0JX+rmdqWpslORviFFAcgaQbhxDWWJvAloPMQ2CERuD3TwIHgy/rfKc8TjajyP/b4UrrcZh2fIfV+nnwuGFDD7VB4ynxYXr5Vq1j6ERrfrpDBWOLQ/v4YZkH6Zjk/YE19qpfuC+e4IFV9dRrwDwwxQ93nYJAR2sLWxKl31dNkwjkTTr6OPz05AGb3YcCN0s/HV/1gOpr2fzgl+B7YKtlrpVX5COCqBSfmDk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The is_from_cm() can be used to check if a memory allocation is done
from CMA. Export the helper when kunit is enabled so it can be used by
the kunit tests.

Signed-off-by: Samiullah Khawaja <skhawaja@google.com>
---
 kernel/dma/contiguous.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/kernel/dma/contiguous.c b/kernel/dma/contiguous.c
index 0b1702bf39ca..6d0cf9c7528c 100644
--- a/kernel/dma/contiguous.c
+++ b/kernel/dma/contiguous.c
@@ -37,6 +37,8 @@
 
 #define pr_fmt(fmt) "cma: " fmt
 
+#include <kunit/visibility.h>
+
 #include <asm/page.h>
 
 #include <linux/memblock.h>
@@ -153,6 +155,7 @@ bool dma_is_from_cma(phys_addr_t phys, size_t size)
 
 	return cma_for_each_area(dma_cma_check_area, &chk) != 0;
 }
+EXPORT_SYMBOL_IF_KUNIT(dma_is_from_cma);
 
 #ifdef CONFIG_DMA_NUMA_CMA
 
-- 
2.55.0.795.g602f6c329a-goog


