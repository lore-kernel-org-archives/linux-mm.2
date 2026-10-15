Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 952CDCCA462
	for <linux-mm@archiver.kernel.org>; Thu, 15 Oct 2026 22:16:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 72DBE6B0098; Thu, 15 Oct 2026 18:16:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 706346B0099; Thu, 15 Oct 2026 18:16:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6230B6B009E; Thu, 15 Oct 2026 18:16:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3D6336B0098
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 18:16:23 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B4C79A7724
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 22:16:22 +0000 (UTC)
X-FDA: 85326270204.23.2CE71D8
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	by imf08.hostedemail.com (Postfix) with ESMTP id 9666416000B
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 22:16:20 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=alien8.de header.s=alien8 header.b=Eal1toxd;
	spf=pass (imf08.hostedemail.com: domain of bp@alien8.de designates 65.109.113.108 as permitted sender) smtp.mailfrom=bp@alien8.de;
	dmarc=pass (policy=none) header.from=alien8.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792102581;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ayvyf0SQKGYl3AXZdZH/iDjIpOIVCOpr/zIAFrXxluE=;
	b=aJOs2GbQq8AIN3vcQB6JO+ZUObqGWxc0o22LuZOx0MteGSW52ADVXX9TM9zd9bsOYU17kk
	JU+1K5snkn4kLlaD+64Tz7EQs4GtBAbIjI4SeawdhenSXEDpIWgQyvLOjV1CF9YKUWLZhc
	IBPInTEw/7m3qi0LUiczX7NWl3EKNXM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792102581;
	b=NaaSkNTIHibfuYMQ3Lf1hrBF+AggYC2NgdeGpldidVao/Ssf9K43cCIE8+TAQ0iTk61BVJ
	lrfGwGi48dfuzlGtLF/8mnxeC9cqqZ0DDs2xImePeonnPoldM1FWgPUvA/0ZQZ6RXTRcFt
	spsJZ+NHbk6ybzN1nrpEUpg+chnrtPg=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=alien8.de header.s=alien8 header.b=Eal1toxd;
	spf=pass (imf08.hostedemail.com: domain of bp@alien8.de designates 65.109.113.108 as permitted sender) smtp.mailfrom=bp@alien8.de;
	dmarc=pass (policy=none) header.from=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id DA03740E0497;
	Thu, 15 Oct 2026 22:16:18 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id 80Z-8B1sJTl2; Thu, 15 Oct 2026 22:16:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1792102575; bh=ayvyf0SQKGYl3AXZdZH/iDjIpOIVCOpr/zIAFrXxluE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Eal1toxdOhCf1v9Vm+kGWIgleqGavTE/aGcf4EiVB+Q40bgDA289jaskoAd3YUkA1
	 2IrrFTCyudrY2/2BbOe6E7E8XvFcGY9qc+TQ01+Gg2OyKU7jxQpNx1qOONlVuJ8pYE
	 LUG/lMIOi61R6fFj9yBKlAtD9+Do2IOG4ZfxZ8I4974KmjF6bzINqNiafklFwvxoSt
	 y0FKlY5+3a70rGOg2mpMzS9EVVmH/JYjWWhuib8II6kgCw1MdOIhV0QU4BW0xZruHv
	 GKF63jRG6C6XoXJ/M0yv2UflPvGboDHXPfwY2YLqZ+BZzdfuR44zMLIOO5MW7JUndg
	 +MT+gAX1+tEzNF24HJLK23YXhzyRnh0UTtQ10lMCfW4HJ2g4JiJHI3qzvzV1Qx8udI
	 IxXN4OpKSX0whvSH7hC4kgYvKhOtdiSVU6iDV4ErF2XwGnRXrplS5hysm0mjeBNdWL
	 B2CzlXNNtTF4dahMZ61zt+akX1j8eI6Y08m8IfXwzaUvGzAKYV6tVQ3j4tqsbgsV0j
	 3EZ3E1MsEBFVKRFW3+buKB9VsK3aY+uh0TRqg7tJ+UjRPTnnbDbD4wH/hHRiJU5Er6
	 BwK8/oQB1SeiaiP8YncOywvuCuQJofV89XLYIrHq6HMH6644D54Yg175kMMz8Y0pLF
	 0Be7nzIerTj69bCLh0W8Npi8=
Received: from stx.tnic (unknown [IPv6:2600:1700:38ca:c00::3a])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 2919D40E047F;
	Thu, 15 Oct 2026 22:15:58 +0000 (UTC)
Date: Thu, 15 Oct 2026 15:15:56 -0700
From: Borislav Petkov <bp@alien8.de>
To: Nikola Ciprich <nikola.ciprich@linuxbox.cz>
Cc: David Laight <david.laight.linux@gmail.com>,
	Rik van Riel <riel@surriel.com>, ljs@kernel.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
	david@kernel.org, Mike Rapoport <rppt@kernel.org>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Pedro Falcato <pfalcato@suse.de>, Kiryl Shutsemau <kas@kernel.org>,
	luizcap@redhat.com, pbonzini@redhat.com,
	Tal Zussman <tz2294@columbia.edu>,
	Matt Fleming <matt@readmodwrite.com>
Subject: Re: hunting memory corruption bug in 6.18.x
Message-ID: <20261015221556.GBatFQnDnsIjRVOpU-@fat_crate.local>
References: <asKdhWiJb3qXeopz@pcnci.linuxbox.cz>
 <bd8e9b01ad88cafb12da33331f32a1ce315f590b.camel@surriel.com>
 <20261005132113.43548696@pumpkin>
 <asP5xK4axiUk7jun@pcnci.linuxbox.cz>
 <aseMsMGpGPT/G548@pcnci.linuxbox.cz>
 <20261008182356.GBasffvDuTemTu1VUY@fat_crate.local>
 <20261009090042.39ba9c06@pumpkin>
 <aszH4vpXFAOQP1WG@pcnci.linuxbox.cz>
 <20261014235736.GCatAW8GD0GlYumL4l@fat_crate.local>
 <atCZc+XB1eWWR02x@pcnci.linuxbox.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <atCZc+XB1eWWR02x@pcnci.linuxbox.cz>
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 9666416000B
X-Rspam-User: 
X-Stat-Signature: j1t4jsran8cyr1jw67qzfe4db9gabw34
X-HE-Tag: 1792102580-939186
X-HE-Meta: U2FsdGVkX1849Y1w791iPBc8Oeo+23JW30BfGHbzY1FpHrMzalZGEgHVjg7Rvgs0c4NzrZ6RdT09f435n2Itgmqmu8CX1CktBlV+5AOAgxePehDbuyoeWVfl2lvBd3Or43blU3prsb00QCfOADhJAkdqAOyc5L0wK+rR4naPAntzUQenDz0HLBarHb1aFB2QNGStSN7btZJ/YPfQUlumLE+kFI1m1GXSKwD1vXqnWqtbmxZ6q1ONAtSNhfWaG1/k+v4Al6dmaiIyzgnRBYFhc8Q828xltxMsg3Ei5ByBJZlh1iI0RT8hezAlbbFRksU5nriFo5SSQkvY2EqdVxmly4rrGgjIt/HJkMaeXBZDQ+0jDHHU0EHXDIPuP2cNCCFB+moK4tNh6go9cV8MrvaNH8CkqJSAlmsP/uun7ow9jxmLic1UayKA/XhnvyZ2lOoaD/A8djMTRXjxyrMghc0w9QhrufiBVT8MdlVBB4bgrYMqvxCXLrftjhqhZsP//vzEDqpfHydm9UrXYQHtp07X7RXeOCjvTFSakUoJ1Wh1ymGzdYNbgjCOgKE5DTzuDIgMjm09YvzWjezMKRWeVRcl1eEDWTHvVURdcmnWsislJAgr4Sh8rPyWJCYF5DMDQV2iP/WTj5ornP6d1kuxjsK93oMdouoruNGBGvIumxUvneDEiSfinEdPdL2WUlfXS+F6VhwZmtkEvDjt8XM5zVLJCVbzJL0C7xIInLBz/6znLvzEAAtwUOJuGAjkAMLwE5pedzvzSQ9Te8+Cjt1IdHA7xNt7pKSOAJ7seJCz/EHPRdsD7+uiX0FOjmXFiyh2N+Kp1SOlTTdL6w6NUq5rFY5LFozvpFHOacGQyiL9O/QZZdRa+ygXmEZjpuKd/MhlyLd8oYwmoEwU0v5qr8J84/XbAeINiKdNBxr3VX54TKeV2/qR+0PIQgCAB9OZ/009X+H3N4bQG99zMA1J2HQ8/OZ
 jeIOcCux
 HyI+NWMGzpRmj5oaUyCWaBsEQTHoWlMjep/kSN5vOG8PkmyYHL4q7LOVs7A+rsVgUtlx3n7IqgK+nW8wpCL4Wssk7k4P1fV2h6SmvpeI0I8eymzg7LocXcPCPxCVYe4b2BP2jx4Pa24P2Zkgnp/6op1cEAQMLdC+uXpoLLSdRxtIyyyaAJTvPCywpIrA9FW6byjkajx9rtrxFQdvJAv2k0WbqmWup7zAl0rMvAFo9NwQh4Yd2Y+uE1X3/EP8aW7F9wyb8lU3zySPWxtelJ5A3aHEizqSoc2sG939nNFSQyIawXe+9txBWRHVtyFqO7xRNJMozha2X1EIov143gAkTZya2qvnVlnAg9uDrzRIiwYBKwgMR7VCSBsM1Iw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Oct 15, 2026 at 11:14:27AM +0200, Nikola Ciprich wrote:
> it doesn't seem to affect users in any way, so I'll just keep it running
> and report if I get some issue

Thanks, yeah, let's see what happens...

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

