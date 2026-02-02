Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 47113E73165
	for <linux-mm@archiver.kernel.org>; Mon,  2 Feb 2026 19:43:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7FA1D6B0095; Mon,  2 Feb 2026 14:43:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7A8776B0096; Mon,  2 Feb 2026 14:43:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 680646B0098; Mon,  2 Feb 2026 14:43:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 56DD86B0095
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 14:43:43 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id BA7868A51F
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 19:43:42 +0000 (UTC)
X-FDA: 84400541484.10.F0A2F77
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id B17F2140003
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 19:43:40 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=utBPvsVE;
	spf=pass (imf09.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770061420;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PUWBIrP78opZNdJbQdciYGrwuEJ5dHQ/fuTQpKWSAjU=;
	b=xvCKqavRc+Aje3txTduZ4gzmqoeaz284ACYjZE+SvfyQ6Axl6mQFr7YHdzFx1CRwlktiVO
	3iMHy8VrRkLlHZLoW0ntea93J5uMb5duuDIoSzwRPpC5jMhUcryB1mSC35vUifkvD/Pa3i
	lPCz8239JNLeKkkZVFzVjoxVky3KDbc=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=utBPvsVE;
	spf=pass (imf09.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770061420; a=rsa-sha256;
	cv=none;
	b=7ihyNOEo4n1TqpJCnf3mROPq0u+rl5E4Qoj1640bjgHVPTqLe5J5vKRJfhhmqFfrT6R/Yb
	IV0C/M9t5Cl/gyoXdFQT6AxWnPAAWW2LP86s2VuBDSIjpzMLRkX6QaMH8mxxfZyqRAvD6n
	NJTS1Uw8yvB5tqo6EvOzcuMBMR9k5p8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 13248600AA;
	Mon,  2 Feb 2026 19:43:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72ECAC19425;
	Mon,  2 Feb 2026 19:43:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770061419;
	bh=hq/wkgdPnsy/n7unUoWg2bNDVpMpHe1tPcwYEi7v2Ho=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=utBPvsVEODaRCMfLB7ORx2MPLqLsfljOjbRy6a8CbKkOvkPoWWGDlgbsJ1t9BOUN7
	 SXTnFqw1B8ZBbKyDZ6wZvrzIu+XtWPEC6YX8pkEPoHKlMchwqt7aFWmw4sQ68wmAcf
	 y7IUpHuie9G+JZq7NEzh5Z5OuZTp4pNA5Vzh2Lgl4qjmB/OQ6ETbUjb/8gTB29z/uK
	 cmlsSGKcF9eoFb0UEqGVh+kZNqL7Q73+ElJdDQ1L4JOMBHPfwUFwfbEuGlJZHhk6ks
	 DHE1mvbixEuVLnBXhwN+k5RdKVkRLZgEYJblZeLD7tsGt+j86guUkZSZ1Q4Zhxx80C
	 5Xy+yRY9IXG0A==
Received: from phl-compute-03.internal (phl-compute-03.internal [10.202.2.43])
	by mailfauth.phl.internal (Postfix) with ESMTP id 6D9F5F40068;
	Mon,  2 Feb 2026 14:43:38 -0500 (EST)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-03.internal (MEProxy); Mon, 02 Feb 2026 14:43:38 -0500
X-ME-Sender: <xms:av6Aacqc4713DP2VCEM5iEU3nGx90At0PO-Shp-WB0S05uxb8X2a9g>
    <xme:av6AabbZJ6xWyECVYpaWCYXvtBi1KW2_bo7G39p0SDUqE-P9y6VMUjkN0eaxk4yjx
    H5ACX-Yclqyqoe3l_XXDKWqT2Z0MovzcqyNjtVTirQF2zdVqrAIonPq>
X-ME-Received: <xmr:av6Aaf5V-OxVEQ7aGlxoqHrzrOFW-ijFfCDTZyIboC-YhJKqweif2sDYC6ZFQA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddujeekheduucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepfffhvfevuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepmfhirhihlhcu
    ufhhuhhtshgvmhgruhcuoehkrghssehkvghrnhgvlhdrohhrgheqnecuggftrfgrthhtvg
    hrnhepueeijeeiffekheeffffftdekleefleehhfefhfduheejhedvffeluedvudefgfek
    necuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepkhhirh
    hilhhlodhmvghsmhhtphgruhhthhhpvghrshhonhgrlhhithihqdduieduudeivdeiheeh
    qddvkeeggeegjedvkedqkhgrsheppehkvghrnhgvlhdrohhrghesshhhuhhtvghmohhvrd
    hnrghmvgdpnhgspghrtghpthhtohepudeipdhmohguvgepshhmthhpohhuthdprhgtphht
    thhopehvihhrohesiigvnhhivhdrlhhinhhugidrohhrghdruhhkpdhrtghpthhtohepsg
    hrrghunhgvrheskhgvrhhnvghlrdhorhhgpdhrtghpthhtohepjhgrtghksehsuhhsvgdr
    tgiipdhrtghpthhtohephhhughhhugesghhoohhglhgvrdgtohhmpdhrtghpthhtohepsg
    grohhlihhnrdifrghngheslhhinhhugidrrghlihgsrggsrgdrtghomhdprhgtphhtthho
    pehlihhnuhigqdhmmheskhhvrggtkhdrohhrghdprhgtphhtthhopehlihhnuhigqdhfsh
    guvghvvghlsehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhrtghpthhtoheplhhinhhugidq
    khgvrhhnvghlsehvghgvrhdrkhgvrhhnvghlrdhorhhg
X-ME-Proxy: <xmx:av6AaWRoQe9VwPYMBlQnL1SkVdwA0x1tw2nKDSWyA0I9U3uE2G8uxg>
    <xmx:av6AafsJijIxdd9W07yMw9SOLzRlEyO3gGmYdGMMfb9Zocc_md8ghw>
    <xmx:av6AaYZ4GGvUFXcYHwUJ4Q5phX5mB35MkDKLX-P9tXhwmD-DNeTugw>
    <xmx:av6AaZ--4frUTtd_I8rDNcRQk-QbMwywmsxTwBjk4ZHdIncliPp68g>
    <xmx:av6AaUph2FTNUmZmEoMPzWEyysX2n6saY4iVUtIJ38MQRhchdQMqCIFF>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 2 Feb 2026 14:43:37 -0500 (EST)
Date: Mon, 2 Feb 2026 19:43:36 +0000
From: Kiryl Shutsemau <kas@kernel.org>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	Hugh Dickins <hughd@google.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, linux-mm@kvack.org, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Orphan filesystems after mount namespace destruction and tmpfs
 "leak"
Message-ID: <aYD7zpZQeeRpy9ho@thinkstation>
References: <aYDjHJstnz2V-ZZg@thinkstation>
 <20260202184356.GD3183987@ZenIV>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260202184356.GD3183987@ZenIV>
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: B17F2140003
X-Stat-Signature: bd6nefxapjb69co71guau9rfi6cmjwms
X-Rspam-User: 
X-HE-Tag: 1770061420-862201
X-HE-Meta: U2FsdGVkX1+2ll77J2XMYFAZen9vOzWFPXhEeNifExS79pNYgVALX/UwGK5We3yssm/UTGR4RkRtUtjmY8IUUXr8IdzXrjcQAG7r9Bn4cbewBrRMmjuKUmPSAZlw1kaISjihhEfJmww4EPB4/j7FJRDqqJaxQBGE9mxyuUYzoWSaDHZjaW9rTEySQZg3rNZPZ/c3UvZSkZW/z/wcHxNIHQIJ+L+B2zlYu5ktUbqaVR2m91AYWAx+IS4ur4t1+wKQ/YMT3KYsn61k8BWz3xfLrYjfQH8nTtSGD3PnvMf0fs6ACH2Pfu26rhlc0eOS2xkB2jiuLilgmcLJXySM1N8kF9JnVy7pUTq+VaMCzKA5xc8R/aME1b9sXf47/CEroVgLVgIU33f8b4v4izWm7hqSqDz92BBeMAZFRSusmu2oYPwkhVGaNpIiWQb+PbdUmQ633KthSjcrdUKg0+/isaDIXTW2+OrOmfLbJ1uz/ghVzy7NM4lrHPD0TY2loOqxKoWYFpd4IZO2TlqjQEW/26kYd9f3OfRjNMjwJaLpXka80HcbekjDL9cCdNuA7mPsMsVyw8J1EF3HM1XE8sYlLEOX4m7VPCJRLobkEqiVxWYlihuUhn3M2jiYFHNG+3xMFR7o8Ju2mRCLMFQPtVs/vspITzVJF9JTgvP4pJ1cOUZX89jiXHEQRigBSfiHimhCsaU7Z6GwdBEbgyfhDg9gavuP4PAFsQjfWv+/q81AOtKKTyGpTdNQ2JB7dm8LIKNvqPcOzEF4xGHl2A/QeGyOrWINQ5pNCDy1kI3JpxY8cgZZoDvQUc8B05J10pokGgQ6McUv9iy6pGregZ70NIYljIbAtYqFnSL+Xg8DcimBopwskqxJgSpu8pux8XWrX47LTDHzG8+t1/d6k4FFjYw2PuxszhleAJnCpTMesLUT0IQIAZXnUvXUvDlGPY33F+g2sNMmILSeU1WIW9YF5h+eBy4
 lq0o7q7M
 JWbrwoHcBMxZzd5QH3bTLWo+smozQibWHuVRQu2Umrba7Ca7FHFPuZh+Ekhxz7iZ5cLaoIVu7x35EU2D3lkYvNufznF2tGPc/EWINDHVoGUdqLrGpgQ6KaCGuCUr7zeAtWNzvSQCi5Cd6E0Bxmk9diQmIIEDP05Vvsn11N7K5TUX/Okxgr6hv+MHxFoPdgx1H4ZZz0wfs4yRd0OUvwejxVWZt+RcLLNmgWKM7QyhWpdE86R4TOScSDQnyVMLfa1N6hYQ/FoVSLStB9IEt5qtupeCgwg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Feb 02, 2026 at 06:43:56PM +0000, Al Viro wrote:
> > I am not sure what a possible solution would be here. I can only think
> > of blocking exit(2) for the last process in the namespace until all
> > filesystems are cleanly unmounted, but that is not very informative
> > either.
> 
> That's insane - if nothing else, the process that holds the sucker
> opened may very well be waiting for the one you've blocked.

Good point. I obviously don't underhand lifecycle here.

> You are getting exactly what you asked for - same as you would on
> lazy umount, for that matter.
> 
> Filesystem may be active without being attached to any namespace;
> it's an intentional behaviour.  What's more, it _is_ visible to
> ustat(2), as well as lsof(1) and similar userland tools in case
> of opened file keeping it busy.

I can only see the opened file, not the rest of filesystem, right?

Do you see the USB stick scenario problematic? It is weird to me that
umount would fail with -EBUSY here, but kill full namespace is fine.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

