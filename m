Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3B276CA1013
	for <linux-mm@archiver.kernel.org>; Thu, 18 Sep 2025 16:18:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 807048E00FB; Thu, 18 Sep 2025 12:18:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7DF108E00F6; Thu, 18 Sep 2025 12:18:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6F4A18E00FB; Thu, 18 Sep 2025 12:18:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5F68F8E00F6
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 12:18:58 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E65AF140290
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 16:18:57 +0000 (UTC)
X-FDA: 83902879914.01.FC582F7
Received: from fout-a1-smtp.messagingengine.com (fout-a1-smtp.messagingengine.com [103.168.172.144])
	by imf08.hostedemail.com (Postfix) with ESMTP id 90DF6160003
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 16:18:55 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=arndb.de header.s=fm1 header.b=hT3UzSYH;
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b="n arD2ch";
	spf=pass (imf08.hostedemail.com: domain of arnd@arndb.de designates 103.168.172.144 as permitted sender) smtp.mailfrom=arnd@arndb.de;
	dmarc=pass (policy=none) header.from=arndb.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758212335;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fm4R8b6atPDjgItmLn3c75WIBp5VlWzcsZH4FVIt7ag=;
	b=dxioDEplhqtwcC29aeS295VvGmylFltVq0OJ+LHhs1wv9IjXtcBYgwA+JS33VGpOgewn2M
	IWo+Kt03kSq8rguxkBkdwIjrQNCKhNkDCxmrqywWumXZBsmtjrJR+ELRrMPz1ZS0oHSZdM
	Rrn8UoyUBcXLmUq+yWfS6VC8RvdHzfQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758212335; a=rsa-sha256;
	cv=none;
	b=37yJT5eYCxd+yEnWDDvF6ogk4ZhpHbIIMgNTEXLRqQrov54TWbwmu/muvGab/EFxvuu/Kt
	DiO3KN9WN5RrBBGTkB+JCSKEGSy0WKmnJrJS9yBCqH78pR/TvGRV/Xyo/GpjJNqHfO56m2
	u/QgV7Ise0P+upWjM1xqDGeszH25n68=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=arndb.de header.s=fm1 header.b=hT3UzSYH;
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b="n arD2ch";
	spf=pass (imf08.hostedemail.com: domain of arnd@arndb.de designates 103.168.172.144 as permitted sender) smtp.mailfrom=arnd@arndb.de;
	dmarc=pass (policy=none) header.from=arndb.de
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailfout.phl.internal (Postfix) with ESMTP id E9DB1EC030E;
	Thu, 18 Sep 2025 12:18:54 -0400 (EDT)
Received: from phl-imap-02 ([10.202.2.81])
  by phl-compute-05.internal (MEProxy); Thu, 18 Sep 2025 12:18:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm1; t=1758212334;
	 x=1758298734; bh=fm4R8b6atPDjgItmLn3c75WIBp5VlWzcsZH4FVIt7ag=; b=
	hT3UzSYHqECruml9nJYhLaF2PeApMfKPsa2Kchq0gCzfeBYX32RBViapVaUovlLI
	Txe/jjqieezrzrzA7uJYsDtvqVjCXXnC1LoBBhdcmSoOMaSrN5Fqt+5RD4WlTS+u
	BKhECFDp11UJ471uauSho7G4oGR/BvOy/5lMipcEoJKhdbXiTwla7TTe3MuQrnYQ
	KueeBTCWfI8OcXJS2UG9kae6uVbtlAF7CcZVk2LQ2vS/xIuZHiD0Lp9ICyNHy82r
	40M21sNMmpSgYWUZzCPqKroJovjjCGbk7bJ6mlDgjqwo5fwELH5lepoBABDtgS9L
	scjCSBoybymPnkbUAktH5Q==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1758212334; x=
	1758298734; bh=fm4R8b6atPDjgItmLn3c75WIBp5VlWzcsZH4FVIt7ag=; b=n
	arD2chK72CMw+3XE4ZMyHoCXIAodtWOlFh+lygozTruGzTZh8h856redrTp47dRO
	sXbFqPqDBwTwab9JjkqMOZqEpw8xcAx1CsSrhxGH9ZhJahklo+5B/YYA8F9qKGuK
	wms91Otr8e2xctRFqgvVzfrtq2c8xTnxS+u/pW8oiV7Qo/b/JpZmiOHUmjZVqgw/
	j7EXQHPtj5+QrGpRsg0kWk6VvAUAduP/2DL/i1mtAsRcQBIRbZU3Rh1twx82usbv
	RgntitcMyx+XgxmuyvLSSVKNtRoybAgMqWlWzYvwXSnU7WaKl8QejTpIg2kBSi6W
	CaYxaV9Q1r98Co569m6Gg==
X-ME-Sender: <xms:7TDMaNodCGNeyIp-SBSrJ_TtgdGNi08_RHKQYU5GUMzQyGU2qL51sw>
    <xme:7TDMaPqtNE5Wm9OwOTBTVsoBpq7nOqMcCYUvpQ-AcC442Pi0J8C_IlqeLqpTVtfET
    Z4yar8_IO-zzD-k2lw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdeggdegieejlecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjug
    hrpefoggffhffvvefkjghfufgtgfesthejredtredttdenucfhrhhomhepfdetrhhnugcu
    uegvrhhgmhgrnhhnfdcuoegrrhhnugesrghrnhgusgdruggvqeenucggtffrrghtthgvrh
    hnpeeggfejudejvdeijeeglefgtdfhudffieetfedugefhffekjeefhedtjeefjeetfeen
    ucffohhmrghinhepghhithhhuhgsrdgtohhmnecuvehluhhsthgvrhfuihiivgeptdenuc
    frrghrrghmpehmrghilhhfrhhomheprghrnhgusegrrhhnuggsrdguvgdpnhgspghrtghp
    thhtohepfedtpdhmohguvgepshhmthhpohhuthdprhgtphhtthhopegthhgvshhtvghrrd
    grrdhunhgrlhesrghrihhntgelrdgtohhmpdhrtghpthhtoheptghhrhhishhtohhphhgv
    rdhlvghrohihsegtshhgrhhouhhprdgvuhdprhgtphhtthhopegrnhgurhgvrghssehgrg
    hishhlvghrrdgtohhmpdhrtghpthhtohepghgvvghrthdorhgvnhgvshgrshesghhlihgu
    vghrrdgsvgdprhgtphhtthhopegrlhgvgigrnhguvghrrdhsvhgvrhgulhhinhesghhmrg
    hilhdrtghomhdprhgtphhtthhopehsvghrghhiohdrphgrrhgrtghuvghllhhoshesghhm
    rghilhdrtghomhdprhgtphhtthhopehsuhhrvghnsgesghhoohhglhgvrdgtohhmpdhrtg
    hpthhtohepfihilhhlhiesihhnfhhrrgguvggrugdrohhrghdprhgtphhtthhopehirhgr
    rdifvghinhihsehinhhtvghlrdgtohhm
X-ME-Proxy: <xmx:7TDMaPbKt2WoXqHMwpanytM6BOnhzj_CQNwGh1PFIqubtDAyu5jB5Q>
    <xmx:7TDMaGKxNLlBIr_WiBflz4DJZ5ui2U4YOwVgSsgJGQrpphOVta5LLQ>
    <xmx:7TDMaG8COQwGxvO3AW0IJmLokZHWS06CKK-GHPM5ep7McMCa1__b0A>
    <xmx:7TDMaNp9nu7518TclPj1lZvDtvnU_ezCWZtqceFpg9Flbxum44e-lg>
    <xmx:7jDMaKcwFz32-9rZOzFDRZfXWP5Uej9dboxG4Bi3HNtAfR6kH7cYV8fc>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id 7D7F370006D; Thu, 18 Sep 2025 12:18:53 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
MIME-Version: 1.0
X-ThreadId: AneuvEk2E7Kg
Date: Thu, 18 Sep 2025 18:18:13 +0200
From: "Arnd Bergmann" <arnd@arndb.de>
To: "Andrew Lunn" <andrew@lunn.ch>
Cc: "Jason Gunthorpe" <jgg@nvidia.com>, ksummit@lists.linux.dev,
 linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 linuxppc-dev@lists.ozlabs.org, linux-mips@vger.kernel.org,
 linux-mm@kvack.org, imx@lists.linux.dev,
 "Christophe Leroy" <christophe.leroy@csgroup.eu>,
 "Richard Weinberger" <richard@nod.at>,
 "Lucas Stach" <l.stach@pengutronix.de>,
 "Linus Walleij" <linus.walleij@linaro.org>,
 "Geert Uytterhoeven" <geert+renesas@glider.be>,
 "Ankur Arora" <ankur.a.arora@oracle.com>,
 "David Hildenbrand" <david@redhat.com>,
 "Mike Rapoport" <rppt@kernel.org>,
 "Lorenzo Stoakes" <lorenzo.stoakes@oracle.com>,
 "Matthew Wilcox" <willy@infradead.org>,
 "Andrew Morton" <akpm@linux-foundation.org>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 "Vlastimil Babka" <vbabka@suse.cz>,
 "Suren Baghdasaryan" <surenb@google.com>,
 "Ira Weiny" <ira.weiny@intel.com>, "Nishanth Menon" <nm@ti.com>,
 =?UTF-8?Q?Heiko_St=C3=BCbner?= <heiko@sntech.de>,
 "Alexander Sverdlin" <alexander.sverdlin@gmail.com>,
 "Chester A. Unal" <chester.a.unal@arinc9.com>,
 "Sergio Paracuellos" <sergio.paracuellos@gmail.com>,
 "Andreas Larsson" <andreas@gaisler.com>
Message-Id: <ea6562f4-ec8c-4e99-98ec-000c25c34a3e@app.fastmail.com>
In-Reply-To: <ca6fc8dc-d1ee-41a8-a1c9-11ed2907207f@lunn.ch>
References: <4ff89b72-03ff-4447-9d21-dd6a5fe1550f@app.fastmail.com>
 <20250917125951.GA1390993@nvidia.com>
 <02b0f383-1c43-4eeb-a76f-830c2970b833@app.fastmail.com>
 <ca6fc8dc-d1ee-41a8-a1c9-11ed2907207f@lunn.ch>
Subject: Re: [TECH TOPIC] Reaching consensus on CONFIG_HIGHMEM phaseout
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
X-Stat-Signature: c5aic5e5m9a6pc9guc6f6zeunizybrhr
X-Rspamd-Queue-Id: 90DF6160003
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1758212335-557647
X-HE-Meta: U2FsdGVkX1/rQPAHHAz9dWd+OuhO1fiYO0vB36QVvGKukE0n2E1pOn4bSP09+q/47yUSRaxICHWGA4ZKNJQXmYIvhbDporOgg/JFxWFPpkqKCklYx4tPkNl16YorhdLCliZEwJrF0UFEC433kxsBoc+iKFDpH+xMvowL4zCIsrPMi2kq92/hgAiaDOOxXRKPN+GJ4kv/CbZo5M2232aF8mHcZRy+kPc9523OPBnDJf0DgWW9tAoKIgDTGnGzTV/aboBTEAOe+HOm8Zqu4kouOOi07OiGn0UJi8Ff0d5JOYSSs98WkkiwXI3YbOXzT1ONzPPntIQFwziuufVTFvqQS0cTAP7fYA+6ygQJCUUDT7HocFEakgXBG7EboX0ZnAwWqbf4KaTfPzOJt2ZKjvbVulFWQvUZYBmK0e8zSHp4JbkBzuLYnPkhUS/3UKX1zio9YBw3WOw3S3gnRByb1YpJFsrbPgjinevPQHMv7RxriPyEMHhifTXhVElHp7QJIMzU0ecSFjzNL7RFm3lJLxXoTxpb48ZXeesKYGx1G0f7ioK1CgsKJKTQLl/+6KpNSX/txgKHpcF+Z+4wSPmnsyvbIm4RGhafgGYiByC53/s4NplX5F4RP5mFGgOFeQC3WqkwfYxMLXy4zqwQRUn5KDdv9Xora4dd/SLynYW19CjdpjxPtDufcdKg7bNQgXhl262wtnBhlVRry8TqpgOGh0dMDaAPWZaDwNatTFNfbeJeJXdODmAGeLA3U8wwasFwkrqjlVpaNYEeYs3g+w2mDvEFsdjml0HECQUq3jB8ii89TTsCr5OybaA89biVoABavn4jHmdd5qfuaCwDlslgvI9GVd4idlOsON0G8vEiYCB13rpSFol0ABAe6p+q/7Q7z3mVnv26PEydf7zBmtKhLVw4ON+z6VVN8cHolqZUjkqRILrMnvoqWmdHVXePb7dYD7JW4Lj+ZqwELwgfg2y1LpS
 FXetJvfi
 bYykT8xc2zNpghz/AJOAXQ/dWhTr5ld9PjvdqqNb9osFkkOpFlvnSYL+rdzPdi7xreQExCOBs0VG5HBKcNBoODGyW6NHL3qAs22H0Gx/LlG9xuCbmCPuxJhYx+KZewaIVfKnv3pIC5s1iUVLTRCkvVFa3dAypB8GgT6IsbpeZ9MdOs1VVG5CAGtEX9oRkqxbYJYdiRkD7xkKquqUfC9buT0968AF7/StCFsQ5rNkb0vYz7DHE3KrvOauL9HTWQ0+e/3sRlhJ0okH3/6QDMKrUzsXnj5Axenv3D1cAoyeVZiDrKFT1ppC+T7QYdWJ7cxssrkYeYrbCVYuz4KQKMukVKat4Yg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 18, 2025, at 15:34, Andrew Lunn wrote:
>> * Marvell mv78xx0 and kirkwood (armv5 pj1) were fairly
>>   powerful in 2008 and could support at least 1GB of RAM,
>>   but I only found one machine (OpenBlocks A7) that does
>>   this. It's unclear if anyone is still updating kernels
>>   on this machine, but they could /probably/ use
>>   VMSPLIT_3G_OPT if they do.
>
> If i remember correctly, there was a design issue with the OpenBlocks
> A7, and it would not run with its full amount of memory. To get a
> stable system you had to limit the RAM. I don't remember if that was
> just with the NULL series, and it was fixed for mass production
> devices, or they are all broken.

It's possible that the bug is in the exact bit of code that
Jason was suggesting to have removed, if this was the last
ARMv5 machine that actually tried to use highmem.

> I doubt there are any mv78xx0 machines left, why where never very
> popular, but there are still Kirkwood NAS boxes around.

https://github.com/1000001101000/Debian_on_Buffalo does support
some variations of the Terastation Duo, and they were planning
to do a DT conversion at some point, but I think there is not
much hope of that ever happening now that Debian armel has had
its last release, and I expect we can drop the entire platform
soon.

The reference system for mv78xx0 of course was the platform
that Nico used for implementing highmem on, with a full 2GB
of RAM. I think in the end this was around the same time
as dove and then armada xp.

> I keep mine up to date, put an LTS kernel on it once a year,
> update to the latest debian sid.

Do you know of any kirkwood machines beside the OpenBlocks A7
that have more than 512MB of RAM?

    Arnd

