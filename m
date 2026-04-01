Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5C6A3107637E
	for <linux-mm@archiver.kernel.org>; Wed,  1 Apr 2026 14:05:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C57906B0088; Wed,  1 Apr 2026 10:05:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C09366B008A; Wed,  1 Apr 2026 10:05:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B1EBF6B008C; Wed,  1 Apr 2026 10:05:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id A0EF46B0088
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 10:05:37 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 345B0E159E
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 14:05:37 +0000 (UTC)
X-FDA: 84610159914.09.2152F93
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id 4A88E1A0002
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 14:05:35 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=okgej+9y;
	spf=pass (imf19.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775052335;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZAj8fPYR8t9QC3/lrLGCsIwWdlo87Q2YfYvBoHcAo38=;
	b=pROWFtoiIxS6VRVCkAm/Yb+4Td9SJJDdKAEwb/eitkoM5BzVnfQFgOgHhizmzXOWhdoTe5
	S1ENQ8tQqlLxdov5wZxTF7tH0MUj1M7NqmZXjrsnwR4LDObM1ziHrF9A4mMtINd9zJ7JqN
	gt5e6ziTIt1AycEMe0YcQgarcFQ8Zsg=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=okgej+9y;
	spf=pass (imf19.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775052335; a=rsa-sha256;
	cv=none;
	b=zZx3Va+t9NBfeSceC9rBc/rw4tcm6SGJNykT/xs8coETr65p1o816P/RM5fK1NvcPfjADd
	eLOjIji/6f0NE9q6Fjdwg6Si6tCQeeNEfke9sTo4AtgCJ07ZWkEO3ZSh/bX78YInowntJo
	6TRyvNjKKixc1YMPwvrMOzex5MM7MuQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 9D818600C4;
	Wed,  1 Apr 2026 14:05:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A9A4C4CEF7;
	Wed,  1 Apr 2026 14:05:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775052334;
	bh=18eng7a3PN7FjoM6NdQpFNVTtE1OZpCZ4zH2G0dIZ+o=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=okgej+9yHEHuMp5ikbtmmnewWHiF7KMMZ4fM8OVjC8xqDnhI0DkQosCa2KAIvYo29
	 pHkodWFZQ5ir9UOmI3Dj3wNHtFn/l3E5JgiM229RpZuVfYkdRYCO0mXrWpRScT7OU0
	 eCb5drED+kOCKwubCdvl8PjwMbYHqOXezSm8p6+PuKf60TsitaPP0NtmPzXEiupv88
	 qLL7xbEGPMIbdVAoMUNV5IugM+UjCPHp9kq4RMsVMgMSq7ihVTY2ICGerKo3GB2UMn
	 kxCwgbRlSHxIi7yJgYwylVsITdutYEs8dsZZdstaqrLM8DWIdzXNMASwTD2i5kGmmp
	 NFKD2rRZk/mCA==
Message-ID: <7bc24281-8676-481b-8c61-1c5cb71068f3@kernel.org>
Date: Wed, 1 Apr 2026 16:05:28 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 00/13] selftests/mm: fix failures and robustness
 improvements
To: Andrew Morton <akpm@linux-foundation.org>,
 Sayali Patil <sayalip@linux.ibm.com>
Cc: Shuah Khan <shuah@kernel.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
 Ritesh Harjani <ritesh.list@gmail.com>, Zi Yan <ziy@nvidia.com>,
 Michal Hocko <mhocko@kernel.org>, Oscar Salvador <osalvador@suse.de>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Dev Jain <dev.jain@arm.com>,
 Liam.Howlett@oracle.com, linuxppc-dev@lists.ozlabs.org
References: <cover.1774591179.git.sayalip@linux.ibm.com>
 <20260327111104.b8bc18be45172639f5b9226f@linux-foundation.org>
 <09104413-483f-4852-9d7e-71e0f86a1754@linux.ibm.com>
 <20260330151125.d0b6cbb24b273bc963b05116@linux-foundation.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260330151125.d0b6cbb24b273bc963b05116@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: i93gpwsfbnxhkgkaof93e5kaoaddfo7n
X-Rspamd-Queue-Id: 4A88E1A0002
X-Rspamd-Server: rspam09
X-HE-Tag: 1775052335-147165
X-HE-Meta: U2FsdGVkX1+PieCxRQxnWSes4xyth/N2vRXeNp+ljEsdp2kBc8Ykfe2DUR5IdSHC4NRAZJiV+M5mmPKJixq6u4Q+JU89bWn3KOPiB6sRRxP+ueYM98hg94ZQq+I9gBD2ngIPQIRz9VktPjToXvF18AeWI5JrbwCAGfOEvnsmk3IQr/1qpW2xUq6nenjhMR/1k7EgoO9R0sBMCyoDsE+tT+zt9ms7iG0NLcbiv4OBGd6kIelGsIswRxFH3YjJjbbtYR+mcD4syWOo2wwrgCPjIZdgr9KiOQRVz1aqC0jrlVh/FEPDR9kSELi7ed5681s30/xDCxaG9lhjcMnAYheVcfLvAz1M7lf35vm+kpsJ2tEFg8UG1mSGkv7ZklBc+b/K7tzBfiovnPfKuq2qx3RWl8AIvSq/bT7oGz2/cANTwTT1yfJbyo+eldi9siv/oq6AqM2T/hDqrW8e4JK5GN/AX5cujyLfwipUgLyGY6Sa5eub+jIo4ihNyGTu/gH5PPIQfj6bFQyTBPyB0bT7KfHFuFcL47YjpLDlO12RH6D6vF02LCgcCVf30Od7a9MGnu0aa9iH+SnjFvsH310JrpKRXPGxJgJv+G1a5/cc9MFVBjCi3ovxO5WjB14ByrsvUWbbvSailtDJUTTX2IOUGekB57oaso0zJ1hvkXXZx81Y9QBG6CNZdkbQ0NrKD+fWQR9GchAxnrFM8nQBzWhDcyCbxDo/6O97VXq5AXOklqviwX2d7UQB4231R4BOJ4kkWfjrtWeWM9QiRvSV9II+1ArfiSqyXcWwmk++uYDhGAOfi12J8l109cxB8vprFGrHE3CPmQFkI6nbFrer9xVXx2ka6ZwRNYJoMlUL3KrMiIuoof0grjHXmHu0bsCc5AR+aVhvgc0dcGkCtBaQYHgGR77wtM68TcQNvBAH73pdPE6Bap/G4fvVW7qMUHeEmaxMo6sUyE/8RgrBqYzuNs+8QPw
 4G1KNbLo
 rUdXJGr8vEchtkxOsgJfjov91CfUJqjojoOK81pRXwYvr/4TDXyuVwTsho055d/82OUsc/A21xuJEbTniLXodSBQJCJ8cJ3qMIEHXJ7O3irQspNmWNVVeq5OQ9tIypa1NAqnz9GpvCOgaDPiLBh30TCWFIOCP7gd8HlpzZ1mi3fAlY8CTs/LF8Vx7FGOd/EuVUYu6vDlP4/lmglh6MGof+tyJEOXaUJQs/ZlS7clRy5W/nCaEO4d+x0HDTnAwbGi9u9YoEzLEPp3Vvs9uidavBJuazxCY0OJAEFacFA3UeqbGCVWuKFZ2rUmAx9fIbbXVVbHLg78SvHYt2rgsO2CT7LYDwFDt70iJYStNWE0NqhIHPSSjY0qPcLZdI9HfdU8X0sEeNmDULyXk4HXy+x2KN2yEwUuW/oaDRaUAmTyHHf1gJt0/tYwr+uRrvY5UEcJQMUDwDqnncxEQ4CnDAFMTwRVUSTG6UZJWaoxg
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/31/26 00:11, Andrew Morton wrote:
> On Mon, 30 Mar 2026 11:27:04 +0530 Sayali Patil <sayalip@linux.ibm.com> wrote:
> 
>>> I don't want to risk breaking selftests so I'll set v3 aside until
>>> you're confident we should proceed.
>>>
>>> Thanks.
>>
>> This line continuation pattern has been used in selftests for quite some 
>> time. For example, a similar usage exists in 
>> |charge_reserved_hugetlb.sh|, introduced here:
>> https://lore.kernel.org/all/20200211213128.73302-8-almasrymina@google.com/T/#u
>> <https://lore.kernel.org/all/20200211213128.73302-8-almasrymina@google.com/T/#u>
>>
>>   echo "$reservation_limit" > \
>>      $cgroup_path/$name/hugetlb.${MB}MB.$reservation_limit_file
>>
>> In this case, it was primarily used to keep line length within 100 
>> characters. I’ve tested the script  and it behaved as expected.
> 
> Great, thanks for checking.
> 
> Series is nicely reviewed and an earlier version spent time in mm.git. 
> And the bar tends to be lower for selftests.  So I *could* break my rule
> (https://lkml.kernel.org/r/20260323202941.08ddf2b0411501cae801ab4c@linux-foundation.org)
> but would prefer not.  What do others think?

I guess it doesn't really hurt to take this now.

-- 
Cheers,

David

