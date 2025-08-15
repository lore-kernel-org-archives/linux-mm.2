Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7824CA0EE0
	for <linux-mm@archiver.kernel.org>; Fri, 15 Aug 2025 05:11:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 24E538E01D1; Fri, 15 Aug 2025 01:11:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1FF868E0002; Fri, 15 Aug 2025 01:11:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0EF068E01D1; Fri, 15 Aug 2025 01:11:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id ED2598E0002
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 01:11:08 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 721F4BBB0A
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 05:11:08 +0000 (UTC)
X-FDA: 83777817816.10.35EB499
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 8630440005
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 05:11:06 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="qaZHeg2/";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of leon@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=leon@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755234666; a=rsa-sha256;
	cv=none;
	b=o85dt1WE80jism1SujTIUq8Fnz7Lq9YJj0TEoF60Y+1eaDzxTHXMw1K3bP1RaL48GYcC53
	SNejAvQuljz9+l1KLmPZW8ofFpWDPuV6cx3ZS859vCs4qgTzgX2OdsI9uQxLm7lPMsfGsQ
	siJ8URERid0aQ77rHM7zMrWB/VOYzKQ=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="qaZHeg2/";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of leon@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=leon@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755234666;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XUOWdZP1cezLj5JR2qWET0ULt+yC1LXg9Jc7bXW5jXo=;
	b=8j/nFqgQMxwd4Le342coOZUZXc8KSjCOdqKRWIyUHtOi5Qi6VsuPm0vpsYnY46XMeGYaL7
	5glu1EnKRThjErJrF+08I8YlD8Z7UFFd9sVsR06beQ4zqxe/145HM5/7nrZZKQ7JtjgUlh
	11cFMx3kd8pxyHb1OxHCiSylSEe6lVo=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 6848645783;
	Fri, 15 Aug 2025 05:11:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EACBBC4CEEB;
	Fri, 15 Aug 2025 05:11:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755234665;
	bh=rjs/V71n+3a48sbczUimLUbQ99An++PfjAuhQIEa13s=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject:From;
	b=qaZHeg2/5a1nlFDrCh+QQq8+2z+k/HIBWZUD4nh0+1i6c37KB42J7MuL6+NCG/t+L
	 Sb4lS+mkZ14VoVX+YlDNVGPRMcWMXRHAGigO6GBs+JD82O/j0LxY54D+zDNDsJYKAo
	 sXevI5VIzQWOLFfl/WV5zUlxyV+wLZ1J0REOzQc8KXCWGG5zo4v1sD8WTb37YmZh26
	 fQvGeRnhGwhiRkaAiLioOMAOHFUuoJ1KDM4vS7BfgMxeW43efHE9YPv+gnweYXLTPM
	 XrWCUBDKKDrqe8banORHuWlWg0uTJGuY3c9EmS4cdtxIgiUKad4TjoW3OXKR2Ys5uU
	 wi4dFrypsvChQ==
Received: from phl-compute-12.internal (phl-compute-12.internal [10.202.2.52])
	by mailfauth.phl.internal (Postfix) with ESMTP id CD58BF40066;
	Fri, 15 Aug 2025 01:11:02 -0400 (EDT)
Received: from phl-imap-08 ([10.202.2.84])
  by phl-compute-12.internal (MEProxy); Fri, 15 Aug 2025 01:11:02 -0400
X-ME-Sender: <xms:ZsGeaEjCAtEWX1UaHLA2gfColtQZO7w89chtZ2uFaG4vMYHweTmDIQ>
    <xme:ZsGeaNCED0uQ78E9d2j9GAg3NYkGAhxwrM8S6giPlAbcy5DsDkd_hrjkIGTNdnggG
    4eL_xWyjdx6jEOR_bI>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdefgddugeeftdekucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepofggfffhvfevkfgjfhfutgfgsehtqhertdertdejnecuhfhrohhmpedfnfgvohhn
    ucftohhmrghnohhvshhkhidfuceolhgvohhnsehkvghrnhgvlhdrohhrgheqnecuggftrf
    grthhtvghrnhepffegjefgueegffffjeevheektdekgeevheelvdekieehvdejvdejjefh
    hfelhfefnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucevlhhushhtvghrufhiii
    gvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehlvghonhdomhgvshhmthhprghuthhh
    phgvrhhsohhnrghlihhthidquddvfedtheefleekgedqvdejjeeljeejvdekqdhlvghonh
    eppehkvghrnhgvlhdrohhrgheslhgvohhnrdhnuhdpnhgspghrtghpthhtohepfeejpdhm
    ohguvgepshhmthhpohhuthdprhgtphhtthhopehjohhroheskegshihtvghsrdhorhhgpd
    hrtghpthhtoheprhhosghinhdrmhhurhhphhihsegrrhhmrdgtohhmpdhrtghpthhtohep
    tghhrhhishhtohhphhgvrdhlvghrohihsegtshhgrhhouhhprdgvuhdprhgtphhtthhope
    hmphgvsegvlhhlvghrmhgrnhdrihgurdgruhdprhgtphhtthhopegrsgguihgvlhdrjhgr
    nhhulhhguhgvsehgmhgrihhlrdgtohhmpdhrtghpthhtoheprghlvgigrdhgrgihnhhorh
    esghhmrghilhdrtghomhdprhgtphhtthhopehrohhsthgvughtsehgohhoughmihhsrdho
    rhhgpdhrtghpthhtohepghhlihguvghrsehgohhoghhlvgdrtghomhdprhgtphhtthhope
    hkrghsrghnqdguvghvsehgohhoghhlvghgrhhouhhpshdrtghomh
X-ME-Proxy: <xmx:ZsGeaPWPNXdI6VvYib3k9QdMC2XlJbr86LA_KN5YspkDL_EEK6BRlA>
    <xmx:ZsGeaI3d1bh3fFRFl4aiXZUts9ejR-WHFcon7KnhJbC_6nOGWjjn2Q>
    <xmx:ZsGeaIdgKvfZyaCQpAF_MAary9Xg8Dva0Q5zSBAie2gJ8xC3nka9fw>
    <xmx:ZsGeaNVlXDFhOQ5jT6MnFggS_FVesjsSUNJLf3EVumbGV5Io7NaXkQ>
    <xmx:ZsGeaG9LccLFJ2EboOYrfkTWU2yRr6gsoUbWRyvB7Ij-X0QWOgy49Rp5>
Feedback-ID: i927946fb:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id 8094E2CE0071; Fri, 15 Aug 2025 01:11:02 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
MIME-Version: 1.0
X-ThreadId: AWyaQ402xWe7
Date: Fri, 15 Aug 2025 08:10:43 +0300
From: "Leon Romanovsky" <leon@kernel.org>
To: "Christophe Leroy" <christophe.leroy@csgroup.eu>,
 "Marek Szyprowski" <m.szyprowski@samsung.com>
Cc: "Jason Gunthorpe" <jgg@nvidia.com>,
 "Abdiel Janulgue" <abdiel.janulgue@gmail.com>,
 "Alexander Potapenko" <glider@google.com>,
 "Alex Gaynor" <alex.gaynor@gmail.com>,
 "Andrew Morton" <akpm@linux-foundation.org>,
 "Christoph Hellwig" <hch@lst.de>, "Danilo Krummrich" <dakr@kernel.org>,
 iommu@lists.linux.dev, "Jason Wang" <jasowang@redhat.com>,
 "Jens Axboe" <axboe@kernel.dk>, "Joerg Roedel" <joro@8bytes.org>,
 "Jonathan Corbet" <corbet@lwn.net>, "Juergen Gross" <jgross@suse.com>,
 kasan-dev@googlegroups.com, "Keith Busch" <kbusch@kernel.org>,
 linux-block@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 linux-nvme@lists.infradead.org, linuxppc-dev@lists.ozlabs.org,
 linux-trace-kernel@vger.kernel.org,
 "Madhavan Srinivasan" <maddy@linux.ibm.com>,
 "Masami Hiramatsu" <mhiramat@kernel.org>,
 "Michael Ellerman" <mpe@ellerman.id.au>,
 "Michael S. Tsirkin" <mst@redhat.com>, "Miguel Ojeda" <ojeda@kernel.org>,
 "Robin Murphy" <robin.murphy@arm.com>, rust-for-linux@vger.kernel.org,
 "Sagi Grimberg" <sagi@grimberg.me>,
 "Stefano Stabellini" <sstabellini@kernel.org>,
 "Steven Rostedt" <rostedt@goodmis.org>, virtualization@lists.linux.dev,
 "Will Deacon" <will@kernel.org>, xen-devel@lists.xenproject.org
Message-Id: <45552b38-5717-4b0c-b0eb-8c463d8cf816@app.fastmail.com>
In-Reply-To: <ccc8eeba-757a-440d-80d3-9158e80c19fe@csgroup.eu>
References: <cover.1755193625.git.leon@kernel.org>
 <ccc8eeba-757a-440d-80d3-9158e80c19fe@csgroup.eu>
Subject: Re: [PATCH v3 00/16] dma-mapping: migrate to physical address-based API
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 8630440005
X-Stat-Signature: fauxkxzi8fjcjadacm31otyptgo5qjgn
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1755234666-328810
X-HE-Meta: U2FsdGVkX19QDa5D/HhFj8CcaUhBxKcIKbdCsjW3okd1N5gIggP8X2XU6tJ7H4N9mveNCUneI7nVOgjQ4vClf0NMUwZfIYQ+RfC2O4NnKiJfYpbLnsQSz7iESUeSXai+r0YYs2XYOmCHaOTkhWk1vdWkyI01otcmaaorVIuFuFWClDAvAu8jeuC9bCLTyswQpvt2vpPc1feJIW4tY0sozuSFIJRoDAFKLhW0Yg7aHHlgxz9eA2YVv5tA6ybDUHDuLD4ZBkKsUv4Kij53zK63D8PXRLVY0oH8C/E7WV/EqlCO9T4A0jwMMFu5KCQ6Z31QlKGvS+RFIRP6wED8FDuiLOtPrXwWmbYeMiPNSiCBkeCl9lOptsNkC2mUPBZ9FwPcULV5I50Tlrs6IduMbE8iDV60puAOUjTX6y4MR6hCvErh/1txGh9FX9hyBp2j+n0fVqwv8TuHngrtWHSlAGnGoZgQcbmZ8E43fTrffNSpcupjqCSLnVM/b2g8BQPpNLKVBATVhsHgWwAySm3srp0qrZnxHlogu68UQnLHxrztxut7V+VLGzW1KZ8X2gzdyQrpWITnhu9+3gQtMQ3t2PSJy+u7Djjd0r98xdjrG9RKEmvv9hGZ+S8feS+khTUHOFVvRfXIJoTrcjXyZ4rpCq5SLvBvhgNMt3spa6+FxSRX5k/UtY5GHS/B8wReXOfEHGBZd7rXHuCvuflwiwOeTQCMkBb1iLXo/3sasQw0ieyjez3iUwHwPPU0Dw9+Yp11wdIbFtv8g8TrzkDNCiyyXkvWyGtu/g15+PPuM9rc52W7sYm4lqdAQAj77Vu/r6jFEbEi/LlK5cMpvikeqM61z/uBFpeKPyLxJz3v02z/1rGJCWIG9zBjvF9g0YyxU9BEdjyKK8nGVOKjADpEY6H21s42pfmY/jgh0K9aVLIYnhgRKEU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On Thu, Aug 14, 2025, at 22:05, Christophe Leroy wrote:
> Le 14/08/2025 =C3=A0 19:53, Leon Romanovsky a =C3=A9crit=C2=A0:
>> Changelog:
>> v3:
>>   * Fixed typo in "cacheable" word
>>   * Simplified kmsan patch a lot to be simple argument refactoring
>
> v2 sent today at 12:13, v3 sent today at 19:53 .... for only that ?
>
> Have you read=20
> https://docs.kernel.org//process/submitting-patches.html#don-t-get-dis=
couraged-or-impatient=20
> ?

Yes, I'm aware of that section. It is not even remotely close to the rea=
lity in different subsystems.

There are some places in the kernel where you never get any responses.

Thanks

