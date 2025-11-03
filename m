Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 58D73CCF9F8
	for <linux-mm@archiver.kernel.org>; Mon,  3 Nov 2025 21:57:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 91BF18E009D; Mon,  3 Nov 2025 16:57:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8CC0B8E0058; Mon,  3 Nov 2025 16:57:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7BB098E009D; Mon,  3 Nov 2025 16:57:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 66BD38E0058
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 16:57:05 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0D84713A81B
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 21:57:05 +0000 (UTC)
X-FDA: 84070656810.25.4072462
Received: from mail-qt1-f178.google.com (mail-qt1-f178.google.com [209.85.160.178])
	by imf12.hostedemail.com (Postfix) with ESMTP id 5B89A4000B
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 21:57:03 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=F0ANE9TB;
	spf=pass (imf12.hostedemail.com: domain of surenb@google.com designates 209.85.160.178 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762207023;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gER3U4jPm3zLdToO+o/G1Pi3xvKnkSrxt3iRJAUvLXw=;
	b=jhhAgmjbFMAnLtoNT+NGcXSeps9XzgiYwxCvY9KTgkZhFvfCWobAzlIHwJYQA1QWFVv/2p
	DqBGjy5NuaEXSXyE6JLJ+ZhBfYAgqSx6AKKB9YV4H4vErs4XfVKBx4oBLb/loxP3wb+R2n
	laH6q3jajZQOq94qjCLHT8C3bS2nWfw=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=F0ANE9TB;
	spf=pass (imf12.hostedemail.com: domain of surenb@google.com designates 209.85.160.178 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762207023; a=rsa-sha256;
	cv=none;
	b=UTFHEUuEp9fgHgmpHamaXE3mfYcnecn0G5WI9dhbYGZ+5WhJFfk2aXP0/EMl6h8sSz9kpo
	SMQzhX3JKnJqi6Zwz6jTzFmJ6hYxmAot8V9GH4VHKcDaREQUia/LZJzV0XRX5hgKgTLzDn
	3MyWjhS7VB+ePSrNNjAprNRNq4GTlcY=
Received: by mail-qt1-f178.google.com with SMTP id d75a77b69052e-4ecfafb92bcso42511cf.1
        for <linux-mm@kvack.org>; Mon, 03 Nov 2025 13:57:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762207022; x=1762811822; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gER3U4jPm3zLdToO+o/G1Pi3xvKnkSrxt3iRJAUvLXw=;
        b=F0ANE9TBphqzFU549I9/c/tuKqQBFLwyTkjE7hztZ5Www11LZbeGQcnm2YBt5pq6hs
         GZVknWKYOxtVAqVKNIdiTQFeVN88IZ5vdM9CIm3xE/fT6DjhBdBt2huqJHPvTqbS7/uK
         m7IFVOLMc22kuY7A+PM/PYfla87vewOOJ0WNXAvHbd0XaflEd8ZA6xj3mcQdq7hcRPPx
         WoOlyfd0oRhA8bP23/TjhEaRj25mBdZpsxIXKkuNU89is5POA8no7GQQFJ+9lRFjT57c
         aEqW/3zf3u9qMlPb4zEnM8/0WxgTO2RGHYyVaD7Tseta0X9yhlkZdAKVwqjmLlVaR14M
         DblQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762207022; x=1762811822;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gER3U4jPm3zLdToO+o/G1Pi3xvKnkSrxt3iRJAUvLXw=;
        b=Is0bKACeoTyH1VRaBJQgWQp2Z8CSsxZSGlLtHKfbHm2MxM5TNF83fpvSU8L0q6aOf6
         CN+A8ictEfVE1WXdCwI6Hav5coGxa7cEJAS8r87I0tnn1VLCcPD7yNDmSwLuVcEiCjvj
         ouIJirzjdjKIqBl0gfEgUOBioq7rHgEf4i1kDVmxhljWtzahv1F7kLQR85VBRPfBi5Zk
         NZU+CySCNbCC0d6eGOiO6oZ8w+LV2WXEXg7h2EfgrUs/C9cUv+xgmyzhK/wpdVEyssJy
         hjJVCOvnqpNKdGMZWMLHA1+fzLlEZd1KPNJ2Mh+g/8286fSwCDFTVhDE783kclr1AHF0
         KIgQ==
X-Forwarded-Encrypted: i=1; AJvYcCXftH7y50JUe33PDNhwpkc4uv0WEiIMVbUqCtmjwElYdV/Qjgd1kLN598YXRtteQKd5Ehk2FmlQrw==@kvack.org
X-Gm-Message-State: AOJu0YwqVDQ8d/XwnIZqAgCH+HrKncxZyKhRabuUcoj+7QRfv2YO0ojA
	1XMJkekF0dsPdqMT9RRU1O0ad3eau8KucmZKLJlI6QpJfum/oC3YWARnoUkJOUP41Rk+lfjNdO8
	aTNJQeuORAT6k2WT3NjWnUAC1xUaX8ihGrUTW2HE/
X-Gm-Gg: ASbGncsjnOoD+VjV+fLjLYO93OP56JtLf1rwtlPYhIKTmSQGtwsYVmmD724xX0wr/8/
	f6IhjaCEHsCdbzKGE40RWaH9sLEMmLjpG6ZoXhEnsap+DNKfgXAaXjm6UJkZjYse+Y7UskSsCXm
	KJE6/G/OAn/iEdLRokIs3HPdA2jNXVGBwDmmI7EgeZhmQ/6reLq54NkbOLVq1NuR5i7Yr9P9MOe
	egMNQQMabe7ZtYKGI1DmwOJR8aW1qQBN2g9IUTo149Ol46nnKxXUsCwimU=
X-Google-Smtp-Source: AGHT+IHqbx00mxkUGGZdrnp/316jHboDvkSx+kYiXZ/w/2M/7+huN4IaN5ivuFOg8POG1NGQOixLckbAJEDq7ZUINDQ=
X-Received: by 2002:a05:622a:178d:b0:4b2:ecb6:e6dd with SMTP id
 d75a77b69052e-4ed636431d5mr621241cf.1.1762207021864; Mon, 03 Nov 2025
 13:57:01 -0800 (PST)
MIME-Version: 1.0
References: <20251103180348.3368668-1-willy@infradead.org> <20251103180348.3368668-3-willy@infradead.org>
In-Reply-To: <20251103180348.3368668-3-willy@infradead.org>
From: Suren Baghdasaryan <surenb@google.com>
Date: Mon, 3 Nov 2025 13:56:49 -0800
X-Gm-Features: AWmQ_blouekaMtnIRYYE6JmxLReYzERcdi77Exh8mwIITLdLuyJVa6Vz1hpFemg
Message-ID: <CAJuCfpGmcJPY=-a=0RAdVdYUa9mffzsGs0VdBLKwfkjY0MT8vQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] mm: Use vma_start_write_killable() in dup_mmap()
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Shakeel Butt <shakeel.butt@linux.dev>, Jann Horn <jannh@google.com>, 
	Pedro Falcato <pfalcato@suse.de>, Chris Li <chriscli@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 5B89A4000B
X-Stat-Signature: gekescux5yt1yd8gidhrkg7zcp5z8pcg
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1762207023-689701
X-HE-Meta: U2FsdGVkX1/cXtLh+vjfXi50jXSRhty4rJKtesWm3Pp+6RYL9hQ0yaeF0xTfUxVyEQOM8quF8gWZw2UnRtYOufoW1H4cHq/nDWJLB7wj59v9CeBa8wjWNuI9OPN0igi1HIQSEEU4CSCaR4lRmFn9XUEXJR2tTWMntsOI+V+PdRUmMAMsMP0OXlCNfWGV3LaFak5jQ7bt+ypeJRTD1mwVTTKBFY6jat5//yviHx385eLUm97menBuINQgrJ1mIwV56n9b2aJMB3V2pxlFG5hMMpNpxG+ZCWWk/TnGJ8yWoYqZQK/z4ZUPDSwCauCJIXJQ/HjUwfpEBQ4YxpP/Pfh86s1ZGYH+Kg7EG54CwTPR/F1gpjGs2kMl2GoCS272uoF2o674+we/Obhw0E+PssHgnNUR92zh/Wc8+rCkg+A7U7dQf90GrC+fan8roXyMf8WjcH4dpK3WmA1Zzs1FfG+FdQn6OWFcaXhXxzTQJSvl+AowgPCpb3ykuKEYeIjLewGW/ARGyeSsuIbtTXwzdriaJt+AX2+6LsCif+SfZwoQ7FjotBZVr2eBjL2V3qUzWe8nVnS/jS2F4khi6VCnXfuogvQiCCOQzcwcIDgUxjldXs3NVZhH3tTXi5RE/IO5hBJ35RdMH7mxNdfWX8I/xEacy+Pk5MbXBouCWPMI1aIlkK1XcjjsZtZKIHaYsZAZgt7ht/7dTcDPebrX3mN4z9uLY/YYR78kEZr63kQ2b9A3uHVQnMjr7NC5KtF04g3bhQgR+rcHCaDBQIqRhK6HxEHgejAnuUDad3jAx/ok0gZ/HCKV1r37cuKBx7WeDt4g4Yz3LD/zCYTHpeR8OM6JrZaR/F6P6zt3m95bK/QA46aaQ6xh4kAxyIhAeaD+fxWarouVMmb+s9SlHgN2NPB4sqXxlfw4NLQco+sVUanB7rNPknI61vcYimdRkbsJUA3ntZ3TXcFlnQJHbMRiYAVg59G
 WAUEVoAl
 NBOoFpsmpGY+CrJ0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Nov 3, 2025 at 10:03=E2=80=AFAM Matthew Wilcox (Oracle)
<willy@infradead.org> wrote:
>
> Allow waiting for the VMA write lock to be interrupted by fatal signals.
> We can remove the explicit check for fatal_signal_pending() as we will
> check it during vma_start_write_killable().  This is an improvement as
> we will not wait for the reader to finish before checking for signals.
>
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>

Reviewed-by: Suren Baghdasaryan <surenb@google.com>

> ---
>  mm/mmap.c | 12 +++---------
>  1 file changed, 3 insertions(+), 9 deletions(-)
>
> diff --git a/mm/mmap.c b/mm/mmap.c
> index 5fd3b80fda1d..03773fe777b7 100644
> --- a/mm/mmap.c
> +++ b/mm/mmap.c
> @@ -1750,7 +1750,9 @@ __latent_entropy int dup_mmap(struct mm_struct *mm,=
 struct mm_struct *oldmm)
>         for_each_vma(vmi, mpnt) {
>                 struct file *file;
>
> -               vma_start_write(mpnt);
> +               retval =3D vma_start_write_killable(mpnt);
> +               if (retval < 0)
> +                       goto loop_out;
>                 if (mpnt->vm_flags & VM_DONTCOPY) {
>                         retval =3D vma_iter_clear_gfp(&vmi, mpnt->vm_star=
t,
>                                                     mpnt->vm_end, GFP_KER=
NEL);
> @@ -1761,14 +1763,6 @@ __latent_entropy int dup_mmap(struct mm_struct *mm=
, struct mm_struct *oldmm)
>                         continue;
>                 }
>                 charge =3D 0;
> -               /*
> -                * Don't duplicate many vmas if we've been oom-killed (fo=
r
> -                * example)
> -                */
> -               if (fatal_signal_pending(current)) {
> -                       retval =3D -EINTR;
> -                       goto loop_out;
> -               }
>                 if (mpnt->vm_flags & VM_ACCOUNT) {
>                         unsigned long len =3D vma_pages(mpnt);
>
> --
> 2.47.2
>

