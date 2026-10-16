Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 60279CCA462
	for <linux-mm@archiver.kernel.org>; Fri, 16 Oct 2026 02:19:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EC4876B0088; Thu, 15 Oct 2026 22:19:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E4DFB6B008A; Thu, 15 Oct 2026 22:19:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D3D1F6B008C; Thu, 15 Oct 2026 22:19:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 99C3D6B0088
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 22:19:22 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 29EE4A7AAE
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 02:19:22 +0000 (UTC)
X-FDA: 85326882564.08.C00D121
Received: from mta0.migadu.com (out-190.mta0.migadu.com [91.218.175.190])
	by imf01.hostedemail.com (Postfix) with ESMTP id 20B6B40005
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 02:19:17 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=HAqVD7YH;
	spf=pass (imf01.hostedemail.com: domain of jiayuan.chen@linux.dev designates 91.218.175.190 as permitted sender) smtp.mailfrom=jiayuan.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792117160;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hevrjN9Z5/gE0w1T80DtiqCW7nEPAv4GEWYnL+LWVBg=;
	b=muFCJTIYDCbJBmFiSY8LcvQzos9pQ0f0XKjeNYunBvMmMqZqumdzs0ZTiY/5P9o8HCZTln
	T57pfj4dCdfjOnEj3ytF+9HeXMOW3CWbtEGCy9t0dIycCVcfhZrHCt+LWmW4NpwV8Hk73W
	npmtOBVwez+K/jyOfytb5QNJk/CUIRs=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792117160;
	b=jVfUGn/MAtiqlHErNC2g8efZNred+xPF/jBgbI2rkpIdy3ozPzgUIeXmAjwthZpDeSWMFC
	Mu3yNZdhWWY8QQKK1aw79BNIBv9ogp914FjFRn47POV/9d6LNzpQULIU6MOUmep0WmaFbW
	RDGa1L14BfsAgtMvwAyd7ohH9yyh8uc=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=HAqVD7YH;
	spf=pass (imf01.hostedemail.com: domain of jiayuan.chen@linux.dev designates 91.218.175.190 as permitted sender) smtp.mailfrom=jiayuan.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=17KKcw8hwoNEkFzjNMvkidkGWg1lqcGVBB0m+8zSDac=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792117152; v=1; x=1792721952;
 b=HAqVD7YH4u6rac3COdiFarB5/WOPRtrdu5lNAyC6snglHFYDhaki7GyDScZwMYGVIRfazLMe
 A6s2zUaIisdt697oDLbCxyB0PNnH11fNMc06lyrkMqJJ6ZaIcr/SpLtFjNABJHePq9vHhm1WJkS
 BCL2ZWUtL06aMQ05v+vc9l9k=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 9117b98bd5139204;
	Fri, 16 Oct 2026 02:19:10 +0000
X-Mizu-Trace-ID: 9117b98bd5139204
X-Migadu-Flow: FLOW_OUT
Message-ID: <37f1af42-9788-4552-86a4-516299241ee8@linux.dev>
Date: Fri, 16 Oct 2026 10:19:01 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/swap: fix swap_cache_get_folio() returning a folio
 that left the swap cache
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, Jiayuan Chen <jiayuan.chen@shopee.com>,
 Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>,
 Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>,
 Baoquan He <baoquan.he@linux.dev>, Barry Song <baohua@kernel.org>,
 Youngjun Park <youngjun.park@lge.com>, linux-kernel@vger.kernel.org
References: <20261015060528.302634-1-jiayuan.chen@linux.dev>
 <20261015190619.deccb92624e356bf81084a24@linux-foundation.org>
From: Jiayuan Chen <jiayuan.chen@linux.dev>
In-Reply-To: <20261015190619.deccb92624e356bf81084a24@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 20B6B40005
X-Stat-Signature: san3wisra9pnmabweh7ihuynr6cdz3p1
X-HE-Tag: 1792117157-784934
X-HE-Meta: U2FsdGVkX19yYykVfVkvBS9wziYzw/rjFiv2z1VmMo9Ck813PdbIxGrFEm8ggo7ammPOfWR0VSMJUnh1flc0BifoWU053ny5NWD3dcHJMawZCkiCco4Kt03ETbZK3VmrpcdxVwGCllYbjeN6f2iu/JhM35VulxfNa9lvbJ3heUV2PNH42yN8xHlPoDUJZ0KuFkJ7ZZdM9mjfb3kc6OIlFl1lRzOmY8pGakOitIYph4RXN7dSyZCG7rQaqqUKL6vhkYsTymIIooS2LK/DLOv8pD1X0EJfXRSa/x12EtXH8f+uapoz9j7KvPKtH1WaDP7nttRzUODKeycRQPnaEnpQkcjQPx36UXSaaO9884b7aM2h9PeDMaYyDWpkOVLdUDkPPsOFPjphoowIpwEuoVPoVqu5qM5iwh/8d0FAjZHT3M/OMNK5MWwKjV5HuVSUD44W6CNIP99eSpXhaNZTLTVRFSh6wA/uXFgsICtbvBkw9Eml2LMTZ6K+QC7tj05xDL8quEpQ4h5Xb8qj3ADN519UbXeTYyCJvvVLVm6O2ymdTU6ytWPEgVuyPQeexG3Tjay/q74kVbUVk5XpITcZa0jHTdpMa1P/pQluu2ZA1zPS1pY6UH3fqkcrrucDlDpUIhGBOf1boMyOQfv0gf+zp4J3FqAD0KQJ/B1mVxhB5drpva5rJJDMQvc15eX6V2qMol5uizD0l5d3RJDkwzs1CP4Gv753jnWLzyRKSpvkLVhXNTyV2tOty9KcDcOQKrfzJ08uuwAM1scotoqXhpDcPti/GrM9mpUse12zTz7g5qCZoIwtFmTSlbcoCGWofn3JQbodDQw6z1voeJgzdYnl2UfQiFeIqV6tZn4TOEN4hg9OkwXoIPWQdcKv2f/ksY5nwm3XtDlX6Wl5XwuVzPQtkmaXtTYtq9rMuidIy+RewjyTMMHZ4VzgVVh5z65fMT3tCeWV4pmkxAQ9zvwQ+Ic5z58
 z3bW5P9D
 o9u5pKEtCbqbqO2gakgBFCxRIQXgu1npSxZJnQIP6T4aevhFJVZmPZIGh7M8nJAcUIoo25PCQljDTZzTA8CWacq5dLlPs7M2aBp/1Xk/OdGBylfxUWyN3RorWMbdgZ5dBScZUmbRmjjXPk3s53w3S56qPr3bgahD2/cRzGT/uR+kUTenuohEpF/pq4o0iBHbegC/pafR5cz2wgt7HzM355gjTvfUnCAsZZw30B8S1hwJrXmVneB3uHopfdawBWryiyb9C5FEA00PjuNTD0rqKOJVkoOG/3mxPFLCuOweryDNRTwCh9iJptaFEMx7R72AzFQBgi5Z/gj4YAO4lRu8gDzsZthLJi8aIptbe/FgMImjOkIEG3DyobOq1Lx9b6ZGV/jHFshwdF5K0NKJr9OxXm4jdMROwB08bkYnOTMfqBvsDHh4VQJHx7/0kxWFh+9ifqGAM
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Andrew,

On 10/16/26 10:06 AM, Andrew Morton wrote:
> On Thu, 15 Oct 2026 14:05:27 +0800 Jiayuan Chen <jiayuan.chen@linux.dev> wrote:
>
>> From: Jiayuan Chen <jiayuan.chen@shopee.com>
>>
>> swap_cache_get_folio() reads the folio from the swap table and takes a
>> reference with folio_try_get(), without any lock. If the folio is
>> removed from the swap cache and freed in between, and its memory gets
>> reused, folio_try_get() still succeeds and we return a page that has
>> nothing to do with the swap entry:
>>
>>    CPU 0                                  CPU 1
>>    do_swap_page()
>>      swap_cache_get_folio()
>>        swp_tb = swap_table_get()
>>        folio = swp_tb_to_folio(swp_tb)
>>                                           madvise(MADV_DONTNEED)
>>                                             zap_nonpresent_ptes()
>>                                               swap_put_entries_direct()
>>                                                 swap_put_entries_cluster()
>>                                                   __try_to_reclaim_swap()
>>                                                     swap_cache_del_folio()
>>                                                     folio_put()   <- freed
>>                                           page reused, e.g. as an anon
>>                                           folio of another task
>>        folio_try_get(folio)               <- succeeds
>>        return folio
>>      swap_update_readahead()              <- may clear PG_readahead on it
>>      folio_lock_or_retry()                <- locks it
>>      folio_matches_swap_entry() fails, unlock and put
>>
>> filemap_get_entry() does the same lockless lookup for the page cache,
>> and after folio_try_get() it rechecks the xarray, because the folio may
>> have been freed and reused in between. swap_cache_get_folio() lost
>> that recheck when the swap cache moved to the swap table.
>>
>> So CPU 0 writes to a folio it doesn't own: it may clear PG_readahead and
>> takes the folio lock of someone else's page, before
>> folio_matches_swap_entry() finds out the folio is not ours.
>>
>> Recheck the slot after folio_try_get() and retry if it no longer holds
>> this folio.
> LLM says to me:
>
> : The original folio could conceivably be freed, its physical page
> : reused, and the same PFN inserted into the same swap-table slot before
> : the second lookup.  That would pass the check.  However, the returned
> : reference would then belong to the newly inserted folio, and the later
> : swap-entry validation would still be required.  I don't see that as
> : invalidating this fix.



I had the same worry at first, data corruption or something worse, but
after thinking it through I agree. Passing the check there is fine:
the folio we return is the one currently in the slot, which is what
the function promises, and callers still check folio_matches_swap_entry()
under the folio lock before using it. That's why I didn't mention it in 
the changelog.


>> --- a/mm/swap_state.c
>> +++ b/mm/swap_state.c
>> @@ -92,17 +92,27 @@ void show_swap_cache_info(void)
>>    */
>>   struct folio *swap_cache_get_folio(swp_entry_t entry)
>>   {
>> +	struct swap_cluster_info *ci = __swap_entry_to_cluster(entry);
>> +	unsigned int ci_off = swp_cluster_offset(entry);
>>   	unsigned long swp_tb;
>>   	struct folio *folio;
>>   
>>   	for (;;) {
>> -		swp_tb = swap_table_get(__swap_entry_to_cluster(entry),
>> -					swp_cluster_offset(entry));
>> +		swp_tb = swap_table_get(ci, ci_off);
>>   		if (!swp_tb_is_folio(swp_tb))
>>   			return NULL;
>>   		folio = swp_tb_to_folio(swp_tb);
>> -		if (likely(folio_try_get(folio)))
>> +		if (!folio_try_get(folio))
>> +			continue;
>> +		/*
>> +		 * The folio may have been freed and its memory reused before
>> +		 * we got the reference. Make sure it is still in the slot.
>> +		 */
>> +		swp_tb = swap_table_get(ci, ci_off);
>> +		if (likely(swp_tb_is_folio(swp_tb) &&
>> +			   swp_tb_to_folio(swp_tb) == folio))
>>   			return folio;
>> +		folio_put(folio);
>>   	}
>>   
>>   	return NULL;
> This return is now unreachable...


Right, and it never was reachable, the loop has no break. It should have 
been dropped earlier...


