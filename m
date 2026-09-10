Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D1F27C79F9F
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 11:02:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E9E4B6B0096; Thu, 10 Sep 2026 07:02:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E4E846B00A5; Thu, 10 Sep 2026 07:02:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D3D7B6B00B3; Thu, 10 Sep 2026 07:02:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B9E2C6B0096
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 07:02:53 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 184A51C212C
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 11:02:53 +0000 (UTC)
X-FDA: 85197565026.12.9099D20
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf21.hostedemail.com (Postfix) with ESMTP id 1438A1C000C
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 11:02:50 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=gUoQDdnh;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf21.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=gUoQDdnh;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf21.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789038171;
	b=N5ap3QLd6QsgF8H8CKmec+z1yuodwWhEHdKLfwQQuyk2cMkOuI5nGfVUWtonTs1wdj0Hip
	KXu7+0IoWMjwTFWLffTkkkscUuDTxpFD/hfOuF4mSuIov5dqnYALUNtn+hWQ97C9HbY9mA
	Dp8CM/31bJon+l62QwZimwLspMVaJec=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789038171;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HKuEi7+JQ7A9WOXUqmmj18XdJqiU/+4nBYcEMX0I428=;
	b=Jp6Xh40J8dQEWAjCBPfg2NRH8UFq9jUfTc0le0REpGnQDjG1Q4nRWVRMDYhhZshlz0pqrm
	nybK8zENVVs/7wRNSjvx5vTIXvXoEjc3kjZ92RlEw2StI7J9I5+XLyUelRF0CHWcYJorkm
	zs2qbJKaTO5gZtfe6dQcB8Vvv75zR9M=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 892701477;
	Thu, 10 Sep 2026 04:02:46 -0700 (PDT)
Received: from e129823.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 3AFBD3F7B4;
	Thu, 10 Sep 2026 04:02:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1789038170; bh=/dEIy4o63fAuLRmPsqw2tWaPBUfiEsjcQUh6U/nccpI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=gUoQDdnhVoQC6I8BCdAG+Us9oa8BWEbviuzUkHV9UxC2sIiCX+tWf6QfdCPkzZ+/G
	 w2mzMKUPN833StqmMeH9wS7ztmqdlQnVz1A3qJ+xbQzyiEDumaMULK+J6xpXPXLwbe
	 UzlnQ9wrliqUXi05PxhB8UrjRDpeHWEM7IKvi578=
Date: Thu, 10 Sep 2026 12:02:44 +0100
From: Yeoreum Yun <yeoreum.yun@arm.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Yeoreum Yun <yeoreum.yun@arm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <ljs@kernel.org>, Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Nico Pache <nico.pache@linux.dev>,
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
	Usama Arif <usama.arif@linux.dev>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>,
	Kevin Brodsky <kevin.brodsky@arm.com>, linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 3/3] kselftest: mm: introduce alloc_isolated_mem()
Message-ID: <aqKOVGECsCNtSMIV@e129823.arm.com>
References: <20260907-fix_split-v5-0-822b810458bc@arm.com>
 <20260907-fix_split-v5-3-822b810458bc@arm.com>
 <5c05b620-7a2f-453d-9725-fed4f536a019@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5c05b620-7a2f-453d-9725-fed4f536a019@kernel.org>
X-Rspam-User: 
X-Rspamd-Queue-Id: 1438A1C000C
X-Stat-Signature: feck4qzyisnm13cr3b4binhfw4zhgar1
X-Rspamd-Server: rspam01
X-HE-Tag: 1789038170-56152
X-HE-Meta: U2FsdGVkX18Md5aRMtZANDq/34pCrLxHikd6aL7u++wSD4GP+cy5w2F00YaerbTezXHrHp2FetFrDM3UD7E6ydtDtTU1kX8Ie8hp27Q4ceuE4PNEMmvPGXZSkEtLEs2SNyazFYZlmiusZR14WanNqABXc9Ks7Hp4rsdXQ8M1uOYSGRYtP4iH/zZ/GQLAjTb74y8nTsRWfpYRFGxY9sWBD7f+FUv8DQQVOeiBrA/1NB0xS3jm90G6UukZx3LIDYS82PYZqB03QQAKotNSWaQBTY4NmjOajI291OkFI0I/7uN5DopS0NWKYwYyjUTyIiwesa8Yoh+V0F0kT8OJMvvRhSVLM4uheCtkuTLSUHcVVCkKqU2XNLgVEaZb9E9X0XjqeiIs9dYSsvRFwcz4uGeyem0wm+IkNqcR4LmWscnG2P4iwcdKrJonXcZwzoAr6TDwgJbpfb66pa4HD3PP2bH3g6aCXh4jmXO571AhOajyhoANe/2N2OlA8bx76Tm1mwgJUyTYyQgDlz9wMut6bygNz+e05oBn6z5L/EYEwpPm7fsvZsuGXDfQDpHd8DHmdJMvLSHmcdsNYu119kSseOhoO5VUWb3ErurCOAGFt+fEIx58YLUzKTpO/2mffnApv0VxB4I6fVzkOyYzqymn0Oux7sIYcy8H8E25U7PMcajHsejlhWpVMO2vHHkWc08YSak7MgkOnMJd4FkxyzVl9gIxJN3Nzx4iYqzSpaSHi7wv3xzIZrMzsdStoibquIACtxQDhI3ReoB8n4/7z9WUFhMj8Tr78NVRTU9JBxqbyg+Mz7nOb8BQ2dj3EOVEpyY9kUlgrNvvrWXUsQPcnWjnRD3BP8ub9OsuuKn3QC6WMErZwf7VuHDJVr/wRqDZz+TjS/KOckuaPcmuiwtK0r9kEZ+z0L7dRV+14cxvWDkPoKtY4Udi1Zh/JCyOhl+Xe8PTOCdGg6LmnazbQNTOZAlu8+Y
 smZxNcZ6
 skeZWGC/jqrH+Edoi0Zm8/I43rV7pd1TTgnlIWtT0dTJ4J0Dpe5kBozFsHozkcm1i1oDGdqmNxiQdtqt94718SFESrgh3HouM76bjkAV/EPTBL96e8Alp82GwUbQ56Z8Yh88LQZOnPcJ0BdffPr7BfL87eoPnbcNDP4jfqji9DGmciyewnnosFrYdp6YqmdmHtliRt7HQIi8VI8z+TOKK4UgRVPCP7QUDoSpWDLr7wLmVAQBlyxVglfKSJuACRxPpzYVO+QiGl8srsspFgZHWEpUz/0WiKxK4OI/W
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> > diff --git a/tools/testing/selftests/mm/soft-dirty.c b/tools/testing/selftests/mm/soft-dirty.c
> > index 5f278913c4d7..b6fad38c8bee 100644
> > --- a/tools/testing/selftests/mm/soft-dirty.c
> > +++ b/tools/testing/selftests/mm/soft-dirty.c
> > @@ -92,9 +92,9 @@ static void test_hugepage(int pagemap_fd, int pagesize)
> >  	if (!hpage_len)
> >  		ksft_exit_fail_msg("Reading PMD pagesize failed");
> >  
> > -	map = memalign(hpage_len, hpage_len);
> > +	map = alloc_isolated_mem(hpage_len, hpage_len);
> >  	if (!map)
> > -		ksft_exit_fail_msg("memalign failed\n");
> > +		ksft_exit_fail_msg("alloc_isolated_mem failed\n");
> >  
> >  	ret = madvise(map, hpage_len, MADV_HUGEPAGE);
> >  	if (ret)
> > @@ -130,7 +130,7 @@ static void test_hugepage(int pagemap_fd, int pagesize)
> >  		ksft_test_result_skip("Test %s huge page allocation\n", __func__);
> >  		ksft_test_result_skip("Test %s huge page dirty bit\n", __func__);
> >  	}
> > -	free(map);
> > +	free_isolated_mem(map, hpage_len);
> >  }
> 
> smaps is really only problematic with merged VMAs when relying on exact page
> statistics. For other properties (vm flags, MMUPageSize) it's not a problem as
> long as our smap search just finds the VMA that covers an address.
> 
> Assuming we fixed check_huge_anon() to not use smaps, why is this change here
> required?

Since there is no interface to get vm_flags not via /proc/self/smaps,
It might be good to have it for preventing unwanted VMA merge.

And might be useful for future to prevent unwated VMA merge.

-- 
Sincerely,
Yeoreum Yun

