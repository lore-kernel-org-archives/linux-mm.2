Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A03F7C44508
	for <linux-mm@archiver.kernel.org>; Wed, 15 Jul 2026 14:42:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 976796B00AE; Wed, 15 Jul 2026 10:42:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 94EB96B00B0; Wed, 15 Jul 2026 10:42:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7EF5A6B00B1; Wed, 15 Jul 2026 10:42:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4A9A36B00AE
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 10:42:52 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B8F7DC01B3
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 14:42:51 +0000 (UTC)
X-FDA: 84991277742.13.A29EEC0
Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	by imf01.hostedemail.com (Postfix) with ESMTP id 8F1374000A
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 14:42:49 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=DJW4sjrd;
	spf=pass (imf01.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.221.44 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784126569;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zxylkB/9Q330ZTK+3xtMFXAr8pY156LcQll6mFT3qQU=;
	b=0BKcqHX/mUQCIYm9z8SElC0yNv8HMVOXERwGzKYbwhbeETrNLtn9stgy3+vMTYt8isXvBp
	drvArxIr0+2nCTMxGVb1Ssq/AxVK7Zttkarcg2jvGq0dM9lC59JUfJNCupgsovHmFP8dvY
	HC7Wd0QB48oMkPuIJg+d201kveAivv8=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=DJW4sjrd;
	spf=pass (imf01.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.221.44 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784126569;
	b=fGhmuLzjjf6CLmlOIFHc65TGlMfEmAlZ5qh+EP3Rc4kbxwKkdpA3YFTeNWeyn2QHPXaMzA
	ZqVAdXaKe91joIBkWjw3LBgYkVRFk/aJccAeRVgCpSbDMHNNukrlorEXfMUQW9ckB2lPA4
	thcTvZ033g/koFpA3nNQ1B1nY6ayZTI=
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-47d6c634f45so3164979f8f.3
        for <linux-mm@kvack.org>; Wed, 15 Jul 2026 07:42:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1784126568; x=1784731368; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=zxylkB/9Q330ZTK+3xtMFXAr8pY156LcQll6mFT3qQU=;
        b=DJW4sjrdGllq/Ch5VKjeMSO0RJP0G6/hOCIIsJkzm3c2FJDXimNO3K/vVC8mjfo73j
         t1hf0MnCuXggdCv20giaaviCoEjZ7gN7+6w4SiqhDk6FmGYCP8otdI7s1BO4pYYDrLzp
         S6/6J+VyfhZpgqZ6uUJoLA0sgmcKOPcPLTxWXx8w1vWPIgZR3KEVhFyP3Y5MVHZJBSJW
         qWqN4KYrhfQoBuSGhZxo4l41YNupFfZufH6bexYJucyN+3FM32cAwEunj227UEqCalhU
         I766tt92JCyecKSLaVc1VuEkpO8BqGSeFdwqok2HvcN93GFxIXUu8oZoTK93UiV00/GA
         1beQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784126568; x=1784731368;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=zxylkB/9Q330ZTK+3xtMFXAr8pY156LcQll6mFT3qQU=;
        b=YCE4Aa/Um4JmrM2FR8TPQqCuEfVpwTDK8URLnUf1/5itIMk+7Qd5woC9bxxBYzN+mz
         QtdMWQXeO7vnz4nbCXVj9sGQC3Fd4k2NttnPiiif0FK6gVP51AagOE/P+iXxyKAUuNou
         KEr1U2aJmOuVeZai7vGf6xedJHAwlgfOT7vvEjvqPHiI3EYCQ8+0WTceaK9djy9NxK40
         dLCUUximROvbqBB19x3pgbilib6GzpbN2z6kCLCsrKIsIuaJXQ9OJaBRyrR+OWUyMJPT
         4jYq1NbMNZy9Y8i+kf8H7sYCpWJRPxCAIZjau4dUB+05BTIMZmA1Tnc1QH6BK+Pflodk
         u0qQ==
X-Forwarded-Encrypted: i=1; AHgh+RrGqCjdTvkZAHi0bqMLYvmfaMlOSpqjmKvMG+wDfH3KpFf/JjAdIwFLMb0KyLd7tlq/bdf1pqjGaw==@kvack.org
X-Gm-Message-State: AOJu0YxmAzhRbVFscuzIxK2zGW3FkGIhz80+L4uZQW9Q+EaQS5b8GE/K
	oH+zRh7IAlLFk3nwdlYD1LPqBQpvRmgqgFPS1+WQKnGUyCoSm2FQJmD+o9phOHDVl2s=
X-Gm-Gg: AfdE7clhL6HCdVpJQAYE9lSo+9NSS1bm0NFuMk4I5DeSZaFnSBdDdFFdDlV0NE3xhxu
	xLGA6EDc6CQas59f8S7+qdUI1/nxmVdKWmWozdMTGQdQmjCDry4eLK6ibrxrY8j40Bk1/dDl77x
	2JjCyfVU3pKYYQs/FigcT82xUYRf4bAEkBzsd3T/Asr7guQccAGeaKWYZHtWYktxc1CMvb8LkZR
	ouymv/G7oGJ8bPxNJkogKq9c9EhCN8IwIqbFK9xaLIOlOjArMd8ULgaCMetqTQnHK3UICtwdmJs
	4pSOkCmipRe7VWBa5qGQiy0Qqeq3fG8Z9Qk25SEQXO2ex88MkYFRnNF2CbjROpvtysJUeqCN4d3
	zU4kEHxXtF/xDCdldyAozmFZl7ZOC+l+TbW4PEC7GvxWHeL/rfB71/hJG5vLz0E54ywaWoNZREy
	o4NLLC0xGgkC/foA==
X-Received: by 2002:a05:6000:25c8:b0:462:d07e:4bc4 with SMTP id ffacd0b85a97d-47f4886edd1mr8716611f8f.7.1784126567792;
        Wed, 15 Jul 2026 07:42:47 -0700 (PDT)
Received: from localhost ([2a02:8071:8280:d6e0:1353:8eb8:c84a:b6d4])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47f464c4320sm16428786f8f.32.2026.07.15.07.42.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Jul 2026 07:42:43 -0700 (PDT)
Date: Wed, 15 Jul 2026 16:42:38 +0200
From: Johannes Weiner <hannes@cmpxchg.org>
To: Altan Hacigumus <ahacigu.linux@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Jiayuan Chen <jiayuan.chen@shopee.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] mm/vmscan: clear hopeless kswapd when global direct
 reclaim makes progress
Message-ID: <20260715144238.GR276793@cmpxchg.org>
References: <20260711043946.68421-1-ahacigu.linux@gmail.com>
 <20260713112001.GE276793@cmpxchg.org>
 <CALjTKDkFG651PbreBkDjB_=rKXOrek4b1WJpDjfTY=385z__VQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CALjTKDkFG651PbreBkDjB_=rKXOrek4b1WJpDjfTY=385z__VQ@mail.gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 8F1374000A
X-Stat-Signature: pp1r9owgtg43wffc1te9j1ahwyhtct57
X-HE-Tag: 1784126569-179646
X-HE-Meta: U2FsdGVkX19NTvNN2olrTBeZW1FRvPTjQbutkj7mDsF4I3dfI3OK0xTRRsLTkLaginfkINKREkO+hlod7Sm3YJ5r/Aw0OVeEMAOq3BYadMkIa2+DX9aSJkJhii0z5KIlxZZ5bELCVeYW2aelZMwqH3ANvGvmEN4upIcOvalMhD6UBZ1Ei9oFjSC9WnqNtfn2ts39SS8Cknjrg6wpogh+y+1EwMFtXVNXG98Wueg8MEZ2P9p1La6LYDEpMSe74P40CORuA0v3cUNuNe7gHpH0nTZ8vtzBXEV9Wrh2jEmUQJ4TLJOuUBmiHeklz7gzC4JUtCRJMxr6MapAjmSqGdUf7ibhXmSOG5dht5BVuPUDtocXNdMpazXHyOpvGlKuvbgQgUyQHCHY2agqnkP/mKUEXRbNxzDiIHDX8czt+uFw0LejEUSpcz+D+d4mTua4yZzZJf8qIen8R15cNDCwQ7JcP3HclGbdkUpC3rTfjOVQiGCmB4586syztjyYK3KfGt0FY4RMPc4Y+X3zVJPtY2V7nX2YVtrUNiXG0USxDSrNwdb5OBWuAgqn2+x/7HUI1wpphUSb085xms88Is5PSvduMSd7l/O4MBJdlGDiEY5h2oYemIigmvQ1bi/zIIdWSrvcY4L3ge1/s/IPW5BJNc90syJ6B/gf7ZLzYwULrOzbEVUjetD8RoOJCUumTRjU6zZWkqW0vLS+NBpFkfbzN0CnZrn+mPrUgqb1i7KFwZ2QxrDOlOQ0un5Oc3WntZzlRFQyCG6+vV/YynTkTGBMXrJ+ZvC3reGQmcQXA88VAK+cWot7OC0w9xI61qYV7+IDt43vpVYFlGkznwoLdKwam/qimeYzxWMhcWZxfUNrACBDClyPLCaxKjK14lPdZ5gOOH/+4Pchj4hp22NfVJ/RrP1KIhGhhtADD8jFyfZsRrrApiKdb4g7aSaz8g5WVE1FwkluFOH1TiPSPAYQ1Hdx2IP
 6CcAhGC0
 YvKq0BnMwjyG/vZ0H1aOfa+kzRFlk4SjejpgRsBwtS2F+yW1dDIIN/fVQBzzyizrKU7Cxi5dG19Iqm/v+rbW5nS7dHH+oVWLySd8pa03CGGTJvGIRaELZYdcLUmhG34BMFa1dwyfd2A5po2kmh5ZKpVfPlk15ShsvBfjcaaOS88dsDtvDYNqfPJszeoqzh2GJtvwl48GxHC7nD9ocxQSTuZg2oO6NP0ApxXoKO4upGeDNHaEySjOV9lD3YxoaAzZpNmun7iIYce9T37ddKPwpJL2cY5J2ZBRe4NSFO0rWBYeha19+/QTtURs+qBQ/hbWuwjP0/yBUPoOgtpWvD9kXn6SlPhiPd1ics9RYCuHx6I23k/3ltV1cN6pY+Fd0NkthRc/oeYsvbNKFT4reINREBwbw71XMaD4JgE0Vghxva/ftJQ8iHbIFFoz8Ip3s59v0MpHfkHDYH6/tUqj41YmMXjbTC+mZLaQTPDT/qUAO+3b6yV1MlD6lM7kSTaxfs96QX6P3yDd1Hoo7jr476ke2loarCA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 14, 2026 at 07:30:12PM -0700, Altan Hacigumus wrote:
> On Mon, Jul 13, 2026 at 4:20 AM Johannes Weiner <hannes@cmpxchg.org> wrote:
> >
> > On Fri, Jul 10, 2026 at 09:39:46PM -0700, Altan Hacigumus wrote:
> > > Direct reclaim clears the hopeless kswapd state only once the node
> > > becomes balanced - added by commit dc9fe9b7056a ("mm/vmscan: mitigate
> > > spurious kswapd_failures reset from direct reclaim") so that cgroup
> > > memory.high reclaim cannot repeatedly revive a kswapd that is unable to
> > > balance the node. Before it, any reclaim progress revived kswapd.
> > >
> > > However, this restriction also prevents global direct reclaim from
> > > reviving kswapd. Under sustained memory pressure, global direct reclaim
> > > may continue making progress without the node ever reaching the high
> > > watermark, leaving reclaim to allocating tasks.
> > >
> > > The effect is visible on systems where a database workload mlocks most
> > > of memory and the remainder is under continuous pressure: allocations
> > > stall long enough that ordinary tasks (e.g. ssh) become slow or
> > > unresponsive, while kswapd sits idle.
> > >
> > > Unlike memcg reclaim, global direct reclaim follows the same node-wide
> > > reclaim path as kswapd. Clear the hopeless state when global direct
> > > reclaim makes progress, while continuing to require a balanced node for
> > > memcg reclaim. kswapd_try_clear_hopeless() becomes static since struct
> > > scan_control is private to vmscan.c.
> > >
> > > On a workload with most memory mlocked and the remainder under sustained
> > > churn, with swap enabled, comparing the same 60s window:
> > >                               base       patched
> > >   allocstall (all zones)    413441          6532
> > >   pgsteal_direct          15889552        255619
> > >   pgsteal_kswapd                 0      26079382
> > >   PSI memory full avg60     13.10%         9.37%
> > >
> > > Direct reclaim was already reclaiming many pages in the baseline;
> > > this change lets kswapd resume doing that work asynchronously.
> >
> > But does kswapd actually stop?
> >
> > I don't see how you avoid re-introducing the issue described in
> > dc9fe9b7056a. Direct reclaim picking up a few pages is no guarantee
> > that kswapd is able to restore the watermarks and stop running.
> >
> > The distinction between global reclaim and memcg reclaim seems
> > handwavy to me. Either can free a couple of pages on the node. Who is
> > doing it has little bearing on the question whether kswapd can balance
> > the node and go to sleep?
> 
> kswapd still stops for the same reason as before. Its own reclaim
> progress never clears the hopeless state; only pgdat_balanced() does.
> If it stops making progress, it reaches MAX_RECLAIM_RETRIES and parks
> again. This change only allows successful global direct reclaim to
> revive it. Whether a revived kswapd can rebalance the node is not
> guaranteed - nor required: under sustained pressure the change is about
> who performs the reclaim, kswapd asynchronously instead of every
> allocating task synchronously.

This is exactly the bug described in dc9fe9b7056a: A single direct
reclaimer gets lucky, which kickstarts a very aggressive burst of
kswapd activity.

Sure, the commit lists memcg reclaim as a trigger, but there is
nothing in that scenario that would make this memcg specific. The
observation is simply that a single direct reclaimer getting lucky
does not mean that kswapd can now balance the watermarks.

Trivially true if your unreclaimable set exceeds memory - high_wmark.

> The distinction is mechanical rather than "handwavy"; global direct
> reclaim follows the same reclaim path with the same protection rules as
> kswapd, whereas memcg reclaim does not: reclaim targeting a cgroup
> ignores that cgroup's own memory.min/memory.low protection (see
> mem_cgroup_unprotected()), so it can succeed where kswapd cannot. Thats
> why the patch gates the reset on pgdat_balanced() for memcg reclaim, but
> not for global direct reclaim.

I don't think the distinction is meaningful in this case. The
memory.low/memory.min aspect just makes a bad signal worse. It doesn't
make the global reclaim signal good.

Please take a look at the history of the hopeless kswapd concept. You
have to follow the patches past the recent "hopeless" naming because
the mechanism has been around for longer. We have moved trigger points
around a few times now, and you're very likely to just reintroduce a
problem somebody fixed recently.

