Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F180FC53200
	for <linux-mm@archiver.kernel.org>; Wed, 29 Jul 2026 16:36:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ADB656B0088; Wed, 29 Jul 2026 12:36:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AB2666B0092; Wed, 29 Jul 2026 12:36:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9C7E46B0095; Wed, 29 Jul 2026 12:36:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 6C5036B0088
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 12:36:04 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D1169C0702
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 16:36:03 +0000 (UTC)
X-FDA: 85042366206.06.D327E36
Received: from mail-lf1-f54.google.com (mail-lf1-f54.google.com [209.85.167.54])
	by imf13.hostedemail.com (Postfix) with ESMTP id E6ECD2000E
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 16:36:01 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=PKQ0H8rU;
	spf=pass (imf13.hostedemail.com: domain of souravpanda@google.com designates 209.85.167.54 as permitted sender) smtp.mailfrom=souravpanda@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785342961;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=REfnSoiHAhfzCj23tYELVWqQt7xAhsafs6RnhDeyxck=;
	b=nn0m6d6Vg6GoF40zkXjTpjY/sRyvxzyJUY50/k1OdiNid83G6A2mVVaYo6iGcmKJLbLV8M
	NE63MynhIY3IDouMDDgaDhUy6HqDp36c+24znyBgoivF8h3ZshTf9Z5CqrVX30dLySuXQ7
	Wqi20eNZYOkQxuyJRHkZJ85DdGEdV1U=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1785342961;
	b=5UCRlFgucNUYT9RdcuNBw5uKMla73G557fspY+nk9gV2fLE9LwrqJStBp69MYOMBCpFr30
	yZFTM3FH/9Hso9p3s0W/98Jq0/Ins547gwKOLnYetudHfy8VCl8ZC/srk+oUK+vafWxxi4
	FAZn8jpHvLtl5rPg+dUUl63l38yTGv8=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=PKQ0H8rU;
	spf=pass (imf13.hostedemail.com: domain of souravpanda@google.com designates 209.85.167.54 as permitted sender) smtp.mailfrom=souravpanda@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-lf1-f54.google.com with SMTP id 2adb3069b0e04-5aeb688ae83so8553e87.1
        for <linux-mm@kvack.org>; Wed, 29 Jul 2026 09:36:01 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785342960; cv=none;
        d=google.com; s=arc-20260327;
        b=gBGrx1AULrEw1eWNyPFjAMC3t/4peiWy6rs2+EVSJTa0p9qhOicymyzeXnNnN3mQWd
         7h3mExJz1VvXtayzpQriVrO5wUOoLWUrJNqxsuK8dYdAEwytV/yKvkVGTXc5bqGTRHRM
         2OMeLf53YOq4lh2MhAAK4t4XQYa64dQPPePpHH/dcgGNqnrqlNFWd+CYz38MJN6sPcup
         cG9GHWqCbv2Z4xFOQnjMZmq0A3yMeMvXOrMNLa4uuUhptosMgolDK1qjzwWxNW/z/y6M
         nbR2CQEoBMgctvUduZPU5taqCH05AFLhqTLUa5emM4m8C1rzGLD1Licd+VtfTBZ2oTR0
         qjSg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=REfnSoiHAhfzCj23tYELVWqQt7xAhsafs6RnhDeyxck=;
        fh=EINky7lchw5DKashTku3srEoIwRymgHGcekjh1pA8xw=;
        b=rEtuFELFx/FsQWCdAYeVqY29wXg4mv8YNl4j1pomc7AX3P+FftQ6tK3rKcxtZVnxAB
         m2Uc/1jpcvOhA9hwcpnW8RZgJ3RtNdB3EAl8gertduIATftXjVDyPfu/DEmGIaar0ynT
         zHKrkgvf+KqFLldsxaSAMP77mu/byrJD7y/XSyPltHGBHJz2AmgeTVU4ZoyFQu6Pshtl
         7BSX/jP19/piGWIP0R8QlcfeS6Ssud19MruTRcoOoScDfJL2xZ/0fYL4yokyE5P2EUO5
         UzERSRAb7vAV1EfIC3rYR84F9wR5Dh26Vgx6jF/5AaQkMItHqrasi3OUjBabAGHB6Xan
         9vow==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785342960; x=1785947760; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=REfnSoiHAhfzCj23tYELVWqQt7xAhsafs6RnhDeyxck=;
        b=PKQ0H8rUXdfNh+GbYOpkGjR7AhWeuoZ8qVf4uZ2ILuOdQFQxo3DSWFk2E1gBCNdGYg
         /BOUC0SZbpVjlzWYYPKPbWeL+NX9IVUJb2j0qSwthuuWhJEcbLWKvs2E1XpAlfuUNfVm
         JsBO0cLVFdAG4Flh9B/DBYQnPR5q+jQWoS47lGeQVsDdUYxeI7qL9ZSvqKkUJy/jfMt8
         v/Hm2LlBNNOyuFk3bihFPLo9MOy0UpcISo34badmtIo/mrXDrIUt73ZEWVaEXnnafarf
         g6ekitD4IdYLTng373o+TEt9Y+fy61CV/wmx9FZ8b4wgIMp62oHYKjApZbBrdVm2WU/M
         PEaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785342960; x=1785947760;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=REfnSoiHAhfzCj23tYELVWqQt7xAhsafs6RnhDeyxck=;
        b=my9U6hZtKMtzAKKPkq+SnosSEztGmZbFDmhwvCVcrb0ciEEMOg9QLsuShS34TFTLjW
         ukOQ0Kq1HFIfC3HoiNQivLZ7vPp1BFlYOYGlvJ9LnazhWmYpsY+KdbLEyGsKXvl5bX4N
         sY9GzcBi5x2mFdz+48By2DwCrNB52YvmrFb05JiCToH6SeXhdLDJkY0gqReYPcrsdQTx
         XdUKqaFgWvU9M7Oj9t2NZPRuduaTNTAqjjG/1DR3pNBDxS5oqm+w4q3KxyBRfzy6sW2g
         O50SATpriBpN5bloD82tK1WU5BFrY+wWc2ow+zlNDjXo6oznmNW4KnZWDZguUCLyZyOz
         NUyQ==
X-Forwarded-Encrypted: i=1; AHgh+RrqknGiuMKXi4HiNvf9UJ+WNLu+EZT7CE/1zJCIfnBx4wes/c0YAUG93DWXNkgj8ly1C4bWEs2wlw==@kvack.org
X-Gm-Message-State: AOJu0YwYtgyAxkPfWJS9KwzZyfTl96Nm5idL4x8ur6HoWrmAzzfzZUtw
	WUkTKEfTTvbIHjT1Mm6zk7BlyBmRI4mV5LR4MmjyqEchVsoM1Nd+R604UHvTzPaZNiMGM+iliZ1
	5CHwrV5WkrW4E+9t63i/ipN1ZowV6KDf+U61Dil0/
X-Gm-Gg: AR+sD127k15lreG/KpmVIAlYDN/YFqWCgE141HPN5qQxtpSvLY+AZzRadV6UCc3YL2f
	QESvUgQNrsNkotEl0fgKVWO+rJl08b4Vhzp2Ne2YQ8Pz51jJ0WYKrc1JZ773GZ3j2/cmwB62ctB
	M+USsHB3+XygBcna70PiNONusNBbKhHKKKWLnnJm1J9gksKKUwwZWXBRnPD8CHbyV76btuI/NMh
	KglKOKXEnm7yuyr6jHKLia5onczTpzNaucSsI50DDjh3LaFs7legG8mEhzETLUzuxUgnA9QuWIJ
	vxxlk3Q1y9u8eL4EoJMnF4ygFPeq9x5P2OHZO9FAkD8jjyyxobpfKXM6cAPbqQrNYhNaxFGVMD8
	SaQDdKzbRl/weRklQ+QhY/20aH+LdZAEfuA==
X-Received: by 2002:a05:6512:688d:10b0:5b1:4fd9:ac with SMTP id
 2adb3069b0e04-5b2d9b812b7mr18771e87.3.1785342959533; Wed, 29 Jul 2026
 09:35:59 -0700 (PDT)
MIME-Version: 1.0
References: <20260628190155.3655895-1-souravpanda@google.com> <de52f27f-7248-4f29-b37c-922fcd6e31fa@kernel.org>
In-Reply-To: <de52f27f-7248-4f29-b37c-922fcd6e31fa@kernel.org>
From: Sourav Panda <souravpanda@google.com>
Date: Wed, 29 Jul 2026 09:35:48 -0700
X-Gm-Features: AUfX_mwU1wdow5yJC7UXxS_L13P41I6HX-JyHNPHdsEuNUHg0dxY6zd6CNh3pDs
Message-ID: <CANruzcTFc=X487RsFjsEk6vmyGno6GNvooTwU+Sc=by44Ku+xg@mail.gmail.com>
Subject: Re: [PATCH v2] mm/hugetlb_cma: support percentage-based hugetlb_cma reservation
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: muchun.song@linux.dev, osalvador@suse.de, akpm@linux-foundation.org, 
	surenb@google.com, fvdl@google.com, gthelen@google.com, rientjes@google.com, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: E6ECD2000E
X-Stat-Signature: 5q63w7e1rexsygp99xtpyejaoff1ahta
X-Rspam-User: 
X-HE-Tag: 1785342961-584538
X-HE-Meta: U2FsdGVkX1/4manOScK3Z/YTtiti0qrNp+BLOrGRc0ZdPMEGPRBjhpAgonNLiD8R8uRQXPDW7svSrcwO2cjE2iOUwY65U0hkmyUJaWRzv92OgXS2iHOEoLZY6OaL+d6t+GvdIO3kHgUTy/7Y27tsp166ogeZ3aBwLn3IxJ6dyr4aw1crBKVoDGQ+Qne3hLiDC48J0l1Blqq6nLQnCFemxgB9S+31Xn1M200CmkFwj7ofZpusWk02mhf1/H9y6SuRy/UrxD47r82olGz2xlfHxebLBRlH7bThPSrU6hWG7Wz/Piq0+NREetVeMkpY0vrXuLq9LXV2v/VPEAGDiJ3/ARKVbkMYBWBlk0y4sGhqkU+4xtzRw0VgUe7E/8dQDlyYttDSN0DzW2BvAvIwwgj3C5lIvDtywRXGSnaCcyic5h19xEXeZqiPvrxNqlaOpxf50QXSRtsVu1dRXb8mtrsid2Otjj6Sztdwp2VEIozh6FGXoeX0pG3TsJXAdyzIo31dO7MF1VLZjYhxio5ZzsteeMVdq5kilj25BmOzyjnRpVP3X0OwFQp0zkyr1Ljefjy0QtfjAhXONb3cWf7eJpi2GID/uNAm/i+Am5hqTIy+wHw+yZSuwfH6jm0CUJPPADdKGNSK8dgHXjKC8fLSfyY6IEXps6G2xGxzqsvwkzLHJcfnQp/xt8PwuYXB1AG53aJaUjZieLNl7xnpCv2zp5pzbS/jW3ZOR99l7y8vG03hZHF+hmw86Hxpd5Spaklvl1qcrXL5A6ypnnrLAX+AUYwOwQw5CBCD9h4TIz3M01UWn+Rhdqya5/PLrH/t2xBgRvMvUJpJTHN4sjGK+zQ7t3CDT9poNxRm013X7JXEfobkWHoZFPLTjcM+PO1T3dj75mZkxm27m8bFa4AX9hRkXiNZYuo1o230pSianO24uaHlNWkzNfS5Bw0giKB70T7wW0d0iV/Ps+EEX6FcaqReors
 hZGyX/Kd
 ri5vyDbCv125nhmBax7W7yhX2kFltXalj41757p22n+KHezd6pLJSGvcB7zhCBvpxjhhQVcmY/PIZnq5VwNvtZIZMtEI5ZtatS9gskVWQbrlyd8UZ2r254CqAxJsHR83Ago73L0Fe/geo0GcfOUfTivIl4ZvUULaXOT4zp1iO4/+n7VKFduoN2DsEymWIfLIGK/AZFD7MIJM9r5vrTTqKKdQDehdJu961ZqZORapF8Ssq4ZVijajGslCwuGesbYklQJZ5xfHZr5ZM6lmOYswhp1NiJg1UPuNrFuA8rgDWrstyyMAUzcHM1PsYOjzZ+AFV4hgNnzx+akW7kUa3wKWTyKLJFNyvSA/hrNVf
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 29, 2026 at 1:52=E2=80=AFAM David Hildenbrand (Arm)
<david@kernel.org> wrote:
>
> On 6/28/26 21:01, Sourav Panda wrote:
> > Currently, hugetlb_cma reservation only supports absolute sizes (e.g.,
> > hugetlb_cma=3D2G or hugetlb_cma=3D0:1G,1:1G). This can be restrictive i=
n
> > heterogeneous environments or when deploying common kernel command line=
s
> > across machines with different memory capacities.
> >
> > Add support for percentage-based hugetlb_cma reservation (e.g.,
> > hugetlb_cma=3D20% or hugetlb_cma=3D0:20%,1:10%).
> >
> > The percentage is calculated against the total memory (for global
> > settings) or against the node-specific memory (for node-specific
> > settings) using memblock APIs during early boot.
> >
> > Signed-off-by: Sourav Panda <souravpanda@google.com>
> > Reported-by: kernel test robot <lkp@intel.com>
> > Closes: https://lore.kernel.org/oe-kbuild-all/202606262023.IKUrn01I-lkp=
@intel.com/
> > ---
> > Link: https://lore.kernel.org/linux-mm/20260625215900.2151690-1-souravp=
anda@google.com/ [v1]
> >
> > v2:
> > - Use mul_u64_u32_div() instead of mult_frac() to avoid 64-bit division=
 on 32-bit architectures (Reported by kernel test robot).
> > - Fix physical memory size truncation on 32-bit PAE by using phys_addr_=
t in memblock_node_memory_size() (Sashiko).
> > - Fix boot parameter override logic to respect standard last-one-wins p=
recedence by clearing opposite values during parsing and clearing node-spec=
ific values when global values are parsed.
> >  .../admin-guide/kernel-parameters.txt         |  7 +-
> >  mm/hugetlb_cma.c                              | 96 ++++++++++++++++++-
> >  2 files changed, 97 insertions(+), 6 deletions(-)
>
> What's the status of this? Reading the comments I assume a v3?

Thanks David for checking.

Just sent v3: https://lore.kernel.org/linux-mm/20260729163148.3271755-1-sou=
ravpanda@google.com/

>
> --
> Cheers,
>
> David

