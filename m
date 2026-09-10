Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C6E6CC79FB9
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 10:34:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DF6F06B0092; Thu, 10 Sep 2026 06:34:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DCD366B0093; Thu, 10 Sep 2026 06:34:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CD4606B0095; Thu, 10 Sep 2026 06:34:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 9C5DC6B0092
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 06:34:54 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 30981A0463
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 10:34:54 +0000 (UTC)
X-FDA: 85197494508.25.7DF23D5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 5E59D40003
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 10:34:52 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MSnkxusa;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789036492;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xPoAJQ8RVtTcl+HZmeHhbo2ptnfrxfTfihttt1e6Wso=;
	b=YCtOsmPxJJMSS4Pd/unkMqLCbBgwvataC1uHb7dZkhGfe9AP1ZULZRHaMUD1O7J3AtiVLY
	hra4UT4S6UgdpxNGf1HJzsbB1I0T6s48hUrkxLy69i1rz2hSHZ9hhSSPxgVyXEm9PhoqgX
	3WcbGC5aiJ7ZObBG+cOXjABIgW//jPc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789036492;
	b=zkeOoA7AlkUXyg3G2StR+cN6VLya8BxGdNMbtc/4pzkL5qM5IqA1eoLiZO6raZuGlTNe5B
	OmBJL7FV7+NPrl88TmruMRMdxtDR3Op6aR07ZYZp9YT0j0Txvtd6MLTZ4PYO4uxEy0silB
	ogGE1Y7hmTr+KbQjwuf35TI0df12VrU=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MSnkxusa;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6D417400CE;
	Thu, 10 Sep 2026 10:34:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5583B1F000FF;
	Thu, 10 Sep 2026 10:34:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789036491;
	bh=xPoAJQ8RVtTcl+HZmeHhbo2ptnfrxfTfihttt1e6Wso=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=MSnkxusaee5aoWIGIGQi7pPtsnXjreNTB0RV3NddkGoNuvcRSiSt7ifMpT+wuVWQI
	 52PLeyPiZRMdWMUpiqFDaOsUGPXqlzlasC5Sa1NC+N7Ej0gotbzJ9GQyNzPa8LVvsu
	 xgg6uSvaN/+4DkCIGIJFLFle890YE1jVcqgyeqWvQL/jXgUSqGHq1gzX287vGcgO1l
	 rLnh/OxXJtoglp1HuAWl0mXm62CVgpWLMZbB5W0OccpF0RrYIVruwsMy6RrL9cj3lh
	 mhWC0q7fVr3ZndwP2s6pZUViv1rhdis1W4/otlQ8HgrMuJOPOr4zDIl7ns5NIKsTsf
	 3yBhtGZcSQKww==
Message-ID: <5c05b620-7a2f-453d-9725-fed4f536a019@kernel.org>
Date: Thu, 10 Sep 2026 12:34:43 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 3/3] kselftest: mm: introduce alloc_isolated_mem()
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
References: <20260907-fix_split-v5-0-822b810458bc@arm.com>
 <20260907-fix_split-v5-3-822b810458bc@arm.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260907-fix_split-v5-3-822b810458bc@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 5E59D40003
X-Stat-Signature: y774wtfuwfok5f35etdwu8nnr83auomr
X-HE-Tag: 1789036492-941820
X-HE-Meta: U2FsdGVkX185s5IHD3QDCqDXaxrFo8FfT20/k8VQhs6aoYLjghGkh0a7wruCu2/fkp7pOiOGNRVrqzB4+WLpHAPQYcQ+0jA7UELZMdKsNa/f5pmuJMFzvSKBMNNpBPQWX8pZ5u1lFWoNTRVsijyhLDZJKkLlrpBo6Zgm5o3rJi+KXG9c+Ys9SXD0oJx6mHHJk8+Wij6XQK0qicTPYr2JhxHxUIZV3RbChSMh/aYP/whQZ56ELFUJlvZx7fCbji6J7Bap11K91UB3HXIsoJ5FgpQ7eRTrVo5O3vXjD926k6HZjJ+a/eQDkdKSFyZ4lKUw/0NMPKoD2Sz0XevW/MO2mrO90+2zWmyoXhh+6OYU6xgFap82ykv0LqaMJrbGbWPyrRK+yx7IEI2IhWft318Pp6h7oFJNZ8GTOpYxEpOe4zBTXAVO9GiNk2z0aTzZRSDGlpG2Eoc6PsFuu9V7S9fECMFGC6pWVOOOMz7Fkb1arxVtC4J2nhTiZTwcnD5ZAUyT8RRhS8tBykrWGFtbVtGiLHcvye1lhxyhjz+Ke8Sd37rU8Krb/QwKwBMpWHZuuWw6D9SFSkjN/2HfwexaBxS7dB+bjlz0rG+AmHLYITxohAa+BsT2p1bb7cOCCN7OktKxe2sdnbT0IOol4AcKqLpFNu5A8fjMchueH9raG5iqO5gUcfQjVU9eAR2+kynXLuRgddfbhD3OVztnpIUNpPk4Cm+9n7oqEUWGNriGB0vuisrDuf79fCARooy9MmQO68unEnyVt6s99PKuicMupR3iaowYXOWdUTpNZQmTUrWRwTs3gtioCsco0FzKwbznp42qqZTXrBemJVK19YFPoexfaLoW0XNVe+mjsQbI9ut6D/ySKsJPEuMfQ8xYy6jgHA09oh7PKCdbAvfyw4/6MeqW4v5XRPqNOa0pKVztPHgytNYT+wl8GnHB9t9cebIwv32TwSQhdbIy0XFdXEykLj3
 cJB7O9Ob
 Cx9pde6cpYAY7+1IrkeKRcVa+w0qjfELMtA1PUw3Fu/cWVhUC3RM7pjOmO2ZhkVpZ2SnN7zgZhLKr6QN2DAuXzBK8Y7lW+RRSLtMuy4y9CeWcIRp8KUFG+2ZbeJ1uaG0xJ+VXyiA3Hp7EXSoUKbyRDUHpdoS2tpkQLeYuYyvQ4MXtnP84ybaY3N1fSJSRMCkG+Ce49Q7mnJQO+sa8A+nt3XzlMfpZO5mU82jPu6+N8aofIZkmeizu+ZoqwTwaCFNqokSBHt6IRC04bAq2UcYCu357i7Mv13vKThrH5Eo01EOjHxr34pdOa9OV4w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> diff --git a/tools/testing/selftests/mm/soft-dirty.c b/tools/testing/selftests/mm/soft-dirty.c
> index 5f278913c4d7..b6fad38c8bee 100644
> --- a/tools/testing/selftests/mm/soft-dirty.c
> +++ b/tools/testing/selftests/mm/soft-dirty.c
> @@ -92,9 +92,9 @@ static void test_hugepage(int pagemap_fd, int pagesize)
>  	if (!hpage_len)
>  		ksft_exit_fail_msg("Reading PMD pagesize failed");
>  
> -	map = memalign(hpage_len, hpage_len);
> +	map = alloc_isolated_mem(hpage_len, hpage_len);
>  	if (!map)
> -		ksft_exit_fail_msg("memalign failed\n");
> +		ksft_exit_fail_msg("alloc_isolated_mem failed\n");
>  
>  	ret = madvise(map, hpage_len, MADV_HUGEPAGE);
>  	if (ret)
> @@ -130,7 +130,7 @@ static void test_hugepage(int pagemap_fd, int pagesize)
>  		ksft_test_result_skip("Test %s huge page allocation\n", __func__);
>  		ksft_test_result_skip("Test %s huge page dirty bit\n", __func__);
>  	}
> -	free(map);
> +	free_isolated_mem(map, hpage_len);
>  }

smaps is really only problematic with merged VMAs when relying on exact page
statistics. For other properties (vm flags, MMUPageSize) it's not a problem as
long as our smap search just finds the VMA that covers an address.

Assuming we fixed check_huge_anon() to not use smaps, why is this change here
required?

-- 
Cheers,

David

