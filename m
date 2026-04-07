Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 04D8BFF512E
	for <linux-mm@archiver.kernel.org>; Tue,  7 Apr 2026 18:59:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1CDF26B0088; Tue,  7 Apr 2026 14:59:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 17EF86B0089; Tue,  7 Apr 2026 14:59:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0958D6B008A; Tue,  7 Apr 2026 14:59:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id EDD2B6B0088
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 14:59:02 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 73BCE1406F9
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 18:59:02 +0000 (UTC)
X-FDA: 84632672124.27.FCB2875
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf04.hostedemail.com (Postfix) with ESMTP id A9CBA40004
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 18:58:59 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b="eVY9/VRu";
	spf=none (imf04.hostedemail.com: domain of rdunlap@infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=rdunlap@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b="eVY9/VRu";
	spf=none (imf04.hostedemail.com: domain of rdunlap@infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=rdunlap@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775588340; a=rsa-sha256;
	cv=none;
	b=ptZ4SwX3Rm2QGRDAZ44weCTYTRHcFb4odTA7V6GbBtLpfo+B/IN7oyvOU/eoUMmO/2ghQn
	x+Dmn6aTyTDq5QCYBtuBqlbipsMVO/J3NsyKi2HfrhtcaDfVrbvljSfYC/ZlbuCBcxHxdi
	ef2WYHf9GEvDeWn7kBmdu8rQ30dBLPE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775588340;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SQSxQSEOHiVkC2HemnN/5qYkqBP2dOqmPajTu5+oxsw=;
	b=QCMJOQJUB4VvKyWskBtVtsD3B8Vz+Wq4Pod5wesi92QCxTcHhWmV9vx78kY2AQgCVQQRIS
	JFqoCvYQecq8vr6PoR9hxKu/fs6d1PaLPvYUcYdICkUMFi/rAFD8bPxzmFXsnNhE8oDzob
	iU8KMHRpU3lc4v3rcu37YDqMtvoX1Ac=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	Content-Type:In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:
	Message-ID:Sender:Reply-To:Content-ID:Content-Description;
	bh=SQSxQSEOHiVkC2HemnN/5qYkqBP2dOqmPajTu5+oxsw=; b=eVY9/VRugfr6vnIaqRJqhFI5HN
	9Kb6vigVz4U4mvZnmzfRVBXNX4+J/lxvZlSEGUNNp5MchlZSnQSrG6OZ9Pio+A+tO/Nj4OERv2YNh
	HUc5zDfcUnEyaytHUfK8y4l1a3JLSoVhP/9ygHNM7fRGzrPrqx9Qg7AyMV0SQZtIR7rKq8xAxDjzc
	OLG0QWC13ApBCL+oXo6RvABHhfnhQ53elFVhKCEp8OwO0mqToK1lzm9VeYIQlujNiheEdyGgyhuP2
	bBhWYxtyqW18Zuicg7ygu6QMM8MysFZLEBmsj6gzQasYuXJrs5xC2hyzUYHHIutuHdGsCKhFyG8JU
	OPG/OyyA==;
Received: from [50.53.43.113] (helo=[192.168.254.34])
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1wABdU-000000079Wf-16wb;
	Tue, 07 Apr 2026 18:58:52 +0000
Message-ID: <18e2042c-d414-40fb-8819-5e930d5b1584@infradead.org>
Date: Tue, 7 Apr 2026 11:58:51 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] docs: proc: document ProtectionKey in smaps
To: Kevin Brodsky <kevin.brodsky@arm.com>, Dave Hansen
 <dave.hansen@intel.com>, linux-doc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Yury Khrustalev <yury.khrustalev@arm.com>,
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>,
 Dave Hansen <dave.hansen@linux.intel.com>,
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Vlastimil Babka <vbabka@kernel.org>, David Hildenbrand <david@kernel.org>,
 Mark Rutland <mark.rutland@arm.com>, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org
References: <20260407125133.564182-1-kevin.brodsky@arm.com>
 <98880cc2-09be-4bd8-b8f4-f0f0845f939e@intel.com>
 <2d2aac86-2780-4a29-9eef-116c26485812@arm.com>
Content-Language: en-US
From: Randy Dunlap <rdunlap@infradead.org>
In-Reply-To: <2d2aac86-2780-4a29-9eef-116c26485812@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: A9CBA40004
X-Stat-Signature: ktzhajbbq8b1guhje13dhpq9mczftend
X-Rspam-User: 
X-HE-Tag: 1775588339-676057
X-HE-Meta: U2FsdGVkX19E9ivOjvfa+lREES1jqPSf6lhxXRBdK2Pa2WloQlb/F4yfyQM0r+vjOJo3dNSED42kCWzkWwkkqonWYjVloEqtWmOhrilGKgAmjvtAT9szQDOQhShODAo2qP+LdHRHz1GOHyYzho7q7cKeCvkunsFqFMLOrBr1HdBFpU82VeEZHMbbBrViUgFeg9mIH8vxZlgQ7aSFkKVIE5ndIjgHMPQBU/fXLL/SB8PrMoZeXCy8K5HUv4rNivOCOqTF+wdNPMojLfMfVFsqYi9jK1k+5cWinHa8iw5p0v2w75EMCpk+RNV/ao9CdpGeZvEhtYjIflgc9rCzRVC7WsiK8Hnexn0Q1BkY5tdT6amj7c1LjP24I3Y4C1MMM/R+Ql7S4Mfwlm3LJOxlCsPM8khmRe+Un7WBXu0V0L521JeOu91O9RIkded/DQTv7bOY6vjNsb/8mQrbtVj64AbAABK9B/yK0DCBFU+LxjdgCZtoFbAypDcSWQmYeaJ8TcOu0umWFju24gE5kVDq6bkfyZPhd8IlzkUMkUfApIuEoaZz8JFUSxwmBrlZGbDdikq16ffYFTU/4m/bbtCOFrBlPUDo3bOzzpX1TtZa4AFS+YTpjO0MtNTlOqfDBdpCtwXChnSLWgmzb4EMO1LfLPkQFfmrArc1t2mrFcl58fFQYIkcgLe4r+8LrhlPd4KT94UJN0xYP8ICbvChfQAQ5kwT7HRJi8kojBBk8JcvDHEo/vnJafgHrEA1dZU8ou+4zBOwX0U5atVnvlAUsMij/l+c0V+DFNHZNrpRmXg9bG9yyfFeldXvX4pmKMpMXdnXc1SXrUVDpNXo9tD5ERkAb6WjsYsnt0/jWeihCyJF6Ll7iXLm0p2cHXIBlma4ndVxnEjeQJ13JU4u0Y0bl4dmGUSq1mTR072aWXKIfgscf6HegUiy4y78V9mBCm5fF48W896RmbWDCU+lC9637gzPcP9
 +wi3JC0B
 iXJ6GqeSUYpb+NyVtIizzQsg4PCN7bcdu6dEd3WJzqSNoEVPgKR9dZY7QNjvVLXoYxEx1Jy94DZFWCKie44RtvXGSrV2WiKGn5aEEiEgFrX9IXP0ZGMm86rqS3YQHoEGd7/wTE4p2EFaJdt7oEm0N2JUeCS77FqNfPrriOhH45ghAf0nAs1nI1kmOkOXlNgPjwnG7/feW2TW3i3JkQ1mTn5Ar8rEuWF6GYbAP1Rs4uedPUmCqxACbi35BezWXJb2mdzlPhDgVKe4QD4LCSBE1gfznitj3diX5cvScVzFotU2oBYs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 4/7/26 8:12 AM, Kevin Brodsky wrote:
> On 07/04/2026 16:42, Dave Hansen wrote:
>> On 4/7/26 05:51, Kevin Brodsky wrote:
>>> +If both the kernel and the system support protection keys (pkeys),
>>> +"ProtectionKey" indicates the memory protection key associated with the
>>> +virtual memory area.
>> I think you're trying to get across the point here that the kernel needs
>> to know about protection keys, have it enabled, and be running on a CPU
>> with pkey support.
> 
> Indeed.
> 
>> To me "system" is a bit ambiguous here but _can_ refer to the whole
>> hardware/software system as a whole. To avoid redundancy, I'd say either:
>>
>> 	If both the kernel and the processor support protection keys...
>>
>> or
>>
>> 	If the system supports protection keys...
> 
> I see your point. By "system" I essentially mean the hardware (the SoC).
> In general I would tend to avoid "processor" because not all CPUs in a
> system necessarily have the same features, and some features require
> hardware support beyond the CPU itself. Terminology is hard...
> 
> Happy to replace "system" with "hardware" if that's clearer :)

I think that "system" is too nebulous there, so I would prefer to see
"hardware" instead.

thanks.
-- 
~Randy


