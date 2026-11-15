Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DABDC606A330
	for <linux-mm@archiver.kernel.org>; Sun, 15 Nov 2026 22:12:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=2dU+DbgF
Received: by kanga.kvack.org (Postfix)
	id D62BF6B05B0; Sun, 15 Nov 2026 17:12:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D3B136B05B3; Sun, 15 Nov 2026 17:12:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C506F6B05BA; Sun, 15 Nov 2026 17:12:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8F2066B05B0
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 17:12:10 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 126288086E
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 22:12:10 +0000 (UTC)
X-FDA: 85438752420.07.973F3DF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 400311C0008
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 22:12:08 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=2dU+DbgF;
	dmarc=none;
	spf=pass (imf18.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794780728;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=q9s42YVPhc56VTV+G1TekC9EyggoNH/5JmNGm6Xx0OY=;
	b=4nzP4bejRBHfWGTkPRpNs1HZjqXOUw9J7bvHjC43dYbO8PGA3D7o5lhQWMGSeXecqjCgBF
	VVaNeq1wyrY1mLWs5ilUZPAKBemb2avASMVlRJVmEOarfz5bQ7TuXyTKVOyeqzogBG9vSB
	2Ac3kaUfKeMpQd2WjlQSVK90idrGvE4=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=2dU+DbgF;
	dmarc=none;
	spf=pass (imf18.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794780728;
	b=5tjIAcNz3+4IG4350Ar3eWAVymk/oHUxh7LVj9j+WD1DM1/KPyaFO4MDHOy+MREQugXSxM
	Yaw3ZkeWtLxeScu/xLvtR0yje3eQzOVrIGJO8vs/ceA0YBKQDXPDk/OTSnzPkMAZ0PMQlA
	mzpz7UCXGCIEjmF9zPYXli0D/z0tS7g=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 71CEE4176B;
	Sun, 15 Nov 2026 22:12:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D80C81F000C4;
	Sun, 15 Nov 2026 22:12:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794780727;
	bh=q9s42YVPhc56VTV+G1TekC9EyggoNH/5JmNGm6Xx0OY=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=2dU+DbgFDrqSj3PWmmULOFhMRJrMipQby1pDwXNQGxLi46AXNwWZX7utTYV4vHXMw
	 OuPTqGy1iRd0KdBcAa+7e2q56eUOyyVc+qL8yfUS0ZDGXQiZX1nqa8ER3jfu0eQFvY
	 gnkUjz6mfockveWho3dsBBhBNdBl3oqMsZUPEw20=
Date: Sun, 15 Nov 2026 14:12:06 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Yingjie Wang <x-professor@outlook.com>
Cc: Manfred Spraul <manfred@colorfullife.com>, Alexey Gladkov
 <legion@kernel.org>, "Eric W . Biederman" <ebiederm@xmission.com>, Vasily
 Averin <vasily.averin@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>,
 Shakeel Butt <shakeel.butt@linux.dev>, Michal =?ISO-8859-1?Q?Koutn=FD?=
 <mkoutny@suse.com>, Michal Hocko <mhocko@suse.com>, Alejandro Colomar
 <alx@kernel.org>, "linux-kernel@vger.kernel.org"
 <linux-kernel@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
 "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>,
 "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>,
 "linux-man@vger.kernel.org" <linux-man@vger.kernel.org>,
 "linux-hardening@vger.kernel.org" <linux-hardening@vger.kernel.org>,
 Davidlohr Bueso <dave@stgolabs.net>
Subject: Re: [PATCH v5 0/3] ipc/sem: account dynamic sops arrays and
 validate SEMOPM
Message-Id: <20261115141206.920bdc8c5a84073712bb5c3b@linux-foundation.org>
In-Reply-To: <cover.1793250194.git.x-professor@outlook.com>
References: <cover.1793250194.git.x-professor@outlook.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 400311C0008
X-Spam-Status: No, score=-12.5 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,NICE_REPLY_A,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: 4imxxwqhjwzwskbwss9w7gmjfnbc73it
X-HE-Tag: 1794780728-921407
X-HE-Meta: U2FsdGVkX19t+WAWmgRD0QWx6f3llubBHVih7BuxEefL+oxZb3uJl8x9sGYChciB2ReHH5u7i4DweAFSa/dpQWNUmWpigsh7QhATfEyn7Mz+mXKV8KzDbUvMWdgPof1qxTr1LeL7OXTrfyt9gsAHgN4zcPivZVLPT1mKZmWG9eWUOn4Fl9Y2gzr+HX52F1YmpCUvxpGBb2Xhf+d0DioedS0Y1sxFhKUvWRNkD9NJr99OoXdrHTxgOhQ48W6ZeI4xayMfc0zLu/QBOFpW0IfBmX9lqIv1nlQkaaN1VrWJobXLRc0Jcp4o2OwL31GF6gxbte7GqqXKef7yI8gLAFckHnbVs+bKB8xYP8zUHPvjb+focYA3Ik1bVGJwObuxBTjUjOCtQaCgoZGJhDaJqaJ9YtQvRd+ZSEWGnHP0vQTtp1QhOmJ0L4A7v3i69iVVBd0fiMvqXXJvGlT8/2bwEtzwPlhBlXVol00ddOyTn8X4tjisUC2oOQBP0Igj+950gjPC1r6y8UYjW1KPmdmZnC9ERFR6wp1sIVMJhRQ2u+BXpKRca/Z4PToImcbJeedshbpsb3dcawg6X1fKJD6JY1PyhmovF3pS1YrgnTA903eneBeTf4UPQg8tmfNnXu/d86ELKwPhJFKHZyc9UfEPkJ8G8/EcDLdzi4/nVIt9dhN5evipNW3rRr9DGzlh/jT+YMD3CEEINhGzCnIkfno9G/8t8gQ14A/26U7+VtTxmxGf+5WhvJ92H2POgFW4WQne3vGw36CO5Rhr8qfXzoo/pOGM+vcR3yLM8AXHBeysm7RCzTvMqmZs7nb+YQWoOUvZY1abeb7NWgSlYLkBHPLp4GqXn/c//GUuG3Thj8Yi6nsKfnc2DLjr1rP7UxUsurjX7UivUr3IWJiMueOT25kFH4XYJcCJzMWVFBD+5gxIZOKQQTnAkjJoszp947LjnsFtWjnOO9LkvrHgVt5dCk/k3kN
 8EEmZOmw
 /LZ7ONKH+7YNihKwUaRp4pW8Kxw3l+1CfkvL6GSBtk21FpT5qR1dfjK/9ZNUah/ryKk3nchHBffcQ7qqCZwkmUVYKbf+ixLOOgkQKXbQKitu7TNFM1BfmDukHPGLqXsIBbqMcydpMhTxCnU9K8d6tGBaLRlvjw1Kbf+9EVrRvR2RLEjy17qwCSIfOc0VKvJkmSX/yuONtbmgsf5GacGeZqRniIa93TC+AMrLdoa5E2j1aCL8kSDv9LDHMxJyZl26TOPXz736uUQ1a9sgp94tF/ksQEMU4sqEWPeubXaB/4wT+qpXSpck74x0mkH8V4/2shsfXQXIoNuKre6Vd1YAA4j+48g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, 29 Oct 2026 05:03:24 +0000 Yingjie Wang <x-professor@outlook.com> wrote:

> Shakeel, thanks for the suggestion.

Thanks.  Shakeel, please review [1/3]?

> Patch 1 now uses GFP_KERNEL_ACCOUNT for every dynamically allocated sops
> array. The first 64 operations still use the existing stack buffer. The
> fixed 1000-operation exemption and its conditional allocation flags have
> been removed.
> 
> I compared this version with v4 in a 4-vCPU KVM guest. The benchmark process
> was pinned to one vCPU. Each number is the median of 21 samples from three
> fresh boots of each kernel. In a leaf memory cgroup, the changes were:
> 
>                                       65       500      1000
>   successful semop()                   +3.2%     +3.2%     +2.3%
>   allocation-focused invalid semid     +5.6%     +9.1%    +11.9%
> 
> The invalid-sem-id case allocates and copies the operation array before
> returning EINVAL, so it emphasizes allocation overhead. The 64-operation
> stack controls changed by 0.9% and 0.5%, respectively. The already-accounted
> 1001-operation controls changed by 1.0% and -0.2%. Successful calls in the
> root cgroup changed by at most 2.3%, including the controls.
> 
> The sysctl handler parses writes into a temporary array while holding a
> per-IPC-namespace mutex. The mutex covers the snapshot, validation, and
> publication, so a failed write leaves the live settings unchanged and a
> partial write cannot restore fields from an older snapshot. The snapshot and
> publication use READ_ONCE() and WRITE_ONCE(), and reads continue through
> proc_dointvec(). The unused sem_check_semmni() helper is also removed.
> 
> The UAPI warning about physical fragmentation is obsolete now that the
> operation array uses kvmalloc(). The header describes SEMOPM as the
> compiled-in default and retains the uniform <= INT_MAX range comment.
> 
> Patches 2 and 3 are unchanged from v4 and retain Manfred's Reviewed-by tags.
> The series is based on 7be4bc52fd9e ("Merge tag 'driver-core-7.4-rc1' of
> git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/driver-core").

Thing is, the above is largely about what-changed-since-last-time. 
It's useful info, but it's short-term development-time stuff.  Most of
this is inappropriate for the long-term kernel record.

I had LLM suggest a replacement [0/N].  wdyt?

: An IPC namespace owner can raise SEMOPM and make semop() allocate a large
: operation array.  A blocked call retains the array.  These allocations are
: currently uncharged to the caller's memory cgroup, so repeated calls can
: consume host memory beyond a container's limit.  In one test, a call
: retained 60,936,448 bytes while a 32 MiB cgroup recorded less than 1 MiB. 
: Sixteen concurrent calls retained 100,860,416 bytes while the cgroup
: recorded about 1.3 MiB.
: 
: The SEMOPM sysctl also accepts negative values.  Because the operation
: count is unsigned, SEMOPM=-1 becomes an effective limit of UINT_MAX. 
: Separately, a rejected kernel.sem write can leave earlier fields changed:
: an invalid SEMMNI can return ERANGE after setting SEMOPM to zero, causing
: subsequent nonempty semop() calls in that IPC namespace to fail with
: E2BIG.
: 
: Patch 1 charges dynamically allocated operation arrays in the regular
: semop() path to the caller's memory cgroup.  Patch 2 parses and validates
: kernel.sem writes before publishing them and serializes writers within
: each IPC namespace.  Patch 3 removes the obsolete warning that SEMOPM
: above 1000 risks physical memory fragmentation; the operation array uses
: kvmalloc().
: 
: Accounting contains the large-array case when the caller's memory cgroup
: has an effective limit.  The series does not impose a maximum on positive
: SEMOPM values, so a root or unlimited cgroup can still request large
: allocations.
: 
: Validation included x86-64 and i386 builds, initial and user-owned IPC
: namespace checks, concurrent sysctl writes, operation-count boundaries,
: and allocation cleanup on success and error paths.  In a limited memory
: cgroup, accounting increased median successful-call time by 2.3% to 3.2%
: for 65, 500 and 1000 operations; the allocation-focused invalid semaphore
: ID case increased by 5.6% to 11.9%.

Also, [1/3] and [2/3] are cc:stable but include no clear description of
why we're recommending backports.  Backportable patches should clearly
state the userspace-visible runtime effects of the bug which is being
fixed.  Our downstream people (-stable maintainers and further
downstream) are swamped with bugfixes, so let's help them out!

So for [1/3] I inserted this statement:

: A caller can raise SEMOPM and keep large, uncharged operation arrays alive
: in blocked semop() calls.  Repeating this from a memory-limited cgroup can
: exhaust host memory outside that cgroup, causing reclaim, stalls, or OOM
: kills of unrelated processes.  Charging the arrays lets an effective memcg
: limit contain that memory use.

and for [2/3] I inserted

: A negative SEMOPM becomes a large unsigned limit in semop(), allowing
: operation counts that the configured limit should reject.  Separately, a
: kernel.sem write can return ERANGE for an invalid SEMMNI while leaving
: earlier fields changed; if it leaves SEMOPM at zero, subsequent nonempty
: semop() calls in that IPC namespace fail with E2BIG.  Validate the whole
: write before changing the live settings.

Please check these also.


