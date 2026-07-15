Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 47037C44508
	for <linux-mm@archiver.kernel.org>; Wed, 15 Jul 2026 04:05:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 404F46B009D; Wed, 15 Jul 2026 00:05:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3DD016B009F; Wed, 15 Jul 2026 00:05:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2F4266B00A1; Wed, 15 Jul 2026 00:05:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0B90E6B009D
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 00:05:29 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 8EE3B80333
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 04:05:28 +0000 (UTC)
X-FDA: 84989671536.04.66B0490
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf19.hostedemail.com (Postfix) with ESMTP id 546E01A0003
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 04:05:26 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=Be6daMTs;
	spf=pass (imf19.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784088327;
	b=Wc4RwWR+Fd1Xiqsx/RVcP75D2iQDnBXtJCjobK8f6pNaHA04pTbEonrRMwAo/86K94yyJs
	P+h1E74Y5uAbMlWXdtQpZwy0iBVCgGMoMZAKgvFuR1BnhmVlOfu+/xacJZE0P9EqbeAq8g
	LEusZxVKRU5Us8NHqDTJQhapneMvih0=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=Be6daMTs;
	spf=pass (imf19.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784088327;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+NKTSivvd/RznSgZgQ5XRa9Kux+hc0gRY6vB/wLL5b8=;
	b=t0WWKKoQlZnvGKcqAe5a1Gs5zXsO6SjCuxWhLSvwia2h0lf6+3HnLCtHVpLpPkNQ92Z+lH
	sUo21A/ZzYA2eWBUPJFS/vnJl7eHWdFsEvzWKO6jL/Fc+s0ZDtzqUaEsyJBH0BxWPFmdBZ
	f30Cfi7ZPkEN0n98YWc6DH5N16iufY8=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7FA7E339;
	Tue, 14 Jul 2026 21:05:20 -0700 (PDT)
Received: from [10.164.18.40] (unknown [10.164.18.40])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D24F23F7D8;
	Tue, 14 Jul 2026 21:05:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1784088324; bh=JleE5ZWx9SjpMJn0oHA2QSPbxd8mp4PaHdJxoION0bY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Be6daMTs1IbU1CSoetXmxbaEoBz8AoymrrC01Gu2ZMKnuQTFZg2itQMyvkNGJewjG
	 W00xD+NdY68zakgWc9vHhmLYz2D0EOw8R5GaE/MwzP4v6IMDxG+eCYgDl+6Ojz1itL
	 dUS8pwTSACiNa/1z7jgbTix7dOW1TdVfVZn1Jrzk=
Message-ID: <90194352-7389-4942-a33f-37ed4df7c51e@arm.com>
Date: Wed, 15 Jul 2026 09:35:18 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 0/6] mm/vmalloc: Speed up ioremap, vmalloc and vmap
 with contiguous memory
To: Dev Jain <dev.jain@arm.com>, Wen Jiang <jiangwenxiaomi@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: catalin.marinas@arm.com, linux-mm@kvack.org, urezki@gmail.com,
 will@kernel.org, Xueyuan.chen21@gmail.com, ajd@linux.ibm.com,
 david@kernel.org, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, rppt@kernel.org, ryan.roberts@arm.com,
 Wen Jiang <jiangwen6@xiaomi.com>
References: <20260709073823.6643-1-jiangwen6@xiaomi.com>
 <20260709160805.26e63bae89dd03cf2951104e@linux-foundation.org>
 <CAHKocdH5kp5kTtZht+v5j-4-Thh40TGvif3=kRMgErRXr+Q+RQ@mail.gmail.com>
 <929dedc2-eea3-4153-be6d-d2dd727fed89@arm.com>
 <a08e2a7b-2ab8-4429-8d4d-9c13b6a2a77b@arm.com>
Content-Language: en-US
From: Anshuman Khandual <anshuman.khandual@arm.com>
In-Reply-To: <a08e2a7b-2ab8-4429-8d4d-9c13b6a2a77b@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 546E01A0003
X-Stat-Signature: o9gdxwdbobp7u7bye4kpaapgjjwr1cek
X-HE-Tag: 1784088326-321424
X-HE-Meta: U2FsdGVkX19NzeK08LcbaffvEfwKyJ+Z/Ky/AaqGg/HV+LE6iP3Q2VVxX571aNMded1mkZnjPwtugJ8eQhlBCQIrkn/au2KzhGCMRJSeY2suwTA/1kW6QQjbIAve57xy/uuSmstfyyrJxOwp/c8cYedkqtTBECX8LCPQ+HOmJqvH09gSRgeQiNAbEOjL0ozYMzyPU/7U1qfBCqiUuXhNuKxv5lOdFSTlI3ZJ9EQvrL8wGglN0L4MyN/7U4uJy4cgypVZxV6ifJv4nhsmoiVbJD/HCKj6Yhe1MhXCkOrQcvQSrDbLQUB7V41RPtDC4crs04s0QrlH/3NuUx3WWZtrI7fhyzABg7NyA9GTjzg31zkJEtQI/Angxgrg6cyDz5TZOl91UsuZKozi0Nsj14TslRDp8GJypWe6gDbiY+Crn1FPtEIjWhpr2sDrc45KGHErLHbN+o0BhJXIVzMk1OzHQJgn0zF/tur6HY/D0epv6/SUtHmgLGvT4LoobnlrCaQAQx9Pu2NuTNYdOw0xzeU8OinpofkoI8SPSzHjdjRYjdZsu9UYQ9qGk+Rl/40u8Bfq+Lh+1iI8J+3DBs8HN2xwrmHwfdh7dqqshOBcKyu2Oev6BmzxCpe4ufbkMA5lmRijdxQvGdhRceRYzK6BDpL2ngb1XUwM5ZfciEQGgBZbmbYRrnIvc2bsyg7WMpuSjeDfze5m2HESpnDusLE8uwdXq8L6oWg2SPlLZFeImFwSCbZnX6zUhbwF/wplIY7Td3N+/1RNDYQ3816mIqvW7fMjEVJnOzitsbEfZs4fzfN48eDOMbm/PLp4mVlO+Kmo1mLkN7At2BlgeppErxzD5m1aEPRKDPECiLqvGGuSzWfVDMPSXA6DBCz5SAlc8l+3J/CVtXUjOT52e5P0S3STsb1FYz1pPlwK4AyOGMHI9FN2nhqb4X4Buf8VBwHOuxEPOClP5WjFwbCbgTDkUbF2slB
 K0F06P1/
 nJBXjO8fcYzTBNordHsBDvUS0nB+KvqDzcZyi/FN2WeBJ8S5PB3hXqQ55HK7wqZCjJ2gm/9CTcQNrs6cL6slLTOrshyIcaunvCnRfxs0M/5dBjyMuoKuRPgrvlRGkmmmG6uO//2neeAc50ZLkyiPmJMEMQS2d/hHtGy7IuwvTi72Ov2A20H5i1ytB60FCwfjN0B+i+9NPNoKDxe95LuM+yMQF7/R1PRXyT64XDDh4qXGQ8lgOu9d90oHCzOEf7VyeNDziouDadT9MNJLiwE8nmU0hWGufDN0BQAcfWyUpXcP7lS1eOl5kWfyfYgta5qwyfNO/0G357OsGnAQgJC9Hg+U0Cm9UEA+GFpyGKW+UxnAEOxRX92NLfueo6fgg6Ni+akVykGowHSJgpxjW4kw5ASbZLSoceADlPN1ly5jbmhJNa3CK/6ldhXE+X8DbXORC/A0qXcOJzCRAlWqg1dTuBiwZCQPIVcKq3AMu
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 14/07/26 4:47 PM, Dev Jain wrote:
> 
> 
> On 14/07/26 2:06 pm, Anshuman Khandual wrote:
>>
>>
>> On 10/07/26 2:24 PM, Wen Jiang wrote:
>>> On Fri, 10 Jul 2026 at 07:08, Andrew Morton <akpm@linux-foundation.org> wrote:
>>>>
>>>> On Thu,  9 Jul 2026 15:38:17 +0800 Wen Jiang <jiangwenxiaomi@gmail.com> wrote:
>>>>
>>>>> This patchset accelerates ioremap, vmalloc, and vmap when the memory
>>>>> is physically fully or partially contiguous.
>>>>
>>>> Thanks, I added this to mm.git's mm-new branch for wider testing.
>>>>
>>>> AI review asked some questions, and some of them are new since the v5
>>>> series:
>>>>         https://sashiko.dev/#/patchset/20260709073823.6643-1-jiangwen6@xiaomi.com
>>>
>>> Hi Andrew,
>>>
>>> I've gone through the Sashiko findings:
>>>
>>> - Patch 1 (find_num_contig): Over-interpretation. No new hugetlbfs hstate
>>>   is added. The extra sizes are only used by init_mm kernel mappings via.
>>
>> But not sure if that is a right approach. If these multi CONT_PTE
>> sized mappings need to be supported in vmalloc() but without adding
>> corresponding HugeTLB sizes, probably these required helpers could
>> just be factored outside HugeTLB.
> 
> The problem is that the existing vmalloc-huge code reuses the hugetlb helpers
> because it is easier that way.
> 
> If you really look at it, num_contig_ptes(), set_huge_pte_at() and arch_make_huge_pte()
> do not have anything to do with hugetlbfs, but with huge mappings. It is unfortunate
> that these helpers are sitting in hugetlbpage.c . Really these functions should be
> pulled out of CONFIG_HUGETLBFS and put into some common header - but I can't think
> of a clean solution to this.
> 

set_huge_pte_at() and arch_make_huge_pte() are provided by subscribing platforms
to be used in generic HugeTLB. But later these callbacks started getting used in
generic vmalloc() as well. Although arch_vmap_pte_range_map_size() first narrows
down supported size from HugeTLB list. Basically vmalloc huge mapping support is
still a subset of HugeTLB support. Hence we should not add new vmalloc based huge
size support without first adding that up in HugeTLB. Otherwise set_huge_pte_at()
and arch_make_huge_pte() need moved outside generic HugeTLB as well.

> So I think for this series, the least we can do is add a comment to clarify that these
> helpers can be used by non-hugetlbfs mm code to set multiple huge mappings at the PTE level.

For these helpers to be used outside HugeTLB (without prerequisite)

- Move them outside generic HugeTLB
- Drop #ifdef CONFIG_HUGETLB_PAGE in vmalloc.c

Not sure if a comment would be sufficient here.

> > 
>>>
>>> - Patch 5/6 (NULL page): Invalid input. vmap() expects a fully populated
>>>     array of valid struct page pointers.
>>>
>>> - Patch 6 (32-bit count << PAGE_SHIFT overflow): Pre-existing. This was
>>>     already discussed in the V3 thread, and a separate fix was proposed
>>>     there.
>>>
>>> Thanks,
>>> Wen
>>
> 


