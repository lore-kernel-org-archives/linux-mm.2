Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 21864E81A44
	for <linux-mm@archiver.kernel.org>; Mon, 16 Feb 2026 16:56:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 486A56B0088; Mon, 16 Feb 2026 11:56:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 434A06B0089; Mon, 16 Feb 2026 11:56:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 316BB6B008A; Mon, 16 Feb 2026 11:56:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 1B7326B0088
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 11:56:21 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 720471B557D
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 16:56:20 +0000 (UTC)
X-FDA: 84450922920.28.BCA7E8E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 959F540008
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 16:56:18 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=lzkYBfO+;
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771260978;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bvWse1u7cH7qRCPtQFi3FnUEePLqkbglJjFEYwbfoOQ=;
	b=iQsL7BtCS63WUQLeHdyG4uQFMt26+Tpub40SeXYjLmDZpGsq8FXUP3TFSgfqEAe932ma/m
	bg1W6Tybj7u9ynWKHmC4fBqYQ0RSxGsvbc1evN9EV91xiYbCBAMoP+whmDHZ9hSdZIj+Ak
	DLPe4T14TtTD6Pbr8Z+OSWu9y8xmbcg=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=lzkYBfO+;
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771260978; a=rsa-sha256;
	cv=none;
	b=KHeMzy2TuwYYNWgw9CPgDpU39+FCTTuP//LfUX5SuSOvwa2TGlqDeA9cFUDKe2EBMc+N4D
	a2ux4NoRmC6IC0vnYToq3x4F3nDa0QwlzRRiuM88hRGXUXUIqRfvaQ6YVqUxrDyn5nlZBT
	QhU8WfpC1mGDTt9tA6ZGr5ywTsz4aEI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 59DB344264;
	Mon, 16 Feb 2026 16:56:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95785C19423;
	Mon, 16 Feb 2026 16:56:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771260977;
	bh=psHk8ooPVQIi0n1vAky6NB+Eow9vaXXza3Qa9opqD8I=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=lzkYBfO+IVMEcYFua54czgMOjhBk8/fDUaWj59PjrMC1PHZTVT07fdzup0rT2Wtet
	 pl9e6YOL+c/d/jWC0IISGGKA2PFD+2X1uvRgX2+2KQhVNZRllJN1Az1UEfz1zj+md+
	 VxbSMyD1isp+gV2m12gqporARmvSHK9aDfeKujfXINH+Fuo0P/hiarGKIk9uH2HWRA
	 Xe+9l993X+xRmrygNuhb4CJ3k6tcq4NaebwLU/i2cM7mVbRCRlWS8w0nqSI1Re4+KC
	 SX3hg/e4JP6gjK/UQw6q5l1KI4oe5Ny2kDgyJH9t6ZdQb02fZ2twEH5r6HUWHGYxZO
	 hmSyWdUULGcvA==
Message-ID: <b20695bb-227a-4e00-a36d-9fc389aa1ab6@kernel.org>
Date: Mon, 16 Feb 2026 17:56:12 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: Add AnonZero accounting for zero-filled anonymous
 pages
To: Michal Hocko <mhocko@suse.com>, Wenchao Hao <haowenchao22@gmail.com>
Cc: Kiryl Shutsemau <kirill@shutemov.name>,
 Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20260214084514.2842745-1-haowenchao22@gmail.com>
 <aZMAVF1S1kP5Gny_@thinkstation>
 <ddb0d3f8-a617-49a2-8fb1-e6293f376030@kernel.org>
 <aZMEvl7WUKyxmgIh@thinkstation>
 <CAOptpSNMx7moZnLP1Q9xX_6zw2xJL4OV4N=f8rzyZBLuTMEJnQ@mail.gmail.com>
 <aZNI9mo34vs27DXz@tiehlicka>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <aZNI9mo34vs27DXz@tiehlicka>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Stat-Signature: 9h5qgp548me796rwoj6pqbyr5wbk91ch
X-Rspamd-Queue-Id: 959F540008
X-Rspam-User: 
X-HE-Tag: 1771260978-882596
X-HE-Meta: U2FsdGVkX18f0s6fq2H4Zhfb4W8ovBSJexod/g+IJ3esN5jBlVKm6dVdou/rJ4ACGxgw3IZs5AShgOHHIEtcFjTwoUXP4xzAFDHMPyi4ikm7dhSWxlibhBPwWwlHBxXOESjcuJCHMgvYoG1wvqMbfIXnWkgWNbHN0mGHDYCQaR64qI6cSgX36E5RLUdU5r2SLtyll4ubGoS27xhDx1Ej1WhVN/9YXcxDmnAPT9xHfK1ikD9qzUHnlC2NuXYiIncHkUQCqXL2ZwwiPZonPnh61JaYTN0ZOGGIDp+d4yP4wDKlwXm7sFvGUz/T3KlDYlYeychpcbtdwqGOkDTZOmBplAs/UCYlNj3AtIXDtX4n689E5z7SBZeohMnNq8j4EI0WD9B/BQX6E/tw0BLoLpCi+fxqjAc7kahJtMuxKJimiy0RvFMhvLJ2uQASMHBpzD1JJz0ubqtUBoZwQC1F3ZWAOqK5QZ0Vj1XklquDkqpYkYfvvcotrTwWx+NiNh+hELjbugp4OHuHBgvMsFnh7aGYPGvdsGQpKPmv1FJYHWhK/dkOF5G5XmfkYphMGOGS9SbEO0GpDhnanGhD4XmZGGpAZ+BHUbHHGbwflq9VykSUbWQwBGk6S6V9jQG+HNaBPPQjg4twxSXcuV0FvObzaTHgIhtpIvFMkecA8zbAfCJfnLVgFuoh+3Q8VCcCEm8KjkovfGC8yz9vm7SFWIWmPz5lGnNFQRl+ClvIhihdQLUawODxl0z47nLtA6Bpw/JR/Cqq/6q5XYPYIy2DRpfsD4mffwdz7S+bvFS937WMHid01oNTWjGs2J8UaroJQeZrALX7JX4yw3513qhKwZ4/jHm8Qg0Gz8POU1Gt/cVs5pCpW+CWm5wk2TKa6+tBOVJIYMr1AOQNF3ojv9m+Fj3+y3wvuhKBe3pPfOq242jFAMsb7h9QsmYLi11ZLaRlo2LeN0ag7mVcAI4IW5DSXWGMmyZ
 Apg2jiu+
 7rsDDbo3OwcI7zRaqbfe0RABg5UOU/g20gkXRpkkCFLUuaT3JtTET4YtwVuB96zauUIvyju4EKAgDnswCYbXUffxrKp4QOVYL5/TBbw2Epdp62kiMK3+mYEisnK/YVdv5rvSUMsvLjhviTbPyYU9U5mOuYXF1/Ostm1+4xFh9/cYi7PAyqAyl6G26eN5bXa/VOkUr0Niiycrfy98UjslhE4RZ8poTXZJFd43Oea0qhjwEaTsOzMaNT3rtzZ/DHcmfkobbDUKReFVCaWdRIaEph7EiTPh2TUv+dqEY
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/16/26 17:42, Michal Hocko wrote:
> On Mon 16-02-26 23:59:50, Wenchao Hao wrote:
>> On Mon, Feb 16, 2026 at 7:58 PM Kiryl Shutsemau <kirill@shutemov.name> wrote:
>>>
>>>
>>> One users want the stat and all users on the machine pay the price?
>>> That's a poor trade off.
>>>
>>> In general, smaps scales poorly. It collects a lot of stats and most of
>>> them are ignored by user. We need something like statx(2) where user can
>>> declare what he is interested in, so kernel won't waste cycles.
>>>
>>
>> I initially considered two approaches:
>>
>> First, exposing the needed information via smaps. This does incur some
>> performance cost but is the simplest to implement. The new feature can be
>> dynamically toggled via a command-line parameter. When disabled, the
>> overhead is negligible—only a minor if check, which is insignificant compared
>> to the full smaps cost.
> 
> You are comparing content of all anon pages, aren't you? Depending on
> the content this can add a lot of overhead.
> 
>> Second, adding a new system call or extending madvise with a new command
>> like MADV_GET_ZEROANON. Userspace tools can then use it to measure
>> memory waste from zero-filled anonymous huge pages.
> 
> MADV_GET_ZEROPAGE would make more sense to me. But a more fundamental
> question is whether this metric is really what you want long term.
> Kernel can do all sorts of optimizations behind userspace back - e.g.
> map shared zero page - so just learning that a process has a lot of
> pages filled up with zeroes doesn't tell you all that much. Or does it?

If a sysadmin wants to see where THP hurt (zero-filled pages), surely 
MADV_GET_ZEROPAGE is the wrong (ugly) interface.

All we want are per-process stats. What am I missing?


KSM could deduplicate them, the deferred shrinker could remove them. 
Unless both mechanisms are not desired or are ineffective for another 
reason (e.g., page pinning).

-- 
Cheers,

David

