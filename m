Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A80C7E8FDB1
	for <linux-mm@archiver.kernel.org>; Mon, 29 Dec 2025 05:52:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4EC406B0088; Mon, 29 Dec 2025 00:52:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 499A86B0089; Mon, 29 Dec 2025 00:52:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 398136B008A; Mon, 29 Dec 2025 00:52:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 284566B0088
	for <linux-mm@kvack.org>; Mon, 29 Dec 2025 00:52:13 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 7F0D88CC28
	for <linux-mm@kvack.org>; Mon, 29 Dec 2025 05:52:12 +0000 (UTC)
X-FDA: 84271438104.27.C6ABD09
Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	by imf26.hostedemail.com (Postfix) with ESMTP id C3734140004
	for <linux-mm@kvack.org>; Mon, 29 Dec 2025 05:52:10 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="GuyXB/kE";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf26.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.216.52 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766987530; a=rsa-sha256;
	cv=none;
	b=8bd4/HchOqfKW3tQ3CClt9Sf1L3EIFiv4aSNBGp66A5N16N4Xe7ndHkn42jgBuaQBbowjU
	0e/aMfBuDbAy3x4KJ94cidc6BQSgqQYw7YFjktQw20oBI/Gft3LAj6uVZhY2MiRsqGNb3a
	yLGD8UwApwbn6Zf9lCm8TtH5n3aDtYA=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="GuyXB/kE";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf26.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.216.52 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766987530;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=GwZc8D9qIOEPObhGT+ZYI7JCUtF0SjfJuFQ2Q9xdOp8=;
	b=hh5hNuh8vfJ4uSKNkXPQozpBEtXhAVyHkaDJcTiXNOdCaC5/uonqve0UOZRmD9gTAYo49H
	APEOHU018wVnyusWGeY9vPbkq2JvcnOb/ApmwiDbU1TDgnkkQCBrMxQl+QAmfgTJEzoY44
	YP3JScMwQ7myvkTI65OcVpVcPUX9xDA=
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-34f0bc64a27so957611a91.1
        for <linux-mm@kvack.org>; Sun, 28 Dec 2025 21:52:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766987529; x=1767592329; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=GwZc8D9qIOEPObhGT+ZYI7JCUtF0SjfJuFQ2Q9xdOp8=;
        b=GuyXB/kEG22BSVB+zOi/KZkzi6JqDiaEZXWB6J0bpmc0fg2HxXROclEYW4+Df7BO0c
         n43mlQb5y8hWsB1vI+mGO5Y5Su6X6UTiekXIuAAbhlJoHBLx43p1BGTvi7IygqRV3roY
         1YPXLPbGyi4gz2/mBPUjkmj7F9YdsxKs4QWAWP04VIuldRYj8S5JlY37/3vEqnrhZh6t
         otUkNkr/rFQcDmDD5wewDdQvWdsPrv+m4DA0e2T0kZ1oiLVE9kAlJxkJlFpOevgeXJdH
         /E8sTtwJf6Eo+ZUH1kfp4iwhe0TGgJuG28r6dtMXPIAR4LqKnl2yUSFcWYhQiw3OaEDd
         CiyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766987529; x=1767592329;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GwZc8D9qIOEPObhGT+ZYI7JCUtF0SjfJuFQ2Q9xdOp8=;
        b=Iqoyecej+kqXA6aAFhQciNcajuV63ROImflvaQO17fARU3O3W3AKqnQKILGvNnbos1
         2VCYuyVqCU1Tg49G4UEFfypjzUdNoNVT58Gb/H+xoICX9YcOJYKVc03C0IB5SermMDL3
         kvunm/ACBNn5Cj3pku2BzZNI5vi9C2LblSbD9hvG4b31bzx7e+UV09IznByOR9hf5ROk
         ohaXc5RIb/JbmIa6crtMC9+S0E6Bcx53znAaBkfAx12GYGReKeC7phat1l8RdZKv8RUG
         kZ2neSLP5dzM/q4PMQVJPWl1K2C/KIJfGPpcKtPj2DGLMYtKJpWf0NeKkYSVQjuuW4tl
         Q0aw==
X-Forwarded-Encrypted: i=1; AJvYcCUQVY0Lru7kUbdk79b3vFIMidQ9dS193/42rr4moYpNKj9m8VZ+VB8+ogmGwlhDWE9Q1cadoDt5PA==@kvack.org
X-Gm-Message-State: AOJu0YyDJ2cVxnbImco63S7R6/2up4VQ/eR3A7UzFMG+CNtd5c54dIQy
	K+aO9qEKQTF4aPZew55ewF5utLj2jW08ZzzvIYPiZwkvVe7aMGE5OhcL
X-Gm-Gg: AY/fxX63qygx3mIt97pVE9cNlsPaoetEIo+73C3a1mgzJqMhwJhni7mhFKGzlcWqg9P
	4KMLxmH1Gy9iZ/sVkam5YwthSJUAZUwRFEXEhHb7XUy8N3rq0rUUp9+0xzyhRNYuCxWgAITSM+l
	ei4AApy1LPzmt+PfFEE3cyvS8RIXJO8NTAKtJ0jh4c/10NHprqd90O/jZSqJPZpBKw+0BqZBgC+
	r2Lg29BiCZhX95Lz5cL2cACWgODnXZAVnr3HPs91LM+pD6jdZLrYEy6yUOanrJ864NWpg61DgZ0
	ON915JKgId+FwZyrS4Xrls7esYBC71hQu6WAagcA+XL0fjud6MSaYzsP4qUsDtT9ywTlU4mGgOb
	remJtG8nnsXb7Jau3mpV7a0QUrxqRPdcZKX1k5/S/8TXoytbp794CWaP+QbenSRU04MWhbtZtZe
	AU88atOzatXbPSQao+ikOwOYsxWJ4g
X-Google-Smtp-Source: AGHT+IHgdK+LhHjBymPTO5HkjTAAEhd8fnZwS6pZFnoRxqJJE2qq7+OYjDGbCakVhrSXIr8yhdms8Q==
X-Received: by 2002:a17:90b:4b43:b0:343:e2ba:e8be with SMTP id 98e67ed59e1d1-34e9214bec7mr23998689a91.10.1766987529458;
        Sun, 28 Dec 2025 21:52:09 -0800 (PST)
Received: from localhost.localdomain ([121.232.80.251])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-34e920c9a7csm26164019a91.0.2025.12.28.21.52.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 Dec 2025 21:52:09 -0800 (PST)
From: Vernon Yang <vernon2gm@gmail.com>
X-Google-Original-From: Vernon Yang <yanglincheng@kylinos.cn>
To: akpm@linux-foundation.org,
	david@kernel.org,
	lorenzo.stoakes@oracle.com
Cc: ziy@nvidia.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	richard.weiyang@gmail.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Vernon Yang <yanglincheng@kylinos.cn>
Subject: [PATCH v2 0/4] Improve khugepaged scan logic
Date: Mon, 29 Dec 2025 13:51:47 +0800
Message-ID: <20251229055151.54887-1-yanglincheng@kylinos.cn>
X-Mailer: git-send-email 2.51.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: C3734140004
X-Rspamd-Server: rspam10
X-Stat-Signature: z7qcn3et5sys5jd7azk4an4hizboa8pj
X-HE-Tag: 1766987530-387274
X-HE-Meta: U2FsdGVkX19qWJ5RUk/B8wfG+OFsicWTvsNBQvg/wSJ68qP5M8Nc2ZwBCPcr7Uyjy9+DjsjB3OCrIma4sb4/KW8I34lUm2huQGMVjrNhwkeZDGI+745LegI01wNmevyH2kSsvtHtgH6+ZTZaLwgiHoy2clYfhQ9GuQy6RF98RNGH1NTtuMfLHuLNOwH3Qe8gOKNluoF1X+5/z4wiQ2fMq5Oab/5spQ1tEjfEODkroDl8qiZobHmbveDZqXOB8e//9CfzZjSrots5jRFp8CwfLlnLQyqmiWcHcoho1zFVSgnyuTOMBBXEZq2MqGk1vXAbrBpnIcUTDoyneov5G5Z40y6C3Tp9QgumQX7CkGM8zmnlvIP7Uy8cs2JlAAIwc6zGfQ+hXlxKoS/6snSVpPSIJFbbQwj/FZBNQIgnarOv2rFGu9VLHvHdnSznyWIABkdOdnRGBIFIfxIwf5MKVoR5hWDeyzJpSfYl+WmeONJPKvvdZZ7I9ypvlZPpvgl5fJxSxvhLwaOhKeWJE2R5n7t4DFJyt0EyaHd8ZEki4/rjSyu6ZFUkHuHfx4N+w12O64pHi4RhuvNnzaO2eJcQNNW+RrBMDibFo9N1ss5Kg/X0/5aaxzwSDQ2oRNnxnWY6M2yvOd6tf0BxaKpGIppYPX7D51TwFUUCik3KwqvnganPDYacQkjNB2wP0LZp1YQwPZsh91zgzO8iZ4WRNjDCuZ2J082z9Tusu70OpJdYsuVEMBeZVfcZODqENF8c/8VXZGYkZILHVCA3FvfidSjLNJTXnf5OX2YKtD9g0QNPKwLJ3+jgwySp5Icw6OikSWS67jjgZpf4puDNxObId3eLHxr//8NYLzAAtAsjD7s8woqyI0ETd5Zw5QRM9eZE+E9ogvSqJPtYla2ahR+RdA8hJsTq5+gqrv9CvFPloYMbZePJc6WYxfdKMgPB+C/eOtVKvt3Kcvc4qoYf/XQkFISY/4H
 jja5F4/+
 H/3vR3qCS+b5OGR3CpXXF/uHAwW3AB4rIHOphDCLP1IogZBj7479Wy/N7hITWG7fPovjRjriD0G4iICtDAbFDqb6VNg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi all,

This series is improve the khugepaged scan logic, reduce CPU consumption,
prioritize scanning task that access memory frequently.

The following data is traced by bpftrace[1] on a desktop system. After
the system has been left idle for 10 minutes upon booting, a lot of
SCAN_PMD_MAPPED or SCAN_NO_PTE_TABLE are observed during a full scan by
khugepaged.

@scan_pmd_status[1]: 1           ## SCAN_SUCCEED
@scan_pmd_status[6]: 2           ## SCAN_EXCEED_SHARED_PTE
@scan_pmd_status[3]: 142         ## SCAN_PMD_MAPPED
@scan_pmd_status[2]: 178         ## SCAN_NO_PTE_TABLE
total progress size: 674 MB
Total time         : 419 seconds ## include khugepaged_scan_sleep_millisecs

The khugepaged has below phenomenon: the khugepaged list is scanned in a
FIFO manner, as long as the task is not destroyed,
1. the task no longer has memory that can be collapsed into hugepage,
   continues scan it always.
2. the task at the front of the khugepaged scan list is cold, they are
   still scanned first.
3. everyone scan at intervals of khugepaged_scan_sleep_millisecs
   (default 10s). If we always scan the above two cases first, the valid
   scan will have to wait for a long time.

For the first case, when the memory is either SCAN_PMD_MAPPED or
SCAN_NO_PTE_TABLE, just skip it.

For the second case, if the user has explicitly informed us via
MADV_COLD/MADV_FREE that this vma is cold or will be freed,
just skip it only.

The below is some performance test results.

kernbench results (testing on x86_64 machine):

                     baseline w/o patches   test w/ patches
Amean     user-32    18586.99 (   0.00%)    18562.36 *   0.13%*
Amean     syst-32     1133.61 (   0.00%)     1126.02 *   0.67%*
Amean     elsp-32      668.05 (   0.00%)      667.13 *   0.14%*
BAmean-95 user-32    18585.23 (   0.00%)    18559.71 (   0.14%)
BAmean-95 syst-32     1133.22 (   0.00%)     1125.49 (   0.68%)
BAmean-95 elsp-32      667.94 (   0.00%)      667.08 (   0.13%)
BAmean-99 user-32    18585.23 (   0.00%)    18559.71 (   0.14%)
BAmean-99 syst-32     1133.22 (   0.00%)     1125.49 (   0.68%)
BAmean-99 elsp-32      667.94 (   0.00%)      667.08 (   0.13%)

Create three task[2]: hot1 -> cold -> hot2. After all three task are
created, each allocate memory 128MB. the hot1/hot2 task continuously
access 128 MB memory, while the cold task only accesses its memory
briefly andthen call madvise(MADV_COLD). Here are the performance test
results:
(Throughput bigger is better, other smaller is better)

Testing on x86_64 machine:

| task hot2           | without patch | with patch    |  delta  |
|---------------------|---------------|---------------|---------|
| total accesses time |  3.14 sec     |  2.93 sec     | -6.69%  |
| cycles per access   |  4.96         |  2.21         | -55.44% |
| Throughput          |  104.38 M/sec |  111.89 M/sec | +7.19%  |
| dTLB-load-misses    |  284814532    |  69597236     | -75.56% |

Testing on qemu-system-x86_64 -enable-kvm:

| task hot2           | without patch | with patch    |  delta  |
|---------------------|---------------|---------------|---------|
| total accesses time |  3.35 sec     |  2.96 sec     | -11.64% |
| cycles per access   |  7.29         |  2.07         | -71.60% |
| Throughput          |  97.67 M/sec  |  110.77 M/sec | +13.41% |
| dTLB-load-misses    |  241600871    |  3216108      | -98.67% |

This series is based on Linux v6.19-rc2.

Thank you very much for your comments and discussions :)


[1] https://github.com/vernon2gh/app_and_module/blob/main/khugepaged/khugepaged_mm.bt
[2] https://github.com/vernon2gh/app_and_module/blob/main/khugepaged/app.c

V1 -> V2:
- Rename full to full_scan_finished, pickup Acked-by.
- Just skip SCAN_PMD_MAPPED/NO_PTE_TABLE memory, not remove mm.
- Set VM_NOHUGEPAGE flag when MADV_COLD/MADV_FREE to just skip, not move mm.
- Again test performance at the v6.19-rc2.

Vernon Yang (4):
  mm: khugepaged: add trace_mm_khugepaged_scan event
  mm: khugepaged: just skip when the memory has been collapsed
  mm: khugepaged: set VM_NOHUGEPAGE flag when MADV_COLD/MADV_FREE
  mm: khugepaged: set to next mm direct when mm has
    MMF_DISABLE_THP_COMPLETELY

 include/trace/events/huge_memory.h | 24 +++++++++++++++++++++
 mm/khugepaged.c                    | 34 ++++++++++++++++++++++++------
 mm/madvise.c                       | 17 ++++++++++-----
 3 files changed, 63 insertions(+), 12 deletions(-)

--
2.51.0


