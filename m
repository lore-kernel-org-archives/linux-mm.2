Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D7C97CED617
	for <linux-mm@archiver.kernel.org>; Tue, 18 Nov 2025 11:32:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0DC216B0031; Tue, 18 Nov 2025 06:32:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 08C7F6B007B; Tue, 18 Nov 2025 06:32:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EBD1D6B008A; Tue, 18 Nov 2025 06:32:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D82CF6B0031
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 06:32:17 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 0714916052F
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 11:32:17 +0000 (UTC)
X-FDA: 84123514314.07.A287226
Received: from out-188.mta1.migadu.com (out-188.mta1.migadu.com [95.215.58.188])
	by imf07.hostedemail.com (Postfix) with ESMTP id 1547040014
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 11:32:14 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="Dg6bJIB/";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf07.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.188 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763465535; a=rsa-sha256;
	cv=none;
	b=1cc9oUidi7JmzcJqlkYgZSarIZxWtKAMAXjWXx6oWSspRE4ymE3hxp3KOGeHfcDpv/1BU4
	upgn1o8wgiHwZUOCHrDjchxgaMPI0ibFYrnfD66Wx+nJfAmxoiWX+nQwLDoYAgwxURb8gk
	+UnsQj63jnlZIk6+eH/ArdI/IPO+zO0=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="Dg6bJIB/";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf07.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.188 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763465535;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IHki3f3cNtOnM09ovZSWhqC7IqaJsYo0WZIJZZw+RVU=;
	b=WGU5hiZewXgA+P6sWkfDQn7EqGbcker6PGZrff+qWX/k0WyfFn5DgNAZRrb4VAeRxeHg87
	SfhnYaF3yf+myrbmCxZrhFg92sDLER1ktQVtyyDT6e4vgkgxnh0mHMX5qkmDsf0NcmKs8W
	rc92x0CZb4R1b2JiJ1cdQtzQXF76x0k=
Message-ID: <17ce88c0-a5d5-4315-8074-6c0a4a4e7d64@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1763465532;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=IHki3f3cNtOnM09ovZSWhqC7IqaJsYo0WZIJZZw+RVU=;
	b=Dg6bJIB/vHPh4AVUVfpV8FwbbcIyFe4Xwg9nIM5+YFjnpsAyXDBARc+5rkdZn1e4fXNptU
	qdr+a8+t8ycFjPbfMfgPznhx+/KDzp4xgB//bQbPiiGNoxrowBo6Cz77wMcSTbdjyVcUdO
	l+Tw+0GrJLPlGpjHEHBe3/wqcra2+Kk=
Date: Tue, 18 Nov 2025 19:31:01 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v1 06/26] mm: memcontrol: return root object cgroup for
 root memory cgroup
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
 <5e9743f291e7ca7b8f052775e993090ed66cfa80.1761658310.git.zhengqi.arch@bytedance.com>
 <aRroO9ypxvHsAjug@hyeyoo> <aRrttY5kdbbubmGs@hyeyoo>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <aRrttY5kdbbubmGs@hyeyoo>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 1547040014
X-Stat-Signature: ic5xa1g1xpgxgkhpzr3r4ij6dycgyfft
X-HE-Tag: 1763465534-431989
X-HE-Meta: U2FsdGVkX1/SETvQWqg9ZfYLQGM4ncgY159wr+cknhSdbPaplUNSib3WxbE2ImwU39L4aQzBFXkyrmTDeMSpepSNEAC49M/UqNXZhBjWyi0XHHdTAaAvmcWmjzGoqB3zeTVyjhyXxTb+EZ4O+THSWG3fiH65AOJ9Iqnf46aiDm2x2DxZn9IdAKX7E5OqxV8cTND1qApjqHylXuBlskldYaUyaWksMXtqEv6eowh+qq3byuAdSlara01QqqLiXCmc/6TWFrbzpA9emoHZKGyts2DDUkCKXudbMWhYEnor8glaL4xMQFvGKCf3bMIMoP8nlk9nClphxA0l8F5XtLMXQ+2iw0MqzkGfoYnFEJssSHsb1bMi6emthIa8t+w3IbOfWmYrR4LvN5/GTF6ov0i4VQhylOBKn4uamR6YyImgS2bY+h2vm1eG/CAcZ98A9Mv2iUMwzWsXAnL8UBGRqk421mmuRNwR0hmZejjGGicXAEB16QI6ZGmsnq0SbZqcSdsNpyFEkR5Q6bsJxWxQ7g1VojYGSsSvY1TnzZTFboDNaokLWyMeQ/8tb8pOImBupIz6ZtdAPvqddaUMr8cMQg4g0+sbix4m9BfoQztm4PKoyzL4h8Kxv+gOZrjvOBWK4ON/MY1he3wTR2ZvVtSPLrofCb8r5dlRjeWjCXULE1/j8mQDSn2PTQirLEHmnVhMZvLx1RhC1vzEzOZHqFrPXE8X9RuHOkh1h6Nnw1NfVXkYb8PVyvlv3MEWez6uXbqgEpXcf/z4VYwVVe5QH0dOX6c2danAgfrMRk5XwRTGH7luW+60To66d+MLQKLN1CtIkCLeJbnUBRoNfXFuRkX9YtsHF1kL7Wg2Xbrm7rZClJ2xT7C0nD0kn34cW8+NghwrNvHoy3tTXULQBiLSO3z9/AMSvOaFWeRbsvtlUHDIZTgNN1iDIqqHWBeCm/kWv5CC0wDLaR7qjszYpcciGGgA27z
 FHpmAYjx
 /t59cspSXDeZjL4DA1sMvbD2cnsX6No9eeXFDyGsPbIoj1lp5Yd8Gc1yT2egw3aHVLVqozLgIhl4Id91p3r0DAA6AahUffCQn9i9heV1AXOWs3mXvCviGSfHY008U0Tjdqn8uwgdJ6MP5NOggoEAb7qsEo2tTlmoZYbmquEYXPnfW2vu3aQIKybVBz5O7zc7XkeUjeZHQWS86LiaxIuOwEO4/ZeWCLlSJvCl+XKKBjx4htgo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 11/17/25 5:41 PM, Harry Yoo wrote:
> On Mon, Nov 17, 2025 at 06:17:47PM +0900, Harry Yoo wrote:
>> On Tue, Oct 28, 2025 at 09:58:19PM +0800, Qi Zheng wrote:
>>> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
>>> index 2afd7f99ca101..d484b632c790f 100644
>>> --- a/mm/memcontrol.c
>>> +++ b/mm/memcontrol.c
>>> @@ -2871,7 +2865,7 @@ int __memcg_kmem_charge_page(struct page *page, gfp_t gfp, int order)
>>>   	int ret = 0;
>>>   
>>>   	objcg = current_obj_cgroup();
>>> -	if (objcg) {
>>> +	if (!obj_cgroup_is_root(objcg)) {
>>
>> Now that we support the page and slab allocators support allocating memory
>> in NMI contexts (on some archs), current_obj_cgroup() can return NULL
>> if (IS_ENABLED(CONFIG_MEMCG_NMI_UNSAFE) && in_nmi()) returns true
>> (then it leads to a NULL-pointer-deref bug).
> 
> This is a real issue, but
> 
>> But IIUC this is applied to kmem charging only (as they use this_cpu ops
>> for stats update), and we don't have to apply the same restriction to
>> charging LRU pages with objcg.
> 
> actually this should be fine for now since we use get_mem_cgroup_from_mm()
> and obj_cgroup_from_memcg() instead of current_obj_cgroup() when charging
> LRU pages.
> 
> But it is not immediately obvious that there are multiple ways to get
> an objcg, each with different restrictions depending on what you are
> going to charge :/

Perhaps some comments need to be added. :)

> 
>> Maybe Shakeel has more insight on this.
>>
>> Link: https://lore.kernel.org/all/20250519063142.111219-1-shakeel.butt@linux.dev
> 


