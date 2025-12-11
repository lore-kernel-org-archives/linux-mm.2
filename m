Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 93710D3E784
	for <linux-mm@archiver.kernel.org>; Thu, 11 Dec 2025 00:43:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 904A96B0006; Wed, 10 Dec 2025 19:43:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8B4C36B0007; Wed, 10 Dec 2025 19:43:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7CB356B0008; Wed, 10 Dec 2025 19:43:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 6FBC86B0006
	for <linux-mm@kvack.org>; Wed, 10 Dec 2025 19:43:44 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 0D4C1135040
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 00:43:44 +0000 (UTC)
X-FDA: 84205342368.20.1DED9CB
Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	by imf28.hostedemail.com (Postfix) with ESMTP id DA15AC000A
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 00:43:36 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	spf=pass (imf28.hostedemail.com: domain of chenridong@huaweicloud.com designates 45.249.212.51 as permitted sender) smtp.mailfrom=chenridong@huaweicloud.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765413822;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=aChNKSyPCYRgu+/GcOlFbmKUoiHZN3nZwAOz4R2P0X8=;
	b=jJR3nz7hrv1vC9x8O/2eMbLXoaoBivCLS2G1Mh3oM/jynX8OGAVLLwnDOdvi8Rh0Z/UxFK
	+QzIjIPwPoHLtfYCnURV3PUF6Hw/QJin5PM6bYTqGwJSMTCsfhkzKv6yzRKpIhAb1YFjP/
	fVyQ2jqEyQfwSxZ0gdkklmnz27lrmsM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765413822; a=rsa-sha256;
	cv=none;
	b=iduvB3wYd5h33gKTQQcPrSvfW85YN4rFGTvVbVOv7Lhhrq+fSVBbCvi9YQyjIfMhvRSucM
	+H60+Ezps/2oaEUAhR3Rbz7aTEZrJe6KAHYMSSkYHv/OxKKYBHsUWuqNgj/42FkK5rQHA1
	FKJJUtfHHy0fHLE5ZYI4KWvLpm9uQJ0=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=none;
	spf=pass (imf28.hostedemail.com: domain of chenridong@huaweicloud.com designates 45.249.212.51 as permitted sender) smtp.mailfrom=chenridong@huaweicloud.com;
	dmarc=none
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4dRYjH59czzYQtnc
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 08:43:15 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.75])
	by mail.maildlp.com (Postfix) with ESMTP id AB9551A14D3
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 08:43:31 +0800 (CST)
Received: from [10.67.111.176] (unknown [10.67.111.176])
	by APP2 (Coremail) with SMTP id Syh0CgAH5k+yEzpp071GBQ--.40689S2;
	Thu, 11 Dec 2025 08:43:31 +0800 (CST)
Message-ID: <66201b4a-44a5-4221-810a-897699425195@huaweicloud.com>
Date: Thu, 11 Dec 2025 08:43:29 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH -next v2 2/2] memcg: remove mem_cgroup_size()
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: mhocko@kernel.org, roman.gushchin@linux.dev, shakeel.butt@linux.dev,
 muchun.song@linux.dev, akpm@linux-foundation.org, axelrasmussen@google.com,
 yuanchu@google.com, weixugc@google.com, david@kernel.org,
 zhengqi.arch@bytedance.com, lorenzo.stoakes@oracle.com,
 cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 lujialin4@huawei.com
References: <20251210071142.2043478-1-chenridong@huaweicloud.com>
 <20251210071142.2043478-3-chenridong@huaweicloud.com>
 <20251210163634.GB643576@cmpxchg.org>
Content-Language: en-US
From: Chen Ridong <chenridong@huaweicloud.com>
In-Reply-To: <20251210163634.GB643576@cmpxchg.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-CM-TRANSID:Syh0CgAH5k+yEzpp071GBQ--.40689S2
X-Coremail-Antispam: 1UD129KBjvJXoW7tF4kCFW8Wr18Kw13Wry8Krg_yoW8Kw4xpF
	yvyay7Kw4aqry5Kr1Yv3sYva4Fvw48ta45try7Gr1IqwnIgr1rtF9Fy3W8Wry5CF93XF17
	Za90gws7Cw42kFUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUv0b4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x
	0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG
	6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFV
	Cjc4AY6r1j6r4UM4x0Y48IcVAKI48JM4IIrI8v6xkF7I0E8cxan2IY04v7MxkF7I0En4kS
	14v26r1q6r43MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I
	8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVW8ZVWr
	XwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x
	0267AKxVW8JVWxJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_
	Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7IU1
	7KsUUUUUU==
X-CM-SenderInfo: hfkh02xlgr0w46kxt4xhlfz01xgou0bp/
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: DA15AC000A
X-Stat-Signature: mocitpbgf4hkx6hnuy74wpr4jnxx9p6e
X-Rspam-User: 
X-HE-Tag: 1765413816-381828
X-HE-Meta: U2FsdGVkX1+YtnKJYifdnQFSbA1Mk+O8Eltjlwbnqr5tpQLLNlEZ6vKQLozZJ4Nkgouc49t1yU6VpE0MIbwpjnaks2tBcSRvHO5dMj9ZZ8ajawpd2nHiA01t09YJgJob1aMpmNlA4j1/sHMPDHZc2c34IQq8VMh4YFxJ3vLPtdDa9/8gL+qsD4ySFhD0LcMoPj4d4yJwQS0tMxg9twDJSDuqOBgEjnQ7xE7CB2V0P3UZIdtElgLe0Au3LCNFyfvfh93k1kI6l1YZYYVRD1mDTW2Yt4YnxC1hj+74DT1kwWjr0fz9/HzWc3juJ5Mo7ojrm22S9/YWinkHX7Ohy2iAEqNdILWPbJSzpRmA/YgqJpc1bwn/GsdnSl/fmO768BGvtAsPrr+KqzT825mtmZgIXhHyCE7h0lOIZcKwH6pAeCX1M4hfGJrjBJ3uzY2G6ypnn8cSIuNPKSK61qK22Xr7NlmzG0mXA9/P7LXfBkSeqkqT+O241Nooro1wwdYhlrz5YuPbjeewxzatoWuzYpcbEEgc/1KQxxXjI3MfzE74t6YYEB2bg0nO/bwWH+6HsmkHeg+mWSeW7lmKiK0LeXYAYvxfjJv9QqaG9hXiYSODZV9v/noensImOpGIMfzWGD08cjVMP76ilXnU3l1zGic1K6MOsKtfSXWxZhzgr0WWZFZR7a8MfGYNC+MLnlfjz+hDk2UGtZCgkYzMrtmxrYzoKqvYEWY46S6VouE6C3wHOEY4AvBKdgudI6Vjm3Pc0t5nxFhgRZwPKTY5Dka80RV3RVtS+khd5+0DVNZmhsg+RRrlIwbr5mr9pKANQPOvWwg23ae6bNzZyeQIBMqMkG2/PtjXxxyoPuexXpqnMvipFmXa68WZ3M/f4GUo6MY1Ta0S3/OP0vEDWGLDVcqECcMhBr9B/6r02L6knIZQ89QVkbhvt1dwAnEFN4MavYzJYXRVuYYhHvrgKuwKLEa3RPp
 2t+xdRFL
 wWMz+jQ5LGZbZUvWw0YKU4GLyiHT8Czm/RsLWKZfvUWmOXw0jA6gRKAzm3etgqo8/Io0gs0i1TqKRG/ByBbFXh+piTBjib+fmuYr9bqudESOwbbNjW8emkQ1WKWTHLp+mCf4MX7xGXKYuCaMnyVreaSe5/EmWAhD0pgUHCn2FwGkTjv+GzaCxDbk82KExObL+22q76Jr7RDWGUtLX+3uurk+mPgQeV3UAY1lx
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/12/11 0:36, Johannes Weiner wrote:
> On Wed, Dec 10, 2025 at 07:11:42AM +0000, Chen Ridong wrote:
>> From: Chen Ridong <chenridong@huawei.com>
>>
>> The mem_cgroup_size helper is used only in apply_proportional_protection
>> to read the current memory usage. Its semantics are unclear and
>> inconsistent with other sites, which directly call page_counter_read for
>> the same purpose.
>>
>> Remove this helper and replace its usage with page_counter_read for
>> clarity. Additionally, rename the local variable 'cgroup_size' to 'usage'
>> to better reflect its meaning.
> 
> +1
> 
> I don't think the helper adds much.
> 
>> --- a/mm/vmscan.c
>> +++ b/mm/vmscan.c
>> @@ -2451,6 +2451,7 @@ static inline void calculate_pressure_balance(struct scan_control *sc,
>>  static unsigned long apply_proportional_protection(struct mem_cgroup *memcg,
>>  		struct scan_control *sc, unsigned long scan)
>>  {
>> +#ifdef CONFIG_MEMCG
>>  	unsigned long min, low;
>>  
>>  	mem_cgroup_protection(sc->target_mem_cgroup, memcg, &min, &low);
>> @@ -2485,7 +2486,7 @@ static unsigned long apply_proportional_protection(struct mem_cgroup *memcg,
>>  		 * again by how much of the total memory used is under
>>  		 * hard protection.
>>  		 */
>> -		unsigned long cgroup_size = mem_cgroup_size(memcg);
>> +		unsigned long usage = page_counter_read(&memcg->memory);
>>  		unsigned long protection;
>>  
>>  		/* memory.low scaling, make sure we retry before OOM */
>> @@ -2497,9 +2498,9 @@ static unsigned long apply_proportional_protection(struct mem_cgroup *memcg,
>>  		}
>>  
>>  		/* Avoid TOCTOU with earlier protection check */
>> -		cgroup_size = max(cgroup_size, protection);
>> +		usage = max(usage, protection);
>>  
>> -		scan -= scan * protection / (cgroup_size + 1);
>> +		scan -= scan * protection / (usage + 1);
>>  
>>  		/*
>>  		 * Minimally target SWAP_CLUSTER_MAX pages to keep
>> @@ -2508,6 +2509,7 @@ static unsigned long apply_proportional_protection(struct mem_cgroup *memcg,
>>  		 */
>>  		scan = max(scan, SWAP_CLUSTER_MAX);
>>  	}
>> +#endif
> 
> To avoid the ifdef, how about making it
> 
> 	bool mem_cgroup_protection(root, memcg, &min, &low, &usage)
> 
> and branch the scaling on that return value. The compiler should be
> able to eliminate the entire branch in the !CONFIG_MEMCG case. And it
> keeps a cleaner split between memcg logic and reclaim logic.

Much better, will update.

-- 
Best regards,
Ridong


