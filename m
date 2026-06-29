Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6BC3BC43458
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 15:20:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4EE8A6B0123; Mon, 29 Jun 2026 11:20:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 49FC96B0124; Mon, 29 Jun 2026 11:20:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 38E096B0125; Mon, 29 Jun 2026 11:20:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0E85D6B0123
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 11:20:13 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 68BDF1201A4
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 15:20:12 +0000 (UTC)
X-FDA: 84933311064.02.5B83E15
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 985E120003
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 15:20:10 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GXIsfJDz;
	spf=pass (imf13.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782746410;
	b=aF289JtvU/w5Ci9x22YFbjUSw4eX9NUrqiEAaK2a3Php0BusjrS8pYwI/83bj9UF4GtnFK
	c/dmdRtfrw95KnV2ekJyNbiEn/suN9gXOLlu5OAf3zT5UO+dnEoCT52zxgigXsMRYvYGTd
	2q25u2uMk0nk0DkXiDt0QW3qVVqTSfg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782746410;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lAK889VnZ5GR1ejnB0aGy9b8XfwY8yySXBWtcqayKUU=;
	b=yI15UzVL1w9GPrHJaqausunzPv8KAGKwPrvmOO1uCVF0fmX5dyfvTxs4b93k06vS001jLz
	2oASxvA6NzriRLzqRJmmgdrRrv3OB5POeis6vWhM8n9e9xrs87TlyjzDz3SIRzGxq415RR
	ECRtOtkbWm2hpDWkBvJK8NHT+sMqx8s=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GXIsfJDz;
	spf=pass (imf13.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C63A64352A;
	Mon, 29 Jun 2026 15:20:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F12B1F00A3A;
	Mon, 29 Jun 2026 15:20:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782746409;
	bh=lAK889VnZ5GR1ejnB0aGy9b8XfwY8yySXBWtcqayKUU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=GXIsfJDzyX6BUWkom6q69jdArKaxrNLPu+prOqdHr2uNODNVln7wtnlW4CU8QokP8
	 UngcxEWqvcTuBcgPyK10OIe24gX2KV1XUkb4ypgeK4FGuJNB24gHpHkbJhBdkrharB
	 thg2uvw5FZv5fi0+IP5mToROjvuHTtb/La2H2514ql4ZdD4tO/XDqReBVWGufCUn2v
	 zZ3xrv0xRHe0mJAJ2vSzxtfya8QHQSJrh+C/R6XXrjIgiLHVTBjmsYGpgRw3FWbBz2
	 zraz0APC6pq/JXbjbh/7yQ8qtByo3itYgemZG4ZGFkLiLGoJWgwiO0QB//7XK6J3mW
	 ldRSKvrM7+DLg==
Message-ID: <cfa56e7d-2395-44bf-848b-6103d53cccde@kernel.org>
Date: Tue, 30 Jun 2026 00:20:05 +0900
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v3 00/10] kmem_cache instances with static storage
 duration
To: Al Viro <viro@zeniv.linux.org.uk>,
 "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: linux-mm@kvack.org, Vlastimil Babka <vbabka@suse.cz>,
 linux-fsdevel@vger.kernel.org, Linus Torvalds
 <torvalds@linux-foundation.org>, Christian Brauner <brauner@kernel.org>,
 Jan Kara <jack@suse.cz>, Mateusz Guzik <mjguzik@gmail.com>,
 linux-kernel@vger.kernel.org, Hao Li <hao.li@linux.dev>
References: <20260611171425.1671254-1-viro@zeniv.linux.org.uk>
 <20260613050951.855141-1-viro@zeniv.linux.org.uk>
 <151b1c96-0ed5-44ce-b9d5-86a48d8ad592@kernel.org>
 <20260624004828.GI2636677@ZenIV>
Content-Language: en-US
From: Harry Yoo <harry@kernel.org>
In-Reply-To: <20260624004828.GI2636677@ZenIV>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 985E120003
X-Rspam-User: 
X-Stat-Signature: o9zaagh3er7a9k4bztwdn1jzr8etydwp
X-HE-Tag: 1782746410-478274
X-HE-Meta: U2FsdGVkX1/Olkht8LiUD0w7BmFZz8KF18XTSIy6eBWCdZX64jSe0qKev1f2aWGsZFVKM8FHY8P6rsxXks59KPSa8OyCuYQ88wvfnGgDox8wyZkV5cPHXBotf9qjpjIz1NxcOF7TUQT9vLgE6Dbjo5UVzlV1JkrK7FKCytO8Wzcf2ixAC64sJA5OWkQvxuNI6JHyfn/DYHQRxgkjV9mMqwbSEXIWSGkFRrUUzyNydIhfT98kqKP6I0Xl66t1slwisfnJ4QsSGAghKTEaIFqmwnP7ypOfSiTyIxS4OWa2LMhnLckQp4m9bEib3Odt24SJY5YYfZVnrnUiWi38FPeXtFkN6m4t6IRoWAOxLqeJHs0v/JKE0+9vJEwgRtqwoau5ws0hoUUjZhZESKOdIdsW7aChqMgv1Ot6GaxiU35P5Fj94DJrvurMTzV6lDeVv9+0zfKT3xre0x3pfLJ0nntQVRFvf9BOI1d7l4TkDqNDNQk2AyNH1h976Mp4sg/iXl8BxqGLsSRoZl2pRe7XsR9F2GpfGEj04bIVSr8IoiC8JzkSqjC4dM7t+WI4ArjSonwHtnZ0xwekvciJk4T1sjOnY0jFvff1m0FEU1vnGfSBYmOaGpovpetS4D0d1ub1fII27PhMSlzoWaXlmlII9zHD3qMPIVDtZU2AIGM8DqAfRjGjldeNbdannQjgk/1ij1bP8e4Ifsxt0lVYUKEiLL0H2pJR1X2JLXDrM77reyvi7+PY2+/1dJsOhrzyD9lQKxE3W9J8RTEmBlG3wwdWEzTByJ6NNfGJqaUlQqosgUENc6Hbl2KJk2CAV3Q0j8XZIndk2Dm2icUB9XL4ih2rGFOQQy56FYyqB9/P5vDjgvm/FNDuKyH7RpLxN/qGIxMfY0NEqXjOHASyupdLCZ/WoeE0Y+CDylvt/OOxURa0cRQjwtOdi/NBKVsYpvycUGkTWevAjKM9GPR+H9a7AIIevCN
 q84q7AQ1
 IYFlxTvGavHHUNLF8sfK+JCKmg56hRinuQUYwmQkkwyj41ezt9th1gL4XC8qb8VJiE5Sd016hhukGhhAOfVRd5NnnxNDt6n2rljtxmTChh0U2IVnGPfGdOBWJQKOPDcJKb0m1SRh1hXSUXFjKIWkKJ5Irgh+W1lyLTje3EcfJDzJvOeTmFeQ0U4My0kTbN4hMu30imof6dvCjkjpilvvLxEv/bBkQtI3b4ZqotmAo/qX59Qb2I3XCmeEXkCRwLVUMq14A46YCX1tXCIzBAVzQk5FHQun2Ja1c62mZcbMKRf9bV0x5Pbfgv9e8Va5U3TEekSkk3mTmngZ2i6SZNprbjhspehnow5hLwgE/7TZSfM0DlDXTm3HVbvRGqsS3yrfVi71zizdPsCZbRT1RySwk4H1qFmHNmXx0ZLrX
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


[Adding a new slab reviewer Hao Li and dropping my old email]

The thread:
https://lore.kernel.org/linux-mm/20260613050951.855141-1-viro@zeniv.linux.org.uk

Trying to follow the discussion here...

On 6/24/26 9:48 AM, Al Viro wrote:
> On Tue, Jun 23, 2026 at 10:09:41AM +0200, Vlastimil Babka (SUSE) wrote:
> 
>> But the argument for doing the static duration support is that it should be
>> faster, not just "not slower"? So is runtime_const equivalent or for some
>> fundamental reason it's slower than plain &?
> 
> Yes, on any 64bit RISC.  And if nothing else, arm64 has enough users to care
> about.
Agreed that arm64 has enough users to care about performance.

Out of curiosity, could you please share on which workload you observed
this (dereferencing cache pointers) on profile and how bad it was?

> Compiler does *not* build the address of global variable in a sequence of
> shifts and bitwise operations when it needs to pass it to a function.
>
> runtime_const_ptr() must be able to handle an arbitrary address; it can't
> avoid doing the general "build a 64bit value in register", which tends to
> be nasty on RISC.

It'd be nice to have some examples in the cover letter.

So if I'm following correctly, arm64, for example, uses four
instructions to build 64-bit value in register (one instruction to fill
each 16 bit) in runtime_const_ptr().

And by making it plain &, the compiler can use clever tricks to use
fewer instructions to do this?

e.g.) a quick search says [1], on arm64, it is possible to reduce them
to two instructions to build the address of any global variables, one
instruction (ADRP) to generate page-aligned address using pc-relative
addressing (within +- 4GB), and another instruction (ADD) to fill the
lower 12bits.

That's what makes it faster than runtime_const(), right?

[1] https://devblogs.microsoft.com/oldnewthing/20220809-00/?p=106955

> If you want real ugliness, take a look at riscv - AFAICS, they wanted to
> avoid a long dependency chain, so they load chunks of constant into 4 registers,
> then shift and combine those. 

-- 
Cheers,
Harry / Hyeonggon


