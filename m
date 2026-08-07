Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4F88DC5AD2B
	for <linux-mm@archiver.kernel.org>; Fri,  7 Aug 2026 23:11:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AD4606B00BD; Fri,  7 Aug 2026 19:11:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AABCC6B00BF; Fri,  7 Aug 2026 19:11:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9C1FC6B00C1; Fri,  7 Aug 2026 19:11:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 521656B00BD
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 19:11:08 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 1F96EA023A
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 23:11:06 +0000 (UTC)
X-FDA: 85076020932.21.61938A2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id 2A30518000C
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 23:11:04 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HWMWqjWG;
	spf=pass (imf24.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786144264;
	b=N0RpKV52uys1uwYViud968RTzeUeUgMqJ5ZM6d6DApWWAZxuoXE6lxmFXX0sSggnW2BA8L
	tNd8yFncdCpG0Y2r3Q1mzYVjklv5lpvlOmiVoRVIkDDMz6mkRHkIUgsk2xQff5bRRsm5X1
	urtkMxygej6iupLOSZPbJl8/WvoXw34=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HWMWqjWG;
	spf=pass (imf24.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786144264;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GjEUQuQkEGtfQk63ntfLN6GvmM6krYsFGwZAiVs7jkg=;
	b=fDJb73uDPSnm8BuG4o5MNTK19wOgbClQYWA72SSQkYLrk16Ze6u3VB+/nv1TtzKD7ua4OU
	vJpqtSS/mQ1wc/wWqpPzVTIAq52V1T16drO++XHn4E00T6DqeEObYl8s2GZTf0+Zsy+NQc
	6xhd1qNZe06vwG+Ou90JjFySQ8QoGUw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 15C1E4401A
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 23:11:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3C291F000E9
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 23:11:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786144262;
	bh=GjEUQuQkEGtfQk63ntfLN6GvmM6krYsFGwZAiVs7jkg=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=HWMWqjWGaQvrvtZg4yyYY+2UhEMePhzJsXIWpCe0IpuymIFKD8Dykdgjh69pg8Yyn
	 zG535S42E8iw6Z48r4VJGV7uj3N1pRruMJCiIIDM1Neb4eMg4PlTRMFBksypPwLSjq
	 U/YkLHcJYa2vwgKmwRorQksoW535WcEPrXz9dM8Q+QWAOIqNGGs1aOwe0CCTq3WtUW
	 Mgsg9njBgpCtdRuP/qRWmuSgzVHrFXxWMQ34QZfjg64NLWsaX7+VXsYBkoJneyTkzC
	 Mw6cz0lTNb+JcntVHU5YIfFzg0od7fJNqKCrndBL0EFCT9cWGuIuU1WPfvL2pxkI6v
	 24e0hCwlLhkSg==
Received: by mail-qk1-f176.google.com with SMTP id af79cd13be357-92f03daaa97so3226685a.2
        for <linux-mm@kvack.org>; Fri, 07 Aug 2026 16:11:02 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+Rrh6VmHHf8bHEVTDai/huja4v9wGuU37ZA8In31baE3Vu5qN9iO1r0COASiKNeR8QZwZ50gXwHJWQ==@kvack.org
X-Gm-Message-State: AOJu0YxJqMkHoHlmdqcLwcs4otpQNH2Vn5JT7yzUCGkIxU6aaDLIWbmu
	Xcq6hbjUJOweq0RNgbfoe7vAwEB/Gmzpj6+l2H6r79XR5J+u5N2wrANVJOL0eUOenoplVdXeyd7
	jWhcGpvjrMVm2gIrG0baba/H3BnbNpR0=
X-Received: by 2002:a05:620a:28cd:b0:925:56bc:b8bb with SMTP id
 af79cd13be357-93648fafb5bmr2749977885a.9.1786144262076; Fri, 07 Aug 2026
 16:11:02 -0700 (PDT)
MIME-Version: 1.0
References: <20260730122304.2496440-1-xueyuan.chen21@gmail.com>
 <20260730122304.2496440-3-xueyuan.chen21@gmail.com> <anWAZ3T6Sz8bsKSo@KASONG-MC4>
In-Reply-To: <anWAZ3T6Sz8bsKSo@KASONG-MC4>
From: Barry Song <baohua@kernel.org>
Date: Sat, 8 Aug 2026 07:10:48 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4wL0fiVji16XCb37XYZh3s8RetndxPq76d=whhaxH4tcA@mail.gmail.com>
X-Gm-Features: AUfX_mxeQ7BnSG0as7KL-BR2yRh5hwB974upCVTv4g3-H2SP8bkySwta4PXLc40
Message-ID: <CAGsJ_4wL0fiVji16XCb37XYZh3s8RetndxPq76d=whhaxH4tcA@mail.gmail.com>
Subject: Re: [RFC PATCH v5 2/4] mm: distinguish large folio swap allocation failures
To: Kairui Song <ryncsn@gmail.com>
Cc: Xueyuan Chen <xueyuan.chen21@gmail.com>, akpm@linux-foundation.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, zhaonanzhe@xiaomi.com, 
	hannes@cmpxchg.org, youngjun.park@lge.com, baolin.wang@linux.alibaba.com, 
	hughd@google.com, chrisl@kernel.org, kasong@tencent.com, 
	shikemeng@huaweicloud.com, nphamcs@gmail.com, baoquan.he@linux.dev, 
	mhocko@kernel.org, roman.gushchin@linux.dev, shakeel.butt@linux.dev, 
	muchun.song@linux.dev, david@kernel.org, ljs@kernel.org, liam@infradead.org, 
	vbabka@kernel.org, rppt@kernel.org, surenb@google.com, qi.zheng@linux.dev, 
	axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 2A30518000C
X-Stat-Signature: yoogddarnu3f57j9n94znzba1819xsfj
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1786144264-160778
X-HE-Meta: U2FsdGVkX1/yJCVYFe2Bk35bovzhiTiXKin9htl5MYBTc1zsOY6TVQBALPDuNc21wTqIoZcuskRX2sxtFV7QNW1pWu1ExT/51Pj97BjEkzI2r0CWcufajFPo3o16H5Ct6iD5tQdanyl+TO2JKIk/PCYdVhgBYR3q7RdrsQ3jMq9t7IdqSLu5RVJPhtIv5A/cM13Xv1ykrQXlbHHYH6wGLtQoVcxS/UYar1ucM1orArbWcFqabt+X6FPyyDw79DiYoz9uRxwdXUugnfIPcSszzB89jwy4gxKp6VhBh03E9AvmtXcnq2UyEiPj7+ozvo87C2SjeA7CzY+giw9m+a1wSyQzFTNseL4/oRKoJ4NjuHdtWvSHjiKsjyCwDpfpCIL2ExGGmUd52SbUbwCiaAv+J9l1Sp6z2nAPum0eu+m10lTDTJC35bXVwqc3Dm/qnqsrBvmMiqdSXVPk8qTumGMFF6umutVZVOfeUcEeJWwZdLakR0Hhc1Rust6R3YtqiofKY8EdjJpGy7V3xnV3IAErfOl/MTF1z0Khya7oHaateUQbjzJBajq3GaL8SbTNwNXw6pWgQyC6MXrxLbVHJV4FHScKdtuiWRLM15d6buWLy/wHGwWCvHQrWP2veKgl4rjWARHTcdudjKzcJMI22qDbw8pj2ydXDLouCzyqiug19Kkfw/SyG9dlKDF0z3CwDlS4JLWg2gCVa2CBmE71JOkHnZYD3jyCqxjdX67x4qjoC5POAwBshvJzJl6AtElY0GP4Qx3oLehbG7zmkJJ8qpnzWqSE3e4v6EcX7NsQMqk5L7LCgKup0QnnJn9db4VnRP/jQ0mr7nOqeYBZd4zEBkH1IH+Xn4gOKKa3XS+EDGpNzsFIosD8JE6Xm20TOjn+SNs2nFmTFigE8m++JIhnJTYcW6mCtZAJdB7lwh+dP7S7U51seFIp3gbiWB3C6mxUFnBBu7wvRTAPlfhas1qjvhS
 8IWM6BA3
 iu/AWXUc7Xum2Dx3WQA3En3wnaxNiVkIctNgeGJI6QBOiwPg9oOXfaPHucfoUiNoHq0HllVXNfWxtEBjKBy6emNDR8W84NOg6lE2GG7+0IUpe80Dc0mh6r18//P7b5+cQBIlKKdomdvv08B8MRb0IRFQ2GQGLGh8hk6HSmi0WLN3xSAHI2XtNOcErbWyE9qwGNhJ8ysyl7z7Jafid9FYQLJP8lRD6nFEymxsakg8I4ceWYv7L5/zaG6mEH6Zur2fb+S8OKoxOMb+lsQ07n/VrwmopsVJ9A0VWG0p5tA8S55rdXkRnaFUSUHNQqT07opHsIequlKGko+0TNGebD3+h5yQtv7c5gy2qUOSisVf5907/g/+q1im6R87ixShfGZCsIvIE3Hv+VLT3Iem6Vmvxy8cOnessb/Wa3Lrr1f+38d0tmTh076tkn7WTNA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 7, 2026 at 4:29=E2=80=AFPM Kairui Song <ryncsn@gmail.com> wrote=
:
>
> On Thu, Jul 30, 2026 at 08:23:02PM +0800, Xueyuan Chen wrote:
> > folio_alloc_swap() reports most allocation failures with a generic
> > negative error code. Reclaim cannot tell whether splitting a large foli=
o
> > could make progress or whether there is no backing space at all.
> >
> > Keep the global free swap count and the remaining hierarchical memcg sw=
ap
> > margin as separate inputs. The memcg charge path reports only its own
> > margin; folio_alloc_swap() combines the two layers when classifying an
> > allocation failure.
> >
> > Return -E2BIG for large folios when a smaller allocation might still fi=
t,
> > -ENOSPC when no global swap space is available, and -ENOMEM when the
> > failure is not helped by splitting.
> >
> > For early large-folio rejections, check global and memcg swap availabil=
ity
> > instead of returning -E2BIG unconditionally. On a memcg charge failure,
> > swap slot allocation has already succeeded, so use the remaining memcg
> > margin to decide whether a smaller charge might fit.
> >
> > This only refines folio_alloc_swap() return codes. The reclaim callers =
are
> > updated separately.
> >
> > Suggested-by: Barry Song <baohua@kernel.org>
> > Suggested-by: Youngjun Park <youngjun.park@lge.com>
> > Signed-off-by: Xueyuan Chen <xueyuan.chen21@gmail.com>
> > ---
> >  include/linux/swap.h | 16 ++++++++++++----
> >  mm/memcontrol.c      | 32 +++++++++++++++++++++++++++++++-
> >  mm/swapfile.c        | 32 ++++++++++++++++++++++++--------
> >  3 files changed, 67 insertions(+), 13 deletions(-)
> >
>
> Hello Xueyuan,
>
> Thanks for the patch!
>
> > diff --git a/include/linux/swap.h b/include/linux/swap.h
> > index 0544b2ec4c56..7d12058174ae 100644
> > --- a/include/linux/swap.h
> > +++ b/include/linux/swap.h
> > @@ -509,12 +509,13 @@ static inline void folio_throttle_swaprate(struct=
 folio *folio, gfp_t gfp)
> >  #endif
> >
> >  #if defined(CONFIG_MEMCG) && defined(CONFIG_SWAP)
> > -int __mem_cgroup_try_charge_swap(struct folio *folio);
> > -static inline int mem_cgroup_try_charge_swap(struct folio *folio)
> > +int __mem_cgroup_try_charge_swap(struct folio *folio, long *swap_margi=
n);
> > +static inline int mem_cgroup_try_charge_swap(struct folio *folio,
> > +                                          long *swap_margin)
>
> Am I the only one that feel this returning argument is a bit ugly? See be=
low..
>
> > +/**
> > + * mem_cgroup_get_folio_swap_margin - get a folio's memcg swap margin
> > + * @folio: folio whose memcg margin is queried
> > + *
> > + * Return: Remaining chargeable pages in the folio's memcg hierarchy.
> > + */
> > +long mem_cgroup_get_folio_swap_margin(struct folio *folio)
> > +{
> > +     long swap_margin =3D PAGE_COUNTER_MAX;
> > +     struct mem_cgroup *memcg;
> > +     struct obj_cgroup *objcg;
> > +
> > +     if (mem_cgroup_disabled() || do_memsw_account())
> > +             return swap_margin;
> > +
> > +     objcg =3D folio_objcg(folio);
> > +     if (!objcg)
> > +             return swap_margin;
> > +
> > +     rcu_read_lock();
> > +     memcg =3D obj_cgroup_memcg(objcg);
> > +     swap_margin =3D page_counter_margin(&memcg->swap);
> > +     rcu_read_unlock();
> > +
> > +     return swap_margin;
> > +}
> > +
>
> Will is be good if we just always check the margin use this helper
> on alloc failure? Alloc failure should be a rather cold path I think?
>

The only disadvantage is that we don't get the margin together with
the charging failure. If this happens infrequently, it may not matter.

