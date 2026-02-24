Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 359C8F4BB93
	for <linux-mm@archiver.kernel.org>; Tue, 24 Feb 2026 22:18:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 49B506B0005; Tue, 24 Feb 2026 17:18:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4494E6B0089; Tue, 24 Feb 2026 17:18:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 320FE6B008A; Tue, 24 Feb 2026 17:18:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1D9906B0005
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 17:18:49 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B4636C188D
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 22:18:48 +0000 (UTC)
X-FDA: 84480765936.14.4AC79FF
Received: from mail-qt1-f181.google.com (mail-qt1-f181.google.com [209.85.160.181])
	by imf19.hostedemail.com (Postfix) with ESMTP id C2FCB1A0002
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 22:18:46 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=S4GPOzy8;
	spf=pass (imf19.hostedemail.com: domain of surenb@google.com designates 209.85.160.181 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771971526;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=60wR+/e0uxVasj9d0tpIRSIemMLnPNg8h6fu0IUBUFc=;
	b=i+OuP8QshJ2Tf6Ct3eDHP1N+gwIWrzB5EyHP3Eo2zal6WB5Mu3DrGPwng9Nx40AQD2ttTy
	Embq+eW2Xu+x1Xa5SJX7q6FrEwC0NCyKfEBSvA+RtuOa7J+6Zui+5B/RVgLhXjJJlEVbT1
	lYpPxhQITKyzHjDQPSeTAMNVbFkOCfE=
ARC-Authentication-Results: i=2;
	imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=S4GPOzy8;
	spf=pass (imf19.hostedemail.com: domain of surenb@google.com designates 209.85.160.181 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1771971526; a=rsa-sha256;
	cv=pass;
	b=3W8rkge8VDdTrGEuQt+lyrWX1a2czLzk9vOvkGQ+WvnSab+9fO9rVjdnPqlxyRkaXlyHqZ
	oMX/M1cKxLSMVat08EnirqvJw3evDrcz88SKiVJcaixkPbH+bK2UK/EUtWVpquiA/vIag0
	b+4TxeOLeFXQjljl5ClCl5gzPyIZcHI=
Received: by mail-qt1-f181.google.com with SMTP id d75a77b69052e-505d3baf1a7so72261cf.1
        for <linux-mm@kvack.org>; Tue, 24 Feb 2026 14:18:46 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1771971526; cv=none;
        d=google.com; s=arc-20240605;
        b=iAJaa8PStaBRxFjESF3CYi55/rWlhFCbNCmi1GFBRn5e9wsz/alg3JG7d6ucA2XFjj
         v4lWlcx/V8K4UxZGbO5/gX20vSKHqYGtNpcZjrPQRaqMWjEFLVuSGEMmsmOhA+2/ZvfN
         WRw5qlGl7tCZaRv+Mr6jf4ckg4TDX8CIMN3x7IGD/DoOeBlkprn86yvmqDnKhCRlhXCN
         A/mzG/6gQItrKqsnLFDB+a4MGQ1rHWqpcCmff6s0hrH3U9nMRH/8Plqwi3JXR1/FSs8S
         IIbw/Xw6xsyShJcgpkS5EMPp2paRrSrMAGmL9hQZVprNmaL8smPkin5S6zpU179J4VNA
         nDOw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=60wR+/e0uxVasj9d0tpIRSIemMLnPNg8h6fu0IUBUFc=;
        fh=sDJ3OO+VzT91CmXH7AMvxoOQraEpXMsriEsugpwp1YE=;
        b=G4NhKItBmpf3/AUseNFMUjMVLiEbdlPcYaJoUF7ZvP4ETMyNb0QTjrP87UwKfYEw0y
         FQln5uTZqqx3yJi/KEuVeKCRxSTvJ65FqX6rb6JLNnRRDhbd4Wh5oUgdtgW+vel2fAa8
         rZ1zPxV03W5cvbsj9O80IzRKCmDi96hvnJuWUbJksd67dmpIc2fcr48JBNlYMN+wAETR
         SqiqiF6KDGpq4FdBIn/lNJyQ0gFSoWZO5TLXFyM5egIY0bxRxbeWlGEl4DcTG1umo3tU
         TKA0RydsrUfiRyDFNeaYIN6C/jogcvq/NJtAiWrUn7zWocw/kXPRtEU2xPIGhMBRWflk
         /qtw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771971526; x=1772576326; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=60wR+/e0uxVasj9d0tpIRSIemMLnPNg8h6fu0IUBUFc=;
        b=S4GPOzy8JsWIE+YXxCYwb675Eb1V/hy+2FK4vVUHbfUpOMIYNxmPI3ND+rbz8pA7Lu
         /YJQpNX6VUj6rVm02PFpg8OQ1tZDYKdHvhabqt8JGEkdrHHrwoyghE6jPJau606jC90e
         ahtTQueezDLROsxVAhslyh/HYa5QccHPKGGeSWE2mvtiYct93LHeE3cFjRCuW5e+axLy
         cIZkBjNMOBwMB4z7IzHbME67Hi+H9217wh/YFaZpOZ4ezmbaPxSe2nmFUmhqj/SfXckV
         dBRAJOgeyRO7/pYaSPVbTLUISq72ba9vb/1glfMvmU//lpC6g2zRQNNbO/ehZIwQAYEC
         TLSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771971526; x=1772576326;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=60wR+/e0uxVasj9d0tpIRSIemMLnPNg8h6fu0IUBUFc=;
        b=WqPETVdzJWQaLcOxwp5PAQ9DeCOOp813EwUkNnicMU+Bu8PYz/CIAfd6JL8/GOjyZW
         DBijrYN/bFcDo4dgfcUXMWnWH5iCyt1SS6jMIR37IqURNma4iHcJ8xn2cCEDrbA70/V8
         mFHAYcfTpndDdYN36C/SeJaQkGXvipeu3rKmce8gONJm4hRAqnfKgFGW8rLWfZW5BG2F
         sbm5nx5xpp26nozeC1ugiSaiIf9OsIdCLaDZCB5r/ATLmqluH4k+QNkeu10eYaWcHROR
         po85zLEnJaBre4Pzg6Mg6FrzWbJ7uL00z3lussZxAF+Tb/6zrP+vt5W9mn0K0Zo1bjHo
         wXwQ==
X-Forwarded-Encrypted: i=1; AJvYcCWWsBQPCFfbXBH2vsc+g1bjmmaRBGUvIhNWvgD6FXkIDxnvKjkCNG88bnDpA4Ot/9w+ahU9FQnHOg==@kvack.org
X-Gm-Message-State: AOJu0Ywg4bmkPdF0RWrsd/Dn/Uph1B2JfIfurR0TY5q/EJERGwwPmva6
	UoLp3q8qhYVMJ4Brtwnx6nNSNiTwjsC4eFNOU5mIvEccFDSls1Ws4j5+zKU3r0+hrGq+1fTOlhu
	tj6IqHVxJYFppKOs1ehiIUZVVeRhU4ji9oeY6R3S6+ptTjc+LSLYpfByuERs=
X-Gm-Gg: AZuq6aILfqpoaRTJuRGRGM8DgS/vJkd1OXVRCM4I9zJ3OunBWfIVUtecYc8SGLiprUz
	ReaHETZLa5qxfTg46ybmvm2ZGstPJibbOhKJCqRNeykf4zCOIPF0+06xacIWfnCwP2gpu9OYsev
	XweRkJEzlacdpyhTEyywAzIQDXAhExFUl87iN+z4BYM+49GAS3nTAWWBRu2TTLI2Q192TWQrwSR
	RIRDDRM4mnaUlyk8i2sYwmqSoqsBhzKhNrGhi64sLW7IsEb9ydN7tyOLFpobPhwoeSQX8IAy1Gn
	/8cgE9/AvcHV/3VLEAFl62IHq/hYpGgbepUb2w==
X-Received: by 2002:ac8:5a82:0:b0:4ed:ff79:e678 with SMTP id
 d75a77b69052e-50739021a57mr3227091cf.18.1771971525186; Tue, 24 Feb 2026
 14:18:45 -0800 (PST)
MIME-Version: 1.0
References: <20260223155128.3849-1-00107082@163.com> <6ca5f70c-43c5-4ba3-bdc4-8c48607dbe7c@suse.com>
 <37bbaa9.1831.19c8d7a2cac.Coremail.00107082@163.com> <CAJuCfpEsykCarj6_k5T9EeLDfsA0fFL182g1hQ+tb-7EM=izsw@mail.gmail.com>
 <aZ2yrEz2ZVggT7UL@hyeyoo> <aZ21CP0d-RRAjUCX@hyeyoo> <CAJuCfpHjeFW3xJii3ZcHD_CH8iagHaGGG35wv=ErU7Z8j1vbtw@mail.gmail.com>
 <CAJuCfpGGyrmmtKXK7jOhz-=6+J9D7En3RNwNGFP18Stvi3j2Rg@mail.gmail.com>
In-Reply-To: <CAJuCfpGGyrmmtKXK7jOhz-=6+J9D7En3RNwNGFP18Stvi3j2Rg@mail.gmail.com>
From: Suren Baghdasaryan <surenb@google.com>
Date: Tue, 24 Feb 2026 14:18:34 -0800
X-Gm-Features: AaiRm53Qw0WGW9_7bWBrAKRaj8YdMWRKvPrndTqJsGKOgZiDwK1AjsgnasOG2FM
Message-ID: <CAJuCfpG54+M53M9gdNFRT3ROSGJDgefK5Cv+oAoLiescmpbTTw@mail.gmail.com>
Subject: Re: [7.0-rc1] codetag: kernel warning "alloc_tag was not set" during boot
To: Harry Yoo <harry.yoo@oracle.com>
Cc: David Wang <00107082@163.com>, Vlastimil Babka <vbabka@suse.com>, vbabka@suse.cz, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 5pzx9hz1ydpkxhbfpxry6t6ob7naktfy
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Rspamd-Queue-Id: C2FCB1A0002
X-HE-Tag: 1771971526-529390
X-HE-Meta: U2FsdGVkX18wwCyHxySmnDHHnsUMbgrVYwPgl94l9PxfAcWJ7Yk5DAND1Uh7Icd7f/1aPoVSMgy80tN++BBLRG6chLcxPo10R1ZhrHZgpzF0AuBl2iPrfcLUYQuLCCOq5cs7oB/6xBVQziTomjBM4Jv2ZlNh2iBWe9PyEk08ouD/rd3SnLp7NJ9/Uw0G69XlvYGgXz8q5FXFHJg1wVhZ6yhDns/hkfo1StZ4of/3tFs9aUV9RjbAT75YqBDu90oSx9GhKKY7dbyyRI41ebQ2AOs/V5taB6IX6c3snOLly/P6GBQ3T6i5y89Y5WF2msUjR6tRsRwmPLTPKdsq3vS7o1rH2Afp5OJw6R9vaGUsM10GJgQPMBHTuplqCVQyaffuB6P+vAhm2SYTrJg+xxFwvj8UUprZ56/vLgZMiRcxJUz/X3vVuNsT8S+eY5tqbbjHaWI1LsMfAfylOMX3UivZzX1rAFsGNQz5CynA4zafDA6yBYJv90Kx0vk6p8XgaIHN1DUSmIeB+GhTCJ8sd1SVxsra0EM+lgpXjJVgGHFL/AEtMNMPs4+TMEccgxE3fv3FbOfx+osMuKceO2ZWjPxCc6ZtqK6AEQnG/JiidoBvwXULHf8jtAuQYC3rfZnu2DApbJPkbNGyNsbenuCgq3rZ91yBGoBAbbg1Ult240IYsRiJ8ln5uB5VOghIwwaBP2dccL0FT5inHQWHRkO/DOnb3Boq6tuDljeO/zbSeQNaLYlS2ROeGbL6f5zOiiB7foYWinQniKtbQVuTQ4tSOT8jw9XJqQZSFYjG5f8FlAMIHM59IhMjYUpNuM52BA0lCjGKTspigIntxM7uBVt+1VAls0HVv0XUKePhRv88z+0TMhm6j+niecKV4mF8yUmKU4jZm/A4VEV2Qr3tVfSoOivFbt+AYFEj2bEn5PAVhZntvQuJg+bI/pIMdB4QOh+hoCdbn2VTuwYx9YkVkmsxWLw
 8EBmBZ5+
 7IaKCJYOwHHYUA1pTerQXG82RYw35S6Z+WKN/8VTgWVeOBDJ0evDZ65BYLbSljkZVg771G3q5XLVjxYKiKs8AvhbxfMCSayOXQk6Z3Afoz54bbpQ3YxR3BJHvo2HtkLiOjzeKbt3h5xuzY7bwXT/tVPnMmNok9XZVAH7rMHeypD777YGjXnmZOFpLde5whn5EBjbO5guVxDkekW+pfHBC3nrfZWgJY3HMUXW3l4D54awb7EVFBbwjmWHuVi3DZcvAUhDZFeR+zreHKgQCHvQNDeugeun24GMwTMrQ5m9rtbscOYzOTXPAzKaENoRDDOruyUz2t/miGqfoZunCEeyICcGkLsXu3rbYOw7A
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Feb 24, 2026 at 8:56=E2=80=AFAM Suren Baghdasaryan <surenb@google.c=
om> wrote:
>
> On Tue, Feb 24, 2026 at 8:15=E2=80=AFAM Suren Baghdasaryan <surenb@google=
.com> wrote:
> >
> > On Tue, Feb 24, 2026 at 6:26=E2=80=AFAM Harry Yoo <harry.yoo@oracle.com=
> wrote:
> > >
> > > On Tue, Feb 24, 2026 at 11:16:12PM +0900, Harry Yoo wrote:
> > > > Just sharing updates on this before going to bed...
> > > >
> > > > I was able to reproduce it on my machine I have a working fix
> > > > (nowhere close to upstream quality, though)
> > > >
> > > > The reason why we're seeing "alloc_tag not was set" is
> > > > because SLUB allocates empty sheaves for kmalloc
> > > > with __GFP_NO_OBJ_EXT and it doesn't teach memory profiling
> > > > how to handle this when such sheaves are freed.
> > > >
> > > > When __GFP_NO_OBJ_EXT is used in alloc_slab_obj_exts(), it later
> > > > avoids this "alloc_tag was not set" warning by marking alloc_tags
> > > > empty in free_slab_obj_exts(), just before freeing obj_exts.
> > > >
> > > > And we don't handle this when allocating freeing sheaves
> > > > that were allocated with __GFP_NO_OBJ_EXT.
> >
> > Ah, thanks for the analyses! So, the fact that __alloc_empty_sheaf()
> > sets __GFP_NO_OBJ_EXT when allocating the sheaf leads to this issue
> > later on. Makes sense. I only wonder why I could not reproduce this...
> > Will try to find out later.
>
> The reason I could not reproduce this is because with my config
> free_empty_sheaf() just happen to never been called with SLAB_KMALLOC
> caches. Once I remove SLAB_KMALLOC condition in both
> __alloc_empty_sheaf() and free_empty_sheaf() I can reproduce the
> problem.
>
> >
> > > >
> > > > Passing __GFP_NO_OBJ_EXT skips 1) allocation of obj_exts,
> > > > and 2) alloc_tag_add() even when obj_exts is already allocated,
> > > > and this confuses memory profiling later.
> > > >
> > > > I'm adding the fix I have now. (I guess Suren might have some prefe=
rence
> > > > on how to solve it though)
> > > >
> > > >   1. mark obj_exts allocation failure when slab has no obj_exts and
> > > >      gfp flag has __GFP_NO_OBJ_EXT, so that a later obj_exts alloca=
tion
> > > >      will mark alloc_tags empty.
> > > >
> > > >   2. Set alloc_tag when obj_exts is allocated available,
> > > >      even when __GFP_NO_OBJ_EXT is set.
> > > >
> > > >      Because it's already allocated, we don't have to worry about
> > > >      recursive allocation.
> > >
> > > Wait, isn't it much simpler to just do mark_objexts_empty(sheaf);
> > > just before freeing sheaves, if s->flags has SLAB_KMALLOC?
> >
> > I think that's the best fix and it makes logical sense.
> > alloc_slab_obj_exts() allocates obj_exts with __GFP_NO_OBJ_EXT and
> > then free_slab_obj_exts() does mark_objexts_empty() before freeing
> > them. Similarly,  __alloc_empty_sheaf() allocates sheaves with
> > __GFP_NO_OBJ_EXT (for SLAB_KMALLOC objects), therefore
> > free_empty_sheaf() should also call mark_objexts_empty(sheaf) before
> > freeing them. mark_objexts_empty() currently accepts only slabobj_ext
> > but I think we can change that. I'll take a stab at it.
>
> I posted a fix at
> https://lore.kernel.org/all/20260224165250.1322946-1-surenb@google.com/.

David,
Please use a fixed version at
https://lore.kernel.org/all/20260224221132.1702713-1-surenb@google.com/
for testing.
Thanks,
Suren.

> David, please give it a try.
> Thanks,
> Suren.
>
>
>
> >
> > >
> > > /me goes to bed anyway
> > >
> > > --
> > > Cheers,
> > > Harry / Hyeonggon

