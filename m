Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F0E2CCF2567
	for <linux-mm@archiver.kernel.org>; Wed, 19 Nov 2025 07:32:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 265546B0088; Wed, 19 Nov 2025 02:32:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 215E56B0089; Wed, 19 Nov 2025 02:32:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1527F6B009E; Wed, 19 Nov 2025 02:32:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 04C466B0088
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 02:32:35 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id AD9BF1603C2
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 07:32:34 +0000 (UTC)
X-FDA: 84126539028.12.CF680EB
Received: from out-178.mta0.migadu.com (out-178.mta0.migadu.com [91.218.175.178])
	by imf13.hostedemail.com (Postfix) with ESMTP id E790D20005
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 07:32:32 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=RkrZBK3O;
	spf=pass (imf13.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.178 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763537553;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=RM/LNY/jIqKvMu4siWA3n4g7le9dIkYSozgItVRuYzQ=;
	b=j/+AxmMIjqg9L3o8tFsQDorLZkjJFsvqkv9i5h42i1p0i5UY8gubvklagn9WkIkMMxy2VP
	QgNlOfajQ4XoIOnYbJLELgLEQ2CLyvRo2ias39vygi1NaEoHH7rc3c0pxwXRP2acJsAKyo
	DENo7JPhKKiCQZiN6eSmP+PMTJDgCx4=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=RkrZBK3O;
	spf=pass (imf13.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.178 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763537553; a=rsa-sha256;
	cv=none;
	b=h4PgAUMcrnnqg3qvwqHr+BtUlWOyD3qulQlweT5MpOaTwXHxVsrvUo9heFSF8ndztQPYbk
	Vdab+vHOx9wCZiOM1EUfO0sivcPbi/Pj5xGMyTlZpMDo6BXXCx6+Ipab/sZzANOFd9SSyY
	oG96ql1L9TSq0wQeTqNVOk/iuGPWiQc=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1763537550;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=RM/LNY/jIqKvMu4siWA3n4g7le9dIkYSozgItVRuYzQ=;
	b=RkrZBK3OBlnLn39KLbMXWTZHlkpQhan3nyk+UskGsUD7ugTEJOaYyfWLD3V1wFF7qXLd8d
	89T9NsZlF9okuMBocxfIwiJRSi+XwXf2ys8YqEE8dcM+bWD2FAunmOg9NrueVwybIJH4fT
	KGL4YWEpARpMdZqp/4K6fUM4DDEnpoI=
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
Subject: [PATCH v2 0/7] enable PT_RECLAIM on all 64-bit architectures
Date: Wed, 19 Nov 2025 15:31:17 +0800
Message-ID: <cover.1763537007.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: E790D20005
X-Stat-Signature: 6hzicdryzpuesh933xgj9e8ib7nqoej9
X-Rspam-User: 
X-HE-Tag: 1763537552-742134
X-HE-Meta: U2FsdGVkX1/dC0/QIdxoieHLlwIO1H5MUiWdbx3FB7pbML5LdHhrsErd+OQaeYAOxSxdw9sZVcyKzfePLTaWECcX2nBsmuPAVcrtLJYHvdWu4A7DeFuoFe24+X8vzCKhupxpSprcunvefF0dIIMnlOEnSnex03XyWsO//fEYTUsRXxHCNOcsHyTHuVF/gpfQy4+qxtfdIo59MVhjTM7Gc5k0664YUxKO1vDbipLoG+ZUKZIYTA8/Rjm8N72KN1wiEtV5Pzp6Yk/XmaIS8ARsSQ0Tu0i9OJOKEbuWKz2i5Wf1BsdSCb/XmbmFnfjA1bxR8ArdjK8VYIq9eMBnTg0Htnln1ZJ7QXvoKvcdf4wJzNoE7jwH1VBwP9xMX/qJaS3XompOm/SepfPS6yiLsb/aIINQDNKDVh6u6eD8gdkll49FouuifReUOMxshMh3Zs8HkA17Rayw3mkhe3f+pFvFHQMjAn0u9kUR2OCdstPl29StQ7vxmOLPPOeAsxrVAQ3VYZU05BMjCyl7ozgZ93op0vz+uwpncaNtm46U46Lez1L9/OWFd50aBL46mAHfSOXdodD0lx+u4uxA4otg1w/GnW/nVct3auAGfs/z8mJUqjCdBl3mFxOMJqdqAbjwyU49F/8IeYXW94nD2uUDeklJGT0voCSW0LC6fTZPa0RvSMvZj/sDCC8S3/Tvy2B6aVPYEKdpzghA3Zb8uqiy9UJ1UdpXoHPx8IdG5gshl9lScc6nJSXaPcats05jS1mTmruKP/l2mGHruqeqd687JX+6qJpf/JTuO48QljFwiz3Y0Gs3j7yHAswYrJiuMiaMpq4RV3cnDIzCYjxwLlJneCb5t50P/X6D0hVe25fiUO1iPZlZC3y1D8yQ0v1VVIyuegYtWgVODzNW/ABPXOWtXr8rcbX1r3x5hzBnGMcFYY6BWrtMiHq/fsIsn/jRcbUqeLnVXU+3D6ucixhoPTIBZ8X
 FCSrwb3R
 +xLWiuEr3djhfdtGTPfBg7EbjcaTOSkVCtDqlYz8mmgAWrG0vcFjV7C6RP0IGrcYqKD7tT+z1ZTVJ1hHpNtMkGXow1reL3ziHEpYJuTetVr4NMRTYEPvoFJ42TTkeSoi6nZ6iHpR7rjVNW58wRKtP2xrY8AmbQiYJEl2VJ7T0D2ISxmcBNtVTDrzUoBnEmhVMFPoSFu/xFGHpMqx8YFloQ7Qg2ertxxag+PIwzUjQK+8yAdY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Qi Zheng <zhengqi.arch@bytedance.com>

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
architectures, and finally makes PT_RECLAIM depend on 64BIT. This way,
PT_RECLAIM can be enabled by default on all 64-bit architectures.

BTW, PT_RECLAIM works well on all 32-bit architectures as well. Although the
benefit isn't significant, there's still memory that can be reclaimed. Perhaps
PT_RECLAIM can be enabled on all 32-bit architectures in the future.

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
  mm: enable PT_RECLAIM on all 64-bit architectures

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


