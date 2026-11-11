Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0953A606A321
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 12:52:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lV9/dT8F
Received: by kanga.kvack.org (Postfix)
	id 05B036B00EF; Wed, 11 Nov 2026 07:52:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 00BDA6B05B0; Wed, 11 Nov 2026 07:52:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E3CA46B05B1; Wed, 11 Nov 2026 07:52:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id BD1BB6B00EF
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 07:52:30 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 5E9BEC02C0
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 12:52:30 +0000 (UTC)
X-FDA: 85422826860.27.A0B7A84
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id 983DA1C0005
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 12:52:28 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="lV9/dT8F";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794401548;
	b=tS0FAs7u32d5Qy3ARtSZ1130bmIx1+cUp/tgA4zJH8+mPBgUn3rYsWPwi6k0w+zNspuEWA
	0VDdIzhwB3Bjct8XvajxhaNFhC/vC1yBDnd4xhUtAhm65a052VgWpwzICT+SjDqq0q2h82
	I2Uz3r86Qo7Fo8YOn22AE49YBpZch1M=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794401548;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8EaOYw3Ns7m59pAEKopA3/8l+QWoCfeJZjHCMiNoUTw=;
	b=bWYNcFcReuMOUIokYX+fwsWHVXjHksNGSR4uZfy82U+ll9SsCl/SsXd+0VM3aP2ejh5nQc
	9oFdT+W6iPXzamb8YaIob+QS65csX1G07w6NIilMGEYfDs5cYuHbcyZZ96goB5tnIrfk95
	Mb/EZ5YbFSkZ2QOsGCUlI2fiZupzcMQ=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="lV9/dT8F";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 8D86961D3C;
	Wed, 11 Nov 2026 12:52:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6A8D1F00A05;
	Wed, 11 Nov 2026 12:52:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794401547;
	bh=8EaOYw3Ns7m59pAEKopA3/8l+QWoCfeJZjHCMiNoUTw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=lV9/dT8FHtdDoJpmXQ0Sy1v8sQyBKBrYr/BK878gTWYi52sLwjNxUBCbjV8eZKIL3
	 sagrUd9iT3OSHGfcxTTqoO0fABAXkOK+KwnjfUcI/tmNdjThAiet+pKWRb9Wcu9XBK
	 CDzvHY2EcQ4GQG4JZM4jywaYIiwgB/YRNQMAF9GDxge6c0TOjiHNEybfJoFW+gpSLO
	 t3meqPrxAtEvpoZgfGoLzSSKBuTOnOXfx7k8vXSAKsADCmHwSnBAKcEke11OWlQ+hD
	 0Z5LR3bBkbC66NJ1hKtDexbWuNF082TWoI0VeULw9rkGzrFU2mxUd+++7x/CbD95Si
	 R1yVYngZ1Onsg==
Message-ID: <9575e79a-4cbf-48fe-bd3f-ff89e2ffdb92@kernel.org>
Date: Wed, 11 Nov 2026 13:52:20 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC] mm/filemap: fix lseek() skipping a new large folio
To: Jan Kara <jack@suse.cz>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 William Kucharski <william.kucharski@oracle.com>,
 linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Chris Mason <mason@kernel.org>
References: <20261110-lseek_hole-v1-1-c089c960b846@kernel.org>
 <wkpls4kiwl3ktyu5ekahlchabnaqq45o4tgv26cmrs552ljse4@oczec23ankdt>
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
In-Reply-To: <wkpls4kiwl3ktyu5ekahlchabnaqq45o4tgv26cmrs552ljse4@oczec23ankdt>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 983DA1C0005
X-Rspamd-Server: rspam12
X-Stat-Signature: g6bd3suy9n1tfujd5tkmibhni1f73bs4
X-Rspam-User:
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794401548-921244
X-HE-Meta: U2FsdGVkX182b/4VSzbCbPq9pIennHeSgDD9JqBD9snEQFYMvQ6b+2mKoPhNqDe8HPqOhqXXaJikir9o6XX/Ttv4Q2ChBUxdZ6/6farhv52JAQqQ7TFpvrdmcY+AgKMTgiN1FSa0VubDcDDxwD1bphTJAs7PS3XwI52n+kGgv4okYY3WPlxKcUKfRBmhTLEwf9V60WB33Ah44yLrN+DGLZtLFB4PuqwMJIB+9MYTuZHL+qnzdbnl1d9v1wOAmqDDZYdLUuqfx0zBTfrO8JsOA8GbjsR+MLiqAtG7IE3kGTzldPO6XJ/f/Z6Omar1yIORSst1vTQ+01RxZU33tg1JTVrLu8tJUe1u1str1tJSCr+0qQxtiDNEGCal5crupjRGB9ZCCwuk4J6OOcUWnEePzKdd2Y2J0Vttl8ZOpG1Ru1FzMnsI1Tdw7rwgx1lXoCz88CBRm4BDfrSzZQhFyL5TKU6qKLG+36pYmTLs0mxEM9wmWTIq5NQrTda83NZTChORF/I1AqlmZJ+/mKnMI0DltWpdx5fh9i7rLToVJnCKNZ72Js+j0JfDk7VyZ6jynQB95GZjF+eDYJ+OcFQKPyL4eKwwEEOm/Iw0Fjp9iEXIJ5Y71vT+yUabnpjpNJNF7tM6gRcs0R9FHHhMH+GI/7GRFV/ICG33YviHD/D7ikNbHkMZ3TbneuTJUDS8gTEQpP+RrZxiCsyzkIG5wA5fO/NM1hTC+tB2NxOlKrqdXHkjx6lm5ihhJkKV1XIPLSEiVUc2rFyPyLFhqqLXJKiNzWABLr1/emhK0qgVD450wX1du/UxO0/3D1eZSNh0gpJgJuZr3LeZLW4oLP6fd49ou5nJ9amo6062CuU1OP/ShrGCrUZsz4taUYxQVa32H6WFF00g4dq1wa07a1eYtdocpQINhy5J8yfKkxeadvdZZ9vsnOdVUcn9orvZVN35PnGGCoGT9zympuIAcaNDZx+pFuD
 qJq2s6aO
 xAJl0qBXUXsw17u6+dFzRDpg0gJSs6o6wRH8kSCRmLCvQZZb08MET4LV+1mVyUBFc0Pm/xxFBU0xelO600MqmbXzjF7vuK5rP5e/K+vtkztoux5JKHBtn7QgOgrBmymEeCEDAQZBdeyg5AP7bYcpc32pOKfAA3/7cMa57r351nYVpDWPzv1j9a0hXXricvR/5fnmdM5K6oiSXzSNZazZJULwh5ZoRTveXT9+yeXrrnBvKaWhfgvoAbuqxMiVRoMYTlRbM/lOFvr23eXPvuW7Dsc/VDcQttUeCWV9IEhfA7YU0QamW3dKuJiSZvpuhIlUdDgfIVK59ELqY8sydDvqpRaTCj5shY7TSbLzcE+psYJk14NZoY4zpnJWY7suGme1exiKLq4rdQpagknRCNhWxigwBL0ZyofeEQhkmTVGBuo4xF0cGpXQOJL1c7A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/11/26 12:45, Jan Kara wrote:
> On Tue 10-11-26 21:33:12, David Hildenbrand (Arm) wrote:
>> mapping_seek_hole_data() walks the page cache under RCU and only calls
>> xas_set() after entries larger than a page. Between base-page entries,
>> it continues the walk with xas_find(), which skips sibling entries
>> to return each multi-index entry only once. If a large folio replaces
>> small folio entries between iterations, the slot holding the new folio
>> can lie behind the cursor. Skipping its sibling entries then skips data
>> that has not yet been examined.
>>
>> On tmpfs, SEEK_HOLE can then return an offset inside existing data.
>> SEEK_DATA can skip data after a fallocated page that is not uptodate.
>>
>> For example, assume a 2 MiB tmpfs file backed by 4 KiB pages on x86-64,
>> with page index 63 fallocated but not uptodate and all other pages
>> uptodate. Index 63 occupies the last slot in the old xarray leaf. A
>> SEEK_DATA starting there can skip that page, then race with collapse of
>> pages 0-511 into one 2 MiB folio. The next xas_find() moves past the old
>> leaf and skips the new folio's sibling entries in the parent, returning
>> -ENXIO instead of finding data at page index 64, or 256 KiB.
>>
>> The inode lock held by lseek() does not exclude collapse or swapin.
>>
>> Restarting the xarray walk after every entry fixes this, but increases
>> SEEK_HOLE time about 24%, when scanning a fully written 1 GiB memfd backed
>> by base-page folios in an x86-64 microbenchmark.
>>
>> Instead, use xas_next() for adjacent indices. Restart the lookup from the
>> root at the requested index if it returns an empty slot or an internal
>> entry, including a sibling entry. Also restart for nonadjacent indices,
>> invalid iterator state, or failed folio validation. This avoids skipping
>> unexamined data without restarting each lookup during base-page scans.
>>
>> Fixes: 6b24ca4a1a8d ("mm: Use multi-index entries in the page cache")
>> Reported-by: Chris Mason <mason@kernel.org>
>> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
>> ---
>> I'll be more than happy if someone of the pagecache folks wants to take
>> over ;)
> 
> This looks good to me. Feel free to add:
> 
> Reviewed-by: Jan Kara <jack@suse.cz>
> 
> I just find it unfortunate that we have to play complicated games like

"unfortunate" is a good word. I'd have used "annoying" :)

> these for such a simple operation as sequentially iterating over all folios
> in a mapping. And it is not a first bug of this nature trigered by
> compaction. So longer term I believe we need to provide saner apis
> shielding pagecache users from these nasty details.
Yeah, I would have preferred the simpler fix, but ~24% slowdown gave me a pause :(

thanks!

-- 
Cheers,

David

