Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 970E8606A319
	for <linux-mm@archiver.kernel.org>; Thu, 22 Oct 2026 16:01:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LUKMDLgm
Received: by kanga.kvack.org (Postfix)
	id 9EB276B098B; Thu, 22 Oct 2026 12:01:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9C1376B098C; Thu, 22 Oct 2026 12:01:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8D65A6B098D; Thu, 22 Oct 2026 12:01:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5C95A6B098B
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 12:01:22 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 40D541201D2
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 16:01:21 +0000 (UTC)
X-FDA: 85350726762.16.A69D7D8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf31.hostedemail.com (Postfix) with ESMTP id 7EB1D20003
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 16:01:19 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LUKMDLgm;
	spf=pass (imf31.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792684879;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mZnQH4k66o1mIDEsmzGgsw5IwNIOyXJTZDCq9e7F1pw=;
	b=bdsK/Srg+/noA2pYxShowmEy/yKW+eGmWTJP7jHqWTu6STyWYT49ZTQavM72aAOg4XLIY4
	TKKFXIaIPgro8MOHQQp9yxcCSo74r6q4l9NacKcc07N/w5ZjY5S+uPgI1+CgXiHYadioow
	WqYufbYwh8HW/JPuAm4hxtD1ozPWWq0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792684879;
	b=eGRkJfWUv/MTEG6jb12Z/YqVV/BpaIi/YwKkymlTlJdOEtHRGiaMojYVmTCwzr3Tgxy5D0
	65+58EM8SdGM1zKFuC3UwQXd4xHhRT/f9/T9t5qCR+gLFaHiqNRyDjnUj4ZjZjTXPzr6SC
	6XWlm2vBxb9FISUt1XzXqq20akz4BJM=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LUKMDLgm;
	spf=pass (imf31.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3B6EC43E34
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 16:01:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F1FF1F031E6
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 16:01:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792684878;
	bh=mZnQH4k66o1mIDEsmzGgsw5IwNIOyXJTZDCq9e7F1pw=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=LUKMDLgmYCelRKZK3jvmKxwZJ7UrPFrxBmub5jJzBKHKMKc9Z71KOTzZ/U8sLqWbK
	 GJmt6NKptSpfEOoQwXPij8KghJWk5NJL4tv9qLsOxm237m9aNMzvIIonAN+/PtyQi1
	 4TwwtY0rsqa4jjU9/UMFlSck7yWRvLUAWADohSj0rmzKEFNE9deUxG6G+z5yWMZJnR
	 yeJ4UJ0kpZ4BywGO0f9ltMctlmyK0lhz9oW/oT/yjh8bmLtNsQeDk2HC3NWPEHnzRQ
	 eAS+ol+jMyd58RSBrjXXgCtg1e6uJYbRhFwgJaE1WuFkROnx2ElpqAdkCnQmdEtHgw
	 Zj7udkyyZe1cg==
Received: by mail-qk1-f178.google.com with SMTP id af79cd13be357-93e6eb77f0bso173553185a.3
        for <linux-mm@kvack.org>; Thu, 22 Oct 2026 09:01:18 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBxRwCbnjc2JKZ7NxE2o7glKs5sZm4H6twbIuYEZE4MY8URObYkd6mk+EnDReVkenVkBLpOJRfKvMQ==@kvack.org
X-Gm-Message-State: AFq9FYLpxkGo0v9vRgXTkx40vUhyvIgTG4jjsBcK2R1+Z0yXM/GVL+1K
	jgXrClJixl0Zb/3JbvAR84LtCCySu6g8PWhydeuVF1NJDO3JYqRZj5X7W16iC+IsoFQpz0jR7kS
	HD/03/SCUKpkQeGEOGVj2xAo3kUeON0M=
X-Received: by 2002:a05:620a:4015:b0:93f:3646:7a53 with SMTP id
 af79cd13be357-93f57f985e5mr1089190485a.83.1792684877406; Thu, 22 Oct 2026
 09:01:17 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261021205626.3286270-1-suseendranb@google.com>
 <20261021205626.3286270-3-suseendranb@google.com> <CAO9r8zNtuN=_BTV53oHqaTqE0Bo2qiDSrgTBzEZo5oyOnWyeYA@mail.gmail.com>
 <20261022155144.4177200-1-suseendranb@google.com>
In-Reply-To: <20261022155144.4177200-1-suseendranb@google.com>
From: Yosry Ahmed <yosry@kernel.org>
Date: Thu, 22 Oct 2026 09:01:02 -0700
X-Gmail-Original-Message-ID: <CAO9r8zP+GUE-hcGWSGzhLNLcchFoZ38EMVCAtX5yZ78tZ0bbgA@mail.gmail.com>
X-Gm-Features: AclHuK8UBgpUaMkUIVDLgCYUdPlk7TRDmPVZZOzzavqgJCzERTrB32bGsXXzVQk
Message-ID: <CAO9r8zP+GUE-hcGWSGzhLNLcchFoZ38EMVCAtX5yZ78tZ0bbgA@mail.gmail.com>
Subject: Re: [PATCH 2/2] mm/zswap: classify compression dst overflow as poor compression
To: Suseendran Bhaskaran <suseendranb@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Herbert Xu <herbert@gondor.apana.org.au>, 
	"David S . Miller" <davem@davemloft.net>, Johannes Weiner <hannes@cmpxchg.org>, Nhat Pham <nphamcs@gmail.com>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Nick Terrell <terrelln@fb.com>, 
	David Sterba <dsterba@suse.com>, SJ Park <sj@kernel.org>, Chris Li <chrisl@kernel.org>, 
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>, 
	Suman Kumar Chakraborty <suman.kumar.chakraborty@intel.com>, linux-crypto@vger.kernel.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 7EB1D20003
X-Stat-Signature: jbe9pskjgwfriwj7bqw4naxfjhok9n5q
X-Rspam-User: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1792684879-664280
X-HE-Meta: U2FsdGVkX1+zooAf+0cSqg+5vc3sDO+XYLubuKC8TVKbd0PAUIXi96BgObLzs5900to8ItJut2xWXH3uSo2cj1ngm9Qxq/z1Q9fzK9QPZWEA0OUPwobqoKfWG1ujrOapNtCOAZ4QTefjEhP4J989ETltpfcY4XGxxiobQeOQOv2VkBX1Dcl9NkVNiIFFp4+EEXU77yN9nP2Ks0sJy674SBW6ThlZCuTr8Uksi9y8vf/FTvaXmaI5yn7UyG7t+oovY3odP0NmthKJqPkBd3R6io9SYgiNo3WGA3W87Er9VVV6EwQukd2YxFwYMdE7CoBx3huH7ir8INADv38+hCjm6ac9+LGR9FaaC2EInpGh1gfqruZu/7auRovljhzFtz0N5uUL2QhVTVZiFeryAWUk5/R6IRBEonOPHx5u91sNIlUTTJTvmActzSkhBjfHO5Ve02y2+gnZ8FkP+fpmMWKizdSGjuL/YlwoKWE5UCTiSBEuzG/SvQC2jsALoI3CW6tjRxyZeJpYxeQYNC5G29sLpNBqeHPbMd0AGysHQOp4zn83n1cdTXR/rjQVIRcWNL0Oc5uKmrZZo0zunL6aPgRAd2kmzroVmRXmXQkCukXTcfzgBggdUPnpoDdawiN78//2och+nRp2BNizwMTjZN9JwUIEheqjONtcFKKR+mWyKuCL/+wxqeGXZEaWA+GZpqu14FufWRKXfIje/e4z4kxw7ptfJep3uYFt5AHG4KHbZiqUAzbpa+i0qDYvDEAYpS1HXBvft/zNHPe9tbwdUDf8SOGJNe+CfQklSUA8lD4bYylEV/Kl91B4D2PwUkRx3D67NdGJUaQOKnK+qhFhu7HtNIqz8U2/EaxVrGseBWsgtxngiigMKgIXxjvDTO9Y7+96qRygqCA6ih4rA0XHHYGJRtaJYqzhx1wXx64kilLYp1aBTvqIai3H/It9StZ2PYsGyr4C6kg2ooVZ62XPVbR
 tIIi8sSB
 CIep2aUfMoYil1e7AJ3Hby0tD0mF9/tRs9zlEuUUn1gdg+ekTnrW2iP0ZQv3i8ctRez6qsvTvJcCJqAeCXZ0b6+fKAfXD+5h0VwMgsvCKEOqk+0KfLbWweUrQirX5gxI0FNt4qjVkG9TWABEYITEpR6JadFU21YnNW9fNcglvt+uBXwUuv8z5q37zeMIdo2vYfFwZthjAp3/KQ8RneXjYi0sgMJldKkw/6K1TGvySmMdMHPYbCX+URCtt1fz5FO7VEfkla073+diq/1DRr/38hnBfRZ1LVAWW9udJNibBMVcLK6OLOU//dBxK9bvCbpVoYmNy4JCuoaZTH0hGcVKys6ftag==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Oct 22, 2026 at 8:51=E2=80=AFAM Suseendran Bhaskaran
<suseendranb@google.com> wrote:
>
> On Wed, Oct 21, 2026 at 02:47:46PM -0700, Yosry Ahmed wrote:
> > On Wed, Oct 21, 2026 at 1:57 PM Suseendran Bhaskaran
> > <suseendranb@google.com> wrote:
> > >
> > > 1. When zswap writeback is disabled (e.g. memory.zswap.writeback =3D =
0),
> > >    zswap_compress() sets 'comp_ret =3D comp_ret ? comp_ret : -EINVAL'=
 and
> > >    jumps to unlock. Whether the compressor fails on destination overf=
low
> > >    with -EINVAL or succeeds with dlen =3D=3D PAGE_SIZE, comp_ret beco=
mes
> > >    -EINVAL. Consequently, incompressible pages are misaccounted in
> > >    debugfs under reject_compress_fail instead of reject_compress_poor
> > >    (leaving reject_compress_poor stuck at 0 and triggering false
> > >    compressor failure alerts on normal incompressible workloads).
> >
> > Hmm IIUC this is completely fixed by patch 1, so it doesn't belong here=
, right?
>
> You are right, thank you for pointing this out. For the destination
> buffer overflow case, Patch 1 alone fixes it since comp_ret is already
> -ENOSPC and 'comp_ret ? comp_ret : -EINVAL' preserves it. The only case
> not covered by Patch 1 when writeback is disabled is when compression
> succeeds (!comp_ret) with dlen >=3D PAGE_SIZE, where 'comp_ret ? comp_ret=
 :
> -EINVAL' sets comp_ret to -EINVAL instead of -ENOSPC.
>
> > > 2. When zswap writeback is enabled, any non-zero comp_ret (such as
> > >    -EINVAL from an invalid compressor context, -ENOMEM, or a hardware
> > >    accelerator error) is treated identically to an incompressible pag=
e:
> > >    comp_ret is cleared to 0 and the raw page is stored uncompressed i=
n
> > >    zsmalloc. This silently masks genuine compressor failures
> > >    (reject_compress_fail is never incremented) and miscounts pages th=
at
> > >    encountered a compressor error under stored_incompressible_pages.
> >
> > Storing pages in zswap when compression fails to avoid LRU inversion
> > was intentional in commit dca4437a5861 ("mm/zswap: store <PAGE_SIZE
> > compression failed page as-is"). Unless we think this needs to be
> > changed, I think all we really need to do is make sure we account
> > debugfs correctly for -ENOSPC vs other error codes? Or am I missing
> > something?
>
> Thank you for the context. Keeping the writeback-enabled behavior from
> commit dca4437a5861 ("mm/zswap: store <PAGE_SIZE compression failed page
> as-is") as-is makes sense.
>
> With that unchanged, existing zswap_compress() already accounts -ENOSPC
> vs other error codes when writeback is disabled, except for the
> !comp_ret && dlen >=3D PAGE_SIZE case mentioned above:

Is this actually possible? When we changed the buffer size to
PAGE_SIZE, I thought we made sure all compressors wouldn't write
beyond the buffer size. dlen > PAGE_SIZE means buffer overflow, which
is a bigger problem than debugfs stats. Or maybe compressors can set
dlen > PAGE_SIZE but won't actually write to the buffer? I didn't
check.

As for the (!comp_ret && dlen =3D=3D PAGE_SIZE) case specifically, yeah we
should probably use -ENOSPC to count it as poor compression.

The compt_ret and dlen checks are not super intuitive tbh, I wonder
how they should relate. What is the expected value of dlen if comp_ret
is an error? Is it always 0, or can the compressor set it as a
non-zero value if compression fails?

>
> -                       comp_ret =3D comp_ret ? comp_ret : -EINVAL;
> +                       comp_ret =3D comp_ret ? comp_ret :
> +                                  (dlen >=3D PAGE_SIZE ? -ENOSPC : -EINV=
AL);
>
> Would you prefer that I narrow Patch 2 to just that change in v2, or drop
> Patch 2 and only send Patch 1?

Let's figure out what needs to be done for patch 2 first, if anything.

