Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D6663CF885C
	for <linux-mm@archiver.kernel.org>; Thu, 20 Nov 2025 13:32:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2CE826B0062; Thu, 20 Nov 2025 08:32:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2A5DC6B007B; Thu, 20 Nov 2025 08:32:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1E26C6B008A; Thu, 20 Nov 2025 08:32:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1190F6B0062
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 08:32:28 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B2B7512BC20
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 13:32:27 +0000 (UTC)
X-FDA: 84131074734.03.E489E93
Received: from out-179.mta1.migadu.com (out-179.mta1.migadu.com [95.215.58.179])
	by imf29.hostedemail.com (Postfix) with ESMTP id C0AAB120010
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 13:32:25 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=MrvtAjUo;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf29.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.179 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763645546;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ybURcIVrz7mysPIWzBzQOyxvKWboFgst4pbQzAb0oQs=;
	b=Iend45m1ZsP+RChgpDUiEyJ5SVUZnnOqfAyD2kczBxwaeNgYkAmoKfYgz5zrVGoXWdnQM4
	yEAXaQSdJkVmNve1YyUnI8gUYK2ptcKjwEaCVLWm5u5K+jT0SR86T39M+o4ftZ+Bz7PagK
	2rOCZN4A0UF5GfksdRh0SeNf5E/A59A=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763645546; a=rsa-sha256;
	cv=none;
	b=3UPCy2CKZSodhTkC60xoJMlWulCP7OGSVup/8kriJxoKbyYZq5jFES+iyHFrGVmA98QSuk
	OaV2kI8mAX15XgAuL5hf0XlMxFQvE28TrRyGcSOjF5PBPzNM2aZ5qVip9A2L7fNplwJ220
	p2re5TkK9uDvsT0IqMDlCvK1u2vmg9c=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=MrvtAjUo;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf29.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.179 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
Message-ID: <6d372282-d443-4fe4-942b-998aa742eb0a@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1763645543;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ybURcIVrz7mysPIWzBzQOyxvKWboFgst4pbQzAb0oQs=;
	b=MrvtAjUo07c82+yzmSH3h/kWt7CxnHcNiFmUBnzEiScilBeS3UAknDBBayZG72RaQ8b49Q
	WsAmvYaMaleu27E7PklGE0FVra3y9mswrhSRUNrvF0HZmdUAEY8r2jRI/jkyLrgiQttdNI
	kc5UbGFFwApLOHJkmNaZMpZXo4OaYmY=
Date: Thu, 20 Nov 2025 21:32:09 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v1 07/26] mm: memcontrol: prevent memory cgroup release in
 get_mem_cgroup_from_folio()
To: Harry Yoo <harry.yoo@oracle.com>
Cc: hannes@cmpxchg.org, hughd@google.com, mhocko@suse.com,
 roman.gushchin@linux.dev, shakeel.butt@linux.dev, muchun.song@linux.dev,
 david@redhat.com, lorenzo.stoakes@oracle.com, ziy@nvidia.com,
 imran.f.khan@oracle.com, kamalesh.babulal@oracle.com,
 axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com,
 akpm@linux-foundation.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 cgroups@vger.kernel.org, Muchun Song <songmuchun@bytedance.com>,
 Qi Zheng <zhengqi.arch@bytedance.com>
References: <cover.1761658310.git.zhengqi.arch@bytedance.com>
 <9eca65dec044d4352bee84511fb58960a1402ddf.1761658310.git.zhengqi.arch@bytedance.com>
 <aR16bLuvj-W0AAM1@hyeyoo>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <aR16bLuvj-W0AAM1@hyeyoo>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: 8uofczorpcuwpsyzr73etjnopkmipief
X-Rspam-User: 
X-Rspamd-Queue-Id: C0AAB120010
X-Rspamd-Server: rspam10
X-HE-Tag: 1763645545-201445
X-HE-Meta: U2FsdGVkX19Z0oub8CjdxPB+nsQV30dc+9fzSc5YgEjI04OF6zwZCcUvTLZf4wnGteUmGB25x/BVnIEJaohx4h+cmF+508hNMkO8EMPZlOY1msgy6DavNzS9gAvoGaoU5YjBRTR1pxwrRdq7yRC/sO4ocFvWXY+LNKYUK7RkrYn/CPxR8CWthNa6zH6wg/H82/fvgb8aAiYdb77Sdda/mr2gbJALPV4KQhNR99XKiL8qpzhHSVwWDaMn0Akps6Aw3dMaTuOvxbgg99c6NGciR3wLMckGjEY1OrDgzc4P5oum+jNty4yjERBQdOtgVHej7nbA5kPFQpMWwnLfesOFMphFsVgdryATag7akhdRVzW6TFUMNO5Zd9yhEdwlEX3qRMawwJcYDqZmy0FxyAP46dO9qwNMrhDrvHwmkEjUwbeO05Hl63dLuL8lW5ZhxcVm/gHps1JvsI+osCScCjYx/PJynVw+89BY/sqHF31/4I7uQdzzQZycvdxdORIxfqYMTPH1FpXMoDLb+4KvJgnuFvo/+doXgyDVcGPrK9/dtGeRUrwrIhaHfHKhWifBMY51st4sV04AecfGhwq9oIvhlMsLcaS8mjAriXrT12MrHKuUNsEXhPiQJj4qfSkMwxyV+9bLuedE0nXWMFfe598YfGhSAQQINcMn9VszBXRv+1gdGj9aRe+3/rSRmBSS+vK+HJN9MMaPoMpYuHtnoDqj6HbYrFAiYvXE2S988iID0ObK+/yMCoFAeNWS3ZQsDoYKrrxKVDAMNS6ivEiV0zsYlvnv56SEmR7eKhJq4SjCK6unq+TgEuJgXW4vgfaVRsE8mX8RU8PPXLb2YnaYJQhy55je2cgkf82aec6snVjiaZ1CgCYqQMR0G4My02yeVvczSQ/x6zH0HHZZbTE6T55Dl30yoFXvU7uoqcMSk2xCNve0cjV5zp0lWLG3t3oJALl99fd/UbGlH2Roq3YsehE
 H7pCSrBQ
 ZyLozIabhv5yiXO5XwJtTCcn0Kwus5xaOwwOsYI6VUfzQZtkEpF8Ilo2dImqqp6T5cz7cDpLop6gpsru5sL8ymg3lY87NEuU6CfHBFY5iLgUCfd1C6V+L0PYWgo2wy0NWYr1O3gA6mc5xXnL1Ej9djqtw3zX+9JGXEGCHuPnp35yQNvWdLqZ1Qkfbu1ueDphvowl9R2m72aoAOQKOlnDH+1pyu01RrKCCM24IEej30/OXCM9xYvKT3qpHY/tZJvt74ArM49mMJqqFI/M0Sjl5Aoniml9O9WKJ4342iARCvgKjOV2o8KoFKThqZYjTxmERO52HbhXkYrnsDB0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 11/19/25 4:06 PM, Harry Yoo wrote:
> On Tue, Oct 28, 2025 at 09:58:20PM +0800, Qi Zheng wrote:
>> From: Muchun Song <songmuchun@bytedance.com>
>>
>> In the near future, a folio will no longer pin its corresponding
>> memory cgroup. To ensure safety, it will only be appropriate to
>> hold the rcu read lock or acquire a reference to the memory cgroup
>> returned by folio_memcg(), thereby preventing it from being released.
>>
>> In the current patch, the rcu read lock is employed to safeguard
>> against the release of the memory cgroup in get_mem_cgroup_from_folio().
>>
>> This serves as a preparatory measure for the reparenting of the
>> LRU pages.
>>
>> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
>> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
>> ---
> 
> This patch looks correct to me, so:
> Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
> 
> with a few side question on current implementation rather than
> this change...
> 
>>   mm/memcontrol.c | 11 ++++++++---
>>   1 file changed, 8 insertions(+), 3 deletions(-)
>>
>> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
>> index d484b632c790f..1da3ad77054d3 100644
>> --- a/mm/memcontrol.c
>> +++ b/mm/memcontrol.c
>> @@ -973,14 +973,19 @@ struct mem_cgroup *get_mem_cgroup_from_current(void)
>>    */
>>   struct mem_cgroup *get_mem_cgroup_from_folio(struct folio *folio)
>>   {
>> -	struct mem_cgroup *memcg = folio_memcg(folio);
>> +	struct mem_cgroup *memcg;
>>   
>>   	if (mem_cgroup_disabled())
>>   		return NULL;
>>   
>> +	if (!folio_memcg_charged(folio))
>> +		return root_mem_cgroup;
>> +
>>   	rcu_read_lock();
>> -	if (!memcg || WARN_ON_ONCE(!css_tryget(&memcg->css)))
> 
> I have no idea why we're already calling rcu_read_lock() when a folio pins
> the memcg :)

+1, this was introduced by 
https://github.com/torvalds/linux/commit/f77f0c7514789577125c1b2df145703161736359,
may be some defensive programming.

> 
>> -		memcg = root_mem_cgroup;
>> +retry:
>> +	memcg = folio_memcg(folio);
>> +	if (unlikely(!css_tryget(&memcg->css)))
>> +		goto retry;
>>   	rcu_read_unlock();
>>   	return memcg;
>>   }
>> -- 
>> 2.20.1
> 


