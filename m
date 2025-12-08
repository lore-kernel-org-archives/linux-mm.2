Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0E97ED1CDC6
	for <linux-mm@archiver.kernel.org>; Mon,  8 Dec 2025 02:35:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 638246B0005; Sun,  7 Dec 2025 21:35:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5E8D26B0007; Sun,  7 Dec 2025 21:35:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4FDD06B0008; Sun,  7 Dec 2025 21:35:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3F6DD6B0005
	for <linux-mm@kvack.org>; Sun,  7 Dec 2025 21:35:58 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C85935BC1A
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 02:35:57 +0000 (UTC)
X-FDA: 84194738754.27.E739D1E
Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	by imf30.hostedemail.com (Postfix) with ESMTP id 0869580002
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 02:35:53 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	spf=pass (imf30.hostedemail.com: domain of chenridong@huaweicloud.com designates 45.249.212.56 as permitted sender) smtp.mailfrom=chenridong@huaweicloud.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765161356; a=rsa-sha256;
	cv=none;
	b=25t8wtTa+6xF7w27YOY7zY/O09k4O52pts0g+Lobk7X364fIMDOeixuLjY23/9NoXGeZPM
	WU92wT/nIbPwKe1aqjsEMO4JUfODmFxgabT+3rzzjdI2hYGHfFqISBZweqDim+3AkbooZx
	2/Sd/VIyUWkWreS1ipZ1yc3xdnCiZbM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765161356;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TvSV5fFGuEOFjUYyyYheVzehmeCjrTbwB5BCRB7nlmE=;
	b=LIArtXHabAx8zC14+MsCOdUiodNI8BJeAMl0xV48vPjk86z61XQQR//SnbsNqQwQ3muu9V
	wkka+0M/kTLweMEC0tZcqxeTaRpe2UzW3zI+gxh/HEE0ujhT8xZZyi8B0frjHVMhNZ7SpN
	up7wTOHbt09wphDQNj0d8m9+oNDrF90=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=none;
	spf=pass (imf30.hostedemail.com: domain of chenridong@huaweicloud.com designates 45.249.212.56 as permitted sender) smtp.mailfrom=chenridong@huaweicloud.com;
	dmarc=none
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4dPmKT5DVrzKHLwf
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 10:34:53 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.112])
	by mail.maildlp.com (Postfix) with ESMTP id 1B5631A191F
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 10:35:50 +0800 (CST)
Received: from [10.67.111.176] (unknown [10.67.111.176])
	by APP1 (Coremail) with SMTP id cCh0CgB3sX2EOTZpaUznAw--.9363S2;
	Mon, 08 Dec 2025 10:35:49 +0800 (CST)
Message-ID: <14b2584b-3ac7-4358-9d81-40ca32683e4f@huaweicloud.com>
Date: Mon, 8 Dec 2025 10:35:48 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH -next 1/2] mm/mglru: use mem_cgroup_iter for global
 reclaim
To: zhongjinji <zhongjinji@honor.com>, hannes@cmpxchg.org
Cc: Liam.Howlett@oracle.com, akpm@linux-foundation.org,
 axelrasmussen@google.com, cgroups@vger.kernel.org, chenridong@huawei.com,
 corbet@lwn.net, david@kernel.org, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 lorenzo.stoakes@oracle.com, lujialin4@huawei.com, mhocko@suse.com,
 muchun.song@linux.dev, roman.gushchin@linux.dev, rppt@kernel.org,
 shakeel.butt@linux.dev, surenb@google.com, vbabka@suse.cz,
 weixugc@google.com, yuanchu@google.com, yuzhao@google.com,
 zhengqi.arch@bytedance.com
References: <20251204183437.GB481418@cmpxchg.org>
 <20251205025727.8324-1-zhongjinji@honor.com>
Content-Language: en-US
From: Chen Ridong <chenridong@huaweicloud.com>
In-Reply-To: <20251205025727.8324-1-zhongjinji@honor.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-CM-TRANSID:cCh0CgB3sX2EOTZpaUznAw--.9363S2
X-Coremail-Antispam: 1UD129KBjvJXoW7tF4kCFW5CF45XF1DGF48JFb_yoW5Jr13pF
	ZxAa1jk3yfXryxAFs2kwnruw1fZ348Cw43WrnYqw1xAa9xAFnYvr47Kr15WFWkAr4vg3W2
	qrZ0vwnYvFWDJa7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUv0b4IE77IF4wAFF20E14v26ryj6rWUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x
	0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG
	6I80ewAv7VC0I7IYx2IY67AKxVWUGVWUXwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFV
	Cjc4AY6r1j6r4UM4x0Y48IcVAKI48JM4IIrI8v6xkF7I0E8cxan2IY04v7MxkF7I0En4kS
	14v26r4a6rW5MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I
	8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVW8ZVWr
	XwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x
	0267AKxVW8JVWxJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_
	Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7IU0
	bAw3UUUUU==
X-CM-SenderInfo: hfkh02xlgr0w46kxt4xhlfz01xgou0bp/
X-Rspamd-Queue-Id: 0869580002
X-Stat-Signature: ykf3kqyzcef8qhmtznytqr4xab8frfef
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1765161353-265806
X-HE-Meta: U2FsdGVkX1//YM+G1COzeKBZa/fOjWSwz+O/1xxgoSHZkUGG3bgN/FyHqhYDOE287ctQQ2KpDMe7gY9CF1zgU5csAnW/OZhT4LaqBg8DIHjzuuAPL5VZZj7NprBJW/9UzHTy64q3kinS4SI/Guq6zdz53ZeKvawgLZYgjxzZxJoi91Ae5ABS3QGlpC436JYxC9SRix+aRD7GEBQ7mcGt0MWB/ZI5LTvTJGa9XoofWlssDlxIiF+aTWccJb0acsgTHVBkX5meBD49ex2OHWbqb0G4OEj5DE6mUfPgF4d6ZOqt7S8V5G9ROA9fB1mc9TfRihQOGyczsj+djgnT7GU8jNJEUD085HiLWa24I0DT4gZ0OM2ECr1a9EmTYXMp3lZ//448oizGIOPlRBBeDnqR/LYKbUb/gGc/ZuIt2j4KvO8BCB9wM9S8Yw53cgBOLvZ901fkrp37yLs21btOuUD878wwQno/eVWs0/uERUZaxdJRf5bug4yT1CFj6R8a+kgsuBk1PdZtF7hW0IrUj9N8qCuDCqpwQ7EUPS5Y0TgGPn4SrnaSx+kqoJY1xMdXzRKpg364UHdgpdZ93RfJtatW57jQXeoNf1NGwJ9Ja8QdQp36Ces2g1sEQrHq7NHR86/+RviIdqVDNxNQkwsqyr0y0MdSOksfsd388ev29LISa8LoMKLBfaPMP7RB4tJNlr2BTIhn3sq5zp5fZhsKYomqhkc/xIZlpa/Lu+qZLgvRMEPjPynD65RBOcFclEpRn/ysqGJ1+vOU8kmzR/nBkEFcAzJ4lYEnanppu/hs4ZQUmthDGt9cKRbmbQIcp3ITX9F/JpR2X4xtGsWh6nEkdZsmFky8YpxOb4kSEN6ZUSxvstnJyR9KGBEJ6nATqvEIzIQX87FP+wfizmQbo59qMEfw/4XAVTLz+YDJtBoQy0KQd7t1CQnFCcAkfvs7vaCHhtX5rUaRygAlQAA/IJ5HW9i
 xfDG0K7f
 9BvBO5OZhkBt6AB2znkKkFHsi+vHwPnExFihQMxRRckx8dlnFtwlkRVzSCEJLs45uBZka0aZ+ytXz9eEpDyQakzU5dxoWqBAcSiuuwJgyWJEWIYMG/jQDgRyvm96PYjvWZOyBkVUc3LCVDthav7bySNOCbAP4AtfoSmdm4q9m2gf8KFmeZuN/SmKXcBw0npLqK4zOhuP29FOZfMA9i97fDXWx5aWbs6I4bfkxWepdMjOFpuN/myyDDY9InA7iAWcc/+j7R82Pu2uwVxXPfmCPVLxytvQeiBqsS4qVuYeW/d1Nc+0cgHTMmXWxe7TH2SNeGtoW
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/12/5 10:57, zhongjinji wrote:
>> From: Chen Ridong <chenridong@huawei.com>
>>
>> The memcg LRU was originally introduced for global reclaim to enhance
>> scalability. However, its implementation complexity has led to performance
>> regressions when dealing with a large number of memory cgroups [1].
>>
>> As suggested by Johannes [1], this patch adopts mem_cgroup_iter with
>> cookie-based iteration for global reclaim, aligning with the approach
>> already used in shrink_node_memcgs. This simplification removes the
>> dedicated memcg LRU tracking while maintaining the core functionality.
>>
>> It performed a stress test based on Zhao Yu's methodology [2] on a
>> 1 TB, 4-node NUMA system. The results are summarized below:
>>
>> 					memcg LRU    memcg iter
>> stddev(pgsteal) / mean(pgsteal)            91.2%         75.7%
>> sum(pgsteal) / sum(requested)             216.4%        230.5%
> 
> Are there more data available? For example, the load of kswapd or the refault values.
> 
> I am concerned about these two data points because Yu Zhao's implementation controls
> the fairness of aging through memcg gen (get_memcg_gen). This helps reduce excessive
> aging for certain cgroups, which is beneficial for kswapd's power consumption.
> 
> At the same time, pages that age earlier can be considered colder pages (in the entire system),
> so reclaiming them should also help with the refault values.
> 

I re-ran the test and observed a 3.2% increase in refaults. Is this enough for what you were
concerned about?

The complete data set is offered in my earlier email:

https://lore.kernel.org/all/e657d5ac-6f92-4dbb-bf32-76084988d024@huaweicloud.com/

>> The new implementation demonstrates a significant improvement in
>> fairness, reducing the standard deviation relative to the mean by
>> 15.5 percentage points. While the reclaim accuracy shows a slight
>> increase in overscan (from 85086871 to 90633890, 6.5%).
>>
>> The primary benefits of this change are:
>> 1. Simplified codebase by removing custom memcg LRU infrastructure
>> 2. Improved fairness in memory reclaim across multiple cgroups
>> 3. Better performance when creating many memory cgroups
>>
>> [1] https://lore.kernel.org/r/20251126171513.GC135004@cmpxchg.org
>> [2] https://lore.kernel.org/r/20221222041905.2431096-7-yuzhao@google.com
>> Signed-off-by: Chen Ridong <chenridong@huawei.com>

-- 
Best regards,
Ridong


