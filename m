Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C4DF0C44508
	for <linux-mm@archiver.kernel.org>; Wed, 15 Jul 2026 13:57:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D58306B00E6; Wed, 15 Jul 2026 09:57:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D2FB16B00ED; Wed, 15 Jul 2026 09:57:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C46BC6B00EE; Wed, 15 Jul 2026 09:57:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 96C0A6B00E6
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 09:57:49 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 3B71940183
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 12:40:48 +0000 (UTC)
X-FDA: 84990970176.11.9E63F73
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id 7DE9614000E
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 12:40:46 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="R/+DW4Qs";
	spf=pass (imf26.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784119246;
	b=68hHX8QOQQhy/cS14nrS4P6GIOFlSaWPcYASfpDh4Iem5LFbb2PHm5kzoqecW1BXG2fYxV
	XBXv8lyaO/QluxEHbge2m7nKMgyOQ6pnpPQYZrmwwk1Axv3AXzwfrLZuMYh2ayqDbI58cH
	1OrOH50/JksA3x099AGn6L2mvw03uuA=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="R/+DW4Qs";
	spf=pass (imf26.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784119246;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=i70MI3s/daHgb9WcIfx/WVMuhZ4GwOjC+i/kHkbzay8=;
	b=a15XLXkWanORu+qNeOjSxwZfhC5XG8+/OClGgtE7jP0B5dZoj4NllXZjvXH7M3o2BKOqHJ
	Xt564o29BUF+Ln6t7SmmLork+q5RTwIpu8fOxdYfACl2F3WqHbhnfqazSA7mM3VVqnZslp
	mp9Pi4fr9BrBJtpMqoIGYDEizOo3X3U=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 9A769600BB;
	Wed, 15 Jul 2026 12:40:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1470A1F000E9;
	Wed, 15 Jul 2026 12:40:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784119244;
	bh=i70MI3s/daHgb9WcIfx/WVMuhZ4GwOjC+i/kHkbzay8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=R/+DW4QsHagJtrTm/PTF1fKFkQUwn2RCbCtKWbYz32A5aQmLRXgW0gznkbmzP//tx
	 8wh8fGPqa+d90N7VKYCtVtrpkSTggPM4uj8Hg8EPVH9x+mjALJBzvrazvWN2J5MX1l
	 epqL0VPTJr6z6ia/yLeoW/JNUQ8zmIjRDW6gxICJvzVJeqtgOUkQw1SJ/gkEJIM/Rr
	 wbwFkdjJZaQ8qS1eF8FKkxSvz1nYKrbKum038JZNG412M/6b88ltOpD2mHwv2c5MB2
	 k+ZOISYGwdB0CUMoaOYAoHnCIe6nwYqOmRjegD1qW3p3xpnswgQPW/raFCWgAfFIfF
	 /aXPl5Id2ry3A==
Message-ID: <8f7f0a6f-d819-4a56-bb5c-d690664dd80e@kernel.org>
Date: Wed, 15 Jul 2026 14:40:40 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/migrate_device: avoid overflowing migrate_vma
 collection arrays
To: Zi Yan <ziy@nvidia.com>, Alistair Popple <apopple@nvidia.com>,
 Balbir Singh <balbirs@nvidia.com>
Cc: Matthew Brost <matthew.brost@intel.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>,
 Ying Huang <ying.huang@linux.alibaba.com>,
 Kefeng Wang <wangkefeng.wang@huawei.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Sashiko <sashiko-bot@kernel.org>
References: <DJT9Q4WLXSUG.GHQOMM41P9PZ@nvidia.com>
 <DJUUUX0BK942.1ZP1I5GNIGEY1@nvidia.com>
 <89d20411-4915-43e8-9808-3a7fbd98d2ab@kernel.org>
 <DJV02L9N37X3.1THK8MN9Z2RUR@nvidia.com>
 <a29dae55-93de-416e-9f34-b7911a2c9fdc@kernel.org>
 <A1606A10-AB38-4101-A058-8355E5E81C47@nvidia.com>
 <57cc487b-6ec3-4ca6-8735-f37644e2b0ab@kernel.org>
 <F14401B1-7388-4C5A-A19F-E031002A76CF@nvidia.com>
 <alVjyqWiAggf1mTG@nvdebian.thelocal>
 <aaab69a7-d1f8-4fba-be13-6de109f37348@nvidia.com>
 <alXFS7BJWLwH6Wpt@nvdebian.thelocal> <DJYQKBV5C3WQ.2A702GAYGPW71@nvidia.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <DJYQKBV5C3WQ.2A702GAYGPW71@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 7DE9614000E
X-Stat-Signature: 1dpqdsc5khudek55rr4wdtx4fr7jfxb6
X-HE-Tag: 1784119246-823910
X-HE-Meta: U2FsdGVkX1+paQ3g18AnE0rVnSHdAqBEYxU8mmiGTMzuRjhj/20zYqmgNORhhjqCTIQUqdoa2wJsdK/g+a5B8NbQHw2jHutMHY+hBk4xRCijhDE2dmy/wxu8EFLsLXXCLB6bL3bVwWrSD3V3V/D3KYqWg9ARCdlpBY28dnDrPWk2NL3159BTTF0m5IDaN8IQCApt0rYi+7qpY6GHYWBawy9hv76CpeUTsdZuni8OTviFD7D+E0Wkclsau+xwpSR2jSb8QWwElK0ioc0XHrR95VV1yCYVB5M57vEKaV/9o+Y4g4yzfAaqJ4SJvNytlihgQv04/TBrfteouxv1U9tENMROuq68La1DmIg7fPEPXkPgXsXnnVkMJGhPzn/3Lp79Gu11Jh7Imh7AbejCn7arO+4gkBYuSVBn8w7DPQQfmNu1s0BCVe+eZQ5jO6rF1RccTrtJ9ZhqpSAi0SeyarZ9AotM6FIaNx6oDU78tr/nk6iGdlXAdmTIDd8YZrzwpvgRFn0IRG0RPQsMHISZnkE6IFBi1TLMLmnb7QocyFl3lNmdxPsuXvOJOwtQUFN1B2/1rWLLbHOWUc7LH75P0uMQmfuxEfsygpKZyeqQdqiGG3dSu575JuX81+62ExyR7EvBM2CekCfobyM3we/H4XDjD1DyZSri2/heil0uS4cxWNegVcFFyNnXR7Gxu1mu/qHClOsrzdZ3QMnH3M5PVhYNjehP4+kI1xkjgJqEZ6ubNwCkF1VKCxKypQ99TyLiPoQcHgkxhV65sJStJVeOHwEZRAOqBImZ53rc5iEZ7nz9Od1EsX6din7OSZNhss+W5eWft6uIWCm8WdgH/4loquABbuyc8NphXx5cFoL0UQlhm3S9GVkHSiEAbZQJ4QYSDOPIrnD5VFBN0Fv75wCiG43KuRR7QYYogYsHiTe5xVE9h4Acb7J3kK5GJJExo5MyDqX3wwfwv1WAoMqxKoNWesD
 VrGKhPZ7
 nKwYhZYHC323EWT4yyKwQVW+RdxKbvmp7gBdeCABBUx1jbi7G5ECYiamF+4Gh9c8LO77JTEEN292G/MjZrjGMp40oydju0DKaZbdWaMr/m7/Rc7jtHnQcdk/5dGl7VL5rZoN7tPvOTbH8/o1Wv0PJ3MFuqumDWgywGhyP5lSHHVeX5DFex8bQ25wKoqNRxXf6P8O8f20HE/FRQLDq4i6unsoY8h8O010FtVloU7aPWd09jgZhW5FDbZqt8GrOWA4O1akQ1Uziq9mGLORt4gHDXXT0WPDsXhqzOeDLRMDbdvol1DNOZTlSxVZwr5KAixPwzohWe6OvD5Ht5h8PsRy0Wdc2bXbBWZC6g7l6X+k3eRED7L739mkA2hp/iCI6UC6bR4JStcyl64+Wzsn1W4KVt1lyyg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/15/26 02:59, Zi Yan wrote:
> On Tue Jul 14, 2026 at 1:30 AM EDT, Alistair Popple wrote:
>> On 2026-07-14 at 10:10 +1000, Balbir Singh <balbirs@nvidia.com> wrote...
>>>
>>> I had a patch to add tracepoints to the code and some of that instrumentation
>>> included this data. A combination of the trace points + hmm_tests will help us
>>> get some data to start with.
>>
>> But hmm-test already has a nice bandwidth benchmark :) We just need to force
>> the slow path. That used to be easier before I simplified the trylock handling
>> but with the below patch applied I get quite a lot better perf from the
>> optimisation. Note the patch isn't entirely correct as it assumes any locked
>> page was locked by migrate_vma_collect_pmd but it's good enough for the purposes
>> here.
> 
> Thanks for the numbers. If I read them correctly, the optimization
> has about 3x throughput of unoptimzied version. The optimization has to
> stay.
> 
> I will try to come up with a fix that resets collected PFNs, reverts
> established migration entry along with putting folio ref, and restarts
> from the beginning.

IIUC, with the page table gone there are no entries to revert. We only have to
take care of folio lock+ref.

Which raises a question: how can the page table be gone when it contained
migration entries? Probably MADV_DONTNEED could clear them, followed by
reclaiming the page table, maybe.

-- 
Cheers,

David

