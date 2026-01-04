Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4CA47C2A06C
	for <linux-mm@archiver.kernel.org>; Sun,  4 Jan 2026 05:41:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0AC236B0092; Sun,  4 Jan 2026 00:41:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 05A106B0093; Sun,  4 Jan 2026 00:41:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E7E466B0095; Sun,  4 Jan 2026 00:41:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id D73C46B0092
	for <linux-mm@kvack.org>; Sun,  4 Jan 2026 00:41:30 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3E7348B098
	for <linux-mm@kvack.org>; Sun,  4 Jan 2026 05:41:30 +0000 (UTC)
X-FDA: 84293183940.21.DE7EDE4
Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	by imf04.hostedemail.com (Postfix) with ESMTP id 5CA5E4000E
	for <linux-mm@kvack.org>; Sun,  4 Jan 2026 05:41:28 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=lHCxTSuN;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf04.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.210.171 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767505288; a=rsa-sha256;
	cv=none;
	b=aBZZFIasTeLwiki0LtgRJ2g/nZwzssG/Cdlic9AbJ5pZrdQbaH+74mfnhcRmKg9cVQzYBh
	Cfqq/dF7ldjL9+xRY4AL9wqcN7CchrNkgxr5yBYPAQmeJr9HMsT8KqLtIUwT7MXyJwH/NU
	0KoXgxL3dqeCxqEK6oYJ92y74O8hsfU=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=lHCxTSuN;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf04.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.210.171 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767505288;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=L+kiv/8SILETCkwFrxgRITVEGgT0GejFYqT2B99DKFw=;
	b=D/TT1owsJjWPGUByXYxkmm7wR/FHQ+cjs1FDbiAPqzx9hc/33RNCoq6SXuL7xh6SYC6nK1
	9woktuoXas80jJIyZFq9Ecn+ae9Wj57GE3z5IGDQR1FHEKD+d2qkObp09nBqYJycIboeMM
	diHkMPGFLY49LHRpB8Nii3zvyUCDYjk=
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-7aae5f2633dso13620860b3a.3
        for <linux-mm@kvack.org>; Sat, 03 Jan 2026 21:41:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1767505287; x=1768110087; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=L+kiv/8SILETCkwFrxgRITVEGgT0GejFYqT2B99DKFw=;
        b=lHCxTSuNKdHKTL49Y5pQE55AYxu7gbWebgK7X3zjkX2acd+kZOz1vQD/zoCtz4IszU
         /1rM05LBzF+QwJa7vc3BXs519zbPf45I75CyGEsxrMohVtWM8yIH/EX6kc/yWQYKL3Zs
         Kw94yxJQ2XvRQy3ovAGvMYpLdl4b5LHRzw8NiSyxK7MTgEnyX1FjhJj0pQZMvTc/k3NA
         ZBird7L4ajYfMf03KBYYk9g5CVugGh2TACSWD05Fj8cRVhReTrcgm1Dp5+g4e/ujhcZj
         pAcQhlJ8ZdwEkX9WNETOGiT/+LEkoxslYMamm1VM1rzX7Wyoz6nVOA3WBZHonO69azwj
         WoRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767505287; x=1768110087;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=L+kiv/8SILETCkwFrxgRITVEGgT0GejFYqT2B99DKFw=;
        b=ljqGLoeYRutt2jr3egJxhR/jyg3S6TC4/4XjXplJgaNGXz34KNmbROpOS4TFo089nu
         KGpFmSFXbQ7EiWvmDJM67CNZ06XCZjhG15YyJbkxJnb3PsGXbMdzFhOHziN7jhjLHJri
         wL3Sbqrlhq/y8TdaoPm5ZaQdlAIBwgazyGrMnRUnMwkPX7eo61rZwGhv/KOYwRL3GTi7
         flLgkF+5acUKgV5C5i2Yk+PZgvQSUVVKF1tUZFfRVZMnLHCt5mfq7Avgdms4sttvMC5T
         3sD0P7rpyVStb6Cyc5SCaM7TYuAzd33LAXLJb9wCno2Nv4DEu0OBZJPD23AAEZtA5CDu
         VpuA==
X-Forwarded-Encrypted: i=1; AJvYcCUowHoDEDhXCDzp2633freXF+gr45OTaGg5g0MS686AJu8b4wfRCiyyNaUagpVrjGjjeYe87koECQ==@kvack.org
X-Gm-Message-State: AOJu0YyXKzYY9CWfslFZdJDUmQ//YMmYn7luoXATv9LbYfLufZdNAIgc
	nU9uYnu6ahAWPeFymfc4TCbXqrGI7TDFmJ4uTdyYQKfLgb2N6o5xBPs6
X-Gm-Gg: AY/fxX6C9oLty+Evgto7KLavuyl4WnlCYBGTxqvelGJQjvWOFBQLLhceWkplAz8pVYK
	oxI1YVwq26zxqGxa6Y9FVfkmxYf+1gO3WBjhhuISLnejAvdHtoOOHrF8txF+nbik6/J4iS+fimj
	JmPn7pZZimjPF9ec5y8gwyDhLxlkDPsezOiU5AYazV2hvcHRxwT43et+f4EPpxmkNcXwJH7Horz
	mw+ruhD1+d7DSrkFn9/zN/v/9jqbg7lOJBGJUE/3SL2Eaj/KV6apPkLz9/PXVaU5DmasbKj+18W
	C2bjVxPaFXTa3eFxY36cUoD7M/JhJ6fYlT/zhA8TNFiqKp0IYnZLCknoSFj1URCIyqV7thteBmh
	8Yp4DqurcbZPoD1uaMepYDjTkIV1bCNpHAU6B4Iv/ftevXzXrYkjjzvOdF92WJHh9Cu7H7mn7Un
	MbbbkwoPTQuztnIs6OoQhOoN+nUmuU
X-Google-Smtp-Source: AGHT+IHSNazXt203ZBtanUVsyfrVnyaVinElm0qffDxsDlurpazdiGN3PpxVXtFiIrT7TvMO9AkecQ==
X-Received: by 2002:a05:6a00:4396:b0:781:16de:cc1a with SMTP id d2e1a72fcca58-7ff6607b421mr35122649b3a.32.1767505287106;
        Sat, 03 Jan 2026 21:41:27 -0800 (PST)
Received: from localhost.localdomain ([121.232.80.251])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7ff7b31c479sm44378305b3a.24.2026.01.03.21.41.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 03 Jan 2026 21:41:26 -0800 (PST)
From: Vernon Yang <vernon2gm@gmail.com>
X-Google-Original-From: Vernon Yang <yanglincheng@kylinos.cn>
To: akpm@linux-foundation.org,
	david@kernel.org
Cc: lorenzo.stoakes@oracle.com,
	ziy@nvidia.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	richard.weiyang@gmail.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Vernon Yang <yanglincheng@kylinos.cn>
Subject: [PATCH v3 0/6] Improve khugepaged scan logic
Date: Sun,  4 Jan 2026 13:41:06 +0800
Message-ID: <20260104054112.4541-1-yanglincheng@kylinos.cn>
X-Mailer: git-send-email 2.51.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 5CA5E4000E
X-Stat-Signature: zebsfxfphwqmoxosdmzb9stzbpkee9g5
X-Rspam-User: 
X-HE-Tag: 1767505288-584423
X-HE-Meta: U2FsdGVkX1/wDmrDMfqYhVySRFaczpC4KNXxsiGqfyxVH3gi9LWRR8ruPHPUr0Au2S+6r5hulUuZRve7KU8Vj8yVuzTwIUHMOmQAl1UnXEfH319oTeQPp3w77ZhLExuwepVbPW8t8oMFI8EKwcYQz0H3GkwnLbkugvEzffERG+Un9EBqVxLiw9L/gOsEyZemnFFvfHiQHH60QAUominteENNTeY3oASPhojnrSG1DjE9yzjaicttsKoJQb7FGnL+DJJmI4VPtqSdZQMVxBq8tbkjljht6gDBD5pk9YQEdMFPZ0/blO5PaxoQg51sWb6F5lJ7paieXXv2YCjxxDc4GcPc+kw2kQVUw3LrOYDL34iDe5wZ66uWp2pskbj64NRht/u5VcDmxo0goJqBq0V1etkOiNfQ+F8RArAcnXmNLLLBgFlSA4M3KL41l9X9c6iOI2BFq3yoJKMU/m2lsfJqe33mFKH3v/cGKitnDKL51hm0+kRkH5p21unojqQAJwhp/M7tZxZyYlYr6lsbWTe6ew875TloASzcUaGfgaP7C/c9DNecDEcQ3c1VyU7qBCPojO/2slZJalUO1oyzkAOxxjrClbFBMxnBGgRDbZA9rHQlfgmAZjxDHZ4hNeVXALI0+rFDCklODYhqut7TmUAgwG+/ZIj2qiXl/68Wj55IIS5jbPkmHfCuUrncQz/fIIyHMzQSV6s0MP/oNIatP21Kwh9+4fMC+2NT75OXA7ro/++cNMsdxN/mKrucBL5y4ksHXEGYY+vIbGrrDOOgXh2MhpRaj2gNWwZkJ98MXK7pvuEheaaNvW6QofM+bloHFSzFXU8cLJiOW5jYktMkvjX48EAbIkcaKYoEyXs6JT+ED9x4m6bkG+8gyJL0aMPhJapacLEqmMs6DSVdILbOQKr4QVQpiI/hmXJWA8tRS4tox8aEeXEf3n7WtkGLy/nGcyhQHnV2iFlw3DqosiZ2O2X
 bHY+j150
 zOVZGIUv/3pN9a4X6+RoVMsUGfBBTzQM5IFRiDaYgAz5SuUXkzJ0HOi/umYKy2Ncbg0QuJ5RWyicW6NAAayt5A0Wg2RFG5znNg+2+AZWwddsXNv24xjpc+y7t7lLd51JOP3CVWGRFN6WeRISspALgeYsTarGVJMuELYDCG/vFwUjal+8otSvjFphmDissRe2Ww8avVTCtLuD9BDW4W9F8i4MECWo+yQdhqjpJFEBPZKZlEeAHDjTj+YgC8/ehakCZ/ZDVQ3ZLHfwENzii1YFGsNsxxYyWzw9XqdT8ZMWNCqUyqpiPjYtyTBLp0HbADeW5KPtyaeSOM2vtTQBoI7W436d3cq8R6blqmI0kXswNLLFHTokKBpYd5nuMSOkiPR3ONgnRrUbHEPHKDrS+aGlSDh9UZI7/iES0jJfbPgJZy21iRCiMjDVgG75l85wF+2+WY92RIOW+mMHK/wax26PubuOITiubSrQPIxjBaXaKON/Uu8rPYTcIvc5Vrg==
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

This series is based on Linux v6.19-rc3.

Thank you very much for your comments and discussions :)


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

V1 : https://lore.kernel.org/linux-mm/20251215090419.174418-1-yanglincheng@kylinos.cn
V2 : https://lore.kernel.org/linux-mm/20251229055151.54887-1-yanglincheng@kylinos.cn

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

 include/linux/mm_inline.h          |  5 ++++
 include/trace/events/huge_memory.h | 25 ++++++++++++++++
 mm/khugepaged.c                    | 47 +++++++++++++++++++++++-------
 mm/rmap.c                          |  4 +--
 mm/vmscan.c                        |  5 ++--
 5 files changed, 71 insertions(+), 15 deletions(-)

--
2.51.0


