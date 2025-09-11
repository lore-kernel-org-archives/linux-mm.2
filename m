Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 18F5BCA1016
	for <linux-mm@archiver.kernel.org>; Thu, 11 Sep 2025 05:38:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 66D758E0002; Thu, 11 Sep 2025 01:38:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 645B28E0001; Thu, 11 Sep 2025 01:38:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 55B888E0002; Thu, 11 Sep 2025 01:38:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 45C418E0001
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 01:38:26 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 0CE591198A8
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 05:38:26 +0000 (UTC)
X-FDA: 83875864212.16.3353FB3
Received: from smtp-out3.simply.com (smtp-out3.simply.com [94.231.106.210])
	by imf22.hostedemail.com (Postfix) with ESMTP id ACDC8C0002
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 05:38:23 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=none ("invalid DKIM record") header.d=gaisler.com header.s=simplycom2 header.b=Hs7ZfSyD;
	spf=pass (imf22.hostedemail.com: domain of andreas@gaisler.com designates 94.231.106.210 as permitted sender) smtp.mailfrom=andreas@gaisler.com;
	dmarc=pass (policy=none) header.from=gaisler.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757569104;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=J4SmUX7P+kpNB7OaZvmmYUNeRGLdLLWkUbpUICDS3qY=;
	b=m/DWn1Zl2SBeeetq5vuMAn30Z+thVKb9dCzD7LFbBWzoBJDtY5cUVMZUgMVxIDaeHW+f7v
	CfRkejYrgXj/nPljFQNs04war1sEBpXjEGnKRL3bzIliue5hCsMIB5t93U32s/OcwnoFrg
	DwL9J7gbr0P4LQhErn1YQWc2hvGmJK0=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=none ("invalid DKIM record") header.d=gaisler.com header.s=simplycom2 header.b=Hs7ZfSyD;
	spf=pass (imf22.hostedemail.com: domain of andreas@gaisler.com designates 94.231.106.210 as permitted sender) smtp.mailfrom=andreas@gaisler.com;
	dmarc=pass (policy=none) header.from=gaisler.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757569104; a=rsa-sha256;
	cv=none;
	b=6aziNmnDiZw6Thx3i02/OPhELde0HqntivKdD979hW3OZO+y6STV2Q5eBuP6mEdNVGFWGE
	/Pc10ITSPKTrwP1F50k4dE7z2SQ+z0XLLQT0spKlHDcp6LMqbNPe102xgHzj0ozSAgnXOV
	x6Tan6jM0AYcp7gxn3V5D9yamA/CdWg=
Received: from localhost (localhost [127.0.0.1])
	by smtp.simply.com (Simply.com) with ESMTP id 4cMmYn6jWzz1FQVw;
	Thu, 11 Sep 2025 07:38:21 +0200 (CEST)
Received: from [192.168.0.25] (h-98-128-223-123.NA.cust.bahnhof.se [98.128.223.123])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(Client did not present a certificate)
	by smtp.simply.com (Simply.com) with ESMTPSA id 4cMmYn1PXCz1FQVP;
	Thu, 11 Sep 2025 07:38:21 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gaisler.com;
	s=simplycom2; t=1757569101;
	bh=J4SmUX7P+kpNB7OaZvmmYUNeRGLdLLWkUbpUICDS3qY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Hs7ZfSyDOM7aPRu33LOA+3yef+fVto4kU9xa+4YpClIxfuXs1fUOvHNHSbYzTsH95
	 ys3zgWHJHS23RTioc6nK1rRkrbxCam9D5ptr5a/DgIz7xpPRDCQ6Etyd5bStpWc73w
	 7yOC/+8Ounc2FdB1AGu5KYNtNxw+XWF0Y0vJdIXiwXVxxPzwE6FGqoMLKjGAvRTDu6
	 0tRpQ6v9KDjievFY3f8w6p8LSH1LMGdoj0SQczd00LYltcWoPmKILRmn5F8FOypXFd
	 6Zp6gO/YqFuyTXHhSNlsS6DU3Zk+NRltjlY23ffJsltCzkH4eal4Sp3ahPCc/wsqRM
	 gmrx1Brnia8oQ==
Message-ID: <5d2fec2b-8e59-417e-b9e6-12c6e27dd5f0@gaisler.com>
Date: Thu, 11 Sep 2025 07:38:15 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [TECH TOPIC] Reaching consensus on CONFIG_HIGHMEM phaseout
To: Arnd Bergmann <arnd@arndb.de>, ksummit@lists.linux.dev
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 linuxppc-dev@lists.ozlabs.org, linux-mips@vger.kernel.org,
 linux-mm@kvack.org, imx@lists.linux.dev,
 Christophe Leroy <christophe.leroy@csgroup.eu>,
 Richard Weinberger <richard@nod.at>, Lucas Stach <l.stach@pengutronix.de>,
 Linus Walleij <linus.walleij@linaro.org>,
 Geert Uytterhoeven <geert+renesas@glider.be>,
 Ankur Arora <ankur.a.arora@oracle.com>, David Hildenbrand
 <david@redhat.com>, Mike Rapoport <rppt@kernel.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Matthew Wilcox <willy@infradead.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka
 <vbabka@suse.cz>, Suren Baghdasaryan <surenb@google.com>,
 Ira Weiny <ira.weiny@intel.com>, Nishanth Menon <nm@ti.com>,
 =?UTF-8?Q?Heiko_St=C3=BCbner?= <heiko@sntech.de>,
 Alexander Sverdlin <alexander.sverdlin@gmail.com>,
 "Chester A. Unal" <chester.a.unal@arinc9.com>,
 Sergio Paracuellos <sergio.paracuellos@gmail.com>
References: <4ff89b72-03ff-4447-9d21-dd6a5fe1550f@app.fastmail.com>
Content-Language: en-US
From: Andreas Larsson <andreas@gaisler.com>
In-Reply-To: <4ff89b72-03ff-4447-9d21-dd6a5fe1550f@app.fastmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: ACDC8C0002
X-Stat-Signature: gn91hwyut9g64wn4peo4rkdb6x85iroj
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1757569103-775305
X-HE-Meta: U2FsdGVkX1/C+1vvdGE9Am64dMlvNHSOfRArvaNqsS/t28TJf1++0ALJ7y/6EvQGzqnnGneq4+EJ0ARyUzccEyJo9b53ZQqpjuhnQK45GT7fZGqY5SBS9j86iesV1KgWJNc6D7q2bCxO6CrouuBVWeM4oPoqfnjXvwyeAd5si2puxhduScYdmRgUsISQsVEyx+txqxVOBQpUbfnVlZKxbiNhQvPLaM8GKg7LaIvUthcdiUvmplPjYVxfWZH3zd66XYkZiJYr/M0Ex5MuPROzH0o0bFLDQ5q47xjSXM9R1DmazG+1PLtFf40GoIKOh/LsyjDIEcnkMzi5XRkDJSFJ+znMI1ExNlYg/jntFrKXzIaPMOhePWBxz1vPVt0pbhTWgrKmn3LQLXszibf703rhOyjgAuGUE5dwdPglZKlfP825BR/oBbox+P8js/B4H2so/vkr7Mam6XpgRXR/tP/J3Qqe25vfkTqvPvT9r+ECQZRR3k9kjIeLWdsSa6yqcboQzpdDxPbLottFq+ccgvPq9BZiZZR/6qwYdrFZ69VhGRKWxDDLbRadhN5wISK2RUXiqy+CZlE/51Ju9Aoy01T8zJNURhKfqZVuehdG1aXp0RgaKIBYPacl1MW3CiU6DNFOq3AeB8ZAOALq7LSHz/CWXNgdT3bZVsoKe/4fmneHtXhzAjb5dcTONtvD3bYeaKmitCb7eC95+B+n8NU7c/0pH393YMtxfkV0kMFk07kEQvnRkK+FfXsuieHPYLjaXN6Ur5k4RKMNroiLJsdP8oLTO29vgBEXMuLDIqghZrhQ0Ua5UEOFlXqoXKI1cb5bTttWow5eKX+2Zd2uCFPivLCvKStihARbOCzlmUfoOIMailLisZClYj6u3b2fsZqdqEa0CygQoffzPCZ4kCCFbc28BjGcgSBmRTU9qCUDpDrmPwCKFnwcH3Taht+hE9aQxPGS436SAGWgZ2RCFbw+vF3
 /8OKbIBk
 iUbzuhkMzl+vP6pC6V2HefN9qShbAdjfGl6n8fP7v3P9w1ZHkOvpczq9ca8aSC+k2WHPR5GgZ4NGwvT9xZdkFphsoYCwDVwoKLXmZiV5NZtU95IxiiWA9Xwmetigg1x5c0dCdBcvLRCFDivpxB/XP//VuNv8eF34Y9hC/z77V80pJOc9QACPpNnJDCwoBk17dnx9ZS0OVfWcPnUarfTddK8Jv6eVJ8UZod1pPdZg6veCRH41bfuHgYBzXu+KP3wEwzqZ5e0By7VhR6YmGWTlew5vXl7Odl9G68sIlSwttpITgodQs8zgUXakRNjwj4I3eO1sgcJujwji9vxaNz2BWmr1o+7EIRRCjtUaobw8gC+V56lh0VyevhflZPyHUbfMd1wUHEFiThHto1l2YiFe6Cp+2PGqodMKlHPKBoYe45j1iXgD7Q+J4wCS4gw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2025-09-09 23:23, Arnd Bergmann wrote:
> High memory is one of the least popular features of the Linux kernel.
> Added in 1999 for linux-2.3.16 to support large x86 machines, there
> are very few systems that still need it. I talked about about this
> recently at the Embedded Linux Conference on 32-bit systems [1][2][3]
> and there were a few older discussions before[4][5][6].
> 
> While removing a feature that is actively used is clearly a regression
> and not normally done, I expect removing highmem is going to happen
> at some point anyway when there are few enough users, but the question
> is when that time will be.
> 
> I'm still collecting information about which of the remaining highmem
> users plan to keep updating their kernels and for what reason. Some
> users obviously are alarmed about potentially losing this ability,
> so I hope to get a broad consensus on a specific timeline for how long
> we plan to support highmem in the page cache and to give every user
> sufficient time to migrate to a well-tested alternative setup if that
> is possible, or stay on a highmem-enabled LTS kernel for as long
> as necessary.

We have a upcoming SoC with support for up to 16 GiB of DRAM. When that is
used in LEON sparc32 configuration (using 36-bit physical addressing), a
removed CONFIG_HIGHMEM would be a considerable limitation, even after an
introduction of different CONFIG_VMSPLIT_* options for sparc32.

Regards,
Andreas


