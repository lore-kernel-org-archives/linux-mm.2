Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 13FD6CC6B03
	for <linux-mm@archiver.kernel.org>; Tue, 13 Oct 2026 11:24:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E66006B0095; Tue, 13 Oct 2026 07:24:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E16DD6B0096; Tue, 13 Oct 2026 07:24:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D05B56B0098; Tue, 13 Oct 2026 07:24:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id AC3A06B0095
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 07:24:00 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 4FDBF1A0409
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 11:24:00 +0000 (UTC)
X-FDA: 85317368640.12.DF7322C
Received: from mail-qt1-f178.google.com (mail-qt1-f178.google.com [209.85.160.178])
	by imf18.hostedemail.com (Postfix) with ESMTP id 536B21C000D
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 11:23:58 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="AqVooZ/m";
	spf=pass (imf18.hostedemail.com: domain of surenb@google.com designates 209.85.160.178 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1791890638;
	b=I0q6QQcseTt8cMtp0ZvYTtJ9KNFJ9yeyaT04agJTuoH1chWirdypHco5QyPBcAWrvIX8tK
	LJqyafnYjCH8se327OXYJMd+NJCxSCPawpgs7Yl1kcpu2pfXfUx2nx5Xaz8ZeEM/RRxxfA
	6ZUe2pT8dQJzh015bowspljovRSzOPI=
ARC-Authentication-Results: i=2;
	imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="AqVooZ/m";
	spf=pass (imf18.hostedemail.com: domain of surenb@google.com designates 209.85.160.178 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791890638;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Xzn08Xsc7kDwJ9WnURk+AQXsKYZTAAr7RKZN9XHYFSg=;
	b=HX7rss/kTUDY60KCmr8/GFNgwW3TXSMYCqq2wWms/A52y0UkR17gy9Br5xpWsQeBGpJYhw
	mUgHdD0joZaq9xT/BiDA2CJuTkXyVd3QfMre1UuZMYclpbJuCYGUguEMGxPGg2xZl3sqty
	S9EiGKViAt08auRT/+KGApN04RoOLAo=
Received: by mail-qt1-f178.google.com with SMTP id d75a77b69052e-5337c7b9937so707331cf.0
        for <linux-mm@kvack.org>; Tue, 13 Oct 2026 04:23:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791890637; cv=none;
        d=google.com; s=arc-20260327;
        b=DfbaZK8J0sOmLknMJLOKSR1v3bqfNz1rQhUIPm3MH2BeXAIu2onaujApBAh0mE6v6h
         H7ZbBwYRxNDX+CHBuh3fIg9uEu06Bq4cQTNmupJvn3KKwjbDXGQlTHOOLwDve1tJI0Cd
         XFHGgo/ZLuA6eNdfzXK4boKwBlymseDxXC5P1q1ayWRbkAchrdKy/+YJm+8uqNXxNxa/
         Rsi9t7fL5u2p6OUJ4aNg4fTfsOWSXtv7RBQ1QcS8RLQpPy4jASaFleFwJrincATerrMz
         +g6HjC0VfN/hcZwef/pOIEyCksYoylBfZyl7PsaMiO+fHoqRXXxRqu0UHYXd8p8ffZ9o
         UvOQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Xzn08Xsc7kDwJ9WnURk+AQXsKYZTAAr7RKZN9XHYFSg=;
        fh=RZburkEFLE/n4WrakVPhd5fhdyP4CPQnprDGu65eAmw=;
        b=IfbmP7TI4hETaK5o49qWrvRkXhyAT0sWOtByYRuJxzrlhWEztYF5xYODU4fe4dPc/3
         xEqoWR24T5HMFjjoOHbYTTp5P7yU1+BKnPzUwxVm59QSvUvZ5xaNRF23NisKvsbIMcVD
         OZYob5wzAILIIp/HpyB9gZzMH9QiBALcckh9QJ8gjTZIoxRCtO7D9HlcWftE1wtZ4I5z
         dBLGpmnC6jKlYriIOMXq2tlzx3t9w2LrjLzLMh+GvpFyJXGJkgal+kvcf3V9yNKU24kw
         CZr2WYprEieYb7whkylWR5qLn77ik35MOh3FWE9QoVHlI+j8S2v3brnAkwTJPggS3tep
         5rFw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1791890637; x=1792495437; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Xzn08Xsc7kDwJ9WnURk+AQXsKYZTAAr7RKZN9XHYFSg=;
        b=AqVooZ/m00QhC6F0NPjZHAtxgw1iYo4Bh0ZmxKagmheRZGu1OzYMvGvF3lrWa/SKYk
         HQrXih2l9hEZxLsJFFPFZAHb2YDGPqtZROhtzq642NnmA+o9FBLEHJa1f81kLl6ZXh/O
         u+trhp7xOPZkKVD6D0lWaZqMFIn2C8Zl71SJRNXiVYAgoMsw45oDDCVZxtELR7i69zFG
         uR30wU61ER9hZFB+ZKgAtMj6YdPo/7m0AAOZXJ09cHO68k6Eb6Xq4ijm8HLshUlslpJ3
         tGUEgJFO9/PSWg8cgDGcM4ZmtyeKUUU+rD2/EoCJ9rHOFgcclYIkwKwPMJxxL5HlyQBD
         j4gQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791890637; x=1792495437;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Xzn08Xsc7kDwJ9WnURk+AQXsKYZTAAr7RKZN9XHYFSg=;
        b=chCR4IGV3U6k3U3rcMAvgBUbV6U1xI+UMz+nJEvxfTxK1/s42mPsLU+8WIqHFqHvIF
         fsEAdSm5fmg49k65wlkeB209mRpaxbqB4sQk54bBO/s7X49oYhl3Z8CdN5x9mE2rFt9m
         x4caJmE0MzGUXaaQDS1DcWd7RuSDwDfvyEgPG9ps669k5Zq9WPyZp70v+mFewsCI8k67
         Xj6Sn5Cpi9nmyqPO6W0hm9J5pmNxZRpiiLk8WpCvnEAhnDXDxmP3/8Efq2IskbWVp/5G
         O0lfFy0DOFL9Alrki5m2/hvT5zsG9M4w7LOVqoYDuMu+j2gPDE7X1LOlBrV10KxZENa2
         8Unw==
X-Forwarded-Encrypted: i=1; AKwUvBxwbm7+v8tEwj9euCw2AzbwrOIbw78UUpTQcBfZWJVkMpnhdrxXXv5H6dHENtxc3p5WMCMAsw5QaQ==@kvack.org
X-Gm-Message-State: AFq9FYI36kx+w9u+OgM4lKkiMyMESmuG91hMZSsk7uXKWThHzbmLolP5
	wZZOY7K6jsmpvBZle1Ip6SyFBa64CDPJAFqV5XUpoNpFhT5wlBzsiIOmCu+OZr4+gxhaV7rG8wy
	N0355RGSuLRLfJ783wEnU5E9xtXJ46EB0gqOEyqJ8
X-Gm-Gg: AYBFou0Z8CD5rYAATOK0fFxG/SSKJFcH0/DtzFoFD7H5zJRmghigv8mE1j/pmF3FeCc
	EUNG8mrLoNyWRLdFY5Quf4ls+pJuz/zPY6KlzxMK1XDCkCNHZ2e8+EDSRbYghiFuo5tfPRrZ70H
	0l+PxedOpyM39PJtWq59WWFVxbeEEbru3ZCoD47Uzcc2cm2Zufnf9tbK4n2vzG7Cwq/oi7xdUne
	N+v53zQTrI5W5TiUzyUcH945EyfqR3e8nSygNw/C3j+iYWCu7BU4gm3PIvNc9z+Pd3PVyOPI3G4
	+g2qH6yCtycK93v7z8aszbR7282N/elcaAJeX17fapd7UkSHMcwMrl5YlE2iAVeJobk=
X-Received: by 2002:ac8:6105:0:b0:531:475:4ce6 with SMTP id
 d75a77b69052e-535b4ed04b3mr47467571cf.9.1791890636806; Tue, 13 Oct 2026
 04:23:56 -0700 (PDT)
MIME-Version: 1.0
References: <20261009063619.112313-1-hao.ge@linux.dev> <20261009063619.112313-4-hao.ge@linux.dev>
In-Reply-To: <20261009063619.112313-4-hao.ge@linux.dev>
From: Suren Baghdasaryan <surenb@google.com>
Date: Tue, 13 Oct 2026 15:23:41 +0400
X-Gm-Features: AclHuK-h0QSYINdnd37OoLMuJ9wy9b_aLEO1B1JVU8ue7bvUVrVwE_vPxVcZz8s
Message-ID: <CAJuCfpHjX+_AvwgqV3XB_QQuorvnegvd_YjQ85JZWfSk-ckUHA@mail.gmail.com>
Subject: Re: [RFC PATCH 3/4] powerpc: drop redundant unmaps of failed vmap mappings
To: Hao Ge <hao.ge@linux.dev>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>, Michael Ellerman <mpe@ellerman.id.au>, 
	Nicholas Piggin <npiggin@gmail.com>, "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>, 
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>, Shrikanth Hegde <sshegde@linux.ibm.com>, 
	Alexander Potapenko <glider@google.com>, Marco Elver <elver@google.com>, Dmitry Vyukov <dvyukov@google.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>, 
	Christoph Lameter <cl@gentwo.org>, Uladzislau Rezki <urezki@gmail.com>, linuxppc-dev@lists.ozlabs.org, 
	linux-kernel@vger.kernel.org, kasan-dev@googlegroups.com, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 536B21C000D
X-Rspam-User: 
X-Stat-Signature: 6ywb84ybpe441cqyws5xindjfi3d41wu
X-HE-Tag: 1791890638-995590
X-HE-Meta: U2FsdGVkX19y6/x8n5hPwKqfRt2hnFcMzXhbcLga0e++nVRobuM3UWqM9xstum8pH8263UGZh63/BbzCWL5HDnn4GyG7FmxsXjSXBVqm2cn/fexpwozkwJqNnA7BQxjRrc5ZU3l/A/i/SCcwRMi1Jv5VbAPlEYi8E9gSjuCimAGibxd/aZv7I7xTxgM7iySyKPjWBjh68bz5qwNtBjH6SWQ0Gp84S4wH3gxXNvpz1gZNw8DdCBx9P6tFyUY4Tc8xXprOBSdE5lqsQr6ywDMy7M19WR6R+FYvjA5VilJd++Lrf5lnQiSujTY3eQnVy8hMrAFhvRwYALiEEHMoGu7/RLCMfta3Oi3a3EdfyFxVX09S3kg14PUvcAo1taelc1AfB2GMusb5VGAG2hRG8Ynvz0mrQ+/uEp4A0jdui7ymJsViZQnpzc//fPMrrZeTgW51fM6PEQ3dTzDLCX31r4vn3fDN9BXZqwhuNmjz05XVxtb4pVkLwc31bntfRppGxOzE6GQt1Z62hrD58Mp2l5V4iqT3oD7rsU27qlt3uCKVaExKnRin9WE2G7izFQiFVT64KP4ArA/twgjwMKQZsSnvZuXwwzpEN0z9Cz+sPnx4ijY5pGFgiutd7pc1vN5K/KKZEi+0nSjpRyMWWeAppPnw1LSxYvikoRTMW7tW3OfdKorcKoSQJsUjzKb5sUW+c1nEcUI2ucxNBuZo5lQI36sgUUo5fTAb9yX1J9qkZGp0V7uxq5OqTsCPw9QSltfvNdppDgnPE7wCAxVJDchaBBJ8SwYVTP3p3tcA2OS1oh8OgePEkzm9Ro+ap0r0I8pfhIK46Ryhvsl9CCicSfL60QLaRhRVx+GOBoNndLrzIqAoQlyPNa/n37+PE4UoOFhejfLX4Z+GHKdscuHz5i28CQ79WJtJCEVP9yIMjL7UVBL1tBBuqoehc8Vpa+mp2+1HcTZXtnFugIsrYUE3pMNqPO+
 JTwzpFgu
 40s1wrd1Ru8jgcg7S2f6Qhxb6Tm2m0Mp0qHNHAPKp0VuwgamDqlzWBy6mYqff0v667nVjzauxJFZz0EL3II1Az7yGT3EO+X+wy5ueJjBUiWrOurTGm7OADGBkR0FSr+zMV+GCh5dp1oVRSoJkn010+YxLEZm6IRnRHQZkyWVcCGqdLZ3fRcwoa7LD4QLJTJf18DZp45QmaJL87IW3VWZrw/V4iuKskIJY3K/Nrx/W+3FjQY0ZCQ/J7prT2td3ZW06qAUr+RemRrFtegDjN6xhE05sPfDFvILYFDjf2tNdYEG19/T84mX+s0QwGloXBJ0RDBEQj1yfcrmLWfHlnLMrdsJ4Pw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 9, 2026 at 10:36=E2=80=AFAM Hao Ge <hao.ge@linux.dev> wrote:
>
> vmap_page_range() and ioremap_page_range() clear the PTEs they
> installed when they fail, so the vunmap_range() in remap_isa_base()
> and ioremap_phb() has nothing left to remove.
>
> Signed-off-by: Hao Ge <hao.ge@linux.dev>

Reviewed-by: Suren Baghdasaryan <surenb@google.com>


> ---
>  arch/powerpc/kernel/isa-bridge.c | 5 ++---
>  arch/powerpc/kernel/pci_64.c     | 4 +---
>  2 files changed, 3 insertions(+), 6 deletions(-)
>
> diff --git a/arch/powerpc/kernel/isa-bridge.c b/arch/powerpc/kernel/isa-b=
ridge.c
> index 5c064485197a..93029d85e6ea 100644
> --- a/arch/powerpc/kernel/isa-bridge.c
> +++ b/arch/powerpc/kernel/isa-bridge.c
> @@ -46,9 +46,8 @@ static void remap_isa_base(phys_addr_t pa, unsigned lon=
g size)
>         WARN_ON_ONCE(size & ~PAGE_MASK);
>
>         if (slab_is_available()) {
> -               if (vmap_page_range(ISA_IO_BASE, ISA_IO_BASE + size, pa,
> -                                   pgprot_noncached(PAGE_KERNEL)))
> -                       vunmap_range(ISA_IO_BASE, ISA_IO_BASE + size);
> +               vmap_page_range(ISA_IO_BASE, ISA_IO_BASE + size, pa,
> +                               pgprot_noncached(PAGE_KERNEL));
>         } else {
>                 early_ioremap_range(ISA_IO_BASE, pa, size,
>                                 pgprot_noncached(PAGE_KERNEL));
> diff --git a/arch/powerpc/kernel/pci_64.c b/arch/powerpc/kernel/pci_64.c
> index e27342ef128b..f74269636d5e 100644
> --- a/arch/powerpc/kernel/pci_64.c
> +++ b/arch/powerpc/kernel/pci_64.c
> @@ -139,10 +139,8 @@ void __iomem *ioremap_phb(phys_addr_t paddr, unsigne=
d long size)
>
>         addr =3D (unsigned long)area->addr;
>         if (ioremap_page_range(addr, addr + size, paddr,
> -                       pgprot_noncached(PAGE_KERNEL))) {
> -               vunmap_range(addr, addr + size);
> +                       pgprot_noncached(PAGE_KERNEL)))
>                 return NULL;
> -       }
>
>         return (void __iomem *)addr;
>  }
> --
> 2.25.1
>

