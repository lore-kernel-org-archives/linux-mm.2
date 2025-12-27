Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7A24BE8FDB0
	for <linux-mm@archiver.kernel.org>; Sat, 27 Dec 2025 01:24:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 455616B0005; Fri, 26 Dec 2025 20:24:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3D8BF6B0089; Fri, 26 Dec 2025 20:24:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2E4AC6B008A; Fri, 26 Dec 2025 20:24:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 1CCD96B0005
	for <linux-mm@kvack.org>; Fri, 26 Dec 2025 20:24:38 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 8CECF1394E3
	for <linux-mm@kvack.org>; Sat, 27 Dec 2025 01:24:37 +0000 (UTC)
X-FDA: 84263506194.06.1A56E4A
Received: from canpmsgout09.his.huawei.com (canpmsgout09.his.huawei.com [113.46.200.224])
	by imf29.hostedemail.com (Postfix) with ESMTP id 0309F120008
	for <linux-mm@kvack.org>; Sat, 27 Dec 2025 01:24:33 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=GMn49GJq;
	spf=pass (imf29.hostedemail.com: domain of tujinjiang@huawei.com designates 113.46.200.224 as permitted sender) smtp.mailfrom=tujinjiang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766798675;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ho5QV9/TnOp2NE1FOM+sYQerAf2ACztkwBtddDPusaI=;
	b=qEXtCM4JAWl82vSOLRHzxGEywmHORp/8UozzjNWY8t5gbvqKqZz4CI6SdyYcBFa8EE6f2i
	xpFT739NkNsubvuw0Pkss9lOJg9xBtOVWkP85fzsQ9haJs3/660jGGWqt4NvRTYzSyIB8m
	VEZnPgetcLrIPBK5Y5sfVEFhTsbaRdo=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=GMn49GJq;
	spf=pass (imf29.hostedemail.com: domain of tujinjiang@huawei.com designates 113.46.200.224 as permitted sender) smtp.mailfrom=tujinjiang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766798675; a=rsa-sha256;
	cv=none;
	b=SLauKV0ebJaaZEZc6EA3lhTLgBlYbtS6WBRA3h7X57FT/aFVBxwjMdoSeJwAE0RDMcUhJh
	U1sd6bgBYZi2Y3zOIpj5HSHZH1br8uf9XjLgpM2jVqhL2c/IwltQtVZNPU6/9nQk0cFC+c
	kb2hT27BHduZpX4g98qpLhGW7Ff3pTE=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=Ho5QV9/TnOp2NE1FOM+sYQerAf2ACztkwBtddDPusaI=;
	b=GMn49GJq/1bIXUv9aQ3x6KUZkCIcE0ds2NorFN8VczLqYae8LYkCnpR4F3AABmGX71AIT+wTz
	/UeqZwVF3ZhPzZk5cYWjgPFWk/oUDxte1kYR1O3FIlvf7PU1EOjRwlWAkJpuel1OviNSQj4gMez
	SCRvf8TPL7UaVrdSwQAYYy0=
Received: from mail.maildlp.com (unknown [172.19.162.92])
	by canpmsgout09.his.huawei.com (SkyGuard) with ESMTPS id 4ddPns1fP5z1cySw;
	Sat, 27 Dec 2025 09:21:21 +0800 (CST)
Received: from kwepemr500001.china.huawei.com (unknown [7.202.194.229])
	by mail.maildlp.com (Postfix) with ESMTPS id 4817740565;
	Sat, 27 Dec 2025 09:24:29 +0800 (CST)
Received: from [10.174.179.179] (10.174.179.179) by
 kwepemr500001.china.huawei.com (7.202.194.229) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Sat, 27 Dec 2025 09:24:28 +0800
Message-ID: <eefae4cc-ec75-4378-a153-c190fdc230c1@huawei.com>
Date: Sat, 27 Dec 2025 09:24:27 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [bug report] memory leak of xa_node in collapse_file() when
 rollbacks
To: Shardul Bankar <shardul.b@mpiricsoftware.com>, "David Hildenbrand (Red
 Hat)" <david@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Matthew
 Wilcox <willy@infradead.org>, <ziy@nvidia.com>, <lorenzo.stoakes@oracle.com>,
	<baolin.wang@linux.alibaba.com>, <Liam.Howlett@oracle.com>,
	<npache@redhat.com>, <ryan.roberts@arm.com>, <dev.jain@arm.com>,
	<baohua@kernel.org>, <lance.yang@linux.dev>, <linux-mm@kvack.org>,
	<linux-fsdevel@vger.kernel.org>
CC: Kefeng Wang <wangkefeng.wang@huawei.com>, <shardulsb08@gmail.com>
References: <86834731-02ba-43ea-9def-8b8ca156ec4a@huawei.com>
 <32e4658f-d23b-4bae-9053-acdd5277bb17@kernel.org>
 <4b129453-97d1-4da4-9472-21c1634032d0@huawei.com>
 <05bbe26e-e71a-4a49-95d2-47373b828145@kernel.org>
 <a629d3bb-c7e2-41e0-87e0-7a7a6367c1b6@huawei.com>
 <308b7b3c4f6c74c46906e25d6069049c70222ed8.camel@mpiricsoftware.com>
From: Jinjiang Tu <tujinjiang@huawei.com>
In-Reply-To: <308b7b3c4f6c74c46906e25d6069049c70222ed8.camel@mpiricsoftware.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.179.179]
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 kwepemr500001.china.huawei.com (7.202.194.229)
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 0309F120008
X-Stat-Signature: wt6ahscyt6pdstyq41mzgh91yzic4p9f
X-HE-Tag: 1766798673-585422
X-HE-Meta: U2FsdGVkX1/dSJBUK8tiGq7IDRLov01FtoaG24AvY89E5cB8DoXK19fwKTnZXFEBX4mssLnlyF8a7lTDbWa8SuWjnepzSgZ4aKKwyWuJy2NSb/3bBYMYKDYDBe8psD2NHwjO5la72//sLJ3AJavegl2/a+8cC/05H3qW09CyMBGeswTmsSGs2F1WAjOHvmR/eBAGXJ0HX+ebHCODd0wKif0PCUJZmVPBGi9q/d3rsjfB1tFo9FA5c+rMc1kb2trmqQV9zmRYp1qM151AhtcWckqAEoxfGr2kW1dSFobWvpPqXr40dwsfN72UztM/00mItXb9Pu1doIi760yRRPrtfVp7wJB6OTJmIsUszE5us0i5W/6/WoJgRWVoSewsFE27myC7RXjfAfkKaj8gIQLDome6arRlTSA2zV3f6KTDqqi585Rk+mY2+Y/cuXLIwJYGC0guZOio7JCnI3D+hCl0D8roI+ZFIiUG8LsVZkV3QMB+WJ5c1kVAX6NXxgi8DyoRLk1nsWyDPYRjCosfDJOp58BvkVDxPcJM5mRl+9AO7xLtAmHQOCggTLnzyXH5vPmPz5sp5NQOuvPxs5mkIOYnhcTvXD8+o5YOOwZpt4hBnudhNCeiuMElr/Ewqczp7ppyY5v0WE+oXJSrpT4f+XCEePbgekf+82Ml0RwIrADhpcigtM1QCGBBOu4nouSkU/FY1qD6WQI1iPnqSWd8G15S4Bh3aRrMOPOXB4zuuUZw4LwbH4ZkH62yIyJi44Aq/fNc5bUcaZ+NziDbIKhtKVPbCN/mOxg/HSY7T76rEWsY4IaT09i5bFXwVa1lz04qupvwKBAk7WINGhpyA4BKpH+394lcz+8hc/7SAkEq/9Mg0lz7PyQAsdTksLG6uRmNKWyPefpt77xo5/0uZ5MIecMQNY8BEaIZLuaINAnJOp8xD7d46VIMMjXJsK0ITasQ59K/BJB0rHEWFNUEM4kyER8
 vtWskj5X
 FTx5qX5CLzsrf1Gt9rlBHiGd6wQqUngSO9VioKoIYQlvevennGcksw9OGQtaZIfUHUQWrTk4U9lLvBg6RYr3BN8fwGih4HhiKq2Uh/S6kmwRsWvWUW3JLFgWgzlAICQtTyZl92CO1kExQ6xjL+3L9joniTibcBC7hFP6+GaI3FOT4WcQVaeO9aJQYivIRMmXjIElUfoNGByOy0XAVAGKPV/MS3jvpUVB9PDLL34xByjX+hpPleJ8e0JdZLNI8h4E78Z764xWJzsYPkFTCJBrtKcjGx1ajJunVutiR8a4wD3Q0bOn+s6NUfJuyXAuc/gRj2XoNj7HpK8FnGwnxIM+GnPn7aSf2hVc18ic6+3WRoBckABz5+/6hRTuanHIh59p22yxM5jCzOgMAfCWKfUA11SN9HZQmTslQo0YeBZ75ru7E9Seffm7CNNGsyXUgkH/lJPFYkYP7nIKKYVvmZv+yvJVUp/lDdpfYdwsdCuAtT4yj8wXbXjR4v1czsF0oDvbn6RYxNUKVIssr3tAlRavkhX8O52zp0wGhIqnO6bBJLKMJl11JwhFlW529igXov0CnY4BIGS4pfguCsKZhc2GtSBXnKA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


在 2025/12/25 12:15, Shardul Bankar 写道:
> On Thu, 2025-12-18 at 21:11 +0800, Jinjiang Tu wrote:
>> 在 2025/12/18 20:49, David Hildenbrand (Red Hat) 写道:
>>   
>>>   Thanks for checking. I thought that was also discussed as part of
>>> the other fix.
>>>   
>>>   See [2] where we have
>>>   
>>>   "Note: This fixes the leak of pre-allocated nodes. A separate fix
>>> will
>>>   be needed to clean up empty nodes that were inserted into the tree
>>> by
>>>   xas_create_range() but never populated."
>>>   
>>>   Is that the issue you are describing? (sounds like it, but I only
>>> skimmed over the details).
>>>   
>>>   CCing Shardul.
>> Yes, the same issue. As I descirbed in the first email:
>> "
>> At first, I tried to destory the empty nodes when collapse_file()
>> goes to rollback path. However,
>> collapse_file() only holds xarray lock and may release the lock, so
>> we couldn't prevent concurrent
>> call of collapse_file(), so the deleted empty nodes may be needed by
>> other collapse_file() calls.
>> "
> Hi David, Jinjiang,
>
> As Jinjiang mentioned, this appears to address what I had originally
> referred to in the "Note:" in [1].
>
> Just to clarify the context of the "Note:", that was based on my
> assumption at the time that such empty nodes would be considered leaks.
> After Dev’s feedback in [2]:
> "No "fix" is needed in this case, the empty nodes are there in the tree
> and there is no leak."
>
> and looking at the older discussion in [3]:
> "There's nothing to free; if a node is allocated, then it's stored in
> the tree where it can later be found and reused. "

However, if the empty nodes aren't reused, When the file is deleted,
shmem_evict_inode()->shmem_truncate_range() traverses all entries and
calls xas_store(xas, NULL) to delete, if the leaf xa_node that stores
deleted entry becomes empty, xas_store() will automatically delete the
empty node and delete it's parent is empty too, until parent node isn't
empty. shmem_evict_inode() won't traverse the empty nodes created by
xas_create_range() due to these nodes doesn't store any entries.

>
> my updated understanding is that there is no leak in this case- the
> nodes remain valid and reusable, and therefore do not require a
> separate fix.
>
> David could you correct me if I am mistaken?
>
> [1]
> https://lore.kernel.org/linux-mm/20251123132727.3262731-1-shardul.b@mpiricsoftware.com/
>
> [2]
> https://lore.kernel.org/linux-mm/57cbf887-d181-418b-a6c7-9f3eff5d632a@arm.com/
>
> [3]
> https://lore.kernel.org/all/Ys1r06szkVi3QEai@casper.infradead.org/
>
> Thanks,
> Shardul
>

