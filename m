Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A2C53F99344
	for <linux-mm@archiver.kernel.org>; Thu, 23 Apr 2026 09:50:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 00CFF6B008A; Thu, 23 Apr 2026 05:50:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EFFE76B008C; Thu, 23 Apr 2026 05:50:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DEEEA6B0092; Thu, 23 Apr 2026 05:50:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id CE73D6B008A
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 05:50:03 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 79C44160545
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 09:50:03 +0000 (UTC)
X-FDA: 84689349486.12.6AEBDFC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id A4EB24000A
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 09:50:01 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Q7q2Q3nG;
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776937801;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uNA/k6GIPS1cGTg0TvlH+GblfJNIHZ0SEG7WbSVR/vM=;
	b=ugint9gHOMeZpbQPQN3XxbWKzBumLoV21fSfCmA9xNf7PTIT8ELf5SVJIJ5vnjpByT8/7e
	KmSC1P+YdMwGPKiIQDhItJ7GAlC6Lb/ZAJSX3tABJAWtLmtQpbbYVVk+2q/YezI3ElDkdm
	YvtY3PtQd2jTpr62hiC/YDgvWKVSNzI=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Q7q2Q3nG;
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776937801; a=rsa-sha256;
	cv=none;
	b=GwDtQsLH1oKeuyqFghkLXJkF1SlQNVSg+/9O00bmFRD9ALF9WJlPQlOF5OD9GFNDMcZHQz
	t2fupHSFUEpUuS39+GPh/3SJfPyKvPSr/3x2U/A6BgZ7WHw2oZ9vkQvZz9jlbtDCxKCbqx
	fI/Gl6gKpFgijbWKuDDJLwofx45YJ8Y=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 799A4443C6;
	Thu, 23 Apr 2026 09:50:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E24DC2BCB7;
	Thu, 23 Apr 2026 09:49:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776937800;
	bh=0AvMl/HgDuU6+++EEE60wT7QZAwnlvC+1Uak1iqD4xc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Q7q2Q3nGsNvTyv8Vv/aO7WMV5WBRP9gzVxbwrZcs4ayzSXskMzNEZozwOzGNGAcLz
	 gup7R4EMuWdNDDsYUoEaQDeuZu39P+WZvgLnmv6HQfzymHbaANub4skC6zHY+h6JUP
	 EwgneY5LsCpv+u8w4+nonOVGY0wpg8f1BxIXUD0wu3jS5fGUuIRyddFKjTtox2we1H
	 2PM5zhfZPcAWbGB665+xe5hrX+x1IFMAEM5mZ4mK7ozYUp8foUbLZknMMwEjKOVdSi
	 Bbw6oJzy0siRuFqHaI4ecvcx6En50gaBeb1QQ6swir2EWTD5bq8a5qXOdFQb4eWbBz
	 AGiGv1wjg+9Yg==
Message-ID: <28c3ae9f-c974-454c-b8ed-ba0ba0a5706d@kernel.org>
Date: Thu, 23 Apr 2026 11:49:55 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC 0/3] mm: process_mrelease: expedited reclaim and auto-kill
 support
To: Michal Hocko <mhocko@suse.com>, Minchan Kim <minchan@kernel.org>
Cc: akpm@linux-foundation.org, brauner@kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, surenb@google.com, timmurray@google.com,
 Johannes Weiner <hannes@cmpxchg.org>
References: <20260413223948.556351-1-minchan@kernel.org>
 <ad3ldU4DZxga_J2L@tiehlicka> <ad6c0DN7AGoOQ_Iq@google.com>
 <ad9AXVYxWCkHmh6J@tiehlicka> <aeAeqoJ_acUAza8D@google.com>
 <aeCHvYOKP1exBBns@tiehlicka> <aeHRLv834FCAQlQ8@google.com>
 <aeHdGf7XDjvOES1V@tiehlicka> <aeagUxlju40rvkYQ@google.com>
 <aenPV9ewKAzRF2Vg@tiehlicka>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <aenPV9ewKAzRF2Vg@tiehlicka>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 8qjmmubdwwirwi64tfn3a99im33pup4x
X-Rspamd-Queue-Id: A4EB24000A
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1776937801-925834
X-HE-Meta: U2FsdGVkX193EB/fcpROwGmjC0i1sRTsksmaEmDHq5jPtncW8DRMym1VKJnYM+VfURc/lbqXUUr2PXW9aF9CbPXsFjR3BsjA2Cnv0vpyAlkuQkfPJOECEWQ7Y7uzOxndAHjg4gj1mSHhVtFt9UmaBd0YIIha3g5McYO9rD+T4ky77CwZo1oiuYyw9d15GFZNVef8kkdMO9Y/tU0xxnqbjHau8x9BYvrsihOY7/vyZql6QRsCGJ37BESjwGSWMySuMic0dKKl4LnylP8zFsFZ6xiZA5UmFuT47Lkai2z8/vBAZLHo/vnHfiWt9lbDXwphBFJeIGd6K/ToNtjVikjteTYLhHlL2HghsgC6Rvok9UtpUvEc62F0aP7Ny09qxrtLAlebR6jxNZFyUTV8ZmlfHMzZIEQzXVDxJGf5aKSkPgHCANgf/026J4rIPuJQobQaLjxUTguy5XFZqr2/OwFyjg8jHlW1ct0A/OtRKeD8vr2s4LNbgQB8BqmIIKnUXAPdFpbWcfCAirWy6OMv46fazduEui1Os1HzLP7jYL32t2bIBnOUdOrjvlQ3TcdXQxhlP5jn8QqDvhhJT7JZ2aoazpETwcI7/eTioKAXzhKW8u8KT/jlHLdbXXfLzusFgrpTHRYfMCf7M7LHslNycMdDOEb1B1I8By+X5PmBSQIEwVHG3VgLEZf7qTz3uhtStZqV53I5tPz/l3fu9BjT+81wxNv+KNjnAdU3JOdIqHA5TRNV9yO2Vwzr8ydgSHXMYJISD8wi0zCClDfPK5Gl7Zs5zUYXd4D3M6Bq5GVOcKx1B2DDRGjO5+afVokvmBqA6nOiqnlUMGMp2BopH7GLrEGciKjIFsp3/32f/cD2U2KXjgrB8CXsYpa7ihg0WqTUObXG2YhZlQVYHhvco5ookoJSzOQgtQL6WUgoYIOT/GpN8vrVaSXrdJRJXuhz0P+MBJDnDdRMRzwDpORIENn/mdG
 1RZ/XXlN
 jV2wYD7t/Vw04vN9YRy6ymeADj35QAfDHk0G70s720TkfvkmxzK7YnEoAM2/7nKFuzxBruufJFEiNlRY4Dy0ba6I+WoB6ln7wZa86Wlr8Lt5cPlPeMuXNTq26EPypMisACEHPCxpKag/IivcOFtQOrQWsMDFp1Su8BQGwlS55Ww2y1xj3g+YQ8vWSS3PxvfoA+txZcUTxApQEobtEL2XlQFhg2cn3TrvMAq0NjbNP65b/fZJHSBX6Uaim2/fHNg4mxPzcsoWdPVxCVKzA+w5ccmvenvr8cQvXn1k8ybm0V/cKXN9C2ayq2tlFNA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/23/26 09:50, Michal Hocko wrote:
> On Mon 20-04-26 14:53:23, Minchan Kim wrote:
>> On Fri, Apr 17, 2026 at 09:11:21AM +0200, Michal Hocko wrote:
> [...]
>>> Yes. All which make sense, really. I am still not convinced about the
>>> clean page cache because that just seems like a hack to workaround wrong
>>> userspace oom heuristics.
>>
>> I see it a bit differently. When paltform decides to kill a process
>> to free up memory, they want that memory back right away.
>>
>> So it doesn't make much sense for the kernel to ignore that and leave the clean
>> file pages to be picked up slowly by kswapd later.
>>
>> In some aspects, you can think of LMKD as a more specialized, userspace version
>> of kswapd. It has high-level knowledge of process priorities and knows exactly
>> which process is safe to kill to get memory instantly. The kernel's kswapd,
>> however, operates globally without this specific process-level awareness, which
>> makes it less suited for this kind of targeted reclamation.
>>
>> If we force LMKD to rely on the slower global kswapd to actually free the clean
>> pages, it defeats the whole purpose of targeting a specific process.
>>
>> So letting process_mrelease speed this up isn't a hack at all. It's just helping
>> the kernel do what the admin wanted in the first place: fast, targeted memory.
> 
> This is a very creative/disruptive way to do a memory reclaim. From a
> user POV I would much rather see clean page cache reclaimed before my
> apps start to disappear. But this is obviously your call and your users
> that will care.
> 
> Anyway, I still maintain my position. I do not think it is a good
> idea to drop clean page cache as you do not know whether there are other
> users.

IIRC, Johannes raised in the past the we cannot predict the future.

For example, if an app gets OOM-killed, wouldn't we usually try restarting it,
re-consuming the clean pagecache pages we would be evicting here?

Just a thought.

-- 
Cheers,

David

