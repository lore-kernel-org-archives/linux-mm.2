Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6EA46CCF9F8
	for <linux-mm@archiver.kernel.org>; Mon,  3 Nov 2025 03:33:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9C5728E001B; Sun,  2 Nov 2025 22:33:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 975D68E0015; Sun,  2 Nov 2025 22:33:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 88B488E001B; Sun,  2 Nov 2025 22:33:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 772C28E0015
	for <linux-mm@kvack.org>; Sun,  2 Nov 2025 22:33:43 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 152224AE9C
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 03:33:43 +0000 (UTC)
X-FDA: 84067876326.20.3AEC743
Received: from out-177.mta1.migadu.com (out-177.mta1.migadu.com [95.215.58.177])
	by imf12.hostedemail.com (Postfix) with ESMTP id 2ADF040009
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 03:33:40 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=f1GN3GoF;
	spf=pass (imf12.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.177 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762140821;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=07ypOvsfQH+I/btG1VSjUxVXQmcWpU4TWlpvVvH8A8s=;
	b=Zksgycxt68Owb80ycOzIpohxIOk10p43+e6/80vSwhXmZj7tW1n64WVYsuZJFOUshY8UMx
	k9jdMAQQedzWPECjzM2e4w4W1fLtHlOZnML2gZztq3SykrshXePyw3qr/hqwMn6Oe05mZM
	AJROaN2Kfz0C38Z4Js3sU1K2ZQqanpw=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=f1GN3GoF;
	spf=pass (imf12.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.177 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762140821; a=rsa-sha256;
	cv=none;
	b=YaMMyRC/hrLvnmaEeFWaJWNXOA8yQQxwFg5wHclvr1tEYXoIY44nSQ9z+7LW5hUrDYRiB8
	yp9CUiLbdFCPMhSvMaoYovfVdQFpKuZWEW86PNqXoFumdBgsAKIYkkkjmxETAe7J4B61LT
	Kr383eYXqZSlQbYjYQH/6KoW5P2yhT0=
Message-ID: <6893294b-41bf-44a1-baae-1bb3a6034777@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1762140818;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=07ypOvsfQH+I/btG1VSjUxVXQmcWpU4TWlpvVvH8A8s=;
	b=f1GN3GoFEkv8j01/V6a0IpuPCpZ44/TmH9s5oyNcHNEU0McpLPw7qgMdJdCN2H1e6dJZAl
	WEw34ysi508mSirjzIDBngFc0Mpsqi+Q6pIeipZU5yExbK4ZPWBnrMusXfYREDpBas2RRB
	p1lzvBuF7cy/FDYh0kyo/Ch+pELHpOY=
Date: Mon, 3 Nov 2025 11:33:08 +0800
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
 <aQHIDWDx3puT5XZd@tiehlicka> <8edf2f49-54f6-4604-8d01-42751234bee9@linux.dev>
 <aQSRBjdhdMR8iD6n@tiehlicka>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <aQSRBjdhdMR8iD6n@tiehlicka>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 2ADF040009
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: 9gkmeha7awffd54ekdet6h9j6hx7hf1i
X-HE-Tag: 1762140820-762357
X-HE-Meta: U2FsdGVkX1+5pHeMI16y21c+B7RIZP6LM7ltOcBSOoZFy/K3y0syi0Zffx4uZLKCp7vTxkssGFN7kDNA64DEfjfAQzG/o8T2xxUigtYHFlN3MDKJwNo+UOEDpa4fuiuk6C+7UsGgOndEo2zTAFY3f3K+w/KFmQGH2U3LwnAfPi+qj/fxigYvsd+pwuUG1FeQ82hOm04iUJHN4urKf19VWqLOpnieLLso6lxKqeO5DSlkCeN9bjA+B1vfZGAE2ncEnK0osK50dbEo+xqqSpqsSkU1+hPGLz0r2gz75vdZU97iiOPsGh/a1p87D8a5A9MCBKVgx5ckUOcBeiFMiQ6gSN3A1yD1lXLVZFiyZa8OXwzmenAfGUacOiG4ev6nTX4P1ZwoZIzWXLvVxgrXyYYyLG1KEaJQPpw7zW6Bh9wfk3VHQ3eFZMH3UBLik/HNiqSwWOqep+G/u2mBcIbc9cQf6lgSakVtTHZzCRTm9VwtQmBUcNFjJtmmNb6CLrR4GpPspKYUZ/vMnqJ+p31yv1b0efNVBl70I3WfWJ8Ea8PsO6yPLPzs/KwXeBISEXOfZ15Z+AsyUusAEH7VGgbkeiVqoJeSJSEExWVDqPM/lSHyqKgcR/Ad6BATCncaes4NAudCp1uySZX0URlLqnLwCuI3C2CtEnnOSfzPy8scGvjEZw5d/1IJ3rreDktlD4Ch0SJ62nX5eMuqz3mpTv1Q9Q3fDvejbX1bCorL/pNph9Z5p7qEDvgqhzSzjkLoBHeCj6TXcnFwAZzpMRarxMneOcbtfHBzF/UbKaXr3PhBnvl2yFRAE00X3jkBSkvA82cbONDZ8DfoEoFO2wN6mW7Bb73liCURDMktzHM47JRPGnMPbAvImggKanz/07+THVsMOacVubMWYbAQitjZE1isd2//lQUfvJJkTHgkua9UQ4NAfraa6fLBePBdlST96zWJinfQYFtVfgeEtOqsPkZkCp7
 qY7SXI5v
 X9C7aRNjBI0hREdhKK8GuBzA9ybSN6S+GeFGWHYVbMCW9Bpsmf3Lq7K0MfaEhiTvtHSKqS0BAutKlkt3w/zJQ2ZVmtLW8urU/uGR9ka1xnT41FQvpjGoO/FWPNK+cp7HZl5z/lsKHpy9r7mErD7PoqiT1qjvNza82RVLmd/L1d9szf/z9KoW5XzHcsyn9rQeLmyZULXqOd+ZQi6CSJZY6Qp5qj6ydy+RIfw3j+JYG3V11LKxZERytChqBEJkl9YHiHkLWfk+CsgmupkTG4q/dbbicKovMCQTvNLfDIea8uj3LjB8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Michal,

On 10/31/25 6:35 PM, Michal Hocko wrote:
> On Wed 29-10-25 16:05:16, Qi Zheng wrote:
>> Hi Michal,
>>
>> On 10/29/25 3:53 PM, Michal Hocko wrote:
>>> On Tue 28-10-25 21:58:13, Qi Zheng wrote:
>>>> From: Qi Zheng <zhengqi.arch@bytedance.com>
>>>>
>>>> Hi all,
>>>>
>>>> This series aims to eliminate the problem of dying memory cgroup. It completes
>>>> the adaptation to the MGLRU scenarios based on the Muchun Song's patchset[1].
>>>
>>> I high level summary and main design decisions should be describe in the
>>> cover letter.
>>
>> Got it. Will add it in the next version.
>>
>> I've pasted the contents of Muchun Song's cover letter below:
>>
>> ```
>> ## Introduction
>>
>> This patchset is intended to transfer the LRU pages to the object cgroup
>> without holding a reference to the original memory cgroup in order to
>> address the issue of the dying memory cgroup. A consensus has already been
>> reached regarding this approach recently [1].
> 
> Could you add those referenced links as well please?

Oh, I missed that.

[1]. https://lore.kernel.org/linux-mm/Z6OkXXYDorPrBvEQ@hm-sls2/

> 
>> ## Background
>>
>> The issue of a dying memory cgroup refers to a situation where a memory
>> cgroup is no longer being used by users, but memory (the metadata
>> associated with memory cgroups) remains allocated to it. This situation
>> may potentially result in memory leaks or inefficiencies in memory
>> reclamation and has persisted as an issue for several years. Any memory
>> allocation that endures longer than the lifespan (from the users'
>> perspective) of a memory cgroup can lead to the issue of dying memory
>> cgroup. We have exerted greater efforts to tackle this problem by
>> introducing the infrastructure of object cgroup [2].

[2]. https://lwn.net/Articles/895431/

>>
>> Presently, numerous types of objects (slab objects, non-slab kernel
>> allocations, per-CPU objects) are charged to the object cgroup without
>> holding a reference to the original memory cgroup. The final allocations
>> for LRU pages (anonymous pages and file pages) are charged at allocation
>> time and continues to hold a reference to the original memory cgroup
>> until reclaimed.
>>
>> File pages are more complex than anonymous pages as they can be shared
>> among different memory cgroups and may persist beyond the lifespan of
>> the memory cgroup. The long-term pinning of file pages to memory cgroups
>> is a widespread issue that causes recurring problems in practical
>> scenarios [3]. File pages remain unreclaimed for extended periods.

[3]. https://github.com/systemd/systemd/pull/36827

>> Additionally, they are accessed by successive instances (second, third,
>> fourth, etc.) of the same job, which is restarted into a new cgroup each
>> time. As a result, unreclaimable dying memory cgroups accumulate,
>> leading to memory wastage and significantly reducing the efficiency
>> of page reclamation.
> 
> Very useful introduction to the problem. Thanks!
> 
>> ## Fundamentals
>>
>> A folio will no longer pin its corresponding memory cgroup. It is necessary
>> to ensure that the memory cgroup or the lruvec associated with the memory
>> cgroup is not released when a user obtains a pointer to the memory cgroup
>> or lruvec returned by folio_memcg() or folio_lruvec(). Users are required
>> to hold the RCU read lock or acquire a reference to the memory cgroup
>> associated with the folio to prevent its release if they are not concerned
>> about the binding stability between the folio and its corresponding memory
>> cgroup. However, some users of folio_lruvec() (i.e., the lruvec lock)
>> desire a stable binding between the folio and its corresponding memory
>> cgroup. An approach is needed to ensure the stability of the binding while
>> the lruvec lock is held, and to detect the situation of holding the
>> incorrect lruvec lock when there is a race condition during memory cgroup
>> reparenting. The following four steps are taken to achieve these goals.
>>
>> 1. The first step  to be taken is to identify all users of both functions
>>     (folio_memcg() and folio_lruvec()) who are not concerned about binding
>>     stability and implement appropriate measures (such as holding a RCU read
>>     lock or temporarily obtaining a reference to the memory cgroup for a
>>     brief period) to prevent the release of the memory cgroup.
>>
>> 2. Secondly, the following refactoring of folio_lruvec_lock() demonstrates
>>     how to ensure the binding stability from the user's perspective of
>>     folio_lruvec().
>>
>>     struct lruvec *folio_lruvec_lock(struct folio *folio)
>>     {
>>             struct lruvec *lruvec;
>>
>>             rcu_read_lock();
>>     retry:
>>             lruvec = folio_lruvec(folio);
>>             spin_lock(&lruvec->lru_lock);
>>             if (unlikely(lruvec_memcg(lruvec) != folio_memcg(folio))) {
>>                     spin_unlock(&lruvec->lru_lock);
>>                     goto retry;
>>             }
>>
>>             return lruvec;
>>     }
>>
>>     From the perspective of memory cgroup removal, the entire reparenting
>>     process (altering the binding relationship between folio and its memory
>>     cgroup and moving the LRU lists to its parental memory cgroup) should be
>>     carried out under both the lruvec lock of the memory cgroup being removed
>>     and the lruvec lock of its parent.
>>
>> 3. Thirdly, another lock that requires the same approach is the split-queue
>>     lock of THP.
>>
>> 4. Finally, transfer the LRU pages to the object cgroup without holding a
>>     reference to the original memory cgroup.
>> ```
>>
>> And the details of the adaptation are below:
>>
>> ```
>> Similar to traditional LRU folios, in order to solve the dying memcg
>> problem, we also need to reparenting MGLRU folios to the parent memcg when
>> memcg offline.
>>
>> However, there are the following challenges:
>>
>> 1. Each lruvec has between MIN_NR_GENS and MAX_NR_GENS generations, the
>>     number of generations of the parent and child memcg may be different,
>>     so we cannot simply transfer MGLRU folios in the child memcg to the
>>     parent memcg as we did for traditional LRU folios.
>> 2. The generation information is stored in folio->flags, but we cannot
>>     traverse these folios while holding the lru lock, otherwise it may
>>     cause softlockup.
>> 3. In walk_update_folio(), the gen of folio and corresponding lru size
>>     may be updated, but the folio is not immediately moved to the
>>     corresponding lru list. Therefore, there may be folios of different
>>     generations on an LRU list.
>> 4. In lru_gen_del_folio(), the generation to which the folio belongs is
>>     found based on the generation information in folio->flags, and the
>>     corresponding LRU size will be updated. Therefore, we need to update
>>     the lru size correctly during reparenting, otherwise the lru size may
>>     be updated incorrectly in lru_gen_del_folio().
>>
>> Finally, this patch chose a compromise method, which is to splice the lru
>> list in the child memcg to the lru list of the same generation in the
>> parent memcg during reparenting. And in order to ensure that the parent
>> memcg has the same generation, we need to increase the generations in the
>> parent memcg to the MAX_NR_GENS before reparenting.
>>
>> Of course, the same generation has different meanings in the parent and
>> child memcg, this will cause confusion in the hot and cold information of
>> folios. But other than that, this method is simple enough, the lru size
>> is correct, and there is no need to consider some concurrency issues (such
>> as lru_gen_del_folio()).
>> ```
> 
> Thanks you this is very useful.
> 
> A high level overview on how the patch series (of this size) would be
> appreaciate as well.

OK. Will add this to the cover letter in the next version.

Thanks,
Qi




