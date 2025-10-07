Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C855CCCA476
	for <linux-mm@archiver.kernel.org>; Tue,  7 Oct 2025 22:00:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 037778E0005; Tue,  7 Oct 2025 18:00:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F29B48E0002; Tue,  7 Oct 2025 18:00:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E184B8E0005; Tue,  7 Oct 2025 18:00:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id C9B818E0002
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 18:00:00 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 7CAD813A89F
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 22:00:00 +0000 (UTC)
X-FDA: 83972686560.20.024F1D4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id A84FB14000B
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 21:59:58 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=eqTBKJ2M;
	dmarc=none;
	spf=pass (imf09.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759874398;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Yv9O9R181QREhkQ5a4cmT+VfOGb+38KNvLpIfqV1KKk=;
	b=p/PbDHwSYQUsuGNzjYEb8uaUHqH/1UebllcmfCf6nkJogOc2urIpKnXY3iGTODgA0T2WxL
	L6ke1uqAZzV8dHPPN7ddGH2zyeunXACja2tWMIan/bpJ9D9byGhkUzgn5/zqZNeCZIltxN
	IUGw3ppMg8FRTkuu0Xsz/h+oDmajo3I=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=eqTBKJ2M;
	dmarc=none;
	spf=pass (imf09.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759874398; a=rsa-sha256;
	cv=none;
	b=iL0aZx5xN2ytxNP01ENocZa+EUbH4mqXYgRn9ak3qOOzsc1Jdu3mZD+lnqBFzRZ8ymfYfk
	WI5nk/feVqiVevWUEovXfSX6dkk1q8676+BO+rOb0spwf1A2ZlDKXsNenvlX+VG5Pb+ntJ
	5zXAqtR5NRlt3Z4DBhaxAr+tWFpyFj8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 500F04045E;
	Tue,  7 Oct 2025 21:59:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94009C4CEF1;
	Tue,  7 Oct 2025 21:59:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1759874397;
	bh=ehRXRPc5gq4sto6XUaGVVNc4Uvx89XC3Wfecl1rHaAg=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=eqTBKJ2M8ObGhNoqy8DBYa55islBZD7ZRmjTMTsXwVL99OoeyEL4uo6QHewJll/Vv
	 MLm8Zlu0p6IOruOhar0793ib45TmpBnhcl+5W6rW9hSLU1R8vV3kPSmzNJLoF7X8Cz
	 issd+zGW5zc6o2ZuYQfIE0VzhoVU1SvQjo+Rmvxg=
Date: Tue, 7 Oct 2025 14:59:55 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Gregory Price <gourry@gourry.net>
Cc: linux-mm@kvack.org, corbet@lwn.net, muchun.song@linux.dev,
 osalvador@suse.de, david@redhat.com, hannes@cmpxchg.org,
 laoar.shao@gmail.com, brauner@kernel.org, mclapinski@google.com,
 joel.granados@kernel.org, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, Mel Gorman <mgorman@suse.de>, Michal Hocko
 <mhocko@suse.com>, Alexandru Moise <00moses.alexander00@gmail.com>, Mike
 Kravetz <mike.kravetz@oracle.com>, David Rientjes <rientjes@google.com>
Subject: Re: [PATCH] Revert
 "mm, hugetlb: remove hugepages_treat_as_movable sysctl"
Message-Id: <20251007145955.31dba3afad6200e885e906a5@linux-foundation.org>
In-Reply-To: <20251007214412.3832340-1-gourry@gourry.net>
References: <20251007214412.3832340-1-gourry@gourry.net>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: A84FB14000B
X-Rspamd-Server: rspam03
X-Stat-Signature: d1h9p67p7a7egyqnjc5okrwndirw36kj
X-HE-Tag: 1759874398-901868
X-HE-Meta: U2FsdGVkX19QJmkzcOEjXbWZcWpWgurLtNkH5bptTC7w2ONFq2/xTjuMx8YQ7AZwCMuhs0TijAVyycUVjmrXmVni6e4KsyW3COsLVsJIiU1c3BgBokiFiksRvSNPCNMRHGvBSqVxVGSYE8t6PkG6atJQU6d3ctQGsQgezonXOfgDSz6RTb5d6o8Z1N/c3GgTmuaQXYPcI1cJOYRODoMMX6PMHWD7p+be8gI20ayYmYBITRwg8IX1KdTEeYGsEpDmYqLvsXCjXwo1GeD9CtAfPmIqWfl/SeDCtM33V5lfVFhNZyQbYrzFRKIi+oX22qUVwti/GymJoYOv9zViS3YVnqU+JEJfHHxNB3iHbzPBUxFXjLYXaj39EjSi9OsLRFiiq3t4lTUuKBw0QghhwOxyzOZ2sXWVCJHntcZS+eJMSL2C51AwPnP2ID4kbUtcUdlAHCIBNMb4SJSPjAkxG0UojmH6C8UwfK3kNR4DEuAv5uTBUAIdcQHPELryNFwtdd3Sl87XhXDsecXO4PhySMtGlROmMGxI+ctrYkIFHVG/0O/rt5yLiPkD5p4GhWD3lY8uOFSq7/gg2oNvu873UDhK07bnVtvJgYH43U3vGuohb2F4LugGsBOAdJGHxIC5eeTSIzMLb3B0SVXfcCLXkZsh/iRqaDO9tLuOFK82sQ78mpke9yh+778Xd7X9tQgo0aPYDB5tU+nkndNKKfs2POoTWzbXPY8pM8Id2+P+eEYrqJ4xnc4hrlWZLGuQq7H8WyT/toHbhebvho2JC6XYizd7oQlfDLg3NIVad1dUrOpM1aFtbqo8JJwC8BJP5knnSnrDGKFiMBYOcKxA3dtf0ox2JzmIxvSrUltpB4apoE40OwUnhDvMZ1ZFUVwNE7v0BC6+0p2YMb8G2UI+jDSgqLfNgatePiyrD5XDg4G5AUohcPRKvj06oOeAiFy0F40Sgq7rI6bHGJ4qCxV2V/PHRSv
 fs7p3DAZ
 wjvsmyHmkU430BwB/sf8xNFIJ85nzFnBMu+947NbGctxTp0wqWhY+IK64fDp2Mn2v61JSMZc4npNeMyGDP0G8w8Nm8eEuSZp2Fuzqxbur2R1sTlQ4RPIFB0GsaIliPhjQqBqRqJlZvME4nbKGPohF0Q3Mc8kPaGVojV8qOaclcVKwUCtv3kcw0/oya4uynbRXiQJICr24rADorQR3lpYddGBCrFg1Je3WG0+kLzSv3mhmrByh0gtf09Mv03kW9IFIHu7HG2qezt+oQ6yYwJ+9pCVYcD8zxg4smneL1vW9Kp+RraL6BwapFyZ2cljLogm87ICz3bGMdR+OBe6Dnzbnco0DEp2N8LpkxhSORyj2tjuOioT+JIGrszs+rZjiX6V1gMuH3AX5DhLqUs5lM03LvyU6irpQbgoRuHvyje43r5iLMlo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue,  7 Oct 2025 17:44:12 -0400 Gregory Price <gourry@gourry.net> wrote:

> This reverts commit d6cb41cc44c63492702281b1d329955ca767d399.

It's been seven years.  Perhaps "reintroduce hugepages_treat_as_movable
sysctl" would be a better way of presenting this.  Not very important.

> This sysctl provides some flexibility between multiple requirements which
> are difficult to square without adding significantly more complexity.
> 
> 1) onlining memory in ZONE_MOVABLE to maintain hotplug compatibility
> 2) onlining memory in ZONE_MOVABLE to prevent GFP_KERNEL usage
> 3) passing NUMA structure through to a virtual machine (node0=vnode0,
>    node1=vnode1) so a guest can make good placement decisions.
> 4) utilizing 1GB hugepages for VM host memory to reduce TLB pressure
> 5) Managing device memory after init-time to avoid incidental usage
>    at boot (due to being placed in ZONE_NORMAL), or to provide users
>    configuration flexibility.
> 
> When device-hotplugged memory does not require hot-unplug assurances,
> there is no reason to avoid allowing otherwise non-migratable hugepages
> in this zone.  This allows for allocation of 1GB gigantic pages for VMs
> with existing mechanisms.
> 
> Boot-time CMA is not possible for driver-managed hotplug memory, as CMA
> requires the memory to be registered as SystemRAM at boot time.
> 
> Updated the code to land in appropriate locations since it all moved.
> Updated the documentation to add more context when this is useful.

I'll duck the patch for now, see what people have to say.

> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -55,6 +55,8 @@
>  #include "hugetlb_cma.h"
>  #include <linux/page-isolation.h>
>  
> +int hugepages_treat_as_movable;
> +
>  int hugetlb_max_hstate __read_mostly;
>  unsigned int default_hstate_idx;
>  struct hstate hstates[HUGE_MAX_HSTATE];

Could sprinkle some more __read_mostlys around here?

>
> ...
>

