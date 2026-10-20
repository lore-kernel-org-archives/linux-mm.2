Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E354B606A327
	for <linux-mm@archiver.kernel.org>; Tue, 20 Oct 2026 08:43:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=e2cYCQVT
Received: by kanga.kvack.org (Postfix)
	id EBFD76B0451; Tue, 20 Oct 2026 04:43:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E70A66B0452; Tue, 20 Oct 2026 04:43:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D60BA6B0453; Tue, 20 Oct 2026 04:43:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9FE566B0451
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 04:43:00 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 2D9381A096B
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 08:43:00 +0000 (UTC)
X-FDA: 85342364520.03.118FAE8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id 691E380006
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 08:42:58 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=e2cYCQVT;
	spf=pass (imf30.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792485778;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sLynr6//lH+2rxsY6ffbt7Cr2xdwoxHTD2+TxPt+66k=;
	b=yX+8f8NydJjLWz42JDN93knaCObImtwMSxXzF69S7hJbm1V8y7TbFVO6nXr9KSiZLftVmx
	KBvTR7ZsBzI+duh8FtA8i/P3DbBmkxNz+ejt/tkBRgyU6R9EUj4wKNTMjs+0E0U9rHaI+9
	TZRhVOPw0TZ04vk1qmXPIsDHuqmbHWQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792485778;
	b=CCytqF0aZYuKyyubv9ADoNZyVpm2JI3wHr/mIkbz4k81ofX7Bu5UhIRojcqACQr0GyOdfM
	3TUXE2q1aDOXboM3U2nnGGbPZrRzxCyoaZ6SvkxVrSHnoBqMQ3+qGrQoveGJB+t4N7oGd/
	X1IVUki2f38HXfa6daBG6bgal7e2ErA=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=e2cYCQVT;
	spf=pass (imf30.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id EEBC8605EF;
	Tue, 20 Oct 2026 08:42:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E4C41F000C5;
	Tue, 20 Oct 2026 08:42:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792485777;
	bh=sLynr6//lH+2rxsY6ffbt7Cr2xdwoxHTD2+TxPt+66k=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=e2cYCQVT81RkTLLpwPg2CVfrhyKaN1vcviAOmjORE4hrFf1z/hO6KII9Mat0Lktmy
	 abEyCOsIGTrqXzBhobmEb89JCZg4Gz7hYBP9WvCr6rtXz84FE39nlsCSFv56QgmOs/
	 /LgXvk003PCM93iyc0WQVmFqW38Kekez+4FRP1ctF1oa5sKHb/ehbnxpbKK9N9HzBd
	 I90fGmjLh+HPRkeTh1Kn8r5bx6iRjLobhfaKjF188C0TNgreJulITRySfkeXkBQqFZ
	 gwTsZUYwfdZMDG+1ldipvIL4P0zz2rIOVdVWNAxv2wliusIHypFFLQtv3tKEOic85M
	 SZKU1iVljOfaA==
Message-ID: <de86277d-ed7e-4208-a3c2-6d26a8278d0c@kernel.org>
Date: Tue, 20 Oct 2026 10:42:53 +0200
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1] mempool: fix min_nr exceeding the elements array after
 concurrent resizes
Content-Language: en-US
To: Harry Yoo <harry@kernel.org>, Nickolai Zeldovich <nickolai@csail.mit.edu>
Cc: Andrew Morton <akpm@linux-foundation.org>, Hao Li <hao.li@linux.dev>,
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
 Vitaly Wool <vitaly.wool@konsulko.se>,
 Vitaly Vul <vitaly.vul@partner.samsung.com>
References: <20261016132510.789715-1-nickolai@csail.mit.edu>
 <atJBK6hWYh2AqXwK@thinkstation>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <atJBK6hWYh2AqXwK@thinkstation>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 691E380006
X-Stat-Signature: wpi9ubfssdgbauw1d76c94sjzprmu8ep
X-Rspam-User: 
X-Spam-Status: No, score=-22.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1792485778-491278
X-HE-Meta: U2FsdGVkX1+pO4Zu6e5PKhGSxPn+/iJoTEnA3oPW6NRcp/hWzASJMrvb1bmGLDJDPSk7PFdjF0TqnM4dY8vVq8+bGCpcuUDwR8YlH/YaKqqREVr9x0zjzeebTO+bWxpRaohy8wCMEXt18UZjw2C9K4yUXkHTXNQnPh5gy9WLgI7mQ/R9T/+dOiOEVl5pvENDLtEos+MD3UzvKraPXH/TbAjRgV6QCgEaoJ0evXEPjo482MLxtG2uHgqRsM3ukFZV7hgjmIAWP7LSxCC8zYyalj/RwUABgI3kP1lwkhSZlHV/xDW5aXAPwkdbl32dPTyns7nO28MQya1vBW6qzotMg4ezewQmrIlplJEl62UqfroETtStivcRdUs4pNqRiJThlgkzAIkbf3BW8la6tfTMkF+YHI3vE9/6AGURGgD0vx/4P8A3fWf6iARe+xICs2VYsGxd3ih/YfZ2GMCjC1hhnBol9uqRGG6YqokprbB71gGavtw7JtBSuCN7UMqxqoSJkdEad4LYF5JJ7AM5m+0MID4Rt8P2Ulb0Uzu1k+MYSVz34wQbSEbHoOkAg3aeP/amOcBdwN7kqszJOiNIYCPfDxkUeZZLMTpmhfodo99JWM5H3FjrrNObFTclxXE6mYgsSDq66KRcWvMbb8R4SwtGSTXyrXhPtJU4Y1vATqkuy2ipkLJUuDrdiGpHqQx6DAMPsCg0HVSuV4fJ7vnjaiVELPPTsW9JX8CGZPUlwg+F5lJT1QxRTLt+P/ijUpPaGxCYyJPOvyQfEWW4rkoaeH62aZnWwWJMx/69rX0L9KxPfLEjeLx+1PmYqmdkMQew97pSoZBCFpjnuhtoFnZcE5z4Hrnh7p9wqVrN6X+JgMJX7wc2R2dpyFfmoiCS0gbsJ39C4mz9wcDkVT7nJihpl0er/5lqiwa3GPpu+REsUr+Q7WP6AKglSykbvrpYWrAA1enQjNw5hu/hJ8eSU95PLQy
 o4N2sLUu
 qwmCk7F6i6xtLBXuD1lTYodh5kGZiE8CVf1WNAyWUN07su1SMPZDfvminEPlNVy2BLuRtNgJ4sGkvX0+tOyQbNqh0nIPgpqnHcMs/7FzhzpLQSD1OhQq9cUn2SQYAYEt8dC/u5wU8jwtOw5kzcFkoeCHb8AWHTjhdp+9CwshTEP/yPnkCDwcevcCBPJw3BN9j8Wo1BRke/Hlim03nCoxEmVM509ia8LrhRXdm4JCJ7Lu41CpTWEMgqreebvYm52h4JyIeho7fVs2ZYhVslleATG3JFpUjm2fAn2eC8NhqLdcWJoRzTjn/7CvKEeH4bGXlSYwtPDfOHkmupmU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 10/16/26 17:46, Harry Yoo wrote:
> [+Cc Christoph Hellwig and Vitaly Wool ]
> 
> On Fri, Oct 16, 2026 at 09:25:10AM -0400, Nickolai Zeldovich wrote:
>> mempool_resize() shrinks a pool by dropping pool->lock around every
>> free_fn() call and, once the pool holds no more than new_min_nr
>> elements, stores new_min_nr into pool->min_nr.  new_min_nr was only
>> compared against pool->min_nr before the lock was first dropped, so that
>> store assumes nothing changed meanwhile.  The kernel-doc allows
>> mempool_alloc()/mempool_free() to run while a resize is in progress and
>> the grow path also copes with concurrent resizes ("Raced, other resize
>> will do our work"), but the shrink path does not: while its lock is
>> dropped another resize may shrink the pool below new_min_nr and a third
>> one may grow it again to a size between the two, replacing
>> pool->elements with an array of exactly that size.  Storing the stale
>> new_min_nr afterwards leaves pool->min_nr larger than the elements
>> array.
>> 
>> Interleaving on a pool with min_nr = curr_nr = 10:
>> 
>>   CPU A: mempool_resize(pool, 8)
>>     takes the lock, 8 <= 10 so it shrinks: remove_element(), drops the
>>     lock, calls free_fn() and is preempted there
>>   CPU B: mempool_resize(pool, 3)
>>     completes: curr_nr = 3, min_nr = 3, elements still has 10 slots
>>   CPU B: mempool_resize(pool, 5)
>>     completes: elements = kmalloc_objs(5), min_nr = 5, curr_nr = 5
>>   CPU A: retakes the lock, 8 < curr_nr (5) is false, stores min_nr = 8
>>     while elements has 5 slots
>> 
>> Every later mempool_free() sees curr_nr < min_nr and add_element()
>> stores the returned element at elements[5], [6] and [7], past the end
>> of the 5-slot kmalloc allocation: a heap out-of-bounds write, i.e. slab
>> corruption, a KASAN report, or a crash in whichever unrelated object
>> sits next to the array.  The invariant that breaks is that pool->min_nr
>> never exceeds the size of pool->elements; every other path that changes
>> min_nr or elements keeps it.

Instead of reading all this, it was simpler for me to check what the code does.

>> An in-tree caller can hit this: fs/smb/client resizes the global
>> cifs_req_poolp from cifs_demultiplex_thread() (grow, when a TCP session
>> is created) and from clean_demultiplex_info() (shrink, when one goes
>> away).  The two are coordinated only through the atomic
>> tcpSesAllocCount, so mounts and unmounts racing on one client run the
>> resizes above concurrently; pool->free is kmem_cache_free() there and
>> the window is a preemption inside it.  The other callers
>> (block/blk-zoned.c, drivers/s390/scsi/zfcp_erp.c) serialise their
>> resizes.

This is useful to know, but maybe could be also less dense.

> The bug looks valid in theory, not sure if how easily it can be
> reproduced in practice as resizing should be quite rare.
> (A bug is a bug and should be fixed, but no need to hurry in this case)

Ack.

>> The shrink path has stored new_min_nr unconditionally since
>> mempool_resize() was introduced, while the grow path has always
>> re-checked pool->min_nr after reacquiring the lock.
> 
> So it's Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2") ? 
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/tglx/history.git/commit/?id=6892188b54d484098b79b0c9813c20e543124e2d
> 
> ...from a historical commit before git era, 1da177e4c3f4.
> 
>> Re-check new_min_nr against pool->min_nr under the lock before storing
>> it.  If a concurrent resize has shrunk the pool below new_min_nr in the
>> meantime, keep that resize's min_nr (and whatever array it installed),
>> as the grow path already does; otherwise the store is unchanged.  The
>> elements the loop has already freed stay freed, which is right either
>> way because the pool's limit is now below new_min_nr.

Again too verbose IMHO.

>> Found by formal verification of mm/mempool.c against the kernel binary.
>> Reproduced with a userspace build of the affected functions in which the
>> free_fn() callback drives the interleaving above: before the fix min_nr
>> ends at 8 with a 5-slot array and the next mempool_free() writes past it
>> (AddressSanitizer heap-buffer-overflow); after the fix min_nr stays at 5
>> and the element is handed to free_fn().  Not reproduced on a running
>> kernel, where the window is a single preemption inside free_fn().

Alright.

>> Assisted-by: LLM
>> Signed-off-by: Nickolai Zeldovich <nickolai@csail.mit.edu>
>> ---
>>
>>  mm/mempool.c | 4 +++-
>>  1 file changed, 3 insertions(+), 1 deletion(-)
>> 
>> diff --git a/mm/mempool.c b/mm/mempool.c
>> index cb74e718b2c6..95533e2975ce 100644
>> --- a/mm/mempool.c
>> +++ b/mm/mempool.c
>> @@ -378,7 +378,9 @@ int mempool_resize(struct mempool *pool, int new_min_nr)
>>  			pool->free(element, pool->pool_data);
>>  			spin_lock_irqsave(&pool->lock, flags);
>>  		}
>> -		pool->min_nr = new_min_nr;
>> +		/* Raced, the array may now be smaller than new_min_nr */
>> +		if (new_min_nr <= pool->min_nr)

There could be just '<' ?
The outer if uses <= but the == case only leads to an early goto out_unlock.

>> +			pool->min_nr = new_min_nr;
>>  		goto out_unlock;
>>  	}
>>  	spin_unlock_irqrestore(&pool->lock, flags);
>> 
>> base-commit: 90201351a862182bdabfc1ad1c97b1e1b6ed5931
>> -- 
>> 2.53.0
>> 
> 


