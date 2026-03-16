Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D127AD58B09
	for <linux-mm@archiver.kernel.org>; Mon, 16 Mar 2026 03:47:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4304B6B0104; Sun, 15 Mar 2026 23:47:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 405296B0105; Sun, 15 Mar 2026 23:47:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 331A26B0106; Sun, 15 Mar 2026 23:47:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1F0786B0104
	for <linux-mm@kvack.org>; Sun, 15 Mar 2026 23:47:47 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id AE841BD445
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 03:47:46 +0000 (UTC)
X-FDA: 84550542132.18.58EE97C
Received: from out-181.mta1.migadu.com (out-181.mta1.migadu.com [95.215.58.181])
	by imf12.hostedemail.com (Postfix) with ESMTP id 0FF3C40007
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 03:47:42 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=CqdAeQ8x;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf12.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.181 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773632865;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BC/9VRvnBx2Fbj7AWhZPfEGKyE+15so5XBYMY8jq8jw=;
	b=JzgYL012up5ZKNwEYXYL8cVmlQ71XgUwKLlH0+uxn23O2NqsT+whGHQl8iH9cJ+tbCPPsA
	v55cNgNxy7zKSNbQVELAg8TPL/uC9oj4aGdqRissCC1P5h/Z8mOq0dXFzEijKsyJHCpIUQ
	uaCH+5rdRDUNf16HAAkNU2jSeaGPP1Y=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=CqdAeQ8x;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf12.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.181 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773632865; a=rsa-sha256;
	cv=none;
	b=XaKbpJ1D8HAEz7Db4mf6zKk6DmNOkpthoTwgj11eS92h1Myu0qN0apDC20l/B3h7m/uJ4x
	fiMXrFNBec/QC0S7ev0RgpLc1SJYEaH1/mYkXibBgFLg7/l73er6+Sc15eoYaJmR1cmCuH
	FjUU7rp/7cY4eZFJXab94AJdl+QqnV8=
Message-ID: <d07a0787-dd00-402c-b8bd-3a6380608c0d@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1773632859;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=BC/9VRvnBx2Fbj7AWhZPfEGKyE+15so5XBYMY8jq8jw=;
	b=CqdAeQ8xg8xe5XJljnNCPre7futB6K0k00xwmOjFkgULmZSHb4opCfSw2vsPa5wzqNXcWO
	fzFYYPFQ/K3WUWO6OY3euHKDMdSWVovLrYZEHR1esnICG4oK6qmP5mqeRgiuCt1q4tsrG1
	NU7ZpkPh03uzkBJfquOm246sapaN1/8=
Date: Mon, 16 Mar 2026 11:47:06 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v6 30/33] mm: memcontrol: prepare for reparenting
 non-hierarchical stats
To: =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>
Cc: hannes@cmpxchg.org, hughd@google.com, mhocko@suse.com,
 roman.gushchin@linux.dev, shakeel.butt@linux.dev, muchun.song@linux.dev,
 david@kernel.org, lorenzo.stoakes@oracle.com, ziy@nvidia.com,
 harry.yoo@oracle.com, yosry.ahmed@linux.dev, imran.f.khan@oracle.com,
 kamalesh.babulal@oracle.com, axelrasmussen@google.com, yuanchu@google.com,
 weixugc@google.com, chenridong@huaweicloud.com, akpm@linux-foundation.org,
 hamzamahfooz@linux.microsoft.com, apais@linux.microsoft.com,
 lance.yang@linux.dev, bhe@redhat.com, usamaarif642@gmail.com,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
 Qi Zheng <zhengqi.arch@bytedance.com>, Yosry Ahmed <yosry@kernel.org>
References: <cover.1772711148.git.zhengqi.arch@bytedance.com>
 <e862995c45a7101a541284b6ebee5e5c32c89066.1772711148.git.zhengqi.arch@bytedance.com>
 <hwcqvplnn2knclpivgagctmcaiutyv2qprgoqmwp7suzj6fqb2@diq6grkwo33b>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <hwcqvplnn2knclpivgagctmcaiutyv2qprgoqmwp7suzj6fqb2@diq6grkwo33b>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 0FF3C40007
X-Stat-Signature: reptp6t76yw1sidac8fc6ho8egb6pogj
X-Rspam-User: 
X-HE-Tag: 1773632862-45421
X-HE-Meta: U2FsdGVkX1+nKNZptCovuYHlpm17alPuMPwmYFk2QQtznZigdadGsmJcLoz6HIpR2zwrNHdLCjA8kC+7HNUHoCZa5V+BItge2RaCyrc/v9MVnw9CHSH3xSgnqu+fO5WmeW6SqcswF7cpbPJtwFO/INmfRQ7IzMmiEbsWUg41wo5CRCgi/dnwEeu/fXuMB5aWKbxIQJ1vbfLofdMP08h+Eh0kwU/1DGvpEHRhqbWMaRuL0fQBUJ6FHbQWsuC7B1FsazmG74c06e7ZQd6kF6L+i6WCrjAmJYewtnpDqQXJQJdTOL9g0xqXtzFHw/u+Q/7xQgddWuh330hUUd+gn68WauOaw+hre+GzmX1LFEU1qdrRHFjW10WqaR1/3YZAz8LYhmT9ojRbk+7auDW4zUqgsxxmPDvCqQQnr4V4zkbg6ocQ2dLvFtfc93rZ+PbaJ9VtO2men4vuvc2D4lVyBJ7iIEYlFyAKiFjX9MU44GTD27v1UoXSvKmvP5tV7F5dZxd0sp22P7ReqEhnTxOPWwZv2zftEL6vQXMY7davHm3nXWevX5t6SPMjwI5EtSiyfmaixMM1gh+iIziyw6aMTLDy76paMGdv6DSXuo2HNxxtPn/sugYsuxRSFyjGwwOFGn5oOFoYsb4qtx3ANJKT9+WJdriPuloSB+VHc00qqDZ90YHo6vw/cacBBAo8kSndyHCAPkahru45FEx98sWTxXHU2PItp+IWU0a140YSLWgPkCoOUUESmculPk5rcLudvTvERqje28JIrPYNhBUfiy3qqEo3HJUVdI+wE6cw3/gkH1ryq3HS/Oxyc14l0aTzuhPOXUjVnQWOtI56JLQXSKy7KZQJg9kUBZNiUo0CdzQ4uQQIRlbXDp+Hzg4Cequ10M52fkP+ubJ5PPpdATlHQwYCjk6RB14XwpJR3kARzQPK2944Sdc+8+CUoEkVdeL41wpB4ym50tvJSfauurEBRdr
 xHuVmm5u
 UunM6VV8shM7uRAQ2YBhyLCRspbfssil1fpdfx3C4a8kv7BER4VSswHZw2BDSdm/NKd81Edo0nDp90x/HSPpaNsDyXighOVPRO2lZicknjBuhxxdBHPLq2v8+TcYJ2mGLSPRv1T5ISlyoNA+cuWV6YwbPy8QF2h8pCn77DbxBZtd52+SW9GmbosYs4s3SBqB09UahWMVsoJQL8o32HAVeqpWjJQkH10ABygVCLKtstak0vXo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Michal,

On 3/14/26 12:22 AM, Michal Koutný wrote:
> Hello Qi.
> 
> On Thu, Mar 05, 2026 at 07:52:48PM +0800, Qi Zheng <qi.zheng@linux.dev> wrote:
>> To ensure that these non-hierarchical stats work properly, we need to
>> reparent these non-hierarchical stats after reparenting LRU folios. To
>> this end, this commit makes the following preparations:
>>
>> 1. implement reparent_state_local() to reparent non-hierarchical stats
>> 2. make css_killed_work_fn() to be called in rcu work, and implement
>>     get_non_dying_memcg_start() and get_non_dying_memcg_end() to avoid race
>>     between mod_memcg_state()/mod_memcg_lruvec_state()
>>     and reparent_state_local()
> 
> 
> css_free_rwork_fn has() already RCU deferal but we discussed some
> reasons why stats reparenting cannot be done from there. IIUC something
> like:
> 
> | reparent_state_local() must be already at css_killed_work_fn() because
> | waiting until css_free_rwork_fn() would mean the non-hierarchical
> | stats of the surrogate ancestor are outdated, e.g. underflown.
> | And the waiting until css_free_rwork_fn() may still be indefinite due
> | to non-folio references to the offlined memcg.

We need to ensure that when reparent_state_local() is called, no writer
modifies the non-hierarchical stats of child memcg, otherwise these
stats modifications may be missed.

In the v3, we used synchronize_rcu() in reparent_state_local() to ensure
this, but this could cause blocking, so in this version we changed to
this asynchronous approach.

> 
> Could this be captured in the commit (if it's correct)?
> 
> 
>> --- a/kernel/cgroup/cgroup.c
>> +++ b/kernel/cgroup/cgroup.c
>> @@ -6044,8 +6044,9 @@ int cgroup_mkdir(struct kernfs_node *parent_kn, const char *name, umode_t mode)
>>    */
>>   static void css_killed_work_fn(struct work_struct *work)
>>   {
>> -	struct cgroup_subsys_state *css =
>> -		container_of(work, struct cgroup_subsys_state, destroy_work);
>> +	struct cgroup_subsys_state *css;
>> +
>> +	css = container_of(to_rcu_work(work), struct cgroup_subsys_state, destroy_rwork);
>>   
>>   	cgroup_lock();
>>   
>> @@ -6066,8 +6067,8 @@ static void css_killed_ref_fn(struct percpu_ref *ref)
>>   		container_of(ref, struct cgroup_subsys_state, refcnt);
>>   
>>   	if (atomic_dec_and_test(&css->online_cnt)) {
>> -		INIT_WORK(&css->destroy_work, css_killed_work_fn);
>> -		queue_work(cgroup_offline_wq, &css->destroy_work);
>> +		INIT_RCU_WORK(&css->destroy_rwork, css_killed_work_fn);
>> +		queue_rcu_work(cgroup_offline_wq, &css->destroy_rwork);
>>   	}
>>   }
>>
> 
> Could this be
> 
> #ifdef CONFIG_MEMCG_V1
> 		/* See get_non_dying_memcg_start, get_non_dying_memcg_end
> 		INIT_RCU_WORK(&css->destroy_rwork, css_killed_work_fn);
> 		queue_rcu_work(cgroup_offline_wq, &css->destroy_rwork);
> #else
> 		INIT_WORK(&css->destroy_work, css_killed_work_fn);
> 		queue_work(cgroup_offline_wq, &css->destroy_work);
> #endif
> 
> ?
> 
> IOW there's no need to make the cgroup release path even more
> asynchronous without CONFIG_MEMCG_V1 (all this seems CONFIG_MEMCG_V1
> specific).

Right. But I'm wondering if it's necessary to use ifdefing, since
asynchronous methods shouldn't cause any significant drawbacks?

> 
> (+not so beautiful css_killed_work_fn ifdefing but given there are the
> variants of _start, _end)
> 
>> +#ifdef CONFIG_MEMCG_V1
>> +/*
>> + * Used in mod_memcg_state() and mod_memcg_lruvec_state() to avoid race with
>> + * reparenting of non-hierarchical state_locals.
>> + */
>> +static inline struct mem_cgroup *get_non_dying_memcg_start(struct mem_cgroup *memcg)
> 
> Nit: I think the idiomatic names are begin + end (in the meaning of
> paired parenthesis, don't look at css_task_iter_start ;-).

Both are fine for me, but changing the name requires changing
[PACTH v6 30/33] and [PACTH v6 32/33], if we need to update to v7,
I can include them.

Thanks,
Qi




