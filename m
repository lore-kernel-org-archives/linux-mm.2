Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0F32DEA4FCF
	for <linux-mm@archiver.kernel.org>; Mon, 23 Feb 2026 15:23:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 710506B0005; Mon, 23 Feb 2026 10:23:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 690DD6B008A; Mon, 23 Feb 2026 10:23:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 592E86B008C; Mon, 23 Feb 2026 10:23:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 475946B0005
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 10:23:34 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A5B5E56E23
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 15:23:33 +0000 (UTC)
X-FDA: 84476090706.27.ABFC67E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id E94E64000F
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 15:23:31 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=V7+HQvRw;
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771860211;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1RoF47py/q8y8DrCz6K/90Xii9aAW3toxFuuv1XpBRI=;
	b=62snJxtzlztOnQm+lzZco+jswaQK4/GAQ0yl8FziMvwP1bhUfp+9oDo+QnBAiB4dBMB0O5
	ps3pwapEH3VSRNDDZmTdDxcA9kqdGqp0KnH0Fr1+OB0Y3s2+0sGLE7n7QrRWpVQeHXYjuJ
	SfL1Joh9SLq9oCF89tBYWVZYWOna/kY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771860211; a=rsa-sha256;
	cv=none;
	b=rSWHS2AQn0fZd7k3A+iztL/JH83gOlVGJnWEXeuaGX9iKICfIvzyQrsiLvmaMQBm9JAJ12
	m7Onn5M73TYw7puBf5NJfY4xPAN2G3TvcYEPwT0uX0qkMfc+nu3EM9XbRJQANNpOf15n7x
	b9VT6zzutR+RCAmZ+Ni1+o81sGK+5J8=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=V7+HQvRw;
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 39AC260018;
	Mon, 23 Feb 2026 15:23:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1B05C116C6;
	Mon, 23 Feb 2026 15:23:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771860210;
	bh=bALHuEZfqz05Bg8MqVkjA0pxJVc6K09SZOdZ92Wgj68=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=V7+HQvRwM9bPb0Rxkkv5aHO99w3TUgqWDsppu0UG6MQTNDMsPwzNKNIG2rQPEJ6LX
	 1tVgVAI/NI6k2O3UX6ZxwITvnJwIN794QtGOMz6rSEu6I4kSc68W+gn1B9MzhmSUjK
	 lxUbOGRzV0jEHIwzfhiCpwaV4slLgVJYSJeE7Rqygrv0lA8tEw7Rk6Vt4ZQH7cgKP7
	 yYXhPFFickcwkFwVw9Omcj7Ze/yFW1kNeeVLq8WuQN/NfkM55kr9v7Bveup3cyx/il
	 cX6zxqy072LUeqbhFrMk72NeBYauAgvZVTdERArq2xQcocEJ4gheOB475fPltfsFzH
	 v6g3P8mdHQibg==
Message-ID: <a97045a9-8866-40fe-aa15-d319cafa6f2c@kernel.org>
Date: Mon, 23 Feb 2026 16:23:21 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v1 00/10] guest_memfd: Track amount of memory
 allocated on inode
To: Ackerley Tng <ackerleytng@google.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 kvm@vger.kernel.org, linux-kselftest@vger.kernel.org
Cc: akpm@linux-foundation.org, lorenzo.stoakes@oracle.com,
 Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org, surenb@google.com,
 mhocko@suse.com, willy@infradead.org, pbonzini@redhat.com, shuah@kernel.org,
 seanjc@google.com, shivankg@amd.com, rick.p.edgecombe@intel.com,
 yan.y.zhao@intel.com, rientjes@google.com, fvdl@google.com,
 jthoughton@google.com, vannapurve@google.com, pratyush@kernel.org,
 pasha.tatashin@soleen.com, kalyazin@amazon.com, tabba@google.com,
 michael.roth@amd.com
References: <cover.1771826352.git.ackerleytng@google.com>
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
In-Reply-To: <cover.1771826352.git.ackerleytng@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: E94E64000F
X-Stat-Signature: 5yrnz37qgrw96pbz5594qfd6astwsjmp
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1771860211-85254
X-HE-Meta: U2FsdGVkX1+2bTLx8rgRmKSgg3CafmYlsTFQWXAgeR2L1ACh+YTsG/f2yRFFnwN2dt1NMgHACPAJ7yBk93/806aOwpn8m4FZhyeeNcD5jAznLHcPD6GQrDioVZzmt1p8/6DJ8d7e1Bj5EzaZh1UxYHDzv22U2mXYEm5YWizQiQtn1XfwOGdEu2Xq9R/v9fMyx+77bOa2/cv4RjhsuTkTukPppnVJx+tQajQO/O8DPmdkzTCIPrO0HddLKjTUmMbIdcmAcLO5QvQQSo7CDUwYiBizJwpfYttQ68jMszygTa21o6xeax5DgolDqO/RCBhpdMdm07g3npaHRsKdZsivYY7FyWT/Cp/G0GXCPYavl1XpC+BmXG5j6Py397t7tjNfLUuVQcVY7DhQJPC+E+qUoCRZ4OGStvJzu5hDwExHk7zYDN6Rk9W5i6Ngyt+xSOcdOcSoq0zcNvwc/3TP3ma0U+LW8EwlrKXUJFWIUe6KlcOtd1h4sLATeZLTmOb97zyAKjm/pmB0nxtq/t2hF215cd07qZRnzDws2JFiV4q7xMVCnq/b0QnE6XZz4ooAg1gqyYVJn4NQUTm1fT0/KkS9L9v/B8mb3B6+/6w18BlOMdl+iOaOgHFXoeWvs19P88Jp6v8ZRRw7GoF12BtpN6wxkXWbqDYiB441t/WOag7ZeiBaIQl64XVRqapxXLm0JCnpH2UG23Ez/rXDCJsg82zMuqGYsT54nGKtaSoMnDe+Ayx0yl1kVoaGYZeAznm078qfPEbIvufMPv9MKw3SnUkmrUE+GoFEWVcdrsEsbv4oeW3zB8vb8Vu12I9m4RyQCHTW4hFknuQAfu9f9sx9n/ru7Y6HyKtF+qV9FtkNsqmxttgDkczXAcIFl6Qj1Ve+Rry247GsHmfuTHsqvQssNaJ+mgXCNsqycKzQpuEkJz3hlqce1RtRMsNixKnxG44Vr+dI+CnGlWlPr443eqE+CQ3
 9ifWHmmV
 Y4gNpgprLFnw5oFGRLiZov7MpSy2x/APhNnvh7+/wWzRr9LUrowybcDihagtGj5F4i+WG7PpV6tY0OZuGeqpVpk90h/U4EH7A5dxWafv5iQwb1aQMw2lbaaLz2vqC8nq42Fdws376EfF7j9STKZH/+WFWIY3h8BkR+D4R7YC7BJfeTY0Ic9CbRiEpk+3nBSzrAva4Ne6qy7Jse34Jv23+09Q0Me683NvVkXk8PYaY7iKqG2YyXpPjBH5zOzXXTnNFBydqJP9ZYindOPrVhWqHNVJ22AZPFDDM+CK/3Dvfd46qSilvMmcOQMYHFw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/23/26 08:04, Ackerley Tng wrote:
> Hi,
> 
> Currently, guest_memfd doesn't update inode's i_blocks or i_bytes at
> all. Hence, st_blocks in the struct populated by a userspace fstat()
> call on a guest_memfd will always be 0. This patch series makes
> guest_memfd track the amount of memory allocated on an inode, which
> allows fstat() to accurately report that on requests from userspace.
> 
> The inode's i_blocks and i_bytes fields are updated when the folio is
> associated or disassociated from the guest_memfd inode, which are at
> allocation and truncation times respectively.
> 
> To update inode fields at truncation time, this series implements a
> custom truncation function for guest_memfd. An alternative would be to
> update truncate_inode_pages_range() to return the number of bytes
> truncated or add/use some hook.
> 
> Implementing a custom truncation function was chosen to provide
> flexibility for handling truncations in future when guest_memfd
> supports sources of pages other than the buddy allocator. This
> approach of a custom truncation function also aligns with shmem, which
> has a custom shmem_truncate_range().

Just wondered how shmem does it: it's through 
dquot_alloc_block_nodirty() / dquot_free_block_nodirty().

It's a shame we can't just use folio_free(). Could we maybe have a 
different callback (when the mapping is still guaranteed to be around) 
from where we could update i_blocks on the freeing path?

-- 
Cheers,

David

