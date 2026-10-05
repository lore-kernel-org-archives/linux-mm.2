Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B2F82CA5FF0
	for <linux-mm@archiver.kernel.org>; Mon,  5 Oct 2026 14:54:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 45E946B0088; Mon,  5 Oct 2026 10:54:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3E7B86B008C; Mon,  5 Oct 2026 10:54:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2AFCF6B0092; Mon,  5 Oct 2026 10:54:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 04D356B0088
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 10:54:06 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 89A3F1C21DB
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 14:54:01 +0000 (UTC)
X-FDA: 85288867482.13.4637D9D
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	by imf17.hostedemail.com (Postfix) with ESMTP id 828A64000B
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 14:53:59 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=alien8.de header.s=alien8 header.b=Be1sCz+n;
	spf=pass (imf17.hostedemail.com: domain of bp@alien8.de designates 65.109.113.108 as permitted sender) smtp.mailfrom=bp@alien8.de;
	dmarc=pass (policy=none) header.from=alien8.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791212039;
	b=C0AR0mQ7lPhxGIL7vJ8wycI63REtHCOwBpJu3LE8P2OJ5Bdflh6+APfxtxSefnRtDzlX/g
	EBgOSZQTRsDR/Cj3z7QCgDBkD/rsEc6zaX3zbF03J53/oSHD0BiczAHNjZDtvJALLF80Bt
	f6FLfATWtwjRjfInZVIxRXLrTobBREA=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=alien8.de header.s=alien8 header.b=Be1sCz+n;
	spf=pass (imf17.hostedemail.com: domain of bp@alien8.de designates 65.109.113.108 as permitted sender) smtp.mailfrom=bp@alien8.de;
	dmarc=pass (policy=none) header.from=alien8.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791212039;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QCTRJrRSMliG1y0HI1fW1TaWT0OQqIRjC93mDJT/OgM=;
	b=k7gCM4KpKOoK23yhhsys7AKfpUi33tf7tGp97rpN2kc2TkRGU0kPSmrRGG6aCjJWeSbIvL
	uXianyY6R/Fy2H01FT8Lhf6nYEnak+qvb3QJ9kfdNWKH7mj6iDY+nIc1Mnl8bSUsaawkJU
	AnJSrbGJMk0aytfKV0D7IwVR1KDZpuE=
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id B517840E0486;
	Mon,  5 Oct 2026 14:53:56 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id GxC8E64juKXb; Mon,  5 Oct 2026 14:53:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1791212026; bh=QCTRJrRSMliG1y0HI1fW1TaWT0OQqIRjC93mDJT/OgM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Be1sCz+n5/PAMGPvHEB0svqS2EoG27rxXqpG4h78erSha+p+OCiqwepOJAPQPAu4g
	 GUbUIy8uSvkXqVm3yCBFxq6xHimi/UGXuKb2wxNwYzW68ygz2vKjTJMcWpBsSySto+
	 LoMRSKwM2dbGKMvzncFVNTxfVdSeDqzN13ZsOqamzfuyHloJxlaHfoYrPr9u7eu/rw
	 y57EQq151grDPU/ZYMAd2tdLVJL2f1cTC5nwi4IS6etBo+5fdmNH0FGJVy2GwNWJpk
	 spwPYvDmqj/YWQe7Yl673TlJ5WH8yMFEt/ISMbWtoc6oBuMITsn9S86xO3WlYiwbp3
	 Q3r6zp0lwujc9TDSvjjTISJFAlRCKLNkSRb9N95Fjsn6Qe3mf/Xv7//VrkWWTsJRIo
	 sGjrJxRb1GPIEXv9bbsg5cEr2cW7M/SiKwR5kZTB9Spa2l8jQXtwezQd4G/dlSM7pt
	 UU4MKj+17mmykJf4BbgnpZcwDRJafjPzbWZgFnLcmMLXDb9eSMBPUEHxIbZwGE4GwQ
	 GItF+o3akWdEuxVgoQNR7Z1Mbnj5fyH4SPsgvPJOyKFAXCsNOyUDrw+HjUD1Ccglvd
	 hhqJUNYZiByb3jO2Y13o/ZUkSMUAP7bBtwGni5IAdnDvp3FlIbPe26/lgNln1VJGoy
	 dssko10C2ca+xKh2FY3yV1ug=
Received: from stx.tnic (unknown [IPv6:2600:1700:38ca:c00::3a])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id ECE5940E02A8;
	Mon,  5 Oct 2026 14:53:18 +0000 (UTC)
Date: Mon, 5 Oct 2026 07:53:15 -0700
From: Borislav Petkov <bp@alien8.de>
To: Lance Yang <lance.yang@linux.dev>
Cc: Andrew Cooper <andrew.cooper3@citrix.com>,
	Pedro Falcato <pfalcato@suse.de>, dave.hansen@linux.intel.com,
	luto@kernel.org, peterz@infradead.org, tglx@kernel.org,
	mingo@redhat.com, x86@kernel.org, hpa@zytor.com, riel@surriel.com,
	linux-kernel@vger.kernel.org, qi.zheng@linux.dev,
	nadav.amit@gmail.com, thomas.lendacky@amd.com, kernel-team@meta.com,
	linux-mm@kvack.org, akpm@linux-foundation.org,
	brendan.jackman@linux.dev, jannh@google.com, mhklinux@outlook.com,
	Manali.Shukla@amd.com, mingo@kernel.org, stable@vger.kernel.org,
	toshi.kani@hpe.com, david@kernel.org, mikhail.v.gavrilov@gmail.com
Subject: Re: [PATCH 1/1] x86/mm: fix incomplete page-table invalidation with
 TCE
Message-ID: <20261005145315.GCasO523MWyIIx2ngl@fat_crate.local>
References: <20261005052302.43042-1-lance.yang@linux.dev>
 <asM7b8ECO34-jiwi@pedro-suse.tail5790ac.ts.net>
 <60d5db86-8002-4d87-b8d3-c161d674122b@linux.dev>
 <ab077b6a-160f-41a2-a167-813f0560e30d@citrix.com>
 <38541ec6-d796-4f35-a700-75ab097b6df5@linux.dev>
 <7ad90e94-d04d-453a-ba22-9640a5024d8c@citrix.com>
 <6801221a-6307-407a-85fc-46906f95d22e@linux.dev>
 <20261005142216.GAasOymJHYnmn6wD5m@fat_crate.local>
 <de41b083-6368-429e-9928-90aa5440f750@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <de41b083-6368-429e-9928-90aa5440f750@linux.dev>
X-Stat-Signature: w6jqc6q47exr43oynf6wdofi5pwyn15y
X-Rspamd-Queue-Id: 828A64000B
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1791212039-740454
X-HE-Meta: U2FsdGVkX1/ApZ5/UqL8eezAhRFMWcgkz6eZ/tB4nsA5QERp3FSsKWEH+Tjdt23TNES1axrxRCkhqDquD3ecPZvRpSGGMyEKUXM5gTVfszAt2yAiBcq2nS259TO0QebS/lsa+w2WdbG1+M4fI28mT6JsKec7bJoSL0WqzUB1SfvJBbKVR8SRGucHebyXuP7ME+DqXdSw1t6bkJ5whQgYN1Bybc6GKh+1C74jYL1sq4mgJlayL1Ton1X0ouL9RO32r3eFGXzPwotuL8F5R232u3kxYkdEKYdJGD/fcasrM44/GnJLJCo7lTY8hiufjKAYpCuvucVs6hgS/9R0PeDTHXJtuu+ITtX0mlohOXtHTqeE1rjUMHoXdPJTftJ1fQFe1veBvNkyeRzpatGPiRnV/7h+1t3d7RWf95GDIzt3DRndm0dBsvJspBiq2oBZ9qtj41H/5VbCoU3lmQpIexHRwKSvxO7FMj13XSEUHyogDSZwjL3mkv83ZS5Zg4yolIsEbIefO0dyAMu8HGfYQt3iDJaxNiDSx3BZ7EuAKOWa3JcNwq1G5VEssR4hQJal9ZQovfjCREeM7hqTyAMqIJCjkclLYlc745GMAHDgFvsMjSU0ngy/7HATXWhz5LvtcyjFzyf0PKrflIiJmnQ4I0WqZ+r8I29W/sDpWoz0mzBwmIRWBUfvm9wOA7UgDZB0lhGkri79pW2IzeEshp1UAQ/mLcbfdnzsbKnGb5u9Cd/jyFQGXGZlki7RgOAKO8RtJYY8LSowMqXAbw6DqQmnJPxhVjHuk77zH6llI7mucVdyoEiqL9DCpRnpo1a+w5tY/Di35MnETNapUblhcwpJYDh71Ap+3Lnr97e99mGCYhXzzEFrsjIQCVJV7B/XyU9IMsFPaEqUk2iN13XWwwALX/chIlcYTKiZzadNb21jXSjMPDwTAnQM6qpsqR9d/4vvZZog6KQJK6eW/3Wrt/t2UMK
 dU5DsUFX
 pLQ+P0ZYaAlCW+xvGfQmmrfq8HWwR2rVIMotiIbChj/HwEZCXCyZk6lk9oIgxj1qwkmULYm4dpciefR6/egqUrnGyEXm1LaWXwxa7QUDw1+uoVeZA1v6eMD/kxnyWbfta25MGbfIaCasWz9FfWDwahpBU+wujJVEbNcMHgU/RL1pJVf5XI1+lAP+IydbK/4B6upx3sHudmufCkCdqw3YFZosQ6VPqXczFSZ60Zn4DExDGmECwGZ5vxQz8Ik5U3UWE7ijAPBrFtWn+oAKZ5Ps47bmbaXrpDqgidzNocwR0SZ3Qr0jydnbEH6rmexg+uE9pNzc5s36EV8zd2XP18wpbhi0Dl/JO6M590UXYpyfFYWnmTuxQjMLNoNATpWlhaIja1yB1xunHPnLFW70dwnfcTh9Fgg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Oct 05, 2026 at 10:36:26PM +0800, Lance Yang wrote:
> I don't have an AMD machine to test this on. I spotted something
> that looked wrong in the code and sent it out to see what others
> think.

You send a normal mail - not a patch.
 
> Maybe I'm reading the manual wrong, but is raising a concern
> based on the code and the manual really just "a wild hunch"?

If it is formulated like a patch which is supposed to be even urgent, then
you're reading our process wrong.

https://docs.kernel.org/process/development-process.html

And since you have not tested it to actually fix anything, then this patch is
nothing but a wild hunch.

And to answer your question, no, it is not needed. Definitely not the TCE
angle.

Now, the speculative thing is another story but that whole story you're
referring to needs a lot more debugging.

But we do not apply patches on a wild hunch, without any definitive data that
they fix an issue and, if very much possible, with a clear explanation why
they fix it.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

