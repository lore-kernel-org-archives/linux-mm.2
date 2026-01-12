Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2512DD26D9B
	for <linux-mm@archiver.kernel.org>; Mon, 12 Jan 2026 10:03:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 694516B0088; Mon, 12 Jan 2026 05:03:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 641C36B0089; Mon, 12 Jan 2026 05:03:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 54D696B008A; Mon, 12 Jan 2026 05:03:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 46A206B0088
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 05:03:28 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id EB770D0C0B
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 10:03:27 +0000 (UTC)
X-FDA: 84322874454.04.280C6F5
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf22.hostedemail.com (Postfix) with ESMTP id 2BF3AC0006
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 10:03:25 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=none;
	spf=pass (imf22.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768212206; a=rsa-sha256;
	cv=none;
	b=5y0D5xUEkVwEthR/A7H51QZVtZXPd6wsXMFlTZX/N8Pi0NbDI+DBW+88OAty7L0IeXlklK
	lwjiE6Pv3MCfXUKEXcuqBaG/lanxklR92mXGn1VloRc0zYdsjUCIlXuRsWe4bCpqGkZlBC
	IgZI53L2WxWV2/B6jgUeY1iNlSEa4bk=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=none;
	spf=pass (imf22.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768212206;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vqucZmy7vv+Jrb08n6h6uNJCPDTTgAegSyMxVY7iqhI=;
	b=WA36mgmi771PG/pyF/2pq4LyyuyY3GzCKSatk5ISHDo/Cgxwq43cZGiUeDerD2rNov85en
	CFeubPCubcaVLDcWxDvtzvSLcxh8qoqS092jFlftnExhPY/OmAxZqdcT9hEjBolZCaHsgm
	DuVjWJ54mPm7qzAnNrIqpMunZVjJAN0=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 85A27497;
	Mon, 12 Jan 2026 02:03:18 -0800 (PST)
Received: from [10.57.48.185] (unknown [10.57.48.185])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 738883F5A1;
	Mon, 12 Jan 2026 02:03:23 -0800 (PST)
Message-ID: <105c747f-5721-4ee8-8eb2-1bf298de9adf@arm.com>
Date: Mon, 12 Jan 2026 11:03:21 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 8/8] selftests/mm: report SKIP in pfnmap if a check
 fails
To: Ryan Roberts <ryan.roberts@arm.com>, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Mark Brown
 <broonie@kernel.org>, Shuah Khan <shuah@kernel.org>
References: <20260107164842.3289559-1-kevin.brodsky@arm.com>
 <20260107164842.3289559-9-kevin.brodsky@arm.com>
 <315a7239-f5ce-474e-bd0d-f1deca3a7b26@arm.com>
From: Kevin Brodsky <kevin.brodsky@arm.com>
Content-Language: en-GB
In-Reply-To: <315a7239-f5ce-474e-bd0d-f1deca3a7b26@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: wxhb3xrrcmr67wxe38b3ij44wfb7j6na
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 2BF3AC0006
X-Rspam-User: 
X-HE-Tag: 1768212205-161776
X-HE-Meta: U2FsdGVkX19Uc1r4tSk/kros7m7CyQmuGsP4AryV09swespEgsHOVvahpcC2hkHg94qsO4cLqgD+N2aM4R2VIRYZ3i2CXRsdJqBc/2rhfwz+Qi/0McMQicX6RNlSubx9uv+p6zH+Zy0wJ2TV512IlgnuA4W43VAtAHUgzlNZU1heAJdZicFz61KPtQqYujQU3rhnPS7cwepd5Xq3+99IJWWoLptj7DMeuNKiixDuK0PO47XU+mO4plflUY1zIm5M4tdBWcYgkjro1T9S3417HuV6jSVisLR01tz549yfxDBKCRfk7uZIefc2YKCYQM9EGD/sa/HUoWe2QU0g64INS1KRxm2bQ6HvLKgjch9oGAd/ZRhxEWTpjuDSgOlh0miParV44ztEI1ELsBPlVFjSmxh8uzMWzlp8qsRElVfwuTisE4qBe6x9kY/2NI9GyW6D8lT57fijzhse3eVN5VkFP5GfexjitnTglFb0ogx+ZA1MBHp5VO1y5F3aTAyzKccDHVVg/oELk6km5m4ka7lcyNXC1w08EULdo9pGpxplrOrVRszikjNtpeuqzgnJA2uU8DeLqpVj1X+3EYKlrvuJFk/zpEbh0MyAs16iH8VeLtZu46jutkqeygz6z533u/QOkIZvHhuVzSwJXWEuYPm99qw7rvfcMC4yg0ef/pfS1i32vNXC6k+1/mzq0dhXMtG10yGXCzFAOXcUDtH7wN22pMWzMCGsxvJMk97htFZ3tSbo9/iweYXJI3HsBXX11TsTkrjET9mSRHOxzOwJAA/49C7NX15iMYvWI78vIinsczH1yffeNpJ8X3ycuJ0g0s8vwgOxgKc3HD9bw4uZl7iDJY8/HcQ0L47rOgjX+SaZVg4xc01ep+VdUjdMSv0s65TJrXEGy1Y3849fPiXLzZurU+YYgumMwEkOyV864YMqxpE4D7qFuv6yxicYszj5pJE3Mw3y0qh+ahF2NS6O6H8
 A4y6Dxuy
 k0to8aeGb9PZHcuVBim3KGlnPmotz7A3cUYtbgIgEKQ16bFbB/h3v6S6MWeHBu2qOxB+do4bSYCeD97LY/REwjdr8Wi7iIQ75rhRUPaPEGDJfC7BZ3kQwNDidM5bJs/5qiGE8euGqZLHAZgE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/01/2026 10:34, Ryan Roberts wrote:
>> -	if (!check_vmflag_pfnmap(self->addr1))
>> -		SKIP(return, "Invalid file: '%s'. Not pfnmap'ed\n", file);
> I wonder if we still want this check per-fd, but upgraded to a fail?

It seems very unlikely to fail though, I can only think of the
underlying file having changed in between but I really wouldn't expect
that for such special files. I was trying not to duplicate the checks
too much.

- Kevin

