Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 91BF1CE8D4F
	for <linux-mm@archiver.kernel.org>; Fri, 14 Nov 2025 16:40:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F133F8E0025; Fri, 14 Nov 2025 11:40:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EC3DE8E0005; Fri, 14 Nov 2025 11:40:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DDA6E8E0025; Fri, 14 Nov 2025 11:40:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CB32F8E0005
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 11:40:51 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 767A213AFA0
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 16:40:51 +0000 (UTC)
X-FDA: 84109776702.20.4D320DB
Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
	by imf20.hostedemail.com (Postfix) with ESMTP id 776B11C0016
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 16:40:49 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=Exj5SGjn;
	spf=pass (imf20.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.48 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763138449;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+BmoiZRsuPnGxYJyUhaS8+69dvbkfobIcleZY4sazNI=;
	b=3Qi6lXl6SkNv8XFOc1OAVeyCSBLJRc/BXjYt2IYox/i3WQBpk2YdtXCoK5rcNBULew4wiJ
	1PRvLvXacSMbkDdJZ0nkm8jbRx4fU7qQw6o3WjRs9QNnKlwSEHvIgbyG7jsfx6rxTLBJ7c
	7IGY5eLWmc7eBy99sVWMWdviR10z/uM=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=Exj5SGjn;
	spf=pass (imf20.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.48 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763138449; a=rsa-sha256;
	cv=none;
	b=i2fU5KZrk57XHZvmak9fIB8nCv8iACb5LIW/Db7eiBJVWiurl8K95TeRSYCRgYB16Qf2/0
	Hv7YhkuVrNHDX7J9qrG57k0N0Y4I5N7htOsmD7BULfNmIZDeTJASZbe/yE1Nt8pg5wnXdm
	Sqx4yXOucM9rsrvnzYPyRAsiSXtsTdk=
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-640a503fbe8so3711495a12.1
        for <linux-mm@kvack.org>; Fri, 14 Nov 2025 08:40:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1763138448; x=1763743248; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+BmoiZRsuPnGxYJyUhaS8+69dvbkfobIcleZY4sazNI=;
        b=Exj5SGjnxYmcVAAO/BXIV+moLoqJ9ZAd988RcbM3fEGhy9YedHXp8DNA3LavZucaFw
         JZIUwBrxoAVvD0d46W4GwnvmEc34i1aRdl9En083cZh0G40FLi6sarxjv2oZMXvyJLhn
         WF0LLGYVw6Ow2wSbKyhL8144JA07P2H1oNF/bT6bY6Cf8FXcel3ihTq4EYbDNtfL5myO
         c37PNMtJmPWTmCEWS+iKUBf0AQz387yiS7pBdSaa92p+L05gzXQscAM+fszbhTQbNWV4
         tqxs4XsWKiHZZY0YMBZYRGAukxzeiUXTevW6enbukw1RRHWu53dGN6m/EBupWviPa8jb
         fYvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763138448; x=1763743248;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=+BmoiZRsuPnGxYJyUhaS8+69dvbkfobIcleZY4sazNI=;
        b=B26c8ZSOF0S2GxElsLugVZ6dTv7bQscGxpgFzV7BGhdo1AxdnulNChqZd0Y4vZQsQQ
         /5C+MKP6YVvsNSbCjqnb8VKFh6Hzd9gtDtlkR4QgfNj1HRLm9OkpphKKtbE4ZSk/ebgH
         kl2B52zU9hjK5kZYg1bFVhpuLCqEJAqv9pDflyGHLXdMyMuA6AE00/iwntgWmPuCmOVu
         rGcEM7jplfV/0O7oDXlCradrcvuLf40TvNQZiUeS5kf79WmPzuqxxrDKuMOtIPAagT9g
         F9a9x45sfAWSriiGId2U1BR9bIkvF4iR6zlt4BU69F0IOdznRwIVDcASDk9EDJVi0xVg
         KZhA==
X-Forwarded-Encrypted: i=1; AJvYcCUVzavFbJjJaCN4Sa6X3TCiH/8QlQPqN31GAR1FCvO2sssjzZEMyMtYk/jRv5Sa+0CnyY6Ow+GydA==@kvack.org
X-Gm-Message-State: AOJu0YxhABEZVNNWOqmOmQjVIt+1j//qbplESS28QaC9RbgqpX5Cj1Oj
	/Fo5BMYStYawcseT2ufBzSiIbrl6cnOGxLI12B1rVHe06xl9pkuQZyvNFBtgMMctBJVXuBMJbfk
	KPXdKVRf+8AFtUHFXQYsFTEULprMo2CtEA3PQTpe58w==
X-Gm-Gg: ASbGnctroiqR+D3Ru3qN0JqgzjwJkg9Kgp+UhAHQzK2KzB+RyKZGGFSSFnx/aACJpSN
	lqcxQLvBn/zb4yzLw5fZlK9z+TW2hAEPtMFeQuwStTq6GkFltEwadbk4JTYDzq4OldFJWzQXthA
	CzW840SRVYbTc5wlfGDUo+jGkwzQ88//iEyBlSSbbHPB1Rkz4Oo156GSIDm+Dj6Eud/EC1yRoU0
	PglqrjcNrCSkOP9IgxxGsaZOPaJbFj2aexzJAIEIjQns3tKYS0hhPMm+R2yvr9Mboza
X-Google-Smtp-Source: AGHT+IEF4x+kZ5m4UBqS5P7FCCGZmYDNBKrsgiFiSFZO70e9s+6ZZ4g35lOr+LKKumUlnwEO9GTykGNdehIw3+hWGOY=
X-Received: by 2002:a05:6402:458b:b0:63c:1066:8bec with SMTP id
 4fb4d7f45d1cf-64350ec7934mr2996599a12.35.1763138447774; Fri, 14 Nov 2025
 08:40:47 -0800 (PST)
MIME-Version: 1.0
References: <20251114155358.2884014-1-pasha.tatashin@soleen.com>
 <20251114155358.2884014-14-pasha.tatashin@soleen.com> <aRdVvxF2bDVjSN8f@kernel.org>
In-Reply-To: <aRdVvxF2bDVjSN8f@kernel.org>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Fri, 14 Nov 2025 11:40:11 -0500
X-Gm-Features: AWmQ_bnys2iW_PWd1e_-UViHA3MthYV6vwR21vLFLUBBVVOxt0CKBnBQUXPUwcI
Message-ID: <CA+CK2bB51Df-m3nTOQ8kRh+M7q_fdnpRR5xcRHSEgM3Q2C9LSQ@mail.gmail.com>
Subject: Re: [PATCH v1 13/13] kho: Introduce high-level memory allocation API
To: Mike Rapoport <rppt@kernel.org>
Cc: akpm@linux-foundation.org, bhe@redhat.com, jasonmiu@google.com, 
	arnd@arndb.de, coxu@redhat.com, dave@vasilevsky.ca, ebiggers@google.com, 
	graf@amazon.com, kees@kernel.org, linux-kernel@vger.kernel.org, 
	kexec@lists.infradead.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 776B11C0016
X-Stat-Signature: m8q4mad3f4osrsokr1ghwrbh6q6o7sgq
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1763138449-238379
X-HE-Meta: U2FsdGVkX19aGWls0iueEzzEeTMuhLIqU+jZwC0745UdWNurjUXGv9L2GqS7wWma9mjFnxbKyZFnRXaO+uPtAt/MzLxabAGXpW9gve090qxbo1iCZMDcH4N++7FxNHDodl6Uw7Za/sErYTRuyRCIxknwvVBGcp+zcs40pI0OUTWTWYLmPy8EMVuq3Sfh/etELKG3tW4ExC5Qx6Vf6ZbSqENTFlOu0FU2Zx2UIniVMN+5K+MhT1if8msdwcpaI1dZFQ5pQlVPkzwG7GcEJlBM4JUoGBISL6gxnKaq7uYR7xzJOPW1uZ6yhVejpC1b+aSBL4nb/WNvaJuHIzHMqZG2aa2LxIOt1NAx/7jd2nMYrkLUwcw6WI/yz/gxm54JSgsqVLnVHncZAwN64dW/ykkMK8XPtnuCcib9x1hR2JYD1ACo/liGgZyR/TIAjPToUPg61r4A5fyiuY0EPApsEik7q90Nh0RN9urVusI5Xqg+hFNBQ1aL8i7jFYAp6yjwnmMse0XFVABGEhVPwnNmBKUID5o75IvA8tXOHIq63H8aeBiWR6yVbuBKuGwu8otPecAM4h9hncNdPXi0ybuBfoi82u+WsntfOcG5cjycDftm07/HIjp1pIX0N0WSViw9KrY3ZI3Da1DGE89f9DMyRnqPZD2EzllYyQ2JGzaR1cdrXCVkgYmmiPHGaOLvmviKW/LioO59TvP3Ir9r29zlj4Se9H/6BXXjo+GqVVSe8n4NtmLY6BMCTz8A5DOtoFLhQQCk/hBQCuZ1Mpqjw1vDFV5+icamMPqDKLedF0Oh7sO4D9ZARoDkQxUQFetijBnj096DsCRJ/vsKF1qgrBu9+/XqBQ+0qIZX8x9ecWKil++dfuITD/pTJdIrsawpYnaiU1h1yLgJ5JHFAEXJb6X3Qtdqb51LAcsnKgCO6MQZca22RncijaOABsVK2S5cFmqfvmFYxcOVh7ViGliR5UnHGQH
 L/EGgiF3
 POYdns/b9htVdeirG3Tt/hnVseahHp2Gni5SGqrs0apMVaZIsS9NlwueBcli5EMzVywkA1rAwc7uTowDW8qtv5tiYZMpsZrxWzMzwsXGboBD/ZcqdnqLpFPrzWLv4pERNXrg7uFFdC1jjhqWXnCmd+c5oR/E79eH0z8Gzd7iRhv6BkUjdG17iJ93QvpK3b6932lzGpil/xKrxzPy2QYjpUiw/aIyE6+3y6dgSO9LAJIAr2IGPFtxdY1aezrfxoT6S6OAChVp4T4eqhjlCkwCEs+NPYw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Nov 14, 2025 at 11:16=E2=80=AFAM Mike Rapoport <rppt@kernel.org> wr=
ote:
>
> On Fri, Nov 14, 2025 at 10:53:58AM -0500, Pasha Tatashin wrote:
> > Currently, clients of KHO must manually allocate memory (e.g., via
> > alloc_pages), calculate the page order, and explicitly call
> > kho_preserve_folio(). Similarly, cleanup requires separate calls to
> > unpreserve and free the memory.
> >
> > Introduce a high-level API to streamline this common pattern:
> >
> > - kho_alloc_preserve(size): Allocates physically contiguous, zeroed
> >   memory and immediately marks it for preservation.
> > - kho_free_unpreserve(ptr, size): Unpreserves and frees the memory
> >   in the current kernel.
> > - kho_free_restore(ptr, size): Restores the struct page state of
> >   preserved memory in the new kernel and immediately frees it to the
> >   page allocator.
>
> It would have been nice to have it before patch 3 (Preserve FDT folio onl=
y
> once during initialization) and use kho_alloc_preserve() for KHO's own FD=
T.

Sure, I will move it before 3.

>
> > Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
> > ---
> >  include/linux/kexec_handover.h     |  22 +++++--
> >  kernel/liveupdate/kexec_handover.c | 101 +++++++++++++++++++++++++++++
> >  2 files changed, 116 insertions(+), 7 deletions(-)
>
> --
> Sincerely yours,
> Mike.

