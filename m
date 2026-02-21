Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A97CEC61DE0
	for <linux-mm@archiver.kernel.org>; Sat, 21 Feb 2026 09:46:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CB7106B0089; Sat, 21 Feb 2026 04:46:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C656E6B008C; Sat, 21 Feb 2026 04:46:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B67856B0092; Sat, 21 Feb 2026 04:46:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A00F56B0089
	for <linux-mm@kvack.org>; Sat, 21 Feb 2026 04:46:23 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 4AD63C1BB2
	for <linux-mm@kvack.org>; Sat, 21 Feb 2026 09:46:23 +0000 (UTC)
X-FDA: 84467983446.29.3004255
Received: from mail-dy1-f173.google.com (mail-dy1-f173.google.com [74.125.82.173])
	by imf09.hostedemail.com (Postfix) with ESMTP id 83623140008
	for <linux-mm@kvack.org>; Sat, 21 Feb 2026 09:46:21 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=XnoHUEF5;
	spf=pass (imf09.hostedemail.com: domain of vernon2gm@gmail.com designates 74.125.82.173 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771667181;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=r8HSfiLjyaGOvsXQk4UfGGYxPYIXKUkZDXPSFYlRGr0=;
	b=F1zFqZYiDz7WrGbPtAVyGAmNULFvW/KQ+cxGM8GDSXLzpVykuSvnutdZMn0dPlnRykB7Zz
	4KQ9OREIVF0TZxlB95e5MEK0B8CgbtEaUmiGTrWuNS0xflLSRQzznWlRWsE41DEHf/G2uC
	hG9fSbXqDhrpr+lLznIQ4wfCmepzg4I=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=XnoHUEF5;
	spf=pass (imf09.hostedemail.com: domain of vernon2gm@gmail.com designates 74.125.82.173 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771667181; a=rsa-sha256;
	cv=none;
	b=nKn0GqkPmiOFgSfVHXdl0W41vEoFR7hfKLDhUlR0iBG+nES22RKJ340xC14Poced332CRy
	Jcumm1eU2pbKQ4zqUef9vQSRLSqL4OxunJycboXNdTNBqjHvK53Tawb+9lpir/rYRTRIxD
	Xq5SFgdNadNbnFGNXyUls9jnzjze6w4=
Received: by mail-dy1-f173.google.com with SMTP id 5a478bee46e88-2bd8097c709so528282eec.0
        for <linux-mm@kvack.org>; Sat, 21 Feb 2026 01:46:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771667180; x=1772271980; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=r8HSfiLjyaGOvsXQk4UfGGYxPYIXKUkZDXPSFYlRGr0=;
        b=XnoHUEF5yVsu+1iMqxSNtVhNv9ms+offe7W4FLbgu9HZUtBHDuK5EHTjZ3owmCqZiU
         LTKpGt6CSOmcb/dVtbClCwP3YLpSEAvEl/dIWX7OVILWSqU+SWTDO/+JUzCAJwvAERg7
         urh6ohjgiiR5dSEJ0ySNwBIH0f0llfurqWDhO9ca8IIXMBil/dnxTw4LTB7NWZAH8jp0
         qjs4K1XknmAiSRnnHlecCRkA5fI9+Su0ewf2nupFsMrHdvy7AFXum4CHeES3uwnTvNvM
         QIjW6yuB7Gz3NF4l5lk/GL1qVci+ENNv9FL041bpeZiYnyGZAgxP3xJLYizAiDJ3tRxk
         RsGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771667180; x=1772271980;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=r8HSfiLjyaGOvsXQk4UfGGYxPYIXKUkZDXPSFYlRGr0=;
        b=Pw4pzwF+Iyoz36UKUjBOtyI1VsiJAUbDDDlReasZIlvL2fCNkrw2MziWjx462xakAH
         HKMRlsxffk4CgAxt/sZSKzhM5CVdK41fiK5345ldJjesWOq43Vx2bgQHIXSw21OuxRcl
         f4E5YE8oByYGRR2+/9rxRWdmufwsC0EGywN6fwurgX8VqvstDBN0QcpLOIvkT74dYfT+
         qom05BjEkbQKYjV3Qxq6ktmiaDkp/xflK+bv7AjQ9TyiG1WrblOIyZJdyeO6Leyzskth
         uDtnIAG7c/fJ46eyZOVXHDjSOwMD4prEPvBIKZMi0jQAvT6/SkXILMbQrrjra6FUsJWW
         pjNw==
X-Forwarded-Encrypted: i=1; AJvYcCWoqFfEjv/ipl/mn6Zk92tH8yj5c0b4cFndG8R8wZpWBfLGvbXcsLQnQwTL8IbGqDRn5kJwspiwng==@kvack.org
X-Gm-Message-State: AOJu0YwWlIg5UdOwpNNYkg4VtaVC6pPOgoiZ2u0b6uv4sLE/q1c1Yi7J
	r26wUhMzmM/M0RJtetX9JD0b7vO3RA35SJNWB2I6bExYPdTTFCGItWZ1E/MvKg==
X-Gm-Gg: AZuq6aJPRakT8UsmS7fX4jWORXktpaMf0j2JtJOtH6dGqEwixKfZBjt/pMK1A/8NSOb
	LuTiJNjnQ78HR6VYZBxZBldTA1pFLjwiS4nowV1gOuWqsf9AzeiQgKyef5FZMxCWees2IgTqdsh
	xhWhHndttLAEXT2biSSbJyd4aekJNIjYUsTFx1cneWoAZmre7VVTxbPh+EAr/YbYDFL1FiWZqIB
	8rT2x3m6Hq7eG7ZDcW7DrG9ItcPy6/eB9+RFAZwr88GKVCnVs4FcT5ABJ28A6/FYpZlOItSnwZ0
	zFOM2wCrcUw/YjBFs4qIeQ7xj8noCyvNNaiKOlwzQ/OWyLPT+Lqxh0yPbkZQFnFBdW81dDeTMKf
	0MtgFOCMVIwcAAthPdadWPjwAJkxEm43PsHRvXz5XB+hhTnx+8U8N/DRLFQT/4yoS+wut0Y0kt/
	yhYsnrcjW7xwZxY3YwJAl7IntAugzO0Or8vXQHCjCLVw6f
X-Received: by 2002:a05:6a00:2290:b0:81f:15b2:21ea with SMTP id d2e1a72fcca58-826daa310e7mr2286680b3a.42.1771666787132;
        Sat, 21 Feb 2026 01:39:47 -0800 (PST)
Received: from localhost.localdomain ([49.79.21.101])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-826dd8ba11bsm1761708b3a.50.2026.02.21.01.39.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 21 Feb 2026 01:39:46 -0800 (PST)
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
Subject: [PATCH mm-new v8 0/4] Improve khugepaged scan logic
Date: Sat, 21 Feb 2026 17:39:14 +0800
Message-ID: <20260221093918.1456187-1-vernon2gm@gmail.com>
X-Mailer: git-send-email 2.51.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 7aomx1bmpxhwoenyzp8qcs7r657gtcua
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Rspamd-Queue-Id: 83623140008
X-HE-Tag: 1771667181-860631
X-HE-Meta: U2FsdGVkX18bLlLMmse7Qz9jJ9h5zw2ecKCk4CvmviziiTL2y9OI4nocLsHNsLKEQ7zZLXNrH8TDZKy+HjZFOi0Bn8eMy+uif2ltQuW9g1Eg793BVxjRHPBYbFh/wDDEuIWvkHlVmUqIyzhaNivs6BF+RmmoaJSoh0X4dNxuvrgQCqek4Nce8IIHdi+hggF/N+C+pqRgYW0/ziGhJ3F0dI4fVg/08T4Xv83I124FtwQQ9DxXe5pfSVP61aFHtfcWrfE2Hs/r4OC04X8lOxi1qLRhXst1FrDM+sKsCExyhfvIhJJ9a+q1m6OQ5hRE8h0vV2+1gjJcXkyZFfG41wl84dGpfZpwOzJCdyv6alXkd1q6/BiJAcdia9SjkBm3Yn0+UiplwS9EjqoHPOs/brvV2iSmqCXnu1c1mnlzxvNsUUoUH1q5G/Ba7dUxYlKecBfa+R5Pxg0OA1bYSsJnFUIfJI5ZZojZ0MltHA9wlaDCBh57c7dIwOAzTfk79vnyLWYCCytd1C6WAwIAMJI8zCLAgSe5uEs0xu+Dqn24QP/Z/+fkX41nb0OWyc7nThVFpr4izmRttSPj4HcGZIgpJFZn/esMTAb3IktvdBHOQY8aJidRyH9GwggCZRYfa58X6IE6VnMaHBuNnrZ4kOGE9mJwAVhliTiaIXvFEl5lUnmG08+W2nFAt6ZW1DaUZdMm7BXau5Tok24Z3sq8OWUhl6mV60lXi5B0IkkQ91+insAEXxcqGyysVuRy3ME395FWenLSJuwY7a5OBeOgi2ra/hdqcuETPGzWQr8xfXjVeKN1ksrVzIXnkMy6wVEMrwiw3Q6XXxjjviNYv+wZp3kp0r4lO0YFRvIsjGeOCP4Hfvtj7Ck+mbSCeJgUI6CIZ8BYfwnYc6sSoDIC06cEbU5GFNPy2DrVUGHtTt9sLE+MKDRyrqzuLNqhnDGBFc+JWom1brjhm18Of8hBGQoG1ekU4d2
 K1hzn4Do
 d3gl0luB31GJViSWpIpe936whrR9vMJ+CFpkk1r1G8u9hf4uQfKP0qpgc6pxx56RRqab9t4R7rAzKrZtX0svNEb5n4jY7TvGyL8uzT15w+cjMSzx5cGfAoVBWi+ZOImATOtwMewa6cCigGGSQtwXt9uq/Y6L0XsPyK8DTC3gp6Y9/hohyM3RzUXVJtSjtUDMBPox5ji08VfFJCfRbGelrN9Wf0ZKn7EXWYxAU8Y9XYSeUB8a272zkdN5KViowNuNVkpPfA+M0Gw+X7L7RWxekzv0rGQS99VWC2sD2Lt1yvp3GUXnSfvsT7rIeW6DUzV9B9y4aDi0gClUVqY5wgD2kYBTJeGZSZkshNc9EIaZbM00TNJISX9ajghslx4tUHCvMJ2aJQZTzTE1xL+c6p+Fyotl0nGQu3yQPYsOFpoz3XvY70sG5BW1gIYlFPW3e/thmwOYwIOZWhlgM/okmhjh98GBcYRlRxv8HhQrVQkDeigpDhzJKTQbpWZrx8kP+oJlawCEsVkGRC/o6yN4MMbf1e2YYy8fR9VBATIOIs45eYP/PJ6j69am7S/czvdOsd74bFvOzj942cs+pB1JccPgNFLxww0Nf/8Xc/hlMdmfAfJk+Ur0NpxKRwCeaDmRb7916A5YspOLWUr1GqHSiRKFlXwDkoxJscCuhhkCz/JID5MY3+0ITtAhVj7rzEpEreislnqbWsvRm7JdFAO0itHOMHnAVtJBj48EdZG+Yn9WlwDAUAVRRh2BvSGuuAlxKFGrURnjUxidFxcyzS6GV6qxH77ZKp0+cjZ3zE4DfAs2UeaXnlh9Q2wJdqKPo6RE+AAiwuWQk
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
SCAN_NO_PTE_TABLE or SCAN_PTE_MAPPED_HUGEPAGE [5], just skip it.

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


V7 -> V8:
- Just not skip collapse for lazyfree folios in VM_DROPPABLE mappings.
- "cur_progress" equal to 1 when SCAN_PTE_MAPPED_HUGEPAGE in file case.
- V7 PATCH #5 has been merged into the mm-new branch.
- Some cleaning, more detail commit log, and pickup Reviewed-by.

V6 -> V7:
- Use "*cur_progress += 1" at the beginning of the loop in anon case.
- Always "cur_progress" equal to HPAGE_PMD_NR in file case.
- Some cleaning, and pickup Acked-by and Reviewed-by.

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

V7 : https://lore.kernel.org/linux-mm/20260207081613.588598-1-vernon2gm@gmail.com
V6 : https://lore.kernel.org/linux-mm/20260201122554.1470071-1-vernon2gm@gmail.com
V5 : https://lore.kernel.org/linux-mm/20260123082232.16413-1-vernon2gm@gmail.com
V4 : https://lore.kernel.org/linux-mm/20260111121909.8410-1-yanglincheng@kylinos.cn
V3 : https://lore.kernel.org/linux-mm/20260104054112.4541-1-yanglincheng@kylinos.cn
V2 : https://lore.kernel.org/linux-mm/20251229055151.54887-1-yanglincheng@kylinos.cn
V1 : https://lore.kernel.org/linux-mm/20251215090419.174418-1-yanglincheng@kylinos.cn

[1] https://github.com/vernon2gh/app_and_module/blob/main/khugepaged/khugepaged_mm.bt
[2] https://github.com/vernon2gh/app_and_module/blob/main/khugepaged/app.c
[3] https://lore.kernel.org/linux-mm/4c35391e-a944-4e62-9103-4a1c4961f62a@arm.com
[4] https://lore.kernel.org/linux-mm/CACZaFFNY8+UKLzBGnmB3ij9amzBdKJgytcSNtA8fLCake8Ua=A@mail.gmail.com
[5] https://lore.kernel.org/linux-mm/4qdu7owpmxfh3ugsue775fxarw5g2gcggbxdf5psj75nnu7z2u@cv2uu2yocaxq

Vernon Yang (4):
  mm: khugepaged: add trace_mm_khugepaged_scan event
  mm: khugepaged: refine scan progress number
  mm: add folio_test_lazyfree helper
  mm: khugepaged: skip lazy-free folios

 include/linux/page-flags.h         |  5 +++
 include/trace/events/huge_memory.h | 26 ++++++++++++++
 mm/khugepaged.c                    | 57 ++++++++++++++++++++++++------
 mm/rmap.c                          |  2 +-
 mm/vmscan.c                        |  5 ++-
 5 files changed, 81 insertions(+), 14 deletions(-)


base-commit: a6fdc327de4678e54b5122441c970371014117b0
--
2.51.0


