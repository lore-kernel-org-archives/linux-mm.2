Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A57AD606A328
	for <linux-mm@archiver.kernel.org>; Wed, 21 Oct 2026 09:50:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=HhledqBj
Received: by kanga.kvack.org (Postfix)
	id C10366B0205; Wed, 21 Oct 2026 05:50:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BE7D46B0206; Wed, 21 Oct 2026 05:50:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AFE766B0208; Wed, 21 Oct 2026 05:50:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8DBFD6B0205
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 05:50:04 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 1114B1604D6
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 09:50:04 +0000 (UTC)
X-FDA: 85346162328.23.5FD4A2B
Received: from mta0.migadu.com (out-216.mta0.migadu.com [91.218.175.216])
	by imf21.hostedemail.com (Postfix) with ESMTP id 9D31F1C0004
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 09:50:01 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=HhledqBj;
	spf=pass (imf21.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.216 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792576202;
	b=cx22yBXjmFpSzLyqkKu+webJb+NuEkHJtR5isMLfMZt3XCOFqlEQXT1dDB/Nslf19vXzxS
	SLd2NNeWqQPi2tw5zilx3EBM6CySwHV1A1As5FqLmZC9TpCh7/jQSsGcvAN1c/Y9wDKJQI
	mUMqRobnaNCEpDgifAnkN3MhAKeJo2c=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=HhledqBj;
	spf=pass (imf21.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.216 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792576202;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=G53IIIXhDfjfjxT9ZDHI2vAikXwb38otkA5QxpRYrN8=;
	b=nP0fNtM052gEQUGdJxt36Wfc893H9Vu6sOf+4JT70DBBF5JYm9Xdfe/FnJg1pSf+kPgzP1
	Y7/r0eDka9kE83c2DZwXk5BZgjarLaLeaET/wOqGpPydlFHsR7NAt4mWgSQVpWD5jqdlsa
	X9NuhVviTZDDwIiKzEgM0UFIiPKM5bk=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=VR9I6eMpxuCj5V9ollyYvyPkLG3wtvmTCmYpBpxiZ2o=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792576200; v=1; x=1793181000;
 b=HhledqBjzKKur4GB7XnhRqxlnismylTJ8jxijNG+tr+PiZQp4dR7vte5aP1DJJr0sA58plYC
 fEiUbQHlfeMJ0k7QO6LY0whr+P/ngEVJ4X014VCRQp9ybqIf7vLTK9enKYJDeFO9Luht01YROek
 8wZvAIMyHaV9l4hZbijp1OZw=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 83e3e21a2d7caf67;
	Wed, 21 Oct 2026 09:50:00 +0000
X-Mizu-Trace-ID: 83e3e21a2d7caf67
X-Migadu-Flow: FLOW_OUT
Message-ID: <2329ee64-f9be-4826-a496-65344e9a9c18@linux.dev>
Date: Wed, 21 Oct 2026 17:49:51 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm/ksm: keep soft-dirty and uffd-wp when merging a
 page
To: Kiryl Shutsemau <kas@kernel.org>,
 "David Hildenbrand (Arm)" <david@kernel.org>
Cc: samarth.colleges@gmail.com, akpm@linux-foundation.org, xu.xin@linux.dev,
 chengming.zhou@linux.dev, peterx@redhat.com, rppt@kernel.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <efa6a28c-f0f9-4d1e-9cce-fec2c08e7d9f@kernel.org>
 <20261020055518.36087-1-lance.yang@linux.dev>
 <3da45e6d-2b46-4fff-9ff3-241f70d68296@kernel.org>
 <f6bdf823-be42-4184-87d2-fc7c128f4786@linux.dev>
 <68f17ee7-d272-4475-8a59-645442e2c210@kernel.org>
 <ath8JTlITYcXsyLg@thinkstation>
Content-Language: en-US
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <ath8JTlITYcXsyLg@thinkstation>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 9D31F1C0004
X-Stat-Signature: 66iu4rawpqd96s8uz5e4ket1osg8wn9k
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1792576201-117157
X-HE-Meta: U2FsdGVkX1/X80MlOu8BnddX+xaGhpW2LcXlXkUZDtb3LWwtsqxEeWqdl0WDifJC3/5nx73T6otD7pKG8P++g45Y42WbUfvIOGy1WoXgbyQZjzIVvfkq1sjuxCDmdCUgBz3V4BXYFWR5TDRKMzSTrkYP8G0qALzE4Zom6Bnk/bP8JUAvYXRuKIeUqJGLN0+rXld1A0q6z5b7BC1m0MMOopzoUKKP+6/RsboMLCUQQGI61Im3yxqxYa5iAT3fGr02fHT2RhpmInM8Lf/MJKO7HZMAPug1QXr4hPTp4ubxsAqE8NMlWznGmLaQPSNQQzhiRnJF96bhq3xbYVDmFPcYNzMUOad7ZX7p87LLrLi73bzhIYTok5mT9epndlAlaY7wsU8jb1GhkAaEy9j9tgSMpzu/d72bBEE2LDVE3746FI945MMD43v/fYo/ZtKeDuykcltDvr/HsXtXK0OLYI5j/vU70igPweaTIlEi7EQOV3c810r08cE3QLGGVZzRGxiiSW1kkpKgxU75kKTq/PMXKycDqwUr3LpNXXUt6lf+Eni2vIA/M57/wvSL3jzdkoLoqIzy5Btu06RTUTl8ZO0dKCJrqcRr6K5M0eRRwYcbwi9E46EWv8cYXVXkYP7/7G2hywvOHG6hB4cm0i3bDrrFLTwfgnWPqtHafmWYeDHfjuMZEldgyYT71Eq+ur+F0i84OOYKujyuweOuLxolqF8/kZ+sEJTlvHUQOlUWswrKWCwqCnhMxsQFdWCIhN9Ffzw71+WQXX3EMcuUu6ySbr2zRdZ7O1s84ES8M6yEKRQxG34Yn4tz2lpqOsw/j5wWicRbD9uO5JWJKX6glLTOUK/lM401YMpJsng32i6qCldS5duklRbXU61VRxzOiFfnBemp9QHZAosl26P65m8g6NpnL/ejoudTnymYlHxHuz4XObsRv/n4yGTwhCrzRRm4YB30Q/97njfIMMOaxBXo+LU
 x9iHBwUt
 SNwwpc5ZPaXP+Rd+8yZVO5dmRysd7+YrZqySF2mP8M/W27lYO1oEJWh4aZiWCWM5fElQZHgTolMnroh0m6dV6ueiEPRVwlX2KtfVMipROP5/ePDXThJDtS5Q25dWrK9T4knmLOQy4H35iJPIaH6E4JKOBK0SKF3U5QIceDNxolz2ihySgY3odUPEK8Nq2b4zWgR5NCyzOIx2Wr5xUY0gt3RqzB3NyBGUI/j56N18u20M9Dnkp/5vH5jI6naCpbLlRdhjOJQcqe0IlTZUYSEAElzWCLKdKzq6ghnkYGNA5LRim67MJ57v0zyW2i6A3+D+Kv3kcK2ICsfumGoxuJO+dlp5ywVh5fERzQX7o2Mt4Pa46zyv0F9uh6OXYKX2wACgo3mHj
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 2026/10/21 16:55, Kiryl Shutsemau wrote:
> On Wed, Oct 21, 2026 at 10:21:53AM +0200, David Hildenbrand (Arm) wrote:
>>> +1. Did it ever actually work there :) Why not just skip them and
>>> call it a day :D
>>
>> I think QEMU just always sets MADV_MERGABLE and later activates uffd. So that
>> needs some care to not disable them. So let's rather try to get it fixed properly.
>>
>> Can you send out proper patches? Thanks!

Thanks David! Will take it over next week and get proper patches out :)

> 
> +1.
> 
> Lance's direction is right. Unsharing is not an access: do_wp_page()
> already skips the uffd-wp fault on FAULT_FLAG_UNSHARE, and RWP should do
> the same.

Thanks Kiryl! Will take a close look at that :)

Cheers, Lance


