Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC5B1CA0EEB
	for <linux-mm@archiver.kernel.org>; Tue, 19 Aug 2025 18:49:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 50C6C6B00C8; Tue, 19 Aug 2025 14:49:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4E4228E002A; Tue, 19 Aug 2025 14:49:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3FA336B0138; Tue, 19 Aug 2025 14:49:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2D86D6B00C8
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 14:49:33 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id CE6081DACC9
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 18:49:32 +0000 (UTC)
X-FDA: 83794395384.28.65BFF18
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
	by imf16.hostedemail.com (Postfix) with ESMTP id B816C180004
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 18:49:30 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Xmpr6nUl;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of leon@kernel.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=leon@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755629370; a=rsa-sha256;
	cv=none;
	b=Hz/NyyIF3hgLIX9RGzA2EmwhfG09hmA/24jxdqYn+DDRN7qJFLwQ8JWiRL5ioOQ1TsFWsp
	z9R8sVL0E/vGayYtXTubC2b9cgTbJ5fwu6QMmIuwYzcsd3yiz/fUvZ7D/zPCkKsiX+bDOW
	aGSzbipLRCpWrL5HOHuXSeXfFEGphoY=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Xmpr6nUl;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of leon@kernel.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=leon@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755629370;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=V0a8rCSgjkAz7gnhnXOKuD7c9T1R+bK+iGUt9hpQUxA=;
	b=Tk3Ypro0UU33m3bSRXmM0IpF7Aa6bnRv0BGViBBWovw0AELCU74thCOLvPhNjtyt7KRXhJ
	FY58Hamp/3E8woUvdTzgnjpijUwxoI5ev00ctr6WcjeypLmkUApHZOvLXnHPTY8xK6F7XD
	mJKucnXrHdecKBxkxcLVpyHqhy+0Fyc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by dfw.source.kernel.org (Postfix) with ESMTP id 8FB685C659B;
	Tue, 19 Aug 2025 18:49:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F0B9C4CEF4;
	Tue, 19 Aug 2025 18:49:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755629369;
	bh=7PY2nvBiFg+PmH3kasIozmSCqMsV1czCdVRZ4HT8eEo=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject:From;
	b=Xmpr6nUlxhT4ML+rFt1gIMnPEVpYqIqWjpUkgUQR5tX3Ea3qBYnKk1IyWsYC7sBet
	 QBsMrRk3r7iMu12daYBH1ylIKK33Dgbw2Y1MuCT43OUlbupun65NOdzuJa9IY8ytGJ
	 F2KoEBiwNJLZb2M/WkquLSxMBkG+zUTjWlAYLvA7NXHrkQmzA8GdxTTiqKCPXXi78g
	 mN0g5G7szNsgyUdSlZmbkMIIrt7pMw7M4uyf1LOzcmC10UoLlqg1CBOGjbTIEq00Ec
	 HfGNVq0UJwNkN4j62cFWRW+/HtCdXt1of9/eic9VtPkqlZST1PzxASg8IfYr3RIGmP
	 SUG+MxNe67pLw==
Received: from phl-compute-12.internal (phl-compute-12.internal [10.202.2.52])
	by mailfauth.phl.internal (Postfix) with ESMTP id 31D3DF40066;
	Tue, 19 Aug 2025 14:49:27 -0400 (EDT)
Received: from phl-imap-08 ([10.202.2.84])
  by phl-compute-12.internal (MEProxy); Tue, 19 Aug 2025 14:49:27 -0400
X-ME-Sender: <xms:NsekaGLkpYYn_tL5rT3yO_BkXqxiddfgdxidgKxcHaH-MXl652p3cQ>
    <xme:NsekaOJlIC7TCSjCwYmRCpvzsFljgqYaxuYOZolEbVOqnFcN0Yb2GZzTgHG2uybzM
    aWMSS4nJkDgbbBx7tg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdefgdduheeivdehucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepofggfffhvfevkfgjfhfutgfgsehtjeertdertddtnecuhfhrohhmpedfnfgvohhn
    ucftohhmrghnohhvshhkhidfuceolhgvohhnsehkvghrnhgvlhdrohhrgheqnecuggftrf
    grthhtvghrnhepjeevffelgfelvdfgvedvteelhefhvdffheegffekveelieevfeejteei
    leeuuedvnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomh
    eplhgvohhnodhmvghsmhhtphgruhhthhhpvghrshhonhgrlhhithihqdduvdeftdehfeel
    keegqddvjeejleejjedvkedqlhgvohhnpeepkhgvrhhnvghlrdhorhhgsehlvghonhdrnh
    hupdhnsggprhgtphhtthhopeefjedpmhhouggvpehsmhhtphhouhhtpdhrtghpthhtohep
    jhhorhhoseeksgihthgvshdrohhrghdprhgtphhtthhopehrohgsihhnrdhmuhhrphhhhi
    esrghrmhdrtghomhdprhgtphhtthhopehmphgvsegvlhhlvghrmhgrnhdrihgurdgruhdp
    rhgtphhtthhopegrsgguihgvlhdrjhgrnhhulhhguhgvsehgmhgrihhlrdgtohhmpdhrtg
    hpthhtoheprghlvgigrdhgrgihnhhorhesghhmrghilhdrtghomhdprhgtphhtthhopehr
    ohhsthgvughtsehgohhoughmihhsrdhorhhgpdhrtghpthhtohepghhlihguvghrsehgoh
    hoghhlvgdrtghomhdprhgtphhtthhopehkrghsrghnqdguvghvsehgohhoghhlvghgrhho
    uhhpshdrtghomhdprhgtphhtthhopehsrghgihesghhrihhmsggvrhhgrdhmvg
X-ME-Proxy: <xmx:N8ekaMdwa-bjfjKiy_bnjKe5pj-w5KnECjXqAsQ2QeQdV4SQA7pQwg>
    <xmx:N8ekaPdCW9gH5-vPa6JOMA4aaqp_1mwWnXjSovauczKDDBtpYQ57dA>
    <xmx:N8ekaKnKy6VKuw8SWj7LEaUJFkqm2rbcIMv54YWlw8KOdD3OfERqqw>
    <xmx:N8ekaE8iyeSnMuDLLObkGrzOSgmAQEbj_4QdVJQzRyQ8881Jp0dwDQ>
    <xmx:N8ekaGEni2UyRaNp_TjZoxjj4fIEinDxeQ57M5QUT8SDp3Eg6UepfRUM>
Feedback-ID: i927946fb:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id E45512CE0071; Tue, 19 Aug 2025 14:49:26 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
MIME-Version: 1.0
X-ThreadId: A0xmfm2pPGfg
Date: Tue, 19 Aug 2025 20:49:08 +0200
From: "Leon Romanovsky" <leon@kernel.org>
To: "Keith Busch" <kbusch@kernel.org>
Cc: "Marek Szyprowski" <m.szyprowski@samsung.com>,
 "Leon Romanovsky" <leonro@nvidia.com>,
 "Jason Gunthorpe" <jgg@nvidia.com>,
 "Abdiel Janulgue" <abdiel.janulgue@gmail.com>,
 "Alexander Potapenko" <glider@google.com>,
 "Alex Gaynor" <alex.gaynor@gmail.com>,
 "Andrew Morton" <akpm@linux-foundation.org>,
 "Christoph Hellwig" <hch@lst.de>, "Danilo Krummrich" <dakr@kernel.org>,
 iommu@lists.linux.dev, "Jason Wang" <jasowang@redhat.com>,
 "Jens Axboe" <axboe@kernel.dk>, "Joerg Roedel" <joro@8bytes.org>,
 "Jonathan Corbet" <corbet@lwn.net>, "Juergen Gross" <jgross@suse.com>,
 kasan-dev@googlegroups.com, linux-block@vger.kernel.org,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, linux-nvme@lists.infradead.org,
 linuxppc-dev@lists.ozlabs.org, linux-trace-kernel@vger.kernel.org,
 "Madhavan Srinivasan" <maddy@linux.ibm.com>,
 "Masami Hiramatsu" <mhiramat@kernel.org>,
 "Michael Ellerman" <mpe@ellerman.id.au>,
 "Michael S. Tsirkin" <mst@redhat.com>, "Miguel Ojeda" <ojeda@kernel.org>,
 "Robin Murphy" <robin.murphy@arm.com>, rust-for-linux@vger.kernel.org,
 "Sagi Grimberg" <sagi@grimberg.me>,
 "Stefano Stabellini" <sstabellini@kernel.org>,
 "Steven Rostedt" <rostedt@goodmis.org>, virtualization@lists.linux.dev,
 "Will Deacon" <will@kernel.org>, xen-devel@lists.xenproject.org
Message-Id: <82f3cf3c-960b-41bc-82a8-ce84353706ed@app.fastmail.com>
In-Reply-To: <aKTAVOBp0u6ZSC4w@kbusch-mbp>
References: <cover.1755624249.git.leon@kernel.org>
 <22b824931bc8ba090979ab902e4c1c2ec8327b65.1755624249.git.leon@kernel.org>
 <aKTAVOBp0u6ZSC4w@kbusch-mbp>
Subject: Re: [PATCH v4 14/16] block-dma: migrate to dma_map_phys instead of map_page
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: B816C180004
X-Stat-Signature: epsw45whaqn13w8913brxzcuugbc455a
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1755629370-934821
X-HE-Meta: U2FsdGVkX1/XUc6kkSrkUiHYaFYSyjKbStipf6ANgLUTH1XVbwxJ+sFwCABZzlFaIN2W36f6msu0vGnpBagA4fFh7A6+3SLc5gjSuTbRsNvTAQecGjZSAsh6QZe2ciWipQlyQiqO3c9T1SCqjSMwlzSQzHijO6D5BwLatviJjt7KRMgjureCPThMTtNlJ/H0n+dL2W2OhU96Kq/FbbYWiilYaYCD/cMfj1qkWWD9IgUBYV2t+yRXtINg+JEyYs0CMioIn7GW77LTzyhfv5IS+04xyXow6E8xo7b0tO8iXIfjhBBGbuRwaQLjJC+P1fEja0Cl7SJTqk77ix0mwaA2wmqhM7DNe2looaGh2TRo9kDxZi/6JrW/gN3YCcgOykayOvuRWe2T2mEel8vD+iNZ9ftoc4V338hnpJTOlzl5Jv0h6Cq3LZ7u+ZbPYc+KneTEqdaRQNhVjZcBU00dAp9SESzEegrVBKmol3MQfkNBFvORL0FN8kJcJiTVrjsvDxTFR8YtdIbE3hkVEeDTqq20WlZgkwv6NNUHZljQJJDHvBSrxhrXcOifb+/SGqJrfq/yNJs5v4rWr2EkLJJ1xjBa1ew8HvGEx+uNwnJjCyyoe9XmQhzVFIHhtuLOGRh+lA54hy/8v0nLOjy+HlnC5V9PHxJW8JgiymaQK2z3EKgP9kGDzq/bMkrQSY0rSQK+5AnymIf05nLNKp3B9QmvTmLlBTDrKGqCnWLAY+VxWaHUBEWSmhXoUPTF2NiqzOTVSsJDFOzFsp5vAk9IgAnfn71bJW4yi0vrsIEgVigapmGGjjsQNxCxmQx+wZ7b0nBfJPeUmbilrLkW3EAPl3HwNOl5G8aw1xgBZcINB6FohI9flCZJwDSzocLfeNYbWkwB8LaZj6f2xmmeci07zqpUBGKzc272fU3jVPrTzgLT4k+GL5I4Rwyv0vH35hjFMn+OEnqdh8Pt0BSkIGOhtwZKh+g
 0cclyJpg
 7G/NOeaoBlnKvjKaqbS4tMDgTchuIKBdpaKr5gzahLLrM0NQorTg+72QAEy0YRAtZmMK/k3c0pHUPIw5M7wSyzInxvwuVS4L3V9mxMkTp/74TfOmPtnaeGKDKLLuGhOPE/BaOBoF2aRhbYE6j5BonjWninChmcaG9B5GpvKVLH0ZYeaCuLafT/+NbOUXgY8XdgYRAfiJuw0Egtk18M9jsPa0Y8vMBkWNhVlGJsqZIETJh++gV/2tLn65jmCPn1zQLYTYoLyWJ2yBMVNlUiaZS+V5KXDACDvuy7NCwF9IAjQX2buXLIgWFSaYE4LbwIa0GK9GX7MZ6JBm9+QTPLq8brAXxUw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On Tue, Aug 19, 2025, at 20:20, Keith Busch wrote:
> On Tue, Aug 19, 2025 at 08:36:58PM +0300, Leon Romanovsky wrote:
>>  static bool blk_dma_map_direct(struct request *req, struct device *dma_dev,
>>  		struct blk_dma_iter *iter, struct phys_vec *vec)
>>  {
>> -	iter->addr = dma_map_page(dma_dev, phys_to_page(vec->paddr),
>> -			offset_in_page(vec->paddr), vec->len, rq_dma_dir(req));
>> +	iter->addr = dma_map_phys(dma_dev, vec->paddr, vec->len,
>> +			rq_dma_dir(req), 0);
>
> Looks good.
>
> Reviewed-by: Keith Busch <kbusch@kernel.org>
>
> Just a random thought when I had to double back to check what the "0"
> means: many dma_ api's have a default macro without an "attrs" argument,
> then an _attrs() version for when you need it. Not sure if you want to
> strictly follow that pattern, but merely a suggestion.

At some point,  I had both functions with and without attrs, but Christoph said that it is an artefact and I should introduce one function which accepts attrs but without _attrs in the name.

Thanks 

