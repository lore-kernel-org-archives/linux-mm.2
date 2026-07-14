Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D1840C43458
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 06:23:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B06956B0005; Tue, 14 Jul 2026 02:23:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AB7306B0088; Tue, 14 Jul 2026 02:23:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 981556B008A; Tue, 14 Jul 2026 02:23:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 65E016B0005
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 02:23:28 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id EA0C4402F9
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 06:23:27 +0000 (UTC)
X-FDA: 84986390454.12.48931F8
Received: from mail-oi1-f181.google.com (mail-oi1-f181.google.com [209.85.167.181])
	by imf05.hostedemail.com (Postfix) with ESMTP id 979CC100005
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 06:23:24 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=XZmUlE6v;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf05.hostedemail.com: domain of cuiyunhui@bytedance.com designates 209.85.167.181 as permitted sender) smtp.mailfrom=cuiyunhui@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784010206;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UmwZ2JdGpnQjzlIbtGvTSfdYg7lmImsp/NzZpGZ4h5M=;
	b=YlVWnu4y7doiKFQu636O4jCEl70a0/zA2KpNBfrJmq5TCDjikghsRB2GCY5PGxN+5aUj46
	lteKrAA1uR6qV3xmlzfhwKup4h6Aq/1Eh4MeGMqFCNVgX/WTCpwulFjoAtvLfoKoMr/bso
	1kcWjIFZY8oAbdh3KYwNTCuLrD1aCZg=
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=XZmUlE6v;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf05.hostedemail.com: domain of cuiyunhui@bytedance.com designates 209.85.167.181 as permitted sender) smtp.mailfrom=cuiyunhui@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1784010206;
	b=nUtRWmqPBZYAludBIgrzvaKO9odRmbqIno2v137IdN9qrgcdXuGgJZPzrR9AA9XR+Xl3nw
	MqigfnTaSg4LGx1R5RYkXoIrtubjpXYEM67i9QVethOzDghdn+8NiELzlXUdfao3Ep+7IN
	d/ew98VBkkq9d1naJZeUUMzegBtmjGE=
Received: by mail-oi1-f181.google.com with SMTP id 5614622812f47-48d6c621a67so1906641b6e.3
        for <linux-mm@kvack.org>; Mon, 13 Jul 2026 23:23:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784010203; cv=none;
        d=google.com; s=arc-20260327;
        b=OzA+1lV/3UefDnifR/GAVQkYmgfXWGAMBsJZaZMEu/Nw0oRQ+NPvjxht4SVMqicFLV
         Z926MJw58dXBkGU0HH8OVUI6V7DdDY8Z+FwGeEyYpE65+/XrzRPmOs1WfpvYA5LOB+wV
         4FmfTp3AcKCW3achzPU7C98W+LLqVuKEnkMiCH450kA+qLGKI70acY2j9RhRyLByo/Yg
         XhdBmeE9Ij0TJILFNXV5Bg7TuRMJ1IpRwMKb02y/MhG9kXgL1B0H8FPUlN5LvqNqGwRi
         0haT5sfzylWyZjwig/YpasG+gveLme1uEua9+8C8XyAzuC3iRZ79b3CmTgEAtGs62+dV
         LQsg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=UmwZ2JdGpnQjzlIbtGvTSfdYg7lmImsp/NzZpGZ4h5M=;
        fh=SZqyM/rON8Hx9AOH5zmDbl6SRjyVpiocBV9Ypob9yY0=;
        b=KOdIPBqkZTXdES1eMiGMqE/X1gVcT0P/LUtc55ohW/Olc1XHmRn0xiOv8BjbpT5z7b
         WBlWfr+IZk6cs14OcrLZw8159JQy74uf0uHFzWt3vVpzLf+Hct/FY8h0ivOzcKKBzw7f
         Oeua+SjpRSvk1u41HuSGU1RqVCGN5ueShrdz9DgVNUk8u/Fh6uoyN+kkFUx9q4cGk+RF
         F7NXkuQvcIDO22MZjoNmMiF64P9xFGqKTFEXeIzDJbtGU6+xcnEfVRb29GlfoFDCnsOC
         N4wLlJcs7Uxlqd58e1sZGu0+MmbilTqrtxz6paknWDkt5ct6rp3SymCCgg/C8P5X4ZT/
         Ufuw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1784010203; x=1784615003; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=UmwZ2JdGpnQjzlIbtGvTSfdYg7lmImsp/NzZpGZ4h5M=;
        b=XZmUlE6vY1szOHNxs4td63/eBnDaAllDnNcpueEWfEAOoQNgVOEa9G+W5MetWssIZ1
         avrRFVQb9e9jNiCHu2lPdPe5hkNIIcU5DHtu06MjfZjO955Vj7THaPlZQEyd8Ny9bHMY
         iAExVTP/9uejhcSE0pq6NNcK2bh9r8hbtARjgvGoi+m3WqwduCQMhMb3Yx9IPKleI63f
         IXGgvgyKW1RLuLmRfBzzKnDrURFHAU5g1OOEJ5xY/y7VTx0Wlec9DZFSoBG8aB7G9zMQ
         GSubSTk9wv1TUYRuBMIom2fuerY3EYCmBt8iQsSskoFoTxsUSAJ2+pMQnrw47EEt6sCD
         PdPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784010203; x=1784615003;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=UmwZ2JdGpnQjzlIbtGvTSfdYg7lmImsp/NzZpGZ4h5M=;
        b=ia8BkFFeH/gyZjPq521sS4qHaab2VVbPNsP+1cgknKxNbuuvMtegS23GnFEGAav7OD
         cFC8BfSDcxrotFEIQ9jcGPtUy+8y1bGRG1g3MiR0a3QQuXFUEn84LZpQe0KCJ3CUfSQU
         YH6EZrZnrpu8nfufqK9/SC9j4DqSc2Qg/F35kRtV9ZDEsLiC6nEuCDMKgiLgCDnvXLqJ
         PLZy9+n2yVcW0etaqVJiHBGqacYICWKIn2jgZjNT7IYE2hQUlXRsfrR8+DhHRO8rCP+q
         PC/cVO8DEBSMHzPwBoC3YMnmBPmeYEO354kCL6+7uMHFP6ma5XxKH86P9DGNNXR/MsWZ
         mxig==
X-Forwarded-Encrypted: i=1; AFNElJ8EmiGuuGeahHyyxf47fSqMsUgNnEjUj9/RWMGqRH2Y5sfoB+17YRxVijQYiqERGm6iVdZFYqT7OA==@kvack.org
X-Gm-Message-State: AOJu0YyuZzu1Wy+5yRpQ0sXGr38pKHOtBgeIrONuHjPqe9bTJTRG2Xh/
	2xyjjnJaZhloh7lJeQBRNYAlZyJrmDpdFII8Q4uifgB4hlw/2ir1TQTie+RdgK0Spp4M77sovb0
	hkhcoEXeUBuRiTKyXYX991yvyFh2uyx1jQS02s+bVcA==
X-Gm-Gg: AfdE7cm6oDIE74M0hQcqbv44zomgmiRvxNDGuhlu6X4d7I0MNQtlXNU3QkK1YKuSvYw
	bKnX/4HuMBQgS3jGx0/z3/ZJlpNIKW6YVsEi866Ja82g0/7SY9mOX7A1CL7VelzjVvZpt0lT8DK
	jDV4/a5C+FCDM2PwTT0qwxGzlvkoBSDq665Dx7ilMB/dOdweMjgZdueq5XeZMABC4wX8U4IAq1u
	2r9aKoJgm32Kh8dkBLiHngbZXBCu/nNTpNDKFRur/BeljUtFG0pgPYtx/Ejkn+t/u0Fggv823A=
X-Received: by 2002:a05:6808:1b24:b0:495:f79d:b08e with SMTP id
 5614622812f47-4a47a6c1d27mr439710b6e.21.1784010203197; Mon, 13 Jul 2026
 23:23:23 -0700 (PDT)
MIME-Version: 1.0
References: <20260703122832.15984-1-cuiyunhui@bytedance.com>
 <20260703122832.15984-2-cuiyunhui@bytedance.com> <74ffb0c5-4edd-7b64-3d3f-be76c2aec4c2@kernel.org>
In-Reply-To: <74ffb0c5-4edd-7b64-3d3f-be76c2aec4c2@kernel.org>
From: yunhui cui <cuiyunhui@bytedance.com>
Date: Tue, 14 Jul 2026 14:23:12 +0800
X-Gm-Features: AUfX_mxF_EkkHPpXwVLSHWKREo9gY6a3BeqhKBMKR6LcYXx54wa2zu3a3fsDMQ8
Message-ID: <CAEEQ3wk8gK9pam2da=o5mbfzU3-5EtfH5nyhAoVfCoy+7UuCGA@mail.gmail.com>
Subject: Re: [External] Re: [PATCH v8 1/3] riscv: io: avoid null-pointer
 arithmetic in PIO helpers
To: Paul Walmsley <pjw@kernel.org>
Cc: palmer@dabbelt.com, aou@eecs.berkeley.edu, alex@ghiti.fr, 
	dennis@kernel.org, tj@kernel.org, cl@gentwo.org, ast@kernel.org, 
	daniel@iogearbox.net, andrii@kernel.org, martin.lau@linux.dev, 
	eddyz87@gmail.com, memxor@gmail.com, song@kernel.org, yonghong.song@linux.dev, 
	jolsa@kernel.org, bjorn@kernel.org, pulehui@huawei.com, puranjay@kernel.org, 
	thuth@redhat.com, ajones@ventanamicro.com, ben.dooks@codethink.co.uk, 
	rkrcmar@ventanamicro.com, samuel.holland@sifive.com, zong.li@sifive.com, 
	conor.dooley@microchip.com, tglx@kernel.org, debug@rivosinc.com, 
	seanwascoding@gmail.com, andybnac@gmail.com, menglong8.dong@gmail.com, 
	cyrilbur@tenstorrent.com, wangruikang@iscas.ac.cn, atishp@rivosinc.com, 
	apatel@ventanamicro.com, linux-riscv@lists.infradead.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, bpf@vger.kernel.org, 
	arnd@arndb.de, nathan@kernel.org, nick.desaulniers+lkml@gmail.com, 
	morbo@google.com, justinstitt@google.com, qingfang.deng@siflower.com.cn, 
	linux-arch@vger.kernel.org, llvm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: ksucdhqyjjf3sxcbxydk86yi5c1xjgon
X-Rspamd-Queue-Id: 979CC100005
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1784010204-72236
X-HE-Meta: U2FsdGVkX1+9fJ19siemsT4zpqOtPGKVqCsTSbDCBSArYVj2BUjWhtcj1G8dDdhSRINXAdRG3iFmrEpvULpcq1FtJJTNKCZkgqzNRGT1Ciwqs5s1EOTxgcm/H8+/ONxJPJCeGnlnz1mx+hTle9sPHngE4+6RHbM66pg9PZ3bLHmpzVLuOq4O7Yu/KRYW8YjFnroWEe3OkvhlZEkkhz0I5fUHhEkVhtEgGgfDrTj+MHWXIaDyTTnl65raYWqoGQOf8pD7tUfpPER4XFWoSgLpRSipT+OZbWOPAaDzmTXz2iTm+gIDGr26wg0yebIJr2tena0CLvozdtWYNm7eCFvICQLa1W8Rvg2JMSmFvzRhIchGJ8JMLxJkSsYJEGuA97+9p00mOuIah/S89VYyGeLL6c1ZjIX2vWrBuNaR4I+eaE5v9Q1ACHX5YF87bEAN/kSW1TeiJ+xBTEdD5MV/sGozSG1oKSch2sKPZTURPdoB1CdRBslRMJczPSsGp3Uzw6ELqDsoEaGmFszfalN2+0SYrqgB3ePQESpTVHBS3fLYxZZq5HliK7+w3x/vQrqAHGpsYRD8+EOP0PzyFtQIGz+97GLUVdaaRGK2LEuDyv4SaR8u0hgZRuxelDLwacTSxWWN76c8hfrD95aHFQ4sqwF/G8fWPd920BI4IGMq/jogGKUCHq03DsNfD0NoVb5uU01jtaQzfTjbGQKlmIv6wzeA2itbxlSZ7/LwdSBzNT+wIxejZ8yLzp7e0OSCvV3nJVKeEhKm6t35QcQ4rjR9e0KLbu/GMY3Tzhg0gQ5zWmfbP/bAb06XZjzYDQdoK/slGR3bFqfP9sf13PAR/kHLbXoWslU0by+o08O8F/4soLbxiH4BSRu0xT/xJIgXtU+SsUBHWtivBjbd6nEZemTEAcwiX1v6Ixkj54MGS4Egk/+12h/qwH41byCkyJ73ncoGSKk07AfiFKuxcsjZ6bC97aF
 NBKPnpnH
 ZEpQscf+XY0o0PHsK4j5HD4yswDILdVov99urYyNfmSbelCMtTq4xpsxyyA2bYip/Q3FaPU5nqY709sRVwojtLKRHUsTX2I6YdrfGUF0uloxbO7AZWDNKk2NvqaLGGLtt8FgIQ1avzf9z1uXvpqprgZVpPzzAgYRH1mjZ5zibp+QffrQB8gpdKYceAz96oz+WuYR4lACTQOXtdUurqPcT5+P+gSqgLBE8w9wc5LMKrlW1F7iNuKr0AjWOr8f4yBwRdI02Bjx6Ii0gym5XSPjSn1SszduR1n6Zrjan3PYznaPMFq0Rnz0LRjDimxKpTwYkflHh7pE0QG7IO19xVlJH17A0jf+HkzO6tQTDa8ozt7bPCFkxtU1NcOTZkyDAP6woMyBSyCvXk5Syxyc+KyPFHhAht2z68EoCfGiL
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Paul,

On Tue, Jul 14, 2026 at 2:04=E2=80=AFAM Paul Walmsley <pjw@kernel.org> wrot=
e:
>
> On Fri, 3 Jul 2026, Yunhui Cui wrote:
>
> > When port I/O is not supported, exposing the port-string helpers is bot=
h
> > unnecessary and can make clang diagnose null-pointer arithmetic from th=
e
> > PCI_IOBASE based address expression.  Keep the MMIO string helpers
> > available as before, but only provide the port I/O variants when
> > CONFIG_HAS_IOPORT is enabled.
> >
> > Signed-off-by: Yunhui Cui <cuiyunhui@bytedance.com>
> > Reviewed-by: Arnd Bergmann <arnd@arndb.de>
>
> Thanks, queued for v7.2-rc.

Thanks for queuing patch 1.

That patch is independent and safe to take as-is.

For patches 2/3, we later found that the percpu try_cmpxchg fallback path c=
an
expose a variable-shadowing issue in the current RISC-V cmpxchg macro
implementation in arch/riscv/include/asm/cmpxchg.h.

I'll address that in the next revision of the percpu patches, so please jus=
t
take patch 1 from v8 for now.

>
>
> - Paul


Thanks,
Yunhui

