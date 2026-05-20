Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 28B32CD4F3D
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 14:31:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8E5336B008C; Wed, 20 May 2026 10:31:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 895DC6B0092; Wed, 20 May 2026 10:31:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7AC196B0095; Wed, 20 May 2026 10:31:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6AC296B008C
	for <linux-mm@kvack.org>; Wed, 20 May 2026 10:31:44 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1629D4032C
	for <linux-mm@kvack.org>; Wed, 20 May 2026 14:31:44 +0000 (UTC)
X-FDA: 84788036928.26.7A049FB
Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	by imf20.hostedemail.com (Postfix) with ESMTP id 138481C0003
	for <linux-mm@kvack.org>; Wed, 20 May 2026 14:31:41 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=SWNTQqYU;
	spf=pass (imf20.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.221.54 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779287502;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=l+wF22bF5EmTZVPtYuYx3YYi/+1MmDMRoeQxqbotBDA=;
	b=dB3IY8OXzO3TxLnbsizmQHTTcineY1QYNWF0oDRTTT/4odAZxGq66ZqC4s+MahSWQt9pyr
	4qKs8VH3MrOr1vH/On3/CbYyCR0iCNQmAzWt7uc6FbgkZ6LDnTZm2dOCM9cT2u8tPd4LNL
	a5Nn5Xxu2R+bBEDl8P2zspJVHSzWJyY=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1779287502; a=rsa-sha256;
	cv=pass;
	b=GcQgnD/vx9EEbvyVJcGg8tqiDMTVJk64qpK7Fop+GYDjnRjeGa32r4T2BSLGareKKXRyJv
	IhIya52n0KjqKzEGChbdupQYqY8jN9KhHthfilUOGR4EuPT3GY3sK9EPmO81IHtvqGZmSH
	zkoh0U5qlv8NI/1fdX88schD6QYhAuk=
ARC-Authentication-Results: i=2;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=SWNTQqYU;
	spf=pass (imf20.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.221.54 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-4585a116a4aso4122974f8f.3
        for <linux-mm@kvack.org>; Wed, 20 May 2026 07:31:41 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779287500; cv=none;
        d=google.com; s=arc-20240605;
        b=XPP23c0fnm1AwYmWP++1EBnER2y5dmg8mNfy2w4W/aCvLEcRuYahDPCB2vkxlhUEuG
         JSMWtmoHlNVZWjpthW6aAxdwbq21Vc52qrO+GBiGq9emV82fN6YPuHd9YK7I62dGuxWN
         2Z0r0pigj7RItqgnM6hsLhW0LtvPs09uZUkijt+82rDm2YqLBaQCcwZip1XfZ6dFxhSu
         yt98zSqXN5xrNlR7FkRvf1+bPdkrjxL3bPvgaUR0gg4u4RM4bP7+kz9NUuT43p08Csky
         yKeE6RlrGH8QN9CzkYjCEWJME3dIJp7vWyFp5TP7AldMHrXASxb7cEav1mYYpIpInN21
         xO4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=l+wF22bF5EmTZVPtYuYx3YYi/+1MmDMRoeQxqbotBDA=;
        fh=dsP0CXykRqLQwI+DL4VTGk1kj26iVUPyCLGPIaBFQqk=;
        b=ExSbvvPjetFfJOCPvyge+KcGhIuhad/jx18vRR8sXJXhpFytpi3jM7lOW+zGRhBW4S
         kY47pK449C6uSxlCm5jUuHDPO276KnSks4CmjtBD9+gQX3UzIZI2wQEHQdHRbAUwD8te
         +ES+VeZrbU5doWCcjW52NUiD4Lp31M7EcQHnCqgHfXZvZFPaYuEkB/EfrJFZ+L0UDUi7
         EujXpjVDbORPezk/kYoHp0z23vurkRh1B3f0y9t8r4vErTTbFoa4VORQmLC7RnE7aI6j
         QPddUy2Z5NYiJL8OC6S8NeV+XkNgzxRgMwuIsywglEoA+ab93jnIl/0U2l93jlirWwAz
         BeFQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779287500; x=1779892300; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=l+wF22bF5EmTZVPtYuYx3YYi/+1MmDMRoeQxqbotBDA=;
        b=SWNTQqYUBLQZJ+h0DjvHZSGRdkd3xeEiQ804qIYQAAP2zx9/CDPRnQPBrzyxg2REEg
         REP+WpgVG+Rbf4nxqZgJCfaopRF+jkzwlbhUoTYKGRkB8Cs98frmkWoYXieKb3cV8Xba
         kg9PgDmILkajjDLA1OjEtaiXvYs5yJReMQEqFBEK3tPYpM8mju0hzGM7vdOM+wNwCNv4
         GUfEOaTEnTjX2gvcmeWpwYaIyjUWkkfTKF9QcoTzh1tzI4jXjmIKDK0xt1KOqGTOBfQa
         d4Q2UKeoqu96GRhOZY8FIwIzPal23GHLQ/BN+SFvFtDhJ7/1ffyfbhB+1CDRZ3dE6A7d
         xuZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779287500; x=1779892300;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=l+wF22bF5EmTZVPtYuYx3YYi/+1MmDMRoeQxqbotBDA=;
        b=R55epRs5HakqoaBf2fc1jfTfXYtYz+/neeY1HMLan3gDipElTAuCGeA6+DRvrTbRqB
         /ta+T0Mu2mMJkYUeCn190LoXyGmfuUNtfOjcpDpRrwzKYd/1lJlSJeshUqzdtXV+bAKm
         DknkAiioAinB1+zvf45SV72WV25MP1cRESOdDOR3GJLzMAzXT0lSc6ofItkZXEaTaUgt
         OTynznZVzwBMeR219XvbeXw3AOwbdsn0lzWhlH8SZoc6Jh13Zx8Tbb3Rd5VKriqmNOL2
         VYfJtbQXt4SLG1LaSOTjunpFhUG3eM0CCHREHud+uqZY99IdhjcVrvvjVaTPM1xCJUwB
         c2qw==
X-Forwarded-Encrypted: i=1; AFNElJ/wAlxgvuMozeO7CD2K4tPC9TQemQKY5iYSUNxzLfQfd+61HGHTLP/edubmHnixj/nnF9t34NP+wg==@kvack.org
X-Gm-Message-State: AOJu0YyZqvnQaSTliejWxp0G63vVgfGdzAaa9InvuG2LjsDPe1PE0hms
	TsUODJJdD2Su9P7WlJZXO/YJ+KcYitOOTfDa9T15JKAcJQ8fOyXhw/XSX4+io16jHdqKSkJBcbS
	VPYon49jaUkcnTGmXXP0CezQ1tiziLC0=
X-Gm-Gg: Acq92OEgV+ni2rSYx2kO3EsttSATv5dkOJzJ4W8+u2VgOzFrvfFIDoAKRhv2Lj/IhIe
	FvABoS5mjeHL/HoAnEuBbT5fFhpVKUnQRHLYer6w2MGANiJ4btoo4JmjIKKo0LjUp1pNAD7Lkjn
	FarEbR6Fzh2b5XgNZ4YsPL7wOk7lTFBPO+BcdnmdANEHW2Qls4aNRJeVB39E/U69UBiN3i3UiU5
	UmwdZGEk2np/KKogy6Kr7gUhzmKVAlmhd2Rl6XoVONwnuMo11797gLzrNBcUU+c35BA9et5vm6J
	8Tp/EQlv+ELWJAutT2ToF8D9EHPTpJqEPx2A1ftakHeRqCsUqaWhriOsIREb2XQnSToPh2AT0Pj
	OxWA=
X-Received: by 2002:a05:6000:2489:b0:441:36b7:725f with SMTP id
 ffacd0b85a97d-45e5c57d4c7mr39111981f8f.5.1779287500133; Wed, 20 May 2026
 07:31:40 -0700 (PDT)
MIME-Version: 1.0
References: <20260517211232.1670594-1-tj@kernel.org> <20260517211232.1670594-2-tj@kernel.org>
 <9ba50fd2-077e-4291-9276-9adb18186873@kernel.org> <agtuPrgIDNKSu2Oo@slm.duckdns.org>
 <2f02d90d-cdc9-48ef-abe3-99e00f22595f@kernel.org> <297658c4ae2d6e7103f5968efc936224@kernel.org>
 <04b03066-86d3-4c0b-b077-307fd0f3bc9c@kernel.org> <5590fd3d-dae1-4070-b52f-bc40982ac678@kernel.org>
 <agyZxmHoueGwBAQg@slm.duckdns.org> <CAADnVQJt0p7hSn2G074QZRh2LEdthy3RKYJ9j3w5yeJ-e8UQLw@mail.gmail.com>
 <fb889bfc-af0e-491e-a69f-38c2abf88d22@kernel.org>
In-Reply-To: <fb889bfc-af0e-491e-a69f-38c2abf88d22@kernel.org>
From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date: Wed, 20 May 2026 07:31:28 -0700
X-Gm-Features: AVHnY4Jfl2x_h-7nV11QrGsQRKElNx9baYm9fCq6a9rlTD86qFRr9_qH0Fp83GM
Message-ID: <CAADnVQ+j4o0Xy+cykSdx9txSqCouy0yHFaA09qTJp3OVF3VaRA@mail.gmail.com>
Subject: Re: [PATCH 1/8] mm: Add ptep_try_install() for lockless empty-slot installs
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Tejun Heo <tj@kernel.org>, David Vernet <void@manifault.com>, Andrea Righi <arighi@nvidia.com>, 
	Changwoo Min <changwoo@igalia.com>, Alexei Starovoitov <ast@kernel.org>, 
	Andrii Nakryiko <andrii@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, 
	Martin KaFai Lau <martin.lau@linux.dev>, Kumar Kartikeya Dwivedi <memxor@gmail.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Mike Rapoport <rppt@kernel.org>, Emil Tsalapatis <emil@etsalapatis.com>, sched-ext@lists.linux.dev, 
	bpf <bpf@vger.kernel.org>, X86 ML <x86@kernel.org>, 
	linux-arm-kernel <linux-arm-kernel@lists.infradead.org>, linux-mm <linux-mm@kvack.org>, 
	LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 138481C0003
X-Stat-Signature: xf4t1w3tauss7pw4oordx9a9hmfg1fyy
X-Rspam-User: 
X-HE-Tag: 1779287501-69809
X-HE-Meta: U2FsdGVkX18lbkBzSAe6PxhiM8mMyu0KU6Z8Npv+nbSC5SlFo4VRpuOLdhHnO3W8bvLtj9kyTi87RebRj8x9C4Q3ACMRqbJughC/5mpiZDYDqXeEHoma1b+WIRIO6gR1MSI/Lw9h8nQuGwlwN66sRwKat0/oL1N04d5EMLrocHi28vCxzCk6Sm7g/24hpSSnCwWdYDbfadoElQPh+Ltc8VI0A65tIoU3NXXINrID/Grn0utPrt331aZucLuFAu+Jh4l6ZaIfFe4e+h20TgG7QjScLe7Kt0+5EziQml5Awdu29jvyVZ/H+vAdWfcoLLj7LHqH7JfgJpRbNfJtV4frx+l/6hADoziaR6jlV6l18OwomzjW/SpqyZPje5EGAQr6YJEwCx4o4H+KN8iPltm2q4SKpMJIiAwdGm+odctDJGYItpUIPQcFQG71sVvKb4XE7kE58ZP035hIJstmyLFGplKZJBjjTw9melT9hY+GADdXavsf+7YzRAodTS5P3dTl1EcpBSGV92U8vGeSF6JK2eQno7kysXRWBdB8FkJ5hq4tn4cJdbLBZcy5660e2FHKVziBMpqOsMq5N1nACywer3Kkjzpxw0gnkn5tBR2+OPcczkQ/82anwixjvnZpb5iEtKzVIHTIOkRWr6MlX88exgvH9XdIw9uDlpLLIs/ZKWgQEruDifvn7suByNF2GGBDdT0fMr+ULDGkzk5j/fLRW1h5Ffggtbkt71l06i7ijBpgx/4IU5Ggk+J23N9Huv6G8j4mCSe/ByffBWNW07BCik3sywZ0iohHCkNL8hW9cusP6gl+MAVSiHWxJsyXdfFLcc6TdfY0Ya1cXejj3XojiWPcQ8a+gZrOYf47SDTURnXlIsQPvJh3hSVh1sGaeOvtf+kmbJ12Avt7+8fTzVXBDq5coC5lvrkx47p8N3/9uMu39OEqOFI726LGC0EpAM52xluDcGbtCUBvC/ZM/Pe
 GlelxpER
 qNJscrR/Gj3JnQlJHn7+GTr4UBOfZ1in458FfYzXklHfow/TRY1yDZNn+fMlzg4P76LFQjo1oJLY/lxtnniKgRJplS+PwYOh0XElMMKeJtBWi0UD/MJ0gtFaOvPe75wnu589GDVmAgsR74eDKUtMg6yRv4zSMyYoKqDSr2SxygWj/fW8SVAIRhBIU8h5xXS/9yszFTP4PMQBeeFUjpVVQVdtvkmY5XxFHhefGFlBOHrMLp4pnI8KmwScLK1Kvuyb1mKZYs8l6cC1h/xcLx3stkOUxb5p3iIAmAABCIgSZO0WOvkx8zz8vHukJx5jfzsc4tIyuvUqAYdfSaVmtqT1dJ9t+ph9JadVYxBAkXyKIonRc+QFwpg0Kc+CSAz6EbEgnpUEiFo8cpuP5rjAg1NCJBo6R5jUmpSyQxz/UZQ9W0E7j15pGTKVzMphls2FxRtS4/4tfj1fL5gKJfx/YaoJy2RD/gmb6sbFX6dokNFGuo00FF4PjRhIj7W2mFg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, May 20, 2026 at 10:41=E2=80=AFAM David Hildenbrand (Arm)
<david@kernel.org> wrote:
>
> On 5/19/26 21:04, Alexei Starovoitov wrote:
> > On Tue, May 19, 2026 at 10:11=E2=80=AFAM Tejun Heo <tj@kernel.org> wrot=
e:
> >>
> >> On Tue, May 19, 2026 at 11:40:48AM +0200, David Hildenbrand (Arm) wrot=
e:
> >> ...
> >>
> >> Wouldn't it still be either or with both cases being okay?
> >>
> >>>
> >>> ... or can we run into similar problems with kprobes? (I am obviously=
 no bpf
> >>> expert ...)
> >>
> >> Yeah, I mean, that was just the first TP I found scanning the code. An=
y
> >> kprobes or other TPs in the path would behave the same.
> >>
> >> When this fault triggers, the BPF program has already malfunctioned, s=
o it's
> >> not going to be a high frequency path and performance isn't a primary
> >> consideration. So, anything that can ensure that the kernel doesn't cr=
ash or
> >> lock up would be fine. Any better ideas?
> >
> > As you guys already figured out the trylock is not an option.
>
> And that should be carefully documented.

+1

>
> At least in apply_range_clear_cb() one could similarly switch to
> ptep_try_install() to at least have both these paths handle races in a
> reasonable way. (having to handle when ptep_try_install() is not really i=
mplemented)

You mean to use ptep_get_and_clear() ?
Makes sense to me.

Also noticed bogus defensive check there that should be removed:
+ if (unlikely(!d))
+   return 0;


> Anyhow, the documentation of ptep_try_install() must clearly spell out th=
at this
> must be used very carefully, and only in special kernel page tables, neve=
r user
> page tables. There are likely other scenarios we should document (caller =
must
> prevent concurrent page table teardown somehow, and must be prepared to h=
andle
> races if other code is not using atomics).
>
> To highlight that, we should likely consider adding a "kernel" in the nam=
e, like
> "ptep_try_install_kernel()".
>
> I am also not sure if "install" is the right terminology and whether it s=
hould
> instead be "ptep_try_set()". (set_pte_at is the non-atomic interface righ=
t now)

I suggested using the ptep_try_set() name too :)

> Further note that last time I talked to Linus about arch helpers, he pref=
erred
>
> #define ptep_try_install ptep_try_install
>
> over __HAVE_ARCH_PTEP_TRY_INSTALL

ok.
I guess __HAVE_ARCH_PTEP_GET_AND_CLEAR is legacy ?

