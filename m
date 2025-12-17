Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8D998D65529
	for <linux-mm@archiver.kernel.org>; Wed, 17 Dec 2025 09:46:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C60D36B0005; Wed, 17 Dec 2025 04:46:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C42376B0089; Wed, 17 Dec 2025 04:46:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B410F6B008A; Wed, 17 Dec 2025 04:46:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id A1C626B0005
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 04:46:57 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 5502ABBAE2
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 09:46:57 +0000 (UTC)
X-FDA: 84228484074.25.AA67108
Received: from out-178.mta1.migadu.com (out-178.mta1.migadu.com [95.215.58.178])
	by imf07.hostedemail.com (Postfix) with ESMTP id 907ED40004
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 09:46:55 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=MRO4qPIx;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf07.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.178 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765964816; a=rsa-sha256;
	cv=none;
	b=VLMQ5R2t4RzInuqqoUUbWADnwHaPZx1oqaCZAiSvv3ZPqhTr1ZkY1sZ4yrdJgHye23aJU8
	A+znbU03vyXNLMAhQtaN1Lu6PPLxmz9eXuqX1/kq0nzMpnBYRLApI41JdZpZWSwOQvIypW
	avDUBjvqGTWQFcCNkI6bT7QVuvxr8Rs=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=MRO4qPIx;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf07.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.178 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765964815;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=oN9R7byRGmHEs6T0OtpuwOuRpbJv46Zq9CpZBf5+XJg=;
	b=sfaFsrYvhHexG0rrFMHhs3JtFtu6iYDB5MRHLbNxTR/G8NT5qN/M/Xk25m2I4HXv5Oh5RE
	AftvfDCu+J6Gn6dWZcx1LnQiX0RSEp1fWD15oFB+pq/hpYaZcE9TckpM+f/xvzjy9CRz8O
	TCNHwhJT/pnbhJFL/9IDsWlAB/O1oIw=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1765964813;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=oN9R7byRGmHEs6T0OtpuwOuRpbJv46Zq9CpZBf5+XJg=;
	b=MRO4qPIxxsVdDqwXzC7u9PLqRjNXx7wnrDSDf1lYyiYd50PIXjJACLh+SJDhboDde2AFBp
	xudEn7lhZost3Ms/RAgSJ4rwmF9QHLUnd5iBfmp1YPdZeHPAwkC3Dg4lXkpK8Qt3kXk60G
	KOm9TW1XYyMer/EiQIPn82zf46FXx9c=
From: Qi Zheng <qi.zheng@linux.dev>
To: will@kernel.org,
	aneesh.kumar@kernel.org,
	npiggin@gmail.com,
	peterz@infradead.org,
	dev.jain@arm.com,
	akpm@linux-foundation.org,
	david@kernel.org,
	ioworker0@gmail.com,
	linmag7@gmail.com
Cc: linux-arch@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-alpha@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-mips@vger.kernel.org,
	linux-parisc@vger.kernel.org,
	linux-um@lists.infradead.org,
	Qi Zheng <zhengqi.arch@bytedance.com>
Subject: [PATCH v3 0/7] enable PT_RECLAIM on all 64-bit architectures
Date: Wed, 17 Dec 2025 17:45:41 +0800
Message-ID: <cover.1765963770.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 907ED40004
X-Stat-Signature: pxqmwnm1tzfsu4xep3th6txxdpuzkhyh
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1765964815-149236
X-HE-Meta: U2FsdGVkX18OxwRmL15QscZfi3u3BZg3QkO3ybd+9UMqyO3D2/LXglZBO4GudHdbeCRjSj3Bysj4sbwSg33ouOsgFLnYRZUPvVqNi7eDN5gww4JVBWQWVamoNgWToW5MO2aZrvwIK1JuvOtGabnDB+XGmqJ4EIS4wLjGMJvdH+oBGaSfS+57WDFz5uft54WNtVzCp+KvxoaUjDIeBEWPgBvnpSOLPv3B90tgCIbb0gK3dqI9v0JdOeO9DeEs+CVUSgaQZD/K0gwjtGbuxCX+TGuUF6A2XK8T0WVGnZSnP0hPRV50wiOj0Rz2iPlv0Qoi8me1mxkETLv8qd4rPVRo8UDn2HVU+LcpN1x5jbfWpUYVc51URcxxrkn5U8hC2ho39VhomRMeOPxMND9MWZ1B4PSSRuQjEWJf+AkbrebYhBznIuojuOJNA3Bhb10vUaQ7SIhJNJRVb8CYiB0PQ1vvC4OyxtzpMFRT3fUz8l6mklHXYxJwOO43o4V8QnFRC5PnGBkwMYO7qmtwd5o4zsx9Kiz+cFJbm83tXAMtmR9jnZB1ulGgM1xGkQ5lBqU2cjO8euVF8tpGK7TWX0+pY1ozSeXlCJWHi1yT9TbScv6Wvtu3o8YEmgZKKIMFTpN3TK4iPuWIf4aEU09Tq8YASzhrvFKrU3rJWqm4dkmal6H6xsrHr2mqV+wA3YSdPRwhGH5AbLN3qrYxBaulH+8JcxAugpTb94EUHNs9bJzAiXaiKIgHESGsa1iyf8YikrS3GZq8Kxv97fUbNhechosfd4Bpung/mzv/l8rSJRDi4k0h8MHNdbiXxrRgER55ixHs7X1TS9d1AnwTQAsRQPVHLuC4iC8G6CDPDZaOjs+w2CDdy/TjBIEwXktFCClv/QXcvYHrRDwM1XVvWpuMNchiskqB+xNJXjl57RIuLCTHKe2cNODdAjZoia6FfN2c0IdvtXl3M/Qpf77/uSHxXe/9syl
 LGVkA73/
 rns8OMGd16TC+Vdy+q4/CW1dudtA7qxJ/eHYCJ/jXPHzmsnhwKjUKjtyb0A5GkflFWIh3x8MfgvTkIjTUKeg5/rpz1lQxDYQm19VsskH/evzisqBdky0waJ4VMxq1rIRLHidwXGcUBP68BScn6mblJ6SHyRpVjlBe8CmlzDelwC9q51qwTaKBrMTA347PUuiqkyv/SfEsXHt2xQkRiV2oJw6iuvfO3GZUQOjdTE6oNJZaGJQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Qi Zheng <zhengqi.arch@bytedance.com>

Changes in v3:
 - modify the commit message in [PATCH v3 1/7] (suggested by David Hildenbrand)
 - make PT_RECLAIM depends on MMU_GATHER_RCU_TABLE_FREE instead of 64BIT
 - collect Acked-by
 - rebase onto the next-20251217

Changelog in v2:
 - fix compilation errors (reported by Magnus Lindholm and kernel test robot)
 - adjust some code style (suggested by Huacai Chen)
 - make PT_RECLAIM user-unselectable (suggested by David Hildenbrand)
 - rebase onto the next-20251119

Hi all,

This series aims to enable PT_RECLAIM on all 64-bit architectures.

On a 64-bit system, madvise(MADV_DONTNEED) may cause a large number of empty PTE
page table pages (such as 100GB+). To resolve this problem, we need to enable
PT_RECLAIM, which depends on MMU_GATHER_RCU_TABLE_FREE.

Therefore, this series first enables MMU_GATHER_RCU_TABLE_FREE on all 64-bit
architectures, and finally makes PT_RECLAIM depend on MMU_GATHER_RCU_TABLE_FREE.
This way, PT_RECLAIM can be enabled by default on all 64-bit architectures.

Of course, this will also be enabled on some 32-bit architectures that already
support MMU_GATHER_RCU_TABLE_FREE. That's fine, PT_RECLAIM works well on all
32-bit architectures as well. Although the benefit isn't significant, there's
still memory that can be reclaimed. Perhaps PT_RECLAIM can be enabled on all
32-bit architectures in the future.

Comments and suggestions are welcome!

Thanks,
Qi

Qi Zheng (7):
  mm: change mm/pt_reclaim.c to use asm/tlb.h instead of
    asm-generic/tlb.h
  alpha: mm: enable MMU_GATHER_RCU_TABLE_FREE
  LoongArch: mm: enable MMU_GATHER_RCU_TABLE_FREE
  mips: mm: enable MMU_GATHER_RCU_TABLE_FREE
  parisc: mm: enable MMU_GATHER_RCU_TABLE_FREE
  um: mm: enable MMU_GATHER_RCU_TABLE_FREE
  mm: make PT_RECLAIM depends on MMU_GATHER_RCU_TABLE_FREE

 arch/alpha/Kconfig                   | 1 +
 arch/alpha/include/asm/tlb.h         | 6 +++---
 arch/loongarch/Kconfig               | 1 +
 arch/loongarch/include/asm/pgalloc.h | 7 +++----
 arch/mips/Kconfig                    | 1 +
 arch/mips/include/asm/pgalloc.h      | 7 +++----
 arch/parisc/Kconfig                  | 1 +
 arch/parisc/include/asm/tlb.h        | 4 ++--
 arch/um/Kconfig                      | 1 +
 arch/x86/Kconfig                     | 1 -
 mm/Kconfig                           | 9 ++-------
 mm/pt_reclaim.c                      | 2 +-
 12 files changed, 19 insertions(+), 22 deletions(-)

-- 
2.20.1


