Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EF634D4A5EB
	for <linux-mm@archiver.kernel.org>; Mon, 19 Jan 2026 03:20:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 31E006B00ED; Sun, 18 Jan 2026 22:20:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2F5A76B00EF; Sun, 18 Jan 2026 22:20:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1F8086B00F0; Sun, 18 Jan 2026 22:20:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0DA2A6B00ED
	for <linux-mm@kvack.org>; Sun, 18 Jan 2026 22:20:41 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 88FDFC22CB
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 03:20:40 +0000 (UTC)
X-FDA: 84347261040.15.00E9519
Received: from out-170.mta1.migadu.com (out-170.mta1.migadu.com [95.215.58.170])
	by imf28.hostedemail.com (Postfix) with ESMTP id 903C3C0008
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 03:20:38 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=hdfhqaVd;
	spf=pass (imf28.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.170 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768792839; a=rsa-sha256;
	cv=none;
	b=babP9EljtsoS8b4Ot8zLfVFCOeOnfi/Kc1OcBAEfCHQJ0bXqH6qPgPdjr5Y6MZUb8420Pb
	8OPxmPbTWOO1NZ6FsQgaQuuIXwFqIsuN+oY1i9ZzcfXndAXbtWn1HCTdLGrnDZzUtasOMl
	Sgt464MXTLSpakz0DQTZkj4IBGkj7DE=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=hdfhqaVd;
	spf=pass (imf28.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.170 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768792839;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pd6kZGNbyNYE8tPLcAsqL3zBFM4wIaBCbTnO8h62LzA=;
	b=aeREciNYLVKFhdQZoYxe4WIgepgZU/sQQOn2fhkj207w43gGgLSCoXeebGUm/Sz0CyGExm
	iW6W0yyvUKFf8OdWRU3xKQ1wu5Y6U7LX368YHOUEikGIyzrPh+nvI7AlvmKqkrh8vkJa1C
	5V9fkfcmG1h7zjYRhuQxLFfv5cRvf0k=
Message-ID: <f2b2d0e6-0690-41e5-9718-ef4a1985e50c@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1768792834;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pd6kZGNbyNYE8tPLcAsqL3zBFM4wIaBCbTnO8h62LzA=;
	b=hdfhqaVdUy2hJ5povwHWvJH4g07Wa6Kmf/JVODLiU5Fp9De+Ho7k9WyFuc+U4pD1cqVdLB
	oeu4dSx2lKbMq72W34qHqDZEz/ZdAlRuDR0vJuFNUQR3WpiyyCsiD/7+7Rt73FiwhGNGvI
	yIRlAM+lX63AEX1QPjs39nfRRXxNHvY=
Date: Mon, 19 Jan 2026 11:20:11 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v3 08/30] mm: memcontrol: prevent memory cgroup release in
 get_mem_cgroup_from_folio()
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: hannes@cmpxchg.org, hughd@google.com, mhocko@suse.com,
 roman.gushchin@linux.dev, muchun.song@linux.dev, david@kernel.org,
 lorenzo.stoakes@oracle.com, ziy@nvidia.com, harry.yoo@oracle.com,
 yosry.ahmed@linux.dev, imran.f.khan@oracle.com, kamalesh.babulal@oracle.com,
 axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com,
 chenridong@huaweicloud.com, mkoutny@suse.com, akpm@linux-foundation.org,
 hamzamahfooz@linux.microsoft.com, apais@linux.microsoft.com,
 lance.yang@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 cgroups@vger.kernel.org, Muchun Song <songmuchun@bytedance.com>,
 Qi Zheng <zhengqi.arch@bytedance.com>
References: <cover.1768389889.git.zhengqi.arch@bytedance.com>
 <c5c8eba771ab90d03f4c024c2384b8342ec41452.1768389889.git.zhengqi.arch@bytedance.com>
 <qdfq2vxdma4qnt7pyfvuiyiib6ffuv46jyqsfgab643ihzttb6@h4hodwsqkmom>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <qdfq2vxdma4qnt7pyfvuiyiib6ffuv46jyqsfgab643ihzttb6@h4hodwsqkmom>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 903C3C0008
X-Stat-Signature: aq7yczfoft5tb3af7ji4cycunz1n18yn
X-Rspam-User: 
X-HE-Tag: 1768792838-966295
X-HE-Meta: U2FsdGVkX18rc/b1BD/XIBdtGHD55Pnb+hPCMbLhRzRQQND/Vh4dcgwt+AgzG6jrzdfEkuT+GPubJe+cZ0CtBm5HWUVmRkiBlZ3kZyLqldedGFP67P9G6kBOzuRUXSacoWKlcyIS90Wx7ePd7VJwYi6eIZ+Np4Fh1vHMtRtJX/XumgCBklPSDGlPqhvWBFWBVV5BDBSztksYCOuOEWItFISSbAZwqbnNBcSD0B4kQZtkuwnswQLJlEzdDfa3yDK8sz8HFtLsgB47YcSvwQSHAOFIu2tKL3TNcx5TbKgkH6nfVrzPg9evlO3BbDAEfVIBwu2eIm31ANcOtbTR1u65zLMjqu0NeGhkJQ0cOfdrGooy1YVCQC5cmDRineORLKkURWEN+OMA5in7rrLTLrpBWOHUCdLAvc3VOJMoxAeFYOgYYCu54fpE5VaNnjbAuxpLeVR5hg47YcevvzF8wljJjrUfZ9VgbfI6ortWpsbxMvCljlAPc0bzVapI2ZEAVOYtJuXREc4cAZDyYsJ7ey+KMy5ifTXbtLpetR3n5HJBDziMLDnpElSPD9WnPiorWtdhYQPRCyUd6ZDTzvlecvc1o8lQYl4NVUdJ3EwpK7lRExY8kwbHAL92UtT4NfiQpDaUkxpNGPiQGEEDvIbiPY9nPPCAYpcziZEIgkI0G9eFkyCuSfhmFde0ltQ9AwCLT9SaVAfumwsdFQrjEKAtzp3uQjgoHoL8EgSCByL7ZvVg4ojBDL7tXpN0HOtNYiANW/G5I+w49N1AKzNgaUqLrqv08GsGCUY/wrsKumgoKfZ8i4uj0qembNfA2WeubM7JEun8P+iDacgrjkuUngqM9Z6+2HUe6iSP4DbCRGHdew5QPjuftoS11ENGagzeaL8nEMzAPURfomkA4rCfwRRiM5StkHc2fpTLOUbHCAh6hkZBiRbPYPKTP2rlLkNiPNuxrX+aoAapqQm0qkj8Veat9Yh
 kF9DeEVI
 yMS1mFX6JtoYizzvk0gKRQ22an7bBahq4zmTyWZomo0tGRgvBXSRM8g6yvMrAdPmOqPZnzlj56y3s8zPJ0YNRPByZ3NJQfTnoneHMLPi4ui8eYUKqh6pvvFIupTNPWCDCTef8G6DTJTRAeadtmTAK/uL1KPC5wMHv1C79CE6cn1yYmpJpy0DvYiPJBeCh6qIm0g7P+VCdptpjHsjUisX1CZDiGmAcWQyPxkECFjNYO7Grvb4z4N+CUWsmH9gsmTZhpZtSMbTn2ZURA9/Z3vN4Y9D8cH50c39YWaeL+GEVcwQaf1hcV2lzWP1EMxCvEfjPDL5s58BeMof78MJG9EzDedH40u3oJZpwcpO4bsexrXJDSPI0DXxR6aDYHTS1zkl6rO9/
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 1/18/26 8:31 AM, Shakeel Butt wrote:
> On Wed, Jan 14, 2026 at 07:32:35PM +0800, Qi Zheng wrote:
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
>> Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
>> ---
>>   mm/memcontrol.c | 10 +++++++---
>>   1 file changed, 7 insertions(+), 3 deletions(-)
>>
>> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
>> index 982c9f5cf72cb..0458fc2e810ff 100644
>> --- a/mm/memcontrol.c
>> +++ b/mm/memcontrol.c
>> @@ -991,14 +991,18 @@ struct mem_cgroup *get_mem_cgroup_from_current(void)
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
>> -		memcg = root_mem_cgroup;
>> +	do {
>> +		memcg = folio_memcg(folio);
>> +	} while (unlikely(!css_tryget(&memcg->css)));
> 
> I went back to [1] where AI raised the following concern which I want to
> address:
> 
>> If css_tryget() fails (e.g. refcount is 0), this loop spins indefinitely
>> with the RCU read lock held. Is it guaranteed that folio_memcg() will
>> return a different, alive memcg in subsequent iterations?
> 
> Will css_tryget() ever fail for the memcg returned by folio_memcg()?
> Let's suppose memcg of a given folio is being offlined. The objcg
> reparenting happens in memcg_reparent_objcgs() which is called in
> offline_css() chain and we know that the offline context holds a
> reference on the css being offlined (see css_killed_work_fn()).
> 
> Also let's suppose the offline process has the last reference on the
> memcg's css. Now we have following two scenarios:
> 
> Scenario 1:
> 
> get_mem_cgroup_from_folio()		css_killed_work_fn()
>    memcg = folio_memcg(folio)		  offline_css(css)
>    					    memcg_reparent_objcgs()
>    css_tryget(memcg)
>    					  css_put(css)
> 
> In the above case css_tryget() will not fail.
> 
> 
> Scenario 2:
> 
> get_mem_cgroup_from_folio()		css_killed_work_fn()
>    memcg = folio_memcg(folio)		  offline_css(css)
>    					    memcg_reparent_objcgs()
>    					  css_put(css) // last reference
>    css_tryget(memcg)
>    // retry on failure
> 
> In the above case the context in get_mem_cgroup_from_folio() will retry
> and will get different memcg during reparenting happening before the
> last css_put(css).
> 
> So, I think we are good and AI is mistaken.
> 
> Folks, please check if I missed something.

LGTM, thank you for such a detailed analysis!

> 
>>
>> If the folio is isolated (e.g. via migrate_misplaced_folio()), it might be
>> missed by reparenting logic that iterates LRU lists.
> 
> LRU isolation will not impact reparenting logic, so we can discount this
> as well.
> 
>> In that case, the
>> folio would continue pointing to the dying memcg, leading to a hard lockup.
>>
>> Also, folio_memcg() calls __folio_memcg(), which reads folio->memcg_data
>> without READ_ONCE().
> 
> Oh I think I know why AI is confused. It is because it is looking at
> folio->memcg i.e. state with this patch only and not the state after the
> series. In the current state the folio holds the reference on memcg, so
> css_tryget() will never fail.
> 
>> Since this loop waits for memcg_data to be updated
>> by another CPU (reparenting), could the compiler hoist the load out of
>> the loop, preventing the update from being seen?
>>
>> Finally, the previous code fell back to root_mem_cgroup on failure. Is it
>> safe to remove that fallback? If css_tryget() fails unexpectedly, hanging
>> seems more severe than the previous behavior of warning and falling back.
> 
> [1] https://lore.kernel.org/all/7ia4ldikrbsj.fsf@castle.c.googlers.com/
> 
> 


