Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 57B8DCCF9E3
	for <linux-mm@archiver.kernel.org>; Mon, 10 Nov 2025 20:19:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 985858E0003; Mon, 10 Nov 2025 15:19:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 935D98E0002; Mon, 10 Nov 2025 15:19:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 824CD8E0003; Mon, 10 Nov 2025 15:19:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6BFC38E0002
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 15:19:18 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 32B281A029A
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 20:19:18 +0000 (UTC)
X-FDA: 84095811996.23.0A821F0
Received: from out-180.mta1.migadu.com (out-180.mta1.migadu.com [95.215.58.180])
	by imf22.hostedemail.com (Postfix) with ESMTP id 15329C0011
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 20:19:15 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="dDZdHH/k";
	spf=pass (imf22.hostedemail.com: domain of yosry.ahmed@linux.dev designates 95.215.58.180 as permitted sender) smtp.mailfrom=yosry.ahmed@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762805956;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GUAtP+bOC5fLBEO7OxWohIhZ/kKSaZK8V4CE4mNGeCE=;
	b=73t/hrjihq4cvBQ7MyjPCMsmbAix+ekSIO+FY8ohxPeDkENR+6mwP38Hg8x2yDnh6DcnMY
	8GnnHXms8nh5q+0URKaP7h1K6Bme96+rHLld0k8HkXKjmTm4FDw+oMpepkT2EVHpgpb8Ss
	h+4WbFKouhajJkboq70is6/CMleATaM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762805956; a=rsa-sha256;
	cv=none;
	b=xD8rUUdqgFNX/t1GtX4mWnSxmZP8bw3XpTKZ0NGzV9rGNvY2jNL7kLw/thchConDJNPd5s
	VuGeab/R8SdoD+jPIMuwznin6IQvVTzbHtWsd+aCpZpgeEWe649OGjPR/F5lTOpnK9Odaq
	4sAziT17XRqEeIBAkZFwP9yjt/58U2U=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="dDZdHH/k";
	spf=pass (imf22.hostedemail.com: domain of yosry.ahmed@linux.dev designates 95.215.58.180 as permitted sender) smtp.mailfrom=yosry.ahmed@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Date: Mon, 10 Nov 2025 20:19:04 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1762805953;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=GUAtP+bOC5fLBEO7OxWohIhZ/kKSaZK8V4CE4mNGeCE=;
	b=dDZdHH/kUkiRo3SsSNquTHnsNNN5J1Hk+BaJBgf32qqXkT9h85QIiDkbubM9dJ0mnW2sJI
	m1tCceGb4xcU/Fsn4Th82hnSW3LDELgBS33j4ATEEaZ2qp0rTfOXLwrGL86r/sDmFKxpSa
	HdMxQ1gJ8Hm1xuXfedgVL8bXwbUNMx0=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Leon Huang Fu <leon.huangfu@shopee.com>
Cc: shakeel.butt@linux.dev, akpm@linux-foundation.org, 
	cgroups@vger.kernel.org, corbet@lwn.net, hannes@cmpxchg.org, inwardvessel@gmail.com, 
	jack@suse.cz, joel.granados@kernel.org, kyle.meyer@hpe.com, 
	lance.yang@linux.dev, laoar.shao@gmail.com, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, mclapinski@google.com, mhocko@kernel.org, 
	muchun.song@linux.dev, roman.gushchin@linux.dev
Subject: Re: [PATCH mm-new v2] mm/memcontrol: Flush stats when write stat file
Message-ID: <fwthn4zl6uppdjdckjkmglxwnby42x2rd57i3m22pbqamjzaxy@aso4l7xyvhek>
References: <blygjeudtqyxk7bhw5ycveofo4e322nycxyvupdnzq3eg7qtpo@cya4bifb2dlk>
 <20251110063757.86725-1-leon.huangfu@shopee.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251110063757.86725-1-leon.huangfu@shopee.com>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: 15329C0011
X-Stat-Signature: i7hujb5ou936gh1zt5bye7m6xr8q1unk
X-HE-Tag: 1762805955-795944
X-HE-Meta: U2FsdGVkX1/CVfyqBMZbYzpOfogUBTZt+ZrAJEhK4R4czfUMp/Q6azKn5zFwKR5FIBXrNGr+ONVX7pEm+3+1LTjrvr7FlXXxX1df5bg2FbBMiiBkl8+8euaz/8CVJxAAodIQ+qgRUf6FEqw2WuadxssAKWNmGSZPxuIrYMQI6RiHV7bJaLfJmDzIEhfTFgc8tKtPfEscryh90DC+qMTFle/tT9XwKrqT2zvMK1k/JsDL9sVu03vWkfMFfiEIREx4feukpLcGtlpXvXFcZfO2EXVnvsaDV0tFO5SfEu6uXKWqU1auERLopvug2g8O47AFeItSt4RXHzZHlO7VtINNahTfx1i3LDTB1W4fCqUZih47CmW2P7yZ/oKTxZpStgiH7e03bQ40ztQZ62kX8TolfMQRUmpkhWaLLGTfsiLmhlYcRMCFJOFaUo31uQ0VYuVMaHj/y4hkW+0a6mtEfPAaIHYzh3JXvrhmy42kfHzFo7XMd0ruGZkDEp11hcLjnOEdN9RmM/miIff7hLThcV4NZCmhzZKqXQDbPyGxu27FVCYKmEC1qSD1icT6zwU+3B0nC6JGfkROw6a4vF83VxwSCDVfGyN1olUdKmcTEr+/869U2BpONeubLJ0bmFi/U1soNDvr7v0K8mBaJveL3V7oCmW+sT2RjTk7CutFa8l+xead4tKO5cKSkSHuqfXvsblxs8TSqzTt4z5qTcF5pNU/sHgNJzWg0vGbDbIwvtO292/tjA2KYYD9fNcffsdwFaygsTKC1QKUXY4bUAnpBSFdeyfP/HVFSeXdXFh4O33V4IxjEDjj+ICSD1a6DHZ+Ijmk9+DGn11P/OtkbfdW2nhtz3L1EuqvuBow6gSQHnZkmmPQvvdEFYVtwmlsI2KSmYENxcmtn3ekMOdTPg+gxqzyYd8gpM49LzAYdlQdZXXXINS4Iv6J4rL1s2zwRGDlE5fFwiAmu+1mgISulaeXdFE
 r/wMQTsa
 1ram+jOA6UdQTSh1FJ0YITyi1HDUmI+kV4jftRtkd31Nb8f/IZfnYc+zqcr0WzGYo08lJAcIoz4zGyGomMvYXMUJhYYPkPchyykx+RCe3hAsztg5l7fkyAO+GoQZDvGmvubhNst/ds+/4xZs53+eE8Ar4Ubqs7KflodE0hpBXEa2MtpgGowb128B/EuPgNUlodkRy4bFQ0J8evKdmtOVlA3L/DfLZc1AnqCeaqTuoOUoKDXRFNeC2sNvyeZt8oGlTUfnVkgHifSP2hjPYsw3LB8m0fA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Nov 10, 2025 at 02:37:57PM +0800, Leon Huang Fu wrote:
> On Fri, Nov 7, 2025 at 7:56 AM Shakeel Butt <shakeel.butt@linux.dev> wrote:
> >
> > On Thu, Nov 06, 2025 at 11:30:45AM +0800, Leon Huang Fu wrote:
> > > On Thu, Nov 6, 2025 at 9:19 AM Shakeel Butt <shakeel.butt@linux.dev> wrote:
> > > >
> > > > +Yosry, JP
> > > >
> > > > On Wed, Nov 05, 2025 at 03:49:16PM +0800, Leon Huang Fu wrote:
> > > > > On high-core count systems, memory cgroup statistics can become stale
> > > > > due to per-CPU caching and deferred aggregation. Monitoring tools and
> > > > > management applications sometimes need guaranteed up-to-date statistics
> > > > > at specific points in time to make accurate decisions.
> > > >
> > > > Can you explain a bit more on your environment where you are seeing
> > > > stale stats? More specifically, how often the management applications
> > > > are reading the memcg stats and if these applications are reading memcg
> > > > stats for each nodes of the cgroup tree.
> > > >
> > > > We force flush all the memcg stats at root level every 2 seconds but it
> > > > seems like that is not enough for your case. I am fine with an explicit
> > > > way for users to flush the memcg stats. In that way only users who want
> > > > to has to pay for the flush cost.
> > > >
> > >
> > > Thanks for the feedback. I encountered this issue while running the LTP
> > > memcontrol02 test case [1] on a 256-core server with the 6.6.y kernel on XFS,
> > > where it consistently failed.
> > >
> > > I was aware that Yosry had improved the memory statistics refresh mechanism
> > > in "mm: memcg: subtree stats flushing and thresholds" [2], so I attempted to
> > > backport that patchset to 6.6.y [3]. However, even on the 6.15.0-061500-generic
> > > kernel with those improvements, the test still fails intermittently on XFS.
> > >
> > > I've created a simplified reproducer that mirrors the LTP test behavior. The
> > > test allocates 50 MiB of page cache and then verifies that memory.current and
> > > memory.stat's "file" field are approximately equal (within 5% tolerance).
> > >
> > > The failure pattern looks like:
> > >
> > >   After alloc: memory.current=52690944, memory.stat.file=48496640, size=52428800
> > >   Checks: current>=size=OK, file>0=OK, current~=file(5%)=FAIL
> > >
> > > Here's the reproducer code and test script (attached below for reference).
> > >
> > > To reproduce on XFS:
> > >   sudo ./run.sh --xfs
> > >   for i in {1..100}; do sudo ./run.sh --run; echo "==="; sleep 0.1; done
> > >   sudo ./run.sh --cleanup
> > >
> > > The test fails sporadically, typically a few times out of 100 runs, confirming
> > > that the improved flush isn't sufficient for this workload pattern.
> >
> > I was hoping that you have a real world workload/scenario which is
> > facing this issue. For the test a simple 'sleep 2' would be enough.
> > Anyways that is not an argument against adding an inteface for flushing.
> >
> 
> Fair point. I haven't encountered a production issue yet - this came up during
> our kernel testing phase on high-core count servers (224-256 cores) before
> deploying to production.
> 
> The LTP test failure was the indicator that prompted investigation. While
> adding 'sleep 2' would fix the test, it highlights a broader concern: on these
> high-core systems, the batching threshold (MEMCG_CHARGE_BATCH * num_online_cpus)
> can accumulate 14K-16K events before auto-flush, potentially causing significant
> staleness for workloads that need timely statistics.

The thresholding is implemented as a tradeoff between expensive flushing
and accurate stats, and it aims to at least provide deterministic
behavior in terms of how much the stats can deviate.

That being said, it's understandable that some use cases require even
higher accuracy and are willing to pay the price. Although I share
Shakeel's frustration that the driving motivation is tests where you can
sleep for 2 seconds or alter the tests to allow some bound deviation.

The two alternatives I can think of are the synchronous flushing
interface, and some sort of tunable that determines the needed accuracy.
The latter sounds like it would be difficult to design properly and may
end up with some of the swappiness problems, so I think the synchronous
flushing interface is probably the way to go. This was also brought up
before when the thresholding was implemented.

If we ever change the stats implementation completely and lose the
concept of flushes/refreshes, the interface can just be a noop, and we
can document that writes are useless (or even print something in dmesg).

So no objections from me.

> 
> We're planning to deploy container workloads on these servers where memory
> statistics drive placement and resource management decisions. Having an explicit
> flush interface would give us confidence that when precision matters (e.g.,
> admission control, OOM decisions), we can get accurate stats on demand rather
> than relying on timing or hoping the 2-second periodic flush happens when needed.
> 
> I understand this is more of a "preparing for future needs" rather than "fixing
> current production breakage" situation. However, given the interface provides
> opt-in control with no cost to users who don't need it, I believe it's a
> reasonable addition. I'll prepare a v3 with the dedicated memory.stat_refresh
> file as suggested.
> 
> Thanks,
> Leon

