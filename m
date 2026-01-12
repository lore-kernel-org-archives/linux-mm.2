Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C7071CF45C8
	for <linux-mm@archiver.kernel.org>; Mon, 12 Jan 2026 19:23:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0DA3B6B0005; Mon, 12 Jan 2026 14:23:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 05D966B0088; Mon, 12 Jan 2026 14:23:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EAB726B0089; Mon, 12 Jan 2026 14:23:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id D3DB06B0005
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 14:23:45 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 88052BD4BA
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 19:23:45 +0000 (UTC)
X-FDA: 84324286410.27.47ED91F
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	by imf09.hostedemail.com (Postfix) with ESMTP id B4F0A14001A
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 19:23:43 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=0VP7raof;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf09.hostedemail.com: domain of bingjiao@google.com designates 209.85.214.180 as permitted sender) smtp.mailfrom=bingjiao@google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768245823; a=rsa-sha256;
	cv=none;
	b=hIUdy5cKR3khVXi4lE6wOdqKpCMO+4F304pBAweCdSqcIKIrgAqQ1wIPOoxKUFTg12mIpD
	0E8T6nHWtQ4IVoWFZ+QNHCKE/le5e76aCPYUAa5dqutphRajzdPIkHciWMUzZR5uoYDwCV
	P6nUvZOK7beUTSew68lJcYZQugZIUEw=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=0VP7raof;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf09.hostedemail.com: domain of bingjiao@google.com designates 209.85.214.180 as permitted sender) smtp.mailfrom=bingjiao@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768245823;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hmOnMmQfqqdHxNQ09Yihr63xKdO4t9TmwZwP3j3Qm5Q=;
	b=xMtjVTtXyt5uX0825+TUNaJC7JTaVuHAiOnBSCcNpFyorbfJxFTxc6+YOs60j8zHvIinjm
	yH/rvaUkzrbgEqAtqoYIIJcqTOZSPJUriTOXtJunTeU/YFcyuJ5R+zbn7hUjp1InohcFkL
	WAp6g6spROkH1mZENkFOFADU0joOT8c=
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-2a35ae38bdfso9075ad.1
        for <linux-mm@kvack.org>; Mon, 12 Jan 2026 11:23:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768245822; x=1768850622; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=hmOnMmQfqqdHxNQ09Yihr63xKdO4t9TmwZwP3j3Qm5Q=;
        b=0VP7raofgUqvxtNJlwxIDmha5pEU4IFwqqLmUBB80v1mg9axym76rasNt3IBi9Jk+B
         hutLawjaVdNQeagPiE8tZiMN7J9PiAqVXMMO3AR8Txe9tR/BurQyIuAiychhNbXMAZWn
         RnuXx6Sf9Ac6dpD3cuEl9Q0dTg7m1h8sqALJ8lipWo86UsRI0+SW7Js4KKz0xpJ1wvq8
         +rWidUzPCIT7ARizZNTdny37VUvE4A7MgPK3c/ySIXAtYHSKcwUEZlIIzjD0Lz+pgTFs
         CPJnmKn5K0+FbGBPzNjK1lT/jIrqksCp1PLXPT2pQ7D8QpHGY56iM3pc0jIXOR4jBc9Z
         iH1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768245822; x=1768850622;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hmOnMmQfqqdHxNQ09Yihr63xKdO4t9TmwZwP3j3Qm5Q=;
        b=Wy6rBUd0AQOORvgugVFp0ouay7tAgzQJuOUfPOALrLx0dE2xeibZmRsuHrYX1IUx5L
         ir1aqSxK83NpqPap/H4YvAn77YrGLihTi84IvR65vcYjUcBGTAcDlLLg7mtV5UKtOfCd
         EQ5vQ/MF2IC49LcmIZ/yqrklsr3o8cuvspLf89ByPROyEv9/FggUZVLOBWSyyRbtPgxh
         hUiIz9psEBgBPTIOJJsPv00/f1b3EFkfp0LFwOv/IS80Jm8yX+gxXy2JhJ/GvTxv872P
         OT7YDKcG1haDGuDp88x8+nB4z7YKLkBfxT7oYmV0cNg0soBBDA7tGyM77L1zq9zwjc9/
         ha9A==
X-Forwarded-Encrypted: i=1; AJvYcCWRtpH7HYLfTIEhnpnVG+rvPbqJ3R6o8M1Vaipodx4GS7wXBGeQsYONiUi9qRy0yuZjugdOcz+MCw==@kvack.org
X-Gm-Message-State: AOJu0Yy1i+DuF93ir7WnbNcjC2OzMbx6Q5nU+AduexclIVvmQUgGlZfr
	YMXOILQh+eQkLr7KK2P2VM02hRfmcm5wfs/EmhHhUv0t5uHaMAT6dJ+v0KN4xC3ZlQ==
X-Gm-Gg: AY/fxX4cWjhaFporLc5HDRKclMIIj9R0nD6KD3+45A9wAezabvgnOomkRZ1GS3XEEEE
	RzzQzfD8FgLjJpafgVPAR9ZkreMEHJltu90kEoH57d4bi/um2HLWMGkPXbRkPJlXN5l0KpNSX8c
	SyCMGmId8MkDW0LAE8o3Fv+Piq3EZVK9meowsqv4HcxCE58QDGPDQGMbXGhrGpdmcfvRVkOJykk
	deCzz9rGB8z8NoqriY6QTKlFIwA8ylatwv1MCbppHHxNf2Xnro1N+7Bs9jXauU1b5oEFvIr8Rh5
	DTNoA08KHtdXc5yogDK8qzMGyd76NZhvas9lsN0M5n5BSmaFFAYiANz/uMpu+3xN0bpGX7qLXwJ
	6BT/M3piFGKhDUrioWPgL569F8zRWPThgrzUQE/TIWCPLMeDN9gVmzgQ/be5loA5a5IV+BHiuSn
	z4AXYiSjAGf374oxGBImK8gVTe3FBcDoVleWumP+5zoPChmnuPx9oS
X-Received: by 2002:a17:902:e54f:b0:299:c367:9e04 with SMTP id d9443c01a7336-2a58c7603bdmr254405ad.19.1768245822052;
        Mon, 12 Jan 2026 11:23:42 -0800 (PST)
Received: from google.com (248.132.125.34.bc.googleusercontent.com. [34.125.132.248])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a3e3cd2acdsm179373125ad.89.2026.01.12.11.23.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jan 2026 11:23:41 -0800 (PST)
Date: Mon, 12 Jan 2026 19:23:36 +0000
From: Bing Jiao <bingjiao@google.com>
To: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Donet Tom <donettom@linux.ibm.com>, linux-mm@kvack.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	David Hildenbrand <david@kernel.org>,
	Michal Hocko <mhocko@kernel.org>,
	Qi Zheng <zhengqi.arch@bytedance.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1 1/2] mm/vmscan: balance demotion allocation in
 alloc_demote_folio()
Message-ID: <aWVKJta4vuZEOIZV@google.com>
References: <aWGTNfrLBhCM3_-9@google.com>
 <20260110005229.1348817-1-joshua.hahnjy@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260110005229.1348817-1-joshua.hahnjy@gmail.com>
X-Rspam-User: 
X-Stat-Signature: eay4njsgun4bin75pxbfjidwxq4ymits
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: B4F0A14001A
X-HE-Tag: 1768245823-440237
X-HE-Meta: U2FsdGVkX1+ZtkbLA6q+3/gPcQ8HIH5FBEvFdTF9f8Oef0QdVPYWOHP6boKoUauvZcGYs6KlmBBNj6L+xx3Pnus6NnUZEkTMYLRLXHmV2ygttsFjkkc+azmySy6lnmQ/UOmGz4AVNtPgawsY9rsoEauBRc1ePauVRDY3sPc0rhWTg8otEMzhOCkUHr9Nsp+U9hSH79W5nAVzwQZXfHBwkiJyb1CX/yuZ2vx6ofXJHLsMZE45aZ+ADGH/51ASaOFcvflmyZu0X99JTiU5uTLgF6eAwNx0ZsOaxsVzJRhLmEnJkO0KdXNlpTU/LNMF5zEqDroh2Qd0j8wgCcIrQgcHkW3q1HyKIXzyy4ylyTLzzPvWMkuQXd8vU+ZmqCs9NuqMJgx5G1cuXJSEZv55VFSF++yooK+SV261MhEqE+Xun0QsKXRqwlJtzsSDln+gTjcU1wLK2kUOJ2h2OjRwUFeDDnej8X2MDSXTswUUyeYr3Xr/NBTNrZfUjOfOtbwB6/nbaQEQQ61kQWmlh9HCZ7ryRjrjlpn7srNc2jkrbVHU8+4EnjgZnJTdQxKVl5ltHRU+Jp7Mcs4p5LAfuxL9BvQuVzVPWkdBhLtqUQS14ZFzB3Kt2VHQKSDWlXsh8Fa2FzYRH+mqHsqBbA4KHEFqTChgx573WjPP627Obd/lMCvuP9Nhtt7IaaHuUoutjMSybgZA1Y+q+XnwOpapM+gyDvjfzj04IA861dQbNEe4+knJwliPVWOmV+NgL1AlIYIuCWIQYNShBLPCsYAnon2SzJqCDRsf1Yz2c3f/1SSurcxJszHS+8cBnKust91TEhB3+cpsR6SKr8+zf5uPStKUlMrVStuL+u93NRjXxjsUHG5MxUxOXJxxKDtdnC7qRf7WXqarzD9rkuUZL1p2v8hrL4KRX7xDaNDhrDqR7Q6GXf2gzE/PqZiN/Srm4fxhtvQnZMivI6f8B88n9LZSkzK69l+
 LcehvBsF
 tmndrHWVcKn8z9zdz5gUBsBK6v49CdE61mRCaFz5JKzMqHaqCgg9w7WJQS4EEVVOx+QAfCvjErIqOcf76/SP1QOA1VxJjrb1Q5SegKaoZatEU0RcUCe4v0ufLonDK1s+Ub88hBdwPc1Hmd51X+7DSqFIfG+UbhKG0O1Agnco9QTtM7OX3HZ+EFZ4xuNdfvVOHFuflVBW9lZ3ZKZgTwOMlEdoR+OlwDblLZJGAQGtNHThTYHTpwb4eVc4Q4W555Z9vRNPL1e45Mo4vmzN3gIbeGE8cCavM4Qd42AtHCt9ooWsKNrZ7/wPIsNCBFpWaNDpsESzOMUOmZ0BbUeZjHiAhPp6E4RMGFol68IqPpXUD9jy+qsTpiQPvQILsDflqLfGL0y7f3Wc9k+qnpZGNxwT9asUODkPDY2WVeoD/ntDzpf5L6li8f/57nHNEsT6I19yjGwEyo9C8xc8pAMHPqyllApb0vjJp3OMVQRNBBCQ2PbLeR7X5HxaAr0z03tHRDSIS+H4FGxjxhOKaOwDhglLRhmAzJ4+K6ltRNVYFguDI6JBZEA8tQqVjuL7NfUOyJDko+HIe
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jan 09, 2026 at 04:52:28PM -0800, Joshua Hahn wrote:
> On Fri, 9 Jan 2026 23:45:57 +0000 Bing Jiao <bingjiao@google.com> wrote:
>
> > On Thu, Jan 08, 2026 at 06:14:02PM +0530, Donet Tom wrote:
> > >
> > > On 1/7/26 12:58 PM, Bing Jiao wrote:
> > > > +	/* Randomly select a node from fallback nodes for balanced allocation */
> > > > +	if (allowed_mask) {
> > > > +		mtc->nid = node_random(allowed_mask);
> > >
> > >
> > > This random selection can cause allocations to fall back to distant memory
> > > even when the nearer demotion target has sufficient free memory, correct?
> > > Could this also lead to increased promotion latency?
> >
> > Hi Donet,
> >
> > Thanks for your questions.
> >
> > Yes, the random selection could select a distant node and lead to
> > incresed promotion latency.
> >
> > I just realized that the the fallback allocation should not weighted
> > by a single metric, such as node distance, capacity, free space.
>
> Hello Bing, I hope you are doing well!
>
> Yes -- this is also what I believe, and I think this idea of "how should we
> select demotion / allocation targets" is something that is a difficult problem
> (and one that may not have a single solution that "just works").
>
> It's also a question that I have been thinking about, and what was discussed
> in part at LSFMMBPF last year. At the time, I made some auto-tuning weights [1]
> for weighted interleave based on bandwidth capacity, since the main benefit of
> weighted interleave is to distribute memory accesses across multiple nodes
> to maximize how much bandwidth the system can use at once. A follow-up was to
> think about how these weights could change over time, and what heuristics
> should be used to determine how the weights are selected.
>
> Ultimately, we agreed that the heuristics should probably be delegated to
> userspace, since there are just so many scenarios that could change what
> metrics should take priority. (Jonathan Corbet wrote a great summary of the
> discussion in an LWN article [2])
>
> Coming back to this patchset, I think that all of the ideas above apply
> nicely here as well. What nodes should be selected for demotion and how they
> should be weighted is a difficult question, and one that is probably best
> answered by userspace and what workload they expect to use on their specific
> system.
>
> What I do believe though, is that an unweighted random selection / round-robin
> approach to selecting demotion targets might lead to some unexpected
> performance implications.
>
> > We need a thoroughly study before changing alloc_demote_folio().
>
> So I think this is the way to go : -)
> Although, I'm not actively exploring this at the moment ;)
>
> Please let me know what you think, I hope you have a great day!
> Joshua
>
> [1] https://lore.kernel.org/all/20250109185048.28587-1-joshua.hahnjy@gmail.com/
> [2] https://lwn.net/Articles/1016842/

Hi Joshua, hope you had a great weekend!

I appreciate you sharing that information. I really enjoyed reading these
articles and discussions.

It makes sense to assume users understand their requirements, but I think
the kernel needs internal heuristics for weight adjustment. Because
users often lack the comprehensive and immediate information necessary
to update their configration in a timely manner, unless the system has
an omniscient administrator who can oversee and (pre)allocate resource
for all tasks running on that system. Therefore, I think it is still
necessary to have kernel on weight adjustment.

I will think more about this and explore it further from userspace,
kernel space, or using a hybrid approach.

Thank you again for the sharing!

Best,
Bing

