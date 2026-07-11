Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0B13DC44501
	for <linux-mm@archiver.kernel.org>; Sat, 11 Jul 2026 08:03:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D443D6B008C; Sat, 11 Jul 2026 04:03:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CF5066B0092; Sat, 11 Jul 2026 04:03:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C0AF26B0093; Sat, 11 Jul 2026 04:03:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A35476B008C
	for <linux-mm@kvack.org>; Sat, 11 Jul 2026 04:03:09 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 13043C1E4E
	for <linux-mm@kvack.org>; Sat, 11 Jul 2026 07:53:57 +0000 (UTC)
X-FDA: 84975732114.10.EDE4B61
Received: from m16.mail.126.com (m16.mail.126.com [117.135.210.8])
	by imf08.hostedemail.com (Postfix) with ESMTP id 2D81A160005
	for <linux-mm@kvack.org>; Sat, 11 Jul 2026 07:53:52 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=126.com header.s=s110527 header.b=iLrS1o52;
	dmarc=pass (policy=none) header.from=126.com;
	spf=pass (imf08.hostedemail.com: domain of zhongling0719@126.com designates 117.135.210.8 as permitted sender) smtp.mailfrom=zhongling0719@126.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783756435;
	b=SXlOud0Ovjb+C9jXr7OX3zQJHOP6MWPqh2UpX9aAwWGP6CKMkcjEdeTqJHZOLFSFKw1sCO
	1pp2664V+uvHkJY0Malp1IX0KHpCWfQeH7hGiYoFgRUESg7X2JqS/UTGcCLztCt7ROfk8/
	chbCMF3xAYUfXaJNolL7UDOyffZFPRg=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=126.com header.s=s110527 header.b=iLrS1o52;
	dmarc=pass (policy=none) header.from=126.com;
	spf=pass (imf08.hostedemail.com: domain of zhongling0719@126.com designates 117.135.210.8 as permitted sender) smtp.mailfrom=zhongling0719@126.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783756435;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Og51IuOMC4sUgh7fHR2b6CD95EpwXnuhBRb4AGzlVns=;
	b=SowO06+FhODneuGEMyvQLH+nGEIxtf16U/NbANNblvFoU90CFKxnHT3eeCQteP5r5Sn20r
	LNdmqwZ7OwFkFS3PrHWBPo9yVf9rZ9CA2LjCwUEoZRigJIPdeQeqWpP6OX9P1JdHv4e54G
	IwjDvVvLtjm3S+1LOYrXv7pI4Ou2C3I=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=126.com;
	s=s110527; h=Message-ID:Date:From:MIME-Version:To:Subject:
	Content-Type; bh=Og51IuOMC4sUgh7fHR2b6CD95EpwXnuhBRb4AGzlVns=;
	b=iLrS1o52zhz1omy5BiOwM+PF7EyU1ALML7GEsKGeoAjdlotGRCVnQHhDho99W7
	o6o0et3Bk5bLwmyvqsxJ60LVaAtkpOdqB6pVOb2ZXbdX/vWSp3TFaZqbQQfE3Pcr
	zuKDqh+0GgXI+EZ+ZRVKmrXqCLga2McspF/tOQURWtF6g=
Received: from localhost.localdomain (unknown [])
	by gzga-smtp-mtada-g1-3 (Coremail) with SMTP id _____wD3b0CA9lFqJAzODA--.38605S2;
	Sat, 11 Jul 2026 15:53:36 +0800 (CST)
Message-ID: <6A51F670.9020104@126.com>
Date: Sat, 11 Jul 2026 15:53:20 +0800
From: Hongling Zeng <zhongling0719@126.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Qi Zheng <qi.zheng@linux.dev>, 
 Hongling Zeng <zenghongling@kylinos.cn>,
 akpm@linux-foundation.org, david@fromorbit.com, 
 roman.gushchin@linux.dev, muchun.song@linux.dev
CC: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 stable@vger.kernel.org
Subject: Re: [PATCH] mm: shrinker: Fix double-free in alloc_shrinker_info
 error path
References: <20260711041954.95749-1-zenghongling@kylinos.cn> <ab1bdfa0-7382-4d26-a65d-68eb172eb84a@linux.dev>
In-Reply-To: <ab1bdfa0-7382-4d26-a65d-68eb172eb84a@linux.dev>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wD3b0CA9lFqJAzODA--.38605S2
X-Coremail-Antispam: 1Uf129KBjvJXoWxuF1fWFWrWFy7CF43Cw1fCrg_yoW5ZrW7pF
	Z2gayDKFW5A3409r1av3W7XrySqw1Fkr4rGwnaqw1jyr1fuF1aqr47Ar4a9ryDu3WxGF4D
	tFWDXr1jgw1YyrJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07jjyIUUUUUU=
X-Originating-IP: [112.64.161.44]
X-CM-SenderInfo: x2kr0wpolqwiqxrzqiyswou0bp/xtbBrwDMnWpR9oCLegAA3C
X-Rspamd-Queue-Id: 2D81A160005
X-Rspam-User: 
X-Stat-Signature: i3k8oizpmyh8f1b43scc699oghwmr1r9
X-Rspamd-Server: rspam03
X-HE-Tag: 1783756432-744452
X-HE-Meta: U2FsdGVkX19viqq1WLcegEIDJLiQwwyxwm2a/NBK5uvjwo/qDYJA8M70BUd+7ugZun8qIoHga7RuQuiuY2zFkDcpM8onk2fUnXGxAYQcpH2xTJz18dKjo4ZA1QJ3vrT5dYIlQR9v7AD88sKbqf3vxV/VwU/+T1x+nAkFTi9QtUF8i07w5CD1SkRdvjrVCCiEy3O41EXywOoHm+N6uIaT0fUTpqhvCPsFDgfV/Saqq9e0q3qDrr09gkAw4p8w695+xXX2ns4qDSVi20hoxxR5ucoxb4OHj6wPtJ3vnpFfBDk9QwlGhC4Ec/Jkpa0jkxPnQZD/wXMLLni6j3kiqT0jf50sGHngkKdTacLpBXbkOUQzwtAd2mlG9rQuxj7G48RG5pFT6gxmbPDjf28aQ5CiNIObeaoSUccOBp1kecXH97GSrq+Dp+DsM2FrTsz6IyVVRSxJ9V+XUP1b/nJpamD7x27ToYyW8qP8wzsfKz/6xtyCERcN9MCnVgnFWEl0NzEE8X1ShYP7rzoNugONQEu/sIHcvWlgtilDGUKvGQB1b8+p32TbXmVlTYoahUN56La/FyS4WTBHwa+FokAmzSyGFpJRlWIaMjKRmxdFr0GPYeQhSYGXeLu9ZCh+cF3JF4TBlQOoa2EuKEvTEmrn0io8GH9/jowpr2I4MSvJkvXdfGp2H4cF2OVQgECPlvEJOA01/35LRptVs2wwfBjeTQbvVTSny07bT0beXGPCokS2QhFZrjWWVXrxWZltHPOpT6YB5RGrr+ngMmKDOmKXr+rK96DN7kqMB1DEhweZm0rSjaomGWOlVsipHNEJWG41bhsijUKSOTuxhnAuGDhjz7hBZjuxpmz5XfGPDYxxUnSVB6FAe3pPRuQthJPBoB7r++sEzZlW99FF4plDZuxO8/A4pt0l3wOfIiprAAmLoUVLnRP6PUty/HbvZ+BFn1hTy9g2PzRX4YBBNBwo4bTuxNO
 eUJTCV7L
 qutR4JXS7S2O0to6mca91EBItp4SAMo3E7oV1CLVCj74QtAnklhAi7ogMdBiZDMXxr47V/ojSSz6C9iMblrISERFmiIpkIMPaoxkkRJaW3fmT8gZ51lYu2FJN5rAIyTK5tOEEwR8YZj6T9SI4riP3Qey9j5r8e5JOg0s6i1a91KuQLVA0zMprAytvAvew49vi66/VozdSOAhTcL9lw2CtkwaHWPi8kggX95/5n2fyOWcmxhxYkKmC+Uzii0na/683oEMxVaPQgsbKFP7iGrlYhi7ZVKQ8UurGU+AEUsWpzqsydsvg6W82QjLRBQGpDVeDW1IEjJznbwN5s5NAyE8xefFgevRbcZi9BPLUnXmT/OlsR/SCQGFV2SyQVaK2TeTlBrwATP49Uc21Y4qy8zvDOCsRMOmtM7frtxPWmhv+tNuG8ZsKN2yk/ObW/rhEH9xaAcrqxcL+GMpks092y5FLrhpaeyNrnKMgSjWjEoVLQNOvqymSdwfG49ihyg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


在 2026年07月11日 13:31, Qi Zheng 写道:
> Hi Hongling,
>
> On 7/11/26 12:19 PM, Hongling Zeng wrote:
>> In alloc_shrinker_info(), when shrinker_unit_alloc() fails for a node,
>> the error handler calls free_shrinker_info() which iterates over ALL
>> nodes and tries to free their shrinker_info. For the failed node,
>> rcu_assign_pointer() was skipped, so its shrinker_info still points
>> to old data. This causes double-free of valid shrinker_info structures.
>
> No, it will be NULL, not old data. Therefore, the double-free you
> mentioned doesn't exist. Before sending the fix, please verify the
> problem exists and your fix actually works.
>
  Sorry, You're absolutely right. After carefully re-examining the code, 
I now see that:
   1. alloc_mem_cgroup_per_node_info() allocates with __GFP_ZERO, so 
shrinker_info is initialized to NULL, not old data
   2. The error handler in alloc_shrinker_info() correctly bounds 
cleanup with if (nid >= failed_nid) break;, so it only frees 
successfully allocated structures
   My analysis was incorrect - there is no double-free issue in this 
code path, I apologize for submitting this patch without proper 
verification.
> And as a reminder, please don't repeatedly send identical patches:
>
> 1. 
> https://lore.kernel.org/all/20260711041509.92926-1-zenghongling@kylinos.cn/
> 2. 
> https://lore.kernel.org/all/20260711041823.95135-1-zenghongling@kylinos.cn/
> 3. 
> https://lore.kernel.org/all/20260711041954.95749-1-zenghongling@kylinos.cn/
>
> One last thing, please make sure to base your changes on the latest
> tree.
>
> Thanks,
> Qi
I also apologize for the multiple identical submissions ，my email 
client was reporting errors when sending, so I retried thinking the 
emails weren't going through。
>
>>
>> Fix by tracking which node failed and only freeing shrinker_info
>> structures that were successfully assigned via rcu_assign_pointer()
>> in this call. Failed/unhandled nodes are left untouched.
>>
>> Fixes: 15e8156713cc ("mm: shrinker: avoid memleak in 
>> alloc_shrinker_info")
>> Cc: stable@vger.kernel.org
>> Signed-off-by: Hongling Zeng <zenghongling@kylinos.cn>
>> ---
>>   mm/shrinker.c | 13 ++++++++++++-
>>   1 file changed, 12 insertions(+), 1 deletion(-)
>>
>> diff --git a/mm/shrinker.c b/mm/shrinker.c
>> index 7082d01c8c9d..92c6cb455fc9 100644
>> --- a/mm/shrinker.c
>> +++ b/mm/shrinker.c
>> @@ -78,6 +78,7 @@ int alloc_shrinker_info(struct mem_cgroup *memcg)
>>   {
>>       int nid, ret = 0;
>>       int array_size = 0;
>> +    int failed_nid;
>>         mutex_lock(&shrinker_mutex);
>>       array_size = shrinker_unit_size(shrinker_nr_max);
>> @@ -98,8 +99,18 @@ int alloc_shrinker_info(struct mem_cgroup *memcg)
>>       return ret;
>>     err:
>> +    failed_nid = nid;
>> +    for_each_node(nid) {
>> +        struct shrinker_info *info;
>> +
>> +        if (nid >= failed_nid)
>> +            break;
>> +        info = shrinker_info_protected(memcg, nid);
>> + rcu_assign_pointer(memcg->nodeinfo[nid]->shrinker_info, NULL);
>> +        shrinker_unit_free(info, 0);
>> +        kvfree(info);
>> +    }
>>       mutex_unlock(&shrinker_mutex);
>> -    free_shrinker_info(memcg);
>>       return -ENOMEM;
>>   }


