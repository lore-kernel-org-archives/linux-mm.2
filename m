Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D3E41CCF2E5
	for <linux-mm@archiver.kernel.org>; Mon, 19 Oct 2026 14:41:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DD85A6B028D; Mon, 19 Oct 2026 10:41:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D60CB6B028E; Mon, 19 Oct 2026 10:41:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C4FCD6B028F; Mon, 19 Oct 2026 10:41:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9625E6B028D
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 10:41:31 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 31C9780706
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 14:41:31 +0000 (UTC)
X-FDA: 85339639182.29.B37CDF2
Received: from mta0.migadu.com (out-126.mta0.migadu.com [91.218.175.126])
	by imf12.hostedemail.com (Postfix) with ESMTP id BEDAC40006
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 14:41:28 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=d+6BuBab;
	spf=pass (imf12.hostedemail.com: domain of jiayuan.chen@linux.dev designates 91.218.175.126 as permitted sender) smtp.mailfrom=jiayuan.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792420889;
	b=HXBA8QFmbPs0CsfdRli6SihKX447BW5fc1Xv4cFAc89mt2XDlToO4nyQn0C8loSfX07wyw
	G7dm1Ie2uHhFbaTwfiy9s9QdQpsm+2sxq850iMNC/1c1auN16kuWugRdqY9A2kYfDTwkAh
	5ogwpey9ZEYHRnkj1oUc+bUSNg5KcXQ=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=d+6BuBab;
	spf=pass (imf12.hostedemail.com: domain of jiayuan.chen@linux.dev designates 91.218.175.126 as permitted sender) smtp.mailfrom=jiayuan.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792420889;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=T6raW/PObwT7h5FSIt56ztQ+9Pww7CebsT2963E2czs=;
	b=eRVCKCdhY8A1i5xtXIHsEfUWnorftw217TlufrR2FVIqyiOdBEiR0HsStib4hyTrijZjW6
	xFzaOvuE7IeP1pSF7soI7mqK5Z5RgHpdrkQvrGTKOBlPVHU6vQx9CVmwZ/I7YsbyTr3mk5
	cBKDkPvP8J4bG5yJAQp0IcZp83fPShc=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=HwE2plcjFNclb9HwtwKDo6zr2B1gdPL2a6p1mdIeSyU=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792420887; v=1; x=1793025687;
 b=d+6BuBabhD1ZdY8NeF7Ot2Jm16a39EPZNn1G5n1mNMhKmdi+mX+6Qon1A49I/y/CISLbdZXn
 WGhfN6ws709zzS7si8qffSU92nnVUUR52ZGgla6XtBgpVAORphi+kgowB/eeR1RWghh7otM6oKV
 Bu+i453MfyuqJ5EQTzvA3ae4=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id df66da58367c8def;
	Mon, 19 Oct 2026 14:41:27 +0000
X-Mizu-Trace-ID: df66da58367c8def
X-Migadu-Flow: FLOW_OUT
Message-ID: <19fcff1a-75be-4522-8413-047efc2612e5@linux.dev>
Date: Mon, 19 Oct 2026 22:41:20 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH mm-next] mm/swap: free swap cache folios the zap path gave
 up on
To: Kairui Song <ryncsn@gmail.com>
Cc: linux-mm@kvack.org, Jiayuan Chen <jiayuan.chen@shopee.com>,
 Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>,
 Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>,
 Baoquan He <baoquan.he@linux.dev>, Barry Song <baohua@kernel.org>,
 Youngjun Park <youngjun.park@lge.com>, linux-kernel@vger.kernel.org
References: <20261014090821.227366-1-jiayuan.chen@linux.dev>
 <CAMgjq7CT4srpTcAkStOV6zN8X2v4mPN7cRzA9B_eevFB4azvtg@mail.gmail.com>
From: Jiayuan Chen <jiayuan.chen@linux.dev>
In-Reply-To: <CAMgjq7CT4srpTcAkStOV6zN8X2v4mPN7cRzA9B_eevFB4azvtg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: BEDAC40006
X-Stat-Signature: b3cqwes178nnff1kykmhsnkgwafhqo6a
X-Rspamd-Server: rspam01
X-HE-Tag: 1792420888-797005
X-HE-Meta: U2FsdGVkX19wqpUzK4lplTuXDcU88xT51IDvR25omK17QsiyfDtdHa2G504J2d4M+X9EiHstMoanGjW3HWCXmKI4RZGRHRfAS8plx0xCAx2BYQUYNBhWcn+R+fabRSXT9z+Xe/oFvM7QOtPkSgACYpkEZ30XGxmnnle2dCtH4Z7IKH3tzP8sid725j9xVcv90+7cZpevEe4K4diHJzBuJsq1GpT/8LyrUSY5XvYPmtygpPpha8wMEBUw8GT2VU02JFAymNfVWMAgDGpOkFipyghlhLaKkjtadX2PRXk79L2pbYKN0VbrSw+Ix98VtVsvS9EGgdVEpspd1QWAyd3T7udbU3eynZ3TpMWL/XVWstuuJ42QhGCGB0nS65nMFSsIaqXrannftp7halo45BWDJ0jfx9GXYmbdv9hXz2nMdQQa7TGK2U7q2rVmCBXpuctN8yM4wRusizTqKvRI7N+Lk3w4C/+AUYcgRto7zBN+YIONqmFKSy9u9/+adRrTr23CTsYnfNhce8SeHSXC2JCwwFex98fN8x8HV71rsrJIKgVno6HNxAQTS2ZY7qSRVBy5HN7Sk0y+IEixk4MXXy2Q5uu0d5bdmk1kGyXA/VKX3c7+hosmzH+ewcpomqDJ400wP+ZfH22OsBIg3tXZHWLMbgwH9gh6ArY7Fl7NlCIPp27sGOCt3GIRO/pRDh5Auil5HZAVs9i+5kp2LUlRGZ63Fwx4vxB4e4Kw2dcqsmlXjc79V1YvJ9eWFRw8URNrv7SL25rlPV2qfvQdUdRRYPoCP57s0Ru9i0bHzG6s4ZVQY9w7wxkPFzR8gYpKtuXYS7Tqeu7hM7n8gciEO6OO5z7jOBXwdzhMtwLJUIjpM4l0XBUNgIxc4j2ZGyuAqqY0Xv3V7s59Q4I+7gF4K5m12Rtp8+/aB22NcvywWP2q40/uhDAqqZIsa9IrREX6Za4Y9Q5LgJFjCE5h38jc4qX2cfG
 5DuwHIEY
 KvcbGjOM6G1DyJg5wHnRxdreWvEEkXzKq6PdiNzbvjASI9sz6A1K69UZi9rDiCm7RW7wKrRAU3+qjVi5a4U6idYhn7TuN5Jtc4GM/CdPbv2dbNhDGStCcJWT6l2ISDShVylfDJKJ8PGl6WMsuvSvFYk4Iph/06rWQZpY8pjwL+KlaA2Qnb12JkREn8b44vvBgePJWQwrlpwY/qjwPSF9IPs7MGeQOokiujsN6czmKQzy25maw9esoTQHu8mxbFvSu0C6dPdV0gh3ValQPmiU8BuerAPMyi8soXodFKAzCZlM474s=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 10/17/26 2:17 AM, Kairui Song wrote:
> On Wed, Oct 14, 2026 at 5:10 PM Jiayuan Chen <jiayuan.chen@linux.dev> wrote:


[...]

>> --- a/mm/swap_state.c
>> +++ b/mm/swap_state.c
>> @@ -598,16 +598,13 @@ void swap_writeback_dropbehind_folio(struct folio *folio)
>>    *
>>    * Its ok to check the swapcache flag without the folio lock
>>    * here because we are going to recheck again inside
>> - * folio_free_swap() _with_ the lock.
>> + * __try_to_reclaim_swap() _with_ the lock.
>>    *                                     - Marcelo
>>    */
>>   void free_swap_cache(struct folio *folio)
>>   {
>> -       if (folio_test_swapcache(folio) && !folio_mapped(folio) &&
>> -           folio_trylock(folio)) {
>> -               folio_free_swap(folio);
>> -               folio_unlock(folio);
>> -       }
>> +       if (folio_test_swapcache(folio) && !folio_mapped(folio))
>> +               swap_reclaim_entry(folio->swap);
> One problem here, if folio is not locked, you might read garbage from
> folio->swap.



Right, keep the trylock in free_swap_cache() and only read folio->swap 
under it.


>
>>   }
>>
>>   /*
>> diff --git a/mm/swapfile.c b/mm/swapfile.c
>> index c3288910b3e3..ee29085152fe 100644
>> --- a/mm/swapfile.c
>> +++ b/mm/swapfile.c
>> @@ -172,6 +172,8 @@ static long swap_usage_in_pages(struct swap_info_struct *si)
>>   #define TTRS_UNMAPPED          0x2
>>   /* Reclaim the swap entry if swap is getting full */
>>   #define TTRS_FULL              0x4
>> +/* May sleep: wait for the folio lock and for writeback instead of giving up */
>> +#define TTRS_WAIT              0x8
>>
>>   static bool swap_only_has_cache(struct swap_cluster_info *ci,
>>                                  unsigned long offset, int nr_pages)
>> @@ -217,9 +219,19 @@ static int __try_to_reclaim_swap(struct swap_info_struct *si,
>>           * avoiding deadlock. This is a special case and you should
>>           * use folio_free_swap() with explicit folio_lock() in usual
>>           * operations.
>> +        *
>> +        * The zap path (TTRS_UNMAPPED) is the one caller for which giving
>> +        * up means the slot is never looked at again: it stays allocated
>> +        * with count 0 and an unmapped folio pinned in the swap cache. Let
>> +        * the sweep worker, which can wait, come back for it.
>>           */
>> -       if (!folio_trylock(folio))
>> +       if (flags & TTRS_WAIT) {
>> +               folio_lock(folio);
>> +       } else if (!folio_trylock(folio)) {
>> +               if (flags & TTRS_UNMAPPED)
>> +                       schedule_work(&si->sweep_work);
>>                  goto out;
>> +       }
>>
>>          /*
>>           * Offset could point to the middle of a large folio, or folio
>> @@ -232,11 +244,20 @@ static int __try_to_reclaim_swap(struct swap_info_struct *si,
>>          }
>>          offset = swp_offset(folio->swap);
>>
>> +       if (flags & TTRS_WAIT)
>> +               folio_wait_writeback(folio);
> You may merge this into the TTRS_WAIT check above?

Right !


>> +
>>          need_reclaim = ((flags & TTRS_ANYWAY) ||
>>                          ((flags & TTRS_UNMAPPED) && !folio_mapped(folio)) ||
>>                          ((flags & TTRS_FULL) && mem_cgroup_swap_full(folio)));
>> -       if (!need_reclaim || !folio_swapcache_freeable(folio))
>> +       if (!need_reclaim)
>> +               goto out_unlock;
>> +       if (!folio_swapcache_freeable(folio)) {
>> +               /* Same for a folio the zap caught under writeback. */
>> +               if ((flags & TTRS_UNMAPPED) && folio_test_writeback(folio))
>> +                       schedule_work(&si->sweep_work);
>>                  goto out_unlock;
>> +       }
>>
>>          /*
>>           * It's safe to delete the folio from swap cache only if the folio
>> @@ -1099,6 +1120,80 @@ static void swap_reclaim_work(struct work_struct *work)
>>          swap_reclaim_full_clusters(si, true);
>>   }
>>
>> +/*
>> + * Free the slots a zap could not take back: swap cache only, count 0, folio
>> + * not mapped. The zap runs under the PTL, so when the folio was locked (a
>> + * readahead or an asynchronous swap-in still reading into it) or under
>> + * writeback, __try_to_reclaim_swap() had to give up and scheduled us. Such
>> + * a slot is reachable by nobody but LRU reclaim: no page table holds its
>> + * entry, and the allocator skips it until swap is half full. Here we can
>> + * wait for the lock and the writeback.
>> + */
>> +static void swap_sweep_work(struct work_struct *work)
>> +{
>> +       struct swap_info_struct *si;
>> +       struct swap_cluster_info *ci;
>> +       unsigned long offset, end, swp_tb;
>> +       unsigned long nr_clusters;
>> +       int nr_reclaim;
>> +
>> +       si = container_of(work, struct swap_info_struct, sweep_work);
>> +       nr_clusters = DIV_ROUND_UP(si->max, SWAPFILE_CLUSTER);
>> +
>> +       for (unsigned long i = 0; i < nr_clusters; i++) {
>> +               ci = si->cluster_info + i;
>> +               offset = i * SWAPFILE_CLUSTER;
>> +               end = min(si->max, offset + SWAPFILE_CLUSTER);
> IIUC scanning the whole device for one pending folio reclaim doesnt' look good..


Agreed. What I'd really like is a mark on the cluster itself, so the
worker only walks the clusters that need it (mentioned in commit message).
That needs more thought though, especially with Andrew's point about
backporting in mind, so I want to be careful there.


