Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 492F4EC1106
	for <linux-mm@archiver.kernel.org>; Mon, 23 Feb 2026 16:20:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 845396B008A; Mon, 23 Feb 2026 11:20:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 81CF06B0095; Mon, 23 Feb 2026 11:20:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 72FBD6B0096; Mon, 23 Feb 2026 11:20:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 5BC646B008A
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 11:20:29 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 0A01F1B5522
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 16:20:29 +0000 (UTC)
X-FDA: 84476234178.24.62BE4DF
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id 34A6E4000F
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 16:20:27 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=PvSQrdeo;
	spf=pass (imf07.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771863627;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NVI0Y7WWrko3nhGx2NU9ZJ8Sd9AAcRODnva0eiUT/8w=;
	b=GWuIPbUU4HuBK/55FWhhtkDjDRlzaoQw7YwBZEhmGd+DzFH2IRWeD80KSqUPLsh17du/y3
	Z2MjbY0xYFMk/aelSsGzcM39oR7y9oZmmok1qa+pnGID9ZPsyuaos7sJU5Fv751KvIhNFj
	OOnVXTcSCVRti1c9YkIyoWA+u4/DMW0=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=PvSQrdeo;
	spf=pass (imf07.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771863627; a=rsa-sha256;
	cv=none;
	b=xrDyYlHe22yEG0qJOYgYRmvYuV9HK6/LRjF3IjeYxHh08+4K1rqWpoZeB54YFwq/wXNtYi
	kc4LHWup4CZ5j9d8xwVcH2WP6DohGSeVhp+aZE1NEAiSWsl+99UqEBc3n5ybZ3t/K26gV7
	6CLOPH27jXMhPBbIpui9w6z2uOX0FWo=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 8C6BF6013A;
	Mon, 23 Feb 2026 16:20:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 491D5C19421;
	Mon, 23 Feb 2026 16:20:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771863626;
	bh=r8mDeUpeW8tBUm82rtc4kcjK4ONsKrxt6c1CNArIpvE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=PvSQrdeocpoNN0p9MaK3sggyEhP6bDqgKlYc4yggH5rAQfcrJSEuKTtELQhVIOkjx
	 27RQ0W9Om2jLvItanmN74NXkqDRCxLkjXjaCXz5bEKdFVStFxL1rlOWFSZbj8akEiQ
	 RTIy9lvApB5TO1WlSYuX4YYlQUEqNRrOHfiiFgYlCTl+BgTe7OSrlqkia9urvm4gfH
	 wEnzHCtCVlI5CNU0NW15/hd1zgUBBwRbdtJjTdH3whUnlSskR3W3fdLulPBddBqTd9
	 p/zoAG/hQZwKDfywAO//6WYOrm1PgrTL/1tu0We8q3IF+9vQhWyrE7DidGdwP4gezC
	 Z3Nfs3HSc7qbw==
Message-ID: <4bbe1b83-da01-4226-9a86-1bf6194c22e4@kernel.org>
Date: Mon, 23 Feb 2026 17:20:13 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 4/4] mm: cache struct page for empty_zero_page and
 return it from ZERO_PAGE()
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
 <20260209144058.2092871-5-rppt@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 xsFNBFXLn5EBEAC+zYvAFJxCBY9Tr1xZgcESmxVNI/0ffzE/ZQOiHJl6mGkmA1R7/uUpiCjJ
 dBrn+lhhOYjjNefFQou6478faXE6o2AhmebqT4KiQoUQFV4R7y1KMEKoSyy8hQaK1umALTdL
 QZLQMzNE74ap+GDK0wnacPQFpcG1AE9RMq3aeErY5tujekBS32jfC/7AnH7I0v1v1TbbK3Gp
 XNeiN4QroO+5qaSr0ID2sz5jtBLRb15RMre27E1ImpaIv2Jw8NJgW0k/D1RyKCwaTsgRdwuK
 Kx/Y91XuSBdz0uOyU/S8kM1+ag0wvsGlpBVxRR/xw/E8M7TEwuCZQArqqTCmkG6HGcXFT0V9
 PXFNNgV5jXMQRwU0O/ztJIQqsE5LsUomE//bLwzj9IVsaQpKDqW6TAPjcdBDPLHvriq7kGjt
 WhVhdl0qEYB8lkBEU7V2Yb+SYhmhpDrti9Fq1EsmhiHSkxJcGREoMK/63r9WLZYI3+4W2rAc
 UucZa4OT27U5ZISjNg3Ev0rxU5UH2/pT4wJCfxwocmqaRr6UYmrtZmND89X0KigoFD/XSeVv
 jwBRNjPAubK9/k5NoRrYqztM9W6sJqrH8+UWZ1Idd/DdmogJh0gNC0+N42Za9yBRURfIdKSb
 B3JfpUqcWwE7vUaYrHG1nw54pLUoPG6sAA7Mehl3nd4pZUALHwARAQABzS5EYXZpZCBIaWxk
 ZW5icmFuZCAoQ3VycmVudCkgPGRhdmlkQGtlcm5lbC5vcmc+wsGQBBMBCAA6AhsDBQkmWAik
 AgsJBBUKCQgCFgICHgUCF4AWIQQb2cqtc1xMOkYN/MpN3hD3AP+DWgUCaYJt/AIZAQAKCRBN
 3hD3AP+DWriiD/9BLGEKG+N8L2AXhikJg6YmXom9ytRwPqDgpHpVg2xdhopoWdMRXjzOrIKD
 g4LSnFaKneQD0hZhoArEeamG5tyo32xoRsPwkbpIzL0OKSZ8G6mVbFGpjmyDLQCAxteXCLXz
 ZI0VbsuJKelYnKcXWOIndOrNRvE5eoOfTt2XfBnAapxMYY2IsV+qaUXlO63GgfIOg8RBaj7x
 3NxkI3rV0SHhI4GU9K6jCvGghxeS1QX6L/XI9mfAYaIwGy5B68kF26piAVYv/QZDEVIpo3t7
 /fjSpxKT8plJH6rhhR0epy8dWRHk3qT5tk2P85twasdloWtkMZ7FsCJRKWscm1BLpsDn6EQ4
 jeMHECiY9kGKKi8dQpv3FRyo2QApZ49NNDbwcR0ZndK0XFo15iH708H5Qja/8TuXCwnPWAcJ
 DQoNIDFyaxe26Rx3ZwUkRALa3iPcVjE0//TrQ4KnFf+lMBSrS33xDDBfevW9+Dk6IISmDH1R
 HFq2jpkN+FX/PE8eVhV68B2DsAPZ5rUwyCKUXPTJ/irrCCmAAb5Jpv11S7hUSpqtM/6oVESC
 3z/7CzrVtRODzLtNgV4r5EI+wAv/3PgJLlMwgJM90Fb3CB2IgbxhjvmB1WNdvXACVydx55V7
 LPPKodSTF29rlnQAf9HLgCphuuSrrPn5VQDaYZl4N/7zc2wcWM7BTQRVy5+RARAA59fefSDR
 9nMGCb9LbMX+TFAoIQo/wgP5XPyzLYakO+94GrgfZjfhdaxPXMsl2+o8jhp/hlIzG56taNdt
 VZtPp3ih1AgbR8rHgXw1xwOpuAd5lE1qNd54ndHuADO9a9A0vPimIes78Hi1/yy+ZEEvRkHk
 /kDa6F3AtTc1m4rbbOk2fiKzzsE9YXweFjQvl9p+AMw6qd/iC4lUk9g0+FQXNdRs+o4o6Qvy
 iOQJfGQ4UcBuOy1IrkJrd8qq5jet1fcM2j4QvsW8CLDWZS1L7kZ5gT5EycMKxUWb8LuRjxzZ
 3QY1aQH2kkzn6acigU3HLtgFyV1gBNV44ehjgvJpRY2cC8VhanTx0dZ9mj1YKIky5N+C0f21
 zvntBqcxV0+3p8MrxRRcgEtDZNav+xAoT3G0W4SahAaUTWXpsZoOecwtxi74CyneQNPTDjNg
 azHmvpdBVEfj7k3p4dmJp5i0U66Onmf6mMFpArvBRSMOKU9DlAzMi4IvhiNWjKVaIE2Se9BY
 FdKVAJaZq85P2y20ZBd08ILnKcj7XKZkLU5FkoA0udEBvQ0f9QLNyyy3DZMCQWcwRuj1m73D
 sq8DEFBdZ5eEkj1dCyx+t/ga6x2rHyc8Sl86oK1tvAkwBNsfKou3v+jP/l14a7DGBvrmlYjO
 59o3t6inu6H7pt7OL6u6BQj7DoMAEQEAAcLBfAQYAQgAJgIbDBYhBBvZyq1zXEw6Rg38yk3e
 EPcA/4NaBQJonNqrBQkmWAihAAoJEE3eEPcA/4NaKtMQALAJ8PzprBEXbXcEXwDKQu+P/vts
 IfUb1UNMfMV76BicGa5NCZnJNQASDP/+bFg6O3gx5NbhHHPeaWz/VxlOmYHokHodOvtL0WCC
 8A5PEP8tOk6029Z+J+xUcMrJClNVFpzVvOpb1lCbhjwAV465Hy+NUSbbUiRxdzNQtLtgZzOV
 Zw7jxUCs4UUZLQTCuBpFgb15bBxYZ/BL9MbzxPxvfUQIPbnzQMcqtpUs21CMK2PdfCh5c4gS
 sDci6D5/ZIBw94UQWmGpM/O1ilGXde2ZzzGYl64glmccD8e87OnEgKnH3FbnJnT4iJchtSvx
 yJNi1+t0+qDti4m88+/9IuPqCKb6Stl+s2dnLtJNrjXBGJtsQG/sRpqsJz5x1/2nPJSRMsx9
 5YfqbdrJSOFXDzZ8/r82HgQEtUvlSXNaXCa95ez0UkOG7+bDm2b3s0XahBQeLVCH0mw3RAQg
 r7xDAYKIrAwfHHmMTnBQDPJwVqxJjVNr7yBic4yfzVWGCGNE4DnOW0vcIeoyhy9vnIa3w1uZ
 3iyY2Nsd7JxfKu1PRhCGwXzRw5TlfEsoRI7V9A8isUCoqE2Dzh3FvYHVeX4Us+bRL/oqareJ
 CIFqgYMyvHj7Q06kTKmauOe4Nf0l0qEkIuIzfoLJ3qr5UyXc2hLtWyT9Ir+lYlX9efqh7mOY
 qIws/H2t
In-Reply-To: <20260209144058.2092871-5-rppt@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 34A6E4000F
X-Rspamd-Server: rspam02
X-Stat-Signature: dhea7cgap439dyfmpqmzabfgqwkmsqsy
X-HE-Tag: 1771863627-442329
X-HE-Meta: U2FsdGVkX1/yLNETqO7XtiGzBk7McrsYGoEn/zMmPfvM7QpEyZxoRI5V0T68bTpQ+8fODvSasiLz0HMbceXSgVzhic3eEbkhRj4gDp94XmiVyHKRzIzeUM607ulEw4RuSPGfwmEuDMEjLmBhEpiu0SYGhRqXYHK2JHXR8qP54njHw1PwgJddHVz75WZDnS0yh6nxD7vuBT29l22UetBm8INg0a5nUzfg7WvYR8v7eSj7cUWxR3e6KBpOncYv2kSCT5UQu8fmWzFHcEJkrZTlabGfCkQdWNAzRpwRpYvjj6gUATHZSzUe5wY0pyeTe+Q6g4khjV4bGkTGErfdZX2FV/wLeH5f3c5Rj0Z/WQwimFoEHvcvQILhDr/xS6hm8yxH0BxCi/LoBlwA3UFOCxQqcC6bAeJxI9F7jw5c5G3SUhSKC/goTNhD2vgsJ+TtZDRujBuj4uGASRHojhRl5Z/IFMGYJjE7D1OgotpWzB7T7eg+mADpvugYc+DBgQGmdL+lYI9NtQ5GOIMdzJqSnRY4NaWY2umpBVYAlS+1rSCn/8mLZpP7iZYIlRUyJB1LlzaUflkyKGHz+fYIelfYaGwMRM8NTO2v8NhVxJ1eH8s8lTAQLz1uJB999199R2Z1yuTCdv3FNU4sbMnu/aVs1wvZUcSG2Ju34kL+qyyB4fmD+I9/Cve8ybzoFV2Tob9pSJPpbV942L51ksTj7delw6G1X+MY6yqQD3UJSGF9jFYE9fpBONU/JEq40vZpfPoh9k6St3mb1AJ/FuCAsi4SVljpuPVlMcN0MfvnZsTpgSyGC5h2DxuAx5OlxEGQR6O7QRe0AqVZKwy+HN2PgQxDE/or6+BqLPlPBfTBCmpAO159/5lG1BHTZ6Tnd/buxQ4vp9zQtn9tZA3GV53dd7ucs/bCGlTts5UrYMlWqvQ/5yEK9A0gemlHQevymQcKtPleiiB2/cgp44lVk4K2J4zaigI
 ZRcLshCd
 8oNQ/KHF8haUhjpnh3+oRA1qIJsAVq3OlL3TEGtNKo8dv1sri7acdvtjX+ILzDLS8qYdN+FCM/cxNrsqfyrlmvtTvCo7FyIKq+OAttl4b0XwqUP9u08lKtYqnyjiEZdsvcC7fPP9kN3LpBmSAL0OD5AmFM+FCi2VrJkARCIvNJdLeeDFl+SciOeymt/dgZNGMnA8rSHJ6wQpgEcEj1RVI0YCdoWg79GrY2H3xdcGM3sZYKcLmsINJZzcOdIE/VxVW3Hrst6ibBZ1O4Hc4es3VoCXQhqIqVZPMk+SFfx5wvY4mNTVekszXcVb8O8bNuw3VvqsceagAtsXqZpg=
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
> For most architectures every invocation of ZERO_PAGE() does
> virt_to_page(empty_zero_page). But empty_zero_page is in BSS and it is
> enough to get its struct page once at initialization time and then use
> it whenever a zero page should be accessed.
> 
> Add yet another __zero_page variable that will be initialized as
> virt_to_page(empty_zero_page) for most architectures in a weak
> arch_setup_zero_pages() function.
> 
> For architectures that use colored zero pages (MIPS and s390) rename their
> setup_zero_pages() to arch_setup_zero_pages() and make it global rather
> than static.
> 
> For architectures that cannot use virt_to_page() for BSS (arm64 and
> sparc64) add override of arch_setup_zero_pages().
> 
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

