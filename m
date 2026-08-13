Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3822FC5CFEB
	for <linux-mm@archiver.kernel.org>; Thu, 13 Aug 2026 06:24:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1297E6B01A6; Thu, 13 Aug 2026 02:24:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 100FC6B01A7; Thu, 13 Aug 2026 02:24:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 016326B01A9; Thu, 13 Aug 2026 02:24:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id CA2936B01A6
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 02:24:00 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 5AE85C0561
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 06:24:00 +0000 (UTC)
X-FDA: 85095255840.29.809EA54
Received: from invmail4.hynix.com (exvmail4.hynix.com [166.125.252.92])
	by imf03.hostedemail.com (Postfix) with ESMTP id A8D3520002
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 06:23:57 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=sk.com;
	spf=pass (imf03.hostedemail.com: domain of rakie.kim@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=rakie.kim@sk.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786602238;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5wLDHgab615CSLj+ydzHGATGTZuO83cjL6IjYwS35Oo=;
	b=r/ZXLj4oxgDdzXfRNsO5bQVIvvWTbMeLVFpjJzvfHQMaSbTuF5DoE87lci10r46VZ3lJIs
	pQ6DfEf0oZDxRNolyFCxl0kTshreJeOQ9DAH8RZoJdYJBwvcM8olWUMAG2mioqYL1VirgD
	VjZGMQ9PyJQ97trVHVFpUIKDN7lqx+o=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=sk.com;
	spf=pass (imf03.hostedemail.com: domain of rakie.kim@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=rakie.kim@sk.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786602238;
	b=nQtDii41tP0Bdw51a5DJ1bqDbPyACddXb4RCqE2dZHB7vrNS3c5m/c44baJe2kWaH7bYrS
	mSR8oInfkbAOxa1iqKSpujBx/Mj8cT4fg74eVbeVBVC+xgu000iT7NLupswWIaohkwF7sL
	2XrMNJJQsrj35b1kCdkJBuBxzL+BuqI=
X-AuditID: a67dfc5b-c2dff70000001609-ad-6a7d62f9452f
From: Rakie Kim <rakie.kim@sk.com>
To: Gregory Price <gourry@gourry.net>
Cc: akpm@linux-foundation.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-cxl@vger.kernel.org,
	nvdimm@lists.linux.dev,
	ziy@nvidia.com,
	matthew.brost@intel.com,
	joshua.hahnjy@gmail.com,
	byungchul@sk.com,
	ying.huang@linux.alibaba.com,
	apopple@nvidia.com,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	dave@stgolabs.net,
	jic23@kernel.org,
	dave.jiang@intel.com,
	alison.schofield@intel.com,
	vishal.l.verma@intel.com,
	ira.weiny@intel.com,
	harry@kernel.org,
	kernel_team@skhynix.com,
	honggyu.kim@sk.com,
	yunjeong.mun@sk.com,
	Rakie Kim <rakie.kim@sk.com>
Subject: Re: [PATCH 0/4] mm/mempolicy: introduce package-aware weighted interleave
Date: Thu, 13 Aug 2026 15:23:48 +0900
Message-ID: <20260813062351.1856-1-rakie.kim@sk.com>
X-Mailer: git-send-email 2.52.0.windows.1
In-Reply-To: <an0t0mP9JB8f4ILK@fedora>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrFIsWRmVeSWpSXmKPExsXC9ZZnoe6vpNosg3n9bBZz1q9hs7j7+AKb
	xa4bIRYnbjayWay+uYbR4vnWX4wWP+8eZ7e4fmslo8X+p89ZLB40rWKyOL51HrvFulOH2CzO
	zzrFYnF51xw2i3tr/rNavHnsZvGtT9rifp+Dxcoff1gtjqzfzmQx+dICNouOl/dZLG5NOMZk
	sXpNhsXso/fYHSQ9ds66y+6xYFOpR3fbZXaPzSu0PBbvecnksWlVJ5vHpk+T2D1OzPjN4rHz
	oaXHi80zGT16m9+xeUydXe+xfstVFo/Pm+QC+KK4bFJSczLLUov07RK4Mg5ezC+4IV/R9PkB
	SwPjE4kuRg4OCQETif5LJl2MnGDm+oa7rCBhNgEliWN7Y0BMEQFVibYr7iAVzALbWCVuXdQE
	sYUFgiS6pj9nBLFZgErWPp3LBGLzAk3ZsKmJDWKipsS6jbdYQGxOATWJrn8QNUICPBKvNuxn
	hKgXlDg58wkLxHx5ieats5m7GLmAej+yS5xYcYQJYpCkxMEVN1gmMPLPQtIzC0nPAkamVYxC
	mXlluYmZOSZ6GZV5mRV6yfm5mxiBMbqs9k/0DsZPF4IPMQpwMCrx8GY012QJsSaWFVfmHmKU
	4GBWEuGtXlWVJcSbklhZlVqUH19UmpNafIhRmoNFSZzX6Ft5ipBAemJJanZqakFqEUyWiYNT
	qoHRKHdT8Zr9rAVME2yOhHoHX1/Zwb542v6LL+4WvFpnwxHUtI+h8+AJWaN0/f8aYisCM4LP
	e36OrLmRb3rqFfPuvxH/N+s8+m4mnKz4RX3z/Nh1K+z3lC+eWOCf57F3QVW+2clF2+Z92Hfx
	nqG09JV7T1T2TVz1s+T4xp0GeY6fyjY03Km4Lfy5QomlOCPRUIu5qDgRAOp90W3NAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrFIsWRmVeSWpSXmKPExsXCNUM9RvdnUm2WwcH1BhZz1q9hs7j7+AKb
	xa4bIRbnpsxmszhxs5HNYvXNNYwWz7f+YrT4efc4u8X1WysZLT4/e81ssf/pcxaLB02rmCyO
	b53HbnF47klWi3WnDrFZnJ91isXi8q45bBb31vxntXjz2M3iW5+0xf0+B4uVP/6wWhy69pzV
	4sj67UwWky8tYLPoeHmfxeLWhGNMFqvXZFj83raCzWL20XvsDnIeO2fdZfdYsKnUo7vtMrvH
	5hVaHov3vGTy2LSqk81j06dJ7B4nZvxm8dj50NLjxeaZjB69ze/YPL7d9vBY/OIDk8fU2fUe
	67dcZfH4vEkuQCCKyyYlNSezLLVI3y6BK+PgxfyCG/IVTZ8fsDQwPpHoYuTkkBAwkVjfcJe1
	i5GDg01ASeLY3hgQU0RAVaLtijtIBbPANlaJWxc1QWxhgSCJrunPGUFsFqCStU/nMoHYvEBT
	NmxqYoOYqCmxbuMtFhCbU0BNousfRI2QAI/Eqw37GSHqBSVOznzCAjFfXqJ562zmCYw8s5Ck
	ZiFJLWBkWsUokplXlpuYmWOqV5ydUZmXWaGXnJ+7iREYo8tq/0zcwfjlsvshRgEORiUe3ozm
	miwh1sSy4srcQ4wSHMxKIrzVq6qyhHhTEiurUovy44tKc1KLDzFKc7AoifN6hacmCAmkJ5ak
	ZqemFqQWwWSZODilGhinT3rebX9+cXDdo8Nu/jMcpDMlz39/clMud6LFTZ2N/fu21W1W3hvh
	n7aqwfOtZ3HWrxP/t05M3CjyTsHmkKmtkWqWqlML04RVb22rLk4NF970+Y3m1K7VTXdNrmlf
	XrDkvY+L8wHzNXy/H8h0RN5J7Pvxxm1PiMO530f5zBdbrr3ZaKvLX52jxFKckWioxVxUnAgA
	4pG6rs0CAAA=
X-CFilter-Loop: Reflected
X-Stat-Signature: uzt7gik8obq97hnwtgx7baannbgqnytu
X-Rspamd-Queue-Id: A8D3520002
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1786602237-999693
X-HE-Meta: U2FsdGVkX19unEIgUgIfuonXE6lptaE4tHcOjy4xWq1LTyk3gT0/ezsdkPF6VebBrrlNYdEOyBnRNABPSQZUPtdBHa7icusrrYoVibbVZBT4jN+hFg+hRys1gjXPOevl0nwFlj0E9P2jmo8qKMHPPnzhUGwPObVK8wO5d7KtPqOTr7tK9wxbuJFJbugJip8Qzu4KpIQ/66hvkBMm95e9awYgoADLTialkoNXYCjAEP8Zz++jU5Kq5/pRtbJqZ7QUrNM1d132NvdR1sn3Ejic0SUrsp3w37JLny6Y9oHdihYz3UmQF9RUtb8iKLRsEcY7sXPjjz3olRiC3Ad2mOq3Ta0suWY/1dGXILat5d410/0/r/O2LPspLbM/BguHavjvCrsK1A8umoQoCuSvkpZ+swQc1L5Hlt/KF6xT6AP+1h81d/EXjKR41MfdSXU5j5MaJJ/CdbzVsPB6sOBicLxqHWRU+4FirviR4f1o6dHfLcBE01Ckqjx2DZKpYmqOufaC0k9BOVgzLl91haG9NFUG/UiVSK7tG+r+TCdc6CaURHq7ViIc40JspwC6Fcq+3L2d/URPNh+Sjbv4bvIz97qklRjVAkfgq0he6rSxb6i/Muc079WecGVLTyv0OHF2uEeSAVV7PQ5T8WPM/TziGPGwJfdCjGUwApgLpEMl6VjHefMESrABtSmhRFuHALe/BneG4lR8nfU/UX5vKjF5bHLFQySuQPNiUOuJ7JxZSssTEEFiRo3gnsgP6J9k3Ugq2uy0Wayr3gadLHHylpL61R3/ei/19czmf1W9X7tXg3gloZNApegjGG4LobjFol0KbXAvGftfmkLmn8OPF+OeQTzZHyKiVuLYogw3LIAYXeKLGngYEWkikKRrrUX3XweEHWiR8W+lwIBZ2OE/IDgEgq9Hm4uFibcYOQxQ05y6Rx1LDZ30D35MKaFCbGNrmuNciQaklvnjbwOmbudFmtX+tEt
 Cs+rMF1p
 Sin2SaHUHuFIQtWcoRgqlD27z8ySbtfZEZLP93OBYNkqPX2vYGyjLqg1oTQi8p+CxOlevJ1lUkzbvkLM4jij5LWIzVPH5wC7Ys9CB6O0JhaghCZfkIuiycCcuC0iGAFdHqQWA
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 12 Aug 2026 22:37:06 -0400 Gregory Price <gourry@gourry.net> wrote:
> On Thu, Aug 06, 2026 at 05:09:31PM +0900, Rakie Kim wrote:
> > Package-aware weighted interleave places a task's weighted-interleave
> > pages on the NUMA nodes of its local package, so that interleave traffic
> > does not have to cross the interconnect to another package. This keeps
> > each node's weight aligned with the bandwidth the task actually gets
> > from it, so effective bandwidth holds up on a system that has more than
> > one package. (A package is a CPU socket together with the memory
> > attached to it.)
> >
>
> The only major question I have before I dig into the actual patches is
> whether you actually need this on a *per-task* basis, rather than simply
> a *per-process* basis - because that's all this really buys you.
>
> You can already do what is described here by simply using a combination
> of cpuset and mempolicy
>
> cpuset.mems = 0,2
> mempolicy = weighted interleave --all
>
> If this is actually required on a per-task basis, then I agree this
> concept is reasonable.  I just want to make we're grounded on a real
> use case before we go adding this complexity.
>
> ~Gregory

Hello Gregory,

Thank you for reviewing this series. My description was not precise
enough, and it seems to have confused several people. Let me go over
the example again.

I labelled the rows "from CPU 0" and "from CPU 1", which reads as two
separate tasks, each pinned to one place. What the rows were meant to
show is which package the allocation is requested from:

                  node0  node1  node2  node3
from package 0:     2      0      1      0
from package 1:     0      2      0      1

Both rows come from one policy at the same time. Which row applies is
decided per allocation, by the package the requesting CPU is in.

The cpuset.mems = 0,2 you describe is the node set of package 0, so
the tasks in that cgroup use node0 and node2 wherever they run.

The feature I am proposing does not fix a package that way. It uses
the nodes of the package the request comes from.

To build the feature I am proposing with cpuset, I think you would
need a cgroup per package and would have to place each thread in the
one matching the package its CPU is in.

cpuset.mems does not follow the CPU, so unless cpuset.cpus is set
alongside it, a thread running on a CPU of package 1 would use node0
and node2. For a program with tens or hundreds of threads, keeping
that placement right does not look easy.

To put it plainly, what this series aims for is that when a process
with many threads runs across several packages, each thread's
allocations are weighted-interleaved within the nodes of the package
that thread is on.

There is one process and one policy, but the nodes actually used
differ with where each thread sits. That is why I think this has to be
per task rather than per process.

The workloads I had in mind are memory-intensive server workloads:
vector databases as used in AI applications, or in-memory key-value
caching services that sit in front of large services and keep their
data in memory.

They run with a great many threads, spread across several packages and
running at the same time, and they want as much memory bandwidth as
they can get.

That is also why the numbers were measured with MLC. It produces high
bandwidth from many threads, much like those workloads, while still
giving a quantitative result.

The runs used "numactl -w all mlc" with no CPU binding, so the threads
were spread over both packages, and in that configuration the
bandwidth was higher than with the existing weighted interleave.

That is the reasoning behind my thinking that this belongs at the task
level. In the next version I will strengthen the documentation,
including why this feature is needed.

Thank you for taking the time to review this and for the question. It
made it much clearer to me what the cover letter still needs to
explain.

Rakie Kim

