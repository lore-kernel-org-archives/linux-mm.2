Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E5013FF5104
	for <linux-mm@archiver.kernel.org>; Tue,  7 Apr 2026 15:12:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1B4B56B0092; Tue,  7 Apr 2026 11:12:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 165396B0093; Tue,  7 Apr 2026 11:12:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 07B776B0099; Tue,  7 Apr 2026 11:12:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id ED04E6B0092
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 11:12:57 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 42D0F1B8B58
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 15:12:57 +0000 (UTC)
X-FDA: 84632102394.28.D5FB269
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf01.hostedemail.com (Postfix) with ESMTP id 0FF9B4000A
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 15:12:54 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=WfxbU98J;
	spf=pass (imf01.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775574775;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Y5K+5kR+dY44S+Djxc5i0znUyspwfpnyu0KX5aeg88Q=;
	b=fiWb7v4vYu1ZHYuAE1mlD5c2AFTbiSUHinMam2IG9NfjuV5m9uUaiQ+a/SfWVt1ToGOTCz
	WvKSyl6xi7+BGLy4nKa/ZOAKs/pOhoBp5+JMFj6a7tQMm3RUzI7RTAOE2oItmD6BYpGbnL
	s9FRexTAEFXMZIvecXAWAft3UEIBu1s=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=WfxbU98J;
	spf=pass (imf01.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775574775; a=rsa-sha256;
	cv=none;
	b=B534HoK2VSazA9z3TDlcZOjOxhSP4NQI8WoL38LY05ZjnIt1PHcvYODMa9i3czNja8VQ0X
	KMS9ZYcZ8nyh/Y7WuM5Qo4guQf6aQxHLBWjJyFc3nVGZbWKtNb+DzAbQdkZg4RuzoF2q+h
	P1n1xOC3EoNMB2FRTzZ6l0P9RH9+4hE=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id EFB623293;
	Tue,  7 Apr 2026 08:12:47 -0700 (PDT)
Received: from [10.57.62.47] (unknown [10.57.62.47])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 322143F7D8;
	Tue,  7 Apr 2026 08:12:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1775574773; bh=eN18IrONevsoo58gEUdDHXiEgoDM2LKGg0S0uh2Re5s=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=WfxbU98JLhxx24PyPN7oX1VXAEQLQ6QcE8Vg6D5u/gaffXdgZeCi06wkdKW/utfk+
	 kokY0lqImfvFUceZ40JU4ui5cLu74Pn57bZ8IZB4pMS4A+8oeHdwgL0dbLP8YJgnQt
	 0mTS6c1gtdFIdg8gXhskpAs1ikGD0tuxSxwByk8A=
Message-ID: <2d2aac86-2780-4a29-9eef-116c26485812@arm.com>
Date: Tue, 7 Apr 2026 17:12:47 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] docs: proc: document ProtectionKey in smaps
To: Dave Hansen <dave.hansen@intel.com>, linux-doc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Yury Khrustalev <yury.khrustalev@arm.com>,
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>,
 Dave Hansen <dave.hansen@linux.intel.com>,
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Vlastimil Babka <vbabka@kernel.org>, David Hildenbrand <david@kernel.org>,
 Mark Rutland <mark.rutland@arm.com>, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org
References: <20260407125133.564182-1-kevin.brodsky@arm.com>
 <98880cc2-09be-4bd8-b8f4-f0f0845f939e@intel.com>
From: Kevin Brodsky <kevin.brodsky@arm.com>
Content-Language: en-GB
In-Reply-To: <98880cc2-09be-4bd8-b8f4-f0f0845f939e@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 0FF9B4000A
X-Stat-Signature: jd6ki33k9odegfyrqe8ir5m4umh9ssma
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1775574774-252788
X-HE-Meta: U2FsdGVkX182t9fawkUPweYnN6LOdG4iFo+4Ke8pf6B0p1QcZC5053WPfg36QMQUTkjNzEU5n9iytmyld7XvLtQFk84buYZjrXUYHRzKwUxMPR2pbSVT3k0soQUEnNKZSfymBCtmxxnoC9GTNqRAvv890ELyZPiJoEkM+bNINkdZJI6y/2T7e/3xFIwClOHLdRMERPDfkpz6vsi/EvK4E46U0UK7CZ3UT/Po+tT6ap4XRLqtOx+JCfYMZL8UlEZHg/YcV5clzGaFbrI+EvZ4DWl1fNN1wYX5ASOrGFAwiPR/BzUkAvo2fh10/v4BVU9s/vmQRTUw/tENyz14K+Joc8HmWOwc2hDafOxlAVdlJgM3NtSqejN78dlTMh0B0dsr0rmxHZ8/9IEPg24ViVR167AT9BoGR7ZirIqcZR5ZHRKXqB16aCbjq+OHbUILwrhV3uAkN5n7OVMT40Harbqzv6tY4C68U/ur9VrufDLYwmkiRidJqUrO68Df7CFVld0ka1kL09HVRoNNz3eoXKS5EW8fETVZAMjGrjdwqH/QYSutHkjbjwNImve/pmSr2vJgGX30IRdWRfTOkk8Qb1LoiOlFr4MBKufCYWY/9Ok5lvrPFomqWDduii+fDVLzBWLEGbfS4beOa3eCTUuJjoL+qXY41caF3dfnE+yiWnrvno6KeUggrNaEH7J6kn1aTEUDWG0qA3i6BOtAHul8YwXdNf6Jp8SjpfEXEF6JV4bnrbCV83dMuGFvth8Vn/FUBDyOsOQIeJRKoA/BXSaW35fO0PwIAO8lzX3WikZpkRe6hM6ddzOiS3NQ4dtYLBSuwrVMno80iOZxABeLtjPsfZPPK1ud1P1EI3A3B2sCEjrl1w403xjbBS0s8BVBBXm9/sjGTBh6RsX9Zzs0fZGQ7HT5OwXE9Kbhedd+uHfsDWsiR08osV9o72iwEOy9sedrnb9ZAbhVCl7SJ6RgQ5XBpj1
 uuyTNAaD
 gyhJWVp3S2p8e38DwRrBSs53PdptiF7ob/CBNVipHTRpJ8/gfKcnElsPYrE0MPL59URxlKQuzmRCIo/ZiM2kDD8G6JwlkaI9hrm5dhabQoQXw6CLaP+qMe96OGYdSy7OeQ9POPobA+AJfrgtsjFPlEuYc2DiIvyMtZvZFCDAdNT5/X3f8lfVadda64NLSVXg+mEyViMKWA3N/Hzt4MGS4yrZ5pFFaznxJpqGV
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 07/04/2026 16:42, Dave Hansen wrote:
> On 4/7/26 05:51, Kevin Brodsky wrote:
>> +If both the kernel and the system support protection keys (pkeys),
>> +"ProtectionKey" indicates the memory protection key associated with the
>> +virtual memory area.
> I think you're trying to get across the point here that the kernel needs
> to know about protection keys, have it enabled, and be running on a CPU
> with pkey support.

Indeed.

> To me "system" is a bit ambiguous here but _can_ refer to the whole
> hardware/software system as a whole. To avoid redundancy, I'd say either:
>
> 	If both the kernel and the processor support protection keys...
>
> or
>
> 	If the system supports protection keys...

I see your point. By "system" I essentially mean the hardware (the SoC).
In general I would tend to avoid "processor" because not all CPUs in a
system necessarily have the same features, and some features require
hardware support beyond the CPU itself. Terminology is hard...

Happy to replace "system" with "hardware" if that's clearer :)

> But I'm ok with what you have in any case. Folks will understand what
> you're saying:

Hopefully!

- Kevin

> Acked-by: Dave Hansen <dave.hansen@linux.intel.com>

