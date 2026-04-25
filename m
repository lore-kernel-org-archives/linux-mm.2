Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6C10FFF885C
	for <linux-mm@archiver.kernel.org>; Sat, 25 Apr 2026 05:31:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4460C6B0005; Sat, 25 Apr 2026 01:31:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3CFB06B008A; Sat, 25 Apr 2026 01:31:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2708A6B008C; Sat, 25 Apr 2026 01:31:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 10DD96B0005
	for <linux-mm@kvack.org>; Sat, 25 Apr 2026 01:31:09 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 8DCD71B6FD5
	for <linux-mm@kvack.org>; Sat, 25 Apr 2026 05:31:08 +0000 (UTC)
X-FDA: 84695954616.15.305B80E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 9F0AA18000D
	for <linux-mm@kvack.org>; Sat, 25 Apr 2026 05:31:06 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=jYysDsHk;
	spf=pass (imf16.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777095066;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=izoWNZpptbtssuD2FUMoZUclN6qI6Z56asGfirveslY=;
	b=6/Kt0Q8hHC1WAtZlnpNLN9drygUosTV1IwVaT+19u6Aw46dhvDs+e079TNTXUcU2aw8MQI
	9WBOoY6gEGURaMPE5LnmTrb4eJqLCHQ5+W6P6ntJ2xgV7g+FhgGVasvIjPXqVXmCBRzeGq
	UOJOBu/avIsTkLb4GSoCD+oDRwGvIkQ=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=jYysDsHk;
	spf=pass (imf16.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777095066; a=rsa-sha256;
	cv=none;
	b=NLcnNzQkfc6p//Rqbnu+WKUgobrgnq8ur2jbME2xyfzM5xyVXERKtEphQB1UdBTZzskdZZ
	ToGY5q0PsjkB3xLcv1HCa/bMSnbpmJ8ZoHIlMJZ5tLTHOvyU4P3mdFRoVF9EGnlx7vHYte
	P9eQV4wYKtJRhvBcr5u6A9DafDvnI/Y=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 4E588442DC;
	Sat, 25 Apr 2026 05:31:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F001C2BCB2;
	Sat, 25 Apr 2026 05:30:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777095065;
	bh=+42vCSXJu+YT6e/EV0HGcmeCkiK/R9NkN3Va4VSdmwY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=jYysDsHkvzw4w3++oWoxcKUL5tUhrDt3tudCV04MV1nF6s9NwRS4bhdI529+APIVp
	 ejYWAhExQ58uN+VhVKMTGIyFuUp8YKZYbyBJ649BnZt401mdS16uq9UohqyGyvLPpo
	 EVe9C/S246G1qZ9H1DiWlXVk64R5SqUWekLWPAeVIign7HTq9u+iQ5ko68UpXhr0Uo
	 lbV4kFk/bGyYYa2rJpbcN1koXSnY/Ei8FcxGEh9asrApLEawwiYlYYWIkDqJkOWmm5
	 82sP/HTZ71rZSx7i8vDUdxsLDNpZKssDXnn20eRmqB/85UuLgUMzcbAAqCVWAChA91
	 7NCRl6Yncqz1g==
Message-ID: <3146ebcf-5649-44a7-aa21-163bf404c42b@kernel.org>
Date: Sat, 25 Apr 2026 07:30:56 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC 4/7] mm: add page consistency checker implementation
To: Sasha Levin <sashal@kernel.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>, akpm@linux-foundation.org,
 corbet@lwn.net, ljs@kernel.org, Liam.Howlett@oracle.com, vbabka@kernel.org,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com,
 skhan@linuxfoundation.org, jackmanb@google.com, hannes@cmpxchg.org,
 ziy@nvidia.com, linux-mm@kvack.org, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, Sasha Levin <sashal@nvidia.com>,
 Sanif Veeras <sveeras@nvidia.com>,
 "Claude:claude-opus-4-7" <noreply@anthropic.com>
References: <20260424140056.2094777-1-sashal@kernel.org>
 <20260424140056.2094777-5-sashal@kernel.org>
 <4b961a07-b72d-4c8a-ab49-23f61ed12b53@kernel.org> <aeuC6TJ4XowazVZj@laps>
 <aeuFnuiYDBjttEKt@plex> <12985b32-88b3-47ab-8292-2e0ec6f5fbae@kernel.org>
 <aev-DS4YTp5soVPd@laps>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <aev-DS4YTp5soVPd@laps>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 9F0AA18000D
X-Rspamd-Server: rspam06
X-Stat-Signature: 68111mxhi533kstw9cw8hw4jdaq3889t
X-HE-Tag: 1777095066-414980
X-HE-Meta: U2FsdGVkX18nGmzUa3i3Mk9CQ6uhB4Trqt+dzSIS4DWsvuvOiTuVBpnCDsPV75tabW2KdrBdBRqhF9DgeR+2koMhOyTdhrxthCne3MWBYeXY2w/PKd8GcHyi+lpPCNY3s6ttuo8JTKACBShdGR7c4cbJ5YeO5HsUF//aBzEh2GhX0jP7Xvgi97YbLWNqyr4rPEhCQwmr7uMuZvyJuGUt8YUUybvSYGqUQIZSh5ttaC9XdGnWgCmLdWmC4/a3WvCL8pq/7rCmP/Vi4Nbs+tovK51kV3PnsC7c5mZf2BT8Ch2z5vpFB3aROjLeKWuIOXwZmNrPEG81yiB++uyOozmTSwWK7T0CV6A0OVuH2VDWQzF1hnEyEfkNIpBakkhxR26zqENue1AvK+DeH0euuoqfSImwo5+zSeJw8/lfnjg0SEs26QLElAbwOUqwn0QGiFnurXL7LSx+IxDfxccbqMIF2q8NcKCMyHC3yy9sTHM9izIH9ulJ5jrcVAIrZouKeiEDX0HIxgHmF7Bq1kkoURUPKN0YQwkTBfKxMbyIv5ofc4rZ0rX6BkauHz5JchiUzaXNeGHyw3idLY6ESKrMH49pb56O/POgz9hVQwVi2VZBpZmN6/BxbV13C4RUocQpXx4XhSbZLbhe4EpaS0k1nMGRAtCxtnGuuST0558BLQ8ZPeOtPZ5L2IM7YOc2GdxaD1M6hn5oYG+/r0x2/9gmqrAmhC9Sa3uIV00Obp9+8L3PYCeuujJluUjtYla3ICMmc0clRM9iywXdp5u92iXHrrRj7u069r+rNyyE93ycXHPEDbJK6xCerHtrypI0IVSWCggbXf37viQuRkyiLUib88TDNvRfmiNESBbLN2Lmz87jl1Sz0Dlh4CuA4fP0zpurAY9Tx3z7JXBv9E/liY8nXZnzrDhvc9SOS1LF4FPfB7Nz5m0ZbqcNgE3QKWwgYzkBOOkEUoT5DCCols/yc2IoW+j
 Dt4Z+W2l
 z/FSbnHhYzVLrY8W4wg4l/yXYHfjEzDlAB79Sc+PvkFTRj35qcADNO8Ctd0dnLrINd2mC4DJNmBmQl7OTKKGd80JJiVkPI+HYBtPpoIM7TteUK6/g5p02PjH6smx9ONrUEljqxWyat3pVzkZcH92uBBYrrD4VOjBvEo+t7fhJyRyzsgI9qBi0z4UPxsqf+HRngoaaT8mFlbb6e/crV7xIdB50ZYqCKj8QZgj+JJMK0oTFMCUdRxzCELeVvhD8yJ+64UKS
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/25/26 01:34, Sasha Levin wrote:
> On Fri, Apr 24, 2026 at 08:28:14PM +0200, David Hildenbrand (Arm) wrote:
>> On 4/24/26 17:06, Pasha Tatashin wrote:
>>>
>>> The issue is that we are going back in time to a flat memory,
>>> without NUMA or hotplug support. We need an abstraction that avoids
>>> allocating this memory in enormous contiguous chunks, as thit approach
>>> will not work on modern hardware.
>>>
>>>
>>> Page-ext provides all of these capabilities, but as you described in the
>>> cover letter, it does not meet your requirements. Therefore, I believe
>>> a new abstraction layer is needed.
>>
>> If we decided that we want this (and I am not convinced), we definitely want
>> something that supports sparsity and, in particular, something that support
>> memory hotplug.
> 
> Makes sense. Let me take a few days and see if I can find some middle ground
> here.
> 

"The natural question is why not use page_ext. The key objection from a
safety perspective is that page_ext stores per-page metadata in memory
that is itself subject to the same hardware faults we're trying to
detect. The dual-bitmap approach works because the two bitmaps are
independent allocations - corruption in one is caught by comparison
with the other."

So you want to have two bits per page, whereby both bits come from in dependent
pages I assume?

Storing one bit in page_ext and one bit in page flags would be possible if we
had a spare bit in page flags ...  We could allocate two bitmaps per memory section.

But the real question is: how far away do these bits have to be in memory to be
considered "independent" and not prone to the same corruption?

1 bit?
1 byte?
64 byte?
4096 byte?
???

"Embedding both in page_ext means a single fault could
corrupt both the tracking data and its redundant copy in the same
allocation region."

I might be wrong, but isn't that the case for any such fault, as you don't 100%
know how the DIMM is organized internally?

Do we really expect that a MCE event would, for example, very likely corrupt two
neighboring bits, or two bits in the same byte etc? What are the odds that we care?

It's hard to tell here which part of this work is "too research focused". For
example, if I were to write a paper about that, I would make such claims to make
it sound more complicated than it needs to be :)

-- 
Cheers,

David

