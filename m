Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E5BDCA0EF8
	for <linux-mm@archiver.kernel.org>; Wed, 20 Aug 2025 21:06:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 01AB48E002B; Wed, 20 Aug 2025 17:06:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F34DE8E0010; Wed, 20 Aug 2025 17:06:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E71A28E002B; Wed, 20 Aug 2025 17:06:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D44D28E0010
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 17:06:15 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 8E1AF1D9D1D
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 21:06:15 +0000 (UTC)
X-FDA: 83798368710.25.8EC042F
Received: from out-188.mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	by imf18.hostedemail.com (Postfix) with ESMTP id 1545E1C0007
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 21:06:11 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=nv9ys9uW;
	spf=pass (imf18.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.188 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755723973;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=x5nnquroIbMQvlMv47A2Web6GvDOkaVsT4QY8ArCPIE=;
	b=o0TZd3o5FKHsCw+5Sz8zB/RFudMI9ZP/ZSb+9UIY8l7n5lOMHJpgswj6gAjJkFQfzJYtuS
	jYRWkkCG+pj+8YVIc7Ftx/JHt6vQfg0apSrkMft2mQ1yGkpRflkcfZkdRrG6JKSLfbmpx3
	07ehBI43rqynaGbRZ83+Xa4a1ES1hcI=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=nv9ys9uW;
	spf=pass (imf18.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.188 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755723973; a=rsa-sha256;
	cv=none;
	b=NUVhl8Yjg06tZh1JOyxTBgYVGI/bnLLx4fYg9fxUaD2nIHG7wDLrSvfZvxHd56MynleWlK
	QyxU2dQoVrev1GA0h4Vr9Zk0nypJ4ACA0cx1474Lo9Phcg4GlHJpjCoq9vZ3d0N/ggYurW
	vcf8o2FZ0AcKVqnkVxo0G/gE8pJpLvo=
Date: Wed, 20 Aug 2025 14:06:03 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1755723968;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=x5nnquroIbMQvlMv47A2Web6GvDOkaVsT4QY8ArCPIE=;
	b=nv9ys9uWgQm2a+GMpXf6T75wGLjEAhLKwr7XgWO7MIB9CWfN2fodejGugNNSgz1I3dXDqN
	9TrqWVh/wJbZXqa1yhxEY4vptm/oADUqgvnIhd+rwaEd0Vt/ADPr3axKZYb/M8MmIwK9OK
	tQ9kU52NGGSTGuis2NiC7H4W5p4151M=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Roman Gushchin <roman.gushchin@linux.dev>
Cc: linux-mm@kvack.org, bpf@vger.kernel.org, 
	Suren Baghdasaryan <surenb@google.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Hocko <mhocko@suse.com>, David Rientjes <rientjes@google.com>, 
	Matt Bobrowski <mattbobrowski@google.com>, Song Liu <song@kernel.org>, 
	Kumar Kartikeya Dwivedi <memxor@gmail.com>, Alexei Starovoitov <ast@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1 00/14] mm: BPF OOM
Message-ID: <h2bmsuk7iq7i6hphp7vbaxndawwgjz42mhfntlcc2yt4u6but6@7xlre5c56xlq>
References: <20250818170136.209169-1-roman.gushchin@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250818170136.209169-1-roman.gushchin@linux.dev>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 1545E1C0007
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: ehhed1mnmwtuqbz1q1q6nqdjmcd446qx
X-HE-Tag: 1755723971-394148
X-HE-Meta: U2FsdGVkX19AVhvkEf95wPtyzu6IsD8OWZ0PLRUY1y1zdn8crn0c001yV8WoeiZxNox2ujknsZf9j5/26nIxZUg77la2Dd1MkyanXezilX7DadagDwEsVuqWjzZNbgBinMsFhfy5eLb0+2AN2qYnc2T+q8Rt4js39HCkC05f0aBMN+z59x3uXXSb0KOikYJV2SVTmc/TE/jdbHD+zcWQnNvDTot6Kq0EzYk67MS8F+ndDi8YT0SPKTtV521ghNAZjqT/nqKIoYH/kT+HeAFa8Za0Krx9ZFqHDsFa3u/449WCbUKy2dnveFX/7MUqKLXJZ9jH+ZpGBfpVX0j+XFhDLofawYhxtMSN6YAX5chxL0xE8RYeEWk8XkdCKSux3a1YiJLGiZlQR1Rxm0uQ/RO/X7DughUjVAzt8KMAs4v8vAOYtbyYwQkBa6xsW8J2rQhg/Eycl2M4NibVlgggojbkb7gcFZCWsIfGtwRPkVcdB/FyVVYzUIhnwsqlma36Pz/WBBpwcqtV5W6gKhZ2qJeVoof9nxz04bzaknwG4iwqclolHu+WvRnvXIe3RRwlR75kZ5zjyKv52ygOuoPJ1Wc1v+OHKI5G8efuYAFf/ybpLthK/kPty17LOCKnQgaBrAO72YYHmXJwFcxemu+GUzp/58f7IeTp2dDWcbX5b/XBonFEjnmIoIiOCM8f6BlVsXGWjw6MvLuiBUoE6oTyhSeVuwxaVTQL6g3WpbkGQOhYwPX66MnM4RtliwguSuZXXUl/D6Q9C1yxRXbdrdfRidTH7VoRsi6pz1JTkRkqZuGf29bt3l4QA5D0KdNAj86sfkIJCsZJiG6kDma0VdfZS5OmD6Re5zx3IAvxixaTrdBsEM8jIqWAqu4Ra4HNSge1h6j768LYqnnJK5g3fkj6hcyWkWMJ9U4aSgttIMJ/XFCKJxDOLS/8Ib9zGXs6ALeoUTirnkn3azLTBm2iUob0Pqi
 1WTGeT5I
 L5CPAAcvHlyI5BRLEZtK8f4QuzX2fUMfUHiPRylBRjMDjjen3KYLOc1JR0qNCFdWUZL3r2kxQDj4IvVDwj4AzwC2OD69Bcfv7CBkk8R6HHqfUYt92L2UwOXfsVTy4ekyHHOOEIbm5K7kX2gX07DEaErbaGr2ZUuvPs1wUBX28YhqYm0KFbwnNKZ1SDt/ieCV51AfwTVyRRs2JMuOSYLO1atigFWCby278bZ2luEbZgcXjDdc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 18, 2025 at 10:01:22AM -0700, Roman Gushchin wrote:
> This patchset adds an ability to customize the out of memory
> handling using bpf.
> 
> It focuses on two parts:
> 1) OOM handling policy,
> 2) PSI-based OOM invocation.
> 
> The idea to use bpf for customizing the OOM handling is not new, but
> unlike the previous proposal [1], which augmented the existing task
> ranking policy, this one tries to be as generic as possible and
> leverage the full power of the modern bpf.
> 
> It provides a generic interface which is called before the existing OOM
> killer code and allows implementing any policy, e.g. picking a victim
> task or memory cgroup or potentially even releasing memory in other
> ways, e.g. deleting tmpfs files (the last one might require some
> additional but relatively simple changes).

The releasing memory part is really interesting and useful. I can see
much more reliable and targetted oom reaping with this approach.

> 
> The past attempt to implement memory-cgroup aware policy [2] showed
> that there are multiple opinions on what the best policy is.  As it's
> highly workload-dependent and specific to a concrete way of organizing
> workloads, the structure of the cgroup tree etc,

and user space policies like Google has very clear priorities among
concurrently running workloads while many other users do not.

> a customizable
> bpf-based implementation is preferable over a in-kernel implementation
> with a dozen on sysctls.

+1

> 
> The second part is related to the fundamental question on when to
> declare the OOM event. It's a trade-off between the risk of
> unnecessary OOM kills and associated work losses and the risk of
> infinite trashing and effective soft lockups.  In the last few years
> several PSI-based userspace solutions were developed (e.g. OOMd [3] or
> systemd-OOMd [4]

and Android's LMKD (https://source.android.com/docs/core/perf/lmkd) uses
PSI too.

> ). The common idea was to use userspace daemons to
> implement custom OOM logic as well as rely on PSI monitoring to avoid
> stalls. In this scenario the userspace daemon was supposed to handle
> the majority of OOMs, while the in-kernel OOM killer worked as the
> last resort measure to guarantee that the system would never deadlock
> on the memory. But this approach creates additional infrastructure
> churn: userspace OOM daemon is a separate entity which needs to be
> deployed, updated, monitored. A completely different pipeline needs to
> be built to monitor both types of OOM events and collect associated
> logs. A userspace daemon is more restricted in terms on what data is
> available to it. Implementing a daemon which can work reliably under a
> heavy memory pressure in the system is also tricky.

Thanks for raising this and it is really challenging on very aggressive
overcommitted system. The userspace oom-killer needs cpu (or scheduling)
and memory guarantees as it needs to run and collect stats to decide who
to kill. Even with that, it can still get stuck in some global kernel
locks (I remember at Google I have seen their userspace oom-killer which
was a thread in borglet stuck on cgroup mutex or kernfs lock or
something). Anyways I see a lot of potential of this BPF based
oom-killer.

Orthogonally I am wondering if we can enable actions other than killing.
For example some workloads might prefer to get frozen or migrated away
instead of being killed.

