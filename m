Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5C01FE909C4
	for <linux-mm@archiver.kernel.org>; Tue, 17 Feb 2026 15:47:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 744526B0005; Tue, 17 Feb 2026 10:47:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6F1C56B0089; Tue, 17 Feb 2026 10:47:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5F42E6B008A; Tue, 17 Feb 2026 10:47:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4EC716B0005
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 10:47:15 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5C0CA57559
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 15:47:14 +0000 (UTC)
X-FDA: 84454377588.02.159F5A4
Received: from fhigh-b3-smtp.messagingengine.com (fhigh-b3-smtp.messagingengine.com [202.12.124.154])
	by imf28.hostedemail.com (Postfix) with ESMTP id 2E786C0006
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 15:47:12 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=anarazel.de header.s=fm3 header.b=Mn8APs0x;
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b="E h20fcj";
	spf=pass (imf28.hostedemail.com: domain of andres@anarazel.de designates 202.12.124.154 as permitted sender) smtp.mailfrom=andres@anarazel.de;
	dmarc=pass (policy=none) header.from=anarazel.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771343232;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eSOHZKYixCwKfgxL+toMTrJrfTKK7cDvAJRVjTf9RM0=;
	b=GpKu9P/a4QcK+srUt4bIuNBboDdAK6fQaEtZGcvvUbLq8JFg5B37jIMtBXLfNyxCZjbOUN
	T0AkKXlHb5YfVGU7cegMXcCfOLlEAgNU1ohwDV7ge56uzRF6OfLAK6N4uOruBG05sy3RIS
	fG3nrIb9ufmxmwSLhPwNvWI9cfPFklk=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=anarazel.de header.s=fm3 header.b=Mn8APs0x;
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b="E h20fcj";
	spf=pass (imf28.hostedemail.com: domain of andres@anarazel.de designates 202.12.124.154 as permitted sender) smtp.mailfrom=andres@anarazel.de;
	dmarc=pass (policy=none) header.from=anarazel.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771343232; a=rsa-sha256;
	cv=none;
	b=vFV/sQGNGoGgeHLRkar0R7lnLgtx+MVgeyWj6IDzuOD5VgcJ6RKNePzQy8J4wxe02obDqN
	nUh+i97h9rnECopyhEEEPPrnuf2lkcMLprabZTtJFtUD074BIfSCBpMNcoM2I/Kd7mSFqc
	8BPrLcOfTdy8Z3HRFKZYzZmrZelhgMk=
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfhigh.stl.internal (Postfix) with ESMTP id 7E88A7A0108;
	Tue, 17 Feb 2026 10:47:10 -0500 (EST)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-04.internal (MEProxy); Tue, 17 Feb 2026 10:47:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=anarazel.de; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm3; t=1771343230;
	 x=1771429630; bh=eSOHZKYixCwKfgxL+toMTrJrfTKK7cDvAJRVjTf9RM0=; b=
	Mn8APs0x7sHctVRPN8/7iUwyhAmujqeUbTrvmNm6j+FOlZQSs+/73bLRa6geXjbz
	099935qUbifVqUCIxuqwEMwd4cRdQBDF5RJVHCRoL2LYmyra1T04cYK0jGCjB4Ww
	aiosmjsmjhVh5zi9HXP2X2nH+CWmUQFezSawr47QivjSVR03asypxVydDCSzJEip
	1l1nb50Qzvj5XRwtUlZeTxJv7Krl+5fts26S77m+ildbnGuxudoXIuYg0DBXcd/N
	QWQHG3qmhAwZ2rogEfeBYAz1VvqL9we1C+ioIx65wRGnjXK48GeoAufxMfERQmPa
	e87uHR7i06X8tgJbELLHyA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1771343230; x=
	1771429630; bh=eSOHZKYixCwKfgxL+toMTrJrfTKK7cDvAJRVjTf9RM0=; b=E
	h20fcjUeQD5VDaOOummopqzrHBZf0r3+6stdjYoCheS8QRvS9yb/OGU1xwhJRLaB
	HzuxZsLMWkhcdJuX2AAhxP2m9oGf8VPs4dlhELOxNlwXhxCpEO5IPUxY6Qq5SYCY
	QRPqP8tJPkDWOu5I+33J+MPRYpccOZElANHNqzGX8IH+h/dmcdsdTu5pBTTK9DNj
	/Z8ujUYiP35PUcT0J8r6UEQWsvVRMtz7B6lMQR8+Zb7iGA/1KLWCvjGOe1JC/bee
	rrCQVrghgs4vWEjFQscYYybLZyqGT07MyGI/2rQwh9mgANE8qVn8r7LdDMjrpGwm
	AnaanyrFKK0z2w4/Yoi/A==
X-ME-Sender: <xms:fI2UadxdXWxOkJBqkCf3w_2xjNSc95X5l6befkBvbTGYGq9ya6YceA>
    <xme:fI2UaZLt5zDl_7wWXcGZeRnoWgoze8gE_tmakKEUWp14tpfP5GopDHfId27gpLCzX
    Xb-7PAwxLS2J8nGPfjZDSbXqGYYVhJ-224WBUiVnYsbpks79NTsTw>
X-ME-Received: <xmr:fI2UaS063dnAzv8VHGf0UxFZLuYO9TsPYnhFGbMQ31mNL3wUi2pxw_KaQml3ieMaA-nHEw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddvvddtudeiucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepfffhvfevuffkfhggtggugfgjsehtkefstddttdejnecuhfhrohhmpeetnhgurhgv
    shcuhfhrvghunhguuceorghnughrvghssegrnhgrrhgriigvlhdruggvqeenucggtffrrg
    htthgvrhhnpedtleelvdfgjedvffeiueekfeeuleffhfegfffhgfffkeevueehieehhfei
    gffhvdenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    grnhgurhgvshesrghnrghrrgiivghlrdguvgdpnhgspghrtghpthhtohepvddtpdhmohgu
    vgepshhmthhpohhuthdprhgtphhtthhopegrmhhirhejfehilhesghhmrghilhdrtghomh
    dprhgtphhtthhopehrihhtvghshhdrlhhishhtsehgmhgrihhlrdgtohhmpdhrtghpthht
    ohepfihilhhlhiesihhnfhhrrgguvggrugdrohhrghdprhgtphhtthhopegujhifohhngh
    eskhgvrhhnvghlrdhorhhgpdhrtghpthhtohepmhgtghhrohhfsehkvghrnhgvlhdrohhr
    ghdprhgtphhtthhopehlihhnuhigqdhmmheskhhvrggtkhdrohhrghdprhgtphhtthhope
    hprghnkhgrjhdrrhgrghhhrghvsehlihhnuhigrdguvghvpdhrtghpthhtohepohhjrghs
    fihinheslhhinhhugidrihgsmhdrtghomhdprhgtphhtthhopehlshhfqdhptgeslhhish
    htshdrlhhinhhugidqfhhouhhnuggrthhiohhnrdhorhhg
X-ME-Proxy: <xmx:fI2UaTcdZYB-mpJIJd5jldcTdiY-2Twjhj8aAHGKT7qzEf-NoLUuiA>
    <xmx:fI2UaW6TbJ9w1l0L50LmdJioh38TY-CiCK6iJHnQdsCrnRppAzeIew>
    <xmx:fI2UaW8wc3tfyzNhknY6_3BJhGTQY-0VBQWWApz6h7_O9W-g0AbiLw>
    <xmx:fI2UadJ6rf-vJ4UZNx7yLVwQXr04L3BfQ7RjiQ30ZLTfPrBi0OhJFQ>
    <xmx:fo2UaSfK4T3HvYEQLinaS7lvlUdt-dAbbSUTo1wOW05RdrqEQEj_EDV5>
Feedback-ID: id4a34324:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 17 Feb 2026 10:47:07 -0500 (EST)
Date: Tue, 17 Feb 2026 10:47:07 -0500
From: Andres Freund <andres@anarazel.de>
To: Amir Goldstein <amir73il@gmail.com>
Cc: Christoph Hellwig <hch@lst.de>, 
	Pankaj Raghav <pankaj.raghav@linux.dev>, linux-xfs@vger.kernel.org, linux-mm@kvack.org, 
	linux-fsdevel@vger.kernel.org, lsf-pc@lists.linux-foundation.org, djwong@kernel.org, 
	john.g.garry@oracle.com, willy@infradead.org, ritesh.list@gmail.com, jack@suse.cz, 
	ojaswin@linux.ibm.com, Luis Chamberlain <mcgrof@kernel.org>, dchinner@redhat.com, 
	Javier Gonzalez <javier.gonz@samsung.com>, gost.dev@samsung.com, tytso@mit.edu, p.raghav@samsung.com, 
	vi.shah@samsung.com
Subject: Re: [Lsf-pc] [LSF/MM/BPF TOPIC] Buffered atomic writes
Message-ID: <ndwqem2mzymo6j3zw3mmxk2vh4mnun2fb2s5vrh4nthatlze3u@qjemcazy4agv>
References: <d0c4d95b-8064-4a7e-996d-7ad40eb4976b@linux.dev>
 <20260217055103.GA6174@lst.de>
 <CAOQ4uxgdWvJPAi6QMWQjWJ2TnjO=JP84WCgQ+ShM3GiikF=bSw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAOQ4uxgdWvJPAi6QMWQjWJ2TnjO=JP84WCgQ+ShM3GiikF=bSw@mail.gmail.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: 2E786C0006
X-Rspamd-Server: rspam02
X-Stat-Signature: qghstzhzzwsjm475j3grfywmwfuatkrn
X-HE-Tag: 1771343231-227085
X-HE-Meta: U2FsdGVkX1/5NrSoHP3X13clouEr1CznJ2i2bEgIKeLuurod2G80Z9V1qSUdsZ8LgbtymQL/eMMl7A9RccrvpyQ4mwnvJrdRlzDkJq8XnslCpJHf6znNVrf2rQkNBye4esPu/dQ/3togC2gSD4kMYfl9sdifKgs0bEyJChIFveK2OlxOc3qgwmcYtFf9oQeLAupsC8CRKSJeuR3/n/B3zJnJ+MY4Y6DJJ707Yc/oPCMG03s1Cg3LaSQ4q5VRyIbJR8uoaze7abSyu8oZZJjMR8kbK3xVapLSxir5vGAnPRXyxbtEOv2duwveOAU+LtYONEaHM2K3T/gtKNR3WuhtkD4GOmEBNoQejedvFcdXyOCP8YtDRBBAf/yhC4lxEfXVhuslnfrMBgsTIb6tfVgePjHnZHAFmgCcoKs/msb+T+8Yt4u43xbMAANImyes5Ii7FKTtq/GmwHqSrywF/IdvUc2Se48cwmXelenuDi+LYG6FG2Y52hBiEOqJGKacaJq5bp9RZ+rUCM/9lTm/j9bxjqpEw7Kal890522QnMBoDJaA18jk1HMu6hJAqv63I81RkRSVIrV9T4J1yV7K+GvVla698Wl02U4CG4UcRqguQuN1J2ExzhX6M/Gdvp/hpMsRJ9hoXQ8R8ZVTBPhJ0kRRe7WSRhVVCBzH1hNoDRPZ016jXJi5BMmEpKYoT73njbMFAC6M3RdSI+kIHAP8qPho/aItk0k3S83Xdj4wDUw9ARpPi3nwGDb5Y/ZryvzyAtUXSCJtfgEdd2gqkb36ZSw8BV8JYqFKRy7qPeixGCLVLbkhvPP2Gvo/BF8h/g+YNGyTyN5sIaU0P7P9T6b5Te0zMspmrxglmfptQqp3Qw6cJ5r1ykBHv9sXcAwNArLKQ2c+q06lp+VxwVMERHqz42nL2TzrgTXXLSEC/iX1bFKFBwGMirhDFhi8q2uJeedzk90RZF/XtuH+Rbz5x7HvTak
 yn0ekFIy
 ZQJ3wFf2OiBW3kwuWcfkyzP35peRlMcMPAyhtlYmXjLhuVpMw4CmBmfOgzoj2sg4I4j06lrdYT/VmS+LwgFGIYeOJUcdWL3/14IyyWtUev5tMIcVEHnvId2PdMDgzgmt8fdQMBZo1rL0/uT+E6RrCGcSajHdMMTMco3R6YDe4T+5WBjHt52PXhLCPsCFDbqCFXtbF9v90uGCzakohHxXKuYrC0kJfSTF3gxOMwujcOPl6ReE50UIzGZLkzYFhhrf11hNzWzP60Xj/FWhTmuHFYu/xNSvDCJ3OpLJnMm938bNLn+xUZOxu28fkLr+M8pohUIYzE4sj9wHM+OLbxPImRo+jdY93E2KlqnXx/CvsOrcRHHGgHTSWIzCbxzUSiZkQjzP+ChuKVNHaTNzYpsElqHWAtT4jnEasv+uxZHWM5ZSRZw1tUc9vyGIsA5Bg/JxWFM8OCG/n/1vSqsc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

On 2026-02-17 10:23:36 +0100, Amir Goldstein wrote:
> On Tue, Feb 17, 2026 at 8:00 AM Christoph Hellwig <hch@lst.de> wrote:
> >
> > I think a better session would be how we can help postgres to move
> > off buffered I/O instead of adding more special cases for them.

FWIW, we are adding support for DIO (it's been added, but performance isn't
competitive for most workloads in the released versions yet, work to address
those issues is in progress).

But it's only really be viable for larger setups, not for e.g.:
- smaller, unattended setups
- uses of postgres as part of a larger application on one server with hard to
  predict memory usage of different components
- intentionally overcommitted shared hosting type scenarios

Even once a well configured postgres using DIO beats postgres not using DIO,
I'll bet that well over 50% of users won't be able to use DIO.


There are some kernel issues that make it harder than necessary to use DIO,
btw:

Most prominently: With DIO concurrently extending multiple files leads to
quite terrible fragmentation, at least with XFS. Forcing us to
over-aggressively use fallocate(), truncating later if it turns out we need
less space. The fallocate in turn triggers slowness in the write paths, as
writing to uninitialized extents is a metadata operation.  It'd be great if
the allocation behaviour with concurrent file extension could be improved and
if we could have a fallocate mode that forces extents to be initialized.

A secondary issue is that with the buffer pool sizes necessary for DIO use on
bigger systems, creating the anonymous memory mapping becomes painfully slow
if we use MAP_POPULATE - which we kinda need to do, as otherwise performance
is very inconsistent initially (often iomap -> gup -> handle_mm_fault ->
folio_zero_user uses the majority of the CPU). We've been experimenting with
not using MAP_POPULATE and using multiple threads to populate the mapping in
parallel, but that feels not like something that userspace ought to have to
do.  It's easier to work around for us that the uninitialized extent
conversion issue, but it still is something we IMO shouldn't have to do.


> Respectfully, I disagree that DIO is the only possible solution.
> Direct I/O is a legit solution for databases and so is buffered I/O
> each with their own caveats.

> Specifically, when two subsystems (kernel vfs and db) each require a huge
> amount of cache memory for best performance, setting them up to play nicely
> together to utilize system memory in an optimal way is a huge pain.

Yep.

Greetings,

Andres Freund

