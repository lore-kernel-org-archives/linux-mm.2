Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0701C83F1A
	for <linux-mm@archiver.kernel.org>; Tue, 22 Jul 2025 02:33:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 865566B00A4; Mon, 21 Jul 2025 22:33:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 83D8E6B00A5; Mon, 21 Jul 2025 22:33:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 753816B00A7; Mon, 21 Jul 2025 22:33:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 66D756B00A4
	for <linux-mm@kvack.org>; Mon, 21 Jul 2025 22:33:34 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E0527578A6
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 02:33:33 +0000 (UTC)
X-FDA: 83690329506.08.A0415F1
Received: from out30-119.freemail.mail.aliyun.com (out30-119.freemail.mail.aliyun.com [115.124.30.119])
	by imf18.hostedemail.com (Postfix) with ESMTP id 154471C000F
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 02:33:30 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b="HedIRV/j";
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf18.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.119 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753151612; a=rsa-sha256;
	cv=none;
	b=bteyWHbGMir9RIYiPSkGtXjAp4Sxr7xNjreXvRSLtDQ8fJmx+IqE1fMUXCuBbr3jOCvskV
	8O+StToaQNVh0zgAqdOZm7eENhqfmO425UTH/b94sA7tIgSUmnF8UCESu7qj36NbGS6UWm
	1CCOZC0co/MqvuhLm0MlrEUSRJV5PgU=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b="HedIRV/j";
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf18.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.119 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753151612;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pWXVyeKGfLMQnpoF8/uk15LxfELGiJXWnze7SP/0X5E=;
	b=6V/H7N+ao67T6rF1jaxq90AwCcld2GcOYvf/Tyjlsq/YWG6Cj0XcsmiKXHWzljFdA+ROQh
	hZrB6yrBCMm6S0rSUQQA5+Z8Zk3lyCX4B0lPrMkhM1pAR1Rcfl3+6JuNTFklWMGAQiYAgi
	8nCb3hMxQoNP4c3DWSiRnc+TsOfAi+U=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1753151607; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=pWXVyeKGfLMQnpoF8/uk15LxfELGiJXWnze7SP/0X5E=;
	b=HedIRV/jnQpTthoSwqjT20Y6Yg1SSew3b9YotwZ4vOmKI0xcXSeHQpx7tqEg9DVePJ4suskt8PhJBCDjNIOc5z1JtqmyeeF8/Dc+OVAAdaa63VyJIW0znai1zmU2qHPZwplDccnPBvZcgcnDeDHxc0fLJeiVP34+7SsqlBoPngc=
Received: from 30.74.144.108(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0WjTwAqR_1753151605 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 22 Jul 2025 10:33:26 +0800
Message-ID: <a7062d0d-804f-4b9a-ba7f-62d67064c584@linux.alibaba.com>
Date: Tue, 22 Jul 2025 10:33:25 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] docs: update THP documentation to clarify sysfs "never"
 setting
To: Barry Song <21cnbao@gmail.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@redhat.com>, Zi Yan <ziy@nvidia.com>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>, Nico Pache
 <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Jonathan Corbet <corbet@lwn.net>,
 linux-mm@kvack.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20250721155530.75944-1-lorenzo.stoakes@oracle.com>
 <35df32ae-dc95-48e1-bdb1-90f17bfd4d5c@linux.alibaba.com>
 <CAGsJ_4yMLi_+yxJYebTbEALujcVmeqbfHh=ArkZRxMwE+OBWgQ@mail.gmail.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <CAGsJ_4yMLi_+yxJYebTbEALujcVmeqbfHh=ArkZRxMwE+OBWgQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Stat-Signature: gdto1isjwj1fswd3tsg51644r88s9ske
X-Rspam-User: 
X-Rspamd-Queue-Id: 154471C000F
X-Rspamd-Server: rspam02
X-HE-Tag: 1753151610-446335
X-HE-Meta: U2FsdGVkX19ENfTIMNsbaOgMwlLUzaCYQxqYpWD64ZAfuC3325l13J65ui3SDuFUTtvQqXD9Pa6FfGO51yLlwCO0C9zyOPDStR7nG59ACAzTS5N+5IWZqh5D2lB50/Z/kapk0HWWLZ80dEuugTTb/01USR9cLNBLTKL0oW5YqssatBwkPUqWm7UCETzfbsoEMkGnektMOubmWX6kbAtO1irsSOwNDKhaEc5inMHYJOtID7ENvXtZW/nKNQWpbXVjXmS9yvwM+2aahoragJ9KIb/jRR6mPNrb3fixcQp+TEFzv6TdJSDn5YmUG6ilWU3M4a9W6gufcZxPwXTv9IVCOpZo3sIl9nKUcuN33Ya3z114QRKOHlur4w1LfBkT4YwVoEvs4NYG12iK73JfzLpSu+L8U1V5YoOnTkR8UYDfLGahB2EXWhqv0rEjK4Ba70BwUUxAbhAVP2c7TY90Cxjwfxe09+xMOoeoBpMTHuLkYqxSi6mNXakYv+l1qwTLXdiu3plS/UummKZ2te8yCHMYj1IE3cy2QaF5v0rTjI/0lwHTUELHUrFl9NJJAh3t9lp0gYLu4gXRDIYhppTewFv6s86B4Qd+BeaoMHMkVUQBIys2LWIAiAVntbdZz+H4bpIzwDhi2TXGFt90jA2EQwybVcgGEMGDt0yU/6EgUiMMnCRccdFczwjTIwqv60OSM0CQjUWskHQvKnbf2VMWWlXk/5XpdbO+ErE/9VPE6axASMGNLNigcJvEcJyzCmEcyPxnlVz2r01Q32/2yM5cB+kD3pgki1tAUiis8XhepqHx8OYkKexhX2Py9XrvJ2iy8YGRHKBPMkPw0Mtimm5z3vbgXgUZWxUiOyQyRVghCWWP1nQolWJCh0SxBWdrfTB6fNZLZdVAgEVdPfAYrtLomgSTyFV9K/Z8JYz0wYx/TbwE4S2juGTGJb9pW88V0pqq0Cq5srpk2PVI5wOmRtHYaVM
 hmlSEsWD
 ybvNuKRpjXJA/mtCZqi8IOGWzANXgKCZSD2pRWnPwgktOYHyRFx1Ed18iTHX02fcGX7HcK/r3NJZUZupa5AbufT2k1S6yr7oXC4O6CsAL9VZFdvlaw1TNKPpegIeSiyKD8z6va6GXwvy+mYPnkNzjkUWxCHV27oTmv+I0nJ8HUQjdHld2kk94L7M709c2ZtdkMjw+adcuQyX8P9NAGIHKkGeKs5+JUFMGu0HLzyPbSVfJVc0kX0FaAmru6fr61XvD92QqKKzbuH7iDtXkVpprHHs1hJTPumaUe7CPK+UDL/JGL66LKhJ8f6CxcnXIJRouz80A6NfmXHU33K+2t5+WKTFOtkE7DDG2y77xiLmfr7AilbOfqTwEJmToNZO0plykmykdNoJiNq6mR4Uo9N3BOoeFrQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/7/22 10:23, Barry Song wrote:
> On Tue, Jul 22, 2025 at 9:30 AM Baolin Wang
> <baolin.wang@linux.alibaba.com> wrote:
>>
>>
>>
>> On 2025/7/21 23:55, Lorenzo Stoakes wrote:
>>> Rather confusingly, setting all Transparent Huge Page sysfs settings to
>>> "never" does not in fact result in THP being globally disabled.
>>>
>>> Rather, it results in khugepaged being disabled, but one can still obtain
>>> THP pages using madvise(..., MADV_COLLAPSE).
>>>
>>> This is something that has remained poorly documented for some time, and it
>>> is likely the received wisdom of most users of THP that never does, in
>>> fact, mean never.
>>>
>>> It is therefore important to highlight, very clearly, that this is not the
>>> ase.
>>>
>>> Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
>>> ---
>>>    Documentation/admin-guide/mm/transhuge.rst | 11 +++++++++--
>>>    1 file changed, 9 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/Documentation/admin-guide/mm/transhuge.rst b/Documentation/admin-guide/mm/transhuge.rst
>>> index dff8d5985f0f..182519197ef7 100644
>>> --- a/Documentation/admin-guide/mm/transhuge.rst
>>> +++ b/Documentation/admin-guide/mm/transhuge.rst
>>> @@ -107,7 +107,7 @@ sysfs
>>>    Global THP controls
>>>    -------------------
>>>
>>> -Transparent Hugepage Support for anonymous memory can be entirely disabled
>>> +Transparent Hugepage Support for anonymous memory can be disabled
>>>    (mostly for debugging purposes) or only enabled inside MADV_HUGEPAGE
>>>    regions (to avoid the risk of consuming more memory resources) or enabled
>>>    system wide. This can be achieved per-supported-THP-size with one of::
>>> @@ -119,6 +119,11 @@ system wide. This can be achieved per-supported-THP-size with one of::
>>>    where <size> is the hugepage size being addressed, the available sizes
>>>    for which vary by system.
>>>
>>> +.. note:: Setting "never" in all sysfs THP controls does **not** disable
>>> +          Transparent Huge Pages globally. This is because ``madvise(...,
>>> +          MADV_COLLAPSE)`` ignores these settings and collapses ranges to
>>> +          PMD-sized huge pages unconditionally.
>>> +
>>>    For example::
>>>
>>>        echo always >/sys/kernel/mm/transparent_hugepage/hugepages-2048kB/enabled
>>> @@ -187,7 +192,9 @@ madvise
>>>        behaviour.
>>>
>>>    never
>>> -     should be self-explanatory.
>>> +     should be self-explanatory. Note that ``madvise(...,
>>> +     MADV_COLLAPSE)`` can still cause transparent huge pages to be
>>> +     obtained even if this mode is specified everywhere.
>>
>> I hope this part of the explanation is also copy-pasted into the
>> 'Hugepages in tmpfs/shmem' section. Otherwise look good to me. Thanks.
> 
> Apologies if this is a silly question, but regarding this patchset:
> https://lore.kernel.org/linux-mm/cover.1750815384.git.baolin.wang@linux.alibaba.com/
> 
> It looks like the intention is to disable hugepages even for
> `MADV_COLLAPSE` when the user has set the policy to 'never'. However,
> based on Lorenzo's documentation update, it seems we still want to allow
> hugepages for `MADV_COLLAPSE` even if 'never' is set?
> 
> Could you clarify what the intended behavior is? It seems we've decided
> to keep the existing behavior unchanged—am I understanding that
> correctly?

Yes, Hugh has already explicitly opposed the current changes to the 
MADV_COLLAPSE logic[1], although there are still some disagreements that 
cannot be resolved.

At least we reached the consensus to update the documentation to reflect 
the current sysfs THP control logic first, to avoid the misunderstanding 
that 'sysfs THP controls can disable Transparent Huge Pages globally'.

[1] 
https://lore.kernel.org/linux-mm/75c02dbf-4189-958d-515e-fa80bb2187fc@google.com/

