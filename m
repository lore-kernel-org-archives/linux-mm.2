Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A539DF9D0D3
	for <linux-mm@archiver.kernel.org>; Tue, 14 Apr 2026 14:38:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 184596B008A; Tue, 14 Apr 2026 10:38:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1360E6B0092; Tue, 14 Apr 2026 10:38:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 024436B0099; Tue, 14 Apr 2026 10:38:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id E44B46B008A
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 10:38:53 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 883EEE3C11
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 14:38:53 +0000 (UTC)
X-FDA: 84657418146.14.4A68B1C
Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	by imf17.hostedemail.com (Postfix) with ESMTP id 45B244000C
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 14:38:51 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=UONWg8bI;
	spf=pass (imf17.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.221.47 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776177531;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=t3FcHIl3IgssSn4hNhLSe6L719nynY/t+2SO5yRqP3Y=;
	b=sf1Fuxbfbxb2hSysPJMQJdRBCg/AdUUfLtQ+A7o3JV8pxwMc0Mox8A/1iukoAUc4NL2s+8
	8c7NEtvRNbrw1t1K43gClUJNJYdjhwGr/HA+kY9ZNyz2VksLjfsX56jfAP+IaPznP2Af1O
	85IBXA6SUTlB6TXXHpsjAOFfgvLE1FM=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=UONWg8bI;
	spf=pass (imf17.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.221.47 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1776177531; a=rsa-sha256;
	cv=pass;
	b=dOKEVIW+aHPRUbQE/Kz0h0HqX3ANW/UUbb1b8RiRIFsUiFRbCKtXLsH5OS+UD2TxrT7Nok
	bwmTZt3ISiMmwps4jKy9AKD8BcWorM5fZGo7SNODdwIr0JUocPloQHxyB6hyeA53Jnj12k
	8FJrrJPySkvRbNaBhPrk25wHTz/ZFXI=
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-43d7605ec91so2120574f8f.3
        for <linux-mm@kvack.org>; Tue, 14 Apr 2026 07:38:50 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1776177530; cv=none;
        d=google.com; s=arc-20240605;
        b=j6Y/CLoJVmr7ljBmjQOKgLGviHgc2/XI3c5zR9Ie2VSVFkuMOucJbn2YiEOjVqQ3rH
         wSFuzcAp4TytJQ/azvoagpoU9/iSe6b42rJg4f2Kx4QNu5Q1Zi/ItZdjm2F7auY9Eroi
         rDNPwUqXRwq4VxaMRbgouJfaPaCuHBjxbuFM/pEF21LxyHT+CD+wg2+v1lCjECZnqmZX
         zns5Ya6faQLSgvnd48Iti/o6JjTk/X9AQAdf/u1XkUpMStIYwPAo3jUbpcPSC+lLQhPx
         rmDLkArpbjSb0cXWdI0Z9c5Pb+F96vhZaAY4NfyDz6oK+xSkhejRhQjcjxeV1TAPSGIh
         BGUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=t3FcHIl3IgssSn4hNhLSe6L719nynY/t+2SO5yRqP3Y=;
        fh=mwQxHnI8RKIQ/2Jw6vSXNq2t0L3dOJmHwEnIBt6yKKI=;
        b=LR/561Jr+0EArm7Cae9YYue3t99UusK1Wxsb6/e8WKD5/VO6LliA8YKxGrDXZMllMS
         8T7qXGGzncfXigVvK0Kcp6S71SXXMP8AcopyEA04cJd3QqSjz/FrtplPuo8dQUVWBix9
         3Kx2WL4jaP842dMMCmHi5KIcldM1aAC4wvEGu7EjuXTwBtEo5CRgGEGNIh15l4Qo8uUs
         wdKag4Rw83v4Ap8AxcLWZ+nmFILshBw84cmT/H77oq89ZexYZHwSU/r4vye6C8dCLlZk
         fGc62pVDZsKnggm/d0R2Y9aWP/VTE3v0yAyKqYZVKj7X02fHlGgLVXU4lF1Nq7lN+BgK
         gwcg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776177530; x=1776782330; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=t3FcHIl3IgssSn4hNhLSe6L719nynY/t+2SO5yRqP3Y=;
        b=UONWg8bIL/zm+YKmLWO/vV0OXwfLLpLmjd+HtUpCh9Uv9WN1My8lVjEuUNHXA6Wk7f
         cDTGMj1mAcHdQ7uKUyfqU7W1+f1mFKENxSSzwvP3IuzodUW2KZA5LmA7CNsvk2p0lDYM
         G96JKJh4HfkKzpaBkksQ0ErUXTLcCBdOznrMiIxHoPUfrkcMtkGPK/nLMuv4gZswr+we
         4fzCe7OdVu9pu8xsRtj5G1CJH2vyQvsx+gADFxiQwASbEgtVaZ2xF0SCheAhKn+dqcYb
         txDaybYZDUJDWWlyyuJVBwHJohC8dF0+xentT0EyVQ8f9prwYse+iUGNMcjnLW5q/bH7
         xLXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776177530; x=1776782330;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=t3FcHIl3IgssSn4hNhLSe6L719nynY/t+2SO5yRqP3Y=;
        b=W4hS++kuM8fsv2lpXlNf03kIbbdBD0qTgW4aTYTh4FhdGEiEc5Iz4EQ9PdLAucJhdS
         OUm53ArOEwyDW1fOAixDwbyIbDG7ez9GOimpvE9piv99oq/++v6qrxuDdZ3iL+OhGWwp
         H9tHf04mkjIERnD0/4pra9R3kSRXYpkTCw2xFFnle78hxAhGdQe+VcymxESbIQdpgwzr
         1UvWoD0ZweNHpAknPbTX7LpKVO9ZCmbnwV8n4JjITOdYCoxWeeE/5+wzxup6xrke2pd9
         ldhySyZmfMj1ub0fjcUItSWslDvM8OYlD+Mc3890HUPtuxKxeUECRNZZx5+iJXEEQegu
         krWA==
X-Forwarded-Encrypted: i=1; AFNElJ92Je57cxjBdXkU/xDDToYlbx4NQD4bYw30d7Dkkd0Ns57ZWXnxswutKbZGAxGLKLzvxQCLc1rUdw==@kvack.org
X-Gm-Message-State: AOJu0Yx3L2hll5aQ9w0UJA8PuvSuSt25C5f/w/xsCCldgX7spqnASEoT
	jj+YP6K6iNwie1U0qMWZm34eO5sfS/gRL73Ne9NXk8IfxqZANFjbdG0ebqg8ybAfehng1za6dlY
	5BQAKQk6OC6aBpEOZO7Qltx3kIPdk3aY=
X-Gm-Gg: AeBDievnjZBUy5bNSl7S05nKCbyVtynbVjouVPPHk1NwB7mimn7wmA8XC3AYUtsVvMx
	JMEAl0Uy3HQD4tyzMnKbIJqRwCAlLfP+2Dih5G7j8U7An0VghteBbKIRxaHiHNRlYxHDZumMjPV
	TOiqsv7JNwPnNDOlXGnXNR3DLTjVpLoxOMGiOtUiQf1eLAoOihcX6ewLJ5QbqESrXw5PEqtyFo/
	tzI2VwLBrfzt2GoDnhqy0LtwaxI1FgloPQLyUnUggQJZnjhInXTcetJIoNNMF1TqWGTO3VT05Em
	zYCzlYVy+WhQ6Sq8jRV+ILO2RtZ7Ok4gYQZwSwF4jYNzgLpkhiUJMntcZ6/6sfM4Y1E5Ro9roDs
	Z6WXKyEMNApusZrEnteJgnTL/JQ==
X-Received: by 2002:a5d:5d85:0:b0:43d:73de:abd2 with SMTP id
 ffacd0b85a97d-43d73dead51mr14691281f8f.26.1776177529609; Tue, 14 Apr 2026
 07:38:49 -0700 (PDT)
MIME-Version: 1.0
References: <20260413-kasan-v1-0-1a5831230821@bootlin.com> <20260413-kasan-v1-3-1a5831230821@bootlin.com>
 <CA+fCnZf-o8tiv_tX9YB5eBUGx17OpztKZsEB6Awjw3WAqBAiUw@mail.gmail.com> <DHSWSSYRPUVC.2W3G3OU27L3HG@bootlin.com>
In-Reply-To: <DHSWSSYRPUVC.2W3G3OU27L3HG@bootlin.com>
From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date: Tue, 14 Apr 2026 07:38:38 -0700
X-Gm-Features: AQROBzAAc3g7dGJeHc3HZECQFqFuOBrJ_YiWzr60z_aqmL-sqKG6l_qunoKkETU
Message-ID: <CAADnVQLj=UosnsC-4V2+mN92Fe0-kW++U+m-O9c93kk6BwiXgw@mail.gmail.com>
Subject: Re: [PATCH RFC bpf-next 3/8] bpf: add BPF_JIT_KASAN for KASAN
 instrumentation of JITed programs
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
X-Stat-Signature: 4q8oyqq9pmya1844973463i1bxrjdhn5
X-Rspamd-Queue-Id: 45B244000C
X-Rspamd-Server: rspam09
X-HE-Tag: 1776177531-529039
X-HE-Meta: U2FsdGVkX1/MsMPbJrgF2fkHIMIGDaURx2vFdqKzn+BlkWATAbYKbXt0mOIomqavKMvg0IyNUB7Yzyrbv/uEI+jCqtRd6ek6abw/9IHkzFO3LyqMUje3GDy3vUHbUcNEb5mlZCRFISLSsEeGT/hy/Uecrmdc9YT254iu+Jfjum6N/X4EVQcpNFHBfifXQyY8I+9BbQsf7vwivCXeE2Msl8k/LpQiF+lZSnTCBXdhnlwaDhQ67+E3EIUuEIy2Cqu/P400NAsw32jAOIZXhNDiJs++iNZAG/oAYEuFvkblLQNUJj4f+fdrEnH6OwCBiiCpn4fdxkB/Jxmg0/ELlBcD9qSqIxGWLLy0vRM7prmnKT1ktl4mrCHvSgYwQRq1o3TNZgPC9ymPuBSQcdJcWpfejRAZtlbF1Qc0RBouLGc88euXrFoh/7hQRAFe8/Lt3xvmSzAP/9f4V5gdIJI/Mv68kNQwO91jT6HtwdZcVajVcCM8lHasinKKnjPx4/am9QGNWMBOFGHAZl16vJqcxTVO9c7DJIW2yFCNmUGljMn/FnsQ1X9o9wvJxAcw12JT2pXXJKhAJXcZ1XWh9/QvXXl7hlxUQkPCzvbAa0UQLOX8r5Qn1rQbVDIRHOJQkQaI3fw77Mhs4MewhXKI3qso1dvwu1LEVKyvZTofV5Ayt7hNgTBozULV6le1UgdbWZdfikPL/lpAmx8hAfRElGv2TZLLymoL4oRaJwh/UWROasaYPpbq1nHH9Fhn7CxfvtS/+NoUZvHdVrSYQ4szkISOZS5AORgwnolDBO5Xswnm0S2JA7S2XOG/FD7cho/mGU61JPpwAOuKRJsFCHxVQoKjGqhBYEgDj/FY/CChY4DkN04CCHrFRYCBUN/eCf+jStH3A1Ty9AMe+AhIngfs3LtH7z4T33siN9IO8SREGi7eFS/ogUxeoigyKpLpCNRV7mTXk1o/wLI0Bd+C/C6c6MibQuv
 F90HZ+ol
 KigspWAmpFhCl3SlGNMy0Zo1SPMMPSS8GXOAeAN3ppJJKiHTJAR1arTh3Lk0rHdfYWFy94ZOmkX6tQTKY/4+obV4TyQ8yhpkxiWHZmap4GtXTUsVTRjWC3QMYKuI0qTEz50p5A1LmoWs90Ej+93DJGUlhbOUcx57DOXu9C+BDWwIVqCjr9Edc6VwHsJ9KVKHNIo6XjdUItBq3SzYi8UqxzsGzMtCdmnZ6mDwwHY/STT44wOaEtvmX+Ei2a6ISpsdqGzy0h2K2LfkgF81pvx2KwzmC1MjDmC2E95dyoV2nU/eY5UP+pGrISXzuqkGM79AbaeByRVrAncbDGDrD21WbVdxkiXpZ4+ksrnj4r/XQaSHkykjdFl5VoMwcDFlpM91UXnjbX//YIJYjTEZwSj123WDS877a4JsBXo/GoZRiynHxSF2pmZbWOjit38Ih0G5QsbmfaIGe0V64TZX3Zr1lRA4Hr9DUVs6UmxnkiEY6T/uIE+JVCFtxeHdnFbcCST0ysVfu9FHjHDnMYpn+amOZSJer+9ySl2pbrag/Aoo+WOdtv8K/2DOHddTcM1EbrNJ+wZ1VKikTQyovlwQp+QXzPj+gVNB4C3lvZ6/HFL0QPn+1nzFiMFt1kNZRCN26TQqFsRfnHHolAELnkeo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Apr 14, 2026 at 6:24=E2=80=AFAM Alexis Lothor=C3=A9
<alexis.lothore@bootlin.com> wrote:
>
> On Tue Apr 14, 2026 at 12:20 AM CEST, Andrey Konovalov wrote:
> > On Mon, Apr 13, 2026 at 8:29=E2=80=AFPM Alexis Lothor=C3=A9 (eBPF Found=
ation)
> > <alexis.lothore@bootlin.com> wrote:
> >>
> >> Add a new Kconfig option CONFIG_BPF_JIT_KASAN that automatically enabl=
es
> >> KASAN (Kernel Address Sanitizer) memory access checks for JIT-compiled
> >> BPF programs, when both KASAN and JIT compiler are enabled. When
> >> enabled, the JIT compiler will emit shadow memory checks before memory
> >> loads and stores to detect use-after-free, out-of-bounds, and other
> >> memory safety bugs at runtime. The option is gated behind
> >> HAVE_EBPF_JIT_KASAN, as it needs proper arch-specific implementation.
> >>
> >> Signed-off-by: Alexis Lothor=C3=A9 (eBPF Foundation) <alexis.lothore@b=
ootlin.com>
> >> ---
> >>  kernel/bpf/Kconfig | 9 +++++++++
> >>  1 file changed, 9 insertions(+)
> >>
> >> diff --git a/kernel/bpf/Kconfig b/kernel/bpf/Kconfig
> >> index eb3de35734f0..28392adb3d7e 100644
> >> --- a/kernel/bpf/Kconfig
> >> +++ b/kernel/bpf/Kconfig
> >> @@ -17,6 +17,10 @@ config HAVE_CBPF_JIT
> >>  config HAVE_EBPF_JIT
> >>         bool
> >>
> >> +# KASAN support for JIT compiler
> >> +config HAVE_EBPF_JIT_KASAN
> >> +       bool
> >> +
> >>  # Used by archs to tell that they want the BPF JIT compiler enabled b=
y
> >>  # default for kernels that were compiled with BPF JIT support.
> >>  config ARCH_WANT_DEFAULT_BPF_JIT
> >> @@ -101,4 +105,9 @@ config BPF_LSM
> >>
> >>           If you are unsure how to answer this question, answer N.
> >>
> >> +config BPF_JIT_KASAN
> >> +       bool
> >> +       depends on HAVE_EBPF_JIT_KASAN
> >> +       default y if BPF_JIT && KASAN_GENERIC
> >
> > Should this be "depends on KASAN && KASAN_GENERIC"?
>
> Meaning, making it an explicit user-selectable option ?
>
> If so, the current design choice is voluntary and based on the feedback
> received on the original RFC, where I have been suggested to
> automatically enable the KASAN instrumentation in BPF programs if KASAN
> support is enabled in the kernel ([1]). But if a user-selectable toggle
> is eventually a better solution, I'm fine with changing it.

Let's not add more config knobs.
Even this patch looks redundant.
Inside JIT do instrumentation when KASAN_GENERIC is set.

