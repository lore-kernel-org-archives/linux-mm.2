Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A72D4D0C83B
	for <linux-mm@archiver.kernel.org>; Tue, 13 Jan 2026 10:29:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B9D3F6B0005; Tue, 13 Jan 2026 05:29:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B74E86B0089; Tue, 13 Jan 2026 05:29:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A76846B008A; Tue, 13 Jan 2026 05:29:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 938FB6B0005
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 05:29:01 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 1D4E38AACA
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 10:29:01 +0000 (UTC)
X-FDA: 84326567682.10.91E17F3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id 1B401100008
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 10:28:58 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=s2aUrJVw;
	spf=pass (imf14.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768300139; a=rsa-sha256;
	cv=none;
	b=cWtqNB32Xm309cLCsxZrtR1Z2Zo8AIoUgEKGU4E2a1sGPAK36PeLr+VgRqKDFQkcPfp3vT
	FyFl3THuL4bbvAZV6GWoboryLR7TFRZsGsszC6E/PtDTRsdpYAL+GD5fXUCFO+sF4QBAQy
	BSq+orBbLgZ8/Nphua7zhgphmA6wjCE=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=s2aUrJVw;
	spf=pass (imf14.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768300139;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rI93w2f+EuoCkodfTZDpi0RbO5cNHdC0rtrVxEbhSBQ=;
	b=3xWbP8CyI8iUll+Dx3UGnOUewOSbJ7x4emoA0OfNVjtTtZ+tonWZFyjR32Ep06CdolzGog
	aNh//b7yDdkePx/6lLEl3eAWh9nxpBJ4bx10KKtIoPqTzITUgx+8XiwC528MzN6DtuRmo6
	PxSdIjESXw1YmmmzaAFd/gOTp09P/FQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 3B2616001A;
	Tue, 13 Jan 2026 10:28:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81D4AC16AAE;
	Tue, 13 Jan 2026 10:28:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768300137;
	bh=N68j10Imr8Oj2TObO7c8P8UDnygSs8IugasnfTpCDZI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=s2aUrJVwgXahtVnOEwCpcxQKO/9RKMSR4dsAmEzqxaz9Voia1Jsr5qTQS+pSj0OTT
	 7Qu44FzfWQ1IZ/jwI1AKjwQg/vbEUXcWrkPJ3K+E6j+eoiigZEFrG6r7Ftrzdbjjy6
	 z7DAp88TqrKe3s+kiGvxjO3Xf/ZrQie7B9nDKfuw9vJSxX1TGxUoO1Rwey+mg8f/jz
	 OKvnG5eWPZB6+MuSWWifE5vrpedZyB5hvDA1b4RQwCWQ3XvzTg5On4AvzmgAnet5W/
	 p7FN3Bp4XDUd8sUReSo9eiOizM1b8DzkFz5axgB86Vx5dL1oUmSqzBaT8cCYZinKCi
	 tw5xLZyvkuGHA==
Received: from phl-compute-03.internal (phl-compute-03.internal [10.202.2.43])
	by mailfauth.phl.internal (Postfix) with ESMTP id A6D20F4006C;
	Tue, 13 Jan 2026 05:28:56 -0500 (EST)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-03.internal (MEProxy); Tue, 13 Jan 2026 05:28:56 -0500
X-ME-Sender: <xms:aB5maeWdtLxRpWUhslSqbEuaig6QFcNdvjduZioHMp0nUi5haG7Yaw>
    <xme:aB5maSQopPHtnJiDrpDIYflf8cmKzFjfQ3_yadwr03qgpauc_mZE9HRwdBm0U_VzD
    Ew9oUHE16nxExWE3wHhAvtqonEQu1A9nwXQdTzY9nn3BYMKDq03mGw>
X-ME-Received: <xmr:aB5maYMFxN231BNejme6KU2QB5vban3K2oK9n9I2cIwkzhXH8tzehZaEZoiqlA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgdduvddttdekucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepfffhvfevuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepmfhirhihlhcu
    ufhhuhhtshgvmhgruhcuoehkrghssehkvghrnhgvlhdrohhrgheqnecuggftrfgrthhtvg
    hrnhepueeijeeiffekheeffffftdekleefleehhfefhfduheejhedvffeluedvudefgfek
    necuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepkhhirh
    hilhhlodhmvghsmhhtphgruhhthhhpvghrshhonhgrlhhithihqdduieduudeivdeiheeh
    qddvkeeggeegjedvkedqkhgrsheppehkvghrnhgvlhdrohhrghesshhhuhhtvghmohhvrd
    hnrghmvgdpnhgspghrtghpthhtohepfedtpdhmohguvgepshhmthhpohhuthdprhgtphht
    thhopehprhhsrghmphgrthesrghmugdrtghomhdprhgtphhtthhopehlihhnuhigqdhmmh
    eskhhvrggtkhdrohhrghdprhgtphhtthhopehlihhnuhigqdgtohgtoheslhhishhtshdr
    lhhinhhugidruggvvhdprhgtphhtthhopeigkeeisehkvghrnhgvlhdrohhrghdprhgtph
    htthhopehlihhnuhigqdhkvghrnhgvlhesvhhgvghrrdhkvghrnhgvlhdrohhrghdprhgt
    phhtthhopehtghhlgieslhhinhhuthhrohhnihigrdguvgdprhgtphhtthhopehmihhngh
    hosehrvgguhhgrthdrtghomhdprhgtphhtthhopegsphesrghlihgvnhekrdguvgdprhgt
    phhtthhopegurghvvgdrhhgrnhhsvghnsehlihhnuhigrdhinhhtvghlrdgtohhm
X-ME-Proxy: <xmx:aB5maWtNABOE5heYiTbE1RhalIxva5dQv_tU5i-qNStTUyy067IEJw>
    <xmx:aB5maUSIZtxolFI3W-P3f2_vTqOhJ-BBgun7iWnQFgCbYSKik6HrxA>
    <xmx:aB5maYvXmY6f-3MY030OOGUjcBYEEX9gLaw0Y7FCkt0jsMuGPTFHXA>
    <xmx:aB5maazdvvek_kPITXbFnNJ6nUHWHS6frh2Sgu1ehszVz7oZA1A9TQ>
    <xmx:aB5maf3hytYqmQ0d0peATdxeCnV3I7-IxCpN_0t29dqCyoIA0ORAsIkT>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 13 Jan 2026 05:28:55 -0500 (EST)
Date: Tue, 13 Jan 2026 10:28:50 +0000
From: Kiryl Shutsemau <kas@kernel.org>
To: "Pratik R. Sampat" <prsampat@amd.com>
Cc: linux-mm@kvack.org, linux-coco@lists.linux.dev, x86@kernel.org, 
	linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, 
	dave.hansen@linux.intel.com, ardb@kernel.org, akpm@linux-foundation.org, david@kernel.org, 
	osalvador@suse.de, thomas.lendacky@amd.com, michael.roth@amd.com
Subject: Re: [PATCH v2 2/2] mm/memory_hotplug: Add support to unaccept memory
 after hot-remove
Message-ID: <aWYctexPTf-w7QT8@thinkstation>
References: <20260112202300.43546-1-prsampat@amd.com>
 <20260112202300.43546-3-prsampat@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260112202300.43546-3-prsampat@amd.com>
X-Stat-Signature: cfe3wzrb3np7jyqswramqmfuw14scw9t
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 1B401100008
X-Rspam-User: 
X-HE-Tag: 1768300138-165943
X-HE-Meta: U2FsdGVkX1+JpHkTk2ZfBJZSdVvBOyo0MOWK888GTl0K+pLyv8X0kb4HnfC49tAX8q8vRZ8vH3dFYR7zNmoWHVRbQoWmSw/gyjcUD5/i1GCd7IzFyp2HqUgqDuuXFN19uA9LRZ9TvL+Yti2L/69mKmwS/ccuhPKn/qVlpiKl6rXwTLEbjnIRhbR4h6C0hSVquQ6LngSiA2fotTqfLeBrqunVvJWndxk4sbdc1wrXQGTT8V9r6Ly9p2BQeU8rnztqBPAS0FgtktNIkIs9CXBoxgpFLfETSlreXSmyNzjTZ2ZvaBJ70AnKtcxGIYFAthQs7EBturcJ0dXJqbDygh+nvwtHtl5vpWQ4KNuG1SBalMLpgK6GypZXmmqGDjlbCjBlklV1xjcRjij8pICLx5ggtNMuo/Z4R+sbmX6j0UIxO851f64Z6NB2L3V47UojYujeiSX68S3Hvq2Ojw5COe+EAnlgns/lbouGIetRiwgZDIMwd4yTM9e+8fn1s/fBvSXwXyaESP/waT9nvYTZx0hq8VOeavVBsck2GC4Jgk8O5IVayBQL+TvgAhSODJkJ3x8HTwt53HNtwO6SOw7sDWw7tDhm5k2t6fa19FdYJP62qwO41/EWygWp39o6nI2SjpahTqq8MhKbVGuG+Wz2I0FwhszGnJaebF3C0BrS6eREcBlpKB5tIx6Espt7ki4L1ByTSlaDQtHZ68uBt91ZDHn8YAktNayDd5PxzrErV3210vETO0RgoYjDEAM5dLG60+K/QFzf0noL1Cj/v7n7G9rCJsp5dodnzadChhMD2L5XFjLsdCvp2bscWYsQSHVhgSOT9WnZXSOmNPsvEaBbiFp9wHPp8pUt/JlfvgqKNutQc5omfHZi850OsCe3r/pLAIHNXWMRJdvFMa7BLHKsREwbVMDwsw19Kk8x5gZlN87edIQugIT6A7emr0sI+tAM3EP2YMfFbwu2Ima9S+yRbI/
 4swnQXLT
 021IT9/+tdE3iTyFAMArbGgCdIbuvkopUo0+QSGJy953LgD6VskHHSdYwU7miFRBC2qVQ6v40zfIlU1qLNhTgaYPZE95ecMBZfn6uvI9B5lNinnwak1Ehah7lmZkO3xir5Jb21pOzIbhe7l1kBDJVVD0pX+poGFXdQb3WazIx4JsfElP7ywxmx+bCfVEvopUrNQzszC26IoNAEb06NW2hA7iwxu7i41vdRAcKha2uHZFEZAyIfjeI70U6MSOIZSbemm77Mf7aSxdZIL+d06mwIq42v3AQMvck0ZYqgMBTdrEAfenKrvo5ZXiM1RVKAo/flCM0
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jan 12, 2026 at 02:23:00PM -0600, Pratik R. Sampat wrote:
> Transition memory to the shared state during a hot-remove operation so
> that it can be re-used by the hypervisor. This also applies when memory
> is intended to be hotplugged back in later, as those pages will need to
> be re-accepted after crossing the trust boundary.

Hm. What happens when we hot-remove memory that was there at the boot
and there's bitmap space for it?

Also, I'm not sure why it is needed. At least in TDX case, VMM can pull
the memory from under guest at any time without a warning. Coverting
memory to shared shouldn't make a difference as along as re-adding the
same GPA range triggers accept.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

