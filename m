Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 781D4C88E4D
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 16:44:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4CB1B6B008A; Fri, 11 Sep 2026 12:44:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 455CA6B008C; Fri, 11 Sep 2026 12:44:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2F6CE6B0095; Fri, 11 Sep 2026 12:44:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0E34A6B008A
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 12:44:16 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 9A356802E3
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 16:44:15 +0000 (UTC)
X-FDA: 85202054070.03.42E502E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id DFD4F1C0003
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 16:44:13 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JNlZ0Vfr;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789145053;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=64/u24ltheFG+IRwvDX3qmiVM9rNvR3qqwc5FQ5UhyE=;
	b=6zcU/v6HyccKr1HcVZhDTbe+pIqvi2Kzdx8HCWSB6f09XLQFoxUbCq5o5AUge1h69+Wq9u
	1RWPhuL1AGW4htAEIjdGKlvPmbioQSIo+QPrGQtR4XRnChqyG14bRpaaek4Ri9WFIZpevC
	i345tB0fs0TSm/9Ueciq64bGGl1Wd0M=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JNlZ0Vfr;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789145053;
	b=LJxZOCG7kidDHnB84sC1JELMlbRRMY30ifBQhr58smDgclvj0IiTjwbidmy/FxeiCW34Px
	o+0hygb8eocM0epm0ASO1tL0awiTCKOI1bcJis1TSTAMiLxqFW5D8jqEKiATCcqceN3nvA
	Ryt8RG9HKTlRTyiL60GW9MRY2qAlwts=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C3CE660142;
	Fri, 11 Sep 2026 16:44:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9ACDE1F000FF;
	Fri, 11 Sep 2026 16:44:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789145052;
	bh=64/u24ltheFG+IRwvDX3qmiVM9rNvR3qqwc5FQ5UhyE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=JNlZ0VfryvP9EzKmXHTr9w/lIf2axf3au0kadcGsERGODueey6Tw/YYQ7c4bG5XsO
	 V2fZ50m7qORqDc5hsVlmwsbqMJOHGILSx+sty1t6GluygCYQzS6LqtByMeNe/AuX3S
	 uJH/gJXDtT/BWS5LWoQOQQsn4WjyWZ7sCqbL8Y1fNlYzfYl/t20Lh0mooj4F/ua59Z
	 R+wClSZRMp1xfQNZvdk9FLadg65f5VV6DMzkmx42VpRAyuTdkQZRqntDswfi8F9QxC
	 Y/j+PuTJ3KMm+bhmrV7LDhA1KznGr8n7Uuft0S+5jxWqdiVFkulT0d3baNTZG9oA6I
	 V5q80ufL8r/cA==
Message-ID: <6882373c-f76f-41ee-be62-cd910d07efce@kernel.org>
Date: Fri, 11 Sep 2026 18:44:04 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v4 0/12] mm: use per-VMA lock in __access_remote_vm
 for improved monitoring reliability
To: Rik van Riel <riel@surriel.com>, Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, kernel-team@meta.com,
 Dave Hansen <dave.hansen@linux.intel.com>,
 Peter Zijlstra <peterz@infradead.org>, Suren Baghdasaryan
 <surenb@google.com>, Lorenzo Stoakes <ljs@kernel.org>,
 Vlastimil Babka <vbabka@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>,
 Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>,
 Peter Xu <peterx@redhat.com>, Matthew Wilcox <willy@infradead.org>,
 Usama Arif <usamaarif642@gmail.com>
References: <20260724222934.1463812-1-riel@surriel.com>
 <9e902c8e-c825-45ee-89a1-85923453e43d@kernel.org>
 <7c7b028ae93f0551e07e9e09468954e76ad072ee.camel@surriel.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <7c7b028ae93f0551e07e9e09468954e76ad072ee.camel@surriel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: esxgnrs7kxpggwjmjyct7b96b51zas58
X-Rspamd-Queue-Id: DFD4F1C0003
X-Rspamd-Server: rspam07
X-HE-Tag: 1789145053-84167
X-HE-Meta: U2FsdGVkX19jTI2kkvWggnGv9eZmJzB5el7RMct0hEO9Mm3lgFVe5HhWukvIV6+k0aschsMuWJokvEQzIZf8fIXeDT4VZHqHf6/1/8eMki/YczccXTpQbLFXTR0S5ckE7zccjLwUMbToiMPxmlRpPQwKzuvL0MaxvEhopcxycYU0512qTwOb+5/sy/ftidTWbrLd/mJA8SUPQkXflDx2qvyiiEf/nQ9/m5G/3nN46A2mfSzSgsEphgPlaNG/6KG8jEw5pspzOAfUI7L865deZpDeH7W+TZqUqt3RE9VBw5Qhw0UOzCDjqC4xBHynJTL63GHg2aw5BMPxwZqd6okxOjnJ5I0BMrAk593MQ20pFdw6cF7MhQ4yfeE3bYaLyzIk/fVZFRooak7S6tK13/O2WI/i9bkU7GqdeqR1/oiwl5Kksv/+sn36tewuicQIPkRu7nuy82S/ysn5dGdhNzc5UFdK1f4f093B3N06I1UPMC94zEvbcdiNdwVAmqMoSX1KWzjNPnG289K5QyMDH6ZRUt0TBKZHAKg/DOCGsrKTMjZneNzQ6ut9AnEi8bnvHKCJCxOlQwpIfYuHcjl0QuVChZZo8d6mV0Pu3r60lkRk/xoP5md0Kra/G5k/01LHwA5HjyC2/TGh2GZURspVQ54iebYCywf3ZttKjEtw8m1f//mTscMVNK2ROwO39xG89sQo8tUYVu7B4cLTCGVP7MP6Xp/Pn5n9VuuvRGfcxw1npcn95HOhveeuVFKZLQmVmF8f00qhChteyOyWQ/QkD0Y4dsTX8h4PaZKD/KbXE2FG6E0KqYtv8wMyb7rIhlsdvjJegQAnWfdNlNTyjUDxFmIvVT7vqnoiIBoLp5uVs7XDsOMmiC/NkqXtE/aKvMw7jWpRpoGy7yUH1dWCZXJ+lGZ/iDD7MrF2w6QpJIyhmlAdDKRpPFfxysZEX8qw4kuR8HwZNzkKHay0bgTztdby3Ka
 hRHwtScz
 Xs69QcGmyoILFq7icFqFNgCydpvtQYs0qzJsiEO1stSFUnRyEdt1zXnn4fJDXThZGjRK0IIBfCmgeHK7i+SUcTBNhLhYYGa4Tv5jwfO5MOb7V6s6Cp79GTdDK126Nsg/iiUaBNU6yb8QfojeXRe6I42EeELNHJ132cjwVO2xpoh3he1zCcObS/zf359ZEBw4ctmti1IZCsQkkveL28S2DAPaGPe6sC5poB9AFp/lwPz7H8mSi2XADX0Cw8IU898Yod4doUEo/ca4IZa5p/0Gktf7wpzDzsPlA8pBBsc0JtfZDE6WHECDehOOEzHFkoKo8vLpu+Jx2p2ed7Ew=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/11/26 18:03, Rik van Riel wrote:
> On Fri, 2026-09-11 at 17:11 +0200, David Hildenbrand (Arm) wrote:
>> On 7/25/26 00:29, Rik van Riel wrote:
>>> __access_remote_vm() holds mmap_read_lock() for the whole transfer.
>>> On
>>> large machines, with large multi-threaded applications, the
>>> mmap_lock
>>> is often contended, leading to things like reads of
>>> /proc/PID/cmdline
>>> stalling.
>>>
>>> This results in system monitoring tools getting stuck, right when
>>> system information would be the most helpful.
>>
>> Rik, what's the status of this, and which series do you consider more
>> relevant:
>> the pure per-VMA lock change or the pure page-table walking + folio
>> batching?
>>
>> I'd assume the page-table walking would result in more speedup and
>> the per-VMA
>> in mostly less contention. So likely we'd want the page-table walking
>> optimization first.
> 
> We can merge them in either order. 
> 
> This series gives a speedup as well, by removing 
> the double VMA lookup.
> 
> If you want to merge the page table walking and
> folio batching change first, I can easily rebase
> this per-VMA lock series on top of that.
> 
> Do you have additional feedback on changes you
> want me to make to get the page table walking
> and folio batching thing in a merge-ready shape?

I'll go through one patch set next week, I'm trying to figure out which one to
prioritize :)

-- 
Cheers,

David

