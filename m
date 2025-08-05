Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2ED08C87FCB
	for <linux-mm@archiver.kernel.org>; Tue,  5 Aug 2025 23:59:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AF0088E0006; Tue,  5 Aug 2025 19:59:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AC7A18E0001; Tue,  5 Aug 2025 19:59:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A04B28E0006; Tue,  5 Aug 2025 19:59:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 900798E0001
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 19:59:54 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 29B42140231
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 23:59:54 +0000 (UTC)
X-FDA: 83744374308.29.939B0AD
Received: from invmail4.hynix.com (exvmail4.hynix.com [166.125.252.92])
	by imf19.hostedemail.com (Postfix) with ESMTP id 785061A0004
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 23:59:51 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	spf=pass (imf19.hostedemail.com: domain of byungchul@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=byungchul@sk.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754438392; a=rsa-sha256;
	cv=none;
	b=FD2xDrI8clq5e/qIlIH4oVuh7LU6iXoPGCpPMnl65tftZpTKJ92Y9II57lNWAc+3MIo39R
	CPS6oHC7xzDvaFz+Jb3oohFcJRQosv4D9f8RJa0fWxrDI58bLLoWjjIVbhw34m9W33PlqS
	AcRRF61PG6AF7wt8LKnyKwknBDUr0eI=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=none;
	spf=pass (imf19.hostedemail.com: domain of byungchul@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=byungchul@sk.com;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754438392;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5JL8jnvobkbM4VKc+fVw+a16FXpkbfBu4M8aK71Ytww=;
	b=dFxElsnuKJfruwc6WX1SCi+Y0y4YHzUkBOZs/gsX7n9cB9PGI/YBUggLR03dEhQLWSutqC
	a2LdHALMyaILTrYJSUi2NV2LMfHiWz41Fhvd7NTagnHAlEy/Siij6TqhW/FJKoJ1XzGDC0
	TBnle9fg2qaQFrssgvV8a6+J2Fg+23g=
X-AuditID: a67dfc5b-669ff7000002311f-02-68929af3b516
Date: Wed, 6 Aug 2025 08:59:41 +0900
From: Byungchul Park <byungchul@sk.com>
To: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@redhat.com>, SeongJae Park <sj@kernel.org>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>,
	Gregory Price <gourry@gourry.net>,
	Matthew Brost <matthew.brost@intel.com>,
	Rakie Kim <rakie.kim@sk.com>, Zi Yan <ziy@nvidia.com>,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	kernel-team@meta.com, kernel_team@skhynix.com
Subject: Re: [PATCH v3] mempolicy: Clarify what zone reclaim means
Message-ID: <20250805235941.GA53923@system.software.com>
References: <20250805205048.1518453-1-joshua.hahnjy@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250805205048.1518453-1-joshua.hahnjy@gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupgkeLIzCtJLcpLzFFi42LhesuzSPfzrEkZBl2LhSzmrF/DZrHrRojF
	1/W/mC1+3j3ObnF86zx2i30XgeKXd81hs7i35j+rxbc+aYvDX98wWaxek2Ex++g9dgcej52z
	7rJ7dLddZvdYvOclk8emVZ1sHps+TWL3ODHjN4vHzoeWHucuVnj0Nr9j83i/7yqbx+dNcgHc
	UVw2Kak5mWWpRfp2CVwZOxefZiuYKlqxa/U3xgbG6YJdjJwcEgImEncnNzN3MXKA2ctbvEDC
	LAIqEs/bbzGD2GwC6hI3bvwEs0UENCVOtE4Csrk4mAW2M0vsOjiLDSQhLOAk0XHjPSOIzStg
	IbFj/3x2EFtIwE5iz9v1bBBxQYmTM5+wgNjMAloSN/69ZALZyywgLbH8HwdImFPAXmLvxF2s
	ILaogLLEgW3HmUB2SQi0s0vMe7OPGeJmSYmDK26wTGAUmIVk7CwkY2chjF3AyLyKUSgzryw3
	MTPHRC+jMi+zQi85P3cTIzB+ltX+id7B+OlC8CFGAQ5GJR7eDNFJGUKsiWXFlbmHGCU4mJVE
	eGPq+zOEeFMSK6tSi/Lji0pzUosPMUpzsCiJ8xp9K08REkhPLEnNTk0tSC2CyTJxcEo1MJoa
	z3aetfW6B9OE04sbKtpWx3lu5X3qzvU/wuvbVMddnyfeXP5v2hHTPQ9/XtqxWcEqyuxmFG/m
	HMXzZ10YfbLsGSMuPrp8QGOF+bN3a3/fbOOZXmEjfe3lEovJlilbD8Zx1R1bIHNhkd+yP0zn
	/1k/bgm2jH6v1PnFcaezjcexTN6FZ7/t8jqpxFKckWioxVxUnAgA12be3ZsCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrBLMWRmVeSWpSXmKPExsXC5WfdrPt51qQMgyMTGS3mrF/DZrHrRojF
	1/W/mC1+3j3ObnF86zx2i30XgeKH555ktbi8aw6bxb01/1ktvvVJWxy69pzV4vDXN0wWq9dk
	WMw+eo/dgc9j56y77B7dbZfZPRbvecnksWlVJ5vHpk+T2D1OzPjN4rHzoaXHuYsVHr3N79g8
	3u+7yubx7baHx+IXH5g8Pm+SC+CN4rJJSc3JLEst0rdL4MrYufg0W8FU0Ypdq78xNjBOF+xi
	5OCQEDCRWN7i1cXIycEioCLxvP0WM4jNJqAucePGTzBbREBT4kTrJCCbi4NZYDuzxK6Ds9hA
	EsICThIdN94zgti8AhYSO/bPZwexhQTsJPa8Xc8GEReUODnzCQuIzSygJXHj30smkL3MAtIS
	y/9xgIQ5Bewl9k7cxQpiiwooSxzYdpxpAiPvLCTds5B0z0LoXsDIvIpRJDOvLDcxM8dUrzg7
	ozIvs0IvOT93EyMwPpbV/pm4g/HLZfdDjAIcjEo8vBmikzKEWBPLiitzDzFKcDArifDG1Pdn
	CPGmJFZWpRblxxeV5qQWH2KU5mBREuf1Ck9NEBJITyxJzU5NLUgtgskycXBKNTDWq7FXTd1T
	78/NsyvQU/fszcbwaw/Nphdqn7i87PL9wuO3PJhE3onfdDd53GUheGGqZ4B6deE/jtPXfj85
	6rjB1Wnj9kWduu/6W6+nftsx/dIu08BGo9tcQsWhzgvDPs578e/NrN1aC5stE51mPZk7z8h7
	shijwJu5j3Qrsj2nWyzy0DmfMvmWEktxRqKhFnNRcSIAgiVw8YsCAAA=
X-CFilter-Loop: Reflected
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 785061A0004
X-Stat-Signature: ai7imzjqh5ssrjtufr4u196yenqsxx6x
X-HE-Tag: 1754438391-69631
X-HE-Meta: U2FsdGVkX18Q9hmXzPSJzyvz0sAUk3pGRitpxhS6sO5uHXUDAmQ+5/ydSRq/MzU0GHmwlCyvWIYSosACzqXXN9N8/gI6Ku92BG0evAsR+ajzgmdD8wcjwKd7iqzOjocwDNunLjGOURF4ER1AE1CeZb8vUG2EaMfA0tofnwEuEeBIOtm24Kcqtfz3wRxypwgVQDSdyPN4jUUq0TWbF5Zdx3GcAmxgkqWK//airYBFNENU2xxA/MnICxYyJ46hgFN5oJsWjnBNNb1+e6i4oZM3ffurUAUiEeZS8SXnsYDh8yMPctH+2UIvh2X+SY2fe0P+reVJXIbqfuoBoWy7TPNtO3Ahh0X/2At9THlD/zWfnxbz66YtK2P4GWw+4e7+FpTttdT3anm3l9kBKDr9oLCEqyoFoEZozgx4f6USAXRMh4EVoKrcSnU7XPtWz54TSDLXS5SBBi1F4iELIy2fRyBq1UVgPE1le8TZf9pdKMbyj1+sFBdv3J01Wy+yCyEeisQgN9UPNcCDLz330R/1u/RTl3SceV1poavktcsGWUK0BwtL8escg/9+Chz+Nsk+A85y7efsgBGu/DacY9B1Rv+Lzk91H/6I2q75t/DjOp4EEpRhhs+cDkUZ3k0pa+8/gZZ9Im86aAPFS26jmo64Mm3a6SGF5mJCFZ/r05fVBAt2wIXWxLCh+ocwlhq1UWeAcjdi68BZsXflXDph6kgkJajC3YLv6hJCgAtEUQFmbKjdQdI2V0MN8cWvkiUamPxgV7s2eIskoJUKIe9NjbOp1b5jV1syKMw1HzABJmlyRxJb4vmrNFGaMZd3WWLfkFaQEn6fZhpYc3G5NH8mrMk4AeITs7Q8DFJEIt1WoyogJ0gXDu4DUwsY1rssw8c1bzsagkBDQLnSe/eIydzj4uJ0sEs6ia+nvzPnCr+Ruo7BewgRKIVtdSjyuGVoanSwKAMMlDFeT+O6aIjfl/yniSzc7hG
 vroeR1k4
 nH60kGFHLQi3A+O9Rd820R7+fdJu8YbWZXe7EszynIQuL2Nd/KuGrrF691eNS/pyyIDjg0ee+pV7uG0F5aMWk6gJdTeOz2zRPN5KtHZyXnI6yIh72n8VcKv4cholfdHnrogXsm/7+YVGh95/uyn6kGGpUUDOCsnrMrqVE
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 05, 2025 at 01:50:47PM -0700, Joshua Hahn wrote:
> The zone_reclaim_mode API controls the reclaim behavior when a node runs out of
> memory. Contrary to its user-facing name, it is internally referred to as
> "node_reclaim_mode".
> 
> This can be confusing. But because we cannot change the name of the API since
> it has been in place since at least 2.6, let's try to be more explicit about
> what the behavior of this API is.
> 
> Change the description to clarify what zone reclaim entails, and be explicit
> about the RECLAIM_ZONE bit, whose purpose has led to some confusion in the
> past already [1] [2].
> 
> While at it, also soften the warning about changing these bits.
> 
> [1] https://lore.kernel.org/linux-mm/1579005573-58923-1-git-send-email-alex.shi@linux.alibaba.com/
> [2] https://lore.kernel.org/linux-mm/20200626003459.D8E015CA@viggo.jf.intel.com/
> 
> Acked-by: SeongJae Park <sj@kernel.org>
> Acked-by: David Hildenbrand <david@redhat.com>
> Reviewed-by: Huang Ying <ying.huang@linux.alibaba.com>
> Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
> ---
> v2 --> v3:
> - Fixed typos
> - Softend wording from "never" --> "should not"
> 
>  include/uapi/linux/mempolicy.h | 10 ++++++++--
>  1 file changed, 8 insertions(+), 2 deletions(-)
> 
> diff --git a/include/uapi/linux/mempolicy.h b/include/uapi/linux/mempolicy.h
> index 1f9bb10d1a47..683c130782f0 100644
> --- a/include/uapi/linux/mempolicy.h
> +++ b/include/uapi/linux/mempolicy.h
> @@ -66,10 +66,16 @@ enum {
>  #define MPOL_F_MORON   (1 << 4) /* Migrate On protnone Reference On Node */
> 
>  /*
> + * Enabling zone reclaim means the page allocator will attempt to fulfill
> + * the allocation request on the current node by triggering reclaim and
> + * trying to shrink the current node.
> + * Fallback allocations on the next candidates in the zonelist are considered
> + * when reclaim fails to free up enough memory in the current node/zone.

I was confused too, at the beginning.  Thanks for the explicit comment.

Acked-by: Byungchul Park <byungchul@sk.com>

	Byungchul

> + *
>   * These bit locations are exposed in the vm.zone_reclaim_mode sysctl
> - * ABI.  New bits are OK, but existing bits can never change.
> + * ABI.  New bits are OK, but existing bits should not be changed.
>   */
> -#define RECLAIM_ZONE   (1<<0)  /* Run shrink_inactive_list on the zone */
> +#define RECLAIM_ZONE   (1<<0)  /* Enable zone reclaim */
>  #define RECLAIM_WRITE  (1<<1)  /* Writeout pages during reclaim */
>  #define RECLAIM_UNMAP  (1<<2)  /* Unmap pages during reclaim */
> 
> 
> base-commit: 6bcdbd62bd56e6d7383f9e06d9d148935b3c9b73
> --
> 2.47.3

