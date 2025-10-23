Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CF0BACCD1BE
	for <linux-mm@archiver.kernel.org>; Thu, 23 Oct 2025 11:41:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3550A8E0015; Thu, 23 Oct 2025 07:41:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 303838E0011; Thu, 23 Oct 2025 07:41:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 17DBF8E0016; Thu, 23 Oct 2025 07:41:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0262D8E0015
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 07:41:52 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A826B140A9B
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 11:41:52 +0000 (UTC)
X-FDA: 84029189664.02.78F78C8
Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
	by imf03.hostedemail.com (Postfix) with ESMTP id 5563D2000C
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 11:41:48 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=samsung.com header.s=mail20170921 header.b=CQZ66iSY;
	dmarc=pass (policy=none) header.from=samsung.com;
	spf=pass (imf03.hostedemail.com: domain of kundan.kumar@samsung.com designates 203.254.224.25 as permitted sender) smtp.mailfrom=kundan.kumar@samsung.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761219710;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=N+oN6QIkhg+yxG+jofXiwToGHW0SdPwLgjc3KiwgdQg=;
	b=xUDA7mc7yK5kEppPjfKNdajoPSZOw9xetNM6jjw8LT5rw1M/bB8D06GcBLcJwsQ55sFiPL
	XZ/aSzz4VGHxtcm3zXu91ozDnyH2iKH2SJWXa4WkQBGFAQpaS0OowKX9u/t1otStlfv+nC
	HNwflGQ3lzOyIzhT0qYGnxtt1bv9H8M=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761219710; a=rsa-sha256;
	cv=none;
	b=rKsR+pq75VNYa/oScyzQHb/S7XhpyFQ3kWefzcBS1eKXAD4CshzZ8lDop4rbZIw1NBHymP
	M7kIm1qJzZoSlQNaDPunamMpVoOZ8+XdsKVsB2mpzXBnUps7bRO0lLsMhJzwYenlHxssBi
	DrTQAkjsSQRRV6mZafsm84EFMqvvIYQ=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=samsung.com header.s=mail20170921 header.b=CQZ66iSY;
	dmarc=pass (policy=none) header.from=samsung.com;
	spf=pass (imf03.hostedemail.com: domain of kundan.kumar@samsung.com designates 203.254.224.25 as permitted sender) smtp.mailfrom=kundan.kumar@samsung.com
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
	by mailout2.samsung.com (KnoxPortal) with ESMTP id 20251023114145epoutp02c68f2afa8f062cd86679664211734b64~xG-2hl8PB1530115301epoutp02S
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 11:41:45 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20251023114145epoutp02c68f2afa8f062cd86679664211734b64~xG-2hl8PB1530115301epoutp02S
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1761219705;
	bh=N+oN6QIkhg+yxG+jofXiwToGHW0SdPwLgjc3KiwgdQg=;
	h=Date:Subject:To:Cc:From:In-Reply-To:References:From;
	b=CQZ66iSYqNmHIJkk+0ZfYZ6mI08ULjkdlQ2Gb9uroSSh4A/ksYaZoznFo38EuldpN
	 Pmev3HPm6H3BdGroe6RJS8mWtP3FGeyhi9EH8wCaMFqggcHAjUosc196egoDvoXfOW
	 1d/8tMTtEuQQIK5VON5bdvQ9G1SER5CLfXjMrlvI=
Received: from epsnrtp02.localdomain (unknown [182.195.42.154]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPS id
	20251023114144epcas5p4915a81068b8c2110682c4ce6ea36272e~xG-157QXg0607706077epcas5p41;
	Thu, 23 Oct 2025 11:41:44 +0000 (GMT)
Received: from epcas5p3.samsung.com (unknown [182.195.38.88]) by
	epsnrtp02.localdomain (Postfix) with ESMTP id 4cskdg5VR5z2SSKZ; Thu, 23 Oct
	2025 11:41:43 +0000 (GMT)
Received: from epsmtip1.samsung.com (unknown [182.195.34.30]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
	20251023114142epcas5p10a1abeff9e1326fc9c846001906c9986~xG-0B0nat0254002540epcas5p1U;
	Thu, 23 Oct 2025 11:41:42 +0000 (GMT)
Received: from [107.111.86.57] (unknown [107.111.86.57]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20251023114136epsmtip1a3b96a88ae62950abac3f8a8a7dd3abc~xG-uRBGdX1343713437epsmtip1Q;
	Thu, 23 Oct 2025 11:41:36 +0000 (GMT)
Message-ID: <81330754-1aee-4807-a982-1fed37c016af@samsung.com>
Date: Thu, 23 Oct 2025 17:11:36 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 00/16] Parallelizing filesystem writeback
Content-Language: en-US
To: Jan Kara <jack@suse.cz>
Cc: Dave Chinner <david@fromorbit.com>, jaegeuk@kernel.org, chao@kernel.org,
	viro@zeniv.linux.org.uk, brauner@kernel.org, miklos@szeredi.hu,
	agruenba@redhat.com, trondmy@kernel.org, anna@kernel.org,
	akpm@linux-foundation.org, willy@infradead.org, mcgrof@kernel.org,
	clm@meta.com, amir73il@gmail.com, axboe@kernel.dk, hch@lst.de,
	ritesh.list@gmail.com, djwong@kernel.org, dave@stgolabs.net,
	wangyufei@vivo.com, linux-f2fs-devel@lists.sourceforge.net,
	linux-fsdevel@vger.kernel.org, gfs2@lists.linux.dev,
	linux-nfs@vger.kernel.org, linux-mm@kvack.org, gost.dev@samsung.com,
	anuj20.g@samsung.com, vishak.g@samsung.com, joshi.k@samsung.com
From: Kundan Kumar <kundan.kumar@samsung.com>
In-Reply-To: <bfpv6jrjo4avzk76ex77dwpzaejglu5gsf2pqpmmgwrmqdkkk3@imsbtnrcelee>
Content-Transfer-Encoding: 7bit
X-CMS-MailID: 20251023114142epcas5p10a1abeff9e1326fc9c846001906c9986
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20251014120958epcas5p267c3c9f9dbe6ffc53c25755327de89f9
References: <CGME20251014120958epcas5p267c3c9f9dbe6ffc53c25755327de89f9@epcas5p2.samsung.com>
	<20251014120845.2361-1-kundan.kumar@samsung.com>
	<aPa7xozr7YbZX0W4@dread.disaster.area>
	<6fe26b74-beb9-4a6a-93af-86edcbde7b68@samsung.com>
	<bfpv6jrjo4avzk76ex77dwpzaejglu5gsf2pqpmmgwrmqdkkk3@imsbtnrcelee>
X-Rspam-User: 
X-Rspamd-Queue-Id: 5563D2000C
X-Rspamd-Server: rspam02
X-Stat-Signature: nff7pqix1nzk6wzuhz9rn1hqi76cc3ix
X-HE-Tag: 1761219708-173461
X-HE-Meta: U2FsdGVkX1801LcyO6Ny7X8eqJdKbO6e/umzM8IpOV5nFRqjKT/VYROllVvZfeX/0cdGBtAUTx0QrkZRGkGqDsOR44eJ0cv73GQE098QmhklFURDeJ9MdP/gz6wI217FyyWt5dbUX/Dt4lqHeRhP1H+VWfiurerouf03HcbScH10IsS75JvKiG+ew7BFHLU/hXibPfgsvh9THpU8Ov827M1gckTzaLv2OtSEE9GqRF8HakEoffIROLovaDgWz2VG8SCz8kImzpdbwPAzyrqA+mT5vdeWsl19ONp5tXZQstY3njbPfCVdL4LkdYkThNs1i+2Iw4zm9cZ7Wur13sUpqQgchJq0KjJNmKRg5++72IO6L5llvBFfE+YDOujFdcTg7oRX9J4HKY2Vo11Qp2OpO7j8xGu3l5Aq4jARpxlFljuIiFfCuVWVEnxxyITcaM2nIQQ7ipJEgq/N4dCGJ38xovfu475uPueWGfLGq3A/v44u74QI/hF65Z/xobR/z0eBl0TcNgHlvhqJSUdKB8RYUCdDtWwYtrtR8fvZs8qry4+XZek5hVJh5glBEIUASoZT+j4xDJkt3Yb31yW9UIM5Ln/wBQ1T0XcTSPx16EyD8ox3BfGvueSn4+kDSViBFmQ9os/stxSoTIIB491jy8BmAxUrmSHBoSLr6wKoegwQQ0YMH+M3396fzB0fl58iCiZby/4asSjO8tKeoz4roopFkXO/TRTQepvw5Q3dfmNSLmElXwYIYaDbSnMzYjw5lq+HVx3KxDjwSTHjlTdidIQ6wEJJ+b0hQYevuQMjVNUqo2HVtcdmfQ1Ra2oBZjxyL2F47dUMuHy/e7YtAtDnadF6BMlJ8oWGc5tKq8doOctue0mxLXXV3XHlqV/edRR4P98O6I19/hi5U1ca59BrYoo27INpD5qvDVFK6jICXn0ZjUcpn0MSlwOSe9dAGOTg5002S70hXsVdOpsDG7irJMI
 f23VSio2
 u3RK/x5tMP8cZo7nMjLj8KbPWBN+w9XDoHDZaWkGZ1gq1IkOHXkJ1rBNt+OYuaZ4sMqp6yLKResLk/FvQa1Qb6lkrTG7y6j0xNqZUS7zAVDjrStU9NiwGAK2zb21EfJLALdKixdASV8Uo/Ojau+jcMWXt95zWZ2E/yNGBOh05FBCTRIRXDNhsvwiXOtMKFPLJ1BWHEcKQmnmOEqs=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/21/2025 5:41 PM, Jan Kara wrote:
> On Tue 21-10-25 16:06:22, Kundan Kumar wrote:
>> Previous results of fragmentation were taken with randwrite. I took
>> fresh data for sequential IO and here are the results.
>> number of extents reduces a lot for seq IO:
>>     A) Workload 6 files each 1G in single directory(AG)   - numjobs = 1
>>           Base XFS                : 1
>>           Parallel Writeback XFS  : 1
>>
>>     B) Workload 12 files each of 1G to 12 directories(AGs)- numjobs = 12
>>           Base XFS                : 4
>>           Parallel Writeback XFS  : 3
>>
>>     C) Workload 6 files each of 20G to 6 directories(AGs) - numjobs = 6
>>           Base XFS                : 4
>>           Parallel Writeback XFS  : 4
> 
> Thanks for sharing details! I'm curious: how big differences in throughput
> did you see between normal and parallel writeback with sequential writes?
> 
> 								Honza

Thank you for the review, Jan.

I found that the IOPS for sequential writes on NVMe SSD were similar
for both normal and parallel writeback. This is because the normal
writeback already maxes out the device's capacity. To observe the
impact of parallel writeback on IOPS with sequential writes, I
conducted additional tests using a PMEM device. The results, including
IOPS and fragmentation data, are as follows:

A) Workload 6 files each 1G in single directory(AG)      - numjobs = 1
     Base XFS           : num extents : 1 : 6606 MiB/s
     Parallel writeback : num extents : 1 : 6729 MiB/s - No change

B) Workload 12 directories(AGs) each with 12 files of 1G - numjobs = 12
     Base XFS           : num extents : 4 : 4486 MiB/s
     Parallel writeback : num extents : 5 : 12.9 GiB/s - +187%

C) Workload 6 directories(AGs) each with one 20G file    - numjobs = 6
     Base XFS           : num extents : 7 : 3518 MiB/s
     Parallel writeback : num extents : 6 : 6448 MiB/s - +83%

Number of CPUs = 128
System RAM = 128G
PMEM device size = 170G

