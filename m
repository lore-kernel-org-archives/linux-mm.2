Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E36C5D58CBE
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 01:39:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C95636B0005; Sun, 22 Mar 2026 21:39:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C461F6B0088; Sun, 22 Mar 2026 21:39:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B34A06B0089; Sun, 22 Mar 2026 21:39:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9E6A66B0005
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 21:39:08 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 2E019140998
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 01:39:08 +0000 (UTC)
X-FDA: 84575619576.23.1381A5A
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	by imf12.hostedemail.com (Postfix) with ESMTP id 269B44000D
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 01:39:05 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=jvoSpXgz;
	spf=pass (imf12.hostedemail.com: domain of leobras.c@gmail.com designates 209.85.128.48 as permitted sender) smtp.mailfrom=leobras.c@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774229946;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Fx2cmrzWqJT91Br9jsPMyIKQu88+WNBdQ+o5h791kHo=;
	b=OEYSAH4bvsQgiWTxnPpovD1n/giM5vgAF5/lzd8s4LA3kitPaT576i8OwXKwJTa6n2JDa5
	7RR9tHO+XLiM+fsjy14cB/ziOjMlyVxAEXkaqEu+MiWnPFhDjlSgeGlQDpCc+rxHHm41/p
	6RapOep/88dTWlhPHVTrqI9RFYyKv5g=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=jvoSpXgz;
	spf=pass (imf12.hostedemail.com: domain of leobras.c@gmail.com designates 209.85.128.48 as permitted sender) smtp.mailfrom=leobras.c@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774229946; a=rsa-sha256;
	cv=none;
	b=ZYHboTXybKH0eU9esae5JE7HanYysPe+Du5cWhTPP7h5wpGSGBXLx25XK+0k7UAqAo4ab8
	f6+XXPE03MWUEdZwN4EN/dwTVVYjbyEjO/T7XnwV9fzXESCux1S8YkRAF/EvjxEVkpAwFS
	JD5G9Nl4uf8gfKNZ+e/zsPwHtkKH+Qg=
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-4852e9ca034so20769505e9.2
        for <linux-mm@kvack.org>; Sun, 22 Mar 2026 18:39:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1774229945; x=1774834745; darn=kvack.org;
        h=content-transfer-encoding:content-disposition:mime-version
         :references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Fx2cmrzWqJT91Br9jsPMyIKQu88+WNBdQ+o5h791kHo=;
        b=jvoSpXgzR9vRNbuLmblquU5WJFk/QXcZ9+Kkto0JPUweYjwWMODfF5En7hm+wZrWH4
         JRQ5LyXKo7uXH2/533Z2QwgOqW4PU2sx7HZCbvryB1dYUVIkGvuRp/7lgcMkYKaDK1RK
         T0W+BoABNKDyaZweh34xRGH9ltDhy5Lat2/NaE4mV9v3ilrR7eezJp5clKxM8CBOhSbh
         6IO7iZcf+nMFfqxEtCPzyLZAbcLQKiJXY68lZlVWu2LrNHS87ydhjy7zKe6PIk0RI4Ad
         31D6OOKldd3jRwV/2zq/ttKHeeqRhPxMKWWOm1xk36r9+OYQ+drzcxijRCtM/37jcind
         rMnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774229945; x=1774834745;
        h=content-transfer-encoding:content-disposition:mime-version
         :references:in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Fx2cmrzWqJT91Br9jsPMyIKQu88+WNBdQ+o5h791kHo=;
        b=sfQswxH9szPsf212xADp5e5BFEiVJmJHa6iQrIP4dbyPw0OAfDV2bvfO/6EG7f7nMn
         nU5vm3reaVHdTS4rMmse5KZmMjvy3XoHmvSYEy9HmXBdudKMCvaCqQZas0MJgHbfkVLZ
         dLUBFf0VY+f9ykN5XjXDBjWg97w5aJZ7fmtB3Lljl9kywGfgwDBv197HqgtDoq7/5G1s
         CEVmq6w+T3OzHLC/ycFp3WzPBN1OxBD4FJMjZK2Sp28TjrNEtVTaquVv75hiyoruLqK4
         c1MPFQQ3xtHMtvfw7z5W0DOirTvLAcL1j+ECrpEt+wgduxQxw6RB3qm0gbZ4BQrmX27k
         9Xmw==
X-Forwarded-Encrypted: i=1; AJvYcCXXZ8guZYUl9WCPa39LQT7ae4v4rHSZrg2tavYV70ytm/toqNM2WatcgQ98oPk1AL+hM+tIjKKw9w==@kvack.org
X-Gm-Message-State: AOJu0Yz76drO25SaNp977gUK635jHKOyrix283Z7Nhlxx5Y/vi7iM0lh
	ElEap4zpV8Jr8yTdXthdMmwlnHPa5aK2F1gECQ54cqp9blb9LchtWLn4
X-Gm-Gg: ATEYQzxVpN9XjLuk1nnukUsManNdS8Ee1utqOnJI6Ho6GNXHNq8X77TvkwKVBtw12zv
	Febk3fJJCQ1ePUzETBi6gABAQBYLAK8Cqo5JpHd8gLWXV1pO9InG5JSIcEdmdw2zencvr7AACnw
	dvdbpprhWnMbzVxQRk1hBglEMnsbt2bzQuVnHaTFw/R/F0lZyUkOaLwPB2P0rEI4J36I4bcPQad
	n9Ay5JNuMjrgAGQ/9PiN0OlHiWDkGcnjFX+bKiUtB5YH8lSUKuKhlu6E4TDdUf2dfIwp600R+HD
	G5wdKGZi5TQUf56k1TF+w7EVrWZlHkd9U0DojuXOAUwKOY0TgVzlEIjVNbFIEtZ3GSM4rU+Ox9P
	Q4BgdVhDWFGtpiXsKSqqXm+AvQaFK6CIlDDyUaEn/0j7ChjGG/2hl5+fklCxebwbUIQLbp/QxyA
	0mM5StTyLdpnzGRHPZ+H2+ee4zasOsAZ+6lLc=
X-Received: by 2002:a05:600c:8b24:b0:485:3dfc:57c with SMTP id 5b1f17b1804b1-486fee0fcf6mr148878665e9.21.1774229944373;
        Sun, 22 Mar 2026 18:39:04 -0700 (PDT)
Received: from WindFlash.powerhub ([2a0a:ef40:1b2a:fa01:9944:6a8c:dc37:eba5])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43b644bdaf8sm29704360f8f.13.2026.03.22.18.39.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 22 Mar 2026 18:39:03 -0700 (PDT)
From: Leonardo Bras <leobras.c@gmail.com>
To: Frederic Weisbecker <frederic@kernel.org>
Cc: Leonardo Bras <leobras.c@gmail.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christoph Lameter <cl@linux.com>,
	Pekka Enberg <penberg@kernel.org>,
	David Rientjes <rientjes@google.com>,
	Joonsoo Kim <iamjoonsoo.kim@lge.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Hyeonggon Yoo <42.hyeyoo@gmail.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Waiman Long <longman@redhat.com>,
	Boqun Feun <boqun.feng@gmail.com>
Subject: Re: [PATCH v2 2/5] Introducing qpw_lock() and per-cpu queue & flush work
Date: Sun, 22 Mar 2026 22:38:56 -0300
Message-ID: <acCZsEOsrv5Ku-mu@WindFlash>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <ablYPt92Y63GcIu2@localhost.localdomain>
References: <20260302154945.143996316@redhat.com> <20260302155105.214878062@redhat.com> <abSH40oW9qiVDXZS@pavilion.home> <abb2E3QW7t5Rhxrt@WindFlash> <ablYPt92Y63GcIu2@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 269B44000D
X-Stat-Signature: w53eazyroa46gigua3f5ik4p1dufgmem
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1774229945-835579
X-HE-Meta: U2FsdGVkX1+qQEVsWjf/Y6aEtaPQuFMqz+E6SEn2YmQwQgJe5ovOIC+I+Gt6ZiYLEcHcHEOkpmoHjFGjShMp5Ebwak9B5VRHQ6mcNIIQqHhhSnlHwv8oZxS6qxtnc62XDXCzkFJu/7jU5ezbMQan3Zvs8nCov8bx9WnW7dkRbvZvj1O8LRAHy60xn4ihzmNTCMmHQcI+IWKxQe72z3yJ9UoWQOBGYIduKigtudOv8CXAzP4vIRxwrAXe1Nhds4sGgIbuhbK/ah/sHKZ8vibn2xuQtLMaNYhLcxRgtia1vIhCPCbWh5gJN7JuXa4Uwwht8DtE++882p+Jd+FCmzKKdTcOFRLYvLLmqfXtFd3oV9CGzihM48kKHOZcNa81ei5CdiQlX6QaLVKfY8+WWjK/3OMC2lcGHO1xa5kaobwl5+sxVGk28+HBDqFeKUVRQRnLQT7MO9IH+Q7EL0ZAusp7Xec3iPUdGHJCuH82g6WRRb5Xr1qcWpQLnxhTUtCLEu1gMwm+jVCaF+wUSYuocPh0cxrXpkW7wCCqWXfIymE44J2pQw4d+U7cIE/lx+kay+yXz2XqsoCK960InIaXoKFS21W/YUeYLKjENUwk01sHlBj9qs2OskWcxYnQ3+f/EqjREhjgB+LGcqURxNNwXmXgpJ9M9cPHj2UG4ceMPQRlC5bS5sijSn+ZKPYGPsbPigfNHF5ncWrQ9UmDF/uYNUTrydek6WhAXItAu6RLxaw9WEomOVZl/AvcCfm0Rok35Cj0WAWwMQ+57fvS/oXiRFTslgXb+tguZNzb4S9FQ8/bex8jBOwGWT+tgGytEU4t53JKcsd7Ors9B2jUmdBKrsIXOOC4urqxzwmCD91Ka+6O2i0rKloEh072gUEIj7ToHVVqbRq0qbhdwMVOcGQMpjsjvprWKOismi7jImp+MDCsKaiRnWZifJJqhS+oTV+3vnEofZao7812crOtz4PGn2G
 UPiR0h4f
 6I2iDieKC81XgACnisImS7e3c/g7eaLKmhRiLgH58iKN2vmB0QHfBcNSbrxb+/TNZhNtwoShUY0mcUeRpCPph6IZwv+rsKKKEb90U9Y/R+a0wK09oClkkGkfGo3garl1u/Ogg3mY3ObQsi7gkBE9M0VzGGlZE78oOC281nK2I79mslQvA4EasxyXiFHKaa6/fVn0dI5zjtNWBl08pmwLUvdtt2bEx/DO4zGcnb726GmsVq90JXypDp+AknZsGZRQlyBT4lmLgxxMYY4oSvRreIHamuAPxhmlC0EzzE+ZLceO+IkY37XLqknD5WVsEpg3cubUDmyuCiuVp9HfRYxQgh9Zsy5TRYKgCMakIxfS+hr8+HQoJtqV2+1Bh6sB8Q2ygPn1W8Ml8v/0PNWt20mmTEhvSo6TvXI6fYtgd/Wb454K1BJUokdKz99nQA1HFRzkfx6H6nUZMJ9FIzHYvWIXic6Cp6wQRZLdf2BvJk4Tf+5zOLBJdB3S3YalVsOKUeK/HzBMDzhxxK2qjdu0EPKlXzm9q7SrQz8jB04Yefo91XNKGJkS24Bue7Dau9gKDn4a4BZiCnn0WbyQOHkYCPrHQ2im4+TjnHlg8YcFXj5yG0v0bXSlIbs3Bgxh8FjCvDMfhn0a55kUTdyme3B5o3D6gtq+vrRiYlKJbCFSDTaoRWrRY/NFsrVqAA540kA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 17, 2026 at 02:33:50PM +0100, Frederic Weisbecker wrote:
> Le Sun, Mar 15, 2026 at 03:10:27PM -0300, Leonardo Bras a écrit :
> > On Fri, Mar 13, 2026 at 10:55:47PM +0100, Frederic Weisbecker wrote:
> > > I find this part of the semantic a bit weird. If we eventually queue
> > > the work, why do we care about doing a local_lock() locally ?
> > 
> > (Sorry, not sure if I was able to understand the question.)
> > 
> > Local locks make sure a per-cpu procedure happens on the same CPU from 
> > start to end. Using migrate_disable & using per-cpu spinlocks on RT and 
> > doing preempt_disable in non_RT.
> > 
> > Most of the cases happen to have the work done in the local cpu, and just 
> > a few procedures happen to be queued remotely, such as remote cache 
> > draining. 
> > 
> > Even with the new 'local_qpw_lock()' which is faster for cases we are sure 
> > to have local usages, on qpw=0 we have to make qpw_lock() a local_lock as 
> > well, as the cpu receiving the scheduled work needs to make sure to run it 
> > all without moving to a different cpu.
> 
> But queue_work_on() already makes sure the work doesn't move to a different CPU
> (provided hotplug is correctly handled for the work).
> 
> Looks like we are both confused, so let's take a practical example. Suppose
> CPU 0 queues a work to CPU 1 which sets a per-cpu variable named A to the value
> "1". We want to guarantee that further reads of that per-cpu value by CPU 1
> see the new value. With qpw=1, it looks like this:
> 
> CPU 0                                               CPU 1
> -----                                               -----
> 
> qpw_lock(CPU 1)
>    spin_lock(&QPW_CPU1)
> qpw_queue_for(write_A, 1)
>     write_A()
>        A1 = per_cpu_ptr(&A, 1)
>        *A1 = 1
> qpw_unlock(CPU 1)
>     spin_unlock(&QPW_CPU1)
>                                                    read_A()
>                                                        qpw_lock(CPU 1)
>                                                            spin_lock(&QPW_CPU1)
>                                                        r0 = __this_cpu_read(&A)
>                                                        qpw_unlock(CPU 1)
>                                                            spin_unlock(&QPW_CPU1)
>                                                    
> 
> CPU 0 took the spinlock while writing to A, so CPU 1 is guaranteed to further
> observe the new value because it takes the same spinlock (r0 == 1)
> 

Here, if we are in CPU0 we should never take the qpw_lock(CPU1) unless we 
are inside queue_percpu_work_on().

Maybe I am not getting your use case :/

Also, I don't see a case where we would need to call 
queue_percpu_work_on() inside a qpw_lock(). This could be dangerous as it 
could be the case in another cpu and cause a deadlock:

CPU 0 				CPU 1
qpw_lock(0)			qpw_lock(1)
...				...
queue_percpu_work_on()		queue_percpu_work_on()
	qpw_lock(1)			qpw_lock(0)


> Now look at the qpw=0 case:
>                                   
> CPU 0                                               CPU 1
> -----                                               -----
> 
> qpw_lock(CPU 1)
>    local_lock(&QPW_CPU0)
> qpw_queue_for(write_A, 1)
>     queue_work_on(write_A, CPU 1)
> qpw_unlock(CPU 1)
>     local_unlock(&QPW_CPU0)
>                                                    // workqueue
>                                                    write_A()
>                                                        qpw_lock(CPU 1)
>                                                            local_lock(&QPW_CPU1)
>                                                        A1 = per_cpu_ptr(&A, 1)
>                                                        *A1 = 1
>                                                        qpw_unlock(CPU 1)
>                                                            local_unlock(&QPW_CPU1)
> 
>                                                    read_A()
>                                                        qpw_lock(CPU 1)
>                                                            local_lock(&QPW_CPU1)
>                                                        r0 = __this_cpu_read(&A)
>                                                        qpw_unlock(CPU 1)
>                                                            local_unlock(&QPW_CPU1)
> 
> Here CPU 0 queues the work on CPU 1 which writes and reads the new value
> (r0 == 1). local_lock() / preempt_disable() makes sure the CPU doesn't change.
> 
> But what is the point in doing local_lock(&QPW_CPU0) on CPU 0 ?

I can't see the case where one would need to hold the qpw_lock while 
calling queue_percpu_work_on(). Holding the qpw_lock() (as is the case of
local_lock()) should be done only when one is working on data particular to 
that cpu structures. Queuing work on other CPU while touching this cpu data 
is unexpected to me. 



> 
> 
> > > > 
> > > > @@ -2840,6 +2840,16 @@ Kernel parameters
> > > >  
> > > >  			The format of <cpu-list> is described above.
> > > >  
> > > > +	qpw=		[KNL,SMP] Select a behavior on per-CPU resource sharing
> > > > +			and remote interference mechanism on a kernel built with
> > > > +			CONFIG_QPW.
> > > > +			Format: { "0" | "1" }
> > > > +			0 - local_lock() + queue_work_on(remote_cpu)
> > > > +			1 - spin_lock() for both local and remote operations
> > > > +
> > > > +			Selecting 1 may be interesting for systems that want
> > > > +			to avoid interruption & context switches from IPIs.
> > > 
> > > Like Vlastimil suggested, it would be better to just have it off by default
> > > and turn it on only if nohz_full= is passed. Then we can consider introducing
> > > the parameter later if the need arise.
> > 
> > I agree with having it enabled with isolcpus/nohz_full, but I would 
> > recommend having this option anyway, as the user could disable qpw if 
> > wanted, or enable outside isolcpu scenarios for any reason.
> 
> Do you know any such users? Or suspect a potential usecase? If not we can still
> add that option later. It's probably better than sticking with a useless
> parameter that we'll have to maintain forever.

Out of my head, I can think only on HPC scenario where user wants to make 
use of the regular/RT scheduler for many small workloads, but doesn't like 
the impact of IPI on those cases. Such systems that explore memory at it's 
limit will also benefit from those, for example, if cache gets drained 
remotely very often.

None of those necessarily will need to or benefit from isolcpus, and may 
want to just use the kernel scheduler policies. 

> 
> > > > +#define qpw_lockdep_assert_held(lock)			\
> > > > +	lockdep_assert_held(lock)
> > > > +
> > > > +#define queue_percpu_work_on(c, wq, qpw)		\
> > > > +	queue_work_on(c, wq, &(qpw)->work)
> > > 
> > > qpw_queue_work_on() ?
> > > 
> > > Perhaps even better would be qpw_queue_work_for(), leaving some room for
> > > mystery about where/how the work will be executed :-)
> > > 
> > 
> > QPW comes from Queue PerCPU Work
> > Having it called qpw_queue_work_{on,for}() would be repetitve
> 
> Well, qpw_ just becomes the name of the subsystem and its prefix for APIs.
> For example qpw_lock() doesn't mean that we queue and lock, it only means we lock.
> 

Locks for queue'ing per-cpu work. :D

> > But having qpw_on() or qpw_for() would be misleading :) 
> > 
> > That's why I went with queue_percpu_work_on() based on how we have the 
> > original function (queue_work_on) being called.
> 
> That's much more misleading at it doesn't refer to qpw at all and it only
> suggest that it's a queueing a per-cpu workqueue.
> 

Humm, maybe qpw_queue_for/on()?

Or maybe change the name of the API for pw:
pw_lock()/unlock
pw_queue();
pw_flush()

and so on?

That way it stays true to what means :)


> > > Perhaps that too should just be selected automatically by CONFIG_NO_HZ_FULL and if
> > > the need arise in the future, make it visible to the user?
> > > 
> > 
> > I think it would be good to have this, and let whoever is building have the 
> > chance to disable QPW if it doesn't work well for their machines or 
> > workload, without having to add a new boot parameter to continue have 
> > their stuff working as always after a kernel update.
> > 
> > But that is open to discussion :)
> 
> Ok I guess we can stick with the Kconfig at least in the beginning.
> 
> Thanks.
> 
> -- 
> Frederic Weisbecker
> SUSE Labs


Thanks!
Leo

