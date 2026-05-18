Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2338FCD343F
	for <linux-mm@archiver.kernel.org>; Mon, 18 May 2026 20:24:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 448C26B0005; Mon, 18 May 2026 16:24:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3F9D96B0088; Mon, 18 May 2026 16:24:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 30EDC6B008C; Mon, 18 May 2026 16:24:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 206AD6B0005
	for <linux-mm@kvack.org>; Mon, 18 May 2026 16:24:26 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id BDBE1140A5E
	for <linux-mm@kvack.org>; Mon, 18 May 2026 20:24:25 +0000 (UTC)
X-FDA: 84781668090.18.3526D32
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id 0CCEC140010
	for <linux-mm@kvack.org>; Mon, 18 May 2026 20:24:23 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=JSlwArzO;
	spf=pass (imf23.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779135864;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RZNf1bcVC2IeeFr1W1Od5fHA7JmsxLWbYc9ve0+T0jg=;
	b=zWJAie2Jwkb18tQXn7+4zViD34dQ7qrOqYO9OgqVRpOMrWdPR4nHlDYrIN3w4mbXGpR6eP
	Z4XUgLxYYaU4W/3/If9Zb4BKkSugExs5dEJbUQNhX6GnJB/CATTQJJv6QijRHWtdZ1J3nh
	jfLTRUjKx38MWC200Ague3DvOMRRdVw=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=JSlwArzO;
	spf=pass (imf23.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779135864; a=rsa-sha256;
	cv=none;
	b=7faKSkaw29+QRsjUz+3zfrBHPR9mBXjdv+pCxv/yMTiromIcsQnVyVpRpnYBjE8IAmiNl8
	gmmOif7OjIWSC1FBMhM3jGzvoS2EV8FuE9UeXWvDJGjk2p0r5tf7vQGoVQ+oRW4u0aMlfe
	wTbLCcpEcY2Ms3r6ZQ6ddsO4E0wLJ7w=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 4E2F060128;
	Mon, 18 May 2026 20:24:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A70C5C2BCB7;
	Mon, 18 May 2026 20:24:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1779135863;
	bh=IJAKL8NTs72NKxZNZ1VjujoXmDaDDaVg2ZSqV8hIpRg=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=JSlwArzOVJuRLn98yhZUKM9d36LFDaSnk7U762De8BaJXGSoOV9JNJpicKVx0hxyC
	 Oy2i1NrsDw+3YzicrhLIoXeuCwX/l8FW3LnyDokp9pV8ncwu/E5fRszsWREuOi63WF
	 ZM1qpg4IOE1Bf1IEyYlDiEGnzQ6/NxVAe8fVqFKU=
Date: Mon, 18 May 2026 13:24:22 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Dmitry Ilvokhin <d@ilvokhin.com>
Cc: Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan
 <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Brendan Jackman
 <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Zi Yan
 <ziy@nvidia.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 kernel-team@meta.com
Subject: Re: [PATCH] mm/page_alloc: fix defrag_mode for non-reclaimable
 allocations
Message-Id: <20260518132422.8cfec729a4d7e974c87ace72@linux-foundation.org>
In-Reply-To: <20260518163736.173910-1-d@ilvokhin.com>
References: <20260518163736.173910-1-d@ilvokhin.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: cu9u3d5xn9b1fmd9xqz467tc5o1nhiyu
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 0CCEC140010
X-Rspam-User: 
X-HE-Tag: 1779135863-976993
X-HE-Meta: U2FsdGVkX19N5Cykj8c9oGhYEa5cWY8wyCD8S5J5ZAzle2dvpaZXFXXRIQ9cIVg+mhS+U049ls6p1zEx/t7cxsWr2JzA1QGzDDHLsRXmDYN9R5+uRd1O8TYNalNiez9jYX2k5OPTlicKNC9KMxqi4K+1JfAgAJZYvPFFxIDgfji6cbv+iuXXGdK7JYUnHZmSW26DLprflDy68DSGd7Y9KMQbD3zIKzlro+sVoPrq4mTkBmVqWBCN8Ra9d/R9IgMHA/fxfBP3QL6hrYoArkJ1LJtXL6nPFU/IFhdIYv7pWS83acDC+vtJ8zwRksa2OvJQkSwDeZkY+h0UmusUZERhSbd/j/yrX2h9fPdRTlTe7+oEyfbfJK72jvDKTKrv/YIKHPW9wkRPKNySznzG5gPhqAgFOpmh0AsFXczogQSCMaimzSBafKGUIBHFZBuwT54k37RhKjQPstJxSx8Dj+aPQK6jKAP/OvitUIBFHGOFSL13t0R8d6rgh2jv6SPG3q87sByd2S/sYL3BslBcXcHTP8fAt/4wJhnt+ybbP9ZNgdDucRpChRwdELiG9tX6oeYOytsNXISh+ylg0BiByFKsH/4kffj8v2NtSkOy6c9uEiyxXayJBGpsSGESynvk1NhnTH2mhLKYzQ8yQ+QS9CahoOLewEIy85l4GxH4FpCdrPqtKUcI4hm3q1A/YMk4ABCVkZ4twbGVpxNtv8yX6xgHBAckbCUalu9+h7p5boXb/Paeb1rthKgSSN/grNO2675p6uSp6wxps1vRhxv9P0QL+fEOT4/e8EPRHO8NZ0p8qSx2kSTUuqccMXuXG1El3/URaYf8w1LnMON+s5D5nNXUMWboTR11h6ejaSn/hDKHMAjGm/4H0bxP9SxhboupsH31/Jt1J18XtJcGvCjYwE/7KwFNV2pIelpS3Wd/wmU6VyWYCdoVghc+xBhd5br9KkXY5xcFgeMmggfUoh3gm2S
 R1SmzsNX
 ekYw7K4xLxsWjYS2WNg8RRKwAiyvLIyK+qsHUoSpS+34GBulbtRvv7rGwEUs3R5wx0mxXT12EAUowAAoUE1YRqx15X+ITSTzyaRZdGnQq/bH0Mwdka3ZOuXgo3h57Y0tDI29tFHg96gCJxTBOCxeeLrIRSnPRNu78ja9XnBpAAigHxyKyNJRno5Xi7pOO+o1lnfQ8rMjOY47p/YHpXz7/FYxRTWdonb6T+C5Po8HWQ8iMHkxIxzEr2rsG8c9uhIJ4ROkI/L95qIIsHADp5wS31pHjy9/aonPmR09xhZF7ps5VGaYYrhJZYqOJehaKrMtm0Jwg+qNm5k1/bKdKm6Ud+s5Bjr8F4ZN5q9cI/GCwGD982uNcsPXMqc0GICCrtNbvFrJ04p/MZEwtbNc9mapwmQ6Bywlwry8w+8kv
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 18 May 2026 16:37:36 +0000 Dmitry Ilvokhin <d@ilvokhin.com> wrote:

> When defrag_mode is enabled, ALLOC_NOFRAGMENT is enforced to prevent
> migratetype fallbacks and keep pageblocks clean. The allocator relies on
> reclaim and compaction to free pages of the correct type before allowing
> fallback as a last resort.
> 
> However, non-reclaimable allocations such as GFP_ATOMIC cannot invoke
> direct reclaim or compaction. With defrag_mode=1, these allocations hit
> the !can_direct_reclaim bailout in __alloc_pages_slowpath() with
> ALLOC_NOFRAGMENT still set, and fail without ever attempting a fallback.
> 
> This causes a large number of SLUB allocation failures for
> skbuff_head_cache under network-heavy workloads, despite free memory
> being available in other migratetype freelists.
> 
> Clear ALLOC_NOFRAGMENT and retry before giving up on allocations that
> cannot reclaim, following the same pattern used after reclaim/compaction
> exhaustion later in the slowpath.

Thanks.  Sashiko asked a couple of things:

	https://sashiko.dev/#/patchset/20260518163736.173910-1-d@ilvokhin.com

I'm not sure what to make of the first one - we aren't holding any locks
in there which prevent concurrent cpuset or zonelist alterations
anyway (?).

But your change might violate the later comment `No "goto retry;" can be
placed above this check * unless it can execute just once'?

