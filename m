Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 34260C43458
	for <linux-mm@archiver.kernel.org>; Mon,  6 Jul 2026 09:04:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1368A6B00F5; Mon,  6 Jul 2026 05:04:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0E7B76B0107; Mon,  6 Jul 2026 05:04:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F183B6B0121; Mon,  6 Jul 2026 05:04:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BCDAF6B00F5
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 05:04:04 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 5235E168796
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 09:04:04 +0000 (UTC)
X-FDA: 84957764808.13.2377D2D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 8F060100004
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 09:04:02 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GETY1i49;
	spf=pass (imf05.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783328642;
	b=wJCbbpjxhQQwI9q6XCH0juCsZISeF5wejbUkztahQ+xzq5qNlPwGdgpvHqEl/xM1jRrAJq
	GrsPMKoFKKxwD8rmkYGUDmaKFdj8M7gJ+yRZw3VZ4MCzj+epOE1AyH8gwV4j9CwPnwjBiy
	8/1qFt6gQSoHhlyJvU3R9STei231YqA=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GETY1i49;
	spf=pass (imf05.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783328642;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5OarufiuowxPUUgdW+NmJtZnc440F7WatBguGIfARR0=;
	b=N+IqLvOiUiF88qqcOCyqePnxUHJu1K0f5Goan9co24Wtn0QafEMrGnlAr6FQazAQouIoPH
	lsGvqwM1fonpuvu7QrN41PMsufGw6COxB6iziGedh7nJGrGghaq7p8cvluR5sA80yNKfww
	SZ76tum3dLu6OW4x2ewCDqnl7tdzGk4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B9C56412A1;
	Mon,  6 Jul 2026 09:04:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 782CA1F000E9;
	Mon,  6 Jul 2026 09:03:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783328641;
	bh=5OarufiuowxPUUgdW+NmJtZnc440F7WatBguGIfARR0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=GETY1i49QXGftXhugiIMCearNR9AkhC56iuKwK0t5K2wOH3wfrhyFWukEzF/EnV4t
	 v8UT44jzjaY4v4xI8UYNOW1K2G4EKo7CR6+mEftyizJ3l0iQ2Cak5HbLGOar5xxUTG
	 8FTeHUWpquu6ToYIt89/Dx8HEsB/P/fgsRBrM25LrTmP1m1aZFu9NA0W0zSKmTpiic
	 lIC87+DfZSD1R7fpcSOCUs/iUAkKP2eFUH1/PNU1gloVziFDiz9Xn5NO2wjXJPXAtN
	 3KHR1PIp6A/gpDJmy0ZyOiyEwMqeRCnhZvAmPJa3IP0UIJJNNmtXdbbWFlkxWAq0ix
	 xnA8LlPPXtjRA==
Message-ID: <2c619662-0e6a-470e-8698-b74afea758f3@kernel.org>
Date: Mon, 6 Jul 2026 11:03:51 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 0/5] Only free healthy pages in high-order
 has_hwpoisoned folio
To: Andrew Morton <akpm@linux-foundation.org>, Jiaqi Yan <jiaqiyan@google.com>
Cc: linmiaohe@huawei.com, ljs@kernel.org, ziy@nvidia.com, vbabka@kernel.org,
 osalvador@kernel.org, harry.yoo@oracle.com, willy@infradead.org,
 osalvador@suse.de, jackmanb@google.com, hannes@cmpxchg.org,
 nao.horiguchi@gmail.com, william.roche@oracle.com, tony.luck@intel.com,
 wangkefeng.wang@huawei.com, jane.chu@oracle.com, muchun.song@linux.dev,
 liam@infradead.org, rientjes@google.com, duenwen@google.com,
 jthoughton@google.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 vbabka@suse.cz, rppt@kernel.org, shuah@kernel.org, surenb@google.com,
 mhocko@suse.com, boudewijn@delta-utec.com
References: <20260705180714.3708947-1-jiaqiyan@google.com>
 <20260705115045.eba41efda0c46121b1d10827@linux-foundation.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260705115045.eba41efda0c46121b1d10827@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 8F060100004
X-Stat-Signature: un69cfc3mag3mfaoo7u35q6z163gcydn
X-HE-Tag: 1783328642-541860
X-HE-Meta: U2FsdGVkX1/s20sY+oH3fTxbz/8IWV1nZzrUSht6nJmR1K31jvHeKdZdoKAQbv64n8w3AHhS3kX4rJDnIXoJ+S8XIkhkS21h9sUr5YrTlzQ8crSJF8EVFOomnixJoW0p/TX48wXohL7BKSk/2ckHiURABkVvGc+3hK+6yL5Durf5i9TQBwX3GSC70XgKzR5mczhf2mEPcirVQe+qj4sPoTvPNHEikJNdE91mkaJS4ln60F0zugP3NGEQTnKGA9IpFr2QkTUEPB0QxyFbOT6OBxI79H7hON0xxnnHwIqwpi7GnBRANl12MXrdTt/XCJcwDVQfz7Yke5Wf6I1UDLBmVzh5oPKxOxKRYhjBctjniQq9y2pAwUxsivbXFgVvB4QBJDWA5R94WA+XIFpmPGKiQUWChASGUn46zqrpFxAFPFYoz0wpd73CVfZ4UICtLBQRu40r0rlam9cwgh3wAfQGolmegR9go0WQUxkF0vwUOr99fVJcrfL7UQVSsasXX9c4cI3V/xO9H3zkSBynkZtOu6RsrkwU84vPlgrE1jj9P1n7t5q84l0vSAgYkGCFJ4SgESHMSzSkve8yLayOkhgDe6cJ6Jw2HXleD0fIzMDBXJE426RhQfJJv3vxWHtLp1QwkWVtYlwlBtnSgAQrDj/G6KJCu6jeA6M5WLR12tPK+0vq0tq/Wc9o4BanaJgXcXVN6YVQ3hNbDKGeCDKHA0kk5/n6wBGXBWI2Xz8EmEpihyTFKOWqjA2ZHRRdCry3f0geZee5xE8nwPEdkqymWA1wrI+UnSgxCb+H2u+DQP0SaBBlktIMpoz2hs1cHAZTSIJqeKveleAuGWFOq0XHAX+3qCpDB4byK9zypXtM1xcyjra34vIoqVmBAX++GpXvsBYsMleoEYXiK3aRfovtBySkBhAWTr9bcdUwEa6RrP/C989cQDoW8W8Cl0zW0fI6yE+EZfaAJ+6S9Cw7DU1xIIb
 1Sni/uql
 XSncf9Wnw8Av4wZtAWzfMslcjEr2aSjTNL1C+vwDZ9Cbir42LvRhR3bl6tuvSQ62mICXHx2s9TIADVdR6qKRlOEbbzLBzMAOedwJIWsECpwDtaLGAiqjFQQ/4/rUnvE2ATSA27l6Iyad7qy5/CZ3mGL+LJV1JVLH4tS/kTN3cudW1FiHWexH8LCJT5xzb71JoeXW8ygQw3kIgwXSLVtU+IF0W+pOqiEdhH8SdzcYxVqtGTm+VwwJLL/oW1VaR9KY+Up3G++JtUbm9lUZZgdR1CUe92J2/OfxfQ0T0XOigU1TUnwSEfCYk9SMvhu7iEUKpiQhBiZ5S0ED9l1Raw1quKRTAyFQh/6hLFSQRSoV2OaTVSNdNwRjOmy5i48I+0vWBe7BHtUJFDF4NQmeMICungx0UzQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/5/26 20:50, Andrew Morton wrote:
> On Sun,  5 Jul 2026 18:07:09 +0000 Jiaqi Yan <jiaqiyan@google.com> wrote:
> 
>> At the end of dissolve_free_hugetlb_folio(), a free HugeTLB
>> folio becomes non-HugeTLB and is released to buddy allocator
>> as a high-order folio, e.g. a folio that contains 262144 pages
>> if the folio was a 1G HugeTLB hugepage.
>>
>> ...
>>
>> Introduce free_has_hwpoisoned() to only free the healthy pages
>> and exclude the HWPoison ones in the high-order folio.
>> free_has_hwpoisoned() happens at the end of free_pages_prepare(),
>> which already deals with both decomposing the original compound
>> page, updating page metadata like alloc tag and page owner.
>> It is also only applied when PG_has_hwpoisoned indicates folio
>> contains certain HWPoison page(s) for performance reason.
>> Its idea is to iterate through the sub-pages of the folio to
>> identify contiguous ranges of healthy pages. Instead of freeing
>> pages one by one, free_has_hwpoisoned() then re-use
>> free_prepared_contig_range() [11] to decompose healthy ranges into
>> the largest possible chunks of different orders. Every chunk is
>> freed via __free_frozen_pages().
> 
> Thanks.  I'll await further reviewer input before taking any action
> with this series.

FWIW, I want Vlastimil to ack this before this goes upstream.

-- 
Cheers,

David

