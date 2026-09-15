Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D180EC88E75
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 03:32:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D6CAE6B0095; Mon, 14 Sep 2026 23:32:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D1D686B0098; Mon, 14 Sep 2026 23:32:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C34576B0099; Mon, 14 Sep 2026 23:32:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A10CC6B0095
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 23:32:43 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id EF38A1C2132
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 03:32:42 +0000 (UTC)
X-FDA: 85214574564.25.22E44A0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 242FA100005
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 03:32:40 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=KN3s6g5U;
	spf=pass (imf14.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789443161;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DJtcw4lxYMd8BUGvL3QH2Kt7L1pNOwjIdoeAGicFQhc=;
	b=64Cy7+8f58neMyWUOMbc66ZBsEv8hIWLRxB3pb/QGyopTHvspikEAx5yQZ/dlnpt5NibSH
	PNT5Kw5TYFc8Z7JqbwbE8fclsaVFcyHPude/d0i/K6yHLUhRss3qRvFWMEoMTA/xGFkRl5
	dBmDgZU74olotZymop3sxW/ljbFiQGc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789443161;
	b=HwUbn9lv69MyrtVG6HOfbZ7GLkpXzT4lHJgSf61DZR2DxVPccTLUyksX4/pKx3DvvBqmHb
	oKu7uuld6j4wP1pmA2nz3aGdTBFENYHKzFPVTkhyk7cTgdOodpcZHqv50jYOHBD/v1rR6f
	Rwa9DBSf6vnmUx1lVwdLM4BWdepm3Kw=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=KN3s6g5U;
	spf=pass (imf14.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6CC0641948;
	Tue, 15 Sep 2026 03:32:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 659241F000FF;
	Tue, 15 Sep 2026 03:32:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789443159;
	bh=DJtcw4lxYMd8BUGvL3QH2Kt7L1pNOwjIdoeAGicFQhc=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=KN3s6g5UDIFToTuKC/4IKEROBfIZbHDioOFVA642QfWaU1gexfPME6VKQ1glqN9fR
	 xO5508ebHeJkD4uc/AZHTb9TN5Lw+qX1lN2TYymv9X8m/h02fIJUMv00BjZTQDCzGx
	 NBEmYzVvUWyfNrzjcJ4TzKIT1f7NC2p/6dR3cLjU=
Date: Mon, 14 Sep 2026 20:32:37 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Usama Arif <usama.arif@linux.dev>
Cc: david@kernel.org, chrisl@kernel.org, kasong@tencent.com, ljs@kernel.org,
 ziy@nvidia.com, linux-mm@kvack.org, ying.huang@linux.alibaba.com, Baoquan
 He <baoquan.he@linux.dev>, willy@infradead.org, youngjun.park@lge.com,
 hannes@cmpxchg.org, riel@surriel.com, shakeel.butt@linux.dev,
 alex@ghiti.fr, kas@kernel.org, baohua@kernel.org, dev.jain@arm.com,
 baolin.wang@linux.alibaba.com, Nico Pache <nico.pache@linux.dev>, Liam R.
 Howlett <liam@infradead.org>, ryan.roberts@arm.com, Vlastimil Babka
 <vbabka@kernel.org>, lance.yang@linux.dev, linux-kernel@vger.kernel.org,
 nphamcs@gmail.com, shikemeng@huaweicloud.com, yosry@kernel.org,
 qi.zheng@linux.dev, luizcap@redhat.com, kernel-team@meta.com
Subject: Re: [RESEND v7 00/29] mm: PMD-level swap entries for anonymous THPs
Message-Id: <20260914203237.7cdfcd4c320470f4ae5cafd2@linux-foundation.org>
In-Reply-To: <20260914122950.3283997-1-usama.arif@linux.dev>
References: <20260914122950.3283997-1-usama.arif@linux.dev>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 1hurbjdpzgswmkjir6ttqdfoc4q6ik3k
X-Rspam-User: 
X-Rspamd-Queue-Id: 242FA100005
X-Rspamd-Server: rspam03
X-HE-Tag: 1789443160-269804
X-HE-Meta: U2FsdGVkX19YLECBjkAVUGUXOXUV93mFAtfJOQ45aofb6UcL28e69eAVxhQdPgXzkQqsbvc15OGgm6QI3pHjn7ybpsbLCMZGodb/k2Y021LRLmkn81qoPf1kBgUGXLRZDZabgCa8g3tGbduRksac5kADhztgZVlN68aJgrKba9z1jDpbG1HyGQdbHuSTLVr1RTKKKsiOVi/gzAEZgoRfXMhljZnm47aORPoApCdbVfOyxsM1R24yhJVWA3VPfLeMiGF9+Ou6xMAdw40De7bgM8gsM7dK9PQq/qhC3/Xrvt+5Iy5n+qkwT1U855iktIRpkzH/x8VUY53FxonCUc6R6qOZxfnHAkJELUymlC9voSQDTq3Dbm/EA7XJ5HcRmfQHEN8kLyhv0admVsOnjBoKv9pBPu1Xr222VoElT2ismT6PEv7S+2wxQfxHw06K1K6vCKmCLvytu/32ufUHdTiBi6le7D929dfoP5S0rMIDEeBmcGuJniuOqiqDaeQLLbcC1cYL/FpCAdyWeDqHpPPZLvQ1GtGu4HUBgSwP0E2VefQT5Y/O7iWRENmGV8/7pusavjAhq/0FREx9ubOrPMQUxYJWjqWFyihkMkj8UaQc9BECgaByZkDT+wHx3mN4svn8p5YwO3Y9kShjzmq0Z4GySkpPietnj17uRvTkoCH/bDyen7zzL/jKpuDm3+z+ty8w251h3wUE+YllMIjUf/otJaz7HQDg5hzyRDEAJcjvmlqVOzQSo4bAd+EGT4blh6skM7hjb8TGCwB/QIS+ElvuxElPYchzLjkyGajw5K8Puy1GreHKbtC5k5uxfWy2iMlCp/ebPfYQaAxm6pSsG8OGiGZUhWEGa5m3IulXqu4+jR/Hn55cKkR5JebHdCutUfx7NTpGVK3jfMKMv2aiYR3/hqC7iYWT6jxNepbJe37CEcXmSRUEPGpXv5X+uRvPJifZ06DPD2fdqsZbqrvdBdr
 alGqqC/b
 gKykyVC07s3F4UuGT1rn5u9ax4pyHoGkSqy2XRFXG7jtw1zx32YJHydLUe9Xcsda1c9EoTpt0Zqv0xFZ2gVPh9s+SFuPUTLfcrWXmLyRsbzZmH6o2sMFH5EXirvVc/qI+SxE4VmAwQBLnvY0fOTBb+OxZ2QqncBfdyt8jCl4+rc+u5+oGQWTaomifraT06OZOlWyXVZGPTsMXez/m9nx9qiYZGekArS07TOsu7Kv/NB8A3ntXGM3fStKDsCl6C9qgoaqG
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 14 Sep 2026 05:27:50 -0700 Usama Arif <usama.arif@linux.dev> wrote:

> When reclaim swaps out a PMD-mapped anonymous THP today, the PMD is
> split into HPAGE_PMD_NR PTE-level swap entries via TTU_SPLIT_HUGE_PMD
> before unmap.  This series introduces a PMD-level swap entry so the
> huge mapping can survive the swap round-trip and do_huge_pmd_swap_page()
> can restore the PMD mapping directly on swap-in, without waiting for
> khugepaged to collapse the range later.

Thanks.  I'd describe this as an inevitable step along our thp journey.
Has to be done sometime.

I'll await more review, especially of the core parts: pmd swap fault
handler (#27) and swapout producer (#28).

And it's a 29-patch performance optimization without any performance
testing results ;)  Is efficacy testing in the works?


