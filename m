Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6DE60CD5BB3
	for <linux-mm@archiver.kernel.org>; Fri, 22 May 2026 17:13:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D24B86B00AB; Fri, 22 May 2026 13:13:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CD6006B00AF; Fri, 22 May 2026 13:13:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BCBF16B00B0; Fri, 22 May 2026 13:13:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A644E6B00AB
	for <linux-mm@kvack.org>; Fri, 22 May 2026 13:13:44 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 7431C1C085D
	for <linux-mm@kvack.org>; Fri, 22 May 2026 17:13:44 +0000 (UTC)
X-FDA: 84795702768.29.B262508
Received: from mail-dl1-f42.google.com (mail-dl1-f42.google.com [74.125.82.42])
	by imf09.hostedemail.com (Postfix) with ESMTP id 1A693140011
	for <linux-mm@kvack.org>; Fri, 22 May 2026 17:13:41 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=etsalapatis-com.20251104.gappssmtp.com header.s=20251104 header.b=ywllzd4U;
	spf=pass (imf09.hostedemail.com: domain of emil@etsalapatis.com designates 74.125.82.42 as permitted sender) smtp.mailfrom=emil@etsalapatis.com;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779470022;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wY4I8lMoFI92sp/KvSm+KBFNyjnf2+5FqBSVyBYIdTY=;
	b=MIKLtRBT3+75yr2+9Yza1eJgP2YQKrmICRM98jJNq9qYm+zQ7CXeUPDiJWk5y9+G0euKRx
	PXK3GR10j4fqExo543Q+sDwCGhKEOnvDpAdpEOKE0igvP9s7faGcwRkJVIa4WJ7NISRya9
	ufV10tsIL63eRcGNDKAUk9ytMxP1nUI=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=etsalapatis-com.20251104.gappssmtp.com header.s=20251104 header.b=ywllzd4U;
	spf=pass (imf09.hostedemail.com: domain of emil@etsalapatis.com designates 74.125.82.42 as permitted sender) smtp.mailfrom=emil@etsalapatis.com;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779470022; a=rsa-sha256;
	cv=none;
	b=cvDVMNOOSRWka4XuZN8f+YrglsR13sUiiFzx1sbx9q4VamkBqfNWDXhMNoDgbdBZmpgity
	oid8YnOY86cYnz6bPMZuIqnXlMPx5moAwWHkmhvHlqG1uFNmB7KC7ObqI5mnz/PnHJwD3E
	ZTLZGsbSiRACpnkbLGUaAIfz6b50Lbo=
Received: by mail-dl1-f42.google.com with SMTP id a92af1059eb24-134fe980658so9446317c88.1
        for <linux-mm@kvack.org>; Fri, 22 May 2026 10:13:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=etsalapatis-com.20251104.gappssmtp.com; s=20251104; t=1779470020; x=1780074820; darn=kvack.org;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wY4I8lMoFI92sp/KvSm+KBFNyjnf2+5FqBSVyBYIdTY=;
        b=ywllzd4UzKQo7S50jAdiKHaovQTX+wj2gg1yyhmYe3jh4FYmGuRbJYVLX0HsafoN47
         LZLigWw0taxpmEDv5eSuY4VqeSLpT64PdHnWVfIjaMdnGQUviJmhq27Eq+GLZAmDwZs5
         IFYyoCPDuK0EvSMlveKbAXHW7y6NTZPtTtouxEvTg0dbzU2Q8RkqliULhPN2+eRZn3Cc
         rXMiqaVOf4jF18LArABM+9lhneGdCvWsdJUrbygVKNZ5J/fIkmPLSPuCHlcq1H1Hl8kr
         ZsP0BmIQHFj0sm6CszTxlt4Hfq2w0H73uaohGd0vGOf/bavNxCmeUoClfK8vyLwrb2Qk
         Jv5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779470020; x=1780074820;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=wY4I8lMoFI92sp/KvSm+KBFNyjnf2+5FqBSVyBYIdTY=;
        b=kqGdCDtP6UhodQTp4jyf1QPnzJEhmBB3LSqNUKSYS14YXznYmKY2v8+yq22J8Vbk0T
         sw4tcFX6BSkjYS85wFeK2r6muxBMew11c3CNnBLKKZwP4H92L7kAlxOnE9VF9HMSDTMP
         1t+e1xqQ/9S9whc579B13hhOsKeVOz1SIzmIGbR4KomSLOQQdvB2IjNgphxKMhKgQYnA
         B06Oh4k7IyyYNb3maLPZFeLVjdRKPRI0mHjIjhqstJYeRJfC0H5bz/gBi4fNSZzm/4c1
         llHMlh3ENcXMwFQO859PWxe4Hl1PaCWJ1nIuYfsGPhsbb9Fe8XpzIQqC+9eGXP9r6oHr
         7W9g==
X-Forwarded-Encrypted: i=1; AFNElJ/4ax7er2poNYh5ZZAu6lIux40JcnzXDW107mQaT8ul2/cmH6BnWx7NZK3B1c/lz7l8bXKxg8rL3A==@kvack.org
X-Gm-Message-State: AOJu0YxqF4SjQCquCm6eAM1p/PXhJ3osQYa8Y2A8Xlmz504Tqigp8lQ0
	S8yIprC4V0Z3P483Jt4KHtzqlH57IxhljYWERi35bpO7ivw31ShwZSQh15BG7UVz29Q=
X-Gm-Gg: Acq92OFuB3FaHYAenl+IOMWhL5/Oc/m3NYEhxGtZG31rf4dFtr3t3MhcicDNgHnZkoR
	DUXpL/sLb6nFdVvlfKfaCPtpQa4vGBk4zhj9kWM1XOx1y3wQZdy2uLKkuKS8X3YMB65vrE6+0wB
	XArjFg0cHe/HC3BhNkyrJlTca5956az95Y7wEsI8PM7krYc+lr0Kw7Vl6H2j10cCUuXm8QNVANB
	sW+LXelNHTQ5fDH6oqc8TQcOGpYoHr9A/WMQZB6TVbq8bgyl2roRPna43LqFCsLIRpGD361TdLP
	HMfulJaxfvFOoTFmmJ23OjudQTjCscOp5nKeJVFCw1Q20LaIbADRh3WV/v1RPBAcHAzhe7TNcOy
	pgCwTl01zqKvGDqBGdZZBTGswo55qOhRVgKjs3H6iKIvSf25sBzcnto30hyudQA5pMqMzyOo9RO
	21Qd1Zqx1rPqWscG4=
X-Received: by 2002:a05:7301:168b:b0:2be:833c:149d with SMTP id 5a478bee46e88-304491e11fcmr2091389eec.28.1779470020197;
        Fri, 22 May 2026 10:13:40 -0700 (PDT)
Received: from localhost ([2620:10d:c090:600::69da])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-30451f3feadsm1872911eec.13.2026.05.22.10.13.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 22 May 2026 10:13:39 -0700 (PDT)
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Fri, 22 May 2026 13:13:35 -0400
Message-Id: <DIPDH3PCUDDG.EGYL0SYSG1IO@etsalapatis.com>
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
Subject: Re: [PATCH RFC bpf-next 3/8] bpf: add BPF_JIT_KASAN for KASAN
 instrumentation of JITed programs
From: "Emil Tsalapatis" <emil@etsalapatis.com>
To: =?utf-8?q?Alexis_Lothor=C3=A9?= <alexis.lothore@bootlin.com>, "Alexei
 Starovoitov" <alexei.starovoitov@gmail.com>
X-Mailer: aerc 0.21.0-0-g5549850facc2
References: <20260413-kasan-v1-0-1a5831230821@bootlin.com>
 <20260413-kasan-v1-3-1a5831230821@bootlin.com>
 <CA+fCnZf-o8tiv_tX9YB5eBUGx17OpztKZsEB6Awjw3WAqBAiUw@mail.gmail.com>
 <DHSWSSYRPUVC.2W3G3OU27L3HG@bootlin.com>
 <CAADnVQLj=UosnsC-4V2+mN92Fe0-kW++U+m-O9c93kk6BwiXgw@mail.gmail.com>
 <DIP9O3BEWG3C.2BAHKYUIA4H4E@bootlin.com>
In-Reply-To: <DIP9O3BEWG3C.2BAHKYUIA4H4E@bootlin.com>
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 1A693140011
X-Stat-Signature: fwt7e3zt1fkjgad8a1p9yq5fp1dp5c8i
X-HE-Tag: 1779470021-266544
X-HE-Meta: U2FsdGVkX193gaW/V7dAxVlarY9CqVh1JCSMgvqhXSIlUJh0e6pH+pugQosZjttGXuIXtjSyVL1mYt6+8TuzSGRB7llPhAVtmHaLWNn5FZM4dEan5mCrY+x7vAbiNAmgoC6V5EbNpMHlO0B6h1RYBlB2rKqZ82TA+68GqDQY0dPtIoEzd4ylSlH0In6iOj6GWwnRzP9UUvKrjDmDurdjMtwj89i8CFf1oC68k6DljvUuINsvNu56fBiuLAjgwXw1AgVG/aczCMFxNk3y+0zXKjicgMM/BXgrluAVVYTz2geLE82V0HXfKx0yN6yTP/4/pKZyhYMGuXLXjHgMpR7VI+h/UbtNzQ8kGefWfpc7/DfgUg/PMC+vpoWHSwaAkaXCcwJsr3kTJQBxubPjBxM9YNYhwYF4eGToBSjIWXEyOJP/oBtF5gK5UtjzZsCvgcztjdLLvsICBqYxMeqiPbmsirug+QcXnAovpc0YYeF9dttF5GUoFn6pnt+Ke6Q97LiFeTm9URbaWo0B2CV2ODW73L+cx2FoNJSeWypRkOyXFqPxxycwwV9BeSx4JvQYwNg+pk0zMP5lJK1VwrhTR9BycVmZmXGC3YwCr5LadrTipgYcmMqQNF0b2a0vItjPF4cu5x6Q+nmeBmqXbf7nJ3kl2Fr69VFoKFvbj7N7uKxHBCkoEuWW9MK4bz3+EpVx57oLp9QSibaqdcc2rbUxrob3O1tigFTKrVfBM/HDwllBW2CVvQXHlOliMx/+og6IwQ8b2d8YNLuaIF+YcXKVjuR4/NIk1uv1+OuP6DoxIGi/5R2My9pNOm8Ryc2BYLtVN5MyA93cBycZHtDaBH/43sK6ELUNYh4TQPE37tmvOY8s0TAiUd3bLz6Rtzw8G1EeLHLPVwRG/y2cXJmO3da8bCcqiA6jE1PVJLa2kU+Atq8ah1sS8ryM0MSS2Oun1kcNu0XAJAY0Kn29W6Z5RCRrscX
 XomV5NZP
 05cKb6new8fULrQjUrkYTR6G6newuDnco/MDWSRBNugggmrjx7P+dn9ftDCNStUjYzs9mNifceanSz3fkPRo5QjX862xahQaUv3ZaSa0JrtbegsSE/GUQU2HGEzsUgFbRmulox0BrwaTGGATK/t/fUnW7gijnZXQB2KzmnP8bHPij6ax1QZpGBdATJFaKdM8ZsYrJ0xV65J+ERnIzIUBsWyb8CWGg0oy8BnMZBAYZ2RgijopOMBx85Qeco87OKRl0mDOjjREOpdjLcBRMxRpWHLlO3H3Jx8UZdYGkS52SNV6vlMjmbm8RLyP2dCw2BrJhA9l4EWNpX1gY1VX9eEnP0fdx8+2r+8+Cmv19OV27JhHxhj100IPWUE2o/8h88FWsNXtz6AwVkUiMUFM40bgNVnRWYWM6V5qq9/L18HFt9JQPGT5X3XALrFyDit1glBpUs/9JnSzagYha2AHHlPHtt68ADsk+SULAjzG/PxqnTeQmObPlJ8mFL50tCYaBYzIiU3wov/912PDgxihPJTnDNdp/gYwwZQnO7u93iVC50MRu13H/MW7iDR8m9i7QgW6WpWXC8TDmRZul/Uoc+YfkFBshzS8BoSkyAph7eAROMC8X5Hd2rWjr9SoaVHHT3QtC6/AQmfT/j3+RpgDKxvH6pJTtJOcwHO9NwLHuAdc1u/Z/mMpMM456O+lfDN+gSk4bxerwZYbLwMEBkQc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri May 22, 2026 at 10:14 AM EDT, Alexis Lothor=C3=A9 wrote:
> On Tue Apr 14, 2026 at 4:38 PM CEST, Alexei Starovoitov wrote:
>> On Tue, Apr 14, 2026 at 6:24=E2=80=AFAM Alexis Lothor=C3=A9
>> <alexis.lothore@bootlin.com> wrote:
>>>
>>> On Tue Apr 14, 2026 at 12:20 AM CEST, Andrey Konovalov wrote:
>>> > On Mon, Apr 13, 2026 at 8:29=E2=80=AFPM Alexis Lothor=C3=A9 (eBPF Fou=
ndation)
>>> > <alexis.lothore@bootlin.com> wrote:
>
> [...]
>
>>> >> +config BPF_JIT_KASAN
>>> >> +       bool
>>> >> +       depends on HAVE_EBPF_JIT_KASAN
>>> >> +       default y if BPF_JIT && KASAN_GENERIC
>>> >
>>> > Should this be "depends on KASAN && KASAN_GENERIC"?
>>>
>>> Meaning, making it an explicit user-selectable option ?
>>>
>>> If so, the current design choice is voluntary and based on the feedback
>>> received on the original RFC, where I have been suggested to
>>> automatically enable the KASAN instrumentation in BPF programs if KASAN
>>> support is enabled in the kernel ([1]). But if a user-selectable toggle
>>> is eventually a better solution, I'm fine with changing it.
>>
>> Let's not add more config knobs.
>> Even this patch looks redundant.
>> Inside JIT do instrumentation when KASAN_GENERIC is set.
>
> (with quite some delay) I think it would be better to keep this new
> BPF_JIT_KASAN, because aside from the possibility to use it in
> bpf_jit_comp.c, it allows to update tests affected by KASAN
> instrumentation in a nicer way. For example, the test_loader subtests
> that monitor JITted instructions are confused by KASAN. I can either
> skip them or make them smarter when KASAN is enabled for BPF, but in
> both cases, it would be nicer to just adapt the behavior based on a
> generic CONFIG_BPF_JIT_KASAN, rather than sprinkling some "if
> jit_enabled AND CONFIG_KASAN_GENERIC AND ARCH_X86" in selftests. That
> still does not make it a config knob, that just creates an internal
> Kconfig option that is automatically turned on when KASAN and JIT are
> enabled at build time.

Having a togglable config knob gives us the option to set up KASAN for
the kernel but not for BPF, and I don't see why we'd want that. Imo we are
already paying the cost of KASAN for the rest of the kernel, there is no
incentive to not run it for the BPF JIT. Having to eat the complexity cost
in the selftests seems reasonable if the alternative means a cleaner
interface for the user (preventing them from choosing an unreasonable
combination of options).

