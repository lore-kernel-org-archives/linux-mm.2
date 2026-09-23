Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 49116C98304
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 21:57:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 23B1E6B0092; Wed, 23 Sep 2026 17:57:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1C4896B0095; Wed, 23 Sep 2026 17:57:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 08BD66B0096; Wed, 23 Sep 2026 17:57:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D0AF26B0092
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 17:57:44 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 58D1B120151
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 21:57:44 +0000 (UTC)
X-FDA: 85246389648.18.2C63043
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf31.hostedemail.com (Postfix) with ESMTP id 9503B20003
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 21:57:42 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UlRCpIiu;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of chleroy@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chleroy@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790200662;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8M+UT7oIyha+XPFScsNzmi18L28ReOVLoc3XQz11GVc=;
	b=XojF3oKaZcYVsft922dnoe+zL6ZmuAGaufAoiz0zGQhvswCG54xEpUrzdkr5LTRXf6yBrm
	Urlkq41YmJrYxIW8EajsQpZTMMv6VlR5vmKw5gnMT4eNGUr+azFrkRkICV1WEcYT8jw8BB
	0nl/q4pouxjMfh3ALjM25qjrS2KN+so=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UlRCpIiu;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of chleroy@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chleroy@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790200662;
	b=otfxbQRYlp7BEzQh2wLjyMR6VuqHfUQDyV8kik3/vB9RAlFkI1L/3W5hJz+w+dwvUj7uoZ
	F7nK19eYOBKnqLyJrpkJNJJejCfN6UQ5odW/mUahaBMKzXkAVSJ5EZjOBq/Ec/xKUDqB0a
	Tyie5QWP1gkUUlkU0ZQqw4DZTB6qQBM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C8E8C43F16;
	Wed, 23 Sep 2026 21:57:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E64F1F000FF;
	Wed, 23 Sep 2026 21:57:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790200661;
	bh=8M+UT7oIyha+XPFScsNzmi18L28ReOVLoc3XQz11GVc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=UlRCpIiuV4BL8JAAastxBfA9AqVs0ltc4wCol3mQOA0gLZjTyueHPUzDfkomWqfcu
	 vpR5AZPTtAEq8u8eSrNmhkr+1CMQCTroungYOMyBMU32U2CLz6KVXjlWqsLSI8bR6S
	 wP35XQ0D+0tN2X9HGw/1WDk6TQFINV9Nk3VDmxB8pRzxfOrvcjXU2KNpiq4TgP+2pl
	 ygpXh/ifYG/6W3V00QmeW4/BAs7W2rOQMFTUC0RlwS5eMPL8R/2vlpijuJKJ/F+yA+
	 MDkFmyaiUsbKOg26ABOc+B4X0L531YtjJ1pdd1hXGLbmJLpqc1OPuXWPqBU7xsqBdy
	 Cg9pPN+qNyR9w==
Message-ID: <f95ccf9c-c366-48d6-ac9f-c97546b9b543@kernel.org>
Date: Wed, 23 Sep 2026 23:57:31 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 03/10] mm/vmalloc: use pte_set_huge()/pte_clear_huge()
 for PTE-level block mappings
To: Barry Song <baohua@kernel.org>, Wen Jiang <jiangwenxiaomi@gmail.com>
Cc: akpm@linux-foundation.org, catalin.marinas@arm.com, linux-mm@kvack.org,
 urezki@gmail.com, will@kernel.org, Xueyuan.chen21@gmail.com,
 ajd@linux.ibm.com, anshuman.khandual@arm.com, david@kernel.org,
 dev.jain@arm.com, jiangwen6@xiaomi.com, leo.yan@arm.com,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 linuxppc-dev@lists.ozlabs.org, maddy@linux.ibm.com, mpe@ellerman.id.au,
 npiggin@gmail.com, rppt@kernel.org, ryan.roberts@arm.com
References: <20260923062832.479455-1-jiangwen6@xiaomi.com>
 <20260923062832.479455-4-jiangwen6@xiaomi.com>
 <CAGsJ_4z-oqoxKynRr6mz0-5zZU_2NBnPkwz05CEEHHnwTyqa-Q@mail.gmail.com>
Content-Language: fr-FR
From: "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>
In-Reply-To: <CAGsJ_4z-oqoxKynRr6mz0-5zZU_2NBnPkwz05CEEHHnwTyqa-Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Stat-Signature: sbnf44qnabn5q7u7wbb3mpwjmdmhgobc
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 9503B20003
X-HE-Tag: 1790200662-288688
X-HE-Meta: U2FsdGVkX1+XGj2i1ARE8bFAfQxQstpkCTKtTFG9Ln5rTE72tbzETvdutfrN2l4Y9LtvdGGFI1fAUI17GlQyEzN9p3dTr6H5UFHC+y+eCyyBmCzy3tlyEQPaCoGh99OigiSQkJjQnV2wnx2i2PITzZDdC4CtYBe25JC9A+dDQl7X1oesOpHU9LrEVIRO+nVeoZfZG5puaE/ktB6ePPgGTxwQqjm+FG21QVdRhjsUEVgSwiTpN4ZZSV06p5FmfMvxZnH09RNnj0UxEb3U2sV061vD4/tyt1wLemTiNlJVznS8Im1cATRvIQoou71j81Nv0alf8o+z8qqUzW9atp/RImLKY+y+VMF7M11QzcUr7dTUo/8AcNHAcKqJsQw6UedyXc5EIuk8GheyduFq6K5JUHDElxXenUeFDIrqL2CLADhUvZco/8jL9hr92kwVGYEspNb2RW/fR8DNF35QFONKvwevclzxcgxiYADHgHSw5nr0GkKm7GHEwyBGCCnyOW1pML/YtRaqaJ7ncfIWp7uEin9vGrLzjl8h2poJiKIvd5RdqhNgomdUvaJKdxQgVAqyDAHPOMeR5COF6qUMC0HI1oEgeRt3FF7Pm/6I10Coe8S8VQQ3iV12KU7g30T6Xrty99AAzfYBVTAc6MyCNoxyo70eI+GhIjSXymil+2BR0OZ7syC+WlKz6QWRO07B3nS/LN/gJjLV7juMBXmD5XbD2QN9Z8HC79A8z51kDzHKtaQvE7CUMaQEonoDlmI2pqF/knBZ39ZQN/aGZtCPl8xZyYDRbcciwANsgEwukrECzWkRo36koJhn3aqKOM9OI5xrW1ucCJYE0YFUClg6YlcKkJin+6Y3I7SOII00dtgluhf3sz1Jt+sTQBxlOybdnYXhkGKUMQ2rYGTBGvGFNgopN+aAvldKXaX1nzZ4rhoeri1yuUjX9ewqj0YqDxFZcL11LFGtC0u4jcZsTnVzcr2
 XltBfAJc
 SnBGPT/jtlgFxF5EWIt2psKPdJrEbq6kd6PYOPY5pQWzYrDRY/bz4uBjdaSgg2H9ythYi8Q2qbeGN/5H8EsOCwFgTgYoiHdd+XFV2QXXSQqcxuMcbXvVFRM+m2orSSFaQRPyxjO2/ezlF/ZGGUb4KulYZOAQAvaPkxlWd6ZtmcgkwNGUmCqAc9hE81FY74hHmwKjKOaOnmMV0/w4zzMaFVfbg0p8yR+pPKZGb7iswPik5ffshNZ/miRHgh0WKpZIMc0UGaVgIr2M/mjfacxY/oJaKl2fui2ElQV+J0jIP0+YFkMxovxZKs/40sxhbb0ht9gug21Bad2PzuMPaE1kJ70R+qQhoN22j80A0y7CuI9bT0w4Lr8ppVGBQ1j9/P4wOMZXckxr9S6lhxeBSXWZmVwCh9rZcw4DZHOINwjugYJs9ksDZI+iNOfzbu79PW+98csvsVCQj2NsGUI1kxOAlRtl67QlB0P/jlrF2
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



Le 23/09/2026 à 23:38, Barry Song a écrit :
> On Wed, Sep 23, 2026 at 2:28 PM Wen Jiang <jiangwenxiaomi@gmail.com> wrote:
>>
>> vmap installs PTE-level block mappings by reusing set_huge_pte_at() and
>> huge_ptep_get_and_clear() under #ifdef CONFIG_HUGETLB_PAGE. This makes
>> the feature silently unavailable on CONFIG_HUGETLB_PAGE=n kernels and
>> couples mm/vmalloc.c to HugeTLB internals it does not otherwise need.
>>
>> Now that arm64 and powerpc/8xx provide pte_set_huge() and
>> pte_clear_huge(), add the generic fallbacks next to the existing
>> pmd/pud_set_huge() family and convert vmap_pte_range() and
>> vunmap_pte_range() to the new helpers. The CONFIG_HUGETLB_PAGE guards
>> around the block-mapping paths are dropped, so PTE-level block mappings
>> now also work on CONFIG_HUGETLB_PAGE=n kernels, and mm/vmalloc.c no
>> longer includes <linux/hugetlb.h>.
>>
>> The fallbacks exist only to keep the build working on architectures
>> without PTE-level block mapping support. They are unreachable there:
> 
> Since this is a `BUILD_BUG`, can the compiler simply eliminate the call?
> I guess the build would still pass even without the fallbacks, so this is
> more of a build-time check than something needed to keep the build passing?

Yes and that's what the compiler does, it eliminates the call.
The BUILD_BUG() is there to make sure it does eliminates the call.

The build won't pass without at least a forward declaration of the fallback.

In the old days when BUILD_BUG() didn't exist, the trick was the declare 
the function and never define it. But with that trick the problem is 
only detected at link time. With BUILD_BUG() the problem is detected at 
build time.

> 
> Am I missing something?
> 
>> the callers only run when arch_vmap_pte_range_map_size() or
>> arch_vmap_pte_range_unmap_size() return a size other than PAGE_SIZE,
>> which requires an arch implementation. BUILD_BUG() makes that
>> explicit rather than silently doing nothing.
>>
>> Signed-off-by: Wen Jiang <jiangwen6@xiaomi.com>
> 
> Nice to see that `#ifdef CONFIG_HUGETLB_PAGE` and
> `#include <linux/hugetlb.h>` are no longer needed in `vmalloc`.
> 
> Nothing concerns me except for the changelog issue mentioned above.
> Please double-check whether the changelog needs to be corrected.
> 
> Reviewed-by: Barry Song <baohua@kernel.org>


