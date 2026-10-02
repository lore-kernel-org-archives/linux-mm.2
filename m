Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A92A2CA5FE6
	for <linux-mm@archiver.kernel.org>; Fri,  2 Oct 2026 22:28:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AAC066B0088; Fri,  2 Oct 2026 18:28:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A5DBB6B008A; Fri,  2 Oct 2026 18:28:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9738D6B0092; Fri,  2 Oct 2026 18:28:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7D7EA6B0088
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 18:28:29 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id F10EA8087F
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 22:28:28 +0000 (UTC)
X-FDA: 85279126296.06.46A7EDF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 3212D40006
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 22:28:27 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=O1lDm6z9;
	spf=pass (imf12.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790980107;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nL/ZJzb+eWbYYnb+iW2qc4P7Usj9ljnxOgkJ0BBDdVg=;
	b=x275ZOqiFgHV3dcTMDTe22OBXzECB4Nae6seiLIeHOnR54pEPm2a90La6PInBde2vzu5Ag
	bs2ABvtNKO92XFhw+py47oCaLrIdPVhDmlhwObx6hzBkTN9Nbxcz49YH8ayMm1SAaZrAub
	YV81c0jRpRzRUSBBmuMivi0KZzr9MW4=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=O1lDm6z9;
	spf=pass (imf12.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790980107;
	b=5ZEr7gr3j8AHL9nUHjq6J+2Z+mfe+2mVOos4/B0vf94nGjhksZ3+v5X2zdvmNVgfXBj33+
	X0MWNhe64PqmQ6YM6V/k+knIglAK+bkcnmo9sycO70foArSHR+4sLg/NSjlLjwFN2hSprH
	O1DJUfOd4sCDr8pIJMAgywRi5eyprhw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4A30241143;
	Fri,  2 Oct 2026 22:28:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A6541F000FF;
	Fri,  2 Oct 2026 22:28:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1790980106;
	bh=nL/ZJzb+eWbYYnb+iW2qc4P7Usj9ljnxOgkJ0BBDdVg=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=O1lDm6z9hrvgFknTcEbmBpb4kZzRIzRb8Cr+61QGKNVqw/CHTSV63wzhcCKewo2J1
	 DiHXB9/F2ZR9jNGkNtvHjB5UkDVW9WMXLab0F4UifDDpVbMz0X4MhStvSslG0kkdgf
	 ALLCyTzr3PNj0nWSdJMaPhu+3bFzASE5W/F01Zkg=
Date: Fri, 2 Oct 2026 15:28:24 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Salvatore Dipietro <dipiets@amazon.it>, linux-kernel@vger.kernel.org,
 hch@infradead.org, abuehaze@amazon.com, alisaidi@amazon.com,
 blakgeof@amazon.com, brauner@kernel.org, dgc@kernel.org,
 dipietro.salvatore@gmail.com, djwong@kernel.org, hannes@cmpxchg.org,
 linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
 linux-xfs@vger.kernel.org, mhocko@suse.com, ritesh.list@gmail.com,
 rvvandan@amazon.com, stable@vger.kernel.org, surenb@google.com,
 willy@infradead.org, ziy@nvidia.com, David Hildenbrand <david@redhat.com>,
 Christoph Hellwig <hch@lst.de>, Dmitry Ilvokhin <d@ilvokhin.com>, Brendan
 Jackman <brendan.jackman@linux.dev>
Subject: Re: [PATCH v6] mm/page_alloc: avoid direct reclaim and compaction
 for costly __GFP_NORETRY allocations
Message-Id: <20261002152824.75ee2a39f5b705a85123ea74@linux-foundation.org>
In-Reply-To: <42d1a163-3502-49b8-9a27-7df9d06eee64@kernel.org>
References: <20261001082152.2879289-1-dipiets@amazon.it>
	<20261001182942.ce99faa753fb9d9bd2efec1e@linux-foundation.org>
	<42d1a163-3502-49b8-9a27-7df9d06eee64@kernel.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 3212D40006
X-Rspam-User: 
X-Stat-Signature: wmtg4arb6e4x6ofxz3645yckrro93wog
X-HE-Tag: 1790980107-692174
X-HE-Meta: U2FsdGVkX1/CJ8qKPxU0kamBK+m2ya5cMBjDTOo1JQBWST0kqblZdpDZmCF4KxV9/WdTe1bMRp97UqJHB3Z+ZZqpUP9Cv+qsNg4AmCm+/enN37PMJKaN0/XNPBVW9rH4dDZWfxDtYc6FOFhpsOSP5umPsitMI3t+wgj8cCRSZZ0GJ1hFUj8l2OS3Kj1/lB3JKiSwokbeiPr8aquG03usfO51yqms4Oct/3IYqvI4eisZpIm2OJra5lu2IasMly/r9a4A6ycNRdT1cLc01kEHSxU1P7HvdoYIIBozCRuWkp9Nj408w647iPvcwHgB8dqWYXYEEnkQR95Cz9N30ppo400TyRhsemFlEoFo9x+OGj3bA9+Eelt6VA2ynvwkgDazD87gMLRLaggSp75qd9PBs2G3WBw+qS2QKQikqRewKCL18FI1+h8Y7XUeUdD+nKtdIXJ3A7bxYNTMqhyE61CgY/u2NiZgXlWoMNS0cn8XQekER6WO1MdungzC+DwwFlyPBwCQRvTMxZxXDEDGcx+KqvqaHC2W8JQ22M6JnGtpSwkm1rYptmWVI68QutXCuDBuqvOr7cO5qW6YeomTp59L2l3fiB04Smacy0gWqgHRDCe8yw4nKvsB25hFvXvZ6cUfYOT+MOUyNEAXzuxVmEb15cZl2kL4oYn4oHaApAqEZycnpOIMoAUB5m43Dm/S7KUKNUXelhSidHS68L4rb4DsmGwxwHhzHLC1GI4UQpD17A2D/7vA8ucE7rzELF3HKG4OITyIhaTjfcaOdcQTX8kcyPY2osghyeUmjs3uAKjIn9tisNwx94h0iXXYOHxgKqz9oukT8HeMRMEoMSsX0fQbWLao6hqQe8CamNku5WImJEo/1W+ukXpB4W4ssiPJFVhqHjc3vzQvae5YXQkwAhgYOXcukjG+lD8zwbUpRxcupUMV5lNzm7NtNe88nU7ULaCeyO52SYeZwwAMNsU2AsY
 U+4GR8lg
 /+MT7c+CA/hu1jYB6eoiKJcmBSoqofBO9IDwlXmNPcpZ9Rzogmettv8HLXhdSLtIwf+8VI6VSvAF1pwAdCLaOeV1l9oNMDjw8FVtFoeXNrgRGPP3DU6h16QkeXdUmgIIVlr8KPZ6KdcLIKRbWe+XEMMnMD48W5IBNPBYvmby557tvyPZZDbFi5Onq+6YMeuzkKBA7QJgog2oF/H3DBbjqgZGZr97YCvU1YrlzpU4ygz08CBejzxsPlqgXQ9WjqdJ1dYdruw3qq6P8+RDIqTGpirePcHqdlfWkoNB5MYucXBG7Ixep0iU+cTuAAD6ntrmwQjtIpAtRt6/f+h9VmCkh+i0iPEva1CdSu1wtLDA0dQJEuRyDKuhZCHyi+aYhQFgTCWDN/dQxF7KveQw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 2 Oct 2026 10:23:47 +0200 "Vlastimil Babka (SUSE)" <vbabka@kernel.org> wrote:

> On 10/2/26 03:29, Andrew Morton wrote:
> > On Thu, 1 Oct 2026 08:21:51 +0000 Salvatore Dipietro <dipiets@amazon.it> wrote:
> > 
> >> Commit 5d8edfb900d5 ("iomap: Copy larger chunks from userspace")
> >> introduced high-order folio allocations in the iomap buffered write
> >> path.  When memory is fragmented, each failed costly-order allocation
> >> enters __alloc_pages_slowpath() which runs direct reclaim, direct
> >> compaction and drain_all_pages(), causing a 0.38x throughput drop on
> >> PostgreSQL pgbench (simple-update) with 1024 clients on a 96-vCPU arm64
> >> system.
> >> 
> >> The root issue is that direct reclaim and direct compaction are too
> >> expensive for hot allocation paths that have fallbacks to smaller
> >> allocations.  __filemap_get_folio_mpol() already marks higher-order
> >> allocations with __GFP_NORETRY | __GFP_NOWARN, signalling that the
> >> caller can handle failure.  However, the page allocator still enters the
> >> full blocking slowpath for costly orders with __GFP_NORETRY, which is
> >> unnecessarily aggressive when the caller will simply retry at a lower
> >> order.
> >> 
> 
> Since it expands the impact of a pre-existing bug of nonblocking allocation
> eating reserves [1] it shouldn't proceed to mainline without a fix for that
> (Johannes posted it there but the review discussion got stalled).
> 
> > Thanks, I'll update mm-hotfixes to this version.
> 
> I've also argued for not handling it as a hotfix [2]
> 
> [1] https://lore.kernel.org/all/9f415dc7-adad-4161-b20d-7c3173f50ff3@kernel.org/
> 
> [2] https://lore.kernel.org/all/c6e2c1e1-a285-406e-a2b6-c09e05df91d8@kernel.org/
> 

Thanks.  I moved this to tail of mm-unstable, removed its cc:stable and
added a note indicating that changes are expected.

