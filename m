Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1C234606A32E
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 09:44:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=ieFLPrAQ
Received: by kanga.kvack.org (Postfix)
	id 28B3A6B00EF; Tue,  3 Nov 2026 04:44:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 233E36B05B1; Tue,  3 Nov 2026 04:44:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 149866B05B2; Tue,  3 Nov 2026 04:44:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id EE4B86B00EF
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 04:44:25 -0500 (EST)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 72C46C0376
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 09:44:25 +0000 (UTC)
X-FDA: 85393322490.13.00F6103
Received: from mta0.migadu.com (out-75.mta0.migadu.com [91.218.175.75])
	by imf27.hostedemail.com (Postfix) with ESMTP id 46D6240007
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 09:44:23 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ieFLPrAQ;
	spf=pass (imf27.hostedemail.com: domain of hao.li@linux.dev designates 91.218.175.75 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793699063;
	b=7j/KyOtjtA4/AQicDBhIHs6HMrqclgL4MdRjlAfYOK5wkMY1o6ZVH/cC/Z7BhvIeNXjdca
	IoNj++NBF77WgfeL/g9koX1Tj4hASDc2asSfU6I5vPUd3DpZPfSzem/U8Wv6ktOcaM6yfl
	WFC5hRtLxbazTIyGQUgUmOLzNLxb4FE=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ieFLPrAQ;
	spf=pass (imf27.hostedemail.com: domain of hao.li@linux.dev designates 91.218.175.75 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793699063;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SYguy4w1YM/41pc0M9vIj3VvmIP455ki3qTLrxyk+EI=;
	b=g7aJn1YIxbBe1o2IWdxNN125D4TEwCubaMjGjpDQsDiVGeZQE31rlxpNPH6s0Dl3LFMvym
	uUa2KavCCtVsjFMHfobyVeJx87h1OV6zqkcdzHymbhW73wKzD3Y5jfFet1zn9KtmZJrcFB
	HvyuO/DZ9S8o6InjZmLW26mEkuHsWSc=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=ytP1FYc4mLUgzvNlPS6MBB0Sb8vEqTbsbrXFac19CKg=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793699061; v=1; x=1794303861;
 b=ieFLPrAQNPYCccev6UXHzMnB/eE9I4RjivSB7cPgBCgLf1Z8p1TfRXG7rfFpnXmyGRMvcsl1
 wsGBySrF6FiAcQiv89dASwBemAj0bwqYL7FYUJTfTHDnWlsdVoKgpiWfJybTAW6RWw5nyL+peva
 vSSJ4ykA1PniS3QBWk7KaNO4=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 4fced7d92f6bec66;
	Tue, 03 Nov 2026 09:44:21 +0000
X-Mizu-Trace-ID: 4fced7d92f6bec66
X-Migadu-Flow: FLOW_OUT
Date: Tue, 3 Nov 2026 17:44:13 +0800
From: Hao Li <hao.li@linux.dev>
To: Tiezhu Yang <yangtiezhu@loongson.cn>
Cc: Vlastimil Babka <vbabka@kernel.org>, Harry Yoo <harry@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Christoph Lameter <cl@gentwo.org>, 
	David Rientjes <rientjes@google.com>, Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org, 
	loongarch@lists.linux.dev, bpf@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1] mm/slub: Genericize x86-specific cmpxchg16b comment
Message-ID: <aumssHCOA4D_BFm1@fedora>
References: <20261102082730.12430-1-yangtiezhu@loongson.cn>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261102082730.12430-1-yangtiezhu@loongson.cn>
X-Stat-Signature: 4r1o5rfhpksdchzr3xmf5uygeqmu5fz7
X-Rspamd-Queue-Id: 46D6240007
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793699063-961761
X-HE-Meta: U2FsdGVkX18vheNI2hYwFD8AqSkbH2zAL1oQdtr35lGTXhJX9T62i43itsjXHkkMogiF2x5jjtEM46JydFSmESrRHKSJwA6xNu1C6AbmivQXOxmphWIRwmqw7TZzdK7uIjHGj9b0en6UHr3DNcxaVm61hI+CO4ZNGVhwOrTvtrpXmxhk4oCdW3tGNwEAFyHkmkHVyE9MzQRwNCr51jgLBTZRMqHigYiaY883HoigduzzUXAF3uOQiw+HabSiMsRvjvMtgUFHBseZxOrX2uKzcRHYMdBlfrqxXDu4DFzcpziNL4YjSFCjLe8lSV/HDi3BEM+MnAKPCeATR3VgdpPhfjCgM70LDQY1lvxLOpjyeXiA/6d5rlXe7h0MM/sRvvLsLdYKKvcZEPzhZUSKTjQ6BK3kElu0XVuReOQKBp3EegW6deU3AECxS5MNg38UjqcqbRGxgSPB2cjHpdEh2sAyr4CtU7hrxU/pJXwTaBalQIL+N014/yRlQTSMX4uVGcqedAkK1MH/YE8dQRF+UUH4B3d+zr25HpnqGkoc49t5LX79LRZ1qBRO3bUkZm1F4Hh14VjWVXQKW6hmXm0WM1OKkJJ23KrNysClyaM+BJ6IkzF9jEV0ugd2nxm9Qb6RL7xowNYVMDyfg9IEsEeG1vTWnmOi3VWR3EzQnZ9blmpXpxDO4fOeTO7CO7ycobuXIrDbqsGrOKdXGnXHn8NmySvXwHvgl6mK5DF2J+YjtFPo7omzVlH56aX53nUBTMyy+z9Gb21YBV4Le7MzmiTUupCzzllD4R+fo1RLe3iGN+W2r1ZBg8FH/pSr97CP9uZellPhD6ZGjPFKNmWB/Hl3VyVhAz2NYgRly4tBkK1cYXVkiBSRA2m9Zj0+f7R/PRhZ3bOEzwLEi9teVAg0vUNZKNizRDBlX+1HZ6FGTd/rM5l05ep3Ps9Sv5/j0XbnZM5U7VGVcIRtFwsuQqfqOfZVTkE
 iZhbjFUc
 P9bm1nVdfcIjPHz3XC8f0hlKw+VvGRz32YAG3S4BOmCqAsMo38Nu0Z7ka3UW8SygmXyJ8LXD/5MjfOGBUzRrvi4oLBD2Cm4kBedSsaNZ3HCbTencw2ul906GE0vMGCRFuNQneAnudtJ3atibQeQ36+KzhSVF1gwkdGycHjUeP4omOm112egVMsweo6fmX0Y0oBc12WN7azt3LTTWA6N8/q3RaTLgfrsvfbXunC07Bq2bPBPUfKEglEjv/dMuplLGcwyKdClfgX5/8t+o=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Nov 02, 2026 at 04:27:30PM +0800, Tiezhu Yang wrote:
> The kmalloc_nolock() infrastructure relies on slab caches with double-word
> atomic cmpxchg capabilities (__CMPXCHG_DOUBLE). The current inline comment
> in __kmalloc_nolock_noprof() uses 'cmpxchg16b' as the prerequisite hardware
> capability.
> 
> However, "cmpxchg16b" is an x86-specific instruction mnemonic (CX16). On
> modern architectures supported by the Linux kernel, this 128-bit atomic
> primitive is satisfied by different hardware implementations:
>   - arm64: satisfies it via LSE atomics ('casp' instruction)
>   - s390: satisfies it via native 'cdsg' instruction
>   - riscv: satisfies it via ZACAS extension ('amocas.q' instruction)
>   - loongarch: satisfies it via SCQ extension (using an 'll.d'/'sc.q' loop)
> 
> Update the comment to refer to "128-bit atomic cmpxchg" to accurately
> describe the cross-platform hardware invariant needed by the lockless
> allocator, and to avoid misleading developers of non-x86 archs.

Personally, I feel the commit message is a bit lengthy for a simple
comment-only patch. It might be better to keep it concise and just directly
state the purpose of the change.

-- 
Thanks,
Hao

