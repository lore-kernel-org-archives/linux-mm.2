Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2162ACD4851
	for <linux-mm@archiver.kernel.org>; Thu, 14 May 2026 08:02:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 829D26B008A; Thu, 14 May 2026 04:02:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7DB956B008C; Thu, 14 May 2026 04:02:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7177E6B0092; Thu, 14 May 2026 04:02:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5BE846B008A
	for <linux-mm@kvack.org>; Thu, 14 May 2026 04:02:10 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id EF4CAA02FA
	for <linux-mm@kvack.org>; Thu, 14 May 2026 08:02:09 +0000 (UTC)
X-FDA: 84765282378.26.5105EF0
Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.2])
	by imf30.hostedemail.com (Postfix) with ESMTP id 3693580002
	for <linux-mm@kvack.org>; Thu, 14 May 2026 08:02:06 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=mla80myU;
	spf=pass (imf30.hostedemail.com: domain of 18810879172@163.com designates 117.135.210.2 as permitted sender) smtp.mailfrom=18810879172@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778745728;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2wZMTh+1D838cPRYfvU/JSIy1+/YJa6vhcFveOfSWR8=;
	b=Y5MZE3tEQkZWi6859HVncAA5IniDDgPBS6AeWolP6cppk1jsWxAZyYL3OJg/v9JxZ+NKwj
	jOV9f3OeAfPXHkkpBAwp7AepL7AMglGI+cxkkBDwlJ/66lNGHBjhGt1t381zN9lJT96FMz
	+vmVB8m5H2Svemb7Dl4FRDlDV7ESlQM=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=mla80myU;
	spf=pass (imf30.hostedemail.com: domain of 18810879172@163.com designates 117.135.210.2 as permitted sender) smtp.mailfrom=18810879172@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778745728; a=rsa-sha256;
	cv=none;
	b=Uz3w3gJZUZI9kX/+vRn1J8zUdnU0Vje8+Rkx2YP9wdggugujZlUFuu6UeqqQiwu2fi9pKB
	/Bx60rKP0b89ZXVNVji0QslGemLDtEHQVNoUpSW3Tq2oGQZW+dutJKk37btTIOpCk6nrtP
	AVCJIuuaIrKcpuX5YcvaoUM/PBn+mE4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=Message-ID:Date:MIME-Version:Subject:To:From:
	Content-Type; bh=2wZMTh+1D838cPRYfvU/JSIy1+/YJa6vhcFveOfSWR8=;
	b=mla80myUykgtG1Nim9LJZE0v4WWo+wtuz06dOk4B5huTAaONFBTGJYOgnlE4i+
	CroDEZ0VhokYUvsM7ye9c2ZwGGpBUfY/1N6VZjd1VYCiI9MD2Z2yAhz8dL7YLXgD
	AZVtUJJzkSzSRLVlOlQwgrwJ2vj6zKLgw4QmHYJqunREI=
Received: from [192.168.111.49] (unknown [])
	by gzga-smtp-mtada-g1-3 (Coremail) with SMTP id _____wD3pjtkgQVq+ApBBQ--.7663S2;
	Thu, 14 May 2026 16:01:42 +0800 (CST)
Message-ID: <ef571709-b761-43ad-8a16-f9034f44d033@163.com>
Date: Thu, 14 May 2026 16:01:40 +0800
MIME-Version: 1.0
User-Agent: =?UTF-8?B?TW96aWxsYSBUaHVuZGVyYmlyZCDmtYvor5XniYg=?=
Subject: Re: [PATCH v2] mm/shrinker: simplify shrinker_memcg_alloc() using
 guard()
To: SeongJae Park <sj@kernel.org>
Cc: akpm@linux-foundation.org, david@fromorbit.com, qi.zheng@linux.dev,
 roman.gushchin@linux.dev, muchun.song@linux.dev, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, wangxuewen <wangxuewen@kylinos.cn>
References: <20260514011207.148756-1-sj@kernel.org>
From: wangxuewen <18810879172@163.com>
In-Reply-To: <20260514011207.148756-1-sj@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wD3pjtkgQVq+ApBBQ--.7663S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7KFW8KrWfuw45Gw4kKw17ZFb_yoW8tFy8pF
	Z8Gay7KF4FyF1kZFy2yFnIqryjvw48uayxJrs7XFyYy34fXF1fWr1xt3y2kFykCa4xCryI
	qryjgF1293WUtrJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0zRrnY7UUUUU=
X-Originating-IP: [183.242.174.21]
X-CM-SenderInfo: rprymiyqyxmiixs6il2tof0z/xtbC7wdVS2oFgWc4qAAA3v
X-Rspam-User: 
X-Rspamd-Queue-Id: 3693580002
X-Rspamd-Server: rspam06
X-Stat-Signature: p3drsg8p16dsp5i74by3ex78z6jj3ujx
X-HE-Tag: 1778745726-509438
X-HE-Meta: U2FsdGVkX181EFXxN3jedjV/MKadIhjQFpZPln/OguDwHfV3u77D+AmJeTodajbzsz3iIQf9Sg20nqH1hB+d+i6FlPPohGCtBX2JZy9n855xo1BKzL1wvu8qRthikoZMidv3QgyCy+TbYSaVSPeZwTiWv0GuijZAZqnZ0qebltYe+suDehVKjsr5vb4VkUBDkNZxSZ29VQRQoAYNE65sVVSeCXikDrh0JeoP2sw2daCXpiMib69Kfr+5L1yvpAzzlrWGV9skz1SBSFFMgptf5hVSufiIvD8fYX5taXeGOOwT7B4bfTDFGEYE0D3+SrGUhoaTS3i6PRtl90lP4zMrpH0EKUvghiHsdqCSbIJ9mmWWJwGRuPT5WxeYbn/bGnDTcwK+R6AClIHnaTGAjnWZnPLepFUE+j4QEz7L02a8kkgpp2SSmsQUM6ORvufQ6fe4vhD7Y1SCcrYR4GvJiXEmfctIEe8nlQ1+QCLz5s8iWK2MdhCs1mtLEtKNZADvzdM2rz/wy82+Xzi/WMoghWMJRFaD9ohTcsm4VSZSH3f4IoG/uI5zYrd0MW42bQ7OPTuMjayI0V1A5unS7r0HEa6Hvi3Xy/tRpXf8epQ/UQVOWv39y2HijSKCzHhj+vvIA3T2yNqvSsSBTsfB9gg5+nMvc4CqhmQwl66qbZZryqzuyd1zV/k4zhSWSFBUcmk5LkQ53/L3tBxEUz9IVK6aRgNAa7IxQnFsS71T2l2NZDoyZj+PeAbUCavSoNF8u3S4GA64+vA+DqTMmJV+NZYTUVdeWlJ8ARKakDHB2s3YF4lju0bFQSOEs+Z2TaMbzkJygLM2rLQO14COjFT/T4TJFmHrBdNPyM4AzzaI5gpaTNzCDQ+co5H0dDAN1jedilJPYV70DksatwmjTGfNO7OOcpG6W2vFMGap0PX01FffZKv3vVHL6LkHDihvoHJmuEq7V8jtEdOsKwHEa7+o50sbVDt
 6jJOZ+Ef
 uRp5PRaj0pyqXCh9ooHd8Y+DGEtW9LKMbYVdd3ITPQrei9Mv6IN79KT8rsHJ+5vL/w/vhMtSziUxhWhRQ8ckIIHGz4IwRm8d3MH6c4ABv78MBe8QAYzEpFIaDXZgDj/0UbGn1m5VNVBnRHlGMCHaFghQIcDzJvT17aHxctphUIFumA+8kWu+7hh6THPwU+2dJ+cz5vAt8NkG2oJXZ6XK6Ftpm46Xx47ujTH+13hEiYpWGNINZc68aGYUsJklGYQI+GKYQALPCn52MF4WxyiF8Z71NqcNS7HwE90QR+db3A4FewIRY0BcgXb/drPFXqGjjVZHhxSLz/uhLDIPbAZ6Wx3JRI0jFeU/7c/DnbndHFgWOoei/KX/TZOY3bGSh9ys9UB+WmesOe43H/ZGE2iXv67VNWz/hOm2Sba8pwOFuoJfx23RRTZJ1y3RVtqAXGu2pNSpWY4EqWpsgLiM1MqIQDzKXgNY1anmJuA0f0q0CPE/GKcC76x5MSeL495WFLsxj09oQlBKI7m9Rt0bqZrAjzNsvHp5yB7C1tqsylEPQ/8IpTMDOp5i7BbFPl8OF/JQQBel84b36N/v3Dfmho6zpwLR/T1XWhvtO32nb1deBABk/+Sk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi SeongJae,

Thank you for pointing out the patch changelog convention.
I appreciate the feedback and will make sure to follow the rule of 
placing version changelogs after the --- separator in all my future 
submissions, as well as adding links to previous versions.

Thanks,
Wang Xuewen

在 2026/5/14 9:12, SeongJae Park 写道:
> On Wed, 13 May 2026 15:52:14 +0800 wangxuewen <18810879172@163.com> wrote:
> 
>> Use guard(mutex) to automatically handle shrinker_mutex locking and
>> unlocking in shrinker_memcg_alloc(). This removes the explicit
>> mutex_unlock() call, the goto-based error path, and the redundant
>> ret variable, resulting in cleaner and more concise code.
>>
>> v2:
>> - Drop unused 'ret' variable to avoid compiler warning (Muchun Song).
> 
> Patch changelog should go to commentary area [1].  Also adding links to
> previous versions would be helpful.
> 
>>
>> Signed-off-by: wangxuewen <wangxuewen@kylinos.cn>
>> ---
>>   mm/shrinker.c | 13 +++++--------
>>   1 file changed, 5 insertions(+), 8 deletions(-)
>>
>> diff --git a/mm/shrinker.c b/mm/shrinker.c
>> index 76b3f750cf65..cb03fbecc75d 100644
>> --- a/mm/shrinker.c
>> +++ b/mm/shrinker.c
>> @@ -215,29 +215,26 @@ static DEFINE_IDR(shrinker_idr);
>>   
>>   static int shrinker_memcg_alloc(struct shrinker *shrinker)
>>   {
>> -	int id, ret = -ENOMEM;
>> +	int id;
>>   
>>   	if (mem_cgroup_disabled())
>>   		return -ENOSYS;
>>   	if (mem_cgroup_kmem_disabled() && !(shrinker->flags & SHRINKER_NONSLAB))
>>   		return -ENOSYS;
>>   
>> -	mutex_lock(&shrinker_mutex);
>> +	guard(mutex)(&shrinker_mutex);
>>   	id = idr_alloc(&shrinker_idr, shrinker, 0, 0, GFP_KERNEL);
>>   	if (id < 0)
>> -		goto unlock;
>> +		return id;
> 
> Could this change the return value?  This code was always returning -ENOMEM
> before, but seems it can now return -ENOSPC?  Seems that doesn't matter,
> though.
> 
>>   
>>   	if (id >= shrinker_nr_max) {
>>   		if (expand_shrinker_info(id)) {
>>   			idr_remove(&shrinker_idr, id);
>> -			goto unlock;
>> +			return -ENOMEM;
>>   		}
>>   	}
>>   	shrinker->id = id;
>> -	ret = 0;
>> -unlock:
>> -	mutex_unlock(&shrinker_mutex);
>> -	return ret;
>> +	return 0;
>>   }
> 
> [1] https://docs.kernel.org/process/submitting-patches.html#commentary
> 
> 
> Thanks,
> SJ
> 
> [...]


