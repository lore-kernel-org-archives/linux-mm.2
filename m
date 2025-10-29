Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 894EFCCF9E9
	for <linux-mm@archiver.kernel.org>; Wed, 29 Oct 2025 08:05:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CF1A6801BC; Wed, 29 Oct 2025 04:05:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CCB91801BB; Wed, 29 Oct 2025 04:05:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C06DB801BC; Wed, 29 Oct 2025 04:05:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B0FE7801BB
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 04:05:34 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 5B3DC1A07D1
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 08:05:34 +0000 (UTC)
X-FDA: 84050417388.27.3144DB7
Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	by imf12.hostedemail.com (Postfix) with ESMTP id 6E0FC4000A
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 08:05:32 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=POB69esF;
	spf=pass (imf12.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.173 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761725132;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yk4PUhjFL395TmYOv7gltb3HHECw/EBab++L+Zsd2s8=;
	b=ewdwxp+BAwY8zVmNi20px3cLANpNQ6BKPGrZAdzEBQNmDuNuliPwMcPqFb68JHvIF5b6ei
	zjH97Njb+Meowcj7xJDe89gCWH7aybuImsUXpZk5B7oN+B/yZdPMrCqctbZARX4BwFzadJ
	r3kqSObM5ayfa3PqUZNATBbMVko8R2c=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=POB69esF;
	spf=pass (imf12.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.173 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761725132; a=rsa-sha256;
	cv=none;
	b=eLhJ4CGVGxYz76T4gDNXOICBZ49mvPvptcCIa/3C+Kwm3oyxUsjAou8b38mo7ruuBwFLyE
	IHqQYsRfUvJ4diRlEXcWgQdsVi/NRogssebxUw4Iy6t+CPnD2Q2GloSgm9X02g1kKRZLxZ
	sTdXuES4DWFyY0xxKpA3/BSIbsyZnCM=
Message-ID: <8edf2f49-54f6-4604-8d01-42751234bee9@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1761725127;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=yk4PUhjFL395TmYOv7gltb3HHECw/EBab++L+Zsd2s8=;
	b=POB69esFKG9kb3n4mSAV3U7Ka6U9jKsTmiynTZND0fdm2hrV6tVNyeIb094iW12aUZujcS
	ylMz9tnF41HneC7z9bYAyXQrHBjjjpAHrjeEDn+JmZDTUagUtNklDvY/fNbEsXOcB4KJi6
	k9MDji9FBdRnuSToM6Y1FHFq9d1uLPE=
Date: Wed, 29 Oct 2025 16:05:16 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v1 00/26] Eliminate Dying Memory Cgroup
To: Michal Hocko <mhocko@suse.com>
Cc: hannes@cmpxchg.org, hughd@google.com, roman.gushchin@linux.dev,
 shakeel.butt@linux.dev, muchun.song@linux.dev, david@redhat.com,
 lorenzo.stoakes@oracle.com, ziy@nvidia.com, harry.yoo@oracle.com,
 imran.f.khan@oracle.com, kamalesh.babulal@oracle.com,
 axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com,
 akpm@linux-foundation.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 cgroups@vger.kernel.org
References: <cover.1761658310.git.zhengqi.arch@bytedance.com>
 <aQHIDWDx3puT5XZd@tiehlicka>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <aQHIDWDx3puT5XZd@tiehlicka>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: wdsfbz1soz4zxinqjerkrxmijjsju3j7
X-Rspamd-Queue-Id: 6E0FC4000A
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1761725132-805106
X-HE-Meta: U2FsdGVkX18Qv2/k1ajVjHtIlayAELqZyXf2K3fQeWrr2QL1Xt0qlfsY6A5zGJFCVMbAezN7jQIEsQg8CvVJHWgGsc7DIcMmJ7BES3TsTvGb9Ni+gao9Oz1urRVxhckPz78m39dB9xuTuf99pqJArv9hV4wkCslx4uWSOudVdu1pcCKqnfXfsMTvH6jyZJWg/3ekBqt+Ssr5YpN2X2lR+stasOZxtr1sQ/vkcgA1YI/Y4ryD9DCg9m4tQDgr2DbWw+xyxB+XbgYUhbXu1v6hOjPYdqpH4Q0ZuwyejNFKBHv2ocTHadxwnz9ZiD/pOXpdlh7vNcPy04oCugBx5b2iaSXpzoJcChnk/i52z3LPO6V9Xb/l5tcA1CarLOeiXXrZ1yTFfO+C/Hxwdi3cVJbSHeHMfRYYjgQNrGmhsvlrFVmZS/p2DiuYitVE5rlNVLEz10HbdK5Ng8FP3b1XOb7m+vxvAY5TBnL1Cntm+IYWEankWlgJcdvpoy++DQGJoVW+DJh+5uhz+WF7Cftqm87dgSxyiSl/YKcCqkE/6Qxv7Untoc0fa5OhMBO7wEhKr+17UmbWHxt5zQFRpYl+r1LH7/UPdSQBJx4lGfqXycFKg34wiMq084UjnRH1Jn5qCDb0jsi5LpcbbUw+S19WmhkxlC5Qo55SCmNuRRXhD4ww8aGYOFL87FpgbfdiF7FrMEFG0ChIF+VLQcC9e/k/IUZJGYh5kETfHr8XdH7ed+5PBRHgwNxp6MUsHRMOjm0DrO6QF7zPh3Z+HnUAWrJJFIkwpZRoa1/Y6S55y2hxIOkX0h8LYFQR0Y9w6akRp1RY+oYQ76t1J5e5nRKfkJxN7HFctLHXyiKDw/jqSiE/AN8ud53+28fHLDL6UykvZGPsOIJf158ZhhiAJ59BCeXDBY3D/5lsmXcjQ5fu4gjw0pYZb8UxKbp1Nejn8mj3AAXgyR1sYoIwDpjS7nXqWRva25b
 sfLpdoEB
 Eeaeon5lZgv+UDAIMNfMEpnUXPe/LyNTVhnnQEJIy7k1mttMErjlguNNPqjmexyqUPuwj4bIFrTjexLjraE7busDjK5X2z0nVmbSvS3XQPzq7rl9ZNxjMaavemslhH/ZTLXEQRf/h3cbNbUku/sZvQNB+9pgO5lGXbn55/CoxK+Rxe2vt3edWw0PKNNmZgag+zYk5
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Michal,

On 10/29/25 3:53 PM, Michal Hocko wrote:
> On Tue 28-10-25 21:58:13, Qi Zheng wrote:
>> From: Qi Zheng <zhengqi.arch@bytedance.com>
>>
>> Hi all,
>>
>> This series aims to eliminate the problem of dying memory cgroup. It completes
>> the adaptation to the MGLRU scenarios based on the Muchun Song's patchset[1].
> 
> I high level summary and main design decisions should be describe in the
> cover letter.

Got it. Will add it in the next version.

I've pasted the contents of Muchun Song's cover letter below:

```
## Introduction

This patchset is intended to transfer the LRU pages to the object cgroup
without holding a reference to the original memory cgroup in order to
address the issue of the dying memory cgroup. A consensus has already been
reached regarding this approach recently [1].

## Background

The issue of a dying memory cgroup refers to a situation where a memory
cgroup is no longer being used by users, but memory (the metadata
associated with memory cgroups) remains allocated to it. This situation
may potentially result in memory leaks or inefficiencies in memory
reclamation and has persisted as an issue for several years. Any memory
allocation that endures longer than the lifespan (from the users'
perspective) of a memory cgroup can lead to the issue of dying memory
cgroup. We have exerted greater efforts to tackle this problem by
introducing the infrastructure of object cgroup [2].

Presently, numerous types of objects (slab objects, non-slab kernel
allocations, per-CPU objects) are charged to the object cgroup without
holding a reference to the original memory cgroup. The final allocations
for LRU pages (anonymous pages and file pages) are charged at allocation
time and continues to hold a reference to the original memory cgroup
until reclaimed.

File pages are more complex than anonymous pages as they can be shared
among different memory cgroups and may persist beyond the lifespan of
the memory cgroup. The long-term pinning of file pages to memory cgroups
is a widespread issue that causes recurring problems in practical
scenarios [3]. File pages remain unreclaimed for extended periods.
Additionally, they are accessed by successive instances (second, third,
fourth, etc.) of the same job, which is restarted into a new cgroup each
time. As a result, unreclaimable dying memory cgroups accumulate,
leading to memory wastage and significantly reducing the efficiency
of page reclamation.

## Fundamentals

A folio will no longer pin its corresponding memory cgroup. It is necessary
to ensure that the memory cgroup or the lruvec associated with the memory
cgroup is not released when a user obtains a pointer to the memory cgroup
or lruvec returned by folio_memcg() or folio_lruvec(). Users are required
to hold the RCU read lock or acquire a reference to the memory cgroup
associated with the folio to prevent its release if they are not concerned
about the binding stability between the folio and its corresponding memory
cgroup. However, some users of folio_lruvec() (i.e., the lruvec lock)
desire a stable binding between the folio and its corresponding memory
cgroup. An approach is needed to ensure the stability of the binding while
the lruvec lock is held, and to detect the situation of holding the
incorrect lruvec lock when there is a race condition during memory cgroup
reparenting. The following four steps are taken to achieve these goals.

1. The first step  to be taken is to identify all users of both functions
    (folio_memcg() and folio_lruvec()) who are not concerned about binding
    stability and implement appropriate measures (such as holding a RCU read
    lock or temporarily obtaining a reference to the memory cgroup for a
    brief period) to prevent the release of the memory cgroup.

2. Secondly, the following refactoring of folio_lruvec_lock() demonstrates
    how to ensure the binding stability from the user's perspective of
    folio_lruvec().

    struct lruvec *folio_lruvec_lock(struct folio *folio)
    {
            struct lruvec *lruvec;

            rcu_read_lock();
    retry:
            lruvec = folio_lruvec(folio);
            spin_lock(&lruvec->lru_lock);
            if (unlikely(lruvec_memcg(lruvec) != folio_memcg(folio))) {
                    spin_unlock(&lruvec->lru_lock);
                    goto retry;
            }

            return lruvec;
    }

    From the perspective of memory cgroup removal, the entire reparenting
    process (altering the binding relationship between folio and its memory
    cgroup and moving the LRU lists to its parental memory cgroup) should be
    carried out under both the lruvec lock of the memory cgroup being 
removed
    and the lruvec lock of its parent.

3. Thirdly, another lock that requires the same approach is the split-queue
    lock of THP.

4. Finally, transfer the LRU pages to the object cgroup without holding a
    reference to the original memory cgroup.
```

And the details of the adaptation are below:

```
Similar to traditional LRU folios, in order to solve the dying memcg
problem, we also need to reparenting MGLRU folios to the parent memcg when
memcg offline.

However, there are the following challenges:

1. Each lruvec has between MIN_NR_GENS and MAX_NR_GENS generations, the
    number of generations of the parent and child memcg may be different,
    so we cannot simply transfer MGLRU folios in the child memcg to the
    parent memcg as we did for traditional LRU folios.
2. The generation information is stored in folio->flags, but we cannot
    traverse these folios while holding the lru lock, otherwise it may
    cause softlockup.
3. In walk_update_folio(), the gen of folio and corresponding lru size
    may be updated, but the folio is not immediately moved to the
    corresponding lru list. Therefore, there may be folios of different
    generations on an LRU list.
4. In lru_gen_del_folio(), the generation to which the folio belongs is
    found based on the generation information in folio->flags, and the
    corresponding LRU size will be updated. Therefore, we need to update
    the lru size correctly during reparenting, otherwise the lru size may
    be updated incorrectly in lru_gen_del_folio().

Finally, this patch chose a compromise method, which is to splice the lru
list in the child memcg to the lru list of the same generation in the
parent memcg during reparenting. And in order to ensure that the parent
memcg has the same generation, we need to increase the generations in the
parent memcg to the MAX_NR_GENS before reparenting.

Of course, the same generation has different meanings in the parent and
child memcg, this will cause confusion in the hot and cold information of
folios. But other than that, this method is simple enough, the lru size
is correct, and there is no need to consider some concurrency issues (such
as lru_gen_del_folio()).
```

Thanks,
Qi

> 
> Thanks!


