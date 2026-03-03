Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3C40CEB3641
	for <linux-mm@archiver.kernel.org>; Tue,  3 Mar 2026 00:20:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 757D26B00F0; Mon,  2 Mar 2026 19:20:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6DB286B00F2; Mon,  2 Mar 2026 19:20:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5BCF96B00F4; Mon,  2 Mar 2026 19:20:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 499756B00F0
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 19:20:22 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id DAEEE8B8A1
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 00:20:21 +0000 (UTC)
X-FDA: 84502845042.29.46FBFBE
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf03.hostedemail.com (Postfix) with ESMTP id C79D02000C
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 00:20:19 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Q020LqpM;
	spf=pass (imf03.hostedemail.com: domain of mtosatti@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mtosatti@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772497220;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+PxAs2WvNVOxCftZ/jr64yaJOBUiDO5P1MZH42ytmr4=;
	b=Kp7td/LjCNXAA10D4/AqGeEQ9s5KdSCouNh/xD0QLPfrY8GE/8g+d4YS/kG7bBFhA1lfru
	F0V2UjZFCHajHrmAszP9yjAbA0Z7d0ePfXEqNakxcclRtfiMmUcpfjZSSiIbPvTxPliz+i
	h+TgH4ivuZSHCqyrke5NSNz2vj2Gr7c=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772497220; a=rsa-sha256;
	cv=none;
	b=t/lzAjkdA5t9CbL4AvRTigkdlFTezbvj5domu+0wbffK3fJPMYBWMSRYuB0M5+qm7mprzu
	m/RrWsC5kG5TpgtVExyWsrCI2lYHPEbT9pJpw+fLv78bZ9skdeUzdPXIRLVn22XCuYJ5XC
	pcZmMFzL3RYtiTYqpDP/V9QZ5KNNq44=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Q020LqpM;
	spf=pass (imf03.hostedemail.com: domain of mtosatti@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mtosatti@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1772497219;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+PxAs2WvNVOxCftZ/jr64yaJOBUiDO5P1MZH42ytmr4=;
	b=Q020LqpM+CYjLP9qlMt+IWiBpBytDhOGDQH/ohlX/Ku9y6d3i+lu2hM/2Smo5JU0AmAHAr
	jb0sfNgSV9RoB32rbcDldWlURwwnEiiejnnN7D/pWrncFpm3qHVZFHL9P6CKMDJb1falN/
	cD1P1y41NC7j/9idj2LMUiC/OBunNq4=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-377-6OCu4L77MnWbFpTG33YaJw-1; Mon,
 02 Mar 2026 19:20:15 -0500
X-MC-Unique: 6OCu4L77MnWbFpTG33YaJw-1
X-Mimecast-MFC-AGG-ID: 6OCu4L77MnWbFpTG33YaJw_1772497213
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 1BBD21800366;
	Tue,  3 Mar 2026 00:20:12 +0000 (UTC)
Received: from tpad.localdomain (unknown [10.96.133.6])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id BC4521800348;
	Tue,  3 Mar 2026 00:20:09 +0000 (UTC)
Received: by tpad.localdomain (Postfix, from userid 1000)
	id 17973401CFE28; Mon,  2 Mar 2026 21:19:44 -0300 (-03)
Date: Mon, 2 Mar 2026 21:19:44 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Leonardo Bras <leobras.c@gmail.com>
Cc: Michal Hocko <mhocko@suse.com>, linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org, linux-mm@kvack.org,
	Johannes Weiner <hannes@cmpxchg.org>,
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
Message-ID: <aaYpICV55B70U1I2@tpad>
References: <20260206143430.021026873@redhat.com>
 <aYs6Ju2G4bm6_tl2@tiehlicka>
 <aYxviLoWsrLqDU7o@tpad>
 <aYywl1hdBQP2_slo@tiehlicka>
 <aZDw6xI2izFDfuuu@WindFlash>
 <aZL45yORfkNvS9Rs@tiehlicka>
 <aZjY9h3XXMNY-Ytd@WindFlash>
 <aZwYmNuucBspCYhk@tiehlicka>
 <aaJDjmnfuo8AM6J9@WindFlash>
MIME-Version: 1.0
In-Reply-To: <aaJDjmnfuo8AM6J9@WindFlash>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Mimecast-MFC-PROC-ID: lBdhemGGYfXJcAolnA6vvSi1WddKqr_QR9y1QKGQAl0_1772497213
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: C79D02000C
X-Stat-Signature: p95akfps53t96gz3nzpnxetmhck6mnud
X-Rspam-User: 
X-HE-Tag: 1772497219-335899
X-HE-Meta: U2FsdGVkX19EjK3dbzTLdwu+ejKmmyHHVwSYgLpZ0+r2PSYmy+WN2Z3senASYJbl7TiQf9rM7gwyhOApYEUI0WrkXLjU3VmIT2/opLWMjOqPD6F85tqlvHmD99JRGb8hXjk4GhnVeUmQMVReNCoNxWN57a6uSph00DsopVDBR/HRDtbbncjerU96CWi80ENDJq6/5rxWZWn6YpJglHUlNIILmR5VtqlSJuggNcabXqs2CDU5BPi6rE0bjbxj667I4rcfQhRoXp09TCPlmcA6zF2arLcpver2587iIcDKDR2Q3ZgBrV3opZ5mpaZjPHz22hsFpcGjHKsIDBepl9kyjZJoFF/ZP2fPgSnJzyDSh5sCF3o7Xuh4UhsofQCmU+6WnJyXzKT5fWPM+fIp5lYrWCvcwXkoRsC6z3237ViKSRjAPm67AtFaasp/QnvOPkKvpBdeDR6pxgDhyJ3CqqDqtsDwhkAaoiS3GV4YR5QtojnSD80NrKuWbEm03S0ydxqxrJFW3M3/JWYUOgugYPioMA0OOeITXdEBuJjurBPGtdiahthMQdwoGd8QMAtwDKbDu5NiSdSG/EQLM+X6WNtgEsgdfGLCWqpdYWppIY5kaF0d7Bt1pGStAmmzllnxeHcN1AeFa1tcebN5oY4eJshgP6ApVm+aSlWZ2bLKINSRPz4qYBEPNCxIRtgP1BxgvgyutFWpV2kzECA8XMMLr27XTCi9fieQIB7slu4supjqfagRj5AZSl0H9CTcpRV7qIZ+yBmIGdvXxQKJw3w12g9nOLRENApQMsmUZ+eOAwXMZUxUnyFm5X1LBl1ItJeFSV1bG74l1wREyrC2wJvZ3TgEl8DDCj8ISDMZgrrNV3xu0Ld6sDdoSARQs9sgthFSpyWCUFswWV9W0tDugHh9loNO5wReZ1np/qPTES+pfhu4Ws8ds+1IQbXZPzLiZCqrcyO7H1T/v6Z1Mh+nZ/vapl+
 6zhZjAsC
 tURATaTqRaY0zRbaUWldIS1BNxENGMLUNDh3MxWic7E9COGKurWLCa0moanzgdGbSx1s3uGveaDJZKO5ntgBIj1qb8q1Eh3cXDC99
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Feb 27, 2026 at 10:23:27PM -0300, Leonardo Bras wrote:
> On Mon, Feb 23, 2026 at 10:06:32AM +0100, Michal Hocko wrote:
> > On Fri 20-02-26 18:58:14, Leonardo Bras wrote:
> > > On Mon, Feb 16, 2026 at 12:00:55PM +0100, Michal Hocko wrote:
> > > > On Sat 14-02-26 19:02:19, Leonardo Bras wrote:
> > > > > On Wed, Feb 11, 2026 at 05:38:47PM +0100, Michal Hocko wrote:
> > > > > > On Wed 11-02-26 09:01:12, Marcelo Tosatti wrote:
> > > > > > > On Tue, Feb 10, 2026 at 03:01:10PM +0100, Michal Hocko wrote:
> > > > > > [...]
> > > > > > > > What about !PREEMPT_RT? We have people running isolated workloads and
> > > > > > > > these sorts of pcp disruptions are really unwelcome as well. They do not
> > > > > > > > have requirements as strong as RT workloads but the underlying
> > > > > > > > fundamental problem is the same. Frederic (now CCed) is working on
> > > > > > > > moving those pcp book keeping activities to be executed to the return to
> > > > > > > > the userspace which should be taking care of both RT and non-RT
> > > > > > > > configurations AFAICS.
> > > > > > > 
> > > > > > > Michal,
> > > > > > > 
> > > > > > > For !PREEMPT_RT, _if_ you select CONFIG_QPW=y, then there is a kernel
> > > > > > > boot option qpw=y/n, which controls whether the behaviour will be
> > > > > > > similar (the spinlock is taken on local_lock, similar to PREEMPT_RT).
> > > > > > 
> > > > > > My bad. I've misread the config space of this.
> > > > > > 
> > > > > > > If CONFIG_QPW=n, or kernel boot option qpw=n, then only local_lock 
> > > > > > > (and remote work via work_queue) is used.
> > > > > > > 
> > > > > > > What "pcp book keeping activities" you refer to ? I don't see how
> > > > > > > moving certain activities that happen under SLUB or LRU spinlocks
> > > > > > > to happen before return to userspace changes things related 
> > > > > > > to avoidance of CPU interruption ?
> > > > > > 
> > > > > > Essentially delayed operations like pcp state flushing happens on return
> > > > > > to the userspace on isolated CPUs. No locking changes are required as
> > > > > > the work is still per-cpu.
> > > > > > 
> > > > > > In other words the approach Frederic is working on is to not change the
> > > > > > locking of pcp delayed work but instead move that work into well defined
> > > > > > place - i.e. return to the userspace.
> > > > > > 
> > > > > > Btw. have you measure the impact of preempt_disbale -> spinlock on hot
> > > > > > paths like SLUB sheeves?
> > > > > 
> > > > > Hi Michal,
> > > > > 
> > > > > I have done some study on this (which I presented on Plumbers 2023):
> > > > > https://lpc.events/event/17/contributions/1484/ 
> > > > > 
> > > > > Since they are per-cpu spinlocks, and the remote operations are not that 
> > > > > frequent, as per design of the current approach, we are not supposed to see 
> > > > > contention (I was not able to detect contention even after stress testing 
> > > > > for weeks), nor relevant cacheline bouncing.
> > > > > 
> > > > > That being said, for RT local_locks already get per-cpu spinlocks, so there 
> > > > > is only difference for !RT, which as you mention, does preemtp_disable():
> > > > > 
> > > > > The performance impact noticed was mostly about jumping around in 
> > > > > executable code, as inlining spinlocks (test #2 on presentation) took care 
> > > > > of most of the added extra cycles, adding about 4-14 extra cycles per 
> > > > > lock/unlock cycle. (tested on memcg with kmalloc test)
> > > > > 
> > > > > Yeah, as expected there is some extra cycles, as we are doing extra atomic 
> > > > > operations (even if in a local cacheline) in !RT case, but this could be 
> > > > > enabled only if the user thinks this is an ok cost for reducing 
> > > > > interruptions.
> > > > > 
> > > > > What do you think?
> > > > 
> > > > The fact that the behavior is opt-in for !RT is certainly a plus. I also
> > > > do not expect the overhead to be really be really big. 
> > > 
> > > Awesome! Thanks for reviewing!
> > > 
> > > > To me, a much
> > > > more important question is which of the two approaches is easier to
> > > > maintain long term. The pcp work needs to be done one way or the other.
> > > > Whether we want to tweak locking or do it at a very well defined time is
> > > > the bigger question.
> > > 
> > > That crossed my mind as well, and I went with the idea of changing locking 
> > > because I was working on workloads in which deferring work to a kernel 
> > > re-entry would cause deadline misses as well. Or more critically, the 
> > > drains could take forever, as some of those tasks would avoid returning to 
> > > kernel as much as possible. 
> > 
> > Could you be more specific please?
> 
> Hi Michal,
> Sorry for the delay
> 
> I think Marcelo covered some of the main topics earlier in this 
> thread:
> 
> https://lore.kernel.org/all/aZ3ejedS7nE5mnva@tpad/
> 
> But in syntax:
> - There are workloads that are projected not avoid as much as possible 
> return to kernelspace, as they are either cpu intensive, or latency 
> sensitive (RT workloads) such as low-latency automation.
> 
> There are scenarios such as industrial automation in which 
> the applications are supposed to reply a request in less than 50us since it 
> was generated (IIRC), so sched-out, dealing with interruptions, or syscalls 
> are a no-go. In those cases, using cpu isolation is a must, and since it 
> can stay really long running in userspace, it may take a very long time to 
> do any syscall to actually perform the scheduled flush.
> 
> - Other workloads may need to use syscalls, or rely in interrupts, such as 
> HPC, but it's also not interesting to take long on them, as the time spent 
> there is time not used for processing the required data.
> 
> Let's say that for the sake of cpu isolation, a lot of different
> requests made to given isolated cpu are batched to be run on syscall 
> entry/exit. It means the next syscall may take much longer than 
> usual.
> - This may break other RT workloads such as  sensor/sound/image sampling, 
> which could be generally ok with some of the faster syscalls for their 
> application, and now may perceive an error because one of those syscalls 
> took too long. 
> 
> While the qpw approach may cost a few extra cycles, it operates remotelly 
> and makes the system a bit more predictable. 
> 
> Also, when I was planning the mechanism, I remember it was meant to add 
> zero overhead in case of CONFIG_QPW=n, very little overhead in case of 
> CONFIG_QPW=y + qpw=0 (a couple of static branches, possibly with the 
> cost removed by the cpu branch predictor),  and only add a few cycles in 
> case of qpw=1 + !RT. Which means we may be missing just a few adjustments 
> to get there.

Leo,

v2 of the patchset adds only 2 cycles to CONFIG_QPW=y + qpw=0. 
The larger overhead was due to migrate_disable, which is now (on v2)
hidden inside the static branch.
My bad.

> BTW, if the numbers are not that great for your workloads, we could take a 
> look at adding an extra QPW mode in which local_locks are taken in 
> the fastpath and it allows the flush wq to be posponed to that point in 
> syscall return that you mentioned. What I mean is that we don't need to be 
> limitted to choosing between solutions, but instead allow the user (or 
> distro) to choose the desired behavior.
> 
> Thanks!
> Leo 

I think 2 cycles is acceptable.


