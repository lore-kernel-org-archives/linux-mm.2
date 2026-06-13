Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 88FFFCD98CF
	for <linux-mm@archiver.kernel.org>; Sat, 13 Jun 2026 04:23:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A3A606B008A; Sat, 13 Jun 2026 00:23:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9C4596B008C; Sat, 13 Jun 2026 00:23:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 88C396B0092; Sat, 13 Jun 2026 00:23:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 753626B008A
	for <linux-mm@kvack.org>; Sat, 13 Jun 2026 00:23:01 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 0E6F2402EB
	for <linux-mm@kvack.org>; Sat, 13 Jun 2026 04:23:01 +0000 (UTC)
X-FDA: 84873594162.29.68E4B4E
Received: from out-185.mta0.migadu.com (out-185.mta0.migadu.com [91.218.175.185])
	by imf03.hostedemail.com (Postfix) with ESMTP id 2987520004
	for <linux-mm@kvack.org>; Sat, 13 Jun 2026 04:22:58 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="tPb/kuJv";
	spf=pass (imf03.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.185 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781324578;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DEMwa4f1MFnoeLMMYpMgo/qvtlYKFkI0l0gCAFNfcMQ=;
	b=MWdnKfNEBYcAn9ZrnrBO54JpGz2HsJSSpvbs7puafx0F1Jg7NQ9zHpRFvCVv3ABFsmxNMS
	0q0ZWgVRVqvh7nxJq1Fo7A5besOxz/ldN2nbuyQscYEXdDZZCs178lXd9OPcKKJxltzXaR
	uUNRNj9Pn31d7se1P9GEfRKTDWuQhvY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781324578;
	b=tWgd7o/m2OvtGUf7fsoqYM/APgvGa6AJRfC8exwe1FygAKE2Fkhao8ngc+hPHS8q6hEpfk
	X90jRmYERgQIuO/7Cdc94s1w4528KQWa0o8WGDwEes/Z1GGlf94kgO7M4ZMQv0LhrhbDo7
	YxH0Y8x/2Dk3vp2bo1OtWzV6/gMDSUM=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="tPb/kuJv";
	spf=pass (imf03.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.185 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1781324576;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=DEMwa4f1MFnoeLMMYpMgo/qvtlYKFkI0l0gCAFNfcMQ=;
	b=tPb/kuJvWgaPzvQpy+4bzGMmKA8DJRnuluujcznryfkSdJX4r649PfcIlHlywiFQYv2cBu
	fmtO8tEOi8UZ3flArfYAvge816lR4fX9d07VP4xxMsfg0sHnRtmOggt8xINgnWQbWc0RdR
	AVru2TvWh3ebEYv2mgiG7T8fnKxfOaQ=
From: Lance Yang <lance.yang@linux.dev>
To: usama.arif@linux.dev
Cc: david@kernel.org,
	lance.yang@linux.dev,
	ying.huang@linux.alibaba.com,
	baoquan.he@linux.dev,
	willy@infradead.org,
	youngjun.park@lge.com,
	hannes@cmpxchg.org,
	riel@surriel.com,
	ljs@kernel.org,
	shakeel.butt@linux.dev,
	alex@ghiti.fr,
	kas@kernel.org,
	baohua@kernel.org,
	dev.jain@arm.com,
	baolin.wang@linux.alibaba.com,
	npache@redhat.com,
	linux-mm@kvack.org,
	akpm@linux-foundation.org,
	liam@infradead.org,
	ryan.roberts@arm.com,
	chrisl@kernel.org,
	vbabka@kernel.org,
	linux-kernel@vger.kernel.org,
	nphamcs@gmail.com,
	shikemeng@huaweicloud.com,
	kernel-team@meta.com,
	kasong@tencent.com,
	ziy@nvidia.com
Subject: Re: [v2 00/16] mm: PMD-level swap entries for anonymous THPs
Date: Sat, 13 Jun 2026 12:22:32 +0800
Message-Id: <20260613042232.93691-1-lance.yang@linux.dev>
In-Reply-To: <680441bf-c878-4a00-8787-63ad8b201bc9@linux.dev>
References: <680441bf-c878-4a00-8787-63ad8b201bc9@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 2987520004
X-Rspam-User: 
X-Stat-Signature: x3ekt89189w5tq1z65tm6tsyzuema4rg
X-Rspamd-Server: rspam08
X-HE-Tag: 1781324578-671830
X-HE-Meta: U2FsdGVkX1+pN34qM7nXy8lGOW/yXuUeorClyt9ENSWAS/Egpdv9ARO9AxS9J9+QHn9hDniiuik2Zg19WRrl8ppeYKg6Lw84VAZ0tlea5mSdxBG1/iSl7Ph5ybNfqQfxjLtkttzfncf6mFH28W2IAPNGStwsGHl81TqPpRh8qViWvRNtWd3SkEnJjxabTmCp2meF/gIVvFCQlYcWC1+Lt1TR3hQmJe+esrxMGkb5CeGsw7+fhSCc88VfHexU6j1MrZlyDoJVqv2iwMXj4HK8t2+dzNJO6zUwF8lasit4FhjOxr7tcYMdRsBitkOjWFPOiBlxRCu6NXk/2zvx+Qz5OIamc7BOVrm/MvlyoG+fUq+Eor8wL5SqMe8cUZzA4x9VYfjnW3D0Vzjby+aVctD0ckC6eUuNXO3GFBve/75oIaVmkr/mQFzSMf7ypiGyyj6d0fobvGXATqfAiS/eaQTLJfljXI3eoMTTFNXmY0aAjTN5uhUP9Foz3tWzQYPZoHqsFkrlPiA9g3/P/g9idsZ7UVoCMBxNFCm5BrG1jjZOKmA4gisydEioAPSnEcZIDJV4whut1/8niurvOiM0WPU+dULajBlWKU7Oal2XEIKdJKxh4vPH/YbvK7thK5vML94+yMhDfz19cCpmjs9ytJFeAzmOHfs3hCUzMyVDc4f+j7ezbgBXVEWGQyGHRXP5LMwJxFn/xdEybTii5RR++uE3DWc0q7TXrKczo/pfHeYpw4dc4r1MrSSWk5OfcZN5uRT3OypjyPhelKg6BLkKBGGOcvfEHtLSgCxsXql0dv+fypn2zSyAAdr7m1Jj9vNjNVerTvxR8WyHptzK5YcvwWHh8B4/jJura0/Hw5Ry9vXperWtNQ2IaXt2L3G9EeEV1bbQ+e55NM6RsNH2LwBc26oy+7R+QTLC7GOMG6So4VsIf+wKS2LAsBxol6HLsjPPQUeckUN4aoOV8GyQ3LLMAes
 BGMhFFAm
 iBqvcdfIWK3KMv19rhcvnuWXTIxxpzLe6QffvVm32zom69lXshVbKEoeU0/+03HgrsJSzMFfiAWrJHRAuOAbpLd4vW+n4JNM4MjMfsuCexA8veQoo9/JXo3phxN8i4MXlzOar1O76qrwqLLryhT0bunr0JGzPPOandr67QUjo9Y0v8JI/G8dRW1uyO4bPZikzmO4eROv2ndoQCTfHdAo77LyyJA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Wed, Jun 10, 2026 at 03:44:32PM +0100, Usama Arif wrote:
>
>
>On 10/06/2026 14:48, David Hildenbrand (Arm) wrote:
>> On 6/10/26 15:01, Lance Yang wrote:
>>>
>>>
>>> On 2026/6/10 20:24, David Hildenbrand (Arm) wrote:
>>>> On 6/9/26 16:29, Usama Arif wrote:
>>>>>
>>>>>
>>>>>
>>>>> Hello!
>>>>>
>>>>> Just following up if there were any reviews/comments on this series!
>>>>>
>>>>> I know its a large series but was just checking if there was any
>>>>> feedback?
>>>>
>>>> It shall be reviewed. We just finished the mTHP khugepaged review to get it into
>>>> 7.2, so we've all been rather busy.
>>>
>>> Right, mTHP khugepaged was a rough one. Glad we got it over the line,
>>> but yeah, there's just been a lot of THP work lately. pretty nonstop ...
>>>
>
>Yeah its definitely a lot. I have set a target of leaving review comments on
>atleast 2 patches from mm per day myself, but even that can sometimes be
>difficult! I will try and help out more in reviews.

Awesome!

>>>> (I mean, just take a look at the THP-related flood of patches we are fighting
>>>> with on a daily basis, it's not funny anymore)
>>>>
>>>> This is clearly going to be 7.3 material, so there is plenty of time given that
>>>> the merge window is about to open soon.
>>>
>>> Usama, I'll try to make this one a priority too. Looks interesting :P
>
>Thanks Lance!
>
>> 
>> I have two other bigger series to review, but I should soon get to this as well.
>> 
>
>No worries at all! Thanks for the reviews! and yeah definitely 7.3.
>
>I will send this out again when 7.3-rc1 opens (rebased), so that the reviews wont be on
>outdated code which could cause some confusion.

After skimming through the whole series, probably PMD swap entries need
one bigger rethink ...

Emm ... same tricky bit keeps showing up ...

One PMD swap entry is easy to handle while the swapcache still has one
PMD-sized folio behind it. Once taht folio got split and reclaimed, the
512 swap slots need per-page handling :)

Maybe worth first pinning down the rule here.

Is a PMD swap entry supposed to mean "there is, or soon will be, one PMD-
sized folio behnid it", or is just a compact page-table encoding for
512 swap slot?

Without that rule being very clear, every caller has to guess how much
it can assume, and it is easy to miss one ...

So I stopped staring at the details for now, because the same issue keeps
popping up wearing a slightly different hat :)

Anyway, no clever answer from me here, not a swap expect :( Just pointing
out the pattern I keep runing into.

Thanks, Lance

