Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 353DFC2A073
	for <linux-mm@archiver.kernel.org>; Mon,  5 Jan 2026 02:32:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 79FA06B00C8; Sun,  4 Jan 2026 21:32:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 777576B00C9; Sun,  4 Jan 2026 21:32:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6AD756B00CA; Sun,  4 Jan 2026 21:32:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 583C16B00C8
	for <linux-mm@kvack.org>; Sun,  4 Jan 2026 21:32:50 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id BDC15140C37
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 02:32:49 +0000 (UTC)
X-FDA: 84296337258.19.1F7ED7E
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf21.hostedemail.com (Postfix) with ESMTP id 60F5D1C0006
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 02:32:47 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=BMc5I14R;
	spf=none (imf21.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767580368;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lCeFINuEpZTgO83TvN70WfqLpvLxXbwhEJYmsPx6DPA=;
	b=A6QNQyNistjfL6ZE4DtSk5O7ChugeKbaVEYbRD76Jw5aspKWF/ZJd1U5442tIUr8dawkyn
	Xi6CB5kqwV8F3CDsUqufEc2D8jb9Wrs3TYStbX/xCUgVd9ngx6qWYOvfP5s9VSFDspYRKi
	CulEkMhGM+4znyTmcw7hh+dMNns146Q=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=BMc5I14R;
	spf=none (imf21.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767580368; a=rsa-sha256;
	cv=none;
	b=HikxAXSbTuZLMXhzC8y3+TuzG12ImdDOiplzuNZAh87JVYVuFRBECquiBwBfRABRRSLt+Q
	/X+Hf+PDGj/ZT4OTn+lEo4Jo+m1OqtnGUzPQuYb8V8zRBRHdE3kzU+VbHa0BcE9vk4z/q3
	OxXbkF4gQuw3DDUcYArBiYt/QPL+z/Q=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=lCeFINuEpZTgO83TvN70WfqLpvLxXbwhEJYmsPx6DPA=; b=BMc5I14RUoMck9ZAvxtXoxbUu9
	eL1ReVBSaA4jKnqyxn+Y3X8dgEeOAeyuqC/pdzKEKVFD3GqpHwGHwa8nEQIolaCy0l2vFAbAgBBy+
	56ldn6XtNISYMSbsQ706P/B5VWDKQXIr2g1zR14EthGkKgjHQZCR4UZzwiuW2x2JxcqYDVrtwn09z
	vgf4rvEvwNcS51by1OXxLMPCLaTVLrMi8UukdF64QbBw6CR2rQE/Fngm8Xm012pWKKO7WDYrc2R4U
	7wv2nm8hjedMkqa7laLIOvEUK8RYX5Xfa56fMen6KrCIaY8/jDgXWP+Ks2I+i3df4gOKVTczvh3W5
	IN+5bYgw==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vcaOc-00000009l6D-2VNa;
	Mon, 05 Jan 2026 02:32:38 +0000
Date: Mon, 5 Jan 2026 02:32:38 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: wujing <realwujing@qq.com>, Vlastimil Babka <vbabka@suse.cz>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	Qiliang Yuan <yuanql9@chinatelecom.cn>
Subject: Re: [PATCH 1/1] mm/page_alloc: auto-tune min_free_kbytes on atomic
 allocation failure
Message-ID: <aVsixmk_D99cZqz5@casper.infradead.org>
References: <tencent_C5AD9528AAB1853E24A7DC98A19D700E3808@qq.com>
 <tencent_9DB6637676D639B4B7AEA09CC6A6F9E49D0A@qq.com>
 <20260104101443.f10264bc9730de884b52c5a2@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260104101443.f10264bc9730de884b52c5a2@linux-foundation.org>
X-Stat-Signature: fwixyqw8pmsduq68r9q1uo8r6yqu6hj1
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 60F5D1C0006
X-HE-Tag: 1767580367-315883
X-HE-Meta: U2FsdGVkX1/qVpJ4iFbnmThlGoVrC681Syps9ak52LLs025kIdh/ymjwNFLiKRCsuDKKLYAUzJT9erBOh9NONpiw1m+lZdz0gWNi5xfAZI9ooHhoHB8jU0+SuSbMCFQRMOFwglQ1x0sma7TLH14yKmZwa1cCG218hxB7vxaY2MCXIej9qJQx0mF61hxT13trF8cyxq3daWkRLuwzqrdV6KrULlThlNzNoeO0n/KOsCH5USdOSeSqnWf2n7D6n9NFAf7sX1UICh0ffSB5g9SxHABwG+n5rYULqwqPNE7r4MqOy9gh85qKPXH6kUXHpho1oeyKqlRsrLbTqI5xAXc0+jg7TH0nPirpe/fFGBoP19310UTkn6U54kVXHo4D9SkvSlxFpC0whvqMKiE7NOPylpwknjQr3JnEibj+fi5I7DHQ9FMNKj5Chl5SSaYDwVcMKQeZUIHvXzgAAv7LUhdnFIpLA1MbTwWoKf/Bnwe/jExiBZNhNJY/asCvDU7+krzGsvZNk6jnrJxMGnfHxIx8w3wC/G5OS4vP7rAO3uUBEmiDSD7Q/vrbLrjAIc7oOrSSIQB7GUZwBrH6Tcc/dFv9b+5HBZnFjod+wIwSSg30eg1m4369V4R4jRbREjNilBHxFXZWc3Az5hUmE9/itd/OsZM9sKJ2bqIwe9harlK8zx4muBlO3sIK5hx70VtKMeb0//OGiosIu4BA8ZvH2TQ2UZ3iFEOoionN07wfEflf65aU6VTAkSRsurTc/EpEqM/UphCye06F0Tst828VUVq9O9TDD8YFchkaXcmQUYgCT9wABuniIVt+d1CsfIEUhtExUbG9ThYrOPyu3Pp8ToCazAi/6I3HhvkvY7LWO1cCrpUAmPWT4jmRzQXawQPs+9uP5/LSvQylxqs04remHOvIlM1+x/7ZSvn0rVj+6grR+LfC4YbICjH6ryiQrp8847AB7zpPGLaK9pFxqrO/zPR
 hCu/lqhh
 xAND6pgorBfQ8sEvZfzczD2AkkOiR53BHeJIdiKk+6tA7IPYcz2pcowIEjYmqOJh+gLFKKNaki7HDxskHgVX30f+q217z8bJ/sRFNT5B/dVFy8qwbjgjWvNqNhegdk1W5cTGorQtAdnR/PAY5g1kjOwhEC8z3KskTz5yRaHk20+Pp+4cOXrtylo0f4u91j/1otZ+5skAwWZ85+z/CMevtbJlh0NF5U2ejucCiv7rD8DPaQEu9C+Sa4N/ARFiWHurrC5UKXGf4/ZOSKgth1405p2y/yovcqXAvtIGJqzA5sCflwvj1TEnH3NYGnEZwcuEw9NRTS4yihXOE9MNY79AKslPliQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Jan 04, 2026 at 10:14:43AM -0800, Andrew Morton wrote:
> On Sun,  4 Jan 2026 20:26:52 +0800 wujing <realwujing@qq.com> wrote:
> 
> > Introduce a mechanism to dynamically increase vm.min_free_kbytes when
> > critical atomic allocations (GFP_ATOMIC, order-0) fail. This prevents
> > recurring network packet drops or other atomic failures by proactively
> > reserving more memory.
> 
> Seems like a good idea, however it's very likely that the networking
> people have looked into this rather a lot.  Can I suggest that you
> engage with them?  netdev@vger.kernel.org.

Agreed, the networking people should definitely be brought into this.

I'm broadly in favour of something like this patch.  We should do more
auto-tuning and less reliant on sysadmin intervention.  I have two
questions:

1. Is doubling too aggressive?  Would an increase of, say, 10% or 20%
be more appropriate?

2. Do we have to wait for failure before increasing?  Could we schedule
the increase for when we get to within, say, 10% of the current limit?

> > The adjustment doubles min_free_kbytes upon upon failure (exponential backoff),
> > capped at 1% of total RAM.
> 
> But no attempt to reduce it again after the load spike has gone away.

Hm, how would we do that?  Automatically decay by 5%, 300 seconds after
increasing; then schedule another decay for 300 seconds after that until
we get down to something appropriately smaller?

> > +	/* Auto-tuning: trigger boost if atomic allocation fails */
> > +	if ((gfp_mask & GFP_ATOMIC) && order == 0)
> > +		schedule_work(&boost_min_free_kbytes_work);
> > +
> 
> Probably this should be selectable and tunable via a kernel boot
> parameter or a procfs tunable.  But I suggest you not do that work
> until having discussed the approach with the networking developers.

Ugh, please, no new tunables.  Let's just implement an algorithm that
works.

