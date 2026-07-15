Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F26B5C44508
	for <linux-mm@archiver.kernel.org>; Wed, 15 Jul 2026 15:32:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BDC076B0099; Wed, 15 Jul 2026 11:32:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BB3D76B009B; Wed, 15 Jul 2026 11:32:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ACBF16B009F; Wed, 15 Jul 2026 11:32:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 7DB146B0099
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 11:32:33 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E323E12020B
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 15:32:32 +0000 (UTC)
X-FDA: 84991402944.15.315701D
Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	by imf03.hostedemail.com (Postfix) with ESMTP id C8FBF20010
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 15:32:30 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Jb4wWyn3;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf03.hostedemail.com: domain of surenb@google.com designates 209.85.208.51 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784129550;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=o+EmL6ul0Mt4yc97Q5opSK0Zr5dXjXkyP7dXXPr3OPA=;
	b=ytGv+0gN8BtUo773jVVAEUV+tCNXNyql6QMrrppBSvClSFxMOqknvVczdOxqG1nny4kVSU
	RhNDFwVH5Ycw3Nh5mEZdDFcCoAt2nlA3AiPEEuD/Lriusv2j2rx4u51npcy402P5FGvQNj
	oSmo5CvsCjiShDvrTm48cpvIklLq/ZA=
ARC-Authentication-Results: i=2;
	imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Jb4wWyn3;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf03.hostedemail.com: domain of surenb@google.com designates 209.85.208.51 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1784129550;
	b=yTjeM80x/6e1EtNqhYNTyvB/e7YoMhkrKUNzpS7EKjTXCJTBKEtZh5FQxZydJs73U71U07
	GIFvlAp6kiFWFflLlNEKdkEA6i7xgNY3R7j6MFa7b7j7no376Cno9VLU7gyJ+xtKqScQLA
	3tWneohT6/nLTsPJIbxJI5b2nLPjLgs=
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-69a19eb2e6dso11530a12.1
        for <linux-mm@kvack.org>; Wed, 15 Jul 2026 08:32:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784129549; cv=none;
        d=google.com; s=arc-20260327;
        b=nZDHtj6HFHk+gwwc1tbIDrM9sJI3tOjg1aslsDDgohlmFl2peNdc6snfVUubaB9Mw7
         rY8M4pYGkwo9IgKBIaf6Trh0LH05PjuydRvQ7Ou2Qshm7Dk9gLkpzMag2V5Fb31YeTlU
         aOCgw2p0UvpChgZfELcLTKO0kZ9D6Ch3T4bAJK7Q5WMIOh+84r+0hm6W9L0Jmzx1y8O3
         /ghDsdDuN4CiPsgbvkbP43Ke+P21NvCpem4NHBhvuJ+mgAEIMma/on1feLx0BdPvyYBb
         1e8u9JUavxwE4WIyVcVl5mA060D1sB9orugrgm8brgD9Q/uK166/NuDvJ1ygIiBkVKEu
         eWIw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=o+EmL6ul0Mt4yc97Q5opSK0Zr5dXjXkyP7dXXPr3OPA=;
        fh=zVvzSI9fCGgqSCSFg8ohKHjfgeNS1WkOozFhjQGDXDo=;
        b=MaidnOScUcHjawXbavHVQ9rjmHCTWFkUQWnfOYDzLRG1TG2eU+CqHAGH0qh/Qiw67L
         TJD0QQBjXVhaEXBX0Njgf4XteAb+05Us+MadpufwWC4R49cqJUtZ9a9MQg9rp7OO/lmM
         nTDg6KEsKlOkMZ2S6Pnyv1ZSIJMk4ncmAYstwfGntwuw3/6qZzDG7Hy+uIIQgeH1cU0T
         JPdF+Nxl7nAUvytnVwV9zKyHcFB7gQdpzdQYWradJIVON7W+95qVvAMPytPfl3MQuLb1
         onSUfuT7iOwuXUs+AM/w2UBVGCD0hyCggrvF5rmpzvT+FPFQqnAJxmtyLCnLYfo3mPPj
         +87g==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1784129549; x=1784734349; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=o+EmL6ul0Mt4yc97Q5opSK0Zr5dXjXkyP7dXXPr3OPA=;
        b=Jb4wWyn3ry/75RYLdJKU8Qeh5KvfuHaN4u9/IA7QPe69zGl1ryVz6Ys4CXaR9m4dPP
         3ipnCn19H9QEiSKWY8f4eltJhxAkchnkKsAhsK19lbRIlvUAEe2xraOpJpeh/iuf2S0l
         2Fk1B0udxvbLOfWTS3k5y1bQ8yuGXYVU5aSnwgiyzNmrjpeRtS4e329wudz1bKweKxPE
         7qVnyGf/hrmqiyM2k//iWAnj2xy6tlTKUZ9HTd23flpMcz4B7UwIEj73zuyU0Uz6781s
         TcYZoJqPobcb9UgepS/tNmWS9YKd6S5IlA8GAGFeH8cIp74E+6A6DLe5cGvXgRNrvOce
         vK+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784129549; x=1784734349;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=o+EmL6ul0Mt4yc97Q5opSK0Zr5dXjXkyP7dXXPr3OPA=;
        b=M5yw4UMaqn4I201nB+dTqBsOTOs1yG2+nvbxGRMSVsxM6H8fAoOJuSxomp4SH0eGyi
         +eF1XYCrLtBPx9IUzMt9Ew8EnEmhlGM2u4bGkDaZe1Pkz/3l+81Co666fsPn5kqaI8zC
         5wq5k1xdYRW0/i+uDBSj2AQYrXAaurMIlYYNKZk6fUlubUs2g7Eb450Ojb8wqikIYBz9
         ovgoNgK1UhJCcbDucbMPKUoNSeHq3u5hOkhQetnb92dR6m+f2eJr9KLvUHP2lflcFPkA
         2v0WI9XYxB3TgYrk9ZV3phwkD/1gKwh8u6N8vl6F7pqRIlwB+StRWLHonaatIn2Xh7pe
         Vo5A==
X-Forwarded-Encrypted: i=1; AHgh+RraK5y/Xtjhsmq86EGg9tbPVvHB1xzJyYCbtdN8DIkt+ZYLvyNyMuxGkBx53SnVphxuirhAgy4fVg==@kvack.org
X-Gm-Message-State: AOJu0Yybmt1N6uW56FvE3qtP9he8r4EJC7OQBHHuyNiBgOLSKgwO3TLp
	dkDenOrlDoKa6h/doFae5CezHpeViYgca3vI0MxwIZQqk1dTOcxhLAplA9EobVs82TnsGmqrwrm
	AWByLqlFAWTUXtV5ObC+9e1sEC3i6rps1X0dv0uKQ
X-Gm-Gg: AfdE7cl7V5e7txEcjIGWjM/syssCUW5MCuMmtE7wNIfszSJmNdZggEDCi4lHW1yEMaV
	++IycVP8gIlDRpNlbfviwBIZpOn8TKYZvcGOxa9SNOPCafUBHbI62nT7Lv2e1pXFurCQMb86TY0
	DH47UrZYDCheeoojGUojpt+UafuAU+6l+mi/I4pRbxH3ZtgTlHridapUPQ/0yO3JVNP43P6ccst
	eAL/usBPt8d7q0lUhnZlulm9czmE0zTduUjYJAFNS3eGT7R0B4KAy75DEHq5Ordh+58LPhCo/Zb
	Zh/4l6fx4MAQQEQMkXiAwaqj/jM=
X-Received: by 2002:a05:6402:a39c:b0:697:e82f:e4f2 with SMTP id
 4fb4d7f45d1cf-69ccf08bba4mr183091a12.4.1784129548768; Wed, 15 Jul 2026
 08:32:28 -0700 (PDT)
MIME-Version: 1.0
References: <20260715-b4-objext_split-v1-0-9a49c4ccf4c3@kernel.org>
In-Reply-To: <20260715-b4-objext_split-v1-0-9a49c4ccf4c3@kernel.org>
From: Suren Baghdasaryan <surenb@google.com>
Date: Wed, 15 Jul 2026 08:32:15 -0700
X-Gm-Features: AUfX_mxQK59tgAAh8WBIpXQKDElc_jbLM3NvO9a2ZdZbwnoad_i4PU5FH57YufA
Message-ID: <CAJuCfpEVQU6s58s9XWCVDUXzr=7bbatmCi35vxnSiyA1pe1P6g@mail.gmail.com>
Subject: Re: [PATCH RFC 00/12] mm/slab, alloc_tag: reduce obj_ext memory waste
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Harry Yoo <harry@kernel.org>, Hao Li <hao.li@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Alexander Potapenko <glider@google.com>, 
	Marco Elver <elver@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	cgroups@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: xnazeqegbmt13xhk648kzsjpb65uq8bh
X-Rspamd-Queue-Id: C8FBF20010
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1784129550-658464
X-HE-Meta: U2FsdGVkX18FunYdhDCIceY2VXmEjmg+bqSdJl8U4R5D2WdLjH832vsCzPsGSHw5idiidc5ZbvPrh8UAbi7ruNX0QiQCsBRVFzNH4WkB4PTNOZYa2a8tQ3m5hzeqAMFYgT9nJybr2ep34mdSGRBbadPaIE45YU4sL8NCnE8qjLoRBQuP3weP0zOQvQBTMMYkcnCVApd3MuFUOqK1bXEQsxxwRpJIbZW+MGzQ8XTvUknppQKONs0M6vezqty/yKv2uF6jOGq6LYQYjuyvDD1SlSNqiFk6P88v9V3vYgUv00Zj4UY0Qvj8+/zRoiRkeXoqHwKzPJNLxKiD2EYiUsftm+ANPBDSJgfCtuzFqvCI+hZmPqcAiVKY02evlSOsmjxwAeWNgK4NHjKqfSCVW1jxYTOwFww1RKwm7i92sxf0YLddf/5Qc6y57DrJOXjP3rCDdHaOQlpoVa8YpRzh09rUx5uX1eEcDhDTacQjJjCJBnJVI3RKXOGyXojgcCeIqvf68bEQwKHSwKGfyBFUDaijDcZgd1/6y8uXeDhk4gKGCk1OKLzpQX0ciEOhqLL/WOkeKdPcFHn7lcBcfZae3dMvGFJ4NH2x88gW5fdti1mMP5CB26es0+5YV2ieJBfq7V6ZSx8MsD0oRKdRcqiCKEVFv2aodizgh6U/dMox2GMWZtI8GQfI11ps4dTC/k5mcw71FK6Exo6wJHBZ4ohn3hd2PsbAYrmbQtWdis1KLNXJavfp7DXLBx+Jh03NNEM5ZvE70u/FyJmxc6rlqlygDYvFpiEJB2xYilY3RBpYpUv3Wqv426eeCaPYRqQwfPmmqHbaMHva6ZNakgp70VvxJYsahPEBgpjFT/r6Eu/ESDbMuUlSr26xdR42K6fXmK91TiiKqVM7QlgV4c9n47tMMqu7R+z/2nYw3+QrCk3gCXni2g+RQQIbHbkZ5L+nzJ+owFVHkjpzh4ZHKXPQ05e/DlG
 4zNlq3wz
 CSG6He1TSB38bk4NpmcJoEqtEBNfxIbfYXxikCtF/sPmE+NGb8i8fPxWMPt9GRKDx5qPTTVrtRGoJnDIzDz0diWCBf3SpZRgu96BH80Ip61NhrJ2HfYju/TejzzYzN34VWBoFWJzcaNkvvM5YVLXiUtZr5bXkDH9OhrBZf2wf5Cd7Pyha20ezoviboMX51QrDXZeGXczlkRv54boErLm21WRMxQAiZK6WchKfFMbNvx92n2Prhd8AWVbRELge96sm03RZzjfSAL42DdnKRxqclXJ6yi1W0oxHGm1XHsLSmur5dVryRxC2+uV9rA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 15, 2026 at 3:10=E2=80=AFAM Vlastimil Babka (SUSE)
<vbabka@kernel.org> wrote:
>
> The recent fixes for objext array handling inspired me to look into this
> finally. It's been bothering me that the memory usage of struct
> slabobj_ext depend only on config options and not whether the fields are
> actually used. So with both CONFIG_MEMCG=3Dy and
> CONFIG_MEM_ALLOC_PROFILING=3Dy there is always objcg field and codetag_re=
f
> field. And thus:
>
> 1) Having memory allocation profiling config-enabled but not
>    boot-enabled means wasted memory on unused codetag_refs. This makes
>    it less suitable for a general distro config and the page allocator
>    side doesn't suffer from this, only slab and percpu.
>
> 2) Complementary, with memory allocation profiling enabled, there are
>    caches/slabs that don't need the objcg field, so memory is wasted on
>    those.

It's funny because yesterday I started working on a prototype for the
same optimization. But your patchset is much more mature, so I'll
focus instead on reviewing it.

>
> This series should solve the point 1) fully for slab, pcpuobj_ext
> handling can be perhaps improved similarly, haven't looked into that.
>
> For 2) it avoids allocating objcg fields for KMALLOC_NORMAL caches where
> we know they are not necessary because kmalloc() with __GFP_ACCOUNT will
> pick a KMALLOC_CGROUP type.
>
> The named kmem_caches are tricky. They can be created with SLAB_ACCOUNT
> and then we know objcg fields are always needed. But also they can be
> created without SLAB_ACCOUNT and then some allocations have
> __GFP_ACCOUNT and some not and we don't know that in advance.

Do you know how often this happens that a named cache with no
SLAB_ACCOUNT is used for __GFP_ACCOUNT allocation?

>
> A possible future solution is to introduce e.g. SLAB_MAYBE_ACCOUNT, add
> it to caches where we know __GFP_ACCOUNT is used, and only honour
> __GFP_ACCOUNT for those, while warning for an unexpected usage
> elsewhere.

I wonder if for such caches we could create two separate caches, one
serving __GFP_ACCOUNT and using extentions containing objcg and
another one for non-__GFP_ACCOUNT with optimized extentions?

>
> Only lightly tested, need to run at least some microbenchmarks to see if
> the now somewhat more complicated access to objcg is visible or not.
>
> Based on slab/for-next-fixes
>
> Git branch: https://git.kernel.org/pub/scm/linux/kernel/git/vbabka/linux.=
git/log/?h=3Db4/objext_split
>
> Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
> ---
> Vlastimil Babka (SUSE) (12):
>       mm/slab: skip kfence objects in allocation profiling
>       mm/slab: remove objs_per_slab()
>       mm: move struct slabobj_ext to mm/slab.h
>       mm/slab: make slab_obj_ext() determine object index
>       mm/slab: abstract slabobj_ext.objcg access
>       mm/slab: abstract slabobj_ext.ref access
>       mm/slab: replace slab.stride with obj_exts_in_object
>       mm/slab: change struct slabobj_ext to a union
>       mm/slab: introduce slab_obj_ext_has_codetag()
>       mm/slab: reduce slabobj_ext memory with allocation profiling disabl=
ed
>       mm/slab: add slab_needs_objcg() helper
>       mm/slab: stop allocating objcg pointers when unnecessary
>
>  include/linux/memcontrol.h |  13 ----
>  mm/kfence/core.c           |   5 +-
>  mm/kfence/kfence_test.c    |   2 +-
>  mm/memcontrol.c            |  41 ++++++-----
>  mm/slab.h                  | 169 ++++++++++++++++++++++++++++++++++++---=
------
>  mm/slub.c                  | 162 +++++++++++++++++++++++++++------------=
----
>  6 files changed, 267 insertions(+), 125 deletions(-)
> ---
> base-commit: d9e6a7623938968e3752b67e37eaff097e559a54
> change-id: 20260714-b4-objext_split-da82426257d5
>

