Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 95290606A31C
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 08:54:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ltl8ImxL
Received: by kanga.kvack.org (Postfix)
	id A84076B05B1; Thu, 12 Nov 2026 03:54:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A34EA6B05B5; Thu, 12 Nov 2026 03:54:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 924776B05B7; Thu, 12 Nov 2026 03:54:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 661DF6B05B1
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 03:54:13 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id F35DA140281
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 08:54:12 +0000 (UTC)
X-FDA: 85425855144.07.B79BF41
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id 1FE8D40006
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 08:54:10 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ltl8ImxL;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794473651;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ePkuZsGQpV9jd5TnZXMBz49Rl2IFx60CuIIApPV/Lyo=;
	b=P1xX8cHLPB+5zHCbSy8FL2KtJmMYJvkmS52MyqqGiMIq1Dp+iAyzr9VfigSGLIO/jHV9jS
	WgqgWhsUBvca4d4RPqTxA9BDzG6Kzu2JEp23Ennhx7Cz4DXAxWtQE+IkEnqu5OicnLISTq
	qRUyX3MlVPIHCb/20LJnJC6HKX6vsAo=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ltl8ImxL;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794473651;
	b=vLgihFKcDN07ycOYjBEBCWYx0tH0ixhoDhspFJ7+s+pD9deF4u6YEFBG460dli4x/Un6LL
	7Vj3dZRU1BwB17e9hkg5ifDzWammbrSNeQXEbpqmmUIWtAsBCHIikHVFPtrKCUwT/3fkpZ
	0Yw+qTlP5OMw43S5ZDrTzQmpTjPvYD8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A2C94611F9;
	Thu, 12 Nov 2026 08:54:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 960071F00A07;
	Thu, 12 Nov 2026 08:54:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794473650;
	bh=ePkuZsGQpV9jd5TnZXMBz49Rl2IFx60CuIIApPV/Lyo=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=ltl8ImxLoafNcK4EpGTLoPNj5qUQQrLzABRGpWQsvGY1mDdlI6VDdtd1H+ts2pVCP
	 UNaUiMIS/ZiSZgav9R3+NQ1QnEtCSbRGPylnH7/84HLfeIRwjHIFRibRbkph5z7FuR
	 7nHX/Ao5Rs/JC/8dPC/017P7gQXwZynLSf4GRDiI2bAe6oL1Zq8t0B2mPfTMDBP2M7
	 gH//ZjoWG10PI/DHwgsfFRMxTon52cjOWoiBXQdqw9hNFA1pWXkrjzv9VatUuAq+Xg
	 3nEhT64qFWQwD2QU2V5srpExAnV6DtqecgNhn9pIH/DIfY8s/uIrpk9pkJzL18YYwC
	 RJoqAbZOaCdWA==
Message-ID: <ceb2ef49-69e8-425c-9582-ba6fb872e0cf@kernel.org>
Date: Thu, 12 Nov 2026 09:49:11 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 2/3] mm: gup: allow long-term pins of CMA-allocated
 HugeTLB folios
To: Qi Zheng <qi.zheng@linux.dev>, Muchun Song <muchun.song@linux.dev>
Cc: osalvador@suse.de, akpm@linux-foundation.org, azpijr@gmail.com,
 Lance Yang <lance.yang@linux.dev>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, stable@vger.kernel.org,
 Qi Zheng <zhengqi.arch@bytedance.com>
References: <cover.1794379433.git.zhengqi.arch@bytedance.com>
 <503c9f6d869e3206c6fd591de962c3d619b73825.1794379433.git.zhengqi.arch@bytedance.com>
 <80FED512-77D2-4D49-BAE5-745CE1F711CA@linux.dev>
 <1116fd15-a927-4f6e-a0ab-084bc36a90aa@linux.dev>
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
In-Reply-To: <1116fd15-a927-4f6e-a0ab-084bc36a90aa@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 1FE8D40006
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Stat-Signature: 9fwt3sgy1g3ht9uoqg8inuo51oiz1u1a
X-HE-Tag: 1794473650-939568
X-HE-Meta: U2FsdGVkX1/LwUTpukVz0iQ50IziYytFIt1Bogy/aHGKDgeMkMAtKUor+7xXlWZ+FhPHUwCdMPRd/oahDRJBoajIuycUO8rBgG/eNtJQ4ruGX+R5U0x5NxiFrCnZs7c1AE2N0hilzTVY2TuHSSTnVbJ0EZrcVSMv+DSK1ZwOLEwy6psfU5e49rOZFXY+0l+8l/BV5nrRnNxIiQX7dDfjLI7p7j/dnfVlZkzZvYA50X7JNQLdN8hR3exwOb038tsfeLNNCd9a0l0RK5g+y2YOQzPquDLopnUJZWMG7Z6jUk1sitUK3PlF3LF950htFEEqPdG228qIWJ/dlV4l9dW+2yI/XJq7WmjAr5RT26Ce1f2icl92//vzEqAtgb3l5hmzSG+AsgxqWVfqbhQxPFjG2G6VreyWLUMhsacih72z1EkCWVsGiFvsB5IjCRqRsCz+9ktsqbgTlD3915ITb8CGI9YxhJBDsFC2/7s9io9Ep1ORQuY51wu7twCmjpsaZwt06brjrS9kEsHBocdBB2vsaZOu2kG3jIGmiuWyruPwjWziOQt2FuWzKpa5HQSQx7Zuy/QmUIlhULOnqzqxwe7HiJk06OkmcIuEBxfq7BCEeb7lKQUH1o5YWDxHvZ+fasdLYFQh5fEf8xxQpcYKSqKe+Kg+fXuBUYcIrh2JhwNZP11dTpZHEObRqdTpjkZZiUo7l1ywk7efJ7EQucyDvrxSRR/NEyGJawrtWin69OX5dAZgszGOF8xgMCfZ67/mNi5glniCd6cLWfp/DFpxnbj5Y3mKG7RaACwolJMG2kwq4bVpBILY1NcanncLG6rKakW1qbWbMO+TSyd4kYmhmv5xNn4GCisz4BIfikdRoZxAG5pEZ6IugUvw842nxuBrexMREO/wRaRcsfaaYN3y8tINEsFLK73VpGRJXFx7TvvUYWvkQh7HEdSLwQSnHMD3t+sB/4PpyZNwNAAZmWRAm3G
 GDgSoJhb
 cOGOmvcZRIZU7qhwNbCuqejlH6wj+x6DDelSU+uH1/pfFWZgQZpF+Ngv+lSGH6ywZ98tBElKomREE1NplKsSJvtSQCfqqVDIKRfcLcMkJcwsXFQAABeHGkrPQshBHX5d0h5+A1ZqI/auzb7DYsWSQEObaZnMHWWXRS/83tbEBYPH9/6jBjwXiV4Ud9+mdblKyLB1imkC9N/kRd7QKh8BA4/Tp+bJaNafL8HxPJ2verUW1UixVMp/ADmocyqqSDlMHaOZSWv8hVaFii8bBfql8sN8Nb4i3Al50LHqbtZXRWw3wZ/GPAvsFVP0MXwWNwktUpiAwZKuPrMdZTK7TGnoJ6o92JwSgn2yb/esZ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/12/26 07:13, Qi Zheng wrote:
> 
> 
> On 11/11/26 3:42 PM, Muchun Song wrote:
>>
>>
>>>
>>> From: Qi Zheng <zhengqi.arch@bytedance.com>
>>>
>>> Long-term pinning treats explicitly CMA-allocated HugeTLB folios as
>>> unpinnable, causing unnecessary migration or pinning failures.
>>>
>>> These folios already own their CMA bitmap ranges, and memory blocks
>>
>> Commit message needs updating to bitmap as well.
> 
> Will do.
> 
>>
>>> overlapping CMA areas cannot be offlined. Allow HugeTLB folios with
>>> HPG_cma to be pinned directly, including in ZONE_MOVABLE.
>>>
>>> Fixes: cf11e85fc08c ("mm: hugetlb: optionally allocate gigantic hugepages
>>> using cma")
>>> Cc: stable@vger.kernel.org
>>> Suggested-by: Muchun Song <muchun.song@linux.dev>
>>> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
>>> Acked-by: Muchun Song <muchun.song@linux.dev>
>>> Reviewed-by: Oscar Salvador <osalvador@suse.de>
>>> Reviewed-by: Jose A. Perez de Azpillaga <azpijr@gmail.com>
>>> ---
>>> include/linux/mm.h | 29 +----------------------------
>>> mm/gup.c           | 31 +++++++++++++++++++++++++++++++
>>> 2 files changed, 32 insertions(+), 28 deletions(-)
>>>
>>> diff --git a/include/linux/mm.h b/include/linux/mm.h
>>> index b0da9be413098..47d1d96bfc7fd 100644
>>> --- a/include/linux/mm.h
>>> +++ b/include/linux/mm.h
>>> @@ -2954,35 +2954,8 @@ static inline bool is_zero_folio(const struct folio
>>> *folio)
>>>     return is_zero_page(&folio->page);
>>> }
>>>
>>> -/* MIGRATE_CMA and ZONE_MOVABLE do not allow pin folios */
>>> #ifdef CONFIG_MIGRATION
>>> -static inline bool folio_is_longterm_pinnable(struct folio *folio)
>>
>> I think David prefer to move this function first, then fix it in a separate
>> patch,
>> right?
> 
> Hi David, is this what you mean? If so, I will split it into two patches
> for the v5.

Let's try something that is more future-directed: cma should deal with
cma details. In the future we might implement something reasonable there.

diff --git a/include/linux/cma.h b/include/linux/cma.h
index 8555d38a97b1a..d829fd0355bae 100644
--- a/include/linux/cma.h
+++ b/include/linux/cma.h
@@ -21,6 +21,9 @@
 #define CMA_MIN_ALIGNMENT_BYTES (PAGE_SIZE * CMA_MIN_ALIGNMENT_PAGES)
 
 struct cma;
+struct folio;
+
+bool cma_folio_is_longterm_pinnable(struct folio *folio);
 
 extern unsigned long totalcma_pages;
 extern phys_addr_t cma_get_base(const struct cma *cma);
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 6af3b7008f1ad..5392e225cab9b 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -3,6 +3,7 @@
 #define _LINUX_MM_H
 
 #include <linux/args.h>
+#include <linux/cma.h>
 #include <linux/errno.h>
 #include <linux/mmdebug.h>
 #include <linux/gfp.h>
@@ -2975,7 +2976,10 @@ static inline bool is_zero_folio(const struct folio *folio)
 	return is_zero_page(&folio->page);
 }
 
-/* MIGRATE_CMA and ZONE_MOVABLE do not allow pin folios */
+/*
+ * MIGRATE_CMA and ZONE_MOVABLE folios cannot normally be long-term pinned.
+ * CMA may allow pinning folios explicitly allocated from its areas.
+ */
 #ifdef CONFIG_MIGRATION
 static inline bool folio_is_longterm_pinnable(struct folio *folio)
 {
@@ -2983,7 +2987,7 @@ static inline bool folio_is_longterm_pinnable(struct folio *folio)
 	int mt = folio_migratetype(folio);
 
 	if (mt == MIGRATE_CMA || mt == MIGRATE_ISOLATE)
-		return false;
+		return cma_folio_is_longterm_pinnable(folio);
 #endif
 	/* The zero page can be "pinned" but gets special handling. */
 	if (is_zero_folio(folio))
diff --git a/mm/cma.c b/mm/cma.c
index 9ec1d1fd5dff5..b3bf0014a90f5 100644
--- a/mm/cma.c
+++ b/mm/cma.c
@@ -27,6 +27,7 @@
 #include <linux/log2.h>
 #include <linux/cma.h>
 #include <linux/highmem.h>
+#include <linux/hugetlb.h>
 #include <linux/io.h>
 #include <linux/kmemleak.h>
 #include <trace/events/cma.h>
@@ -38,6 +39,16 @@
 struct cma cma_areas[MAX_CMA_AREAS];
 unsigned int cma_area_count;
 
+bool cma_folio_is_longterm_pinnable(struct folio *folio)
+{
+	/*
+	 * Explicitly allocated CMA folios own their bitmap ranges and can be
+	 * pinned even in ZONE_MOVABLE, as CMA memory cannot be offlined.
+	 * For now, only HugeTLB tracks these allocations with a folio flag.
+	 */
+	return folio_test_hugetlb(folio) && folio_test_hugetlb_cma(folio);
+}
+
 phys_addr_t cma_get_base(const struct cma *cma)
 {
 	WARN_ON_ONCE(cma->nranges != 1);
-- 
2.43.0



In a follow-up cleanup folio_is_longterm_pinnable() can be moved to gup.c.

-- 
Cheers,

David

