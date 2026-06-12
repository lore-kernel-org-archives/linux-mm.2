Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 509EECD8CA8
	for <linux-mm@archiver.kernel.org>; Fri, 12 Jun 2026 11:14:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 08B416B0005; Fri, 12 Jun 2026 07:14:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 03B8C6B0088; Fri, 12 Jun 2026 07:14:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DF7BF6B008C; Fri, 12 Jun 2026 07:14:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CF2EC6B0005
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 07:14:19 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 659D4165810
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 11:14:19 +0000 (UTC)
X-FDA: 84871001838.10.20A872B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id 89DA0160015
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 11:14:17 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="n+h/dgKk";
	spf=pass (imf08.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781262857;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dP7e3JEtOPtC6CVM3VUIPHIKZe0OVbKMvYxoe2ZHRtY=;
	b=piTFZeCMDencFoA/shjFGlKOMlc0xkmgrSjXQPuCOEeRMmN3ylRWIgJo2w4sfokylxYuC0
	l15jbOBoGAkOGJCIU5QVaZ6+IOafgiu1nFEMkMKOl7HhNTf8NrWQNQ+7CXbowLq93iMB9I
	k+KKG+/8oKrIUh2sXFRwEXVDlt3cYAE=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="n+h/dgKk";
	spf=pass (imf08.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781262857;
	b=bAEEofGCFOEtvEvDTlN6FQA2pSq0ZX3nS4hzywgAMiEJMrK+Ux815VSDmEMeyVIfhy/LAl
	rI81KT05IOzCP6duhxZsatc8YtAqlJTUM5PlO1WjUlsgtH9s3X6DCyjvHvA6LgP/WvJVzr
	Qh535cvI2/BoLQvQMmIUUqGJ9iJpTio=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id AB3DC43A95;
	Fri, 12 Jun 2026 11:14:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E07F1F000E9;
	Fri, 12 Jun 2026 11:14:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781262856;
	bh=dP7e3JEtOPtC6CVM3VUIPHIKZe0OVbKMvYxoe2ZHRtY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=n+h/dgKkcBlo/dGQjj1ub3s9bjOa0M2la6urtdxD0te37aVSmCofz0hyWaifbPk20
	 mS8IHjwYOyPvqcGFKrUnRefPCHeAQFySphnvGxKPQLj4KzCYeGzPYq+BCR3cj4vCA6
	 viFy8LB1SAvbHyu/PXVcxGxXFGzLV4lIpsWxWktEtHo8/sTXJB2/0K71s+fSdPIhB3
	 nX9RflZcxKhiUeUSMoVeyVE4jZT8zOB7eNZFF7cKPGRJ0xB0z3EYGyPa61BN7W9knN
	 4GxyBMUDop4P3Sk7/axoqTQA3bJ8OeJqcVc3VI47d8arWIzRyxwP4RvDi6JVUKjcj3
	 qAM2UyRRNtqIg==
Message-ID: <3603c37b-95b1-4d29-ab6f-fa3360dc17db@kernel.org>
Date: Fri, 12 Jun 2026 13:14:12 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC V2 0/3] lib/vsprintf: Add support for pgtable entries
To: Matthew Wilcox <willy@infradead.org>,
 Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>, linux-mm@kvack.org,
 Rasmus Villemoes <linux@rasmusvillemoes.dk>,
 Sergey Senozhatsky <senozhatsky@chromium.org>, Petr Mladek
 <pmladek@suse.com>, Steven Rostedt <rostedt@goodmis.org>,
 Jonathan Corbet <corbet@lwn.net>, Andrew Morton <akpm@linux-foundation.org>,
 linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org
References: <20260610043545.3725735-1-anshuman.khandual@arm.com>
 <aisJbeVVxxNuYxQ6@casper.infradead.org>
 <aisNjxHW369cbKiq@ashevche-desk.local>
 <aisOi1B0o5KYyaQo@casper.infradead.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <aisOi1B0o5KYyaQo@casper.infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 89DA0160015
X-Stat-Signature: ngub1jmjgd869faaj1une88bapaw49hn
X-Rspam-User: 
X-HE-Tag: 1781262857-172078
X-HE-Meta: U2FsdGVkX18GfqHxecGZVzHmroW7S4SC89Up0eQTaKzlunpAUD/Fz9ixH1chOLdJuBr9QUI72Q4u+uiIzLmXO1W0GfKttaYC1af1q2H5AGVWFtpn0xqyChYsfbkI811qTVbsqZW+1sPfpClIhWKnMQcqYJfnPDjDQr9wlvOJc6WmqnZr+FBsSrUZpEZFGfEyUUQQr1t5Md70gB9dBoxlp2aqtZ2Inu1e4D2uDeuNQsIuJbiu0scDwjauUYbTLuDe1zOhzXLcZ0DC4Jn33/jcL6WkpkuclYxAMhycDif257HO8vFRrOfkzv3ZRZtMiuPQ96EfM1+4RLCbah+tstquyF98hrf3CkXi3kB7cDedf7ZFvLrCpTHuDnDOelkLFbKQFJn5OVLSWs6mtB/pN7+GIVvpRXkN3ngxO/BLmZG+2OHd+KI0Xmk93WNEQqgMbN6ott2sSEVV39wL3NnSSe1CRizWwGCmplQO1PGlO9lrEhbyyKPDS27XC3W8SVQLLH2dzNta7Qyp1qZ0dcNrSeJOVBpk2r5UgOKHqasaz1ernbC8+695jVd9/BimJDdYhpb51sai0kLgFS+q0RO7SF9T6FM/fJCPV/U3Mgrx+cV0MRgVA7rlcpAAispHLytbhU9sgrSPFnUm8CJaAQaQGtSjY13SE8cAFKqsD70wDYQAk3YM7ZhjhsfN5b+r39QbcPFHE23NnP+UkyqrFWBvDQJqJi6X9/d8prUWrVZLh0ScgTaDLNAyywvgae+kA1RmGbzD4OqH0EJsXUxWGATL53YN0iozA/prTWKnlm5Ugf59+frMwAKxtv59wK3MF8zvEOS4GNkd+1yP7iDXTSFrlTMGJQgBBJQDks8AfrWp4912dMAZDuVTp+TZ0LcD5YoAdveEEYh9/mGFlUOPKJ7z3kn3QlSaSrCdJ6DxszZKc6PWoLq+zyGHI4q472zrRbbLn67Nr+ziHDOSwmu7CkBqT0g
 rUalJQXo
 7FjfNLQXQzwT50bI6KtyGUNOUNhNZfL480FAGscvCi2uFLtqVrF/i9WK7FCBN19289LYtEm5zOGZIUhEyYA09y3A/NFNxvegK9+khcaVd2pyikyjzbRloOBtl4y+7W+w0ZrPP+eFrtBJGXR+eBgtwo8gYD7gVOFv1ftCwDyzwzkafywmjjwsKxFFEEtakWIuRxoavoYEURF5be0prUuAnvvPfUS59LpwiDyzjbHMAl+anWJvJtTGXo9kXGjpI/3Aknkd6IzJYW8K7J8mIsYmEHaXr2GVLdUCNtqCxw/hkct8TcTRbHnbAjrY201d4f/HPwtWcimg4Z4XhcnVpBllQ8GZj9Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/11/26 21:37, Matthew Wilcox wrote:
> On Thu, Jun 11, 2026 at 10:33:35PM +0300, Andy Shevchenko wrote:
>> On Thu, Jun 11, 2026 at 08:15:57PM +0100, Matthew Wilcox wrote:
>>>
>>> You didn't address my objection here:
>>>
>>> https://lore.kernel.org/linux-mm/aFQP8LzVMctf6XH5@casper.infradead.org/
>>>
>>> ie there is now no typechecking possible.  So you've made it more
>>> dangerous.  I reiterate my NACK to the concept, not to the implementation.
>>
>> But this is more of a global question, how do we check the validity of
>> the parameters of pointer extensions in the kernel? Does anybody go to
>> commit into GCC plugin or so for this job?
> 
> I agree that it's a global question that it would be great for somebody
> to answer.  But it's specifically a problem for this patchset because:
> 
>  - It's really easy to get confused about which page table level you're
>    working on.  And hugetlbfs deliberately increases that confusion.

Yeah ... so far I was assuming that for hugetlb, all relevant entries (what we
call a PTE although it isn't ....) would have to be the same size. I mean, at
least in the callers they are the same size (pte_t)

>  - Different levels of the page tables actually do have different sizes
>    on some architectures, so if you think you're looking at a pointer to a
>    64-bit quantity when it's really a pointer to a 32-bit quantity, things
>    Will Go Wrong (or vice-versa.  And some architctures are big-endian)

I see your point with the pass-by-pointer.

>  - But on x86-64, Everything Is Fine because all levels of the page table
>    are basically identical, so you'll never notice there's a problem.

I assume on most architectures.


Let's see if we can stop printing that information completely, so we can avoid
messing with this at all.

-- 
Cheers,

David

