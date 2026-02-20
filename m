Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B1BE0C55178
	for <linux-mm@archiver.kernel.org>; Fri, 20 Feb 2026 09:51:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DC9F96B0088; Fri, 20 Feb 2026 04:51:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D77FC6B0089; Fri, 20 Feb 2026 04:51:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C89FA6B008A; Fri, 20 Feb 2026 04:51:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id B5EBC6B0088
	for <linux-mm@kvack.org>; Fri, 20 Feb 2026 04:51:26 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 62A0E1A0C22
	for <linux-mm@kvack.org>; Fri, 20 Feb 2026 09:51:26 +0000 (UTC)
X-FDA: 84464367372.11.C280423
Received: from fout-a7-smtp.messagingengine.com (fout-a7-smtp.messagingengine.com [103.168.172.150])
	by imf04.hostedemail.com (Postfix) with ESMTP id 595C740005
	for <linux-mm@kvack.org>; Fri, 20 Feb 2026 09:51:24 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=arndb.de header.s=fm3 header.b=DM8l3uM5;
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b="L g0sPUz";
	spf=pass (imf04.hostedemail.com: domain of arnd@arndb.de designates 103.168.172.150 as permitted sender) smtp.mailfrom=arnd@arndb.de;
	dmarc=pass (policy=none) header.from=arndb.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771581084;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/Ss8+VywhuMU/4S/P79Oi5pZzhllFGa7sC8VXnFATFo=;
	b=u8o51lz/Zy+eNO2rSnVAnYMuw8UP6hxy9ZoH1iIehtefg6fx/Q5yJI1hdYZPnH4q+K4ImN
	eeuv4N5AKk6ZiJ0NNumh/tHp2UN/h9C9pEjW+4loL7alWpVolLc737XdTdwNM9uNHvvj7U
	A0cvXPixNU5uydDUrzGOnfQkSTNnzPA=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=arndb.de header.s=fm3 header.b=DM8l3uM5;
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b="L g0sPUz";
	spf=pass (imf04.hostedemail.com: domain of arnd@arndb.de designates 103.168.172.150 as permitted sender) smtp.mailfrom=arnd@arndb.de;
	dmarc=pass (policy=none) header.from=arndb.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771581084; a=rsa-sha256;
	cv=none;
	b=xlnl5AHh6kUO69+tYWeI1DzPeuIu+Dh++kLoMYyhYk9E0t84cKUi3WdAWDGGA7QvNYrhQv
	4AdqwWSH1tdBgbxFS9P1JmwTynOACVrKvAmP1PgOhFaUxFoHr9G1Xy6kEH6RluoYDbbCQh
	lfnK02esOmLmozSQmc2agsskeG2Ztm8=
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfout.phl.internal (Postfix) with ESMTP id A73D7EC00BE;
	Fri, 20 Feb 2026 04:51:23 -0500 (EST)
Received: from phl-imap-02 ([10.202.2.81])
  by phl-compute-04.internal (MEProxy); Fri, 20 Feb 2026 04:51:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm3; t=1771581083;
	 x=1771667483; bh=/Ss8+VywhuMU/4S/P79Oi5pZzhllFGa7sC8VXnFATFo=; b=
	DM8l3uM54FlOtMhdVmuiKUnCv+Tdb05f/0/le+2o7lCAyrlAlayKHHIoDwMaE5+L
	VgnZQAssygnuYcc2cr58Y9X+zQKJt48nGOiMht3Pmm6T/F/UYLUAFnfkNBK6vHLv
	KeJ1NgEPJ61wPCgS4SvodSHSVPBSTTFzEURuHk1XABKqJN0W+ghzSsqcSQVjXjuk
	0HPuihJzk7vvndxVcKz37UQ5mgSH72QfgIijj7M3CqCiO05FsTefKV+/Arv/dfwL
	qnCAx/fTV3xbQs2rPh6JxHCYAxbppMR5xmtUHMo/UBQxiwRHYiFyosSjIJYVUUfS
	AC73s4R32s+z/FThsWIPGg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1771581083; x=
	1771667483; bh=/Ss8+VywhuMU/4S/P79Oi5pZzhllFGa7sC8VXnFATFo=; b=L
	g0sPUzk+wjVOq3c+ySWLNHKhNdDP1aNcbKu2Igeu0YmL9p6yj2rVP4SXygzl2X9o
	47BETZmZ+eoPcPka5MtbwsmLfUdilPwa/QhJTgTDdFQ5rCQojfUPZr1NXSGEwOz8
	yvpD2/nJkRorJ403yFC/SoUv3eseB21eWCI7yPjFwsH6dvZXTDKa69U3VeMxuOep
	3osIDLDXf5DQnVtdFkdRrsyYx/oCtqqSaiYkGJb0AqVGd+uiR75cVhkcVnmoaPOy
	KkSioLBhVGQTS5Bk2Ad9QotvJilGgvBwmNebScXsBLgT/pkvEUnCWpxy6yDyQywF
	34i7ujWsm9UbBjPAHxlZA==
X-ME-Sender: <xms:mS6YadDcMz1LW9GlFgls2pIkaWd-nac4ctLgKiC9GeQ4tuA4WobsHg>
    <xme:mS6YaWW4xnJACieWFCPsFLuAXGa815jgmercmd9MSEmh212xyyqERZzWmYf14UnBM
    PW9m_pWz4lgekPAOiKPCgeKyiI0XwV-xnlfGC9N7DJXhqfWqoAQc-E>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddvvdekuddvucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepofggfffhvfevkfgjfhfutgfgsehtjeertdertddtnecuhfhrohhmpedftehrnhgu
    uceuvghrghhmrghnnhdfuceorghrnhgusegrrhhnuggsrdguvgeqnecuggftrfgrthhtvg
    hrnhephfdthfdvtdefhedukeetgefggffhjeeggeetfefggfevudegudevledvkefhvdei
    necuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomheprghrnh
    gusegrrhhnuggsrdguvgdpnhgspghrtghpthhtohepvddtpdhmohguvgepshhmthhpohhu
    thdprhgtphhtthhopegtrghtrghlihhnrdhmrghrihhnrghssegrrhhmrdgtohhmpdhrtg
    hpthhtohepuggvvhdrjhgrihhnsegrrhhmrdgtohhmpdhrtghpthhtoheprhihrghnrdhr
    ohgsvghrthhssegrrhhmrdgtohhmpdhrtghpthhtohephhhughhhugesghhoohhglhgvrd
    gtohhmpdhrtghpthhtohepshhurhgvnhgssehgohhoghhlvgdrtghomhdprhgtphhtthho
    peifihhllhihsehinhhfrhgruggvrggurdhorhhgpdhrtghpthhtoheprghruggssehkvg
    hrnhgvlhdrohhrghdprhgtphhtthhopegurghvihgusehkvghrnhgvlhdrohhrghdprhgt
    phhtthhopehrphhptheskhgvrhhnvghlrdhorhhg
X-ME-Proxy: <xmx:mS6YaRn5gsZlN31IV-YVFag28YOwQjXuLMU7uZDbX_HQE02SNqa2xg>
    <xmx:mS6YabNvD9ZyuAY6rrUR_xwp28TrBXegBjycAcHGYfUD7G55ZYi-BQ>
    <xmx:mS6YaToaXbFImnpECXlViUynjZHYH7nP1vGDVwLY4RdLfAMra1WXPg>
    <xmx:mS6YaUvdB2QK0kJK8EVY2Et2G_gm5JVgpwRi1yePHjOszGe4pAo_Aw>
    <xmx:my6Yad2etw_Sw5FD4H2hINglbPGE5SPNWZlEAlt5XZQK1Od-jSxLQ_og>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id CCB9F700065; Fri, 20 Feb 2026 04:51:21 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
MIME-Version: 1.0
X-ThreadId: ApFJJ1QKyIT7
Date: Fri, 20 Feb 2026 10:49:33 +0100
From: "Arnd Bergmann" <arnd@arndb.de>
To: "Matthew Wilcox" <willy@infradead.org>, "Dev Jain" <dev.jain@arm.com>
Cc: lsf-pc@lists.linux-foundation.org, "Ryan Roberts" <ryan.roberts@arm.com>,
 "Catalin Marinas" <catalin.marinas@arm.com>, "Will Deacon" <will@kernel.org>,
 "Ard Biesheuvel" <ardb@kernel.org>, "Hugh Dickins" <hughd@google.com>,
 "Baolin Wang" <baolin.wang@linux.alibaba.com>,
 "Andrew Morton" <akpm@linux-foundation.org>,
 "David Hildenbrand (Red Hat)" <david@kernel.org>,
 "Lorenzo Stoakes" <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 "Vlastimil Babka" <vbabka@suse.cz>, "Mike Rapoport" <rppt@kernel.org>,
 "Suren Baghdasaryan" <surenb@google.com>, "Michal Hocko" <mhocko@suse.com>,
 linux-mm@kvack.org, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org
Message-Id: <5a687d0d-5ee2-42a2-9bd5-df29e518edac@app.fastmail.com>
In-Reply-To: <aZSHvt9Trlq7k7aH@casper.infradead.org>
References: <20260217145026.3880286-1-dev.jain@arm.com>
 <aZSHvt9Trlq7k7aH@casper.infradead.org>
Subject: Re: [LSF/MM/BPF TOPIC] Per-process page size
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
X-Stat-Signature: g1utx6i4yqdb8r6q4b5aczjw1ix18ob8
X-Rspam-User: 
X-Rspamd-Queue-Id: 595C740005
X-Rspamd-Server: rspam01
X-HE-Tag: 1771581084-470002
X-HE-Meta: U2FsdGVkX18G3OzTpYEBIz/BuYQ1yGL7gUSdSITDmMxvUfwprL4jZjrLRcWKJdrlzCizUGfBwgeRP0i4W8GUJI0kOs3FTU3rGt33EE1mztGYXFjD+IGWIT9hG60ODDxlLReJLRetQ3c1wCwJPvXqiiojsiOV6pux8TfLuB2W6xdmnrgzN2kqYYJqBvBIpW4iy39s0P/jSFNKYT8gPBjknxxjQNvEgxpC1+yJCCBq78ndcHpdv/aUrV+ROwrc1pj9O4oaWQ7mRMFyEwVunNSchWgG0Q3r39upWmo+Th0F4it352VM0UVSCJIRbjDVyqNlM+fn5Gz207D4Vx6JBTUFDHO1ynwH/bKGOAQniduW2zrP3MBt8B8Dh3k7vLJ2SvRM3UVRWtD6eMVZJBkFvzruliihsr6KPX3gQINyTjqP+XDXUQQ1wrZ/N4GnFpCVQMeI0U3NAt6n/YvAFtbajeTuxHBlIumkxO42zyOOJ1lXEH7Yj60btwP0kEAy468BMEEv5Bl0j4qVTX1PvgSXuVeUYaPA/BHpiHNM5Vj26racz9b+zpxtmV6J5iTGtmywK+6cD5H25rT7k5m3t/UbGZ+GS2TZ1SXXIVovr7lIaKsfi+t/kmKezle6xTjaMpv30McMQnbRF543b/ymKwAzzAsCktBgt5kzbBV6o8/DyDLZ3OsdoouTua6MYhXYLukskzVyRezCaXLLO9/PFhoUi7xcl0q4Cc2tSF9ojc6HU+jQQykq03Uo4T7iV3aCYFNIwcfYs9JSJL9ifUOFNa5b52Iq2LfgUfJpOcNxoFeD0A/RRi0+CXQ2oOJ5oxscK/qIwpurGfskOFlXDT1E0LxdUR8xQhscdz7OQJDxGKqUSmwv0gyI5n32t8cP8sg5Knf+fus+W45j+G6dRk+i39oxgY6vJg/0HFpA+yXIxYHxXT/ozhnZarWpbUXTTyq1COMfSty8X1Mwv9MOlBHtr6Ekrof
 sXXbv32e
 ppeISsN6seZcjoLOQYFO694ZHVmlBoDxtosPwYk32su43oGOFHqc5Aw4CYaaai6xAQbzi6lmEmmBq5HON6ngbjirG4A5E121Jb67EJsAuFCl/xjI/HppNuJaykVvvPyi9Vl5Oo6fSMDQg7IwPnlQ+pvPbwJZOVqNxRSEi5ZN9dE8fpsYRgC5BtytxzEGWWoUFBRPn08AMiCEDeUb7lDo+9/jGZyvmVPWR6n5X
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Feb 17, 2026, at 16:22, Matthew Wilcox wrote:
> On Tue, Feb 17, 2026 at 08:20:26PM +0530, Dev Jain wrote:
>>
>>  - Are there other arches which could benefit from this?
>
> Some architectures walk the page tables entirely in software, but on the
> other hand, those tend to be, er, "legacy" architectures these days and
> it's doubtful that anybody would invest in adding support.
>
> Sounds like a good question for Arnd ;-)

I think Loongarch and RISC-V are the candidates for doing whatever
Arm does here. MIPS and PowerPC64 could do it in theory, but it's
less clear that someone will spend the effort here.

>>  - Rough edges of compatibility layer - pfnmaps, ksm, procfs, etc. For
>>    example, what happens when a 64K process opens a procfs file of
>>    a 4K process?

This would also be my main concern. There are hundreds of device drivers
that implement a custom .mmap() file operation, and a few dozen file
systems, all of which need to be audited and likely changed to allow
mapping larger granules.

>>  - native pgtable implementation - perhaps inspiration can be taken
>>    from other arches with an involved pgtable logic (ppc, s390)?
>
> I question who decides what page size a particular process will use.
> The programmer?  The sysadmin?

I would expect this to be done by a combination of these two, it
seems simple enough to have a wrapper like numactl or setarch to
start an application one way or another.


Another concern I have is for the actual performance trade-offs here.
As I understand it, the idea is to have most of the memory size
advantages of a 4KB page kernel, and most of the performance
advantages of a 64KB page kernel for the special applications that
care about this. However, the same is true for 16KB page kernel,
which also aims for the same trade-off with a much simpler model
and a different set of compatibility problems.

Do we expect per-process page size kernels to actually be better
than fixed 16KB page kernels, and better enough that it's worth
the added complexity? In particular, this approach would likely
only get the advantages of the TLB but not the file systems using
larger pages, while also suffering from the extra overhead of
compacting smaller pages in order to map them.

   Arnd

