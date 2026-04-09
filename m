Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 901CEEA3C5F
	for <linux-mm@archiver.kernel.org>; Thu,  9 Apr 2026 13:45:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A47036B0005; Thu,  9 Apr 2026 09:45:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9A99E6B0088; Thu,  9 Apr 2026 09:45:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 84A6A6B008A; Thu,  9 Apr 2026 09:45:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 6E14F6B0005
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 09:45:31 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 2FAFD8C488
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 13:45:31 +0000 (UTC)
X-FDA: 84639139662.14.151CE43
Received: from canpmsgout08.his.huawei.com (canpmsgout08.his.huawei.com [113.46.200.223])
	by imf20.hostedemail.com (Postfix) with ESMTP id C746B1C001B
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 13:45:26 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=QqozcRe0;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf20.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.223 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775742329; a=rsa-sha256;
	cv=none;
	b=zoM85tjfClJ9nJPfqVKL2kpZsmlAQfnSD3DMP/f/Nx6UsewW5fydhNZsJ79CmnPq9TLGsL
	Dff/OamAtzVrBVgnxQhwjq4iyacUmndnijPaE2Df1xvy9pUILCpIiinVMWOIgufiV8g5Lf
	ZBLR7323JjMIhyUugUcdxldBXBJtYTU=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=QqozcRe0;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf20.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.223 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775742329;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gJ3AK0pFALltuMA1doiDwlpqhRI344SC4WJuiz5X1dY=;
	b=Zh1CY0VAjkoyNSNpGUV4YpMSoIKlNAaVTBroV0CKiJVP/ZBxkjt9P23/9uzzh8OpKFkuhh
	xBs+fNIMfFNp94xESCPoUaLp09sIWPNLzQ9pxA1WmfsoUVXX+S3+Qfn8dZh/c7Jrw1gQ4B
	d4ZpPOeAnmQlAm41dylY/MX5ECDzX2c=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=gJ3AK0pFALltuMA1doiDwlpqhRI344SC4WJuiz5X1dY=;
	b=QqozcRe0aKq0MNTlS8Hpb0XYFDQ4Bt6buwo6ox398OnNhv5CnKMRSYyPq/jF6/dPTdUhMn2ge
	u2q+qYnbUZb1sKawAVk7hxVOD1D2bMnDnubvnDZahA9guoqsqJSQ6QjlmEGpxqKIcvdLHf6rX/D
	aznrGZ3Y+1+JUPYzRv518fc=
Received: from mail.maildlp.com (unknown [172.19.163.163])
	by canpmsgout08.his.huawei.com (SkyGuard) with ESMTPS id 4fs1HR34HTzmV6X;
	Thu,  9 Apr 2026 21:38:59 +0800 (CST)
Received: from dggpemf100008.china.huawei.com (unknown [7.185.36.138])
	by mail.maildlp.com (Postfix) with ESMTPS id AC28F4048B;
	Thu,  9 Apr 2026 21:45:15 +0800 (CST)
Received: from [10.174.177.243] (10.174.177.243) by
 dggpemf100008.china.huawei.com (7.185.36.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 9 Apr 2026 21:45:13 +0800
Message-ID: <1141f0ca-3b43-455f-bfa3-39c6da68ee58@huawei.com>
Date: Thu, 9 Apr 2026 21:45:09 +0800
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
 <dbb92553-58ba-42e1-b7df-b8450bd69d33@huawei.com>
 <addhuRqrB-u7oDp8@tiehlicka>
 <bdd49511-9b84-42cc-a286-9fdf2ef531a7@huawei.com>
 <adeFBKzNq9rNzbHk@tiehlicka>
 <95bc0034-a72b-449c-9be4-b691fd03dc1e@huawei.com>
 <adejDzw8Mf6407-a@tiehlicka>
Content-Language: en-US
From: Kefeng Wang <wangkefeng.wang@huawei.com>
In-Reply-To: <adejDzw8Mf6407-a@tiehlicka>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.177.243]
X-ClientProxiedBy: kwepems200001.china.huawei.com (7.221.188.67) To
 dggpemf100008.china.huawei.com (7.185.36.138)
X-Stat-Signature: 67ftatjb368cjkt1fhqwmcmqobwsqog6
X-Rspamd-Queue-Id: C746B1C001B
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1775742326-615995
X-HE-Meta: U2FsdGVkX1/NGSGwb8FLb5JrYWndH/UIEeNEBJPlpS8GwRyS8xEq6xohIjLhVG5ssQPGWQZ51a/rfeoHXY9FhGam+ZAqx9iZvj1JUubB8xKF3gbbbeLlCyLeEyB0aCzmDudKIo5VwEdi9YljIpMhL7zx005/RY6wXiZryqFMahl7Vv/A27T3CR8oB+owofwqUCsIOPwnhgX7zCrxmSS6cVCMPa+BxiKn1yBw0vqF5rU7pFlbjFwKfcKN6sa9Dlr5FwdIzVE0alw5/XtQ+92YcbrkzRPOjRghS8gr5dYX2xLK0/eJ60wb1v6hEV2CdmhuSucqxYsckj+NQyy9T1W5BYdsRe7ihx+g1AHV/HtYDgfJeUirDxqJvR5qpC1/JF2nUfNb+r66M5tXjibzrxxUJRv6g/1lo2t5qyjuZ5sSF5PmAM1YQNISDuQwQ6NC3i0uEY/ORQZSYeEqn8rGv81GW5wfAlSKEhsYrPx7yXDn58GItbnYqiiml4XpDB0ZyJP+13sqhOomFJOZ5LIvXS5ecBf6xA2E2GFx2Pys7UaK4UDYsKC2x7Qzv0AaAVixL4Jfj+93jfjAUiSqzRzLmwsay7bzbf6Qs8eS+JJrs198y9A/d6hz4+hxuEKP1/ipUJWGJiMgTakuvuGj+myJWzLGqvBFV9hlRrwpthoqzTupPzz0SJI3cEB1o+e7890hjvp/nC4Jefsbnh0x1rljlU/DQH7iddg/aA9w6j7Ks4Tci4cwUk5NHVWDZcyM7p67qT7kMpl5ltHSJzKzOFYYdnr+bnNw41BPHmJ2+CId6iw2KXB5+ur3KeCFwe1g5sJQZzRXuv+IJuKVZYA1uZO1HYx1KdpRVhZKzRh7MN0Nte8fpu4rzeYBIXcZei0RqCwSlkrCDEINFIBSOASBWs/O0vnLskf3x+pkDWpx3wRpjhSoH5KpTvynb2w53vwRPgoPnADCESNi0Xxnvyj42QoiReL
 rmzwmQXc
 Q65AgCA6HnOuk6G/C9zTWYd2B4Gx8ox0zxyxjZb4Hh6xOKQT44uAzZF9S5kAq5uHJyiffkSyDVhS6pFaAqJMA2LHZZwpZqgsCLRUFHsNKDgswAtWB3c/sVEEcejhLMlfIaUQuCtAggStNPThw2nsE8AxjmYzCsOJACdypGvQvECtwg6IQSjfx23mId7wbWwqtV5JWFmvrP48Wqtn9xUFaFxJdDZZuvTtASeKeVt80VWHrv2DblklEFEAdENYaZbRdtHOE4Jv4FCz2QyyqmDns7CDlSrwWlHO94zEtfTkTD0rVyfC/RKHM13WMfC6s9eBKts0H4QutLqp8XTgoHoyfVl18KMNPAOI5CesrJ42ROsFB3zpoO/8hlcrVJvKEeMvk6aVX/tze4b8MCf8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 4/9/2026 9:01 PM, Michal Hocko wrote:
> On Thu 09-04-26 20:50:33, Kefeng Wang wrote:
>>
>>
>> On 4/9/2026 6:52 PM, Michal Hocko wrote:
>>> On Thu 09-04-26 16:54:48, Kefeng Wang wrote:
>>>>
>>>>
>>>> On 4/9/2026 4:22 PM, Michal Hocko wrote:
>>>>> On Thu 09-04-26 16:08:37, Kefeng Wang wrote:
>>>>> [...]
>>>>>> To use the reclaim interface, there are two differences,
>>>>>>
>>>>>> 1) we need to input the reclaim numbers and swappiness, this is not a big
>>>>>> problem
>>>>>> 2) for reclaim, it supports swappiness=max to only reclaim anonymous pages,
>>>>>> but cannot only reclaim file pages,
>>>>>
>>>>> Why is 2) a real constrain?
>>>>
>>>> This should not be a restriction, but a strategy. Our product wants to
>>>> migrate anonymous pages to the local instead of swapping them out. However,
>>>> the current per-node-reclaim interface does not support reclaiming only file
>>>> pages.
>>>
>>> Yes, I do understand that you want to keep your hot anonymous pages
>>> resident on some node. Those shouldn't be reclaimed by the user space
>>> triggered reclaim anyway, right? Migration will then happen during the
>>> memory offlining.
>>
>> Yes, that we need.
>>>
>>> This will certainly require some fine tuning but I do not see any reason
>>> this should be completely impossible. Certainly a more robust way (from
>>> API POV) than the suggested drop_caches. I am also not convinced we need
>>> page-cache-only reclaim for the existing reclaim interface. I believe it
>>> makes more sense to look at the reclaim from hotness POV rather than
>>> anon vs. file.
>>
>> It is already support only reclaim file pages when swappiness = 0 for
>> memcg.reclaim, but not for per-node-reclaim, so we can just make a few
>> small changes to enable it(no tested)
> 
> This might be small changes wrt code impact but they are changing the
> semantic of the interface and that needs proper analysis of impact,
> potential regression risk and also evaluate whether this is what we
> really want/need. Memcg has been special in this regards from early on
> and we pretty much had to keep the status quo IIRC.


For proactive reclaim, there are three interface for now,
1) lru_gen:  called lru_gen_seq_write()
2) memcg.reclaim/per-node-reclaim :  called user_proactive_reclaim（）


I think it is reasonable to provide more strategic options for user 
proactive reclaim. The new code changes the semantic of lru_gen/per-
node-reclaim, but not memcg, so if we do need to avoid potential
regression, maybe add something like swappiness=min to only reclaim
file page.




