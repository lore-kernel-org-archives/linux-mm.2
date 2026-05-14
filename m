Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CB518CD4F25
	for <linux-mm@archiver.kernel.org>; Thu, 14 May 2026 09:56:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0E6986B008C; Thu, 14 May 2026 05:56:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0C00B6B008A; Thu, 14 May 2026 05:56:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F169B6B008C; Thu, 14 May 2026 05:56:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id E1E6D6B0088
	for <linux-mm@kvack.org>; Thu, 14 May 2026 05:56:50 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 7BAAB8B488
	for <linux-mm@kvack.org>; Thu, 14 May 2026 09:56:50 +0000 (UTC)
X-FDA: 84765571380.02.C0C32F8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id D79BCC0003
	for <linux-mm@kvack.org>; Thu, 14 May 2026 09:56:48 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=SGW0YnjF;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778752609;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OYPfJ5q+UyOsECqlL9HVghzOksRGdiTxxffAx5CcbNI=;
	b=idBkd9y92qjr82EV1F8VwOVidRA4Cwvx86wj1xtGRhbQ1OHPaVHVsDgCPTIeM85IoFeyWW
	QS+qDCn4uaOmQuYmZsdecWfGTk13Ey8PSXaP/N7sCA8KyzSf6ZsyRkqtAY2cRJdiGwgS0E
	BarUMMJD8sSweBBRKXAMKV7/hqisaF0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778752609; a=rsa-sha256;
	cv=none;
	b=4cP5s2BMPYNhSndfBr6qOrZsIytdnMlzIBwkAcoON71TOT6IiQsdyJqwwk6GpumQQIABdh
	Bj4usI1pldqjMKe1ya8FMwBu51YeIcgpluXnqOZSgoi8kxZxPc6CldDk7k0aBv9nS4RV8T
	QCqczc45pfKy8WMQ1Zzz1N5h1BQ6o50=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=SGW0YnjF;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id C1B6A415F5;
	Thu, 14 May 2026 09:56:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 539F6C2BCB3;
	Thu, 14 May 2026 09:56:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778752607;
	bh=FisyFDYDjwcpF9r2x/lYGWwGIEu3Rtw7Ard6wGtL6Ds=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=SGW0YnjFUXEiNZwZWa0FDCtv5RZtWPsEptBdrt7DYbvB368/hDnqRj1D0UWWSekL1
	 /u6oydDGb0S0OEa+JbELspg6Px2zxMLGSAjvwLX8c4DLwGb6afjGRbHEbE+Yt4IFcn
	 JumnguJxxBn4EY9a1xP/j+24pjkbvZvCu97j7a6WyBMFufUnOsWkjZ4cOKrEQDMKa3
	 f7T7X9E1EnBT6y2TbvFQvgkbR/d7lKX6mI5SHg/iH9iCMi7RBoBiW2+BnQtymMyDOz
	 Je31Y3m9+nneHgAlFyINWEIdfI+lGnDN1BRwbLVH82Vv4OJNk1DcfEfEqvnoPagDZy
	 u0AdINdGkZC7Q==
Date: Thu, 14 May 2026 18:56:45 +0900
From: "Harry Yoo (Oracle)" <harry@kernel.org>
To: Dev Jain <dev.jain@arm.com>
Cc: akpm@linux-foundation.org, vbabka@kernel.org, ryabinin.a.a@gmail.com, 
	surenb@google.com, mhocko@suse.com, jackmanb@google.com, hannes@cmpxchg.org, 
	ziy@nvidia.com, hao.li@linux.dev, cl@gentwo.org, rientjes@google.com, 
	roman.gushchin@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	glider@google.com, andreyknvl@gmail.com, dvyukov@google.com, 
	vincenzo.frascino@arm.com, kasan-dev@googlegroups.com, ryan.roberts@arm.com, 
	anshuman.khandual@arm.com, catalin.marinas@arm.com
Subject: Re: [PATCH 0/3] kasan: hw_tags: some micro-optimizations
Message-ID: <hk5e3gfh7hiiv3wknhkerz4k7qshortncqmkzsto6tn432364w@nidukxmif6ne>
References: <20260513105734.3380544-1-dev.jain@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260513105734.3380544-1-dev.jain@arm.com>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: D79BCC0003
X-Stat-Signature: 4tqarbw6u8j8fmnket79pptm8kzadmio
X-Rspam-User: 
X-HE-Tag: 1778752608-233038
X-HE-Meta: U2FsdGVkX1/glEQMNFTkj7tO5eKy9gzlucE0zDjfaH5putV9DqmicgVO/hDPtw8pwQmKaYmdH/8syDc12Z94R6F8s/mB7mn54a69WlRi+Ae/b68LQ28dsWcDnc3SzCNTII9fqHxSU3eEqbQQ6omxwH2/lTApLa9hVEi0hIUtDWfC5Uz0bUMSD1eyUX0v59M/1vIzRf8kTEsPFhzLKEc6Y7BrEPbw2hFG6b2elGv0K+0HxVasxtQ2EbjiBGNExwhUYi/Hi/lxYXSFFWmuJQWo/KuiSZIQaS4PIj/UKJNIq813HjXsnTZBlY+sv32+7jVf1DpWkq36++oGl57emwCy48P/hjAcgPCn1k03IdJYuIMXjYGZYVuGZJMHgWsn/aWwLGWueGlA0XsKCCw7K0ergF3W2x90jpnzRDdCmiI2cYgdNriCwmmjLs27mI0ihCWO/I/om7Eumx7rOKY/TxoPsYqGJH+itUbztF8ef0fTy4Kyf1BXm27uEw9EyQ9BQYVdsKxZ20l4HNc3ailOLjcS+vZpVRZ0l1uwjlsOb0NR0F8tyfGe9fw8b2xAziKh28Rys0qdWje4NbnZsTFFDKvbVciTYR4RiZKR8yUxq38FZd4vsWc5/IpuOcACJG/rdDbQz01UeURww44lbJ+ZNBaI7t6vq3lTHOQYeF0By8MWrE3Mnsmy9mdfr+8ovw3RyWdDuOmeRS5QerEgFub/fAXyplHgfX/FImY33bVfGVbpF81zLCBSaDvXJU45G2a/5oLfpq1tETy+khFi1ZbwKC5t9CajP/Na1YOOTOnfrYUYFtEaj+4xzXTVBVUTBVI667UkJ7gnZQWnkYIJIrW6+qzyjmrH9CyTPZZEA8FN8/0d2d7vRCx0FmfLp9rZmo8qVaTZTgO3Ff7yubQ/upPQEzgbDTRRT1Mua337pEu8pTbub2p66jsTCx4uXb7ckCvUpQly84e5ZyzvM1lK3ebtFxM
 BR47xHPZ
 HTo4KiKPsdYGfRui2qBxJvcoCCyIkL/ephQsnBVoX7PCjoEd59OhhZ9/+05LiOM6QmBfBG3o23hwUnTeBG238BmEFIVK8viruqANkrZkrLUxiFPbJvaXYTkSPF+rJS2/6/DxhTG+66Ovv+AAX77BBotnAY9hlWN6yeYb1WoILn7Sai+ODbvxeESGmTzs0IFsW/4hmH68mnyiOnSNOAIpwlHuupwPHT9VOWovxTVWndnVSJrWn6mnDXqWBB5HTNE7ylXamcHnyFEtHlkTokCXG5kIzQYnCbg2nbXcDcyvOmOnw8IIDbFtWc/s6ZpqAIqmT1IYsNhAwzrOeoXYnh0rDu8+3K6Yh2PEw5DLcsobfsBJZkJhU3m35h/DqnQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

I have a few questions...

Does the performance of KASAN_HW_TAGS matter?

Yes, the performance of Hardware Tag-Based KASAN matters because
it is meant to be used in production on mobile devices as it utilizes
cutting-edge (to me) hardware support instead of compiler
instrumentation.

Do you have data or are you planning to measure the performance
impact of this work?

On Wed, May 13, 2026 at 04:27:31PM +0530, Dev Jain wrote:
> Patch 1 uses GFP_SKIP_KASAN to skip unpoisoning of a slab page in the page
> allocator, since slab allocator itself poisons the slab page immediately.

If __GFP_SKIP_KASAN skips unpoisoning, why should the slab allocator
poison the whole page (kasan_poison_slab())? It's already poisoned.

> Patch 2 and 3 remove wasted work while poisoning the tail end of the
> vmalloc/slab allocation.

> ---
> Based on 7.1-rc2.
> 
> Dev Jain (3):
>   mm/slub: hw_tags: skip page-allocator unpoisoning on slab allocation
>   kasan: avoid re-poisoning tag-based kmalloc redzones
>   vmalloc: hw_tags: optimize vmalloc redzoning
> 
>  include/linux/kasan.h | 17 +++++++++----
>  mm/kasan/common.c     | 55 +++++++++++++++++++++++++++++++++----------
>  mm/kasan/hw_tags.c    | 13 ++++++----
>  mm/page_alloc.c       |  2 +-
>  mm/slub.c             | 22 ++++++++++++-----
>  5 files changed, 79 insertions(+), 30 deletions(-)
> 
> -- 
> 2.43.0
> 

-- 
Cheers,
Harry / Hyeonggon

