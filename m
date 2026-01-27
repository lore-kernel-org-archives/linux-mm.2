Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 363F3D2F004
	for <linux-mm@archiver.kernel.org>; Tue, 27 Jan 2026 12:16:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 57AA96B0088; Tue, 27 Jan 2026 07:16:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5285D6B0089; Tue, 27 Jan 2026 07:16:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 40A596B008A; Tue, 27 Jan 2026 07:16:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 2F6B46B0088
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 07:16:16 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D912F1B110F
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 12:16:15 +0000 (UTC)
X-FDA: 84377641110.02.50F089F
Received: from out-186.mta1.migadu.com (out-186.mta1.migadu.com [95.215.58.186])
	by imf11.hostedemail.com (Postfix) with ESMTP id C8AFE4000E
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 12:16:12 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=swOtWBA2;
	spf=pass (imf11.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.186 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769516174;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=rw3Z5uz+wN/jKEhx+ggzBvOdjGW0IdrWnEXd8bGadDI=;
	b=QThF2mGmG7G7SvlnjN1pYZwANbZ9OGAkqu4mlK67hm5SaJi9Ihe9PQFK0rirfk0Wf4JoZZ
	vVXX4xCbRYMhZxSSO3+4U/NfymmA/arval3aJanCzwnodybDaKYBmIqmPZu6tzD+A6Pr/A
	IQaLTwZ9dkOVItAmlEPiKRQVbrbHLao=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=swOtWBA2;
	spf=pass (imf11.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.186 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769516174; a=rsa-sha256;
	cv=none;
	b=Cu3E34cxU2Yl//KlVXJMZtORZ+Ylg4+F81++j6HilmGRiMVOLy3Ucbag6PaZuEmia0V6EP
	QnFL/dXw63gLdOFuKPdFsffkrp0a8b5Kg5MLkYlBA7Vjl7We3npLimDXvGIN6yQgFoZ6tn
	MaFFGsVJpTGPDTuG7YFtYwXA0reTk9o=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1769516168;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=rw3Z5uz+wN/jKEhx+ggzBvOdjGW0IdrWnEXd8bGadDI=;
	b=swOtWBA2Pxw+VUT1PgETbtdgbPH5WgWUXEJQKmSqNUXZeFJybWNBgbHHDf61HMLS9e9X+A
	/UbuSve74Y3SLHsizfV5uZHvGuLEqftFCcCvnoYpdjbId1/fyXQalrb4sM1LqT6/gvYfsS
	kGfQpCcXFro2mJes4NEiytnYkfPcksE=
From: Qi Zheng <qi.zheng@linux.dev>
To: david@kernel.org,
	andreas@gaisler.com,
	richard.weiyang@gmail.com,
	will@kernel.org,
	peterz@infradead.org,
	aneesh.kumar@kernel.org,
	npiggin@gmail.com,
	dev.jain@arm.com,
	ioworker0@gmail.com,
	linmag7@gmail.com,
	akpm@linux-foundation.org
Cc: linux-arch@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-alpha@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-mips@vger.kernel.org,
	linux-parisc@vger.kernel.org,
	linux-um@lists.infradead.org,
	sparclinux@vger.kernel.org,
	Qi Zheng <zhengqi.arch@bytedance.com>
Subject: [PATCH v4 0/8] enable PT_RECLAIM on more 64-bit architectures
Date: Tue, 27 Jan 2026 20:12:53 +0800
Message-ID: <cover.1769515122.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Queue-Id: C8AFE4000E
X-Rspamd-Server: rspam07
X-Stat-Signature: rxhtjf619scsgcxzfh3xra71sujacfw3
X-HE-Tag: 1769516172-27064
X-HE-Meta: U2FsdGVkX1+9mWt2qtv7QzmYA0iofESkjOJzb/vBMt5IDKLcsa87W2ANZF9goG3h6ADunBYlkk/+PXj+amSPRAqqo3bEBUmBcpQFuZcYMkLY1l20L7SSSuB8uW7gSu02azOttsjPS1tiB2XXsM5TYTs0rOVsv27XzEdv5yqHDitcR9FRDkFuFxi88twD0ecAUfC+als/WF/559OPdjcHtNlqcUrFifvEtj5eD9U5vXPD0POOmkw/Vek0C9+mS8+rui4Qm9aMoNtomaRyNA0bSFWl2VXhzjl6zgQYSHfttQmSq6H45psgy934bAizod5oAITs6BhxZlhziu7Z7JopK5w3FvTKFzP44VJsCh/XJwiluQ4spMfxU+KULn02VBvQYyK/s5OzUySJipO7x5llmSoYk32czsfDpHdVTDL4605yh9mMfsMWgCGmbJN8i7eRVu8T+uZ2lajQ8Q3Z90Oq/LI0zvi+x29/f4AKfn0bOTogTJFftJt47dmdspWHwstQrDndkqq/idvZLgXOSrc+O5xywKM4wi9kz9Kf7z2skUfMTosyb1p95QL/Jn4PbqagsMoIGTJqafWNPVjHo/vKzdTDAnkdvdnuB6wL3UcefzCi/XBWz2gra9al9+GCAQgmOgbLqaNI8qwP8dANKdKfQQAHcpCPKw+HKtLXUK80FQjrSrvaedZ+USxYr0a1zIgAfNjl4L57p+2dZ6y+/XCWllCnHvd4EMq3W+UmN6FTCYwPQc6Tz7VwaGVgxiDZnajHUGVThWuIK+WWYKFsSdZnKio/zVQC5FUfaeVVBgf2+JZFZ0TpH40q+jW0lVmBzkjJVwmSoRLld/8IrkTGIzHTUs5wL5XxGuJ36rjJR9NjnP10kMWmcQZJQfviOSDiSzWrtRIgeXnTl5CaPZ6a/NiBEyNLvuLlUj2FUeR244srD2ML+1t8gLVVtIuucrFWQ/jUx11Eaq0w0vKbQEGRZUr
 lRrMUioj
 4KrxW+8PDIMKcbm8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Qi Zheng <zhengqi.arch@bytedance.com>

Changes in v4:
 - convert __HAVE_ARCH_TLB_REMOVE_TABLE to CONFIG_HAVE_ARCH_TLB_REMOVE_TABLE config
 - fix a WARN_ON_ONCE() on sparc64 (and on ppc)
   (reported by Andreas Larsson)
 - collect Acked-by (Hi David, I've kept your Acked-by, feel free to drop it)
 - rebase onto the v6.19-rc7

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

This series aims to enable PT_RECLAIM on more 64-bit architectures.

On a 64-bit system, madvise(MADV_DONTNEED) may cause a large number of empty PTE
page table pages (such as 100GB+). To resolve this problem, we need to enable
PT_RECLAIM, which depends on MMU_GATHER_RCU_TABLE_FREE.

For these architectures that define its own __tlb_remove_table(), since
their page tables are not of type struct ptdesc, they cannot be supported
PT_RECLAIM.

Therefore, this series first enables MMU_GATHER_RCU_TABLE_FREE on all 64-bit
architectures, then converts __HAVE_ARCH_TLB_REMOVE_TABLE to
CONFIG_HAVE_ARCH_TLB_REMOVE_TABLE config, and finally makes PT_RECLAIM depend on
MMU_GATHER_RCU_TABLE_FREE && !HAVE_ARCH_TLB_REMOVE_TABLE. This way, PT_RECLAIM
can be enabled by default on most 64-bit architectures.

Of course, this will also be enabled on some 32-bit architectures that already
support MMU_GATHER_RCU_TABLE_FREE. That's fine, PT_RECLAIM works well on all
32-bit architectures as well. Although the benefit isn't significant, there's
still memory that can be reclaimed. Perhaps PT_RECLAIM can be enabled on all
32-bit architectures in the future.

Comments and suggestions are welcome!

Thanks,
Qi

Qi Zheng (8):
  mm: change mm/pt_reclaim.c to use asm/tlb.h instead of
    asm-generic/tlb.h
  alpha: mm: enable MMU_GATHER_RCU_TABLE_FREE
  LoongArch: mm: enable MMU_GATHER_RCU_TABLE_FREE
  mips: mm: enable MMU_GATHER_RCU_TABLE_FREE
  parisc: mm: enable MMU_GATHER_RCU_TABLE_FREE
  um: mm: enable MMU_GATHER_RCU_TABLE_FREE
  mm: convert __HAVE_ARCH_TLB_REMOVE_TABLE to
    CONFIG_HAVE_ARCH_TLB_REMOVE_TABLE config
  mm: make PT_RECLAIM depends on MMU_GATHER_RCU_TABLE_FREE

 arch/alpha/Kconfig                   | 1 +
 arch/alpha/include/asm/tlb.h         | 6 +++---
 arch/loongarch/Kconfig               | 1 +
 arch/loongarch/include/asm/pgalloc.h | 7 +++----
 arch/mips/Kconfig                    | 1 +
 arch/mips/include/asm/pgalloc.h      | 7 +++----
 arch/parisc/Kconfig                  | 1 +
 arch/parisc/include/asm/tlb.h        | 4 ++--
 arch/powerpc/Kconfig                 | 1 +
 arch/powerpc/include/asm/tlb.h       | 1 -
 arch/sparc/Kconfig                   | 1 +
 arch/sparc/include/asm/tlb_64.h      | 1 -
 arch/um/Kconfig                      | 1 +
 arch/x86/Kconfig                     | 1 -
 include/asm-generic/tlb.h            | 2 +-
 mm/Kconfig                           | 8 +++-----
 mm/pt_reclaim.c                      | 2 +-
 17 files changed, 23 insertions(+), 23 deletions(-)

-- 
2.20.1


