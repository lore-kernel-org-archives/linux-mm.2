Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 48DA2CD4F24
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 09:34:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8AAF76B0005; Wed, 13 May 2026 05:34:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 85BF06B008A; Wed, 13 May 2026 05:34:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 771B46B008C; Wed, 13 May 2026 05:34:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 62EB56B0005
	for <linux-mm@kvack.org>; Wed, 13 May 2026 05:34:24 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 1170B1A07C8
	for <linux-mm@kvack.org>; Wed, 13 May 2026 09:34:24 +0000 (UTC)
X-FDA: 84761886048.12.DB90AA1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id DEE38180007
	for <linux-mm@kvack.org>; Wed, 13 May 2026 09:34:21 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=GLg+0KzZ;
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778664862;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NQIowi8HYwL1Mw8nX8dtQ244LtjS+YgvYBSiVQO9Uqo=;
	b=0ihn56RBnic1GzxwxRvfT8+a2cIe9AGD3EFzP4oIdJoNHiYEFQP3xJYgBb3FxRx+FRMzQz
	M3c6+ORZ1nmTPxKgjkQ7UqaO6+ozVO06zK9JAdwgvXs0feyi+lpgTxmbDZO7DEHBf4FOHp
	grlVy0f7yFyfDOfRzmtlcEcUidw+tqg=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=GLg+0KzZ;
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778664862; a=rsa-sha256;
	cv=none;
	b=sj7Yts9mbngOgCxE0kzMcNDfI6g+WrN6cGc+aGgyAnRFS4wMOufBELOVGmwSFvuXjyUwD1
	8tHNYI2P1WnGdYP+LByQZIevVowz5kzOyq4UYECgqswCGgDNnMeP0pDk66AfsRIqqsikJj
	1H4Rhsih9MRq/yUXmpMpyJWOWaq/Z2k=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 98B8C4183F;
	Wed, 13 May 2026 09:34:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3135EC2BCB7;
	Wed, 13 May 2026 09:34:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778664860;
	bh=cwBcOAhw7XRGs1cBgzSo6PxgfXRn8QQsB24E7xZ/gvg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=GLg+0KzZ6dVntq3/8ZFIx74+WBMQ00O4/y9y2xAt2h8GaaLD9B6Xjx/+quGrtiqQV
	 YDpXVFEw3KFl/Pa/oGwSbzBONLgUKCD/Fi+BljLlMKpGqVWyILNaa6ywRQGDnVxg21
	 QbfbLViqD8MiMJj/CYaXPpFQY6wsrklhRcJ+ke10SAQKpHgypqQftKnwaAtHPgQFPz
	 UHs/WovtV9kL+uqoXn42RYuVrQqNiMnt7/PeFfbyJHLiicqoQfrmMF/LGYEQx5zkGV
	 rPuB3HE3WAeqJbVs5cDeG181sardfUQoco+U4/KitEQYXr6ogxdND6eBgyWfiavlni
	 SzcZRDT1I9cLg==
Message-ID: <6f8793d2-80a9-4c8d-8154-5ec56a26499a@kernel.org>
Date: Wed, 13 May 2026 11:34:08 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4] mm: introduce a new page type for page pool in page
 type
To: Dragos Tatulea <dtatulea@nvidia.com>, Byungchul Park <byungchul@sk.com>,
 linux-mm@kvack.org, akpm@linux-foundation.org, netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, kernel_team@skhynix.com,
 harry.yoo@oracle.com, ast@kernel.org, daniel@iogearbox.net,
 davem@davemloft.net, kuba@kernel.org, hawk@kernel.org,
 john.fastabend@gmail.com, sdf@fomichev.me, saeedm@nvidia.com,
 leon@kernel.org, tariqt@nvidia.com, mbloch@nvidia.com,
 andrew+netdev@lunn.ch, edumazet@google.com, pabeni@redhat.com,
 lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com, horms@kernel.org,
 jackmanb@google.com, hannes@cmpxchg.org, ziy@nvidia.com,
 ilias.apalodimas@linaro.org, willy@infradead.org, brauner@kernel.org,
 kas@kernel.org, yuzhao@google.com, usamaarif642@gmail.com,
 baolin.wang@linux.alibaba.com, almasrymina@google.com, toke@redhat.com,
 asml.silence@gmail.com, bpf@vger.kernel.org, linux-rdma@vger.kernel.org,
 sfr@canb.auug.org.au, dw@davidwei.uk, ap420073@gmail.com
References: <20260224051347.19621-1-byungchul@sk.com>
 <982b9bc1-0a0a-4fc5-8e3a-3672db2b29a1@nvidia.com>
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
In-Reply-To: <982b9bc1-0a0a-4fc5-8e3a-3672db2b29a1@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: DEE38180007
X-Stat-Signature: g73hi3b7fb8my4o336irdseqd7ufjqnh
X-HE-Tag: 1778664861-540990
X-HE-Meta: U2FsdGVkX19AnTUfPZS0R1J1shV91grHeo/SY8YLH1LGvX84cOZgqHTmKvX3VpkZR7X1unFyoEygu1M6h/qZd3JVbrqPxZV1oaVMgCv//dNBq6uN2uDD77Sjam8XrJCC9QFIC4WhHlWM0I+4pO515iEmfPdOdM2tNokKqLWl8oUaDlwn8xBGo09YVlg2bCn/+qWOimCj4127kHzQ6jmIPwBeuSVD/rRrtd6JQFAYhTJ9Chd+9b/e8YBwfXaHL7Gd2omHxqFIDGHajW6O98Z+6RN9FIGvq3Xp2heKqZJWjBdrF193toc8wl+vYcKx95YuABPp/POXzsDdNIuNzUqtV+Jt0wAvoAYlPOfDM6deYxQhEI0IsQWzALjLNa5KkedogvF+oocWo7shXuxW+TWWSDb4+p/NxRXJfdAbZ4d9XdbB+ncRBVay/0IdR6YD3vGnfZ5fYjtR4FQ1xjBGxbmeLMQEIIpYPr+LJRh88N4jDHN27o1V7G8UtIUwlWg/Ok68sX86hqKml//AqUMyXuDUH0AQTH11C2jozQqEsqwphsmh+LgsrKL5Eru9uX9+0XlvFTAeEjanu5UK1CPYuaNQqXEOToB8ufrWhi0u7Pa9H8S6MUoV/wxm8TGIQpSkYUy+gOIMW20F/JhVcSrC4ybRd+LKZfCU+3vIHLB+9wAP/EBGoOy4rj0yIBpFgPNXE2pi0UyMDrT+PEHZbM+zOdwEP4ThJsnxwG+eh4e88lcNE39BkT7vCECg0BKSzggRkGWVksZFnWbyM59wfiCZteWxxcAYGFchB7jQzdVVVQ1EWrWzQVZFpk54OXukwJRD540H1w4hPSzIzT/Az4H28fQeFZFqp9cUwEDNNAMwr6jNYK7O2XaqKN2jyymz4BsHdUGEj35h2IiTWV1fKwsB7ggaxZ8vlcqxDxLWsRrue8MpvhTqwb3V1VhccX9nwo1Bvem3jeKC6OBGETVliFSmYT+
 oCdmDmf6
 x2a5yAazXyml3G/rR9gM9hUXm0Tb2AR+1g3OEDwo/wieLVaJxQBQWIa6be3c3UJ5h2sSo7/x80D5/yabItbrFOfkdh2hifZ3xG4HaHSv+VwkSOx+xBDjg1qRPQ/+k0ifEdT9tUntZJNy2QpjdYeDhWirokjjlNO5i4zu64UrKmJtLb8jF6PUJO1uz87DP6YdC4fu96FvqvACX1OmTV83pnNtNq2a0d9CpQEgFHAXszXsMMDw6jxbKxpryGCeUP/0YwQJpnjhms5IayXus7CVbhQaTX2uzs4SwUqoY28qm7RRIvYwxuuC4pQMjFXqOrcWnSQJFH+IcvnBhp3Eqp+VfMQvXztYO8JzqiB7+Do2EmlRqoIMw50QGeKUpZnzQ4SC5s47DtPMCZLKnhbRaq5BGBnaB8FtyKrt/LdwG4slWyt7oXn6fXuk5VmLM2Uzn3zeT03sfNsJQm8bCuqOcnZJalltj1c+4OXutz3Vo2yW4GmPYzpDoiPiu6LxFERMw3CldSkDvDB+aReFgLR7joA3m0elC5PrF5wbfjWO2
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/13/26 11:00, Dragos Tatulea wrote:
> 
> 
> On 24.02.26 06:13, Byungchul Park wrote:
>> Currently, the condition 'page->pp_magic == PP_SIGNATURE' is used to
>> determine if a page belongs to a page pool.  However, with the planned
>> removal of @pp_magic, we should instead leverage the page_type in struct
>> page, such as PGTY_netpp, for this purpose.
>>
>> Introduce and use the page type APIs e.g. PageNetpp(), __SetPageNetpp(),
>> and __ClearPageNetpp() instead, and remove the existing APIs accessing
>> @pp_magic e.g. page_pool_page_is_pp(), netmem_or_pp_magic(), and
>> netmem_clear_pp_magic().
>>
>> Plus, add @page_type to struct net_iov at the same offset as struct page
>> so as to use the page_type APIs for struct net_iov as well.  While at it,
>> reorder @type and @owner in struct net_iov to avoid a hole and
>> increasing the struct size.
>>
>> This work was inspired by the following link:
>>
>>   https://lore.kernel.org/all/582f41c0-2742-4400-9c81-0d46bf4e8314@gmail.com/
>>
>> While at it, move the sanity check for page pool to on the free path.
>>
>> Suggested-by: David Hildenbrand <david@redhat.com>
>> Co-developed-by: Pavel Begunkov <asml.silence@gmail.com>
>> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
>> Signed-off-by: Byungchul Park <byungchul@sk.com>
>> Acked-by: David Hildenbrand <david@redhat.com>
>> Acked-by: Zi Yan <ziy@nvidia.com>
>> Acked-by: Vlastimil Babka <vbabka@suse.cz>
>> Reviewed-by: Toke Høiland-Jørgensen <toke@redhat.com>
>> ---
> 
> Seems like this patch broke tcp_mmap because
> validate_page_before_insert() returns -EINVAL due
> to a page having a type. Here's the full flow:
> 
> getsockopt(TCP_ZEROCOPY_RECEIVE) returns -EINVAL because of the
> below flow in the kernel:
> 
> tcp_zerocopy_receive()
> -> tcp_zerocopy_vm_insert_batch()
>   -> vm_insert_pages()
>     -> insert_pages()
>       -> insert_page_in_batch_locked()
>         -> validate_page_before_insert() returns -EINVAL
>            because page_has_type(page) is now true.
> 
> The patch below fixes the issue. But is this a valid fix?
> 
> diff --git a/mm/memory.c b/mm/memory.c
> index ea6568571131..4cb12673f450 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -2326,7 +2326,7 @@ static int validate_page_before_insert(struct vm_area_struct *vma,
>                         return -EINVAL;
>                 return 0;
>         }
> -       if (folio_test_anon(folio) || page_has_type(page))
> +       if (folio_test_anon(folio) || (page_has_type(page) && !PageNetpp(page)))
>                 return -EINVAL;

That's wrong. The type is stored in page->_mapcount, and rmap code would corrupt
that type.

So if the pages should be mapped to user space, it wouldn't be possible like
this. Today ...

-- 
Cheers,

David

