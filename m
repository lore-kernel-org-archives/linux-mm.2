Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 37DDDE9A03E
	for <linux-mm@archiver.kernel.org>; Tue, 17 Feb 2026 20:29:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6874A6B00A3; Tue, 17 Feb 2026 15:29:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 635396B00A4; Tue, 17 Feb 2026 15:29:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 509BF6B00A5; Tue, 17 Feb 2026 15:29:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3A4906B00A3
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 15:29:11 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id CAF8F1C0EE
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 20:29:10 +0000 (UTC)
X-FDA: 84455088060.02.3186160
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id 207F614000C
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 20:29:09 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=DzqZia3n;
	spf=pass (imf26.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771360149;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7WCESJSbY9N2dO2UAxDeDl2USAxOA6BbU696flxTd7A=;
	b=wgnFO85mFH7GnnpYN32BwteNx/SCNJlCTqgRBr2BdwKiHzo6WyT8AKWdlaZORjCdnmGb1A
	uqu2RHdotkrmS9acCPeRBg2M4BCz7a6NRiaz6/oLVzUNgkB04WXpAvkGW59JuvWcaI4RLv
	dpe+jRE374YR/mvFxp7n8ZfJj/+8uK0=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=DzqZia3n;
	spf=pass (imf26.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771360149; a=rsa-sha256;
	cv=none;
	b=u7vhShylX17mudyE47Z7qdIUPtAMu1FfdmPJnROb8xVzkUThTE+WooOyWgB4UgKRdZBttg
	j0ibr7DEBpWgv2OOK7Mh9nVVMDaDw+XFN4QqqmrQ59slifU21gh+bH4Yrl1QAoP90HKo3F
	KsgaahFXRNIPlcVdf7Qdqxew7bX1YhI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 7A1CB60053;
	Tue, 17 Feb 2026 20:29:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63F1DC19425;
	Tue, 17 Feb 2026 20:29:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771360148;
	bh=galDsGJIDowpQEwDMBvPkSWhLfNMwM+9UqHQmmxkw6U=;
	h=Date:Subject:To:References:From:In-Reply-To:From;
	b=DzqZia3nlIi0O0fad+QBa4AqAo8vQWRTVvnHJhdS3cosLARHKY6/9a9UtBr+MDbLL
	 1fjob+YIkLg411pUQEci64PNmZfAdMb1+GMtbsnE92FuNZDR77xwNMy1s+blKy6Z2o
	 fHO6H5xdYn81X5vQK8Y5YKWEVzLJW3l+G20geIA1rDg6V1NrVglwUa0EEa8HkDP064
	 IqoQ6sUD+bYDAkf3Twf3G88S18HSOESBgB5R3fWLG7bgIHXn+iNs1Cxd1JMBATRvvf
	 P7HrdY4VBkZxZbJI9r9yI5o0JaZ4bd0Wxz4oRRW8ddITv/CtDiPpT9P9WNHrJK4P2f
	 l8+1lX+D/q6mA==
Message-ID: <419053a2-9784-4051-b73e-5871d3c32be9@kernel.org>
Date: Tue, 17 Feb 2026 21:29:02 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: Add AnonZero accounting for zero-filled anonymous
 pages
To: Wenchao Hao <haowenchao22@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Kiryl Shutsemau <kas@kernel.org>
References: <20260214084514.2842745-1-haowenchao22@gmail.com>
 <CAOptpSP1zx1akeGkZEuPBx1Fk8uz8rs4_m5c55GwPUROmCGxKg@mail.gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <CAOptpSP1zx1akeGkZEuPBx1Fk8uz8rs4_m5c55GwPUROmCGxKg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 207F614000C
X-Stat-Signature: f35mk9h35bzizbatbfijd7wknt1jppb9
X-HE-Tag: 1771360148-480338
X-HE-Meta: U2FsdGVkX18MYFo2rv2UFQlPU8qkugCWBmelm4JKmqJYR3+SFrS7NEjUu+KInOmm2K69sZ5f/1FWMiKHBmCh6N56WL0CEtyBAkkENhjrfp4BNGSPMycJN3fuB3wdb2E/EV01kSIoXO8NlPW+EC00G4iIHuxpRePhN1WuqLKWixjYZS80Fkfa0thZqidM7tBa5JmfRqkCnE6D5MuGDsphZyRRVzuGamqtHdCjzKxV1JiLrRaiZFZyoCjswjARR/xkvFhbAsVtYV84JTjrXw/vVHRRYVIHdaKus6ETswplNr43596vPama3hvQBZ01aj9n+9zTgxcRSBuHN40KTodjJ+X7RoDZ5uvLYG4Ic+qMiFpE7LzSat4Lfju339fOVw8WCmh56byV3CjfClN6hiPoxiySdECxUTainWqZ1EaEbB0MdMOC00nT7qq7wDwmVVgZDOPjrye/MHeA2qkInZnThFZwZtL/9nAaFj53utvVzg37nuVLZXNnIZsA1JdQXjHyDOHNlxuwzioU1GyGWaYRuK6IDEa+fNHj5BdHrV2rjNu8fQpusYJ+pfLrmiMpdCnvFvyi7qP+I3wfkMA0OJyxeAtiK+Z01iird5/+sDVRhzc4cU0vQixA008T9V4+TQJcKATgnc7Fk+6Z9k41pUpXCn5o0v5RBctF/QUQv3+tt/GvXlKyprBj8mAVKJ6oDq2NSh5rpbNanJPpEINcHBpoLFtdkx+D2UiZEJ1PbxPFYlQ+TsrTAe9nalDqLdD/pPw93LocH61zbsHf3DhjJ1hDecE8TixmyU5QC3YHyRV/Jg2F2Lo0OJs75bO1tGvQhfcMngH5Mop9KuO0FzE3hTbUgoOqE44UZLjD/ypSNNn1eYTFCI8qvAYL4W82AmteURB/YBwlxxJ0K6svWJrjNojVrnTpAyDFrodFxfFhMorjHqvzwvgfq0LAii4Ruupq6EkbPhL+zyswk1n7YRTyg3U
 721J+tNp
 VO31xDFV44bD+mmneFVaMB9KrLr0zdCRl0zMAOJxYlgA0HOEsGxlPpJ2vJQpVEAZ77MBR8Zc+xX40x4kg61YiokkcaJ+vThWxAMqczww1z4uh34wGa6KsORRjMwbOzpzGNpjdXOnduHlR5LWvC73hsm+sudRyD+ZcPVhgRDM6x0j85tfakqhamSuHJAADKfnmLy93rBEDsL1Di0JepMN8ug2Xoq71UOvB15agDp25c5tSAA5QuWHf/nvTyvILxOBwT5C2CkgKld+pdh+mRRxKj0EQ2pbaJoxApVhI8zM8o+Cc8w6Kn2ruALTARBM9YZ9BuUOkjGGrPdh4yKI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/17/26 16:22, Wenchao Hao wrote:
> On Sat, Feb 14, 2026 at 4:45 PM Wenchao Hao <haowenchao22@gmail.com> wrote:
>>
>> Add kernel command line option "count_zero_page" to track anonymous pages
>> have been allocated and mapped to userspace but zero-filled.
>>
>> This feature is mainly used to debug large folio mechanism, which
>> pre-allocates and map more pages than actually needed, leading to memory
>> waste from unaccessed pages.
>>
>> Export the result in /proc/pid/smaps as "AnonZero" field.
>>
>> Link: https://lore.kernel.org/linux-mm/20260210043456.2137482-1-haowenchao22@gmail.com/
> 
> Sorry for the late reply. We are now on Chinese New Year holiday, so...
> 
> The original goal of this patch is to measure memory waste from anonymous
> THPs - pages pre-allocated on fault but never accessed.
> 
> On memory-sensitive devices like mobile phones, this helps us make better
> decisions about when and how to enable THP. I think this is useful for
> guiding THP policies, even as a debugging feature.
> 
> Let me summarize the discussion so far:
> - Matthew Wilcox questioned the value and raised concerns fork but haven't
>    exec path
> - Michal Hocko criticized the inefficiency of scanning zero-filled pages.
> - Kiryl Shutsemau prefers a system-call-based interface.
> - David Hildenbrand acknowledged the value and suggested implementation
>    improvements.
> Please correct me if I missed or misrepresented anything.
> 
> I suggest we first agree whether this functionality is useful for upstream,
> before discussing implementation details.
> 
> Reasons why this should go upstream from me:
> 
> - Anonymous THP can introduce real memory waste, but we currently have no
>    good way to measure it.
> - With accurate metrics, we can make better THP policy: disable for
>    low-utilization cases, or early-unmap to relieve memory pressure and so
>    on. This is especially valuable for mobile/embedded devices.
> 
> Possible implementations:
> 
> 1. A new smaps counter (default-off) to count zero-filled pages.
> 2. A new madvise command like MADV_GET_ZEROPAGE
> 3. A dedicated system call

I understand Kiyls point about smaps providing too much information 
users might not be interested in already. So sorting that out might 
provide a real benefit to other users that are only interested in 
specific stats (e.g., Rss).

Providing a system call where one can specify/filter in theory sounds 
like a good idea. A syscall implies that one has to write a tool to 
obtain these metrics.

The nice thing about smaps/smaps_rollup is that it can be easily 
consumed on any system while debugging.

I wonder if there could be a way to achieve something similar with a 
file. Likely not, but maybe someone reading along can surprise me :)

Otherwise we'd have to go with a tool.

-- 
Cheers,

David

