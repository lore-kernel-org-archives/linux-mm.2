Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5CA3ACD6E56
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 12:06:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C3F306B0355; Mon,  1 Jun 2026 08:06:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C166B6B0357; Mon,  1 Jun 2026 08:06:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B2C726B0358; Mon,  1 Jun 2026 08:06:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A0E476B0355
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 08:06:32 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 68A9A16245A
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 12:06:32 +0000 (UTC)
X-FDA: 84831216624.25.A76E4D0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id A4A1D180003
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 12:06:30 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FRpHjCBQ;
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780315590;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HkMg3NCB26gAhUUW/DuAMeOpPoMt1oN8LvktWRRL14s=;
	b=iItzQ98Cmc4K7eytZrrRDBPS1lTyrmrCRgGmm2GTuLFDFaj+8YO7ZIHta7DO2nERWNEwAx
	nZbYCtiW7y0WoR1ZMMrnS+BE4XdKBR1JskT2BjjuNX1gf4Q7YmcZGYxuFhRBgYEqFjWJet
	wd2RMVaE9BU5XrE2//cQkZOT1lcIFgY=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FRpHjCBQ;
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780315590; a=rsa-sha256;
	cv=none;
	b=YqU67tqFoVmFYY3hCsPLw2c+sWRSEJFP4sYeD4my6+Eakq8WyVGfdW5+d9le4sOdAzJwwL
	tUMwmQZ7KBhNGfHPfhEzPl3lLx7T5WLlzNfz2QfeLCMKt2e9Q3hvkG0ibd/+alQbxROV2t
	hNdKkMsQnUsVrN99daxptAyx3F6tF50=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 26AE3601D9;
	Mon,  1 Jun 2026 12:06:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 350851F008A1;
	Mon,  1 Jun 2026 12:06:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780315589;
	bh=HkMg3NCB26gAhUUW/DuAMeOpPoMt1oN8LvktWRRL14s=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=FRpHjCBQXQ5Zf6i2+7aYg5ZfVma/l81fehJ3XD4KbjXDpz4wczfktm0xO4dWonVAV
	 WtQgLSXg5sYF3D1DrcPEmrqNgxpZ+dpU4OUxVXdztvfOP52n59M3Nj6a32q4eUzq9T
	 JSJhvYkN7CRWeSdRVaB3AlszrzlDAGfH1qIKTlMCD9AYQTNSXcj4g4QjDV6sCZzT0j
	 /gLx5U70OUcRfv0K0vzM3FFGVC0arv3j6BPFrSSERnMQgnLnkEnyldxeBgFxjQ7Kcp
	 HSzoqv9sPRasdUglu+TlCu3sjV1QzU3828BqMYOXYWZgblwWfCORmbBgv+CHo4hfuu
	 c8IilCLHYED6A==
Message-ID: <3a5eed44-7d4b-488c-8e04-380cd115b6dc@kernel.org>
Date: Mon, 1 Jun 2026 14:06:12 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH mm-unstable v18 11/14] mm/khugepaged: Introduce mTHP
 collapse support
To: Nico Pache <npache@redhat.com>, Lance Yang <lance.yang@linux.dev>
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org, aarcange@redhat.com,
 akpm@linux-foundation.org, anshuman.khandual@arm.com, apopple@nvidia.com,
 baohua@kernel.org, baolin.wang@linux.alibaba.com, byungchul@sk.com,
 catalin.marinas@arm.com, cl@gentwo.org, corbet@lwn.net,
 dave.hansen@linux.intel.com, dev.jain@arm.com, gourry@gourry.net,
 hannes@cmpxchg.org, hughd@google.com, jack@suse.cz, jackmanb@google.com,
 jannh@google.com, jglisse@google.com, joshua.hahnjy@gmail.com,
 kas@kernel.org, liam@infradead.org, ljs@kernel.org,
 mathieu.desnoyers@efficios.com, matthew.brost@intel.com,
 mhiramat@kernel.org, mhocko@suse.com, peterx@redhat.com, pfalcato@suse.de,
 rakie.kim@sk.com, raquini@redhat.com, rdunlap@infradead.org,
 richard.weiyang@gmail.com, rientjes@google.com, rostedt@goodmis.org,
 rppt@kernel.org, ryan.roberts@arm.com, shivankg@amd.com,
 sunnanyong@huawei.com, surenb@google.com, thomas.hellstrom@linux.intel.com,
 tiwai@suse.de, usamaarif642@gmail.com, vbabka@suse.cz,
 vishal.moola@gmail.com, wangkefeng.wang@huawei.com, will@kernel.org,
 willy@infradead.org, yang@os.amperecomputing.com,
 ying.huang@linux.alibaba.com, ziy@nvidia.com, zokeefe@google.com
References: <20260522150009.121603-12-npache@redhat.com>
 <20260531071845.10875-1-lance.yang@linux.dev>
 <6a9f062c-8376-4f83-90a9-8b167f925dc6@linux.dev>
 <CAA1CXcCfww9X-f2Vb=ipz8tY2nMNnMx5_58Ozz63tvZTz_wpOw@mail.gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <CAA1CXcCfww9X-f2Vb=ipz8tY2nMNnMx5_58Ozz63tvZTz_wpOw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: A4A1D180003
X-Stat-Signature: poouddmp9b6fg8dfgneseetimdi5gtsn
X-HE-Tag: 1780315590-827922
X-HE-Meta: U2FsdGVkX18Wf10hNqTBfrjdkC6tnmAjWlz3X/sqhaAWmkL5p+VkFigkicOPn1E1s5J5AYiGjnaiIhSqEyoTbgCLegW7LqzlIvx+z1qfk6fj1q53sqJil8LokNWgmt/+MLWcivpcxrSUMfBxSe1I+/nLmGomaClaEJUJx3SuEHdT2GV9yM30WPmj2MJudmKZuYaApw+wWpIqbtOWKJfWh4adMGa5qzCoGeFb/UGCk+6mlsdPFidfgmMIzVeDafm6hEiQsBYQegoG9TbyKZVqo0uDYJ0IVOT5iZdhrl/SEh+akLYvOEjirOMbkzFnltEWn1A9Vgaqx6Ma7RwVwxtIPbipqdoQlpQj2hwuOD28sXMbu9yZ4wptJ+ceSHOWnmTWwy3IKwEZ5Z77OnvRpAORSd0YmwLDWCpH63e+UGHq7+yRx65xHHs6ebqz7xGMzJFO/OGY3ctHzzH8/ZjE5YhM4/MrviC3F0Avop31YFZgHIFSFomG+53puyOdxvX3Pv2jItjCANAi8ylAbw5Y3CUwP+kdAiYiOpLAmeASR6imPKBR7lXop2wWN+rHtoO6JPHCU6/Mc2elRqboMrU5DNw3m9JMNkpatvFIRKM/HXQFYEy8mF7UeKjkYzGYmV3azplMu6rtvnUM8AWNbenvrr6uLsoq5obclUSwjSwLAz5yDy4PpCdajrPl3qYNkwBnKUmsT4+oFl57RBtr4mtXuw1Ax2Y++o3CNiuu6X7h9oKqMWf2axLPzEmNCSTC6go0IpzdcHUHGGBcNr8RD7oJWz5MTqeA0tQbqOB/v16cYl2+CfVpMYZ8cFNsBKb1PhsXkQ9BxymHuhv++nZtWs9oTfGeULSLK3Sq8f0OlndRaEg8W7N2YaZ4++nfk5WdEUvamoAOsiWjDqeepPq8RK+7GwFebGoKrdKBr3XFRX64u1rvgkMP9vfWWd0KzGcRgKCKxg0tejjHVTJc70hMi7aanhF
 m9kI2y4m
 583jmIRd73IcPpsg+FoBp4I8TaK8GLMZx+bFxTFKYfQM0Ex5gg4vYfs3jKjQgX/oW4BttwJxlgACGg4aAxzkytsGQZFesVwBzVBmr1JM2jpE4aW5v+CwE3b47y+VibMOXYZh2HHe24ljsBP9WB4+D0+R6UAqRR/oimIFHajNY1dijfYo06+nIZ+C3sURkYJpUzsel8+MfSOoqxuSBb8zDcOrylhKdWLZsDgykuk9KDwbo7b6xsIL14aopKitMNV/c1NrCaIZo8gZ1y2V3NPQGa6rqK2cjbrfCNgZMzhb1WXoBWtBQjcUXb+/icg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/1/26 14:01, Nico Pache wrote:
> On Sun, May 31, 2026 at 2:48 AM Lance Yang <lance.yang@linux.dev> wrote:
>>
>>
>>
>> On 2026/5/31 15:18, Lance Yang wrote:
>>>
>>> [...]
>>>
>>> Hmm ... don't we lose the allocation-failure result here?
>>>
>>> Previously collapse_scan_pmd() propagated SCAN_ALLOC_HUGE_PAGE_FAIL from
>>> collapse_huge_page(), so khugepaged would call khugepaged_alloc_sleep()
>>> in khugepaged_do_scan().
>>>
>>> Now if allocation fails and nr_collapsed stays 0, we just return
>>> SCAN_FAIL. So we won't back off via khugepaged_alloc_sleep() anymore?
>>
>> Looks like this is a more general issue with mthp_collapse() only
>> returning nr_collapsed.
>>
>> For example, SCAN_PMD_MAPPED used to be propagated too, and
>> madvise_collapse() treats that as success. With the new code, if
>> nothing was collapsed by this call, that can also become SCAN_FAIL ...
>>
>> So I think we should keep both.
> 
> Yeah I thought about this before, but more regarding the "incorrect"
> propagation of errors; I didn't consider that those results were
> actually being considered.
> 
> I actually had a patch to track the last_failure (with some
> prioritization on certain results). I think that would solve this
> issue.
> 
> Thanks for reminding me to improve this.
> 
> Depending on how the rest of the reviews go, I can either send up a
> follow up series to do some more cleanups and improvements of the
> current approach or we can send out a v19.

Let's do a v19.

Patch #11 might need a bit of work, we can discuss offline if you want.

If we could get a v19 by the end of the week, that would be nice.

-- 
Cheers,

David

