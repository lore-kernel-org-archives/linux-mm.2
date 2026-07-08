Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5427BC43602
	for <linux-mm@archiver.kernel.org>; Wed,  8 Jul 2026 15:48:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 217BC6B0005; Wed,  8 Jul 2026 11:48:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1C8836B008C; Wed,  8 Jul 2026 11:48:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0B7A56B0092; Wed,  8 Jul 2026 11:48:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id CAE876B0005
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 11:48:10 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 39B561201CF
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 15:48:10 +0000 (UTC)
X-FDA: 84966040740.23.3B3509F
Received: from out-189.mta1.migadu.com (out-189.mta1.migadu.com [95.215.58.189])
	by imf19.hostedemail.com (Postfix) with ESMTP id 46B1E1A0005
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 15:48:08 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=k7v+LaJv;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf19.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.189 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783525688;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fhXQ2pg2GCTHGE+3nF80C0E7btiY3aOHNwr8NyhJ9xQ=;
	b=lQ7KbjnnLcG+kmk/Y9W81yyrYj7Lb/ZTf58nh9lneXIHirtETcCfsTwhezk5w40T+sYGjn
	rjJ2XZLhqUgJqQ5OA0RZOGFwGy+NNXuoseyMBFsnrBNXRoSUdxvGyrq1iwRhgT6OyZ+DCJ
	Wrsm6No9sItfxMGiAmuAm+jQMDAlcos=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=k7v+LaJv;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf19.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.189 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783525688;
	b=HHcjfxxXwVT8M3HMjwLNph5EkuG3PkraX+hY7KSIcwLduad5SpxAbYkVuQqGi3uigVuyRX
	yGy9TRvgTzOo+rm1ZAyyuWs/mxla4BZZWFEZGN7v6ZU4vfhyo1h8/Mbe5060OIbXfCq9Be
	8Qh77B7lTQ83l/tAzJOSZVkd6CTxSGc=
Date: Wed, 8 Jul 2026 08:47:19 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783525686;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=fhXQ2pg2GCTHGE+3nF80C0E7btiY3aOHNwr8NyhJ9xQ=;
	b=k7v+LaJv9n79b2IMORUT3+mrLRRBz5m2NFw74Gefjjtg4tPW20M0W72UqCSGofT3tzCFKG
	f6hKIvgGXCdUT8CO62rcUzmK29BOSYlZQGPzqW76qhRoHBvypCEdxLiN50S3hT1fGnAIkL
	r+c7JeHJtZlbcCo15ERsJKNlTdxhHv4=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Richard Chang <richardycc@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, David Hildenbrand <david@kernel.org>, 
	Michal Hocko <mhocko@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, "T . J . Mercier" <tjmercier@google.com>, 
	Martin Liu <liumartin@google.com>, Minchan Kim <minchan@kernel.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: vmscan: abort proactive reclaim early when freezing
Message-ID: <ak5wxwj8cID-QQCF@linux.dev>
References: <20260706081218.3438762-1-richardycc@google.com>
 <ak1XzPxbwBF72d1m@linux.dev>
 <CALC_0q9=KNnkQBE_7gC60jZ2Akj9jgL+VaDMFd7yGvqyfTJbYw@mail.gmail.com>
 <ak3Xtrtm5iVayEx7@linux.dev>
 <CALC_0q-juSkv=iqG7mAGCuGqbdCtjEHEy6oD1pcxQkFdBMJHWg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CALC_0q-juSkv=iqG7mAGCuGqbdCtjEHEy6oD1pcxQkFdBMJHWg@mail.gmail.com>
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: tdc4xckbwsr55fszhke35mfwe5p6y8pe
X-Rspamd-Queue-Id: 46B1E1A0005
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-HE-Tag: 1783525688-686183
X-HE-Meta: U2FsdGVkX1+3mC1Iz/jGracXRn9dkvK8P2WVv7d8yh+zwKDiwIAln7FowWoecyrWqagM7Pr5SqYRiZpFcJG5mqxpTApYS9kSmXRELqweQ8+Xh4EGRnY6AHBZGVgRdV7U+hBQq2wn6AQx3SV2/sO6KFwYu5V67yKRA4LNlZMgIFJ6ypA93fjUscwwpSnY+Feqr0ncL+B26MMguoZyJOGh2r+ggps1h44FtX+lgh0mbmWRTyFxSQoLoGxfAX0SQ38dzDP4w8KxDtxb1tAGhtp5M91pFz4JqUfc7/tQa7h/PqqRB3gJoVP2ipGCtT7fK0TQ0jmUWnuSy9PbfAVKqZ28WqNyVFIzM4fkDGc+9H5VTf3xcbwarFQFnS+MA2OC9wDdGqLnPYPZrN2bNoZQLw24f5Ok2HD/9eM/tsFthior7FN6lpcK05GT/8T5R+PoroxNuwx+FB3ZyYys9tjrmfYs+3svkhliLCtOPwVYdOcoCeUC33dV9YIYJOdbVx+Dt37ACOCfrfAV21822g283l0t6wEQ/sbIBPQIPJW3f5LA5qp+K4ccJidukihzah+7FvFqhC84+3cdGx5i4wCvd+OQ8ZRZmPX1OfFg8AMJKxpqAwghePWIJY5pXrhHp+IirTYTSqhSZJHhO5OvqLHsslq8W74XaD5FPxwxg3IEVLMeIrWWQVtG5cfW2dUEHarM2f+O2BzflolyH4CRHW6624WtymmDy8KzsGJ6uJtk6EX4uyY8sXj5dMJWgi4tELZWBYDzcVb8BSRRPYQJbtrjQkZwEExBaOopo0s5/Otqr43XnIuTjOJCK/I6emkKNBZ9EWq4XnRkSq2TrgeU50+mkAW58nF8H5lK/z+8807Bh+8AXDIJDZKfckgMF+QfCpsTBrehHP4siBjFPQPPhu9czUXWqIBilzAUj3ANM44QcLkm+ExKn3Faxj6BjV/kS514AHIn+zza8r6jPV37hOG1P/7
 Gez7EnLL
 8HH6tTzzcg3JDWhlUB9MGeqPx8patCjohK+fNbLAUnxv5PgYyr19hfyuzZyIGV5ezjvmIGlkAmfl4pds+hImbmMku+9Lqj+aE/7ZEvMoN3k/cKMw5Sgr/wu1qJz3tzrXojtlVvN6TuAVpzNeCRGfbgQd5qvS1sB8+UhDrT/wX/kW4h16p17oG0hs6Q2BGQu9dUoOspdE981Jw7+lism/5lWFPctsh94cGmjpTLPupK+y5IDw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 08, 2026 at 03:24:15PM +0800, Richard Chang wrote:
> On Wed, Jul 8, 2026 at 12:54 PM Shakeel Butt <shakeel.butt@linux.dev> wrote:
> >
> > What's so special about proactive reclaim? Why the same situation can not happen
> > for global or memcg reclaim?
> >
> 
> The target batch size of the global/memcg reclaim is typically very
> small -- usually SWAP_CLUSTER_MAX (32 pages), allowing the task to
> yield or check signals between attempts.
> Furthermore, kswapd is a kernel thread designed to be freezable, it
> explicitly checks kthread_freezable_should_stop() in the main loop.
> In contrast, the target batch size in proactive reclaim is
> user-defined and can be extremely large. Without signal checks in the
> inner loops, the task may continue scanning and evicting pages for
> seconds at a time.

Why can't the proactive reclaim use the same batch size as memcg and global
reclaim?

