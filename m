Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 02EACEE20A0
	for <linux-mm@archiver.kernel.org>; Fri,  6 Feb 2026 13:52:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 30E406B0089; Fri,  6 Feb 2026 08:52:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 29B506B0092; Fri,  6 Feb 2026 08:52:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1C5136B0093; Fri,  6 Feb 2026 08:52:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 09F1F6B0089
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 08:52:56 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 7EA741401BD
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 13:52:55 +0000 (UTC)
X-FDA: 84414172710.10.E9D29DE
Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	by imf24.hostedemail.com (Postfix) with ESMTP id 5937C18000C
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 13:52:53 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=lVArVqdL;
	spf=pass (imf24.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770385973;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JP3JgFFPAC9maJD5a6nNDzrMrZ2Ma5PybmorCwXVQQc=;
	b=an8Q7/f//gnUykIbrdC13L/u0MXH5r2yo9KC/urbil09oFtCFT1YsB60N0kDimnFIQeEne
	S9wZukcpXIc3ese6fZ/Z6GTntLkeliM3KT5io+UtG+M6HSp39iKQrPI5hvJ5KsIsQHe1No
	8MaXdBL0YgxAHFWUYE5qSlKzVy8V5JI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770385973; a=rsa-sha256;
	cv=none;
	b=fF58TtCmFKQ0r1srp3MF4KTYCe5LWtHyq8gNTs9PVzAQEdfp1uJi7N6vjwIFVPSZTm8mwl
	diLE/N3W/s1SZjSp4qFuOM9eBJzcA47Wc1SkX9xjvi501hwf8Cw+tUyFOea0Yh41Wyq0T0
	Bh+8VrzgLfB4X2TnaenGqQu/MSm7CGs=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=lVArVqdL;
	spf=pass (imf24.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Message-ID: <2d2eff81-4f7d-41df-8c56-12a050ffb60c@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1770385971;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JP3JgFFPAC9maJD5a6nNDzrMrZ2Ma5PybmorCwXVQQc=;
	b=lVArVqdLUbAnuy56x5+9azwBkbzri33c/LkukueMeXy8bzb66WP4nLq/ED69UwITa7+pZh
	ratVBLPTpvEG+gMCb10g9qRwqOqT4BaRt+3Rw0N4nHfMUAEmlonB3NGHCFWs09qaXIRmlN
	WQA6so+0GNEqYybG14ycu+vCrPgG1do=
Date: Fri, 6 Feb 2026 21:52:28 +0800
MIME-Version: 1.0
Subject: Re: [PATCH mm-new v6 2/5] mm: khugepaged: refine scan progress number
Content-Language: en-US
To: Vernon Yang <vernon2gm@gmail.com>,
 "David Hildenbrand (Arm)" <david@kernel.org>, Dev Jain <dev.jain@arm.com>
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
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <6zltgzs24wpypzu36ldwgtzilhv2z3ofuu45azp5u45huiwqvj@6jhhp5r24po6>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 5937C18000C
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: 8ayytpshmpuqozfbmj6g5719tfsr4cse
X-HE-Tag: 1770385973-533731
X-HE-Meta: U2FsdGVkX1/tYXJwaL6Hz93klaspnEbl2e1R1psQXtxMjuF2u518U3hdSLp8+zvjSr4Jlg6NdU/Zp52hXCbMEHcXUL5NRxEisWSRxffoZcTs2Hw9vP2TAH0A16VfET6OjPku4bPPup12LbaMD2lHpk9paOLRDqT4p7E7AZeRe6/4YCqjpfAcokqATBY/2IOU95vEMTSXAYZF8YXwoJr/C2N2IAyzy2kD0vtFo4sWNSCVwq9//McoHSv5ztnP3RMAstAEaPwEiDPOc7t6kytvHrBloVer7yrc5cOWg0B2Gikun74D768xgDJsYO0SCiYsIqa3H0aGl/Gfl73kARw7Rw3/BZsND9r51PSqlxsYaY8H/3BP2gZOd2oZObOEugNJzV6TLdj5rkgywQ5EfI5WfgTygQynTv771d1164bhzxD12l9E6rp3BQk0/TH0xBwHh6ePcWPIy9T01S/XqKM13OqeNm4NK0zE0ZsLeH1Sko3URPyZMSjKeurIqYUFeTYhrVDXwLz3q2RsEZhZ0dWoUEQRnF+B/JBo4zXfIYEIwwMoQHMAbQ5Bto4bPDG1rvrFKLeMDYJao2ZGsY4JMGSGx14uX5pUif60quC/NaBB0wM/pWACHDNVJPJKkOPIo68s52DkpPzjwsG+F+PG5znoB3SI/pQRF3aRZ3sC6WJGOxxpIs2db7XRKE5ulVm6B3u4x/NXWOai+iIE0vBNZI+CliMcHHeyyXpg3lgxxRKUdrZS6aU6hCVyqp7ychnV3I2zAvb+IwAGjEDmELl94w+iZV4bsKDx73GEd3cnG0dp3xDbQ2yjAQQj3+tqIVek/0pLstYqOAVljiNYNe3lG79ct0eWW0MxYVhaLpbC/xk/T2oJW9JDXihnSQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/2/6 19:12, Vernon Yang wrote:
> On Fri, Feb 06, 2026 at 10:02:48AM +0100, David Hildenbrand (Arm) wrote:
>> On 2/5/26 15:25, Dev Jain wrote:
>>>
>>> On 05/02/26 5:41 pm, David Hildenbrand (arm) wrote:
>>>> On 2/5/26 07:08, Vernon Yang wrote:
>>>>> On Thu, Feb 5, 2026 at 5:35 AM David Hildenbrand (arm)
>>>>> <david@kernel.org> wrote:
>>>>>
>>>>> I guess, your meaning is "min(_pte - pte + 1, HPAGE_PMD_NR)", not max().
>>>>
>>>> Yes!
>>>>
>>>>>
>>>>>
>>>>> I'm also worried that the compiler can't optimize this since the body of
>>>>> the loop is complex, as with Dev's opinion [1].
>>>>
>>>> Why do we even have to optimize this? :)
>>>>
>>>> Premature ... ? :)
>>>
>>>
>>> I mean .... we don't, but the alternate is a one liner using max().
>>
>> I'm fine with the max(), but it still seems like adding complexity to
>> optimize something that is nowhere prove to really be a problem.
> 
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

Cool! Compiler did the right thing and the heavy lifting after all - we get
to keep it simple :p


