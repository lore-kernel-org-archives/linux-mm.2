Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3FE82CCF9F0
	for <linux-mm@archiver.kernel.org>; Fri, 31 Oct 2025 01:55:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8F31C8E00ED; Thu, 30 Oct 2025 21:55:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8A2EE8E006B; Thu, 30 Oct 2025 21:55:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7B8658E00ED; Thu, 30 Oct 2025 21:55:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6A7618E006B
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 21:55:20 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id EA6F949893
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 01:55:19 +0000 (UTC)
X-FDA: 84056741958.28.E89619A
Received: from canpmsgout01.his.huawei.com (canpmsgout01.his.huawei.com [113.46.200.216])
	by imf10.hostedemail.com (Postfix) with ESMTP id 259FBC0008
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 01:55:15 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=1PJllnbf;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf10.hostedemail.com: domain of libaokun1@huawei.com designates 113.46.200.216 as permitted sender) smtp.mailfrom=libaokun1@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761875718;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FuRkASDZGC+sxqL3DYTg3OeS7+jWMa3JBcSB0zkywCw=;
	b=ygwr1mK7XFyVX3kpXAerU5iU5jDW1shDm5Zxr/NmOJk9MsxftF2kfVrI+vf8cee9jLDe0w
	qaODj6ItPzWKT6cBZaiACTISURKXn+/Z2DubLX3bVno29juI9Tm5wxz22ofGBgPCEUlJl8
	2M+z7QjIlXKMVSKs0jyyV0nakHMvySY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761875718; a=rsa-sha256;
	cv=none;
	b=eYh0l4e6ETwSURTUz9IYB6yK03eAWLqmRfJobEXgbztT9i6gyl4JqH+QG2OsPKALdsko2v
	NI2rMv7qwEtwTi+a6878B2Z0VrJ6G3BFWpCcwhH9pt0fvSyZhENxhdJgOwCut2KKoB9Dfw
	VWYghv6Srvm+KL7GWGBLPGlcX0276Fo=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=1PJllnbf;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf10.hostedemail.com: domain of libaokun1@huawei.com designates 113.46.200.216 as permitted sender) smtp.mailfrom=libaokun1@huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=FuRkASDZGC+sxqL3DYTg3OeS7+jWMa3JBcSB0zkywCw=;
	b=1PJllnbfIbkvN0pKBGCG9TvvyYM4KGWr7n3wEXphZXHtJ4dimURefifOMidnDOs+bfUqeOF/4
	OAEbwCDFZydkX1/3puSsGcf2swvVu2LEN3zhuUZkJIiN22z9kddenEuUrN/H1xkv2rk5oQu2eSC
	o5hUppPjT4EJIbxE0/pOPNQ=
Received: from mail.maildlp.com (unknown [172.19.88.194])
	by canpmsgout01.his.huawei.com (SkyGuard) with ESMTPS id 4cyPCs5FPtz1T4Fg;
	Fri, 31 Oct 2025 09:54:01 +0800 (CST)
Received: from dggpemf500013.china.huawei.com (unknown [7.185.36.188])
	by mail.maildlp.com (Postfix) with ESMTPS id EB2F0140156;
	Fri, 31 Oct 2025 09:55:07 +0800 (CST)
Received: from [127.0.0.1] (10.174.178.254) by dggpemf500013.china.huawei.com
 (7.185.36.188) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Fri, 31 Oct
 2025 09:55:06 +0800
Message-ID: <6899c98c-b31b-4827-979c-935f833ed332@huawei.com>
Date: Fri, 31 Oct 2025 09:55:05 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 22/25] fs/buffer: prevent WARN_ON in
 __alloc_pages_slowpath() when BS > PS
Content-Language: en-GB
To: Matthew Wilcox <willy@infradead.org>
CC: "Darrick J. Wong" <djwong@kernel.org>, <linux-ext4@vger.kernel.org>,
	<tytso@mit.edu>, <adilger.kernel@dilger.ca>, <jack@suse.cz>,
	<linux-kernel@vger.kernel.org>, <kernel@pankajraghav.com>,
	<mcgrof@kernel.org>, <linux-fsdevel@vger.kernel.org>, <linux-mm@kvack.org>,
	<yi.zhang@huawei.com>, <yangerkun@huawei.com>, <chengzhihao1@huawei.com>,
	Baokun Li <libaokun@huaweicloud.com>, Baokun Li <libaokun1@huawei.com>
References: <20251025032221.2905818-1-libaokun@huaweicloud.com>
 <20251025032221.2905818-23-libaokun@huaweicloud.com>
 <aPxV6QnXu-OufSDH@casper.infradead.org>
 <adccaa99-ffbc-4fbf-9210-47932724c184@huaweicloud.com>
 <aQPX1-XWQjKaMTZB@casper.infradead.org>
From: Baokun Li <libaokun1@huawei.com>
In-Reply-To: <aQPX1-XWQjKaMTZB@casper.infradead.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.178.254]
X-ClientProxiedBy: kwepems200001.china.huawei.com (7.221.188.67) To
 dggpemf500013.china.huawei.com (7.185.36.188)
X-Rspamd-Server: rspam01
X-Stat-Signature: roa5iiypo9kkrtukfxzcn8u7digt8fai
X-Rspam-User: 
X-Rspamd-Queue-Id: 259FBC0008
X-HE-Tag: 1761875715-628137
X-HE-Meta: U2FsdGVkX19S5l8Xk8LfO/PoeFmvnHjBmX/FA3JRJTuTvIpqXeuhAueEUHv4HjaFaSG6bJ512NzjWZw1fyunjXFKLyxt1FZtn01A9LPQme/J/r2j7w6O51ChKcnHsz5AvRDsDFA6zO1OCQG1hdlSINHFD2kKB/8CNec6kgBq8vyytGrSmEZn7cUrgvC2kFjJxZcmzyCmhe/P65/R+VM5lK+I+MvIiAeq2wUKui6M0ysEHZGO7uSFNWasENniPT4t5fxLpHzEiTAc3m31jzYoRTEgJJXS+F2CtqPnQu9yglXWVhAc22S6SqW0W0UZ+9rNslgh7M7XF5pHC7r3l/WCUcYlFPXosQ1vdEnTWCjBB+h8cI60fFH5wWSc5HAFYnyDmfQ7OJXI+EmGhVGXy7QRJSbmjAcPDPOG7RcmX+xIkmtNfNzPzD4gQ5chSsOvLMKSRBAuF5m021zXuope9Enh4R2YS30lOIL1AgO2h9BAaEQxom1IXagqtGySiw6cVSk97dngu6V/+l5i+n7s6y85crjbgzr/C4qW+WvqzijnWUwP3f/2mV93oD7+hTwcPHjmKUeFvRDGhhXla0B+GJurX2PCIqb96UVem3d51T9S/fktg+OWrKOdgpwqdbsWRbhtD/pk9IsB/z/PgzeQWpYhieA0LZaJke56YVqXBBKp6LiSdnJz8tPsnxwctEFw9csyYxTAiRE2ZZWHfdilfc1qUd3nuL/lYxF3p6Ky/ToA7I/ODYPVTuoqvc8akAbbe7K0RzfuUPcjes+HM58Zen4Hl/Y2f4HtbPPD95omAxXfCBNB5xWkFLliTrhrX0W8szztGKHtMkQHAg4eXnHRlb53Ugoqh3OOtmso6OMDlqs8g759l0MshofmWspfakMQ6HlxonIMhugHe0Hmgre3VKZOs9l/uSGKz47AFtmN1ZFxIjwSwNnuYyP/8IyUf9yO9TDOQXNqv7mh7p7oZ6Q1Yez
 BJbmpq8x
 KZ6dk7I2CAJaJvoYE3l5j70A814b/AxvWgixf1qdok1s2APqbhQyldfiajwBkDyQDWFTintjj2zHJZMiErYK6QXX9bIiLvJI3VsC2IM/9DaDbesPT7SrcJpdfYJLpqKndYR4Pcuipwk40G7rifXhsAgNpFDQHFmdwAR5zJ4sgRJfzeG5oogiDlrjq48zsKd6eElupCv3mnvka7Tv9nG9JkaKHG1EjQAGCp/xJrdTxqkek9/X8vdp2302yjDJJbvrk6JJqrtMF+DmhnO+koz4QuYrC6ZqOK6khp7uKe5fRhMHGc460ZB43ppi0HilgbDjj4ZAuBxNQ1cuH/WTRR5TthJAnTx6HcYcGxJ1dVE6kjNiRSv1ND9CS8GqW7+fJGfjSPVDcoO3GseCRvIOPxXN2LsL0dnMzhDpwgsSJIvelRlGPYg5mCcjQdcr98A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2025-10-31 05:25, Matthew Wilcox wrote:
> On Sat, Oct 25, 2025 at 02:32:45PM +0800, Baokun Li wrote:
>> On 2025-10-25 12:45, Matthew Wilcox wrote:
>>> No, absolutely not.  We're not having open-coded GFP_NOFAIL semantics.
>>> The right way forward is for ext4 to use iomap, not for buffer heads
>>> to support large block sizes.
>> ext4 only calls getblk_unmovable or __getblk when reading critical
>> metadata. Both of these functions set __GFP_NOFAIL to ensure that
>> metadata reads do not fail due to memory pressure.
>>
>> Both functions eventually call grow_dev_folio(), which is why we
>> handle the __GFP_NOFAIL logic there. xfs_buf_alloc_backing_mem()
>> has similar logic, but XFS manages its own metadata, allowing it
>> to use vmalloc for memory allocation.
> In today's ext4 call, we discussed various options:
>
> 1. Change folios to be potentially fragmented.  This change would be
> ridiculously large and nobody thinks this is a good idea.  Included here
> for completeness.
>
> 2. Separate the buffer cache from the page cache again.  They were
> unified about 25 years ago, and this also feels like a very big job.
>
> 3. Duplicate the buffer cache into ext4/jbd2, remove the functionality
> not needed and make _this_ version of the buffer cache allocate
> its own memory instead of aliasing into the page cache.  More feasible
> than 1 or 2; still quite a big job.
>
> 4. Pick up Catherine's work and make ext4/jbd2 use it.  Seems to be
> about an equivalent amount of work to option 3.
>
> 5. Make __GFP_NOFAIL work for allocations up to 64KiB (we decided this was
> probably the practical limit of sector sizes that people actually want).
> In terms of programming, it's a one-line change.  But we need to sell
> this change to the MM people.  I think it's doable because if we have
> a filesystem with 64KiB sectors, there will be many clean folios in the
> pagecache which are 64KiB or larger.
>
> So, we liked option 5 best.
>
Thank you for your suggestions! 

Yes, options 1 and 2 don’t seem very feasible, and options 3 and 4 would
involve a significant amount of work. Option 5 is indeed the simplest and
most general solution at this point, and it makes a lot of sense.

I will send a separate RFC patch to the MM list to gather feedback from the
MM people. If this approach is accepted, we can drop patches 22 and 23 from
the current series.


Cheers,
Baokun



