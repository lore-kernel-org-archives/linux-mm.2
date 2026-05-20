Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8AB57CD4F3C
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 13:09:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EF9A96B008C; Wed, 20 May 2026 09:09:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EA9F96B0092; Wed, 20 May 2026 09:09:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D99336B0095; Wed, 20 May 2026 09:09:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C83146B008C
	for <linux-mm@kvack.org>; Wed, 20 May 2026 09:09:24 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 8FAAB1A030B
	for <linux-mm@kvack.org>; Wed, 20 May 2026 13:09:24 +0000 (UTC)
X-FDA: 84787829448.27.81220E5
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	by imf27.hostedemail.com (Postfix) with ESMTP id EA02F40005
	for <linux-mm@kvack.org>; Wed, 20 May 2026 13:09:22 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=YpHeu5XE;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=tPIj50Bo;
	spf=pass (imf27.hostedemail.com: domain of bigeasy@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=bigeasy@linutronix.de;
	dmarc=pass (policy=none) header.from=linutronix.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779282563;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cya+tMoFymUiiUMO949m9cNeRyJ+/OxofgEYmhbqfEQ=;
	b=6hzz5SNTYMt5rzlhUOJLbc3sjC+ClExlYFq90kbyG/Kp8NDxQ/fjrT/gejMDilYW3vVN9D
	RWFtQvsr0GSL95YQYgdPuT+TZb4XcwC7vYGOoH//f97ixxyYe1SJznBRmf/1hCAj2dlTnY
	rAkciN3bTfPEOrwGhOJwfFUvZKfQi7w=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=YpHeu5XE;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=tPIj50Bo;
	spf=pass (imf27.hostedemail.com: domain of bigeasy@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=bigeasy@linutronix.de;
	dmarc=pass (policy=none) header.from=linutronix.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779282563; a=rsa-sha256;
	cv=none;
	b=f8cm3nbl1++beGe1wdA+3kY7TiAOHy73cOr2KnYu53t1nw/J4IVHQR8JSxRgrIKZ711AUh
	gr4kWhG1CTIKFeHSKWG/nVTzRZjpB2Xk0nUpsAMjzXFRyelrPAMNxZNelWG9H7n+/DDNrU
	X6Wzj/unP39XvR3COc01f+nRlJu0Ix0=
Date: Wed, 20 May 2026 15:09:03 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1779282545;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=cya+tMoFymUiiUMO949m9cNeRyJ+/OxofgEYmhbqfEQ=;
	b=YpHeu5XEac5sy2OB4xvanyH4HNjNtxA1u+7eO1k07GpkSy5GwFoA8WOl7v1VZtofZxZKPo
	zDP42xAZanOGd53qKghSjYEL/H/8HnqzAYH86BFu8Z/8g/XnyzJGNtNmENMgHA6qmuGps2
	1xIErcW/Tm78/NQcQbyVbOrawlYLY+Ao0+tXu6KxDCxjP78fw7Ifl7RtK2EseOIEzlNbby
	v3AGB5p4tYCLpC6huA6timfuuHLoV4W8c8uRI4xFJlz4cIZrTyUn02t/naw700GqV2LIHS
	BpJfp0KHCEVIT+R15se35cGI2UDN9pWTdE/FVi/WyVsZ0ZoysyjfmHKedmkzsg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1779282545;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=cya+tMoFymUiiUMO949m9cNeRyJ+/OxofgEYmhbqfEQ=;
	b=tPIj50Bor+vehmmu8fzN+AwNvSd1OiMEbGVBNTXebC32AR0UKdYTKpeWVm2OcmZvw/0FR9
	cRDAia8bpc4kGjBQ==
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Leonardo Bras <leobras.c@gmail.com>
Cc: Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>,
	Boqun Feng <boqun@kernel.org>, Waiman Long <longman@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	Harry Yoo <harry@kernel.org>, Hao Li <hao.li@linux.dev>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>,
	Barry Song <baohua@kernel.org>,
	Youngjun Park <youngjun.park@lge.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Randy Dunlap <rdunlap@infradead.org>,
	Thomas Gleixner <tglx@kernel.org>,
	Feng Tang <feng.tang@linux.alibaba.com>,
	Dapeng Mi <dapeng1.mi@linux.intel.com>, Kees Cook <kees@kernel.org>,
	Marco Elver <elver@google.com>, Jakub Kicinski <kuba@kernel.org>,
	Li RongQing <lirongqing@baidu.com>,
	Eric Biggers <ebiggers@kernel.org>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>,
	Miguel Ojeda <ojeda@kernel.org>, Nicolas Schier <nsc@kernel.org>,
	Thomas =?utf-8?Q?Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>,
	Douglas Anderson <dianders@chromium.org>,
	Gary Guo <gary@garyguo.net>, Christian Brauner <brauner@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Masahiro Yamada <masahiroy@kernel.org>, Coiby Xu <coxu@redhat.com>,
	Frederic Weisbecker <frederic@kernel.org>,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, linux-rt-devel@lists.linux.dev
Subject: Re: [PATCH v4 0/4] Introduce Per-CPU Work helpers (was QPW)
Message-ID: <20260520130903.Ebsd4aUa@linutronix.de>
References: <20260519012754.240804-1-leobras.c@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260519012754.240804-1-leobras.c@gmail.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: EA02F40005
X-Rspamd-Server: rspam06
X-Stat-Signature: stdh1j9gidsc1bqtfjtfci1u58s8jcc9
X-HE-Tag: 1779282562-587802
X-HE-Meta: U2FsdGVkX1/lQXXfgzXApEZdEz+dMt+8n2G1Ib51UiqN5ZOCl7RVFJHrmwzErATL5b+QdWTeTIw7/pAckBosveeSfd1G2LqixIKF0KYN4aHoxpU3e0n7ShFm8JZCjJ7g6oOBId++gkRKGMJ4vrL3A9avwA5bNVykAqGkS7/RKjpVLDA0DqUdlAoGJqgRNcRFPp1fBdo35cWO5wbpTPBVgYoLaJG81R7MHz7VNSzG882CLQZLsC7521kWY3LGp2vQApeAHCkSQ41WN26FpvAl+BuMwcvQ111DcwM5uHShTInEuByRjU4fKDV+vAE1h5j/BYSXrCDrNi3EsWkOc9ZfziVf45a34Yq0TqQG6J4/4hI4VBqNp2IVXos6TfOWMzKp74W6IIgq2nv9/DWwgbrZG4fhfed8B0r0PrBAcMkopiA4YJLeFlLoTuGNWiqv3UPrp9POfkYDtccp/ZEBrAuDYD6uGz7ueHFruca7QPMpnS29ARbaE+uqNKTAudfPPfhc0ejGzVDXiLWP2I7LQbojjXl5eqhryqxVyIuA/EjkLZ9WZyKX2pD55GLwMAlaHO6Z3C00DabG3pCJRroxEN6j3X7gfJ88i9HVOrtZ4TRexxS2bCJCAZdxNAB41fELXJGL8vMC17Kbr6DWALCGOzSwnvL00B73qExd/ny6+oNXiVKdzRraOghOAPcm1jwCuETrPaYKS4ihVjuyMZAsELk3V7RGi35qpz4M+qJlCxaI7mkhyPN9dKfd9gXdLCFSlrCjy+WN1AHn1OTUsvtZTHhtRGzLxlLPeIQCFZQRxtavbuyHmGCSpOS4ku51G7AKEdjMaF5kh3l3TujTZbGV70OisQ0J9Csu523YMzzUqaz7jEGAsfoaKVM33v4izAwQI9P4wr/gULuFjDt5ZHTXfBXxcp4ZhXC9qYblTH4/7kfJ8APlXTbTIcmT1Aypt9SZEYqLhmY7wh9q+sneL17PmhF
 6QO2vhiH
 AMHjCAq1bSryod0LnggTr0GPZF/sYjxRT3rFJFyKZjCzy/eoI6t1fEM7YLjTitf2/6ntkqZPE2v3g/Vkg8DVrxAe68zgVlq63VfTHh8XTNrbPu+vDdsGkJ7UV4OjPARxm66I/iC9r6gpjBQkHpCXlrom/Cc4aTB4ialtiK79QuGvLeJO7CFq8KdO44Zq8jD9pboOiY9KLLDU3K94tQSaY0oMAaSn3XojxXUXvkA8F8+CZdc5LrF02L0KtcA5zADbYAsiV6jxKQug/sW4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-05-18 22:27:46 [-0300], Leonardo Bras wrote:
> The problem:
> Some places in the kernel implement a parallel programming strategy
> consisting on local_locks() for most of the work, and some rare remote
> operations are scheduled on target cpu. This keeps cache bouncing low since
> cacheline tends to be mostly local, and avoids the cost of locks in non-RT
> kernels, even though the very few remote operations will be expensive due
> to scheduling overhead.
> 
> On the other hand, for RT workloads this can represent a problem: getting
> an important workload scheduled out to deal with remote requests is
> sure to introduce unexpected deadline misses.
> 
> The idea:
> Currently with PREEMPT_RT=y, local_locks() become per-cpu spinlocks.
It does not become a _spin_lock because it does not spin. It sleeps.

> In this case, instead of scheduling work on a remote cpu, it should
> be safe to grab that remote cpu's per-cpu spinlock and run the required
> work locally. That major cost, which is un/locking in every local function,
> already happens in PREEMPT_RT.

We did have this before but only in the RT tree. It was a bit messy from
the naming because it started with local_ but then it was a remote CPU.
The main issue was the different code path which led to a few deadlocks
back then.
By the time local_lock_t went upstream, the cross-CPU locking was
removed. As far as I remember, the cross-CPU user which did schedule
work on a remote CPU and annoyed NOHZ folks were replaced.

> Also, there is no need to worry about extra cache bouncing:
> The cacheline invalidation already happens due to schedule_work_on().
> 
> This will avoid schedule_work_on(), and thus avoid scheduling-out an
> RT workload.
> 
> Proposed solution:
> A new interface called PerCPU Work (PW), which should replace
> Work Queue in the above mentioned use case.
> 
> If CONFIG_PWLOCKS=n this interfaces just wraps the current
> local_locks + WorkQueue behavior, so no expected change in runtime.
> 
> If CONFIG_PWLOCKS=y, and kernel boot option pwlocks=1,
> pw_queue_on(cpu,...) will lock that cpu's per-cpu structure
> and perform work on it locally. 
> 
Sebastian

