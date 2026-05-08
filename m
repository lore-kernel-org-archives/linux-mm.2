Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 44636CD3436
	for <linux-mm@archiver.kernel.org>; Fri,  8 May 2026 06:19:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8FCD16B0103; Fri,  8 May 2026 02:19:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8D3E06B0104; Fri,  8 May 2026 02:19:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 811286B0105; Fri,  8 May 2026 02:19:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 718B76B0103
	for <linux-mm@kvack.org>; Fri,  8 May 2026 02:19:25 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 1D3BFC262A
	for <linux-mm@kvack.org>; Fri,  8 May 2026 06:19:25 +0000 (UTC)
X-FDA: 84743250690.03.894408D
Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	by imf13.hostedemail.com (Postfix) with ESMTP id 4B56520007
	for <linux-mm@kvack.org>; Fri,  8 May 2026 06:19:23 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=cd7na+dv;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf13.hostedemail.com: domain of haowenchao22@gmail.com designates 209.85.210.176 as permitted sender) smtp.mailfrom=haowenchao22@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778221163;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=rkBzF4kHcyHsJwA7Bk0uOMxQ0R67JepyxHs0+PT2pxU=;
	b=4fow/DKmd170RWvV7eZ2zN2af3j5nmUGKy7kd6wYRA887nlGSuXZo9BKFxRUGDT0FooQTn
	W1kgWXle07kAhuXbayDba6szNp14SvUctolflBN4fYpntfyfZSHYE4Wq1lqtlZAvPSJfya
	iboSo1Nl3h9wiJP2+3mBILQuHzrntYI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778221163; a=rsa-sha256;
	cv=none;
	b=diuj6ZTWmUSH90iu/Z/qSYaHNCIg5aIsbk2KkO4OUCGZQkmsW9/nvGpImsBsMTspvADM2i
	hPp//Lmj3+TgFhrF4X6vgXtmgUhKmMNQjiUFd/lzUDe9F/wCl6FNpS2Knln5XuyK8mcORF
	PM6xSIGleCvB3o4DJBq+h02xFBQFTCU=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=cd7na+dv;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf13.hostedemail.com: domain of haowenchao22@gmail.com designates 209.85.210.176 as permitted sender) smtp.mailfrom=haowenchao22@gmail.com
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-83975e992e1so809733b3a.2
        for <linux-mm@kvack.org>; Thu, 07 May 2026 23:19:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778221162; x=1778825962; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=rkBzF4kHcyHsJwA7Bk0uOMxQ0R67JepyxHs0+PT2pxU=;
        b=cd7na+dv1TFHgr7tVZeqd1SmeTJ/XCs0jL+5i3JQHukLtvjbFaEGrt5dbRCV0tQ5VS
         2OU3rMVLRuRfl5n0e/BUIG51M/zWEEARLqukfbWiVfQm1sum9ugVF/00dGMoOZYYxLVj
         gCoV6xBpyVuEFhDo5FpsTWVMWGTlhlqOkOXUKoNR6u+mmf8kSKxGOa0+H2i1rg4x+u7M
         vxnX+zdGUjA5uC31jFs8ITzHq6Y7kn/3r/VJFwgiqGhbieAbuReW+R19RJCXaLutyMgK
         ko+hD/KcUmLyyQqRW7waZvsERAdSrNOnfGvM4XAusbLIGsBJ1agtdi52UtxOmlUY9IL/
         RxaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778221162; x=1778825962;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rkBzF4kHcyHsJwA7Bk0uOMxQ0R67JepyxHs0+PT2pxU=;
        b=dd6s6DILuOQkzLckvsxFgj+GUtLDhDANtrlBnCMYhIRBf2kJPTki577QWXpLCC5Wgd
         Ot5/b/uBvuQPt6jN+l05g+VkyKskE9iJiyxSDIfKK165xI9IEq3H0NtzrzzZHJMxz1Kw
         bk1JW9k5yrM8sQ4nr+AluNG1K4yLNyVJQziUjRktPL8TvfNVzlzjL8igxRCLZpRasHxe
         DKj78RwkrS1CGkZhCv2wD1rkZ8Et2U8suFvCpiPGHJp0nEBrRHKPcoKtfY/XhAXZxpCV
         vIjXBB31I/pt82Bw7Ub0xsflZ99vAOJEMLCSQ5uFvs9oZpGhvh4vUlS225xhxIjAE7pm
         3EPw==
X-Forwarded-Encrypted: i=1; AFNElJ9buharoOiScLD0xEueAU7iZfTOb7H79NvQr/gyxDPWDWk5PSw/OMNqqDzqtWKuPJsdgshhRE7N3w==@kvack.org
X-Gm-Message-State: AOJu0YwdyY7AH1wH5rTxXfiJucOByAE+1ZLfkYMiXPJQdP0QMlMi/Qzy
	togkKZhX13dnCs7t5hDgFmkW2pke39jOFhW+5j4TwNn4HA0u34JC1dB9
X-Gm-Gg: AeBDievEqEzzVN0saOHRT57ak/GhdGtke/tAs1bEEKq8z0ppAEicdyofLNRTIPHOhQ/
	BdJsfOjYmY4gXg6g1qPY7FBDriN9Z2aAIXzw6kQos357tlHHjWH2SfG9J85quqfh16/SYempsg1
	NFHXZNWaemn00f31ais8xass0wLX0w8uakV8PTUN+TqPYjbH5D7oy53cxILgNn++Q9LfRZ38xGw
	7moAaNqFYPDEAo7xlo4MdGQ+h7Oull+/vl16CSpYDJLfAE3z+IiToy0eBu1lpRrOHlhkIGcYtU/
	oUAUfr+lbgRaqOkt/lmVn0DVE30O7ympRMKmhbenuuER0IOB3uzk+mneTkX2mO+v8nRv0gjPPlU
	/i+59kCz7wVCw762V06r4Zy8+ut3/7/YA8XXCuRIJl+D1g1PTKemX+Tf6AZJZC7CtWEQ4wJHFnJ
	d/07GPD7/ZO+Wdw3N9TdXhVjFdmrcNbBO13zKAkw==
X-Received: by 2002:a05:6a00:a381:b0:81e:ef16:b288 with SMTP id d2e1a72fcca58-83a5c0c51b3mr10342541b3a.22.1778221162014;
        Thu, 07 May 2026 23:19:22 -0700 (PDT)
Received: from ubuntu22.mioffice.cn ([43.224.245.232])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-83965a3e3ecsm11308452b3a.19.2026.05.07.23.19.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 May 2026 23:19:21 -0700 (PDT)
From: Wenchao Hao <haowenchao22@gmail.com>
X-Google-Original-From: Wenchao Hao <haowenchao@xiaomi.com>
To: Albert Ou <aou@eecs.berkeley.edu>,
	Alexandre Ghiti <alex@ghiti.fr>,
	Andrew Morton <akpm@linux-foundation.org>,
	Barry Song <21cnbao@gmail.com>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-riscv@lists.infradead.org,
	Minchan Kim <minchan@kernel.org>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Paul Walmsley <pjw@kernel.org>,
	Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Wenchao Hao <haowenchao22@gmail.com>,
	Wenchao Hao <haowenchao@xiaomi.com>
Subject: [RFC PATCH 0/3] mm/zsmalloc: reduce lock contention in zs_free()
Date: Fri,  8 May 2026 14:19:07 +0800
Message-Id: <20260508061910.3882831-1-haowenchao@xiaomi.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 4B56520007
X-Stat-Signature: h5cnr9afigb554t9dk3zbgj1xc9qhymc
X-Rspam-User: 
X-HE-Tag: 1778221163-982427
X-HE-Meta: U2FsdGVkX188CwOpTFZg9zuJe3ZDpSzL556ML+j9zZnpYGAbzJRJ5BtD/95AU0uJOcSEGbrLguLGeCkp5YMgHJ/k02gVkBo93xqN0AmnMVTLhbUyz2GM2rMSMt8nMNxZGJQWbzG6Yg/TRu7Yg84ZjsR/17PD3ARegDNqLM3Og9IX2YWREDq2SaxM/3FNq8S3n6iCFfn98sjQZ9fOw54adpSudpl1rCBLPydvsowj0TGl8gS5YMdwq7ICvn6wCvUXQkDuJRuVbVj22jhxFXwHgTxY6oGbCtojkNf3pOd+sZrT3N1fuhluWip2FDIrAIX5x5KHepq7zJULTQiYMFloOqIrts8aqeH3onOYxOxtBQJrPIlDyzhE96C+Q0gpw/53UcvyJgs9jiovyAVjxrQYrb7Xt8seiRj4IAAA/Pm3iMy+Q1/uzJXE47Mqkq7WWPuG8gaIGMIDzAQdwJ7FEYiQaNe5YCY3ugR9V5+BsBEKZOXYnFRX2jhuCvDrSGaRaFnlCQDFSkQMdFNsy8y8wF/VfWd+uS033DNHI+qzzYHFE3lR8rK4vAdlm3Vxbjg1v0FCP9z8aFGLsyDhN2fsqDrqQMjlCwVS0QQ42d8pJzQ29BIG9YsJfOuLp4i9y8331FL94mtEvxG4t/tu0/MKjcBwwhxe4L+SWrDR+jRLRjBDU1sEDwWPcXlFvvKbCjtwmBjJiIF4G104xBKGMS+056pAFRzFQs6X+Dn1uCJSwH3soHNw5cQ/F5I3L0DJ7buHdXrSicE15tzArsV+w6+elx4r6hQv2RfjyoLYawpNnLOGhEpZnOWqnJJA18iyQxKdc5EU0wVilzYYM7YKrblXk8UFaNTrX2WReM2kaXEhSkz1jHz7miMdppBQsl0jqKtAgreCInoEs4YsI0o96pjLIj2+FeXM0W+3JscDaVjwF/+HzUMBYu4xb2JVcuxshmv/UtMPChl3lsCITJUf3Ngs0ab
 0yFLHc3G
 Wj7NP6DJdWiQAeHLX3utjdbQ7rEBVedndFPNxkqWxxL7y7/sQziVsZRjPKkYe7E0gkQr0c9VVegsmHnuBML13G1Ub7+3sKaPEzLRaTgInhQLRVGhK07WhLHSsW/uALqauB6VCeq6n/4FyYB2U25W223gaiVmG8cqgDGYBXyqIrljUeDoy4QzxXnQDC4FSHGM4YMB9zoWyEj2uS/l1UYs8VNNiMGCVrSZVKyFsyCXGgbbQ6eWeWxYxdfUv850KnmpyXnJXU5f69X13EpV9slh4HtQgXg+XwLSq4AFuuB1nx3CIw8K+VOMC1qvD+QLXa7PmnhmblnomnpCEkZLwVTf+vLrC4RUQzniT0iU+oDEX5IDWcVktgk6x7v/2T131eIHNmurJpNmqtPw5qJIOGF2aaoY4yeJldEReQ80+ocQC7EgaZKaP9dEXK1tujb/CrvSyW1zw8nec+cAe7kl9hFripSXxrneSM5UJVA1u5pOF1SBsCk0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Swap freeing can be expensive when unmapping a VMA containing many swap
entries. This has been reported to significantly delay memory reclamation
during Android's low-memory killing, especially when multiple processes
are terminated to free memory, with slot_free() accounting for more than
80% of the total cost of freeing swap entries.

Lock contention in zs_free() is a major contributor to this cost:
  - pool->lock (rwlock) read-side atomic operations become expensive
    under multi-process concurrency due to cacheline bouncing
  - class->lock held across zspage page freeing causes zone->lock
    contention to propagate back

This series addresses both issues:

Patch 1: Encode class_idx in obj value
  On 64-bit systems, OBJ_INDEX_BITS is over-provisioned. We split it
  into class_idx + obj_idx so that zs_free() can determine the correct
  size_class from the obj value alone, without needing pool->lock.

Patch 2: Remove pool->lock from zs_free()
  With class_idx available from the obj encoding, zs_free() acquires
  only class->lock (re-reading obj for a stable PFN). This eliminates
  rwlock read-side contention between concurrent zs_free() calls and
  page migration/compaction.

Patch 3: Drop class->lock before freeing zspage pages
  Move the actual page release (free_zspage) outside class->lock. The
  bookkeeping is done under the lock, but buddy allocator interaction
  (zone->lock) no longer nests inside class->lock.

Performance results:

Test: each process independently mmap 256MB, write data, madvise
MADV_PAGEOUT to swap out via zram (lzo-rle), then concurrent munmap.

Raspberry Pi 4B (4-core ARM64 Cortex-A72):

  mode        Base       Patched     Speedup
  single      59.0ms     56.0ms      1.05x
  multi 2p    94.6ms     66.7ms      1.42x
  multi 4p    202.9ms    110.6ms     1.83x

x86 (20-core Intel i7-12700, 16 concurrent processes):

  mode        Base       Patched     Speedup
  single      11.7ms     9.8ms       1.19x
  multi 2p    24.1ms     17.2ms      1.40x
  multi 4p    63.0ms     45.3ms      1.39x

Single-process shows modest improvement. With multiple processes,
each read_lock/read_unlock atomically modifies the shared rwlock
reader count, and the cost of these atomic operations increases
with more CPUs accessing the same cacheline concurrently.
Eliminating pool->lock removes this overhead entirely.

Patch 1-2 only work on 64-bit systems (gated by ZS_OBJ_CLASS_IDX);
32-bit falls back to the original pool->lock path. Patch 3 benefits
all architectures.

Wenchao Hao (2):
  mm/zsmalloc: encode class index in obj value for lockless class lookup
  mm/zsmalloc: remove pool->lock from zs_free on 64-bit systems

Xueyuan Chen (1):
  mm/zsmalloc: drop class lock before freeing zspage

 mm/zsmalloc.c | 146 ++++++++++++++++++++++++++++++++++++++++++++------
 1 file changed, 131 insertions(+), 15 deletions(-)

--
2.34.1


