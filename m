Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DA72260A2603
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 14:18:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XUQVHCdI
Received: by kanga.kvack.org (Postfix)
	id D8D556B05BC; Thu, 29 Oct 2026 10:18:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D65026B05BD; Thu, 29 Oct 2026 10:18:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C545B6B05BE; Thu, 29 Oct 2026 10:18:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 8CE7A6B05BC
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 10:18:46 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 16732A0435
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 14:18:46 +0000 (UTC)
X-FDA: 85375869852.19.79F1EBD
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id 666F8120012
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 14:18:44 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XUQVHCdI;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793283524;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KrmJHHnmWU49kR3EjjGIqe7TD1rMMa5OKGo7QYF6nE0=;
	b=yIwOdueAkCgJ6plVmjejKDyj5O3c91bCMJFEiRgCJXPpm9SJk2iNlYWXQ3S0VfbH/TLLxD
	DUzOIOaM3qd+LFQuOlrgRLbMibBMDaPjpmJP9/5huGduj0ABGDlc+bEAtQkmcPtS3s1gK3
	ry3nAr2JXVEWo4X+6Dgz0rDvWz9lJe4=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XUQVHCdI;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793283524;
	b=amCoq19SwqbkulceccGvSDrqtPCk8tTQDocqISXqbCiarRw7v3e/j39LnfIzZ6M6kKlNUI
	R6JlwLfxeXRWv5b+GmiWtMCGmjgkPwXf6FVqP/ncHtklwBMx7OOURQfkBZTWbiikpA5QYn
	hCdnhN8p/J+cpuhnOlf7TbMS3z2mmuM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 9F9506022F;
	Thu, 29 Oct 2026 14:18:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37A8D1F01825;
	Thu, 29 Oct 2026 14:18:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793283523;
	bh=KrmJHHnmWU49kR3EjjGIqe7TD1rMMa5OKGo7QYF6nE0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=XUQVHCdIXfvmbaph/VA/rxWkBrBMpTWNrTAYGGhlCnhClgHcbmqfLm/eKiQyCpl+W
	 E3eYifg9BPWiMSDXEftsG6P1erQcEU1cxEqVv7Q65NLTq6sRGvicyug8evlSykwQ1n
	 N555FxgSSTArXb9eRt1k/+Rr7/gKg542EG3ZHgkCdrsxx5r9mVZUcQFcOovPpa8Tf+
	 K5DX1M/2E6C5yMjxDhwgcHRNE2N173N/c0Ut2AaVXgOtOHtG0XhsZlbs8t2w98oJlg
	 Mu1VOIE7670qxMrHyiu6QL0I/NiamJbSsCKr41PrvWSm0g6yo0ne75ilTxt7hUJyj/
	 vpESVobE2Pi8Q==
Message-ID: <7fab2115-6c44-43b1-b03b-8ce4a37ffe32@kernel.org>
Date: Thu, 29 Oct 2026 15:18:23 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 05/46] mm/truncate: look again if a folio left the mapping
To: Kiryl Shutsemau <kas@kernel.org>
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
 Usama Arif <usama.arif@linux.dev>, Matthew Brost <matthew.brost@intel.com>,
 John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>,
 Will Deacon <will@kernel.org>, "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>,
 Nick Piggin <npiggin@gmail.com>, Oscar Salvador <osalvador@suse.de>,
 Minchan Kim <minchan@kernel.org>, Muchun Song <muchun.song@linux.dev>,
 Xu Xin <xu.xin@linux.dev>, Chengming Zhou <chengming.zhou@linux.dev>,
 Chris Li <chrisl@kernel.org>, Kemeng Shi <shikemeng@huaweicloud.com>,
 Nhat Pham <nphamcs@gmail.com>, Youngjun Park <youngjun.park@lge.com>,
 Gregory Price <gourry@gourry.net>, Joshua Hahn <joshua.hahnjy@gmail.com>,
 Rakie Kim <rakie.kim@sk.com>, Ying Huang <ying.huang@linux.alibaba.com>,
 Jason Gunthorpe <jgg@ziepe.ca>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, kexec@lists.infradead.org,
 linux-fsdevel@vger.kernel.org, linux-arch@vger.kernel.org,
 linux-cxl@vger.kernel.org, stable@vger.kernel.org,
 Josef Bacik <josef@toxicpanda.com>
References: <20261027-fixes_core-v1-0-6f74bec9a5bb@kernel.org>
 <20261027-fixes_core-v1-5-6f74bec9a5bb@kernel.org>
 <auIniV8YSpA4_oxg@thinkstation>
 <2f2ef336-2186-4f20-b7f5-565e60471bda@kernel.org>
 <auMvYdTd_e9O9kDj@thinkstation>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <auMvYdTd_e9O9kDj@thinkstation>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 666F8120012
X-Stat-Signature: scea6sq6x7zzpgcsrasw5dfbubfphmf7
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793283524-614958
X-HE-Meta: U2FsdGVkX18c4KHYuJ3cA4riseSmZlrL0xnNO6g2sN1WEOgzTFMqWtc/jdh5Zf4HCXSTBFlb2LwYjMK7YAPptbFTmTNX1ncq6CWDMubfatj36hpTix+9c/wCEf2K3OSS0wDlCvWtE6c0FMEwFgL70v8ORU2SZJWQCz8r5d213e6UFn0WMMmLXj1NSAn612ZQztZsO8Z5XXfI6Ysjzmy0zPYAWbiWds372zX0TaVLVqRkr6TJQellWblOui1SR+mpQmyTxncWfqqTNrcetZUqt1lxGwIZM1wqM7g/guWGzdkoWsLbMGsJKkNxPXmQ9UPk1VtQlsr2joiliTWQg7fLUFdzmYiePP/UnF14UWYvFGnw/pUrTb/qRhOmKRMEjfxIGmCxsYsSVWY6lSbQw1eux5M5TEELd6bMwo4c67UMaNmn45aRzhPrychmFA0Jf+myZZgAfcMetqlPLBwnmEuVMW6LXKg1X6zPniHANoh5p6QDrqmDcX+9//a/fdH0d0SimKP5TkO1m1eTHswkiCQFpuiCJZHcrcU2XU1p8Sbf8ULolkDZtHZcogukwsG90iwUHFUvqRjWf5cmtigOjid/QtFW+oNn3ZI1eVOrVkPO3k7P6gbHMAosJVFl/0HSS0oEjf+W2vjU/W3uawU15pzlhx4BM1DNbPDFuH2wg+mLZd7p7wH8y0btWzSqZJbGgtISaV0ai9OenhTPZfVVXy7GTfLyDT5+K+PfT1rz1d1EqopwoSwB6wU3FmLvAF4lx5IuAq1pkm5jdagWXOciqCXo16p0f1pV4WxMNd+tO3ULOXrxygiLLtGxir1dnS1ntJ3btZ38dzVs7XXGyCepjRmOaunDmDrtf40QLezUtHCGj7yWGbMtN1PUy36pWTRRRccb5tDQZqpKFCkMmsWLVE3hVv0GsF03/2HM5WeAIzbk+wArLvYfOTnRf2KOW0tI1+v0wcj10Q38Cq+ow/31vqz
 MvALH8MI
 AUpdybM2jQHVDlCqhhbWbEOI1rhSAC8lHQfyBOx9PP6HUMkHJgKsedBNft2t7lua69LZ4wZeVdxuITONKbz25Uk7ZQcB/53Az75wA/g4LLoBSD6Hd55QpbsGyh92af8ajYWXU1BYLMFQbaXMH63vZ3iuimOfb9GMf/wLe7qTWQkGJ91pb7PjL2O6OOtjyymnHY8ZPoreZAxh98dZr82LbDbcXIHC6JFge7g4JlHtAJo3iRNEjSFwkLynsiSTfJdJ4rMFMNAWJQRiZIj010DE/3DZrBVhW8fkGcv76FfVx6rswyWq9HkACVDmnChiN9YzkZ4Vr0VBKp85vg7NZROQD7ZyTaOjI/Q8MmM4vnyXJejF0p0s=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 10/29/26 12:37, Kiryl Shutsemau wrote:
> On Wed, Oct 28, 2026 at 10:45:34PM +0100, David Hildenbrand (Arm) wrote:
>> My brain hurts, does the above make sense?
> 
> Yes, I missed that the loop only goes back to start when a lookup
> comes back empty below end. When the last batch reaches end, it exits
> without another look. It doesn't need the split either: any punch hole
> whose last page is in the page cache gets there.
> 
> That exit looks unintended to me. b9a8a4195c7d ("truncate,shmem: Handle
> truncates that split large folios") turned the "if (start >= end) goto
> out" early exit into the loop condition. Before it, the loop went back
> to start until a lookup from start found nothing; Hugh kept that on
> purpose for hole punch in 792ceaefe621 ("mm/fs: fix pessimization in
> hole-punching pagecache").
> 
> Restoring it is enough, and makes the "restart to make sure all gone"
> comment true again:
> 
> +       if (start >= end)
> +               return;
> +
>         index = start;
> -       while (index < end) {
> +       for (;;) {
> 
> Then a replaced folio is found on the next round, and truncate needs no
> special case for it.
> 

But that's then another lookup even if not really required?

Why do you thing that is that better?

I agree that the code is simpler, but at least it's consistent with the other
handling.

-- 
Cheers,

David

