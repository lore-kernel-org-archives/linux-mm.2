Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6C8FCD277C9
	for <linux-mm@archiver.kernel.org>; Sat, 10 Jan 2026 00:52:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4042D6B0088; Fri,  9 Jan 2026 19:52:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3E6EF6B0089; Fri,  9 Jan 2026 19:52:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 30F936B008A; Fri,  9 Jan 2026 19:52:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1E7D86B0088
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 19:52:34 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id AB8C01AE505
	for <linux-mm@kvack.org>; Sat, 10 Jan 2026 00:52:33 +0000 (UTC)
X-FDA: 84314228586.27.182D409
Received: from mail-yx1-f45.google.com (mail-yx1-f45.google.com [74.125.224.45])
	by imf27.hostedemail.com (Postfix) with ESMTP id DAC204000A
	for <linux-mm@kvack.org>; Sat, 10 Jan 2026 00:52:31 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=c5HO5r4E;
	spf=pass (imf27.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 74.125.224.45 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768006351; a=rsa-sha256;
	cv=none;
	b=6vCMua/xOH/2IK900k+rJQFO1BEl0YT3ckTcU0xvBSVQjECEWDIESaX/x1lLGZZi4aM1NS
	G7r0hqHwMcKsfzREY96RBUYjQ+eX7i9ZhA2RwzajFqFP/saUgeQlN0jUFGX73D5zKNKvD6
	qorLaIUzPeQrrh575LfcXoMHjfCSazQ=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=c5HO5r4E;
	spf=pass (imf27.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 74.125.224.45 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768006351;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xh0zcKAqQroU1tp1p4pimwYJeCFYqvdejY8GmA8WI20=;
	b=Q4yeaypohQ3Tqr4zrDHzeaeJe1jxsYQFIGKo42W3Gqm9ORnxLZSZk//sKGPVFmm1AzpWkF
	bJMNTEE0Cht1Of5nzIHIVZYdM77VTkmQV/TTMlDXAxBzucm1++i5WYM972xd8qiY3F18yz
	toG0hWQ2TIZ2hZTKvZDTApHewmfo86I=
Received: by mail-yx1-f45.google.com with SMTP id 956f58d0204a3-6420c08f886so6861267d50.3
        for <linux-mm@kvack.org>; Fri, 09 Jan 2026 16:52:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768006351; x=1768611151; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xh0zcKAqQroU1tp1p4pimwYJeCFYqvdejY8GmA8WI20=;
        b=c5HO5r4E3DHsyA8YGFFsrYvhfBdRV4Cc1Q+r0z17CAAtKVrLuz/EdZ0IWWINb5pEEW
         LKSi1oGqt+mUbSYiUJAK8729rWwR27DENsNE2yQrlhl5W8A5cLKdmjUQ6nTwBT3G6GX3
         VAImpq1LX95M7M4o5pGUng3e7vYxSHKTSKSf0Afnvctpg2v0PExY4kN6rOsLuwO7NPmE
         UwnUF8J/ngqQyrYWAZ++HaaImy2Dr4M9iHxcOfCWRThtZpxmAEQe4DG4JBl99q9yW4mQ
         7TcdIfwVCpJa4kJiv51UaYtuAlYT+nHKjY/drOxrTtSxfcM6tOSF5NwiG7c20PeI/ar4
         haAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768006351; x=1768611151;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=xh0zcKAqQroU1tp1p4pimwYJeCFYqvdejY8GmA8WI20=;
        b=ZG/AHp+0OdridGfniL3m7Di0BVW70tj3PnkUqd/kcNsvYtFmP3JklhDWTBxzAM+ztF
         b6KDAfyGvYgm80wVTAPkYyupkK4AobcEL/7iQYoFmVCXzJ6URoPvscbB72hJ6Dir5Mkt
         aUyMPcqcQzehVHkY7S/ESJijR5LAMwnd/XxVIKYSr4qg6VzazL49mBfFYhLAiBCRpC7z
         /pSXKZXydw2xLiyPblitkN5ltpkyaIxVdHllkgF3JQqUYYFSh7cfu8YCdCtJUAi49zkO
         k7Xj+kPPDoL0cUe+JNyZH+R9H/eWscL9LrH8V07MK9iiSiJq7un8mpYbPto/CoFmzD0F
         2pPA==
X-Forwarded-Encrypted: i=1; AJvYcCVM1G0Y9eUJUBS1eTg1yLS3UTLw8PYCfm1qjFxuTM8akzzmQWobrHKg9WYFGfjf0bQM9HciFN0oPg==@kvack.org
X-Gm-Message-State: AOJu0Yz3dN6ctpiFb3Xl/GqX+O9XFQELJ75bj6y012dcapS44Z5Tla4R
	IpXbghl+33eQIv6+tkUDM5hWhVLfk7kgmb3+YXRl27hMRjINfGvtu9RS
X-Gm-Gg: AY/fxX4JD2vVzW2P6JsAUXd0kl2ZMtYJSIJkNSHyFYBWNhmlVELQPZlYH/zhd140396
	p68LW83/WNEGeJRQVF3eIdXYalCPjKrzy0jXb/yfIeKO4i8uFjA2EuBxYq8mTlqpWXF+SuMxWS1
	ibkefMnP2WRDLZoLugy/M6FobaW0KEb0oJn7a9sZIku6EufXPuXWe8ZY8v/koq+xKxDHP3IGNbD
	kuOSjZnIHHfYoPSwzMUYIiszuI9sa+lzsvOE/EULMrw+lTk+0M346+ksjeEa7V3AwYGjGA8GWKu
	wxYcgzxGeHt5WvUkbENox1rJsP+eVUlA2DsuT25cHcOMe+B03ZRor6EYOQmmWevfJD3FYwH68sh
	CjOWUa4Fzavqfl0A6aVB2blGoIlhnzlHps/f0/TjVnDxOx6zGdbrPZ9Mff358zZqs4e98oJDb/F
	jgOCtJI4KKmA==
X-Google-Smtp-Source: AGHT+IEzdhwxbsfQJvT+TvlDMVhfQHhV/8zH5/GstRRQwXcsCbM5ULAqTAR9M7X0213MG2Ra2+1EWA==
X-Received: by 2002:a05:690e:c4c:b0:644:3850:9062 with SMTP id 956f58d0204a3-64716c75477mr9285804d50.72.1768006350765;
        Fri, 09 Jan 2026 16:52:30 -0800 (PST)
Received: from localhost ([2a03:2880:25ff:4b::])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-6470d8c51bcsm5128601d50.22.2026.01.09.16.52.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Jan 2026 16:52:30 -0800 (PST)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Bing Jiao <bingjiao@google.com>
Cc: Donet Tom <donettom@linux.ibm.com>,
	linux-mm@kvack.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	David Hildenbrand <david@kernel.org>,
	Michal Hocko <mhocko@kernel.org>,
	Qi Zheng <zhengqi.arch@bytedance.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1 1/2] mm/vmscan: balance demotion allocation in alloc_demote_folio()
Date: Fri,  9 Jan 2026 16:52:28 -0800
Message-ID: <20260110005229.1348817-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <aWGTNfrLBhCM3_-9@google.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 817rrer6ez5q5384mpfiut3cd4egp1tj
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: DAC204000A
X-Rspam-User: 
X-HE-Tag: 1768006351-665121
X-HE-Meta: U2FsdGVkX1/jYMMTu28h2IU6+WWT+u6FqVrEtBpzBoAHKI68imT77ePSOrJjuupwb9ZdHnllNMzhSq21Mgz9Jjp6mt+tl1iiZJ68cfjDwnI9UmIoFQx5g9SBO9JVfHNY3ekK1qzVOhXM8JINu8TJlPOEa7vpyLL+TC8/0mVcZ884xGEl4UD/sHM0qThAhARJMYyFeodGBCsZQBehqCYVoLYdGJUfTRJLzQjeWqFs9Klm8PkXTg3nLxApzjIxPTrf7JUyOhGPp7wiRRolLVgJgyFFmqk/iqUwyci5PQblhUdR10kqGleLrdTBg2b4Cw0gse4jvU417i8jUjmesf/bnuHz1IkZAHDgUF8QytqZQinjBJOIkUOM9ydgTMZsTRd2CtTgyfXLdxUORAQ2i0ruYUiQumbySb41oO46aXNQ1nVXyLDj6VYx/777m+k6lTG76eOGvTkpvDwyLN3yz1urtFPzjBRhUW1EXLJpl7De8LVXCaaQtBJ4bY1q1Z8/Su8WbSq++hXQjw1LYyFPs+t3MVzLVlnJdnvF0kSFDM+T/RzzI5xm8LvVLbEl/0+A5BnZ2Rp7VmPSVb/3n3bjZaA77U/zUuogf6nScT5gJaZY5yrFeWz7C8DTq0iX9ggjDWAIsoGLerKBaPDJQ+aJ4TxwuzQFt4LIJ8JnowommhflOTWDYl182BRyqJfhjuVn3YAZXgDywF53rEFp9M1aO+CppuFAF/g0NIV927438K/G6gQIXnb/vYhEn+V9HgWVHt9QEGhIEOqnUsW8f7hqaUA5/uuGOZEknvQuxQ0QXfJbKP/ocT2fwnwc+pswUYEnBZw5cBxWTbDO7g0JQdL9BYdct3EdjjtDFyEDoibThG+R/yasf6W+vA6RbFe9/4lC6JKhGx3+8zignhVzxnXMfl+kQkBxO+R3+/y5uElbZNwm8QvtCaD7/QMI+reIQWJNTJu+f5vVNqdjfQ1ia6CTbW5
 WZwyiixV
 KPMQ87lDGmKjh0SEpI6RPJM2KtsCdkOkXC5GndBfMN+QwmTAR1CjB2i6Lo087a3+l0EKOrRfQ2GSuIGX2vMZKumxLCoPTFqV6cCNdkIoUU6ecUq3U2EgdkH3gwlq6c2qonPJtfsFnIMKL0yNHRiKFY3w6h2CEXJaZX6U+WJFq3DQ1pU+Uph0P1wuph6nyfYiXmG1qmK3snigg8Cj8otaHWJLB8e7ifBTg2gwrOba+8+dimFMWTPvU0bra6/s/El4WwWVf1Sh9i1SlZwWFxFM6MmlUbTak0CAV7NoiC1F4wsscuM+PWpogEPxXvSYstGlz61/WNEBgWXAYmV8GBNksMW6R9F8/cMLNuey+PbkmR+u8TFCtvNBEvO6RMm+8Pds7KUbX7wqizbeaOd9dnp2dhLQRJ1aMz11Yr7ZUF1uVOgdNuMz0Yx4OLU6L9SO+7XacH45ZP/4aDLih9Dq/pR0LI1KsR3pR6AqYSPyUxEfVh6WoyRstMvL2jRDHuSOkHk+fgIDJQ8PeB6mJtIAIkof9kbLHoC4dvjI56QvXDmCGaq3nO5b6EAjozVi7J/mEuIApci/kZm4xeh84+rOtPBk51TGCWGi/6UKW07uBH35RMhul9AX+NeaOr4UuNWx3E2j37yQvIP2UVF/zK3BMJYbFB3AnvQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 9 Jan 2026 23:45:57 +0000 Bing Jiao <bingjiao@google.com> wrote:

> On Thu, Jan 08, 2026 at 06:14:02PM +0530, Donet Tom wrote:
> >
> > On 1/7/26 12:58 PM, Bing Jiao wrote:
> > > +	/* Randomly select a node from fallback nodes for balanced allocation */
> > > +	if (allowed_mask) {
> > > +		mtc->nid = node_random(allowed_mask);
> >
> >
> > This random selection can cause allocations to fall back to distant memory
> > even when the nearer demotion target has sufficient free memory, correct?
> > Could this also lead to increased promotion latency?
> 
> Hi Donet,
> 
> Thanks for your questions.
> 
> Yes, the random selection could select a distant node and lead to
> incresed promotion latency.
> 
> I just realized that the the fallback allocation should not weighted
> by a single metric, such as node distance, capacity, free space.

Hello Bing, I hope you are doing well!

Yes -- this is also what I believe, and I think this idea of "how should we
select demotion / allocation targets" is something that is a difficult problem
(and one that may not have a single solution that "just works").

It's also a question that I have been thinking about, and what was discussed
in part at LSFMMBPF last year. At the time, I made some auto-tuning weights [1]
for weighted interleave based on bandwidth capacity, since the main benefit of
weighted interleave is to distribute memory accesses across multiple nodes
to maximize how much bandwidth the system can use at once. A follow-up was to
think about how these weights could change over time, and what heuristics
should be used to determine how the weights are selected.

Ultimately, we agreed that the heuristics should probably be delegated to
userspace, since there are just so many scenarios that could change what
metrics should take priority. (Jonathan Corbet wrote a great summary of the
discussion in an LWN article [2])

Coming back to this patchset, I think that all of the ideas above apply
nicely here as well. What nodes should be selected for demotion and how they
should be weighted is a difficult question, and one that is probably best
answered by userspace and what workload they expect to use on their specific
system.

What I do believe though, is that an unweighted random selection / round-robin
approach to selecting demotion targets might lead to some unexpected
performance implications.

> We need a thoroughly study before changing alloc_demote_folio().

So I think this is the way to go : -)
Although, I'm not actively exploring this at the moment ;)

Please let me know what you think, I hope you have a great day!
Joshua

[1] https://lore.kernel.org/all/20250109185048.28587-1-joshua.hahnjy@gmail.com/
[2] https://lwn.net/Articles/1016842/

