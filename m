Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 21829C5B572
	for <linux-mm@archiver.kernel.org>; Thu, 13 Aug 2026 12:14:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D0A006B028B; Thu, 13 Aug 2026 08:14:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CE1F46B04D0; Thu, 13 Aug 2026 08:14:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C24D46B04D1; Thu, 13 Aug 2026 08:14:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A29B06B028B
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 08:14:41 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 30EA41C0054
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 12:14:41 +0000 (UTC)
X-FDA: 85096139562.01.BC6BF6E
Received: from canpmsgout06.his.huawei.com (canpmsgout06.his.huawei.com [113.46.200.221])
	by imf17.hostedemail.com (Postfix) with ESMTP id 051D840002
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 12:14:38 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=LmsUJYyr;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf17.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.221 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786623279;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5mar/IZUE5TjogPRooZ5SINIofEJGtSownXYdjfo6Ro=;
	b=gbMJu8WiHzR5y9zxswl4WtWgbZv6sOtsPDk1lPllcCgNBsGTr68JKfxTmo/Fpt9tPbLrV7
	jS6Fxim5lhG2uC8S3NR9oe3LUp6/PvswfzAKHVKvqJqpISO0TxXeoXEeLmAvRmZJJ77Dhv
	+gNo6s9XJU/0ctGNdAIA+mWX331pmII=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=LmsUJYyr;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf17.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.221 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786623279;
	b=UObIWUFG8uFgdJn4gYTTbBIsGB1Wg7+hyoR0i3WBiEjnGy4E+e4ELcknGcATEXrZs6Y/oc
	SlsRS1XvB7itVTfn/KxmxMn1eo0Bjr5b4YF2fRgS94F6mUoaQat5H9pFg3BtTbDNRpFXeW
	zj7UB/QE7Pymgv5z+5kAnkil1CnY2MU=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=5mar/IZUE5TjogPRooZ5SINIofEJGtSownXYdjfo6Ro=;
	b=LmsUJYyrGitcmIsyyXrtGOdPNNJuOobKfjvVIu4aXV3JGdz05w4E/VKfaK8NQlEkF40+Eelmf
	LQ8PPhbTs5OlFT6GjvECzNFSGU3fYheCDOx94qL5EejepG+S94T44Vma5oAeimmBqhy5tIMSK4E
	W6SMdxYZsHnyHwDaQCA1hZs=
Received: from mail.maildlp.com (unknown [172.19.162.144])
	by canpmsgout06.his.huawei.com (SkyGuard) with ESMTPS id 4hLPCd75WPzRhR0;
	Thu, 13 Aug 2026 20:03:57 +0800 (CST)
Received: from dggemv705-chm.china.huawei.com (unknown [10.3.19.32])
	by mail.maildlp.com (Postfix) with ESMTPS id EA8E54056D;
	Thu, 13 Aug 2026 20:14:33 +0800 (CST)
Received: from kwepemq500010.china.huawei.com (7.202.194.235) by
 dggemv705-chm.china.huawei.com (10.3.19.32) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 13 Aug 2026 20:14:33 +0800
Received: from [10.173.124.160] (10.173.124.160) by
 kwepemq500010.china.huawei.com (7.202.194.235) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 13 Aug 2026 20:14:32 +0800
Subject: Re: [PATCH] mm/Kconfig: allow user to select MIGRATION if
 MEMORY_FAILURE is enabled
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>, Xie Yuanbin
	<xieyuanbin1@huawei.com>, "David Hildenbrand (Red Hat)" <david@kernel.org>
CC: <akpm@linux-foundation.org>, <apopple@nvidia.com>, <bp@alien8.de>,
	<byungchul@sk.com>, <gourry@gourry.net>, <joshua.hahnjy@gmail.com>,
	<liam@infradead.org>, <liaohua4@huawei.com>, <lilinjie8@huawei.com>,
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
	<matthew.brost@intel.com>, <mhocko@suse.com>, <nao.horiguchi@gmail.com>,
	<rakie.kim@sk.com>, <rppt@kernel.org>, <surenb@google.com>,
	<tony.luck@intel.com>, <vbabka@kernel.org>, <ying.huang@linux.alibaba.com>,
	<ziy@nvidia.com>
References: <837c2e83-ad5f-42f5-afef-5132e02fc19a@kernel.org>
 <20260813092343.214324-1-xieyuanbin1@huawei.com> <an2PGVZuYruQhzel@lucifer>
From: Miaohe Lin <linmiaohe@huawei.com>
Message-ID: <83554fb5-d105-56da-dbe4-68fde533199a@huawei.com>
Date: Thu, 13 Aug 2026 20:14:31 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <an2PGVZuYruQhzel@lucifer>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.173.124.160]
X-ClientProxiedBy: kwepems200001.china.huawei.com (7.221.188.67) To
 kwepemq500010.china.huawei.com (7.202.194.235)
X-Rspam-User: 
X-Stat-Signature: tgw1mmh83qo61yrhym8mhb64qu93h84d
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 051D840002
X-HE-Tag: 1786623278-357597
X-HE-Meta: U2FsdGVkX1/Kqc45MprFdbm+mL3mZqTUsMW2KuhYL2D/tLM/ywSjfiVjY+Hy/dGsX7D2wUoaHBWt6wXVzTqA5pLy4pJahyXXOLnferMjy66rWRU+Hh3TD2+KOfpiSuEOfK1iAdQ2rB6VMHYKxyruvhoRbqelqE7bOzsJiVFhhp2L+/lFeulV4eySkjLb6+m/K7ZcgLPi6mNs4FTLc40zPSh5qp37dR1cUy3+8+vyOIzU1vYrI04NnkMPO9o+vrs9XfJng01f4Dc9H1hTmj8skgdampJwgQpRi4Te/JLE++iqKnDA5+ok2/Aesq14iM8+EQ9Pj8KErwy6cdnuObbnIiuWFio6qNVfbO9bRzGVomGQLSGDeL9cqWt/ZxtCi3Yy85iKEd+0ujZgZC6G2c8SzCZkCvmeJNCmH8MWrJ7Ln+wZkKAQBd3SaEeVrLVDGBVGKDf1bYDJYAAL9lr/CQBps2nmezfF5qqls2f81KzHUlJa4vm5fs5K7hvvUHkGNKfFV30K3RXl+0Q5TUvpjDafZ//16EQIW/5mvTHpQESYrljZ+awbHWswXOsWdVz6XDgvIFzeMV1XeLGeT9tcVvms7YWucB6gCll0ZlP7NQ2uIpsEvQeQ98JRwdEQVb7688uyvLEiJkgtYSEwxC0xFEiZnCJFzz8QgSrpHUModWi0aN3aGWf1dUgSJ7JhuEMZd0xeErn5Z5ojxEg8akfta99v9nL6CTzZCQybJQmjWMazZIBV4r1WvdZQhNVEJZs0s0PV+T3dQHi6HcemHG2s2R5JOBMcrhzz0xM9wZBVgQ/6tAf8qQjA8bTe+j/fMGVUG28PJCUzXfBCk9XzzdsbexBfJWHg7zu39ecJyO8kp8e2ehCatNV4/WwyOVaXMiGTRSWJjxuv4pjsOXmAjcfWsGir1XdWMKAGQOIT6txWAAaCOl34tnaYG7r4gz2OV6k25HP0AGP/p6pa5r1D9YDjY2W
 hD4+SesO
 Tal/t4Nqer62b32taJolXGPm5V8eHruLfJaZ19HgdoHTtm+o3zkAPe0vVPlBQFGjAYzzybXhj4hMuCocwR7Zej5B1sM8BPcqRPPfOkBDwSXwZBxH7wf4K7gx3Cg33m03K4rDTcleOA4M0jz1OTNXphTY9JyweGVhJcCtUfZpgmeNNSgL9LSenVf8wIWcWxeIPmMEdelNDJSSGzGbwyVH1W0eY6qui6vxOuMY5QfT0UUPucCDO+ilR/A5odAC76WAchm+biI5p2dT9aX4B/uDl6jmzWikOf9q5Kg5moiIB3CgUSkd4ogHMgFJpLQLQ/o4jutnYhqHTxQby5iMfgK3VwZWZ9xaJKZmsrNNgc4QTvcgBaD+BslQ0IdFv5XjNXb4E6A+BEci5PatWfPZlU9eEi8O+iA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026/8/13 17:32, Lorenzo Stoakes (ARM) wrote:
> On Thu, Aug 13, 2026 at 05:23:43PM +0800, Xie Yuanbin wrote:
>> Thanks for replying.
>>
>> On Thu, 13 Aug 2026 11:11:11 +0200, David Hildenbrand wrote:
>>> On 8/13/26 09:23, Xie Yuanbin wrote:
>>>> I think that just making MEMORY_FAILURE select MIGRATION is also a very
>>>> good solution, and I respect the maintainers' opinion.
>>>
>>> There must be a good reason to do something fine grained like
>>> MEMORY_FAILURE_MIGRATON, really.
>>>
>>> So if there is a use case out there that absolutely doesn't want
>>> CONFIG_MIGRATION but does want CONFIG_MEMORY_FAILURE, we could discuss it.
>>
>> At least so far, I haven't encountered such a use case.
>>
>>> As really only softdirty needs page migration (IIRC), we could also just put
>>> that under a separate config that implies CONFIG_MIGRATION, like
>>> CONFIG_MEMORY_FAILURE_SOFT_OFFLINE. But I'd rather avoid that unless really
>>> required.
>>
>> Okay, I understand it now. Making MEMORY_FAILURE select MIGRATION should
>> be enough.
> 
> Agreed with all that David says, and yes that seems the best way.

+1.

Thanks all.
.

> 
> 
> --
> Cheers, Lorenzo
> .
> 


