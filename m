Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6D0F6EA4FAE
	for <linux-mm@archiver.kernel.org>; Mon, 23 Feb 2026 12:42:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 90C696B0095; Mon, 23 Feb 2026 07:42:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8BA7A6B0096; Mon, 23 Feb 2026 07:42:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7C6706B0098; Mon, 23 Feb 2026 07:42:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6A4F26B0095
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 07:42:49 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 2408D86BDA
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 12:42:49 +0000 (UTC)
X-FDA: 84475685658.08.599E24B
Received: from mail-oo1-f43.google.com (mail-oo1-f43.google.com [209.85.161.43])
	by imf10.hostedemail.com (Postfix) with ESMTP id EDCF3C000A
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 12:42:46 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=rUK5YEw5;
	spf=pass (imf10.hostedemail.com: domain of nogikh@google.com designates 209.85.161.43 as permitted sender) smtp.mailfrom=nogikh@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771850567;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QwHlGbS3cn9jSgHE96pfHR85LcmhKeNoxRR0LDuTZE8=;
	b=GTncNIZUQ8im8pHlv24N2StWzoJhnVrOtKH8NQ6FD8zejQQpyaEEQ2plwz5J7A7n6LgHlG
	P76/yjByLSb9/8Gw1f0jO3EI+P4v+YGKXcY166DozHVlkSPgI3XTorzJg4bWwOLfZ3Min5
	hAUJ6eKRvKzqmSQUlBgXA3xpl5xOxx4=
ARC-Authentication-Results: i=2;
	imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=rUK5YEw5;
	spf=pass (imf10.hostedemail.com: domain of nogikh@google.com designates 209.85.161.43 as permitted sender) smtp.mailfrom=nogikh@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1771850567; a=rsa-sha256;
	cv=pass;
	b=qjJ3yMfhZamgKNbDDi0eF2MQ6gcs7DJ0xOzbZ4eaw3xDohUOZJF3AxQtkHFYbo2XW14srI
	hGWdb5GoVHbcbWmH5oxmEUxFVgEyjOceiKiNMLjxvxSRcr1G2LEit0qStgapq5eZS5XHI3
	01UwLXWUjeA7o+EmxMGVjVvWyHKKqVo=
Received: by mail-oo1-f43.google.com with SMTP id 006d021491bc7-662fc35291eso2418550eaf.1
        for <linux-mm@kvack.org>; Mon, 23 Feb 2026 04:42:46 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1771850566; cv=none;
        d=google.com; s=arc-20240605;
        b=N1LMv+yu6863S66unD/iBsgamMk/rxE4SnwYPOdLqVAWpp7ENtUDXpL6SDehoKN5Pp
         2FR3sEU7p0DTPvnanch/sevh+DWEd0BMeEPiO8xD+crLZeq3XPeH7zOCDPERFQWHDrwY
         Z6j6/T7uW1dVqcVlunHp/OYZyG4z1UF4wdywAvKLLo/iwEwGp52qLKEKD35dEWGpiydN
         hVqe0ADVP8VHqJt5YrcxbhptTBq6kDKRItRUNKogrFXeC135tJpfLPAGPv7C7LEd8F5c
         CIsjsfDI01OYUbt2v3tKSXUL8SfRVAL6AYSxc6rnGytzpBYQ09A8Tcs7Z+lqDDtjnexH
         /yzw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=QwHlGbS3cn9jSgHE96pfHR85LcmhKeNoxRR0LDuTZE8=;
        fh=AsUaOn0RqGgrXOePh/nIMHafaZ+Ld/yCERoUveTBkwY=;
        b=XlImdHJ2NlalVNUeVLqqujX7yTHgx3HWjGz5kRlnYV4/9bxnFjOorw64Lj9MoRm5vE
         QFjg2mYP7u2e1AfYvWxau5AcsINmvjkj2pzowCvrgi7AzI92K33/NNC2UprhB72F7x8N
         igTCy7RdxjljLB1qeyHQllebWo38T7IAPXCa60mzeXjmyquP+m6InJm1DArjzsWC8RZQ
         61c5Bf1mbxeAupzze/QUxKUAB05dOd67rO+a4ZpMfJ/bRFiE+iKWpFt/AnVmxqbFla97
         m7i5E8whewjDui2/cee6dgdxKBnlIt9zzYLUjETd5B2lABahm6sa68bF/VJpxJ8C6j5s
         /4rw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771850566; x=1772455366; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QwHlGbS3cn9jSgHE96pfHR85LcmhKeNoxRR0LDuTZE8=;
        b=rUK5YEw5zQC1ZmQ2DHh+aZIJMMQL0OqYsp5XiPoZTiRO1ITPuYgPlBn+0Prjeic3YH
         6TCVa2f7iwxfB7F3ukP0loMeNwdJrA2WEgEhas7si4J42ydKKcc69C8nG+8B9SG1BaVp
         JE8srOdRlBRThkrb7kwq/4LZHFkgSTUbaCMqo9Vb4yxLW4W7cuQYn/65Yvq0mIZ4+Ys/
         dZNMk1ZpGwMIigIY6vCUkSie0TTkLO+Q/D/sTRtQmq3SBw0YHW8FqLL3YFL3ypieWxYl
         pshAd2I+x/67HFQneIpaqDgzj5D5+AkuCyyzTWLfZ0UtfJaO3udy6kMeIx08JjisIhEa
         nHdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771850566; x=1772455366;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=QwHlGbS3cn9jSgHE96pfHR85LcmhKeNoxRR0LDuTZE8=;
        b=tFkMfnLD1iQvcDdjKVlZBrvgY1KM4A00QnGrJ20/AbdjLa3Fb1lTzoSwhQnklY91T9
         wHCyXYyJLxglUsmoAap9KGE4yqT/W9PWmWtirph/cnU+LkwOKOs8CJoJyEyOLcwh5pY3
         J93zLEciY0+q/Rf9Q9RRDdNAzMuMQZrzAuneyfvfTDLDzp+5eR42Cv5SyL/9yn8OQh+o
         Ivsm6QbaAHC+48F2RoxWZ20gkptS00bVTTersvjHvHsxS9IUhudN0RGM8N4fHfIlSkpb
         J8LtZ+Y1sxHJBF9zqmMCSt3u2/hr7JnRw0thbvBh3r9mFzkUka8br4QWP47EtJBg4ck9
         x6uQ==
X-Forwarded-Encrypted: i=1; AJvYcCXKiDdC5znH2c03aHE2nlQQPbPJRKh0LwSbeBF8FIDuCNsdkllhw6n0iOcFGfhiEcbOX3Hp9NOGRg==@kvack.org
X-Gm-Message-State: AOJu0YzspQndjl8M/2JGBuF89TJ7JAlB3E71E2EX9TfZYISiHOzq32IK
	8Z+j2d6HwpatO9/AWIRvmzq8hX3cOvscDL0/ltaHg/GWZ/1CqRbELprptraQp1Vqd0flf/T0Lo2
	6QRfH9QruTrbLmCKQeQwuKfpb5mHKzeDTvPPbt/Hn
X-Gm-Gg: AZuq6aImL9IxYYh0itJssU/eiK4xjQHnJRTpvzosPg9uhmuCEgvx4/6sE5s5aH//NQS
	n3cXR8HsAf0nDDN8DcYZ2dQKdsjdI1pxzYgZlF8CtMpDmJ+fEn0BxnFrEYWn8FLlRDcdKD2lWcb
	vqAgxEQtUPM3lIaDUKLcHbg0/f/wT/PCadd0ElAy4RY87bNT8BEr62w9vt30GzmgeycWGe7h4So
	1i453OgiuGxKOZMooRmb5hg9p4QvFTMfDqwcBli9MtqEllIfDLhhRHKH1OW4sa4YV2ySvh3yMN8
	GuTuZ2xnGBQYAP7YShxsq+y06GD+W5KJqvv51mlEn5DtIuQiZw+7hxA1PVCPip+vhEoGJ9YggTM
	xKc2O
X-Received: by 2002:a05:6820:4410:b0:678:7266:8e9d with SMTP id
 006d021491bc7-679c46115b0mr3809769eaf.76.1771850565555; Mon, 23 Feb 2026
 04:42:45 -0800 (PST)
MIME-Version: 1.0
References: <20260216173716.2279847-1-nogikh@google.com>
In-Reply-To: <20260216173716.2279847-1-nogikh@google.com>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Mon, 23 Feb 2026 13:42:33 +0100
X-Gm-Features: AaiRm53XIB_8hrdBUvZtKbbzwwdkFXPuotzr2k9FukKdKsESIA-40mClL6YShhs
Message-ID: <CANp29Y57fyE4H=FZju_AhBkzfeKBPXJKDEumqBKaR+zxKwMYbg@mail.gmail.com>
Subject: Re: [PATCH] x86/kexec: Disable KCOV instrumentation after load_segments()
To: tglx@kernel.org, mingo@redhat.com, bp@alien8.de
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, dvyukov@google.com, 
	kasan-dev@googlegroups.com, stable@vger.kernel.org, 
	syzkaller <syzkaller@googlegroups.com>, linux-mm <linux-mm@kvack.org>, 
	Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: saf549gouiem1s3hrnfosrwtz977ub1z
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Rspamd-Queue-Id: EDCF3C000A
X-HE-Tag: 1771850566-752259
X-HE-Meta: U2FsdGVkX1+9RkakwqJLJUoEGsmD+EK5XkG4ofwcjVKbUShQwBcbiWKMPpF/wdh3P6a71fXlBwPxP+kSwtXDJsuUaD5vWb2XOS5Dj0TzR35lKCECpZj22Jon5cKIvDNUfKrq5P0/uvn1sTjq2wgKA1e/luTnmICtQu8zMQEb8Ur6IBcHcDKPxi2Mm1YU8bfD/pe/74NF2eeS8FRLw1v2SvvDwQ+GWRY7S+GO7kPAl57tY1vt+qYqUUmSOJe4vatt4/zhOIKFt/0T2fOCrnDXNQXH37soWcsttOngLQ/JweTqac1DwxOq2vG5j8J8qP+nWLKI5BHx3DllDYeNvYa66H+ugmYF175duvr+UZf3Lcc5VCiYEvxjZtkUAqr1kiW7VnDNfLSWZLDUK8TnmX6KtEjYiiNXbROP8D0g++C9T4Zzw6sNGZSru/TIVScAU/oOAC9/Sn3qTq07CZW/z4viHVJPco/4lPlOS4kCrxam+fd/byg35xloYhzVPN+TJTRJfolmDdE7yJ79utlCFZLdTfFaz3uh2NAQH38VVvJJx9HftOvinDfR3YdKsrgPjQ2ljMgyFAYYGco8bd4X0KMdvau8ITnEDr95c6xOPcWn60m7pT6mZa0N1fWmw/fop8yepVyfWcMkLurbRjSWqiFPXuh6ryURfLY9gKG6IpbbYGdZyRntQP2WlrE9izzB4xX2hZ3HovR3uR0Kozlv8Yjza0xDbKSzPkY2eIBkMkARs1dBwQRJPuw/1fhkl/2Af7adLd1nlxZc5Qfm1v6vti724xZw6I6INzMp5gbFJgpKoOORR9/SNhJ0M9uJQ9FplYF5MjFEwfcuKz/ByGYZgqgepmfj1SMKtpSVc9xNZvzzrDm6g75ynf48d3LtClcCyqvi3GKji4zszpJJ5tGJASapcu+DUyw8IWYeqcmM9H0DCWCYL96etd2fTQZHJrvbBJ0QAfrbdVboBpCcLEQKNrp
 2+xjXnew
 wwFjTZpuzpI8nOXw8FGWUfFUFz8CYRHN6lEL3fc96N1976ZBkEZfm8Ga+bS6VuIdG0PHDgeQ65HYv+N4MJ3S3eqeyiSsRH5nRirfPapR0Fh18XxUTuI19ahRTqVtf1A3hRA3kpkui3ex40CY7Wm7qpzL7n0QUPWAaKr1uiSFV1/j06kXqSYjfem3zDDswjjdKvSNCBDde0DDlfHgLVo2ZKulmbH4icAqNxwLGCjMCVxXPrkpH5eDjh9So2xBmoVukhKYGFSi0+/Ae68HkdZt0rrqB62uj7XhMroYbgh+kAEdegWtvxiX6dgYoLZQYFZj0DzYhG5HwXaShP4s=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Feb 16, 2026 at 6:37=E2=80=AFPM Aleksandr Nogikh <nogikh@google.com=
> wrote:
>
> The load_segments() function changes segment registers, invalidating
> GS base (which KCOV relies on for per-cpu data). When CONFIG_KCOV is
> enabled, any subsequent instrumented C code call (e.g.
> native_gdt_invalidate()) begins crashing the kernel in an
> endless loop.
>
> To reproduce the problem, it's sufficient to do kexec on a
> KCOV-instrumented kernel:
> $ kexec -l /boot/otherKernel
> $ kexec -e
>
> (additional problems arise when the kernel is booting into a crash
> kernel)
>
> Disabling instrumentation for the individual functions would be too
> fragile, so let's fix the bug by disabling KCOV instrumentation for
> the whole machine_kexec_64.c and physaddr.c.
>
> The problem is not relevant for 32 bit kernels as CONFIG_KCOV is not
> supported there.
>
> Signed-off-by: Aleksandr Nogikh <nogikh@google.com>
> Cc: stable@vger.kernel.org
> ---
>  arch/x86/kernel/Makefile | 4 ++++
>  arch/x86/mm/Makefile     | 4 ++++
>  2 files changed, 8 insertions(+)

A gentle ping on this patch.

Should it go through the x86 tree or the mm tree like other kcov patches?

>
> diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
> index e9aeeeafad173..5703fa6027866 100644
> --- a/arch/x86/kernel/Makefile
> +++ b/arch/x86/kernel/Makefile
> @@ -43,6 +43,10 @@ KCOV_INSTRUMENT_dumpstack_$(BITS).o                  :=
=3D n
>  KCOV_INSTRUMENT_unwind_orc.o                           :=3D n
>  KCOV_INSTRUMENT_unwind_frame.o                         :=3D n
>  KCOV_INSTRUMENT_unwind_guess.o                         :=3D n
> +# When a kexec kernel is loaded, calling load_segments() breaks all
> +# subsequent KCOV instrumentation until new kernel takes control.
> +# Keep KCOV instrumentation disabled to prevent kernel crashes.
> +KCOV_INSTRUMENT_machine_kexec_64.o                     :=3D n
>
>  CFLAGS_head32.o :=3D -fno-stack-protector
>  CFLAGS_head64.o :=3D -fno-stack-protector
> diff --git a/arch/x86/mm/Makefile b/arch/x86/mm/Makefile
> index 5b9908f13dcfd..a678a38a40266 100644
> --- a/arch/x86/mm/Makefile
> +++ b/arch/x86/mm/Makefile
> @@ -4,6 +4,10 @@ KCOV_INSTRUMENT_tlb.o                  :=3D n
>  KCOV_INSTRUMENT_mem_encrypt.o          :=3D n
>  KCOV_INSTRUMENT_mem_encrypt_amd.o      :=3D n
>  KCOV_INSTRUMENT_pgprot.o               :=3D n
> +# When a kexec kernel is loaded, calling load_segments() breaks all
> +# subsequent KCOV instrumentation until new kernel takes control.
> +# Keep KCOV instrumentation disabled to prevent kernel crashes.
> +KCOV_INSTRUMENT_physaddr.o             :=3D n
>
>  KASAN_SANITIZE_mem_encrypt.o           :=3D n
>  KASAN_SANITIZE_mem_encrypt_amd.o       :=3D n
> --
> 2.53.0.273.g2a3d683680-goog
>

