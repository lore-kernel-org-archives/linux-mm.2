Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 91396C79FA1
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 16:22:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 85EFA6B008A; Mon,  7 Sep 2026 12:22:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7E7AC6B0092; Mon,  7 Sep 2026 12:22:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6B0726B00A5; Mon,  7 Sep 2026 12:22:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3D3E66B008A
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 12:22:12 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A24061201C2
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 16:22:11 +0000 (UTC)
X-FDA: 85187483262.13.20B4E36
Received: from mta1.migadu.com (out-161.mta1.migadu.com [95.215.58.161])
	by imf25.hostedemail.com (Postfix) with ESMTP id 513F9A000F
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 16:22:09 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=FLwudnI2;
	spf=pass (imf25.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.161 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788798129;
	b=K8jmv8gdLX6nIacnKGBEO3YJkqVMS5hqkcKW0DouI3S2gmEwArEchLMjfGGDQUUgWT9nUb
	fao2VJ4BuiudwuWG76frQ/SnAEI43uC4n7DWLjzZ5kF/aRXaCzEWJi6R6pBnKxmEE7wulV
	ma78FqOeDVIu6eoQSuVyuLBDvh68o6s=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788798129;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YK+SLDbYCEGbna3Gwz1GSPEBRsIFmpZ9c3t0iOtpysE=;
	b=vlkUHfk7kmZcOOWep1tDUOCyav8anyUvTm1suBB9zEudWFRudjHd9vaQgRvsSN0jgKWFqS
	yehtfyyCAioBwVgMLvLxc5you4FWdeUbWbnjnCaD9mV3BitzIj9uJOlXyv6ih5A5xsAyDq
	vzJdLBVULixdBagwIWGO0KGaxMrHyQs=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=FLwudnI2;
	spf=pass (imf25.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.161 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=Z64/Ehd9ihFSWachz7g/AkEEVAqCuvrLEXtG44Yl9zU=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788798127; v=1; x=1789402927;
 b=FLwudnI2L2GmSLVxDQzfLrINNReODh/OGdrQ7CBwRqiyM6qwmnHCaWjbfUYFuUWLfat5Br0J
 BuH0yP4xUK3Ih2C9B8s7TyYklshdyZWqlaXQF5A55vtUO4cSr3rBvNun/7MRzoqJABsAvvxrupe
 DcoNyRps/UHXKkmzHqbOrVk4=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 2f1e3352eedca130;
	Mon, 07 Sep 2026 16:22:07 +0000
X-Mizu-Trace-ID: 2f1e3352eedca130
X-Migadu-Flow: FLOW_OUT
Message-ID: <17b08370-b50e-4565-87c0-b92c84a312b6@linux.dev>
Date: Mon, 7 Sep 2026 17:22:01 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/1] mm/zswap: enable static key after runtime pool
 recovery
To: Yosry Ahmed <yosry@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Longlong Xia <xialonglong2025@163.com>, hannes@cmpxchg.org,
 nphamcs@gmail.com, chengming.zhou@linux.dev, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org,
 Longlong Xia <xialonglong@kylinos.cn>, Alexandre Ghiti <alexghiti@fb.com>
References: <20260905125101.2970456-1-xialonglong2025@163.com>
 <20260905160926.9836f2ca0dc977b89f2f146e@linux-foundation.org>
 <CAO9r8zPhMw=2+wyRYwbBS4As-zNbVnkcT3Y2ppqLo1AxPzaTAQ@mail.gmail.com>
 <b00822a4-87ce-47d7-ba63-21a7b99980af@linux.dev>
 <CAO9r8zMxF7tH4LkATd5pQvyvQ5KTCqKTxafsu5wQcad5tRsc1g@mail.gmail.com>
Content-Language: en-US
From: Usama Arif <usama.arif@linux.dev>
In-Reply-To: <CAO9r8zMxF7tH4LkATd5pQvyvQ5KTCqKTxafsu5wQcad5tRsc1g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 513F9A000F
X-Stat-Signature: 3qnbkgamm1n1i1zd4y34zykt53d35834
X-HE-Tag: 1788798129-915931
X-HE-Meta: U2FsdGVkX19CCiKToCyIH8vz2uOBt7sTFnQkICcc76H4+ePGwVy5LYqtcB59+umpZJiof2Jug9I2LnaQvDy219blRW5KN1quuo2uUd7tQusWOjPhQ5NLiwklwr0OsmLySR8LHOI0lGiwj54eHjO9UpCo5qonIyfJtaIG5haZ5kJwOscOjtob97utww4pGzPB8xaJX2Ulg/OYhhWjZvBX0Tx78QBZvBIO+A7sU2hoHFb2RhaPhBFP8oVybB5w3hDcADcwAFfmzAbzE9HgE8Twt8HzODMe5mIJRM53KQ6R2odpGFVn/b1Wj2XaYBXTnjJulSB7YXPT0Fnqjq5VYjHfOEMln/nxx68Gvy3UlzmwhOYGkWIgZ+Q9W8CpEcluwjWv2tigPLU0JquwBVzmhIPOnxJbfdcAmT7uUCVEYTOnhx7oBuLhHja076JpwWEAg0be/5YyvEG6DgDUpCui/ZVyJ/k7PxqXfOYbmbOMLgevSLqN2ALhAPOBhzUzoHFPDNefj73UP4u32URecRfP8BAbMAGpsrz01pMC4c2L0mHT/DFjcs65l8bKZfP+Ld8vhwn7MuDUOZ1tYlsKB/4q1LrivklO1Qj0SUQZdLsub8hn3Op01+wQpkAg5TzTNc6T7nJz48bXrK5w//NU59wnfyqFWquuZ33SrTbEJHZdWZ/BBlm9moRiP7CItmNkhrxjEkZgTaMqFF1bitQdM9GR1VMNATGUEEV1Pnef0bcp8lRPVcY8r4LpdX5mDxG3pek8EHB1N4ocpWCbO0LAzFg5azCHrWgXO5DOrjCVrLWK2gGiNFrPwINcNQB3bhyghTA4pVrLaCWNqJVqWkBgRE6C2JW0GX43gDjNPLTR6G88Sxtq7EqVjzXyN/ZOZrvJXg56wss5uXklhOMKL1+0bWVqYci2MugUlqRS+139SOn6UqXZCg2ptz+DVnuTJ3uX91ERv/r6JBY6+jFgqoTCGqa7qzs
 u4zQh6HN
 TLFrLdajSRAJCwCLh3pX2g++1PpRF0Jv8Ls0YME2Lt2JBNFrd7jHCBFfmUUC8U7+EJlp9DD7Tu1kxtQTJ1TdlWBULyVe0AM0oCRzJoRjKOw7Z7SPKAD9jyWvqs4UhP2Xa81VKdwbA210ZC12eEtptg5nJwpCmRb/kR2QA42Jnl+XVIrWKLdQNKqfcnRqtpTwlhnR51hkTprr/K7DKqh+V8iaI1c1GsTEbgHJXrgLVuilDDCWQ7oixSpq4bwGC+I4HS+bT3SeDH0OKM/Ixy2ENvZQg51ZRqejUIp42rMBnokvXH5YR6Qn74KfjMsIySKaAIQOLhWjVIhe1ckTea69JupQJ5BwF0LYljWBzXVkgUpFj6XtDjCOF7flpMqQwRWAJv42UGSs3lTu4MIKqNKmzrijqBg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 07/09/2026 12:34, Yosry Ahmed wrote:
>>>> And thanks.  Sashiko might have found another issue in this zswap code:
>>>>         https://sashiko.dev/#/patchset/20260905125101.2970456-1-xialonglong2025@163.com
>>>
>>> Hmm I think this might be fixed by Alexandre's patch (in Usama's
>>> series): https://lore.kernel.org/linux-mm/20260818131202.494754-6-usama.arif@linux.dev/.
>>>
>>> Instead of always returning -EINVAL for large folios we only do so if
>>> they are actually in zswap. Usama/Alexandre, assuming I got this
>>> right, can I interest you in sending the zswap bits of that patch as a
>>> standalone fix? :)
>>
>>
>>
>> Hello!
>>
>> Below is what the patch looks like in my tree now. It can be sent independently of
>> the PMD swap series. Yosry if you are happy with it, will send it on the list
> 
> Would you be able to send the zswap bits only as a standalone (and
> hopefully backportable) fix to the issue Sashiko surfaced?


Yes, have sent it in https://lore.kernel.org/all/20260907161938.1932355-1-usama.arif@linux.dev/.

> 
>>
>> From a5b70b6d72eda15bd7a16b8fc51db1d271b08520 Mon Sep 17 00:00:00 2001
>> From: Alexandre Ghiti <alexghiti@fb.com>
>> Date: Wed, 22 Jul 2026 08:19:35 -0700
>> Subject: [PATCH 01/19] mm: zswap: add range lookup for large-folio swapin
>>
>> A large folio reaches zswap_load() only when the caller expects
>> the whole range to be on disk. Zswap still stores large folios as
>> independent order-0 entries, so reconstructing a large folio from
>> zswap entries would risk returning partially initialized data.
>>
>> Teach zswap_load() to scan the covered range. If no slot is in zswap,
>> return -ENOENT so swap_read_folio() reads the backing device. If any
>> slot is still in zswap, fail the large-folio read so the caller can
>> fall back to per-page swapin.
>>
>> Return -EIO rather than -EINVAL for that conflict. Large-folio loads
>> are now valid requests; the error means zswap cannot safely satisfy
>> the request from partial per-page compressed state, not that the
>> request is unsupported. Existing callers only distinguish -ENOENT,
>> so this is a semantic clarification rather than a behavioral change.
>>
>> Add zswap_is_present() so PMD swap-entry consumers can make the same
>> range decision before attempting PMD-order swapin. For high-order swap
>> cache allocations, check the zswap range after inserting the folio into
>> swap cache. The insertion stabilizes the range against zswap store and
>> writeback; if pre-existing per-page zswap entries are found, remove the
>> folio through the existing allocation rollback path and return -EBUSY.
>>
>> Signed-off-by: Alexandre Ghiti <alexghiti@fb.com>
>> Signed-off-by: Usama Arif <usama.arif@linux.dev>
>> ---
>>  include/linux/zswap.h |  6 ++++++
>>  mm/swap_state.c       | 29 ++++++++++++++++++++-------
>>  mm/zswap.c            | 46 +++++++++++++++++++++++++++++++------------
>>  3 files changed, 61 insertions(+), 20 deletions(-)
>>
>> diff --git a/include/linux/zswap.h b/include/linux/zswap.h
>> index 30c193a1207e1..cd9efcf9dec94 100644
>> --- a/include/linux/zswap.h
>> +++ b/include/linux/zswap.h
>> @@ -35,6 +35,7 @@ void zswap_lruvec_state_init(struct lruvec *lruvec);
>>  void zswap_folio_swapin(struct folio *folio);
>>  bool zswap_is_enabled(void);
>>  bool zswap_never_enabled(void);
>> +bool zswap_is_present(swp_entry_t entry, unsigned int nr);
>>  #else
>>
>>  struct zswap_lruvec_state {};
>> @@ -69,6 +70,11 @@ static inline bool zswap_never_enabled(void)
>>         return true;
>>  }
>>
>> +static inline bool zswap_is_present(swp_entry_t entry, unsigned int nr)
>> +{
>> +       return false;
>> +}
>> +
>>  #endif
>>
>>  #endif /* _LINUX_ZSWAP_H */
>> diff --git a/mm/swap_state.c b/mm/swap_state.c
>> index b76eb3d876fd7..103ae7ae8a4a6 100644
>> --- a/mm/swap_state.c
>> +++ b/mm/swap_state.c
>> @@ -12,6 +12,7 @@
>>  #include <linux/kernel_stat.h>
>>  #include <linux/mempolicy.h>
>>  #include <linux/swap.h>
>> +#include <linux/zswap.h>
>>  #include <linux/leafops.h>
>>  #include <linux/init.h>
>>  #include <linux/pagemap.h>
>> @@ -459,16 +460,21 @@ static struct folio *__swap_cache_alloc(struct swap_cluster_info *ci,
>>         __swap_cache_do_add_folio(ci, folio, entry);
>>         spin_unlock(&ci->lock);
>>
>> +       /*
>> +        * Once the folio is in swap cache, zswap cannot start storing or
>> +        * writing back any slot in the range. Reject high-order allocations
>> +        * that raced with pre-existing per-page zswap entries.
>> +        */
>> +       if (order && zswap_is_present(entry, nr_pages)) {
>> +               err = -EBUSY;
>> +               goto delete_folio;
>> +       }
>> +
>>         if (mem_cgroup_swapin_charge_folio(folio, memcg_id,
>>                                            vmf ? vmf->vma->vm_mm : NULL, gfp)) {
>> -               spin_lock(&ci->lock);
>> -               __swap_cache_do_del_folio(ci, folio, entry, shadow);
>> -               spin_unlock(&ci->lock);
>> -               folio_unlock(folio);
>> -               /* nr_pages refs from swap cache, 1 from allocation */
>> -               folio_put_refs(folio, nr_pages + 1);
>> +               err = -ENOMEM;
>>                 count_mthp_stat(order, MTHP_STAT_SWPIN_FALLBACK_CHARGE);
>> -               return ERR_PTR(-ENOMEM);
>> +               goto delete_folio;
>>         }
>>
>>         if (order > 1 && folio_memcg_alloc_deferred(folio)) {
>> @@ -492,6 +498,15 @@ static struct folio *__swap_cache_alloc(struct swap_cluster_info *ci,
>>         /* Caller will initiate read into locked new_folio */
>>         folio_add_lru(folio);
>>         return folio;
>> +
>> +delete_folio:
>> +       spin_lock(&ci->lock);
>> +       __swap_cache_do_del_folio(ci, folio, entry, shadow);
>> +       spin_unlock(&ci->lock);
>> +       folio_unlock(folio);
>> +       /* nr_pages refs from swap cache, 1 from allocation */
>> +       folio_put_refs(folio, nr_pages + 1);
>> +       return ERR_PTR(err);
>>  }
>>
>>  /**
>> diff --git a/mm/zswap.c b/mm/zswap.c
>> index 37f34e406c8e3..32671dc2bf84d 100644
>> --- a/mm/zswap.c
>> +++ b/mm/zswap.c
>> @@ -1571,6 +1571,23 @@ bool zswap_store(struct folio *folio)
>>         return ret;
>>  }
>>
>> +/**
>> + * zswap_is_present() - is any slot in [entry, entry + nr) in zswap?
>> + * @entry: base swap entry of the range
>> + * @nr: number of contiguous slots to check (pass 1 for a single-slot query)
>> + */
>> +bool zswap_is_present(swp_entry_t entry, unsigned int nr)
>> +{
>> +       pgoff_t offset = swp_offset(entry);
>> +       struct xarray *tree = swap_zswap_tree(entry);
>> +       unsigned long index = offset;
>> +
>> +       if (!nr || zswap_never_enabled())
>> +               return false;
>> +
>> +       return xa_find(tree, &index, offset + nr - 1, XA_PRESENT);
>> +}
>> +
>>  /**
>>   * zswap_load() - load a folio from zswap
>>   * @folio: folio to load
>> @@ -1578,13 +1595,9 @@ bool zswap_store(struct folio *folio)
>>   * Return: 0 on success, with the folio unlocked and marked up-to-date, or one
>>   * of the following error codes:
>>   *
>> - *  -EIO: if the swapped out content was in zswap, but could not be loaded
>> - *  into the page due to a decompression failure. The folio is unlocked, but
>> - *  NOT marked up-to-date, so that an IO error is emitted (e.g. do_swap_page()
>> - *  will SIGBUS).
>> - *
>> - *  -EINVAL: if the swapped out content was in zswap, but the page belongs
>> - *  to a large folio, which is not supported by zswap. The folio is unlocked,
>> + *  -EIO: if the swapped out content was in zswap but could not be handed
>> + *  back, either because decompression failed or because a slot in a
>> + *  large-folio range is unexpectedly still in zswap. The folio is unlocked,
>>   *  but NOT marked up-to-date, so that an IO error is emitted (e.g.
>>   *  do_swap_page() will SIGBUS).
>>   *
>> @@ -1605,13 +1618,20 @@ int zswap_load(struct folio *folio)
>>                 return -ENOENT;
>>
>>         /*
>> -        * Large folios should not be swapped in while zswap is being used, as
>> -        * they are not properly handled. Zswap does not properly load large
>> -        * folios, and a large folio may only be partially in zswap.
>> +        * A large folio reaches zswap_load() only when its whole range is
>> +        * expected to be on disk: PMD swap-entry consumers split before
>> +        * calling into PMD-order swapin whenever any slot is still in zswap.
>> +        * Confirm the range is entirely absent from zswap and return -ENOENT
>> +        * so the caller reads it from disk; if a slot is unexpectedly still in
>> +        * zswap, fail the read rather than return partially-initialized data.
>>          */
>> -       if (WARN_ON_ONCE(folio_test_large(folio))) {
>> -               folio_unlock(folio);
>> -               return -EINVAL;
>> +       if (folio_test_large(folio)) {
>> +               if (WARN_ON_ONCE(zswap_is_present(swp,
>> +                                                 folio_nr_pages(folio)))) {
>> +                       folio_unlock(folio);
>> +                       return -EIO;
>> +               }
>> +               return -ENOENT;
>>         }
>>
>>         entry = xa_load(tree, offset);
>> --
>> 2.53.0-Meta
>>
>>


