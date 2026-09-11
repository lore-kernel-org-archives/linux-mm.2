Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D9513C88E58
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 16:55:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A10AE6B0092; Fri, 11 Sep 2026 12:55:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9C1F06B0093; Fri, 11 Sep 2026 12:55:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8AFEA6B0095; Fri, 11 Sep 2026 12:55:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4F4F96B0092
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 12:55:42 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 6AFD01C1C17
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 16:55:41 +0000 (UTC)
X-FDA: 85202082882.13.CDBCD16
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 8D3B81C0009
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 16:55:39 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=c0NoZhUu;
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789145739;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yE+7Pez0ot5mrGbBn0XwFu3bOI3y9SJeDDhq4Pq3Cgc=;
	b=D594RUza84htOALyl6TYnAkt5yxBkiP5USMSPns+UGdfXzOqQpeMxCWPI6KY6QqHCKXH7H
	AwYUAlXXIcgpjOFP5FOP8oIU7pSxTb0p6ke3Zel9LwUoryqOobGbm++yGVYR1AvcMGk3kx
	b9Oz1oYh3h/jwelahXaZLHojWAeFZVM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789145739;
	b=4vcyxvsmfmTkWNRLsLAuEYKinaN5QHwh/8guL2UflZI1p6ET4yCavAp1akNcs9YCYaRZRY
	HrdY0jjdrg1S0y0aESiyXHskG336ISCw9ReB+zY0Gzt8G+P/95KQ25YL9c8ZwfGmFr51ZP
	XGErR8qmCuTN6SqWgmcHNGSliB97Li8=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=c0NoZhUu;
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7B0824005A;
	Fri, 11 Sep 2026 16:55:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EEC91F00893;
	Fri, 11 Sep 2026 16:55:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789145738;
	bh=yE+7Pez0ot5mrGbBn0XwFu3bOI3y9SJeDDhq4Pq3Cgc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=c0NoZhUuLC8eojSn10Dl+/6UkGx8wGOb/eBDtEA0CIyk1hQ6mP9dgGNHHGBX3N7yA
	 X71r+aiXtzF4bhp3C1o/xG+WbKq9dsGWuGA3Hu4bxgxtDeR0HzLHnKDlSwnkTzN4I0
	 yNFvdrydYpmyeMrh9F90cWrJC226CBBW/A2ArZjcVPRInVrizb9o3/D2/gMDnyMPx1
	 YbCSjQU+p0HSOBH8E3Fyc1mpmYrLR8tCHSP8jSjf3gDgXExbXqvDifcxjWpIDa/PKf
	 vZyITqtq+KtGCpN47eXarSnhSRPzuOIVrud/pd7SbcUw4idHZQTzpTNbHJv4fgl0sg
	 qtZmvLKps6t8w==
Message-ID: <dd6ecac2-9bd2-4184-a034-9e13afa614bb@kernel.org>
Date: Fri, 11 Sep 2026 18:55:18 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/8] mm: distinguish PTE table storage from PTE values
To: Muhammad Usama Anjum <usama.anjum@arm.com>,
 Jani Nikula <jani.nikula@linux.intel.com>,
 Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
 Rodrigo Vivi <rodrigo.vivi@intel.com>, Tvrtko Ursulin
 <tursulin@ursulin.net>, David Airlie <airlied@gmail.com>,
 Simona Vetter <simona@ffwll.ch>, Dimitri Sivanich
 <dimitri.sivanich@hpe.com>, Arnd Bergmann <arnd@arndb.de>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 Helge Deller <deller@gmx.de>, Juergen Gross <jgross@suse.com>,
 Stefano Stabellini <sstabellini@kernel.org>,
 Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
 Andrew Morton <akpm@linux-foundation.org>,
 "Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Will Deacon <will@kernel.org>, "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>,
 Nick Piggin <npiggin@gmail.com>, Peter Zijlstra <peterz@infradead.org>,
 Andrey Ryabinin <ryabinin.a.a@gmail.com>,
 Pasha Tatashin <pasha.tatashin@soleen.com>, Chris Li <chrisl@kernel.org>,
 Kairui Song <kasong@tencent.com>, Uladzislau Rezki <urezki@gmail.com>,
 Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu
 <mhiramat@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
 Daniel Borkmann <daniel@iogearbox.net>, Andrii Nakryiko <andrii@kernel.org>,
 Eduard Zingerman <eddyz87@gmail.com>,
 Kumar Kartikeya Dwivedi <memxor@gmail.com>, Ingo Molnar <mingo@redhat.com>,
 Arnaldo Carvalho de Melo <acme@kernel.org>,
 Namhyung Kim <namhyung@kernel.org>, SJ Park <sj@kernel.org>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>,
 Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>,
 Miaohe Lin <linmiaohe@huawei.com>, Dennis Zhou <dennis@kernel.org>,
 Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@gentwo.org>,
 Mike Rapoport <rppt@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,
 ziy@nvidia.com, pfalcato@suse.de, agordeev@linux.ibm.com,
 ryan.roberts@arm.com
Cc: linux-kernel@vger.kernel.org, intel-gfx@lists.freedesktop.org,
 dri-devel@lists.freedesktop.org, linux-parisc@vger.kernel.org,
 xen-devel@lists.xenproject.org, linux-mm@kvack.org,
 linux-fsdevel@vger.kernel.org, linux-arch@vger.kernel.org,
 kasan-dev@googlegroups.com, linux-trace-kernel@vger.kernel.org,
 bpf@vger.kernel.org, linux-perf-users@vger.kernel.org, damon@lists.linux.dev
References: <20260903103002.1091859-1-usama.anjum@arm.com>
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
In-Reply-To: <20260903103002.1091859-1-usama.anjum@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: by64kfuki6k9ngxhyqeu96n3q19jzfen
X-Rspamd-Queue-Id: 8D3B81C0009
X-HE-Tag: 1789145739-180813
X-HE-Meta: U2FsdGVkX1+NKyJi2Vofdq39svCewKU6kfdIc1iQaAbIcAHCZXRu3V4+R/ctMg8IAQdFZlY24FqpZPbQqmTfZEjmLXsCDr6P7di5q7IJPXXf3esmSZIZnEfpfK7pByMhwOK01UkoUUeoxH890XM2jzKq7WyGlXF6QU0ACQapDWoS7GKlNjfiUQmOkK5/jGvP2zDxU1O5z3je6YJ5XgBlJyKyzYA9iePXIytS7rqBVUH8//LiwCsJFnOhraSObNYVmEipA6NE4cnrk9umyWgVKDAychk3aBa03RJrq35onMKfnEQ5A/dG9V/QCp06p8aftwldnSSb4p2iegVAv+6fleYx7qt9fQM9MHLkhvSjV5ev9ZGnF+ZAi98YZxQx1CAMrgq2g6r2P+H5M5UTTXZwGhbF0IDZBp5RIOiVI6LW1JVrwhgDTENUKFzCSy9whoeKMYNubRP8KGi9NW4+Yx1Wm2x3sriFTVDTKzNiGdLIGaebDqBJ44j0wrNovunUnn429mT0XlJ+2PJwFggtoBwzOFuPsluBzEQ3JXIdTJ+ZAkyQsTMMP8EMl1vHcRDKRkqwrf2H73ftPC0pDHMFhC5OWh1Jtnp1ayqHrCrbQh8dzzq3yxgsMklBZAasmC39AN+Sf7y24Px6W+H7tPAJhbcz0VYvjjdxzhYo6ovO40eXoxNVHo6yusVAsx6cIl1Ed2rhgXcy6l7VnP4q3303aKhsoFQSGj7V9zYGohp1Kbp3/zmiY9TwCLs6uPJDiQKa1yyigqEGwQmU4SxzB7dBoS4q7d9Cj8b/Hu1sOHj98ca46fW0oICIeivgNY2j3ASsLXIhqaCFsAF1b04SLoC3mW1Ukx5XXPgsidm0hMJ6q314xvbIpcejNhybQzAkMg0gnMuyPCWdriPEwYEDfNpN2nyBlsbU74JqWvfGqE8Zg5apjoGF+DcMbVHq2+6/HtOo3gYU3xdRzIJWozxpbtXXBpB
 Ii7FdpbT
 rpepivq3xNwyxZQ1moQz20vkK2mtUqSvLQ0Zjp4EMzOlCPKB+hptfsMEfQi9Z6toiE7gOou8VA78leLPZGfDqTGA6NZIo64qw4lYjd2HWwjTDc1DyqMg/3/NlwOEFQIYmb1Fmalb+uwX8Ie2i1Iw8Vs+N8Bku/nMZ5m19hI2UIyYK481bh9qUGK+fsUFFIX6ghZnGwmiDAWxb7AM7rp5GIjaNfQUOoWkAXXPb+WOtqzNxZWvbKObtKSDJCVTBOYQkmam0eHDsTE6NR0+dLYtJAFeE88NViQlvrdW3AtUeFqwlshtA0xT8IMEnVwCpCVc3y92HjBm0T0WciVusvW5U87KhDQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/3/26 12:29, Muhammad Usama Anjum wrote:
> Hi,
> 
> pte_t currently describes both a software PTE value and an element stored
> in a PTE table. Consequently, pte_t * can point either to a software PTE
> value, often a stack copy, or to a PTE-table slot. The compiler cannot
> distinguish these cases. A value pointer can therefore be passed to an
> interface that expects table storage, while table storage can be read by
> direct dereference instead of the architecture accessor.
> 
> This series begins a staged conversion at the PTE level. It introduces
> hw_pte_t as the element type for PTE-table storage and converts generic
> MM to use hw_pte_t *. Software PTE values remain pte_t. Interfaces that
> intentionally return a value through pte_t *, such as install_pte,
> remain value interfaces; the relevant parameters are named ptentp to
> make that distinction explicit.
> 
> The generic definition aliases hw_pte_t to pte_t unless an architecture
> selects ARCH_HAS_HW_PTE_T, which enables a distinct generic wrapper named
> __hw_pte_t. Some architectures define pgtable_t in headers parsed before
> the generic hw_pte_t typedef is visible. The structure tag allows those
> headers to define pgtable_t as struct __hw_pte_t * without creating an
> include-order dependency. This is required when converting s390, m68k,
> powerpc and sparc.
> 
> No architecture selects ARCH_HAS_HW_PTE_T in this series, so the
> representation and behavior of every architecture are preserved. ptep_get()
> keeps its existing READ_ONCE() semantics and converts the stored element
> through __pte_from_hw(). An architecture can later select the option and
> convert its PTE interfaces to make the distinction compiler-enforced.
> Architecture PTE implementations and most architecture code are
> deliberately left for those later opt-in conversions.
> 
> Here, hw_pte_t identifies PTE-table storage rather than table lifetime:
> complete PTE tables use hw_pte_t whether or not they are currently
> linked into a page-table hierarchy, while software PTE values use
> pte_t. The distinction between complete but unlinked tables and
> hardware-reachable tables was raised during discussion and remains an
> important point for review.
> 
> PMD, PUD, P4D and PGD storage are deliberately out of scope. They can be
> converted in later series after the PTE boundary is agreed, avoiding the
> PMD-specific cases that made an all-level conversion difficult to
> review.
> 
> Most mechanical pointer conversions were generated with the Coccinelle
> script included below, then audited and fixed by hand.
> 
> This series does not add a second ptep_get_once() accessor and does not
> remove or replace STRICT_MM_TYPECHECKS.
> 
> The design discussion is available at [1]; while the original idea came
> from [2].
> 
> I've the patches here [3] for arm64 conversion which I used to find
> usages in generic code which I missed during development. These would be
> sent separately.

Unless there is more feedback on the overall approach, the next step for this is
to have at least one architecture support posted.

We should only merge this if at least one architecture (better two? :) arm64 and
s390x? ) would merge the architecture bits.

That is, we should get an ACK from the arch maintainer son the common code bits
and the arch bits.

-- 
Cheers,

David

