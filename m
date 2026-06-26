Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AD647C43458
	for <linux-mm@archiver.kernel.org>; Fri, 26 Jun 2026 18:05:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4A49C6B011B; Fri, 26 Jun 2026 14:05:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 47C6B6B011C; Fri, 26 Jun 2026 14:05:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 392D26B011D; Fri, 26 Jun 2026 14:05:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 07B2C6B011B
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 14:05:18 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 8376D1A0569
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 18:05:18 +0000 (UTC)
X-FDA: 84922840716.05.A344933
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id C924FA0005
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 18:05:16 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="RWQRTWo/";
	spf=pass (imf15.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782497116;
	b=7cD/OFUV3xTR2zTVvVXflC1K6jzw/oaZZsdIAQfw8CiH3IBmsxANtjCej7JnWlTzHBkc4V
	PtsVxNp86kl1pProsZlp53RMU61hOThpN4VWpydwP/LGOIuZeDsp5HXL+5tImcU8oKCuS2
	ZIrNgVOuFG/l5eGU+hgXRytTQXo8yA4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782497116;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fGiMyZB/kEhf07t+JFhkktFDb6T15Rf253lpTmaTVd8=;
	b=8CAvGCLl/Uh4p4Rr1KPpjEHWdR7TCIJonugRcTqgDWnyyz/iXQrXQmQ6BYXip85e2/rWda
	+Uw9TvN+bpGU3PDA9B1Ti8eYID/SZcM9q5wJ09kymDOpyUKZKRhb882FzzFYYr9X85Drcw
	RNZbQ06SqyMhu5OauJDoOpK8A+2DIjw=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="RWQRTWo/";
	spf=pass (imf15.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 348FC601C4;
	Fri, 26 Jun 2026 18:05:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79F171F000E9;
	Fri, 26 Jun 2026 18:05:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782497115;
	bh=fGiMyZB/kEhf07t+JFhkktFDb6T15Rf253lpTmaTVd8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=RWQRTWo/O74n4A8v4P+Qyk3xgKStasPuZl6B7LVJ5wjaiALscfqq3SAfKa+w4+OQA
	 FoXgyKGVvOeF8Z1Vi9qJ5l/MYpAHoPt0ZRQn00vUIcY3HrM82aA4S8UiuPcfaZfZNd
	 t850CYdcz+VqiDQls9RsFY/JrIa5Xqt2g2YKaZwz4UL2o3bUhBZYGli3c6ubwjL6+0
	 SkoSXh+vnsLm+eUoMO9GJE3sE4cwTXdr8M7Yjs3X2cqSyVSp5t9lExOaDSXj3b42HU
	 faUqhcmcq/+zhWKeqTFFQQDtztGavuSbocqtkCrnsmzjBgmWd0ww3MdqT5ikusnD4I
	 /AI9JO7i8hEQA==
Message-ID: <10824fdd-0abf-44ad-9a2f-e62aeb669195@kernel.org>
Date: Fri, 26 Jun 2026 20:05:07 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 02/13] mm/page_alloc: some renames to clarify
 alloc_flags scopes
Content-Language: en-US
To: Brendan Jackman <brendan.jackman@linux.dev>,
 Suren Baghdasaryan <surenb@google.com>, Brendan Jackman <jackmanb@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Michal Hocko
 <mhocko@suse.com>, Johannes Weiner <hannes@cmpxchg.org>,
 Zi Yan <ziy@nvidia.com>, Muchun Song <muchun.song@linux.dev>,
 Oscar Salvador <osalvador@suse.de>, David Hildenbrand <david@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 Mike Rapoport <rppt@kernel.org>, Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Byungchul Park <byungchul@sk.com>, Ying Huang
 <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>,
 Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>,
 David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 Clark Williams <clrkwllms@kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
 "Harry Yoo (Oracle)" <harry@kernel.org>, Gregory Price <gourry@gourry.net>,
 Alexei Starovoitov <ast@kernel.org>, Matthew Wilcox <willy@infradead.org>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-rt-devel@lists.linux.dev
References: <20260622-alloc-trylock-v2-0-31f31367d420@google.com>
 <20260622-alloc-trylock-v2-2-31f31367d420@google.com>
 <CAJuCfpGagFf4RaCNJqu4Y1oqOXXOWSkP1UGuT9LA-9EbDN4Njw@mail.gmail.com>
 <DJHEUV09YHKE.1YVJWE38NM8U5@linux.dev>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <DJHEUV09YHKE.1YVJWE38NM8U5@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: C924FA0005
X-Rspam-User: 
X-Stat-Signature: ddhzf8cyh4nga7tbamyj1w4659bm9j8n
X-HE-Tag: 1782497116-501124
X-HE-Meta: U2FsdGVkX18mSSnCbaVLgeF1SkTrubwo3B2vZWI0PMCiQDZ1XPuDRavP/eafrtf5Vdf25vYUDcys41+hAM1CZ+DcCUNyDk8LbFcdGCUWxzCTeSfUeIOYirXrZRC9u2D1Rw5qqymm2SHwyutDu62S28osurc/Q0hfUehwha3QHTFr9iZgBSdrsnY/9ACRctuMYlMrJ3M/QodmopVwnPttKnh0mYfeSNq68WZHRDA3+flLZb9In6eM5+q8d6aUn+dtrQvXSnG40N4ESDipNNPlMfZYwCXJ+IanixjAp9OPW7BI0QLWQ7CJwwZzxhSX1He/j8PheBaWAsPoiWwOyzvqof3Nu9wIT+cJ+m94gtCC8pTcu/Rk2akMle1U1ShpMMVh6BlWIayNBROmyeNer6CeyTZNUSnkel4HTTCbf6lY2EZw94LLZsRLm/rsay9oTDLwyC4c5beq6mpeUcZXnEGZUHocNJBlWsAEF9qgkuNEfohqfsPNvjUA6Qdw6EIazDlxVp7+TRildeRonsFyO85Wn1JxM6UGrGQ0f8Pilxia/bwSgv1UBoZ3BW/V3p4CXE24FXtmk8CcuP9QZ1gJy0JtrQWztjQWTsLahR/jV/a4QmkTcWWOPnsbMdDF3f+NCFNQylOj4A1IY4ZOJ+ww+BJM/eZcs+GXFWevtrJ+XQJemGz5SgNFCXIZ7ixmQd7aZBWJMp+vpXEUND1GPoJ0UwH62BFenK6Z30fbDrOZTtmkW/R3letSck6Zmw6U7+6w3c5yBWBysTZ6SI9OWjO41N9W4Ye3yZayaaAHoirxxk8KHbkvKPP4JT241iFcEtkqXjUv/d9sEdq+SSFh7iXcf51jR1AfON/EX+BaCA1hFs2AJ9/u+7mykPEEHfSQYuCL1VRK38DLejmS7ajYUfgwGOh9Hv0ZkSyrjaHhcJqbl//kIov42kRlE2WiBB1RrFtWkSHrltIMfunu4wI10KvNXFx
 KJudnWSv
 3GlCNcT95PmBnpjllr8dvk+O5P7AtsN2Cg699wJj5uwn/M/DALC7lxYX526+t40izSb/Iu0lcwLR2bfhVp4O+oNfnXHVrv7RsaqnMUvtZ+coD7Gp/egHS91y2B4msBdzV5WaLTy7r5hreghy4pn8INSXIt32XbfiTlSy6mnXA5aq5p0iylrlixBKRmRMw3oIwmqQZkofqhf+RRP2Fsk9neOaSXQBEOHL0iQ88bupCumJICEq1RjgQPNR/pHeskLAPXaRflXfcroSWlvz76FKkhjfowNgqk0A8tIBcsfYk1Z56zY51EVl3G2l1CdDI8RmNkrORqMOtLl8lG7J5z4QhtOXxkEnlqARbrKaW8/Q5Mva1dGZg1ODyN7PVVQg6Ob0vyCjHC002BSJ8AC+AsmCcwMpeNEh/XHtZF8AkNMQkRUB8myw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/24/26 18:13, Brendan Jackman wrote:
> On Wed Jun 24, 2026 at 3:03 PM UTC, Suren Baghdasaryan wrote:
>> On Mon, Jun 22, 2026 at 3:01 AM Brendan Jackman <jackmanb@google.com> wrote:
>>>
>>> It's pretty confusing that:
>>>
>>> - The slowpath and fastpath have a totally distinct set of alloc_flags.
>>>
>>> - gfp_to_alloc_flags() sounds generic but it only influences the
>>>   slowpath.
>>>
>>> - prepare_alloc_pages() is generic in that it sets up the
>>>   alloc_context, but the alloc_flags it generates are only used for the
>>>   fastpath.
>>
>> I understand you want to clarify the usage but this particular point
>> seems to be an implementation detail. IOW, if tomorrow
>> __alloc_frozen_pages_noprof() is changed to use alloc_flags when
>> calling __alloc_pages_slowpath(), would we be renaming it back? So, I
>> would suggest keeping alloc_flags as is in prepare_alloc_pages() 
> 
> I would say yes, we should rename it even though it might mean having to
> rename it back later. IMO it's very useful to make it clear to the
> reader that they also need to look elsewhere to find the slowpath flag
> logic, without them having to notice this rather odd detail of
> __alloc_frozen_pages_noprof().
> 
> But, yeah I guess prepare_alloc_pages() doesn't really care that its
> caller is only using the result for the fastpath so I could see the
> rationale for keeping the arg as alloc_flags...
> 
>> and its callers. 
> 
> ...  but for it's caller I really do think the rename is necessary and
> doesn't really have any downside? Especially once alloc_context gets an
> alloc_flags field as it does later in the series.

I don't mind either of the renames. It's all page_alloc.c internal anyway.

>> The rest LGTM.
> 
> Thanks as always, I appreciate the review.


