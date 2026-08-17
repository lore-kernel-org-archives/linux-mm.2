Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C7793C5DF66
	for <linux-mm@archiver.kernel.org>; Mon, 17 Aug 2026 17:43:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 70F036B0101; Mon, 17 Aug 2026 13:43:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6E7826B0102; Mon, 17 Aug 2026 13:43:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6265D6B0103; Mon, 17 Aug 2026 13:43:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 30B956B0101
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 13:43:45 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 34ADC1C1C6F
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 17:43:44 +0000 (UTC)
X-FDA: 85111483968.12.5EB2865
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id 8ACA340007
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 17:43:42 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=eKkxo1KR;
	spf=pass (imf07.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786988622;
	b=bedxi23eDPCJDD6K75sxXFUA25npeUAninAdLwh0w8yQhPUiV9sb7ZFzvJLZIy5NjmMJZw
	mvgCz8MwKRkpIWt45DCmvv/3SCWza5jhYq9b2cH6iOP/t/zKzb/I2UGJwR4sjzdocA+GOl
	MPGJoz/2MF0GHZet8iqfVNw0ngno0FA=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=eKkxo1KR;
	spf=pass (imf07.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786988622;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ljlKfunao6ScN++sYA+g1iZ+XV/2BXLfKcwWuV93qQQ=;
	b=y3cZYet2YVQCMU9NsJcLYhzMV3Tht1/b3qfYkZwWeZuy/4RHYgdOC8UU0uEGm4AhatNTBS
	Kx+mlyPBP5xP3WYvLT913kE0DFN0TI4bOMXkXCDonS61k0q+Mu6B9YBDdnur6aKuPyutvQ
	1nQvlmKtYS5o3wEB1Mxx9v1KYg6bU90=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 183E9601DE;
	Mon, 17 Aug 2026 17:43:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CA561F000E9;
	Mon, 17 Aug 2026 17:43:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786988621;
	bh=ljlKfunao6ScN++sYA+g1iZ+XV/2BXLfKcwWuV93qQQ=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=eKkxo1KRikpizP51WbuqCMzjbpsMC2EB66RDsQvKs8ZF6hUQ2yzOxhKRJwpwRk0RM
	 SvRpNBy0qrEWJRYHQvfYbb1gFQvJzRVbAKrWOX+MYnlTSghqalzzxK+zA3VajtvzZO
	 mx/iPyqBLKgzIfRv2Gax1+Ob7z8N7wH2yITp70mc=
Date: Mon, 17 Aug 2026 10:43:40 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Usama Arif <usama.arif@linux.dev>
Cc: shakeel.butt@linux.dev, cgroups@vger.kernel.org, hannes@cmpxchg.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, mhocko@kernel.org,
 muchun.song@linux.dev, roman.gushchin@linux.dev, david@kernel.org,
 kernel-team@meta.com, kernel test robot <yi1.lai@intel.com>
Subject: Re: [PATCH] mm/memcontrol: avoid false sharing between vmstats and
 events
Message-Id: <20260817104340.c9bd2dae70d4fa31fd66b216@linux-foundation.org>
In-Reply-To: <20260817103835.2937733-1-usama.arif@linux.dev>
References: <20260817103835.2937733-1-usama.arif@linux.dev>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 8ACA340007
X-Stat-Signature: ox1etz89qrtcc3abkzhpwincatdx1mod
X-HE-Tag: 1786988622-769794
X-HE-Meta: U2FsdGVkX195uv8cUv7nul8WRwBX5xeSpIOfvE7VjD4sBuNFDB968RUyPxtGkMQ/JlsWVCl3eNwn6kqZVy7y+NXLD2UAFvPLyY0nNPTBT+ketfDYx4oQVMbWLrcbD4wtDnbODiDy0fdqn5OCCH9wcz3/87pTwLXzvkBocfH7Im6s/uRXA9W/eLmPleG/GLsuDiToC5LcG1+Nx3BLi8C50C/t5sfmdnS4uw141OWNVSqrc9EjTPIQeURAE7D3bPawoEaKPS0Ifk9V/mpCckUlNPPPTOCSNNr+rb+keYwmttiiIDv/M93NGmVASUFYjz9o3pLXAU7t69mR+ZrB1SB3uEqed37U3Ux6Rm+WyV7gnaGsZFpU4zCM6TkQktIPFVKDW9H8GPZ4zXC0wa7M9k3sCJ/JpjYyzRYT4zr9Z2vqL9Ht6pyxarEZf3bi8fOgDNG1FoD+rV9Ijb0nZ84LjESMLq483N1UMSfkuvZgJbX1R+fnO0G6hLmL5+pdORJJXOpKtE4omR7eW0k/PQLGKyTvQz8ALKg7qmhz/w2ubnWhMuJ0z4luZBfxWB68kjMYfPonXhxT2CZMAKMTtTp8jOHeN5y/VxWWdaswaNtaRrL3VV+8CAmyiOmaXUr532k1httGTypFkCXoo6RLRrA6GTUsCRSF/NmB/WRmQTCgwU9M9CQMvokrvViOrBjQdpoL0yvFXRPEXpMke0vozLpFVnu7WcswyvRQ6ZTodVFdRfImnaJNz0gYwditOerIYEToYnFjbrfQX/uEzX84dPDalYJkQTpMNT3P3nAMwwlq2Ur8BqNhh6mCPV+cnDPJWta2z39kyx8Gq0CvyBatjXXOQ9xuTreP52iMc6sOn1N+p+6Mt2mXx9GmwxrNYnCNpQugmYD87fgCdCnLKxhdSa3o6R/IuolfMFfLD0P0JOWnUL7btZLfyneqKz1vY+U0PNCkCJ0NQ/NYdgk1NO89UG0gaF0
 amI/PVgo
 dZPoxdM0sLMQpQNorcRjeLvDaeqMqWU99sBuCxExEn9VcDs6P5gTaLf8W/ru0uTM5DAkowoCVogC4piqhRDI8nMysNthsw34ENdC2kBdBzzXQDmqdUUe1ehBqoP+s+SqmP1L44YVLKXwEZ4rGoaBZRvBOc2XbnTQR65TIPc0XI068r804HT0Pn8E9QbALFm+ZcjmpZMknVFlxcC8BCN2UzJZ4WCqhph7UWNII6wBAaSSwQuX9gTJii80dMBHVVydJBvMw
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 17 Aug 2026 03:38:35 -0700 Usama Arif <usama.arif@linux.dev> wrote:

> Moving v1 userspace eventfd handling into memcontrol-v1.c shrank
> struct vmpressure from 112 to 24 bytes when CONFIG_MEMCG_V1 is disabled.
> This moved memory_events_local[MEMCG_SWAP_FAIL] and the hot
> vmstats_percpu pointer onto the same cacheline.
> 
> The stress-ng mremap stressor exercises MADV_PAGEOUT with swap
> disabled, generating about 20 million MEMCG_SWAP_FAIL updates per
> 60-second run on a 176-CPU test system.  Those writes bounce the line
> while memcg statistics paths load vmstats_percpu.
> 
> Move cgwb_list into the existing alignment gap and cacheline-align
> vmstats_percpu.  This separates the pointer from the event counters
> without increasing the size of struct mem_cgroup in the tested
> configuration.
> 
> The blamed commit reduced median mremap throughput by 4.38% on the
> test system with one socket. The patched kernel brings the performance
> to within 0.5% of the parent which is within the observed boot-to-boot
> spread (up to 1.2%).

Cool, thanks.

> Fixes: ea928e9e18da ("mm/vmpressure: move v1 userspace eventfd code into memcontrol-v1.c")

That's in mm-stable so I'll squeeze this fix into next week's 7.3-rc1
merge pile.



