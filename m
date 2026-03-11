Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 36D57103E2E7
	for <linux-mm@archiver.kernel.org>; Wed, 11 Mar 2026 21:28:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 900D56B0005; Wed, 11 Mar 2026 17:28:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8D8ED6B0089; Wed, 11 Mar 2026 17:28:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7D7A66B008A; Wed, 11 Mar 2026 17:28:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 67EF86B0005
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 17:28:03 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 1BCC11A0431
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 21:28:03 +0000 (UTC)
X-FDA: 84535070046.15.7F62195
Received: from mail-oo1-f52.google.com (mail-oo1-f52.google.com [209.85.161.52])
	by imf12.hostedemail.com (Postfix) with ESMTP id 1AE0C4000A
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 21:28:00 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="pKkQ/L3r";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf12.hostedemail.com: domain of nogikh@google.com designates 209.85.161.52 as permitted sender) smtp.mailfrom=nogikh@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773264481;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1AfpscOl23y0kgBvUSVae0SftirJC1B+VE/VgHXoA/E=;
	b=Y0WSJPNEODSYrQkDCOg5qZIpPrXzYaVdp/u57Wr5CziEEwLiGRLf8O5y6X3WtSlJnT2mxo
	wmvsWCO9wI+mS+5wX0U/GYdQO/mVJj4KYRPe7UTxiZPBBbQdrkfganvDhCXarbMuJpX4cU
	xoHJhlWxbYJ38sQgNXluGk5tl+kCDlc=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1773264481; a=rsa-sha256;
	cv=pass;
	b=ws8R7ei/iuLQEvi7ufd+W0pNHNgagOFZ48tRGw391k6LAJAeQHQYmt6DcKxRJRWqyyGNev
	D4B5U9lOfs2ro5lt5fTxnkLOecUAAaU0Yhq4dXEPnfgFpGWmCvNVgftICBD84dJLgFVkrb
	dkeVKKTHGQGezJlbMlsRY4OA9uc5Df4=
ARC-Authentication-Results: i=2;
	imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="pKkQ/L3r";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf12.hostedemail.com: domain of nogikh@google.com designates 209.85.161.52 as permitted sender) smtp.mailfrom=nogikh@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
Received: by mail-oo1-f52.google.com with SMTP id 006d021491bc7-67bb5e4d06eso161529eaf.1
        for <linux-mm@kvack.org>; Wed, 11 Mar 2026 14:28:00 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773264480; cv=none;
        d=google.com; s=arc-20240605;
        b=QHSkD63Y3CbQgUWuNkTzgUidwK3w/sdG93kVKCY7Kiak4IREzDfseVTAf28l9Lezrs
         nDx0+bIiP8V7DYCmYQd1rMf1FTJRV0AB2+yScSvwCRBQtnFs5hzwMzX5udEBYgKTkVCl
         Syi6sJnCmxqwF6xcwuJPEQpUm1yIe1uVhM9S7WSzP0K6k19HvrP/KcKTHDlm6il3NcQT
         VMz3nDYQ1MpTjfeFmqRLH8T2Z0ASjDnSxZSsElqdvCuVbI4RZoxfBKesHorND4KPbmyk
         NxSOLqimYCvPwPwlPg/pwPFI7/3us1tiwz1yOGZw6CaK3ZVImjPVmsXeYYMkgr2VKN4l
         SKQw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=1AfpscOl23y0kgBvUSVae0SftirJC1B+VE/VgHXoA/E=;
        fh=HrOMzg78Cd5ZyvYdmtuJOmyRjWwlU6wlESAQiNseeVk=;
        b=crX9af1mfVmQwJikwjytL//zjhtXuCcdSM3XwKYjp8A2yG2ZRuRp7+XrYdueI+wGCx
         k0XUEZyUzQAe1bfmge3equxYUvfMsn/nnxuwkzvSTgUNcqeYyvKbLKsFF8ifrN9Pu++c
         +UIvaGrOdNAkjgD+mD6YstX0tSH9efnlGUDz9xQiiBNzJDeHtMYESP9u1XacQlsYq4K9
         mXQrxFldMbQdke7D9y3zVlXs5EXmdyQiapAHxbTZ6Ld62/QY2hQyg2/qEPJpXkQzGODW
         /JB3SjMekJRxEj04P4dI9ai6pr78WRcdlKKuC0daXxoIzN+wWMLzVs6Q7TfWGbKnr3zR
         X0bA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1773264480; x=1773869280; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1AfpscOl23y0kgBvUSVae0SftirJC1B+VE/VgHXoA/E=;
        b=pKkQ/L3rmGVNkSZYixK19jbAdjn8eOm8iH9umijUSTChwmO+IknEXGS8r80+2egJrC
         m3T0CbunDxJCsu6IUUwenJIycD3VBa+AUT7YawPGN9OAY7WzfyWeWrS28O4wZtxfJwgv
         FAF8c+h29+cllYQiLXEGfJXDYBBl2euhdr2y2L9RhjeSGrMDJ4raTIg8GK3hteli6Hqo
         SqDGmBCcpOX6RZicmyuuJLXKlik8gigrB3F/GhxQKqTzDH9mub9qH7GvXxkU+Fp/xCxZ
         8dkmwUKqeX09P0XJ+5mldMClNQHZG+GBil9wQdoe0XOC1Rylk9lKnoX6hUeSpY4tKw4k
         mzPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773264480; x=1773869280;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=1AfpscOl23y0kgBvUSVae0SftirJC1B+VE/VgHXoA/E=;
        b=At0MiVYb8m2apY3nTHY5/HpX4Gv47dSn4Yzf80ve4dZdcwfXdHiqDB389vvA9LILKA
         9FDO9exSsHTYRu8YqdRSGHjQTzpJf0rabouz/5Iug9adUy8mycvmk9LNXxdZalTQYC0y
         4u5q+i43dFN9ur5EGj2ZxQLVnYhWoY+4+FWavwaef/HvBHk+yvYaHURrl2dz6kjXW0hY
         76CsyUwaaT6Bmd5JFM1qhXY8QC22xtr3ebHlgwwOewLEKudtc6hOLdpOlvbYvD0tojRk
         FmZ++R0rq7cIUgxMsxN9ncYRZsasuT8XEDd43vdabcPgD6gxKlXEta/VgDN6kM0cJ6/t
         O37A==
X-Forwarded-Encrypted: i=1; AJvYcCXeE2lIXcHoKDc+8DYqvVQthQehI4DHj5MI1jEe1+zFCjaYD6W7jWHvGW42iK7bmDtELxM8m3hs0w==@kvack.org
X-Gm-Message-State: AOJu0YzdCWf6rsdEvinZdhLCNqhphCF4+CI/HD0djSU6o41tkc0RQbPq
	7Q/pY75YcBB03ePJxgg8qk+6bH+fLdePhRwNF6jrhNnQ5VD1E/Djn8XSImLJSfaStdW0UyeYwKY
	u2A/0unZTERiApARoaAL381yNfkVK0BE5mERQUBom
X-Gm-Gg: ATEYQzyYq2CP+rbfwH33Dvdc/cS3RnBlQScDyGL3pk+EhZhipwzt/odHZUkKQoKTd1x
	Aa57j4PNmGgrkZmumlTS+TJYM7wSjzNvTaVbuAxb3o3hx1wX2eSCvudAbRyM5n+JxsK1KT9YEK/
	RyufuoW9fKiZ6viGI/2wPTHdLqga69s4noVil0EgQfx0t6XlhWfk2QgAKu+NjHOoX52SfYFpn0y
	zeSnI0N20t1ldSpYm6Fw/+HhkrlZv6xhKVjs/eDDTATF+cMmT04zfuYPwzyBQldGSQHPbCNqaQj
	Qt7gZ8ZOwHrxJK+dPT3po9HsQbnygijoLYnk/oDR0TrUj9UAq2YjuSdMvS98aYTThWCgNAw9EWE
	3/8EGtA==
X-Received: by 2002:a4a:ec43:0:b0:67b:b4b3:821e with SMTP id
 006d021491bc7-67bc8a5a4c1mr2166715eaf.64.1773264479583; Wed, 11 Mar 2026
 14:27:59 -0700 (PDT)
MIME-Version: 1.0
References: <20260216173716.2279847-1-nogikh@google.com> <CACT4Y+b1UZpV_i68cSP3XOBsr9EfbX+SAbXRdL3btmAnSvmMBA@mail.gmail.com>
In-Reply-To: <CACT4Y+b1UZpV_i68cSP3XOBsr9EfbX+SAbXRdL3btmAnSvmMBA@mail.gmail.com>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Wed, 11 Mar 2026 21:27:48 +0000
X-Gm-Features: AaiRm51S07yNuW3cPcrVSq28S7hXGinZghFBDdce6BA-XJE8j8KP7kq7NftJAfo
Message-ID: <CANp29Y6xexyfGo0umf38JK=6k4Mg+EGRyDmVfuxyAgpX8FxE9Q@mail.gmail.com>
Subject: Re: [PATCH] x86/kexec: Disable KCOV instrumentation after load_segments()
To: Dmitry Vyukov <dvyukov@google.com>
Cc: tglx@kernel.org, mingo@redhat.com, bp@alien8.de, x86@kernel.org, 
	linux-kernel@vger.kernel.org, kasan-dev@googlegroups.com, 
	stable@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, 
	linux-mm <linux-mm@kvack.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 1AE0C4000A
X-Stat-Signature: 6mmtyghz8b3jrnu4patd411kewt63fzz
X-Rspam-User: 
X-HE-Tag: 1773264480-705853
X-HE-Meta: U2FsdGVkX1+ZU3A6Bb6kiMVb+A/mA8BlZOndouE41y0n41tNoFsWyVhskzH6QkHLgDQ6H9kk5+Xjpjhao4ul1IzVaX+MXHs/l6qFnReh5IGVQyk8Kyb7aXQp0lT19YOQ9uR+lFft1DMnedUaFj3puHq28BAwWvuiuLQo4LS7fcxk3jpn5Jg2jhgNpPXPdY9sfxZk7q9U2FoCywCVFwz7iuDnLZXHOQxZhvcLkbeUPQHn2M9Koq4nmAfQrNcTZ6BeX6gdSUMJfEcAvmjnZQy8oEquso1V4sT568Pm+akTGFnkXYorSdcVKlQYqHl+9ZIgEBGyWP5vz8AwJD+Jwnajq7WqYPZYg06fb6R6ZGMnA0gJg/s4dKY4l731pN1JFnjL1xmmlqa+M4T1o/SGdzA8fS6K57Kb9DFkTIfqc8pB4EgLDbfvhuCP4n/t8TIJKwKn61RzqEijhR+T5I0wpjewoSYJGAdC+qan0x5vRU85wVuqKb00Yw6Y1EAwrMCEC2eAP0i7oi9thQOLPJsOVHfarSNCk5ACdpKKl7Fd2X2fpDhjR/PAwF4xArOSwsudQy1J2Ig3SIOhLdkYR3R/Rqa8RE9OVtNww6PtIXwlrXy2+xXHDMFJI+rGuYp14DooTxeXqAN8BHkoHgqH+gfo8SiMe+whRQ24sOFCIJnkbP1w3ZIH45Yuxagc8OnaC51MDnRVsVWzY3gjDgymTBm0j8CKhEppzDovlC1+yN/lJ+ygfRG4ugolILo4eRpvKGgeJMNZ/xWD3rWSu67uEm49i1oebn9j2m1PqH7KviSWFTT18Uph76aL5jOTo/3taLTKmvIE6fxpqUTWlcIpbD7RvYSHvc1NJq2PY1R3eIr36BPgODGsRAHJHwhyS054m0gDSiOgqMfpc+iPiqbGgTvTDMiVMryZw4PqNxGNNTtgxp/v46gefy7KooT9LqwB0LMsMFqztsQMBCQT+orMnicHBLI
 lI1eou/x
 iafEyMEuBkXXEce0qtm5xkZxsCemQHtfnz6nV0bGN0jq4+392Pu5cjYs94kSIclqRbUqt6jm28O6892fyrTS6HQ7ob4aQAq+yhzXFGYlPBRHupmYr9/lAO3ipvIlKU5tHIZXyfJi+pcAFO06bPqHNJOZjZhtOTq3g4P1a1nkBeob0weL8IzKcuDEjhzJ3ghWNblUmkrzynhgqk49DQvnDtCEDOh9gAqJZmZozPOeVVvaWHEkTeAoNiFNWNzSYDG6LQSVL1j2nCXLB/Wo0+8uKA3JyzxkISXncXsYNPNL4PJgs3WIMW4t9uUR4yX25dbsPJgGXAkJc9cJIVHs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

+Cc linux-mm

On Fri, Feb 27, 2026 at 2:26=E2=80=AFPM Dmitry Vyukov <dvyukov@google.com> =
wrote:
>
> On Mon, 16 Feb 2026 at 18:37, Aleksandr Nogikh <nogikh@google.com> wrote:
> >
> > The load_segments() function changes segment registers, invalidating
> > GS base (which KCOV relies on for per-cpu data). When CONFIG_KCOV is
> > enabled, any subsequent instrumented C code call (e.g.
> > native_gdt_invalidate()) begins crashing the kernel in an
> > endless loop.
> >
> > To reproduce the problem, it's sufficient to do kexec on a
> > KCOV-instrumented kernel:
> > $ kexec -l /boot/otherKernel
> > $ kexec -e
> >
> > (additional problems arise when the kernel is booting into a crash
> > kernel)
> >
> > Disabling instrumentation for the individual functions would be too
> > fragile, so let's fix the bug by disabling KCOV instrumentation for
> > the whole machine_kexec_64.c and physaddr.c.
> >
> > The problem is not relevant for 32 bit kernels as CONFIG_KCOV is not
> > supported there.
> >
> > Signed-off-by: Aleksandr Nogikh <nogikh@google.com>
> > Cc: stable@vger.kernel.org
>
> Reviewed-by: Dmitry Vyukov <dvyukov@google.com>
>
> > ---
> >  arch/x86/kernel/Makefile | 4 ++++
> >  arch/x86/mm/Makefile     | 4 ++++
> >  2 files changed, 8 insertions(+)
> >
> > diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
> > index e9aeeeafad173..5703fa6027866 100644
> > --- a/arch/x86/kernel/Makefile
> > +++ b/arch/x86/kernel/Makefile
> > @@ -43,6 +43,10 @@ KCOV_INSTRUMENT_dumpstack_$(BITS).o                 =
 :=3D n
> >  KCOV_INSTRUMENT_unwind_orc.o                           :=3D n
> >  KCOV_INSTRUMENT_unwind_frame.o                         :=3D n
> >  KCOV_INSTRUMENT_unwind_guess.o                         :=3D n
> > +# When a kexec kernel is loaded, calling load_segments() breaks all
> > +# subsequent KCOV instrumentation until new kernel takes control.
> > +# Keep KCOV instrumentation disabled to prevent kernel crashes.
> > +KCOV_INSTRUMENT_machine_kexec_64.o                     :=3D n
> >
> >  CFLAGS_head32.o :=3D -fno-stack-protector
> >  CFLAGS_head64.o :=3D -fno-stack-protector
> > diff --git a/arch/x86/mm/Makefile b/arch/x86/mm/Makefile
> > index 5b9908f13dcfd..a678a38a40266 100644
> > --- a/arch/x86/mm/Makefile
> > +++ b/arch/x86/mm/Makefile
> > @@ -4,6 +4,10 @@ KCOV_INSTRUMENT_tlb.o                  :=3D n
> >  KCOV_INSTRUMENT_mem_encrypt.o          :=3D n
> >  KCOV_INSTRUMENT_mem_encrypt_amd.o      :=3D n
> >  KCOV_INSTRUMENT_pgprot.o               :=3D n
> > +# When a kexec kernel is loaded, calling load_segments() breaks all
> > +# subsequent KCOV instrumentation until new kernel takes control.
> > +# Keep KCOV instrumentation disabled to prevent kernel crashes.
> > +KCOV_INSTRUMENT_physaddr.o             :=3D n
> >
> >  KASAN_SANITIZE_mem_encrypt.o           :=3D n
> >  KASAN_SANITIZE_mem_encrypt_amd.o       :=3D n
> > --
> > 2.53.0.273.g2a3d683680-goog
> >

