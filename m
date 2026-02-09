Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 64769E81BD3
	for <linux-mm@archiver.kernel.org>; Mon,  9 Feb 2026 16:40:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7E3746B0088; Mon,  9 Feb 2026 11:40:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 791026B0089; Mon,  9 Feb 2026 11:40:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 673056B008A; Mon,  9 Feb 2026 11:40:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5449F6B0088
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 11:40:57 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id EE63DC092A
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 16:40:56 +0000 (UTC)
X-FDA: 84425482512.21.77895AF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 2037CA000E
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 16:40:54 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KU8YatN0;
	spf=pass (imf15.hostedemail.com: domain of "SRS0=i6U4=AN=paulmck-ThinkPad-P17-Gen-1.home=paulmck@kernel.org" designates 172.234.252.31 as permitted sender) smtp.mailfrom="SRS0=i6U4=AN=paulmck-ThinkPad-P17-Gen-1.home=paulmck@kernel.org";
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770655255;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FPTx3uzBs5Lxru+hVNimFyvCcCFIZWE2WVm1w1dI4+E=;
	b=cXhhjxSakr+pYzwPE5yvdkOQYSpl9EiIhXKsC0KfEJelfI8R216SjScOILQHCBExQYFhBC
	Nbw1TU7AZp+pO4aZwHLybcpgEQQuHP66fr0xTYBJA9vPex0uhPMCM3n6jWGEzwBlKK26p4
	90pyLcrtk4utdFs+BDuPQE+PhFu/31w=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770655255; a=rsa-sha256;
	cv=none;
	b=EdtLVIWHZyYIoqjs+7jl94kG2a9ve48aWZ3ucx+A6GCv9WYf4HQmYEtJhQ02HULEl+8nFz
	/Jr53MC64GPNtiyrrfLqnnfi7zrerbsqpRF8u+UP/+3v60QoovBrCS+OgyN7K7eO54dx0l
	OZL1swWZYLmIThCUyW4/j38PM2mcPuI=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KU8YatN0;
	spf=pass (imf15.hostedemail.com: domain of "SRS0=i6U4=AN=paulmck-ThinkPad-P17-Gen-1.home=paulmck@kernel.org" designates 172.234.252.31 as permitted sender) smtp.mailfrom="SRS0=i6U4=AN=paulmck-ThinkPad-P17-Gen-1.home=paulmck@kernel.org";
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 0D93043D17;
	Mon,  9 Feb 2026 16:40:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D61B5C116C6;
	Mon,  9 Feb 2026 16:40:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770655253;
	bh=lARbkbntWGtDhEXk7qoEkyADOxVnx/IfWT0MwbUrRfg=;
	h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
	b=KU8YatN0GgoQMo7vohVj2AM0aYLcVLS/YXu4d+X/qih4Q0bXpBGmIdAQGhd52fL0m
	 AvSZ3CV69yKen1Ps18FYU9lFPKRqYD3TQkCV+jfOmlZJWLpGcu6oaJ+ZMmwHNeDFTb
	 42QL5pAXF9rECbSelJ8TvZ/yvgISxF0oWlekqTNvxZZKtyQQ4HyyG0eqbf+2pWbUnx
	 c3pIlN1X0ZHIwcRvpDDd7P5I9Yh7wabs+2uH/wf7i7xL1qH5PNokxUj5hGvpxiFbz3
	 AKnvuGfyO2wvuXq5cMWa1GhpP4XKSJRqnqtE68gHOzU0heiqQE0Ik6f8E1K1RH/VpK
	 pcTPZqbL46OUw==
Received: by paulmck-ThinkPad-P17-Gen-1.home (Postfix, from userid 1000)
	id 5AFA1CE1105; Mon,  9 Feb 2026 08:40:53 -0800 (PST)
Date: Mon, 9 Feb 2026 08:40:53 -0800
From: "Paul E. McKenney" <paulmck@kernel.org>
To: Harry Yoo <harry.yoo@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@suse.cz>, Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Michal Hocko <mhocko@kernel.org>, Hao Li <hao.li@linux.dev>,
	Alexei Starovoitov <ast@kernel.org>,
	Puranjay Mohan <puranjay@kernel.org>,
	Andrii Nakryiko <andrii@kernel.org>,
	Amery Hung <ameryhung@gmail.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Frederic Weisbecker <frederic@kernel.org>,
	Neeraj Upadhyay <neeraj.upadhyay@kernel.org>,
	Joel Fernandes <joelagnelf@nvidia.com>,
	Josh Triplett <josh@joshtriplett.org>,
	Boqun Feng <boqun.feng@gmail.com>,
	Uladzislau Rezki <urezki@gmail.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Lai Jiangshan <jiangshanlai@gmail.com>,
	Zqiang <qiang.zhang@linux.dev>, Dave Chinner <david@fromorbit.com>,
	Qi Zheng <zhengqi.arch@bytedance.com>,
	Muchun Song <muchun.song@linux.dev>, rcu@vger.kernel.org,
	linux-mm@kvack.org, bpf@vger.kernel.org
Subject: Re: [RFC PATCH 0/7] k[v]free_rcu() improvements
Message-ID: <14281c04-a14d-43ef-8433-a780230838c2@paulmck-laptop>
Reply-To: paulmck@kernel.org
References: <20260206093410.160622-1-harry.yoo@oracle.com>
 <3069e76d-5c7a-4c3f-9b83-43ed1700b95f@paulmck-laptop>
 <aYaTluYIbqt7xSC5@hyeyoo>
 <a49009d1-a0f7-4111-a148-c94fc6e506b9@paulmck-laptop>
 <aYmivqZKklspsa_8@hyeyoo>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aYmivqZKklspsa_8@hyeyoo>
X-Rspamd-Queue-Id: 2037CA000E
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: sak9peiwyg3x1oqhfxwz8iuhf4z8fjrz
X-HE-Tag: 1770655254-248668
X-HE-Meta: U2FsdGVkX19Egu1aNbcyBZWR1Ff18jPEL3UtFtB/WuExXogJ9pk7YQuZozHk6IxCuI+/6nBR/THlCC956NpNJeubgHfF9sqCm3LC+v/QvMr5BakDe5AlOswWdFC2exnIzRebK5hHz0TMwhzet8thK4Ib/IRDevel9u7ox5CG9YzU9qoa/glYhnmfXklK3mlSGT/TahxmS+y8XAz+c5CjnY7dUF2RMqcc5Zz7/X/H7ausgkLpl46vZWO6y6vczqXoJPgQfKukpDNK8vm2IjIys1XI2fI9sFBNMauY4uekiPtCf8RunQ6+q6G90LwKTCGIcxMZfdJjV7FYQLoZFwtJ2zIv2hzWe3GgbHT5QiSBGMGbsCX5By769e27G0lvqgrTlrjcH5ypxx7L3sCqHhdHiD79WIU4Ft9kAE5Hnp+tMHEa/y+nik3m3a1tYu6tAtchyDOINAiKjG3vKp+JXUGTtoKTazHtlK6sbLnb1I9qp0knFfMcZngldd+0iYWFbnfF1gxTW/4lNwIBpKKBRIG4fNn++ZunLfeuN96OaJdtufsVsctyfywPpeid3TCmAdF6bTzom7LlyfFsmWjkigG4tc5uLfd4o1TRVnyoMJRi0vwRCkPgKCaG7Gfit1C6O2UeoNmG+ev/IMB9hW0+ljlptieC/I0R4VKV3fIqKMedXfMWxCpFzGViHSau0yEEdScYG3WbBrpqZBtCW5r8hRtroMd+zdLPiVFd9z0HcLAmjo0ez5Chx9f3A3Lj7UZ8S7evJQAsD+KZpgnJdAOS1/0g7aIyzhdzzxQWKffNutvW3CBCBIxTvZE9WnlHniM6nklAM6incha1vgB/O6IalrYj/X8hCyyQxvLhMh9vI7LicbpDjAXti7PS0tcnAqofRn7B+4Sa0mHuUP2EU3aDI8Go9tpu+svFBoq1aiK7XBWagZm9oOLESmOk1lSO9S7abYbaNndSOCS0hSOoddCmCvz
 SXxxsOBm
 EyGCmwubvKDOhRZzWN/JNKNctFSOsqk1oJZXHuhy2ilx9Hnbo/+z14w2nmRFpsklUpz/4PaR/kCPGYtTecpc05kSV2UncsVyUQMM5TgYMT1Oweq6c0SxnZlvr2twkQ1GsiPYQiAZBkeCZjIL97v0wgek3MlkkyytKRBkybNtPQt7ev2jcH6NqxGYv1Lgfavld9mOce76VeuvuCLqg+4DwFfQ6h3EpwrWGzeiCe3wF2SV70N1b+MHqwjSb4BcrFyYAYXprSxAl0LofRqb4QBSToaJgNkTYy7QVCnNdx9ZgNTHF7p9KivzCIxWKEGxNVcQujuZM1FOMwzC8utSnel1aBhiaNHVGXCfNlfj9iMoFnPpSIoyBIIsV448RfzLdDvGemXT+lu2ejekwmpJ7jJqxBE3xKaotslmyd8vxuJjC5/WtKjfAOflRxprAIqynb+R2h7xp+M1CLhAUBcKfN4dk0Qw7Vqcu9RrUdtMyYiO28C4NY/N4nNFsH53R/8lNXAGwEVDD/DAxIm7VMfx3KCHgx+dnywiRDkmSaUgHoblnigyCWkdo73t8JftiSGVvOJ1tN9yND3idapov9Sn5ZJrONZRCxvkH1pgZENVuuj8ZNKQWA474w8CifZBPyiupVxBb3EpLh/g8Nu+igOk9hea9lMUJpPYCdDKTDjCHEfXIyK22ymbXIB9kCJ+ZzJx0MeIbA1BpuGgf7D0stqm+NP5qB7Vt7EnUwRB1HjzeAIdS3lkv3/0r34JfIimw31Zk1cAsWZ5ySz2Ow9w9aHFjtzsxExH82/QYX85vZxt8tC0Hxya70mNs7i/NItWaIQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Feb 09, 2026 at 06:02:54PM +0900, Harry Yoo wrote:
> On Fri, Feb 06, 2026 at 05:33:52PM -0800, Paul E. McKenney wrote:
> > On Sat, Feb 07, 2026 at 10:21:26AM +0900, Harry Yoo wrote:
> > > On Fri, Feb 06, 2026 at 04:16:46PM -0800, Paul E. McKenney wrote:
> > > > On Fri, Feb 06, 2026 at 06:34:03PM +0900, Harry Yoo wrote:
> > > > > These are a few improvements for k[v]free_rcu() API, which were suggested
> > > > > by Alexei Starovoitov.
> > > > > 
> > > > > [ To kmemleak folks: I'm going to teach delete_object_full() and
> > > > >   paint_ptr() to ignore cases when the object does not exist.
> > > > >   Could you please let me know if the way it's done in patch 3
> > > > >   looks good? Only part 2 is relevant to you. ]
> > > > 
> > > > On what commit should I apply this series?
> > > 
> > > It's based on Vlastimil's slab/for-next:
> > > 
> > > bc33906024eb Merge branch 'slab/for-7.0/sheaves' into slab/for-next
> > > https://git.kernel.org/pub/scm/linux/kernel/git/vbabka/slab.git/log/?h=slab/for-next
> > > 
> > > > I get conflicts on top of -rcu
> > > > (no surprise there) and build errors on top of next-20260205.
> > > 
> > > Interesting, I don't get build errors when applied it on top of next-20260205.
> > 
> > Here you go!
> > 
> > Here is my repeat-by for these build errors, perhaps a .config issue
> > or difference:
> > 
> > tools/testing/selftests/rcutorture/bin/torture.sh --do-none --do-kvfree --do-kasan
> 
> Haha, thanks! The kernel test robot reported the same issue on the
> weekend. It seems I forgot to include <linux/irq_work.h> and it's
> accidentally included on my environment.
> 
> Adding #include <linux/irq_work.h> in mm/slab_common.c fixes this.
> Will adjust next time I post it, thanks!

Very good, and I will give the update another spin.

							Thanx, Paul

> -- 
> Cheers,
> Harry / Hyeonggon
> 
> > 							Thanx, Paul
> > 
> > ------------------------------------------------------------------------
> > 
> > mm/slab_common.c:1475:21: error: implicit declaration of function ‘IRQ_WORK_INIT’; did you mean ‘IRQ_WORK_VECTOR’? [-Werror=implicit-function-declaration]
> >  1475 |         .irq_work = IRQ_WORK_INIT(defer_kfree_rcu),
> >       |                     ^~~~~~~~~~~~~
> >       |                     IRQ_WORK_VECTOR
> > mm/slab_common.c:1475:21: error: initialization of ‘struct llist_node *’ from ‘int’ makes pointer from integer without a cast [-Werror=int-conversion]
> > mm/slab_common.c:1475:21: note: (near initialization for ‘krc.irq_work.node.llist.next’)
> > mm/slab_common.c:1475:21: error: initializer element is not constant
> > mm/slab_common.c:1475:21: note: (near initialization for ‘krc.irq_work.node.llist.next’)
> >   CC      drivers/tty/pty.o
> > mm/slab_common.c:1477:17: error: implicit declaration of function ‘IRQ_WORK_INIT_LAZY’ [-Werror=implicit-function-declaration]
> >  1477 |                 IRQ_WORK_INIT_LAZY(sched_monitor_irq_work),
> >       |                 ^~~~~~~~~~~~~~~~~~
> > mm/slab_common.c:1477:17: error: initialization of ‘struct llist_node *’ from ‘int’ makes pointer from integer without a cast [-Werror=int-conversion]
> > mm/slab_common.c:1477:17: note: (near initialization for ‘krc.sched_monitor_irq_work.node.llist.next’)
> > mm/slab_common.c:1477:17: error: initializer element is not constant
> > mm/slab_common.c:1477:17: note: (near initialization for ‘krc.sched_monitor_irq_work.node.llist.next’)
> >   CC      drivers/tty/tty_audit.o
> >   CC      net/ethtool/eee.o
> > mm/slab_common.c: In function ‘kvfree_call_rcu_ptr’:
> > mm/slab_common.c:2097:25: error: implicit declaration of function ‘irq_work_queue’; did you mean ‘drain_workqueue’? [-Werror=implicit-function-declaration]
> >  2097 |                         irq_work_queue(&krcp->sched_monitor_irq_work);
> >       |                         ^~~~~~~~~~~~~~
> >       |                         drain_workqueue
> > 

