Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2D015E6B277
	for <linux-mm@archiver.kernel.org>; Tue, 23 Dec 2025 06:14:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8E2D26B0005; Tue, 23 Dec 2025 01:14:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 890276B0089; Tue, 23 Dec 2025 01:14:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 79C516B008A; Tue, 23 Dec 2025 01:14:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 65FF36B0005
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 01:14:24 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 0F02DB9B04
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 06:14:24 +0000 (UTC)
X-FDA: 84249721248.06.FAB6042
Received: from out-181.mta0.migadu.com (out-181.mta0.migadu.com [91.218.175.181])
	by imf30.hostedemail.com (Postfix) with ESMTP id 3DCA280007
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 06:14:22 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=p3pNAUjj;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf30.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.181 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766470462; a=rsa-sha256;
	cv=none;
	b=v9PuoDO38yfUCKc/K317IKDtlJxh/cYUlQQIg8IHXBLHbMSPkym5bc29Pno800O+BTYpPr
	PTZdcotLlWgimBwNIcTJcNOS+N6eDR75skQkb7YfBkXd45MHDE7ytSgI2fHC+B/rNbmQ4y
	zMlCXis94/I2H73AS6d7xtz+v8vpYcM=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=p3pNAUjj;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf30.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.181 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766470462;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=v1Vxe9QHr773cXPHburX7fEkwO6UQV/y6BuQFvRR+UI=;
	b=VYsMOYFFLunS15xH3Csl8jAqSbLs15E2vi4CIM9qQZj5RkKtIJELb5KmzGNFS1di0UpapP
	X9bW0wzbVJf5JxVqXCKD3QxJexGgXDSy2FlCSNiu/dYT6GAf5NqZqL8rNQP7kzJ0yewo93
	1rSfvI21fIFzzCA2xUJakfUDzj33+9g=
Message-ID: <ffc68aa4-cb9d-465f-8c6f-9cd7315eb560@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1766470460;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=v1Vxe9QHr773cXPHburX7fEkwO6UQV/y6BuQFvRR+UI=;
	b=p3pNAUjj1hv8lsweRgKt7TABdptgSaVSplZqD1MmYcacqWp56Jo6BybVFtDaZv6+69kQnc
	oEJurwFFBic9lI2wg4vy0AVYfl1Ixwo5Mq6tVEPaKXdhWG1WFv+xQ0BI3dBp4RgSvRuTly
	bbrH8k2y4SlComNwLN0LoW3Q2PL0ZVo=
Date: Tue, 23 Dec 2025 14:14:09 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v2 23/28] mm: memcontrol: prepare for reparenting LRU
 pages for lruvec lock
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: hannes@cmpxchg.org, hughd@google.com, mhocko@suse.com,
 roman.gushchin@linux.dev, muchun.song@linux.dev, david@kernel.org,
 lorenzo.stoakes@oracle.com, ziy@nvidia.com, harry.yoo@oracle.com,
 imran.f.khan@oracle.com, kamalesh.babulal@oracle.com,
 axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com,
 chenridong@huaweicloud.com, mkoutny@suse.com, akpm@linux-foundation.org,
 hamzamahfooz@linux.microsoft.com, apais@linux.microsoft.com,
 lance.yang@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 cgroups@vger.kernel.org, Muchun Song <songmuchun@bytedance.com>,
 Qi Zheng <zhengqi.arch@bytedance.com>
References: <cover.1765956025.git.zhengqi.arch@bytedance.com>
 <6d643ea41dd89134eb3c7af96f5bfb3531da7aa7.1765956026.git.zhengqi.arch@bytedance.com>
 <jdhf6h7weedyentvyaqsr3n3v7dlj4n6k3mrryn2hkyhc255cl@kmexszfblh6s>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <jdhf6h7weedyentvyaqsr3n3v7dlj4n6k3mrryn2hkyhc255cl@kmexszfblh6s>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 3DCA280007
X-Rspamd-Server: rspam03
X-Stat-Signature: 3hsucerz97my76uzn4s3ngacjt6bboqj
X-Rspam-User: 
X-HE-Tag: 1766470462-128533
X-HE-Meta: U2FsdGVkX19Dd3FsAJ/22+UFw7Dlo9SysGo5la5vZNLjd31F2Km7oQDRHiEriZHfDb+O5oGvAz0x6mw6wwTwPasJDubgGOCw4wB5hNn0JgPrjT8bwcd/W6XU5U/hX++cjskB8/IKYNPuvTXSpFEJUcQjxMA8/P94BMKJl6n09HaXLPeOQLpuKodRO6DKlpcyEO8JjwHljen1NjLsep4TzYs/SOwcOk7Y/B5tggp5vmazUcZJoce5UbRc3REnZJpUZNpZaYgYSdywnZ+jyxpALLeTB4kRAPL8y+8Y9iwV4vIyxp4k9Yx8IlbHhlnf7JV2g9cR9CH6KZx9T6lIAwOpMcc9yqeyo9LXPDxv+ix+aCnjbq+t7I/F7/RV3UoNnnNOtRHt4ttsDOSHTBN8e3NcijnfH1SYBZcY7RTjFuebyc6CRfOBZyjFNNHao/qK098QHalPiLCxaS8/Me5exf/c0Ln1hlwloAFreMnvDY2t3qCqpCm4XPhFaikzFOVZu0gUSJ1o88kcPlnX4/sIX7e8ygXXEi1z0yf/hGdL182Jjz3aZqwI37Ayi4ReC0doS682G57OL8Ks/L7PqBUCt+bEY7HipauudZws9l8l9HscCOkk72lUks/sv7hwKdpIOIIocJArSdzo8L/Id3CkEj/MFTdeXafpMJ/tNjrS3Tw/EUrY6t/dx0r3bTbUFbglgdjsTAO/+nhNpHIphjJvvzByS2LnhtiJa/Ia02l5LgHIAMLxvVxsFqPkHp2Md6f6/Rq0t2pNkohnkQ4A/6zugL/1yIh/FpDrDZB2SsteTXgvAGQnNUPHHnXI/LSwYP+hAFIDuoaf0zhB0/T/Ki6Iz8FVdgvrDcYAywLYm6z6NUkICLWhb2cZi/Uu2hzQsXe8+Sp+Zgw2u4hf2f7yMTmAsArVoXb4vTZGxrCft60+f7mKpvCctXiQTjxAnxauR+vC/GweLiINSuALSeXlXNYXow4
 9X6/O1FA
 7VJ2V8BmxGmSc4OxYfXPhfheuRokcIvSGQNQvzSyyA2efjNw18IavbPgrM98zz82FLe11/Pa/nAc+J5VLMJIEW3J6N2drGdQT4qaW+us7WvPaBb9T8/j2l4f0bqyILO8nd+UWrAx0S5ulld9BMIFQperVBL9zP15py2YgR+ghoV0srDa6AtrkerDtZhKqjqKRaJmho71NB48RVS9ccODClk/Inw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 12/20/25 10:03 AM, Shakeel Butt wrote:
> On Wed, Dec 17, 2025 at 03:27:47PM +0800, Qi Zheng wrote:
>> @@ -1232,14 +1221,20 @@ struct lruvec *folio_lruvec_lock(struct folio *folio)
>>    * - folio frozen (refcount of 0)
>>    *
>>    * Return: The lruvec this folio is on with its lock held and interrupts
>> - * disabled.
>> + * disabled and rcu read lock held.
>>    */
>>   struct lruvec *folio_lruvec_lock_irq(struct folio *folio)
>>   {
>> -	struct lruvec *lruvec = folio_lruvec(folio);
>> +	struct lruvec *lruvec;
>>   
>> +	rcu_read_lock();
>> +retry:
>> +	lruvec = folio_lruvec(folio);
>>   	spin_lock_irq(&lruvec->lru_lock);
>> -	lruvec_memcg_debug(lruvec, folio);
>> +	if (unlikely(lruvec_memcg(lruvec) != folio_memcg(folio))) {
>> +		spin_unlock_irq(&lruvec->lru_lock);
>> +		goto retry;
>> +	}
> 
> So after this patch, all folio_lruvec_lock_irq() calls should be paired
> with lruvec_unlock_irq() but lru_note_cost_refault() is calling
> folio_lruvec_lock_irq() without the paired lruvec_unlock_irq(). It is
> using lru_note_cost_unlock_irq() for unlocking lru lock and thus rcu
> read unlock is missed.

Indeed. Will fix in the next version.

> 
> Beside fixing this, I would suggest to add __acquire()/__release() tags
> for both lru lock and rcu for all these functions.

OK, will do.


Thanks,
Qi

> 


