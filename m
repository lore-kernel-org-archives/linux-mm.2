Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 44592E67A79
	for <linux-mm@archiver.kernel.org>; Tue,  3 Mar 2026 07:00:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 615EF6B0005; Tue,  3 Mar 2026 02:00:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5C3C66B0088; Tue,  3 Mar 2026 02:00:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4A5616B0089; Tue,  3 Mar 2026 02:00:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 370446B0005
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 02:00:47 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id CF14B59EE3
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 07:00:46 +0000 (UTC)
X-FDA: 84503854092.03.0AEBBC0
Received: from mail-yx1-f44.google.com (mail-yx1-f44.google.com [74.125.224.44])
	by imf02.hostedemail.com (Postfix) with ESMTP id D0E4280003
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 07:00:44 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=hev-cc.20230601.gappssmtp.com header.s=20230601 header.b=K9bcrcrC;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=none;
	spf=pass (imf02.hostedemail.com: domain of r@hev.cc designates 74.125.224.44 as permitted sender) smtp.mailfrom=r@hev.cc
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772521244;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mdDAqhN3rl5RL2XosH5lbLdupO3Vv/WKtZ8EOPEylcE=;
	b=GxK8VqoIDx6JthzzhdJW1U8j2n/6R8RI4uzqlmTeCQBDZPQwGa5GeU7dF4kalmfXCB8yTr
	/zDy/TST4XivCcM8HrY3r0G3FOyzo/eyLMUYw31/6jMGeyFV0rVl8P8nrv5vEcyZ6wqYyy
	xmKxFidQYmYj2WtKcrY2ksV/ontiLrU=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=hev-cc.20230601.gappssmtp.com header.s=20230601 header.b=K9bcrcrC;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=none;
	spf=pass (imf02.hostedemail.com: domain of r@hev.cc designates 74.125.224.44 as permitted sender) smtp.mailfrom=r@hev.cc
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1772521244; a=rsa-sha256;
	cv=pass;
	b=T10h/ei6sx6u+8H0E1NUSlVjn5vcYBVPZJ4Ip97f02Ha+ZjHAYRPTSvtEZMYsQLwXHslhj
	KiLvpNWwEN6Vy96MBLYfn7vCGh4uuMWZ340ChVMTPqv9DPWfQFz7PKRh1PBXABDKjuedW6
	K6CzYqYQR5sGXgwIlBYfwLDdkXE+YmM=
Received: by mail-yx1-f44.google.com with SMTP id 956f58d0204a3-64ad8435f46so4978806d50.1
        for <linux-mm@kvack.org>; Mon, 02 Mar 2026 23:00:44 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772521244; cv=none;
        d=google.com; s=arc-20240605;
        b=UBqddjoJuVNsxFqDQtcv7T++3D8sKLCqTZ8gxzXJC6RNLNb8b0g6/j/z398tq/Feoy
         tthSpzGdD/gINYohZlsRe66e0wT8GJ4lU4721ScaArM/rYCIPlUg78sOYxjCkABbe+xa
         lL9EvnQjCXN9xTkQvLBvn+PHCJN+0LQEiM/BOX/eVrTuvRs73A7kyc6ZPmnx8PxpdKe2
         ww649GEUbLiQ4hmi8Tsxa4xFGMnCCXOg65aKyvsvv2XlQ5VOh0TT4NcClX5s+ZssPIcm
         bEnPkyB34fOpPglSb6jBr+zxiUPsw5dfAep3qGBSPCLe3iN2MNu74BkXOsocnFzaAYIp
         PX/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=mdDAqhN3rl5RL2XosH5lbLdupO3Vv/WKtZ8EOPEylcE=;
        fh=pKvaLZ7Owpo0BhuqvTdg98HJoWqVT/Fr7lJc4+Mi0AU=;
        b=hpT1Oeiufw4aCvbYiIsfp9RHB3UoxjYhrw7JfMQte4XL/CSk+RNWFOSHIg4MVs+wrY
         SJUxkM5S0PP+PMdhK1PB5GlxXF2qT+caZ8o7JiUU0rGZ1XXLePW3aba21+96J/FeX/39
         2lGJczFcytaqoSlpZGgA07+bzlXfnxsPl6/B6w5cxGF/kE3hNRtITwiWh6wRhd/Tfs7W
         k/d/L/rSyGJg291T+QE9ZUQI325uA36tqg/PrufIplyRGeyzk5m6DcW9ASFXZSNk1Lkt
         EqKg4Ce5r4U3YutAsl9g45TYWHgXXRw3W56vVL/KdvYU3k/hOsk363ldHoi+98FA57U6
         uDmQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=hev-cc.20230601.gappssmtp.com; s=20230601; t=1772521244; x=1773126044; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mdDAqhN3rl5RL2XosH5lbLdupO3Vv/WKtZ8EOPEylcE=;
        b=K9bcrcrCvwJrNDocPMhGI0lYUFXe9S2kTB+B6F/l7JRjKrO8cNTftyi2K+NzCUjxqa
         llpvfGw3yTlpLvUvJOFc2riz4Zz8vIhx7IAYdQ26df+8dpd75Fik8j9qs+XULSwG9PqR
         HaLXs1swNXNi2VKS8wHRgvKGF/fZ8jNsOh0Tw1rXhMGnLWcskwWd0+iRuybJOFCqfx7A
         SMSgDXCMDYW9q7oLtx8pX3fnx8h3x1yDskvsAtujCqmKj8XkrUEPIPdL1huTXy6OSA1r
         IgouXbW3NjAt9ZbJPfUR805xrfLICmcukRzakUEA92xSJ+gQsr4efZarHPlH0DcsZku8
         FuCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772521244; x=1773126044;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=mdDAqhN3rl5RL2XosH5lbLdupO3Vv/WKtZ8EOPEylcE=;
        b=bQF5FRYZhguyLROF3fxOnznM0Ah4o9G8QZztGJolrd2fpNjQ+MVSzQ+FmubTb/tFlT
         KMENFibJla6LtlMn/xNBA/OHmuagy1l6ApuCxGSPNvnLlh9qFFDaDbBTce8QcJokbJUH
         keu0OoYs1zqNXP79Jej/TFywOKUdYA+2maO6mpjcgTJzpeUnEatUMtej7EUb6flmkxzK
         jYx1r0TZTBu9cA9UGSC2C1IAxPZdNrv/BlA3Ca7qEdZ/zoNeLxkJRwBt/vSgFUXEYGS5
         ycw1+ojDZyC6Z37qudZLS4Pl+mIjIiRI59uyKgJQ2OMUNUB/F/fGgcQ0iwV9Ij5rAkcu
         wyMQ==
X-Forwarded-Encrypted: i=1; AJvYcCVBAz5zt69kzoSKhaqsJp4za84T+GFMkldjd0ZkstX1My95axMKi/C31nTWSNNtKSJUCVP5Uk1DVQ==@kvack.org
X-Gm-Message-State: AOJu0YyZ2R6d2qTQ4Vg4xCrwkj6hs83szb7u0OZIM2ZtUq+EFLMXKtyx
	j7YCuhHUMGGw30PnGg7eQvwmjL3dT/6HN1K7jlUeEz/RAB8S7A8goBGQ/0JgvTG3rYrQ9+CtolR
	WJLA4MfQHTpe6Dq8yzlA8QMZNjwEbVTWbJc2Mll7N2A==
X-Gm-Gg: ATEYQzwuDwyXNexBL4BCmprPfP0IcJkQIn9NYkD5x3EmS6a7kPSQMsCgHYJ1pBSZdRV
	wpX0Q67f3luVlaXiEcEM+qOLr7CaxFIZi7jaOTxLnpuHaWfO04LmeeA7Q+ZJx1G6bfuBueBxrTJ
	jQ25aLl0/YSa/FXu/gFIlro4mX1GOVfbf23CiVu8vaVcTZth12TWBqR4Bja2n/VG2gTfm7saG+6
	/h87+TCtEb0acZUVLvVgrKXablme/lFI/Ej0euE0JVnyBYeBMsbQBSy11Z1p9aQlK4rbzqglCAT
	337TlYf6OF7B7QHdfC1+VVNLwYq3DUdmJK2cfCtgnPq4FyoCc6/C
X-Received: by 2002:a53:d888:0:b0:64a:edf2:e769 with SMTP id
 956f58d0204a3-64cc2080baemr9787968d50.10.1772521243655; Mon, 02 Mar 2026
 23:00:43 -0800 (PST)
MIME-Version: 1.0
References: <20260302155046.286650-1-r@hev.cc> <aaW-x-HVQpSuPRA1@casper.infradead.org>
 <CAHirt9j-appZ+Mn=8AoG=SW3Lrqi2ajdZDGp8yYWiBWkzBbQ9g@mail.gmail.com> <aaZyg0GT4_f52UEr@casper.infradead.org>
In-Reply-To: <aaZyg0GT4_f52UEr@casper.infradead.org>
From: hev <r@hev.cc>
Date: Tue, 3 Mar 2026 15:00:31 +0800
X-Gm-Features: AaiRm52m82PzF35zggyHMFL96K9Z2hLwy17XjN4QOrmMazJ6hfUaYOxSxnYbtkI
Message-ID: <CAHirt9ikm_n1KHtOSBcUpBM3nNRX90AZhr1K0PaLZuL-8ww97g@mail.gmail.com>
Subject: Re: [RFC PATCH] binfmt_elf: Align eligible read-only PT_LOAD segments
 to PMD_SIZE for THP
To: Matthew Wilcox <willy@infradead.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	Kees Cook <kees@kernel.org>, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: D0E4280003
X-Stat-Signature: 6tw51tzf37tdzxgfoqj8hcdu5nmqsnj5
X-Rspam-User: 
X-HE-Tag: 1772521244-116446
X-HE-Meta: U2FsdGVkX19dv6ZPGFCXKnEWj5loaBUe6DRvZJ8t1Ihxaac+4JLAGm4DrvXiZJfAAJcxsAsKK4jMMgtbEkgFe72CXwOELirXMgaTVkR0bFnffW5D7lDe4ZFe+SPcY4IRHjjp8CLkMn81N8wVYw8DQw3QQ4poP5luoE94HTZEwNpxLH047QFzXCybw0627uQ6yVhIaf4UFuO1ezNMgp+uxcQUPc/8yB83mND5z3DCc2MCRdE2kp2A57BrBWnAboZP054uGjMS/t0y0C3ivo70UxXid28fWGOvEO8F0rAw//7BZRi6ZNoLJUCs3sN4wceQYpCnDFeye/fBEOj4ChjFI1vC44WuGqg02LDZJP2oDw3GiDJRsQRfeGnK6NnRiKO62rQAQvbsjZNskdXO8EneJXhxHoRCZrsabYDKWgXEUWfE4uIew7Wa+pqcY0AXcq+XztaGc9KxIgpEPp0KDKNbcq1Amx1LG+xz4nvVxMace/3OpK9uuLMIVvL/QRJqBz1XM82/7CeYkQbCm1ni8iDIx7HH2pfySMTE6XkJNF/4t+rez6JZaPi2xt4SFfdse+3aTmHxH+rfv0Ko64IxErpXSUPee1/5YZtQ+vZJSyRWnWN/gu4Gylyig9I4RgcEz9fPpxkMIzemC1Bp0eu1RVoe5WyIA99eITOj4DK7RtyJtOPc3xUYAlqwCGSwznN35tFtgE6ZyqlLPsUd3KgCoRUsRvjjBqCiBNV+CLSDT251kcNoi8ZsN/sagR9L7Af682F5Zawna5bHB9LKeWRY1y8pARF17M5obHo//EOS7AWR0cx5alsFRLwjCSoLPxSxzVz1WKdS6bPH9slXrCMDF69kseLPeku7vOc0M8p6nhvEf3+Fr6dns9pdII2enBDhmDCkT+wyhq2wKIiVWbV8Rg5jl5sAkt/fcz2o69CniYFtYq6hTe5JmaN+mlB0iknEE8QfabVHHCjIqyaZp7diKNb
 xzIGaf4t
 +WWAiN7maU4tFjc1vdl9lEc3Y8RwBVa9vtgTUUaXrWqyfJxIkl1Yo+zAbclq07y9h81KAt9mPMe4UYQxvy/1LGUVUiUzAeCs6JVMKNxKAF6NanhAdrXsEjBg0tKyM7mSeFoMpTm8Qi+T6/LWCNp3KMOoKxMNOm4JwKNHcqOc94IjEbUchPliRYbZDDBpixFTD9xobGVaaIQNFDlj8Kfi/8jc3FFYz/0kRp//tzaEAtPsmqqaYR4lVCvJUAopaJU6q4N63wyugkjKb8YcNPlPoJ2tzRStN257G69uSmODYutEjJ0hEC32R2bi5NylxgZj/M9oNRuRS0LzF8cF2LTCAyxF8sGGb9JrvXz1iwXgooGonEDTgWXKPZ7u1x+B+IinNNmeXzFVkRjrSXZiocM+/zah2vpZQh6fycwIVITaeL12Wy8prRPWUb25+1slkW9uyoVUXV2dtWE56H8Bf3K3fGSJd6r+WZlesWIpILx9PIEl8a92cMbkp0EqHZA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 3, 2026 at 1:32=E2=80=AFPM Matthew Wilcox <willy@infradead.org>=
 wrote:
>
> On Tue, Mar 03, 2026 at 12:31:59PM +0800, hev wrote:
> > On Tue, Mar 3, 2026 at 12:46=E2=80=AFAM Matthew Wilcox <willy@infradead=
.org> wrote:
> > >
> > > On Mon, Mar 02, 2026 at 11:50:46PM +0800, WANG Rui wrote:
> > > > +config ELF_RO_LOAD_THP_ALIGNMENT
> > > > +     bool "Align read-only ELF load segments for THP (EXPERIMENTAL=
)"
> > > > +     depends on READ_ONLY_THP_FOR_FS
> > >
> > > This doesn't deserve a config option.
> >
> > This optimization is not entirely free. Increasing PT_LOAD alignment
> > can waste virtual address space, which is especially significant on
> > 32-bit systems, and it also reduces ASLR entropy by limiting the
> > number of possible load addresses.
> >
> > In addition, coarser alignment may have secondary microarchitectural
> > effects (eg. on indirect branch prediction), depending on the
> > workload. Because this change affects address space layout and
> > security-related properties, providing users with a way to opt out is
> > reasonable, rather than making it completely unconditional. This
> > behavior fits naturally under READ_ONLY_THP_FOR_FS.
>
> This isn't reasonable at all.  You're asking distro maintainers to make
> a decision they have insufficient information to make.  Almost none of
> our users compile their own kernels, and frankly those that do don't have
> enough information to make an informed decision about which way to choose=
.
>
> So if we're going to have a way to opt in/out, it needs to be something
> different.  Maybe a heuristic based on size of text segment?  Maybe an
> ELF flag?  But then, if we're going to modify the binary, why not just
> set p_align and then we don't need this patch at all?

I agree that a compile-time config is not a good fit here, and I=E2=80=99m
fine with dropping it in v2.

Relying on ELF-side changes is problematic. Increasing p_align in the
linker inflates file size due to extra padding, and more importantly
it cannot help existing binaries. The loader is therefore the only
place where this can be done without ABI changes or file size
regressions.

The logic here is deliberately strict rather than heuristic: the
segment must be read-only, at least PMD_SIZE in length, and PMD_SIZE
is capped at 32MB to avoid pathological address space waste. If these
conditions are not met, the layout is unchanged.

I don=E2=80=99t see a reliable way to make a smarter decision at load time
without workload knowledge. With READ_ONLY_THP_FOR_FS already limiting
the scope and the THP policy applied at runtime, this keeps the
behavior constrained.

Thanks,
Rui

