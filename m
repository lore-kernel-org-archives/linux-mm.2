Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1359FCD5BC8
	for <linux-mm@archiver.kernel.org>; Tue, 26 May 2026 13:01:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7E0CB6B0093; Tue, 26 May 2026 09:01:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 791086B00B8; Tue, 26 May 2026 09:01:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6A73D6B00B9; Tue, 26 May 2026 09:01:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 595866B0093
	for <linux-mm@kvack.org>; Tue, 26 May 2026 09:01:29 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 01F861C02AF
	for <linux-mm@kvack.org>; Tue, 26 May 2026 13:01:28 +0000 (UTC)
X-FDA: 84809582298.10.CC34728
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf22.hostedemail.com (Postfix) with ESMTP id 6BFA4C0022
	for <linux-mm@kvack.org>; Tue, 26 May 2026 13:01:26 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=p5Dsr0Xg;
	spf=pass (imf22.hostedemail.com: domain of catalin.marinas@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=catalin.marinas@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779800486;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=p674zEnWHv8nUzAecGlmwz5Fx3UFXOqGsTZBm8jEkn8=;
	b=gJEvKKGYJ7rHuzAaUgIp5Z7p2sVUnkRqFxDp3U95jCvjlsta+LrHvwSH4OtAoykMeWpuBr
	lXExCnoZnnKHR+/cHHyEOVGuxzF0okUcRhLQTSU4GzBtijxQpyet8mV2nURLuTxHzVFQ2D
	CkwhNUyyD0BNL1WqgLS2ZToOjiNudV4=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=p5Dsr0Xg;
	spf=pass (imf22.hostedemail.com: domain of catalin.marinas@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=catalin.marinas@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779800486; a=rsa-sha256;
	cv=none;
	b=NVEM7Ccd+oYS8FdS7dJtpjXKmUo2SA9RQXsvFJWkF/u11+1XGIV0y4ar8GtcM2sxG/cl+Q
	GpOPVy0kd+2R3NnWHmR//Bpimy0Ew6v78rl7FNbBiGHkrN0UJvZzVWO3Uno9cz4mgjmZcY
	Dj+AeJaeXOHvNpiLEUD3DVatCTkCvK0=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2E9E9169C;
	Tue, 26 May 2026 06:01:20 -0700 (PDT)
Received: from arm.com (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 6F1563F7B4;
	Tue, 26 May 2026 06:01:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1779800485; bh=QpvJy6L0CWjMFpDpW8hAGQht5XAWKU3uc1IdSsCVqqI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=p5Dsr0XgPS8sKERaqTqbDerx+Dn5jf/pmbrKN+O+qEDCMgx32IF7d+aOy0yyNZYcH
	 +XwBPVX+lcDnvbKX7Dms7cneX8kxmoejWuL43TPu0moc2NGzHIA6y7Q0YGice4hMx+
	 eCJbFlg5YILwosv9Sj8NQkWWJYc8jsLPEp/mmU1g=
Date: Tue, 26 May 2026 14:01:20 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Zeng Heng <zengheng@huaweicloud.com>
Cc: will@kernel.org, akpm@linux-foundation.org, npiggin@gmail.com,
	aneesh.kumar@kernel.org, peterz@infradead.org,
	linux-kernel@vger.kernel.org, wangkefeng.wang@huawei.com,
	linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org,
	linux-arch@vger.kernel.org, zengheng4@huawei.com,
	sunnanyong@huawei.com, blingxue@tencent.com
Subject: Re: [PATCH] arm64: tlb: Flush walk cache when unsharing PMD tables
Message-ID: <ahWZoD9Ubaxx-GdK@arm.com>
References: <20260521073011.4121277-1-zengheng@huaweicloud.com>
 <177944657885.252010.9796978866224637120.b4-ty@arm.com>
 <f5b7460a-5719-bdb2-c53b-413468857f57@huaweicloud.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f5b7460a-5719-bdb2-c53b-413468857f57@huaweicloud.com>
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 6BFA4C0022
X-Stat-Signature: munexwp8zwycpjgq93nkkc459w1wu3k6
X-HE-Tag: 1779800486-464392
X-HE-Meta: U2FsdGVkX1+Vjv4UoS1xjlkaFoFNNtSCWy8tmiWJefzkYbs5g+5+qUomxP4zwvXpPvBJ8lIZhQE2BDH3ra/8MC52/TR5neJCMd93WSjSqqbCoGYS/abuuZTscipDyKX3zQbBieYJhyxQwvmBYsvSVQq3jYIypzy3VXTzMuEnSH7yR+R/XpzXDgFyoE+f6I4NlvRnKgU/xqRphm4D5unUBactYtDlFzm+Yyo6QLhFmmtgH9LWHYCM+RkkG4nvfCsTtI2rqVKn5U9Yx0JXqRH5OCBdtFCB0rBVfYBz4AylGS+y+0ICMU1x1x94NLZDk2aQCLXI191+H2iONNCflY6fPadGJIAZjjGzbBIBjonkxRQ7PL3mkSjaAUBrjuDmSFZTYvrY7pINvTQIHhmAXYzdZnJoHyCjcfe/GTf9PgXCx81mpG5u/MDacdWkcYIm642bb1BVhPnUBGtK28yT1LtE/4QrUENqbZnMYcdbfvOXC0xV2QMM6YV+Gfo7gHoxA5DOMyF6FkZ5Bsa9Qyw1XB5KD7FCNdFVU2YQgei8lNQYlvxICAQm8p9S/ggQR31Y7u3Y/N21LpDMtfHW09CWPKxkSr6DBIw8Oo+/W+21PxbJ90CcbPjkl+Q4dQxUylelP2u6Gc9f39PmMy8fug/WCOcj7qAxnph8uyvLVVwBNXIjVEFdMUzRyiSyYlwHEnSFQBVzv+TnWajoXTuR1fuXpKEBvHnnXlXgnIZ8pgctL73y37+cAd3X4BDPPeXXcVoZrz08LEgkNx2Kbfp66n+oHcmIcMfiUXgxHpr5w7UD5jY0cs7OJvj5G/mtRTiOSGg9+1LAYJdGEqOhXDymUMgnM3kvsPLvNQQvA0i4fMFmuqehkrGPkrUQwR08fwqZUmsij8jEL4a/L5snubzgTEYdsoa4azGU87If462uak779KJAViMu//A2FOmFP4eXSpBjCiUlz4fu+4Omjt+zzdW6k2/
 vA2h5UGs
 3XSXvMcDYKzEIFw2ogaQwEQeGUluPijkhjZqIZiIVtgREr3XIhVb7srXHsZ5UgkLrreQxQy6cuq9664PNm+ezU7BtPzgg+5raFmoxW+u1xFLcF2aP74eu22RRybu8XT8WCaM0YwLC0LK/K8u8G4cO5Z4ZGhyXoM70ICW5DkdxcXMYQgd7cmBYc7udncSd5DrWISRWaoO7pweMLv7Xbfb/HEJLPHSlrJgVpqX9aPPoFcDhCsK05vvnllJkmHPAyFq3NP0tAdF7Tpi738W2Y6ffk5PAsA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, May 25, 2026 at 05:20:14PM +0800, Zeng Heng wrote:
> On 2026/5/22 18:42, Catalin Marinas wrote:
> > On Thu, 21 May 2026 15:30:11 +0800, Zeng Heng wrote:
> > > When huge_pmd_unshare() is called to unshare a PMD table, the
> > > tlb_unshare_pmd_ptdesc() function sets tlb->unshared_tables=true
> > > but the aarch64 tlb_flush() only checked tlb->freed_tables to
> > > determine whether to use TLBF_NONE (vae1is, invalidates walk
> > > cache) or TLBF_NOWALKCACHE (vale1is, leaf-only).
> > > 
> > > This caused the stale PMD page table entry to remain in the walk cache
> > > after unshare, potentially leading to incorrect page table walks.
> > > 
> > > [...]
> > Applied to arm64 (for-next/fixes), thanks!
> > 
> > [1/1] arm64: tlb: Flush walk cache when unsharing PMD tables
> >        https://git.kernel.org/arm64/c/c2ff4764e03e
> 
> This original issue was reported by our customer, who also participated
> in the root cause analysis and resolution.
> 
> Could you please help add the below tags:
> 
> Co-developed-by: Xue Xiaowei <blingxue@tencent.com>
> Signed-off-by: Xue Xiaowei <blingxue@tencent.com>
> 
> Thank you in advance.

Too late unfortunately, the pull request went in on Friday. It will be
in the list archives though.

-- 
Catalin

