Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 461A4C5CFDB
	for <linux-mm@archiver.kernel.org>; Thu, 13 Aug 2026 09:01:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 527006B0200; Thu, 13 Aug 2026 05:01:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4D7D56B0428; Thu, 13 Aug 2026 05:01:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3C6DD6B0429; Thu, 13 Aug 2026 05:01:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1869A6B0200
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 05:01:11 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id AEBFD80516
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 09:01:10 +0000 (UTC)
X-FDA: 85095651900.13.E93CBFC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id C9E58180017
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 09:01:08 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iAkJaMtM;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786611669;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Y9O+191m0uBz3Oh/7L7UAfh/wJKAqqGNUbdnCQ8c2N0=;
	b=bhRxOst9qRy1HcpNIw9uy0s1MwOtReGPTLxQ7a1P7qGcIYVu6TBjb74o3/1cTAaHvQEs0o
	mIFkkk7BxKidpbRgGH3E3ISuU+M8qJCSbU/+U3rhT53of7FMBysJNxwiX4qgVQUkdn1a0A
	9jlbo6UfzH0NK5NcX0P5jCakVcFKzok=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iAkJaMtM;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786611669;
	b=u1qxBIgtGrMvqtfcusWHk+faMVm3Z4p/Kf+4TRXqIYiVHq5tW/ReuRkaNe+Tf84DEfV/Ly
	4lsRIyI48N8LCEdaQxJtx+AOpHi/q0y6iV/DzDBai0oGty5gbdRTGdM4I+/7eW8T/ZHEwB
	8bf16rMaM+Nga0o/F3ikqmS3qC9zu/A=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0AD7940878;
	Thu, 13 Aug 2026 09:01:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA2D41F00A3A;
	Thu, 13 Aug 2026 09:01:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786611667;
	bh=Y9O+191m0uBz3Oh/7L7UAfh/wJKAqqGNUbdnCQ8c2N0=;
	h=Date:Subject:From:To:Cc:References:In-Reply-To;
	b=iAkJaMtMOdiOmhfeJui4hvi0zurvyPRCg1hxCp/mj5yKnXOowW3KbXg1EIIs6Rfo5
	 /cyddz345GqfbiEoa+YwJrtUJijtEL+C25/oxoDXovtLm7gddr7lfFShGDqolpxFiZ
	 lUUrctDej5iVevEUL7f+NrKeRvAPduUTvZA7tp7GGRF9tL/Dpwy6HV0DOwb4PULNuR
	 P+UbouheLbm6EeXb0bxLy+aJaQ4tcDyz9qUMoJj4HIvLVpdOE8tr7mXImZBeFGIdVN
	 eZ4IEq/7pulooMyUhs7DcvYt/perkmR3S/fif3r3GfRLcTkYO33H9QXmW8Y+4awuXr
	 2bOVXfjf4f/Uw==
Message-ID: <e68018a5-a8d0-4ca6-b3f7-7a151d17be31@kernel.org>
Date: Thu, 13 Aug 2026 11:01:02 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 06/15] kpageflags: Use is_page_hwpoison() to set
 KPF_HWPOISON
From: "David Hildenbrand (Arm)" <david@kernel.org>
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Andrew Morton <akpm@linux-foundation.org>, Jane Chu <jane.chu@oracle.com>,
 linux-mm@kvack.org
Cc: Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
 Miaohe Lin <linmiaohe@huawei.com>, Naoya Horiguchi
 <nao.horiguchi@gmail.com>, Jan Kara <jack@suse.cz>,
 linux-fsdevel@vger.kernel.org, Christian Brauner <christian@brauner.io>,
 Jiaqi Yan <jiaqiyan@google.com>, "Gregory Price (Meta)" <gourry@gourry.net>
References: <20260805210557.1118966-1-willy@infradead.org>
 <20260805210557.1118966-7-willy@infradead.org>
 <3e609c64-a393-4667-be74-6cb2bbdcb717@kernel.org>
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
In-Reply-To: <3e609c64-a393-4667-be74-6cb2bbdcb717@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: C9E58180017
X-Rspamd-Server: rspam07
X-Stat-Signature: 1sg6m7mxzxm44ht8s14p6dhqae39ipxe
X-HE-Tag: 1786611668-715320
X-HE-Meta: U2FsdGVkX1+JbwSd+VtsTlZzOu4yolCt3rPKbsEV6/a5/3bwjNUnMO8a6AMdfv94ao4Z2K3RPyJPIvO/ol2PvyuS3DSPg4tIp0Eqfi+khItLhxY+syWkFIqII07OYldofJ1nAKx+0QCAGdjJV2PBJmJYnUIXfxzVKIGa0jsoQ0KCMXWq2RTp+SYNZCtaJmR9qkyvNbJ9o//TLHSkpjxn0iOH+CIlMdYi75ohnt1WULa1c/wSYiM9KKPwB+/2R2faBMZYJJQsY9b5HOA+7KcHQpuxvXob8WeVNs5wQGUYy56VLOCpf2OqwJ2+k6NWUpcrgrCJ9PXcuoOpbE7eb7kYOMptRIZizBddtiKtAtc+J8Dw5gsqI/XUzI6UJId2Lm6uB98PrW6MI5XSwGsCGmDGLsJ0SYX25M7XkngFsc6feMetcp+l21iPbIldiFY/gdPSLGx8TChgHOTE4lxKL/4pv3AnM/UC9eIK7fOtgmproIFQf1tRTCexGNHjyxb4V9DcA3YEWuAYrwT3Bp+MnKDIk8zTN+wkAJHfKzrwRD0uNjvXYCqs+hXBivXFksMMrexH7IHZtrdm2vg0CNAhCicaKTdSXMzYdAXOyGdIayDQPis/bdHz8ahIBuhOYpAI+zuwsrjH3DXW0f57g6pymoSqUbgUFH5fYo3dDKhJzcl2Qug9vky6Drnc6G5E/ro0KKU8n3YwYKlz2sQkI3S8sesbmon2WUE2VA8RF4ZNeWF7fxETltDeSl6AcHVpKsOiMZZIMZikL7G9xOdhkaR23Xo2jlEKFA145sijH3+WALGtpoj6+Y4AjqjzyRYP9UanwnKSjYz3jGQkO98QT3TaJCiRo0fjD03EQIef0LEyITaXFwjbETOKevVXnzeI2rnrz8dQtW9wBRtyj9/xyt98/Kryv90eH4hNWkXxQcbZjRLBxCbrFk7iWpXjdX2NqqqUm70dLpQDw0dCHdAX7lgDyoj
 X1Eh8JfA
 TP4nah1yTBRkNLIKH6XGP+BdKnhh5UMtd1sVQqArk9+rPt05AQoV9P5RyZ9R4UuwYXzV1blsOMGOYtUhAK+zE3tPxhD3yDJxZs0CVMXFvIzl5tNjFTjCJDPmicS9LP6TyKb//Hft4p133FJ2GDKBcPoh5RKMwSxmnnI9N8LYKoKqN3xckBODENWEL9ghrkl6hBDTJkGLlpr/SoNx3IoEbJgeoEqUzGDl5pFlzT2v55chWAvtLiYACQ3CvF8S9+D9Hgm94aY8lKXWXbnkkRPJvdHYqER6KCsdYOfrwvJhk4HX7+GoXbQNlHDv5GezWNV0BXCXGmAqMVpKfytcW+a17y076fgImEBw7cZKsHFAnRrDyTD2I8IuHqbtAKk3+IzKex1SVlDaihWuFJrBWJzrKsGlLexG/52oMm6JW6GhOZd4wKUWqLm9tjhsACK/8ZBetHEYEnkD6oQQForoptXAq614NHCmlnVsCB97RPkroYG4ctQt/o8SR3soDueDBQuwIKx522Ynzt/NhVsg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/13/26 09:25, David Hildenbrand (Arm) wrote:
> On 8/5/26 23:05, Matthew Wilcox (Oracle) wrote:
>> Instead of knowing how hugetlb handles hwpoison, just ask
>> is_page_hwpoison().  This gives us the flexibility to change how hwpoison
>> is handled without updating this function in the future.
>>
>> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
>> Reviewed-by: Jane Chu <jane.chu@oracle.com>
>> Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>
>> ---
>>  fs/proc/page.c | 8 ++------
>>  1 file changed, 2 insertions(+), 6 deletions(-)
>>
>> diff --git a/fs/proc/page.c b/fs/proc/page.c
>> index 7d9387143435..323e4c049f69 100644
>> --- a/fs/proc/page.c
>> +++ b/fs/proc/page.c
>> @@ -233,12 +233,8 @@ u64 stable_page_flags(const struct page *page)
>>  	u |= kpf_copy_bit(k, KPF_UNEVICTABLE,	PG_unevictable);
>>  	u |= kpf_copy_bit(k, KPF_MLOCKED,	PG_mlocked);
>>  
>> -#ifdef CONFIG_MEMORY_FAILURE
>> -	if (u & (1 << KPF_HUGE))
>> -		u |= kpf_copy_bit(k, KPF_HWPOISON,	PG_hwpoison);
>> -	else
>> -		u |= kpf_copy_bit(ps.page_snapshot.flags.f, KPF_HWPOISON, PG_hwpoison);
>> -#endif
>> +	if (is_page_hwpoison(page))
>> +		u |= 1 << KPF_HWPOISON;

I also just realized, that other users in this function now use BIT_ULL.

> 
> snapshot_page() takes a snapshot of the folio and the page. If you look at
> "page", you start going to the live version again.
> 

If we really cannot use the snapshot_page, one alternative to avoid using "page"
after actually snapshotting it would be:

diff --git a/fs/proc/page.c b/fs/proc/page.c
index 260772b20bd99..f2fc0917f0b6c 100644
--- a/fs/proc/page.c
+++ b/fs/proc/page.c
@@ -223,12 +223,8 @@ u64 stable_page_flags(const struct page *page)
        u |= kpf_copy_bit(k, KPF_UNEVICTABLE,   PG_unevictable);
        u |= kpf_copy_bit(k, KPF_MLOCKED,       PG_mlocked);
 
-#ifdef CONFIG_MEMORY_FAILURE
-       if (u & BIT_ULL(KPF_HUGE))
-               u |= kpf_copy_bit(k, KPF_HWPOISON,      PG_hwpoison);
-       else
-               u |= kpf_copy_bit(ps.page_snapshot.flags.f, KPF_HWPOISON, PG_hwpoison);
-#endif
+       if (ps.flags & PAGE_SNAPSHOT_HWPOISON)
+               u |= BIT_ULL(KPF_HWPOISON);
 
        u |= kpf_copy_bit(k, KPF_RESERVED,      PG_reserved);
        u |= kpf_copy_bit(k, KPF_OWNER_2,       PG_owner_2);
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 29f13cc6b52a2..7e14e58b98c38 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -5496,6 +5496,7 @@ static inline bool page_pool_page_is_pp(const struct page *page)
 #define PAGE_SNAPSHOT_FAITHFUL (1 << 0)
 #define PAGE_SNAPSHOT_PG_BUDDY (1 << 1)
 #define PAGE_SNAPSHOT_PG_IDLE  (1 << 2)
+#define PAGE_SNAPSHOT_HWPOISON (1 << 3)
 
 struct page_snapshot {
        struct folio folio_snapshot;
diff --git a/mm/util.c b/mm/util.c
index bf0513d1d3d08..06195d0801130 100644
--- a/mm/util.c
+++ b/mm/util.c
@@ -1294,6 +1294,8 @@ static void set_ps_flags(struct page_snapshot *ps, const struct folio *folio,
                ps->flags |= PAGE_SNAPSHOT_PG_BUDDY;
        else if (page_count(page) == 0 && is_free_buddy_page(page))
                ps->flags |= PAGE_SNAPSHOT_PG_BUDDY;
+       if (is_page_hwpoison(page))
+               ps->flags |= PAGE_SNAPSHOT_HWPOISON;
 
        if (folio_test_idle(folio))
                ps->flags |= PAGE_SNAPSHOT_PG_IDLE;


(I'm starting to hate all these different hwpoison helpers)

-- 
Cheers,

David

