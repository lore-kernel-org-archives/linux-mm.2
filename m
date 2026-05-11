Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 42BAECD37BE
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 19:01:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AAEB26B00E6; Mon, 11 May 2026 15:01:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A85D66B00E8; Mon, 11 May 2026 15:01:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 99BD76B00E9; Mon, 11 May 2026 15:01:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 882BE6B00E6
	for <linux-mm@kvack.org>; Mon, 11 May 2026 15:01:55 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 3FDDDA01EB
	for <linux-mm@kvack.org>; Mon, 11 May 2026 19:01:55 +0000 (UTC)
X-FDA: 84756058590.01.D986B2D
Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	by imf13.hostedemail.com (Postfix) with ESMTP id 3DA4A2000E
	for <linux-mm@kvack.org>; Mon, 11 May 2026 19:01:52 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="bNOf/lrK";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf13.hostedemail.com: domain of jannh@google.com designates 209.85.208.46 as permitted sender) smtp.mailfrom=jannh@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778526113;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UasgaygcEAyRMWmEw6L6LjHmbIj1q8wLQQcU0N5zRcE=;
	b=npfuLMy9paZHueujIFKlH7d07oNs8nQXtxFpvmSh+Eud0Zy6mT4So7vDlxaxa6H7XZTEST
	9iPGuswD5LTXn651TricMb3dZctEHmMlWR1hUeV4Rrp+R2+ZoYuByslHcf2yYhFCWCaexC
	xisQX15ZLNsfTHWqaa1Z/JywAdsSQEE=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1778526113; a=rsa-sha256;
	cv=pass;
	b=UiGkFWWuYD2TmXoJr0JU+tkunNejzZs6zw2cvj6a2TopBrh9F0wsxQ4lhVEU6aROP3mRw2
	LMlUIoO0BMqdx7kwczQ99QEUG1adBH4EMYjhlCJ9vK1mbGzyDPm+BYCtIc5mxtWDPEy4Sl
	vh4WLoHOKsKXARuiPr8PYBBIXzKlQDA=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="bNOf/lrK";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf13.hostedemail.com: domain of jannh@google.com designates 209.85.208.46 as permitted sender) smtp.mailfrom=jannh@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-671588ab0cfso1029a12.1
        for <linux-mm@kvack.org>; Mon, 11 May 2026 12:01:52 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1778526111; cv=none;
        d=google.com; s=arc-20240605;
        b=e8RABUTXuLF41rmBc7gupOyvxjkHUPKd6LKbMZN7EtGtRAky47ygPrfFL8YA2dqIZi
         W6o/5TtgvpX7vE3Hs3paSIo16v2rREbz+OTYbjK95drrwSFBGdXwN9h5xl+qR1JIW4CM
         +w5CXAt64sVH2jFM4wG2XpjA2Yh1YFe4qi+fXs70j54PkgOt1YCQ5XLkOc/q2fdCBh3+
         9jJRSw2SPIUvvtd9I3wWC0HQTJhgAJ22Y0vw0GtTF8kbI5FJWdrJDyduNRQvoaRSlMLW
         UDcuQOJGwhHh+KJJfONGtfFMQoYZqiXuKSOvXxFUhKZwexa/8ts+nO9FlyluM0sb7Rcs
         DF/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=UasgaygcEAyRMWmEw6L6LjHmbIj1q8wLQQcU0N5zRcE=;
        fh=+/AjhoRdutnZad3nFd4xGhYqz/0/FosKHZwLaP8511M=;
        b=D7Do+w08kiAxp1mhqpson7enphTZZVlQ8ZbklzgF9zyi0QAzNyc0oz+oN/0wXIPJVn
         yPccbakhpQjSTeKXRbmlICaXOWI4ccAA3UiWp/pVQQP84T6tCrIrGeQ+IAV2329FsXf8
         LFaMs0+xNy2iYF8E+H3s4PRNygaSMeuxHWfK1e2FmnBikeUfbcsbOJJlq5/G7Ns2Vq8/
         DJpNmZLYhfCpm5C5zp+AI622W80pgiLGhhKKvSiIyNVIbxbiyqBn/xdK4x1rhpJKQA0l
         ApFNffrrjb7dWUkNLksjRagaWG6QZ4Y0otbpfqy9a/KYj4s0X1m9/JgaSEeaLHw7LIKK
         niuw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1778526111; x=1779130911; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UasgaygcEAyRMWmEw6L6LjHmbIj1q8wLQQcU0N5zRcE=;
        b=bNOf/lrKgsyW9lsdLP/jvKmOqr8QC0VQDPg0pAaBgvfCEV4FKPJlG7/VSuCjumAmpO
         ra8m+M4WmCRYeDHYqLfgOQqrW9I6JZMfcH4JLb0mEx9/yec4WnOPV34820LyRqY1D1lS
         Gh0jQJJzXRy1i/UTgoouba6s3C4ApA3xLuLCSOrpKJyPbTkoodzL9/iOiZJ0MqQ0e5Nb
         8yrG4nC+1IJonLXwZCFq/yxaNW6ccJoyUvxwnp322l+1NBBKSLiaTCqGsZuwQdSseFgK
         tcefn6vlR9w/LeF/fB/wHJLhtnmfCbjlPG3noCCUYvt8XBSrtU48oVrEXskP6WSQgGUR
         Lwtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778526111; x=1779130911;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=UasgaygcEAyRMWmEw6L6LjHmbIj1q8wLQQcU0N5zRcE=;
        b=eie7M7VUsFAiTuCgchLnC5XuwHtwizvzagjPgTPfkXmy9avWxtrdeBCyk0wFUpIq8m
         HAL46N90oDPz//924sNRyssNG9rAUm+zSzdQzymWNAFdFk1/4fVptKqbcP6ZlNIdeN+q
         cMgxKKWK19P0z9acCxHMzrqHoJrVFfx/k1QxilQPZwmWNp2KsuhWTftVdgB000p1MEe0
         pwgTrOpGww/DSbAFjEaRALkzwCKK8InE9zf6x0/2sFtOIEoxEbO15OYvli5CXhuwpu9o
         IlqXqiZM7e8A8yVqbBhvnkKF8ZpChCPMSSvtz73hkEtRj5smfc2a8X8rufvRNoxus0Pg
         J8cQ==
X-Forwarded-Encrypted: i=1; AFNElJ9XpQEwCuP3Uy8TGUs8bH2wFb/ZbnJE8YrBES9gmd+FAYONHJM/Yjhp89A5EDYbPvyU/5gSDJ8BJA==@kvack.org
X-Gm-Message-State: AOJu0YyexQbw70Y+T1A3xd/VBYPWyTZ28LDgevxeOMXkI1tWPxGMo5B/
	2kTsmhiio07kKM8I+WVKv9p1Xbx14xYrLlrMjnWU6kiDEacsTe+Kl+UEuAMiicA6yCgCobX/q25
	eob56wiNEPZQ0+GJz6a6vdtXkfOfPJyMHeHol6DFr
X-Gm-Gg: Acq92OFHuCTMVVQXfmk9/W+dvDSl2Kzpkg2aUZPT2o7Kfyv/YRrDgFuSCLnUEBDXfXf
	+IFDMluzfQQN8oBn8AixkD95JY2TvAjpgEBfgFW8dMGM6QvUI3vtQHn7MYr/vwBT76sQU4hVUwY
	MF0DVPkSwU53SuD8eQWjapojxvqZIsseWCbjKFDgiQ9h0ddZUC8ghquBdveLYMJtOdNYTnWBTGm
	nQBWdhKXgASM4Z2KS0bvdbn5HYnA1oVLHGAwD3s1K3OuY74Id6baL3wsXXI/kWAT8XzPSHvkLXp
	3s7QLOyYfKVW9Wt3bXV8Uhj+xKODAVeSBrIe1b9QGLOl7ToL
X-Received: by 2002:aa7:c399:0:b0:668:c2b6:9fa2 with SMTP id
 4fb4d7f45d1cf-680b4539f8bmr5944a12.7.1778526111017; Mon, 11 May 2026 12:01:51
 -0700 (PDT)
MIME-Version: 1.0
References: <20260427153416.2103979-17-ardb+git@google.com>
 <20260427153416.2103979-19-ardb+git@google.com> <CAG48ez1DJ88a0pBCE-Q0VXyDuJgng8zdunb38g4b4JPU88exww@mail.gmail.com>
 <202605111144.349EF737E@keescook>
In-Reply-To: <202605111144.349EF737E@keescook>
From: Jann Horn <jannh@google.com>
Date: Mon, 11 May 2026 21:01:14 +0200
X-Gm-Features: AVHnY4J61JG6Vq5BHLoEJWjDPI-cUqKQQzYAmbcRiKqmBdXYMvgpf6b8RTG6Wkg
Message-ID: <CAG48ez3q2kW9GD-KVDQ_T=C=ADXmSqY2UyfXq_EMJeEsQ6KgRA@mail.gmail.com>
Subject: Re: [PATCH v4 02/15] mm: Make empty_zero_page __ro_after_init
To: Kees Cook <kees@kernel.org>
Cc: Ard Biesheuvel <ardb+git@google.com>, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, will@kernel.org, catalin.marinas@arm.com, 
	mark.rutland@arm.com, Ard Biesheuvel <ardb@kernel.org>, Ryan Roberts <ryan.roberts@arm.com>, 
	Anshuman Khandual <anshuman.khandual@arm.com>, Liz Prucka <lizprucka@google.com>, 
	Seth Jenkins <sethjenkins@google.com>, Mike Rapoport <rppt@kernel.org>, 
	David Hildenbrand <david@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, 
	linux-hardening@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 3DA4A2000E
X-Stat-Signature: 9en8mk93mwcfxanagyhgthfthiuwi146
X-Rspam-User: 
X-HE-Tag: 1778526112-973672
X-HE-Meta: U2FsdGVkX18ujmlt4m++Zp8RyOuFXumRig/jlf4uy57MYYOD+DWwrrq4a4CURs+18mcZm05pPxXCvumHStUOleM2bxHAQc9linJ+vUPbqZAssYKRm5CD4cfSvwhJyqCiES66i6weQaWP1QlAsX7c1h1hhvW1QY22/H7qyzjOC9w8yYeI9Tr9p23WKjP3/UP3X/OELwa5X1mYQc8dKR8G7NuHMP/VwOmgNw/V0CNJk6icxvKsOOGVFu6sBR1cqR8NzBDE92DYImyO0AK88wbS6CLiopHIBFuWEajT6QzLlcj15yDw15F9V8UQ/IktAUptXfF13IfZZ6k1KUh1EjyuVVesZXTJirIx55fPma9UkUdfNNodbpowE3QVZP2GiZTtm41karU2fOAnAQLnpfCe4Rg7qTvkuagwLudCY+361an9/5ijgKt4VmGJhM5qE/L9DbLwAijvQ9ZohenZlpaMhyANCjZaBsDkASywA9MF0h2zJcG0DWPY6GgmH+MT4qA3zKUNyYbjmm6rLJ2FUtBGBzrUOWguTfxVmH71gt90XpZJGbBuH800TAwzEW8VWwSmzWgIuqn2mFSaUvzbxyWQzFnXbX2mqggci+jibcX1pJLK7JeQMa+55zgMpScXmcG2UoU1+bnnwQHiW3BUg9m1zOG+QHOYoKZ+ONn4NLfiP6aKFp/WcCVNyDYUxKq+bNKxQLyJvpYccMABBa5Yp8ZJZybT0YdrSyUzLWTbjcepIN3XwDOa8QhoCId9jbC1s/b4eSIrQ6osiI2F7TV++9CHQP0Zg4y6RzvtwEazN7he7MT2Zf94TGzJ/H8WUMB+gGc8za7+7MxJ7627F1EsBUIWnF2pBf6nlqb4L+x7o8LEU1nDbAg2C9xxQ6yHs+KoxsatAinuMsOSiReQxkQSevtxx98+U5fyNTokmhOzYZHodDpcvPxfHb5MX1MVdeHwKLfvQ0gGvnsek3QFpCkJ1gl
 ZgHxesC9
 1yFIKZqbTsLSbttVeOpVYZQviSRd1Sy3THZTbT1ZSNoHl4rzmeSivEjMJwep0FEmd5losBsgNTDMkmiEXxZ0AnOGSQedwixyba8CA7Q1p9rBaHkon8NGNvQHCnC0ceogMjSDRLOOg/GUtOvaUh+ZffCV7+VRJlXGWWt+Lv7/vQjHRnd/gYbGzom2OmYASOsAb3sMyeHsdZOoRjM96hUiAE4Txww0UDN253/nQhObncBrxcH4NwFvfsufn49f9Dv+rn900jKFKrr72i2gJrj31WaQ8hyqOUbVapdhn6K+LhobGIO+EuPxuENrrvIeQV/sAiENN9+AUPRqgyCi7c0DDoRWil/qp0WDZZpzwYWTS2QCe6UhlEzWwTKZuzxKwnx7YBGuM6uS8bC+YSertNa3cTe8YIw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, May 11, 2026 at 8:45=E2=80=AFPM Kees Cook <kees@kernel.org> wrote:
> On Fri, May 08, 2026 at 07:02:51PM +0200, Jann Horn wrote:
> > On Mon, Apr 27, 2026 at 5:44=E2=80=AFPM Ard Biesheuvel <ardb+git@google=
.com> wrote:
> > > The empty zero page is used to back any kernel or user space mapping
> > > that is supposed to remain cleared, and so the page itself is never
> > > supposed to be modified.
> > >
> > > So make it __ro_after_init rather than __page_aligned_bss: on most
> > > architectures, this ensures that both the kernel's mapping of it and =
any
> > > aliases that are accessible via the kernel direct (linear) map are
> > > mapped read-only, and cannot be used (inadvertently or maliciously) t=
o
> > > corrupt the contents of the zero page.
> > >
> > > Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
> >
> > Reviewed-by: Jann Horn <jannh@google.com>
> >
> > Sorry, I should have looked at this properly earlier instead of ending
> > up duplicating this patch with
> > <https://lore.kernel.org/all/20260508-ro-zeropage-v1-1-9808abc20b49@goo=
gle.com/>.
>
> As you mention in your testing of the patch, could we add an LKDTM test
> that does the same to catch any regressions?

Shouldn't be too hard - LKDTM crashtypes don't accept arguments, so we
couldn't easily pass in a userspace pointer, I think, but we could
make a crashtype that allocates anon memory with do_mmap() (under
mmap_lock), then GUP on the allocated userspace address, then writes
into the obtained address with something like atomic_add(0, <pointer
from kmap(page)>) to trigger a write access without actually changing
memory contents...

