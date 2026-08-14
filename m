Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BE6C0C5B572
	for <linux-mm@archiver.kernel.org>; Fri, 14 Aug 2026 20:33:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 904746B0320; Fri, 14 Aug 2026 16:33:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8B4966B0323; Fri, 14 Aug 2026 16:33:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 735F66B0326; Fri, 14 Aug 2026 16:33:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3FE166B0320
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 16:33:17 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B0A1DC0276
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 20:33:16 +0000 (UTC)
X-FDA: 85101024792.04.3571BF2
Received: from mail-qt1-f177.google.com (mail-qt1-f177.google.com [209.85.160.177])
	by imf11.hostedemail.com (Postfix) with ESMTP id B62D740004
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 20:33:14 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=h6e8akJr;
	spf=pass (imf11.hostedemail.com: domain of surenb@google.com designates 209.85.160.177 as permitted sender) smtp.mailfrom=surenb@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1786739594;
	b=ZytLmDN41izqoOpXJkIw/vMwLUN7g8b2pa9Bb4PZ6BJPlgYygph1LcclbKxCHjxImnvWce
	wJVvdxpm2vmwl95nAOkU9zZgsZ+oTPsfDiKSXwceL3dHy7aA8YUSS8/fwPSz1XIEoedklw
	L87XjZ0C8evnEVNkayVvMfAXzTMKuO0=
ARC-Authentication-Results: i=2;
	imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=h6e8akJr;
	spf=pass (imf11.hostedemail.com: domain of surenb@google.com designates 209.85.160.177 as permitted sender) smtp.mailfrom=surenb@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786739594;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=diV8ZyWOXiwFLeaKQirjN9/tN/ZC3QnY567JJpTflm8=;
	b=2ozTxGUYUBzIi5F7n0V55Z5qFyhB4rfvDw2n07US+tDegSe7vkU5uLFT8NA4X0zgBVO3uf
	Mas/jRA9cZH4FBBbqKyoJnXWPIM9NkHXX9z1ZIIfKf6RgzFBziM52z6afgcqLiRPCqEpj4
	LGN4TZw3jwf7gp8Tlj4IVjWDMwHCjbo=
Received: by mail-qt1-f177.google.com with SMTP id d75a77b69052e-51c10ed63c0so347011cf.1
        for <linux-mm@kvack.org>; Fri, 14 Aug 2026 13:33:14 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1786739594; cv=none;
        d=google.com; s=arc-20260327;
        b=sYaEMdzOnnGAY1TDVQ4D0YIuGOSFvEvsMPO0PPU0GosOEYMl04vDCasLVi3Im37/Yq
         bw/UJ5ZJLow4l2diIJ6229zUCwW84Dg+j3Toe/hzh5YLE1lXNe3PQlebrWY9It8BI80J
         pz75gA2IbmJ00dY9xSddLTeHXWjgJSrh7crlB+e8IB0Q+THiLwJIkUTa8CP/pdlIcV8B
         IPxrUx+jHE+WQzjtexFWbDuCa/uB9HSW/BALvhXsIpGMBdzQtJYl+tT1UW2XEn+NdpaU
         fpbdhuhnOctoC+FTMPevw4nxfiTLz3DDztN+U/imL2+FdQDBKmFIfG9qc8hFQ0Lj7PL2
         XPiA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=diV8ZyWOXiwFLeaKQirjN9/tN/ZC3QnY567JJpTflm8=;
        fh=LuueXOxZOSYMhA1mrMrsAjNWhC0iMG36AC3dGSMQy4g=;
        b=LQUmb4ICmo2ehtSdrOtuSAf8ZArWr2aEWIIHOP6G2uNqaKxiK1955GUpVCv27GUR9O
         sHLFqD4gS4V/TP2H8d69PtZvZ6Ogwp1HBS2dPBZ5vJWZ8WLK9+X+pB4K18H4UKlD8NUR
         eRqx6cllF9pdKtQMK+V5aVjjm9dDE5CLgFK0e0urzSKo6ebqO/8ufamVdPyH9DW5x7aD
         nhvmw23FbwdMYbncO3tp/dxcYcYecpczLeHUYtS1wbjTZ3ZAuIf4Srqi68Xr77pB4Fj7
         f2OMOZS3i9XhQ9FDMuMHEThn4LMAXmRlifOFth5jqMJX7swgTUsPQymgIwaWFtfbT3TG
         9yBQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1786739594; x=1787344394; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=diV8ZyWOXiwFLeaKQirjN9/tN/ZC3QnY567JJpTflm8=;
        b=h6e8akJrK4QKrm+6IRJdf1b4wVaVxw3yAAqBgWathzM5d9jMQgRYjSGSHOkMLVvhJl
         y75nYFd8tqpo6+nZ3D0IkA/R8oAPMRqMOALAoPlC9GM2+UVgI454RQjcTr3l1gkAPFx0
         UJfsT5kJZWTnXpGviJCOGbHDBgUXnzwKSZtGie9914dKe2kxdD70DVFHWx03rMclkLIm
         T6Y83Vg4LAWbF1MXHbi1x2dkDewEmIYOy4vRDqXTZGgB4QR+7pf2kErmGv6A+f+psN2V
         bQweHAJzsD2HJxrNTL4EIX7EkQ0IlXnpYIBmKJDWMcFZVt7Sxuzb6D0F/QaSHUPGuf13
         guCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786739594; x=1787344394;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=diV8ZyWOXiwFLeaKQirjN9/tN/ZC3QnY567JJpTflm8=;
        b=rSbpOBWXyo5jKbkLTSsxqE8XgleWSrffyxuoI/2nF/CfWwUnZCxGfWQ6JyaxqkYv4S
         7ToT80QVEpWB91YrHyE4VYagjH0nOaSR983Y/0OC0xTDcO8mLt7NOiV7N6QGzDccMcV5
         tdENCPXXDTYZ8YncHMWU9Fo7M+DG+MdxKRD9Al/1vttmOoXd67L2c/LdZDxuk4AX7EF1
         kUiZmYy5R7Pvmt5cmuqhkbxH22K3xab4hIiXRlyRpnxilMf3HFOPf1H6JQYj9dFpU4jn
         Yaplzps6LzTrDxdWZOc40q6BJSUm/YGE/Y7I+e9UYyYQNydLPf16Ko68LGpGbHRGWxVV
         D4eg==
X-Forwarded-Encrypted: i=1; AHgh+RpD42CxlSmZj8aaYYKHLfBorUL8ISuuz5tXw7kuGlOIsoBNq/6k7k+GxX+RfWNiaHoNIoMgrUJp1A==@kvack.org
X-Gm-Message-State: AOJu0YxDf9TRVPHNP1c3YAUkaGa6o4V0qu9mrDlCdcjBqbvJPf8jXPaA
	2xBIM77YoMriMUfLPWzbcB1vYarzb2s9ITcM21eLbjVATh2eJ8ZFbLrl0zXfSRkx0Bgze+XZ865
	PyZnsBROKZfYJ1iNMaErAXruq3tsPqD9nE5zW9MQv
X-Gm-Gg: AR+sD122nqnmcAtygjcrYNhsjrHaV0DGOzWbrMJlcWc8iRHKu9833muOeYf7cj4KB0s
	uxkY7OWP+fudDo80H7MJhWBTRLJuwWOAFR48NH54A6RrFOLYahQPFuBMTvvV5vtQOboxwg/7Yo0
	C2Hgf+xSpF0N8oj25Jpe44ahDtzedGCLi2a8cQ9A1mYakVWIHsY6KTQIYfasqEF/440Sw6hWET2
	TGJ1w6efUZ6N0hIqngqnGVLRFFIqcJ8io+Xm4x4nVn2SsUraNaInJvyjJWfHJf/NNVPOsfIB0QE
	HgrjGiUH4pj1pg4Fm/TaJblcN/jewq3ZeZD+DXgvWAQ=
X-Received: by 2002:ac8:5f8b:0:b0:50d:edb1:6bd1 with SMTP id
 d75a77b69052e-52d8631482dmr4697751cf.13.1786739592773; Fri, 14 Aug 2026
 13:33:12 -0700 (PDT)
MIME-Version: 1.0
References: <20260813193433.3318288-1-surenb@google.com> <20260813193433.3318288-2-surenb@google.com>
 <an8ZAE0MX05t5EZz@lucifer>
In-Reply-To: <an8ZAE0MX05t5EZz@lucifer>
From: Suren Baghdasaryan <surenb@google.com>
Date: Fri, 14 Aug 2026 13:33:00 -0700
X-Gm-Features: AcwNN1WFR8l3_ouzlVZt3HqQMG5MvSjjJwi665cJQfA-cVvMCJaU82MWHnQt4n8
Message-ID: <CAJuCfpHq-C3utgDdsFmFtUs3-dctnCGSuiQe_3XkN8XsoONFhw@mail.gmail.com>
Subject: Re: [PATCH v6 1/5] mm: Make per-VMA locks available universally
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: akpm@linux-foundation.org, dave.hansen@linux.intel.com, 
	Liam.Howlett@oracle.com, david@redhat.com, willy@infradead.org, 
	shakeel.butt@linux.dev, vbabka@kernel.org, jannh@google.com, 
	aliceryhl@google.com, arve@android.com, cmllamas@google.com, 
	christian@brauner.io, tkjos@android.com, dsahern@kernel.org, 
	davem@davemloft.net, gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: B62D740004
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: bd8webpedo9u3q3dp1tw5hrx7x13hj9u
X-HE-Tag: 1786739594-121307
X-HE-Meta: U2FsdGVkX1/AZc1Oad0V3b+QGYz4m1KJ+86dnAHUypXWWL5kCctAIBNM/dtTjQv6Kmt1QCMNhTwVd6vbNLxf6lQSNRZw5hdo6DbwC5rNo10ozhN84kTjBCp6Kau6z4X7OvDY5ywQnWVJfurMu4qT7jbCUOiXdoqvLbANmzWAwQrTCvwCwB3+5m1FrGudLarWCNJcbbfacXN2GBG/z41VwTEsP4KGSpFX/NBiouNbxY/ZhZQePQ+F04e4PO+xF2BgaHJxT2zamcQbvVQ2d8c+6ok81ma33Tz+6cluKv8Mrk0c70MfPDaXFLNdpK6JH9UqSTONIq89OOMlecvVRhuq17v2Ip024oefiyv5HtzLu2UmtR34bzz+5J45yEEABzCsUDBATgyIVGQ3eX/+MpaDeZ4sbuVu88KfNmL0ODec9r+LVJTTC3MwG0EHeJMr6Clxvc6fiy+qNEOwDUkqA1R5gzgT8wsXXVIn04D3DN2UettYE+sAoeYd9UpeVWd2Y49FZg/iz9Vmc1i6afOz0+WuUII/48+VYpMZPZydfUJekXKlgZ9KJReaGosbgYmG4TC5DD8QB4EP7X20VshBOTQ6xE21bH+IJVffxgMB9GC9gYEo1G+eaTJd/Wq/h8zbadxsu+ZYN+fuxeycpmlel6A0k1VB8JS19tk1shkwJf6q/7iZ604OSUByj5qOeGxi6eAJPdpjozNyIpDS2LCk6wUhtb8nncv69twefq99xLiBhMrf7mvdkQMDYNFQZuWJvlaz83kD0IIHLCiYQsqYvhCZ5Alchlvq+enCy8P4bGMQwy9TAKgt67KwcFaeb2pMbJ4Ond0H9ZEmCA/SUw+FaAee/9NiqOr7F0Kaa3bpNJ0l9Q7OoX7vPE/o5qk0ohkGhbtIEfXXn11UfdPP5sJyYtvOmJUZCgWrWSID2qNR2Ra2C1betEAE3U7cmLA+RgkSKkSA0VBqQUXlfV0N7ZRqhNr
 KJcQcFps
 RFyh9pG9rWCneOvYve9TUVFw9zcA8FyS6ndTPR/2zxSrFcKL+jny68LgStCYN1A3jO4vc+tKkmpe44OhDFNGEtq+m0slYjc+RxbtXKPi+zF1F/HqHW9jS+iC+hjxmrCVGtCmEcjXVY5L6ptmCzSAbSxNH4I1avlJ4iNDmnlrI0o6CNar5Jk/6TRpH5PlACk615FykKqs30jDM99I6hufylVY6qfrzulVSzqW57dV2ldWxo6QO2+xxGE77mguG3tiRr3r/K3Dmc97ZZmYxphtLvM1B35w8ky8SCCd2jxUJeMHc401rVvy3lp/u5gg139tjPy/NFDLSL90gKkY0uk+lN9IVIXyODimPY0p9yYkrqAN6AHXO1dtG5XwJZ4Wz6ijk58dMP9Iuo/qEY1iLnPg4iKOBRwlTzw7thj03Ss/yHy91b8rzeMEUlEBswL560hjB8tMSQPQtd5gBTSN3CI4o1YtWgsKFnP1F20QN9WJyIhfSdXvE62bIledMUQUmrqdvbllcXTOoN8HxSaq5MO3hT2DAIHKZjuhRAAdegoi3/aSMu/nWr4xWLn5jvmY+yhW5gcjhd++VJwLd9ZIWn5qM13f/Dt3/AJm6e4UfjD0sgM6m7ImynH/+K80EjEK2cFdUfAgE8rOHjY/5aVMqhPTI9enL6hEnLA5iVPO3f8jXFjE5FEdr/yjm6nmrP8NhLEbdOPrO
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 14, 2026 at 12:03=E2=80=AFPM Lorenzo Stoakes (ARM) <ljs@kernel.=
org> wrote:
>
> On Thu, Aug 13, 2026 at 12:34:29PM -0700, Suren Baghdasaryan wrote:
> > From: Dave Hansen <dave.hansen@linux.intel.com>
> >
> > The per-VMA locks have been around for several years. They've had some
> > bugs worked out of them and have seen quite wide use. However, they
> > are still only available when architectures explicitly enable them.
> > Remove the conditional compilation around the per-VMA locks, making
> > them available on all architectures and configs.
> >
> > The approach up to now seemed to be to add ARCH_SUPPORTS_PER_VMA_LOCK
> > when the architecture started using per-VMA locks in the fault
> > handler. But, contrary to the naming, the Kconfig option does not
> > really indicate whether the architecture supports per-VMA locks or
> > not. It is more of a marker for whether the architecture is likely to
> > benefit from per-VMA locks.
> >
> > To me, the most important thing side-effect of universal availability
> > is letting per-VMA locks be used in SMP=3Dn configs. This lets us use
> > per-VMA locking in all x86 code without fallbacks.
> >
> > Overall, this just generally makes the kernel simpler. Just look at
> > the diffstat. It also opens the door to users that want to use the
> > per-VMA locks in common code. Doing *that* brings additional
> > simplifications.
> >
> > The downside of this is adding some fields to vm_area_struct and
> > mm_struct. There are likely ways to optimize this, especially for
> > things like SMP=3Dn configs. For now, do the simplest thing: use the
> > same implementation everywhere.
> >
> > =3D=3D Considerations for NOMMU config =3D=3D
> >
> > NOMMU systems do not write-lock VMAs, therefore read-locking a VMA
> > would always succeed unless VMA is detached. Therefore for NOMMU
> > config we make vma_mark_attached() a NOOP, which keeps VMAs always in
> > detached state. This causes VMA read-locking to always fail and the
> > caller falls back to locking mmap_lock.
> >
> > The following functions will have a different implementation in NOMMU
> > config:
> >
> > - vma_mark_attached(), vma_mark_detached() are made NOOPs, keeping VMAs
> > always in a detached state and preventing assertions and refcount
> > underflows;
> >
> > - vma_start_write(), vma_start_write_killable() are made NOOPs to avoid
> > warnings in __vma_start_write() due to VMAs being detached.
> > These functions are not used in NOMMU code but __vma_start_write()
> > is an exported function, therefore might be used by drivers.
> >
> > - vma_assert_attached() is made NOOP because it's reachable from NOMMU
> > code via split_vma()->vma_iter_store_new()->vma_iter_store_overwrite();
> >
> > - vma_assert_write_locked() is asserting vma->vm_mm is write-locked, as
> > was done before this change;
> >
> > - vma_assert_locked() is asserting vma->vm_mm is locked, as was done
> > before this change;
> >
> > The following functions work for both MMU and NOMMU configs:
> >
> > - vma_lock_init() performs the same initialization as for MMU config;
> >
> > - mm_lock_seqcount_init(), mm_lock_seqcount_begin(), mm_lock_seqcount_e=
nd()
> > are called from mmap_write_{lock|unlock} and update mm_lock_seq correct=
ly.
> >
> > - mmap_lock_speculate_try_begin(), mmap_lock_speculate_retry() work as =
is
> > because mm_lock_seq is updated correctly;
> >
> > - vma_start_read(), vma_start_read_locked() will always fail because VM=
As
> > are always detached;
> >
> > - vma_end_read() will never be called because vma_start_read() never
> > succeeds;
> >
> > - vma_is_attached() always return false because VMAs are always detache=
d;
> >
> > - vma_assert_detached() will never trigger because VMAs are never attac=
hed;
> >
> > - vma_start_read_locked() always return false because VMAs are always
> > detached;
> >
> > - lock_vma_under_rcu() will be safe as the attempted read lock will bai=
l;
> >
> > Changes in the following files are not affecting NOMMU config:
> >
> > task_mmu.c - not compiled when CONFIG_MMU=3Dn;
> > pagewalk.c - not compiled when CONFIG_MMU=3Dn;
> > userfaultfd.c - not compiled when CONFIG_MMU=3Dn (CONFIG_USERFAULTFD de=
pends
> > on CONFIG_MMU);
> >
> > The following changes in the BPF code are made to keep NOMMU config
> > working like before:
> >
> > stack_map_lock_vma() - keeps mmap_lock in NOMMU config;
> > bpf_iter_task_vma_new() - bails out in NOMMU config;
> >
> > Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
> > Cc: Suren Baghdasaryan <surenb@google.com>
> > Cc: Andrew Morton <akpm@linux-foundation.org>
> > Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
> > Cc: Lorenzo Stoakes <ljs@kernel.org>
> > Cc: Vlastimil Babka <vbabka@kernel.org>
> > Cc: Shakeel Butt <shakeel.butt@linux.dev>
> > Cc: linux-mm@kvack.org
> > Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > Cc: Arve Hj=C3=B8nnev=C3=A5g <arve@android.com>
> > Cc: Todd Kjos <tkjos@android.com>
> > Cc: Christian Brauner <christian@brauner.io>
> > Cc: Carlos Llamas <cmllamas@google.com>
> > Cc: Alice Ryhl <aliceryhl@google.com>
> > Cc: David S. Miller <davem@davemloft.net>
> > Cc: David Ahern <dsahern@kernel.org>
> > Cc: netdev@vger.kernel.org
> > Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
> > Signed-off-by: Suren Baghdasaryan <surenb@google.com>
>
> LGTM so:
>
> Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Thanks!

>
> > ---
> >  arch/arm/Kconfig                       |  1 -
> >  arch/arm64/Kconfig                     |  1 -
> >  arch/loongarch/Kconfig                 |  1 -
> >  arch/powerpc/platforms/powernv/Kconfig |  1 -
> >  arch/powerpc/platforms/pseries/Kconfig |  1 -
> >  arch/riscv/Kconfig                     |  1 -
> >  arch/s390/Kconfig                      |  1 -
> >  arch/x86/Kconfig                       |  2 -
> >  fs/proc/internal.h                     |  2 -
> >  fs/proc/task_mmu.c                     | 93 --------------------------
> >  include/linux/mm.h                     | 12 ----
> >  include/linux/mm_types.h               |  8 +--
> >  include/linux/mmap_lock.h              | 75 +++++++--------------
> >  kernel/bpf/stackmap.c                  | 17 ++---
> >  kernel/bpf/task_iter.c                 |  2 +-
> >  kernel/fork.c                          |  2 -
> >  mm/Kconfig                             | 12 ----
> >  mm/Kconfig.debug                       |  1 -
> >  mm/debug.c                             |  4 --
> >  mm/init-mm.c                           |  2 -
> >  mm/memory.c                            |  2 -
> >  mm/mmap_lock.c                         | 26 +------
> >  mm/pagewalk.c                          |  2 -
> >  mm/rmap.c                              |  2 -
> >  mm/userfaultfd.c                       | 55 ---------------
> >  rust/kernel/mm.rs                      | 32 +++------
> >  tools/testing/vma/include/dup.h        |  5 +-
> >  tools/testing/vma/vma_internal.h       |  1 -
> >  28 files changed, 48 insertions(+), 316 deletions(-)
> >
> > diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
> > index 9187240a02db..f815209167cd 100644
> > --- a/arch/arm/Kconfig
> > +++ b/arch/arm/Kconfig
> > @@ -41,7 +41,6 @@ config ARM
> >       select ARCH_SUPPORTS_ATOMIC_RMW
> >       select ARCH_SUPPORTS_CFI
> >       select ARCH_SUPPORTS_HUGETLBFS if ARM_LPAE
> > -     select ARCH_SUPPORTS_PER_VMA_LOCK
> >       select ARCH_SUPPORTS_RT
> >       select ARCH_USE_BUILTIN_BSWAP
> >       select ARCH_USE_CMPXCHG_LOCKREF
> > diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
> > index 11a9c534b7b4..21eb64b24a2c 100644
> > --- a/arch/arm64/Kconfig
> > +++ b/arch/arm64/Kconfig
> > @@ -81,7 +81,6 @@ config ARM64
> >       select ARCH_HAS_PTE_PROTNONE
> >       select ARCH_SUPPORTS_NUMA_BALANCING
> >       select ARCH_SUPPORTS_PAGE_TABLE_CHECK
> > -     select ARCH_SUPPORTS_PER_VMA_LOCK
> >       select ARCH_SUPPORTS_HUGE_PFNMAP if TRANSPARENT_HUGEPAGE
> >       select ARCH_SUPPORTS_RT
> >       select ARCH_SUPPORTS_SCHED_SMT
> > diff --git a/arch/loongarch/Kconfig b/arch/loongarch/Kconfig
> > index e20acbe5fe7b..7741e39eca2b 100644
> > --- a/arch/loongarch/Kconfig
> > +++ b/arch/loongarch/Kconfig
> > @@ -69,7 +69,6 @@ config LOONGARCH
> >       select ARCH_SUPPORTS_MSEAL_SYSTEM_MAPPINGS
> >       select ARCH_HAS_PTE_PROTNONE if 64BIT
> >       select ARCH_SUPPORTS_NUMA_BALANCING if NUMA
> > -     select ARCH_SUPPORTS_PER_VMA_LOCK
> >       select ARCH_SUPPORTS_RT
> >       select ARCH_SUPPORTS_SCHED_SMT if SMP
> >       select ARCH_SUPPORTS_SCHED_MC  if SMP
> > diff --git a/arch/powerpc/platforms/powernv/Kconfig b/arch/powerpc/plat=
forms/powernv/Kconfig
> > index b5ad7c173ef0..dd8f6060fb7a 100644
> > --- a/arch/powerpc/platforms/powernv/Kconfig
> > +++ b/arch/powerpc/platforms/powernv/Kconfig
> > @@ -17,7 +17,6 @@ config PPC_POWERNV
> >       select PPC_DOORBELL
> >       select MMU_NOTIFIER
> >       select FORCE_SMP
> > -     select ARCH_SUPPORTS_PER_VMA_LOCK
> >       select PPC_RADIX_BROADCAST_TLBIE if PPC_RADIX_MMU
> >       default y
> >
> > diff --git a/arch/powerpc/platforms/pseries/Kconfig b/arch/powerpc/plat=
forms/pseries/Kconfig
> > index 74910ce3a541..7d125e288f6e 100644
> > --- a/arch/powerpc/platforms/pseries/Kconfig
> > +++ b/arch/powerpc/platforms/pseries/Kconfig
> > @@ -23,7 +23,6 @@ config PPC_PSERIES
> >       select HOTPLUG_CPU
> >       select FORCE_SMP
> >       select SWIOTLB
> > -     select ARCH_SUPPORTS_PER_VMA_LOCK
> >       select PPC_RADIX_BROADCAST_TLBIE if PPC_RADIX_MMU
> >       default y
> >
> > diff --git a/arch/riscv/Kconfig b/arch/riscv/Kconfig
> > index 7b9c373d82fa..faa85a031fe5 100644
> > --- a/arch/riscv/Kconfig
> > +++ b/arch/riscv/Kconfig
> > @@ -70,7 +70,6 @@ config RISCV
> >       select ARCH_SUPPORTS_LTO_CLANG_THIN
> >       select ARCH_SUPPORTS_MSEAL_SYSTEM_MAPPINGS if 64BIT && MMU
> >       select ARCH_SUPPORTS_PAGE_TABLE_CHECK if MMU
> > -     select ARCH_SUPPORTS_PER_VMA_LOCK if MMU
> >       select ARCH_HAS_PTE_PROTNONE if MMU
> >       select ARCH_SUPPORTS_RT
> >       select ARCH_SUPPORTS_SHADOW_CALL_STACK if HAVE_SHADOW_CALL_STACK
> > diff --git a/arch/s390/Kconfig b/arch/s390/Kconfig
> > index ab8fccc2cc4e..d1274bca8c39 100644
> > --- a/arch/s390/Kconfig
> > +++ b/arch/s390/Kconfig
> > @@ -151,7 +151,6 @@ config S390
> >       select ARCH_HAS_PTE_PROTNONE
> >       select ARCH_SUPPORTS_NUMA_BALANCING
> >       select ARCH_SUPPORTS_PAGE_TABLE_CHECK
> > -     select ARCH_SUPPORTS_PER_VMA_LOCK
> >       select ARCH_USE_BUILTIN_BSWAP
> >       select ARCH_USE_CMPXCHG_LOCKREF
> >       select ARCH_USE_SYM_ANNOTATIONS
> > diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> > index fb298e219179..79479d29576f 100644
> > --- a/arch/x86/Kconfig
> > +++ b/arch/x86/Kconfig
> > @@ -27,7 +27,6 @@ config X86_64
> >       select ARCH_HAS_GIGANTIC_PAGE
> >       select ARCH_SUPPORTS_MSEAL_SYSTEM_MAPPINGS
> >       select ARCH_SUPPORTS_INT128 if CC_HAS_INT128
> > -     select ARCH_SUPPORTS_PER_VMA_LOCK
> >       select ARCH_SUPPORTS_HUGE_PFNMAP if TRANSPARENT_HUGEPAGE
> >       select HAVE_ARCH_SOFT_DIRTY
> >       select MODULES_USE_ELF_RELA
> > @@ -1846,7 +1845,6 @@ config X86_USER_SHADOW_STACK
> >       bool "X86 userspace shadow stack"
> >       depends on AS_WRUSS
> >       depends on X86_64
> > -     depends on PER_VMA_LOCK
> >       select ARCH_USES_HIGH_VMA_FLAGS
> >       select ARCH_HAS_USER_SHADOW_STACK
> >       select X86_CET
> > diff --git a/fs/proc/internal.h b/fs/proc/internal.h
> > index b232e1098117..6713757da099 100644
> > --- a/fs/proc/internal.h
> > +++ b/fs/proc/internal.h
> > @@ -385,10 +385,8 @@ struct mem_size_stats;
> >
> >  struct proc_maps_locking_ctx {
> >       struct mm_struct *mm;
> > -#ifdef CONFIG_PER_VMA_LOCK
> >       bool mmap_locked;
> >       struct vm_area_struct *locked_vma;
> > -#endif
> >  };
> >
> >  struct proc_maps_private {
> > diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
> > index 5c54aebe2118..e671b4fd8ded 100644
> > --- a/fs/proc/task_mmu.c
> > +++ b/fs/proc/task_mmu.c
> > @@ -130,8 +130,6 @@ static void release_task_mempolicy(struct proc_maps=
_private *priv)
> >  }
> >  #endif
> >
> > -#ifdef CONFIG_PER_VMA_LOCK
> > -
> >  static inline int lock_ctx_mm(struct proc_maps_locking_ctx *lock_ctx)
> >  {
> >       int ret =3D mmap_read_lock_killable(lock_ctx->mm);
> > @@ -233,46 +231,6 @@ static inline void reacquire_rcu(struct proc_maps_=
private *priv)
> >       vma_iter_set(&priv->iter, priv->lock_ctx.locked_vma->vm_end);
> >  }
> >
> > -#else /* CONFIG_PER_VMA_LOCK */
> > -
> > -static inline int lock_ctx_mm(struct proc_maps_locking_ctx *lock_ctx)
> > -{
> > -     return mmap_read_lock_killable(lock_ctx->mm);
> > -}
> > -
> > -static inline void unlock_ctx_mm(struct proc_maps_locking_ctx *lock_ct=
x)
> > -{
> > -     mmap_read_unlock(lock_ctx->mm);
> > -}
> > -
> > -static inline bool lock_vma_range(struct seq_file *m,
> > -                               struct proc_maps_locking_ctx *lock_ctx)
> > -{
> > -     return lock_ctx_mm(lock_ctx) =3D=3D 0;
> > -}
> > -
> > -static inline void unlock_vma_range(struct proc_maps_locking_ctx *lock=
_ctx)
> > -{
> > -     unlock_ctx_mm(lock_ctx);
> > -}
> > -
> > -static struct vm_area_struct *get_next_vma(struct proc_maps_private *p=
riv,
> > -                                        loff_t last_pos)
> > -{
> > -     return vma_next(&priv->iter);
> > -}
> > -
> > -static inline bool fallback_to_mmap_lock(struct proc_maps_private *pri=
v,
> > -                                      loff_t pos)
> > -{
> > -     return false;
> > -}
> > -
> > -static inline void drop_rcu(struct proc_maps_private *priv) {}
> > -static inline void reacquire_rcu(struct proc_maps_private *priv) {}
> > -
> > -#endif /* CONFIG_PER_VMA_LOCK */
> > -
> >  static struct vm_area_struct *proc_get_vma(struct seq_file *m, loff_t =
*ppos)
> >  {
> >       struct proc_maps_private *priv =3D m->private;
> > @@ -560,8 +518,6 @@ static int pid_maps_open(struct inode *inode, struc=
t file *file)
> >               PROCMAP_QUERY_VMA_FLAGS                         \
> >  )
> >
> > -#ifdef CONFIG_PER_VMA_LOCK
> > -
> >  static int query_vma_setup(struct proc_maps_locking_ctx *lock_ctx)
> >  {
> >       reset_lock_ctx(lock_ctx);
> > @@ -612,26 +568,6 @@ static struct vm_area_struct *query_vma_find_by_ad=
dr(struct proc_maps_locking_ct
> >       return vma;
> >  }
> >
> > -#else /* CONFIG_PER_VMA_LOCK */
> > -
> > -static int query_vma_setup(struct proc_maps_locking_ctx *lock_ctx)
> > -{
> > -     return mmap_read_lock_killable(lock_ctx->mm);
> > -}
> > -
> > -static void query_vma_teardown(struct proc_maps_locking_ctx *lock_ctx)
> > -{
> > -     mmap_read_unlock(lock_ctx->mm);
> > -}
> > -
> > -static struct vm_area_struct *query_vma_find_by_addr(struct proc_maps_=
locking_ctx *lock_ctx,
> > -                                                  unsigned long addr)
> > -{
> > -     return find_vma(lock_ctx->mm, addr);
> > -}
> > -
> > -#endif  /* CONFIG_PER_VMA_LOCK */
> > -
> >  static struct vm_area_struct *query_matching_vma(struct proc_maps_lock=
ing_ctx *lock_ctx,
> >                                                unsigned long addr, u32 =
flags)
> >  {
> > @@ -1314,8 +1250,6 @@ static const struct mm_walk_ops smaps_shmem_walk_=
ops =3D {
> >       .walk_lock              =3D PGWALK_RDLOCK,
> >  };
> >
> > -#ifdef CONFIG_PER_VMA_LOCK
> > -
> >  static const struct mm_walk_ops smaps_walk_vma_lock_ops =3D {
> >       .pmd_entry              =3D smaps_pte_range,
> >       .hugetlb_entry          =3D smaps_hugetlb_range,
> > @@ -1345,22 +1279,6 @@ get_smaps_shmem_walk_ops(struct proc_maps_privat=
e *priv)
> >       return &smaps_shmem_walk_vma_lock_ops;
> >  }
> >
> > -#else /* CONFIG_PER_VMA_LOCK */
> > -
> > -static inline const struct mm_walk_ops *
> > -get_smaps_walk_ops(struct proc_maps_private *priv)
> > -{
> > -     return &smaps_walk_ops;
> > -}
> > -
> > -static inline const struct mm_walk_ops *
> > -get_smaps_shmem_walk_ops(struct proc_maps_private *priv)
> > -{
> > -     return &smaps_shmem_walk_ops;
> > -}
> > -
> > -#endif /* CONFIG_PER_VMA_LOCK */
> > -
> >  /*
> >   * Gather mem stats from @vma with the indicated beginning
> >   * address @start, and keep them in @mss.
> > @@ -3497,7 +3415,6 @@ static const struct mm_walk_ops show_numa_ops =3D=
 {
> >       .walk_lock =3D PGWALK_RDLOCK,
> >  };
> >
> > -#ifdef CONFIG_PER_VMA_LOCK
> >  static const struct mm_walk_ops show_numa_vma_lock_ops =3D {
> >       .hugetlb_entry =3D gather_hugetlb_stats,
> >       .pmd_entry =3D gather_pte_stats,
> > @@ -3512,16 +3429,6 @@ get_show_numa_ops(struct proc_maps_private *priv=
)
> >       return &show_numa_vma_lock_ops;
> >  }
> >
> > -#else /* CONFIG_PER_VMA_LOCK */
> > -
> > -static inline const struct mm_walk_ops *
> > -get_show_numa_ops(struct proc_maps_private *priv)
> > -{
> > -     return &show_numa_ops;
> > -}
> > -
> > -#endif /* CONFIG_PER_VMA_LOCK */
> > -
> >  /*
> >   * Display pages allocated per node and memory policy via /proc.
> >   */
> > diff --git a/include/linux/mm.h b/include/linux/mm.h
> > index f940d20551d5..73a6244e1dd0 100644
> > --- a/include/linux/mm.h
> > +++ b/include/linux/mm.h
> > @@ -931,7 +931,6 @@ static inline void vma_numab_state_free(struct vm_a=
rea_struct *vma) {}
> >   * These must be here rather than mmap_lock.h as dependent on vm_fault=
 type,
> >   * declared in this header.
> >   */
> > -#ifdef CONFIG_PER_VMA_LOCK
> >  static inline void release_fault_lock(struct vm_fault *vmf)
> >  {
> >       if (vmf->flags & FAULT_FLAG_VMA_LOCK)
> > @@ -947,17 +946,6 @@ static inline void assert_fault_locked(const struc=
t vm_fault *vmf)
> >       else
> >               mmap_assert_locked(vmf->vma->vm_mm);
> >  }
> > -#else
> > -static inline void release_fault_lock(struct vm_fault *vmf)
> > -{
> > -     mmap_read_unlock(vmf->vma->vm_mm);
> > -}
> > -
> > -static inline void assert_fault_locked(const struct vm_fault *vmf)
> > -{
> > -     mmap_assert_locked(vmf->vma->vm_mm);
> > -}
> > -#endif /* CONFIG_PER_VMA_LOCK */
> >
> >  static inline bool mm_flags_test(int flag, const struct mm_struct *mm)
> >  {
> > diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
> > index 6d815f6440c9..5413bd10fff2 100644
> > --- a/include/linux/mm_types.h
> > +++ b/include/linux/mm_types.h
> > @@ -950,7 +950,6 @@ struct vm_area_struct {
> >               vma_flags_t flags;
> >       };
> >
> > -#ifdef CONFIG_PER_VMA_LOCK
> >       /*
> >        * Can only be written (using WRITE_ONCE()) while holding both:
> >        *  - mmap_lock (in write mode)
> > @@ -966,7 +965,7 @@ struct vm_area_struct {
> >        * slowpath.
> >        */
> >       unsigned int vm_lock_seq;
> > -#endif
> > +
> >       /*
> >        * Low 32-bits of anonymous page offset.
> >        * See vma_start_anon_pgoff() comment for details.
> > @@ -1003,7 +1002,6 @@ struct vm_area_struct {
> >  #ifdef CONFIG_NUMA_BALANCING
> >       struct vma_numab_state *numab_state;    /* NUMA Balancing state *=
/
> >  #endif
> > -#ifdef CONFIG_PER_VMA_LOCK
> >       /*
> >        * Used to keep track of firstly, whether the VMA is attached, se=
condly,
> >        * if attached, how many read locks are taken, and thirdly, if th=
e
> > @@ -1046,7 +1044,6 @@ struct vm_area_struct {
> >  #ifdef CONFIG_DEBUG_LOCK_ALLOC
> >       struct lockdep_map vmlock_dep_map;
> >  #endif
> > -#endif
> >  #ifdef CONFIG_64BIT
> >       /*
> >        * High 32-bits of anonymous page offset.
> > @@ -1254,7 +1251,6 @@ struct mm_struct {
> >                                         * init_mm.mmlist, and are prote=
cted
> >                                         * by mmlist_lock
> >                                         */
> > -#ifdef CONFIG_PER_VMA_LOCK
> >               struct rcuwait vma_writer_wait;
> >               /*
> >                * This field has lock-like semantics, meaning it is some=
times
> > @@ -1274,7 +1270,7 @@ struct mm_struct {
> >                * mmap_lock.
> >                */
> >               seqcount_t mm_lock_seq;
> > -#endif
> > +
> >               struct futex_mm_data    futex;
> >
> >               unsigned long hiwater_rss; /* High-watermark of RSS usage=
 */
> > diff --git a/include/linux/mmap_lock.h b/include/linux/mmap_lock.h
> > index 87f77e3da77f..db2dbf84943c 100644
> > --- a/include/linux/mmap_lock.h
> > +++ b/include/linux/mmap_lock.h
> > @@ -76,8 +76,6 @@ static inline void mmap_assert_write_locked(const str=
uct mm_struct *mm)
> >       rwsem_assert_held_write(&mm->mmap_lock);
> >  }
> >
> > -#ifdef CONFIG_PER_VMA_LOCK
> > -
> >  #ifdef CONFIG_LOCKDEP
> >  #define __vma_lockdep_map(vma) (&vma->vmlock_dep_map)
> >  #else
> > @@ -297,6 +295,9 @@ int __vma_start_write(struct vm_area_struct *vma, i=
nt state);
> >   */
> >  static inline void vma_start_write(struct vm_area_struct *vma)
> >  {
> > +     if (!IS_ENABLED(CONFIG_MMU))
> > +             return;
> > +
> >       if (__is_vma_write_locked(vma))
> >               return;
> >
> > @@ -319,6 +320,9 @@ static inline void vma_start_write(struct vm_area_s=
truct *vma)
> >  static inline __must_check
> >  int vma_start_write_killable(struct vm_area_struct *vma)
> >  {
> > +     if (!IS_ENABLED(CONFIG_MMU))
> > +             return 0;
> > +
> >       if (__is_vma_write_locked(vma))
> >               return 0;
> >
> > @@ -331,6 +335,11 @@ int vma_start_write_killable(struct vm_area_struct=
 *vma)
> >   */
> >  static inline void vma_assert_write_locked(struct vm_area_struct *vma)
> >  {
> > +     if (!IS_ENABLED(CONFIG_MMU)) {
> > +             mmap_assert_write_locked(vma->vm_mm);
> > +             return;
> > +     }
> > +
> >       VM_WARN_ON_ONCE_VMA(!__is_vma_write_locked(vma), vma);
> >  }
> >
> > @@ -343,6 +352,11 @@ static inline void vma_assert_locked(struct vm_are=
a_struct *vma)
> >  {
> >       unsigned int refcnt;
> >
> > +     if (!IS_ENABLED(CONFIG_MMU)) {
> > +             mmap_assert_locked(vma->vm_mm);
> > +             return;
> > +     }
> > +
> >       if (IS_ENABLED(CONFIG_LOCKDEP)) {
> >               if (!lock_is_held(__vma_lockdep_map(vma)))
> >                       vma_assert_write_locked(vma);
> > @@ -432,6 +446,9 @@ static inline bool vma_is_attached(struct vm_area_s=
truct *vma)
> >   */
> >  static inline void vma_assert_attached(struct vm_area_struct *vma)
> >  {
> > +     if (!IS_ENABLED(CONFIG_MMU))
> > +             return;
> > +
> >       WARN_ON_ONCE(!vma_is_attached(vma));
> >  }
> >
> > @@ -442,6 +459,9 @@ static inline void vma_assert_detached(struct vm_ar=
ea_struct *vma)
> >
> >  static inline void vma_mark_attached(struct vm_area_struct *vma)
> >  {
> > +     if (!IS_ENABLED(CONFIG_MMU))
> > +             return;
> > +
> >       vma_assert_write_locked(vma);
> >       vma_assert_detached(vma);
> >       refcount_set_release(&vma->vm_refcnt, 1);
> > @@ -451,6 +471,9 @@ void __vma_exclude_readers_for_detach(struct vm_are=
a_struct *vma);
> >
> >  static inline void vma_mark_detached(struct vm_area_struct *vma)
> >  {
> > +     if (!IS_ENABLED(CONFIG_MMU))
> > +             return;
> > +
> >       vma_assert_write_locked(vma);
> >       vma_assert_attached(vma);
> >
> > @@ -484,54 +507,6 @@ struct vm_area_struct *lock_next_vma(struct mm_str=
uct *mm,
> >                                    struct vma_iterator *iter,
> >                                    unsigned long address);
> >
> > -#else /* CONFIG_PER_VMA_LOCK */
> > -
> > -static inline void mm_lock_seqcount_init(struct mm_struct *mm) {}
> > -static inline void mm_lock_seqcount_begin(struct mm_struct *mm) {}
> > -static inline void mm_lock_seqcount_end(struct mm_struct *mm) {}
> > -
> > -static inline bool mmap_lock_speculate_try_begin(struct mm_struct *mm,=
 unsigned int *seq)
> > -{
> > -     return false;
> > -}
> > -
> > -static inline bool mmap_lock_speculate_retry(struct mm_struct *mm, uns=
igned int seq)
> > -{
> > -     return true;
> > -}
> > -static inline void vma_lock_init(struct vm_area_struct *vma, bool rese=
t_refcnt) {}
> > -static inline void vma_end_read(struct vm_area_struct *vma) {}
> > -static inline void vma_start_write(struct vm_area_struct *vma) {}
> > -static inline __must_check
> > -int vma_start_write_killable(struct vm_area_struct *vma) { return 0; }
> > -static inline void vma_assert_write_locked(struct vm_area_struct *vma)
> > -             { mmap_assert_write_locked(vma->vm_mm); }
> > -static inline bool vma_is_attached(struct vm_area_struct *vma)
> > -             { return true; }
> > -static inline void vma_assert_attached(struct vm_area_struct *vma) {}
> > -static inline void vma_assert_detached(struct vm_area_struct *vma) {}
> > -static inline void vma_mark_attached(struct vm_area_struct *vma) {}
> > -static inline void vma_mark_detached(struct vm_area_struct *vma) {}
> > -
> > -static inline struct vm_area_struct *lock_vma_under_rcu(struct mm_stru=
ct *mm,
> > -             unsigned long address)
> > -{
> > -     return NULL;
> > -}
> > -
> > -static inline void vma_assert_locked(struct vm_area_struct *vma)
> > -{
> > -     mmap_assert_locked(vma->vm_mm);
> > -}
> > -
> > -static inline void vma_assert_stabilised(struct vm_area_struct *vma)
> > -{
> > -     /* If no VMA locks, then either mmap lock suffices to stabilise. =
*/
> > -     mmap_assert_locked(vma->vm_mm);
> > -}
> > -
> > -#endif /* CONFIG_PER_VMA_LOCK */
> > -
> >  static inline void vma_assert_can_modify(struct vm_area_struct *vma)
> >  {
> >       if (vma_is_attached(vma))
> > diff --git a/kernel/bpf/stackmap.c b/kernel/bpf/stackmap.c
> > index 41fe87d7302f..6bd6022b6b84 100644
> > --- a/kernel/bpf/stackmap.c
> > +++ b/kernel/bpf/stackmap.c
> > @@ -272,13 +272,10 @@ struct stack_map_vma_lock {
> >  /*
> >   * Acquire a stable read-side reference on the VMA covering @ip.
> >   *
> > - * With CONFIG_PER_VMA_LOCK=3Dy this returns a VMA with its per-VMA re=
ad
> > - * lock held and mmap_lock dropped, so the caller may sleep.
> > - *
> > - * With CONFIG_PER_VMA_LOCK=3Dn it returns a VMA with mmap_lock still
> > - * held; the caller must snapshot any fields it needs and pin vm_file
> > - * with get_file() before stack_map_unlock_vma() drops mmap_lock, as
> > - * the VMA may be split, merged, or freed after that.
> > + * On NOMMU configurations, returns with the mmap_lock held.  If the M=
MU
> > + * is enabled, the per-VMA lock will be held instead.  The lock
> > + * should be released with stack_map_unlock_vma() which will release t=
he
> > + * appropriate lock.  Once the lock is released, the VMA may be freed.
>
> Thanks!
>
> >   *
> >   * Returns NULL on failure, in which case no lock is held.
> >   */
> > @@ -288,7 +285,6 @@ stack_map_lock_vma(struct stack_map_vma_lock *lock,=
 unsigned long ip)
> >       struct mm_struct *mm =3D lock->mm;
> >       struct vm_area_struct *vma;
> >
> > -     /* noop under !CONFIG_PER_VMA_LOCK */
> >       vma =3D lock_vma_under_rcu(mm, ip);
> >       if (vma) {
> >               lock->vma =3D vma;
> > @@ -308,21 +304,20 @@ stack_map_lock_vma(struct stack_map_vma_lock *loc=
k, unsigned long ip)
> >               return NULL;
> >       }
> >
> > -#ifdef CONFIG_PER_VMA_LOCK
> > +#ifdef CONFIG_MMU
> >       if (!vma_start_read_locked(vma)) {
> >               mmap_read_unlock(mm);
> >               return NULL;
> >       }
> >       mmap_read_unlock(mm);
> >  #endif
> > -
> >       lock->vma =3D vma;
> >       return vma;
> >  }
> >
> >  static void stack_map_unlock_vma(struct stack_map_vma_lock *lock)
> >  {
> > -#ifdef CONFIG_PER_VMA_LOCK
> > +#ifdef CONFIG_MMU
> >       vma_end_read(lock->vma);
> >  #else
> >       mmap_read_unlock(lock->mm);
> > diff --git a/kernel/bpf/task_iter.c b/kernel/bpf/task_iter.c
> > index e791ae065c39..245f74ec491d 100644
> > --- a/kernel/bpf/task_iter.c
> > +++ b/kernel/bpf/task_iter.c
> > @@ -835,7 +835,7 @@ __bpf_kfunc int bpf_iter_task_vma_new(struct bpf_it=
er_task_vma *it,
> >       BUILD_BUG_ON(sizeof(struct bpf_iter_task_vma_kern) !=3D sizeof(st=
ruct bpf_iter_task_vma));
> >       BUILD_BUG_ON(__alignof__(struct bpf_iter_task_vma_kern) !=3D __al=
ignof__(struct bpf_iter_task_vma));
> >
> > -     if (!IS_ENABLED(CONFIG_PER_VMA_LOCK)) {
> > +     if (!IS_ENABLED(CONFIG_MMU)) {
> >               kit->data =3D NULL;
> >               return -EOPNOTSUPP;
> >       }
> > diff --git a/kernel/fork.c b/kernel/fork.c
> > index f0e2e131a9a5..ff91f5f66c80 100644
> > --- a/kernel/fork.c
> > +++ b/kernel/fork.c
> > @@ -1077,9 +1077,7 @@ static void mmap_init_lock(struct mm_struct *mm)
> >  {
> >       init_rwsem(&mm->mmap_lock);
> >       mm_lock_seqcount_init(mm);
> > -#ifdef CONFIG_PER_VMA_LOCK
> >       rcuwait_init(&mm->vma_writer_wait);
> > -#endif
> >  }
> >
> >  static struct mm_struct *mm_init(struct mm_struct *mm, struct task_str=
uct *p)
> > diff --git a/mm/Kconfig b/mm/Kconfig
> > index 8a24c130d008..bf89d7d3be4b 100644
> > --- a/mm/Kconfig
> > +++ b/mm/Kconfig
> > @@ -1429,18 +1429,6 @@ config LRU_GEN_WALKS_MMU
> >       depends on LRU_GEN && ARCH_HAS_HW_PTE_YOUNG
> >  # }
> >
> > -config ARCH_SUPPORTS_PER_VMA_LOCK
> > -       def_bool n
> > -
> > -config PER_VMA_LOCK
> > -     def_bool y
> > -     depends on ARCH_SUPPORTS_PER_VMA_LOCK && MMU && SMP
> > -     help
> > -       Allow per-vma locking during page fault handling.
> > -
> > -       This feature allows locking each virtual memory area separately=
 when
> > -       handling page faults instead of taking mmap_lock.
> > -
> >  config LOCK_MM_AND_FIND_VMA
> >       bool
> >       depends on !STACK_GROWSUP
> > diff --git a/mm/Kconfig.debug b/mm/Kconfig.debug
> > index 5737a504efbb..1dd150edfe71 100644
> > --- a/mm/Kconfig.debug
> > +++ b/mm/Kconfig.debug
> > @@ -310,7 +310,6 @@ config DEBUG_KMEMLEAK_VERBOSE
> >
> >  config PER_VMA_LOCK_STATS
> >       bool "Statistics for per-vma locks"
> > -     depends on PER_VMA_LOCK
> >       help
> >         Say Y here to enable success, retry and failure counters of pag=
e
> >         faults handled under protection of per-vma locks. When enabled,=
 the
> > diff --git a/mm/debug.c b/mm/debug.c
> > index 9a0297b3988d..655e6bcc0e8d 100644
> > --- a/mm/debug.c
> > +++ b/mm/debug.c
> > @@ -157,17 +157,13 @@ void dump_vma(const struct vm_area_struct *vma)
> >       pr_emerg("vma %px start %px end %px mm %px\n"
> >               "prot %lx anon_vma %px vm_ops %px\n"
> >               "pgoff %lx file %px private_data %px\n"
> > -#ifdef CONFIG_PER_VMA_LOCK
> >               "refcnt %x\n"
> > -#endif
> >               "flags: %#lx(%pGv)\n",
> >               vma, (void *)vma->vm_start, (void *)vma->vm_end, vma->vm_=
mm,
> >               (unsigned long)pgprot_val(vma->vm_page_prot),
> >               vma->anon_vma, vma->vm_ops, vma_start_pgoff(vma),
> >               vma->vm_file, vma->vm_private_data,
> > -#ifdef CONFIG_PER_VMA_LOCK
> >               refcount_read(&vma->vm_refcnt),
> > -#endif
> >               vma->vm_flags, &vma->vm_flags);
> >  }
> >  EXPORT_SYMBOL(dump_vma);
> > diff --git a/mm/init-mm.c b/mm/init-mm.c
> > index 3e792aad7626..a1bb2c2d0284 100644
> > --- a/mm/init-mm.c
> > +++ b/mm/init-mm.c
> > @@ -39,10 +39,8 @@ struct mm_struct init_mm =3D {
> >       .page_table_lock =3D  __SPIN_LOCK_UNLOCKED(init_mm.page_table_loc=
k),
> >       .arg_lock       =3D  __SPIN_LOCK_UNLOCKED(init_mm.arg_lock),
> >       .mmlist         =3D LIST_HEAD_INIT(init_mm.mmlist),
> > -#ifdef CONFIG_PER_VMA_LOCK
> >       .vma_writer_wait =3D __RCUWAIT_INITIALIZER(init_mm.vma_writer_wai=
t),
> >       .mm_lock_seq    =3D SEQCNT_ZERO(init_mm.mm_lock_seq),
> > -#endif
> >  #ifdef CONFIG_SCHED_MM_CID
> >       .mm_cid.lock =3D __RAW_SPIN_LOCK_UNLOCKED(init_mm.mm_cid.lock),
> >  #endif
> > diff --git a/mm/memory.c b/mm/memory.c
> > index 4134ac607ee0..21a4d95cb409 100644
> > --- a/mm/memory.c
> > +++ b/mm/memory.c
> > @@ -6818,7 +6818,6 @@ static vm_fault_t sanitize_fault_flags(struct vm_=
area_struct *vma,
> >                                !vma_is_cow_mapping(vma)))
> >                       return VM_FAULT_SIGSEGV;
> >       }
> > -#ifdef CONFIG_PER_VMA_LOCK
> >       /*
> >        * Per-VMA locks can't be used with FAULT_FLAG_RETRY_NOWAIT becau=
se of
> >        * the assumption that lock is dropped on VM_FAULT_RETRY.
> > @@ -6827,7 +6826,6 @@ static vm_fault_t sanitize_fault_flags(struct vm_=
area_struct *vma,
> >                       (FAULT_FLAG_VMA_LOCK | FAULT_FLAG_RETRY_NOWAIT)) =
=3D=3D
> >                       (FAULT_FLAG_VMA_LOCK | FAULT_FLAG_RETRY_NOWAIT)))
> >               return VM_FAULT_SIGSEGV;
> > -#endif
> >
> >       return 0;
> >  }
> > diff --git a/mm/mmap_lock.c b/mm/mmap_lock.c
> > index 898c2ef1e958..272f9ac762b9 100644
> > --- a/mm/mmap_lock.c
> > +++ b/mm/mmap_lock.c
> > @@ -43,9 +43,6 @@ void __mmap_lock_do_trace_released(struct mm_struct *=
mm, bool write)
> >  EXPORT_SYMBOL(__mmap_lock_do_trace_released);
> >  #endif /* CONFIG_TRACING */
> >
> > -#ifdef CONFIG_MMU
> > -#ifdef CONFIG_PER_VMA_LOCK
> > -
> >  /* State shared across __vma_[start, end]_exclude_readers. */
> >  struct vma_exclude_readers_state {
> >       /* Input parameters. */
> > @@ -299,6 +296,8 @@ struct vm_area_struct *lock_vma_under_rcu(struct mm=
_struct *mm,
> >       MA_STATE(mas, &mm->mm_mt, address, address);
> >       struct vm_area_struct *vma;
> >
> > +     if (!IS_ENABLED(CONFIG_MMU))
> > +             return NULL;
>
> Thanks, I do think that's the least-worst solution :)
>
> >  retry:
> >       rcu_read_lock();
> >       vma =3D mas_walk(&mas);
> > @@ -431,7 +430,6 @@ struct vm_area_struct *lock_next_vma(struct mm_stru=
ct *mm,
> >
> >       return vma;
> >  }
> > -#endif /* CONFIG_PER_VMA_LOCK */
> >
> >  #ifdef CONFIG_LOCK_MM_AND_FIND_VMA
> >  #include <linux/extable.h>
> > @@ -548,23 +546,3 @@ struct vm_area_struct *lock_mm_and_find_vma(struct=
 mm_struct *mm,
> >       return NULL;
> >  }
> >  #endif /* CONFIG_LOCK_MM_AND_FIND_VMA */
> > -
> > -#else /* CONFIG_MMU */
> > -
> > -/*
> > - * At least xtensa ends up having protection faults even with no
> > - * MMU.. No stack expansion, at least.
> > - */
> > -struct vm_area_struct *lock_mm_and_find_vma(struct mm_struct *mm,
> > -                     unsigned long addr, struct pt_regs *regs)
> > -{
> > -     struct vm_area_struct *vma;
> > -
> > -     mmap_read_lock(mm);
> > -     vma =3D vma_lookup(mm, addr);
> > -     if (!vma)
> > -             mmap_read_unlock(mm);
> > -     return vma;
> > -}
> > -
> > -#endif /* CONFIG_MMU */
> > diff --git a/mm/pagewalk.c b/mm/pagewalk.c
> > index cc07fcf50e87..7411702a37f5 100644
> > --- a/mm/pagewalk.c
> > +++ b/mm/pagewalk.c
> > @@ -444,7 +444,6 @@ static inline void process_mm_walk_lock(struct mm_s=
truct *mm,
> >  static inline void process_vma_walk_lock(struct vm_area_struct *vma,
> >                                        enum page_walk_lock walk_lock)
> >  {
> > -#ifdef CONFIG_PER_VMA_LOCK
> >       switch (walk_lock) {
> >       case PGWALK_WRLOCK:
> >               vma_start_write(vma);
> > @@ -459,7 +458,6 @@ static inline void process_vma_walk_lock(struct vm_=
area_struct *vma,
> >               /* PGWALK_RDLOCK is handled by process_mm_walk_lock */
> >               break;
> >       }
> > -#endif
> >  }
> >
> >  /*
> > diff --git a/mm/rmap.c b/mm/rmap.c
> > index 14f2f9b07572..7515220dfea4 100644
> > --- a/mm/rmap.c
> > +++ b/mm/rmap.c
> > @@ -260,11 +260,9 @@ static void check_anon_vma_clone(struct vm_area_st=
ruct *dst,
> >       /* For the anon_vma to be compatible, it can only be singular. */
> >       VM_WARN_ON_ONCE(operation =3D=3D VMA_OP_MERGE_UNFAULTED &&
> >                       !list_is_singular(&src->anon_vma_chain));
> > -#ifdef CONFIG_PER_VMA_LOCK
> >       /* Only merging an unfaulted VMA leaves the destination attached.=
 */
> >       VM_WARN_ON_ONCE(operation !=3D VMA_OP_MERGE_UNFAULTED &&
> >                       vma_is_attached(dst));
> > -#endif
> >  }
> >
> >  static void maybe_reuse_anon_vma(struct vm_area_struct *dst,
> > diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
> > index 23fb68fce000..0b279b82eaa6 100644
> > --- a/mm/userfaultfd.c
> > +++ b/mm/userfaultfd.c
> > @@ -122,7 +122,6 @@ struct vm_area_struct *find_vma_and_prepare_anon(st=
ruct mm_struct *mm,
> >       return vma;
> >  }
> >
> > -#ifdef CONFIG_PER_VMA_LOCK
> >  /*
> >   * uffd_lock_vma() - Lookup and lock vma corresponding to @address.
> >   * @mm: mm to search vma in.
> > @@ -182,34 +181,6 @@ static void uffd_mfill_unlock(struct vm_area_struc=
t *vma)
> >       vma_end_read(vma);
> >  }
> >
> > -#else
> > -
> > -static struct vm_area_struct *uffd_mfill_lock(struct mm_struct *dst_mm=
,
> > -                                           unsigned long dst_start,
> > -                                           unsigned long len)
> > -{
> > -     struct vm_area_struct *dst_vma;
> > -
> > -     mmap_read_lock(dst_mm);
> > -     dst_vma =3D find_vma_and_prepare_anon(dst_mm, dst_start);
> > -     if (IS_ERR(dst_vma))
> > -             goto out_unlock;
> > -
> > -     if (validate_dst_vma(dst_vma, dst_start + len))
> > -             return dst_vma;
> > -
> > -     dst_vma =3D ERR_PTR(-ENOENT);
> > -out_unlock:
> > -     mmap_read_unlock(dst_mm);
> > -     return dst_vma;
> > -}
> > -
> > -static void uffd_mfill_unlock(struct vm_area_struct *vma)
> > -{
> > -     mmap_read_unlock(vma->vm_mm);
> > -}
> > -#endif
> > -
> >  static void mfill_put_vma(struct mfill_state *state)
> >  {
> >       if (!state->vma)
> > @@ -1850,7 +1821,6 @@ int find_vmas_mm_locked(struct mm_struct *mm,
> >       return 0;
> >  }
> >
> > -#ifdef CONFIG_PER_VMA_LOCK
> >  static int uffd_move_lock(struct mm_struct *mm,
> >                         unsigned long dst_start,
> >                         unsigned long src_start,
> > @@ -1925,31 +1895,6 @@ static void uffd_move_unlock(struct vm_area_stru=
ct *dst_vma,
> >               vma_end_read(dst_vma);
> >  }
> >
> > -#else
> > -
> > -static int uffd_move_lock(struct mm_struct *mm,
> > -                       unsigned long dst_start,
> > -                       unsigned long src_start,
> > -                       struct vm_area_struct **dst_vmap,
> > -                       struct vm_area_struct **src_vmap)
> > -{
> > -     int err;
> > -
> > -     mmap_read_lock(mm);
> > -     err =3D find_vmas_mm_locked(mm, dst_start, src_start, dst_vmap, s=
rc_vmap);
> > -     if (err)
> > -             mmap_read_unlock(mm);
> > -     return err;
> > -}
> > -
> > -static void uffd_move_unlock(struct vm_area_struct *dst_vma,
> > -                          struct vm_area_struct *src_vma)
> > -{
> > -     mmap_assert_locked(src_vma->vm_mm);
> > -     mmap_read_unlock(dst_vma->vm_mm);
> > -}
> > -#endif
> > -
> >  /**
> >   * move_pages - move arbitrary anonymous pages of an existing vma
> >   * @ctx: pointer to the userfaultfd context
> > diff --git a/rust/kernel/mm.rs b/rust/kernel/mm.rs
> > index 4764d7b68f2a..f4fa54616085 100644
> > --- a/rust/kernel/mm.rs
> > +++ b/rust/kernel/mm.rs
> > @@ -170,30 +170,20 @@ pub unsafe fn from_raw<'a>(ptr: *const bindings::=
mm_struct) -> &'a MmWithUser {
> >      ///
> >      /// This is an optimistic trylock operation, so it may fail if the=
re is contention. In that
> >      /// case, you should fall back to taking the mmap read lock.
> > -    ///
> > -    /// When per-vma locks are disabled, this always returns `None`.
> >      #[inline]
> >      pub fn lock_vma_under_rcu(&self, vma_addr: usize) -> Option<VmaRea=
dGuard<'_>> {
> > -        #[cfg(CONFIG_PER_VMA_LOCK)]
> > -        {
> > -            // SAFETY: Calling `bindings::lock_vma_under_rcu` is alway=
s okay given an mm where
> > -            // `mm_users` is non-zero.
> > -            let vma =3D unsafe { bindings::lock_vma_under_rcu(self.as_=
raw(), vma_addr) };
> > -            if !vma.is_null() {
> > -                return Some(VmaReadGuard {
> > -                    // SAFETY: If `lock_vma_under_rcu` returns a non-n=
ull ptr, then it points at a
> > -                    // valid vma. The vma is stable for as long as the=
 vma read lock is held.
> > -                    vma: unsafe { VmaRef::from_raw(vma) },
> > -                    _nts: NotThreadSafe,
> > -                });
> > -            }
> > +        // SAFETY: Calling `bindings::lock_vma_under_rcu` is always ok=
ay given an mm where
> > +        // `mm_users` is non-zero.
> > +        let vma =3D unsafe { bindings::lock_vma_under_rcu(self.as_raw(=
), vma_addr) };
> > +        if vma.is_null() {
> > +            return None;
> >          }
> > -
> > -        // Silence warnings about unused variables.
> > -        #[cfg(not(CONFIG_PER_VMA_LOCK))]
> > -        let _ =3D vma_addr;
> > -
> > -        None
> > +        Some(VmaReadGuard {
> > +            // SAFETY: If `lock_vma_under_rcu` returns a non-null ptr,=
 then it points at a
> > +            // valid vma. The vma is stable for as long as the vma rea=
d lock is held.
> > +            vma: unsafe { VmaRef::from_raw(vma) },
> > +            _nts: NotThreadSafe,
> > +        })
> >      }
> >
> >      /// Lock the mmap read lock.
> > diff --git a/tools/testing/vma/include/dup.h b/tools/testing/vma/includ=
e/dup.h
> > index 41203b1c2323..a0d1d563da24 100644
> > --- a/tools/testing/vma/include/dup.h
> > +++ b/tools/testing/vma/include/dup.h
> > @@ -582,7 +582,6 @@ struct vm_area_struct {
> >               vma_flags_t flags;
> >       };
> >
> > -#ifdef CONFIG_PER_VMA_LOCK
> >       /*
> >        * Can only be written (using WRITE_ONCE()) while holding both:
> >        *  - mmap_lock (in write mode)
> > @@ -598,7 +597,7 @@ struct vm_area_struct {
> >        * slowpath.
> >        */
> >       unsigned int vm_lock_seq;
> > -#endif
> > +
> >       unsigned int __vm_anon_pgoff_lo;
> >
> >       /*
> > @@ -632,10 +631,8 @@ struct vm_area_struct {
> >  #ifdef CONFIG_NUMA_BALANCING
> >       struct vma_numab_state *numab_state;    /* NUMA Balancing state *=
/
> >  #endif
> > -#ifdef CONFIG_PER_VMA_LOCK
> >       /* Unstable RCU readers are allowed to read this. */
> >       refcount_t vm_refcnt;
> > -#endif
> >  #ifdef CONFIG_64BIT
> >       unsigned int __vm_anon_pgoff_hi;
> >  #endif
> > diff --git a/tools/testing/vma/vma_internal.h b/tools/testing/vma/vma_i=
nternal.h
> > index 8a48b231aa7a..54d5c3360aa2 100644
> > --- a/tools/testing/vma/vma_internal.h
> > +++ b/tools/testing/vma/vma_internal.h
> > @@ -15,7 +15,6 @@
> >  #include <stdlib.h>
> >
> >  #define CONFIG_MMU           1
> > -#define CONFIG_PER_VMA_LOCK  1
> >
> >  #ifdef __CONCAT
> >  #undef __CONCAT
> > --
> > 2.55.0.691.gc56d675ccc-goog
> >
>
> --
> Cheers, Lorenzo

