Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 93F68CCF9EB
	for <linux-mm@archiver.kernel.org>; Tue, 28 Oct 2025 17:22:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 00A4D8018F; Tue, 28 Oct 2025 13:22:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F24448013F; Tue, 28 Oct 2025 13:22:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E61528018F; Tue, 28 Oct 2025 13:22:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id CED4A8013F
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 13:22:40 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8D60E592E1
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 17:22:40 +0000 (UTC)
X-FDA: 84048192480.14.BCE3B1A
Received: from mail-qt1-f172.google.com (mail-qt1-f172.google.com [209.85.160.172])
	by imf10.hostedemail.com (Postfix) with ESMTP id 67E7DC000C
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 17:22:38 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=dVZSKhho;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf10.hostedemail.com: domain of surenb@google.com designates 209.85.160.172 as permitted sender) smtp.mailfrom=surenb@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761672158;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WXkInKYza36OKEjDJ9gQla/X4/pbEXOW59mglWVYVe0=;
	b=ytUXQe8yfYLX/kirgroBk88sPJNRzYYljPDp6otomsjywke6a2GQx6xCgTgegNk72qGkbg
	s6BtwI0wT5EdeakgdUsXRDxH0Q0o4TVj3ZDXt4LNemsZjqOyl4C6r04rcVCmBa4l5jAUwq
	+uupuP1BwKpYSPAdgjyz40jnhsgjTfU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761672158; a=rsa-sha256;
	cv=none;
	b=ldgxQfkoxLX9T13y37tj3GAdXmCA9vkUhtRz0tBZcxoaw7MznEVulkRm5cQjs7qgPWuHB/
	nljkCBDsRezusonOyeRgxCNZ1eNwuPnfE1J5YxFto8h6N4xeE6rw3/obkj3vJklKyzaCRD
	LsIY2z25TEnM8nifjbP0L9xed8MlR9M=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=dVZSKhho;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf10.hostedemail.com: domain of surenb@google.com designates 209.85.160.172 as permitted sender) smtp.mailfrom=surenb@google.com
Received: by mail-qt1-f172.google.com with SMTP id d75a77b69052e-4ed0c8e4dbcso23081cf.0
        for <linux-mm@kvack.org>; Tue, 28 Oct 2025 10:22:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1761672157; x=1762276957; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WXkInKYza36OKEjDJ9gQla/X4/pbEXOW59mglWVYVe0=;
        b=dVZSKhhob8fGZl2D4apWYczDT5XDGa40uy5AHaIsU5QLLVKF5Ich51QBoco+LQdvCx
         GsUBZG1gXbFbtYuhP0wf8Kcn+rtD0B7iYKG78VT3llOnQAdGS9ID4QA0nrrrjVUeubWo
         +gzcrutvBOdiKrK91ipt9AwoCF83I9eHYfZf18gAq6CitPtG9jsEVC3FSaOxKIsylXvI
         Fh+On6uEBkDW/uHH2DCMPno8BzBj/jCEa1Fdkr39WXdDakcTD08+8vdamzo4pn9uVv+h
         SWhl/uJTuia1kLT93OH78mxHt0tF4NkJOOMwHBSCSfSYFSIxTVHG9I9YP/ZNo2BEceWG
         oFcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761672157; x=1762276957;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WXkInKYza36OKEjDJ9gQla/X4/pbEXOW59mglWVYVe0=;
        b=snfxtqD6wUmGadFkdTSJGs68jAoffhcO/8ICwdmAxIaoKZ+zfITP/fBLnLOuLTIy/q
         TCfbZFCnGxSzcFrOINwZuWnA5Zw7H0a1RJ+XBzA24Ejh9T1Y5fdlcoZ2mhqTzNr0xjwn
         gHgTZVvqYXWJq8X1du3fCai3Mp0+dyaE3RH8hbKyZcYOa4mNGnvX/3Fr5kG4dGXovUYD
         xcu+woGVeWfxGnhe5LiJAn53DaL0HBjS9vrwcCREYeLfBmNTAnrbo7mFcPrNSXN8vX1X
         f7D3lkvucZco3w8rJf6+6vA+S4q3Cwz4eY6w+xBS/coQnMud2teI5zTnkfpdkCmBjpHo
         ImYw==
X-Forwarded-Encrypted: i=1; AJvYcCWFZp3mN9N74VOm6MLhKfam9IiNRUJfs3KrlHmiAybOBip40ddnpnquSwIVhIkCP8dTio+1YJ4hyQ==@kvack.org
X-Gm-Message-State: AOJu0Yye0LXi6xFXscanJ+z/Yq+l2bXnmU0knVHzE6ZzowzHto/WQhp/
	BHF1JHoasG9CNgzbVW6sfMXN5RXZ6qcZYrrDPCT7//vh7UvcClHomIcHJ3Gn+4KZfDeSDMRUuo9
	utjEy/vm00cpQuKSZeE0psDBj22PYZFlyeNEWPjFj
X-Gm-Gg: ASbGncupHv1cCt1xX6yWwTnT2GHzNo8tKmMkGWf+0nFVFGYYEUY37tyUWUU4IASbj1M
	YkKMiwFSX0DRbWN5cJOIR6UH8NQYENNm/FEDl6b3TRvGcdsDBblfnGB6x4WWYRYpJYRdbsanWAv
	N2bwuYQ4hH6fX9JM1/Un7h+kPEddfqgzQeYTKym9/t7y6kNCtQZcHjxk09QXqP+iA5NR9BufZK8
	/5NtOZRp4DRkAr2T7wItt4E2E8gDsY5u2TZSKVd+6nbNVjjbef1urvIhP+M8U3GJCmxOU1MvxlK
	UcxvK/SfsCG8tWYZokqRd3Abyw==
X-Google-Smtp-Source: AGHT+IHn/oTfm/JuwLti1FuzoxQ+/oX/hUBOtVlQ025ocwE7vk9a+/tdWJJNQoH1S/B6JBQomz11gO7zAkAgU9yuzGA=
X-Received: by 2002:a05:622a:244d:b0:4b7:9b06:ca9f with SMTP id
 d75a77b69052e-4ed157de56amr256901cf.2.1761672157120; Tue, 28 Oct 2025
 10:22:37 -0700 (PDT)
MIME-Version: 1.0
References: <20251027122847.320924-1-harry.yoo@oracle.com> <20251027122847.320924-3-harry.yoo@oracle.com>
In-Reply-To: <20251027122847.320924-3-harry.yoo@oracle.com>
From: Suren Baghdasaryan <surenb@google.com>
Date: Tue, 28 Oct 2025 10:22:24 -0700
X-Gm-Features: AWmQ_blgmjSynkbbdCoPvFJY7HzNhE5kHecWMsBfPzVUZdQoPVaPzHQJsWkzclk
Message-ID: <CAJuCfpGo=m9vdRQCqa-2MtAb9GBNsF4+6YXm7vzGFYtqsOzq1A@mail.gmail.com>
Subject: Re: [RFC PATCH V3 2/7] ext4: specify the free pointer offset for ext4_inode_cache
To: Harry Yoo <harry.yoo@oracle.com>
Cc: akpm@linux-foundation.org, vbabka@suse.cz, andreyknvl@gmail.com, 
	cl@linux.com, dvyukov@google.com, glider@google.com, hannes@cmpxchg.org, 
	linux-mm@kvack.org, mhocko@kernel.org, muchun.song@linux.dev, 
	rientjes@google.com, roman.gushchin@linux.dev, ryabinin.a.a@gmail.com, 
	shakeel.butt@linux.dev, vincenzo.frascino@arm.com, yeoreum.yun@arm.com, 
	tytso@mit.edu, adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam01
X-Stat-Signature: qh5e13nkg5j776tcdxkagqhbfr78u8no
X-Rspam-User: 
X-Rspamd-Queue-Id: 67E7DC000C
X-HE-Tag: 1761672158-735939
X-HE-Meta: U2FsdGVkX1+7ggCW3J3XD25ZbGvZLy5PxJRphzKZGnEV/gL3pi6FQ50bpqaJkxbb9VIxDUEx6aZ1+TMN57blN2wYhuWCQbS8IyWdAVZLXXE7dMBhJsLm1cAOLOkkUf71MBUDezEhUQfxTyzmv3mOOsM+jAWD9VFdECAXFrbErW0Ws4aLdwHGOj4beZuZG91mTICgRsqf5vJT8NToYAr1d/N3oWU5vdGreLaAdYxoQ8BkvmxDEGvgzWr7ePa4L0oI0BI31ithitXH1Ux7zGcxWy0DlKQOyH/I+i12pSBpB5VCct+YwrNghZjA/V8SSG4JDWiJBdN97JrHVbM+CrOtY/2f208A4GPTSlcLUdfgd2xjEHmhSvxohHUJdoCzMsIr1Hc0FhYWaJF4MP/ye6daa56pTHANNbRZrv3m+p24uu1Fjop4Eb4YxG6JSiJr7Of7TW6tIHXvsZ3bUv0+QhPqcCiijrhzlU12WXgz3qeM1xjfCU6Uvr+3nPfoGVTSBPce36aKrXHmv15a6SaKiHImjbjTgvl7+bSghyruVXj5sftHCjizQQxU/+fU0ATwf49WYoUh4Uvw2k/pFyjB0SNiONoCX6AJrqa0Sxk9skK7YaRua1nplz6Pt2s4hWS6Htv+f7FfJ2J0hbqpaqftnmOF7yWlj/WeuiqXQAmtBPsJYkWCgP4sQL5+yYV9uAqSdTFCjfNOnnsMClpaT8lFUskeo48gKSbGqeWLG7eODLP/DrwV3ef8NzZBePWlE79bkfTvzgb73SdI6Iz0X3k9gKgWzyqibUMruO03x+0O5TOQmon2PV+v86i29qzsCJu9QtX2xkE3QniGJkQAmr4/P7OeecAhcqubZ/UkNOUhBL29qdF5RU4v0Tubu7h1cWP9uzK6nRiqnssFhRxg9rwPsC8P6g99cAicFz2M+B4CRItBloaTk38+OfusWIQyFEonhmZpmvk1BOvDcbDXL9gduTZ
 T6WboqYV
 X/UKo/1XcQMkCzC0qYjSdc1OwfUTsQk3lo61oETDZUQ65vkD7urIuz2tgGnxeNoII+kIJGq9rWcCWMYwHffN8Bm06l9nR8Tk3PewB6w9WLY9vSD4OE3d//6u5hFowToiT4fRZm/gBfAcj9cdp78YSghjHlsT6wP1FiQHWtIqu+365201xm9kSluTe3pGoT+naRQwqmaSJ77S81mjAhuOhIca37chb0esQXLpYd4dj0c5XQtB9NJodMdqA/HrI+WGUnYHMzd/DOOPKGGM9cC9cYGsI3prK59FNhWZ4KQUiL95ue7TG9imoryory6YhQAUpRaFpFkGW2lo6SEesyq2Aol0BeSI5Xv7Jh3IUOYmdziYPhwvBxhqHzu4p95jedRvSy3y4+p4TttRtAM4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Oct 27, 2025 at 5:29=E2=80=AFAM Harry Yoo <harry.yoo@oracle.com> wr=
ote:
>
> Convert ext4_inode_cache to use the kmem_cache_args interface and
> specify a free pointer offset.
>
> Since ext4_inode_cache uses a constructor, the free pointer would be
> placed after the object to overwriting fields used by the constructor.
> However, some fields such as ->i_flags are not used by the constructor
> and can safely be repurposed for the free pointer.
>
> Specify the free pointer offset at i_flags to reduce the object size.
>
> Signed-off-by: Harry Yoo <harry.yoo@oracle.com>
> ---
>  fs/ext4/super.c | 20 ++++++++++++++------
>  1 file changed, 14 insertions(+), 6 deletions(-)
>
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index 699c15db28a8..2860e0ee913f 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -1474,12 +1474,20 @@ static void init_once(void *foo)
>
>  static int __init init_inodecache(void)
>  {
> -       ext4_inode_cachep =3D kmem_cache_create_usercopy("ext4_inode_cach=
e",
> -                               sizeof(struct ext4_inode_info), 0,
> -                               SLAB_RECLAIM_ACCOUNT | SLAB_ACCOUNT,
> -                               offsetof(struct ext4_inode_info, i_data),
> -                               sizeof_field(struct ext4_inode_info, i_da=
ta),
> -                               init_once);
> +       struct kmem_cache_args args =3D {
> +               .align =3D 0,
> +               .useroffset =3D offsetof(struct ext4_inode_info, i_data),
> +               .usersize =3D sizeof_field(struct ext4_inode_info, i_data=
),
> +               .use_freeptr_offset =3D true,
> +               .freeptr_offset =3D offsetof(struct ext4_inode_info, i_fl=
ags),

Hi Harry,
AFAIK freeptr_offset can be used only with SLAB_TYPESAFE_BY_RCU caches
(see https://elixir.bootlin.com/linux/v6.18-rc3/source/include/linux/slab.h=
#L302)
and check at https://elixir.bootlin.com/linux/v6.18-rc3/source/mm/slab_comm=
on.c#L234
should fail otherwise. The cache you are changing does not seem to
have this flag set.
Thanks,
Suren.

> +               .ctor =3D init_once,
> +       };
> +
> +       ext4_inode_cachep =3D kmem_cache_create("ext4_inode_cache",
> +                               sizeof(struct ext4_inode_info),
> +                               &args,
> +                               SLAB_RECLAIM_ACCOUNT | SLAB_ACCOUNT);
> +
>         if (ext4_inode_cachep =3D=3D NULL)
>                 return -ENOMEM;
>         return 0;
> --
> 2.43.0
>

