Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DBC97E81A3D
	for <linux-mm@archiver.kernel.org>; Mon, 16 Feb 2026 15:57:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1F9B16B0088; Mon, 16 Feb 2026 10:57:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1A7AD6B0089; Mon, 16 Feb 2026 10:57:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 089E26B008A; Mon, 16 Feb 2026 10:57:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E802B6B0088
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 10:57:49 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 9A3FE1A0E14
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 15:57:49 +0000 (UTC)
X-FDA: 84450775458.26.1222FD1
Received: from fhigh-b8-smtp.messagingengine.com (fhigh-b8-smtp.messagingengine.com [202.12.124.159])
	by imf26.hostedemail.com (Postfix) with ESMTP id AB61E140009
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 15:57:47 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=anarazel.de header.s=fm3 header.b="jNP6/UIn";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=BdzMv320;
	spf=pass (imf26.hostedemail.com: domain of andres@anarazel.de designates 202.12.124.159 as permitted sender) smtp.mailfrom=andres@anarazel.de;
	dmarc=pass (policy=none) header.from=anarazel.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771257467;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8ny6L3zkCfX0j47xfHrpkoxrxspJzdvPThy0B9HOMh4=;
	b=IPWXxjB/MFweHiB+lzJLcIU3D8zMCynBJn4JPiBXkZpBmK9ylieL66bXwLeXI3LHDatUAx
	zZKpzGQMkqv29J7eXEHnRQR562MqtbC2Foi0J02qMYJkv7mlrf5VUxcA74/krp/I6VGCbG
	inGz0axB186NPMVwUHxO8kfGRXfh2jw=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=anarazel.de header.s=fm3 header.b="jNP6/UIn";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=BdzMv320;
	spf=pass (imf26.hostedemail.com: domain of andres@anarazel.de designates 202.12.124.159 as permitted sender) smtp.mailfrom=andres@anarazel.de;
	dmarc=pass (policy=none) header.from=anarazel.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771257467; a=rsa-sha256;
	cv=none;
	b=T2qPMiLzgfrwer3R0I3POuAYBB7d8cWTD/tyr4qvz37vGIdC2q5SUPJyVYLuGro3d1Obom
	P/yW7LLQ/HiSwuuAPGkdFp4UUj/0lEuUNH8x6Wg8rAg2B9FJkA9TOfsWrcSTjAgcbyGo8u
	RZEJMq3Kn56G1jZiZlLRt8EPddUSAIs=
Received: from phl-compute-03.internal (phl-compute-03.internal [10.202.2.43])
	by mailfhigh.stl.internal (Postfix) with ESMTP id 7253A7A017A;
	Mon, 16 Feb 2026 10:57:46 -0500 (EST)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-03.internal (MEProxy); Mon, 16 Feb 2026 10:57:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=anarazel.de; h=
	cc:cc:content-type:content-type:date:date:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to; s=fm3; t=1771257466; x=1771343866; bh=8ny6L3zkCf
	X0j47xfHrpkoxrxspJzdvPThy0B9HOMh4=; b=jNP6/UIn5h67c4pHOIJt6WcBFQ
	3Ez9eAHvBKjWUSGOP4z1rJU0bZDj72VpXbJqJ19zf6F/UO0VdFXizuY4co3ti2T9
	CsDdHZr8YznwA16hnBSinl23TMH9oth63/L6WVm4PO1OiUzxakZ3Zb6ROdyb9yM7
	4o1eD8VZ5vXcZEQDCUWD6TfPu0s0hDVlGOqQNUGy2KXipcxLg+01VwCbRRyAW2lm
	lKlz41EngtphONWUuwGvlEj7Nset88WpvMccOofU9A06fy6roLH9czpXEHQYUhsW
	ziKTnS9Z4Ifp8a2oT6BO2cscSBwXXhX6WzMfUE/+EEnKibNzNZruRgWAmebw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
	1771257466; x=1771343866; bh=8ny6L3zkCfX0j47xfHrpkoxrxspJzdvPThy
	0B9HOMh4=; b=BdzMv320tFvUAITz5K7ZBbhslwF0II4hV0vFg0VgmUMLJrWN+a3
	rC32xlNR88mYbvbOuelZmvsDlY42gj3KWMsSFSupy9iyiPvAzk+qEO6ma5kYQA+Z
	gh+sC8QShDOhwn9kIMU29pnNE4TFZJlBezaImBVzhEXHmIULUlj5Hp565a0kcgDo
	yrU/ZPgr/rgMwcotIMPOOsDhbs3OT6WYqN6KUqbAmSkjwhg2FiFFvbPIlImv8VPI
	Ezi7dkiVb2sizvwRUTTRueZgZ/sdTHU6NOCxTeq/j0vpLZfubh3NJJMYGvYM0Gm9
	axnEf2iw38s0sbV/vKASyWq+2Ja4ZrP+C6w==
X-ME-Sender: <xms:eT6TaYhy7ZiIUMNV9o5zAxxBmLsgQ-F0vPzNVDppUIY-4mPVavQg0A>
    <xme:eT6TaX9RQwxh4SJ0Z-Qh42ytjdQ5z27PsbfnK7H5uNwbGqR-bMc3_EiJRQ6FNJzs0
    wigUHEjKXN69XL2mOVzIMZeT9A9G8eoDM5w7xYX1hqP7z2I8IRbCQ>
X-ME-Received: <xmr:eT6TaVIf5ahnHo_4mr99E4_Qc3ozO5CRvGpwHgIp8cscheAJayHWW9Jukn5rm39hE2-qbg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddvudejvdelucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepfffhvfevuffkfhggtggujgesthdtsfdttddtvdenucfhrhhomheptehnughrvghs
    ucfhrhgvuhhnugcuoegrnhgurhgvshesrghnrghrrgiivghlrdguvgeqnecuggftrfgrth
    htvghrnhepheeiudduuedvleetjedujeffgeeiueevgeehjedtgeehueekledthfelhefh
    geelnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucevlhhushhtvghrufhiiigvpe
    dtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegrnhgurhgvshesrghnrghrrgiivghlrdgu
    vgdpnhgspghrtghpthhtohepudelpdhmohguvgepshhmthhpohhuthdprhgtphhtthhope
    hrihhtvghshhdrlhhishhtsehgmhgrihhlrdgtohhmpdhrtghpthhtohepfihilhhlhies
    ihhnfhhrrgguvggrugdrohhrghdprhgtphhtthhopegujhifohhngheskhgvrhhnvghlrd
    horhhgpdhrtghpthhtohepmhgtghhrohhfsehkvghrnhgvlhdrohhrghdprhgtphhtthho
    pehlihhnuhigqdhmmheskhhvrggtkhdrohhrghdprhgtphhtthhopehprghnkhgrjhdrrh
    grghhhrghvsehlihhnuhigrdguvghvpdhrtghpthhtohepohhjrghsfihinheslhhinhhu
    gidrihgsmhdrtghomhdprhgtphhtthhopehlshhfqdhptgeslhhishhtshdrlhhinhhugi
    dqfhhouhhnuggrthhiohhnrdhorhhgpdhrtghpthhtohephhgthheslhhsthdruggv
X-ME-Proxy: <xmx:eT6TaQY6AOTmuO-eiDc2jyfM8Qa83v5y5WghAv_duMKrl_625G_eow>
    <xmx:eT6TaQgNIRQ4QYpWgiLXRkrs7g6kWwRJytm6vJeR7oZUbk3d1nRzbA>
    <xmx:eT6Tad6T-bM66v1fbCzXuMHeZUNnv_OpR1gFDTASS_eYK6jsRj3i2w>
    <xmx:eT6TaQqyEeQ8IlZfnoHLXgIKu_lJdfCKwvXF6vyd9E2tiSn7YtxT1g>
    <xmx:ej6Taf5s9cJOCvzk2wAxZZHwlzUlaswk1VbSZywx80cTTUpeVNnqhVE3>
Feedback-ID: id4a34324:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 16 Feb 2026 10:57:45 -0500 (EST)
Date: Mon, 16 Feb 2026 10:57:44 -0500
From: Andres Freund <andres@anarazel.de>
To: Jan Kara <jack@suse.cz>
Cc: Ojaswin Mujoo <ojaswin@linux.ibm.com>, 
	Pankaj Raghav <pankaj.raghav@linux.dev>, linux-xfs@vger.kernel.org, linux-mm@kvack.org, 
	linux-fsdevel@vger.kernel.org, lsf-pc@lists.linux-foundation.org, djwong@kernel.org, 
	john.g.garry@oracle.com, willy@infradead.org, hch@lst.de, ritesh.list@gmail.com, 
	Luis Chamberlain <mcgrof@kernel.org>, dchinner@redhat.com, Javier Gonzalez <javier.gonz@samsung.com>, 
	gost.dev@samsung.com, tytso@mit.edu, p.raghav@samsung.com, vi.shah@samsung.com
Subject: Re: [Lsf-pc] [LSF/MM/BPF TOPIC] Buffered atomic writes
Message-ID: <fh3hxyhoezqzcsabqjr2glft2uvrx5bkyx6pejek3uskpm5ow4@zym4kmg5o2bm>
References: <d0c4d95b-8064-4a7e-996d-7ad40eb4976b@linux.dev>
 <aY8n97G_hXzA5MMn@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
 <w3vwdaygcz3prsxwv43blo4co666mragpdwaxihbirt5stl4vr@agyz4mnaxghj>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <w3vwdaygcz3prsxwv43blo4co666mragpdwaxihbirt5stl4vr@agyz4mnaxghj>
X-Stat-Signature: h4fczk3uo7atxqba41o4b58bedray9gu
X-Rspamd-Queue-Id: AB61E140009
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1771257467-440621
X-HE-Meta: U2FsdGVkX1/uvVeAPSovC0UVVhQxTGAfp5Z4CDEQtsQ+TKpmbXGL1HUNVt9sgvLp3hos84mrpQ6ExEvL8kOrriLoyQeDKHQu5B9crgVvTUcdPV6lIVmgQPCOnjUHbQnzJ1yriSxboV4yhKGExusa3LEAHpF6StmNvbLcJJ/2tuaUjJkib6/LdokSstGkc7NlAJn5xTtqLuS8XRMZ6uQaNehXygLu811iStykJRA+1pWEqi9KTqV2sv69ed+PKUmzdclIfQotR9+R6beWNO/udIG+OV1T3Mzt9gEMWVQ4XHyKqOp+4i0sXx0GT0/78F88CHLh79Tgw5OFiALUkatj4POSeVs+hPqvD/IbRTPrdL8SyLfuFhwOjfsvW3PZqGfulxNxon44VJ92EH6650+k835qibjezLdhYm2751t+NSG1vMGfOHYa15uc0NFIQgffCwFjNwZ5ae3kNyOqb6tZdfNo2vuPno/4vUHs6vWpbe0aahuzGvrwJkBs+JHdLStNBj3otEdR8Y/xvAkSM45SRCD0Mnx4I4YiY+y7TwH96TMh7DVdsIRssBIc0gRgCI9n7GyIiPXzCPmoeJnN9vnBKogouMT5m4Q6NGs1CaSlyHmtVQIz/ebwh+8Vy4WpdL93d2e5b4LSP5Bk7Im1jDb6Xfzaw2TgbQ/snB2R+erJ0BrVnx1JM7IcrHNAJiu9u50pGaP7p2eeYetu8ScJZk1I9RYQ5hQ9/7OF4oVSLz7ZA7VtqaSv3wfMCyLN+oUYmlM6vHpMIkNEOaKsz2ynSaBV9EEHu0VrqFFw66kydAUUaVICRTVR5AOqGa6kS+5FpZt0zhh2MRNRxA3XnZxycjLCV/TNZz5/xGDkGvQcznjaTNZTYN79idHdU8wNsyIlqhVRMAEgbd7GVsLxdnd8rIF6ZL+fEPgBMIXroINOo9nZcPyZCeN6ILkMCbdWwz5uPJ4lbVjOOzggx4PVagq0TKf
 60GtKwEQ
 Ty8H8DeLSvzbnhRT05i/8G7ho00GXpzu7JLkbACQoHkjNKJYYc0iLe6J3W07f3u8exw3DeK6FSZcnldXG8zJ9bBNL6flo0aUelz3cMSNVmW4OnNgHegiloHuKH2Yynn9B2txF9sNGE7PntoR0VL7VJE6kmYtBI8IxLzFZn/3ZVTZmN6DInY05yoIhVyAgKVBrR+PdVHyieItn5ben+/wM3odXGw3WnY4u3x7lcUaIKxlSRnL4mciapyYq3c2XPdYyyWn3Pw+4uckFogXNHex1k2oLanNvOKmFy3b2qkkKHxIbpl7K49ENomtal4qFoShhzIq3+fkmDw/HHPJfUO+y9cWZNjncJc7sGnKOk2GFoCa3g4OGkMLWbWdFm2QHXBXZNtAf5HOrhOF+jAqzkErDzld+UzlxvPRSHp2m4pf+8vZc8kAj4hlEP8zGFyOEI67y9/+eT1msBCrb4/s=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

On 2026-02-16 12:38:59 +0100, Jan Kara wrote:
> On Fri 13-02-26 19:02:39, Ojaswin Mujoo wrote:
> > Another thing that came up is to consider using write through semantics
> > for buffered atomic writes, where we are able to transition page to
> > writeback state immediately after the write and avoid any other users to
> > modify the data till writeback completes. This might affect performance
> > since we won't be able to batch similar atomic IOs but maybe
> > applications like postgres would not mind this too much. If we go with
> > this approach, we will be able to avoid worrying too much about other
> > users changing atomic data underneath us.
> >
> > An argument against this however is that it is user's responsibility to
> > not do non atomic IO over an atomic range and this shall be considered a
> > userspace usage error. This is similar to how there are ways users can
> > tear a dio if they perform overlapping writes. [1].
>
> Yes, I was wondering whether the write-through semantics would make sense
> as well.

As outlined in
https://lore.kernel.org/all/zzvybbfy6bcxnkt4cfzruhdyy6jsvnuvtjkebdeqwkm6nfpgij@dlps7ucza22s/
that is something that would be useful for postgres even orthogonally to
atomic writes.

If this were the path to go with, I'd suggest adding an RWF_WRITETHROUGH and
requiring it to be set when using RWF_ATOMIC on an buffered write. That way,
if the kernel were to eventually support buffered atomic writes without
immediate writeback, the semantics to userspace wouldn't suddenly change.


> Intuitively it should make things simpler because you could
> practially reuse the atomic DIO write path. Only that you'd first copy
> data into the page cache and issue dio write from those folios. No need for
> special tracking of which folios actually belong together in atomic write,
> no need for cluttering standard folio writeback path, in case atomic write
> cannot happen (e.g. because you cannot allocate appropriately aligned
> blocks) you get the error back rightaway, ...
>
> Of course this all depends on whether such semantics would be actually
> useful for users such as PostgreSQL.

I think it would be useful for many workloads.

As noted in the linked message, there are some workloads where I am not sure
how the gains/costs would balance out (with a small PG buffer pool in a write
heavy workload, we'd loose the ability to have the kernel avoid redundant
writes). It's possible that we could develop some heuristics to fall back to
doing our own torn-page avoidance in such cases, although it's not immediately
obvious to me what that heuristic would be.  It's also not that common a
workload, it's *much* more common to have a read heavy workload that has to
overflow in the kernel page cache, due to not being able to dedicate
sufficient memory to postgres.

Greetings,

Andres Freund

