Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E0941C43458
	for <linux-mm@archiver.kernel.org>; Mon,  6 Jul 2026 08:26:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B51406B00DB; Mon,  6 Jul 2026 04:26:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B02026B00E8; Mon,  6 Jul 2026 04:26:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9F12A6B00EA; Mon,  6 Jul 2026 04:26:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 736FB6B00DB
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 04:26:32 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E558216899A
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 08:26:31 +0000 (UTC)
X-FDA: 84957670182.06.EF02F9D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id 369CDC0007
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 08:26:30 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XD95iwxe;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783326390;
	b=VVz6yXKfHfjwG/7Gg/sr8/Nbwe15/3Zy5daLuG9htB2H6Nc396j4VKi0BGp4lhoFc21PsT
	fOglJo7+MmXCFCn7QeFe2JwvLhR7iPRIQnZetVRN6qlk94fSNFqgDAB7jm7iPM/BXA0uWP
	uogm1pghH/5K1TYI5s1GEIPr6HSaqPQ=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XD95iwxe;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783326390;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tmx803utrU9SauxJqUVH2L6AoBvfeqUv4jPv6Ckgibg=;
	b=X5KMmKjcmqqYP16tZSOJ9oTszrM4COO5xjNE6pox84rI+cGurTY8cqtgVruy+d06HGG/14
	5Juqq9qo5ZAXN2U1r+lh9G8CmN3esjmLNXXRv6+I1r8drXWcz8S3+CjFmMK41g+J3E9SYA
	i6Ritii1LC1ypVgevWzFjlJ/gafQ9gw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id B005561389;
	Mon,  6 Jul 2026 08:26:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B1641F00A3A;
	Mon,  6 Jul 2026 08:26:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783326389;
	bh=tmx803utrU9SauxJqUVH2L6AoBvfeqUv4jPv6Ckgibg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=XD95iwxeSuM7nYOntQkQSp1XpHvUUgRt9Mm7J9d/VkZR7E80FEFMjJDyGmJ2W3djC
	 9wn0A2P7kC2wbHe3hN+Njj9j1Xs6X+k6y5/jBwSCwDGLG8EHFgsrWjAB7WBPw4fvCD
	 Y7/R+g18v+7739iD4xJ/z7uq1D9TSJUsFQm6Bqr8vkVSlGW03mizQKKqj46q/4Yy4x
	 LnWl5QFzmJBiObpyDxm8FglWgHjaTedegyorDWXtgHodH70MpAr75sIwmgxuE5oSc9
	 GBkFcjXN53YsFVNITvvNvy1s1H9e7xDLx+TZjutjsIHCTen+wvEeQLP9hQtRZ4SVoh
	 nmjH8mUphDNvQ==
Message-ID: <66e478ca-1234-43b8-854f-fed4a804f4fc@kernel.org>
Date: Mon, 6 Jul 2026 10:26:22 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 5/5] mm/page_alloc: remove set_page_private() in
 prep_compound_tail()
To: Zi Yan <ziy@nvidia.com>, Andrew Morton <akpm@linux-foundation.org>,
 Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Brendan Jackman <jackmanb@google.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Mike Rapoport <rppt@kernel.org>, Dennis Zhou <dennis@kernel.org>,
 Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@gentwo.org>,
 Alistair Popple <apopple@nvidia.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260703-keep-subpage-private-zero-at-free-v2-0-2970fe777dd6@nvidia.com>
 <20260703-keep-subpage-private-zero-at-free-v2-5-2970fe777dd6@nvidia.com>
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
In-Reply-To: <20260703-keep-subpage-private-zero-at-free-v2-5-2970fe777dd6@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 369CDC0007
X-Rspam-User: 
X-Stat-Signature: sbcuzz9ymu69386wocb8r4j6f63x17r4
X-Rspamd-Server: rspam03
X-HE-Tag: 1783326390-50358
X-HE-Meta: U2FsdGVkX18RGBpKC4Utxqa2Pxv2J2lp0JNr5i2v+ppiuaYTn1bMeMRbmmkkIwPMh7y6Dzgt5AqO2LJywDaKNUcQr8GVH/xBdQBYLZ+66ra0TSiQYkKrvl1SKqlMpgz8tCn+HNKeWoz9DH+9f0GbBQfbyxje6GF4Z0Pxmg60C0pqe+4TTM0wIT83j9J6X7KipWFH4g8cVxDm6Ejtj2LQmLNkKwcv/5JwesKKwVitJE3QhgM0CdxeH50uRBndp8PPcpqM0x+ij8CKJURzAmosHYgpGMtdOTvtmuiahPleloCh3YkG0vXsw/mTA0ddu3aF0IlqYn9Tdabn+Xxawtr9x0kB+2pkKnem26f1JeOIWuzsY1sAokzkR/tyAvlKZc3PI4aqBrIAOR/JGgbylZwOrxn/iwFj2KCg5OZP5OIdlrCfjPZGfg7Hb4zzNhP/hhAuIDC4bqJFCY+Q0spDiz+HMWW7Re5UzhID9NSvvQS43WbFt0KADPbhxa0ftD3cCQTaG92ChR23tfj/AHf+4+idEh5oQN1VPh2XEKqDCIXX+D14Js7zgtSzEwzd507XfMIbp4WY4uCI9Jgk91ekZgFpqdBjtKdCPBxmwoKalpiBp6Kz295wuHViCvX1gC7Uf7nzcOa0ZaQwRYfQFNN8Ft1dRpAcI5e9VuOFdP7r8ZskOBc7ikTgoV/kdENMnuqljxLn7+v4/2IfludM/MRIAJnfZ1OB3FO5oQm8DqR6A8j5pAalX5GeBIKRLI9Bk+Qgn37YuQ8mamqfrgQ7lyyf04XOGbF9ZI5lzvW4evwxscJ2g82heaVeYnmpyfJSfvAPsekkt3VN+U/7bLeBxY3rHddgXD8+tNhqx3DdPHpApppcx/xowYRgMQwZSn3phThWFoWDmXK1HwGDnP53S2jiXq8c5cQbyEKfFzFx2rkpGmWDbt4iqBwrpDkZmdIIUsDiTTrz0Z45pX6Z4fGaizvsTzj
 JT6By35c
 9XtzLRLtPKjH+TaVXizGuNBBpd1udpB/z47yhjuSwEcxoeeWLIlMzB7+J70hUbbJx+6uW4/PcJ0FKQk2t2i71pa0k8z9RfvjaCpmES0EvkT/xbssVUSwPxOuhVywNU1yyeXY9OfeoXaCvdanvq+hpjP+kZXAtfFwxS7YEs+HCalXC1rzWqibukzlLtaWtEPorNojItxbhf22V+9c8LNZfTnPS4NCjE//ZhWo/LlD+Ny21KnwXZiO4DtHp8AnkcJjKYu1UfmtCTufGBqJb3kMdvFgtcl4wf64Q9lsBFhCh6Lfv61tn3UkuLnrASLkYnnbX9j5M87dfIEaIf1gP2SEG677lg0p4aiW02Kng
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/3/26 15:47, Zi Yan wrote:
> Tail pages are expected to have (and optionally be checked) zeroed
> ->private when they are freed. It stays true during subsequent
> reallocation, so replace the tail_page->private initialization with a
> VM_WARN_ON_ONCE() in compound page preparation.
> 
> Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
> Signed-off-by: Zi Yan <ziy@nvidia.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
-- 
Cheers,

David

