Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 497A0FD45EC
	for <linux-mm@archiver.kernel.org>; Wed, 25 Feb 2026 20:30:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A3F7F6B0088; Wed, 25 Feb 2026 15:30:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9CCA76B0089; Wed, 25 Feb 2026 15:30:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8CE416B008A; Wed, 25 Feb 2026 15:30:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7BFD26B0088
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 15:30:46 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 3AF54BADD6
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 20:30:46 +0000 (UTC)
X-FDA: 84484122492.10.AA98203
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id 87D79A0009
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 20:30:44 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fPGASCeS;
	spf=pass (imf25.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772051444;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Qewo0TnhwR7uheqBw1RcyzRJGdvQdrTIJRcEjgEGSl4=;
	b=7hG0nhHckUOsltEZMjVGu9oHCcOlRfKaBreyohxHarZNox24+54rC9QNg5ipXLIVDpQjeO
	xUToWnNa7sNH02vZNLctUdEWkcAaXGyt9+buZGCV82MTgTfaNmZt3zjmr2sXX6X7H3R8tJ
	SEgPcRvq6Snwkv1BzwmI8IPda3neE1o=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772051444; a=rsa-sha256;
	cv=none;
	b=dGKqgaoutYQBfOJ/ZA5toLyg+ErfRHekpjXW/XWdD0Db4loePOUoo1nWBrJNSOEyZU3I2f
	4ac8anwCc5hOrSs+f/Nb9Dt+3EqYC3FNOXBxbuH8Lz2gnOmmp+uNM4XVGm+0y0Gp5/y+um
	tSp5WaprWD+XrA7V93uAcMHtR3cOPuk=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fPGASCeS;
	spf=pass (imf25.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id EDD0360053;
	Wed, 25 Feb 2026 20:30:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7049FC116D0;
	Wed, 25 Feb 2026 20:30:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772051443;
	bh=DhUwWF9hvGMT3GfhSRvYm1fO70kNv+3B4YZOWPsUAzk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=fPGASCeSeOBSuIus3pIwKH7JilctDyHytAqAyGOm8c6XSODdDJD7pbWc3K+qduibF
	 nfTzg/CQ6sWoynnR60Ge0Q8SXcElZG0MqtcoOKPJeA4Si4FA1fJgyjLumQ032a/C84
	 gkysUYg3HY7pwssEXRXve2jvk8oryG7mPWNPZcA8Eexp46sTX6Fxinp7r3aRqB30k7
	 AyyPtv6JT8OTcs5MIJH2+cbodoxbzWzjORDjy0jImnYox6QRjpL7P5gFAWj0fwFUPx
	 a+rtO/g4IWQkAX0dRw9GAhmxbTMNA5+zk3jH2XusinWzyQNicO2WL0uh0Fv4/t+T4K
	 Vgwk3N9vd+eww==
Message-ID: <6e7ffb3a-e876-48a9-8aa5-0889905de5ac@kernel.org>
Date: Wed, 25 Feb 2026 21:30:38 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: VM_BUG_ON_VMA in split_huge_pmd_locked: huge PMD doesn't cover
 full VMA range
To: Sasha Levin <sashal@kernel.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Andrew Morton <akpm@linux-foundation.org>, Hugh Dickins <hughd@google.com>,
 Zi Yan <ziy@nvidia.com>, Gavin Guo <gavinguo@igalia.com>
References: <aZ78kFBEA2SjgT93@laps>
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
In-Reply-To: <aZ78kFBEA2SjgT93@laps>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Stat-Signature: pzbzsf9ox7xk6wfxw9qyixyo1muqcdy5
X-Rspamd-Queue-Id: 87D79A0009
X-Rspam-User: 
X-HE-Tag: 1772051444-373057
X-HE-Meta: U2FsdGVkX18Qi5N8/odN7pWE0dQLukRpCbPmDGZEO/sZ7eCXu3rQOTVt6SZ2R+zBEgWTYmSoQylGsGGnZthOnGuQGiSrL0Bkjq5OAax7KN8A7xo59qrLa0+tkNuN4m5cT8lHJ/Xdc8Lg+SrNqFdV2sHMlNDiQTrke0jnSqU6sarY450XMM+H+QzOVp6DY2OFSzdOP4bWu2m288DJXjufmT6qLFZp6ljzqapWM+A7HTtHlX+59ij0SMmy82VWnCwRJl6Bzx7oxRL3ALZOpdrHBTFM6uTwouGNcPIYEqUftTvScfsN2AdSNc9gMgBNGq+3Xb7xD7QYFlyJV67OQ2X5rOuZRfoFo3KS7Q4GDCuRZsRDV8Z/bywY3QlFjmpkIjbl4xPZxFL18hYup1w8JPJfeSDZtMNFZdIQ2HIhWSykiEg7paquilHY+Oa5dyfzsZ3TS24ShFh55GWo5pnT2yNVdAdGgd4jtgvMmeyaAps0ZRJqHEmFMejAwJavjw1So/k+c3lPc+Z4GZji+OL6/NTn9OWftpwdasFOvWGk/T3Djh1fEuxe3DbAcRDaDXxQjRQ/lzuAIosxwsJy1yioVEz96DMITKS5X0nZffr1CnZOmY75J4sY+MI3fCxrWrzRaEcYVfzENpTTy9bAr5bxjMlvLYrwbKM5fuJ7S2E+7WwHnSbIIERYuq0hRnY5hGIySMHz2qNWesEdKrqPNVJ116gfw8NdjXcr7sKaP4uEDHb2fevTWDo99kpOx36Zj7Mvj64NVjK7p5OQXSA38r5Ta82MkPQZzsrieU9zOKI1tuPKzy3BaqTYaq1gQy204xnLvLt5ZLXC5W51J56sj8kAWZKKUgDnB0FZNPP7Ni9eri2rp/O1Dl2Dr16Ca3PbxhHYscvTeX13Ijz8HhqFP12INtEFmwbdvSNQzRvR0BRaCGNxsTVkl8Kbn20+mevM3ZTZfsHowAH4dmPBESpMIzpPvwN
 +e5dhnDS
 o1ozu4aOgrTlsPwnqYDNZ0Kd9B6fufV86eh5xYMu118Hu2zbikCD6s6kbbmnPCB50XcYy2cUliPXSi/7WgzGaIoNhcgJv2AEbGq+Jx71TDIrPml1xQOyLAFJwfO4BEEsVoGBXgznsWpNCpflpKKhaYE0/VMap1Wo9ObDmmyFz0MtrRwq/9tfPK4WND0Z+5jYAsXLcCRGYYRdfikfupAE0rDGiJKD9o3XNUgI9wlBWOsolB33IQToqKBP/F9KuWtTI6kPTJVWb4eewfNABHCpgI+rCsBFLhANlZi6l/9MFfAhrwO15JKumV/ISbQ3pw1hR+H4YBO+Zm7fynhU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> The suspected race window is:
> 
>   1. VMA [A, A+2MB) has a THP. Migration starts, PMD becomes a migration
>      entry.
> 
>   2. Concurrently, __split_vma() runs under mmap_write_lock. It calls
>      vma_adjust_trans_huge() which acquires the PMD lock, splits the PMD
>      migration entry into 512 PTE migration entries, and releases the PMD
>      lock. Then VMA boundaries are modified (e.g., vma->vm_start = A+X).

split_huge_pmd_locked() will call __split_huge_pmd_locked() either for
* pmd_trans_huge(): Present PMD
* pmd_is_valid_softleaf(): Migration PMDs (for our purpose)

__split_huge_pmd_locked() will remap either, resulting in a PTE table.


> 
>   3. remove_migration_ptes() runs via rmap_walk_anon() WITHOUT mmap_lock
>      (only the anon_vma lock). page_vma_mapped_walk() acquires the PMD
>      lock. If it wins the lock BEFORE step 2's split, it finds the PMD
>      migration entry still intact and returns with pvmw->pte == NULL.
If 2. runs after 3, 2. would simply split the (present) PMD.
If 2. runs before 3, 2. would simply split the migration PMD.

And both should sync on the PMD table lock.

exit() cannot run before 2. completed.


Wondering if it's instead some missed vma_adjust_trans_huge() case. I
see a call from commit_merge(), so maybe some odd corner cases with VMA
merging.

-- 
Cheers,

David

