Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C9AABD0D176
	for <linux-mm@archiver.kernel.org>; Wed,  7 Jan 2026 21:23:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3B9B06B0088; Wed,  7 Jan 2026 16:23:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3912B6B0092; Wed,  7 Jan 2026 16:23:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 290826B0093; Wed,  7 Jan 2026 16:23:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 172BA6B0088
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 16:23:18 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 91122B9A49
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 21:23:17 +0000 (UTC)
X-FDA: 84306443634.25.B7E198C
Received: from ale.deltatee.com (ale.deltatee.com [204.191.154.188])
	by imf30.hostedemail.com (Postfix) with ESMTP id 7B4D080012
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 21:23:15 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=deltatee.com header.s=20200525 header.b=sAs7KK64;
	spf=pass (imf30.hostedemail.com: domain of logang@deltatee.com designates 204.191.154.188 as permitted sender) smtp.mailfrom=logang@deltatee.com;
	dmarc=pass (policy=quarantine) header.from=deltatee.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767820995;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UkZv5onkyAXg00ymNzmBDBe0GBLZo5D/WkzgMa+G8aE=;
	b=ujlsvJcS7XYbafJ1ht82csYF9Hc1YGEEEzWYJirHX3T8btcKw4qIujrzfKS/Mvzmz87gF/
	KFX6VskSUPWuroY8gDOn1Qa+omcy4XsNwoRhY38DCkNANp7ZRkCZ6RjHazDZhDwyWfgnZr
	F7yTd0h3jKnY8x5xDPnfc4/ulHimxaI=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=deltatee.com header.s=20200525 header.b=sAs7KK64;
	spf=pass (imf30.hostedemail.com: domain of logang@deltatee.com designates 204.191.154.188 as permitted sender) smtp.mailfrom=logang@deltatee.com;
	dmarc=pass (policy=quarantine) header.from=deltatee.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767820995; a=rsa-sha256;
	cv=none;
	b=6VO/zom/9cfqTqWmYVg6EZcT6TADwvditxkk89PvIqftGqQImQA0R7vSRDlLTT74zjZaUJ
	LHV6B8b/TQmJ9sHbgJ1e35AyrU0wHuyv+t2dTF0HLnGDjhcGbWzAFovYWmjXHkxvkRILpW
	vc5+QkYtiQ2rr6wjkxErVLOvx4JtnXs=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=deltatee.com; s=20200525; h=Subject:In-Reply-To:From:References:Cc:To:
	MIME-Version:Date:Message-ID:content-disposition;
	bh=UkZv5onkyAXg00ymNzmBDBe0GBLZo5D/WkzgMa+G8aE=; b=sAs7KK643BWbWhoo6dF6UQ1/hT
	ZLLmOL/LPVznRjY+5D4R/1OIBjEGbBOAKimg/TrjMiTYbZ9Suqs5NKYOv2oYJIaV0Rx5hzGUkn6vd
	/9KjuYX4IPOeSz5EF/TriHk3wHFgOz6Sz/lAmLXfLaejw2/5GozSnvKBlFB7DlrSzk59G/tHTLq1E
	85vfcq1tY1L6TJ8DUK2kGelCJqhlxt4crpt5Tck1bCOssOIZo0Mu3hk1t5Fg8EUxOgsx11R8LDK6e
	e9kT6VK8iumDWsc2JoHZLObgto8LS/BXGS0VnuqYEirj8o55U+UXAMOFyVcUMXldKifXSan0zEErN
	nzh97lrw==;
Received: from d142-179-236-232.abhsia.telus.net ([142.179.236.232] helo=[192.168.11.155])
	by ale.deltatee.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.98.2)
	(envelope-from <logang@deltatee.com>)
	id 1vdazo-00000002GOe-3sYV;
	Wed, 07 Jan 2026 14:23:13 -0700
Message-ID: <1d2714eb-f5fc-4e73-9114-8d644deccdcc@deltatee.com>
Date: Wed, 7 Jan 2026 14:22:53 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Hou Tao <houtao@huaweicloud.com>, linux-kernel@vger.kernel.org,
 linux-pci@vger.kernel.org, linux-mm@kvack.org,
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
 <20260107202424.GC340082@ziepe.ca>
Content-Language: en-US
From: Logan Gunthorpe <logang@deltatee.com>
In-Reply-To: <20260107202424.GC340082@ziepe.ca>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 142.179.236.232
X-SA-Exim-Rcpt-To: jgg@ziepe.ca, houtao@huaweicloud.com, linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org, linux-mm@kvack.org, linux-nvme@lists.infradead.org, bhelgaas@google.com, apopple@nvidia.com, leonro@nvidia.com, gregkh@linuxfoundation.org, tj@kernel.org, rafael@kernel.org, dakr@kernel.org, akpm@linux-foundation.org, david@kernel.org, lorenzo.stoakes@oracle.com, kbusch@kernel.org, axboe@kernel.dk, hch@lst.de, sagi@grimberg.me, houtao1@huawei.com
X-SA-Exim-Mail-From: logang@deltatee.com
Subject: Re: [PATCH 10/13] PCI/P2PDMA: support compound page in
 p2pmem_alloc_mmap()
X-SA-Exim-Version: 4.2.1 (built Sun, 23 Feb 2025 07:57:16 +0000)
X-SA-Exim-Scanned: Yes (on ale.deltatee.com)
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 7B4D080012
X-Stat-Signature: 48anpxzcfxf4neryzjia9my99ezz6bua
X-Rspam-User: 
X-HE-Tag: 1767820995-17889
X-HE-Meta: U2FsdGVkX18BE4lvTORFnKQdVs1qoRU9FutxjQaqvLeRERsXyURLT5v13zho+C0oWmyJfBURviKe2z0WXg9nqHATma+dpKNipQSOQ/piN8JKtv77Ljt796r56sCVya6vKqUOMg8ejkK0AkWm/bp28f0j5hEEKl2kKGz2/fsnmiDdqveTRrREXj8K1OmDOwQYIdGsCcxDWpT9XdL+DyAL4QkZzm7SF5vspnPz4OuEmqIc6zJhmGBxpzzWkLzfH38qnC2d/tuVj+a4gPVyNOToStjNLMgRa0rHoPDFsdtg2NU5OaYQZAJ2kA+RfNSRaEZRD13mQVnanBnWe6UmwdWCRRFm8oBXqj2wv9F9Se7BPfa35LO6gqUpV4QJD019qsF68WRBllqoTURZg6GYKuIFJRhzvQN+l0unyDgtYVfEC1Ib0xCTVfhwK3g0BpxnnElzrCML5KLa5g6I9p++JZ1pCnmvsw18gxOj6IwlahHMJkj5XYF+ROFyvHUCgtE6ECpnGdAhRsvIh5DuqbE0n7xfaxRRfLj+XgwwdwaAgFGRiIacEt5RxcWJqaHK1aygsSljI+zEAPF9GDgpUdscY/bt/4QVhV3qcSiGwPQllSiyBgqY9JjabkEqxbRC+dwU0iUw2ErNqemu2Ikpa4j1gnIAxuz2P1aTi99ZoctrL0Z8Um6oFebhfKjiDLTZFf+tMSwzH35k1M1DsK7g6dyfW+DrA2C+kIXS1NSNwfIPkGe29kaHyotqoRqyJUUGVSU1gYQqf3BVvtdQhzpAY9Eha3u8IpJj83wwRb/JhDFG9VdWt+zaQ0L6aqmzEzjaj2/0FFh4wOg9I4nfwMtG4/4dN25wnb6rMy5e0lMHoHbRHj0OBF80sY7071L0JlVt89h1c4QDyWWNQMQIt27645JkTZoARm3NXg9QeGiKA+EZLnLyqnpMujYROeL4pAMI7TeNEIBP8MRTPV0fRe1dF2QYRDq
 Y0nRt7hH
 obAhosOfoE/U1Wc9MaPefne4/YZgFUctaYtFoQ7gG9zkYgfrLNJZsT+Ya9+PBH7lwG6dQIDgsPswl4T0+SCwoYWmMM57TCC60Y0mFJ3jH8j+MJPjPRm7wD/y3C56DvLwtSfux//Q/ZCevS41lXLFNpMOCtp/bNlmJz4/E2m8bgZwkB6yItTvvqrsa4aDMbV8X1TtBz5OfymuXenhAbS0c1CkIZpr5GNMMnlEF40wENMuvEDloRxGvkDfkJPtOHiVWjWE4CgWdt4a31QGTLXi0tHIy5ztIbyeMVOmhddiC0mXPvHgevXW3dKtfkuKCEKFRZqbM2OypChTwkkQtJELI65a0DCGhx4kNtfA4
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026-01-07 13:24, Jason Gunthorpe wrote:
> On Mon, Dec 22, 2025 at 10:04:17AM -0700, Logan Gunthorpe wrote:
>> I would have expected this code to allocate an appropriately aligned
>> block of the p2p memory based on the requirements of the current
>> mapping, not based on alignment requirements established when the device
>> is probed.
> 
> Yeah, I think this is not right too.
> 
> I think the flow has become confused by trying to set a static
> vmemmap_shift when creating the pgmap. That is not how something like
> this should work at all.
> 
> Instead the basic idea should be that each mmap systemcall will
> determine what folio order it would like to have, it will allocate an
> aligned range of physical from the genpool, and then it will alter the
> folios in that range into a single high order folio.
> 
> Finally the high order folio is installed in one shot with the mm
> dealing with placing it optimally in the right page table levels.

This all sounds the same as what I was advocating for. genpool does
still need to be modified to support the specified alignment
requirements for the allocation.

If there is more help from the VM layer to insert different orders of
memory, that would be fantastic too.

Logan

