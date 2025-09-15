Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7F21DCAC58E
	for <linux-mm@archiver.kernel.org>; Mon, 15 Sep 2025 09:05:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C05698E0003; Mon, 15 Sep 2025 05:05:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BB55A8E0001; Mon, 15 Sep 2025 05:05:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AA4778E0003; Mon, 15 Sep 2025 05:05:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8A9488E0001
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 05:05:35 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 23775140518
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 09:05:35 +0000 (UTC)
X-FDA: 83890901430.30.5553BA8
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf05.hostedemail.com (Postfix) with ESMTP id 2EBB6100016
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 09:05:33 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=SfVoNwF1;
	spf=pass (imf05.hostedemail.com: domain of bhe@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=bhe@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757927133;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KvJ9L1p3rbhqt/V3V+FfG1d8fzkSxXKReu1b/znpF7c=;
	b=3/KHMk9P7zq+Lb7UPlYRz+LBcR6Y6vsJKytTYCVRpqEzd2BBcMMEdoXxKlUy4HG5vsbbDx
	NciXMnWC9OZwGZs5l6UL47BA7Zf/DrDHr/q+zPZNqcqEtbTDFURS6S/dtzzIa501tuCwB2
	b5s3HU7C8LNTH1SlxzcLmrBqQVD32NY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757927133; a=rsa-sha256;
	cv=none;
	b=OftGwys/G7ywjnZ+9hilxqHIJa2N8o177GeZxmeI5VMvEKexOBsi3WS1lQI9kQuHhZGtEG
	mPLRu1vV7RL8taxT69OENX8LD57qz8/0mTzmzQjBUI4WuLQZ/2fcvU8uqZgFJ/Rn5jtzkN
	YNU7dXWFXBzGOoQH0gHZ897dc2U8K88=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=SfVoNwF1;
	spf=pass (imf05.hostedemail.com: domain of bhe@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=bhe@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757927132;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=KvJ9L1p3rbhqt/V3V+FfG1d8fzkSxXKReu1b/znpF7c=;
	b=SfVoNwF1m8TmqzJACl9865qllwugm4/+QrZwqM87f1wFbcMOl1xFfi7ulGXsCeqQ04YJRI
	iaOz0saCEz4k9EVQ1oPH1MQUNi1ponwf+jjotCDwfjrgcIrBEd6DFRzxVSZwbK2r1o0G1E
	ZSavkh76GKFVf3awvNI6B9yiYDLKY4k=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-351-88ufwEDMO5aVH_vHDZb24g-1; Mon,
 15 Sep 2025 05:05:29 -0400
X-MC-Unique: 88ufwEDMO5aVH_vHDZb24g-1
X-Mimecast-MFC-AGG-ID: 88ufwEDMO5aVH_vHDZb24g_1757927127
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id CF3DC18002CA;
	Mon, 15 Sep 2025 09:05:26 +0000 (UTC)
Received: from localhost (unknown [10.72.112.195])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id BA10719560A2;
	Mon, 15 Sep 2025 09:05:24 +0000 (UTC)
Date: Mon, 15 Sep 2025 17:05:19 +0800
From: Baoquan He <bhe@redhat.com>
To: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>, snovitoll@gmail.com,
	glider@google.com, dvyukov@google.com, elver@google.com,
	linux-mm@kvack.org, vincenzo.frascino@arm.com,
	akpm@linux-foundation.org, kasan-dev@googlegroups.com,
	linux-kernel@vger.kernel.org, kexec@lists.infradead.org,
	sj@kernel.org, lorenzo.stoakes@oracle.com,
	christophe.leroy@csgroup.eu
Subject: Re: [PATCH v3 00/12] mm/kasan: make kasan=on|off work for all three
 modes
Message-ID: <aMfWz4gwFNMx7x82@MiWiFi-R3L-srv>
References: <20250820053459.164825-1-bhe@redhat.com>
 <CA+fCnZdfv+D7sfRtWgbbFAmWExggzC2by8sDaK7hXfTS7viY8w@mail.gmail.com>
 <aLlJtTeNMdtZAA9B@MiWiFi-R3L-srv>
 <CA+fCnZf2fGTQ6PpoKxDqkOtwcdwyPYx2cFwQw+3xAjOVxjoh6w@mail.gmail.com>
 <75a2eb31-3636-44d4-b2c9-3a24646499a4@gmail.com>
 <CA+fCnZf7jYPUyqHqonWhDKVi9eeN6aaaByMTBYCQrv2-8+hngQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+fCnZf7jYPUyqHqonWhDKVi9eeN6aaaByMTBYCQrv2-8+hngQ@mail.gmail.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Stat-Signature: jt1poosgjjneps434r66qfsnae6k1p7p
X-Rspam-User: 
X-Rspamd-Queue-Id: 2EBB6100016
X-Rspamd-Server: rspam10
X-HE-Tag: 1757927132-430774
X-HE-Meta: U2FsdGVkX1/Grx5Wq5njT13tEXrc1+ihB1Al/XeIitDSqojt7Eai0Oo1b/4In9KR9O0hPMLQI4pFRpxAYf4Y7cPS6YxQR43NCUFTqFgnzbbsPuIKLkQcgj5NiZ8bHkkDt9m1uBOdlGyKDr9l9gMM98e9KNt6rNdRjNZWgMcj7JQL/B2bWQjyTrN2fAZuRDMUrgJyQGJJUUhOmw/Ny43Pd2lGifOogEFWb1BtxPE7ASEgYH/cFuSeAr8FrV5MyTPycwXzxIiSWCgn6n8XK5hX7Tj+6kCZPp0XiDMUaFkWRj/lNFHQaPqRHUZUxZMfWhDZszs6SJwtSozu4omljAFXXu2vJewAp6m4iPvThgiRSvOH/W+TTgEKevNyp34gDgloHfNKhhwDm9KtmecY6qHAF2INNAg74CxS21exZS6vppwe59X6DgvRMXpu2nyLbWyglfRdideY+A9AxrM+/ZYeshHuDbds3o9/mVTF/f+GLd5ljPFi+ncTqJ5yES4OCMQQqk/bX7Tdu+3THh1bOUB0cdZd9PdGHo9uFthSZcPwtcMF5RgXGh2IfOqWWNw0xs4BRSaJzDK0Bb66omydjR9DVpFoGLMHozbTuHgpFAIJAYNT3OEMBuISROWXZSRRGAtT803GjeeAumHEj/20oC60n6Q7beTHVCJQBSUO1ViFQnniBmWQQtZPkxlX/p/KR3N3WaRThVitxGdRkwKcABGIm6cv3D2PTxHmLQRU2r6VYIDlg8AZiHDwR5j51k9n0wBDyx/egz9x/GcIW3TUWQrgHmL04awxUc/AvISCiLQWyOJT+joTe9W3fSjblYsng0YfVOYadc5HxFZ1LxW0CoAWCHH/YzL057LkBefNsQd7nVkhUWQfk3BMgW8NSqL8CBSPAUP12vp1XC2i0n6JjHWZHUYWjP3Utj9BnHOZL+72cMw5qcMOoPITuyUfnRgiCBtrD/ktGvLjvdLfvS/AUxG
 72uyE87b
 wqvo6GeUiAUz6z+kbe/2UV0bw9PkwNG+37Kbk9PyVMgoOH2aDqQh+k0grKRnrcQqjohFA29wT7sdu6YtI4CqVuXsuspK3z66iXTH2YMb7y7tSWFvW1V2dFRI89rjaQZIVCt+7Coe0l2HbVX8AJ6dI9tESpnUYJKKSfUC6VatIHoswgBZX1WoxkXrGB69e+jucM/nxeqgxNZCSnacCjUoRmzyYb10auj+vgzRX7sZBn9BqbHWrzl7b/8qdN54vdIuMTYsh46loBhQKNkbNiA3M8fDgNwamMz1wGZwZJ5ygQuYpoRD0G2Z4FTnFYCv8yWQv6mbGo8jmmgbC4ZfdeZ95qbwgLZmy08V845xWLMdwA9BrCRI9o0M8yJD5wnMIMGbeggt1Nu4ZGiV70CtTfUSQC16wt1I0o+reFKnE4+SU8xI1HAKfvrr13t9HudWE+coiQTI40nAetmUJsVaE5Wyj2DAjSI07iHB4ZVj6EzFByB8NquoPDboQWvBzUpf4jw0iBJIdJqWxvCUEjTLaQ1x3JMvjGxsZOn+ZWG1FRnlWciWXHYceEkawpntV23X5cU9j0oa2
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 09/05/25 at 10:34pm, Andrey Konovalov wrote:
> On Fri, Sep 5, 2025 at 7:12 PM Andrey Ryabinin <ryabinin.a.a@gmail.com> wrote:
> >
> > > But have you tried running kasan=off + CONFIG_KASAN_STACK=y +
> > > CONFIG_VMAP_STACK=y (+ CONFIG_KASAN_VMALLOC=y)? I would expect this
> > > should causes crashes, as the early shadow is mapped as read-only and
> > > the inline stack instrumentation will try writing into it (or do the
> > > writes into the early shadow somehow get ignored?..).
> >
> > It's not read-only, otherwise we would crash very early before full shadow
> > setup and won't be able to boot at all. So writes still happen, and shadow
> > checked, but reports are disabled.
> >
> > So the patchset should work, but it's a little bit odd feature. With kasan=off we still
> > pay x2-x3 performance penalty of compiler instrumentation and get nothing in return.
> > So the usecase for this is if you don't want to compile and manage additional kernel binary
> > (with CONFIG_KASAN=n) and don't care about performance at all.

Thanks a lot for your careful reviewing, and sorry for late reply.

About kasan=off, we use static key to detect that, wondering if we will
have x2-x3 performance penalty. Not only can kdump get the benefit, but I
can think of one case where people may use kasan enabled kernel to detect
MM issues, while use kasan=off to make sure kasan code itself won't make
trouble. E.g you tested a normal kernel and it has no problem, while
kasan enabled kernel will trigger issue, sometime do we doubt kasan
code? In this case, kasan=off can prove its inonence?

This could be trivial, while I don't see much kasan=off introducing will
impact the old kasan performance and stir the current kasan implementation
code. We have got the kasan_arch_is_ready() anyway.


> 
> Ack. So kasan=off would work but it's only benefit would be to avoid
> the RAM overhead.

Right, I built kernel with below configs on, kasan=off|on works very
well.

=====
CONFIG_KASAN=y
CONFIG_CC_HAS_KASAN_MEMINTRINSIC_PREFIX=y
CONFIG_KASAN_GENERIC=y
CONFIG_KASAN_INLINE=y
CONFIG_KASAN_STACK=y
CONFIG_KASAN_VMALLOC=y
CONFIG_KASAN_KUNIT_TEST=m
...
CONFIG_VMAP_STACK=y
=====

> 
> Baoquan, I'd be in favor of implementing kasan.vmalloc=off instead of
> kasan=off. This seems to both (almost) solve the RAM overhead problem
> you're having (AFAIU) and also seems like a useful feature on its own
> (similar to CONFIG_KASAN_VMALLOC=n but via command-line). The patches
> to support kasan.vmalloc=off should also be orthogonal to the
> Sabyrzhan's series.
> 
> If you feel strongly that the ~1/8th RAM overhead (coming from the
> physmap shadow and the slab redzones) is still unacceptable for your
> use case (noting that the performance overhead (and the constant
> silent detection of false-positive bugs) would still be there), I
> think you can proceed with your series (unless someone else is
> against).

Yeah, that would be great if we can also avoid any not needed memory
consumption for kdump.

> 
> I also now get what you meant that with your patches for the kasan=off
> support, Sabyrzhan's CONFIG_ARCH_DEFER_KASAN would not be required
> anymore: as every architecture would need a kasan_enabled() check,
> every architecture would effectively need the CONFIG_ARCH_DEFER_KASAN
> functionality (i.e. the static key to switch off KASAN).

Exactly. In this case, the code with the static key enabling or
disabling is clearer than CONFIG_ARCH_DEFER_KASAN setting or not.

> 
> Nevertheless, I still like the unification of the static keys usage
> and the KASAN initialization calls that the Sabyrzhan's series
> introduces, so I would propose to rebase your patches on top of his
> (even though you would remove CONFIG_ARCH_DEFER_KASAN, but that seems
> like a simple change) or pick out the related parts from his patches
> (but this might not be the best approach in case someone discovers a
> reason why kasan=off is a bad idea and we need to abandon the
> kasan=off series).

Here I understand your reviewing policy. While I would like to explain a
little about my posting. I planned to do this job in 2023, made draft
patches on x86 for generic kasan, I dind't go further to try sw_tags
mode on arm64 because other things interrupted me. This year, I made
plan to disable some kernel features not necessary for kdump kernel,
mainly by adding kernel parameter like ima= I made, and later the
kasan=off.

aa9bb1b32594 ima: add a knob ima= to allow disabling IMA in kdump kernel

When I made patch and posted, I didn't see Sabyrzhan's patches because I
usually don't go through mm mailing list. If I saw his patch earlier, I
would have suggested him to solve this at the same time.

About Sabyrzhan's patch sereis, I have picked up part of his patches and
credit the author to Sabyrzhan in below patchset.

[PATCH 0/4] mm/kasan: remove kasan_arch_is_ready()
https://lore.kernel.org/all/20250812130933.71593-1-bhe@redhat.com/T/#u

About reposting of this series, do you think which one is preferred:

1) Firstly merge Sabyrzhan's patch series, I reverted them and apply for
   my patchset.

2) Credit the author of patch 1,2,3 of this patch series to Sabyrzhan
   too as below, because Sabyrzhan do the unification of the static keys
   usage and the KASAN initialization calls earlier:

[PATCH v3 01/12] mm/kasan: add conditional checks in functions to return directly if kasan is disabled
[PATCH v3 02/12] mm/kasan: move kasan= code to common place
[PATCH v3 03/12] mm/kasan/sw_tags: don't initialize kasan if it's disabled

commit ac4004af0e1e8798d11c9310e500a88116d90271
Author: Baoquan He <bhe@redhat.com>
Date:   Mon Jan 2 08:58:36 2023 +0800

    x86/kasan: check if kasan is available

commit cddd343bdbf5d0331695da8100380fc4b8b47464
Author: Baoquan He <bhe@redhat.com>
Date:   Sun Jan 1 20:57:51 2023 +0800

    mm/kasan: allow generic and sw_tags to be set in kernel cmdline
    
    Signed-off-by: Baoquan He <bhe@redhat.com>

commit b149886995ecb2e464fee0cdd3a814035fc87226
Author: Baoquan He <bhe@redhat.com>
Date:   Sun Jan 1 21:07:29 2023 +0800

    x86/kasan: allow to disable kasan during boot time


