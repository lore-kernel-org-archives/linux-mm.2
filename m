Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 478D4CAC582
	for <linux-mm@archiver.kernel.org>; Fri, 12 Sep 2025 10:18:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A5C496B0027; Fri, 12 Sep 2025 06:18:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A33A06B0029; Fri, 12 Sep 2025 06:18:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9496F6B00AC; Fri, 12 Sep 2025 06:18:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 8512D6B0027
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 06:18:06 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 3765411ABCC
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 10:18:06 +0000 (UTC)
X-FDA: 83880197772.25.1A5D7DC
Received: from fout-b1-smtp.messagingengine.com (fout-b1-smtp.messagingengine.com [202.12.124.144])
	by imf27.hostedemail.com (Postfix) with ESMTP id 439C940005
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 10:18:04 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=arndb.de header.s=fm3 header.b=MkTTGqz5;
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b="B q3IzD3";
	spf=pass (imf27.hostedemail.com: domain of arnd@arndb.de designates 202.12.124.144 as permitted sender) smtp.mailfrom=arnd@arndb.de;
	dmarc=pass (policy=none) header.from=arndb.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757672284;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9YTVFTqv3esr6/4o2z0BMROL8ZzR/twbyPKp7dOgQ8c=;
	b=2Zj47gPs9SuuXfwgvhUFmnW/MISziQC88QTM4qY0wAAPE+CG6F9qULKl9Vfc14aWFuZ5lm
	KqNdGF03EHZjgP858ppQRbv118DCx+tdvr5cFZD5ssYxyxyQ2frvLUFA70Bcm6NtakaTmr
	6cHQc6eNZxDomNZ1gMs6Wopr6A+a2os=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=arndb.de header.s=fm3 header.b=MkTTGqz5;
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b="B q3IzD3";
	spf=pass (imf27.hostedemail.com: domain of arnd@arndb.de designates 202.12.124.144 as permitted sender) smtp.mailfrom=arnd@arndb.de;
	dmarc=pass (policy=none) header.from=arndb.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757672284; a=rsa-sha256;
	cv=none;
	b=lTme4+W9Yme/YxtlIxp+76jr4aChuKbAjJEwEnB16xwYw6v3dIem7LjzUqoM3uWMQh/RWe
	pPEicK0DlOCiyYiNeAKtJN5Of+pr3d18GcUyn3CvvA+OR3eexfyZAAvM8z3qXBZIscDz8I
	DR7XyE8OpJ1adUjEZRQ/xCkZE0ITUTI=
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailfout.stl.internal (Postfix) with ESMTP id B472E1D00410;
	Fri, 12 Sep 2025 06:18:02 -0400 (EDT)
Received: from phl-imap-02 ([10.202.2.81])
  by phl-compute-05.internal (MEProxy); Fri, 12 Sep 2025 06:18:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm3; t=1757672282;
	 x=1757758682; bh=9YTVFTqv3esr6/4o2z0BMROL8ZzR/twbyPKp7dOgQ8c=; b=
	MkTTGqz582tMoXiaxv+WzOMeCUpK43NVEMy0S2ODRVT6sTC0DTo0bXB3GAv1vukK
	dJEC0SEQ1h46wMjlM0kgfqFGcTG77SIC41gzKic0kOGz3o8tsU3ZI5hbyTA4Y43x
	ohKbeayVJdnZPqj5V+ZrKqHCFhmkeEC+rgbi5TVJ9v7kqJ9DvvqO+MW1peFNO+aN
	mTGOCkN0mQA7/SxHODsqxDeHrU/CWbhSVvD98tPKm4aIz0VarFAl4Im3dVLMMG5a
	3o77/cyDl8VssAc4Bm2hiOmeweHDoNJNxytvsrCbvJoDBeOLvwXoe/Io4OCKMv3o
	IFLx/C3HuKRmZ3rVttd6tA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1757672282; x=
	1757758682; bh=9YTVFTqv3esr6/4o2z0BMROL8ZzR/twbyPKp7dOgQ8c=; b=B
	q3IzD3eNVHz5NfcgZdq/BAq7VPToJWFLvnE7NSgoDR5AJIuIqwb+T3keAu2cJZWY
	KkzHKH6eb7irC3elLVTowyLeB7wOwVeeV/uULPDUTpad6DkCRBwmlz+DF1TRJWKE
	HpaBmN8htE/95T8l/xUhANUYuPEdxZ4tehrOIIQvJbCE81x6NDbZo6UWl6uLMES/
	U11kHYWOB1W7hz9smWXW1HIBNmK10Mxhh5en6Rk3VV1qfc+axmcfLYoJ9h9Fw9ia
	xaoQbgf0e0mWOsExo1UxF/88Xe6B1qgFmYZ6MDtZiX7DVKI0GdE1TRG9X6KT5SW6
	PEaXJyDPEEospM9IHNmFA==
X-ME-Sender: <xms:WfPDaGuIsUrEe6-e3HJpzHbjJCYFKzrF7mghMR4O1VstVjwEdYX-QQ>
    <xme:WfPDaLdTwSIO6wHADzHbI1GCZVROUQFrBN5bf1RSzeigqwVbg08C6WM00Afp-65x0
    RZWEqL5Xjboy3OYyz0>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdeggddvkeejlecutefuodetggdotefrod
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
X-ME-Proxy: <xmx:WfPDaEqN_q6tYpYBgHqbaXeMIWWYeCD7i1PfPOpiNQgTfTusQAbplA>
    <xmx:WfPDaFgM8M1jDJDlqZkPywyDozkHTeqG-FJA8dINcdX2bB7OuZkcag>
    <xmx:WfPDaKIxdHlABr-TMX6jl6rL10byP7mIBcu10ZsTsaxIGEL3I_VyEg>
    <xmx:WfPDaC4MP1PgKGRLiJso9NwDui0b7sZsJbvIFwjoBQONQKl07idhZg>
    <xmx:WvPDaAlcw0aU0UxqRmsaUcMFIiKW8MFdVdLPSfFJyj5hIs03ouv_j11Y>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id F0CF1700069; Fri, 12 Sep 2025 06:18:00 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
MIME-Version: 1.0
X-ThreadId: AmcCJOTBQ5ho
Date: Fri, 12 Sep 2025 12:17:26 +0200
From: "Arnd Bergmann" <arnd@arndb.de>
To: "Andreas Larsson" <andreas@gaisler.com>, ksummit@lists.linux.dev
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
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
 "Sergio Paracuellos" <sergio.paracuellos@gmail.com>
Message-Id: <c6ad1870-f5c1-42f4-9de8-953f2e0f6a6f@app.fastmail.com>
In-Reply-To: <a393f6bd-ac30-4861-818c-ba0b558df4a4@gaisler.com>
References: <4ff89b72-03ff-4447-9d21-dd6a5fe1550f@app.fastmail.com>
 <5d2fec2b-8e59-417e-b9e6-12c6e27dd5f0@gaisler.com>
 <363853cd-7f10-4aa9-8850-47eee6d516b9@app.fastmail.com>
 <a393f6bd-ac30-4861-818c-ba0b558df4a4@gaisler.com>
Subject: Re: [TECH TOPIC] Reaching consensus on CONFIG_HIGHMEM phaseout
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 439C940005
X-Stat-Signature: urf9ao87rszmurrkyfy3w1d8iork58rr
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1757672284-697720
X-HE-Meta: U2FsdGVkX1/TwNMsDR4NnvuPTsm7JQq1jGwdUViQ+sVvUG16+gX6j8Uuj8FDdPfh3HA8WwW6k7mo3X7aQ+QOu++EXcMMlXIakFRWhpBxXdbta8Zm6eGAadrbyjKF7VyrqbT2pSttK9bwvHJqZ7OwzsHVap+ZE8FIz56c7NVpyhH40eXlCo2XsaEpV/mkByoSohrlFos0pCpb48/y5l8ueWIqKc5NfcHF0OxIH+HQJd+NUID7xzSb+PfAXlUl3V/X82oI9dp9oVZPiS5w0oG3mQZ2cUI3QI3msVeLPNKopUzi+yBDod8mvo6JXQQeDoM1aqOCySh18SzTCsGgQzYIVhgZG48bGA1MioAYxLhYyPyVeP0lrbGRqfUn6VRSbk6MIVEnixSemTUS7NKwLjrRwQNiK0zP6LywZJkAwHzeKSq4HeVUkbQS8l/xLhbq87uYW5t0pCsLvWa4G8Bp5vaZN5tb7LcQjxqDWeDFBOLfg11yY9dUA7BVFpl7Uh9zywKj1Iylc+Rl/JwsIDLSQL4fFDLWhhyQaK6TqZxldwQthgUnYagppI/BCoa5OZqDKCpPe90IsaZcT5ArjjhVCrEUA2K5njaIw+IM5A0TeY9v6So2cKI9jmPlk4VfPeFBSTzT3c3E+poY7PvBaqGo/S38fhEZwudnUn5pU5dVYlj7bd5tBVO6IIUdLuy0dCX0OeJfEienCZ2eMZdTzQiT9xX/9AOmI0gW7xKlOuPX8vaGvTNb6EIky/m3ujdDXbvwuH6ikorNe0Gk5t60LS3i71FbEDUzM6oTqbrSRzTOumeS4YukEyNfB05Mux1epcHX5yIDk6EuEhz5b/1s0aloGn2rCiDyWamxd3WDpsQ/ZNO+4nXeSOcvxDPFK6uC8bAMuNBjHmKp20nPCDd4qzHVKOmgtoDSkzzv35RxTYeE7Y7Hh0EFAPwVgtZ+FCz82PpKshmXs04jAPTCVUAUQ01FZb/
 I1oPoPek
 gcU0filZBrb34/KHrDgv2HUQsuTNcyhVPp4Atx5K5v4sUWNfMCllePBgDtg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 12, 2025, at 11:32, Andreas Larsson wrote:
> On 2025-09-11 09:53, Arnd Bergmann wrote:
>> On Thu, Sep 11, 2025, at 07:38, Andreas Larsson wrote:
>>>
>>> We have a upcoming SoC with support for up to 16 GiB of DRAM. When that is
>>> used in LEON sparc32 configuration (using 36-bit physical addressing), a
>>> removed CONFIG_HIGHMEM would be a considerable limitation, even after an
>>> introduction of different CONFIG_VMSPLIT_* options for sparc32.
>> 
>> I agree that without highmem that chip is going to be unusable from Linux,
>> but I wonder if there is a chance to actually use it even with highmem,
>> for a combination of reasons:
>
> I would definitely not call it unusable in LEON sparc32 mode with
> HIGHMEM gone, but it would of course be seriously hampered memory wise
> without HIGHMEM support compared to with HIGHMEM.

I meant specifically a configuration with 16GB of RAM would be
unusable.

>> - If you come up with patches to extend lowmem to 2GB at the expense
>>   of a lower TASK_SIZE, you're still  looking at a ration of 7:1 with
>>   14GB of highmem on the maxed-out configuration, so many workloads
>>   would still struggle to actually use that memory for page cache.
>
> Yes, we already have patches for 36-bit addressing with 64-bit
> phys_addr_t. Patches for CONFIG_VMSPLIT_* are under development.

Ok

> Even with 192 MiB lowmem we have being using up to 4 GiB without running
> into problems. Could you elaborate on why you think lowmem would run out
> before 14 GiB highmem in a VMSPLIT_3G or VMSPLIT_2G configuration?
>
> And even if 14 GiB highmem would be hard to get full usage out of, for a
> board with 8 GiB memory (or a configuration limiting 16 GiB down to only
> use 8 GiB or somewhere in between) the difference between getting to use
> 2 GiB and 8 GiB is quite hefty.

This is highly workload dependent, but usually what happens is that
one type of allocations fills up lowmem to the point where the
system runs out of memory. This could be any of:

- AFAICT the mem_map[] array uses 40 bytes per physical page on sparc64,
  so on 16GB, you need 160MB of lowmem for the mem_map[] alone.
- to actually access the memory from user space, you need several tasks
  that each map a portion of the physical memory. Each task requires
  at least page tables, task_struct, kernel stack, inodes, vma structures
  etc, all of which have to be in lowmem.
- anything you find in /proc/slabinfo comes from lowmem, and for any
  network or filesystem heavy workload, there are a lot of those

It's easy to construct an artifical testcase that maximises the
highmem usage, but much harder to change an existing workload to
use highmem without using more lowmem as well.

>> When you say "used in LEON sparc32 configuration", does that mean
>> you can also run Linux in some other confuration like an rv64
>> kernel on a NOEL-V core on that chip?
>
> Yes, boot strapping will select between sparc32 LEON and rv64 NOEL-V.

>> Aside from the upcoming SoC and whatever happens to that, what is
>> the largest LEON Linux memory configuration that you know is used
>> in production today and still requires kernel updates beyond ~2029?
>
> The maximum I know of for systems currently in production has the
> capacity to have up to 2 GiB memory.

Ok. The 2GB point is clearly the one that works well enough on
x86-32, arm32, powerpc32 and others, with VMSPLIT_3G+highmem
that gives you a 1:1 or 2:1 ratio of highmem to lowmem, and
a single process is able to use all the available memory in
its 3GB virtual space. Alternatively you can already use 2GB
on those architectures with VMSPLIT_2G_OPT to have everything
in lowmem, again depending on your workload.

Once you go to 4GB and beyond, you really want a 64-bit kernel.
CPU designers have added 36-bit addressing to all the major
32-bit architectures at some point, but it's been very rare
that this was actually used after 64-bit CPUs became available.

    Arnd

