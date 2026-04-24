Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DD58AFB44C5
	for <linux-mm@archiver.kernel.org>; Fri, 24 Apr 2026 07:26:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CDD716B0005; Fri, 24 Apr 2026 03:26:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C8DF76B008A; Fri, 24 Apr 2026 03:26:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B7BDD6B008C; Fri, 24 Apr 2026 03:26:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A63646B0005
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 03:26:28 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 346678C219
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 07:26:28 +0000 (UTC)
X-FDA: 84692616456.10.DB13C8D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 54201A000B
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 07:26:26 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="C6/S2Vgh";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777015586; a=rsa-sha256;
	cv=none;
	b=zAVMU7MobcnHHUBbfcMJRbiVqI4FjKMGvkNEBT1wia43+dlDobkHHKucxK8Li6Huf1LbPc
	dc84u2U5Av85EvHlKXPNgjS6ZiepaoTVtYnIh5eJYLGHwz8zUuK+CKdTLIMMl1u32N4juy
	4yvsJz92D3G+0g72T44PK5XFNl8PYZ4=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="C6/S2Vgh";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777015586;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Uje65QBS8nkEsvDxvrhqo0gIkSqNi9hZLH7oH59/OSg=;
	b=aCSFi0EmKxHgJECP8jZ758TLxMug6L8n/+JfZi2fyDvU7GMPsdlOHmuOpdrK1SGziIj2FQ
	v7AXzCxucNvgXxd4Nivx2q6401eogSrMyVBnuC2526d2ZHpJA0Sh4giVKu1tUQlpAW7LG3
	5LpZyFY2ORvMB+VLQ8wzymFh+PM3RgE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 08A5C444A0;
	Fri, 24 Apr 2026 07:26:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B53E4C19425;
	Fri, 24 Apr 2026 07:26:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777015584;
	bh=5dmzXPh5bpR2t1b0uCMuOAqmdZYp5LGnT+Lwxr5M/oo=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=C6/S2VghcGegNnoRZvvUqEJC5Se8UaQriA/q3zpdTKceryHugwPWmW3hLepdvu1F+
	 2pM+7AAqUoTcF2vFap5zsQEkhXzDgXYV78p0OUuJuBbqwBv3O/8qmPDmftAAl3npF0
	 xW/rsHX18FkQjJ+YAAeoc6OliYWOCGHcOEkrOczwwIR7JJOdORUKzS+ONFq0/aasrm
	 hP3Sx+oWS6eTZF945+EHKpbaheEyeT0B2vNJIJS1KrWjWeYm3RWxWjG9f4dFefYjb2
	 Mwbeyt6hyV1NXzUvZvL3q+lySBi28hFUyuJMztEzXOwji88N0hU/rAZhQILqhxViia
	 bamHzpaHrw1WA==
Message-ID: <a1252167-63a1-481b-9f1d-2a7bae7a3b6c@kernel.org>
Date: Fri, 24 Apr 2026 09:26:18 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/5] mm: Introduce zone_appears_fragmented()
To: =?UTF-8?Q?Thomas_Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
 Matthew Brost <matthew.brost@intel.com>
Cc: intel-xe@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Johannes Weiner <hannes@cmpxchg.org>
References: <20260423055656.1696379-1-matthew.brost@intel.com>
 <20260423055656.1696379-2-matthew.brost@intel.com>
 <76191a17-18bf-4e9b-9ab5-dc9a48abfabb@kernel.org>
 <be42059924cde9bb16a087ee2a5abb0b9d850d68.camel@linux.intel.com>
 <aepuNL2fwp47P1Wi@gsse-cloud1.jf.intel.com>
 <aeqbe/9YRKNyYuWY@gsse-cloud1.jf.intel.com>
 <291406b26b8badf2e565996515931d9ebe50208f.camel@linux.intel.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <291406b26b8badf2e565996515931d9ebe50208f.camel@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 54201A000B
X-Rspamd-Server: rspam12
X-Stat-Signature: cn79nkxfw7gz4z3ujymd8zk99o3ebqay
X-Rspam-User: 
X-HE-Tag: 1777015586-222199
X-HE-Meta: U2FsdGVkX1/qlCXH346+n0AwP+zxcA2lIhWpKq/pMXvkDw2fQ+n+4ByCRP0Qxt6yvldMvhiZcM3HPcRVo6CST0rNB24UznGnU8t3Qt0sqgDZNrlciPCjW411qCH9fQo4LoUstGfxcjYNOiMwmCklzP5BrlU3kaCdrCIwhfu/8cbqLGFwmUOnCqryM0l6RmJ8uevPy/y4/XOyZ2uF36Y51Dyjrk80jH9NUtE2KTLw9q2w6VQ99UOL5YYqQqOrZ8FlvMYmVtQ+qwV94p1XzmHOpVEWIGQZplHf+l5EObzr2hMfWftJoZaoQ9plZyXarV5qT7PDwZW+ZhzpBxzQ/Lji3FxyBrGxxF9Y0JydymY/zcKr2Hu17tMXvsDM+Gyd8qq238wqfh1XpH2RFJDhIhwR2XyMS/7/lOTc1usvfe8LqPBFY8bRDfuPDJoVMPMpd5yYnKRPsKGZF/Kn8T0V41wc3KWCWF1f2b8B+1Pp1v93rzEJpry7KEZp8W2yBv+0OzflxJdmIQmNp7tg3W7qob46Rg3a4MUd03A7lfDazDfqs7XoU3kckJENAvurAAtnG1tDnL5cTxin8gP9CtY++HLyseWVfKCHB3jLAePO76kIiXWbJTJINR4+LPwwyLoI70G3EkGRpRilGYVwJI4Vua+v5KEKiW4ZJ77zxhGlt7IlYelW8VUu0FgvaohN9KPPTtliQgDDiVVgzrNz8da/z2MFC9JnvcR8Kqgr6/q5oNmRaaxPzvNVENtCluBjxWWmFPBRqxKP2AiAnDkHlDPyUpLgHoaxUUnmkb4O3MdPTWrKYSkUvzeHMdtfB6r1EuTplyFgQK+LHYvBFdpN/uT4B2h2KLlKkmYXMsW/tCC/hW7IRHKmAPAcPFHJzhetACgbvmhwt5Ia0MIxwBzqifIDDFfbkB2bBUI39bsssr5fcUbdiJJBNpcdhERbegn8LasPfQqlaoVvK28ee8TP/ekECkY
 bw9nRlQ2
 1Oljia+gf3EFppA2g+EvLI+ttVsGHXs496TnTbE6MdBiYamvUJl15pdEhzd90UoEIhMJPUkJmPXLD673xbwll0y304sNRoHXJBLO9e/ddypxltzCn4SitIvhli4vYVlvcbZBjPAaDhOu1s5x8tfeP2YU9EDJT+6Dd85AfQu44TzcCtcoJwBE6Bb2nibuU9SmTau+8xnDFswzXlz8UW2WzxA7yP3Y7zdpCNL9X1PiAbjho0oCgRRrTGQrV+DHK3ghMhgpmCR67s0sv9VCz1TWi/caI0OIGs+X4V9rs6vKM0UMTdaz1i6Q15nSmjpycqAITVrTny98M/irB1fbIxoEw2na7CvALmlMp/K/dvhmMzG0ptIk/XWYZ39r6KjH5DfYXSV94tzEvd8ND0N8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/24/26 09:05, Thomas Hellström wrote:
> On Thu, 2026-04-23 at 15:21 -0700, Matthew Brost wrote:
>> On Thu, Apr 23, 2026 at 12:08:36PM -0700, Matthew Brost wrote:
>>>
>>> If the order were included in shrink_control, there is about a 95%
>>> certain that this change would allow TTM / Xe to break the
>>> problematic
>>> kswapd feedback loop. This may also better express the intent of
>>> the
>>> problem we are trying to fix here.
>>>
>>> For reference, the cover letter [1] details the problem.
>>>
>>> Any guidance from the core MM folks would be appreciated—would
>>> adding
>>> the order to shrink_control be an acceptable solution?
>>>
>>> Matt
>>>
>>> [1] https://patchwork.freedesktop.org/series/165330/
>>>
>>
>> It doesn't look like __GFP_NORETRY, __GFP_RETRY_MAYFAIL, __GFP_NOFAIL
>> make it to the sc->gfp_mask flags from the caller and get into kswapd
>> loop...
> 
> Perhaps that's because they mostly (only?) make sense from direct
> reclaim? Looks like the trace is from kswapd.

kswap obtains the desired order through pgdat->kswapd_order, as a hint from
allocation code (wakeup_kswapd). The order can be easily merged (just use the max)

We do have the gfp_flags there, but merging them from different wakeups is a bit
more tricky (and when to reset?).

Assume we have one urgent request for order-0 and one non-urgent
(noretry,nofail, ...) request for order-9, we'd have to figure out a way how to
represent that. Gets more complicated for more orders.

Of course, we could have some kind of array, and try to store some "priority"
per order. But I assume plumbing that into the rest of kswapd might not be that
easy.


-- 
Cheers,

David

