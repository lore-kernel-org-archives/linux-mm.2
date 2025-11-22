Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 777DACFD2F3
	for <linux-mm@archiver.kernel.org>; Sat, 22 Nov 2025 21:00:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B9DD96B0012; Sat, 22 Nov 2025 16:00:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B4EA16B0023; Sat, 22 Nov 2025 16:00:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A64406B0024; Sat, 22 Nov 2025 16:00:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 90FFC6B0012
	for <linux-mm@kvack.org>; Sat, 22 Nov 2025 16:00:55 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 08341BC72D
	for <linux-mm@kvack.org>; Sat, 22 Nov 2025 21:00:55 +0000 (UTC)
X-FDA: 84139462470.11.FEF6308
Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	by imf22.hostedemail.com (Postfix) with ESMTP id CB4FEC000B
	for <linux-mm@kvack.org>; Sat, 22 Nov 2025 21:00:52 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=google header.b=JCktNlrJ;
	spf=pass (imf22.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.208.52 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763845253;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jQGcvOhJEN1J1/uUViuAgWsDBHc/YH/i6gYOyi8rm/I=;
	b=j7UHv2BH8dNO8oYlrP4w2LMcQuwDhf2/c9s+Q2r8NKuOy85yvYNJIoSDOvoz/mkhzu/tKf
	nJqmqKpL6TfXaWBK4QQgHxMQHo5wdSSIdBZX/kn0gk9W1BLGtVnHifzCtfOqt9glgIsWDD
	Wf4VbF6FVgz5431jkv1rHlmORys+yqk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763845253; a=rsa-sha256;
	cv=none;
	b=QPXqKfbRN5KNOg6aedsasB0L344+P7MhDaQJvbFfkduohe8f94s3nxAdq2blb9sq1BH0g2
	ztI0jG4I1k7RoY5sat4SdrAXyeZQabngmZblZnua1dmAzFuUURlj0HNrC83GYJnTB5uKIv
	wEPjNO6kpA7+vFY0MB1aMlWqDUlaHwM=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=google header.b=JCktNlrJ;
	spf=pass (imf22.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.208.52 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org;
	dmarc=none
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-644fcafdce9so4790662a12.1
        for <linux-mm@kvack.org>; Sat, 22 Nov 2025 13:00:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1763845251; x=1764450051; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=jQGcvOhJEN1J1/uUViuAgWsDBHc/YH/i6gYOyi8rm/I=;
        b=JCktNlrJnPZKfhgC0x+mmbg0G0TqhDdHMD1T69wuj34UTkn1h1npiHiNfodXJJynEn
         7Y8BJ5QqIHaq2wEM8DVWWcC+PfMr8flOFozWQjL7ryZxu3wTqtINgZv7G2pBeXx+h58T
         WtNUtCUpVE01Cj3c/8kUgGJLscdwOL6E63EHY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763845251; x=1764450051;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jQGcvOhJEN1J1/uUViuAgWsDBHc/YH/i6gYOyi8rm/I=;
        b=H4u8lVKpUsoGQIqykAAZVjNAWwZmG/2idY4cjpw9NZnXQT8BanAJhl5rp+Ih8kZNcw
         v1AEmRwFzfa6aCkRp2XKlbAmv9ZCO/jWtgsFizrZKUw9fzCjqBNo8b/KJ9HtSS8s511z
         kwH+H8cuuQcgtwc2hNXtpQTmZkQyJImWwW4Gtf9+1diQfQtQR0ecvml2QYDW1nCyXaO/
         qNk3C7SgDjs4Pam/LLAb5mLVfnfzpJLJ5A+zVK15IHUYmhRWgtO0dlfsIZXoDVvnJCCF
         jK301OZxc8vg1l334Bw7BO4F8tJW5xCiIkXRtDSPNx8Y0bPKuzkZknjB8XectQ9DVWHg
         biXA==
X-Forwarded-Encrypted: i=1; AJvYcCVeo9h7fBkf9BzI7KmuKPywvC1sgW1Fl3sdYa5YK/Gr6xfsi9ySOcfOnyKJQyFgJRGzwJ/iDren4w==@kvack.org
X-Gm-Message-State: AOJu0YyIsJWL5OfVhnk/2ne/6SH4xXA3fak1kQ1E5yfmEN0C3w+6xZ/M
	FRgJyFE1by+DdVwFhC9/mKBO4ijd4gByoBdrHQLSCs+M1t0ZPeqoTdAhtyFDIwWnHjl2dr9B919
	y6MQ8rvC2lg==
X-Gm-Gg: ASbGncv3V+bpCEnUbiV6ImMFIO3lGwJK2nyytVDXYxP4b4jZzXCOXDY4XV6klOPsTkD
	YpqRKfemsmrqul93BowECgJ2axhyhmxtCcaFB0rT9COavAlUaUAFveC53pxWYcohsmbmvfMI6iR
	w37n/dU0RsLLlILOmdINnKqKf2nfYGmhGKnroaXAz/rjs9rP217aXWU4MTD13sx51Y+ND4Bm2VD
	6sdyA1PGEAD+vqfIiFKdSyojUDfmT3fzQSUL+Dkxs40k85PUP13ywk/RFHrUP8vzwmD/8jenYfY
	/ogtvGQPbZn0a/NzULpEbFgj+LSVnX97/zHPp2Pne73zr4GKhYLwT0F2OPbSz5x3fkwrYWYM89x
	C59kUDP+zkKiGUuL2M3DxGbrN9ZXY+iK40VuQQwvK50b171597OCQ3wOSodkB6QORNGS2U7L5vM
	mcnNoizyWLnLuzDxVu6ipRHEp84Y721M67ioR+OPv03d8zZkr3IKkKQlWu0CbC
X-Google-Smtp-Source: AGHT+IGjmBeAjdwx2tp3eAgzg+py4jpXCajYBW5VvNA+Im6O4qLvCU4jXf2cauGiOVa4K90PiUoPVg==
X-Received: by 2002:a17:907:1c25:b0:b73:594e:1c47 with SMTP id a640c23a62f3a-b76715b03c8mr660770466b.26.1763845250879;
        Sat, 22 Nov 2025 13:00:50 -0800 (PST)
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com. [209.85.128.46])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b7654ff3bbesm809655766b.51.2025.11.22.13.00.50
        for <linux-mm@kvack.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 22 Nov 2025 13:00:50 -0800 (PST)
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-477bf34f5f5so14850545e9.0
        for <linux-mm@kvack.org>; Sat, 22 Nov 2025 13:00:50 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCViGRBgiHXrW8SgnnTmeTrYcqpHaXxWj//exoffnQ+VsT5jVK2qFp04iRUoHwzYK4LDRmAV2X+ALA==@kvack.org
X-Received: by 2002:a17:907:6e8d:b0:b70:7cd8:9098 with SMTP id
 a640c23a62f3a-b76719d4d02mr618930666b.61.1763844895821; Sat, 22 Nov 2025
 12:54:55 -0800 (PST)
MIME-Version: 1.0
References: <20251122014258.do.018-kees@kernel.org> <20251122014304.3417954-2-kees@kernel.org>
 <CAHk-=wiNnECns4B3qxRsCykkHwzovT+3wG738fUhq5E+3Lxxbg@mail.gmail.com>
In-Reply-To: <CAHk-=wiNnECns4B3qxRsCykkHwzovT+3wG738fUhq5E+3Lxxbg@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 22 Nov 2025 12:54:39 -0800
X-Gmail-Original-Message-ID: <CAHk-=wjxj---dy5haOvNXjg_Xz-mDQciGL7OnJnpJpjYD9Moog@mail.gmail.com>
X-Gm-Features: AWmQ_bnv84PkVSmG-NV-hwB1C2eg-gsEJfo3JVaH66sxShWKO-Vcyq708ZlrB18
Message-ID: <CAHk-=wjxj---dy5haOvNXjg_Xz-mDQciGL7OnJnpJpjYD9Moog@mail.gmail.com>
Subject: Re: [PATCH v5 2/4] slab: Introduce kmalloc_obj() and family
To: Kees Cook <kees@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>, Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>, 
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
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: CB4FEC000B
X-Stat-Signature: 4hy7ktibjy9rpupzb88r67p3kmmd6p6k
X-HE-Tag: 1763845252-238536
X-HE-Meta: U2FsdGVkX1/L4yuX3H+JhWABFz/e8jGQIr//LMZaw+mXqXBdUBeCFKPJDOgkB7bhf63A+qIBkPj/DeFW8lVWvlJ2k0LermXISIk/zvBH6Y8owFRa5KrbphjpIjjGq6dzK1vkRSDFNameW88y0c+Kvh1xBpx39D8aJ2TwAihJ55ELFkQgF2+Os0K7ITBkm8Lm34wYGIh0IAG3zCXvpWZ4TaUrE3gGuITiVMotyDv8uAnpnOrTavoCu4a4Pbmfh1NA6j+oBp3QJj0pc99QbJBYTJImuDyJbtigQ/tmnYvb9h3H4M3BM7ldNcaHLv+gIRbwn43595ZhCPUyZtCgzTutM11IRrfZSc4khyvE5janZjS6RPvZ2PrUlfvkUay98vZZ4FJD6t6zwT5wfb7NGbEDewsnx4M5UMkVxIegrYIAZQKo+uFfuZou+t7taP2N/sEaStgKi+wXgOT9Bkfk/+LkLzv99hT+fCVqQgI3Tf8w7OdPS/xVBdTX8tL/Ifc5ZGbERNgV5p8kOSVB782mcgBGFtP2OrIpYHRb+xrHgExNjJm1fe2mSfl1XUXwOokf10uZBQRJUGdSbBtxxjrsi8lSWUDlmH2vsYusxvxeQZU24FbMaahypzpPqiB7d8yZZcr4rWFZphNFjAP/nfn7EC2aGTlWJ53qXoisGIG8qc2BEagU10nM7kqb1jQbeun5KIPgJD4yu8h0wwWfv9K51mkN8FYVnyreVNxap4UsC5VOrGZ1BIaSL33eERMCV3H0FXMMBPd/aCZrXGEmNsiM7TSDzwb3qYijNd0tVXGlCBYusEbGoQPqtzblizk6Kjdh/rA0Jg+p9wxOieKbb5rMr48uFQ/30amTiV/49vr6Igag84iskl/2b1JL3SNOHb/30Biw+ZFl8u8ABQDbJEdn/AdmTJ/ybWofUVi8UE6/m70RhH0mLicukbwFbDU0BRJEtPeR6Y52m8+869ryVNNNcKp
 bkqXElnz
 Ad18cGtAoexsZv2VqkSg6S7ZuugKFw+B+OsfKWBdUu9eW8950thbIzE5C9Js5zHyR9KRzWOnNbdUwOV1KEThY7C96gX8ekDNPBeZbCVhmSvjqDoLninimmiczOAIT8hRQne2i7oEEA9bFK7nP6QNtXuQjQRCeZ09e/Itg0RT8gaqDsL+9pNvUudKz4I/BiBpgN/1o6HntHRmbn8chNnATfp5FPujgu7kalvXXj0iek2WGkL0sty/E0YHA3u0GnjMFJa+xjPU19vpL17Qp5pWNWI/eExF8lKkVvy9gcQX7PmHmSXWwFBnPTIyfvIYS95PYhDXpIDJhIVEFf1ZzmQalKQOOkV7PV60N3H+3GHTT8v6VTJZZ44/4wh+NT6tRuneOSVDh2T7Ux53fantQBN/Sn1VrInYXZ+oizO1JcCl+s+o1X5Fn6AJlbfc9Dr/ymq7RieNvm6jHr7IZisjMiAn++MKX9mLYvudNyy7mLKnHMq55eBrZ1Amgxhl2MpbcfA/Y3GMRn8NnIlVnfxckmzpAvhqn+6WM1bauCfrz2NdM1R+BHEiNCY+hL9Mha9WyKbodH0GU9l2gfJX1k8qP/SIyic1J6A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Btw, I realize that we don't have a good way to do the alignment with
the current kmalloc() interface (we do for some of the vmalloc
interfaces).

So for now, it should just have some static build-time warning if the
type of the object we allocate has a bigger alignment than the
guaranteed slab allocation alignment (ARCH_KMALLOC_MINALIGN or
whatever).

And I really think the first version should do the minimal thing that
actually matters, and strive to deal with the simple cases. The main
things that matter are

 - the return type should be a proper pointer type (so that you get
warnings for mis-uses, but also so that you can use automatic typing)

 - making the 'sizeof()' match the type

so honestly, I think 99% of the gain would come from something fairly
simple like

    #define kmalloc_verify(type) \
        BUILD_BUG_ON_ZERO(__alignof__(type) > ARCH_KMALLOC_MINALIGN)

    #define kmalloc_size(type) \
        (sizeof(type) + kmalloc_verify(type))

    #define allocator(name, type, size, ...) \
        (typeof(type) *)name(size, __VA_ARGS__)

    #define kmalloc_obj(type, gfp) \
        allocator(kmalloc, type, kmalloc_size(type), gfp)
    #define kzalloc_obj(type, gfp) \
        allocator(kzalloc, type, kmalloc_size(type), gfp)
    #define kzalloc_struct(type, member, count, gfp) \
        allocator(kzalloc, type, struct_size_t(typeof(type), member,
count), gfp)

The above macros are entirely untested. But they are simple enough
that even if they are buggy and I miscounted the parentheses or used
the wrong name somewhere, I think the idea is clear. No?

(And I made that "allocator()" macro use __VA_ARGS__ because
kzalloc_node() and friends would want that, but I think it's starting
to hit diminishing returns at that point)

Hmm?

               Linus

