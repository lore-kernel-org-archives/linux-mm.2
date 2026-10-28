Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6E8B8606A32D
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 08:08:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dZ686wUN
Received: by kanga.kvack.org (Postfix)
	id 81D3C6B05B5; Wed, 28 Oct 2026 04:08:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7F3BA6B05B6; Wed, 28 Oct 2026 04:08:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6E3AC6B05B7; Wed, 28 Oct 2026 04:08:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 47F6E6B05B5
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 04:08:26 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A861C1A0BF7
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 08:08:25 +0000 (UTC)
X-FDA: 85371307770.29.D0CA746
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id E3B8F180005
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 08:08:23 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dZ686wUN;
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793174904;
	b=Dmta1pZP7g8E04LrTOsSR1oNOdStDnq17xbAjwqq52IkSLDmbNbU+2atsBJdQTCbpcw8WF
	WClCvaqNPOJ1nQOSsPVoWJkplMxQUKw1A2VJIWdPxIr+A+cDX1X1/N7PZ1LFrs6rkPFRoG
	O6n6GLosJG1dhc21Fzc+u0Xy38W73lM=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dZ686wUN;
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793174904;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YMhIQCmPp2kb7swtobccIXYat54/CLD8sSk/wH59+ic=;
	b=N7G6kEzS0BrjoW416YpEClTQNHdSX2GYx7rdU+RQPR/yiKkExdzvTExb2YSDqFzszC/FzK
	Ofq+2kShp+ntArpG5sdQK9m+R4Ih5GRRZ3Mk/m/UynVQyuy5qQC7kisAKs1urclvDhU03q
	iDIx0MtLEXiTarvolklJI+3cDIHB7n0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C784C43047;
	Wed, 28 Oct 2026 08:08:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34A6A1F01825;
	Wed, 28 Oct 2026 08:08:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793174902;
	bh=YMhIQCmPp2kb7swtobccIXYat54/CLD8sSk/wH59+ic=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=dZ686wUNZbeecaUUWhZqyDq+oCgkRoB4kXRKTaERp4XUiBer361hBYqWjPHFR+M1F
	 9WmGi/Rexa0QNinbE+89muvmYBicfuIj8K6BQyKOXON1Z/yJ9rHvknTBFjZqoQajDD
	 YtiL5Md9P+qPqzqquZO8ghitcvonnnx14OGMNUYh/49Y9Mmu37+z3GYNVoOjoy9Dcu
	 W3Td4vVeq4N4cnYDJ51H1XGG589ESoqxem7USKOTKvn3jc4P42kCq6J1SWKfEhu6xe
	 /NM90F0ua/vaf9NYyBwgiunmcNPylFsU43oJGbRHrjJdWitClABpXe+oQVU4j0qO6Q
	 weAHsNtGpH+fQ==
Message-ID: <f5b90920-5923-45a6-be2b-f558801781c5@kernel.org>
Date: Wed, 28 Oct 2026 09:08:04 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 09/46] mm/rmap: handle device-exclusive entries in
 folio_referenced_one()
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
 stable@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>
References: <20261027-fixes_core-v1-0-6f74bec9a5bb@kernel.org>
 <20261027-fixes_core-v1-9-6f74bec9a5bb@kernel.org>
 <e32a19c4-76c4-40ba-83a4-781333af7b0a@arm.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <e32a19c4-76c4-40ba-83a4-781333af7b0a@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: E3B8F180005
X-Stat-Signature: iwcgrduc9y3guz5k8ei79qc5ysk8sghc
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1793174903-783134
X-HE-Meta: U2FsdGVkX1+fDqnbFzIlK2XkMzkjnwzrTzaP1zd+jVbKY5cE1JSEsNtTOTE+OGdcbBMuStJV10nFsbw4D8aHOM9HfTZO8KxT4KgFkZQi46Bd/d0EemlsWzs46nW3AfOi5xQKg0qjhxfPf6UrxEPcLVzo7rizPXg7EzyZgtpzuB+AFn+goj/jzolRNWIGSvMuO3VRKTNjBDbiRmoF4Z3bzVmqbzSwVQRp2hGEpEGdmjZRhr11SDYF1+3zMDq5K5onLadqUHLAu/1SdAiAb8qjfERxtnzi3rmXSFaZgPKhuFgZVBMLjo6Jb60+eLXhkmhXFg3UcjWIJZAEvgOHqGZlmj3ecPxwcLLcTUIylVcttQ/UeF0sYRS76XMNamyd6txJme5/6Y4+yH6mury/oB8zS5uR3lAOC2eLds64VF7i7o8F23KyWwSC3kOB0eUAAZgZAP0YGEMI4TGcSBS1Q+iZMC/7+5oSDBipzLgxx3U0LMwx2YXRTq8imuCN8IMiCu6ZHxS/e+8I+LraklmBzOU5bKI03cSyZXK+hW7T5tE8uJC86KW89Q4iysBH3v7PkQpXm5APZbY8cB70VuMMgKFO5rG8mPjuxKpVHzqMy8/80Ku4LWfNiwglavQlIU+VpwIXBSUQlJCHsoKRoEtgdtit9bjPXljELYZEueZvjT6xdUrELfXaXERbqHiDJb8JnV+AerL6b0IYX1BHkNAl7i9jyzBw+oy+zAYDnYx2zal1+DZVTiwwFrlOBAmkD0402EvwesOXL/yPUCnZkGH9znLE8JrlE7jIXJWWS/d+DtNpIhsdew0kSqLqZJw/i6/ZPHJtrvG7oxorelKA2z3h3LdIKJrOHlRp0q96Bkha/1ddnbxPb/DKdRCRgKrDleH3rmpULbzLUUyWRGDguf/lNcczfJtBjXHJTsiRjIpbZ60c2ygfO64H4nPZ9L8j4FxRvYgh+RMC3nO2Ju308NJD57Q
 obP1M7FI
 IdDQvvkuc7pZlXexfvnHJx3t3+obAq35GcQ2SCmqazIgw0fTNMiy+yYqdWNOgNIGZ2JYTggqMSfHnjvy50izXEBJnxAs69W7DEJz4O9PTsb30L6wkoMoRlWScUf/WTm4nrHZhBsVD16JhcLfXllJUQkYqgDTYhb88RSotH/7k/Hmv33Ur47AN2+0scqoPzvJ+jtvIxUcg5deap0UExuC23g3ReOd1p9zO6kfU+L+2aOcCW3BXVFhMz3aV3fA4V1zoX+zXRI2jbrJqh121lSq7RQYirrfBqfdQPeS8sPi3RnWnYWrLQKZzKKqqqMZDpv8rcvO9mrvDdUcN97XFeo8mKfJYe1LWkr4mZA2V9J8PmEWAuofQ960FGsH2ILOnEgmY49bp
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

>> -		if (lru_gen_enabled() && !lru_gen_switching() && pvmw.pte) {
>> +		if (lru_gen_enabled() && !lru_gen_switching() && pvmw.pte &&
>> +		    pte_present(pteval)) {
>>  			if (lru_gen_look_around(&pvmw, nr))
>>  				referenced++;
>>  		} else if (pvmw.pte) {
>> -			if (clear_flush_young_ptes_notify(vma, address, pvmw.pte, nr))
>> +			bool young = false;
>> +
>> +			/*
>> +			 * PFN swap PTEs, such as device-exclusive ones, that
> 
> You mean "PFN softleaf PTEs"? Better expressed as "softleaf PTEs embedding a PFN" ...

Lorenzo raised this off-list as well; I'm using the existing text we use
elsewhere for consistency.

This needs a cleanup that adjusts all of them :)

Thanks!

-- 
Cheers,

David

