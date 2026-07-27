Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2F109C531D0
	for <linux-mm@archiver.kernel.org>; Mon, 27 Jul 2026 20:49:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BD7536B008A; Mon, 27 Jul 2026 16:49:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B87E86B008C; Mon, 27 Jul 2026 16:49:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A9DE26B0093; Mon, 27 Jul 2026 16:49:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 7C60F6B008A
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 16:49:09 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D9406C01E4
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 20:49:08 +0000 (UTC)
X-FDA: 85035746376.17.1B2FE38
Received: from out-177.mta1.migadu.com (out-177.mta1.migadu.com [95.215.58.177])
	by imf06.hostedemail.com (Postfix) with ESMTP id 89B28180002
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 20:49:06 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=oFDB5P8n;
	spf=pass (imf06.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.177 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785185347;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FFvaZkohkm528INkbN+EO7pcO2PxXj1dIjGSZDzFMIg=;
	b=iYGB8WoUCjSt6yW3p32J+0mPVHQYN0lHpmvzNzNp05e/N7OjT10lBUfZ401qDkj2uZqwKs
	eXnwTJCjUumgLQntqIJONmb1kNn6daM52uLPCHAyY7VXhiyTko7NHK3NMFFREtK4diHfAA
	+20dmRzYGodgUJbVgY2wN0IJ+rCSVFQ=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=oFDB5P8n;
	spf=pass (imf06.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.177 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785185347;
	b=LEQ8QPT648GOuosPRB1REAE5t/DgW/ZbuGMEhKNUZYG71lHty9wvBVqXWctcOxz4Kqe1yW
	ik4e0SvS9qNxMXrA7LouoDehcFhlxqmy0DuGX0l5Aob8J4MDTbIJn/0+irQ1vbfAp5AEc7
	eZwfIs7PV5A5d77wi8pTt8VGM/0AYpA=
Date: Mon, 27 Jul 2026 13:48:58 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785185344;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=FFvaZkohkm528INkbN+EO7pcO2PxXj1dIjGSZDzFMIg=;
	b=oFDB5P8n2pxOC9LeWJdqJfFQi0V+c/ConSiq6qsRnZqmzeEf4tmIRQU6+h264HoTbcAESP
	JH6T+IX8GwIpDwVJGCjZWMThhb13j4eD5V5MvQBTIXkee1+lh62bvAeV6NYlHP2ij1hc5g
	TfJmYfDldJRhnmE7pa1n2zDLdm9QByM=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Michal Hocko <mhocko@suse.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Rientjes <rientjes@google.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
	Suren Baghdasaryan <surenb@google.com>, Usama Arif <usama.arif@linux.dev>, 
	Peter Zijlstra <peterz@infradead.org>, Darren Hart <dvhart@infradead.org>, 
	Davidlohr Bueso <dave@stgolabs.net>, =?utf-8?B?QW5kcsOp?= Almeida <andrealmeid@igalia.com>, 
	"Liam R . Howlett" <liam@infradead.org>, Yosry Ahmed <yosry@kernel.org>, Rik van Riel <riel@surriel.com>, 
	Nhat Pham <nphamcs@gmail.com>, Meta kernel team <kernel-team@meta.com>, linux-mm@kvack.org, 
	cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC] Robust futex causing memcg OOM storm on exit
Message-ID: <ame7Q-0eVRrtt34j@linux.dev>
References: <20260723001908.4046643-1-shakeel.butt@linux.dev>
 <amds50dIVOiQNz0k@tiehlicka>
 <amd6N4DVzZkl90cs@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <amd6N4DVzZkl90cs@linux.dev>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 89B28180002
X-Rspam-User: 
X-Stat-Signature: rkpyiewj64kjb5zr3pyd4mduy8mnx5o3
X-Rspamd-Server: rspam04
X-HE-Tag: 1785185346-745061
X-HE-Meta: U2FsdGVkX18DB3NuIIHtmlbob4L+xvZ8fVsScF6uaQGSMG1s3Q6VeU49oNLrBOZ/A+HaWLKmQfPikWpmaNDOzRsi+ZrM9X9U5RYc1oc9XRUXVaVvZTk/ja+8U0an8tJY4IgpJYqXr70Ay6GFARsIdjhT9T1yaJrxjDo+3rxKXN7t5JpS0oId7or5rxaTSQOvoPMQkaXu3wkTdpk3Ve9HjFJsWQV3UanJDeiWaquMXKmaWDak/WsIg/SqPmmMC58b3NTKMXQW7aUXEXu/2m3D9Go+rWet+l4LfZhv+5PUVEjVMqzjwYQT6dGgoerTJIDLGXoGLz+i27E5m+B26nve0gh1nsa8bW7BNwe/yvGfGymhcTIsnYhK+pyx9MGqwPdJKlPQtatx4MAx4ImEKq9OKU8/5Jt+FFer5uW5Aij6w9KFslpzLhmxIBsvzyxb2Qd+CX9HnDidoiD3dWArBY8rUlK3LscpuLlQeaZFD7rhbt854EFO/88KNmXKGY0y5gJfAeLGEYXdMFFCHVGiqvqnOumxnE++XMyZckL/ZdgoQyupmuuv6MPtIOE5rM4HwSldPFAyE1b9IJ4Q4bKMA9ZPlY47d+NnFqM4luATQztpn00D5x9jQMpb4QY28mW1e35cG1pHiLDkxSqsdGWweGHo2rgGaZGM71FwsVJ0I4o3M4xIWSkxFDRX7GOIvWXJs/MAcUS4B4cW9r00SJSa6z8GFFjHPNBp5NAJkxrEnZdVXNt4Ed+TAPlOzrw2xr4eUXyVChsY+dvCmlxNSnb9vBoGY2EIs7J9KBHhxUZcnpX1ZLnmSVl9XRpPfUmQdtuH5xYP6EUAzLNbrFcEEuURAJxVLzP10uN8FRRotpK/j/FGN6IMdFDI3Z5Kk4fiSVpXC827Pl3E/plSY7kLXCuG9Paj8V2ic/17pdx3Zdmj4rtzDejOsp6AUpUuVC4Kl5UgENl8yQQJRyxxeRL3aVgPnrn
 JoNkITtG
 hkeSptkSiAPy04EaTV5iu+BQPm4pspDol80thjB1OerRy50SDFCXoTgRbp1OIep32CXABozbvM/P4QZ8Uzq5++3y8fVNlP9jIXrhOL0MhsP3GYoNCpbs+1MRQXL9gTseGFvSajh47xa4rUKLhUZ/Md19WVgkwI5fgUls684q/Uu/eWa6RUxB7BdX48KGj3B10U0wNXVUOxjORFksAaMJLLpGWNg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 27, 2026 at 08:38:37AM -0700, Shakeel Butt wrote:
> On Mon, Jul 27, 2026 at 04:36:23PM +0200, Michal Hocko wrote:
> > On Wed 22-07-26 17:19:07, Shakeel Butt wrote:

[...]

> > 
> > TBH I am not entirely happy about this approach. It effectivelly reverts
> > a75ffa26122b ("memcg, oom: do not bypass oom killer for dying tasks").
> > It just makes it lockless. Assumption that a dying task will do so
> > quickly and with bounded resources has turned wrong on several
> > occasions.
> 
> That's why I kept it as RFC :)
> 
> > 
> > On the other hand I do undestand the contention issues and I can imagine
> > that the existing solution doesn't really work well for huge thread
> > groups that all end up lining up on the oom_lock just to learn there is
> > nothing really killable anymore because they are the oom victim...
> > 
> > Would it be just safer to bail out only for oom victim threads. This
> > would narrow down potential runaways for oom victims which should be
> > more limited than any killed/exiting task. It would also give the oom
> > killer/reaper chance to work. WDYT?
> 
> I will give the following patch a try with the reproducer I have. I am still
> improving the reproducer as I am still not able to recreate multi hour slowdown
> yet. I will report back once I have some results. 
> 

I have some results with the reproducer I (AI) wrote.

Setup: 20k threads, each with its robust_list head on its own page in a
large anon region pushed into a zswap pool (writeback off, so it's
unreclaimable and pins the memcg at the limit). On the OOM-group-kill
every thread faults that page in futex_cleanup() -> do_swap_page() ->
swapin charge -> memcg OOM. A separate thread holds mmap_lock for write
in a loop so the oom_reaper can't reap the pool -- matching the host,
where the reaper was blocked and the memcg never fell below the limit.

I tested on next-20260726 as baseline and then tested your suggestion over it.
For baseline ~48k no-victim OOM invocations serialized on oom_lock; ~40s to
drain the 20k threads in a VM (hours on the host, where each invocation
was a dump_header over netconsole). With the patch the dying tasks stop
entering out_of_memory and the storm is gone.

With the following suggestion, the threads of dying tasks stop entering
out_of_memory but the exit time doubled as each thread has to decompress the
page from zswap.

	if (tsk_is_oom_victim(current))
		goto force;

I also tested by replacing goto force with goto nomem and the exit time halved
i.e. ~20 seconds. Looking deeper it seems like each thread is still going
through the reclaim loops.

Just for testing purpose I moved this check along with goto nomem just before
the reclaim fuction i.e. try_to_free_mem_cgroup_pages() and the exit time falls
below 1 second. I think what we need is to detect early that the cgroup is
unreclaimable and the threads of exiting/reaped process should just return with
enomem.

