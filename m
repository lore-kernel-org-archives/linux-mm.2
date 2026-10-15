Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DF7B7CC6B38
	for <linux-mm@archiver.kernel.org>; Thu, 15 Oct 2026 22:45:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 678BF6B0095; Thu, 15 Oct 2026 18:45:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 650D16B0098; Thu, 15 Oct 2026 18:45:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 51ACD6B0099; Thu, 15 Oct 2026 18:45:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 180B46B0095
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 18:45:24 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E9C08A0206
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 22:45:22 +0000 (UTC)
X-FDA: 85326343284.06.6EFF778
Received: from mail-lf1-f50.google.com (mail-lf1-f50.google.com [209.85.167.50])
	by imf16.hostedemail.com (Postfix) with ESMTP id F2E46180002
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 22:45:20 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=WDSj3sy6;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf16.hostedemail.com: domain of kanchanapsridhar2026@gmail.com designates 209.85.167.50 as permitted sender) smtp.mailfrom=kanchanapsridhar2026@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792104320;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cDTDKMrdQwRgjoWMeyrkyF6DIGr4iKPuJqKn3z4+wB8=;
	b=ui+yJsx+uzTcbKlXgnBqIRhfA3pCrLSjzFn0aPIkcW5FYu9LYIQJIbS3ZT8YtB8OKSYH5w
	/+RiWX9dWFvSSgL7k/TEUiR7abrVJlYYZwDPJABnovFJSMZgZks4O4mdMZfqFQIjJTLjl7
	nHGV3xU0CwGR/btDXwdNsZW+469w4jE=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=WDSj3sy6;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf16.hostedemail.com: domain of kanchanapsridhar2026@gmail.com designates 209.85.167.50 as permitted sender) smtp.mailfrom=kanchanapsridhar2026@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1792104321;
	b=oykyE5KjhTmOo5OP78wZ7HgZjRYGpX/z2PJMcrQbS4q4Hm34UF07/jp7nrdSpy4AdGmDot
	jQa0i96DAIA1Pbt4Rx3yFAc+3z6lt36n+ZXMkhUAw7Sqm8sX7ibPxwAFN3XU5muHlDtvVD
	iHzzED7tslOIeyPWFkpuU+xh3qJbAAw=
Received: by mail-lf1-f50.google.com with SMTP id 2adb3069b0e04-5b2b92065ffso2861672e87.1
        for <linux-mm@kvack.org>; Thu, 15 Oct 2026 15:45:20 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792104319; cv=none;
        d=google.com; s=arc-20260327;
        b=MmqQn8ynhTIm9JDVtS8C19jenomv6Cu9OXXjjMvmJ3KNvM8Z09KxWxIOX7UkCcxdZb
         F7P4TZvD6s0QC9reuv+iVkd9QRef/zYNSpSd9+cCCsWgPlWdSH5K2yZmmEKRwq2YulIb
         lrHXG6OkY0K3YEhEAu98qggKFRQIhg8JuRSYcUJutk6NxC+T+gbDI3CSeHoLj4T6XKUq
         Y7E4h7BBFBUpE3fa0owi9qp72YwQF5NmR3qMTpTC7TQqea0C6PoTlIJHsqVbE6drexLV
         PboecI6M1CzBkkNJipmm4we5APEyC8lmiruzudv5P9VP/6ikLalBd9NKaXUIFBe0yQfn
         MbWQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=cDTDKMrdQwRgjoWMeyrkyF6DIGr4iKPuJqKn3z4+wB8=;
        fh=lGlJCNnJWM+n8PF6rL/PCY0xfrjgE2vM4+JBF1QY0Ts=;
        b=lhZM8nTyv061RjcVIdmy5FKoJ9xd3kspc103op89gYG/w9vwpUNKkye5fBYL4A17IW
         uMUJ6XDc+9rUrMqAJVTvm+fvoh60Wu9643NoQUbYosvvC1wq2lXFbaH0sQXCsWHc83Ae
         xSl6HM4EEFkm9qX0J2kzI/hQ/4NH8FPhGDH4CWT1Fwaz75CAki46sdTRfOdQ6tuHhpKu
         P+3zacgdDlW7fUUUa6QpCMbzTEwqsVq5vqQqnZEXQ/jvXR6zWGsiX3DG9kNXPDGLBP0q
         RTUsg1ONkpDGTOjSLnfMl9+4sQtlzGYL7URciOdcm6Zl7BrpoQLAeV1zVPvwkfBhHK8J
         cI/g==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792104319; x=1792709119; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=cDTDKMrdQwRgjoWMeyrkyF6DIGr4iKPuJqKn3z4+wB8=;
        b=WDSj3sy62qkFa1/WZCIIZJ++c6utMmYiDnVwrjB8oSbewZJBfO59NPkZJdTifOqruX
         bmD7DzdTpROlpSD3duHa2Wfz2FOeLD3NUJeqkqiVNqxZAZ+KZa2cTc0HfWij4yAIrtL+
         YqTjRfY1H61xqYvNMa9y6iZi28xld+ignT+W5/Ce0uKVdglXEsjXNVSbaOPeCpeZ7tXD
         hUjkdl738ejev5Ci05utzQIpH7bvkfvTqGSRYO/25KmKKterxMZXOYfAW120jWeF+5zl
         nX1tyjw/ya2TpSy5nYIJiyZVuii+iHrdhDcaI+1p5jmhNObHx/M+xBPSWoHVtDoyyEfr
         ozSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792104319; x=1792709119;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=cDTDKMrdQwRgjoWMeyrkyF6DIGr4iKPuJqKn3z4+wB8=;
        b=XVftbx7+3OFDFfSci/qKY5nKz1jvUh1SmglDtXRsgxz/ylWnhCopV/wjqqGJi9XpY6
         oxFCUg6Qn4FrT1P7fFr5FhnHsEbgqjykeh7Yxfe4WK+OZfFRq0LQqDz5JOtTmZFdjCAu
         Esal2QAUvJzQMTU8eOfvSxIw/h00UHE0tKKGYcZGU3V1wIxpsVn2hRiGDYIJeKTYMXs8
         +dMvnFAWXvE3XWkAVUWkG3vovlqxBK6o3jvKOC73HVQ2ETXPwGku5qJx5RtSc/qHyPqy
         9aOetY+GhZ2W9XYJcX8KdSJbvIeNRtalDCtR6VJEh+wyvJrvF8GZp41KtxsCMOoWXDQw
         5a2A==
X-Forwarded-Encrypted: i=1; AKwUvBwRmPu/XhqPe12n//8KkXbrh5amvlQHYvSA5AHlnutKcSBg/1rAqcz2QWMSp2mn7p6MXNEqMbBDlQ==@kvack.org
X-Gm-Message-State: AFq9FYLdgUu/g/dL2D8YAhaQBJ3DyAUsHIIIO7Vg0Mv56JcLKAMK5Sei
	QAQKbpET/19dJI7/Dd3fdn4E/GNLTwZnI5UkXAk54ajk+xdn7P18jatHnpd0MmbCQJhXAMHB2tG
	l+4jL1n4rnOhU7Hxdm+6yAq11i6ISpR0=
X-Gm-Gg: AYBFou1GUw04Ia8hMzbiLKufQPIAtgXfaI0ETT+RwpKxY1VuUc+Uarovq+MKjtiX2lT
	rn9xqTrhKgBUS8jIvi38SoD4wAyLzY80hEr9PpEqmhE2qH7FjYt9k/5H08nnBICwYZByJq4abTm
	d/0S6BdAYn5VUtCpkvyS2Bf0nCXjSGktJjwiMRb25hXSX6qIShBEn1enMwTXEtnG9h592bSaX6T
	ycnDYQ+U0AxmuX8ymWpc1DSm3fgPdO/1CUfsvxoo8P7CokA3sCO13alr/VafgB0dCJVr43NxvZQ
	oascf6tlx7/JDrbZWih92e2ut+dlKL+PRoDzjb2n3zW8d2gUGASILkE=
X-Received: by 2002:a05:6512:3f24:b0:5b8:f533:d439 with SMTP id
 2adb3069b0e04-5bcde8c1acdmr7282009e87.38.1792104319215; Thu, 15 Oct 2026
 15:45:19 -0700 (PDT)
MIME-Version: 1.0
References: <20261008182814.27450-1-kanchanapsridhar2026@gmail.com>
 <20261008182814.27450-6-kanchanapsridhar2026@gmail.com> <as7JC8o2kggiq_ss@google.com>
 <CACpmpofXMGBP70Rn7jHLwOF38GRKMUGoW3rb1Jp2SPH7ygKcfw@mail.gmail.com>
 <CAO9r8zOEcGmg8eVttu41htugnng0ahnVQbubiJfxVH+GfDe47Q@mail.gmail.com>
 <CACpmpodDA=oqnVa_hsJpyhGt=4zxknYF=QX9L6-sJbxsRxtM2w@mail.gmail.com> <CAO9r8zNN6F01icKUFr8q_AgJvhxGw0MkGezKbBuKzFQV0NaAdg@mail.gmail.com>
In-Reply-To: <CAO9r8zNN6F01icKUFr8q_AgJvhxGw0MkGezKbBuKzFQV0NaAdg@mail.gmail.com>
From: "Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
Date: Thu, 15 Oct 2026 15:45:06 -0700
X-Gm-Features: AclHuK8NXYRqg5T9PQ2fZ89a7chOTLHtC37Sjh9lMWynljXBN8yHgyQfD3XnlOE
Message-ID: <CACpmpocCJWkA+zvZ9ivNCt8xSZWfViKQ2ZeYN+f1EmdVTewzRQ@mail.gmail.com>
Subject: Re: [PATCH v1 5/8] mm: zswap: Store the folio's node id in the zswap_entry.
To: Yosry Ahmed <yosry@kernel.org>
Cc: hannes@cmpxchg.org, nphamcs@gmail.com, chengming.zhou@linux.dev, 
	akpm@linux-foundation.org, linux-mm@kvack.org, herbert@gondor.apana.org.au, 
	davem@davemloft.net, linux-crypto@vger.kernel.org, 
	linux-kernel@vger.kernel.org, rientjes@google.com, willy@infradead.org, 
	senozhatsky@chromium.org, 
	"Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: F2E46180002
X-Stat-Signature: n8y4748m9576a9hajp74erp6h6koc3jh
X-HE-Tag: 1792104320-168635
X-HE-Meta: U2FsdGVkX18JOH0ILB1Hfe0Q1fW+oALj0cRTXuXMsgv4wIfCUr4GHtJGktyfFn+Bmfl4QuVtGG7fyzflMOgLMF7O0oFu0aTA3fLgWgJFGlxeK+MF/BQoeDIyWxXfSJ/4Pw5IAmOrPmiBY0zCQbpcxDZun7lb4KJUwQ0bAkZHQFYOpwSpR2zoVCo6wi9I4Fr7htCFwdTdbf4L6pFZbDJ+vobeoBhlsp661XVr+IO305lNbVFeZycHL8ZAmoWhoSHX8HJgMhkfYFZvXzS60T8mPREGbZExdSXxNt8ZDiKIEO/3Lafc1u3/7viWgqpmz/sLao+Jz1htjjMCpiRHUcWnxDP/3Jx1gVkzjYkkXUDb4kTpyLW4ievi4jUZ+1rm2reW0edHvCxY7cBI+D/EasePI3cHZDgGW1HE9WOqBXP7JKPIIR8WpQnmaACtfoWZlSOKwqzHNXe20h7QM+1LCoJvPgCZBUfaDX84GgL+7kzqCiRk20uKAys2t28DUyr2PEJ56b8S9CcPYUJzfg2mVnAorPfJWvrtz4an1NyrCdit2Jvxkce6gx2Als5FKDGFqbmqEXV16ABxhA1psz7/HmGsqxhFE11AfE9nv/t87gqn3Cc+a1xhKS64adHn7Y25+tsM/JqwFj+z1Cycssu2Tqs2ETUnFn+Cbh5qCs3QL8UkaFrrahSQ0MJXhhHtvmGd7c9eWqkSjErV3m24Q9dpnw8brWTUzkqdK2j6RlnntdCkbmRLfpjEr3Kl3LvZJ0GUAEZFlMsrbIrHfBbgFa2XIGeWqHtiB+0cNVdR6JFCxRdedpucm06PUegNCv5okJ0NHG5DB9v4SViMp9moM5TZ8AdxVuGlQY8g+A376MU/fRCM1tHTttcsyXwv+23SSOTCpbOdfYKekaJwRizaHe+eZTD8CNnCgtDXst5CIStZ6qB0vdQsl+IgMkFZYcVTXwBaUvR1/r4ucSkRcXXGUZNMKPn
 ybOUOizw
 UfH9ywAE3SPX8LSzaOXbR5OIRc+ohvClNx+Z9A19mRqeNpWQvWmTVMyI0niBzm10Xokwjkw9xJ2I9V+pPfE4YbpGBnfs8BT0x+dYukIt2dHqj1E1FBRmoeTAvkN1TjaW+xKQu3HWed/D09bGwJ+38a5yJrQZolgnKTmk35pkqZVudxNc+9e8S+crpU0mYjVw2v8otFNfErxvMr5dmRoLzE7TpYa731g96puu0as2nhCTu0qut0WGlLBMwjiPjg92uBVkHG8VVfSsCW5TbczRDUVc82seNp3htJfI0BktCp5eiMipkvCIwNIY40B4SLremRIxbKGpWky/uBZSPqGdsrx7RAyIInChCBLM7HpIUkAs3VWh56pGg8NU82YyV4NJoqHW3zph3Q7gQptwn01xjxz72UKgQ4xhTpyKcc+UL98rLq45DtPsu1BjNBmPfNoBqLoshC1JQCB/KtpvESFeiPEVB+3HPfKG18YMo
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Oct 15, 2026 at 2:39=E2=80=AFPM Yosry Ahmed <yosry@kernel.org> wrot=
e:
>
> > > > > > @@ -1449,9 +1446,10 @@ static bool zswap_store_page(struct foli=
o *folio, long index,
> > > > > >  {
> > > > > >       swp_entry_t page_swpentry =3D folio_swap_entry(folio, ind=
ex);
> > > > > >       struct zswap_entry *entry, *old;
> > > > > > +     int nid =3D folio_nid(folio);
> > > > > >
> > > > > >       /* allocate entry */
> > > > > > -     entry =3D zswap_entry_cache_alloc(GFP_KERNEL, folio_nid(f=
olio));
> > > > > > +     entry =3D zswap_entry_cache_alloc(GFP_KERNEL, nid);
> > > > >
> > > > > We don't need to allocate the entry on the same node anymore, sho=
uld we
> > > > > drop this and let the slab allocator handle it as it sees fit?
> > > >
> > > > Was this a recent change? I see the folio_nid(folio) on my version =
of
> > > > mm-unstable as of 10-3-2026. Let me check, and yes, allowing the sl=
ab
> > > > allocated handle this is probably a good idea.
> > >
> > > We allocate the entry on the same node to avoid having to store nid i=
n
> > > the zswap entry (see entry_to_nid()). If we store it, then there's no
> > > need to allocate on the node.
> >
> > With patch 0006, we try to bulk allocate all entries for the batch.
> > Only if this fails, we call zswap_entry_cache_alloc(gfp, nid). So
> > patch 0006 addresses this already, and the nid is used on in the
> > fallback case.
>
> If we are storing the nid in the zswap entry, there is no need for
> zswap_entry_cache_alloc() to use the nid anymore.

As of now, zswap_entry_cache_alloc() uses the nid for
kmem_cache_alloc_node(). Is the suggestion to change this to be
kmem_cache_alloc()?

>
> >
> > >
> > > >
> > > > Along the same lines, I have been working on replacing zsmalloc wit=
h
> > > > direct SLAB allocations for the zswap compressed data storage and s=
ee
> > > > very promising results: memory savings and latency improvements. I
> > > > will submit an RFC shortly.
> > >
> > > Keep in mind that zsmalloc is movable memory, while slab memory isn't=
.
> > > Zsmalloc may also be less likely to make a new allocation in the stor=
e
> > > path. There are other considerations beyond memory overhead and
> > > latency here.
> >
> > I realize this means we trade off page migration for writeback for the
> > pages representing zswap compressed data. This might not necessarily
> > be a bad thing for 2 main reasons, the way I see it in this specific
> > context:
> >
> > 1) Page migration would only be transferring a memory pressure problem
> > elsewhere. Not sure how well this would work with memcgs or
> > containers. At some point someone would need to do writeback.
> > 2) I don't believe there is a zswap specific page migration flow in
> > the kernel other than zsmalloc compaction. IOW, memory tiering
> > components like CXL are handled directly in the reclaim path. From
> > what I understand, things wouldn't break with slab memory for zswap
> > compressed storage, but I could be wrong. I hope to include the
> > architecture level considerations/trade-offs in the RFC.
>
> Zsmalloc memory is currently movable, so compaction can move it around
> to free contiguous blocks (e.g. for THP allocations). Slab memory is
> not movable. It can be reclaimable, but writing back memory from zswap
> when we are not under memory pressure is also bad.

All good points, thanks. I agree, writing back memory from zswap when
not under memory pressure is bad, however I have not seen any
writebacks in my experiments with usemem at 60% over-commit and with
64kB mTHP.

I am running these experiments in a memory constrained environment:

QEMU VM: 7G RAM
Swap: 3G
cgroup memory.high: 3G
4 usemem processes want to allocate 1200M each. To make the experiment
even more stringent and representative of actual compression datasets,
each usemem process reads the Silesia dataset from a
pre-fork-allocated buffer into the 1200M. This causes realistic
compression payloads in usemem.

>
> Note that compressed memory can be very large compared to slab
> allocations (or kernel allocations in general), so it can increase
> unmovable (or reclaimable but not movable) memory significantly,
> causing fragmentation.

It took me a while to experiment with compressed size bins, until I
settled on a compromise between memory wasted per slab and zswap
latency in finding the correct size bin to minimize fragmentation. I
have been gathering extensive SLUB stats which indicate:

1) Even under peak zswap compressed quota ("pool") utilization across
10 consecutive iterations, SLUB comes out ahead in less overall memory
overhead.

2) At steady state (when 10 iterations of the workload are done), most
of the slabs have been returned to the Buddy allocator, except for 3M
worth of slab setup per compressed size bin (0 objects in use): this
is as compared to 32K of zsmalloc slub metadata that remains at steady
state.

I learned some really interesting things from these experiments, which
pose questions about the memory penalty due to latency that zsmalloc
adds to zswap compress/decompress paths vs. "internal fragmentation".
I expect to quantify this with data from my experimental setup.

