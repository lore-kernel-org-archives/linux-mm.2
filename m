Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 788C0E7C71B
	for <linux-mm@archiver.kernel.org>; Sun,  1 Feb 2026 12:26:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 19FCF6B0005; Sun,  1 Feb 2026 07:26:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1808F6B0089; Sun,  1 Feb 2026 07:26:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 07FC96B008A; Sun,  1 Feb 2026 07:26:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E99856B0005
	for <linux-mm@kvack.org>; Sun,  1 Feb 2026 07:26:43 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 826AE1A0914
	for <linux-mm@kvack.org>; Sun,  1 Feb 2026 12:26:43 +0000 (UTC)
X-FDA: 84395811486.28.9484CA9
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	by imf10.hostedemail.com (Postfix) with ESMTP id B63DFC0009
	for <linux-mm@kvack.org>; Sun,  1 Feb 2026 12:26:41 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=njYGLIOo;
	spf=pass (imf10.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.214.176 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769948801;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=ZOp1GFQHyzeEszgnaKmemF0L8YwiMTjqGQb7miA/TDA=;
	b=C0OoymFybv//JNO7mAEC5ymhZv0l/vpkGEcqZJnANQ7BlIWxKEASxsPRTPEaSmHlAKmr8z
	vWyVjzCjyd6+u0jCo99yzWh5NS0Y67i/LuC+BwQG/HYGYkLy/Mh5rE6iwN0gFqjXDC/NEW
	3FY2t42p/nxZ87m56SmBBX60Jp0MpYw=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=njYGLIOo;
	spf=pass (imf10.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.214.176 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769948801; a=rsa-sha256;
	cv=none;
	b=kJkHLYE0tAXzJMYMFsKOoPceOYZOyO2N/ji4/A7leC254xw5h5WvDBiwc3EbdLnVml+ott
	7lv6lj4g4pcLqzqDKLgoNcjM/ecsx0xb9+wpb2XaN0B3BeEjRrwvV7E074bkAAKnyLrPUq
	pPak6ZJluMwiDPQoXgrx8wiIIedWTug=
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-2a8ff2ca490so2862215ad.2
        for <linux-mm@kvack.org>; Sun, 01 Feb 2026 04:26:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769948800; x=1770553600; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=ZOp1GFQHyzeEszgnaKmemF0L8YwiMTjqGQb7miA/TDA=;
        b=njYGLIOo3dO6OvuOUKuwQAaEJ4SDl5k7c1AEelhSjodwpwoEq9uOKde8dZ1R5kUVHD
         nl+kBs2oZlHtXpWpb7h3gFO/MdXSkzjZ9OhJS8k8zM1jzqEzvGTOskfRuYdivkcAfN+I
         QtcobRJF5PXJQVeZ32NwxbIkwB71Mnmm+UVjEh/K7eo6vVzirqxOukTTztDGjTDWaJfi
         yv82aHY8/8HuO+NmZktQY/wAR7tAogjQpmaIlj7EgQfv3chZDGoHzXD2Rv0exGk4JEC9
         uwAS9VaC3WGTq1Os2psu0d1CnT95J0WxW18H2sk77XOXNyOlfWz8pco0Cao9JJQnyVdg
         Qahg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769948800; x=1770553600;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZOp1GFQHyzeEszgnaKmemF0L8YwiMTjqGQb7miA/TDA=;
        b=cWvNWAZvYZn1aKTRQR9p7ecIeLpmVR07Z7V8phtm/8a/owsQudwZ4ajwKJOa0aAfJx
         vcX9+qyCxnUSt3VygBx4HVxSEKhuCD1vvVmjMhluObxkacm6Kb92dYj/A5m+NURoYTjE
         OWRnHqX4PlL0RbA3FbkO8Mqo+TAFhA/onT6niEp6wEVficHs5+sln99NdlisOiB2clpK
         cXYpJ9CDFE6FY8rmRkSh8hTUrQDYsdKiYEsWLy3rejAgYmGvtAaq1wTLWGR87vtqsr31
         52O6d/XvWeWPxvmpLZCrERLY/jDOVvecntWYlDSVoW4KmOISQUc9lzYO6STlpVHBRA/j
         k7tw==
X-Forwarded-Encrypted: i=1; AJvYcCVsYo86ysaXAKXGAKMfdrjuN+4wJA+LSloagjEsBpTYBNdiYM8tqCNw3VZIRTcSC+hn0Q9W5boMag==@kvack.org
X-Gm-Message-State: AOJu0YzfDVUQtUt22x0MheByBOiqJJLH2LfTpk+irV5pbWgsDhElnAmr
	t28SNs8Uv5EhT60uc6OmPR8Rce6XAawKALVTDIgXyIUCCMcXQsEuJA58
X-Gm-Gg: AZuq6aLt63RU/FAOdRdxljTkVDs44AElIauvqG0Bduzr4LgFYEeOWZdbfcoyUy9+StO
	I6ub3h0dFSdkwWiva3cGzYXt7DOkR/1Oq46urksjhlYT2LAYT8LuZiLKvWmsJcY68HSSH0b+l9S
	g8ZgxoJ5zpycpyNK/qMoRnvWuFp9XI2Lg5kS9Ptq/15b9WJWyWaGg5b678xizrwamD80GYxhdMl
	980hAYfNBplB63c2nvxBZ3gVZXRVF3XrKL+7Ji2O2J8DrqfbIUGR9lJD48PY/ZrHg/c7xcGKGCA
	xyA7qvaZ5umovMBdXb+5mBIALGFv/vb6hThjzYffkIev9/FGecyOwmrn4BMFC3GCfdJxpoQV5To
	nmSZ84XnLD55WC9HA5RdJOSTZ3lYxMfoOhYkC9yiwKuFOFxs+iUyMUmiw06EqHdOnxphCVqjFwh
	znVlT6+xWRhCfDgG1226fz8FuG
X-Received: by 2002:a17:903:2b04:b0:2a1:2ebc:e633 with SMTP id d9443c01a7336-2a8d7eb53ecmr81513165ad.4.1769948800330;
        Sun, 01 Feb 2026 04:26:40 -0800 (PST)
Received: from localhost.localdomain ([114.231.118.96])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a88b6e5ac4sm116941185ad.86.2026.02.01.04.26.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 Feb 2026 04:26:39 -0800 (PST)
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
Subject: [PATCH mm-new v6 0/5] Improve khugepaged scan logic
Date: Sun,  1 Feb 2026 20:25:49 +0800
Message-ID: <20260201122554.1470071-1-vernon2gm@gmail.com>
X-Mailer: git-send-email 2.51.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: u1iamat8fq41nqwk3465nrrq5bofia1c
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: B63DFC0009
X-HE-Tag: 1769948801-754997
X-HE-Meta: U2FsdGVkX18AWRxeJQowxh9n99wIqaGGFzueuYzXaI5SRhQ+uwmqugMyp7dPM/UZSW8mPNZHET7bQ7WWNFRDBO2m8KXEWeYoo83fFYcjhfPF/kR1Em/2SuHN5Fztkzj1s9CHVaGauRh/HDwEeAPmDkbeg8g3xJ3sHBhD7tiZIHqFrMXgqONM2Qxbfegtv75QN8rdsWk3c1oeTyZoS+NnZDtykA2kHBO1BE63THB4R7/TJlcvP3hJhj07D5lyMOch0uOxcVaXozTAX0wf2RH2UFdlaTPybqzdiQW73QwEIRHmJ0hsJxga6mBtA120keQQdAsgsrZnDhgv0BvxpLHAxYhH3vxGGigwDiiZGtBh3MFymXDH2W8FXMWGd9bICfxECmilWIqzf3F3b7C/BAa02dN9n5Y/T016QiyI05UJQPWZ51H7oyWgizHVK8TMUk4t3C6ZXqqbZRB11KeCsG5au+eINJ1Bkfj462kHB+GqQS2eNtaXHcJxd8Oia5EUDzYEvJLyPw0BBh6DisJ+gJTcD9SvWywA10GBJfI2uGO6t0KJa4InCrjXFAKOescCpn1Q0c81b/NpA81TFAOi5uBdmtnKjvykpFUeY5+QxHszLsFaD1ZR+obdLE70bEe4tKU7ykWRSfi5zTi2gB00NBrJs5uH182uqvtUx9rC6AyTLUSVh6ghH9+A+1oa24a2fpazMGN9BSx6AXtlR0LqYpza+s0YDZkRv8ci6RJt0GskzEmXO/e6ODbQBjVcyVDQAkJ7S5ojtiL1/2+OIOJMWvwenbXYEHN5dhEIW9LJhE6mAAy7KV4fR7KAaY1nATUH8lIRFac4TDxjkOf7NyORXEBdXy/DyO9kwPtPO6Q2cOGd87snqYJ/Hvc9jSP2ldImYcfVy2tI+5lWEagcZc8tH1YlO8fIJXijYb7e6vhnORswzXg2oQte8CvsleQzA3j9se+cPJhlgaPK0d8aQthHPWP
 sOlRG+Kd
 saCFCCVzS8qwDh0h7WnJhLSbKbBXfxttLhd263tnYrWLN8Lws7Ly0LO0THI85wrVEDhbOXW8I9YhGJkXS+xO6DH/qIwSinWEFZ1ROfu7Z/CgxktaDvSnobFQQ0QW++NOF1NelDhpv+S6cN8Kpf959Cnb8CbpHNolVcj8sPt/GQDiEUgCoWjhHx+d0lLFGJrspJHEI9eo803S3itwDdOH4WrZ+CleKFZ1dZkqI2hBF0SJ5b3s7CXss9V1bD6aPoNsHhJhBhCzShfeYWbeuYE2DzH2porPfo4arkHkapk+22NJ3ZsmcwE+7F3QCN6ca/pSu8b23++uPzUidscg68MvgjSy8NXdH/uPyz6dnJVtHI+Ivq5FcgN7nsMwxcEclNjFYh6WG7G12CvKVwzjQvUbSlADOLq3V2qBGLkeZACbG0UDn2RF+a7rQPODWNV5wa21QVQY35nPc4H2Gw0wcfPdi5BKlJgQ3gB2CfUsTVCQehfkh/TDbYCH3bLCQ6aKR0see8YqZsOK3mP6KO3jRZsbeuwj9L9s5f/3UT4dKF+OT2MHSl51KHyRFtBQPtWLskrNJXJCG/SWO1keku29OUT9Nn4jh3V+MvDcFyPMmB/ry/ajHsyl9Sfnyjww3i5H+vglB+mrI9jY75575ND4=
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


V5 -> V6:
- Simplify hpage_collapse_scan_file() [3] and hpage_collapse_scan_pmd().
- Skip lazy-free folios in the khugepaged only [4].
- pickup Reviewed-by.

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

V5 : https://lore.kernel.org/linux-mm/20260123082232.16413-1-vernon2gm@gmail.com
V4 : https://lore.kernel.org/linux-mm/20260111121909.8410-1-yanglincheng@kylinos.cn
V3 : https://lore.kernel.org/linux-mm/20260104054112.4541-1-yanglincheng@kylinos.cn
V2 : https://lore.kernel.org/linux-mm/20251229055151.54887-1-yanglincheng@kylinos.cn
V1 : https://lore.kernel.org/linux-mm/20251215090419.174418-1-yanglincheng@kylinos.cn

[1] https://github.com/vernon2gh/app_and_module/blob/main/khugepaged/khugepaged_mm.bt
[2] https://github.com/vernon2gh/app_and_module/blob/main/khugepaged/app.c
[3] https://lore.kernel.org/linux-mm/4c35391e-a944-4e62-9103-4a1c4961f62a@arm.com
[4] https://lore.kernel.org/linux-mm/CACZaFFNY8+UKLzBGnmB3ij9amzBdKJgytcSNtA8fLCake8Ua=A@mail.gmail.com

Vernon Yang (5):
  mm: khugepaged: add trace_mm_khugepaged_scan event
  mm: khugepaged: refine scan progress number
  mm: add folio_test_lazyfree helper
  mm: khugepaged: skip lazy-free folios
  mm: khugepaged: set to next mm direct when mm has
    MMF_DISABLE_THP_COMPLETELY

 include/linux/page-flags.h         |  5 +++
 include/trace/events/huge_memory.h | 26 +++++++++++++
 mm/khugepaged.c                    | 60 ++++++++++++++++++++++++------
 mm/rmap.c                          |  2 +-
 mm/vmscan.c                        |  5 +--
 5 files changed, 82 insertions(+), 16 deletions(-)

--
2.51.0


