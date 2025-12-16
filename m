Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 96A48D5E147
	for <linux-mm@archiver.kernel.org>; Tue, 16 Dec 2025 12:34:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 05C6E6B0005; Tue, 16 Dec 2025 07:34:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F22B66B0089; Tue, 16 Dec 2025 07:34:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E20996B008A; Tue, 16 Dec 2025 07:34:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CE5B26B0005
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 07:34:58 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 884C2C0638
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 12:34:58 +0000 (UTC)
X-FDA: 84225278676.25.D720FF3
Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	by imf27.hostedemail.com (Postfix) with ESMTP id 5060340008
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 12:34:50 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	spf=pass (imf27.hostedemail.com: domain of chenridong@huaweicloud.com designates 45.249.212.51 as permitted sender) smtp.mailfrom=chenridong@huaweicloud.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765888496;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kQR74/ksaXQZedcRd2myaaC49e2JtPPkTV8e7vIDcuY=;
	b=BWv1VSQ3Au1+yDEygDjB5Dgxg13xfE+QXu4RHqwLM6yTvTdKX6+eZKW9/UKABjbAuyDA2W
	orZCEFGSqS7azg/hPeMW4EDc44HA1tEA0AnD4IwbCqBlGH0kmmpMFae3qgibiP4pAihtq/
	lBHUSvtqhlyNTf/mpy3YaiF7imH+Ao0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765888496; a=rsa-sha256;
	cv=none;
	b=YW2MOr3FJnTULm4Nf7UJOa9ENZnI1rWQsYaV9IBF22bG+9dwB8GkziG3I3wsf2t8MfiJIj
	hXXL/Ik+eGd+Bto3G6mAZwLrFj/DfmAKcFQ22vrGPOnnGYw6bt0C8oYFyXnLNDi/6cjkKm
	oOiMnp88cLTVg9g/nYofsqe1ReafN9I=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=none;
	spf=pass (imf27.hostedemail.com: domain of chenridong@huaweicloud.com designates 45.249.212.51 as permitted sender) smtp.mailfrom=chenridong@huaweicloud.com;
	dmarc=none
Received: from mail.maildlp.com (unknown [172.19.163.170])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4dVxFR1ppfzYQtkG
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 20:34:19 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 708084056D
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 20:34:44 +0800 (CST)
Received: from [10.67.111.176] (unknown [10.67.111.176])
	by APP4 (Coremail) with SMTP id gCh0CgCHNvfhUUFpcimUAQ--.7655S2;
	Tue, 16 Dec 2025 20:34:42 +0800 (CST)
Message-ID: <476fcde5-d54d-4b15-9870-844b3b8c700a@huaweicloud.com>
Date: Tue, 16 Dec 2025 20:34:40 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH -next v3 2/2] memcg: remove mem_cgroup_size()
To: =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>
Cc: hannes@cmpxchg.org, mhocko@kernel.org, roman.gushchin@linux.dev,
 shakeel.butt@linux.dev, muchun.song@linux.dev, akpm@linux-foundation.org,
 axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com,
 david@kernel.org, zhengqi.arch@bytedance.com, lorenzo.stoakes@oracle.com,
 cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 lujialin4@huawei.com
References: <20251211013019.2080004-1-chenridong@huaweicloud.com>
 <20251211013019.2080004-3-chenridong@huaweicloud.com>
 <o3hmzratjkcxms3ylnjiuashclllf7mvz6ttkfrz4lybdiwhhp@yeo5my374trx>
Content-Language: en-US
From: Chen Ridong <chenridong@huaweicloud.com>
In-Reply-To: <o3hmzratjkcxms3ylnjiuashclllf7mvz6ttkfrz4lybdiwhhp@yeo5my374trx>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgCHNvfhUUFpcimUAQ--.7655S2
X-Coremail-Antispam: 1UD129KBjvJXoW7tF4kCFW8Wr18Kw13Wry8Krg_yoW8KryUpF
	nFka47ta15Zryjyr4Iv34Yva48tw48t34UG347Gr18X3srWrn5tF9Fka40gFy8CF93AF17
	ZF15uws7A3y2k3DanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUvYb4IE77IF4wAFF20E14v26ryj6rWUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x
	0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG
	6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFV
	Cjc4AY6r1j6r4UM4x0Y48IcVAKI48JM4IIrI8v6xkF7I0E8cxan2IY04v7MxkF7I0En4kS
	14v26r4a6rW5MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I
	8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVW8ZVWr
	XwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x
	0267AKxVW8JVWxJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_
	Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8Jr0_Cr1UYxBIdaVFxhVjvjDU0xZFpf9x07
	jIksgUUUUU=
X-CM-SenderInfo: hfkh02xlgr0w46kxt4xhlfz01xgou0bp/
X-Stat-Signature: cx3qhb5w1nif5tzie9gfwq1cu1fe78bh
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 5060340008
X-Rspam-User: 
X-HE-Tag: 1765888490-963199
X-HE-Meta: U2FsdGVkX1+WCP/IgurG0DN/DNzSgF0Qm/Rq+L1lksxOdPIaq3iiwKmwe0yixNbXtIEcZ2rPGiHgkHlsiqls/JLtPThnYOu/5d/Ho2EmegHYTGgKJm1a39OkdelZ2lg6GPtFnvy3XM5fOsWbf/DXHuFb7zX8odSE8MQbHofKDWtH3A9CUZ95vy7nQP3dUO5tWxOk32vL9PB6rCQ0apiUlr5279Su+lze1ZYNvgd60OVFqtiVeEbeAcDGXQtKGw/6SzJvrjXND56Dg08S2jEoGXBDB/vyeAr3qWQ0gjfuq5pMEUtZACWJDQlSd540LnR99+OEMI4aeoieDt758xIpa7KJITTntVa7G+kK/mo2DmBTBme+YSpIkwutjvtzwLP2qVguYKg64IOvZEBx/w84squ205ttDONGCvEfWEdhz2GoKORG1BfuIQXwxcZhKj8FP9Px6aDjXWb8BGuHlgOR23TV68POFUypRGab39ULKkofyS51y6yTiZzsp+2jdad2WQeKj4HTVFtPoBuY0G/DCCOBh5DW4rCW0iw5OCXPMMkdXm3zGBAoovBAQwYF7E5bfHJMOEwJ88U6EfKLPqLZ/1NoPuKzvT4hR5WegyVaZ436zoV5DJW5lk6JKXJkvgspjd423Uy30+teoDk6vW2JR7S8RzQB0jKm+MBPRSRmbMsb1zMxci+Cg4qS23w2KPUW6bSFZsxADjr9pmATHS0+NpRmTxt2b1L9n88NmOCj+vMYBOfzIzcARO8joXOu6BPTwyas19kHLzKjwqp/5Pf7pN2FLKYJY6Mb+96d9JHwUiqmVAwTLPX0lRhk7w0QJDoXcczbgiFfgStq+2VSo9TI0GoOe3iUzaKE6M/10AogodoT9Cdlcb5JpON4H69rUBBb092z0hB6hvAKqdngJQktyK4yUhd1CChXJSmv4T+toNhHLvW4ygiScGif0S18b5e5j9f+4CBMMnYME8sJJp+
 im3LT8xD
 mydezj0lGDk9HHwKr/HD/SzHvJptAE/kzeHmD54gTspK15jv2ChMWss43UO2G1fpqrsaDq47+UBe29NQVRoxUidNJeRTjgnXA5O13mpKwkvuyBfDiMl5r/vizYRDE1x2TXEu8iQKAXEewVfQU2QLcJ0CX3ptyG4qnikI3HkW7tvNKD878Tdjou/9fcbVACeIdaDLtMY0LWphZnUxh2tmSM3UhCr3khfrw+3SSWQxYTCbNyahvfVAewIIPnX1tY+BNNIgoS5qu9IhiI6AgHiP4hB1BLTVdKh+PQCJpdjVr2JhziOT9EB1ayMLAfAZ2dcQcLbyx
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/12/16 0:28, Michal Koutný wrote:
> Hi Ridong.
> 
> On Thu, Dec 11, 2025 at 01:30:19AM +0000, Chen Ridong <chenridong@huaweicloud.com> wrote:
>> From: Chen Ridong <chenridong@huawei.com>
>>
>> The mem_cgroup_size helper is used only in apply_proportional_protection
>> to read the current memory usage. Its semantics are unclear and
>> inconsistent with other sites, which directly call page_counter_read for
>> the same purpose.
>>
>> Remove this helper and get its usage via mem_cgroup_protection for
>> clarity. Additionally, rename the local variable 'cgroup_size' to 'usage'
>> to better reflect its meaning.
>>
>> No functional changes intended.
>>
>> Signed-off-by: Chen Ridong <chenridong@huawei.com>
> 
> Why does mem_cgroup_calculate_protection "calculate" usage for its
> callers? Couldn't you just the change source in
> apply_proportional_protection()?
> 
> Thanks,
> Michal
> 

I apologize for missing this message earlier.

In my v2 patch, I was reading the usage directly:

+		unsigned long usage = page_counter_read(&memcg->memory);

This works fine when CONFIG_MEMCG=y, but fails to compile when memory cgroups are disabled. To
handle this, I initially added #ifdef CONFIG_MEMCG guards.

Following Johannes's suggestion, I have now moved this logic into mem_cgroup_protection() to
eliminate the #ifdef and keep the code cleaner.

Discussion:
https://lore.kernel.org/all/20251210163634.GB643576@cmpxchg.org/

>> @@ -2485,7 +2485,6 @@ static unsigned long apply_proportional_protection(struct mem_cgroup *memcg,
>>  		 * again by how much of the total memory used is under
>>  		 * hard protection.
>>  		 */
>> -		unsigned long cgroup_size = mem_cgroup_size(memcg);
> +		unsigned long cgroup_size = page_counter_read(memcg);
> 
>>  		unsigned long protection;
>>  
>>  		/* memory.low scaling, make sure we retry before OOM */
>> @@ -2497,9 +2496,9 @@ static unsigned long apply_proportional_protection(struct mem_cgroup *memcg,
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

-- 
Best regards,
Ridong


