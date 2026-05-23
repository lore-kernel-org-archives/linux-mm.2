Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0397ACD5BB4
	for <linux-mm@archiver.kernel.org>; Sat, 23 May 2026 02:34:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E6F6C6B0092; Fri, 22 May 2026 22:34:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E1F506B0095; Fri, 22 May 2026 22:34:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D34D26B0096; Fri, 22 May 2026 22:34:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B80A66B0092
	for <linux-mm@kvack.org>; Fri, 22 May 2026 22:34:44 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5ACAA40771
	for <linux-mm@kvack.org>; Sat, 23 May 2026 02:34:44 +0000 (UTC)
X-FDA: 84797116488.18.8EEFDD7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf31.hostedemail.com (Postfix) with ESMTP id 962ED20007
	for <linux-mm@kvack.org>; Sat, 23 May 2026 02:34:42 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="c00/stR2";
	spf=pass (imf31.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779503682;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mb+a0dDtdR5L7Q5VQ5CEa/NHANDWzSQ1aXqxFnIKIO4=;
	b=CW2lsklvOvKtphKAmF4n29TXNq2VsDREPIVilmprp9AkQYjVH60o4JRDH2CgY20H1uoEER
	SBdLDEsbUPG1VkoPzVe6y7Vf/7AjiOnfT+NByUYo1LJ3xUmWEae7FZQjIDIM5ZNUXi51NR
	fIqkVrANgUXUQZ7mhYN2pyn9l5/5kAU=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="c00/stR2";
	spf=pass (imf31.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779503682; a=rsa-sha256;
	cv=none;
	b=ZKVFS43/e3yt9pn6W3HEk480kKyY+5uHRmB9mBdy1hPWk5U6+DIw2RLKdWjBP8AQgBjCZG
	yFqQC737yxlVbkEtnp9roEGeT9lVy+aZSLJWapjaNkwxPf5QhPyYwZjao9cpn8+F0qsTA5
	RvqQcxN396Ck/g7y3V+RYlrJHYT0BaA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6C68844227;
	Sat, 23 May 2026 02:34:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDE351F000E9;
	Sat, 23 May 2026 02:34:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1779503681;
	bh=mb+a0dDtdR5L7Q5VQ5CEa/NHANDWzSQ1aXqxFnIKIO4=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=c00/stR2QqGSFKqYZZi4q67VKjGgv9VlpfTU41yaXPrVZfYQ4fQoEbwDmPvoxoalu
	 UO0r4ceZw/iVPZSVRvhPSLNQTgNczurkCiBjJYcdGLoOvb8QBwd6/u1Er61XRQf+PZ
	 /XaE/zdUUIC7tdk+MvV0O/G7EEmp3lcPD1tkyZZ4=
Date: Fri, 22 May 2026 19:34:40 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song
 <muchun.song@linux.dev>, Qi Zheng <qi.zheng@linux.dev>, Alexandre Ghiti
 <alex@ghiti.fr>, Joshua Hahn <joshua.hahnjy@gmail.com>, Harry Yoo
 <harry@kernel.org>, Meta kernel team <kernel-team@meta.com>,
 linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
 kernel test robot <oliver.sang@intel.com>
Subject: Re: [PATCH v2 0/4] memcg: shrink obj_stock_pcp and cache multiple
 objcgs
Message-Id: <20260522193440.40e20563422afcc69b8445dd@linux-foundation.org>
In-Reply-To: <20260522011908.1669332-1-shakeel.butt@linux.dev>
References: <20260522011908.1669332-1-shakeel.butt@linux.dev>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: y4s1jiy613zbqmt76dz7xh3yz1c6t7xs
X-Rspamd-Queue-Id: 962ED20007
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-HE-Tag: 1779503682-413997
X-HE-Meta: U2FsdGVkX195nnd4mNCR8V7uGrWTlTJyYqt0MT04vMpDvj/Bqv/3a1sQ5i9Fe8Bns7uzs8qq3/CKnANeL44EEIJ+2dzUQGt7fFP1+Vil9NdCbrwO69POzolBojnu7e0fyeam8fROdjEN5bIwXG7TzyQIMlBZcRnl96lAp0tStjjDiewwWhsdXUpP8AwgbM798pI30U2UNWsH8yGWWkSNd0DinCqrihTdHRELEmdIoozWoC/Opbe7NOMUKZivBU2wUAVKbUJ+vUPHn1sHatv0wQ2RL9iEi5+8FFxQbtnRq+eCdI3bCArvI4BB3NH3NUyWTuntMrj6aoFawRm8TfHK+4JZi4vKURCHe4oQvXDzKNI7URtRJmHmeVoCMH1T0BgPKO3FGWJ+DyyvBL64Zazg+i/sNvcI5qLxZ4OLBMX6EpN+kp+j2Pa6s6jCvRyi9lAsBlSrdTFzyTFZVZltf7UPApQvDZb7f8x3E4cZ1uusl8hxzY4T3Buy7TQ3+Ic5x0iiPRf0Wu4Dr94bs4dCcED8U4DGNz+JUOoSDLWcwi53DsdadsT9hnELTZ191MpNAPotGqAQudtzfFG4TCYG+LTFRxDyTBUWevFwnexFw07FIyNGmGJGhYc9nhV3CMaboUPlVSTOMv9NxzYUZGbcdwUnVQlbzHUucdlITVqRhliTsVWsAUXU5WOEXBEbxTPrCMJFl1MZx1fC4og8HUX1u9Jol481AAJHuCMc7yo0C7GE/z8MRP2RPimgVyHDJpn9JIvEgVBYVyI7/YTKSHTOs8wgFnYI7XULyqWYKjDGGAFESJmgPHtJQmDlsE1q8Ei7AT6dEcvPcp++aTofkCRCjZ8d4L4O1OceeOKWZuzvVHYmC8zNtDm4hZFI0yIGM+Kk8kDl3lsgE7gHvuYMEcuMlim/TNVC+ugDXkuNTsi9C13jW/+AHYcHxZ+wypusvw0134JemybsRmcxicNTaG14UPe
 nyib7GPo
 1qtAupCXyVHL7g3uryaP41W9YSM93wk7hr/cfgS3czCYFzTzf2Vd1yvTlxHj5LlE2EsLgrpCFBbrFqXvejwJOZeDslF+CdULbKFFRm8rgqxhMWSxTB3696czMHGkyi8unrWCHCoYkL6zA9gU2lcKuaYPdLeInhB998+ZEQ7EUoBn7/HR+PXaTmW721RHb2N7HNA9H7FUJ3W5CXlRNAgoNMy6mutAMNrMR1/ced3hXN3x9WUpPu0oWnB6jdTKeHtbq2ODYyeKaJ0GeqX0s8k3TdLHlhjkr7iNVab8XFuj1tBxOnn5fsOpZaepgcvjNfr7QJ+aesoHlUNGBU2Re5ajTB9IgNKXU74PmUzL3o1rDCOrUSXfPSRb+n9yl15w4wWgibc23lMowiSe9RRCDq9yT/bagAa+DjniWDtO+nYzY+DKXYeE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 21 May 2026 18:19:04 -0700 Shakeel Butt <shakeel.butt@linux.dev> wrote:

> Commit 01b9da291c49 ("mm: memcontrol: convert objcg to be per-memcg
> per-node type") split a memcg's single obj_cgroup into one per NUMA
> node so that reparenting LRU folios can take per-node lru locks. As a
> side effect, the per-CPU obj_stock_pcp -- which caches a single
> cached_objcg pointer -- thrashes on workloads where threads of the
> same memcg run on different NUMA nodes. The kernel test robot reported
> a 67.7% regression on stress-ng.switch.ops_per_sec from this pattern.
> 
> Commit d0211878ce06 ("memcg: cache obj_stock by memcg, not by objcg
> pointer") landed as a temporary fix by treating sibling per-node
> objcgs as equivalent for the cache lookup, intended to be reverted
> once per-node kmem accounting is introduced. This series takes a more
> general approach: cache multiple objcgs per CPU using the multi-slot
> pattern memcg_stock_pcp already uses, so the per-node objcg variants
> of one memcg can all coexist in the stock without ever forcing a
> drain. The temporary fix can then be reverted.
> 
> To avoid increasing the per-CPU cache footprint, the first three
> patches shrink the existing single-slot obj_stock_pcp fields.
> The final patch converts cached_objcg and nr_bytes into
> NR_OBJ_STOCK=5 slot arrays and reorders the struct so the entire
> consume/refill/account hot path fits within a single 64-byte cache
> line on non-debug 64-bit builds (verified with pahole).

Thanks, I added this to mm.git's mm-new branch, along with a couple of
possible todo notes from the review.

Sashiko asked a thing:
	https://sashiko.dev/#/patchset/20260522011908.1669332-1-shakeel.butt@linux.dev

Did you already see this?  The footers there indicate that an email was
sent out but I don't know if it works?

