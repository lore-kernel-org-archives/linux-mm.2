Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4269CE81BD3
	for <linux-mm@archiver.kernel.org>; Mon,  9 Feb 2026 16:06:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A9D816B0005; Mon,  9 Feb 2026 11:06:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A4B7F6B0089; Mon,  9 Feb 2026 11:06:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 94DFF6B008C; Mon,  9 Feb 2026 11:06:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 83EFD6B0005
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 11:06:52 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 149331401F0
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 16:06:52 +0000 (UTC)
X-FDA: 84425396664.04.31676BA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 2944120015
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 16:06:49 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=V5J3z3AT;
	spf=pass (imf13.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770653210;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=a3Lyts8uWLvj4VYRHXqt2lETV+d9HGwbS4aoiHBUdIA=;
	b=VkJNAUFfkOFnUuOG/euZHTgdNwVXlsrGjBidLuZjaHQygMG0AsCgVdmCzboyl05FMNBKYO
	XO2bf/a6es3TDplg3D+huSsIk3xjsAzH13Xxw8x1WaDI0gJHxMbh6W0eurWjjK6jZhm6O4
	+LEpe30XxI9GI4k554Rwm5NcCVCJrS8=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=V5J3z3AT;
	spf=pass (imf13.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770653210; a=rsa-sha256;
	cv=none;
	b=YOGQ37G9K1+nxFId0/4vChB44awkVTwUTsma2ysSlcciVukvH0Ypf07NSIcXkk/YSibka2
	vlJTBCqyaSgqm0tkn3HP6s1YhrZ085Gl2FX9ewLRMH3T986bd2obceNdYKbQT+6Uhih/eY
	Ky5XSEbAD0PtL/catpAO/OlBNMP005U=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 380084181E;
	Mon,  9 Feb 2026 16:06:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97AA9C116C6;
	Mon,  9 Feb 2026 16:06:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770653209;
	bh=yVgbaNirlh2OA7D4UrWbL9q1fbpgQwsPgJytedPsg2w=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=V5J3z3ATIEcEvlbOLsT8GbVOrIOvawcOkq9AXrlxBSdltJGZMpXCPOFEeBsOLClB7
	 BXnaFOBlXKGt6kKSmxPvhroGatW0qIklOx+S1V5KixSvt7LsnGbsiAgd0Ol8npJrKz
	 wmF+jnhpFIC9+CAoqDse16mUrEZV+IrpkN5yYl6LcV75ixsayuFBHIiyu7DfkBqV7k
	 zr9GYFC1cuAAkNmTGxW3eIYCYLSZnEPk9jcp+7sLHXxwov8SKsw96/pWmFp5q4G08D
	 L05BjqvUQcR4XrWcTR/AW2/jDctdwdVyWqif6ZLldJH89xf03ltiY5vCaoLFukBdAr
	 sxb2Yy1Auixog==
Message-ID: <3b95bb12-5642-443b-b163-8b5f5f6400c4@kernel.org>
Date: Mon, 9 Feb 2026 17:06:40 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] mm/page_alloc: clear page->private in
 free_pages_prepare()
To: Zi Yan <ziy@nvidia.com>
Cc: Vlastimil Babka <vbabka@suse.cz>,
 Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>, linux-mm@kvack.org,
 akpm@linux-foundation.org, surenb@google.com, mhocko@suse.com,
 jackmanb@google.com, hannes@cmpxchg.org, npiggin@gmail.com,
 linux-kernel@vger.kernel.org, kasong@tencent.com, hughd@google.com,
 chrisl@kernel.org, ryncsn@gmail.com, stable@vger.kernel.org,
 willy@infradead.org
References: <209207FE-D3A9-4BE2-8DA7-9BE38A19F387@nvidia.com>
 <20260207173615.146159-1-mikhail.v.gavrilov@gmail.com>
 <cbc3b5b3-09b5-4e3c-99f0-a1f67582afff@kernel.org>
 <51f96b31-fb59-4cda-9d33-e3cebc45686b@kernel.org>
 <a38fb457-c0e8-4089-a31a-ac59d06a796f@suse.cz>
 <c0b93b3f-bc4f-42f6-8287-72d015a0a79b@kernel.org>
 <FD637A2F-909C-4039-BEE2-B60F85FEC7E8@nvidia.com>
 <42b977d1-4873-4b3e-9107-7055836cde11@kernel.org>
 <CD2D5EFD-53FC-4E0B-B7B8-023495867C65@nvidia.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <CD2D5EFD-53FC-4E0B-B7B8-023495867C65@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 2944120015
X-Stat-Signature: yxxhdhquh7p73xhno34d13gizy35gmqh
X-Rspam-User: 
X-HE-Tag: 1770653209-345073
X-HE-Meta: U2FsdGVkX1+eyxLaMJrydJIRg/Nq1tYC8LnP+x8PGtFEkkbab4KnvuhRFYhMmK327EzPyF1p4EPQg5WuMhDzWsDlZgvDlWsvGXtsfhdnikfPOt6+yVER9Bu1ryHoZI//hnKzC9zzC1a+LSVDspgKerFmNhPQz60dz8OrNTQVzC5KtWY+p+2L5h7Ghv/GkFB2udsEVZbSbC+yOwCo3Lf5A7ZyCPR3s0bjzFJON1+frYTNCtZLfnv3doO++g5syoSrCtZzFba3SVX0Zzf8L/JQlEQf25qhwxNtszKdIsRTvBQpbG2onhIIhIqB/I9Vaff3t9JyCYp+qXmbkqBzvYRivndS4O/CpqJBGXWPxV+XSfmfPnt9Yl1aothTaB/cZeONZURtbRDzMnKXBpN2DqzcMMYQSDOg63EkI/SgNVCKJIeRolH7TzEqlNasKHXUjnTUUXvAgmKEWuzERnv511UvK8apLrq5+dXBGUMaIiJe6ZzrGeopaZgDW1/13hiX7ybTsjE01ZPkJDrJ4lCLNaZQnUzNb3PdholsTUMcUgPIOL0kpLoHEE8x1UFaWmiLXFCDzte8Kay9qC9g07l9L+tPZgLg3LweQiMngdKGcHYYzUDq87mhdWKDhkkXlnJ9udeEo7VjAMZkUlGSAaa5Glfi8DiDXnadv1YNq326/DlO0kfatQlRpuEvy5o86V/jGY/WpXL9CQkz/afknoqJN+QzWdHqahc3vJT+hdF6kCdTYka+KUGBQK5CqoqSJsWDFT5sQqbXxeb12ikWOSsPVa0nLEpjhLzi8iOPLST2X96vJyJ6++DA4Mp9vWPNNScSbmFl/lfN5HQ0G30WdWTl0mTB33h3JV8VANwYNJbSOFYIUuB/ReZKNUt21OCF4PQ2yi9Ag0OwdulPWcFWosv71zEEIyiHfjh9zn3vrIyUBn04LJpPFDp1cyUUcvyMs+DWheq61pEJSkK3QTYkb7he0Lu
 h5jAbQA9
 NQijop8dK2i+t8hEhNh7hKaxuYVXw/0nbmBEqp8imUcWQ1WJvg9tPhMnRtnI3R4UYQzjXzxNti+HPuxIAUIqBwpBp/O7FGS7PXPZXIf8dNzceTKuaFsrj6XotfyYf/ciDqXNC5p7YHuSpKY10m+MD0NoBG19HicLCWFKrZ0JJZt9hOlbb3I9xLjlstf78xSv3LaREIepNsPIp6F5Z/CDIoFLOWwmLYXZRXjJhu2Bx0Z1IJ6qVKg/ylIWRyUMpRr3zBLsYFi1njxdiHm7xICbt8AfWEdxgXeDzdj3QchYRiKu410NUAESSWmTVcxMgEWctylb4qL8evyl1VyywdTj2uo9JGtAGYjlUsJbubdKNwtVdj+oDkkghw1QNbUdjTii4WQJZvoG8xZlua0s28QMkjfyU3g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/9/26 17:05, Zi Yan wrote:
> On 9 Feb 2026, at 11:03, David Hildenbrand (Arm) wrote:
> 
>> On 2/9/26 17:00, Zi Yan wrote:
>>>
>>>
>>> Currently, _mm_id (_mm_ids) overlaps with page->private. At split time,
>>> it should be MM_ID_DUMMY (0), so page->private should be 0 all time.
>>
>> Yes, it's designed like that; because that check here caught it during development :)
>>
>>>
>>>
>>> It is still better to have the check and fix in place. Why do we want to
>>> skip device private folio?
>>
>> I don't understand the question, can you elaborate?
> 
> You said,
> “BTW, I wonder whether we should bring that check back for non-device folios.”
> 
> I thought you know why device folio needs to keep ->private not cleared during
> split.

Oh, I thought there was some overlay of ->private with zone-device 
special stuff. But I checked the structs and didn't spot it immediately. 
So I ended up asking Balbir as reply to his latest series that got merged.

-- 
Cheers,

David

