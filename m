Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0D1ABCD5BC9
	for <linux-mm@archiver.kernel.org>; Mon, 25 May 2026 18:01:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 308556B0088; Mon, 25 May 2026 14:01:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2BA646B008C; Mon, 25 May 2026 14:01:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 15A3A6B0093; Mon, 25 May 2026 14:01:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 021796B0088
	for <linux-mm@kvack.org>; Mon, 25 May 2026 14:01:47 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 918BBA01AC
	for <linux-mm@kvack.org>; Mon, 25 May 2026 18:01:47 +0000 (UTC)
X-FDA: 84806710254.30.3180ACE
Received: from mail-dl1-f51.google.com (mail-dl1-f51.google.com [74.125.82.51])
	by imf01.hostedemail.com (Postfix) with ESMTP id 6E1CA40013
	for <linux-mm@kvack.org>; Mon, 25 May 2026 18:01:45 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=etsalapatis-com.20251104.gappssmtp.com header.s=20251104 header.b=QlVib23w;
	spf=pass (imf01.hostedemail.com: domain of emil@etsalapatis.com designates 74.125.82.51 as permitted sender) smtp.mailfrom=emil@etsalapatis.com;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779732105;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fzor4pOAcoXrq0r/dQWN3ieh5O1PmvSJQr5rj+ToVL8=;
	b=b+tBtswagTakYU50HsVNTuPrMEQcc3NVXm5/QladzEfOJkjqxWqEDazKMGQ8KcL3oXaual
	mNpS7r4OZs6gDeNC67rsRHbtAbnldzKgu2oXVGVH0L1kd+CH376BRIN9X2NswNzuKQaI5P
	2IDXbxt2qEbOI/6nQK4JRkMEkBPWpjU=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=etsalapatis-com.20251104.gappssmtp.com header.s=20251104 header.b=QlVib23w;
	spf=pass (imf01.hostedemail.com: domain of emil@etsalapatis.com designates 74.125.82.51 as permitted sender) smtp.mailfrom=emil@etsalapatis.com;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779732105; a=rsa-sha256;
	cv=none;
	b=Oza5JVPFdSVyRI8RCavi3yZfNgR7Rcat3/68+Y7a7iUUnJf7QbHZKLnL7y6iKAoQOoM/FE
	mQAErViMn3oStxMjbRunBR/4wF3DjukmmKf78xd7tk+bxz56YG5O2XCwiIr+obGK+ER07D
	q5gpHuIYhONVjPyEYEDj7QiF0HtPTh8=
Received: by mail-dl1-f51.google.com with SMTP id a92af1059eb24-1329fc4bf77so7608118c88.1
        for <linux-mm@kvack.org>; Mon, 25 May 2026 11:01:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=etsalapatis-com.20251104.gappssmtp.com; s=20251104; t=1779732104; x=1780336904; darn=kvack.org;
        h=in-reply-to:references:cc:to:from:subject:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fzor4pOAcoXrq0r/dQWN3ieh5O1PmvSJQr5rj+ToVL8=;
        b=QlVib23wgTTQQARgC+Stnq5M6DehcoHxSHgYniDCJaYB13WxOQtN+MPxl4X13ETXNx
         FUAB+ZLwV41jtNkAY7MXIlrC/oWJ3ghzZep4YAzn2BcXsEUmH2S9GTbtTyXh3c7hF1VA
         EKLxHtzOl21ArGeL0IipxynF+m5WvYPvVIjfDOTqt7Bg9dyk8RCkXo1IoSF9oAD9jyIO
         ZNNpQbjTsOA1/AKbMki6pXkxiiomxmKZ+pLfnF7fxLh/nOlysHbfV4mZiMR+PgKPeAfr
         mo8zMJTJLGkoSrNiWMWEyvKWWVTVI93A4PX5N3G/mx0bRUxYdrX7q+6X8QtvdCF7qJPi
         e6bA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779732104; x=1780336904;
        h=in-reply-to:references:cc:to:from:subject:message-id:date
         :content-transfer-encoding:mime-version:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=fzor4pOAcoXrq0r/dQWN3ieh5O1PmvSJQr5rj+ToVL8=;
        b=ceX2MYL+V0oVKkOgVzrMng/yUP1QHUZxTFNBcKtjnZ4w38rnvipaVH3XrWId/ES3Vo
         EhJyzP1fE1JJMkCgAdTkV/d0m7ieVVOifWBo/Fk04/ma7jYWgTG/NcNKIdT2UA0+c13Q
         hAaWLEjBHol1S0mN0Su+XTYiP1ChzGldSZTnCc2dUv3xlDMwh7TjwLsXTPnL91sEeLtG
         yBw2B2NNTLJZD+PHZ44NL8TPo0rwpmA99fsLQrXGyx97CFv3l3MAL8Ycl03TKoyLoJq7
         5BGUZrEQU3KA6RwdJWgmhxScfLmj5vgzzQJie25Bmnyv2WP4a7BFmdcjJOyYO4zChUJy
         yuDA==
X-Forwarded-Encrypted: i=1; AFNElJ/0VAKmg0S3btq+cdrS+760Gy7mNMdwE+ZbEX/+OJ3msAddEhFV5JU1yshGDNYhWMvDkKxQQRFl+w==@kvack.org
X-Gm-Message-State: AOJu0YznGQ+1J1CUEEHEh7dKylp1ymPM8HKEHT34HwbBD34Lq4rn/H8E
	yM0w4MFiW+XsBYhooafHcscG7nJixM1lxksCIvrH8L1BkuByX+2e7Q287KqhbJya85g=
X-Gm-Gg: Acq92OEimAkJt7iR78dZpt9dqMU7qAk/mPBjv44wvACYdY0fcsCphEmtQU6UAXSv1jU
	HZmVDzKkLEO7FfoEni520+8uIDuivBsCrvx4ke+rrVtzh5UltvlGNVnTDIEqm2jTOEEcpw32AZi
	nyPSQud07G+0U2talx/b2bJmCj8JGgqz8cjJPG4gfdgTHG9eTnFFInDtuoB+aPSH9pUmWMsOHfE
	Pl4YqDB2KG2RamdDkxPHIMxPlQnLZELjj/CdSvjMo9uRXYd+JS5bfn/lP2KeKvPcHCZoA7gmN7v
	xXjc5uFeyycBCSZUUaFC8dxYokhzOIuEXR/sBUNL/N2vvQpPSlYLYjCWQbyDUaU0wIjdn+PKo5d
	1Mb+fuyLsaeL9w9L7vKOCAg3IFOU+VTyZu9fdNT6KK/WbA26NWYLCiG8bWDI+x5R83vbO9DCVd8
	s+iW4=
X-Received: by 2002:a05:7022:ef01:b0:12c:8f92:c6ba with SMTP id a92af1059eb24-1365fc7b48cmr5378838c88.34.1779732103455;
        Mon, 25 May 2026 11:01:43 -0700 (PDT)
Received: from localhost ([2620:10d:c090:600::cc2])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1366a2e634csm7642048c88.2.2026.05.25.11.01.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 25 May 2026 11:01:43 -0700 (PDT)
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Mon, 25 May 2026 14:01:33 -0400
Message-Id: <DIRYDGLWJJWI.1PACVYJDRYBJ2@etsalapatis.com>
Subject: Re: [PATCH RFC bpf-next 3/8] bpf: add BPF_JIT_KASAN for KASAN
 instrumentation of JITed programs
From: "Emil Tsalapatis" <emil@etsalapatis.com>
To: =?utf-8?q?Alexis_Lothor=C3=A9?= <alexis.lothore@bootlin.com>, "Emil
 Tsalapatis" <emil@etsalapatis.com>, "Alexei Starovoitov"
 <alexei.starovoitov@gmail.com>
Cc: "Andrey Konovalov" <andreyknvl@gmail.com>, "Alexei Starovoitov"
 <ast@kernel.org>, "Daniel Borkmann" <daniel@iogearbox.net>, "Andrii
 Nakryiko" <andrii@kernel.org>, "Martin KaFai Lau" <martin.lau@linux.dev>,
 "Eduard Zingerman" <eddyz87@gmail.com>, "Kumar Kartikeya Dwivedi"
 <memxor@gmail.com>, "Song Liu" <song@kernel.org>, "Yonghong Song"
 <yonghong.song@linux.dev>, "Jiri Olsa" <jolsa@kernel.org>, "John Fastabend"
 <john.fastabend@gmail.com>, "David S. Miller" <davem@davemloft.net>, "David
 Ahern" <dsahern@kernel.org>, "Thomas Gleixner" <tglx@kernel.org>, "Ingo
 Molnar" <mingo@redhat.com>, "Borislav Petkov" <bp@alien8.de>, "Dave Hansen"
 <dave.hansen@linux.intel.com>, "X86 ML" <x86@kernel.org>, "H. Peter Anvin"
 <hpa@zytor.com>, "Shuah Khan" <shuah@kernel.org>, "Maxime Coquelin"
 <mcoquelin.stm32@gmail.com>, "Alexandre Torgue"
 <alexandre.torgue@foss.st.com>, "Andrey Ryabinin" <ryabinin.a.a@gmail.com>,
 "Alexander Potapenko" <glider@google.com>, "Dmitry Vyukov"
 <dvyukov@google.com>, "Vincenzo Frascino" <vincenzo.frascino@arm.com>,
 "Andrew Morton" <akpm@linux-foundation.org>, <ebpf@linuxfoundation.org>,
 "Bastien Curutchet" <bastien.curutchet@bootlin.com>, "Thomas Petazzoni"
 <thomas.petazzoni@bootlin.com>, "Xu Kuohai" <xukuohai@huawei.com>, "bpf"
 <bpf@vger.kernel.org>, "LKML" <linux-kernel@vger.kernel.org>, "Network
 Development" <netdev@vger.kernel.org>, "open list:KERNEL SELFTEST
 FRAMEWORK" <linux-kselftest@vger.kernel.org>,
 <linux-stm32@st-md-mailman.stormreply.com>, "linux-arm-kernel"
 <linux-arm-kernel@lists.infradead.org>, "kasan-dev"
 <kasan-dev@googlegroups.com>, "linux-mm" <linux-mm@kvack.org>
X-Mailer: aerc 0.21.0-0-g5549850facc2
References: <20260413-kasan-v1-0-1a5831230821@bootlin.com>
 <20260413-kasan-v1-3-1a5831230821@bootlin.com>
 <CA+fCnZf-o8tiv_tX9YB5eBUGx17OpztKZsEB6Awjw3WAqBAiUw@mail.gmail.com>
 <DHSWSSYRPUVC.2W3G3OU27L3HG@bootlin.com>
 <CAADnVQLj=UosnsC-4V2+mN92Fe0-kW++U+m-O9c93kk6BwiXgw@mail.gmail.com>
 <DIP9O3BEWG3C.2BAHKYUIA4H4E@bootlin.com>
 <DIPDH3PCUDDG.EGYL0SYSG1IO@etsalapatis.com>
 <DIRMYUXFYOVY.1LQV9E3OHGGBK@bootlin.com>
In-Reply-To: <DIRMYUXFYOVY.1LQV9E3OHGGBK@bootlin.com>
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 6E1CA40013
X-Stat-Signature: aa1d4mk4478ud74a6z7dr9w8dijwxkrh
X-HE-Tag: 1779732105-625313
X-HE-Meta: U2FsdGVkX18Mqg3Enw52u7Ggjzvnx5sQgXuNMLl72d1uMAJX9devemOTm8VmeAcsrHKmlqo0r5Phqz3UY1RygJG0w+Zvp69gEmpybuW0yWO0zv+fHG4S+bdiE+G+0CxU0jozXhT1EVURNCtgU00EE8myW+GNqhKy0X02GU8xS8VUj+EhuhoEInKlT/yIsIlzTeaa5XEbpXB/Nc1SMDjbuQuv23kQGzlqEJAHio4BH2o4ix88LLd0btfPKrOKTiYRVyUZVRgsQ3TZY8LMe7pqws2Ts+C+0ViBUg0fIa43h8HFDD5xJhn4NkIwk6iID0a6qVouNVbu8Q5mHySLyKcufxDP1g0eFXgRalvFHyqowEq5ZzH+IqhHXSoFeok3R3IXp38Gfo8PFX6opVIwjqN+vcms3BUz3s1xfBQIr7yGstelGuu222gsaEjZrB94vsY4LjT1WtlpF1PEKp3jRyLgseKHWYljrQp80kP02yMEUF31VCdoVizkNrx/8darrb0hWZpNZHkbT764aWc+kH6hmNr/Vn6WwMFD43nJJXNosmZltob9IcLa87qLDtP4yVFbmUJeMUHwC6lwJSxksVmrIq7MaL2jfgrxnCNhiPeKXjQ5a6eO91aNHmRi9UKvAqJGN3Nqhmi3eGUmpmD6IySyCLxSkZBSEBPKbcjHmuC1wPolbphWgyBBAOPUOAxOSXl0hd/1Uxn1MkEFU8apRZXyc1JI2dir/C7MdcmYqpYooSy6Pzr2XOh77v919mkCMlPGE9Q1dKG0nkpv18GzWAExU3jn+Z08Ow2L8xpIA4OIkMi96QFzAGHbrmzat10CySkxERBTP4IwrXa+fZFDucX7FXJwygbL0nFymA2amyITmgTKtoAKEV6ZT9WzYGu8Zg0Lywj1GdO5iSK5jbjralCzIfiPP/EV5ZFTvtTNFN45/IazrRuitNr6TV91Fus6Z4/OPHo2URigaSRb3sJfz+Z
 84idvNl/
 JjegRb3Mm5KQ5LirNKN9DqBq2avE7N8LJP5Z0Br3xd3yYqp7Mnagbnpg9rumOAT3sfOdRD3LmIDC3l4dzhb6nMr397rzFx2B0P9V23xHJS0x3+z7Cab1s4eUi8KqCztaEkhJ5ieyTI4PWHxx87aQszzQINU4JWoQz5vkmjU4Rtbz3kwTCZ0oSF8g7N37mrvh9fPzMKKLm7pUd+QePuYp3yhIvvHiseOOl51FmPxrWKNiB2cEycnDL44tempF53Gcu/Q+WlEZDY5l/i35umiUJVxnmTnz9gh4xqkMQ9u5yuJk5bR8AsR7oMIhASolOKH1hvyJtZJZkwZ9YdidW7symwNPXeGeya0aSv4TzbVrnjaHQ9CaMVCs3GgYp4AwEJyx59lXILF74Dn7dfxOr1UoKvPiGe86nIyux/RJgDD2+ESZ/v9I7xCGRpTxU2qD1PAU/1mPXTFTyJ0cKGKO/BF5vG7sexjzUa7rsyU/qbaiRHjJPgz2DQ5t7hBt2vxbZWPrHUVX4wo7Je7fyrK2nkDKngfegR0HB9wWibgxPeq8uOZ34mAU1sKzafppdxKTgR+OdtXoVbf/XZhDk5p62lxjNQ1kdSyCH/3AMksKtKQEAcv5JZkS/odVXdWzvl9TBTDnpZxgDX0qENKP7qSj3cM9mjK5ArC0Visslw+xgq7ZSo8s4lcZHTxeHxI0EVegFfjYKrVgZRcJLfBrWoUSVjTcCZEqZUHiiEtxuxmouEMaLwynsnn32Vca6wD/Q3RK+/HX9OYLDSeUbdQh6buwe61vskfGgKESbGshMFR8z
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon May 25, 2026 at 5:05 AM EDT, Alexis Lothor=C3=A9 wrote:
> On Fri May 22, 2026 at 7:13 PM CEST, Emil Tsalapatis wrote:
>> On Fri May 22, 2026 at 10:14 AM EDT, Alexis Lothor=C3=A9 wrote:
>>> On Tue Apr 14, 2026 at 4:38 PM CEST, Alexei Starovoitov wrote:
>>>> On Tue, Apr 14, 2026 at 6:24=E2=80=AFAM Alexis Lothor=C3=A9
>>>> <alexis.lothore@bootlin.com> wrote:
>>>>>
>>>>> On Tue Apr 14, 2026 at 12:20 AM CEST, Andrey Konovalov wrote:
>>>>> > On Mon, Apr 13, 2026 at 8:29=E2=80=AFPM Alexis Lothor=C3=A9 (eBPF F=
oundation)
>>>>> > <alexis.lothore@bootlin.com> wrote:
>>>
>>> [...]
>>>
>>>>> >> +config BPF_JIT_KASAN
>>>>> >> +       bool
>>>>> >> +       depends on HAVE_EBPF_JIT_KASAN
>>>>> >> +       default y if BPF_JIT && KASAN_GENERIC
>>>>> >
>>>>> > Should this be "depends on KASAN && KASAN_GENERIC"?
>>>>>
>>>>> Meaning, making it an explicit user-selectable option ?
>>>>>
>>>>> If so, the current design choice is voluntary and based on the feedba=
ck
>>>>> received on the original RFC, where I have been suggested to
>>>>> automatically enable the KASAN instrumentation in BPF programs if KAS=
AN
>>>>> support is enabled in the kernel ([1]). But if a user-selectable togg=
le
>>>>> is eventually a better solution, I'm fine with changing it.
>>>>
>>>> Let's not add more config knobs.
>>>> Even this patch looks redundant.
>>>> Inside JIT do instrumentation when KASAN_GENERIC is set.
>>>
>>> (with quite some delay) I think it would be better to keep this new
>>> BPF_JIT_KASAN, because aside from the possibility to use it in
>>> bpf_jit_comp.c, it allows to update tests affected by KASAN
>>> instrumentation in a nicer way. For example, the test_loader subtests
>>> that monitor JITted instructions are confused by KASAN. I can either
>>> skip them or make them smarter when KASAN is enabled for BPF, but in
>>> both cases, it would be nicer to just adapt the behavior based on a
>>> generic CONFIG_BPF_JIT_KASAN, rather than sprinkling some "if
>>> jit_enabled AND CONFIG_KASAN_GENERIC AND ARCH_X86" in selftests. That
>>> still does not make it a config knob, that just creates an internal
>>> Kconfig option that is automatically turned on when KASAN and JIT are
>>> enabled at build time.
>>
>> Having a togglable config knob gives us the option to set up KASAN for
>> the kernel but not for BPF, and I don't see why we'd want that. Imo we a=
re
>> already paying the cost of KASAN for the rest of the kernel, there is no
>> incentive to not run it for the BPF JIT. Having to eat the complexity co=
st
>> in the selftests seems reasonable if the alternative means a cleaner
>> interface for the user (preventing them from choosing an unreasonable
>> combination of options).
>
> Again, this does not expose a togglable knob, this is a purely internal
> kconfig, automatically enabled if CONFIG_KASAN_GENERIC is set and if the
> architecture-specific Kconfig defines HAVE_EBPF_JIT_KASAN (since we want
> it for x86 only), and there would be no way to enable KASAN for kernel
> only and not for BPF, or the other way around. What I am proposing is
> just an internal, architecture-agnostice kconfig to avoid conditioning
> some selftests to any architecture.=20

Makes sense, in this case this seems reasonable.

>
> Alexis


