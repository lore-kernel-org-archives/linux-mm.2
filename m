Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 991E5CCD183
	for <linux-mm@archiver.kernel.org>; Thu,  9 Oct 2025 15:59:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E1D638E009A; Thu,  9 Oct 2025 11:59:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DF4598E0008; Thu,  9 Oct 2025 11:59:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D0A698E009A; Thu,  9 Oct 2025 11:59:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id BD67B8E0008
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 11:59:53 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 7656511B1DE
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 15:59:53 +0000 (UTC)
X-FDA: 83979036666.03.3177BD9
Received: from mail-lf1-f53.google.com (mail-lf1-f53.google.com [209.85.167.53])
	by imf27.hostedemail.com (Postfix) with ESMTP id 88E584000E
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 15:59:51 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=hTkKFz3k;
	spf=pass (imf27.hostedemail.com: domain of snovitoll@gmail.com designates 209.85.167.53 as permitted sender) smtp.mailfrom=snovitoll@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760025591;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WQBxmURKiGaN3QIqBhTff7pEbZ70mJ9TllMgftPCUcQ=;
	b=XFwkwsHXU6h3cl1dqUmkywi8wfYY3I6Dw63ZgVwBtxnGyaVXll5EZbS6FrhIQdJlhZ3R49
	6AInBQdnf8rtlqw460S2/fn8x8e1lCMajR2JMkyTngdECVd6Qo6S8rFE7ubeEs+c5pzarb
	FjAnbjsd4NRNKu9rDjU8MqQE0z9csJ8=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=hTkKFz3k;
	spf=pass (imf27.hostedemail.com: domain of snovitoll@gmail.com designates 209.85.167.53 as permitted sender) smtp.mailfrom=snovitoll@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760025591; a=rsa-sha256;
	cv=none;
	b=MNTNfnHzZAjS/ey3BefFVCjtu80MZqIysIbQf2X88Jx6kT6M5L4HQtc5OEFFs2KcJOekH9
	ERgowKn6ryAUgGSwUtTM+at1yzoQo63SGCKrQE3t3UDu50zcx/8stNk12HMjbwISH9BQb+
	Sy0Upv9zN2dt8sgnBHhr7yfgFXkU+LQ=
Received: by mail-lf1-f53.google.com with SMTP id 2adb3069b0e04-57d5ccd73dfso1225031e87.0
        for <linux-mm@kvack.org>; Thu, 09 Oct 2025 08:59:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760025590; x=1760630390; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WQBxmURKiGaN3QIqBhTff7pEbZ70mJ9TllMgftPCUcQ=;
        b=hTkKFz3k0VBVzakjOKsPhtYciMSYgfeOA7oFfTys7UrHrp8lyuO1un6iTv93WfWfXu
         vXFrck4qvPp1WG35SrgmkcT+MuKxIbqP7k+mAdTI7+FaAHyJzfE5g0SnMnPomc+sOLiM
         uekGPgHkuB4TTyDopM1+iSfbNbbN4oUXEAAnAGxj86bflsDDW1ko51fXbIJ9KYThNX4a
         KUhAsXEhgsp9YluBJdkdOo8rPJP7sBYNWRpcvGcpyGj7fzOdjV6NdPnxJua7kaGM68mL
         wz5HB3evMFqvOE3DQDPnQa3i+owqxfdnXNoTyf9j97DaUg5WHXqSp+2oxTf2GA5HYCss
         WNbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760025590; x=1760630390;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WQBxmURKiGaN3QIqBhTff7pEbZ70mJ9TllMgftPCUcQ=;
        b=C7DXo1upguD6DQIE1FMqriuMinCK+H+xLb9d2Fch+0ZnZpXFrbYFZcV4StJiCZ5Tot
         1irRuhEqxeoHahhdaHOYAkk9FHqZP6txBK1X2Bf9HM42jOkomn/FVBpBY03INqgULMty
         eRX2H1BBZzUPMlxycXNVA1mSEKmdJQy8uj/g8EfNYAA70UFIWxLl5Dxx/pFZJ7x0EFyW
         JEgPoXCXNCHIktI/T9g2Dd1VxS2zzABVdoWqre3uToTlffABcqQE88U30GXCUvfO381e
         5p6ojqrC1MhntutXNTK89iQ8PKfdijjrJjCJuepRBiBKN3eeLu2jpDoJD8rKUNCxZqbx
         nckw==
X-Forwarded-Encrypted: i=1; AJvYcCX+gZl5aBkKxAzeOjhMg9Q2KFvvvhtHAz57/06tcpQvtnplQ5AXa/BZHraTAAYDYJpMeSEZwRlY7Q==@kvack.org
X-Gm-Message-State: AOJu0Yz+80fzLgdOp4AEJrYVDupS+WNzyd1FWy7zRl43CD8nxyzAGMfe
	ijYjZNpeGrRPAbl89R/1sHm18tBuPh59UVtnWXG9mTB7ySBsxc667Ut/ajmsswgo8uX4VPdxYhg
	2X9dBDHg02shI6+mrPDD7X2J/mnXt+X8=
X-Gm-Gg: ASbGncsyHB9wU7uPJ07m10L18seVhOyhF/u3VsuhFo0hq/HyE6jrZj1jexUOtDhL+P5
	hFvWc/m3FDrUMr6mDbMnrWevIYILiPdsY86gvkxTYjKPLGJvmhN20UkSzFdUaNWPgUBFNYaxP9a
	3vNefo23Orhh6cbJBsWAl8apEvMsIb/WpUFRdkk3RlHQfBB+r1gyvfaCxK7trnZxnPTC/EoRWX9
	RzMVSxn2NZOEdElfh9OZLbCImG30HTY+H0pL7f6nQ==
X-Google-Smtp-Source: AGHT+IFiOw5ablsLgUKfCaNuQJri4wcztl+zI4ly3LRjrgaXjzgOnqWcpR8ZMzuTHWFg5QDe7h9JoAEutSyQKhvfT4w=
X-Received: by 2002:a05:6512:1291:b0:57d:ffa4:56f4 with SMTP id
 2adb3069b0e04-5906dae5904mr2393608e87.41.1760025589415; Thu, 09 Oct 2025
 08:59:49 -0700 (PDT)
MIME-Version: 1.0
References: <20250810125746.1105476-1-snovitoll@gmail.com> <20250810125746.1105476-2-snovitoll@gmail.com>
 <87ldmv6p5n.ritesh.list@gmail.com>
In-Reply-To: <87ldmv6p5n.ritesh.list@gmail.com>
From: Sabyrzhan Tasbolatov <snovitoll@gmail.com>
Date: Thu, 9 Oct 2025 20:59:32 +0500
X-Gm-Features: AS18NWAnJdcYDP3fsUmpv8ZuZnvVnkv1zMHsU4QWH3X3orZoE8748Ur0FWZohd0
Message-ID: <CACzwLxia6xMcQ=vsYG7SE+pUO8=4DiRWD_Omq3wzRyuhDjGcPQ@mail.gmail.com>
Subject: Re: [PATCH v6 1/2] kasan: introduce ARCH_DEFER_KASAN and unify static
 key across modes
To: Ritesh Harjani <ritesh.list@gmail.com>
Cc: ryabinin.a.a@gmail.com, christophe.leroy@csgroup.eu, bhe@redhat.com, 
	hca@linux.ibm.com, andreyknvl@gmail.com, akpm@linux-foundation.org, 
	zhangqing@loongson.cn, chenhuacai@loongson.cn, davidgow@google.com, 
	glider@google.com, dvyukov@google.com, alexghiti@rivosinc.com, alex@ghiti.fr, 
	agordeev@linux.ibm.com, vincenzo.frascino@arm.com, elver@google.com, 
	kasan-dev@googlegroups.com, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, loongarch@lists.linux.dev, 
	linuxppc-dev@lists.ozlabs.org, linux-riscv@lists.infradead.org, 
	linux-s390@vger.kernel.org, linux-um@lists.infradead.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: rgczbuyy75w8wbmn9fmdt4geuoeeeaz6
X-Rspamd-Queue-Id: 88E584000E
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1760025591-840631
X-HE-Meta: U2FsdGVkX1/7tXifXLs/qfMCCDL/5lLktL4zCJSOISlgDK+pHkCWhrDn0PfY2L3Wfu2zSpixdvwoYrCzjULb6ldy5O+jZjouF5uCD1l3t/wG+bjNCCpPYwZNthIpuBsv4VkfPaCeg28neTnf7Gdso2UpqHKcxwvtob+GRMnSQf3jeeBOzKuGm/m4KYVLEybLYdpyd8DXqIk3oIXbCFE9YZ0LghjyYxiaVr87nkRaRmVygdq4JJ1bnUeyA27q5UGqnGFFwd0ESTRlCJaJhRQTcXKzKTzno9/yYybB3tEQjR47LQ2A4TpQ4yeUduaJ9KaZM/k6rcZoShocWcp5c/U/B4EYYE8NB8U3M/wkZFrSQKra2eAwW7wcT9O4AASYjta0mk1aUf1HnevjYXI+uJpmFOPWkCIm0R/qsKc+jwQcOkHCL5+1T+xmQdFYsoou4eJcMTMVSrpExeZFe0AMAbGfwjpHckjgoPGiZkCSlvRJTVXIizHxQ4HZREPj1aMFhYj9Y70wN5pGoiKCcwXz32SlTLvKuYQYoSmYLuhu/zEcTBMNwTejQNSGBYpJZRnfGB64sBbcUHAYLRkpHTMZWByS75+5+iOvMw8USNWGTGe++6wF5491w5NPmvC3PnlmVQ6AgI3SfuYOeNQHWhDRIanySvlovgp7Ygyl61rglFsd8oEE4hFZOP0VXSHUVc17ahi1T1gxQCYqb0LwcCsPSLx4/qBs5vhV+lPMUYu75x5U4SMPlWspjr98G6mLHI6PRFf6SA7+SME2tbmqIZ+gUiTJjuphhsLeLRvuJ3geegvMT6K4SLdd1exSW1JTmZjWOQI+C3dlwybsZ1vuCNF04VMxzBpbcuprfDgYWDv8ic0L8wmD7AdtHpectVQ/i6aDobsz+RakuJ4Y/gdvcP7JLICExhW5B9t17uSDC/V/XSYn2SBFkRtmvuzuKlz/88avLG2u9ipao6wFRIIDQ/Gx7QV
 RSyREWGo
 WCFejsWwNCh2dkjPaM+9CVsGQ550b2vcd/kB4POJzmHpKWASrxnUyWiJyG9JCxEdUK8rkdmG6+hNvSNb2I0kDxY99BHrAEUpqDLHRj1IO2HjAMkpmlO9ck2XvH08ETyyUc419OV+2JezWHf542eVy6f3hjM1ZrUTwPdEKfGP3D0CsyWwunWyaljRuqQ9patudrdYDj1ElczBquc6u0Q/P70URO6Zzr8j1X4pd9SuAIJ9HpuZUu40Z1IOXA2VHse4r6qIaiUkCVyXpkycTMhL/tkgobH//vmAkldqGqv3r7Rbpbrri+T/QypDp7up8FWTmx5Vnz5gon1vPPyDQUpbUijtrddMUgXc08i5c3UbHF0keiSTF6zZXGoQOZSTvAG9EoM2bKljRLhD8LZj/G5yrrCOU80uiJcgsA4gRelyYvs6Bv3fC/4qlot8i1W/X1AETQeKE6OiIOinxAE+lrBwwlZc1n95mb6MFK88rfWC8IYQ7UqKr3lFFrVD26OxR//LCP2Od27kOERWkTdErIfVI9rhVyBHjEuXo84lmTkfH0soeWbo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 4, 2025 at 5:38=E2=80=AFAM Ritesh Harjani <ritesh.list@gmail.co=
m> wrote:
>
>
> Only book3s64 needs static keys here because of radix v/s hash mode
> selection during runtime. The changes in above for powerpc looks good to
> me. It's a nice cleanup too.
>

Hello,
Thanks for the review and sorry for the late reply. This has already
been merged.
AFAIU, in arch/powerpc/Kconfig

config PPC
...
        select ARCH_NEEDS_DEFER_KASAN if PPC_RADIX_MMU

and in arch/powerpc/platforms/Kconfig.cputype:

config PPC_RADIX_MMU
        bool "Radix MMU Support"
        depends on PPC_BOOK3S_64
        select ARCH_HAS_GIGANTIC_PAGE
        default y

So the KASAN static key is enabled only for PPC_BOOK3S_64 by this
Kconfig selection.
In other git changes like:
arch/powerpc/mm/kasan/init_32.c
arch/powerpc/mm/kasan/init_book3e_64.c

, where we call kasan_init_generic() -> kasan_enable() does nothing because
CONFIG_ARCH_DEFER_KASAN is not selected.

> So feel free to take:
> Reviewed-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com> #powerpc
>
> However I have few comments below...
>
> > @@ -246,7 +255,7 @@ static inline void poison_slab_object(struct kmem_c=
ache *cache, void *object,
> >  bool __kasan_slab_pre_free(struct kmem_cache *cache, void *object,
> >                               unsigned long ip)
> >  {
> > -     if (!kasan_arch_is_ready() || is_kfence_address(object))
> > +     if (is_kfence_address(object))
>
> For changes in mm/kasan/common.c.. you have removed !kasan_enabled()
> check at few places. This seems to be partial revert of commit [1]:
>
>   b3c34245756ada "kasan: catch invalid free before SLUB reinitializes the=
 object"
>
> Can you please explain why this needs to be removed?

kasan_arch_is_ready() was removed here because in
commit 1e338f4d99e6("kasan: introduce ARCH_DEFER_KASAN and unify
static key across modes")
I've unified the check with kasan_enabled() which is already called in
the __wrapper
__kasan_slab_pre_free in include/linux/kasan.h

> Also the explaination of the same should be added in the commit msg too.
>
> [1]: https://lore.kernel.org/all/20240809-kasan-tsbrcu-v8-1-aef4593f9532@=
google.com/
>

