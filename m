Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 84C69606AA0A
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 17:03:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gxgRo1RS
Received: by kanga.kvack.org (Postfix)
	id 571C26B05B0; Fri, 13 Nov 2026 12:03:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4F7BD6B05B1; Fri, 13 Nov 2026 12:03:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3BFBE6B05B2; Fri, 13 Nov 2026 12:03:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 056BB6B05B0
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 12:03:10 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 65FDE140334
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 17:03:10 +0000 (UTC)
X-FDA: 85430716140.10.3B3B9B9
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id 84EB3C0013
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 17:03:08 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gxgRo1RS;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794589388;
	b=UWSab9V5+iSD69cpzBlLca/JQPfu4XT/Qr6JBcyemaRzzHWsiIM4n66qYwN/xUQ0UQ2tb+
	f5vNMeeYsaagnNLmtWTbbDz5yz+k33AheWdLezFYLC4BCNlv5Yu0G4pfOGxBXM0QA45fDu
	+4PSUcsjBt6Dh9C2g2X3heAp2z5DnOc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794589388;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=b1iBR06mysXuO9oyeYat1Y60ZRUTWo8aGvB3eQgMSoA=;
	b=VQRpVFeTtPT5GcWvmQDxyx9/o2//76UyVNVeTQUNjNUpdSrBmb53KVQWJjuDMxyitUbhbd
	xBWA2cBfhX+4dFmiZBZenBRCpfCDtQANztv4L/Rse4vVT4cmrQ4JCgrH0guq160qZ1W0QF
	PCYP3LPh0i+pWJaF4ebd6GcoyV2Cw0c=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gxgRo1RS;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id E1289605C8;
	Fri, 13 Nov 2026 17:03:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 960901F000C4;
	Fri, 13 Nov 2026 17:03:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794589387;
	bh=b1iBR06mysXuO9oyeYat1Y60ZRUTWo8aGvB3eQgMSoA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=gxgRo1RSHOc9qKClV3C26LtiU6p9kJ/ozWFc2K79GFXHw+V2zqI8muvqqPuT4rTGb
	 BUE9WsN9VTM1kBKFeWkGNHnimcaZMkVYoq/DW3cbrQSCB2M2NdK2RJ/d3t4+hu4WXM
	 WXpLNE0S3SYsXfJPnIH4GsjXlK0DEshXuvHyAM6VzNlhTsxLBSL5Jo6JBZxBpjsZIX
	 zFYwbUqm6nnXo+AW9MkjpY+zf6p4JSo4FoURUI++QVNVql9g9hYlQcbwrhS9ymsd9h
	 8u2FsT3d2Q2ZRsjr08T5ai3DkOY6FqfMIa5FUHfIvmXG06XsEKYJdJIccJidjFEDkx
	 4lAwW/x6Qcm3Q==
Message-ID: <13c40a66-4ce9-4d9a-801b-a3debfecee22@kernel.org>
Date: Fri, 13 Nov 2026 18:03:00 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/3] mm: page_alloc: add a watermark check that knows
 the migratetype
Content-Language: en-US
To: Kiryl Shutsemau <kas@kernel.org>, Harry Yoo <harry@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Johannes Weiner <hannes@cmpxchg.org>, David Hildenbrand <david@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Brendan Jackman <brendan.jackman@linux.dev>, Zi Yan <ziy@nvidia.com>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 Mike Rapoport <rppt@kernel.org>, Qi Zheng <qi.zheng@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Kairui Song <kasong@tencent.com>,
 Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>,
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
 Baoquan He <baoquan.he@linux.dev>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, Dev Jain <dev.jain@arm.com>,
 Usama Arif <usama.arif@linux.dev>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, kernel-team@meta.com
References: <20261102093939.3340540-1-kas@kernel.org>
 <20261102093939.3340540-2-kas@kernel.org> <auynaZkzdzL6Aeyo@thinkstation>
 <avTEezDIsJBhsPmi@thinkstation>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <avTEezDIsJBhsPmi@thinkstation>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 84EB3C0013
X-Rspamd-Server: rspam12
X-Stat-Signature: of5mm1r9o53s8g568uq1j3fqh4ksr4b3
X-Rspam-User:
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1794589388-433208
X-HE-Meta: U2FsdGVkX1/9dyb9b3n6F6UTI29gWsRxuAHvG00HE8tCR7MFjLtrCqu7lgNphhRNtAC8SDF52JzvjQ0LIaPTEbSJWaTjw+xFKeFsGrh9I4zsuE1bOiqsY2Jav+pM3Zc/Epq6jfn80KGmoOUgwLxdVSMk/PCrCg8V5dgvuRpGCFNGZhzMaE1NnSjaBsYfFIpogePdSoKnQl2vuikRqL1gIpUxCG9TPTv90uwpdLgLl0tM3DJ48AOFqJOVERvWXK0xqI5wA1ZPT3l6kb1HrrWLd90nMVU6fOx1F3eA6xkYob5ywhQqbVfXRcUV+UB+1xVXyEONh4C3Il4Lv6cnshK3eXzqLDwsvyrmQVnc6WSMX2AIPlfAmLupvLaUQBn6fPJSyeWVm81DhB3f6aSiPJ28xjvwNMerZtI5XNRKYzat4f0hE+gslZixq4Acp2Z9WYar7zaxWRWVAr+PmL/Jg+bl7hVlytu3FV8zH/KCgIuHX6m5wPwA9evx1qBmeseRbTh4rFFj0dr/lIrMqQliQp9oITN7KYqfqQGwwxFQfV69aCBUFGhtUeTa51LvfpjA2Ttof/1RUPxRzOwCr5ZxIXbFu42jkomf9EHbdJy2VVPFtrZJ1WK/KoNBfoa99bgxR+ZbEHXNi0Afeu880Or1eYMny58oXz3anoTXbF+2et39HGrBF/VlzlUOu3ZiGq2ZyGkSkgx6ba3fn7looU5jXvMQdZuCHdl8wv/XJvYNnzwmgBYHJwmnz8m4hAvlSEr5WvGUIg7FA/IzMVamRFdOpGMNNYRzV5byuQp2Y8bDOog7UFoT5qZGJnPSRUf1NMghIWqT9XocTNkaeTuw5nJF9u1yLke4fYeW4/JTLhO3X5rC2veQ0+9T0+TdbLQx6UNm0R9fb2Yyk4gBBIEyMd0QpGCTJC2NIGgeWHHYNF0y2AZYydKGaJSAdZgoh9J2D/2PHXDWHE7Llu/5/zlSHnfymGT
 68cd3eBd
 PvOcTs89yH2PXAQTk2B3XaC9dt0ZViqOszHlPAh/3keSkBdaxeBbfABQyjIjxFa6g0KpnKLFW/ONVr7uaPUjGcrRN/dCZwF5x/PTfbbKUNa6iSlCUflaBjeBEiWxGeidXLt+VwNaboBAu5pP7rzPcdmcuEd0ieXF5yPwDYZiodAxgfb4/IBtaVPyLg2hnkXOp6sHYlQYVIIB6JREofBX8XwWx9fEO87WA8np43yHE9/6krxdL8P2MSWGA7vK798DSlOt0jdTG4dsS+SGseKGUQTdmBidSI7iRQ6rr+8MElK4FQszLhzLDfI/GHHNLlQM2MQrOmyI43qLl03gSX47j9b2WVQOdUjYXlSCYJa/PIU7wHnqVRQgJHm/T0nTdr3X/pW522yqef8AAsgbtZI3AdAR1hBPPp92OKVdQ8yVEwxrjVGdMHjt6y932AkqqZUqhjQ/FQKrClZAJrOo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/11/26 20:49, Kiryl Shutsemau wrote:
> On Thu, Nov 05, 2026 at 05:06:39PM +0000, Harry Yoo wrote:
>> On Mon, Nov 02, 2026 at 09:39:34AM +0000, Kiryl Shutsemau (Meta) wrote:
>> > The high-order check in __zone_watermark_ok() accepts a free page of any
>> > migratetype.  Under ALLOC_NOFRAGMENT, a request below pageblock_order can
>> > only take a page of its own migratetype or claim a whole free block, so
>> > the check can pass when the allocation cannot succeed.
>> > 
>> > Telling those apart needs the request's migratetype, but not every check
>> > wants them told apart.  A check whether an allocation can be served now
>> > has to count only the pages it can take.
>> >
>> > A check whether there is enough free memory counts every migratetype:
>> > kswapd and kcompactd balancing a zone, order-0 thresholds, the
>> > slowpath's forecast whether reclaim and compaction can still make
>> > progress.  Reclaim and compaction work across migratetypes to free whole
>> > pageblocks.
>> 
>> nit: perhaps we could make the changelog above bit more concise.
>> 
>> I think the necessary bit here is "With defrag_mode, allocations cannot
>> steal a page from pageblocks of other migrate type, thus
>> __zone_watermark_ok() needs to take that into account."
> 
> 
> It is ALLOC_NOFRAGMENT, not defrag_mode: Normal zone allocations get it
> on the first attempt when DMA32 is populated, with defrag_mode off. And
> such an allocation can still claim a whole free pageblock of another
> migratetype.
> 
> But fair, it can be shorter. A tighter version is below; it also says
> why kcompactd passes MIGRATE_MOVABLE.
> 
>> nit: maybe let's set cc.migratetype and pass it?
> 
> The value is not read there: __zone_watermark_ok_mt() uses the
> migratetype only under ALLOC_NOFRAGMENT, and kcompactd never passes it.
> kcompactd_node_suitable() makes the same call and has no compact_control
> to take it from.
> 
> Thanks for the review.
> 
> The new changelog:
> 
> 	The high-order check in __zone_watermark_ok() accepts a free page of any
> 	migratetype.  Under ALLOC_NOFRAGMENT, a request below pageblock_order can
> 	only take a page of its own migratetype or claim a whole free block, so
> 	the check can pass when the allocation cannot succeed.
> 
> 	Only a check whether one allocation can be served now should count just
> 	the pages it can take.

Please try actually reading this sentence, does it make any sense? It
instantly reminded me of the meme classic: "Has anyone really been far even
as decided to use even go want to do look more like?"

> A check whether a zone has enough free memory
> 	serves no single allocation and counts every migratetype: reclaim and
> 	compaction free whole pageblocks across migratetypes.

Oh yeah always this damned style again. What did they train the models on?

> 	Add __zone_watermark_ok_mt(), which takes the migratetype, for the first
> 	kind:
> 
> 	  - the allocator fast path, zone_watermark_fast();
> 	  - its recheck after node reclaim in get_page_from_freelist();
> 	  - compaction's up-front check, compaction_suit_allocation_order().
> 
> 	__zone_watermark_ok() wraps it for the second kind.  kcompactd shares
> 	compaction_suit_allocation_order() with direct compaction and passes
> 	MIGRATE_MOVABLE, which is not read without ALLOC_NOFRAGMENT.
> 
> 	Declare both in mm/internal.h: nothing outside mm uses them.
> 
> 	Nothing reads the migratetype yet: no functional change.  Preparation for
> 	making the high-order check honour ALLOC_NOFRAGMENT.
> 
> Looks good?

Not really :(



