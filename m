Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 66FF9C55838
	for <linux-mm@archiver.kernel.org>; Thu,  6 Aug 2026 05:35:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 42D906B0092; Thu,  6 Aug 2026 01:35:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3B6D36B0093; Thu,  6 Aug 2026 01:35:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2CD9D6B0095; Thu,  6 Aug 2026 01:35:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 052CD6B0092
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 01:35:36 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 6854E1205D7
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 05:35:36 +0000 (UTC)
X-FDA: 85069732272.02.0174F96
Received: from out30-118.freemail.mail.aliyun.com (out30-118.freemail.mail.aliyun.com [115.124.30.118])
	by imf24.hostedemail.com (Postfix) with ESMTP id B9FFD180008
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 05:35:32 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=DiqMnpnk;
	spf=pass (imf24.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.118 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785994534;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=D9phiXDHjrSLovQ25oeaKf4LKyu1U2UfKUgGrIYgwmU=;
	b=o5WKVOV0xQJ+uxxfespzK9a3tItkcoOu5n7l+OAd5OvOhEOH/bxvXvIvZ4cSOQW0TAcpDb
	02dWsD++oBzPjkDivRdKJSk/W/1B9Taqwsk6BBwrvNz3vUgtb+aH8YL5+wuxTlK4koT3cA
	toyuDj6DI53Et0cT39GINHlxrduU2Og=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785994534;
	b=V0sO2kbSibQ3yNJvZa5nal4D5leQVIVrqtTCosrqvR2VVJ2E6kANI82dYyYWgKGtCweJIN
	cVRgUo0sk+RLktZy0y7xri8CL8UP54fTJx/gmcf2+iP4Eo/LtqnhQvfaCc7bGErsxugNy+
	IkFC56DvXA3Dn2fSdBnO/NMIVxujDkg=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=DiqMnpnk;
	spf=pass (imf24.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.118 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1785994529; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=D9phiXDHjrSLovQ25oeaKf4LKyu1U2UfKUgGrIYgwmU=;
	b=DiqMnpnk/LJlP09G8MYc33oIx1cvrB7kZ11p1lY3DgPr6AN7ahDRQGNIrd6vaIxyQ5uwVQofo8PD5Ugglk5ZPacjNLVLkk1ZdSoJZrT3nbv+qZG5PSVOemAJjfg+6azKt/LQskH+vM1xR1Abq5GtM/KAV5kGU2VsgaGHko8zFFM=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R121e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033032089153;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=9;SR=0;TI=SMTPD_---0X8T-XQa_1785994527;
Received: from 30.74.144.136(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X8T-XQa_1785994527 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 06 Aug 2026 13:35:28 +0800
Message-ID: <e638aa5f-a557-4990-82d7-e0fa1e246658@linux.alibaba.com>
Date: Thu, 6 Aug 2026 13:35:26 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 3/3] mm: shmem: make unused huge shrinker memcg aware
To: Qi Zheng <qi.zheng@linux.dev>, hughd@google.com, usama.arif@linux.dev,
 brauner@kernel.org, akpm@linux-foundation.org, david@kernel.org
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Qi Zheng <zhengqi.arch@bytedance.com>
References: <cover.1785746588.git.zhengqi.arch@bytedance.com>
 <d23cc0d06527e8085bdef645bdce489d9aa15bfc.1785746588.git.zhengqi.arch@bytedance.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <d23cc0d06527e8085bdef645bdce489d9aa15bfc.1785746588.git.zhengqi.arch@bytedance.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: B9FFD180008
X-Stat-Signature: rx4a67r9o43gb7cgqrw8c5bkg5h81ih6
X-Rspam-User: 
X-HE-Tag: 1785994532-887527
X-HE-Meta: U2FsdGVkX1+3Vq593iiG5PhveafZMBfczBILizf+sc93qeqePF1FIAcy8K3vd0nqDn0RZHMrKawUs9cR627kib408Nb2lCOcOfIcUz1Fm3hOVAOVTYyP71bPfzfykcDiUF8s1vaMSlLjKFIS2sGSWbZ0D/74PchdD3rLiiOPe7ayL4dDdvUdlI0KlrzxtURXXYOtPQa7i9u/mJN8ItwpjnkSh3msIyn3x1itquIk4ZJFPQ+exBr62OH3IErekfheJl4H08LYIoPB4XssJ8Ph8E0wrxZsr1r5sLhc2mWBtH4VhF/eXTrVHVsfDxf63W6jasxFy1IrKvPAKnUzcbuanHGXqT7ZxtOmIN2rDvbyABhxjkxOQD18rzb7NjBRqlM8LFKsu3kaPtOd+w081Zhuw2ioe4IydaQ8QZvawyvKdlC+C5aEuSuhkBho7awA1jfjWyvw1ko2DBh0HvORr4//uNIaU7MWFAJoxqy1FNTVWPWpPRpJOZI3G8lYKGE96TTuLRM8FuVa5MjP5owK+NaXQxwSAxSqjoEeI+oaOSk9dB6gRynxXoOl0WuddthYT35QuGyygeiz2rE0pwBWXYCxIYWL0NwEIhCMRx5BDQ+dR1b48xsgODrpIPC878pgczVuf2pQLwl0XYTSqNfDuMTKLX0TKOTXTbw1UY9BtYaFPEi4m2qbM+leR2hKNrCJ3A/2fzhbqqvYsF1+6lt/v+rDaArd5RgCCvEBuIL9B7ETq1MnhaAlUXF3WR5z6I5p66sN1PhQafo0q4oOMgLnBHlZt8oiDbOFizy0QY1kYs7jDiLmwILHSF3AsIBmCFT1zvmRgT4VPQ9NlRfN5/jXtOqDmLlx6OmmSuDjTX8+UVeD6GztmFKsZiq5FnyCQ0PkpN2g9EZlfxjR490svWKgeCcQOiK3NKhdgKGxhh3dG1cUJ57sn04z5+VLwdOxL725SXpera0tprtzQ+wPTQ9T+rx
 PBSDTn8x
 xRvFFbzK3huCvGdwAilxvL0VJ90VT/6jCLqcaKHqefkq9uZVH4QPEpu9IfQUqmHbPQt6I4uOE/BMYPu9LR2rnzA+nlFn+XhR9/KXiL9poz2A5NgDFiS7veXGQV0xruCY2FCY+IVHfhdJ6PusJMACspsFrCv/r6iSZQPfdMa/uZfHUBBhOsewqL06XLQR8XrAp1bksxu2hHL326DmLkfSdrOpioUPcqxX4IfunUXDYhKeerDPludMFkuwqUfTfKSaHHhRWy9xNaux5JFIiKPzlTyzYF2/9C9E0Fuk9MomHG4MhfHxQDeCn11LCEhXByCF8R+aK07sEAH04c+hocA1lprrAMw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 8/3/26 4:46 PM, Qi Zheng wrote:
> From: Qi Zheng <zhengqi.arch@bytedance.com>
> 
> The shmem unused huge shrinker keeps a per-superblock list of inodes whose
> tail huge folio extends beyond i_size. Since that list is not memcg aware,
> reclaim triggered by one memcg can scan inodes from the whole superblock
> and split shmem huge folios charged to unrelated memcgs.
> 
> Convert the shrink list to a memcg-aware list_lru. Queue each inode on the
> list_lru sublist matching the memcg and node of the current tail huge
> folio, so non-root memcg reclaim only walks candidates charged to the
> reclaiming memcg. Global reclaim, root memcg reclaim and shmem quota
> reclaim keep global semantics.
> 
> The list_lru still tracks inodes while the actual split target is the
> current tail huge folio, so validate the folio memcg/node during scan. If
> the folio no longer matches the reclaim context or splitting cannot
> proceed, requeue the inode according to the current tail folio; if the
> inode is no longer shrinkable, drop the scan entry.
> 
> This can be tested with the shrinker debugfs interface by allocating 32
> tmpfs tail THPs in each of two memcgs, then scanning the sb-tmpfs shrinker
> with memcg A's cgroup id:
> 
>                 before A scan    after A scan
>    base         A=64M, B=64M     A=64M, B=64M (per-memcg count is skipped)
>    patched      A=64M, B=64M     A=0,   B=64M
> 
> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
> ---

Apart from the two issues Sashiko pointed out (which you've already 
replied to), nothing else jumped out at me. Thanks.

