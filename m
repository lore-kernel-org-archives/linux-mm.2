Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AD10CCDB47F
	for <linux-mm@archiver.kernel.org>; Thu, 25 Jun 2026 07:42:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A26A06B00A3; Thu, 25 Jun 2026 03:42:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9B02E6B00F3; Thu, 25 Jun 2026 03:42:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8A0726B00F5; Thu, 25 Jun 2026 03:42:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 5AEAB6B00A3
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 03:42:18 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id BB0C1C289A
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 07:42:17 +0000 (UTC)
X-FDA: 84917641914.19.D0AB1AF
Received: from relay6-d.mail.gandi.net (relay6-d.mail.gandi.net [217.70.183.198])
	by imf30.hostedemail.com (Postfix) with ESMTP id 9589580006
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 07:42:15 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	spf=pass (imf30.hostedemail.com: domain of alex@ghiti.fr designates 217.70.183.198 as permitted sender) smtp.mailfrom=alex@ghiti.fr
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782373335;
	b=iOflpeEOmB0RoAys5gNaYGUVQ6MrVFVB9el8pSTtw17N0Ue1m3t5SNaBRASZD+87HJWxcB
	sgOAZts0t239q8p4oZLn/wAYGeS5hbJn0gtTkmoFrEZgdB08zq50PRbaNTRRPzabxZtrSR
	aczfzPkKXy9u4qx7e/icKqlXRj0Di6A=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782373335;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ysQ1AutjF3HgFCwG/Yl7AaqE4XuoN5VtbHuSzw1G7LE=;
	b=aIeinCnUpPShKyEKhQypNc5NRMBihPz7D0eura7UTtWd5BSnQB6VrgO+4a7n1/XmHd7G7n
	PDs1A90+vEqxkq7H1EGZ1zJOrukUEB1op2QSKDgLvmIcNHcki8IgkerpIPG6e9/4HSrVkn
	XBGmYvVahoqPP/uljFQKJXUVusaxMeU=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=none;
	spf=pass (imf30.hostedemail.com: domain of alex@ghiti.fr designates 217.70.183.198 as permitted sender) smtp.mailfrom=alex@ghiti.fr;
	dmarc=none
Received: by mail.gandi.net (Postfix) with ESMTPSA id 8B6633EDA8;
	Thu, 25 Jun 2026 07:42:10 +0000 (UTC)
Message-ID: <96b9f86a-d127-4e90-8ced-9149719a28ef@ghiti.fr>
Date: Thu, 25 Jun 2026 09:42:09 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH] mm: bypass swap readahead for zswap
To: Yosry Ahmed <yosry@kernel.org>
Cc: akpm@linux-foundation.org, hannes@cmpxchg.org, nphamcs@gmail.com,
 chengming.zhou@linux.dev, david@kernel.org, ljs@kernel.org,
 liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, surenb@google.com,
 mhocko@suse.com, kasong@tencent.com, chrisl@kernel.org, baohua@kernel.org,
 usama.arif@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260624075700.751467-1-alex@ghiti.fr>
 <CAO9r8zNni28A+9BiDgDTBRuvGTKnqH91kpbpjjeftfnKSeSOJg@mail.gmail.com>
Content-Language: en-US
From: Alexandre Ghiti <alex@ghiti.fr>
In-Reply-To: <CAO9r8zNni28A+9BiDgDTBRuvGTKnqH91kpbpjjeftfnKSeSOJg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-GND-Sasl: alex@ghiti.fr
X-GND-Cause: dmFkZTFTnLYT8n0uWWP1+V3+HeDTng3vPJpb403+3gIToV7ghLBRdPm1iIkXEa819A0U9GJeAbk/0SWQaLZeodDdMisJy4JcP6+E/lqxzXJARee69TXsFdR81qjglUs7rMNaFmcThNUS6DchZAXSOo4Tu3L/BV+1JsKwK5O7aRhyuaBOOLhshyo9DPNSBI8oLo5p8KiLo/QPm6JCet+nNzQ09HLys42qsjPktVIO1RxzztXWUAQsFXSaHVFgYZ5i42Yti4jxYH5HUi3qwwPYl8NNZyBuUz8o+8+2T4aBekItq+kHncZtLvoQKbztypjcOLUZGqe+0k/yJHI0JCtm37fHNLhbN1aojnz1raY5X9FcaR275rSYYbe8YArQBAdf/EcK1PchMgbr1KB64iBkvBqbmr5YfJ4puXkZ4REGSW5yQqzwoC8bAGOqkFMqZbOuhiMDi5GzoAhghcQVE6pTVfmEndS9rR1+tSOf7EJh1aBZ1yTgbLBe7IRA8gXGkbQGGa2fOgRt/Lhl3MskkkISrMdYBfaIYru8rh5n9wcYLLIVXKW24ZqSSY9uFBFAA7TD3W3ZDbjd70H50xpin/FCxRtEPTUU82HhOP3XOcK38tAtdAJBXtmP0YxEkTcamNi2xLN/BlgohaEEqYZcDHXY9pXjBWGbg681g6tvBRe8kwGTsBiW8g
X-GND-State: clean
X-GND-Score: -100
X-Rspamd-Queue-Id: 9589580006
X-Stat-Signature: hi1abfhhwrgpksbyzn657wkpdqrfonwx
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1782373335-404868
X-HE-Meta: U2FsdGVkX19FGlXB5Q92Fzk7T5HinFGt6hAnaXLI5QqtRwd3sO1jXvqdCh9375T6iO68ucBKOz1rH5F6bz5mTATpg0nm+ovQKiZYAdLRifo1PeoComKnBlWMitis5sxkYxGbcPpUZi/RJRwIXKShTL9OR6gI75NiachbmI9W9buSDapBkyjKtacu0XU3oDb6XB3cb3tqwhiPd6PuwAh4iVvdRXTa9W6L1s2aZuegZcrYg2aPscJUHFwaEMyEoSuaCUuRkBbwprFh4O41esRFxD80IpVnFtTBmwNrrwbN6LIIQoq6j5pLExFDQuAJMfFLzGf+vonUbW7Oz3KmJPhPINuBqFQvGxXGa9fGzEMFvGMbpDjEQ2jnoN7w5vkUqQ878Y5W92NND7J4/13UNPvBVvVhxGCARnIgsGGVq678WcFrhtiNx0C1SOXmEJuc0ae/996MOXlAsgAvjR46jv9pTmn+5LS7wn8m5KsrA3PcYyt/3sVmIOccmbcnP4zuqFlQYoJNaq1Te6RRgeE9QHfVBhi8NCqhyNdSZaOpjuOtIWHJHX8/ypwAjnE5YZg+/pwmOtQsN4pftYGRQxOjn4kCqPEJVC3rMKzAjR0nmwrxvmYjNJAykiMYjggqzamDq04BK6k+T6fxU7RENnrMYZNxqJWxklTcrKnYD3mNTr4CPsFcOLd5dcXkZESjR098aQq2dPW06WKpjNXli03AYAj/PVB9CPlXwTiLBaN25hnHb4jO9LGQAIVIAfd/XP+9Meh4tvkn/57/loG9Zgg6ZyHkA+iTeTW5j1fs0TFXrstctxDMwkXxMYk+5Y6uMlDc2VtGpaktPlJEWwTCsBSlL0IcWM+9cW2D1AGy681DBYS/+RcySN/KyKf2n8/n0TL6eYjCVFhEdv3HMPT5733hp4X2ZBzodYaW10yfVm0xuyZjiOUkrVEa5tYr61915Ta+DCn5jKAmj7oXmrSxqp9OrBq
 FEhe5tST
 HF8WLbevZqS5h1jsc5SEIYAwVe4fgAzne3hC/VCohPlZEtnshgN582y3qMCsyrVu/uOHbASpL+/0dTLo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Yosry,

On 6/24/26 20:01, Yosry Ahmed wrote:
> On Wed, Jun 24, 2026 at 12:57 AM Alexandre Ghiti <alex@ghiti.fr> wrote:
>> Commit 0bcac06f27d7 ("mm, swap: skip swapcache for swapin of synchronous
>> device") made SWP_SYNCHRONOUS_IO devices (e.g. zram) skip swap readahead.
>>
>> zswap is the same kind of in-memory, synchronous backend as zram, not a
>> swap device flagged SWP_SYNCHRONOUS_IO so it still goes through
>> swapin_readahead().
>>
>> Here are the results from bypassing readahead for zswap too: it was
>> measured with a kernel build (make -j16) in a memcg, zswap=zstd, shrinker
>> off, on Sapphire Rapids and 3 iterations.
>>
>>    768M memcg (sustained swap thrash):
>>      metric                 mm-new    + bypass    delta
>>      build time (s)          405.0       341.7    -15.6%
>>      zswap-in (GB)            79.5        53.0     -33%
>>      zswap-out (GB)          144.8       115.6     -20%
>>      swap readahead (pages)  6.79M       0.45M     -93%
>>      swap_ra hit (%)          72.1        89.9     +18pp
>>
>>    1G memcg (light pressure, build not memory-bound):
>>      metric                 mm-new    + bypass    delta
>>      build time (s)          177.7       176.0    ~same (no regression)
>>      zswap-in (GB)            10.2         7.5     -26%
>>      zswap-out (GB)           27.7        25.1      -9%
>>      swap readahead (pages)  1.07M       0.08M     -93%
>>      swap_ra hit (%)          68.6        87.2     +19pp
>>
>> The gain is from no longer prefetching pages that are pointless for an
>> in-memory backend: readahead inflates anon residency and thrashes the
>> page cache (file pages get evicted and re-read), lengthens each fault by
>> synchronously (de)compressing a cluster of neighbours, and adds
>> compression traffic when those extra pages are reclaimed.
>>
>> Bypassing swap readahead for zswap therefore makes sense.
>>
>> Signed-off-by: Alexandre Ghiti <alex@ghiti.fr>
>> ---
>>
>> - This bypass originally comes from Usama's series that implements
>>    large folio zswapin: while working on improving this series, I noticed
>>    the gains I got only came from the bypass of readahead.
>>
>>   include/linux/zswap.h |  6 ++++++
>>   mm/memory.c           |  5 +++--
>>   mm/zswap.c            | 11 +++++++++++
>>   3 files changed, 20 insertions(+), 2 deletions(-)
>>
>> diff --git a/include/linux/zswap.h b/include/linux/zswap.h
>> index 30c193a1207e..b6f0e6198b6f 100644
>> --- a/include/linux/zswap.h
>> +++ b/include/linux/zswap.h
>> @@ -35,6 +35,7 @@ void zswap_lruvec_state_init(struct lruvec *lruvec);
>>   void zswap_folio_swapin(struct folio *folio);
>>   bool zswap_is_enabled(void);
>>   bool zswap_never_enabled(void);
>> +bool zswap_present_test(swp_entry_t swp);
>>   #else
>>
>>   struct zswap_lruvec_state {};
>> @@ -69,6 +70,11 @@ static inline bool zswap_never_enabled(void)
>>          return true;
>>   }
>>
>> +static inline bool zswap_present_test(swp_entry_t swp)
>> +{
>> +       return false;
>> +}
>> +
>>   #endif
>>
>>   #endif /* _LINUX_ZSWAP_H */
>> diff --git a/mm/memory.c b/mm/memory.c
>> index ff338c2abe92..5aa1ea9eb48a 100644
>> --- a/mm/memory.c
>> +++ b/mm/memory.c
>> @@ -4827,8 +4827,9 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
>>          if (folio)
>>                  swap_update_readahead(folio, vma, vmf->address);
>>          if (!folio) {
>> -               /* Swapin bypasses readahead for SWP_SYNCHRONOUS_IO devices */
>> -               if (data_race(si->flags & SWP_SYNCHRONOUS_IO))
>> +               /* Swapin bypasses readahead for SWP_SYNCHRONOUS_IO devices and zswap */
>> +               if (data_race(si->flags & SWP_SYNCHRONOUS_IO) ||
>> +                   zswap_present_test(entry))
> This assumes that if the swap entry is in zswap, then the remaining
> entries (covered by the readahead window) will also be in zswap,
> right? While not very likely, it's possible that the remaining entries
> not in zswap but on disk, right?


Yes, I assumed locality here.

Indeed, it would be interesting to keep the readahead but only actually 
readahead swap disk entries. I don't know how this will affect the 
readahead window (it is computed from the number of PG_readahead hits 
iirc) but I can give it a try.


>
>>                          folio = swapin_sync(entry, GFP_HIGHUSER_MOVABLE,
>>                                              thp_swapin_suitable_orders(vmf) | BIT(0),
>>                                              vmf, NULL, 0);
>> diff --git a/mm/zswap.c b/mm/zswap.c
>> index 761cd699e0a3..5b85b4d17647 100644
>> --- a/mm/zswap.c
>> +++ b/mm/zswap.c
>> @@ -234,6 +234,17 @@ static inline struct xarray *swap_zswap_tree(swp_entry_t swp)
>>                  >> ZSWAP_ADDRESS_SPACE_SHIFT];
>>   }
>>
>> +/**
>> + * zswap_present_test - check if a swap entry is currently backed by zswap
>> + * @swp: the swap entry to test
>> + *
>> + * Return: true if @swp has a zswap entry, false otherwise.
>> + */
>> +bool zswap_present_test(swp_entry_t swp)
> zswap_is_present()?


Agree, the naming is not perfect, I'll change that to either your 
proposal or zswap_is_entry_present() (or something else), but I'll 
definitely change that.

Thanks,

Alex


>
>> +{
>> +       return xa_load(swap_zswap_tree(swp), swp_offset(swp));
>> +}
>> +
>>   #define zswap_pool_debug(msg, p)                       \
>>          pr_debug("%s pool %s\n", msg, (p)->tfm_name)
>>
>> --
>> 2.54.0
>>
>>

