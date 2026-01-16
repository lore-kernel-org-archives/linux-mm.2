Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3B16CC982DE
	for <linux-mm@archiver.kernel.org>; Fri, 16 Jan 2026 16:58:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9F3BA6B008C; Fri, 16 Jan 2026 11:58:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9B4FB6B0092; Fri, 16 Jan 2026 11:58:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8B7106B0093; Fri, 16 Jan 2026 11:58:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 7DA2E6B008C
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 11:58:22 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 250651396A7
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 16:58:22 +0000 (UTC)
X-FDA: 84338435244.01.D31F1FF
Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com [209.85.160.175])
	by imf18.hostedemail.com (Postfix) with ESMTP id 139921C0005
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 16:58:19 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=cZBlIhDC;
	spf=pass (imf18.hostedemail.com: domain of surenb@google.com designates 209.85.160.175 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768582700;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UaTAsxPYTCPWjwQ4mQCkSgV5i6jSjH4fHwMIaU55o8I=;
	b=8rDfI9nKVye7kJRhqhKE6aaPrnsFjp8bY3hHoQHKZ2MoVnhbkw4cz6yM2rTziEndwpT+qH
	nGRVw8lsRKoOfVvyuINShGl4O9WEm0xwc7A/kaaGIMHYHenTeJ4awS1+8BmJdYRc+iJhel
	rNLhejNP6zw4zmDllqr8k1tKSkmH59E=
ARC-Authentication-Results: i=2;
	imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=cZBlIhDC;
	spf=pass (imf18.hostedemail.com: domain of surenb@google.com designates 209.85.160.175 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768582700; a=rsa-sha256;
	cv=pass;
	b=8EVWEJbxcm8EJnxQeUJ8qXYowv9hTsTkdNPS+EvXV/Gs2EMSmz4AyV/N0Vs5dsfu2e8gTT
	khoezlb431XGW3YeFDF3RhSmNI14d91eY4/+uaT4FnuMFBlAtq22iSN6AHnuXJEAsysRLX
	9UuYRr3a1yvVDw6awqA0ZI9QyxPNbpA=
Received: by mail-qt1-f175.google.com with SMTP id d75a77b69052e-501511aa012so497071cf.0
        for <linux-mm@kvack.org>; Fri, 16 Jan 2026 08:58:19 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1768582699; cv=none;
        d=google.com; s=arc-20240605;
        b=EjwbGj2N6Oc/VxFSMMbpqsxHBhx7J+1tlfVXZJUIt3daZkgAaSFNV94+2PsqXhYFr6
         qM3TJ1Ph8HAYDttuuDg7fYC8UhF5g9e0tikgBRtLPcLxbef0J4hvrDAdkNn6lyR+8Oi7
         b3ZM/V07swRlr+ioC/ren7Lhc7uQVlhNFnfJurs28iXs3MU96LytDHap1eZASq1tAEqE
         dCHiiDxsKXecElE860EiK+2HqxlSvCnGF0hdXVw+wTJOMIQF2YtpC52hV/mjovTCBofx
         tTc/unp4rmxIOKS0Luggx7mL/qhdbDvSQUEAiBotq9XMUzi1ABUMA4UmBbYqPfwOEOG6
         lDWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=UaTAsxPYTCPWjwQ4mQCkSgV5i6jSjH4fHwMIaU55o8I=;
        fh=3Dia4SiSx09sAf2uv5hmZWqpxehqzhKiDiMKv+s5w1Y=;
        b=Jtm0lKn1/IJW9cn1zi7eHLcgTWdVtCwSmpQTGSSpS5seF9NReF7yr/3kEa1Kh151HH
         moQi0cyyJd52uSGl/19eKb83RJxWOPsy9FGmQV+7VKyHr1esw2vFULCyABV+JzI3QBXI
         SSikICv/IKiW9QfA/psEDD62/CVRJVyvoRHWKEpKjSjm9KuejkKJYy5Srq4SFpgzixsX
         VA/Bi6RlSmDA+TD1F4EWew5v7uVP0+ekO1z4uzHWLH4oYFV8hfAcJWvTd8YHRLBilHWc
         ez1ZbRFnqpIw8/2KLJQeodSpbgJMgEHsSTkGoI9TcmAyvl1u+XODXzjqIcpa9XfMWD5v
         HWCg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768582699; x=1769187499; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UaTAsxPYTCPWjwQ4mQCkSgV5i6jSjH4fHwMIaU55o8I=;
        b=cZBlIhDCiwm25KBp7wy+rYeKXIPBKHngu7WzZdnnExVPBn6mwGSIFNJwln8ZGQfQbJ
         3wsyQFKNs5GGQElT4cB1pnEoPq5Uu9ZRdKx5RjWt/zbbDLrjXd7sv6XgsPlu8dbhA8m7
         7OZJ2W5IYxwQo5TZybj1C3aVeoPeNZenX3qyqv6wko9dsSKAL7Z5L13xiM7Eda8fZR+o
         XnEL9TLQ3KfFnefJZr0wYvQVe+zuXCQu+i0+JU2fEyxi3CAXLddzRsVtgn02uQdptpa2
         CL//Owm/7pcxyuQnyqNRSIf8xziHxnqoOVBL33LnBMk5PuP2eFm5hYCo8OXYZocgQaaO
         9q0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768582699; x=1769187499;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=UaTAsxPYTCPWjwQ4mQCkSgV5i6jSjH4fHwMIaU55o8I=;
        b=CaUTGKae1BIg0Wxe37CezVL57dBjcB7Xa17S5QefBqqo9h2Uhecn2eK0T2iBygcO1K
         vF+rLBGi0zOI3b6/Ml0ABs286RWGbYWgOkMNk+sH33UlS8UZ04kwNZ9EOAFpeVQ8VKVV
         zVh4mKzw0WQMb4LS40Ym4cS8NmGabtabd1PBvvRrD7iF7KAH5u9bZmKoFX8P1/7ECb38
         2cdZUmKe11Kwtk1E4+I18AwqbChk6Mo3t5HgK3C4qH1XZbw1tsDcefdH/JCVkK+kqNqi
         BiWteMw3X+NKk5RjvqEtpvg797Gt+UZbxsYxWa3ZhQHJQNXKR6NQA0Tzs7KQKWYVM8HV
         FNNg==
X-Forwarded-Encrypted: i=1; AJvYcCUvfzcQh5zSUHx3HQ8hpP4kNnVijV5hIP79gVgHMosur4V9EPdNfuSB+4Cpq7j88ittwikc9yEg3g==@kvack.org
X-Gm-Message-State: AOJu0YxKs+jQ0c8Iocm8uCJ6SqoBbkkMqa39bh13PBKYBovTeTnD/mZX
	nqlJ8tJHLe9qQHjk272OqR+8/DvEd0xzyX0AF8BwhneZKEu8ze8Pi0pky4pS5eQrJhFp++Dp4lW
	92LjqZ+Amca73RHOunhY9tchdjXQA3Tv/tb+Hd860
X-Gm-Gg: AY/fxX66FlFrxoQD8COAOOulbDwYzPJNBep3EuVwoeTpCXuseor+hC+TrdMFgG1pmwy
	XfmB2KEYrI00cy06MuKZiGv+LChNCgdsOV5mQ1hjfMWebnDGJCMFLuKWr9sYfUapY4DJ39jmITj
	Zn3Tr+lNchEVhnUjv4GxxLKA0hsTr8G2wPlOQUeE6ccnGHplBkwvSfJfyLQq9tvmMyoDNYJc4ch
	4S3JAkqqL37dqIA3EH8nzDg8LyJqYxkIkw7c0sYthTFGIpsoUGgRdKKhItn+Rjx590oVQ==
X-Received: by 2002:a05:622a:4c6:b0:4f1:9c3f:2845 with SMTP id
 d75a77b69052e-502a36feeefmr9677951cf.9.1768582698713; Fri, 16 Jan 2026
 08:58:18 -0800 (PST)
MIME-Version: 1.0
References: <20260112-sheaves-for-all-v2-0-98225cfb50cf@suse.cz>
 <20260112-sheaves-for-all-v2-3-98225cfb50cf@suse.cz> <CAJuCfpHowLbqn7ex1COBTZBchhWFy=C3sgD0Uo=J-nKX+NYBvA@mail.gmail.com>
 <4e73da60-b58d-40bd-86ed-a0243967017b@suse.cz>
In-Reply-To: <4e73da60-b58d-40bd-86ed-a0243967017b@suse.cz>
From: Suren Baghdasaryan <surenb@google.com>
Date: Fri, 16 Jan 2026 08:58:07 -0800
X-Gm-Features: AZwV_QiGfwWS_a1m6Zzi_yFSpjGioLT9sSjsdK1eWkPIvYtSYBlLySU-l0-N1MQ
Message-ID: <CAJuCfpGikJpueGo1hW8ONimHOALnpftT22F7xYuL5CpnphJu+A@mail.gmail.com>
Subject: Re: [PATCH RFC v2 03/20] mm/slab: make caches with sheaves mergeable
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Harry Yoo <harry.yoo@oracle.com>, Petr Tesarik <ptesarik@suse.com>, 
	Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Hao Li <hao.li@linux.dev>, 
	Andrew Morton <akpm@linux-foundation.org>, Uladzislau Rezki <urezki@gmail.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Sebastian Andrzej Siewior <bigeasy@linutronix.de>, 
	Alexei Starovoitov <ast@kernel.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-rt-devel@lists.linux.dev, bpf@vger.kernel.org, 
	kasan-dev@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 98yuz6965upjb6titscqhohkq8kdw15d
X-Rspamd-Queue-Id: 139921C0005
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1768582699-126379
X-HE-Meta: U2FsdGVkX19YrBPqg85ymQkhTw0+boD62asytyyj51G1+KbysivoreGfEX9sbg4NLkyUnJJJXCuRKY+7oRTQBw67XE2rlSL7U0HZGgt17yTnXppVoRt3e/bIG1twfyaw7Q8cgx9wpWxzQJc34/stXlpAoTeGEGECGQXYPEVL3keG0gUD15y2+1g8TZIL/6UKrqCiIQ9jHzgoKKkh1vPn4vdx+7IiMSKoyD9PTt31lzFamWs0MqElGbTAGAHekQl17ijr/ABcznSzTVFB9eLkpPLjNMMQZBlSPMBxVkgKJoAsIS5irT7KhEK4CepBmrWP3SE8usIMeJw2qCvlqMamSnwjWZTYUKRc6+nBnbD18h1EMpj3nqubYhxWsn5HkbJtdrlveUzwEdguQ+Q6w0nNhXJi0IPN2DRd064S3nWYJX2N1Ff9G9cDOfHosu5VUvatUjr23o6knojZ0SLmWy2dP2po89jAkk0UhJoffxNuVoWeop2mOsx64VFGcpGn7H19JFf+uYcZ5XCBF7UXPxdr4dz3nLichL/EhIW2zmAQTAbJH1zGnMUL7fu8r1c3tANOnOk3AymZxXDBUKojqoa6nBIOoaYI3gF0+98C2mHarj5otq8f0Yy6Q/vQ3cel2r8VP0EYz18/O0s+j/M1feGYxDVA6O7ZzHi54JNVmLzr/IJEDsk4GIfP2tr1QG0hlS9LEbiGT1kgODGyLtawcugbrwzqVJM7EOLII62Sb6peGA8erX02C1/47iONJU486VxEmmoQXPkLjKlMreWkDPtdNU0ddsnBEYCcvsQm71TBWH7+txuNsbX+OctA8K3iRZKOYr8RfEvgxgdw3dYyEG5r9a1cH529yfDgml7g3I9yyOPpfSkUNCpD21XicpQjK+shY8VZcsiTicnYuR6xUHWTSFJKf9Kx/yxhNC26KidaksN4L3oGso1V3IEYqcnFYPqT9HfGtMQY49pEPJMFtAH
 pz28poZd
 19OpMyYbdQLnhqG+8rNTT+/i9GyvrGKo0oB7az3TJPobdvlhFb6vVgMX9tL31loRvImdYUiwPtlyTNEFQhhdkRZlJksNGavtIO54vq51VfUmXAdxUkI6vCZmqolraIqXuZuhPfMiBxf0sCliZZ5wttN4rJA21/xJQuQjaC9srZCOnNRYpoOrx29/rogNpyQ2m+1pg+gsRTNuyJcqT8U3Yk1UJnGp7bG9eooNgln+m5hU5z84=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jan 15, 2026 at 11:24=E2=80=AFPM Vlastimil Babka <vbabka@suse.cz> w=
rote:
>
> On 1/16/26 01:22, Suren Baghdasaryan wrote:
> > On Mon, Jan 12, 2026 at 3:17=E2=80=AFPM Vlastimil Babka <vbabka@suse.cz=
> wrote:
> >>
> >> Before enabling sheaves for all caches (with automatically determined
> >> capacity), their enablement should no longer prevent merging of caches=
.
> >> Limit this merge prevention only to caches that were created with a
> >> specific sheaf capacity, by adding the SLAB_NO_MERGE flag to them.
> >>
> >> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
> >> ---
> >>  mm/slab_common.c | 13 +++++++------
> >>  1 file changed, 7 insertions(+), 6 deletions(-)
> >>
> >> diff --git a/mm/slab_common.c b/mm/slab_common.c
> >> index 52591d9c04f3..54c17dc6d5ec 100644
> >> --- a/mm/slab_common.c
> >> +++ b/mm/slab_common.c
> >> @@ -163,9 +163,6 @@ int slab_unmergeable(struct kmem_cache *s)
> >>                 return 1;
> >>  #endif
> >>
> >> -       if (s->cpu_sheaves)
> >> -               return 1;
> >> -
> >>         /*
> >>          * We may have set a slab to be unmergeable during bootstrap.
> >>          */
> >> @@ -190,9 +187,6 @@ static struct kmem_cache *find_mergeable(unsigned =
int size, slab_flags_t flags,
> >>         if (IS_ENABLED(CONFIG_HARDENED_USERCOPY) && args->usersize)
> >>                 return NULL;
> >>
> >> -       if (args->sheaf_capacity)
> >> -               return NULL;
> >> -
> >>         flags =3D kmem_cache_flags(flags, name);
> >>
> >>         if (flags & SLAB_NEVER_MERGE)
> >> @@ -337,6 +331,13 @@ struct kmem_cache *__kmem_cache_create_args(const=
 char *name,
> >>         flags &=3D ~SLAB_DEBUG_FLAGS;
> >>  #endif
> >>
> >> +       /*
> >> +        * Caches with specific capacity are special enough. It's simp=
ler to
> >> +        * make them unmergeable.
> >> +        */
> >> +       if (args->sheaf_capacity)
> >> +               flags |=3D SLAB_NO_MERGE;
> >
> > So, this is very subtle and maybe not that important but the comment
> > for kmem_cache_args.sheaf_capacity claims "When slub_debug is enabled
> > for the cache, the sheaf_capacity argument is ignored.". With this
> > change this argument is not completely ignored anymore... It sets
> > SLAB_NO_MERGE even if slub_debug is enabled, doesn't it?
>
> True, but the various debug flags set by slub_debug also prevent merging =
so
> it doesn't change the outcome.

Yeah, I thought that would not matter much but wanted to make sure.

After finishing the review I'll have to remember to verify if that
comment on slub_debug/sheaf interplay stays true even after
args->sheaf_capacity becomes the min sheaf capacity.

>
> >> +
> >>         mutex_lock(&slab_mutex);
> >>
> >>         err =3D kmem_cache_sanity_check(name, object_size);
> >>
> >> --
> >> 2.52.0
> >>
>

