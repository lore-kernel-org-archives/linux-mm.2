Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 968FBC79F99
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 15:09:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8977B6B008C; Mon,  7 Sep 2026 11:09:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 848726B009D; Mon,  7 Sep 2026 11:09:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7109B6B009F; Mon,  7 Sep 2026 11:09:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 526776B008C
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 11:09:41 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E5F46A017A
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 15:09:40 +0000 (UTC)
X-FDA: 85187300520.04.2C861F1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id 38450A0002
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 15:09:39 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jZ2Ej4o6;
	spf=pass (imf15.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788793779;
	b=oOPka3dS1JkgqlcJAGpqhC8YfFv08VMyEwGCTDx9YI4Pr1U/BCxHq+wylK3duYgnNG//5E
	cRfzG7OcZiXMQlOud+uI3Y+dY5NIDspeTE7Ygu/Vd+uoNS098XzB62rv2z3Dr3ewq/NCW6
	UUJzKtWiCD/gOQWr6SpQF18Zi/vEyn4=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jZ2Ej4o6;
	spf=pass (imf15.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788793779;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=a2tewgAqN1l+PrFwzJKAGhBGvdeNnZRzDfeds4hg5zQ=;
	b=L+BRzQd60Pw61Dkn0Wd47sIy3TmpeaoUTs2BIwQVA+UHpWnuYs1fIKLfRH7mL2gBpjMN19
	UlAtYJxexvYGUK8ScRJLW/vBAjoZj/VcNpcvgNlDlGjmSzwmqpIl5Wv2hoLu5f55XJBmgq
	zQKwOAZCmsWU4RIvTzD9hcmnwOb2Cfw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id B946660AB5;
	Mon,  7 Sep 2026 15:09:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 808521F00A3A;
	Mon,  7 Sep 2026 15:09:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788793778;
	bh=a2tewgAqN1l+PrFwzJKAGhBGvdeNnZRzDfeds4hg5zQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=jZ2Ej4o6rCHE2ixHPTMWVEAmIO5OFj7MCI5XtjI1faWcP9lpG+HKvXSgQnnKOKaNu
	 OSY7kCfUHC2N40EHpjnYwTVbQCDs8ZVTlGyw8AV1JoMFXO7+w1pzKYj2gtYCK7w+0o
	 ezaMAlDteQT5vaKbQp0EkqF2hITJRtSYSJ7OLiL5qvyNmx80Mwds/eGji17U1sNaNn
	 a5H0W+TS/TiCCvTYjJeWXhtI6u42a52JMveYl/lnfin0T/yDvgkKs+gPvYuPQf5+IW
	 TBWH4fI/eV5wG8xmpsZJ4oE0PZqSqGvEUoBl+M9K8gP+xtMxh0tPt6BuFkJ4VzCzH3
	 AFMcrPlq8NqvA==
Message-ID: <55ce7bee-c0e0-4051-8bc4-26cf3aa3f7e9@kernel.org>
Date: Mon, 7 Sep 2026 17:09:34 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/madvise: swap in CoW'd MAP_PRIVATE-file mappings on
 MADV_WILLNEED
Content-Language: en-US
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Pedro Falcato <pfalcato@suse.de>, "Liam R. Howlett" <liam@infradead.org>,
 David Hildenbrand <david@kernel.org>, Jann Horn <jannh@google.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Mike Kaplinskiy <mike@recall.ai>, zhaozhengzhuo <zhaozhengzhuo@uniontech.com>
References: <20260904-madv-will-need-map-private-v1-1-6b83cc99fcff@kernel.org>
 <apriM1q4GzAgP7JQ@pedro-suse.tail5790ac.ts.net> <aprjOxDy3JCPb2oa@gremlin>
 <20260905171757.ba8b0f8f0f18ebd04418bfeb@linux-foundation.org>
 <ap6u6Ana3MvvIIUe@gremlin>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <ap6u6Ana3MvvIIUe@gremlin>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 38450A0002
X-Stat-Signature: 8s4u46jw8cyeyboxpt61q5hhhg8tudh4
X-Rspam-User: 
X-HE-Tag: 1788793779-452995
X-HE-Meta: U2FsdGVkX18P6XKx1925VJMGRoRYou2kaRVtrAUJk/GPpu8rfFOzJmpE7LP9/WyFGYN+bmE8ywj8gnKHijTdIBMR91agsPZckwrw9m3xPU4wZVhbJLHVSP3Ugu7cojsq9fSgO7Td0yJaujMTf4zA4Wv42ZxsPDpV5z47u7gsZi+NYyqOHLXAAVKC7GHUBZqlGVtPFB9STls8jIJDI5ywFMz3lz86ObpnHRmcNeyC008LGjvSCaAyakEMNyQqS87SX/6gvKaMiPXdpjL8TdPgu1uI1KwoT5/VLJLbyD+nirxsfeAC+PhbT0yHE+XZdssF3uxTnRINcgDKc92kj4FOiMPXCOJQ+A3FgjXat5eoq6eTCF6WtvZaDrb2HHxj/X1Q+zrLNyH0WkHYTTdoELMKo42E4q4KkE4+dm3xEOpk2RvojQzT0exxB4+3nwBzFlLcxCZIaLOliizi8qf1o/J+b9uzKas3xjouoTCnD7mga3mfFDJrt6lw30oj41DTnBsQOg1Iu8/g61WiR6WFIIs5yF5qtduFHyI/zkd8IIFrfS87CuPdNWtwj0+2CXEnBUnxb+QJ7o8W2Ebn8NOGAC+j5HkLa3ST5gxBLYzk9UNZfLaWPSVWPmV7g9bkYQtJxLwGH34pPRm6x9NhHIeJOnkssOnFN4XnfsijB+CNNoNdTUylISyPGebWAFFDY0Oe93oWWGryEDYfuRyQbHJq0VWGLTKCQL1SDeoU+I8lZeih0RAPY5zBJG7KA0BwTAvWGXcoxbEbCoMRYgjhFRyEmaTi/29I6HD6cqE/nKVyefIBHKfbIDJ5x3pzTnK6NWbDT4EDPMa2CX6NXDDMVYK/eiHcX7w/w5jWi4FCG8kcszRkB9ts2sasOhCEJGRakTPjAQl+0PSs4aHIarojSTjcCEcDN6rq3/FkXo4Q9fUd1ngxoHq5spVTA6BXJNrjFZK5IV8ieMP/zsSTwaINGwJK6YD
 3Mq/phTF
 nCDziF12kXl/QGDf9zGcDVUJ/DDo2X1+YCeM0XYuHAZfv5MuFrAjFrcHS/2X9EmlYlFNKlCqP3YOvpJoUW1TkVyEpimi+mpqtZxIIIzwuL/Kbq02k1uXqdfrBRDzpHuJjG3rLJrLM9rx82Jx34vpGmiJWFPjwXaFD+Id6s4kNkD6DKeriLACgJwd2DZne6HANa8K68N2xUT8vigEacfSw3Z5qE8JbFaf06TYTbkG1fKVUcVQYUqrcMs8h0faCSQAb+5L6qIgBeH9EIKUHP4hfATC/1y2VdBG/j7XQh0lMYU4n1PFxiO2GVcpe8uwGIjGzz9YYtDR9PoCqxDtcaIUB1EVY3FLFNt2XHxP5
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/7/26 14:32, Lorenzo Stoakes (ARM) wrote:
> On Sat, Sep 05, 2026 at 05:17:57PM -0700, Andrew Morton wrote:
>> On Fri, 4 Sep 2026 17:01:37 +0100 "Lorenzo Stoakes (ARM)" <ljs@kernel.org> wrote:
>>
>> > Andrew - could you swap the patch out in-place with below? Thanks!
>> >
>>
>> np.
>>
>> > Currently MADV_WILLNEED treats file-backed and pure anonymous mappings
>> > entirely separately - using POSIX_FADV_WILLNEED (equivalent of a readahead)
>> > for the former and a tree walk and swap in to swap cache for the latter.
>> >
>> > MAP_PRIVATE-file backed mappings straddle the two and currently get treated
>> > as if they were purely file-backed, meaning any swapped out private pages
>> > remain swapped out.
>> >
>> > Resolve the issue by explicitly checking for CoW'd MAP_PRIVATE-file backed
>> > mappings and performing both walks in this case.
>> >
>> > Since the logic checks for vma->anon_vma this means un-CoW'd
>> > MAP_PRIVATE-file backed mappings retain only the single file walk.
>> >
>> > Reported-by: Mike Kaplinskiy <mike@recall.ai>
>> > Closes: https://lore.kernel.org/all/CABeknB_S2XJSHFgnHdgnN0rjzHhH4oQJs_APq9fvxHztQ_pgiA@mail.gmail.com/
>> > Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
>>
>> The failure mode looks pretty obscure, so I'm thinking that no backport
>> is needed.
> 
> Well it's not even really a failure mode so much as a 'known limitation' :)
> So yeah agreed.

Yeah, as we know madvise() just an advice after all, the kernel is free to
ignore it :)

(MADV_DONTNEED and friends enter the chat)

> --
> Cheers, Lorenzo


