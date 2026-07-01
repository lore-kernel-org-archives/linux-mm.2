Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 765DBC43458
	for <linux-mm@archiver.kernel.org>; Wed,  1 Jul 2026 08:18:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 65A466B00AB; Wed,  1 Jul 2026 04:18:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 60B026B00AC; Wed,  1 Jul 2026 04:18:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4F9896B00AD; Wed,  1 Jul 2026 04:18:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1C4956B00AB
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 04:18:29 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A4265A02A1
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 08:18:28 +0000 (UTC)
X-FDA: 84939505896.17.4586655
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id CA4C910000D
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 08:18:26 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LKoNVL4g;
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782893907;
	b=wSfZtwiCXvhIlRVoAmwFZ+rSSDVZd2uCxnYkJsVMYFA+VlUy4L9NQGmy9aDxxINzzZZj4J
	UK4vfOkKQ/B9zFGT2Ra/jVnqMKQG+FUPibb9gFe022p2CC2usZLvoDCbJEK+WqONd//o1v
	g+g3mYgP1jqEHXh66zQNMvQ2sclqBtk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782893907;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nDL3ilZVm2uMCF1pO9rBAggewE0THWnlKKczkxpeYj8=;
	b=tHVgrhFw4io4z5rNb8lIjFGGYNdthpCsih4+UUbbOaJLgYTLB4CVslVsdolOE4upE2rTVZ
	387lONTRzkl8ppSXgbxcT5FngDU34PFzQtv3oWIllsbCbtuoq2I0wi03d8vcWFAZbk4UTe
	gOpTXf1c6JnT2uAAx4pr4nvbkkhUDPc=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LKoNVL4g;
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E862B4401A;
	Wed,  1 Jul 2026 08:18:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5CFF1F000E9;
	Wed,  1 Jul 2026 08:18:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782893905;
	bh=nDL3ilZVm2uMCF1pO9rBAggewE0THWnlKKczkxpeYj8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=LKoNVL4gjYpGxBtnO4v3Q2F8NC1jF1fN/yySyi2CjqRa5Ts5CGAgrUVgiXYAxUoWT
	 6HOzYQRI7yPU53Gzp3Jz+LBMhzfoEzAQW2AOXgkI0+UqECGwrmlHRyQUV5pG19unAT
	 i5ioIfQh3KKBswp9pR5E+Zu2ybe19hhTuxAZ6kYVk4xnKOXq6iB7ade+OKJEr+2oG9
	 AFHqpQ0iMG5WyiyjBN6MZ3d+BrBnbzY8yZ4QYY/RTKHXBtLs6IMZrODqT1zmx9p8ID
	 gcXaWVYXsw36zUNnSYzUVBQwHLs8PdZnXGdprytdDmGDeMRxmzVZ0S8cUX77iaaYpU
	 dV6G33jjw6ZJQ==
Message-ID: <430e75bc-3993-40da-9996-71583e44c2d5@kernel.org>
Date: Wed, 1 Jul 2026 10:18:19 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 4/4] mm: try to free swapcache for non-LRU folios
To: Barry Song <baohua@kernel.org>
Cc: Kairui Song <ryncsn@gmail.com>, akpm@linux-foundation.org,
 linux-mm@kvack.org, baoquan.he@linux.dev, chrisl@kernel.org,
 jp.kobryn@linux.dev, kasong@tencent.com, liam@infradead.org,
 linux-kernel@vger.kernel.org, ljs@kernel.org, mhocko@suse.com,
 nphamcs@gmail.com, rppt@kernel.org, shakeel.butt@linux.dev,
 shikemeng@huaweicloud.com, surenb@google.com, usama.arif@linux.dev,
 vbabka@kernel.org, youngjun.park@lge.com
References: <20260623231635.43086-1-baohua@kernel.org>
 <20260623231635.43086-5-baohua@kernel.org>
 <e56c4d73-ed4a-48bb-8d0a-97b1200d4a35@kernel.org>
 <CAGsJ_4y3yC1DCsHfCn5FP6vK3jqNRbqU5pbBqHnb5LB7GgtWOA@mail.gmail.com>
 <ajzm3pHq-wQlLNmm@KASONG-MC4>
 <c16bd777-6dfa-48f9-8dc5-2b56bebe67ad@kernel.org>
 <CAGsJ_4xh1P1yw3JogQxTS=Vu8kLEiMMh8si2YnCc9qnoKWLwjA@mail.gmail.com>
 <1e7a712b-33f4-44c2-85ed-6333ddca421c@kernel.org>
 <CAGsJ_4w8zK=xvWhRpyPiPS6JskmVnEH8E9fdQOYmk_PHb1bZtw@mail.gmail.com>
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
In-Reply-To: <CAGsJ_4w8zK=xvWhRpyPiPS6JskmVnEH8E9fdQOYmk_PHb1bZtw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: CA4C910000D
X-Rspam-User: 
X-Stat-Signature: wd4he19h7xyh5uj341ni1agfz745ptrs
X-HE-Tag: 1782893906-138439
X-HE-Meta: U2FsdGVkX1/yvopi38eTU8dHbrJxZ7g+/Xa3zrP4oVzbYvuZFMtVVhTtyCYgKbSAJJeEdsxwLdu1cOh2q4csEG1d3didql5hTwnIAMqbsCRdW8RmSH2aH/WXMccDYDTasvBbOG5jJZA5M6mpVP+EYZ770tARtWVjd/9hk2qvX3x7XBUhT+f2KRd4r9cCtHkZn5CQ3R1SOz2vPySBKGsya2roXf7OFSCZyxdMbV4QVSDlhurOQV9Id/plk1OtXUPPrZxB9wlIJUpVVFPQ9uv9KINQdDT8U8uRCtmJKheB+qfMRsqCt907YF+1fUsjMf7/uW+By8ISmJW4x6NxQC/ZFlCJ4MFj7l0ANZuudTcqdmuPXe7n+xxeOVodmpQZP9cqUwzHLQHMPDMU5CvfWwZ13DfZQA5wwy1SfHC+AtJs/8FHG2InX6ty+vdHdTFZztuzH3uF1UNJNhVHUjEstoHJ5HnKrIuFLvvFrh1dT4F0dDvSb2x8uIWCvo9EZoia3bCFljjx+f1u4MAOHwwgjAG9Umjn3W7kQ662w2D30oFC+sL4X1Q9tEyJpEaOs114m9eoe5kazNTHXv6cPH8shI05F5xPlksSHF/rknwHtgPfS9XulJMaLXZ3fX+FG/kE2QxlIVUDZ53laYAkVGRwbai8nEuI6wEFTMJQCP5YDm9/odJqot6VrLlmsxYKsuY648pMoq/XcremGz6e1eCV6e4vXJ+vHZS+BJtoMfufTxBmUzKYy2SdGiqVnjR15O+T4JEfsqe5PdNtG7Kn55s5BfdzbgBJVs58WHnVc8oUApmu5nrR4qtIkneL94Tz16N2q0nJEYZsYSXXN6eEHXcPdpZEn56nee5A1CJbkBcS4jyWkhQr6hZ55/dXcY3EBmAxEh73zX21uvjpqdF6AV2CnwxAYcDkurSRiMi8aY5Z2/3WvFomB6MLQs8pNQJg9pDrn1E95mtUdIJSuOoXZMx+/WY
 0d/HJiMT
 brcCe7MKPJUOq6VJs4SOBv2kTrAYSOKwVJf1Erc6O5GG4YgwidBMxVzQ7hii5qhEeZBng56lRMkdVITbQ7A13lEbh9CYhWZJM2+qvAyYdWYWcQ0kZMnraMVFdr0EtiUQxmEg+3F8IussHx5/6AgJOpnu5CF5Z6oVcJEbKoz6W0ZJxC/pMSlLDwBK3HGzGyk6CVyFQfHZKJk6UJYUpwaGtrOe29vZtF0zrnzpnwKdVvwxOcyKfpCNAllAbs4ovBCyWXRPUuhR5Sc7PG1x7NXnYoymofzv6QqsWUcBZ0kVVX+zAXEQjf5KTFtHSPOHZZ/xoz4VRQiuZe1vY2KMAY7qu3upr3pK25hlb1xT0
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/1/26 00:36, Barry Song wrote:
> On Tue, Jun 30, 2026 at 1:48 PM David Hildenbrand (Arm)
> <david@kernel.org> wrote:
> [...]
>>
>> -       if (vmf->flags & FAULT_FLAG_WRITE) {
>> +       if ((vmf->flags & FAULT_FLAG_WRITE) && !pte_write(pte)) {
>>                 ret |= do_wp_page(vmf);
>>                 if (ret & VM_FAULT_ERROR)
>>                         ret &= VM_FAULT_ERROR;
>>
> 
> Thanks! I'm working on a v3, but one thing still seems a bit odd to me.
> 
> In patch 1, we're removing the local LRU drain from
> do_wp_page(). But in patch 4, do_swap_page() calls
> do_wp_page() for folios without the "exclusive" hint,
> since folios with the hint have already been reused in
> do_swap_page().
> 
> This can happen when we allocate a new folio whose swap
> entry lacks the exclusive flag, even though the folio is
> still reusable. For example, in the scenario I mentioned
> in patch 1, the swap count is effectively 1, but there is
> no exclusive flag:
> 
> #include <sys/mman.h>
> 
> int main(int argc, char *argv[])
> {
>     int i;
>     #define SIZE 30*1024*1024
>     while(1) {
>         volatile int *p = mmap(0, SIZE, PROT_READ | PROT_WRITE,
>              MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
>         volatile int q;
> 
>         for (int i = 0; i < SIZE/sizeof(int); i++)
>               p[i] =  i;
>         madvise((void *)p, SIZE, MADV_PAGEOUT);
>         if (!fork())
>              _exit(0);
>         for (int i = 0; i < SIZE/sizeof(int); i++)
>               q = p[i];
>         for (int i = 0; i < SIZE/sizeof(int); i++)
>               p[i] =  i;
>         munmap(p, SIZE);
>     }
>     return 0;
> }
> 
> The newly allocated folio will likely still be sitting in this
> CPU's local LRU cache. If we drop the drain in patch 1, it seems
> there is little point in calling do_wp_page() from
> do_swap_page(), since we won't be able to reuse the folio while
> it remains in the local LRU cache.

Well, we call do_wp_page() here to avoid another page fault where we would end
up in do_wp_page() and actually break COW.

> 
> So I'm wondering whether we should keep the drain in
> patch 1 by checking for a refcount of 3, or instead do
> something like the following in patch 4:
> 
> 
>         if ((vmf->flags & FAULT_FLAG_WRITE) && !pte_write(pte)) {
>                  lru_add_drain();
>                  ret |= do_wp_page(vmf);
>                  if (ret & VM_FAULT_ERROR)
>                          ret &= VM_FAULT_ERROR;
>        }
> 
> Otherwise, the combination of patches 1 and 4 seems somewhat
> inconsistent. It feels like a strange mix of sweet, spicy,
> hot, and cold—kind of contradictory :-)

Yes, this needs a proper thought.

What you describe is relevant for

e.g.,

swapout
fork -> exclusive bit cleared
child exit -> parent is single user
swapin -> added to swapcache and LRU cache


This is not very odd, so we should keep that working (I think I have
micro-benchmarks for that).

-- 
Cheers,

David

