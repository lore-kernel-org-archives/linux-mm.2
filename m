Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4EF2EFDEE41
	for <linux-mm@archiver.kernel.org>; Thu, 23 Apr 2026 18:21:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 819126B0093; Thu, 23 Apr 2026 14:21:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7C9256B0095; Thu, 23 Apr 2026 14:21:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6DF146B0098; Thu, 23 Apr 2026 14:21:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 5F2C26B0093
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 14:21:23 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8F88440452
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 18:21:22 +0000 (UTC)
X-FDA: 84690638004.11.BB54B37
Received: from out-178.mta0.migadu.com (out-178.mta0.migadu.com [91.218.175.178])
	by imf07.hostedemail.com (Postfix) with ESMTP id 5FF2040010
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 18:21:20 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=PRHmDfdT;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf07.hostedemail.com: domain of jp.kobryn@linux.dev designates 91.218.175.178 as permitted sender) smtp.mailfrom=jp.kobryn@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776968480; a=rsa-sha256;
	cv=none;
	b=ZDnH+J6pemnWbCPMu48dJUElFzU1zcO2LOrgVDlJhyRpPaT8NXVg3Rnn1hAMXKnL81EMiS
	Z12isLJhPlAwUCDqj5uEi/pPDDnMSfVId87Eo0D69hCstijUk/vQrUZrFPdMh783NFCknA
	qPD1c2riRlZrJrNPr7fRKciHSTqAvK0=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=PRHmDfdT;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf07.hostedemail.com: domain of jp.kobryn@linux.dev designates 91.218.175.178 as permitted sender) smtp.mailfrom=jp.kobryn@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776968480;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NT5G3ybYNd+sfFQXG2SgNNLq2F21AGBVro6FdqalTiM=;
	b=jf8tuI5DEaXaKv+9LkEBYVtF6YS24i2G9O8B+TvD6SWUD62rV8AuFi4FpOWFdmkYIDFjaF
	ML+31MpXtlF15WAVw/6+HKI5JnVeLr8h1+XOzjvkPcjavrKjmvC8ddb5QWVH69rrmXTbYR
	qbUF7bBFQex/y65c9fz8iejHXHHO+bI=
Message-ID: <c09c9138-b2ab-41d6-be9e-05be87a2bfce@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1776968477;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NT5G3ybYNd+sfFQXG2SgNNLq2F21AGBVro6FdqalTiM=;
	b=PRHmDfdTojOH+JWxKAM1fa6YLZJJb4nYdQ0QcXTOEua3xbjplBUhtw6uBWax01E61unV9G
	/BvFtDEGFICdnrQ5B1Cy9dj8Jl8h0ynS7Ji5nGtCE8n/XyYQgwMlpPBaFV6Et2QLTH5lcj
	JFp+RTpn12USHA2yG44cO7auSbDpU6o=
Date: Thu, 23 Apr 2026 11:21:10 -0700
MIME-Version: 1.0
Subject: Re: [PATCH] mm/lruvec: preemptively free dead folios during lru_add
 drain
To: Matthew Wilcox <willy@infradead.org>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, vbabka@kernel.org,
 mhocko@suse.com, hannes@cmpxchg.org, shakeel.butt@linux.dev,
 riel@surriel.com, chrisl@kernel.org, kasong@tencent.com,
 shikemeng@huaweicloud.com, nphamcs@gmail.com, bhe@redhat.com,
 baohua@kernel.org, youngjun.park@lge.com, qi.zheng@linux.dev,
 axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com,
 linux-kernel@vger.kernel.org, kernel-team@meta.com
References: <20260423164307.29805-1-jp.kobryn@linux.dev>
 <aepTnIu1WiyyHNJp@casper.infradead.org>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: "JP Kobryn (Meta)" <jp.kobryn@linux.dev>
In-Reply-To: <aepTnIu1WiyyHNJp@casper.infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam10
X-Stat-Signature: z4f1znyndszanu8roec7u7p5qdk3uuat
X-Rspam-User: 
X-Rspamd-Queue-Id: 5FF2040010
X-HE-Tag: 1776968480-683089
X-HE-Meta: U2FsdGVkX18ZaaQI5YEx6ctx6/pNR5xbUnvmb3cVql20IpOftSjPw8NJsWPXWEc1GgWYqwvSfwJDkEvfqDLT3MxlmsWhUW9b26Z+lBl74HUDeEs8Ad9yrIjWYUPTaQYOOKndtHbCUJw9HcjG28NJxMDBMMOolCb9ZNJsoETyqH3ZdAQF/F4qvtosEypw5gdDFjFC4sB5IWCZApGr46q/0qNY4VmzdrjRalOBSSp3qynuP7ceSZuFIinogAkHddOMc6RmUPwNouhzz3aVb6BbOIsb+brsBh17tcHwca3OsAx5vvlosv6U5mjyduvFFEasSLOHkNV/B45XtDOqGfe5y1l7Xl0Xw4bbhae0yvxr8v8KJMxj1Gprxzfx0qHbwP43h1+fPLSuziN5Q7UNqqjqSthitTSR1GRtPL0jxRg9pm4qWJtSkinZ2qlpKHrFdiDJJrfpo96Tv9HE0VUC1HREgOD42Q9yS7MGcKwDHeD8gT5VXx2FF7e1OVf78+GFXbaD78ZUaSe6jLU/Jlr6HOJ5Dg87/VvuCib2t6Eun0y7pHaScmVQVjAB59LywPK6glSS6Zcof4+atprcFGeapv2OvWLrydFXSgfwCcriz4yNUgq1mM5uZdr6NH/aXUpWdiGl5tu6F/z7JU7eU7WorxvM+ZEwl8l6uhYF+hFwnmSYxVntv5dppx0tvQU6zPMRmFHq5uNwZS2h+XZeDPal/EnJcXMtpfmXAtxzG+ThOJcLxAJoq0ve/h6GI1DPIvhE6KlZllf96d6fST5JfmBlgrOLG+jP2XSchTNuQAmQmx054zb2lwodav6O8BCLut90ivfM2cESYbWumRX9ssJ4G7kR+VINOwpiS5S88owzKaf0Jde0FDwnPf/6fBZQE89Ccs7tf6VvoX+0svbrFkcfGlNgB2tZZXoCqEakjy/E1TqYf9TnQFAMKoQ5dfFrI3eikHG08P4VpAeo3vUqQLWLdNv
 DpsKS3XZ
 1EmO35kM/zxfzOq1DgbEdh5GnDb1TSl8UmetirzNj1RO/II/Jegz1xE8O8taq3N9wjVC4b7JL/jhSWKPATn5vq4nkGr4qF9OmsvnFk+911uf20hvwbGlqzg5A0mjqk5iMG5htQwusdFfG4dUNw2QQ0Vu43+xhA1r1eta7UdXZ2pzFS8dA0tiSS+aa6qGdW3MY9BWtLfp0MhM8CL8tDdyk/829bJ/SmA/u6nJ5Bo4IVbQXPZ6n1mXygNCU1JRui+eMSu5ePW3Ztfr9gnAcmBmY+W6Pr/xKqwAlh6Ul4aaxJMf12XdtEPqbv8Fw4A79cWfUzvGI
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/23/26 10:15 AM, Matthew Wilcox wrote:
> On Thu, Apr 23, 2026 at 09:43:07AM -0700, JP Kobryn (Meta) wrote:
>> Of all observable lruvec lock contention in our fleet, we find that ~24%
>> occurs when dead folios are present in lru_add batches at drain time. This
>> is wasteful in the sense that the folio is added to the LRU just to be
>> immediately removed via folios_put_refs(), incurring two unnecessary lock
>> acquisitions.
> 
> Well, this is a lovely patch with no obvious downsides.  Nicely done.

Thanks for the kind words and review :)

[...]
>> diff --git a/mm/swap.c b/mm/swap.c
>> index 5cc44f0de9877..71607b0ce3d18 100644
>> --- a/mm/swap.c
>> +++ b/mm/swap.c
>> @@ -160,13 +160,36 @@ static void folio_batch_move_lru(struct folio_batch *fbatch, move_fn_t move_fn)
>>   	int i;
>>   	struct lruvec *lruvec = NULL;
>>   	unsigned long flags = 0;
>> +	struct folio_batch free_fbatch;
>> +	bool is_lru_add = (move_fn == lru_add);
>> +
>> +	/*
>> +	 * If we're adding to the LRU, preemptively filter dead folios. Use
>> +	 * this dedicated folio batch for temp storage and deferred cleanup.
>> +	 */
>> +	if (is_lru_add)
>> +		folio_batch_init(&free_fbatch);
>>   
>>   	for (i = 0; i < folio_batch_count(fbatch); i++) {
>>   		struct folio *folio = fbatch->folios[i];
>>   
>>   		/* block memcg migration while the folio moves between lru */
>> -		if (move_fn != lru_add && !folio_test_clear_lru(folio))
>> +		if (!is_lru_add && !folio_test_clear_lru(folio))
>> +			continue;
>> +
>> +		/*
>> +		 * Filter dead folios by moving them from the add batch to the temp
>> +		 * batch for freeing after this loop.
>> +		 *
>> +		 * Since the folio may be part of a huge page, unqueue from
>> +		 * deferred split list to avoid a dangling list entry.
>> +		 */
>> +		if (is_lru_add && folio_ref_freeze(folio, 1)) {
>> +			folio_unqueue_deferred_split(folio);
> 
> Would it be better to do this outside the lru lock; it's just that we
> don't have a convenient batched version to do it?  It seems like
> there are a few places that could use a batched version in vmscan.c and
> swap.c.  Not that I think we should hold up this patch to investigate
> that micro-optimisation!  Just something you couldlook at as a
> follow-up.

Good call. I'll leave this patch as-is (unless other feedback), then
pursue the batched version of unqueuing the split in a separate
follow-up patch.

> 
> Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>


