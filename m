Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 33351C5AC67
	for <linux-mm@archiver.kernel.org>; Tue, 11 Aug 2026 18:49:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 068026B0099; Tue, 11 Aug 2026 14:49:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F34216B009D; Tue, 11 Aug 2026 14:49:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DFC546B009E; Tue, 11 Aug 2026 14:49:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 9A4D86B0099
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 14:49:55 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0FDDE1201C9
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 18:49:55 +0000 (UTC)
X-FDA: 85089877950.28.0E53997
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id 35EAD16000D
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 18:49:53 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=R6N5n+wl;
	spf=pass (imf08.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786474193;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+dHjbBbWrA37kJZ885T7+w7Pqd1cWVUcE26OuZvp9OI=;
	b=6ePM0Bio3QHTCX0I9pRpyYkQWIWPMJH1f/kH+kIQ33kA6GnX6lzMaWdONX2AzRYwqkoo0a
	In79bMcmcJc5yxELoCPKJ5cLr4agtRjmNFQScOt5AZUnOqjEtxL7URP7v6xIRavEqL3wri
	643NTExOvzho2BPcsAK7PMMOfl+kKHw=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=R6N5n+wl;
	spf=pass (imf08.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786474193;
	b=jtqTOJW/Z1pi6jeB+tDisLon2VmWK/Okb3QO/X5RI5K49ksa+TPTp3gfLO1Qv1tKsFGFzd
	KkTZGtah4ZwzoHN3OUgzQhXHM8FHnXWO5yulsKl0A7PXwoIurGivGesxb8IkJARwNeIqKj
	CTT+8Y2LftnXh6Xkn9QtH6AwXcyqF1w=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 56C7D43AC9;
	Tue, 11 Aug 2026 18:49:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5626A1F000E9;
	Tue, 11 Aug 2026 18:49:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786474192;
	bh=+dHjbBbWrA37kJZ885T7+w7Pqd1cWVUcE26OuZvp9OI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=R6N5n+wltg5SKuy1zFP2wSZLF27S6MWlYcXSpL3NHa+lUH9btGWYqeIdvUplTrP7r
	 iEVi5GyaYufCpIxfcywTLoKRdBiKm8CsnwUha1v6ubg9uIZ73uUnUHMKqVhr38NWeL
	 mZ5bVvX7vHHviBUOXUH6vuM7q3i879fXrifLytL+Xn4JiAZeRK8guJE23Fi81MRrYS
	 ib91J8Ih6KCCk5lqVjlQtjnQToq1Qz5+piNOIwEeSppr95YiXa4Z16+Q21RC7Rjdts
	 u/dOVGbaBeqGdIxowKOi8nt4gwtEDmmUL6lawHUcq8S+rERwN0i+QZRfhKiPJzo8T/
	 rywTFKdkmTs/w==
Message-ID: <0ec056ff-222c-42a4-a737-0bd65d1f0a93@kernel.org>
Date: Tue, 11 Aug 2026 20:49:46 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/2] selftests/mm: add stale walk->action race test
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Hyunwoo Kim <imv4bel@gmail.com>, akpm@linux-foundation.org,
 liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, surenb@google.com,
 mhocko@suse.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260811161949.3879321-1-imv4bel@gmail.com>
 <20260811161949.3879321-3-imv4bel@gmail.com>
 <b27f03ea-414a-4ae5-9649-2a05398fe082@kernel.org> <antoRbvwXVxoQ7Dw@gremlin>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <antoRbvwXVxoQ7Dw@gremlin>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 35EAD16000D
X-Stat-Signature: uzznxdgponn8w5pf3pbpz3spkt4zn6yt
X-Rspam-User: 
X-HE-Tag: 1786474193-12613
X-HE-Meta: U2FsdGVkX18Edny56rLhIexYQE42TleByzKzG7KtLxy+4LP5FcsCF19eAO9BtP6bDMsf21mDlt4xZKxZEGPzry5la1En3fWvRQh3mMLmOgxFqQh1fZQcXFE6glisDSUSdxov706sdwfyCqRXkt4TgFe4bIn/rDfRzbal9Y52b1E68ks5V5P4iiu139zKC/PbB5UkbGTBi+O1NMW9NZtUzYU55Puvpq6MKu56Yc1z8GPi8aqpYF313JT8c3a6UfxeGHu18lHxdsf474fUqKHZcdLIgn4E2PGPRejtrSfWZuWiy0BL6S/ETvEXZt6q3yuqJY68IRR8l3sbXl+ckhXUv7UGcoQMkog4Ufkf8RrO7BHzAp84yw/VH9VYAHPQbNJlzaJi9aCnIIJwbWM89S/AgIk7tdpr66V3qi7efXhS7mWXhZrGwYTHWVFJicGvt93kpx+oSq5l4RyB5OHxuARhmd6WA4nO3ocqW5YUAY2eDECM866RaNBbsvsgNTUCUApbjzNRTp/okk1bPHMa8ac+VYpwIkEX1u0mN2YBjy4ngaxRSvqZc+ZbCddO5RwmZlnWie2CajHN72BWOD1ngZehJQzKrXGtzakknvrepbmUvv8L7ipviYr4lSma3esdfcXAZcwSOfbq/HkVvSe+jkyQjsZozyPVZY3OdcQWUdnC/xBW8bWijoDqwy5rzJ6DWKcofJe89tDpzUs0egqTkKczHbC1T6eS1/0jfnPflFVTO7OyA7K7xcagdNLdZIJrg+QhqE13UpxA2UWb4lZ/7JfQdrL8bGsWZi35gp2rJSVMXEAwyoWV1L1y4uYKNk5OXoQ5HOU55sXrL/QgKFxzpTbox+wjDViW69y+Eh6lR3Wxtl/AZKpRRIKWIy5qFImBa5ZY0GNMmFFn8KywLuRr+0RVUYdyh6XeUH0r10TvVvgUI6nfhIeVuXnMCOq2d6mGu9Po/wGHe4aIm2X3QmEm4c4
 h/14TFUJ
 RdUtWRofyA6DYY+ufmX4Zy4QVSsjXdN8SIc4eUtB4Y5Fx9r/Mt8vzMTYBEem2QZ5TgI8skp6T8nsmfS4AD1XZJFwX/qkAdtdEQISPWZB5g7WPrYXfcIqgsjgKMHyjSE8H2pizz7FKaoUfrDtaZ9Kb0iIM088I3sgl8U4o83auRnV42Yws05sMVGCc3dqhyfZ/0cmpRVEbxlj/BIttMM6y52YDapt60u6nMuYa4We+fnrI7111+o2PUS3gMWtUoAcp4ORE4n9sxhxpxWTAxAsVBQCZSA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/11/26 20:23, Lorenzo Stoakes (ARM) wrote:
> On Tue, Aug 11, 2026 at 07:11:59PM +0200, David Hildenbrand (Arm) wrote:
>> On 8/11/26 18:18, Hyunwoo Kim wrote:
>>> The added pagewalk_race_test maps two PMDs and faults in 2MB of the first
>>> one.  A second thread then faults in the second PMD and drops it again with
>>> MADV_DONTNEED in a loop, while the main thread reads Rss for the mapping
>>> from /proc/self/smaps.
>>>
>>> Clearing the second PMD while smaps_pte_range() runs leaves walk->action
>>> erroneously set to ACTION_AGAIN, which causes the PUD walk to be retried,
>>> so the first PMD is counted twice and Rss comes out twice as large as what
>>> was faulted in.
>>>
>>> mincore() is the caller named in the fix, but the second walk writes past
>>> the length mincore() copies back, so it cannot be seen from userspace
>>> there.  smaps reports what the callbacks counted, so the duplicate shows up
>>> in Rss.
>>>
>>> A failure can only come from the kernel counting the same page twice, so
>>> missing the race is harmless.  On an unfixed kernel the test fails after a
>>> few hundred reads at most and takes about half a second.
>>>
>>> Assisted-by: Claude:claude-opus-5
>>> Signed-off-by: Hyunwoo Kim <imv4bel@gmail.com>
>>> ---
>>
>> I'm sorry, but I don't consider such a specialized reproducer for a problem we
>> hit once a good fit for a selftest.
>>
>> Or am I missing something, that this here is more generic?
> 
> To be fair I did ask him for this. :)
> 
> I thought it would be useful to have a regression test because there's certainly
> no harm in it? The code is very sensitive and catching a similar mistake in
> future could be useful.
> 
> If you're sure this isn't valuable then he could just drop it, but it's my fault
> sorry Hyunwoo for giving you extra work in this case! My bad.

pagewalk_race_test is just rather odd. If this would be part of a bigger test
that covers more things than just one odd race, it might be better.

But we certainly don't want one new test file for each kernel bug we ever
trigger, right? :)

-- 
Cheers,

David

