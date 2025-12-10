Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 910C0D3B9A9
	for <linux-mm@archiver.kernel.org>; Wed, 10 Dec 2025 08:42:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E96D96B0006; Wed, 10 Dec 2025 03:42:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E47E86B0007; Wed, 10 Dec 2025 03:42:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D5DBD6B0008; Wed, 10 Dec 2025 03:42:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id C43576B0006
	for <linux-mm@kvack.org>; Wed, 10 Dec 2025 03:42:23 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 6A28DB8FA2
	for <linux-mm@kvack.org>; Wed, 10 Dec 2025 08:42:23 +0000 (UTC)
X-FDA: 84202919766.11.F744079
Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	by imf21.hostedemail.com (Postfix) with ESMTP id 7BEBC1C000C
	for <linux-mm@kvack.org>; Wed, 10 Dec 2025 08:42:17 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	spf=pass (imf21.hostedemail.com: domain of chenridong@huaweicloud.com designates 45.249.212.56 as permitted sender) smtp.mailfrom=chenridong@huaweicloud.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765356141; a=rsa-sha256;
	cv=none;
	b=7IRV7rTLgJi1SJ6nElA3lXJf+m+c/dphW2mYvqnANFAjbGvJVPEzvSSWGRtXyCJEQLHCet
	zKhhmkCPyFpDLV8qo6Lo6FEFeZgh3m9Gayv44RSuMocLjFg6qtDKnbi73rdTtIRq6vFsFJ
	VjbpfCxjnvBaIRds+/F7J4bmCsKzFWw=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=none;
	spf=pass (imf21.hostedemail.com: domain of chenridong@huaweicloud.com designates 45.249.212.56 as permitted sender) smtp.mailfrom=chenridong@huaweicloud.com;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765356141;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=HeryyzZzLp65h/NZGcvmK52pZNFHK5D9WdENI+2hwvk=;
	b=sw/zKRNERixadFVrChvg+31CINhqVYhVwXgTFB011HXFXUh7w2X5Tp6DcUB4YZWA+WPru3
	w1ojER9MSDVxfNWXPahxUXbkZe4Ibev0pPVN1n+1QTKjgXXFwbjp7qrmjbsdYFAjfoyuGF
	+XmeZoswu856y9qoOVdSzeHw3ylwiWw=
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4dR8MD1JvyzKHMn4
	for <linux-mm@kvack.org>; Wed, 10 Dec 2025 16:41:12 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.75])
	by mail.maildlp.com (Postfix) with ESMTP id EF5B91A084D
	for <linux-mm@kvack.org>; Wed, 10 Dec 2025 16:42:11 +0800 (CST)
Received: from [10.67.111.176] (unknown [10.67.111.176])
	by APP2 (Coremail) with SMTP id Syh0CgBXOFJiMjlpL9n3BA--.10261S2;
	Wed, 10 Dec 2025 16:42:11 +0800 (CST)
Message-ID: <48f734fa-531a-4b3f-9c96-02dd342d41d2@huaweicloud.com>
Date: Wed, 10 Dec 2025 16:42:09 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH -next v2 2/2] memcg: remove mem_cgroup_size()
To: Michal Hocko <mhocko@suse.com>
Cc: hannes@cmpxchg.org, roman.gushchin@linux.dev, shakeel.butt@linux.dev,
 muchun.song@linux.dev, akpm@linux-foundation.org, axelrasmussen@google.com,
 yuanchu@google.com, weixugc@google.com, david@kernel.org,
 zhengqi.arch@bytedance.com, lorenzo.stoakes@oracle.com,
 cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 lujialin4@huawei.com
References: <20251210071142.2043478-1-chenridong@huaweicloud.com>
 <20251210071142.2043478-3-chenridong@huaweicloud.com>
 <aTkp1tIIiw8Nti10@tiehlicka>
Content-Language: en-US
From: Chen Ridong <chenridong@huaweicloud.com>
In-Reply-To: <aTkp1tIIiw8Nti10@tiehlicka>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:Syh0CgBXOFJiMjlpL9n3BA--.10261S2
X-Coremail-Antispam: 1UD129KBjvJXoW7tF4kCFW8Wr18Kw13Wry8Krg_yoW8ur1UpF
	Wvka45ta15Ary3Jw1Sv348Z3sYv3y0qay5Jry7Cr1fZwsIqrn5tFy2k3WvqryUCF9xZFyI
	vayY9an3Cw429aUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUvYb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x
	0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG
	6I80ewAv7VC0I7IYx2IY67AKxVWUGVWUXwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFV
	Cjc4AY6r1j6r4UM4x0Y48IcVAKI48JM4IIrI8v6xkF7I0E8cxan2IY04v7MxkF7I0En4kS
	14v26r1q6r43MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I
	8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVW8ZVWr
	XwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x
	0267AKxVW8JVWxJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_
	Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8Jr0_Cr1UYxBIdaVFxhVjvjDU0xZFpf9x07
	UQ6p9UUUUU=
X-CM-SenderInfo: hfkh02xlgr0w46kxt4xhlfz01xgou0bp/
X-Rspamd-Queue-Id: 7BEBC1C000C
X-Stat-Signature: 1j5r6t6hgsxuu8k3us9isr8fhjsepr4o
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1765356137-90271
X-HE-Meta: U2FsdGVkX1+XC9W42zdmTfObdoKcm5JMaY2o0nTgwOjka66mC9VKMeq+mK7N8PibSd72ukJ+a+KKf6LfxHVXoXkWpnarhurbSA9uh7DXvvF7cMlDklNXKtiZ0KbJA9aLQIxpRXttOLNzGDu5qCw2gWzpy0plKsgdMvrWSXvgF4Z9VAzI7btx7k8GxRWnKVUhVvUJNW4cFdcBv+drUeghDThZQD/ZNEtYtleu6hmPmM2wXB1k7pasHVHIrHbMIekthA8U5gF4228EPOIejfXh3WTx3c/oREd73oCqhY9/FxylKgzjqSgbsqPAFEX7vOrnvRIXLzup2M6pFAqeHN16AYeG8PZIb/T/RQ30Ca2POxN0MZTbBbeAoG3vo4O3mnYeD/xbXTwbvDlBi28/asoj+kd8fsr9h/0o/TRgyfvClnPZxm4s6omf8kIefiAioKQbR42QEp6rnkMVkLUsg56gjljqkdq7xNNhoVujF2tz/12Y/nzMgQrV5i+yHpuaDqAL8RUWtC4nVUbBegw+g1xyVPqld8Y5u29uhk9/0/jUc3oVrNdOS7co5sbwHY9XF/5aR4P+LEOFXEbSpIFmaVI0r3uBOKBnQJ8kzH2zASfXznh8+dDnoi9uK8xR9XPfrDhkKxuuS90RWgQ+vZH2zNweOtO2CoItmxBlX8fxd+JSX5u95S+fyiJdWZzJFXJAIbG49NET4G71GPxHwfsLWYOG7MKk6vObXr2a2EKPoUX6jIfsVHTkat/wyG9HI6gvgvHWjcVqifurXBy2rOUj2HLNKD/BUFSvtoX812+o3C5/bApKu6zreMGW7sJ81f6Hq73mWv1gifxIMqRI0NkwJfqOnjQbz8vAcOBSm2eXCjArr0OX9pa5qOYcMlTXQjebmhh6zG+XcPdRiKbvKj+l4W8UE5g65ysdbOlihN0V2GjF0jHqpzYL9qIe/5SIWDAJdW02BN8tIDkoSHooOGn966L
 XBnb+r4D
 HETX+vx1yCAoDcuInEFGzeR2L1L3kTUU9OlQrSa9iPx7nA9TucK74PHs+GjCgLyhACmt4rLQtwB60O0258qFyx5my3PRQyEasrVeviRp1pMQYA+96qh0bDZJzoRgZRNwZ6JUQe39GJgqINBZjSwPeQoGEYjMd+6LlYbRZfKP6tOavl3b85Q1DE7Jqyg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/12/10 16:05, Michal Hocko wrote:
> On Wed 10-12-25 07:11:42, Chen Ridong wrote:
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
>>
>> This change is safe because page_counter_read() is only called when memcg
>> is enabled in the apply_proportional_protection.
>>
>> No functional changes intended.
> 
> I would prefer to keep the code as is. 
> 

I find the mem_cgroup_size() function name misleading—it suggests counting the number of memory
cgroups, but it actually returns the current memory usage.

When looking for a clearer alternative, I found mem_cgroup_usage(), which is only called by v1. This
raised the question of whether mem_cgroup_size() is truly necessary. Moreover, I noticed other code
locations simply call page_counter_read() directly to obtain current usage.

> Btw.
> [...]
>> diff --git a/mm/vmscan.c b/mm/vmscan.c
>> index 670fe9fae5ba..fe48d0376e7c 100644
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
> [...]
>> @@ -2508,6 +2509,7 @@ static unsigned long apply_proportional_protection(struct mem_cgroup *memcg,
>>  		 */
>>  		scan = max(scan, SWAP_CLUSTER_MAX);
>>  	}
>> +#endif
>>  	return scan;
>>  }
> 
> This returns a random garbage for !CONFIG_MEMCG, doesn't it?
> 

-- 
Best regards,
Ridong


