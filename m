Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0A31E606A31E
	for <linux-mm@archiver.kernel.org>; Thu, 26 Nov 2026 02:19:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=Pwlc86FF
Received: by kanga.kvack.org (Postfix)
	id 315B26B05B0; Wed, 25 Nov 2026 21:19:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2ED3B6B05B1; Wed, 25 Nov 2026 21:19:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 229B66B05B2; Wed, 25 Nov 2026 21:19:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id EE0A56B05B0
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 21:19:01 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 60A4F120258
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 02:19:01 +0000 (UTC)
X-FDA: 85475662482.22.3EF6239
Received: from mta1.migadu.com (out-140.mta1.migadu.com [95.215.58.140])
	by imf13.hostedemail.com (Postfix) with ESMTP id 339D920004
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 02:18:58 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Pwlc86FF;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf13.hostedemail.com: domain of ridong.chen@linux.dev designates 95.215.58.140 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795659539;
	b=2efJeIDF6xxKSAwqXF++K9QwfMLvaUBng1dPIBCqlEDguvPN1yRMTfqcysMf0QwlWm7pCk
	Sx2zKFNWoHwywuz8wzBa4yUQE9rT5G2PFMJfB2vSMaIhZQb8lPJ7fuPxsNAn/U2iijJifC
	pnk4cLJnwrAMVUTVjPPtY+HYw3bLcSs=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795659539;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6STSsHaJ1JM4lliafBNz4jm4dTWlP/gXXNHzo2c3fcE=;
	b=Ve12XlIALTeQzXUVyRt0Qi7T57vBcrpbsYT6XP6o7QOXcdyeVaEWvBT8ZSbJwwLz46Aifz
	fq1/mZgBPwrkfVGqJZOZPn+uMGCxMqFcdU+jPfglTyP95iqYIF/NuhanHVMiGwnL0VyENe
	GoHLsFG9t0rXzqasJb9nG+xNresIdUM=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Pwlc86FF;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf13.hostedemail.com: domain of ridong.chen@linux.dev designates 95.215.58.140 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=Uj+KAPIjbrW6i+MVum7pLdMAOpwX3+lRSs2xlDHzCfY=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795659537; v=1; x=1796264337;
 b=Pwlc86FF6ZzaywQkAoOkq4r16qaH7XCCCis7MVpfdOXwjLwW7X9b9HuB3X2UeSwrgAFdHZ37
 cm5GNFMzm8aOT51WslpJqP5FA9TQYodyoiairragW93hzNcXjdxMijTrCl84qmcjztW9/LDPqDE
 6ShqVUIh1pGax4U7ricVMNXU=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id e92e7e11acb95b29;
	Thu, 26 Nov 2026 02:18:57 +0000
X-Mizu-Trace-ID: e92e7e11acb95b29
X-Migadu-Flow: FLOW_OUT
Message-ID: <635682b8-6e6b-4f0f-a3aa-48c458960b19@linux.dev>
Date: Thu, 26 Nov 2026 10:18:48 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 2/2] mm/mglru: deactivate anon folios into the oldest
 generation
To: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, Kairui Song <kasong@tencent.com>,
 Johannes Weiner <hannes@cmpxchg.org>, "Liam R. Howlett"
 <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>,
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, Baoquan He <baoquan.he@linux.dev>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, Yu Zhao <yuzhao@google.com>,
 linux-mm@kvack.org, Ridong Chen <chenridong@xiaomi.com>
References: <20261125094056.3973331-1-ridong.chen@linux.dev>
 <20261125094056.3973331-3-ridong.chen@linux.dev>
 <CAGsJ_4wScDHmPin2H+Va7SFZ1zwa4XcYMghkreMMyO+RK5W4gw@mail.gmail.com>
From: Ridong Chen <ridong.chen@linux.dev>
In-Reply-To: <CAGsJ_4wScDHmPin2H+Va7SFZ1zwa4XcYMghkreMMyO+RK5W4gw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspam-User:
X-Stat-Signature: h4ypbitm1p6hxkqra88jxhz9asu5cd9h
X-Rspamd-Queue-Id: 339D920004
X-Rspamd-Server: rspam10
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-HE-Tag: 1795659538-819485
X-HE-Meta: U2FsdGVkX19ptjqM6Uh6H6YDFv8dZ1qqSdCTwgzdjQ0Mdv5mgX+ibUqimc79VNIZ9Jx8pFJWGlbg/V8k5ShziSbS2r7Zj4DLdI2afLAXxwqvVV/vS50Mkw2xSI32m0BvLExFYgRR1eiUBr8I1l653sxqQWLKVphEflklFR3uFXhzcofD76cKxmh/wn5hYEHiSZCyIGjxO6nVHWASq/3mw/TBrnnljKJmqhqVXF90IsW7KjTDldWtdESjLalrGyCgqAkpB5teL3eUMueaoF0aI9MjWMn3FljvlOvlXpgoAw/V5jq7J2G9AWaVF5ohyP7OVx/xpAbAHM0Mol26AVvOqfQvjA0iVCcn43l375hnB61DPN8GJqCssrdkWlPsQevvmaBvPLP89CKIBPo0RPWMNAn8PxFnoruuSRD37vMl1LyPgnd0/48enV4Ybxsf+TNGYfeAH3CVq+xZbMhWcb0CXFYHPnwlegLSOc2BlNAQ1ezh61fLCgfXlWoXpNQ5INN1CU5SsbTVKi+Apqnme5XUKL1VW4iGUGGIvR+CqVKlQOca0yU0X+yTmoK2TQpfhOfAX651AjFDv2NSlhfp0hLtt6eBL+IkshdrRG2WHsqPtL1CDFm/0G8XFyv+JZowbS+IZhYqJYelveNhe1NeudPQGBzoOFHGsWe8zWUKXSfu4E4wZIqYU3doBWSm1KABUShZBng2ClFXGItXtE3wLdo25gmbJuJNSJXO7zY8ijy3f+reyH8V89DdG+BPW2T/mf8WrCz6b+U5MTJUzNhovOHsY0gz04T29xKhs0BonD80/fBBvDGRv51wwRJbXbMLjLaMds/SMPCBRp7u/5hGN5XYWch9EE0qV67AIlg5cqCkqNeX+vShVBPrOQT5rdygUCpkHe5Lx7uAqC1OtY1vQza7+cuwfhrtB/SooQPgE4FrN7FtFBXDMit/B+/aa0EaDAbyIGP+HDGVhfTOmlu1n25
 tGCNd7JG
 kOBefDrG8ud75oaLQSoJbDnmpIOrhVya1ga3NWVZNEL0P7oWB3LZrEiuntokOmp+ZdwiibUe12ToI2Lyq7nK/2JWyRufQzpnRopwAN+LNoGqDFDg8lGTXLFRdiPQqXnVbJZqIjNWBqW+/eMNCYOfdcCI4nQtBSH/E0dRP3IA9WbjVVu8xT0EASijaSlDtfSmH4GNlcswaHjIA98B+ObyTpaH27KmSJ7J/9kiqY7vZhhqTiXznR5BqpdpAYoYmG0QVL49dXy/zX0G0tncksNyrGGXPJb4cNuLPkIiCg0+Hj2MxHrj7+6yDnVVERk/EQ7OVO1a1tVGfq4OlrRnA57Mj3sTvda/bxibGX5Gn3gpQxldSXt5oZ3x63SFllceyhf9NzgmuyT57xEF+8nd42qeXsUS+NFNFabaD7i7/6bFMMHc99sjkCnCO6sez/A6+19OGnemri8yrsg83+4tZunFe2Vp3je+Lqtq18B+yBDQHWGyaRZVeY9bMGyl2z1ia9dkAdzO+7HlhGHnfE01jm25ZGEGy8PuqAGt/kdJNlstyjerGgnyHwXrBgTNPqA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 11/26/2026 8:02 AM, Barry Song wrote:
> On Wed, Nov 25, 2026 at 5:41 PM Ridong Chen <ridong.chen@linux.dev> wrote:
>>
>> From: Ridong Chen <chenridong@xiaomi.com>
>>
>> folio_deactivate() is used by MADV_COLD and DAMOS_LRU_DEPRIO to move a
>> folio towards eviction. lru_deactivate() does that by deleting the folio
>> from its LRU list, clearing PG_active and PG_referenced, and adding it
>> back with lruvec_add_folio().
>>
>> With MGLRU, lru_gen_folio_seq() places a swap-backed folio that is not
>> in the swap cache, i.e. an anon or shmem folio, into max_seq - 1,
>> regardless of its refs. So a folio that has aged into an older
>> generation, e.g. min_seq + 1, is moved to a younger generation instead,
>> while PGDEACTIVATE is still counted. Other folios are placed into the
>> oldest generation with their refs cleared, except the ones that have
>> PG_reclaim set and are dirty or under writeback, which also go to
>> max_seq - 1.
>>
>> As a result, MADV_COLD can make anon memory less likely to be reclaimed.
>> It can be reproduced with a single process in a memcg with swap enabled:
>>
>>    1) map two 64MB anon regions A and B, and fault in A;
>>    2) age the memcg once through /sys/kernel/debug/lru_gen, then fault
>>       in B, so that B is one generation younger than A;
>>    3) apply MADV_COLD to B only, A is the control;
>>    4) reclaim the size of one region from anon only:
>>       echo "64M swappiness=max" > memory.reclaim;
>>    5) count the swapped out pages of A and B from /proc/self/pagemap.
>>
>> B is expected to be swapped out instead of A. Before this patch, B stays
>> in its generation after MADV_COLD, and after it, B is moved to min_seq.
>> Three runs on mm-new:
>>
>>                       A swapped out        B (MADV_COLD) swapped out
>>    before             16384 pages          63 ~ 150 pages
>>    after              58 ~ 78 pages        16384 pages
>>
>> Cap the generation to min_seq[type] for MGLRU, so that the folio is
>> added to the head of the oldest generation. This matches the classic
>> LRU, which adds a deactivated folio to the head of the inactive list,
>> and is where most file folios already go. Folios that have PG_reclaim
>> set and are dirty or under writeback are now placed there too, as the
>> classic LRU puts them on the inactive list. min_seq only advances under
>> the LRU lock, which is held here.
>>
>> Fixes: 081488051d28 ("mm/mglru: fix underprotected page cache")
>> Suggested-by: Barry Song <baohua@kernel.org>
>> Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
> 
> With a few minor nits.
> 
> Reviewed-by: Barry Song <baohua@kernel.org>
> 
>> ---
>>   mm/folio.c | 19 ++++++++++++++++++-
>>   1 file changed, 18 insertions(+), 1 deletion(-)
>>
>> diff --git a/mm/folio.c b/mm/folio.c
>> index 7521680874c5..0220419612ff 100644
>> --- a/mm/folio.c
>> +++ b/mm/folio.c
>> @@ -525,6 +525,23 @@ static void lru_deactivate_file(struct lruvec *lruvec, struct folio *folio)
>>          }
>>   }
>>
>> +#ifdef CONFIG_LRU_GEN
>> +/* with MGLRU, add the folio to the head of the oldest generation */
>> +static void lruvec_add_deactivated_folio(struct lruvec *lruvec, struct folio *folio)
>> +{
>> +       int type = folio_is_file_lru(folio);
>> +       unsigned long seq = lruvec->lrugen.min_seq[type];
>> +
>> +       if (!lru_gen_add_folio(lruvec, folio, MIN_SEQ_UNBOUNDED, seq, false))
>> +               lruvec_add_folio(lruvec, folio);
>> +}
>> +#else
>> +static void lruvec_add_deactivated_folio(struct lruvec *lruvec, struct folio *folio)
>> +{
>> +       lruvec_add_folio(lruvec, folio);
>> +}
>> +#endif
> 
> I'm not sure whether compilers will inline them, but explicitly
> marking them as inline should be fine?
> 
Sure, will mark them inline in v4. Thanks for the review!

-- 
Best regards
Ridong


