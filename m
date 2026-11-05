Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C1EBE606A32D
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 09:42:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=E7DFiWlP
Received: by kanga.kvack.org (Postfix)
	id D321B6B05B8; Thu,  5 Nov 2026 04:42:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CE1B66B05B9; Thu,  5 Nov 2026 04:42:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BD0316B05C1; Thu,  5 Nov 2026 04:42:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 8E0206B05B8
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 04:42:03 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 13319C099C
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 09:42:03 +0000 (UTC)
X-FDA: 85400574126.19.3FC8F68
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 362F220006
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 09:42:01 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=E7DFiWlP;
	spf=pass (imf13.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793871721;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PuufadtnrE0xPdkd4gRyzuQkUWzXAX5d0S4WuZODUDg=;
	b=xY5c5W+KRbwFwWAMyQBie24OBdX+WerazWeqnEBiL4jdyl89BvhU21Ixl2ikKnh5+7WvWO
	9ffUFM3Ps+cdZg+HvgUj3X50bNhV8PxvlN2j8fkzaV+NC1y+iaJK8n2fsGHDE5gw3+1l0E
	dG/jferjEjYJ7nVM04z7WS6LPYAmkwU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793871721;
	b=rQQZh4W+5wW2FVjM49umt2DcQHZhKT/NrUD9ZJsnRw9typ+f4Iryo5sLiaqJqnMhE/JQuc
	GSr++1DWDwvmmf6FoPAwvueo2Au13n+3YeSTJVTQawwcUhcblXoApYQ8p6kkdvGi1afu+J
	3GUR84FMhkW+DXGhacprtV/yHU193iY=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=E7DFiWlP;
	spf=pass (imf13.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8031243D39;
	Thu,  5 Nov 2026 09:42:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 039801F00919;
	Thu,  5 Nov 2026 09:41:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793871720;
	bh=PuufadtnrE0xPdkd4gRyzuQkUWzXAX5d0S4WuZODUDg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=E7DFiWlPXN+jU3UEAtnhc15nZ+zLEwXM61RKCdGBvxvuJ0zqYZfnE0qrzWTr1klqX
	 jFmVvTMJV7STZZpP9mCGdXuhG+WtnAsEq/WJaZ3z6xGC05yOYvRmWLYoMEDBfY0J8n
	 b1vxaNRoV9fAHLglExUTkjXKA6EcpstFU+zUCZk2QcYjAPHy9rRdDOTMuraP3xDiK3
	 2ea8yEPPjAJ2jQEu/VSzJICu1Yd9xc07F2P4XhwxSiqlSnOHmJrhq3jFlaQQPkvUdD
	 EGUpaIPE6FTx5ZuynzsW+0PRFaUzeAJZG1Cc+G2ZgDt9/nu4g3GtkzznhB3xlW5SWq
	 3CHDn2w30Jdwg==
Message-ID: <a29912a1-ccf5-4b3e-84dd-367de4849032@kernel.org>
Date: Thu, 5 Nov 2026 10:41:53 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/shmem: remove truncated folios from the page cache in
 batches
To: Jan Kara <jack@suse.cz>, Qiliang Yuan <odys.yuan@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Hugh Dickins <hughd@google.com>, Baolin Wang
 <baolin.wang@linux.alibaba.com>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
References: <20261029-bug-mm-shmem-undo-batch-v1-1-59b34212fe78@gmail.com>
 <dru32b7k62tbur7kmk6vv52zd6jnglnzzz4pvhlsqez6smcjip@gjuh6fud4nir>
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
In-Reply-To: <dru32b7k62tbur7kmk6vv52zd6jnglnzzz4pvhlsqez6smcjip@gjuh6fud4nir>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 362F220006
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Stat-Signature: tkd7smmx5ugrc9xeq7wjgqiz8tuuhxcm
X-Rspam-User: 
X-HE-Tag: 1793871721-862855
X-HE-Meta: U2FsdGVkX1+UbJnvnkISWA38koZ2UBiaesajGtke1z8rr2fgDImY2em/1ETwAdrHPArz5Y4LMXVuUCmUB3o/CsSjG7qV2KivZP9veRtDPFofkMMM5AVtj151YD4vgJuyrXRUqH4VR5bi6kX8B1GhOAxH3TJeG8WzzodRt4LRY+khH8fNpuG2j9VcF5pH7R0eTqS4kLjviNcLH3n9KEFwESa+Q+Zc2L1QyepTyiTLFpcrQ5socrJT7TC2FIGDQ5t2NSGDJ08LmaVcaXziWVW0R3e68Asw2DdpeQrw9kg7L00bgiFvK8jFxtfxpcxy5ErDWCl1Vtxyr1esPZw2v4ZU21G/BVLM2hxrqHjM6/1bUV3NvAsZxB82ZuwEQrTu+s22F+6CsObQJU93+mjQk/I3OPQVMmcAbLiX9qpgkv1Dkf4GuvI4sBzQLnvFq0n7MD6VKG5y7pptBEJuAKA7KOyJRmxDemq6b37XH7WtNl2Xh4OlhXU/7r93rWjqmRBuR3zY5ygtDuC3Vw/SGgNwi2W8kp4+71pg8HHIa+gwmjdCcsuszDGs7ewsxLQSYAnsXJvK9fSesbr68qdOv7i1rD57DTT4xo+e3xRFSvrJ59WRPmGzwyjTw5XTWdTJtm6sXs0Dz/hX22e0KN/pjEZRP8iGrKS12u34m5flGR07EeorluaqROT8aPDFzBrKtqTzoXSjybOX0o3cgC1OtyUahPLQRAirbrUATJZAai1z7oMmKWJg/V6y1b0yLLt31DGfECU/sfOvLNsL7L4oimfYUbD8gg2OLOQuzTxBHxfCsQPPMkhf61h/TcewLOgM5QMLZKoVslcqWttto7iJfXn8G6+FMYkKyCMh3KRd0uG8iG00Wc0oo/kUyxDjZ/n9FUJ07dvXFyb/T+nLM9iLcpheExQYi1qskrMqNK0RWdaSMfN0HRk6hHgeTfQg17wE/czPkSjK1yOnN3ugy/6O45yiWkD
 Jy+cV35L
 P9CAX5R/vcj8l0qfMd/l78ihXHUqnrw7t8tNQwDF0RiA86F7LOICbrAvvLol9myeRoKFpx4kpk8/h9Hc6leLJHc56ozyV64m/UoSC9LKuRZtJgFSjp0yRn5Fa3n3aLrimBRBdUxGbrLxb49Px9H1Zle+UFk0OXtdeyfnS0LXpEF02BPLeH0I5cCiuiSDAkUCeqS4i7eoBX6yySTBWJFWD4PaC2cYXyHzEvmqXD0ruelt1pt6+kLTeHSZe5wvUpmrveLvtjnpsA+cM1OLCfgur64TyHIqhbi1yQo8Sl6PyXYo8aRqkO109/jwkuvPE8ezRzCjohPUJEvEe8FVtYno0T1i4DqsMw8yz9C2tZzLuphfYC116g/WLQSY/rP4Q+jEipeNBTxVY/Jy3QcA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/2/26 22:46, Jan Kara wrote:
> On Thu 29-10-26 23:44:57, Qiliang Yuan wrote:
>> truncate_inode_pages_range() takes the folios it finds out of the page
>> cache with delete_from_page_cache_batch(), which takes the inode's
>> i_lock and the i_pages lock once for each batch of up to
>> FOLIO_BATCH_SIZE folios.
>>
>> shmem_undo_range() calls truncate_inode_folio() on each folio instead,
>> so filemap_remove_folio() takes and drops both locks once per folio.
>> Truncating, punching or freeing a tmpfs file or memfd made of small
>> folios, such as a large /dev/shm segment, pays for that on every page.
>>
>> Clean each folio up as truncate_inode_folio() does, collect the ones to
>> remove and take them out with delete_from_page_cache_batch(), which
>> needs truncate_cleanup_folio() outside mm/truncate.c. Swap entries, and
>> the folios kept when undoing a failed fallocate(), stay out of the
>> batch. Dropping an 8 GiB file of 4K folios, median of five runs,
>> averaged over two boots of each kernel, in a 32 vCPU VM:
>>
>>                         before    after
>>   ftruncate() to 0     1163 ms   913 ms
>>   hole punch           1155 ms   914 ms
>>   close() of a memfd   1161 ms   914 ms
>>   unlink()             1162 ms   916 ms
>>
>> Files of PMD-sized folios take 20-25 ms with or without this change.
>>
>> Signed-off-by: Qiliang Yuan <odys.yuan@gmail.com>
>> ---
>> To see it, fill and remove a large /dev/shm file:
>>
>>   fallocate -l 8G /dev/shm/f && time rm /dev/shm/f
> 
> Looks sensible. Just one nit below. Otherwise feel free to add:
> 
> Reviewed-by: Jan Kara <jack@suse.cz>
> 
>> @@ -1352,6 +1352,9 @@ static void shmem_undo_range(struct inode *inode, loff_t lstart, uoff_t lend,
>>  	index = start;
>>  	while (index < end && find_lock_entries(mapping, &index, end - 1,
>>  			&fbatch, indices)) {
>> +		struct folio_batch remove;
>> +
>> +		folio_batch_init(&remove);
>>  		for (i = 0; i < folio_batch_count(&fbatch); i++) {
>>  			folio = fbatch.folios[i];
>>  
>> @@ -1363,9 +1366,16 @@ static void shmem_undo_range(struct inode *inode, loff_t lstart, uoff_t lend,
>>  				continue;
>>  			}
>>  
>> -			if (!unfalloc || !folio_test_uptodate(folio))
>> -				truncate_inode_folio(mapping, folio);
>> -			folio_unlock(folio);
>> +			if (!unfalloc || !folio_test_uptodate(folio)) {
>> +				truncate_cleanup_folio(folio);
>> +				folio_batch_add(&remove, folio);
>> +			}
>> +		}
>> +		delete_from_page_cache_batch(mapping, &remove);
>> +		for (i = 0; i < folio_batch_count(&fbatch); i++) {
>> +			folio = fbatch.folios[i];
>> +			if (!xa_is_value(folio))
> 
> You can move this loop after folio_batch_remove_exceptionals() and drop
> this condition.
> 

@Quiliang, can you resend with that?

-- 
Cheers,

David

