Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 20385D72345
	for <linux-mm@archiver.kernel.org>; Fri, 23 Jan 2026 08:01:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6EBEE6B042B; Fri, 23 Jan 2026 03:01:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 699536B042E; Fri, 23 Jan 2026 03:01:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5CF1C6B042F; Fri, 23 Jan 2026 03:01:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 49B146B042B
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 03:01:17 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 049631AF7EF
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 08:01:16 +0000 (UTC)
X-FDA: 84362483394.03.4D9B59A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 28ABD40015
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 08:01:14 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="Krs/YL+k";
	spf=pass (imf12.hostedemail.com: domain of mailhol@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=mailhol@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769155275;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=L69DbREXIPbGz4DtTnsvKlPccKUoMA6Yse3KHmYUO2I=;
	b=sKwT/h0Zx28pnUwcZfGl5u2JSrrHqUCsrwfVT4iA+znrlGVHvNaldfM9+BXvohljXuRt8C
	QsNmI0yhuZvaIOr32UybHtNze6oIzBp9/zBXJr+OG4jaw55R/gR7TNE6eUsD5v38y8w8/I
	AyJ3zvwKPD0ZR7KRyzK42kBmmJDn/2U=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="Krs/YL+k";
	spf=pass (imf12.hostedemail.com: domain of mailhol@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=mailhol@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769155275; a=rsa-sha256;
	cv=none;
	b=rIKNg8eKQa2ggW78rjcNyNVSSTQTQkXzUrHElwDiaAM/uQcdASJoo3d1qycOPTxed3F7Gb
	Z6AlofweeRMDeYhoKNkHyY7TFsTFSW9aH8ETVYCpWT3UuoqAekOS/NVxKF3plo1V+l+GjX
	ESpKQPrIOlC7gyD5PaHD686x4bbeMM0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 154C44370D;
	Fri, 23 Jan 2026 08:01:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EC51C116D0;
	Fri, 23 Jan 2026 08:01:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769155273;
	bh=jA0nIGlSFCoO5clU2/Vm0KGTikWt2SZVuYyg1s8QNsw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Krs/YL+k4dMDFZGOntJwBxp9s1aWP7XzQN3y5A5IVHdmsm2Cn6o4ohWo9dOMC2zs9
	 gN+VJSV4vFetiAhLEpX1INcD8zwF0eb9rQJugBxR+0kPA+tgUwBsAp4E/y/qh6mMLy
	 /oeajz+f7+8iYhYzD7+Vuy65lFsIvZ/BJGL8nu+XCSIOOQLN25RRknJfuO2WqxXh6S
	 3jq5X5brp+aVTbUycm0Um0YE7CDqcX0DGzsalepQxnrKS+uvn3J8OFSm2OiBNxN96i
	 DTQbuMja9W7oLxMBYp7l6t6IgjDKsuEurEdZ9Tx+3EyE/j+kXDWAOdLTeGBnxLRIMs
	 iro7ohwYHD2/A==
Message-ID: <b49c9993-7676-4d33-a2d6-9f6b77b0fd34@kernel.org>
Date: Fri, 23 Jan 2026 09:01:04 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH next 11/14] bit: Strengthen compile-time tests in
 GENMASK() and BIT()
To: Philip Li <philip.li@intel.com>,
 Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
 Chris Li <sparse@chrisli.org>, Al Viro <viro@zeniv.linux.org.uk>
Cc: David Laight <david.laight.linux@gmail.com>,
 kernel test robot <lkp@intel.com>, Nathan Chancellor <nathan@kernel.org>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Thomas Gleixner <tglx@linutronix.de>, Peter Zijlstra <peterz@infradead.org>,
 Ingo Molnar <mingo@kernel.org>,
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Arnd Bergmann <arnd@arndb.de>, linux-arch@vger.kernel.org,
 linux-kernel@vger.kernel.org, Yury Norov <yury.norov@gmail.com>,
 Jani Nikula <jani.nikula@intel.com>, Kees Cook <keescook@chromium.org>,
 Andrew Morton <akpm@linux-foundation.org>, oe-kbuild-all@lists.linux.dev,
 Linux Memory Management List <linux-mm@kvack.org>
References: <20260121145731.3623-12-david.laight.linux@gmail.com>
 <202601221237.soiAkwkN-lkp@intel.com> <20260122103337.26473d1c@pumpkin>
 <aXIzpC6wpdv47cSH@smile.fi.intel.com> <aXLOELiIG8MHKcIO@rli9-mobl>
From: Vincent Mailhol <mailhol@kernel.org>
Content-Language: en-US
Autocrypt: addr=mailhol@kernel.org; keydata=
 xjMEZluomRYJKwYBBAHaRw8BAQdAf+/PnQvy9LCWNSJLbhc+AOUsR2cNVonvxhDk/KcW7FvN
 JFZpbmNlbnQgTWFpbGhvbCA8bWFpbGhvbEBrZXJuZWwub3JnPsKZBBMWCgBBFiEE7Y9wBXTm
 fyDldOjiq1/riG27mcIFAmdfB/kCGwMFCQp/CJcFCwkIBwICIgIGFQoJCAsCBBYCAwECHgcC
 F4AACgkQq1/riG27mcKBHgEAygbvORJOfMHGlq5lQhZkDnaUXbpZhxirxkAHwTypHr4A/joI
 2wLjgTCm5I2Z3zB8hqJu+OeFPXZFWGTuk0e2wT4JzjgEZx4y8xIKKwYBBAGXVQEFAQEHQJrb
 YZzu0JG5w8gxE6EtQe6LmxKMqP6EyR33sA+BR9pLAwEIB8J+BBgWCgAmFiEE7Y9wBXTmfyDl
 dOjiq1/riG27mcIFAmceMvMCGwwFCQPCZwAACgkQq1/riG27mcJU7QEA+LmpFhfQ1aij/L8V
 zsZwr/S44HCzcz5+jkxnVVQ5LZ4BANOCpYEY+CYrld5XZvM8h2EntNnzxHHuhjfDOQ3MAkEK
In-Reply-To: <aXLOELiIG8MHKcIO@rli9-mobl>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 28ABD40015
X-Rspamd-Server: rspam07
X-Stat-Signature: aafotzh7s5qr3yg57e6gewzy369amd79
X-HE-Tag: 1769155274-159281
X-HE-Meta: U2FsdGVkX188eYnw2OZBGAV1ijuosfLug5BIT4IjMBZlmWTYiRjfZ//p8zCRUA5gf4JYTruN9FBbFu/VzvuOxhUrw++HTuzRlvTkJK2hVAIAR1sGisTrSYU42iXEItUIbbhZdPRxoPzqpytm3ttSbnMetqtXmUitQLh1ZgdQIYprFMEJHUrMzxvJEQIDkvgTjvawsHBihHVRr6MLWW4TzKkfuy3uusJXbG4hoi8NBYQslfIhYsGaCHi28FsS5Ui6L8h85FWTa7rJB7oMc15D3UvRKeo+o/GKGp7tJoIMInPKFkEFFKVmN215ZG10B4zQhLhfIX286NBu169XmlToFpxk8mhvuoix7vWUHEG1pe5AZzZEghwIueyobSy+xDsJI3YToWvyVLJmJQV2YHTwS54hg1fOK5Acwwn7U7fCotDyO4KdHpP9lwiPAUlJBzfzkZtv13kj9HycXO3A0t+iMxKFf5WGMD65uJxFebP+yCm83Pw1Vs1WDaQ7Spr4jk9mWzovqzEdNLATKfQt0KxyXol2OUPWIXRBTfiBa4EuQ/SZHztcqllDTwTHFSVrYZgoFd+NHSPreXHDk4mmmWA9SrSVicHwB0MDcOgJ62MO59qPRwxOBC7bNrlm4i6jPY0i80GAWbFVSSVhCEheNSFO1QUzm+rHfM9aZ02Usr5ldhTZY212AR9vjrXX7QXU9HyDV+zzZ3TQ0UBMtAOFsNT3VpcS3oafw632XC/7Ir9KgzPW5byPGzIbtiN7R70VnpKC8yhU46k/DIdoVkTReyFRmy/6gFye0Q8oA9AMxcH2u9TAJYyQ0ts7iAPCTXZpkK6eFYJ0sskfTp9L4dEGNiDuYrK04n4x0RI8bEMYsUWI95NXjeufxsOMk2IPRO4WumZsHsooKUJwFEfPI0UJz/m0lYuVUry7eky5R4zdjxXYK/sjcoxE3JgB1w3loz78fVC7vyc9NrUHwHuSXrygh6K
 pj9lFphP
 OC3bPa+N06lwdRpXEwc9norrC1nDCnYW9btChKBSgGddkc2xAqX/LOqj2RmJ+fXWZ1rhXQ4p0d4pTufGPDi6i6zyFqakZBuIDhgHcN9wc1rUt5ooqB8cfM7jl/uZfc8ON3zTxV30ODb7La21LPNHC/IMqbwadieCozuuMY99BpLWmNPvHkUrJiYiodoAhrqYkwhJkyWtkOKaVXaWiG6LDoVuoHAuv9nmJmtC2VQfAo5iGieAvhGXdvnrFDZr/SOoEVzmSaU8B/kDreMUwsxZErX7oITRLUcUv+DLzY/FSOgl5CGAZhzU+2KmPtni/fqd+1kk1ogrhqKrRiu5VbiXmoyHfKS/JcBLTXCT2
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Adding the relevant parties to the discussion:

+To: Al Viro
+To: Chris Li

On 23/01/2026 at 02:25, Philip Li wrote:
> On Thu, Jan 22, 2026 at 04:26:44PM +0200, Andy Shevchenko wrote:
>> On Thu, Jan 22, 2026 at 10:33:37AM +0000, David Laight wrote:
>>> On Thu, 22 Jan 2026 12:41:22 +0800
>>> kernel test robot <lkp@intel.com> wrote:
>>
>>>> sparse warnings: (new ones prefixed by >>)
>>>>    kernel/kthread.c: note: in included file (through include/linux/bitmap.h, include/linux/cpumask.h, arch/mips/include/asm/processor.h, ...):
>>>>>> include/linux/find.h:209:45: sparse: sparse: Variable length array is used.  
>>>
>>> Can we stop sparse complaining about sizeof(VLA) ?
>>
>> First of all, the LKP should install the fork of sparse by Al Viro. That will
>> fix tons of warnings that are related to modules and speed up the process
>> itself.
> 
> Thanks Andy, i will switch to the repo from Al Viro for sparse.

Al Viro's fork just adds 8 commit on top of the upstream sparse repo.
Wouldn't it be possible to just merge those?

That would be much less confusing.


Yours sincerely,
Vincent Mailhol


