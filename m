Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 05991CE8D6B
	for <linux-mm@archiver.kernel.org>; Mon, 17 Nov 2025 18:35:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 641AC8E001C; Mon, 17 Nov 2025 13:35:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 619DF8E0002; Mon, 17 Nov 2025 13:35:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 57D758E001C; Mon, 17 Nov 2025 13:35:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 497AB8E0002
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 13:35:48 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E71A14D7A
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 18:35:47 +0000 (UTC)
X-FDA: 84120952734.23.E11D3AF
Received: from mail-24416.protonmail.ch (mail-24416.protonmail.ch [109.224.244.16])
	by imf20.hostedemail.com (Postfix) with ESMTP id 384ED1C0009
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 18:35:46 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=pm.me header.s=protonmail3 header.b=Ow9517Gl;
	dmarc=pass (policy=quarantine) header.from=pm.me;
	spf=pass (imf20.hostedemail.com: domain of m.wieczorretman@pm.me designates 109.224.244.16 as permitted sender) smtp.mailfrom=m.wieczorretman@pm.me
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763404546; a=rsa-sha256;
	cv=none;
	b=AVehx42Eywv6QORUT5Bgr4rMMTmzaLUia9eiPCj86UAbGYKKM+Dc/deBZY3lHOJVPWQOZ5
	BnZtSpqU33mShuvo5828eCqjwKhMsYviK8q12KRfYp252cZ63XaAnY0LslKYcjMPk2DjZF
	tmvAnyF7IAZ+WGJAdM47lv9crfTaxZw=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=pm.me header.s=protonmail3 header.b=Ow9517Gl;
	dmarc=pass (policy=quarantine) header.from=pm.me;
	spf=pass (imf20.hostedemail.com: domain of m.wieczorretman@pm.me designates 109.224.244.16 as permitted sender) smtp.mailfrom=m.wieczorretman@pm.me
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763404546;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zH5WVIO3cxOwoV7JqKcP1ToXH/X437vo+cbBXaQZW1Q=;
	b=k6N1Rdd5uoua+SP4b01VU0n0oBbL+mDtwPTogFfcVa23Y4fpCth62jez+PuEW4iaUDG1rD
	NAmH3niowgRe4j0IWWdehugWS/v+SsuRyCNE2UDY8IZYsnxEVfiVtyJaJ9cpzTFfdk5gGd
	7B+MplDqfyvmoj9htxuHe+4Ag1lLZ4g=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me;
	s=protonmail3; t=1763404543; x=1763663743;
	bh=zH5WVIO3cxOwoV7JqKcP1ToXH/X437vo+cbBXaQZW1Q=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector;
	b=Ow9517GlVkdXb0QK4zjYxuQOHLNlXBQV1cDfbfieA47R/oZppYFaXLUldJ1Tsq5ih
	 cSQWOVBUEIXNRzU9Z0PwoISODUhBmTaVt175wXQkO+pXpKxbHzlR9FcwRIpzz9Tqw+
	 IR2AUVjxkUQt58ykh1SuYyNEC2vg9WKSs0zAWb2vchX/qb4b2aj56AuCLDjILSWJKR
	 y7thVVzmNLOKb57GussgLz8hjrzaxtGyskBAQgEksXSAQcDYFI0X/MRtnGpRX/UsQ8
	 0/Q9NgRR+AM3VtjauiR5MqSjMmNx7MddjrniFxSo0IFFpcXYNxvJBOr2L2aXvHBWr7
	 wsuBdyxI2rtlA==
Date: Mon, 17 Nov 2025 18:35:38 +0000
To: Alexander Potapenko <glider@google.com>
From: =?utf-8?Q?Maciej_Wiecz=C3=B3r-Retman?= <m.wieczorretman@pm.me>
Cc: xin@zytor.com, peterz@infradead.org, kaleshsingh@google.com, kbingham@kernel.org, akpm@linux-foundation.org, nathan@kernel.org, ryabinin.a.a@gmail.com, dave.hansen@linux.intel.com, bp@alien8.de, morbo@google.com, jeremy.linton@arm.com, smostafa@google.com, kees@kernel.org, baohua@kernel.org, vbabka@suse.cz, justinstitt@google.com, wangkefeng.wang@huawei.com, leitao@debian.org, jan.kiszka@siemens.com, fujita.tomonori@gmail.com, hpa@zytor.com, urezki@gmail.com, ubizjak@gmail.com, ada.coupriediaz@arm.com, nick.desaulniers+lkml@gmail.com, ojeda@kernel.org, brgerst@gmail.com, elver@google.com, pankaj.gupta@amd.com, mark.rutland@arm.com, trintaeoitogc@gmail.com, jpoimboe@kernel.org, thuth@redhat.com, pasha.tatashin@soleen.com, dvyukov@google.com, jhubbard@nvidia.com, catalin.marinas@arm.com, yeoreum.yun@arm.com, mhocko@suse.com, lorenzo.stoakes@oracle.com, samuel.holland@sifive.com, vincenzo.frascino@arm.com, bigeasy@linutronix.de, surenb@google.com, ardb@kernel.org,
	Liam.Howlett@oracle.com, nicolas.schier@linux.dev, ziy@nvidia.com, kas@kernel.org, tglx@linutronix.de, mingo@redhat.com, broonie@kernel.org, corbet@lwn.net, andreyknvl@gmail.com, maciej.wieczor-retman@intel.com, david@redhat.com, maz@kernel.org, rppt@kernel.org, will@kernel.org, luto@kernel.org, kasan-dev@googlegroups.com, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, x86@kernel.org, linux-kbuild@vger.kernel.org, linux-mm@kvack.org, llvm@lists.linux.dev, linux-doc@vger.kernel.org
Subject: Re: [PATCH v6 04/18] kasan: sw_tags: Support tag widths less than 8 bits
Message-ID: <6rh6ynwrmh7afqkfyfphiy6rv2xjpdpcotzooqfye6lg7rddhe@betrc4geghsk>
In-Reply-To: <CAG_fn=VUx7GkcjuYO3oRH7ptgKVtzQNChW1xKL+1SPfJ=XvWwQ@mail.gmail.com>
References: <cover.1761763681.git.m.wieczorretman@pm.me> <8319582016f3e433bf7cd1c88ce7858c4a3c60fa.1761763681.git.m.wieczorretman@pm.me> <CAG_fn=VUx7GkcjuYO3oRH7ptgKVtzQNChW1xKL+1SPfJ=XvWwQ@mail.gmail.com>
Feedback-ID: 164464600:user:proton
X-Pm-Message-ID: 89bdc726c809a41792e2e4dd98d31d2c2e8b87c5
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 384ED1C0009
X-Rspamd-Server: rspam07
X-Stat-Signature: x8pafzhrubp1obyejz8moxsry97x85n3
X-Rspam-User: 
X-HE-Tag: 1763404545-863502
X-HE-Meta: U2FsdGVkX1+pXFYgoXhIdAH4+cX2mToWYVLjc8Aw78WkQN4KzH/Mosk26om3mhn7QpMI5aJfUSvhPMbAk0jBvOKXsfypW0VXbM7tJWaBilPDI7M+W5ArxaRthTXcXpwC+KUcvtArX9zjz2Fk1Qr5Rp8h1NTQnkj9+RJtWHt2xhFypogYYW3xMQuEf5bZTuDDE4QhltZw0VgI5PqiKtEUGK/aI225egqKmNIl7jeMyhzPdqyHihvEaY0KTMcVa0m2mniKZJ5seTwmWCbCVUP3ynBCsDrpevWzO64GzE25hUADh9WlbI1N9xDUSa9fd96bqHoD4xE1LY114xSSGHnKwS8hL2AUsTRcs8Jta27dKZm8bDLwP5mWczt3FtGfrXFGtMoPo/Mhn4Jo7ngPVe9ONnL19wMbo4mfHExEn00xNHmUrzoWAsl2+3WH3PIeTIPfqaTR5GvQjYM251xmtKG2wJ2PCL/5Ix8NyifKq7Ss1gTeR0G39o423xx/k/b3KVxxlXHGMrOZ77fnKhd8NwqpVHSHN/+zARIjs3aLnhBP9GNi1Ti+Otx8iXifppdl3O/B0FRL91lCofPdwgVolEvVMv7unhWVVVCiWprpSYXx59vtRiV3LIhJIrbn+J2thMaS7amE++3LP25qy4aDsEifPlbV1MST/DdPJO03uxL8dHKagiLLzWRVWeLE0Vauu/OgPy9kGaibH0m4FL7wlFNGC5JXhRAFq9gnwXucTLeC9lq5h6/TkOVSnSxgc1RbhZDIJAKkOKP6WCap5ln+TCiNgXTa13NXbVQ39sCuuVti914UR0Ro9biB1yrClAHAB6CM0P6aaPOrjMlZmj1BtHdGMoG0H1/s2dCwxYR6RvUVO84MEiI2YEesRMIuQ9LBqH5Ufi1yKXM/x2zGFifu6VS8+0GCEcFLCByhzV9e2N69vPFn8GIVbmDC+Ik4tMTwwplSsnnNhLyoQVufC+mPph3
 7ZQ1itTI
 ZDneZ1V/HY0Ph5EvH32ccKBklwjgoC4OuJ+3qGA7MpHh+1Ko66Uy68gRd56GxagyVPYzVi+Ip9CSGX3sYRyC1FcjHJf9kte7CX6tARe6r6cYR3xd6hAeqzHSqxBuWLdBF4irqq+16/hKjCRLNTy6Be7cCUfi/ifci9EdjPXikQJRml1Wqwm+1IAXnGeunKx9q0b/k6EIni5oycLgCsiW4cM/XxJDcvLd6Qim/HVCn+VNU8BZwwQ6St60uEO2PjpZTfKR9LQ0na0X2TpCmBQ4Bf8rb9M2ooLCHgZFzYCbJbADFdNSCSF/JndAba4+6AiYvkxS1FZLB/WbXJCMXFQXUBvjTRG7BPR5F64i+W/JS7OH7398=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2025-11-10 at 18:37:59 +0100, Alexander Potapenko wrote:
>> +++ b/include/linux/kasan-tags.h
>> @@ -2,13 +2,16 @@
>>  #ifndef _LINUX_KASAN_TAGS_H
>>  #define _LINUX_KASAN_TAGS_H
>>
>> +#include <asm/kasan.h>
>
>In Patch 07, this is changed to `#include <asm/kasan-tags.h>` what is
>the point of doing that?
>Wouldn't it be better to move the addition of kasan-tags.h for
>different arches to this patch from Patch 07?

I wanted to keep the split between adding the generalized definitions
that Samuel did here, and my arch specific changes. Thought it'd be
easier to review for people if it was kept this way. But maybe it's a
good idea to just move the asm/kasan-tags changes here too, I'll
rearange the code a bit between these two patches.


