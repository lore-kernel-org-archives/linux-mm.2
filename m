Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0626FCD98C5
	for <linux-mm@archiver.kernel.org>; Mon, 15 Jun 2026 03:29:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 033BD6B0005; Sun, 14 Jun 2026 23:29:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F00A76B008A; Sun, 14 Jun 2026 23:29:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DC8196B008C; Sun, 14 Jun 2026 23:29:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C7A366B0005
	for <linux-mm@kvack.org>; Sun, 14 Jun 2026 23:29:28 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4B690408A3
	for <linux-mm@kvack.org>; Mon, 15 Jun 2026 03:29:28 +0000 (UTC)
X-FDA: 84880716816.01.C28B94B
Received: from canpmsgout02.his.huawei.com (canpmsgout02.his.huawei.com [113.46.200.217])
	by imf22.hostedemail.com (Postfix) with ESMTP id 073F3C0004
	for <linux-mm@kvack.org>; Mon, 15 Jun 2026 03:29:24 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b="Cw+MEhA/";
	spf=pass (imf22.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.217 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781494166;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QJb9FmlHeruupdTIUIXHdJBdFqX4Ek20qkGI45QfU+0=;
	b=dVePyeZCDgMJAVqnLideuetKfLUs0uu1ZTl7CiIY7QRhg162rfujoBEQhv3rUJfiOctUdU
	hUoCZUawM5P3/8CPXY+H9N3+CeviB9uaeRB5CfUBJcN5yXC2Q6EkBaPPpBvT/Qrgh8t0Xb
	SUNpGKoYMsslIKDJa143806nCiZoA+w=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781494166;
	b=skJ3PD6gLOE6a4bFIWtUeIQfNy+suGvh3ZFMO7iHOcghl9ElvFKvVj7tz/lzmNfbuAJIlo
	a2LhtrA0bJDfcvuwwMZWGF3WNUFN2YyrVBEiu3UTTe3smYe8lmCbqBOM7zPnvr1j8JyVTy
	G2JfqQ02ctTpes4Sbju27r3sDpFKAU0=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b="Cw+MEhA/";
	spf=pass (imf22.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.217 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=QJb9FmlHeruupdTIUIXHdJBdFqX4Ek20qkGI45QfU+0=;
	b=Cw+MEhA/Z9r3S/Yb0WxjaWWfrIiUyusoknamGmnrQxVVKZOtAG/Un1ZKbcNCgCmNpvN/Mx8MP
	BB2TViSG1Gw6XlU8aFpUpnK1x2h+T965BO8X/z0R9wl3Y20UqryBUqVixbJZlxf8K6FQX/QiZZQ
	LheTXmB1a2jCF5U6ytCSM08=
Received: from mail.maildlp.com (unknown [172.19.163.0])
	by canpmsgout02.his.huawei.com (SkyGuard) with ESMTPS id 4gdwPS1pB9zcZxy;
	Mon, 15 Jun 2026 11:21:00 +0800 (CST)
Received: from dggemv712-chm.china.huawei.com (unknown [10.1.198.32])
	by mail.maildlp.com (Postfix) with ESMTPS id D949940561;
	Mon, 15 Jun 2026 11:29:20 +0800 (CST)
Received: from kwepemq500010.china.huawei.com (7.202.194.235) by
 dggemv712-chm.china.huawei.com (10.1.198.32) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Mon, 15 Jun 2026 11:29:20 +0800
Received: from [10.173.124.160] (10.173.124.160) by
 kwepemq500010.china.huawei.com (7.202.194.235) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Mon, 15 Jun 2026 11:29:18 +0800
Subject: Re: [PATCH splitout] mm: memory-failure: serialize
 TestSetPageHWPoison with zone->lock
To: "David Hildenbrand (Arm)" <david@kernel.org>, "Michael S. Tsirkin"
	<mst@redhat.com>
CC: Zi Yan <ziy@nvidia.com>, Andrew Morton <akpm@linux-foundation.org>,
	<linux-kernel@vger.kernel.org>, Jason Wang <jasowang@redhat.com>, Xuan Zhuo
	<xuanzhuo@linux.alibaba.com>, =?UTF-8?Q?Eugenio_P=c3=a9rez?=
	<eperezma@redhat.com>, Muchun Song <muchun.song@linux.dev>, Oscar Salvador
	<osalvador@suse.de>, Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett"
	<liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport
	<rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko
	<mhocko@suse.com>, Brendan Jackman <jackmanb@google.com>, Johannes Weiner
	<hannes@cmpxchg.org>, Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache
	<npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain
	<dev.jain@arm.com>, Barry Song <baohua@kernel.org>, Lance Yang
	<lance.yang@linux.dev>, Hugh Dickins <hughd@google.com>, Matthew Brost
	<matthew.brost@intel.com>, Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim
	<rakie.kim@sk.com>, Byungchul Park <byungchul@sk.com>, Gregory Price
	<gourry@gourry.net>, Ying Huang <ying.huang@linux.alibaba.com>, "Alistair
 Popple" <apopple@nvidia.com>, Christoph Lameter <cl@gentwo.org>, "David
 Rientjes" <rientjes@google.com>, Roman Gushchin <roman.gushchin@linux.dev>,
	Harry Yoo <harry.yoo@oracle.com>, Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, Chris Li
	<chrisl@kernel.org>, Kairui Song <kasong@tencent.com>, Kemeng Shi
	<shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, Baoquan He
	<bhe@redhat.com>, <virtualization@lists.linux.dev>, <linux-mm@kvack.org>,
	Andrea Arcangeli <aarcange@redhat.com>, Naoya Horiguchi
	<nao.horiguchi@gmail.com>
References: <20260609111020.e88f51a7b6ebc37360d66fdc@linux-foundation.org>
 <8c1f468e-b50a-487a-a267-8d1ea5a61c87@kernel.org>
 <FB250C43-790E-4AB0-BD40-74665FC601A0@nvidia.com>
 <38C84F23-E881-4DB2-86BA-93F39D44AE1B@nvidia.com>
 <20260609162437-mutt-send-email-mst@kernel.org>
 <4BA276D9-9EB9-4E2A-8A05-657ACACFF227@nvidia.com>
 <20260609165829-mutt-send-email-mst@kernel.org>
 <dd8d89be-9c73-8ff7-7d44-9705bddeda4d@huawei.com>
 <20260610171646-mutt-send-email-mst@kernel.org>
 <14537566-94d9-eac5-2636-35f925a9d159@huawei.com>
 <20260611013644-mutt-send-email-mst@kernel.org>
 <1b5676ab-0dc5-ef33-9d79-a2bd6090a62d@huawei.com>
 <cbffabdc-42bf-4e67-9d2b-ace9a1e09f29@kernel.org>
From: Miaohe Lin <linmiaohe@huawei.com>
Message-ID: <984d9775-e17c-0231-b021-126b13a9aa42@huawei.com>
Date: Mon, 15 Jun 2026 11:29:18 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <cbffabdc-42bf-4e67-9d2b-ace9a1e09f29@kernel.org>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.173.124.160]
X-ClientProxiedBy: kwepems500002.china.huawei.com (7.221.188.17) To
 kwepemq500010.china.huawei.com (7.202.194.235)
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 073F3C0004
X-Stat-Signature: 1ikxkeemw83wfcj1ui4o1fzzkxss7b1t
X-HE-Tag: 1781494164-920987
X-HE-Meta: U2FsdGVkX1/NYKOn4dL+OPKHzlC3qbjNd4r0oBUqtvcngccRQbOayOYc2TxHWsm6VDKob+STpZmph3C3WzdUIPvJgSAQK66ekohNnpd1Up1zXEwNXy2RRduaKgL23B3egQ3pNtTKm4rz+ix7lkdLwI5njIseMFp3c8IVf3WCva8jfGWvwZ4p76ZEMoSu6bEphmxxEzOYMcp2mUs7z7aoHwcd3vcyba5SR0xsjY0yLIK+itAgZXtxRplQLpyKkRyz0BDD4NpCNX00F5m/VNvl/7ZkC2zA7PYQiFf55iDHTnAg5KD8NOgE3nnUbxOend30cYwMVSj3sUH9yZLle+hIoFi/uPZ3bkL10a0q0Mc/GC5Yc2ZgtBGBN68jvlb8McLkLnIITVgZfeudrOxp7qwqeniXp9kvypyfXjp/md8kTZ9Ve/T5MGSKch7nb23Dsvfy0e7iAwGgZOeMUUs0tDfmfawbTz+9TmPB2Uo1HYBCrO9nhWRLLs7ppepR5RInXspuko8xOSq3S18NuA/kyqRpxMi6T4aaE0n+lmOVp8K270y2IYQxa2/ke6RSnvD127njyT+nHkeIJ9wDpTU+dxU1EWm6h3IZKDrLzuhODE3+sC6dhn8gKcgfn1TrOrHRjjZlvCDDcmPQHdM8ebcT9CKswXdUvLKDVyr4vo91KVwxwaecAmTy6O3M6Zm95iAt1OkzsHiFOkXCtVyZvzIwD2r++p9I/3XKdiBLlki+2pCy6rJtechK279ZMNyjgKs7yq6zSnWuTyyUkfPbceRh6/V3UZr4tEtMD2lHSi0j5Sg33jGkc0k6afeta1l2681ID+0zvlKajtArNjPt7/n76Nn3A9xTArAz2lsfrgpeLyebg3gG2oYD5e9n/7MfzZTO0mJ2iz5gvSk/tnCxr69pAevz89+Op9If20hymWCFZc5mueJEINa+Pw2x1uQc4WrSyIMvvqFvCSwiVDsH5aRteYj
 FUbL+pJ2
 JpmUDVErbqbKHXicabvQAaBEQ2A7QJNH2SUaz7KVo7eGKNtmVacrPkoFns9aeFgioJOfgTbtytGRLK3A5bVVcy8JnjELiqsEgDyn0Ns5maoZkFM/nzX7DJQLUxRvC0HBgqDOkcJvGupy4T4NsqA0+cZH9eEQr4FogwCPEnCf7trQYHYB8hMwp0nOjgu4CaYivWwTLKmCek1WpQeBhiiuoSZ8X5VAWd4FO7R7eqXzviUgOn58C+zdoAxHi+LAqcaydsjzNRHbaZooBM6Dp7WOw3UyjBzKTuhNRhMZPPu5ORV3lZZZqakA8HnWLyddhDMriA3mKdiCRTK/DhMQa45o26P4QD9wqjml1Tmps
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026/6/11 21:20, David Hildenbrand (Arm) wrote:
> On 6/11/26 09:36, Miaohe Lin wrote:
>> On 2026/6/11 13:43, Michael S. Tsirkin wrote:
>>> On Thu, Jun 11, 2026 at 11:35:36AM +0800, Miaohe Lin wrote:
>>>>
>>>> Do you mean repeating SetPageHWPoison on every branch?
>>>
>>> Right.
>>>
>>>> Is it possible
>>>> to make __free_pages_prepare changes page->flags atomically or this race
>>>> is specified to memory_failure?
>>>>
>>>> Thanks.
>>>> .
>>>
>>>
>>> Adding an atomic op on every fast path page allocation is, I am
>>> guessing, going to slow down Linux measureably.
>>>
>>> Doing it for the benefit of memory_failure, which is the slowest of
>>> slow paths, seems unpalatable, to me.
>>
>> Agree, it's not worth to do so.
>>
>>>
>>> Neither am I sure it's the only racy place -
>>> grep for __SetPage and __ClearPage - all these have the same issue, I
>>> suspect.
>>>
>>> At the same time, I'm not an mm maintainer. If you disagree, try to
>>> upstream a change converting all non atomics in mm to atomics, and see
>>> what others say.
>>
>> Since memory_failure might be the only place, this change would be unacceptable.
>> We should come up with a better solution. Maybe we can try repeating SetPageHWPoison
>> and ClearPageHWPoison at a first attempt though it looks somewhat weird to me and makes
>> code more complicated.
> 
> And I am fairly sure we could still have some remaining races ... it's shaky.

I have to agree it's shaky. Any suggestion for next step?

Thanks.
.

