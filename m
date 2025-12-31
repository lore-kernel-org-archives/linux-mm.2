Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9C764EE57D1
	for <linux-mm@archiver.kernel.org>; Wed, 31 Dec 2025 06:29:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A4E206B0088; Wed, 31 Dec 2025 01:29:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9F1646B0089; Wed, 31 Dec 2025 01:29:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8DCB36B008A; Wed, 31 Dec 2025 01:29:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7EDEE6B0088
	for <linux-mm@kvack.org>; Wed, 31 Dec 2025 01:29:56 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C00CA1A5F19
	for <linux-mm@kvack.org>; Wed, 31 Dec 2025 06:29:55 +0000 (UTC)
X-FDA: 84278790750.08.C7E97BE
Received: from canpmsgout03.his.huawei.com (canpmsgout03.his.huawei.com [113.46.200.218])
	by imf04.hostedemail.com (Postfix) with ESMTP id 8F9914000A
	for <linux-mm@kvack.org>; Wed, 31 Dec 2025 06:29:52 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=hVRJCtJg;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf04.hostedemail.com: domain of tujinjiang@huawei.com designates 113.46.200.218 as permitted sender) smtp.mailfrom=tujinjiang@huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767162594; a=rsa-sha256;
	cv=none;
	b=2O8guUNhuBrqfSRK0XqB9PnbQuse20Hrssr2yNJc89VYG5KUg70O9u4j+N5z6d9z8ib7+U
	f852aSu6HUBit1luCxNp9UQdj+WmJDd49XPFSUdFcUBV5PSv5oo94NzmgQhRUkoNzKHiE6
	f9MNt3rLhoWClkQFx4N6Gmzy4hSq5gw=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=hVRJCtJg;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf04.hostedemail.com: domain of tujinjiang@huawei.com designates 113.46.200.218 as permitted sender) smtp.mailfrom=tujinjiang@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767162594;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OBZ82aL9b7XNQ4dgrQ9a9vD5S2v4QAbv6HVlWFGJKqw=;
	b=7CUsTAYuK7EdMivAiK3ciTxV81OvFa8+2/vyJxw3snA0rDy6heQzE/tmEgipGLsJ61dBf7
	XKYj3kyPd8h/QbBV5LnJ81hutPP8tSqC2qlqFTF0Yw4N/P2s54Dhd9Y4e3PQK1wpqHx9zg
	PXO1UuH/uCL01hm5R7VhaL7DdMLq+Ek=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=OBZ82aL9b7XNQ4dgrQ9a9vD5S2v4QAbv6HVlWFGJKqw=;
	b=hVRJCtJglHsECW5aMgKWBl5cpHeS/R1XL6hcv7f97eMiMbMMdCsnDZI3pbDmTEmHEguqOt9zU
	6SCFZT4tliZMGtJS7IIHlVuyBx3QG3pbzF718NMNPXQtYh8PG/YtEtTdhrW2sGDB9RrdfFTTnKW
	yyGhHnhsnKL1c/pbMFqVKFA=
Received: from mail.maildlp.com (unknown [172.19.162.140])
	by canpmsgout03.his.huawei.com (SkyGuard) with ESMTPS id 4dh0NG5zd5zpSvr;
	Wed, 31 Dec 2025 14:26:38 +0800 (CST)
Received: from kwepemr500001.china.huawei.com (unknown [7.202.194.229])
	by mail.maildlp.com (Postfix) with ESMTPS id 77A1520104;
	Wed, 31 Dec 2025 14:29:47 +0800 (CST)
Received: from [10.174.179.179] (10.174.179.179) by
 kwepemr500001.china.huawei.com (7.202.194.229) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Wed, 31 Dec 2025 14:29:46 +0800
Message-ID: <43024ae3-4131-4381-a766-5ca674d3f87d@huawei.com>
Date: Wed, 31 Dec 2025 14:29:45 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [bug report] memory leak of xa_node in collapse_file() when
 rollbacks
To: "David Hildenbrand (Red Hat)" <david@kernel.org>, Shardul Bankar
	<shardul.b@mpiricsoftware.com>, Andrew Morton <akpm@linux-foundation.org>,
	Matthew Wilcox <willy@infradead.org>, <ziy@nvidia.com>,
	<lorenzo.stoakes@oracle.com>, <baolin.wang@linux.alibaba.com>,
	<Liam.Howlett@oracle.com>, <npache@redhat.com>, <ryan.roberts@arm.com>,
	<dev.jain@arm.com>, <baohua@kernel.org>, <lance.yang@linux.dev>,
	<linux-mm@kvack.org>, <linux-fsdevel@vger.kernel.org>
CC: Kefeng Wang <wangkefeng.wang@huawei.com>, <shardulsb08@gmail.com>
References: <86834731-02ba-43ea-9def-8b8ca156ec4a@huawei.com>
 <32e4658f-d23b-4bae-9053-acdd5277bb17@kernel.org>
 <4b129453-97d1-4da4-9472-21c1634032d0@huawei.com>
 <05bbe26e-e71a-4a49-95d2-47373b828145@kernel.org>
 <a629d3bb-c7e2-41e0-87e0-7a7a6367c1b6@huawei.com>
 <308b7b3c4f6c74c46906e25d6069049c70222ed8.camel@mpiricsoftware.com>
 <eefae4cc-ec75-4378-a153-c190fdc230c1@huawei.com>
 <fc73a7a4-c66b-4437-b581-43bd7e5fae8d@kernel.org>
From: Jinjiang Tu <tujinjiang@huawei.com>
In-Reply-To: <fc73a7a4-c66b-4437-b581-43bd7e5fae8d@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.179.179]
X-ClientProxiedBy: kwepems100002.china.huawei.com (7.221.188.206) To
 kwepemr500001.china.huawei.com (7.202.194.229)
X-Rspam-User: 
X-Rspamd-Queue-Id: 8F9914000A
X-Rspamd-Server: rspam10
X-Stat-Signature: yeiz4nnxsmfdc4xbg35dimuy445nmh9t
X-HE-Tag: 1767162592-443669
X-HE-Meta: U2FsdGVkX19J0RRjmfX6sUmK2kg4QTBzCpLbYQaA3/cchCgHx6elNNoTB+SlCKaxKNlIJ3xdLKh9MYBEws7Byc3tvvA1Qcsyn4wRA35cbSB9RamXYfFXM5BmB4wdT9f5qeCxrNNM0XOapkEiGP6gOGEbSmF6uUvV33IPFrl29Pt6gFjU53nmJe/4x2fqbUrURGe2zhPA//Ge1oYJeNdyGx6YXVc2TSBiejkUsdGsuzAcImAEq9c2QkR8BJ9VoK+ZePjhwZj8nzf2O2jgO8oqfOXS9qu9Ky8zbN3nYSldcR7Db6Dyby+IMUQzKM1ZDEysc3gRkTTgHo2a6we+dFwzRRPqHxzMIlmSDvjbB5N9BvwOvJJP5AzUod3f6UXUTY1xIqb0nBTNhDAqO78X6nVMIM5FjFMuPEjXGKoA3ShKjSoxIJ2AVSOJrHeKbaeb4Y7Fok4JwguGH8IQMtxztgPWek8LaVIGjwTwvAT0xwz0S7OHZx2UNkUkIQi8jkx0pFkiCZSTWw98ru6OhusO58eq8/FBaGUL7WJa8XCncH/cgTy7jpC0fj+nDc7Tcyce4DU/poeWfGiz5TnNWDH17VohOkaZIy6/DW9XDcIpBNviW4MstJzix+8tHBwn4oQlSwH1kqDLp/89k9VDKuY8d6WSKG9PO0Z6tYat+AawM00udeB7PAndJ44yNRarpDAsrRrwpLiab6ygh1NO5ZHB7B2iwRBpH7AwVcrcDSANVkynhqFy2M3iJXlUGwAH+f1isyx1qDbZrWxydyxI76j5+HVSSPimvD1ZqlJq+pjQVbiQFlT91dj/BpM5kg/z+kyR/zqgq7A64AYRctibsG3QnhBYljwNb+0zjN9+kt8efQ9JuNYKXQxyX2hRiVqS98/FRKkh4+RvGIF3SKH3kxKOqdKw08k1tmBFy1DCQs9uZOd5m8xWcDj9tu8wlNOCVlOa1wK4ahn80t4u7OXDo6jsFBh
 WRAt811x
 pE/kA7pHx9DgdmrRDwQkH+y8UTioroUjh3toSY5Lx8W1dctj2TD+qkcG4m5ZnSfbd7kxc5eEZrUYw7tV3Bao14rbBHPFx5/JiHrOMZm4ArjvR1CvcxWPu4VrLQTWW33sR4K3/8DFa7DTaZjETe2J4x2Is/Mk5sAudTHln5UwXNK8sH+h1CqExuMlAie1wsQyUfjUbqd6E8TggQLGdV+KOqXksI8kS1mzE2SfSZNa6kBpyvAnD2/XPTQRoMhtcO57RfDcj7f97M5mXBeYF2G7k/EWPa/nMSvmjITx4UhblmTH17eh6ZRjL5Z2H1Lt6ZVYR6Fdk0VQLsAaTmtxEbWkpaq5FmDZJSgp10B05ytU4kq3Zwq7hEvAXta7iT5gfyPhAN3saIYejqCkUncA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


在 2025/12/31 5:03, David Hildenbrand (Red Hat) 写道:
> On 12/27/25 02:24, Jinjiang Tu wrote:
>>
>> 在 2025/12/25 12:15, Shardul Bankar 写道:
>>> On Thu, 2025-12-18 at 21:11 +0800, Jinjiang Tu wrote:
>>>> 在 2025/12/18 20:49, David Hildenbrand (Red Hat) 写道:
>>>>>    Thanks for checking. I thought that was also discussed as part of
>>>>> the other fix.
>>>>>       See [2] where we have
>>>>>       "Note: This fixes the leak of pre-allocated nodes. A 
>>>>> separate fix
>>>>> will
>>>>>    be needed to clean up empty nodes that were inserted into the tree
>>>>> by
>>>>>    xas_create_range() but never populated."
>>>>>       Is that the issue you are describing? (sounds like it, but I 
>>>>> only
>>>>> skimmed over the details).
>>>>>       CCing Shardul.
>>>> Yes, the same issue. As I descirbed in the first email:
>>>> "
>>>> At first, I tried to destory the empty nodes when collapse_file()
>>>> goes to rollback path. However,
>>>> collapse_file() only holds xarray lock and may release the lock, so
>>>> we couldn't prevent concurrent
>>>> call of collapse_file(), so the deleted empty nodes may be needed by
>>>> other collapse_file() calls.
>>>> "
>>> Hi David, Jinjiang,
>>>
>>> As Jinjiang mentioned, this appears to address what I had originally
>>> referred to in the "Note:" in [1].
>>>
>>> Just to clarify the context of the "Note:", that was based on my
>>> assumption at the time that such empty nodes would be considered leaks.
>>> After Dev’s feedback in [2]:
>>> "No "fix" is needed in this case, the empty nodes are there in the tree
>>> and there is no leak."
>>>
>>> and looking at the older discussion in [3]:
>>> "There's nothing to free; if a node is allocated, then it's stored in
>>> the tree where it can later be found and reused. "
>>
>> However, if the empty nodes aren't reused, When the file is deleted,
>> shmem_evict_inode()->shmem_truncate_range() traverses all entries and
>> calls xas_store(xas, NULL) to delete, if the leaf xa_node that stores
>> deleted entry becomes empty, xas_store() will automatically delete the
>> empty node and delete it's parent is empty too, until parent node isn't
>> empty. shmem_evict_inode() won't traverse the empty nodes created by
>> xas_create_range() due to these nodes doesn't store any entries.
>
> So you're saying that nothing/nobody would clean up these xarray 
> entries and we'd be leaking them?
Yes.
>
> "struct xarray" documents "If all of the entries in the array are 
> NULL, @xa_head is a NULL pointer.". So we depend on all entries being 
> set to NULL in order to properly cleanup/free the xarray automatically.
>
Yes

