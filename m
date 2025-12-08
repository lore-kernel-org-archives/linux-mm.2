Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7110BD3ABEF
	for <linux-mm@archiver.kernel.org>; Mon,  8 Dec 2025 04:09:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D272D6B0005; Sun,  7 Dec 2025 23:09:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CD84F6B0007; Sun,  7 Dec 2025 23:09:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BC7066B0008; Sun,  7 Dec 2025 23:09:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A7DE26B0005
	for <linux-mm@kvack.org>; Sun,  7 Dec 2025 23:09:17 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 535715A517
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 04:09:17 +0000 (UTC)
X-FDA: 84194973954.30.45F21C2
Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	by imf16.hostedemail.com (Postfix) with ESMTP id 2ADE3180008
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 04:09:14 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=google header.b=a0IeSM8u;
	spf=pass (imf16.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.218.42 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765166955; a=rsa-sha256;
	cv=none;
	b=vHaUqXyeqKjVkU2hBM8UTuM2o1bYf+s6xiI1LJWcCnyggD+qy09VXdG9ZI0158VgWcIood
	YTalamg3Fxr9gIoc5n2sv12VqEIQnxkM76Sxr6uTQDSJvih5Diz+StQAajh6LbXmnmyLKk
	TzYxXKGcThvxbVo8chmpENg/jlqnWak=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=google header.b=a0IeSM8u;
	spf=pass (imf16.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.218.42 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765166955;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yjpMpxTSEmH7ETp9HeUWdoHVAlweFsF90v8ynWQoJSU=;
	b=gc1aCLsG5P/nEViz8CQVLyvdRlk/FJfp4OfOaRVJLJ242rmkPxm+U1f2HskquFtP7ZWoPP
	WC4aEytzCcnSOGuojasfZACYFdAUE40QkU9z2IIYJR0BFmy3sUbUjJcIYnBkfyUez+zYbu
	0PIdz5O3EaJ5TGT6DSeankarujJJIOk=
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-b75c7cb722aso564901966b.1
        for <linux-mm@kvack.org>; Sun, 07 Dec 2025 20:09:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1765166953; x=1765771753; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=yjpMpxTSEmH7ETp9HeUWdoHVAlweFsF90v8ynWQoJSU=;
        b=a0IeSM8uIaqO7JUKLaMaH5nOtow0skTNziJtjk22M540ZNiIVbFr8XkXuz4GghMree
         8k0iUWzB+N/0yW/YOjSfsLzKTOngvxjbX5CVWR15LAVzdgpur+oQWvwzRb1pmSI6XLHM
         Dm4k3M1mZkvw5ekYoOCiJcQ+WDP6LoJu66eTM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765166953; x=1765771753;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yjpMpxTSEmH7ETp9HeUWdoHVAlweFsF90v8ynWQoJSU=;
        b=vkQ4f4SlEgmB+3cKnnEqDcnIh5VExIpSV6wwsQHg46cTYKYJsWymiY6GwOiLiWFwZN
         hHKz3i/zsvEVf72g1u7J08QtyDovGAWhpPeyMgF7+Lk/QRQ7M4NGTPadI8i4GxPlBaDt
         u5fnmI9qYjnBp5Bd6FOOY+/dUapR1SkOJY9TlrJuTKfej4KkXC3KrumoA85SLVaqHNag
         FUXHWcEhvMyzr03mZQHrc9QQGff7/mi0mKdNix2ypEOQGPiL923X5S23tMlO83vCM5Ty
         Nk6KVxTz571lFv5Qp0E5pFEcm3XqNvMG25Aak8hJAMa9isRTLkRAnaEHGA5eS03UU8dA
         bM/g==
X-Forwarded-Encrypted: i=1; AJvYcCXc2h1AcyotuNgaCShZwkKlpbu5q8Xjf3o3jLPWDmJEfy+VNIpohL4eWVzEX+/PUnqa03nhx0Tnbg==@kvack.org
X-Gm-Message-State: AOJu0YzZJQnWMRB2Y4swyw6gQyLDE58mJ0g10Rsz5Idgx6zwWhF4EX7z
	Mw+/4/C/Xe5XwEPxRxof4w0lBjIfl9YJXB0Jf8phkLrKty2ZxtbpLZwM68Uc8ce9RgI45OvI9wv
	ijMviB5y9bQ==
X-Gm-Gg: ASbGncu88Gm88aEHL/Qh6G+f/eV9y5CvA5whpRj26AC7M6iNjS+eWeuhmGHbL0N3jS/
	O3szWcxj6aSscr7I4KxuFITKwXmKTVL/UDydLxJbIw2baE/Cqtke3hGlR31v2WJgOSARnjQlNuf
	BLfoqSb67UaazIBvzOyUbCytAkWhclak8X+f2XW/PBuhaiEtCAXlNiLfQPbJZKajt7t/JjdQ7gk
	mclRNwKrAyViamtrQGfmg6BNMAlkXvB1ZOhVO+MuIuzR3uNcPRl6HpEBinETTYL1I1VWrlNrip7
	5p7UDjFhGOwVobBgvDpkLD8y5OrALzzh6addTgrmXNnMZ7Lt2qBqtKamc32jnLsJqQrvvIbNlhV
	nZKQKIyFiQF35EBS/+l+EWpW1IboQy6pWDO/UPr/Yno8t05yXUQPj5dxcB5Ttqh8+uGGVLV/u4g
	qIpe92hFpHl030EJCT5xOQ+Q0r7MT4NZAAJ4tITXl3/REilIkOON4mo2IUAYs=
X-Google-Smtp-Source: AGHT+IFtVtwW3fOyvJ0Mehbfkkr0d1RyIAAFfkfHfieNviy+DEUDChIynjsAWKbQ08zy8Bb7klxbtg==
X-Received: by 2002:a17:906:f594:b0:b3c:82d5:2119 with SMTP id a640c23a62f3a-b7a2428bdb9mr534947366b.6.1765166953144;
        Sun, 07 Dec 2025 20:09:13 -0800 (PST)
Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com. [209.85.208.41])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b79f4498d2fsm1000740166b.21.2025.12.07.20.09.11
        for <linux-mm@kvack.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 07 Dec 2025 20:09:11 -0800 (PST)
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-640aaa89697so5247616a12.3
        for <linux-mm@kvack.org>; Sun, 07 Dec 2025 20:09:11 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCWTilbj1LZ4fQg9rk6UXLCpejLVoIROMIa7f0Dsxm9xLt4jg6LhqhuIkORY45AmWyzkKdVEG+87DQ==@kvack.org
X-Received: by 2002:a05:6402:144a:b0:647:72a2:771 with SMTP id
 4fb4d7f45d1cf-6491adf5cb1mr5006982a12.22.1765166951064; Sun, 07 Dec 2025
 20:09:11 -0800 (PST)
MIME-Version: 1.0
References: <20251206111533.f1b18ce84d0854b5f6d86a8f@linux-foundation.org>
 <CAHk-=wgG3xqJn1=SVw-npsdwCRtyY=sYbLa7HFkmj_Q0U=vdHQ@mail.gmail.com>
 <5e5e24eb-6af9-464c-ab1e-f9ee55a05a24@linux.alibaba.com> <CAHk-=wgvMBRrcR=DzsRKcLdZpmg-kJz49D1CzafjrWj+BzAGiQ@mail.gmail.com>
 <f72b8316-ddae-466e-a72d-0df9960d6c82@linux.alibaba.com>
In-Reply-To: <f72b8316-ddae-466e-a72d-0df9960d6c82@linux.alibaba.com>
From: Linus Torvalds <torvalds@linuxfoundation.org>
Date: Mon, 8 Dec 2025 13:08:54 +0900
X-Gmail-Original-Message-ID: <CAHk-=wjiiHNi9iCNZG58zH-AXpfM85giXho9m5YC8t8us4aWAA@mail.gmail.com>
X-Gm-Features: AQt7F2qwZ98ba2_lKzAT1Sk2bdcZpr0oj3bTXTVca09vBhmN_TYgXCKX_2Zkd3Y
Message-ID: <CAHk-=wjiiHNi9iCNZG58zH-AXpfM85giXho9m5YC8t8us4aWAA@mail.gmail.com>
Subject: Re: [GIT PULL] non-MM updates for 6.19-rc1
To: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Heming Zhao <heming.zhao@suse.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Dmitry Antipov <dmantipov@yandex.ru>, Mark Fasheh <mark@fasheh.com>, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, mm-commits@vger.kernel.org, 
	Pasha Tatashin <pasha.tatashin@soleen.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 2ADE3180008
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Stat-Signature: cd4et5bnsssh89oxcnuct9cw5jees5ce
X-HE-Tag: 1765166954-586487
X-HE-Meta: U2FsdGVkX19iwEzxcd3N9RTAyiAK+I+m+HIY9x/y+VLjNc9vO1au9tvD5bWZTgVVq+drGgysqHDdn55n0lSNH9nmekqBJfsJkPvZn1Dp4t0qoRhl2fhQvTwibUKKD6MCJVecE6DjsecbcuvuofdTXBT1EmnFClJLOMcejtLNPedCCQCz0DcB7kRpDxfI9J/CpUzBf4VWn+GG1FiKsGQZZKcP7k5cQBpar43dfHP5EOUZ1yL8i2/uqUkF1snjevM/oIpe7Sb3zW5MkvVI1Q09KVyIt3s4uVN5huBSodlhdfLQP7ccdL9reYiNU6T/CdgNM8R7fSZ9kzaEkkKdxC/OvWIOqlRcG4IFDITC4Cz1RbdhagBHrkjdAani3Eoc404NmdwGhobz4XQROATgAbz2fjiM0RFMeH5LglAf6c7K1mN234gQF+tTYtBKh37l+EvLUUBsxWgisv57mdkapqDxCxfmTxJ8fhsXws9HK8IIH4ZZcDndxBSPjHgtILJVuu/YLZuzoEBQ7QPN/lf2jxy3rVkoyQmHimYKF4Ha07mjQ76OKjWc8ocYJDPoy7wPbmzd7l6BSQRcPxIId6yazZbrm+OjaTtvRs83vU13QJ9+wvbEp8CPi0y9FM8Ew8cFwSoqaBPH+dlyoijVqgGIWpb3BYmeNTWPBYxefycMStHxT+8ApfzlnWUGn9GaGgDzUgzK5tRX0yrWlUTn3tVUDNASktNvhXtVFoeNt7/TJWYE78UU4c+6IkrOBwuBieJI4JaOAyhQp8m9NmtHw7hpnTs0qu0mfouRttPf7mvnG1CuodWervBant6NwYt/logc6zGfEcYR5wt+l0gHekW3+v6HFxErw/1Fx9M/tHWdESDDa0iVGBHF6cRLJ0MNOlkJOL/lBoRGHpOk5/K0t6RuJ7inpuROw6dfxRygiSCcn+ymeMwuPnoAVAMBYJvHnsNBJZKGENmwvgR+SwVY7lFRkOb
 cljp2n/3
 TN3XMTviwKFI+2CYuG1ce2CmLSvOA1EpSq3GJuwG0XcSWPtUpBz5SEhtrgpw3Wbz7zbDuo+G+mNULd+uz78uDzW0BNXFl3NUg59TbXcU0NCjoJr5UQ8CzKB5Rovo1DGttSd4eIpoxvMIhP/KYUrSicSgG2pEWO82Xp17HQJmUiOX8SLD0UouYz+dEJJpoCY48svj312smNP+ZkTtkZpx7verzQPqBVAF6By72bU/I4u7pQR+nfHrDUZhHQmfyVVY1mkSQIsHFSTtZ7VDdKiVbedpeR9uLaMPUL83xiTiBDO524oKsOX37eLt0Op2IM2Ktn63Zo0WI0dJKavCz6VmUSeUo3YX5JpRZLC3VkeTKLlOP7uvL44nn2MEAHWw8L74yFoQXyCrLWXtkAd1SlR0gPp6YuBNchVG11CxkVEqQ0o09bv3fHQrKYQkRirC1ZvqfgPGty/qfCjebnl6WwZbqcO2slTFULLAmDhvp
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 8 Dec 2025 at 13:01, Joseph Qi <joseph.qi@linux.alibaba.com> wrote:
>
> It seems now new_xh->xh_count is 0. That's means, it is trying to add a
> new entry and here 'last' is pointing the next free entry.

No. If new_xh->xh_count is 0, nothing ever happens, because it checks
for that case:

                        if (new_xh->xh_count) {

and that's the only place where 'last' is ever used.

                Linus

