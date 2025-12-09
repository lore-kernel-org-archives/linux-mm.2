Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 65305D1CDC6
	for <linux-mm@archiver.kernel.org>; Tue,  9 Dec 2025 09:43:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BA7146B0008; Tue,  9 Dec 2025 04:43:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B7ECF6B000A; Tue,  9 Dec 2025 04:43:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A94D56B000C; Tue,  9 Dec 2025 04:43:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 9709B6B0008
	for <linux-mm@kvack.org>; Tue,  9 Dec 2025 04:43:52 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 31C48B993D
	for <linux-mm@kvack.org>; Tue,  9 Dec 2025 09:43:52 +0000 (UTC)
X-FDA: 84199445904.19.8702DBC
Received: from mail-ot1-f67.google.com (mail-ot1-f67.google.com [209.85.210.67])
	by imf13.hostedemail.com (Postfix) with ESMTP id 4B27B20011
	for <linux-mm@kvack.org>; Tue,  9 Dec 2025 09:43:50 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=EgoCMS1Q;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf13.hostedemail.com: domain of haoli.tcs@gmail.com designates 209.85.210.67 as permitted sender) smtp.mailfrom=haoli.tcs@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765273430; a=rsa-sha256;
	cv=none;
	b=iATUHXn3TSuGc54kIeEmZyrkXJRfvME4RRAsQHgaFPmMo4f8HS9RmvR9BONHT//34Xy9dy
	iGcG3kSvtQKF+prRCXDWrslihI+Tr7LXwImcQWebTrpaHZykf53v6KfscYYbvS97pvNU+p
	4Qbr0kIWSZWctAWbTCmYzleBJOHdz4k=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=EgoCMS1Q;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf13.hostedemail.com: domain of haoli.tcs@gmail.com designates 209.85.210.67 as permitted sender) smtp.mailfrom=haoli.tcs@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765273430;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MUmGYBiGWNpLts2NDyHiFgi5lTJLsPjA/UugWflgesU=;
	b=yedRwnMHaPbVTIxOjnG7+bmnBD8jSKMBOO29vK61amLGHFl5MW2JMGoucbDS4I9c9A2vUu
	NN5gELHZSX1CFfOymgzY9XF2kZK6k+J20j5+N38OR/KqQmZOQcFbOzSVRfIC2bFKc16IAO
	8cg5AZcguCuvM7E9bO0ZWnLKMR6W3w0=
Received: by mail-ot1-f67.google.com with SMTP id 46e09a7af769-7c6d1ebb0c4so4391128a34.1
        for <linux-mm@kvack.org>; Tue, 09 Dec 2025 01:43:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765273429; x=1765878229; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MUmGYBiGWNpLts2NDyHiFgi5lTJLsPjA/UugWflgesU=;
        b=EgoCMS1Qag9bPtUlsvVicm2SKPDan/mQ9zyXtUj8LLCbipoF28aWfUt2MBcB+pKGu9
         F4YOmNWUyjcRaZfj0HUAW2AkaqSrZs0LjH08k5MWKrY+dV3lPgjjv36HkhbbWZrAO6dW
         bjhsWyOvgF6+R9VTbokzTLIshnkGWMlRAYQxSm9N8Ufv79UOBlbqoIFD9LczcR0giLxF
         GOy3EZwaH3C9rUqgftS4me7kt7pTGvEa/fjlC5Y19yTGLQwxHijzH47wlTy1zlG1Avk9
         w6BQf6DNxILIZ9X47/Jndzk1yQrICXtrYP3ZLD6exVhXYk4Aw7rVuoUSJ/TgR07MpIfi
         0JXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765273429; x=1765878229;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=MUmGYBiGWNpLts2NDyHiFgi5lTJLsPjA/UugWflgesU=;
        b=DCVCHK9ii/6tNdvRU40umCg50Cgn194BU6xLSP/ybGheFQveVZp5TgXAQLqjFqSjc3
         4d5b5RDhd+aYUIP8XZCe1xl4wTP3PfZ4z8rAT9/qSW5Ubh6x7qaUejagEWXTBaIHEzTS
         b7zQR3b8jCxAcAX2Xi1MGe7gt50SmULfOiCfMT2I+NO/pcCTyVpaWVm9zznH1VLrsUr3
         ORA52M4ZNfRoODYrPDU43o3CpSlHjXhU2GRs2c20TIKMsUAFpyn40r28WnoDt0vk3OpC
         yE8GbvN4li89pSoeZWJgfV3Ah19sahahHpYcXHHt+q8wo/3EXePHWfweI5kCa4hKIa5p
         RQCw==
X-Forwarded-Encrypted: i=1; AJvYcCUAQ5S4z7rcnoCe78SYvOE/URHV1VCjFjFksuS/HnfPM1lGNsfmU0nUx5Dkk3MIylmwjhVP0PHmFg==@kvack.org
X-Gm-Message-State: AOJu0Yyr+ytJ9neChZ471NIJf03+fu3ES+HmyIlFJU9KYEVugUEtgkGV
	xmasCjHHvSzl/05ucUAyYXNcrjrsjaEx7BGBAtZswPput/W65qRwbVya0+CPnDlyVf3reJQa20x
	CbVKTOceeZSFyRPaXielFeggq36KSK78=
X-Gm-Gg: ASbGncsgBRmW5PgHJgaairIKdqXnR+zFVzF9VS3f78tbqZhcf/ko0BNUmoi/hOlw8sR
	/hXQzF08Ts/RlmqFu6knDvmm7aO6/+jpJKAqmyvQgMTqa+I4fmrytjEQR+yx+MZdVjvz1fyfdUf
	nj3t08ABHdvaqY+S46LDgmOnF6bDsmYtCzA5c96Sy5KYH/cr4BQqumyY/S3sCMBUeyniZPEK7Lp
	oFRymQNw7sF4CdB1tiUG8fP0CCqCeShFh6pj/C8OaOr0NUXIY9R3mCmuOfMgfwlsoC+qwzyQw==
X-Google-Smtp-Source: AGHT+IFv9IpaqkBeUd86Nr3OuDzklG3yFLqBXbMjhf/Mnoiu1eFqfKKJ8fJymN964DrgEiph0Yx66JMNRrgic7biNC4=
X-Received: by 2002:a05:6830:2115:b0:7b2:aba7:f4e with SMTP id
 46e09a7af769-7c970752562mr5668508a34.10.1765273429418; Tue, 09 Dec 2025
 01:43:49 -0800 (PST)
MIME-Version: 1.0
References: <20250910-slub-percpu-caches-v8-0-ca3099d8352c@suse.cz>
 <20250910-slub-percpu-caches-v8-3-ca3099d8352c@suse.cz> <lvagftdnxgpyafafl2ish6x6phno6xstd6r3zxffs652lyxzyc@2pbngufu7wro>
 <aS_OrvHmgyhQzQIj@hyeyoo> <dq67tbm6bbvm7opvuq5vwtjjrcnrponmhfv7xwnvpv6vp3u2lv@bkruq4dtx3rd>
 <aTWIQ0s3EbOa0azX@hyeyoo> <8bbbaa65-2783-4006-97b4-a1628525e7c7@suse.cz> <aTeLzFrc6EA2yTzk@hyeyoo>
In-Reply-To: <aTeLzFrc6EA2yTzk@hyeyoo>
From: Hao Li <haoli.tcs@gmail.com>
Date: Tue, 9 Dec 2025 17:43:38 +0800
X-Gm-Features: AQt7F2qOPq2FORbgnnaGiFBv2DPLqnw1zxgZR0HoDLae5rm3U726fF5yoLqzoqQ
Message-ID: <CAAXMevqBFNO70N9+-ZGSEVmvs3fiF27g9WzP2W4uaXHhDkFFUQ@mail.gmail.com>
Subject: Re: slub: add barn_get_full_sheaf() and refine empty-main sheaf replacement
To: Harry Yoo <harry.yoo@oracle.com>
Cc: Vlastimil Babka <vbabka@suse.cz>, Suren Baghdasaryan <surenb@google.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Christoph Lameter <cl@gentwo.org>, 
	David Rientjes <rientjes@google.com>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Uladzislau Rezki <urezki@gmail.com>, Sidhartha Kumar <sidhartha.kumar@oracle.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, rcu@vger.kernel.org, 
	maple-tree@lists.infradead.org, Venkat Rao Bagalkote <venkat88@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 4B27B20011
X-Stat-Signature: bzp6pfxibi19arpoz1j6g41c4erqgc7s
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1765273430-225513
X-HE-Meta: U2FsdGVkX1+ORWfCGiAEnRX4W7SQQlEBRHaizwyGTPJTpegIjNm5+hGiFuntVohTWIYLp172JjTMMuaqPKw+OT78IdEM2TL5+2S7YM1UIKlGI+7oX+sBx48bTd0KF8ZYRn5Xu+tdom+ePlPz00KARJN+rMzWo//X++NWahQHkkhOVB9RNill9Otdx+aEldNEPmweSR1wZ+r2fAxU6r0UMBiZXU7zSlg1jqDgpKbj6nw6rJArZp/CL9GIoXjV1YkeNZmYeiUcNXjePGTa9YPt49n37ldl8Pz2GigheqFmvqfuMh9gvTpRCMW+F9woQiIzuQ2bSUgjmbbqVT6oV0PCOgCfn+blnOX+9yQFVPci6mQ20BQwnurTsZkwNjmE18jsWAO+yUl2IzYd3hqe+ImW0fONlubTJkvQhHWGKEUjYa+4X6v9M4s6xKOMSC2PWxkroJkTJLiPv6mUe2QsjsBSvG7wAU90vTKJekupOJr9zcazpmkIpu+wpz2kiwRW2+MnKATK3bX04SfjQCxLraWd7860I3c9/FqK5XI+GbSB7h6biGZQLyg2cA3LmzuXFm6ROXc6gbB+JDaUlqLRnLSj0o2VKe/Y1fhtj0YacaXJ+IFjcyKeASR14eTgHGSOVUC+b/8q7POfbCGQ9QvXLqUP+3DvD0b0hwNEpPFx5pJQF2aIS7GdKGiJSvEZSUD06GNg082LyKo383TYfxYec0P37Mn3p+QJyyiHf3JA1dpbiXmU/muTLsZ/rf9fOpJBJOYcQrN0EFqrg/1tGW/q8wFLVIe2ZkCedhbJHRpH0ew0tZRiqfzlzLdbCp87DG7M0yuaiyULCNBoiHBzoufSXD5AsjDMtPTldoJgOr+Yxq3icCBYoShQ8fNXAHipmaBqKSatrZ5V/IAy8MnPx4EZfHEAHYqs8bh13LrXdXRlLk3plYqbTnqZ+yCCEA9uKHuus372z3PDiKsbp5qMz7EB2Ri
 1bpqSB7T
 f42BGS7UKJqzFxGWEWu87ffvELQpquC2hCIJFn+ZUPw9Koh3ExCiEBrrhegJNPGRjwN8OGBOsIwKtjlKIZ5U4JPPMH4yrTuQkzXdKlr98IJfgoMUyOezK53rPa8jwJgyEV6i+vddYxqJXLXxVLHUbfw3vvxgE3F4PU8/RltWdqPY4OxaXUfY2d0SBm1aCdJE/2tL2BrV+wkKkIn7+C0hZohcrS/djF35KxnlFTmp4SdhwKWP7pgQTwVgOKXjH1seR1luA4Yko/GwS3yEtOscPoX5hEdrYfKnrlWeWiLJQueaUibkBlddMDwpXLj0nkUzTJhPeQ110vm+At/8UzPtFH9soPV5mq4y42dKGgqqcAHuAHx65JQ/PCI32hjsSXe96TMBNdJ6B2rOjHDEHHuFPnV+4bDL8rBP0ixzfxnuHUizwgOYV8HE8fkbL+pUOsHzTMA5BfzJW+Or12lixps3YWeLE/EadYKZFPBQHTHYEOngY87tM8Z131CccKex9LzNGVFFeV3PH+Oekke/sSVjJRDMDdJk1JiPyI+tCn+rjZeFFzMRprpZU+ZtXhavH1MwOh4+bVRIKw3+WxQEGMdco7F0L0Dp99qI1/Stj
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Dec 9, 2025 at 10:39=E2=80=AFAM Harry Yoo <harry.yoo@oracle.com> wr=
ote:
>
> On Mon, Dec 08, 2025 at 07:51:40PM +0100, Vlastimil Babka wrote:
> > On 12/7/25 14:59, Harry Yoo wrote:
> > > On Wed, Dec 03, 2025 at 07:15:12PM +0800, Hao Li wrote:
> > >> On Wed, Dec 03, 2025 at 02:46:22PM +0900, Harry Yoo wrote:
> > >> > On Tue, Dec 02, 2025 at 05:00:08PM +0800, Hao Li wrote:
> > >> > > Introduce barn_get_full_sheaf(), a helper that detaches a full s=
heaf from
> > >> > > the per-node barn without requiring an empty sheaf in exchange.
> > >> > >
> > >> > > Use this helper in __pcs_replace_empty_main() to change how an e=
mpty main
> > >> > > per-CPU sheaf is handled:
> > >> > >
> > >> > >   - If pcs->spare is NULL and pcs->main is empty, first try to o=
btain a
> > >> > >     full sheaf from the barn via barn_get_full_sheaf(). On succe=
ss, park
> > >> > >     the empty main sheaf in pcs->spare and install the full shea=
f as the
> > >> > >     new pcs->main.
> > >> > >
> > >> > >   - If pcs->spare already exists and has objects, keep the exist=
ing
> > >> > >     behavior of simply swapping pcs->main and pcs->spare.
> > >> > >
> > >> > >   - Only when both pcs->main and pcs->spare are empty do we fall=
 back to
> > >> > >     barn_replace_empty_sheaf() and trade the empty main sheaf in=
to the
> > >> > >     barn in exchange for a full one.
> > >> >
> > >> > Hi Hao,
> > >> >
> > >> > Yeah this is a very subtle difference between __pcs_replace_full_m=
ain()
> > >> > and __pcs_replace_empty_main(), that the former installs the full =
main
> > >> > sheaf in pcs->spare, while the latter replaces the empty main shea=
f with
> > >> > a full sheaf from the barn without populating pcs->spare.
> > >>
> > >> Exactly.
> > >>
> > >> > Is it intentional, Vlastimil?
> > >
> > > Let's first see if Vlastimil had an intention, and...
> >
> > Hm I don't think I aimed to make this difference on purpose, but I didn=
't
> > also aim to make the alloc/free paths completely symmetric. Rather the =
goal
> > was just to do what seemed the best option in each situation. And proba=
bly
> > getting a full sheaf and populating spare never seemed to be an importa=
nt
> > case to warrant the extra code for a situation that's only transient af=
ter
> > boot (see below).
> >
> > >> > > This makes the empty-main path more symmetric with __pcs_replace=
_full_main(),
> > >> > > which for a full main sheaf parks the full sheaf in pcs->spare a=
nd pulls an
> > >> > > empty sheaf from the barn. It also matches the documented design=
 more closely:
> > >> > >
> > >> > >   "When both percpu sheaves are found empty during an allocation=
, an empty
> > >> > >    sheaf may be replaced with a full one from the per-node barn.=
"
> > >> >
> > >> > I'm not convinced that this change is worthwhile by adding more co=
de;
> > >> > you probably need to make a stronger argument for why it should be=
 done.
> > >>
> > >> Hi Harry,
> > >>
> > >> Let me explain my intuition in more detail.
> > >>
> > >> Previously, when pcs->main was empty and pcs->spare was NULL, we use=
d
> > >> barn_replace_empty_sheaf() to trade the empty main sheaf into the ba=
rn
> > >> in exchange for a full one. As a result, pcs->main became full, but
> > >> pcs->spare remained NULL. Later, when frees filled pcs->main again,
> > >> __pcs_replace_full_main() had to call into the barn to obtain an emp=
ty
> > >> sheaf, because there was still no local spare to use.
> >
> > As Harry suggests, that assumes a specific pattern where we exhaust mai=
n
> > sheaf first and then we fill it fully back.
>
> Right.
>
> > But even then this can only
> > happen once per cpu and then we have populated the spare and are very
> > unlikely to run into this situation again.
>
> Good point!
>
> > Also it's unlikely that full sheaves even exist in the barn during this
> > early stage when we would request them. That assumes cpus behave differ=
ently
> > and some have returned full sheaves to the barn before other cpus have
> > consumed their first full sheaf and request another.
>
> Right.
>
> > More likely both barn_replace_empty_sheaf() and barn_get_empty_sheaf() =
will
> > fail and we do alloc_full_sheaf().
> >
> > And then... I think I can see an issue in
> > __pcs_replace_empty_main() that's more likely to be suboptimal than the=
 lack
> > of symmetry you point out.
>
> > When we reach the last part below "we can reach
> > here only when gfpflags_allow_blocking..." and we have empty pcs->main,=
 a
> > full sheaf from alloc_full_sheaf() and no spare, we should be doing
> > "pcs->spare =3D pcs->main" and not barn_put_empty_sheaf(). Right? This =
is what
> > can delay populating the spare more likely I think.
>
> That makes sense to me.
>
> > >> With this patch, when pcs->main is empty and pcs->spare is NULL,
> > >> __pcs_replace_empty_main() instead uses barn_get_full_sheaf() to pul=
l a
> > >> full sheaf from the barn while keeping the now=E2=80=91empty main sh=
eaf locally
> > >> as pcs->spare. The next time pcs->main becomes full,
> > >> __pcs_replace_full_main() can simply swap main and spare, with no ba=
rn
> > >> operations and no need to allocate a new empty sheaf.
> > >
> > > I'm not still sure that either way is superior, as it really depends =
on
> > > the alloc/free pattern. If the CPU keeps allocating more objects, kee=
ping
> > > the empty sheaf is unnecessary, but we don't know what the alloc/free
> > > pattern will be.
> >
> > Yeah.
> >
> > > So strong opinion from me, but I think it'd be better make
> > > __pcs_replace_{full,empty}_main() handle it consistently,
> > > if there is no special intention.
> >
> > I'd rather see some numbers. But the suboptimality pointed out above is=
 more
> > obvious to me. Do you agree and want to send a patch? :)
>
> I agree and would like Hao Li to try this path as he raised this topic,
> if he's interested ;)

Thanks Harry for reviewing and letting me work on this as a newcomer to SLU=
B.

>
> > >> In other words, although we still need one barn operation when main
> > >> first becomes empty in __pcs_replace_empty_main(), we avoid a future
> > >> barn operation on the subsequent =E2=80=9Cmain full=E2=80=9D path in
> > >> __pcs_replace_full_main.
> > >>
> > >> Thanks.
> > >>
> > >> >
> > >> > > Signed-off-by: Hao Li <haoli.tcs@gmail.com>
>
> --
> Cheers,
> Harry / Hyeonggon

