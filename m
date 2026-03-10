Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 348C5EB1054
	for <linux-mm@archiver.kernel.org>; Tue, 10 Mar 2026 14:53:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 84B266B00B2; Tue, 10 Mar 2026 10:53:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 815E46B00B3; Tue, 10 Mar 2026 10:53:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7630A6B00B4; Tue, 10 Mar 2026 10:53:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 64F4B6B00B2
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 10:53:32 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E951D1A01EC
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 14:53:31 +0000 (UTC)
X-FDA: 84530447022.14.9714C46
Received: from out-181.mta0.migadu.com (out-181.mta0.migadu.com [91.218.175.181])
	by imf28.hostedemail.com (Postfix) with ESMTP id 6F24DC0002
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 14:53:28 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=RJ70MCfZ;
	spf=pass (imf28.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.181 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773154410;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TwC6pQbU5gHuxh3zkLyr8F7z5S+cv/um/MQ7GFUg3ck=;
	b=uUYS7riZcGATyk1ZFzuwghrYy3iUTi0iswTdzAzSIoNtfybtnzUhXJnCGylteCkTlsPLp5
	AubN/ItT+gHo3/ngCQlGPOhxPK89oeYlusgEfo2MnRRDcFlZZrRwbu4nqJ8GS0cFMLzl6T
	VY9Zj/Zhxs2O3EjiOm1FpSrLshEI4cY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773154410; a=rsa-sha256;
	cv=none;
	b=bkkO33wPrnuJ2SRKleLmI2ov+Lu2dZjTzAtaSIuTJt16n1sKXDs4wzZhS7JrNdHovOy22U
	h3aGWc1M/gfDlDga08oXVmoNnmOqCYSebCTIk8QBlwc/gn0NrvyFYw+ylkJUNAEqcvSENh
	m2jxjZo/ufQNLeFc/sWyU3eLmC2eUyw=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=RJ70MCfZ;
	spf=pass (imf28.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.181 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Date: Tue, 10 Mar 2026 07:53:17 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1773154405;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=TwC6pQbU5gHuxh3zkLyr8F7z5S+cv/um/MQ7GFUg3ck=;
	b=RJ70MCfZUZ8oim853NhKIczs7H6wsAeJGmYw6yKIRMGVS7S/HlKGVccsLjpNf1rv3CDO2+
	MY/mrrZY1AH4PArNfzP67Y4oEkykaWnYAGNufGH5bp4JkvMeIYW25inkycGAXGc1plCYvY
	l3mPcmnI4yj1EuXY7C8AidiZzdkAz4g=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: "JP Kobryn (Meta)" <jp.kobryn@linux.dev>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, mhocko@suse.com, 
	vbabka@suse.cz, apopple@nvidia.com, axelrasmussen@google.com, byungchul@sk.com, 
	cgroups@vger.kernel.org, david@kernel.org, eperezma@redhat.com, gourry@gourry.net, 
	jasowang@redhat.com, hannes@cmpxchg.org, joshua.hahnjy@gmail.com, 
	Liam.Howlett@oracle.com, linux-kernel@vger.kernel.org, lorenzo.stoakes@oracle.com, 
	matthew.brost@intel.com, mst@redhat.com, rppt@kernel.org, muchun.song@linux.dev, 
	zhengqi.arch@bytedance.com, rakie.kim@sk.com, roman.gushchin@linux.dev, surenb@google.com, 
	virtualization@lists.linux.dev, weixugc@google.com, xuanzhuo@linux.alibaba.com, 
	ying.huang@linux.alibaba.com, yuanchu@google.com, ziy@nvidia.com, kernel-team@meta.com
Subject: Re: [PATCH v2] mm/mempolicy: track page allocations per mempolicy
Message-ID: <abAmMjkZZLN9LXXM@linux.dev>
References: <20260307045520.247998-1-jp.kobryn@linux.dev>
 <aa9aDGwk8YteaEob@linux.dev>
 <dcf2e654-ad2f-4390-9b62-078e664158de@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dcf2e654-ad2f-4390-9b62-078e664158de@linux.dev>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 6F24DC0002
X-Stat-Signature: 16tx96kbk9w8x91md7p1tf1qkbiaygh5
X-Rspam-User: 
X-HE-Tag: 1773154408-893668
X-HE-Meta: U2FsdGVkX1/tqujlHHs8UICFU55VPRG8X5Sp1q1/kgGAq1BEIgzfwJUTR7dFJWevz+qeiaO4TBvS4hD8bqcSUYhsdrO5GyH0GE/5ODHgAsB8Y793XiZCx1nmLI0qDXr/gLPdTNvaeopv+rYOHtZgNZcjigNWZQok+E+gWvcxKnIs/wRDK+EAy01etzff+Q77NnQTVpi2pz7TZscEsbC7N7DxUXuYxYfkS5lJBRZgnWhRa9lydprdeLWi80NgGinPsQ3mo2DjtuQ3/JHF/RCN65wgnklpTiqsWjylvBCv9eojEnPyDu71UvOGl2n2y2GfLg1s65DHZgOHRCXeMrPXwMLL9Yznf7HH5bJiVjp6KqyS/fg3a2A9W2qkcoVG5EFvg66iWiPwJTC80G+O5mczM74kxilXux6uODv7/Fd2iJGIiSlUTWFrtsxI24UekWruwUZ3fZCEhPdRHVLYOciSP4SUAhqBWuShRQBffmDhALE+mxYXzP5DfVyM8GXlq+N9l4+i3yABgOqg33uWmUum3zxsFi57kiQ4CIM771J82x2Yr+0UaBSh+hDyhsAtj/GOqV3XB5GxD8FYd5SHKyHzwOvnprLXeP1i4aFaUqJMsaWyri5kkJJ4rkYIk44T2iL1uastTGIOKt8NLF2WVwpVHvSNWeD+JWD4OzrjpgmOFbxjAgF4/gItkHGFf5HIYxePIGF7ZqmkaRfCiqtf6A3p901RCBbfY6fRuI4GcfnC2DJl1Va5Cg/1nh9q5EWsDsX0yTanNuxZ91Yx+uiNL4QPfvKZh1X9yuoKDnw2b33dlM0yKZgHXoTe8E0L3n2Z1xvSi88V8DfipfRGm0NiwuKezvAFFuOaZ/DiagzpVdZP4ttdUNT800/mtNy0Zmqm5ShmAMOGPf9YvJPbI5Odddvzkt3K52i8L29dCarSE4CTz55gee9Al/gU6HQ6HY0vcrL2kcVtsABtNHRZ9e98Nho
 O+dkh/r+
 O99h+z/cRPfx+mWwRwxT2w5AhZRp2ArvOjrLtEQrJsMJfcnUv01ny8nyqQ3y+wHSG/h8o9UXtf4xAt9FKuoWY2YilL1JL2qiT2zfWGFS1X/ZwCo85A5r2GzhiHWbe0QEnDJLEXRGIb+KkC6aZAzUjB9ncfJEWVN9qmHhPmjoY9W73ApZXmas/9zkeoYcb11bsigDFg7sWlp4uMwnck0wNYWhDwABiwywTdt/6BbFqTNbSe3o3nAz0z9kVZMlXBxXXx0lRHnImseIfilgAL0METqqPXQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 09, 2026 at 09:17:43PM -0700, JP Kobryn (Meta) wrote:
> On 3/9/26 4:43 PM, Shakeel Butt wrote:
> > On Fri, Mar 06, 2026 at 08:55:20PM -0800, JP Kobryn (Meta) wrote:
[...]
> > 
> > This seems like monotonic increasing metrics and I think you don't care about
> > their absolute value but rather rate of change. Any reason this can not be
> > achieved through tracepoints and BPF combination?
> 
> We have the per-node reclaim stats (pg{steal,scan,refill}) in
> nodeN/vmstat and memory.numa_stat now. The new stats in this patch would
> be collected from the same source. They were meant to be used together,
> so it seemed like a reasonable location. I think the advantage over
> tracepoints is we get the observability on from the start and it would
> be simple to extend existing programs that already read stats from the
> cgroup dir files.

Convenience is not really justifying the cost of adding 18 counters,
particularly in memcg. We can argue about adding just in system level metrics
but not for memcg.

counter_cost = nr_cpus * nr_nodes * nr_memcg * 16 (struct lruvec_stats_percpu)

On a typical prod machine, we can see 1000s of memcg, 100s of cpus and couple of
numa nodes. So, a single counter's cost can range from 200KiB to MiBs. This does
not seem like a cost we should force everyone to pay.

If you really want these per-memcg and assuming these metrics are updated in
non-performance critical path, we can try to decouple these and other reclaim
related stats from rstat infra. That would at least reduce nr_cpus factor in the
above equation to 1. Though we will need to actually evaluate the performance
for the change before committing to it.

