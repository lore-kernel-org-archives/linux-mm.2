Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CFA28CCF9E9
	for <linux-mm@archiver.kernel.org>; Wed, 29 Oct 2025 06:05:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B71718E0034; Wed, 29 Oct 2025 02:05:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B22918E0015; Wed, 29 Oct 2025 02:05:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A38138E0034; Wed, 29 Oct 2025 02:05:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 8F0FA8E0015
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 02:05:54 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 3115AC06AB
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 06:05:54 +0000 (UTC)
X-FDA: 84050115828.02.85AEA68
Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
	by imf14.hostedemail.com (Postfix) with ESMTP id 7173510000C
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 06:05:51 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=samsung.com header.s=mail20170921 header.b=vbuEe17m;
	dmarc=pass (policy=none) header.from=samsung.com;
	spf=pass (imf14.hostedemail.com: domain of kundan.kumar@samsung.com designates 203.254.224.25 as permitted sender) smtp.mailfrom=kundan.kumar@samsung.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761717952; a=rsa-sha256;
	cv=none;
	b=pGAfsPop0bvNtEbBjYBHovuOH/4rrCxo5wLBb7LPJMWcWWY8pR4yisWr+P8vk3QZDD65T8
	eihtpdCMF3dD2AGVDW3Sjnl6bEFEUxmHAf6ygQPSUjgNhlvXX56H9cLTpBPqWkxOxspBWF
	QqthE5pvfJq8/CZzze9jqH47F5lt/VM=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=samsung.com header.s=mail20170921 header.b=vbuEe17m;
	dmarc=pass (policy=none) header.from=samsung.com;
	spf=pass (imf14.hostedemail.com: domain of kundan.kumar@samsung.com designates 203.254.224.25 as permitted sender) smtp.mailfrom=kundan.kumar@samsung.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761717952;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bBJQp7PbGMd1XdhUFl5A/6fLfmccB/IWy8yXpsj4CGc=;
	b=2HXH/Hp44gy6uvC4XQpTEF5ebx2pwq9pns370PA/lzRZlkRZFQhrrnQPw5ADOQPu+veV3l
	RhbpIyGc9ALn38NlhTLhSEfq+p0Lrv7ppYTGgtnoxDcQvlbm3BLUEf0TuY3v83eecOOK18
	rq7vrLOENv+I36GZpJUTUXZtaWVZAqo=
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
	by mailout2.samsung.com (KnoxPortal) with ESMTP id 20251029060548epoutp021b9ed9da2dd2f59252f8ce8b2be3f9d5~y4SPfvgjD2182121821epoutp02O
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 06:05:48 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20251029060548epoutp021b9ed9da2dd2f59252f8ce8b2be3f9d5~y4SPfvgjD2182121821epoutp02O
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1761717948;
	bh=bBJQp7PbGMd1XdhUFl5A/6fLfmccB/IWy8yXpsj4CGc=;
	h=Date:Subject:To:Cc:From:In-Reply-To:References:From;
	b=vbuEe17mTF2terd1TQ+gi3mkaNQ+gSv01pyxt704vlOpbeMh20OJKRtvhq38wKJpB
	 EhIkFmb17+oJbYcYDLRELStbMI/9A8fc5xYMpoyix3uXeCtTFBV9Z8hbDh4jiRgzsx
	 fbXRyG0udW3HlL/1jfZBTSVcOwcrY1cBEG0kndv0=
Received: from epsnrtp03.localdomain (unknown [182.195.42.155]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPS id
	20251029060547epcas5p3b81b402ebdb14361658a0a9d1625f9a1~y4SPBxYRj0475104751epcas5p3j;
	Wed, 29 Oct 2025 06:05:47 +0000 (GMT)
Received: from epcas5p2.samsung.com (unknown [182.195.38.88]) by
	epsnrtp03.localdomain (Postfix) with ESMTP id 4cxGvG5lFcz3hhT3; Wed, 29 Oct
	2025 06:05:46 +0000 (GMT)
Received: from epsmtip1.samsung.com (unknown [182.195.34.30]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
	20251029060545epcas5p491529ef7b75758f4d8bc82f4da1b9976~y4SM_VznG0334003340epcas5p4Y;
	Wed, 29 Oct 2025 06:05:45 +0000 (GMT)
Received: from [107.111.86.57] (unknown [107.111.86.57]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20251029060524epsmtip1c2db16f0f541ef4f1bd12a548aa4a54d~y4R5nnv-B1497914979epsmtip18;
	Wed, 29 Oct 2025 06:05:24 +0000 (GMT)
Message-ID: <e51e4fb9-01f7-4273-a363-fc1c2c61954b@samsung.com>
Date: Wed, 29 Oct 2025 11:35:21 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 00/16] Parallelizing filesystem writeback
Content-Language: en-US
To: Christoph Hellwig <hch@lst.de>, Dave Chinner <david@fromorbit.com>
Cc: jaegeuk@kernel.org, chao@kernel.org, viro@zeniv.linux.org.uk,
	brauner@kernel.org, jack@suse.cz, miklos@szeredi.hu, agruenba@redhat.com,
	trondmy@kernel.org, anna@kernel.org, akpm@linux-foundation.org,
	willy@infradead.org, mcgrof@kernel.org, clm@meta.com, amir73il@gmail.com,
	axboe@kernel.dk, ritesh.list@gmail.com, djwong@kernel.org,
	dave@stgolabs.net, wangyufei@vivo.com,
	linux-f2fs-devel@lists.sourceforge.net, linux-fsdevel@vger.kernel.org,
	gfs2@lists.linux.dev, linux-nfs@vger.kernel.org, linux-mm@kvack.org,
	gost.dev@samsung.com, anuj20.g@samsung.com, vishak.g@samsung.com,
	joshi.k@samsung.com
From: Kundan Kumar <kundan.kumar@samsung.com>
In-Reply-To: <20251022043930.GC2371@lst.de>
Content-Transfer-Encoding: 7bit
X-CMS-MailID: 20251029060545epcas5p491529ef7b75758f4d8bc82f4da1b9976
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20251014120958epcas5p267c3c9f9dbe6ffc53c25755327de89f9
References: <CGME20251014120958epcas5p267c3c9f9dbe6ffc53c25755327de89f9@epcas5p2.samsung.com>
	<20251014120845.2361-1-kundan.kumar@samsung.com>
	<aPa7xozr7YbZX0W4@dread.disaster.area> <20251022043930.GC2371@lst.de>
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 7173510000C
X-Stat-Signature: 754w5gn59surpujbyd1rbzn89q19xjri
X-HE-Tag: 1761717951-780174
X-HE-Meta: U2FsdGVkX185ZcnGAVfRW0T+ktsmoNS38syIR021kkekOV8PKUKdtmOEPp7+F+LrwZqlCrSkCHWEgisH7qJ0794Cn4Sizj8/eb7MsyHeFeEELTnozIdH1FwP3QUbA8lZE12SDhaeHzeU+wsaVzIahb0JVWR5nbrN/eOZG2b+0+Tb0IDgmmhEWkwSJ9Jv8/VEspZyapWpzkO3hMr0/NM1Aie7KUUw0Odw3SK0nh7kLnUl8R0ZkY1ynop3FKdQUn05wrXAZj0KDreCgCUGwH04mIIeLEhuQ5L4zNVdSvbzW0p3Mw748qVlxhHoI5Fj8VVPpZABs/NCOWk7tvaKFIASXxlKyYRjJ+3nlFelT60ArtKcR3z96ovxKerUKNtqfu2Hp50NR9IQDwQxuSfhE691NrqCe4C/dugjpR6QlyBESAnRJ9lW4igq57CvD/xGixXrOQsS3D8DzlDjFfu0kFeqQ20pDtca9EDN6iAkAAg0i08miSGmHo3JVqA/LG1fdKduCAM4yQFNgo+LTUTqI93FDBeXm6N3ueGxZtDaVwscPJih3AJ1ZZ/nZ2vBzw5kt5DBeq4GnbSK07qb3smwDlHHy3gpjRrO8zxSlfgqJpGP4RNS+o+7meBxp6o9X32tZvI4pH+8FOnq+LHtv6q95hdOgs4pSLQx/y77CpWftwffqvGj/eWGUZsw2wlBIOHIpQo7cj5djzhQxD3ZG7zON1IpY8hgyn78fesFNAMT4dDTUnukTPZGhGRn54JHVNRLeWh0vD9Pcy5r7BjcPiP740Kt4nEDTxIcIZ1rwEQ1CpIYi80mtKiQSOiZt+Jo2eWyvHvQG6MWZ5wvGzEYRfD9l181tOpSbDxCR0lg1prTC6AVV+ziP4in7URLq4NfqEverQrxLDq2jsX9uivNLjK1bVPqCMxE3JzJuN5QI0a+5H/3cLZXloykWvePlJHYLLVlS+th1/h6ie52SqqdkhWLukZ
 ZTwV8v6f
 0hsL8tD1GaTnvcXFRsV1Q8MVKqxnj+MF33W9kVXj0KYILbOyrcjWCfsXrAHCSbb4ROZSyfHULCuv1Cj12qg9EbsdcTf3uMF04fvsmJESPCdw7/2jMDZBExIzseXkujlWivo4bBZV/ALsIMVG2xl0Sa+3PNoVOeADvz85DfPEquFJJFzNfhWI4xLKqrOLM4Wbw79pmZYvfGh3JUWo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/22/2025 10:09 AM, Christoph Hellwig wrote:
> On Tue, Oct 21, 2025 at 09:46:30AM +1100, Dave Chinner wrote:
>> Not necessarily. The allocator can (and will) select different AGs
>> for an inode as the file grows and the AGs run low on space. Once
>> they select a different AG for an inode, they don't tend to return
>> to the original AG because allocation targets are based on
>> contiguous allocation w.r.t. existing adjacent extents, not the AG
>> the inode is located in.
> 
> Also, as pointed out in the last discussion of this for the RT
> subvolume there is zero relation between the AG the inode is in
> and the data placement.
> 
> 
I evaluated the effect of parallel writeback on realtime inodes and
observed no improvement in IOPS. We can limit writes for realtime
inodes to utilize a single default (0) writeback context. Do you
see it differently?

