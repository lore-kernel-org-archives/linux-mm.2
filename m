Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EA723D10362
	for <linux-mm@archiver.kernel.org>; Tue, 25 Nov 2025 22:41:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AD5326B000A; Tue, 25 Nov 2025 17:41:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A85986B000C; Tue, 25 Nov 2025 17:41:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 975166B0011; Tue, 25 Nov 2025 17:41:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 859A36B000A
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 17:41:42 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0436E8A627
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 22:41:41 +0000 (UTC)
X-FDA: 84150602844.20.14D2C33
Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	by imf01.hostedemail.com (Postfix) with ESMTP id CE4294000B
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 22:41:39 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=google header.b=fcO5Iv+K;
	dmarc=none;
	spf=pass (imf01.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.218.46 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764110500; a=rsa-sha256;
	cv=none;
	b=DpkLaG6+HTHVjokQ+DX3OWkA2SS3WAzNvdZmztQe4Clf0WVKUPQmb6i3VQOs+zCWUFGmNb
	RX4DJVcqIDWp2ukn537RH8L0LRoktrnN+Qx68SJe4/JPNtbtQc2ViJe0T1k+M1gRK3NJiV
	xmajnrRS5D/wv0ldKzkQcYJzm/xxoPQ=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=google header.b=fcO5Iv+K;
	dmarc=none;
	spf=pass (imf01.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.218.46 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764110500;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PICSSTOVtSfieJ36Y7geN1Ip3ZesP7jblQQJyY8Iec8=;
	b=pOGTj0K5zAZpnMFFK0sUK+Cr9480epaoUlejDfLuXRhJBA3cv0KQ61IHJXsa2NKJXHAZ5v
	ByvGA81Cg7GIEdfi22/eQFHIWEPtssaaY3u2usJJfXQ24+eGIwQ2p5ItsVnBFtYlMe8PdX
	xY7MQP4cmcV+lhMlhuSo8BXGg1yMrn0=
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-b735b7326e5so52337766b.0
        for <linux-mm@kvack.org>; Tue, 25 Nov 2025 14:41:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1764110498; x=1764715298; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=PICSSTOVtSfieJ36Y7geN1Ip3ZesP7jblQQJyY8Iec8=;
        b=fcO5Iv+KC7KRR3FZGy+jidSXBsl3O4DeCY+kHN5foG0qvlHwo9efdGr+SjvVG0n6Nh
         Q/qpgyj2Ki27iGooqxAZh8ZcXBJaJsTeR1+ewO3KVPAv+RVj4YsgBoYXgxzGVgjAHyiQ
         7jtMbvriOi/fbUB9cbHDLLFGjWKERLjU9X8gA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764110498; x=1764715298;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PICSSTOVtSfieJ36Y7geN1Ip3ZesP7jblQQJyY8Iec8=;
        b=b1SXaFjkbWXCBEnlFElI+qlaPMubGbL9w0+GWCb5DrUQHGgW6qm8Nwg+uvj/NOQxO1
         rAMXBio8ZbvZU8FlGXArjm5+1CQjq6KlPSO71nOM2QNMZV+DPSpnrfDM1xicOmjvq11u
         LSGy/oy2HQmZ73HosS83hFR+UfwZrUaL+etldZ7J49P3k18ag1k7azedr//8aX6ZKw7V
         v/Xya80QFAdNotgpGoCUrCqDA/xF9sQQBOR7vM+qEA7vjSbygvR5zw+n2gCWmXXJ3ZRI
         NkjuV6k69jrY+4pvXmJZVfKGLSOULkIPhtNfWv1kITDVN8h5PB45IE7EKwxBpRODOqtO
         yu/A==
X-Forwarded-Encrypted: i=1; AJvYcCWhA+GBD2CYqF5G4FpBetlA3T9SG7TrbIAGbfLS5+9STGUI2AC0bSiUCy2AtjnT/eXmg9NXU/L5bA==@kvack.org
X-Gm-Message-State: AOJu0Yx1lZ6DYLwsPGOxRFqtAUlGHfoYNfhTqFq7GFOc1UrEGg9nK1yn
	B4JPNJ6U5tRDiB30ndlutRNfXqDfIKjOeN/1Dvx4TPrQV1XNaZI6JScG+TMYbAh8es/ERYSVq10
	7SM3WR24=
X-Gm-Gg: ASbGncvwF9pVD6grpOvt2q80+ECSaue7XPMUyOhR3n4UuEm/DCECSsZAqN1YNguPRg3
	XtfKo9wYCx7pFXkajkP+mIWMJNmZR0y6Y06sjhu4mTg6yXFfboaymO29zjunJMlbVGo3k05fJiF
	nlt50SFwzegz5xXPOPfb8XFRXFle9PrKngBBcLxLFyOQvkLQFaR/whS7AVB9o18kl0kzJSw5Xzl
	I/YxdRFExXizybQro2pYeU0vCgo12b8NMwbmroAzcrcuZn8rCoOLKv1lle5RdXoFMPXReMycSBE
	/2du9HUleBfTIp9UoP18L1hFMwWZp1xa2cN+ux1lrqV3M5ol0OmQFlxtmZkeIY8ONs3pDV476g6
	NMMSDy9F8Ye7/IEOhR4ca+M/DndkQv6rtd+sWYYqEdOkQtgfkEQWGlyO4MMJQAVs88PqHLW9aGT
	SWkLXbMDoaxwRn7EpsyoWCJ9TzNNZK0TddioD8+J5LiXLE4SfXkdTLuJh53JCV
X-Google-Smtp-Source: AGHT+IHO1Amz/iRj8rATN/B3wx2t2ToyD/VhZ843PQ5aaLkJcenCNLAKSoL/lhiJlPcE6CA6kpgs4A==
X-Received: by 2002:a17:907:3d87:b0:b72:671:b2a5 with SMTP id a640c23a62f3a-b76571367f9mr2700006266b.3.1764110498365;
        Tue, 25 Nov 2025 14:41:38 -0800 (PST)
Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com. [209.85.218.43])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b7654cdac18sm1678602966b.11.2025.11.25.14.41.38
        for <linux-mm@kvack.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Nov 2025 14:41:38 -0800 (PST)
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-b727f452fffso46456966b.1
        for <linux-mm@kvack.org>; Tue, 25 Nov 2025 14:41:38 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCXMc/yUXpAfF6fDzvYM3cUg5L3KfXv5P76XctPcbrleQVL28jJ1IVKusrMVm5X94sZwgW04Na9RrQ==@kvack.org
X-Received: by 2002:a17:906:d553:b0:b04:48b5:6ea5 with SMTP id
 a640c23a62f3a-b766ef1d27emr2056801766b.17.1764110497696; Tue, 25 Nov 2025
 14:41:37 -0800 (PST)
MIME-Version: 1.0
References: <20251122014258.do.018-kees@kernel.org> <20251122014304.3417954-2-kees@kernel.org>
 <CAHk-=wiNnECns4B3qxRsCykkHwzovT+3wG738fUhq5E+3Lxxbg@mail.gmail.com>
 <CAHk-=wjxj---dy5haOvNXjg_Xz-mDQciGL7OnJnpJpjYD9Moog@mail.gmail.com> <b7804333-6030-4bfd-8e0b-4479f87060ce@suse.cz>
In-Reply-To: <b7804333-6030-4bfd-8e0b-4479f87060ce@suse.cz>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 25 Nov 2025 14:41:21 -0800
X-Gmail-Original-Message-ID: <CAHk-=wi6nqPAveRPjrH_=ombtpz00G--RH9_MyC38PzsDHcb0A@mail.gmail.com>
X-Gm-Features: AWmQ_bnHmATmDGg6MkJpXYuB1__YO7XbeBdtXEi7jxM1H4BelwLZXehOF1vhEBg
Message-ID: <CAHk-=wi6nqPAveRPjrH_=ombtpz00G--RH9_MyC38PzsDHcb0A@mail.gmail.com>
Subject: Re: [PATCH v5 2/4] slab: Introduce kmalloc_obj() and family
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Kees Cook <kees@kernel.org>, Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>, 
	David Rientjes <rientjes@google.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Hyeonggon Yoo <42.hyeyoo@gmail.com>, "Gustavo A . R . Silva" <gustavoars@kernel.org>, 
	Bill Wendling <morbo@google.com>, Justin Stitt <justinstitt@google.com>, Jann Horn <jannh@google.com>, 
	Przemek Kitszel <przemyslaw.kitszel@intel.com>, Marco Elver <elver@google.com>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Sasha Levin <sashal@kernel.org>, linux-mm@kvack.org, 
	Randy Dunlap <rdunlap@infradead.org>, Miguel Ojeda <ojeda@kernel.org>, 
	Matthew Wilcox <willy@infradead.org>, Vegard Nossum <vegard.nossum@oracle.com>, 
	Harry Yoo <harry.yoo@oracle.com>, Nathan Chancellor <nathan@kernel.org>, 
	Peter Zijlstra <peterz@infradead.org>, Nick Desaulniers <nick.desaulniers+lkml@gmail.com>, 
	Jonathan Corbet <corbet@lwn.net>, Jakub Kicinski <kuba@kernel.org>, Yafang Shao <laoar.shao@gmail.com>, 
	Tony Ambardar <tony.ambardar@gmail.com>, Alexander Lobakin <aleksander.lobakin@intel.com>, 
	Jan Hendrik Farr <kernel@jfarr.cc>, Alexander Potapenko <glider@google.com>, linux-kernel@vger.kernel.org, 
	linux-hardening@vger.kernel.org, linux-doc@vger.kernel.org, 
	llvm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: CE4294000B
X-Stat-Signature: jfw1nx41ceqq8xams7kh8nynejce94by
X-Rspam-User: 
X-HE-Tag: 1764110499-199052
X-HE-Meta: U2FsdGVkX1//3kfGHUtaL0TzDu1DuZP10Vs5LOg4+1QFwgPZJseJIwfwWFnjG4Xi/fseaKMu94Ggatge+WWkqSg+LE8VCFrescENjK4KQr4WeNJi+rnWG2JlkQJ6B/0RPSCHqRWP6keSQITia59q6O1nXg49R3XSlaNwtjDLBu7YFD0P6RaYS1+iDZiYliwraX2Bvn0/O/FXEDHhl9nqNe/+UFISWy7JZRr6YnNNBvAn2P3AjzyDLkDBSuDM87Dc8YGAg+9wuKDWf064kGzHqfcJEQC1kOIreDDjC7ORnnJR8dI0xZyHqPh3LSpzV4mFOqlc5Vvh09C8O3LIZmlm7V4BXucaJAVRb15SXNxMI69ZpSYC8OAU/BJCV6SPyLjZnakQUYDo/zOo1BGIegSTbN9QvSP2RfsSNSy5ou/CH9Ceg8g8LgualPSvFmIJG70r8QQsAB3SuomA2gWfQcriS8Aj/L6uzDU75axfJjl1manwf33lgxOGkVQboR8yZ1DqvYR11rElYC4b5d5zCTqvnkPMdAp87zZfEmjD2zp7Rck8WJyQDtCVnJJk0017shfWKAyN6v7xWT00EXu/AynNnIChW+ymwngVEIaODGyOEWM5vlTn0AtzgRsOrNVBtzbo+R3doID2clKtz90dzbiQj2rFPR3evnjqII1dstmDECQQSi2TncCchur8FkkfYcHf2mVaxEKkgrCBsi1c/g9dwyBuLshV4QgyAQwea2LMYgnHzJHig+YPcRqvSrpcHp+ycu0ajoz/SZw6cTeenClq4PpeXfHSav01kjI3pO343TosAbBBtM6dtUs88XboUrFLROuet4bC05WEIkIIG3MCYyNUN5T+08TfZRtJu7Ciqwswf1Do71DPjbWh2dSONW1R9p0Gsv1+YOZ85NvbPvpoyA7xseyYU64WP6l9fOopZxZceh4YZth8FS8f+YsBko5/Hp1C4JjTMTUOo4wdu51
 lgVY5qmH
 rqEEV2uacuNC3e18zpHaK/wwwFTI7vpBDL1f9PH24NymZF3M+auztDLS+gG801wvBiCZPEIjELHTMKJLAkxOeplAlTZ4vEv1X18L9mFTEYV8uQzRh9/L/s7wkDEonC1w1N23QPz0cVzF8XiXn+qJ+AG1KlhZmN6rr4R40puvAtnzQP98uJtK/D+XssHsNwZ6xvluiewMz0NnYpRgfDNulDq2teJdztuX9pBhXpwwGwCjWgnlx/hCeJLK6WcTE1z/eiX/kzYaNPxU/tgZg/SFcZIv89kHVMgPhV/PuDip4uWWmfy0Let4XfAaPnZxx4oTOqcpNIRs9qPBp4JBnIq88LrIdN1R5XM0wLTwfnjEEsZ1SHuoVi/zL7pJtxcdIk/WIn9LD2xNFTEtYRTqW8Ik5NRgQaNzjlM+mfz3U5NIiZMTtS1Xhu5PzLcj0XdzGtKJWkawl9Yspeiqx8dWgPakz8Y/3SLMoQh4giuNJPHRfji90dlwLlyZZZ9HDJoM4tFfmE3non2KkeinG7rbrTOYO/oWsJQXvSFmdrp8dG1vUp6GRX8OGnnFL/9Zta5pqWOcIwqu3sLNjyOGIcc5zKjxFE0EBrA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 25 Nov 2025 at 10:56, Vlastimil Babka <vbabka@suse.cz> wrote:
>
> >     #define kmalloc_verify(type) \
> >         BUILD_BUG_ON_ZERO(__alignof__(type) > ARCH_KMALLOC_MINALIGN)
>
> So AFAIU this would be too pessimistic. I'm not sure if the alignment rules
> can be sensibly encoded in build time checks. Perhaps yes, in a similar way
> that we have compile-time size bucket selection via __kmalloc_index().

So I wouldn't worry about it over-much: it's actually pretty unusual
that we have any odd alignment rules for anything that we would
allocate with kmalloc.

And I don't think a 'kmalloc_obj()' case needs to necessarily *handle*
such unusual cases, I just want this to be *detected*.

IOW, what I worry about would be people who use the simple object
allocator mistakenly on auto-pilot.

So if it errors out about "you're trying to use the simple model for
an object that requires non-simple alignment", that is perfectly fine.
Those cases can - and do - use more specialized allocators.

Yes, yes, in a perfect world we'd just handle that case automatically,
but it really is fairly rare, so forcing people to then use some more
involved interface for those cases is maybe not optimal, but it's
perfectly ok.

              Linus

