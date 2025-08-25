Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ED3FDCA0EFA
	for <linux-mm@archiver.kernel.org>; Mon, 25 Aug 2025 16:10:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 287D48E004B; Mon, 25 Aug 2025 12:10:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 25FA08E0038; Mon, 25 Aug 2025 12:10:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 175098E004B; Mon, 25 Aug 2025 12:10:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 011C68E0038
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 12:10:08 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 7F44D1DDB4B
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 16:10:08 +0000 (UTC)
X-FDA: 83815766496.09.FBC4819
Received: from mx0b-002e3701.pphosted.com (mx0b-002e3701.pphosted.com [148.163.143.35])
	by imf06.hostedemail.com (Postfix) with ESMTP id 266B3180012
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 16:10:02 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=hpe.com header.s=pps0720 header.b=BZv7aZNE;
	spf=pass (imf06.hostedemail.com: domain of kyle.meyer@hpe.com designates 148.163.143.35 as permitted sender) smtp.mailfrom=kyle.meyer@hpe.com;
	dmarc=pass (policy=reject) header.from=hpe.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756138203;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sQH2klu1q9w/NyJjrasqKq1tGmDd3ucFuLZtG1LKn80=;
	b=Nr34KPy22T/drqpCWyTU3hwLBKWpby6pXS/rhILGMLarPp+LQJzpf858rIGP+4DEJIIe24
	6aTKDIbRGKYcpysOFgC6BQWUTtoahcR2ABE5PN9CgKIxSw2uMcGP7XBdvxXq3o3TZAoCRp
	Tx/0yicYTSLxkVtj2ia4MIg32n+N7cU=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=hpe.com header.s=pps0720 header.b=BZv7aZNE;
	spf=pass (imf06.hostedemail.com: domain of kyle.meyer@hpe.com designates 148.163.143.35 as permitted sender) smtp.mailfrom=kyle.meyer@hpe.com;
	dmarc=pass (policy=reject) header.from=hpe.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756138203; a=rsa-sha256;
	cv=none;
	b=adVsXZ3CdfMHU5s012Lvp+cBctlO2npu9kEeuSgVbhOx/cwX2Tr6BBQSDKmshPlG3YriEX
	twE8xrG02r5k9F3NUMKPltK496WTolq9r22D2+qTBrAE6HgivFZmkxSg7MMoLgyV3hM2hx
	as0+4nAJm30GW6uqJGeyvXpeG8FE+ao=
Received: from pps.filterd (m0134425.ppops.net [127.0.0.1])
	by mx0b-002e3701.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57PCNc4l029977;
	Mon, 25 Aug 2025 16:09:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hpe.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps0720; bh=sQ
	H2klu1q9w/NyJjrasqKq1tGmDd3ucFuLZtG1LKn80=; b=BZv7aZNECNBSQkdGA2
	8twBMjCYGOwkxdSEOXhC1z9DwHwoNNt1eQIq97g8jtcPYLT0e4pRleKzYd4qRlNE
	e5sSQTAOlZqZ7TgRYFJnpqbLO63L23IQ4pZxqF96n0kAsPit9+6Q7Iuqb2+mAHBo
	7aSZn0pRR+1KLabMU+vsqPC/DLUH+aClU0hEvSkluWwqm28t0luI99KzkaS5D6RT
	JrJUiJkfR1LTIDbArRsP93f6yRX5CPDFoy1vS7OFFCXyUfkjR6Y5/jClcq+KYayS
	0hObwpsGkO1tBZgOkG4uI+Vb57PNOGz5uezsDgv8x9MC2rTvyEAZUMm+TxO/dr0h
	kJiQ==
Received: from p1lg14879.it.hpe.com ([16.230.97.200])
	by mx0b-002e3701.pphosted.com (PPS) with ESMTPS id 48q6xvq0wc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 25 Aug 2025 16:09:15 +0000 (GMT)
Received: from p1lg14886.dc01.its.hpecorp.net (unknown [10.119.18.237])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by p1lg14879.it.hpe.com (Postfix) with ESMTPS id 07E97130D5;
	Mon, 25 Aug 2025 16:09:13 +0000 (UTC)
Received: from HPE-5CG20646DK.localdomain (unknown [16.231.227.36])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(Client did not present a certificate)
	by p1lg14886.dc01.its.hpecorp.net (Postfix) with ESMTPS id 10E16801616;
	Mon, 25 Aug 2025 16:09:10 +0000 (UTC)
Date: Mon, 25 Aug 2025 11:09:06 -0500
From: Kyle Meyer <kyle.meyer@hpe.com>
To: Miaohe Lin <linmiaohe@huawei.com>
Cc: Jiaqi Yan <jiaqiyan@google.com>, akpm@linux-foundation.org,
        david@redhat.com, tony.luck@intel.com, bp@alien8.de,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linux-edac@vger.kernel.org, lorenzo.stoakes@oracle.com,
        Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org,
        surenb@google.com, mhocko@suse.com, nao.horiguchi@gmail.com,
        jane.chu@oracle.com, osalvador@suse.de
Subject: Re: [PATCH] mm/memory-failure: Do not call action_result() on
 already poisoned pages
Message-ID: <aKyKort2opfQYqgA@hpe.com>
References: <20250821164445.14467-1-kyle.meyer@hpe.com>
 <CACw3F53KmKRJyH+ajicyDUgGbPZT=U3VE4n+Jt3E62BxEiiCGA@mail.gmail.com>
 <aKd1K3ueTacGTf1W@hpe.com>
 <CACw3F527M-x=UeB0tN_sjCgp_YP_8yLkVRCLP2dLO2bzXrqWsA@mail.gmail.com>
 <14a0dd45-388d-7a32-5ee5-44e60277271a@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <14a0dd45-388d-7a32-5ee5-44e60277271a@huawei.com>
X-Proofpoint-GUID: eAojbwjnBFsxwDzG-eJQqJ_iiTYjmQP3
X-Authority-Analysis: v=2.4 cv=ArTu3P9P c=1 sm=1 tr=0 ts=68ac8aab cx=c_pps
 a=5jkVtQsCUlC8zk5UhkBgHg==:117 a=5jkVtQsCUlC8zk5UhkBgHg==:17
 a=IkcTkHD0fZMA:10 a=2OwXVqhp2XgA:10 a=MvuuwTCpAAAA:8 a=ERPcR_hKxm5yt4fehIQA:9
 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODI1MDE0NSBTYWx0ZWRfX3Fhlj65ssQQh
 iBxTfpOt7lv+4AFi8G63U53mKaWeYuCR6wPS6FvOcefIDLVr6N6IWqxUH+wGfyIm1PIUsrBVcZD
 xqIlK2/HnzT/9/+QzwmaZX2UeC+gfWVsThm2oqmBQaxefjXFfKvAR97DhQmATQIAX/vEV2WZiIF
 RqYr7Mb8Bz6xh1Ih/+HSos4C+lb/V3zaCiNOUp4ZVnbV+svX60RFioRGpOHMOXp/v2Rslx0nTiz
 4Wp9M7oU0f0yaGLDMF/d9hcjqWI8vCWFTBQ+J+u9SVw6kDP4Ut2cFD9R4QnRBfnkUBcHyg9Wg7Y
 6s3brve84JhuX92h9sU5l/FES2uNn7KPFCqzzIGHB0qiBKLYxiFTRDPTkc1lR3nVrmGbpQbmdqO
 wQDgsmx0WHl/S4Owq8wLdwT4udB7hZSv28AaEyOA62CgztPuyFyIuPqdvbzV0MS8pA/gjsQo
X-Proofpoint-ORIG-GUID: eAojbwjnBFsxwDzG-eJQqJ_iiTYjmQP3
X-HPE-SCL: -1
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-25_07,2025-08-20_03,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 mlxscore=0 mlxlogscore=999 suspectscore=0 clxscore=1015
 priorityscore=1501 bulkscore=0 adultscore=0 phishscore=0 spamscore=0
 lowpriorityscore=0 impostorscore=0 classifier=spam authscore=0 authtc=n/a
 authcc= route=outbound adjust=0 reason=mlx scancount=1
 engine=8.19.0-2507300000 definitions=main-2508250145
X-Rspamd-Queue-Id: 266B3180012
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: pyce19sx7bjnf7h3jy97fobfg1tn4xac
X-HE-Tag: 1756138202-852954
X-HE-Meta: U2FsdGVkX1/PZODywPlP5ooXDrHeh70/iqrxwY9wErEney77aW8l9tAgy5kzv9oxEsXlrR272CmoSh2XLltAteQvM00g7jfnlaRQq3lA0O384bT7sCzbPuZjhOb5R1dvLKJz2dJK0//BkObdNqanTVQdk+qwjqBCaTJALHbT4I8AMDcl5hGWCu6bO3WciGG4xUr25+wGUzEgs5iqO0gIFgqrfexAIUkmCkmJjW3EuU7H0a7J8j8504KMbTLAa9zp75PBsNftz6XD20B5YVB1B6ZMkGOFTtLjL9ObHJ/4sP9A3q2fABpzFXx6nGXe1OhjDs29mqnXJqTZURE1DO+bZQKDP4dKM18vJ3BjJRtFL2oCCIJOfdjdZY/mg2rAibPUF8q2XJyHTHk97Y150w0NBPONBx8JkrO64DSbqKWlRWD1ILnVqQZKsvxK+LV1YiBSTVNnbOhldAuMocqJ66xW8Mw+6VgCxs7fBQ/XV/upg12tsIDlgbNYKOKj9SzUJxEZTpBqgvAqzXmPZEg2af4woaCapmM6JhMYdE8pi23Ca27A/ujy+Vk1+a1zVKFxhmrHpanyVwBzWyowXAHbQvo3uQ7JLY/J5MgYjL+NGv1x9mvgGLAE0cIdBd28OwQqrQU0ZpIHYtZN8ZDgguIyIF6clqVE9MSSeXV75tJTkrs4q0NQ/OTh0aZsgRZSSlpn7snE4vdMBblDDCKt9xDVXXyCcKbmXN0OeVhkK3ItNgbLgbHvfzYLSA/r3U9dePafT9Wy4ex3wmtaz3QZBVULhkr67ydD+T0Owt04nBcfY4/3osIWKuBu1rtux2jxwG3euKgxYVaQgFnn7PZSnv+m5yHMMhGV60hbyaJ00CcFQt1p9rVbeF1auoGZegJZlDFJeK2k3m99592bWk+V1Yu7k+AVUQDb+yDM38MrVCbhHSktdn42F3Qpk7az2CKCLzLTVGwCiLzPA32QFLc3TGK6h0K
 IuMtzBHm
 eDDS/3dBPixigAr1PzuG0MSem/iSbP0jIMlUgBVReVOoykT4JWbD3faxlDU6GpOn7uzV/hjMTLdbaxKSeMNmjCGfsvFCzZMdE+95uYX7DfQK4la7+flcb9KlwRcQ22t+GDh/j4Sr5G7o6ZDH3K0QZ1hAEVAHAsZ/aR7nJSi9bK1i8aqjoo8DhiT7RKDJ4K4nLYH9BlLa1l/PuPyoW2CSb0c0wKvE4fPI+NUfycmkgCq1uhonX+CAKOKuUs+0p68UPCGM5yp1PVJ/UNM6zYUPBd+zCrIFapwflGXew/AW/DzOydPz136nI0yszR7R5PoS7+CLkAmJcTEBuGwCMUY6ILunVAVibUJiEJhb7bBb6DjgY7iQrsSxikCn0eYEiWSVdBM/vT0p48NSSZe6i1aLZIKjOgw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 25, 2025 at 11:04:43AM +0800, Miaohe Lin wrote:
> On 2025/8/22 8:24, Jiaqi Yan wrote:
> > On Thu, Aug 21, 2025 at 12:36 PM Kyle Meyer <kyle.meyer@hpe.com> wrote:
> >>
> >> On Thu, Aug 21, 2025 at 11:23:48AM -0700, Jiaqi Yan wrote:
> >>> On Thu, Aug 21, 2025 at 9:46 AM Kyle Meyer <kyle.meyer@hpe.com> wrote:
> >>>>
> >>>> Calling action_result() on already poisoned pages causes issues:
> >>>>
> >>>> * The amount of hardware corrupted memory is incorrectly incremented.
> >>>> * NUMA node memory failure statistics are incorrectly updated.
> >>>> * Redundant "already poisoned" messages are printed.
> >>>
> >>> All agreed.
> >>>
> >>>>
> >>>> Do not call action_result() on already poisoned pages and drop unused
> >>>> MF_MSG_ALREADY_POISONED.
> >>>
> >>> Hi Kyle,
> >>>
> >>> Patch looks great to me, just one thought...
> 
> Thanks both.
> 
> >>>
> >>> Alternatively, have you thought about keeping MF_MSG_ALREADY_POISONED
> >>> but changing action_result for MF_MSG_ALREADY_POISONED?
> >>> - don't num_poisoned_pages_inc(pfn)
> >>> - don't update_per_node_mf_stats(pfn, result)
> >>> - still pr_err("%#lx: recovery action for %s: %s\n", ...)
> >>> - meanwhile remove "pr_err("%#lx: already hardware poisoned\n", pfn)"
> >>> in memory_failure and try_memory_failure_hugetlb
> >>
> >> I did consider that approach but I was concerned about passing
> >> MF_MSG_ALREADY_POISONED to action_result() with MF_FAILED. The message is a
> >> bit misleading.
> > 
> > Based on my reading the documentation for MF_* in static const char
> > *action_name[]...
> > 
> > Yeah, for file mapped pages, kernel may not have hole-punched or
> > truncated it from the file mapping (shmem and hugetlbfs for example)
> > but that still considered as MF_RECOVERED, so touching a page with
> > HWPoison flag doesn't mean that page was failed to be recovered
> > previously.
> > 
> > For pages intended to be taken out of the buddy system, touching a
> > page with HWPoison flag does imply it isn't isolated and hence
> > MF_FAILED.
> 
> There should be other cases that memory_failure failed to isolate the
> hwpoisoned pages at first time due to various reasons.
> 
> > 
> > In summary, seeing the HWPoison flag again doesn't necessarily
> > indicate what the recovery result was previously; it only indicate
> > kernel won't re-attempt to recover?
> 
> Yes, kernel won't re-attempt to or just cannot recover.
> 
> > 
> >>
> >> How about introducing a new MF action result? Maybe MF_NONE? The message could
> >> look something like:
> > 
> > Adding MF_NONE sounds fine to me, as long as we correctly document its
> > meaning, which can be subtle.
> 
> Adding a new MF action result sounds good to me. But IMHO MF_NONE might not be that suitable
> as kill_accessing_process might be called to kill proc in this case, so it's not "NONE".

OK, would you like a separate MF action result for each case? Maybe
MF_ALREADY_POISONED and MF_ALREADY_POISONED_KILLED?

MF_ALREADY_POISONED can be the default and MF_ALREADY_POISONED_KILLED can be
used when kill_accessing_process() returns -EHWPOISON.

The log messages could look like...

Memory failure: 0xXXXXXXXX: recovery action for already poisoned page: None
	and
Memory failure: 0xXXXXXXXX: recovery action for already poisoned page: Process killed

Thanks,
Kyle Meyer

