Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A0BFED29C2A
	for <linux-mm@archiver.kernel.org>; Mon, 19 Jan 2026 13:30:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D7BCF6B01A2; Mon, 19 Jan 2026 08:30:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D45FF6B01A4; Mon, 19 Jan 2026 08:30:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C73A56B01A5; Mon, 19 Jan 2026 08:30:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id B58476B01A2
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 08:30:54 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 533EC1ABD59
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 13:30:54 +0000 (UTC)
X-FDA: 84348798828.05.B0D5EA8
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf22.hostedemail.com (Postfix) with ESMTP id A89F3C000B
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 13:30:52 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=none;
	spf=pass (imf22.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768829452;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1P1nE/rAtWRsTJFlGlwRPm+3eocw/OOTCUMKzo5i0+c=;
	b=128ZTYELdsHQDy4ozB3/6kSklp8tMyY1rmkTsdDsx6DDGYin/u/D0fyD0/jE/MLxzXWOrT
	ibF73mZURjPd5tH+hw19Xtnqf3QnCTOs/q9VfVxydQzqUoiJVD+GtqBEu7xSjro3yz5WTH
	mxtl+zxhJF7ooyzB4wYF/V9fidu+7mQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768829452; a=rsa-sha256;
	cv=none;
	b=MvCP/asElPOik4vInALYSBRoMRYkHmtRfcxTPmo6XBSlJ7b+Pg7toHRCG+goyLnKDLs0MX
	BohsjbdjacmdOXJB85bKVpCJnCf+QqLFvnFgLdbgzO6xK7YUpWXYnDDJnnx1wuhYGI/PSj
	RKQuKObVFF8mWf3/49iERml+e1f/Cr0=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=none;
	spf=pass (imf22.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 251F8497;
	Mon, 19 Jan 2026 05:30:45 -0800 (PST)
Received: from [10.44.160.85] (e126510-lin.lund.arm.com [10.44.160.85])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 39B813F740;
	Mon, 19 Jan 2026 05:30:48 -0800 (PST)
Message-ID: <a78f2fdf-ef4d-4570-b592-b2943b6ac06d@arm.com>
Date: Mon, 19 Jan 2026 14:30:45 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 6/8] selftests/mm: fix faulting-in code in
 pagemap_ioctl test
To: "David Hildenbrand (Red Hat)" <david@kernel.org>, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Mark Brown
 <broonie@kernel.org>, Ryan Roberts <ryan.roberts@arm.com>,
 Shuah Khan <shuah@kernel.org>, Usama Anjum <Usama.Anjum@arm.com>
References: <20260107164842.3289559-1-kevin.brodsky@arm.com>
 <20260107164842.3289559-7-kevin.brodsky@arm.com>
 <cd9e1fca-81ef-4eaa-aea1-aac6dd00623d@kernel.org>
From: Kevin Brodsky <kevin.brodsky@arm.com>
Content-Language: en-GB
In-Reply-To: <cd9e1fca-81ef-4eaa-aea1-aac6dd00623d@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: A89F3C000B
X-Rspam-User: 
X-Stat-Signature: a77swocu57greuzshkojz43dc4j3ct5g
X-HE-Tag: 1768829452-287887
X-HE-Meta: U2FsdGVkX18Nia42JlXvOIk9TTyV3lCrnKx5qcRaRXXMvcGjLeiQQUzI6PeLC6eU9rY0H/I4IezcZSgQG8LgxvfbXLI3RTc6Grz/1XQmEHtNRfQHbQQ0inj2W89VIv2tAURAoe2bm+xxJDasbOZVMhr6IBT8+OS33GJIwSCvpH1Qp4yoWMrtlprJN6xjhqZVdSBD8Hb+P97t+UBF21y9XzYVPsrZBd1tW/6x7F+cEgkOBjcH42rYMOJ6/R+jfAFQxAgCA8mhixmLBboJZHi81cJCEiHJpwwPDNqiE4m+XpOFS8CURqkIy3w8WEIQlJK7iswSejm46jk7MU2ekyjvWrLNgXpKCNXtsuYmIziVdge48jXYm0vnH2rvNtJgWs5zW3OToOkq0VyIstiONlrdHZd6kHoLEdYbKrF8d9iSCPeq8QUDAcuA9lgGKvyCht1N73/njBQU1X1fen9j//OWaAUElGgyREKm8iqML73UtoMx47BPDeKDN0jgzKqqUFDd9/5TQ+wyuJxZykP0wz6d0pXj7RCeWZXJpQoHoa4xu7LPDruI23KFGHbPl/vxDDz9MCRXduDspre+Jp35ag1tJXLUBG+GddrHMkbMUF4DlV8jtnZ8Q/Y5Lm7pswda3aniSRuqwakft580nB0pj240xGGAoRC+QooXWL8pe+OTK/SybRnsZrlL/YI/FHsqJCxQAONfMU7PiCdxPd/ZnA6L/znTO9ENHL3uiuzFnvJ4TTwaH6RC/VBdXqUVv4/z38uwX0S5VGiXBPdFkibzHcJ5VBZU94pGzInpeMlHMtkOSu7S0JJFm3wQNHSjtiaWh0t8F36luSWP3esk8QMAXt9+CCnPiCBOOD2oZJicWd7txz42vtff5pjWHV5lq82GDibECnIe6X1hH3TXkTpt57+j2bR9x4OYa6T5YolaZ714e26VMkRlVePVJquhvvYh0mVWOt7wfNJ7aCWIfJRgKMZ
 nWn5IhuV
 ny1docAPbbB/7nuYr/tI3XTynO9mhKaUq+DQIHxhWKK1BbF/+ieQmxr8FJvHUhQlf+MzTRgehFjQ5t6EpWt6JpHvcSoQGAB4CFkUWEvXnJ4t53UozH6iMiaeceXlbAJHU/4fSAd/sJAUKdYMub3pEiVpg4AdxACVEMl0/+WkmYrqTS+3gbMUjnhZZp2/YPTuDKJNtEltazGATwbQrK56Iw5Zijg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 19/01/2026 12:09, David Hildenbrand (Red Hat) wrote:
> On 1/7/26 17:48, Kevin Brodsky wrote:
>> One of the pagemap_ioctl tests attempts to fault in pages by
>> memcpy()'ing them to an unused buffer. This probably worked
>> originally, but since commit 46036188ea1f ("selftests/mm: build with
>> -O2") the compiler is free to optimise away that unused buffer and
>> the memcpy() with it. As a result there might not be any resident
>> page in the mapping and the test may fail.
>
> Yes, I assume so. Using FORCE_READ() etc is the way to go.
>
>
> Should we add
>
> Fixes: 46036188ea1f ("selftests/mm: build with -O2") 

Yes that seems reasonable, the test was arguably broken to start with
but it is this commit that revealed it ;)

- Kevin

