Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DD1F7606A31A
	for <linux-mm@archiver.kernel.org>; Fri, 30 Oct 2026 21:45:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=REn6JYNu
Received: by kanga.kvack.org (Postfix)
	id D776F6B05B1; Fri, 30 Oct 2026 17:45:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D29166B05B3; Fri, 30 Oct 2026 17:45:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C17DD6B05B4; Fri, 30 Oct 2026 17:45:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 94CE56B05B1
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 17:45:53 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 21259C08AD
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 21:45:53 +0000 (UTC)
X-FDA: 85380625386.17.5347F52
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf31.hostedemail.com (Postfix) with ESMTP id 5A2EB20002
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 21:45:52 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=REn6JYNu;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793396751;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SIsDvo8Dwh8MYMeNu3FFHHVGCAky2rFlF8V3AFBYuzI=;
	b=wKQtlWfH2up577y1OwJ5PNg73l6j48xiQ0j3ZuCJ1BPAnkXnMdseIE+Ag1n7hn8cnTqanC
	VyK/K0DdbEYwnkxeSb5A4Lvmc15zu0LQmm80h4Pqn3dD6raKdE/AkC+YYrb4Y/v38ydFbc
	38bYbpbgrQyAwZJ76V3qMrmIYkzEgdA=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=REn6JYNu;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793396751;
	b=F6dkkhlCiuUn+2W503A+XXUXuikcwxaPJ/aS/XUPJ0WAHzGqMrlzSaOKUdW7R/uoY0wHI0
	ny9gyfsFtWlIlpcB3rMXcZgEUUpUMQMJCAUmD4L91Xx7KDY5qQOmsx7EBKIfD9l3W0GzU+
	oMvcVa2Z6VfCaoOjywhbq05RdqMhIdk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id EFA3E605C6;
	Fri, 30 Oct 2026 21:45:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2049A1F000C1;
	Fri, 30 Oct 2026 21:45:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793396750;
	bh=SIsDvo8Dwh8MYMeNu3FFHHVGCAky2rFlF8V3AFBYuzI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=REn6JYNuTaJzMeDN8DZXvOKj7thT3j16dF/ka7EDQaG8MndhKTcYOw2iiHSQ17P9t
	 1HqWdwfQBh0NGz1R/QB7AI5hBA0efLY1FlDxPGoSSMVsjqMfIyAQevEasS6MKOVesg
	 OPBkYDYTOcWLQniqt/12QSn1bWrZaERhcgchEF3Ped2ucRK7HXbH4O3ppZDWchzFpJ
	 UtA1IrgJyRyW8oN+ihHH0GzsHIJBei1uGbgjUzh3hLgxDSgWhzLOzmz2O6XG541N9y
	 y3gUKfKOe7HyjJ3RNFKjdWqbWjvAbSo2I06DKbXTK0HjA6bVq/OKRH94qB8dn7yD7Q
	 zaCkfX8XfYJZw==
Message-ID: <4e4a1e82-44cb-468a-959f-f06205641515@kernel.org>
Date: Fri, 30 Oct 2026 22:45:30 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 06/46] mm/filemap: read mapping->a_ops->free_folio under
 i_lock
To: Pedro Falcato <pfalcato@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>,
 Lorenzo Stoakes <ljs@kernel.org>, Kairui Song <kasong@tencent.com>,
 Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>,
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
 Baoquan He <baoquan.he@linux.dev>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Kees Cook <kees@kernel.org>,
 Peter Zijlstra <peterz@infradead.org>, Jann Horn <jannh@google.com>,
 Hugh Dickins <hughd@google.com>, Pasha Tatashin <pasha.tatashin@soleen.com>,
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
 Gregory Price <gourry@gourry.net>, Joshua Hahn <joshua.hahnjy@gmail.com>,
 Rakie Kim <rakie.kim@sk.com>, Ying Huang <ying.huang@linux.alibaba.com>,
 Jason Gunthorpe <jgg@ziepe.ca>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, kexec@lists.infradead.org,
 linux-fsdevel@vger.kernel.org, linux-arch@vger.kernel.org,
 linux-cxl@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>,
 stable@vger.kernel.org
References: <20261027-fixes_core-v1-0-6f74bec9a5bb@kernel.org>
 <20261027-fixes_core-v1-6-6f74bec9a5bb@kernel.org>
 <auDG-5bYh2tSQem8@pedro-suse.lan>
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
In-Reply-To: <auDG-5bYh2tSQem8@pedro-suse.lan>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 5A2EB20002
X-Stat-Signature: j5femdqriyycoaxzemfqxgm9yyf7dj81
X-Rspamd-Server: rspam04
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793396752-537248
X-HE-Meta: U2FsdGVkX1/EgfT305g8KTB87sYqxV98gj3WTyB3dbNcMJjie/1stmx0Cil5UUk4hnve3sIo+i9LwbGS0pAyWYd2jBFxmi0HruGvA6QcEvr6Te0CBi2KM4hZH0hBKSmpgYPR1ZyT0u6iyLKE6Wp6pTieeB5Y+p36QrRgoLTDJknIoquJrsjFEQ8ZLHowHOHaemrguCRoMsSzFRXXfn1qc8nqxfEpABcXM5zOnRN6MeRLir19/giATWgdDc6abvHf5EuwyUyre4/IQR3d2MotBj61h961DHHP1V3WGG5tEeJ0V9n8NrORm9WZekxb2xy/DheCMSmL7nO5yKdKqhi5Nuna8FtIR/AWl/8aHQcZ/5iKY6gZLF/JGgal/c1mrnWIU2F/F2mHNvmZZ9RELQryLD/6uIdl1toNRg+sURgrwoUwr+8yN0YLFQMy66UnUTEkSnieVKslH2VF7tJ2AzhpGExkBHgwsJSMRgFm6gbwRaz/2MGw6EI7O2XrrZlGUgKOF7RYjVpZBzHvHXQU0IJg0XtUJUuUsDjEffBDc0Av8K66i2BOl2I/nel77PBxhTYJ9lshrAAbdlZUR2bc5qGcjW1Y0l4I0GWY0SD9bbD1io1FR6h0aqwxtkCo2Lykrx/mseGc3IhyqVFXOBVQVnnRyaA+0NLr9XdjvREyj/QFXtmmhFb0dj+Ue5NBXkn9MDZaxm9hyPlQipttYC7JYAJXLsd5vxNPdWy51zGv8ks1MI/aBN32+PS3RPZQdLjDzI//5F7O7rppakkzSW40LiGDYkJzBLrvDTB/bwNYEMMUIfLH8ocGmqEfvmChSP+9hxqr/UZNMpHyS5LPYaU+wB4DgA1B9vDmEwGz3Fo/6fxiE+8gLZ1mUfzB5EbEfb4wX8offyEjtK0Pe/qKLRVMpUnAaJbigNoy/qyPlGV/aOfzwU00JpO2Z2XpEd5dVp9twY0Rc84P1RPrmcLIujARk6Z
 tz5qM9k8
 F4YyvSSr4FaHEOZKMGrNUx/PpceJFv6UMmT1N+0x5lF6E3ZCPOBaQry554hR9FlpJabb8E1EgK+iTU0hFNmh8S/Evnry65pZBZpohX8ZMydQhyiR/6KPDFwxa0xhRmPSV8TWMDNCXIcLEakshypSrjj7e41TLlsE3D3EKZQSlY89SspUG5zSTYPU2YPzY+S6gA5POIN+DCmA4O/x7IBgPwIxlh5yV9Sccd3EJRaPAsWg18yK2RjKRZyWKfoHSRhJG28MoEKK+3U6+yBzfwJBj+ziTl7DHys2dRARY/q19eys2QiA+z8+Vy6EPvFfi3e1BRB6MghYC1VPmyC+MqCPWn7tPIv+pJjcHfWAoh8jLBQZWIsg8Q20rXpPBlFTIuwnpmZSinq7YQfx2gfX/Ch2bAZaBtn0fLnaz9VlT/pnKtNd2S78hq/oDg5lRkw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 10/27/26 16:47, Pedro Falcato wrote:
> On Tue, Oct 27, 2026 at 12:17:26AM +0100, David Hildenbrand (Arm) wrote:
>> From: Josef Bacik <josef@toxicpanda.com>
>>
>> memory_failure() -> ... -> filemap_remove_folio() can read mapping->a_ops
>> after the inode has been freed. Once the folio is deleted from the
>> pagecache it no longer pins the mapping, so after i_lock is dropped
>> e.g., a concurrent final iput() can evict and free the inode before
>> filemap_free_folio() looks up mapping->a_ops->free_folio.
> 

I agree with what Willy just replied.

But his reply made me realize that I missed your reply and just wanted to say
that it was not intentional.

... after I already missed another one on patch #3 ... guess my fingers were
typing "r" a bit too fast in a row. :(

-- 
Cheers,

David

