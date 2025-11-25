Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6975AD0EE0F
	for <linux-mm@archiver.kernel.org>; Tue, 25 Nov 2025 18:56:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C51376B0028; Tue, 25 Nov 2025 13:56:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C01756B0029; Tue, 25 Nov 2025 13:56:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AC8C16B00BA; Tue, 25 Nov 2025 13:56:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 9696E6B0028
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 13:56:21 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 36819130ED9
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 18:56:21 +0000 (UTC)
X-FDA: 84150034962.26.7098B8A
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf17.hostedemail.com (Postfix) with ESMTP id 94F924000B
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 18:56:18 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=VnkDbdow;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=WI9x+Hjp;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=VnkDbdow;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=WI9x+Hjp;
	spf=pass (imf17.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764096979;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MZhxcSq9jz3i+YAFu/iNlBsFEWcEIog5kMoH5BURTNQ=;
	b=a6QNC9PBxuJej40znKVdQZ77SKSyk/8ZVDeZSTFzF0/ddPPUs8SYE2WsY3oRMiC+EDLuSY
	cIBio4rldQt95XJN6hh0RytCI70slZFI8objKIhTKawvGlwH8S794zr7LsogB2pjUcJa/K
	0HqI89FhO6mv6HJe/MorrZji0p5fanM=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=VnkDbdow;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=WI9x+Hjp;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=VnkDbdow;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=WI9x+Hjp;
	spf=pass (imf17.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764096979; a=rsa-sha256;
	cv=none;
	b=RMeQblMR4TIr1BMglVsWoGMepY+CQr6maBfu+bhBaDo9Omfr1c3EHOBO4w4k6MUXBrFe8j
	YW60Y69qpNylEeZYHYr4PrF/PXMjvJYHECjWilqzg+HZgYoNVjmpeKjMrbJbJwzs2iUcky
	xtY1MDGbKahYw4lHjhGC/flPxhxmhM8=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 9672F5BD0D;
	Tue, 25 Nov 2025 18:56:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1764096976; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=MZhxcSq9jz3i+YAFu/iNlBsFEWcEIog5kMoH5BURTNQ=;
	b=VnkDbdowD8JfpomKJ+CQ55m5GyxNxjcZmaz1gbpHjxl6yn1XZCSMsjhdxQAeG/d6hm8cy+
	QImqb7ZLaUcA0sD9xTMfxeY9PpunHAv9MxIrYNDWxAZAO3BqmeC+M9z3+JC7xe7hMr+91S
	H474vubuLEJuJlLQvsdn3QRtJCXctiQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1764096976;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=MZhxcSq9jz3i+YAFu/iNlBsFEWcEIog5kMoH5BURTNQ=;
	b=WI9x+HjppKEWPgDdr58Zx3sHlpDWL0Ua0SFxNCYnrE2Aw1mbWBoE+xpwH/yYn+v5CrZjM0
	tz/Y+JvHVGzsSqBg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1764096976; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=MZhxcSq9jz3i+YAFu/iNlBsFEWcEIog5kMoH5BURTNQ=;
	b=VnkDbdowD8JfpomKJ+CQ55m5GyxNxjcZmaz1gbpHjxl6yn1XZCSMsjhdxQAeG/d6hm8cy+
	QImqb7ZLaUcA0sD9xTMfxeY9PpunHAv9MxIrYNDWxAZAO3BqmeC+M9z3+JC7xe7hMr+91S
	H474vubuLEJuJlLQvsdn3QRtJCXctiQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1764096976;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=MZhxcSq9jz3i+YAFu/iNlBsFEWcEIog5kMoH5BURTNQ=;
	b=WI9x+HjppKEWPgDdr58Zx3sHlpDWL0Ua0SFxNCYnrE2Aw1mbWBoE+xpwH/yYn+v5CrZjM0
	tz/Y+JvHVGzsSqBg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 46C4F3EA63;
	Tue, 25 Nov 2025 18:56:16 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id KvzCD9D7JWnGawAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Tue, 25 Nov 2025 18:56:16 +0000
Message-ID: <b7804333-6030-4bfd-8e0b-4479f87060ce@suse.cz>
Date: Tue, 25 Nov 2025 19:56:15 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 2/4] slab: Introduce kmalloc_obj() and family
Content-Language: en-US
To: Linus Torvalds <torvalds@linux-foundation.org>,
 Kees Cook <kees@kernel.org>
Cc: Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>,
 David Rientjes <rientjes@google.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Hyeonggon Yoo <42.hyeyoo@gmail.com>,
 "Gustavo A . R . Silva" <gustavoars@kernel.org>,
 Bill Wendling <morbo@google.com>, Justin Stitt <justinstitt@google.com>,
 Jann Horn <jannh@google.com>, Przemek Kitszel
 <przemyslaw.kitszel@intel.com>, Marco Elver <elver@google.com>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Sasha Levin <sashal@kernel.org>, linux-mm@kvack.org,
 Randy Dunlap <rdunlap@infradead.org>, Miguel Ojeda <ojeda@kernel.org>,
 Matthew Wilcox <willy@infradead.org>,
 Vegard Nossum <vegard.nossum@oracle.com>, Harry Yoo <harry.yoo@oracle.com>,
 Nathan Chancellor <nathan@kernel.org>, Peter Zijlstra
 <peterz@infradead.org>, Nick Desaulniers <nick.desaulniers+lkml@gmail.com>,
 Jonathan Corbet <corbet@lwn.net>, Jakub Kicinski <kuba@kernel.org>,
 Yafang Shao <laoar.shao@gmail.com>, Tony Ambardar <tony.ambardar@gmail.com>,
 Alexander Lobakin <aleksander.lobakin@intel.com>,
 Jan Hendrik Farr <kernel@jfarr.cc>, Alexander Potapenko <glider@google.com>,
 linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org,
 linux-doc@vger.kernel.org, llvm@lists.linux.dev
References: <20251122014258.do.018-kees@kernel.org>
 <20251122014304.3417954-2-kees@kernel.org>
 <CAHk-=wiNnECns4B3qxRsCykkHwzovT+3wG738fUhq5E+3Lxxbg@mail.gmail.com>
 <CAHk-=wjxj---dy5haOvNXjg_Xz-mDQciGL7OnJnpJpjYD9Moog@mail.gmail.com>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <CAHk-=wjxj---dy5haOvNXjg_Xz-mDQciGL7OnJnpJpjYD9Moog@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Action: no action
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 94F924000B
X-Stat-Signature: wupu7ai8ugxu5nmjny3f8yku9ns1coxp
X-Rspam-User: 
X-HE-Tag: 1764096978-817576
X-HE-Meta: U2FsdGVkX1+91TyWHUW0lhF077EjErivwQ2TdZVgXii4G/MMvkVwn8X3v6DebupNl6f/mOy2VFdgfNtQHtO0TEyeP2JsT/hEj4EPMnRC5R9TFWCd873zgiU8SLRXEThUJU4Tr5fS5EDt4DiU/dkiInRzjicy0TU0zIKVfuVTqYTebFnFWbChbMyW//tbyLmUaQHwykWY/ue0Yz4rA7MM/axrIg/Mkh9oz1A9q0DzyAQVqEY7mGp4J5SQzP2frKiN32jzHxLvQDRVo0WbPU1WbauJ9/DYSXhSFsV2O6zrKwkioWtfngrYbSjPU42NKvk2mxBj1RqpNNJW1Dr14hfaq4ti5PkfvN/4XFaQXAFXwuchjDZz+OpxNa+ujmkVXM/oEqMbtqoOpMzBlbLqSvnUT6CaS7+3g+ZpBd+BLrsThviVvRusacQtZKQ4YMkQIzANCPGratbyerXogbGc4bof4w2EALpSUpazkpMO7/x6USN3RO3j3m/q5QyCN9Sw3bSyRZsVeiiluNz0eMj1Z2FNLcEU9aDD5OVJ1T/ImCbR+Vc5u273F3ZmvrgoDXPLYyYsvPJ//qRce7UnR1mv9t4HOwOYkna/dMskDzJa+Ei/qD2xzm2bYAulzk+qXSVKTC3a3agaPljT2Lrj77GHZkkonxSUIXDws/WdLhSI1SNZzelW2Alds4cy/V8zMU3ZZWDC4frjSb45KdDXPMkkQk11tQadbBLproKQakQTF0AtXMDVS08rs0vf0BT0R7LKL+lRucwsihS2aL8rvO6leo88c6SxM7tvh8kFZmNNwnF9QrwoYOYUHhusjbJG5sPPOByT1KnWvNyN6FOhPjwP3kZ6ZG0B614Oh7OPUfik4BPeY5+dLefKnhlZ31uuaI1deevfmNcBgWB3f8x0MVQ6Bvacw/WXdSo1Djp9GT2xu3+vsX8tm6qImAD23SQfEfEigdudf9qvpNBpzn54p3iYTeD
 Hxsq2bvY
 FyAUrsM9b0ZiQbt5UO69T3SkhCh1YnhvQI5QQ1zj1aLsl86X3EhbkuaagHw1HW3z6LS9w6HDKbkDUc4gmnGFsmE+r9/GAeDNEFolLViSuRv79qySPBKBTRpGOTmgBZOKVwVZsheo7EWHPi/qXZjZEYgbMv8Gzs3d7WUNf2f1dYYYuXn93mW5eFPtqRfYHufIcqBiMjfGQbJO2BPDERSlA1cMpSOBhoOInFNFYOq+vlgDUYP9WAWB6AMFOe2iMLIzbh20ZwANdj0tvoChWY1jZC9iKAfQlHS8FMDJf3R0wyUCujggHitLJtJw25VQjrXufyeg3XyyCPK13ZidzGfIcreJ8lZIdYDN1Nnx6OCec0uAA4saovUW5SkCHG+NVUyR83PZRWG34mZcL+6cV2FhA7kJ/IiRmIIkim6lC
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11/22/25 21:54, Linus Torvalds wrote:
> Btw, I realize that we don't have a good way to do the alignment with
> the current kmalloc() interface (we do for some of the vmalloc
> interfaces).
> 
> So for now, it should just have some static build-time warning if the
> type of the object we allocate has a bigger alignment than the
> guaranteed slab allocation alignment (ARCH_KMALLOC_MINALIGN or
> whatever).

Note that these days we guarantee more than that, and it depends on size.
From Documentation/core-api/memory-allocation.rst:

The address of a chunk allocated with `kmalloc` is aligned to at least
ARCH_KMALLOC_MINALIGN bytes. For sizes which are a power of two, the
alignment is also guaranteed to be at least the respective size. For other
sizes, the alignment is guaranteed to be at least the largest power-of-two
divisor of the size.

> And I really think the first version should do the minimal thing that
> actually matters, and strive to deal with the simple cases. The main
> things that matter are
> 
>  - the return type should be a proper pointer type (so that you get
> warnings for mis-uses, but also so that you can use automatic typing)
> 
>  - making the 'sizeof()' match the type
> 
> so honestly, I think 99% of the gain would come from something fairly
> simple like
> 
>     #define kmalloc_verify(type) \
>         BUILD_BUG_ON_ZERO(__alignof__(type) > ARCH_KMALLOC_MINALIGN)
> 
>     #define kmalloc_size(type) \
>         (sizeof(type) + kmalloc_verify(type))
> 
>     #define allocator(name, type, size, ...) \
>         (typeof(type) *)name(size, __VA_ARGS__)

So AFAIU this would be too pessimistic. I'm not sure if the alignment rules
can be sensibly encoded in build time checks. Perhaps yes, in a similar way
that we have compile-time size bucket selection via __kmalloc_index().

>     #define kmalloc_obj(type, gfp) \
>         allocator(kmalloc, type, kmalloc_size(type), gfp)
>     #define kzalloc_obj(type, gfp) \
>         allocator(kzalloc, type, kmalloc_size(type), gfp)
>     #define kzalloc_struct(type, member, count, gfp) \
>         allocator(kzalloc, type, struct_size_t(typeof(type), member,
> count), gfp)
> 
> The above macros are entirely untested. But they are simple enough
> that even if they are buggy and I miscounted the parentheses or used
> the wrong name somewhere, I think the idea is clear. No?
> 
> (And I made that "allocator()" macro use __VA_ARGS__ because
> kzalloc_node() and friends would want that, but I think it's starting
> to hit diminishing returns at that point)
> 
> Hmm?
> 
>                Linus


