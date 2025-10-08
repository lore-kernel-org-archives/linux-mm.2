Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9D98FCCA470
	for <linux-mm@archiver.kernel.org>; Wed,  8 Oct 2025 10:33:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EE6338E000D; Wed,  8 Oct 2025 06:33:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E97728E0005; Wed,  8 Oct 2025 06:33:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D86318E000D; Wed,  8 Oct 2025 06:33:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C77358E0005
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 06:33:08 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 96C31160118
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 10:33:08 +0000 (UTC)
X-FDA: 83974584456.19.5233557
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id 9D0AD1C001D
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 10:33:06 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LeqDFI6H;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759919586;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=o8icbrcXzTRCL5crimPXEf38lTPLnUQkfyNRpAzdLqg=;
	b=JFSIbnQlPM0hiBvoD2FMrdzOZOIHaebAIaibvTKAsrPN5x2ZRV4/IangjM7FnsTZXz6aZa
	4saKAzFIgaNJEKLyhlOT1Ik+5/ipNik31mBq0I7fDqTlk7G95X9s41mSxHvcUdSOWbruPC
	wkXgnHIBUJn7Gq884oc8aDLVKD6tkQU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759919586; a=rsa-sha256;
	cv=none;
	b=uwIq52iW+csu2HdH2skhGHIgKjT4RvQsPrmTWvbiVAEMhzOvsljFUm2XyafssBVkq0071e
	kCZgiUTu5slRVZjOhaTDfnC4DVr+8NskfXuc7v6zmWTAmgT/L16IO0erLudIC+UQm4xbuE
	765BZNCcuIbiyU5I+HTUV9tFYbYW1To=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LeqDFI6H;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 9BD5461F54;
	Wed,  8 Oct 2025 10:33:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADEF7C4AF0B;
	Wed,  8 Oct 2025 10:33:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1759919585;
	bh=ebKkEsnGtJg9BHiElx4TZYX6g1+ZOgVHkaaIq2OEWwk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=LeqDFI6HpfBKRsb/79toHGw54ncCDPykuSei3jXbsAFhv7aAaRqY1jtB8imBkP7Sj
	 LZCe4iVND7ScZ7a9ycNRk1sqNVSFwStpLYLdmn+juVwXo/2qQ27H+3d8WzyA9eX3Dv
	 /4rOnellhZIZp7+nQ/SaFwrV3wEmF+jzDRFwC3ZHeppTWB4yIbiTKznH9UsY1/DYk0
	 jEizPqqaCKEqNwNLObQTWggy5nxIVi1vRBHopJOkDOcUZkz99K4K1JMmtobjtvUAhd
	 yv3t9Bekyd8Kv/nZNTFHXeJ9YDogW3YBIVieqib0mZTM+8ElmLrR3LcyxBj/LLzIvo
	 OiDLFoTYkDdrQ==
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailfauth.phl.internal (Postfix) with ESMTP id D48AEF4006A;
	Wed,  8 Oct 2025 06:33:03 -0400 (EDT)
Received: from phl-mailfrontend-02 ([10.202.2.163])
  by phl-compute-02.internal (MEProxy); Wed, 08 Oct 2025 06:33:03 -0400
X-ME-Sender: <xms:3z3maEPgXEJLz2KM41mvujuUPTcYRX6iiSpBjDCMRxygDNtOSlFeLA>
    <xme:3z3maDwe3-HOGSY4do_Gqb7qN0Jo3uIoyw4ZNz2m-kYUMX-r7Z5hlM15zwzZyCoKe
    ZIK8CMsMxD6GCLMMSZ_5nwBsqnoS7RDOQlz3_LwZodgSNEueAuiAU3v>
X-ME-Received: <xmr:3z3maCOCToqIh9PXwKLy6Z6olts7GiYzL102t3BreEgBWIXZyMCiPYIwrdNrdQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdeggddutdeftdejucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepfffhvfevuffkfhggtggujgesthdtsfdttddtvdenucfhrhhomhepmfhirhihlhcu
    ufhhuhhtshgvmhgruhcuoehkrghssehkvghrnhgvlhdrohhrgheqnecuggftrfgrthhtvg
    hrnhepheeikeeuveduheevtddvffekhfeufefhvedtudehheektdfhtdehjeevleeuffeg
    necuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepkhhirh
    hilhhlodhmvghsmhhtphgruhhthhhpvghrshhonhgrlhhithihqdduieduudeivdeiheeh
    qddvkeeggeegjedvkedqkhgrsheppehkvghrnhgvlhdrohhrghesshhhuhhtvghmohhvrd
    hnrghmvgdpnhgspghrtghpthhtohepfedvpdhmohguvgepshhmthhpohhuthdprhgtphht
    thhopehsjheskhgvrhhnvghlrdhorhhgpdhrtghpthhtohepugesihhlvhhokhhhihhnrd
    gtohhmpdhrtghpthhtoheprghkphhmsehlihhnuhigqdhfohhunhgurghtihhonhdrohhr
    ghdprhgtphhtthhopehshhhikhgvmhgvnhhgsehhuhgrfigvihgtlhhouhgurdgtohhmpd
    hrtghpthhtohepkhgrshhonhhgsehtvghntggvnhhtrdgtohhmpdhrtghpthhtohepnhhp
    hhgrmhgtshesghhmrghilhdrtghomhdprhgtphhtthhopegshhgvsehrvgguhhgrthdrtg
    homhdprhgtphhtthhopegsrghohhhurgeskhgvrhhnvghlrdhorhhgpdhrtghpthhtohep
    tghhrhhishhlsehkvghrnhgvlhdrohhrgh
X-ME-Proxy: <xmx:3z3maGQQEIn_9blyobQI1AT6SA-kIjq1QWm2DQ2Hcg4V1T1YeLICvw>
    <xmx:3z3maFXKjvvo7oqtsl0v32XslPUruNAv8C7amGimTl6qXKpC2wLmww>
    <xmx:3z3maPRmfX_CmQaDOSbs0ExcLsL50UPU2l9c5ix32X8XrdPQoypueQ>
    <xmx:3z3maAtPNXOaxJHYTTGUhOyWXPRRtpTXg0G7WlMMNCjcAxigVG5ocw>
    <xmx:3z3maAao22rxt42G-lDKVLKVh12lCW6sJLhSETLJ_B9JqMPneYJplngV>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 8 Oct 2025 06:33:03 -0400 (EDT)
Date: Wed, 8 Oct 2025 11:33:01 +0100
From: Kiryl Shutsemau <kas@kernel.org>
To: SeongJae Park <sj@kernel.org>
Cc: Dmitry Ilvokhin <d@ilvokhin.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Kairui Song <kasong@tencent.com>, Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, 
	Barry Song <baohua@kernel.org>, Chris Li <chrisl@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Usama Arif <usamaarif642@gmail.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	kernel-team@meta.com
Subject: Re: [PATCH v2] mm: skip folio_activate() for mlocked folios
Message-ID: <x6u2afqqwqpoabtpq24n64owlwagolt63csvaibg33p6t2ywuf@beayabw66enb>
References: <aOPDRmk2Zd20qxfk@shell.ilvokhin.com>
 <20251007195313.7336-1-sj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251007195313.7336-1-sj@kernel.org>
X-Rspamd-Server: rspam01
X-Stat-Signature: 5iwrkwcyuscaycw6431ahqune16axrrz
X-Rspam-User: 
X-Rspamd-Queue-Id: 9D0AD1C001D
X-HE-Tag: 1759919586-382621
X-HE-Meta: U2FsdGVkX1/8kUhvj0F9W5j1LIxpc3H9V51HeXghVgh8aEZ7EEbHTU+3UlCEsSvYezL78l0yx61r4umBIZ8Ose65hopuypqGcwAEz4uye3vLTkCWr0+XOBwF9Zl0IEhM+c8NuapkzMloqyXG5JYis8SJHXjYDZzWzp3Lrmbb5njFTyzgnilG0oOOsye5+MUkFAlButaGAj+sLlD10YxxeV96Q/o4cfAF5igkhvFHlxJT2ZxbYU9RDI5++Fp7YP4QnJvI+cqIxIj+QzUiMqmYz1Cjr2hsRjwBhDAqfg7sla0M9Dhx+H09t2V4bZKiKqMiOPhY5AqR9tBTqeDiWu4UsLuo42ZBldb3txvGAsP3on2mQcrC9gUmA2SSPGTjU9UucDi+PBDyrjKSPjBdsCUk4VkWdyv1vzIdMZGQ02jEKI4QIPkvAmZ6QhySc5eOwogpHvi5Agu18Nrp3b4+GEQChbbXZb/TaATXCuiXDvgNy1GEfTIUJ3pwnFxQtmBUss1EMhkJrAk6ywRxzz8NDtgkEtRdwIhb67Rtuoq5lWcbkcpjc8S36AhrTUhP/S5IhmU/ODam6K2k/lTTLFCblGcdpQBaHDGnMM80hFRKF5gksBZeIEia7oKTh16Uza3t56Hi68/NCetCJ5X7h8U28OCl874ev3tg1XxrLYslI3akAdnRXMDos+OtM9h+E11tZnZxWjOeUCISlbzYyVfiTaqFuQPlc3L9sIbr1/QsAqGMX1aIWi7AuR13t4TRhqoAVVqmhIGQV/g/uI9aDNxr0LkBBdAoGURuv3+UqyQy6vSUXkPOODfZVOHN6nAcs0X48nKnSwJRzvfAMbe6SQFsG9+/AvAXTagbnknbo0pZHkgbSSLWBVryNfNJhJktuu5tG6UExlHxoLm0gML70z5LemYAPw6fiOw5Ay9guNWV7BJFl3GWaGd1S9ZjKjIJR1PYE5dnPXU2CBUn8TEOkRzqBke
 tqM1Fafw
 zYqJJj6xifl5qYxPVsecmFEv080pqlqOeDiUm6jbJDOkTbJa1ilyPfmz5FZ39nONw471PjM3oalTixG+qFvfNTumXlp4X2/CGL/5oqd+9vUbuSVaXNJIr+NVsTgJuQP5JK7F1Wad4y0q7GSplZwupUFLJf9PAZ4KIO+XAMPv+gkJ6aUlQ4wXKaQweKMH3c5wSN7Kot09vK5l7nWnzKuriPW8KwtAyu6Pj+Yd1RXi9LY9ZTQVpd+6/3UP0LnTyVhJJJb76i8MBRDEvQL46h2O6Ew+tWeaGv7tlXzcgQv7w514BLK2fuOxddo1f5l3RQqZTt1QI/rtlDVrfFVzWD/+itl4/P6pQGIvt+FmkU9nXjEZ6C95apoGwsKKz07f7Fxq/DAb8
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Oct 07, 2025 at 12:53:13PM -0700, SeongJae Park wrote:
> On Mon, 6 Oct 2025 13:25:26 +0000 Dmitry Ilvokhin <d@ilvokhin.com> wrote:
> 
> > __mlock_folio() does not move folio to unevicable LRU, when
> > folio_activate() removes folio from LRU.
> 
> A trivial opinion.  So the user-visible issue is the incorrect meminfo, right?

The user-visible effect is that we unnecessary postpone moving pages to
unevictable LRU that lead to unexpected stats: Mlocked > Unevictable.

> > ---
> > Changes in v2:
> >   - Rephrase commit message: frame it in terms of unevicable LRU, not stat
> >     accounting.
> 
> Yet another trivial and personal opinion.  Adding a link to the previous
> version could be helpful for reviewers like me.

You probably missed recent Linus rant on Link: tags :P

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

