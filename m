Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8F1C4FF885D
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 12:34:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BF11F6B0088; Tue, 28 Apr 2026 08:34:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BC7E06B008C; Tue, 28 Apr 2026 08:34:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ADD666B008A; Tue, 28 Apr 2026 08:34:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8FE2F6B008A
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 08:34:50 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3D71186984
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 12:34:50 +0000 (UTC)
X-FDA: 84707908740.30.DC2C6B9
Received: from canpmsgout02.his.huawei.com (canpmsgout02.his.huawei.com [113.46.200.217])
	by imf10.hostedemail.com (Postfix) with ESMTP id 6258AC000C
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 12:34:45 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=oJqY9FNE;
	spf=pass (imf10.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.217 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777379688;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zzMDEYzsulY+KHA1t1QmO1PLem7Ek0Kh2oljY0po6pI=;
	b=OHWkAa8WZGBQVCo/YTsI4YB9wEKJw7bURtMrYMYWGQPW46t8Wa9YpEuW5bnZ05jA0Ke9Q1
	dmKBfHzr4z3OnR1vY55xaDHuVXnhWRT2ScyoBaxBV4yywI4doIisr+44SMFuEkgwyffQSJ
	7wWCQDoxRki87/KVJAUwLAs2zfVrG+M=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=oJqY9FNE;
	spf=pass (imf10.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.217 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777379688; a=rsa-sha256;
	cv=none;
	b=1z3jUZJikhpWTyipBaglooTF1PrI5mJB8mPRzN+L4Na30V97LW2fUOgiscwdowSrdzo9n4
	8RUgwGgMD618ylrAM6ziqpoe6gaNkFdxxnIq/pvAWI/XxQJbcr7zD+FgPukRZKGIVdZO01
	iW0CDp7sk2Vv7FhO7FyYRCEuUnfI1Ts=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=zzMDEYzsulY+KHA1t1QmO1PLem7Ek0Kh2oljY0po6pI=;
	b=oJqY9FNEiXJzrwtJNuU8JXsbp+zDI90/SwPURrnq1/rKozrLjwLmQKIY7Wz6VW9wYu7M+Wyv1
	vHIBWPB1HzZkaR/9xd0tPokQaSrfDFVEwjIM1hReOC+Kk6CzY69vcorMt7+fpJbJXmnVFz+q2KN
	Y2qzhTEPruTUvNcKbzV1s9Y=
Received: from mail.maildlp.com (unknown [172.19.162.223])
	by canpmsgout02.his.huawei.com (SkyGuard) with ESMTPS id 4g4fpF67ZfzcZyN;
	Tue, 28 Apr 2026 20:27:33 +0800 (CST)
Received: from dggemv712-chm.china.huawei.com (unknown [10.1.198.32])
	by mail.maildlp.com (Postfix) with ESMTPS id E716140561;
	Tue, 28 Apr 2026 20:34:27 +0800 (CST)
Received: from kwepemq500010.china.huawei.com (7.202.194.235) by
 dggemv712-chm.china.huawei.com (10.1.198.32) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 28 Apr 2026 20:34:27 +0800
Received: from [10.173.124.160] (10.173.124.160) by
 kwepemq500010.china.huawei.com (7.202.194.235) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 28 Apr 2026 20:34:26 +0800
Subject: Re: [PATCH v2 3/3] drivers/base/memory: fix locking for poison
 accounting lookup
To: Muchun Song <muchun.song@linux.dev>
CC: Muchun Song <songmuchun@bytedance.com>, Vishal Verma
	<vishal.l.verma@intel.com>, Ying Huang <huang.ying.caritas@gmail.com>, "Dan
 Williams" <djbw@kernel.org>, Naoya Horiguchi <nao.horiguchi@gmail.com>,
	<linux-mm@kvack.org>, <linux-cxl@vger.kernel.org>,
	<driver-core@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
	<stable@vger.kernel.org>, David Hildenbrand <david@kernel.org>, "Oscar
 Salvador" <osalvador@suse.de>, Greg Kroah-Hartman
	<gregkh@linuxfoundation.org>, "Rafael J . Wysocki" <rafael@kernel.org>,
	Danilo Krummrich <dakr@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
References: <20260428085219.1316047-1-songmuchun@bytedance.com>
 <20260428085219.1316047-4-songmuchun@bytedance.com>
 <fae6e568-fbdd-e697-8ea4-b12c73750ec9@huawei.com>
 <68DFF29C-B3CC-4950-8A8E-7D42350939CA@linux.dev>
From: Miaohe Lin <linmiaohe@huawei.com>
Message-ID: <3697dafa-7ff4-30d9-006b-860299421b63@huawei.com>
Date: Tue, 28 Apr 2026 20:34:26 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <68DFF29C-B3CC-4950-8A8E-7D42350939CA@linux.dev>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.173.124.160]
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 kwepemq500010.china.huawei.com (7.202.194.235)
X-Stat-Signature: 84tt9tz91cyzzz9iq6csjzp4n3nhynt3
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 6258AC000C
X-Rspam-User: 
X-HE-Tag: 1777379685-664537
X-HE-Meta: U2FsdGVkX18pgLe4QzeAzzJA+Iwey8uBi6lMZTgiCJ0aOih1RNz3QPVj0vujWYqv4nLRQj74p5nnMXO+CuEItN9X09vCw8jttnmzxW4xp02Akh39vHs5BnrnBn8mpPCJjLbSaaDUeB4lMNWktNRFLzgG4CPy41Izd2T9Ha9tytjWzCipL/nGhDeXnHgyAiqmSl/z9j8eiA5ws9Dn0vFc7nUaQTwN0FrEdI6kHrSD6X1Xy6RJPTYN+TO5QpeKHGyPsTP6XR2YtNF2oDRyjGSpo8M+uxY4CV14TrHs34R5GecOPEDaPH7wJm6u56SE5D398tZt7D87xks7MFs7h9h/TZXF7Og2gZcqPrQtj7hnFaUGCZ3qXxLkbrW2BFB6GYh1awueb9DHccRRhDjbDg/Jg/eVjFfjf2X0jDdkxXN+W+fjJNp7jUNhXyzhSTcCzCX6sg54ubXSmUIV7jJQTCTmAWiGEGAW8S6B9mIJS/JEyXaZIsupM52Y0uKGQ/dI03VzKxyFpIy+RhXGuEEi0/IbOFYNEvJv/hg/CSKweAE1v1sWu4NXFuhZI9q67bvyXHrsfAaLnHNEVnBCkPxZTXVp4XPFtXXPAdKOLdTUpElclBhXnXQ42Tzeqaroi+/dqLqfqRTu5Nz9irpRJ4IqjbmKqrNFynEQkAx5Hvepxk4rjvaVYOp0XNiSMJsL15MdOhp9Cm623ucCPEfTvGphB7nuMj0FsVza12C2RbMgsocEOoQ4y4cDP2VsIOLEGGtlbJ2V9ZmieObd+OH5tvOTDXDZM1JbYd6jMAkpqgyctiUwUOhFc7xvI6Iqal7PHNrZS3olp6RHToMxJWG0fuJlvJM8LCiqDa4p38RwZQb0U/vYiaQmSerXjtgSyqfhawp3ytFovoZV4kKql/h7bQoX1el19kp7ncdyiBAfbL0Kogm48rdT9SHMKnyu+LO2Zp1V48op6zMM5R+4tpGnPG+qU7J
 RMnXI8D8
 Y5KePHcUqIhToFtvEgjjsG3voFtMRoksvwMksRT2g9GydUiH9bRoOV3hANVyX9xtaAKOIkUCh2t/R6URWXxJdRYPpn/SOGkg63nGi5jfKWLIH2muxYI4R19oEx+A5YrXeEjUiYVPzCvdPL4wACkJtaxOAKgSsMr8lcln2Qx+z/by5BjxE9n2B/woIskjClQkRwSNmUajf4+UOmC/JkGz4XGQa4mc4Rao6htfVlB8KwufcZqZEb8AGMoPdYnNx+/v+yw8es9y9YTxzOYfxYbcsSDZX15oIrIllHfXK8+M7838Dxw3zxCbnJLRmOJ0H2hL5DEAeXLUfq2B+QhElMPrLa7bieUDrcmncvZPUZ9pq/2lC6vqT0e/bCkGstBrtg/GhYWiS10TXn1Znc4V3Z8GK1PtWkKOZSbiGhT5mSLhIGkhAN+0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026/4/28 19:40, Muchun Song wrote:
> 
> 
>> On Apr 28, 2026, at 19:37, Miaohe Lin <linmiaohe@huawei.com> wrote:
>>
>> On 2026/4/28 16:52, Muchun Song wrote:
>>> memblk_nr_poison_inc() and memblk_nr_poison_sub() call
>>> find_memory_block_by_id(), which requires device_hotplug_lock to
>>> serialize the xarray lookup against memory block removal.
>>>
>>> Take device_hotplug_lock around the lookup and nr_hwpoison update so
>>> the memory block cannot disappear between xa_load() and get_device().
>>>
>>> Fixes: 5033091de814 ("mm/hwpoison: introduce per-memory_block hwpoison counter")
>>> Cc: stable@vger.kernel.org
>>> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
>>
>> Thanks for update.
>>
>>> ---
>>> drivers/base/memory.c | 10 ++++++++--
>>> 1 file changed, 8 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/drivers/base/memory.c b/drivers/base/memory.c
>>> index 6981b55d582a..f76aee29e9a5 100644
>>> --- a/drivers/base/memory.c
>>> +++ b/drivers/base/memory.c
>>> @@ -1228,23 +1228,29 @@ int walk_dynamic_memory_groups(int nid, walk_memory_groups_func_t func,
>>> void memblk_nr_poison_inc(unsigned long pfn)
>>> {
>>> 	const unsigned long block_id = pfn_to_block_id(pfn);
>>> - 	struct memory_block *mem = find_memory_block_by_id(block_id);
>>> + 	struct memory_block *mem;
>>>
>>> + 	lock_device_hotplug();
>>
>> memblk_nr_poison_inc() and memblk_nr_poison_sub() are both called from memory_failure() context.
>> I'm afraid if memory_failure() is triggered while lock_device_hotplug is held, it will lead to
>> deadlock. Or am I miss something?
> 
> I am curious is there any place where memory_failure() is called with holding lock_device_hotplug?

Sorry for dumb scenario, I was a bit too presumptuous. But there might be another possible deadlock:

remove_memory
  lock_device_hotplug <-- first called here
  try_remove_memory
    remove_memory_block_devices
      num_poisoned_pages_sub
        memblk_nr_poison_sub
          lock_device_hotplug <-- deadlock here

Hope I'm not mistaken again. :)

Thank.
.

