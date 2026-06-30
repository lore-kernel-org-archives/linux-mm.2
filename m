Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8C0BDC43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 10:57:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 76D056B00C7; Tue, 30 Jun 2026 06:57:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 744AE6B00C9; Tue, 30 Jun 2026 06:57:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 65D096B00CA; Tue, 30 Jun 2026 06:57:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 435466B00C7
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 06:57:26 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C8556120441
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 10:57:25 +0000 (UTC)
X-FDA: 84936277650.19.84ABAB5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id D6090180002
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 10:57:23 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ml0Ca4UA;
	spf=pass (imf06.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782817044;
	b=Xne7S9KnbE9kaQ9StA4ov7Bpi73R37l8ystqIK7Wvx5kmaeWh/NSbAt0oXGZdYdI4lTwBt
	9MIN34PK8dstzCe3FLosDbVgxg4G1ID/8R6LPkvwO2faw2D19eHTojeuiLEbzMm4I9GFIQ
	zc36VD6tiWC38u83y1VIt/O+sd+064k=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782817043;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2+HA/JoBOxFhZJaSk9aZ5CarxkWj6UA49Z/NltJ50Cg=;
	b=Fcs/DajsRPvuTNURjKYTkwnQvUy1rgNy5RhLLFzl5cl/FduxpWSBw03K0ZJgCPk2WK2sJ3
	bTZXEnZRcY0+AGKJD34WmYD6MVTKwpKtgQcn2/tnoGyrYmLVrtTLPN1KXtOH/0Ueza4VGM
	0OTPtNtbQtr8K4YSNkjSGa7BO2cJDQg=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ml0Ca4UA;
	spf=pass (imf06.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0C808407C5
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 10:57:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E58C41F00A3A
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 10:57:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782817042;
	bh=2+HA/JoBOxFhZJaSk9aZ5CarxkWj6UA49Z/NltJ50Cg=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=ml0Ca4UA8WnoIceeByIqxj9zleRHe4d4FldENXK+iKmBFAipQ75AEdeo/fGCqmRJC
	 Qubr3JAb4291J+0F8rRqobUgfrwR7AEdiTQvF3tERlrAkYYJAQt4tCZDdZDoc0Fmbx
	 FAaWWdZewjg/UrTOTRfiw+6Wi7dHvD0F0+oujEHCJvNwNi9jzf9SgfnQ17icKyQsNW
	 jsIphJi6kruZaAP1WC44aB58wb14jYgWJSz1GFqjOlCjw9IYclQq4dPwYUUbWJuVCd
	 rMjHy84CAguLrfYAops3rN5vfJdoFQTBYkmIA3Z+9ui4Xe/zGr01rwoQEuNm97vpkN
	 GtkF6n/sh4ACQ==
Received: by mail-qt1-f181.google.com with SMTP id d75a77b69052e-51c0006ea8eso15461151cf.1
        for <linux-mm@kvack.org>; Tue, 30 Jun 2026 03:57:22 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ+s4x68Y9VD0do4RSpcKjzL/iOjiz8A2GqHs7930sOK0uEoI9EYo7SyunlA1p5E/Mp/Ve6d/yKV0g==@kvack.org
X-Gm-Message-State: AOJu0YxOpjrQ/L2dr6GVxuZq4/1GmX/kqLhhkIaKGo/upaQKkq/g9s8j
	XBXLNIGdKStaZp7FEtt9R/5Pkyr3kruTktUH1tliJcnQLxBMqaPPVIcv7TCjZPSrDCj8FvFXzqL
	nfdPAUIxcj5LpWKHyQEKa33PvJmzFf5g=
X-Received: by 2002:a05:622a:207:b0:51a:8c86:bd40 with SMTP id
 d75a77b69052e-51c1ca5ad03mr786431cf.61.1782817042418; Tue, 30 Jun 2026
 03:57:22 -0700 (PDT)
MIME-Version: 1.0
References: <202606291606.9h8aGniQ-lkp@intel.com> <20260629171909.1d6e96dd15a80b8f463bb68a@linux-foundation.org>
In-Reply-To: <20260629171909.1d6e96dd15a80b8f463bb68a@linux-foundation.org>
From: Barry Song <baohua@kernel.org>
Date: Tue, 30 Jun 2026 18:57:10 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4wViR10e-9B1qqv5MNTMGVHVGLDiDzqh8PM=PPfm5rCTA@mail.gmail.com>
X-Gm-Features: AVVi8CfRjXxRj_MDC-E8kjBOS5LOmhQQQo2Vt2_pEXaIk32vDSLRHRLAK_LHPZk
Message-ID: <CAGsJ_4wViR10e-9B1qqv5MNTMGVHVGLDiDzqh8PM=PPfm5rCTA@mail.gmail.com>
Subject: Re: [akpm-mm:mm-new 59/142] mm/vmalloc.c:3590:23: warning: unused
 variable 'start'
To: Andrew Morton <akpm@linux-foundation.org>
Cc: kernel test robot <lkp@intel.com>, oe-kbuild-all@lists.linux.dev, 
	David Hildenbrand <david@kernel.org>, Linux Memory Management List <linux-mm@kvack.org>, mm-commits@vger.kernel.org, 
	Dev Jain <dev.jain@arm.com>, Wen Jiang <jiangwen6@xiaomi.com>, Guo Ren <guoren@kernel.org>, 
	linux-csky@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Stat-Signature: ya8zyofstsoirz9q5f4mah5xzc3xqya6
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: D6090180002
X-HE-Tag: 1782817043-785193
X-HE-Meta: U2FsdGVkX1+lpccac4lk99W2BG5/QJjxV2IBUBC4xhW85yM1MR4+qRsEPk5VxLycKheHt6eXEK5Nyp3ifq4Shpc6bjXyFGAh2TBJNQoQd2DqEui8ga3SiX8eEdly7dyNPSsnCB8H4LSpPAuyuSfsMtajGJ2tAdSyn6N9UCrKVOi1uwSuFssWBG6GJiXTaSOhpIl075M0AqOuajpbjuH5+z7AGTwRVumrguNIXTUzgemfRMna899vsBl+jv9DZoeMriQP3fK9gZYqdCV74hRQgUPmdGGRWkodYFT/ArZQEt4B+ETT2c3wgysjhG8KnyJe4qtmfc2bzfp56Yt5etdz9Ft53X842lflnvAA/UaFC/1/mvPndsSwX9Fsq2RXFCWB1c6oDK38QE3Bw/elK5q8SfDmPpT5tN+bWdqaqnkJmW5AHW199wjrhBXUNiKAloJbP7gtd3sesZV44Hn8NHlPayezSTwZ2+guGKilnmSo+m44ju6KEF85Ab11I224vcPGrIYTunq54MUTAQ6Q+EAKsArXXfTWM9ad3ttHQFglHMmUgYAvA7LANN6mchhJNXW539wSXtZU8MkVSOVSMM4NK3UWX/tcBj8QmmqJSSt66KCOu04LZSQ7ij2Lf2HYH1SjwpLsVlhTl5vW6DgxjE6obRV4x6ob1yiCaMNtypUVg5+YkZ7JsFc1cfisPpc5C0GSYD94PMjyW7lCGVcaPSWUenEUkG5JMihWZamnMSUYaCJDNVTcQFVEeIqChet8pTkbGf2gXSoGt+wD8qeZ69YSqX/G0jpGDGWN9bfQCCEqICnpxyuPC+U/lfXZeQwOF2l8/fIvGnDyGyjOJFsWotYaaqjDPmItFSUoTLuksoodOdEzYtIKS55WlflCZ6Ml0BGkLNpdEr4V1wJeuQOqxqLiCqI9gTsPzWpEvfQ6CKDvrEpPPLR3/tmwWy+EttQ4cx8tvtKSfHqYLbcm4ZJBkk7
 fA/IFesz
 vkhqjWsY3Yjz/CMH8oCxLMhSABGeMXlV8wDAK5gj0MxCu7Z3tHRmwURjC+sQ4xmG5amNqi2bkcWuSkmZweW2zqYueDN44ay1Yt+fey08W1B+clz9vJk7/PQTS/sLSwy9o7bL7ua6qEzalgZ1n6mAwXFjCLebDQKetlVFGDYXR+2lOfyeIcIZUN23DZ4Kbbw6yCodCNA1wJ15jXBYNVGZiInM2Qc385cEaOhxxTz5g1wHLcw7Nq+MCQUGJSzEUpoulaBmvDDG8trhia6c2mdTQCnF96O1i9W/l7QYqHth+eatQFNhUXr7YOVSEjbOv8Py464EILhjdSH0TyOlnFH4sKebqPLymfJA4TMI+K+/5w0RP22kbXxmzszfwC2f/HeUcElyOpSH5gnMwK1nEL+/ye/GIZ7GrP1RIntzdmQCLT4Q7gJrUI5jgB8H73bOYGilygdKmrSuUJAYq9fDs79+rX2Opk4g0zXEB3LjpcL3nLJbz3yauVbMKD2Najrp7tUuS4tJDXvbXAko/yVb0vV96e+jKuOX95Mwzjoyjq+hHGlfsBCYKaIgnGxXjqfX0pQxykpSlnewQjqjoqeA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jun 30, 2026 at 8:19=E2=80=AFAM Andrew Morton <akpm@linux-foundatio=
n.org> wrote:
>
> On Mon, 29 Jun 2026 16:58:34 +0800 kernel test robot <lkp@intel.com> wrot=
e:
>
> > tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-=
new
> > head:   88cefc306c43b58d9bb65c9e96e284306710d961
> > commit: 80c453511b6ee1af0e4db83c3db0020215c4eaf0 [59/142] mm/vmalloc: m=
ap contiguous pages in batches for vmap() if possible
> > config: csky-allnoconfig (https://download.01.org/0day-ci/archive/20260=
629/202606291606.9h8aGniQ-lkp@intel.com/config)
> > compiler: csky-linux-gcc (GCC) 16.1.0
> > reproduce (this is a W=3D1 build): (https://download.01.org/0day-ci/arc=
hive/20260629/202606291606.9h8aGniQ-lkp@intel.com/reproduce)
> >
> > If you fix the issue in a separate patch/commit (i.e. not just a new ve=
rsion of
> > the same patch/commit), kindly add following tags
> > | Reported-by: kernel test robot <lkp@intel.com>
> > | Closes: https://lore.kernel.org/oe-kbuild-all/202606291606.9h8aGniQ-l=
kp@intel.com/
> >
> > All warnings (new ones prefixed by >>):
> >
> >    mm/vmalloc.c: In function 'vmap_batched':
> > >> mm/vmalloc.c:3590:23: warning: unused variable 'start' [-Wunused-var=
iable]
> >     3590 |         unsigned long start =3D addr, map_addr =3D addr;
> >          |                       ^~~~~
>
> Sigh.
>
>         unsigned long start =3D addr, map_addr =3D addr;
>         ...
>         flush_cache_vmap(start, end);
>
> See, this is our punishment for writing kernel code in CPP rather than
> in C.
>
> I'll queue (and test) the below.  It should be OK -
> arch/csky/abiv1/inc/abi/cacheflush.h directly includes asm/cache.h
> which declares cache_wbinv_all().
>
>
> From: Andrew Morton <akpm@linux-foundation.org>
> Subject: csky: implement flush_cache_vmap() in C
> Date: Mon Jun 29 05:07:51 PM PDT 2026
>
> To avoid getting an unused-var warning from
>
>         unsigned long start =3D something;
>         ...
>         flush_cache_vmap(start, ...);
>
> Cc: Guo Ren <guoren@kernel.org>
> Cc: Andrew Donnellan <ajd@linux.ibm.com>
> Cc: Anshuman Khandual <anshuman.khandual@arm.com>
> Cc: "Barry Song (Xiaomi)" <baohua@kernel.org>
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: David Hildenbrand <david@kernel.org>
> Cc: Dev Jain <dev.jain@arm.com>
> Cc: Leo Yan <leo.yan@arm.com>
> Cc: Mike Rapoport <rppt@kernel.org>
> Cc: Ryan Roberts <ryan.roberts@arm.com>
> Cc: Uladzislau Rezki <urezki@gmail.com>
> Cc: Wen Jiang <jiangwen6@xiaomi.com>
> Cc: Wen Jiang <jiangwenxiaomi@gmail.com>
> Cc: Will Deacon <will@kernel.org>
> Cc: Xueyuan Chen <xueyuan.chen21@gmail.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

Thanks for the fix. We even have a checkpatch check and coding
style documentation for this:

6813216bbdba ("Documentation: coding-style: ask function-like
macros to evaluate parameters")

b1be5844c1a ("scripts: checkpatch: check unused parameters for
function-like macros")

Reviewed-by: Barry Song <baohua@kernel.org>

Best Regards
Barry

