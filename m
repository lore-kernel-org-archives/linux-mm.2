Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6AA30D35162
	for <linux-mm@archiver.kernel.org>; Wed,  1 Apr 2026 11:51:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A07056B0005; Wed,  1 Apr 2026 07:51:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9B89D6B0088; Wed,  1 Apr 2026 07:51:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8CDD96B0089; Wed,  1 Apr 2026 07:51:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 7D0FE6B0005
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 07:51:57 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 0B7EA5B391
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 11:51:57 +0000 (UTC)
X-FDA: 84609823074.06.F924AEC
Received: from out-183.mta1.migadu.com (out-183.mta1.migadu.com [95.215.58.183])
	by imf23.hostedemail.com (Postfix) with ESMTP id 8517214000A
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 11:51:53 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=aQQFE9SZ;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf23.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.183 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775044315; a=rsa-sha256;
	cv=none;
	b=lG+B7L9jS8DTOqhUASq0xPQfcRM5g5WrfWoecjNfwSaSNE5IqejYw99P8mjUGjSQYHDM2F
	rzjGIg/3fJzviu3pa3u8C3zEdjUdxmT6aFqz/wKDVwLJwcCIkaBJwvWvaOgT5kn8kSdh3n
	8H0SM8MxKNqw7GgP5eUuQBXDsIjRi9I=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=aQQFE9SZ;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf23.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.183 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775044315;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uLlhZc+mP4ePWpjvv4aWNtQSAr/NOqK11GS/RTSR+bY=;
	b=iqV56qPn/Drm47sHmzq1NbXjinOhTlm7I52oSgycyGL+l2+sddIoL7ZcjV0zBZxHku1zjy
	9RyrQvUTWD0mSZlsbXyfITY7wO9B5vWB06X4TonWBpBxowLyJeKNSHHMS5TvBzaCtqdRFH
	3U/z6pUmBEjwJHV3q/1lCgbr5OFDxpM=
Message-ID: <c5d01704-9035-482a-b562-ef5a0c163d4d@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1775044309;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=uLlhZc+mP4ePWpjvv4aWNtQSAr/NOqK11GS/RTSR+bY=;
	b=aQQFE9SZOw0V8amtAysnp2bzjbgDyyNUV8od9WfM/XRPSxBEnk5xFUK9/Hak+lMwYUtLnf
	YQf1njE76/9Dl+/mFihl/8m+qXKvr42uEpKPZHrKaL7uyzf/f5ajHKHYgvUlyXVKNh07e0
	TdE3TY0OD+0PO1l1PC7r+DWOBIEQT3Y=
Date: Wed, 1 Apr 2026 19:51:38 +0800
MIME-Version: 1.0
Subject: Re: [syzbot] [mm?] WARNING in deferred_split_folio
Content-Language: en-US
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: kartikey406@gmail.com, usama.arif@linux.dev, Liam.Howlett@oracle.com,
 ziy@nvidia.com, syzbot+a7067a757858ac8eb085@syzkaller.appspotmail.com,
 akpm@linux-foundation.org, baohua@kernel.org, baolin.wang@linux.alibaba.com,
 dev.jain@arm.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 ljs@kernel.org, npache@redhat.com, ryan.roberts@arm.com,
 syzkaller-bugs@googlegroups.com
References: <38a347dc-8a1c-4d04-926d-7a6318e93ca2@kernel.org>
 <20260401113434.29369-1-lance.yang@linux.dev>
 <cc8a2d06-c774-48d4-af8a-905126dbd588@kernel.org>
 <7176f8a2-8830-4fe9-b00e-fae67e2ac81d@linux.dev>
 <70576b00-6210-4eec-aeb8-69a74cca27d1@kernel.org>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <70576b00-6210-4eec-aeb8-69a74cca27d1@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: 81x3br7iygnnstjyiqbdhrbgqyrw31tn
X-Rspamd-Queue-Id: 8517214000A
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1775044313-228696
X-HE-Meta: U2FsdGVkX19Ku7Itfo4e9gO3wwmCWW/PQSREvyDjHPfidUO+AM/4/VvE1DPQak+PEq1+cvTZU1ax0ae4MRCJ7fX3F/5Ro6MICs5O8pDVhRgTn0gKFhBG0OeqwBE1UjuoxwQktIV+FteOAoFwcOnmSHnhC+1KofmjCyYgUsElOyDkCojFFHBCUdCaO9yYuXz2v4g31/CFL0+tpM2VQ1lJ91x5GLB2/fC/5mQhLAElG6djPrMcXFDisC9cTFIpJE7D0Ww6k7lLg3cyNgNtRsSb26pAF2Jt7VmlLsF57rrViFQZKTDrHDylwaRS8R8KlW7/hbS9pNpmJAE15pS1zYUoKMxwBs+YauYtl4Ds/SCbHT2IwAVG37VEitEzhco8wzdesnNppnF5TWiPY2oWwsxGHdnTZh76UgwetkTCEqv5qZfrouw8Wn/397SlGzsEN2hWyTdqk6dgXkW3k4oQa0bunbu8EwNfFGmjPR66BtBFFTKQQY3fOhRqGiOW3PA76iSItpPzKkbI7YRBMp+YhagWdAmqSMRtURiyVTWWOJ08/qj8zTax4sbQ4qAfosry4OfGqK9RI4mErQkeWpioXuoh9d6gCI6mECPFKbH8ZLTPETKUPaTYLBc4a6rx8JPZjupNF8U2U7fnONGoz6FhSCTbnRwlQSq7snpiUiPNJo7R/YkWZq8UIDE8SQoEaRWTwQXbZP2TmVZ0YHPI5k4XTu99cclIC2duW3b+7FoKTXYu1nap//KMrGfQy2ChJWTKj/b4g08qReVXH0CGDtP4Csce3PEG1gTfWQtawbWLzyGKUhbyDsY7L8WHLm6QeVk3oV3mg0GRdSIYIiQIODc2DBf1kirHZeG1hy3hzpMAWGIlpEjsPX9X6fuhpRs1Zdw6xBriL4egWMGGNP9Y7ysJyys3sdsSnfuZ4AmcvE1Ct2fZ+yAN5v1feLaHrmUvahKOGqq3tAh+VknMWNNSH5na0+G
 onMr+Hze
 Nth2X1XrbxhwKCZpIC8EyEwOt/JgmJOHoxKALdu7Bs+1TwJ1w96CEEhzP/uZOzHAJTe5XOIDipaSQzqWhjFKX8oO355TbrTDtzG1jbAs6C9o/kYTQCpdUhjy+5tz8p/JpxDdKMRo/wwgbl5mr0Zp/7R7NQ+YOAQsN5/pLLCa3Y8ViPIP57UVaRwiPt+tRWXQigbh7u3zdNwo206/AQ4WS8u/udbjkMEchdzPZgSNeYPtsYRwSgbVTqWQZFNVtxZq87/nWuR+d0pj8lw45bZufeetYFfGl+XBiGYtpVfYnzx35kj6ElkStJtgI1b9vzxnDKju/TKclzNFNfZh5QS4oZtaPWMWP6/RC/icndEPHF3Z2YNu3VeV/CPqrdFLBdWfyZD/v9xek7HEHpsCSPWHRDY4zEQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/4/1 19:44, David Hildenbrand (Arm) wrote:
> On 4/1/26 13:41, Lance Yang wrote:
>>
>>
>> On 2026/4/1 19:38, David Hildenbrand (Arm) wrote:
>>> On 4/1/26 13:34, Lance Yang wrote:
>>>>
>>>>
>>>> ACK.
>>>>
>>>>
>>>> certainly, will do! But commit[1] ("mm: migrate: requeue destination
>>>> folio on deferred split queue") is only in mm-stable now, not yet
>>>> upstream/stable ...
>>>
>>> It's tricky. The original commit will be backported to stable kernels,
>>> so we want also the fix to be backported to the same stable kernels.
>>>
>>> The commit id in mm-stable is "stable" now.
>>
>> Emm... Not a big deal, I guess. We can always submit a stable backport
>> once that fix gets merged into stable :D
> 
> What's the problem with tagging the commit right way as Cc: stable?

Sure, that makes sense. I'll add "Cc: stable" to the fix as well, so
it can follow 8a8ca142a488 into stable ;)


