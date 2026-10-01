Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 67DB7CA5FCB
	for <linux-mm@archiver.kernel.org>; Thu,  1 Oct 2026 11:40:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7C5AB6B008C; Thu,  1 Oct 2026 07:40:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7767B6B0096; Thu,  1 Oct 2026 07:40:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6653C6B0098; Thu,  1 Oct 2026 07:40:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 42ED36B008C
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 07:40:18 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D4FE8A3FF0
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 11:40:17 +0000 (UTC)
X-FDA: 85273864074.16.5FBF268
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id 384CD1C0003
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 11:40:16 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PUupB5gQ;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790854816;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=R8QnVRuxXx0DRHjhLodBsB0dPH0Vc9e66VDO/VON7WE=;
	b=a5mpv1/Fj2JpOqbVnSd89viQ0W9FIPnGJEHDWNHtcEyCq1BYhJMSREWDODRBz9d5XLLRc3
	ihUckcQyuQnncXY+5JokbZBDO/2EW3sF9u1GVcrQsVERFsKGOyqwt6HAmcQ3Jm+4jYfdFc
	ttRfE2PnpVfCpdpjoSYWW6J4o9OIYak=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PUupB5gQ;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790854816;
	b=jr5GoWAOxXfL7aCq7gfnXXLo316B1abarJcPHwWhrnRIt9HpJNSMmCaZkEYvYN/L0OyIQX
	3QtRHkVQJe+V69RBa2PfWxpMqVOPYmznSWaytuzTvb4gElcxdD4rK0oi14fUt2+QA0W3hl
	ngONXJEmU4EcZ/mAW5ZoeF9TW6DauTk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 9E63E601E4;
	Thu,  1 Oct 2026 11:40:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B055D1F000FF;
	Thu,  1 Oct 2026 11:40:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790854815;
	bh=R8QnVRuxXx0DRHjhLodBsB0dPH0Vc9e66VDO/VON7WE=;
	h=Date:Subject:To:References:From:In-Reply-To;
	b=PUupB5gQlzr+bWtFrTHfgVpwkTN7x++K9kI8wfHEPTjtHMkwKqyI5WDWii0Bkkdm8
	 zc+/P0XWsRcF7derKkF83f7dkkQc1UWQelBTuOtpZ/gyAomoRXsifxd4luvWVBD3ER
	 TNQ2PESLWmY6by6SyG+A+EUs5kmjXWnECiwaagON8c8jwJG3jtik1eKSgLol4paxDr
	 wYHUnf6dCWnKcvULC69CJnKHJRP34dqQqmv3TFIugxWuTWrJDeeDJJV4e6n9vxHzzD
	 srwh8e1g+YjOwg3w4ItlCE5jLfQT8SVJ4wjtkI4PFRLphYU+I+lLPhvTLFJuGLozv2
	 hKJP4P4l3Is7g==
Message-ID: <3e03425b-7962-4c69-93aa-96168fd7168e@kernel.org>
Date: Thu, 1 Oct 2026 13:40:06 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 3/4] kselftest: mm: integrate huge page checks
To: Yeoreum Yun <yeoreum.yun@arm.com>,
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Usama Arif <usama.arif@linux.dev>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>,
 Kevin Brodsky <kevin.brodsky@arm.com>, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260924-fix_split-v8-0-cba7359d882a@arm.com>
 <20260924-fix_split-v8-3-cba7359d882a@arm.com>
 <16f16e77-05ab-418e-ad06-8f48fb29375a@kernel.org>
 <aruMgm8UZ_t2V_wh@e129823.arm.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <aruMgm8UZ_t2V_wh@e129823.arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 384CD1C0003
X-Stat-Signature: sr36mpik1tbemwoq3pe7ffxmrqowdnpd
X-Rspam-User: 
X-HE-Tag: 1790854816-281149
X-HE-Meta: U2FsdGVkX1/MdbxbAFGhW1e03T3cm3+UIwBhqLJmqUfUgxveM6RQ7DLhnYUiyS2Q0rHYFSYCTlZLcZAIFYP65fDVpMy6OQoFeJq2m9xL+H+5qXKASpDYUSFUgRLdFewAO8erpFJP8p4Gefn5azaku/dJsxWU0/apwSqUZ01LRhzeprPGV2D+CPuFqUIjiUgErleZjhhPpwdg0dISLq6E6jgH97lUcVZ+rNsGZ5YYJVGbJtrsRpaihSt6lq0jonGE7OGsJSH2T26F1q2Yv0xcPA3yKbsH4FAr+nrYdALRsKuqsc3Mihv12LFhbGPtJaSweo9Fjh/rFiyX/cpJY4lx6IfFarvCc1mktEGhkB4CNyjuLoJdXINR9lCu2fAutlRBL7iL0K68gV6ACJK2TX3kA8rTVkDPJe8SLpoOyc4UiEptbGum6WDmxmEQAP9bFm4/FQkt5sedVBILSgzmX1L2XdvwcYH6iRaCiSUxbTH0C767TDHQwABIT+qXNOJ4VOCLqK1bA3KdBQMYGTU9/lA4k3IRLh4anLkezz9URg28ABJH3qXIbwJvQWvBsu97VU5XsfagYin49HUYdrnaqiKzQ6oKYPcuQ4lVmvU8TUa/HZPC9rYGTyVLMFPJwUt4dtyHH0OYn1HGexXEK6+Yv0sBCInuc2vQDpptjjN7zFO8612jLzoV3DguyL3fYzH4SLsdSYjHkR4cDux1rRsK0sq8vQMC1jWhdojlIsgLjJusaGky7dGP7nKY0u5wTKmF17kZRFD0j9/2beg3rF0fNGHisI30lU0x9NM+8Hf4zW8sLTIumsDnUva/GWxPQM0wdScpFd2F4Xd10CAsieNk5Qeogegsi2r5jmFUvQAZFGmY5858m82s3/xMPhPNcBbN5VvQq9BiAXCowE0HhzipK1l3LchwnZkHkEDx/3YpmPNPISc3QCjt8/HGc5mxiC4OlPYKIkYHmq3nFgfcfiMY/Ea
 zws2N0cU
 +P49P8xjxRKm0u0Vbr4wK6hVy2X6zaPU8phda7zRviFnpYeWAbyKoNn8DDfwjNr8m/c3ZteQJlS57cmjy/RZVOZU4MrtGi7zl/ZHZM3HAa6uykz7BeVSzRBtMwMvWQfH9XcTb6lPBxTEobljbTLJbBH6y6fOKfgz3PqbHVkg31ZXopVJ3kxhxqXMAEAdrh/0KxtGZ/K56CIgXyw6gz1i1noO96SKYUHD7fFNugqvMQpvIFLCSqP0PJuQxTn5I2YBJgWWjB2zOOh6Df617kmgWSTuuaHzQNaLzxuaDijha+Nfug4GdEb27l/Jy8UhEyU4UHcqFzHCzp+6OA7jmlyK/q+1ihf1+AAGdODfs6GDLVVuvmi8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/29/26 12:01, Yeoreum Yun wrote:
> On Tue, Sep 29, 2026 at 10:07:37AM +0200, David Hildenbrand (Arm) wrote:
>> On 9/24/26 21:11, Yeoreum Yun wrote:
>>> check_large_folios() only checks for large folios without distinguishing
>>> between anonymous and file-backed huge pages.
>>>
>>> To add huge page type checking, integrate the huge page checks into
>>> __check_huge():
>>>
>>>   1. If hpage_size == pmd_pagesize, check PAGE_IS_HUGE instead of using
>>>      check_large_folios(), since only the mapping type matters. This
>>>      identifies PMD-mapped huge pages.
>>>
>>>   2. Otherwise, use check_large_folios() to detect large folios. This
>>>      covers mTHP cases.
>>>
>>>   3. Check the folio flags according to the huge page type.
>>>
>>> Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
>>> Suggested-by: Zi Yan <ziy@nvidia.com>
>>> Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
>>> ---
>>
>> Instead of merging both things (detecting mapping vs. detecting anon vs. file),
>> could we simply perform the anon vs. file change separately?
>>
>> Doing another pagemap walk that focuses on that should end up with something
>> that is easier to read.
> 
> Okay. I'll change like below in next-spin:
> 
> -------&<-------
> 
> @@ -411,57 +400,78 @@ static bool check_huge_type(uint64_t categories, enum check_huge_type type)
>         return false;
>  }
> 
> -static bool __check_pmd_huge(void *addr, size_t len, int nr_hpages,
> -                 uint64_t hpage_size, enum check_huge_type type)
> +static bool __check_huge(void *addr, size_t len, int nr_hpages,
> +               uint64_t hpage_size, enum check_huge_type type)
>  {
>  {
> -       int pagemap_fd;
> +       bool ret = false;
> +       int pagemap_fd, kpageflags_fd;
>         int nr_pmd_mappings = 0;
> +       uint64_t pmd_pagesize, scan_mapping_size;
>         uint64_t categories;
> +       unsigned long pfn;
> +       bool check_pmd_mapping, allow_nonpresent;
>         char *start = addr;
>         char *end = start + len;
> 
> +       pmd_pagesize = read_pmd_pagesize();
> +       if (!pmd_pagesize)
> +               ksft_exit_fail_msg("reading PMD pagesize failed\n");
> +
> +       check_pmd_mapping = hpage_size == pmd_pagesize;
> +       scan_mapping_size = (nr_hpages > 0) ? hpage_size : psize();
> +       /* Some mTHP tests check a partially populated PMD-sized range. */
> +       allow_nonpresent = (uint64_t)nr_hpages * hpage_size < len;
> +
>         pagemap_fd = open(PAGEMAP_PATH, O_RDONLY);
>         if (pagemap_fd < 0)
>                 ksft_exit_fail_perror("open pagemap");
> 
> -       for (; start < end; start += hpage_size) {
> +       kpageflags_fd = open(KPAGEFLAGS_PATH, O_RDONLY);
> +       if (kpageflags_fd < 0)
> +               ksft_exit_fail_perror("open kpageflags");
> +
> +       for (; start < end; start += scan_mapping_size) {
>                 categories = pagemap_scan_get_categories(pagemap_fd, start);
> -               if (!(categories & PAGE_IS_HUGE))
> +               pfn = pagemap_get_pfn(pagemap_fd, start);
> +               if (pfn == -1UL) {
> +                       if (!allow_nonpresent)
> +                               goto out;
>                         continue;
> -               if (check_huge_type(categories, type))
> +               }
> +               if (!check_huge_type(categories, type))
> +                       goto out;
> +       }
> +
> +       if (!check_pmd_mapping) {
> +               ret = check_large_folios(pagemap_fd, kpageflags_fd,
> +                               addr, len, nr_hpages, hpage_size);
> +               goto out;
> +       }
> +
> +       for (start = addr; start < end; start += scan_mapping_size) {
> +               categories = pagemap_scan_get_categories(pagemap_fd, start);
> +               if (categories & PAGE_IS_HUGE)
>                         nr_pmd_mappings++;
>         }
> -       close(pagemap_fd);
> 
> -       return nr_hpages == nr_pmd_mappings;
> +       if (nr_pmd_mappings != nr_hpages)
> +               goto out;
> +       ret = true;
> +
> +out:
> +       close(pagemap_fd);
> +       close(kpageflags_fd);
> +       return ret;
>  }
> 

I'd leave existing __check_huge() mostly alone, and instead have an additional
function that checks the type.

Essentially a __check_type() or sth that we run after the large folio / pmd check.

-- 
Cheers,

David

