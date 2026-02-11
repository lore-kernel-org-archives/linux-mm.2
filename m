Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 49D1FEB597E
	for <linux-mm@archiver.kernel.org>; Wed, 11 Feb 2026 09:05:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3E5DE6B0005; Wed, 11 Feb 2026 04:05:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 393626B0089; Wed, 11 Feb 2026 04:05:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 268696B008A; Wed, 11 Feb 2026 04:05:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 12BEB6B0005
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 04:05:09 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A88121402F8
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 09:05:08 +0000 (UTC)
X-FDA: 84431591496.02.9360646
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id DFBC2140002
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 09:05:06 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=HendglcX;
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770800706;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=h+ON3hPP5/P3jT1LxaRTP3uhuvBn0Mjfpx2JhpRXZCc=;
	b=oVfH/ZRi3pSg9tXOTGTQtgoc8bso1dp4sBBncgnuMMNTfm1QyDcjUJtJiEpWyyLSX1mnVM
	dw+tKi0pOqLOBiHEEVyzA1XwmLOCBx2/t7MjnjRlJK7uXP0wLNzMBuzmGPz0O8jTOJ0Cbx
	Ut1kBMd61eySxxfUQ0DWsr2rz9VonTU=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=HendglcX;
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770800706; a=rsa-sha256;
	cv=none;
	b=H1A6cyN73bdCJYVbC2U79CDlU7PIqTmS+YrJJWHTDL/1NkNIXqsB0NB9Fh6JtFmw74+LGV
	9cs7WnQruSUdK0gj8nLdpKvWOlWp7mUmblZQ+rDJvXimhke9kATwe50k6xwO++CB1eDfy1
	C3uWtodynQkrbIJQReqsSAsYHPuOL8E=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 296B660130;
	Wed, 11 Feb 2026 09:05:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65AECC4CEF7;
	Wed, 11 Feb 2026 09:05:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770800705;
	bh=hWUvEIMDgaSkuvkIhEUyb9sETUNymoRMqbQf8BchU9k=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=HendglcX9VxNmWhUJdQ0Ro7+mrzywKoXELy0fHe4P1o9Vl0ijmm7Xnd906z5j6SMP
	 zb1/B1Cmq1HLEPLxBWbl+UWMyat+ixZhN9/pxNbI4HonAcT0foY/PUvEP37zu+4wq6
	 AhBSRQo1Dw9qzA7A7DEM14dsAGdQkbK0HkCmF9/GSMnF+1N9IGarXcAgUStXYETF2Z
	 9Nd5CSFKveZJgW+jNw0qt+oej/ToUfO3CDT+wq83MawG0W53yiCO41kqLu5mkJbev3
	 oRxqtTbSt3ubX2ia1crF52NO981fIWmkkRoh6gHJ12GGIEHTdqNcov03GEwgMkxpyh
	 bGB9zIIYo87MQ==
Message-ID: <201fcbb4-c43c-406c-ad54-f2c9301c12b0@kernel.org>
Date: Wed, 11 Feb 2026 10:05:00 +0100
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
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <CAOptpSPuntL5dy+D7-wWcWuOgxugD+_uLzEO8e4fyGjS_ZkUWQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Stat-Signature: 67wx4numnaxz6nnhy9p44ncrdtcd3k6f
X-Rspamd-Queue-Id: DFBC2140002
X-Rspam-User: 
X-HE-Tag: 1770800706-712788
X-HE-Meta: U2FsdGVkX18NC6MMJcsKlKOV/KYzOeM0FUr9W1NqMLdxIJ8Ac2h9cunqeB11wOoSPHRQylfPDSn8AWsiGxfCCBhbwg4W3pQgm1rXtnYRHziA7Vqa+S7EXHsNdKFcENW7AGps1VbIaPp8dBNoLNlVlkrh3IxVcehqN332NCI7NfLKRJPPdmi45UnwIzFOfKVCvM8BtD6gcC+sW5SCds0LrPslf19M5h6goreXvRoJTjAbT88mYD9d1JUyLmxJ7HoMExYXtL8mekLtA1hWRInYPTUu4PKUtfU3f2+2MQFgHEycqLxEfWbK2FWtB3bBo2SlKnIU1i4VgUxCBYW+p3yFxu3DcLc56zgZ7QKIVvobz6Q5HNnYab/N6o7PK/trhI7vZ3q7kAHfoeI0pekhJ6NhjPHMYbzF7z+bOv97fSt68aVA5bltm9VPqdNkWWNfoKiCHNwju4G5uXowrlLYfcrIQsMf8QuuzMogZuAHJ80MFob5PNMpL6n4VM7S4RdymD6/1XBjRUn7za0YQwykVM7T1yHx+Qf3nqRJ1PEydC2xeKqWVZRJjtxYU3+ix/nVH4kgI5ZmDy60EleEtGqdzNYGeoMoxpQl79o46VDTaJToMebl4XVvWSUwcchh6EJ17r76yLkjXD2NUocpidIf247kC96bL59Vdfemnx8K+0umDiRamvqVp/79yJ3FIJeHaz5SBcGvpxhTnb9mAJlJ/KRtY/nhPyv4IuCKa2ctp3b4wFPr/MYE0xfITzP4pwGNqmCletZaQUGm3Z8ZHmKnqxrN7nlRT4CWn61e7nUc3HYEa29wP8Q8o7RV8pnWvWPgxTlQkQleckOl1Oi283qPkdfko8WAM6jmt2LYHDaAIWDRVPSwh+YAM2q3U3x91ea4qmDbViCadYskXKKB6p7z3LEhkjBnBqKBNib/bQKxUBtWRI+vUgxV4hyolilaRHU310Pu/ilDc9rn4LHCyVYGkUp
 wQUiO2Pu
 NBHxaiUs3+7sx2PuIujCYDRstTZoTx8j7QxOm2vvqEae/zh9shDr9iAf74UN9i+Yt9rzIzOt0R1+kjSznLnWi2sfLbgCUQUsGZdWOkLLyxbQ7jdwZiXitG6TzwQ9Ev+m2SUd0j1zj3B5dDv+GXnKW6sJb25zgfS5lvR8efZCM4ALGW+ifeW8xzYwgF48TPDCVcdyr6TGywdbk0h1Wk0wWk2SH8CaYTjwaFFZDzjy5w/GeZsefU18hHWLID6QveCmbiE4W7la/OgNc9jal45+qrEGccxgqJA0mc9AwZXlyAXvcX0D6eOFEeyrcsmSQ5IReewzjWshjbXOSX5eKoMZXNy3999ePsyY9bSqi
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/11/26 01:49, Wenchao Hao wrote:
> On Tue, Feb 10, 2026 at 5:07 PM David Hildenbrand (Arm)
> <david@kernel.org> wrote:
>>
>> On 2/10/26 05:34, Wenchao Hao wrote:
>>> When do_anonymous_page() creates mappings for huge pages, it currently sets
>>> the access bit for all mapped PTEs (Page Table Entries) by default.
>>>
>>> This causes an issue where the Referenced field in /proc/pid/smaps cannot
>>> distinguish whether a page was actually accessed.
>>
>> What is the use case that cares about that?
>>
> 
> We have enabled 64KB large folios on Android devices, which may introduce
> some memory waste. I want to figure out the proportion of memory waste
> caused by large folios. Reading the "Referenced" field from /proc/pid/smaps
> is a relatively low-cost method.

Right. And that imprecision is to be expected when you opt-in into 
something that manages memory in other granularity and only has a single 
a/d bit: a large folio.

Sure, individual PTEs *might* have independent a/d bits, but the 
underlying thing (folio) has only a single one. And optimizations that 
build on top (pte coalescing) reuse that principle that having a single 
logical a/d bit is fine.

> 
> Additionally, considering future hot/cold page identification, we aim to
> detect 64KB large folios where some pages are actually unaccessed and split
> them into normal pages to avoid memory waste.
> 
> However, the current large folio implementation sets the access bit for all
> page table entries (PTEs) of the large folio in the do_anonymous_page
> function, making it hard to distinguish whether pre-allocated pages were
> truly accessed.

The deferred shrinker uses a much simpler mechanism: if the page content 
is zero, likely it was over-allocated and never used later.

It's not completely lightweight (scan pages for 0 content), but is 
reliable, independent of the mapping type (PMD, cont-pte, whatever) and 
independent of any access/dirty bits, leaving performance unharmed.

When you say "I want to figure out the proportion of memory waste", are 
we talking about a debug feature?

-- 
Cheers,

David

