Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 88998606A329
	for <linux-mm@archiver.kernel.org>; Fri, 30 Oct 2026 11:11:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ewkqjIeb
Received: by kanga.kvack.org (Postfix)
	id 906F86B05B1; Fri, 30 Oct 2026 07:11:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8B7A76B05B6; Fri, 30 Oct 2026 07:11:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7A66F6B05B9; Fri, 30 Oct 2026 07:11:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4A8C56B05B1
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 07:11:09 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 217E11204DB
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 11:11:08 +0000 (UTC)
X-FDA: 85379025816.26.B6E3FD9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 5171A40003
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 11:11:06 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ewkqjIeb;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793358666;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=e5NnHqFGh2WLk8KpW0BJvN7IH3ve0Yj4mZZ8fp9OtsI=;
	b=BV4CPdLgHHUNOREaGcX2ddk4teMf0ZtEABBwHt3VeBVz+62CWvFYcVjYbASLa3MxsTZNrA
	raqWYg9bV1yS6gdPVJHh5DMhwBV7evVXcJ2uv5dpoqrCQ/lpe1+oxXHc2+pnUZGIPiyBLl
	hitpgPKrhxCLq8p6SAKWPROkUe35FS8=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ewkqjIeb;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793358666;
	b=5WM/aj+WS7YYwOvVFNr30BukS/hmCCICo7bSTBgap23ucKoqXwCb7lMXtrhvdXp7crV2Zt
	SjeNCIQt+6q+o+ZdODbrbw6tV9DWdUXHqHlyKLq4hZ5pRW7HnPmN7C5WUeOPaw1mfz6bAa
	sUJ9bquliKMGFuiAgnRxXClzahMOIt8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8DA5843989;
	Fri, 30 Oct 2026 11:11:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22FC11F000C1;
	Fri, 30 Oct 2026 11:10:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793358665;
	bh=e5NnHqFGh2WLk8KpW0BJvN7IH3ve0Yj4mZZ8fp9OtsI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=ewkqjIebBvhym6IB3Ksl7IZW4E3WWrG+/4yOGfUUwfsfHMqgAdiGfPsLito4NMzH+
	 3X5GTmTwRVzbBuN0IMwDqw+qwS5ZG1TkZy22Bl6SI2a2ruWcosBrFpeUBZwQ1+X86r
	 2XsLssw2rnRioIhlsH3cexrza2qXr4bBiLO7ocs8u3A+E/DxolzLiaKG/WTEJdrZmV
	 j3bSQu7F+PpI5upb84fHqRT4ETg6Pm/arVNg449Goy2wT41T8MsfIsurdfVxOe8Qwv
	 dw++8VuLquwqT4MD8BXS6SL+v+RwX048NJm6rMxUecQ/wWmEsk2BQT0mxJGwf0odE4
	 9x6mq7eusSUaw==
Message-ID: <ef51420b-0260-454f-b08b-f4e5a3da6e20@kernel.org>
Date: Fri, 30 Oct 2026 12:10:47 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 14/47] mm/huge_memory: fix zapping migration entries
 for device-private THPs
To: "Gregory Price (Meta)" <gourry@gourry.net>
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
 linux-cxl@vger.kernel.org, Chris Mason <mason@kernel.org>,
 stable@vger.kernel.org
References: <20261029-fixes_core-v2-0-a64ce7f83abb@kernel.org>
 <20261029-fixes_core-v2-14-a64ce7f83abb@kernel.org>
 <179331304801.2127828.6570375349219520262.b4-reply@b4>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <179331304801.2127828.6570375349219520262.b4-reply@b4>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 5171A40003
X-Rspam-User: 
X-Stat-Signature: wof3sr88mhpz6enbg5ktzhfus8csf4og
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1793358666-445541
X-HE-Meta: U2FsdGVkX1/RCbAQeOnQsKg80vNzS0X5FK9b6zoTNWl09QnvzpcxDOUdxfpaju548cGOEiyluMellSsUkwaERlp4i5Itqtif4qSrYw7BZfQQY4E/rpPjCZsed3kgqqBr7uGvSM4GT9PbWQ76MqTrZyRQWvR6NZ7a9JvqRrolq1JvOUD9XThQyUOsYWs41Cmqi0rB+HXj5SEmqb9DjR24INdo50NwQOQ2Eq2S+5l5QiXVHQA6hE+f6gqlqv1UTByIaopR4pcR1+FyGKwC2zyV07abSApoP3lzufLyRrB0GrTzLqnoxzn7XbNCuebuxm9IFiaGOT9pBNLHarYSrv0GmPCT6QqawcAiRBymaHdRuZwRvz8rhRXJxJ4FjVxJ+8ZIS68bZYcr9RpMvnqpRF8d/Eot+UCjB9X0FeGaXMmSosHFwPTHMV97x2P20ViQAk9Nh10aF9dRpRI0zJ6uWpnsQlZssKITj0RBSL7cX+qih4xoCqg8xfUjCxSKlRY1H2LnD7oc/FBIiKwig0mpRDHvA0a+xk4Rjo/TO09RHl+zQulba6jfFot4SUuonh8A9iAt8NlwGxezKS8CTWVFsNuevgrhATmaIQtcFOS5s+6DQEnFvQ/GT1SKyLgKOoofpetV44ZTDXQ2cVmvvAdmSht98tUbqsK7sgCG6AMvfav+rR/vMos+6zxMlGb1W8BLxqBY46AgLDiW0CLtah/S73hc/Vh7pUEXrp5Pbfxafr+JFcsXKwIvbkdTO2736teyzpWvpL3LM0vHJexssba6TiQnFh7s10eA91aG3eCbYWpTZYAeoVd/Ds0vGOxOOi5isjrELg4bqBtUOKnpLgFQR4BQTx9C7qCiEN76gw2UVcw96d/o578ZK3PUHI3LJTxwo+mWLlu507FEekRGX8pVRK38l6zim/4hX8g9ecd+0mAl5K+oon7eJG/T2/6GJY1h6GBVTvCI7+XpH+sYDhxruRT
 lFn+WLnr
 ZwcYB1qCZrYuDTex6ecqwGu/7B1bOUQucRYkXCHt73oQgWgYOTKWik7kjtawDq0sqd5wCUtdSr+Gy4dtMbCeR0FWW+YrP8fG1hYk0S+HUiI7E6u/OsYRoGpavGEcCo0pWaZB7pET+hrew2cZTReg84Ta5AakB74mBCUYmaxeAf6EF2K2b1/Zca6eoxhEw7JdxrH8/PCvYLC2b2sVix4/CH8qpRYXIseqpH/2xk7E5fN2qUSNroBhGCxkEqjpQBMYUDru8z8QjbHyhK2de17nNq7t1iXEB4exQc7qxhmlII4EhTQUJBIbMNkOATNB7ria5gX6dIYIGN+NmuSE+2huzRdbrHhczGA9SZ4UM/qhhIuDMokM9sflAx1YQgdUKHcxz3JTDuNCyyAzLJCoIrFgkYLhx0hI0PtLNZAyFRcEMqcLDjXOQZYSW5YzZ7SBwB/c5Xy+TvikvZPlSjFkNxOuv+s5Ttw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 10/29/26 23:30, Gregory Price (Meta) wrote:
> On 2026-10-29 21:33 +0100, David Hildenbrand (Arm) wrote:
>> From: Chris Mason <mason@kernel.org>
>>
>> A PMD migration entry can refer to a device-private folio.
>> zap_huge_pmd_folio() checks the folio type instead of the entry type,
>> so it treats such a migration entry as a device-private entry.
>>
>> Installing the migration entry already removed the reverse mapping and
>> dropped the mapping reference. Zapping it must not repeat those
>> operations. Concurrent MADV_DONTNEED during migration back to system
>> memory can trigger this.
>>
>> Check the PMD entry type using pmd_is_device_private_entry().
>>
>> Fix generated by an LLM and sent by Chris Mason in private.
>>
>> Fixes: 368076f52ebe ("mm/huge_memory: add device-private THP support to PMD operations")
>> Cc: stable@vger.kernel.org
>> Signed-off-by: Chris Mason <mason@kernel.org>
>> [ david: simplify description ]
>> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> 
> One note below, but it's not a holdup.
> 
> Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>
> 
>> +	const bool is_device_private = !is_present && pmd_is_device_private_entry(pmdval);
> 
> pmd_is_device_private_entry() already returns false for a present
> pmdval - so !is_present is redundant.  If there was a reason to open
> code this, then keep it, but otherwise you could drop it.

Ah, softleaf_from_pmd() takes care of that. Yes, let me drop the is_present check.

(I'll double check that both are guaranteed to be consistent; but otherwise we
might have a bug already)

-- 
Cheers,

David

