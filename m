Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EF2EDCA0FE1
	for <linux-mm@archiver.kernel.org>; Fri, 22 Aug 2025 11:04:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 29D54280018; Fri, 22 Aug 2025 07:04:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 254188E009D; Fri, 22 Aug 2025 07:04:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 13D15280018; Fri, 22 Aug 2025 07:04:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id F30598E009D
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 07:04:35 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 852435051D
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 11:04:35 +0000 (UTC)
X-FDA: 83804110110.07.A35BC91
Received: from fout-a5-smtp.messagingengine.com (fout-a5-smtp.messagingengine.com [103.168.172.148])
	by imf07.hostedemail.com (Postfix) with ESMTP id 697E74000E
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 11:04:33 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=arndb.de header.s=fm3 header.b=odUmb+Dh;
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b="K U95G1j";
	spf=pass (imf07.hostedemail.com: domain of arnd@arndb.de designates 103.168.172.148 as permitted sender) smtp.mailfrom=arnd@arndb.de;
	dmarc=pass (policy=none) header.from=arndb.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755860673;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EmIUXF86YcQrT/8Hjt3QbuzJX9flVj+2OUQWxZuGrsA=;
	b=K8gtnI9ZNmIBuY3/4wUGLqe+8H2PSyjki5yjwSebvELuiTmoHzTVwR8+lwK+/xtPZPc31h
	7UH3Tvez257OaM1jQG3iep+LcJ2pyO+06mIPjOUnoOTk8K5mvHHra4KrtbBwJBTsvoh3Uy
	3GNJuNu7AHUYrmlTi/sXg8xX973bibw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755860673; a=rsa-sha256;
	cv=none;
	b=j2AiVF6zVqmNYCc+/B7VaY2sxRxemAE+lYZigDo+rIqNePUvGmAmHW5GeoshAfW2dQeljp
	amqGDxSTs6Fr8hjynIl61ONBB/NFqNSXi+qFgxw+UrF++hwWOto7ouElyQKzb43KBfbrK6
	kAw+tL92k9IEoyO3Nl7Tq9FQufyWQSc=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=arndb.de header.s=fm3 header.b=odUmb+Dh;
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b="K U95G1j";
	spf=pass (imf07.hostedemail.com: domain of arnd@arndb.de designates 103.168.172.148 as permitted sender) smtp.mailfrom=arnd@arndb.de;
	dmarc=pass (policy=none) header.from=arndb.de
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailfout.phl.internal (Postfix) with ESMTP id 9B610EC094A;
	Fri, 22 Aug 2025 07:04:32 -0400 (EDT)
Received: from phl-imap-02 ([10.202.2.81])
  by phl-compute-05.internal (MEProxy); Fri, 22 Aug 2025 07:04:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm3; t=1755860672;
	 x=1755947072; bh=EmIUXF86YcQrT/8Hjt3QbuzJX9flVj+2OUQWxZuGrsA=; b=
	odUmb+Dhs2VS+C0GwK2Ch9U8/U+xpZXk1XEC70+Pntyibd0lIeB3x/gd8oJvPXwG
	YgevcwC9PI508ReOCtMEICnlU4SXrEhUnjnXKk3+z4bcAmQruNw1OgQh4p4CAS3S
	4Xb1TzLfmsJalz9uLwr7mW0nOaThYwVP71wk35FFZoKp2xJ0qC0tH61vH82IxgeU
	ZOLoRPaYu2rxK7EXSqZqL+fD/ShYJgmH5HHfVuuVJPAxoBAutW1qccZauYzy5K1F
	OJYFdy2XIvXbwwHuWBSIXzmjfct07GWObWngqXE1J4cvUlIjZUIXKMUK/wZivDmA
	e45M3OXji1uFq2EjDiCT6A==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1755860672; x=
	1755947072; bh=EmIUXF86YcQrT/8Hjt3QbuzJX9flVj+2OUQWxZuGrsA=; b=K
	U95G1jFCCKMtIbaULGb03C3x0nNYBZLl0OKd5hGWgty9sCojBaXVdHCY4zjAAzu+
	Qk96cUJD9qC5NMl/vmVtmjwo/eVIKotjlQz1ojto2zHrFjR+Wv8pw2frgi+N3CNT
	xU5alI15wx5w6snF8O1Hri+KycM+mpeMbzpS87Ry2XkGgA2eUxlRcSQ1XCUzsrBx
	GdhbmM83vHx67ni5xSfARaWVgMRVUQAo5ca4vGVW2JcTHX89tfxaPson4e7BZtR2
	wTbld3+yrZAARJPLsyFAC6RxwEb0uOJBuDmbi9twMA5aWCY2jF1JniKggZLJ+KuD
	ERPfn9HHKUzkHNlpjOW5w==
X-ME-Sender: <xms:v06oaFnNY0cUdO21P-9Ma-qjweXgKLB1f11vK-G-5Ntc_Ex8ubiFkg>
    <xme:v06oaA2B_tMUHaiSYJQWnmGgLvoZoqfNiSC_gGssewMw5d-gdxRTWgwQ8k5RKcPcT
    FO2jXE9aBT28NsXIbg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdefgdduieefheelucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepofggfffhvfevkfgjfhfutgfgsehtjeertdertddtnecuhfhrohhmpedftehrnhgu
    uceuvghrghhmrghnnhdfuceorghrnhgusegrrhhnuggsrdguvgeqnecuggftrfgrthhtvg
    hrnhephfdthfdvtdefhedukeetgefggffhjeeggeetfefggfevudegudevledvkefhvdei
    necuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomheprghrnh
    gusegrrhhnuggsrdguvgdpnhgspghrtghpthhtohepvdefpdhmohguvgepshhmthhpohhu
    thdprhgtphhtthhopeguihgvthhmrghrrdgvghhgvghmrghnnhesrghrmhdrtghomhdprh
    gtphhtthhopehrohhsthgvughtsehgohhoughmihhsrdhorhhgpdhrtghpthhtohepsghs
    vghgrghllhesghhoohhglhgvrdgtohhmpdhrtghpthhtohepshhurhgvnhgssehgohhogh
    hlvgdrtghomhdprhgtphhtthhopehpvghtvghriiesihhnfhhrrgguvggrugdrohhrghdp
    rhgtphhtthhopegsrhgruhhnvghrsehkvghrnhgvlhdrohhrghdprhgtphhtthhopeguih
    hnghhuhigvnheskhgvrhhnvghlrdhorhhgpdhrtghpthhtohepkhgvvghssehkvghrnhgv
    lhdrohhrghdprhgtphhtthhopehrphhptheskhgvrhhnvghlrdhorhhg
X-ME-Proxy: <xmx:v06oaNv2vkg4FQGapO3c_YHhofNvxfTuo2zOGcxqE8zhNZZ5hUhLMA>
    <xmx:v06oaOFVs_4iy7m3Hm_AH6WQFEniE3zbrPKmWXN-rnPMqYcQK84n5Q>
    <xmx:v06oaA--uPBA6Mm7vI9kW8ii1lE_kAUxJZfMwjbVIxXelxhZLXRtoQ>
    <xmx:v06oaMNLABhtZ6b6BCWK356wtaSiXa9MyR_NbR8VWIJAcNyvbz8HTQ>
    <xmx:wE6oaNXuCP0_6qmIwJ5SSu4OWGFSmgyfWKLLtMXkQCYYsBHfyGfofuT9>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id 385FB700069; Fri, 22 Aug 2025 07:04:31 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
MIME-Version: 1.0
X-ThreadId: AVsTuni0f5VB
Date: Fri, 22 Aug 2025 13:03:50 +0200
From: "Arnd Bergmann" <arnd@arndb.de>
To: "schuster.simon@siemens-energy.com" <schuster.simon@siemens-energy.com>,
 "David Hildenbrand" <david@redhat.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "Dinh Nguyen" <dinguyen@kernel.org>,
 "Christian Brauner" <brauner@kernel.org>,
 "Andrew Morton" <akpm@linux-foundation.org>,
 "Lorenzo Stoakes" <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 "Vlastimil Babka" <vbabka@suse.cz>, "Mike Rapoport" <rppt@kernel.org>,
 "Suren Baghdasaryan" <surenb@google.com>, "Michal Hocko" <mhocko@suse.com>,
 "Ingo Molnar" <mingo@redhat.com>, "Peter Zijlstra" <peterz@infradead.org>,
 "Juri Lelli" <juri.lelli@redhat.com>,
 "Vincent Guittot" <vincent.guittot@linaro.org>,
 "Dietmar Eggemann" <dietmar.eggemann@arm.com>,
 "Steven Rostedt" <rostedt@goodmis.org>,
 "Benjamin Segall" <bsegall@google.com>, "Mel Gorman" <mgorman@suse.de>,
 "Valentin Schneider" <vschneid@redhat.com>, "Kees Cook" <kees@kernel.org>
Message-Id: <1e9f9975-7be0-4abf-87c6-a8f54cd9d059@app.fastmail.com>
In-Reply-To: 
 <FR2P281MB15445D806CF865A0E1CD8FFCB53DA@FR2P281MB1544.DEUP281.PROD.OUTLOOK.COM>
References: 
 <20250821-nios2-implement-clone3-v1-0-1bb24017376a@siemens-energy.com>
 <20250821-nios2-implement-clone3-v1-1-1bb24017376a@siemens-energy.com>
 <8c6239a9-8414-469c-9b94-a43735b4e882@redhat.com>
 <FR2P281MB15445D806CF865A0E1CD8FFCB53DA@FR2P281MB1544.DEUP281.PROD.OUTLOOK.COM>
Subject: Re: [PATCH 1/2] copy_process: Handle architectures where sizeof(unsigned long)
 < sizeof(u64)
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 697E74000E
X-Stat-Signature: 15esd758qixih4pnopsamam1ue5pxeey
X-HE-Tag: 1755860673-551575
X-HE-Meta: U2FsdGVkX1/GSrBE9GriOaiv6iFokWEZXHb2wm2+VcHpZDPpvFTV3FvBYAvajfDQvGaCnADMWsn2q7DgOSrezNxcBlHDjNZvHBWYuSgF5dpJtVnz7uO3uKFpDQorDRxlaMsmO45xnInMew7LWU3Oqn1F/OnvOOb0gdlVcMsiksV+dMbBbGQ/sstGgXRsX/qr6M1ZJQkawejl2+5XpyqNNebQxSLp5PmhuRQBWp2qUnANp9nGhdQ0OerXXqEGMljzrwcYgK2vp+6M617Pmy4HUsN4MZ9Aa9GGPfFyydMsyXiss1fYPzXi4wdrQtTqIm8UstVf4O/W2JrZItNCv7978SOBs855xoXHEI2WzjFKTPiYePqfVHiNr6g8qJAzhNiBAhN3NEo8UF+/sLwx82WwyZvyfsvZ/8FfsDqjXp+RxK9RYEWkT87/5Q5jRyRMHBphnM9pRvKmxhcPq76U0jCXVIcooPBqmHU1wP32pJNEuwQUO5tmLzFXhBqtjoVqpEotS8P5Wy0i8edmW1E1GY/EFCi3Lj+7ELQn1LVBRbROrGW+9GUHV7c+NEGJDoNbjHhDPOc6grv+iZ4wYMgCgT9ELM2QH79Ap3pLvS6ShaXXN3dxTIvNP5hbeGz2rA5kvnxw3RXb5QUdGqVIMvLSDj62Bu+VBrTPtvQw38X/3ns+TRTFeLtwLa2PTScp7/7p+9wRMAFdTX5B3qmVlduAYFiqc0Ux+XvYqVMW31BCom99QF1o0Eqtr6Uw6QR5r4Ntx2gyih8+AfQM6aIX8H/aGFtBDONvsyoWq8avjuA8FYL4PjnIhzv/qXd40Sizk7DMUjsRrnztfd6vGB3/5LmoBsTNP3LLnlbf1z5Lz8cQuyPo9SOM7wwQgqXBXpI7AidoWWw4Ip2l7576JM7DATv56sL/eO349t31knz6xY6FeUT6okGXVTL0pG8Gfll+Nj8Y9+y9+GDSBpnsyWYS9vTDmf1
 brDbuX4u
 mKlhjIg6tfwVaDobsJDf/nreb1aGIgKzgW+knAknFCOMAg79dONuSeg1sSnPZuZdpTA8pC8EqJzdiBbPsJF18Z7NM7SrD5nhj5ZwoLbsfHDXmXMLoPR9vcrx6Q9w0l0+C/rADpotAnsCRXg/Xa8WJB/eL/qoMUrWL3XWQ6MUWJmHt4fZ8rUklAfB4onkmVB/JbuMozXNhpQnmUaww41pIj4TdrhttUhO2tlijYlP6oGSX40OT3Ti4svuZP5ljAtltvCKS0lo6AyLNUaHHCaNDM5fG8MwYKVJi97aUzH/XLcnoqwSedCdMZJ/oeChCQ6yrLZXpKNDg/fpYp9qzHT9wocXlOVnqU7OEII00
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 22, 2025, at 10:52, schuster.simon@siemens-energy.com wrote:
> On Thu, Aug 21, 2025 at 11:14:00PM +0200, David Hildenbrand wrote:
>> Sounds reasonable.
>>
>> But is this actually something that is already exposed before patch#2
>> on other architectures?
>
> I'm not sure, but I would assume so, as e.g., arch/arm seems to have
> support for clone3, but also seems to use 32bit unsigned longs as far as
> I can tell and, thus, should also be affected:

Correct. 'unsigned long' is always the native word size for an ISA
on architectures that Linux runs on, and the same size as a pointer,
so the bug affects all 32-bit architectures that have clone3:

arc, arm, csky, m68k, microblaze, mips32, openrisc, parisc32,
powerpc32, riscv32, x86-32 and xtensa.

However, since the ABI itself is fine and 64-bit kernels pass the
value as native words internally, the 'compat' mode support on
arm/mips/ parisc/powerpc/riscv/s390/x86 does not have the same
problem, and running the same 32-bit executable on a 64-bit kernel
should work fine. This may explain why nobody caught this so far,
even when they were testing the new flags with x86-32 or arm32
userland, but using 64-bit machines.

>> (I assume above output is with patch #2 but without patch #1)
>
> Yes, sorry, that one is on me; I've naturally first implemented support
> for clone3 on nios2 and then investigated the test failures, but somehow
> deemed it wise for whatever reason to switch the commit order in the
> patch submission...

The order you picked is fine: we generally want bug fixes before
new features to allow backporting them more easily. Please add

Fixes: b612e5df4587 ("clone3: add CLONE_CLEAR_SIGHAND")
Cc: stable@vger.kernel.org # linux-5.5+

above your Signed-off-by for this patch, to ensure the fix gets
picked up. I would also suggest changing the text to not mention
nios2 specifically but just say that it affects "all 32-bit kernels".

    Arnd

