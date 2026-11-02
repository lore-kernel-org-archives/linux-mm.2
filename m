Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 02208606A331
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 10:03:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Dx+/iD7G
Received: by kanga.kvack.org (Postfix)
	id 2E4EF6B05B8; Mon,  2 Nov 2026 05:03:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2BBAD6B05B9; Mon,  2 Nov 2026 05:03:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1AB096B05BA; Mon,  2 Nov 2026 05:03:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E73866B05B8
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 05:03:10 -0500 (EST)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8D815120A39
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 10:03:10 +0000 (UTC)
X-FDA: 85389740940.30.33E907E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id CF35D1C000A
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 10:03:08 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Dx+/iD7G";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793613788;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XFsKGmo7DMNhEgVimoBDSNS68WkiA1IPOa/9oNM+BB4=;
	b=6D3hkOWgLn6bomJOEJZpUBNZL3K6ZxCVpPMiNgVvOJXa69+NapEJxemheRzgwdixgQDKAU
	YsHagagZGn81Z3Sy6azELZ9pu8BdIAEOuF8Z5C6HOFBNL+rgbEvZiwp8ZW523LROv2FR3e
	ti7E9yaR6V1guPdG/hYUivr/2zedwcc=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Dx+/iD7G";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793613788;
	b=rny6CEvap1P1jMCF8iYJ4LVXlGqZfui2QBdfrkwK3woOrYiHQwFecYeZ8ZjKXR5zYJo2J4
	+631fsLOlUe8D7pqAKCsjwMp3o2lwa0Py79zU1LKcKUKTX4+kfb8RU3oxFmYK6pWokUieH
	nieuaNoCBw2lUMki09b5n09LArk2ED4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5ECA560ED3;
	Mon,  2 Nov 2026 10:03:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 084631F00A16;
	Mon,  2 Nov 2026 10:03:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793613788;
	bh=XFsKGmo7DMNhEgVimoBDSNS68WkiA1IPOa/9oNM+BB4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Dx+/iD7G5omWWNtLm9rXXBkqcFwFkpoV76w5JNFRfp9yaT0+bhh/RjhOIuG+7G4qN
	 X2zVQRBD9lBhtZPVFF7juoB7NTlANCgV47sLwYMQge/HcVZqJ2CRX+cvKoubOocBgO
	 lbE1CsF2C42viDYG5fOpNDKXC3qRw3dcYR4l3qyytWKTmTOGu1vicyG/Irc1yH0TUM
	 dkXC0NIzX7c01rGN7UxzIoKewKteXkPkKNuqNEe+Vp8FCp6txT/L6jbX/NZqYzPTeZ
	 0LQp5enljFBJOzeYZNHSkO3LUZZ2dyChPkvodXurwerhhsXrTBCDJzPARuNRkxqBF6
	 i+6Enw55VMVlA==
Message-ID: <a0647590-f937-473a-9603-7efb8803b39c@kernel.org>
Date: Mon, 2 Nov 2026 11:03:03 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm/memory: use pmdp_get_lockless() for the pmd read in
 do_fault_around()
To: Hui Zhu <hui.zhu@linux.dev>, Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
Cc: Hui Zhu <zhuhui@kylinos.cn>
References: <20261102093120.92654-1-hui.zhu@linux.dev>
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
In-Reply-To: <20261102093120.92654-1-hui.zhu@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: CF35D1C000A
X-Rspam-User: 
X-Stat-Signature: itc3a63ehujypphfnj8r9n8cqmi6in7c
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1793613788-781936
X-HE-Meta: U2FsdGVkX1+PsTxH8Qe4gU+PovOZBlWz8JFpsV1UdM9HvIgwg/k253KJrg9bTkEq9iA3N/4kjEsGIpFgvL1IuWpWs6+CzLZfmIUH9vQaf3YZpwD0cZyIkxNW/3Nb9vQUllyzPso6oMdpIjdr8pIvbqKMHYJkd4hJIdChskQDxOSWMe/ibM1wFSSBDB2cPcX7GTKQJ1W9asCDPUK1Oudv1grwnAVWLG4SrQzOoQQ57puHdTp58TihTEmEpIPE9W22NFEsahSehOHedSMpgPG6qvBz3nRGmqia6s63KlSijA9dH2kTCWcLoqK0RV9THHt7SHPxODfqoND+Au8vO5ZWYW4n5IPQdChj+XKW/IlHwmjDw+yqHTZTHrZGUgr2YRdf6lpivP+1zRT7fcI8oOubax9ouSQ7V2zXSgsewSc32dgbk3/OtA3oXJrSp3niGTrzwhisJTSRBLrIZH5qzfAxS/4CNLRMmXMV9BdVNCiE/pCG+73R920qKMcnJEKhzoc3N9U1RHlvxljim/r4BeiVEamTHmfANX+wevvMfWh0zUooU7njYx6Q2s4zEUanOJou4TuSX+uA5AOIKuaSQat+feJYiOZMmF6zVSz44gmIbhC+tcyUFV0Gc12zGxuBpB8X2RawOllZVkI8AdTtN589BffiJqb5N8F8ZMHmmjv35E/BvHAGtnlORODzy6k0BdqavCAjYLCS458TZC25gg1T7GdH5gausZmwslud4MIiMbwysBW53qBMoCUDTXo1X2lHlmgkmzgNPw5trTkxYdePLxv9w5ZTsn0BKO4Iyq3bF25SQTmr6Ukl9y4e2m5CrFcFvuxqaq3znapOcN2ynMk6Ah7YwYHtz/OWtNaRgKA5LLVNCFdqau0rUbFynJqx+7m55HNNAkcep0rBT/aSQaGgLI1f8qSgGU1QvQ6ekJ+ahqamrRaxhb10WMNgHjK7ZhSaauXBO7K6hgIRxR4vUQL
 FgxHuh+p
 Rvw2YeOr/N0K/rWhz0tj6//0po7I9mR33e523akHrAZTVR8TX5ZvS3kaDM3DJ9GORRR453EcwsG2jiMdTJcMKJ6FciAyEeLu2tdaO3JWqPgCyoqKDf6ImcXZ7LPikzyZuLsg/BR9a1fLMHHmI23aMgfUGlh8dlnCxMuaM80kpvaxT3IKsFflB19lfIFIs9l21UJ1dwMx91sNADtcKkqN8EJr+LOPcfLiUTR+zDrxtTlbQi1ik463UFgRoHaBXDRtZvlOi1y8u2gx7gjA/W/Y4hJBCAdWVUNhfohSNsFdMrjX1Jb4M2OFLlRKAFw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/2/26 10:31, Hui Zhu wrote:
> From: Hui Zhu <zhuhui@kylinos.cn>
> 
> KCSAN reports a data-race in do_read_fault / pmd_install; the same code
> is in mainline:
> 
>   write (marked) to 0xffff8d52a75fb810 of 8 bytes by task 27487 on cpu 5:
>    native_set_pmd arch/x86/include/asm/pgtable_64.h:83 [inline]
>    pmd_populate arch/x86/include/asm/pgalloc.h:84 [inline]
>    pmd_install+0xe0/0x120 mm/memory.c:444
>    finish_fault+0x5bc/0xb00 mm/memory.c:5204
>    do_cow_fault mm/memory.c:5432 [inline]
>    do_fault+0x5d0/0x6e0 mm/memory.c:5526
>    handle_mm_fault+0x211/0x4c0 mm/memory.c:6218
>    __mm_populate+0x144/0x270 mm/gup.c:2207
>    __do_sys_mlockall+0x2cd/0x380 mm/mlock.c:764
> 
>   read to 0xffff8d52a75fb810 of 8 bytes by task 27527 on cpu 9:
>    do_fault_around mm/memory.c:5341 [inline]
>    do_read_fault+0x162/0x670 mm/memory.c:5381
>    do_fault+0x31a/0x6e0 mm/memory.c:5524
>    handle_mm_fault+0x211/0x4c0 mm/memory.c:6218
>    faultin_page_range+0x227/0x530 mm/gup.c:2156
>    __x64_sys_madvise+0x67/0x80 mm/madvise.c:1479
> 
>   value changed: 0x0000000000000000 -> 0x000000001386c067
> 
> Both paths only hold mmap_lock for read, so do_fault_around() tests
> vmf->pmd while pmd_install() populates it under the pmd lock.  The race is
> benign: a stale pmd_none() only wastes the prealloc_pte, which do_fault()
> frees again, and a pmd seen as populated only makes ->map_pages() find no
> PTE and do_read_fault() fall back to __do_fault().
> 
> The load still has to be lockless-safe.  pmdp_get() is a plain READ_ONCE()
> and can tear where pmd_t is wider than a word, as on i386-PAE where
> pmd_install() publishes two words with a single cmpxchg8b.  Use
> pmdp_get_lockless(), the accessor for pmd reads without the pmd lock and
> what __pte_offset_map() already uses on this very pmd a few instructions
> later.  It is pmdp_get() everywhere else, so the report is silenced the
> same way.
> 
> No functional change on architectures that can load a pmd in one go.
> 

Do we have a Fixes: tag?

I'll give this some review time on the list; once review is done I'll queue this
for the next merge window.

> Signed-off-by: Hui Zhu <zhuhui@kylinos.cn>
> ---
> Changelog:
> Use pmdp_get_lockless() instead of pmdp_get() (David Hildenbrand).
> 
>  mm/memory.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/memory.c b/mm/memory.c
> index 0fb676dd2bd63..2c1e50b70faeb 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -6017,7 +6017,11 @@ static vm_fault_t do_fault_around(struct vm_fault *vmf)
>  	to_pte = min3(from_pte + nr_pages, (pgoff_t)PTRS_PER_PTE,
>  		      pte_off + vma_pages(vmf->vma) - vma_off) - 1;
>  
> -	if (pmd_none(*vmf->pmd)) {
> +	/*
> +	 * Lockless: pmd_install() rechecks under the pmd lock, so a stale
> +	 * pmd_none() here only wastes the prealloc_pte allocated below.
> +	 */

I assume this comment can be shortened. Can be changed when applying.

-- 
Cheers,

David

