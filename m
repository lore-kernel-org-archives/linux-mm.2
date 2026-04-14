Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AA287F9D0DA
	for <linux-mm@archiver.kernel.org>; Tue, 14 Apr 2026 15:58:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C837B6B0092; Tue, 14 Apr 2026 11:58:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C33DC6B0093; Tue, 14 Apr 2026 11:58:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B22B96B0095; Tue, 14 Apr 2026 11:58:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A303A6B0092
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 11:58:31 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 561E3C0232
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 15:58:31 +0000 (UTC)
X-FDA: 84657618822.06.551A44B
Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	by imf02.hostedemail.com (Postfix) with ESMTP id 556F680004
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 15:58:29 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=iQc9QDgx;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf02.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.221.48 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1776182309; a=rsa-sha256;
	cv=pass;
	b=z3Lw03uuZQ3YiL/M6MZQ/C/LzufjtZEfvuDwczR+y0InOXcf0oETR/firgADCu+YqC1UxQ
	UjpzNx7HPgFe2YPT4xsyTqdqnVQON33u9NREi6be7OAYkEG+8WTtJJq714AihJ8wKHKMWG
	pgero/m3c/5OX14XIHGm/KdgwnVrR7g=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776182309;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3mMVtHum7zPwks+XDXBRlehlKpwvf1Ihn9S56ZO2pRY=;
	b=6YgFzPYXPuWfQIbvxqDz5rb/B7ktrd/YaN5oM2mij6o4oleNp5t+fjBnyQlsvWRcORRGb1
	H+h64wKgE5Lwq3DTzNJV9+l/RO95dhdfyqfk2MKI+9u19ttD4GOE55VNGXuHlEUrGsUc0f
	fGXDZ/zvc7IiWRVgsJE+frXiYasSJK8=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=iQc9QDgx;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf02.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.221.48 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-43d7650202fso1932998f8f.2
        for <linux-mm@kvack.org>; Tue, 14 Apr 2026 08:58:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1776182308; cv=none;
        d=google.com; s=arc-20240605;
        b=V9lwA7FP0nk//b87kzUulkgGCEigRB2INMZxgEHAs64/isve2ILC2dUyTMhImwGJFS
         fKAOfXe+k+QHiHb1Z5nshzMqgzXgolyo9XcmOcBF1ps5L5duvd4SRV16S+k00d6obNKN
         4CLThG6Tuu9F+7ozvkd194d0b86D8U7uf+7sElKP44+gfqg7Au4DmqgIQTNbkc+6JQ8M
         svOAJd36Pd4wN77DD7o2AQ9dL7DxqnBmM+Z3sxEX0JRSN9567/t6i+/k4o9KHyS5qclC
         tboe/75NBoSIlWKa9Jsy/8s2GJ4ipdgXhaVxaWY94voy13bboWkDC2iXfIY8QEnjm4Dk
         Iq6A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=3mMVtHum7zPwks+XDXBRlehlKpwvf1Ihn9S56ZO2pRY=;
        fh=dNwqz0vbgMqiqrlSGMAkEJu5UqIUm3D59TjH3c5/Wv0=;
        b=hmxQkJdLZ2+dFZA2pMo9R/vTeiAeSG1I9yqH+uPnneWhMH3mgI2oQLW+RNqzXLLY6Y
         7us1BA5sAm/ubmnRZ3+Ih7IQqzOhrZ5bqaQOhidD+k0f0DRTCkJU0v/RPSaQIsmVc6Tc
         wIlpscvdwSR+qlH3B/DMJqbAv29FUWk4cRMIhype8Zl0/NpQzWI1U7pe7Wdhy2RxuMca
         Zp0ilIU9LnwlFk1yTWOniLkjbHErjAiPwhqYd9XUxRp1hbzYhhh5O1DbRy9t2w3CXu+f
         MDgRND+ZFtKVD4F0kyNgtkgiDrzP2f5uFE63b/zGuTtESasudqASnQGH6qz+15/OMFhm
         E6vg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776182307; x=1776787107; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3mMVtHum7zPwks+XDXBRlehlKpwvf1Ihn9S56ZO2pRY=;
        b=iQc9QDgxOqLpoI68zFlfTttTM4xpLlWJ8wV4bqKyJ/OCmMaHyQj6Z3o9miDkKMqFHP
         NCKMktjfbxwwQogb0sCBNzI0tWxhO8uIE0Dp+/Rrl3XD5gycuEZNAxgRm6/RfRqM7Zka
         EPaXPepdOzK3llfxNDLYkQBZw/GDIByhtmEaMuPEfxmWDjMvmOx3EF7Leczs/PYBepxK
         rcMh6Llnn2fvmskD3E5GOZtXtGkiyyPRCBmsdL7PcOHxTVIVorwp7mRf2yLpNRYSr4ue
         n5aUCj/DnCO2O5zEZe7QYG+XXZczBcAHMJ1QNTpiXE/ft8a88enrQQNhSsY+1ho1ROct
         YzvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776182308; x=1776787108;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=3mMVtHum7zPwks+XDXBRlehlKpwvf1Ihn9S56ZO2pRY=;
        b=B80KpPRTL4VQrngk+/0kFiyexwHnkLlqMwuE8LtrQt3nrhYfQj70dm2gtXg9MrQnAi
         mn2n1ucPWgowikIQZH+sLASl9YciGC9miIuB6cLL4wNp2VTS8E1yZzQNo3R9zQ6JXF8z
         YpNVGrULsr6YxttQXf0k9PUN0fk35LuHooMqUvAQfqYzXe/KgRHoczZ2lwOmrs635Jtr
         6I3SWCdMqujQL0O89BwwJh9skmQwdit/rNilMxqKnfeVhq1V7O1lBLEprUaLLVW/5YBu
         rm6GdthDj78byx+aeD3iXU8/sOuWIl0PtAJqmwVaN/I+Ha/Y9ph/ir3kF5svKvUzxwmx
         jCBw==
X-Forwarded-Encrypted: i=1; AFNElJ8+4SIkAaJcbOiyUsDYUMIVg0zQvY8otSpS/hjyi3PqFyLSNUWzklYNjxtxFULZiMjzMtIh3PQzgA==@kvack.org
X-Gm-Message-State: AOJu0YybKhpXp39oJvBApDWtJYRQrCiKSZHZZRhUt9GZxYt9YNMbFKpw
	czmaXnZacXiyz2Zb2UCOcJtFAtwyn1FBaFMZaLXzUWJosRTmQ/Qf2u0iZS66aqi1ijsAB+Z7eKm
	21ywZ4pwoIdWLAheGlQ4jcbTjkKgDtzE=
X-Gm-Gg: AeBDiet19XH147JXZWk8nsfdJmiLFEWwnB50Iq21lPX1Ba29Rt8onOV25pWC/ZWuXaO
	eA/iiOsEgJ9Lsq0J7UwYNLJZHdwdiXYQi5FvQkGeEsrmI8iB1vHQE/ANb7fdRrlgUnXmm/DX6vl
	GZ5an2RDnwjhLm9ivpq4uI7EMRKdHXanh1XFIK+8Hzq4TVFbS2WTyecZcpyxlfEEt94wAJus0+T
	EuLrAa0x9ai8iDcjhkKi+PVnEgG3ktJAwzeA4ZKvWx7e6+Fi3tad+H+K5ND4c+jL2v14nIyLEnv
	dYHa/+NC/FI6A/FBeGE5l3218GDj5akcNyPZhs+1pOcOzdftFJFruINfqzAVuuqOw3OHHKSAfKP
	Plnv84/FZY/k+LqMX134mYkv32jALyhUFTT52
X-Received: by 2002:a05:6000:290b:b0:43e:a703:3665 with SMTP id
 ffacd0b85a97d-43ea7033872mr4250710f8f.25.1776182307210; Tue, 14 Apr 2026
 08:58:27 -0700 (PDT)
MIME-Version: 1.0
References: <20260413-kasan-v1-0-1a5831230821@bootlin.com> <20260413-kasan-v1-1-1a5831230821@bootlin.com>
 <CA+fCnZfubV6LgRjO3NQvhrG2Q5o0ftkFFupLWVYS50XDnmCaog@mail.gmail.com>
 <DHSWK17EZUDP.GIJ6BX2NFR6U@bootlin.com> <CAADnVQLJ=fJ7t1i2+_RYqU1gqYqiLP9Zrwo4vdZsgzjK_yzJTQ@mail.gmail.com>
 <CA+fCnZd31GzdpEqR8VhfK4JtUKyyRMgbBoAbeGACJgm7WvB6Vw@mail.gmail.com>
In-Reply-To: <CA+fCnZd31GzdpEqR8VhfK4JtUKyyRMgbBoAbeGACJgm7WvB6Vw@mail.gmail.com>
From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date: Tue, 14 Apr 2026 08:58:15 -0700
X-Gm-Features: AQROBzCLeOrIcZKaiQb6Cd-OuEC8rfDXHtXvBFTPGfyaVO0Jqt2FWke0BxyjjQs
Message-ID: <CAADnVQKv5y+gq=TnOAEXSqgBRpmHNjwqCfxpLaw5XkcbQ+23bg@mail.gmail.com>
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
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 556F680004
X-Stat-Signature: y9dfhu95oppktpwxbkn63jug1857nkge
X-HE-Tag: 1776182309-973133
X-HE-Meta: U2FsdGVkX19DuWXTOlblBvg1+okW58y5ac1wOEylo8NGeLNci3wq8EEshed9AXcDYDBlA7vHlbV+IATsOXMRLQdYLUY/UXx/goHsX2xx2WLy33ctlJe1tTweJmc3aBjGQLFGNWqS4BLp+KXhl/ti7jMNkEI3k80cC7qPKKtnywRciqOR4nU8cOhCviqlh4+eT44kOqt2ennPsUz53mOo88nwEqYRf0DC3sZbQ67rOxCViN0Qx+Q/ha1VrXIhLtSwptS9vZIUv3IEGrXjkYDVHfFKHF8kiAXs/zWmambDZq+3Po0Lh4pDnmUuAEie2ZMtXx+5/SHU9/3gnjlpiV7je9niOhNfXWfl3/353To9lSL6n54jHUjqrrss4shTPAnybD1Oo8+nnNqQOeM1mGyCxn0LQ7xaDvz7oVUiAF8rY0sujtGSqB9IjudGz4faP/hUjKd7CWwlXQz+wkg1Na4nI83EyL0ZrOHX/We0Ar4Xe7jiDNXAx94pGsWtAFbdA3xEdXNTMMVOAQLTUdQYkQ3WzBoF30JWO1KZOPMe7T5Cvaqt7TQt93eItJJtWD9XwGr9ImJtc0zO2glFn0p22fL6N7S4/Gf+JnZd0aXqAqGg9J2iErSKClJi9k0UzskH8Pd+HpmE4A4uxFXZFZmSTzD6r9xZ4ojqfJ2y6ipyaA2C/n5PW6XTeohsLHJYeRzsSXWuukjF5/LgTtu5+QVu0V2NGsHr3szanYCSfPa5qZy+qantULP7Ox6rSJJVSIz8GzJ/kEqXkrUpfOIrghPQ6W8I2WEYcQCFTwKa5H+VaepJZJtRnX+XeqSM63I5oy0UegQrUz4f2DgsXMTylRDj9fO8QsOfAqNMfCBktzWDdyAx+XNoXyQ08l1kFj+Yz8GNYC4GG4XykpJTIdpeDrsrdnFnhYEz6lm/lNPOJ+tVr649iuY2VayvaCenAEkCTxxjQravGkCVqIgbMnDjE6qKEsB
 k+HKJXmU
 L791+crcGqf/svNCN+87ZOORbpimwBfmJnATovVfaFKfPxkJlDhkJa+5826guTg4qwQ+7KjbJYlppsqRXmxBVq15M4jmYtqy1mkWv1Q/MXiR0rRmYC3OUwHkE957YqHCQKonnAEZvZP7VPH86cEHZ8X7TbW/koN50cuRojvnx8IP54XQL0xUaDtiSXlPaclizyR9LkTwQeQX8115nFEHbsq7C848AVNC9XSih+c8ZJM2a4Eyhk7pwHfwyeqhBwxQkBfJmeWRBeDo8VkQtvuSf3D/EpPNTW61CmnzJb+YDz5TnALdZYsZJ6F2mXR7MVSD6x8KBqw4SVybdOc6Ne0RqbERe/GemTy447y0TOao9MQxU/z56dIy0ZRODhVxglyb0M6Nby3lWMPSPhLmzi7uRpdtfrJIJm5wMbnvRl1keJtMDC0pLUkFn2436f790ftZyn3VPFMxE/6KjRfRLhfliF0rAO9IZ4T/+UK97DZyif6Kr8+8ZBnSV+42mngml1aoqCWrH4jKdV37I0wucAY+DSrIVtw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Apr 14, 2026 at 8:10=E2=80=AFAM Andrey Konovalov <andreyknvl@gmail.=
com> wrote:
>
> On Tue, Apr 14, 2026 at 4:36=E2=80=AFPM Alexei Starovoitov
> <alexei.starovoitov@gmail.com> wrote:
> >
> > > ACK, I'll try to use those kasan_check_read and kasan_check_write rat=
her
> > > than __asan_{load,store}X.
> >
> > No. The performance penalty will be too high.
>
> With using __asan_load/storeX(), it will be one function call to get
> to check_region_inline(): __asan_load/storeX->check_region_inline.
>
> With kasan_check_read/write(), right now, it would be two function
> calls: __kasan_check_read->kasan_check_range->check_region_inline.
>
> I doubt an extra function call would make a difference in terms of
> performance: the shadow checking itself is also expensive.
>
> But if the second call is a concern, we can move kasan_check_range()
> and lower-level functions into mm/kasan/generic.h and include it into
> shadow.c, and then it will be just one function call.
>
> To improve performance further, the JIT compiler could emit inlined
> shadow checking instructions, same as the C compiler does with
> KASAN_INLINE=3Dy.
>
> > hw_tags won't work without corresponding JIT work.
>
> You probably meant SW_TAGS here.
>
> HW_TAGS will likely just work without any JIT changes (even the
> kasan_check_byte() thing I mentioned should not be required), assuming
> JIT'ed BPF code just accesses kernel-returned pointers as is.
>
> > I see no point sacrificing performance for aesthetics.
>
> With the change I suggested above, there would be no performance
> difference. And the code stays cleaner.
>
> > __asan_load/storeX is what compilers emit.
>
> For Generic mode. For SW_TAGS, the function names are different.
> Keeping this detail within the KASAN code is cleaner.

I think we're talking past each other.
We're not interested in KASAN_SW_TAGS or KASAN_HW_TAGS.
We're not going to modify arm64 JIT at all.

This is purely KASAN_GENRIC and only on x86-64.
JIT will emit exactly what compilers emit for generic
which is __asan_load/store. This is as stable ABI as it can get
and we don't want to deviate from it.

The goal here is to find bugs in the verifier.
If something got past it, that shouldn't have,
kasan generic on x86-64 is enough.

