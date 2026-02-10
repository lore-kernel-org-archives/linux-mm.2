Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 51D6EEB2718
	for <linux-mm@archiver.kernel.org>; Tue, 10 Feb 2026 21:38:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A19336B0088; Tue, 10 Feb 2026 16:38:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9C6DC6B0089; Tue, 10 Feb 2026 16:38:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8D27F6B008A; Tue, 10 Feb 2026 16:38:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7BBE96B0088
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 16:38:48 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 3A3C15ACAE
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 21:38:48 +0000 (UTC)
X-FDA: 84429861936.08.FEC2695
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	by imf20.hostedemail.com (Postfix) with ESMTP id 1A8B71C000A
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 21:38:45 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=TN+5ZGIH;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf20.hostedemail.com: domain of andrii.nakryiko@gmail.com designates 209.85.214.179 as permitted sender) smtp.mailfrom=andrii.nakryiko@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770759526;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tR2ChMHSQYG9eiKqn995QhGy6+Jcq6dQubiTn+G1TVc=;
	b=kfTACP8xDYpsH6DrUvlG+7xc0ho7LaGkLxzSIFnfXIJEqKdShMW8enum4TUeX6yrCZMsZz
	xe2QdrHgRxDlP/9NxH3rfWNrIbO8txZ2EHnjIipWPAxYJp49GXOc6zaPC25xdWhTx1L1Zj
	M1aPM+cdcYXCuNxkDevAJPaVusZSqJc=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770759526; a=rsa-sha256;
	cv=pass;
	b=HRSqQ4bebsfNKcEOyDd7eELmYcYiwrwRhZ+ELXATbeumzgGA/c1gGcns0LDS/6XgmaOiBH
	+SRtCszXKF+2AQeSSzGKsaj4qzj7sY+0ch7x5dwaK98ZniUvYiaqtzy+yGGloF1o43+YSz
	5sjO3D8PogrwFzRUejnBfLr3cYJUSSs=
ARC-Authentication-Results: i=2;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=TN+5ZGIH;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf20.hostedemail.com: domain of andrii.nakryiko@gmail.com designates 209.85.214.179 as permitted sender) smtp.mailfrom=andrii.nakryiko@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-2aadc18f230so19501855ad.3
        for <linux-mm@kvack.org>; Tue, 10 Feb 2026 13:38:45 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770759525; cv=none;
        d=google.com; s=arc-20240605;
        b=bmVdj5CpmIJ2FpGIZLJi4V95Ql7wr1mT3wpq6qC+ca3KJKNozNbYFiCc9pjdkk/nvK
         qGkkUC4lMyY35h/JfjL7SesvEHVVKC5k3S01o++7NqCVIeiyCdxYKFwzbWlVzkDeMTYV
         5Fe6ZnhId2ilcKF6B2paB/aqe6r7tYJHHO1y/ncMbvYprmQlT8Kgw3b8Nl6W0mLQt3S9
         NnCaiEGkhk3ZLpLoqSfoXIWi0mrqQ8c/9sTLVSTteawxFpgfLsG+hYlhy9NZs11I+8/e
         z9mzwWvFET6uONxgGJtbxpflDHlsu8dk2/UHaBYfjTWqCPJxj34t/PAXbwhC+PEofXww
         acYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=tR2ChMHSQYG9eiKqn995QhGy6+Jcq6dQubiTn+G1TVc=;
        fh=Qz+q/ueH8s2bGrmsDvEbcyfuWFiAYMEqULznf+FzfI0=;
        b=Z4AZfFEV7gpisHvXoQVwmmfjxOREnRKEClNqjoBHlMVu7+EzpNzpGfmQdj0Xz+EcR2
         albq6D7PPTgO38fFliWtcYV5M8YQ4CtDz8lk1tpzU02IYW+oK+X/HuhJgp0tAcOUqYd7
         LJfdg5qhAGmFbdIMRcnc1QJoQ8OpV2VmylM7/6RdtvWKLFIWLPjurFQtTu2//7gftFeT
         lsxRnqpfl4uiScML9oErZ2RWi8je7M6ZKTzQ1a5PdeqrYRIyGDqFZLz8aCsb1jWLX7PI
         97mOa466/29P9ksy9+YrV3bhpgzsiyV7TdjG9DdJER6lcNdoeetqujQurVV/rnnw301a
         0NoA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770759525; x=1771364325; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tR2ChMHSQYG9eiKqn995QhGy6+Jcq6dQubiTn+G1TVc=;
        b=TN+5ZGIHKXW0hBnt6XKpq4aezDIeQae7w8BI9FBlW/iML1UOX4xLgVFDMLWWoNqGQM
         ETgb6RsmzuKEXMOkUCoRa9s/r4K6+H382MKRAX126/yEGwaZ5w4pNCSvQEpC5rCLTyPd
         0tC9Oyq2v1Iuv9+WwKxuqoCX+HORsqimnn7Z68N6wMTlXqXGesX9M0R8rXdakmv82cOX
         uZO6je3uwkQJ5k6h3MFTnmtssQrfvxaOGaA6PmKM7CGyRY1cY9mJYuBFadY5SAdGmLFI
         f0V9FQ1eP3tizYXJMWShb/CFRz1inX7/Tv93D0iIrlNlM+9dEGuM8r3km1Nk7iOM6RSM
         OpIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770759525; x=1771364325;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=tR2ChMHSQYG9eiKqn995QhGy6+Jcq6dQubiTn+G1TVc=;
        b=uuM3cYDyG8IWNLfumKTDhPPEcVSBbbDmFmgvDXJ6jUz/d8wtprdRQjPmuhNkcWbfbJ
         QDJkwQamCZ+8qBqoYLxICJ8q2nwiFQgWBREYoyMNoLZK5G5yndLyZGlPuxcHXB9Q2SpU
         XRg4PurHet5t+CzTmNEJkYqS8tduxDPCKwLqnRVzDITJdrYrWjdYaoFpatxJwVHUPs+j
         tCNWve4ZmYVes1GNNr0Hi3VFGkfx3oc/HHtwKbwDgDt2qIjKwemvynyrn9/hq2QLlca3
         +cHHXuX10WjHaKqBK23pmREJN2tvdC+WxWJxXsyxGpc2WUxmkGdMn5HREeTog9oLTxRn
         j4wA==
X-Forwarded-Encrypted: i=1; AJvYcCUt5PYQPoOy83PtY9WN2yDiLCbkRN7befkOLGF0Jxt9Fm6oiXLvUZ0X5RhntkAl0VUVZhLiW8/vpQ==@kvack.org
X-Gm-Message-State: AOJu0YwiK4Y8pVCTLX69cmk88ZK//ca0fT6hJeNV0WJfOgbvvXqk1E+W
	jupSIE7PerX5rjBGyP80IKXto1xI8OG8GuFsjeeQMFKpS3p/wM5f6/YEOsqXYCe7niVZBpqY22P
	hhrqZ+6YMeXN7yXArUQ+X0ozf2yNu8Z0=
X-Gm-Gg: AZuq6aJy0rq0KqdqD91BBxCdXTDzxPgF8Bt1Bkv+6+lWdG4FXXkyEDGVCkCmdfT/dEN
	W+5v4iOCJfIjN3nrVy88q7Bz0K7T0Nw0Zfk5w+IqNUnBoN0d51EiyaaDZuknnFo4FfCEcQNcQTZ
	xkGloB8KrHGwP00bqhSOkcw/GPaOv94vlIaJM7Im1sv3KYs+qUiMH7zqdn6+ZXEflfsmDgmEDq5
	qW8m0eGJ8VNM2DKDtTTcSsN9ATwuz/nebCd0QiUeWQqTxsNbvyNFfqEPLoaH7X+9FS9mb43xr1p
	UXzrNyF9GSEtVcjoTRKU150=
X-Received: by 2002:a17:903:1aef:b0:2aa:ecec:a447 with SMTP id
 d9443c01a7336-2ab27f5ccffmr6284285ad.36.1770759524804; Tue, 10 Feb 2026
 13:38:44 -0800 (PST)
MIME-Version: 1.0
References: <20260210192738.3041609-1-andrii@kernel.org> <aYui6BgekgRplVka@linux.dev>
In-Reply-To: <aYui6BgekgRplVka@linux.dev>
From: Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date: Tue, 10 Feb 2026 13:38:31 -0800
X-Gm-Features: AZwV_QhA0DEhtZ-EkZ_Xu_JjyHDVYb_bRHTKSR6CTiprFcTcAmgBUrZ-O5pJohI
Message-ID: <CAEf4BzZnwhGW1VPtQ9svSYUp-+c8=9rxyupF=Xf+WG3sV14oUg@mail.gmail.com>
Subject: Re: [PATCH mm-hotfixes-stable] procfs: fix possible double mmput() in do_procmap_query()
To: Shakeel Butt <shakeel.butt@linux.dev>, Ihor Solodrai <ihor.solodrai@linux.dev>
Cc: Andrii Nakryiko <andrii@kernel.org>, akpm@linux-foundation.org, linux-mm@kvack.org, 
	linux-fsdevel@vger.kernel.org, bpf@vger.kernel.org, surenb@google.com, 
	Ruikai Peng <ruikai@pwno.io>, Thomas Gleixner <tglx@kernel.org>, 
	syzbot+237b5b985b78c1da9600@syzkaller.appspotmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 1A8B71C000A
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: s46rfwi846ak9t9pf7q4hrj8xoj5k5cj
X-HE-Tag: 1770759525-896356
X-HE-Meta: U2FsdGVkX1/P3q2J8ICaYm1uUdi+j7D/L+4Q2A+OV5FJWu1jfTV/KXjXeVhFRgFgGoLGN1Fbjk/tN/2w3PZe/Q/v1UoK5XrJ51g19G/9VTVgcWw1fUGdRcXgNnE2aNsx/nTqM6YON4aA7DidXrXtA9RWTY9g27QWQpF0ex1NfXB4xEgkgtdn2krNMggWiXv+Y9Q/eOaT/PdYf8EbanaUuA8Hhq8x+ktbQFFafSns5hli1LTm7OohC0Ca4bIosqiaOIdDsB9QBK9T6x/77C3u4zvkZ+moGFejByD2Wec0uWMcMaw2TjGesXayy0V+SUlr+T/rajLx1eCJBZkSMuAtUJj1SMTAKL96nvZSAUlwTctyeR+3XHdNtiTAoUs6s21jxpgNxw51vlpDNV/BY0KluBci40yBbiJKoQOGF6sk2CJS2JxoX3iijxQ+wMw8lGPLNEcKB/cLtDQMtQ+s89tjiEQEcR3Qnv4lcSQp9BLH1/fzS+bQSaOOSot4PqPAa+K0dEQqT4Z1aRl8VyMx0w+vhcd+V/I4w0kAw9Sd1AaHf3dNAJFlcj7t/KyyaoO2tvW52ujiaxAWRM35depaRZrPMLLEdf+sCcmRKCF8ZxF4PsYKM6BJ6/sMpcTPKIOBaK3NIfeblApr04tC54xtv70tsk6RatP5yrWfvm+cdkG3/HMJbJ8hhJN7XWezjiX0Yt79E2iKms6y4MeZP1ppbVwFb2R3M6arlfIwx00OVUgePMzn0Fr/raVSowUpNqpqFCAu+6AzYycbw1IbKyIRXv5cEcfzlzVbbY0HddrQShcU3dFdwaIgVjbddMM5yCFPtYw9go44wW++Sv7bXWQjLrKRJFY75JtFGMRbvlaunjBjzCe6U1bNJaZ+iyAU+FSIgLXRtpbRUL+87LkxcXTI/J5YHmCran3Z8/owLrYhCR2yGbBIXQH4CaOZAqTBa2acAJVhxRZgA2ca9np1sJo+LDM
 SccHBQjZ
 neBvNUN4wweO7eazy49GZfNm4QYfbB92NfSxIWnmbB3KeR3CmNA/q7bFGD7nCJO9Kz0mK21F7U0oLzYQBwb2dEFziRP99vsO1eDznrJ/HMfN/nFMvRkWOchvnR4We5uGmVp8TbhFRzDa5vr4Jo2JK0MPAgTkiuz4dm8pD/ZxTbt+VEcMkSPrzWorz0pFT69bGuwpzppRbV7NLA6PnuAHW690WuAANHYFXmBB2Z2E/tddLFpUI2UeKwzvBSBaNF+IvloPWDM8A7QbyOrx5rLQ7EtqDLD1ffVsZWZewD3ImmJUVV9o59HZyuAnMkAk+VoQDLb91LwckQ3FpZ6nzb62b22u4qf9hzYE/mn5ZSi+drdfFXC3AfYeqwLGnU2bQPuPaRDYWkDTuEbFj5E6kc7nGJN33SadzpFFtmv0ilQrlFsxv92f4ZRMgOIGphlvCNRpq8wgScMRRxRzDscXqBIKZwarH4vMUwC5a4JdsuQYlfkUbI6Qazc7jp0kHG3h0OLHXHR7VUUqHZ49eHUPa7nBKT66S+hwVH+d0yLQKu/1/ffqLUBh34kvYZhQnAjOvyzUxVICRf4eBPrhaR2sVc1rJbmInR5PwYDzlGL1R4MZCW8nIkLdsD1sY7pM0P+Y0Hsw3YsauQbkL4xLvoNnHCY4V2QUPOw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Feb 10, 2026 at 1:30=E2=80=AFPM Shakeel Butt <shakeel.butt@linux.de=
v> wrote:
>
> On Tue, Feb 10, 2026 at 11:27:38AM -0800, Andrii Nakryiko wrote:
> > When user provides incorrectly sized buffer for build ID for PROCMAP_QU=
ERY we
> > return with -ENAMETOOLONG error. After recent changes this condition ha=
ppens
> > later, after we unlocked mmap_lock/per-VMA lock and did mmput(), so ori=
ginal
> > goto out is now wrong and will double-mmput() mm_struct. Fix by jumping
> > further to clean up only vm_file and name_buf.
> >
> > Fixes: b5cbacd7f86f ("procfs: avoid fetching build ID while holding VMA=
 lock")
>
> Why didn't the BPF AI review bot didn't trigger for b5cbacd7f86f?
>

I was wondering the same, tbh. I think it's because I marked the patch
for mm-stable tree with [PATCH mm-stable], and our BPF CI
infrastructure just ignored this patch (even though bpf mailing list
was cc'ed).

> > Reported-by: Ruikai Peng <ruikai@pwno.io>
> > Reported-by: Thomas Gleixner <tglx@kernel.org>
> > Reported-by: syzbot+237b5b985b78c1da9600@syzkaller.appspotmail.com
> > Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
>
> Reviewed-by: Shakeel Butt <shakeel.butt@linux.dev>

