Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 95DB5CA101F
	for <linux-mm@archiver.kernel.org>; Sun,  7 Sep 2025 14:25:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 550D08E0003; Sun,  7 Sep 2025 10:25:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 501C58E0001; Sun,  7 Sep 2025 10:25:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3F0A38E0003; Sun,  7 Sep 2025 10:25:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 287228E0001
	for <linux-mm@kvack.org>; Sun,  7 Sep 2025 10:25:25 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C7B625B81A
	for <linux-mm@kvack.org>; Sun,  7 Sep 2025 14:25:24 +0000 (UTC)
X-FDA: 83862676968.12.ABD05B5
Received: from fhigh-a3-smtp.messagingengine.com (fhigh-a3-smtp.messagingengine.com [103.168.172.154])
	by imf06.hostedemail.com (Postfix) with ESMTP id BB8BC180004
	for <linux-mm@kvack.org>; Sun,  7 Sep 2025 14:25:22 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=sakamocchi.jp header.s=fm1 header.b=LxAEL1hA;
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=gkkyoHxl;
	spf=pass (imf06.hostedemail.com: domain of o-takashi@sakamocchi.jp designates 103.168.172.154 as permitted sender) smtp.mailfrom=o-takashi@sakamocchi.jp;
	dmarc=pass (policy=none) header.from=sakamocchi.jp
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757255122;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:dkim-signature;
	bh=G/EPaorfj+fFyTEHaVMF0Aq5nU/5YHn8ZldlmV9nSRU=;
	b=jMbprQxgr1BasivNPg4a3zpxRzGKyYwbI8Te8ikqeTyYb6RT8kiNZc7KAfC6qf6IDsj+cp
	ZNyjMMMjMO0esM9H+BczHTbqxyDkHFVvKhirSmal9kCmT2ztxWqdAfwfxHHEvP4LtcZq9X
	ZPGsoYwrlQkH+QrjY61p68zeu9sMFWM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757255122; a=rsa-sha256;
	cv=none;
	b=4/Jg3R0Iu/9cZhZcmfUU20nYBs2mVP4DV3na9xmK733fJbmcTOc14h+fO3k16sdw+6K65z
	VqAs8kvqTl2ljawGOO0qPmezBv0jQNWZWRdoOMuKAAyTKxB17ItsXA4qJ9xWVpr71p7sv7
	naSjWmCHueLc2jYC70piCc+o5u7IDi4=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=sakamocchi.jp header.s=fm1 header.b=LxAEL1hA;
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=gkkyoHxl;
	spf=pass (imf06.hostedemail.com: domain of o-takashi@sakamocchi.jp designates 103.168.172.154 as permitted sender) smtp.mailfrom=o-takashi@sakamocchi.jp;
	dmarc=pass (policy=none) header.from=sakamocchi.jp
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfhigh.phl.internal (Postfix) with ESMTP id C2941140003F;
	Sun,  7 Sep 2025 10:25:21 -0400 (EDT)
Received: from phl-mailfrontend-01 ([10.202.2.162])
  by phl-compute-04.internal (MEProxy); Sun, 07 Sep 2025 10:25:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sakamocchi.jp;
	 h=cc:cc:content-type:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:reply-to
	:subject:subject:to:to; s=fm1; t=1757255121; x=1757341521; bh=G/
	EPaorfj+fFyTEHaVMF0Aq5nU/5YHn8ZldlmV9nSRU=; b=LxAEL1hA32JcJEnG98
	oeJWFJW96Ab1ZdHJgGFlspwkJEj8Aiavk+dntTuQR94KmnDxtmALl7CB+fX7pbmo
	zvwHV9izosIpgEyayMmq4HTHRSL2iK4fMKWHMvvD41vWIEJCTnEIIqxOvjqUMPdN
	FaaZNPb2cDEYVHxVXwipUcCnSOWtlHTWUV9b7UKVDN46YphS5bUyXSD3O2FSIvg3
	JUD1TcNnZpGiXsQ7MCTj1TVHQ3ohhj+xY79FbL/+BRd7wIICp8XkFAHyKTyD/8lm
	yl+rKrALxeGxgT5Cn2F0n3Vujw7PsQdn7K1EKLloRiZFtuJG1JI5PkcjOkt6ZukQ
	tPFQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:reply-to:subject:subject:to:to
	:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=
	1757255121; x=1757341521; bh=G/EPaorfj+fFyTEHaVMF0Aq5nU/5YHn8Zld
	lmV9nSRU=; b=gkkyoHxlYwH2iEfC+POnjbirfwG9a7+WNBFdUULpIUfCF6QwBKD
	CXcsXkweDWwsQzN7Gd/GbXOk1SV+QIJUgWkOe1GLc0VVeUYBy346pR/YD304mG7z
	1ztsB7KcR9c74q1QJaQIjsplL9rOCD+fGXEZYd3b1CaBQnjtDDPbNZDWICkLf5pp
	E+qxogYXjT9un6LXfyJoljBVnMPFxj2E3BW22x2ShtmyGXx44gZthxk9ic+CJ+5v
	xe6lmL0VZ16DWgsUqgTs96f66G7saKooHJEnRz+Yld+xGqzw4yGMu+xPzsXFPe8w
	GNdDDSQNNRcQqEmj5hrowrarHbImiv5H7QA==
X-ME-Sender: <xms:zpW9aHBBt0nmuBo9smDJ2pyc66XAz51H2zLxPIL-bKuIIirEqr75FQ>
    <xme:zpW9aP5GM0Oa9oXSpXiYSqnaKLnHMrts9xFSY3EInc6RNC_Ob2dxgDJB8d83jBdim
    fy3XXGQESbNHiHsUNQ>
X-ME-Received: <xmr:zpW9aNLIKTgt7t1RechOqALMeiJc4jvDTVIeA0j8Y6R9TLQOMTuGJFNVHgmJLi83Qw1w6W0IAc1sMtpcdOdKwHPv5EDXH_yn>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdeggddugeekkecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjug
    hrpeffhffvvefukfggtggujgesthdtredttddtvdenucfhrhhomhepvfgrkhgrshhhihcu
    ufgrkhgrmhhothhouceoohdqthgrkhgrshhhihesshgrkhgrmhhotggthhhirdhjpheqne
    cuggftrfgrthhtvghrnhepveehudehueekveelteevkeevkeeiudfgtdeivdehjeetffdt
    vdeukeekheeitdetnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilh
    hfrhhomhepohdqthgrkhgrshhhihesshgrkhgrmhhotggthhhirdhjphdpnhgspghrtghp
    thhtohepfeeipdhmohguvgepshhmthhpohhuthdprhgtphhtthhopehjghhgsehnvhhiug
    hirgdrtghomhdprhgtphhtthhopehmrdhsiiihphhrohifshhkihesshgrmhhsuhhnghdr
    tghomhdprhgtphhtthhopegrsgguihgvlhdrjhgrnhhulhhguhgvsehgmhgrihhlrdgtoh
    hmpdhrtghpthhtohepghhlihguvghrsehgohhoghhlvgdrtghomhdprhgtphhtthhopegr
    lhgvgidrghgrhihnohhrsehgmhgrihhlrdgtohhmpdhrtghpthhtoheprghkphhmsehlih
    hnuhigqdhfohhunhgurghtihhonhdrohhrghdprhgtphhtthhopehhtghhsehlshhtrdgu
    vgdprhgtphhtthhopegurghkrheskhgvrhhnvghlrdhorhhgpdhrtghpthhtohepihhomh
    hmuheslhhishhtshdrlhhinhhugidruggvvh
X-ME-Proxy: <xmx:zpW9aESQOTluGcoqM_cunEP_CQ11Qvxrpy5aGTfr1MzqwvK2MTzWog>
    <xmx:zpW9aFHJqGCH6u0UWGJG3VtNOeC2T8wJ8cwxckTphVMd0qLeV964DA>
    <xmx:zpW9aNpr-peDJ1nPk1kSevLyeyufAy3XpVeJTpuplknDlKhO7wcF7A>
    <xmx:zpW9aLNxtTkNoAukVHmomnYFXm7ah-6QwcR2-dfdjXXF-bo6zSTB0A>
    <xmx:0ZW9aEVsvUTTHZprT5gFlKyXEiCBT6fpdOnxgCny8ixcqLiQ3QkTgVqI>
Feedback-ID: ie8e14432:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 7 Sep 2025 10:25:11 -0400 (EDT)
Date: Sun, 7 Sep 2025 23:25:09 +0900
From: Takashi Sakamoto <o-takashi@sakamocchi.jp>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
	Abdiel Janulgue <abdiel.janulgue@gmail.com>,
	Alexander Potapenko <glider@google.com>,
	Alex Gaynor <alex.gaynor@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christoph Hellwig <hch@lst.de>, Danilo Krummrich <dakr@kernel.org>,
	iommu@lists.linux.dev, Jason Wang <jasowang@redhat.com>,
	Jens Axboe <axboe@kernel.dk>, Joerg Roedel <joro@8bytes.org>,
	Jonathan Corbet <corbet@lwn.net>, Juergen Gross <jgross@suse.com>,
	kasan-dev@googlegroups.com, Keith Busch <kbusch@kernel.org>,
	linux-block@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	linux-nvme@lists.infradead.org, linuxppc-dev@lists.ozlabs.org,
	linux-trace-kernel@vger.kernel.org,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Michael Ellerman <mpe@ellerman.id.au>,
	"Michael S. Tsirkin" <mst@redhat.com>,	Miguel Ojeda <ojeda@kernel.org>,
	Robin Murphy <robin.murphy@arm.com>, rust-for-linux@vger.kernel.org,
	Sagi Grimberg <sagi@grimberg.me>,
	Stefano Stabellini <sstabellini@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,	virtualization@lists.linux.dev,
 Will Deacon <will@kernel.org>,	xen-devel@lists.xenproject.org
Subject: Re: [PATCH v4 00/16] dma-mapping: migrate to physical address-based
 API
Message-ID: <20250907142509.GA507575@workstation.local>
Mail-Followup-To: Jason Gunthorpe <jgg@nvidia.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Abdiel Janulgue <abdiel.janulgue@gmail.com>,
	Alexander Potapenko <glider@google.com>,
	Alex Gaynor <alex.gaynor@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christoph Hellwig <hch@lst.de>, Danilo Krummrich <dakr@kernel.org>,
	iommu@lists.linux.dev, Jason Wang <jasowang@redhat.com>,
	Jens Axboe <axboe@kernel.dk>, Joerg Roedel <joro@8bytes.org>,
	Jonathan Corbet <corbet@lwn.net>, Juergen Gross <jgross@suse.com>,
	kasan-dev@googlegroups.com, Keith Busch <kbusch@kernel.org>,
	linux-block@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	linux-nvme@lists.infradead.org, linuxppc-dev@lists.ozlabs.org,
	linux-trace-kernel@vger.kernel.org,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Michael Ellerman <mpe@ellerman.id.au>,
	"Michael S. Tsirkin" <mst@redhat.com>,	Miguel Ojeda <ojeda@kernel.org>,
	Robin Murphy <robin.murphy@arm.com>, rust-for-linux@vger.kernel.org,
	Sagi Grimberg <sagi@grimberg.me>,
	Stefano Stabellini <sstabellini@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,	virtualization@lists.linux.dev,
 Will Deacon <will@kernel.org>,	xen-devel@lists.xenproject.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250905174324.GI616306@nvidia.com>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: BB8BC180004
X-Stat-Signature: stfxut4mh3kob3ersa7r7sktcedgmxp8
X-HE-Tag: 1757255122-8432
X-HE-Meta: U2FsdGVkX18vQQmUdv5UzEaDmkVyyGQBLBbtCbM0Z3rmQSEtjwZ/PWfdcMwBE7Gcu4JcASYaPTI6oFpt2yaoTm4bRGvGQxp3R2vvvqyow3g4cHCBtIgzmfDn7bn19OAjDotkuwALQ53Kj8nixMd0lUJgl470mq/of+sCBdJkh/OMCDEf0gAU5pc6oV1JyrKcFWem0IC/tczZLtXuYOrkjYz1+dxvg2UbPhtGPiq8tXicFFkKAoOxcSbce139E/f/Zd0k2cFiv113MfRtO5cLf+PO1CWcbsv4MV6YmpzkzsQZokT4jHoIL0Ixyc/d8u65Zvw//SZPSrm6Sovvg8qoOoDywJ+GEXgsngVIDW1zYFNC262bPXHgGYLmxwjLv7fFYczIghHS8+bqv468Du6Yjo8P8fRyXsM/vXu0EgG6FzJOGsO8sE9N4YZ+V/UIh/dL0SYPOtnodfgtNvD/9LITObf6+Q2u5EU8bPxhmT+W8GSouuxXNK+bBImVtYHK4jbNiwytly1BwP8UAMjik6bOo4L5F6PWEbJ6lHIFrxo303cXC7pJom+kf06rvFJzkRS+L56FI2symIMXPXsBOEwfoflYRpy/9t1F5Tw/lQTpZsQbDFKMQZimtYb1/Tz59rWps2xc3HxmxIGWwlpKo/ShoA0Pgos5NW7UK+s2eaPtOgMxjYmqya/9TwhQEfUGM4woce1NMsODZ+vRSheaKtBYUFeXHU9mAStY6OgwgRVJQRR4i+25WLLknUDaiEkFvFSex8VD37NzEyOcD5vr5DWyEPP3BWwpbLucAiwkKiLFseI14fS+Pfb+6YRtTS43RHhcJRdq5QK11mMu3+SgLfQg3TdgQzWsGyuwMVl03LoXWvDaM28Lm4ASYe5rnH7NbokkMNN0abYtPlUv5J9ZGbPgjIcLur8CY4AtqArVYPcPXW4+yPBkmig3VhyrHMuQhB2rTkILGQkgaU14mq3Tt53
 48s5ktvF
 bRNO+0uA76q0i6vhiPWdHFafPtg253Zl7/VK0cCB1b5l1eyW7sv9HRFD4U/Ye33mQxeGV43s2OZr2H4MnkEaYBmvh1pnZPIhCKaUHGCwH1kpIocjnWk2k+dMKlPeeGKKsqlrQDHamclfDKtydqCiKtYKm6zkX8Xb3hs9Vqn+BTAyeph0OV+ft802+t9hhviPp8BjxtSB0avdhCgqwUJxZZdLdofZnu2JJZ77ctuGaIyDvLaoN5F+OdmRrRIPeZQsM21V7Umv8tifl2VpxnYss13NouLBfZc35QNZlb/G3PomuUXPodlUERSaHTFB+54uIoWoR4J6t6cWxV/8HfUKUBBaWCMi6tKtOMUMH4wYOmUil53I=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

I'm a present maintainer of Linux FireWire subsystem, and recent years
have been working to modernize the subsystem.

On Fri, Sep 05, 2025 at 14:43:24PM -0300, Jason Gunthorpe wrote:
> There is only one user I found of alloc_pages:
>
> drivers/firewire/ohci.c:                ctx->pages[i] = dma_alloc_pages(dev, PAGE_SIZE, &dma_addr,
>
> And it deliberately uses page->private:
>
>		set_page_private(ctx->pages[i], dma_addr);
>
> So it is correct to use the struct page API.

I've already realized it, and it is in my TODO list to use modern
alternative APIs to replace it (but not yet). If you know some
candidates for this purpose, it is really helpful to accomplish it.


Regards

Takashi Sakamoto

