Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1B643D3B9A9
	for <linux-mm@archiver.kernel.org>; Wed, 10 Dec 2025 08:31:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4912D6B0006; Wed, 10 Dec 2025 03:31:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 41AED6B0007; Wed, 10 Dec 2025 03:31:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2E2F76B0008; Wed, 10 Dec 2025 03:31:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 182976B0006
	for <linux-mm@kvack.org>; Wed, 10 Dec 2025 03:31:50 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 942FD8A4D0
	for <linux-mm@kvack.org>; Wed, 10 Dec 2025 08:31:49 +0000 (UTC)
X-FDA: 84202893138.06.B4A01C7
Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	by imf15.hostedemail.com (Postfix) with ESMTP id D1F46A0008
	for <linux-mm@kvack.org>; Wed, 10 Dec 2025 08:31:45 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	spf=pass (imf15.hostedemail.com: domain of chenridong@huaweicloud.com designates 45.249.212.51 as permitted sender) smtp.mailfrom=chenridong@huaweicloud.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765355507; a=rsa-sha256;
	cv=none;
	b=Gx6g4pQDdyaelYvokCH1xCjHBDQDTwemRsY5CXXSx+H4gMd9QcKuIcmnlxiMIQPPLgmQ20
	opP0yWDaoLus8oM1o6zoJz8VpI50XHCBAP7ypapGYWi0VABxRx36dTMihsNTfGR5WyLsNV
	8jGXP3HFtB7g4O2N3w8BV9SXgOqg7Dg=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=none;
	spf=pass (imf15.hostedemail.com: domain of chenridong@huaweicloud.com designates 45.249.212.51 as permitted sender) smtp.mailfrom=chenridong@huaweicloud.com;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765355507;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9g815ff2nmCLWOZaxMXVFeBlpZ6ADS9ULTkApNOzQxw=;
	b=zLbnHXPgLAMqxswPHipSh8NBMwmug7wz2LoeusYbf3ZDCbipG5RLSE2/9sYbA573C69s5W
	wszRg+kBMXNlWoA8kdh2yZ7uvbKMj43HwUQx/BqRJMdbg/Urq7eBlyO6VsfoE9t/PF15pE
	gpNmQviymA500MJ3yUSrOOSZoz507fc=
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4dR87w2mrWzYQtJ0
	for <linux-mm@kvack.org>; Wed, 10 Dec 2025 16:31:24 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.75])
	by mail.maildlp.com (Postfix) with ESMTP id 356431A06DD
	for <linux-mm@kvack.org>; Wed, 10 Dec 2025 16:31:39 +0800 (CST)
Received: from [10.67.111.176] (unknown [10.67.111.176])
	by APP2 (Coremail) with SMTP id Syh0CgDXt1HpLzlpSPr2BA--.8485S2;
	Wed, 10 Dec 2025 16:31:39 +0800 (CST)
Message-ID: <9a9abc04-8915-40ac-ad40-2ae67d429ddb@huaweicloud.com>
Date: Wed, 10 Dec 2025 16:31:37 +0800
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
Content-Transfer-Encoding: 7bit
X-CM-TRANSID:Syh0CgDXt1HpLzlpSPr2BA--.8485S2
X-Coremail-Antispam: 1UD129KBjvJXoW7tF4kCFW8Wr18Kw13Wry8Krg_yoW8AFWfpF
	W0ka45tr45try3Cw1avas5Z34Fv3y0qa45GryxKr1IqwnxJr1rtF92k3WvgryUGF9xZF1S
	vayYgFs3ArWjk3JanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
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
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: D1F46A0008
X-Stat-Signature: 5rs78117w165kt5q75w4d7nwccjqs83k
X-Rspam-User: 
X-HE-Tag: 1765355505-838683
X-HE-Meta: U2FsdGVkX1916qN7ZfI1dLDQM1xq2q6J1LXrVMVzgyQMu0jsoTHEMzlLNe9+EcN07jWHexUobY1S36JVJMRMVjFIj7J6H/CRl+aoPyZ5iUE/o/UeMnPHWnK2iwHb2VfzxxnpwMimCC3QQSbYisXUEP2CB4RWivHq/JqzBfPN+Hz7GdnMRX4CMVHv1P11av/xZRiLkI4jEA/Oo2mTW5HYiu+V0TtWLnqlfUP2OgSuLOZ4xCcO7RPooK36nZSwohDXor0Cf9t5ln3o7tI60jXwkK9pDsCjufUXe0o0jCd8FO7uX9/FlWKjCon2khvKthq8Ne63YTue97crpA3X08CCFOaW9Xq9/QCq5bA8nqcyf35y0ZEy+Ur5O70sniR0Oa7B8ZirwNUyH2k39olY5qCsxeMmBHx4e0+uJekdEG6UNCugV0tauWauAbb7ikX3NwUjhrUAR2PIGDD/wv6qf0MBLH/rxg4NIWXZCTobqtjxlwenzweWRismPl35kFq5B+xY0iB6DW3CJredPjpbzl58CdatjE8RXxOPYyHNZZdEUAxneqno3lG9GYTVAoIOu/Ik125e3f79vGyaKCNXrVx3N6AOTg1jSBLOuCXuTBvr2SzeiK4aqeu4uqENpHINodcUTYUZPsVgahaX1SlN/j3EYY8op4NW5JMqE2t8P0ILSnbNcL/eYmlzxCP02RlHSEizqa/2T7XejPLd1N2Sab1FqjGGk9rHJ+utg+uLKSRSUKiE1XDab9nEGzLj95qaGwO2fJg2UfTOfnuN5tahUocmr8eMKro+SUJFNv6mYrusucQtuiu2Ro0XlKH/MLkzlRTspF1Yk3ZXzF8TmTOeaynIScNElNGVjPciVBAOWtDCUAD8S5pg20e2jw14yikSwDArAxs62CjjL0JlDTh/guyJjaGwnVFLCi1PAhKfDwBxIT2SF99D9kQ5OdkQ3pBdp1mdJHuXaWDGWlrMyrOIANL
 s05z/A5k
 Lv5f0I/tPVlg5BqWQ4bwpXwdVxhvNvIvaDqRXZDjqvAdl/jPzXgyCVknEuJ3rbtoTgeGPH/E9qcFqRUtniUelalmlPnAbYt7Y8kx6WRfmNkQWfijauW80OvcVz2CxQ/j8Ft7yOYMoSpzGQs4JmOELuLOWFV83nL7RCYFnbCWbZ2ZASDQTkS2mwwumhnuf+PsT2yp1
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

This returns what was passed as input. This means the scan behavior remains unchanged when memcg is
disabled. When memcg is enabled, the scan amount may be proportionally scaled.

-- 
Best regards,
Ridong


