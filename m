Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 45EEAD2502E
	for <linux-mm@archiver.kernel.org>; Sun, 11 Jan 2026 12:19:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4DD786B0088; Sun, 11 Jan 2026 07:19:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 48BC36B0089; Sun, 11 Jan 2026 07:19:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 36D556B008A; Sun, 11 Jan 2026 07:19:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2496B6B0088
	for <linux-mm@kvack.org>; Sun, 11 Jan 2026 07:19:35 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B1249599E7
	for <linux-mm@kvack.org>; Sun, 11 Jan 2026 12:19:34 +0000 (UTC)
X-FDA: 84319588668.01.7DD965A
Received: from mail-pg1-f172.google.com (mail-pg1-f172.google.com [209.85.215.172])
	by imf02.hostedemail.com (Postfix) with ESMTP id 0E05280006
	for <linux-mm@kvack.org>; Sun, 11 Jan 2026 12:19:32 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=l6O9GJDi;
	spf=pass (imf02.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.215.172 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768133973;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=uiMvrJOYUzQmUPoXzeap6162aGuxIMcZy1UNPq2JUvY=;
	b=R1hHGyJ0P02MCV8mBhULF9XUNJiUfMnu6ChV5FOy4a5/58Ny3uGcGvAEwKz6Aihe2tClSW
	ia50sYg88nh8UXnNDE1QLkbZKYFmZwsvlxuvYeCFUojlEINOB2dwyGH+6wqjpKplqrwMhk
	zAyXfAk1xJ8NrjGB+fJKGyngIDSt3Y0=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=l6O9GJDi;
	spf=pass (imf02.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.215.172 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768133973; a=rsa-sha256;
	cv=none;
	b=NCFbsqLu4kRYo3w9sRekYhd1r5lF9epPFsjH1Yt/h+tmoZsE1s4e96J6BT86A3aiTtXJUB
	sQvdpMx0BCsMD3KoKaYYZpmu2mXLMiHulEJqCjDO17DRLB++sfANQJ2teXqNGUziiQ8vyv
	ZBK4lPbSuB45nggzMD2ppLx7hNVvkX0=
Received: by mail-pg1-f172.google.com with SMTP id 41be03b00d2f7-b553412a19bso2587854a12.1
        for <linux-mm@kvack.org>; Sun, 11 Jan 2026 04:19:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768133972; x=1768738772; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=uiMvrJOYUzQmUPoXzeap6162aGuxIMcZy1UNPq2JUvY=;
        b=l6O9GJDiU8jQQlTD+2lBH1bQx3p47nrYVHjOkS9EP6XdygSbi/pb2CAo0w00DdpzLr
         rY5obkP3GQvXRsVIRrWa1ye3wCZPejSJW8SyFrJdrmwrBAuadloPFuwngZmxJ6XMAUr4
         ebAtNzzcXio3y9+RTPHdhJZHMfOGoOwyorn0NRBakSuYbPG2pCb/786RdpNAuhHbyQLf
         +RmrUBQH/I+yJr/J1WgmQDtm6M3Tyi8+/h7hyTQQwcaXJCyyRNFStcCJ72vk+2Z78ZeZ
         QVE6i5m+piwwjjXokK31Eoa8/hJNQ+OZPMgaotZdJ4MEeOVgaqNItGWDMraN5Rq/a57w
         jLtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768133972; x=1768738772;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uiMvrJOYUzQmUPoXzeap6162aGuxIMcZy1UNPq2JUvY=;
        b=upUKhy0FzApRVeB8z1xu1mbcrOyffp+P0xoS02g3GZF9A9x/xTdyJp9iNIrX01CUeh
         Fp80KLmRN1q8cG6T536bu9RpNk3ReCjRCoJh9NdBhIbiuQKfW2Oa0JbN2eFB0DNpc9T0
         z+rxDw4J7eqISA/LrMhjLt+/lSWbo9yHrt76aEmfnwAiYb7Z+xDIj6n83HO7gKmDV9oP
         w8YZObU4JGY5vueDUsp1YhvmyXWBGRCyKvV1Eii5KSPk/2hyUGqON+9qPNMpibrQrBOs
         qxn01KishTlknsDwzgtoskh/98rG7/CcGbH/uQf5oToKMVYRJEtIzyCzN/FPKxJqt3w/
         KSDQ==
X-Forwarded-Encrypted: i=1; AJvYcCUHgTVzsPoLy/naJRHmERODGauYKWjPb124TiOgZtiplDlCHPmVSONi/IKsWO+BU5VVzozu/4M/NQ==@kvack.org
X-Gm-Message-State: AOJu0Yy+B+q1ayjZyFagni+Mc5m6EnQY1o+KwRM2OodYkhU1VhA92K9V
	m+/yzIp+lBT8ooWQO3lXPVG5uXBsaxsCU6d7KOuiNXlfMdJI0DbxaWvs
X-Gm-Gg: AY/fxX5d3PWNiSVcJItCjYZP/dxax/NKX6wR+kVCbqI39LN9UOMUr3wSJeSDZzcHdGS
	NnPLuJFGmJcIC9gVzRJKPCo/NEtlJulUGS0V17+r/9OuX9gJcWvig/70HhSERkWM+atv++fl5qU
	hrUHVjpo8fn8am6xXzQffWgA6OIV3t1tPDwmfa9CXWJW/zXQp2LPUUs5fTThxpwX79zw6yPKpMf
	2PpOngpuKAeViKuj1c93hv1/f5bceuVAeavRxk2I7Swjg6b5p7UnsJdQCTFgbyMYTSEyh8BedLr
	MBUhyMArNAV9WtpMLFZ352CcDvZ6hYaCiLXcFfU/cIo6zCLh48Je+z5HPy17wf/48YKt1AsqVRV
	0LV5a8JqAVzz0Ctg4yuH+ZsWcGgyZoF0Mm6W/yLOXcSorFwWx62I2/rxlJyMDBFKAY4uHBIdaT1
	aA9wKcmlMJDJbXDfcgvkU559sw19Bs+g==
X-Google-Smtp-Source: AGHT+IFKhcW8u8+6pQwDTOjpNR2DjgEpyg2z/PddZO02md7o9wHGUR6NzM7fqE//O0DgyETuiIfJIQ==
X-Received: by 2002:a17:90b:5746:b0:349:8116:a2d8 with SMTP id 98e67ed59e1d1-34f68c02457mr15089092a91.7.1768133971673;
        Sun, 11 Jan 2026 04:19:31 -0800 (PST)
Received: from localhost.localdomain ([221.227.246.159])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-34f6b07029fsm4877954a91.2.2026.01.11.04.19.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 11 Jan 2026 04:19:31 -0800 (PST)
From: Vernon Yang <vernon2gm@gmail.com>
X-Google-Original-From: Vernon Yang <yanglincheng@kylinos.cn>
To: akpm@linux-foundation.org,
	david@kernel.org
Cc: lorenzo.stoakes@oracle.com,
	ziy@nvidia.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Vernon Yang <yanglincheng@kylinos.cn>
Subject: [PATCH mm-new v4 0/6] Improve khugepaged scan logic
Date: Sun, 11 Jan 2026 20:19:03 +0800
Message-ID: <20260111121909.8410-1-yanglincheng@kylinos.cn>
X-Mailer: git-send-email 2.51.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 0E05280006
X-Stat-Signature: o15n6npixtpqabt9p1onnhig3ngjwpxq
X-HE-Tag: 1768133972-979605
X-HE-Meta: U2FsdGVkX18iUJHDjfKqz6zFBtd8Jxe4zT0qwEJqr0G4K1Xubc3+y8LM7f2YOLg9fdlDBGHD7WwyipSTv14yiiqmTgaQOsmT2jt+WsVjBog3r8wkWwzCX6aXQdTpO0BJHuhTlNX+sUmphOhkiZwogkqWKJRH1xRt3h+bkKDrnaeooS+2SdBQvFN0l50kwx9NH83J9O0ujhIggt18BHoQiP5+08t1b2zusKXKIiOaDJjHGoEAL+XA+o2sZDKkZ01wvshACJytiNRaTLnV/H6EVJg53T1D3VVo+uXnDgf1gzkI/0AUCk1U8IL5Poarr3eNDNUv0uFyCZRXlC0hoPct5rKYdektLB5jsKOXSsvClNSzd2ITyLg8o5p2NekuE/6sRLspYBqlxTvlwU1oZiRqZ6TuQBzalg0ULyJR4RHiWgte1ckrEr8auQLLaNfhAL9W61mf9Dz3UsVioIdOAaPG3ciG2qtq8x5/60yrOD68ET38l6iG0A7iKAfy8Itdv3eP7sye1icDTYfaHrn0CzgLzMPXaxn+gNaHu0N7XXkFGcnv86TS/twdPTjovPaSQCGGzgNW8qb7TK6yOlQfcw9ZV6Hh0w+0pMFcyElYomqiRGYRuRu3UVrNodMhiQX4vADhkHgSRDNGGZOdcHLriXUn3sXWKw47qMgST3D5HnyyyFFO4YFa8qTo3G10+SzvQSjRuqXDR3SdV1aBeV/67Iy4EkzBS+HeOTn9z+/OEQ4gmpAT1iVV5lRlq00OD2axL3Xro+yKxy85ZFJtgirJXllcIaz2aoPspMUDFG4gy2f96HqZzeoQv9bEbLzfvwQxCBbmejegKuP0I8waseyHnPzaSGBZqWZZzy/cqXoSqa7TdpA0tzNTuzduDfKvNKHkDAgfvPM8oB4SGOPkxjA2DaW0HDhsThKpVMN27JIl8diiEbB+8aebddoLSJQieZqdYmmvBLbvZc4k2Bd89N7U00r
 bX08fS6E
 8/JjQQ2Qtft2pZTo=
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
MADV_FREE that these folios will be freed, just skip it only.

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
briefly andthen call madvise(MADV_FREE). Here are the performance test
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

This series is based on mm-new.

Thank you very much for your comments and discussions.


V3 -> V4:
- Rebase on mm-new.
- Make Patch #2 cleaner
- Fix the lazyfree folio continue to be collapsed when skipped ahead.

V2 -> V3:
- Refine scan progress number, add folio_is_lazyfree helper
- Fix warnings at SCAN_PTE_MAPPED_HUGEPAGE.
- For MADV_FREE, we will skip the lazy-free folios instead.
- For MADV_COLD, remove it.
- Used hpage_collapse_test_exit_or_disable() instead of vma = NULL.
- pickup Reviewed-by.

V1 -> V2:
- Rename full to full_scan_finished, pickup Acked-by.
- Just skip SCAN_PMD_MAPPED/NO_PTE_TABLE memory, not remove mm.
- Set VM_NOHUGEPAGE flag when MADV_COLD/MADV_FREE to just skip, not move mm.
- Again test performance at the v6.19-rc2.

V3 : https://lore.kernel.org/linux-mm/20260104054112.4541-1-yanglincheng@kylinos.cn
V2 : https://lore.kernel.org/linux-mm/20251229055151.54887-1-yanglincheng@kylinos.cn
V1 : https://lore.kernel.org/linux-mm/20251215090419.174418-1-yanglincheng@kylinos.cn

[1] https://github.com/vernon2gh/app_and_module/blob/main/khugepaged/khugepaged_mm.bt
[2] https://github.com/vernon2gh/app_and_module/blob/main/khugepaged/app.c

Vernon Yang (6):
  mm: khugepaged: add trace_mm_khugepaged_scan event
  mm: khugepaged: refine scan progress number
  mm: khugepaged: just skip when the memory has been collapsed
  mm: add folio_is_lazyfree helper
  mm: khugepaged: skip lazy-free folios at scanning
  mm: khugepaged: set to next mm direct when mm has
    MMF_DISABLE_THP_COMPLETELY

 include/linux/mm_inline.h          |  5 +++
 include/trace/events/huge_memory.h | 25 +++++++++++++
 mm/khugepaged.c                    | 56 +++++++++++++++++++++++++-----
 mm/rmap.c                          |  2 +-
 mm/vmscan.c                        |  5 ++-
 5 files changed, 81 insertions(+), 12 deletions(-)

--
2.51.0


