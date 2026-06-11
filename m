Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ACC93CD8C9D
	for <linux-mm@archiver.kernel.org>; Thu, 11 Jun 2026 19:30:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ADFD36B0005; Thu, 11 Jun 2026 15:30:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AB7636B0088; Thu, 11 Jun 2026 15:30:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9A5666B008C; Thu, 11 Jun 2026 15:30:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 869436B0005
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 15:30:11 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 1608FC26C5
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 19:30:11 +0000 (UTC)
X-FDA: 84868622622.08.066AB78
Received: from mail-qt1-f179.google.com (mail-qt1-f179.google.com [209.85.160.179])
	by imf31.hostedemail.com (Postfix) with ESMTP id EE17820017
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 19:30:08 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=RxFsweqL;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf31.hostedemail.com: domain of surenb@google.com designates 209.85.160.179 as permitted sender) smtp.mailfrom=surenb@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781206209;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZE18H5Ui8cnmxCzZ0X7IVvZWtIRFB9ouO8fNlDixovc=;
	b=A2NeOmrzAXg2DlfxZpj9K5Pvw8MoK8KGRV6BNly4e/tDosNoyVj2VPedKDlcS4tfJ3d3lT
	PJztbLuPIwvLeGuKSX77CpbJq9IGJ6/jc+82Mh+P626iMJaxvUzhgVj4UN9MJRdfKlpFNf
	ZY9NM3D7GBhoIAwYZY0F5TBA7+6z+Rk=
ARC-Authentication-Results: i=2;
	imf31.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=RxFsweqL;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf31.hostedemail.com: domain of surenb@google.com designates 209.85.160.179 as permitted sender) smtp.mailfrom=surenb@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1781206209;
	b=X3IcgBSZJPg/vXw6VUNuJduYku2UvOBf7BiLmOaVTjvQ2HSY8tqpgGmLU30YVHHe3H7UKm
	ubC190AUqpjf6qXunVzeCqxlODsGvibwS1GPDVXTU9UmIB1zRlmbz9Ahi8WG5doKT79vcm
	aXpoTOyf+A2e3wQs9UNxk5ilHf1Rx44=
Received: by mail-qt1-f179.google.com with SMTP id d75a77b69052e-5175d339e8bso118131cf.0
        for <linux-mm@kvack.org>; Thu, 11 Jun 2026 12:30:08 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781206208; cv=none;
        d=google.com; s=arc-20240605;
        b=D58kMoWCYotnfn5jRisR3fu/FuNDqVDoXiXVktos4QmgvwL5Ebq1Wonc9zKmZb3ytR
         W7nAsiCeiFHR3i0U4lmEbwXLjDoinEkCUTeLTu7Qk5IVI2jKXZgP2Uxlb9DY0mL4rKvw
         mwuJ0uiLwF0QMTFF7/JMy4O0CrF4LXpJ+UrpaI7keaMAjC2IsyMWAJTaoFyiBu/c3Nu+
         ptt9Qd8I/t04VX0mJ+TdiYjKgeCr5uTcYxxP2w0x/zIR1Aco6+4t3N2E+/to+MnKtlyq
         XgZm61rpW8TN2grhZ5PWSZVTTFPF3i1QFBAwIxXzUaPuJuNZ9MOEDco0RE1yedkOWqDx
         Jp2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=ZE18H5Ui8cnmxCzZ0X7IVvZWtIRFB9ouO8fNlDixovc=;
        fh=lio0det8i9CrxIUyueTElgQvo07o6G51cp5uvwakTyg=;
        b=CjzDTqx3DWJRNMM9TnEITTzGFa/1OCHXwif89yjgyjJQjR306VLOkJT1CrSSLMD9Lm
         oCKq1e1eWz28OADjhPRzHWPyAmjXwbbh4+T+xZkn3g1dnZiMt/3gZp7gdfc6fdCKUF7R
         uKftQlAs6e1tfUBtLlEZKudRMzSqJFCuDFDaJQ9FeOl59zQ1ZgNOCKhTcF+vEZiofxuv
         iXUhem7p0uQ29PUqUS+NGJ6k5xzduyX8YwYIRm6HbzTRtuUuSqFCUq5GekO9UcfC72Ae
         WAfgBMr+6VqptSo97JsIFn9zsrGRhleDOH6Jx8GlRMZlBnqTkwHwN9wEOWX3djnxvnuH
         sZzA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781206208; x=1781811008; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZE18H5Ui8cnmxCzZ0X7IVvZWtIRFB9ouO8fNlDixovc=;
        b=RxFsweqLeAa2Hwlu6IE0HkFMl3yuHwbRBQqkOzmMEitQ6jkY1b8LMQaKTyUabEYHin
         l4hGRRPHeiEoYcltvF8nu1NE6rT245LnGip+j7JxYl6lLCUOSsw5P6IrIKbgdHBfYYmB
         dPwbaWb/b+8g1XAJ1uXzlflr9dJnlymPOqCjAgBBapIOwPuaRuCyUOEeFka7XbV+CPZt
         fGyPxjhtwApredVhpktb2CYrN10B776RSDsBjBBkvL8yfbzXem1ozNXa0AuRwN5cQilO
         zv6xy7Vuk3W96LIlCGwTnbs58GlV06mt2aZpSwqZc3CkGRZYjhmJ9Bgnszia7yPjAr0G
         BanA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781206208; x=1781811008;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ZE18H5Ui8cnmxCzZ0X7IVvZWtIRFB9ouO8fNlDixovc=;
        b=lPH9qRhc6dx1Aq0Oc6UkKhUz8e8W3eNMvunv+3P0fNFVC0onTVQhFf9O8ijc3EnLVx
         GcSyQkb/dkwIAT8wBXRmmsdZ6EIYn03GKBt60tXcqJLU0ONH+aO6SaOCR5a0N/zwb6uQ
         5NkCbVSfHeijS5dmPNYEw2La7hg5yIjncF8Of+DWj62F11oei9TjrQCqTZL8OhKzzBii
         lnnL0AnWH6BO1SGu2RgWf+RF7Og2GgxKxPt182f4VvzVy6+k3sxUhmA0PDZbmwkVPfGm
         vP5F+gNlhC9Bcb/VKJbWutTRb2okWgkn8h/Xg5gDCwDx8waz18huSD2cwFTB21FK52Ff
         feOA==
X-Forwarded-Encrypted: i=1; AFNElJ/mXD2/CyttPsL0t6huM2u+ekGbDIzsVxVLvBhDyd7Db1ldVGJ2r8iDpBzQsSQ5ra0vc1I2CkeCQA==@kvack.org
X-Gm-Message-State: AOJu0Yxv/KrrR93c/dyrRufKsvH7oKhLuUgBMJj2b30tTj/YBUh5Wkli
	s8yTig+mmo6usRRblL6Xg3gcHor+p3cNRdVnP5trIWRWfGYwBwCVPkGrz9KVfmPZ3rCD+dWXzis
	56w1vyLTGKuTUxFbpQcbws2LS0LDHGaqbk/48sCA7
X-Gm-Gg: Acq92OGUKQ3lbCPYBd9jldZ1vez2JmblQXMpox9AHqS2xrCTZ4utHnbCm3VCn9TP6A8
	8k2coDUNMVBjH1nTAijTHRe1FY2oFxi4VGGT/mKkitbz/rMMr0H2OopYxNlUtzzlqoFoU27NPGp
	cQMJLyK9IpzFA5jaxQ2HGhT92l7Rg4+EF4L/tA6HYqRs2cWU0gMPe7ErrBVpURsV55aE7kATKAU
	If6oHZJFz/ONCAh4tNVDYxQpAQ06ZDMGethiXdki7/ZLkLYtOXBUrrGtJg5lwhxlS1XLGZT57vx
	mDjELdRs7fMZwNPq1vHqXPPTHlioZMDxGrXz
X-Received: by 2002:a05:622a:2293:b0:516:4f62:85ee with SMTP id
 d75a77b69052e-517fb24f55dmr1423531cf.19.1781206206972; Thu, 11 Jun 2026
 12:30:06 -0700 (PDT)
MIME-Version: 1.0
References: <20260610230409.A44D29FA@davehans-spike.ostc.intel.com> <20260610230411.617DD5E7@davehans-spike.ostc.intel.com>
In-Reply-To: <20260610230411.617DD5E7@davehans-spike.ostc.intel.com>
From: Suren Baghdasaryan <surenb@google.com>
Date: Thu, 11 Jun 2026 12:29:54 -0700
X-Gm-Features: AVVi8Ce8DHD1TRde_gfa50pisjPH2maXlW5G_8M-eoDp8baullLXePwybPMEt1s
Message-ID: <CAJuCfpGbz1_05GkyaoEpnhbd4s6+-U_ksUA=wYfRPivq2iFBHA@mail.gmail.com>
Subject: Re: [PATCH v2 1/5] mm: Make per-VMA locks available universally
To: Dave Hansen <dave.hansen@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, Alice Ryhl <aliceryhl@google.com>, 
	Andrew Morton <akpm@linux-foundation.org>, =?UTF-8?B?QXJ2ZSBIasO4bm5ldsOlZw==?= <arve@android.com>, 
	Carlos Llamas <cmllamas@google.com>, Christian Brauner <christian@brauner.io>, 
	David Ahern <dsahern@kernel.org>, "David S. Miller" <davem@davemloft.net>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, linux-mm@kvack.org, 
	Lorenzo Stoakes <ljs@kernel.org>, netdev@vger.kernel.org, 
	Shakeel Butt <shakeel.butt@linux.dev>, Todd Kjos <tkjos@android.com>, 
	Vlastimil Babka <vbabka@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: EE17820017
X-Rspam-User: 
X-Stat-Signature: cmf8awx1pc9c9ab77fi9yxwirnyjjzx3
X-Rspamd-Server: rspam09
X-HE-Tag: 1781206208-89941
X-HE-Meta: U2FsdGVkX19v82Jiq5+ZFkjDQrMI2DTyH1fNzzN6VjBSy5dfxVpa42EnlQQF16m6YW2XYpaNFH3ATxr0Rj52r5MF+Dpd5L8naX9UB8lJwjQQKWU59r78SpJ4xX7h2RlQPK/2Jz35E4qVcvNPr+DjwBLsZigjug2052g60CFIRq7pOH4BUn3YIzrnrPtd/6nDH9xG+ejX5BFoCyU5qArRmKXhixOJWeRl64aBsTgFrH9U0gFlrt/2UPftEqIPLOV1ubl/CjaEaL7FBLB7YLZZHHKeOkgOMElFPbZ1lNKsye36VIDCJ4JhVrRM3UEDm8MRX0AJm9C2nwIx6wnY7/d8bNmIIxuImNgI3G7EhXjrBSJmKO2EMOM8clz/jivJffzhDQ7dr7eYxuvuh//cfvw0npNZmYHnGZ3fqaXR0Oq9a4LG8uSLnQBiS2iFk+JQmKdrBzWsmzcT9F0vpS7zipKhkiZnkmy5MUk7v/sHFPbQ4YEos27Owks+2UudLnt4dk36lnysiJR4oihQG3FRknp6w22E65gvE6WkqU8aJ6xIloX97nkX6XWH5zMg7tPE+qx0w9nF8VhC75dpuGsBTf03QGMpcf+GZtd/taxdU0wh8BdnAh5mauhwvAQnWovJbnu8bQHHRIbjcxI0LDxQnWyxKO1MKXVQQirSwCm2Fl5v2Qse2KAEaSpE5yT3sBXR/1ms2YvtWRQnfwauppxuBlryvM88FKP2gdw9W2TZIRnieNw4f96qESSSg5IoLUOKfcjhZrNZICbQMs5zvvLDi753cwHPdjWLffCYCc7YpLcpB/ssn0lo3SwBXppZZw4H8pm9RJN657P5iRTpBO4YCbelKpkXmy+bOutbUMsiGTczSiAOCpg6IOTSKEBQBpy4xZ+Gm/0R2QNw8zd2QGRQUvISMzqh37ITxIfCeis7DMGJVrqnfyZfyXWeVkkUbFfOQ8rRKZ/z0Gy14WaFc2jkbqv
 Xp/Z8JQ8
 sjs7lRwaP2urXgZHHV/Ql4JDXxep67ZR07GPd96ojviJBfb590MyGW/yooD3Kmimhhc7BpIdzIcymIle9tVMTnN47CIkOYz1TnZMc4EX1eE2eDh69K8fZH51qWt3IlgWSm8WebiDa2lWVO4Dbboo2E/aLgKX+GwbfVv8q0Nh3BCgv29fJa6slLpSOy6v7462UIBUY9knB1YdxYLs0r7uKAW+Sxmkcao3AN9oCpsju5aa6npaD4/Q5i1/sQpyfMO3lNDuyXgdRqexIace9GVWfD7ThVGpz/vTS0whUHx2ISC/4NGKmhxBywO92Gnjh/UcFgsNBFkrOOmRQTLKu6ZKf/lhRetEKQwhuye2fcfsYo95Bt34cu67I9E7aT4UInrPxYf2jcbxneAiixEacMQwoumYphgN+ESSAc9gEygfrb0E+VhRiEd6WpdUAcmtmnZd67XfsiNEoCrKbeUYkoiALYssHVacWKtoAYeiZ24450S94oT1M1fyIomT29dAP1z5JMLaG/LcBmjEgAw1e7zH4YI+Qd8co7zvkeZDT6BC7mRRSh9LLBGnSBj5zqQ1KKv/e9s/d6o2YjA+cTVEvirsOJsjJ860kB9g0Yog+x+cOgk5OooaRLPRm3/wBSQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jun 10, 2026 at 4:04=E2=80=AFPM Dave Hansen <dave.hansen@linux.inte=
l.com> wrote:
>
>
> From: Dave Hansen <dave.hansen@linux.intel.com>
>
> The per-VMA locks have been around for several years. They've had some
> bugs worked out of them and have seen quite wide use. However, they
> are still only available when architectures explicitly enable them.
> Remove the conditional compilation around the per-VMA locks, making
> them available on all architectures and configs.
>
> The approach up to now seemed to be to add ARCH_SUPPORTS_PER_VMA_LOCK
> when the architecture started using per-VMA locks in the fault
> handler. But, contrary to the naming, the Kconfig option does not
> really indicate whether the architecture supports per-VMA locks or
> not. It is more of a marker for whether the architecture is likely to
> benefit from per-VMA locks.

Correct. Originally per-VMA locks were used only in the page fault
handling path and architectures that used them in that path would set
ARCH_SUPPORTS_PER_VMA_LOCK. Over time these locks are used in more
places, so ARCH_SUPPORTS_PER_VMA_LOCK lost its meaning and indeed can
be removed.


>
> To me, the most important thing side-effect of universal availability
> is letting per-VMA locks be used in SMP=3Dn configs. This lets us use
> per-VMA locking in all x86 code without fallbacks.
>
> Overall, this just generally makes the kernel simpler. Just look at
> the diffstat. It also opens the door to users that want to use the
> per-VMA locks in common code. Doing *that* brings additional
> simplifications.
>
> The downside of this is adding some fields to vm_area_struct and
> mm_struct. There are likely ways to optimize this, especially for
> things like SMP=3Dn configs. For now, do the simplest thing: use the
> same implementation everywhere.
>
> Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
> Reviewed-by: Suren Baghdasaryan <surenb@google.com>
> Cc: Suren Baghdasaryan <surenb@google.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
> Cc: Lorenzo Stoakes <ljs@kernel.org>
> Cc: Vlastimil Babka <vbabka@kernel.org>
> Cc: Shakeel Butt <shakeel.butt@linux.dev>
> Cc: linux-mm@kvack.org
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Arve Hj=C3=B8nnev=C3=A5g <arve@android.com>
> Cc: Todd Kjos <tkjos@android.com>
> Cc: Christian Brauner <christian@brauner.io>
> Cc: Carlos Llamas <cmllamas@google.com>
> Cc: Alice Ryhl <aliceryhl@google.com>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: David Ahern <dsahern@kernel.org>
> Cc: netdev@vger.kernel.org
>
> --
>
> Changes from v1:
>  * Remove a bunch of left over CONFIG_PER_VMA_LOCKs
>  * Trim some speculation out of the changelog
> ---
>
>  b/arch/arm/Kconfig                       |    1
>  b/arch/arm64/Kconfig                     |    1
>  b/arch/loongarch/Kconfig                 |    1
>  b/arch/powerpc/platforms/powernv/Kconfig |    1
>  b/arch/powerpc/platforms/pseries/Kconfig |    1
>  b/arch/riscv/Kconfig                     |    1
>  b/arch/s390/Kconfig                      |    1
>  b/arch/x86/Kconfig                       |    2 -
>  b/fs/proc/internal.h                     |    2 -
>  b/fs/proc/task_mmu.c                     |   51 ------------------------=
----
>  b/include/linux/mm.h                     |   12 ------
>  b/include/linux/mm_types.h               |    7 ---
>  b/include/linux/mmap_lock.h              |   48 ------------------------=
---
>  b/kernel/bpf/task_iter.c                 |    5 --
>  b/kernel/fork.c                          |    2 -
>  b/mm/Kconfig                             |   13 -------
>  b/mm/Kconfig.debug                       |    1
>  b/mm/debug.c                             |    4 --
>  b/mm/init-mm.c                           |    2 -
>  b/mm/memory.c                            |    2 -
>  b/mm/mmap_lock.c                         |   24 -------------
>  b/mm/pagewalk.c                          |    2 -
>  b/mm/rmap.c                              |    2 -
>  b/mm/userfaultfd.c                       |   55 ------------------------=
-------
>  b/rust/kernel/mm.rs                      |    7 ---
>  b/tools/testing/vma/include/dup.h        |    4 --
>  b/tools/testing/vma/vma_internal.h       |    1
>  27 files changed, 1 insertion(+), 252 deletions(-)
>
> diff -puN arch/arm64/Kconfig~unconditional-vma-locks arch/arm64/Kconfig
> --- a/arch/arm64/Kconfig~unconditional-vma-locks        2026-06-10 15:57:=
53.491348630 -0700
> +++ b/arch/arm64/Kconfig        2026-06-10 15:57:54.069369179 -0700
> @@ -80,7 +80,6 @@ config ARM64
>         select ARCH_SUPPORTS_INT128 if CC_HAS_INT128
>         select ARCH_SUPPORTS_NUMA_BALANCING
>         select ARCH_SUPPORTS_PAGE_TABLE_CHECK
> -       select ARCH_SUPPORTS_PER_VMA_LOCK
>         select ARCH_SUPPORTS_HUGE_PFNMAP if TRANSPARENT_HUGEPAGE
>         select ARCH_SUPPORTS_RT
>         select ARCH_SUPPORTS_SCHED_SMT
> diff -puN arch/arm/Kconfig~unconditional-vma-locks arch/arm/Kconfig
> --- a/arch/arm/Kconfig~unconditional-vma-locks  2026-06-10 15:57:53.49934=
8914 -0700
> +++ b/arch/arm/Kconfig  2026-06-10 15:57:54.070369215 -0700
> @@ -41,7 +41,6 @@ config ARM
>         select ARCH_SUPPORTS_ATOMIC_RMW
>         select ARCH_SUPPORTS_CFI
>         select ARCH_SUPPORTS_HUGETLBFS if ARM_LPAE
> -       select ARCH_SUPPORTS_PER_VMA_LOCK
>         select ARCH_SUPPORTS_RT
>         select ARCH_USE_BUILTIN_BSWAP
>         select ARCH_USE_CMPXCHG_LOCKREF
> diff -puN arch/loongarch/Kconfig~unconditional-vma-locks arch/loongarch/K=
config
> --- a/arch/loongarch/Kconfig~unconditional-vma-locks    2026-06-10 15:57:=
53.542350439 -0700
> +++ b/arch/loongarch/Kconfig    2026-06-10 15:57:54.070369215 -0700
> @@ -68,7 +68,6 @@ config LOONGARCH
>         select ARCH_SUPPORTS_LTO_CLANG_THIN
>         select ARCH_SUPPORTS_MSEAL_SYSTEM_MAPPINGS
>         select ARCH_SUPPORTS_NUMA_BALANCING if NUMA
> -       select ARCH_SUPPORTS_PER_VMA_LOCK
>         select ARCH_SUPPORTS_RT
>         select ARCH_SUPPORTS_SCHED_SMT if SMP
>         select ARCH_SUPPORTS_SCHED_MC  if SMP
> diff -puN arch/powerpc/platforms/powernv/Kconfig~unconditional-vma-locks =
arch/powerpc/platforms/powernv/Kconfig
> --- a/arch/powerpc/platforms/powernv/Kconfig~unconditional-vma-locks    2=
026-06-10 15:57:53.544350510 -0700
> +++ b/arch/powerpc/platforms/powernv/Kconfig    2026-06-10 15:57:54.07036=
9215 -0700
> @@ -17,7 +17,6 @@ config PPC_POWERNV
>         select PPC_DOORBELL
>         select MMU_NOTIFIER
>         select FORCE_SMP
> -       select ARCH_SUPPORTS_PER_VMA_LOCK
>         select PPC_RADIX_BROADCAST_TLBIE if PPC_RADIX_MMU
>         default y
>
> diff -puN arch/powerpc/platforms/pseries/Kconfig~unconditional-vma-locks =
arch/powerpc/platforms/pseries/Kconfig
> --- a/arch/powerpc/platforms/pseries/Kconfig~unconditional-vma-locks    2=
026-06-10 15:57:53.552350794 -0700
> +++ b/arch/powerpc/platforms/pseries/Kconfig    2026-06-10 15:57:54.07036=
9215 -0700
> @@ -23,7 +23,6 @@ config PPC_PSERIES
>         select HOTPLUG_CPU
>         select FORCE_SMP
>         select SWIOTLB
> -       select ARCH_SUPPORTS_PER_VMA_LOCK
>         select PPC_RADIX_BROADCAST_TLBIE if PPC_RADIX_MMU
>         default y
>
> diff -puN arch/riscv/Kconfig~unconditional-vma-locks arch/riscv/Kconfig
> --- a/arch/riscv/Kconfig~unconditional-vma-locks        2026-06-10 15:57:=
53.559351043 -0700
> +++ b/arch/riscv/Kconfig        2026-06-10 15:57:54.070369215 -0700
> @@ -70,7 +70,6 @@ config RISCV
>         select ARCH_SUPPORTS_LTO_CLANG_THIN
>         select ARCH_SUPPORTS_MSEAL_SYSTEM_MAPPINGS if 64BIT && MMU
>         select ARCH_SUPPORTS_PAGE_TABLE_CHECK if MMU
> -       select ARCH_SUPPORTS_PER_VMA_LOCK if MMU
>         select ARCH_SUPPORTS_RT
>         select ARCH_SUPPORTS_SHADOW_CALL_STACK if HAVE_SHADOW_CALL_STACK
>         select ARCH_SUPPORTS_SCHED_MC if SMP
> diff -puN arch/s390/Kconfig~unconditional-vma-locks arch/s390/Kconfig
> --- a/arch/s390/Kconfig~unconditional-vma-locks 2026-06-10 15:57:53.57135=
1470 -0700
> +++ b/arch/s390/Kconfig 2026-06-10 15:57:54.071369250 -0700
> @@ -153,7 +153,6 @@ config S390
>         select ARCH_SUPPORTS_MSEAL_SYSTEM_MAPPINGS
>         select ARCH_SUPPORTS_NUMA_BALANCING
>         select ARCH_SUPPORTS_PAGE_TABLE_CHECK
> -       select ARCH_SUPPORTS_PER_VMA_LOCK
>         select ARCH_USE_BUILTIN_BSWAP
>         select ARCH_USE_CMPXCHG_LOCKREF
>         select ARCH_USE_SYM_ANNOTATIONS
> diff -puN arch/x86/Kconfig~unconditional-vma-locks arch/x86/Kconfig
> --- a/arch/x86/Kconfig~unconditional-vma-locks  2026-06-10 15:57:53.57735=
1684 -0700
> +++ b/arch/x86/Kconfig  2026-06-10 15:57:54.071369250 -0700
> @@ -27,7 +27,6 @@ config X86_64
>         select ARCH_HAS_GIGANTIC_PAGE
>         select ARCH_SUPPORTS_MSEAL_SYSTEM_MAPPINGS
>         select ARCH_SUPPORTS_INT128 if CC_HAS_INT128
> -       select ARCH_SUPPORTS_PER_VMA_LOCK
>         select ARCH_SUPPORTS_HUGE_PFNMAP if TRANSPARENT_HUGEPAGE
>         select HAVE_ARCH_SOFT_DIRTY
>         select MODULES_USE_ELF_RELA
> @@ -1885,7 +1884,6 @@ config X86_USER_SHADOW_STACK
>         bool "X86 userspace shadow stack"
>         depends on AS_WRUSS
>         depends on X86_64
> -       depends on PER_VMA_LOCK
>         select ARCH_USES_HIGH_VMA_FLAGS
>         select ARCH_HAS_USER_SHADOW_STACK
>         select X86_CET
> diff -puN fs/proc/internal.h~unconditional-vma-locks fs/proc/internal.h
> --- a/fs/proc/internal.h~unconditional-vma-locks        2026-06-10 15:57:=
53.579351755 -0700
> +++ b/fs/proc/internal.h        2026-06-10 15:57:54.071369250 -0700
> @@ -382,10 +382,8 @@ struct mem_size_stats;
>
>  struct proc_maps_locking_ctx {
>         struct mm_struct *mm;
> -#ifdef CONFIG_PER_VMA_LOCK
>         bool mmap_locked;
>         struct vm_area_struct *locked_vma;
> -#endif
>  };
>
>  struct proc_maps_private {
> diff -puN fs/proc/task_mmu.c~unconditional-vma-locks fs/proc/task_mmu.c
> --- a/fs/proc/task_mmu.c~unconditional-vma-locks        2026-06-10 15:57:=
53.594352288 -0700
> +++ b/fs/proc/task_mmu.c        2026-06-10 15:57:54.072369286 -0700
> @@ -130,8 +130,6 @@ static void release_task_mempolicy(struc
>  }
>  #endif
>
> -#ifdef CONFIG_PER_VMA_LOCK
> -

A bunch of these helpers can be removed too but I'll do that cleanup
as a followup. Let's keep this one simple.

>  static void reset_lock_ctx(struct proc_maps_locking_ctx *lock_ctx)
>  {
>         lock_ctx->locked_vma =3D NULL;
> @@ -213,33 +211,6 @@ static inline bool fallback_to_mmap_lock
>         return true;
>  }
>
> -#else /* CONFIG_PER_VMA_LOCK */
> -
> -static inline bool lock_vma_range(struct seq_file *m,
> -                                 struct proc_maps_locking_ctx *lock_ctx)
> -{
> -       return mmap_read_lock_killable(lock_ctx->mm) =3D=3D 0;
> -}
> -
> -static inline void unlock_vma_range(struct proc_maps_locking_ctx *lock_c=
tx)
> -{
> -       mmap_read_unlock(lock_ctx->mm);
> -}
> -
> -static struct vm_area_struct *get_next_vma(struct proc_maps_private *pri=
v,
> -                                          loff_t last_pos)
> -{
> -       return vma_next(&priv->iter);
> -}
> -
> -static inline bool fallback_to_mmap_lock(struct proc_maps_private *priv,
> -                                        loff_t pos)
> -{
> -       return false;
> -}
> -
> -#endif /* CONFIG_PER_VMA_LOCK */
> -
>  static struct vm_area_struct *proc_get_vma(struct seq_file *m, loff_t *p=
pos)
>  {
>         struct proc_maps_private *priv =3D m->private;
> @@ -527,8 +498,6 @@ static int pid_maps_open(struct inode *i
>                 PROCMAP_QUERY_VMA_FLAGS                         \
>  )
>
> -#ifdef CONFIG_PER_VMA_LOCK
> -
>  static int query_vma_setup(struct proc_maps_locking_ctx *lock_ctx)
>  {
>         reset_lock_ctx(lock_ctx);
> @@ -581,26 +550,6 @@ static struct vm_area_struct *query_vma_
>         return vma;
>  }
>
> -#else /* CONFIG_PER_VMA_LOCK */
> -
> -static int query_vma_setup(struct proc_maps_locking_ctx *lock_ctx)
> -{
> -       return mmap_read_lock_killable(lock_ctx->mm);
> -}
> -
> -static void query_vma_teardown(struct proc_maps_locking_ctx *lock_ctx)
> -{
> -       mmap_read_unlock(lock_ctx->mm);
> -}
> -
> -static struct vm_area_struct *query_vma_find_by_addr(struct proc_maps_lo=
cking_ctx *lock_ctx,
> -                                                    unsigned long addr)
> -{
> -       return find_vma(lock_ctx->mm, addr);
> -}
> -
> -#endif  /* CONFIG_PER_VMA_LOCK */
> -
>  static struct vm_area_struct *query_matching_vma(struct proc_maps_lockin=
g_ctx *lock_ctx,
>                                                  unsigned long addr, u32 =
flags)
>  {
> diff -puN include/linux/mmap_lock.h~unconditional-vma-locks include/linux=
/mmap_lock.h
> --- a/include/linux/mmap_lock.h~unconditional-vma-locks 2026-06-10 15:57:=
53.599352466 -0700
> +++ b/include/linux/mmap_lock.h 2026-06-10 15:57:54.072369286 -0700
> @@ -76,8 +76,6 @@ static inline void mmap_assert_write_loc
>         rwsem_assert_held_write(&mm->mmap_lock);
>  }
>
> -#ifdef CONFIG_PER_VMA_LOCK
> -
>  #ifdef CONFIG_LOCKDEP
>  #define __vma_lockdep_map(vma) (&vma->vmlock_dep_map)
>  #else
> @@ -484,52 +482,6 @@ struct vm_area_struct *lock_next_vma(str
>                                      struct vma_iterator *iter,
>                                      unsigned long address);
>
> -#else /* CONFIG_PER_VMA_LOCK */
> -
> -static inline void mm_lock_seqcount_init(struct mm_struct *mm) {}
> -static inline void mm_lock_seqcount_begin(struct mm_struct *mm) {}
> -static inline void mm_lock_seqcount_end(struct mm_struct *mm) {}
> -
> -static inline bool mmap_lock_speculate_try_begin(struct mm_struct *mm, u=
nsigned int *seq)
> -{
> -       return false;
> -}
> -
> -static inline bool mmap_lock_speculate_retry(struct mm_struct *mm, unsig=
ned int seq)
> -{
> -       return true;
> -}
> -static inline void vma_lock_init(struct vm_area_struct *vma, bool reset_=
refcnt) {}
> -static inline void vma_end_read(struct vm_area_struct *vma) {}
> -static inline void vma_start_write(struct vm_area_struct *vma) {}
> -static inline __must_check
> -int vma_start_write_killable(struct vm_area_struct *vma) { return 0; }
> -static inline void vma_assert_write_locked(struct vm_area_struct *vma)
> -               { mmap_assert_write_locked(vma->vm_mm); }
> -static inline void vma_assert_attached(struct vm_area_struct *vma) {}
> -static inline void vma_assert_detached(struct vm_area_struct *vma) {}
> -static inline void vma_mark_attached(struct vm_area_struct *vma) {}
> -static inline void vma_mark_detached(struct vm_area_struct *vma) {}
> -
> -static inline struct vm_area_struct *lock_vma_under_rcu(struct mm_struct=
 *mm,
> -               unsigned long address)
> -{
> -       return NULL;
> -}
> -
> -static inline void vma_assert_locked(struct vm_area_struct *vma)
> -{
> -       mmap_assert_locked(vma->vm_mm);
> -}
> -
> -static inline void vma_assert_stabilised(struct vm_area_struct *vma)
> -{
> -       /* If no VMA locks, then either mmap lock suffices to stabilise. =
*/
> -       mmap_assert_locked(vma->vm_mm);
> -}
> -
> -#endif /* CONFIG_PER_VMA_LOCK */
> -
>  static inline void mmap_write_lock(struct mm_struct *mm)
>  {
>         __mmap_lock_trace_start_locking(mm, true);
> diff -puN include/linux/mm.h~unconditional-vma-locks include/linux/mm.h
> --- a/include/linux/mm.h~unconditional-vma-locks        2026-06-10 15:57:=
53.745357660 -0700
> +++ b/include/linux/mm.h        2026-06-10 15:57:54.073369321 -0700
> @@ -890,7 +890,6 @@ static inline void vma_numab_state_free(
>   * These must be here rather than mmap_lock.h as dependent on vm_fault t=
ype,
>   * declared in this header.
>   */
> -#ifdef CONFIG_PER_VMA_LOCK
>  static inline void release_fault_lock(struct vm_fault *vmf)
>  {
>         if (vmf->flags & FAULT_FLAG_VMA_LOCK)
> @@ -906,17 +905,6 @@ static inline void assert_fault_locked(c
>         else
>                 mmap_assert_locked(vmf->vma->vm_mm);
>  }
> -#else
> -static inline void release_fault_lock(struct vm_fault *vmf)
> -{
> -       mmap_read_unlock(vmf->vma->vm_mm);
> -}
> -
> -static inline void assert_fault_locked(const struct vm_fault *vmf)
> -{
> -       mmap_assert_locked(vmf->vma->vm_mm);
> -}
> -#endif /* CONFIG_PER_VMA_LOCK */
>
>  static inline bool mm_flags_test(int flag, const struct mm_struct *mm)
>  {
> diff -puN include/linux/mm_types.h~unconditional-vma-locks include/linux/=
mm_types.h
> --- a/include/linux/mm_types.h~unconditional-vma-locks  2026-06-10 15:57:=
53.763358300 -0700
> +++ b/include/linux/mm_types.h  2026-06-10 15:57:54.074369357 -0700
> @@ -959,7 +959,6 @@ struct vm_area_struct {
>                 vma_flags_t flags;
>         };
>
> -#ifdef CONFIG_PER_VMA_LOCK
>         /*
>          * Can only be written (using WRITE_ONCE()) while holding both:
>          *  - mmap_lock (in write mode)
> @@ -975,7 +974,7 @@ struct vm_area_struct {
>          * slowpath.
>          */
>         unsigned int vm_lock_seq;
> -#endif
> +
>         /*
>          * A file's MAP_PRIVATE vma can be in both i_mmap tree and anon_v=
ma
>          * list, after a COW of one of the file pages.  A MAP_SHARED vma
> @@ -1007,7 +1006,6 @@ struct vm_area_struct {
>  #ifdef CONFIG_NUMA_BALANCING
>         struct vma_numab_state *numab_state;    /* NUMA Balancing state *=
/
>  #endif
> -#ifdef CONFIG_PER_VMA_LOCK
>         /*
>          * Used to keep track of firstly, whether the VMA is attached, se=
condly,
>          * if attached, how many read locks are taken, and thirdly, if th=
e
> @@ -1050,7 +1048,6 @@ struct vm_area_struct {
>  #ifdef CONFIG_DEBUG_LOCK_ALLOC
>         struct lockdep_map vmlock_dep_map;
>  #endif
> -#endif
>         /*
>          * For areas with an address space and backing store,
>          * linkage into the address_space->i_mmap interval tree.
> @@ -1249,7 +1246,6 @@ struct mm_struct {
>                                           * init_mm.mmlist, and are prote=
cted
>                                           * by mmlist_lock
>                                           */
> -#ifdef CONFIG_PER_VMA_LOCK
>                 struct rcuwait vma_writer_wait;
>                 /*
>                  * This field has lock-like semantics, meaning it is some=
times
> @@ -1269,7 +1265,6 @@ struct mm_struct {
>                  * mmap_lock.
>                  */
>                 seqcount_t mm_lock_seq;
> -#endif
>  #ifdef CONFIG_FUTEX_PRIVATE_HASH
>                 struct mutex                    futex_hash_lock;
>                 struct futex_private_hash       __rcu *futex_phash;
> diff -puN kernel/bpf/task_iter.c~unconditional-vma-locks kernel/bpf/task_=
iter.c
> --- a/kernel/bpf/task_iter.c~unconditional-vma-locks    2026-06-10 15:57:=
53.773358655 -0700
> +++ b/kernel/bpf/task_iter.c    2026-06-10 15:57:54.074369357 -0700
> @@ -835,11 +835,6 @@ __bpf_kfunc int bpf_iter_task_vma_new(st
>         BUILD_BUG_ON(sizeof(struct bpf_iter_task_vma_kern) !=3D sizeof(st=
ruct bpf_iter_task_vma));
>         BUILD_BUG_ON(__alignof__(struct bpf_iter_task_vma_kern) !=3D __al=
ignof__(struct bpf_iter_task_vma));
>
> -       if (!IS_ENABLED(CONFIG_PER_VMA_LOCK)) {
> -               kit->data =3D NULL;
> -               return -EOPNOTSUPP;
> -       }
> -
>         /*
>          * Reject irqs-disabled contexts including NMI. Operations used
>          * by _next() and _destroy() (vma_end_read, fput, bpf_iter_mmput_=
async)
> diff -puN kernel/fork.c~unconditional-vma-locks kernel/fork.c
> --- a/kernel/fork.c~unconditional-vma-locks     2026-06-10 15:57:53.78335=
9011 -0700
> +++ b/kernel/fork.c     2026-06-10 15:57:54.074369357 -0700
> @@ -1067,9 +1067,7 @@ static void mmap_init_lock(struct mm_str
>  {
>         init_rwsem(&mm->mmap_lock);
>         mm_lock_seqcount_init(mm);
> -#ifdef CONFIG_PER_VMA_LOCK
>         rcuwait_init(&mm->vma_writer_wait);
> -#endif
>  }
>
>  static struct mm_struct *mm_init(struct mm_struct *mm, struct task_struc=
t *p,
> diff -puN mm/debug.c~unconditional-vma-locks mm/debug.c
> --- a/mm/debug.c~unconditional-vma-locks        2026-06-10 15:57:53.78535=
9082 -0700
> +++ b/mm/debug.c        2026-06-10 15:57:54.075369392 -0700
> @@ -157,17 +157,13 @@ void dump_vma(const struct vm_area_struc
>         pr_emerg("vma %px start %px end %px mm %px\n"
>                 "prot %lx anon_vma %px vm_ops %px\n"
>                 "pgoff %lx file %px private_data %px\n"
> -#ifdef CONFIG_PER_VMA_LOCK
>                 "refcnt %x\n"
> -#endif
>                 "flags: %#lx(%pGv)\n",
>                 vma, (void *)vma->vm_start, (void *)vma->vm_end, vma->vm_=
mm,
>                 (unsigned long)pgprot_val(vma->vm_page_prot),
>                 vma->anon_vma, vma->vm_ops, vma->vm_pgoff,
>                 vma->vm_file, vma->vm_private_data,
> -#ifdef CONFIG_PER_VMA_LOCK
>                 refcount_read(&vma->vm_refcnt),
> -#endif
>                 vma->vm_flags, &vma->vm_flags);
>  }
>  EXPORT_SYMBOL(dump_vma);
> diff -puN mm/init-mm.c~unconditional-vma-locks mm/init-mm.c
> --- a/mm/init-mm.c~unconditional-vma-locks      2026-06-10 15:57:53.80835=
9899 -0700
> +++ b/mm/init-mm.c      2026-06-10 15:57:54.075369392 -0700
> @@ -39,10 +39,8 @@ struct mm_struct init_mm =3D {
>         .page_table_lock =3D  __SPIN_LOCK_UNLOCKED(init_mm.page_table_loc=
k),
>         .arg_lock       =3D  __SPIN_LOCK_UNLOCKED(init_mm.arg_lock),
>         .mmlist         =3D LIST_HEAD_INIT(init_mm.mmlist),
> -#ifdef CONFIG_PER_VMA_LOCK
>         .vma_writer_wait =3D __RCUWAIT_INITIALIZER(init_mm.vma_writer_wai=
t),
>         .mm_lock_seq    =3D SEQCNT_ZERO(init_mm.mm_lock_seq),
> -#endif
>         .user_ns        =3D &init_user_ns,
>  #ifdef CONFIG_SCHED_MM_CID
>         .mm_cid.lock =3D __RAW_SPIN_LOCK_UNLOCKED(init_mm.mm_cid.lock),
> diff -puN mm/Kconfig~unconditional-vma-locks mm/Kconfig
> --- a/mm/Kconfig~unconditional-vma-locks        2026-06-10 15:57:53.81636=
0183 -0700
> +++ b/mm/Kconfig        2026-06-10 15:57:54.075369392 -0700
> @@ -1394,19 +1394,6 @@ config LRU_GEN_STATS
>  config LRU_GEN_WALKS_MMU
>         def_bool y
>         depends on LRU_GEN && ARCH_HAS_HW_PTE_YOUNG
> -# }
> -
> -config ARCH_SUPPORTS_PER_VMA_LOCK
> -       def_bool n
> -
> -config PER_VMA_LOCK
> -       def_bool y
> -       depends on ARCH_SUPPORTS_PER_VMA_LOCK && MMU && SMP
> -       help
> -         Allow per-vma locking during page fault handling.
> -
> -         This feature allows locking each virtual memory area separately=
 when
> -         handling page faults instead of taking mmap_lock.
>
>  config LOCK_MM_AND_FIND_VMA
>         bool
> diff -puN mm/Kconfig.debug~unconditional-vma-locks mm/Kconfig.debug
> --- a/mm/Kconfig.debug~unconditional-vma-locks  2026-06-10 15:57:53.82036=
0326 -0700
> +++ b/mm/Kconfig.debug  2026-06-10 15:57:54.075369392 -0700
> @@ -310,7 +310,6 @@ config DEBUG_KMEMLEAK_VERBOSE
>
>  config PER_VMA_LOCK_STATS
>         bool "Statistics for per-vma locks"
> -       depends on PER_VMA_LOCK
>         help
>           Say Y here to enable success, retry and failure counters of pag=
e
>           faults handled under protection of per-vma locks. When enabled,=
 the
> diff -puN mm/memory.c~unconditional-vma-locks mm/memory.c
> --- a/mm/memory.c~unconditional-vma-locks       2026-06-10 15:57:53.83036=
0681 -0700
> +++ b/mm/memory.c       2026-06-10 15:57:54.076369428 -0700
> @@ -6659,7 +6659,6 @@ static vm_fault_t sanitize_fault_flags(s
>                                  !is_cow_mapping(vma->vm_flags)))
>                         return VM_FAULT_SIGSEGV;
>         }
> -#ifdef CONFIG_PER_VMA_LOCK
>         /*
>          * Per-VMA locks can't be used with FAULT_FLAG_RETRY_NOWAIT becau=
se of
>          * the assumption that lock is dropped on VM_FAULT_RETRY.
> @@ -6668,7 +6667,6 @@ static vm_fault_t sanitize_fault_flags(s
>                         (FAULT_FLAG_VMA_LOCK | FAULT_FLAG_RETRY_NOWAIT)) =
=3D=3D
>                         (FAULT_FLAG_VMA_LOCK | FAULT_FLAG_RETRY_NOWAIT)))
>                 return VM_FAULT_SIGSEGV;
> -#endif
>
>         return 0;
>  }
> diff -puN mm/mmap_lock.c~unconditional-vma-locks mm/mmap_lock.c
> --- a/mm/mmap_lock.c~unconditional-vma-locks    2026-06-10 15:57:53.83436=
0824 -0700
> +++ b/mm/mmap_lock.c    2026-06-10 15:57:54.077369463 -0700
> @@ -43,9 +43,6 @@ void __mmap_lock_do_trace_released(struc
>  EXPORT_SYMBOL(__mmap_lock_do_trace_released);
>  #endif /* CONFIG_TRACING */
>
> -#ifdef CONFIG_MMU
> -#ifdef CONFIG_PER_VMA_LOCK
> -
>  /* State shared across __vma_[start, end]_exclude_readers. */
>  struct vma_exclude_readers_state {
>         /* Input parameters. */
> @@ -431,7 +428,6 @@ fallback:
>
>         return vma;
>  }
> -#endif /* CONFIG_PER_VMA_LOCK */
>
>  #ifdef CONFIG_LOCK_MM_AND_FIND_VMA
>  #include <linux/extable.h>
> @@ -548,23 +544,3 @@ fail:
>         return NULL;
>  }
>  #endif /* CONFIG_LOCK_MM_AND_FIND_VMA */
> -
> -#else /* CONFIG_MMU */
> -
> -/*
> - * At least xtensa ends up having protection faults even with no
> - * MMU.. No stack expansion, at least.
> - */
> -struct vm_area_struct *lock_mm_and_find_vma(struct mm_struct *mm,
> -                       unsigned long addr, struct pt_regs *regs)
> -{
> -       struct vm_area_struct *vma;
> -
> -       mmap_read_lock(mm);
> -       vma =3D vma_lookup(mm, addr);
> -       if (!vma)
> -               mmap_read_unlock(mm);
> -       return vma;
> -}

Might this removal break CONFIG_MMU=3Dn && CONFIG_LOCK_MM_AND_FIND_VMA=3Dn =
case?


> -
> -#endif /* CONFIG_MMU */
> diff -puN mm/pagewalk.c~unconditional-vma-locks mm/pagewalk.c
> --- a/mm/pagewalk.c~unconditional-vma-locks     2026-06-10 15:57:53.85136=
1429 -0700
> +++ b/mm/pagewalk.c     2026-06-10 15:57:54.077369463 -0700
> @@ -446,7 +446,6 @@ static inline void process_mm_walk_lock(
>  static inline void process_vma_walk_lock(struct vm_area_struct *vma,
>                                          enum page_walk_lock walk_lock)
>  {
> -#ifdef CONFIG_PER_VMA_LOCK
>         switch (walk_lock) {
>         case PGWALK_WRLOCK:
>                 vma_start_write(vma);
> @@ -461,7 +460,6 @@ static inline void process_vma_walk_lock
>                 /* PGWALK_RDLOCK is handled by process_mm_walk_lock */
>                 break;
>         }
> -#endif
>  }
>
>  /*
> diff -puN mm/rmap.c~unconditional-vma-locks mm/rmap.c
> --- a/mm/rmap.c~unconditional-vma-locks 2026-06-10 15:57:54.018367366 -07=
00
> +++ b/mm/rmap.c 2026-06-10 15:57:54.077369463 -0700
> @@ -260,11 +260,9 @@ static void check_anon_vma_clone(struct
>         /* For the anon_vma to be compatible, it can only be singular. */
>         VM_WARN_ON_ONCE(operation =3D=3D VMA_OP_MERGE_UNFAULTED &&
>                         !list_is_singular(&src->anon_vma_chain));
> -#ifdef CONFIG_PER_VMA_LOCK
>         /* Only merging an unfaulted VMA leaves the destination attached.=
 */
>         VM_WARN_ON_ONCE(operation !=3D VMA_OP_MERGE_UNFAULTED &&
>                         vma_is_attached(dst));
> -#endif
>  }
>
>  static void maybe_reuse_anon_vma(struct vm_area_struct *dst,
> diff -puN mm/userfaultfd.c~unconditional-vma-locks mm/userfaultfd.c
> --- a/mm/userfaultfd.c~unconditional-vma-locks  2026-06-10 15:57:54.04936=
8468 -0700
> +++ b/mm/userfaultfd.c  2026-06-10 15:57:54.078369499 -0700
> @@ -104,7 +104,6 @@ struct vm_area_struct *find_vma_and_prep
>         return vma;
>  }
>
> -#ifdef CONFIG_PER_VMA_LOCK
>  /*
>   * uffd_lock_vma() - Lookup and lock vma corresponding to @address.
>   * @mm: mm to search vma in.
> @@ -164,34 +163,6 @@ static void uffd_mfill_unlock(struct vm_
>         vma_end_read(vma);
>  }
>
> -#else
> -
> -static struct vm_area_struct *uffd_mfill_lock(struct mm_struct *dst_mm,
> -                                             unsigned long dst_start,
> -                                             unsigned long len)
> -{
> -       struct vm_area_struct *dst_vma;
> -
> -       mmap_read_lock(dst_mm);
> -       dst_vma =3D find_vma_and_prepare_anon(dst_mm, dst_start);
> -       if (IS_ERR(dst_vma))
> -               goto out_unlock;
> -
> -       if (validate_dst_vma(dst_vma, dst_start + len))
> -               return dst_vma;
> -
> -       dst_vma =3D ERR_PTR(-ENOENT);
> -out_unlock:
> -       mmap_read_unlock(dst_mm);
> -       return dst_vma;
> -}
> -
> -static void uffd_mfill_unlock(struct vm_area_struct *vma)
> -{
> -       mmap_read_unlock(vma->vm_mm);
> -}
> -#endif
> -
>  static void mfill_put_vma(struct mfill_state *state)
>  {
>         if (!state->vma)
> @@ -1672,7 +1643,6 @@ out_success:
>         return 0;
>  }
>
> -#ifdef CONFIG_PER_VMA_LOCK
>  static int uffd_move_lock(struct mm_struct *mm,
>                           unsigned long dst_start,
>                           unsigned long src_start,
> @@ -1747,31 +1717,6 @@ static void uffd_move_unlock(struct vm_a
>                 vma_end_read(dst_vma);
>  }
>
> -#else
> -
> -static int uffd_move_lock(struct mm_struct *mm,
> -                         unsigned long dst_start,
> -                         unsigned long src_start,
> -                         struct vm_area_struct **dst_vmap,
> -                         struct vm_area_struct **src_vmap)
> -{
> -       int err;
> -
> -       mmap_read_lock(mm);
> -       err =3D find_vmas_mm_locked(mm, dst_start, src_start, dst_vmap, s=
rc_vmap);
> -       if (err)
> -               mmap_read_unlock(mm);
> -       return err;
> -}
> -
> -static void uffd_move_unlock(struct vm_area_struct *dst_vma,
> -                            struct vm_area_struct *src_vma)
> -{
> -       mmap_assert_locked(src_vma->vm_mm);
> -       mmap_read_unlock(dst_vma->vm_mm);
> -}
> -#endif
> -
>  /**
>   * move_pages - move arbitrary anonymous pages of an existing vma
>   * @ctx: pointer to the userfaultfd context
> diff -puN rust/kernel/mm.rs~unconditional-vma-locks rust/kernel/mm.rs
> --- a/rust/kernel/mm.rs~unconditional-vma-locks 2026-06-10 15:57:54.05136=
8539 -0700
> +++ b/rust/kernel/mm.rs 2026-06-10 15:57:54.078369499 -0700
> @@ -174,7 +174,6 @@ impl MmWithUser {
>      /// When per-vma locks are disabled, this always returns `None`.
>      #[inline]
>      pub fn lock_vma_under_rcu(&self, vma_addr: usize) -> Option<VmaReadG=
uard<'_>> {
> -        #[cfg(CONFIG_PER_VMA_LOCK)]
>          {
>              // SAFETY: Calling `bindings::lock_vma_under_rcu` is always =
okay given an mm where
>              // `mm_users` is non-zero.
> @@ -188,12 +187,6 @@ impl MmWithUser {
>                  });
>              }
>          }
> -
> -        // Silence warnings about unused variables.
> -        #[cfg(not(CONFIG_PER_VMA_LOCK))]
> -        let _ =3D vma_addr;
> -
> -        None
>      }
>
>      /// Lock the mmap read lock.
> diff -puN tools/testing/vma/include/dup.h~unconditional-vma-locks tools/t=
esting/vma/include/dup.h
> --- a/tools/testing/vma/include/dup.h~unconditional-vma-locks   2026-06-1=
0 15:57:54.064369001 -0700
> +++ b/tools/testing/vma/include/dup.h   2026-06-10 15:57:54.078369499 -07=
00
> @@ -569,7 +569,6 @@ struct vm_area_struct {
>                 vma_flags_t flags;
>         };
>
> -#ifdef CONFIG_PER_VMA_LOCK
>         /*
>          * Can only be written (using WRITE_ONCE()) while holding both:
>          *  - mmap_lock (in write mode)
> @@ -585,7 +584,6 @@ struct vm_area_struct {
>          * slowpath.
>          */
>         unsigned int vm_lock_seq;
> -#endif
>
>         /*
>          * A file's MAP_PRIVATE vma can be in both i_mmap tree and anon_v=
ma
> @@ -618,10 +616,8 @@ struct vm_area_struct {
>  #ifdef CONFIG_NUMA_BALANCING
>         struct vma_numab_state *numab_state;    /* NUMA Balancing state *=
/
>  #endif
> -#ifdef CONFIG_PER_VMA_LOCK
>         /* Unstable RCU readers are allowed to read this. */
>         refcount_t vm_refcnt;
> -#endif
>         /*
>          * For areas with an address space and backing store,
>          * linkage into the address_space->i_mmap interval tree.
> diff -puN tools/testing/vma/vma_internal.h~unconditional-vma-locks tools/=
testing/vma/vma_internal.h
> --- a/tools/testing/vma/vma_internal.h~unconditional-vma-locks  2026-06-1=
0 15:57:54.066369072 -0700
> +++ b/tools/testing/vma/vma_internal.h  2026-06-10 15:57:54.078369499 -07=
00
> @@ -15,7 +15,6 @@
>  #include <stdlib.h>
>
>  #define CONFIG_MMU
> -#define CONFIG_PER_VMA_LOCK
>
>  #ifdef __CONCAT
>  #undef __CONCAT
> _

