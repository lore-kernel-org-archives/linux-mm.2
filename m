Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DCF32C79FAF
	for <linux-mm@archiver.kernel.org>; Mon,  5 Jan 2026 17:24:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3DFBF6B01F3; Mon,  5 Jan 2026 12:24:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 38CB36B01F5; Mon,  5 Jan 2026 12:24:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 286016B01F6; Mon,  5 Jan 2026 12:24:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1155A6B01F3
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 12:24:59 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id AEF17139A35
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 17:24:58 +0000 (UTC)
X-FDA: 84298585476.05.C7B6C80
Received: from ale.deltatee.com (ale.deltatee.com [204.191.154.188])
	by imf03.hostedemail.com (Postfix) with ESMTP id 5CC9720002
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 17:24:56 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=deltatee.com header.s=20200525 header.b=Jap+phMR;
	spf=pass (imf03.hostedemail.com: domain of logang@deltatee.com designates 204.191.154.188 as permitted sender) smtp.mailfrom=logang@deltatee.com;
	dmarc=pass (policy=quarantine) header.from=deltatee.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767633896;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nPXCpaMeKr8anhQvykVWaeOhAh4K2CJRGmcFaO12UK0=;
	b=Xhu6wYXXtrsdu89lAiuadj1305Zn2MXJVNq2VJ7HUTxK0QEH98HobPD0i99XI8aXjz4CVs
	TP5q7Ovdg0oz4G5ln4YlMqTZIwueQy5v+wWrC4sE+2q0iiiJ3P5RUB1pZ1xh/ScNFBYWC9
	HZ0DgEnHdio3lnSx4JzpyZ/aNLrkqgM=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=deltatee.com header.s=20200525 header.b=Jap+phMR;
	spf=pass (imf03.hostedemail.com: domain of logang@deltatee.com designates 204.191.154.188 as permitted sender) smtp.mailfrom=logang@deltatee.com;
	dmarc=pass (policy=quarantine) header.from=deltatee.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767633896; a=rsa-sha256;
	cv=none;
	b=ZhKhEBKbgDIAsQehlK9Q+TV62UwiWGbwv1uz/xsoVXTz+Lae7Ps1tS+BvpEmXIChijxtLL
	wX2GQTBdbwAZ0Od5x+tMmCotyD2ibF5RLJZrN00f3amrtGo95kWW29MgllHsmtTCjLSqpw
	azO8xDzLLXUtHpIe/gi24Da8I46pglY=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=deltatee.com; s=20200525; h=Subject:In-Reply-To:From:References:Cc:To:
	MIME-Version:Date:Message-ID:content-disposition;
	bh=nPXCpaMeKr8anhQvykVWaeOhAh4K2CJRGmcFaO12UK0=; b=Jap+phMRmtmaCkqb9qwsgwj7JI
	nMb91j6DyoHvobSJzXUHGruB3Md3M3d+UdUDnY8fFM6Y5JkrTYHdUS2o9O6mpHaDQTTc0u/yInpwo
	AYAaUQQgA9xT5m6foMA/rc4K/cc8QTvc9kZKNSpiT04fGCUVkkKn6cyZr+yyC+UAkbXMP8D/oajbc
	RmXXZoikMBxNLvXL0mdn+hM0em/4gcWamJK4HCbXZbeMe+bpjqXZ5NpCPt6E0HzlOIBdwy9FJpwPQ
	KsZt6XtHv/FPrBYPCBxljHV5iyzEuLykHtPMXVOR7zpqsmVQ0nDXEPdkFH5tZ9nr0hmCI4iEHwHL1
	vZdU8p+A==;
Received: from guinness.priv.deltatee.com ([172.16.1.162])
	by ale.deltatee.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.98.2)
	(envelope-from <logang@deltatee.com>)
	id 1vcoK6-00000000l4E-1xnz;
	Mon, 05 Jan 2026 10:24:55 -0700
Message-ID: <1a6ff388-c282-42c7-a0a2-d8b2f5ed720b@deltatee.com>
Date: Mon, 5 Jan 2026 10:24:33 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
To: Hou Tao <houtao@huaweicloud.com>, linux-kernel@vger.kernel.org
Cc: linux-pci@vger.kernel.org, linux-mm@kvack.org,
 linux-nvme@lists.infradead.org, Bjorn Helgaas <bhelgaas@google.com>,
 Alistair Popple <apopple@nvidia.com>, Leon Romanovsky <leonro@nvidia.com>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Tejun Heo <tj@kernel.org>,
 "Rafael J . Wysocki" <rafael@kernel.org>, Danilo Krummrich
 <dakr@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Keith Busch
 <kbusch@kernel.org>, Jens Axboe <axboe@kernel.dk>,
 Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>,
 houtao1@huawei.com
References: <20251220040446.274991-1-houtao@huaweicloud.com>
 <20251220040446.274991-11-houtao@huaweicloud.com>
 <07a785e5-5d2e-4c81-a834-1237c79fdd51@deltatee.com>
 <beb61666-020a-d99e-e84f-c16111039e66@huaweicloud.com>
Content-Language: en-CA
From: Logan Gunthorpe <logang@deltatee.com>
In-Reply-To: <beb61666-020a-d99e-e84f-c16111039e66@huaweicloud.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 172.16.1.162
X-SA-Exim-Rcpt-To: houtao@huaweicloud.com, linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org, linux-mm@kvack.org, linux-nvme@lists.infradead.org, bhelgaas@google.com, apopple@nvidia.com, leonro@nvidia.com, gregkh@linuxfoundation.org, tj@kernel.org, rafael@kernel.org, dakr@kernel.org, akpm@linux-foundation.org, david@kernel.org, lorenzo.stoakes@oracle.com, kbusch@kernel.org, axboe@kernel.dk, hch@lst.de, sagi@grimberg.me, houtao1@huawei.com
X-SA-Exim-Mail-From: logang@deltatee.com
Subject: Re: [PATCH 10/13] PCI/P2PDMA: support compound page in
 p2pmem_alloc_mmap()
X-SA-Exim-Version: 4.2.1 (built Sun, 23 Feb 2025 07:57:16 +0000)
X-SA-Exim-Scanned: Yes (on ale.deltatee.com)
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 5CC9720002
X-Stat-Signature: whh1ryir1zhyjo74tdxfo36mpar5bbpg
X-HE-Tag: 1767633896-809744
X-HE-Meta: U2FsdGVkX180CLvj78F3gTsOVWJabOAzt8OfWVuS2It+ipaJo0ljSRdolwAnT/ATIuE4KpnhNyMBxTPQzvbJ4Go5kTkgQYzNFclMvtblE7MllM0BaNuYCOZuQBWZ6MY15e3qOyv1JVdYoBhy+5BYGrbnLi8pIkDIrQ6FfDpDBaFAYHE5rhRVaMn8GxvJRAV22W36odQDEfK7MpPSkqC0U9MvsBOuj2RiCzPjwQBykdLlQcBk3Vr5dV7a7Xg74rTS55FnnuasOF6Y9BpxNCS6R3sZXv0qwyMLK2lTZ93JqGgL5m+BsYr6URqPbGcoGYPVFpECQIHvFVBizE0PTHY47mMcmKqwweqCW36fbxz/aT4VbePHZi3g4ktk2kzzx1vE1D4kCUcIU3yJ/epBCvHu89WX/OfQ9nko4U9zwMm5zE0qJRc/uRuehrFk6ioGJJlopWYsWWoKaMTT27s3ela4GQ3p5S3scYToaZuvqSg+RqGHaOHgFqNomuE9hUR+wL3QbMpyVMNECAfe0JoVJ+71gqtIdi8arF9igRK4zre86jPDjuHQ0RIBhMfqb9opy0izwk9mGvWi352naK+gRSxajCMqzcPo3N0x7NvWKGCo4yLZB3jvKhTe1cGKgT3eaFHDgpyyxqsLTM/TFJNsfdUZdYf7upvfCMXG0e7tZ7PTqgd8naysqQcbW6XewU4XfOFHPctRSd0Dnz/bFg37FxInFASjIfkS1kidsF/iPguFz9deaYwwbt+04r3sHPN5037+kGIr/RJPHw5KX4tHO/Wo6t0QNbFvMuC2ftDa16IdLnIHZtdMzaeue4wLHXkRuWCo8ZfL0CJRJ9AygKW7VuWRB3GxDi/xCLg6yan3lRpl8mzps2YWye1aW/3P8TbHFp3nTXSyk6IMnlPZ4AUHzLeZGMmTr1ZEwJ6kpeG252jA5T4U80n76it6HrGd+EEPiZtNava895ie3YWwn9Ri/YQ
 Id+poWq4
 ykM6hqyZGrRv2XnMlXDgZfA0el5cokUHDc1GULO1BL3V5d5bIABRq9S0OX0WAWk/hd+dc876dIDtDpz3TB+KuZllFq3vYkxsiDsvZ/0ASylwQsGYR5qkyDI9L4RWCCVX8LYqj4xuLdY2R2zV0Lkc9wXitL0MEC0x1ikkg1bhYBzizv/xRGLdRbCsTxx88L+eSXawt2JdEdaAitV/MpTAzGluIVPUCaqFAR8Ut4wARr+/GNcwmyBt2FhjyD7iO+BsGqqwp6/MFiU7y3bN6toRN4D/4NlN4Qt2KbFy/aPzeruIq9vfuOxepy2rnaqSOmE0t2M3Qz0EfpMKIa73cZo5XKB/krP+NCau3uBH2
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

>> I'm a bit confused by some aspects of these changes. Why does the
>> alignment become a property of the PCI device? It appears that if the
>> CPU supports different sized huge pages then the size and alignment
>> restrictions on P2PDMA memory become greater. So if someone is only
>> allocating a few KB these changes will break their code and refuse to
>> allocate single pages.
>>
>> I would have expected this code to allocate an appropriately aligned
>> block of the p2p memory based on the requirements of the current
>> mapping, not based on alignment requirements established when the device
>> is probed.
> 
> The behavior mimics device-dax in which the creation of device-dax
> device needs to specify the alignment property. Supporting different
> alignments for different userspace mapping could work. However, it is no
> way for the userspace to tell whether or not the the alignment is
> mandatory. Take the below procedure as an example:

Then I don't think the approach device-dax took makes sense for p2pdma.

> 1) the size of CMB bar is 4MB
> 2) application 1 allocates 4KB. Its mapping is 4KB aligned
> 3) application 2 allocates 2MB. If the allocation from gen_pool is not
> aligned, the mapping only supports 4KB-aligned mapping. If the
> allocation support aligned allocation, the mapping could support
> 2MB-aligned mapping. However, the mmap implementation in the kernel
> doesn't know which way is appropriate. If the alignment is specified in
> the p2pdma, the implement could know the aligned 2MB mapping is appropriate.

Specifying a minimum alignment as a property of the p2pdma device makes
no sense to me.

I think the p2pdma code should just make the best effort to get the
highest aligned buffer for the allocation it can. If it can not, it
falls back to just getting page aligned buffers. We might have to make
some minor modifications to genalloc to create an aligned version of the
allocator (similar to gen_pool_dma_alloc_align()).

Logan

