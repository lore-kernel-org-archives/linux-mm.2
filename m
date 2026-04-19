Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C7E18EA71AF
	for <linux-mm@archiver.kernel.org>; Sun, 19 Apr 2026 22:51:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9F8776B0353; Sun, 19 Apr 2026 18:51:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9A8A46B0354; Sun, 19 Apr 2026 18:51:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 897546B0355; Sun, 19 Apr 2026 18:51:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7A9586B0353
	for <linux-mm@kvack.org>; Sun, 19 Apr 2026 18:51:44 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 9B322BAEC5
	for <linux-mm@kvack.org>; Sun, 19 Apr 2026 22:51:43 +0000 (UTC)
X-FDA: 84676804086.04.B93A527
Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	by imf15.hostedemail.com (Postfix) with ESMTP id 986B4A0005
	for <linux-mm@kvack.org>; Sun, 19 Apr 2026 22:51:41 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=iG5Sr3Jn;
	spf=pass (imf15.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.221.54 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776639101;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nGI8q1vIW2YCqL8DB2swQpMBunXNj9M7QpTu5vxe99c=;
	b=EnkIY7P3+4oEw02XgeDNRKNWTs9qEbkZWMLBR0qQodlTc9aSwMSBO7S3xo7ckNzftOzEgs
	ZqcaxNyoNU+wu+k/upiLG7B1hV2vFypUsP7NCLwLWG+WIlGibwKhExl612Z9oBa410oXSd
	iLJYS6bDVcMG574zZxgQ3O+eq7SBPTY=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=iG5Sr3Jn;
	spf=pass (imf15.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.221.54 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1776639101; a=rsa-sha256;
	cv=pass;
	b=xqa3R9rJoCpIGmzyR8rJoct4rcjEBeBEo+7/yxsrBfqMoBP6xQRRefOLDcsguJf8sjwqMg
	IZwCDENWfvOFtvQxlJr2DDHwjHU+K1e6lXQGqC1KCLCJ3K+ClMXLkvULqqIX/72rhxxMbi
	bG2G84sXMdg1/8Rb3ZRuDyjavfZKJEw=
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-43cfbd17589so1754352f8f.0
        for <linux-mm@kvack.org>; Sun, 19 Apr 2026 15:51:41 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1776639100; cv=none;
        d=google.com; s=arc-20240605;
        b=LeK2a8Zqc4rSti0dGy7qlW4zW2iQgfaux+A4XQixqaW02YcP2Lr/lBMZ7+xbSlDmm2
         3uSasDEhtiyt5Gd/fu/OX+NmPLTfIh0x3L37tPDEHYmtatXG11kY71iUuftZgfi6uvbn
         5mMEvtpLcI0t4W324v7UxBvLdyK3LNNIUGhv7G9OcYbyfXjEYetyKbFhK+fuye3zC/YP
         JY7G3Ydbz6EMT1RUj9bDf5+i5E2BXUXW+qUhK0QRfgRgZ3wsBZzOwufV39bcyz8LjEYV
         XymAAswoOnlV2OoK+1/DGTad1p2ddU+rUU/IZ+9raQq8LRa3k1+Zm8QzrTkwXhX/tRsd
         zpKQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=nGI8q1vIW2YCqL8DB2swQpMBunXNj9M7QpTu5vxe99c=;
        fh=9s9etyUuzdhtfHgoBZF6gMj0z69CFRGR970Nh+Iqz8Y=;
        b=U7KJe6VHjVMTZlYGSrsPqwiWw5vsr5TIdrACggN2OTSo82L0jzQ/EfJRJSStGjGHN6
         BBDbktk94BiyXylPlHskJFtu7d4OwymS0XRf0f5N+WbMimPYxG9n+kbLPzLPcsGKpbNn
         dv5osxN7OTDf2j+3sDa/YHMj3yfePjrHi93pOLNOqh5j1eCUhfBaCkFDAhMWe4exVGvU
         HzILcmSUgvxZYe6qchzWjve+r0kbFDN/X8kuYol236Gj/C8Zg/7eTWdokKFgadmhrq2W
         gO07pVx6Y5yUH3BbEwbaMMztoVZGDfEheA0CvLaQEavnsDz1tLZ6b3gouyK5AjqXtBFt
         V4Vg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776639100; x=1777243900; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nGI8q1vIW2YCqL8DB2swQpMBunXNj9M7QpTu5vxe99c=;
        b=iG5Sr3JnC2pJU/noIBKskAZzX8M5gdXILxE44QT7d0uvCtC1uyxSxq7FjFnaP9jgJW
         YyW9SkXk7LlMnb5TVAJM5eFpS6/+sbAPY/g6o8+vePncCRkHc+IQW3V+NzINKRWwWBl6
         RCjD7ElcnjQphyiGhUMSRd85cW8G/4+N3BzGQ0ND9McGbdCeIAWiUnE+6ewKpU0WyagH
         aSJgHQYDkNRZuIV2fC+tK4pDDSgYvNN0r1388r7pI1MLvuagSKcUBbybjfoohXzw58GY
         ZTnvP8FgOikNv1G3vNmU4ilpWmkmKCFzTkaV4TecN+fLDhrwIJhTM4se5MhSQ2+AJR4o
         nQmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776639100; x=1777243900;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=nGI8q1vIW2YCqL8DB2swQpMBunXNj9M7QpTu5vxe99c=;
        b=HQ+Y0iOaBuEJAh2cahOz+0KucbwY5P0Addhb5EHlNu0tJlweYzTLwxHGL9AW30Otet
         ZpS1OujytBjfL3Q3bTmwnHv5rfSFHlUAHnjV7f1C7AjFCVr3/VkgGKkWD4j/2KVDWwcj
         08MoUWIBqZlpqA5iGN/GnAZYqDS/oYD2JZ6WLoSEPGq91Zty47Ialja0htbi9vg7cZIc
         FrIHQn5enn3yi5kkWqzUifo/t9x03E+R0n6nKzfCzvQtyo1QC0HGsrassYzUnHbqJmoQ
         cqmdM4j8gWlSkieDJRSjdjeTFm2uKdUEHApuzlvkyAGFzDE84F5EYGm+MLC8xYq3Pbvp
         dUrg==
X-Forwarded-Encrypted: i=1; AFNElJ886hcTcdjiDvYaQ+vUPgu039Skf5VY3CcrRlki2SGBnJUNNV5d4YnDRyn9JBp5ZMTSzJJfhqRcLg==@kvack.org
X-Gm-Message-State: AOJu0YxbYQnf+y7G/zyz2Njg3h23BIfQNVVFpe/aMa1HfDHidDgpPkId
	7LH7njdS6vyrUxGR9+5xqqFaa5etKIbDRdIoJHWMK7un4211ZlAH1A8jbq6QE0qnEPMvYukmZNi
	rv7DlOlzV1lxgz4doS+mMXeqv5zhY6qE=
X-Gm-Gg: AeBDieswQf1gT7F481zsfV9ZIR2l0Vrc17CNYnQAc9gt9AEtbpO4LqiKqiiC65NhBqM
	pxQuPapB+iDCnDv48DAh3IW3T8pjj8GYnwo0AXnxOps7VwPkLjc6z14abDZBwiCO5y2p9cypG7e
	9y2oM5uLw68dfkik/6OpQ7GgLy+lSLSxhPLAsazGfrg8iMsEpXjZF8xIffA6k7s+DEDEj7vcQcm
	PppdboD9gHZAiBGeTnjsXxvSxPRhlw093Br6aeFQdt+KZkisi4zXjIFvXdnxIxjApkCm7BSvwqu
	KEMptf8Tuh6tqFoKrUGeV6qmI9q63tB68qpAFyUMrrMIuBCIc+BLTt399ERCewNb2T+ssUvL+Yr
	9ChJ/EKIHMWibt4Ej3sxTd8mXiKE/YX7kV1T0
X-Received: by 2002:a05:6000:22ca:b0:43d:7883:87ce with SMTP id
 ffacd0b85a97d-43fe3dfd265mr15420059f8f.34.1776639099627; Sun, 19 Apr 2026
 15:51:39 -0700 (PDT)
MIME-Version: 1.0
References: <20260413-kasan-v1-0-1a5831230821@bootlin.com> <20260413-kasan-v1-1-1a5831230821@bootlin.com>
 <CA+fCnZfubV6LgRjO3NQvhrG2Q5o0ftkFFupLWVYS50XDnmCaog@mail.gmail.com>
 <DHSWK17EZUDP.GIJ6BX2NFR6U@bootlin.com> <CAADnVQLJ=fJ7t1i2+_RYqU1gqYqiLP9Zrwo4vdZsgzjK_yzJTQ@mail.gmail.com>
 <CA+fCnZd31GzdpEqR8VhfK4JtUKyyRMgbBoAbeGACJgm7WvB6Vw@mail.gmail.com>
 <CAADnVQKv5y+gq=TnOAEXSqgBRpmHNjwqCfxpLaw5XkcbQ+23bg@mail.gmail.com> <CA+fCnZe-b0Qqbo5gGv3HN20twquQETDfYYkE1r9tPr9zUFbW9Q@mail.gmail.com>
In-Reply-To: <CA+fCnZe-b0Qqbo5gGv3HN20twquQETDfYYkE1r9tPr9zUFbW9Q@mail.gmail.com>
From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date: Sun, 19 Apr 2026 15:51:28 -0700
X-Gm-Features: AQROBzDew-foTfJLq_z3E45rMJ3PdE7WT5G5Kb1cNLd7o7s_NLhMVNDGxKf8D94
Message-ID: <CAADnVQKuptG_opA12O=Xb9_+cHf3f=ycAZdfUp17P2HBYQzdsg@mail.gmail.com>
Subject: Re: [PATCH RFC bpf-next 1/8] kasan: expose generic kasan helpers
To: Andrey Konovalov <andreyknvl@gmail.com>
Cc: =?UTF-8?Q?Alexis_Lothor=C3=A9?= <alexis.lothore@bootlin.com>, 
	Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, 
	Andrii Nakryiko <andrii@kernel.org>, Martin KaFai Lau <martin.lau@linux.dev>, 
	Eduard Zingerman <eddyz87@gmail.com>, Kumar Kartikeya Dwivedi <memxor@gmail.com>, Song Liu <song@kernel.org>, 
	Yonghong Song <yonghong.song@linux.dev>, Jiri Olsa <jolsa@kernel.org>, 
	John Fastabend <john.fastabend@gmail.com>, "David S. Miller" <davem@davemloft.net>, 
	David Ahern <dsahern@kernel.org>, Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, X86 ML <x86@kernel.org>, 
	"H. Peter Anvin" <hpa@zytor.com>, Shuah Khan <shuah@kernel.org>, 
	Maxime Coquelin <mcoquelin.stm32@gmail.com>, Alexandre Torgue <alexandre.torgue@foss.st.com>, 
	Andrey Ryabinin <ryabinin.a.a@gmail.com>, Alexander Potapenko <glider@google.com>, 
	Dmitry Vyukov <dvyukov@google.com>, Vincenzo Frascino <vincenzo.frascino@arm.com>, 
	Andrew Morton <akpm@linux-foundation.org>, ebpf@linuxfoundation.org, 
	Bastien Curutchet <bastien.curutchet@bootlin.com>, 
	Thomas Petazzoni <thomas.petazzoni@bootlin.com>, Xu Kuohai <xukuohai@huawei.com>, 
	bpf <bpf@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, 
	Network Development <netdev@vger.kernel.org>, 
	"open list:KERNEL SELFTEST FRAMEWORK" <linux-kselftest@vger.kernel.org>, linux-stm32@st-md-mailman.stormreply.com, 
	linux-arm-kernel <linux-arm-kernel@lists.infradead.org>, 
	kasan-dev <kasan-dev@googlegroups.com>, linux-mm <linux-mm@kvack.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: eff1ko3p3f838tboqa3rhnqaautzigsc
X-Rspamd-Queue-Id: 986B4A0005
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1776639101-268148
X-HE-Meta: U2FsdGVkX191GzOklHs6cKaiIRkLJ/uceHNovsLjDYRSSC/40G0Kp77Dlzjx2nc03lRu+U8n1xDeghJAqe9gagZ4CI+0RILn2y3SZ3pvbatuAC4JnQYqKTo8jI0dVJQmcwvoV42imVuyG+FkgE7ue+sRDIaIeb6wo7SfrvwvU/NjMeKMiAQxybTBCMKhtij8MAq8bd7+Lmx5Gl+6jXiE0aErjwmYowYV/Ml9XWLXSfsnG8atG87YzzkF6x2Fe0uBfwTItKXaCKfLlLQDl8nwWgAqaKSpVqPvDFWwXp3shQ9aJJTayx8xCdjmgHU3MY2Gfq9S3dS2/lf/q3DX121EZE88ptAwiDnoy4yCo+trfFtUkThaQu3Ap2tvEuF4TQzhWreFX97uQD1oKfuql+zVY6/wbrrY7fKEdXN3iS7V8Mgo6iL+VC2tzXCbJD9qTUDeQcIOw8R5gXtjsOWc6+6g7JxDEXIBAs2RuDoL8gkoqmriNzB7MGkAoF3AW2ayfe59hBZxHhGeSYMsi9TxQjSPEuro9+g9IK499wt+ErO1xet2ZjE6H0hascgA2UpbprsLJD5pTQRWLXY7u5PvBve9YDHnDG5l+4RoNqhKOvYiPZXzp2xTIB5Swjtb+dZ489EPPRU4MFMZuNK7q0q6K6Mu91WDQ2A21iGq97hZy4OdFiQZhWonhan6pbj7LC0UVQuEJX6AIBm45nFg5peIVtGCoEvgrYw7421mNPPl6ajNuPgX3XRaS1tevqSoG2SMXWZOuH+EnBRq9DZaz4LY+TtEleEo2jJOe280MPce4Qe6nCI5fYZeMuovPGpa29jcCY3ww4yqJV3GOivD5m7NxLS+Qe13grYJCMCfLq6aVci7PBqG1F6H72qF9EliP4YV3HK4+YE9fpZQysP9UNPFLjMkhXFOTeuxxJ3zBzMVYcLqoV46IUK/dLRSneZZl6CP+ldkYR8DOLXNDLReVU40JmT
 MbOYCr/j
 vYBj6MzN07ev6pkPKijOUoMxsiJXE9bXtDrywr8ClyzcwuDCiAebSzS86jSHsTN09qstJdhB2GwucaSxObuBRKBe7G7p0N2iwFDFC6oSBz+BlC/DbecCEoOfhlQvzilEWdtyqCP8Y5QEiocrALbSBGjAC9cemUe37MhAUwK+dGCUP9mZfV5DFdkwxSUoxK38a8a/xWcH6mRgqflPZl/tCZo3EBEoDH7CYBvk0bUJcraq7y9M5N0437rL3VIUy0DikCjBeJdkRoJvF0XMoP0m/zO7+gvnCvcnfn5yFZ/QRih7s8Ma6oHNdfwzsVye1EQd55Lpnjp6obXY+uia9b8U+QInJkkjVrxUDkR5rqz79enVjjeYRdZLZnEixA8M5I7ES1sv7RMapGGTkNyjoWuJ/L5ZZRV6745g42W8aF6pRlx7l6DMHKIauF6AaWkgN3QegZ8a9p2tAx6QZT395c1ogc8rh4eNTmD46xoqnrA5ArXfx8g3qhl2tIuTKXeFUiI9LAM1jgw6SMj6z1btuTmdu3LK1tw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Apr 19, 2026 at 2:49=E2=80=AFPM Andrey Konovalov <andreyknvl@gmail.=
com> wrote:
>
> On Tue, Apr 14, 2026 at 5:58=E2=80=AFPM Alexei Starovoitov
> <alexei.starovoitov@gmail.com> wrote:
> >
> > I think we're talking past each other.
> > We're not interested in KASAN_SW_TAGS or KASAN_HW_TAGS.
> > We're not going to modify arm64 JIT at all.
> >
> > This is purely KASAN_GENRIC and only on x86-64.
> > JIT will emit exactly what compilers emit for generic
> > which is __asan_load/store. This is as stable ABI as it can get
> > and we don't want to deviate from it.
>
> OK, I supposed that's fair. You did throw me off point with your
> performance comment. But if you decide to add SW_TAGS support at some
> point, I think this discussion needs to be revisited.
>
> But please add a comment saying that those functions are only exposed
> for BPF JIT and they are not supposed to be used by other parts of the
> kernel. And in case you do end up adding a new config option, guard
> the public declarations by a corresponding ifdef.

I feel concerns of misuse are overblown.
Being in include/linux/kasan.h doesn't make them free-for-all
all of a sudden, but if you prefer we can just copy paste:
+void __asan_load1(void *p);
+void __asan_store1(void *p);
into bpf_jit_comp.c

> > The goal here is to find bugs in the verifier.
> > If something got past it, that shouldn't have,
> > kasan generic on x86-64 is enough.
>
> FWIW, I suspect HW_TAGS KASAN already just works with JITed BPF code.

Ohh. Good point. Looks like modern arm64 cpus in public clouds
don't have that enabled, so one would need pixel phone to
catch verifier bugs via hw_tags.
So we still need this x86-specific jit kasan.
I guess eventually it can be removed when hw_tags support is widespread.

