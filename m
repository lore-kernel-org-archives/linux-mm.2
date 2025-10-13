Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A3F85CCA476
	for <linux-mm@archiver.kernel.org>; Mon, 13 Oct 2025 05:24:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B612B8E0009; Mon, 13 Oct 2025 01:24:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B395B8E0002; Mon, 13 Oct 2025 01:24:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A4EC38E0009; Mon, 13 Oct 2025 01:24:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9445B8E0002
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 01:24:05 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 2F37DB7761
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 05:24:05 +0000 (UTC)
X-FDA: 83991949650.06.DEFD49E
Received: from invmail4.hynix.com (exvmail4.hynix.com [166.125.252.92])
	by imf29.hostedemail.com (Postfix) with ESMTP id 5C924120005
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 05:24:02 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	spf=pass (imf29.hostedemail.com: domain of byungchul@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=byungchul@sk.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760333043;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cRTeDf+CEMAypt/CCBsS7J4Y4mUGaLxFLgIkfDQfeqo=;
	b=6QBBNPxtsI6yTSbZa/Rd3N5WFcQdrdQ23GZMZGFdk5tRD+zck3uIULnLHMrfn6H0Bj8fZi
	761+5oHsA56cmNx7mqHDj+yk3MqgfShyp2Jv833Plps/XfqDIRR34Xo+Uk5vqEqOSax4Yf
	rvvshZ4BEikqjMKo1OmMaLhK0AUAbEg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760333043; a=rsa-sha256;
	cv=none;
	b=UBrmXGHtBw7axZUNBDWTO3Rduco3SHyBoggWfo2fRQIbsf/gc0YlZ/+tHzTfdi/XMYdEVR
	CxkeaWaO6Fr2IHYTuZYFEgF7SIOG/CkDni4MxLmS6wEIVr/xLU+M+h0ujtyHPded2j4Ila
	PMm64uhv2KpjpCMjnaJw+umKX00gnsg=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf29.hostedemail.com: domain of byungchul@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=byungchul@sk.com
X-AuditID: a67dfc5b-c45ff70000001609-68-68ec8cf02760
Date: Mon, 13 Oct 2025 14:23:54 +0900
From: Byungchul Park <byungchul@sk.com>
To: NeilBrown <neil@brown.name>
Cc: linux-kernel@vger.kernel.org, kernel_team@skhynix.com,
	torvalds@linux-foundation.org, damien.lemoal@opensource.wdc.com,
	linux-ide@vger.kernel.org, adilger.kernel@dilger.ca,
	linux-ext4@vger.kernel.org, mingo@redhat.com, peterz@infradead.org,
	will@kernel.org, tglx@linutronix.de, rostedt@goodmis.org,
	joel@joelfernandes.org, sashal@kernel.org, daniel.vetter@ffwll.ch,
	duyuyang@gmail.com, johannes.berg@intel.com, tj@kernel.org,
	tytso@mit.edu, willy@infradead.org, david@fromorbit.com,
	amir73il@gmail.com, gregkh@linuxfoundation.org, kernel-team@lge.com,
	linux-mm@kvack.org, akpm@linux-foundation.org, mhocko@kernel.org,
	minchan@kernel.org, hannes@cmpxchg.org, vdavydov.dev@gmail.com,
	sj@kernel.org, jglisse@redhat.com, dennis@kernel.org, cl@linux.com,
	penberg@kernel.org, rientjes@google.com, vbabka@suse.cz,
	ngupta@vflare.org, linux-block@vger.kernel.org,
	josef@toxicpanda.com, linux-fsdevel@vger.kernel.org, jack@suse.cz,
	jlayton@kernel.org, dan.j.williams@intel.com, hch@infradead.org,
	djwong@kernel.org, dri-devel@lists.freedesktop.org,
	rodrigosiqueiramelo@gmail.com, melissa.srw@gmail.com,
	hamohammed.sa@gmail.com, harry.yoo@oracle.com,
	chris.p.wilson@intel.com, gwan-gyeong.mun@intel.com,
	max.byungchul.park@gmail.com, boqun.feng@gmail.com,
	longman@redhat.com, yunseong.kim@ericsson.com, ysk@kzalloc.com,
	yeoreum.yun@arm.com, netdev@vger.kernel.org,
	matthew.brost@intel.com, her0gyugyu@gmail.com, corbet@lwn.net,
	catalin.marinas@arm.com, bp@alien8.de, dave.hansen@linux.intel.com,
	x86@kernel.org, hpa@zytor.com, luto@kernel.org,
	sumit.semwal@linaro.org, gustavo@padovan.org,
	christian.koenig@amd.com, andi.shyti@kernel.org, arnd@arndb.de,
	lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com,
	rppt@kernel.org, surenb@google.com, mcgrof@kernel.org,
	petr.pavlu@suse.com, da.gomez@kernel.org, samitolvanen@google.com,
	paulmck@kernel.org, frederic@kernel.org, neeraj.upadhyay@kernel.org,
	joelagnelf@nvidia.com, josh@joshtriplett.org, urezki@gmail.com,
	mathieu.desnoyers@efficios.com, jiangshanlai@gmail.com,
	qiang.zhang@linux.dev, juri.lelli@redhat.com,
	vincent.guittot@linaro.org, dietmar.eggemann@arm.com,
	bsegall@google.com, mgorman@suse.de, vschneid@redhat.com,
	chuck.lever@oracle.com, okorniev@redhat.com, Dai.Ngo@oracle.com,
	tom@talpey.com, trondmy@kernel.org, anna@kernel.org,
	kees@kernel.org, bigeasy@linutronix.de, clrkwllms@kernel.org,
	mark.rutland@arm.com, ada.coupriediaz@arm.com,
	kristina.martsenko@arm.com, wangkefeng.wang@huawei.com,
	broonie@kernel.org, kevin.brodsky@arm.com, dwmw@amazon.co.uk,
	shakeel.butt@linux.dev, ast@kernel.org, ziy@nvidia.com,
	yuzhao@google.com, baolin.wang@linux.alibaba.com,
	usamaarif642@gmail.com, joel.granados@kernel.org,
	richard.weiyang@gmail.com, geert+renesas@glider.be,
	tim.c.chen@linux.intel.com, linux@treblig.org,
	alexander.shishkin@linux.intel.com, lillian@star-ark.net,
	chenhuacai@kernel.org, francesco@valla.it,
	guoweikang.kernel@gmail.com, link@vivo.com, jpoimboe@kernel.org,
	masahiroy@kernel.org, brauner@kernel.org,
	thomas.weissschuh@linutronix.de, oleg@redhat.com, mjguzik@gmail.com,
	andrii@kernel.org, wangfushuai@baidu.com, linux-doc@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
	linaro-mm-sig@lists.linaro.org, linux-i2c@vger.kernel.org,
	linux-arch@vger.kernel.org, linux-modules@vger.kernel.org,
	rcu@vger.kernel.org, linux-nfs@vger.kernel.org,
	linux-rt-devel@lists.linux.dev
Subject: Re: [PATCH v17 28/47] dept: add documentation for dept
Message-ID: <20251013052354.GA75512@system.software.com>
References: <20251002081247.51255-1-byungchul@sk.com>
 <20251002081247.51255-29-byungchul@sk.com>
 <175947451487.247319.6809470356431942803@noble.neil.brown.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <175947451487.247319.6809470356431942803@noble.neil.brown.name>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Brightmail-Tracker: H4sIAAAAAAAAA02SbUxTZxTH99yXp5fGLtdO44N8MOkwLEyZCMtOCJk6Z7wfZmZmzIwmaCN3
	ayOlWhTFxU1guG6iYk0lLYKAUDtaEQsz423rcFYqolWKViNvsysQqDUOMQqFtWxGv/3O/3/y
	P+ckh6PllXgxp87eK+qylVkKLGWkwXlVy58Uj6tWlAXT4G6+kwG9w8SCp96GYOCZHsHzqTIa
	wgaXBGbbXQjsTfkU/NMwg8E45McQshQjGL26HoIDrSzM9g1TYPHPUOB3/oDgbHUjhlKjB8FI
	Q6RscvUjaLcWYOjxvw3eZyEMbuNRDI8bMFQWtLNQXmZAcLrcwUDzYIsEbo9NU/DwtIECm2MD
	DFgCDHSVVFNQOoqhrLSQAuOFVgpeWOokMD2UDC7bsAT6ThgZqA/eYsHdf5eFsYABw4R3iAJ7
	cYAGx6OI1v7gfag6UsOAqeIhBn14AkFPyxkM/fbZyN3OLhbu2DwMXBz2UdDl6mTAbf6ZgVst
	F1iovXebgqFBHwuN3TdomDweB56Tx9jVmcLzouOMUHQnjAV7hR0JUy8NSJioLaSFopJIeWU8
	RAu1XeNYuF5NhJPdy4Vmc59EqHTsE77/M8gKjdZE4VzbKCU46n7EG5dtlaZnilnqXFH3wcc7
	pKr8uhC9+/6aA55w7GF0LPEnFMMRPpVMFPVSr7jf3EhHmeGXEm+gWRJlzCcQn+/FnL6AX0Iu
	Nd2P9Es5mrfEEV/p5JzxDr+K3Oy1oyjLeCC/n6lF0SY5X4PIWaNe8p8xn7hNfibKNJ9IfDOj
	kSQuwnHk/AwXlWP4z8g9y8jcQgv5d4nz8rW5YYT/K4Z4By/+v2ks+cPqY0oQb34j1vxGrPl1
	bCWi65BcnZ2rUaqzUpNUednqA0k7tRoHivyt5dD0tl/RU8+mDsRzSDFPpmodU8lZZW5OnqYD
	EY5WLJB99M24Si7LVOYdFHXa7bp9WWJOB4rjGMUi2crJ/Zly/mvlXnGXKO4Wda9ciotZfBil
	WTIS0Hcl7s9N87Wh+M1VI22/DWz76srLlIR4cR3VaXuQsWtdT8YngUdWfXzh9OVy3Gm62rv2
	ZujGl+9RT52XTvlSaz49VF9gja/aotqQdyJWuyfll07N1N97lqxYU5+0Nj35ranubyuuaVLS
	w0e0y2jJh9tp//5TB9u+OJq2ySr1mhVMjkqZnEjrcpT/Aq5cnEezAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA02SfUwTdxjH/d1d747OMyeDeEiisdOZkKgz0/hEjUOj8XyZGrPMl0RHI+fa
	8JrWVdBsoQKhOtDSpG1oURHkhqUKAjOiKWtwdnPCyosMdEKHqbxIuy4bxSAUvGrM/OfJ5/l+
	n++T54+HxmMjsoW0OvOEoMlUpitIOSHfsyF/xT/FAdUn4XIW/tC7CQiPGwgor3OSYGgok0HH
	jVoEvrABwcspOw6FzbMEREweCsYn/6Rg1uVBYOk04eBs0mPwX/0MCWP3/kVgHvSTYB3VExAS
	ixHYhuwUjN7fDkHfXRnM9g9j0DsRQCD6ZzDwu4sQRCxpcLmykYSpdi8OVnMHgiuD/TiM1Etm
	k2cAgavmDAnPjT/i0O2fB4/CIRIemL8nIdhZjsHf9SRUnHHJ4KLdhCC/qo4Ey8UGApr/ukNB
	59g0Bk8tJgxqGz4HnzhEwENjJSbdJ03dXAB2az4mlREMzNfvYjApOihoq3pKgJi3DOzt3TJ4
	VmOjYHpwNcxWZIGndpiC/gtmAm4EvbJkM+JfFp4neEfjLYwv7IqQvPOSE/FTr0yIH6/Ox/lC
	o9TeC4RwvqDxJF/9MEDyr8I9JO+aqCD43yo5vrR9Bd9s66f4gpYn1L71h+UbU4V0tU7QrNqU
	IlfpHSE8+/HmnI5IQh4qSTqHYmiOXcMN2BrxKBPsMu7RUDMVZZJdzvX1Tb7R49jF3M2mx9g5
	JKdxVkzk+qwTb4wP2c+433ucKMoMC9xP5dUoOhTLXkXcZbOBemvM5x6U+Yko42wS1zczKm2i
	JU7kfpiho3IMu5vrFUewKMezH3HuW79gRsTY3kvb3kvb/k9XINyB4tSZugylOn3tSm2aKjdT
	nbPyWFZGA5KeUvx2uvQ2Gu/e3opYGinmMvuKAqpYmVKnzc1oRRyNK+KYdacliUlV5p4SNFlf
	ab5JF7StKJEmFAuYnQeElFj2a+UJIU0QsgXNOxejYxbmod1HJuJ9V7K7wLNkOMJ81xPzZcr5
	bccSci9s3FG85VoIPt1r3ZNzVCRdXkNCywdOmRf74vrBtqJDJR+ftPTqurKPl+x6saHEvfbJ
	+mTSn7ouVLejR++t31/jphYlz41T0B2+4ICSdpTN2aprK2ihz6qYMeOan4Pxvx69s2VpKVOl
	ILQq5eokXKNVvgZzqHjckAMAAA==
X-CFilter-Loop: Reflected
X-Rspamd-Server: rspam01
X-Stat-Signature: i5kq7k18tkouc1qpn3i8id5g7h4rrztw
X-Rspam-User: 
X-Rspamd-Queue-Id: 5C924120005
X-HE-Tag: 1760333042-949578
X-HE-Meta: U2FsdGVkX1+NlIyDplBWdOs6WprADwG1paKX/bjUng5789YatqIWNXYWT/GDUMBECSmUUE8gXoVWveI5eVUCtp/lvQnpDNgSL/rTV5/JEUQFKyB5EnDJvENMfBbQNPrK5gQBewtJBDZ8qmntOBilmJYaDhZNKJDwxELI1sLTJbsq01+Br7y7v/aoU+moypgfcJ0NBlMB2mTxu477mA6lLDEnV3HKaZsGsHpebpMYEmF/OcjKX67TvfrWywYvh2Xyh8fgyv0OB2LTmUb78alSyZ/4T0FT3z3q0bmw3lKicw9dLOlmqGPOhkg749DsDLsHvab2lNTl56AtrvUoyJ0ccU9whoxw3oXMqXLGSJnaoF0oTPYlSPD0U/kQbmWsuxSQJRVreEhgESlHvi5L7NqKQNG2VC4loYyglaBL6uw/RQOae55/b55N7coSwVTEWAXkio0rJK9rI0dwII74gIt1PgPreNtyWrjjglZZeq6TngvtkFc84hWBOwwh6+5F/NxlyHb9zgp1ht9Bz+1yscqseviAKpuSREvURz4baWjVYAxl/0M2pZt4SnyFkkF7yIexeKI+QYgC1/jC8fPpfJ7/Y+0pl6U69DHgH/qPHePkCuRVEupDkm4IH+IalfBjZJocQKjSS9qiFAW+NRJoA9O0hVqjIqPh9Slt0yfmxga9aztvSCJeO4R7j/uBqDT8LCm7l1kHYWl+p2Jz0SS8P8fs1jPw++X1x21NX8j/+mY7NvWeJYm4asJtbIxQqMAtyoPm8PlkxvUgXiEEuM4VAlUyHooEm66DGJFIgFrUSBGSZWXAck8sJGyl9xo8ZTRa6ppqKKt1nSf99lk9HwqzT5l/1T8zT6TdVmWDHqsoAYIdG3NrusW329h0xSyrnnF4x4a+Pdir/ykNpIcVS/hpg9jIdPbsZXdx2PH8hZP7xvW4F5bkCje8ZhNogD1SpyMEDorQByrZtAIQPEVpC+aS0Wt
 Oyg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 03, 2025 at 04:55:14PM +1000, NeilBrown wrote:
> On Thu, 02 Oct 2025, Byungchul Park wrote:
> > This document describes the concept and APIs of dept.
> >
> 
> Thanks for the documentation.  I've been trying to understand it.

You're welcome.  Feel free to ask me if you have any questions.

> > +How DEPT works
> > +--------------
> > +
> > +Let's take a look how DEPT works with the 1st example in the section
> > +'Limitation of lockdep'.
> > +
> > +   context X    context Y       context Z
> > +
> > +                mutex_lock A
> > +   folio_lock B
> > +                folio_lock B <- DEADLOCK
> > +                                mutex_lock A <- DEADLOCK
> > +                                folio_unlock B
> > +                folio_unlock B
> > +                mutex_unlock A
> > +                                mutex_unlock A
> > +
> > +Adding comments to describe DEPT's view in terms of wait and event:
> > +
> > +   context X    context Y       context Z
> > +
> > +                mutex_lock A
> > +                /* wait for A */
> > +   folio_lock B
> > +   /* wait for A */
> > +   /* start event A context */
> > +
> > +                folio_lock B
> > +                /* wait for B */ <- DEADLOCK
> > +                /* start event B context */
> > +
> > +                                mutex_lock A
> > +                                /* wait for A */ <- DEADLOCK
> > +                                /* start event A context */
> > +
> > +                                folio_unlock B
> > +                                /* event B */
> > +                folio_unlock B
> > +                /* event B */
> > +
> > +                mutex_unlock A
> > +                /* event A */
> > +                                mutex_unlock A
> > +                                /* event A */
> > +
> 
> I can't see the value of the above section.
> The first section with no comments is useful as it is easy to see the
> deadlock being investigate.  The section below is useful as it add
> comments to explain how DEPT sees the situation.  But the above section,
> with some but not all of the comments, does seem (to me) to add anything
> useful.

I just wanted to convert 'locking terms' to 'wait and event terms' by
one step.  However, I can remove the section you pointed out that you
thought was useless.

> > +Adding more supplementary comments to describe DEPT's view in detail:
> > +
> > +   context X    context Y       context Z
> > +
> > +                mutex_lock A
> > +                /* might wait for A */
> > +                /* start to take into account event A's context */
> 
> What do you mean precisely by "context".

That means one of task context, irq context, wq worker context (even
though it can also be considered as task context), or something.

Of course, in the example above, it must be task context since it showed
a case involving only sleepible ones.  However, I wanted to use general
terms in the document to cover all the types of context e.g. irq, task,
and so on.

> You use the word in the heading "context X  context Y  context Z"
> so it seems like "context" means "task" or "process".  But then as I
> read on, I think - maybe it means something else.  If it does, then you
> should use different words.  Maybe "task X ..." in the heading.

It should cover all the types of context.  What word would you recommend
for that purpose?

> If the examples that follow It seems that the "context" for event A
> starts at "mutex lock A" when it (possibly) waits for a mutex and ends
> at "mutex unlock A" - which are both in the same process.  Clearly
> various other events that happen between these two points in the same
> process could be seen as the "context" for event A.
> 
> However event B starts in "context X" with "folio_lock B" and ends in
> "context Z" or "context Y" with "folio_unlock B".  Is that right?

Right.

> My question then is: how do you decide which, of all the event in all
> the processes in all the system, between the start[S] and the end[E] are
> considered to be part of the "context" of event A.

DEPT can identify the "context" of event A only *once* the event A is
actually executed, and builds dependencies between the event and the
recorded waits in the "context" of event A since [S].

> I think it would help me if you defined what a "context" is earlier.

Sorry if my description was not clear enough.

	Byungchul

> What sorts of things appear in a context?
> 
> Thanks,
> NeilBrown
> 
> 
> > +                /* 1 */
> > +   folio_lock B
> > +   /* might wait for B */
> > +   /* start to take into account event B's context */
> > +   /* 2 */
> > +
> > +                folio_lock B
> > +                /* might wait for B */ <- DEADLOCK
> > +                /* start to take into account event B's context */
> > +                /* 3 */
> > +
> > +                                mutex_lock A
> > +                                /* might wait for A */ <- DEADLOCK
> > +                                /* start to take into account
> > +                                   event A's context */
> > +                                /* 4 */
> > +
> > +                                folio_unlock B
> > +                                /* event B that's been valid since 2 */
> > +                folio_unlock B
> > +                /* event B that's been valid since 3 */
> > +
> > +                mutex_unlock A
> > +                /* event A that's been valid since 1 */
> > +
> > +                                mutex_unlock A
> > +                                /* event A that's been valid since 4 */
> > +
> > +Let's build up dependency graph with this example. Firstly, context X:
> > +
> > +   context X
> > +
> > +   folio_lock B
> > +   /* might wait for B */
> > +   /* start to take into account event B's context */
> > +   /* 2 */
> > +
> > +There are no events to create dependency. Next, context Y:
> > +
> > +   context Y
> > +
> > +   mutex_lock A
> > +   /* might wait for A */
> > +   /* start to take into account event A's context */
> > +   /* 1 */
> > +
> > +   folio_lock B
> > +   /* might wait for B */
> > +   /* start to take into account event B's context */
> > +   /* 3 */
> > +
> > +   folio_unlock B
> > +   /* event B that's been valid since 3 */
> > +
> > +   mutex_unlock A
> > +   /* event A that's been valid since 1 */
> > +
> > +There are two events. For event B, folio_unlock B, since there are no
> > +waits between 3 and the event, event B does not create dependency. For
> > +event A, there is a wait, folio_lock B, between 1 and the event. Which
> > +means event A cannot be triggered if event B does not wake up the wait.
> > +Therefore, we can say event A depends on event B, say, 'A -> B'. The
> > +graph will look like after adding the dependency:
> > +
> > +   A -> B
> > +
> > +   where 'A -> B' means that event A depends on event B.
> > +
> > +Lastly, context Z:
> > +
> > +   context Z
> > +
> > +   mutex_lock A
> > +   /* might wait for A */
> > +   /* start to take into account event A's context */
> > +   /* 4 */
> > +
> > +   folio_unlock B
> > +   /* event B that's been valid since 2 */
> > +
> > +   mutex_unlock A
> > +   /* event A that's been valid since 4 */
> > +
> > +There are also two events. For event B, folio_unlock B, there is a
> > +wait, mutex_lock A, between 2 and the event - remind 2 is at a very
> > +start and before the wait in timeline. Which means event B cannot be
> > +triggered if event A does not wake up the wait. Therefore, we can say
> > +event B depends on event A, say, 'B -> A'. The graph will look like
> > +after adding the dependency:
> > +
> > +    -> A -> B -
> > +   /           \
> > +   \           /
> > +    -----------
> > +
> > +   where 'A -> B' means that event A depends on event B.
> > +
> > +A new loop has been created. So DEPT can report it as a deadlock. For
> > +event A, mutex_unlock A, since there are no waits between 4 and the
> > +event, event A does not create dependency. That's it.
> > +
> > +CONCLUSION
> > +
> > +DEPT works well with any general synchronization mechanisms by focusing
> > +on wait, event and its context.
> > +

