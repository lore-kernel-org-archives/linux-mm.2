Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C3FF2CD37AC
	for <linux-mm@archiver.kernel.org>; Thu, 14 May 2026 01:14:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 220836B008A; Wed, 13 May 2026 21:14:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1F7A86B008C; Wed, 13 May 2026 21:14:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 13BC96B0092; Wed, 13 May 2026 21:14:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 050036B008A
	for <linux-mm@kvack.org>; Wed, 13 May 2026 21:14:28 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C3C9B8CD01
	for <linux-mm@kvack.org>; Thu, 14 May 2026 01:14:27 +0000 (UTC)
X-FDA: 84764254974.14.EC7D494
Received: from out30-124.freemail.mail.aliyun.com (out30-124.freemail.mail.aliyun.com [115.124.30.124])
	by imf12.hostedemail.com (Postfix) with ESMTP id 7F04140005
	for <linux-mm@kvack.org>; Thu, 14 May 2026 01:14:24 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b="ZD88/Xbb";
	spf=pass (imf12.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.124 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778721266;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=325Nj4SkWAN2yfmB/v07RmcNNk9MGrt8w7gUkkkxemY=;
	b=G70OesMkWaGY8PIsYpDckC9+s38BuwEwhFWNOejJg2/Xa/P/vMfH9pnwsbzQVn0MAzqGD8
	5usGzUU2SiO1SwxjqSNueg8/0Y+PKRMXMDqHeX9PeK6LKCNjUMJ1qnmuMmwJeNgud99njM
	MrQkuh8P/D1Y+CAlc2RjzW7op8QO77E=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b="ZD88/Xbb";
	spf=pass (imf12.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.124 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778721266; a=rsa-sha256;
	cv=none;
	b=BfHEJL1D9DKxnKYyS1JORkPZwcVpisfd+YJPAjGfcDalGyTvXMoxcJwsmhp9aBEokcr15y
	YIK0xCGKFOB2ddYbFQGnSKRnmnLWATVLi+0QvAy5bZAsTEVuxqaoe+Wm5WdwWEvKTq9/Xj
	34dMQUvT+GvTavoobcKtFH2gwJA7tv8=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1778721261; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=325Nj4SkWAN2yfmB/v07RmcNNk9MGrt8w7gUkkkxemY=;
	b=ZD88/XbbsTH71uPva5jkoNIUabXAxvfL+xS0ZNX+aov0OfjxI0QzRGfqDKuiadrgYcX6kElpUF5C2cGmOpOskYvaQZc4gQYg119vsJQVE/vXFP6fXNMwMVU5pizi0w6LMajxvRV8Hw78VS6ziSwXuwFykAHQW9shN2AMvjP9HE8=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R101e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037026112;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=21;SR=0;TI=SMTPD_---0X2v5VKl_1778721258;
Received: from 30.74.144.136(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X2v5VKl_1778721258 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 14 May 2026 09:14:18 +0800
Message-ID: <972a86e9-3c92-4e90-b02b-e9cdb18f0973@linux.alibaba.com>
Date: Thu, 14 May 2026 09:14:17 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 9/9] mm: thp: always enable mTHP support
To: "David Hildenbrand (Arm)" <david@kernel.org>,
 Luiz Capitulino <luizcap@redhat.com>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, ziy@nvidia.com, lance.yang@linux.dev
Cc: corbet@lwn.net, tsbogend@alpha.franken.de, maddy@linux.ibm.com,
 mpe@ellerman.id.au, agordeev@linux.ibm.com, gerald.schaefer@linux.ibm.com,
 hca@linux.ibm.com, gor@linux.ibm.com, x86@kernel.org,
 dave.hansen@linux.intel.com, djbw@kernel.org, vishal.l.verma@intel.com,
 dave.jiang@intel.com, akpm@linux-foundation.org, lorenzo.stoakes@oracle.com
References: <cover.1777663129.git.luizcap@redhat.com>
 <f67da00a825da9097b5faf2f390ad344450b88be.1777663129.git.luizcap@redhat.com>
 <ff7bcd65-d444-4da1-890e-75504303ec3f@kernel.org>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <ff7bcd65-d444-4da1-890e-75504303ec3f@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 7F04140005
X-Rspam-User: 
X-Stat-Signature: a9khuupkgwhkuxincjyqnksrgfbt87a6
X-HE-Tag: 1778721264-823561
X-HE-Meta: U2FsdGVkX1/k9KPdsYdgZmms/u8F4j+KesBAGiTPG5w+by4IEX+TCc4dW5b1D6mY5rvhL6yp4IO1Rcn8z0wJWxUSZ0LuYJu6r7TrU4N5tjgsKoLOmkVX8UhFKkOyBBcd5JGoGVsg/uLzuH8+RLuoBoR3Z0gw0mWkjSTOZy/xd2dqz+QyJIBER5gWBzkxIZ6WJDkeQhn46t3aRzOa7DxaCNfLi7ZXVTqDRyvSxXR9W1oKqQsr73qpoqXV2CwiPNK6TP2Sxu/dpFebvPftcHyow0YC6PvnTmMX/SaMiSXlD+GDN2sj/aSsvklF1Ig9wtN7RXkMIKxkRHkIvGm1xEyZuzlrqnuokJMlnXb4XSiekURwYdOfW5DNGFDhhdpjuP+qBY1vd9UKcteumvv9JFhGMqg2ffjboG5gWXM/qKLld+4ajO2D/MZHB8JnVuo46ZbN+sND6wH5S2mUiSzmIBnvoloi3OE639W1G0O60+uUGzph2QsdKRcOegWhpSbWmA6Vy8EdobhQgAJoBU/nkG4i4oRA4B6BPKj/VJEWrlgk2Tr+/gLFrtCXXZO4xGk8Z7KQ5hL5hGqiZNrOoLfE4mZaayafZye1TlJRgTmEQRIFdLfXlaUhulgzB0GJeJ+koGEQOZJaXJ+06rbAl/WDis7QnbdmVgmShMHNCZ9iyIURSFSa7qAelRtRukRv1GsOssQqaPsp4pDz5jv0SNoJjJPjCT4VFEXvZjs1+NomWlekvB+G1dAH99IKC1Zpd/Vkiw7uqoP3je2uitZDNkwoFp0fOeaDhAFJW4dLfSodewRBSwfUtvcI7NsNMwzR8eiVsSIWfIdv4o04Gz6G9ukVyuQvMeXosmyzxM/WZMRPYEjf9aByLl3VVKntxQotgQIJnH/6qTN6cIKZ9F+5K4L/p2F9fRVnXQnpZOH1VntWT/fFMHl9J0GUF2EoUoJO/GPtVMqY7582ikM9e0CyOGRZ2YX
 kXtxSGZJ
 JtdGLaR2Jgm7vRh2ZZo8rmAXhroCvxgGxQ5S8RLHSfyI741XTmtjEPEAr8lZlHJkD43fXQ/lmhniEBYSTUaHKzspDlcO8qJKEGhTez5ndORRWL0VDi6BjIu1bULoGlSnh4fNqTfXYNuaLsVcEUcszIKwy4K7FCmA+1BEl5O/60xp6Wxg/JuPQC6I7xxUupXLKQyxvwTHlfETeK6H7fg5wsl03xcF4Vr0fJ9Gc+t6Ua8DSCks4cekCj4kcBQBMQK0/iQ7IItmEMIkJoYcOp1XWxNRcwgIOKwvXhwyquGbrEgYcfCZuMbfC4X0w1H5dCcrkISn7VrgzzDikhdA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 5/13/26 11:58 PM, David Hildenbrand (Arm) wrote:
> On 5/1/26 21:18, Luiz Capitulino wrote:
>> If PMD-sized pages are not supported on an architecture (ie. the
>> arch implements arch_has_pmd_leaves() and it returns false) then the
>> current code disables all THP, including mTHP.
>>
>> This commit fixes this by allowing mTHP to be always enabled for all
>> archs. When PMD-sized pages are not supported, its sysfs entry won't be
>> created and their mapping will be disallowed at page-fault time.
>>
>> Similarly, this commit implements the following changes for shmem in
>> shmem_allowable_huge_orders():
>>
>>   - Drop the pgtable_has_pmd_leaves() check so that mTHP sizes are
>>     considered
>>   - Filter out PMD and PUD orders from allowable orders when
>>     PMD-sized pages are not supported by the CPU
>>
>> Signed-off-by: Luiz Capitulino <luizcap@redhat.com>
>> ---
>>   mm/huge_memory.c | 23 ++++++++++++++++++-----
>>   mm/shmem.c       | 14 +++++++++-----
>>   2 files changed, 27 insertions(+), 10 deletions(-)
>>
>> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>> index 32254febe097..c1765c8e3dc6 100644

[snip]

>> diff --git a/mm/shmem.c b/mm/shmem.c
>> index a48f034830cd..23893c2bc2dd 100644
>> --- a/mm/shmem.c
>> +++ b/mm/shmem.c
>> @@ -1840,16 +1840,19 @@ unsigned long shmem_allowable_huge_orders(struct inode *inode,
>>   	unsigned long mask = READ_ONCE(huge_shmem_orders_always);
>>   	unsigned long within_size_orders = READ_ONCE(huge_shmem_orders_within_size);
>>   	vm_flags_t vm_flags = vma ? vma->vm_flags : 0;
>> -	unsigned int global_orders;
>> +	unsigned int global_orders, filter_orders = 0;
>>   
>> -	if (!pgtable_has_pmd_leaves() || (vma && vma_thp_disabled(vma, vm_flags, shmem_huge_force)))
>> +	if (vma && vma_thp_disabled(vma, vm_flags, shmem_huge_force))
>>   		return 0;
>>   
>> +	if (!pgtable_has_pmd_leaves())
>> +		filter_orders = BIT(PMD_ORDER) | BIT(PUD_ORDER);
> 
> Would "disabled_orders" or "unavailable_orders" be more appropriate?

Thanks. Better than my naming:)

> There is no need to disable PUD-orders, as shmem does not support PUD-orders
> (unlike DAX). So you can keep it simpler here.

Agree.

>>   	global_orders = shmem_huge_global_enabled(inode, index, write_end,
>>   						  shmem_huge_force, vma, vm_flags);
>>   	/* Tmpfs huge pages allocation */
>>   	if (!vma || !vma_is_anon_shmem(vma))
>> -		return global_orders;
>> +		return global_orders & ~filter_orders;
>>   
>>   	/*
>>   	 * Following the 'deny' semantics of the top level, force the huge
>> @@ -1863,7 +1866,7 @@ unsigned long shmem_allowable_huge_orders(struct inode *inode,
>>   	 * means non-PMD sized THP can not override 'huge' mount option now.
>>   	 */
>>   	if (shmem_huge == SHMEM_HUGE_FORCE)
>> -		return READ_ONCE(huge_shmem_orders_inherit);
>> +		return READ_ONCE(huge_shmem_orders_inherit) & ~filter_orders;
>>   
>>   	/* Allow mTHP that will be fully within i_size. */
>>   	mask |= shmem_get_orders_within_size(inode, within_size_orders, index, 0);
>> @@ -1874,6 +1877,7 @@ unsigned long shmem_allowable_huge_orders(struct inode *inode,
>>   	if (global_orders > 0)
>>   		mask |= READ_ONCE(huge_shmem_orders_inherit);
>>   
>> +	mask &= ~filter_orders;
>>   	return THP_ORDERS_ALL_FILE_DEFAULT & mask;
>>   }
>>   
>> @@ -5457,7 +5461,7 @@ void __init shmem_init(void)
>>   	 * Default to setting PMD-sized THP to inherit the global setting and
>>   	 * disable all other multi-size THPs.
>>   	 */
>> -	if (!shmem_orders_configured)
>> +	if (!shmem_orders_configured && pgtable_has_pmd_leaves())
>>   		huge_shmem_orders_inherit = BIT(HPAGE_PMD_ORDER);
> 
> Do we really want to change that? We can just leave the defaults as is, no?

Yes, this needs to be handled the same way as anonymous memory. If 
pgtable_has_pmd_leaves() returns false, but huge_shmem_orders_inherit 
still has the PMD order set by default, then shmem would still be able 
to allocate PMD-sized large folios if the global shmem interface is enabled.

