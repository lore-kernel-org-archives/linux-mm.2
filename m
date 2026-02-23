Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B0534EA4FD5
	for <linux-mm@archiver.kernel.org>; Mon, 23 Feb 2026 15:32:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1EDD26B008A; Mon, 23 Feb 2026 10:32:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1ADC66B008C; Mon, 23 Feb 2026 10:32:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0D0FF6B0092; Mon, 23 Feb 2026 10:32:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id EE82F6B008A
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 10:32:05 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 9C1981A01F3
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 15:32:05 +0000 (UTC)
X-FDA: 84476112210.28.510D58F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id CED8120004
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 15:32:03 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=k4vPP7Zj;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771860723; a=rsa-sha256;
	cv=none;
	b=kOwQMy0mwqg6pm80I55AIRVXaxUR3v/D66vsUzIySehEAOpUGz/kdRx5oD9O0qHnxd0aIx
	MTzvdSRyXNxBfSd/TPwtSQ81/f0C870I/fskKDIvrtKqpBQpLRfg4HzC/MS60bzbdfVizi
	e1jbYBAtsQs92JhSLe2Q3CgtCTT0R4I=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=k4vPP7Zj;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771860723;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=p6JjQQv7UNHED3dJwwlueF0pFgHzsOufk97nLlruOOg=;
	b=1tzmx2EUhava6jCTAMlnt0yH/RvNR+ao1twf+290l2UDIa+H/oWviQfVycXWrV8jK4ljW5
	/qcv2Tn34Vd0F8GppQb8fc7Qvq1l+C/f4VyMlvPOOsB3w4an69Wi8oYIT32e410ofcgUF4
	XtlWUJMNjt30Xd3lsWF5MdN7R9+LoUM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 3593660018;
	Mon, 23 Feb 2026 15:32:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83125C116D0;
	Mon, 23 Feb 2026 15:31:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771860722;
	bh=LRL3TEebauglrWICWhBhJ8xMN4jV0MTXRZp1Fsp0Ovw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=k4vPP7ZjMugCeFHa2nc4/4F7dgyQD+ogk9/gOBTtJc97epaG8wIVRoaynSjJ49O7e
	 eqXiLgt6iP/y2la7NC33QK+y4rVr9oaCGn86/h/NBYmavRulcEoK8nzCVi3yd+8tkx
	 pi9xxTcM1ikI+cirXUrU6JJYj4cRKuhQAfBxgVTN0g9389YsF2TflJQwJbp6H07FxQ
	 /YSlVXvCSjD7dZSKXlVOheTfVtkcBV50jfJXYMaK8d5VipeJY4H0eotXEYBj3JW7A2
	 qzE+XHiIz9wSee7Jzkf/dEWxowp0CVS1amL8PbBONw9T06nIyoLdI/F74UsNVvTwjQ
	 y7b15Va49h7wg==
Message-ID: <89cc554e-9c6a-4c8d-8c30-573b2eabccac@kernel.org>
Date: Mon, 23 Feb 2026 16:31:56 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [LSF/MM/BPF TOPIC] 64k (or 16k) base page size on x86
To: Dave Hansen <dave.hansen@intel.com>, Kiryl Shutsemau <kas@kernel.org>
Cc: Kalesh Singh <kaleshsingh@google.com>, lsf-pc@lists.linux-foundation.org,
 linux-mm@kvack.org, x86@kernel.org, linux-kernel@vger.kernel.org,
 Andrew Morton <akpm@linux-foundation.org>,
 Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Mike Rapoport
 <rppt@kernel.org>, Matthew Wilcox <willy@infradead.org>,
 Johannes Weiner <hannes@cmpxchg.org>, Usama Arif <usama.arif@linux.dev>
References: <aZcmlIF4bmG0twkp@thinkstation>
 <915aafb3-d1ff-4ae9-8751-f78e333a1f5f@kernel.org>
 <aZdCl8byz51Q1-v6@thinkstation>
 <17c5708d-3859-49a5-814e-bc3564bc3ac6@kernel.org>
 <aZhErt9DZcWI24_v@thinkstation>
 <d7c7ef63-e40c-40c5-8ce5-a4ca411da832@kernel.org>
 <CAC_TJvd=wKKnj=d3phZsAaarXUdUbZDGauxWNWkQtsFV-MTYEg@mail.gmail.com>
 <32ed82dd-62c3-4a5c-8bae-9465afd7e75f@kernel.org>
 <aZw1DlKHaWvgOtm_@thinkstation>
 <06684dc4-3902-4452-824a-ee2064314d24@kernel.org>
 <7b414e68-4d0b-4d2b-a664-bbbdf314c0d3@intel.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <7b414e68-4d0b-4d2b-a664-bbbdf314c0d3@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Stat-Signature: beba5yk9aam31qm8cyzikr8jfdcga8ni
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: CED8120004
X-HE-Tag: 1771860723-398072
X-HE-Meta: U2FsdGVkX1921yaM7J6UZbImgaUJz1ADan4nfIz3GlBVvtcqMywWw1XxVnrZZmSHSFjfyEs8lX40hKxYWylv9usKn/JGQ50Os/WmiCr29dTCDKrj7mM+hZQrqTufhCzyforx6ODCq8sNyeKG1ImBRSIhRvxfDZpir2CUPRmviyXcS6xvwvNWRsicGvrxB7GMvtMkk/691R+eqqM3fWOzAqQViRjzoefHaI9rIW52sEyO+DaTTZ7aKv2qRxhO7u7dfO1gjWwiXqQJy5xIDSGJPAUgJbsGlLYcm4jm6cBI9x4jQMc5tHQZ5aD5OPN3+coHjgdNfJseG6RLagv1XiK0eLxOCrJPib4tZPu+IfEkq/1SAc4rpgaOcHwquVcM7M719tPrvlYP9wKVkHKYJ1JiG6oRJEXQJ+Zv3sjs/2kHNXwFRgFPIqroqwU28gZfUPtLI00XnV6vyIBczBjB3+h6YFSWTc+aSohCdjn13xdWULx4h9HraJZDuKQH+ajtiKnW8/8XagQYIktmigAgYtCZN7IhnEAMoarBjXsfHEK/pvR4UQvihk8JV9pHDb4WYID4e0F/+KJSYMZoPRx7TSCXZs9m+d6qM+Qj+U7HkPQKGspztimasmxRAGVyP+0IEFq16h36UUt+xIn3aYEgeiIn4JooiMZHK76RSfE7As76L4xLSkNJnqRwRrLiXK5ES8u8KBGedh31hZSi4CKcgt/ah5nfUQP01RpaQKvG4zhkDrHAGK0l2UGIGgrzZGWU1I1eCxbY3UL2BNtbAJ/lCi/IXHYtEhzb24KsUfDEDjWm1oiE0km8RvkaDHXcLQ5voJDRKj2kj36TmXbY6ozDl56cz1EiX9mkY0c9UURL4objQTTsMzTtpHxwCbvPv/pFsCOAGqvNDpgo8uDX+nOPpZC5d3eyHDf2NRadyy+E9ejVaOCRLYHE9K/z22Oa6kYHjoGxlBkS6rao2y4foiD7iz5
 2OutaQVw
 lDc++MuWvyGhvCO0tvPeZRNaCq5XdDN8ITeMhyAVeL1p/63AptwarHyPXpDhBFKUt2kCm5arGMXgkR/5LDlpdiwuvgzfpKZIrxuy9/BHsSbGWTjOtk6U7zoIwIfYpWGaLzlEqBMPmd2w1duq7jcJnnktVZLrlaAJ4tZYP5TI87qY2PvZZzaTgqebj8aeXUepGSDyItURJWB9Z1yzO5raUQruQsKbufva2aWD2fzM0tRPxbT4ojiD4KHWZeSQaOl6KjQFVHmbAnkp9pmC+wzVNcTZuGAftiEvY22Go
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/23/26 16:14, Dave Hansen wrote:
> On 2/23/26 03:27, David Hildenbrand (Arm) wrote:
> ...
>>> BTW, x86-64 SysV ABI allows for 64k page size:
>>>
>>>      Systems are permitted to use any power-of-two page size between
>>>      4KB and 64KB, inclusive.
>>>
>>> But it doesn't work in practice.
>>
>> Even in well controlled environments you would run in a hyperscaler?
> 
> I think what Kirill is trying to say is that "it breaks userspace". ;)

Yes. Probably similar to Intel proposing an actual 64k page size. 
Expected. :)

> 
> A hyperscaler (or other "embedded" environment) might be willing or able
> to go fix up userspace breakage. I would suspect our high frequency
> trading friends would be all over this if it shaved a microsecond off
> their receive times.
> 
> The more important question is what it breaks and how badly it breaks
> things. 5-level paging, for instance, broke some JITs that historically
> used the new (>48) upper virtual address bits for metadata. The gains
> from 5-level paging were big enough and the userspace breakage was
> confined and fixable enough that 5-level paging was viable.
> 
> I'm not sure which side a larger base page side will fall on, though. Is
> it going to be an out-of-tree hack that a few folks use, or will it be
> more like 5-level paging and be good enough that it goes into mainline?

Just thinking about VMAs spanning partial pages makes me shiver. Or A 
single page spanning multiple VMAs.

I haven't seen the code yet, but I am certain that I will not like it.

I'm happy to be proven wrong :)

-- 
Cheers,

David

