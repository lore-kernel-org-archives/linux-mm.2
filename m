Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E2524C88E6F
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 20:57:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F32BE6B008C; Mon, 14 Sep 2026 16:57:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EE3F36B0092; Mon, 14 Sep 2026 16:57:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DFB2A6B0093; Mon, 14 Sep 2026 16:57:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id BAE236B008C
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 16:57:27 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 3F1A6C024F
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 20:57:27 +0000 (UTC)
X-FDA: 85213578534.29.6EF1FC2
Received: from mail-qk2-f12.google.com (mail-qk2-f12.google.com [74.125.230.204])
	by imf01.hostedemail.com (Postfix) with ESMTP id 513F440009
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 20:57:25 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=u0SNaLja;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf01.hostedemail.com: domain of surenb@google.com designates 74.125.230.204 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789419445;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tJlt6R5lZve0l4Ih2XY+XXFC+R8xsQxnNIxnXABtymc=;
	b=6ib3pTSXfJwB1ienl240uDHqnRm8EpuoMFH+7KWWbgFkNqsXGwBUWaJh47Ku0Ha7adDxez
	B3TkpnL1XA1pQPdeg1vXmFQwPcddEGJLBXMu96A2knzd/E1e6Z7jfpuQDg6SgCy+e601dC
	7lI/Lr/7UG46Qubcxkt0GdNFn46Dq9E=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=u0SNaLja;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf01.hostedemail.com: domain of surenb@google.com designates 74.125.230.204 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1789419445;
	b=hWPDJGpnCsGHPVxYcOb4z2LkA9pFtI30R4rlw+WY5Sh+812XBnnj1rHE50d6DXgBItC14E
	vHxfEnqsC9LeP2deN4yZUPTDbg+BG+5jJJbCptDXfnJ8q/iciqANqDAvwbAItgvLHsYg0j
	glNotwq7vgBXQs9yM45D2nQmk13PO1o=
Received: by mail-qk2-f12.google.com with SMTP id d75a77b69052e-530d5fc2cd8so1721cf.1
        for <linux-mm@kvack.org>; Mon, 14 Sep 2026 13:57:25 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789419444; cv=none;
        d=google.com; s=arc-20260327;
        b=kKF4XOZ1rdElp0dRQM0uFt31hcH/AtRQwyTigw3+evJpx43+5uZYjFBMAYdXVkw/aO
         lvAO7APE4FUqm5MYaOreUh36xU309nkOkfWM42tDtL03oNg1jqE/UBXY9Xnd7gY3esXs
         sktq89AecbKIogM/P+pIu0Oa+mJY0fXUPrx+JWaySDpVFvTgYwEJ8yQY4FRWk7HCuAIE
         FhU2tEN8iGQNbBA8DoJyWUKPA/8FW8hJAu3DSN+kWjoZwavIQbUg3Fd9oTPsO8lfNg7G
         vThfr9ELHK84moVs9OnchLlbBtg8/rrWtuCVuBWHt9PEmkLN00m7vjzoIEjvvG8Oo/Wg
         p6Eg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=tJlt6R5lZve0l4Ih2XY+XXFC+R8xsQxnNIxnXABtymc=;
        fh=XDoe+V3BF6jrsPwNCTngTN806yt4OdvwWkJxRabDWSA=;
        b=NQVyjEMA68MPFNKMwSf8o7slNjNzKRTjTlB/KjxPRX08+YaMtS5HP+9b0AY8julioK
         LS9tUVDNW9BuvLjHWfyq61snei0F8c6dGr3+h9yLglpcfRAS0nAqLRdKdRqUk4EDmWqZ
         EbJyFL9nhrwizvPPHfeBYazPZx/YJQb4N7DqpFyo17wiSIYSxt+o8KYa5JHXo1bt8O/2
         aoEpEDSukVOq1pw8F0jBRZUsqfKAc4KPPA8y8O9Uov8skqC4tSQVuUzswGwwkN66SIBJ
         SIR27St9SxVpCj9zGYUSKCcZsgfCqGVqxhTvLLY06X7Ter7K7tClsc2gqfOJkzznJqQ9
         t57A==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1789419444; x=1790024244; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=tJlt6R5lZve0l4Ih2XY+XXFC+R8xsQxnNIxnXABtymc=;
        b=u0SNaLjaBkVYwx0/S0wEKYtQmOUGGDmOR80IuKrZCGRIH8vyd3SnGyx+mNObi9ciNj
         nNv/RiptDGe6dx8lz/karXWXUhgh8O7S8bfJH+Z46ovKg0N0sfrG2hxDiBr5NJJ43Z8E
         jsTYFw5MWzc6P6IIf9TO55L+Etk2/bR6b6F9mmRFpVWbr9/BX6JvBPbw9z2zy6P2zpbg
         OKWjWJ82fNW/XR77Tsuqy4QV5ar59ecZe3yvhxrm4H9yStXVZIIkmXYo0t4AX2d+zcYX
         EztmWKVVsW7Yyc3UYj6uFD7wFXjc1U3Zz3AaR3/lrPc9H+LSL16lkFDpjDmTEce0d+CG
         uIfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789419444; x=1790024244;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=tJlt6R5lZve0l4Ih2XY+XXFC+R8xsQxnNIxnXABtymc=;
        b=NjhYqhf9kaQmV4RJ9JpVQKuykkQ8GWlS0/p2eMSVvYspRiPST0vSmqFYaXh/4QB2I9
         cgqVZDP/Pe/bqCaWLpL3BIm/fiaFKmAqRCy+Zgs7MYaeygvK01KVnA4yTNVkpn9oEfwx
         hG3ptaY3ZhPWE5JUY3nLUu727ehTX1xV2w1tXTEpDDhnvm2g+bglN5DiW5pSs1roS9RZ
         mG2WXWMnxq79l44+Om3Fd/d28Itzu37aBv+4zZM4ydBhv/IW4rITbh+8PDpt5c8C3jq6
         44O0vDwwFSfr2G4qIrUOa+yUVbPyDhrEcMfdxHYcxMMaQAkGddvbQ/SSeF6LkQs2n+Ev
         71Kw==
X-Forwarded-Encrypted: i=1; AKwUvBwAlkQ/dxCsOD05B7iFmBIt8nk9WP1o1oyJSQE6ZVQ4vssw3GOjSVFRezWmjGYuOgA3WROeN4DHbw==@kvack.org
X-Gm-Message-State: AFuF++k8l/cNjN6Jfpkxl8Ge6HZae2wVWrlmnLRbA5fxWIIYqafGDSCA
	JXUDdY5xjHq/DVhs9KNt+8RqQaBrvKWxcBnaMZ8LvxITu57+DNMPE5wdlqaoFHDFM9rxg2xvG1c
	jKPe0Xcqos+cIMZ04f87ic+qh1mCyBbvctmZW22lh
X-Gm-Gg: AYBFou0U9DTgcZNN7GG38Q/54a1lfbDXuvclgl/IeBtpol+v4d2t1W8JY4KI2PeXg6I
	NhoFi+c5MZkwQViQNOjYG54DGJBNZ22cpZ99rwlhQNG1+4+AcNP0x4QRbhw9VVh5NCodaPTs3Mg
	ihdVqxJaTsI2Sb/o6/78LWGURHNJhDKSTXtDofvoh03f9lCLJkFwYB5UvpSD/NFOSHPlEFz/4bB
	kkYxZ5x9gDmK9ktvle6QATo9p65sQjYv120fWgFxtuuKSEZk+KpOXN1x2Fbq0FOougosjfU+1qB
	JBO7Qvqt6x62dgWC9NQ55NFDa5WlSYpjUTTCeJjGgjJYFq+EjjhLZw==
X-Received: by 2002:ac8:5a54:0:b0:531:282:6560 with SMTP id
 d75a77b69052e-5311c823c52mr1239381cf.15.1789419443661; Mon, 14 Sep 2026
 13:57:23 -0700 (PDT)
MIME-Version: 1.0
References: <20260914190631.3167420-1-surenb@google.com> <20260914124223.3ce35057f35313d7c2a6254d@linux-foundation.org>
 <CAJuCfpFoWjM61tFLiZ79ufr7TLvWBarP--nmtHCm7OdiY-95Gg@mail.gmail.com> <20260914135559.5784327913c6247fcddba4e0@linux-foundation.org>
In-Reply-To: <20260914135559.5784327913c6247fcddba4e0@linux-foundation.org>
From: Suren Baghdasaryan <surenb@google.com>
Date: Mon, 14 Sep 2026 13:57:11 -0700
X-Gm-Features: AcwNN1XL6L6O3qVtSq8SnqnzFSGxCfMDT2pGuzzKhpjeJ2K9xb0flUDDPlk8I10
Message-ID: <CAJuCfpEv2k+Z7q14UUpFXDL9_=Q66Gdemf0s=NXyXm4DLbWAcA@mail.gmail.com>
Subject: Re: [PATCH 1/1] proc/task_mmu: remove unnecessary inlines in function definitions
To: Andrew Morton <akpm@linux-foundation.org>
Cc: david@kernel.org, liam@infradead.org, ljs@kernel.org, linux-mm@kvack.org, 
	kernel test robot <lkp@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Stat-Signature: d9i8t8or6igiq31yaqjuwicddjjzaphw
X-Rspamd-Queue-Id: 513F440009
X-Rspamd-Server: rspam07
X-HE-Tag: 1789419445-573012
X-HE-Meta: U2FsdGVkX1+4877SwKvNxqIaBnXg6QAQaCiYJtkbEE/7JrpElXxf3G3ujN4SBtHQ49VD+Ua16AukS7j+m7hls6ijQgsmImV6zRvYhLE9alAmiAmk0BRq58XpHUmgbM5hiNko3QSdpcz65xKERwwkmRj/IUT0Xrd919cGAVWJVXCqx6/VY2XHFRlTGR2hDMY09yoWNNBubkSQKC2yrV4MgqYrdGmOmAOc3mGefagAGtHqgTUWFiZsjyc7YZ2/skceLfPJRhjBatM3z2lW8baoop1J97M5USXVTOGmM19zGI8NeNA0hgz8oFoVS8HM4apEopsyCinh7iY+1EFJj5A0IJ5QMJK3IqU9xi1X6FujgQ/lxAB2poFSpixnvunDMK3d457HebB8MHPUXYJm7nKhO5TH/agcVxykNQi1PWV2kp6o/T3N0EHhcawVFnT7DFTLHmMZEEoIQhdoaD+MiEXPPSJ2ws21kLwSRHhiGcMPNUjJfiGcwbPzAJs5gLunSBi3EMbG5LUfRBvBy0Bqyr0IY6bZqH5JUT54UtGKV7vrJXJFDWgSDAMRp9nzqxmeFv9o0rxk76A9b92mLqn8xL9E5p0wBHuDTZgETnA2TFZH9+zF/PcxvC1kwd2SsUu0QUNiv9SlNiUC3ceeVJhDHiuMSAO8e1uXIdQyq+XzPoun2OCavGXuBe87g48TqKZCUmNgG6G1miY/urWiIwQBG/BNbqmmcIxwv0wJHb0HSO85jFsACjk+GSmByx3mqWZpUMQyH4Y4rMtUpgkwSLPyxqVkcBQLAMPCUgANJhEAi/GtuozDreBPntIA7lACtHzdFBEeuZQRPkkuQ8N8ij9ap03se3R1a5xTBhTEsGdJ1F3gjZB4PEfT2Iqn7Tkw8oM2u2d0D6dMoCGBZolm4K2PTbb90lNZ4L5xgsFDtD4NTYVvIlj5RaID6J2PFbXlfcc8Yrdb9aqEHoly//FTZ6wbv7e
 wIZmrOfX
 XhYSar2pPCJ4+REjK9+Sz3trOmp6u5b8FhHRoZdh6FPai0DDm4k1llhZt500s0KFwXlcOBI4kFQhE08Kx7KXkPf7+ob/rY8i1ahNfmk7/RrKltsb4MHaeNU37SqfCzgTGcp3vl2mc7pjowNA7u0FrFBGFvYpXtnlHhvMAiufeKHSoYMlLdYQzPICq6MmdTeFThtC7LWjp3jh2HWR9mlxwcLX+ZYa6OmQGAQhc/yKlMp0djkLlAoEZpINLYKamr9CQm3+ZthMFb/YBwL1+pt9FsC/brA56UNzia0XwAfKsCR9pOWGu/W1egZJ76KhzGuEkgmb0A2qEV2Bh5F7TRZR+nez6+24Q2RgBk14jHP5Au/f3Klw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 14, 2026 at 1:56=E2=80=AFPM Andrew Morton <akpm@linux-foundatio=
n.org> wrote:
>
> On Mon, 14 Sep 2026 13:11:52 -0700 Suren Baghdasaryan <surenb@google.com>=
 wrote:
>
> > On Mon, Sep 14, 2026 at 12:42=E2=80=AFPM Andrew Morton
> > <akpm@linux-foundation.org> wrote:
> > >
> > > On Mon, 14 Sep 2026 12:06:31 -0700 Suren Baghdasaryan <surenb@google.=
com> wrote:
> > >
> > > > Uninlined drop_rcu() and reacquire_rcu() functions are not used whe=
n
> > > > CONFIG_PROC_PAGE_MONITOR=3Dn. Exclure them in this configuration.
> > > >
> > >
> > > But there's also
> > >
> > > fs/proc/task_mmu.c:133:12: warning: 'lock_ctx_mm' defined but not use=
d [-Wunused-function]
> > >   133 | static int lock_ctx_mm(struct proc_maps_locking_ctx *lock_ctx=
)
> > >       |            ^~~~~~~~~~~
> >
> > Ugh! This function is removed in later patches...
>
> Yes.  So it's a compile-time bisection hole, which is probably the
> worst kind of bisection hole.
>
> > Should I just repost
> > v5 instead of fixing up in different places?
>
> That would be best.  Leave it a few days, we'll survive.

Ack. I'll post v5 on Thursday if nothing else blows up.

