Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EC95CEEA84E
	for <linux-mm@archiver.kernel.org>; Thu, 12 Feb 2026 20:13:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F109E6B0088; Thu, 12 Feb 2026 15:13:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EC74F6B0089; Thu, 12 Feb 2026 15:13:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DC5F46B008A; Thu, 12 Feb 2026 15:13:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id CA0516B0088
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 15:13:46 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8EFC0140282
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 20:13:46 +0000 (UTC)
X-FDA: 84436905252.27.BD4B2D9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id AF2B6140007
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 20:13:44 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LpWR43F9;
	spf=pass (imf23.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770927224;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IcOFYUdaWh0SRfBwE4phYoDqNtv+2Nrr+GeOqaQ2/Do=;
	b=XZJz0YLBd5ZXfxrCrM/ORUD3RpdvFSuAn0l4w4YX6WwKzfTRyPiMBwRs/6lbRFmsSHii6+
	eMuMVDlsL/ah0ynen8tuwUGLCqPYGQCjEsjR3pBqEvImZT/hYT0sM9WN04EGM8fQbf8pkU
	A/+uxM8UrG90ClML0SfcCIh7EPbSRCU=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LpWR43F9;
	spf=pass (imf23.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770927224; a=rsa-sha256;
	cv=none;
	b=mlQ81BlOD1L/A+nwj5wyXa9ito8kd6xcjA+DNrFQ1yjnBk5t+uAfXxtLrZdFnj0lv2a/jd
	z9gSmHRnvFFvT4J0lVM54F4wiKZDTBW331ZSX4q1rYYoW8nD2cFR5hhiOpYTMBKTb/yOTn
	OAoJUeIR4C87rbFb6m/deJy5wUQlOoY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 71F2444338;
	Thu, 12 Feb 2026 20:13:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F820C4CEF7;
	Thu, 12 Feb 2026 20:13:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770927223;
	bh=PRhxMjd9z0vMov8ARGr3CMdfoqkeeAg10tB8JiIftfM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=LpWR43F9hquCPkE/fuRAr/7u3FSeCqf2wjV+XkSXXm6oeymE5Fj9Wup2x1RkIlqdd
	 EiVRIyKO/uSb5Nj3jcZr0X/wLJsC88vY5zBKaXIn7dD8YA2PDRqXrOMl/VH4OigS4h
	 5S0o03LKKfqJUHW8yMmG8lIppu4thk95FB5aLTYW7JKJmCkNE/tn+OCmy2dvEEV3MV
	 WY2SYXcG7D1CWXVh81g2uicXW/8DYS2b/Odd7UtpKegga+28jO+BQCd74+Zn3QpghJ
	 rCVtXMm/MLDK6bKRVhU4WpzmDi3rfVwgbK6wkO1FZp2sCLsXtmREfdxkaDgLbpf7ka
	 BEH81+FmWjrlA==
Message-ID: <f348e466-cebe-43f2-ba8e-6ceea16955e4@kernel.org>
Date: Thu, 12 Feb 2026 21:13:28 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH mm-unstable v1 1/5] mm: consolidate anonymous folio PTE
 mapping into helpers
To: Zi Yan <ziy@nvidia.com>, Nico Pache <npache@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, aarcange@redhat.com,
 akpm@linux-foundation.org, anshuman.khandual@arm.com, apopple@nvidia.com,
 baohua@kernel.org, baolin.wang@linux.alibaba.com, byungchul@sk.com,
 catalin.marinas@arm.com, cl@gentwo.org, corbet@lwn.net,
 dave.hansen@linux.intel.com, dev.jain@arm.com, gourry@gourry.net,
 hannes@cmpxchg.org, hughd@google.com, jackmanb@google.com, jack@suse.cz,
 jannh@google.com, jglisse@google.com, joshua.hahnjy@gmail.com,
 kas@kernel.org, lance.yang@linux.dev, Liam.Howlett@oracle.com,
 lorenzo.stoakes@oracle.com, mathieu.desnoyers@efficios.com,
 matthew.brost@intel.com, mhiramat@kernel.org, mhocko@suse.com,
 peterx@redhat.com, pfalcato@suse.de, rakie.kim@sk.com, raquini@redhat.com,
 rdunlap@infradead.org, richard.weiyang@gmail.com, rientjes@google.com,
 rostedt@goodmis.org, rppt@kernel.org, ryan.roberts@arm.com,
 shivankg@amd.com, sunnanyong@huawei.com, surenb@google.com,
 thomas.hellstrom@linux.intel.com, tiwai@suse.de, usamaarif642@gmail.com,
 vbabka@suse.cz, vishal.moola@gmail.com, wangkefeng.wang@huawei.com,
 will@kernel.org, willy@infradead.org, yang@os.amperecomputing.com,
 ying.huang@linux.alibaba.com, zokeefe@google.com
References: <20260212021835.17755-1-npache@redhat.com>
 <20260212021835.17755-2-npache@redhat.com>
 <048C7077-3E54-4DFE-A25D-05D3CCB132D6@nvidia.com>
 <CAA1CXcDNX6g8c09q=oaW6RdPYrpEfZP-Hk2rXo-2XqREm68Twg@mail.gmail.com>
 <079A6B19-00E6-4895-AFF7-3F7CEED4170B@nvidia.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <079A6B19-00E6-4895-AFF7-3F7CEED4170B@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: AF2B6140007
X-Stat-Signature: pgnem93jsa8hhcqjy41t1sytucejs1nb
X-Rspam-User: 
X-HE-Tag: 1770927224-53498
X-HE-Meta: U2FsdGVkX1/LqMe5AoA5XOt3SOquVnNDWJ++Zqkh//48ihPueOYglesklMv50/JfozgHlDL9xvFrV+Miw5CLBh6vW3Dz5BQwxcKeV+mH+V7SYiZrkNNow4W7fi9Ic9Zn/xjiSQnGutJfKzss4HnI/fUrRf4J0nFTxspvHOykxzl181Iios6fhr5GSfMzr2bbozd4vYRKTalNaOJAgbQy9wJ2njh9QN5LPlZ2GbkGGKRxUEzj5SoLzNlDJaKodk778DEWGLucxqeURBl+F8ZP9t+Y0FNiSxSEIGaXmijtGSFQB17eii1lzWvowJeHW1UT7uoymYItH8WRlrDywA76T54BsIjBtg/gO+iZ+BXKx7QI/18/zyVrKMuQjztpbon5QflqxP+jB/SwbZ58wiFxDHhxxjxGxEz0S6TnFTcn2BvhUf1JSfn472KSb2QzsRbmApqR06Abr1PI+XsKixWERpOMFOhoyd3qPlqkqsAb0EBINik8uiFwOJ7l8OgwcZaP8gUT03+YbBVXRI7YnVunuC/REr9oFMyMp4Yffd+J+bamwGKz4z88W1b+8kbAeoylqu0umswB43lLquNV3D5UknHNq5FUloKEc9tp6joJzQzWNb7YYa/VBbQ0ds/Id39v41Xt6G+CmxzvQFuOuQHktUyScKN+9GIJVqD+7PX5etDXeHcwmoeuH6xLuewjJYOxp9ZEKJwrhzOaDz9c0IXCFOZfhM+S55SsL54ro1TMdsVSZWKvUkAViRMtE/7IyXu5EEDeDd+S5QGW/iXrsFEddnBIu0lP0Yc4F5CJ+HzpXxHHiaMx+0FsO7ZWdbWldrTvVRkqLEmJlbysllrVUUAYxp1SwJb5XJWY6Kc9DWUt73YaFGa5JGWWB/cskEED20ocyDl7s/sYr1SFc8WdpOB+bzzg8FiWfFNMF7t8Q4TfeQrhHU4c2zGeCXIjecE9IomxdLk4bd9YVV0r44lpdhy
 S8d4GSRN
 RX8mcRkw/7X6+uICWb09ND46ETAgRFz8eW3bSX7DU0tn9HwHQgpZXv8W60U5B5u7cALjIb7Gwe9NWE8/kBu/KooHU7d4p0KdWQw55DniAHMbAiuJK9YeZJJITvYER103JiDByph4c5YYb/A/dA1i3dfBmqI88Y4czsElAuRewkoYOLW3DaWzNLbVL44tY6g7tqf1hQ6gxVZlXks3HNjkUYhe66NkbFoxRFj9Hif7gqqI67OcOAETLBnJnZSejAcc/7C3b31pMJeN8JQrrHJ+vSHFvrDPKO3MmKnraCTK2MDEeAxzkqYvZoXkoq3VkuOav58a42AAMlwmQkQs=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/12/26 21:06, Zi Yan wrote:
> <snip>
> 
>>>
>>>
>>> OK, this becomes maybe_mkwrite(pte_mkdirty(entry), vma).
>>
>> Yes, upon further investigation this does seem to slightly change the behavior.
> 
> I did not notice it when I was reviewing it. ;)
> 
>>
>> pte_mkdirty() is now being called unconditionally from the VM_WRITE
>> flag. I noticed other callers in the kernel doing this too.
>>
>> Is it ok to leave the pte_mkdirty() or should I go back to using
>> pte_mkwrite with the conditional guarding both mkwrite and mkdirty?
> 
> 
> IMHO, it is better to use the conditional guarding way.
> We reach here when userspace reads an address (VM_WRITE is not set)
> and no zero page is used. Using maybe_mkwrite(pte_mkdirty(entry), vma)
> means we will get a dirty PTE pointing to the allocated page but user
> only reads from it.

In general, it's best to not perform any such changes as part of a 
bigger patch. :)

-- 
Cheers,

David

