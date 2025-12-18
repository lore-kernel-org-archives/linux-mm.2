Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 00A3ED65C7F
	for <linux-mm@archiver.kernel.org>; Thu, 18 Dec 2025 02:18:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 667006B0088; Wed, 17 Dec 2025 21:18:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 63AE36B0089; Wed, 17 Dec 2025 21:18:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 567296B008A; Wed, 17 Dec 2025 21:18:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 4184D6B0088
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 21:18:15 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D43DB1409AD
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 02:18:14 +0000 (UTC)
X-FDA: 84230982108.19.E14B4DD
Received: from canpmsgout02.his.huawei.com (canpmsgout02.his.huawei.com [113.46.200.217])
	by imf22.hostedemail.com (Postfix) with ESMTP id DF521C0002
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 02:18:11 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=z8xS0Ku0;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf22.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.217 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766024293; a=rsa-sha256;
	cv=none;
	b=q8xVWJVWaLpqgCAER84TZzA1+sCo+gd2Uh7icCXPdYNpjjk6wi8CmT/ZZDiBEELp84i/kx
	wHZcry+ATO4gUuUrcY4HZiHOLlxsgD/R54qLvJm6LrVUh940GtjatCauLKCa9i0aKSjVbl
	T8AUDuTyxwNRgFpQdCPU18eptsBj7RA=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=z8xS0Ku0;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf22.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.217 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766024293;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mU9pFxcO0/m/HH3q3YJxOTDrfSR1HD2/oA7Tnb2zAg0=;
	b=3jwveOxsG9DbF0tj08xzI9j6vvW7u3/YVCzanPEzMOwYYvjp3Ri7B+JMkqZliQSz6DzZ5v
	pJ1K3BQpHfo58V1JXFASgbzQluOYHW4GM+JDJmzqBvuh8eyL4bzWX97XtDN+e2Fj+lXJ6p
	tnfC8sYgGrJgE9ryGhXte6/97cuI29E=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=mU9pFxcO0/m/HH3q3YJxOTDrfSR1HD2/oA7Tnb2zAg0=;
	b=z8xS0Ku07NSfMV0+Eyjw0tVZd+2KlX5/xZ9iNMjLJk7g7Ezu8uLL02LLnDzGNeOgBxj7LLSFL
	pyoGHKtcJlGOTfIO1UHDoVdjdSIj4M7daExWaLqQIJP/W/0uNfuyblKB5WilT14RNWJiKCJnB6D
	VJhJ83pyUdWc45DEopxByOQ=
Received: from mail.maildlp.com (unknown [172.19.163.174])
	by canpmsgout02.his.huawei.com (SkyGuard) with ESMTPS id 4dWvQ81r27zcb2h;
	Thu, 18 Dec 2025 10:15:12 +0800 (CST)
Received: from dggemv705-chm.china.huawei.com (unknown [10.3.19.32])
	by mail.maildlp.com (Postfix) with ESMTPS id F115814022E;
	Thu, 18 Dec 2025 10:18:06 +0800 (CST)
Received: from kwepemq500010.china.huawei.com (7.202.194.235) by
 dggemv705-chm.china.huawei.com (10.3.19.32) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 18 Dec 2025 10:18:06 +0800
Received: from [10.173.125.37] (10.173.125.37) by
 kwepemq500010.china.huawei.com (7.202.194.235) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 18 Dec 2025 10:18:05 +0800
Subject: Re: [PATCH v2 1/3] mm: fixup pfnmap memory failure handling to use
 pgoff
To: Ankit Agrawal <ankita@nvidia.com>
CC: Neo Jia <cjia@nvidia.com>, Zhi Wang <zhiw@nvidia.com>, Krishnakant Jaju
	<kjaju@nvidia.com>, Yishai Hadas <yishaih@nvidia.com>, "kevin.tian@intel.com"
	<kevin.tian@intel.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>, Vikram Sethi <vsethi@nvidia.com>,
	Jason Gunthorpe <jgg@nvidia.com>, Matt Ochs <mochs@nvidia.com>,
	"jgg@ziepe.ca" <jgg@ziepe.ca>, Shameer Kolothum <skolothumtho@nvidia.com>,
	"alex@shazbot.org" <alex@shazbot.org>, "akpm@linux-foundation.org"
	<akpm@linux-foundation.org>, "nao.horiguchi@gmail.com"
	<nao.horiguchi@gmail.com>
References: <20251213044708.3610-1-ankita@nvidia.com>
 <20251213044708.3610-2-ankita@nvidia.com>
 <f871d90d-11e0-1719-c946-1c0bf341042a@huawei.com>
 <SA1PR12MB7199065CD785B5FD0BFE6FB9B0ABA@SA1PR12MB7199.namprd12.prod.outlook.com>
From: Miaohe Lin <linmiaohe@huawei.com>
Message-ID: <f83bf67a-166e-f224-8b5c-821d8314ca0c@huawei.com>
Date: Thu, 18 Dec 2025 10:18:05 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <SA1PR12MB7199065CD785B5FD0BFE6FB9B0ABA@SA1PR12MB7199.namprd12.prod.outlook.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.173.125.37]
X-ClientProxiedBy: kwepems500002.china.huawei.com (7.221.188.17) To
 kwepemq500010.china.huawei.com (7.202.194.235)
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: DF521C0002
X-Stat-Signature: aifym8kjh7bqcoeh59io86dw56kozsrz
X-Rspam-User: 
X-HE-Tag: 1766024291-348880
X-HE-Meta: U2FsdGVkX1+cLL0+2ooQ5GWn8Rn8/DetUXI4GLM1GQVUpwizsTZtLwNQAymKC/UHJT9gPu/FUORftG+y3Kv/b5JqGjjeyVCpYlanPGv9anYK4S1ffKWfGwqFwkC43muaoDOqVsfzzDAxG5tsoyMHPCjhQlzMTiCsudU+ufzm6xeE49xl657ySh1oZSdZj8qij0Hlzqgso5ZUBAniBLBQfPQHU4IMDD4c/OK76JePoBrFeI73op0umtCa1uYHIi0yH+bk1VXGZ8Ye2qmS0KaEt9+BMI/zXkTA4jUE1e9wbEahexO7KaX+Og1xABTWwwVUFnontb6dC7WECIqj9JapJJPHGyZLAlgUGvaY9Yk6c4kfqUMEy/SQB9GiduuPq656z/oPxSI2fLpzWCSuvF3oeJmB2oiDbKn8m8oXcgYIF9eOmttSGcK0vK0K9jtC0fyqB4d2b5gG+ocSg3noc24eH9/efiFNCqtH6e/fMOsYVKYBGzFIdvyXJS7l+uQHgDelY/mHHlpNEQViJxKvdBMAbmknuWEg31Cb2m66XfIguXZiRTe84CIOu2BllI9OzDLC5Be5Ow9uZzqwqj1roTymo2A7b+JgJHcVdMmaz3X5nLtTLagqOwHuK0tQFz6pWsKZSNk8hBuX9DKT8ce80Ss5h2iVTXCPGUTDFT8DvSM7N8LIP4f7QPGhTpOCWWQxUrS+AF6Ddwwnb4DBcz4dOPndbWFh2CqN7qIGzOxz6rimTzns+yFdcJ1Aew5ggumhD4fLQu3toQjAUbsLq9LDEnN+sCPqNnQU9/+ngbeooDBelI5zVRqtEVnBwywdj8aIuuUI4XPmggfwqdXM2aYzde3coaLhWkMRX5okQToVT02e0IGf/zmxoL2gZ6dYHglALB/jBOajc1x2xFllmSaiWXNVLkhUMVDtQHtxYHhRt8mhH5lDtlY+yDfw8BWJiJZFPtZH7DWO5JCt3S1ulyz6IXl
 cJDc70pq
 L3zfMeSe6bj8KkVzulpp7ldH7AAEBXCImoQlO7SELMtzM0DyoHNqTfagERSzNwIPs1EqB
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2025/12/18 2:10, Ankit Agrawal wrote:
>>>        i_mmap_lock_read(mapping);
>>>        rcu_read_lock();
>>> @@ -2226,9 +2230,12 @@ static void collect_procs_pfn(struct address_space *mapping,
>>>                t = task_early_kill(tsk, true);
>>>                if (!t)
>>>                        continue;
>>> -             vma_interval_tree_foreach(vma, &mapping->i_mmap, pfn, pfn) {
>>> -                     if (vma->vm_mm == t->mm)
>>> -                             add_to_kill_pfn(t, vma, to_kill, pfn);
>>> +             vma_interval_tree_foreach(vma, &mapping->i_mmap, 0, ULONG_MAX) {
>>> +                     pgoff_t pgoff;
>>
>> IIUC, all vma will be traversed to find the final pgoff. This might not be a good idea
>> because rcu lock is held and this traversal might take a really long time. Or am I miss
>> something?
> 
> Hi Miaohe, the VMAs on the registered address space will be checked. For the nvgrace-gpu
> user of this API in 3/3, there are only 3 VMAs on the registered address space (that are
> associated with the vfio file).

Oh, I see. Thanks for your explanation. :)

