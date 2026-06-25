Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D1A26CDE001
	for <linux-mm@archiver.kernel.org>; Thu, 25 Jun 2026 11:47:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C8A2C6B00BF; Thu, 25 Jun 2026 07:47:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C62286B00C0; Thu, 25 Jun 2026 07:47:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B77CB6B00C5; Thu, 25 Jun 2026 07:47:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8BF456B00BF
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 07:47:36 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 14C4C14069F
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 11:47:36 +0000 (UTC)
X-FDA: 84918260112.27.81A5A1C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id 60E4420002
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 11:47:34 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=G5Vm4Dz0;
	spf=pass (imf13.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782388054;
	b=FlyKwvXvXlXwCZP5rqT92B75mqL5PU5JW1WFcpd0F8QIE575O0J94DhqEBeMT6NTyktwNP
	haWAzTQ1+5QYN4xaNreN5TVompdVZXzD3SQPu27mw/MU+oYyDQP5fXGbODn7FMdXmGN9Ru
	KJa31SnYyWHcJdaUZPhv3Y0RdMfq8WQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782388054;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Lp9WB6zXi8E2sTZp694xYWZZj+zJNQ67XHQgfj0Z/o8=;
	b=QeNcobqkh47OPirE4w7iyqZHjr+9wMlXYKXeLxxfKdA1PSe+F+BS4vhHjDDkODceU8KpXj
	7aXzrGAI6bnUP+/jyZ2OsGRS8xler0IS8OtOT7w4uXYZMLkDVQC0d/tTAbX/J91GSPM/5v
	/OYf5u5zdxE4BOseaPmCRiO2FIP4ZF4=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=G5Vm4Dz0;
	spf=pass (imf13.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id EE1106021E;
	Thu, 25 Jun 2026 11:47:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44B4F1F00A3A;
	Thu, 25 Jun 2026 11:47:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782388053;
	bh=Lp9WB6zXi8E2sTZp694xYWZZj+zJNQ67XHQgfj0Z/o8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=G5Vm4Dz00Z/WLyF8vee9vI6yArVVZqfevw4mjzc3wX4tYDj+DouC6+0eeQLgfB03H
	 x2jAUEEpx/TBBsYrCT376J3HvRA1EzqIWgal0oyWDYQ6DD3pmUV+VlpkMm/DR8HeqO
	 7O7OdjZ6cKAEES2+cqf1mfUzHFYwePzNC+2GqSiA68T9O6m1JwsKrqaLwfUZ/AbH5I
	 o62zOrANcxlik21ipb5n71ccrMDxphD0BksXrXd4lk7BtftRXoLCuZkKl/n8I3hJz0
	 UR0RrkVhQyAlcMPjuoAhH3ejl1q/Saw984qzf2c45g9y2Bb2JokMEchZI7FS7dYewe
	 zyN/Lek5/TJGw==
Message-ID: <d462612c-508c-4682-a776-92f4f4a40e28@kernel.org>
Date: Thu, 25 Jun 2026 13:47:25 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/3] mm/mmu_notifier, drm/amdgpu: block THP for GPU user
 mappings
To: Yitao Jiang <jytscientist@hotmail.com>,
 Alex Deucher <alexander.deucher@amd.com>,
 =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>,
 David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
 Felix Kuehling <Felix.Kuehling@amd.com>,
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R . Howlett" <liam@infradead.org>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Jann Horn <jannh@google.com>, amd-gfx@lists.freedesktop.org,
 dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org
References: <SY1PR01MB10596EB75463208A8E1EBBA0FC0EC2@SY1PR01MB10596.ausprd01.prod.outlook.com>
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
In-Reply-To: <SY1PR01MB10596EB75463208A8E1EBBA0FC0EC2@SY1PR01MB10596.ausprd01.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: a77eotknkwwo7bg1pypi168a3ajh8ej5
X-Rspam-User: 
X-Rspamd-Queue-Id: 60E4420002
X-Rspamd-Server: rspam02
X-HE-Tag: 1782388054-356933
X-HE-Meta: U2FsdGVkX18uuTFMaRAkthTViQXGaoo/UuLq3NWQgk31R/ZxeW2aO1AgTrqtVtogFr9DudKWSYsTCGlFQzZSEC9UnULqxL8UqJVgd534CQr2N0/zt0Bye/JAUqVMk0OqZDWmlOPNnUScFC432QwuszdDjQxRARbWfu9t9FB0o6vShexoQoilVDVeen0uPKfX0d12zQlaIojDQBlczU16EdHfPw4UQeejRnjyisgJP8rTwxkKnLjit6xpFdWVOzmH+PJp1cBGSBELGSfldPHau9PaPizMm3JBdHl3sbgvhpSFIXJpeTewoXDE2adMcd+VQV+TvhibkXQJpHt1bIXFxIHTjMvhzVD4FKRE75aM/NSUtgnQMzOayAkxZxwmry25GZHdeWuVK6BdA5Ne9s2sC+odxEnj+NZaPIfVWYPnKTC7UXImJ3lyj0vkSNShivW1Eh07OvVuBfWcN8iv1OKH1VOdL0CubqjnTuQ24tcXQ8VevjBfEzSgh01QyGEF1GOzxUD8hnzwDrgre9Lxwp1Exh53NX3dA0Zz9t722UUjZzJUttp0toaRhsp9/+74sdvJfHCCQ0x1nkLJGE+fm83erw2ZQFD58J+0+/IPHIkjsnV0VdRGHKI+V3AgEqcQrkTi1jlhfd6OLECs39dWe1+53FSmHCNwPRAxwxrxJ8riYThdkwMIpLNk2w2DxIXuEShiuXQlqF5DpG85q4uDWzv7WE3DiLF4uq0FoGQgisYA5/TF47cSVAhCcdRWVouzFtTNphuB6GIiaisWu+AfNemn2pfopovc3zyKQ7ZXR5NpbdJk1l4bEUaQokTLnWpt5DYY2V2cWxdFXOzCDsYmuHkkO5QsLzIFL6Zv6F23MnYX+lF5urj+umLkl7aRQmhfwuiEAmHu6iqMrqjLSIpUO1f2sIq4C+r96pakm83XhNp1Y9CXrTMe0T8rfp8x0T2MdXCFzAvOeV0MElpjdAfoj6V
 RqNLA5sv
 jUtc4e1KA+EfZhU86RhH32LwmlhvJwypnxwjwLhvrWEtd2YiTIApVKeWQWtvC23L48b/n+z48PCSQUSZPuTaeTRzcSubDXVHxJfRaTFIKiMYzFR4Qa+c6Wcl3nRXtOw8H7GJubLxUYQsvr6vz8YKbS/JN3f+L9uhidHV2sYqONbIzUnQ3Jk0yq/5bm6bvdJOc/5CFIm2+a885PqyGQdlkaQmFVfwXGZ6pJ06peEsn91Eu5a3NfB4yPdfG/rlqkfNNahJ0YaxzISoefyNHs2uxOSOhsPYMjQ/4j/xSR/yNlZOwd9Bfc6tGLrM1wA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/25/26 12:59, Yitao Jiang wrote:
> Hi,
> 
> This series fixes a THP policy problem I found while debugging
> frequent ROCm GPU failures on an AMD Radeon 780M system during ML
> training.
> 
> Some AMDGPU/KFD user mappings are registered through interval
> notifiers and cannot safely tolerate the backing VMA changing from base
> pages to a transparent huge page after registration. Userspace can
> still apply MADV_HUGEPAGE or MADV_COLLAPSE, and khugepaged can also
> collapse the range, after the GPU mapping has been registered.

Huh, why? As a memory notifier user, you must be prepared from memory to get
unmapped+remapped at random points in time.

What is the precise problem here? How are you handling THPs at registration time?

Letting arbitrary drivers make THP policies sounds like the very wrong approach.

-- 
Cheers,

David

