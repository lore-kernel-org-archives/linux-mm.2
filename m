Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B9EFAD111A8
	for <linux-mm@archiver.kernel.org>; Sun, 30 Nov 2025 11:20:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2352A6B0029; Sun, 30 Nov 2025 06:20:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1BEE66B002A; Sun, 30 Nov 2025 06:20:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0AD716B002B; Sun, 30 Nov 2025 06:20:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id EA9026B0029
	for <linux-mm@kvack.org>; Sun, 30 Nov 2025 06:20:14 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id AEFC8BDA56
	for <linux-mm@kvack.org>; Sun, 30 Nov 2025 11:20:14 +0000 (UTC)
X-FDA: 84167029548.21.1630130
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	by imf10.hostedemail.com (Postfix) with ESMTP id B60D8C000A
	for <linux-mm@kvack.org>; Sun, 30 Nov 2025 11:20:12 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b="H/O9ZzYi";
	dkim=pass header.d=linutronix.de header.s=2020e header.b=8RrraBCZ;
	spf=pass (imf10.hostedemail.com: domain of bigeasy@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=bigeasy@linutronix.de;
	dmarc=pass (policy=none) header.from=linutronix.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764501613;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gPPSeu511L0k6gL1IYpux6jfrEM3Z2mSgCdofcykt0M=;
	b=bhdvZhVbY0OGZdLhiEBEIimfNdsvdNLwsGYvLGePY7+vJkqBxAc3zJiESgyJEeenpK+S6d
	i81IvgL0J248ZSOzcvAmqrUS2jge1jQ8pnx2JGcl0FnxZXM6pce8OzmAuNDiP5nNN3GvWs
	xhRwFkCYWOaB6M2w+CrZQk0NG3dxxg4=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b="H/O9ZzYi";
	dkim=pass header.d=linutronix.de header.s=2020e header.b=8RrraBCZ;
	spf=pass (imf10.hostedemail.com: domain of bigeasy@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=bigeasy@linutronix.de;
	dmarc=pass (policy=none) header.from=linutronix.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764501613; a=rsa-sha256;
	cv=none;
	b=Drpe4nvn3IxzyISwvnUysiY1pGIgXjp2hHChiblo1eXNCmZAkJpqYiZL+kCxUnmxgjG1TF
	pCY0R2JI1hiGwf9GJaIQYvy5h84ONB+Hx4sIY+yHhbV7yFaPvZOlaF6M9WVwcLF0JiHnFI
	5oMDtzairgmJ+i3NcLOl0oyhhFxiJiI=
Date: Sun, 30 Nov 2025 12:20:08 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1764501610;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=gPPSeu511L0k6gL1IYpux6jfrEM3Z2mSgCdofcykt0M=;
	b=H/O9ZzYiHw/2G2WBqoGZ3K3FPLNuLrAWvk4v/z+wfncXBs075k6aX+F8Iqp8Vgp+LcjyHC
	z1G/MHOyvAh7TA4mK+eXChXlqCIy+EZvNiofVHBTXaCED1jIhLqVlWUxXvtoHpu1Ah9S2e
	F9JX+agQqQ/wqp8/A44N9X3E6LhxoLVaz+GSa+Dj2DBQ++P2UMEGoJSFjvRTB6wNi21E8W
	3esGxnfRtGW9Xy9r7VrNCc6RRigIODj87/eRuf/oAicuV8uZFco5gHUlYiB3CiXIVKxoYP
	MZ7+6xcVMAYjC7Z8e8XAfZYx6UOUYsx3qf+zjw3RwTW8FcJLWYP9IkNoABFSNQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1764501610;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=gPPSeu511L0k6gL1IYpux6jfrEM3Z2mSgCdofcykt0M=;
	b=8RrraBCZU5plsGR6xmde28IoY0RzxSIbtXdVMZm7XVpNQnachUBhpN47q/W3YXgJIb0ERh
	gNxYivhVx7Dx+TBw==
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc: Xie Yuanbin <xieyuanbin1@huawei.com>, akpm@linux-foundation.org,
	arnd@arndb.de, brauner@kernel.org, david.laight@runbox.com,
	hch@lst.de, jack@suse.com, kuninori.morimoto.gx@renesas.com,
	liaohua4@huawei.com, lilinjie8@huawei.com,
	linux-arm-kernel@lists.infradead.org, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	lorenzo.stoakes@oracle.com, marc.zyngier@arm.com, nico@fluxnic.net,
	pangliyuan1@huawei.com, pfalcato@suse.de, punitagrawal@gmail.com,
	rjw@rjwysocki.net, rppt@kernel.org, tony@atomide.com,
	vbabka@suse.cz, viro@zeniv.linux.org.uk, wangkefeng.wang@huawei.com,
	will@kernel.org, wozizhi@huaweicloud.com
Subject: Re: [RFC PATCH v2 1/2] ARM/mm/fault: always goto bad_area when
 handling with page faults of kernel address
Message-ID: <20251130112008.DZYHlSPm@linutronix.de>
References: <20251127145127.qUXs_UAE@linutronix.de>
 <20251128022756.9973-1-xieyuanbin1@huawei.com>
 <20251128120359.Xc09qn1W@linutronix.de>
 <aSnVXrnuY9QKjTKg@shell.armlinux.org.uk>
 <20251128172242.cCNBVf7H@linutronix.de>
 <aSndJ1EYUnMGsUYX@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <aSndJ1EYUnMGsUYX@shell.armlinux.org.uk>
X-Stat-Signature: wxnof3ybbtst16ub1w9fk4zhd3ffroe6
X-Rspam-User: 
X-Rspamd-Queue-Id: B60D8C000A
X-Rspamd-Server: rspam09
X-HE-Tag: 1764501612-585926
X-HE-Meta: U2FsdGVkX18cPWT8DTQTTA+Jugivcp3JSFE0ux2q9YQTt1+PHk49U92PUD21vRX2iil9E4bD4dcF7Ak3e10h0weu8rGfmvg4mJ4eYGTzu5986G2J7pwboFQRgb6CkcIkJqItlkEiNasS7qdhm5fMWJUz9d1JNK2l9JDRWaFdLLQMJt1nBBJ3bquLgry8LVEtAaJsILqo85pAFx/W9c2PTAN6msPoVs5I00Tz+zd19jO9dAD6Y0GHXxQ8dJqVxvKjCixRxpUKH1/JjKQOtID1cGRicmDPd2jlgWBU+pf4mroFfN3DOkIVtrkcEVt5K4gKWBbpkZsZ5XvagGcinXyTlYYScv9hn5SnSSee6NNTviSKaLV0qPzDA6vDpJzhorjBKdQ7L/N31Qg9h0qywclDgDcEnLMAcw2PzMKK/jdoJA6ePHdEMXOODMHSTQ1pVMX5Ao2lFYfPbJZk6UhcgkacxkvHB1OVNCq939OZVwmxSFto/SyKvxpBpm+c8lPxmvn2JBfwH9afQ8YB9XCvKrCu9SmhWqYu0/n9EBENbiTriG7rdBc3VeZXgL9ftTsfhlvhfw738yX+QyA005oMc10Maj5IEGqn+Yj8mVzl37oP/ruO/JOamO1YS6mavmR7TGX7n3/x8dr79KiMlcpfDLyjj8Bl7g+BW1Wd6l269KSI4Gah4448eSVqMjPI7TbnDQLX0DsYqsf1KAzTu0tD2UJ0LO7dGyAVvPuhlsBl149MeMK88ClVWs0Ai65LjQDw8PSY+dqfI4H1RUXRMCk+5eo0zK6KTrpmcCyOrmtELwtyHkXGxuJqkoCr8V0BBRmux+vZG57nyKygjP0OABDDRS092bc389cdy5OHqtDeR1wQN65g7AEthW9lHrXqgu027ee0wX0x4kSa0uGYwoDiuvhB73DfAUANGH2lzzrKFnAoeFJ9AmKAbueZcLIqmozOwtsZX+WOxs83g/5+QJIRkyf
 e5j9FmBi
 /u2RLniaMwLM6/6M8slTBO3wIV5iR7X+pXo4zuf7Vj5VTyyOCvLiyvELz1n5mgyGs0UDm6xoN1dCKQiLofrxIWDD/FQo7IPOQhftSODq3aaDsUnv2uNIaS4pqSs5TzVA/SuwaBQWCpn90hzT0Ma1CfBGDp8i8vO3QWe+nMqupBQoQxjAWevbbd/Aal3FOzdqJt+pHJZMukkzPNsi7Hi6N1+nX3D0kv4WiA7gYRDLzt7gvw4+cXT6tUV6LcgjAi5yxS3EhONFU5owCqP8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2025-11-28 17:34:31 [+0000], Russell King (Oracle) wrote:
> On Fri, Nov 28, 2025 at 06:22:42PM +0100, Sebastian Andrzej Siewior wrote:
> > On 2025-11-28 17:01:18 [+0000], Russell King (Oracle) wrote:
> > > > I hope Russell will add them once he gets to it. They got reviewed, I
> > > > added them to the patch system.
> > > 
> > > I'm not sure which patches you're talking about, but discussion is
> > > still ongoing, so it would be greatly premature to merge anything.
> > 
> > This thread
> > 	https://lore.kernel.org/all/20251110145555.2555055-1-bigeasy@linutronix.de/
> > 
> > and the patches are 9459/1 to 9463/1 in your patch system. They address
> > other issues, not this one.
> 
> Oh, the branch predictor issue. Yea, I'm not keen on changing that
> because I'm not sure if it's correct (the knowledge for this has
> long since evaporated.) There have been multiple attempts at fixing
> this in the past, and I've previously pointed out problems with
> them when I _did_ have the knowledge. Have you looked back in the
> archives to see whether any of that feedback I've given in the past
> is relevant?

I dug up the emails from 2021, 2019 and you complained that I open the
interrupts too early. Now I moved the invocation of hardening the branch
predictor to happen before the interrupts are enabled. Based on that it
should not raise to any complains.

> > So Will suggested to let change the handler and handle this case. The
> > other patch is avoiding handling addr > TASK_SIZE.
> > Any preferences from your side?
> 
> ... and now we have a new proposal from Linus. I'm not intending to
> do anything on this new problem until the discussion calms down and
> we stop getting new solutions.

Okay. If we could please sort out the first part then it might be easier
to move on here once the dust settled.

Sebastian

