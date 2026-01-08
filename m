Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EB97FD185C6
	for <linux-mm@archiver.kernel.org>; Thu,  8 Jan 2026 11:40:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 324CB6B0088; Thu,  8 Jan 2026 06:40:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2FD1D6B0089; Thu,  8 Jan 2026 06:40:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1FF786B0092; Thu,  8 Jan 2026 06:40:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 12A106B0088
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 06:40:03 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A5CAD16016C
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 11:40:02 +0000 (UTC)
X-FDA: 84308602644.27.C006098
Received: from mail-qv1-f47.google.com (mail-qv1-f47.google.com [209.85.219.47])
	by imf20.hostedemail.com (Postfix) with ESMTP id BDEDE1C0003
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 11:40:00 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=zi+2HFue;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf20.hostedemail.com: domain of glider@google.com designates 209.85.219.47 as permitted sender) smtp.mailfrom=glider@google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767872400; a=rsa-sha256;
	cv=none;
	b=aiHyfLrJKTm4c6Q8sl6kexH7HNHvlIc5fzyhYRJjiukacSetujUepR98bm0s3f0aT6xy4h
	jrmxqFBBtitzBMYj6prb/s3yp8NG2YBxhSVWTo8kYLPXEaRriaqkJu86U44Ewr7S7gsQhh
	3IiGqP8dope2Xzgi0wTS7ar58nu0oWw=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=zi+2HFue;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf20.hostedemail.com: domain of glider@google.com designates 209.85.219.47 as permitted sender) smtp.mailfrom=glider@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767872400;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=De/F7GrZ3a7XQW11zwFhVMyznAHPN5+HCcRNv17+1Go=;
	b=gQLHwgEkJOUhpUZi03S1Zhoh2Ui+k39E+sAoTIduOcxM2lbguyTyNCBWrIWP9aqaTEfKws
	d2wpO4EC9ORjcyh5q59YOeumQwCUxscJqRvD9tdXp3I0XQTkOCw0QO++Bfy0/V4iuembYS
	MiMdYO1C3c2nNZykwgvt370h1S97Gq8=
Received: by mail-qv1-f47.google.com with SMTP id 6a1803df08f44-88a2f2e5445so35976716d6.1
        for <linux-mm@kvack.org>; Thu, 08 Jan 2026 03:40:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767872400; x=1768477200; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=De/F7GrZ3a7XQW11zwFhVMyznAHPN5+HCcRNv17+1Go=;
        b=zi+2HFueeV8U/HWLE8QIOj0DDG09/Yx7eQwUJWFuChwu8Lh0nBL2E8BCo789ZMpIE0
         90WxT8r6qcgN8yEYVMZxkYXPrVgJEZT48V+SvVJSL+rcJkVe228y7N+6XzKL4F7WTDQY
         w+sFv8DE5vY7fSNnUjbh8ygpPQGsVZn2Ho09BphAyjVFXAvCuujy+eXeccFfVbqvz6Cu
         ai6ZHR3dsLLPIkVlsp6lTsJs+peoJO9cLtkBayCxQpvwZ/8ZKRAhyJiDoYH73QF51kTx
         D8CuKRDE0/qHOahjUiDxEQbGwV5NIIA060TSHBjGVdpStYTkvPzSUPQyYudpotHFHkQL
         cU2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767872400; x=1768477200;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=De/F7GrZ3a7XQW11zwFhVMyznAHPN5+HCcRNv17+1Go=;
        b=HRCF7PBo2EnqXnEAywB8j7JQ5nolJl2HAGhXZsd4uXHW+nhwevUZer1gLwGaxOf3ig
         nUxeY3dixVouXy+onSd8YPhK4fhfIf/q3pSvzf8d7RLcdPwap4eMOKt52gYUtMMll5cJ
         vkSOv+b7m7HYnyphWO0fE/W3xxya6OHapakrGD2i87oot493e0D3Err9XkKQ92liCUZz
         PztFWnvDE8+hOYSWrEcR04pgIe/V6+1v76WKJIb4BgSX7Np23NSyOKOWCjK8eGxn8xwH
         G4DXZ0MDIUzgvelaCoLcjp9CbS5TdZmRVn5l7u6Rno2clHfv5wJesMBang1WpInzDxDX
         3aNw==
X-Forwarded-Encrypted: i=1; AJvYcCU9ZfYd1uLmjDJzrKQ5rhY6f0/1SVsZqfE5VtVczYQr8JseGo/JmXZ/+YfqayDH6WwX1c87je6gTw==@kvack.org
X-Gm-Message-State: AOJu0YzG/tzUw4HvhUsKwkSSAI+bgR19kqRLfdtB7PHIOl/ZILUDPXxl
	QrU2dX/GtDlS3RtqQPSp4s0Ue5DV2W4/lY0T2zMV5F9kJ4uT4Mt5m6Ab9xOTXqCkxdf5ca+a/Zt
	hMfzJqeOBJspFkfyzLzRoVC2QH60eX2k+TORXT4Li
X-Gm-Gg: AY/fxX68sQ96nA2t90HvBEW/2+lc0Od48TMmN1c0CjoVbV/2QStdxXTcP0GrPaaIZd3
	feDo4/14Hg6HX9gEf46RN8CUErMsx8hj9MQa2r24Hs0UOtufMI6YQsBsZTL2e8xGJLcA/oiyH/Y
	ShPZbNOLJJv7zHOs/OS116nhc3VnuyQcRuC74kDqmcRmRsOFbhpCtQMpdfBwC4qFIImZHxiKC7U
	EElxwOolEs7vU9EvAz66tCXt1sryV97n8QrqUR6k75bNb3a1ZiRdtLUxD9bd4jOGZOgYEqNgdcP
	eTsGlhRYp+4wVMlL1oZk3JWvQLf8DqItlPZW
X-Google-Smtp-Source: AGHT+IEtTsutQpO25KKJJxkwWclrV1NkoOFyJBOS1res7lIatKk2McpUxH3uFSbvGt+LR+VAYJv6MCV9dzQjj1c4j+4=
X-Received: by 2002:a05:6214:20c4:b0:87c:152c:7b25 with SMTP id
 6a1803df08f44-8908417a83emr85986576d6.13.1767872399549; Thu, 08 Jan 2026
 03:39:59 -0800 (PST)
MIME-Version: 1.0
References: <20260105080230.13171-1-harry.yoo@oracle.com> <20260105080230.13171-2-harry.yoo@oracle.com>
In-Reply-To: <20260105080230.13171-2-harry.yoo@oracle.com>
From: Alexander Potapenko <glider@google.com>
Date: Thu, 8 Jan 2026 12:39:22 +0100
X-Gm-Features: AQt7F2p4_VUyRgHz6qqEM5-JBZ5E2KV2nkrPg5vKNyZeCt2rwmq1SfsxSID667s
Message-ID: <CAG_fn=XCx9-uYOhRQXTde7ud=H9kwM_Sf3ZjHQd9hfYDspzeOA@mail.gmail.com>
Subject: Re: [PATCH V5 1/8] mm/slab: use unsigned long for orig_size to ensure
 proper metadata align
To: Harry Yoo <harry.yoo@oracle.com>
Cc: akpm@linux-foundation.org, vbabka@suse.cz, andreyknvl@gmail.com, 
	cl@gentwo.org, dvyukov@google.com, hannes@cmpxchg.org, linux-mm@kvack.org, 
	mhocko@kernel.org, muchun.song@linux.dev, rientjes@google.com, 
	roman.gushchin@linux.dev, ryabinin.a.a@gmail.com, shakeel.butt@linux.dev, 
	surenb@google.com, vincenzo.frascino@arm.com, yeoreum.yun@arm.com, 
	tytso@mit.edu, adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org, 
	linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, hao.li@linux.dev, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: BDEDE1C0003
X-Stat-Signature: iuu7bawz9oafcdng7ccb6o4aw7cbuksk
X-HE-Tag: 1767872400-502725
X-HE-Meta: U2FsdGVkX1/g35hoFsHYlMpQSY6HE7Un+0gzatFqxVDUFYNpeBpBfNgQuOcyO5xw/8GnFBOVaUUtuvsqK1ozbQkE6MJLkt1P05i8LH4DfkNt3QBwP8fQY/qpdxK7QtqE0HUBn6JXBMilnI2iAngT2pIV9r78FcZQEz2oPX2j0HbhS47H35VuerWUp4T7+R+zaPoIBoF26RNajm25tJDG6OCxHI7cGDrdbltGG0KWeWH+oTOKKuVtlQdE0aUa1AAgumHZ90CvdXVN/kTYiWDqqpmCGifqPwflUVxpGNs/9gSQFyYCq5zBHL8BVyRNLz2xlW8lZNNgxiTsTkU71ZlxM0c0SCRZdPQIos3Vj+F56OBhEIv8f2ClQ442Z7I1MV2CAWPNnAghn6cfXS1wt7FdltE8UqBe9ftlJOGQjemvjksOeIJBr2JOE/I/DgPtwGl1rPeC2bAcRzBzlNDQ7kaYVZS/2UU7QABswg2/wYE8eTQZTuhOB+9H31LAY5Dwb8dRtnKNaeY0ZUbxhO94xhe9/MXrFviKDsF9o56IPg+BG0cQfXV2/WIbhGhLH/my219ABTfS5FLJeUomDSFQe+8uSiOekbqqnidootgADbMgkf2zAl4aRmh3DAkxNisiREGnv/D5+ApPtP6x6BwAZCH2PxXV+uuEAQS3iP2vIp1FCuCdp80WXXG2ND2QrO4IB0VsWfsKdK0JVaDU8oVn3yGXVq3c0MUwSd/6qXyoSB4Fis0Qm0TlT+XDia4tUsMOAVRD/cAc9MCOlF4CAwSbPH7R0GoGkEKo1ggMXxWhokLE75ZoZ9Gun2eqe6LxLkpSj5H8ACllVENf8liQlyIIp9EAXLDvfxTmcE4F2a+W8rMvM8iA2WkubDGaP0voYdq+/8zEEEt2NTxHmrQUQffMYcnOOCTPy7dGhhlfh96oxMxMUikBMjPAt7mEcnThyn2KuwEQurCXj+tRDthh8FtVDbQ
 qiiWzfzT
 udHzRopy6dtEKCc9a7eaVkXLmYDpRossAK7pfS66Bv1NoMIX8hVmnBoKz8FRj6g0q9quxJXZruoPoF/Zs8BaAFGMHKQUlYK/qC5rEPTISmMt3qy85uZU7WqMZ5ZcTNqrKe02dKUPvJeKeFgtuE4tQLcWZV3LsMEtFfNjzWYom41Z350AUNhlKTxXP4edX4zMnaxSLd467to6JoZsRJpAxjX0ZQK/7e6jvn0yFJPX1PJFY3VsAR+SGkQGisMfEX6b9Gs/KKOPJGMTQGqUYV5W8VB4g0Zp/2i2MXALZEzkltRKlHuv0XFPtOowettfko4/SNg/GHr92L/EYQMlAp/BDLBXguvRT55SYfsRGV8Vw+1b3BUyvSTph3ytg6GBOMUg0D8x9
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jan 5, 2026 at 9:02=E2=80=AFAM Harry Yoo <harry.yoo@oracle.com> wro=
te:
>
> When both KASAN and SLAB_STORE_USER are enabled, accesses to
> struct kasan_alloc_meta fields can be misaligned on 64-bit architectures.
> This occurs because orig_size is currently defined as unsigned int,
> which only guarantees 4-byte alignment. When struct kasan_alloc_meta is
> placed after orig_size, it may end up at a 4-byte boundary rather than
> the required 8-byte boundary on 64-bit systems.
>
> Note that 64-bit architectures without HAVE_EFFICIENT_UNALIGNED_ACCESS
> are assumed to require 64-bit accesses to be 64-bit aligned.
> See HAVE_64BIT_ALIGNED_ACCESS and commit adab66b71abf ("Revert:
> "ring-buffer: Remove HAVE_64BIT_ALIGNED_ACCESS"") for more details.
>
> Change orig_size from unsigned int to unsigned long to ensure proper
> alignment for any subsequent metadata. This should not waste additional
> memory because kmalloc objects are already aligned to at least
> ARCH_KMALLOC_MINALIGN.
>
> Suggested-by: Andrey Ryabinin <ryabinin.a.a@gmail.com>
> Cc: stable@vger.kernel.org
> Fixes: 6edf2576a6cc ("mm/slub: enable debugging memory wasting of kmalloc=
")
> Signed-off-by: Harry Yoo <harry.yoo@oracle.com>
> ---
>  mm/slub.c | 14 +++++++-------
>  1 file changed, 7 insertions(+), 7 deletions(-)
>
> diff --git a/mm/slub.c b/mm/slub.c
> index ad71f01571f0..1c747435a6ab 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -857,7 +857,7 @@ static inline bool slab_update_freelist(struct kmem_c=
ache *s, struct slab *slab,
>   * request size in the meta data area, for better debug and sanity check=
.
>   */
>  static inline void set_orig_size(struct kmem_cache *s,
> -                               void *object, unsigned int orig_size)
> +                               void *object, unsigned long orig_size)
>  {
>         void *p =3D kasan_reset_tag(object);
>
> @@ -867,10 +867,10 @@ static inline void set_orig_size(struct kmem_cache =
*s,
>         p +=3D get_info_end(s);
>         p +=3D sizeof(struct track) * 2;
>
> -       *(unsigned int *)p =3D orig_size;
> +       *(unsigned long *)p =3D orig_size;

Instead of calculating the offset of the original size in several
places, should we maybe introduce a function that returns a pointer to
it?

