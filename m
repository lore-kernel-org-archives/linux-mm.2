Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3A0B1CCD184
	for <linux-mm@archiver.kernel.org>; Tue, 14 Oct 2025 16:41:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 65E838E00D5; Tue, 14 Oct 2025 12:41:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5E7C58E0090; Tue, 14 Oct 2025 12:41:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 489B18E00D5; Tue, 14 Oct 2025 12:41:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 30EFE8E0090
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 12:41:41 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D83E2C09F4
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 16:41:40 +0000 (UTC)
X-FDA: 83997285960.05.976D4C8
Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	by imf04.hostedemail.com (Postfix) with ESMTP id AC89E40010
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 16:41:38 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=google header.b=ERmWatgk;
	dmarc=none;
	spf=pass (imf04.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.208.45 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760460098;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TfIjTfdF2e53St+2VVBPM1O6zAI6tUF3QFF7DgeTNmM=;
	b=tm31H/jlHk27aEv3AudYuaV0y+X0JhDOA+rNAlvUIC+ZPwYsOM2HgBlZQx9dGkTS6hj2N9
	KnLXSkGlvQSj0nmMgPlTPckEZeP7JLXrPWsYxCI+KkaswvU16oe1QrXH9zqlBSqTXLQCBz
	zDDJ5dQRMzXrHTeRDgQ+qaA8YZM9muw=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=google header.b=ERmWatgk;
	dmarc=none;
	spf=pass (imf04.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.208.45 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760460098; a=rsa-sha256;
	cv=none;
	b=E5OfAUa917LzHeLl7UmZB1+3MfuexpmjxbXtp+ng8gaWIZGds4ULgwGOnFqiYKGi3d6QHP
	SMuyGVJvTjjupmJth+ep6xdYZLj1J0BDGgv8QQOet85SanyzJwzP4Wq6G5vau13xPj9M4Z
	EiStD7Z8oJg6CwvaKSnKoOJFKxN7OaA=
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-63bd822b007so1607736a12.2
        for <linux-mm@kvack.org>; Tue, 14 Oct 2025 09:41:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1760460097; x=1761064897; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=TfIjTfdF2e53St+2VVBPM1O6zAI6tUF3QFF7DgeTNmM=;
        b=ERmWatgk+x1QjBdhn1rUwI0iZo2W3lWMM6U2vSqj+CKKhaW3KK/meWwMPTclHZakuL
         IjjR/BnSBpdlkepr4TUTAUnbT9cjKSibyTlVHtJKcrrwNYNygiTnAZVZ4jQULfsiEEgQ
         fxokKDIVdAARYA5AovXU0xMT5iDdjseBD4t5s=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760460097; x=1761064897;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=TfIjTfdF2e53St+2VVBPM1O6zAI6tUF3QFF7DgeTNmM=;
        b=QGKGL4y3Kj4Dk9gxic3ylsZ9qgJyKRk3qR+Zlswjoye8miVMcSpK+2f018mLqj8Rzv
         iKBk+B8f/wd67M5sqskWSWe11hUyzNbbDcOPoBXgylLC7TjiVOB8qEGzZctVBvGT+aqC
         cLt5E1eh6eiOiK+TZwxKUCdHNcKnXL5SLEVvuAV41SeQrfqZhucbLEn19aqep6eDg+f4
         JFOGfZm+LNczZw+Z+NoERlFVxq/TOcf6M++XlKJhibJkrcLK5MGCQg37To78T272w6NI
         rXZfa7SZgFR3bejZFW8AwFJs1pCpQAzlxIsu0aqZ4ENa9fOZD7h3TEFtMS59cEWTTfPM
         fsfA==
X-Forwarded-Encrypted: i=1; AJvYcCWft4GSwfbecBTMuQSL5QaV4/LrhAEDybCmfPoNakXe+NnhFHqXXfSE8Z55kQI1WEefc8iflgkvyg==@kvack.org
X-Gm-Message-State: AOJu0Yy8AOrviAr5/l0o6Ucshw+Npx8V+jCeS0SnN7ZR87+OgefA+2Lc
	g6mKJ1mAJ/uxjCoBY6B26sceOKMqp6kX9Qw2RDevkgCNLt/e3jSOQr5CavDpRZ6gbzQL2zHcP05
	Ahjt3uD0=
X-Gm-Gg: ASbGncuNa6eMm8syJJnmO6RWdhrBLCHilulHyCs8jqn1in5yMr2pAlacrBYqSeI4xpj
	fE7twr2nFDTLQt9VJa0YOpMzo2hXhVktcI39imP9AgbVgnQaiR/nSrRUuagHevsV4aOw+bGkkEV
	bl5hByObCqjoPlegDNBfbx+VRW0FPfR2SAfZhZlM+QHSFZEmfERD/1f8As4mrtMg6byolX0QOiu
	iMgaXW4bzbUC0Gpr21jXVu2+07YJ0Z0lHZzUknQ/2nU/5MQtuy65nH5DZhNNL4pzLdsG8p8bZh4
	Q59/7IrN/h0ocGGjqYf3lhxIJpUY+0rQkdZXBlLQlbOWYJF1lEH+5VJhDdZ82NNcIltHLq/D/hz
	K4AMQ9o6qsCU+Wz2p0Yhz1AkhvR0u/ylxJMYTb0LdzWQRyzl2QyNNtcx+5jZ0JxUK16SpJyQ4dV
	gs7p8QsysyPuXhUNDq7uP3g7JqBw==
X-Google-Smtp-Source: AGHT+IFhHlq3eYd3s7xcKFhBc3OJDX/LoGhkLe6laa+sqw7hzHOVbTWt+BJ9ReEBBlZFP6MRo+uzgw==
X-Received: by 2002:a17:906:ee85:b0:b4e:f7cc:6346 with SMTP id a640c23a62f3a-b50aa08f852mr2514118266b.15.1760460096828;
        Tue, 14 Oct 2025 09:41:36 -0700 (PDT)
Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com. [209.85.218.48])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b5ccccb511csm17001966b.53.2025.10.14.09.41.35
        for <linux-mm@kvack.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Oct 2025 09:41:36 -0700 (PDT)
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-b3ee18913c0so903414066b.3
        for <linux-mm@kvack.org>; Tue, 14 Oct 2025 09:41:35 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCUWzu/5OXDfWCjop9YIsFWw8fGrCc0ICrs6bGMkgpGnEpxjma9Yari0f/mVnS+sKrB5ILJH+vxsfA==@kvack.org
X-Received: by 2002:a17:907:3daa:b0:b45:60ad:daf9 with SMTP id
 a640c23a62f3a-b50a9a6cb4fmr2924764166b.3.1760460095576; Tue, 14 Oct 2025
 09:41:35 -0700 (PDT)
MIME-Version: 1.0
References: <ik7rut5k6vqpaxatj5q2kowmwd6gchl3iik6xjdokkj5ppy2em@ymsji226hrwp>
 <CAHk-=wghPWAJkt+4ZfDzGB03hT1DNz5_oHnGL3K1D-KaAC3gpw@mail.gmail.com>
 <CAHk-=wi42ad9s1fUg7cC3XkVwjWFakPp53z9P0_xj87pr+AbqA@mail.gmail.com>
 <nhrb37zzltn5hi3h5phwprtmkj2z2wb4gchvp725bwcnsgvjyf@eohezc2gouwr>
 <CAHk-=wi1rrcijcD0i7V7JD6bLL-yKHUX-hcxtLx=BUd34phdug@mail.gmail.com>
 <qasdw5uxymstppbxvqrfs5nquf2rqczmzu5yhbvn6brqm5w6sw@ax6o4q2xkh3t>
 <CAHk-=wg0r_xsB0RQ+35WPHwPb9b9drJEfGL-hByBZRmPbSy0rQ@mail.gmail.com>
 <jzpbwmoygmjsltnqfdgnq4p75tg74bdamq3hne7t32mof4m5xo@lcw3afbr4daf>
 <dz7pcqi5ytmb35r6kojuetdipjp7xdjlnyzcu5qb6d4cdo6vq5@3b62gfzcxszo>
 <CAHk-=wgrZL7pLPW9GjUagoGOoOeDAVnyGJCn+6J5x-9+Dtbx-A@mail.gmail.com> <wfneq47jscotsqb2hhwpjfp2hqz4d7yyw643yagqnqvh74opvx@5fnmgowterq5>
In-Reply-To: <wfneq47jscotsqb2hhwpjfp2hqz4d7yyw643yagqnqvh74opvx@5fnmgowterq5>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 14 Oct 2025 09:41:17 -0700
X-Gmail-Original-Message-ID: <CAHk-=wj8KLDrL7ApM76cJTSXbZ0uxktexBaN9pMYO+hsiW-KxA@mail.gmail.com>
X-Gm-Features: AS18NWDqj066zW2Fdpipv6VXjg2cDmYzFXBwfjyGrNNP2eC0z2mKKWvE1qATHFI
Message-ID: <CAHk-=wj8KLDrL7ApM76cJTSXbZ0uxktexBaN9pMYO+hsiW-KxA@mail.gmail.com>
Subject: Re: Optimizing small reads
To: Kiryl Shutsemau <kirill@shutemov.name>
Cc: Matthew Wilcox <willy@infradead.org>, Luis Chamberlain <mcgrof@kernel.org>, 
	Linux-MM <linux-mm@kvack.org>, linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Queue-Id: AC89E40010
X-Rspamd-Server: rspam03
X-Stat-Signature: zgyx5iyc31unxyhxxo8k7e5wun6iauy4
X-HE-Tag: 1760460098-849221
X-HE-Meta: U2FsdGVkX1+gj014OMisCsCiBNlfQJD1B5n1vMgBi6P01xx93TGiNyInxGOjPIfaWqyAb0JapFYFTn+nx9q0yDnk0gvOCIEpI+w5CXbh0R3S/i0vc+Eaki7sg9sEZvgcQQ9vp0jCDSgLIpQEFW4daWR5HqC6s9OGJs4cm6DIutYDAqCJHHn3IZyxFijZR3HMs/RSjyVPxixwFELgtYEsJeDn9nkn4ZFheqgLFJV2TWg0ip7so87m5FYHTd4nrc6RxqZfzsJ8kwTTpg5gW+yI8ZXTKYGIvbj4KdV2tepe2B0ZnnKItI26ewSolQorHFGuq0Z0Ykl/iKw0vEwbsKXp8D2BhWLD2E5L/j9H9MFu+qDRD8GjD5H4mlHWsQi6T97A/fmg3LRaAEd+hBeonoHZW6hOhBKKb22xlGZlVM8IcsLm+oVyESbucHERiKhY8mwW3nxxZKGUtQ7+JsKWYfbZ08tvcYZsKF6UvpGdk7FrQxtE5/2of3mCZn4AnCDMC1azjybWtTGC9XHuYqBd0uijS0uDTTbFPgFGpppwCxXqAPlaEPK1y/K/bkKMuVfVBBe6qcz8Z+Ochy8yaok3QvCdYRzG8GVkDAA1Iy0AedjQyWWcER2xtbfTVcxDiQIHVO6szQ2JRBRUMwcAjrlUVRp97SSnRg2T0eSVD3+PFzwhKE9B5ee2ynDp+SdAAJpD7UhaN3pHkl8kglZCJX/0vKksrG7VuXQc9Qi5Oiwf+fv/NVFfP/03Ien37gxdch55DsStdTOkwAEDHYEH91kC1sGBTFEWSpD6Ycq9LUMdphN4Ofp47pvGPf8Fhg3Oh+2csW+unTa7ZkzJaCgvkFUDFT+e/dAlvAC0o8PzJrz7phq4L56r3C4Ikx+7+q0zzggj9FGnFHF/dgbSpAtm4GVz9s8URXkBMbu3dKn3GjdwU21J04TNQzvec+dj0xB1HCGDVDP+uV41sZMyQNJM6FSfA+2
 RSYCRqbS
 TP2rH87EAUHNa01xC4SGB4X2EJXdz4UgtAtSK++Tp8KD4aAhL3DJkZkJt5LVKPv3Y0OFUSDQlFFFqiBxdSuQBq3E0mGFQUk4whrXtxvRGBQwKR5MqRkJ1Tp6BvYNZUgznDDfM2IM3JUGJkS1C9MV1Q+P/AF5k5eMrm/LOnKA2nGBXU4DNRmO5i1X5oapiiqZzKbepSSTYOwHSaXepxY3Itx2VlhPKFHjHjCOTKv4xDjprEiE6vTbU1wEwc0R5g4cAp+ZcKemKEKAkujRW56dq8ipNsg0xGpcXv6C4MqAe14XxODQ2i3css3wK/cc3ag5sIK0gbLWoqu2yyCneM9i5HeZDsn7p+G6uOqdJ1sgFKb8zqIijnYl4LczUmLcVxcCm4TLtxPw1GY0fQz4Bac3DrJFrcDD2eoTrm17ZZv4HMFCVJpzZLcR/loZAMy7YDoaddXSUavkNa7JEDRsVcKEFZ1l+PJ0TzJcgAl2PSYUxaIb2vJazgAxW6s3Fv61mLDfr5j1r
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 14 Oct 2025 at 05:58, Kiryl Shutsemau <kirill@shutemov.name> wrote:
>
> clang-19 actually does pretty good job re-using stack space without
> additional function call.

Hmm. That certainly didn't always use to be the case. We've had lots
of issues with things like ioctl's that have multiple entirely
independent structures for different cases - so obviously no lifetime
overlap - and it has caused lots of extra stack use.

We do use -fconserve-stack these days and maybe that fixed the
problems we used to have with duplicate stack slots.

Or maybe it's just "different compiler versions".

But the case I was worried about wasn't so much the "re-use stack
space" as simply "lots of stack space for one case that wants it, deep
call chain for the other case".

But it appears we're ok:

> And if we increase buffer size to 1k Clang uninlines it:
>
> ../mm/filemap.c:2870:9:filemap_read     32      static
> ../mm/filemap.c:2714:13:filemap_read_fast       1168    static
> ../mm/filemap.c:2750:16:filemap_read_slow       384     static
>
> gcc-14, on other hand, doesn't want to inline these functions, even with
> 'inline' specified. And '__always_inline' doesn't look good.

That looks good. I'm still 100% sure we absolutely have had issues in
this area, but again, it might be -fconserve-stack that ends up making
the compilers do the right thing. Because that sets some stack frame
growth boundaries.

           Linus

