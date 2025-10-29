Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 10293CCF9EB
	for <linux-mm@archiver.kernel.org>; Wed, 29 Oct 2025 18:21:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6F4B88E00C6; Wed, 29 Oct 2025 14:21:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6CC358E00B2; Wed, 29 Oct 2025 14:21:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5E2308E00C6; Wed, 29 Oct 2025 14:21:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 495FC8E00B2
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 14:21:46 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id EE2001408FF
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 18:21:45 +0000 (UTC)
X-FDA: 84051970170.01.01352F3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id DF78B120011
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 18:21:43 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=gFW23Htf;
	spf=pass (imf29.hostedemail.com: domain of leon@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761762104;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vF99+toDZDdN2wOCemWCahItQlBdLScG3Tc4V8O6SNI=;
	b=toXDbu7Q6NTlbFJ2mfEZStCzIfSY+NJBs7WDv5EG/OvEIXfpmRD9KHAkR9yXJSVyMcmu+W
	CRyyDIvrFisJWX7VYEd3tlo9i9RppuTiBc9HdJkdclKjjTaHhCnWsZCinHt6SPqYoVAVTZ
	M/BfJTCTEI8zRqiu6Qu/Q0SIla4Dt3Q=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=gFW23Htf;
	spf=pass (imf29.hostedemail.com: domain of leon@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761762104; a=rsa-sha256;
	cv=none;
	b=iI7unfQbNPl+mdqjOkC8hf4IFTjp5PiS8Z2N/ZxGewIj0CJF50L1+3nLoBs++Z2eyxoTrW
	EP/vk+oro6YPCUeWNDj3sIJJHz95P/lhX0a4Q2/ATP5fbhn2clopXJjMVYMsU1MQna6Cxd
	KMWLwPQMiaSzPuYZHIxiqScb9Ax24Vk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 8A61D418E1;
	Wed, 29 Oct 2025 18:21:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8F3CC4CEF7;
	Wed, 29 Oct 2025 18:21:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761762102;
	bh=DPpnCMRM2ONFlhs5+vFfnp4TspRDpdDt+xZVOrOrXxE=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject:From;
	b=gFW23Htfob9JVF7Tkn4OSf9AnrApu+I6w/WwRAqodqNSJgWV3LvyyA301zt0Uc/34
	 x6/VtvfQztzfWNSs4dCB24QCQ92FaoC3Ir0q1XCVKjJFK0mda3xuB3/1XZaRMFNUXz
	 eKchmNDyoozyoZ1HDSmEvBNDfCzBEX/JM9hSKH1faPH+eCNjYzQ8eolkTg1SxEnsuN
	 OiYGqp9kql+IT4pn3GRuJtUrP7KVnTg8oBjrsKkvR1gl2P1VWZJ1WaGGmovzTOQ08j
	 00jFA5M5GT40p+AGKTcPdvEO7j6lNxIAKnKsXGXjkZV2+V5oKvWkiHqhIxIa5TZ/hr
	 O23qaAx/QhODA==
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfauth.phl.internal (Postfix) with ESMTP id EBBEDF40069;
	Wed, 29 Oct 2025 14:21:40 -0400 (EDT)
Received: from phl-imap-08 ([10.202.2.84])
  by phl-compute-04.internal (MEProxy); Wed, 29 Oct 2025 14:21:40 -0400
X-ME-Sender: <xms:NFsCaVDOQpzKD7wTZgNCCgPb13e9mhCbRK36w5KK5UL_6Vz3kfOqqg>
    <xme:NFsCaeWLHPtpKhKZrslQ2gjrJtZvmfWKaeB-BNH71AIRQgkZgmY6dvyy7h1hVLqQY
    7vQeI-WSHuXH29wxJ06dzec-n0tAu4pMEPndl_0A5NlTk476sEDng0>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdeggdduieeggeefucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepofggfffhvfevkfgjfhfutgfgsehtjeertdertddtnecuhfhrohhmpedfnfgvohhn
    ucftohhmrghnohhvshhkhidfuceolhgvohhnsehkvghrnhgvlhdrohhrgheqnecuggftrf
    grthhtvghrnhepjeevffelgfelvdfgvedvteelhefhvdffheegffekveelieevfeejteei
    leeuuedvnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomh
    eplhgvohhnodhmvghsmhhtphgruhhthhhpvghrshhonhgrlhhithihqdduvdeftdehfeel
    keegqddvjeejleejjedvkedqlhgvohhnpeepkhgvrhhnvghlrdhorhhgsehlvghonhdrnh
    hupdhnsggprhgtphhtthhopedvgedpmhhouggvpehsmhhtphhouhhtpdhrtghpthhtohep
    jhhorhhoseeksgihthgvshdrohhrghdprhgtphhtthhopegthhhrihhsthhirghnrdhkoh
    gvnhhighesrghmugdrtghomhdprhgtphhtthhopehrohgsihhnrdhmuhhrphhhhiesrghr
    mhdrtghomhdprhgtphhtthhopehlohhgrghnghesuggvlhhtrghtvggvrdgtohhmpdhrtg
    hpthhtoheprghmrghsthhrohesfhgsrdgtohhmpdhrtghpthhtohepsghhvghlghgrrghs
    sehgohhoghhlvgdrtghomhdprhgtphhtthhopehvihhvvghkrdhkrghsihhrvgguugihse
    hinhhtvghlrdgtohhmpdhrtghpthhtoheprgigsghovgeskhgvrhhnvghlrdgukhdprhgt
    phhtthhopeifihhllheskhgvrhhnvghlrdhorhhg
X-ME-Proxy: <xmx:NFsCaUzjtyzcUVu3XHD3WVhral27CzlLF39AneDrzievZ37OsGY-GA>
    <xmx:NFsCaRUFAQz6l_v7A2JkDReVdjjdcI-Y2IcFNcrwrHcfSX10RiJcNQ>
    <xmx:NFsCafZkyPDABk8DELRQCYDmg48L5nSl4vq1dKK-pP8IizJlTTWYMg>
    <xmx:NFsCaeR_shcDrhZPGvArnf4UbT0ylRaXp3-PRr2Wr-isMOf0OBIlZw>
    <xmx:NFsCafRS72r3S4Uq0J_JrwdIdBgQm6Y4YZw8AGtHru_SaMGZiKXRtxaV>
Feedback-ID: i927946fb:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id B52662CE0071; Wed, 29 Oct 2025 14:21:40 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
MIME-Version: 1.0
X-ThreadId: AwB0iom3SqON
Date: Wed, 29 Oct 2025 20:21:20 +0200
From: "Leon Romanovsky" <leon@kernel.org>
To: "Alex Mastro" <amastro@fb.com>
Cc: "Alex Williamson" <alex.williamson@redhat.com>,
 "Leon Romanovsky" <leonro@nvidia.com>, "Jason Gunthorpe" <jgg@nvidia.com>,
 "Andrew Morton" <akpm@linux-foundation.org>,
 "Bjorn Helgaas" <bhelgaas@google.com>,
 =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>,
 dri-devel@lists.freedesktop.org, iommu@lists.linux.dev,
 "Jens Axboe" <axboe@kernel.dk>, "Joerg Roedel" <joro@8bytes.org>,
 kvm@vger.kernel.org, linaro-mm-sig@lists.linaro.org,
 linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-media@vger.kernel.org, linux-mm@kvack.org, linux-pci@vger.kernel.org,
 "Logan Gunthorpe" <logang@deltatee.com>,
 "Marek Szyprowski" <m.szyprowski@samsung.com>,
 "Robin Murphy" <robin.murphy@arm.com>,
 "Sumit Semwal" <sumit.semwal@linaro.org>,
 "Vivek Kasireddy" <vivek.kasireddy@intel.com>,
 "Will Deacon" <will@kernel.org>
Message-Id: <275a5a94-1c69-4eb0-a9d0-4b397073555f@app.fastmail.com>
In-Reply-To: <aQJF1wiWWWoIgHI0@devgpu015.cco6.facebook.com>
References: <cover.1760368250.git.leon@kernel.org>
 <72ecaa13864ca346797e342d23a7929562788148.1760368250.git.leon@kernel.org>
 <aQJF1wiWWWoIgHI0@devgpu015.cco6.facebook.com>
Subject: Re: [PATCH v5 9/9] vfio/pci: Add dma-buf export support for MMIO regions
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: DF78B120011
X-Stat-Signature: 7sr9i5gbkzozfxb4rpizjdyxg6fxif7a
X-Rspam-User: 
X-HE-Tag: 1761762103-12647
X-HE-Meta: U2FsdGVkX19ooyNETNYvVjL461Ct1nUK5bzWSovzEp7w8eSILFvxOaWzKkp+8nUKoLVUYVVBJsIeaP2Nu+5lWL6v1S4T+thSeMWL8cJh+uPJr27+L+iXoWYiGIvePEJut+oBY9M0YrKmIRtPFZQupU10+YZzkC4ndh0H9ilrpW/0fCiUDQkK8tEaKmLI3m/c/zR0jnZxjDo/2keIr+QqB3tX11oh1/K/cW2s+r4i4dbPrXZD+Z4+BO+b8ECk4JCvbbzIw3978JsnB7v/xZJs16eiUOqLu7E59p9vyP4tlkgAB/4W1OaWGD3CdYX6tqvY+9WMemThcpIBiUto3XDwZDzmcdmGS3kG6u6FWPVHdVUzmxikXLNWn2Bz5kleU19aH/unkppa+e0yxsLirUtYP4+zIrdElSz4MtArniT6k/B2oS+2pL1kdS3YmtSD07Ktga0w5uOPR0C+RSi1AyGz4tkWt3NnN691RjbLnTxgmrfIZrXt7bvqz8LkIE2h9SWif9/hG+AfclHu+DWy1SAiZASiiJ9XzvjuBCJlITYwtdMf8E9uutz8rOrSRDUfvu3qqC2lsNYYen9XvAfMlPjgcSYaILdT70fjq6jAxI6tV6zS5yA1VSXCmVgKoECNJmoUiN2wnwv//hzy69D2oJviqueHn4J/c65I6SbSkVo5Duqfe+76lTCAJP9zEiv5pVZX/Dhsow7uST7g8B125uuKUysbG6O5PKfT8Z090EkA91FjGf/pdfMbq5q+KZO+SxDsUdRXue6Co4EMLPYeStWZVsN8hHE48o5vMeFvSpCHajT1cZ7iX3/V90JSHFC81jmKZMRiuvZHa1DGwH7oNkihGTLU/H+/s1KiY2fW55fcTshjjw+Q0XBivg+vDU2H9pPcEIRwta3BjEuHTKhIQ/Jh340o5pzs2YMPu75c9/bKBFKS4NdjdaBXHERZX/SRNKog5+NoJx7CTf1K9WZCpKL
 2/Eta+Ar
 zQ0O09LcEvKkmB5cXgjhb6LBhc/gr62Gj1nK8HisH6akdZXgbEFBROZBTwcpT4bPh7ujGphMoSp0YG4g6XEAjiekKX8RQQNo9B4cBT7DjDL/BrZzA5/98eNZ5nfrTt9byv0BPwhZSPaJPlUBXSwjKDvnVMAIw/8gvsGEP
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On Wed, Oct 29, 2025, at 18:50, Alex Mastro wrote:
> On Mon, Oct 13, 2025 at 06:26:11PM +0300, Leon Romanovsky wrote:
>> +	/*
>> +	 * dma_buf_fd() consumes the reference, when the file closes the dmabuf
>> +	 * will be released.
>> +	 */
>> +	return dma_buf_fd(priv->dmabuf, get_dma_buf.open_flags);
>
> I think this still needs to unwind state on fd allocation error. Reference
> ownership is only transferred on success.

Yes, you are correct, i need to call to dma_buf_put() in case of error. I will fix.

Thanks

>
>> +
>> +err_dev_put:
>> +	vfio_device_put_registration(&vdev->vdev);
>> +err_free_phys:
>> +	kfree(priv->phys_vec);
>> +err_free_priv:
>> +	kfree(priv);
>> +err_free_ranges:
>> +	kfree(dma_ranges);
>> +	return ret;
>> +}

