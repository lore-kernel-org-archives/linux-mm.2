Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A9891C55171
	for <linux-mm@archiver.kernel.org>; Sun,  2 Aug 2026 12:05:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D5ECD6B007B; Sun,  2 Aug 2026 08:05:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D0F856B0088; Sun,  2 Aug 2026 08:05:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C048F6B008A; Sun,  2 Aug 2026 08:05:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 886556B007B
	for <linux-mm@kvack.org>; Sun,  2 Aug 2026 08:05:40 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id EBA88C044A
	for <linux-mm@kvack.org>; Sun,  2 Aug 2026 12:05:39 +0000 (UTC)
X-FDA: 85056199998.30.28C68CF
Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	by imf12.hostedemail.com (Postfix) with ESMTP id 0146B4000B
	for <linux-mm@kvack.org>; Sun,  2 Aug 2026 12:05:37 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Wanec2Em;
	spf=pass (imf12.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.180 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785672338;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EhAjnceW+YstcNmd0dRQVH29iTq9U+yYRGJxK6BlBAM=;
	b=OqEGt6hbh/gKInt3OjDsXmeajEjd08UnsfHJMhWPxqCFQsr9EJ7zhLd6GZq1phzpCQx/PE
	95fTAYTZxclgSLLCqlazSWYblfpg+O/Uce777GKkyoTFhUjJmuTq66IaXZnb9+vJUyKaAh
	WH+AV0UzYymi+hy2eIIncpRFrKGTC9Y=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785672338;
	b=MbQj+UGL6gyq6Krtpay5KR3P6Rn/YkmfPPOmRLcIc9bD6zRQXWhhTfBkPerV7+32P1CYm9
	ifgMNBGs9wyvduevPLKKQ0vRH5KH1zAQL2RDdMykmauBjsOgopSKKDhMtvHHF2/Cb/y/f+
	eiHDOosbmbjx1Zjm5UYjgvmCxmrjp+0=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Wanec2Em;
	spf=pass (imf12.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.180 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Message-ID: <b3f03eba-02ed-4763-86af-cafc23e0006f@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785672335;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=EhAjnceW+YstcNmd0dRQVH29iTq9U+yYRGJxK6BlBAM=;
	b=Wanec2EmC1suOkIOhufH0i5W+qegpKDEOf1S6elAJZUsDOe7I3l/Jxfhiizvtk+NbUf0/d
	T7GorbfKAxMcpTMx4+H8WWPHE8T53gAslyE4ygwKjbyoBylRkWxt934z6Vm1Fr7Cy8PssX
	Hj1HfGcZUVWDjfu1IEhT5Rwuc7cqWUg=
Date: Sun, 2 Aug 2026 13:05:21 +0100
MIME-Version: 1.0
Subject: Re: [PATCH RFC 01/14] mm/zsmalloc: replace PG_private with pointer
 comparison
To: Zi Yan <ziy@nvidia.com>
Cc: David Hildenbrand <david@kernel.org>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Muchun Song <muchun.song@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Gregory Price <gourry@gourry.net>,
 Ying Huang <ying.huang@linux.alibaba.com>,
 Alistair Popple <apopple@nvidia.com>, Johannes Weiner <hannes@cmpxchg.org>,
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>,
 Kairui Song <kasong@tencent.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Minchan Kim <minchan@kernel.org>,
 Sergey Senozhatsky <senozhatsky@chromium.org>
References: <20260731-remove-pg_private-v1-1-142c97ba3562@nvidia.com>
 <20260801141259.627022-1-usama.arif@linux.dev>
 <DKE0CO9RE3TN.KYL8VQE6QW66@nvidia.com>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Usama Arif <usama.arif@linux.dev>
In-Reply-To: <DKE0CO9RE3TN.KYL8VQE6QW66@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 0146B4000B
X-Stat-Signature: udxedc3aq6xtxfgnoj9zdczw6etdm15z
X-Rspam-User: 
X-HE-Tag: 1785672337-454742
X-HE-Meta: U2FsdGVkX19TLVBpsvTemmqbxwi90fNd9cC0X5gomQROZyF043Z54Rewq2kX5zWA9HCte/IrgVwnVw1davtM9zKcUi4CMLjKBmOl399rTTxm4WWmtWbXJGwhWH0NZUsD6zPzkfhPVc1PX/slccPB7WnuCmTZQAqkS1DTCgCLGTfl3deWKiWlj7kacq0vvE6Y69CsrMIeJhZNtjs+/2SF/8SDi0W+JA194DFT7EQSxhcRWi1/DUTz4NMhB3jWCjIZkTXyvG7hFdffHDwRZbVUPY7N2up8WFbODGGWpf/hmJ7XlhZB4ZZRZMRU8He7iP6xxUeL8HNbvrBbpLKwRs4hxGIGGVNMXbVLkgwtRnAhxOdBvZ4DtG6wUcpNu97VWjl2cId5KtrsIRawAPmWL+Z8rFq2n5WXmyTRMKZpF20Fz5koImjo2hRwW2Gwuy8L6wL1EgJeFDXLMZJpKuB+kbRcWL8h/WoUxjmzqWZUSUN+tPdLLb8CzR82CwIKP1dod/590QvfoJgZMhBWPEFSBXJlT61CBKTraW1r9971Lr6AC8Widj1900BPPv4Pnqg9Y4NWF4GnheQ+l6ZRdjlHbMb7fNeOCkqw5LnzVUkBvkgjthgPF3qIL0BU4D9OILJkS8njoI8lLvLL1ZNbp6z6HvoD5KkZOoNDjKCTKORKw26kK9Y+Tn3WJLjKRl20hVwHeTlxlUkANbdcibnbR8+m49mfb6poVRIIDc0Kln1zViZsorst+I+M0oBHx5btKc4SlXjDqTvEYFeGzG6sSgot/JeG+mcUSdxL5ClE0msIC2D9xEgq7JU3zB3NhSHt14VKnlbcSxVRrxaJr9KI7CTCh4ynRaswJVia/NRSyyphJVqEV82cnAWxpXYvV4Ho69nGF9KTG6iZahnI75d9QmHJzyxjDEqkntvhUXDXm57p6IHA+P7evTVxh9J31X6842g2jvkXJoPHpXrflxKL9akRf5X
 7tESYneM
 OmVA+NEeHNgGF+TJ+dmzWncTHWYIAVQPv2oVW49BtoyWruE3cd5Kg5dMfvuQ+q2i0tlCBokf/ct1LcTxSeQVjwbo8aon41+g6OxZH4i+aKCcTR+ZHwkmvEiSNAEkmjqRBBrRyNmT+rB7YJBg+rCboQJ7lTkESDxgPcTwM+fJ/737vTmldyoHMLyvOCisLcq+5q2GyhX74gCKKZYCVvHHcjT1AVQFixwvhTMiA3O988Pw++icLSirkCwbR/GmFTVH+kBtx1JwnupzlKivtCrCSPJ94aCrSMc2z9QFz/Au3zwN10Jc7k2JIQXtIJ4SY8WURh5r/WlrDJr9WV8HmK/4wO6dTmQb3MZg0OXRnqHvrA4/5u8s/nzrB8aw65TRz0fUt4r+/NKe5sFGhMa2gpTicwGSoLp23dCIenLQN0ahso6T2fm9SkjxXB4OvUJVSqkKhm9pd
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 02/08/2026 00:49, Zi Yan wrote:
> On Sat Aug 1, 2026 at 10:12 AM EDT, Usama Arif wrote:
>> On Fri, 31 Jul 2026 22:13:24 -0400 Zi Yan <ziy@nvidia.com> wrote:
>>
>>> zsmalloc uses PG_private to indicate first zpdesc in the zspage chain.
>>> Replace it with zpdesc->zspage->first_zpdesc == zpdesc. The check,
>>> is_first_zpdesc(), is only used in VM_BUG_ON(), so performance impact
>>> should be negligible.
>>>
>>> It prepares for a future commit that remove PG_private.
>>>
>>> No functional change intended.
>>>
>>> Assisted-by: Claude:claude-opus-4-8
>>> Assisted-by: Codex:gpt-5
>>> Signed-off-by: Zi Yan <ziy@nvidia.com>
>>> To: Minchan Kim <minchan@kernel.org>
>>> To: Sergey Senozhatsky <senozhatsky@chromium.org>
>>> To: Andrew Morton <akpm@linux-foundation.org>
>>> Cc: linux-mm@kvack.org
>>> Cc: linux-kernel@vger.kernel.org
>>> ---
>>>  mm/zpdesc.h   |  2 +-
>>>  mm/zsmalloc.c | 15 +++------------
>>>  2 files changed, 4 insertions(+), 13 deletions(-)
>>>
>>
>> create_page_chain() sets zpdesc->zspage = zspage before assigning zspage->first_zpdesc,
>> so LGTM.
>>
>> I think the assertion in get_first_zpdesc()
>> should be changed to
>>
>> VM_BUG_ON_PAGE(first_zpdesc->zspage != zspage, zpdesc_page(first_zpdesc));
>>
>> in the current check, we are checking
>>
>> zspage->first_zpdesc->zspage->first_zpdesc == zspage->first_zpdesc
>>
>> which is just testing the backpointer.
> 
> Got it. Thank you for pointing this out.
> 
> is_first_zpdesc() is also used in obj_allocated() for the same check and
> getting rid of it in get_first_zpdesc() causes inconsistency.
> 
> How about the changes below on top of this patch? is_first_zpdesc() can
> be used for both sites and looks cleaner. And VM_BUG_ON_PAGE is replaced
> with VM_WARN_ON_ONCE_PAGE.
> 
> 
> diff --git a/mm/zsmalloc.c b/mm/zsmalloc.c
> index e8ef227624efa..f021d2df99404 100644
> --- a/mm/zsmalloc.c
> +++ b/mm/zsmalloc.c
> @@ -471,9 +471,10 @@ static void record_obj(unsigned long handle, unsigned long obj)
>  	WRITE_ONCE(*(unsigned long *)handle, obj);
>  }
>  
> -static inline bool __maybe_unused is_first_zpdesc(struct zpdesc *zpdesc)
> +static inline bool __maybe_unused is_first_zpdesc(struct zpdesc *zpdesc,
> +						  struct zspage *zspage)
>  {
> -	return zpdesc->zspage->first_zpdesc == zpdesc;
> +	return zpdesc->zspage == zspage && zspage->first_zpdesc == zpdesc;
>  }
>  
>  /* Protected by class->lock */
> @@ -491,7 +492,7 @@ static struct zpdesc *get_first_zpdesc(struct zspage *zspage)
>  {
>  	struct zpdesc *first_zpdesc = zspage->first_zpdesc;
>  
> -	VM_BUG_ON_PAGE(!is_first_zpdesc(first_zpdesc), zpdesc_page(first_zpdesc));
> +	VM_WARN_ON_ONCE_PAGE(is_first_zpdesc(first_zpdesc, zspage), zpdesc_page(first_zpdesc));

mhmm do you mean 

VM_WARN_ON_ONCE_PAGE(!is_first_zpdesc(first_zpdesc, zspage), zpdesc_page(first_zpdesc)); 

here? ! is missing I think?

>  	return first_zpdesc;
>  }
>  
> @@ -828,7 +829,7 @@ static inline bool obj_allocated(struct zpdesc *zpdesc, void *obj,
>  	struct zspage *zspage = get_zspage(zpdesc);
>  
>  	if (unlikely(ZsHugePage(zspage))) {
> -		VM_BUG_ON_PAGE(!is_first_zpdesc(zpdesc), zpdesc_page(zpdesc));
> +		VM_WARN_ON_ONCE_PAGE(is_first_zpdesc(zpdesc, zspage), zpdesc_page(zpdesc));

same here? ! is missing?


>  		handle = zpdesc->handle;
>  	} else
>  		handle = *(unsigned long *)obj;
> 
>>
>> With the above VM_BUG_ON check change, please feel free to add:
>>
>> Acked-by: Usama Arif <usama.arif@linux.dev>
>>
>>
>>> diff --git a/mm/zpdesc.h b/mm/zpdesc.h
>>> index b8258dc78548d..4fd81c2e80769 100644
>>> --- a/mm/zpdesc.h
>>> +++ b/mm/zpdesc.h
>>> @@ -26,8 +26,8 @@
>>>   * with memcg_data.
>>>   *
>>>   * Page flags used:
>>> - * * PG_private identifies the first component page.
>>>   * * PG_locked is used by page migration code.
>>> + * The first component page has zpdesc->zspage->first_zpdesc == zpdesc
>>>   */
>>>  struct zpdesc {
>>>  	unsigned long flags;
>>> diff --git a/mm/zsmalloc.c b/mm/zsmalloc.c
>>> index 8204b76f78308..e8ef227624efa 100644
>>> --- a/mm/zsmalloc.c
>>> +++ b/mm/zsmalloc.c
>>> @@ -290,11 +290,6 @@ struct zs_pool {
>>>  	atomic_t compaction_in_progress;
>>>  };
>>>  
>>> -static inline void zpdesc_set_first(struct zpdesc *zpdesc)
>>> -{
>>> -	SetPagePrivate(zpdesc_page(zpdesc));
>>> -}
>>> -
>>>  static inline void zpdesc_inc_zone_page_state(struct zpdesc *zpdesc)
>>>  {
>>>  	inc_zone_page_state(zpdesc_page(zpdesc), NR_ZSPAGES);
>>> @@ -478,7 +473,7 @@ static void record_obj(unsigned long handle, unsigned long obj)
>>>  
>>>  static inline bool __maybe_unused is_first_zpdesc(struct zpdesc *zpdesc)
>>>  {
>>> -	return PagePrivate(zpdesc_page(zpdesc));
>>> +	return zpdesc->zspage->first_zpdesc == zpdesc;
>>>  }
>>>  
>>>  /* Protected by class->lock */
>>> @@ -848,9 +843,6 @@ static inline bool obj_allocated(struct zpdesc *zpdesc, void *obj,
>>>  
>>>  static void reset_zpdesc(struct zpdesc *zpdesc)
>>>  {
>>> -	struct page *page = zpdesc_page(zpdesc);
>>> -
>>> -	ClearPagePrivate(page);
>>>  	zpdesc->zspage = NULL;
>>>  	zpdesc->next = NULL;
>>>  	/* PageZsmalloc is sticky until the page is freed to the buddy. */
>>> @@ -1001,8 +993,8 @@ static void create_page_chain(struct size_class *class, struct zspage *zspage,
>>>  	 * 1. all pages are linked together using zpdesc->next
>>>  	 * 2. each sub-page point to zspage using zpdesc->zspage
>>>  	 *
>>> -	 * we set PG_private to identify the first zpdesc (i.e. no other zpdesc
>>> -	 * has this flag set).
>>> +	 * The first zpdesc has its zspage->first_zpdesc set to itself, no
>>> +	 * other zpdesc has this set.
>>>  	 */
>>>  	for (i = 0; i < nr_zpdescs; i++) {
>>>  		zpdesc = zpdescs[i];
>>> @@ -1010,7 +1002,6 @@ static void create_page_chain(struct size_class *class, struct zspage *zspage,
>>>  		zpdesc->next = NULL;
>>>  		if (i == 0) {
>>>  			zspage->first_zpdesc = zpdesc;
>>> -			zpdesc_set_first(zpdesc);
>>>  			if (unlikely(class->objs_per_zspage == 1 &&
>>>  					class->pages_per_zspage == 1))
>>>  				SetZsHugePage(zspage);
>>>
>>> -- 
>>> 2.53.0
>>>
>>>
> 
> 
> 
> 


