Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CCB02C43458
	for <linux-mm@archiver.kernel.org>; Fri,  3 Jul 2026 15:10:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B31206B00B4; Fri,  3 Jul 2026 11:10:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B07256B00B7; Fri,  3 Jul 2026 11:10:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A448A6B00B8; Fri,  3 Jul 2026 11:10:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7A3FE6B00B4
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 11:10:25 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E93511C0FC7
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 15:10:24 +0000 (UTC)
X-FDA: 84947801568.07.94F7144
Received: from out-170.mta1.migadu.com (out-170.mta1.migadu.com [95.215.58.170])
	by imf11.hostedemail.com (Postfix) with ESMTP id 165E240006
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 15:10:22 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="j/vuK0n+";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf11.hostedemail.com: domain of leon.hwang@linux.dev designates 95.215.58.170 as permitted sender) smtp.mailfrom=leon.hwang@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783091423;
	b=xCX5y+gwsl10odSnCP6IrEWQse/fngEAyL3cvjhQ79WH+zysbI05GepEt06D0v7zsF1IDR
	LyA8zruPa/r3Xpi/mdhXcshEmj0rzVdaoiuaI3/mpaYMtv3gtaqM5ttTcn448CxSgBWIww
	QwpElgfI6b5rHUUOE0lLPejl5JfD9uQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783091423;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=D0jQhMPhscsL1NbyNjS1WJWCL9R2xskq5LtPdLuRjgQ=;
	b=nkjMqWih0ED0AwnAvLgHH6oKoqwG7nwWDBNbKC6QRhv9682DO2DAWiU9C2+qAD0qE/xu7j
	qRNr5OORYNeRRg6tYHltkOeHLRdYKfnOWhaTz9HGURhKVRQoqgkoEfhJl+s1/6PaMyDWze
	x9YTDO/XbX/5cuDhA56JUjHYmI2j9E0=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="j/vuK0n+";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf11.hostedemail.com: domain of leon.hwang@linux.dev designates 95.215.58.170 as permitted sender) smtp.mailfrom=leon.hwang@linux.dev
Message-ID: <b6f5f3b2-bf62-4b77-9c74-debbed9a4738@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783091420;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=D0jQhMPhscsL1NbyNjS1WJWCL9R2xskq5LtPdLuRjgQ=;
	b=j/vuK0n+G28zyIBLktJU1GlREKmOyVhgVtBHvZIfkZ4ZTiO05suHg86BY+INcDSH3/rzg2
	eYKS5nnCjeL0L8QyipRBNB3i4lx61WmR8qewTnZB8a6H4G6v1/uqV3zSQLbG+NWz4f4tBv
	P9w44JsWEgPbVPjshqUB3G39TMkvs9Y=
Date: Fri, 3 Jul 2026 23:09:55 +0800
MIME-Version: 1.0
Subject: Re: [PATCH] mm/mseal: fix mseal documentation for 32-bit kernels
To: =?UTF-8?Q?Thomas_Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>
Cc: linux-mm@kvack.org, Jonathan Corbet <corbet@lwn.net>,
 Shuah Khan <skhan@linuxfoundation.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 "Liam R . Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>,
 Pedro Falcato <pfalcato@suse.de>, Paul Walmsley <pjw@kernel.org>,
 Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>,
 Alexandre Ghiti <alex@ghiti.fr>, Nathan Chancellor <nathan@kernel.org>,
 Peter Zijlstra <peterz@infradead.org>, Miguel Ojeda <ojeda@kernel.org>,
 Nicolas Schier <nsc@kernel.org>, Thomas Gleixner <tglx@kernel.org>,
 Alice Ryhl <aliceryhl@google.com>, Douglas Anderson <dianders@chromium.org>,
 Gary Guo <gary@garyguo.net>, Anand Moon <linux.amoon@gmail.com>,
 Randy Dunlap <rdunlap@infradead.org>, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-riscv@lists.infradead.org
References: <20260703022507.187457-1-leon.hwang@linux.dev>
 <20260703114128-2a7a4723-0060-436b-99d9-7499bd90fa82@linutronix.de>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Leon Hwang <leon.hwang@linux.dev>
In-Reply-To: <20260703114128-2a7a4723-0060-436b-99d9-7499bd90fa82@linutronix.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 165E240006
X-Stat-Signature: coyun16koiy9nzxnmoquwzq1495c3jec
X-Rspam-User: 
X-HE-Tag: 1783091422-65020
X-HE-Meta: U2FsdGVkX1+eK5kG4kol6egFH5uVCG1Tkli43Nr/Vy99lMzgI8plqDAM/sz/09zG4FhlVu789E4IYK6SWqrdGWpWroao3s0gncDLilVNJA3F0q350M63vx673zWXQz42QTD9YDaOlrNxwpwCUOS0FsQGYoYn/R0ZSFpjwNWPmlILN6ItxPCf9WUK+Okf/tVVHSEvj5WetsS+YWeJjMTk7tFD9xPoo6hZ5u297QmHgznKWPcVTmmYJdXaoUmtMVhczzF908TVsMpT4JNyRgF8Z4VqG2AWnUlrwYsauFbr7f1qTztb/pEZwYK7ksss7NEfJIjoM4iK86svfTJn2p8AHUtM6TUD5TKcMc2xQO78R4JGpN9BuUTQD/mHLIyvv9e7HaqA7j/GHhgcn0kuSxiSHfoP7mGN8W2Z7A43o0W5PrtGWhkxJdn9ZXFHct3IgxCso54Kf7m+ftv4a1mVkmdnQu3ac8HYD1R/bca+OLGrYoAosyH6bXywvD2vyuQ2foAshnKkdKnzh8DvbmVRiGO/KqYhv/vygo8j5z2wzUGZFbxaDE4l9eUimBYWK3XA29Lbl1yyuNWVHQzzA3fhnewZEB1bs7vo9EWsrymA94o6/dEwiIqs739af7779BDTdYs7rKRsXsI7NDPNDD3G08yqS0HY6CowLWdrt66C32gmzE03ynsibE7CgjglTA9ko8dHdx1g2fCeoMp43QQLpDjpcHkpHDCUb0d/u7hTBJK02VT+zQSq/A001G/F08qzzhS+t8gQGvh22W0Hm7zzDfkNuup7CToQq1VgH7LEqjnTZx+DJeerdVC3qjkM/sUukg9loA4s05oFugv+FrCM9ftmoUb737s2Uu9Sha9aQ4q3qywBy27nHYmbN7Yae4lZhmAkDQfZ4OlUrG/wmdgetPK+ooHh99HlCp45hYfIuw/u65KHic8Yng0YStRydv+CZBiWumBVimJYELcdZPSjX+C
 uP8AVepB
 9HzlZIJxaehL2682sd9rsRS7Ruv2n8KkE33Ex/rrimSW/54GoZLq6hHS3u99NlWQ2dOYR6GF62FN6d6t3g04kmX9rH8vxfsoWShqzAyF/JzXgz8Gte61a61kU8TCY6PAeTCpcd+K/RDdf2My29C1s6FDjsBG8lkBW5H6zefRabauMc8frB20buEagEuyG1Qew6+lWYrnYGfXXK4KpCVxXavQNQBjJMLKj0SgMict/WZK3iKpKcRwoPbWQDc1mY7bYCrcq5iW4YwrDUmsck3yGECHqSqu/riLJcDJKppj7HGJtzhpDj/bs9Fdahw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026/7/3 17:44, Thomas Weißschuh wrote:
> On Fri, Jul 03, 2026 at 10:25:07AM +0800, Leon Hwang wrote:
> (...)
> 
>>    The following architectures currently support this feature: x86-64, arm64,
>> -  loongarch and s390.
>> +  loongarch, riscv, and s390.
> 
> For per-architecture feature documentation we also have
> Documentation/features/. Maybe move it there.


Better to replace with a reference to the feature doc?

+  Refer to :doc:`features/core/mseal_sys_mappings/arch-support` for the
+  support status of each architecture.

Thanks,
Leon

> 
>>  
>>    WARNING: This feature breaks programs which rely on relocating
>>    or unmapping system mappings. Known broken software at the time
> 
> (...)


