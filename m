Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 33998E7AD41
	for <linux-mm@archiver.kernel.org>; Thu, 25 Dec 2025 08:18:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 876396B0088; Thu, 25 Dec 2025 03:18:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 823DC6B0089; Thu, 25 Dec 2025 03:18:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 706046B008A; Thu, 25 Dec 2025 03:18:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 5DCE56B0088
	for <linux-mm@kvack.org>; Thu, 25 Dec 2025 03:18:21 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E99A28B9C2
	for <linux-mm@kvack.org>; Thu, 25 Dec 2025 08:18:20 +0000 (UTC)
X-FDA: 84257291160.16.498A7AE
Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.5])
	by imf14.hostedemail.com (Postfix) with ESMTP id 2F712100002
	for <linux-mm@kvack.org>; Thu, 25 Dec 2025 08:18:17 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=NwGLlF6y;
	spf=pass (imf14.hostedemail.com: domain of ranxiaokai627@163.com designates 220.197.31.5 as permitted sender) smtp.mailfrom=ranxiaokai627@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766650699;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iZsYXZc7P6CajHZu/iuSCPVYtaydN+4wb+jdPPWqApU=;
	b=HPvNaWI6vwYFpN8Df9aIQIsh6vfz104BZ41klrZDQt86dHQPzyga4n3zrxazUPua7jN06n
	nr6T9jvsPc/f6cBUvK4oQZEOHbH60dUiuPG+pv1uXSq2XYszlz2mV83L0Xc4ILj5L1Lodi
	BHGi6CsvmFd4FmseQBenOlsqYlQPptY=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=NwGLlF6y;
	spf=pass (imf14.hostedemail.com: domain of ranxiaokai627@163.com designates 220.197.31.5 as permitted sender) smtp.mailfrom=ranxiaokai627@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766650699; a=rsa-sha256;
	cv=none;
	b=nEvRVK9m1sSC/bhml3Kxrkc62FRiM4xKratQaaU7edSHNd6CGVpk0DWb+8ulhniBwK2Pol
	ho/A3VKNX5FEl4JTweDmSmb7SdL41Th3nLrjeByva9DbpmsEYlEVzFGyxs61GfA6lt+lX0
	D/wxcfijTSe6eVHzV+2DRZ94UY87TMs=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version:
	Content-Type; bh=iZsYXZc7P6CajHZu/iuSCPVYtaydN+4wb+jdPPWqApU=;
	b=NwGLlF6ytLPWN+aZoK6Veg+gpxIfH4d6N2k1TzGR+8tA8Xx31U3kpmc8hBx68k
	FPntcCrCukNmfdtemTOuN0cyVujPDHiUP+e7Gd3H7qaXCC/SuKncHTyr3WCPGuld
	SCnmxB6wrUT4CN4Y0/lzcNOvIRkAMaht+BfwaDJnnauis=
Received: from ubuntu24-z.. (unknown [])
	by gzga-smtp-mtada-g1-4 (Coremail) with SMTP id _____wCHVLcx80xpZ5d0CQ--.345S2;
	Thu, 25 Dec 2025 16:17:54 +0800 (CST)
From: ranxiaokai627@163.com
To: david@kernel.org
Cc: akpm@linux-foundation.org,
	hannes@cmpxchg.org,
	jackmanb@google.com,
	linux-mm@kvack.org,
	luizcap@redhat.com,
	mhocko@suse.com,
	ran.xiaokai@zte.com.cn,
	ranxiaokai627@163.com,
	surenb@google.com,
	vbabka@suse.cz,
	ziy@nvidia.com
Subject: Re: [PATCH] mm/page_owner: fix prematurely released rcu_read_lock()
Date: Thu, 25 Dec 2025 08:17:43 +0000
Message-ID: <20251225081753.142479-1-ranxiaokai627@163.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <c6b766bf-0f05-47c3-bcc6-2f0e1961a864@kernel.org>
References: <c6b766bf-0f05-47c3-bcc6-2f0e1961a864@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=y
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wCHVLcx80xpZ5d0CQ--.345S2
X-Coremail-Antispam: 1Uf129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7v73
	VFW2AGmfu7bjvjm3AaLaJ3UbIYCTnIWIevJa73UjIFyTuYvjfU54E_UUUUU
X-Originating-IP: [117.176.243.82]
X-CM-SenderInfo: xudq5x5drntxqwsxqiywtou0bp/xtbCxhN2wmlM8zMmAwAA3h
X-Stat-Signature: 57xzcshu8arwixih4d4njghttj1fxs73
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 2F712100002
X-HE-Tag: 1766650697-675864
X-HE-Meta: U2FsdGVkX19CXdCClFciALIUXiykIbydLQS8zpyqKGCG6W2P8KTPX54A55sALFAt+w7yE+sljNAscN97YtLSKT82Igf99gII1Uu3e5FEvynYFFqpHiGbEUxfMttGctKqCQJ9yeTRYqzPjFo3S7g2uJ1Tahx5YasC8GlnHYpMVnABfCCFisvtQL1RXUjJuM3ntRVYXjPWFIyRDR3TExHSdHbKQetDbIV+/UumRr7o7vWR94HPOuv3c8UKuc585nHSttb7fykA8NHLDIA9pQFlfd4tiDJcS/H+RnwZyVIX97+zrW9WKr5Ax1wUxTZF2117J16FvzXUIMjICfWmakwF/Of7xu/AxUZJA36rWMsj96mKmykLPMmpjOthvNJJKI9DOmDqQowROWTBKjhQnzq2QRjVG+Ha5clmQ/Y+cDZbjrkrrYm7C+OQ4f+4ofrEIv3iqr03dxjRaR5ebIN6LLKHMmABJzXfh3QWnzVaU7dgJ9z6Xp0U6zQ0uj3dFLwAKdLQvfKBV8Ae3UyGxy4rzxW6KWpQWyjs9t63VFKn2cptU2O77b8gr7A4FRfF00wNTTjjw/wnGcmrelHy5M8eDwMnBlxC7qUm3Ho2ibqHmpWqSkU+TggAD/BxpPM92Oz4LN8Jb1CnoBYaLpBXWPLONJXG4IX85MzC2YMCf0qup4BdAwP8UPjWW0naxk0ygsVvJThfdj7FaqXYQo/zqOxQiHXrOHyLxFOjIvoYm26FLLAbNGe3pXWB9NRPAMcVoaBe5dUSo1JOiFKdUHyt7SAUmP389ka9REVDnc0LkrqkxDjh1UejiEb7+4Q7jF+xCL9mnvQ7QEheOejIvL2dXYFDEonN7Lp6srpN1txZK3wHz/pXtnTPq84OG7Uw/LCRp5zQUwVtICBSSa1Hkp8XtH3drNa5UqVFZ8mqaMvMTaoknD0dKrymQhyeh/S9NLWaRgTD7DSJ5e0FAPBAcSc4x7lREcY
 rxSCsgmj
 XtOpRP/Oj7BE/v5Dloh57F3DkD5XqWkkc1AuLOWPIUh9sKn6pl3ZyRjhA5H446SfVvCZgkSNe1EHLWT1rFWbUd8/D7CXASaaUYMdYUtvx6MX+PV0JftsHWOwfGQgKlC7Z2nMdL27HEXmG4H0fh5rB8eL+6wP2YJaNpnhzA00GcGUQ/yweumf4n0LT8ZguNySblyfNwCrsZ/oWe0BQvsh3kOHlO4+h287oDGMwMlnGwjigaXLZsAWELXRP34F/itdfhDoHYKwPqbhMTgCdri8cfxQ/fwc24+2id2RpPariW/pU2oJC2xviGlFWGdiYA/396hYOwQDrt3jjwGWIYYYoNZZmTJkILBaKSVDWAsCHzmydHwZZncfkKEeWKK670YmunI7SI5WvCm44bJTsawmdSEmWX+E4Kban9Ki5TZzSMV5GbD+9zE4q2grWcy1hXmvtau8x1K2qTeW9DIpxZJTRRZa+AkOV+yeVainR3LTF3eu4g7Weo+pqsJYO+Dq06+VPHEbA
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi, David

>On 12/23/25 10:25, ranxiaokai627@163.com wrote:
>> From: Ran Xiaokai <ran.xiaokai@zte.com.cn>
>> --- a/mm/page_owner.c
>> +++ b/mm/page_owner.c
>> @@ -375,24 +375,25 @@ void __split_page_owner(struct page *page, int old_order, int new_order)
>>   void __folio_copy_owner(struct folio *newfolio, struct folio *old)
>>   {
>>   	struct page_ext *page_ext;
>> +	struct page_ext *old_page_ext, *new_page_ext;
>>   	struct page_ext_iter iter;
>>   	struct page_owner *old_page_owner;
>>   	struct page_owner *new_page_owner;
>>   	depot_stack_handle_t migrate_handle;
>>   
>> -	page_ext = page_ext_get(&old->page);
>> -	if (unlikely(!page_ext))
>> +	old_page_ext = page_ext_get(&old->page);
>> +	if (unlikely(!old_page_ext))
>>   		return;
>>   
>> -	old_page_owner = get_page_owner(page_ext);
>> -	page_ext_put(page_ext);
>> +	old_page_owner = get_page_owner(old_page_ext);
>>   
>> -	page_ext = page_ext_get(&newfolio->page);
>> -	if (unlikely(!page_ext))
>> +	new_page_ext = page_ext_get(&newfolio->page);
>> +	if (unlikely(!new_page_ext)) {
>> +		page_ext_put(old_page_ext);
>>   		return;
>> +	}
>>   
>> -	new_page_owner = get_page_owner(page_ext);
>> -	page_ext_put(page_ext);
>> +	new_page_owner = get_page_owner(new_page_ext);
>>   
>>   	migrate_handle = new_page_owner->handle;
>>   	__update_page_owner_handle(&newfolio->page, old_page_owner->handle,
>> @@ -414,12 +415,12 @@ void __folio_copy_owner(struct folio *newfolio, struct folio *old)
>>   	 * for the new one and the old folio otherwise there will be an imbalance
>>   	 * when subtracting those pages from the stack.
>>   	 */
>> -	rcu_read_lock();
>>   	for_each_page_ext(&old->page, 1 << new_page_owner->order, page_ext, iter) {
>>   		old_page_owner = get_page_owner(page_ext);
>>   		old_page_owner->handle = migrate_handle;
>>   	}
>> -	rcu_read_unlock();
>> +	page_ext_put(new_page_ext);
>> +	page_ext_put(old_page_ext);
>>   }
>
>How are you possibly able to call into __split_page_owner() while 
>concurrently we are already finished with offlining the memory (-> all 
>memory freed and isolated in the buddy) and triggering the notifier?

This patch does not involve __split_page_owner() – did you perhaps
mean __folio_copy_owner()?

You are right: when memory_notify(MEM_OFFLINE, &mem_arg)
is called, memory hot-remove has already completed.
At this stage, all memory in the mem_section has been fully freed
and removed from zone->free_area[], making them impossible
to be allocated.

Currently, only read_page_owner() and pagetypeinfo_showmixedcount_print()
genuinely require RCU locks to handle concurrency with MEM_OFFLINE events.
This is because during traversal of page frames across the system/zone,
we cannot pre-determine the hotplug/remove state of these PFNs.
In other functions, RCU locks are merely used to satisfy the assertion
WARN_ON_ONCE(!rcu_read_lock_held()) within lookup_page_ext(). right ?

Regarding page_ext, I have a question: Semantically, page_ext should
correspond to one structure per folio, not per 4K base page. In x86_64,
page_ext consumes 88 bytes—more memory than struct page itself.
As mTHP adoption grows, avoiding page owner metadata setup/cleanup
for tail pages would yield performance gains.
Moreover, with folio gradually replacing struct page, will struct page
eventually be superseded by dynamically allocated all kinds of memdesc_xxx_t?

If so, wouldn’t it be more reasonable to dynamically allocate a
corresponding page_ext structure after folio allocation?
While this would introduce overhead on the
memory allocation hotpath, I believe we could optimize it—perhaps
by allocating multiple page frames at once to store page_ext structures,
or by establishing a dedicated kmem_cache for page_ext.

What are your suggestions regarding this approach of
dynamically allocating page_ext structures?

>Doesn't make sense, no?


