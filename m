Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 92FDCC5AD2B
	for <linux-mm@archiver.kernel.org>; Fri, 20 Feb 2026 16:57:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 266E76B0095; Fri, 20 Feb 2026 11:57:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 24AE26B0093; Fri, 20 Feb 2026 11:57:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0FB786B0095; Fri, 20 Feb 2026 11:57:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E9D206B0092
	for <linux-mm@kvack.org>; Fri, 20 Feb 2026 11:57:45 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A09B4160233
	for <linux-mm@kvack.org>; Fri, 20 Feb 2026 16:57:45 +0000 (UTC)
X-FDA: 84465441690.04.BE9BA16
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf20.hostedemail.com (Postfix) with ESMTP id BDA781C000A
	for <linux-mm@kvack.org>; Fri, 20 Feb 2026 16:57:43 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=IPz+rktC;
	spf=pass (imf20.hostedemail.com: domain of mtosatti@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mtosatti@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771606663; a=rsa-sha256;
	cv=none;
	b=4C8aM1rpyFirvEQRvRPkE/+2Ona7vFpRNElawPzz5OXKcYWWTJeReqC1ETry4qCsZ1lnyx
	X0W+s2SAz8zUB5kG0eJC30pYHsc7KeuiiMkUJL3tWEz9bOnzkye0RJS5UavFwB3Njnz/lQ
	CD3askgUx61GiKvPav+tzjYXO14KAOQ=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=IPz+rktC;
	spf=pass (imf20.hostedemail.com: domain of mtosatti@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mtosatti@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771606663;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FOyp2mMMM2tbgcKpJAWgPFOB0aCyHCshmwfn3XakoHc=;
	b=TKlLAvxfyCWgBe7QURs+hqbTO4j2orPwMh9qTjaLGBFElbNA+Q9dQzsSmD+4L3icqnkuxE
	uPdyEtRHE7plPEATVR6Sbt1itf6EgN0y+/z2FyASVZe6HotOSjT1jMhTTw77BCWoSicWwi
	HM+TElnrGC7mfaAhdehqjh2ep4qHUOk=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1771606663;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=FOyp2mMMM2tbgcKpJAWgPFOB0aCyHCshmwfn3XakoHc=;
	b=IPz+rktC0P6JqDT4/C7PjyI8b5c0x14bpKTDPuZu404bQaUm4AfjRowuXT8uscqbR94/a9
	5Jgsb5HsuxZwqHzbhS2Q9P+b0hre9lhwX8LrMVAVkWEEK/J6lpE0HIaMVDvbmIE2jjP+H7
	6qIk4G5nmtsk0+VoiY/grH9MDgR4gbo=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-614-WumhJ1N_NBewOjTnDhcEaQ-1; Fri,
 20 Feb 2026 11:57:37 -0500
X-MC-Unique: WumhJ1N_NBewOjTnDhcEaQ-1
X-Mimecast-MFC-AGG-ID: WumhJ1N_NBewOjTnDhcEaQ_1771606655
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id F12F318004BB;
	Fri, 20 Feb 2026 16:57:34 +0000 (UTC)
Received: from tpad.localdomain (unknown [10.96.133.4])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 540671800352;
	Fri, 20 Feb 2026 16:57:33 +0000 (UTC)
Received: by tpad.localdomain (Postfix, from userid 1000)
	id B3C7B401D5D4C; Fri, 20 Feb 2026 13:51:13 -0300 (-03)
Date: Fri, 20 Feb 2026 13:51:13 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Michal Hocko <mhocko@suse.com>
Cc: Leonardo Bras <leobras.c@gmail.com>, linux-kernel@vger.kernel.org,
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
Message-ID: <aZiRAa6uf4KhscJC@tpad>
References: <20260206143430.021026873@redhat.com>
 <aYs6Ju2G4bm6_tl2@tiehlicka>
 <aYxviLoWsrLqDU7o@tpad>
 <aYywl1hdBQP2_slo@tiehlicka>
 <aZDw6xI2izFDfuuu@WindFlash>
 <aZL45yORfkNvS9Rs@tiehlicka>
MIME-Version: 1.0
In-Reply-To: <aZL45yORfkNvS9Rs@tiehlicka>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-MFC-PROC-ID: mgWmE7-AiHRs6UCoot-_icUX9sEwnCfQG-wFe1NblQo_1771606655
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Queue-Id: BDA781C000A
X-Stat-Signature: ifco6naj7nhpr4xnr3oas74ybpzk4dwq
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1771606663-486160
X-HE-Meta: U2FsdGVkX1+c95mNoGN+VhwuflCytv/U8qhORPbONazKjA/KMgdgwsex4HsUqeA+l3s93hHGcYd1i7bPO6y7v5y0dV4eCyy2qtc9jfnaKYQut0JoRhp8oOzNSb3zpCTwLF3G/U2QntIyJp96XSk5sPyilrTnromMjyv63hZ4BqTrP5j8OPe8UfhZ3FscJEfwwVJMaaTCTU78UyZpbmhfNPqhFFB4VVXoflFz7wNg5R7t2TtZeLzfS+yEm2TnF8iOk05jg4sSnhQ2AY7BrtipRjEZP1o6uR+D+IXJDb5LMQy/dXeCXIcsjUpd46I+fHcDNICjqL+VftUTZ1oys02HwbHoM+yQFOEAywFscril7wT9vHrofyjl1pvqf6uJUxdMTWIXqfRJOuOrfOR/2WM8zj5V2zm7RnrD+RBuMwitin7Pr/O9GyqzCgYstXcq2MgEn8kh3NfLya1cfZaXpYIjDlwns9Izqxqd/nw7aiK8lGLIBDgfXpSgEs8XeeTXmPTblkIgxhxBZGKs03+LgZ8lonUgWrOw4yLSKqGlCiSmr7Dc2Ad4mjT/w+V9Uxv11l61Mn8Sfg+gU1QQ11qnYFwdNmv8/8HI/1ll6gBlpTLtPFZAA3YpitHZ5ObDpQFHrkrj52rhBDawJZC9CCaoevAxRA6BOCEf+vN5liyiYUcQXSd3gPLp46HNsR87e3S3vIeGkaN2kXIlnkScNVFY+WKKk/ZbAKpnSZZ9ipixPZxZY6Glnnx8gwoYfyG6oQGl8/xm+V+cacgyn1llNQ02xkGU2cpipl7Tb9aVHXvT+vqSuJvotpBfAjIkcXWaBPBUL0xXMnh6+8uFz59VUB7vHXI+TPgPmm+mJ7LI95u/R+HMiSWd2SNQh0nWMImc3wJpkl+LKABnI8BgHMEAI3hreZM3AvMAyNLycL4l9HcSGmXcPRnYfUJ95PA0nAU6QNdYnwsOfC5XMqMEl42qxmPpTmw
 2ukXeB/F
 SHM1wNrZ4tP6mdtXVhKdYiZQDg0LS5+xPnNeOGQ/J8pwof04GsArrmPkEEP+gGUtUOuxU11Dd5wetr3WPUpIOO3qKNRhB63j6/B+wl/pFN7+EE32qpoCu06U/+5GAeYh65x3XX8S3Us4jbW1SawWxK3hQVEOZQz/sW//pYG+qbPdizJZrWSYsVt0w64va23BfQytiTnM7MsFNWCZdL4QKgYk0UVMxqQ6opSLbQ7I79QjZo3WbEac7NcFJg+P8dbxQJ2KRePvBcAWsUGcz5WZvcdZGcf2PJfLGGSetZfQL/X64KD4ZB7zosstlYnocAgX16V1SPxyB9RtlfUqaY6Z/F1T1eFGiNN0lqYL3YBt+qF4R9UhMf+l2tTZYP9pH8JcjAdZkPyDjWk9FpXCTviZJlgxXD4HbtrG5WChBFQj6wiD7jPYqeGWSrxaH9sljjJFIjX06Op8ob4ZKIbLUEIxq8jchYpwnCo7wrO3f
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Feb 16, 2026 at 12:00:55PM +0100, Michal Hocko wrote:
> On Sat 14-02-26 19:02:19, Leonardo Bras wrote:
> > On Wed, Feb 11, 2026 at 05:38:47PM +0100, Michal Hocko wrote:
> > > On Wed 11-02-26 09:01:12, Marcelo Tosatti wrote:
> > > > On Tue, Feb 10, 2026 at 03:01:10PM +0100, Michal Hocko wrote:
> > > [...]
> > > > > What about !PREEMPT_RT? We have people running isolated workloads and
> > > > > these sorts of pcp disruptions are really unwelcome as well. They do not
> > > > > have requirements as strong as RT workloads but the underlying
> > > > > fundamental problem is the same. Frederic (now CCed) is working on
> > > > > moving those pcp book keeping activities to be executed to the return to
> > > > > the userspace which should be taking care of both RT and non-RT
> > > > > configurations AFAICS.
> > > > 
> > > > Michal,
> > > > 
> > > > For !PREEMPT_RT, _if_ you select CONFIG_QPW=y, then there is a kernel
> > > > boot option qpw=y/n, which controls whether the behaviour will be
> > > > similar (the spinlock is taken on local_lock, similar to PREEMPT_RT).
> > > 
> > > My bad. I've misread the config space of this.
> > > 
> > > > If CONFIG_QPW=n, or kernel boot option qpw=n, then only local_lock 
> > > > (and remote work via work_queue) is used.
> > > > 
> > > > What "pcp book keeping activities" you refer to ? I don't see how
> > > > moving certain activities that happen under SLUB or LRU spinlocks
> > > > to happen before return to userspace changes things related 
> > > > to avoidance of CPU interruption ?
> > > 
> > > Essentially delayed operations like pcp state flushing happens on return
> > > to the userspace on isolated CPUs. No locking changes are required as
> > > the work is still per-cpu.
> > > 
> > > In other words the approach Frederic is working on is to not change the
> > > locking of pcp delayed work but instead move that work into well defined
> > > place - i.e. return to the userspace.
> > > 
> > > Btw. have you measure the impact of preempt_disbale -> spinlock on hot
> > > paths like SLUB sheeves?
> > 
> > Hi Michal,
> > 
> > I have done some study on this (which I presented on Plumbers 2023):
> > https://lpc.events/event/17/contributions/1484/ 
> > 
> > Since they are per-cpu spinlocks, and the remote operations are not that 
> > frequent, as per design of the current approach, we are not supposed to see 
> > contention (I was not able to detect contention even after stress testing 
> > for weeks), nor relevant cacheline bouncing.
> > 
> > That being said, for RT local_locks already get per-cpu spinlocks, so there 
> > is only difference for !RT, which as you mention, does preemtp_disable():
> > 
> > The performance impact noticed was mostly about jumping around in 
> > executable code, as inlining spinlocks (test #2 on presentation) took care 
> > of most of the added extra cycles, adding about 4-14 extra cycles per 
> > lock/unlock cycle. (tested on memcg with kmalloc test)
> > 
> > Yeah, as expected there is some extra cycles, as we are doing extra atomic 
> > operations (even if in a local cacheline) in !RT case, but this could be 
> > enabled only if the user thinks this is an ok cost for reducing 
> > interruptions.
> > 
> > What do you think?
> 
> The fact that the behavior is opt-in for !RT is certainly a plus. I also
> do not expect the overhead to be really be really big. To me, a much
> more important question is which of the two approaches is easier to
> maintain long term. The pcp work needs to be done one way or the other.
> Whether we want to tweak locking or do it at a very well defined time is
> the bigger question.

Without patchset:
================

[ 1188.050725] kmalloc_bench: Avg cycles per kmalloc: 159

With qpw patchset, CONFIG_QPW=n:
================================

[   50.292190] kmalloc_bench: Avg cycles per kmalloc: 163

With qpw patchset, CONFIG_QPW=y, qpw=0:
=======================================

[   29.872153] kmalloc_bench: Avg cycles per kmalloc: 170


With qpw patchset, CONFIG_QPW=y, qpw=1:
========================================

[   37.494687] kmalloc_bench: Avg cycles per kmalloc: 190

With PREEMPT_RT enabled, qpw=0:
===============================

[   65.163251] kmalloc_bench: Avg cycles per kmalloc: 181

With PREEMPT_RT enabled, no patchset:
=====================================
[   52.701639] kmalloc_bench: Avg cycles per kmalloc: 185

With PREEMPT_RT enabled, qpw=1:
==============================

[   35.103830] kmalloc_bench: Avg cycles per kmalloc: 196



