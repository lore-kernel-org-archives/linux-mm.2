Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8EA9E1125854
	for <linux-mm@archiver.kernel.org>; Wed, 11 Mar 2026 17:00:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8F3D76B0005; Wed, 11 Mar 2026 13:00:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 89E4B6B0089; Wed, 11 Mar 2026 13:00:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7AE0C6B008A; Wed, 11 Mar 2026 13:00:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 55F2C6B0005
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 13:00:17 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id DCE5E140307
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 17:00:16 +0000 (UTC)
X-FDA: 84534395232.05.544F36F
Received: from out-184.mta0.migadu.com (out-184.mta0.migadu.com [91.218.175.184])
	by imf07.hostedemail.com (Postfix) with ESMTP id 3154F40022
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 17:00:13 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=pjqpT2QE;
	spf=pass (imf07.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.184 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773248414;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8u7gOfH94HKLacZFGszI8Rx3/Wm+sBV0C+t5lK8/D3g=;
	b=mmtI5Ice3DWePfaJ8HfRvtup7PzLzJE692PMrSkMJN5osG4SJa57fTx5KlpOjuavZ6RU7n
	w1Q4AXcK8EMEHUE+wC5wTjb7LyEza3NXasjZtGaEYvsw9XKnNZAHCiKasvSrJkky+TsLGE
	uAHzF6rqoY/qfZuAmstOIP2u7vjLQ9E=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=pjqpT2QE;
	spf=pass (imf07.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.184 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773248414; a=rsa-sha256;
	cv=none;
	b=zSW6MqVe3rGC4N9HQAhkWHOubZyjYkYAl8NW/9G/08o1IBRYpH4afb6o6PrF/PU8poLx9j
	LXNbJtdenH5NM8FerD4zuUlK7voP1cmx+Wyy3bhZWg+lHSa0i1341IzNVVIxsoEUhkei4u
	C6VU7MRspaBEG4t3YEoAoJaNmIDjA7o=
Date: Wed, 11 Mar 2026 10:00:05 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1773248411;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=8u7gOfH94HKLacZFGszI8Rx3/Wm+sBV0C+t5lK8/D3g=;
	b=pjqpT2QEx4QK4mt9WWipNl59lZpDJsmlzMJx2BS0z9m7lFDATjsn4sT7L1t5WG0S8BWeR7
	30jtKuIoe2+ew2uhWL2YcasG+2v14BUqCRQ1kfYnUQH31uq5teDA8hxaVhrB9tOQ0locxG
	WlaeoTQ+EuQzlgyi0SYgYA6788FQ2UM=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Jiayuan Chen <jiayuan.chen@linux.dev>
Cc: lsf-pc@lists.linux-foundation.org, 
	Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>, Michal Hocko <mhocko@suse.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Alexei Starovoitov <ast@kernel.org>, 
	Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Hui Zhu <hui.zhu@linux.dev>, JP Kobryn <inwardvessel@gmail.com>, 
	Muchun Song <muchun.song@linux.dev>, Geliang Tang <geliang@kernel.org>, 
	Sweet Tea Dorminy <sweettea-kernel@dorminy.me>, Emil Tsalapatis <emil@etsalapatis.com>, 
	David Rientjes <rientjes@google.com>, Martin KaFai Lau <martin.lau@linux.dev>, 
	Meta kernel team <kernel-team@meta.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, bpf@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [LSF/MM/BPF TOPIC] Reimagining Memory Cgroup (memcg_ext)
Message-ID: <abGdmslfvNTiQUJm@linux.dev>
References: <20260307182424.2889780-1-shakeel.butt@linux.dev>
 <6076b8c2-c198-442d-974f-b3084a0cd1b1@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6076b8c2-c198-442d-974f-b3084a0cd1b1@linux.dev>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Queue-Id: 3154F40022
X-Rspamd-Server: rspam08
X-Stat-Signature: agizoaqt8oeyyy7qymf9bwcfwoxaj6gd
X-HE-Tag: 1773248413-288832
X-HE-Meta: U2FsdGVkX1+5hW1RemEdH251JN/tXfwbCPAUjapubzPB6GaZe/yGVYIQxyO49IXFDagQVIjIIoH3bhOuAcv+sea8CJe/KqKXMwnIzacOg7khiyOoNlimg9lW/nLhS8q0FEibeATCRECm6JeR+VuOV8V0VkC+QJ0LfwAhrCLYESFRMYXv7hChKZu1eZ2eIxt689uz0FSJYxpxlJx2BypGHv7hSQrsEP/C6Pb4NQ/8ritz39ChE51Ok8bVv9P9f6YgzQYqjkd6SsNwFvAKjXQn86bOJUm5k25KYhyW2zlYPkvL5AjFwjVQKmDVf5CFCr39ZGHXRys6o6JBM2wLWnzjog5Zf9lcII+B0kEzwMBPnew1Zg7VDEnEUsAFm3YqD89kWX4WWLNbK1q1o1ZPBWm+VxwXgOOpMJbyeCJm7qYOhMCK6ERw88WM3PjDeBAZuLMMc7KzOou/OHIIn06FRn4WOc7jJ0FtMwaKBMXQqXi/fjwIchoYGFCmLWnzILpz/IScFSccaSwanTFWpYSYIA8kByydtAJ2FLQMttmEp0onomJ4ST/qTftfdjflCFasdF+Ix7Inm286SCaODmCClMBYzNu41H+BUJIKZlpWQhkWacmpyB91isJrGB+pXAuvS88LNRkLrH7c0F9XU8JQq3P5whSkX45W66gD+H4oWLJdpxDLMD5JCNJ6y4/9OBKAV21ZY4BtYKUFhyx76bioPFMyx81ugF1iyNbIPKWZvxPN6ZZ7RP1BzxiCzu3fdiBgBLLqdz2zhxyayUMqVyrD/k+tZh2Bm8ciHr13864zJzWB50b3GnlF9M0m0WEYNZIYQydRG+2lESTEi0EhHi+Ghgh3Hf10sW+80OQEX0jKpiuJRIe9uasitQOzfmuYn3MdM5OVuKoQS+yniNLewKjEKhK5QZZPRKn6+RC6XuuC4QkQnhuRntQRbYMdc09jz+qYuZfCdYiSvgorzoR2WWU4iGN
 tgq7ukfD
 3HF6dcqoJ9iL9rPQq+aD2Vxfi8GWVyt0fHBviHnGmadbFXDiIlz3ebW8q/Sw4gFhkznSmJkbEOeMZwKcZZB6TW/kIJjjyVqbSYDgXF6f8zcjPa7e/f6BZmwQ9xWbp+k/fXhtaHOMMd+tj1hqjKMmTtN/YAei/XEUNQbarQQI6YbyLiT9F11OVFBMOK6HY0ni6THATmbKjgIscW1NwB7XxfvYyfWKSWBFTwDifhLEbRZIc8w5UxZJ3g85T36rTxO8bbpC0
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Mar 11, 2026 at 12:57:34PM +0800, Jiayuan Chen wrote:
> 
> On 3/8/26 2:24 AM, Shakeel Butt wrote:
[...]
> > 
> > Per-Memcg Background Reclaim
> > 
> > In the new memcg world, with the goal of (mostly) eliminating direct synchronous
> > reclaim for limit enforcement, provide per-memcg background reclaimers which can
> > scale across CPUs with the allocation rate.
> 
> This sounds like a very useful approach. I have a few questions I'm thinking
> through:
> 
> How would you approach implementing this background reclaim? I'm imagining
> something like asynchronous memory.reclaim operations - is that in line
> with your thinking?

Yes something similar. I still need to figure out the details of the mechanism
but it will be calling try_to_free_mem_cgroup_pages(). More specifically the
context need more thought because we need to account the CPU consumption of
those background reclaimers to corresponding cgroup. Will we be using BPF
workqueues or something else, need more investigation.

> 
> And regarding cold page identification - do you have a preferred approach?
> I'm curious what the most practical way would be to accurately identify
> which pages to reclaim.

That's orthogonal and is the job of the reclaim mechanism which can traditional
LRU or MGLRU.
> 

