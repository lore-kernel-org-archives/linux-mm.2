Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A88B4CA6007
	for <linux-mm@archiver.kernel.org>; Thu,  8 Oct 2026 15:07:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7219C6B008A; Thu,  8 Oct 2026 11:07:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6D2376B008C; Thu,  8 Oct 2026 11:07:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5C2DB6B0092; Thu,  8 Oct 2026 11:07:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 3005D6B008A
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 11:07:00 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A7B8FA02EC
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 15:06:59 +0000 (UTC)
X-FDA: 85299786558.15.0444505
Received: from mail-yx1-f51.google.com (mail-yx1-f51.google.com [74.125.224.51])
	by imf10.hostedemail.com (Postfix) with ESMTP id B8E93C000C
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 15:06:57 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=oKvr1YC5;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf10.hostedemail.com: domain of ekffu200098@gmail.com designates 74.125.224.51 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791472017;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7nTNII3n3G87GHhdFtHT3hqd10T6INaV8G3FhaWt9A0=;
	b=VrY35SaRbQycsrd6JdZEVg4RUGL/6AF79eZ74iSQG4wZtQcOKUuYkOD6mp9efqOzHnxTcn
	Vj24vF/gkQuwXY1ULaxmZTYCohbvKjPfZxXrHxJHl7DiS5zr5sSrecdSfz/kBY5D06bKa0
	uLPeSlSTEC1bBiZEK21WnhiheCDBn24=
ARC-Authentication-Results: i=2;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=oKvr1YC5;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf10.hostedemail.com: domain of ekffu200098@gmail.com designates 74.125.224.51 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1791472017;
	b=q5KqVszZl2J6ljNtsw/gQ/heWcxqV+frFC7ECJJn0fIol0d4d3sU4RzWYiJqPbqTwkIgVU
	7/Yd0g+L+Yb7QsJ7VmGNxe/vbPUKaochdqcwcwm9NEgDT6A3L+DsjfcEfbn5wbxGL+RYOa
	YXMLdvHTCFa4E9q9mwwBfSkM5/7+rc8=
Received: by mail-yx1-f51.google.com with SMTP id 956f58d0204a3-6740e7ae219so2837496d50.1
        for <linux-mm@kvack.org>; Thu, 08 Oct 2026 08:06:57 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791472017; cv=none;
        d=google.com; s=arc-20260327;
        b=fcJLhIGOZiiMKW5O/srcwNILhvvt1gaU4ZUPnf8fj0sD4cUJEWpYWpd+uJzW4feOdu
         FGynpH+9tSZ7VrMoEHHWh2mVICftegVwkbrI+rP/woqEoY9FxEYNLL92QyzEs3ZKlzW7
         8aUP8smsmyxbf1QQrLq1QCvTGMqjKIm6ACNqmuy9qsg/o3G7g46wgG/G7jgqKUs8S2B1
         2VYndU6n3R/mZf6FHTs9eZoG04peD1MQh7opfeCLKvPxka7vs3cIKTqpWk+d5rUpyjCN
         b/aCVZDXGZ4O+LElhVO4JSS8LGCpEt9T/3BRV+kap5et+BAe1ybtQMaY8FmxLpoEsosu
         bLFQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=7nTNII3n3G87GHhdFtHT3hqd10T6INaV8G3FhaWt9A0=;
        fh=3p+aCoaT7eRINQZxcHUagFNwvkKm60VbwPp74G8JZco=;
        b=hJ2AcDUOU1MmKTumct42zFe+WzAfmogCB0fefeFrl1zuMmGXUNUEpPQi0svsmDE1ZQ
         0ezCVA1OUIZQK0LRCcgDslE8aEp1ryi9jVCz+nGtGya+a2L/586KzR4Yt9Muhym++egi
         cMUXEYN3W3zExiC527DOhZ2U+NuntpTwLN9ArgiejjwKAJct3sNc+GUjaKu43e7jRgF+
         N5RcI+POzobdcvYkzLjVGLc175bleVvLoTtcHUgvEyTDrS4PqFqm3RN9JWPV7vQwioJB
         aN42l1DrzUlR43VmYav0hwUYZaigEj0cJ8HmabrQLizOu/t+EzUk6sHhIc8aNkAIMy86
         djdw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791472017; x=1792076817; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=7nTNII3n3G87GHhdFtHT3hqd10T6INaV8G3FhaWt9A0=;
        b=oKvr1YC5K6qoJY5BeNdXZeNO4HevKSty5jKZ/72rblWru/GHuJFTgjE9mYMxc+lGVU
         1bOFbM46S2z4g1uOQmEk2X6RzuH8/KrWLSSvfnrZt8+4dH9C2GGuxLgHXVbSxD8Z7EhO
         7/JrBQ3EekTc1w5HVLYO6QUQtFeftRalQV2Ar1d4EZeWbWfX2xxcBSUL7TdeWzmWCMQ1
         JUUlPMJ/5zpc81n3VPCCQp2YHzmZWtbYhCOwFIfZ2XKAioRpPCzR08nkr65tiAvaZ3oR
         tqeueNfttBvbB9d0wYb7J0tbCfDpAzvcPcNEELxttxc57GTwTYPxTtjRuAWmisrdr8Cc
         eXCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791472017; x=1792076817;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=7nTNII3n3G87GHhdFtHT3hqd10T6INaV8G3FhaWt9A0=;
        b=bXchDhCi1uOJwIkyvwAka0u4mtY05no+gYWmZZaS4bjqqJPRZUTVm1NkzwPUl2T2vu
         81zcJLxzLydr3W4UbdXVsmN6DyrkhF0WrEQnixldy54lXKP9giPksv73cLMctaFZ4Zje
         xqdc9Ijj/OWrwogpH74BsmzrEiCtM5WFOuA4cX3cNH3/7iJw0UAKLSdt57qmzD+wERB8
         6XVre5cIlApLscwJ87RHL5AN3tqvLiJol88yX/ra550DmUaqow49EQkdTD3E7v3l2mrE
         qMU/vdmGIHtIIsEkxg6yFcPOdBsXHstLPZ8Xs3+eq1kZYeRhpZhQHaLyLqF/CZ6MvvVW
         MGFw==
X-Forwarded-Encrypted: i=1; AKwUvBzhoyaeU1GVyF8EPT6X9pE4UA858aPh6O+MfiQ+LeJjU63XqF+cM/M4FcVcEzk+qFu3+ESrMIvEdA==@kvack.org
X-Gm-Message-State: AFq9FYJDdB8IeQGy2qd/dWu1XEm+/gwVX3A93MmN9uqMS9jsDixSK4SM
	HupMblq8BTe5S6B0t05y182bbXy++Wn8cbqHmzGeVMS9Z5fDuRUm5Vs1TRYgaafBoV7cUCX5G+h
	0GmWWL6VgNYfYL0yjUuRSzG8tswA1LjI=
X-Gm-Gg: AYBFou1INUlZ+7NJFonTPGg/kHtntSHF7FlHHca6wZsl94Y1cygkRkojndXAN7UrzKW
	CgTL0Rl4NOftHbWN3TpzyKJJOZ+6H+qWXyhBPF+BmxWEvthQE4etCkNJo/f6ij8irm6usxGTK15
	/1HbWf2gdSIMnNxpiz6LxSXUcgih9mKiq5YV65MQsMQ9HyvElLwAK+atczdO3/GXJzH7dm0N9By
	xeeR9VFzdyu6jXS33tWypj8msCb0YXcPxJwuOimeyto6Qm9I9ytbSVIsDh8wQBLSTg+FYHz/Zuq
	jI9nlYSaYIsssBjKs4uPZAbSmJu4mR3hBG9/OmnzLsapL5mXze7DkT7t9m4IAL++ZTfSMIaVnjJ
	obIKc84W7
X-Received: by 2002:a05:690e:4199:b0:677:b923:dbd3 with SMTP id
 956f58d0204a3-6790a49aef4mr1817579d50.154.1791472016554; Thu, 08 Oct 2026
 08:06:56 -0700 (PDT)
MIME-Version: 1.0
References: <20261007163403.1643768-1-ekffu200098@gmail.com> <asaEdFRDdZlRdAc4@thinkpad>
In-Reply-To: <asaEdFRDdZlRdAc4@thinkpad>
From: Sang-Heon Jeon <ekffu200098@gmail.com>
Date: Fri, 9 Oct 2026 00:06:44 +0900
X-Gm-Features: AclHuK8DoN5ENhoGGsqTh6mQAA4XecrayQgZajzaBuMSAutJnzs0JzwLoPXtW-M
Message-ID: <CABFDxMHsn+Dj42GU0zk-HEfYOhoEs1c+UsmLMSjNSrWfUu4MsA@mail.gmail.com>
Subject: Re: [PATCH] mm/slub: clamp slab_min_order to MAX_PAGE_ORDER
To: Harry Yoo <harry@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, Hao Li <hao.li@linux.dev>, 
	linux-mm@kvack.org, Roman Gushchin <roman.gushchin@linux.dev>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: B8E93C000C
X-Stat-Signature: 8fkexq6xbieuirka9yatg4bpnkic4ae1
X-HE-Tag: 1791472017-328761
X-HE-Meta: U2FsdGVkX1/TH7Bv0F+qUvpLDxde/Koy1tXdcJDGk1PC8oo2XvJukMvfVhe2lwNw8qB2c9xvXRDqoXLVNSqM5vylLZoSayEd4OQ/UZdXYIwOIXNguqZaMhATVNMYlxOYn2nWhVzA1AMIscZMl95ySLei+/0CfxSXM5q/OPKPJFTnvaRJZo0F6RQ2WgP0Hle8buFDLKhgeQEpalO5WnpuMu/n5Pza46+GbC/FTPSNsYhGR5FT+o5dlh472yKZhr8oh+lODHwOp4iomD3K6MPy2pqQFY3JQnopegsy63n94ap11UGs+K0uWuvW6vU9JJqO7FvetfRApTuBgOQ1qV4kuKorG/yEEMHJp+G5kBMnxW92GjGjlBEESSYTiQqqKynaZU7RstYno6T6Ajimt8x5BThFfvL0zFD1zd+wxD2xDh7RNAvMGJrpAlmHbP/B9l15K3Kl7+6Q11PagSZDfzEkPTex90rQs8F8JQV1PPxPd5Jq/VhX1Y9JDBGN9uamcEv6wPai0hmtD/fTlHGAEtT3LsNoR7NIL2edW7MTBFXJOs7N+ju7Ahc+Wyl2aUV89JG7ogWy0SiPAV1Ayp+eHPyLbSOp9pq8GFkLanYJ8GrJBZumf8VYaHk7Ws0PCECQs9AmgX2Xy/3OlmmAGhzdyJgQdVrTEyklX6CLYfxN0lmWS1GEwWQP0HXatHtttWMXlFBmYE+slJIqgE3Nt3rq8emhN/RO/84NTkmijGc50lCzUhLzYqxjpoJQLW/iGOFCM1VgSXUwdu8j5q5dY8ZrpXfd6rpfmrUX2jj1agqAQCY6w1hsVfDAerGrRQVu0b+V0uLRRiKkHw9XB89kFg8C7jehl84gBIsbTkPIKj2DuiHsYbMGs8sY7HAJwamUzUc+6hmCZuaUFy8d1tWiUIN58wLegfdoP2tOoesxnZUO3mahTCRnb39nw4TB+IY1kQmerdkLsAZEZdWt7ysN4gBLk3G
 Q704XaBu
 10eQiWJkE4pOeWXYmu2uMNXnq8foKq2WeWpltgNpnw3tn3Wsdwlej0yyaZpj4n4Q/ZyNAgdBC9IsTzmyZ43rAVYxUDG0OWHM+u98tKq3PTQulWfRMGcmirylfsgpc92cYI33TX9GibZdAoE41TBJhe+tbtU9C8d7R5NLAsbqj46xYVpPNGZudcdF6NYh4jmBa3QHwnotaBuvpMD8SjKoWUfOBLFS09FbUxLwKIE9bl/oN+D7bfBRPNzZ8JUXx5GYiQaCYBW+YTPTKQ0aXdoVJipRKn8Q5QwI+9v1qEhnsIR2cnuptcrOnoE8PhnPOyNR3rVf3sG9PQWkfoDhjNmuWJHOGbq1tjGlzgWKHI8uv4b1/iVtGPe5v3pVfeylV6FiqjKlB7N0kR+M5N5xTVVYOO1TOQlaRXSoPfpw7uXZdSAHJDWsaeFymHgzX7fG0Vs3NF+1hvptneGbRoqLXN2D99JEb+f66HImr0x6cCkJPqYRZBYkUBRIahU2t7g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi, Harry

2026=EB=85=84 10=EC=9B=94 8=EC=9D=BC (=EB=AA=A9) =EC=98=A4=EC=A0=84 2:47, H=
arry Yoo <harry@kernel.org>=EB=8B=98=EC=9D=B4 =EC=9E=91=EC=84=B1:
>
> On Thu, Oct 08, 2026 at 01:34:02AM +0900, Sang-Heon Jeon wrote:
> > setup_slub_max_order() clamps slab_max_order to MAX_PAGE_ORDER, but
> > setup_slub_min_order() has no such clamp.
> >
> > The buddy allocator cannot allocate more than 2^MAX_PAGE_ORDER pages
> > at once, so slab_min_order above it makes no sense.
> >
> > If slab_min_order is set above MAX_PAGE_ORDER, it can even panic at
> > boot or invoke undefined behavior in order_objects().
> >
> > So clamp slab_min_order to MAX_PAGE_ORDER as well.
> >
> > Fixes: 818cf5909701 ("slub: enforce MAX_ORDER")
>
> I think Fixes: should be the commit that introduced slub_min_order.

Thanks for your guidance. I'll switch this to 81819f0fc828 ("SLUB core") in=
 v2.

> > Cc: stable@vger.kernel.org
>
> And no need for Cc: stable? It's been there for decades and people
> should realize the kernel parameter is broken when it doesn't boot.

Okay, I'll remove it in v2.

> Otherwise looks good to me.

Thanks for the review :)

> > Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>
> > ---
> > QEMU-based test results
> >
> > - Booted with "slab_min_order=3D20"
> >
> > 1) AS-IS (before fix)
> > [    0.094926] mem auto-init: stack:all(zero), heap alloc:off, heap fre=
e:off
> > [    0.097776] Kernel panic - not syncing: Creation of kmalloc slab kme=
m_cache_node size=3D64 failed. Reason -22
> > [    0.099542] CPU: 0 UID: 0 PID: 0 Comm: swapper Not tainted 7.2.0 #1 =
PREEMPT(undef)
> > [    0.100903] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), B=
IOS 1.16.3-debian-1.16.3-2 04/01/2014
> > [    0.102607] Call Trace:
> > [    0.103040]  <TASK>
> > [    0.103417]  vpanic+0x32a/0x4b0
> > [    0.103976]  panic+0x5e/0x60
> > [    0.104491]  create_boot_cache+0xe3/0xf0
> > [    0.105194]  kmem_cache_init+0x12d/0x410
> > [    0.105890]  ? mem_init+0x1fc/0x210
> > [    0.106521]  mm_core_init+0xba/0x140
> > [    0.107153]  start_kernel+0x441/0x8b0
> > [    0.107814]  x86_64_start_reservations+0x18/0x30
> > [    0.108638]  x86_64_start_kernel+0x10c/0x120
> > [    0.109401]  common_startup_64+0x13e/0x158
> > [    0.110145]  </TASK>
> > [    0.110584] ---[ end Kernel panic - not syncing: Creation of kmalloc=
 slab kmem_cache_node size=3D64 failed. Reason -22 ]---
> >
> > 2) TO-BE (after fix)
> > [    0.008976] mem auto-init: stack:all(zero), heap alloc:off, heap fre=
e:off
> > [    0.011366] SLUB: HWalign=3D64, Order=3D10-10, MinObjects=3D0, CPUs=
=3D4, Nodes=3D1
> >
> > Also, I'm not sure about the Fixes commit. Please change it if you know
> > a better one.
> >
> > ---
> >  mm/slub.c | 2 ++
> >  1 file changed, 2 insertions(+)
> >
> > diff --git a/mm/slub.c b/mm/slub.c
> > index 1559cbace469..8400df7c222e 100644
> > --- a/mm/slub.c
> > +++ b/mm/slub.c
> > @@ -8354,6 +8354,8 @@ static int __init setup_slub_min_order(const char=
 *str, const struct kernel_para
> >       if (ret)
> >               return ret;
> >
> > +     slub_min_order =3D min_t(unsigned int, slub_min_order, MAX_PAGE_O=
RDER);
> > +
> >       if (slub_min_order > slub_max_order)
> >               slub_max_order =3D slub_min_order;
> >
> >
> > base-commit: d755441b7672c74f29d1241ffdd2b067ecab1ca0
> > --
> > 2.43.0
> >
>
> --
> Cheers,
> Harry / Hyeonggon

Best regards,
Sang-Heon Jeon

