Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 16E7CC531FA
	for <linux-mm@archiver.kernel.org>; Fri, 24 Jul 2026 15:10:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EFD8D6B007B; Fri, 24 Jul 2026 11:09:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EAE506B0088; Fri, 24 Jul 2026 11:09:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DC4766B008A; Fri, 24 Jul 2026 11:09:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id BA10D6B007B
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 11:09:58 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 3D3FC1203C3
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 15:09:58 +0000 (UTC)
X-FDA: 85024005276.08.A092339
Received: from out-189.mta0.migadu.com (out-189.mta0.migadu.com [91.218.175.189])
	by imf19.hostedemail.com (Postfix) with ESMTP id 124FE1A000E
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 15:09:54 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=QRhPdMVj;
	spf=pass (imf19.hostedemail.com: domain of brendan.jackman@linux.dev designates 91.218.175.189 as permitted sender) smtp.mailfrom=brendan.jackman@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784905795;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LrK6XCzPn9w/pAkja+a0sS+++36AUS3xetGkCJHXVDU=;
	b=MCQPFaKvI+Kb06gAXK/TJs1U8Do81MfPnemv2X9ppkjM361OKjPJEKEhYJDtSPu0f20V9k
	c2Y3GwjKI5PCVAGHCdquer+orOti0lJP+akA3PCsbrn/oe4vS6Jsc4Rpp/qxsKlJE3gCwm
	cIUw5ftJaTWke2XOIWEK6I/KQ43iie0=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=QRhPdMVj;
	spf=pass (imf19.hostedemail.com: domain of brendan.jackman@linux.dev designates 91.218.175.189 as permitted sender) smtp.mailfrom=brendan.jackman@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784905795;
	b=Rd8zTTn1xwUuIEJb+hq5PfmuinHLblS6SU1AKjJthZYo5pdX24y+gNlXBAz3IoRpFAokoX
	7L/wQDuY4brJari17JYUuG5Isaz7E5YB/8D4+T8XiDjSNhAXtVcbulfeNX06HJnVT7Dxza
	6AZH6m1QyFTUjJIj6uZ5heTb7I0j1ug=
Mime-Version: 1.0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784905792;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=LrK6XCzPn9w/pAkja+a0sS+++36AUS3xetGkCJHXVDU=;
	b=QRhPdMVjufPUbcboXkrdt8XctcYEM20T/lv8n4fB4pJg/op1fAff/SrlEj5S5EJHIa/Urh
	71XhM44Xfy0b64c4KZt9KBbhXtd6Ytu1QVagsDFKPz3bIHbLROc6drVAaS+ZkwVC5fsI42
	MBkWvQuxE/buLUIjLWWP5itdXz1HQxM=
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Fri, 24 Jul 2026 15:09:49 +0000
Message-Id: <DK6WANTYCK4H.CRSXHW3ST1Q5@linux.dev>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: "Brendan Jackman" <brendan.jackman@linux.dev>
To: "Johannes Weiner" <hannes@cmpxchg.org>, "Andrew Morton"
 <akpm@linux-foundation.org>, "Vlastimil Babka" <vbabka@kernel.org>
Cc: "Suren Baghdasaryan" <surenb@google.com>, "Michal Hocko"
 <mhocko@suse.com>, "Brendan Jackman" <jackmanb@google.com>, "Zi Yan"
 <ziy@nvidia.com>, "David Hildenbrand" <david@kernel.org>, "Lorenzo Stoakes"
 <ljs@kernel.org>, "Liam R . Howlett" <liam@infradead.org>, "Mike Rapoport"
 <rppt@kernel.org>, "Shakeel Butt" <shakeel.butt@linux.dev>,
 <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
 <stable@vger.kernel.org>
Subject: Re: [PATCH v2 4/4] mm: page_alloc: fix non-movable reclaim storm in
 defrag_mode
References: <20260722150006.3848560-1-hannes@cmpxchg.org>
 <20260722150006.3848560-5-hannes@cmpxchg.org>
In-Reply-To: <20260722150006.3848560-5-hannes@cmpxchg.org>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 124FE1A000E
X-Rspam-User: 
X-Stat-Signature: gnjsgskqpfyntkrcreetpkni6gjg7nwz
X-Rspamd-Server: rspam04
X-HE-Tag: 1784905794-977218
X-HE-Meta: U2FsdGVkX18HU3li0FGPKXMCTVLqimxjY9GBBi2KwQnAWmfdrbLmQOJk7SiKJyXCsOYuiv00nViNwtnASnSNccAw/okDAP9wpyr+YKYGKK+NF9EI43D38yGB4YYkP/pb7qgQv/lQSDND/yGB6wZzaAlUD7g6mcJTLNFHn86P2XfH0O5qLae2yFmb2dY7vGWY+k7jW/rPM40EbK3IimNasR1U8lgWIFwGuSJHiyyfJB1tBVhuPDABlpOwgsXEGktpom1KI8Ex2ciarWNQXEltMKSqRDA3moBNFKTZFaI6OsfVydsgcfUuqinDfUuL75vdtBV4eLHveRbCkYkyKme3E/oZYQQAlLYmqsx31CyU+SxTQnHmRwCtp2SpIrRyUPLonw2LQ4smEtZz+FskEwKum1Yb7CSuTp7ne4nHWa2o9tY4pH/wQvZTNa7BdUfRTHRgjgvhDHr5CWxTKVHnoOhYJ3D3O1+ZPeaNmiza+bOEiqX2rBWgd1yEC0+VAdhPNmUUjHD7NT4ur4TfTGUPDbf0O5JWA5cVFn1NlDvnUYViP2skvQmlrHIsFB0e2wpA8pPY/lLrUzTHtL+8Bxr6khr4h0EHMaD7LmR2dI9Wvp3N5R7A4YvqyLAPTC252uRi6blHoThkF2ad2p1R67fw5+XJ+oTGEt0qh0GXZ35WBRnD/dVZkzhCIOT7L86JamMVxVjhz7Q8Rz1zM6TfunCdmXCwU+SGNAJVF+cL6FQelzyLKpYbDZzibTkjQswXv0uZr7CusNfs1O3ufMylH9aeAFrCECp+Nb8H3RFGicP6fiekvjquwLMf1hHw8mgfdgUHq6nNsBGtU/TA40UCQgd/O9XVbnvh8aHxFC0BOU4sodSSq+9PqJ+51TeCFx0/FjAiWhllT/VnXVejdVQS68g0RLuEnIGyp5QgjOGaAWPsHTTiOaGa6wOH5VrShk/6l4mZ6p5QD+O4Dv1Cd0LNec6VnYI
 n5xdUw3y
 1hlF6XyP/MF1HoObQIsOnCMDIT9L4hAtQeCXurh2Mr4qttja6l9G8VRBFL7jPbZ4sKBXKVgkIsYORzYMqTNREfrt0KYrY2z85Wp09NUdjapXJifnDaxU4tBNQGXFK5qPgJwRTC8je34UrAZPo+IqCTQLofzdlx6hhpICTidzr8NUDBuMK497dBzjqnePxwYnGmocQL9/XD6l5itFDlHRpwab4VB4Jc8CS9s8wJ3YHXHT2A5kxDO7wSuWfG41QoEIQKBLKWgkSjwRPD73ZYzh2De97LqNLfgUVNd1X
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed Jul 22, 2026 at 2:56 PM UTC, Johannes Weiner wrote:
> As we deployed defrag_mode into Meta production, pressure spikes and
> excessive swapping were observed on some workloads. Tracing confirmed
> that this is unmovable/reclaimable requests spinning in the allocator
> and direct reclaim, causing excessive amounts of swap.
>
> The initial plan for defrag_mode was to rely on kswapd/kcompactd to
> produce blocks, and if those are overwhelmed under high pressure, let
> the allocator fall back (__rmqueue_steal()) after its retry loops.
> However, that retrying results in more reclaim on some of these
> workloads than we'd hoped, sometimes excessively so, spurred on by the
> !costly order conditions in should_reclaim_retry().
>
> The storms are dependent on the request type. Reclaim will inevitably
> make room in existing movable blocks, since that's where the LRU pages
> live. So if movable requests retry on reclaim, they make progress.
>
> When non-movable requests spin in reclaim that isn't productive. They
> cannot use the individually freed pages, and the process is unlikely
> to accidentally free whole blocks to meet the ALLOC_NOFRAGMENT bar.
> They spin and overreclaim excessively, which tanks performance and
> triggers userspace guards like swap exhaustion or pressure based OOM.
>
> To fix this, send non-movable requests, regardless of order, into
> pageblock reclaim/compaction. This way, they help move things along to
> meet the ALLOC_NOFRAGMENT bar. After this patch, the reclaim storms
> and excess OOM rates are no longer observed in production.
>
> The longer-term plan is still to have all requests, including the
> movable ones, help make blocks to spread the cost of defragmenting
> more evenly and fairly; combined with proper watermarking to reduce
> allocation latencies in the common case. However, doing this naively
> unearths scaling and concurrency limitations in compaction that need
> to be addressed first. Promoting just non-movables for now is the
> minimally viable bug fix for the above issue.

Please forgive the noob question, I'm still struggling to get a really
good mental handle on this stuff. But what about compact_first here?
When we're promoting the order for compaction does it also make sense to
promote compaction itself?

I'm aware you said "minimally viable bug fix" so it's fine if this falls
outside of that, I'm just trying to poke around to improve my
understanding.

