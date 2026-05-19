Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5EFD8CD4F5B
	for <linux-mm@archiver.kernel.org>; Tue, 19 May 2026 18:07:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 931BD6B0005; Tue, 19 May 2026 14:07:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8BB7E6B0088; Tue, 19 May 2026 14:07:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 761DA6B008A; Tue, 19 May 2026 14:07:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5F3D66B0005
	for <linux-mm@kvack.org>; Tue, 19 May 2026 14:07:11 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id DD12D9169A
	for <linux-mm@kvack.org>; Tue, 19 May 2026 18:07:10 +0000 (UTC)
X-FDA: 84784951020.20.E395155
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	by imf02.hostedemail.com (Postfix) with ESMTP id CB57080008
	for <linux-mm@kvack.org>; Tue, 19 May 2026 18:07:08 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Wxa0qDcM;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf02.hostedemail.com: domain of tjmercier@google.com designates 209.85.128.50 as permitted sender) smtp.mailfrom=tjmercier@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779214028;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xWuRtr4K/5gUdgYtvuhsDbR4Td/jrXMBs73+p4Eyg4o=;
	b=v+rCBc2fG9KBzGLBRsovydk7Lh31U8oVLgtLZ6APNAKcLbg3jCqyKW71AcW88C0ewAQc94
	N6qW7m29s9dVAmJFtc5P9NJoctZSVZFYPJVjih01Xm3vhl6A+Jz5JOnCR5KR2Z86ydB8qX
	gD5BkMdxXC0/GP1l3tek8q9UTdMSVv0=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1779214028; a=rsa-sha256;
	cv=pass;
	b=LvmgxxOlmy4WdCTplaX2lcIZjmjHjcv/S4lnDq9WLL+4yxL9Nz6SkGMJEsGQA5m3i8dOls
	A4oiXmbEryWYcVFQo3LaOxh1GkM676MZBEo6NBG1uL3YoHdHJiGpJqZAS3L7bk13FhRhUm
	9ojw0dK5tex38f1wpJWCWLPpTHz7OXU=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Wxa0qDcM;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf02.hostedemail.com: domain of tjmercier@google.com designates 209.85.128.50 as permitted sender) smtp.mailfrom=tjmercier@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-48d1c670255so325e9.0
        for <linux-mm@kvack.org>; Tue, 19 May 2026 11:07:08 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779214027; cv=none;
        d=google.com; s=arc-20240605;
        b=Wfw5YHvFCB71nEoUk9u5cdXq2hPXVAbd1cwXc79eJ7WMG/K1h7ROkbEBcA1Z3I+0On
         V9ekP4mljRPlKUMq2Y0kX8M7MPVMZ1EikhhyVnVUfe6G0aerlMZ3vOLpyOgiEfRyXfZC
         9ShcV5OaAzrFvVOoaUsc1S4Ra+CmdFDVD05pmH9XW6vKsXYfvPwrkem9va/vzzVwTQpq
         MgJ4KVWdelGyHDYf+sABMeh1xBygEnzU6dZkwVlgTK4gfIXZvzqjbSIq8a/sbxRHXap8
         mwbilylvo/M8HV85kDeAmvjRIB27NhPJMaFxFmAVUhSXTH+6MpqeJlN9axd5ZTQV/2BF
         uD8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=xWuRtr4K/5gUdgYtvuhsDbR4Td/jrXMBs73+p4Eyg4o=;
        fh=fBt2hYhJc/ks35ckuzhqjkGWW6xIgiHN+9G0ES23gdw=;
        b=i/5CWqd/u81xyqvPS0SqyYQeVc7g7vMc2E8sfcgenmwaui5gXi+ODBN6EID0IxUs6D
         axtbgGvWGQLFZLL8ASb/ZFfjzNG7K83CmWM5mqm5JtEjA0WT9WTUVFSpveU1UyxhBekf
         qn4Lal7aY83xwt0Nx0Vwlqle6FaYEjJFovbLJ5Pb9RCnBVkTONW0HtZ8T/pPtmTOrvzK
         5cox5h+iZj/Jvds7wLN1gVf/UPhmcy3gjEtxO934lUX1Hu8TpxYvtymAv/HlKQPFLo8j
         PgLrEAAatkLjqw0DYrHh85E4wb+/5zPkBciVOX6zXH3VEOqLj2d3qzx5R6nJM6SHnX4s
         BkBw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1779214027; x=1779818827; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xWuRtr4K/5gUdgYtvuhsDbR4Td/jrXMBs73+p4Eyg4o=;
        b=Wxa0qDcMaftUS/L7uoEU7udPkvGIm6v5NulgfYUkW8MLp0Gsc7WgdriHz1eIgYzDN6
         946eKfMhutCBxGiTdD36cVxhGlOnK9HJaJ/a7NyGToorPnDa4HPpxhFBvhY62ZNCdDKP
         3w6CBFyfr6kc0wnb/y/xvM1qjSnyjxiZJgjfHYMg1+MK7Q/dHb3djBzfsldpor8XUCkN
         5i9bQ5Q7lwvgAF7Do8doIKsXITyLI1TasTpMskXdvNiUT7Q8VABigJUqYl+ULKJ7ajCH
         7H+865UUcVxQnp/G70ez19f+1tI+5Hs2EqXNxB3eWhp0WEIlRUCVP5ozLGG1mLfMbtDS
         JISg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779214027; x=1779818827;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=xWuRtr4K/5gUdgYtvuhsDbR4Td/jrXMBs73+p4Eyg4o=;
        b=VYZd4BwZmg3U/ejc60tBWKDDKszdb8yrFba+EO6pNXi//Llju+wglGH8R2QBTx9j3B
         pZwUfsjcEkh/xN6np8uw6yGm+j21LUFePVm5lVB4QMdziNREwtFoWmi3x8aubb33wgxc
         W25yLfn7QIj3c9oJOSyTNt2tR4KAzyEip7KdRfsBPqP8Rsl89XEAeKBEgkfPel/oY+wT
         WVU8JT2vxWYAERMTrqSDCESPtsq6iHhlhlmMWmdeHaASHusRnrW+enT6AQiQ42D8a/nr
         DNTto8L9hNnYCR7Ft9eBREoRIdGjK101pgNNmZKgUcheY4KJUtVlOkAqBZTjlXvkCl9M
         lOCQ==
X-Forwarded-Encrypted: i=1; AFNElJ/zGK+nVYv6cGJGgVssq5AKInNjukib3oocyrxgizECqzFD6NIfJtfIZdNGiZ8D6vkK0BzmdyA1pQ==@kvack.org
X-Gm-Message-State: AOJu0Yxwn1ME/upnLzD9M5+41Ty8JNHc0VbndrEq/cZn7rslR6V1Tsuz
	+8xMRELPTf8uWAm9BZG/9JTD8XDGdlaVe/5lTm1alXpTyMtZRByG5nRJ3T/AnYbVLbRGbVeugpS
	bzLqCv9+roq1APtAs1HxSjZhBP4OzF/WhuCJWfshz
X-Gm-Gg: Acq92OFWrY+hObyWLSvqwou2a7j1YHrYlQXii/003/LW/YjiRrXfzb4tS8edaUeuEhK
	1pVpxU2Gvq/gMeaBkVC4G1cQ6BbJMblL6FMGmGcgGBBFhc5wML14yNnQZ6fdvYX+LD30bHB5cEP
	RPUUmB6aGpZZReOofZLqtp0MKEke/tKq4uRcDSqw27h3dS1iulR7PAqUpfYnDYerFfITjZgmeWw
	mH5/k+66XoKZiNmje7ezLn2jILtLefzkRcP9K9b4TUHPnHMBd7kkrILS1ot62gpr91OjrhPMEtg
	hO3fHMj9IMJRdGARbh4sTSe4p+INS1sLEypjr4/p3zlXT31yI8UaXNIgnF4=
X-Received: by 2002:a05:600c:828f:b0:485:1a54:9407 with SMTP id
 5b1f17b1804b1-48ffa06d607mr4555145e9.0.1779214026686; Tue, 19 May 2026
 11:07:06 -0700 (PDT)
MIME-Version: 1.0
References: <20260512-v2_20230123_tjmercier_google_com-v1-0-6326701c3691@redhat.com>
 <20260512-v2_20230123_tjmercier_google_com-v1-2-6326701c3691@redhat.com>
 <8ef38815-6ae9-4359-86d4-042554357639@amd.com> <CABdmKX2uwZ12kYJYPJGfWxuMBOJS=64b1GRj72tfB5D=NKM22w@mail.gmail.com>
 <CADSE00Jq_uvNgvxgPze0mEdUd+hF4-DPZkHy0KroWHZzygf4WA@mail.gmail.com>
 <CABdmKX3DhejYBis9htLDnzPrG7vuF3R3URLVNEbnyd61SSsx=g@mail.gmail.com>
 <CAGsJ_4zyecY6E-=Tm4_couT7uoM9LMcFdTMUPkZAjj4zUKE-dQ@mail.gmail.com>
 <cb84c2ee-9de1-4565-b2e0-60984721228f@amd.com> <CAGsJ_4z121v4tK_3+j-hkD7HH0gH3w8tWD8nk0CwRhFE5T+4Og@mail.gmail.com>
 <8a13b1ad-f1be-4ef4-905e-0d9828ae8cb5@amd.com>
In-Reply-To: <8a13b1ad-f1be-4ef4-905e-0d9828ae8cb5@amd.com>
From: "T.J. Mercier" <tjmercier@google.com>
Date: Tue, 19 May 2026 11:06:53 -0700
X-Gm-Features: AVHnY4ILqt3aAhuKzQVtfjO_TWAUc-lBkfBsfy8pZGOgOTZtrN6Xce9TENH_RxE
Message-ID: <CABdmKX1o5FeR697DGdExhSDAzdLBN=y4ijpA2SZyisC6ThYKbQ@mail.gmail.com>
Subject: Re: [Linaro-mm-sig] Re: [PATCH RFC 2/5] dma-heap: charge dma-buf
 memory via explicit memcg
To: =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>
Cc: Barry Song <baohua@kernel.org>, Albert Esteve <aesteve@redhat.com>, Tejun Heo <tj@kernel.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
	Sumit Semwal <sumit.semwal@linaro.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	Benjamin Gaignard <benjamin.gaignard@collabora.com>, Brian Starkey <Brian.Starkey@arm.com>, 
	John Stultz <jstultz@google.com>, Christian Brauner <brauner@kernel.org>, 
	Paul Moore <paul@paul-moore.com>, James Morris <jmorris@namei.org>, 
	"Serge E. Hallyn" <serge@hallyn.com>, Stephen Smalley <stephen.smalley.work@gmail.com>, 
	Ondrej Mosnacek <omosnace@redhat.com>, Shuah Khan <shuah@kernel.org>, cgroups@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-media@vger.kernel.org, dri- <devel@lists.freedesktop.org>, 
	linaro-mm-sig@lists.linaro.org, linux-mm@kvack.org, 
	linux-security-module@vger.kernel.org, selinux@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, mripard@kernel.org, echanude@redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: CB57080008
X-Stat-Signature: 5rwtqx73edcwowrs3mp1cnwro874gkc4
X-Rspam-User: 
X-HE-Tag: 1779214028-801894
X-HE-Meta: U2FsdGVkX1+WI86rpwquRLEF5a7rI2yQd7Q0zGoyx5IKbPThrEvqKp9ZwXP2itS5pV9dW2DWJfmm91V3q2RBU34KDabgQ1+kgTvT91y/Bgv//qrpjDaxcPiyJjCYQkCFvJ07n6H4CNZ9aEaFUSA+jIJcP97op6r8mR3/lpkdeqFBKyaMsp389JwR1CRtS2nTctjlWZ+mWfHWhuwCKRe0ujkyjlb72SCKJOKaj6JCwQFordWGI/vR30UMA0GS2AVuPrYybelEiDkKIpYNhKDVnm26/Zk4wBJf7bcfsMDS8roI/k++DtUYizbbBgd9OuixCzhHJK9jvSEu+Yg3MrE/SF/nWqfqLZHMZ976DXs8Ji8aeTsdiBVUqITlm+IujbiZb4w9joQU4ybz7rMaBdEZufzacbS2TulhVwwWwZPRyr2jul4DBzyQiZVbr7tcki0G+bqTtxXN93HtVXDeJTnB5g0vPWOfKNO5wvBfBzviP+lHXaBHloBeVltiBGUZp1MMNT+w+8Vy0z6Is4zvAJi+iCTFGgT6k/OsCWqNsa4rBS3iV2GveJx5wEi8Xo/NqJXPL41UeAyu/3gduAVp/QEMevyHix3I87704YW4Fd/Vq5wSUvoW/F91C5jlrKsjlSAcdhrYDIk/jOUpizRAMHG5uhYciEqeI5HeuI2zXyrmukQeMZgTwf087OpfLZ3FexKxJvLY28LQ4/Ww6Z6U2PWPS/Kq0UlUl8Fv4cI9iA4CsZOEIAOJ8sT582XHFbiuwk0FsPSvo9LhormTBi49j/ijE0qiL4aRB7csxE/mFPP0gh5JXxavpBIUmNgSW4e77ppF4czJZ1MOMXrTPorZ8hep2K+VW8BhIz0UXxuKn7fhG3p073GG4j0Ic8EoDK1nMIrxRq710tXHEXtN9OS04qie1R9idxG7PKHLKu8V9pZ883uY8kxzum3nR+5ULJ5seIDLP0N//dGVQlnkAZPAO06
 0qgrsyBJ
 K7ArWm6yUdCQp38C57i12Ug9DksPsL7mQm+1fJs2Y8ILIRzWvq5OaK0dAkFMxT1cFxwuTG4W0dcedhKfxdlEmp0+gDn7P03JCLGU5Qvv/erU5db2fsGJs9WXSycB0/o06G/vwn7NSXPPHWB9dQU7nCKpmgSn4MZ1ytVoZOaaFO8ufkiV9tqb49eBomOAufV7ruRtbT4yVoPpeVwdilmnd/sIaxu8zqOmx269xtJ4Kr8DDg1HZzc06OMaQXP6Wy+IPNKonhjc1H+rzAmtQIfEdW9DUaBKzUbXk9Fu65RugorqST8Nffmh9dZUZUojPPu8HZkpuoQrE7S/wpK0kResfrn0KAO51I7XrgJJhW9FsNVp7Nxyu70rGSSTISLa/4w7u7fnRDAGRGYkv3m1SHHoXGIc1z7IqK9kPD02LDziAHYxDu8YK/BjdW4O54v1zxDKGjvup
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, May 19, 2026 at 12:10=E2=80=AFAM Christian K=C3=B6nig
<christian.koenig@amd.com> wrote:
>
> On 5/19/26 01:00, Barry Song wrote:
> > On Mon, May 18, 2026 at 3:34=E2=80=AFPM Christian K=C3=B6nig
> > <christian.koenig@amd.com> wrote:
> >>
> >> On 5/16/26 11:19, Barry Song wrote:
> >>> On Thu, May 14, 2026 at 12:35=E2=80=AFAM T.J. Mercier <tjmercier@goog=
le.com> wrote:
> >>> [...]
> >>>>>> I have a question about this part. Albert I guess you are interest=
ed
> >>>>>> only in accounting dmabuf-heap allocations, or do you expect to ad=
d
> >>>>>> __GFP_ACCOUNT or mem_cgroup_charge_dmabuf calls to other
> >>>>>> non-dmabuf-heap exporters?
> >>>>>
> >>>>> We're scoping this to dma-buf heaps for now. CMA heaps and the dmem
> >>>>> controller are on the radar for follow-up/parallel work (there will=
 be
> >>>>> dragons and will surely need discussion). For DRM and V4L2 the
> >>>>> long-term intent is migration to heaps, which would make direct
> >>>>> accounting on those paths unnecessary.
> >>>>
> >>>> Ah I see. GEM buffers exported to dmabufs are what I had in mind. I
> >>>> guess this would only leave the odd non-DRM driver with the need to
> >>>> add their own accounting calls, which I don't expect would be a big
> >>>> problem.
> >>>>
> >>>
> >>> sounds like we still have a long way to go to correctly account for
> >>> various v4l2, drm, GEM, CMA, etc. In patch 1, the charging is done in
> >>> dma_buf_export(), so I guess it covers all dma-buf types except
> >>> dma_heap, but the problem is that it has no remote charging support a=
t
> >>> all?
> >>
> >> No, just the other way around
> >>
> >> DMA-buf heaps can be handled here because we know that it is pure syst=
em memory and nothing special so memcg always applies.
> >>
> >> dma_buf_export() on the other hand handles tons of different use cases=
, ranging from buffer accounted to dmem, over special resources which aren'=
t even memory all the way to buffers which can migrate from dmem to memcg a=
nd back during their lifetime.
> >>
> >
> > Hi Christian,
> >
> > Thanks very much for your explanation. So basically it seems that
> > dma_buf_export() is not the proper place to charge, since it may end up
> > mixing in non-system-memory accounting?
>
> Yes, exactly that.
>
> > My question is also about the global view for both heap and non-heap ca=
ses.
> > After reading the discussion, I=E2=80=99ve tried to summarize it=E2=80=
=94please let me know
> > if my understanding is correct.
> >
> > for dma_heap, we have the ioctl DMA_HEAP_IOCTL_ALLOC, where users can p=
ass a
> > remote pidfd or similar information to indicate where the dma-buf shoul=
d be
> > charged, as in Albert's patchset.
>
> Well that's the current proposal, but I think we need to come up with som=
ething more general.
>
> > For non-dma_heap dma-bufs, we don=E2=80=99t have an obvious userspace e=
ntry point that
> > triggers the allocation. So we likely need other approaches. We could e=
ither
> > move more drivers over to dma-heap, or introduce something like
> > DMA_BUF_IOCTL_XFER_CHARGE, as you are discussing, to let userspace expl=
icitly
> > declare a charge.
>
> Yeah but that's not only for DMA-buf, we need that for file descriptors r=
eturned by memfd_create() as well.

memfds get charged on fault, so an allocator shouldn't currently be
charged just for creating the fd. Unlike system/CMA heap buffers, the
shmem backing a memfd / udmabuf is LRU memory, and swapping the memcg
owner of those pages is a more-involved process which is not supported
by memcg v2. There used to be some support in memcg v1, but it was
removed. Commit e548ad4a7cbf ("mm: memcg: move charge migration code
to memcontrol-v1.c ") said, "It's a fairly large and complicated code
which created a number of problems in the past." So I'm not sure how
much appetite there would be to support it in v2 for this.

