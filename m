Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 701DCC61DB9
	for <linux-mm@archiver.kernel.org>; Sun, 30 Aug 2026 09:08:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 50BE86B0088; Sun, 30 Aug 2026 05:08:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4BD1E6B008A; Sun, 30 Aug 2026 05:08:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3D2B16B008C; Sun, 30 Aug 2026 05:08:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0915E6B0088
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 05:08:25 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 774EF802A5
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 09:08:25 +0000 (UTC)
X-FDA: 85157359770.18.1966E74
Received: from mta0.migadu.com (out-69.mta0.migadu.com [91.218.175.69])
	by imf12.hostedemail.com (Postfix) with ESMTP id 4359C40008
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 09:08:23 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=qr1GZV46;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf12.hostedemail.com: domain of ridong.chen@linux.dev designates 91.218.175.69 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788080903;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AhNLhP0niRo1iFZVbcpIIAPhATZL8XNvvgMnbrg6p20=;
	b=e3We3FZuvTZIRiD0Ey+9jXEBa+F3+vuluBsgkZ5cL2CQXZQHKSTLJZB5Ju4c0CNixJEVcZ
	WGghYFq7zQN805n+PaZNixGOXbIM8BkzZBTJUsxvNSs4jhSLrAkvbN1rVNVVpWaV44sBgD
	2I3gBH3lexnPofveaXOuu0AWOaRZ8sk=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=qr1GZV46;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf12.hostedemail.com: domain of ridong.chen@linux.dev designates 91.218.175.69 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788080903;
	b=qHm+czU11IpQD+m6eGMoIyU8PktjtWv6gatcr7xK7KhC61/Y/e7AzGAWgd+fN3p9207MyB
	QcWFbiunxDsEiZqPBy7S/oX0lwxvzNvoLHefEubd21Ls6n8Waes1Cn7Dw6nTCSKqBNh3mu
	K3HmVgQSzeLXTtvTKUtk6OxmphbOBgs=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=V2dtd4OYMUBexxYoOnaLyFCYO8Ylxw79o0cRyiJ0VzI=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788080901; v=1; x=1788685701;
 b=qr1GZV46n+ZUqk0jC9yht8q2rzFEtqcG7swKFr9ovvEkCzvQ0zzvHUYAoIChaIdOPz4njpLQ
 dKkYshLQi/3O++HcWSmPp18iH4lG/kIPc8Jl4tfbO8LACd1xTbDxCmsKYtdMlvX5ffkNDSHtksh
 Ct39qA6q0PR3C3aiyAWXa2Wk=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id b72dab2c1cd40654;
	Sun, 30 Aug 2026 09:08:21 +0000
X-Mizu-Trace-ID: b72dab2c1cd40654
X-Migadu-Flow: FLOW_OUT
Message-ID: <d270d063-027a-4297-bd0c-8f4a1eaf3f40@linux.dev>
Date: Sun, 30 Aug 2026 17:08:04 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 2/6] mm/mglru: introduce helpers for manipulating gen
 and refs flags
To: Barry Song <baohua@kernel.org>, kasong@tencent.com
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, Baoquan He <baoquan.he@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>,
 Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>,
 Muchun Song <muchun.song@linux.dev>, Chris Li <chrisl@kernel.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Yu Zhao <yuzhao@google.com>, Zi Yan <ziy@nvidia.com>,
 Qi Zheng <qi.zheng@linux.dev>, cgroups@vger.kernel.org,
 linux-kernel@vger.kernel.org, Kairui Song <ryncsn@gmail.com>
References: <20260826-mglru-flags-cleanup-v3-0-d9f1c75549c8@tencent.com>
 <20260826-mglru-flags-cleanup-v3-2-d9f1c75549c8@tencent.com>
 <CAGsJ_4yasRXO52K-13dx9ZXPw95wEyn2bpnf0NiQ2z56dxf-vQ@mail.gmail.com>
From: Ridong Chen <ridong.chen@linux.dev>
In-Reply-To: <CAGsJ_4yasRXO52K-13dx9ZXPw95wEyn2bpnf0NiQ2z56dxf-vQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Stat-Signature: u3om4iziuxd5j845zaaciyg73kpxbe3z
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 4359C40008
X-Rspam-User: 
X-HE-Tag: 1788080903-889881
X-HE-Meta: U2FsdGVkX1/ISsl88AsJHuY5JYERm1LN5tE9ztaRHazzgm8q5EosGXr1F4YESFz7WFfd74ky2l9yP56wHPDbGkXIdP+z+X9veTNIJbhT7E9Wn4Ifb3Z6x1xDSFCNq93mCm0KXV5kuSmnCeXQvaKfdS5xxxOoOVLQTvXrneksPg637DSJqckgUrK2E0RCsh02LLNzr9Q24a1K8zrlnahvF5Inxqx7uUmkzvdY9+GWdO9b7OehFH5zdVpgQattiy1A0Wbt+YcBBzIfFmRGmXcZB8DUy2MN0HGGEPcjRCvO0IF5DAO7dr6N/ghaH4rsdUOaP3zMPXaqMV3KZHsDlE9ZGswKeMZGR9euHDkhXEcHu45gKoRPHi0R4WA7IGCDfmH+rBQ3oqt6nt+OuGAp8qNq8ugoSl5RhL9xWX2jQVj9e9N8bCL6GISS5TbfRqRhhZufiMtmoJmWuA0aJJDJShIIU4aEkFh++OjhpMbpoh5FiWzyh9k7uWwtUmaMr0vUiVn3edKD0nsvsvV8JQNi0bZEJSpwuhJYG6mlAgGJzNx3gFIAVBliWwVvmlSLVvwyxkXbpj9Is4Yols9y0RwjCtjuKKcFnW9xTTl6/EWdCZyxcKKMWsI7SCrJglg1LmyJXsbsYREf4hXbZQasI8JZNCwMfhoRFxD+cFlWf9NF06RMDDoudwKL88ozMopbgGsiJNCsEioPeGx+p1Ptdx0rqhZc4n5Qw3MjsGVPKHssPqOMISWzd1kosMtlAb02cVLe9cV8FjdgB/HpQeY6SNcoQYMRPR3DHpmePC8T9JMXoYnDzPmu/FEdfcuBk5Z2MFhcCHp7Sgq5ndES9UNlcRpfbkQG30HBpGvfokVG0SSb9NYTdNbyWInLOIAFcZe2xKUpiYJPR+3PUn4cQb212HQv7WCDsZz1Xen/VzMIsyPWhvGOQ+hc459FnGmOtybmzt+XvA8/pSUC4vjV5d7pVFhGAyy
 uYAGFB8P
 ppIOyXDpXwEvwmRj8Ljiv1zP3A0iSPlVtnUKlWV3pXaa8zbEFum+ZI+lYV2Cl9fYkBNyk2SM6yjAFLoH2qurkBVG+EifMqvapivmXbyHkNdDJ0DqvbcODkdV23+ZmDG0++FT7kjY5qG/bKpmRdMCJ0c8x4+juAyXuma/os0r/qVk74ePB1sXgr8YM6QQyrAm9VYS8Q7EQEvqim0+ywzqCBuPmfTl2/CZyBP9Ew43T5RORbfrBT5tVdc4752ZvtxKCsnRi5k6na+WpM9DdEKF4UEgmstrvNs4r1Bz6DEQrTvKHqTpObc/eTzUaMRGjoTC5podcFAoc8v8VTR4VpeKV6LR02DqgOrtyFL4F
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 8/29/2026 12:21 PM, Barry Song wrote:
> On Wed, Aug 26, 2026 at 1:53 AM Kairui Song via B4 Relay
> <devnull+kasong.tencent.com@kernel.org> wrote:
>>
>> From: Kairui Song <kasong@tencent.com>
>>
>> Instead of doing bit ops on folio->flags.f, introduce helpers for
>> adjusting a folio's refs and generation info, making the code easier
>> to debug and understand.
>>
>> No functional change is intended: some combined atomic operations are
>> split into two, which only creates harmless transient states. There is
>> no measurable performance impact, and some paths even look slightly
>> better in the generated assembly.
> 
> Hi Kairui,
> 
> I like your idea. Overall, it looks good to me. With some cleanup,
> we might have the following:
> 
>>
>> Signed-off-by: Kairui Song <kasong@tencent.com>
>> ---
>>   include/linux/mm_inline.h | 76 ++++++++++++++++++++++++++++++++++++++++++-----
>>   include/linux/mmzone.h    |  1 +
>>   mm/folio.c                | 19 +++++++-----
>>   mm/vmscan.c               | 61 ++++++++++++++++++++-----------------
>>   4 files changed, 114 insertions(+), 43 deletions(-)
>>
>> diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
>> index 621c8653d8f7..edfaf2661812 100644
>> --- a/include/linux/mm_inline.h
>> +++ b/include/linux/mm_inline.h
>> @@ -142,10 +142,42 @@ static inline int lru_tier_from_refs(int refs, bool workingset)
>>          return workingset ? MAX_NR_TIERS - 1 : order_base_2(refs);
>>   }
>>
>> -static inline int folio_lru_refs(const struct folio *folio)
>> +/**
>> + * lru_gen_from_flags - Return the LRU generation number from folio flags.
>> + * @flags: folio flags
>> + *
>> + * Returns: A number between 0 and (MAX_NR_GENS - 1), inclusive. Returns
>> + * -1 if the flags indicate the folio is off the list (e.g., isolated).
>> + */
>> +static inline int lru_gen_from_flags(unsigned long flags)
>> +{
>> +       int gen = ((flags & LRU_GEN_MASK) >> LRU_GEN_PGOFF);
>> +
>> +       BUILD_BUG_ON(LRU_GEN_MASK & LRU_REFS_MASK);
>> +       gen -= 1;
>> +       VM_WARN_ON_ONCE(gen != -1 && gen >= MAX_NR_GENS);
> 
> Since `gen` is an `int`, it seems a bit odd to have
> `gen != -1 && gen >= MAX_NR_GENS` combined here.
> 

Agreed. Especially with the gen -= 1 right above, it took me a while to figure 
out what that actually meant.

> Do you actually mean the following instead?
> 
> VM_WARN_ON_ONCE(gen < -1 || gen >= MAX_NR_GENS);
> 

Maybe we could add a macro like the one I mentioned in my earlier reply:

GENS_UNREF -1

>> +       return gen;
>> +}
>> +
>> +/**
>> + * lru_gen_set_flags - Set the LRU generation number to specified folio flags.
>> + * @flags: pointer to the folio flags
>> + * @gen: generation number, between 0 and (MAX_NR_GENS - 1), inclusive.
>> + */
>> +static inline void lru_gen_set_flags(unsigned long *flags, int gen)
>>   {
>> -       unsigned long flags = READ_ONCE(folio->flags.f);
>> +       VM_WARN_ON_ONCE(gen >= MAX_NR_GENS || gen < 0);
>> +
>> +       *flags &= ~LRU_GEN_MASK;
>> +       *flags |= (gen + 1UL) << LRU_GEN_PGOFF;
>> +}
> 
> It seems that we are setting the gen in the flags, rather than
> setting the flags themselves.
> 
> The current name makes me think that the function is setting the
> entire flags field, especially since `lru_gen` is used as the
> namespace for various MGLRU functions, e.g.:
> 
> void lru_gen_add_mm(struct mm_struct *mm);
> void lru_gen_del_mm(struct mm_struct *mm);
> void lru_gen_migrate_mm(struct mm_struct *mm);
> struct lru_gen_folio;
> lru_gen_update_size(lruvec, folio, old_gen, new_gen);
> 
> However, this function only sets the gen bits in the flags.
> Maybe we could use a name that makes this distinction clearer?
> 
> Could they be named as below, or is there a better naming option?
> 
> set_gen_to_flags(unsigned long *flags, int gen);
> get_gen_from_flags(unsigned long flags);
> 
> Or something like flags_to_gen() or gen_from_flags()?
> 
>>
>> +/**
>> + * lru_refs_from_flags - Return LRU referenced / access count from folio flags.
>> + * @flags: folio flags
>> + */
>> +static inline int lru_refs_from_flags(unsigned long flags)
>> +{
>>          if (!(flags & BIT(PG_referenced)))
>>                  return 0;
>>          /*
>> @@ -155,11 +187,40 @@ static inline int folio_lru_refs(const struct folio *folio)
>>          return ((flags & LRU_REFS_MASK) >> LRU_REFS_PGOFF) + 1;
>>   }
>>
>> -static inline int folio_lru_gen(const struct folio *folio)
>> +/**
>> + * lru_refs_set_flags - Set the LRU referenced / access count to specified folio flags.
>> + * @flags: pointer to the folio flags
>> + * @refs: referenced / access count number, between 0 and LRU_REFS_MAX, inclusive.
>> + */
>> +static inline void lru_refs_set_flags(unsigned long *flags, unsigned int refs)
>> +{
>> +       VM_WARN_ON_ONCE(refs > LRU_REFS_MAX);
>> +       BUILD_BUG_ON(LRU_REFS_MAX != (LRU_REFS_MASK >> LRU_REFS_PGOFF) + 1);
>> +
>> +       *flags &= ~LRU_REFS_FLAGS;
>> +       if (!refs)
>> +               return;
>> +       *flags |= (BIT(PG_referenced) | ((refs - 1UL) << LRU_REFS_PGOFF));
>> +}
> 
> Similar to the above, maybe we could use more descriptive names?
> 
>> +
>> +static inline int folio_lru_refs(const struct folio *folio)
>>   {
>> -       unsigned long flags = READ_ONCE(folio->flags.f);
>> +       return lru_refs_from_flags(READ_ONCE(*const_folio_flags(folio, 0)));
>> +}
>> +
>> +static inline void folio_set_lru_refs(struct folio *folio, unsigned int refs)
>> +{
>> +       unsigned long new_flags, old_flags = READ_ONCE(*folio_flags(folio, 0));
>> +
>> +       do {
>> +               new_flags = old_flags;
>> +               lru_refs_set_flags(&new_flags, refs);
>> +       } while (!try_cmpxchg(folio_flags(folio, 0), &old_flags, new_flags));
>> +}
>>
>> -       return ((flags & LRU_GEN_MASK) >> LRU_GEN_PGOFF) - 1;
> 
> [...]
> 
>> diff --git a/mm/vmscan.c b/mm/vmscan.c
>> index 73a81b4a3e16..9ee9f8dc6805 100644
>> --- a/mm/vmscan.c
>> +++ b/mm/vmscan.c
>> @@ -843,19 +843,22 @@ static bool lru_gen_set_refs(struct folio *folio, const vma_flags_t *vma_flags)
>>          if (!folio_test_referenced(folio) && !folio_test_workingset(folio)) {
>>                  /* Activate file-backed executable folios after first usage. */
>>                  if (is_exec_file_folio(folio, vma_flags)) {
>> -                       set_mask_bits(&folio->flags.f, LRU_REFS_FLAGS, BIT(PG_workingset));
>> +                       folio_set_workingset(folio);
>> +                       folio_set_lru_refs(folio, 0);
>>                          return true;
>>                  }
>>
>> -               set_mask_bits(&folio->flags.f, LRU_REFS_MASK, BIT(PG_referenced));
>> +               folio_set_lru_refs(folio, 1);
> 
> We have quite a few instances of folio_set_lru_refs(folio, 1) and
> folio_set_lru_refs(folio, 0). Do these values have any special
> meaning? Could we add wrapper helpers to make the code more readable?
> 
> `1` just means `PG_referenced`, right? Could we add a comment or
> changelog description to clarify that `1` actually means `refs = 0`,
> but `PG_referenced` is set?
> 
> Thanks
> Barry

-- 
Best regards
Ridong


