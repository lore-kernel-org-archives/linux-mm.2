Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4580BE9E311
	for <linux-mm@archiver.kernel.org>; Wed, 11 Feb 2026 15:43:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7C1D76B0093; Wed, 11 Feb 2026 10:43:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 451FB6B0095; Wed, 11 Feb 2026 10:43:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2B9376B0096; Wed, 11 Feb 2026 10:43:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 1D9166B0093
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 10:43:14 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id DFD68B8270
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 15:43:13 +0000 (UTC)
X-FDA: 84432594666.01.F942847
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf30.hostedemail.com (Postfix) with ESMTP id 32D788000D
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 15:43:12 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=UDb9hAux;
	spf=pass (imf30.hostedemail.com: domain of mtosatti@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mtosatti@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770824592;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wE7la7K/IKWK0kSdZLLaAcmHE3mv3hvFTPaHbiBOxk8=;
	b=Z3KPN+88RoY9o/xpiVimySx7ByF9oKvRNTEbqWIppzusN0Kz5REU4mG+xgWTsHxT4w2cw+
	ATgv56XkpzzN+4jjMvOuySEgT/bG54v3q86CxQQZNmGVGwOjbB8i9KoT9PK7Bzo7oCyo/N
	UwhqTrcRSUxwnF79ft/+7mXp+sf5V/A=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=UDb9hAux;
	spf=pass (imf30.hostedemail.com: domain of mtosatti@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mtosatti@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770824592; a=rsa-sha256;
	cv=none;
	b=GOObWkxe14Px2nywllikds3trUevnSdG4oaSPy4vOm24gVQTgxnA+7TwU1/gntnSpO8OcZ
	+PjEF2ovRC1pSArtolMqyxjKpKHNY8sUS7RFbIrPNzNynyYO9fix07q/XacjNi2oFP6Lul
	+wcIRrxU1B8QWScl53oct29zVtaL1xQ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1770824591;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=wE7la7K/IKWK0kSdZLLaAcmHE3mv3hvFTPaHbiBOxk8=;
	b=UDb9hAux+qJH2e75ZO/z/a2h9EOA84fAhccaZ1tiGzSSYLt9La2GZ/mI2gdyrN7Msr/2We
	KBM1XxMNVsylYQyFxMik0dIV3N2FFWfl4xem+EgbeSd4Om+e1PDfPMNP1r+imRVTYht2CM
	AojUOG4YviyG8UJA6zPGy62DQLl+ZpE=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-61-CvMfWgf9MqKHQQmxAVGhcg-1; Wed,
 11 Feb 2026 10:43:06 -0500
X-MC-Unique: CvMfWgf9MqKHQQmxAVGhcg-1
X-Mimecast-MFC-AGG-ID: CvMfWgf9MqKHQQmxAVGhcg_1770824584
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 0E0861955F28;
	Wed, 11 Feb 2026 15:43:04 +0000 (UTC)
Received: from tpad.localdomain (unknown [10.96.133.3])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 0F7911800668;
	Wed, 11 Feb 2026 15:43:03 +0000 (UTC)
Received: by tpad.localdomain (Postfix, from userid 1000)
	id 7DAC1400DF589; Wed, 11 Feb 2026 09:11:21 -0300 (-03)
Date: Wed, 11 Feb 2026 09:11:21 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Michal Hocko <mhocko@suse.com>
Cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
	linux-mm@kvack.org, Johannes Weiner <hannes@cmpxchg.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>,
	David Rientjes <rientjes@google.com>,
	Joonsoo Kim <iamjoonsoo.kim@lge.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Hyeonggon Yoo <42.hyeyoo@gmail.com>,
	Leonardo Bras <leobras@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Waiman Long <longman@redhat.com>, Boqun Feng <boqun.feng@gmail.com>,
	Frederic Weisbecker <fweisbecker@suse.de>
Subject: Re: [PATCH 0/4] Introduce QPW for per-cpu operations
Message-ID: <aYxx6cq6he6jTIZI@tpad>
References: <20260206143430.021026873@redhat.com>
 <aYs6Ju2G4bm6_tl2@tiehlicka>
 <aYxviLoWsrLqDU7o@tpad>
MIME-Version: 1.0
In-Reply-To: <aYxviLoWsrLqDU7o@tpad>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Mimecast-MFC-PROC-ID: 4h4xWowPss_Tbp3VuWbWN3RVyddRbFMGtLIIe7vdIcg_1770824584
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Stat-Signature: 5p9ydsc8tqj1ai6qm3tepfu5e7cruyk3
X-Rspamd-Queue-Id: 32D788000D
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1770824592-732496
X-HE-Meta: U2FsdGVkX18tqKANU0CWev8liUxje5XjYKSJ9trESiMX1LQG4OSwsmuGTMKR0tMYhje62VXaBFn1p6y/LVAbWqR5oHsLVTKEiDC+kitNVjpb68qp8z1WO+KNOl+mfR6aANCSRYRE6TkxuQWPM2lVIA5QVerRhGBHjtYPAtClJSkVjVrVrPjFx2h6rAkUCdXln4xAtqqA2P0HtYKgBikF28dxE172+8cTHh/FhtM8UGp3DCbh/s0g6F5NHRgcOoY3Dqno4zJxWoK5oDZaNfXvt2JKhoUdS2YcevBMNQ/QS5QV/WT8jFnqclfWhP0zv11JtXBDOno+9amrDfrqKOb7YcroM1qgtQW3rhGcVOyUk24o9FCDgj+C5r7A4qtG/9DEKLe4VYeSzaAm1LNxcMCtQIA0x8sTwa1PN5RmeE9oILGVzCYIziF6NUmr96iVib518U9cTK2w3SuJeEt8gdBoKUNYUvEl8BMDCjgcO0EsTsCgbqu2qlLIJgbGU2zCRt1vy0fhWESJWCe6khSyCGOfC+mueUSv6D5HpP2seeXkzAdBxVFcFf8FrsH7S8oWZk7rCuC1LUwCpDa+D1Xr77F1zKNWCwDcDYTbfC0fGiSLgjTxW752EefbgL9dJj3H5G3B4qxcKHO2ayusK1wvIH6PzRJQfUMs++/H/rGwZbodydm8JMRjjp9WietMO4S7t2H3yZyV4tFNvOLS4XYR20plMAuRXgILXzloaRQqk8mDdoaI8vnoT6o+p6tnFlEJW07POPvJqqeHuCZ+2wwGETOBlv7R6ha63L4UyCdbjV2jyWkvBHA21/20qSl6SHmVOtXaeXRx9jCehPnCI/qs6URFEs1uJtaqnBZN97s67fH85GYNlNdusuII+njWpdI3Xw77WQDmkBqbB4wKuMUyqLgt6HwBkUGLnN3CEE22NVHA31kmRtUh7IpbOYoG48ghZNx8OnSWG9iyMvYKYJBS/su
 ZihAzBc+
 Wga1SbIOU8Np+X1zK50RgclxBky7c9Tj6Iqh0fW38ExrPUzNd1j7vs05iWmKqNY119KEHDCKTKs5XYixRHmIhN0E9bg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Feb 11, 2026 at 09:01:12AM -0300, Marcelo Tosatti wrote:
> On Tue, Feb 10, 2026 at 03:01:10PM +0100, Michal Hocko wrote:
> > On Fri 06-02-26 11:34:30, Marcelo Tosatti wrote:
> > > The problem:
> > > Some places in the kernel implement a parallel programming strategy
> > > consisting on local_locks() for most of the work, and some rare remote
> > > operations are scheduled on target cpu. This keeps cache bouncing low since
> > > cacheline tends to be mostly local, and avoids the cost of locks in non-RT
> > > kernels, even though the very few remote operations will be expensive due
> > > to scheduling overhead.
> > > 
> > > On the other hand, for RT workloads this can represent a problem: getting
> > > an important workload scheduled out to deal with remote requests is
> > > sure to introduce unexpected deadline misses.
> > > 
> > > The idea:
> > > Currently with PREEMPT_RT=y, local_locks() become per-cpu spinlocks.
> > > In this case, instead of scheduling work on a remote cpu, it should
> > > be safe to grab that remote cpu's per-cpu spinlock and run the required
> > > work locally. That major cost, which is un/locking in every local function,
> > > already happens in PREEMPT_RT.
> > > 
> > > Also, there is no need to worry about extra cache bouncing:
> > > The cacheline invalidation already happens due to schedule_work_on().
> > > 
> > > This will avoid schedule_work_on(), and thus avoid scheduling-out an
> > > RT workload.
> > > 
> > > Proposed solution:
> > > A new interface called Queue PerCPU Work (QPW), which should replace
> > > Work Queue in the above mentioned use case.
> > > 
> > > If PREEMPT_RT=n this interfaces just wraps the current
> > > local_locks + WorkQueue behavior, so no expected change in runtime.
> > > 
> > > If PREEMPT_RT=y, or CONFIG_QPW=y, queue_percpu_work_on(cpu,...) will
> > > lock that cpu's per-cpu structure and perform work on it locally. 
> > > This is possible because on functions that can be used for performing
> > > remote work on remote per-cpu structures, the local_lock (which is already
> > > a this_cpu spinlock()), will be replaced by a qpw_spinlock(), which
> > > is able to get the per_cpu spinlock() for the cpu passed as parameter.
> > 
> > What about !PREEMPT_RT? We have people running isolated workloads and
> > these sorts of pcp disruptions are really unwelcome as well. They do not
> > have requirements as strong as RT workloads but the underlying
> > fundamental problem is the same. Frederic (now CCed) is working on
> > moving those pcp book keeping activities to be executed to the return to
> > the userspace which should be taking care of both RT and non-RT
> > configurations AFAICS.
> 
> Michal,
> 
> For !PREEMPT_RT, _if_ you select CONFIG_QPW=y, then there is a kernel
> boot option qpw=y/n, which controls whether the behaviour will be
> similar (the spinlock is taken on local_lock, similar to PREEMPT_RT).
> 
> If CONFIG_QPW=n, or kernel boot option qpw=n, then only local_lock 
> (and remote work via work_queue) is used.

OK, this is not true. There is only CONFIG_QPW and the qpw=yes/no kernel 
boot option for control.

CONFIG_PREEMPT_RT should probably select CONFIG_QPW=y and
CONFIG_QPW_DEFAULT=y.

> What "pcp book keeping activities" you refer to ? I don't see how
> moving certain activities that happen under SLUB or LRU spinlocks
> to happen before return to userspace changes things related 
> to avoidance of CPU interruption ?
> 
> Thanks
> 


