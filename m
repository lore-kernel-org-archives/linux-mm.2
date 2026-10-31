Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C5674606A31A
	for <linux-mm@archiver.kernel.org>; Sat, 31 Oct 2026 10:01:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=oh3tIIHc
Received: by kanga.kvack.org (Postfix)
	id DB1ED6B05B3; Sat, 31 Oct 2026 06:01:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D89A76B05B7; Sat, 31 Oct 2026 06:01:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C9F666B05B8; Sat, 31 Oct 2026 06:01:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A26FE6B05B3
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 06:01:42 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 31F071408E0
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 10:01:42 +0000 (UTC)
X-FDA: 85382479644.18.5BA38A9
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id 5C9CF40006
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 10:01:40 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oh3tIIHc;
	spf=pass (imf07.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793440900;
	b=0PRR/Xhu4gqNN/4sKnZ9IidUtNx9IjRn3v7A4kCNyYRi+25l0xxGC+5zcfvgHMrGobXex0
	G5tVv5c+o+XoA3azMQF40InKo8l0qLo4PQ2QQuHY1TcMI4SnwMo/1OV5OiJjxvrzTnGXzj
	cj0LssgxZ3JFmaH2qdFT4h/SsgVjCVM=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oh3tIIHc;
	spf=pass (imf07.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793440900;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7JYRAu4hmle3e+tmlKVwJN9rE57Jf6g2AoH9AwZHJo8=;
	b=NbaOK5CXa/ddcnGcabdlt3m/AGOzPVlUd+WtWQu6/4+6ITIyd15ylxzB6YufFkVB1CmM/k
	MBgxHqTU21fGk137TVXX2f7SP/mzUaW6RYsPGWDNfzPNjL0PfMJOEoHqPX/M8dB+kKYnrE
	zvhKNAPUhjbn+pf9vDIxamwAMS2d3tA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id DFE44600C8;
	Sat, 31 Oct 2026 10:01:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAEAE1F000C1;
	Sat, 31 Oct 2026 10:01:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793440899;
	bh=7JYRAu4hmle3e+tmlKVwJN9rE57Jf6g2AoH9AwZHJo8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=oh3tIIHcPFh7UHKvpLtOWD5ADyL2EmR304OGIDBULi6Uu3/+uj8Ky5UM+i4Yj6Jg5
	 XHA3GR8+N1LxmbNZFc0pQp3U0WAknpFU26CviLyMTpmVLyHrM+izn7MmJy2jAH6D9m
	 ioIQcwJgGz5ODBZo2aypRQJ4iX2M79ZoEh6gFnv7OJ+EuTmDklBzXi/8csanqk2vk7
	 ZRiJRnrZjpw/cZ9CeJX4oLX9kEYYVG4vCBnB1O7NnjfkreMeUq5smdtsopTm/wluRs
	 vt4z59AflBiRzlthWdT0qJBpe5tblpqiCEO1IPXHUUY0+Gn2gzURUAat6VqTmw4+O2
	 OdvdQGUaJ0WAA==
Message-ID: <75d664fb-d5c2-42c5-80a7-2316beb0ef3e@kernel.org>
Date: Sat, 31 Oct 2026 11:01:30 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4] khugepaged: fix readahead lock inversion in
 collapse_file()
To: Lance Yang <lance.yang@linux.dev>, akpm@linux-foundation.org
Cc: ziy@nvidia.com, baolin.wang@linux.alibaba.com, liam@infradead.org,
 nico.pache@linux.dev, ryan.roberts@arm.com, dev.jain@arm.com,
 baohua@kernel.org, usama.arif@linux.dev, kas@kernel.org, jack@suse.cz,
 djwong@kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 hch@lst.de, pfalcato@suse.de, ngocthang2710.1999@gmail.com,
 syzbot+16bf7cd0ebeb1de93aa5@syzkaller.appspotmail.com, stable@vger.kernel.org
References: <20261026152013.10511-1-lance.yang@linux.dev>
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
In-Reply-To: <20261026152013.10511-1-lance.yang@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: qhyqsg36od1sefuusj3g5gdxxcs3p8n5
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 5C9CF40006
X-Rspam-User: 
X-HE-Tag: 1793440900-175103
X-HE-Meta: U2FsdGVkX18fM1SVKiinJU4/yVKJ+nZYE0dSexmWf0S1WGgINMawgLM8bIIObG4/3wWSCILFrtE/iahhwYeb5B9q08MYPQp9dgvzX7JdDmALf+4JNNHWwoPKUBN74kjqCqjCAj62Cx4vdGeNpWRVUi7CErOakP9Zx/eEKrd/zpzsbeM/qjd4PDUl+yNuXckxGyWUGKS5iW3z05hFexZ+RjZoaU7kVXn6APqWeXVXIwq1TYqXMAmYjGYJnphmo8v+BOJYFOLb6dTUFih2SCRa/Z4ASeTs7cXeOZPzAUz895O3kwVzeO2bF/d9xzzBns9iMnCWa6zZl2tmQWa76ewHLw0xxGyNOWENIMyVKXFUp+9F6WQaavWxokrJntelTA9pE4L6HQ2/GgqxqbZGZPBNsP/ydxZZl9e2+T3lnslpVJLipVJk8XkvUJsr9kQ+BQnC6+O+swMzCUKnXXvMvvRn88/XNDuiglau43b1EWSZYDvNH8nPCe/6CrtbzpnsI9Rryn0yTLk+P/TbJA7yzWHr4I9bJe/EJ2bvMpJCQ+5HgS8LRs87ERnGDYjif1U4T/JBw0bK55XBek9i9L9cN1lL8YaAFchS+j1qqzrHsxbKnHbv7apKoUCeWSvJyXoyeMGShfFvb0ZKw+lYOCU/y6/F1Xg9h98GyfTKSDi/y7uzvJckLQznQpTYBaWWnxfoR6V88MAUHOAfiRIeKjwL89pMoTpbXBpGi93ksSZpIU2lrno1gfJH8h3DDBWoN0L7uf0+MIJOaeR6wxLOTWSgEZplEodHjRD6jkK/HvvCnPTwb/jTaPaefgA+Jo+Duhm1BDeVbFuoMggBj0x7PqTsW++BpoE1dlWmgftnorBA4Mt1+bNI4i4/D4+ZnKswgalTfObAxpVQpFQpImk3BdxffT+wFIZlIA8czrjp0rqzFSfVcUrG37XAO9LNYQ7ONnbQOp4jOs/tP/g80yw2KHLOSZj
 I97/bv9d
 AhswsbbIt1CRV6J6FArEdiliWzVC3N10kgvHDjzYB8O1rRt8xEYvOZIlleZTCDGcKP4clqFBrU0kiZa14EYQ9GXx0523Sj1KkFETjSRrwO7+LI+ikRpqE6wiafEmAvVyiP1NunI7ZQL7dfUH8MrtufVo8PjRs53ILDZ7E+BwXPgprMczOgeRf9PhnQAqORF6zqPuyvgQ3kYJU+QGNbyiyabfxKNSe0ca2lw3U+XfofuzCxVi4y2DWLOaXvvRV7QdiX6usa5JR2NcFcxlUTnQDJ1EvdHvrDa0Kw4RnVWghBi1ir63zpqKKki5WF8KDvw0RlZwIpn42ZHQIvC65sCnKRl1GORfG9qUbja2+drNoQ2rXHL5fsd8x5MJxCTfPYdeh2OoJZuEToAKoUVDu6rXyLP1+YGdxSczQuHsXoPpw6Ata2vnp/qG3eegjNIHjszSmElIlZyHd0OnqnpizDtPQOuxczicY1+RCoruCHXCxTIRRYIIuOsO0DTCMFjt/CjnWCu0fNT0g4e7487qGfIeKNey3/AO2YpGH77YA/u/tJRFW5Zd20bZHjWX22yD3Fi31tdxXnAjLK2vIAnU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 10/26/26 16:20, Lance Yang wrote:
> collapse_file() can call page_cache_sync_readahead() while still holding
> source folios locked. If truncate holds mapping->invalidate_lock
> exclusively and waits for one of those folios, readahead waits for
> invalidate_lock and neither side can make progress.
> 
> We need to release those folio locks before starting readahead. On a page
> cache miss, roll back first, populate the collapse range, and retry once.
> Doing readahead after rollback avoids an extra pass when all folios are
> already present. If another miss occurs on retry, give up rather than keep
> retrying while truncate or reclaim removes folios.
> 
> Keep page_cache_sync_readahead() and wait for read I/O with
> filemap_lock_folio(), releasing each folio before moving to the next. The
> existing uptodate check during collapse still handles read errors.
> 
> Shmem uses shmem_get_folio() for swapin and fallocated folios without
> taking mapping->invalidate_lock, so it is unaffected.
> 
> Reported-by: syzbot+16bf7cd0ebeb1de93aa5@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=16bf7cd0ebeb1de93aa5
> Fixes: 730633f0b7f9 ("mm: Protect operations adding pages to page cache with invalidate_lock")
> Cc: stable@vger.kernel.org
> Signed-off-by: Lance Yang <lance.yang@linux.dev>
> ---
> v3 -> v4:
>  - Move readahead after rollback and retry collapse once (per Pedro).
>  - Drop the preparation pass and its redundant uptodate check (per
>    Baolin and Pedro). Thanks!
>  - https://lore.kernel.org/all/20261016065920.4153-1-lance.yang@linux.dev/
> 
>  mm/khugepaged.c | 44 +++++++++++++++++++++++++++++++++-----------
>  1 file changed, 33 insertions(+), 11 deletions(-)
> 
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index da91762f6358..0d3bd9e23613 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -2239,6 +2239,8 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
>  	enum scan_result result = SCAN_SUCCEED;
>  	int nr_none = 0;
>  	bool is_shmem = shmem_file(file);
> +	bool do_readahead = false;
> +	bool readahead_done = false;
>  
>  	/*
>  	 * MADV_COLLAPSE ignores shmem huge config, so do not check shmem
> @@ -2256,6 +2258,10 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
>  
>  	mapping_set_update(&xas, mapping);
>  
> +retry:
> +	result = SCAN_SUCCEED;
> +	do_readahead = false;
> +	xas_set_order(&xas, start, HPAGE_PMD_ORDER);
>  	__folio_set_locked(new_folio);
>  	if (is_shmem)
>  		__folio_set_swapbacked(new_folio);
> @@ -2320,17 +2326,9 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
>  			}
>  		} else {	/* !is_shmem */
>  			if (!folio || xa_is_value(folio)) {
> -				xas_unlock_irq(&xas);
> -				page_cache_sync_readahead(mapping, &file->f_ra,
> -							  file, index,
> -							  end - index);
> -				/* drain lru cache to help folio_isolate_lru() */
> -				lru_add_drain();
> -				folio = filemap_lock_folio(mapping, index);
> -				if (IS_ERR(folio)) {
> -					result = SCAN_FAIL;
> -					goto xa_unlocked;
> -				}
> +				do_readahead = !readahead_done;
> +				result = SCAN_FAIL;
> +				goto xa_locked;
>  			} else if (folio_test_dirty(folio)) {
>  				/*
>  				 * This page is dirty because it hasn't
> @@ -2657,6 +2655,30 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
>  	new_folio->mapping = NULL;
>  
>  	folio_unlock(new_folio);
> +
> +	/* Readahead may take invalidate_lock; source folios are unlocked. */
> +	if (do_readahead) {
> +		for (index = start; index < end;) {
> +			folio = filemap_lock_folio(mapping, index);
> +			if (IS_ERR(folio)) {
> +				page_cache_sync_readahead(mapping, &file->f_ra,
> +							  file, index, end - index);
> +				folio = filemap_lock_folio(mapping, index);
> +				if (IS_ERR(folio)) {
> +					result = SCAN_FAIL;
> +					goto out_put;
> +				}
> +			}
> +			index = folio_next_index(folio);
> +			folio_unlock(folio);
> +			folio_put(folio);
> +		}
> +		/* Drain the local LRU batch before retrying isolation. */
> +		lru_add_drain();
> +		readahead_done = true;
> +		goto retry;
> +	}
> +out_put:
>  	folio_put(new_folio);
>  out:
>  	VM_BUG_ON(!list_empty(&pagelist));


This create a merge conflict with my large series.

I'll pick this up myself and adjust it, so Andrew please drop it.

Thanks!

-- 
Cheers,

David

