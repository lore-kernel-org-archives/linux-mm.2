Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2A13BEC1428
	for <linux-mm@archiver.kernel.org>; Tue,  3 Mar 2026 10:42:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 97A7B6B014D; Tue,  3 Mar 2026 05:42:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 951F76B014E; Tue,  3 Mar 2026 05:42:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 87F566B014F; Tue,  3 Mar 2026 05:42:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 741A06B014D
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 05:42:38 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 0AE641402D4
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 10:42:38 +0000 (UTC)
X-FDA: 84504413196.24.CB76AED
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id 4DCE810000B
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 10:42:36 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=pc4pLu6o;
	spf=pass (imf14.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772534556;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ceTKC4PCEQQp/siqXCGtgz/7J/ivtPhqYDeEwM40TDw=;
	b=C7keEB74D4gs/wIqV/3kgtoMG9f+Nr5fCiioQvUt4iV2R3kjehN0y19gIS3rzFy/w7NnuS
	nzwBjeG47fIvdGqRSc8TMRBiIngROQmYVaAuvL+8ji/UJP+E653h1ZWVfUdUl73m8/4HyL
	JkjtcqUiUQ2tMPZ+X3J4crMEesxronA=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=pc4pLu6o;
	spf=pass (imf14.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772534556; a=rsa-sha256;
	cv=none;
	b=6/HvFLW4dDA0Lx3TTJSE2fBt/0/mKu0+SIKZ2iFAtsCLN0xGgiAPG8Gww4g9EBjP7jKfHA
	IrAxRiISwlVJyW+o8OTUcDjr78deACoPsXrVWoZTqfj2BoDh259LV/bne9muG14JAKrRpF
	S3qACN0ddej/ZdEkwxfDVWR21j3O+E0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id A2768600AE;
	Tue,  3 Mar 2026 10:42:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 347AEC2BCAF;
	Tue,  3 Mar 2026 10:42:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772534555;
	bh=LXTeLcko8TN4s1+AW7QCG0gHA8xgKDg8hODvm4T/7lc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=pc4pLu6ohC9WXq6G0jj+NEJ5RkGQ37fiA5oNskpR6+zMukelRCHtriLRP4m7CqHAw
	 nPA2LlF3ddDrXi2EUp2GJ0padvrjbfd0UgIOdtSOReXm0uRZdgPT0InGWehijm2w/y
	 ndQDznoNs8TxIEw1DZhmy2CIPUuafpZ7uSQyLa9iPlJkL2+ESL6Q3lf6nlb+ZH4prL
	 VOKd1DKQ9RB0+R4IsTXYoiUOGwebLqLeSRAF3b5u+sTLjOPxrkQd4qWbV9zg4b6JKd
	 Bhfbxnc/CtloC/kupqmYWciYZEwAEqTyJGFzFWFS8uU+tn9+gYvJhSR8lJS0W1Dcjw
	 biTyQuTKeFhpg==
Message-ID: <541a6661-7bfe-4517-a32c-5839002c61e5@kernel.org>
Date: Tue, 3 Mar 2026 11:42:31 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5/5] mm: memcg: separate slab stat accounting from objcg
 charge cache
Content-Language: en-US
To: Hao Li <hao.li@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Vlastimil Babka <vbabka@suse.cz>,
 Harry Yoo <harry.yoo@oracle.com>, linux-mm@kvack.org,
 cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260302195305.620713-1-hannes@cmpxchg.org>
 <20260302195305.620713-6-hannes@cmpxchg.org>
 <ji2jjt4vtmt2ox7wzytpivttc4z7j3u6cwmv23r6xit5322gns@te4t4djl5nlk>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
In-Reply-To: <ji2jjt4vtmt2ox7wzytpivttc4z7j3u6cwmv23r6xit5322gns@te4t4djl5nlk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 4DCE810000B
X-Stat-Signature: i7u9jenz4m4pmhtszir6gto8t7udat4z
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1772534556-104007
X-HE-Meta: U2FsdGVkX18Gw/JjctQKv5nSuqE6qYxHJ83XlccF5vFzenK2L7zw5XhqA/2V+0soros6tSSbkKbt7Yd6wAYyU5rkHdp+SsuG3kps6nOjKImK0Xzg+x8+gDOkpY3uitVj6ygdrgdrXgnD5icKDbMEa76QyH3iJFBDzRQzCjHnBy7JgF9uXvjiqlQAPpzo94OVyR7Hn7I5MBCW1jCIVN0kz8a4V7G/6cTCZQuTGxv9bfbNdYDzcxcuR3KOwJbqI+nRPLVf7fdn/lXwS5NiBN/Nslf8kcPXBQyQvPCHdgcwxNWHbdz38iPziItywZFunoNXkJNtMWJo+RK7XfQiMK3W+XnifrNf9eBXoU7ufHGxnOIUzWqpezefeFP4z0Q8I32N80Vb/UxHZvcTcvT1/puiRrE2eZKVWZtkEKJC02nM4q5bR1riPaoJdDsy+Vs/ISj4JC/LJnpxmM3W6Cd8kkgSugOhutTrEtFFADmBUqzp3vhkEOMe17xCUlNnViV/Pzl0usBMzdBlAOvMv+xaQQYwKiF98dfvaxzqFZbFzpJBGIyjVvE4DwfkLO7/HvHb4/+DKNNk1q6sQiB7fNqR1I7OPXGgB42UpOEspXbhneQxtWfbQRG/o1Vo2bzB5GbppSQ9NwDsrUttqkk0DOci8kYWBnSDYOYzbuLRlEuPTa5Ux/v8kdYUuJNQ7dmeSUrqwNTgEWUdoE+qIfRV5CMzpPHlKTsceOV+in6ay4zgzRWIi2q3X5oW0OlUsomraQoeLM456XeM6kfvmUMzV27vm0X5I6CrHGWWAsKbAr1SHFjFhkDXJ3PGalke9BF7yMB1k/bOzkQhSV2sCtj2Kj+25ieYMElkdLgcoufN1UVXsrQjW7YDPTSGxPrgJVkQsl6dW4gNVJWszQBF/AD1pvSJoS+6uAH5nF6AHkqlGZWRjygiOPYay/Hqpo1R6MtGdLO/aj+PMklJGS+Co07un7RQOlG
 kDELM7sw
 EdVXj6/PUxdmMDWyp0019/jiIXjce7WUljqPejEa9iLihufm6pWMOU5RdZaaETrIEFWutRRBFwlPTkE6Q5HhW0fKopfvteYRATwLWnGtjXntMAoC2DsJ1wVWY5VvFX+VRiue+ajWGLwBCrxEX5ox9JDf6ytIglCOiZLfNNXFjD/toTKc4POvPrMiB3yhty1TX4cpO1D13jwAmE3cR/dKLXERhPzBnQASeZdiqV8js5BRpYPAY4poS+CyfV95QHhuPqXuECmbU/l6Z2Dp0ZKbqm2W1n9K0Jv5X2u4+xPBN3645T5gzash8gt+dlpFPpMevBOQI
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/3/26 09:54, Hao Li wrote:
> On Mon, Mar 02, 2026 at 02:50:18PM -0500, Johannes Weiner wrote:
>> Cgroup slab metrics are cached per-cpu the same way as the sub-page
>> charge cache. However, the intertwined code to manage those dependent
>> caches right now is quite difficult to follow.
>> 
>> Specifically, cached slab stat updates occur in consume() if there was
>> enough charge cache to satisfy the new object. If that fails, whole
>> pages are reserved, and slab stats are updated when the remainder of
>> those pages, after subtracting the size of the new slab object, are
>> put into the charge cache. This already juggles a delicate mix of the
>> object size, the page charge size, and the remainder to put into the
>> byte cache. Doing slab accounting in this path as well is fragile, and
>> has recently caused a bug where the input parameters between the two
>> caches were mixed up.
>> 
>> Refactor the consume() and refill() paths into unlocked and locked
>> variants that only do charge caching. Then let the slab path manage
>> its own lock section and open-code charging and accounting.
>> 
>> This makes the slab stat cache subordinate to the charge cache:
>> __refill_obj_stock() is called first to prepare it;
>> __account_obj_stock() follows to hitch a ride.
>> 
>> This results in a minor behavioral change: previously, a mismatching
>> percpu stock would always be drained for the purpose of setting up
>> slab account caching, even if there was no byte remainder to put into
>> the charge cache. Now, the stock is left alone, and slab accounting
>> takes the uncached path if there is a mismatch. This is exceedingly
>> rare, and it was probably never worth draining the whole stock just to
>> cache the slab stat update.
>> 
>> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
>> ---
>>  mm/memcontrol.c | 100 +++++++++++++++++++++++++++++-------------------
>>  1 file changed, 61 insertions(+), 39 deletions(-)
>> 
>> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
>> index 4f12b75743d4..9c6f9849b717 100644
>> --- a/mm/memcontrol.c
>> +++ b/mm/memcontrol.c
>> @@ -3218,16 +3218,18 @@ static struct obj_stock_pcp *trylock_stock(void)
>>  
> 
> [...]
> 
>> @@ -3376,17 +3383,14 @@ static bool obj_stock_flush_required(struct obj_stock_pcp *stock,
>>  	return flush;
>>  }
>>  
>> -static void refill_obj_stock(struct obj_cgroup *objcg, unsigned int nr_bytes,
>> -		bool allow_uncharge, int nr_acct, struct pglist_data *pgdat,
>> -		enum node_stat_item idx)
>> +static void __refill_obj_stock(struct obj_cgroup *objcg,
>> +			       struct obj_stock_pcp *stock,
>> +			       unsigned int nr_bytes,
>> +			       bool allow_uncharge)
>>  {
>> -	struct obj_stock_pcp *stock;
>>  	unsigned int nr_pages = 0;
>>  
>> -	stock = trylock_stock();
>>  	if (!stock) {
>> -		if (pgdat)
>> -			__account_obj_stock(objcg, NULL, nr_acct, pgdat, idx);
>>  		nr_pages = nr_bytes >> PAGE_SHIFT;
>>  		nr_bytes = nr_bytes & (PAGE_SIZE - 1);
>>  		atomic_add(nr_bytes, &objcg->nr_charged_bytes);
>> @@ -3404,20 +3408,25 @@ static void refill_obj_stock(struct obj_cgroup *objcg, unsigned int nr_bytes,
>>  	}
>>  	stock->nr_bytes += nr_bytes;
>>  
>> -	if (pgdat)
>> -		__account_obj_stock(objcg, stock, nr_acct, pgdat, idx);
>> -
>>  	if (allow_uncharge && (stock->nr_bytes > PAGE_SIZE)) {
>>  		nr_pages = stock->nr_bytes >> PAGE_SHIFT;
>>  		stock->nr_bytes &= (PAGE_SIZE - 1);
>>  	}
>>  
>> -	unlock_stock(stock);
>>  out:
>>  	if (nr_pages)
>>  		obj_cgroup_uncharge_pages(objcg, nr_pages);
>>  }
>>  
>> +static void refill_obj_stock(struct obj_cgroup *objcg,
>> +			     unsigned int nr_bytes,
>> +			     bool allow_uncharge)
>> +{
>> +	struct obj_stock_pcp *stock = trylock_stock();
>> +	__refill_obj_stock(objcg, stock, nr_bytes, allow_uncharge);
>> +	unlock_stock(stock);
> 
> Hi Johannes,
> 
> I noticed that after this patch, obj_cgroup_uncharge_pages() is now inside
> the obj_stock.lock critical section. Since obj_cgroup_uncharge_pages() calls
> refill_stock(), which seems non-trivial, this might increase the lock hold time.
> In particular, could that lead to more failed trylocks for IRQ handlers on
> non-RT kernel (or for tasks that preempt others on RT kernel)?

Yes, it also seems a bit self-defeating? (at least in theory)

refill_obj_stock()
  trylock_stock()
  __refill_obj_stock()
    obj_cgroup_uncharge_pages()
      refill_stock()
        local_trylock() -> nested, will fail

