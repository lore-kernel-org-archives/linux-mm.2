Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 79E841088E54
	for <linux-mm@archiver.kernel.org>; Wed, 18 Mar 2026 23:12:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9FBA66B037B; Wed, 18 Mar 2026 19:12:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9ACA66B037C; Wed, 18 Mar 2026 19:12:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8C2256B037D; Wed, 18 Mar 2026 19:12:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 7B7596B037B
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 19:12:25 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 3D5CC1B5A2F
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 23:12:25 +0000 (UTC)
X-FDA: 84560734650.03.1A72853
Received: from relay.hostedemail.com (unirelay04 [10.200.18.67])
	by imf03.hostedemail.com (Postfix) with ESMTP id 7244A20002
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 23:12:23 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773875543;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=iBV7SjmMiPtQEY7CxcIreZyMZDrlZ/JuV/oR18yCDGw=;
	b=Cptgy+ZKHEdRFtXZObaFbEqkAvUJMzQGSmL3vRWqXXctsRTafl2AQ76MINVX2oa8RBe8hL
	oW0dkDqs5fOMbBPL1JM2ZBexRIJ7FC7azi+LfbWYHtOUmdkdXKdi3tu+jYzVO4L0PyDAJQ
	wgqJ5VGTHYjxTuTU265dOYNvj5mEzZE=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773875543; a=rsa-sha256;
	cv=none;
	b=1+C7y9GM3ny04wAphMQ1GwTyefp9r6EycudTy9QlCl3jX1fYI6CiPT52sLYyP1AxPzzRGA
	We1kCyF4v1bUwxPAE2r0pL8a4ltRv6BQZAeuTUnjfWI0K6eFhLcSKxiylV0hoUCLcK0Piz
	RlpphtOaweL3QVuRnS1DAdba0duOH4A=
Received: from omf14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 9F2241A01AB;
	Wed, 18 Mar 2026 23:12:21 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf14.hostedemail.com (Postfix) with ESMTPA id 729DB2D;
	Wed, 18 Mar 2026 23:12:17 +0000 (UTC)
Date: Wed, 18 Mar 2026 19:12:46 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: David Laight <david.laight.linux@gmail.com>
Cc: Christian Brauner <brauner@kernel.org>, Linus Torvalds
 <torvalds@linux-foundation.org>, linux-kernel@vger.kernel.org,
 linux-modules@vger.kernel.org, linux-nfs@vger.kernel.org,
 bpf@vger.kernel.org, kunit-dev@googlegroups.com, linux-doc@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org, netfs@lists.linux.dev,
 io-uring@vger.kernel.org, audit@vger.kernel.org, rcu@vger.kernel.org,
 kvm@vger.kernel.org, virtualization@lists.linux.dev,
 netdev@vger.kernel.org, linux-mm@kvack.org,
 linux-security-module@vger.kernel.org, Christian Loehle
 <christian.loehle@arm.com>, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v2 1/2] kthread: remove kthread_exit()
Message-ID: <20260318191246.21f5cae8@gandalf.local.home>
In-Reply-To: <20260311104736.51b53405@pumpkin>
References: <20260310-work-kernel-exit-v2-0-30711759d87b@kernel.org>
	<20260310-work-kernel-exit-v2-1-30711759d87b@kernel.org>
	<20260311104736.51b53405@pumpkin>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX18ZAlHD7zRdqyhWTgVQ561leKpKdrlCUw4=
X-HE-Meta: U2FsdGVkX1+7MRZYfjkh8tY3o0PNQxfTCp9CNyhqYR5NFfoxVPCM5iPNukWLzQIvK353tkgDvhZEdUedgHQ5QAkLbovGV5fvwkWyav20iib+DYA0dDHoYUnOxRBuEyIUuWk0DzuG1lL8+oddkej4s1MPcpQDwUN5GqInEA4qcRZLkJpWWxd7t1PfzHXZfqpOcF7WAx+PlcQksO8TPjRtlBOpPJasveRV7LExQmrExj38ijzYTXM4IkABls4ZOZgZxz6jQwh3Jnl0QSJRHa6iPYc7cT5zoaTdKKIxa3A6zx0cZRoh9me2qihdhYWm4g9GrHKVoLJDzQiYMqh11BNCWgZQJ5CMSezB
X-Rspamd-Queue-Id: 7244A20002
X-Rspamd-Server: rspam07
X-Stat-Signature: k3okmar3gqwa3bym6uatb3yctgtgf59r
X-Rspam-User: 
X-HE-Tag-Orig: 1773875537-654795
X-HE-Tag: 1773875543-503597
X-HE-Meta: U2FsdGVkX18hXbAEFhToRDK1kdt715qFJoKmH/dBAiXF3ndFE2KhuXaVAALPa+lLYEwj53aI66f7aQWZOfUD0R/Vp7Y0ZZ3O2LqlrMAw4zyXmjCrW2la6CfGZ8PPO2RfbhWndbuIa86Xc3qMWvZpzNipe3A0wpuFojf6sbzrMZXcm7ppJ0Sz/evlPfKH5hXsagaClBuBIqDVTRAsg1clz27ajsoN3XP1hDIzMYnfYmhcc8QXkcEGUgEBiVfqZqTlNchbyiVIFcLEFOftdiWnoC4f4PFt/1n2gSURTL9hLKWhk4SKesQX47kc5tgCj2q53oVclj5SXK/VYM9OCGuZOg1Ao0IeHv8L9lCzIoakqL4lYIrn1bszHWJjVjotO2OdhtlM2PlPLOHEiEqMN33ANsexy3WNYcllhK2j1AgOlI6XswdcBpAqrS2yvFT7seeFyKhXHWKJ9nGD22cpNrlwwEdrnSjNDW8CL1ZNIOUe4q358pcYttmuy2JIzfEpW7x9RivGdYJsZohpkSeSUmjXtspCYlWdJUlbXffnh41qtyL0dDeFP7B877S/Zc1orximCzHzowdp4Y13IEriCtKZFTs61VoIeso9br3cvNk2AxakQHFxn+We/rL22dfY0ca73vfirU81zdovP5ot0qSsZF1s8w9uTZ51ApDyECmQjg+jpfAEjphsVqNDrpCOm0dQCxNxdBoyI7epojo4MPiJ4JECz54XIYZw2wZDeEtXRJQELaCemZ5oJEAZ5sjcbK+CNUT1HHahRO9mbeX5Ds6RJl7MyGACPflYA4vYZeUxUGIBC3CmfJ5E0F9gHoHWFswcqFlbElu3HqZm/SF2WrNaydUsJDkgqdPxIh79RWoywfA6dwTdvChdgJQkxw/iz2H0LOco67EDf3UBoslpPRUnbzGdrwj/Im/fuYtm/xyXB9dkaHdq9Y6DQa0BYGGZCfoX20K2mPnr6JQJaCfF92B
 1MgRTvZQ
 WOHstIrNYAOMo3jWPmiymVgIPeByqRQ7Cvk40an8egMFS1Kab/KpnU1A+Rm7Bg33Vx5NCp0jQcsYsoo4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 11 Mar 2026 10:47:36 +0000
David Laight <david.laight.linux@gmail.com> wrote:

> > -#define module_put_and_kthread_exit(code) kthread_exit(code)
> > +#define module_put_and_kthread_exit(code) do_exit(code)  
> 
> I'm intrigued...
> How does that actually know to do the module_put()?
> (I know it does one - otherwise my driver wouldn't unload.)

It's in the !CONFIG_MODULES section. No module_put() necessary. Only the
kthread_exit (do_exit) is needed.

-- Steve

