Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CF8B7F8A14D
	for <linux-mm@archiver.kernel.org>; Thu, 16 Apr 2026 10:18:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F30A06B008A; Thu, 16 Apr 2026 06:18:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EE0EE6B008C; Thu, 16 Apr 2026 06:18:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DD0546B0092; Thu, 16 Apr 2026 06:18:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id CD2DC6B008A
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 06:18:38 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 622031B8A34
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 10:18:38 +0000 (UTC)
X-FDA: 84664019916.10.ABE4484
Received: from mail-yw1-f169.google.com (mail-yw1-f169.google.com [209.85.128.169])
	by imf24.hostedemail.com (Postfix) with ESMTP id 6F51C180004
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 10:18:36 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=fHzIkmdC;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf24.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.128.169 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776334716;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pheiDINOAwUsYN7vopid31AhY8r07w9KHuqWqrAWou4=;
	b=HL/3DF/ea6TuTPW6Phgbq3hARTh0UMoNdY3QqTxSiKMN84lwnWHkiJqUqD//VHcMxo+rq9
	PUL1ph9bo6pmZV1BFyDW3vUF10oEBqdCj3GpYB6vTfbzHSuxr7OC1HxxcdcxNi0snBcJGI
	Wbb42ULChlJP49s9fqgTNX2FbmRi0MI=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1776334716; a=rsa-sha256;
	cv=pass;
	b=3l4Scv1f9QsuZDPeSTCM3GQLfxfibp3YfZ6i96/vVHkaN8SGYbdr0W55+6dnc9JYRWO6KR
	GJNnMTWc64MGTETAlg21FQrbQj9k4CuiMKE8eR2AWFppsMfh3ktSa4K9Uv/ejSivgjdH3i
	xJaeDIIWPvdd/cqadCbVcM1OWSz99jg=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=fHzIkmdC;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf24.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.128.169 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-yw1-f169.google.com with SMTP id 00721157ae682-7b41fdf9de2so29002567b3.0
        for <linux-mm@kvack.org>; Thu, 16 Apr 2026 03:18:36 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1776334715; cv=none;
        d=google.com; s=arc-20240605;
        b=Bw+6864JJqagjlqKIe9+rSGrY2WpGjG+u8T0ifQbFk60Gp6/flkpSW5uL9JJe4hTV0
         Y9HyqGfsxI88WjAsb6Nhu7XM41rfCqgGGE/HpU4KIJ4lGlRS7d6I5b05P24HwLnxD0Wh
         3H8FS4FaoieYLUhnQgaAeaIyPJesExenoctdm8BrAsk+3rNjYpg51ZJZC6HFF/cqhFRl
         0MJh9/4s/YPEyRMgxp0l0F+CcnVfZz3IUSCfGWrcjKbcmz/52vPeJ1rVhyYe/iJrLIGX
         QsY6mi22Zr5S5HMqrDYe2rUEUeDeCRFAic1pbc+yT5ptBj8N9/3IF/eILER8YFKz3lAg
         b5BA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=pheiDINOAwUsYN7vopid31AhY8r07w9KHuqWqrAWou4=;
        fh=QVz+8T54OH6ixlF9PCYpZuMdydHzGZmjOCJN7UGQ6TQ=;
        b=JMylseWxca3is1oj0G77ZW5wa/srjMhL9xHgI8F9DERgxlKAlwaoUD950Wev3fZ8te
         OwABcYxl+JuL/yx0SGa7Vy5u9EU33zzOBvTmheQ6z3i6UvKxTfwlE51U/u2tCN8OdZlT
         g8oryHxS5rfuSWq3EaYS4bR39HIq9m7u1zNarN0gXELmocB0Ve3ls7ENVN8nJCq+TtGp
         a1KBvv7yt1fPPuz2AXCvuUa15OV8+qButEcANA+l7MakaULpWVet4DLvVraYlIfkGdX2
         c14d+ZNI02N1kC9EYubHZNjEPNWzpFBZDHSdZ4UuapezGNpgC8Bwtkbz43WBWn2aK9e4
         zAwQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776334715; x=1776939515; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pheiDINOAwUsYN7vopid31AhY8r07w9KHuqWqrAWou4=;
        b=fHzIkmdCd6J5QeqrwaMBUwikmItozWztM9Fd+OCFZk5FGP8QswCQ1ERRNlmbJPF7z/
         kzo7gDmHSo7K5YCx25SGipt7CueWfeOwZHgY7njh72xOQXaRFZPxMqWWkzyPPLW/NQ6T
         m6jzHgT8tmtZSZ8p2wErVBo2XXwu5xo7C70z7zNHsZIgMJzJYJyijvPPMinB/MpGOyR4
         WHL1OuMpxwFSzok0kA1yiyrMZ5etnte8eMlJ8QGQcPUT+JRd6pTJR4sjpFGcSfkJcDtJ
         X1FsrrCF1aPJtnY338VZYCTZh22i8F+U9t5k45dmBFdBG4vVkBHtGoXR6ckGtkd1mNkJ
         nCrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776334715; x=1776939515;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=pheiDINOAwUsYN7vopid31AhY8r07w9KHuqWqrAWou4=;
        b=iRl1ytCGFqzHsbSumyPeAf9BG65eFwELi+LY8uqulSVPNfdNO/Z58By1RmIiyLfThO
         40hUShBvaS9ZKJ3dp0M16MYW9iITQAJZo2W+47YLSAcw5td3tZDWW8t33ehJQHiXmJbL
         UOCKUQrV1zeZDQGcvPF/qxzoiEMkEh1Ma17mHuLwLDhfwsF1nL7Jkl5oV6BMs5rxOxmO
         LB0a29wbeFfvIWbN23rHHKdtHgpQuE67GFVp4tzc4FiGaiLHrlHpn07Gd1rzNS/CWay0
         hxVubsK5nWREZmSFu1U/EGu0Q9NC2nmM3SjoxFYnvPATP10CfCfVb5+O7ZIy3IRdaukK
         yhsg==
X-Forwarded-Encrypted: i=1; AFNElJ8geLRccevo+96FGmBpawkmF6Qw02yaPOhEM1pzAQSf6ZrytY9+0uMPCacDDaWoxZLU/H/THYiEvg==@kvack.org
X-Gm-Message-State: AOJu0Yzs7bLSVxL/+P5IUFFMuAQrlXJpjb8gjL+S0nxNu7tQsORyRa9s
	vQDmECGJu7HLbky/iPMlzYcDk3doI95mNpXQjTtKCOHfxoMBLu5O4KdWO39UDI4D9cxW1PwBgkS
	u2aNUQqbCLOXs20dwhh4TjW10mX1WHyg=
X-Gm-Gg: AeBDiet/yJ0H9PjpTAc9HD9AghatdzETAsmoumOlW9TNdGIssjZaUHJcA8tkrlPMRVs
	0vP+jlXIizpeO2hsKpjIGvbEjAfIziX0WTTxlplH9phj4tq7fvYlDU+LzZAXJWaT9nsoQjBki2I
	6w6SdF+0+ALeLQ2f6t7Jy4gmrgLQoilXa9FfxZWolArxLYrDo2gl7Ef3bcGUZaFegKryX2TMCco
	2j2DJP42kyFIGiBJWFZYNbx5pUSnxQDgcJlOb2IMu7OgF/3oUjmqiIONGA8sFnJ3pWYLaRr0WVA
	SiDhtZnIH6jaeT2kh9PbBe/sug==
X-Received: by 2002:a05:690c:c513:b0:7b8:338d:7d79 with SMTP id
 00721157ae682-7b8338d8083mr43597987b3.30.1776334715394; Thu, 16 Apr 2026
 03:18:35 -0700 (PDT)
MIME-Version: 1.0
References: <20260413154438.396031-1-ekffu200098@gmail.com>
 <20260413154438.396031-2-ekffu200098@gmail.com> <ad40-uVPKtaP6wuw@kernel.org>
In-Reply-To: <ad40-uVPKtaP6wuw@kernel.org>
From: Sang-Heon Jeon <ekffu200098@gmail.com>
Date: Thu, 16 Apr 2026 19:18:23 +0900
X-Gm-Features: AQROBzCuLgCaPOXeRciUhYYsIsIaleERiNMswtAhG6ED3VpHFIBGRhjA5i5QxkQ
Message-ID: <CABFDxMGbqDscOSMWKhPE2RT205=+0v_hWiNdFCmkTEBssN=0AQ@mail.gmail.com>
Subject: Re: [RFC PATCH 1/2] mm/fake-numa: fix under-allocation detection
 logic in uniform split
To: Mike Rapoport <rppt@kernel.org>
Cc: akpm@linux-foundation.org, djbw@kernel.org, mingo@kernel.org, 
	linux-mm@kvack.org, Donghyeon Lee <asd142513@gmail.com>, 
	Munhui Chae <mochae@student.42seoul.kr>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: b1mx9pyta63n87u79cdq9azufg5dzgfi
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 6F51C180004
X-Rspam-User: 
X-HE-Tag: 1776334716-72011
X-HE-Meta: U2FsdGVkX18KOFVpFOc2YSyz/JDdnOsolesjcrupUlSbQxdYorbQCmHXPWUFRetrkk4zbFlcsG3RPsRrP82MoDWyjzmxuNH8hTgN+x4X97P+kxYXvYfyGqQ2gHanGifqcor0oe3QV4/ViCECxRoJPpIMg/oY9sRIWoUivNU03eVGnw2vho5KxXevo27KK6Q/fSBW6q2oXEig/QI3fTySpKntiAfgmho2Y5niyENrrDAw4RyI8YVVVrISAOT7RA93Z0IKtkfXqUcy77ECAL2xzfmcuglYkGd6VAs45rX4BDBrfDoPCYSiXmAvhbjzgUEHiqXT88igdaRMZtKtywng8Eb2QkaHdPeJ72TT4eVlfpKUy6fsIw62zZHstjFGuNX4JpM+G7jI1ilZmQUA+oI4aNuGqsajAnhFolRv/ap0ug98c8PgaoLAn8cflm6QU7OV0E/i+mGNz4q6rH9Uqua/m/r1SmLQ+25WuNXxWEiq5PaH9cR9zS6GdH0SqqMMzHPrtAgFSjQHgrlmh1KweDPdjKyZWgmJQy27UbwNJ+qDcNOfnA3NzGZEoX6tKxAgk1lMQzHZwjZIgsuo+d9Cg88/pmygaKFYv6ct9GJdBjcMTVYp3b/92o8qf6mCYXxm2KHfEAxRqi6Jw4JDDh2CMTT3Ej4NrFFD+RGYmsmITvv8GoW4ehWj0bRFzGDmgbNYRzeUq9ZUvlxMclrbddakTOlIm1dAC84/ZlrORZcDN9ytUPynfk/ONAW/0Z74vaXgS0eOl9MkyNG9Ei2vuD1A4URDJ3pwScNzeq9lBrO6eSBOp6Dfehzo7Gh0AaWoitOn+seDZBXwidkWKvzO5kUXsYRUTGV1X+cjJRDmxDQAXbYE+5XvgNPjkl57rQIVgMDTI0C5ROiOcmGQcscS1JN5HFOFzFr23dbXQmBfrG3oJGnNredJ4JKN1MayvtMvxnloJPxAE4ZYLtN5nZcfQbpUen9
 f4LgZAW0
 k8mg2GqRz6kNdqNfbiZF5Y+NE6MD4uWHrU+prdpgyyEBr55ykq+0rF6K1f09Y9VgkNADt8riAJLaRaMEvKiJgWdEtjEII+1JDvQ9pcesmHOf8VDnU1BaGFbkpWjyWOWjc6gQpkynjBT7qZ3cmR4pmerXfBt/3/XbZZlK8O+Aa9aiUWPG8dUo4UrsP2Q/Ch9gRlbs9IKe+cTuR/ZzT/nWpINjDS22mh62vmwBEpb+ufT42pIpsVZPttGHnVCzYyYXnRnfK8DaOwaeFFokA4dh6g0pNKLFXHVbg0HtPS1XBVomMuJ2K4a0AkqItrx11dqf/sTNwimzwkaxQEzQKkwao28Rz7L5Egs532L+dYhYHj+4OM7D4h3fHGt778IQ6XzfzFVlGEpSaCq7L7qqJBFLK1A/7VvrvmI5idr9Hxp0+EByMljQGnUJPMHbQxVT/0BXHV4oJ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello, Mike

On Tue, Apr 14, 2026 at 9:37=E2=80=AFPM Mike Rapoport <rppt@kernel.org> wro=
te:
>
> Hi,
>
> On Tue, Apr 14, 2026 at 12:44:37AM +0900, Sang-Heon Jeon wrote:
> > When split NUMA node uniformly, split_nodes_size_interleave_uniform()
> > returns the next absolute node ID, not the number of nodes created.
> >
> > The previous under-allocation detection logic compares next absolute no=
de
>
> I'd replace "previous" with "existing"

That's good :) I'll replace it.

> > ID (ret) and request count (n), which only works when nid starts at 0.
> >
> > Fix under-allocation detection logic to compare the number of actually
> > created nodes (ret - nid) against the request count (n).
>
> It would be nice to have an example of memory configuration and
> numa=3Dfake=3DnU that demonstrates the issue.

Sure, I'll add it.

> > Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>
> > Reported-by: Donghyeon Lee <asd142513@gmail.com>
> > Reported-by: Munhui Chae <mochae@student.42seoul.kr>
> > Fixes: cc9aec03e58f ("x86/numa_emulation: Introduce uniform split capab=
ility") # 4.19
> > ---
> >  mm/numa_emulation.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/mm/numa_emulation.c b/mm/numa_emulation.c
> > index 703c8fa05048..e7f856c8f2a1 100644
> > --- a/mm/numa_emulation.c
> > +++ b/mm/numa_emulation.c
> > @@ -416,7 +416,7 @@ void __init numa_emulation(struct numa_meminfo *num=
a_meminfo, int numa_dist_cnt)
> >                                       n, &pi.blk[0], nid);
> >                       if (ret < 0)
> >                               break;
> > -                     if (ret < n) {
> > +                     if (ret - nid < n) {
> >                               pr_info("%s: phys: %d only got %d of %ld =
nodes, failing\n",
> >                                               __func__, i, ret, n);
> >                               ret =3D -1;
> > --
> > 2.43.0
> >
>
> --
> Sincerely yours,
> Mike.

Thanks for your kind review.

Best Regards,
Sang-Heon Jeon

