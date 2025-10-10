Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E19B0CCD185
	for <linux-mm@archiver.kernel.org>; Fri, 10 Oct 2025 17:52:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3384C8E0039; Fri, 10 Oct 2025 13:52:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 30FAD8E000C; Fri, 10 Oct 2025 13:52:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 24CA88E0039; Fri, 10 Oct 2025 13:52:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 15AA98E000C
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 13:52:04 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id CBD671DFEFE
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 17:52:03 +0000 (UTC)
X-FDA: 83982948126.14.94A5DBD
Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
	by imf11.hostedemail.com (Postfix) with ESMTP id 945F040016
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 17:52:01 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=google header.b=GKL2uFU3;
	spf=pass (imf11.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.208.48 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760118721;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QvQdAr9DjpPt7bc+ApQ1ILGDgUPpqYxsi4QQUD3UZbU=;
	b=v6XUslN47fXbwCV/KD3RL+u/OHaJuTrzK4qdSdvdoUPjBC9Y9uGXU7eY6VKwO5SNq8kiHG
	yth+e/HKumXy/B39BS/s5YgODiLWl4OFXRIa9fOG6MW73/x5PtqqppE/kV47sj9tULsIQa
	Mjf6aXhcKEDglgryGbEs4f85WFJrjcM=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=google header.b=GKL2uFU3;
	spf=pass (imf11.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.208.48 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760118721; a=rsa-sha256;
	cv=none;
	b=1AbcwLe72vLXa51QXZlvB0bMgPnXE53xF9YTH6GbjoWilS3AzC74DcAR39+pSDvcSrUqJt
	+c1ZrUZ0UmpqgEBObVsa0/FNp+HKX/lB+NK+okIPzC7VWXAQLIpFQh1KGdW9/sCcQBQJ6B
	XgYjymQQYCmNj8vp4yIyQelqEs1L3KI=
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-637e74e9104so3097474a12.1
        for <linux-mm@kvack.org>; Fri, 10 Oct 2025 10:52:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1760118720; x=1760723520; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=QvQdAr9DjpPt7bc+ApQ1ILGDgUPpqYxsi4QQUD3UZbU=;
        b=GKL2uFU3zRqFGNl3Oag9qw/AI3sdAyTC2ODhx5qaW0wci0FRpxDvPhGuBmxKxmgLCV
         mlNF7a/f9wR87FE7NKmyW2LZYHppohKo9xQSMcXu6uCYNg33McfJkwLNWwWEscc4Nk7J
         dh+Tf8+GyGFNcztDXdk5rGe8rVrK1ytmKBL/c=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760118720; x=1760723520;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=QvQdAr9DjpPt7bc+ApQ1ILGDgUPpqYxsi4QQUD3UZbU=;
        b=g8S30ytbKZG0hZfeEHVBtHYvfQsAJclN+ImBHuAnrz6BA792daQkSBKwTMfupty1b7
         9HNO35XAc3s7lIyR1HsoIVL/WtmCMwtK7CGrbnDe2q2id6kdngETR9miaUrTIxvy9pcT
         WWOE4DyoIScGzb5YYY/Bg07Ou1xwkHPuGSkBLXlsywS9NRqwHGhEbY+6t3ylb95eVK4U
         xpVLuJJXT6UhJQxFP4CzoRn5VgRN9dVbl0E+JReb+q1ydocrJODIfKgsvtDfx7ERuIwj
         e5eY8gzYfIcQmRJ/CMNBsBGPbjmTKlTPqyLEd456gkpHdNByajh2ToNiozuc3VAyYBKd
         6TLQ==
X-Forwarded-Encrypted: i=1; AJvYcCVP6RvIJASyYb/0a45oIOLOwhXOGb65VxSBS8Yyd23cFY+KvlD7jdyj5SmesRau23M28WowBZXiYA==@kvack.org
X-Gm-Message-State: AOJu0Yx+u1tz9U4hXZaZMJPGCtDdzmFRsrcpv3ZqUew/RmYKnaUquvQk
	+RBvn9Nh+Oej1kUPONgoGxvTFdyD40qOTDH5MB3hlCVarsvyJatviWWE8/5TJq5ALWuEAelYb2z
	ydO80/B4=
X-Gm-Gg: ASbGncskPWoxvAT4jdUWx0RzBqT8o6ctew8XCkTt4uYnqXjKwnnto6JFFvGlLMshJOU
	D/YpHVPqRn04qzZhqW3C5GwZuXPQzNib9SCcYdO4Ew/AsHedsWOt7SOFb6iYMaKirIVdglTxAH9
	seps/Kg538DXmQ2OV0ghD1a65YO4DJHQ1832tTCnuGTpKMr5K9cAJwhLVgXTKv9w87+sKKSMB2K
	oQi7UZddUdpU5ZJuQMS+ZQh9pIoI6fYid6wmId2GhchLoM1mX97veVRhYCCv8wirFoFhP41qUMW
	kNZfiLNz5ovaooC50e02Hjd4GE6jFZlblnOouDhALRp4RzJBJhN4aZWuRD5Nxs5b3YnyIEEQOCx
	tKynfdvqkj3Txe5EiyZQIA7R4m5oboqbWR8hbjausODFY1Rvffx3EF/wnRK7IJpQfgHZ89qbVcl
	GENvhskW/IyE5Y1zDuSk6FOevb7g==
X-Google-Smtp-Source: AGHT+IHDlV5dQwzVgKt8spC2bH9eh75by7kIM4Q18pMump2ATNo0CBdM43XT+gmqHN1NB1MumEVmZA==
X-Received: by 2002:a17:907:3f1c:b0:b47:2be3:bc75 with SMTP id a640c23a62f3a-b50ac5d1dd9mr1350259066b.60.1760118719546;
        Fri, 10 Oct 2025 10:51:59 -0700 (PDT)
Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com. [209.85.208.42])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-63a5c132567sm2816474a12.33.2025.10.10.10.51.58
        for <linux-mm@kvack.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 10 Oct 2025 10:51:58 -0700 (PDT)
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-639102bba31so4653035a12.2
        for <linux-mm@kvack.org>; Fri, 10 Oct 2025 10:51:58 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCUpukZYf7lCO6fBn0f8UEWCUgfRFYaHfFRsx1poEJF/3+mEGY38mICD9w8eiQgEroVpXPRVNvkl6Q==@kvack.org
X-Received: by 2002:a05:6402:90c:b0:634:cb54:810e with SMTP id
 4fb4d7f45d1cf-639d5c57aa7mr10472315a12.31.1760118718242; Fri, 10 Oct 2025
 10:51:58 -0700 (PDT)
MIME-Version: 1.0
References: <5zq4qlllkr7zlif3dohwuraa7rukykkuu6khifumnwoltcijfc@po27djfyqbka>
 <CAHk-=wjDvkQ9H9kEv-wWKTzdBsnCWpwgnvkaknv4rjSdLErG0g@mail.gmail.com>
 <CAHk-=wiTqdaadro3ACg6vJWtazNn6sKyLuHHMn=1va2+DVPafw@mail.gmail.com>
 <CAHk-=wgzXWxG=PCmi_NQ6Z50_EXAL9vGHQSGMNAVkK4ooqOLiA@mail.gmail.com>
 <CAHk-=wgbQ-aS3U7gCg=qc9mzoZXaS_o+pKVOLs75_aEn9H_scw@mail.gmail.com>
 <ik7rut5k6vqpaxatj5q2kowmwd6gchl3iik6xjdokkj5ppy2em@ymsji226hrwp>
 <CAHk-=wghPWAJkt+4ZfDzGB03hT1DNz5_oHnGL3K1D-KaAC3gpw@mail.gmail.com>
 <CAHk-=wi42ad9s1fUg7cC3XkVwjWFakPp53z9P0_xj87pr+AbqA@mail.gmail.com>
 <nhrb37zzltn5hi3h5phwprtmkj2z2wb4gchvp725bwcnsgvjyf@eohezc2gouwr>
 <CAHk-=wi1rrcijcD0i7V7JD6bLL-yKHUX-hcxtLx=BUd34phdug@mail.gmail.com> <qasdw5uxymstppbxvqrfs5nquf2rqczmzu5yhbvn6brqm5w6sw@ax6o4q2xkh3t>
In-Reply-To: <qasdw5uxymstppbxvqrfs5nquf2rqczmzu5yhbvn6brqm5w6sw@ax6o4q2xkh3t>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 10 Oct 2025 10:51:40 -0700
X-Gmail-Original-Message-ID: <CAHk-=wg0r_xsB0RQ+35WPHwPb9b9drJEfGL-hByBZRmPbSy0rQ@mail.gmail.com>
X-Gm-Features: AS18NWDeOGtC5F9tBQ5g_zOvePSOzRo7FmLhKL0Jh1LjZOkog6ZFSNNw2rY-UUo
Message-ID: <CAHk-=wg0r_xsB0RQ+35WPHwPb9b9drJEfGL-hByBZRmPbSy0rQ@mail.gmail.com>
Subject: Re: Optimizing small reads
To: Kiryl Shutsemau <kirill@shutemov.name>
Cc: Matthew Wilcox <willy@infradead.org>, Luis Chamberlain <mcgrof@kernel.org>, 
	Linux-MM <linux-mm@kvack.org>, linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 945F040016
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: a49rfr44wpgfok7xy663m1w39nw6ekm9
X-HE-Tag: 1760118721-692376
X-HE-Meta: U2FsdGVkX1++WQsV9/fpvewtJuUTfwQDPyusaZQwzACAlqtldADDizvWFfzkRPebI24aCNuuXhYDTusNggACXIs2AZXoIs7hUa/ta4VaFED+1Yj+dni16xraHa32FiO5KgH4GOJjq3wO9aaW0c28m8j2dW+MiFCm1fthX7aPAstUKOyeucFZedju53adfC3QzqMAmXvppjdoBf/wROd18v3Co9GPb7lD91CmzROpoEYADkcPOEz8Tu+nSHSERAQISoOasXvSYcs1EigxF1MFEz9PpadmNqlmqmKtRGs+phUfJe6Ms49r4yjknDC+ZEEkrxLQTl5X8weQfx6kULHdWI2kiyX5EzTToxfT9OWgHBAVitdDC3qkkLI/vnzxPWGbQWM/C7DTzFpVk95UBwFZAwmemPUYd4Y63ro4JyetsGzI1DG6nAWFCspVcsPDe69Nw4iTNop2Vv4yJvxMythrYwF/sg5Rx+5rXc+AQ0cSK7PNmY/ZhOBD8QP1WeX29m88z8Kjpj260hhEIjKu+gCzt9fYtPwXusuRuPIeL1w4iKU/k+FlDipUejV7aSSWeeZ7t3mXVvOKmVljH6HUbKCukoV3qOrG97Cp7Gsmz69EUYOVLXozmxodPRcMu+v9rlbyk6V/lGQ/6nU1EODxZiCsBI3cXQsfk+u1HAx/nMb1+dMrZK51gojyew+IcHyCK1fuia3nFdLekVf9QrC58AKvZLf1qoOIqXhe1HYNMVScULFYCLtbsH1j9jQe67p6TgLJlh61dqFvqBOAijLRyoAnnSQtC1eFNzDqk0EnD4+QG8grJi+AqZjPOamrU62kcnVsAds1lqHyozqS+xbLIs79d4cGhTbYCBKHKfe8zPMssDyWS+A2WR7CgIaXLoSyZIilac/YMV4knohngy7sL2chnKhjegf9+DzIjj1dmH6GREDwADC47doJUxnd2S7t6AEsl63V8Q4EkgWgecQ6UKl
 815Pp+8v
 0xjr9kodZQ10ekOvkgTIF8HAWbNefVH/8PskxtqjISmiPUvuEncQZE4GZzgZbSTOZdvYbLHK5kPtpVUXzDKX5cONL0n0Qx2Bst2ru+j9cHX0uW8wTDpGVDlJo+qI78OJAvVwrBWPwfko45MXRfBOHgnSibqclzPU/GbZFKITIzBvn/Bkrj89qDp4zBaRRmBL4pEsSgbLR3CEb5LxWIm1LIEwc1B3jD6o6fjnRZGabyZ670KLDkoWCICwzWnYxKV71+zbUL6SHO3aM5pzJfJxa21f/ScFoQOyOAXXH5GyD+2WLPjuMrwBbt//cC/eW9A//s8mAAx8L+pw4vJ0Gjv0pr2y/oU7yWA8FUzICZ/J8wWqsVw76wT/oWymLP4W/j/oceVW6SdnKHOjG2ZfHJYjVGIpSZ+jHmPIp6fGIQJ1eEcon3gwiBc4MVXR4nPa/OStc9QZjTyHPPWIVSR0dIApptU7p+epUzzk6YOLwTqGVDg8JuGzRxFXl2/P52th7lr0vCk5e
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 10 Oct 2025 at 03:10, Kiryl Shutsemau <kirill@shutemov.name> wrote:
>
> > So honestly I'd be inclined to go back to "just deal with the
> > trivially small reads", and scratch this extra complexity.
>
> I will play with it a bit more, but, yes, this my feel too.

There's a couple of reasons I think this optimization ends up being
irrelevant for larger reads, with the obvious one being that ocne you
have bigger reads, the cost of the copy will swamp the other latency
issues.

But perhaps most importantly, if you do reads that are page-sized (or
bigger), you by definition are no longer doing the thing that started
this whole thing in the first place: hammering over and over on the
same page reference count in multiple threads.

(Of course, you can do exactly one page read over and over again, but
at some point it just has to be called outright stupid and an
artificial load)

IOW, I think the only reasonable way that you actually get that
cacheline ping-pong case is that you have some load that really does
access some *small* data in a file from multiple threads, where there
is then patterns where there are lots of those small fields on the
same page (eg it's some metadata that everybody ends up accessing).

If I recall correctly, the case Willy had a customer doing was reading
64-byte entries in a page. And then I really can see multiple threads
just reading the same page concurrently.

But even if the entries are "just" one page in size, suddenly it makes
no sense for a half-way competent app to re-read the whole page over
and over and over again in threads. If an application really does
that, then it's on the application to fix its silly behavior, not the
kernel to try to optimize for that insanity.

So that's why I think that original "just 256 bytes" is likely
perfectly sufficient.

Bigger IO simply doesn't make much sense for this particular "avoid
reference counting", and while the RCU path is certainly clever and
low-latency, and avoiding atomics is always a good thing, at the same
time it's also a very limited thing that then can't do some basic
things (like the whole "mark page accessed" etc)

Anyway, I may well be wrong, but let's start out with a minimal patch.
I think your first version with just the sequence number fixed would
likely be perfectly fine for integration into 6.19 - possibly with any
tweaking you come up with.

And any benchmarking should probably do exactly that "threaded 64-byte
read" that Willy had a real use-case for.

Then, if people come up with actual real loads where it would make
sense to expand on this, we can do so later.

Sounds like a plan?

                Linus

