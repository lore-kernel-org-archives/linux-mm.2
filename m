Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 72847C982DE
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 10:29:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 829296B00B9; Mon, 21 Sep 2026 06:28:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 801226B00C5; Mon, 21 Sep 2026 06:28:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6EFBB6B00E2; Mon, 21 Sep 2026 06:28:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4CCBA6B00B9
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 06:28:59 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A6D4112012E
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 10:28:58 +0000 (UTC)
X-FDA: 85237396356.05.7322DED
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id EB475A0002
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 10:28:56 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NHjCcWDp;
	spf=pass (imf15.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789986536;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PlSPagAiZTiQz4p1UDMuSA1ZHbZ+Mis1oRiT6ujoT9c=;
	b=rfzMbH07rNlhNGBZDQ0QXYo4iuXWRk92ky2ct5vS7Q+grOuf4N2m3x5MAIV/oZNpnJ8yNF
	zq85g9BSxpUxrd8ffoVHDAYHRpT1E5L5/G3qS104wS48OhFqCYvY9kohf+nKhRzzi5Itme
	7KUtW3aodT+cqZFxk0a4OdvSd5c8BVU=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NHjCcWDp;
	spf=pass (imf15.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789986536;
	b=XeJZzC2X68VIwkX4l3oNPrpR+PbSm773FXPpBA+15XjZW3vclSGo9PZ+gK3geZBBFPIy2a
	nr9d9ma8M8G6IdakkciqiMYBiAY9uNgon92S4GCEn20oMr0WrlJzl3b46NjHdv5nRqZ1u6
	dwmmr20/f1I8tVK9cnvXkdE01mg5BPc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 7E518600C8;
	Mon, 21 Sep 2026 10:28:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 984941F000FF;
	Mon, 21 Sep 2026 10:28:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789986536;
	bh=PlSPagAiZTiQz4p1UDMuSA1ZHbZ+Mis1oRiT6ujoT9c=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=NHjCcWDpZe59HM++m7X4aNR69YVOC1Z+RtPkRp+i94WQaXfwcRi7zXYuU8hc8WbyO
	 LZFtc+fCpBArY8l/DeUW6tBGsZcCCO5+7DoDMAfG+wYavc47bWqAmedj3vhYc4jewU
	 Wk3jCMNtdDsvX5FY7E3ki2Ya8NzgHs1KH+ykl0dpROlMayIZx/vWk8RV/D0FApB3BG
	 0WdC9PCKTwgLuKFMOa4psJWR39shP0te6x673fzoJS/aUQFx0Be4EE3rJmsneIs1bJ
	 /Er4O0DPZC6odkW+Es/edHvjScV3Yd6S+c6YuWM3OgU8RYYuYTCacj/kqCcWgkFGfm
	 k2Uww+ro0suEg==
Message-ID: <244ce64d-b7df-4a76-bcf9-effb0c53073d@kernel.org>
Date: Mon, 21 Sep 2026 12:28:47 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 2/2] selftests/mm: Test per-open gup_test pin
 ownership
To: Richard Cheng <icheng@nvidia.com>, akpm@linux-foundation.org
Cc: jgg@ziepe.ca, jhubbard@nvidia.com, peterx@redhat.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, ljs@kernel.org, liam@infradead.org,
 vbabka@kernel.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com,
 shuah@kernel.org, linux-kselftest@vger.kernel.org, kobak@nvidia.com,
 kaihengf@nvidia.com, newtonl@nvidia.com, kristinc@nvidia.com
References: <20260921094243.64698-1-icheng@nvidia.com>
 <20260921094243.64698-3-icheng@nvidia.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260921094243.64698-3-icheng@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: EB475A0002
X-Stat-Signature: wgferzacastpwu5opmjoikmnhmdhkwzi
X-Rspam-User: 
X-HE-Tag: 1789986536-919119
X-HE-Meta: U2FsdGVkX1/sDB1aRqLzbuMwbN9E2oc4/f96OPuwYAIsRt9eoHTFZyN5Q9Et58B6YGIm02Bzk6Rt/5+mZKFUyJ3DXi1sQY58zPItQGhSNfLvoCpC8IhNooNLXJ4J3X2/0Cf6XwuQ+XD9GopL/N9XCh8NyJ38MmBiDere/WQVy2FvCxR86/FkagwI1HqIMEqWLappkNkEVwu3UIOAL4ORXtvD96ED6T8qJXae+Gp0ohgxyuz5YODQZNi3ATJXDqe34MWigR6PtqPlcbl5kpcIBj6+uchW1Z5eUZ9F2XkcRKJ8yxDWVdSB7aw+I054G/WKob+8a4QAqYOIkb9bEoSkukNu0WEgFOMunuex9k5MMEwlnyHutjs1J0kep1Jj6C1W+T8sjXIYa55l71yQ4X8mzH+1f2599M+J/3CJPrTH1ZIxXVJhe9FR3msOXVNdEruNz+w5CCFJyjQDcoOFCvw84l/0lVjsdv6MaEsEnL57hofMbJMnKw/RQT9o0LucFXsdqN4dcrvlbogAl1hoG0C6VcAOHe/S5nVRWEYYCoVniUiacUZfFACBxwCsTBIU2SYznueTLCL6lmeK9gajzsyw00NR9MNPbOxOIjOa624E62H/aqRsYEjPPk+66YnOArA7c12XFdoiZJMRpG5QpHTdBX2+rVd6ji4pjJvX9NgtK+1MuBEBt50mLPFEmtMI56OgHRH0u1DKxp5kfkMHuwbb8P94PAtmQC/8ytksVlz39XZ5ifTlubE2m+7aqtqk5Va9WA+7cBzB5QCd+Ve9KswuKqcXvWEvzT1E+pIFOKFLzr8T8XteO2kyrtb5IncVTl2BX3f6qwy7b8CwjKK6bB02rq9s0ppnFoJ7JdeaIBh1foRdvaoO/Put88shqyOQxpc3J6ElW1cPS/9h6l8I+0n+46kMZ40PbxepyuGrqbdrGo9NbjPg6U8NOJJkC2ZZpnHc0/D65z9LugAhcAAQ4sT
 nHwRsTvk
 9iIA7Qxaud2miPfyzuwW/okIYT3+iabsV7h0QZrAFC0vsoAK6sLDnMvV3bz6cF350zPW998ImWLaO3tnxhaskRpazbiWkD/2AIQ+s8wRiO8ZfnNhjH3WNbIBrN6hkyzSYzeiupEFGJcswA/3mdk7WBRK3cyjGCzWwkzf9VEIPtnYYLOPFVHm9ouFb3X5tB4TUeB4/7TDE5cQnAgK0AiWhZfxAUOsid47T7RkbXsdpemEO+F6ZOYbGY5WvyZPEQSTAAZd6xVA8uXIKwo+qBVLvqGnh2Jq3CGfJcrJ3pAm0R1QofpN2/jBqY3uzTFUg1uqS1B2bJxZqCPh7+mc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/21/26 11:42, Richard Cheng wrote:
> Long-term pin state should be isolated between independently opened
> gup_test file descriptions, while descriptors created with dup() should
> continue to share the state associated with their struct file.
> 
> Add tests using 2 independently opened gup_test descriptors. Verify that
> stopping or closing the second descriptor doesn't disturb the first
> descriptor's pin, that another START on the same descriptor fails with
> EINVAL, and that READ fails with EINVAL after STOP.
> 
> Close the descriptor used by the existing test matrix before running the
> ownership tests. Record whether gup_test was initially available so that
> a later open failure is reported as a failure instead of being hidden as
> a skip.
> 
> Also exercise the shared-file-description case: start a pin through the
> original descriptor, verify that START through a duplicate fails with
> EINVAL, close the original descriptor, and use the duplicate to READ and
> STOP the pin
> 
> Reviewed-by: Koba Ko <kobak@nvidia.com>
> Signed-off-by: Richard Cheng <icheng@nvidia.com>
> ---
>  tools/testing/selftests/mm/gup_longterm.c | 258 +++++++++++++++++++++-
>  1 file changed, 256 insertions(+), 2 deletions(-)

Sorry, we won't be adding tests for gup_test interface functionality. This is a
testing interface.

(I'd be quite surprised if no LLM was inovolved in writing this patch :) )

-- 
Cheers,

David

