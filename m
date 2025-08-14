Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B28F7CA0EDC
	for <linux-mm@archiver.kernel.org>; Thu, 14 Aug 2025 20:34:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 455BD9001DC; Thu, 14 Aug 2025 16:34:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 42CCF9001D5; Thu, 14 Aug 2025 16:34:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 369239001DC; Thu, 14 Aug 2025 16:34:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 252CC9001D5
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 16:34:27 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C7DBC1A07E6
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 20:34:26 +0000 (UTC)
X-FDA: 83776515732.25.1051C7B
Received: from fanzine2.igalia.com (fanzine2.igalia.com [213.97.179.56])
	by imf21.hostedemail.com (Postfix) with ESMTP id DD9A81C0004
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 20:34:23 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=igalia.com header.s=20170329 header.b=imbwz8fo;
	spf=pass (imf21.hostedemail.com: domain of cascardo@igalia.com designates 213.97.179.56 as permitted sender) smtp.mailfrom=cascardo@igalia.com;
	dmarc=pass (policy=none) header.from=igalia.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755203665; a=rsa-sha256;
	cv=none;
	b=LYA02/X/QRVCs3GtwC5Qm4FK09nrZKV6TA8/bR8WzE3d6EaHZYJIn/m7b+2lC+kj9VK+1e
	XGwvSbbhtvG0iWhFB8hJL5PBR93+jBZyQRMhlVu7OVL+9rql/4POQc1KNxfJP19G5xNlD9
	E4BV30K1F3LMYRHwON4ftblZLbJ5Bw0=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=igalia.com header.s=20170329 header.b=imbwz8fo;
	spf=pass (imf21.hostedemail.com: domain of cascardo@igalia.com designates 213.97.179.56 as permitted sender) smtp.mailfrom=cascardo@igalia.com;
	dmarc=pass (policy=none) header.from=igalia.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755203665;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xbeFyxJsjyDLbRjkmdIpJOUuFgQfPXsStvxxRG1ZwuA=;
	b=ipmnjbaEcXdJBGeIzHmsUcewcva/IGJAhQJXTqXT+GiMBZMHJRZg8aaCLESTYquTtA3NCh
	ogEgp7iQPzeUCnCKeSQv2YZfqzTvhwdCkN4L0CZaDn5mbsudOyyNFZw3ofJf7P1aMNzVTO
	ObxUIjCbKwMdV93p5Ny9fzle2/4gp4A=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
	s=20170329; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=xbeFyxJsjyDLbRjkmdIpJOUuFgQfPXsStvxxRG1ZwuA=; b=imbwz8fok9svepYjJICzO70Tri
	qvcNloiiEa7OyowU3DWBMdrD/fBF+Pijh0u/sswA3vQ0vxGDQGP1WWEN6Bletm/xUsrZcQt7ArbO0
	WuCawWXz0gbCCDdX3yZdtEIypbKR19ycZCA14HOMVHhpuePDkfJpUYn0ESPnmlE1tB30kDxohwOr6
	pMZ4kd0sgzOagekxAwFrOOJwcQ29j2kYNh3OfR+TBpTB+bqSGxXAVfv2Ydd3deLldN2ns16NJDxtz
	3yoxukaXJCW4w3pYbesz4ztpsjQUNVXbm4+8ymBgJwEIc65JDnNyVx9gDdNUxXSZ9HkFS0ZokQeVN
	47XJG5Ww==;
Received: from 179-125-71-254-dinamico.pombonet.net.br ([179.125.71.254] helo=quatroqueijos.cascardo.eti.br)
	by fanzine2.igalia.com with esmtpsa 
	(Cipher TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256) (Exim)
	id 1umeeN-00EIWd-5o; Thu, 14 Aug 2025 22:34:15 +0200
Date: Thu, 14 Aug 2025 17:34:07 -0300
From: Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@suse.cz>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>, Zi Yan <ziy@nvidia.com>,
	Mel Gorman <mgorman@techsingularity.net>, kernel-dev@igalia.com,
	Helen Koike <koike@igalia.com>,
	Matthew Wilcox <willy@infradead.org>, NeilBrown <neilb@suse.de>,
	Thierry Reding <thierry.reding@gmail.com>
Subject: Re: [PATCH] mm/page_alloc: only set ALLOC_HIGHATOMIC for __GPF_HIGH
 allocations
Message-ID: <aJ5IP1gKV1bkayj4@quatroqueijos.cascardo.eti.br>
References: <20250814172245.1259625-1-cascardo@igalia.com>
 <20250814201211.GI115258@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250814201211.GI115258@cmpxchg.org>
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: DD9A81C0004
X-Stat-Signature: bbsp5ius61m3hiuqjdei5omwca4k83by
X-Rspam-User: 
X-HE-Tag: 1755203663-855359
X-HE-Meta: U2FsdGVkX18ylrXvkG3BlFVW2fEojTrDmTKN5lu+2VoclTn4Cf2XMvLfBPgsERz9bNu0uu5ZElKXjRJ0V9wOMZ33X73AwqJ5sc6MHH2zWoZldccY75GDm0cR3+bpkJxcw/mCHmqqvSxhMJOKB2LJOnP6TFD8nqbyBkETSHNadJrM3CcWWUaCOaXC257m119f+urpExcOnmyqdJj+d7tVDd7ioUg+orJnqWpN3DnFyUKJbDLyun3aAQy8SsmZsys8GuVxsVEAH1259ZxElphuO8hLMWGdWOk94C/WojGpoZO2m0U6qXVe85BkcOqy/bVa0+6lI+6XbeMnyA61URrqa5Og7NR5HwVCLrqfr0EL9bST7NY+nWFuhsNyEhpINGARHop3tJzLr+OkDn5/yv73/CA5p5pOaOwrJDeNEB9tuEIqH//Ih1PM+8kOlfCBTcpWprPcP2Bykq8o9CEtoQBKkqrr5bcwArl0LrsoIakBO36ZTH4qH5GaxfG7/4c8Dm7nLIMMQ3aYXTYpU3HZxACqjNamLCpVAkWvRk9YuDfYDdaIqdcSu9J/24MdQC7vpykWbVO50lUqteUtLoMixP3F4JJ3x+a/InMDyw3LaVSJl7S1iOC148AayRRWJnmKvVk0GoDGcxav5hlLSNkDvyOUEZnbbPMJb6SwXIW6gXuRN2rN3qhjj2bY7FuTmnWGVXeNGjNVLXxwFTuenUt76mMUnoGY99H7gtl7wmy91hUz+R9fQiVDd7kG0okK9FdZYE0ADn+KXwRuZZgelyWgSi0qE+7eHzlAc7TG5DYXbrh9tdbDz2efM1cqb7KG2qBzUHyBOp3aS+s0U03ieaONuJbpS/jtedr94p0JddzUlOxUGEE1al5bom/yBa+OsObPp2nRcptSLDtCsAAw0zMQpZk0OVuDGKlshMBqO3okkGDRv9sQft4eEx8vfRGini4GqDXUA02yjOv6A7IH6d54dR/
 8NXRCVBG
 BbHRHsGamTRqtSea8+aJJP8deK3HEgsckAcgAfIyqW6KWwF3PTo5W+F01IMpi/1MHsbnHjOejI4tdj2JppU0hVN64WpAlzg/dUUDe7AtBts2op3BSH7vKs5rMvaAyfXAR57JfbZmKKUas/KhmwDMUn+zkI1UcxOFv5Mvi9l58aSjheiFt1LvBfTV4+qQ9Pj0QFHNwzQQA0tJ4Wlijkzf+vA1Pnx1a6iJIsoUF2zsGtXo/npyFfTyDyD13iyVPPFkf3EqpKb5dEvFQid4bLTcE5NbBFp7BPtRufNs35WuFxyjWUSiv0LTXXYbmZNaXcZafGB6JGarbX8kiNBFx7XqtWROM+9ac28rZ/j2PwEjkafztBPS9lV7Fg0r4TX7msROHtOPMIniX03fW6Ekk4IhP3175kcIZwr7tiSM9wrVDuCKQ2GHUMWmFt9l3LdNsKY42MEHuxSj11HBTuugGn4WWCscyrQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 14, 2025 at 04:12:11PM -0400, Johannes Weiner wrote:
> Hello Thadeu,
> 
> On Thu, Aug 14, 2025 at 02:22:45PM -0300, Thadeu Lima de Souza Cascardo wrote:
> > Commit 524c48072e56 ("mm/page_alloc: rename ALLOC_HIGH to
> > ALLOC_MIN_RESERVE") is the start of a series that explains how __GFP_HIGH,
> > which implies ALLOC_MIN_RESERVE, is going to be used instead of
> > __GFP_ATOMIC for high atomic reserves.
> > 
> > Commit eb2e2b425c69 ("mm/page_alloc: explicitly record high-order atomic
> > allocations in alloc_flags") introduced ALLOC_HIGHATOMIC for such
> > allocations of order higher than 0. It still used __GFP_ATOMIC, though.
> > 
> > Then, commit 1ebbb21811b7 ("mm/page_alloc: explicitly define how __GFP_HIGH
> > non-blocking allocations accesses reserves") just turned that check for
> > !__GFP_DIRECT_RECLAIM, ignoring that high atomic reserves were expected to
> > test for __GFP_HIGH.
> 
> It indeed looks accidental. From the cover letter,
> 
>     High-order atomic allocations are explicitly handled with the caveat that
>     no __GFP_ATOMIC flag means that any high-order allocation that specifies
>     GFP_HIGH and cannot enter direct reclaim will be treated as if it was
>     GFP_ATOMIC.
> 
> it sounds like the intent was what your patch does, and not to extend
> those privileges to anybody who is !gfp_direct_reclaim.
> 
> > This leads to high atomic reserves being added for high-order GFP_NOWAIT
> > allocations and others that clear __GFP_DIRECT_RECLAIM, which is
> > unexpected. Later, those reserves lead to 0-order allocations going to the
> > slow path and starting reclaim.
> 
> Can you please provide more background on the workload and the
> environment in which you observed this?
> 
> Which GFP_NOWAIT requests you saw participating in the reserves etc.
> 
> I would feel better with Mel or Vlastimil chiming in as well, but your
> fix looks correct to me.

Thanks for the review, Johannes.

This has been observed in a browser/desktop environment test, where we have
noticed some memory pressure regression. This change alone does not make
the regression go away entirely, but it improves it.

I noticed some unix skb allocation going on and I found this at
net/core/skbuff.c:alloc_skb_with_frags:

			page = alloc_pages((gfp_mask & ~__GFP_DIRECT_RECLAIM) |
					   __GFP_COMP |
					   __GFP_NOWARN,
					   order);

But I tested this at a simple VM with the most simple workload (no swap,
writing to tmpfs) and it triggered with xarrays. At lib/xarray.c:xas_alloc:

		gfp_t gfp = GFP_NOWAIT | __GFP_NOWARN;

		if (xas->xa->xa_flags & XA_FLAGS_ACCOUNT)
			gfp |= __GFP_ACCOUNT;

		node = kmem_cache_alloc_lru(radix_tree_node_cachep, xas->xa_lru, gfp);

Where radix_tree_node_cachep, on that VM, uses a 4-page slab.

I tested with something like:

			if (order > 0) {
				WARN_ON_ONCE(!(alloc_flags & ALLOC_MIN_RESERVE));
				alloc_flags |= ALLOC_HIGHATOMIC;
			}

Thanks.
Cascardo.

