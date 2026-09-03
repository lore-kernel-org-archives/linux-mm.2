Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 21AEFC624A4
	for <linux-mm@archiver.kernel.org>; Thu,  3 Sep 2026 13:47:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 213896B00AF; Thu,  3 Sep 2026 09:47:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1EAEE6B00B0; Thu,  3 Sep 2026 09:47:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 128B56B00B1; Thu,  3 Sep 2026 09:47:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E5AE06B00AF
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 09:47:03 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 7072C16050E
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 13:47:03 +0000 (UTC)
X-FDA: 85172577126.30.06FD43F
Received: from canpmsgout08.his.huawei.com (canpmsgout08.his.huawei.com [113.46.200.223])
	by imf12.hostedemail.com (Postfix) with ESMTP id A3E3140014
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 13:47:00 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=XRoVqDL7;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf12.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.223 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788443221;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kuFl+rvMIhi6ut1C9GlGaV8ipseSsDn8WvDAMrSMbkg=;
	b=bKxXNFjPP1DgM5UYERto7g7k9sMY5IWtxrq9cycY2aD5FLLdK4Rnw1kPF/c3BipRT5k+6Q
	weF/k6hzbkMoti5IkZHsYvF+YWikF/cOI0p4CuRrtHkRDvIkxRHoxFQbq09GS9g5V2jbBY
	W/B4mVx42CQ0gML6SEr5f+2/1d+WIzU=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=XRoVqDL7;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf12.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.223 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788443221;
	b=VcePpTb3cFPcXvZd1dlqTSb+I0ypCn+P0qDJxuR1beDIEUL7cSZO2sa3uTkfnCv0X1v0iV
	jwsGcG4m0p4ivg6fbVE/Ix5OFlYFOrLjrp493ZZK8GU9hGxQv72Ugn5M7BBWst5tQZL104
	HkJm+VhjpFHE/vv+034tyxEnSVAC1Gc=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=kuFl+rvMIhi6ut1C9GlGaV8ipseSsDn8WvDAMrSMbkg=;
	b=XRoVqDL7VXST6Vka40uEIvmWLXP9JKZYKKyxRzhUyUgmxjvRlvhtSMS2PYNnDG9Msmb/sb6EN
	MzONpknM5bEqQJHJX8oti+BTvV0tfKHuCgm5mInE3kdHlMZUSpn4QoCV3GtheUCALmAg8t0gQtu
	dsNbqUMM7QhZRliFVt2KjYg=
Received: from mail.maildlp.com (unknown [172.19.163.163])
	by canpmsgout08.his.huawei.com (SkyGuard) with ESMTPS id 4hbLGD68TbzmV8f;
	Thu,  3 Sep 2026 21:36:04 +0800 (CST)
Received: from kwepemk300003.china.huawei.com (unknown [7.202.195.93])
	by mail.maildlp.com (Postfix) with ESMTPS id BCDFE4057A;
	Thu,  3 Sep 2026 21:46:55 +0800 (CST)
Received: from [10.174.177.243] (10.174.177.243) by
 kwepemk300003.china.huawei.com (7.202.195.93) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Thu, 3 Sep 2026 21:46:54 +0800
Message-ID: <8b4bfff5-6184-4936-9196-49b34260af66@huawei.com>
Date: Thu, 3 Sep 2026 21:46:52 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/4] iomap: simplify writepages reclaim guard
To: Christoph Hellwig <hch@infradead.org>
CC: <brauner@kernel.org>, <djwong@kernel.org>, <cem@kernel.org>,
	<akpm@linux-foundation.org>, <vbabka@kernel.org>, <surenb@google.com>,
	<mhocko@suse.com>, <brendan.jackman@linux.dev>, <hannes@cmpxchg.org>,
	<ziy@nvidia.com>, <david@kernel.org>, <qi.zheng@linux.dev>,
	<shakeel.butt@linux.dev>, <ljs@kernel.org>, <linux-xfs@vger.kernel.org>,
	<linux-fsdevel@vger.kernel.org>, <linux-mm@kvack.org>
References: <20260902131653.1338227-1-wangkefeng.wang@huawei.com>
 <20260902131653.1338227-3-wangkefeng.wang@huawei.com>
 <apgzlDZiLthAD25Q@infradead.org>
Content-Language: en-US
From: Kefeng Wang <wangkefeng.wang@huawei.com>
In-Reply-To: <apgzlDZiLthAD25Q@infradead.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.177.243]
X-ClientProxiedBy: kwepems100001.china.huawei.com (7.221.188.238) To
 kwepemk300003.china.huawei.com (7.202.195.93)
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: y7ey5kusnjzs9sr5j7jaswkyybj4nti7
X-Rspamd-Queue-Id: A3E3140014
X-HE-Tag: 1788443220-147391
X-HE-Meta: U2FsdGVkX19DGA1JCuXQDLjWKLcgSiPjGUGEfa9xtaIJcyRjSv2SknefFGZ4zdfNgkL9ZfMmIC7gzOaoTH7/07ZlQoFAZYxY3lS7islE9Yy7PyhSeVv4/jUvsiaj9ypms9GQ6wJC+KTJBgv3dowRKnD5e1+gYOwiY+cxcdhCWV1n8HKQEfv7oWsT6NqLe08A5ONTS9YZh3xNX+FnUTpcIJ8Lj5fFZzUQjLmUwQUdrokPhq+zt/MmWmzdngOnH/b/KR0EKhFSqygwirokHUU1ikhM/1/8wt+3t06HoaG57jRMWlL+c2ghY39wX3bBWpPSbB9TaMjlNag9N9MLI1jjQhKtZalRxXd9Iu5B5QlLY5QSz21wy2WmhWDDdMyJgsLeucfZNVu/hMtedEKCPQSbBmYTgDaBIgq4hzU59O4L5KFAqRRbwr4KBuKj5avooYm89Y2U8cU6hoGgSD04bUg3GObJo8miMV+ryP7vNaMU4EK35B1xsugVv17vAE8ZCXFSi/tSw4QwyR4SOGESgvrMSTGydToyKBprcyEYEvUx8szz+fLaWRae85wP02vAYMBifjQlyKloqc+bnmM9AAfjUFariCcYqCm6JGlIXiifCGgWfv+NehZV7WJHI5DFZKLzfoS1OvI0HNPM0A+QIEyGTfTZIcqi91n8taXHgVSZZMJOEgzU5jPNIRFRthI9tzOyYfsKZmTdLVqFQuOnv2Tkkbj3SyICgHZn/rvZHaFKeSmpZr07USlaTR1EzXVDNbOQI3lSztATS0ZA6EDn+si4r3GulIbeEe8IKpAqUJ66nJqGXpNnePNGwOkp/kAcQkVCJDNOnU1N6rxDzLHmEzrJ1duwSV/RKUQIiXv7rTyF87ol8vy7h77qTY2cjq1RaBzIwM2JCYRTD15Wmke5/wes3lfyeLJZTLlR50NM2iPad0OHC1T5nSOBbtpjPLPUQmeMpGZylB9RCezLtwC/TG+
 6DHHOdJm
 ANSltyEo+8reTo0sW60Mw4dDZ/+LeW2gNRmBM6CtrEiZUzlILI+yByj4lsUoCbvoHWBbPlwwekayyyVM9OI2zanStpB6jxlLiNqCBvGRNGm1TMgpPXom/j6vBC/xLSw28GoA89tcR0gpaH5CW8d2Anebl0iEwBo38y+saB2iA9I5YGHuN+OX+sL7usdElldsFAah2/fxAVYLx+v85ue8g3we3yPw6tSpHz1oikcoVhGmroAgJu0yTG0IWQhvXUHsCU7Cq0nyJOeDjwf4zA5f4XyF0MIjaqzagBrw+msraZCQf9EcSjFGWBhtHnrFwCEaoHTxc
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 9/2/2026 10:32 PM, Christoph Hellwig wrote:
> On Wed, Sep 02, 2026 at 09:16:51PM +0800, Kefeng Wang wrote:
>> index 0a5ebfda90f1..6306ca747f3b 100644
>> --- a/fs/iomap/buffered-io.c
>> +++ b/fs/iomap/buffered-io.c
>> @@ -2077,8 +2077,7 @@ iomap_writepages(struct iomap_writepage_ctx *wpc)
>>   	 * Writeback from reclaim context should never happen except in the case
>>   	 * of a VM regression so warn about it and refuse to write the data.
>>   	 */
>> -	if (WARN_ON_ONCE((current->flags & (PF_MEMALLOC | PF_KSWAPD)) ==
>> -			PF_MEMALLOC))
>> +	if (WARN_ON_ONCE((current->flags & PF_MEMALLOC)))
> 
> You can drop one set of braces here.  Otherwise this looks good.
> 
Yes, missing it, thanks for your review.

Hi Andrew, I see that you have merged it into mm-new. Could you help fix
it, or I will send a fix patch.

