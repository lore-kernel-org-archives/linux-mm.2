Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8FD0F606A326
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 01:09:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=S2r1a0RJ
Received: by kanga.kvack.org (Postfix)
	id 8AF4C6B05B0; Mon, 23 Nov 2026 20:09:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8616A6B05B1; Mon, 23 Nov 2026 20:09:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 777166B05B4; Mon, 23 Nov 2026 20:09:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 46D696B05B0
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 20:09:45 -0500 (EST)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 53B0B16073D
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 01:09:43 +0000 (UTC)
X-FDA: 85468230246.13.C973258
Received: from mta0.migadu.com (out-104.mta0.migadu.com [91.218.175.104])
	by imf03.hostedemail.com (Postfix) with ESMTP id 22A222000B
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 01:09:40 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=S2r1a0RJ;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf03.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.104 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795482581;
	b=USfF4z7pKTf2h5ewYOYA83EB+NRlxpbfLxNgR5Aj7JvidJR5oA7lRQLQQNiqsA6ykC2uTQ
	qsjjWKwleTYyYH8rEnSVmceEe/vMS8UW0QRfj0pTHCWil4bgGFhch3MQxqkrRu6Hga4Quf
	Mb34nAjokDiZ7tS6iXTU0gzYIGo9x5A=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795482581;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=owYjzpuYFLjOeIilxJig3Hw1JAaAisOBDLN+NbRQADQ=;
	b=wSsRYHs+FnEWWLUVU6Ha0TSIqDasehvKqVIHU+BXBoeRZapimmWgE94O3i4OWI28x0wlIu
	fUBQ9JUe959yHiekIUcoxOtI7Sx+gDCi8kOS4huTlhNv8I8pl3QAk1dPAREUQJVp2IXdbv
	mDb9lXL9ZnFWoZz3dyAD/49ZuK5O/dY=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=S2r1a0RJ;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf03.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.104 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=CJ0tRkMlINyNJPnyBo44a+7BaS66at2HH38E/JU9IL4=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795482577; v=1; x=1796087377;
 b=S2r1a0RJ8HfsGmCU8xVEMaN/l1w7EzrTsyYZhzykVt+eZoeGHrF20tJBlESLprJv994S3TCi
 u6k19lV8qiyNZXX7QLAOZEf+ki49TUG1GWRto04z5HWQ0qSfIIARV1AnX+rSH1037vNqMW3BBHk
 YPNRJE+Li71ydAa0RW2kLhZo=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id dc929d9c275ff9e4;
	Tue, 24 Nov 2026 01:09:37 +0000
X-Mizu-Trace-ID: dc929d9c275ff9e4
X-Migadu-Flow: FLOW_OUT
Date: Mon, 23 Nov 2026 17:09:35 -0800
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Koutny <mkoutny@suse.com>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	Meta kernel team <kernel-team@meta.com>, cgroups@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] memcg: free the private ID of a memcg that never comes
 online
Message-ID: <awTh5c6t7SczKRDG@linux.dev>
References: <20261124000439.967403-1-shakeel.butt@linux.dev>
 <20261123165451.8c30df036f95995316e15047@linux-foundation.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261123165451.8c30df036f95995316e15047@linux-foundation.org>
X-Rspam-User:
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 22A222000B
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: rgqkkba9x4wbytkyxuakkodu1gqb3kg4
X-HE-Tag: 1795482580-698715
X-HE-Meta: U2FsdGVkX1/hD45sJdKsdT+opmJoUjB9PEDxzCAScUt0kkLRUAtJkdBYGOY32S6tJ6pAyk6v7cQdvVB46DK2PAr5Vbh3QjHZTwBgHTFbfu1vKkBBS2c6s5Jmt82gnQM5zUP0ZXJDJ2U4g95yRuW6j+c8vEQWcVa31G3DyYAfUXJCskWK7hxq/qBDNZa+24M/cFM2IuHHbojoBWDjQ9NjFonqrCUod2JW/Uwe9UkBUom8l3GrpE8aC1a3fzp2tBR1y4Il9W4COwuuGsh23mXv9Tvl6mHqe4fwQoTOpSYWogBBd7D6J6GCCtlBSiBZ1hRr+ABBiZDP18BaB/QrnPT72VDjhiBrqSE8AP6PfgSfQzcfn7SkJjpePte5pCs8UMLV2JzpBXizwq820TXDg+fXJm82gVXR9vtLhZoYqVnaokCpTei7DpFuPnnCB+yLzt0cvr8AZO2BOXKDG5QyFkYN8tq9b6F/0t4KhRnE14wHcnaHRX/tDhg5TxK9bA7fCIpaYF36GSuDDtLkRlpGH3GhYzubvM5Ri5JIXMmbr0qbz7LWdKTOstr4ZI5hNEJ6Tn8HyGX2bAvDdjcCRxd//4IDvXigBrWjxESA7w8Id1Te4Pc6vaT+Vh3gQgQR42bYWTGY1Q4L2MKLx8Ib+co8jaVcr6yRZ18tzacM9L5d5Ygmg1qzf2e2BinbKTBBeo0sFMGU5leONxdtFab40cp+pgRvyWb9dx8l6rU3Bbuw6zeD21pkbKfKkinPEp+x06Kf95CtbQqSbNfPApTEU0mzUjXcu+od7YcBsII52HpejeK5e23pE13VIR855K/Ei7UTYf39ugdt1/WsPgAL0QdgQ/wLEq+ibDLe/8UXulR60iR454iPp/zmBH4AKV6r5NhypMJPe7SM6Q4Fkj4VPgx4jdLECNFhLreHtpqfLrOF0DpqD3ndav/ewpBWSzjBca9wwImt4hoa5cgbUVsHXGukvSZ
 /JdMgHb5
 R7l0c0oyQuq8hpT7yjQIH2//8WMgZAOGMtIXD7O1ztonboinXuq/sXwnLtgUUVykVsPNlhFULzJWfKR9BD4in+/uW4914MVlaHpEGv145NGRriRyTe5X6CHxRWqurGRmhzP7JXTmIeOlL/vdKnD9gy0OVuOLPco5LLxEAcEJ11aPyf1JqZEwzhelLO7ekL8qz7761sji8vArWt9NbvwL+fETwfwcpd57+aogiXldwYGexiKXk1u/XBCj+EAJF6zWqWZJ1Ukvp3GQ6dKLS/7O08ivZZe2YZ/ZnOFKzg3mYCSMbXvrS2tWlgohee1zvVHfKIMDZaGMHtIbgQUGQj+uRRBVFkry8oYGS7W1JeIkd2VCTqZBARI4l0VH+jCb8ZClmXdilkcpuj+N3FX8bDsBzh2H7YmZ0Vkiph4YAwPL420HvV0OZDLJT2gykbVek/H6vI8fU0L0cVSRG2JKBq1oVCDHC/kYJQsnGg5mh63u6fiaozRIxnwosNY0mkBQHKirxU3ER3Ul+SsH0pV/5GcaUEQ+7mOEbAL2fgGH6
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Nov 23, 2026 at 04:54:51PM -0800, Andrew Morton wrote:
> On Mon, 23 Nov 2026 16:04:39 -0800 Shakeel Butt <shakeel.butt@linux.dev> wrote:
> 
> > mem_cgroup_alloc() reserves the private ID of a memcg when its css is
> > allocated. The ID is erased when the last reference to it is put, and
> > that reference is first taken in mem_cgroup_css_online(). The failure
> > paths of mem_cgroup_alloc() and mem_cgroup_css_online() erase the ID
> > themselves.
> > 
> > But css_create() can also fail after css_alloc() and before
> > online_css(): in percpu_ref_init(), cgroup_idr_alloc() or
> > css_rstat_init(). The memcg is then freed through mem_cgroup_css_free()
> > without ever coming online, and nothing erases its ID. The reserved
> > entry stays in mem_cgroup_private_ids for good, and each such failure
> > takes one of the 65,535 IDs away. With failslab failing radix tree node
> > allocations during mkdir, 1,500 mkdirs leaked 6 IDs this way.
> > 
> > Erase the ID in mem_cgroup_css_free() if the memcg never came online,
> > which is when (memcg->css.flags & CSS_RELEASED) will be false: it is
> > only set when an fully onlined memcg is released.
> >
> > Fixes: 73f576c04b94 ("mm: memcontrol: fix cgroup creation failure after many small jobs")
> > Cc: stable@vger.kernel.org
> 
> hm.  These allocations are all small and they're GFP_KERNEL so
> cc:stable seems a stretch?   But whatever - stable people have bigger problems
> than this ;)
> 

Sorry, I should have explain better the user visible impact. The memory leak
is not really a big issues, the memcg ID leak is greater issue. We have upper
limit of 65535 IDs for memcgs and if we keep leaking the IDs, we can start
seeing memcg creation failures.

> > --- a/include/linux/cgroup.h
> > +++ b/include/linux/cgroup.h
> > @@ -449,6 +449,11 @@ static inline bool css_is_online(struct cgroup_subsys_state *css)
> >  	return css->flags & CSS_ONLINE;
> >  }
> >  
> > +static inline bool css_is_released(struct cgroup_subsys_state *css)
> > +{
> > +	return css->flags & CSS_RELEASED;
> > +}
> 
> todo: switch css_next_child() to use this new helper.

Ack.

