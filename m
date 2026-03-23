Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D95E7EC01A4
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 09:02:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 287476B0088; Mon, 23 Mar 2026 05:02:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 25ED76B0089; Mon, 23 Mar 2026 05:02:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 14D9F6B008A; Mon, 23 Mar 2026 05:02:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 03ABC6B0088
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 05:02:43 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B4AAA8CB3F
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 09:02:42 +0000 (UTC)
X-FDA: 84576737364.12.1C39C5B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id C670C4000E
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 09:02:40 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=uyLdWPEI;
	spf=pass (imf07.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774256560;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rn0KdutTecDYHCp0Ikb/15BtcMWDAU4HIfMus10ttl4=;
	b=K/BKEzDDxWNRtIfTmEDuTGEomjKPqMWzkyYjprZ0ENZSX/hae0fPMKAfAs3bPzMZCNlWwB
	SCa3oudACryeC4R7QQVezeQEX0jIEMTl5N/DCzptI1dDbm98V47ICsSn14ac+UdJFuqZdH
	anMrNojH2GQlX2sirA56rHcjg5OApwo=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=uyLdWPEI;
	spf=pass (imf07.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774256560; a=rsa-sha256;
	cv=none;
	b=bo0/yPpsoxNsQCnZYVWw+H5RMxUKlAiU6Ox3dxAGvSZeCRfjTL4oxtuOT0cdHdcKlrezO9
	Cmr4tkzSiVXJe5MGA2eZGVCVtmrqeiQbmMF1PnRSfb8CB73hmtKJhjMTytlqnL+jUh2Jc5
	U07JX7bSxRaieVhq+albJrLEIsOAulc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id C515E432BD;
	Mon, 23 Mar 2026 09:02:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F6ABC2BC9E;
	Mon, 23 Mar 2026 09:02:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774256559;
	bh=tFl0s2GdS+bqKxT2MhoL/lmIPS7orihy5/P5XndxhE4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=uyLdWPEIraYJdwjOgOshV6RH+yM4c72ucKjDT2i6/zGxUSQfxxTi9M4ju/JACgjUd
	 HaRYx8S7TrP/ixn7SqL76ao/zKTuwQcUvzMdqwcOrn9ff1A8fARbkHtQKGVwEqecAk
	 S67T+dMswNQM719RnTjQUCnNwoXKUJ4WG2VLQcJBwOVqwZRvOmrk3haogUjHiODW+B
	 1cWcxIiLmhMTEPgY1tPxBQcBeVZuyWHbbPO+shF7wOM1L4F5RqrSkKuvMJQbDcJzrk
	 ptrEnMi1O1Acpm0UmNQoH4j3ymSILfGYk8kqzIQal2XYD6EHSmGV0MvSJjq3bomglJ
	 ls6W2PF3N67PQ==
Message-ID: <dac624ea-dcaf-42ff-b0d7-a5b6c2c9d05a@kernel.org>
Date: Mon, 23 Mar 2026 10:02:33 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 2/4] mm: huge_memory: refactor anon_enabled_store()
 with set_anon_enabled_mode()
To: Breno Leitao <leitao@debian.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Brendan Jackman <jackmanb@google.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Mike Rapoport <rppt@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, usamaarif642@gmail.com,
 kas@kernel.org, kernel-team@meta.com,
 "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
References: <20260317-thp_logs-v7-0-31eb98fa5a8b@debian.org>
 <20260317-thp_logs-v7-2-31eb98fa5a8b@debian.org>
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
In-Reply-To: <20260317-thp_logs-v7-2-31eb98fa5a8b@debian.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: C670C4000E
X-Rspamd-Server: rspam07
X-Stat-Signature: k9pn7w81gcxop8jknc7qi9xiufzzwika
X-Rspam-User: 
X-HE-Tag: 1774256560-898936
X-HE-Meta: U2FsdGVkX1+GDJH7fGmEGfNnAex6X21E+ccwrAVLsdmtSQ7VywrgUGMIkeolrFtftAHJqnQm3WJTdoaSQld4vVn9/Nxky1upGBLjGHAnu18ZbqYKE8thDBYaFqt2mqdMpVp+7AxjGbQKFGKjmDGycoEgCmLnpw4KRyI6pdT078mi9I2SZaRQEV4GJwC9N0iMFmSc/pMbsKCzhLndGAHrQszd7yICJsjUMRjwnMXGt8j0tfLdsX48BCGiGdOO2h1xjSM8eYoABCstXYq8SnySiQ8OkhoSkl+H6wD3aKMJcWsoWnQB0WF7k/j60zySQ0nVT/1c60rA1kH+S6LpArW/aUgnQobjF0SnyLWi++S1QGMJvVz3a1f1ENPvSG0X464OiWaF0wK31HR5rLlhNdhF/PeJHxtyuxPTCg889IVOixB2dLrMihNUoeF9PQUV9tDnd0WEXXE41QQGSgguddiG+gK0t3A1TE1Lz4XyUnTLFYmNYUTthhWS+RJzhur20vbhznRHkK8b7pYF9COf9TUDJd5zdMuvz5emqgScCIpl+HChfi9CardseNvS5V/F9gbrG4DI09q7yiQh4P8q4VtN2jOzZubsHMbC1NBIIp7Q2TQZ8cvUx1M1sqgsS5MxAr8g//BnUh1Yj/KOIlTcVZhfBtvHZQStDg2Ktcnx6Gk2gW4vplTuMtJVISRM04iAEFX6ImM7UIG/RZH2U7ZNujC2rdNoTcz1qwdo203KKSW4dXyJZJ1CmIuvVI2SD5ZS1ZKtLA6MlZZUFw8YIgIekG8qqDrRgGyk/KdbXmXyMXuYi8lIJ4d24dNUauSeSHYGiDA61BPTd/Q+xbiCBrTgi1ikXbHl9hlW/qKYPRIFDr+o7Gi5qN3eho1ZBqF/A20LhQq1f4MidNjnt1Rz4u9EozYrpRUHpAQUwYKU/L8/0RdNPXBPBZeavJ6WC355OX+0fnHSVFn6XsWt5x85jLkPuGf
 DHPrLpUZ
 KfSP/1CMERMHFpEuASD5s2C3nAsml1OlL/v3fUn5IwWaB7lNnt4oDwjfdgXKt1Yk6LaEo4Imyk67/J9FjDlQvPS5urgEBDvUoZvKLWuWytmKaqcMhm6kFOd6Wxttg29sqA1+Ecxe+i47fIpDHGl8YlpsxQXKgQYBJkzFgpOw89q/P3nh8QfBFPN35gymNc3LKpADGPc3JPQBybSeNnTFZBCYtKwOsGjB5J2n89RGx0TxXn5FLA/QSgQcTUbdoDQBuX2ZptHULsFgFthHDFQ4iz55mICb0lx6HntFG9rphV43+C/qi3sHnU+76VneCXpjwmJtJ0FpJcucr8rQgV3dX2AMqqx3qIlssYV+g
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/17/26 16:33, Breno Leitao wrote:
> Consolidate the repeated spin_lock/set_bit/clear_bit pattern in
> anon_enabled_store() into a new set_anon_enabled_mode() helper that
> loops over an orders[] array, setting the bit for the selected mode
> and clearing the others.
> 
> Introduce enum anon_enabled_mode and anon_enabled_mode_strings[]
> for the per-order anon THP setting.
> 
> Use sysfs_match_string() with the anon_enabled_mode_strings[] table
> to replace the if/else chain of sysfs_streq() calls.
> 
> The helper uses __test_and_set_bit()/__test_and_clear_bit() to track
> whether the state actually changed, so start_stop_khugepaged() is only
> called when needed. When the mode is unchanged,
> set_recommended_min_free_kbytes() is called directly to preserve the
> watermark recalculation behavior of the original code.
> 
> Signed-off-by: Breno Leitao <leitao@debian.org>
> Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
> ---

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

