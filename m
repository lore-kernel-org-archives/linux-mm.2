Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F11FBCA9ED1
	for <linux-mm@archiver.kernel.org>; Mon, 12 Oct 2026 10:53:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 04AE66B0088; Mon, 12 Oct 2026 06:53:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F3DC06B008A; Mon, 12 Oct 2026 06:53:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E04FB6B008C; Mon, 12 Oct 2026 06:53:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B744D6B0088
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 06:53:19 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 38BD7A89E4
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 10:53:19 +0000 (UTC)
X-FDA: 85313662518.22.C24258D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id 71A28100003
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 10:53:17 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Q5EVE02N;
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791802397;
	b=E/9dP+zazjuuXJzox4QaHyyMCdW4ALl1F/Y3H+T/8k6UrcjQbBeKSy820lclGYwu0O3yKt
	Ku75NK6XEVK+YZ14R5S9R5UF2S8hhRKa6B2QIdr4WU1D2NAyL+HpQMjdGAvYvH1XlyPIFO
	1mBKAvEckgI6LvWT1bFQb7lrv6DcVXY=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Q5EVE02N;
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791802397;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CC57uKcDR0yMt0YX70szlcAbUkKDMnCloDnAJYvGq2w=;
	b=gIt9zS5rRoN0R52W8wYtqULW2BdXDqwHSJ5vmHn9dclVeAU3Tm4blM/YU7USte99ksTbD/
	UskxDjz1aABbGg70KDMBM7KvFIUWldN5EKMhil2TW0dUXg+geiHYeCCBExftysQEoypxTo
	+H05kk4rA3M9vSdJGN6+46oGKwMF2G4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id E2AA060210;
	Mon, 12 Oct 2026 10:53:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4ABC51F0089B;
	Mon, 12 Oct 2026 10:53:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791802396;
	bh=CC57uKcDR0yMt0YX70szlcAbUkKDMnCloDnAJYvGq2w=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Q5EVE02NohPnIUih3XOl6WsHQMSjW28zaZUVSzyxg8aLIyULRakHHfy2HnR0T+FhM
	 cyLCoNeyGKyB40/mtvF8sYKtdQRZAGF7vpt3NVcAgG8D3TQ3DlZtXlVQSyO+Ufpv9D
	 +T+weqMCN2uunVDg2k9qh1XENWvtCtR3ul/hDGWH6yp/QDrSFX5krakKqbScPulhQU
	 C83TJ9PQviF84jPmnpsekyl4egL4QBIvrcq8v9J0uT+CFTSYwetpd4T0XORbAhSXwa
	 /dSXFUMLplr98tjwU1dXyNcMMZhX5AUYcDzz+fxs+8lUGsJ+HwIKZZTA7+U+2oaxVa
	 fWxfDeiB3tgqg==
Message-ID: <b971a37e-9425-4acc-b868-682cc9480273@kernel.org>
Date: Mon, 12 Oct 2026 12:53:08 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 1/2] selftests: run tests on nommu architecture
To: Hajime Tazaki <thehajime@gmail.com>, linux-mm@kvack.org,
 liam@infradead.org, rbm@suse.com, akpm@linux-foundation.org,
 luto@amacapital.net, brendan.jackman@linux.dev, liuhangbin@gmail.com,
 corbet@lwn.net, kees@kernel.org, ljs@kernel.org, broonie@kernel.org,
 mhocko@suse.com, rppt@kernel.org, shuah@kernel.org, surenb@google.com,
 vbabka@kernel.org, wad@chromium.org, linux-doc@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-um@lists.infradead.org
Cc: geert@linux-m68k.org, daniel@thingy.jp
References: <20261006085642.3852152-1-thehajime@gmail.com>
 <20261006085642.3852152-2-thehajime@gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261006085642.3852152-2-thehajime@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 71A28100003
X-Rspam-User: 
X-Stat-Signature: 3b5xwn5koyurbk9c3z8ojqp7uer7pswr
X-HE-Tag: 1791802397-544715
X-HE-Meta: U2FsdGVkX19PecieZp4Pva9+JkTB7iE5/vU54zf6NUDSlS+p1U7OBw42o/KTrAWSiUGwkbFb5dVyMRcrRlYMgrp5kf4K2CJuuxH250R8BaKr12WwNEunFmw83d0BhPdr4GQUg0tYGqhbFxWA3xjjQ4WTKYA/CSCgw0t3VJh3gIG0DCF1AmrqE+ndmFM0z3qLJmlt1t4jB6YrtTIykGHhqpipl7VdILo9T558Afm2UIu9arspkseimR6Di/UgE1T/itFKDeKUJdf9gCaSdefJtMLso7eyfmHv3IRmVqA0zrYJHugDc+NHFHlxklYaHvx/SeSolGOQ6rI4zkutVJMz9uPUw042lNZoD0wnQHcWJ8KfjQsGhYO1K9IAVmWq24wotfafcaXMynFt1bVaAQvcGwqXS/e01ExvWgiccqh4Q3UvvOilLpUy10dEOj8AZOUAtmbXgDPvKVZew4/N6e+hFVMiLNl1RE2tOHwTOu1An/zMc4t4Y3Tb9sXYEiFsh3BcvbRJMGCEYRIMpdrO0IEzfgUf3FySs7zqhyERKTg0R/SjqdEN+F+rl0xsOY41gHfyr2bYVrzMndJdOABeXD2NQ4+mdXKM3gAzNPgGNZy3cYgBvuEuDCtORWVf2oNTyz45ghlUcyNQFD8TVxcFLzyQ30/tLinAGIkPtLawud+LmMlaRxau9B2MU0HezDIAPmbIrYkO28cly31gShuW/SDsV0E6HHKGb4NZxharZCd6/JROi5Z2ff6ijKRPz88wbrBufawX0nmnOe8e+Ht5rk8GGomrkNK/f1VwaIL+8lYKJd1nTxA3cqCVs97ZW1eDs9BBMcozl7nk8TahXs6fvokuyKNYCxHtIiSqM7fT4rr9EEaHgPv8eYRp2GRyYRJTK91ZiXKNR1/IKCI8xFtaj9bTn6WuBx+2punv6Qb0u8/z4PkCW3lTB6ANMwCMcyvQpR0kNy5PkckKZVetx5+SzZ3
 9Irwm1Tc
 vCPA5234FVzHfhT4cUyNN1gz8mClP5IdGV6hOFZw9h0IkupnBp88h/RVXrn9ZJvJLAyeQyIb8jzi3K/X2+qCZ5xMwGaQ/wY986j6wDxGJ2KAUt5C+LJWomnEyJsGQES/Vpi7TjBsHqJLRlgHb+X3bDlGE/7VPNUfb1j8noWthpi18agyf7u4bdgRyohVzg5+FHmmpx6RKOkojev3oFhBWRduMg6E0lIZGd/2VgYSkct6uDF1Obfr9wH3E8pB5DL7OYu2pdg0HzamRNSV2aIBlju0PXQKb5ihLCTGRkkVpBZhIzBjq99PZlaSfTppnNi9Ty0FOL+lX7ivr6FAg/NYs37vfRRA38nzw6cjH3HosGA7CFzzzJMXeg3xXUhzTtQJrinhw6HSDFYzhnC4PLQqcx8uD0Nz36S+8aRfi2cqmpEu8CVbMJ/jJF0yEyM5q0XjaeZMZinVa4sVTHHRxbqI5cimOVgXoVGGhBGs3W/tMzDQN8yQPTkssSL2VImoVXKiC8DwDVfZTIOYlNzxXgaGG3pZ39B7H4eGl8LwXnpa4qoX0RHmekgWBm7VWhmH7u4PNJB/Z+Cql35doEou+VeDvNmOqU7tJKWYpz89gDv6OF542fUkSRC5T21HhLdiAbzQBUQuYN9AI4/ueEQUDrwttebNMhr7Fm3/pQdi8XqZpTDnf5CD1daNewzBFoA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/6/26 10:56, Hajime Tazaki wrote:
> Architectures lacking MMU don't support fork(2) syscall and only
> vfork(2) is available with limitations.  Thus, we cannot run kselftest
> on nommu architecture as is.
> 
> This commit addresses this issue with the following changes:
> 
> - Detect NOMMU at runtime from the MmapCopy field in /proc/meminfo
>   and avoid timeout, which requires fork(2).
> - Document how to build and run the NOMMU tests, including the procfs
>   prerequisite for runtime detection.
> 
> Build and run the tests with:
> 
>  $ make ARCH=um O=build kselftest-all TARGETS=nommu
>  $ make ARCH=um O=build kselftest-install TARGETS=nommu
>  $ ./build/kselftest/kselftest_install/run_kselftest.sh -p -c nommu
> 
> Cc: Shuah Khan <shuah@kernel.org>
> Cc: Jonathan Corbet <corbet@lwn.net>
> Cc: Kees Cook <kees@kernel.org>
> Cc: Andy Lutomirski <luto@amacapital.net>
> Cc: Will Drewry <wad@chromium.org>
> Cc: Mark Brown <broonie@kernel.org>
> Cc: Brendan Jackman <brendan.jackman@linux.dev>
> Cc: Hangbin Liu <liuhangbin@gmail.com>
> Cc: "Ricardo B. Marliere" <rbm@suse.com>
> Cc: linux-kselftest@vger.kernel.org
> Cc: linux-um@lists.infradead.org
> Cc: linux-mm@kvack.org
> Cc: linux-doc@vger.kernel.org
> Closes: https://sashiko.dev/#/patchset/20260813063401.1786548-1-thehajime%40gmail.com
> Signed-off-by: Hajime Tazaki <thehajime@gmail.com>
> 

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

