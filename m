Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A1F1E606A31D
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 19:25:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mHRKmN4W
Received: by kanga.kvack.org (Postfix)
	id 8C4586B08BC; Tue, 27 Oct 2026 15:25:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 89CCE6B08C0; Tue, 27 Oct 2026 15:25:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6A1456B08BF; Tue, 27 Oct 2026 15:25:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 322946B08BC
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 15:25:41 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id AEC78C0AAE
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 19:25:40 +0000 (UTC)
X-FDA: 85369385640.04.DB0F3AC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id E6D0D1C000E
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 19:25:38 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mHRKmN4W;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793129138;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9KEB8qgzoIeFNOGcSLHLXb2uottvsKzkUwf/j7rEZPA=;
	b=wA1wYTavUMAWQEyV7rr1ciF6OdtGSTnmFMpdwmS4uAwrsoFxXsEWDSOn4oTl00edvzufQK
	9DFv8fdIX9/dd6ItO7pJ4KJ7yG1ho8Q2++sIEo69XLQwDc6/8Ilyw2R52Y7JO/1daJjFtO
	JCK44yvYEnZ/hsNLrya4Ot5DpkZGILI=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mHRKmN4W;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793129138;
	b=W6/wp4Z4jW1b/qoolrfX9rQhX0ZVp7j0TFlOznTzcE1iusvmBC5LzIJhXCTlB2xh0WHl9u
	yK0Hpd935ie6RSsWh2bwFNBfXj+o8nJE6/fucuQ2pFV3LE69A9Tsn/9rjqb2inxgI4xIg7
	amRtJMBGrocWKpPyfmNPmcsW8eDFA+k=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 4F209601FA;
	Tue, 27 Oct 2026 19:25:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7550B1F01825;
	Tue, 27 Oct 2026 19:25:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793129138;
	bh=9KEB8qgzoIeFNOGcSLHLXb2uottvsKzkUwf/j7rEZPA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=mHRKmN4WFGzQCMXXXAobAssayAt6MJNEX4XFML8kScSLR0RWj5iHQU4HOkyVdbrZ1
	 FAfkNQPNnukyYwievxpTrmJxM+E+k2Z82hK7ve6KZYqVtg7FqawBBiMhHOxJxjEa2p
	 bYzJkytrLPqqJ7CYJwvxS2bJELBhxTcauV4K9skmwI9vhz22V6zo1hQGN2pFq2jDUl
	 M7zoVMj2QRdGuUHWMrC7ZKykJhi9OVby5oo7z14LhbLEi2LRbLMRkqAZMODrWoiBbH
	 30E/CpCuG78KvyVtCKRteVs6ztPzOyHgprRt7kzAGfAfwY3zw6sGBJP1Q4vQ9OAjhg
	 ELl7I7hL0bT0w==
Message-ID: <2f436ecf-70fa-42f7-a0e2-8a27d179d1b2@kernel.org>
Date: Tue, 27 Oct 2026 20:25:19 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 26/46] mm/mmu_gather: fix flushing ranges with 4 GiB or
 larger
To: Dev Jain <dev.jain@arm.com>, Andrew Morton <akpm@linux-foundation.org>,
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
 Pedro Falcato <pfalcato@suse.de>, Hugh Dickins <hughd@google.com>,
 Pasha Tatashin <pasha.tatashin@soleen.com>,
 Pratyush Yadav <pratyush@kernel.org>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>,
 Zi Yan <ziy@nvidia.com>, Lance Yang <lance.yang@linux.dev>,
 Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>,
 Alistair Popple <apopple@nvidia.com>, Nico Pache <nico.pache@linux.dev>,
 Ryan Roberts <ryan.roberts@arm.com>, Usama Arif <usama.arif@linux.dev>,
 Kiryl Shutsemau <kas@kernel.org>, Matthew Brost <matthew.brost@intel.com>,
 John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>,
 Will Deacon <will@kernel.org>, "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>,
 Nick Piggin <npiggin@gmail.com>, Oscar Salvador <osalvador@suse.de>,
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
 Josef Bacik <josef@toxicpanda.com>, stable@vger.kernel.org
References: <20261027-fixes_core-v1-0-6f74bec9a5bb@kernel.org>
 <20261027-fixes_core-v1-26-6f74bec9a5bb@kernel.org>
 <21091d4e-0afb-4b5b-84ac-b36bac58e40f@arm.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <21091d4e-0afb-4b5b-84ac-b36bac58e40f@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: E6D0D1C000E
X-Stat-Signature: jbd1t4cr61xsyyx8j66g43g9zafwmyzy
X-Spam-Status: No, score=-7.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1793129138-995089
X-HE-Meta: U2FsdGVkX1/657ZPaqS0ABR+TY81HOV89Xc2nnX9kWhY0IVQbFtxLSTO1O0FmjuXnTVmIun4uHDpJabTK7IKTHSN2eecJD1vPsyCdFuYogHj0Fi5rJlJvM51YiOM7pC2mJuWYoSLERsxJCpRb/aQCbFSQ1kGfDQ1Qz+MWIfRwewZaNjFuCbs52nvMsT9ukf/jHe1XSo1Np2XoK+8sfzttmhSVyNtG3OFpoOvdgdrxGOgW6KR/mwX5pV0MsYlKpNCMKXy1dAsmyIsvpDOrRwZLlK/Pcj/WM4l9JS/gp+OLpwp80CVByxCyyB05NPlOrqhtYKe/EQsFv2HpaRsa9EweAOf8zGeoeAOxhYScnhAK5Ea2NSWD17vJsr8tUXRpQM2dHuGg8ZimKJdOMqyT7kIMBLn8ca5ed5fo3BKtcVDJx7WnjaRK1cHpc+iE/QywQiVPz3ZhTTH7x81dgwq6cuEcjC7zRbRDYaWmLcU0BXDV26nIJY0ws8NhUhLx7x6eAoP8ojUVGz3q6ySNdWIK/JQN8p9UYUQzF6gFVvlRp7XqO5LhU6PIVirL8govRLFgN5sP99lMGz2hPSjOweYGsBkUh0o5HGkF3RIhhlRcDy+nfM5G//GXUz6ZWGoJfyk4KLk8fvobSIA6NyuLR2TDD9BZyrqnptLp2xJfdiwZtVkc2UAcxpfy1I83K9W/AJ9wy2ObHetOGQGh+jAw/qkMRncFYH7Ga40rtyMJ+700NMe9LP4ya2PwTxPYCJW7Utco2+rS+n1EAoVY4aa0GMgCd6bWBj8l5ZdJsPrgSpeDkDFJpW76RijWjYjDYOPAdLY20KU9YadsMnIqmHVzDGcMtSSRz9UaNj60nkUDRKwNiXfTucnt81xM1WloI/0FHAt0LwhnhturFNL6O/XJ66Ti9gfsrUn9QqZkIrB42V7aAkAVp9Wa0WhEsySzQjNZZBVOsXJ4aT73SQe9TxhcIRWu+s
 uYf3ttsh
 /6oFHg6Wa67+EgoqV6nMHOrmeEdSajTXsyyRg+yM7pFwfxps2GyCBq9kmtO70a6YaVH3KLbFguqYcMdY1P5sI+v8uoX4O0lXDzK6xAW6+/swEnyqORd1Qo4/Pbi/CcZUHke6Cqci6Q9u+VQi8g54xm6Eu0To8kt6PsnNeDX8+IbYp+/AszZ/sn8BtYkVLVWormiWz0JyQKjgZVwaDH/Qrwj7rOSL/1pfsCMLrHZU3tTSnc704UBArodWwxkjhaRQHm5l1d5s0Ip2s/oOADL2FB3gHQrJDvAWDNLVN0Ak5orAgrcdJmb/tzBUpE7rbUpUpneVUU5mS4iYyDEnY4OklBdym6suYKG1s85pS/cwlMweq6zmm0Ar1PBSyx1Uxg68cUF3frTJic22Ev2pGX/SAYudskgTW204iHm2xQIE9zpkx51LANgTJ3R7deg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 10/27/26 08:35, Dev Jain wrote:
> 
> 
> On 27/10/26 4:47 am, David Hildenbrand (Arm) wrote:
>> From: Josef Bacik <josef@toxicpanda.com>
>>
>> __tlb_adjust_range() takes the size of the range which has to be flushed
>> as an unsigned int. Its callers, tlb_flush_{pte,pmd,pud,p4d}_range(), get
>> and pass an unsigned long. Consequently, a range that is 4 GiB or larger
>> gets truncated, possibly to 0.
>>
>> On arm64 with hugetlb, a 64k kernel can flush 16 GiB hugetlb PMDs, and a
> 
> Nit: this wasn't obvious to me. Better expressed as:
> "a 64K kernel can have 16 GiB hugepage mapped contiguously at the PMD level"
> 
> 
>> 16k kernel can flush 64 GiB PUDs through tlb_unshare_pmd_ptdesc(). So
>> at least these two scenarios are affected.
>>
>> Fix it by flushing the proper range instead of the truncated one.
> 
> Nit: after reading this I thought you are passing some other parameter now.
> But that is just a type change.

I fixed both up, thanks!

-- 
Cheers,

David

