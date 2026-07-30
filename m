Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9C114C54FDF
	for <linux-mm@archiver.kernel.org>; Thu, 30 Jul 2026 10:57:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 858FB6B008A; Thu, 30 Jul 2026 06:57:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8096E6B0099; Thu, 30 Jul 2026 06:57:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 71F416B009D; Thu, 30 Jul 2026 06:57:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 48F666B008A
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 06:57:16 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C1ED3C0924
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 10:57:15 +0000 (UTC)
X-FDA: 85045141230.11.1D9AC50
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id 221691A0003
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 10:57:13 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JjTthBN7;
	spf=pass (imf19.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785409034;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=s+DGim6f9hRKeeOt/GNuiTh3xBY1SZwuIohJg87lh9U=;
	b=w2ex/Tf4nsiBS5nWZY1j9Egsobw/kCQ5A4Y5qJ56B/dRoWdl9h3nunpt62IRV5X1kPM3qU
	nXZ94tpz8XOEHUkJqWkWmLZN+xl8yt6aUxC41G2P59WRMvOZwWfa3DqBz4yGQM82iPNRoP
	AOKAdWKTnG5sXcRinqbZm2wV3d/sWyM=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JjTthBN7;
	spf=pass (imf19.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785409034;
	b=ntw8THPbR5IzHs7PzvdODG+3LpbQb7JfhlNG4V+qmy/qDV9UpJXkwMNInJKUn8RrO6QjyF
	kNZ92STqAIdIFTnGpWceFX3h+9Oi797MLdelaRNYAcBMFZcqKISkbDaZrv6MEIwQ0KqUtS
	jiZWUmMvP6w24BA6UhBqQU3O1y1wKqM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 558EC43B96;
	Thu, 30 Jul 2026 10:57:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 643821F00A3A;
	Thu, 30 Jul 2026 10:57:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785409033;
	bh=s+DGim6f9hRKeeOt/GNuiTh3xBY1SZwuIohJg87lh9U=;
	h=Subject:From:To:Cc:In-Reply-To:References:Date;
	b=JjTthBN7leN5wgSNiF1p6cS9G8g6HYxncMhEfkOejiYagZFKC+H5+4585yURMNUru
	 +RIJbqombBVmX3/LVpzr3qvMU8ZCl0LbRUFOiVmXoit0hBrOezKa4ji5AOkgw3ys8G
	 5nsR3wuiUxSkKaUD/zeXAtHsKm8Za0ys9/qW5fDVUkRNPelt8Z3FPDKyxcq3TllGrf
	 GTBkMh39RS0XeKC5fGx2wEb+XrsNy1tzNm2DcW9XWZGt6j7p3PF0H90FKmW0ihlbjA
	 IgBifsndP+j4n2zZI1aMpSDcfSbHNdtI3v5JmnZ9HXZUP9Av/NVvZUwqSxeZ6QKbvm
	 psko+QUfnbynQ==
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v2 06/17] mm/mm_init: factor out pfn_to_zone()
From: Mike Rapoport <rppt@kernel.org>
To: Muchun Song <songmuchun@bytedance.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 Oscar Salvador <osalvador@suse.de>, David Hildenbrand <david@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, Michal Hocko <mhocko@suse.com>, 
 David Laight <david.laight.linux@gmail.com>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20260720093127.540540-7-songmuchun@bytedance.com>
References: <20260720093127.540540-1-songmuchun@bytedance.com>
 <20260720093127.540540-7-songmuchun@bytedance.com>
Date: Thu, 30 Jul 2026 13:57:03 +0300
Message-Id: <178540902325.2154539.8652625248432655233.b4-review@b4>
X-Mailer: b4 0.16-dev
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 221691A0003
X-Stat-Signature: xhbcqcw3qz94fcwcr746ddrqwninjefo
X-HE-Tag: 1785409033-914725
X-HE-Meta: U2FsdGVkX1+8zLps+y/VtruTE4p1o2b1vhtLtN4QtLVB7v9pqh0N9trLv2rcHzOgy3QhMPzTbeHGkaW/bj3m98kvL3b0Hfetb6dEq1q3OD7bxbszNTXznDvW79UYOKCO5qunMSdgycpD7fd3rQIiafPPRPvIIzcxDoUj9h7KY/8vgs7SufnGOiSKwF6mn00u34TK1STLUVRN6YT0IVovHJ6mXCTXUsEDpjI1uc6Su/NvLakajWIDb78cr94k9yjvHdjbr8KDeM3SG5MHtS8s6e7CbxjNdrD2dFn3740rqYG/hhRu4sWgNQEJGoju3yR8UOX4Phg6+sKu+3s01dyTBqr9RScs8xDo2tpzxyP1UdFGcZvJplMl96TecobAVEAB0y71fwotEwH1BjWZdH+bjwD6BK0zXe3ch5SxwDwukLCNGT7HDRI3kQWAvWTEB0jPbxkyatJKVGOy4uiSWwhPgIQ2s3z8l7v5bQ8zCFvk2K0IxlcaE1OKpn7enDOjEe/84WpzWeimI8bU1ZNv8WVASrzSvZEwory3QRNw5sa+0YdzbQCpOG3qBlyFFCmJa7t3BnZvwelBJRHPPImTZMNy7ARzN0OZ9fIPegu0OjX+WcBSgbOYHWw+RJL7+kCR2cRNLsoaQiU1QpLn5wuvz+6t8nu+Xy4562PH52xtmKoJWcxSIwlPLezOt8SfqI+Gwj2Is5aER4bo8lUKXjoUxQLmNfgtwVugjt3AaYoLVZ0tCxIquJdnP7nze+/KjVwdLkgasJKxlw3fvqYSUPXMjOFdyT5bRz0N46IRMcUgZ3m+wDT/ONVMc3P7zdGoxNxOQf3SXZDDDlfo2aU3+DMImwj3AqzZ2Q5Numm5svyWxfvvLsapzItaGWzPhKJygzLWm4kK963spYPiZzo8Zg1OTAMkcrO2O2VCVuHSd05i7KhB9qYNGFD7IFlzbCCkzCxeL0msCOzpMMuDaX01ynnNPDV
 Wii9Pxw7
 biO1iORfUcd7g2zzb6WJJoFW/Ks/DJQO44z83vZnzlz+aunTXizfGYTTC4lqR84qR9ixhpmfMDwyA9fogI0TsabZd0WMnhqTuF/dkLL0CCcz//SjdNuIcB+DzR/bQ24G5LCrnI/GGjdm9mB3nWnPDpbVopYlFAMPpwwzPSLVcJxR3m/SEKsp3AaDOKSQnbs2lLFo6fQK6DtT4JDeumA8qXscZAWrr02FpFiQ3X3Ipo2GZk41dkkLRnJny7kdML4/6DsZxRMXEyrywLkQmCWU/Jw4lYxgzatALUWFlc9Ow4OJGrR58Ol62LRs+hiGjnR6TmLoo+USQYzXbgjZB9wTt4TWB44Q4ec6ZIbG7+VvFLXX5/tK4T+ig70D0+FHQ0EjpxTG5/iHcXkg4KZQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> pfn_to_zone() in hugetlb_vmemmap.c duplicates the zone lookup logic in
> __init_deferred_page().
> 
> Move it to mm_init.c, declare it in mm/internal.h, and reuse it from
> __init_deferred_page() and HugeTLB early vmemmap initialization instead
> of open-coding the zone walk there.
> 
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>

With the commit message updated as you mentioned in your replies

Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

-- 
Sincerely yours,
Mike.


