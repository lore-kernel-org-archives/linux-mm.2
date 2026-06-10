Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EAC20CD8CB9
	for <linux-mm@archiver.kernel.org>; Wed, 10 Jun 2026 16:00:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 57BE26B0096; Wed, 10 Jun 2026 12:00:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 552FE6B0099; Wed, 10 Jun 2026 12:00:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 469336B009B; Wed, 10 Jun 2026 12:00:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 35E506B0096
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 12:00:20 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id CA16C1201A7
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 16:00:19 +0000 (UTC)
X-FDA: 84864464958.11.BAF7800
Received: from mail-qt1-f169.google.com (mail-qt1-f169.google.com [209.85.160.169])
	by imf05.hostedemail.com (Postfix) with ESMTP id ABE2C100014
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 16:00:17 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Pn9kcXHU;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf05.hostedemail.com: domain of surenb@google.com designates 209.85.160.169 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781107217;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VEDUkC8AXaU4PRdZaXQ1N+8ibbW+O3iaY6lkOQGumLU=;
	b=yzMJD79p6ynDL7SRRuzXzE5gXSSPGoeKHuiWYtH9TR34lE0v9L1ftt7Pv99eK3bD55ZfBS
	lodTU8dGRtSvQ3MoRPbbPX1N/+FGffZwVwJ4cAhnzDzXjefExYgY9nymAXvdxIdHhS9cmI
	FTiZGN+QKAigISV28NXDD7016htn3lk=
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Pn9kcXHU;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf05.hostedemail.com: domain of surenb@google.com designates 209.85.160.169 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1781107217;
	b=eW7Lr8waoFJ7yeIwDxdKEIKnxWiRJId0fpnd8FWOsC2EWYnCw16R1owQ3jV92RQ6ijOYoD
	Otdp54uGw4ZCQ/tnuQyS0uHlbbI1YcbmLSf91Bmd/eFAF+dqoeAj7a1i2OoF0s+aCrm4Io
	vR/9iys7KL4X6pkf3NnDdgZf159sHRI=
Received: by mail-qt1-f169.google.com with SMTP id d75a77b69052e-5177d1ff061so524871cf.1
        for <linux-mm@kvack.org>; Wed, 10 Jun 2026 09:00:17 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781107217; cv=none;
        d=google.com; s=arc-20240605;
        b=bEJI/asq5JrHbkfpGhiLkCVt/uWq2iDB/LrLSBbZFZPDHofcYwGqmhtNWUnP6xjMhA
         4NJ4Pet6jd+xvIB4QaCnbsQUfXGUrCZb9PhC6zhEqlAJvbyQkqDFqIt4No+xPZ0B5EO7
         IaBv7/+JYWifr8pcJAs/Q+paWMNqt3yXqsk+fqZkgyn1c2geOnqamkT2lJGm0L5N7upk
         Oa7wDebveMy7RT+HXLZxPb3mbjlBjMa0C7ewHdBhMr56yEVXvN+INotO3mOgf9Ou/igM
         F6lGeYuMUX1YiXVNTyH/hfMGwxO/ZvZoWbY5rZJr5+DdFKjQ8ntCE+TlvnR00AxkueO6
         NZnw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=VEDUkC8AXaU4PRdZaXQ1N+8ibbW+O3iaY6lkOQGumLU=;
        fh=ZaLG9hswg7Ke3RINj4mzS+/aXw69N5B41f6/MYRLCfo=;
        b=OP89QPs5JIV9FqLxjZzN0Yysgkr/+UeSXua3jxRVkkwaBXmzeJyfrsIs7NztkMAXbv
         fVxgeIMQIsEfAshata/GxrY8EmCv3OL/UxVR+SkoSpj2+OBI54wenCWmaXRB8Ms2vXGb
         Tj2JyPkkcOXnGch6ontNz/7LuIzsJ1+8m/U+gr+rYUoKFD2b3ZCx7vlndzY4yX8FXxb9
         nKJKHChe9J50/3hwvXpwx1UaUl9jVN3F2ANV5cvs6oThYdd8Z+Lzby3IjnCyMNFmE6Fd
         A5KYhb+t0w4Vps7Yjc47KHWg6I+wy8MJ5LWT8bC87RxskAejvyksI61j8LlhsGPL/D3C
         zzlA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781107217; x=1781712017; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VEDUkC8AXaU4PRdZaXQ1N+8ibbW+O3iaY6lkOQGumLU=;
        b=Pn9kcXHUzA47gXdq2ETndw042FYoDi/tCO3qsDyCNjqH18FuD9d2eubyNvNX9HdkWs
         yGzPwVXilkfMYIuceSMcpDV7wbyggZHGJiRCMEkGxi2tgrba1SfGO+U4ASy8PjohO6Lm
         4yUMlvKwfG3RK9LFrhFppVb6K1InHipCfnrO0MV3DCdONL3RfGsUIhUyoE30Z7NR7Z9e
         hwUWASEvHEdwq4+6UNm9MCn053HnZbg8r7ooYj2w4AT73yxB2XNd/C52/Iw7J7qdz+h+
         MmzKi3jQEElKq5K66VcyBqiBQmt2WOjGWWzYeIpdh35j/IeIrUH9yQyZIebwj+O14xI0
         sM7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781107217; x=1781712017;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=VEDUkC8AXaU4PRdZaXQ1N+8ibbW+O3iaY6lkOQGumLU=;
        b=NLuQUZWwKWu5oK6e3ORvSyuzhmUU9jWDvdad0/0KYCYB7Ue0Scpc9b2CkDT+G2I1nU
         y4IyxznDcYqJOt3DnG08jNVFN9CIy8MJTkCPahY6b4akE60LVezEiXaiH56vdJ9LCzFn
         SkQDmzEFobYUUXn7/YzbUsRe3vOJ01IkUAEu1lCUNhWVY5Qy8HJZ3WQsWhD/jbr3EAAi
         diY5U5GQNpbNBM9ezVr331QiDQAgoIShCzCngq8JIQfm87ddRXvRzoRM+xjvacOmGQMJ
         cB6cxLZBc9S3CYR0zH8QCFjEo6wkhGg9p6Gwzj6Zy/QOqj9aKUM7RasegfRw3eVOZ2Gl
         6TzA==
X-Forwarded-Encrypted: i=1; AFNElJ+RDeim7MKtpyYJ5ApsQzOfA+JjbMuMV1oqlMBbywnDF+UbZR+EjRIc9sPIG8eDNVJoXBG0hdYuww==@kvack.org
X-Gm-Message-State: AOJu0Yxvvv/RZHlhTIqIogTwBD6LgOydID0L8mIwA36dp7nt5KILYn3S
	iEEGBIptYIhjFgBTCL1WTY9AyV4RULSuAsx6y8JfS57+YMLb9ZzM8VgzJ87JIALV9UZxAtlMkSc
	Fi20FUJryc6wJ8ARh0Yf3MeU3ARg84fTqobKcYAOA
X-Gm-Gg: Acq92OHhbGuVexTEMFpf2WmozAe16P5nxuCYyfBmcaa7s1j0vtqh/73UhdnU9Y/yP8w
	Zn4e9Kh2X16IG7vJWCZN0UDkjDPw5HDnZNmezsiVOI6KuBKjjpmQTUHunPx/Ke3M4fpmGrCpJP4
	OdW1IYLa3QU4cQpZ2gLN/4cLI3bR7v7W+CRoza/s9WVhr0oZAaywZjVoke5jruKu/WydAm0Dr8V
	/inw27EIlzokRKR3LJCdS4TzeKyFFyUNit/lnCDyBM2kWDF9hknB5E98LtKfrqf5pkABPFohIPM
	5K2g/1Y3gY7YPb0m2anZ6MKlbBO3EZkWQBZYUGjhNUBf0YNs
X-Received: by 2002:a05:622a:4a0c:b0:4ff:bfd9:dd31 with SMTP id
 d75a77b69052e-517e98c90e1mr820931cf.5.1781107215898; Wed, 10 Jun 2026
 09:00:15 -0700 (PDT)
MIME-Version: 1.0
References: <20260606015729.1837935-1-surenb@google.com> <20260606015729.1837935-2-surenb@google.com>
 <aifO_rCurVhFRTcl@lucifer> <CAJuCfpFOpvNmV4aHnk3Vi0Jg4vF4Cmsm86h2vODZ84FVLXt9yw@mail.gmail.com>
 <aikLCwuzqBetvDrf@lucifer> <CAJuCfpHX5zoaD9XxDGbpXHs5U_8OrRyRuk=Nx8CjDb5qMNy0jA@mail.gmail.com>
 <d05e51a6-428a-420e-b6ba-54f94d029f1e@kernel.org>
In-Reply-To: <d05e51a6-428a-420e-b6ba-54f94d029f1e@kernel.org>
From: Suren Baghdasaryan <surenb@google.com>
Date: Wed, 10 Jun 2026 09:00:04 -0700
X-Gm-Features: AVVi8Cf8c2ltD77T6hmJFDSlT2HwjMv7U0PwhT3D91ZCpnXZBbc7zzCdnWOEZWo
Message-ID: <CAJuCfpFwkkeA8e77s-Hm0YdxMJ2Y60vu145pZw7iiXtNoDzTzA@mail.gmail.com>
Subject: Re: [PATCH 2/2] fs/proc/task_mmu: read proc/pid/smaps_rollup under
 per-vma lock
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>, akpm@linux-foundation.org, liam@infradead.org, 
	vbabka@kernel.org, willy@infradead.org, jannh@google.com, paulmck@kernel.org, 
	pfalcato@suse.de, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, Dave Hansen <dave.hansen@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: ABE2C100014
X-Stat-Signature: 81d4zo7sj7umqme5zx6pqogatfr13aja
X-Rspam-User: 
X-HE-Tag: 1781107217-995454
X-HE-Meta: U2FsdGVkX1/Tc/FEW/uuTOOhvm0AOAGaD6hYO6VEv2nTccjhbRJCW2yYJXIvbjtb/8sT6lLFx1HUb2vZ9WP5w9/agQcTgdjRERS/lsYKQfxEoqZkuSla2JqlBowQn2JyGmuBCj1PyuS2wC2eh0K4dA5uTI2vltU6KvAIpDlO6Pgp9G5H67J1bxPDXCC0rtpDjTBmopgL0wbSpekHVZmDdazU8gEGKVGF2VHaavzN7N2NG9394NVmyYmhnsqPcEzdZnyNT0vKJy/B1pYwEmm6LmiUk4BXLDFPX+53CGOQSS2wqxiPxOJxsoZS9Da+UpjQK5ERWAtwOVpIdz85xVGABXBQPS+h0TPZQtpE7RQMzPLOr9jz9s39LAtIqAWYNrPQaH0jdpRVmQEcvcbmRroozlPJyoFVaL4V216vuBZBVrdDyOMCZkWR/yEt5fyLV/e6XaaLjwMALbx01J5dsJn/iwNkVudanOJeK3mfxcrQN1WOtvt8+AXKZwfLIne39U0I5KcYoXPQHcb1jAfW4alXR5r3UesUQOUGq/cQ03K7DgcjClM820aHqn2eD5Gj3LwpSimEy09x+XeKboIoqDPhQBaXlrHHKo9zNABJduMzN5mLqKtYg7hEv4m4z5E6T7GIJwSTqCnD8dqPozYLhyLzHyHs8fww+TI6ZivNPyv3g/rU7kwHP5ccLm5X60H3mr8nPrTVGGRzDrP6p8Okcz6UAwFaflh72M4gI12dAX5zMJQd3qbOWnIfaOyF3q64m4SRtY0yzZwwYem70X60RuGSS8Q1V1+XvHRqbG3/7zH/0HY3b+iLHRKWxFAmmSF/oiLu4+tJPpsU9scLBJDN51fM1p8z/7g6Sf8tCv261z1Qe2hyxOyIbAYGfOjP2nVh4r4+Pb+hNyxjzbJdJ3JN9w/f569PhmFF2ipNBO6+EGXmseT5piyUQ1vmBeR0Ehib5AZ1tN0M1JpIjJ6JNn+SJLt
 l43bkQ12
 pkfNG6frOOxQv8SjYOKjybQqO2ov+4CbKFPUTAjXkIW5QMLy2Fkok0o5F4ql84sgQ9Fi6JhW4g4AQlMAiMd9vbaza2XUtqr+CLUalLavsVn4PfUKOjeGdvvZv9gWmKmMLeESsgwKL0hObv6XJHn0d6Hbqyi0sXDHUmFjgg5MyOL/wucAWIYtYmnaMW8E8XFgib7/v2tse9WnfEJMhsJIzp3uy/P7xgRKXcuiqaE7LKDkoH4r4SFFX4TuyLua+esztu7Su2IS9SpV6Vuwei8QcIsFU3YGjHdzTuoiq1oR0wEM8jKyp8DbwDbFbOEIvawqkY1xKLheCrfgu8VKMqhOOTEq3JtiWpS6KJBDTaJy9OZGP1D1ilwgFsZESIQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jun 10, 2026 at 8:02=E2=80=AFAM David Hildenbrand (Arm)
<david@kernel.org> wrote:
>
> On 6/10/26 16:56, Suren Baghdasaryan wrote:
> > On Wed, Jun 10, 2026 at 12:05=E2=80=AFAM Lorenzo Stoakes <ljs@kernel.or=
g> wrote:
> >>
> >> On Tue, Jun 09, 2026 at 10:11:03AM -0700, Suren Baghdasaryan wrote:
> >>>
> >>> Ack.
> >>>
> >>>
> >>> Ack.
> >>>
> >>>
> >>> Sadly, for now we do (see my later comment).
> >>>
> >>>
> >>> It looked nicer I think :)
> >>
> >> Yeah tbh I think you're right
> >>
> >>>
> >>>
> >>> Ack.
> >>>
> >>>
> >>> We need it to avoid resetting vma_start, which is being reported even
> >>> when no normal VMAs are present.
> >>
> >> Well previously smap_gather_stats() would just be a no-op for a gate V=
MA, as it
> >> has:
> >>
> >>         if (vma =3D=3D get_gate_vma(priv->lock_ctx.mm))
> >>                 return;
> >>
> >> Not sure if you'd have VMAs past that (is that even possible?) but in =
that case
> >> we would have set vma_start previously.
> >
> > I should explain this case in more detail. proc_get_vma() returns a
> > gate VMA once it finds no more VMAs. So, in this case if VMA tree is
> > empty, the first call to proc_get_vma() will return gate VMA. Now, the
> > original code was using vma_next() and would return NULL when the VMA
> > tree is empty and in that case it would bail out early here:
> > https://elixir.bootlin.com/linux/v7.1-rc7/source/fs/proc/task_mmu.c#L14=
23.
> > I need to use proc_get_vma() instead of vma_next() because it works
> > under RCU. So, the new code matches the previous behavior, but the
> > condition is different. I'll see if I can resolve this in a nicer way
> > but that's the gist of it.
>
> I guess some well-named helper that encapsulates the check would already =
help.
> But maybe the whole logic can be overhauled.

I'll see what makes more sense once the cleanups are in. Thanks!

>
> --
> Cheers,
>
> David

