Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2BE67CD98CF
	for <linux-mm@archiver.kernel.org>; Fri, 12 Jun 2026 16:40:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7C8AB6B0005; Fri, 12 Jun 2026 12:40:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 72C136B0095; Fri, 12 Jun 2026 12:40:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 61A826B0092; Fri, 12 Jun 2026 12:40:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4D44C6B009E
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 12:40:55 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id ECD7F1A0192
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 16:40:54 +0000 (UTC)
X-FDA: 84871824828.25.0840289
Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	by imf23.hostedemail.com (Postfix) with ESMTP id B5B5F140006
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 16:40:52 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=mpGbqHpq;
	spf=pass (imf23.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.173 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781282453;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=B+edMgHsajKp6EUG8qdjLHZUa6igBGAxNqzsWn/cqwg=;
	b=U2T8poF+2mY9ODAkvPO+hVn1cCazny7SFy9XVcjBnlTsuk9mVLUy1d859AHiiebBK44JXe
	HQMZS7tqtrjf1PiVKYktyPCXM5RB47/KfLbk/PEpCCnKJYAsKQ5PnBH6M6oYO5HsCtAA88
	YIZVZbz5/ZYB3yW6EEedLYZvfYYw/wU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781282453;
	b=WcNuxkbJE7NzX7U5txPfUWifn3xb9t0PGLxRfoN9KP23epbokGsP9ZA4I5n+d/puzWGUbg
	WVFJc0SwknndctVTlajTB/kHbxlrIIgZDZumjrEBykF+Dybfv1SwdQ89/dHHPMQjkzIpaa
	0GC1b1aN+nso9KbxKpiLvg/q+AE56sY=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=mpGbqHpq;
	spf=pass (imf23.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.173 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Date: Fri, 12 Jun 2026 09:40:41 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1781282450;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=B+edMgHsajKp6EUG8qdjLHZUa6igBGAxNqzsWn/cqwg=;
	b=mpGbqHpqnOqlz1Vq7gOTntaJ7OPxs83o6X27H+Dm7/LR1BULPsd9sVPzfGSBfSiwhepnuZ
	m6s7sl433AprtRWEMaDYbKUSK+hIVvwgbXsLiZ2DnhDtA/TJZ2K4Jhy9OQgK0ZJzL3rWfg
	3rT2pya67ARTrienUPLyJaINMkXBCbo=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Yosry Ahmed <yosry@kernel.org>
Cc: Hao Jia <jiahao.kernel@gmail.com>, Nhat Pham <nphamcs@gmail.com>, 
	akpm@linux-foundation.org, tj@kernel.org, hannes@cmpxchg.org, mhocko@kernel.org, 
	mkoutny@suse.com, chengming.zhou@linux.dev, muchun.song@linux.dev, 
	roman.gushchin@linux.dev, cgroups@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, Hao Jia <jiahao1@lixiang.com>
Subject: Re: [PATCH v3 1/4] mm/zswap: Make shrink_worker writeback cursor
 per-memcg
Message-ID: <aiw2JB1lZV9xuNSp@linux.dev>
References: <9898f83d-fae9-e284-6b85-c7f4089840a0@gmail.com>
 <CAO9r8zPBH6-0SQ6-_ZOhTQeyu=rz4F=ugikCrU-JR_skm6fEWA@mail.gmail.com>
 <a60eedb6-f3fd-4092-b726-04a17a695ace@gmail.com>
 <CAKEwX=MQ3xXBAY-2H8vA+XSX5GHNBubJ2GCYAXGD+Hra++ZM7A@mail.gmail.com>
 <90730fa7-62e7-d5f4-b638-23b22a8509f2@gmail.com>
 <CAKEwX=PF9hfERC_QMq+rjkSc-BsJyawMgTe+EhwR_86HiQKm=Q@mail.gmail.com>
 <CAO9r8zN6VVZz7dpjNrh8n7wbLkqcrsROPm70MQQxO49HJSmMFw@mail.gmail.com>
 <CAKEwX=MCFbsh9ndBtR0-bGRr_=v-6bBwTo=muzd9ZSD-LAK1nQ@mail.gmail.com>
 <1c25650e-bf98-2863-d505-9b94c385668b@gmail.com>
 <airypNnKrJJ54k_0@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <airypNnKrJJ54k_0@google.com>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: B5B5F140006
X-Rspam-User: 
X-Stat-Signature: np9u444nmb7ktmbsywgbb63p9zyfbyfw
X-Rspamd-Server: rspam08
X-HE-Tag: 1781282452-19289
X-HE-Meta: U2FsdGVkX19BkziBbDWcRd7XawBF1yd3+R72cOB3mnJ7yZLLrxS+vF7HFT72JJ/yLtIgJUhaJPKE7zA6YPYTzUzCldU75bhtKDxXUdDqyHIcSgjUODZtfXZSTiCaiG6f8EDnVwTvnu64dx5s2F3eSustZ0EihHfDMHlbTY0jYSWT43Cx/zVR6nXgTxlL4vib9vswVxxJJi9HXAmVX2IwgxCDKWbX8Hz4PBSWpy+uoG5Oh9TnTwV1FDPdWGpXU5905lsf5HYgm8IIsVDQpzZNHQliy6ZrWFi1EfGGv/K/rB+RLLtiv3NuPLajYhAJCTrxyfSHJIbqSBf0sCKQE0QCWvKFI0NpVnPvqObjvI2BJ2VbOp99dDufwmRVXmz5g9zIrCmnOkDIQOMuetMSrHfYX5KRukz++qMJgZysKVRqaAVDOW5Q7WGjOAaMv3TAeFlBe6fMf8AMEwG5447Iw8y4nntf+qoaGVWvTiwRZB7lSmbRQtao7+GrTGCFpUpaLhuem4b3NpihXA7Vwz01plksU3HmoXdxcRUFyCU+Jn/nxEXvTdU4KICtRPQnvyBbOrIsuUvzkWhoZmy+dHjAeeaYTEjtcw11Gterh9rN/htKn5318BnTIqEGxrzg1scFeo48QtmBHPiSxknUM4GssLIyG820SY+pQ986ePed95iS9skPr7qPE7X1oRGL0kWZ6vQafM8z7XVtDZcHk9epQJxjiNrfshwc0gtscUyTD3qk9jwwGaLEjv1q55d+ldb6v3yEyYQDpDmhfPo2Qw58FctDc6oJw2v8kgNBV29Uwg1jNYv2RCP5/doXyyu/46lub2Tq4PFXmz5rANoJobNBViwCW6KSFajE8DMAgvonSrfYEoCgCE6wyrjKnzeHU3O36WYxFMKFulySued1khgR+JSsADQnhzpAwFDjWWU9Omgzpxx8LdJeer8U8+wUIftqsKhpWmJeIVp8PsnLayZDqyZ
 ZcTu2lFk
 X8BN+zmMsuot5qwfddUaceFEhUDe/U9WFYY7ohKW45mlwu2pYOnAYnFeb9lAdC/bFmdO7BBwnOHDuvX8u2Npozdkxc27IxD+CKMvIbqoFdAFwBcVK57Gx3vGev2oteFdymh7KqeUWiiP/x6HJRcEW7Lt+RIB0PoQCFs1AYXm0/Fkw/on65A5k+ZV2RalsQ9fyyhq+kEKbXf0SDRgY1kTzTAvFYrt+nwBDBYmNJsQVZILV4+X3fQKooaq+mAxfxNaZhjWrAnSVvctp9BOY2eNJ6aFXwGgvZXQbyQMNA9z8rlDEfAepBKgloknEDYXhBP8HLFRznJ6wnfm439fH8LfkZYPzq9f2j8vt9iNMspIovL9BAOH4iLk8YLyLe2xfrVJwQEaq
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jun 11, 2026 at 05:39:16PM +0000, Yosry Ahmed wrote:
> On Tue, Jun 09, 2026 at 11:18:26AM +0800, Hao Jia wrote:
> > 
> > 
> > On 2026/6/9 02:01, Nhat Pham wrote:
> > > On Mon, Jun 8, 2026 at 9:48 AM Yosry Ahmed <yosry@kernel.org> wrote:
> > > > 
> > > > > But OTOH, this does seem like a recipe for inefficient reclaim. We
> > > > > might exhaust hotter memory of a cgroup while sparing colder memory of
> > > > > another cgroup... But maybe if they're all cold anyway, then who
> > > > > cares, and eventually you'll get to the cold stuff of other child?
> > > > 
> > > > Forgot to respond to this part, the unfairness is limited to the batch
> > > > size per-invocation, so it should be fine as long as you don't divide
> > > > the amount over 100 iterations for some reason. Also yes, all memory
> > > > in zswap is cold, the relative coldness is not that important (e.g.
> > > > compared to relative coldness during reclaim).
> > > 
> > > Ok then yeah, I think we should shelve per-memcg cursor for the next
> > > version. Down the line, if we have more data that unfairness is an
> > > issue, we can always fix it. One step at a time :)
> > 
> > Thanks a lot to Yosry, Nhat, and Shakeel for the great suggestions!
> > 
> > Let me summarize what I plan to do in the next version to make sure we are
> > on the same page:
> > 
> >  - Drop the per-memcg cursor and keep the root cgroup cursor
> > (zswap_next_shrink) logic intact.
> >  - Stick to using the zswap_writeback_only key, and change the proactive
> > writeback size to use the compressed size.
> >  - Consolidate and reuse the logic between shrink_worker() and
> > shrink_memcg(). Enable batch writeback in the shrink_worker() path, while
> > keeping the writeback behavior in the zswap_store() path unchanged.
> > 
> > Please let me know if I missed or misunderstood anything. Thanks again for
> > clearing things up!
> 
> Sorry for the late response, yes I think this makes sense. However, I
> have some comment about how this interacts with swap tiering, let me
> reply to the other thread.
> 

I think the swap tiers interaction will be figured out over next cycle. However
Hao can/should continue to push and we may decide to let it in orthogonal to
swap tiers.

