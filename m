Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5F020C98310
	for <linux-mm@archiver.kernel.org>; Thu, 24 Sep 2026 07:53:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 600B46B0092; Thu, 24 Sep 2026 03:53:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5B15F6B0095; Thu, 24 Sep 2026 03:53:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4A3176B0096; Thu, 24 Sep 2026 03:53:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 22F6A6B0092
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 03:53:47 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 9B7D9A59AB
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 07:53:46 +0000 (UTC)
X-FDA: 85247891652.19.9F43C43
Received: from mta0.migadu.com (out-98.mta0.migadu.com [91.218.175.98])
	by imf20.hostedemail.com (Postfix) with ESMTP id DE8DF1C0003
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 07:53:42 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=sImwVlCN;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf20.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.98 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790236424;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XQbEpsznh3I4fa97ckUgg8fNUgwt1b2L8Y+S/9lUej8=;
	b=MaR0cPqUQCU8W55FFqRFcfg7b0YQWTOMWAf7pbHOkeBNbRF3DbhXS4VbKFdbR2hsNBP9lT
	eCw9Rni87JCwZLq3Rcztk4xFNh8Mp6yneaLKcxQQQZuaXfQsBVs2PSHnaOINKuaIHKP3cl
	pWoSGHY/LPiI7edE23bj9vNabhGNr2I=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=sImwVlCN;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf20.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.98 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790236424;
	b=MhrZPocgxvY57BfMvptq8vPmkHhD6Nk1ESyZWFbj4BQ6NgA2Gn4o/W2toIrkigtnF2u4oU
	s8MZ8ZZbeqAa1qqqEXVfwvrW08ofpg7/zHKdyD+KXKDw8bOC+r+APUt55CoCMBCW+yOru3
	8ppXGF5u5JquAsQ/QynPavGPerN/AD0=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=tmFKVXcIZq7e/z6sePm5F4/lrwU40o91QzXOAC74BWg=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790236421; v=1; x=1790841221;
 b=sImwVlCNFoqNyIjOHL50qCBHAiwC0MyJcCg+3QynaSNtr9xiNzGDI/Qa0ty4U+Qx7uEls5PM
 tN++U+qS1T2FVlXhbIEgx2yGOBCoeiZxmeLWfblpAGliMzMrD71b/j1uelAXH8bAuuTl1sm5OCu
 8iPQ+NDegz9SzQ8mwxl1EvQw=
X-Envelope-To: linux-mm@kvack.org
Received: by mta11.migadu.com with ESMTPS id 8c9537f07561259a;
	Thu, 24 Sep 2026 07:53:41 +0000
X-Mizu-Trace-ID: 8c9537f07561259a
X-Migadu-Flow: FLOW_OUT
Date: Thu, 24 Sep 2026 15:53:33 +0800
From: Baoquan He <baoquan.he@linux.dev>
To: Klara Modin <klarasmodin@gmail.com>
Cc: Chris Li <chrisl@kernel.org>, Rik van Riel <riel@surriel.com>,
	Gregory Price <gourry@gourry.net>,
	Johannes Weiner <hannes@cmpxchg.org>, Nhat Pham <nphamcs@gmail.com>,
	Kairui Song <kasong@tencent.com>, Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Yosry Ahmed <yosry@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Barry Song <baohua@kernel.org>,
	YoungJun Park <youngjun.park@lge.com>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	"Lorenzo Stoakes (Oracle)" <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	"Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren =?utf-8?B?QmFnaGRhc2FyeWFu77+8?= <surenb@google.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	Wenchao Hao <haowenchao22@gmail.com>,
	Jonathan Corbet <corbet@lwn.net>, Hugh Dickins <hughd@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Tejun Heo <tj@kernel.org>,
	Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Kunwu Chan <kunwu.chan@linux.dev>,
	Meta kernel team <kernel-team@meta.com>,
	Linux Memory Management List <linux-mm@kvack.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	linux-doc@vger.kernel.org,
	"open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)" <cgroups@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Kairui Song <ryncsn@gmail.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>
Subject: Re: Path forward for Virtualized Swap?
Message-ID: <arTW_QJmL5PFev-X@fedora>
References: <CACePvbXZ4i-DsmbQdNtBQb79y59uwZC9J8qHD2wTWpcYaet3LQ@mail.gmail.com>
 <83539be885f15bb567b30264f5f62e718f4a9fd0.camel@surriel.com>
 <CACePvbXZQERwLF_f2FYTHsv--kq_-Aw2vVVFF+z+ovdnsHy1bA@mail.gmail.com>
 <arKbXe1Qe-FDCTMM@gourry-fedora-PF4VCD3F>
 <CACePvbWW4avTV2WB6iRU+LN5zqkMTg3UhBrq41R0iw91-7Ni0g@mail.gmail.com>
 <5a7ad159b2fabf377b7e1fc4248c433287ac11fb.camel@surriel.com>
 <CACePvbUtEdQLmmudON_qC2aKuLYCNktBuAecFKiSvDC6eTfXeQ@mail.gmail.com>
 <arO0RCCE3Woh_I_z@parmesan.int.kasm.eu>
 <arS6dvzAI5XLHuG-@MiWiFi-R3L-srv>
 <arTNdz2P4ZZZfruh@parmesan.int.kasm.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <arTNdz2P4ZZZfruh@parmesan.int.kasm.eu>
X-Stat-Signature: xt8mstw8hmijpx85jx43eaq6jc9di31r
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: DE8DF1C0003
X-HE-Tag: 1790236422-436536
X-HE-Meta: U2FsdGVkX19qz+cytirS98wxVjmd9vreSP10Nfs3jmfpibczjS6ljLNimtzQDlOB/ISrt06hTrtVbsuPmWR1x+BNNFB6lCpKs5ldRXJbGderHToZZZmMuS8bHbZniVL0Y6rV6Wu2/QlMNS3aIeh/QDUQZt8WJN9NsHXKhhQoPOOxL3Dy/UzXxonoxy7Ud3ZaqDk3rWRN0zAvUw4xUPTUSZiWx1KFMpKpyL8uhh8HbYHM/6bPDgPvFmUSDRfowM8wOWA0BVD1gNncuHqjDXsTeY34IqCEsQVyLkzwS4aM6Y5KdhD0eG6VhDDlI8mATK023s4YQH0mjw+vR+0t5i0Q6WBLbQ40tmS72w/FQaxvDIOA2UWz4Zklh2DHFk0UNcQy5OBJv1qrUw12f6IHJm4tx36yx217NPzBIKF1RISENlmKAaRotOQT3XV683ZIKAPvOZRt9mNRdBQmunPkSfWUy8QBKyIjpJ1x6TMsh2pbR760qA1VlfRZzDeSYFg0clRc39cRlxGR+pQRswHZ62p7KRL+Lxmq5mcUu/ECRvMIbfb4dBoO7PCL+65kzbFHpVEMKQsUyP6D24atSmHIFwAALTdiA/bsdo6taKnb+rcHIx8jZT/VJwIlWOM96hyrSgIxcNT1R7j3zoAgrUo8cXLBCFwzYuCLklLGGmOpRdrb4lMPfpvURieL/D6AYfZCIFmJZ9uqA+CzIv/gy9gEkClYLKOEDSS0aTjfYGirnuZ6uIxBBMyrRehT+k0Cws/o9Xl9kpln790fXs5nOht9eRGxot0+fD0MAAIA+hjMJL4BcYHqAs1Rjzh1IdNS+QcGFDMAZG2546ejZbHOZCtY4U1eEtakJ7Z8gZkh63p8h7yzYcRFjC5Fxf7CB3qTwkWxUT9tTdvmcuU94yjgfbIb80SGhxyZtNdR5W28gsRyAlXaUrdzsdXEKu7aZHMqX2HI1nkfWRPoddU1L0vqslH2IS4
 P3KTHQFc
 M/baN4Ti7o+PZVw/orMAK248EApcA52dLdXhAxVmZIRaZjMTbdgildZy4cSreyaQymDRVo+66xuz6SzBi4uxi+1gZObZlMVVjvKHh3H7BSaot0VpLyfOOTN6vDNSaG/UCaxbTDU78AxJGegXsc/IlGoDSdn0rHAd+Z/AhJCv/QKV+jnHTkVGXAt1P+wGSMd35yP1ZoLhmT+THJ+rCS7cdlHeDYTNVQoV6cj7PKq4IE0pBryMEbwvxbol1CuDTHSEqZH5nRM5ZlfcKqXObVq4TwcJqz/zBN/PljSZOfLimUox7n/fALfXfmsu80sVorWSONxsCEyDRWwYbnwoKKtWk+ziX/3Qi67OgyWfh0Rjk07CJ1XIN0m//IKS/rTmWTdPP+eDNwwkGGrACFqAsWw0F8ckMz+mJfJjW1SQ7
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 09/24/26 at 09:20am, Klara Modin wrote:
> On 2026-09-24 13:51:50 +0800, Baoquan He wrote:
> > On 09/23/26 at 02:52pm, Klara Modin wrote:
> > > Hi,
> > > 
> ...
> > > 
> > > Chiming in as more of a user perspective.
> > > 
> > > On my 4 GiB BPI-F3, I can reach more than 10:1 compression ratio on
> > > zswap during some parts when building GCC 17 snapshots. E.g:
> > > 
> > > MemTotal:        3966864 kB
> > > SwapCached:        31872 kB
> > > SwapTotal:      16777212 kB
> > > SwapFree:       16638128 kB
> > > Zswap:            280140 kB
> > > Zswapped:        2859840 kB
> > > AnonPages:       2927376 kB
> > > AnonHugePages:   1409024 kB
> > > 
> > > While this is 72 % rather than the 100 % you asked for, I think this
> > > shows that what size a potential limit on the uncompressed size of zswap
> > > is suitable heavily depends on the workload.
> > > 
> > > I have been using vswap consistently on all my machines since about
> > > August, and I have also tried one or two versions of xswap (but the
> > > current lack of writeback makes it inconvenient for me). I really
> > 
> > Thanks for testing xswap and reporting issue on xswap rfc v3.
> > 
> > xswap has writeback now. I only built foundation for xswap, while
> > writeback part was left to other people for collaboration. Finally
> > I added it.
> > 
> > [RFC PATCH 00/17] mm, swap: xswap writeback to a physical backend
> > https://lore.kernel.org/all/20260920072043.430390-1-hebaoquan@kylinos.cn/T/#u
> > 
> 
> Thanks, I'll give it another try when I have time.

Sure, no hurry. Thanks a lot!


