Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3FA96EF06E2
	for <linux-mm@archiver.kernel.org>; Sun,  8 Feb 2026 09:05:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 106EB6B0089; Sun,  8 Feb 2026 04:05:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0B5366B0092; Sun,  8 Feb 2026 04:05:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F02F66B0093; Sun,  8 Feb 2026 04:05:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id DCBDD6B0089
	for <linux-mm@kvack.org>; Sun,  8 Feb 2026 04:05:20 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 7B0BED5F7C
	for <linux-mm@kvack.org>; Sun,  8 Feb 2026 09:05:20 +0000 (UTC)
X-FDA: 84420705600.18.371F373
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf14.hostedemail.com (Postfix) with ESMTP id 95066100003
	for <linux-mm@kvack.org>; Sun,  8 Feb 2026 09:05:18 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf14.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770541519;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QJA6wXQCKXrTREPUSprJrSBZffzBC4OBjqTIpe7vjlQ=;
	b=DmCWb0sNOhmg0+uSIO2HK//mkCO+kSBijGKdm9Z+tRfE8Hw94vf2yb6hH2OSpntUzk5W26
	jIqrWfmFl57dgcuztxzDQBNmgbvmxyx3Eruob9e1a8UMRH+2c0xUwACQICe0JPJEWBv8G1
	kQ1PjXetj5gFiYsjWAmadxlwJEvnebs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770541519; a=rsa-sha256;
	cv=none;
	b=aWMO6X1L83Wd3rhJzfiDSweWh0OTbkvDWg6CRtJdhSifpgmjY7TIS56YYi+DbF7LKQVMWh
	eyv/V195Kg568SSiZD01GsTADcAu1jUuZnqj4CgkRPwcE4gzmKWTXK2j3uUAaODS/aIOKH
	YRZYFXNPX0fye8OLrXC6XsTKvuDnj1E=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf14.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2A319339;
	Sun,  8 Feb 2026 01:05:11 -0800 (PST)
Received: from [10.164.10.250] (unknown [10.164.10.250])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 862A53F740;
	Sun,  8 Feb 2026 01:05:14 -0800 (PST)
Message-ID: <78b9bb1c-21aa-435f-a697-ebbfbe604a5a@arm.com>
Date: Sun, 8 Feb 2026 14:35:11 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH mm-new v6 2/5] mm: khugepaged: refine scan progress number
To: Vernon Yang <vernon2gm@gmail.com>,
 "David Hildenbrand (Arm)" <david@kernel.org>
Cc: akpm@linux-foundation.org, lorenzo.stoakes@oracle.com, ziy@nvidia.com,
 baohua@kernel.org, lance.yang@linux.dev, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Vernon Yang <yanglincheng@kylinos.cn>
References: <20260201122554.1470071-1-vernon2gm@gmail.com>
 <20260201122554.1470071-3-vernon2gm@gmail.com>
 <fd67a91f-3930-4bd8-886b-13f7783f4aec@kernel.org>
 <CACZaFFNGFWv3FG8spJDLfLTe=0QWuBWL+Lbs+W3h9vGL=jrT6Q@mail.gmail.com>
 <85e8ded9-a9eb-4663-9c96-93af60006fb6@kernel.org>
 <9508744b-e5d5-49ef-825f-eef683892541@arm.com>
 <1a6d8295-e27b-4440-a367-af0432a7af4f@kernel.org>
 <6zltgzs24wpypzu36ldwgtzilhv2z3ofuu45azp5u45huiwqvj@6jhhp5r24po6>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <6zltgzs24wpypzu36ldwgtzilhv2z3ofuu45azp5u45huiwqvj@6jhhp5r24po6>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 95066100003
X-Stat-Signature: o9ci41m8ys7khho8b58141tfqihdxati
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1770541518-361481
X-HE-Meta: U2FsdGVkX1+jiCpYf/iwNp8zoww49YoE2Iok/qqP++I6p2cC1FsnA3aQjkziK9zzFG1HsLUG1uT7pN91V6mh44nmP4tabYh8NbZHU16Bb0en5E0rRku5NO+qCg4lyQD/5vNpsh60jvZW2EPhIrGHsmybcVX2oanRqIkBHqKRn2YEC10RPtE2kKg2Eql3ZZntbBstgUlEBDqtGAURtubvfmVDDRN4lPBy2DQ3x7M7X0hDRd7Da/y9L8AuGRuN57YVYrJwpIV+Xedo7WCY5tgBCpatEYymC9gF1NKujjJ1Ufj4b7nVo5EZFcAJGVMqFHrrDzRxknx9jJwTyZCzS9OoDhLkfsWCSK3OQ3BTGUkNUhHKsYfT1Z48Y4xfQUCydWTDUZA67Avw7YS5HrHlseP50BfqQ+L8EKt5tfr7w8oxipDqZHNdMY0KJRKJA0mrmHFa9b7cw3ipKt0irr4FMPC9OSp4HxTc9PE1JLtKvl1VjR1bm9xhToj2g1xkTD5ZwnQ/C+J3Gw7Edo4lHQLxC2PTFqsdlDFyZBuc77KxRglhO//atd39BF21mu1WqxwvpcOgjvC/v6bgjqAu2Jgk8cAR9fUCpctpwCIweZHAyffEas8FzfdtuLLUm2uYBuvG/TQkm4SlXybUB98zQu5r9cNXphoSq9FS71I8T0M8WsLsgCrK/ZPKYliSRy23AQKoM5h9NgqqyLzbNU1IV3EUUjqoNZB6/2o0ik4FA1j5cOAP4cUjUfC8+zekSR3asa0npiiRxTO5VTCEK+K8pr2PxP/TMWMBF0VT+1EJ6vBCYqXUIJV6KAVMfjJsz8FAgUufloQnyhulkTXSlLAHMl+UioONSA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 06/02/26 4:42 pm, Vernon Yang wrote:
> On Fri, Feb 06, 2026 at 10:02:48AM +0100, David Hildenbrand (Arm) wrote:
>> On 2/5/26 15:25, Dev Jain wrote:
>>> On 05/02/26 5:41 pm, David Hildenbrand (arm) wrote:
>>>> On 2/5/26 07:08, Vernon Yang wrote:
>>>>> On Thu, Feb 5, 2026 at 5:35 AM David Hildenbrand (arm)
>>>>> <david@kernel.org> wrote:
>>>>>
>>>>> I guess, your meaning is "min(_pte - pte + 1, HPAGE_PMD_NR)", not max().
>>>> Yes!
>>>>
>>>>>
>>>>> I'm also worried that the compiler can't optimize this since the body of
>>>>> the loop is complex, as with Dev's opinion [1].
>>>> Why do we even have to optimize this? :)
>>>>
>>>> Premature ... ? :)
>>>
>>> I mean .... we don't, but the alternate is a one liner using max().
>> I'm fine with the max(), but it still seems like adding complexity to
>> optimize something that is nowhere prove to really be a problem.
> Hi David, Dev,
>
> I use "*cur_progress += 1" at the beginning of the loop, the compiler
> optimize that. Assembly as follows:
>
> 60c1:	4d 29 ca        sub    %r9,%r10		// r10 is _pte, r9 is pte, r10 = _pte - pte
> 60c4:	b8 00 02 00 00  mov    $0x200,%eax	// eax = HPAGE_PMD_NR
> 60c9:	44 89 5c 24 10  mov    %r11d,0x10(%rsp)	//
> 60ce:	49 c1 fa 03     sar    $0x3,%r10	//
> 60d2:	49 83 c2 01     add    $0x1,%r10	// r10 += 1
> 60d6:	49 39 c2        cmp    %rax,%r10	// r10 = min(r10, eax)
> 60d9:	4c 0f 4f d0     cmovg  %rax,%r10	//
> 60dd:	44 89 55 00     mov    %r10d,0x0(%rbp)	// *cur_progress = r10
>
> To make the code simpler, Let us use "*cur_progress += 1".

Wow! Wasn't expecting that. What's your gcc version? I checked with
gcc 11.4.0 (looks pretty old) with both x86 and arm64, and it couldn't
optimize.

> --
> Thanks,
> Vernon

