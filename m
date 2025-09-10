Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 19A02CA0FED
	for <linux-mm@archiver.kernel.org>; Wed, 10 Sep 2025 15:14:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4CBE56B0010; Wed, 10 Sep 2025 11:14:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 47CAD8E0011; Wed, 10 Sep 2025 11:14:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2F64E6B0024; Wed, 10 Sep 2025 11:14:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 1D7126B0010
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 11:14:23 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id CB6515BC87
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 15:14:22 +0000 (UTC)
X-FDA: 83873686764.30.A8ABA9F
Received: from fhigh-a8-smtp.messagingengine.com (fhigh-a8-smtp.messagingengine.com [103.168.172.159])
	by imf27.hostedemail.com (Postfix) with ESMTP id 8F17340007
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 15:14:20 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=arndb.de header.s=fm3 header.b=Wt3vFLdg;
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b="H /gMzN7";
	spf=pass (imf27.hostedemail.com: domain of arnd@arndb.de designates 103.168.172.159 as permitted sender) smtp.mailfrom=arnd@arndb.de;
	dmarc=pass (policy=none) header.from=arndb.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757517260;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lsUUzVSssKb2ZuGuZgzggTzESfnxgxP19f0NGhCBk2A=;
	b=rpJoQETO2y5YGkmOhWpUgtyLtAEDn0wxGHNqYIYdcYp07jSF0CDvZcRPZHzhPpU+30NpPv
	z6OE/ss6CANXQ1qMOjXBZAgSoCbDjxvR8XEq5ii3EV+5SKQWIhWahWPiSmpFM00CPYGu1p
	f1Z9N3iORaN2FmkxfujcS2ywRqA5gAQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757517260; a=rsa-sha256;
	cv=none;
	b=CExIsMJdpsT25HuuC1dokqaxDuddcryEUSVhT1VtxrDu1o+QMPUGIAWA6UnC/iA1TQWmf0
	7ITUWAFVhP5NcNMZl1DoBTcNIIGNKmp9KJTS106yn/5sTDMwhLBQ/1vnj22NmSkX01At5Z
	Qvp8QLGSoOTdVCGbmU4aCgCxIq/sbpw=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=arndb.de header.s=fm3 header.b=Wt3vFLdg;
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b="H /gMzN7";
	spf=pass (imf27.hostedemail.com: domain of arnd@arndb.de designates 103.168.172.159 as permitted sender) smtp.mailfrom=arnd@arndb.de;
	dmarc=pass (policy=none) header.from=arndb.de
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailfhigh.phl.internal (Postfix) with ESMTP id C49A01400375;
	Wed, 10 Sep 2025 11:14:19 -0400 (EDT)
Received: from phl-imap-02 ([10.202.2.81])
  by phl-compute-05.internal (MEProxy); Wed, 10 Sep 2025 11:14:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm3; t=1757517259;
	 x=1757603659; bh=lsUUzVSssKb2ZuGuZgzggTzESfnxgxP19f0NGhCBk2A=; b=
	Wt3vFLdgaWOIw3mFFTO8HkI+FL3aLrAvk1XZkFPK029w4p9kIsmeNNXR2doMLfc2
	NQaimD6tWSMhyd9vrBwpPql7GPen65eFUN6bOfqTcjaYKQTvFwR3Tilc07C6ExJ8
	jmxdK+IoR3hnYmXzQTnYg/t2INRTwDKScAAC5Zh97EJg6FK42wOtjxbJQG0rbqtx
	vb435sW48hCiGaDmkSb48ej0GWsn5+SI3ezoINWNC9Mi29MHlc2MYgDudDq3vQpI
	E3JHV5FX9Je89nP69A4JyLOdFZEUPLOsF/5GLJ2vjV5NifsecRQsRhBZHOY5Wy9x
	jt6rDjYilo0TVNJQvnJkTg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1757517259; x=
	1757603659; bh=lsUUzVSssKb2ZuGuZgzggTzESfnxgxP19f0NGhCBk2A=; b=H
	/gMzN7TnwJd0vg/MTYVl/pyoe/hmyfwJF4mtR5JWM0w21EGmDqzYq1IsTdotAh60
	Fmd1Vg+SdRbChBFHMrAKmV4sr5AgLPgZE/hNEG3iugSyvyKHaye+uflCyTVZE7eW
	y5OXjXOMEmKkObNDMRZmLutp1NrnRb+HXmB/4TDEu05TLasJXe4OYpexHWqlypFG
	f5UGmGv6/ug4tXqoJzn54aHwEZlvC1X/XhFICwEees+qOB1PMhCXSGFdzGOeVRCA
	AmHdT3PYzk6ROQA/RcaMy/7tVU36ZMliytCzRpQYn6smIPsw/Gu6lhjsbjgbm1PQ
	nnukP2hsdOVcW4iab733Q==
X-ME-Sender: <xms:yZXBaDXOlmIombO1szwOlmpXbQqLOdZRNKdHj8DHhLwnjgybvVtD3Q>
    <xme:yZXBaLmGS84fPQjmk21XEVQnEGpISmEP8_Uye0ca4ReQR3HPDWjwuZEIYxBFYNeqB
    zTGP6WvYL_gjS6k-qc>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdeggddvfeeivdcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjug
    hrpefoggffhffvvefkjghfufgtgfesthejredtredttdenucfhrhhomhepfdetrhhnugcu
    uegvrhhgmhgrnhhnfdcuoegrrhhnugesrghrnhgusgdruggvqeenucggtffrrghtthgvrh
    hnpefhtdfhvddtfeehudekteeggffghfejgeegteefgffgvedugeduveelvdekhfdvieen
    ucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegrrhhnug
    esrghrnhgusgdruggvpdhnsggprhgtphhtthhopedvkedpmhhouggvpehsmhhtphhouhht
    pdhrtghpthhtoheptghhvghsthgvrhdrrgdruhhnrghlsegrrhhinhgtledrtghomhdprh
    gtphhtthhopegthhhrihhsthhophhhvgdrlhgvrhhohiestghsghhrohhuphdrvghupdhr
    tghpthhtoheprghnughrvggrshesghgrihhslhgvrhdrtghomhdprhgtphhtthhopehgvg
    gvrhhtodhrvghnvghsrghssehglhhiuggvrhdrsggvpdhrtghpthhtoheprghlvgigrghn
    uggvrhdrshhvvghrughlihhnsehgmhgrihhlrdgtohhmpdhrtghpthhtohepshgvrhhgih
    hordhprghrrggtuhgvlhhlohhssehgmhgrihhlrdgtohhmpdhrtghpthhtohepshhurhgv
    nhgssehgohhoghhlvgdrtghomhdprhgtphhtthhopeifihhllhihsehinhhfrhgruggvrg
    gurdhorhhgpdhrtghpthhtohepihhrrgdrfigvihhnhiesihhnthgvlhdrtghomh
X-ME-Proxy: <xmx:yZXBaESgMqAfocAh5WwsNKvYXczfu7UTStKzoEZ_LOyYB88gFCsczQ>
    <xmx:ypXBaMq8oJRxVm5-KPXU3p6LapKK9VSGtugiiL7OXrTltECusc88CQ>
    <xmx:ypXBaCy-TVZZI6VvKyzbCn9-qbN6vjLZQvQ8eH7rWv4q8MqywpKQ7Q>
    <xmx:ypXBaPDeWwsS_0RafF3IO58JfOjBv4WASYIgwgXNH9S2I7eVRXv1Nw>
    <xmx:y5XBaNu8n69vsZmygvax3BlNn5O-QH6oHbeKtp693EevppGTS0Ykwx7j>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id D18B3700065; Wed, 10 Sep 2025 11:14:17 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
MIME-Version: 1.0
X-ThreadId: AmcCJOTBQ5ho
Date: Wed, 10 Sep 2025 17:13:57 +0200
From: "Arnd Bergmann" <arnd@arndb.de>
To: "Matthew Wilcox" <willy@infradead.org>,
 "Linus Walleij" <linus.walleij@linaro.org>
Cc: ksummit@lists.linux.dev, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, linuxppc-dev@lists.ozlabs.org,
 linux-mips@vger.kernel.org, linux-mm@kvack.org, imx@lists.linux.dev,
 "Christophe Leroy" <christophe.leroy@csgroup.eu>,
 "Richard Weinberger" <richard@nod.at>,
 "Lucas Stach" <l.stach@pengutronix.de>,
 "Geert Uytterhoeven" <geert+renesas@glider.be>,
 "Ankur Arora" <ankur.a.arora@oracle.com>,
 "David Hildenbrand" <david@redhat.com>,
 "Mike Rapoport" <rppt@kernel.org>,
 "Lorenzo Stoakes" <lorenzo.stoakes@oracle.com>,
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
Message-Id: <55cbc329-4b14-4f62-90bb-1e1007cc1152@app.fastmail.com>
In-Reply-To: <aMGFhuHyQwtwyF7B@casper.infradead.org>
References: <4ff89b72-03ff-4447-9d21-dd6a5fe1550f@app.fastmail.com>
 <CACRpkdb=E-_6fZ+4mX5FJas9C5Njp3Gwrygs-cAfWNdbP594cw@mail.gmail.com>
 <aMGFhuHyQwtwyF7B@casper.infradead.org>
Subject: Re: [TECH TOPIC] Reaching consensus on CONFIG_HIGHMEM phaseout
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 6rzzk4ypx4e6nszexhhpjgcmg43ruczb
X-Rspamd-Queue-Id: 8F17340007
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1757517260-168107
X-HE-Meta: U2FsdGVkX18AVTyvadp4Yx3Adql7r8FHhDTRZUEylSB2MWNimVQaB9a0P3xQIo46d08rityf/mie2dQRsTkFbHFl0Zrw4ogtzPiPbIu4ZG7O46RFWxtTBRDXXiYK5qzgnDsoDphy/t8Q/njZtvYP7FR2ZJm/fHjTEGvRnGO8mEwRvzylRDe/EAP76JC26wrJU0uWDuA78tkWXvzw/xqiPDQRczctrM00nSyadZDWxnsbyW0V+4lamVl79k7U+cr+VPWMnUzbKqF9xnqdvWC/KMEpU1/GmdrPEtdSCUXL3Z21RjXNnv92ZMFkuHPbbzUKN1GQ9UbtDev3dZ8MBFbAxLCKtIcDIFJaczm1pTEvPJmhICmCeAcc5a0ZSaja91nK2zib4FzLHH17mNOKjXSWiafK5dvkRAd+i0eyVWnfj3B2Y52jlnTm8Kk3Ya5/beNrhx4dAEn/9HPWNgFLaeX7ntp9sSD6JvpeTUzM21q+TzeR5cCIAsk7X9E07JHYeQbzWpiOEnWFZ0fP28j/h6vUj+BTq1su6cLSLYFTL7bbEyGg9A0l9zuX/Zh6Mst7ebi+S3pyFwm7KSqWhWl4PojLzKEYhLAUGO3xLi6NliPylZRcuDqw1g7kfFzvJU1/SvWSP7yOsscOIerDhAYJJoRrgYvcXK3pXqaHa0Bj871IJeRxYgLeP5H5umMPMS1z2KFXykzsjhCj9I6L+do1sQx79Dv7gxsbYiuZBto7RSlNT3IKBZmCMPiBHWqaC3UT9t52CRyETvCXfbkeo+UdL01qeRaT/ON/8jiyhjlPYYgLvxuIjnYQWT1/aD4SURaxgS29ltT0g2HQLwvf4ALXs7l7lVi10A9DxmeXIqlxIK1IO56bkQh19qjCWINtu0EHVVuZ4FqY4RYjYHVH/TTqCGzvZ0a9xEWUlTXlmjNhf4JZFxn0dbvkAKhJ8NCp8FOfhxikMSmgySC/CGgNc0T3C70
 ifgyxpgM
 iIXPmEG/gpKBphsMtlx7Cdl2x//g7kpuAqpUf8TwyaMf27fXgjzLcOjMrcA6gBj9PpmF4czHZicRpZoQ8RfSE4Qd4I1r0JyAXbRoQKz3PEPJFSxrVLrB4ZOdfU5o8dAPZaStHBl284CgVxgMmi4/DGkGOMulR5RKCe/+Pc1NP5nUyc6wtVn0opQoZUkfcTnb59IM8WwkVuWrbVTTz+g6fIL4hmZPU4crDuij40mzwN/0Se0cmGYLoCTbZhKvMe2xlzgeYAjXWS9UElxJIAgwtfwbrmZTzsiDPvorJ0D2yWRf3qeGONlyyuOn9mh/K8DWVE9l+0F/FPmtBUT3tCcOCIJRRVg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 10, 2025, at 16:04, Matthew Wilcox wrote:
> On Wed, Sep 10, 2025 at 03:10:05PM +0200, Linus Walleij wrote:
>> 
>> This in practice means the area 0xf1000000-0xffffffff
>> which also includes the high exception vectors that must for
>> natural reasons also be kept in the mapping.
>> What we have mapped today (all of the time) is
>> 0xc0000000-0xffffffff.
>> 
>> A minimal 256 MB mapping from 0xf0000000-0xffffffff
>> should be able to cover this.
>
> Can I ask where the MMIO (PCI?) window lives?

That 256MB area is shared by anything the kernel can access
directly, other than the linear map: vmlinux, modules, vmalloc,
ioremap, vmap-stack, etc.

This is mostly unchanged from the tradtitional layout on
arm32 that has the same ~256MB limitation, though it does
get a little tighter because .text/.data is now also
mapped into this space instead of executed from the linear
map.

      ARnd

