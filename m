Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0B3CAC9830D
	for <linux-mm@archiver.kernel.org>; Fri, 25 Sep 2026 12:55:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F17086B008C; Fri, 25 Sep 2026 08:55:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EEDF06B0092; Fri, 25 Sep 2026 08:55:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E047E6B0093; Fri, 25 Sep 2026 08:55:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BFBDB6B008C
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 08:55:04 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 584CFA69DF
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 12:55:04 +0000 (UTC)
X-FDA: 85252279728.09.30F4E05
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf11.hostedemail.com (Postfix) with ESMTP id 4DB5B40007
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 12:55:02 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="T2sDY/OT";
	spf=pass (imf11.hostedemail.com: domain of sarthak.sharma@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=sarthak.sharma@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790340902;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=h4dsqFp9e1dSwilDOF28XBVkcgES5OoW2OuQknQBB3Y=;
	b=yhb7C/f62pY+fB8wlwLQYjL6fU4ft33tJJ0O+gswUE7asLxBc7ENtElIKsMBFk7sqfbRll
	MhBcub19yA9OR8q8rXnpel3Px9ssTN42sUKbbtqlC+LvLOngNktmeSBahfWAvNbMoI/HZI
	UkueEWU2jVkN61VIc3KiG0y3gCRvb4E=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="T2sDY/OT";
	spf=pass (imf11.hostedemail.com: domain of sarthak.sharma@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=sarthak.sharma@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790340902;
	b=u5YDH1cliXjRh1GrvQ4ASrqHQcihK0cyCQrgT7H/s+DV/SoJl17x8rh9C8ZZzDhLbePU1v
	a6+NUlVWh5MmtxzZOZDo9bAFHem6QXd6Ut58Ya1/OLbuni/FYVNwbFt1YXPi/RSMAuBKUF
	KjZyayMRS1d7JPwZBi3G1Ey/wXEJs/4=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B6F40169C;
	Fri, 25 Sep 2026 05:54:57 -0700 (PDT)
Received: from [10.164.19.84] (a081061.arm.com [10.164.19.84])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id AA2733F86C;
	Fri, 25 Sep 2026 05:54:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1790340901; bh=j/85jN3gYWWQWBvqu4uwZCoLwy7OMcYx99dC/0gNZ/0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=T2sDY/OT1wts5m+zf3YiB+h35c0wkFSU5O7wCdUM4ZIQDvj82832pGAwRVWgO6O4P
	 ls3SAOPMKxbCbE73jt4apBpB5wtgH643FtHhgqzeN2vytVostVCok9iKdS/zDUhGem
	 4aG0r2e4ya4jwiIvb3KUc+KaEx2ck1IE42sZpUG8=
Message-ID: <1dc9a608-16f0-445c-8e5d-a865d4ed0736@arm.com>
Date: Fri, 25 Sep 2026 18:24:52 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 3/4] kselftest: mm: integrate huge page checks
To: Yeoreum Yun <yeoreum.yun@arm.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
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
References: <20260924-fix_split-v8-0-cba7359d882a@arm.com>
 <20260924-fix_split-v8-3-cba7359d882a@arm.com>
Content-Language: en-US
From: Sarthak Sharma <sarthak.sharma@arm.com>
In-Reply-To: <20260924-fix_split-v8-3-cba7359d882a@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 4DB5B40007
X-Stat-Signature: ab57apptwt3uixeu9xp4opzfezttnogz
X-Rspam-User: 
X-HE-Tag: 1790340902-827341
X-HE-Meta: U2FsdGVkX1+ssUTVEYiUm+11/knfazUtC0vnksPr+eM6bteQBzk92B5B4KVJ8SzVBa2KJ9Ol9fR/J52k0/j0jOKVrRbAsRU0Txs8HYb18rwn3AtBB98rYv10vOtoGK8rUBlE1QuVpxDpriW/0AUffeKoKrwCJP9IaoUMREhmMMUVo0uZLIXGuFU1WoOxVz30d6r2sbISFK/JAvJVIo5X06tu3VeKr42xVMIvWiQZHUgs1w6vyKsLrQeilOwqCqGnnngPrcx3rwb212MDJoVDYzr6rqyNMrSRRex5gFDOQVdqjnbmQ/yQHKZkTUyuiv0gBBwJmPrhF51MEfHQx9qiJ3bp+8HuFyV2QUEaIIlG9JXG28BNYYx09Etjx6SbwekBMHL72sQfaKu0gFo9VBuFqqtL1cmXniF4SHM6vz0uWV0rPyAQ9bwDzBM5gvE9rL1rFayBCTzEp3yGmYNNZFUtxU3+wodyBQYT2lRwhc6MeJPv8znb3BO9yqgMKSJSSG2svA7QLciO+0giTLyfHAYZIEgrma5wddBAdjTjlBUmoQZdp0ZWRtjpdrvMUngs4wdTDPiB7a/yecSbH7xZYfHsnjz2TLKEzb21mc3wQOi6PsEVDm6hy4ZUsJuGeM0BvB/8j58WhVWoIlCxHldwTUX29AAbPXKbrl/43Qtw8DehcZ/vj+7vgsNVCzDoVK+pf6EIAFfTPSUzIlHcTjpFhh7z0V3qWXw7iPEs5jxnUqQTXAvQMidzbVCJY5K9HAmlaZnKdyPz/dGbmLd7/+2jEJAmnV/Wg63eKohZsDClH3ygkl/puC4uN1X4qjN/y/kWWznnFlAGeaVbfbwCEBI2aJYnBR6wbifTHanzYzrNxA9Tg15tpEEXORZceu/bSowjCrU8RQJYK6u4RPgEu3hyoH0g85QPCxUyn9GE2LruUII38zdUZKb2xrOohdyXbBaCRlakiXWE8DN/QrVf97w6WCz
 MYlbb392
 GaCZy5g7ZHuxmFPCbb25ZD4yxO8MzcQuPSJTcZoUxewT51lWBiizq6O4cKXT+CS15bpptSapYFvM9yG8Yg944Bt7kP0crANp2NxGyWfSWTTn7x84lOHfSryyeMNQWnwOX0Ekfzl1L/LOX0FT3ssyINUA/K/qIu/OyOJcXKRTco65Sla/SNlgRCRyS4IwX7EweCTXp0npTdd2De23iYVK/zfEKTHkCxaNHseaO4sDbgf4Tf2utwHRXrHXYWslPibNWf3cqnmrPUYHYaM6mvOZw8UiV+ZN3KvO5L3NfKNV0Twg3kUdwQNq9N8gxvpwP/jOUslyUeeWLEkWivxFEuL6x8lgfVQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 9/25/26 12:41 AM, Yeoreum Yun wrote:
> check_large_folios() only checks for large folios without distinguishing
> between anonymous and file-backed huge pages.
> 
> To add huge page type checking, integrate the huge page checks into
> __check_huge():
> 
>   1. If hpage_size == pmd_pagesize, check PAGE_IS_HUGE instead of using
>      check_large_folios(), since only the mapping type matters. This
>      identifies PMD-mapped huge pages.
> 
>   2. Otherwise, use check_large_folios() to detect large folios. This
>      covers mTHP cases.
> 
>   3. Check the folio flags according to the huge page type.
> 
> Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
> Suggested-by: Zi Yan <ziy@nvidia.com>
> Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
> ---

Looks good to me, some nits below.

Reviewed-by: Sarthak Sharma <sarthak.sharma@arm.com>

[...]

> -static bool __check_pmd_huge(void *addr, size_t len, int nr_hpages,
> -		  uint64_t hpage_size, enum check_huge_type type)
> +static bool __check_huge(void *addr, size_t len, int nr_hpages,
> +		uint64_t hpage_size, enum check_huge_type type)
>  {
> -	int pagemap_fd;
> +	bool ret = false;
> +	int pagemap_fd, kpageflags_fd;
>  	int nr_pmd_mappings = 0;
> +	uint64_t pmd_pagesize, scan_mapping_size;
>  	uint64_t categories;
> +	unsigned long pfn;
> +	bool check_pmd_mapping, allow_nonpresent;
>  	char *start = addr;
>  	char *end = start + len;
>  
> +	pmd_pagesize = read_pmd_pagesize();
> +	if (!pmd_pagesize)
> +		ksft_exit_fail_msg("reading PMD pagesize failed\n");
> +
> +	check_pmd_mapping = hpage_size == pmd_pagesize;
> +	scan_mapping_size = (nr_hpages > 0) ? hpage_size : psize();
> +	/* Some mTHP tests check a partially populated PMD-sized range. */
> +	allow_nonpresent = (uint64_t)nr_hpages * hpage_size < len;
> +
>  	pagemap_fd = open(PAGEMAP_PATH, O_RDONLY);
>  	if (pagemap_fd < 0)
>  		ksft_exit_fail_msg("open pagemap fail\n");
>  
> -	for (; start < end; start += hpage_size) {
> +	kpageflags_fd = open(KPAGEFLAGS_PATH, O_RDONLY);
> +	if (kpageflags_fd < 0)
> +		ksft_exit_fail_msg("open kpageflags fail\n");

Again, can we change it to ksft_exit_fail_perror()?

> +
> +	if (!check_pmd_mapping &&
> +	    !check_large_folios(pagemap_fd, kpageflags_fd,
> +				addr, len, nr_hpages, hpage_size))
> +		goto out;
> +
> +	for (; start < end; start += scan_mapping_size) {
>  		categories = pagemap_scan_get_categories(pagemap_fd, start);
> -		if (!(categories & PAGE_IS_HUGE))
> -			continue;
> -		if (check_huge_type(categories, type))
> +		pfn = pagemap_get_pfn(pagemap_fd, start);
> +		if (pfn == -1UL) {
> +			if (!allow_nonpresent)
> +				goto out;
> +			else

Nit: We can skip this else here.

> +				continue;
> +		}
> +		if (check_pmd_mapping && (categories & PAGE_IS_HUGE))
>  			nr_pmd_mappings++;
> +		if (!check_huge_type(categories, type))
> +			goto out;
>  	}
> -	close(pagemap_fd);
>  
> -	return nr_hpages == nr_pmd_mappings;
> +	if (check_pmd_mapping && (nr_pmd_mappings != nr_hpages))
> +		goto out;
> +	ret = true;
> +
> +out:
> +	close(pagemap_fd);
> +	close(kpageflags_fd);
> +	return ret;
>  }

