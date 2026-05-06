Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B0489CD342C
	for <linux-mm@archiver.kernel.org>; Wed,  6 May 2026 13:27:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DAD626B0005; Wed,  6 May 2026 09:27:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D5DFB6B0088; Wed,  6 May 2026 09:27:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C28A96B008C; Wed,  6 May 2026 09:27:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id ACB276B0005
	for <linux-mm@kvack.org>; Wed,  6 May 2026 09:27:16 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 5A65EA0140
	for <linux-mm@kvack.org>; Wed,  6 May 2026 13:27:16 +0000 (UTC)
X-FDA: 84737071272.01.C421370
Received: from mail-lj1-f173.google.com (mail-lj1-f173.google.com [209.85.208.173])
	by imf17.hostedemail.com (Postfix) with ESMTP id 3613A4000D
	for <linux-mm@kvack.org>; Wed,  6 May 2026 13:27:13 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=BJU7LqIk;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf17.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.208.173 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778074034;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=G8+O6WlrTVqaZn8/F7q6B9USYK4FirbixL2u42VdTFQ=;
	b=THilYFOskbK7bWp7XPLkbs5Nswlj3LMFKIi+hYQ1VGbo/G/5Y3AlKjJ52JKEWZjlGy1n1m
	r8OH3+Dh0MlXt0pkN1bBk8tXcPzyThULEHEsBeCCvURvtqXXT/ztJWx7+Omd4I9Xb2G9gT
	KspuND/9vumvHQJzlM/Mtd0fNAQewDE=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1778074034; a=rsa-sha256;
	cv=pass;
	b=4rtUovZ4nGEDqKOHDaW+DWiYfBAZnvY1GF1AFjSekuSgYrhHBJiS26jh2lyOn6mrE60uQx
	XeM9Gqrsja+OVK9KllFYei8iTGTETpOrHlXucyiQwO1YOcIzH5yN+04nvnQjcb4pjditxd
	USk91lk50ltzZP3aW7YYQnQSEH4E4ms=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=BJU7LqIk;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf17.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.208.173 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com
Received: by mail-lj1-f173.google.com with SMTP id 38308e7fff4ca-38e84ed22bdso65889151fa.2
        for <linux-mm@kvack.org>; Wed, 06 May 2026 06:27:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1778074032; cv=none;
        d=google.com; s=arc-20240605;
        b=jNMK8vU5v0oD0w9oMNsq6TT4hinnk1ZVgxyvfn7JJ8Plpcex5JP9/KNL5PCuaAZBof
         GcAHsM2ZfY+dvLzOfRTa2yxXQGsjFF4ZNQ4wVhEcPNV1dzdk3MuPqnuWW5OTUg2u/uDX
         7Mp+RGKEYLd4JXS6fu8HP7oECf9uMfnCacVhUPvgU9CoWyTWRD5a36tGeGGPXahkuoWQ
         oilzbsdJwr+N6aCaIKkKrMSpDvajC/oYb4B5CYwlIXgMFsTLRMgp+FjHUFHpCJL/jVAj
         dntdZWDMOxFJ199XRrKNvI3rkw0wO59VkYiEbL6PZQ3VwJ1kZE/N2cY5yGqZWVBbqnd/
         ZGLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=G8+O6WlrTVqaZn8/F7q6B9USYK4FirbixL2u42VdTFQ=;
        fh=DbWKjCJizi1Wv29TnyevbFe7Bd75VszSOQkD8nzT74M=;
        b=kSejV9+LZtetSXbiByg0WX0ooKrehBylCxAyKmLrR8kQjGDNyD+AAkMlfYQ7ieXMha
         VTVenFAk0+zAp1kAgeFwCNZvHeV8eL9Jd6CCxnLlkq90WZdP/e4Pc6nOWH6cWE0Hch1G
         2RNGUQ7PNA0rSLu0CxqzIpJuWfk/5R5Z1r5ovKtChaJRvmahrazkjRpRE1lBizF+2lEB
         Q8LHulg7w4P1UmASgUwh1sJ2tDrN0RY787U0QyymG96qmVxN78345QNdy7IBXF0AS5Af
         nyQQHejCL5k85Eq8Lxu93vSL8/kXIoEpY7x1mc0HUOsGv4O5ryyyauovGIQUMwP3Dkby
         OXng==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778074032; x=1778678832; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=G8+O6WlrTVqaZn8/F7q6B9USYK4FirbixL2u42VdTFQ=;
        b=BJU7LqIkrMjQaEUl5gnEBjlNgd4679Lw4Cs9iOMk+z43ApKMmr+ByfkJOwNV05K3vA
         Ublwpqynds/j3gM6gBi9uiNi+Ft8hX95ehKaki12jxIwOT+EcmTGnmOccCM9ZgmOVN6y
         /WXQJxFSC3bzw2l6W6U/t2yY4Oie8Ojq/HTsSUBZ4q7TwB64nRWUR2zvT6shZcGIpdby
         MmCv28k62hzpeId2RjJbo487Nd/SsYM5oes4KX0v/fPoJh+HdlN3KzH8bq0DzwE9yerI
         SHQa71W3JuXGzP9u2oXEVBHBqJCyvfYlQ5bfZUIeaWRXSkUFqfk5epdpTfjcqJ7K7v5b
         mEqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778074032; x=1778678832;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=G8+O6WlrTVqaZn8/F7q6B9USYK4FirbixL2u42VdTFQ=;
        b=AEb6T65yvmbOGbraJS+Uq+eEd2BaTe0Qt7gnS5R1roUYO+bHTPcsWXo7xylWH8cRkj
         HgWUda7g9Ub+1gkqx3ypxH0ahtISfQnPbkFsEOUzFb3V5kbchbzeWoulmA01T7T7Qowy
         0p39bmgkRkmJ7OPAt4Q2iku68QB1K/j8COpwut83Vtf8YC8X5i+6ZRdk2a6llrDylt9b
         2M84FzktiBTYFQz650VJdb7ClwlW69ot8Sw98dULk+rrwAmUDPv1vVvOfNmZeNUrjYl5
         8sQz4nCjV4CN3h+oxUI/G93c4wbxGD+a8Q0WF6Hux4JGrpwhP6eu/va+jDmq/um3XhYV
         mTxw==
X-Forwarded-Encrypted: i=1; AFNElJ+ykH8ptVceT/6bxYbN3AX3RaaA5DxVO50O5attlrB1drYFqz+Q4QBPxXp3l2m0A6LemQLb09zlcg==@kvack.org
X-Gm-Message-State: AOJu0YypTF2lMk/VOuqa7OoSYInQtmvLdU6pw4gFYhjICh2yZk7HHXdS
	Y4GqXf+8xRSHoZHTBOGHk6t3ZnIMODLK74+cOSHgc+G9tFf9U5dolC1Wm+oxDWl5k04zemXZg8o
	x+UDKHgqbfgk0qeScOYnq5XYiG9DFQcA=
X-Gm-Gg: AeBDietZAGJ0EDsI4xDhk1pizVr2N9OOU2Tju0TLU2GZnO7QGU7V/HIfgjF/Yoya5Pn
	PBMedaKsTj2f4SBNltU77ZGQIb2ABXWv1c3PS3mKGCcPebPq3wEblt0sl5SW61g6OLwV5kTeEcZ
	15bIwgzQD3u5aXMy0rXTXVvVk6vzCG4B4IdRKWrhgjheQa22zHSJc7M6Q2iaqyF8h5TlRLCh46G
	IBLRwmOV+YLYVw2p6NLue8LIdKTR1tVhC9annICQqTEDeAXiEtxNJjJFKikZCmb/VLkc4sxsdbc
	tmh8/6pznrvwaWYC
X-Received: by 2002:a2e:8952:0:b0:38e:98b0:3a7e with SMTP id
 38308e7fff4ca-393c4211654mr10682631fa.22.1778074032033; Wed, 06 May 2026
 06:27:12 -0700 (PDT)
MIME-Version: 1.0
References: <20260503165024.1526680-4-vernon2gm@gmail.com> <20260503174125.2C949C2BCB4@smtp.kernel.org>
In-Reply-To: <20260503174125.2C949C2BCB4@smtp.kernel.org>
From: Vernon Yang <vernon2gm@gmail.com>
Date: Wed, 6 May 2026 21:26:57 +0800
X-Gm-Features: AVHnY4Ljul8CUzS_G-va6ruKGX3ZCJiSzHij9r9KLJr3ECHCCjVxfY92mQxB2T4
Message-ID: <CACZaFFO9-xe-LewtzcUn9XHaJOUiMv60==M6TVOPVJHFafAefQ@mail.gmail.com>
Subject: Re: [PATCH 3/4] mm: introduce bpf_mthp_ops struct ops
To: sashiko@lists.linux.dev
Cc: bpf@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, 
	"David Hildenbrand (Red Hat)" <david@kernel.org>, "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, inwardvessel@gmail.com, 
	Shakeel Butt <shakeel.butt@linux.dev>, ast@kernel.org, 
	Daniel Borkmann <daniel@iogearbox.net>, surenb@google.com, linux-kernel@vger.kernel.org, 
	linux-mm <linux-mm@kvack.org>, baohua@kernel.org, Lance Yang <lance.yang@linux.dev>, 
	Dev Jain <dev.jain@arm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 3613A4000D
X-Stat-Signature: 3pw3653xusnpanndquuyhzuwnfia4o14
X-Rspam-User: 
X-HE-Tag: 1778074033-423597
X-HE-Meta: U2FsdGVkX18tKp4Lqlb7BF0NA7YlB9mEwFL+qd5kJQIBxFXKlcOjHLMFb0q5kCTnqSBVrOztae8ASDdrPRlrtm5grqZdsE86E5agXfqDwZrGxw/IfDW6zQP6MjoF09Wliug9qefcOCQdCZdKUFl08wZ9xl52+Bl8MfGkuDamy02UqrA009IAX/0lzsTzS/POsgyfU53Xkt5/g2012h59aK3PfGfVjsivqqx1OcbrAizUXUkuQqCRd6GRNyK1B00qx+lF8PlAS3JpTdL1wNwLxufp6oScWrHsvHE8XR0olvv/K4WrdOShB1cLEXpuK6tpZi8eQAiS4Cvu1ZFbMmVa33tJv6jmlC9wqijeTWneDLr/uZF69JQ3oRNhwTV/8J86Y5LlkYZAHxRZy7X92WXDDWYCXUu4q5ZsOoZ9LyLybDc8QW/7kpoBvG4MKVOI7tOavUV2FrR0Sb58KeqexHsepiFPCppT2A/mEOUupCBOwjTJ3pVC+472mFDd/FZftEj0jQrt2rjDjPXXJT/f9z3ePF6kwySYBn2mf/XzFgFN6cxs/erFGdcIqRDhWynyKQwajuIgUtRpwkCJdiaBA/1BU78V3Q7CrSpA7s/5tDb0XuG9KUuXcFJW6XGFgI4Dq2gn12Ztt+5SFR+ZiF4OQ2rnBFNKeCx1a1U4NEBs6DllRL74n4HY4loMvHHArQAXttDdu4qq++spgr9NfrE/3253789ZsbZer0MP3QOkVR3iDbeKrW93XktCqjArP1MkkY9xsPmmcWgwtsAM8t0ouzz2oZbsFt3vlC8qebKmIRwXNgikjNSxyAEQVjn5STlya0LW/m/T1GgxzJsJUoZvwciewvRar9hyfXKHME2XWNzo1Si+5XRykD0I9Nf+JctaABzJrNTE9IHlKd0TbmPdyQuuGpqvT3G8+LnZ8X8fVilqt/ZeY4ZXbU8klzn8cUh3JtkI0c6TbEitIIi0u0/rH8y
 0icL43wm
 M646gWvWuNOFQ5Be9DvOUw4COtpwKsjxGP7D7XZSrnb91fpdrWgYc6XPKmlcec+DXcWIQ6QiFWsKz/mlAmlMdLjzbKmtLaH9P26B3YOEz0mZzWQoORaGQLhAwpbf6qEa+hXxdT0DmUaM9fLpj+wQbXwIRcKFal3WN4+bDvmBjzsonbZEJLsBBNkAF0KF3Ofj+9vuBD/tPmKz1OjrMOpMkF72xLFepRZPTLNYXzdl/T1Hk/WNivreOgtNs2zrlk0ADcz1fKeI2Jwq2aPzh0lg5bqdnKeqIZ73uR9zCO9QIXYlY7O6IztQLKFhIuwaD2IiEKB1o8gRnMTWQzsVEogDnCDYNcGiIhWm7Tocqfyw14ec0Hc+E3Lunqb+9k7gjK6QNuUg2+xVG2e+BFIr4IJsVm8a1PyICSedQsqmq6xzIDqRFUJAWoypp5zwrf/jl//1hXesXo2cB17pLXMiTb77s+RlgKU1D78r9G5QNiegG3nI3/YGcQ6wSPFiWWzuzsH1JSINCNJ7WYUASjpk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Forwarding sashiko review

On Mon, May 4, 2026 at 1:41=E2=80=AFAM <sashiko-bot@kernel.org> wrote:
>
> Thank you for your contribution! Sashiko AI review found 6 potential issu=
e(s) to consider:
> - [Critical] Use-After-Free vulnerability in `bpf_mthp_choose()` due to i=
mproper SRCU locking.
> - [High] NULL pointer dereference of `link` before validation in `bpf_mth=
p_ops_reg()` and `bpf_mthp_ops_unreg()`.
> - [High] Newly created cgroups silently bypass the hierarchical BPF mTHP =
policy.
> - [High] Silent registration failure leaves the cgroup hierarchy in an in=
consistent state.
> - [Medium] The BPF program can only restrict allowable THP orders, not ex=
pand or select new ones.
> - [Low] Compilation failure due to dereferencing an incomplete type and a=
 non-existent struct member.
> --
>
> commit e5c9c74b11f76b4de7ba4ef8ff94c10bae978e16
> Author: Vernon Yang <yanglincheng@kylinos.cn>
>
> mm: introduce bpf_mthp_ops struct ops
>
> Introducing bpf_mthp_ops enables eBPF programs to register the
> mthp_choose callback function via cgroup-ebpf.
>
> > diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
> > index 2949e5acff35..80ec622213df 100644
> > --- a/include/linux/huge_mm.h
> > +++ b/include/linux/huge_mm.h
> [ ... ]
> > @@ -291,6 +292,11 @@ unsigned long thp_vma_allowable_orders(struct vm_a=
rea_struct *vma,
> >                                      enum tva_type type,
> >                                      unsigned long orders)
> >  {
> > +     /* The eBPF-specified orders overrides which order is selected. *=
/
> > +     orders &=3D bpf_mthp_choose(vma->vm_mm, orders);
>
> Does this inadvertently prevent the BPF program from enabling or selectin=
g new
> orders? Since the return value is applied using a bitwise AND, it appears
> restricted to only disabling existing orders rather than customizing them=
 as
> described in the commit message.

Yes, It is restricted to only disabling existing orders.

> > +     if (!orders)
> > +             return 0;
> > +
> >       /*
> >        * Optimization to check if required orders are enabled early. On=
ly
> >        * forced collapse ignores sysfs configs.
> > diff --git a/mm/bpf_huge_memory.c b/mm/bpf_huge_memory.c
> > new file mode 100644
> > index 000000000000..e34e0a35edac
> > --- /dev/null
> > +++ b/mm/bpf_huge_memory.c
> [ ... ]
> > +unsigned long bpf_mthp_choose(struct mm_struct *mm, unsigned long orde=
rs)
> > +{
> > +     struct cgroup *cgrp;
> > +     struct mem_cgroup *memcg;
> > +     struct bpf_mthp_ops *ops;
> > +     int idx;
> > +
> > +     memcg =3D get_mem_cgroup_from_mm(mm);
> > +     if (!memcg)
> > +             return orders;
> > +
> > +     cgrp =3D memcg->css.cgroup;
> > +     ops =3D READ_ONCE(cgrp->mthp_ops);
> > +     if (unlikely(ops)) {
> > +             idx =3D srcu_read_lock(&mthp_bpf_srcu);
> > +             if (ops->mthp_choose)
> > +                     orders =3D ops->mthp_choose(cgrp, orders);
> > +             srcu_read_unlock(&mthp_bpf_srcu, idx);
> > +     }
>
> Could reading cgrp->mthp_ops outside the SRCU critical section lead to a
> use-after-free regression?
>
> If a thread is preempted immediately after ops is read:
>
>     ops =3D READ_ONCE(cgrp->mthp_ops);
>     <preempted>
>
> Another thread could execute bpf_mthp_ops_unreg(), set the pointer to NUL=
L,
> and complete synchronize_srcu(). The original thread would then resume,
> acquire the lock, and dereference the freed ops pointer.

(Report is identical to bot+bpf-ci) Good catch, I will fix that in the
next version. Thanks!

> > +
> > +     mem_cgroup_put(memcg);
> > +
> > +     return orders;
> > +}
> [ ... ]
> > +static int bpf_mthp_ops_reg(void *kdata, struct bpf_link *link)
> > +{
> > +     struct bpf_struct_ops_link *st_link =3D (struct bpf_struct_ops_li=
nk *)link;
> > +     struct bpf_mthp_ops *ops =3D kdata;
> > +     struct cgroup *cgrp =3D st_link->cgroup;
>
> Can this cause a regression if link is passed as NULL? st_link is cast fr=
om
> link, and st_link->cgroup implicitly dereferences it before the validatio=
n
> check below.

(Report is identical to bot+bpf-ci) I will fix that in the next version. Th=
anks!

> Additionally, struct bpf_struct_ops_link is defined privately in
> kernel/bpf/bpf_struct_ops.c and does not contain a cgroup field. Will thi=
s
> cause a compilation failure due to dereferencing an incomplete type and a
> non-existent struct member?

(Report is identical to bot+bpf-ci)

This series is based on linux v7.1-rc1 (26fd6bff2c05) + "mm: BPF OOM"[3]
first four patches.

All of the above definitions are in  "mm: BPF OOM" PATCH#2.

https://lore.kernel.org/linux-mm/20260127024421.494929-3-roman.gushchin@lin=
ux.dev/

> > +     struct cgroup_subsys_state *pos;
> > +
> > +     /* The link is not yet fully initialized, but cgroup should be se=
t */
> > +     if (!link)
> > +             return -EOPNOTSUPP;
> > +
> > +     cgroup_lock();
> > +     css_for_each_descendant_pre(pos, &cgrp->self) {
> > +             struct cgroup *child =3D pos->cgroup;
> > +
> > +             if (READ_ONCE(child->mthp_ops)) {
> > +                     /* TODO
> > +                      * Do not destroy the cgroup hierarchy property.
> > +                      * If an eBPF program already exists in the sub-c=
group,
> > +                      * trigger an error and clear the already set
> > +                      * bpf_mthp_ops data.
> > +                      */
> > +                     continue;
>
> Is it intentional to return 0 at the end of this function when we skip ov=
er
> descendants that already have mthp_ops configured? This appears to leave =
the
> hierarchy in an inconsistent state while userspace assumes the registrati=
on
> was fully successful.

Yes, that is exactly what I will do next.

> Furthermore, is there a missing hook in the cgroup creation path? Since t=
his
> loop only applies to existing descendants, any newly created cgroups will
> have their mthp_ops field initialized to NULL, allowing tasks moved there=
 to
> silently bypass the BPF program attached to their ancestors.

Good catch, I will set WRITE_ONCE(child->mthp_ops, parent->mthp_ops)
during cgroup_create(). Thanks!

> > +             }
> > +             WRITE_ONCE(child->mthp_ops, ops);
> > +     }
> > +     cgroup_unlock();
> > +
> > +     return 0;
> > +}
> > +
> > +static void bpf_mthp_ops_unreg(void *kdata, struct bpf_link *link)
> > +{
> > +     struct bpf_struct_ops_link *st_link =3D (struct bpf_struct_ops_li=
nk *)link;
> > +     struct bpf_mthp_ops *ops =3D kdata;
> > +     struct cgroup *cgrp =3D st_link->cgroup;
>
> Does this code similarly dereference link before it can be validated?
>
> --
> Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260503165024.15=
26680-1-vernon2gm@gmail.com?part=3D3

