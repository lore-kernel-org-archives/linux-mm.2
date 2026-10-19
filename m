Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D7C1ACCF2E3
	for <linux-mm@archiver.kernel.org>; Mon, 19 Oct 2026 12:23:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C39046B00DA; Mon, 19 Oct 2026 08:23:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C11426B00DD; Mon, 19 Oct 2026 08:23:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AFFB76B00DE; Mon, 19 Oct 2026 08:23:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 831966B00DA
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 08:23:32 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 03D581C31FB
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 12:23:31 +0000 (UTC)
X-FDA: 85339291464.24.31E2109
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf31.hostedemail.com (Postfix) with ESMTP id 0B0532000A
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 12:23:29 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Oq7f7u02;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792412609;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LuiCl+I2h452P2ySjY/aKFWNJcn4drc6seXyIqCSVY8=;
	b=zM+2bLw/ILoFk8T3tTiFQQbUmzwOyso8mG9cMiUEXRWDkslU4rF+6qPGtKtIcXRGXCTSgy
	QPZzB+UdroPmhOJJu1mH1MjYiExtI2E+LJ/UDscdHPswuD1zw8iemVQq0E8JBkjYk2TYOe
	AqX2Q+cFi0L4SLBV0zmGRLP2bziW4a8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792412609;
	b=v4+D9xnJqBvtIYbW2Viv7gJdX5TlcKlfB5lRinicZTIIqPycMpMzoUKLe2lC6KL/0Hv8bk
	P2Ms2VExngbNqNzG2QU8VTR6krysq3Rkff6ZISZEVYtzNRgH70Vmbf6VsQtje+v9NbrvQX
	DbEpqOsTFD4vpiMb4wXdgfhd62D4bmA=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Oq7f7u02;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 4097960136;
	Mon, 19 Oct 2026 12:23:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3DAA1F000C4;
	Mon, 19 Oct 2026 12:23:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792412609;
	bh=LuiCl+I2h452P2ySjY/aKFWNJcn4drc6seXyIqCSVY8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Oq7f7u02z1MZMAwTdBQfCe7hZrRaN2XCtCDfk6Kmv9L+JzDLETnM+pXZ/QdKeAsCd
	 IpjIT35E4EWLub8zbfJYdEvr8sZ4ATo9B3YFfoBKHidQyqWtp4k/yGXOOfSAqWKM2t
	 QWLsVwUuEgK3krujErnkqv/z5CluTrRgy8Wb9rkHIc8/PFjdynqwnoEr0y171MeIWK
	 Oi1QRss8lATZaL/cdyQqfX0yX/tPIMhMufaemhnMMfIWtYuzBTRhc8ASlitX1iJdCU
	 Te16u5lGojfvFc7g8Sur8XSomaWBT9BS3Kd3isIO6Lwj9C2EWSGmMInLc1vQF14u1G
	 R0gIBW3J68SWg==
Message-ID: <ad34dd6d-f106-42b1-b8b6-a4487822285f@kernel.org>
Date: Mon, 19 Oct 2026 14:23:21 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v2] mm: introduce copy_mc_highpages() and batch copy
 in folio_mc_copy()
To: Pedro Falcato <pfalcato@suse.de>, Shivank Garg <shivankg@amd.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Borislav Petkov <bp@alien8.de>, Ankur Arora <ankur.a.arora@oracle.com>,
 Dave Hansen <dave.hansen@linux.intel.com>, Thomas Gleixner
 <tglx@kernel.org>, Bharata B Rao <bharata@amd.com>,
 Hrushikesh Salunke <hsalunke@amd.com>, Ingo Molnar <mingo@redhat.com>,
 "H . Peter Anvin" <hpa@zytor.com>,
 David Laight <david.laight.linux@gmail.com>,
 David Rientjes <rientjes@google.com>,
 Linus Torvalds <torvalds@linuxfoundation.org>,
 Teja Vojjala <tejavojjala@google.com>, Huan Nguyen <nhuhuan@google.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, x86@kernel.org
References: <20261019-batpagecopy-v2-1-d75e7d0dfaae@amd.com>
 <atX3lpXQBHH1JPhW@pedro-suse.tail5790ac.ts.net>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 xsFNBFXLn5EBEAC+zYvAFJxCBY9Tr1xZgcESmxVNI/0ffzE/ZQOiHJl6mGkmA1R7/uUpiCjJ
 dBrn+lhhOYjjNefFQou6478faXE6o2AhmebqT4KiQoUQFV4R7y1KMEKoSyy8hQaK1umALTdL
 QZLQMzNE74ap+GDK0wnacPQFpcG1AE9RMq3aeErY5tujekBS32jfC/7AnH7I0v1v1TbbK3Gp
 XNeiN4QroO+5qaSr0ID2sz5jtBLRb15RMre27E1ImpaIv2Jw8NJgW0k/D1RyKCwaTsgRdwuK
 Kx/Y91XuSBdz0uOyU/S8kM1+ag0wvsGlpBVxRR/xw/E8M7TEwuCZQArqqTCmkG6HGcXFT0V9
 PXFNNgV5jXMQRwU0O/ztJIQqsE5LsUomE//bLwzj9IVsaQpKDqW6TAPjcdBDPLHvriq7kGjt
 WhVhdl0qEYB8lkBEU7V2Yb+SYhmhpDrti9Fq1EsmhiHSkxJcGREoMK/63r9WLZYI3+4W2rAc
 UucZa4OT27U5ZISjNg3Ev0rxU5UH2/pT4wJCfxwocmqaRr6UYmrtZmND89X0KigoFD/XSeVv
 jwBRNjPAubK9/k5NoRrYqztM9W6sJqrH8+UWZ1Idd/DdmogJh0gNC0+N42Za9yBRURfIdKSb
 B3JfpUqcWwE7vUaYrHG1nw54pLUoPG6sAA7Mehl3nd4pZUALHwARAQABzS5EYXZpZCBIaWxk
 ZW5icmFuZCAoQ3VycmVudCkgPGRhdmlkQGtlcm5lbC5vcmc+wsGQBBMBCAA6AhsDBQkmWAik
 AgsJBBUKCQgCFgICHgUCF4AWIQQb2cqtc1xMOkYN/MpN3hD3AP+DWgUCaYJt/AIZAQAKCRBN
 3hD3AP+DWriiD/9BLGEKG+N8L2AXhikJg6YmXom9ytRwPqDgpHpVg2xdhopoWdMRXjzOrIKD
 g4LSnFaKneQD0hZhoArEeamG5tyo32xoRsPwkbpIzL0OKSZ8G6mVbFGpjmyDLQCAxteXCLXz
 ZI0VbsuJKelYnKcXWOIndOrNRvE5eoOfTt2XfBnAapxMYY2IsV+qaUXlO63GgfIOg8RBaj7x
 3NxkI3rV0SHhI4GU9K6jCvGghxeS1QX6L/XI9mfAYaIwGy5B68kF26piAVYv/QZDEVIpo3t7
 /fjSpxKT8plJH6rhhR0epy8dWRHk3qT5tk2P85twasdloWtkMZ7FsCJRKWscm1BLpsDn6EQ4
 jeMHECiY9kGKKi8dQpv3FRyo2QApZ49NNDbwcR0ZndK0XFo15iH708H5Qja/8TuXCwnPWAcJ
 DQoNIDFyaxe26Rx3ZwUkRALa3iPcVjE0//TrQ4KnFf+lMBSrS33xDDBfevW9+Dk6IISmDH1R
 HFq2jpkN+FX/PE8eVhV68B2DsAPZ5rUwyCKUXPTJ/irrCCmAAb5Jpv11S7hUSpqtM/6oVESC
 3z/7CzrVtRODzLtNgV4r5EI+wAv/3PgJLlMwgJM90Fb3CB2IgbxhjvmB1WNdvXACVydx55V7
 LPPKodSTF29rlnQAf9HLgCphuuSrrPn5VQDaYZl4N/7zc2wcWM7BTQRVy5+RARAA59fefSDR
 9nMGCb9LbMX+TFAoIQo/wgP5XPyzLYakO+94GrgfZjfhdaxPXMsl2+o8jhp/hlIzG56taNdt
 VZtPp3ih1AgbR8rHgXw1xwOpuAd5lE1qNd54ndHuADO9a9A0vPimIes78Hi1/yy+ZEEvRkHk
 /kDa6F3AtTc1m4rbbOk2fiKzzsE9YXweFjQvl9p+AMw6qd/iC4lUk9g0+FQXNdRs+o4o6Qvy
 iOQJfGQ4UcBuOy1IrkJrd8qq5jet1fcM2j4QvsW8CLDWZS1L7kZ5gT5EycMKxUWb8LuRjxzZ
 3QY1aQH2kkzn6acigU3HLtgFyV1gBNV44ehjgvJpRY2cC8VhanTx0dZ9mj1YKIky5N+C0f21
 zvntBqcxV0+3p8MrxRRcgEtDZNav+xAoT3G0W4SahAaUTWXpsZoOecwtxi74CyneQNPTDjNg
 azHmvpdBVEfj7k3p4dmJp5i0U66Onmf6mMFpArvBRSMOKU9DlAzMi4IvhiNWjKVaIE2Se9BY
 FdKVAJaZq85P2y20ZBd08ILnKcj7XKZkLU5FkoA0udEBvQ0f9QLNyyy3DZMCQWcwRuj1m73D
 sq8DEFBdZ5eEkj1dCyx+t/ga6x2rHyc8Sl86oK1tvAkwBNsfKou3v+jP/l14a7DGBvrmlYjO
 59o3t6inu6H7pt7OL6u6BQj7DoMAEQEAAcLBfAQYAQgAJgIbDBYhBBvZyq1zXEw6Rg38yk3e
 EPcA/4NaBQJonNqrBQkmWAihAAoJEE3eEPcA/4NaKtMQALAJ8PzprBEXbXcEXwDKQu+P/vts
 IfUb1UNMfMV76BicGa5NCZnJNQASDP/+bFg6O3gx5NbhHHPeaWz/VxlOmYHokHodOvtL0WCC
 8A5PEP8tOk6029Z+J+xUcMrJClNVFpzVvOpb1lCbhjwAV465Hy+NUSbbUiRxdzNQtLtgZzOV
 Zw7jxUCs4UUZLQTCuBpFgb15bBxYZ/BL9MbzxPxvfUQIPbnzQMcqtpUs21CMK2PdfCh5c4gS
 sDci6D5/ZIBw94UQWmGpM/O1ilGXde2ZzzGYl64glmccD8e87OnEgKnH3FbnJnT4iJchtSvx
 yJNi1+t0+qDti4m88+/9IuPqCKb6Stl+s2dnLtJNrjXBGJtsQG/sRpqsJz5x1/2nPJSRMsx9
 5YfqbdrJSOFXDzZ8/r82HgQEtUvlSXNaXCa95ez0UkOG7+bDm2b3s0XahBQeLVCH0mw3RAQg
 r7xDAYKIrAwfHHmMTnBQDPJwVqxJjVNr7yBic4yfzVWGCGNE4DnOW0vcIeoyhy9vnIa3w1uZ
 3iyY2Nsd7JxfKu1PRhCGwXzRw5TlfEsoRI7V9A8isUCoqE2Dzh3FvYHVeX4Us+bRL/oqareJ
 CIFqgYMyvHj7Q06kTKmauOe4Nf0l0qEkIuIzfoLJ3qr5UyXc2hLtWyT9Ir+lYlX9efqh7mOY
 qIws/H2t
In-Reply-To: <atX3lpXQBHH1JPhW@pedro-suse.tail5790ac.ts.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 0B0532000A
X-Stat-Signature: i5a8qncjx9b4i5pdmtcqe1o31ofqob3z
X-Rspam-User: 
X-HE-Tag: 1792412609-393674
X-HE-Meta: U2FsdGVkX18/45rv/ule/P1li/WbECGdY8oeJtfh5eWj/a8hUl6hFL6gpj6zusKbYNFWFqp4bbGDJwc7Y9Y9PIpqMxFOVf/8UXkV8NiwwxpDABusoLkoZlzZTk5r1OHCXyLyE6RDS4h1L1/QgyOW3sNxtqIpuMH5zBxXQZobQir2NBpJKoxarI/lyVuUT5KSMPNl6hcCeo168yHXfqfKzaGTmNq/9q5+N6282LP5bt2pHEd/ZfD65UESmNQQvQDJ+Ogc7ylKGbkDE6VOJC3iVPaHWuY3H9OlrnGcW64O71EEwCT/JmplAOtbnpA057uxZoItD8k1HV97XtCXSyZqUlZHJGMjeUdWL3B4ojDnSOkXMNEViefx5YdkRYoqtX6xbhBfSsdhuHotIZ3MDANwZnq8vXW3DYaTfIdMxK2Q9H/gdTEtJNWvX0iE309phXM5CL04LAEKM212HWtw7PGI4+sPsjxteOUnsZRrL4y8H1wtiV+wDIOtGyuzF9GKHEYsZ386UtoaRfAqtTaGI9TZcd62fcW+/54mM8ln9b+BtRuDLrZ01kQXDKvHsldNMmHSj0Ltrj2JCtU2FHIGGt+JPTIgHZ7V7A01esYPW1VdUQ+PDTQDyles+fVXwRBnC8bcD0H0E9eboznPW4Q5u9C7p50HMmLVrWp9w+IKn7cbL+utolOsAUejxlR+LQ1nRGmUE50lC+Dzts6Y0RRPjA5/PdCLHAJoYygG9vV7woJT+HHg2Jxtp92OBYeXuAl/sOs6kzE6jaqcoX45mPMsiW0cUyE2cb50/qy6aWOlbNr6V8FEh+miTP9rS8vq/Y1twY/bBcdpNDOfS6nAP8jdC0xZDW5h0HpdHYNnsJTVKlGmAc+AUatOTiq266H0xmBUZscuJtWjN3Z/lbOjG85TWpYb7R56rB5FZmEAfQxmD72H2Q3L16elK4uOwlNhZX8PyPFUxwh06rxqqBVTQBUUlyM
 2DuOQF3Z
 5Vpy/n7U0agzYIoPXfbgw0tnY+t5IN96WNfQ9Ffis/Wlmz102No2EGpLb/sfchIueOASMi8rTPTrcCJacozs0XzQV3j1m5mmEFr7j32ubvtv8WbaF4GU9JvHgqfnzuB3zRFB59rR2araovqWStVqvjphXSgTNiK1JpAfTRjHpGqgRyqH0fY54Y3rIr4OX/R5Ija+2DilottVPXZ759Oaaz63KMT4fXL/jyw+0m2HnNZlnx63Gn8FEImqKkMnNQVImUyXQ6CPMb+dtb1x5c6LrF2V+M7EMG2g/iMJXP/EiXCueeZcU7xxm7jjZ8hG+WIqVyut16XIMEX0tUzA3t8nEYE/sr4uu40OHRzdEhY3md2+i1pelrmMOvRzl3Jvi3eTaPLKk
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

>> +}
>> +#else
>> +
>> +#define COPY_MC_PAGES_NON_PREEMPT_BATCH		1
> 
> I would suggest that perhaps this should be the fallback for non-preemptible
> models. But it gets a little weird with PREEMPT_DYNAMIC I think?

Why can't we just use PROCESS_PAGES_NON_PREEMPT_BATCH where we have similar
handling already?

> 
>> +
>> +static inline int copy_mc_highpages(struct page *to, struct page *from,
>> +		unsigned long nr_pages)
>> +{
>> +	unsigned long i;
>> +
>> +	for (i = 0; i < nr_pages; i++)
>> +		if (copy_mc_highpage(to + i, from + i))
>> +			return -EHWPOISON;
>> +	return 0;
>> +}
>> +#endif
>> +
>>  static inline void memcpy_page(struct page *dst_page, size_t dst_off,
>>  			       struct page *src_page, size_t src_off,
>>  			       size_t len)
>> diff --git a/mm/util.c b/mm/util.c
>> index 7f374bb8bf36..5015cfdfeaa5 100644
>> --- a/mm/util.c
>> +++ b/mm/util.c
>> @@ -763,13 +763,23 @@ EXPORT_SYMBOL(folio_copy);
>>  
>>  int folio_mc_copy(struct folio *dst, struct folio *src)
>>  {
>> -	long nr = folio_nr_pages(src);
>> -	long i = 0;
>> +	const unsigned long nr_pages = folio_nr_pages(src);
>> +	/*
>> +	 * Copy the largest extent possible to allow for architecture specific
>> +	 * extent based optimizations. copy_mc_highpages() does not call
>> +	 * cond_resched(), so limit the unit size when running under
>> +	 * non-preemptible scheduling models.
>> +	 */
>> +	const unsigned long unit = preempt_model_preemptible() ?
>> +				   nr_pages : COPY_MC_PAGES_NON_PREEMPT_BATCH;
> 
> See? now mm is aware of preemption models! eww!

Yeah, we have that in clear_contig_highpages() already, which is getting
replicated here for copying instead of zeroing.

-- 
Cheers,

David

