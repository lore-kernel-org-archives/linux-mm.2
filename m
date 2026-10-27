Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C51E4606A321
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 19:32:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=J2KOffh9
Received: by kanga.kvack.org (Postfix)
	id CA0766B08BE; Tue, 27 Oct 2026 15:32:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C518D6B08BF; Tue, 27 Oct 2026 15:32:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B195C6B08C0; Tue, 27 Oct 2026 15:32:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 85CEB6B08BE
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 15:32:11 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 1CEA1140AD7
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 19:32:11 +0000 (UTC)
X-FDA: 85369402062.28.C5F0B45
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id 47CD6A0009
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 19:32:09 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=J2KOffh9;
	spf=pass (imf25.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793129529;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pdMKQRVfPao2Y0l/0sEvsr0YaDZON+7McqaGQOdPdzM=;
	b=cSSR2VqEYkFHcZYkdMp4mvzZ/voqdc1bOXSyk2FkP0jfY15sFKWxZWspHnxq2QX0zjVQco
	FrdRgsCLK/bY1OA/p7Jm4rKqrIdoMwy/sQUUUW4ZFHq/J7ddutfDj/ZYR4qcTtLxC2mlCx
	ZgK7qKGEjXoX5rWbzgRfyhc6X2+GwXc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793129529;
	b=1URPFa5s2jAhdDBexr3WQUoR7M/ZaZOhcAdweCx3OhBsBrAXHNB9xEusbQ2ssK5vJ2gGnL
	igY/Md6JQHo0ADRy2KIlS++P+YMwgPvTPXETRO8F38VClb3gz1pf15dKeEw7duYDT9ATJo
	i3xL/K/GOQxgOSBvphMPytXhKy3yKUg=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=J2KOffh9;
	spf=pass (imf25.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 75A134019F;
	Tue, 27 Oct 2026 19:32:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 256D31F01825;
	Tue, 27 Oct 2026 19:31:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793129528;
	bh=pdMKQRVfPao2Y0l/0sEvsr0YaDZON+7McqaGQOdPdzM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=J2KOffh9t5THz/aVV9AXm+zRNrOFDoRwtp977EUo1PAOBknoI8V3BnNjjtRLAE4Ru
	 GY5GDPTQ+/81Ar3+hzwrjA0JeTMSAd3xgLXkkWNIOh4w5qNGRaWbYHgigxK1BSB0q7
	 ly8wspHWyvxYXk9F43GT7SewL7fEGQ0Hpa7OJz1VbSrP8w/Wv8rLA0NKXANgiBfMrD
	 TTqIJu5xLE1Ab2vB6aGL8JXJt7kYBWgxH7cJ5Z/fmQvZq4f73ADggruc/guEar+TGR
	 HrC4fv0DA8YODO90lZnMcUoWInit/GOljN2R28H+dA2gPH4zQmKtMA4c2HYGyd/lsp
	 d3rkBUoXQHNBg==
Message-ID: <e894d61c-9b99-4fdd-bf88-c4efd77a75ff@kernel.org>
Date: Tue, 27 Oct 2026 20:31:50 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 25/46] mm/userfaultfd: wake waiters when registration
 modes are removed
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
 Gregory Price <gourry@gourry.net>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>,
 Kairui Song <kasong@tencent.com>, Barry Song <baohua@kernel.org>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, Baoquan He <baoquan.he@linux.dev>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Kees Cook <kees@kernel.org>,
 Peter Zijlstra <peterz@infradead.org>, Jann Horn <jannh@google.com>,
 Pedro Falcato <pfalcato@suse.de>, Hugh Dickins <hughd@google.com>,
 Pasha Tatashin <pasha.tatashin@soleen.com>,
 Pratyush Yadav <pratyush@kernel.org>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>,
 Zi Yan <ziy@nvidia.com>, Lance Yang <lance.yang@linux.dev>,
 Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>,
 Alistair Popple <apopple@nvidia.com>, Nico Pache <nico.pache@linux.dev>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>,
 Matthew Brost <matthew.brost@intel.com>, John Hubbard <jhubbard@nvidia.com>,
 Peter Xu <peterx@redhat.com>, Will Deacon <will@kernel.org>,
 "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, Nick Piggin
 <npiggin@gmail.com>, Oscar Salvador <osalvador@suse.de>,
 Minchan Kim <minchan@kernel.org>, Muchun Song <muchun.song@linux.dev>,
 Xu Xin <xu.xin@linux.dev>, Chengming Zhou <chengming.zhou@linux.dev>,
 Chris Li <chrisl@kernel.org>, Kemeng Shi <shikemeng@huaweicloud.com>,
 Nhat Pham <nphamcs@gmail.com>, Youngjun Park <youngjun.park@lge.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Ying Huang <ying.huang@linux.alibaba.com>, Jason Gunthorpe <jgg@ziepe.ca>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, kexec@lists.infradead.org,
 linux-fsdevel@vger.kernel.org, linux-arch@vger.kernel.org,
 linux-cxl@vger.kernel.org, stable@vger.kernel.org
References: <20261027-fixes_core-v1-0-6f74bec9a5bb@kernel.org>
 <20261027-fixes_core-v1-25-6f74bec9a5bb@kernel.org>
 <179307782442.2301705.17273288326330283268.b4-reply@b4>
 <auBcES74Q5M3MWCW@gremlin>
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
In-Reply-To: <auBcES74Q5M3MWCW@gremlin>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 47CD6A0009
X-Stat-Signature: 1d4bku8or9y11inmufx4o7ua5derrf5y
X-Rspam-User: 
X-Spam-Status: No, score=-17.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=4.0.1
X-HE-Tag: 1793129529-644551
X-HE-Meta: U2FsdGVkX1/wlnI1nb2EGHddpnDC1MMnLE90Ul0hZBCf9AVEZt20cPyG7y1OOldmPIqyjzIjB+9W9ssupsXtYEnFmGyt0mBZC9F0SfW7GBLdNAsW031mBA8iK3SreojHTXxnNZoLQTInj8h5IUrSdF0IyA8EDfboyawpSaYhqHm24BH54z2+LF0TL2VAUJptPpMptNQAaKx9A1iD+Jlf9om3FwKSvoNgSRBAaL0tbcGCuVmLdzFO4oyKCDaJwpmqB6TYxh3dsYe2w4xe6d0WXrCxmJJ4Zu70tRfHE93OGPq3v6bf3MsCl3xVQnc9KJfO/B/7TWw7EabgkxwuUSu9fAvfBauVme7IYrcA/93g7caRB34yd8S/28jo0HueYWh1ZNqZlkBNrSkuItKFicjy9F0h5vYftEywOobXkAmuFO7WWhZJlxwFpUw1/FWjb7Ys682Jz/Tzu/9nMKgMjYtJ6D4BXUys7pppUgv5v2pk8FIF5RkSKw7cmusKHtjCEj8oKIGgOd0OOX/iqhpIp2gx4v9SZ/hU2pRdzL+F221BHmwMmWLS4C/sPcYTGNhlfFduVr7rTQ6WrU2m2x08/GtlHvVQFYKUDDkUI9bNZgj/Y6jfXK5k9hxqFCu/MytYUw10VaZjpxc9xj0q/asgIDCDPHuIeY8tEzjuc6ncNxBBxBatRjFsO/hxhxhfJ3ngsJUVsoYLJ1mKuoyEwdwLYFH+HJYKTGslaRlJxchHcRJli1WL2I3etEEyuCjOXFFeg/diD19eoKQcnBW6Q0o0FMNpkHaxp8e6Gn1M2fcAWIZ4k92VJxyIKfohcXt8dF1gCXBtiH+I+UIw++WrwGDQJ6pqtKTDogI/SRvdEXRD8HG0dA23OFNIpAMunBRTNANh+2LxMA9boN3+PgrajFXFpPH3RlE/3c1ymmiXQyhoKc4VvLH2uoeA9H/P1RuqpuT3kuJawT/QC586sJy+k2HqEfq
 rBUAcrWR
 IL2yNxROVQ5SA7XRjApXsO8zLb+/CueLVpxhHTPfymbYB4bs4uLrZzc3KNqRG5t817h7WNH7C0uU2fj1ywIYIqIGJpbrhX0lgJJSq9LgR3d/r6/3hgHtAllN4smHaSJW16lUZX4iW/1dC93mmv+J19g7qlIQejNgvMWm8FrvMhhsM2iVa/rTQSvZEVkiGzwbkPbcrwRcRulk4BGNW9Eogqf6PwDkUQsmzJOqGlxnmuqUaosdgdygN01JIs+vbPrumRFC+U6eiQUayX2mOgwyKC/ufcGqTBAaNUClT3rljhGn/H1n86Pg1e82qHWXZXmTAGM+IrehzolzePPePB6wki68BPLqi6niNeUTjLx0YpGjQtUXZG8ki/wY2V1jZ/I2GTyru/1WCYbXnLq+ZejRL7DH5sihjm750kxomVfCqJQBx+rX0q3QE237QAsZGt8DFqbH/Qp0TvYnOdjSRLrnM6nilEg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 10/27/26 09:24, Lorenzo Stoakes (ARM) wrote:
> On Mon, Oct 26, 2026 at 10:10:24PM -0700, Gregory Price wrote:
>> From: Gregory Price <gourry@gourry.net>
>> Subject: [PATCH] mm/userfaultfd: compare exact registration modes before skipping
>>
>> Changing registration from MISSING|WP to WP returns success but leaves
>> MISSING enabled. The no-op check sees that WP is already set and skips
>> the update, so later accesses to missing pages still wait for userspace.
>>
>> Skip the update only when the current and requested UFFD modes match
>> exactly.
>>
>> Fixes: 63b2d4174c4a ("userfaultfd: wp: add the writeprotect API to userfaultfd ioctl")
>> Cc: stable@vger.kernel.org
>> Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
>> ---
>>  mm/userfaultfd.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
>> index 669f71d485d02..0a28130cebc99 100644
>> --- a/mm/userfaultfd.c
>> +++ b/mm/userfaultfd.c
>> @@ -2299,7 +2299,7 @@ static int userfaultfd_register_range(struct userfaultfd_ctx *ctx,
>>  		 * userfaultfd and with the right tracking mode too.
>>  		 */
>>  		if (vma->vm_userfaultfd_ctx.ctx == ctx &&
>> -		    vma_test_all_mask(vma, vma_flags))
>> +		    (vma->vm_flags & __VM_UFFD_FLAGS) == vm_flags)
> 
> Would be better not to regress to the legacy API. I realise we don't use it for
> backported fixes in general, but this patch obviously won't apply to older
> versions anyway, so we should use the correct API now, and this for older
> versions.
> 
> I'll add a better predicate probably to do this in one go, but for the fix,
> I put the correct patch below.
> 
> 
>>  			goto skip;
>>
>>  		/*
>>
>> --
>> Gregory Price <gourry@gourry.net>
> 
> diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
> index 777bf122d32a..c71cb9179913 100644
> --- a/mm/userfaultfd.c
> +++ b/mm/userfaultfd.c
> @@ -2288,6 +2288,9 @@ static int userfaultfd_register_range(struct userfaultfd_ctx *ctx,
>  		prev = vma;
> 
>  	for_each_vma_range(vmi, vma, end) {
> +		const vma_flags_t curr_vma_flags =
> +			vma_flags_and_mask(&vma->flags, __VMA_UFFD_FLAGS);
> +
>  		cond_resched();
> 
>  		VM_WARN_ON_ONCE(!vma_can_userfault(vma, vm_flags, wp_async));
> @@ -2300,7 +2303,7 @@ static int userfaultfd_register_range(struct userfaultfd_ctx *ctx,
>  		 * userfaultfd and with the right tracking mode too.
>  		 */
>  		if (vma->vm_userfaultfd_ctx.ctx == ctx &&
> -		    vma_test_all_mask(vma, vma_flags))
> +		    vma_flags_same_pair(&curr_vma_flags, &vma_flags))
>  			goto skip;
> 
>  		/*
> 
> --
> Cheers, Lorenzo

I now have:

From e2cb5867bd46dd6c601dfa5f0415bf7c8e12600a Mon Sep 17 00:00:00 2001
From: Gregory Price <gourry@gourry.net>
Date: Tue, 27 Oct 2026 20:27:52 +0100
Subject: [PATCH] mm/userfaultfd: compare exact registration modes before
 skipping

Changing registration from MISSING|WP to WP returns success but leaves
MISSING enabled. The no-op check sees that WP is already set and skips
the update, so later accesses to missing pages still wait for userspace.

Skip the update only when the current and requested UFFD modes match
exactly.

Fixes: 63b2d4174c4a ("userfaultfd: wp: add the writeprotect API to userfaultfd ioctl")
Cc: stable@vger.kernel.org
Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
[ david: apply fixup from Lorenzo ]
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 mm/userfaultfd.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
index 710e913c73bf..24b7a2612469 100644
--- a/mm/userfaultfd.c
+++ b/mm/userfaultfd.c
@@ -2291,6 +2291,7 @@ static int userfaultfd_register_range(struct userfaultfd_ctx *ctx,
 
 	for_each_vma_range(vmi, vma, end) {
 		const bool any_mode_removed = vma->vm_flags & __VM_UFFD_FLAGS & ~vm_flags;
+		const vma_flags_t curr_vma_flags = vma_flags_and_mask(&vma->flags, __VMA_UFFD_FLAGS);
 
 		cond_resched();
 
@@ -2304,7 +2305,7 @@ static int userfaultfd_register_range(struct userfaultfd_ctx *ctx,
 		 * userfaultfd and with the right tracking mode too.
 		 */
 		if (vma->vm_userfaultfd_ctx.ctx == ctx &&
-		    vma_test_all_mask(vma, vma_flags))
+		    vma_flags_same_pair(&curr_vma_flags, &vma_flags))
 			goto skip;
 
 		/*
-- 
2.43.0


-- 
Cheers,

David

