Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 748C4EE57D7
	for <linux-mm@archiver.kernel.org>; Wed, 31 Dec 2025 15:25:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 67C556B0088; Wed, 31 Dec 2025 10:25:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 629966B0089; Wed, 31 Dec 2025 10:25:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 527AE6B008A; Wed, 31 Dec 2025 10:25:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 41EBC6B0088
	for <linux-mm@kvack.org>; Wed, 31 Dec 2025 10:25:56 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id BA169160465
	for <linux-mm@kvack.org>; Wed, 31 Dec 2025 15:25:55 +0000 (UTC)
X-FDA: 84280141470.22.2AC8F40
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id 2F90A120004
	for <linux-mm@kvack.org>; Wed, 31 Dec 2025 15:25:54 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="s/MiUlto";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of frederic@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=frederic@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767194754; a=rsa-sha256;
	cv=none;
	b=doE/vDRxwCavzxoI3VZOp215DurkG9bRmcujVMTrPO5LL3H+6zPCkby6jythHBUyZaQjEf
	ZgzjhFgz7wCVnkqLCVOv3lAOIh4XNnfXq3Dl795xqBsbUYgVxKDOMCmlcvykz49aAYxypf
	ILwfomoTsp7kTNIVZ1bfhAxFnD8IJec=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="s/MiUlto";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of frederic@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=frederic@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767194754;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2pdAd0KBpKEzOG9SIUhcuMaXAWyHGcb00rsjHnz/GSg=;
	b=CX4XTvHxN+LII1AqI+MNwPDZsDi6eBy+SeLKsRBX4tzASCPXzEZ6SSTic9jvFOAAGT9CpW
	5qzBiww+0e4xXx+4UJadhtWekpDf/ad/7dzU8YHKNbSo/2FZmXx/V7l+SuEiTf2M2mkeNy
	o+A2gDkhAQ3OHVFGbJdTSaWsE0siyRE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 4977B60008;
	Wed, 31 Dec 2025 15:25:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72AAFC113D0;
	Wed, 31 Dec 2025 15:25:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767194753;
	bh=3zCSe0pygUa6B0hxj7uhQQbY3y5VvVFZcfM1W6inRQ8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=s/MiUltoCktzz6D0wiCqcLuak2qC1jPP+t9uF/Wpp9NyhlhUYJRh4a7DANVK3dS3Y
	 5TBAIkOcZD7Uzm31uIRNg+KPXeRfrFDCHo5KImNpcVVxeo6H0CXL4UnXKcwUINX/Ll
	 U1vQ9nn+42I+5DqP4hDp4p5tUlokQFV23MAaxYG5+JRLq2JJ2SJ1zhhHcouBH7kW4n
	 j7tnzqkJRksmGaZ82fg+JWX+rpM1JKmvmvmVA/5WAT8i/ukuaEkGR1UaA6w9uc8YRq
	 7msaf9wYLApzpxDT1X8VKz50GKA//Mk01dWdH2ak+Kw+9n2yKX+4XwtHIVWi3pdEqj
	 QbzdgFhA2MRZA==
Date: Wed, 31 Dec 2025 16:25:49 +0100
From: Frederic Weisbecker <frederic@kernel.org>
To: Waiman Long <llong@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
	Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Chen Ridong <chenridong@huawei.com>,
	Danilo Krummrich <dakr@kernel.org>,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Gabriele Monaco <gmonaco@redhat.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Ingo Molnar <mingo@redhat.com>, Jakub Kicinski <kuba@kernel.org>,
	Jens Axboe <axboe@kernel.dk>, Johannes Weiner <hannes@cmpxchg.org>,
	Lai Jiangshan <jiangshanlai@gmail.com>,
	Marco Crivellari <marco.crivellari@suse.com>,
	Michal Hocko <mhocko@suse.com>, Muchun Song <muchun.song@linux.dev>,
	Paolo Abeni <pabeni@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>, Phil Auld <pauld@redhat.com>,
	"Rafael J . Wysocki" <rafael@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Simon Horman <horms@kernel.org>, Tejun Heo <tj@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Vlastimil Babka <vbabka@suse.cz>, Will Deacon <will@kernel.org>,
	cgroups@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-block@vger.kernel.org, linux-mm@kvack.org,
	linux-pci@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 33/33] doc: Add housekeeping documentation
Message-ID: <aVVAfb2eaeyd7l-h@localhost.localdomain>
References: <20251224134520.33231-1-frederic@kernel.org>
 <20251224134520.33231-34-frederic@kernel.org>
 <370149fc-1624-4a16-ac47-dd9b2dd0ed29@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <370149fc-1624-4a16-ac47-dd9b2dd0ed29@redhat.com>
X-Rspamd-Queue-Id: 2F90A120004
X-Rspamd-Server: rspam03
X-Stat-Signature: zj3os54pcdfns8oka15q1u1wo6hj8ztm
X-Rspam-User: 
X-HE-Tag: 1767194754-408084
X-HE-Meta: U2FsdGVkX1/YOy+85BrEMtSM4218xb9N4K3plhUPuemEdnAFxp1gEi1n3vVBr6+zrcJ9Th+t2VbKu74makgnytagHVyDRfWg3RyVGT8zAunlYsM4IJ4nJLcQKly7MQ23rfpFBKugXa2DIsk5TA7wXOChnjCweFEdfS6CvYO231WNhF70XL41kBoUBSnyllDhPaEzKSUdvzSgdOFTcYKGfHDgIFnIQ9agwhnawtPfAvhnuSQvlaRR45PzQt19G5JBMh6nZEZeM833ZzlIn5QSY4asdYHQDB620RqY4oYfj/CF0pAjC6bUgpUcCkjbXJoQoBYSYhU8/p3KRShPCkFUNj223BdP7Y1+p0EcEJwAR4D8hXqzrlI2HNcrKZjkUHan4K9DYs3ZRfFoLapElZ0WUWWCKe4j7pQKDj2f+W92B8XbBTNuR9e5WkkdyT5KPLAjOqWVPT11Ei9+4TH+tevIYGed31sKFMvwUtMeRhJSS/YHuWN4EgF1w7JhPK0Gfq8wSX+lsQQCVo7iZKbgfeXccY7i0iZ43KMbAnDhUUYJvGAVfsQDhePtEChjwiSarAofaF143i7418+tTDract+GaQ0jLC26jk29H0jueMRvZa8VUidC1nOnthvibx0/MlTvYIKuRKak5e8L7SD3xDFe0cV7Ikzq3NFbBqgl17x/3PbXqvk9uJw/+e2aPRxZBO7cqClGrOBBPM8n9qXu2UegneDcAyhy6P6wm2IizFPwj6Z9Yu0bX29iYr1n01tP2juXlzbwhrZXqBVGkGhCIV/jps6nEvDolaNbXwTNWtn0XK6hlmdj5dZSPfQFE8W/NsAu7nYbLXpM/r5AgjzmskJ2TfRCUMq1FM2wnlkvtu+FjPEbAZZRldSnE4SxZ5q/UoePPw/6ps2gUoyxtMjk4orR8RsYV2/gDM5W6RoJOagddL/1uUzQLdPV3S22lmA9U7lT5U/5yJ4MA1uOPnJ27pi
 mbPt4/3F
 yczyFp0PCTXXOihfOIqEjKguYg36sDf8w11ylr1eyAwEWbu2kx9mea4hY7CKy6VuX7yYWxqIUSb5R2NbFxjsWXW4QrQQQaV/9qWm982Otn1XAad90iJqleovEaP0LYmrf22fNaROWQRQSHMjmx0+hSWXdRcD7WbaJ7JOznNcnzPHNjYsbJuN+Y2WVqw+MxnBJ1K74+NrZOFzvUC3AaPPHNaTDR6ZAu7u+WLP3ScRuJqqfrQmac/2D8px1aQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Le Fri, Dec 26, 2025 at 07:39:28PM -0500, Waiman Long a écrit :
> On 12/24/25 8:45 AM, Frederic Weisbecker wrote:
> > Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
> > ---
> >   Documentation/core-api/housekeeping.rst | 111 ++++++++++++++++++++++++
> >   Documentation/core-api/index.rst        |   1 +
> >   2 files changed, 112 insertions(+)
> >   create mode 100644 Documentation/core-api/housekeeping.rst
> > 
> > diff --git a/Documentation/core-api/housekeeping.rst b/Documentation/core-api/housekeeping.rst
> > new file mode 100644
> > index 000000000000..e5417302774c
> > --- /dev/null
> > +++ b/Documentation/core-api/housekeeping.rst
> > @@ -0,0 +1,111 @@
> > +======================================
> > +Housekeeping
> > +======================================
> > +
> > +
> > +CPU Isolation moves away kernel work that may otherwise run on any CPU.
> > +The purpose of its related features is to reduce the OS jitter that some
> > +extreme workloads can't stand, such as in some DPDK usecases.
> Nit: "usecases" => "use cases"

Are you sure? I'm not a native speaker but at least the kernel
has established its use:

$ git grep usecase | wc -l
517

> > +
> > +The kernel work moved away by CPU isolation is commonly described as
> > +"housekeeping" because it includes ground work that performs cleanups,
> > +statistics maintainance and actions relying on them, memory release,
> > +various deferrals etc...
> > +
> > +Sometimes housekeeping is just some unbound work (unbound workqueues,
> > +unbound timers, ...) that gets easily assigned to non-isolated CPUs.
> > +But sometimes housekeeping is tied to a specific CPU and requires
> > +elaborated tricks to be offloaded to non-isolated CPUs (RCU_NOCB, remote
> > +scheduler tick, etc...).
> > +
> > +Thus, a housekeeping CPU can be considered as the reverse of an isolated
> > +CPU. It is simply a CPU that can execute housekeeping work. There must
> > +always be at least one online housekeeping CPU at any time. The CPUs that
> > +are not	isolated are automatically assigned as housekeeping.
> Nit: extra white spaces between "not" and "isolated".

Somehow it has disappeared in my tree, some Brunaidh must have fixed
that while I was sleeping. That's nice!

> > diff --git a/Documentation/core-api/index.rst b/Documentation/core-api/index.rst
> > index 5eb0fbbbc323..79fe7735692e 100644
> > --- a/Documentation/core-api/index.rst
> > +++ b/Documentation/core-api/index.rst
> > @@ -25,6 +25,7 @@ it.
> >      symbol-namespaces
> >      asm-annotations
> >      real-time/index
> > +   housekeeping.rst
> >   Data structures and low-level utilities
> >   =======================================
> Acked-by: Waiman Long <longman@redhat.com>

Thanks! 

-- 
Frederic Weisbecker
SUSE Labs

