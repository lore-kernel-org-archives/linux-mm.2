Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9E7BE103A9A1
	for <linux-mm@archiver.kernel.org>; Wed, 25 Mar 2026 02:49:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E73F96B0089; Tue, 24 Mar 2026 22:49:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E24666B008A; Tue, 24 Mar 2026 22:49:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D3A706B0092; Tue, 24 Mar 2026 22:49:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id C39FB6B0089
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 22:49:33 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 65E82E0895
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 02:49:33 +0000 (UTC)
X-FDA: 84583054626.09.AD742A9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id 52619A0013
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 02:49:31 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=L3TyWO2R;
	spf=pass (imf25.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774406971;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HKZfsfiRfH0jHmXCxHBrLnzAChk4AmqGHg6bTL9OJcM=;
	b=CZhTjzog3nv2CPz5Kme1z69nQOk3ayFzECjoAumqAC6NPsPb9CSipqkqNm93efBsau0JCp
	8dUxvmifFb4+X2kFhM3fuCQmF1705lRpTLj6Z5qAdkG07bVED7UvIBtZrrm/5USRsgI6pY
	ImA5trvvLuGczitPVhjo6aa5H6U+kkc=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=L3TyWO2R;
	spf=pass (imf25.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774406971; a=rsa-sha256;
	cv=none;
	b=P76t7Qpi9MIoKIaF1LxeWaj/Xgz/oiRxpJQCHYI8IDXPI2U4NYhetaYEm8qQx5YycAz4EI
	QXR1oEKge4+e/066c/1WoN0m2JYcP9Lba4iX2iUy0i8aMrV/seK/doAD0cNDM0/LFxBZjx
	FZaKeFcFtqgPvSIkm8NTg5NnoR2yaUI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 178BB444C0
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 02:49:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDDF5C2BCB8
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 02:49:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774406970;
	bh=f94cZgTZJW4iWE7r4y4Agv+EdHqjRzOhJnMgcftx1s0=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=L3TyWO2RaWI7Qr7K+U1eHoxj9NPRqHuY8/aE1zGn7CgYj7RH27XXweus0y/VxFNwo
	 5PtwwrGBqlEFpDl/4V5fFaE5R26HX9bQG9gexBD76upKNLt9Zjnr6WzQjZQM3SJbnP
	 hQgERltARaesck+woHdDfHdHzlqOstOAGxB+IgSM/JiOP8vPHqbMjEnQeF+cMfs4WJ
	 4f5h0q6B4samFjnV6CaKW01fEfJaqBHQ0J4ctKPl/HbzglWNgRFZEFjdi0pj414/5K
	 DpM2trCQtbrYRohsZwytMoO6AT83Il6YS571z7/odmn8dfpt3fOj1RiWGGoY+0V6EP
	 B5Z30MMwfAy7w==
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-66a33f61d80so3184710a12.0
        for <linux-mm@kvack.org>; Tue, 24 Mar 2026 19:49:29 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCWuzS9esMM1RPPDqlJDLsVDwM0ovGxAjK8LuiwBUbmoWw78U6yKwVcMpAiQeLPhAZZSA8ro4CqWLw==@kvack.org
X-Gm-Message-State: AOJu0Yxlaga87oprTBbkqgPXkqjiGhHolbb/uVKbjnnxIJ5Iv27ffffK
	JHX9+w1bgelgVblJuIJJ8YoI9Clfp1jB5poRovR5LWP4pfaiKC7sfpPsfit3zALxSBd6Z9eLpXN
	A5zl8SYYf7SrtFvqmQrmi7+DH+vM0PD4=
X-Received: by 2002:a17:907:a609:b0:b97:cbb9:2290 with SMTP id
 a640c23a62f3a-b9a3f1665f6mr119783966b.11.1774406968649; Tue, 24 Mar 2026
 19:49:28 -0700 (PDT)
MIME-Version: 1.0
References: <20260322061038.156146-1-liwang@redhat.com> <20260322091851.e965d3a2f0d6af5bd985407f@linux-foundation.org>
 <acCyPNCBoTGAJjfs@redhat.com> <CAO9r8zPxUv5V+VKEBuyacJUsc-UWh7hGc06yNQntY2GcUJLBPw@mail.gmail.com>
 <acKAr0TYzuYPxH4A@redhat.com> <CAO9r8zOCGWSX1+t8-5qe+04UZ6i4mChPJ8hkpiS5Z8pAPZ0sZg@mail.gmail.com>
 <acNH6C6Ay7As4y60@redhat.com>
In-Reply-To: <acNH6C6Ay7As4y60@redhat.com>
From: Yosry Ahmed <yosry@kernel.org>
Date: Tue, 24 Mar 2026 19:49:17 -0700
X-Gmail-Original-Message-ID: <CAO9r8zO2Nq=8dGBuJ0xpQTEr4EM2iJ=WNULtCU5FLLj4a23dYA@mail.gmail.com>
X-Gm-Features: AaiRm50VK0jNxXzN3lqG3s8-GclVxKcP8tps6ilvisx0LReDcBcJLdXYVJVJk04
Message-ID: <CAO9r8zO2Nq=8dGBuJ0xpQTEr4EM2iJ=WNULtCU5FLLj4a23dYA@mail.gmail.com>
Subject: Re: [PATCH v4 0/7] selftests/cgroup: improve zswap tests robustness
 and support large page sizes
To: Li Wang <liwang@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, longman@redhat.com, yosryahmed@google.com, 
	nphamcs@gmail.com, hannes@cmpxchg.org, mhocko@kernel.org, mkoutny@suse.com, 
	muchun.song@linux.dev, tj@kernel.org, roman.gushchin@linux.dev, 
	shakeel.butt@linux.dev, linux-kselftest@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 52619A0013
X-Stat-Signature: usbtt4ejweyz9efcbepdowos771euj5m
X-Rspam-User: 
X-HE-Tag: 1774406971-496068
X-HE-Meta: U2FsdGVkX1/RUmJMD8fFnPsUiXSrVtDF01bCZ71pqQnnZ1TMYEiLZdR6OzUeAGUIMT4fobod67vVcrIDzsNUwziaKn+CjAGbhA8yhqvXt9GZG2u/j2YgJZc9Zzix5LaCT7UD7cKod1Fqq5NZAvuCznJW8kyBuihdysdkU62HheZxtby0lgfQ+LQXmsCAjHXNWz8sdQDZjCw2y7s7fx49FJ/HNioiV5oZoygI8j0CbOi2k9F9zeCZEvku4iUKnPgJjTSzO2PeLsgBeIHe7ECjCVWph4MLPszlbzdnFPaGHhgjKTD4ubtFOkUrMzqe1mRQFyDjwoExQmk1hy4lcZkUz0B99lVoHlqPGv0Ch8n6Xjyp4xR2HFuba5wgbwVwANyMLGg5cFcPz1avOGkYo8cwsYosMP5LVhDyzbqjrJY/6iLZaVZatEd8pHSlpri5Dq1i0LQzGjVBHpqoPNXnPlRn+qK9bCpOSnGzJWHhGnJ5wi0LRWl+3Mei3h0q9uejt+c1d1Pp1L10kbVDpubrKEssYa44fWJ/JmAjT5XjQm0OtWzqp7SRtNwsLEcvI7KgmIuNdPk447cCpL2OCgjsDFB38pwu82zAOYGTYX1YLV/dt9HEgomt3D/JACgQeDfn3i6anMSdgsKmiopTKyUWDZjOIofLDJNc933x3RflpjtKFMicr4Xn+BbGAYAYb8L1ekZwG6c7cpH0gBB3DGCcUMZ7SlWJn5aS8jeMTt8M9MDGSpOgm/EEPyiv5+2j+AP/qVySCWEXfO2KRvh3Ukqc3fJcxOo/3Vg06OAD08ltyf4Rr5ZXQQ/BZ/Iyv/31cGnLeSxW8VfSu53Gl4WDsrFzvBfomjQSUi32Or9jCSGEpaZ7gKI8dxLp5tzQcsM9lNV77mqmagBwthM7zGFihS/s6NX9BH1PL+5KpcoOUn/KU94WCzYrvNwcWVkq32hre+Lm/m7c6jhxEkqTWxTG7EO0Oxu
 ZGvcaU3D
 qrmoTvU+LriaSe3ZFi3XHwnaCHHOzFNBIEXA/+5YOP5PDHL7GWIOBGEoQkTOx7dtRF/gYJqDkOV/qJ6ZgJbDk6jExioxTWv25HDD/3Q6HkhyUXv009lBKVxb/EbYsFF5kbazf4j+ffljcbyNu6DdZQZ5fnIU1+KKOsVfFnxxyzOEo6da/TeZ3moZPjQX+GCSdcxX0orKagZP8llMZA+4li0rf6ozW/ILRUZyzgzlzpNg6HU9W7dbC44RRluqmIZ3vnHIzSu/xQ4A/gbt0IRfuF7zI+d3xfpKrShnowuqWQt71MvPe5z3JVbkt5/Ajh2nVJFXkRWIo9ad+foeED8iFNH94jQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 24, 2026 at 7:26=E2=80=AFPM Li Wang <liwang@redhat.com> wrote:
>
> On Tue, Mar 24, 2026 at 01:28:12PM -0700, Yosry Ahmed wrote:
> > > > Sashiko claims that 512 pages will end up consuming 11K to 15K in
> > > > zswap with this setup, do you know what the actual number is?
> > >
> > > Not very sure, I guess each 64K page contains 1 byte of 'a' and 65535=
 bytes
> > > of zero. A single page like that compresses down to roughly 20=E2=80=
=9330 bytes
> > > (a short literal plus a very long zero run, plus frame/header overhea=
d).
> > > So the estimate is roughly 512 =C3=97 25 bytes =E2=89=88 12.8 KB, whi=
ch is where the
> > > "11 to 15 kilobytes" ballpark comes from.
> > >
> > > > Especially with different compressors? If it's close to 64K, this
> > > > might be a problem.
> > >
> > > Yes, good point, when I swith to use 'zstd' compressor, it doesn't wo=
rk.
> > >
> > > > Maybe we can fill half of each page with increasing values? It shou=
ld
> > > > still be compressible but not too compressible.
> > >
> > > I tried, this method works on Lzo algorithm but not Zstd.
> > > Anyway, I am still investigating.
> >
> > Do you mean the compressibility is still very high on zstd? I vaguely
> > remember filling a page with repeating patterns (e.g. alphabet
> > letters) seemed to produce a decent compression ratio, but I don't
> > remember the specifics.
> >
> > I am pretty sure an LLM could figure out what values will work for
> > different compression algorithms :)
>
> Well, I have tried many ways for ditry each page of the total, but none
> works on zstd compreseor.
>
> e.g,.
>
> --- a/tools/testing/selftests/cgroup/test_zswap.c
> +++ b/tools/testing/selftests/cgroup/test_zswap.c
> @@ -9,6 +9,7 @@
>  #include <string.h>
>  #include <sys/wait.h>
>  #include <sys/mman.h>
> +#include <sys/random.h>
>
>  #include "kselftest.h"
>  #include "cgroup_util.h"
> @@ -473,8 +474,12 @@ static int test_no_invasive_cgroup_shrink(const char=
 *root)
>         if (cg_enter_current(control_group))
>                 goto out;
>         control_allocation =3D malloc(control_allocation_size);
> -       for (int i =3D 0; i < control_allocation_size; i +=3D page_size)
> -               control_allocation[i] =3D (char)((i / page_size) + 1);
> +       unsigned int nr_pages =3D control_allocation_size/page_size;
> +       for (int i =3D 0; i < nr_pages; i++) {
> +               unsigned long off =3D (unsigned long)i * page_size;
> +               memset(&control_allocation[off], 0, page_size);
> +               getrandom(&control_allocation[off], nr_pages/2, 0);

This should be page_size/2, right?

nr_pages is 1024 IIUC, so that's 512 bytes only. If the page size is
64K, we're leaving 63.5K (99% of the page) as zeroes.


> +       }
>         if (cg_read_key_long(control_group, "memory.stat", "zswapped") < =
1)
>                 goto out;
>
> Even I tried to set random data for all of the pages, they still not
> works (zstd). But it can be worked on lzo compressor, I don't know if
> the zstd have any addtional configures or I missed anything there.
>
> My current thought is just to satisfy the lzo (default) compressor in
> this patch series, and leave the zstd for additional work.
>
> What do you think? any better idea?

Let's check if using page_size/2 fixes it first. If a page is 100%
filled with random data it should be incompressible, so I would be
surprised if 50% random data yields a very high compression ratio.

It would also help if you check what the compression ratio actually is
(i.e. compressed_size / uncompressed_size).

