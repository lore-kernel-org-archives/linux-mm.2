Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 26254CDB466
	for <linux-mm@archiver.kernel.org>; Thu, 25 Jun 2026 07:23:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1985C6B00D8; Thu, 25 Jun 2026 03:23:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 16FB66B00D9; Thu, 25 Jun 2026 03:23:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 061506B00DA; Thu, 25 Jun 2026 03:23:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D23946B00D8
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 03:23:11 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 66C4E1674CC
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 07:23:11 +0000 (UTC)
X-FDA: 84917593782.26.2C3B8AB
Received: from relay8-d.mail.gandi.net (relay8-d.mail.gandi.net [217.70.183.201])
	by imf17.hostedemail.com (Postfix) with ESMTP id 450BA40002
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 07:23:09 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	spf=pass (imf17.hostedemail.com: domain of alex@ghiti.fr designates 217.70.183.201 as permitted sender) smtp.mailfrom=alex@ghiti.fr
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782372189;
	b=DChLEaaQE5lJCxw6gkmq4LA3KXVWUXPUS45v3yiv3eqMrlEFaC8HLhREoBJJRma63q4J9T
	CfqZzVlRFNJTvXBEAA73kjCF3td9+AjNRvciG8bEIfCA7sATA+o/gxiXM11ykB8m5G1NSM
	wVhmb1P/ETLiStwgYBlibUCvMW4N/8M=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782372189;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=S6/MUdh9neZ3jrA6IgsLgFgrWPcOabzXidh9SQbI8+E=;
	b=oxzbZ8Cp2JR9q88gvvnYsjVUtm4XDWAMg6ryhWh4wXmX+sIxTcdeEZyv0oOKC5ORzIYxQD
	SihD1pXiAbXgHg4cPB111wp1vJDegKnh1ULW+fpFvWDjv49nl1FGG/3/LtULD4GQn6wopL
	pOxvtVzkrAuZnvpQiieSAylC+wbMbLw=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=none;
	spf=pass (imf17.hostedemail.com: domain of alex@ghiti.fr designates 217.70.183.201 as permitted sender) smtp.mailfrom=alex@ghiti.fr;
	dmarc=none
Received: by mail.gandi.net (Postfix) with ESMTPSA id 7FD1F3ECDE;
	Thu, 25 Jun 2026 07:23:03 +0000 (UTC)
Message-ID: <4acb4206-1dc5-4803-afb1-1a940e3fb89b@ghiti.fr>
Date: Thu, 25 Jun 2026 09:23:02 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH] mm: bypass swap readahead for zswap
To: Kairui Song <ryncsn@gmail.com>
Cc: akpm@linux-foundation.org, hannes@cmpxchg.org, yosry@kernel.org,
 nphamcs@gmail.com, chengming.zhou@linux.dev, david@kernel.org,
 ljs@kernel.org, liam@infradead.org, vbabka@kernel.org, rppt@kernel.org,
 surenb@google.com, mhocko@suse.com, chrisl@kernel.org, baohua@kernel.org,
 usama.arif@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260624075700.751467-1-alex@ghiti.fr>
 <CAMgjq7CfMp_7bhDWirUmxM0pFzk6d9in9h6wuHsMoeUu-+TC_Q@mail.gmail.com>
Content-Language: en-US
From: Alexandre Ghiti <alex@ghiti.fr>
In-Reply-To: <CAMgjq7CfMp_7bhDWirUmxM0pFzk6d9in9h6wuHsMoeUu-+TC_Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-GND-Sasl: alex@ghiti.fr
X-GND-Score: 0
X-GND-Cause: dmFkZTFSm4vxa+rPJnVGGTFqS5imGRrEGQFdaFNUOkShOTrZeb9R4SBoyv5SJ5DNNb67ObECM1XaEUSb+OiO8QPSMSzwQ9jKfG3z9AtWM+YhYJ//nroeIrPzyJ71WMbaGq8HSPLshVRRa/RrXdNugfPIdARST1IilFx8ydwGP1ju2BX4SKieLXFvelr979qsQnmw3Y4PvcW3l4YOlUcA9vLRNQObwwagVex8jMmyovDpd20Wl2lHUSf/i1HxOotgWoD0U796hGBSlB+u7x7K6cn1bPi6g78UkutBZy8LYJDGtazmr5iKHkaIGnNtrEZ4Na1N39WQJ7Sw3TQfUMBaTANz/eHwcRs0uhNkvkZJNtWXDIQYLoZi+P6tD0/0VfCtEKqo5AO4HTsZFNifT49ECm0tB4s7NL4154LQdKUDv+wEpIWkygw35G3mqtWmZ5n8tiMqHnIIGzBO971mwqaABxsS+x6xYoxFGHWHzuDBkr6Mdf1pGGjAI8YaTzkaYbKm83/UwiqMC/GX28VBAM/ExcIiOB0POuSAG4owXE13PWUSrtvsVEHhg9xb2EhNetujLj4guG0ELXhfYQMBsHy3+V8DDp3V2WuvKIXbjPTzQUZI7Ba6E+nVrvG4OcgwM6DYgHnQRPD4LUxarfJYc4rJwYoxuwAdx+oQkuy+/wEZF0TOY6WuIQ
X-GND-State: clean
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 450BA40002
X-Rspam-User: 
X-Stat-Signature: rxuy9bz8cw59dqcg9g9qc5kzrxunyse4
X-HE-Tag: 1782372189-673959
X-HE-Meta: U2FsdGVkX1+WJeXZLMmaxcDWedyxhCKGOjYhyg4YIxXZQTwhga+XbMTrZkdUG0Q6G10ZBqlPbSe9IBAFyQeWqG2Fdrm4NQs65dC8I97d1BGp8ZHZFcb7xI3V2zCiKuS9YE3/yA4UzWJIyE9PgZndBJgmWXPkRvwQCEWGB55tt8GNcLeoXiVF+eajW8VFR8l0Ibvrq/xE61WQSllc/eT3P7A1gqRGDgy4En/zYJpWXS+p7Sc0UF8aK68qRyIkPVoBYASNuxIEVERgg5huoRBynjEVkmLSzWCdUwmTTUO0OAgx7YB6Ja0avUCLpaSXdIUzBJ5OYrUzhfoIDLPhCpkHdLcAm70s7bcgr/lBotOomIMD5mqcD5wodBh1uploGOayeGkr75FTKkdCJsEbunqTP9mTwyEmIeeISPCFZfArNVs06/Emh2huNbawNv1zEnwqmVkvU1k6T6aSp1alVkWNT3Wu7H0Q5hzy0+NVwypyJnUmy5C5ZrljuSdmh6Swx4bJ9IY6dnSblWmQFB7U94Rd8Tve3uknyOfsYVxF8nmnTdsdKTlCJRMxZWc01o43eUgbImKvXDmpEy4h6sOudprXvtaVrmlmyK7aQ5mM4oAKLTnFxtGp3+Lqcq4IpRpLMNNb5/yPs5VxZCwPTOqjLwmKsWoOihoU6PDlttNdHgvARmlKfPaW3s+h2fKpGozsf/OP8hraGf6kpRmfqkN6wu6Yq4fWouxldd6v0zDfeZlcdeQ0yWKlitqXfTpoz3rzAXcQ8AYoAsbdGEJkn4VejW9PcWZPmXjpHKRY/Tpsg5WH9cIZvzJjtMbxGBE3pk1jVx8tMKF/lDcIeoDNopaIJruduRFbIS4b4/cs0qWvDRpXMFiIlIbA5UqFgiru/CluwEfPP7U1+zBlfMo2gNhaNDfIL6HrQFM0BkwBnik5HG77JlUy4zqOnmTRqyFzqQQnAozKDfALTPUH6fJmzup8ujY
 p6lc909Q
 WhvwwRIg7I/LrVZHhkP5u0hvkQqjew9IETewVIyqWT9SyAn439Dt6GSDaSkAlKDISM5GVox+ZrChF6vwrQk6Jdn2ealH9hLHyZjnD4qNuBdu3kLIReSFxAftEP3We3YpGuRJ1
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Kairui,

On 6/24/26 12:30, Kairui Song wrote:
> On Wed, Jun 24, 2026 at 3:59 PM Alexandre Ghiti <alex@ghiti.fr> wrote:
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
> Hi Alexandre
>
> Thanks for the test and patch, very interesting idea.
>
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
>> +{
>> +       return xa_load(swap_zswap_tree(swp), swp_offset(swp));
> Better check zswap_never_enabled first to avoid a xa_load if not needed.


You're right, I'll add that in the v2.

Thanks,

Alex


