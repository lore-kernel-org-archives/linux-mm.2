Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5C429CCD193
	for <linux-mm@archiver.kernel.org>; Thu, 23 Oct 2025 05:58:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 978CE8E0005; Thu, 23 Oct 2025 01:58:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 94FAC8E0002; Thu, 23 Oct 2025 01:58:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 88C988E0005; Thu, 23 Oct 2025 01:58:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 77F828E0002
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 01:58:06 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 234DA160A3D
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 05:58:06 +0000 (UTC)
X-FDA: 84028323372.01.8772462
Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	by imf23.hostedemail.com (Postfix) with ESMTP id 381EB140005
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 05:58:04 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Ser0ks2c;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf23.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.46 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761199084;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KqT3fmbl/NyFgzc1chkjaxa8Hzi6O3hC82OBdEi+dws=;
	b=Il+umLMSUcCpWLC8BAEp8w3oHn2ywl8CufA9KdtyqRw6KyAGBgFmepYKi9ye/1l/5oTb2D
	yHT1H9dAClrZ3JR3qM1Ggzh+o7qcsucz7OyBWNls9wg3PcFvgPxJsxKKcjVnQZhHA4bcbH
	ijuHWyf9wM6vOWU4UsOMEThfDFrBGGY=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Ser0ks2c;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf23.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.46 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761199084; a=rsa-sha256;
	cv=none;
	b=bLPE78SpQzhWiBo600zFOM/I+VmCMWmxTB70Yxyh9n+xMzMTfEHvSoRICAzp5kt/5SXlBd
	idoWEim5LBkne61vVmsRKZtJefstVUlxcVyNFOykDThLTr+17AjAsAJuz42EpcxJFE3qjh
	laCpDATgsRI2cMiJy3FkL/GcLqKeoxM=
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-63c09141cabso616788a12.0
        for <linux-mm@kvack.org>; Wed, 22 Oct 2025 22:58:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761199082; x=1761803882; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KqT3fmbl/NyFgzc1chkjaxa8Hzi6O3hC82OBdEi+dws=;
        b=Ser0ks2cj3K1ThVWKNhkaUuz66XdwAoY1zSGmwDoOmY7BV8wqLcvBgUc+2BBUDDvSa
         JfbKb6Lg3ECu4FdofE1EbVHZHH/Q9303mkvpW3s/AKO0qoOXMtujGzMdabkhO01qM2s8
         fsgub/VAIie2kzm00P7OTJ6RNemB+GoeufE6QOqAddFLVic0ex6PMHQfmobthlKsgZsq
         TrwwhDWgIZnu7Zoa8We2q0CxDxF9YIQik6Bx9d+9YAwuVRSS5IQQgWURsQV5oF4xl8Nu
         GdLzJaFn0YpBdVz9SvDQYfXdnDsknwyJj4DjBQ1y3PJy0h52ps+S5XRGRqG1hLj0JlmB
         EFvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761199082; x=1761803882;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KqT3fmbl/NyFgzc1chkjaxa8Hzi6O3hC82OBdEi+dws=;
        b=sE8HUHV2l6mnoAG+XrsZojx+GtLShzaWIb/ZGQeu3LAvyAgl5oJl/ZpMtG3mA5esy1
         juWhVjuhbo85jXWG3aLZSfxBJIVAGLMSeJu12imEpOUa14ggmHFvss/ReS7+R+hQpsJW
         d5XGrIACNkje3LgTHyYfb/M705I4woPCj22/akTA3QoZChn9KKyqhdUAr9x5OYunlU9d
         ABSP8X51MSGUz+7UFJ83c9YUpsLjesn64PQu9LBpt6v8Wu0pVYHQoY1PAIAb+oqV7zS4
         5/cZUw5t3lciBt2/3qChigKJzhg0VpEhlpib+miJGniMX2m7ZyBPrKdy44++BcaNARJo
         sQxA==
X-Gm-Message-State: AOJu0YyPHxzqSkrJniH1Ho5dvFR5r1rw76BvuhK+YhrMpKqlz9gIEHEX
	lrDTnc5LIbVS4SHxrIPLUOVgS/reCE0tMebRimOx9gES/ciNiiiai9Qo5fNT4BbWLiPh+0YUeSh
	+/wXHeS7PDOZNa+c+aaqhxl2Wi1BxyqI=
X-Gm-Gg: ASbGncuqqsF2GK5fvtOlIhJIm8csAFBPvlKbA/1zfLm4RWSHTbEiRt9+unPWoonEk1R
	wfm+v6wjOKc9W4iuVbDpGJ1+jBz0R+7zH+9yzHimN2aG6CTO9Ysq75T2ZxCjmZxIX+OS9WKPJsH
	89nCFOGkEfWB1WyztYPMwq3cYeWwtEKxJxuls2EnN+IazaE1OZtxQbKksIbar7s97N+jncNCzTf
	IyZIgTCxuM05lBBhLBmRkDlcwgXLyFRu9bWbFFonHBdne7bX5gX8/RwQPqi
X-Google-Smtp-Source: AGHT+IHEgrhoMFz9wAJKmZGqrPoGLd0Yc4jrCJX0a9ZPmSZc59sboKW2LRJQWOCdJd5RmikbQ3D38I9zHdHcXkeQpug=
X-Received: by 2002:a17:907:3f12:b0:b6d:5718:d43f with SMTP id
 a640c23a62f3a-b6d5718d7b1mr65656366b.39.1761199082291; Wed, 22 Oct 2025
 22:58:02 -0700 (PDT)
MIME-Version: 1.0
References: <20251022105719.18321-1-ryncsn@gmail.com> <CAGsJ_4zKcxO-Tacy0jCZSs83+fGsgqQYNib9nCXoLTuL+hdLxQ@mail.gmail.com>
In-Reply-To: <CAGsJ_4zKcxO-Tacy0jCZSs83+fGsgqQYNib9nCXoLTuL+hdLxQ@mail.gmail.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Thu, 23 Oct 2025 13:57:24 +0800
X-Gm-Features: AWmQ_bkGCKMn-MW625Ff-LLLuPlBu8nKTWVvjEa-19moLgG3QM5ri2QsiZJtA4k
Message-ID: <CAMgjq7CdQK_k_oGfOwCtMm18uAXrGwfwUz93pt7kaN-S64G0Cg@mail.gmail.com>
Subject: Re: [PATCH v2] mm/shmem: fix THP allocation and fallback loop
To: Barry Song <21cnbao@gmail.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Hugh Dickins <hughd@google.com>, 
	Dev Jain <dev.jain@arm.com>, David Hildenbrand <david@redhat.com>, 
	Liam Howlett <liam.howlett@oracle.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Mariano Pache <npache@redhat.com>, Matthew Wilcox <willy@infradead.org>, 
	Ryan Roberts <ryan.roberts@arm.com>, Zi Yan <ziy@nvidia.com>, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: 381EB140005
X-Rspamd-Server: rspam03
X-Stat-Signature: tghtnx6jwyc9eeao96ujhgz9zsiqwa16
X-HE-Tag: 1761199084-968877
X-HE-Meta: U2FsdGVkX1+G5G9pqpVNU394oJc/MhHGbKAFUgxRpKacLjFDAbXK0d2DIzUcC2FuJzKwhFvjtFMt+whTmvMyPVrL5I1eIvfXvQawPVO88IGCYE1zpXU+4zF3LO89ZHSiMkbWKwfphaiKcX23YgTwkEvfJcqwEcxIEUYSuzAqcmAQKPbELskeNSNgMCW00nyE5aN5/PA5XYAjNCzo4p2lLtxD2MJEpceGm9wzTrjDk8KR/qoIhX9j9Zeu+u5BS7RKdErMir4Fr2IgyBSxdvCkfWVttIIXl6IXeJCpA73fmsNnH4gnbmgsQoqNuje8WBsJasv5+rv3dJoMIFN2zgsJlqalKvFx3z2vxGzzPm9hLMUD/q3nCZ0/Q8Fd/UvQJGobz8wD2VFN/TdC/jHDinTNNcn7fa+6B0vtlPtvAbH9/cXzlP9JitwyE2TFc4/dTy0KoTnNiqLAXy2l+MaaWCrZmsE7yjKxPAygPcTclp4OW+G6owB/GYddaRvnwf3MmZksjFH7XUWpVaQR72ZgKKYBB0b7DoMJd26YW0o2MD6U+cpua6ilnznAygqCfXYcTIyEwWAOAlxiK4YRhegAIvp+R+kk7kdEVz1zjimjbj9vMZR5wWE2oIXEmz7PaaJHWeC9pyuVRcYTs5a7Y3vF3N6mZPCYOTP/qoCNlnJDFi+36HH0gTmkee56vfpRMq9fsrIyO3xWFcg5J6INNqZch1mhvH5Q4fuN4EY8ZN1bKC7Oh6WjZHBVEg6UfGRDrSnmZ8QXvfsU9nHKLhWTfckiqPY5e7yuUuGWq+cU6drmVL88e1A+RFLdJt3RTomRq019dzsddr7bKg5vipM5+Xm5AfA6d0YY1o9l/AOLcdjYRT8nrbU7toQuzQcON6BvJ4uyXZCtfYbP3N+1tZmqu7PcLbsb7+PCMBRj7t+X4TMzK56SsVV0IbEbgI+AsPSqrYerak3f2rbOrSvp27i3cN7vJQB
 QRBFrs6x
 ZQJUKHvtCB0wNdWo13qvD35Tm/zqEYWE4/do+M0cDWMVfa4MIe7jMyv6xdO3gNUNFT4aKxwAPyou7WUYhRqrCqj9jy06vYmx3pODdmwPo6J3Boegwd2WVgtWdH3OP+Bx4G/IFCmcvo6pNxI5wLPEfDLY9+SLFKpEkQwtQE3TwagWBqrk7SlRXoON/fZjUw2z8wB2s1UGgJ7GDfRkM+V3ywBWzjk7fl7VPejbF2P5obiqKQkmYe6/Swi3VamRbA5JG9HYEFUfOLMGJY0MjlibdkVlU9+/n/Pxh50mTsJ6r7uLMfQoT/fKAOv0rAcvIO7ZMZYL4FVPx59EPplaX9seinez+pqa22yE2FGlONTAZnW+uZPM0iR59Hc94knLZHmVFtNY5
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Oct 23, 2025 at 1:51=E2=80=AFPM Barry Song <21cnbao@gmail.com> wrot=
e:
> > diff --git a/mm/shmem.c b/mm/shmem.c
> > index b50ce7dbc84a..7559773ebb30 100644
> > --- a/mm/shmem.c
> > +++ b/mm/shmem.c
> > @@ -1895,10 +1895,11 @@ static struct folio *shmem_alloc_and_add_folio(=
struct vm_fault *vmf,
> >                 order =3D highest_order(suitable_orders);
> >                 while (suitable_orders) {
> >                         pages =3D 1UL << order;
> > -                       index =3D round_down(index, pages);
> > -                       folio =3D shmem_alloc_folio(gfp, order, info, i=
ndex);
> > -                       if (folio)
> > +                       folio =3D shmem_alloc_folio(gfp, order, info, r=
ound_down(index, pages));
> > +                       if (folio) {
> > +                               index =3D round_down(index, pages);
> >                                 goto allocated;
> > +                       }
>
> Could this be a temporary variable to store round_down(index, pages)?

Right we can do that, but the generated code should be the same, the
compiler is smart enough, I just checked the generated code with gcc /
clang.

Do you think the code will be cleaner with a temporary variable? I can
send a V3 if anyone suggests, it's really a trivial change.

