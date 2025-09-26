Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 71942CAC5AE
	for <linux-mm@archiver.kernel.org>; Fri, 26 Sep 2025 16:37:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 99B498E000D; Fri, 26 Sep 2025 12:37:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 94BB78E0001; Fri, 26 Sep 2025 12:37:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8617F8E000D; Fri, 26 Sep 2025 12:37:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 772D48E0001
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 12:37:12 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 24FFA11AB2D
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 16:37:12 +0000 (UTC)
X-FDA: 83931956304.20.400104D
Received: from out-179.mta1.migadu.com (out-179.mta1.migadu.com [95.215.58.179])
	by imf27.hostedemail.com (Postfix) with ESMTP id 25BBD4000A
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 16:37:09 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="PzA/G7q1";
	spf=pass (imf27.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.179 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758904630;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zBmaD1iUgrP9LAykZKE5mdL2TUB2y38Dq6j4bJYe8es=;
	b=tVWsr/f6IapS71mYPvJnPh3f/exJkFkaab3N9fuLK6eY1Kw3qsH204FB7+C5xN9SZWCC4X
	iAwmZNky+mmQns64bUQdlIZF5ohJsy31jNiBXDQ/0nJbbRWPin8dahlmPuXyTcqSnIt9AJ
	lJqQgTYcoSdhp0KUUalW8DApMXjmbI8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758904630; a=rsa-sha256;
	cv=none;
	b=BSXjgm2iPkn78J5L+KZIOtUgXb5I/jIXbuCMfluzjdq/MqnyuyzAhq5+DE4vN/xHsn2sTJ
	z/NBAQnaaY0pmdh+zfkohlt0nzvCYsc/HidXBG6283RAfOBegqZopns9UJ8KnUeJa0gSBS
	bm0F48oYETcI7jpKm4ImF47p/KBsufM=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="PzA/G7q1";
	spf=pass (imf27.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.179 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Date: Fri, 26 Sep 2025 09:36:57 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1758904627;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=zBmaD1iUgrP9LAykZKE5mdL2TUB2y38Dq6j4bJYe8es=;
	b=PzA/G7q14iI5lyvL2jQs/Q4WwjzEmT9PZkSBDZhX3shplXsvXRByZWlJ/0uho5YjTKjbiE
	EzpO/2mS4VDnypzH+8oS4xP5OPQ1BXcbaXPCVVtAUI/s8Bd7/ksCRYj5v67k5fcF5ojTmu
	t/8zXuDXrLsK68IGAPLi/qfiJTQfZmQ=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: Zi Yan <ziy@nvidia.com>, David Hildenbrand <david@redhat.com>, 
	hannes@cmpxchg.org, hughd@google.com, mhocko@suse.com, roman.gushchin@linux.dev, 
	muchun.song@linux.dev, lorenzo.stoakes@oracle.com, harry.yoo@oracle.com, 
	baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, npache@redhat.com, ryan.roberts@arm.com, 
	dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev, 
	akpm@linux-foundation.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	cgroups@vger.kernel.org
Subject: Re: [PATCH v2 4/4] mm: thp: reparent the split queue during memcg
 offline
Message-ID: <v4ihmnzafzwfgdbk6gcnl76bjqko2t4wdz3vy32vjuzffzzt6i@uxecpmupkqh3>
References: <cover.1758618527.git.zhengqi.arch@bytedance.com>
 <55370bda7b2df617033ac12116c1712144bb7591.1758618527.git.zhengqi.arch@bytedance.com>
 <b041b58d-b0e4-4a01-a459-5449c232c437@redhat.com>
 <46da5d33-20d5-4b32-bca5-466474424178@bytedance.com>
 <39f22c1a-705e-4e76-919a-2ca99d1ed7d6@redhat.com>
 <BF7CAAA2-E42B-4D90-8E35-C5936596D4EB@nvidia.com>
 <tyl5nag4exta7mmxejhzd5xduulfy5pjzde4mpklscqoygkaso@zdyadmle3wjj>
 <wlbplybaecktirfzygddbvrerzrozzfudlqavkbmhnmoyt6xmf@64ikayr3fdlo>
 <fc91a0ab-e343-4f7c-8fc3-508ab0644e42@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fc91a0ab-e343-4f7c-8fc3-508ab0644e42@bytedance.com>
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: sng7ssd6sp7wd7iebmtd13dpxb1yxdsa
X-Rspam-User: 
X-Rspamd-Queue-Id: 25BBD4000A
X-Rspamd-Server: rspam10
X-HE-Tag: 1758904629-892838
X-HE-Meta: U2FsdGVkX19yo6NJFuveQiGEh+Ky9kGrcV30Nr6sZv2cAfmm/mKqiiMqgfAGRMKo1nUHVzSO3Anfjrjv3jO6oWoNsu0nvx7n5TpsSt+LvpQvi/MKu4xsFzGhMKu+CfAIXnX7Xj8X6YB4s0sUjTyLUw5pViARePHavbfdgcHX1gm2IwRsbv7xMD6d/B/wn2136cbRbzm+Rh0Mvim5ygwGkj/usymYx0Mviidh4dri4SBeCBI1RBuWuC7Y2zKbZ0SxEdQyC6f5ze5Mb9R0m0gVD3Bc5dQrNzSPx+u6ZPq36Jbge6Ii1Y8B32iPXfAd7UFz5tsy3RXEV4YwXrtl6LMZVMEtv4K7EBVWGv7WIC3Xll2gehwU7DdvmIJj0y2dzg9Vl8CT0IqXdqrxcTnaSqjDPD34FLCMaxviFBzXh4kNBZXwYjbRfCnbIkXeOvU85MXBUquwWj4VbGg4fS1P2k6wXNwBp9V4uLy54vEe1ecuQwCzVeDtpCpxdxFG6t3/QuyenMo/XMYavpV7Odt5MkJpKlLkRUjGSxzUrDEdMIdaujyxE1+RpdOV2DoxEp76CfqrQ4MtnqR8M6QNHC01p5+LqaoExEjNZQ/oprHxq9NLlZeiIrYrFR66GCXXkSHnKCKeO5yNU1LuPh9PE8ZlLq0/D+yVJAxPa36lpGSsanv0h0Oq+NMHTboImhNF91FgFfwLMbWBoYSuh3NvBwX+KqMlC+RfKz89DUChkP0O/W3n69MxZWxjr8aSoNLToKTqXU2zKPOsG786S25hYgwEbnWwCbKGJAUIwHuE6aeYO8B2YTlum2dr2JLGlxd4eiOviPRFGwuE4we8job2oauGHT9sP1BvFjzx6CoypJdfQtx1AlqKVnAiU7A79g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 26, 2025 at 02:57:39PM +0800, Qi Zheng wrote:
> 
> 
> On 9/26/25 6:35 AM, Shakeel Butt wrote:
[...]
> > > 
> > > Yes, css_is_dying() can be used but please note that there is a rcu
> > > grace period between setting CSS_DYING and clearing CSS_ONLINE (i.e.
> > > reparenting deferred split queue) and during that period the deferred
> > > split THPs of the dying memcg will be hidden from shrinkers (which
> > > might be fine).
> 
> My mistake, now I think using css_is_dying() is safe.
> 
> > 
> > BTW if this period is not acceptable and we don't want to add is_dying
> > to struct deferred_split, we can use something similar to what list_lru
> > does in the similar situation i.e. set a special value (LONG_MIN) in its
> > nr_items variable. That is make split_queue_len a long and set it to
> > LONG_MIN during memcg offlining/reparenting.
> 
> I've considered this option, but I am concerned about the risk of
> overflow.

If you modify it only within a lock then why would it over or underflow?

> 
> So I will try to use css_is_dying() in the next version.

No objection from me but add a comment on the potential window where the
deferred thps will be hidden from the shrinkers.


