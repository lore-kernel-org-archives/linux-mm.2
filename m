Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 482CDCC6B34
	for <linux-mm@archiver.kernel.org>; Thu, 15 Oct 2026 06:24:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0D9AF6B008C; Thu, 15 Oct 2026 02:24:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 08A0C6B0092; Thu, 15 Oct 2026 02:24:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EE20E6B0095; Thu, 15 Oct 2026 02:24:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CC1C36B008C
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 02:24:13 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 3BA921408DA
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 06:24:13 +0000 (UTC)
X-FDA: 85323870786.16.69FB48F
Received: from mta0.migadu.com (out-89.mta0.migadu.com [91.218.175.89])
	by imf09.hostedemail.com (Postfix) with ESMTP id B41F6140008
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 06:24:09 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=RnzgwFeU;
	spf=pass (imf09.hostedemail.com: domain of hui.zhu@linux.dev designates 91.218.175.89 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792045451;
	b=5n4CxA47JYefMChr/jbk/dms79FOzkkJd0u8Mp/I5DZ8OVzKDUMkjgJb8dc79kGpFKsGBt
	lHbkIY7bSBKTB4wXJmLuJTUbEfTSmHXoAxmvnT6MXQOdpYkHVUWHE/rJCyiynXG+En17lF
	xyu4mbvdwGwTCu4RX9jSdmpeHpnnLgM=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=RnzgwFeU;
	spf=pass (imf09.hostedemail.com: domain of hui.zhu@linux.dev designates 91.218.175.89 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792045451;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pcd7biHNUObkYBunhcKosP0qeLOdBI+t9Nka04BwxcY=;
	b=lp4VgojS+AA1ZWmlv/sMWbBjDgyjxynVpKdaHJuHU+OyCfl8vJ/qv3RXz1KUF1uBvCNki1
	0MMXRlP+VcSx7RkaChidG6IVwUDtnb6yFIWvy+UMEnAfh+x4bN4OjnE1lZ1jMwfnF7AeIj
	xQP019JxhCicj80tu8ooDT6KW02CG2o=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=xzxTDP1kJen/uCrhE9uPE6+rH/MP3btycDaiyOCiueA=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792045446; v=1; x=1792650246;
 b=RnzgwFeU88f6BI4zgBBNdIygjAMJ3BZjmdDlRyFOlyHV+KyIxpf3GKSgFibzH+rU3O52dIke
 mMUSfah2Ekqy7w4PY4YWQn3pWpcsKIR2ss2DS+VPZIX5z+TbGwn/COKfvRR+kTQ4wRHdBgZGIZY
 E/LCa8Drk0DofYzdd62E+RG0=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 539d3ab3f892d32c;
	Thu, 15 Oct 2026 06:24:06 +0000
X-Mizu-Trace-ID: 539d3ab3f892d32c
X-Migadu-Flow: FLOW_OUT
Message-ID: <fd35d9dd-8fc9-4cec-97d8-86917bb3c216@linux.dev>
Date: Thu, 15 Oct 2026 14:24:01 +0800
MIME-Version: 1.0
User-Agent: Betterbird (macOS/Intel)
Subject: Re: [PATCH v6 0/2] mm/vmscan: fix NR_ISOLATED accounting and throttle
 MGLRU eviction
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Barry Song <baohua@kernel.org>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
 David Hildenbrand <david@kernel.org>, Michal Hocko <mhocko@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>, Baolin Wang
 <baolin.wang@linux.alibaba.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Hui Zhu <zhuhui@kylinos.cn>
References: <cover.1791968227.git.zhuhui@kylinos.cn>
 <20261014160910.eeaa24697b614d1b94806d0d@linux-foundation.org>
Content-Language: en-US
From: Hui Zhu <hui.zhu@linux.dev>
In-Reply-To: <20261014160910.eeaa24697b614d1b94806d0d@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: B41F6140008
X-Stat-Signature: owwjrigfr4degma9hypnukf7zxgrr475
X-HE-Tag: 1792045449-632315
X-HE-Meta: U2FsdGVkX1/3Web+kjSxxqjEVotDcBFtgA13fXvjfATrEc+dRd8k8za+zHO+EJJ4BWDALzVES5qIZoo+83UFAQaj5hLXogbpW+BYWmURl9bIqYi0NXJZq3TYY0G2/wFBTcIUq5fqVHIvXRKjBj3BBmRAYD4u3j1b2W+lvgvrCI+JT5n/7qtZsgTV3xViIi7AbE7lD8oA+YRDvIF4IhhTf9FTkOCDqKRCrvtuMCJnezCC8o/ihdPptbhpo+j0ha4UuCedn96x4kQabo0TCbq1QcumK8mIiphb5l42OVnE10/ZN4Qyt7qasNSXyX7uwR+9C2BAqcbu+m3Qf2kX6NRksG0JgeigDGj4CQnyDuPDkyiB+Jc/YxDRLF9hngSUA/U3fPupwYnfWRqc34qUDvrDObycegs0FwnlWdzGaRXN3Z7iQ4Kty0xluvlKiypZm2d0HjuWLDCz+GN2x/Ma46P3SieuDIoiMgefnMjZ8M/zkWutXJmnLQ+i7REAr1RC9jQFvMJrHoeMoqyLMiG/MkIpuzNKcdACHnbUp6FLeLz78/r3I+xNWDIdKKnJ8dk+cSA0pmW4vH8utQKca1nQbdMWHwkekI2XGvXzvezTZyHImquGL6nSBcC4UWPRd7o66cjBdUFpdEzaEVyCRXl0tFVDlUaAqcRsIlxr4s66g+k3fP4hTWexZPUQsefYZ7xVfsZo5rkHSCeqM9pS/UTbX20y6fKOIlwMbnHwKWEvPoIBxvIydg/ZYXyrd75nyYnkUpCdqbN9wcS8zhZTPKV1zA5k6ge2LWYYZ+cZL5JOmSG/txHTJraRpfLI8fTH7xJGdVwvgEzFB1bc/Di/YdHtoyMtja3Sfc6fi2oOXMJT24l0HVn1BeqYyCxej7P0s/GfxoXCQW29RbDGeb/RuBCEEHhBSU7VKycFHOX9OhgxRGMaJAtiQgeAFXpeKRpQIOhevKomjn4cGyOO1J/voG6rNsm
 BcSKpCrL
 Y45J+ys27Mbp9qfXzW85WDhC9IHplIwje8mtc5GllpsC2ZhYF+P4HVD4cHCT2zdql2heYfon4ObDVU0Mynnm4erN4r60SrKV7WOeHRW3iBJJPpB+3VzuEUzNaCtCrlxBUW4zJJzWHfqrEjTP/KEpwgibNH1lntucGFLopiTE3mKooIkcmRuXSBdUVt4Zrw7XI/45N+b66aVrS7TF2Gvrp+cpeL6ORCSxKfkyFpEhLiZchYXd3HUtnm5gkZA06T2dhNNhRNpDQAd4p2Oov/xMnltFzEnNdT3T3pUfHuNx2+dTuQP2KiCD4PhEUe1yk2YbcLPu9QggCusNRapF8h5WHL9at/d9d/SHG081Q88/NJZ4eGnyMm56khRmzQTWWnf6ZJD+65OaSR4OSBhDNXoh4eQpKTg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


在 2026/10/15 07:09, Andrew Morton:
> On Wed, 14 Oct 2026 17:00:22 +0800 Hui Zhu <hui.zhu@linux.dev> wrote:
>
>> The legacy reclaim path has two mechanisms around isolated folios that
>> MGLRU lacks:
>>
>> 1. NR_ISOLATED_ANON/FILE counters are updated when folios are isolated
>>     from the inactive lists. Compaction's too_many_isolated() relies on
>>     them to decide when to back off. The MGLRU reclaim path never
>>     updates them, so compaction cannot see MGLRU's in-flight isolation.
>>
>> 2. shrink_inactive_list() throttles direct reclaim via
>>     too_many_isolated() when isolated folios pile up. MGLRU's
>>     evict_folios() isolates folios without any such check, so many
>>     concurrent reclaimers can over-isolate the same (oldest) generation,
>>     leading to unnecessary swapping, thrashing and premature memcg OOM.
>>
>> Patch 1 fixes the counter accounting in the MGLRU isolation path.
>> Patch 2 adds a per-lruvec throttle, mirroring the legacy behavior but
>> adapted to MGLRU's per-lruvec contention and its dynamic type
>> selection/fallback.
> Thanks.  Questions for yourself and maintainers:
>
> [1/2] is nice and simple and reviewed.  How about I queue this for
> second week of the upcoming merge window?
>
> [2/2] is much more code, isn't reviewed and has a Sashiko whine[*].  So
> I'm thinking this is 7.4-rcX material.
>
>
> [*] https://sashiko.dev/#/patchset/cover.1791968227.git.zhuhui@kylinos.cn
>
Hi Andrew,

Sounds good to me. Thanks.

Best,
Hui



