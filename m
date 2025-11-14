Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 43202CE7AE0
	for <linux-mm@archiver.kernel.org>; Fri, 14 Nov 2025 11:13:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6113F8E0008; Fri, 14 Nov 2025 06:13:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5E9428E0002; Fri, 14 Nov 2025 06:13:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 525BE8E0008; Fri, 14 Nov 2025 06:13:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4036B8E0002
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 06:13:37 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D9F294CCE8
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 11:13:36 +0000 (UTC)
X-FDA: 84108952032.05.6EF2B21
Received: from out-170.mta0.migadu.com (out-170.mta0.migadu.com [91.218.175.170])
	by imf05.hostedemail.com (Postfix) with ESMTP id 1DDC010000B
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 11:13:34 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Stpm2Cw2;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf05.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.170 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763118815;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=7tXlmZ+pRF9jtuKn/rsOIXurW72jRhlWkLmUc3dGBwY=;
	b=JE9RfDdyskTkIAIK4PDnjyiYbDtYuBCZ0ZXG86fJ4ZpMGeQLuTmLV9+Q49Pv+UfVt1KHgS
	ITcQBKz7HHZxvVzocW8JNtmLnTA6CODyTbzKpmASjMdk3LbgHqWWwj7ONGowAW1S9q9ttB
	mXFUUNGtu1aO6cOjMpOjMZHyYD4q4HI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763118815; a=rsa-sha256;
	cv=none;
	b=LoTKl4wfV3ny4ohqKM2YWltvpIBLKrcwpc7nhGUmRO64qnezDt1C4W/ScUfJWaR4BeZoTD
	26hmqYDsvSMETPS/zQbozzdLF0Hv8g0Sv+7Ock0vi4xj91++vUmH/2xmqinbOCfCGfKvXb
	GbsmRLhNZuOFsUCvhsAy8TPFu+XoQPA=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Stpm2Cw2;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf05.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.170 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1763118812;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=7tXlmZ+pRF9jtuKn/rsOIXurW72jRhlWkLmUc3dGBwY=;
	b=Stpm2Cw2eR2J2rbFTzOawJSjf+8nVr0S2DRH8c9JHKG+fa285HvCdFhAMOTsWRsfTG7RAJ
	jloMnHkECy68rT0g0QHXnxlcRLoj/F48niZL+Kl1UjiVPo0BMgqdyzoUeUTD8/BUmGQpnX
	MUXmRasI8N65oN5LGgdju7vLVsDd3dI=
From: Qi Zheng <qi.zheng@linux.dev>
To: will@kernel.org,
	aneesh.kumar@kernel.org,
	npiggin@gmail.com,
	peterz@infradead.org,
	dev.jain@arm.com,
	akpm@linux-foundation.org,
	david@redhat.com,
	ioworker0@gmail.com
Cc: linux-arch@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-alpha@vger.kernel.org,
	linux-snps-arc@lists.infradead.org,
	loongarch@lists.linux.dev,
	linux-mips@vger.kernel.org,
	linux-parisc@vger.kernel.org,
	linux-um@lists.infradead.org,
	Qi Zheng <zhengqi.arch@bytedance.com>
Subject: [PATCH 0/7] enable PT_RECLAIM on all 64-bit architectures
Date: Fri, 14 Nov 2025 19:11:14 +0800
Message-ID: <cover.1763117269.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: fauqf68qudcmdzsoaa6u8ipnm1fqq65k
X-Rspam-User: 
X-Rspamd-Queue-Id: 1DDC010000B
X-Rspamd-Server: rspam10
X-HE-Tag: 1763118814-507877
X-HE-Meta: U2FsdGVkX19UTkVsDhcidlLZcE4yulpTIMPwTCAD8XrXqLjXQIDdbToR+6hQEwQxCBjOiSU4S6r1QoUfLnZdB7KJdNescfQBIJjMQ+R64+qRDxMYsTYRxtvOCDN/SD+RkL8drQb6R7ygzY8brhPsfqZJU9+/T9N8i/SUpLWAuB2uEHsXp4ti8Yu4Vwi06FWpGlu7oAdmm1R/D1sSJqJGwZ8/XRq2ngMfCbJOGNIexrx6hoIrDj9S/pR+w+NxpaHpb8CjB0+2xxvqYWhpz53hFgMV/7iNXzuMkocu1YULkOsvzyQx800+69QWg1VNkn0iIrLMtkicj2wxhZAKf7qas0wK/JfdbMD3mVMTRm5BBq/iwKUf2PSyHxEPfuSUlkGxZJ8SS3GTNAdstO3iiDFCg/sc+qGA+abhyFwZn5s58lbsjYnn1gxu7xMeB5LMd1QPvHwwxhj8ZhEF5GojsKsN1jLI593PXxcVo3n3OpY3ERb5DebyV0vlcXivBW/IA0SxDqzVQ2Tb8M4DMn1U12qYHS5pQLa0okhHUy4B42yG8qIi5+ghgmlvmdQA2liIutH85likrSmO15Zy3FDGDmY8mrGiwZwCYYxBkoxFcvoS7X+BrkdY9Ln/IsiPWBsdIdgnDoNz0a/+KoEWyykO1FvL0x7vovafyaMyL9bZaBDeI9fPT5NAKCPH/HBCRD1TugqJWym7ywjveUT3EQsoWm4BdEejoAPzxRpXPX3xxtyfOB65utyGqTHjwL3tVVCkEBjBiqbF2oJlzEQUgrSv3s/HKJWnZ1WivusxU/HALCVXYjdZqQib53lXvCdM1c7kWn6+1qN8GgCavQa9J0HlngWjWh0v1+LxgJpG6RUgyoEpR2XioOfVB5lhATamp9HhcWMXNqWLceaz4RXGZLIBtrnnbcXwVsrJcR030C9PN9WckofDm1hayCzC5ekv2Pdux6SgWg8v0skkv82WbhdLP7y
 UQq1o9kQ
 wkYmz4De4z9ghtigQUCMWAmqwNiSHWV0iHk0gZGe0jjun9+lysHxXzGsJOtSv0e08NuQeXnah4W4/rVTCtBNcnL1mZ3GcxTX8v/oraZ10rXkRVdU5jyzFq9l+36Gf1Zj42ahrS/y1FajmHK5R/v4h7rxQfv+5c3ydfkcxDAGiJpz0nE1H5rmLVEZsoxPvwcVIpMGNS8gQdo2iLMTeC9yC3mcwBlVL8Hts5u4dW9JRZSMnkJI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Qi Zheng <zhengqi.arch@bytedance.com>

Hi all,

This series aims to enable PT_RECLAIM on all 64-bit architectures.

On a 64-bit system, madvise(MADV_DONTNEED) may cause a large number of empty PTE
page table pages (such as 100GB+). To resolve this problem, we need to enable
PT_RECLAIM, which depends on MMU_GATHER_RCU_TABLE_FREE.

Therefore, this series first enables MMU_GATHER_RCU_TABLE_FREE on all 64-bit
architectures, and finally makes PT_RECLAIM depend on MMU_GATHER_RCU_TABLE_FREE
&& 64BIT. This way, PT_RECLAIM can be enabled by default on all 64-bit
architectures.

Comments and suggestions are welcome!

Thanks,
Qi

Qi Zheng (7):
  alpha: mm: enable MMU_GATHER_RCU_TABLE_FREE
  arc: mm: enable MMU_GATHER_RCU_TABLE_FREE
  loongarch: mm: enable MMU_GATHER_RCU_TABLE_FREE
  mips: mm: enable MMU_GATHER_RCU_TABLE_FREE
  parisc: mm: enable MMU_GATHER_RCU_TABLE_FREE
  um: mm: enable MMU_GATHER_RCU_TABLE_FREE
  mm: make PT_RECLAIM depend on MMU_GATHER_RCU_TABLE_FREE && 64BIT

 arch/alpha/Kconfig                   | 1 +
 arch/alpha/include/asm/tlb.h         | 8 +++++---
 arch/arc/Kconfig                     | 1 +
 arch/arc/include/asm/pgalloc.h       | 9 ++++++---
 arch/loongarch/Kconfig               | 1 +
 arch/loongarch/include/asm/pgalloc.h | 6 ++++--
 arch/mips/Kconfig                    | 1 +
 arch/mips/include/asm/pgalloc.h      | 6 ++++--
 arch/parisc/Kconfig                  | 1 +
 arch/parisc/include/asm/tlb.h        | 6 ++++--
 arch/um/Kconfig                      | 1 +
 arch/x86/Kconfig                     | 1 -
 mm/Kconfig                           | 6 +-----
 13 files changed, 30 insertions(+), 18 deletions(-)

-- 
2.20.1


