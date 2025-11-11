Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C8DECCCFA18
	for <linux-mm@archiver.kernel.org>; Tue, 11 Nov 2025 05:41:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0C0878E0006; Tue, 11 Nov 2025 00:41:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 071688E0002; Tue, 11 Nov 2025 00:41:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EA2288E0006; Tue, 11 Nov 2025 00:41:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D381E8E0002
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 00:41:43 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 75993B944A
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 05:41:43 +0000 (UTC)
X-FDA: 84097229286.28.886E325
Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
	by imf17.hostedemail.com (Postfix) with ESMTP id 0B7B34000C
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 05:41:39 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=samsung.com header.s=mail20170921 header.b=dzkz4SMG;
	spf=pass (imf17.hostedemail.com: domain of kundan.kumar@samsung.com designates 203.254.224.25 as permitted sender) smtp.mailfrom=kundan.kumar@samsung.com;
	dmarc=pass (policy=none) header.from=samsung.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762839701;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ef0RDZCWoK3lvtiD9fAfX9+MmhcguTfmbAAtnNupmPs=;
	b=wDYOqU6v8GuExgokeARqzhjZ08dkoFMh3dl/3PpdvcF6lPfJR0Evi7WvEHIhGxu80KXJst
	6CRxOV8lqtq0r2iGByJo/mPRCqDQnFQGlzNNpqQ+1hQdHsyHUdE5n7yaPVvYJuZx1whX8M
	sQMw6JWLIiR7B+tnL1uvUkR61/gGtas=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=samsung.com header.s=mail20170921 header.b=dzkz4SMG;
	spf=pass (imf17.hostedemail.com: domain of kundan.kumar@samsung.com designates 203.254.224.25 as permitted sender) smtp.mailfrom=kundan.kumar@samsung.com;
	dmarc=pass (policy=none) header.from=samsung.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762839701; a=rsa-sha256;
	cv=none;
	b=gwXjrQbxS0DqxPVKRpSU0tfoGoFRjFXt3//a2yaTGPyPZ5ncLOKVFj0Uoulet6qBZ+k0Wy
	SRPzN/WX1r3HwlE3rZixkm8clWMRBRkhVViJAUrJUuzZk/UetzJwGEKl1gkPkuw7ToM5m7
	GDtnMQOZSdVf8XHjBSxaUJtw+AV5elo=
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
	by mailout2.samsung.com (KnoxPortal) with ESMTP id 20251111054136epoutp02d47db83bb0fe91e6dc94fbe6bb4da68b~23V03BHil0778907789epoutp02B
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 05:41:36 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20251111054136epoutp02d47db83bb0fe91e6dc94fbe6bb4da68b~23V03BHil0778907789epoutp02B
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1762839696;
	bh=ef0RDZCWoK3lvtiD9fAfX9+MmhcguTfmbAAtnNupmPs=;
	h=Date:Subject:To:Cc:From:In-Reply-To:References:From;
	b=dzkz4SMGWoa+X2wPgIyjI16jRtOo/FcrxblhLH/gDESsRNTwlNoEdxA6USFbcFcuv
	 O7w2sr+2TQuqXN9wpmZU2LIIGrFGxiAFBmtio9TgGknllbajhUARdXSkOozHkgSx8f
	 ml85fpLcWwsJujGvI6FWUL/Z9iw7tdZuksYYUMGM=
Received: from epsnrtp03.localdomain (unknown [182.195.42.155]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPS id
	20251111054135epcas5p1d15ca46bbaf565fb7c66295f670d762c~23V0NCthE3166631666epcas5p1V;
	Tue, 11 Nov 2025 05:41:35 +0000 (GMT)
Received: from epcas5p3.samsung.com (unknown [182.195.38.90]) by
	epsnrtp03.localdomain (Postfix) with ESMTP id 4d5FlL51stz3hhTJ; Tue, 11 Nov
	2025 05:41:34 +0000 (GMT)
Received: from epsmtip2.samsung.com (unknown [182.195.34.31]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
	20251111054133epcas5p20b40bd8e7a3f97b9291d974346022f8b~23VybX4aU0629806298epcas5p24;
	Tue, 11 Nov 2025 05:41:33 +0000 (GMT)
Received: from [107.111.86.57] (unknown [107.111.86.57]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20251111054129epsmtip241c0542d0446455b092d644d9c07434f~23VukFjr81175011750epsmtip2P;
	Tue, 11 Nov 2025 05:41:29 +0000 (GMT)
Message-ID: <38aa0903-24e6-4c9c-987c-86f6e7634f87@samsung.com>
Date: Tue, 11 Nov 2025 11:11:28 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 00/16] Parallelizing filesystem writeback
Content-Language: en-US
To: Christoph Hellwig <hch@lst.de>
Cc: "Darrick J. Wong" <djwong@kernel.org>, Dave Chinner
	<david@fromorbit.com>, jaegeuk@kernel.org, chao@kernel.org,
	viro@zeniv.linux.org.uk, brauner@kernel.org, jack@suse.cz,
	miklos@szeredi.hu, agruenba@redhat.com, trondmy@kernel.org, anna@kernel.org,
	akpm@linux-foundation.org, willy@infradead.org, mcgrof@kernel.org,
	clm@meta.com, amir73il@gmail.com, axboe@kernel.dk, ritesh.list@gmail.com,
	dave@stgolabs.net, wangyufei@vivo.com,
	linux-f2fs-devel@lists.sourceforge.net, linux-fsdevel@vger.kernel.org,
	gfs2@lists.linux.dev, linux-nfs@vger.kernel.org, linux-mm@kvack.org,
	gost.dev@samsung.com, anuj20.g@samsung.com, vishak.g@samsung.com,
	joshi.k@samsung.com
From: Kundan Kumar <kundan.kumar@samsung.com>
In-Reply-To: <20251107133742.GA5596@lst.de>
Content-Transfer-Encoding: 7bit
X-CMS-MailID: 20251111054133epcas5p20b40bd8e7a3f97b9291d974346022f8b
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20251014120958epcas5p267c3c9f9dbe6ffc53c25755327de89f9
References: <CGME20251014120958epcas5p267c3c9f9dbe6ffc53c25755327de89f9@epcas5p2.samsung.com>
	<20251014120845.2361-1-kundan.kumar@samsung.com>
	<aPa7xozr7YbZX0W4@dread.disaster.area> <20251022043930.GC2371@lst.de>
	<e51e4fb9-01f7-4273-a363-fc1c2c61954b@samsung.com>
	<20251029060932.GS4015566@frogsfrogsfrogs> <20251029085526.GA32407@lst.de>
	<91367b76-e48b-46b4-b10b-43dfdd8472fa@samsung.com>
	<20251107133742.GA5596@lst.de>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 0B7B34000C
X-Stat-Signature: wk1jhjm5aneazae96ma3f7k99xbejfyn
X-Rspam-User: 
X-HE-Tag: 1762839699-823183
X-HE-Meta: U2FsdGVkX1+Uxd89CrwSjHjVnxr/5+K7drDRfS8d3UMRwVgJZZ6xVcsLXbWR2n6xRxL6yr1QozrBkwFf93TDUzT9xwyzWnf5ZBawHAqLW2XNW2/dVJQNN9al+HfnkGiJS+Y809StvX+10mwVDam2MBHeLpH2e2/kPLjLy6Oa/9ES7GweEx0+iy8bGhtTBUMk4P1fWkPyZe7ZeLP5S1s/KKmx37Mw9ZBTMvVeQTzevyZ174TyRc3elIiu2N6zaBkJy264LTPKlszm2eqHAmsZBjXoCOEaEsIrhsPXTRzL79y9wEIYsihHcAGRe55ieFu0tw05A0Aq+VJQoBtQLs37jlpvq2U2MgJWOFP5BS+R6AhGINdc94i64B1aIEgANbVRA9pSrLC9+gB2oM5WiurH2D/126Wsiyhb9Nxxe3mNNiUoLaWKstKi5TOFGMHq1cQqxYi3abD3JaCB5P0P5HxzGrUWaNQmLzYsToJhpppCj8GTwFcO1dXlmqJrMGjiDRbUj++tQXcdBEtaPoK1mdrnPoYyFRoVKy9tkp6em/AmQcB9sA+t2Ok81RauiJfdoc3PfJIdJlMOI5dA7Ekkw+dquqk8gVInA2LU4Nq1BTO9dJ1jWPLdRPVz4/HCd0f/SztqpdVbM81dnJM7NA3rI+GUEoxh3PBLTQA9ZtWzkN49aGYstNUwOexYjUF1XyuvwtDI2VoWqp8nnMjDOCmfBLWeCrL5f17f8kTLtds74SpD58g/fKq9vBEUs2923sI/n2GT1h3u2t3nUyWMOp7bi78q+H6/uhZCzl8Nz/Ly2jt5ogskf5YsQlIAbGtRWWtFOcBJcVkV4PBMLj4eynybmjS0HpBYa9dh3Ut6F6WF8bnwTa3xRnRHtXk1f9DyNfPUwaRSKP6GkpmEOuTrUuLhg7AAakDxXiNECPz1pnlF8pvIIwGEOD2hXzRdq8ZPYDx7SiBNPVJobVFfMsEvOg7uY0F
 QT7Vwkbg
 +YZyN9cYBgHSpPEthv5rhzFPKUjup3Fag76myICNvw7rGrpKPjsYU6C+qLHTs6xJ77jVroi+uO0bn5BeCHImSKp38eOUPh4njAf0yqrLPEPb8jj1RLVwC4z4I3rpKA44rLuhy6vyDeDFouMNfOHXDTnnL6xVescmB4DmuB2ZdjqnMCUiPpf5zrdbdLteq/i1OI5q5KUFT3sYnfX4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11/7/2025 7:07 PM, Christoph Hellwig wrote:
> On Fri, Nov 07, 2025 at 02:54:42PM +0530, Kundan Kumar wrote:
>> Predicting the Allocation Group (AG) for aged filesystems and passing
>> this information to per-AG writeback threads appears to be a complex
>> task.
> 
> Yes.  But in the end aged file systems are what will see most usage.
> Fresh file systems look nice in benchmarks, but they aren't what
> users will mostly deal with.
> 
>> To segregate these I/O requests by AG, it is necessary to associate
>> AG-specific information with the pages/folios in the page cache. Two
>> possible approaches are:
>> (1) storing AG information in the folio->private field, or
>> (2) introducing new markers in the xarray to track AG-specific data.
>>
>> The AG-affined writeback thread processes specific pages from the page
>> cache marked for its AG. Is this a viable approach, or are there
>> alternative solutions that could be more effective?
> 
> Or maybe the per-AG scheme isn't that great after all and we just
> need some other simple sharding scheme?  Of course lock contention
> will be nicer on a per-AG basis, but as you found out actually
> mapping high-level writeback to AGs is pretty hard.
> 
> 
Thank you for your insightful comments, Christoph. I'm considering using
folio private to incorporate IOMAP type and predicted AG information.
The prediction for DELALLOC, using pagf_freeblks etc., and for UNWRITTEN
and MAPPED, using the actual location of allocated blocks.

Subsequently, schedule all writeback threads for the inode. With all the
necessary information, these threads will be able to filter AG-specific
folios and focus on those marked for the corresponding AG. Although this
approach may seem complex, it should effectively address various use
cases, including aged filesystems, filesystem fragmentation, and locking
concerns.

We tried CPU and inode based sharding, CPU based sharding increases
filesystem fragmentation, and inode based sharding results in AG lock
contention. We adopted AG-based sharding to resolve these issues.


