Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E2AB0CAC598
	for <linux-mm@archiver.kernel.org>; Tue, 16 Sep 2025 07:05:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0201C8E0002; Tue, 16 Sep 2025 03:05:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F3A658E0001; Tue, 16 Sep 2025 03:05:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E76E18E0002; Tue, 16 Sep 2025 03:05:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D3EE58E0001
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 03:05:55 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 4FA131A088B
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 07:05:55 +0000 (UTC)
X-FDA: 83894228670.01.EC2CD2E
Received: from out-182.mta1.migadu.com (out-182.mta1.migadu.com [95.215.58.182])
	by imf10.hostedemail.com (Postfix) with ESMTP id 55D4BC0004
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 07:05:53 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=iFG9hULC;
	spf=pass (imf10.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.182 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758006353;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rkCYU2hnN7SdTU8iIMlWGHc/y+53owK9PLewiGtjRNU=;
	b=ITx6NrhIlUJ3idaZJQHE9Ap4Yk1wXu6W/wsx+bLauEG/DqlmTpc8icmwE6KNM6hfXQP8JG
	edLz0GXTGpLt94zIszekqbYv03QElIAbamu5Z5jz0z7RlvNO86rkTbnPAI3tvp4tWfShXZ
	g9I+El9AeKsfG3uXmb9Bs6R2t1XHw1w=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=iFG9hULC;
	spf=pass (imf10.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.182 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758006353; a=rsa-sha256;
	cv=none;
	b=m5BcPkuMYxEXM44lnU//1taZE9iaBztFjoPwYaiI/IIYZzKLPPFyhqmt/e8xwqMIHaO5hK
	vbd/ffbBfGwWZ9jEscVjyvLuMyXGxPvXeJ9f6egdVzpGZLBUSMzyk+26wxEUarbSbFdRqU
	vS2p/gMQvjsC/os/9bCskuxhfpmPlvA=
Message-ID: <36f7c6b0-eaa8-476d-b060-46c2c172d428@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1758006350;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rkCYU2hnN7SdTU8iIMlWGHc/y+53owK9PLewiGtjRNU=;
	b=iFG9hULCYBZq5cJd2sOYRANHbw+GXBnvdYIHqurF20TrMZ7oLijfxKpTnFHP89kknDYT10
	hApkwu1wO5SeI/uIeYqHbgd/OyJ3SU88qaGPj9sl/Qv4gOKdbNsxU5JcEGMqjAM1RZa2oX
	uLtppLW2XNVSKPNZG6CzpeBqHrGk5xc=
Date: Tue, 16 Sep 2025 15:05:36 +0800
MIME-Version: 1.0
Subject: Re: [PATCH mm-new 1/3] mm/khugepaged: skip unsuitable VMAs earlier in
 khugepaged_scan_mm_slot()
Content-Language: en-US
To: Hugh Dickins <hughd@google.com>, david@redhat.com,
 lorenzo.stoakes@oracle.com
Cc: akpm@linux-foundation.org, ziy@nvidia.com, baolin.wang@linux.alibaba.com,
 Liam.Howlett@oracle.com, npache@redhat.com, ryan.roberts@arm.com,
 dev.jain@arm.com, baohua@kernel.org, ioworker0@gmail.com,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <20250914143547.27687-1-lance.yang@linux.dev>
 <20250914143547.27687-2-lance.yang@linux.dev>
 <bc86d5f7-5b23-14fb-0365-b47f5a6f13c9@google.com>
 <a0ec4014-384b-4c04-bf0b-777c989eabcb@linux.dev>
 <70da1948-b0f2-f54b-e0eb-ff901e007ccc@google.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <70da1948-b0f2-f54b-e0eb-ff901e007ccc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 55D4BC0004
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: 9etxjyrmen8naw7hzmi6qjioszcpy4gc
X-HE-Tag: 1758006353-527120
X-HE-Meta: U2FsdGVkX18zwVf2V/TNEbWxsLZz46QLO95CcAkR76uenROIefSN+k4169SaGkwGxYZUFyM/2RUQfWDxiU1965K8jqboZDShvY4TUfOcKRlXEjxQWvmoWPET8Ptn1hkVviaqtoqqf5VrwTWS5FSL/AfVCwKzwXqNH5VjUK9zLk58/0dSVAOK9bRwKXvQX1V6OSN4OZNtz8SIMP1iGV8PZ3j59+vYyKGpJfIE+J0g3uIuJQtWjNh+vjqaeNCAnIrizK7EdUOVAYHf7isQ7FbZRXbjoIynJJc7d/u3vO+rzlaHktvIlU8E6KNl5e3PdlH3nAnDy+T4CP+F4vhg0JFtN0QQbdmq4SkakvS7hZDKTn60IAoAiY8Zezh895dbT2QcNo2EXJzRmNagMJ4l/7quJjZnIWN6wv4EMkxYKIANSjbmta7Sf0E5Nlpvqv05OfcPGrSIC9YmgpzjpkGJSbgyi50034pWgajPN8aPuhd2TALMlSrELDMRFmJPgTJesCVslshdguzm90p4bqsIR6ryPg3C/UxRT815GlQuG969UdXgIMS5Dh6/uCMmAKkM1HY9ah+qTpQ3qgTOrWTQFlCtC0LF+K8sq3esu/PgxSzUGziTqlnSjIz42FzVECrLKgU2k561kPIeVglJP4T1Pm/ALRdxaAxjXjVb6NFDWCTkFFElcgKsw6w/3OJO3aXbCrZjRjUJWwrzKr9EslTIU19kbHKhsHR7DSvBSUZclEreMSKqc3e55tMnAsQo9sVmsm2M4nLHKTvGauhsi1s1KtMLr6cFLZAU1eF6o0NuADWPk+t4inAOYRyrjFgua93zUTRO0glerdccPAfVjEo35voOD1czoHGz8mHfn6hVXCOZuIrTFR91btBn3vPyTICgbtZ0n7x8SjJiClPKu5K7RDpAbNZNUahiYW3PuTAJ78Q6DmpgCiHH1uQPkomsc2Oc3LVHaQF47CIMXRQfTOP+7Xu
 Bpqi4tmL
 uhpPSI1yAAHwqP8USj5Ui5RqJcEB/w+b7weNboIl6RckS2dDQrVkxz+Yiv4JobXU3/hMr9wwcc4X78nbphx5Tn7re8JKrgbJcZWNAjirIotxEaaTVuMUgBEjl3GPHmseSHhmtIh0tFS11jfWFi+q11icAbVUuqbzu+ig9gQ+cfR3bYtHmNniJfjayXHwUAQ3WRbujfRLJK/iXxbHh1E6fQ8bad3k9/btNfF1fww18ImdK5DGt0YeqdYBqLiVJJCOpIGFt
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/9/16 14:42, Hugh Dickins wrote:
> On Tue, 16 Sep 2025, Lance Yang wrote:
> 
>> Hi Hugh,
>>
>> Thanks for taking a look and for raising this important point!
>>
>> On 2025/9/16 13:32, Hugh Dickins wrote:
>>> On Sun, 14 Sep 2025, Lance Yang wrote:
>>>
>>>> From: Lance Yang <lance.yang@linux.dev>
>>>>
>>>> Let's skip unsuitable VMAs early in the khugepaged scan; specifically,
>>>> mlocked VMAs should not be touched.
>>>
>>> Why?  That's a change in behaviour, isn't it?
>>>
>>> I'm aware that hugepage collapse on an mlocked VMA can insert a fault
>>> latency, not universally welcome; but I've not seen discussion, let
>>> alone agreement, that current behaviour should be changed.
>>> Somewhere in yet-to-be-read mail?  Please give us a link.
>>>
>>> Hugh
>>
>> You're right, this is indeed a change in behaviour. But it's specifically
>> for khugepaged.
>>
>> Users of mlock() expect low and predictable latency. THP collapse is a
>> heavy operation that introduces exactly the kind of unpredictable delays
>> they want to avoid. It has to unmap PTEs, copy data from the small folios
>> to a new THP, and then remap the THP back to the PMD ;)
>>
>> IMO, that change is acceptable because THP is generally transparent to
>> users, and khugepaged does not guarantee when THP collapse or split will
>> happen.
> 
> I disagree.  Many of those who have khugepaged enabled would prefer
> it to give them hugepages, even or especially on mlocked areas.
> 
> If you make that change, it must be guarded by a sysfs or sysctl tuning.

Thanks for the feedback!

Well, seems like we're not on the same page. Let's gather more opinions from
other folks ;)

> 
> Perhaps it could share the sysctl_compact_unevictable_allowed tuning
> (I'm not sure whether that's a good or bad idea: opinions will differ).

Thanks,
Lance

> 
> Hugh
> 
>>
>> Well, we don't have a discussion on that, just something I noticed.
>>
>> Thanks,
>> Lance


