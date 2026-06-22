Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3CE80CDB46F
	for <linux-mm@archiver.kernel.org>; Mon, 22 Jun 2026 09:16:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C560A6B0088; Mon, 22 Jun 2026 05:16:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C07106B008A; Mon, 22 Jun 2026 05:16:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AF5716B008C; Mon, 22 Jun 2026 05:16:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 759316B0088
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 05:16:48 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D1ABDC2820
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 09:16:47 +0000 (UTC)
X-FDA: 84906993654.21.0FB3367
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id 0D1A720002
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 09:16:45 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MsvhQmXQ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782119806;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sTvbDmMhUjwqiFd2kPQ5Mc6EsPrALFmqEPayYyfrbfs=;
	b=GE/SF1x4t+Ffd1HhLQespjiv1JBQj/cMWeWC3oQiRs8tMDcPyoLDiOAV//tabskvI/10pw
	2vxgaIBxlK4wxqOi/Ac3635U8K5gGjE4Stxhsk2SLUj7J1TRdKtmv60i/pxuiMB+uQpDhC
	h3d1x6zVQDBHNYnoDBupCOKAX3Wy8PE=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MsvhQmXQ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782119806;
	b=iVmfQj9Gt05sfowULTV8I2/brKiq6mzXERqqy0EP2Mi7unNUH60VaXpP5tSXzk4FPwzjmf
	gSRJsXar/piSB1GkXO8WyU4DV4jbQVROomfwTJ/BK31YY3nBeI/vqpeYs8Edj3tn0YduCU
	VujnYXi8RNpkrYwhEOa+gAUepVTDCl4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5952660051;
	Mon, 22 Jun 2026 09:16:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE4D41F00A3A;
	Mon, 22 Jun 2026 09:16:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782119805;
	bh=sTvbDmMhUjwqiFd2kPQ5Mc6EsPrALFmqEPayYyfrbfs=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=MsvhQmXQIGWOrEzkOB51RjEoo39BuIDGE1NPay9656HboXuXmQSLdbZozLFiLCvrf
	 BZZqW6CszlQoISdvqtY4WaLpZ7SF8KvWUZXY054ISW9vLJP1lxsfzeZ92klvXTXLze
	 RycIVmnxTd99DauFgP286aJ9s3tBNtzFgjeVagNb4jlKcdVFKN5sLZ7IUIhLIhC8mf
	 v/wztbvBe/xIF7PrepIP5bFiQUhCoUKkvzuHq5Ac+qMW/WOAfzgVtRe+bRfW7tHAHK
	 NknpWk/iYaugx9Gt8lLOCS3BAlqur/iN0En9YTd8+OOVXce18QqEOHm908EU7VmFkO
	 bnPpWv/86smbQ==
Message-ID: <f820a74a-ee28-4888-a5ac-e1c4de8c0202@kernel.org>
Date: Mon, 22 Jun 2026 11:16:39 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm: migrate: requeue destination folio on deferred
 split queue
To: Wei Yang <richard.weiyang@gmail.com>, Usama Arif <usama.arif@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, npache@redhat.com,
 ziy@nvidia.com, willy@infradead.org, linux-mm@kvack.org,
 matthew.brost@intel.com, joshua.hahnjy@gmail.com, hannes@cmpxchg.org,
 rakie.kim@sk.com, byungchul@sk.com, gourry@gourry.net,
 ying.huang@linux.alibaba.com, apopple@nvidia.com,
 linux-kernel@vger.kernel.org, kernel-team@meta.com
References: <20260310105419.3256755-1-usama.arif@linux.dev>
 <20260620072721.x4dfh6gy4wnjqre4@master>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260620072721.x4dfh6gy4wnjqre4@master>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 4jy3rhhss586m7mqy8y6gfwcfesukew3
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 0D1A720002
X-Rspam-User: 
X-HE-Tag: 1782119805-942699
X-HE-Meta: U2FsdGVkX18idQg17Qp6SELKZ5IRiQ+5B7Dd1/gyIQj2VUk7VzIq0DUnqwAoO+Ed3wf56pczARDmCX7yBSadkkP8pzUqHwFXTekS+lMUNEQ6xeJxyHxl05fy3o76Qu34Dtek9+1LrcOnHRlXpjUOm97KHeLdSrO/umRmkwzJnK6U+HMwc5mXOgX92CiWhPGDwJOU87y8I7zxgE3PDd9672ZvImwyLMWNPQB3lPBwILCM/nSZXooHt/2AjQOHQQ6C8q5+H3ytRhS8xfaLplZY8bwpOMnR1KfCNpFFgUZq6EKWGa4cJwc+ku8wL0ptjT8UQgw2yA81PM/lDV0dTNydn9vohZ40VZuuNaflvTegykhRC01hCT3nBrsdlc0UnSNCfWk6fnlMEPwNb6mqG9DvJVNInu0jUEsxxbCrAQPxJuZOFGXYvVcA0CO22Z4at/YTez6fMAQeMLOQsmo8IabxaFMsxFlto5Fv77k90Y3R4HaDtPh3o9Q7XsFnrkulNmNSBIQMJ2TyVUo5ib818NtB7AH5mxl1lXlrfoseKYAEYY881Vu4bsVmz6c2sQxM5KVtYqDWXvJ8cxvkXO4aALDQ/E5AAMMPK05/8dSE9KqnleCGx7lYWheoXNTacM+u9c+FqrHSrRC4f4l/nkzZlL/lUCSOcsFurjBr0BQwq0TNyBBOL8d0cN8YZsS6yXCVx7xtS1jYz6mstPV7elDZXNREto+At7UdNce1tyJhwZswHnA/+jj0HiuKXtT4jJ70JD6tEKPvBsjgi2fFm1yZL4upKxylJaWlYj9u9RngWH0nZWdc7PSQccev0TFDoGN4u2a98y3ESAffWocfyO/i1nIomVvoVY09h66RNRoXv8vXBmFs16lZ6B5ZR+Oi3IfR46oqePVfwk/jHOBA2fBRi4MUKMkl/J7fVlABi1wFavOmVWN5c3qqnW1lGnZ85zVJ+Vqv63mYpZcVm+eXBYC02sE
 wU3kTnia
 1KuJUG9ev9AGPsjH2X3wKpUPiGI2C0+q921njcze6LLbTKXtrWaSw6oWHMzSmDDmaWJdBv23K9mW0j89NlPT5aQAs1Fnw2lj0kbnGGJh3Fwrsx5wWox0md7lHb1+5uShq1+BoOFQ5bvVUGQRgewLZT78KRtklqtTMfj/qtssIy3mp7VMwbt1cpPUGbNfSyvc6awuHsCS4/GVhaj29O63HE5AEg72kJ8hHe4prEKUNaXY5OKUzlUjqVP5hgUYvBNeQfm+a7f1MlzPeifseUcHwwVxFGCXPcVaaJd9n+Vvge28PppkBlEBa0z/o8iMvTXwCBsBXi+gd3BgZSySmKpRBbpQTVac11YO0psCzmrYDRb9JgsP5Wg3Y8wHhThQnrzhj2dtl8x1H1f9g6JE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/20/26 09:27, Wei Yang wrote:
> On Tue, Mar 10, 2026 at 03:54:19AM -0700, Usama Arif wrote:
>> During folio migration, __folio_migrate_mapping() removes the source
>> folio from the deferred split queue, but the destination folio is never
>> re-queued.  This causes underutilized THPs to escape the shrinker after
>> NUMA migration, since they silently drop off the deferred split list.
>>
>> Fix this by recording whether the source folio was on the deferred split
>> queue and its partially mapped state before move_to_new_folio() unqueues
>> it, and re-queuing the destination folio after a successful migration if
>> it was.
>>
>> By the time migrate_folio_move() runs, partially mapped folios without a
>> pin have already been split by migrate_pages_batch().  So only two cases
>> remain on the deferred list at this point:
>>  1. Partially mapped folios with a pin (split failed).
>>  2. Fully mapped but potentially underused folios.
>> The recorded partially_mapped state is forwarded to deferred_split_folio()
>> so that the destination folio is correctly re-queued in both cases.
>>
>> Reported-by: Johannes Weiner <hannes@cmpxchg.org>
>> Fixes: dafff3f4c850 ("mm: split underused THPs")
>> Signed-off-by: Usama Arif <usama.arif@linux.dev>
>> ---
>> v1 -> v2:
>> - record whether source folio was on the deferred split queue before
>>  move_to_folio() (David)
>> - record partially mapped state and update commit message (Zi)
>> ---
>> mm/migrate.c | 17 +++++++++++++++++
>> 1 file changed, 17 insertions(+)
>>
>> diff --git a/mm/migrate.c b/mm/migrate.c
>> index ece77ccb2ec0..61013d258eb4 100644
>> --- a/mm/migrate.c
>> +++ b/mm/migrate.c
>> @@ -1360,6 +1360,8 @@ static int migrate_folio_move(free_folio_t put_new_folio, unsigned long private,
>> 	int rc;
>> 	int old_page_state = 0;
>> 	struct anon_vma *anon_vma = NULL;
>> +	bool src_deferred_split = false;
>> +	bool src_partially_mapped = false;
>> 	struct list_head *prev;
>>
>> 	__migrate_folio_extract(dst, &old_page_state, &anon_vma);
>> @@ -1373,6 +1375,12 @@ static int migrate_folio_move(free_folio_t put_new_folio, unsigned long private,
>> 		goto out_unlock_both;
>> 	}
>>
>> +	if (folio_test_large(src) && folio_test_large_rmappable(src) &&
>> +	    !data_race(list_empty(&src->_deferred_list))) {
>> +		src_deferred_split = true;
>> +		src_partially_mapped = folio_test_partially_mapped(src);
>> +	}
> 
> Hi, Usama
> 
> I am afraid there maybe a race between migration and defer_split.
> 
>                 A                              B
>   migrate_pages_batch                   deferred_split_scan
>     migrate_folio_unmap                   list_del_init(&folio->_deferred_list)
>       folio_lock/folio_trylock
> 
>     migrate_folios_move
>       migrate_folio_move
>         list_empty(&src->_deferred_list)
>                                           folio_trylock()
>                                           requeue:
> 
> In case list_empty() check happens after folio removed from defer_list but
> before requeued, we will miss this folio.

deferred_split_isolate() would grab a reference through folio_try_get().

How can we migrate a folio with a raised refcount?

-- 
Cheers,

David

