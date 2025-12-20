Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E1A36E668A7
	for <linux-mm@archiver.kernel.org>; Sat, 20 Dec 2025 01:11:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 48E6A6B0088; Fri, 19 Dec 2025 20:11:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 43C6F6B0089; Fri, 19 Dec 2025 20:11:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 348716B008A; Fri, 19 Dec 2025 20:11:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 235306B0088
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 20:11:50 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id ADB50601EA
	for <linux-mm@kvack.org>; Sat, 20 Dec 2025 01:11:49 +0000 (UTC)
X-FDA: 84238072338.05.ECF2869
Received: from out-171.mta1.migadu.com (out-171.mta1.migadu.com [95.215.58.171])
	by imf16.hostedemail.com (Postfix) with ESMTP id CB4EE180004
	for <linux-mm@kvack.org>; Sat, 20 Dec 2025 01:11:47 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=a8y3Ty2n;
	spf=pass (imf16.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.171 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766193108;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UvnodBTMRcGcxBVyqTPRhAjsSomVlkq7CG7vke7msug=;
	b=1ET/csjM/w7sdeXxl9tMopK/dk1zL/wQgxnTUzrTgupc35tTogzeux4YoKWR5c2BtSQLXq
	FlPLl4giePNkRoBRvzlBJpL0JNRA93YwUAlqFnfXGiUZfJusaBuSbvckp/93xJ0kBvRkxF
	UA28+uGpujGyxrKP/wy4I8YS7rxKNrw=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=a8y3Ty2n;
	spf=pass (imf16.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.171 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766193108; a=rsa-sha256;
	cv=none;
	b=KljMNxKYfYIar6lYFny+rsmploHuuPLVwFrX4GWYpVGI8MSXxii1CZVmuDv5T1BnvcfndZ
	G0bocvRfPe8MaCNDWUiIoYwhPdS1B3VTipnVfCFeuKHJllnyp8Vq8VactSCsSJkuycCAeI
	l36Tc/fIrrEbOWJaNJhwdDevMa3Xws0=
Date: Fri, 19 Dec 2025 17:11:36 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1766193106;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=UvnodBTMRcGcxBVyqTPRhAjsSomVlkq7CG7vke7msug=;
	b=a8y3Ty2ne5jeTurW+9OC7NBn+BoMlmeDdprm7CiX2wYMZocn4luhcpPYTLExt8+wVR1aZp
	+4DP/BgB2+008fvKxfR8rXTh9KlUsjaqBMBzGQn00H6KFBpZ0gRvmQcJ2GR+Q2YGDhbCyI
	h4gqXvj53U2sfa1zPP2SVlKfpfCDZNA=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Qi Zheng <qi.zheng@linux.dev>, hughd@google.com, mhocko@suse.com, 
	roman.gushchin@linux.dev, muchun.song@linux.dev, david@kernel.org, 
	lorenzo.stoakes@oracle.com, ziy@nvidia.com, harry.yoo@oracle.com, imran.f.khan@oracle.com, 
	kamalesh.babulal@oracle.com, axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com, 
	chenridong@huaweicloud.com, mkoutny@suse.com, akpm@linux-foundation.org, 
	hamzamahfooz@linux.microsoft.com, apais@linux.microsoft.com, lance.yang@linux.dev, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, 
	Qi Zheng <zhengqi.arch@bytedance.com>
Subject: Re: [PATCH v2 17/28] mm: thp: prevent memory cgroup release in
 folio_split_queue_lock{_irqsave}()
Message-ID: <ejywj2fho37z4zdtgvryxzsztgtdrfop4ekenee4fewholyugq@xrbvtg5ui3ty>
References: <cover.1765956025.git.zhengqi.arch@bytedance.com>
 <4cb81ea06298a3b41873b7086bfc68f64b2ba8be.1765956025.git.zhengqi.arch@bytedance.com>
 <aUMuRfPVxkfccdmp@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aUMuRfPVxkfccdmp@cmpxchg.org>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam02
X-Stat-Signature: n3ge3an7uqp3oym14sdfhkuue3518r6h
X-Rspam-User: 
X-Rspamd-Queue-Id: CB4EE180004
X-HE-Tag: 1766193107-363374
X-HE-Meta: U2FsdGVkX1/YbAVOLIS/5gMQK0LIiPA+HKkin24IJmJewV5I4SlA4aoDcRt3x+1pdSRQxF17XsnSpeJkwmukn4IJeqdLp6PuXiNTdVSQN7k/9XdHD+ZMZN68We0dHmBT94WhZLDkq0gp3nvNe7dEgb9AeWOo2uPR0rxGT24xUjYFFYqVI6dxq2IoV6z7Who8wRs0lJi/o1cfAIYBDoOn8sVoMWs0ChMW63PijvkiW3PP8TDXxbaBNz+rs+Ot7UG742JLuNwSG3NwUkr5FoUmZ9hwY1iD/PgYybYFYelOc+a+Ban3JfchRXtWpSG68VHgFqwuVjfNqCdx/0SDmBXVEOLZGU0eLMLTeFPY9yrdzn4FiWIwMa7BsiBlpdQeI7ljLvhtBnqnLsc0hbs+GDxJ3FW/nc+PoU39Pa1TCQuOTAtTB9PsLQXARsWdHhy4b5GUqs4MKTr+IA5E3hhRPR88W4YCipN0IbW9bMIpwV2RyNrpy+ku5M3H8vwDa4KqvObak6pKZg7uqJM8ZxOz37dQbNqthlkAQr8xx/K6CQcrl87BhR0wR8MC5koSG4cFeFWQp05BkMgR7OIZPdeUcc3hSU5I7wXwB0UbKO4Zgchs2ThwZ5P/gF/4VcE3BAL3xjBpiBQNoSyWHQ0wRPf7nGfEBNCQwidyyj7X/mDBi1DCb0UeAaPkonliKdg+poeQFSoOXzto5px+AiG3AT8G6sZEAhfgpSgfEMDZ+2lcb5s8koVWI8KcWRjUC/ey/VDUzrunsj3TPGAUQMAcsr693KiD0XbJC5HpVZ/QbIWIqGVhi7hPbQS5fY4ZB3mgnBVOO+SzqtkgSotOOE8r9kKjd1H9nVgnl5FdsvAVGDdgPMvjY9v7GpyR+u4NftJR+RXHfRwyAFS1d2/U65yAzi/8ArpzrclwAoxjSoiQIlNgies3fhMl3m+/3bayAgNhCoqqMzuUM8vvUd8Tw1nvCHq6ZKZ
 2l3bDGKA
 QdC55z62Z40/RLcDfSuNP4qrQsAPjxx1JjMLL1qTvf6961xeq22NwtoMveMIk2JRlBUWLCJMfkIjdL9aX4Eeg6LnKema7YQ//8rrEs0M3Y8Dm9Sf+x+Zhu4hdx8/YOJEEdRK/8SB+NhV9vodHGYuEBuZWB/TdiW8J77q1c7vkVbto5jm6fNceKwDF2NFwDIz0mVY+SM6a//uM9w8FFI2PIZKnDR5h7tH15sOUvay59Y1COtmopumYwJMWwyQ9U9vBiK1hIxKFlflBs3DJr8tviG1eqPjC/a9IBkkIFC++QV5VcBY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Dec 17, 2025 at 05:27:17PM -0500, Johannes Weiner wrote:
> On Wed, Dec 17, 2025 at 03:27:41PM +0800, Qi Zheng wrote:
> > From: Qi Zheng <zhengqi.arch@bytedance.com>
> > 
> > In the near future, a folio will no longer pin its corresponding memory
> > cgroup. To ensure safety, it will only be appropriate to hold the rcu read
> > lock or acquire a reference to the memory cgroup returned by
> > folio_memcg(), thereby preventing it from being released.
> > 
> > In the current patch, the rcu read lock is employed to safeguard against
> > the release of the memory cgroup in folio_split_queue_lock{_irqsave}().
> > 
> > Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
> > Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
> > ---
> >  mm/huge_memory.c | 16 ++++++++++++++--
> >  1 file changed, 14 insertions(+), 2 deletions(-)
> > 
> > diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> > index 12b46215b30c1..b9e6855ec0b6a 100644
> > --- a/mm/huge_memory.c
> > +++ b/mm/huge_memory.c
> > @@ -1154,13 +1154,25 @@ split_queue_lock_irqsave(int nid, struct mem_cgroup *memcg, unsigned long *flags
> >  
> >  static struct deferred_split *folio_split_queue_lock(struct folio *folio)
> >  {
> > -	return split_queue_lock(folio_nid(folio), folio_memcg(folio));
> > +	struct deferred_split *queue;
> > +
> > +	rcu_read_lock();
> > +	queue = split_queue_lock(folio_nid(folio), folio_memcg(folio));
> > +	rcu_read_unlock();
> 
> Ah, the memcg destruction path is acquiring the split queue lock for
> reparenting. Once you have it locked, it's safe to drop the rcu lock.

Qi, please add the above explanation in a comment and with that:

Acked-by: Shakeel Butt <shakeel.butt@linux.dev>

