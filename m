Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C598BEB105F
	for <linux-mm@archiver.kernel.org>; Tue, 10 Mar 2026 21:34:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 071FE6B0092; Tue, 10 Mar 2026 17:34:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 01D5E6B0098; Tue, 10 Mar 2026 17:34:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E3A426B0099; Tue, 10 Mar 2026 17:34:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D06736B0092
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 17:34:54 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 76ACC13A8B0
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 21:34:54 +0000 (UTC)
X-FDA: 84531458508.02.EA3B019
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf13.hostedemail.com (Postfix) with ESMTP id 484F020008
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 21:34:52 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=VAMeG9Xw;
	spf=pass (imf13.hostedemail.com: domain of mtosatti@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mtosatti@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773178492;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=H/UPRVTAsUYW3i+OG72G17asefLsIJOs+AkksZbtd/w=;
	b=vbokkSuYEmi+3UmUvOE23Dcjd6cJAb1iEhDAHz07PazC/weB3XuTJec8iddDO0PlEpUWm9
	GhFYFV7B7JsonvMGyxed27mcIhKW86TIWf3EoyccPU9F5kJbsRpg+xV+ejHbkg9O3f1VFF
	Lg+L/JmwKLJINap2Vi1GHmKr8BrvTN0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773178492; a=rsa-sha256;
	cv=none;
	b=qjwnN/NEebPIo+nBb+D5Gg79DARWD9+KJ9ENMRoHecgyeuJQOn00fdKfK5qkqKyXnjW+Uc
	4yCubHYE5M2NZEKdSkcUvw7voXN+5mhV3OeuKn2LxLpRLl4zNZrtTWE9cyxdy7aoFjwgov
	wrY9wHxDd6OraJTk4btRd4wccLVMzAg=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=VAMeG9Xw;
	spf=pass (imf13.hostedemail.com: domain of mtosatti@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mtosatti@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1773178491;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=H/UPRVTAsUYW3i+OG72G17asefLsIJOs+AkksZbtd/w=;
	b=VAMeG9XwtzaewG5hBYCtv/GXeFf/SjHZhL3d7irXa5IehjCplOj6fhU1Y/F6fNjAKV+QZM
	73DqTIigTCMUNKOSZCCFSTpZ6YQKfIJXRasNOmdCDaRDqXfXOnhol+JUtHernpIxVuRE2T
	RIEBRkFoaA82Pv/++XoYzL4LuxmIt7g=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-227-dn-TJG_tON-R02PKmPloJA-1; Tue,
 10 Mar 2026 17:34:45 -0400
X-MC-Unique: dn-TJG_tON-R02PKmPloJA-1
X-Mimecast-MFC-AGG-ID: dn-TJG_tON-R02PKmPloJA_1773178483
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6EB3F1800371;
	Tue, 10 Mar 2026 21:34:42 +0000 (UTC)
Received: from tpad.localdomain (unknown [10.96.133.4])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 60E7419560A6;
	Tue, 10 Mar 2026 21:34:40 +0000 (UTC)
Received: by tpad.localdomain (Postfix, from userid 1000)
	id D35534037EE9C; Tue, 10 Mar 2026 18:24:02 -0300 (-03)
Date: Tue, 10 Mar 2026 18:24:02 -0300
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
Message-ID: <abCL8vE3cttL1Yq0@tpad>
References: <aYs6Ju2G4bm6_tl2@tiehlicka>
 <aYxviLoWsrLqDU7o@tpad>
 <aYywl1hdBQP2_slo@tiehlicka>
 <aZDw6xI2izFDfuuu@WindFlash>
 <aZL45yORfkNvS9Rs@tiehlicka>
 <aZjY9h3XXMNY-Ytd@WindFlash>
 <aZwYmNuucBspCYhk@tiehlicka>
 <aaJDjmnfuo8AM6J9@WindFlash>
 <aaYpICV55B70U1I2@tpad>
 <aa20uDGqnmiqYJ1w@WindFlash>
MIME-Version: 1.0
In-Reply-To: <aa20uDGqnmiqYJ1w@WindFlash>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-MFC-PROC-ID: lg6PRJMoJzEvTxSP4Nl2aWIJYNmiOxKZMma3vQGevBM_1773178483
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 484F020008
X-Stat-Signature: 69ym8p74uad7q4wo8mu6xgge6ywp9wnm
X-Rspam-User: 
X-HE-Tag: 1773178492-179912
X-HE-Meta: U2FsdGVkX1944Wm08/0/43A20Tq2DKsAOQdcaf/s3ELNcQe1ouFfNJsUIXyk61NGGDIsMxS0wM9IUsAAwC78TE8/4zULzhS4coZHhneHRGmwjVls+wRI7zfIckemNlQ3p3zrHbRzbZxrMo+3z7UR+XBWIwkbLJz1E21xw6zM4+epcRlFwEBwqOVIzEfRQHD2TGbbnBCfww7JMtHWH6ZPSdRUJhhX5+3Nb7u9CywKLfuxGL2s5+hQVBgRfHPsA/CR0UAc7VSHmq6dD8N3VOP7E5d+ig/9HyL9UPap7/689FzkKEtXfP+9239GR2Je2wJV9J284OCDx/MKjtU+uwDKRhWQ7sac9ac7BXIahyu6aD96NHlALYJfUALvaFOkQUgdJkED/O8EhgATeIKlYwqSN68yA8zT7Z/G9TiA9j+cAHR/ioRiBHhexne2d6XZkP5+C6EB8eI50n8NK5qUxExlLIDI2t6Lz/T8gYWG9Tn7iUp4Fko0FVW8tIjvypzc/sJwY1bZLaglusvoq/6xegFFLBR8TwA/ZQWJTdeKvShgltCouxiR1N3Z5cA61DB4O0fsHVNz4269xoNNRWrLY8CnlKfTwc1zt4idWhOFJCYKLL3UZxPOOoQwv9QZ0+TWxtNtBLGIK7SVtDA4GcK6bRJYHOXvjAC9Tqf/Wu65IFVYB7bd3W34uvkYcmzXvSQ0UA32mSSouITIrS3Nk81Qv/sujS8So3cYua4e0OXpHYWO1S+GAsrURHI85JoJi+iNi09rFmV9mjAroiHpWp8aOz22lJq6P8S/5JWolQiRsB+LgxB5lJvxFUo+Exdoox7gC3rRHpYAfGltnqy6AbRdJ8GDwlvZeaa2yR7d0uDkW72MFxPKjZ3FpQ6PsHqfJTtP5qB5kcvdvUzeC1G2YapUcMRXcQ3a27/xquP+QLW0sph4av/h/yckEWk6lHn/IaT6TsPmPAdr2k4at0Z4n/723iG
 ks2r8XCk
 wDlqJo8x1Kpf12nQbxcC5oV7ASI+qynlElcD8ixPli2DNlHypmhs6a8vMQh9cyhSVRDNbR4pz/Gt7VA+ee8QW3Ige2X44EIyzBcsoxQIekH4cyEbvwBszrDs/A/aZkY3etZuzS2rPpu9O+M1PCAfsHZJIqcdfMiKEjmMUBj7Iu90w38jqNuNYtqnupJOzju3mraIYqF+Uhh8exIbCJSHBDE0RY8943azKz2InH1gbVJKp+q6nIBxaO2lmJqawur51ogwLKAFopKzPtIaFXvmbqVnnzfoe+VtkpMzG2TRQLmixrYd1EC/fxJMTl8B+ylJbQYC8gDICra6njaVNRE9OWmbpDcR9q3CAJ5ErQxnAw4fN1GIH2cs0d0oGRoJobXO5z0SmOxCOEfvRQjnbx/rFIswKc1WXi4ypmNtnAAwzbsGBj1VWkuyPQZY/tK29WNnxH4p5iH+3ptvj9ec=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Mar 08, 2026 at 02:41:12PM -0300, Leonardo Bras wrote:
> On Mon, Mar 02, 2026 at 09:19:44PM -0300, Marcelo Tosatti wrote:
> > On Fri, Feb 27, 2026 at 10:23:27PM -0300, Leonardo Bras wrote:
> > > On Mon, Feb 23, 2026 at 10:06:32AM +0100, Michal Hocko wrote:
> > > > On Fri 20-02-26 18:58:14, Leonardo Bras wrote:
> > > > > On Mon, Feb 16, 2026 at 12:00:55PM +0100, Michal Hocko wrote:
> > > > > > On Sat 14-02-26 19:02:19, Leonardo Bras wrote:
> > > > > > > On Wed, Feb 11, 2026 at 05:38:47PM +0100, Michal Hocko wrote:
> > > > > > > > On Wed 11-02-26 09:01:12, Marcelo Tosatti wrote:
> > > > > > > > > On Tue, Feb 10, 2026 at 03:01:10PM +0100, Michal Hocko wrote:
> > > > > > > > [...]
> > > > > > > > > > What about !PREEMPT_RT? We have people running isolated workloads and
> > > > > > > > > > these sorts of pcp disruptions are really unwelcome as well. They do not
> > > > > > > > > > have requirements as strong as RT workloads but the underlying
> > > > > > > > > > fundamental problem is the same. Frederic (now CCed) is working on
> > > > > > > > > > moving those pcp book keeping activities to be executed to the return to
> > > > > > > > > > the userspace which should be taking care of both RT and non-RT
> > > > > > > > > > configurations AFAICS.
> > > > > > > > > 
> > > > > > > > > Michal,
> > > > > > > > > 
> > > > > > > > > For !PREEMPT_RT, _if_ you select CONFIG_QPW=y, then there is a kernel
> > > > > > > > > boot option qpw=y/n, which controls whether the behaviour will be
> > > > > > > > > similar (the spinlock is taken on local_lock, similar to PREEMPT_RT).
> > > > > > > > 
> > > > > > > > My bad. I've misread the config space of this.
> > > > > > > > 
> > > > > > > > > If CONFIG_QPW=n, or kernel boot option qpw=n, then only local_lock 
> > > > > > > > > (and remote work via work_queue) is used.
> > > > > > > > > 
> > > > > > > > > What "pcp book keeping activities" you refer to ? I don't see how
> > > > > > > > > moving certain activities that happen under SLUB or LRU spinlocks
> > > > > > > > > to happen before return to userspace changes things related 
> > > > > > > > > to avoidance of CPU interruption ?
> > > > > > > > 
> > > > > > > > Essentially delayed operations like pcp state flushing happens on return
> > > > > > > > to the userspace on isolated CPUs. No locking changes are required as
> > > > > > > > the work is still per-cpu.
> > > > > > > > 
> > > > > > > > In other words the approach Frederic is working on is to not change the
> > > > > > > > locking of pcp delayed work but instead move that work into well defined
> > > > > > > > place - i.e. return to the userspace.
> > > > > > > > 
> > > > > > > > Btw. have you measure the impact of preempt_disbale -> spinlock on hot
> > > > > > > > paths like SLUB sheeves?
> > > > > > > 
> > > > > > > Hi Michal,
> > > > > > > 
> > > > > > > I have done some study on this (which I presented on Plumbers 2023):
> > > > > > > https://lpc.events/event/17/contributions/1484/ 
> > > > > > > 
> > > > > > > Since they are per-cpu spinlocks, and the remote operations are not that 
> > > > > > > frequent, as per design of the current approach, we are not supposed to see 
> > > > > > > contention (I was not able to detect contention even after stress testing 
> > > > > > > for weeks), nor relevant cacheline bouncing.
> > > > > > > 
> > > > > > > That being said, for RT local_locks already get per-cpu spinlocks, so there 
> > > > > > > is only difference for !RT, which as you mention, does preemtp_disable():
> > > > > > > 
> > > > > > > The performance impact noticed was mostly about jumping around in 
> > > > > > > executable code, as inlining spinlocks (test #2 on presentation) took care 
> > > > > > > of most of the added extra cycles, adding about 4-14 extra cycles per 
> > > > > > > lock/unlock cycle. (tested on memcg with kmalloc test)
> > > > > > > 
> > > > > > > Yeah, as expected there is some extra cycles, as we are doing extra atomic 
> > > > > > > operations (even if in a local cacheline) in !RT case, but this could be 
> > > > > > > enabled only if the user thinks this is an ok cost for reducing 
> > > > > > > interruptions.
> > > > > > > 
> > > > > > > What do you think?
> > > > > > 
> > > > > > The fact that the behavior is opt-in for !RT is certainly a plus. I also
> > > > > > do not expect the overhead to be really be really big. 
> > > > > 
> > > > > Awesome! Thanks for reviewing!
> > > > > 
> > > > > > To me, a much
> > > > > > more important question is which of the two approaches is easier to
> > > > > > maintain long term. The pcp work needs to be done one way or the other.
> > > > > > Whether we want to tweak locking or do it at a very well defined time is
> > > > > > the bigger question.
> > > > > 
> > > > > That crossed my mind as well, and I went with the idea of changing locking 
> > > > > because I was working on workloads in which deferring work to a kernel 
> > > > > re-entry would cause deadline misses as well. Or more critically, the 
> > > > > drains could take forever, as some of those tasks would avoid returning to 
> > > > > kernel as much as possible. 
> > > > 
> > > > Could you be more specific please?
> > > 
> > > Hi Michal,
> > > Sorry for the delay
> > > 
> > > I think Marcelo covered some of the main topics earlier in this 
> > > thread:
> > > 
> > > https://lore.kernel.org/all/aZ3ejedS7nE5mnva@tpad/
> > > 
> > > But in syntax:
> > > - There are workloads that are projected not avoid as much as possible 
> > > return to kernelspace, as they are either cpu intensive, or latency 
> > > sensitive (RT workloads) such as low-latency automation.
> > > 
> > > There are scenarios such as industrial automation in which 
> > > the applications are supposed to reply a request in less than 50us since it 
> > > was generated (IIRC), so sched-out, dealing with interruptions, or syscalls 
> > > are a no-go. In those cases, using cpu isolation is a must, and since it 
> > > can stay really long running in userspace, it may take a very long time to 
> > > do any syscall to actually perform the scheduled flush.
> > > 
> > > - Other workloads may need to use syscalls, or rely in interrupts, such as 
> > > HPC, but it's also not interesting to take long on them, as the time spent 
> > > there is time not used for processing the required data.
> > > 
> > > Let's say that for the sake of cpu isolation, a lot of different
> > > requests made to given isolated cpu are batched to be run on syscall 
> > > entry/exit. It means the next syscall may take much longer than 
> > > usual.
> > > - This may break other RT workloads such as  sensor/sound/image sampling, 
> > > which could be generally ok with some of the faster syscalls for their 
> > > application, and now may perceive an error because one of those syscalls 
> > > took too long. 
> > > 
> > > While the qpw approach may cost a few extra cycles, it operates remotelly 
> > > and makes the system a bit more predictable. 
> > > 
> > > Also, when I was planning the mechanism, I remember it was meant to add 
> > > zero overhead in case of CONFIG_QPW=n, very little overhead in case of 
> > > CONFIG_QPW=y + qpw=0 (a couple of static branches, possibly with the 
> > > cost removed by the cpu branch predictor),  and only add a few cycles in 
> > > case of qpw=1 + !RT. Which means we may be missing just a few adjustments 
> > > to get there.
> > 
> > Leo,
> > 
> > v2 of the patchset adds only 2 cycles to CONFIG_QPW=y + qpw=0. 
> > The larger overhead was due to migrate_disable, which is now (on v2)
> > hidden inside the static branch.
> > My bad.
> 
> Hi Marcelo,
> 
> Great, hiding migrate_disable under the static branch is the best scenario.
> 
> I wonder why we spend 2 cycles on the static branches, though, should be 
> close to nothing unless the branch predictor is too busy already. Well, we 
> can always try to optimize in a different way.
> 
> Thanks for the effort on this!

Leo,

migrate_enable was leaking out of the static key section 
into the common error path.

With preempt_disable, as suggested by Vlastimil, those 2 cycles are
gone:

[   61.217232] kmalloc_bench: Avg cycles per kmalloc: 164
[   68.047789] kmalloc_bench: Avg cycles per kmalloc: 165
[   73.266568] kmalloc_bench: Avg cycles per kmalloc: 165
[  120.634168] kmalloc_bench: Avg cycles per kmalloc: 164
[  127.617872] kmalloc_bench: Avg cycles per kmalloc: 164
[  157.803679] kmalloc_bench: Avg cycles per kmalloc: 163
[root@fedvm kmalloc-perf-test]# dmesg | grep qpw
[    0.000000] Command line: BOOT_IMAGE=(hd0,gpt2)/vmlinuz-tip root=UUID=35cfa00b-ed70-483f-b7b2-1964e14f719e ro rootflags=subvol=root console=ttyS0,115200 qpw=0 skew_tick=1 tsc=reliable rcupdate.rcu_normal_after_boot=1 rcutree.nohz_full_patience_delay=1000 isolcpus=managed_irq,domain,14,15 amd_pstate=disable nosoftlockup crashkernel=1024M
[    0.118274] Kernel command line: BOOT_IMAGE=(hd0,gpt2)/vmlinuz-tip root=UUID=35cfa00b-ed70-483f-b7b2-1964e14f719e ro rootflags=subvol=root console=ttyS0,115200 qpw=0 skew_tick=1 tsc=reliable rcupdate.rcu_normal_after_boot=1 rcutree.nohz_full_patience_delay=1000 isolcpus=managed_irq,domain,14,15 amd_pstate=disable nosoftlockup crashkernel=1024M


