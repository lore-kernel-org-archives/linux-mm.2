Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C5C6DC44507
	for <linux-mm@archiver.kernel.org>; Thu, 16 Jul 2026 02:55:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8607B6B0005; Wed, 15 Jul 2026 22:54:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8124E6B008A; Wed, 15 Jul 2026 22:54:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6DC446B008C; Wed, 15 Jul 2026 22:54:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 398E96B0005
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 22:54:59 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B980C80392
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 02:54:58 +0000 (UTC)
X-FDA: 84993122676.08.64BFB25
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	by imf21.hostedemail.com (Postfix) with ESMTP id E56491C0002
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 02:54:56 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=sXVyJLt4;
	spf=pass (imf21.hostedemail.com: domain of jiahao.kernel@gmail.com designates 209.85.214.174 as permitted sender) smtp.mailfrom=jiahao.kernel@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784170496;
	b=BNxYKcBVOdmka62qDLC+eWUYFe9oDr0V0i4MjOko18iWyEJ/2sDk3s7tzOLChf/pxcBpHO
	4CqCzyYRLqg5lyzCU8rR1OnzXxITTeikQrfTHSoZ2axbJAuQ5968d7HJbBmGplKpf30aYb
	9+dxYOfzNVTftZ7b1BmAsqyAp72bWOU=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=sXVyJLt4;
	spf=pass (imf21.hostedemail.com: domain of jiahao.kernel@gmail.com designates 209.85.214.174 as permitted sender) smtp.mailfrom=jiahao.kernel@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784170496;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=O+M+DkQSkCWTSLDLxTihHDZGPSSRCJtMCVMSJqC4VhU=;
	b=xMbK+Hze3sjfN+u2BBKmu9sIsAd8sEURP9SqNm2GVxH7RVJRkHD/wBdscGf7ytaVu/AZZ8
	ach6CI297TCUKi+boMW7oQiD4ENtEJ+rOcQgtbC11vqBCR/+6jSi5l7494My+gQlP/b2is
	IUo446Rp9sHZIaNIMbqf2bvVtANJsjc=
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-2c6b67d5fa1so101568725ad.2
        for <linux-mm@kvack.org>; Wed, 15 Jul 2026 19:54:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784170496; x=1784775296; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:subject:user-agent:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=O+M+DkQSkCWTSLDLxTihHDZGPSSRCJtMCVMSJqC4VhU=;
        b=sXVyJLt49N8txpt43wL9hVfxrrJ41elXMja8sb3R45IlWEwzmjp3biUdkUHdjZI3aZ
         5wfPc+cUsUhHZiFfp0LPCnZBTOFZ0sZj1M/MZQ0SvzkHEYAWL+w1+xhLaaQNCHri1SSB
         GCV0Tj3O87tF4dWhIQXfpqBp6VjJTIXf2iFY8cu7gVSIllEvGy64d/czP69puRb9p6fV
         kTKlvGZ61UtSGAEVT3GBKpsvqHwrsfNhvAJcUv+S7iqdfoNuinFpBnTjjvlAYVgHpobk
         /aNELxCEQj7rg70UFSPfzhSqoLaHpCiD0L5/Cb75hgaHLCPMGAPe94kti7myU0y4NjZd
         Nxow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784170496; x=1784775296;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:subject:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=O+M+DkQSkCWTSLDLxTihHDZGPSSRCJtMCVMSJqC4VhU=;
        b=IGGLjVBlJEPnQb1I9dEOKIA+Dgu/eAj6uIiBYsWMFHJDEW7ydWbIYKR981tJ3Lgew0
         VWIm9pIWdcwkJtFjyo+xGvOAmoHMx3hG4nekG7p0J68gE7k2PNUGL9oaHE5O1F9+z+Vq
         hnhqqEFY35jBcopSBCSXHceKxrlT9MEbPB8LEa0kHInGfKseb0ZDfxkyhkBH3QWTjRl+
         HFOC0Be7nFiXDPiq1ylfaQkAXicBrLSRgqr3kWSmjEjd50Tpor2zhqip4dy/efDDOTv2
         PMkiCXS5zVdbiJbXAv0S5zH5Rys0F188vcCy34jbWp9vU25liJI0CS1nJfYzXxVXNtzN
         opmA==
X-Forwarded-Encrypted: i=1; AHgh+RodPAGjHm69rTHfEyEnDHKXCD2Q8mANIKSp7/jQPMZwpifXAhinvbtcD81aKUMu5Jjq7NnRKXPAFw==@kvack.org
X-Gm-Message-State: AOJu0YxAPXimJfhNc12A2W2Rj+DbPVht5F2aq7NCZuHUPN2mgj+MlxLv
	MkkRZhH8g9MqsLLVJDoSj+vrcwPYn1o5/Spc4BGoZRp4b9gpt7Hv54N8
X-Gm-Gg: AfdE7cmAuG+IzSvGQYdnHML6fiVBCEQE9MT6s44hj4+wKrOEmi2DAyydN/cmUbba5aC
	AEMf9et0n7XKyYagQfGpHMuO7f7wECGddmi/5Ygth0/EcWM3Lls6pWubYtnoJaYAq6rmnqfPqDP
	EinZ+3DSBaicGdWcjSv4R1MRfXrLdA6LYsXyag4hahdKhDfEEW8SdhARCbwxfhzAXDBQNDqLIbj
	2f91MM4akMUML0O4Dh2uyFr4aQBACQjTih1OzhEgbjdWs1fZbqu3YrZKVIos2MH+r2ZrRbZ2HjP
	/8DgtUBS6C+gUHjnCoXsAquCuKJZNIbA3+avuUgNYgD7GLZVLYzOQO1q+FbsZGpLowYI2GthiJq
	d9KIbqESBQHC01ZNiZaewZhabt4/NyEcx6rI12w0dClQHVBHWokUN81+GrMz9GbQG3H8t+wU+1C
	y4o2Q4ZekP1H5CLlL03wePm4A=
X-Received: by 2002:a17:902:cec9:b0:2ca:1bd2:d57b with SMTP id d9443c01a7336-2cef10f538bmr91527655ad.0.1784170495560;
        Wed, 15 Jul 2026 19:54:55 -0700 (PDT)
Received: from [10.125.192.114] ([210.184.73.204])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2cf10161ef2sm11913255ad.35.2026.07.15.19.54.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Jul 2026 19:54:55 -0700 (PDT)
Message-ID: <b910e870-9583-a2f5-b681-e69edb9af290@gmail.com>
Date: Thu, 16 Jul 2026 10:54:37 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.15.0
Subject: Re: [PATCH 2/2] mm/zswap: Support batch writeback in shrink_memcg()
To: Yosry Ahmed <yosry@kernel.org>
Cc: akpm@linux-foundation.org, tj@kernel.org, hannes@cmpxchg.org,
 shakeel.butt@linux.dev, mhocko@kernel.org, mkoutny@suse.com,
 nphamcs@gmail.com, chengming.zhou@linux.dev, muchun.song@linux.dev,
 roman.gushchin@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org, Hao Jia <jiahao1@lixiang.com>
References: <20260714081510.16895-1-jiahao.kernel@gmail.com>
 <20260714081510.16895-3-jiahao.kernel@gmail.com>
 <CAO9r8zNiT63LUHx8X5i_aboX1UWuGkcFf+p9ch-pekURUuDdXg@mail.gmail.com>
 <2bc8e4f6-46a0-5b74-6eaa-59e7aef9227e@gmail.com>
 <CAO9r8zOFg_mnNGbFFd_h8FAwRCbQ9vXk47EF5f1CLg1cDVGB5Q@mail.gmail.com>
From: Hao Jia <jiahao.kernel@gmail.com>
In-Reply-To: <CAO9r8zOFg_mnNGbFFd_h8FAwRCbQ9vXk47EF5f1CLg1cDVGB5Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: E56491C0002
X-Stat-Signature: h3iqhigductdc7irt1fs6b4zchcq8bot
X-HE-Tag: 1784170496-133641
X-HE-Meta: U2FsdGVkX18rA4KwHeOVqpOTKPdjIVarMwXZIdtDLCyqJHfwq2bVg5zU6tuJYTNYOPOhP8MHrFr6zqBOLrriCoKucAWzS45prHhAPWYIrxRdh3PDVzWKPutwdgs3/4loZOatzbtmZ/BUsZys0qyazXh+paInip1d8Q6YV+6Zyp5syfc9cJnuurWxcpdbNLEGCp+vpA1+iGueFF9jZyMDKYCJzwEHpoHwXVdkjac2MpIw6jKREfk3bpM2lUtB59EilQEAx0oj6PQa1o6OGIE3Rap/SqAbL1+mSE41cpoXHRUkG4HxRNGVFAoM+li/FKDqJa2HrSzfTdyOnIRbwfCmXRqMHR7SQDmYOX8ydodYcKHIs1azOsihjNXXMIJoEKhZYNQYne7/0qxYFOjT97RsQHSNAwf69EtjXXrnOY8v/HnmTOVKcXiEOEQf2JVSrxzPjBCnrXQYEfLwDAH+Q11QUjZlqQ4cBwSOHcJQR38N9f/I567J9FZBlqCXuDVurDm+jc3MHNM6OWsa7pQImN5CSZnBtWcZc4dHWTXyuEtmEAhMuol7JevSnwnebUasbhjxsi+mXN9QNG0Jl8hK+chMGgSukKh5G0sAslfIiLfCPrTGbQtMkO5MSVl0AVx6XZKyCt/rouCaKqhlTf4nLlTzJL8VsJ3G+wWKgFwSMLDU5yyXltr1ax/L25TUomZBvqcaFfXmo4/O51FIlzbGb0hg229dzCpytrrfv5hYq7yFX885Mb0SJKHjLJ6psRLSixeLBvp75Ed4bfr/ZSeXYwCzdWyYdJGwhT+4bcTBuJg9Wba0gQ1ItKJc68V9fOXrbRIWVKJcbAH0AmAtlpQXziGq8ISmy3yuFUmqn+s/Eh/sLjVY4j6tgxNOQT+zqL3LLiA3np7rN6OVKr4WCGu66RcnIr9BCpSezpiOnABXn2uiu99jGIQvPslAFiea3JY/H5kGFQnvKgzaipjZgyn5AKM
 5OZPQMeR
 roUwNw1rt7wVXfC58cow6KFgX3d3dyJvNQQiSiQN3psFf/kM8JOLyeOHfZErz2v8vUNtkx9vdKLLvV70iL2VJZUsWNDKd32ljudTo4Dp42BQyRbjC1YrB14TbRCQeIbewgkzRJ0xL5f3ugqwfXEICNNcudSD9YQyDmJ0YWrIO+Faro/RWNsVw0JcK5VkjcJYcIxduT15+fxWW8Qt7RnY0HeROcnCX7a3oI5gg66L9XdB35okZoY5zPo1/OTgoVpn9UPeh2O/vKeJtleTby9raw8ObWUNreP/N91uVB24NTAbRB/O01KANRi75mAMaUGqC7OMHav6yG5RsjG+plKWZJ6niT7aF1Fp1Pq0AxRfHdnYDvzsZVOdQgfARqGeBDO2TpGmb3BvlwwVKxe06OJvOwxJORq1pV7s+08HlD2e4Ss6SO+B94wt8vQNo1kVl8jpYjqakxQQXsEhCScSgdcsvpCOOKzJydqnDPADrZgMN1BeBLFk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/7/16 00:14, Yosry Ahmed wrote:
>>>> Test Setup:
>>>> Total memory: 32 GB.
>>>> zswap settings: max_pool_percent=1, accept_threshold_percent=50,
>>>> shrinker_enabled=N.
>>>> Allocate 512MB of anonymous pages and fill them with random data (to avoid
>>>> compression), then use cgroup memory.reclaim to force a large amount of
>>>> anonymous pages into zswap. At an interval of 2ms, allocate a 4K anonymous
>>>> page where the first 4 bytes are random numbers and the rest are zeros, and
>>>> then trigger a reclamation of this 4K anonymous page through cgroup
>>>> memory.reclaim. When the pool threshold is reached, shrink_memcg() will
>>>> be triggered.
>>>>
>>>> The test data after running for 120s is as follows:
>>>>                              Baseline         Patched
>>>> shrink_worker wakeups          5363             85
>>>> shrink_memcg calls       11,345,012        188,264
>>>> written_back                  40214          40275
>>>>
>>>> Conclusion:
>>>> Under the same workload and run duration, the patched kernel shows a
>>>> significant reduction in both shrink_worker wakeups and shrink_memcg calls.
>>>
>>> Please also include data from the case where zswap store failures are
>>> observed and pages go to disk, and compare before and after this
>>> patch. I think that part is also really important.
>>
>> I retested and added some collected information. Perhaps
>> `pool_limit_hit` and `pswpout` can explain that batch shrinking of zswap
>> can reduce the number of pages that fail to be stored due to the pool
>> limit, allowing zswap to skip zswap and go directly to disk.
> 
> Oh I meant the other test case with high memory pressure where we saw
> a lot more writeback with this patch. Do you have similar data from
> that test case?
> 

Below are the results from stress-ng (high memory pressure case), which 
lead to a similar conclusion:

                               Baseline      Patched
shrink_worker wakeups         5,640           987
shrink_memcg calls        8,481,500     2,504,818
written_back pages               260       768,576
zswap_store calls           2,742,756     2,301,414
   store succeeded (ret=1)     934,640     1,308,686
   store rejected (ret=0)    1,808,116       992,728 <-
   store reject rate            ~65%           ~43%
pool_limit_hit delta        1,181,310       101,593 <-
pswpout                     1,808,376     1,761,304
pswpin                      4,288,497     3,902,658


pswpout = store rejected + written_back pages
Note that pswpout comprises two parts: the store rejected count (where 
we skip zswap and go directly to disk) and the number of pages written 
back by shrink_memcg().

Therefore, we can directly leverage store rejected to evaluate the 
scenario where zswap is skipped and pages bypass it to disk. This 
provides a much clearer picture than looking at pswpout alone.

Do we need to include both sets of test results along with the 
comparison data in the final commit message?

Thanks,
Hao

>>
>>                                 Baseline      Patched
>> shrink_worker wakeups         5,363            85
>> shrink_memcg calls       11,373,201      180,928
>> written_back pages            40,212       40,236
>> zswap_store calls            161,190      168,741
>>     store succeeded (ret=1)    102,743      127,644
>>     store rejected (ret=0)      58,447       41,097
>>     store reject rate            ~36%         ~24%
>> pool_limit_hit delta          55,826       14,062
>> pswpout                       98,659       81,333
>> pswpin                            2            1
>>
>>
>> Thanks,
>> Hao

