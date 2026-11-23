Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2FCF8606A330
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 10:41:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=fS944Ga+
Received: by kanga.kvack.org (Postfix)
	id 5365A6B05B4; Mon, 23 Nov 2026 05:41:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 50F966B05B5; Mon, 23 Nov 2026 05:41:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 44B026B05B6; Mon, 23 Nov 2026 05:41:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 1C0886B05B4
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 05:41:53 -0500 (EST)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 967D2120838
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 10:41:52 +0000 (UTC)
X-FDA: 85466043264.18.42CAB29
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf05.hostedemail.com (Postfix) with ESMTP id 6707510000C
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 10:41:50 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=fS944Ga+;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf05.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795430511;
	b=8eh73vQ3VVfLodkIMe243LplGdzB57j9m+2GW9Fw0yL1Rd+/FOtL30x9+9a8G5kIUL0uFv
	fPsT2UWgApM3PxPO0BKIwePlrjpQVFawwmpO4RMgokdFtF/9m/NxlDPq0NU67HTPQXtEAJ
	S9XUOvxe4NF3j+6QymaBwwAc0JbLmGg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795430511;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jpGiLd/SR0KkHuW916oaPvPankpE2lAPzBwsA+0eEUo=;
	b=a6Iw0WqlQS/jr2Y338cqGiUEBmiKNF6sProBaDhDzt5j7EjDGYClXjF7Tz4qLjbI2bgAQL
	F71d6LXPbKUPB4kISGSHjsCOBRrRyrJoQb1jNRkp5r+qGpsmx6oKIusXA/douCiPMnu3Q/
	NAjqBg+IGUn6j0RwUs/fwLX8bxoP5WE=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=fS944Ga+;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf05.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 36CC4143D;
	Mon, 23 Nov 2026 02:41:46 -0800 (PST)
Received: from [10.163.157.54] (unknown [10.163.157.54])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 02EBC3F632;
	Mon, 23 Nov 2026 02:41:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1795430509; bh=+Uc9s5vRzOrMEMBjecGU+IR5j76w9s/5x+FEreLson4=;
	h=Date:From:Subject:To:Cc:References:In-Reply-To:From;
	b=fS944Ga+GVS89oCilc07YUDOHzrGxgD/x1uVGnqJPQlpAGss8pw0pHiDOiZIOeWQT
	 /bUJ+Dz9KlLvnnf+AxCR5wLpoKa86/bSdeSIp2SyRQa7yXtBjiiz6XgfCcLJUrvglk
	 eCzLfNKth+PIlOteVECJ7r5T5WTKzYyMqAdUfp80=
Message-ID: <38d06816-e138-4edc-b26d-499617870506@arm.com>
Date: Mon, 23 Nov 2026 16:11:37 +0530
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Dev Jain <dev.jain@arm.com>
Subject: Re: [PATCH v3 2/3] mm: page_alloc: make the high-order watermark
 check honour ALLOC_NOFRAGMENT
To: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Vlastimil Babka <vbabka@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,
 David Hildenbrand <david@kernel.org>, Harry Yoo <harry@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Brendan Jackman <brendan.jackman@linux.dev>, Zi Yan <ziy@nvidia.com>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 Mike Rapoport <rppt@kernel.org>, Qi Zheng <qi.zheng@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Kairui Song <kasong@tencent.com>,
 Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>,
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
 Baoquan He <baoquan.he@linux.dev>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Usama Arif <usama.arif@linux.dev>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, kernel-team@meta.com
References: <20261116125103.2894162-1-kas@kernel.org>
 <20261116125103.2894162-3-kas@kernel.org>
 <a066d403-1608-4c0b-b06b-0b786e71b12d@arm.com>
 <av7_n5llADUbJI-r@shutemov.name>
Content-Language: en-US
In-Reply-To: <av7_n5llADUbJI-r@shutemov.name>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: uskbexxrxrsqffpfwwqhzkckieyi4a5p
X-Rspam-User:
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 6707510000C
X-HE-Tag: 1795430510-8161
X-HE-Meta: U2FsdGVkX18svRyhMyFZfzS6CJ/mfQ43+LzO1ycPJdSsSMHj3iMu5Mo3HSQur8BQF945LRvsZzUOBdUNIFwyQDIpi919xjTOQWPqk44qwpMWoWv7/mBnq3jW64kWIE4vSGe6J5Dms0YWuLvE3pVlL9hfEpijD8dyGh6rlCnyD6FAG38CrFOGDUr95Ilqc81ziaIb1VbSgyNV34dLQmqTQpmQQQK4h3qUtAqtyVgWm7PoQkgN9T0LieGmuJyCqXCUOLmehNu16Lpydh86qvteQCY/0nLSL+qvozNQE7RaN4BpYBw6ZU5EVcvWh+bFNWvU9RBwobAikuHBklFftINWZb15kY86HDRKge7dQW1wg6zVM53kyuSMOE0TLB0x1+8A5jWELh7TWx/7ql1Dd6jp4Fded0P2mP4sVLRCVTASVNwSNjdH0C+0jsHaTqGQ0JiOiOjZlKnM/ZTAF95/uli19OIFncyS1YbCUMWDMQQurL2sGliPj8trJI8gDextFvWy/np2scBr2X7YcFN94vE9zzFhmzcHJ/OSge7lY9uxASiVcGigQlTwZ7ryCXl7L+22bLO6nQl7+8f6/SDpM8mtbyXvVhZoOXtiZv6kPE1w55K15hWBXXQ/r28c7IHGFjtXiFWJw9GKRI3ojD+TAATqBmKswmLxa/0dWRVRH5CPGGF6bJ3J22mSOQdyj8K8IPuhaK8mi5js5vtR6QAtJyP6dviF6jicofYdMEaO03trToYjbBN51G/M3PV+ZvPFG+6xd7dNt1eAmC4fhVmW2muXRjOLdFSWUFkQ+eEy2S4guvyndLUC/v59kRmm7oa9oPQLXZjDtod23r63Ir4Vef+V3f8FGuTR3Bs9QPi8ZWco6QH28gVmD5TagkOCJg1V5D4CgLlJcN7i3h/9Ubbb3kHlMjddDuBqA1xuGiRehnrCxxvEKf/xowk0WzNC5XOtqvJOgZJI6h+J1hUWY/KVBdQ
 JDYpwsw/
 bSPGaZnr1xxdYDcGFxdiuqc/4ON4+I0qNDBT3qhZ6HFRL6kW3gqsmbNlbNryB0IszrNCS7fTaO/xAylrnDpwZAkzH6XwP7YKq6+ACrLLfcuT3VApdsH0u/FZIPz0zeKnvc/3e/Qyd6btRKMxV8SUOvpFI/Cd9myT2N0Sp/Md3luDl11gDvZc2uNFHzZdNLG5drnrNiePG+8bQNEbj8IlHVcGZci83Wg0YbxP8UYNd7xjgUGfToSHoLM96HcEqUqhqlYKIXCYiEsMZIGSBvrMxWHdnicFrXbtA0pAAJfaY0BQX7FWpuQICOfyZu3HTKAnY5bV7n+SBS62UPz7FyFCWrjqYQfahehh9x421Cxf69t5BzkfCCzQEOfsp4lApegG3dOppFrLY/lHspW2q3/T1M3ijbkLcrAMyHpeHaPOqve50UaNqpm48WG5Ow0erR7GDRaGPUI2u/YXfLGmku4rn4DMX7mvNRVsVP9lpFIlZL4UDjGJxxxv6nhW1/DBP63koSqCoiAxrPdUbcxCPHzXhTnyUK76KSQdt0bLGuw59aTsqeltDOlcPwLg0JduptJnm895mR703KukHmJoVXsqw/nGP7Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 19/11/26 7:32 pm, Kiryl Shutsemau (Meta) wrote:
> On Wed, Nov 18, 2026 at 01:40:17PM +0530, Dev Jain wrote:
>> So let us do something like: we have zone_watermark_ok_for_alloc. It will call
>> zone_watermark_ok, which will only handle the watermark computation (so this is a
>> refactor for the code ending at if (!order) line in current zone_watermark_ok).
>> Then it will also scan the freelists for the correct order, correct migratetype etc.

I think my wording was unclear. By "correct migratetype etc." I did not mean
"only the requested migratetype". I meant the same rules being enforced
below the if (!order) check in current __zone_watermark_ok(), in relation
to the migratetypes and orders while scanning the freelists.

> 
> A count-only zone_watermark_ok() does not work for three callers that
> pass a high order: kswapd's pgdat_balanced(), kcompactd's
> __compact_finished() under defrag_mode, and should_reclaim_retry(). They
> ask whether the zone has a free page of that order regardless of
> migratetype. They need the free list scan without the migratetype
> filter, so neither of your two helpers fits them.
> 
> So the split is not count vs scan. It is the zone as a whole vs one
> request, as the comment above __zone_watermark_ok() says. The _mt variant
> is the one that takes the request's migratetype. Callers that only want
> the count already pass order 0.

Although I thought a lot last week and my approach would cause more churn due
to changing lots of places to _for_alloc, so I am fine with your approach for
now. But read on.

Currently you pass migratetype and you say in the comment in patch 1:

"Use __zone_watermark_ok_mt() instead to check whether a particular allocation
can be served."

But, for the existing callers who pass order > 0 , aren't they also checking
whether the allocation can be served? It is confusing me that both alloc_flags
and migratetype are logically part of the "allocation context" but some
callers are doing alloc_flags & ~ALLOC_NOFRAGMENT ... I am not sure whether
the below Sashiko report is related to that, I didn't check in detail:

https://sashiko.dev/#/patchset/20261116125103.2894162-1-kas%40kernel.org



> 
> I am not particularly tied to the _mt() name, but _for_alloc() is a
> mouthful.
> 


