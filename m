Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 17E6FCC6B1D
	for <linux-mm@archiver.kernel.org>; Wed, 14 Oct 2026 15:34:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1F01E6B008A; Wed, 14 Oct 2026 11:34:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1C7A66B0092; Wed, 14 Oct 2026 11:34:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0BAAB6B0095; Wed, 14 Oct 2026 11:34:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DB2456B008A
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 11:34:28 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 768661A0602
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 15:34:28 +0000 (UTC)
X-FDA: 85321628616.01.F57E2D5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id BBC891A0002
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 15:34:26 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oXwsjiim;
	spf=pass (imf19.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791992066;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4PFOX9yalEabkXcpKYf0K7UJ8iSUGtpn9nhdGgjblA8=;
	b=dOsOg/dXwDEn4HGTueBzjKRd9NotISD8jnfqG8S5fk+/5ct+4xzW/bGr6qeeFzgyL5TnFL
	Os7Ec2yI7rlbNJTWrsapfi+FVwpqLaiyzSQtlNa1BjvHjwtxdWtyV/7gPZyY4IThx6COLX
	bzwghrncTCSiNkKt2GhOkmVeMAzD5S0=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oXwsjiim;
	spf=pass (imf19.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791992066;
	b=ssuBqg6g24welZdMPcF3k6c3fYVfuXncnRpLX6V+ySqXf1le8Lnrq5zi4gCz2lku0FvUW2
	kFzOuOoOJNcEFiBTI9Z3LZRKR5OL1hCp9Ok/raz160nst3e11mndzbCof+W2NmQpn5Uudi
	aOVFD8dZSueXNoG+KaWqqRhDu/cnm3A=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id F008643710;
	Wed, 14 Oct 2026 15:34:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3ADD91F000C4;
	Wed, 14 Oct 2026 15:34:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791992065;
	bh=4PFOX9yalEabkXcpKYf0K7UJ8iSUGtpn9nhdGgjblA8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=oXwsjiimljBkk3klGNvt2oGaICpvgZfYfSRo10UiYzT15XrWeCYt6KEOlmy6ogSP3
	 lvrU+RAONvfAw+EO/TwZA6uxO0ktnG4cQofibjrwCwnK5x37vHTvg0G9kufqPAqiEm
	 PHOVyF6jRrNvealKCeNKw1ZQE4eJtZ0tfoPeyt1W2ZLD7tv361JizIZMAhQf5HQLrV
	 435ZB8BCdRo12/DcFdO+x6EuaApq26T0noVRE9AIwbjec6e3CQeblCsaTouSHBYRgE
	 12I3RDGLcnHbknrkK6HM+70+HlA3PYB+TIvAZsUxBg97UMqA+Ind7CkAj5afjetywj
	 UnslMDXYih0yQ==
Date: Wed, 14 Oct 2026 15:34:23 +0000
From: Yosry Ahmed <yosry@kernel.org>
To: Joanne Koong <joannelkoong@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, 
	James Houghton <jthoughton@google.com>, Shakeel Butt <shakeel.butt@linux.dev>, Tejun Heo <tj@kernel.org>, 
	Jan Kara <jack@suse.cz>, Miklos Szeredi <miklos@szeredi.hu>, 
	linux-fsdevel <linux-fsdevel@vger.kernel.org>, kernel-team@meta.com, fuse-devel <fuse-devel@lists.linux.dev>, 
	Jingbo Xu <jefflexu@linux.alibaba.com>, Roman Gushchin <roman.gushchin@linux.dev>, 
	linux-mm <linux-mm@kvack.org>, 
	"open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)" <cgroups@vger.kernel.org>, Nhat Pham <nphamcs@gmail.com>, 
	Jesper Dangaard Brouer <hawk@kernel.org>, Yunzhao Li <yunzhao@cloudflare.com>, Song Hu <husong@kylinos.cn>
Subject: Re: memcg stats flushing (WAS "Re: [PATCH] fuse: disable default bdi
 strictlimiting")
Message-ID: <as-fG4VB_4xnAI8n@google.com>
References: <CAJnrk1YifN22mA5PFRVrh3m_ygxax6x4_8nraG2hPqCzyzBj7A@mail.gmail.com>
 <anpsLy_pCanocgS1@google.com>
 <CAJnrk1Yoj7fqbzurmHkbA-vegpQu3cf-_dfvKor_VxuNhPR-AA@mail.gmail.com>
 <CAO9r8zPLipVW6bvyDK1ypSawbo=LHKvmLqWH0xA6WMR9GYNJpg@mail.gmail.com>
 <CAJnrk1ai-TqcudPoK-qFRYAJnUjBmg1kVa6Vxg3eDm5w5ivqSA@mail.gmail.com>
 <CAO9r8zNJ=Fpc0pZExrttVTDCM3yzSmLPCAU=+RS0k5Pm+hY96w@mail.gmail.com>
 <CADrL8HV7_f68qfd6hG=xCTqzupPqr77ynbwdz8jm0hzjdgDVeg@mail.gmail.com>
 <CAJnrk1aHdBm4CofvKfx7B3H-uF2xRXZUQs47J_4xeRmRZ4hcZg@mail.gmail.com>
 <CAO9r8zOkBVgxdb3pCyHs-ZQTxhwBmA1_+aH0snV7dzbVaVsPsg@mail.gmail.com>
 <CAJnrk1ayOhrFY8LOMYxqEMYZvhK10zjTTyOK93VzMgxpV5W5sA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJnrk1ayOhrFY8LOMYxqEMYZvhK10zjTTyOK93VzMgxpV5W5sA@mail.gmail.com>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: BBC891A0002
X-Rspam-User: 
X-Stat-Signature: bdi4f49fjrwpdxat8huuotxf1stejjs5
X-HE-Tag: 1791992066-409846
X-HE-Meta: U2FsdGVkX1/gXkWCNoAhmdxRgkr+zvw8sQpsIqLrX6mXSen5iz22BaH3GXp7tRN32DpT+JJkGW0OAGpkcyPWcK/OwRlfM9nAGpVMouZi/hAQhrahMo9niHzUVOecnQoy5ojVYekwAQwVPtxTMLrWyI+m3ak2jCV2tnyyPoLBz6NIP9rpPENayl10XkQXdAC/SNlTDcv5RCpV8qPf/dA+DB3jqM52spHPZv1IURK6rCG59LBewLI2d4K6XiOvoaI49g/MTo04tVqEBMkPQPdaLspeqqp23arEmbYCPEExuB8rASSlNzW6GprS0EtdFSCFYH/Gi+4vYK8D1oBzHrJHiP1TW0QWIJXlWxdJYHzBeVN95cGaWhcRfiNoWG6UuUY7wBTGiXpxuOhC6oJ253TXuIvje4EG6Z7eIdE4817AeYPECA6yzpiyS0BQGQ97axCR243JeIZ/1JptQ4okGzxPIcVNoF0zU4TzUiZYAIdwaCHO/V+vVnRQ9vRC4i5+22BJ/kHVpmx+8DU3fNZUJXBuD/pHWnsned5mI0NaVTRcRmOWvj02VqqIvYcQHMFBwl3opPh5Q3kpgF9YlOxSzR0wmxDjS6Qg18L5lL8/luaaZgioVHPew4IhwTE4W4ix586kcb6tk1xhwTalCR33FqQnVQug4jXmWsHmp3f1G9ZRYLcbZ+uipm40yCWUgcm1rD84N9I5tv2U4lXQSIG1QKjV087Tl4InKHzpoWWVBGlrAzc1e1jSkc9k3z6+vjOjOy55u0X40la8srUhQYvEm24N5H6zkhk8vLVurQkIZtX5Ue45+iz/rX0xgI+3mDl3KkaRhnWx5cnJZXLA4AVrDp45vmu/veArMc6czcvgWRNYBhXZi764as3WDgxWN1+37XpimNgqmCLZeBh5rHyrevc5qqUu/H5g2h5m242NyEDk4YkL0u6+e3C6fn+VVU+QU+2z8ZCmbtq5wIYUxp0JJCq
 wTPCTn2o
 Gr4ZataK+Pq2yTOA23MRP3rpg4mXLCqhZDOyXSzoBPH7P1rGMiEWZNcVtXnF9yyRr3DjMYiFBUfzlxLdD3NWKPJ5Z1G/1IYRbcq/DdfF/EgnY2rWkyWxkxEgSQ4bil8S52XPgsad6LEnH6CQcriI27KyjV0ypY7pVXW/WwFWSV307mJ9lY1f6LbowoGCF7mPYnciy2PxaEn8pRXhJ7Eklk6LA7J8IK3qL4/exhQE+LI232xdTf6uuaoF2ASj8JwOPhpmRDPij4sKNj4olzpNxv2TfqW6VKbQKAge2
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> Thinking some more about how stats are used... I think there's two
> categories the stats fall into: a) hot in-kernel ones (eg LRU sizes,
> workingset counters, dirty/writeback, zswap) which are read very
> frequently from the reclaim, refault, writeback and zswap paths and b)
> userspace-only ones (everything else) that are read through
> memory.stat / bpf / etc and much less often. The hot in-kernel ones
> are a small subset (~20 of ~80). Most of the stats fall into category
> b). However right now, a flush always aggregates *all* of these stats,
> even when the caller only needs / cares about the hot in-kernel ones.
> Flushing does all the work for the stats in category b), which the
> in-kernel flushers don't need. With the per-node lruvec copies, a
> flush goes through 100+ counters per cgroup per CPU vs ~30 for just
> the hot in-kernel ones (on a single-node machine).

I didn't measure this before, but I did tree adding a bitmask to check
which stats have updates and that actually made flushing more expensive.
It could have been the case that hot stats were distributed enough that
all the cachelines were being fetched anyway and the bitmask was just
added overhead.

I think you should do a simple experiment first about how much flushing
gets faster if you skip the stats not used by the kernel. It may or may
not matter, depends on prefetching (conversely, I wonder if explicitly
prefetching the entire stats array on each CPU would help).

I think it would matter less if we manage to completely get rid of root
flushes (except for userspace stat reads).

> 
> What do you think about splitting the stats into two rstat trees, one
> for each category? In-kernel flushers would then only flush the hot
> tree (~30 counters). memory.stat would still flush both (eg userspace
> would see the same thing as it sees today). Each tree would have its
> own lock and its own stats_updates threshold.  I can run some
> benchmarks but I think this would make flushes a lot cheaper, and
> since flushes would hold the lock for less time, it should also reduce
> the contention we see between concurrent flushers right now. Together
> with using node counters for root readers, hopefully this will make
> the non-ratelimited flush cheap enough for all non-root in-kernel
> readers and ideally let us get rid of the ratelimiting variant
> altogether.
> 
> Do you think something like this makes sense?

We have to consider the update side of things as well. How many code
paths will need to update both trees? That could be a problem.

From a code perspective, it would also be a bit annoying to maintain. I
would check if we can eliminate root flushes first tbh, then check any
other potential optimizations on top. Subtrees should me a lot smaller
than the entire tree.

> Separate from this but also kind of semi-related, I noticed
> css_rstat_flush() takes the rstat lock for every possible cpu, even
> cpus that have nothing to flush for the subtree. Maybe another
> improvement is to just first check locklessly whether there's any
> updates and then just skip the cpu if there aren't any. I can send a
> patch out for this.

Only the updated cgroups are on the update tree, not their ancestors,
not until the flush time. We used to put the ancestors on the tree on
the update side, but we don't anymore.

So we can only check the if the per-subsystem list is empty, not the
subtree specifically, right? Can we walk the per-subsystem list without
holding the lock or deleting first?

> 
> Thanks,
> Joanne

