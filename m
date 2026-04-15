Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2AAE4F43821
	for <linux-mm@archiver.kernel.org>; Wed, 15 Apr 2026 14:33:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0EA4C6B0005; Wed, 15 Apr 2026 10:33:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 09B8D6B0088; Wed, 15 Apr 2026 10:33:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ECC496B0089; Wed, 15 Apr 2026 10:33:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D812A6B0005
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 10:33:47 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 63D801B7F51
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 14:33:47 +0000 (UTC)
X-FDA: 84661034094.28.594F800
Received: from mail-ot1-f45.google.com (mail-ot1-f45.google.com [209.85.210.45])
	by imf28.hostedemail.com (Postfix) with ESMTP id 82B05C0006
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 14:33:45 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Xy+gBCDe;
	spf=pass (imf28.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.210.45 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776263625;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=z6++CI4laqgUkEu/9WjoRCFUvBg1ZLNaXzfHGKxYlnY=;
	b=Iwz4DLCt6EczFGG02qTY7+ri19qfU/JIpX+H7SCYPyM1tBhBPgBXwyTzD36iBOqXUP+Jmo
	ESixUuGf9iPhFqBpjb57M6kthkMfwfprpTT4sqC3xt8UJA6HGVSxhryo8fDnVYI6H2VJK9
	Y3lJW5VfoBiytxAz7u4POGejNCthH3A=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776263625; a=rsa-sha256;
	cv=none;
	b=yUAibrhH7HNDDtRsHUFEdWh2OJhQjPQjCg2Krn9vsOPPeBKPOdpcHboHFIsDvPLzHU3ZYf
	HaWqs8Lvnib5HWxsED5GVK3KnTch5EF+Ptnr3JgpdT089V/ZQOk1S0+0nUb4iQHCk0HjqW
	BKnFGK3DAWTMoPpl+AiZCauQHVqabSQ=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Xy+gBCDe;
	spf=pass (imf28.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.210.45 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ot1-f45.google.com with SMTP id 46e09a7af769-7dbdcb85067so5749738a34.1
        for <linux-mm@kvack.org>; Wed, 15 Apr 2026 07:33:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776263624; x=1776868424; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=z6++CI4laqgUkEu/9WjoRCFUvBg1ZLNaXzfHGKxYlnY=;
        b=Xy+gBCDe8KOjCZz0y/b/tXHJwTUbY87RWRWuccj2aYiats/s+rvRa+hqqwV1629oyR
         rkq8T/L673+TZ2PPRBvfMAwU5ujOGwCZuwEmJsHHkZbiWhr+SMRNZn57Yo0WXb578uCU
         XjirM2lJRRQDYoMxiKHnxPlTpDZTHiW4Wwd/4RcjMBU5yokTEd6ePcEeXBETQrOYy5DY
         cu/G/2Ac9llFoWFHusWnExgILVdGglb/TAWjZ5wm7+T8FtPmIrkcNke8h6oO92lSmW0a
         0yKqB+LA0ENuXIbZtVFW2yt/CNW32qBPdKw8v05HAX7G4UNSnxB9GthIk9vrslLl9KfU
         8DYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776263624; x=1776868424;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=z6++CI4laqgUkEu/9WjoRCFUvBg1ZLNaXzfHGKxYlnY=;
        b=P/gqzhNO8/2HeISfs3UrGRLfdqCFtm48iTKcDG7dijLHvaO8x9rz9VT1FdWy0GV15G
         6DuqMtRZVNhlz7xGe+1Kr1w8tZZXb3rY7X7DnxMUDj1biTY8CVxr3qAa1gPhxhK8ga6W
         k3zVASeJfP4fACsUwfVDAx4niG63RayqtNoNIfyqOMPqFSMDX1wQReyui45WyRJtMh6E
         t12+RiChEHOkOEIzqJ5DHOBEPLF9B8BdjwgUgvkM852qvM6T+AX3MQ73HV74pku6lP+N
         i+CsxJrW4+Cz/8TLzmbbHLoNBWPFSObJ2N5EM0S0grKSHWh+gzE4uZ4qXeua0+Gm3zR+
         E6Ew==
X-Forwarded-Encrypted: i=1; AFNElJ/l2ahVN8Me08RadZ7Fx++YtXpVfi5SM9xlEc4PHqfAEDklTz0inhYWBm+PvkdtdEhKLhOnQbnbZw==@kvack.org
X-Gm-Message-State: AOJu0Yxk0uw+bFoNPSmccG8ClXvXZ4JsdiOe8WDoITI9OlDQUTYSpbZj
	FzMyLM92mBn9BY09iw1GhE/zrIgH4tib/DtSCkc39XhajgXDxiXMkd8H
X-Gm-Gg: AeBDieu8srLOup70LP5E0mwcYPW67bj3PsTiBa6+APpB/IqIV+k/FF5wfQj7VC1645p
	CK0Jx/ihSR/07iU7hXZ6BPuP6+fMy6foXKSnkL9BVoaz3rHRpY/f+36kuNVA1e4oU6pzE6Z7yTa
	VQNmCL9MvU4HFwhv6t1MtcxYLaAc37E/1UhsHNzm0OF/3UFhFND+kvK5ZoLsJ7ADkBrJQFHaqSc
	zxGzFt9Ll8CNHknADIRvN/v8/FDdueyIRyqX0y/3rHRxc5obAXypdAKF7pU8uExgmqZ3c0pqPtj
	dorod66vXWkg6GDG96As9YzOhWUOkLSu+aAfcEJUKHe6tnzxCV/hsUXIEs6VVv+aKI0HvAp7Tiu
	e5k9qDj9JcyrwjXOUE/8SighBevAoAnkM00D2nvP7oNkZdbjlbuo/PUhM7Pcbl7pJdE9gwrulR4
	WZTg3LuJnfR8cFrnDASlRIsg==
X-Received: by 2002:a05:6830:6ae9:b0:7d7:d8ca:c211 with SMTP id 46e09a7af769-7dc27dde06fmr13267298a34.1.1776263624373;
        Wed, 15 Apr 2026 07:33:44 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:53::])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7dc76a3612dsm1524656a34.10.2026.04.15.07.33.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Apr 2026 07:33:43 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: "Harry Yoo (Oracle)" <harry@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Michal Hocko <mhocko@kernel.org>,
	Yosry Ahmed <yosry@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Dennis Zhou <dennis@kernel.org>,
	Tejun Heo <tj@kernel.org>,
	Christoph Lameter <cl@gentwo.org>,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: Re: [PATCH v2] mm/percpu, memcontrol: Per-memcg-lruvec percpu accounting
Date: Wed, 15 Apr 2026 07:33:41 -0700
Message-ID: <20260415143342.81714-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <ad74z5aSkwxn9QQG@hyeyoo>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 82B05C0006
X-Rspamd-Server: rspam04
X-Stat-Signature: yoripsxks38z6af3jwwktpxqnj11ccu4
X-Rspam-User: 
X-HE-Tag: 1776263625-394859
X-HE-Meta: U2FsdGVkX18xcdxTTuwT1CwGbKY8r4riXYCN1oYxtYWfe46ukh4C50nZOn1iRxTzMN203XVKZRJsUgORqcMaE9jEFa4Eq0iAIYIafNTcPnzAmU8Z+23zTlGS58Ske6IFkIlRBvk+G+y82GcoFRsi9XzQnqVKURzMt+L5TGpB5yFJG7E6z/w8xB+/7QRB05CMaRpmy10T2BdbHz2tf1jwjlVgpt2Q1yesb2xlOKL3c7kBzC9ockR8uewazw/hVYdvYDms4/yaMjOjYKpXMUanSu00/FY/rhdwtjfcVrAnBNH+mATfBg4S9Ljs+/phvSd2eYtxoE3SON6s4ujPZHk/FoHSQq5Gqpijlh0A5B7nYGz/11DrvGqH3eXrowywCUYBqda4syiNaos2pGLNDeQayjQl9HFglSxURDvLbPhT9uc9wfAamAAaMxGMX36ImU6SiEpbVuU/jBRQFnijyEVMVJ2acQbiIpDf/1xSHYcqiy1ykVlkO/FIYCqkLRPbBncGI0kQpFeAzTCHHeTCUmTJnjWHcVVAmQxX5FYWc7t5LMCQ6nReB/krLoshWeOErM7BCTllAFT7llB3Xbqtv3k8cRdqEYp3XKtzeJ8nSz+xsWbRm3DmJBYzguHNLXOj6wTxByQLq/GPb6Z6wM1NiQHgxg7S/cVVUPBfk353Ndzxj2DXS8UETwgA136cUGPsrwNPOueoifzQq6GW54MpFr+OxrcNop4esVjxnFk6r1b4RRaSFP72Xxf+b3/q9MNcs3N+JDORk39adGKVDk2zNV6EMGMJmjZ2ytmFLptLgFdWQlfLWEwkayQGySQDDsWdlOwXF7sRYLJGWwxVFGjJ+MyMapBGM2a4a3y8Fh3ZpwlYXs/CPMxnEvPiGdwC5sARLATjyiXAbtmpgHjEJNmgFV/dU++zMtH18yt+NMBqGpt1LOw3gMJwtJlwuSK0vk3Bl2cDfta8Kpzy5xwYoMvf4yI
 jn12xrKr
 vfGLu7dqavrFZv+JY2Mypu7WH5Vl3Kjfa+85jXJl7r2mbjvR+aN98BFRyC2FqHBwqng8137wiwTU+pWLfQSAztCPnNZKLbbGhNoN0akHNIo8P5z96y0vfv7jLhzNtrEmnFHTNClM95ub4ehVjpj+hQBPstkyaNrMUP1/1nNkWkDoMDfw3gpondPIVZW9EfqFRTNu1JwRyQgKDSps7ugYLqeHY++CUwYE8UevJb6DqBsbSxUJLIe4tUMG9Li5Lt5o/8E1y4+fLpCKx1tQwv6K7fNpN9wjVH0YRw8Wo+F3nGzH09X1bgh9GAaOQPs/ahD+slT2m8nAG6MsOSXTdVW/TJTgb/x9aOGA7d3MSnqhmhQktdjFSaULLWozxTnsAFyoiGKvjvB5ivbOrPZUoRBjUlg9qEjijFXStGGBX9t4Xu9ZLZn591mcjwFBFKdwv62i8tJB2JpJbenQONKfqW9WIVVa415yz7hpXRPEEd8HPa7P81IADddkH6FvKA6h0vFhW/ou3JlmZN5niUwWoHyw7AgFprA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 15 Apr 2026 11:32:47 +0900 "Harry Yoo (Oracle)" <harry@kernel.org> wrote:

> On Tue, Apr 14, 2026 at 01:26:31PM -0700, Joshua Hahn wrote:
> > On Fri,  3 Apr 2026 20:38:43 -0700 Joshua Hahn <joshua.hahnjy@gmail.com> wrote:
> > 
> > > enum memcg_stat_item includes memory that is tracked on a per-memcg
> > > level, but not at a per-node (and per-lruvec) level. Diagnosing
> > > memory pressure for memcgs in multi-NUMA systems can be difficult,
> > > since not all of the memory accounted in memcg can be traced back
> > > to a node. In scenarios where numa nodes in an memcg are asymmetrically
> > > stressed, this difference can be invisible to the user.
> > > 
> > > Convert MEMCG_PERCPU_B from a memcg_stat_item to a memcg_node_stat_item
> > > to give visibility into per-node breakdowns for percpu allocations.
> > > 
> > > This will get us closer to being able to know the memcg and physical
> > > association of all memory on the system. Specifically for percpu, this
> > > granularity will help demonstrate footprint differences on systems with
> > > asymmetric NUMA nodes.
> > > 
> > > Because percpu memory is accounted at a sub-PAGE_SIZE level, we must
> > > account node level statistics (accounted in PAGE_SIZE units) and
> > > memcg-lruvec statistics separately. Account node statistics when the pcpu
> > > pages are allocated, and account memcg-lruvec statistics when pcpu
> > > objects are handed out.
> > 
> > [...snip...]
> > 
> > > @@ -55,7 +55,8 @@ static void pcpu_free_pages(struct pcpu_chunk *chunk,
> > >  			    struct page **pages, int page_start, int page_end)
> > >  {
> > >  	unsigned int cpu;
> > > -	int i;
> > > +	int nr_pages = page_end - page_start;
> > > +	int i, nid;
> > >  
> > >  	for_each_possible_cpu(cpu) {
> > >  		for (i = page_start; i < page_end; i++) {
> > > @@ -65,6 +66,10 @@ static void pcpu_free_pages(struct pcpu_chunk *chunk,
> > >  				__free_page(page);
> > >  		}
> > >  	}
> > > +
> > > +	for_each_node(nid)
> > > +		mod_node_page_state(NODE_DATA(nid), NR_PERCPU_B,
> > > +				-1L * nr_pages * nr_cpus_node(nid) * PAGE_SIZE);
> > >  }
> > >  
> > >  /**
> > > @@ -84,7 +89,8 @@ static int pcpu_alloc_pages(struct pcpu_chunk *chunk,
> > >  			    gfp_t gfp)
> > >  {
> > >  	unsigned int cpu, tcpu;
> > > -	int i;
> > > +	int nr_pages = page_end - page_start;
> > > +	int i, nid;
> > >  
> > >  	gfp |= __GFP_HIGHMEM;
> > >  
> > > @@ -97,6 +103,10 @@ static int pcpu_alloc_pages(struct pcpu_chunk *chunk,
> > >  				goto err;
> > >  		}
> > >  	}
> > > +
> > > +	for_each_node(nid)
> > > +		mod_node_page_state(NODE_DATA(nid), NR_PERCPU_B,
> > > +				    nr_pages * nr_cpus_node(nid) * PAGE_SIZE);
> > >  	return 0;
> > 
> > Hello reviewers,
> > 
> > Since I submitted this, I have been thinking about the feedback that Sashiko
> > has given this patch [1]. Harry has already pointed out the points about
> > drifting due to CPU hotplug, but one there is one particular concern that
> > I have been trying to tackle with no avail.
> > 
> > The issue is, pcpu allocations for CPUs on node A may actually fall back to
> > node B, if node A is out of space and under pressure. This design seems to be
> > intentional, to prevent memory pressure from failing these allocations.
> > 
> > However, this means that we cannot charge percpu memory based on the number
> > of CPUs present on a node, because although the memory "belongs" to the node
> > (since the CPU it actually belongs to is on the node), the memory can be
> > serviced from elsewhere.
> 
> Ouch.
> 
> > To handle this, I've tried several approaches. All of them were either too
> > expensive (iterating through all pages at allocation / free time)
> 
> How expensive was it compared to the baseline?

I haven't done any performance analyses, but the changes that were made required
every pcpu allocation to iterate over all the pages in a loop, and account the
page where it came from, whereas previously we didn't need to do any iteration,
just charging or uncharging based on the size. But maybe it's not so bad
after all, since these allocations should usually be pretty small.

Let me try running some tests to see what the absolute worst case scenario
regression would look like.

> > or introduces
> > new drift (I thought of managing per-chunk statistics as well).
> 
> How does it introduce a new drift?

The other approach I tried to do to avoid the iteration over pages was to
stash per-node counters per-chunk. But of course this doesn't work well if
we need to have statistics per-pcpu allocation, or if we change the ordering
of the charges based on the ordering of the chunk's pcpu allocations.

In any case, thanks for taking the time to check on the patch.
I'll try to spin up something soon!

Joshua

