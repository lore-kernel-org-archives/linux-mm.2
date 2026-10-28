Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A489A606A326
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 08:21:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lo8yN/ZD
Received: by kanga.kvack.org (Postfix)
	id 91FBC6B05CC; Wed, 28 Oct 2026 04:21:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8CF826B05CD; Wed, 28 Oct 2026 04:21:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7E63E6B05CE; Wed, 28 Oct 2026 04:21:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 472336B05CC
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 04:21:55 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B68EEC0BE4
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 08:21:54 +0000 (UTC)
X-FDA: 85371341748.05.8AF7CA5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id D375840004
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 08:21:52 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="lo8yN/ZD";
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793175712;
	b=HFd1iG2s6DtmslgPnEi/L9uiiBClUY/9F4D3kNaId3ECK8TrDj9nOsshlI+/6pNWnoT5Nf
	y+k9anvbipnXf5V+KQR7nfjfIoI4vBFiF8jZMemLX2rZlTXwtYOwi3602oIU0Xd1UN+vKr
	YGjVv2mF/xp/v29ufjkElcpVTAA3lMM=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="lo8yN/ZD";
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793175712;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JbQ39/f3ASQKleDrdvaHaj6KcDl8Bzg/BJL2F5+HWZw=;
	b=a1j0kLcGOXdxJjsA6FMa4jqGiftGk1EIzCwYMnofpegifststseRtVPE53mi6LgpTK5nfK
	/1rcR8egvWgkli2ErKCOSWXh+WkFyLil383TeovlQoxjEoytG8YWtBbHKewAmNhCgB7VHD
	kUuJNA8uvKQ4CRYDYTGuhGb+XBhxhrM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id F3B0640742;
	Wed, 28 Oct 2026 08:21:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D12961F01828;
	Wed, 28 Oct 2026 08:21:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793175711;
	bh=JbQ39/f3ASQKleDrdvaHaj6KcDl8Bzg/BJL2F5+HWZw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=lo8yN/ZD7PTJAuyTezKHOR1S2XSvFaPwIb+JSQUm7CJIGxtgbBqO9ScRWAfTIZAdJ
	 0y1HZBF3TwjbMrS2/R45EENexfZ2zgb8NgBkBGAnFPq6p/o2Bmy+HxMQ0J9OHdVPRx
	 GvNrAzuywX5nT7wZ5ADy95kzFEf/4k+DFDbkKkyMptMgj2k8qA1uN+yjzn+k68K0R+
	 cB1bSScHHNP5Ur7Ryx8UMSjpNpUN2j3pr4UOVUsJOoBIdfw629npgMXIO7As1vNdQ5
	 cH3i8rnIBSFO/suQ9NBdtcGN6BD2jKVcb8ghtfeko/D6TrFZ3x9ZUfliUF5N/v+hKO
	 35+OqUKYsgaEA==
Message-ID: <10ae2533-cc4b-4c30-95d7-705815ba7830@kernel.org>
Date: Wed, 28 Oct 2026 09:21:41 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 12/14] mm/shmem: fix truncate loop after boundary
 swapin failure
To: Baolin Wang <baolin.wang@linux.alibaba.com>,
 Andrew Morton <akpm@linux-foundation.org>, Gregory Price
 <gourry@gourry.net>, Zi Yan <ziy@nvidia.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Ying Huang <ying.huang@linux.alibaba.com>,
 Johannes Weiner <hannes@cmpxchg.org>,
 Vladimir Davydov <vdavydov.dev@gmail.com>, Michal Hocko <mhocko@suse.com>,
 Hugh Dickins <hughd@google.com>, Lukas Czerner <lczerner@redhat.com>,
 Carlos Maiolino <cmaiolino@redhat.com>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 Daniel Verkamp <dverkamp@chromium.org>, Jeff Xu <jeffxu@google.com>,
 Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
 David Stevens <stevensd@chromium.org>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 William Kucharski <william.kucharski@oracle.com>,
 Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>,
 Nhat Pham <nphamcs@gmail.com>, Miaohe Lin <linmiaohe@huawei.com>,
 Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org,
 "Kiryl Shutsemau (Meta)" <kas@kernel.org>
References: <20261027-fixes_shmem-v2-0-86a00952acb9@kernel.org>
 <20261027-fixes_shmem-v2-12-86a00952acb9@kernel.org>
 <2d111275-e7a8-4ac5-8618-f068e87145f2@linux.alibaba.com>
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
In-Reply-To: <2d111275-e7a8-4ac5-8618-f068e87145f2@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 5crxysgs6q8551okotztcryrxbcdc65x
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: D375840004
X-Rspam-User: 
X-HE-Tag: 1793175712-694154
X-HE-Meta: U2FsdGVkX1+fiRMBdLxbcCzRYAaB+NU0Jkd0M+3hokpwx7F0CM+NTGheQ3qPeh3KIu+kBHEItk2453m2+TCDgzL4GI45l3bgm79+5qcr8ryPyyvPP2AZxJDVe8mp68hTo/8BuEz5xjkE8SnlafVwEKAPgerAcbLm4J0+IthEHWRxBFduCJi8brwGyYxFe7voODan/a8Pv2z2lJc4tIzrlOEew9pOBsEC3nmYlk4KC1E6dQcLFyeWjjNyl6HFrulG/F0UleVWvZ+WP29eiuoJR6sUm/jLtfZcx4tRCSXg8sEFnitHJrv2jBqI8vuHYibuyUAxhMGU0P4b48zChGKGQ9/UtrPPJpCo1XH4cPCzsYadlC6tcL5zFHVZN0e/8cFRIK5U3ENPeT+LX3C2y1CVh8ezCSn3DnHGgXp5W5ck1yqOQwdr87Zlyg3DPIb2l8MtPBRct2h+RhPoNcZJpEsfCrvlbxYotEfDGkQE3drXZ/OILtb7ekgecNHQSlCf94reMZCbnsw15x7Z9NdNvdfNMKOa0fkawGH9+h0sLFaVTi74OUpLl6M22eJ+sOHvmyUtNq9s/ej2UpuSYsPqTMi2ut75AMqkI+qhE0NmYQ/sZ+VGjMbiMDziK5Kj5XkiIju+Sb/MXnradvt7mrjyj7hu1g1thxH6oUckzHLypnR8Cz1ijOsoVBF9mOgnpa5zRwT+gl/Li8XX23fh7b5ilNFDctWdPe3baMS+b/rjOk7r/R327+fP/jasYgYQ8qwDT2cdn65KJWtQYUa59WVFH6TWWyGJwo8AFyO1IM6AscJg4o/11qTKOwi/3zm8IsthA6qr4ZbNqcHp69agIV9XYOksUiw8XlwgG50eSDnbNAFcJNNcZAa4IQxz0MMUhOctNf8/dLFA8dyUvmri80Mf3Bmuu0E6dS4JwMMc5fFdub8Z7nncWvxLmQZR21S+sVWzLW0DmHTTFTcJPhNT3z/FJpa
 B85vD6zb
 rrJqmERVj0a9VW+0PscOjUMnzpMMRbAUArSHp0vV2nm88+HLZVvxIh3mt3tYjd/pCAVLqSe02t7OihwwjhXipPckdHC1ZrXgIuL0Mnma5jCKgJv9tsujNdfHBMAd1h4fMwBDdFM3u2paZ6ERI6pY/v71bJb9sqOZxR5LkglVyC4VIShWQWbTvldvbkFyOdJ0a2x0xH5vF+vEg73yYj6nQd/jI+MadX/nznB1oKPgeDqCfZKy8aYVLC60LMP0ZON/CezNDHMfS5NIY8WjmoV8sqODZDYuuqWeN2GndmSZ+9kTObhtX/pPloU/bW+tj9LN4NGMw4/k80Hg5QjwZlXrmcrlVeQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 10/28/26 02:30, Baolin Wang wrote:
> 
> 
> On 10/27/26 9:03 PM, David Hildenbrand (Arm) wrote:
>> If swapping in a large entry at the new EOF fails, shmem_undo_range()
>> leaves the entry in place. Its final scan skips the entry, then restarts
>> from the same start index and finds it again. Truncation can loop forever
>> while holding i_rwsem.
> 
> Right. But ...
> 
>> Advance start past the skipped entry so that a restarted scan can finish,
>> as we already do for folios that cannot be split.
> 
> IIRC, we originally avoided advancing start because a concurrent swapin fault
> could split the boundary large swap entry via shmem_split_large_entry(), leaving
> small swap entries below the new start.
> 
> Sigh.
> 
> There doesn't seem to be a simple fix. We may need to swap in the large entry as
> shmem_get_partial_folio() does, and then split the large folio. I'll work on
> this as a follow-up.

Thanks!

So you are fine with the patch as is to fix the endless loop?

-- 
Cheers,

David

