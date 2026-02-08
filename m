Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 30BC2EF06E3
	for <linux-mm@archiver.kernel.org>; Sun,  8 Feb 2026 09:32:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 545496B0089; Sun,  8 Feb 2026 04:32:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4F2896B0092; Sun,  8 Feb 2026 04:32:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4043D6B0093; Sun,  8 Feb 2026 04:32:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 3013C6B0089
	for <linux-mm@kvack.org>; Sun,  8 Feb 2026 04:32:35 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D1D6FB9CA7
	for <linux-mm@kvack.org>; Sun,  8 Feb 2026 09:32:34 +0000 (UTC)
X-FDA: 84420774228.04.0FFEC10
Received: from out-174.mta0.migadu.com (out-174.mta0.migadu.com [91.218.175.174])
	by imf28.hostedemail.com (Postfix) with ESMTP id D0D2DC000F
	for <linux-mm@kvack.org>; Sun,  8 Feb 2026 09:32:32 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=QzmQj6Kn;
	spf=pass (imf28.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.174 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770543153;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TmASjvYRr/8iOkWpBFHMDIcEFajTddtRmV+cC/u8J+0=;
	b=H3t3ryYTgFNKlOi/hn0n1yUJXid3ci+mb688MdgWF076A3m68dTplF20yEglt8v7gkc41n
	4P8lqMGSg5G/MeWCrN8OjVEQhvxY4UW+Dbi/raT+RcqYLOMWj5t+AEM+0oPN7GidHZYTYd
	eBL27Twgmux2jTlq/TzD7rUG5yOKGUU=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=QzmQj6Kn;
	spf=pass (imf28.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.174 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770543153; a=rsa-sha256;
	cv=none;
	b=2ypsy8UD93d1vSmnMJIOw1HJMBPm/Xi5G9OlpRm0THaeTDWv8rGSfgjsRui1b9ukTzioH8
	ykOynSWDZ0nu8IK96ypLOsck8hmms+HkB7LaoOOMdwqL3sNbwH6D+cltG8SU/x95K1UlMO
	wUzRdgZM00YStyAlpbUtB2rnk2aZ43E=
Message-ID: <9942f80a-5a99-4e43-8053-8e6707c39252@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1770543150;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TmASjvYRr/8iOkWpBFHMDIcEFajTddtRmV+cC/u8J+0=;
	b=QzmQj6KnX3F1OfGkKBEXhavzhDn0k9imbTb9pT7ynRewH4PpjHDeHWtodwzJgMvPHxCnXo
	2IWxeXF1lTnInzvtBSwtl5H2v5K7Fduu/DK7RbUkYgFR2xbpaRHCcm3Tqsk38aK0CEu+qL
	5V919FzBg0utsAxp+M424qUGfw+4zAU=
Date: Sun, 8 Feb 2026 17:32:23 +0800
MIME-Version: 1.0
Subject: Re: [PATCH mm-new v6 2/5] mm: khugepaged: refine scan progress number
Content-Language: en-US
To: Dev Jain <dev.jain@arm.com>, Vernon Yang <vernon2gm@gmail.com>,
 "David Hildenbrand (Arm)" <david@kernel.org>
Cc: akpm@linux-foundation.org, lorenzo.stoakes@oracle.com, ziy@nvidia.com,
 baohua@kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Vernon Yang <yanglincheng@kylinos.cn>
References: <20260201122554.1470071-1-vernon2gm@gmail.com>
 <20260201122554.1470071-3-vernon2gm@gmail.com>
 <fd67a91f-3930-4bd8-886b-13f7783f4aec@kernel.org>
 <CACZaFFNGFWv3FG8spJDLfLTe=0QWuBWL+Lbs+W3h9vGL=jrT6Q@mail.gmail.com>
 <85e8ded9-a9eb-4663-9c96-93af60006fb6@kernel.org>
 <9508744b-e5d5-49ef-825f-eef683892541@arm.com>
 <1a6d8295-e27b-4440-a367-af0432a7af4f@kernel.org>
 <6zltgzs24wpypzu36ldwgtzilhv2z3ofuu45azp5u45huiwqvj@6jhhp5r24po6>
 <78b9bb1c-21aa-435f-a697-ebbfbe604a5a@arm.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <78b9bb1c-21aa-435f-a697-ebbfbe604a5a@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: D0D2DC000F
X-Stat-Signature: 1j8b6ny5u7stfh6xrtqpya6ew4ix6wa5
X-Rspam-User: 
X-HE-Tag: 1770543152-853504
X-HE-Meta: U2FsdGVkX18iCevsPOnRiMPwYP4iDF0aVLreLEznnW2kL3YCCP+FDt+ZVTT/HYuw25qkPN+5wt/HgBTbSNEwDNPHmVLlTZeKV3+kLsW00BtVF+0WyUn6FrOwswDE4Cxt0qyGCO6vIDOK4l3syuR5ooZTEjf05XDuF4mFTYVW62FQ252ThZJVYerBrYIx6GOJvOxbxIuIxBtztXcBmNCjh0wB6o6ey1IJ+jloxhv3TkAUpl4CKzrWuDOkhWmmyxvpECVfqcQt4rRdypxPL6cLQoLNz+44s1+bYgCTfLlr2CEu6DQJTLn761UEa7yYbczgNOdMQ5YDJ/hjVZTwtOTtk0xsCbg+EbdMmjGJiKs4MprVfRSMCr1QmO2/cobS7t22KuqTGBRr9T5Nm6Tck2yTmf8rVJMe819Th3+clxMFNdCeFDPA1D42Dvi3dEetQ7hOyLXDxPDEH7cY3kVKy0XTvf6swAI8JmBuhZO2u0td1GKZfGSPisD4CU4AEMeNpzFSIrmuOVROWGUor8dUZTKFRZbQpFw0KHvEavHgOUcCDD2xjJg2REbfuZqv3VbC+mXUn+ttfMJ2dQXoBc1ed3Xe1hA2ZMuftQ7GMCQYUa9Xp/zgfmYB+wuZYYswRGORdsRcG4fBo2IeoVBXZqWbRpfBKNX3CO+UhQ6FUOFuJlnbHE4azfCihcY/5qoEa2oZowSVHbqnqgNowrx9j2aHtAgPEEDgXuRv+WlSlP/wj7Wc9DgdBAahySuKgG3hZ8D8Zn/jorr5SD3Sl/IwnJmUok8TrFFaVGi1PqB78M3isirLFGV1JQbxjBz9wEMjfRGLkkKGa/mmMle4X3O35bSKFFao2AB0ZQJ5JXR4/SbUliYeL4Z3yJLZxV09p0PJZEkDlcB04BRrWCLUuaOPfsTAeJWYWoRe6P8r3ACniYTZMdVAMX5rLmMXv0BxQUSapwe4QKo9Ya8RoQHpuvqCzADUSha
 omf3p79f
 NO9YM4RovjzS673nH23sG8PHQkE+OIDOcVerbf/078z5Psk+xJQw4jBrRsh0KiQNEWw3ekSciKQ/jUSQk8sMMejuIUw93d/SPLFPtlX/4BvPZ6fqeBUd9KGyZhxh2ODvrwZK44OVFHvdYRwNdzwM+z++jPjisEU4A+rgfFW07Xx0E8G4Jo0IY8txEbnUVOoXPJKZ9mHHEmQnvty3wcK/VJH9lREeK3kne5Foh2RUKM5/pLuzi2f1GlpxeoZxH5UNRN0+P
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/2/8 17:05, Dev Jain wrote:
> 
> On 06/02/26 4:42 pm, Vernon Yang wrote:
>> On Fri, Feb 06, 2026 at 10:02:48AM +0100, David Hildenbrand (Arm) wrote:
>>> On 2/5/26 15:25, Dev Jain wrote:
>>>> On 05/02/26 5:41 pm, David Hildenbrand (arm) wrote:
>>>>> On 2/5/26 07:08, Vernon Yang wrote:
>>>>>> On Thu, Feb 5, 2026 at 5:35 AM David Hildenbrand (arm)
>>>>>> <david@kernel.org> wrote:
>>>>>>
>>>>>> I guess, your meaning is "min(_pte - pte + 1, HPAGE_PMD_NR)", not max().
>>>>> Yes!
>>>>>
>>>>>>
>>>>>> I'm also worried that the compiler can't optimize this since the body of
>>>>>> the loop is complex, as with Dev's opinion [1].
>>>>> Why do we even have to optimize this? :)
>>>>>
>>>>> Premature ... ? :)
>>>>
>>>> I mean .... we don't, but the alternate is a one liner using max().
>>> I'm fine with the max(), but it still seems like adding complexity to
>>> optimize something that is nowhere prove to really be a problem.
>> Hi David, Dev,
>>
>> I use "*cur_progress += 1" at the beginning of the loop, the compiler
>> optimize that. Assembly as follows:
>>
>> 60c1:	4d 29 ca        sub    %r9,%r10		// r10 is _pte, r9 is pte, r10 = _pte - pte
>> 60c4:	b8 00 02 00 00  mov    $0x200,%eax	// eax = HPAGE_PMD_NR
>> 60c9:	44 89 5c 24 10  mov    %r11d,0x10(%rsp)	//
>> 60ce:	49 c1 fa 03     sar    $0x3,%r10	//
>> 60d2:	49 83 c2 01     add    $0x1,%r10	// r10 += 1
>> 60d6:	49 39 c2        cmp    %rax,%r10	// r10 = min(r10, eax)
>> 60d9:	4c 0f 4f d0     cmovg  %rax,%r10	//
>> 60dd:	44 89 55 00     mov    %r10d,0x0(%rbp)	// *cur_progress = r10
>>
>> To make the code simpler, Let us use "*cur_progress += 1".
> 
> Wow! Wasn't expecting that. What's your gcc version? I checked with
> gcc 11.4.0 (looks pretty old) with both x86 and arm64, and it couldn't
> optimize.

FWIW, 11.4.0 is newer that the minimum GCC version (8.1) required by
kernel. See Documentation/process/changes.rst

The optimization might just be version-dependent :)

