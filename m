Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 149BCE9A03F
	for <linux-mm@archiver.kernel.org>; Tue, 17 Feb 2026 20:06:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C7D826B0088; Tue, 17 Feb 2026 15:06:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C47C36B0098; Tue, 17 Feb 2026 15:06:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A368E6B0088; Tue, 17 Feb 2026 15:06:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 81BB46B0088
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 15:06:52 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 2D8FB1602C2
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 20:06:52 +0000 (UTC)
X-FDA: 84455031864.02.802FE2C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 2B0E0C000D
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 20:06:49 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=CnGpVnrz;
	spf=pass (imf22.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771358810;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=5KKpdQ5122AVQvYA3QIx4NfeIt7AnAEoDDNKUksGwNA=;
	b=G2dnsLufz/KXwjkYmeVQekCFJXDKQYNO+efxrafl7/1R+wZIkA7P72KldIAI8V8pzEPFik
	aoybeLkQ/QH9U/VXBb+S4kxgUgR3x7AulhDiz6/+V1QwShkCLBZCyz2+vDCtW0qFWr4SXC
	Kw2/vgr/jnypjqM/GPNdXgnc8fT8Y7Q=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771358810; a=rsa-sha256;
	cv=none;
	b=mH0dLsk2gdr7/sVAJGoZL+2wWKL4x/01gq2hBw7zKQfMRFAPxYLFTzfKQCSAqYCNqNkjTR
	KfwekUzWCeXAZcgbVkCm+2KZa0pFGMowwwmCPDPzOTeP30u5jhITaNf4xODMPcAEE9aayJ
	P0vCrURHRrkWZl93PsTjopZ4cH4VH4I=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=CnGpVnrz;
	spf=pass (imf22.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id F1CBD43907;
	Tue, 17 Feb 2026 20:06:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C8355C4CEF7;
	Tue, 17 Feb 2026 20:06:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771358808;
	bh=A8tvZuNzeX3ptMHESXmOnZxAJZVESqug9w+R4jhew4U=;
	h=From:Subject:Date:To:Cc:Reply-To:From;
	b=CnGpVnrzK83sbHgcB646hbbvJw8GjBnP5vVZdgPgiRaVUiWwrrohyY61oje9DDF51
	 V7XFRtaKPUkGo6dPm+KofTxxPpb7DZmn7UnUaoJ0PKiatTWDCFWuPZvTG6wqVeo2yh
	 D20KMAfngKGSK/2/8e7QH29UvKXKKRxgzjRLHxqcfTR0UuFBeEggs5V5RZzB9H+JxA
	 yroFDQ1RR6YhKpV91iiFj55qVUFQpc+uMbsUkLwsRb7hN6EQvmFlLOn+hGpRvE7j84
	 yK8mIL0zHlJuEIacXzjwttjCW4JvLB75d1KNNdwiJjjOSUPqb9qcttMy4vFJthJgWx
	 x63EqJiBXy7OA==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5A81E9A03F;
	Tue, 17 Feb 2026 20:06:48 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Subject: [PATCH v3 00/12] mm, swap: swap table phase III: remove swap_map
Date: Wed, 18 Feb 2026 04:06:25 +0800
Message-Id: <20260218-swap-table-p3-v3-0-f4e34be021a7@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/13MQQ7CIBCF4asY1o5hqJTqynsYF9AOlkRpAwQ1T
 e8u7Uq7fC/5v4lFCo4iO+8mFii76AZfRrXfsbbX/k7gurKZ4EKiwBriS4+QtHkQjBU0HanKEik
 jLSvNGMi69+pdb2X3LqYhfFY+4/IuUs1RbKWMwEGrI0pptTkZfknkW/Lp0A5PtlhZ/PbNthelt
 8RNrchygfK/n+f5C7daBY/sAAAA
X-Change-ID: 20251216-swap-table-p3-8de73fee7b5f
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
 Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>, 
 Johannes Weiner <hannes@cmpxchg.org>, David Hildenbrand <david@kernel.org>, 
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
 Youngjun Park <youngjun.park@lge.com>, linux-kernel@vger.kernel.org, 
 Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1771358806; l=4924;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=A8tvZuNzeX3ptMHESXmOnZxAJZVESqug9w+R4jhew4U=;
 b=6LubyR8vhfIJ8XyfWmJmr1o9thCKYkaLYPhPaaB4hjujPpuoT5Kb49nlu46jQ0Np1lW8TVv2X
 6gHVEvKTG3gD/wJB54fi3mRipC6OpWfiDCTojPyznsWK0us+w4ugu+m
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspam-User: 
X-Stat-Signature: qfttg7mdh4q66h6uktbph8tnmd8mbks5
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 2B0E0C000D
X-HE-Tag: 1771358809-653135
X-HE-Meta: U2FsdGVkX19JYm8L/l7Y1sf+6reGW/3lIMzGs+K9RLpif+hXIO6I32+eX48vy887OKcsJP3AVOy0/tshyU6+LQ1cPEpPvQxvxAW99sS8lKOkuTr12HRvC/+EmrVTn867ap2haYokSj0W9bwaVBjvjYY8zpMi3Hi5/v4oc+DaDvy5HjaP4A1IHRpKy1IyGtdVotEVtG615iruuK1/n/HootCgRIfiEnZx6R+ji1rMJ20YyKgOHCuKKnz3AB6Z9tF2dsv8ya9TTAQV0thhFN1VAiZFav0hQ0QeI6D9jqWxz1Ok2dzQEDqImSaJV0hAlO8BYSGdWpc5q3Rb7MjykimVxEkwDibKBQpIdfF/9Dp78NV2AJr9kHyPESAGM74W7YwdHt/3Ex0GOKHQscUzI1r7FR/Yl7xJBkRPzElXoBG1K5WhQ/7mfbjjUAzVOSsADtSq4Z2qsqbf1nA2lwWxgGsjaw8N/hV4+Pr2iN6eMnFR6zJtD0vnVNg/qP5NijMdjrJMiXr+gWj0pXzZakP2sGWrB7RLI2Mg84fiU70yyVKavTYmnOnzuTTlgSt/CLZnVI1I2NH5H21hqID1Ri4rHbng0izhbWTgqs1XMCwZXmwRl3ZHJzbZazgTBZMrcl2JxlA46pT+ABpkjo8QGlrjU2+Ki0oDZ8JSxtcYCmxFyQENXDu1asU7F9YxaKvO3s5dDVe4AgwEwXJDIk9cTnwiwGZAjhccyUfxo9UpnpZrri/HzwbfSbqLoje71OXc8Nb8hpz76ZypiF2elFo9SWqt6h4XSGCziuRaiRIBtwiMVFSBydXjlH91JcboIpuP7/hGF9Zq1OI8U/mn4/z9wwXTOtsQX3weannW7MIM3yQCogtkmGfN/38SplnOk/91x/D2yiiJ5ZRozV4dE1DqzBjgwQinkPjwwu81GtjItlekR4nR0I6cZZF/T0oe6bq0rP8xMpKL9Q2PR29xzqj9+jI4VNk
 zkGxpjIP
 ckKos/4SMjIxVvdDDFQn/dszbBMRtg7uGosH2g0xZXDXNsa9RrsGeYyn/ZU17E7RMw/Jd4EHAoF78dV9mE/2dTMyDiIPwBg1Gw2a477+RAGJ7iNkbqF7iFKd9N1tluEKW1vy0iBtxVshQS33uvATYHWBtpmn6/RJa5ooTQGaEWUBHLIqMWZ5h1grIlrXkVTk9RC0duLDOIXnBdwULhaI+9YtV3KRf+FfJ2WG3UDaMcc5Ma68lr60cgDCzbjnrhzJEASoykuY5wL0MUES55Xo++T3p/WTcoj2W8siLucWE3/Xviai7IKSuXPKRbcf64wWFv1qP2lcue3muuxaP3ORmhft2MoqVxcrcjaMmzrUAxYkq0QnHT2TVq+yfg+HnX0n+PYB62Y7uqh7D7AL7HiNvFgSJJkE9YfllvnYLi88wh16j6YshxBCclNwZUw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This series is based on phase II which is still in mm-unstable.

This series removes the static swap_map and uses the swap table for the
swap count directly. This saves about ~30% memory usage for the static
swap metadata. For example, this saves 256MB of memory when mounting a
1TB swap device. Performance is slightly better too, since the double
update of the swap table and swap_map is now gone.

Test results:

Mounting a swap device:
=======================
Mount a 1TB brd device as SWAP, just to verify the memory save:

`free -m` before:
               total        used        free      shared  buff/cache   available
Mem:            1465        1051         417           1          61         413
Swap:        1054435           0     1054435

`free -m` after:
               total        used        free      shared  buff/cache   available
Mem:            1465         795         672           1          62         670
Swap:        1054435           0     1054435

Idle memory usage is reduced by ~256MB just as expected. And following
this design we should be able to save another ~512MB in a next phase.

Build kernel test:
==================
Test using ZSWAP with NVME SWAP, make -j48, defconfig, in a x86_64 VM
with 5G RAM, under global pressure, avg of 32 test run:

                Before            After:
System time:    1038.97s          1013.75s (-2.4%)

Test using ZRAM as SWAP, make -j12, tinyconfig, in a ARM64 VM with 1.5G
RAM, under global pressure, avg of 32 test run:

                Before            After:
System time:    67.75s            66.65s (-1.6%)

The result is slightly better.

Redis / Valkey benchmark:
=========================
Test using ZRAM as SWAP, in a ARM64 VM with 1.5G RAM, under global pressure,
avg of 64 test run:

Server: valkey-server --maxmemory 2560M
Client: redis-benchmark -r 3000000 -n 3000000 -d 1024 -c 12 -P 32 -t get

        no persistence              with BGSAVE
Before: 472705.71 RPS               369451.68 RPS
After:  481197.93 RPS (+1.8%)       374922.32 RPS (+1.5%)

In conclusion, performance is better in all cases, and memory usage is
much lower.

The swap cgroup array will also be merged into the swap table in a later
phase, saving the other ~60% part of the static swap metadata and making
all the swap metadata dynamic. The improved API for swap operations also
reduces the lock contention and makes more batching operations possible.

Suggested-by: Chris Li <chrisl@kernel.org>
Signed-off-by: Kairui Song <kasong@tencent.com>
---
Changes in v3:
- Use unsigned int instead of unsigned long for extended map as
  suggested by [Youngjun Park].
- Update a few stalled comments, and add back alloc failure warn.
- Link to v2: https://lore.kernel.org/r/20260128-swap-table-p3-v2-0-fe0b67ef0215@tencent.com

Changes in v2:
- Fix build error for ARC with 40 bits of PAE address, adjust macros to
  shrink SWP_TB_COUNT_BITS if needed, and trigger build error if that
  field is too small. There should be no code change for 64 bit builds.
- Fix build warning of unused variables.
- SWP_TB_COUNT_MAX should be ((1 << SWP_TB_COUNT_BITS) - 1), not ((1 <<
  SWP_TB_COUNT_BITS) - 2). No behavior change, just don't waste usable
  bits and reduce the chance of a slower extended table path.
- Add a missing NULL check in swap_extend_table_try_free.
- Fix a typecast error in the swapoff path to silence some static analyzer.
- Stress tested setups with SWP_TB_COUNT_BITS == 2, looks fine.
- Link to v1:
  https://lore.kernel.org/r/20260126-swap-table-p3-v1-0-a74155fab9b0@tencent.com

---
Kairui Song (12):
      mm, swap: protect si->swap_file properly and use as a mount indicator
      mm, swap: clean up swapon process and locking
      mm, swap: remove redundant arguments and locking for enabling a device
      mm, swap: consolidate bad slots setup and make it more robust
      mm/workingset: leave highest bits empty for anon shadow
      mm, swap: implement helpers for reserving data in the swap table
      mm, swap: mark bad slots in swap table directly
      mm, swap: simplify swap table sanity range check
      mm, swap: use the swap table to track the swap count
      mm, swap: no need to truncate the scan border
      mm, swap: simplify checking if a folio is swapped
      mm, swap: no need to clear the shadow explicitly

 include/linux/swap.h |   28 +-
 mm/memory.c          |    2 +-
 mm/swap.h            |   22 +-
 mm/swap_state.c      |   72 ++--
 mm/swap_table.h      |  138 ++++++-
 mm/swapfile.c        | 1121 +++++++++++++++++++++-----------------------------
 mm/workingset.c      |   49 ++-
 7 files changed, 667 insertions(+), 765 deletions(-)
---
base-commit: d9982f38eb6e9a0cb6bdd1116cc87f75a1084aad
change-id: 20251216-swap-table-p3-8de73fee7b5f

Best regards,
-- 
Kairui Song <kasong@tencent.com>



