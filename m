Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BEB4FEA71AA
	for <linux-mm@archiver.kernel.org>; Sun, 19 Apr 2026 21:49:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 94DB26B034F; Sun, 19 Apr 2026 17:49:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8FF196B0350; Sun, 19 Apr 2026 17:49:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7EDA76B0351; Sun, 19 Apr 2026 17:49:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 6C8D06B034F
	for <linux-mm@kvack.org>; Sun, 19 Apr 2026 17:49:14 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6F0995B034
	for <linux-mm@kvack.org>; Sun, 19 Apr 2026 21:49:13 +0000 (UTC)
X-FDA: 84676646586.26.DD3B124
Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	by imf26.hostedemail.com (Postfix) with ESMTP id 652DD140002
	for <linux-mm@kvack.org>; Sun, 19 Apr 2026 21:49:11 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=VrHDTZ4P;
	spf=pass (imf26.hostedemail.com: domain of andreyknvl@gmail.com designates 209.85.221.54 as permitted sender) smtp.mailfrom=andreyknvl@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776635351;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cFrGrWFy/krqcVnxXtLhe3ZTOUNcitG9G8OlGBpdvQs=;
	b=vf2D+HLk9KDMwnv2WmXM+3oXSlDolesZ8NcTNNnNM8xK3djU/pvpwOoFdf+nyVBCOqe4dZ
	ptJ5D2b8B1OUlZHVFRRg77ea5LPaZ7vpzinrEFzg+6rYqWO6ye0AxYMeC6RO5JeZyZUE3d
	pEoM1HZv3kNX4SVRGrVLw+LdvYkRE8I=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=VrHDTZ4P;
	spf=pass (imf26.hostedemail.com: domain of andreyknvl@gmail.com designates 209.85.221.54 as permitted sender) smtp.mailfrom=andreyknvl@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1776635351; a=rsa-sha256;
	cv=pass;
	b=Hd3KG1hkpO0b/wJcpAuSoj28mlgCgVfNcxMDieIwSIPLyK7XXiq0t5JPjFCMicyuUnvy+6
	IGA2lOhf4oUUXciG+RfIUL/xOasHIcFZCnzRCoZkAgfVDfYT5E2ypep1jZ/L5ZpGvfqWIz
	38vuQZEeeP5f6hnO/BC4vrTr3x86ndw=
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-43cf7683a28so1544880f8f.2
        for <linux-mm@kvack.org>; Sun, 19 Apr 2026 14:49:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1776635350; cv=none;
        d=google.com; s=arc-20240605;
        b=j13ZkAQZKuBB8L3a+nXF1h7D4M67vLPUvqLpo9LD6qCxhMXX1bwQfGJ4XJWeE6FYrf
         wgBw4BUXSfkLZOu9V0MWCPDdrmNiBP/717XOCzXIjwCT/Q7CyrhrGK+qK6pbP6pe1eBj
         eIIEMJ5FRimK7+DJqSlQLmHAZsiUAGoF6MRLZsr50oHUZB/n2zHFTareJV9QYMa5GxJ5
         p37vFsaAAHN4cWNk7O3gqYoNEHuD93GPUjoE3itQvJgfmys8hqNX704ko/E4dYmJQuhU
         gh60kBcsgCXJeD5RbeH5Em0nxEwXNEYn+fROpqR8TWJ3hIPQ+f9uI3sbGNrdHlfx3tCz
         4pOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=cFrGrWFy/krqcVnxXtLhe3ZTOUNcitG9G8OlGBpdvQs=;
        fh=9O7wc2LdjTOjucSPGGsqGRdXPZCQv99s2aSuACBbeQo=;
        b=VdUMOLhCMfK8DKbzWInDZpLzNfJkYCjqTalwsIA7QuB9Y6rbfwYcTd2zW3D7G3XI4q
         wrNlDucPEYplixHz4uHvSZWehQJyD3fE+D+I9b5/7j3iD90TuhVZCnuYzYpiRsy4wfEj
         q6ExNCxDShdahkVE0i7Us1O3rUETpxxUqoiQwr7PAEenBxjJL5zSF3Mu19EoP/vvqQov
         C2s1q0Do+Vjf9UOfXeB8l9tuXv/nLxjdTW1KueAVgZTaTPLkqgZqhSSASJyjweYz5io+
         A3FrMrVW7x8v6Xn/+7axYmn1gEov4QEjzticgwB9HvmpOAyc3HfVF7LberqohNYjdHMp
         po5w==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776635350; x=1777240150; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cFrGrWFy/krqcVnxXtLhe3ZTOUNcitG9G8OlGBpdvQs=;
        b=VrHDTZ4PGZ6V+kZ5lglxt6L30We4pRkgvavLa6xxwTF89we6CD+FNxGa/HuoKuW/kc
         GSKk2PPkW39TQTOXlxg6Q1vF39lQdOSAzLuR5uZhhD9ZJFsvF6+X0NlUAAsaAMzao8uv
         TW7iaxaH5vi5EE4TxywGSs+D6KRXSg4Fo0BwN+vhrZJ094IPAtMe+DInb/LFs5BrIV6Y
         ROaeYwgHfBHKsPDfUTCqjEx+V0aDAHl/MaZwX0kYEynG7JA4fXrsVqgd/mveih23iAza
         fIHlXuBXcLlSUqech06w5xH73xOL8Lb7GO9A00MRmF26KSg0RGgnd4PsZdJXapmvLPJu
         x5Nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776635350; x=1777240150;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=cFrGrWFy/krqcVnxXtLhe3ZTOUNcitG9G8OlGBpdvQs=;
        b=THIx3XMT7pYCOCKhOS4zT8Pzbe7pZNOkvS4GW4eelg4Uep2ZH26QNPQtADvZvwy9C8
         QKtK36RCjEQlhEd6cFplKY59H+IC8YsqCoUp0g2akSNwOwOUv187N3bBlWRGmqxcdcHI
         zfJx6+75Ihc2HMxQLnqLNMQ5I/2QYQbOfCpiJNCrj/33kdUoTU2DZ/q1AD+hdTStyeJK
         vh0iY6qARK6T6IPIeRJ882LE/lxgDlGOoO97d+J2jQ03Tu8CaeRYjKO1vspXGHbPdzPt
         HZOJ7qCpuYrFnKq57LgFih9jdBUkXyVeESfUW0J9CnL1Zq61QUWSCYrKdL+0RStxAw+n
         E7Kw==
X-Forwarded-Encrypted: i=1; AFNElJ99QHc3ZFU9SfsQsE4Z7LwHFqUvRBbZusxnUqItGjeApk6fz7N+cp+NiGCZhID/RzvbuxLK+XFJdw==@kvack.org
X-Gm-Message-State: AOJu0YxRsiOoSHN8c/BGVIhf+oTo1Xgq2YzPpkU5cCdxNAptRVpmpeJg
	0PIOdoaSj2QRFRI+sVsSNgeednHwHxTFQEFp/n4sJvOLXh/rocz5i2pysm1Nycxt+DuaAQirAju
	HXUBJAfeORUt3u8IM5NHrIJ4xlzt0IFk=
X-Gm-Gg: AeBDieu4y9KCGOL91nfHDz2bQ8Y3DlFR8wABlHl1aq39SnCNyBRBsYk212Xb1F/iSTe
	zRr7ZcA4kiJMKXQVpdTIoxGSjdBKz2sl9BJ4C2LamhUOqSmrMpJ7v5+aGurCLQSmC3K5awCvpXq
	RET8SNSJM08Ec0HbQm0svSipgsxvu9rrl0xlGmrVXXhNnarWABKNWfQRLrizvmq3BYHCagI/irE
	ncYI7gAatTHR+nxodWD7D7f8fydCpxrmnr3TSoD3DmaeoBYQBE7eVNen1qF1NERtTdNyjNl8cJH
	KsFd9DpHlWUoV3GJaldDe+783Fa8jV2y6zGxW9sdh73716iPgIY2
X-Received: by 2002:a05:600c:8909:b0:489:1b10:d896 with SMTP id
 5b1f17b1804b1-4891b10dd45mr22100635e9.0.1776635349567; Sun, 19 Apr 2026
 14:49:09 -0700 (PDT)
MIME-Version: 1.0
References: <20260413-kasan-v1-0-1a5831230821@bootlin.com> <20260413-kasan-v1-1-1a5831230821@bootlin.com>
 <CA+fCnZfubV6LgRjO3NQvhrG2Q5o0ftkFFupLWVYS50XDnmCaog@mail.gmail.com>
 <DHSWK17EZUDP.GIJ6BX2NFR6U@bootlin.com> <CAADnVQLJ=fJ7t1i2+_RYqU1gqYqiLP9Zrwo4vdZsgzjK_yzJTQ@mail.gmail.com>
 <CA+fCnZd31GzdpEqR8VhfK4JtUKyyRMgbBoAbeGACJgm7WvB6Vw@mail.gmail.com> <CAADnVQKv5y+gq=TnOAEXSqgBRpmHNjwqCfxpLaw5XkcbQ+23bg@mail.gmail.com>
In-Reply-To: <CAADnVQKv5y+gq=TnOAEXSqgBRpmHNjwqCfxpLaw5XkcbQ+23bg@mail.gmail.com>
From: Andrey Konovalov <andreyknvl@gmail.com>
Date: Sun, 19 Apr 2026 23:48:57 +0200
X-Gm-Features: AQROBzBeG23-litRs0f9sM5oKr7DzVV_-wsJjyIfGuOE5YpAx7fmmNXRz9M5Gbk
Message-ID: <CA+fCnZe-b0Qqbo5gGv3HN20twquQETDfYYkE1r9tPr9zUFbW9Q@mail.gmail.com>
Subject: Re: [PATCH RFC bpf-next 1/8] kasan: expose generic kasan helpers
To: Alexei Starovoitov <alexei.starovoitov@gmail.com>
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
X-Stat-Signature: 43q15t1b3hkujgauhyp8oqtsx787obr5
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 652DD140002
X-HE-Tag: 1776635351-647790
X-HE-Meta: U2FsdGVkX1+1zEvA1iYQRit2xsbF5tgyW5EiaD6XwCswVVVoV5ryTDhQor+KXRvbcfoTFkGu6+B6chKfn3kMANzSeUu/FaIF4LZ+9AWSS/ChGJl+7h19HPnk2rz2imZiVUa/jLaIPT+W9nlSlXpY4MB3wL2KaIqYMSU5DnfsqI+9TTeCP/rtScQQbkhWJ5YrBF/dWVx8cMefcc3Wxort8YhWtqeRe37CGX+YTkOqzI6SL5iUajxgQJTMV1w7JkK5sP0Fee3vWWpVwORZwdgwlHKSFRL1FUiqPYA27A6Haj7K6GTAyj4sHHfQFuamTSVT1OGxZYCrulqt9PAD8Ov80Uyx8CbljRo24rb3yh/XXlA4asXL8hDCYAc2icOb0mqVHucdk9HGps2JJedqqSBy8Hg0IjQ1vm2b65eZPiVCsUoUBRBVfLQOyFaMoVFffNK7DKA2wbSM1qjLy3PpJOCt/qQQKnBSD7ziT5/vKWVrSrzVrft50xeBOV8TuYlfoA/PuCHbRkKccnxtYftDHTlh7Sqym7r/79ECguegOZ4C5dDZrzEKtqtmV+1c26MaBYpAC1glIdJxIRlt3oPmUVYVm2MI3hVzE2WY3AidKqRN6NP0cSiAR1qRKKErdcY3Bncw09WyYYKlulXaqgd6yP5IhKQiR1hceHuNKJjbMvrpYYkNpGLb1XV6pUtfeDI/mQMfVzkpU2du8ZRWmoWBQajsHCFmELUgC4PdcwWJGq8ItJjga1O2atsut8dak+L0tXuVhyz/1W4yQWzSnr4IEjJY6Aa6J7uvpTSujpJIZKwcp7lYDsgOoknwWWJYlYt3Je9ecUTQXikgPibjs105U8gUThu4XHmF6qyLuwiCEWATGLKlr2vf1yC+ROqOLPVNJwQjgfIiu+/q6xTxLDa1CkjFKUBL2HSEOpaG0wtk2gd04enWVqwlyJpEsTD2cen1sNrhIbJvw3X8s+XYWn+VoBn
 JkSsQXBK
 AfkdjLsasBMJMMJ3PYM+wqdacWKkbofFsRG0aVaQ+vJiZWLSuOUAucvzzUp6kU16tGWowUxemx2m9S4MJxYlJknjrFAYpSQS8LlOoAQ67/1mNEyuwwiEnol+eNDhGgi5iMo6ZBrEF8WXue9xnWIM80wnQF1QTzP6r56Mn9sHyJrm+iER21llxB2Ks6Ox2Q8LJMFs6j1tnRlNG0YOcB3/Fc1PzIly1yfo+l4/fRGVR5OkBlhCEpfVxLKDF/ZXM6RyeZpYaUBeFh5yRgK2BCmFnzeaKOzFkQvdsIVHV2Gzk3PwCyAMBmR/ZSNfGm17l7wNPcjfKTPw/pGjzOx/jzvdo1D9yeqARfL2WvB0WhSYF+bBbc4CcyKBP/pCIqzAH9UK8q6LxzSGgG7vILRX5DWrI2ZJSznemGt9ni4k3UdG8NwyN9CHZk3cE+C/wnBmAZXcm/kO1l2Ywr2yEf27Dh/A0oZlbiXZEowofnfjrtdkP804JKqbS6D2DFYhcfg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Apr 14, 2026 at 5:58=E2=80=AFPM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> I think we're talking past each other.
> We're not interested in KASAN_SW_TAGS or KASAN_HW_TAGS.
> We're not going to modify arm64 JIT at all.
>
> This is purely KASAN_GENRIC and only on x86-64.
> JIT will emit exactly what compilers emit for generic
> which is __asan_load/store. This is as stable ABI as it can get
> and we don't want to deviate from it.

OK, I supposed that's fair. You did throw me off point with your
performance comment. But if you decide to add SW_TAGS support at some
point, I think this discussion needs to be revisited.

But please add a comment saying that those functions are only exposed
for BPF JIT and they are not supposed to be used by other parts of the
kernel. And in case you do end up adding a new config option, guard
the public declarations by a corresponding ifdef.

> The goal here is to find bugs in the verifier.
> If something got past it, that shouldn't have,
> kasan generic on x86-64 is enough.

FWIW, I suspect HW_TAGS KASAN already just works with JITed BPF code.

