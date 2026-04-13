Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2F3F4F34C63
	for <linux-mm@archiver.kernel.org>; Mon, 13 Apr 2026 15:38:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 68BE66B0093; Mon, 13 Apr 2026 11:38:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 663EB6B0095; Mon, 13 Apr 2026 11:38:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5A07F6B009B; Mon, 13 Apr 2026 11:38:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4D1086B0093
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 11:38:30 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 19247E03DB
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 15:38:30 +0000 (UTC)
X-FDA: 84653939580.05.0E7734C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id 53952C0007
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 15:38:28 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=nLWZvOC7;
	spf=pass (imf10.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776094708;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=d389xsFpECFT5XvZW4LaomTpdNNCG/rYyqdyExKIQJw=;
	b=vcTMhFPWAJZDT0iErKVqv2xFbd0D+OAYy65o46aUbBIduakeglFg+jBeaTemSVQ+Aqg1jc
	3LJZjvyiL7kACIRxI3wQFaw4fwQKEdOgWs2FapEeyC9xH+7GBtGKhM0QhQC3kmU2eTMiqd
	isbHgn70POoIIacCHgBSPBcLhgaZ6hE=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=nLWZvOC7;
	spf=pass (imf10.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776094708; a=rsa-sha256;
	cv=none;
	b=XPECGqsnEw5djfODY9ReqJeXe/m4q9lwJND6gIFZdchW0K8WP/681uvKS7hk/5T0jSxZaI
	FTqpC21yV2fwhMkRAGEvEGdF+6NwJFWPLUxRUXmCqi3KIOJaJbsz5Gco9hGLi4WyNqNqsg
	axntIABmbmLDRPAbqSDGMku6000q8q8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 9DEB660172;
	Mon, 13 Apr 2026 15:38:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54969C2BCAF;
	Mon, 13 Apr 2026 15:38:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776094707;
	bh=mZpRvz7G8OpmAEE71Wnk9PIg6d1HTndlpxTz7DDiNKg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=nLWZvOC7HXFamfr3d32XycFsgIQfHX370qoWehj9VS13JL9VHdZVOjADoNWax3WK1
	 8VsI0/KOM8L0oM3UiwNBqCRARPFU4i9VHi7RFiws0cf2/eHoAZHrlB30lLlKgTqDXe
	 ecQ+rhI/BhzMxosHSIIAPdlPQxwjbDd6rOYskb1CDATWCybduvc0o1cN0Yc9gqch2F
	 +Mrsg+VOiflf9XEoulGInr5BLopDQhBGe4miCALqYeO25d2EFKUzvf4MDq1wfAUx4x
	 1x8ZqAERHk3ArhlRo516dYON3z2FAtsLIzVDngdbY6TN3eGcyQP2aQ3lg6PgOVjJSt
	 K7VvpIw7EcGLg==
Message-ID: <6ca33173-145b-43aa-8a8a-34985d375246@kernel.org>
Date: Mon, 13 Apr 2026 17:38:19 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: Require LRU reclaim progress before retrying direct
 reclaim
Content-Language: en-US
To: Matt Fleming <matt@readmodwrite.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Hellwig <hch@infradead.org>, Jens Axboe <axboe@kernel.dk>,
 Sergey Senozhatsky <senozhatsky@chromium.org>,
 Roman Gushchin <roman.gushchin@linux.dev>, Minchan Kim <minchan@kernel.org>,
 kernel-team@cloudflare.com, Matt Fleming <mfleming@cloudflare.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Chris Li <chrisl@kernel.org>,
 Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>,
 Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>,
 Barry Song <baohua@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Brendan Jackman <jackmanb@google.com>,
 Zi Yan <ziy@nvidia.com>, Axel Rasmussen <axelrasmussen@google.com>,
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
 David Hildenbrand <david@kernel.org>, Qi Zheng <zhengqi.arch@bytedance.com>,
 Shakeel Butt <shakeel.butt@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260410101550.2930139-1-matt@readmodwrite.com>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
In-Reply-To: <20260410101550.2930139-1-matt@readmodwrite.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 53952C0007
X-Stat-Signature: 5crqq1nnq9caxf6es141ankggf91cjdc
X-Rspam-User: 
X-HE-Tag: 1776094708-819398
X-HE-Meta: U2FsdGVkX1+0bAJsXg0ijk/6DvylgtfK1bibiZdhsQKJxvZQ+CJm8AdqNT+oBhcapnERWGwcT0aOYSzlaetSF6CfZSXL3Z13twxdW8TMr8/PGZAiUu3GzqAO/BAhLCzCY1uoUbJk9GfkWIWDDQk8Ok0qW2DpPeFh60AgYkZHsn85a0RtEWJYpEFf66lbdGzR60II54bD2nMFfAlRtbPLWjzA1LkHwfCu1K08cyOlPvt7UI/MxhDtlpKIdf5SI5oJyfw+FfVg/lwiZOHZBdvFuDdphGKyG12j4XG0xyl0APq3oP4caSa0aGyMamqMt7tyDp23OTp2fDhpftOmODmrG2hcUw9jbzbI5pFjU1TjxA4kgbMPLdhpZxD4viXiVNh7ttLyayPySzlSQk9V8BqkSLifIevh3XSXy9eRbKCrbtmj0j7XmSMrUPrNMY0rJcqHSgS2ElTLqITAGVuVGNlHOB38z+v2/ZmH5zZh/1QsDPGpbwJTLtDdiCu9iwVIGoSqsZZ+IsyTwtx2jWPPtaP7P3MLmN7Gw5op03SQFQU4DNfYu/eqIDZ+0g3SdwOPa6B17BBnp5IpTMO6dkWbxcgqpRuHv6DIUXwcF+MbnrJJYEoUYck/awf2NNy/SHTKNC47DcYo/qQ0B1uwDOmq+juJ52HQHl69hTchWPaklPIJMc2U6ITwWLl1ztmnSSubwd7BXyAluf3KQg8J408TDEWL8qxL668Uj2kgGC4PXKprm6KDC5YyHzbUU2QabZNU4V8lv8iEk8lw+R50STz6f1bICakW9LgVHZgeaeUvVjnQVHBPK2r2Tevu/zYBB5Aputh3lUlx73883IvWn44Klk6zXCifFqHwSuCr4FOOa0gELWdJkE2zIBCXcxoBWJu5/iB0iAFVRVX3Gxiufvh+x93IHnby74YfIzxZ397JomoXypcj55YajNgVz5vxom+DDw5xNzWpDjYeoGPxoi1U1gX
 oKDy0BJJ
 +wRLFVNKRVOHknEXLA7E+tPDj4fsaalvaPe4DyfT0D6FdTfBuuHJMXjk2rOJmlR6+4WSNFY0xAMA2G1CPagdLyusxCS4X3wuTyUAo3yKDEvoWp9xeePMjyIHG18W1dHVyU34EF4EH4z3xnxKtYcX+QhTLRMg9t7wfK02I1rJgkyaQTXWvKPRcaZH0mZq0dh7YXuxWG8NB1Eznicqa119CHgClfzdV4m2YwHfa8cV9MwGcsL+fyrIOsQRFCxmQ5A1euKKluWEsDZZNBce3+lsi0RGiipmv3xhKpX1IIt4jHkO4J/0jhjrPeMb3jJL2lg3w529RIdAtjX5FaF1cSzh5cHSsWw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/10/26 12:15, Matt Fleming wrote:
> From: Matt Fleming <mfleming@cloudflare.com>
> 
> should_reclaim_retry() uses zone_reclaimable_pages() to estimate whether
> retrying reclaim could eventually satisfy an allocation. It's possible
> for reclaim to make minimal or no progress on an LRU type despite having
> ample reclaimable pages, e.g. anonymous pages when the only swap is
> RAM-backed (zram). This can cause the reclaim path to loop indefinitely.
> 
> Track LRU reclaim progress (anon vs file) through a new struct
> reclaim_progress passed out of try_to_free_pages(), and only count a
> type's reclaimable pages if at least reclaim_progress_pct% was actually
> reclaimed in the last cycle.
> 
> The threshold is exposed as /proc/sys/vm/reclaim_progress_pct (default
> 1, range 0-100). Setting 0 disables the gate and restores the previous
> behaviour. Environments with only RAM-backed swap (zram) and small
> memory may need a higher value to prevent futile anon LRU churn from
> keeping the allocator spinning.
> 
> Suggested-by: Johannes Weiner <hannes@cmpxchg.org>
> Signed-off-by: Matt Fleming <mfleming@cloudflare.com>

Hi Matt,

so have you tested it for your usecase with zram and have any observations
how it helped, what values did you set etc?

Vlastimil


