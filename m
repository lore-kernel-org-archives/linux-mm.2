Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 78D1BCD98CE
	for <linux-mm@archiver.kernel.org>; Fri, 12 Jun 2026 16:34:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E011B6B00A0; Fri, 12 Jun 2026 12:34:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DD8626B00A4; Fri, 12 Jun 2026 12:34:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CEE876B00A5; Fri, 12 Jun 2026 12:34:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BCE1B6B00A0
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 12:34:40 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 856B31C20A5
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 16:34:40 +0000 (UTC)
X-FDA: 84871809120.29.E1E36DA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id BCE628000B
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 16:34:38 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=X0BSL3Jw;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781282078;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1wbHPz0yxgcW40+a1ZKP5R79LZD98PocQmiUS2qLLXg=;
	b=D2/rwCrWGw003RNbQYxsDe64U8F0H+J0QSCH8NPRy9wCn+tuhCrtkukyvZwI2rUOKZGCnx
	lGjOqf6FhHRj9/GGTHWI6aFl59mo0Ah4yQBQQLRtxl1YyNLJ/Ebk7QWf8s1wthq2fCzjcq
	L61jXge8/YmTAHBTL97qcdJqaaXsSvI=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=X0BSL3Jw;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781282078;
	b=DxXMNZ9UXyilo84LtIU1avjwwmuc+aDyeOXxEH4YN0zCZnsRCL5e9owNwuCQFK6HQLjQiX
	/G98r4Cd2tP5V3CspUT/ejXmVBb6fnKbiiwSA69tkRedm47oaLRSjc0RnM3w2Z9r39wzJE
	30E5o4NX7w0T7Lbrf1kcUU3vcCWGxxo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 2A70360008;
	Fri, 12 Jun 2026 16:34:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A2C21F000E9;
	Fri, 12 Jun 2026 16:34:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781282077;
	bh=1wbHPz0yxgcW40+a1ZKP5R79LZD98PocQmiUS2qLLXg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=X0BSL3Jw4NyO5T64SyKIKJN6qaDKKrGABYC9lBRSrb4ql6rGXuEEu5FpyIoXOCRO2
	 lQmVpE90PSnAMt1vtmovv/6B/MVGhh+Jo4/CzZnhjDKwO7pqCSOOSO1nuw+EtetEh1
	 FKT6hTA7qJ2S/ch6+TxMojcDEzzs27nCetOokLOiYjZFCc3y+42HTW8+hRHZH6jYNi
	 PAaY1ppDQqFNvqhbsFCSV1nC3iM2PsVfh9LwiaRlgrBZw6JT9NZbRefIbzE1y/o/fw
	 tKmYJ+O4uqVmNyf7SKNnNmBB0qDgn+S/YofrOZFMx+2YzaGqbuM4AgdJ30QiSYJE+o
	 E1lik8hhJm7ig==
Message-ID: <76d8bbab-ee8f-4f58-b008-ebc9b6da7ef6@kernel.org>
Date: Fri, 12 Jun 2026 18:34:31 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCHv2] mm/huge_memory: do not add dropped split tail folios to
 LRU
To: "zhaoyang.huang" <zhaoyang.huang@unisoc.com>,
 Andrew Morton <akpm@linux-foundation.org>, Zi Yan <ziy@nvidia.com>,
 Lorenzo Stoakes <ljs@kernel.org>, Barry Song <baohua@kernel.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Lance Yang <lance.yang@linux.dev>, "Liam R . Howlett" <liam@infradead.org>,
 Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Jaegeuk Kim <jaegeuk@kernel.org>,
 Chao Yu <chao@kernel.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Zhaoyang Huang <huangzhaoyang@gmail.com>, steve.kang@unisoc.com
Cc: xiuhong.wang@unisoc.com
References: <20260612023456.2424044-1-zhaoyang.huang@unisoc.com>
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
In-Reply-To: <20260612023456.2424044-1-zhaoyang.huang@unisoc.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: BCE628000B
X-Stat-Signature: 958rtfapznfq3krx9srjxgf93xrg63qz
X-Rspam-User: 
X-HE-Tag: 1781282078-115961
X-HE-Meta: U2FsdGVkX1+JcpD4Y0oE2s4FKhO3DA6aWB8eC28kHLjv9mfNlgO09taq+0FC0m0lP65Mu+Ly/XbJbs9TiOZ3UbbZI4OL7issG3JlKre71TDvrCrWt21I6r6w7AltKdZyDD5li3eyREJl4ukm2NYgnLI7l29V6ioC2468H8IXQF1siNdXuJW2OKp3xbdfZ5ZHdElA7rt9NwbdgJVfmCTBZlnDLQAVFYTgJWyMCqF+MXKN+dzI95hh0EVHXnS7HZYHshTyPvShAhR9V9jCr3JXTvYBGsXvGd2g+jVQzpQXPOnQ+rMwRhHk2y3cjrtGO4uiOfdWrXwKilRaZh1Vvsu79OkkWpfnVTcwKBWQ8CdxYJ+2FOmgE11jFcXdDGXt6DG62wFKYtfnB3+NT9jbnnkxfz3vlTIz0vbo5lk+4LMwi1o+xpSvAkqERKTSeWKe5qAt3ONj+99tdg488D7fBSciT024dFVWWoBNhdawrcGFkdl87drX8fkpCtWQArW3kvF0TgHR7vPL2a20W94xXexM/NbDWEeI2J++kclzYxoyrBhJsfmg3Wkk4YVfwppMQsi7hWeAUOrdeeWkc9EsVGn2jBLltaxZmjacc/92aIVUJN4KebuxgLiU3LlbhorOGWDFBAXYFbnE6K1ikZ6/z1Gw+DGqKR496Ed1qsu9D2pzGS6njqrx2ghYQxm/uxR4afsr5Nc+w2iAONLayze/HH7PGaoLehCF16rlFCu9hqbWJV3FfUey9f+z4BpCz29omWKlwi3UHGBB4MChFMgXjAMnFzNkrcMzPHHBuJ5KDw5WyNCJ/IrwHU5//D9zYtqspOEMKWDjHniYue5aJknCtihaGoi2aFjG+0z0Z2N6pACLv3mqdiMzXiW1zmnjSXQb3kEIV+2h9PgtZDGIvSpvq+lXJND/2UCt6h1zWzQm1LJ6t/Nn/gtMt5H5+rz11ETakrXjZ959CEsv+JmPZhz3FmZ
 c7cMq9S/
 RB6CYmlhzbe8e5ZDAqQlFHmVTc1Dvu05a6Gshi8o2hK6bZiM6VsCXrtWrkIHtvWGUc6G6JHTR3Z4GAtDT6lPu86+jrIRGBW9qEMndoqVIGDz/mjegmJGD7+R7daOx6EV7WJjZDQClCCtV5oakWIOobLgAMa5bqFXsX/2FIv+rtL0eRZnZLbTGARf+HHKXpT4YVsLaZ7DrCCAsm9IHESwQ8uPwrO5gaHtohbPjFwn/FqXcZwN5orPc4cK7EP+g4bPBgoWDhJIA3To1y2gPe2BtDMby9k3Hrn5XlRQkhwYKlLGq81rBXV/7+Jq8y8N70PtEIsHiV0mkCukqUad51y3fr53UlFSaM6X7RrBtcQDRO/10f5c=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/12/26 04:34, zhaoyang.huang wrote:
> From: Zhaoyang Huang <zhaoyang.huang@unisoc.com>
> 
> The kernel panics are keeping to be reported especially when the f2fs
> partition get almost full. By investigation, we find that the reason is
> one f2fs page got freed to buddy without being deleted from LRU and the
> root cause is the race happened in [2] which is enrolled by this commit.
> We solve this issue by reverting a f2fs commit 9609dd704725 ("f2fs: remove
> non-uptodate folio from the page cache in move_data_block").
> 
> There are 3 race processes in this scenario, please find below for their
> main activities. However, by further investigation over the code, I
> think there is a common race window for the truncated folios between
> split_folio_to_order and folio_isolate_lru, where the folios lost the
> refcount on page cache and remains the transient one of the split
> caller, under which the folio could enter free path and compete with the
> isolation process. This commit would like to suggest to have the folios
> beyond EOF stay out of LRU.
> 
> Split:
> split_folio_to_order() can split the big folio into individual pages and
> put the resulting subpages back on the LRU.  For tail pages beyond EOF,
> split removes them from the page cache and drops their page-cache
> references.  A tail page can then remain on the LRU with PG_lru set while
> holding only the split caller's temporary reference.  When
> free_folio_and_swap_cache() drops that final reference, the page enters
> the final folio_put() release path.
> 
> Truncate:
> The changed code in move_data_block() lets the GC path evict the tail-end
> folio from the page cache through folio_end_dropbehind().  Once
> folio_unmap_invalidate() removes the folio from mapping->i_pages, the
> page-cache references for all pages in the folio are dropped.  The folio
> is then kept alive only by temporary external references, which allows a
> later split to operate on a folio whose subpages are no longer protected
> by page-cache references.
> 
> Isolate:
> In parallel, folio_isolate_lru() can observe the same tail page with a
> non-zero refcount and PG_lru set.  It clears PG_lru before taking its own
> reference.  If this races with the final folio_put() from the split path,
> __folio_put() sees PG_lru already cleared and skips lruvec_del_folio().
> The page is then freed back to the allocator while its lru links are
> still present in the LRU list.  A later LRU operation on a neighboring
> page detects the stale link and reports list corruption.
> 
> [1]
> [   22.486082] list_del corruption. next->prev should be fffffffec10e0ac8, but was dead000000000122. (next=fffffffec10e0a88)
> [   22.486130] ------------[ cut here ]------------
> [   22.486134] kernel BUG at lib/list_debug.c:67!
> [   22.486141] Internal error: Oops - BUG: 00000000f2000800 [#1]  SMP
> [   22.488502] Tainted: [W]=WARN, [O]=OOT_MODULE
> [   22.488506] Hardware name: Spreadtrum UMS9230 1H10 SoC (DT)
> [   22.488511] pstate: 604000c5 (nZCv daIF +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
> [   22.488517] pc : __list_del_entry_valid_or_report+0x14c/0x154
> [   22.488531] lr : __list_del_entry_valid_or_report+0x14c/0x154
> [   22.488539] sp : ffffffc08006b830
> [   22.488542] x29: ffffffc08006b868 x28: 0000000000003020 x27: 0000000000000000
> [   22.488553] x26: 0000000000000000 x25: 0000000000000004 x24: fffffffec10e0ac0
> [   22.488564] x23: 00000000000000e8 x22: 0000000000000024 x21: dead000000000122
> [   22.488574] x20: fffffffec10e0a88 x19: fffffffec10e0ac8 x18: ffffffc080061060
> [   22.488585] x17: 20747562202c3863 x16: 6130653031636566 x15: 0000000000000058
> [   22.488595] x14: 0000000000000004 x13: ffffff80f91e0000 x12: 0000000000000003
> [   22.488605] x11: 0000000000000003 x10: 0000000000000001 x9 : ffe85721f0e25f00
> [   22.488615] x8 : ffe85721f0e25f00 x7 : 0000000000000000 x6 : 6c65645f7473696c
> [   22.488625] x5 : ffffffed39b23026 x4 : 0000000000000000 x3 : 0000000000000010
> [   22.488636] x2 : 0000000000000000 x1 : 0000000000000000 x0 : 000000000000006d
> [   22.488647] Call trace:
> [   22.488651]  __list_del_entry_valid_or_report+0x14c/0x154 (P)
> [   22.488661]  __folio_put+0x2bc/0x434
> [   22.488670]  folio_put+0x28/0x58
> [   22.488678]  do_garbage_collect+0x1a34/0x2584
> [   22.488689]  f2fs_gc+0x230/0x9b4
> [   22.488697]  f2fs_fallocate+0xb90/0xdf4
> [   22.488706]  vfs_fallocate+0x1b4/0x2bc
> [   22.488716]  __arm64_sys_fallocate+0x44/0x78
> [   22.488725]  invoke_syscall+0x58/0xe4
> [   22.488732]  do_el0_svc+0x48/0xdc
> [   22.488739]  el0_svc+0x3c/0x98
> [   22.488747]  el0t_64_sync_handler+0x20/0x130
> [   22.488754]  el0t_64_sync+0x1c4/0x1c8
> 
> [2]
> *F: big folio before split
> *T: tail folio after split
> CPU0 (f2fs GC)              CPU1 (split_folio_to_order)          CPU2 (folio_isolate_lru)
> *F: pagecache refs = n
> *F: extra refs = split
> *F: PG_lru set, mapping != NULL
>                             split_folio_to_order(F)
>                               folio_ref_freeze(F, 1)
>                               ...
>                               lru_add_split_folio(T)
>                                 list_add_tail(&T->lru, &F->lru)
>                                 folio_set_lru(T)
>                                 folio_unlock(T)
>                               /* T PageLRU set */
> 
> *T: pagecache refs = 1
> *T: extra refs = GC + split
> *T: PG_lru set, mapping != NULL
> 
> move_data_block()
> folio = f2fs_grab_cache_folio(T)
> ...
> __folio_set_dropbehind(T)
> folio_unlock(T)
> folio_end_dropbehind(T)
>   folio_unmap_invalidate(T)
>     __filemap_remove_folio(T)
>     folio_put_refs(T, 1)
> folio_put(T)
> 
> *T: pagecache refs = 0
> *T: extra refs = split
> *T: PG_lru set, mapping == NULL
>                             free_folio_and_swap_cache(T)
>                               folio_put_testzero(T)
>                                 /* refcount: 1 -> 0 */
> 
> *T: pagecache refs = 0
> *T: extra refs = isolate
> *T: PG_lru set, mapping == NULL
>                                                                   folio_isolate_lru(T)
>                                                                     folio_test_clear_lru(T)
>                                 __folio_put(T)
>                                   __page_cache_release(T)
>                                     folio_test_lru(T) == false
>                                     /* skip lruvec_del_folio(T) */
>                                   free_frozen_pages(T)
>                                                                   folio_get(T)
>                                                                   lruvec_del_folio(T)

What I am still struggling with:

folio_isolate_lru() is documented to:

"Must be called with an elevated refcount on the folio.".

That is, there must be *something* keeping the folio alive before the
folio_get(). It could be a page table mapping with the PTL held (which does not
apply here).

Or it could be another prior folio_try_get() (e.g., do_migrate_range()).

But essentially, folio_isolate_lru() cannot race with __folio_put(). It would be
fundamentally broken.

-- 
Cheers,

David

