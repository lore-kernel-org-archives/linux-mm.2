Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 083F6606A326
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 07:14:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=pZZwpvVO
Received: by kanga.kvack.org (Postfix)
	id 079B76B05B2; Mon,  2 Nov 2026 02:14:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 02A396B05B5; Mon,  2 Nov 2026 02:14:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E33AA6B05B7; Mon,  2 Nov 2026 02:14:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B87AA6B05B2
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 02:14:18 -0500 (EST)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 39B9B120A26
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 07:14:18 +0000 (UTC)
X-FDA: 85389315396.26.427A95F
Received: from out30-99.freemail.mail.aliyun.com (out30-99.freemail.mail.aliyun.com [115.124.30.99])
	by imf06.hostedemail.com (Postfix) with ESMTP id C90E6180003
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 07:14:15 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=pZZwpvVO;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf06.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.99 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793603656;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Qm2rnyse/ykhHOoe09sGuMes6K54FQWZVf+H4ljHjfM=;
	b=u26jUC4RR3wQXfxdePMDEjvLAaxllpx0dFOcPMg1Npv0V8bEyqe0BA8dxf175+EVr0k1u8
	cv41Y8yATlewIiJ8zhiumfPCxKVCta0Q4oWy7rrGh4YwhII0068RZekGlajfi2O8T+skLJ
	xezot824FrFsbQ2aPpOtBkf8on4ky0I=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=pZZwpvVO;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf06.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.99 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793603656;
	b=GyhyMFL8dVKRf5hEtNj3k1NsAKfGNm3au87JZttWECNIaTWN/alV4hG9V+BP3BzyhevMIX
	5UfS3BR7ehovEadPJrWnL8oMqfJXz/WDU0DTkubpbAfEHEXl+ME3WKateVcrRU8IyqTbZ/
	GV7J12z97dbxFoyXlwwd96WFZadmHTc=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1793603653; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=Qm2rnyse/ykhHOoe09sGuMes6K54FQWZVf+H4ljHjfM=;
	b=pZZwpvVOA+uj8Hey3gxKpg914FcxtBCprAFnla7zr3dyAQUuxzoqHrpe26MhbQDCNPM8yoFXpIDWMoyD7pMs/tnTGW5+AV+MRJF7a5OSZwLpbbcuoyBfN66Z17SkJJv5tFYMy0aVFPpkwNEqiU3RWweXPl9HVpCG0EckPfQji5U=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R101e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037009110;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=66;SR=0;TI=SMTPD_---0XDv-BWP_1793603647;
Received: from 30.74.144.167(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0XDv-BWP_1793603647 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 02 Nov 2026 15:14:09 +0800
Message-ID: <72c3964c-1355-4272-b61c-5767f5591f43@linux.alibaba.com>
Date: Mon, 2 Nov 2026 15:14:06 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 16/47] mm/khugepaged: fix PMD table lock leak in
 try_collapse_pte_mapped_thp()
To: "David Hildenbrand (Arm)" <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>,
 Lorenzo Stoakes <ljs@kernel.org>, Kairui Song <kasong@tencent.com>,
 Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>,
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
 Baoquan He <baoquan.he@linux.dev>, "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Kees Cook <kees@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
 Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>,
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
 Jason Gunthorpe <jgg@ziepe.ca>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 kexec@lists.infradead.org, linux-fsdevel@vger.kernel.org,
 linux-arch@vger.kernel.org, linux-cxl@vger.kernel.org,
 Josef Bacik <josef@toxicpanda.com>, stable@vger.kernel.org,
 Muhammad Usama Anjum <usama.anjum@arm.com>
References: <20261031-fixes_core-v3-0-d6437171ecc3@kernel.org>
 <20261031-fixes_core-v3-16-d6437171ecc3@kernel.org>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20261031-fixes_core-v3-16-d6437171ecc3@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: C90E6180003
X-Stat-Signature: u3ut6m67aojpxwwwknknf1izxgrtdeyc
X-Spam-Status: No, score=-19.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_SANE_1,USER_IN_DEF_DKIM_WL
	autolearn=unavailable autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1793603655-821719
X-HE-Meta: U2FsdGVkX19iiY3DY448w4AWSniFZHxOljrZD1CttOBsWU9gqHS8a4lH7VfiWyL9er35Bi+MJJzMeWhbQYyORNlxaPk84o8vUl8NOKERr3vuhjGCOkGJ0+CxTwVbUW3mUN6a3Dq3TFUL2zv/Fsh9C4Sm6hiItFNjJUe/of1qyF92nCLRNaKDyj8WHIB/dwXGwEjYw8i184+5jKvqOFlX8PT7gWhzGf4FNFMOtKT0wVyLDCBOklGjJh73rWjnSLSuBbMNM0fUOdGrGFh2CfK+zc8HCL8r5197UvgAsyWxl2dfqNrlrR1B9aCwJ2dNB9iTFCbmKQppUM27lg/5uctZjsurQfV040xKBFPkfC1MOIzP5481Giz2q3vQY3mHOzbDeDgjxP0fwJT8dkCwx4exaK1k4b0RFnOB8tc0VX5/Hmeoe7ABwGvif8eNddN3ssR23zvo+H9X5IRRaRk1DWphFRgS2WKk7F9222gn+ni2OXXYKZSuUvNTHXxXcw38H8Bjahp65wUgNupp6HjO739uqzwguAzGcG9e4bc9yrFbNOSMlDXhT0xeKxJejCRGrTusq4AKtzZ10TAEOKid9ypaw2YG+spINzfdcSrJ7uwLCZBu0Ee0zQsUDZMtu48w0mJjw3t12eRoKRMCeQ5IxZPWMi0sUqI7JaZQjmL9GbyVewX2Gbuj03MgXE95qBbGGy4l5c+kaVq+ACgnapSbt9ThRE9BE9WAuwqNy7ytkWM+n8Y9dOftybWM/gdi7z6Qr8Tuf3Jd/8vALl9hSSrsweP+IHR+YKIo4jgO+Avs047mbo0AZUQNdRrt6tTeHG634NLP7Do0/8skyPsurAXz/65VsWFowGZDt0Q9EF8l1mSOUkIAcQB6rEUvL2Vx4HRWpVpPYJ+LUOdqP4j6WGxCfNGL1tUPzZ1xPY2LhDyIYA5b2AGUrSlpoFo4wsGbSHJJH7rEoxIzbJK5LisE9EnmhjP
 bP6CLjPt
 V+zymrAWew8gm2EgCYFJzihztG+H89jlpkXCOL+18ZPjPl0Ytk2HeKT04lr/ldNgSmI8M8NVvNJDEoe2PDr4gyAq6EWefu8sgc6uWuFCKb9TgxJrz02Lto06qoELDUxpDDYxQyVvN79/y4HRbWaQXz6eDuM+XrgdbLZVjEAhFN4uXaNbQYlihHJbQ+cjmwLB9ue7GL7WqdXctk9D1ouCaK2umJMO2hDzp7kpYeNzh1fwOjC4obOTqiiJyGTCyUaklCJb8xTWKvQbWqSlF3ToXSVQV/orJsBfG9U5KAk/xYuBx4kQtSvYCwTIT04f50+7VunUvdIHOv+FpML9hZpYdh5W9FEa5AY8OJvWKKUCtwbpA24SbsqEC/eMS9yunHRYpQ9nWczRXfddPkAVUhckztFLMhaNC8iGspzSV9FLQgRNPUCzjXuPNocRTV5a8Tv2O59i124uIPR3qI3mipEO6WzLmxzylalZykIlxLXxsroboPXLZbasM0mlx5ULQIFiao0YuB4N71vEhBJKx/j5EpYyhDrbtnhtkftKkLAR8Hs9JDW0TEVhk9UCxejVbiaYAaxfRgp9l6MPKnYKMxK4RPJ9v8ukbR4eg3N1OyZYRhS4/UYikIjz6NK6VKQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 10/31/26 5:39 PM, David Hildenbrand (Arm) wrote:
> From: Josef Bacik <josef@toxicpanda.com>
> 
> For a private mapping with userfaultfd, try_collapse_pte_mapped_thp()
> takes the PMD table lock before it maps the page table for the second time.
> If that (pte_offset_map_rw_nolock) fails, because the page table vanished
> in the meantime due to concurrent page table reclaim, it leaves through
> the abort label, where the PMD table lock is unlocked if it differs from
> PTE table lock.
> 
> In case the PMD table lock and the PTE table lock match, which is the
> case without CONFIG_SPLIT_PTE_PTLOCKS after pte_offset_map_rw_nolock()
> failed, we miss to unlock the PMD table.
> 
> To fix it, forget the PTE table lock when we unmap+unlock the PTE table.
> 
> Fix generated by an LLM and sent by Josef Bacik in private.
> 
> Fixes: 6375e95f381e ("mm: pgtable: reclaim empty PTE page in madvise(MADV_DONTNEED)")
> Cc: stable@vger.kernel.org
> Signed-off-by: Josef Bacik <josef@toxicpanda.com>
> [ david: move the ptl = NULL handling; rewrite description, drop wrong comments ]
> Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>
> Tested-by: Gregory Price (Meta) <gourry@gourry.net>
> Tested-by: Muhammad Usama Anjum <usama.anjum@arm.com>
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> ---

LGTM.
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>

