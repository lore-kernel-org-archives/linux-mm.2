Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 24680D116F6
	for <linux-mm@archiver.kernel.org>; Mon,  1 Dec 2025 21:39:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 707256B0005; Mon,  1 Dec 2025 16:39:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6DF196B0088; Mon,  1 Dec 2025 16:39:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 61BF36B0089; Mon,  1 Dec 2025 16:39:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 531DD6B0005
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 16:39:29 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 045A1131EF7
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 21:39:28 +0000 (UTC)
X-FDA: 84172218858.27.3945851
Received: from mail-qk1-f169.google.com (mail-qk1-f169.google.com [209.85.222.169])
	by imf06.hostedemail.com (Postfix) with ESMTP id 00F34180014
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 21:39:26 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=L91qMD2R;
	spf=pass (imf06.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.222.169 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764625167;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ya5FXlt3fgfn2bY5272+Q5pv7MOagNgU6+eVeVRebso=;
	b=y6LGRdCUwq64mNa1Ltv/kx2d5MHqMOjXh0jVACNHQEyKkB6ygQViVJGrZnFzdiqoHnHe+r
	qL0LDjyC0HCItpB1KgVfHy0tGBGQfBtDCAKUtfZz3DItAYq9OC87Xr3sfR2ypKR1ugzzw6
	mDSbXPW6gUSdu1hqo9MAXTXeOnjfN84=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=L91qMD2R;
	spf=pass (imf06.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.222.169 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764625167; a=rsa-sha256;
	cv=none;
	b=CDlnuXvzVVTmwT0Mj3+hz7b99NKTIiO8AGAM6Q6MRI8A0jDzOrtJxGszgipgC6iuay53dk
	QICmksQ/OeJcEq05UWlZPkWH5WNO8IUvJ8WoNFQ7YQTmLoT6nb5cf+UycByX7H0n6vEYqb
	ycb9T5awDs8Mas03Ags0ZvkI+2HBxd8=
Received: by mail-qk1-f169.google.com with SMTP id af79cd13be357-8b0f54370ecso449892585a.2
        for <linux-mm@kvack.org>; Mon, 01 Dec 2025 13:39:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764625166; x=1765229966; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ya5FXlt3fgfn2bY5272+Q5pv7MOagNgU6+eVeVRebso=;
        b=L91qMD2RzUrXj3AcD811InVXNdJvC8zOKyQJAth2XUR1G4gfcAFiFHAQbE9CT8pTQp
         fEfgCpre0MlfgEbUkuOKo19j6XYGWb2hhlFi2LZb0W3TKOT1M11EYOtTEg36m6mzxBr/
         /dVB8mOzV3897Dv2xXhkZkpAZ0gR/yefikqwdeWZwd2oPqJzPmSodZAaqD/ggxRgaAuf
         2IYrtopeQo6kdaHk+Z+6FErrLFVOdsb9XQRrbtyj3yvbISYilKcLSyunQvZ4GpwpCB8L
         pf8JTsP0JleSqOJY23s2qLMRXw4REA2YNfUwIRBJo2IPEyCOCW+2O8M3cjw5IH9WNarJ
         Faow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764625166; x=1765229966;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Ya5FXlt3fgfn2bY5272+Q5pv7MOagNgU6+eVeVRebso=;
        b=R0D96zGfDyn1irLu+Z1sPr5uCnb4eSBFmkyKNvfGXjLJMyANQVCf2HYEcJAatfH892
         U45RnzCZ1VJD1949xbLz2m5KSMafYNhXMjzQMOCcV9avPybwqVpNksrtsOBrzCt7NStH
         oZINsfkWD1R+cREfXCJ8SW9AaaVpoEi6DCNx87NwPYaVH1Wz1abHvkVKAhWIPGsGZs5W
         hq8dy3Q0D6PSF9enxechrgVwNjYkm2r695uVttZUna6FJ62MCSmd0fn9Yhw3tn4YvgXy
         8eRy+s3E2NhGs+V3h3qVekQsM5LFwtmzqFcRpA2lr1bb9WT47HwLOwOXk8Rej1Y4pknL
         cRKA==
X-Forwarded-Encrypted: i=1; AJvYcCXRIJlBMAB+lBzfZhEyvz3WjN3kgH7MQBGFdvAVD02DtBZqIB9HJG3F+BliLSybywWqLySia/5uhg==@kvack.org
X-Gm-Message-State: AOJu0Yxs6ZVI8Ty+CYscS1pk0xg4OhxG9m6aota5jO4eHjtXEgrii1Cx
	bmeNehUL/ON07IHtokx+Hg25+j7/9QAZeOe+HBYkX3RKjv0zCw5ug2bRS6DiJ2HUo8cOnOvicRM
	fWDUxZIihz8DskC7uEF7buIafweThmJc=
X-Gm-Gg: ASbGnctX0pNaAzoWhiYUSQZ7Tk9WfCbqM2Z2xJc64eG62tI6kC0L0eC61jP+xr+1V9y
	dNoBFaf+rEaLyPuo+1khPJ3IxmY+37d6J3l3qN+IpHt4vBD++7w9LIEzFNE8HJXgpvlLikbsRkN
	ReA/Z+upA23LCuyhW7bY/MFySBz0txAoHA7EAx1bktcfLhVSlTatzdMjAouYQcD9pnh/lST2Jy9
	7pcLVdlppWT6o5R71GBolMYVgePwuGl+xdWWh2Ih9vMqehxPIgXpL0ZNre2tnB+kQ/Pxw==
X-Google-Smtp-Source: AGHT+IFDJ6lg5MxUSmUVun4F/Tz+fV/DaTriGHNCnPcATTgtDfNsilRg6+Hi6qXUw8UE/oCfbowoPuItAeaNKnkxOOI=
X-Received: by 2002:a05:620a:2907:b0:857:890f:7fab with SMTP id
 af79cd13be357-8b4ebdce57dmr3735537485a.85.1764625165847; Mon, 01 Dec 2025
 13:39:25 -0800 (PST)
MIME-Version: 1.0
References: <20251122090343.81243-1-21cnbao@gmail.com> <ed7701d7-28c8-4760-9ccb-f22fc1e9528e@kernel.org>
In-Reply-To: <ed7701d7-28c8-4760-9ccb-f22fc1e9528e@kernel.org>
From: Barry Song <21cnbao@gmail.com>
Date: Tue, 2 Dec 2025 05:39:14 +0800
X-Gm-Features: AWmQ_bkntYc9RqDd7viHZ4oh-bPL-P8xMulAYuAEyBuveMg92U8PVcocpttZ0iw
Message-ID: <CAGsJ_4zwXiwvHYvX6pBsyWLi-LXQcTDzR=e+hQ_4YOLd5BhCOA@mail.gmail.com>
Subject: Re: [PATCH RFC] mm/vmap: map contiguous pages in batches whenever possible
To: "David Hildenbrand (Red Hat)" <david@kernel.org>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, linux-media@vger.kernel.org, 
	dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org, 
	linux-kernel@vger.kernel.org, Barry Song <v-songbaohua@oppo.com>, 
	Uladzislau Rezki <urezki@gmail.com>, Sumit Semwal <sumit.semwal@linaro.org>, 
	John Stultz <jstultz@google.com>, Maxime Ripard <mripard@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 00F34180014
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: 48sib3auuto4x93gthaeqk7snxk8ctnf
X-HE-Tag: 1764625166-7487
X-HE-Meta: U2FsdGVkX18VXEFSY/8CZML2zMHYIrH8OdxbP/btYsdo+8942fjM6w2vyKwRBOBOAQ2RKe6XyB3A2hhM+niE+rTT4tfXI6UosLwI9kXbx0mAY0e0PdaSrYI63e574n92xcEBE+nazYYB3r8F/Y/ZMsLJFyNI9P4ua3mE9Mq5Enx72uAUzWC+4xbQooGseK0iyHwv2pfZeq16cOn7ozvjYt2qCRYMmYcWVkB32jxQZUX+/wx/KRKqtnf7EgYN8pBZ6srNcAm/OwPQr7OooGkAiyvgeU8L020HQ6MSFgvrj4p0FIsptS/5ejkPS2g53CSP1A669/V4z/RnFWR18GJkgSXJPYOVOBJ4TJ7LCp4MPWer0lPWwm9RYYNQB7bBO/+GhOmRAzrIvYHNb4Xu9xtorPgXDy5jHhT1wKvdFrOMj+iVlhw13K4yl+Wq/NssIueXa6C7cqLytkxpD376T0YPI4nH3RPDlMi2CY0p8Sbbm2EKJ4p9cCur7kPTQDyaI7q4QWVMMj5j3LA6/lth/ibq+rKKAjEKjf/luZzBz4HsTEevFSAROxbQuJHyOrPYDXoVQ2vt0u13KEGOSCAQg1/FBzU9F2QxT76BOg29+pJc/FjkOPQtOYOXSYNGsPmPUj1RISy5/+xtQQv5zAjdyQwUWncn0CxR/QmByhOkSp3mD35M3DcN/wVvpbszEX6VmlyRvc0XMDvYcwmVQHk4drlOTyleuEp58AiohdDKTfxJbpbXf9YxzSKzZ+N/XSxw3DmktsWa63JGssR0RpNtldXE2YdUVBcljaC/LU8upCoT0h8jE80f/Idpf9ROnHibw+v/0v8NuqmniNtmAA5KOls+pe28W2tJRp6j3yoc8g/g2yTWuctMEsrISYb8in8PWxLQIUk+aNvGxBUFURSSF0hBIrNYulAxx1l8gVekAlByvtr+cFFUieeLh/lpkgSrovpNaoDvYtSkfkWGSxYPQQB
 n2yXogro
 PsfpAsSpXuWs1oXxZiPIt6WBforqJFwWPCcZYbfP+gPBLgOacmKI0d63IwpMxTVFrnjSTXXJRCL+vLsX5Io01iXhF5e9S3PsRuSy2awmd1/d/TzAEe5q/t9vp0oV/NiEfuGLuaYybg6D/2qV1gld9XR2RxBgRhQT4DNkIqy7ppMk1AWYPke2gSia5YdNjt6zED3qBf6NOb7rJUT0F6FklJ8zUH5kWgsZBw6LbFKamG2tKBUNQhKs8vl+Gdm7T1vZ0ej33JPb/Ltl1PmerW7plmwbRlr92wEDbzoIkChxm8UxfMqeKe3ng6lX3mUlWYx8l7dldvXYOgOMXjKvuCyTC6cT8WyTdm6sHenOlJN8nKRHjNWcNCf2Qdq8reXV+wQro413q
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Dec 1, 2025 at 6:36=E2=80=AFPM David Hildenbrand (Red Hat)
<david@kernel.org> wrote:
[...]
> >
> > diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> > index 0832f944544c..af2e3e8c052a 100644
> > --- a/mm/vmalloc.c
> > +++ b/mm/vmalloc.c
> > @@ -642,6 +642,34 @@ static int vmap_small_pages_range_noflush(unsigned=
 long addr, unsigned long end,
> >       return err;
> >   }
> >
> > +static inline int get_vmap_batch_order(struct page **pages,
> > +             unsigned int stride,
> > +             int max_steps,
> > +             unsigned int idx)
>
> These fit into less lines.
>
> ideally
>
> \t\tunsigned int stride, int max_steps, unsigned int idx)

Right, thanks!

>
> > +{
>
> int order, nr_pages, i;
> struct page *base;
>
> But I think you can just drop "base". And order.

Right, thanks!

>
> > +     /*
> > +      * Currently, batching is only supported in vmap_pages_range
> > +      * when page_shift =3D=3D PAGE_SHIFT.
> > +      */
> > +     if (stride !=3D 1)
> > +             return 0;
> > +
> > +     struct page *base =3D pages[idx];
> > +     if (!PageHead(base))
> > +             return 0;
> > +
> > +     int order =3D compound_order(base);
> > +     int nr_pages =3D 1 << order;
>
>
> You can drop the head check etc and simply do
>
> nr_pages =3D compound_nr(pages[idx]);
> if (nr_pages =3D=3D 1)
>         return 0;
>

Nice. Since compound_nr() returns 1 for tail pages.

> Which raises the question: are these things folios? I assume not.

In my case, it=E2=80=99s simply alloc_pages with GFP_COMP. I assume that fo=
lios
allocated via folio_alloc() would also automatically benefit from this patc=
h?

Currently, vmap() takes a pages array as an argument. So even for a folio,
we need to expand it into individual pages. Simply passing a folios array t=
o
vmalloc likely won=E2=80=99t work, since vmap() could start and end at subp=
ages
in the middle of a folio.

Thanks
Barry

