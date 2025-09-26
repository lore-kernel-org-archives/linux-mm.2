Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9DDC0CAC5B8
	for <linux-mm@archiver.kernel.org>; Fri, 26 Sep 2025 15:31:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C37618E0010; Fri, 26 Sep 2025 11:31:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BE8178E0001; Fri, 26 Sep 2025 11:31:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B25A38E0010; Fri, 26 Sep 2025 11:31:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A14B08E0001
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 11:31:23 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 510428790B
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 15:31:23 +0000 (UTC)
X-FDA: 83931790446.04.C349251
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf22.hostedemail.com (Postfix) with ESMTP id 58A2CC000A
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 15:31:21 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=jTukSQ1n;
	spf=pass (imf22.hostedemail.com: domain of bhe@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=bhe@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758900681;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XrNBABWFGB7LY92XFF2rzNbTXOfz5nPYXo5dvWUZr5w=;
	b=KrzrC5ODHsqGxNGbqYxOXybe0AYSHm5poqC/LIObhFGZmW+l1eyWZopmP9BcIaOAbfk491
	LeOkE3CHNRT8lJ67qv2/id3H6SvCIpce+Gn6qGBiMXtbWo0Pm22z07YhKVPzuFlr5E7mOe
	nNOz63HJUe+u+FhhIAaG5PWGond4WfQ=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=jTukSQ1n;
	spf=pass (imf22.hostedemail.com: domain of bhe@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=bhe@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758900681; a=rsa-sha256;
	cv=none;
	b=KvS2SMX5dtFRFsm5ZkxV3BYL1K7PST0f3tH2l+BZqoet0nbzEzBM35CR8ggQCRPYkSGixv
	nMvWjGlF2041JHpc998WeIe7s8DyPd2OIiNi2I3Qvf/6nE680Oy+50Xzlg2QElFxMFgwgE
	2VcIGjSJ0sEj1FHpRmOLxU1BrJLn1xw=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758900680;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=XrNBABWFGB7LY92XFF2rzNbTXOfz5nPYXo5dvWUZr5w=;
	b=jTukSQ1nnJT29SP80dJUpKi+Gs5gd8Wq8AO0sh6nXA2/EOhC2TV+wmfZgQ6dUJ8iOqlw7W
	GlSaQnt0WNdPiSVfkK5kUTyZEuwHhy80wmC7FX0u/+ojpgE7hHhjAMjrzLsWeN77uloHGx
	RaRSToDpjWi6As0qhCnndYrhmVF8bQ4=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-368-6LqaSeJsMrKIP_HjExk41g-1; Fri,
 26 Sep 2025 11:31:17 -0400
X-MC-Unique: 6LqaSeJsMrKIP_HjExk41g-1
X-Mimecast-MFC-AGG-ID: 6LqaSeJsMrKIP_HjExk41g_1758900676
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 1645219560A0;
	Fri, 26 Sep 2025 15:31:15 +0000 (UTC)
Received: from localhost (unknown [10.72.112.25])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id AAFB019560A2;
	Fri, 26 Sep 2025 15:31:12 +0000 (UTC)
Date: Fri, 26 Sep 2025 23:31:08 +0800
From: Baoquan He <bhe@redhat.com>
To: Chris Li <chrisl@kernel.org>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, kasong@tencent.com,
	baohua@kernel.org, shikemeng@huaweicloud.com, nphamcs@gmail.com,
	YoungJun Park <youngjun.park@lge.com>
Subject: Re: [PATCH] mm/swapfile.c: select the swap device with default
 priority round robin
Message-ID: <aNaxvEiMgh+EqGjt@fedora>
References: <20250924091746.146461-1-bhe@redhat.com>
 <CACePvbUhnNUgqbTUrBYoMK-VeCB1Lntkeijof8ehOz77M8H6Bg@mail.gmail.com>
 <aNShH7WWxuBEvIuh@MiWiFi-R3L-srv>
 <CACePvbU485gPMEvBeK2CN4Ept-zS3ZYXfcVC8Fbk83saX_2dzQ@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <CACePvbU485gPMEvBeK2CN4Ept-zS3ZYXfcVC8Fbk83saX_2dzQ@mail.gmail.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: NaiIzNAgZ7Lyax9kn5NI6pq47kSGUK7lRQSEUJO5M5s_1758900676
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 58A2CC000A
X-Stat-Signature: uiu1nd8xb6mk6qu76pqrryojycnxuibz
X-HE-Tag: 1758900681-473761
X-HE-Meta: U2FsdGVkX194qQW6tTwsiauJ8+ytFmNkZujsQk41CtgBs9F+a35EMR/+zaSkdloLqF/rHluwVnzxphWRYuShEt4NYSMMbY1+aqi9hWqhybIkbQ+RhhXrkc700/VphOs0VF/ezhMarkJOIHFofQotvvAmf7dqEV/PxSSvKHGZBEk6voMrwPwD1z35DENBDl3Di3rrDono9XdHJ9OgE5fxUhkzBMp9NwL7P5H70+c4wTY3iWo73jIUJPw8iHtz+1u6j4fA6qbZssb6o8wQ/OXFenknT7ziHvbcRHndgphY2wUXOgelu9bldebvrTaKs7JopS7SIsQuHbY7izx7g+5TXoD+HKJMOAlnq75hwNtP65fNC9wip6wVgy7BZ11SvVx0sLQmtTIwl8aC57Tpju9O6zMNfpGDk2zo3apWcKxzR3dC2oEywTB5iV0oVirEex2ch9waQ/U1buN/SHipAeJqelzCmVZYRweDi1dShdXZGLe8p9TdtONT5jHMsu1g6cvmftzMzvYSXl1VBj8exEoZXcqIaOdcoGVyQIanCoZNPNfukzg2YcL6Yur2PXjIKcOMA0Mc/T388/b57Sm4Jclj3P1RLF9de+wTIRRl38pZtRjd3V1r1LwJQADGEQlHGgwOC01wgBYBwKdj0kithhPuVvZhzyWyyEldG/TTub/d2NWjNLZp6/3ut1axx84aprFOLBXVRBsbvCcZK1LuKUbRqU+i6RWlMOU3cMyvdj/hwcrprW96+23WUrafc2O+13o5D8uWYLEC/PfUbVbV4Vw0K5nGQB4oVR1ttbXotGRYVXOnz93wwZHkU2OqHBYVceI9YquKV+ljV+A2XiPTbZF4ilDy3P7tvY6+Rat7L3XC78uxQfOreGsabBaKIhjmwQCL1WI041L5JceQ6NFPEH7qC94Q/9JMzK4iTK6Rxyj4yzuF//YvsdM99VZ66ioSNb6JBoKXoL3LUayhECnQZnN
 W08Odf4m
 gK+u3/R6fUt9K20+Shlgt602+WZ7rmgGBPaHXimxhdPV+Oac8IEjCnS7sXXqftQ2tOCtA
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 09/25/25 at 11:25am, Chris Li wrote:
> On Wed, Sep 24, 2025 at 6:55 PM Baoquan He <bhe@redhat.com> wrote:
> >
> > On 09/24/25 at 08:54am, Chris Li wrote:
> > > Hi Baoquan,
> > >
> > > Very exciting numbers. I have always suspected the per node priority
> > > is not doing much contribution in the new swap allocator world. I did
> > > not expect it to have negative contributions.
> >
> > Yes.
> >
> > While compared with the very beginning, there has been some progress.
> > At the very beginning, there was one plist and swap device will get
> > priority from -1 then downwards by default, then all cpus will exhaust
> > the swap device of pirority '-1', then select swap device of priority
> > '-2' to exhaust, then -3, .... I think node-based adjustment distribute
> > the pressure of contending lock on one swap device a little bit.
> > However, in node they still try to exhaust one swap device by node's
> > CPUs; and nodes w/o swap device attached still try to exhaust swap
> > device one by one in the order of priority.
> >
> > >
> > > On Wed, Sep 24, 2025 at 2:18 AM Baoquan He <bhe@redhat.com> wrote:
> > > >
> > > > Currently, on system with multiple swap devices, swap allocation will
> > > > select one swap device according to priority. The swap device with the
> > > > highest priority will be chosen to allocate firstly.
> > > >
> > > > People can specify a priority from 0 to 32767 when swapon a swap device,
> > > > or the system will set it from -2 then downwards by default. Meanwhile,
> > > > on NUMA system, the swap device with node_id will be considered first
> > > > on that NUMA node of the node_id.
> > >
> > > That behavior was introduced by: a2468cc9bfdf ("swap: choose swap
> > > device according to numa node")
> > > You are effectively reverting that patch and the following fix up
> > > patches on top of that.
> > > The commit message or maybe the title should reflect the reversion nature.
> > >
> > > If you did more than the simple revert plus fix up, please document
> > > what additional change you make in this patch.
> >
> > Sure, I will mention commit a2468cc9bfdf and my patch reverts it, on top
> > of that default priority of swap device will be set to '-1' so that all
> > swap devices with default priority will be chosen round robin. Like
> > this, the si->lock contention can be greatly reduced.
> 
> Just curious, is setting to "-1" matches to kernel behavior before
> a2468cc9bfdf, if not what is the behavior before a2468cc9bfdf.

It should be like below. It's not a real output, I made the data to show
what it looks like.

# swapon
NAME       TYPE      SIZE  USED PRIO
/dev/zram0 partition  16G 15.8G   -1
/dev/zram1 partition  16G    0B   -2
/dev/zram2 partition  16G    0B   -3
/dev/zram3 partition  16G    0B   -4

I just apply this patch and set the priority to emulate the kerel
behavirour before a2468cc9bfdf. In kernel before a2468cc9bfdf, it sets
priority to swap device from -1 downwards. There's only one
swap_avail_head plist for all CPUs. The behaviour is very much like below:

[root@hp-dl385g10-03 ~]# swapon
NAME       TYPE      SIZE  USED PRIO
/dev/zram0 partition  16G    0B    0
/dev/zram1 partition  16G    0B    1
/dev/zram2 partition  16G    0B    2
/dev/zram3 partition  16G 14.3G    3


