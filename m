Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 581BCE9DE62
	for <linux-mm@archiver.kernel.org>; Thu,  9 Apr 2026 08:08:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BACE66B0005; Thu,  9 Apr 2026 04:08:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B5E066B0088; Thu,  9 Apr 2026 04:08:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A74356B008A; Thu,  9 Apr 2026 04:08:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 981986B0005
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 04:08:51 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 5D277C22C4
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 08:08:51 +0000 (UTC)
X-FDA: 84638291262.01.B8BF0E0
Received: from canpmsgout02.his.huawei.com (canpmsgout02.his.huawei.com [113.46.200.217])
	by imf16.hostedemail.com (Postfix) with ESMTP id 74A5E180003
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 08:08:47 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=Qg3MJHeR;
	spf=pass (imf16.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.217 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775722129;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2wKIVbg9ebDYTSOl8F0vaTg0+4KOKttW9ZEjysh+UqA=;
	b=nv0Vn8SzTP+JO035ayGmKSGx701f68qVVvaBrbz+6O4HhG9mQNehKnejsMSX/9Io1tM0bj
	n5Q8eD4CjTkXauyuQFp6ossHzWc5VSWmuaJ82BzE/LsCWUUS32FChTXRZhXPLjQT5ycID8
	y4m2uawCjpIrJKNwueQ2Q0glONNE2q0=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=Qg3MJHeR;
	spf=pass (imf16.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.217 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775722129; a=rsa-sha256;
	cv=none;
	b=45vNcWi3OBxaIze2sT2yVFYIy9FfHvKNovg4cITymjVRgA5cguq9SriN6eXoE87uFRHZ8H
	F2H7a+LnJKaBYNHn1kwcTw0t2bIpmuEGmm7l/ipffPI9qbw48cFQJ6XylJifB3nXY7g7yI
	7KgNEaDFUCNmDZvgYaiBIajAghXu0fY=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=2wKIVbg9ebDYTSOl8F0vaTg0+4KOKttW9ZEjysh+UqA=;
	b=Qg3MJHeR+jC0YBSXUgSxWuy6TUsy0aGjFOw80rQSgUK48+NK/rpO1fdY3TzRVAFSPIcHtz8Sz
	v/d5xZV7DUgWv/jLOq1H5ZMGpitBSjxW/fTB9PfAKtZc73XL2kebD5f65nA+rKFw55fy9KS5UkA
	E78O4/vVhCfmVPplr/JmIpg=
Received: from mail.maildlp.com (unknown [172.19.162.144])
	by canpmsgout02.his.huawei.com (SkyGuard) with ESMTPS id 4frsq44MT1zcZyR;
	Thu,  9 Apr 2026 16:02:24 +0800 (CST)
Received: from dggpemf100008.china.huawei.com (unknown [7.185.36.138])
	by mail.maildlp.com (Postfix) with ESMTPS id A903D40538;
	Thu,  9 Apr 2026 16:08:43 +0800 (CST)
Received: from [10.174.177.243] (10.174.177.243) by
 dggpemf100008.china.huawei.com (7.185.36.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 9 Apr 2026 16:08:42 +0800
Message-ID: <dbb92553-58ba-42e1-b7df-b8450bd69d33@huawei.com>
Date: Thu, 9 Apr 2026 16:08:37 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC] fs: drop_caches: introduce per-node drop_caches
 interface
To: Michal Hocko <mhocko@suse.com>
CC: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand
	<david@kernel.org>, Christian Brauner <brauner@kernel.org>, Alexander Viro
	<viro@zeniv.linux.org.uk>, "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Jan Kara <jack@suse.cz>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, Lorenzo
 Stoakes <ljs@kernel.org>, Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan
	<surenb@google.com>, Vlastimil Babka <vbabka@kernel.org>,
	<linux-fsdevel@vger.kernel.org>, <linux-mm@kvack.org>
References: <20260409063503.3475420-1-wangkefeng.wang@huawei.com>
 <addP4MKmA8zfSN1o@tiehlicka>
Content-Language: en-US
From: Kefeng Wang <wangkefeng.wang@huawei.com>
In-Reply-To: <addP4MKmA8zfSN1o@tiehlicka>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.177.243]
X-ClientProxiedBy: kwepems100002.china.huawei.com (7.221.188.206) To
 dggpemf100008.china.huawei.com (7.185.36.138)
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 74A5E180003
X-Stat-Signature: x7qs8a3e61pkazjx185yec87a5d8cqy7
X-Rspam-User: 
X-HE-Tag: 1775722127-990970
X-HE-Meta: U2FsdGVkX1+YD6KSN62U+4tzbeLeF9QzsuawG54uuNDBVm4NsncQVL1wEeinBKGJSERF0Cb5fnN5gmoOWHM90molohXTZN+YFZrhYORr+BE/DmWQogNR5TQpj2kmSTZ/Hg22NkBBM+iQLUuMHOfb2j1qcPj4Tj7zxP1yaNRSW1gomUGzU82y9D/tNkPlCaSd4FsXaKmDBWtFmVNs3kU/yJv7i3h6D9GSh574EoX+rvWgYUmNrzJMyD8LXKBPLyd2iDzCrAiPy0InTMLqvptrq6R7J0qC8A0ddtFMpiQ546KvrzDwDkI5T6pHiVg5yeJ4By5zx9aWZRxyVIPUGSOnpn1EnD6hlPu3o/ClfJK+Tm7fTLuL35ea6I+rxxLk8ZilXoxQRLVn72zflFtiukVxwz4XbWZWS97t56NM26rpHXdq46UfjQ7NgQ4yJmG2d1SJTTrJNJl/2i1UfXZjNBr4Q/gf5Ta3p35ohUINZyvCRVj2BUq6yy4utX0jNu5wR6fx3u0/di0SWc40y1CRmBHmVTgz0Ewg/DIzSI/gy40N19D7bvVnBfsms64hyGwdOkX/M1wcGOMB3J+6lVJL77E9vWm4ZTSG8Ks7MfMnEBmO0T1MMpK4DRZ/GuAzXdcexA/koCaRNM0xbMigHbwIuUT3gFxPVphRgv4SCXgudFjnNGDvnRXk8PCjOKd+EaYo6+GYCCd/njpyIXC/liWl35QyLFyi1vpCcW1iB8WLK6ZRPMBUaQmXccNbt+3d8RcEBsh4yU1fkTtfZub6f7QNCAXAyzNzqwKyq+LQ6PFDc9hFg0NhDE8vbymdnEtSgKdildNFz2PCCuL8R7jJ1eIKlwSAXP316Kt7SRNiglsReO3/GWFTcMd/d/VcPwWxEU8undviBfvAHvYMNS9CjK3lZyNr0ypikMFl1939dSqV2tShJ+15dVW++ZDz/iNZMe5QB2d85NdoikXC5AvTxk+RDLV
 T/EHTDmz
 nGCVOClUnmiTIGIL/KRDp7IwHRxleuJL6iwWAoQArq2FhgYkslGcHehWxn9o8/wMB04R6dzlMfmUvXG3QHh4f4UQbYZ00nM2AMN16Id9qR8a6gqGBJUOlhztZRCcM6C2IIcyZdzaFCXDmwqJIfkIzKi9nh+Vpu2rcI/rjvdigklhQPRcABRunzjnQUNeBP/eFrOCQgm2OE66LBzYQHFjpfOiKdkb+8Zds2VxAZpLQMis2MwnJ3+OKJNGkeoWpF1AyVr0DCifs/kBhE1N1VAHUHmvxJBrHLQRgXH608uM0Kxr3INgOJH1pRcOFEgqafrjTzMPFOusebkTHLTg8ERO/+nb62PXj1lqWjo8X7XAYoFbTr6I=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 4/9/2026 3:06 PM, Michal Hocko wrote:
> On Thu 09-04-26 14:35:03, Kefeng Wang wrote:
>> Add a sysfs interface at /sys/devices/system/node/nodeX/drop_caches
>> to allow dropping caches on a specific NUMA node.
>>
>> The existing global drop_caches mechanism (/proc/sys/vm/drop_caches)
>> operates across all NUMA nodes indiscriminately, causing,
>> - Unnecessary eviction of hot cache on some nodes
>> - Performance degradation for applications with NUMA affinity
>> - Long times spent on large systems with lots of memory
>>
>> By exposing a per-node interface, admistrator can,
>> - Target specific nodes experiencing memory pressure
>> - Preserve cache on unaffected nodes
>> - Perform reclamation with finer granularity
> 
> Quite honestly drop_caches is not the best interface to build any new
> functionality on top of. It has backfired a lot in the past and we have
> tried to make it extra clear that this should be used for debugging
> purposes only. Extending it further sounds like a bad step.


I am not clear about this history of this interface, but some of our
products do use this interface :(

> 
>> One use cases is hot-pluggable NUMA nodes, during hot-remove, simply
>> dropping pagecache is far more efficient than migrating large amounts
>> of pages to other nodes, which also eliminating the risk of accessing
>> potentially faulty memory.
> 
> Does the per-node reclaim interface can help with this by
> any means?

I have also considered this interface. As mentioned above, our product
uses drop_caches, so it is easy to convert to using the per-node
drop_caches interface.

'echo 1 > per-node-dropcaches'  VS 'echo XG swappiness=0 > per-node-reclaim'

To use the reclaim interface, there are two differences,

1) we need to input the reclaim numbers and swappiness, this is not a 
big problem
2) for reclaim, it supports swappiness=max to only reclaim anonymous 
pages, but cannot only reclaim file pages,

So if per-node-drop_caches cannot be accepted, we can consider expanding
the reclaim interface to reclaim file pages?

