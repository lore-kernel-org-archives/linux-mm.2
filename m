Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D6021CCF9E0
	for <linux-mm@archiver.kernel.org>; Tue, 28 Oct 2025 00:51:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D8EAB800F0; Mon, 27 Oct 2025 20:49:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D1818800E4; Mon, 27 Oct 2025 20:49:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BB87F800F0; Mon, 27 Oct 2025 20:49:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 9A035800E4
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 20:49:20 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 6FDBE1A0305
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 00:49:20 +0000 (UTC)
X-FDA: 84045689280.09.271002A
Received: from mail-qt1-f170.google.com (mail-qt1-f170.google.com [209.85.160.170])
	by imf07.hostedemail.com (Postfix) with ESMTP id C5FB34000E
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 00:49:18 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=geG+Uqpk;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf07.hostedemail.com: domain of surenb@google.com designates 209.85.160.170 as permitted sender) smtp.mailfrom=surenb@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761612558;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sCvXsZaHI1SIHLVxQNQkHzVv1jTQnPjDd1JLHsOJetk=;
	b=gQR6U6OH7tUIxNW2yj3ypRFHY9o5xsuxaF6nYegXpCXorTkKG6z/7lYfmcG1Ku/4qeQqr6
	kE/mfHc9CiT2/3iDIujf9j68XOZ0vnRHvvY319Yj3PqSu5GXZImKe9zGSENG0hmlYoEKXA
	jjgOmeAFCtTlZuczkxfTS7lyhpDZBYU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761612558; a=rsa-sha256;
	cv=none;
	b=0aX2RNPCp6hKDObDUsuCGWVs/JpZW9FHOGpM9auRYBeLY/vFcfGVDxKtbD4SK4wlYv8kVg
	dRFVyCHGJcWLRf4Wt0WOVSNThqKixBmVVZ/8UV/2tR/JxosQuzE+GtOiLGjD8eO2CQAeZn
	mz//EhNxhyBXRN0hOsFASJphqLyorkE=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=geG+Uqpk;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf07.hostedemail.com: domain of surenb@google.com designates 209.85.160.170 as permitted sender) smtp.mailfrom=surenb@google.com
Received: by mail-qt1-f170.google.com with SMTP id d75a77b69052e-4ea12242d2eso109581cf.1
        for <linux-mm@kvack.org>; Mon, 27 Oct 2025 17:49:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1761612558; x=1762217358; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sCvXsZaHI1SIHLVxQNQkHzVv1jTQnPjDd1JLHsOJetk=;
        b=geG+UqpkEVfYesMvRXvotg81HYsqYSUGeqQw8DNbxDSOhTsiC33kzR5md2b6zphfKB
         Ei/DYr8Lfjng30Dv8g+OVFtX37MQseD+WsXNk7WZ0CFSvClouGLrTc40X/gBJI4IKODk
         rrh8TTNLLa21NgB0i/LjrnFmr8huLqwXPE5YbXkib8E/QLcPz4YkwBUyTXaQJn7sQexj
         mHtfcagnZ+SmPj5dEq74aAuTNuxdNphpR5S2l6iSuPjkNN+D2rHQcJI5dvR2BgcQfskL
         DkSS85E/SiSCxaEtw/3Dlz2lhjqTl2zWplfXWrQY2fcAwFcZQrMBPSpSNV0JdOtp9zyS
         3Nvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761612558; x=1762217358;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sCvXsZaHI1SIHLVxQNQkHzVv1jTQnPjDd1JLHsOJetk=;
        b=CfNQnNxMmARsdftF4I0Gn/7r7+MnJWOxlZYcTQtW2wbaw5BKe2tzKP/jj3rvmXkO5Y
         yPEqVhnZmdoZ0ExRZ78LKL4ITDD1FitKY9HXfLPUQ9iwE6Yi895PrbbOzwTUwvEQ8Vt4
         lYFn2Ko58vfwDXZWy99uTqBVg0EU99BPXGv6TUKQGztF/SI86edIXzXnNIbPKdZu/XQy
         8DEL9MsJgzcyI6K0xgzzFryuaZuY+diperZtvWek9kVQT0RzuXcdVbnN+YsPfliVpUWC
         MOOc7JJA1xjabUHEdKyaC7lXQ0bKOLWU1mx/SL6aCNtvUIZiF/CIGQgw+fzQgeE9qx0F
         JMbw==
X-Forwarded-Encrypted: i=1; AJvYcCWJ2uA0XPh/QsGEvXcZ5degSIDa9dsDCfWdErHFMLkXeAEjrZgVWq8FmRafcHKlkkXr5qrIDWQFsA==@kvack.org
X-Gm-Message-State: AOJu0YwVDPYjemlqwIy2MNwMYKBKBdngxyQrVhonRM+16cISTvszMsNt
	jjacx0m+GR6UO4DDGFkDHIipgx/nksUQtzpmbkGsbB6UQbBmD8Vga7adoDJcLSSRX0JjsKZXWAF
	QEMLRy10gEgkZsJ4d6WWROFjpZ7i8xIGi79y3gUrg
X-Gm-Gg: ASbGnct4mbFrhyCnynxgsGr/ZF5JT35QcO0gUGzFor04qzyrt7cDMxoScz5ky0FdpLJ
	iR9L3xjHWtDeJ8rMUJ4S7/UCr65tsh+KJ54aYHUUwyhn1OkJXzWFjxjL6jKefBFNWVXJ6f7SxMa
	yTrs/e/qvK2wwTF/ws7XarT4v+3+Xer83vXJZRP7Prs/QQyEqu4TgrzoxzJhMzsi9QL/hNlRAbV
	enEX/gqWxiTm3cZLkZybUaB+uL59pJckt7cTAnKAzyOz8JYxgtiwxRUuvw=
X-Google-Smtp-Source: AGHT+IEorvkOTXjQ2KD2Ost4McwQpoPr3o5PCGxowyBvDtZaGkaLLqZcQVCC+mQgIYrmlP9rxCJ4mPNNjDyS4LIvTSo=
X-Received: by 2002:ac8:7d02:0:b0:4b7:9a9e:833f with SMTP id
 d75a77b69052e-4ed09f3da7bmr2104801cf.7.1761612557521; Mon, 27 Oct 2025
 17:49:17 -0700 (PDT)
MIME-Version: 1.0
References: <20251024090902.1118174-1-lorenzo.stoakes@oracle.com>
In-Reply-To: <20251024090902.1118174-1-lorenzo.stoakes@oracle.com>
From: Suren Baghdasaryan <surenb@google.com>
Date: Mon, 27 Oct 2025 17:49:06 -0700
X-Gm-Features: AWmQ_bltDXnsUE1AyN7X4o_jxjknljjL692Itljid0i8j3vBpWBt3HxocYIVeB0
Message-ID: <CAJuCfpG2f40hosmWVcgTs7O5jSgLNp8w4Mt50N2+t1k9CLLMtQ@mail.gmail.com>
Subject: Re: [PATCH] mm/vma: small VMA lock cleanups
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, "Liam R . Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Shakeel Butt <shakeel.butt@linux.dev>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: C5FB34000E
X-Rspamd-Server: rspam02
X-Stat-Signature: s6wmzphffzh6kf4ajs5ob9ossujjg6ds
X-HE-Tag: 1761612558-559245
X-HE-Meta: U2FsdGVkX19CXmjDns8iSz90tl7qb4QBwPwUI6vMVuWr5TcR8pDPKeZKj1cKhIe9yAPusWmdP2eoFzH08bK1YutlMak8Pl9Ie3UUX/NI9DfYKtZgCAkLi9+6d6QsF9tQxfJixnGRBqXGbwh55XQ5x+3M2+7I7V0WqPK9Zx3oDF5Ywfxz14zS4ISX88gIMVyfff1J5+KipRcJ7Ym2XoOqnSVqGldZIdYCL6mEElMyejxdAU30HT4W82ZTOIi69dnw3VSSTEKC5L7/IieqANJsvRIclhTOTGyhTpFgJ8ZBAdZpGuJTIA1zHDDtzE+2EUbvIoEkIlxVsOG0Qq0f/j7kyqnMp3p3LamSxgwWYKwYI66esKHyxgCLfNcDbSdXYKeNaHYPrKRc9amBSKgD9uKH4zSzQPssvndF+RzVW7ixKHKPKJFm6qe8bRgdGavbTSmJxvfpptShHdi7scp8yjsXnYpOQePt8aRCGmhWfTstTtUXd9kJdfPf5Yk85ICH2AElkLj1bOdIvcxCi5iUfKShK75V6y4FGE9171d4z+28UafUPH0hbabTSSE75sHhK7msdbDQnRg3XmuoWQNM+fEzWzJ5uK9QOl2FfWfn+hik6ugmS8qDnKVTsa1lKZOd7nqVr2DVlMPg//3bGULI+OsgsUCwr5ql8rGOI1mGXZi8WW0gYKODXfIM/o4vkGxIfPJlvZLq1/3ntKSkIVwpW22yyLgJzNvMdxAOsqBGeuHWZONqB2nquKARsplf9gzvATda7OXKCIlk/ai7KDgndAFrQ6o2krIrTZQTVxI3i3jvhBotUZRrmWj8bDa1PkliZDio+mopHcx3dDVYZUO78Il0ezOj8jOz/QgmR4wBvNMxS5hPTUptiSh/QSZfZEh7mHoLwgGkuvlyxgCpA0zJ4m465Sxi5m0YTcBDVCxQKmyZk6ukrSmp/joSw6TXuss1v/f7
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 24, 2025 at 2:09=E2=80=AFAM Lorenzo Stoakes
<lorenzo.stoakes@oracle.com> wrote:
>
> We declare vma_start_read() as a static function in mm/mmap_lock.c, so
> there is no need to provide a stub for !CONFIG_PER_VMA_LOCK.
>
> __is_vma_write_locked() is declared in a header and should therefore be s=
tatic
> inline.
>
> Put parens around (refcnt & VMA_LOCK_OFFSET) in is_vma_writer_only() to m=
ake
> precedence clear.
>
> Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

Thanks for cleaning this up!

Reviewed-by: Suren Baghdasaryan <surenb@google.com>

> ---
>  include/linux/mmap_lock.h | 7 ++-----
>  1 file changed, 2 insertions(+), 5 deletions(-)
>
> diff --git a/include/linux/mmap_lock.h b/include/linux/mmap_lock.h
> index 2c9fffa58714..e05da70dc0cb 100644
> --- a/include/linux/mmap_lock.h
> +++ b/include/linux/mmap_lock.h
> @@ -130,7 +130,7 @@ static inline bool is_vma_writer_only(int refcnt)
>          * a detached vma happens only in vma_mark_detached() and is a ra=
re
>          * case, therefore most of the time there will be no unnecessary =
wakeup.
>          */
> -       return refcnt & VMA_LOCK_OFFSET && refcnt <=3D VMA_LOCK_OFFSET + =
1;
> +       return (refcnt & VMA_LOCK_OFFSET) && refcnt <=3D VMA_LOCK_OFFSET =
+ 1;
>  }
>
>  static inline void vma_refcount_put(struct vm_area_struct *vma)
> @@ -183,7 +183,7 @@ static inline void vma_end_read(struct vm_area_struct=
 *vma)
>  }
>
>  /* WARNING! Can only be used if mmap_lock is expected to be write-locked=
 */
> -static bool __is_vma_write_locked(struct vm_area_struct *vma, unsigned i=
nt *mm_lock_seq)
> +static inline bool __is_vma_write_locked(struct vm_area_struct *vma, uns=
igned int *mm_lock_seq)
>  {
>         mmap_assert_write_locked(vma->vm_mm);
>
> @@ -281,9 +281,6 @@ static inline bool mmap_lock_speculate_retry(struct m=
m_struct *mm, unsigned int
>         return true;
>  }
>  static inline void vma_lock_init(struct vm_area_struct *vma, bool reset_=
refcnt) {}
> -static inline struct vm_area_struct *vma_start_read(struct mm_struct *mm=
,
> -                                                   struct vm_area_struct=
 *vma)
> -               { return NULL; }
>  static inline void vma_end_read(struct vm_area_struct *vma) {}
>  static inline void vma_start_write(struct vm_area_struct *vma) {}
>  static inline void vma_assert_write_locked(struct vm_area_struct *vma)
> --
> 2.51.0
>

