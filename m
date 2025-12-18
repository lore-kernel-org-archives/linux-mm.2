Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7D487D711A1
	for <linux-mm@archiver.kernel.org>; Thu, 18 Dec 2025 19:51:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D0A7D6B0088; Thu, 18 Dec 2025 14:51:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CB76B6B0089; Thu, 18 Dec 2025 14:51:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B98736B008A; Thu, 18 Dec 2025 14:51:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AA4336B0088
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 14:51:54 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 65015160300
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 19:51:54 +0000 (UTC)
X-FDA: 84233637348.16.4B13646
Received: from mail-pg1-f182.google.com (mail-pg1-f182.google.com [209.85.215.182])
	by imf19.hostedemail.com (Postfix) with ESMTP id 8BB8E1A0013
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 19:51:52 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="aQqGh/lY";
	spf=pass (imf19.hostedemail.com: domain of andrii.nakryiko@gmail.com designates 209.85.215.182 as permitted sender) smtp.mailfrom=andrii.nakryiko@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766087512;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=C63H+Q0LBcr5iHhH3l69u6dfCNmkUhMAEU6dY0As97A=;
	b=g7cc07rKAkbV5qOJe8LhQGIfFMAQCeYBZ6EFBuv7bQk8SpSsohOW746xSEiaxTqs0DYdVq
	UK7mGiIqxPTsrRsLQRfZDQti863mNivlhIsWnwr08LVEOShKWrEfiBoiyPiDBNfRMTEbpO
	2yen3CNcPghKqM43RMLUTfm751OPwAo=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="aQqGh/lY";
	spf=pass (imf19.hostedemail.com: domain of andrii.nakryiko@gmail.com designates 209.85.215.182 as permitted sender) smtp.mailfrom=andrii.nakryiko@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766087512; a=rsa-sha256;
	cv=none;
	b=N/41zEoAZtduDLsUEAvw4SsSOLu33mxM168hE3rNtThfNBPdaJ/AFskj8DvjfPv7xmzhdo
	ZHEr1dMzr5ZCdu2rtJQZJXMR6l898V0lDwYqDmfhUVEiZtCEFZRN3ok8dr/yiP3NttWep5
	u7cvGtBqhMt3ca8r0Fz1AS/GPT6JAz0=
Received: by mail-pg1-f182.google.com with SMTP id 41be03b00d2f7-bcfd82f55ebso860680a12.1
        for <linux-mm@kvack.org>; Thu, 18 Dec 2025 11:51:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766087511; x=1766692311; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=C63H+Q0LBcr5iHhH3l69u6dfCNmkUhMAEU6dY0As97A=;
        b=aQqGh/lYqJrTkZUvvyXb9oRGjf8yto02p5kIkOvj2+28H2jy1np6BJBw/lNre7C1FC
         phNGkeubdWNfkzvHyBr8UIYdiqM3Fm/MbruYCW9RD1sXT3vxDC+zW67qyKm9JGaIilvL
         AoKfKEfUCb94v9sfp6w2I/14tbVmBALrHo/ymIooBGfk7MhZfEaPc5Jg2hegSTOo09R5
         jmVY8MilXDVYPRNeZmJ6sGwWGhKOJtzySaqU4pa8ZVBqXtPmZ6mVXFDqhLzxRBnbsphj
         tIO7jrHdg7nmuovGuTFb4970PK2rWW71vah8mtznccOAFfbHu1OCt2gnmcVHXNEk3V/G
         RxCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766087511; x=1766692311;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=C63H+Q0LBcr5iHhH3l69u6dfCNmkUhMAEU6dY0As97A=;
        b=lAZzH7D19w029+mkjRGDtXZlEKke8me28BnNOKQkJIMBEFAlcj0vrdmzBHpeIluYVb
         FIRTQ+orQ1b9CVusa/6o60/77fYmM0+jf3Ja9JZgHQVZE/K+qZu5+rqbJwCWAyI+5RXq
         47+mxygETDLwUo5DyCwLoFtclPwfirHpqrYaHGi5Idr7LzVQ74kPqUhfRbEGgF6vaGrV
         hHYrrGx4lBEIMwQFJpA+5HJ7djDdVwTJA0aLXe5PKwdDuvvRL7uNrW9eUyT5cm67iYO0
         de5JN4Iy2XWOTTs8DxZE5Jmai6oS4zW3j9UgzJq1v+cduB1RN1DJDN9kic4zSeOG/las
         l+eA==
X-Forwarded-Encrypted: i=1; AJvYcCUQoU1b3q47/p+rKz0bUZTicFnvERUtH14pOqwxT7gIlxjzaGRx4eoalwngcZu4vwdUcAeh+VYJSA==@kvack.org
X-Gm-Message-State: AOJu0Yx39J4yLgNf/YYUGB2awzZRdb7VtT1Fjd5ySwV31kK5YTM2oHO3
	/Ccgmh6NhQbKGv0NbTwno43coMXrKhzdhL/eAFif1Fj7HDJ3Prt8xQaiuqLznWd/NtGOQ4gKGrZ
	y914xWF0Ccx0aAEcRcECgw2lGBOm/aHk=
X-Gm-Gg: AY/fxX6Ap8B2Dm9e/sAmkOo6MhU5qHfHHLgZRruJdIG3XzsWMFkQeUXUsrcTHFASKlJ
	h016ZUZhiejPyqr7fwbtGGJmis3nWsfBzIvVTdWwnFSRrJCagOcG529zlM+vGoy7l59gZYfjs9I
	I26mHNqm1AX8m+WC6zUZ6sy/PBfOya+8m7q/gHylq5aeohUIYmK0lceH1kndk/O6lMqQutw7nMk
	2ND5a9c2fILhB8E71z7AfTl/j0AlMXP8rybX8Z64lktJxHuWE78V7DflAJKjz6ka9vij6FEAAmA
	HYsSCtCj3fo=
X-Google-Smtp-Source: AGHT+IEWhe7bv32T+uDEnTLomzrXVkDcdio5VPeba8Lb88GM19tn066r4eU5nxiaGkuMZVdgvFNvFM5Rn8urP76u1tk=
X-Received: by 2002:a17:90b:4c41:b0:34c:2e8a:ea42 with SMTP id
 98e67ed59e1d1-34e90d6a375mr708436a91.7.1766087511281; Thu, 18 Dec 2025
 11:51:51 -0800 (PST)
MIME-Version: 1.0
References: <20251218005818.614819-1-shakeel.butt@linux.dev>
In-Reply-To: <20251218005818.614819-1-shakeel.butt@linux.dev>
From: Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date: Thu, 18 Dec 2025 11:51:39 -0800
X-Gm-Features: AQt7F2qMfWT3bgYpN_4cYf67W4wNT-xNaPH-YHCiCZYNMobBBdufEt-Lx4wkFGI
Message-ID: <CAEf4BzZrU9xA=S9BFy5MHhmBi_S33yjGWYK1Wx8gs5RdEcjbYQ@mail.gmail.com>
Subject: Re: [PATCH] lib/buildid: use __kernel_read() for sleepable context
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, Matthew Wilcox <willy@infradead.org>, 
	Andrii Nakryiko <andrii@kernel.org>, Shaurya Rane <ssrane_b23@ee.vjti.ac.in>, 
	"Darrick J . Wong" <djwong@kernel.org>, Christoph Hellwig <hch@infradead.org>, 
	Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, 
	Meta kernel team <kernel-team@meta.com>, bpf@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	syzbot+09b7d050e4806540153d@syzkaller.appspotmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 8BB8E1A0013
X-Stat-Signature: ucf918jamnbdums13i1q4cak81ztfn4i
X-Rspam-User: 
X-HE-Tag: 1766087512-310087
X-HE-Meta: U2FsdGVkX1/25CjHPvHDbpB2Xy+YjYj9uICYdbOx4Pt49t0B42qFYqWCo3BWVqZP4+TIzVhdp7r6CC8dgDeHUqa8DrfEVftPMFrn8ejCFmZjVi/tT/qvtw45zrh2ly3P1/syZOdBjdGEctvj+nGbcT6nRPGwVf4EZ5Zu+rQHNwdS0L1xiVuwQM2WBN8RlyDUxKDX0vVPJghtRbz6xXC6TVCFf9/qZ9R4b6vHyaCUoOcfCHX3G3erXoAMEglACCbNgMMy6o3hdUf3+bxSJRn8fh+iwEMlVaeriCL64o8qSQh81WzN7JZVDDEsm13DiYQhKPWRP4TaCuvTzP3iYQfRURXFrErb+bemYIcV1kXF7DCc0jcj8b6vRzb/ZovOT17trXpr+sBTx4stIY1yeOBltgZrHIqZCUU2hfmWeiF9WFQxzPT6uLHBRUywzNh7cGarh3HArTysrLDUdnfzoKJRoC83KGzCoS9qVpXXcVF4d8gMM8l9cljHCFrO/w+UNh/9bVs3qfWM6hXdhJaLaA1yQRMFdAhYNsXD48PI/YSE0lkG+qljKuQ5GirO+y/36r0/iUgq+sbGsIFQQSmKF+smdam9gXqCJpXrxX6JsE9tt5xdH8D8W3Vy6Zu64gEXJxB5duUs4pNBFLZTEMqcW1LLW15YR/dvkUS37p4guFswyW/wAFUwHyINRC43lSjqoninfjHsj6RK6UgO80V2RFJfpofOTzCLJQxR8Rc+JsiqHBDJ1X+CMcEhc4GdqZdKxf1QbGf2VKtabnmiryWOrDacjIqliYoYVV1IyfLVq3MD3cSxK+SiXyqmx01dWgivWyZQfElFo/d4Jgb0Lwsq4SQzXQhLopGIp0ZAwfy0Ftgu6JIwmzsI7lsB5nvgOMRYJxF9hlV0PF4YUh9zX/ousgJeqiGNlN+wmaGLnwE/Y+LSIwPZG/EO8BZCo5nHUVclLUb9F+vr+yYpj0xcLNdQvsc
 Q+6VXI+R
 HtUm54kWRijCdS3F1gXvjzHi9CqrbrZXc49ZrjxnIcyvdC/eG+zUAo/aXZmfLtUzHpzZaluFvxUjvTWdAxZ3JNxkumu12LgY08nkz7BCsYL32AwHxh0CrCvHopRTHmgRAqNBtKqZyC8lXj2Kd9t1gzWn6ImMDXHwMPv0Uxks22uCysDazHO3WQsDb+o4yr0cqECx3f1hllPENAOZ2WGnOi1VgO5CXfLGIOLNcNFD4Ez1V53lCHIzviD1YN04lmTtod8YVgZF4elFKN/RwQLbsTtjxur4oYIrwrVhts/eesdB1TxqRoiEN7HI5i22xVbrrLV9yUb+FI650tOrgITM83Ge6LLoH/rdJkV0nWSxcpx/MmDEDkph4r0BNBO0yIjJqS+vkd6N05O9yXXkXjc68Ii0Lhkvs0WsDKE7YWdLRIIN8TMKgVmXsMuRghAq/xIyO1I4lFFjZdY2AL4822Cp2QWX8+9MP/UAGRm2XVTA33xCKH1lIqB9O1kwv9AClVE3IIBaOasZ22U6JMeIxym2zek+PhcCDEwo4JPYh5rL7PM6zaObGjSo4yCwkcMRr2z8jH4sIDn4ZofBzVdR82Jv5x2v1brJNsWH9g5tQ69tpkMDMyoq4O5Y+LWk6irXg+fQMq4CsLAJvRnz+nie+AUFQ47/Cyw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Dec 17, 2025 at 4:59=E2=80=AFPM Shakeel Butt <shakeel.butt@linux.de=
v> wrote:
>
> For the sleepable context, convert freader to use __kernel_read()
> instead of direct page cache access via read_cache_folio(). This
> simplifies the faultable code path by using the standard kernel file
> reading interface which handles all the complexity of reading file data.
>
> At the moment we are not changing the code for non-sleepable context
> which uses filemap_get_folio() and only succeeds if the target folios
> are already in memory and up-to-date. The reason is to keep the patch
> simple and easier to backport to stable kernels.
>
> Syzbot repro does not crash the kernel anymore and the selftests run
> successfully.
>
> In the follow up we will make __kernel_read() with IOCB_NOWAIT work for
> non-sleepable contexts. In addition, I would like to replace the
> secretmem check with a more generic approach and will add fstest for the
> buildid code.
>
> Reported-by: syzbot+09b7d050e4806540153d@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=3D09b7d050e4806540153d
> Fixes: ad41251c290d ("lib/buildid: implement sleepable build_id_parse() A=
PI")
> Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
> ---
>  lib/buildid.c | 47 +++++++++++++++++++++++++++++++++++------------
>  1 file changed, 35 insertions(+), 12 deletions(-)
>
> diff --git a/lib/buildid.c b/lib/buildid.c
> index aaf61dfc0919..e7e258532720 100644
> --- a/lib/buildid.c
> +++ b/lib/buildid.c
> @@ -5,6 +5,7 @@
>  #include <linux/elf.h>
>  #include <linux/kernel.h>
>  #include <linux/pagemap.h>
> +#include <linux/fs.h>
>  #include <linux/secretmem.h>
>
>  #define BUILD_ID 3
> @@ -37,6 +38,29 @@ static void freader_put_folio(struct freader *r)
>         r->folio =3D NULL;
>  }
>
> +/*
> + * Data is read directly into r->buf. Returns pointer to the buffer
> + * on success, NULL on failure with r->err set.
> + */
> +static const void *freader_fetch_sync(struct freader *r, loff_t file_off=
, size_t sz)
> +{
> +       ssize_t ret;
> +       loff_t pos =3D file_off;
> +       char *buf =3D r->buf;
> +
> +       do {
> +               ret =3D __kernel_read(r->file, r->buf, sz, &pos);

r->buf -> buf

(and please add [PATCH bpf] for next revision)

pw-bot: cr


> +               if (ret <=3D 0) {
> +                       r->err =3D ret ?: -EIO;
> +                       return NULL;
> +               }
> +               buf +=3D ret;
> +               sz -=3D ret;
> +       } while (sz > 0);
> +
> +       return r->buf;
> +}
> +
>  static int freader_get_folio(struct freader *r, loff_t file_off)
>  {
>         /* check if we can just reuse current folio */
> @@ -46,20 +70,9 @@ static int freader_get_folio(struct freader *r, loff_t=
 file_off)
>
>         freader_put_folio(r);
>
> -       /* reject secretmem folios created with memfd_secret() */
> -       if (secretmem_mapping(r->file->f_mapping))
> -               return -EFAULT;
> -
> +       /* only use page cache lookup - fail if not already cached */
>         r->folio =3D filemap_get_folio(r->file->f_mapping, file_off >> PA=
GE_SHIFT);
>
> -       /* if sleeping is allowed, wait for the page, if necessary */
> -       if (r->may_fault && (IS_ERR(r->folio) || !folio_test_uptodate(r->=
folio))) {
> -               filemap_invalidate_lock_shared(r->file->f_mapping);
> -               r->folio =3D read_cache_folio(r->file->f_mapping, file_of=
f >> PAGE_SHIFT,
> -                                           NULL, r->file);
> -               filemap_invalidate_unlock_shared(r->file->f_mapping);
> -       }
> -
>         if (IS_ERR(r->folio) || !folio_test_uptodate(r->folio)) {
>                 if (!IS_ERR(r->folio))
>                         folio_put(r->folio);
> @@ -97,6 +110,16 @@ const void *freader_fetch(struct freader *r, loff_t f=
ile_off, size_t sz)
>                 return r->data + file_off;
>         }
>
> +       /* reject secretmem folios created with memfd_secret() */
> +       if (secretmem_mapping(r->file->f_mapping)) {
> +               r->err =3D -EFAULT;
> +               return NULL;
> +       }
> +
> +       /* use __kernel_read() for sleepable context */
> +       if (r->may_fault)
> +               return freader_fetch_sync(r, file_off, sz);
> +
>         /* fetch or reuse folio for given file offset */
>         r->err =3D freader_get_folio(r, file_off);
>         if (r->err)
> --
> 2.47.3
>

