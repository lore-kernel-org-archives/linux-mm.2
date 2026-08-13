Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6AF90C5B572
	for <linux-mm@archiver.kernel.org>; Thu, 13 Aug 2026 10:26:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 484756B026D; Thu, 13 Aug 2026 06:26:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 45C4E6B026F; Thu, 13 Aug 2026 06:26:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 34A2A6B0273; Thu, 13 Aug 2026 06:26:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 08E586B026D
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 06:26:32 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 8B74E80592
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 10:26:32 +0000 (UTC)
X-FDA: 85095867024.20.C710F4D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id CC76C180003
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 10:26:30 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=co3Dplmu;
	spf=pass (imf24.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786616790;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=63X3AIgj8JfsQGRG7V0b/K2oGLZA2KXTTSoU5TCUlQI=;
	b=2QBVyypcLFsgBE4l0oovdjSdXf2Q1v4iD/1droXjaFayKdehMIB4N7mCIVh6sd2W89lIm9
	FvV1k2yisWZkoDksDKZR4A8hccIYtFxGjzvb5VndZfluv3teNHJWczACTSutv7VjfLcZhv
	x1nYsHv9bxWgBOrS6iNR2BdETp72Ckk=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=co3Dplmu;
	spf=pass (imf24.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786616790;
	b=jr8k+IlTHhYhT+KZMmQHpGyh3YkpKtu+SaERvjj6Fo4flTGeeGJ7VjiNfAqkmAEpDzpqXo
	mcsrH9ZG1lose82HzL25Kb7Yb1A2MKBzI/spOfDzGb3WRiJ5+Mhzb4+qMT8ws3iS1O66K4
	V/IR6AXSseuBIM61o7+s75dIOQUzZ7A=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C60C940654;
	Thu, 13 Aug 2026 10:26:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C67591F000E9;
	Thu, 13 Aug 2026 10:26:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786616789;
	bh=63X3AIgj8JfsQGRG7V0b/K2oGLZA2KXTTSoU5TCUlQI=;
	h=Date:Subject:To:References:From:In-Reply-To;
	b=co3DplmuaRys2xtTZIEKEfc0GJMr8C8nVg1x4NKVUUTK+N7gBxkjAfqzR66N+NQRs
	 jkC+bJug7TAzMdGPWu1UidDM9zqzdcLXxBynRZUjhKUqLVTVOkuiwTjLNBHnmbpMfK
	 5pz7qvVJGJ2Y/JBy+w4qh9cYekzjneCZ3koLz1lYBfZzw1xzQzTDkIjjSIkVPWhAgW
	 ol0kLRz9uf+2Hwjz0LUCr1jclUYG2sd4fNT9w7rnL1blBdGW8alSXQ0x7bnk6+Y/d9
	 SuRNmIITngVHYwsSJMInZ5y8XRcao3PS+iZOx3MJSjG2Rts1hD9vbd4LjJ/iuJPfz7
	 RFr5M4UwCtWZQ==
Message-ID: <e372f10c-f964-4cd0-9a48-c31702968153@kernel.org>
Date: Thu, 13 Aug 2026 12:26:21 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 3/5] selftests/mm: skip khugepaged swap tests without
 swap
To: Muhammad Usama Anjum <usama.anjum@arm.com>,
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>,
 Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
 Miaohe Lin <linmiaohe@huawei.com>, Naoya Horiguchi
 <nao.horiguchi@gmail.com>, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
 Kiryl Shutsemau <kas@kernel.org>
References: <20260727095225.372655-1-usama.anjum@arm.com>
 <20260727095225.372655-4-usama.anjum@arm.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260727095225.372655-4-usama.anjum@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: CC76C180003
X-Stat-Signature: k5skqx8rrdjueajtg4ex8htiz9c5p3dg
X-Rspam-User: 
X-HE-Tag: 1786616790-486167
X-HE-Meta: U2FsdGVkX1/OhxLo3sePr7nSSjTy+Dj//LrjYPS3ojEb/3XYkyb4zUoX12m+y6AQl9jby7+/XPROdirQBvwhmJgyXe9Pv7qvcVX3OHULzLrMpVNgmoV9gSekl5wzv5ksLxmz6BH6lx5NttRtx8HgNKyWtjRJC7VDhPK62eAx6PowULmhtnOgJ+OeEaTUumNkJbFz8EwqtOLja6ZI2bvQFtePme+oOjqxk4x6BnMtd88FKGz/oYwUts75YoYaoxTX1ez88yLgFHWF1lOP5IeV48P/YbdNmmS0eBN6E776qC9001QFUzjLin3Ql/F1bJTP1lFXaVuA/b79vng96nWlpBGdLPsg3X6bq1k0jACdqiqrDVP0lbEfyOEhACtA11ym9rVlf75m/XfU+wz4MxssJkcVrINf8SLMqDoZCtz6WH35gHqGyAJDc4fUwTSJ7sfWua+tA2zpH3qoALgN/28AZXAhhDIS10zy+vRnG+MQXz8yQ8Uuz6BAtJtJNlC1Aqp1vflCklSy5eZ0OoEOnpAOGdGjVcvLHxmJbxX4uFjEqPZVcAQ+MRHwwloynP1MKWe1kZ57A9Pu/S575wdCI/8rLtKjmf0/OK0buZ48K9OBwfdco77DMSdzj5/42TJn1Dc9Ypu4jQoxJmBAt64kJeAiDgGLZCdvJDUFLEOINLyoXL3/1rJIg3iRihypMLF1SYe6eQOWOmS6O5SZCr7IEI4PG4ptqPzmyMvHzb1IybRTzfGtgVZxOIwwP7HKnEc/6VOeQ8YPQ7Kf4FsKzk9bJcLyUJ8GbM4RnSP+tjMIcjljh5Nhmolcy5fnADGAGR1HK6Qa7dcQaJyHH2IoUWdeD6bCFfRCG4UNEJCBXsJW0IoX+AgNLJOsp2EsFVPL1SLW6fX5GEQkB/dRMWOB3mydUuXjirgZrY0Yy0I4Rw2AnIqqfO3p5wvYCkpEBKxYf66oCou4D9RKCnKZP3MC2Kn3N5X
 bFmrCg52
 SM8x9lWpfx9zLm1q4COeVzPSj4qACrvmXX+J/TcappnLO6rqpxGMOx3o2A8VHqbml5VOiBdTWliuQ6WTF0DDbEdnWEICoGzWNx9zVmPak5KhDC37Vtk1bhWYj85lc5F11KhcR37l7rhkPEU042y86quG4XaExjBkYe4ReOC/SI0YmfjdrbQG2RR5Uok1BIAKE/meWfyx0myTSiqrqUnxWhDCe4oEkPtiGfoCiwirWuRe7uI9XR3YxIU/jMulXvyk+/b8G7FbbjQP0U1pTg+EekIqLYcK6XAkP6AnBr0FxDqZsE4NY2ym1xomngvxvqeMbcv/vZWCLHydG1Qeb29UuLYQ9dNLla1DKJM93HBIID1WjLuMLcaceHsuWqgRLFQzyVUAvi4mlB7CvysROkYx59BfDUZZuth7UyG7Gj8z9aqPdZQ3GR5lkkT/aAkhmhyiI8HKK
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/27/26 11:52, Muhammad Usama Anjum wrote:
> collapse_swapin_single_pte and collapse_max_ptes_swap require
> MADV_PAGEOUT to replace anonymous pages with swap entries. On swapless
> systems there is no backing store with which to create those entries,
> so check_swap() reports missing setup rather than broken khugepaged
> behavior.
> 
> Swapless configurations are common on Android and other constrained
> test devices. Failing these cases obscures actionable results from the
> rest of the khugepaged suite.
> 
> Check /proc/swaps before either swap-dependent case and skip when no
> active swap area exists. With swap present, retain the existing
> MADV_PAGEOUT and swap-entry assertions unchanged.
> 
> Print each existing swapout diagnostic before the prerequisite check
> so skip() completes a KTAP diagnostic line instead of emitting an
> unprefixed message.
> 
> Signed-off-by: Muhammad Usama Anjum <usama.anjum@arm.com>
> ---

Didn't I reject a similar patch recently? :)

Ah, yes, actually two similar ones:

https://lore.kernel.org/all/9d0d98ea-05bd-43c0-bb36-68aea62cbde8@kernel.org/
https://lore.kernel.org/all/20260715133418.170386-1-jaeyeon.lee.dev@gmail.com/

And I think what Kiryl proposes is actually the right thing to do:

https://lore.kernel.org/all/20260812132304.199287-6-kirill@shutemov.name/

So let's drop this patch.

-- 
Cheers,

David

