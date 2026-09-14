Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 32D4FC88E75
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 14:16:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 20FB76B0088; Mon, 14 Sep 2026 10:16:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1E77C6B0092; Mon, 14 Sep 2026 10:16:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 108A66B0093; Mon, 14 Sep 2026 10:16:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D090E6B0088
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 10:16:54 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 17C2FA395B
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 14:16:54 +0000 (UTC)
X-FDA: 85212569148.09.C55A975
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id 75101160004
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 14:16:51 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dL0j20gf;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dL0j20gf;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789395411;
	b=7ZA6YBZs3xBeDfoCzRjxtggABU5eETL+CwGXSe1KVYp8eDc0niE8SOnd0Nvz8knwqhOzL5
	PAs8C/yRcQm/kvMwPBF2OpZA7WoDy8KXJafbU/5lIHPwLpN9bB4uwSRLvhnAyPiDhOH7rT
	2oE9KVt7oiNrUAlNl6S4VUuq3pixbw4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789395411;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=o/3IRmLFAEksJkCPHyaGPKVzpnZlgfypBxMxwnYS0Xs=;
	b=2QaMJq0VisxnYLxTXaVyLntkzFcXRY6Myj6ADLsgjPKLeASpDDb4qJ417v6dDNeF8uRKZT
	SAd8hur2KZeLXJZenjtISvQ5lsiQzrC9iq2lLhRYw2TK5J4OH/HUbe8qrs4ubR3ju1bSs9
	bhK+UN6FaRdwoZDQvJX6DXbIvNHpdMw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 9EF6540890;
	Mon, 14 Sep 2026 14:16:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C94C71F000FF;
	Mon, 14 Sep 2026 14:16:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789395410;
	bh=o/3IRmLFAEksJkCPHyaGPKVzpnZlgfypBxMxwnYS0Xs=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=dL0j20gfGBQmg5awWBbdF5fL/EH5b8s8ec0E0HvyyjR8q++TGEItDKFOzaAhuM9L4
	 FtzWIcsbBq5yn8LkP68emA2wr/CpECfLPrU4RSqVn5cutqiss1hS5jKWLbMzHo0rYg
	 gIUnfV+HekT/x1yzaZfiy6uAak5hcEf0hx9dOqa79qqGgFTZDaNxA1lHblr9ychJ87
	 V1WdIBQkk293e/YBfYYgTKgMovRiL1rlpcHomv0+1wY7OPxlDkEAgGNGIvqq94rRBd
	 ziSueEAIEgfUEiUU4HHeXyBXNtBtYo4bmiKY5S3vaK6lUs/s0h8tiHjo0ugHO7yeBf
	 10YqmeaZotnBA==
Message-ID: <1be327b0-aec3-4b46-9a96-c701e87d3c3a@kernel.org>
Date: Mon, 14 Sep 2026 16:16:40 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 3/3] kselftest: mm: remove check_huge_shmem()
To: Yeoreum Yun <yeoreum.yun@arm.com>,
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Usama Arif <usama.arif@linux.dev>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>,
 Kevin Brodsky <kevin.brodsky@arm.com>
Cc: linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20260914-fix_split-v6-0-16ed7123800b@arm.com>
 <20260914-fix_split-v6-3-16ed7123800b@arm.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260914-fix_split-v6-3-16ed7123800b@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 75101160004
X-Stat-Signature: sn84howg5d3jf71kntzx17phb18et1rr
X-Rspamd-Server: rspam01
X-HE-Tag: 1789395411-102177
X-HE-Meta: U2FsdGVkX18caJHyCc9tMcTxeh2PO5XsxCxtxYQTkQTH5nV3uQKWakLBYNKXl0uE6suQvYbnZM6+hYzN+fLz2KgTEBZMhgkQsAZW8pV9aa3FpFkLIjyPRVBfmetAcc7potU4G/fp66pZo4lBFqmHUact6PkLSxQIjHoB9Avdp88goS4CGHeST8v7P1X7gtdJc6t6W5LTD/VFfAg1YIiMo6gkU08gmZsqprr9JRvKdviWTellJjUrI4SqR/7+61g38JlHNiz/gCuqm9aLehwcLZ2P9lF4alKvWU9Fba5gytJU5t64SE/DjCTA8TV4DBDlPgRtpDsbbGSjSAyMEIs/0zWKgY4Eh55fHY0f7nI8l/MVYgfY1aVfqq3UMlwf35X6pAp3iKKdiUSlho+i5Vg5xGpjC/iWWya785Zq4gy5wqfWfgmZjZAylY5e1sxiW5BJsYLbdQdLXkhQWlHxmVRqWRdJL5srbafskd4EV2lH5FkO6mh7PTPp9ziCc6cshSYLu6pmkKV1+IEXO4M4AVHH2p+YGELqAEMVT9UTEpOhQukOuyBoIrzT+OyuP8SRqqdpMU7PaMozdC71wzjuZcvD2f1KburyM1vPIH/ljmCyg/9JXGsKRxYxmbZAWJqFsKoN5AgU8UtwEsiM7GVDEGnbk6qEVxlxa6fDYy707+I787ms6VeIvqRe9LaWhE7p8H54if8yei/lL8l0C824rEsNgwaegyCMLCqTzorVhc0Tasn9YwXGdPJkiOFjDrN0PyvX0Q6lBcHuPm+7w7BHVwqpnzbQ++Au1bhZWDULenbkb0biTRIe8fzcIhKE3qmH4/r1lFJnMyrD7Na/sEK5WfQOyiGYuGFT6Rslc7Z8kTUuYHAoq7alacXRPiTgLosiHMZSJq17Cr9d7atmBAVESyoNu8unWGzuxR+JAE2HBMBfNOdSCdvS5AXsf1CVx5QWStx/Ey7pgPg1ixQEvL3/yNE
 6DPuyROk
 aO8cyGEPcp3Vi4v9Cdy/I1/7/CStwmihBe1+VxhUKMwD+ZEBiatuvA7WC2d9X3gRCvzpV2m0U2zFBc5gz0zHhXwOde9YePzi/Psd7CIGLPiM7LeL5RP46Csvd4ZhTrCZecXoytPiteqlbVl4coTRXtagCF1W4yr1NVU79jbdvARqAR/D7n5KbLypuGir2pAq7OOhmP8BbY6IB3TGNGm278ic+Jhn37AfymzpF8TWLC1Kr2u9kYBnB36aHutdyxE/OOCSgc3PrT4d4Oe7UqqD6xWnXdo41HSCqOumS87UU1q/y9DaHuKdor6+ON1014VtrryZFqofOiw3xXb+qPcuSa0fMRw+RYZWyaeRThQScDGdi5efEUbjwVKIIns5SmDbl/WiaUwxVF885uSNzR442g3JPTg9V8iQ+DaZZ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/14/26 09:30, Yeoreum Yun wrote:
> check_huge_shmem() was required to distinguish shmem huge pages because
> /proc/self/smaps reports them using a dedicated “ShmemPmdMapped” entry,
> as opposed to “FilePmdMapped” for file-backed huge pages.
> 
> Now that /proc/self/smaps is no longer used to detect huge pages and
> /proc/kpageflags is used instead, it is sufficient to distinguish
> between file-backed and anonymous pages since the ShmemPmdMapped is also
> kind of file-backed.
> 
> Therefore, remove check_huge_shmem() and use check_huge_file() instead.
> 
> Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
> Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
> ---
>  tools/testing/selftests/mm/folio_split_race_test.c |  2 +-
>  tools/testing/selftests/mm/khugepaged.c            |  5 ++---
>  tools/testing/selftests/mm/uffd-common.c           |  4 ++--
>  tools/testing/selftests/mm/vm_util.c               | 11 +----------
>  tools/testing/selftests/mm/vm_util.h               |  2 --
>  5 files changed, 6 insertions(+), 18 deletions(-)
> 
> diff --git a/tools/testing/selftests/mm/folio_split_race_test.c b/tools/testing/selftests/mm/folio_split_race_test.c
> index 1960635a953e..4c0d3b6a411b 100644
> --- a/tools/testing/selftests/mm/folio_split_race_test.c
> +++ b/tools/testing/selftests/mm/folio_split_race_test.c
> @@ -182,7 +182,7 @@ static uint64_t run_iteration(void)
>  	for (i = 0; i < TOTAL_PAGES; i++)
>  		fill_page(mmap_base, i);
>  
> -	if (!check_huge_shmem(mmap_base, FILE_SIZE, NR_PMD_PAGE, pmd_pagesize))
> +	if (!check_huge_file(mmap_base, FILE_SIZE, NR_PMD_PAGE, pmd_pagesize))
>  		ksft_exit_fail_msg("No shmem THP is allocated\n");
>  
>  	if (pthread_barrier_init(&ctl.barrier, NULL, NUM_READER_THREADS + 1) != 0)
> diff --git a/tools/testing/selftests/mm/khugepaged.c b/tools/testing/selftests/mm/khugepaged.c
> index f82673f5f6b4..6cd1effea465 100644
> --- a/tools/testing/selftests/mm/khugepaged.c
> +++ b/tools/testing/selftests/mm/khugepaged.c
> @@ -416,9 +416,8 @@ static bool file_check_huge(void *addr, size_t len, int nr_hpages,
>  {
>  	switch (finfo.type) {
>  	case VMA_FILE:
> -		return check_huge_file(addr, len, nr_hpages, hpage_size);
>  	case VMA_SHMEM:
> -		return check_huge_shmem(addr, len, nr_hpages, hpage_size);
> +		return check_huge_file(addr, len, nr_hpages, hpage_size);
>  	default:
>  		ksft_exit_fail_msg("Unknown VMA type\n");
>  		return false;


Assuming we do:

diff --git a/tools/testing/selftests/mm/khugepaged.c b/tools/testing/selftests/mm/khugepaged.c
index f82673f5f6b47..9542173a748e2 100644
--- a/tools/testing/selftests/mm/khugepaged.c
+++ b/tools/testing/selftests/mm/khugepaged.c
@@ -53,7 +53,7 @@ struct mem_ops {
        void *(*setup_area)(int nr_hpages);
        void (*cleanup_area)(void *p, unsigned long size);
        void (*fault)(void *p, unsigned long start, unsigned long end);
-       bool (*check_huge)(void *addr, size_t len, int nr_hpages, unsigned long hpage_size);
+       bool (*check_huge)(void *addr, size_t len, int nr_hpages, uint64_t hpage_size);
        const char *name;
 };


Could we then simply use check_huge_anon/check_huge_file directly and get rid of
these helpers anon_check_huge + check_huge_file entirely?

-- 
Cheers,

David

