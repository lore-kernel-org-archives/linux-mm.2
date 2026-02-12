Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5448BEB48E8
	for <linux-mm@archiver.kernel.org>; Thu, 12 Feb 2026 08:54:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 997A16B0005; Thu, 12 Feb 2026 03:54:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 93AD96B0089; Thu, 12 Feb 2026 03:54:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 83D4B6B008A; Thu, 12 Feb 2026 03:54:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 740D36B0005
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 03:54:15 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 2A2518C442
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 08:54:15 +0000 (UTC)
X-FDA: 84435192870.20.2A77B7F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id 80A5EC000E
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 08:54:13 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=O4PqR7Ld;
	spf=pass (imf22.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770886453;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gmnOuVHCtRhsyxJ5fQaioXy62BkjYFd1JTXdPGXqI3A=;
	b=KsW+eE0Kr6QMzJEdHXHxR19oMNTFdPdbTx39UsANTdyTYWpMD15sFn/BknIvlR8tzbF8kp
	alFHNNC8nNtiSXWuB2UpNM69r85013zTyDR9rU5/xNEpd4z25fV8Y694Qq6t0rz4nHKJIn
	MhQKYCb0dVwnF3hRkWZ3tNoIxugZFy8=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=O4PqR7Ld;
	spf=pass (imf22.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770886453; a=rsa-sha256;
	cv=none;
	b=QarYMelx1SiU8GfEUBa7PfEw7idwlUcdZD4qRuGR+ltxxHTEZwy62bUtfOnriqcqj5yKmx
	quIGeTgS7afZAoJCMCZbXnXMNa/iLF7KXMAFEAlxFDfNasW1pAXW6tm+ZKyz/nwXZMEZ9j
	uCFxYwSw1dew2fIVkwwL5Li2sWws3VY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 7DF8860135;
	Thu, 12 Feb 2026 08:54:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCE60C4CEF7;
	Thu, 12 Feb 2026 08:54:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770886452;
	bh=k3MEodMonFKXjo9Ttxo2bEV50SdtUgQar2VKT32zHqw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=O4PqR7LdKInuOIyuh/x8pyWHgAKOhVqykx8Tf4TL51yRXXpbvxVQFwrhxP1KLJQgv
	 JD6wWS8ouBUVc9ULNmWrKn3yLW4xqye8H5uF+F3/KCPdnwl8K9pvYXTPPpApcOHh2a
	 3y5LXC0q9gdg6Q1P/hF/OXb0pjkzKymFLx7CVRe/zFZByfpzfMYVOMbIqSJ2sX0MAr
	 ZEgr2u8AE+lfYJ72cil1eI+8pnGcJepRjqURN18exLxopHyvv8qVLCb9mjQ2tfs7S5
	 pJXuKvJfptTIYxJnQ6BX2Zhcwqpm3QnvgR6OcDWh4+LmMp1b/2ufEJdmiUJTH1ox2U
	 aGfdkI9IByHFg==
Message-ID: <c48511be-047c-4ab1-bd49-f2c4899e3cf5@kernel.org>
Date: Thu, 12 Feb 2026 09:54:04 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH] mm: only set fault addrsss' access bit in
 do_anonymous_page
To: Wenchao Hao <haowenchao22@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260210043456.2137482-1-haowenchao22@gmail.com>
 <5c4d773c-e3e7-4a71-b250-91701cbdd4a2@kernel.org>
 <CAOptpSPuntL5dy+D7-wWcWuOgxugD+_uLzEO8e4fyGjS_ZkUWQ@mail.gmail.com>
 <201fcbb4-c43c-406c-ad54-f2c9301c12b0@kernel.org>
 <CAOptpSN1_4N=e=_e6bVPWjEN2RUXG5=xJouhCaYjjqjLTCi=Rw@mail.gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <CAOptpSN1_4N=e=_e6bVPWjEN2RUXG5=xJouhCaYjjqjLTCi=Rw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 80A5EC000E
X-Rspamd-Server: rspam07
X-Stat-Signature: eaoa9zzdg9zcybanrrjnp8y5yuqq1xm3
X-HE-Tag: 1770886453-888085
X-HE-Meta: U2FsdGVkX1/Lb4ayR76MDpAK1fvbYAP7R4AnS3cVn1X7olTG2m9+rwDQAafZm1YQzPMnCenO/SmNaJiPF/RRk6kGHHy8yv+2RGD96Mrp73YIoBC5vaEM4wbVaDpxTGigtbIR9ffVnsLH1qbizZ3j90q2gyb5lsZM/JE8XFzHsA05rQ/AKTCNhM2+AzMOZqqXuEHkTI4W/oFs4J81PvBH7baCwA//JCjAaPPN49ulNeEg68CF1v3gLK+c9rjUKPT3W8CvDAqA6uHxgz21qWbAhX0MLwXMUp03nosbFMUGsVgSiV0cVKK37e6AKGxCeS9B48BS6Jbyq3IuKG1Kz/+zlamw9+hFg2ieSXpPq6ZUjKDpeUIkvg0qFZVIzFZc1BgwIpmxu28rgJN1OJ7VpYyS423mPWyMhC94RLVLQD+PuYunsi1FVQ0jC7AqeK2W4uukmu9cwVf8enVpLyC6rtctHYfAK6XD87FlcuUqHmjAcwUV0/Lf8N7lkWhu9lAJIk+kB8/cYtQPpwtEwAxT7B6qaHX1MkHUDRG2d67/Rbj3SPDGV4xGcGybSgLGbqS8FDYRQhl3r+ONRKTmh5NafvD4jSWfuImXmj7bSqYIjvl5F5yTufcAz6OryVvmJdXgD1Kv0L/MjKv2glUL91NHJG+SoFoT1jX7TjU5XdqDjzRmXhZZmrA755unjnTuldZWmxevDfvqiuyoESx+ZRfBH4AIk8y0xm7s8SX6uJJAHOj8ty4PdXCtfUtB3+Ic+rhXjNogk2U/mP3sB8/sn10DNHOLOdsqMZktu48Ll2luknTNDrgeOzDgfd2f1ncvLxOh1qH134AbLZaLzxp9Y3OUk6QUEOOCkQOIy4s7PK2KXX42ro+ia7GBVSNhqwIrfNmPgbcoChbWJQYzHIhL7GgGWifEsCo3zsuEVjk/Ca7UwQ3yTdZFnQFzH2YlEldAhcCxK+h48K322pqlKu2OmLA4bks
 v0wH3eUl
 o3Gfo6UBIUafIGL0xMf5h8tbH4q1vXgAlWYMTBIKb56fDR+yBrAdOMbM4fevqbdJuwf/1VtYuDb1pJ5R42QKw1/JH0HC4CPI9ElRneSxVN1g1XWHIHsU+QUwB69XKFRbgJzq++teK9EPZQXAqryo2YDDEKHRHRsa3/pSJg5xPtOZ0KC4iXTmvKwqiJ2QzM/3Sp3byYgq3AD61xnXEJR7apTx58RgSDp6Lu3u3q0tduVZ9vD1hCbwlDwVeOb2xE8qGlDR0jrTNGbbfsZG7AHDk4e5PNenU60akTmgqZzpIVNU0pNtMNKDxihVPJUVyAafz3O4HbOa+yQgwULX/O4wsB7r8tIzoGGDKuflT
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/12/26 02:57, Wenchao Hao wrote:
> On Wed, Feb 11, 2026 at 5:05 PM David Hildenbrand (Arm)
> <david@kernel.org> wrote:
>>
>> On 2/11/26 01:49, Wenchao Hao wrote:
>>> On Tue, Feb 10, 2026 at 5:07 PM David Hildenbrand (Arm)
>>> <david@kernel.org> wrote:
>>>
>>> We have enabled 64KB large folios on Android devices, which may introduce
>>> some memory waste. I want to figure out the proportion of memory waste
>>> caused by large folios. Reading the "Referenced" field from /proc/pid/smaps
>>> is a relatively low-cost method.
>>
>> Right. And that imprecision is to be expected when you opt-in into
>> something that manages memory in other granularity and only has a single
>> a/d bit: a large folio.
>>
>> Sure, individual PTEs *might* have independent a/d bits, but the
>> underlying thing (folio) has only a single one. And optimizations that
>> build on top (pte coalescing) reuse that principle that having a single
>> logical a/d bit is fine.
>>
>>>
>>> Additionally, considering future hot/cold page identification, we aim to
>>> detect 64KB large folios where some pages are actually unaccessed and split
>>> them into normal pages to avoid memory waste.
>>>
>>> However, the current large folio implementation sets the access bit for all
>>> page table entries (PTEs) of the large folio in the do_anonymous_page
>>> function, making it hard to distinguish whether pre-allocated pages were
>>> truly accessed.
>>
>> The deferred shrinker uses a much simpler mechanism: if the page content
>> is zero, likely it was over-allocated and never used later.
>>
>> It's not completely lightweight (scan pages for 0 content), but is
>> reliable, independent of the mapping type (PMD, cont-pte, whatever) and
>> independent of any access/dirty bits, leaving performance unharmed.
>>
>> When you say "I want to figure out the proportion of memory waste", are
>> we talking about a debug feature?
>>
> 
> Thanks for your explanation. I now understand the design logic.
> 
> What I’m proposing is mainly for debugging. After enabling 64K large folio
> on Android, we observed increased application memory footprint, especially
> for anonymous pages.
> 
> Since Android app memory usage depends on runtime scenarios, we cannot
> confirm if the growth is directly caused by large folio. We want to
> analyze memory
> usage via the `Referenced` field in `/proc/[pid]/smaps`.

Scanning for zero-filled pages will be much easier and more reliable. 
For a debug feature good enough.

I'm wondering what the best interface for something like that could be: 
we don't want to make "/proc/[pid]/smaps" slower for all users.

Maybe we could for debug kernels.

For example, adding with CONFIG_DEBUG_KERNEL a new entry

	Anon_Zero:

counter that just tests whether the page content of an anonymous page is 
all zeroes could be doable.

-- 
Cheers,

David

