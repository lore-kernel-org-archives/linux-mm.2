Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 927B9C61DB9
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 16:45:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8C9196B008A; Thu, 27 Aug 2026 12:45:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8A1DE6B00A5; Thu, 27 Aug 2026 12:45:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7B7D76B00A6; Thu, 27 Aug 2026 12:45:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 508696B008A
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 12:45:56 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D854540121
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 16:45:55 +0000 (UTC)
X-FDA: 85147626270.18.B952350
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 0F3D6140005
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 16:45:53 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="SBm/kPjP";
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787849154;
	b=ZBiGZtBeNpwyHC5u5O2FCZ2gE6+P+JabM1ExRauEMbaeSWItPsDCfKLSQgAZ5bEXIfNS9O
	wm4UgEtL5xMCE7WAwp7Ojz8ehdLr4rcGRcv5NuD835zrCz1lYrjtBIIA/9q03zKbfQuO4q
	+DWDRixFjsFA+SQLZCnoNn/JpR5oX/A=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="SBm/kPjP";
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787849154;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OD2S90orDKINgGCaMDMzphHuo5Rary9C+PKf1sfV1BA=;
	b=rf/c5jHjhzCbYaXtB0xdJOI2qEMQ8hao1IEAw+NY8qFfmxRVlUpWmZbtYgovy7zigjXLxJ
	M4wP8p6L+2CPdtZgDu/1Eg9Hm16BXXUV79OVeONwuR2sQJljegScLz/IeUJlX/by7CLuLs
	SA07AKvss5EbUT8LTgRYEMDn39mP5BU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 39F9241AA1;
	Thu, 27 Aug 2026 16:45:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 390341F000E9;
	Thu, 27 Aug 2026 16:45:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787849153;
	bh=OD2S90orDKINgGCaMDMzphHuo5Rary9C+PKf1sfV1BA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=SBm/kPjP3uMP7DmN5FE6H+oE2PP3vCUUrBbtwIlk7QU8FFKBAnhjKgJXcnxGpyUxz
	 UFJwaTSPmw9DqkMlgSDsnw0ALHp726khUfhHi6aTSHjxSJwmRVTI5zAZplxXg0hHRC
	 sa9oJLAnO5r+UwTaNfcaZkP4ts7YMJnhQgQbS9bOmgRGeazsGVPNyfBEkqLxc63nyO
	 zNxINmqD58NisoGVEI0OOELRWDro0kJjoNDn6yg+lRexMWShKlR0x7Bi2p1FzGQswv
	 u3Gbk+CrnTjxvLqfXdijh/IK4kOBAob33mDX0lrU4O5I9tv9+AUUlD/fXqbvkE/kof
	 4iCuAfnZmDvIw==
Message-ID: <c2aaa7b6-0a1e-4401-907c-3be81b4764e3@kernel.org>
Date: Thu, 27 Aug 2026 18:45:45 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 13/18] mm/huge_memory: drop the unused do_lru argument
 of the file split helper
To: kasong@tencent.com, linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <ljs@kernel.org>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Chris Li <chrisl@kernel.org>, Kemeng Shi <shikemeng@huaweicloud.com>,
 Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>,
 Barry Song <baohua@kernel.org>, Youngjun Park <youngjun.park@lge.com>,
 Shivam Kalra <shivamkalra98@zohomail.in>, Kairui Song <ryncsn@gmail.com>
References: <20260821-swap-thp-cleanup-v3-0-9b43f5163238@tencent.com>
 <20260821-swap-thp-cleanup-v3-13-9b43f5163238@tencent.com>
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
In-Reply-To: <20260821-swap-thp-cleanup-v3-13-9b43f5163238@tencent.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 0F3D6140005
X-Stat-Signature: 7ay37ciwczcbyqycgqd3dsumx7knrdkb
X-Rspam-User: 
X-HE-Tag: 1787849153-976372
X-HE-Meta: U2FsdGVkX1/pYCcYx4eXwJmvcg3Yc6NWAdeC/w9xCGwMgz49rAkdFWQrog6PpMpIgCeZx/ML3NBeM2D0ur7B06ABgaytMZRFGoDlKLj52dy//mgk6/3flkNYHzOV8bGLAD4dRsdPjeGONLPNHfz8D4sFCUjQYZhtwCWRrdX8puRx6KaXEjccEbJV/InBmXDoELF0oU05iLc+UYbVevqAvrJQhIGO76uVHQ6wXUaXVmUuiS8IDNoypQcY05ABB3SlYjl6jWy8DIgyDF5PEkbjJpAMmm5+rm62BuWAHcx7C3FZepLbu7gIoeCIz8Z0R/rQRu6Fcf9J+n3B5Xbp5kcOUBWmaXEWTgiQ4nny85F8zeXhEs6l/wXBpxIqn5ow/vafW+P5IwuVZq7zqSRcvoXYSolW+PlLxUwLKoBZkyEF3EJlFFzFWwBwfkRrLKxh5hkLhnGZW6cxsi6od9+4v3ILR4I/6KEYCLOIQA2lfnrm4s9ACLET4P+WUiCePthGXE0pDGP6/lfY1CDUcG7pAHNDZLk72YOzI0rEJzifgnJxI3tjsrF+Mt2eDIDElXbL4uXfcx4ATGCzjg+79qyH/EaVe8HRZqpM8UldjGEtrYEH4PLhXy1eDjoS7fGTbSlOQFgmZj8qKTKBDQH+gkUVbDkjvUaclq2ltONGhOl3WLyMlfDb2PGeERO+lVsnIhIfZzzcCpub528wHe02fRbw+jBBrNGKJCV34NCIxI08wjuhLz4jHZvftPJIN74dahoXOEx+sLuIq1/K1ZTfnvQAr238QI/7JSvnVsUP7vXnUl9QDRFOGHBkD3RkL4fXnXnurRuzn2xqta+Mt5k3ebQmPu+K4XqYrhlGcbp/+64Zd3UfXu8LhJqN6nONo0+InWLIlc/KE34dSoSVynDs/a69EjXtYxHxhFERanC67yNLmlJspYrJotb3/2OWZNMY2IDL2N6PUnq2ygTlyRGZucc2Fo2
 Tm9+dXwd
 aPxLAVhLgUqtQXohZbNnacLxjf09JH+QxdQQAa88ak2KnFDFpUlCCCDm1qEoZTJ6gVjoWsnzgvtmkR5Ja74mDkWovpHleHSM9RB6veT3328TV7PSfIZllea01VY6sDc94XKxGsvq5CItih7m5KhevGF2JO4lvM1GbSYj+npzfz8dXP9StQxgUTly+Mn4+l/t+Gg/eDmJIuCGRRRkKj3ZsNRjqjzRJnyPX8vMle4DMClhpNWZiDL6nU3dhFZg+9H/cEzOnCtCv0uItsiKcFR19yVLJaLeY7BGcLuR/16kCYg6GVzbsalvVTvdaCf2D+tinmEvrml8RB26vhn6NXFn5hVXzGkF0iU7kO8Ml
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/20/26 20:55, Kairui Song via B4 Relay wrote:
> From: Kairui Song <kasong@tencent.com>
> 
> The only caller of __folio_split_unmap_and_freeze_file() always passes
> do_lru as true, so the argument and the branches gated on it are dead
> code.  Drop it.
> 
> Signed-off-by: Kairui Song <kasong@tencent.com>
> ---

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

