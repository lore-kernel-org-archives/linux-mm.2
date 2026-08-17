Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5CE25C5B572
	for <linux-mm@archiver.kernel.org>; Mon, 17 Aug 2026 16:05:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 76ADA6B00EE; Mon, 17 Aug 2026 12:05:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 742536B00F1; Mon, 17 Aug 2026 12:05:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6A7826B00F2; Mon, 17 Aug 2026 12:05:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4DAE36B00EE
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 12:05:42 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D21DF120820
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 16:05:41 +0000 (UTC)
X-FDA: 85111236882.30.1E30587
Received: from mta0.migadu.com (out-10.mta0.migadu.com [91.218.175.10])
	by imf11.hostedemail.com (Postfix) with ESMTP id 73F3A40004
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 16:05:38 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=vZGmMbem;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf11.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.10 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786982740;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HJnyubEpfviZVDRnjmcnAJr3UhC3FMFcEYDyjjrFN7M=;
	b=71Zb/oudUIbwEZa8u8NQ7VtLqyynrcPMdXpaDQRe1Cof8oB2cHLWYMkG0+tN8yZoYxZhKo
	qK/C5MwnFL6pGK2DOtq9wMg0XcKPwu1oduw+vURsfZq7xLl1k6X/nPvbP4o885uNdFTB8Z
	mWIzBLlI/CBU77sPPb4wwGVGvWkr0hg=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=vZGmMbem;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf11.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.10 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786982740;
	b=IMkcECH74LeNd2omDdh6a0lsQn7f9TUn4rk24VvDZhSGF5N5D15IA4MVe4KBoBnaOF2ROf
	ZTvyrIFPl9+vTqV+O78cywFgrOGyMW1XXo+7xF7n3ZjzCowlXEmlv+KtRyqoLz9+R4xzqE
	GYjBhukwNXKoo6jaApFWm58LSOJNNMw=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=1HL8LPVk8C1Xphfp1mnmMSDi25dP9z8IxQZoB/0vnw4=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1786982737; v=1; x=1787587537;
 b=vZGmMbemxlpB/sWbwVXFSfd1oZ8m53L7el3swG4MzBOEUdhZP1XwebRqQ5e8JZyd2K9UvBRe
 Xh+rso3iyRyV9zXXwbP9Ys57pXZHtpwbybV3VfqRNOeK/53bcKWUrpbi0qpw13JKIEwf7aBrjG5
 0qRMtDw5GSI9QjS3DSFmnOwc=
X-Envelope-To: linux-mm@kvack.org
Received: from localhost (2a03:2880:10ff:4::)
	by smtp.migadu.com with ESMTPS id 88455a43fb1c0c1e;
	Mon, 17 Aug 2026 16:05:37 +0000
X-Migadu-Flow: FLOW_OUT
Date: Mon, 17 Aug 2026 09:05:35 -0700
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Qi Zheng <qi.zheng@linux.dev>
Cc: hughd@google.com, baolin.wang@linux.alibaba.com, usama.arif@linux.dev, 
	brauner@kernel.org, akpm@linux-foundation.org, david@kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Qi Zheng <zhengqi.arch@bytedance.com>
Subject: Re: [PATCH v4 2/4] mm: memcontrol: make obj_cgroup_memcg() handle
 NULL objcg
Message-ID: <aoMxN97qg8uzk04R@linux.dev>
References: <cover.1786955972.git.zhengqi.arch@bytedance.com>
 <09bcf74312246a6e4146be8a0cb9787f8beddb28.1786955972.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <09bcf74312246a6e4146be8a0cb9787f8beddb28.1786955972.git.zhengqi.arch@bytedance.com>
X-Stat-Signature: 7afqe361k4tchzza7pc55doti64t8me5
X-Rspamd-Queue-Id: 73F3A40004
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1786982738-801124
X-HE-Meta: U2FsdGVkX1/ghYh5kxJb8gDVlsoeyuBhRUpZEzAMXV/7o6A9pB6/P1qeLuNGHgaV3WVrbg+wNmtT95dt6wp70/oeP3bBmoH839sWfZ3D0z1cDTleWPT7MkMCCKLX57jhaD6epNnpzwa5LZ/5hEvtN7EKWk6SWekqMmriO7xogXJyOJl3RS00KyF8trIMVPJwEPf4yUSaS/CpDo9pIh8UKfgWmM5x38lUpr4N2V4MYByB3TE5DunV5kI/6xHX6sACWLgYF1sSkfzoMEqIx0aend4nBCiErCydgxWw7tLx1hZFJNFojkTspPCa8iDL5PBrT7p31L6xilpj1dDydh+cYGt3pN0LM1CXkguq52z0RyNlI5OYcnvDIaWnrVmQ2kew+ul2z142B/hExVeVZWK6itO8mOJew/UZGCDbNqAvHRdF5iTRGd9V8HJzNzlKwd5EHNOi36DWNxZaaTHX5Ht78UFmrxN9TMuNIWOgCnvyIoJcV1yqvW/BZsWvWNGh1I1wrlV0pCsNizw+rVTJRW8JGoxG/rS9nOmp2KrCYfLcm8m6NCd54jNQM6KfO6PQw8XUupcPHdxrpo26Rp5Ci+73G24wopDsegliEHHFuqSG+hxCDZymKOIaMrkKdrWMtLn7SzVGJit7THvQ4vKld3CiKlvFAFvFrbGtHkfv0wJVFJ9LTwPE+SnMOzQLgl0cSUzDuwDp/HU3K/TrBaK2fSBdtuJvzno/2n5IEcR9QTO6soR8DYR9MpUrd5xgKpStqn7FkOujaRzqOAGT1p1m3V02vSqDh5utXmRGsyT1lQyzlwahUHCmZ3jeYvI3yvUoiw84Mrjbb9AEgOOo/OOPrOm8zF4PQ8p1bFV6EM4ann8zynPKO6MjGyEorxcJIalfdhP6ZxxBKdmTEtt/6oggjEiq9uxI3MLVifCqeubv58LxDVgu15cag2kzN02gKohAYwlxbbynXXnVdfndmU7PNBk
 Cp1eEsAP
 LEp3nACwqBm1eRKeDR0jWB67X0tt0IPdZipnjPmKEQLyjhbJScgunwJSsY/DegmlSA7dhqDpW1GDxI+6IGroPmB/v6uwfjg7y6Znkr1LxwO2J3dstd2hNnFJ66n5W/yaAPUeUFkY/M+aC7o10Hx3PbHY4KNWxQ2qTWtqH0A+xNzUALVKjrxMOxUZadnC+PdwE/dFcRQ+5FZdrYDLYbbtz9NQHz5HQuCr4hE36zYmm30Ton6WRewYSpnQ6GppgGR5AxrF2TYHz/DYJSGmc6K4KIZyddFk2HkJL2e5zYSY2um6wZm8nKLioMPmOnzz8/b6bYorql8eHj2wq4nrujDtUtgSiaqmjl8gDnNz0uZqJU/i5LBfmKbrHqObo7cQ1AN6mHs4oSu4VdsSCt2mLUUZRGii97LVFe275tLZCZC9nDEyLFxY82ZHNd/irc+bEajNH8pHL
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 17, 2026 at 05:03:26PM +0800, Qi Zheng wrote:
> From: Qi Zheng <zhengqi.arch@bytedance.com>
> 
> obj_cgroup_memcg() currently requires a non-NULL objcg, so callers that
> may hold a NULL objcg must guard the call with an explicit NULL check.
> This pattern is duplicated in folio_memcg(), folio_memcg_check(),
> mm/page_owner.c, and mm/zswap.c.
> 
> Teach obj_cgroup_memcg() to accept NULL and return NULL in that case, then
> remove the redundant NULL checks at the call sites.  Also remove the
> mem_cgroup_from_entry() wrapper in zswap, which existed solely to provide
> this NULL-safe behaviour, and replace its two callers with direct
> obj_cgroup_memcg() calls.
> 
> No functional change intended.
> 
> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>

Acked-by: Shakeel Butt <shakeel.butt@linux.dev>


