Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3949DECD6C1
	for <linux-mm@archiver.kernel.org>; Wed, 11 Feb 2026 16:51:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 75BD76B0089; Wed, 11 Feb 2026 11:51:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 70A546B008A; Wed, 11 Feb 2026 11:51:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5EF886B008C; Wed, 11 Feb 2026 11:51:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 4BDC66B0089
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 11:51:20 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E3CA5C1D56
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 16:51:19 +0000 (UTC)
X-FDA: 84432766278.30.5B8C072
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf19.hostedemail.com (Postfix) with ESMTP id D573B1A000C
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 16:51:17 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=BTeDQtjn;
	spf=pass (imf19.hostedemail.com: domain of mtosatti@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mtosatti@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770828678;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7xFvXHAT/zMR6zjSA8LwINVX0TELcD51yiOWZ67mo54=;
	b=e4ujsE+8KLO9+KovdQCwnSC2il2GlraZUiAgVlL5qnGDI8j5wl5tRPH44Y4lX2zvV7Kwzk
	I2MeFqd548ikZiCc2mEnLv2wMPsaV2jy7WTyBJhVkbDK9QEWITabhLoW5GGOvWULqd0Ddt
	IqGE25Cz0yN2+evkAXt3jNFl+6Rg7q8=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=BTeDQtjn;
	spf=pass (imf19.hostedemail.com: domain of mtosatti@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mtosatti@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770828678; a=rsa-sha256;
	cv=none;
	b=WpBHlv81LjIORPoTv+jyAxWoLK6Mc+BlmltvBMUWzUepGmjQrtvH25YAbk4S29RXyhnRFb
	ACfItQBe9FvWO5yBnP69m2p/hniTjsuGxJqEuTFHvIbI4gf2eGLQQWjwnOyKwFiuj93/xJ
	gIV8GEbIiHRe7sHqoQTcEFnFKbZCc/c=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1770828677;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=7xFvXHAT/zMR6zjSA8LwINVX0TELcD51yiOWZ67mo54=;
	b=BTeDQtjnUJWEsFtLWDWSus2llPj5ID0ZypT0IMiofDJ1INuT3W1wfV9PRWy3Sk+YZuP5J+
	GaRmPQMs8zVKGCTdPKj70bLqaD+sPkOh3mlwzjVyoG0RzHvAxL/4MyPazAh8lrBc4S86yT
	ofPyHbbUmrNyxeHTQSCT2swUdDSedmo=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-644-Eh2aTJWBPDOU7fau04qHuQ-1; Wed,
 11 Feb 2026 11:51:13 -0500
X-MC-Unique: Eh2aTJWBPDOU7fau04qHuQ-1
X-Mimecast-MFC-AGG-ID: Eh2aTJWBPDOU7fau04qHuQ_1770828671
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 1BA9319560B3;
	Wed, 11 Feb 2026 16:51:10 +0000 (UTC)
Received: from tpad.localdomain (unknown [10.96.133.3])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 2A49919560B7;
	Wed, 11 Feb 2026 16:51:07 +0000 (UTC)
Received: by tpad.localdomain (Postfix, from userid 1000)
	id 974654084501B; Wed, 11 Feb 2026 13:50:45 -0300 (-03)
Date: Wed, 11 Feb 2026 13:50:45 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Michal Hocko <mhocko@suse.com>, Vlastimil Babka <vbabka@suse.cz>
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
Message-ID: <aYyzZbh/YRMDcviS@tpad>
References: <20260206143430.021026873@redhat.com>
 <aYs6Ju2G4bm6_tl2@tiehlicka>
 <aYxviLoWsrLqDU7o@tpad>
 <aYywl1hdBQP2_slo@tiehlicka>
MIME-Version: 1.0
In-Reply-To: <aYywl1hdBQP2_slo@tiehlicka>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-MFC-PROC-ID: CSoBLjrVQCHbF6R8bDGVfw4Hkl926SG9025lBFPfkM4_1770828671
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspam-User: 
X-Rspamd-Queue-Id: D573B1A000C
X-Rspamd-Server: rspam07
X-Stat-Signature: dkjd5bqd49u157c5ecqyhkjznei16wst
X-HE-Tag: 1770828677-235750
X-HE-Meta: U2FsdGVkX1+YOarK5muVfBhHzajIq7iurDP//p9rSU8YU4i6JMu/iaHFeHfUbeIvtjeltSbuSm2VFbfQEQ5RiRaUxBthWjov4NyJSvfGoQ0Wmov8tDBVPHT25CFIdb9nnPOIccEv5DIHHnexaJgBm2Llt0/iSF19n8lGBgZB70zG1UxIM4cGz+VzgcCvXcTr188S/w55DW0efuBBFJ5kiRIrUpuThC/nN4JdmsplO2VDVtjgEFU9tD+AyFZ0MXR9ila3e8GSNOMkVyXG20fTg7pbPxSd94Di3VKtEVng6raGb4FNLXhmd7oZ9IS7PvD3EZzPeNKQQro/PCe1b3U4ZmyREMg1YmYjl1JP6HpaM4A0x5LPQ3SyRcoirDJv2OwgoZcfdx55pycKjH7UKjcctTCSfzfMOl7jiIn5Qlo1Eqp0nD8y3trN609myGYz9KG+9gRIxMY1dqwZRTXZv4FmDyibKhjIuW87VDrg1Ho9P4T9WJ5dya/ZlCbb0aS47149hsheqdXBs5p7FNVsPXbhrT3MDSO4eF/EBwgC41pSeZgF91esqhaWTghdGmSHRj+GinzGe0sSaGoJnxMRkSdN2Eu6SPAReyeTRolruH15AAcQqI5dVKQ49aL+MTred/bsrGWGsjeVI+HV+cI9/WWwYLySct4+TUUQf6sdK0CSyy87JoG3PR9GPmAqPqq/Vf5tXAvu9829BJ3P8gY5HXxyUUoRaY152UY1+VUwA59f6MmPClP/A9zTn2Ds+P6xXBpPivo71omqdSHt7qgx2GEvAI0qODpaXpJZJd+56nKYvkDtsOF0reFcDM2864xZ0WqjFF3YC1Te4P33CtD3DKb2ZOlQYDflg41lUutv5RXwGsTOHsTIKhElHCoFJ3zEz/FzoQuZkLYfF2eq0GTuTKc5yoIEtz0nWfFAotnMCBsA3sXoUeaTu+uIB4KiAiJcBBtdefjVnG6t9gz1ZxgbqU1
 zE3pOAik
 XeV3K+tsMTuDyT9PN49PRTWiSa3wtSVeBAmfsrU7xyJRIKV5b6OLtapuyDCUm38qFA7rIBECK74Vv9kF21JrEufJ/M+FPqGHg6XDVNFL2B+3tvCQgtdE3w1aMYHn6LP1WJIRylpae/xk4QUaKP2VeuZ6uE7HzbJkmkJaLsfk9kbUelXA2R6MeNOPF4+UlDejI2XyYQyRXNCQdT1Kld728/XIwn1ODtUWpunpyBr/ueKTjRAIyXfb99Q5EO7Ck8SUHIouHJF1OIkor7W6GWdriiwPNq5MfD/fXau5mDBqqCnp+C0TbAQm/Lgj0q7UKhDw0Yl9AhFJtEv6grV88bhcHgP9Eq9EnTYsq3g5qDcN/3+rJLIETzoIYT8VWD4QsKTddMaaArPumYa/ZuvA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Feb 11, 2026 at 05:38:47PM +0100, Michal Hocko wrote:
> On Wed 11-02-26 09:01:12, Marcelo Tosatti wrote:
> > On Tue, Feb 10, 2026 at 03:01:10PM +0100, Michal Hocko wrote:
> [...]
> > > What about !PREEMPT_RT? We have people running isolated workloads and
> > > these sorts of pcp disruptions are really unwelcome as well. They do not
> > > have requirements as strong as RT workloads but the underlying
> > > fundamental problem is the same. Frederic (now CCed) is working on
> > > moving those pcp book keeping activities to be executed to the return to
> > > the userspace which should be taking care of both RT and non-RT
> > > configurations AFAICS.
> > 
> > Michal,
> > 
> > For !PREEMPT_RT, _if_ you select CONFIG_QPW=y, then there is a kernel
> > boot option qpw=y/n, which controls whether the behaviour will be
> > similar (the spinlock is taken on local_lock, similar to PREEMPT_RT).
> 
> My bad. I've misread the config space of this.

My bad, actually. Its only CONFIG_QPW on the current patchset.

> > If CONFIG_QPW=n, or kernel boot option qpw=n, then only local_lock 
> > (and remote work via work_queue) is used.
> > 
> > What "pcp book keeping activities" you refer to ? I don't see how
> > moving certain activities that happen under SLUB or LRU spinlocks
> > to happen before return to userspace changes things related 
> > to avoidance of CPU interruption ?
> 
> Essentially delayed operations like pcp state flushing happens on return
> to the userspace on isolated CPUs. No locking changes are required as
> the work is still per-cpu.
> 
> In other words the approach Frederic is working on is to not change the
> locking of pcp delayed work but instead move that work into well defined
> place - i.e. return to the userspace.
> 
> Btw. have you measure the impact of preempt_disbale -> spinlock on hot
> paths like SLUB sheeves?

Nope, i have not. What is/are the standard benchmarks for SLUB/SLAB
allocation ?


