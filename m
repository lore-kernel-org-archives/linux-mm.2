Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 789BBE81BD3
	for <linux-mm@archiver.kernel.org>; Mon,  9 Feb 2026 15:55:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8FC156B008A; Mon,  9 Feb 2026 10:55:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8A9636B0092; Mon,  9 Feb 2026 10:55:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7A82D6B0093; Mon,  9 Feb 2026 10:55:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 67F906B008A
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 10:55:04 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 1C492B6FC1
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 15:55:04 +0000 (UTC)
X-FDA: 84425366928.27.51C6FFF
Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	by imf11.hostedemail.com (Postfix) with ESMTP id 760554000F
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 15:55:00 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=samsung.com header.s=mail20170921 header.b=GZW9+Yro;
	dmarc=pass (policy=none) header.from=samsung.com;
	spf=pass (imf11.hostedemail.com: domain of kundan.kumar@samsung.com designates 203.254.224.34 as permitted sender) smtp.mailfrom=kundan.kumar@samsung.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770652502; a=rsa-sha256;
	cv=none;
	b=KBO+aue93/dTi8lZxgmlyGmsaWhb22KrdUJnxxJmMctktROlEz63Aq0UBpHDccDw0UytjL
	wXS8M0USKloWJGc48MfjgbvT2k12hpf2sE8T8mrnomYc2RPzLZKQiRiTK5ruwGKBx3GKjl
	ICc4/Ty71QqwrL+RaNRhUUKhGSxwj1k=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=samsung.com header.s=mail20170921 header.b=GZW9+Yro;
	dmarc=pass (policy=none) header.from=samsung.com;
	spf=pass (imf11.hostedemail.com: domain of kundan.kumar@samsung.com designates 203.254.224.34 as permitted sender) smtp.mailfrom=kundan.kumar@samsung.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770652502;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SH6fKsCcHoZUpzqt+IdkVbwE8A8W9DShkgqGQvHxHVw=;
	b=Pbr9npKfOmjC2uGwuRhD6G6fBC1K8eM9YZc1mrd3pmQqMXK6BhLalWVzmtUkTzxyDaovI5
	hpyTcyIeWlwWl0g05i43EZeXoTwOTfSQ4wc+Hf3AeOnk+Zj7GMCHazz9GvSCOLJn5yqQTv
	DYfuY/2ifW55gJUFjVGx45+5iyEQu0g=
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id 20260209155456epoutp04b68013d5fe398eee4d863b3bde887253~SnxBbYJhL1156411564epoutp049
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 15:54:56 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20260209155456epoutp04b68013d5fe398eee4d863b3bde887253~SnxBbYJhL1156411564epoutp049
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1770652496;
	bh=SH6fKsCcHoZUpzqt+IdkVbwE8A8W9DShkgqGQvHxHVw=;
	h=Date:Subject:To:Cc:From:In-Reply-To:References:From;
	b=GZW9+YrohBTSdV8WbG6g/CA1zl/LCSj5ruqdRYncptCw4GELMMbltx8RwBe3agSIt
	 pYkHEohrFnoW/pQrZwk9QAtmXBPXJzNpkEhaZnDIJpxE86lSrHKw63hzlkgYdFN7Er
	 2R1iAqWSgDDvvLDTvNRqsFPuxS7szNsp7h7IQCtw=
Received: from epsnrtp04.localdomain (unknown [182.195.42.156]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPS id
	20260209155455epcas5p1881af6ec338c4adc5a29870cdbc1beb4~SnxA1-tem2548425484epcas5p11;
	Mon,  9 Feb 2026 15:54:55 +0000 (GMT)
Received: from epcas5p4.samsung.com (unknown [182.195.38.89]) by
	epsnrtp04.localdomain (Postfix) with ESMTP id 4f8q5V3Yb5z6B9m5; Mon,  9 Feb
	2026 15:54:54 +0000 (GMT)
Received: from epsmtip1.samsung.com (unknown [182.195.34.30]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
	20260209155454epcas5p270af6d87208aae7466053be8520292c7~Snw-i_C9O1577615776epcas5p28;
	Mon,  9 Feb 2026 15:54:54 +0000 (GMT)
Received: from [107.111.86.57] (unknown [107.111.86.57]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20260209155450epsmtip1ad4b5be51e3fd96ce54775e25682ded2~Snw8mdDYC0787207872epsmtip1I;
	Mon,  9 Feb 2026 15:54:50 +0000 (GMT)
Message-ID: <5b11145d-15e2-485c-a978-365b58854371@samsung.com>
Date: Mon, 9 Feb 2026 21:24:49 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 0/6] AG aware parallel writeback for XFS
Content-Language: en-US
To: Christoph Hellwig <hch@lst.de>
Cc: Brian Foster <bfoster@redhat.com>, viro@zeniv.linux.org.uk,
	brauner@kernel.org, jack@suse.cz, willy@infradead.org, mcgrof@kernel.org,
	clm@meta.com, david@fromorbit.com, amir73il@gmail.com, axboe@kernel.dk,
	ritesh.list@gmail.com, djwong@kernel.org, dave@stgolabs.net, cem@kernel.org,
	wangyufei@vivo.com, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
	linux-xfs@vger.kernel.org, gost.dev@samsung.com, anuj20.g@samsung.com,
	vishak.g@samsung.com, joshi.k@samsung.com
From: Kundan Kumar <kundan.kumar@samsung.com>
In-Reply-To: <20260206062527.GA25841@lst.de>
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20260209155454epcas5p270af6d87208aae7466053be8520292c7
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20260116101236epcas5p12ba3de776976f4ea6666e16a33ab6ec4
References: <CGME20260116101236epcas5p12ba3de776976f4ea6666e16a33ab6ec4@epcas5p1.samsung.com>
	<20260116100818.7576-1-kundan.kumar@samsung.com> <aXEvAD5Rf5QLp4Ma@bfoster>
	<ca048ecf-5aec-4a0d-8faf-ad9fcd310e21@samsung.com>
	<aXN3EtxKFXX8DEbl@bfoster>
	<e7413e3b-3fae-4aab-90a1-4a6695156b2e@samsung.com>
	<20260206062527.GA25841@lst.de>
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 760554000F
X-Stat-Signature: ee1sng4i6r6b7369srxa1t467m9aji5d
X-HE-Tag: 1770652500-199663
X-HE-Meta: U2FsdGVkX1/jATUVoN9LdH3DGrOdYBRTkiobuqL1Kn0egwaz2ymuZ1VQ/erpP0tf9V/G6hgvuiaERpZ7+vVp3qI8WEEkK+SxOZ2SJUBA2GifHCQY7bMNaU7VwZoq0tMmywQuQEoQyQ8BoWReQ657BdpQaJu/l6weOgnseL5gxg7cTbcaF9umiadscbGGbE0HXFBm1zowuPYU1dw5b0E8qPTTdx/O0BGtIrY67rfsopy0w435IJagkjUb6ilo4B7AekRmdATdDPZerF93GrBr2hInNiqwTMpSTWG/rzcT089x2Z0bamYf9+jQuWeKHJNWYSu0hrsg5dZKuXtoS/34FfMPE/dUqkmn00U+sGpg9QYhsn9KZt8Lhxx7mfy3g2UpQr3Qzi0ZCMzB2PeFJDYtgHZAzVMlJd03YESnUnDG/wovkMlucg5xkE1IuYdT92v0+0V+5nJC2693iKZgOJ2tLXn8FtRE3f2eviaafPj+9uQ6TD5qU9z2+khhr4yF4elwTUPVdlCqWhBvNcym6gG2tfHn2wHsIRQPJHUturCn90XRDKr9WXaL92iGfsFal4p1OjcJ1ADMvp+1NQzT4CwcABcRPAS6s2RwhKjimTEDcfac8/1WY4gOl5HoJAWSyNjtc2PAqcA7XgMv2NzLz4CfxR8qUcEAxhnqlJVEpugD4sHvVPtEDPRV1ZxSJeShs+hfVNT/n/8QDykAOSNRv6X2qR3cjyHRNuXfGnouJ+1zoTcDX7mQnH8w//xLJjuVGOfDPvvq7sqpUjdWNmQ65tkRJftzyITQWimxfGvdoQJ9wKypNmnNr5SN9q+2qX3moUb6MMfs0Nw1M5jw1eHyrbLAzFQR62x4Ebt1/Ul9Z36xUtWMGdG5QSDUC/xG2mOAe3rPys04qR56M4MhpxfF4DROhd8UTdqdwyw+AMOrrhNtO4DZLng7X3fGZRAcW6dejWbKg87EYZOGPSGOwstqEUm
 R/SPnTZ3
 GkOZcCjyio6WqNspPXSJ9Oxv7lxpVwF7RTPJFXtStPMpVgzMxhSl5bhhxY8KkhUBegZLEcz7sIy9Ge4+Aq+XVA6H6ZaceBIuZgnfxkKobezQ8U90=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/6/2026 11:55 AM, Christoph Hellwig wrote:
> I fear we're deep down a rabbit hole solving the wrong problem here.
> Traditionally block allocation, in XFS and in general, was about finding
> the "best" location to avoid seeks.  With SSDs the seeks themselves are
> kinda pointless, although large sequential write streams are still very
> useful of course, as is avoiding both freespace and bmap fragmentation.
> On the other hand avoiding contention from multiple writers is a good
> thing.  (this is discounting the HDD case, where the industry is very
> rapidly moving to zoned device, for which zoned XFS has a totally
> different allocator)
> 
> With multi-threaded writeback this become important for writeback, but
> even before this would be useful for direct and uncached I/O.
> 
> So I think the first thing I'd look into it to tune the allocator to
> avoid that contention, by by spreading different allocation streams from
> different core to different AGs, and relax the very sophisticated and
> detailed placement done by the XFS allocator

Thanks, I’m going to restate what I think you are suggesting to make
sure I'm tracking correctly.

We will step back from per-folio tagging and instead align coarse
sharding with a simpler allocation policy:

- Create a bounded number of bdi wb contexts at mount time (capped,
e.g. ≤ agcount).
- Store a per-inode stream/shard id (no per-folio state).
- Assign the stream id once and use it to select the wb context for
writeback.
- In the delalloc allocator, bias AG selection from the stream id by
partitioning AG space into per-stream "bands" and rotating the start
AG within that band; fall back to the existing allocator when
allocation can't be satisfied.

Does this align with what you have in mind?

