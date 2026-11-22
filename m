Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8D366606A32A
	for <linux-mm@archiver.kernel.org>; Sun, 22 Nov 2026 03:20:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=F36G0ze4
Received: by kanga.kvack.org (Postfix)
	id 819CF6B05B2; Sat, 21 Nov 2026 22:20:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7F1636B05B4; Sat, 21 Nov 2026 22:20:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 70B806B05B5; Sat, 21 Nov 2026 22:20:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4471B6B05B2
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 22:20:32 -0500 (EST)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A986BC05D9
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 03:20:31 +0000 (UTC)
X-FDA: 85461302262.30.1D57FF7
Received: from mail-qt1-f178.google.com (mail-qt1-f178.google.com [209.85.160.178])
	by imf28.hostedemail.com (Postfix) with ESMTP id BCA56C0003
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 03:20:29 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=F36G0ze4;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf28.hostedemail.com: domain of surenb@google.com designates 209.85.160.178 as permitted sender) smtp.mailfrom=surenb@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795317629;
	b=MfnNChGpR12iWFjliTUxpEkVtu8sW7hwPKKKxSvLpfgsIiu9Cy7aUxlAUCU5yYFprqCXZd
	HH0/nbdwkvOR4r/i3ioKqCNDl2gafN4gnWryqk2C5Dl16GJXk0V/jp+0W1hveRRjKFB9UG
	ZjjSMsctTUt7ZPJNgX7cCUp19/iq1wU=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795317629;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gv3IQZHKimM8bI9m6RymLgtSv850RKl/MFJtLbuy7EI=;
	b=CCmcj9y9S8Mg5+oDALzEZCiCdMg76Jw3oLHuwsNcILpdKW0anWa45ZfJwaoEBLpBm7m31k
	N9rZIxj7itTsl37uXtohusXv3OEBYSvm1v20Bt4stopKYoLRdfZCdYbfs9BiGOv0XBPSuo
	IbAwTBEgPMbv9MGDUCErXYHo0trEl4Y=
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=F36G0ze4;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf28.hostedemail.com: domain of surenb@google.com designates 209.85.160.178 as permitted sender) smtp.mailfrom=surenb@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-qt1-f178.google.com with SMTP id d75a77b69052e-54492d8a988so214661cf.0
        for <linux-mm@kvack.org>; Sat, 21 Nov 2026 19:20:29 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795317629; cv=none;
        d=google.com; s=arc-20260327;
        b=TKDYtcLXAu7qER/Ox37D0n/gah8IjUVREAvJ3AqxTRynDZl/YfrYgXmOwvNY57so1K
         abU5ECTAM6lsjR/SAc1ln/eI9ZbfHG8MRohZrQNNqdn0nfyZKHDtmBFuvyD8PMuMTbJH
         mzDB2yrtb4BWxxwX2piGsNpNWBWOoAoIVe+VbrDqy9/sBmzsf7PvrRMngsp4qKflbA1j
         eTi9vD/+lgzkGK6kJ8++tIySTv6Ed2uqAQhI0fQPdJTguw5rIQ2ucJHTOZMBXwWagmqM
         6JLanpkf3ok+yNznstk+tQUbFaQxYu8lJybvpZ9S3UsM9c8K2aakgtisJQKC2TyJjHXq
         1zig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=gv3IQZHKimM8bI9m6RymLgtSv850RKl/MFJtLbuy7EI=;
        fh=Lt3rE5mQ5z7QUbWFNdJvQolmioyocSALbVz6dLc22zc=;
        b=E4nAqhSE5op7uzDFp/V9s/uvOyLckfBXvcDy0XV49PlpoByFWbw/quDV62WIVzpu0u
         j1TzMxjPP3RQzAHVY20EE29orT0TMOio9USkBSFINELUicomtlSzA8+g5UdX8DYC9QjR
         EbQsVmPG5A9W+pwQg2UGAG7O66n/ngFAcIwOY98XBG+XKzQTbVGtUM1Zu5dowOMrPsYW
         8wDIY6hfXJSk0A2QbSKo6mzFCvtcGJw3xEsPuPrKouKToR/O/oLpqzcLn9bZUfnFHod8
         OJFHGd1Y0jgNf9WBAzfBCAeOgNYMnvc0ep2bt4TKfUguyZaEZvxV3MCfwKttG7lhVCma
         PZhA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795317629; x=1795922429; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=gv3IQZHKimM8bI9m6RymLgtSv850RKl/MFJtLbuy7EI=;
        b=F36G0ze46ltvA8UPre9Qwg2+5UjeqaE0+3hvLcYsOww6KKJBYuHtoeJ/+93gVrTf6R
         NLe2n0cOA+bI7Nji7UqkoBC/CFG6wQj4uSlLRCx+JSz/JtVdqzpTQKBFPqdSYujbMzmB
         gypa9VLa7iofALDj2AChmUXX7UEx17GvIgd4pz9r310SEXQbV87Xdn4JQMGZ1D53Ibhw
         2LL7r6y7Ugkw4+4r5nJl+cHwKfWAnLdtBt67F4NZ5d4gZiahvlfizEO48VgttMtrvpqo
         VdIVuW+flvnIKP2GyCmhlW6Aqv/y2A9wuMfpf28c3OiEOp3ctzscT2eiMHnIby+AX8fL
         aacw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795317629; x=1795922429;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=gv3IQZHKimM8bI9m6RymLgtSv850RKl/MFJtLbuy7EI=;
        b=1li++2AP/iSzA2pDwmPKBr2iEVVNWuJD8j9yRIidRnsCbFMWnSt8/AlSS4UvD1WA3T
         KNwg4Nbvu0Ak2i4TlFCcwESqEdvY50JuARo4nG1YqzBKvJzjFM8snAIZYCkuQmx33qm7
         XtY1Lt0DJ9ElVErYJIGmB0vqpqRseTzx76k/FWTtCzg3J+tm9vgCsrEP3jIThfALyGpf
         YoJp7IH09E2UQ/XkP7dCuooIBJjQnK6Kd+JLyoMq7IxURT8OkZmp0DH+nzWtlHhM1Dv9
         oPHsVq3RsQavtX1BgcmTPMPQLxhRM/AGfXmu3865ePoKNxtYcQ3x1BNiRNtxc+luXkgl
         Qf1A==
X-Forwarded-Encrypted: i=1; AL+hErGqnmlOzeTAO/hAhGZEyEgpeVxBYru3nEZUq8L5eq99sSBnXzCu38WVBK14S485MGtBr4Wr9JCj1A==@kvack.org
X-Gm-Message-State: APuU4Z8Qzs0c9SlxyBjDxYDYeKvkaUIkUzCVl3wc0NMNaKpoz9QezWSF
	HJzkK8pkpfttwOoROM2VSEJDA7t80WfmvEL2R1lh0g0B8q0bI7BqnOUupvv1gzUOqVmPux7bq4f
	xIamM+op/N87kGJglnd1cbNW5u6f29KGzWnpaYtab
X-Gm-Gg: AZFdTZdJiQHx8vYvQfVswECO4tc6SrHDMmz1mM3LjEzkRzKUxmM0BBYxi1+NWA+v4Tp
	NVDLhMINPkSS4fOD+y+XjNzBiyypyaCSFQSokW1dk4yL3RTf8o12ah/O9BL9hMPNqlTYxhLvyws
	aC4O2TqYnq6itg02PJ/C/844iX6foycekteCmOypTEz/BPnmRax8a/DCvZXO7uzo4pwCsODcMdg
	8IcAbP/Uf62ZZxToBkW+woeIBpQp+Ozon5Dk6Cweo/t16SN6kCCX4EtIYqh1EAmoIHug8zz530F
	fIcCq7aTYd+QFRmFGMxuJ97p7puau8PuvqiWOVtJg7W0Goa6gJ44QtXS6UcB7zw3v8Acu7edPdn
	4cKn0ZGqAZjiGtThIF3sa9fILZSoT65ZroolsqamqjgfvzyYhlZ/a0HYmb4Mcd4RyU+zmQ80=
X-Received: by 2002:ac8:6542:0:b0:55b:ab4a:6fad with SMTP id
 d75a77b69052e-55d88fffc05mr16118011cf.9.1795317628142; Sat, 21 Nov 2026
 19:20:28 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261121-some-more-ai-fixes-v1-0-236e925d9b64@kernel.org> <20261121-some-more-ai-fixes-v1-1-236e925d9b64@kernel.org>
In-Reply-To: <20261121-some-more-ai-fixes-v1-1-236e925d9b64@kernel.org>
From: Suren Baghdasaryan <surenb@google.com>
Date: Sat, 21 Nov 2026 19:20:16 -0800
X-Gm-Features: Aa3M54qj2gRAgBBYtx6A2i2xOdED2vuVhUgObvafxq4NJaUBmmLRoUOUdO8rGJk
Message-ID: <CAJuCfpGkHJv3DUL8tByCrN9_PT7MJnRkg+dJH_oj-gm+2q7Nuw@mail.gmail.com>
Subject: Re: [PATCH 1/7] mm/vma: error out on invalid bounds in unmapped_area_topdown()
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Pedro Falcato <pfalcato@suse.de>, 
	David Hildenbrand <david@kernel.org>, Jann Horn <jannh@google.com>, 
	Andrew Morton <akpm@linux-foundation.org>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Kees Cook <kees@kernel.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>, Ollie Wild <aaw@google.com>, 
	Adrian Bunk <bunk@stusta.de>, Xu Xin <xu.xin@linux.dev>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Mike Rapoport <rppt@kernel.org>, 
	Michal Hocko <mhocko@suse.com>, Hugh Dickins <hughd@google.com>, Joey Gouly <joey.gouly@arm.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, linux-mm@kvack.org, 
	Chris Mason <mason@kernel.org>, Josef Bacik <josef@toxicpanda.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: cgo4pnzo46m9sfmw5sdzwfbfo1aaa4dq
X-Rspam-User:
X-Rspamd-Queue-Id: BCA56C0003
X-Rspamd-Server: rspam10
X-Spam-Status: No, score=-23.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no
	version=4.0.1
X-HE-Tag: 1795317629-564014
X-HE-Meta: U2FsdGVkX19pIURUgj4mlIeHe1crJheuKIYHrrhU4khy6vkZvAA5G2gQfz6S47FkyPIA19Xf79wAFOMGEWxE9SeDIr3qpy9aEBcEKTS2Bn6dhZK3afOlkNri9EP0mZFUjpAuB/ZmM85MKYOnVW9l+vdrQup16lvr929mE2AEmAYEPPIlnCsXg3G0WV4uwushNP8VzWgJWhHmtratAVuBVXFWVSDzKxj6Ano9MeALowuL0K5VXmQOUfMFaSyFhV24M10jDG/HnM4v2/ttPkFXYPbyyxaVPZEtCy8T5NINNezqpL/3dFRkbDybkR33F34tEN9OPV5+XIvzbpq662aYykuZm+Mzg3mEgG4ip6jTCs8Wj0c+kgJSUioPvx43ABox74PLgHJ5Pz34Cf/SfmMYUQxMuXR1TIgD32RmggPTXrxNZYJNy62tgqpxaD8Oj857VRgyOQasCfv22S46s7F8K5YkD7JMfHimPLapZc0l7W9WzWacCCLnfx2Dp9ShGUPSa5mcHtQz+xRLjBmdYyVlDyrIsqSUx1RULHUtGbGKUNnF8n1p4SNHFn7h/MBxx8+yFicdlswL5FMCLHIbuu99tYrB7rs5GXbm7/zB/YtEcDB6wUQ5tAWsWgf884kowF6fKxhZI5YKNm+zUvaVrrFC3oCUx9j8eIdfeA88k8Q8CE2/IkI+KgLBgvjgJruyuyVn00P81fYmAa9KyQSmT7859xt7v31a/OKV+fekasizSAH4y5QiQkiR2C8lFh/T8lUBWVASGi0/8oflho+MWVQaDMae4JzR6TFs05f3K8Hqg0q/CSn/ChK5y3B9MQWHPqeIqKXHCgZVOGi59IwMZZqrEYWIRXpqalSFrXj7uzcqzedndRSscmAza54IPalrVKXjsV8ow8xkAdqkZppdyxToBZt+VtMDw27uCaZ6xtmGRaDESUH4ytTIuEZwk+eeM1DNyIDcs34kS0bNtO7S6tT
 nVhdJLUJ
 kntFGf2chrBeaZ7qUjRYtJC9gwAxBJ5y8PunJcIAKK3akPc310bT2d297vkfbXpLJ9HgNddBg/XAwILkcXLp2izRMAb7FnqrHlWMlThqEl1Ma87oMBdoLobAOszOkaETZFhKpzRfCi+FE782DXPDm1ad93BU/nRN0rwEM2LBn4L1fqoFARQBKfp54DR40MI4I14fXR/INy72WL9VPiu5OU8zVwvMZBLT4KHSb8PDcNCGdAxXHX6nCGG6rigwO7/3ZIxMk9zpUzI62J9TiuL3ypIDZ9ZIOv9t/WljSiCMGzHVvnmqDfAR0tHewhjUXiWeodQI5RCF11Hjq/F83F8nQLEixd8x56V4RxS5FOjYfkzScTQ9yT/Y+SeGuhuQpX+5N7b3EvRf/bsLo5Bba993odrui7PUv8Jq17IMQQqG+8BujNlSlAwt4Oqp1XsQ3Latpaxlfp7Vr6lWLuhQl4umyOr5qJEHAheNoETK04pi1NPb+9bf8Rs0p27IAMmiYasc07X4I0FZj5vAWuT7voME+Qg1KHWyn45ZizMMqRrILb2Gj9y8rf45HViiiJA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sat, Nov 21, 2026 at 8:03=E2=80=AFAM Lorenzo Stoakes (ARM) <ljs@kernel.o=
rg> wrote:
>
> unmapped_area_topdown() suffers from a class of bug arising from a mismat=
ch
> between how maple tree functions and VMA iterator functions express range=
s
> - the former inclusively, the latter exclusively.
>
> This is problematic with an exclusive upper bound of 0, as it translates
> to an inclusive upper bound of ULONG_MAX, that is a range which extends t=
o
> the end of the address space, and start < end or equivalent comparisons
> evaluate false in a situation where in fact the expression should evaluat=
e
> true.
>
> unmapped_area_topdown() calls vma_iter_area_highest() to position the VMA
> iterator into the next highest empty range spanning [low_limit,
> high_limit), iteratively reducing high_limit without checking whether it
> has reached 0.
>
> This can result in a [low_limit, 0) pair being passed to
> vma_iter_area_highest() and thus unexpected underflow. Consider:
>
>     vm_start        =3D 0x30000
>     stack_guard_gap =3D 0x100000
>     info->length    =3D 0x1000
>     high_limit      =3D vm_start_gap() =3D 0
>     high_limit - 1  =3D ULONG_MAX
>     window          =3D [low_limit, ULONG_MAX]
>     vma_iter_end()  =3D ULONG_MAX + 1 =3D 0
>     gap             =3D 0 - info->length =3D 0xfffffffffffff000
>
> The result is page aligned and below the IS_ERR_VALUE() range, so it
> does not look like an error. What follows depends on the caller:
>
>  - mmap() with no hint can fail with -ENOMEM while space is free. The
>    bottom-up fallback is skipped, and __get_unmapped_area() refuses the
>    address as above TASK_SIZE.
>  - On x86-64, find_nearest_trampoline() can pick the address for the
>    uprobe trampoline. _install_special_mapping() then inserts a VMA
>    whose vm_end is 0, and exit_mmap() frees kernel page tables that
>    every mm shares.
>  - On powerpc64 with the hash MMU, slice_get_unmapped_area() can pass
>    the address to alloc_extended_context(), which then writes out of
>    bounds of mm->context.extended_id[].
>
> mmap() can succeed with an address from the wrapped window where the
> range above TASK_SIZE is too short for the request and its alignment
> padding. On s390 that range is one page, so this takes no more than the
> default stack_guard_gap.
>
> Fix the issue by converting the loop into one that explicitly tests
> low_limit < high_limit.
>
> Additionally, simplify the logic by declaring the VMA iterator in the
> loop (it is reset on each iteration anyway) and exiting with the correct
> output value on success rather than performing a goto when an iteration i=
s
> required.
>
> Reported-by: Chris Mason <mason@kernel.org>
> Fixes: 58c5d0d6d522 ("mm/mmap: regression fix for unmapped_area{_topdown}=
")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Reviewed-by: Suren Baghdasaryan <surenb@google.com>

> ---
>  mm/vma.c | 42 ++++++++++++++++++++----------------------
>  1 file changed, 20 insertions(+), 22 deletions(-)
>
> diff --git a/mm/vma.c b/mm/vma.c
> index c82e9306b11a..09bbcdb4971b 100644
> --- a/mm/vma.c
> +++ b/mm/vma.c
> @@ -3369,8 +3369,6 @@ unsigned long unmapped_area_topdown(struct vm_unmap=
ped_area_info *info)
>  {
>         unsigned long length, gap, gap_end;
>         unsigned long low_limit, high_limit;
> -       struct vm_area_struct *tmp;
> -       VMA_ITERATOR(vmi, current->mm, 0);
>
>         /* Adjust search length to account for worst case alignment overh=
ead */
>         length =3D info->length + info->align_mask + info->start_gap;
> @@ -3381,31 +3379,31 @@ unsigned long unmapped_area_topdown(struct vm_unm=
apped_area_info *info)
>         if (low_limit < mmap_min_addr)
>                 low_limit =3D mmap_min_addr;
>         high_limit =3D info->high_limit;
> -retry:
> -       if (vma_iter_area_highest(&vmi, low_limit, high_limit, length))
> -               return -ENOMEM;
>
> -       gap =3D vma_iter_end(&vmi) - info->length;
> -       gap -=3D (gap - info->align_offset) & info->align_mask;
> -       gap_end =3D vma_iter_end(&vmi);
> -       tmp =3D vma_next(&vmi);
> -        /* Avoid prev check if possible */
> -       if (tmp && vma_test_any_mask(tmp, VMA_STARTGAP_FLAGS)) {
> -               if (vm_start_gap(tmp) < gap_end) {
> +       while (low_limit < high_limit) {
> +               VMA_ITERATOR(vmi, current->mm, 0);
> +               struct vm_area_struct *tmp;
> +
> +               if (vma_iter_area_highest(&vmi, low_limit, high_limit, le=
ngth))
> +                       break;
> +
> +               gap =3D vma_iter_end(&vmi) - info->length;
> +               gap -=3D (gap - info->align_offset) & info->align_mask;
> +               gap_end =3D vma_iter_end(&vmi);
> +               tmp =3D vma_next(&vmi);
> +               /* Avoid prev check if possible */
> +               if (tmp && vma_test_any_mask(tmp, VMA_STARTGAP_FLAGS)) {
> +                       if (vm_start_gap(tmp) >=3D gap_end)
> +                               return gap;
>                         high_limit =3D vm_start_gap(tmp);
> -                       vma_iter_reset(&vmi);
> -                       goto retry;
> -               }
> -       } else {
> -               tmp =3D vma_prev(&vmi);
> -               if (tmp && vm_end_gap(tmp) > gap) {
> +               } else {
> +                       tmp =3D vma_prev(&vmi);
> +                       if (!tmp || vm_end_gap(tmp) <=3D gap)
> +                               return gap;
>                         high_limit =3D tmp->vm_start;
> -                       vma_iter_reset(&vmi);
> -                       goto retry;
>                 }
>         }
> -
> -       return gap;
> +       return -ENOMEM;
>  }
>
>  /*
>
> --
> 2.56.0
>

