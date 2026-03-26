Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DE344109E53C
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 02:33:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2C1786B0005; Wed, 25 Mar 2026 22:33:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 25A546B0088; Wed, 25 Mar 2026 22:33:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 170836B0089; Wed, 25 Mar 2026 22:33:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 058366B0005
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 22:33:09 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 8DCF9C35EB
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 02:33:08 +0000 (UTC)
X-FDA: 84586642056.25.5C92F44
Received: from out-170.mta0.migadu.com (out-170.mta0.migadu.com [91.218.175.170])
	by imf17.hostedemail.com (Postfix) with ESMTP id 3841840006
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 02:33:05 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=okqT0U1n;
	spf=pass (imf17.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.170 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774492385; a=rsa-sha256;
	cv=none;
	b=EJTOmHvxvCjMXxG8CNQTx8zpx7i+VzxDyfck0ZR/2QEBvH9kiFBk/PyKp2yiMCbRs05KCz
	4SsTfkbDHwnfl1LjmXoMAo4vdGVh/x8JIM2EKermnmjBaEj+KYRTzkzD9NLw3deJQjrtdW
	+8xO7nTeP9xstNUNCKzUzu8GLgiw4Qc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774492385;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uCRjoJaTn3y6hT3QphxtqsB3Bsvh01UxaQBXeZoDVU4=;
	b=MR6pxA+6EcvkUhOHAnhDoqjokVPJ8Xm+YArhj4es0Mhqh/lZR37Le+pcMOJq24bOBnPls9
	uojm0wJmHLg9jzEO6fWruNrL4n+Z6+MxcnSWIVWQyHpJ1Tk/bNeHk+A5Psf+WCdWBcEMuu
	VDfpjUlcvWhBPm/l2PU5bVsZsr1M4TI=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=okqT0U1n;
	spf=pass (imf17.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.170 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Message-ID: <c46cc185-5c23-4145-bfad-5c455b84857f@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1774492382;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=uCRjoJaTn3y6hT3QphxtqsB3Bsvh01UxaQBXeZoDVU4=;
	b=okqT0U1n0SsshunYkv4Hi7vdiYSgo9Y/BfIDQDh3DsvlAKL7ooePGAdDvNrgv185u7Kt38
	qRP3fsWVDLPCVGQ77EqViOA5+CH4mPDZSb/j97UeXj0e9vI9/Le+6ndC81puSkaud9AEpx
	0JQjDRcDSKfF9Ui4PdpuGIXROT1kiBM=
Date: Thu, 26 Mar 2026 10:32:43 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v2 1/4] mm: memcontrol: correct the type of stats_updates
 to unsigned long
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Cc: hannes@cmpxchg.org, hughd@google.com, mhocko@suse.com,
 roman.gushchin@linux.dev, shakeel.butt@linux.dev, muchun.song@linux.dev,
 david@kernel.org, ziy@nvidia.com, harry.yoo@oracle.com,
 yosry.ahmed@linux.dev, imran.f.khan@oracle.com, kamalesh.babulal@oracle.com,
 axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com,
 chenridong@huaweicloud.com, mkoutny@suse.com, akpm@linux-foundation.org,
 hamzamahfooz@linux.microsoft.com, apais@linux.microsoft.com,
 lance.yang@linux.dev, bhe@redhat.com, usamaarif642@gmail.com,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Qi Zheng <zhengqi.arch@bytedance.com>
References: <cover.1774447069.git.zhengqi.arch@bytedance.com>
 <158fa0b1296168047342f02050e9d2bda6888d27.1774447069.git.zhengqi.arch@bytedance.com>
 <fcd29ba1-e02a-4c91-80d1-2d1280e2ff99@lucifer.local>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <fcd29ba1-e02a-4c91-80d1-2d1280e2ff99@lucifer.local>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 3841840006
X-Stat-Signature: xaysy6oykwqtzgtjg61zxpoddezc6mk7
X-HE-Tag: 1774492385-636829
X-HE-Meta: U2FsdGVkX18fctzi7McU/HeKgreRCTwSBrU1w/zEvHgToMqSYPQtKDRjArLKa4wKNQlQrhn2ndfmxCwpL0HEFxz7ts0XYBtmvpPyfBQwt2ZbLeOnrtB6Is6zN99HEqiCvR9RZMgCPnrGu9FfXrBmZo5KiZsPnzOUuACYIlL17S0veb70HyhdjrrgGFrLzwtD3CaXuPAUXhOnmGTPthci8HM/Eud0RgqC1OReo1uJpjccwIe5Jz9i1NP/3h7FSG8YpDsBU+UEAe0IKdZpcmJq/ETF3gLe0OLSV8qu3X2+Cem7a+HRQvQRX6nsZmBDs1LjUXT7nhu+eKcfHWR4QX9kSwMQT2/kYGpK2jEabLTUDP80ert0TTR282hTk8x9GteecKPSROQvrw58Xu8w8T9gIqRR3mfny2yVjjw1TYtHyfCDT21HaD066IQA6dLE675piko5eS2VXqMpsaRr9W5W0rCdaoj0guVb4mi95a8Vm5sZVgshaZc4QdA/UChSmOapb8K9lRvuj+GkAMng7QBm5WkJ42j03LEJFZblO70o9DrBRdqxjQs9WztDg0fWTModpRQMTEdWzgqSQNNtH4F8HFE5NV30xRppX85qiTua2UxDopeJVIZH/cq2c0zaKTIMp9YR2mGtAaNDabHFuO0bf0g3qYkC8/ax/J3PhD4SAFhlDDKGbU2DSqSSMMg6ZkFYGTVC7rLlgOfYLOfiI6aREdGxcj5IYI4+EnSfh+zZR7ifqYVAtkdtbwN32DnXDIHD0FF3XpALfNbcE3UZ1n3LwnX+1S3RFmj4+ARmYUYvuficLiXT5tdoK5JsvEGjq0iKg+8G9uE1gT4I2rjzv5oUSXUDM010z3RtLvUkun2C8niDIeQ94vKfRnkpCrvgzsGh3wyI6nk3t7YsgZJjZ8WtwXeT4D8VtMIh9iVVFAjJ3eVNtV3Wma619Q+KqypzBshqdLxiApSwwRt3rHMgE8x
 7uA7RbmC
 xACiBVqIcv/4/Qz+gUn+/X+k97HNfQz24fF+Pst/CqS16+s0BjOOImp5ObdkH8qA0lN+bx66djrVTlSLsTvAeez+jD7iMiW4o1yNkaTYd+Vo/Al9FCZoH/VWfDAC0CKsPNiFFrmkhwQGuDJOHRqiHFTe/G5niTqvn1+gxvyksqgbMYeusv9FGcKTpg1U6TPfGEgLOU2cnHTI25nc0ZNq6qCBSt+qYnT2vMJypshF6AvYtFItluCNouTZ76Nm4STlicLj4uZcfujA/Z024l8ihKufaS0MLGIxYhVrGn0JmuOMUC1bKwe2pyFYTLSyftkYcoNrASwgOH0ecTak=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 3/25/26 11:28 PM, Lorenzo Stoakes (Oracle) wrote:
> On Wed, Mar 25, 2026 at 10:13:22PM +0800, Qi Zheng wrote:
>> From: Qi Zheng <zhengqi.arch@bytedance.com>
>>
>> The memcg_rstat_updated() tracks updates for vmstats_percpu->state
>> and lruvec_stats_percpu->state. Since these state values are of type long,
>> change the val parameter passed to memcg_rstat_updated() to long as well.
>>
>> Correspondingly, change the type of stats_updates in struct
>> memcg_vmstats_percpu and struct memcg_vmstats from unsigned int and
>> atomic_t to unsigned long and atomic_long_t respectively to prevent
>> potential overflow when handling large state updates during the
>> reparenting of LRU folios.
> 
> Do we need a Fixes, possibly cc: stable for that? Apologies if already
> asked + answered.

Before LRU folio reparenting was introduced, we wouldn’t pass in such a
large value, so this wasn’t a problem. Since LRU folio reparenting is
still in mm-unstable, so I didn't add a Fixes tag in [4/4].

> 
>>
>> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
> 
> Anyway logic seems fine to me, so:
> 
> Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>

Thanks!



