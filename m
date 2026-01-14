Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B802AD31A26
	for <linux-mm@archiver.kernel.org>; Wed, 14 Jan 2026 08:18:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 14D296B0005; Wed, 14 Jan 2026 03:18:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0FAF96B0088; Wed, 14 Jan 2026 03:18:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F1E7A6B0089; Wed, 14 Jan 2026 03:18:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id DE3CB6B0005
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 03:18:35 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 874A71ADE19
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 08:18:35 +0000 (UTC)
X-FDA: 84329867790.03.E89B77D
Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	by imf21.hostedemail.com (Postfix) with ESMTP id 6FF1E1C0005
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 08:18:33 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=NxCbPceM;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf21.hostedemail.com: domain of mhocko@suse.com designates 209.85.221.45 as permitted sender) smtp.mailfrom=mhocko@suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768378713; a=rsa-sha256;
	cv=none;
	b=h0EQvRv9vyW827mXzly3hgMxHepvHFMgtcPpVPs800f2mbg+xR/+aDC9ImgpPZF/z+STBh
	ONOQZcjnQOejhL6harpBWGfn1X1dJv4z4LXk45CYXWcPlLNtpo0kTNCYb5cAK3I92uLOsG
	gIWV3Z6ydy+IyQ4fUhMICcTNjsixedk=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=NxCbPceM;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf21.hostedemail.com: domain of mhocko@suse.com designates 209.85.221.45 as permitted sender) smtp.mailfrom=mhocko@suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768378713;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=X8y3eBpdpZ4jiLb2IpPbzYhjPFac6qto4kOtboVZXAA=;
	b=5K5wjwh3tt5SzA1qZQ3FODwrzF39JkW8mBqK0r5JOiPdAxLW4wO/TdexryMwVpJez7r9YP
	Knfva55WAun5m9nSQHtqnthcgkbkYgTmHT2L8WH9eLojdtHoChXaZmWtAa1Yage7+7m+wl
	Mb6S9zhLWVNDKqyxcn7A+NHSPZyrlWU=
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-42fb0fc5aa4so6246850f8f.1
        for <linux-mm@kvack.org>; Wed, 14 Jan 2026 00:18:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1768378712; x=1768983512; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=X8y3eBpdpZ4jiLb2IpPbzYhjPFac6qto4kOtboVZXAA=;
        b=NxCbPceMZ7PLj2LY5cIRWyx/jWJHEQvG+mpwjxvZePnHvIpmO0B/7yQKBoDjhqZ7ID
         qzyfIvjqhccwEl/mZeH7ocwP/0IpfpuBtKvIYVJHPUZOKsT++Jn8H9Z37Hc6Qf7Fj/oL
         Giwi+X0rBskuOK7XE6Pz241x1psijCyWHx81ZMYpcesks9TdAKuG4LKI/NvBKoHUJl/L
         IgR0KkE22B60Z9Nah1WP7CzP9JFkuB7GVX2GfJmHpq6CwJKPMPwKD3dr+rYkZqYGjJYz
         Zir1v8pMytv3nYYJukpo7YWYv+MPychI+6l0WwHzoWrx/d8BATR0LwhBNtmFgdn6HhTJ
         jtIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768378712; x=1768983512;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=X8y3eBpdpZ4jiLb2IpPbzYhjPFac6qto4kOtboVZXAA=;
        b=taA4kTWmUstLnVx/N9Rt8u/bXUacmF55pCNFTS1/P9MmKvm0/hI9f6APpliNL8yptL
         tM00BYDpxkBsZ039hQgWKJtZ0u6IjfV6C852T2+DVjcj4W5wzmZZFAekw5yuss8d9JCM
         j0G7YF7jTOEAdBi10yXPNovhgyueghWUfZKroG9rqisZGpiC2zFYaoRyEdrZA+jwcQ66
         TtE3IZoLDBy1vyc1TivNw3Owm77cm50IH0NXXzRt9k2HPE6cyubpwtOy+Z8Hdsl23hn1
         a4U1Zdejzv+F/8kpUK06eZIms7SWuOC8OgxaObc9Jl0W6KVULKa+LPZD959O4E3z2nmo
         c7vw==
X-Forwarded-Encrypted: i=1; AJvYcCVneDCKGRM3vhKopsHNoMydUjcdQCKLPTEM5QTjrF4cY4QMGoF59M2sOHkpixPsqgJEvUSmAZW7Jw==@kvack.org
X-Gm-Message-State: AOJu0Ywov9wEP4Mrh2gq7mTUnn5JIWPLRhPujyDYtie+aVmJ/8i75TBK
	WC7+rccYUj4lr7I/V4sEMUxd6IGw/8S86v+oF1Gp3xIxHRU0skjWJ2SWkj4rKJdZfOM=
X-Gm-Gg: AY/fxX7pTgXVR5LQqZ+KvRroRUy+CkmXop7o7CWFKAuZt9pHN8fdGOCIY7mdncFYHhi
	Ts2x4RmZaBYIbLAaH6r/W9OukJTAGLjUERqrii0uNGG4AaaJTW5JnXWQXnJe6aK9eRaC5LJFnYT
	/LihRMeJC/slDm05mBhir6qTgWCETIMmBA1XhhDATT4xaGcq/NYc8Xe51lKO3UZt1OPpLAWGf2I
	7lPVNWrsoPw+lunFE7G2vp47U/lCWdPO98IsceUm3E1Yekv/mL0f/42aP19VbfGHBiCzyiGi3CO
	+LFbNPztu9Nlw3Bchp8GcI6E8ODKOW8wdH9r0V+nqsEj2bLW478IC3kHOp95Op6KsMhXZu6G3ju
	3+9wbbfuxddqzqRrfBB+ovvZay+yl5DQDsQbL0e+pZV11xx0NiOFMpsBpibB70h5f3+2VjF/UG8
	KKTzkWUQh9Z6bQk/VjSGdvGu5CtjEyA3m0WsA=
X-Received: by 2002:a05:6000:1a88:b0:431:327:5dd4 with SMTP id ffacd0b85a97d-4342c557825mr1897922f8f.46.1768378711829;
        Wed, 14 Jan 2026 00:18:31 -0800 (PST)
Received: from localhost (109-81-19-111.rct.o2.cz. [109.81.19.111])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-432bd0dacc5sm48487321f8f.5.2026.01.14.00.18.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Jan 2026 00:18:31 -0800 (PST)
Date: Wed, 14 Jan 2026 09:18:29 +0100
From: Michal Hocko <mhocko@suse.com>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>,
	Christoph Lameter <cl@linux.com>, Martin Liu <liumartin@google.com>,
	David Rientjes <rientjes@google.com>, christian.koenig@amd.com,
	Shakeel Butt <shakeel.butt@linux.dev>,
	SeongJae Park <sj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,
	Sweet Tea Dorminy <sweettea-kernel@dorminy.me>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R . Howlett" <liam.howlett@oracle.com>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Christian Brauner <brauner@kernel.org>,
	Wei Yang <richard.weiyang@gmail.com>,
	David Hildenbrand <david@redhat.com>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Al Viro <viro@zeniv.linux.org.uk>, linux-mm@kvack.org,
	stable@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
	Yu Zhao <yuzhao@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Mateusz Guzik <mjguzik@gmail.com>,
	Matthew Wilcox <willy@infradead.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Aboorva Devarajan <aboorvad@linux.ibm.com>
Subject: Re: [PATCH v1 1/1] mm: Fix OOM killer and proc stats inaccuracy on
 large many-core systems
Message-ID: <aWdRVY6Bzw2kjedk@tiehlicka>
References: <20260113194734.28983-1-mathieu.desnoyers@efficios.com>
 <20260113194734.28983-2-mathieu.desnoyers@efficios.com>
 <20260113134644.9030ba1504b8ea41ec91a3be@linux-foundation.org>
 <c5d48b86-6b8e-4695-bbfa-a308d59eba52@efficios.com>
 <20260113155541.1da4b93e2acbb2b4f2cda758@linux-foundation.org>
 <162c241c-8dd9-4700-a538-0a308de2de8d@efficios.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <162c241c-8dd9-4700-a538-0a308de2de8d@efficios.com>
X-Rspam-User: 
X-Stat-Signature: dqs3qjmf8xqb5pothw83xdq9bbgrc8gn
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 6FF1E1C0005
X-HE-Tag: 1768378713-207318
X-HE-Meta: U2FsdGVkX19JkHz7IXZuSYmYKyZf55SkVn9FH/r+L9wYECOFfUMg2Xo2GEd7+lRjKX4OpOgSUtZNwey9J50mkWfbpYAJRcinu12N10H1A+Kz+e6q2OoeqvEDq1D36iDBqnFy0Q3zBtnEGdrCtF4qe6JaqiE1FHI7HQ9Nt8TYLa/YhqIe5LNdpzDoqsLqb3mlNsJNPQbPMTS45KB+A5l/dSW+kfx8VYzouM6Ti2+bH/Qu4YayAStASgwIcpiGbu4xJc1L5n3omgrSlJxTRpPI3LSwmA6hof6AH/J4MLLnv/ATXI7VsFekNZZ/rSNqfPCdkbhDbY7meyrD7JRBmm5IKppdezPTmq3PDVb3DkDcomCtB78FHjDwTSrJD9RENqpcEJgM9ArzMq+q0Rekc2d6nlV24LYPb3APcdn9NXIU6a87cjt/Yd+Cfnxxu4lti8LWr0JXPjbtdiGvYhdWgh3o01cxitBqJaRBmYsLbViSow+QL1qZ1KaGrn4ThDpTkh4I/fVB4RngQpH6PxtZ5UfprlILyTC9v5mwpWgn05HUdh8sK/h0O32Edr0Rg/1r1wwGAGBKNUA0kRe2h+yWj8EpG7TdAhFDZx4k26/g43w/Ila+9OVq6SrioZ92y5Par/zFfq62zzyKUx4FNiMEYM6M/pr7uUQdWYQpv+Q777t8biEhcxmGPReSBdxLNzUgj34MGZsV7t4uQWKSS0y6mU8h2ytwEZI/P1jf8skbkomfyL9cONuc6tsy1rgkHLxQBSo52qwTpTACJgbf0Pjf2tjhffnmWV5xUB6Zcw9fW3f538RfO5NJOk2HQcWppFhOUUtDVG26hkImV7Rc0dOw4HL5IJw0+9IhBzaMkeBRLpkaAspwmcTVgCgoATrbQLIZb/S5PhTaian9EnCfNqW0uC2za0SIj/x81itYprfBrK1w9egyfrFarg+8F+GUlDOxnmM5LPZqLtm3uTgXSoVs2dL
 TNl9h+Cn
 KdSJRVx/N4edJGCPBGobV4oWrjdxuM3x3SYwgDEFHnaVNbo+UPvX3cGhRJvs2raRZwbTYaRdFk/ul6kHG6vvKvTt1+RzKY5wFZvA0pzxVhMhoqyxN7taGIS4PKpwf+OBWKoUBYirBaHChTZp613nmZ0xfVoJDO4piH01pXgFyi2Egi48bgwfqkkYLyPIdhlSKaB3ecZtH90qvNXjKPEquO4FYDdTJB4xIDJAnPEVOSDis1s0gszoB6abL2ntlb4f66wy+KgQoFb0zp4dU9HGQLEb9WB4HawoDwNbc8wzNhIff1T9S3OPKti9tbG/CykekfEtULg2St07cgJED6qa58//UyuJ5bHjoO2gVE7Cvf+nUHsbfy/Ztg0k3TsueDfhwDcgXPDto3+Qao3doNj7/dXD2zUBRyzSKaybE3Rv/nyK7O4r2zgGq8jV4amtvNN8WwX6pWT/CX3nbxDJEdT83COHEZLbOEK8FMgaK1oflpCM5QFY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue 13-01-26 20:22:16, Mathieu Desnoyers wrote:
> On 2026-01-13 18:55, Andrew Morton wrote:
> > On Tue, 13 Jan 2026 17:16:16 -0500 Mathieu Desnoyers <mathieu.desnoyers@efficios.com> wrote:
> > 
> > > The hpcc series introduces an approximation which provides accuracy
> > > limits on the approximation that make the result is still somewhat
> > > meaninful on large many core systems.
> > 
> > Can we leave the non-oom related parts of procfs as-is for now, then
> > migrate them over to hpcc when that is available?  Safer that way.
> 
> Of course.
> 
> So AFAIU the plan is:
> 
> 1) update the oom accuracy fix to only use the precise sum for
>    the oom killer, no changes to procfs ABIs. This targets mm-new.
> 
> 2) update the hpcc series to base them on top of the new fix from (1).
>    Update their commit messages to indicate that they bring accuracy
>    improvements to the procfs ABI on large many-core systems, as well as
>    latency improvements to the oom killer. This will target upstreaming
>    after the next merge window, but I will still post it soon to gather
>    feedback.
> 
> Does that plan look OK ?

I was about to propose the same. 1) is a regression fix and should be
merged first and go to stable trees (it is a low priority fix but still
worth having addressed).

Also a minor nit. You do not have to send cover letter for a single
patch series.

Thanks for working on this Mathieu!

-- 
Michal Hocko
SUSE Labs

