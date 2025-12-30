Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DA872EE49B4
	for <linux-mm@archiver.kernel.org>; Tue, 30 Dec 2025 20:45:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 008B06B0088; Tue, 30 Dec 2025 15:45:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EF9726B0089; Tue, 30 Dec 2025 15:45:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E046B6B008A; Tue, 30 Dec 2025 15:45:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id CE0E06B0088
	for <linux-mm@kvack.org>; Tue, 30 Dec 2025 15:45:51 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 643A2B8622
	for <linux-mm@kvack.org>; Tue, 30 Dec 2025 20:45:51 +0000 (UTC)
X-FDA: 84277318902.25.D12CFF7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 90B00C0007
	for <linux-mm@kvack.org>; Tue, 30 Dec 2025 20:45:49 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=N4RsNigq;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767127549; a=rsa-sha256;
	cv=none;
	b=F0bqt2sZNnNH1iF1iTkmSWx+XXZt4+nX/EvkQ0uV3pcuoAL14+ky8u5j27Ec6euDh/xztR
	k/aWoMwYI50g5y/PaMt+Qp+hKeW22H57JBLBCcFgD6WimvgY3K5tPXcLmLRRmH68uEsQVa
	jzNUIxAAuipE24SQu4lGYNY3lzf7LHQ=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=N4RsNigq;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767127549;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=klxCa0pdzPEQYO9Sq/Y3W7OnpSSPcEK30qEOnatjHMQ=;
	b=eBnc8wKAzpIjEiMylKiDP84emtkNNHwMAzlre2hnFEJ5HWezttqbXDCpRyZUZm3jrlNnGO
	L/97P/8rJnpI4fn5ulZpapaxNYlCZ4JZUTXwIDm5FEDFVSAxTvs50WNXldCCbxw1cL+/kn
	fn8fX+0amFJodKRXiBUveajoLKLN1zQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id A274540818;
	Tue, 30 Dec 2025 20:45:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9ACD4C4CEFB;
	Tue, 30 Dec 2025 20:45:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767127548;
	bh=UZsxGvZ+4JAWjJhxgm5CHH5Xv2jjLHsLwK/ptj39AjQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=N4RsNigqIpyrHvH2Go7d/fXUTzZzeV6odSQlpMtwHY0z5xEoc8wvjYjBKz7IrskKr
	 NC1XBEHHyv2g/IKEJqxf6kzLy3bfpCchtfaVO4VPWuPYuSr1Cse36m5n6Q8q6O5uW6
	 mt/0jOWFt3El80n51SmcP9r9/4ccMKkHjUXmZVIsUsLIGlWL1cWWk186Rdg+K0VebG
	 Z9fypQ+PBbTxDwWj2OusHsilY31ecdTz3ihJkKyvJ0NdBUvrAnqp48/tRk67GzCO7U
	 BN4q8DHAh05IztgwMOl2xLvLzmZ/xsxvRyq3eAeG90iQ2nsBNQdGwqQO59bKluPuzm
	 xgT7OueLoY5Mw==
Message-ID: <530cf16c-ce1b-4ec7-b76e-23b184965501@kernel.org>
Date: Tue, 30 Dec 2025 21:45:42 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/page_owner: fix prematurely released rcu_read_lock()
To: ranxiaokai627@163.com
Cc: akpm@linux-foundation.org, hannes@cmpxchg.org, jackmanb@google.com,
 linux-mm@kvack.org, luizcap@redhat.com, mhocko@suse.com,
 ran.xiaokai@zte.com.cn, surenb@google.com, vbabka@suse.cz, ziy@nvidia.com
References: <c6b766bf-0f05-47c3-bcc6-2f0e1961a864@kernel.org>
 <20251225081753.142479-1-ranxiaokai627@163.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <20251225081753.142479-1-ranxiaokai627@163.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 90B00C0007
X-Stat-Signature: j9muoq1juhgks3fw3gur6yg6ycikcpbu
X-Rspam-User: 
X-HE-Tag: 1767127549-239249
X-HE-Meta: U2FsdGVkX18wpZuS7xCRsSHBjvOQAKrr+KFTpqqKhldaG9200HnJcWwKQSS0Bf4MtKztfs7vAlI7do9yo6C7QHebca9poobQQij3FkauaNv1sbqObOM8gYmJomupTYz7n9L7MtGE7H4sl7DG2Uf5BFPCY7Hq+Zw7YD3nlZEHnxpF63NQaEXP4u3mqIgaK29RVVU/+6H71fwLDLYiXZWKQP8VVsuDQeL013p7kZn74NRy2ezQNyjyggXevAFnMOGGGXtwae/v50E2X07bt0HjbWKWbeOHWwL19lYQkSkLfuVO0veuIlZAyIaboya0kOV7YOQUXQtLvpKhr4nH5g97Qz3Mo2eSe/ytAbDpo7msCfFZRYL/PwpJ2jbwCChTdDUuVjNutNrOO6SOnZmCn14r47NCHJ/mA7nosoVatP5CTYGqb22vMDVIBCmPRN03gUgSvo2jDuDA2JZGWpdSV7+kEum/Ct1BxWt8hdAvgGf5MWt9cgpd7/+acHk3S2ithFCK8ncgmevB+S7VQ1K36cLmy0XVjdZMbdzaP6CKnJWWUU1awMrObvwWQPD98MUTz4bvPWeKUqq1sKiuBLjgEozhINyTbsupaGjnV2Ey1Hvx7lW3lAySbyoCUMuDMDZ/4CTXcibh+XmL2HxaXfUgafT+mWxdkk4IZUpG26q5RNbwLwl1YMduub9THOzJHp2ZAu1LrhjZ7YpD+DguxAGdr4w4h41N3n1JaTVGqlrpStpzqXd7+N+9SB9oLHJyMyEc5feuVgRwLlmICGMGuQdErVDAhC3YL/jHPfn3bw037ls5PSl62mem50UlgUxyFHlC8uOm8nIYNFD9DP1EvNz3JOiYbRaHTwYmiQAalrvwwbehqR+leTfg07XGOticYae4eYZ5Hljd7skHvtPHhdvLExoyLdewc/6RvOs0zaLsq9GyQmsXiewck83S9CiDvRoKX6uAlGsymlhOMAJFbbbcvT6
 96SpiKgZ
 yuS1lDAIHCBdOcW+ajS3av+6xAKNlq63pghAVBWYqEx0bbr1hoFC14kChMvZM+XR64SX32Vz2z1Cb2ibxG+5TxdvO4d3AIl7FIXNkXjuuW1knhsm1iGCWHfBybB583MraUAzUIyXQjEcw8hcosXunaeu7XXBI3cEq0JvKI9+qGsYPWQqhuszzLf6AI0E7AQYJeLQroSQl8tC26k6JxBgQNmUcS+t+e09DIQbsKf6NGl6G+NNA3zapTUv3F6ZelIrM2dUwHyRBDauPLgO41aiG631Pcx+0M4qFTMvz/cECIFcd1WXmUKI6c6iG3OoNnRAGL7dOLs7CNQ3ss0mGARGZkukqtYWIEUqsEqtswinIMU1/29ZFPwlxaJAAoj7aQ7+y9cHbIHDn+Ccpgn5HSG8O6MUormkMHk/iS6VQ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/25/25 09:17, ranxiaokai627@163.com wrote:
> Hi, David
> 
>> On 12/23/25 10:25, ranxiaokai627@163.com wrote:
>>> From: Ran Xiaokai <ran.xiaokai@zte.com.cn>
>>> --- a/mm/page_owner.c
>>> +++ b/mm/page_owner.c
>>> @@ -375,24 +375,25 @@ void __split_page_owner(struct page *page, int old_order, int new_order)
>>>    void __folio_copy_owner(struct folio *newfolio, struct folio *old)
>>>    {
>>>    	struct page_ext *page_ext;
>>> +	struct page_ext *old_page_ext, *new_page_ext;
>>>    	struct page_ext_iter iter;
>>>    	struct page_owner *old_page_owner;
>>>    	struct page_owner *new_page_owner;
>>>    	depot_stack_handle_t migrate_handle;
>>>    
>>> -	page_ext = page_ext_get(&old->page);
>>> -	if (unlikely(!page_ext))
>>> +	old_page_ext = page_ext_get(&old->page);
>>> +	if (unlikely(!old_page_ext))
>>>    		return;
>>>    
>>> -	old_page_owner = get_page_owner(page_ext);
>>> -	page_ext_put(page_ext);
>>> +	old_page_owner = get_page_owner(old_page_ext);
>>>    
>>> -	page_ext = page_ext_get(&newfolio->page);
>>> -	if (unlikely(!page_ext))
>>> +	new_page_ext = page_ext_get(&newfolio->page);
>>> +	if (unlikely(!new_page_ext)) {
>>> +		page_ext_put(old_page_ext);
>>>    		return;
>>> +	}
>>>    
>>> -	new_page_owner = get_page_owner(page_ext);
>>> -	page_ext_put(page_ext);
>>> +	new_page_owner = get_page_owner(new_page_ext);
>>>    
>>>    	migrate_handle = new_page_owner->handle;
>>>    	__update_page_owner_handle(&newfolio->page, old_page_owner->handle,
>>> @@ -414,12 +415,12 @@ void __folio_copy_owner(struct folio *newfolio, struct folio *old)
>>>    	 * for the new one and the old folio otherwise there will be an imbalance
>>>    	 * when subtracting those pages from the stack.
>>>    	 */
>>> -	rcu_read_lock();
>>>    	for_each_page_ext(&old->page, 1 << new_page_owner->order, page_ext, iter) {
>>>    		old_page_owner = get_page_owner(page_ext);
>>>    		old_page_owner->handle = migrate_handle;
>>>    	}
>>> -	rcu_read_unlock();
>>> +	page_ext_put(new_page_ext);
>>> +	page_ext_put(old_page_ext);
>>>    }
>>
>> How are you possibly able to call into __split_page_owner() while
>> concurrently we are already finished with offlining the memory (-> all
>> memory freed and isolated in the buddy) and triggering the notifier?
> 
> This patch does not involve __split_page_owner() – did you perhaps
> mean __folio_copy_owner()?

Yes, any kind of folio operation.

Once memory is offline any operation on the page/folio itself would 
already be fatal.

So if we would ever reach this code while memory is already offline we 
would be having a bad time, even without any page_ext magic.

> 
> You are right: when memory_notify(MEM_OFFLINE, &mem_arg)
> is called, memory hot-remove has already completed.
> At this stage, all memory in the mem_section has been fully freed
> and removed from zone->free_area[], making them impossible
> to be allocated.
> 
> Currently, only read_page_owner() and pagetypeinfo_showmixedcount_print()
> genuinely require RCU locks to handle concurrency with MEM_OFFLINE events.
> This is because during traversal of page frames across the system/zone,
> we cannot pre-determine the hotplug/remove state of these PFNs.
> In other functions, RCU locks are merely used to satisfy the assertion
> WARN_ON_ONCE(!rcu_read_lock_held()) within lookup_page_ext(). right ?

Exactly.

> 
> Regarding page_ext, I have a question: Semantically, page_ext should
> correspond to one structure per folio, not per 4K base page. In x86_64,
> page_ext consumes 88 bytes—more memory than struct page itself.
> As mTHP adoption grows, avoiding page owner metadata setup/cleanup
> for tail pages would yield performance gains.
> Moreover, with folio gradually replacing struct page, will struct page
> eventually be superseded by dynamically allocated all kinds of memdesc_xxx_t?
> 
> If so, wouldn’t it be more reasonable to dynamically allocate a
> corresponding page_ext structure after folio allocation?

Most (but not all ...) page_ext data will be per folio, yes. Some is per 
allocation (which might not be a folio in the future ...), which is 
where it gets tricky.

But yes, Willy already thought about simply placing some of the page_ext 
stuff into "struct folio" once we dynamically allocate "struct folio".

The question is how we will handle this for other allocations that will 
not be folios (e.g., where to store page owner).

-- 
Cheers

David

