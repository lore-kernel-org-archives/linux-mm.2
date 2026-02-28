Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 54E2D1048926
	for <linux-mm@archiver.kernel.org>; Sat, 28 Feb 2026 01:23:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9725A6B0089; Fri, 27 Feb 2026 20:23:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 918FE6B008A; Fri, 27 Feb 2026 20:23:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 81B1D6B008C; Fri, 27 Feb 2026 20:23:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6DBE06B0089
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 20:23:45 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id DAFF31A0999
	for <linux-mm@kvack.org>; Sat, 28 Feb 2026 01:23:44 +0000 (UTC)
X-FDA: 84492118368.09.DA60504
Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	by imf13.hostedemail.com (Postfix) with ESMTP id D23FB20005
	for <linux-mm@kvack.org>; Sat, 28 Feb 2026 01:23:42 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=M2QEMysW;
	spf=pass (imf13.hostedemail.com: domain of leobras.c@gmail.com designates 209.85.221.42 as permitted sender) smtp.mailfrom=leobras.c@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772241823;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kpdBycfJnCA5XxdzZKoEBDpwQf+1LoRkJkd0FNmFdis=;
	b=PbPLj0AGz8wwE4KQDoVD32unwLiVPQTJTdeJ55cBZKMMGiBgiZy8P4+vtcZMcZqEtgUViQ
	y/IUbmHZpYcOI1gXE6ZT45T9utfxC+ZuZpf8v2I2OjADzo4943Wu28wss8iXgV5KtuVnrp
	xTH9FmMmAjJ92yzWfupHfTHdU/Z1vVI=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=M2QEMysW;
	spf=pass (imf13.hostedemail.com: domain of leobras.c@gmail.com designates 209.85.221.42 as permitted sender) smtp.mailfrom=leobras.c@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772241823; a=rsa-sha256;
	cv=none;
	b=ymNdvGlkgJgdUokomsRdZvveL5A2fUEdfQGvmhGMuvvaUpYkTVFwYTtqbHQ/tgZ1I4+ixZ
	gZWAXJWRaMdxUUeszNH2LfHXDVAfeNKKeuOv0D8pDMEPyp6ZG8//YP84o10U8LVFv5Tsj/
	lzTkZEvBnvtTMoo4KsHoYnqfRtxAx6I=
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-436356740e6so2708447f8f.2
        for <linux-mm@kvack.org>; Fri, 27 Feb 2026 17:23:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772241821; x=1772846621; darn=kvack.org;
        h=content-transfer-encoding:content-disposition:mime-version
         :references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=kpdBycfJnCA5XxdzZKoEBDpwQf+1LoRkJkd0FNmFdis=;
        b=M2QEMysWkhYhZKpermR2H6RKd4e6CRdoDK3nyJCSFJUi4yE9+m69d5K56gaNmbZcUb
         rEKAk5HWuLxbxRq2Xenue7tLKZme7W07i4FPmAHKCuA4ySKpAX/RqUNJI4O8N7iWnmUp
         iMqA4N4MnNcx+Se2T8Jj5h+gw+MSa51HhUIJQLCxL2SiRuxsFygXTytY6AuV/JYpRUvg
         Y1Y1jke17RKv2BmyZPjnvuoDncgcRiXbk6GZESyAxGG8E1T4PJwJDApPJimCjr6slUaD
         /166gDcZzVl+dtdm6H/7sW8L6OTQ83DQeFFaecavh+jq9wJVBMtUkX5F8mo9rfG1Jr0e
         ZeZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772241821; x=1772846621;
        h=content-transfer-encoding:content-disposition:mime-version
         :references:in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=kpdBycfJnCA5XxdzZKoEBDpwQf+1LoRkJkd0FNmFdis=;
        b=O+DZ9LV18gbLZjzF2lh/IUWrX0H5ihDA7N3ENund+aCOya5B8fINFZeBxJ2YuY/iam
         C/PreKVWb5COisS2InMIZj6jXwps8T01UcHzksBlL9EogqNCfiRonHIbkXtnPSoliC4V
         xshEe5E69pU3gEiUQKR40HXxZexvIZB/xNU+iaHg+AkAqUEXLECZaJJWCJoiPGs2vWZL
         Y98zfvAucSpa7MGs8dC5vgLBq8SYSIijV6+SaOVhFn/3IHW7+iENR0hh9JIUuSKaPthp
         fxxj+9QEfm/ISl1POBEVvSDfhfkTuwPtC1sltPelRdtuI5xL3hFLz4y5S5WQGfzTmNm6
         SIsA==
X-Forwarded-Encrypted: i=1; AJvYcCXTGCC1DtghUOAWczWMWtkMgA7mEWziy7jOXE+osnDk9H6smESCo1hsEmAQSbOWmqAtLLzPbUIjlA==@kvack.org
X-Gm-Message-State: AOJu0Yzjp0eYefhsJ2qy5UhkLXmlEFe/SqbdBzPj+XG8TkWacfXDtLFz
	1VUnmw+FYeRZbMQmXuoFoGVn23XzezzbcGvRZZkkiI8Jklerc5WZy0AZ
X-Gm-Gg: ATEYQzx117i/IYQykKBPbsMg3XnHZgInH/mffGliVq4Ny8PTggjUqJQY9Y+no4l1ZXO
	uVQpAc9rYL0OEckP5uHwbrpmSSgZucBxMMYHmY6SC75tmNsAzLD5FU/8EbpokH0AHrG+g9apfzk
	o0bbKU6N3sJL1qOC8VrgRVshjz0jPw7kvWQ3nCm4ym0FO1iWifVQ/5LtxB53jrLTcK699UTA/v5
	liARfPxfEIhSVWGRFkb9zFbBIp0Bn1vUqCwF6zXOV9uLTXuDl1IBuc133oiikva3zc6aGPoi4z4
	Oll3VT47mTY0nTqC7EbvPChhsZzn9GRz7QQVe0tRHh2pMMY8aanzHfST+o1bdF4ZIxytPSamFE7
	yx3UT9P9033N64H2f33B4s05AqGBiMv8GLi2oRUmcXwIbPYt0gVvynFDqN1cCStk9vf4wnu040o
	Z5iSyLT5mURTTTUDuPxJNjXkiJO2HuhYyrrAw=
X-Received: by 2002:a05:6000:1845:b0:435:add0:3d68 with SMTP id ffacd0b85a97d-4399de33986mr8879477f8f.58.1772241820909;
        Fri, 27 Feb 2026 17:23:40 -0800 (PST)
Received: from WindFlash.powerhub ([2a0a:ef40:1b2a:fa01:9944:6a8c:dc37:eba5])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4399c75b272sm10193021f8f.24.2026.02.27.17.23.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Feb 2026 17:23:40 -0800 (PST)
From: Leonardo Bras <leobras.c@gmail.com>
To: Michal Hocko <mhocko@suse.com>
Cc: Leonardo Bras <leobras.c@gmail.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	Johannes Weiner <hannes@cmpxchg.org>,
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
	Leonardo Bras <leobras@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Waiman Long <longman@redhat.com>,
	Boqun Feng <boqun.feng@gmail.com>,
	Frederic Weisbecker <fweisbecker@suse.de>
Subject: Re: [PATCH 0/4] Introduce QPW for per-cpu operations
Date: Fri, 27 Feb 2026 22:23:27 -0300
Message-ID: <aaJDjmnfuo8AM6J9@WindFlash>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <aZwYmNuucBspCYhk@tiehlicka>
References: <20260206143430.021026873@redhat.com> <aYs6Ju2G4bm6_tl2@tiehlicka> <aYxviLoWsrLqDU7o@tpad> <aYywl1hdBQP2_slo@tiehlicka> <aZDw6xI2izFDfuuu@WindFlash> <aZL45yORfkNvS9Rs@tiehlicka> <aZjY9h3XXMNY-Ytd@WindFlash> <aZwYmNuucBspCYhk@tiehlicka>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-Stat-Signature: rx6pndph8o5c5hoistcf3x7hi6ia6onq
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: D23FB20005
X-HE-Tag: 1772241822-508696
X-HE-Meta: U2FsdGVkX1+aFkxPt8hOkEsKPoUX2ezDBZnwGXtGNZlIW/hoMb+lPoMjTVfe+3CzxP3KJ9ubowWRfqbjBrrord0hMaxkhif7bKc32EqaY7MxmZboNa4spuW9fDU37+RR7Oq8RnhO87Og057wblsCsn6IuSErr/2MhG96Xrll/eltCn54gpnAt7P2CqokblwFlI35UzRa0opWRHgJGVycAQX+3w59+SCJgE8LS3uUamgZcYJhTNaEjDGbQZYQaMuInc8FXO6PIuyBTR+04lGd8hJP9TZkPVxJXjYU9NkkwN1Bl8MLNSzikAKi6I1rE9WV7rEmBqXiWNC/PglAYn85/mqjxF883ecmbI7P66mYEnYa9NZmlZzVTFmIGSvjb/pu/Ksa9TUI2kSEAD58HL0gNUu5m/Oj341wodDN1QfCTeIs0U9JrZrTkcIucoTosXQDbx9Igz9fZGJHG7hm9FHwobLNXX5uA7WBRDeeC04wSAUtorF3DkbXhhyKrAHnni0CwIWijQhaBz7LkTPJNd9G7bh290tMr0y4VkEPSPVBadaDoGDGYJM9liwYZe2j260CfA9ZovO8GqjYM1i7U0iYBbgO7sWL/wO8PjAXbfx/N5VJB2SDwLI7TAENyvzSeY1JNV3Qdr7ceOmSYkoonzre5aI2B8wMbs/cBqDtb/pYFv/6y+gtOxH6wq5cu/TMmlKCElLbMkpHwE4xsVvBt21WvVZDGd9agxkcfvT6qLcggfeM81j3qMGn2JN0o98T8EZAe+466WrdpwDm0rqYqAKFV+GpbW94jrn1/OlRzR92NcRb7JGsgphV7101oyydTixeu69bU+lt/rcmGdYNs/3CxnAQLIDb1Cxq/8bhn53ORfhO1LHDTnX00VGBCrO3rwO+RhPaPQ6M5zxvl2ATBc95Hdr/cxFs8+9Yo8lNfpMCKjqMRJDIwJw6m8panGvUpWRpg7rdzWxjG16DsOz9s2K
 he7zI0OA
 YME7bUgaTsbozRZkWO/tC529Rf9Zvy0Wb+D76EUMIwcXmr9NvSLyGtXns3Gy+76hNxE+weCplGn5fTOcMaMRJ540tDGmcSz+bhrVCBJvkfJBzRr2WcHlVuSeaB05Jc5fRgNEhBGbG5X8kPHP1oLUe4gMqw4fKyeLHFFzPa39ZbHif1gAmHoljOpM9PNb807r0S/LrhgUPd389+IrRSwgehEYzLK3Gfv5vKaQ0vJEHG/02Dd3+yZANJkjLQh/RY+EIrw8+8F6h4w2JHQhZiCc0xA0eSa7Nl8IEY0+b/h0XXCZ9qutx8O9xEkFbfbVCGMVc20JjuoWdck7ORz1zkNYZW/HTO5U9DK/f5TRna3BrEOT6AoYuhtIYOLkOwbUKk4QriXfqsCEAqczGGmear3E3X/XNW1hM/g4RK59Ce8rb1/DcfNYiYYX6YD8C+A0ymWL1lfbOjvVZixuCp5e1OfOOgmZciDxVF37/BCKXhRPFGTTpFknCOyYOor/1N9uoMXRKsBkwAydnxvAVa6zDtEVP+NcqwjYo7Vok75jlzD26QEzMzl+Yjyxa7n/ETpX9JPkn9h/Nmi1iPCVeeaW4q4PYr3r/xIvsXwYU6lrTEgA+9N3nc6GJOEdm+ZJk9Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Feb 23, 2026 at 10:06:32AM +0100, Michal Hocko wrote:
> On Fri 20-02-26 18:58:14, Leonardo Bras wrote:
> > On Mon, Feb 16, 2026 at 12:00:55PM +0100, Michal Hocko wrote:
> > > On Sat 14-02-26 19:02:19, Leonardo Bras wrote:
> > > > On Wed, Feb 11, 2026 at 05:38:47PM +0100, Michal Hocko wrote:
> > > > > On Wed 11-02-26 09:01:12, Marcelo Tosatti wrote:
> > > > > > On Tue, Feb 10, 2026 at 03:01:10PM +0100, Michal Hocko wrote:
> > > > > [...]
> > > > > > > What about !PREEMPT_RT? We have people running isolated workloads and
> > > > > > > these sorts of pcp disruptions are really unwelcome as well. They do not
> > > > > > > have requirements as strong as RT workloads but the underlying
> > > > > > > fundamental problem is the same. Frederic (now CCed) is working on
> > > > > > > moving those pcp book keeping activities to be executed to the return to
> > > > > > > the userspace which should be taking care of both RT and non-RT
> > > > > > > configurations AFAICS.
> > > > > > 
> > > > > > Michal,
> > > > > > 
> > > > > > For !PREEMPT_RT, _if_ you select CONFIG_QPW=y, then there is a kernel
> > > > > > boot option qpw=y/n, which controls whether the behaviour will be
> > > > > > similar (the spinlock is taken on local_lock, similar to PREEMPT_RT).
> > > > > 
> > > > > My bad. I've misread the config space of this.
> > > > > 
> > > > > > If CONFIG_QPW=n, or kernel boot option qpw=n, then only local_lock 
> > > > > > (and remote work via work_queue) is used.
> > > > > > 
> > > > > > What "pcp book keeping activities" you refer to ? I don't see how
> > > > > > moving certain activities that happen under SLUB or LRU spinlocks
> > > > > > to happen before return to userspace changes things related 
> > > > > > to avoidance of CPU interruption ?
> > > > > 
> > > > > Essentially delayed operations like pcp state flushing happens on return
> > > > > to the userspace on isolated CPUs. No locking changes are required as
> > > > > the work is still per-cpu.
> > > > > 
> > > > > In other words the approach Frederic is working on is to not change the
> > > > > locking of pcp delayed work but instead move that work into well defined
> > > > > place - i.e. return to the userspace.
> > > > > 
> > > > > Btw. have you measure the impact of preempt_disbale -> spinlock on hot
> > > > > paths like SLUB sheeves?
> > > > 
> > > > Hi Michal,
> > > > 
> > > > I have done some study on this (which I presented on Plumbers 2023):
> > > > https://lpc.events/event/17/contributions/1484/ 
> > > > 
> > > > Since they are per-cpu spinlocks, and the remote operations are not that 
> > > > frequent, as per design of the current approach, we are not supposed to see 
> > > > contention (I was not able to detect contention even after stress testing 
> > > > for weeks), nor relevant cacheline bouncing.
> > > > 
> > > > That being said, for RT local_locks already get per-cpu spinlocks, so there 
> > > > is only difference for !RT, which as you mention, does preemtp_disable():
> > > > 
> > > > The performance impact noticed was mostly about jumping around in 
> > > > executable code, as inlining spinlocks (test #2 on presentation) took care 
> > > > of most of the added extra cycles, adding about 4-14 extra cycles per 
> > > > lock/unlock cycle. (tested on memcg with kmalloc test)
> > > > 
> > > > Yeah, as expected there is some extra cycles, as we are doing extra atomic 
> > > > operations (even if in a local cacheline) in !RT case, but this could be 
> > > > enabled only if the user thinks this is an ok cost for reducing 
> > > > interruptions.
> > > > 
> > > > What do you think?
> > > 
> > > The fact that the behavior is opt-in for !RT is certainly a plus. I also
> > > do not expect the overhead to be really be really big. 
> > 
> > Awesome! Thanks for reviewing!
> > 
> > > To me, a much
> > > more important question is which of the two approaches is easier to
> > > maintain long term. The pcp work needs to be done one way or the other.
> > > Whether we want to tweak locking or do it at a very well defined time is
> > > the bigger question.
> > 
> > That crossed my mind as well, and I went with the idea of changing locking 
> > because I was working on workloads in which deferring work to a kernel 
> > re-entry would cause deadline misses as well. Or more critically, the 
> > drains could take forever, as some of those tasks would avoid returning to 
> > kernel as much as possible. 
> 
> Could you be more specific please?

Hi Michal,
Sorry for the delay

I think Marcelo covered some of the main topics earlier in this 
thread:

https://lore.kernel.org/all/aZ3ejedS7nE5mnva@tpad/

But in syntax:
- There are workloads that are projected not avoid as much as possible 
return to kernelspace, as they are either cpu intensive, or latency 
sensitive (RT workloads) such as low-latency automation.

There are scenarios such as industrial automation in which 
the applications are supposed to reply a request in less than 50us since it 
was generated (IIRC), so sched-out, dealing with interruptions, or syscalls 
are a no-go. In those cases, using cpu isolation is a must, and since it 
can stay really long running in userspace, it may take a very long time to 
do any syscall to actually perform the scheduled flush.

- Other workloads may need to use syscalls, or rely in interrupts, such as 
HPC, but it's also not interesting to take long on them, as the time spent 
there is time not used for processing the required data.

Let's say that for the sake of cpu isolation, a lot of different
requests made to given isolated cpu are batched to be run on syscall 
entry/exit. It means the next syscall may take much longer than 
usual.
- This may break other RT workloads such as  sensor/sound/image sampling, 
which could be generally ok with some of the faster syscalls for their 
application, and now may perceive an error because one of those syscalls 
took too long. 

While the qpw approach may cost a few extra cycles, it operates remotelly 
and makes the system a bit more predictable. 

Also, when I was planning the mechanism, I remember it was meant to add 
zero overhead in case of CONFIG_QPW=n, very little overhead in case of 
CONFIG_QPW=y + qpw=0 (a couple of static branches, possibly with the 
cost removed by the cpu branch predictor),  and only add a few cycles in 
case of qpw=1 + !RT. Which means we may be missing just a few adjustments 
to get there.

BTW, if the numbers are not that great for your workloads, we could take a 
look at adding an extra QPW mode in which local_locks are taken in 
the fastpath and it allows the flush wq to be posponed to that point in 
syscall return that you mentioned. What I mean is that we don't need to be 
limitted to choosing between solutions, but instead allow the user (or 
distro) to choose the desired behavior.

Thanks!
Leo 

