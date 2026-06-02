Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1B92FCD5BD1
	for <linux-mm@archiver.kernel.org>; Tue,  2 Jun 2026 23:19:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0AAB16B0088; Tue,  2 Jun 2026 19:19:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 05BB36B008A; Tue,  2 Jun 2026 19:19:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EB3656B008C; Tue,  2 Jun 2026 19:19:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DC6C76B0088
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 19:19:15 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 6D68B160FD5
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 23:19:15 +0000 (UTC)
X-FDA: 84836540670.11.118105C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id B1EFE120002
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 23:19:13 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ftb1Jwi7;
	spf=pass (imf29.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780442353;
	b=Kz8WtV2TokggJhaXG2Z5iUNBtioQD2LZrZ7Ngo09cVME0vWeFuv5kXgBFoLus3XE80rXQ5
	F+is5nzhq5g0nMqIVZlpXdYA7cwIoKinK0EIjIdplA8kxiJbhDJCKBnYkFuOcCjpCXNk1B
	96cW7TUA4ti8igO0UP1uD/IgSmJ79/4=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ftb1Jwi7;
	spf=pass (imf29.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780442353;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KCQTKKV4OkG0g4DPTo1dosbbUmHALAtgMMXh353W1do=;
	b=22aPCSR67jI1LmhYh+DNomvU3ZEBZGT1kvXzow2Q+oEWDcYWWBK0NjNDHrzUpH4jBLEl3G
	cYoU1B2yoL6KAbkpESMLEVE7AAOspeACn8up/6iKI8rrJAwXshVKvmSkgaenMp5eMZ9LR9
	G+BEzO6IA2BUPriHlv7CukRxZKYVqdw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 99B1A4176E;
	Tue,  2 Jun 2026 23:19:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4F4E1F00893;
	Tue,  2 Jun 2026 23:19:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780442352;
	bh=KCQTKKV4OkG0g4DPTo1dosbbUmHALAtgMMXh353W1do=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ftb1Jwi7vGUaTZ08YB0sJ8lzivTWYTQb5gxbwHrpsGAczoXYB03Jtxxu4GhdujeF9
	 4wHP/NTcSz8OqTJBEHWQ70CjZV7BF2NYZWVEag1D0NzIJAzOZ4MhKs90U8W0+ZtXjW
	 BsNXfsuVYZZlL+feBLoqauAHSiClLSnOL8MWWpo5sb2oCYqo4gCZVaWBejTi+J2oE0
	 wPY9mvm0bV+o8ktBPSpD2JAw+4gyTqQ+b7tnkLOGkL9lygFoneIRHCByRTbPLrWprB
	 R+90fhMCKQijvqOyKbidq2BCDM4HR1u1y2/Ym7dvz6hTzmsXNZvtBYY2OuqRPaIR4W
	 VLxgGAMKtUp4g==
Date: Tue, 2 Jun 2026 23:19:10 +0000
From: Yosry Ahmed <yosry@kernel.org>
To: Hao Jia <jiahao.kernel@gmail.com>
Cc: akpm@linux-foundation.org, tj@kernel.org, hannes@cmpxchg.org, 
	shakeel.butt@linux.dev, mhocko@kernel.org, mkoutny@suse.com, nphamcs@gmail.com, 
	chengming.zhou@linux.dev, muchun.song@linux.dev, roman.gushchin@linux.dev, 
	cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, Hao Jia <jiahao1@lixiang.com>
Subject: Re: [PATCH v3 1/4] mm/zswap: Make shrink_worker writeback cursor
 per-memcg
Message-ID: <ah9i3uhh3PFiS0Uk@google.com>
References: <20260526114601.67041-1-jiahao.kernel@gmail.com>
 <20260526114601.67041-2-jiahao.kernel@gmail.com>
 <aho7nepN5jZtKmef@google.com>
 <8c0e60e1-5713-69f0-a687-088c87e75764@gmail.com>
 <ah4ZZGl7GYJf54Wz@google.com>
 <ff344c9f-51da-8b3a-e7a9-c4a7f4702ef8@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ff344c9f-51da-8b3a-e7a9-c4a7f4702ef8@gmail.com>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: B1EFE120002
X-Rspam-User: 
X-Stat-Signature: s9n8b6yr6shos3xq1joek4tpsqazhxax
X-HE-Tag: 1780442353-993435
X-HE-Meta: U2FsdGVkX1974lgtJ+U+WRD6d+f6mihUwLsoG9Q805/vlghWuYszQHvUrZOhBq9jtKND/KjtO4uTgop8gIs/SQndyOpPYsHKYIqjF2jyRRXobwfRxpWv2m1o+UDZZH8I5qwBJOSr8sRFOKz5ZjfZaevVpjhPcLNHM4BhkqmyEE0eGe5jO4xQut3ugOI2RD9mr77mLjktmga0A+qgBhx6M6zs8lnp7SiCTHnEJH5rrgwEr/iPYxb7GkBNmDjHATk8EShFaQvTvsNvjCHXi+UCJTN4/wSaC9mfmZOki21LWxc12rL6BzldZgo7jwUgZNH8aAcvJoMX1QmWKXLz8E8PHdKrCmcMMRjw+ToO2II4fu6QPFtvZf4LJkYPMfG96SXSid+Let93PZi0z2YoRxkluW/ArJ+Bl3ol2W52q2wIiXWjdducL8N/nXYniosAMcapzFFZ4j6xGI9aPfOhDYpio0CyCW3IkshgMQxB98LcA4foxKoqX+RDJ9fQt0snhYMginqMe5Utw0yN/ZOKTxKIiZNigVm/knWVNI/qCwckBb3z2h++lncENgTc28Tz1DIks7NLtYJkhdWNJIcLJ2X/jciwNAhl++dKAcB4FV2CFY/JAVb/aNxBtOkvxvPWsW35x1DYkXZNpASAgJDy1oKk1mADnBdZhppdJNU1lVYw19PM3qfPE3e4lGhZ7NEK2Hc+eoRs8rtCQsoyLzsjarlnf1XcOxO/2fgepfFK/1jm+h/zybabTOw6beDTiJKiUc0OIg1UwAluLFXEvcC9Pr6l9WQgZp66665IyNicS5aDP34zSGCIjCrD75o4WR/kzoW27YmmtAUpa0FezdI55xoQmnGc1wEPdNn0hW4h8gPKlJScy9qiqnzGK0yHSaLMzmQclduC4VgWjZ7DvXuoC3eIeWJCPmmcvZLFNW4yNJe2sBNXdTgJ62P4/FZzMIJdJ9oTXhDxDXSSsILoh7361fc
 cdN6E9Y6
 JLL6F4xRJ9glgUzVhfi5OT1Q/rgLUqaGgwQ8zBMJWPwNynKNQ8z9EaVJZdDA40FOf8P2zHQIGsPyNTXcGyhi8N3g3Doyl1zFpiGjLdFyCGJKDhauqDnUxtSHxmnz6X+4eNckJS9OBTAZjUT54ic9uKlMl7MIzAaqIIqHPd+vJwYGrMUObrZLzOdtXxbTo+bbV5L/yv8QYzGKuJtP15I9bQmbEAW2ioQUrMje7yLRTLYqrWC57kzLGyGUh8DARBFJUw0i/nmHVl5LjY6Z356UaQQujUttO3oNJCnWRbcU8akIyCvPAis3MAl4+SETUaM45iEGCLE0g/RxV7lmmYSZmA3OvMwvuJRHbmm8gLvZBnAcjiO0ZhZaj4D59BkEUFOnYKCTrG5NHFytJ0JOk5K0drUmvT48vDhisBW+x6A5Qyh3l8SY1Rp7N/rLzqQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> > > > > Proactive writeback also wants a similar per-memcg cursor that is
> > > > > scoped to the specified memcg, so that repeated invocations against
> > > > > the same memcg make forward progress across its descendant memcgs
> > > > > instead of restarting from the first child memcg each time.
> > > > 
> > > > Is this a problem in practice?
> > > > 
> > > > Is the concern the overhead of scanning memcgs repeatedly, or lack of
> > > > fairness? I wonder if we should just do writeback in batches from all
> > > > memcgs, similar to how reclaim does it, then evaluate at the end if we
> > > > need to start over?
> > > > 
> > > 
> > > Not using a per-cgroup cursor will cause issues for "repeated small-budget
> > > calls" cases. For example, repeatedly triggering a 2MB writeback might
> > > result in only writing back pages from the first few child memcgs every
> > > time. In the worst-case scenario (where the writeback amount is less than
> > > WB_BATCH), it might only ever write back from the first child memcg.
> > 
> > Right, so a fairness concern?
> > 
> > I wonder if we should just reclaim a batch from each memcg, then check
> > if we reached the goal, otherwise start over. If the batch size is small
> > enough that should work?
> 
> Even with a small batch size, for small writeback requests triggered by
> user-space (e.g., 2MB, which is batch size * N), it might still repeatedly
> write back from only the first N child memcgs.

Yes, I understand, I am asking if this is a problem in practice. For
this to be a problem we'd need to trigger small writeback requests and
have many memcgs. 

> This could cause the user-space agent to prematurely give up on zswap
> writeback.

Why? The kernel should not return before trying to writeback from all
memcgs. If we scan the first N child memcgs and did not writeback
enough, we should keep going, right?

> > What if we do something like this (for the global cursor):
> > 
> > 	do {
> > 		memcg = xchg(zswap_next_shrink, NULL);
> > 		memcg = mem_cgroup_iter(NULL, memcg, NULL);
> > 		/* If the cursor was advanced from under us, try again */
> > 		if (!try_cmpxchg(zswap_next_shrink, NULL, memcg))
> > 			continue;
> > 	} while (..);
> > 			
> > 
> 
> Regarding the code above, IIRC, both the global and per-cgroup cursors
> suffer from race conditions. This race can cause mem_cgroup_iter(NULL, NULL,
> NULL) to return the root memcg or its descendants, leading zswap to write
> back pages from the wrong memcg.

Not the wrong memcg, it will just go back to the first memcg again,
which should be fine as I mentioned below.

> 
> Additionally, since mem_cgroup_iter() puts the prev memcg ref and gets the
> next memcg ref, a try_cmpxchg() failure on CPU1 might also lead to a ref
> leak for memcg1.
> 
> 
> 	CPU1                                       CPU2
> memcg1 = xchg(pos, NULL)
>                                memcg2 = xchg(pos, NULL) memcg2 = NULL;
> 
> memcg1 = mem_cgroup_iter()
>                        mem_cgroup_iter(NULL, **NULL**, NULL) error memcg
>                                 try_cmpxchg(pos，NULL，memcg2） succeed
> try_cmpxchg(pos，NULL，memcg1） **fail**

Yes, we can probably just take a ref on the memcg before calling
mem_cgroup_iter(). That being said, I think we can just keep the lock,
see below.

> 
> I took a stab at implementing a cmpxchg()-based zswap_mem_cgroup_iter()
> modeled after mem_cgroup_iter(), and it actually doesn't look that complex
> after all :)

I don't think we should re-implement mem_cgroup_iter() here.

[..]
> > There is a window where a racing shrinker will see the cursor as NULL
> > and start over, but that should be fine. We can generalize this for the
> > per-memcg cursor.
> > 
> > That being said..
> > 
> > > 
> > > Currently, this lock is only used in shrink_memcg(), proactive writeback,
> > > and mem_cgroup_css_offline(). Note that shrink_memcg() only acquires the
> > > lock of the root cgroup, and mem_cgroup_css_offline() is unlikely to be a
> > > hot path.
> > 
> > ..this made me realize it's probably fine to just use a global lock for
> > now?
> > 
> > IIUC the only additional contention to the existing lock will be from
> > userspace proactive writeback, and that shouldn't be a big deal
> > especially with the critical section being short?
> > 
> 
> In the current patch implementation, this lock protects the cgroup's own
> cursor variable. During each writeback, we only acquire the spin_lock of the
> target cgroup itself; we do not attempt to **spin on any child cgroup's lock
> while iterating through the descendants**.

Oh, I did not say anything about the current patch adding contention. I
am suggesting we just keep using the global lock for the per-memcg
cursors, if we keep them.

Right now, without this series, the global lock protects against
concurrent changes to the global cursor from concurrent shrinkers. After
the series, the only added contenders are userspace proactive writeback
threads. Unless you have 10s or 100s of those, it should be fine to keep
a single global lock, right?

Yes, userspace can affect writeback efficiency, but we can split the
lock when it actually causes a problem.

> 
> 
> > > 
> > > So, should we keep the spin_lock or go with the cmpxchg() approach?
> > > Yosry and Nhat, what are your thoughts on this?
> > 
> > I think we should experiment with the global lock first. See if you
> > observe any regressions with workloads that put a lot of pressure on the
> > lock (a lot of threads in reclaim doing writeback + a few userspace
> > threads doing proactive writeback). See if the userspace threads
> > actually cause a meaningful regression.
> 
> Sorry, it seems there are some implementation issues with the global lock
> approach.
> 
> In practice, our user-space agent mostly operates in the following two
> scenarios:
>  - Triggering proactive writeback on the same cgroup at different times
> (sequentially).
>  - Triggering proactive writeback on different cgroups at the same time
> (concurrently).
> 
> In both cases, there is no lock contention. So, the current lock works
> perfectly fine for us.

Would using the existing global lock work for your use case? How many
different cgroups can you end up reclaiming from concurrently?

> 
> However, if we really hate zswap_wb_iter.lock, I can try replacing it with
> the cmpxchg() approach.
> 
> Thanks,
> Hao

