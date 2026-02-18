Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 75F3DE9A03E
	for <linux-mm@archiver.kernel.org>; Wed, 18 Feb 2026 09:31:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CB1CB6B0088; Wed, 18 Feb 2026 04:31:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C5F7C6B0089; Wed, 18 Feb 2026 04:31:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B6B6E6B008A; Wed, 18 Feb 2026 04:31:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9F8366B0088
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 04:31:18 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 490AFC1C44
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 09:31:18 +0000 (UTC)
X-FDA: 84457059036.15.3938FDD
Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	by imf16.hostedemail.com (Postfix) with ESMTP id 7E086180009
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 09:31:16 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=vhHcnEeV;
	spf=pass (imf16.hostedemail.com: domain of 34oaVaQkKCJk3EB57KRAE9HH9E7.5HFEBGNQ-FFDO35D.HK9@flex--aliceryhl.bounces.google.com designates 209.85.221.74 as permitted sender) smtp.mailfrom=34oaVaQkKCJk3EB57KRAE9HH9E7.5HFEBGNQ-FFDO35D.HK9@flex--aliceryhl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771407076;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rFgVqtfti6/svD+1ZiUO3++RgsvWnRMRX+ORPut57vY=;
	b=bGtCf7Wxk0zXs+JTTi+TgYOVADEDySNmHLSdHyC3YRwV43l3FCWz13di5aueFcSHRSVDX2
	pr12fgrftsVfjUbkph+dH17Yn+TQNMwMEKx453nhgxgFWLNacqmn4PKFPReM739NTEa7pC
	zXZI7U1slMQdeg9MsdXy4wUbDblMu+M=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=vhHcnEeV;
	spf=pass (imf16.hostedemail.com: domain of 34oaVaQkKCJk3EB57KRAE9HH9E7.5HFEBGNQ-FFDO35D.HK9@flex--aliceryhl.bounces.google.com designates 209.85.221.74 as permitted sender) smtp.mailfrom=34oaVaQkKCJk3EB57KRAE9HH9E7.5HFEBGNQ-FFDO35D.HK9@flex--aliceryhl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771407076; a=rsa-sha256;
	cv=none;
	b=OizXjVcm9BfuOjEPV01SeMituuOSt0Kya78ktcW4LUnud7GhrFbKMZfPvCRpAmBYpmnLdi
	+Ov0udnc1sGpPbAyjJoQkAtK1ebOiwsqxgnXtIfXUwovuQtKwOT+uuSE0UtyGb6xnk0XUN
	9umvM9TE0xWnVknn69xkEGtvFmdSDWs=
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-43623192c6aso5882068f8f.3
        for <linux-mm@kvack.org>; Wed, 18 Feb 2026 01:31:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771407075; x=1772011875; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=rFgVqtfti6/svD+1ZiUO3++RgsvWnRMRX+ORPut57vY=;
        b=vhHcnEeVhSjzosKxHUY5ZF3YJY+hPeHm3uonXk/LtYWMPIwIAKFU++n+5t0cMqotjY
         gqWE/2+oIKDOkZzqG6ndjjlj1U3UhfzRt7c4KF9tCOPCpZy2qY6I8ICqUp2TFxB3eZM7
         kaOBh8sb3vQmeX2jeMc7KtSVnrjXduvCIdNRxk+3A+UGT7Jz1J6e79uAlimukCn0KBZX
         bQ7ehUWZEXrfnL4LvznTtnGPdkhe/93kx6eUeAwuAd4REoIRwD+QWcxp25JrN7F0llL0
         LwW/0GXbASgTMv7sSTvPSUS/dmfMSs/90bJN24k5tU57hK9ZT63bxIiHgr7MGGa8T051
         uM/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771407075; x=1772011875;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rFgVqtfti6/svD+1ZiUO3++RgsvWnRMRX+ORPut57vY=;
        b=hBy8/s2NDaLridyXfszd6L0oBWYKv/Zv1kjO+WtaOGWthkb7bOsxnm2Prw4C309rMK
         MgE+SnZKlyOw4wzlqzOgLvddBDBh5Ul7L2m/PN3mJM04gN4Mt6hR4fTXJhrp23uzXKTN
         scU0FGBx+HjtjZ1wNTz/LVUeGCZqSYxe54a2g8eofd7leMM+H4Y1ZWmKz6tjyhyRH8yJ
         SdiBz1nSP76FskYdKOBggoMHvg9VpV8lXcYaAvY0dGPt4v6kSuEYM/+MC8waJPBTdYWn
         kTgmD5V5QdqXlq1vXk7eIIx5RbmhNLgVi8o5X+YY+kjLmM32m+l7cVXlEYA5r1iIrkj5
         1Ekg==
X-Forwarded-Encrypted: i=1; AJvYcCWlPHj16+BmWPrjxNLJtmjZikSOVOJW0Cw5h0HSQVGFzWY7HtTEJktyU1Z7hK9JmgHqzCQ4XKSvOA==@kvack.org
X-Gm-Message-State: AOJu0YyEXryI5JaWtS7atAtKGW5fnzTSbM3CmePnftrF7yrtJGmwgdep
	rhbbUTlUfRLBDDwH+Vx8D3DoCZUUsRSomuZvFv10Ac7FxYh4xWgAi+lbPpZEvMOnVyWzmWfBCgg
	gHy6Oq6XJU3DyYr4Ycg==
X-Received: from wrs2.prod.google.com ([2002:a05:6000:642:b0:437:6bbf:a150])
 (user=aliceryhl job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6000:26c2:b0:435:e57a:9082 with SMTP id ffacd0b85a97d-43958e504afmr2125915f8f.46.1771407074382;
 Wed, 18 Feb 2026 01:31:14 -0800 (PST)
Date: Wed, 18 Feb 2026 09:31:13 +0000
In-Reply-To: <20260218083754.GB2995752@noisy.programming.kicks-ass.net>
Mime-Version: 1.0
References: <aZQ8lJJ-U_8j03Z4@google.com> <20260217102557.GX1395266@noisy.programming.kicks-ass.net>
 <aZRHJ7pSzOHruPA2@google.com> <20260217110911.GY1395266@noisy.programming.kicks-ass.net>
 <aZRWOIPThLfIZ1Ph@google.com> <20260217120920.GZ1395266@noisy.programming.kicks-ass.net>
 <aZRokyTqsd_RwdkK@google.com> <20260217154800.GY2995752@noisy.programming.kicks-ass.net>
 <cbbea9ecb994df975109d97a7756d73e@garyguo.net> <20260218083754.GB2995752@noisy.programming.kicks-ass.net>
Message-ID: <aZWGq8EMxz4omw4L@google.com>
Subject: Re: [PATCH v2] rust: page: add byte-wise atomic memory copy methods
From: Alice Ryhl <aliceryhl@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Gary Guo <gary@garyguo.net>, Boqun Feng <boqun@kernel.org>, 
	Greg KH <gregkh@linuxfoundation.org>, Andreas Hindborg <a.hindborg@kernel.org>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Miguel Ojeda <ojeda@kernel.org>, Boqun Feng <boqun.feng@gmail.com>, 
	"=?utf-8?B?QmrDtnJu?= Roy Baron" <bjorn3_gh@protonmail.com>, Benno Lossin <lossin@kernel.org>, 
	Trevor Gross <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>, Will Deacon <will@kernel.org>, 
	Mark Rutland <mark.rutland@arm.com>, linux-mm@kvack.org, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
X-Rspamd-Server: rspam05
X-Rspam-User: 
X-Rspamd-Queue-Id: 7E086180009
X-Stat-Signature: x8hegpcd44s4ho5j3amaqi1oi7nzbbbu
X-HE-Tag: 1771407076-516816
X-HE-Meta: U2FsdGVkX18monr8JQJs1lyEDiXXxYcukaOdWDzcj1/Kc/HcQcIUT+sZFVER4J0ctCOQy5npSkAAmm98Cco1bRnLuyxtAlBp5r3wdKcZ3SSFY5kWCRSA8KYvTCVx/o4r16Qyru0i/GOOg+I3GXMm+VixWXUHpGqrMFk5b/ezoTpk19ej79TLehabKENdCxbZmg6mLfhqt+uu5fFmrmn6ddmGsUkyTvaB0WQxp/ID7tqMDnz5JklPk8dBet83B1cjMwuDos972faCEZOQ0SOWLiR92NYHLe/ZLDFI3toEckGkrXiQ2x10kgk1Bh0YD5HYldkKpThAEQkG39R9Vz2DsG0TPsp2rSwns/RhmRYwVQmllxmteZKmLAEoItuTNis78Rz1vpvgJE/Hsa0R5yXYrLCczj5xbmyC95JAGTVZKopqX1MdPV2AKG0PT2oiv1oiFAJr11NC3pc327Ya3AUSr2669ZDA+1XSjKXblTOxt0b4s1eZ+D3XEGTecOdLoMO9EDj//5EeYVC7PVJ/0rWlk/bPa3VJPEB6pM9BPxxXShcvMFyQXkP53icvAbesY/FjwSV4ix40NJlO0g7KvRXixWg9ztlKAiUhtRDDCOsqvXdkXodGvmINR7q99natWM7lORMi61gAHgAygwtikGh6n1d5S2GC2DIseb5uqdtH2s7BKHPn7z7KslUi4G4WuqTCxFmPpg658Bgl/p2jEKhUNtpRIDjrrJQrE79nAnTVp7YlnUxqDKGdiEsbwiIpBR2XMvYzI5RNzvtpOafydSgHvCjyoglPKH+31OdXjeZtPxEBwbvqk8RG7RoF3hishejmQNcHSaeo0r6G5z/I2tz1vJfyfDAE+CxEptc4G3DjmcqdSvaeyQ8uwCwD/Ndde0A5XhT21vXh2VS4O/TZKr9BSCg1OeKIh1zlMyxpxGIk/GgDErGFmfGt2o14SVlzc5RAFZAwYRHB+v+bxHvx+uL
 PzERG5Eg
 rUulgCJjBRkeLyL2LuAFzVtFx4l9aXf3xLUofWUWFqCGKzb5bLclOWi+cDIWaj26n8ud+tr+mYEqOBxtqQKh0E8uz97OuifbB6AnhKg+HHfGntW1soNkhw2PaRS2wWuLagdHYQJ+GtuPe7Z4UOxMo+Dtq7CwEXhW+xuJIw5erNe1ifP3sj1tPhTVFj65gPe/UJq+QEbpG2lclylPixQXUdK2sGgJpRpNhqeclFfdLPXAN5Mg9poIjl0LSx1Te9IQdCYe/2nCXx4n3o/is84nsbthRzg+9LWPW24sCHVX0atOLl9TTsnerSYzkRU1q4wPzZwRo8SrGKyNEcsZCCfAijhnMsQOcPkiAPGE684yq/dg35C8BJJ+JN3FohhTEfGF6x9gme493lGs9NwAMsqbVk+OxhB1lmtyVG5rRQ9619fSihcDNl//i6ASKif7jFpbwxCIvEUHfrKMN8xiaOZFqsZgZ9PZj0ABKmdGC0vHAm7kfE542yXVOFQpWeSFaPb12OHV7GNe9IC0GWW3Fn8zLnMzxsZeo4/il3gayQc9E0Chp9b598kezbXHo/uQpWc2scn8Q6ZvIOdooGVDDnXDVXm54GfN+d8sZDVqdQoVkeL8+Au955y0nBCPgGjQgL7D3i/6jKxmWlEI1RJ7fWHYuWursngqEPINdcGB+hTam6tTRH2Vcub4m441Rgw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Feb 18, 2026 at 09:37:54AM +0100, Peter Zijlstra wrote:
> On Tue, Feb 17, 2026 at 11:39:18PM +0000, Gary Guo wrote:
> 
> > >> Are we really good? Consider this code:
> > >> 
> > >> 	bool is_valid(struct foo *val)
> > >> 	{
> > >> 		// for the sake of example
> > >> 		return val->my_field != 0;
> > >> 	}
> > >> 
> > >> 	struct foo val;
> > >> 
> > >> 	void *ptr = kmap_local_page(p1);
> > >> 	memcpy(ptr, val, sizeof(struct foo));
> > >> 	kunmap_local(p);
> > >> 	barrier();
> > >> 	if (is_valid(&val)) {
> > >> 	    // use val
> > >> 	}
> > >> 
> > >> optimize it into this first:
> > >> 
> > >> 	struct foo val;
> > >> 	int my_field_copy;
> > >> 
> > >> 	void *ptr = kmap_local_page(p1);
> > >> 	memcpy(ptr, val, sizeof(struct foo));
> > >> 	my_field_copy = val->my_field;
> > >> 	kunmap_local(p);
> > >> 	barrier();
> > >> 	if (my_field_copy != 0) {
> > >> 	    // use val
> > >> 	}
> > >> 
> > >> then optimize it into:
> > >> 
> > >> 	struct foo val;
> > >> 	int my_field_copy;
> > >> 
> > >> 	void *ptr = kmap_local_page(p1);
> > >> 	memcpy(ptr, val, sizeof(struct foo));
> > >> 	my_field_copy = ((struct foo *) ptr)->my_field;
> > >> 	kunmap_local(p);
> > >> 	barrier();
> > >> 	if (my_field_copy != 0) {
> > >> 	    // use val
> > >> 	}
> > > 
> > > I don;t think this is allowed. You're lifting the load over the
> > > barrier(), that is invalid.
> > 
> > This is allowed. Compilers perform escape analysis and find out that
> > "val" does not escape the function and therefore nothing can change "val".
> > 
> > A simple example to demonstrate this effect is that
> > 
> >     int x = 0;
> >     x = 1;
> >     barrier();
> >     do_something(x);
> > 
> > is happily optimized into
> > 
> >     barrier();
> >     do_something(1);
> > 
> > by both GCC and Clang. The fact that the local variable here is a struct and
> > memcpy is used to assign the value here does not make a fundamental difference.
> > 
> > barrier() does nothing to local variables if pointers to them do not escape the
> > local function.
> 
> So how do we stop the compiler from doing this? Because I'm thinking
> there's quite a bit of code that would be broken if this were done.
> 
> Must we really go write things like:
> 
> 	struct foo val, *ptr;
> 
> 	ptr = kmap_local_page(page);
> 	memcpy(ptr, val, sizeof(val));
> 	kunmap_local(ptr);
> 
> 	ptr = RELOC_HIDE(&val, 0);
> 
> 	if (ptr->field) {
> 		...
> 	}
> 
> That seems 'unfortunate'. It basically means we must never use local
> stack for copies or somesuch.

No I don't think RELOC_HIDE is what you want to be using here.

The way to stop the compiler from doing this is to ensure that, in
LLVM's eyes, the memcpy is either a volatile memcpy, an atomic memcpy,
or an opaque function call. According to Gary's reply to my email on V3,
it sounds like an explicit call to memcpy like this apparently falls into
opaque function call, so it should be okay.

Anyway, that's why using Rust's copy_nonoverlapping() isn't okay here.
It emits a non-volatile non-atomic LLVM memcpy intrinsic, which permits
these optimizations that we don't want in this case. By calling
bindings::memcpy(), it falls into the opaque function call category
instead, which fixes the problem.

Alice

