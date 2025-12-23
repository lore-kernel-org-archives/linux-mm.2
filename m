Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D0754E748FC
	for <linux-mm@archiver.kernel.org>; Tue, 23 Dec 2025 23:21:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EF7C66B0005; Tue, 23 Dec 2025 18:20:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EA5906B0089; Tue, 23 Dec 2025 18:20:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DB20A6B008A; Tue, 23 Dec 2025 18:20:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C81CC6B0005
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 18:20:59 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 3B1B91A054F
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 23:20:59 +0000 (UTC)
X-FDA: 84252308238.27.EC9453B
Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	by imf18.hostedemail.com (Postfix) with ESMTP id 4809A1C0009
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 23:20:57 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=CMjc0KoH;
	spf=pass (imf18.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.171 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766532057;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=W/Zjblw4vDP1sJ8bKC4Gyh93B2H/argQe0LsM3CQG9A=;
	b=W4eSxAu8/zAI/BLzQRfH+DsZy5GE93M1v6hyBwZvc8z7bADvOX1a1mPNJgO61TazueR0KS
	m6TekPvLXOFgDuauUHG3kIV65iiVZAHLZWVw9ZCj4fwZbtX4uByPTg3RlIuCT2NBZcdcGM
	q52f74gUdjhj7ISF+Ot6/T6SolmyDa4=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=CMjc0KoH;
	spf=pass (imf18.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.171 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766532057; a=rsa-sha256;
	cv=none;
	b=3DyXV0MuLfpC35Ask+7u+PHfLqQ9Txe8c9GZLZ8dJfu6d9/3aqrrk3YJD0BII6gSDpUX9U
	/Il7j295YK2XObWg8wHL2OFbZ64GCQl7wjQSyeMMtE/gfrP1oI4igeZnOJMCrHMkBGRvYl
	ysZtYTWybnT/i/PN3qE3H4e8yF7i2Ws=
Date: Tue, 23 Dec 2025 15:20:47 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1766532054;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=W/Zjblw4vDP1sJ8bKC4Gyh93B2H/argQe0LsM3CQG9A=;
	b=CMjc0KoHfI06EwO7RnCzuv4OjMj2kPeXra5QwjJ3hvLUOZQCHA9rKdhFK1wvt2MWk3DdGI
	1TMJdVwSItsdJWW/IYv08XCttBViaz3lrkp9mWUmcd1n5Gfid/4DEGfevMQfdWkIjc9Jmo
	zxRR7xkm0WUkRQIqwQ+HMj5kvG5IpBw=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: Qi Zheng <qi.zheng@linux.dev>, hannes@cmpxchg.org, hughd@google.com, 
	mhocko@suse.com, roman.gushchin@linux.dev, muchun.song@linux.dev, 
	david@kernel.org, lorenzo.stoakes@oracle.com, ziy@nvidia.com, harry.yoo@oracle.com, 
	imran.f.khan@oracle.com, kamalesh.babulal@oracle.com, axelrasmussen@google.com, 
	yuanchu@google.com, weixugc@google.com, chenridong@huaweicloud.com, mkoutny@suse.com, 
	akpm@linux-foundation.org, hamzamahfooz@linux.microsoft.com, apais@linux.microsoft.com, 
	lance.yang@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	cgroups@vger.kernel.org, Qi Zheng <zhengqi.arch@bytedance.com>
Subject: Re: [PATCH v2 00/28] Eliminate Dying Memory Cgroup
Message-ID: <vsr4khfsp4unk73a75ky7i35nzdjqsbodyeeuxipu3arormfjr@awi2srdwawfu>
References: <cover.1765956025.git.zhengqi.arch@bytedance.com>
 <5dsb6q2r4xsi24kk5gcnckljuvgvvp6nwifwvc4wuho5hsifeg@5ukg2dq6ini5>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5dsb6q2r4xsi24kk5gcnckljuvgvvp6nwifwvc4wuho5hsifeg@5ukg2dq6ini5>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam02
X-Stat-Signature: qib3ceg5ezb9jbyhgqswdji9jm9e6yr1
X-Rspam-User: 
X-Rspamd-Queue-Id: 4809A1C0009
X-HE-Tag: 1766532057-956177
X-HE-Meta: U2FsdGVkX1/Sy408QL+WyxNPKUgnXpmVoT6ZWhKc9EGhnse9UpWjLzJyPQ8H7TqDCsVjW5+MCzgWZXVZensvBlQ+5/QarA55x97FPk57fxvfouOR21CQk1AW2t+f2vmuWj4mclWc3UCxC7ZScXiV5FG0ZN97whSKPleLaPoKY4+Cu6CGZwaRzfqlEm2faRhklLBipM8Ee3XRt5eMiV+A19eub6RiA/+qfgnytiX2t2JGX+nqfUUY/3oOlXhssiqi067urwQEAcNQXObh/u0PPQWdXJvQj7YDPxFczD1Lc13SeL2bQE1QvCqIWfvavqnv2iSX9zqT8yoA0yXYuBslblJbYk3oMzwibWZ4Rr/Fa0/dA0Ow0Kxipo932I5+ummj8BRKSfEIV2qTRmsZ5rtiXx53P6E45HKfz40He6gbfADgbY3zhiEzNiW7LLB4I4cPqSoVCZsLVdptHoA/yKSsx5Xf0ZBsQJcgyXzHlzs6W6RY1xXfVXL+2Aqmfkk7NTGtrtmFHNmuhLW4OP3xYCtzfT/TpPvrdbLHgVATh4MNQqGxMBpf/SR5USkvEZG8CEJIYO88DgI/VQ9ba50mmXcgv8Bqu+2fzEKfTtwxvXRTmrLXC5q9HYlrZT/pIZ4JWwLDHGYhFI6Kl6mJP0rdVU+lUKXktf9IcZ83YmIJ3gB1DgeBM5bmkcneyJI5HCWoIxCnjRXIQn3u2P+r5PiDazrMSMagPqrkMFoU/XS6sYU+muUiKh1HievbYz5jtSC6v1YX5YuuGLnIAhHmghUu/+j4XNDO2lvKBHrIfbZYnTQ17bONlTMtksLUoSTl+CoD3aXE5MnmL/tkESJ0DzM2CaMVUEzyPYq5+HPm59BfBZeqWVIB7XgtHYlyuTxZy24hAbznimIO9bvJavK28Me7xyrPFzL1sYUod4cSu4ij8/7K/n90eR2+4reuIb6CNHcARB57b7w4UIOYH/vs4vYXMA6
 SCnS6GkR
 inOXQ+DUs1UZlt+ZTDIzzcu81ZRXeYHEWKoQNE5YwK9G6i3Jx8CATQmEtlx8qzJQ5MZ9sjvu3zjkdpncqICZAbzeqiApJz0JqULwciLXXeBGTygBpomLCu4PGa3OJzpj924RWW1CFu9r23uON3B2D7iKrLwnnQbaYsCvh05JWna6SawZMqOs21po+skdGw9Ix6H8qeLFZHGL6LCQsQSM3XJxgKg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Dec 23, 2025 at 08:04:50PM +0000, Yosry Ahmed wrote:
[...]
> 
> I think there might be a problem with non-hierarchical stats on cgroup
> v1, I brought it up previously [*]. I am not sure if this was addressed
> but I couldn't immediately find anything.

Sigh, the curse of memcg-v1. Let's see what we can do to not break v1.

> 
> In short, if memory is charged to a dying cgroup 

Not sure why stats updates for dying cgroup is related. Isn't it simply
stat increase at the child memcg and then stat decrease at the parent
memcg would possibly show negative stat_local of the parent.

> at the time of
> reparenting, when the memory gets uncharged the stats updates will occur
> at the parent. This will update both hierarchical and non-hierarchical
> stats of the parent, which would corrupt the parent's non-hierarchical
> stats (because those counters were never incremented when the memory was
> charged).
> 
> I didn't track down which stats are affected by this, but off the top of
> my head I think all stats tracking anon, file, etc.

Let's start with what specific stats might be effected. First the stats
which are monotonically increasing should be fine, like
WORKINGSET_REFAULT_[ANON|FILE], PGPG[IN|OUT], PG[MAJ]FAULT.

So, the following ones are the interesting ones:

NR_FILE_PAGES, NR_ANON_MAPPED, NR_ANON_THPS, NR_SHMEM, NR_FILE_MAPPED,
NR_FILE_DIRTY, NR_WRITEBACK, MEMCG_SWAP, NR_SWAPCACHE.

> 
> The obvious solution is to flush and reparent the stats of a dying memcg
> during reparenting,

Again not sure how flushing will help here and what do you mean by
'reparent the stats'? Do you mean something like:

parent->vmstats->state_local += child->vmstats->state_local;

Hmm this seems fine and I think it should work.

> but I don't think this entirely fixes the problem
> because the dying memcg stats can still be updated after its reparenting
> (e.g. if a ref to the memcg has been held since before reparenting).

How can dying memcg stats can still be updated after reparenting? The
stats which we care about are the anon & file memory and this series is
reparenting them, so dying memcg will not see stats updates unless there
is a concurrent update happening and I think it is very easy to avoid
such situation by putting a grace period between reparenting the
file/anon folios and reparenting dying chils'd stats_local. Am I missing
something?


