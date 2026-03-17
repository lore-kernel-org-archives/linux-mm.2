Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BCFCDFD8769
	for <linux-mm@archiver.kernel.org>; Tue, 17 Mar 2026 13:33:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EF9C66B0088; Tue, 17 Mar 2026 09:33:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ED1446B0089; Tue, 17 Mar 2026 09:33:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E0E426B008A; Tue, 17 Mar 2026 09:33:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id CC6626B0088
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 09:33:56 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 6D7C01B6F3D
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 13:33:56 +0000 (UTC)
X-FDA: 84555648072.03.7D55EA4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 6FB6EC0017
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 13:33:54 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=o0UGYuCD;
	spf=pass (imf10.hostedemail.com: domain of frederic@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=frederic@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773754434;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7wLThk9vqFCL8eaVlk4gPK1xgF/La36KrS918s5Lj0k=;
	b=Ka30nRGxI5q2dEvlePDitwMHA8RNAIW3YPsAMcTo04PH5xyBgQRZKG88UJ8HwZ6bep2GG3
	yIjsppMA4FfOGwTuIc0hG1zEqGAB9RuubOUFgd20tY1OT5Aei6KQoYhYYG1PGnJOYeUxsF
	dJrp6cp3rJaUmQV0VtIqir12ujxrRiE=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=o0UGYuCD;
	spf=pass (imf10.hostedemail.com: domain of frederic@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=frederic@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773754434; a=rsa-sha256;
	cv=none;
	b=F/BkjZJrpC0T5gyPHGkg7q8OQT1sDrmg+U4c4+XlOSYg8K07NJiQrvY2OBv3ibKy3QYyCh
	pQX/y7Lzlzwuu113tKANXvAsfth5vHrjpcASM9733Cw5qU6NItnNbi/cMjxLnQcxG7ygJ/
	DWSA0YX3nNYPpQGAotrU5O2URu7WmDY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 592504347A;
	Tue, 17 Mar 2026 13:33:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1141C2BCB5;
	Tue, 17 Mar 2026 13:33:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773754433;
	bh=JX2H/y+49Q+R+OOqtdz8X6bLyH5h+JbiWbT3ZJSu2fk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=o0UGYuCDKbFzDohH8kmxaxfxkxtFGeKr7GKbCyr4wkvQ9TsXZYxbSoxtpKJjSdqgP
	 pNgeUMuOnaaZcUjXRvQButrVBuYnMEb1lNrkme28GAWyEW/GvTok+Q7axIywujx3W5
	 P/McHw3f1Gnv1I7OKFswPVL8zJk5t+evfJYWgDYCy4QmQzNrejd+Ceas6JvxzkA6hk
	 UBrgVHaHPWAR+SpnHw/LeGUUhG0ddsheT4reiI5OURWEpbZnXxe2tdzzlzRxJV4flU
	 Hgq7PcMz+WSt0/9Qg5qry7/XinL13DvY6vhquBW7DrSn3jCnLgR3O6TwQ3X36QWbBX
	 uItNt/pwlq+dg==
Date: Tue, 17 Mar 2026 14:33:50 +0100
From: Frederic Weisbecker <frederic@kernel.org>
To: Leonardo Bras <leobras.c@gmail.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>,
	David Rientjes <rientjes@google.com>,
	Joonsoo Kim <iamjoonsoo.kim@lge.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Hyeonggon Yoo <42.hyeyoo@gmail.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Waiman Long <longman@redhat.com>, Boqun Feun <boqun.feng@gmail.com>
Subject: Re: [PATCH v2 2/5] Introducing qpw_lock() and per-cpu queue & flush
 work
Message-ID: <ablYPt92Y63GcIu2@localhost.localdomain>
References: <20260302154945.143996316@redhat.com>
 <20260302155105.214878062@redhat.com>
 <abSH40oW9qiVDXZS@pavilion.home>
 <abb2E3QW7t5Rhxrt@WindFlash>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <abb2E3QW7t5Rhxrt@WindFlash>
X-Stat-Signature: 1h87eg4ekcey9wgsi37bstf7j638hpsq
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: 6FB6EC0017
X-HE-Tag: 1773754434-262783
X-HE-Meta: U2FsdGVkX1+o+zl39wdwl5Si4eSW52kLUDDQpl8aOwhN78c13BPceJ78FE481T0XOhWpI2LYhvyXpDZWmzGl/NPy7O492FJr9vJjqO/+OfiLmPDNxiDMYoAFlJrZB5b42Tk8pxlZaXxYLw996110NsYlkdFe56FZ1cHvRrajd9lvua2nMmKA8lufwSY+2k1FFmIYPFLbdIX1+9P0DXAxCarba2ZN6rU7yJ68IzNvLFEiMKU9vFmWIKL5KRRzE/Ar3gNfP9dtl207OrWSSW5+6DXo3pjidmi7SMO3eWU0sQ4qM4l4qzyElDz+EMyyEdRe9u5zwtxzShM1POjxTnSjnFVCWWNHFI4vlvG8W6e8PRxZnYsM+isVqr+5Vo+El6kwz4Lum2mmBJdJvjNx7El/tjz/A5tKD105WSjh95cpu6QiY56lOJvt+lNksvW5KcSkpB8qkW7Gw8PHQqOQZ44hQEFXdq/kRbtQR52Dd9/dVzfdFW/dqOrAaL73BuMStlhWeMxBWNLRq7Gus85fC+/bKlkJp8hXciSpBj9mEHbs0Qgz/KyCWKeiWoNSaWxUtvMNIs0pnVlc3OJwi/CsTvGasb0AwYTAGkCTFYFAMFZe2XzvHKDPEH6YygzmVABK0z+5viriKqdM+V2epmO2m5Z9nVoO1CeR3nhrjOd8V4J4pteHg7hVUoFU075ofsglKFB/n5+10ZW6QVceVwXCjBqwCMfG70Fkt8+gkBu32iwLQuRWM6waBxtWCjCfKgxey1jvKSI1IaERWwIlgrievlVGVaAU29aOEySmcaK/v7fKdNuBoocV37qpIjpK66eCNgPf5IMyyqbElt+MdaNi+grMb5mi0/xhfcZPduRlcRE2Mog5g9TxeAp4xhVLj/rO94ak/uaA4dximfX3jidh0U9/gGcmnqeTaX2WeP4UhOGGv9Wg93w/fr1ZBy6rKjC45Gxhz6yVT06YZo1Vx70ivby
 oIPzUqSB
 TIBwy14MIK9pBQYkT+GEa8O3KerFVy419NFT9ev3v5gHEaDN8qMhUo4V53jaiTDqI5dtIBp6RnmlGt8ZoUbYSGIGDteXXBDAs09qUAs2NmcjuHowrYPWLCBvdiAnPyaw2zWy38c9b9hQBzecmTgKtorI0vTXHhPKrH3Z5RB+6OphUsSt/7/OV6D2pvdYI3+tOypM1Dp+3063XSAJeECEdi8nNbuC+zIrU17RwhR7upoHo6xswcgpmx5OX0ELdfw1sC30JEJVjMHmSGBJGZJLzIJFHtsZZHGN1nb+r6l6kgqwNPJq3axjs2SCI00/kjR91oh/UzWQmH6oy3No1qR+RYTVG5RwRCMMYhy2WtFYYj2idlzkUwydY81qkYgaZg1W06GPl
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Le Sun, Mar 15, 2026 at 03:10:27PM -0300, Leonardo Bras a écrit :
> On Fri, Mar 13, 2026 at 10:55:47PM +0100, Frederic Weisbecker wrote:
> > I find this part of the semantic a bit weird. If we eventually queue
> > the work, why do we care about doing a local_lock() locally ?
> 
> (Sorry, not sure if I was able to understand the question.)
> 
> Local locks make sure a per-cpu procedure happens on the same CPU from 
> start to end. Using migrate_disable & using per-cpu spinlocks on RT and 
> doing preempt_disable in non_RT.
> 
> Most of the cases happen to have the work done in the local cpu, and just 
> a few procedures happen to be queued remotely, such as remote cache 
> draining. 
> 
> Even with the new 'local_qpw_lock()' which is faster for cases we are sure 
> to have local usages, on qpw=0 we have to make qpw_lock() a local_lock as 
> well, as the cpu receiving the scheduled work needs to make sure to run it 
> all without moving to a different cpu.

But queue_work_on() already makes sure the work doesn't move to a different CPU
(provided hotplug is correctly handled for the work).

Looks like we are both confused, so let's take a practical example. Suppose
CPU 0 queues a work to CPU 1 which sets a per-cpu variable named A to the value
"1". We want to guarantee that further reads of that per-cpu value by CPU 1
see the new value. With qpw=1, it looks like this:

CPU 0                                               CPU 1
-----                                               -----

qpw_lock(CPU 1)
   spin_lock(&QPW_CPU1)
qpw_queue_for(write_A, 1)
    write_A()
       A1 = per_cpu_ptr(&A, 1)
       *A1 = 1
qpw_unlock(CPU 1)
    spin_unlock(&QPW_CPU1)
                                                   read_A()
                                                       qpw_lock(CPU 1)
                                                           spin_lock(&QPW_CPU1)
                                                       r0 = __this_cpu_read(&A)
                                                       qpw_unlock(CPU 1)
                                                           spin_unlock(&QPW_CPU1)
                                                   

CPU 0 took the spinlock while writing to A, so CPU 1 is guaranteed to further
observe the new value because it takes the same spinlock (r0 == 1)

Now look at the qpw=0 case:
                                  
CPU 0                                               CPU 1
-----                                               -----

qpw_lock(CPU 1)
   local_lock(&QPW_CPU0)
qpw_queue_for(write_A, 1)
    queue_work_on(write_A, CPU 1)
qpw_unlock(CPU 1)
    local_unlock(&QPW_CPU0)
                                                   // workqueue
                                                   write_A()
                                                       qpw_lock(CPU 1)
                                                           local_lock(&QPW_CPU1)
                                                       A1 = per_cpu_ptr(&A, 1)
                                                       *A1 = 1
                                                       qpw_unlock(CPU 1)
                                                           local_unlock(&QPW_CPU1)

                                                   read_A()
                                                       qpw_lock(CPU 1)
                                                           local_lock(&QPW_CPU1)
                                                       r0 = __this_cpu_read(&A)
                                                       qpw_unlock(CPU 1)
                                                           local_unlock(&QPW_CPU1)

Here CPU 0 queues the work on CPU 1 which writes and reads the new value
(r0 == 1). local_lock() / preempt_disable() makes sure the CPU doesn't change.

But what is the point in doing local_lock(&QPW_CPU0) on CPU 0 ?


> > > 
> > > @@ -2840,6 +2840,16 @@ Kernel parameters
> > >  
> > >  			The format of <cpu-list> is described above.
> > >  
> > > +	qpw=		[KNL,SMP] Select a behavior on per-CPU resource sharing
> > > +			and remote interference mechanism on a kernel built with
> > > +			CONFIG_QPW.
> > > +			Format: { "0" | "1" }
> > > +			0 - local_lock() + queue_work_on(remote_cpu)
> > > +			1 - spin_lock() for both local and remote operations
> > > +
> > > +			Selecting 1 may be interesting for systems that want
> > > +			to avoid interruption & context switches from IPIs.
> > 
> > Like Vlastimil suggested, it would be better to just have it off by default
> > and turn it on only if nohz_full= is passed. Then we can consider introducing
> > the parameter later if the need arise.
> 
> I agree with having it enabled with isolcpus/nohz_full, but I would 
> recommend having this option anyway, as the user could disable qpw if 
> wanted, or enable outside isolcpu scenarios for any reason.

Do you know any such users? Or suspect a potential usecase? If not we can still
add that option later. It's probably better than sticking with a useless
parameter that we'll have to maintain forever.

> > > +#define qpw_lockdep_assert_held(lock)			\
> > > +	lockdep_assert_held(lock)
> > > +
> > > +#define queue_percpu_work_on(c, wq, qpw)		\
> > > +	queue_work_on(c, wq, &(qpw)->work)
> > 
> > qpw_queue_work_on() ?
> > 
> > Perhaps even better would be qpw_queue_work_for(), leaving some room for
> > mystery about where/how the work will be executed :-)
> > 
> 
> QPW comes from Queue PerCPU Work
> Having it called qpw_queue_work_{on,for}() would be repetitve

Well, qpw_ just becomes the name of the subsystem and its prefix for APIs.
For example qpw_lock() doesn't mean that we queue and lock, it only means we lock.

> But having qpw_on() or qpw_for() would be misleading :) 
> 
> That's why I went with queue_percpu_work_on() based on how we have the 
> original function (queue_work_on) being called.

That's much more misleading at it doesn't refer to qpw at all and it only
suggest that it's a queueing a per-cpu workqueue.

> > Perhaps that too should just be selected automatically by CONFIG_NO_HZ_FULL and if
> > the need arise in the future, make it visible to the user?
> > 
> 
> I think it would be good to have this, and let whoever is building have the 
> chance to disable QPW if it doesn't work well for their machines or 
> workload, without having to add a new boot parameter to continue have 
> their stuff working as always after a kernel update.
> 
> But that is open to discussion :)

Ok I guess we can stick with the Kconfig at least in the beginning.

Thanks.

-- 
Frederic Weisbecker
SUSE Labs

