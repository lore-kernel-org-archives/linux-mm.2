Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5A47BCD98E4
	for <linux-mm@archiver.kernel.org>; Thu, 18 Jun 2026 01:41:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 16B376B0088; Wed, 17 Jun 2026 21:41:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 11DBE6B008A; Wed, 17 Jun 2026 21:41:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 033566B008C; Wed, 17 Jun 2026 21:41:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D085E6B0088
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 21:41:44 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 55A7014050F
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 01:41:44 +0000 (UTC)
X-FDA: 84891331728.10.7647057
Received: from canpmsgout08.his.huawei.com (canpmsgout08.his.huawei.com [113.46.200.223])
	by imf09.hostedemail.com (Postfix) with ESMTP id 24CDB140005
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 01:41:40 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=jjiKExSK;
	spf=pass (imf09.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.223 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781746902;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KB7csUjkqCLwKqCAvOlpbwC4au/IhiGJxqMpoNRNT1E=;
	b=PabbCoVDWVruRHDZdMwUC7JVYTpffgcdFOrfvdEZqIZ8i/ZuhvBfhjDlF8OhARt3m/qQO9
	vLhmqyFdwd/mBeItNg9HWYJ+cRu2GUFZ09cH6tnniEf8vbdBeoKYjo8SD2a4Xwpe6a3AYz
	qPpspOoC5BEbl+XKNQdUXTExzZiIg8Y=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781746902;
	b=cXAnVLqmzf0dJZFInrw95tc7ZfjzWraR64RrmBWeBXZy1mlatoEWP5ssO02OYHSGLsl1mf
	zQIVyLVz1efOh1QL1Il6PxqfcDktwKjYwljFuRWLRmfVmIbAkjxkBzBE4SCi0t4jC78AJG
	v0Fbmrc0LQn7IRAhLo2Y3dAhr/1NVNE=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=jjiKExSK;
	spf=pass (imf09.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.223 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=KB7csUjkqCLwKqCAvOlpbwC4au/IhiGJxqMpoNRNT1E=;
	b=jjiKExSKFGY5tkBznixEHvsi/twOFcC/ve7bxX7QjN2AYlhc/WBfEMrW+oR3Ra7tEFsVQZ39j
	I+VvJjye7QA6a3DejsCSPtjPcpx0rM0+tbru6tS6OZ5k73dSf+Rz7qEocPRSqOJjhh5T0jKLJ0z
	1DIskqWkJqr2QTrIONy/lh4=
Received: from mail.maildlp.com (unknown [172.19.163.214])
	by canpmsgout08.his.huawei.com (SkyGuard) with ESMTPS id 4ggjt83NlbzmVcS;
	Thu, 18 Jun 2026 09:33:36 +0800 (CST)
Received: from dggpemf100008.china.huawei.com (unknown [7.185.36.138])
	by mail.maildlp.com (Postfix) with ESMTPS id A56D740561;
	Thu, 18 Jun 2026 09:41:36 +0800 (CST)
Received: from [10.174.177.243] (10.174.177.243) by
 dggpemf100008.china.huawei.com (7.185.36.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 18 Jun 2026 09:41:35 +0800
Message-ID: <900d0057-9b21-4bb7-a53a-397079d301e3@huawei.com>
Date: Thu, 18 Jun 2026 09:41:34 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/4] mm: mincore: try per-VMA lock firstly and use
 walk_page_range_vma()
To: "David Hildenbrand (Arm)" <david@kernel.org>, Andrew Morton
	<akpm@linux-foundation.org>
CC: Zi Yan <ziy@nvidia.com>, "Liam R. Howlett" <liam@infradead.org>, Lorenzo
 Stoakes <ljs@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, Suren
 Baghdasaryan <surenb@google.com>, <linux-mm@kvack.org>
References: <20260617082622.3397584-1-wangkefeng.wang@huawei.com>
 <20260617082622.3397584-2-wangkefeng.wang@huawei.com>
 <6f323e68-94be-45e8-aff2-b64f5ef7bb36@kernel.org>
Content-Language: en-US
From: Kefeng Wang <wangkefeng.wang@huawei.com>
In-Reply-To: <6f323e68-94be-45e8-aff2-b64f5ef7bb36@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.177.243]
X-ClientProxiedBy: kwepems200001.china.huawei.com (7.221.188.67) To
 dggpemf100008.china.huawei.com (7.185.36.138)
X-Rspamd-Queue-Id: 24CDB140005
X-Rspam-User: 
X-Stat-Signature: mmbh9w75979x7oi5bnhtpu3fdxqg1sqd
X-Rspamd-Server: rspam08
X-HE-Tag: 1781746900-586386
X-HE-Meta: U2FsdGVkX1/Z66k8hJ6c5dzM+AqfsVYgmnVIiYlZi8xrkwhqCUOGdOMGaICAHq5KkVL89dp9/EbStnYVyVgphP9UtfKXBjGHzlYe8JrlKb//rANs4Y+1Kg/H7i/q+MgsoLz7yu7ArQiTZJrqgE5gI75mHLiMeMyWwhhA0G9Gl9QP9m7OPOr0FBCSA034FP8tZa9g5JbIkXhkaZVkc2WplNvzcYSI6ODlucSzmUJYV8hCM6Bppbp+6xiFnHzJvC/2L2KBjDnbYinx3P79i7m6+L/5PWziqGEtFQzaipX95QUYJfozCyU3lOglx8YrhX7+DHq+v9lwxB8+M7Hj1AlbXWTIY+JYDKYuZ08qt3kh7BCpUeEcjpAjX3ACYSYl6KT2VfrNFO9hAQxdC7jb6aZ+9Sdoy1uY/Bg8m+pObT9EE3XYe4+PfZuA8JOszd/PNthD2gRwA1G4WRLwdv9cDyOaUR09isoF1CLvoGzJdKAjOoA3rFuWgoUBBGhaDMEW29+i8JkDREK0BPq2iDRftklx/4x6gmALJUKF3gooPbQBM94hGSu/FKTCNiFIHz1kOsW55lh+fBjHNAJxbYUkTUw9ToXQBNPQsS82NL7WQmSI2lVFS4EJX+jVQGzD/2PKo8zx+N1/8Ue6gTrtsmqPbZhEHznVQ6ZI28R3ZC5NbqQxpbW1Cohdx0IzNqez0MMj7FrzGpUkJDSALZsSHevVZaAd0qXIZOMqde1fn38YKajk+wmaeq1hETVl1WEfgVWAZaIWGHLSWern1emithWoh95TCtITgTwvrSafpzNmiYRCHAoOT10oyzwyry9j2HdbZFUOhcomRRyZO3igZcEvauqeMLA/ZIg4IMk2auPBhTbg8wUVByMAPGjqyL829v4bQ4Fw+yXOSssOWZ0ve0D1DdS+pH+fKagZCBV/aPDRnLtH2EexV57dyCsGPTFqjt16sL8dNU/uYo4eYRxY2+7l4sF
 RZ0wXOHc
 xfYKoAVL/wz6sRBEY7mQ/eGPd13v1s9Wzj/8S2uVfMyuuP/2QWUQwCFzDKcVsqosB4VElfjkZEmwUZTF/GhRhpD8ZYYXQuO3MFeZ+iGSrw4ZcuD2jJNF7IkynLi35ESNSC4p8HdqK+SLdKnyq6a2ST0EtOL2LIkTfeJJ9F95QXGInBZ4iltFd8VF0EAD0K3Rj2F6V0aumRjKjVKUZKmJGnrkstGAGc0MRP2GHFheA3JZPnnBCiDk8trqMvZA6ExhyEA38r2X7Nqu9lju9SHG5Jz5cH9c4ml11zRsO/BLSz9Qi2bZaPmfgfx7WJ64Y0FnHQvkKEjdnItKQAi3GPeuyA9uS5dDg/0X/wTDtpoSiUR+GJS09SsyIhXpB7anUnVo2d2RS
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 6/17/2026 11:01 PM, David Hildenbrand (Arm) wrote:
> On 6/17/26 10:26, Kefeng Wang wrote:
>> The mincore syscall currently takes mmap lock for the entire
>> duration of the VMA lookup and page table walk. This creates
>> a global contention point with page faults and other mmap_lock
>> holders in multi-threaded applications.
>>
>> The mincore is a read-only operation that only queries page
>> residency from a single VMA, making it an ideal candidate for
>> per-VMA locking, so try per-vma lock firstly and use the
>> walk_page_range_vma() in do_mincore() to eliminates an unnecessary
>> find_vma() lookup.
>>
>> Unlike walk_page_range(), walk_page_range_vma() does not call
>> walk_page_test(), which handles VM_PFNMAP by invoking ->pte_hole()
>> to skip the page table walk. Without this check, PFNMAP PTEs
>> would be treated as present by mincore_pte_range(), changing
>> the returned residency status. Handle VM_PFNMAP explicitly in
>> do_mincore() to preserve the original behavior.
>>
>> Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
>> ---
> 
> I think you should first add a patch that converts do_mincore() to just use
> walk_page_range_vma() -- which is what your patch series "mm: convert to
> walk_page_range_vma() to eliminate find_vma()" wants to achieve.
> 
> Which would already be an improvement :)
> 

Are you suggesting that the per-vma optimization should be separated
out? This change is not too big, and I am fine with either, which
method do you prefer?

> Regarding the per-VMA lock, given that we already drop the mmap lock after each
> VMA, concurrent mremap() would already be able to return funky results.
> 
> So that should be just fine.
> 
Yes, the race already exists, mincore just return a snapshot, there
shouldn't be much impact.

