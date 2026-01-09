Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DE6F4D16805
	for <linux-mm@archiver.kernel.org>; Fri,  9 Jan 2026 11:02:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4CC1A6B008C; Fri,  9 Jan 2026 06:02:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 480616B0092; Fri,  9 Jan 2026 06:02:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3A3196B0093; Fri,  9 Jan 2026 06:02:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 287416B008C
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 06:02:49 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C49F7140432
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 11:02:48 +0000 (UTC)
X-FDA: 84312137616.11.C982146
Received: from mail-qt1-f179.google.com (mail-qt1-f179.google.com [209.85.160.179])
	by imf25.hostedemail.com (Postfix) with ESMTP id CB6DEA0012
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 11:02:46 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="yRstko/6";
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf25.hostedemail.com: domain of smostafa@google.com designates 209.85.160.179 as permitted sender) smtp.mailfrom=smostafa@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767956566;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jzCiSHIGOYpa7t9zzF/wcFfKhZV6nLFk0KAKRqVw7HA=;
	b=DB/HiSPvRt4UxQPMslm4dYEMgJsW/9i0yLObXNlGMrcZFNDbi5TnZrPm932dPi5EHUa4dy
	R5yVGgOliqb6YcA9HhoK4TK8fhxCzO5MVe/R7ITaodY1mrLhlxd0XP1+ZDhAaq2dpKl/jS
	4pZb85+Vrw0RwHo96JK7hU3AbQJXp8M=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="yRstko/6";
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf25.hostedemail.com: domain of smostafa@google.com designates 209.85.160.179 as permitted sender) smtp.mailfrom=smostafa@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1767956566; a=rsa-sha256;
	cv=pass;
	b=HirN51ciuLe2+8+qw2myFPhGjreOkSaRVGPxWh1XpRAqBhJp6WtE4hhaEC4wmP/Ab56bCY
	zrhXog7JS14FeEe8CPfoilojYe7PG2yI+5le3IuE+rWJdjPjKRYocNwyyZ7ZOI8JadJPOM
	fmGOsdbwr27auh8rsZpKeh4d1mOd53o=
Received: by mail-qt1-f179.google.com with SMTP id d75a77b69052e-4ee243b98caso269211cf.1
        for <linux-mm@kvack.org>; Fri, 09 Jan 2026 03:02:46 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1767956566; cv=none;
        d=google.com; s=arc-20240605;
        b=BxgVIO7os9BICMt4zdfuJqPYfMVO/ZSPaf2BC8UUX/TFxleDDiYBaqEVgqM+aMf19/
         qjDBPlJHWRqDOwTHIKJSEmm8CqPhF8K1ZtYvpT3TdhIgwcqYOCRJYnEdjArmdjbikiXP
         kUHrPdeO2rTZlRQB/7q6KVNfBNI8TDHx5bJPg313XkJ+yf9P+zi4Uogh41EnpylyuuG0
         ATHRoH8L5B6K4mgQZHjdyURH15DhAijBKC38t5h8f2kTPmjj+Q+XTEI0iFz9eAxSvQBp
         kVHt8KqS8ZhFsGXf6/UYctn8Yb26lBJwGFNWRRa6AEoqQMrUWbIMos6LeiLMIGDcnRU1
         YFXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=jzCiSHIGOYpa7t9zzF/wcFfKhZV6nLFk0KAKRqVw7HA=;
        fh=b2KkvOQEi44Nk7jZCtLBKdwGJ5V/mLLSFnsz/xOt7zY=;
        b=T+nyKHoxjiIfOIr8z6/bUCjVS0tgsuG6dgZ2PLUEUo3ynTQgujY9rrBRYuXyUmLRpB
         7plwffKbupmbn1mgAL5V8eguRq/r8azmoNh9H8jVeA5BI0JtuKT2Dj0/P7PXyPTwU++j
         LI3NkkXU+g2m90n00KpJvdvkp+1pjCifc5Mm5e3GQ959Yv85tsBh08nYRMTbj/5kYzlN
         77TiIzt1xHrQu2dYtfXZej2i8aXjtQYHGdo8oelBSSdhO3kjdsRj9Sq+HwgJRaSSeVtt
         8gdFh/H2tGiVLka8NrAYyvktcwj1FKH8OXS94wKrBHUmYd8tmIaI+t0rtq6zTr/ipNGK
         B7fQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767956566; x=1768561366; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jzCiSHIGOYpa7t9zzF/wcFfKhZV6nLFk0KAKRqVw7HA=;
        b=yRstko/6N6oq6z0+F2GbONgojEzl7k9zxEL+lmGrkPIgOhB4fkrLq+5MUjjxlZwqOy
         6R4jcsLe5gOPERNFBs0aIQ/7taXUN8X5Xoz6mOPVi1gaWxJrdEfGFU6Oxv02QHCIjh3U
         kzENXOX9ncnMVqy6LXJpHbNUrOpg/fyYaONga1rSWaL+84c5ksNe0gSoJuyi3A8V6qCj
         kphS9HOHJnUPNab5GH9HmBCazjnN3W2ElPlOvbbDbTZsCjBdet51IY/L3TcYBfwfCHOF
         YN1lw2nsibTMiTtLQIOvFcTUo57ekxLuJw2styKxwXyX4nmnUOdjIa1LfF+zeypb8J0+
         QdJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767956566; x=1768561366;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=jzCiSHIGOYpa7t9zzF/wcFfKhZV6nLFk0KAKRqVw7HA=;
        b=cvQkI4nkgrSTrlHseWLNnB1yrj9+9mPHeZNNeFkPrlN4Mur1azWEz9YXtkOOh/BuIw
         87OkoyxccDLjZ98PPfMvevi2+bLue3fLl774cAogQV7vDh29hkSlCkWZN+YdpF4G20Vm
         IQiJsTDy05W5tYZ08v1Mxat9/3ulQlBMcVvBA+k56HAxjV0OvJrkk6h1oRRuxZpWfXg9
         d3Ti05UtRpGrJXlN6uPv+o0pQ1FZKnoZeu2HrTWIhoHuNl2om5bAj8QYM3JNWnCwafvH
         jswn3wiinUWpQIS0ztqzDpUH2xfU15nIVorVs0oMxQhohilACiLvyMe0XEpFKLNdrGZJ
         g9Bg==
X-Forwarded-Encrypted: i=1; AJvYcCVCZUFe0kc2cJRp4IhI4HFDuExH/0Gi81LBbyKGpYDtKHxn5cFVmKaHQE79xOWr+NY7n1akEyo0PQ==@kvack.org
X-Gm-Message-State: AOJu0YwUMs5IPG8D6/3wo3cKTlfV/WT6a/CGgQ9NwwFuZhX/7QIkXlOl
	EEOxFCMluTGddkTzLfDi6pZQxYkECn/j3PrHDOgWfI3eQcVJmdSqGQzibpQwIoBuIPs5c7DA88m
	oLl25I/0DXzD7C3q1Y1QbDYGDentGLIrXSMvbsVDr
X-Gm-Gg: AY/fxX7Ce8gSC5k6Ey8E6zRoFgqTClJ43SgpXjxXpwodOJ4uO9osaseCZ2y8RJrZVfU
	St/5Qi9WPub03JPnWh0nEuiJ0bZrwoDZP9AXhAtg+N44X0Gz6Bpmfwl8bp3bWQAePKbXvNHPHCS
	lxEWhhdVO0TrX26WOSqiLecjfXY1ifLzy/r3DSjkd/eJfOoYLdxrd3RgyYISe4eP+Dh+VjmlwyG
	w2iMbCrHXQxIsB7zQYHXqlBzvM0rT42YsOwR6RLHGYt72NZNkp9/9VNppTpDP6EiAtcNcJTanwG
	KoP7HFBppbJrbGuE6K7H90LP88H1m7IYG7nNGnZ4
X-Received: by 2002:ac8:5d8d:0:b0:4ed:70d6:6618 with SMTP id
 d75a77b69052e-4ffca3899e0mr9525541cf.10.1767956565345; Fri, 09 Jan 2026
 03:02:45 -0800 (PST)
MIME-Version: 1.0
References: <20260106162200.2223655-1-smostafa@google.com> <20260106162200.2223655-4-smostafa@google.com>
 <aV56BWisUQTMK2Gk@google.com> <aV-PvBqQ0Ktiha8e@google.com>
 <CAFgf54o4Ja7jQwxo6XyW+JaT+aUuj3O2dvLqOTb+YSVCKTdvyQ@mail.gmail.com>
 <d6236413-7385-45c5-94ad-8b0f2007f1ac@linux.intel.com> <aWCviSCK7IBddLTn@google.com>
In-Reply-To: <aWCviSCK7IBddLTn@google.com>
From: Mostafa Saleh <smostafa@google.com>
Date: Fri, 9 Jan 2026 11:02:33 +0000
X-Gm-Features: AQt7F2oqTpF_L8hxvj3t4iE4ZAXrurkscrS9S6zaVPP7N-l_qQbRFrZajZBoJoU
Message-ID: <CAFgf54quzFPtfXN0Tw5qO2HU0YExN3FBHK3uG2yiLxkNybfHfA@mail.gmail.com>
Subject: Re: [PATCH v5 3/4] iommu: debug-pagealloc: Track IOMMU pages
To: Pranjal Shrivastava <praan@google.com>
Cc: Baolu Lu <baolu.lu@linux.intel.com>, linux-mm@kvack.org, iommu@lists.linux.dev, 
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, corbet@lwn.net, 
	joro@8bytes.org, will@kernel.org, robin.murphy@arm.com, 
	akpm@linux-foundation.org, vbabka@suse.cz, surenb@google.com, mhocko@suse.com, 
	jackmanb@google.com, hannes@cmpxchg.org, ziy@nvidia.com, david@redhat.com, 
	lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, rppt@kernel.org, 
	xiaqinxin@huawei.com, rdunlap@infradead.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Stat-Signature: 4y5pz3fa3ddtn6dqs7mngu3rmrjtarre
X-Rspamd-Queue-Id: CB6DEA0012
X-Rspamd-Server: rspam04
X-HE-Tag: 1767956566-985576
X-HE-Meta: U2FsdGVkX1/YXqW223uc4oZy8pGK38v3geZVFkpt0XLZ58rmy4OpTgnMVWSRIy0D2gAuwCMzGUlQ7jZJEAEU2ixT6reZtA/toHP8Pm/t2/8h+BbZe5r2lbFcvjXQlkyKScjIF2PUUUWdZmWPk64v7eKhANBBeIGbR/LsbnnEH4aq6qnRaftOYO9blMFlZaiXxmAbGtopVWtoM/Ku4KjeK0AghEdxf3PhpxdHrjpRnpuTMT+WytQRRlt2obkENYaxtdyODPmqntMz9IgYUWi0GULNIMqWlQWH6Jqv/7VWlsE7Cy1YcI9hQ7F0kh6fR2ZxRO9oJ5J30uXL8I85SL4Pa5GB7Ce59Z4Oap/hxCbQ4xLoEIGKqPVEXdP3hh9m7fQFSUbNnnLNtauE7kv9ISAr2uU4245cnE34A2OkIcNGXaCntjVMC2JWWhHuK6lMqWl4CUTZJTThU6D3Eyg7VCi1dcX4x3XZzuXyy1i9qlHC1no5uRFpoy2KUKLMEOE8D4XKvbtm/t+X2nGYApbBg94eiiM3/M5OIB03I3JL1IQZDDzg54cSn/6WBHCluPbhjDyFeu1r221iTu8KC8Ib4J3MgZWJcJpbwr4lJIbPiZk4nCAEpKKB4YJXme0KPgtmvhheOLkLBEgT2pFqQTzXS9LP7xCdlvvZPu1igNx7004aUZxVOlAemgXXyIW4UZg4zPUZE/2jvYu7en/xAKOaizjqysDO23LTEIoiLiQ7n2OKXwOdae2dz3PE+7xRsDZR0Y3H/3BG0/lcj/3a3cLChc1OqmS563Sy2n860yBQG2LewFlcWR3tYeA+E7qTPzMTSrZ0i8VH8l5xdt5BJyKafdafy0bpSac2zzjtLPwEKdhIJCcq8/F/RkerWfwL6EvgRa08QtxLz5rhQ7C9VR8Xz3NiVIedkVFMwdK+dvHrBnCC0vFnbij2J5BlyL+OSgVcM1EtXJTjSBEbHvvL/AVEiVw
 JHv5loDr
 w4HNh53cra4Yj/8Js59IHuZBCKd6bhvqaqMhB/Npm/GLHVEdkQHSC6FQcmDrU+B2Anxxg8I1nuR7nlR7BEA06jtBqSnPvtYE7ZshaQZVLOHJ1YPKjrW06o6AVmeFvQJhAFOAY1bGOiUhPlqXGmG4D4GajM2KSfh7as3fLfiG1atY9rye2rSXeuiFr72Gj+tBIOb0Gkhqf95ykeTySkI2mOqsT82ikKjPq2dgHCRPFZuwqZmVktbjpIkWugjV/6ANc5j5UcEE4wLDQZ68=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.009233, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jan 9, 2026 at 7:34=E2=80=AFAM Pranjal Shrivastava <praan@google.co=
m> wrote:
>
> On Fri, Jan 09, 2026 at 11:28:32AM +0800, Baolu Lu wrote:
> > On 1/8/26 19:33, Mostafa Saleh wrote:
> > > I have this, it should have the same effect + a WARN, I will include
> > > it in the new version
> > >
> > > diff --git a/drivers/iommu/iommu-debug-pagealloc.c
> > > b/drivers/iommu/iommu-debug-pagealloc.c
> > > index 5353417e64f9..64ec0795fe4c 100644
> > > --- a/drivers/iommu/iommu-debug-pagealloc.c
> > > +++ b/drivers/iommu/iommu-debug-pagealloc.c
> > > @@ -146,16 +146,12 @@ void __iommu_debug_unmap_end(struct iommu_domai=
n *domain,
> > >          if (unmapped =3D=3D size)
> > >                  return;
> > >
> > > -       /*
> > > -        * If unmap failed, re-increment the refcount, but if it unma=
pped
> > > -        * larger size, decrement the extra part.
> > > -        */
> > > +       /* If unmap failed, re-increment the refcount. */
> > >          if (unmapped < size)
> > >                  __iommu_debug_update_iova(domain, iova + unmapped,
> > >                                            size - unmapped, true);
> > >          else
> > > -               __iommu_debug_update_iova(domain, iova + size,
> > > -                                         unmapped - size, false);
> > > +               WARN_ONCE(1, "iommu: unmap larger than requested is
> > > not supported in debug_pagealloc\n");
> > >   }
> > >
> > >   void iommu_debug_init(void)
> >
> > How aobut
> >
> >       if ((unmapped =3D=3D size) || WARN_ON_ONCE(unmapped > size))
> >               return;
> >
> >       /* If unmap failed, re-increment the refcount. */
> >       __iommu_debug_update_iova(domain, iova + unmapped, size - unmappe=
d, true);
> >
> > ?
> >
>
> That's nice, We could also print the message as Mostafa mentioned, like:
>
>         if ((unmapped =3D=3D size) || WARN_ON_ONCE(unmapped > size,
>         "iommu: unmap larger than requested is not supported in
>         debug_pagealloc\n"))
>
> An explicit "This is unsupported" warning makes it clear IMHO.
> If a driver triggers this, at least we know the sanitizer state isn't
> supported.
>

I guess both are fine, the WARN points to the line which should be
simple to deduce the cause anyway.

Thanks,
Mostafa

> Thanks,
> Praan

