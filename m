Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 57104CA5FD2
	for <linux-mm@archiver.kernel.org>; Thu,  1 Oct 2026 20:00:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4400F6B008C; Thu,  1 Oct 2026 16:00:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3F2266B0092; Thu,  1 Oct 2026 16:00:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2DF886B0093; Thu,  1 Oct 2026 16:00:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 032436B008C
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 16:00:09 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8050040523
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 20:00:09 +0000 (UTC)
X-FDA: 85275123738.18.36A63F6
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id ABCDC8000B
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 20:00:07 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kQZzHCFH;
	spf=pass (imf30.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790884807;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uiy9BQNoShvervfQY5IpdBiMD4LpkWUHwQvhiosijDI=;
	b=DE7qPzZirsA8HcjvLXi2I5sbl/LuMdaIL8gmvSX11H9gDkiC3bE6kug6IliE1vWATqbDps
	W0ZkK8U0Z43/Jq+VMJ9EZgl7DSJnaJqqd7zmvhQg6/sA5vLQfrIgPI6o9a8irtP1LCkwrx
	yg+A3HU3I4SrHokjODXqocGz6g6Zfdg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790884807;
	b=8GnvKctPa9Bfb3IRi39CAk2b8NK4j1CVdHTLlHhVCfWIFZV5FHuP3027hSiSaKLwT/Gf+3
	JhakUq9IWTOZhrvF9t10z5wPEvKLkTkzA4fa+7YN1iiqnd6ZRmo8S40Fbe39qVBCJrIxkO
	m6tljo4mBzytTC6eqwuIWPoB04vBzw8=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kQZzHCFH;
	spf=pass (imf30.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 2D36A602BA;
	Thu,  1 Oct 2026 20:00:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6121F1F000FF;
	Thu,  1 Oct 2026 20:00:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790884806;
	bh=uiy9BQNoShvervfQY5IpdBiMD4LpkWUHwQvhiosijDI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=kQZzHCFHEP+TTv4mj08h4QAEiWuMu20ydvBhcWwogSrpmEJttpYxip+BdOYU5VzM/
	 S+rk0fYkz6Sp9nV1+lz0q5jjMZ5UZSbxnq5ARISEsxwDHaDY36Hb+Rn7b/5moOaK0Y
	 vjYJcrbxE7raQQr8ptYJVOovN+ZALhSFAyEjrCorWd7jiGGwMVAlaphP7I2udxcVZb
	 JrISR+IRXQq8L3Site0mF+aVmoCdkVFwmwGVq86Q7F3yu9u6Xq6GqkMrS131dDySl/
	 mC6SL4B3P49PASoEHa9ZyMbX3m0ceQ+FU19PsItK+eeU0VgKTlzXtH5s86d/Uoqm2k
	 DDckkQTEX1Lug==
Message-ID: <a3a4ae76-c09d-4e9a-a84c-acea6f5fc437@kernel.org>
Date: Thu, 1 Oct 2026 21:59:57 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 3/4] kselftest: mm: integrate huge page checks
To: Yeoreum Yun <yeoreum.yun@arm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <ljs@kernel.org>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
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
 <3e03425b-7962-4c69-93aa-96168fd7168e@kernel.org>
 <ar5lhhdKlK6NwX19@e129823.arm.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <ar5lhhdKlK6NwX19@e129823.arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: ABCDC8000B
X-Stat-Signature: 5o8691qw8duuwef64rawimmns3h7t4ro
X-HE-Tag: 1790884807-16502
X-HE-Meta: U2FsdGVkX1/ByYGBoA/xVLRtZrXv7Dwf9kUMNc3hpGGnJWOLI1NXHVoY+I6zgEVjQ24HoubZYUjgKuXIXyYHsAOwtdhrlYPL9jDh+W8xSnIoGqSJRzeMDIzq05xEifucip3mHcB4DtNcvEFcmtRbvC8pF4ORci4llwJePrHgJWbHYnkCY2AKfNvgXmZD8MkONjjs2O7+FQMiIvMRIWyYFBynq8gPKUrOEsNfm3W+Hx4PIfZkxAohQITzWRT+3eVvzJYPetItlipUp7c8TUfLoqp3H5P1i1mECIaVwTngyROwQKHho8CgWrc/rCw+D4QPoHWRz3jw/eKS4NJmqHLyUxEBpq6s6ESbxdEVh5ZVkhx4OA5CouUwxe95TbLMChdClLOm4hsZ+x1l75QDtAtaCMdpAG0WHInSMn0uhRgxEhyCp3e/tCqUC9PJqiyc6XBukwHRULFqsXwdFdex5o4lfHxpqqNlz9PHFPi4kP9GK0Lbykdy+BGM5PyMC/fzxPCXCF54EFHATtuz4hksoCdHXGIkBMvUUNMnUKFT7AQVyCJvaqbJ1NDfoLdpw1+Uoq3bvdfSHHQJ4lrnzcc4skg60tmZ4O00TmyoKzKqW3jpyTSM5MTSkEu9WOEcvN7eOJFFMIzsH4ThZlO9yTpr7A6ZVzxDLyJ+yk1MFP76JjixwYkhsfNmLOmydpHSAsUcl1UnGv9hxJeJkRzO6uRXFT6Sb/VNDCTc/epf6Bcj1WVDUdx59EysFL8LnPAOMt0oqQJTS5CjVgRrraVkP59QACZNQaUYt5tYNXRuww9mmd1/zfFEw2IMSr9pkqCYAYlICc93gwPruOZzzQmteUkN+eO2Fw4S87ZvX3hGbsR+uQ6U/EWu04dh4PPaco2bGQQXkbhoFqVw2Dpj5YjrrKTMkKVikTJTM5tdWJGBVjlZZt2koILArZc5qcDgt1FpiLU35gZr4JlENAjAULURbxE/HlE
 d/WPXTNl
 OHmu1QpDtwlyPNNnc9nsqnEVDnZH3auJw1+VKXCtClElZ4GEuV3NbmN/hzX3IJk12p4DSz8+rhKLdJHRb3Kye3OE09cgc1cqPnvsFCorh5lWCdyzNrESRq2VRdw9wOqyvxpLTUM0TFTfHWkOoS7m0DEs8k2zh15LJpeBM9C4YWyjrNPeOBtBoXozs/BqCs7uJ7KUMyZaTHA0IgpFn/TuM1nug18hDIxCkZZzr2OfVmNnxnarPzaLT4UeRTR7juFYOLs69
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/1/26 15:52, Yeoreum Yun wrote:
>> On 9/29/26 12:01, Yeoreum Yun wrote:
>>>
>>> Okay. I'll change like below in next-spin:
>>>
>>> -------&<-------
>>>
>>> @@ -411,57 +400,78 @@ static bool check_huge_type(uint64_t categories, enum check_huge_type type)
>>>         return false;
>>>  }
>>>
>>> -static bool __check_pmd_huge(void *addr, size_t len, int nr_hpages,
>>> -                 uint64_t hpage_size, enum check_huge_type type)
>>> +static bool __check_huge(void *addr, size_t len, int nr_hpages,
>>> +               uint64_t hpage_size, enum check_huge_type type)
>>>  {
>>>  {
>>> -       int pagemap_fd;
>>> +       bool ret = false;
>>> +       int pagemap_fd, kpageflags_fd;
>>>         int nr_pmd_mappings = 0;
>>> +       uint64_t pmd_pagesize, scan_mapping_size;
>>>         uint64_t categories;
>>> +       unsigned long pfn;
>>> +       bool check_pmd_mapping, allow_nonpresent;
>>>         char *start = addr;
>>>         char *end = start + len;
>>>
>>> +       pmd_pagesize = read_pmd_pagesize();
>>> +       if (!pmd_pagesize)
>>> +               ksft_exit_fail_msg("reading PMD pagesize failed\n");
>>> +
>>> +       check_pmd_mapping = hpage_size == pmd_pagesize;
>>> +       scan_mapping_size = (nr_hpages > 0) ? hpage_size : psize();
>>> +       /* Some mTHP tests check a partially populated PMD-sized range. */
>>> +       allow_nonpresent = (uint64_t)nr_hpages * hpage_size < len;
>>> +
>>>         pagemap_fd = open(PAGEMAP_PATH, O_RDONLY);
>>>         if (pagemap_fd < 0)
>>>                 ksft_exit_fail_perror("open pagemap");
>>>
>>> -       for (; start < end; start += hpage_size) {
>>> +       kpageflags_fd = open(KPAGEFLAGS_PATH, O_RDONLY);
>>> +       if (kpageflags_fd < 0)
>>> +               ksft_exit_fail_perror("open kpageflags");
>>> +
>>> +       for (; start < end; start += scan_mapping_size) {
>>>                 categories = pagemap_scan_get_categories(pagemap_fd, start);
>>> -               if (!(categories & PAGE_IS_HUGE))
>>> +               pfn = pagemap_get_pfn(pagemap_fd, start);
>>> +               if (pfn == -1UL) {
>>> +                       if (!allow_nonpresent)
>>> +                               goto out;
>>>                         continue;
>>> -               if (check_huge_type(categories, type))
>>> +               }
>>> +               if (!check_huge_type(categories, type))
>>> +                       goto out;
>>> +       }
>>> +
>>> +       if (!check_pmd_mapping) {
>>> +               ret = check_large_folios(pagemap_fd, kpageflags_fd,
>>> +                               addr, len, nr_hpages, hpage_size);
>>> +               goto out;
>>> +       }
>>> +
>>> +       for (start = addr; start < end; start += scan_mapping_size) {
>>> +               categories = pagemap_scan_get_categories(pagemap_fd, start);
>>> +               if (categories & PAGE_IS_HUGE)
>>>                         nr_pmd_mappings++;
>>>         }
>>> -       close(pagemap_fd);
>>>
>>> -       return nr_hpages == nr_pmd_mappings;
>>> +       if (nr_pmd_mappings != nr_hpages)
>>> +               goto out;
>>> +       ret = true;
>>> +
>>> +out:
>>> +       close(pagemap_fd);
>>> +       close(kpageflags_fd);
>>> +       return ret;
>>>  }
>>>
>>
>> I'd leave existing __check_huge() mostly alone, and instead have an additional
>> function that checks the type.
>>
>> Essentially a __check_type() or sth that we run after the large folio / pmd check.
> 
> So, You mean like this?
> 
> -------&<-------
> 
> -enum check_huge_type {
> -       CHECK_HUGE_ANON,
> -       CHECK_HUGE_FILE,
> +enum check_type {
> +       CHECK_TYPE_ANON,
> +       CHECK_TYPE_FILE,
>  };
> 
> -static bool check_huge_type(uint64_t categories, enum check_huge_type type)
> +static bool __check_type(void *addr, size_t len, uint64_t page_size,
> +               bool allow_nonpresent, enum check_type type)


As discussed off-list, maybe we can avoid the allow_nonpresent handling!


-- 
Cheers,

David

