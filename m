Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DDF0AF9D0F1
	for <linux-mm@archiver.kernel.org>; Tue, 14 Apr 2026 19:16:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 34EB66B0089; Tue, 14 Apr 2026 15:16:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 325536B0092; Tue, 14 Apr 2026 15:16:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 214056B0093; Tue, 14 Apr 2026 15:16:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 128346B0089
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 15:16:21 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 9FCA1E3255
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 19:16:20 +0000 (UTC)
X-FDA: 84658117320.17.AEA6789
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	by imf17.hostedemail.com (Postfix) with ESMTP id 9115840009
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 19:16:18 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=cMxvA7ZJ;
	spf=pass (imf17.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.128.42 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776194178;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Pa9Tyq9G0aEPQgad+vwhYFPvxVvYUvSmDxYTMccNEa8=;
	b=ojPhJ0D+XC7P/jiT7UfkCfCg3d/cIpX2YUzDva/apL4aPkhdD5fkNLwKmeN6j5aQL4T0/w
	rmDTjeTulYgKoQRn1T5KDX+wvGHCCXnWCJHDmoleUKm8LUDmdHQO+nAepOmjdPHAWks+Sb
	9WAcYAu6aLja3QTgGvNRIw/6cJT1eJA=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=cMxvA7ZJ;
	spf=pass (imf17.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.128.42 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1776194178; a=rsa-sha256;
	cv=pass;
	b=CD9cKRCzUZpo89Y75Sny2arZEy4u6ovC7W0JFLdrRs8TRA7D/kv31S2V/Y9kdk2D4RUrQ1
	37sBYhFKn0snBMBSZ61fktdL8bdoo+LtXLyaQ3DXyZHXG2yD6KeKfJH3xk9dbvIFxdCNQA
	cIwCawTVgklHQz+3rESxIQKzn8WHb2Y=
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-488a4bc360bso33210845e9.0
        for <linux-mm@kvack.org>; Tue, 14 Apr 2026 12:16:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1776194177; cv=none;
        d=google.com; s=arc-20240605;
        b=HWTUmcklu1CfV92I1C8babZaU6PFEDCkfhVnwnSc8cSCrFlA38Zxoa01nQdEpr+RTn
         jvStUtjhp1+6l1ppJwaiUKdDuFcHbOzx6EjQuKFpdwhveuPnp6PseKH31a7bmgzHuW0x
         P0f9+Mvpy0kcCtg21Le4Fc2DgxR7CsaHQINivEekQogp3BlWwrtuioQZVmGQIPaF0nJh
         HGKI+1FjBol3VINeshbk//syawss5Xj7v8bXOIZXpg0MorgbGggVThvEsHb0GNsWVSiF
         ChTpTIH0WJ5sL8AoAEZXxsg5ty6ZLsoDaNcgYmxlwAJKc66uquQbFTr+nBgXiC2qZn+6
         2maQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Pa9Tyq9G0aEPQgad+vwhYFPvxVvYUvSmDxYTMccNEa8=;
        fh=Qg9cDw1RA1B0bk6vQfEUA8LV4/Q888hQDXC1KlHOTy0=;
        b=CMyBVazzSUwUVcC1V5AFsD4Xlt4ble3lk27k4uc/Z3S+P9OW1sIvCjCiuJs5JHme2S
         oyQnTlSLN36u9D97QHOoPPOIUPZAcj+tvwFLtXMOd/l3Zu2t2b44TarCc9GrF2ejjKwI
         FwidDaCaBBZ0VoFEqxG/erQ9G/861cxKpy7hyyupFaYSHLZ7ql/teoS6jq1r4WZrtxXm
         jGS9Qd4rdLggX6Z/2g7sf2MT+K9AtFJCYDTRZHsS9gtZKzq9h0l7Xb68THrXXM/qZ/7I
         Ak7ZI3C0AAUxhASzXwZft5QcoJuLWf+xADLyBHC3p58D8/wdE6qPS/gU4fmsWhDDZwRm
         xSxQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776194177; x=1776798977; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Pa9Tyq9G0aEPQgad+vwhYFPvxVvYUvSmDxYTMccNEa8=;
        b=cMxvA7ZJyZMmGQ9hTqW+FPtyz/GP8IZvz2+wGOzokQwvlO9OUHRxuDV/sRH2K/+Bcw
         j/hHFfFmU/ga7+5ow7LdXWcoBeZr+ayzP01ACA0KmRMkN4ui9bHLgBiHSdoKWUHg+4Ei
         tp3OG8Dz2HjO7NEIAaYJaD2nyKfbfFe0mEbYMV6mywrvY/0t++bjEHUwY2LPw6crjC5w
         fTbhJB7TEaufFtxl8VcN2F/vManwBn4xWmAHIOZSlQUfqt2InU1VjEpCiHNUTq0tE4cR
         skCYXa2gnaqpQPhHTSTpL6hHuttNORGIDyHTKH7yXXEA61JH0SiJ2+f/S8w0Nq0yXJyr
         yI1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776194177; x=1776798977;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Pa9Tyq9G0aEPQgad+vwhYFPvxVvYUvSmDxYTMccNEa8=;
        b=Wj4yfpKFlw484DbLR+GuLsEAJbewXOgp6fuQ9Ok9YOGiZQvvnqgGrdm3eTOcqyRqUq
         vXPFEhEVZpDdSkDg55hQ0PxLRaeGaOPBXYC9uiJoY0xWrcH7C+oJVTE2/DZZw/kKtJBQ
         y6yc9Ny6fpPnOcy/p/UnkvQvtM5yFShA0uSy9K5PETgO2CL6Jgxqjsd0LvWtdQFoE+4N
         rgdF9QLjO2E041Vo/y3XRTxzwCouDa0K7fX+SJayixAoQDc2MWOUZhN3/fzBQvXC9EvL
         MZINvMnSyf0+6yU4SPyJWq9RKmseMGi/4GxhdlEO5PUmPCYVT7gOLQvPdrOC6eMciiCO
         JQTA==
X-Forwarded-Encrypted: i=1; AFNElJ/9/f/tc4j0BsJJntkaslGvlt6kdvdKLUzuV+BwXaxaCrNxPCeWLsqkhLkMLUL4iDih67S9TopD8g==@kvack.org
X-Gm-Message-State: AOJu0YxHLwqycb/v9dfpSi5tmh5QGWdRCVXgrV8OoJDq8+p15AGyqFeg
	aVwzL7Ra+Z/HpEUKKLdrGTVDxgTDSBPJLmXGJfW+1M1KddEiT9dz63aStezAEuFm+thvOO6+K9B
	5QT8vWUROiwxyZ0FKiPhr4vA0DCEZFiE=
X-Gm-Gg: AeBDiesuX3yipRPXdFcqssLmuzx/tyRnHCKMqNSI6exsbD6UP6GqJigyD1YlVmyM9oq
	Qth9iiZninXHZUmJ/q0+SMJUwUfGyKCgmdgTOlYJ4cYsdVvWL6x+tzqP4/eZzGzntqECXLegElK
	gs4qFhrgyJdhQ++IC0N+na5FB4mcRdj5NbwlpDDF0qNUVbspOUH7bSzAdI2Q5Dyla8lKd74B0Ys
	w0CSnu32maXsX2H9l8OLuI+TEWyrn5FMUV3X/2v116pjix5di5urMUenMqR/dwTVKGKhkKAd8tr
	mCAGPet1+yPDuRXEXcwaP93LjfvrgE/n66IQ5897LYOsWX3tJa35soJnRg9/0rQDpSEFR7esyGh
	EeMl2bKMAZngo4d0ZKyPklYbqgv3hERMpZ+lp
X-Received: by 2002:a05:600c:1f83:b0:488:b99b:4177 with SMTP id
 5b1f17b1804b1-488d687bf61mr256552315e9.25.1776194176915; Tue, 14 Apr 2026
 12:16:16 -0700 (PDT)
MIME-Version: 1.0
References: <20260413-kasan-v1-0-1a5831230821@bootlin.com> <20260413-kasan-v1-1-1a5831230821@bootlin.com>
 <CA+fCnZfubV6LgRjO3NQvhrG2Q5o0ftkFFupLWVYS50XDnmCaog@mail.gmail.com>
 <DHSWK17EZUDP.GIJ6BX2NFR6U@bootlin.com> <CAADnVQLJ=fJ7t1i2+_RYqU1gqYqiLP9Zrwo4vdZsgzjK_yzJTQ@mail.gmail.com>
 <DHT3JV7GTOBL.29205LGGNEDSH@bootlin.com>
In-Reply-To: <DHT3JV7GTOBL.29205LGGNEDSH@bootlin.com>
From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date: Tue, 14 Apr 2026 12:16:05 -0700
X-Gm-Features: AQROBzCIKxzyzm1_jzBBwpYG5l-_Hq5ftS9HvYZuKsAkHlvW0CNWB1k5nfXPFjQ
Message-ID: <CAADnVQ+c9h_wuNwj8pjx885oNErGY7bxxCwKi+DiJ0XKSpyYfg@mail.gmail.com>
Subject: Re: [PATCH RFC bpf-next 1/8] kasan: expose generic kasan helpers
To: =?UTF-8?Q?Alexis_Lothor=C3=A9?= <alexis.lothore@bootlin.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>, Alexei Starovoitov <ast@kernel.org>, 
	Daniel Borkmann <daniel@iogearbox.net>, Andrii Nakryiko <andrii@kernel.org>, 
	Martin KaFai Lau <martin.lau@linux.dev>, Eduard Zingerman <eddyz87@gmail.com>, 
	Kumar Kartikeya Dwivedi <memxor@gmail.com>, Song Liu <song@kernel.org>, 
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
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 9115840009
X-Stat-Signature: 7xt6tsu3k4n1qxfa5ebf3nsj3t3oozjk
X-HE-Tag: 1776194178-178918
X-HE-Meta: U2FsdGVkX199NooLgcE68RSrbnzj/jKT+IeV6eSSLDBRpP1Xffn+ppWLdS+7+3h0CImlHl/tacJ4MF6GkDT8l/TJdjg0TttjefdEnpufhBtqNUHxMDk1OU1oy0GMWz4WkENGktGzi+Vjyldfou0/Hmt20rEwUiFLGu9qKF//ZNH2f3niVc1aeMkBAysN35g7KVl8eoPHfUutNhQdWVDDQfBm0VGTeg+ku1GJZkipkIXBeFccPQeos14P+VxjHpWKorf4W08o2hP3DHGtCxhon8/UsLCbEfnzvqxjNFjbxqQLNn7M35ZVS1oLDIT2FdJV7dIDvplnJf2DhaiQyaFouHF90vhihn73YJD/XC4IJwvDKmblz0V/oJK0HCobbi/yCubiPvUicuEDHs9jlxVsSnSSowOPsKTB9TVqDDyKXvnecHjfLHjXYCRrZ7izTgwLdXdtqlTLX2zn/eEHAx79E24L+E+XzyEEH265nhsYxIMDQI1AxHKyPaodo2IafoMs6qnPyeNQ9rveOg2kheO0pnSDJLZGNCT3pwm7SezdiZG1kO0YgGRhcrBNPSseMEDXRnm0un/VHhSAc6o4weOj66ZXLt/1bNawz2V0w234uRcR3ADA93Dt68WaDzrCRgwS5nWt9siIJIjNVfSCuaToAhjU91dCcbYzsFsnn9Z9EPKn7rqb3NaB9Zy59I6kgizduDGgTRA2dCZKIrBX7FRK879MUrDwbpPwQn4AJPtQYaKJ0HjldhKjTW1j4WGgTbY+F1Z3J2KepvePhOW2kif7j8u7MWTpwMq6ChmIg7H7qbhjlhSXJU2Lv6JhdrBqmEA2qTE92EgoPtNKCeImW8mAWuneAMVJsHcWpEYy7cDgrTGX9YtKEfSCRn5SYCvjr2OHJAbUyQW0KKuBdqkMwyfr9XpKu9hog9hmCMd7Tmu88joFEsHNvHVv1J80T/GGysFR0l8On3PWePJvmfNoSBc
 o8gwfRlx
 1HY+lvchNJz9wm6v8Psie3VJUVj93ctaB6UScBF4v1JK1FSo8Da5coiROhxhZaULE4GKThQA91SoYZHRhrfIueVCR5o6ctIn2ZLEIafiXuDCGMMDY+QZyyUfegtoRlRBi8YRPsm4GaHqUqZfjKKg+butn7jDVAbjXFq80sFlDN8TcmPzi2j7/cyA4FQ4DSrJJSE7wWMvcKMiaNhUFhByXVgqPAhlUPnidpdkyyT3kF6vrSqmRxYhfuzpXR+6dKrUHuenPhNFoHTjuSjnaCS1Ek5j5iuLXXrL+7/2DO4rI9TZATkotAzXl7ccsvUTBlbDjQB/rIir7xlfBq44jJRQxJw19RQ+GP6eRLmhqRtvwgs1x/Gdj//bwwvKp90E/94Vdi0iRMz/BngxCufkpMYhh8mSQH73WcMH27eTh78n4D0vsTeEci4fl3N95u07A2ET71h37fuxwRgMPPq1qwnSkrWxhwTr/29/wR94Axg2aAfFSnKA6v52kAuEm8IM4Z+3Er/ZDCRarYA+C+OZLlvOzlibA7RDpHYYj02ZeHQC9n7/Tx4bIOLJMWxC067snOKXym0OBb59kqjYZo0n3SOoKcnHcUjiouZoIjOzZ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Apr 14, 2026 at 11:41=E2=80=AFAM Alexis Lothor=C3=A9
<alexis.lothore@bootlin.com> wrote:
>
> On Tue Apr 14, 2026 at 4:36 PM CEST, Alexei Starovoitov wrote:
> > On Tue, Apr 14, 2026 at 6:13=E2=80=AFAM Alexis Lothor=C3=A9
> > <alexis.lothore@bootlin.com> wrote:
> >>
> >> Hi Andrey, thanks for the prompt review !
> >>
> >> On Tue Apr 14, 2026 at 12:19 AM CEST, Andrey Konovalov wrote:
> >> > On Mon, Apr 13, 2026 at 8:29=E2=80=AFPM Alexis Lothor=C3=A9 (eBPF Fo=
undation)
> >> > <alexis.lothore@bootlin.com> wrote:
> >> >>
> >>
> >> [...]
> >>
> >> >> +#ifdef CONFIG_KASAN_GENERIC
> >> >> +void __asan_load1(void *p);
> >> >> +void __asan_store1(void *p);
> >> >> +void __asan_load2(void *p);
> >> >> +void __asan_store2(void *p);
> >> >> +void __asan_load4(void *p);
> >> >> +void __asan_store4(void *p);
> >> >> +void __asan_load8(void *p);
> >> >> +void __asan_store8(void *p);
> >> >> +void __asan_load16(void *p);
> >> >> +void __asan_store16(void *p);
> >> >> +#endif /* CONFIG_KASAN_GENERIC */
> >> >
> >> > This looks ugly, let's not do this unless it's really required.
> >> >
> >> > You can just use kasan_check_read/write() instead - these are public
> >> > wrappers around the same shadow memory checking functions. And they
> >> > also work with the SW_TAGS mode, in case the BPF would want to use
> >> > that mode at some point. (For HW_TAGS, we only have kasan_check_byte=
()
> >> > that checks a single byte, but it can be extended in the future if
> >> > required to be used by BPF.)
> >>
> >> ACK, I'll try to use those kasan_check_read and kasan_check_write rath=
er
> >> than __asan_{load,store}X.
> >
> > No. The performance penalty will be too high.
>
> Since we are mentioning it, I did not consider yet any performance
> comparision/benchmarking (and I am not really familiar with usual bpf
> performance validation practices for new bpf features). Is there any
> existing test I should take a look at for this ? Maybe some specific
> benches in tools/testing/selftests/bpf/bench ?

So far everything in bpf/bench/ measures bpf infra like
maps, kprobes, tracepoints, etc.
We don't have benchmarks for bpf programs.
So we don't know how well JITs are generating code
and how much inlining done by the verifier, JITs actually helps.

Puranjay is working on creating a SPECint like set of benchmarks.

For this kasan work we should make the best decisions from
performance point of view, like not wasting unnecessary call
and not saving unnecessary registers. btw in the other patch
I think you can skip saving of r10 and r11.
But we cannot quantify yet that avoiding extra call gives us N%.

You can micro-benchmark, of course, but gotta be careful
interpreting the results. It might be too easy to get into
thinking that JIT must inline __asan_load() for the sake of performance.

