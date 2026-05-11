Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D9E7CCD37BE
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 15:56:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4DC5A6B00ED; Mon, 11 May 2026 11:56:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4B3416B00EE; Mon, 11 May 2026 11:56:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3C96F6B00EF; Mon, 11 May 2026 11:56:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2E33B6B00ED
	for <linux-mm@kvack.org>; Mon, 11 May 2026 11:56:30 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id CE5241C009E
	for <linux-mm@kvack.org>; Mon, 11 May 2026 15:56:29 +0000 (UTC)
X-FDA: 84755591298.06.47819A6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 0808F100008
	for <linux-mm@kvack.org>; Mon, 11 May 2026 15:56:27 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=iWY1agl2;
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778514988;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dCZxDN18cV/422+bkpqdCEfHAHm5mQzBW8ninbGY4+U=;
	b=V2a9IjvkoP3W6Woe2YxatUtVs9L741uI4UbwclTiSggYbOreBYTkYS+Ic/DYa+sQ/W8aAN
	3cmfZEPyyrgeoaE/iwVdSD310Ge1cPRbCRbZ+/APEpcCr8/B4vFgGB0ivpZRk5JBjGnX7Z
	lQmrpMjLByzvnGkKD2X1xOAXAvKICsA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778514988; a=rsa-sha256;
	cv=none;
	b=hKQ7df9fckQha8StjJZh9YzwAy9/DZc8TckX/3UuYf76CAL5eCoXEEGGExIhPBCy5jUDLr
	Ua1ImsqY8QZx3Cqip+X8dXoIu8NA9pzvWJ4Y7bu0SklJu/tcPJ14z0IqDVJcPD6+lDfTjR
	gBUYFBvm8OVRxUYBWGQzD9kStSDpn4A=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=iWY1agl2;
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 0A54D44058;
	Mon, 11 May 2026 15:56:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11D17C2BCB0;
	Mon, 11 May 2026 15:56:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778514986;
	bh=wHF3j54IopBAPswmwUy+Go6x+2HXg2Z8f8E+TCPm3PQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=iWY1agl25YwFg/1AFNy9/VKJjHwRcbFqhG2jvhJjHofiGhZENmc49UsWAL8ItB0VX
	 LuQiFxMk08urZ4n1sV0aCAEm3T36Nn6DRFSMyjCl9IvcVUFcciMK5IGGCfzTkvVgkZ
	 FJkI4LfP4jrPSYkLwkSjXILCi/XOOV99yUNeMjgim97fCybsUeuHgCqfCBK4sKgyYU
	 jh3Sk0psLkcXDXKeBLWUrQBvwYJ2hc7secFOqxsYYu2cGoR9z8dO91DNCV9bevvz+V
	 L66WRhCxH76G0hDBACkxMGxDegrnu7E0dLI9mWZNrXaoFHTugvb8+sXLBrc9iu0Ae4
	 PU8UnQrRVFCBw==
Message-ID: <3ff8b23a-479d-46e8-b820-a23697587f01@kernel.org>
Date: Mon, 11 May 2026 17:56:19 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 0/9 v2] mm/memcontrol: Make memory cgroup limits
 tier-aware
To: Joshua Hahn <joshua.hahnjy@gmail.com>, linux-mm@kvack.org
Cc: Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,
 Michal Koutny <mkoutny@suse.com>, Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>,
 Kairui Song <kasong@tencent.com>, Muchun Song <muchun.song@linux.dev>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>,
 Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>,
 Youngjun Park <youngjun.park@lge.com>, Qi Zheng <qi.zheng@linux.dev>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, Kaiyang Zhao <kaiyang2@cs.cmu.edu>,
 David Rientjes <rientjes@google.com>,
 Yiannis Nikolakopoulos <yiannis@zptcorp.com>,
 "Rao, Bharata Bhasker" <bharata@amd.com>, cgroups@vger.kernel.org,
 linux-kernel@vger.kernel.org, kernel-team@meta.com
References: <20260423203445.2914963-1-joshua.hahnjy@gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260423203445.2914963-1-joshua.hahnjy@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 0808F100008
X-Stat-Signature: qa8pio3gst47k3jntwr8mkh9fpc1qpfz
X-Rspam-User: 
X-HE-Tag: 1778514987-497659
X-HE-Meta: U2FsdGVkX1/e/URrx/HXWBphBJ2zaex6kmlfkwScAqmhBS+lG9Aq4C9d9WqJdPmVD8tXUSHz1M/wfujSZf6bJh0XsweWvEhRkgbPCOQBZFV8rJmrf+OJB6jBNjC3oNH1CUCcZs6epfCf0ihkV0yJsArOmshy2TMVEtRYVbX7xgIdhkUOvy8DAN3HHvkbzSr22+Im5nISGPwIkp6Q8y3dTxHy42n7ZL3Q56m/BeQ6MHSFc1qBOE5AJLrq97BliqpRBN0E9j331MC6SGA24mWP6lOzQPA79BEtcqX/J92aIh3SIDgGlrYmloqyNplXHtSgJ34BbmdsP5kUwqkM2J/ClEe9/GR9+O7yg90JunhgSNpH3Rcb1UmJpshNtF8GsIvnx8IVV+OfJNKunpVR7rDBMrz/bA/MYjdv0YezFBWGoZgzIS1xzVbIXN74B8TamYQj+BEWr7TGi/R8u9J95C1voZw/8XHffWKlIqaAgHBFfnrBHwxzyUsxLIUaiR70I/V1dIyLp9z1X1kuBL7a6ezW5MvcAqTUkfPDqhv+pcy1awEeCgUqMJnYd0cLm2CJTFtqUw4CVq5QKyzJrAsdxSd7eCZZyeoCsnmD6APxyV0VEAO88lvaQZDJz/AEwbXbvdVEICCsMzfKCSNm+FQLX3Md645AN1ZYorQMiV/lF77D0Y8+6xJUd7csCPSS5/ih1/lC5j57bKS6iLtkuxHy/Pt2zzpqbmWMrTKOA8QA5k5w/Uj+hAceqmq06wiEDD70gFCIOxoN6maebDyePQsflrbrmqmAjPU+6sNNb9IAeuwXxVDggyqXyFb8CxWCijRc/AwoPhf/WWIeQxzXELyT+ymlb5G9LFTsAy7miT+p6Ee6iTWY2wN1uIKxmyG7/tOy8/HkQpWHCmxEDhoH+1adJSS5ix61sDZ6BihABk2J8Pgw5CbGF0BB4w7+Fhi30xK7GxUAhpa2XHx7GqbQO3nkbvL
 8G9KQYTx
 ztoDy84ZgSkAElyEDHIWFIzwoMkDq7YEhIzEPApM2Pw6zqQ8XMpZjg2hstbWqbifHN2jl6ba7dyQ9PJlt+T68T+ak1YBk9w8Qd9gJsx7hWGmH2JWXpFvcPf+r5N9NXxwwYoDmfbQcsM++f6pCVTvzSAzOvI3KMCywGpeSbIDRmISBhd13uIbRzP+uJ43gHGqeUlsZbJgANZ2iGt/CX6e/7UPMQHYRkxws/Pe987N+40ckTxXo6U5cWYPZst2iAnyMz70XYGg1aPSRe44J0CCkKu3bnTTvUUv0ZMlQr5dUsNf0NYqkY5i77LymynDnNzg0SzISJXWZOv6pOsf8zUh4P5agVj//MH0FrFxx
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/23/26 22:34, Joshua Hahn wrote:
> INTRODUCTION
> ============
> Memory cgroups provide an interface that allow multiple works on a host to
> co-exist via weak and strong memory isolation guarantees. This works, because
> for the most part, all memory has equal utility. Isolating a cgroup’s memory
> footprint restricts how much it can hurt other workloads competing for memory,
> or protects it from other cgroups looking for more memory.
> 
> However, on systems with tiered memory (e.g. CXL), memory utility is no longer
> homogeneous; toptier and lowtier memory provide different performance
> characteristics and have different scarcity, meaning memory footprint no longer
> serves as an accurate representation of a cgroup’s consumption of the system’s
> limited resources. As an extreme example, a cgroup with 10G of toptier
> (e.g. DRAM) memory and a cgroup with 10G of lowtier (e.g. CXL) memory both
> appear to be consuming the same amount of system resources from memcg’s
> perspective, despite the performance asymmetry between the two workloads.
> 
> Therefore on tiered systems, memory isolation cannot currently happen, as
> workloads that are well-behaved within their memcg limits may still hurt the
> performance of other well-behaving workloads by hogging more than its
> “fair share” of toptier memory.
> 
> Introduce tier-aware memcg limits, which establish independent toptier limits
> that scale with the memory limits and the ratio of toptier:total memory
> available on the system.
> 
> INTERFACE
> =========
> This series introduces only one adjustable knob to userspace; a new cgroup mount
> option “memory_tiered_limits” which toggles whether the cgroup mount will scale
> toptier limits. It also introduces 4 new read-only sysfs entries per-cgroup:
> memory.toptier_{min, low, high, max}.
> 
> The new toptier memory limits are scaled according to the amount of toptier
> memory and total memory available on the system as such:
> 
> memory.toptier_high = (toptier_mem / total_mem) * memory.high
> 
> For instance, on a host with 100GB memory, with 75G toptier and 25G CXL, the
> “toptier ratio” would be 75 / 100 = 0.75. A cgroup with the following memcg
> limits {min: 8G, low: 12G, high: 20G, max: 24G} might see toptier limits scaled
> at {min: 6G, low: 9G, high: 15G, max: 18G}.

Assume you have a bigger hierarchy (HBP, DRAM, CXL), or assume you have multiple
NUMA nodes with a hierarchy each.

Your proposal doesn't really seem to be very versatile, or am I wrong?

-- 
Cheers,

David

