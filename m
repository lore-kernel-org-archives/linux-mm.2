Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DFBF6E98E0B
	for <linux-mm@archiver.kernel.org>; Mon, 23 Feb 2026 09:06:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 05FF56B0088; Mon, 23 Feb 2026 04:06:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 00DD46B0089; Mon, 23 Feb 2026 04:06:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E52BD6B008A; Mon, 23 Feb 2026 04:06:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D20FA6B0088
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 04:06:37 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 5EBCB140891
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 09:06:37 +0000 (UTC)
X-FDA: 84475140834.04.C2CBD7F
Received: from mail-wm1-f66.google.com (mail-wm1-f66.google.com [209.85.128.66])
	by imf13.hostedemail.com (Postfix) with ESMTP id 9B3DC20003
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 09:06:35 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=gCTIBlKR;
	spf=pass (imf13.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.66 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771837595;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FRKHr4XfNyvs/GPqZkcXmlWLUOkA8rjTfDtgUabPVdo=;
	b=IhIEiUzAF3tNQ4xDwG49VFJ6PPO+twe0GXPZlBJTTKsQMyKTW4yJc/1DggObukjBozjfJW
	sWqOEPP9RvZyJja7ZzAESuOaXKWEOmUWgd4OsZsECyQAijBpQq2ZhOxqLZ0vZAw/6Xrjlh
	AmDNuEksOoMe/JsZLgj5GgJHUC94x1I=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=gCTIBlKR;
	spf=pass (imf13.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.66 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771837595; a=rsa-sha256;
	cv=none;
	b=dZkJVMdaUWqP0B+/IOWFMe9S85CusciZGHNhNc33zKIICabPhBwJ7DOwQ56Tk0lncEQ0EY
	l5ahDtqdwD6GgTPpNwm4VsdaSo3KE7DlrDDYj3VjyvJVRfR/6SrPVyYirFbvzmFAP69yQ7
	REiAvaArJoqzJOeDs9xVO3RafRYiWHw=
Received: by mail-wm1-f66.google.com with SMTP id 5b1f17b1804b1-482f454be5bso45222595e9.0
        for <linux-mm@kvack.org>; Mon, 23 Feb 2026 01:06:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1771837594; x=1772442394; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=FRKHr4XfNyvs/GPqZkcXmlWLUOkA8rjTfDtgUabPVdo=;
        b=gCTIBlKRxdlf2EBz3bsge9QTIiCg/xaBfdb0jeQ26kANgSUk2WVqg40QlY5MWFB85F
         5evqg1ppUk3xrjA7/f+iLdtnX5WesxxLViqghFS9yBch3tpZx6vASOt3WK3orkm1HKwG
         yByRCBzAnRJ9V2mBGnOZFuMwl+xenp+oOb59RFmCfJlSSBf1rYwx0CRqpckMBVuP/OwD
         yUYwUEF0eSH/moNKEJg6qq6KiYM+ws+4oh0JnyINO6QeTFGljk1BbZ757kgakBbQivig
         hst1DgSY/DJaGoIf3t+E2FUEn2bft+iTG43g+6v/fYqkoX082SEHPgG7tmCBvz5OAW9c
         N3Hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771837594; x=1772442394;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FRKHr4XfNyvs/GPqZkcXmlWLUOkA8rjTfDtgUabPVdo=;
        b=g043TQz6Pfuy81xzpst2MY5rNH1kbWPHGsth9SrIdnaz9KgSCBpnfFysJ/mTqhax3L
         wUy+5i2RaEfiE+rTD5YfSHKfguJryqZ6gVRCeJzpHmRf/ecdIwS+P6nyqDx46q3dng1h
         QRZKUwJMVc2UrPXNwchoF+X3NbWxc/Vpx68irVOy8XdGAoczgnALNBFS0+PO+z9WQdpR
         exKkkaUHC1Ngsi3EziHP0y4SbSw4qun3l1wb47rPsj/DkJtjAK+JUt0vs9vY4AR8dy/Q
         H8pvJBGk65RWeHDp3P4344H6kGNf6khIorJp1NSNnwSuZImbZkTA0lpKQXaQy3fY/Iap
         Hlhg==
X-Forwarded-Encrypted: i=1; AJvYcCVcVj4HyCUpRKtoGSAqp6eU0rDcOS7D8iJhfjZ0vAcaBZ0hJnqNKInjMW3eJrTrdtn9WvE0HhKfQw==@kvack.org
X-Gm-Message-State: AOJu0YxpC54itSEkuRajlE3Oy4SdeshfzMiHVS5JoPUIxHCw+zaz1af4
	gs7a0K6qfm88np5Oh71azxTNiJVG8btuVOJS/w9uts7HtP9sZi7hUFYvUUMnawnsD9s=
X-Gm-Gg: AZuq6aKy7WGb8gRQzSRtsbskQ6yt5QkwEfgSGHLFH1wQwjb7QgjWKNWMejoBPsJyR4F
	VeqDqxLQ3TZDfE2oE6MQKCRNoLN9NPaUJpm5w0L72XvRqlFgMhHsIvRwQKWeFK+o85ZaLNsSiM4
	Es35XJDtvArCQWHyL0s2ssbZgxIRR2+kgexLWsYcuTYjgc+3HeXIygF+v26l8fyKOKOix24LnYt
	Q/dsU4YCnIOllqnaB9ztDj2/TG84jNREgMx7BbP/X2SvgDCyie708b2aFyRXtCYOFc2wdy24YsB
	ZVZYaNtiH3v/sZgVsOAm5CEu0QXbfNMtSNHfPZFoUAqrZAVuiLlKJ5GOPIDgkzow/cQnTNny4P6
	7lzYORSvfYHEon+rgV7jU9jHoWmJ0XYxwaD82tyqi7Oj9K8llEe4BKAmAr/AMvcNrQkexHvuB1+
	yenXGFfyce6E2wxyZq4s0JZSCy2Uy9E3o=
X-Received: by 2002:a05:600c:1c29:b0:483:6d9e:e4f5 with SMTP id 5b1f17b1804b1-483a949e5edmr131156385e9.5.1771837593880;
        Mon, 23 Feb 2026 01:06:33 -0800 (PST)
Received: from localhost (109-81-84-7.rct.o2.cz. [109.81.84.7])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-483a9b75b4dsm281117665e9.4.2026.02.23.01.06.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Feb 2026 01:06:33 -0800 (PST)
Date: Mon, 23 Feb 2026 10:06:32 +0100
From: Michal Hocko <mhocko@suse.com>
To: Leonardo Bras <leobras.c@gmail.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>, linux-kernel@vger.kernel.org,
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
Message-ID: <aZwYmNuucBspCYhk@tiehlicka>
References: <20260206143430.021026873@redhat.com>
 <aYs6Ju2G4bm6_tl2@tiehlicka>
 <aYxviLoWsrLqDU7o@tpad>
 <aYywl1hdBQP2_slo@tiehlicka>
 <aZDw6xI2izFDfuuu@WindFlash>
 <aZL45yORfkNvS9Rs@tiehlicka>
 <aZjY9h3XXMNY-Ytd@WindFlash>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aZjY9h3XXMNY-Ytd@WindFlash>
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 9B3DC20003
X-Stat-Signature: jpr314j899s3pzegwfb5m7dy4oao5ezo
X-HE-Tag: 1771837595-680050
X-HE-Meta: U2FsdGVkX1+d0uO7QNAlOigl9tAJSbd6CVUhiX6MpmlO4CKZDPCSI0CUakbmHGoIJKSzRgPMA2DUyvfiCHrQB7okSIDNp447kspdn07MaLPisklU8tgEwJMykzfIzk6kxuU41KEvaJZp+oCraX+8i8BiOioTGSAQj6fmc8/Qhd5Dt7TLChr6Y6rMiYOnF7yBAC2+xFWbkmwJXPM6mC67qh9cZIoGarAGKB4L3DdXw5Pj72VZA7X8W8a4gORWLXLgBRqtR4r7Ai1AoBpLM8x9yH3WdeSew5BkN6PSl/PO5PU7eMNdQ1uSHcAzLKAd3m70K4jiIm6FgZiUnZ3sgg/GSzh9Sv/r01T99q28K6UGJADM/UDeios0BmLDOV1m8sB5vcFDvJmQYoitXPi8hFiyXumySjOyucaXRBgIuPCW/7rTiPcRW0P+ygfMkVaO0VEUiHuQbYO5/qwF+wZtBVzuE/O+sb45xyLvM4drhZ6K1R2IDs5Ryfm8IAFDxG71MlcjbRxRe0I+8GlyMUG4YR0cnxuFETv8sxX7m7isr4USSLGZA5B9rfUyGi/g/PyHR2px6flEBVje8c1wGZr/Oy50XZBYnLpN37i4fNe45QbVFdCFq6H3qXLhT2WhLacFOHywLXEWtrI5Bp5fyy3TDip+18WUej/klCCCgR4Xva1KqK9Nl+sIznpLer6qPR5y0xkUbEI4g6YaDv7EBXo8E0QIcCTBU33si8FhN5DRA4HJ09KX2tvp1Kf88hOtkoStsPEk1ag9ZOuur317Z2kylxybGN6dmwQwvdafoMJ+PZZ4q+LthfhwN9G9ryD7JrTNahbP6dhcL+lxlzUUZR5A06m/yBumjcYkFjP4qOkNFSlWqnWyaDbwSqMdyy04c8CgNzxTZ4+z5sx+4AmgoPUM7oSpBQ8YiQoxPmKV6mNR/ygjc0bWiGsEO8esAGESAfbXvML48o3tKHKzAVpIn+JjAwr
 V8qIKZaj
 hQU82yFjEyCQ/295Fy/AvIMqkTTpIfTfWOLPpjriEsJNZdZWERUyNYVU303hBtxxzchS20W6FkHV3w4dI6shvTjqFtffVbD77NwgigA12pz9ErtuRTSwapjBXXogzGJvYqH2mwo9o2rjANw3iqDQBvGxwxIbOR/C0sdszmRoQmgYFqXgwIJeK1LkKtbQ1SkNrO8KD8gyHxg1N4FjrrB2ugENEQw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri 20-02-26 18:58:14, Leonardo Bras wrote:
> On Mon, Feb 16, 2026 at 12:00:55PM +0100, Michal Hocko wrote:
> > On Sat 14-02-26 19:02:19, Leonardo Bras wrote:
> > > On Wed, Feb 11, 2026 at 05:38:47PM +0100, Michal Hocko wrote:
> > > > On Wed 11-02-26 09:01:12, Marcelo Tosatti wrote:
> > > > > On Tue, Feb 10, 2026 at 03:01:10PM +0100, Michal Hocko wrote:
> > > > [...]
> > > > > > What about !PREEMPT_RT? We have people running isolated workloads and
> > > > > > these sorts of pcp disruptions are really unwelcome as well. They do not
> > > > > > have requirements as strong as RT workloads but the underlying
> > > > > > fundamental problem is the same. Frederic (now CCed) is working on
> > > > > > moving those pcp book keeping activities to be executed to the return to
> > > > > > the userspace which should be taking care of both RT and non-RT
> > > > > > configurations AFAICS.
> > > > > 
> > > > > Michal,
> > > > > 
> > > > > For !PREEMPT_RT, _if_ you select CONFIG_QPW=y, then there is a kernel
> > > > > boot option qpw=y/n, which controls whether the behaviour will be
> > > > > similar (the spinlock is taken on local_lock, similar to PREEMPT_RT).
> > > > 
> > > > My bad. I've misread the config space of this.
> > > > 
> > > > > If CONFIG_QPW=n, or kernel boot option qpw=n, then only local_lock 
> > > > > (and remote work via work_queue) is used.
> > > > > 
> > > > > What "pcp book keeping activities" you refer to ? I don't see how
> > > > > moving certain activities that happen under SLUB or LRU spinlocks
> > > > > to happen before return to userspace changes things related 
> > > > > to avoidance of CPU interruption ?
> > > > 
> > > > Essentially delayed operations like pcp state flushing happens on return
> > > > to the userspace on isolated CPUs. No locking changes are required as
> > > > the work is still per-cpu.
> > > > 
> > > > In other words the approach Frederic is working on is to not change the
> > > > locking of pcp delayed work but instead move that work into well defined
> > > > place - i.e. return to the userspace.
> > > > 
> > > > Btw. have you measure the impact of preempt_disbale -> spinlock on hot
> > > > paths like SLUB sheeves?
> > > 
> > > Hi Michal,
> > > 
> > > I have done some study on this (which I presented on Plumbers 2023):
> > > https://lpc.events/event/17/contributions/1484/ 
> > > 
> > > Since they are per-cpu spinlocks, and the remote operations are not that 
> > > frequent, as per design of the current approach, we are not supposed to see 
> > > contention (I was not able to detect contention even after stress testing 
> > > for weeks), nor relevant cacheline bouncing.
> > > 
> > > That being said, for RT local_locks already get per-cpu spinlocks, so there 
> > > is only difference for !RT, which as you mention, does preemtp_disable():
> > > 
> > > The performance impact noticed was mostly about jumping around in 
> > > executable code, as inlining spinlocks (test #2 on presentation) took care 
> > > of most of the added extra cycles, adding about 4-14 extra cycles per 
> > > lock/unlock cycle. (tested on memcg with kmalloc test)
> > > 
> > > Yeah, as expected there is some extra cycles, as we are doing extra atomic 
> > > operations (even if in a local cacheline) in !RT case, but this could be 
> > > enabled only if the user thinks this is an ok cost for reducing 
> > > interruptions.
> > > 
> > > What do you think?
> > 
> > The fact that the behavior is opt-in for !RT is certainly a plus. I also
> > do not expect the overhead to be really be really big. 
> 
> Awesome! Thanks for reviewing!
> 
> > To me, a much
> > more important question is which of the two approaches is easier to
> > maintain long term. The pcp work needs to be done one way or the other.
> > Whether we want to tweak locking or do it at a very well defined time is
> > the bigger question.
> 
> That crossed my mind as well, and I went with the idea of changing locking 
> because I was working on workloads in which deferring work to a kernel 
> re-entry would cause deadline misses as well. Or more critically, the 
> drains could take forever, as some of those tasks would avoid returning to 
> kernel as much as possible. 

Could you be more specific please?
-- 
Michal Hocko
SUSE Labs

