Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 26E5BEC1104
	for <linux-mm@archiver.kernel.org>; Mon, 23 Feb 2026 16:16:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8BA706B0093; Mon, 23 Feb 2026 11:16:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 871AD6B0095; Mon, 23 Feb 2026 11:16:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 77DFE6B0096; Mon, 23 Feb 2026 11:16:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 62E8A6B0093
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 11:16:22 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 1300C1401A5
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 16:16:22 +0000 (UTC)
X-FDA: 84476223804.29.C1D1AC9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 3C12D14000C
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 16:16:20 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="lm/Ir+vc";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771863380; a=rsa-sha256;
	cv=none;
	b=hA53KwRwRnb8QBDy4haVQlhr9PgnGSbU4+R3iScUX48RSxXQdYCCBL2lR14B0XBfKiY/Uo
	bMYPpZbH1bx8CaPhpkV4xw1oFwF9IOrttPgXYTOvcSLXdCXlBQTr/G1b3kOTCsOm7ZsqqQ
	S621DTFh5S/aE8uKekwySbmuPLtMa/k=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="lm/Ir+vc";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771863380;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/UiaVJeeeOQJmnUUx+L2e4aO0o5iKiM4tnaLZvpL68g=;
	b=qtiW+xPigPnrG3PV0cDldcki7RGB0ZI9DAr1kUjbWgOboMm6ffR2GYvjiJcQiUGATBZ6x8
	gGlgxgSIqVu1Gg+Q6Ayfy7wu/STltUy2MCAZ4/IAojOhHvH2yHNfYStwTz0gmPyHK0yAdY
	U1yHZaDi0ByFp/jQhDPDb9fY1LnUk0E=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 1249244056;
	Mon, 23 Feb 2026 16:16:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCE72C116C6;
	Mon, 23 Feb 2026 16:16:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771863378;
	bh=9JBeH7cRemY2uqM6ZDX/nXNUAvQrJ8Fr8vmuN0HFcI4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=lm/Ir+vche8iTl6XhPS0GouZun+tZOLYdBGzcyyG0ygbzNjx8afI9Nz4L4YtQqVAw
	 L7ZQ7pDZ3gaWLb6Qul8yrWt6MyN/Ncsx/yenyXe0G7aXWCG54VFdu0mx+X6zje7COX
	 XEJaY+ZnGfc75MWIz1/A5pttxWXYU6C5BONj+3xpZoofXWS0dkDk5KdXNJzysLD8C8
	 mh9EFg+GhstVxQ0fwB0wDfvCmdp0slrt/Qrnlj74UtibyBW712ksIyGKFR4M6w0rZP
	 jWGQFdCM/rMnpLawlWRdN5X44PPEzw4avAZq+hXefgZuWqzU2Ox2OnD0b/jKqgIeea
	 EU+NgodHersKQ==
Message-ID: <37e62ad6-8922-4022-8660-38b818ae9cca@kernel.org>
Date: Mon, 23 Feb 2026 17:16:05 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/4] mm: don't special case !MMU for is_zero_pfn() and
 my_zero_pfn()
To: Mike Rapoport <rppt@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
Cc: Andreas Larsson <andreas@gaisler.com>, Borislav Petkov <bp@alien8.de>,
 Brian Cain <bcain@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>,
 "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
 "David S. Miller" <davem@davemloft.net>,
 Dave Hansen <dave.hansen@linux.intel.com>, Dinh Nguyen
 <dinguyen@kernel.org>, Geert Uytterhoeven <geert@linux-m68k.org>,
 Guo Ren <guoren@kernel.org>, Helge Deller <deller@gmx.de>,
 Huacai Chen <chenhuacai@kernel.org>, Ingo Molnar <mingo@redhat.com>,
 Johannes Berg <johannes@sipsolutions.net>,
 John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Magnus Lindholm <linmag7@gmail.com>, Matt Turner <mattst88@gmail.com>,
 Max Filippov <jcmvbkbc@gmail.com>, Michael Ellerman <mpe@ellerman.id.au>,
 Michal Hocko <mhocko@suse.com>, Michal Simek <monstr@monstr.eu>,
 Palmer Dabbelt <palmer@dabbelt.com>, Richard Weinberger <richard@nod.at>,
 Russell King <linux@armlinux.org.uk>, Stafford Horne <shorne@gmail.com>,
 Suren Baghdasaryan <surenb@google.com>, Thomas Gleixner <tglx@kernel.org>,
 Vineet Gupta <vgupta@kernel.org>, Vlastimil Babka <vbabka@suse.cz>,
 Will Deacon <will@kernel.org>, linux-alpha@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-snps-arc@lists.infradead.org,
 linux-arm-kernel@lists.infradead.org, linux-csky@vger.kernel.org,
 linux-hexagon@vger.kernel.org, loongarch@lists.linux.dev,
 linux-m68k@lists.linux-m68k.org, linux-openrisc@vger.kernel.org,
 linux-parisc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
 linux-riscv@lists.infradead.org, linux-sh@vger.kernel.org,
 sparclinux@vger.kernel.org, linux-um@lists.infradead.org,
 linux-mm@kvack.org, x86@kernel.org
References: <20260209144058.2092871-1-rppt@kernel.org>
 <20260209144058.2092871-2-rppt@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260209144058.2092871-2-rppt@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 3C12D14000C
X-Stat-Signature: z5zbbk4s8meef1caxbho7o5i6xdpxx8k
X-HE-Tag: 1771863380-627840
X-HE-Meta: U2FsdGVkX1/t/qmrSCBvJqlRRpMo6AOLmhvpiI62FXfSmpMP1L2H6DI2p844QvW//lHBksD71ny7uIh5t/GLRvxdZLBiku63lcmWmXy9v30kp2dPcFN7wSMgN08C9uAAyp0APaSmvS7tw7TN5Mae48e+Gw5jLlL6oPLpYfNbw2TQVOaGPGocxgLDBvS62frkDrEelBbjPilH6PkFiG+wrijVyMdUncspby4pQilDiMWbY5DDH3Pv0pXVcr6mOy24fn0RJYQLKa5F8iJXoYAvtjetIbwQjcRiVlOd3OSm1glvzmg8Pn634keT8BYU4h8iPbSf+8EWgCBG+xBmnYhsxdUTnd+zzc0UahU8K3sU2HqeU1LCZ0Vxc1Nn2Z+PSF78B9Vcy+4erDeieilUnFEm+qtH4lQ6DXhueWAYl824COvQQL9xJaSsNNKX6xE6jP174YWIBfr34+GYLeF8fqOs0bBIsgjKtNNLCWqLIk9Vlk6fXEUuG0jXKshBM1SAVzDrME2au7HXZWvqSai7vAvNHujwqqUY69iuh9ao7INrrp+i/PG7/oW0iBoaROKauj0UpIoU+E9oplzF90F6tUuvuLBNuk1C9bhqLeGLJiPQWbct0J1sNZYqr7lpEocPh/5K3z9bW04izM9Ynu3WTVsFwKTSR04MEVV6QrkzB5nRga9dT4b6YzWK5IY/dV0ioEIy2XtY3RWePaZx+wC4YlqyUpXHxxVydcHFBkwh77HEySLhktm7a8P5VqsZrliRDtAMxVzlWxuNDCON1XqnxBTOcSGW0bPCbIivGnM6bJ/DfENmyR6cyOT8gnxCM03jxVoNIAWoYoXIl36fkYt9rqKCXiobzpLJepU0oOe1bpYsWKw9ygPwSqmz3MojVNPficI2+OGPPA3XQdCbdn7GUZ0s4xu2y9oSIG37fFlbuzpeQzvigPueL5PcqaKPkmT+lU8X+2gcB/H9PljeTbLqrr5
 xazPyHoV
 +5CvDfJeSPf39HUKVvwDxoaqM6th9XkKZdGqtoq3IwXws5rh1pZIHJAXGCk9NIacypwFan9AgxaWd8PgD4EiTyFgh70uSCU0nG3c/KIBmXSjT8L+nqVnPp7t9vZeXJrbOgGsHfep+R1nb5rWBoNceXP8YDZSW1oKxhECcrzyzZOGX1KUYqbueJ5r9ZPE395KGKSvMzrCYvVwDYyvdXNgzX+hbIlKSXblmf7NQe1HW91jo5eIsBwCx48QgWFrRWHV3HzFDXF4UFyWfcpZqZjrSN6QQQMHYl1BvesfioCneJ8SGsjiuX9udru1l/I9cqzRtwqZVLrGPXji9GjUijTkK+/WvdBeMAyKIyhuU6vECk0U4LLybM4sqdlXENA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/9/26 15:40, Mike Rapoport wrote:
> From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
> 
> nommu architectures have empty_zero_page and define ZERO_PAGE() and
> although they don't really use it to populate page tables, there is no
> reason to hardwire !MMU implementation of is_zero_pfn() and my_zero_pfn()
> to 0.
> 
> Drop #ifdef CONFIG_MMU around implementations of is_zero_pfn() and
> my_zero_pfn() and remove !MMU version.
> 
> While on it, make zero_pfn __ro_after_init.
> 
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

