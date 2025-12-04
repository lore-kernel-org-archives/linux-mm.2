Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3229CD1D870
	for <linux-mm@archiver.kernel.org>; Thu,  4 Dec 2025 06:05:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5A7EA6B0005; Thu,  4 Dec 2025 01:05:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 57FC56B000E; Thu,  4 Dec 2025 01:05:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4BD486B0010; Thu,  4 Dec 2025 01:05:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3E5D36B0005
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 01:05:28 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D23DB5B938
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 06:05:27 +0000 (UTC)
X-FDA: 84180751494.20.DDA786A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id 07B0D120015
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 06:05:25 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ANW0GNEj;
	spf=pass (imf29.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764828326;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=U0vP87NLn0faqDquxx6n+SX3sJxOtIzohsUBsjHD5P0=;
	b=uv2nj01n0gVtlSD1VdmUHPuvTI1DRMawhzaD7k73Rbb2tzMoS/PVpgCDIlkv791MpuYfxU
	LaZ7RzNYLZ88vuyUCg26IoYcaTaefLF4Dd8tN2MsZSfq07uFKSIkpdhQsZbiU0vFbUd2O6
	XkCaiHM5BF/3Xk78WzYA7bIxJMnVg84=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ANW0GNEj;
	spf=pass (imf29.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764828326; a=rsa-sha256;
	cv=none;
	b=Kpfh5Q++gyn89hYj5BJTZ8QMYnztPQZjXou+wQCe6pvo1DRy7CqbihAok5LraenGIczNrp
	YLim433hkXSIpGuuAud492HjkD1FgO9K1xu2D20K1Jiyq046LDOQgJJINPhdZ0mIM9uLwl
	vGGfbl88r2eGgpJmMIEIgTwQGIeXx8s=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 0DCB943BAB;
	Thu,  4 Dec 2025 06:05:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 704ADC113D0;
	Thu,  4 Dec 2025 06:05:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764828324;
	bh=TpXXIkYEPpVTVHVJr+O1twTDJSV3XXf6h+Qq9iQ/lmg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=ANW0GNEj11i4a6Ie3r7pRyD9O8Kys0m6A3l/sQiqrrmCNOznPZ3dh08TUw73jvkhp
	 6b6hV+XCH4MWmqBUZqIyPGOq6HoD60Jab3Kqax2T/Wbv8noF3HvnWcsfxamhoK463G
	 u6RYYtLDYRCxQ9AY5bYmNyvrMmcQfpDcaW6XdPVE7crtRaSpXKhSF9bc2AfTkFH/gu
	 g5S8Eq5tZSIUFdiXpQwExdBdU+V9LY4euH3A2U6jEucTnl0g5sDS7LFtnx0l5wVc1v
	 7iKZr/Kj2iK3fMgv5nnEF2pd3hsRFrCiYi+wRTTbwShVpEccXYopxg5d8mRPMy1ViW
	 yJjlMIat7swpw==
Message-ID: <2bc690ca-fa57-46fa-949b-28b5441cd364@kernel.org>
Date: Thu, 4 Dec 2025 07:05:19 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Linux 6.18 amdgpu build error
To: Shuah Khan <skhan@linuxfoundation.org>,
 Linus Torvalds <torvalds@linux-foundation.org>, akpm@linux-foundation.org
Cc: Alexander Deucher <Alexander.Deucher@amd.com>,
 Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
 amd-gfx@lists.freedesktop.org, dri-devel <dri-devel@lists.freedesktop.org>,
 Guenter Roeck <linux@roeck-us.net>,
 Linux Memory Management List <linux-mm@kvack.org>
References: <74032153-813a-4a40-8363-cce264f4d5ea@linuxfoundation.org>
 <1eb24816-530b-4470-8e58-ce7d8297996c@roeck-us.net>
 <0425d7b4-76e4-4057-83a5-a7b17a051c54@linuxfoundation.org>
 <ec77d11a-7613-4b75-8c9e-f2bba1595f0f@roeck-us.net>
 <9d520a1d-0b8d-4d30-b29f-230fc0f92b8a@linuxfoundation.org>
 <1f31b86d-283c-4878-92d0-ab90aed0c58d@roeck-us.net>
 <5af4522e-30ab-4eec-a861-c2760cdabd4f@linuxfoundation.org>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <5af4522e-30ab-4eec-a861-c2760cdabd4f@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: ogeguwmx6spdps1rh9rzgkzcztibbfen
X-Rspam-User: 
X-Rspamd-Queue-Id: 07B0D120015
X-Rspamd-Server: rspam09
X-HE-Tag: 1764828325-120702
X-HE-Meta: U2FsdGVkX1+UtvuHLpzInjwdz57lKoV5Qmtyy0ex9qHr56xpck+w4pBEDiNCH9Nh3DcLmom1p+0eWpmag7MV7iopaAcOGOLfM5bf9a/ZgpEYSQILwt2sMVD3M7GcTDDhr/NRHwh1LegqY8TkqXUygE1mbWsuBCbUaQUiWl/fPng+kWUQnyhEwTVwUS/VrQik9PvMj5lzxjNnn3ydS6Ir7EYkOD5ziyxXZMKuj+KAc9F8Cl/zp8uVJ4LF8tgeWdsVmjtNISqJxSlYWp7mSgCOVm2g44zvUKrhh7cUgugjIkP912CK4N8XoeOuBwSlf7BRiFVbbkiQma77QQlb0Qu7ExIaS7IRZpmutVGd6sVW0YvXBN9FmCDENDUf/tZ/TsIN+qrwACCK7AIYBocBHrSHCnJurzZWcDmg/AFx9gi86EcaxEaGYfntkzXYOY9XgvwVLnUrjQUymtO/n4WlEOP5xKJTO8irR3IOJjKAm56qpfMV1DucxBg2wh36U9jgChu6SE1ngjOzsjgPdEA7dGeMDgLu9RXB0WF3OkRuHvWrGRz+k7TV2og1tLEyQcdAG334SpykTX15efuGYA+M1ZiskpxEolWNITdUfY8k9h6CmeCoKPl9Vvt4cGjxiVsH9EoDaT75/X3TfbitJquehTOXrDGU4o5GDf83FcrqMhfMIXI9pTLOL9AlsyY5XKKwHJv/uaJ1Dj1m2tPlqF0EmU6xGEuJNdp5u7vKxV2UvK5uDEsvgpglMAAMHZc4RAyL7r7Hn7LGwBdljwg8Or6PZ+XVuVNypbOagsLf8x26rZ1cfhGaRQ3a9nwiC9dFUbbkwEzPcvApTjuuVYfvTngdGyhAyCAJdJMajI8DWBS6Gbqo2YhTHhe6uPwxe7xyGb8Xj5Ps6oKkHNMMQF59+HEBV+wVCov70BjEuJty8flrLPVhkIN7OH2gVrI6hU6FtFjPZHKa5rICnF4Aj1bIzeaHET5
 I/jdw8yA
 6cJD2AEv9ErgGDcn1ZYvYsZoBiLLnVgoN623fFSo45fy+iZkFx3YRbz6S97LXMgNQa8WJZ2hF7EB/LDS3mgjnb/EPtskvVOB/8PR4s+dI2EiLDE7Dj/TgjhQ78rsEBUQngvMOLnEqdaw98Dw5+sFhhJ25TKqMSL2JIEAXKGrOYTAVKSXHRClrUXHnv1U+kvp18t9G9rB5nXOwsp02wL2F0Qnf3HNmb1Ix5svkRfzJLM8cmkqj/fqE9iyA9RWsh6T0x8f2HKrZm0yaf3AFuj6nNhT3VA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/4/25 03:34, Shuah Khan wrote:
> On 12/3/25 18:06, Guenter Roeck wrote:
>> On 12/3/25 14:16, Shuah Khan wrote:
> 
>>>
>>> CONFIG_RANDSTRUCT is disabled and so are the GCC_PLUGINS in my config.
>>
>> I guess that would have been too easy...
>>
>>> I am also seeing issues with cloning kernel.org repos on my system after
>>> a recent update:
>>>
>>> remote: Enumerating objects: 11177736, done.
>>> remote: Counting objects: 100% (1231/1231), done.
>>> remote: Compressing objects: 100% (624/624), done.
>>> remote: Total 11177736 (delta 855), reused 781 (delta 606), pack-reused 11176505 (from 1)
>>> Receiving objects: 100% (11177736/11177736), 3.01 GiB | 7.10 MiB/s, done.
>>> Resolving deltas: 100% (9198323/9198323), done.
>>> fatal: did not receive expected object 0002003e951b5057c16de5a39140abcbf6e44e50
>>> fatal: fetch-pack: invalid index-pack output
>>>
>>
> 
> Linus, Andrew, and David,
> 
> Finally figured this out. I narrowed it to  to be the HAVE_GIGANTIC_FOLIOS
> support that went into Linux 6.18-rc6 in this commit:
> 
>   From 39231e8d6ba7f794b566fd91ebd88c0834a23b98 Mon Sep 17 00:00:00 2001
> From: "David Hildenbrand (Red Hat)" <david@kernel.org>
> Date: Fri, 14 Nov 2025 22:49:20 +0100
> Subject: [PATCH] mm: fix MAX_FOLIO_ORDER on powerpc configs with hugetlb
> 

Unsuspected and confusing :(

Let me take a look at reply on the revert.

-- 
Cheers

David

