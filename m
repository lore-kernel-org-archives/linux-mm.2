Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3E5CED7234A
	for <linux-mm@archiver.kernel.org>; Fri, 23 Jan 2026 08:23:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 197786B0439; Fri, 23 Jan 2026 03:23:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 145366B043A; Fri, 23 Jan 2026 03:23:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 06E866B043B; Fri, 23 Jan 2026 03:23:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E9DFC6B0439
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 03:23:00 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 89B7113A259
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 08:23:00 +0000 (UTC)
X-FDA: 84362538120.15.E3FDD7C
Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	by imf15.hostedemail.com (Postfix) with ESMTP id CE7B9A0006
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 08:22:58 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=krQ89JB8;
	spf=pass (imf15.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.210.171 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769156578;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=9IUJFlA7XSFnWdLZVGcPsTawS/pp01Gi6bNp5Y5CBw4=;
	b=cJ8oUnv9U1Ly1sNSO9fOo74P2ZVY171bPDDtMiCvAmvG4tp6K6gcH+jEZIZeL4Djbj/VYY
	FD9RqlR/gGPGNOmgMX87LCMsU3iMARaA5oW962TmSsd1CI2wZbZ5YaeLYcQdExD3wRlTFO
	8tgMcNBmELjb8lZa5U9/YQ3o4M1nBmY=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=krQ89JB8;
	spf=pass (imf15.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.210.171 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769156578; a=rsa-sha256;
	cv=none;
	b=3FUHzp+mrdcWitHOSTol+UWEmj8AinU/sXqZ1y6G7H+7aifmiUiI6OSvn4v3zR7Y5Bfj/0
	eLARGMYzJYC2wfbdRY23ySgFrJFig0YmOy1GMOOTe7dfu1S9b9gmSadSqR4sjV9+578EXb
	888szVrv3V+mYco59Ben/Fk/pZehgeE=
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-7f89d0b37f0so1526048b3a.0
        for <linux-mm@kvack.org>; Fri, 23 Jan 2026 00:22:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769156578; x=1769761378; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=9IUJFlA7XSFnWdLZVGcPsTawS/pp01Gi6bNp5Y5CBw4=;
        b=krQ89JB8ZJ3m4y9QbWcD9XJtQJq9ngy0rNMhNQmmLBUGFAtsboGR0mCvCY7650L7xl
         aBgJdwicWzxzhNjBFYLsRqmk/eGYXKIjpWe05M++4vL3uza6SJ/CQnGIuGeo4FlSctaX
         BVsUO8h9OTI7hEe1mRcaZ7DNVPsMk1qRbF3n7gFXnqaEfflxnjWs6gPTMtOEBeSRW91K
         LkhSenkZ0LLN4Wm0YeLHP8wCAYwcRzEyEjwMv/QG2Do+oHTcEAIU+WD1aHVS9zRDtU7s
         o6uLy2hzzMm4gVvZGsKUuAy4j4aXBhjtXgdOPKJpl1aDw44B3Z3cG9bYrHrrewA9UJCA
         Pixw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769156578; x=1769761378;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9IUJFlA7XSFnWdLZVGcPsTawS/pp01Gi6bNp5Y5CBw4=;
        b=gLTqEZFYkq+dq06t0iLhuNbG0ZWG9YBJOmQicKd+mQqVlD/CqLYc5TvaqRlyJ4HU/P
         BSWZXuRqlIaKdAVpK85IBdnIe9TbJNNxT0HqVGQQHSpXMdaHHGSAT7pZyzbYZIuaHd60
         E2uuwPzj5ewW+lIX9opN76HoKb44CXV6NyTLPEMS7tFmc9ss71vY2dzI5KH596k2p3DE
         x3r55YLd7D2smlqHzjdWRSO+0SYNHPCSUwShQBHAxVJOzn8RU2zg/cmm5Gg9aPRBtOCw
         6iCVjbIp+k6hOaMkFQjlVO7PhYQAnIbenTKQn9BdLfNHbvgGUCXM6gA5sEwEco3Ei4Di
         Rgbg==
X-Forwarded-Encrypted: i=1; AJvYcCWkWNLkutW8t88X8SNQcvet2q3DzJDwG5kcsjimhu6LzXCAmlYMp0pieyLQCdH/69z3xzc6X8vMXw==@kvack.org
X-Gm-Message-State: AOJu0YzhqttXMVzU/YzCGI3xBaFQJ+MS0Rl8uK9KgQv3B/ssQ6pDZTHl
	WzOpQOzbaFZpvy4Tq23Ot0MlFCcKX9nTej7wSJsgT57Z7XGJC+BHUITT
X-Gm-Gg: AZuq6aJSKh20bg/B142/SXbYCcUgFqY8NOkgruEyrTbogAo7HD7DydrGDoFNd+PD5Nj
	lXnLzkHoXKacD4PeW+1zM83ok+Z6dUEBGORdH5UB32nOJb2j27QaQ8lYyPV9zzuhYHT2imeJZwK
	7nHGUJK9cLuP92bzekLXKXjPhY+tXO/br5V5ijNVNBLK2ays9ekdNfKhQS4XQFVCVPZx/7NM6G0
	FP2Vh09ZWv5AQpDQNZtcO6LTMW11w2+R8m/QDqzSVj122eTcZblZlLc/CbAYLajhHNB4mlxH1f7
	aHmMCW7ds3O5yGP1yxh/T518847jkgJi+96TXmLKAPFenN0GVqh9COBI6BumH2Pdq3JsjOF6vVt
	QRlhBGW3cuWUn4/LhRTDUoanrcY3PSyvqz2aA35bEZYolBhpvNf8uCco/ib93g7gietzg8DYYsp
	fKoOlcM38hwZDX3joZtd8C8PXA
X-Received: by 2002:a05:6a21:6d86:b0:35f:31bb:5a5d with SMTP id adf61e73a8af0-38e6ff9573amr2198598637.2.1769156577492;
        Fri, 23 Jan 2026 00:22:57 -0800 (PST)
Received: from localhost.localdomain ([221.227.246.159])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c635a43f11csm1348363a12.35.2026.01.23.00.22.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Jan 2026 00:22:56 -0800 (PST)
From: Vernon Yang <vernon2gm@gmail.com>
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
Subject: [PATCH mm-new v5 0/5] Improve khugepaged scan logic
Date: Fri, 23 Jan 2026 16:22:27 +0800
Message-ID: <20260123082232.16413-1-vernon2gm@gmail.com>
X-Mailer: git-send-email 2.51.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: CE7B9A0006
X-Rspamd-Server: rspam07
X-Stat-Signature: e33n3ncqchas1mwuh1rxfa9cgtrxz9af
X-HE-Tag: 1769156578-512885
X-HE-Meta: U2FsdGVkX1/A9u5B2XsWpYGseq55vhG6DVg6Nd/ncwnhUcNb443GHaJDS0Bhd8i1MKVyv6wQ5wdvgTo+t6opTGiH35jL4hvjHpBkTKk13vajHpmRQG/Pfzao2il1n+EjDjnp4sezIWINv+zS+TBYsDZFVMUbGWzPLkz66Gh2FEdCcRYDV7qvtXpzgOhO0+x4z6hdq7FGh/vcpkVgHYw9owW5xm6ODg+0X13aBbvA7/0psN+ici05CxQyZWBbgBOaUx18dRyjI9Kn9mKh1xhnqMIonbUf2MVFZDws5zSKQwXneJbY6hud7hskMjSf/mO9JLwXmoc8ajIhGPtu9kIz8shSJMEH+fipdatVe94if1QSgnyq3F8HxMoV+ws5DePczvBC9/eG+Ypzdoad3K0w63ivuwtNmXf2wekhNJ2X2Pl6mODbPrcae+Br1FtBr8FHOQTcDQkqScvAmmxTjfPx1ayRJFngQt0KRnhqbFdwaIuVFKVkzfmvfWD8ocQaokHGvVBuZzpG1Nju+LfQuiTTvG/3XLclFqDvCLaunUyv4H7R/Bo5yPwg+ArouIOECYtceBU5D5lww7XUUMksfJcQSZ7zmLqJ8hRvBNcwtwtyCqfKYk8WmVtAl3s4xrhVbDgvRf21l17YKUi5QdRzXy+rXTXBs21ppyHeYp5e5jPZuq+9+vRr4xU3rAu/EN2Plf33xsQ0zfHteHzVoOqO5Fz13oodjB5d0D2gmt00TKPeb2SVvXzq6/odtMSk9j5bFEuvGWNJdN5Bi/Cch3vnBufW6hV4GZXX4uvmoMdaj50Tif+HIcFQL6MLMxUg2j4dV0jAPMW3WrlxaSLw037nfIHB6m26IqdoX9K1DXEANLlnoT+jcJ7CgHHZVaGNTAzO3q4BEKnVhkwuCYGZDZ+7O/Bxx7MUZOrnApz2oMX5cp2Y63VjtS5o+GWnKq84BfCEr0d68IW9KcYdgYenfeM6a3s
 Kdtb6eWn
 iLpcRnG5rPGR7zkvwKwrdKV5+mkltlUBu60FyVu7eRyEUMh7HFFybByPpIAcECBdNOuc+0U0Bvy/6xwa9W48A2yRY8N71+ZJF4iT1Co5WY120DkdiAqjpE7E1jvNvbO1FPuCtgHNoywhY8t1pwJcO5lK2QHZ7IXM5V3AwZXOmj2yV2nvISbTGX1H43bc64GL+NkGvOOVAjweSIy8B48tXSTIu8kaAUN0cTcMUFS3Cz9TcmSC2Qo19A1ZXU6QOrm/qA36pN91/Y13EWx42wMP415IkSgqrkOnwCuaWvYw4PLPQyA5+L1S4gWI22VtW6YEczUo/EuUxJPTjZyHsHR+qGddMFd4N8XUicP0Fu8/vIU77HhCAprCqGag46bbR5eEA61BlJGXaQmW9D1WkXx7w7AUro7lDMBHi7fRNYoX7OtNK0WzIh/b9ImKibQRM6WONjOOBWHoFSIsY4OpKv+HOvc0Vlgi+88mXnICu
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Vernon Yang <yanglincheng@kylinos.cn>

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
Amean     user-32    18522.51 (   0.00%)    18333.64 *   1.02%*
Amean     syst-32     1137.96 (   0.00%)     1113.79 *   2.12%*
Amean     elsp-32      666.04 (   0.00%)      659.44 *   0.99%*
BAmean-95 user-32    18520.01 (   0.00%)    18323.57 (   1.06%)
BAmean-95 syst-32     1137.68 (   0.00%)     1110.50 (   2.39%)
BAmean-95 elsp-32      665.92 (   0.00%)      659.06 (   1.03%)
BAmean-99 user-32    18520.01 (   0.00%)    18323.57 (   1.06%)
BAmean-99 syst-32     1137.68 (   0.00%)     1110.50 (   2.39%)
BAmean-99 elsp-32      665.92 (   0.00%)      659.06 (   1.03%)

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


V4 -> V5:
- Patch #3 are squashed to Patch #2
- File patch utilize "xas->xa_index" to fix issue.
- folio_is_lazyfree() to folio_test_lazyfree()
- Just skip lazyfree folio simply.
- Again test kernbench in the performance mode to improve stability.
- pickup Acked-by and Reviewed-by.

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

V4 : https://lore.kernel.org/linux-mm/20260111121909.8410-1-yanglincheng@kylinos.cn
V3 : https://lore.kernel.org/linux-mm/20260104054112.4541-1-yanglincheng@kylinos.cn
V2 : https://lore.kernel.org/linux-mm/20251229055151.54887-1-yanglincheng@kylinos.cn
V1 : https://lore.kernel.org/linux-mm/20251215090419.174418-1-yanglincheng@kylinos.cn

[1] https://github.com/vernon2gh/app_and_module/blob/main/khugepaged/khugepaged_mm.bt
[2] https://github.com/vernon2gh/app_and_module/blob/main/khugepaged/app.c

Vernon Yang (5):
  mm: khugepaged: add trace_mm_khugepaged_scan event
  mm: khugepaged: refine scan progress number
  mm: add folio_test_lazyfree helper
  mm: khugepaged: skip lazy-free folios
  mm: khugepaged: set to next mm direct when mm has
    MMF_DISABLE_THP_COMPLETELY

 include/linux/page-flags.h         |  5 +++
 include/linux/xarray.h             |  9 +++++
 include/trace/events/huge_memory.h | 26 +++++++++++++
 mm/khugepaged.c                    | 62 +++++++++++++++++++++++++-----
 mm/rmap.c                          |  2 +-
 mm/vmscan.c                        |  5 +--
 6 files changed, 95 insertions(+), 14 deletions(-)

--
2.51.0


