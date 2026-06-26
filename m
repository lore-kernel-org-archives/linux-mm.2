Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 61177CDE008
	for <linux-mm@archiver.kernel.org>; Fri, 26 Jun 2026 07:57:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3DD9B6B0095; Fri, 26 Jun 2026 03:57:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 38F406B0096; Fri, 26 Jun 2026 03:57:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2326D6B0098; Fri, 26 Jun 2026 03:57:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id F1BBF6B0095
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 03:57:36 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 531EA16722C
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 07:51:21 +0000 (UTC)
X-FDA: 84921293562.12.9ABA3FD
Received: from mail-pf1-f194.google.com (mail-pf1-f194.google.com [209.85.210.194])
	by imf23.hostedemail.com (Postfix) with ESMTP id 902BF140003
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 07:51:19 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=GarjpZTy;
	spf=pass (imf23.hostedemail.com: domain of zhanghongru06@gmail.com designates 209.85.210.194 as permitted sender) smtp.mailfrom=zhanghongru06@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782460279;
	b=3+insv6Og8wWxP2qyClh5ykx4EOr78TXCwNlnR6+Jyiov4uoQNMyD+o8cmvVrJcWB/UTJV
	+PwRUL5T/2TTrjCTKrfOJQkYG0cYl1sdvnaOXRvUBnk+efTJFNh/8OL04YkBjY+sOeTTLy
	c/HHA3rtjZKlnSdSUMV9AWxQjejRqqE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782460279;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=paNtpMHD9zL4no40Bb8j2T7HQZDm4wdkclOuDAtzT3E=;
	b=XzWWE0XnmPgrh1YJEIR0BY/tD/YoWcefZay4nr/y1xJRt4uvPAmFdU3UjDf41C6IyKmUki
	1dSbKSBl51UQDCANAxKFJUEY+toLiIOEcp+vC/J78zWVQCj/GtWHi/FbLssRkbS/XpuU/s
	fNMGLbNsT/d2oOCuWd258AILC3Gd6Mo=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=GarjpZTy;
	spf=pass (imf23.hostedemail.com: domain of zhanghongru06@gmail.com designates 209.85.210.194 as permitted sender) smtp.mailfrom=zhanghongru06@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pf1-f194.google.com with SMTP id d2e1a72fcca58-845b965c1c4so343872b3a.3
        for <linux-mm@kvack.org>; Fri, 26 Jun 2026 00:51:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782460278; x=1783065078; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=paNtpMHD9zL4no40Bb8j2T7HQZDm4wdkclOuDAtzT3E=;
        b=GarjpZTyc7HAnyc0ItVDnhMUyXAUAnhQd4HUEeCtTFrYTLRSj4IQLlc6zVMQWEJgiB
         RTUtKrK5DVuWk3iFOp4Uu6UHjIIu1AEnT6M4ffU/UuUdeF9dl4lXvYU9f/eJRP/R5zks
         qXwqGZVipbvgHsQsa+1AXMEWgp0BLS/AIS7LJAYX56HjMnOV1Vqpb0zysk7X3H++deZN
         hOrTcIHeIo8C+BsxPO6Rr9FTY3sm37ph+7BTS4oX8kFoH9CnwvqxVfgCOTb7i99t7NLw
         ZYrteQMPJiatwKxClI+tr+zGLJtgvEx4GccRUyDjrRkud3zQH0YFEfn1m10RzKsNWJox
         6Rdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782460278; x=1783065078;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=paNtpMHD9zL4no40Bb8j2T7HQZDm4wdkclOuDAtzT3E=;
        b=qZAAdEB6bdVAZAMoKGQNKGygJWI3O9Xs3SMIVI28XV91Bc9jkjwkkUvaBUtscd3gWW
         wm139BIfLKr3Z1XTnvtTp37EFAb+vmPs5dMeDFirt+ZB8Y0VSA/DGQphnRmnezhxAFdq
         GcBGlbmLXLOILmT/XeuI+Dxm4AeUCTstifwTtidvNZepUkAakxWHtwMdLJh2J1BeYyaw
         xnolx0vqwrmu+z5IwvbDVHZzVCfy0kcaAOnf0LqgRh8OKPxaS5kPoovuMjMgVDD3vshz
         BWlvbialhb585qgqSTkxpQFyU/EnIy1lLefI1fQoZBt7D4WWR7davcBsngoTpZS52tIf
         jaUA==
X-Forwarded-Encrypted: i=1; AHgh+RrEbAMJob31IzUqqbkAiQVb7QKEQiRY5Mz5EgCZSHS1hfz4aCal07h2DgOT4MOtbTH9XqE7lHFIHg==@kvack.org
X-Gm-Message-State: AOJu0Yxdoejb5c4sk+3eYrh51i8fdqLB4RzZaIbY2RWaunOCIFT8pM90
	EsvKOTsnTzYjXA8f+aADjBfMJRRnsvA+cWO7twG1KRxge7Rg9hhGoQ62
X-Gm-Gg: AfdE7clTI5c+7UVvK9lem0BwZlTyBKjlY4FNAwsmtprybSH3eCIMhzKHcJTkuz5rq0A
	45qHA2mU5B9Ptbn8Nb2VVVXi4+0510OSp9hRU/o7y2istJ3y6PK8X2ERiI6z9JsTk8iluHMEsFq
	+AmZUbbXsKpgXhwHtll4Pr9oscJGHxvIQyNXTcVjixWxl2F4riEoi5xT5bf522qhJmyHLoKS9wt
	fphbNjYAo9N9Udgw7cqse1sYrl2nmCKFFFtts7LuegnfcKv+8Iqqh4FjJ7aErTkQ9jdxD6HNJg1
	T2Vv074u6+QfFQbiQaHF3VWaAgI+JVuwGkLU78cFEe5UYF1tnT4OO3HnCs8nCAZiU5LOZYNOyOT
	Fwc3Ievikvt9ZcP07OcI+1Ina5YhaMb3t2Q2sV7YaottFo0ZgOlrN8S75fumil4ZtjuN5AmRFj2
	2Q4or3M7pNfOrk54bPKQauTkSOpMMjRCJlmwkuXH5C
X-Received: by 2002:a05:6a00:3d0e:b0:82c:d6d3:3190 with SMTP id d2e1a72fcca58-845b3aefb74mr6835493b3a.38.1782460278352;
        Fri, 26 Jun 2026 00:51:18 -0700 (PDT)
Received: from zhr-ThinkStation-K.mioffice.cn ([2408:8607:1b00:8:110e:60c3:7165:2ed6])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-845a40f2481sm6170649b3a.41.2026.06.26.00.51.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Jun 2026 00:51:17 -0700 (PDT)
From: Hongru Zhang <zhanghongru06@gmail.com>
X-Google-Original-From: Hongru Zhang <zhanghongru@xiaomi.com>
To: akpm@linux-foundation.org,
	linux-mm@kvack.org
Cc: david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	baohua@kernel.org,
	shakeel.butt@linux.dev,
	linux-kernel@vger.kernel.org,
	Hongru Zhang <zhanghongru@xiaomi.com>
Subject: [RFC PATCH v3] mm: retry page faults under per-VMA lock when mmap_lock is not required
Date: Fri, 26 Jun 2026 15:50:19 +0800
Message-ID: <20260626075019.1833065-1-zhanghongru@xiaomi.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: eofm44ocidtym1yqztihbiwzzcggiu6w
X-Rspamd-Queue-Id: 902BF140003
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1782460279-747921
X-HE-Meta: U2FsdGVkX18PMKXRo2jMElbrLjN8EPKsUnnsEHiOn5hVnLhXaqE92QsFfEHCdbzgyfvUW7yGR9tOMWCZC6ux0lvH+WkqMv1Eu9+uZwsJslA7Y0pCXdI3W2/Lkv01QZeP+KE4TH5gmPz+PhKPNNBqqf0d8zCZBEHsoMqppefKucpFb05VeObtbozyUPH9nC6TYhjuCiQPUhMwm/M4UJxxCQJW0iHXPdMtZyjZQGKduRdGKk/9GgDih0RMUivK22/EgliRd3LbPYl6y5Ti8eGH66bWRYpde5toUx8v6Sr1Id/B46C3jAUv3F7Xa97P5AKzMiVFioij+8SxLzgWEV3KSO6x7MBkX/Tqd3Nu7hJwAtM7bl3hxRo+A2ugpnlUqSMzyFZCc6EJ13MWltc7bKegc9zJ+BCeA0LlfguM8N6VYHuZgYZ3FS+DLOt2upkeD00HySf+rFTnRC449kq4tyazyOmb+Yc+HG1PWHiEcTKVQVqsChIkQMQlCoXiPL7/GiDhqs5WSR9gYtTuFuf7pLq98vAL7JJajj6JwwmFnkEv+tNFPkuFADC4G20UdRbwQUlwvod2pcU7wd0ZlIjE3SI26LscA5CRXDYlDHrlKqR1yK2mE7iHbRxaN6MgfO/1TDUxzGIfHU1Tj4qTHJyFsbZOSZqQDXb+jOLIZimkEeSlM//LXoutR7FA5AqdnshVK+8VJJy9ToouRVTmzvwBLrzqTqwY0pd94rJxsuQVP00tNdDakvNEqLX6JYbrAQ6Vcr795jPv9ybPENlDLIvo//gv0slgrAT8K+JSeEw2GDvjeI+Sws8wcm3rnoJ0i68LEaXQURqOrNRBZBOByQi92cC+DHat5pzw2c1bqLNAYl49ppRDF36ikAAOoXtsDG+i3KyxKT0f/XEbUrhRMQ7bQXbz2iz9+ptW370/fRprK5Sh0AfjRBnioddcYMRAk08uwwDEWbVlVkWCd4c6PJnAerA
 icUlDb77
 9yYHdi6b5l0xzVAOafrBPkHIlf2tCmfM7BEIQLRbmcmZh+53kQTQAyEp0vyr61Sa2utKKa/yc44Yfj/mzx5T6ukcFhi658lFDs3I83RIUFR3z2/aOQfhCTgP93TYnj6Gr+/lhBb07nW7sWV+lvXJK2gRHvBDuikpa8BIzr53zwVXiCy+4Fz4hkx+0cc8EGZ6z0nTTBTQh0dKo7nExKbNkERV2MchCZdkN+I6iUC4JclahHH+37uWVGJY1k99QsupPnKneqdRTewysJN3bZJNKRI/61YAKKJQ5NrEs+ovUiAwht/V88pPfjhHmukYlCoBEJvbh0a/6st/bRFvmJX7lbc6E5WX7FK7Hlz8hPNtRKjdHSNcK+5A503XUX/3c9je3dK7+LeFrvVVl/C35BfULBOQJK7t0s69apU9eM3uU2S8yDeGFr8X1g/wk2BCpLv0PsaaREr/cyHiwPGAUK0W7GYH5RbtyGk6MJo1s/0qykP0d2ng=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Hongru Zhang <zhanghongru@xiaomi.com>

Currently, when a page fault returns VM_FAULT_RETRY under the per-VMA
lock due to folio_lock() failing, mainly because the folio is under
I/O, the architecture fault handler unconditionally falls back to
retrying with mmap_lock. This leads to mmap_lock contention.

This patch introduces VM_FAULT_RETRY_HARD to mark the paths that
require mmap_lock. Retries now stay under the per-VMA lock by default,
and only marked paths fall back to the mmap_lock retry path.

Based on the stress model from Kunwu Chan and Wang Lian in v2, we
adapted a benchmark for a 20-core desktop environment (reduced thread
count, adjusted memcg limits, 20-core Intel i7-12700). The benchmark
uses concurrent page faults under memcg pressure (forcing reclaim and
VM_FAULT_RETRY) with parallel munmap to amplify mmap_lock read-write
contention.

Throughput (higher is better):
+---------+------------+------------+-------------+
| Threads |  Vanilla   |  Patched   | Improvement |
+---------+------------+------------+-------------+
|   40    | 1071.11 /s | 1301.11 /s |   +21.5%    |
+---------+------------+------------+-------------+
|   60    | 1043.15 /s | 1472.36 /s |   +41.1%    |
+---------+------------+------------+-------------+
|   80    | 1049.39 /s | 1665.65 /s |   +58.7%    |
+---------+------------+------------+-------------+

mmap_lock contention count (lower is better):
+---------+-----------+---------+-----------+
| Threads |  Vanilla  | Patched | Reduction |
+---------+-----------+---------+-----------+
|   40    | 3,217,904 |  51,201 |  -98.4%   |
+---------+-----------+---------+-----------+
|   60    | 4,419,149 |  55,711 |  -98.7%   |
+---------+-----------+---------+-----------+
|   80    | 5,395,730 |  66,184 |  -98.8%   |
+---------+-----------+---------+-----------+

Benchmark and test scripts:
https://gist.github.com/zhr250/c36c2c54d9351df37e12fd072d4926ef

Suggested-by: Barry Song <baohua@kernel.org>
Suggested-by: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Hongru Zhang <zhanghongru@xiaomi.com>
---
Changes since v2:
- v2 required each retry path to explicitly opt in to VMA lock retry
  (VM_FAULT_RETRY_VMA). This patch inverts the logic: retries default
  to VMA lock, and only paths requiring mmap_lock opt out
  (VM_FAULT_RETRY_HARD)
- This patch corresponds to v2 patch 1/5; the remaining optimizations
  will be submitted separately
- Rebased on mm-unstable

Link to v2:
https://lore.kernel.org/all/20260430040427.4672-1-baohua@kernel.org/

Link to v1:
https://lore.kernel.org/all/20251127011438.6918-1-21cnbao@gmail.com/

 arch/arm/mm/fault.c       | 4 ++++
 arch/arm64/mm/fault.c     | 4 ++++
 arch/loongarch/mm/fault.c | 4 ++++
 arch/powerpc/mm/fault.c   | 4 ++++
 arch/riscv/mm/fault.c     | 4 ++++
 arch/s390/mm/fault.c      | 4 ++++
 arch/x86/mm/fault.c       | 4 ++++
 include/linux/mm_types.h  | 9 +++++----
 mm/huge_memory.c          | 2 +-
 mm/memory.c               | 6 +++---
 10 files changed, 37 insertions(+), 8 deletions(-)

diff --git a/arch/arm/mm/fault.c b/arch/arm/mm/fault.c
index e62cc4be5adf..2f909fb4f7db 100644
--- a/arch/arm/mm/fault.c
+++ b/arch/arm/mm/fault.c
@@ -391,6 +391,7 @@ do_page_fault(unsigned long addr, unsigned int fsr, struct pt_regs *regs)
 	if (!(flags & FAULT_FLAG_USER))
 		goto lock_mmap;
 
+retry_vma:
 	vma = lock_vma_under_rcu(mm, addr);
 	if (!vma)
 		goto lock_mmap;
@@ -420,6 +421,9 @@ do_page_fault(unsigned long addr, unsigned int fsr, struct pt_regs *regs)
 			goto no_context;
 		return 0;
 	}
+	if (!(fault & VM_FAULT_RETRY_HARD))
+		goto retry_vma;
+
 lock_mmap:
 
 retry:
diff --git a/arch/arm64/mm/fault.c b/arch/arm64/mm/fault.c
index 739800835920..695a09486795 100644
--- a/arch/arm64/mm/fault.c
+++ b/arch/arm64/mm/fault.c
@@ -673,6 +673,7 @@ static int __kprobes do_page_fault(unsigned long far, unsigned long esr,
 	if (!(mm_flags & FAULT_FLAG_USER))
 		goto lock_mmap;
 
+retry_vma:
 	vma = lock_vma_under_rcu(mm, addr);
 	if (!vma)
 		goto lock_mmap;
@@ -719,6 +720,9 @@ static int __kprobes do_page_fault(unsigned long far, unsigned long esr,
 			goto no_context;
 		return 0;
 	}
+	if (!(fault & VM_FAULT_RETRY_HARD))
+		goto retry_vma;
+
 lock_mmap:
 
 retry:
diff --git a/arch/loongarch/mm/fault.c b/arch/loongarch/mm/fault.c
index 2c93d33356e5..d7dd55722e52 100644
--- a/arch/loongarch/mm/fault.c
+++ b/arch/loongarch/mm/fault.c
@@ -219,6 +219,7 @@ static void __kprobes __do_page_fault(struct pt_regs *regs,
 	if (!(flags & FAULT_FLAG_USER))
 		goto lock_mmap;
 
+retry_vma:
 	vma = lock_vma_under_rcu(mm, address);
 	if (!vma)
 		goto lock_mmap;
@@ -265,6 +266,9 @@ static void __kprobes __do_page_fault(struct pt_regs *regs,
 			no_context(regs, write, address);
 		return;
 	}
+	if (!(fault & VM_FAULT_RETRY_HARD))
+		goto retry_vma;
+
 lock_mmap:
 
 retry:
diff --git a/arch/powerpc/mm/fault.c b/arch/powerpc/mm/fault.c
index 806c74e0d5ab..65ec9a8252e7 100644
--- a/arch/powerpc/mm/fault.c
+++ b/arch/powerpc/mm/fault.c
@@ -487,6 +487,7 @@ static int ___do_page_fault(struct pt_regs *regs, unsigned long address,
 	if (!(flags & FAULT_FLAG_USER))
 		goto lock_mmap;
 
+retry_vma:
 	vma = lock_vma_under_rcu(mm, address);
 	if (!vma)
 		goto lock_mmap;
@@ -517,6 +518,9 @@ static int ___do_page_fault(struct pt_regs *regs, unsigned long address,
 	if (fault_signal_pending(fault, regs))
 		return user_mode(regs) ? 0 : SIGBUS;
 
+	if (!(fault & VM_FAULT_RETRY_HARD))
+		goto retry_vma;
+
 lock_mmap:
 
 	/* When running in the kernel we expect faults to occur only to
diff --git a/arch/riscv/mm/fault.c b/arch/riscv/mm/fault.c
index 04ed6f8acae4..6c68414a1224 100644
--- a/arch/riscv/mm/fault.c
+++ b/arch/riscv/mm/fault.c
@@ -347,6 +347,7 @@ void handle_page_fault(struct pt_regs *regs)
 	if (!(flags & FAULT_FLAG_USER))
 		goto lock_mmap;
 
+retry_vma:
 	vma = lock_vma_under_rcu(mm, addr);
 	if (!vma)
 		goto lock_mmap;
@@ -376,6 +377,9 @@ void handle_page_fault(struct pt_regs *regs)
 			no_context(regs, addr);
 		return;
 	}
+	if (!(fault & VM_FAULT_RETRY_HARD))
+		goto retry_vma;
+
 lock_mmap:
 
 retry:
diff --git a/arch/s390/mm/fault.c b/arch/s390/mm/fault.c
index 028aeb9c48d6..45a6c35044cc 100644
--- a/arch/s390/mm/fault.c
+++ b/arch/s390/mm/fault.c
@@ -294,6 +294,7 @@ static void do_exception(struct pt_regs *regs, int access)
 		flags |= FAULT_FLAG_WRITE;
 	if (!(flags & FAULT_FLAG_USER))
 		goto lock_mmap;
+retry_vma:
 	vma = lock_vma_under_rcu(mm, address);
 	if (!vma)
 		goto lock_mmap;
@@ -318,6 +319,9 @@ static void do_exception(struct pt_regs *regs, int access)
 			handle_fault_error_nolock(regs, 0);
 		return;
 	}
+	if (!(fault & VM_FAULT_RETRY_HARD))
+		goto retry_vma;
+
 lock_mmap:
 retry:
 	vma = lock_mm_and_find_vma(mm, address, regs);
diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
index 63de8e8684f2..cb80070271d0 100644
--- a/arch/x86/mm/fault.c
+++ b/arch/x86/mm/fault.c
@@ -1322,6 +1322,7 @@ void do_user_addr_fault(struct pt_regs *regs,
 	if (!(flags & FAULT_FLAG_USER))
 		goto lock_mmap;
 
+retry_vma:
 	vma = lock_vma_under_rcu(mm, address);
 	if (!vma)
 		goto lock_mmap;
@@ -1351,6 +1352,9 @@ void do_user_addr_fault(struct pt_regs *regs,
 						 ARCH_DEFAULT_PKEY);
 		return;
 	}
+	if (!(fault & VM_FAULT_RETRY_HARD))
+		goto retry_vma;
+
 lock_mmap:
 
 retry:
diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index 5ef78617ce93..58db6f0af6fd 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -1665,10 +1665,11 @@ enum vm_fault_reason {
 	VM_FAULT_NOPAGE         = (__force vm_fault_t)0x000100,
 	VM_FAULT_LOCKED         = (__force vm_fault_t)0x000200,
 	VM_FAULT_RETRY          = (__force vm_fault_t)0x000400,
-	VM_FAULT_FALLBACK       = (__force vm_fault_t)0x000800,
-	VM_FAULT_DONE_COW       = (__force vm_fault_t)0x001000,
-	VM_FAULT_NEEDDSYNC      = (__force vm_fault_t)0x002000,
-	VM_FAULT_COMPLETED      = (__force vm_fault_t)0x004000,
+	VM_FAULT_RETRY_HARD     = (__force vm_fault_t)0x000800,
+	VM_FAULT_FALLBACK       = (__force vm_fault_t)0x001000,
+	VM_FAULT_DONE_COW       = (__force vm_fault_t)0x002000,
+	VM_FAULT_NEEDDSYNC      = (__force vm_fault_t)0x004000,
+	VM_FAULT_COMPLETED      = (__force vm_fault_t)0x008000,
 	VM_FAULT_HINDEX_MASK    = (__force vm_fault_t)0x0f0000,
 };
 
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 94bd656eeaf8..ad0129d579bc 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1398,7 +1398,7 @@ vm_fault_t do_huge_pmd_device_private(struct vm_fault *vmf)
 
 	if (vmf->flags & FAULT_FLAG_VMA_LOCK) {
 		vma_end_read(vma);
-		return VM_FAULT_RETRY;
+		return VM_FAULT_RETRY | VM_FAULT_RETRY_HARD;
 	}
 
 	ptl = pmd_lock(vma->vm_mm, vmf->pmd);
diff --git a/mm/memory.c b/mm/memory.c
index ff338c2abe92..7f2a30b5efca 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -3797,7 +3797,7 @@ static inline vm_fault_t vmf_can_call_fault(const struct vm_fault *vmf)
 	if (vma->vm_ops->map_pages || !(vmf->flags & FAULT_FLAG_VMA_LOCK))
 		return 0;
 	vma_end_read(vma);
-	return VM_FAULT_RETRY;
+	return VM_FAULT_RETRY | VM_FAULT_RETRY_HARD;
 }
 
 /**
@@ -3824,7 +3824,7 @@ vm_fault_t __vmf_anon_prepare(struct vm_fault *vmf)
 		return 0;
 	if (vmf->flags & FAULT_FLAG_VMA_LOCK) {
 		if (!mmap_read_trylock(vma->vm_mm))
-			return VM_FAULT_RETRY;
+			return VM_FAULT_RETRY | VM_FAULT_RETRY_HARD;
 	}
 	if (__anon_vma_prepare(vma))
 		ret = VM_FAULT_OOM;
@@ -4778,7 +4778,7 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
 				 * under VMA lock.
 				 */
 				vma_end_read(vma);
-				ret = VM_FAULT_RETRY;
+				ret = VM_FAULT_RETRY | VM_FAULT_RETRY_HARD;
 				goto out;
 			}
 

base-commit: 81652c5a65d4ae28e9b18c16ef917a40025c3653
-- 
2.43.0


