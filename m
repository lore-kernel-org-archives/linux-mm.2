Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C5783CD6E57
	for <linux-mm@archiver.kernel.org>; Tue,  2 Jun 2026 15:01:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DA8BE6B0005; Tue,  2 Jun 2026 11:01:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D80686B0088; Tue,  2 Jun 2026 11:01:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C971A6B008C; Tue,  2 Jun 2026 11:01:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B5D2B6B0005
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 11:01:24 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 4F011C2E02
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 15:01:24 +0000 (UTC)
X-FDA: 84835286088.19.E51ACD8
Received: from mail-yw1-f169.google.com (mail-yw1-f169.google.com [209.85.128.169])
	by imf29.hostedemail.com (Postfix) with ESMTP id EFFFF120016
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 15:01:21 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=berkeley.edu header.s=google header.b=XSwvRjVV;
	spf=pass (imf29.hostedemail.com: domain of farhad.alemi@berkeley.edu designates 209.85.128.169 as permitted sender) smtp.mailfrom=farhad.alemi@berkeley.edu;
	dmarc=pass (policy=reject) header.from=berkeley.edu;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1780412482;
	b=B9n+ADVobb90vijfxdQ0QGHqF3dorbVTfIveP9XCNmpWxIlMWvGGNiMPZ//2O6wkCDXKg3
	GLLZ1O0sT2tB/7eVzGeXL0q+oifMKUHW59ujGEMfRufiiol9Kf1xeMZzcgz11B8rgOO1Mo
	BANAO/attT9t7y+P0po29D1bbHPWDbI=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=berkeley.edu header.s=google header.b=XSwvRjVV;
	spf=pass (imf29.hostedemail.com: domain of farhad.alemi@berkeley.edu designates 209.85.128.169 as permitted sender) smtp.mailfrom=farhad.alemi@berkeley.edu;
	dmarc=pass (policy=reject) header.from=berkeley.edu;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780412482;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2n1Z1p1zE/++mzakGGp7plWPOy4Oh6izK+XdQVDmCrg=;
	b=AkODyo1Rx9vAeF8vR2QEZ95G/jHtiHiS0BE2Nf29jgXtFYcNT7LWNC+UVADdlzNY2Nlt6r
	kK9vfuOL5e+wOdaItReDzLNXyGH8jBZXIDvBnMMSMPQ9nh4jrj2SHXM1NykO/haUkhy/GE
	ulAac5Pn/NRDgJFW8JNEwDlZLujLGis=
Received: by mail-yw1-f169.google.com with SMTP id 00721157ae682-7e0aa486af8so24847767b3.1
        for <linux-mm@kvack.org>; Tue, 02 Jun 2026 08:01:21 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1780412481; cv=none;
        d=google.com; s=arc-20240605;
        b=B8D05TnH1j3nS+UU5eFDjHcfTqSsjL0gxg05P4WU8JKCWQWviggZUKKFn+vj93IzxU
         mhjiBush3rtSPag9AmanTgKXc1wRrFFmKPCxEn02a1WRTSBQ7mFUyue2deD6PtGKd0Qk
         HjLy4rpWowL/03C56NVltCRltsmeWnGz9szIJkbyewxVHUXXN9oG3cX2kmjw/wZbnOZF
         ODIU/gJCEkUlntajkRT36Oudo+uy+E/GLoJRsJkuyTnHDTPtLqez8N8jK617W/MtWQ2Z
         OTq8nVxrsK65fuDRM8xCcNY7JvPHMQ/lf37b/gwDdJl5SDUofvVo2TW/D4F1tAhrSc5a
         KYgw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=2n1Z1p1zE/++mzakGGp7plWPOy4Oh6izK+XdQVDmCrg=;
        fh=bTOGu5I0VZZEh83e695y5zHmIaq8HPqXwe2EMke4+UA=;
        b=IQzWBua5Nv0cS1q4QrzqftxzLEpepDYnnvyNUON1c3JyE4ZcIaruh59S07Qo3leaG+
         kYeKbpsZaDlx41vYU/LYZinh66mPm4pJ5KgN8yXmyIZUJKADiqtEfqZv6imJ7PMD+Oph
         uwwNuh65TSs2nkGfIm0iZ1/unb7rlv6AorDl6qYOF+7MJPyAlwi11JsdYmoPBS0OUmnG
         pMI3L53CNH2ErY6cvImf0yLRdP6k0wpDu9WAvQkiNGO693vnHWEtehVu/cu3N1FfOdA2
         NrKaMHs/YOzoXEzK/MaixPhiKgVrHsfv1dnW6zBM76jNwjrPv8K073oJGl+uJTtSbnBP
         ASXA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=berkeley.edu; s=google; t=1780412481; x=1781017281; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=2n1Z1p1zE/++mzakGGp7plWPOy4Oh6izK+XdQVDmCrg=;
        b=XSwvRjVV+H16t2MUX5M4e01mQpUIl34sTUgndvCHNE+PyO4i3qMtNUcGEykDuimslo
         DvfTm6I84d6mQWr47xAlGYjCv/w7g4oruZpNGRWcZZjDUlEPQuecFJPtTLiaFdx/Ttad
         EuRXI1vO51XOmPT6D5VZNvxQ2w3PHh6CrOpszmqp1qSaBtPQpdrprP6dmQB9siwOt51M
         0JQcvYENlX56ZBWs5paPFUcCHTZO0SXBIG/A8KM0nYxuArDOFUQ0Hk2w5RuaG0GrnF1c
         RnO1reiQi0UeNFSTGR3v6x4E8dbws9WbDUgAcaOXhnMeHzXdPT9rhhSimSMGNlRvPoxE
         2+og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780412481; x=1781017281;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2n1Z1p1zE/++mzakGGp7plWPOy4Oh6izK+XdQVDmCrg=;
        b=XijWOWIX5JAk7bNlED/50K9dfdVc/0m1iia8TVi7Ef5AJFZNfn8nTriANEgTC9xhMg
         aIhqhDfJvLL3cBd+sAl9dyWzk48jLOzMaZJhq2zOYdJPffSGYezEABw5lMMI2zRYbujb
         2RcDsvfxIVEPeAIltfOvItjg5MG9xYoptwJGfxBsvR0X1STUqTXB30X/hDSI8IN66/nW
         k1I/eaKU67E4Wgz8AL/kNdKOyX+TEIQ9Zvx2qfkCJKV+LADo9Mb0YWNdVQRb0yC+yH2o
         64hJrVnLEkq70WzbGrQn5V8YZ5IPioR7DZAQifFEo8g53TlmLO5Md9ZaceQ+n6469KD2
         f3Bw==
X-Forwarded-Encrypted: i=1; AFNElJ9gUjoFzXCbtxl5+n2v18MRaXmZrVipwAeQ8z5iEzhTwfK5HMKklH232UARwPOXv6UUUxf81a2uOg==@kvack.org
X-Gm-Message-State: AOJu0YxNvnKF22N25H5iS77iS1L2BXZjQf97uWvFlb6gqOKgp/0keLPP
	+t8h5KlTdBOz6KJdJGOzEYnVhqEgCf+pbqpPSSqj+vUoo6DqIJR2V+Uc1CtjhYejDi51mTGiwrV
	BYi7Oas9E/Qpb2mD+xXq1xWnzr8XBTodxV1yeSMB7
X-Gm-Gg: Acq92OFOKyI2avsP9R4unxJ2pjQxjlwoPRIApnRj07pR68jSfYqLFmu4mDcSjOA+Zut
	d16uRVK7ejAJ2ZTzgwNtfICtF2P3rpybpxX0MrGSvOScDr5aFmtG3qvdjA7uFb7OjJDDqcEHZ8R
	+PZOFDaz/jtLMPSv0Z+LfW75ZpkdemOTQseOlmiVHhtGmIqwDVBmScsUmXcypJ6Qq/3LoUt4pXH
	RW2U7JBwZV2aGLLwdoGa+vKMK4PQ/KuLz9L+tEnma9LuhIJynbr/C5oupVERKAznjGj0HEjNK8U
	JpBAvoGu2NzBp+okC/c/Dtyq8wW1wJUIYAwaNxfZlLjLU71RIIE=
X-Received: by 2002:a05:690c:9b0b:b0:7ba:dcae:14dd with SMTP id
 00721157ae682-7e83c6bfa06mr40726327b3.19.1780412478962; Tue, 02 Jun 2026
 08:01:18 -0700 (PDT)
MIME-Version: 1.0
References: <20260528124133.c88c27b11a8ea0ef05e494f7@linux-foundation.org>
 <20260529152616.2308736-1-joshua.hahnjy@gmail.com> <ahnRIDBk4bQ3xX2q@yury>
 <fe33c767-ea11-43e2-8732-f752c9c1205c@kernel.org> <ah6X-RtVX75YP7VX@gourry-fedora-PF4VCD3F>
 <c98eb14d-b878-4eeb-91f0-d2b1d4407e1e@kernel.org> <ah6oS7wiGB4u4-eR@gourry-fedora-PF4VCD3F>
In-Reply-To: <ah6oS7wiGB4u4-eR@gourry-fedora-PF4VCD3F>
From: Farhad Alemi <farhad.alemi@berkeley.edu>
Date: Tue, 2 Jun 2026 08:01:07 -0700
X-Gm-Features: AVHnY4JOgLxBTRoGJX0GhSA3-jleDuxY969AKZ4HYjUMghfMsszmyTDYa4YVtMY
Message-ID: <CA+0ovCiEz6SP_sn3kN4Tb+_oC=eHMXy_Ffj=usV3wREdQrUtww@mail.gmail.com>
Subject: Re: [PATCH] mm: don't allow empty relative nodemask in mpol_relative_nodemask()
To: Gregory Price <gourry@gourry.net>
Cc: falemi@asu.edu, "David Hildenbrand (Arm)" <david@kernel.org>, Yury Norov <ynorov@nvidia.com>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Zi Yan <ziy@nvidia.com>, Matthew Brost <matthew.brost@intel.com>, Rakie Kim <rakie.kim@sk.com>, 
	Byungchul Park <byungchul@sk.com>, Ying Huang <ying.huang@linux.alibaba.com>, 
	Alistair Popple <apopple@nvidia.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Waiman Long <longman@redhat.com>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, cgroups@vger.kernel.org
Content-Type: multipart/mixed; boundary="0000000000005d93b306534695f4"
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: EFFFF120016
X-Rspam-User: 
X-Stat-Signature: p6ie4f9jfoyxba88fx8mjynzayjpy4tq
X-HE-Tag: 1780412481-365156
X-HE-Meta: U2FsdGVkX1/bFOWpsCtd/jMBdVO5U1nEDAXX3S+Y9Hs/TUxSfgdKoczNgjET/Nx6gvXtL5aBBZw30py9X/MoY9K2DiDqvp/SfFY+KkJ2UFJ1wVNLc7bs2Ji5CcG+d3gGNxtXtFvxjUXEwhVL8wVHwSFZ/0TkR/Rv8uWbSk0Qu/1Bkekt85uicoOY7E8S4l/iC125beN4eIA9Zepj14WCV1Zd7mQUXOgo9bppLdu9ruGMQYGR2fEqdhS/r5t/2cm5fmVcr1ABTyVNn/3g0TO1nBhn4uc6Fb+HlESmIH9LgREkTmdq8O1GQ+H+Tuaoa9nUcH1QZlRhxTqzpOHfPRPfZO3Pj6qBsSvhLfM+kfeRUvLrJfz7L+7qZFpq6R3nRPXufdCUvZtPZdcXJDXxhrSxMPT5wjm2AigqZjlAH40pXu7jrgvbE3qrAGlqpSnUZch5mnCRAHUzYZnEoRaZDotWTiOQe0Wq0XGkduLDuiwMtp6/Z2R8Xrl+KphYl09ZUdFC+2YwSAfKP4np0O3r1as5ef5pF6iKALlB9eEY0ghvVgFnhSAbRNBtEc3BVbedUiO/TbFwpCuYV0wVQUhEjegISBRDjJwnqptKMLnYFLQjk3aaR81q+d/bxYAetCBjB2rTHiRKaCKHJViQ7m4RvI0SAr3740/IaVMimgZDqdly2nLp2Db8Cd7ZHKTOSmzzfxBvZfY7+q2rtRJ9WXkPlVYvCFduebREWSVKo+0fHzfXznB5Y3AB43jql/tlUs6tY+f0m7zvuNYpPDzme/soj/eqNM9zPdJw/JfwvNwEtzvpL/aI2DRl2H+tCk5Fv/SG0TpnptfyKl6QdyS8wEZn8MQ6C7ymlgP/vUpgdKc77jL+BHOHJ83V6ORZyBvQp85oV5EwUuKMsipVZL4xfqyTrI6uj6rprWxFER8T519e897mm012FlLupwFJKUkPPEUSv8ise5OqI1EcDay2tOxBWtl
 kg8WumOh
 YYAFK4NKqxSSSKd6iLLkQbYQKqFAnSdXdTBmbwkDsq2Bm6pacArvIHeyYQbAyLnz7ZI4XfsrL2RbXle0vOxMdvId4NAQz6pqL0yJVf5lHoykcV8mF1scfLKA2wcjjPzU6cRLGUFPY0+gB5Id1/uOaGyKu+C61q/DtM4FmRYvByFABJ2Yt+rMRi3WmExqsKhnoI+jGw/tl5rjkgAgtWclcgV9/xhrYUFlMKpk3Rh1I45/UuruvqSh3xl19bZi6eYXxfk/pwdhoCBH75AmRUcNHNoSm6gdck+mlZcPiZopwqBUkqM4YjH0iM3GR1fWjN6EZC1i66vazQ1q8r+Z5km3MvxFKUOz0P/479p9vPQ/n2wnHMEcz27dccT0gZR5MpPOPexCDbCHzKDXGZUKuIRUA7ehrLfsdshKJpBMALJ8RtjYMY6pK6uuBqNiB+Skz05HT3ZJ0MtTYTzJ2tGCq5xnIqUBtAmKMDMGxYKtRiO2g3gYS4BZ8g2nIXI+WiT1T0kHiaDrlQxcW4g1MA1mcdh2gBZHi+c01SywKuhtW2VvjfWQacZuWnk46/o8miD5Sxi9OysSVDDNUaBJwSWud9ikcu6On4g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--0000000000005d93b306534695f4
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Confirmed, with a standalone reproducer (attached); it panics linus/master
at e8c2f9fdadee. cs->mems_allowed can legitimately be empty
on v2 -- a freshly created cpuset child that never had cpuset.mems
written keeps mems_allowed empty (never initialized) while effective_mems
is inherited non-empty in cpuset_css_online(), and v2 allows attaching
tasks to it (the empty-mems guard in cpuset_can_attach_check() is gated
on !is_in_v2_mode()). So the non-empty guarantee holds for effective_mems,
not for the configured cs->mems_allowed; forbidding empty cpuset.mems
would break v2's inherit-from-parent semantics.

The reproducer enables +cpuset, mkdirs a child without writing
cpuset.mems, moves a task in, mbind()s a VMA with
MPOL_BIND | MPOL_F_RELATIVE_NODES, and offlines a CPU; the hotplug walk
then calls mpol_rebind_mm(mm, &cs->mems_allowed) with the empty mask and
folds modulo nodes_weight(*rel) =3D=3D 0 (console logs attached).

The newmems instinct looks right: it's the effective, online mask the
task is actually allowed to use, guarantee_online_mems() keeps it
non-empty, and it matches cpuset_attach(), which already rebinds against
cs->effective_mems. The fix this implies:

  - mpol_rebind_mm(mm, &cs->mems_allowed);
  + mpol_rebind_mm(mm, &newmems);

I built the current base (e8c2f9fdadee) with and without this one-liner:
the unpatched kernel panics on the first cpu1 offline, while the patched
kernel runs the reproducer's 8 offline/online cycles cleanly, with no
divide error.

This regressed in ae1c802382f7 ("cpuset: apply cs->effective_{cpus,mems}",
v3.17), which moved cpuset_attach() to the effective mask but left this
rebind on cs->mems_allowed.

Happy to send this as a proper patch (Fixes: ae1c802382f7, Cc: stable,
reproducer) if you agree the cpuset side is right, or to test a
mempolicy-side fix if not.


Thanks,

Farhad Alemi
PhD Student
SEFCOM Lab @ ASU

On Tue, Jun 2, 2026 at 2:54=E2=80=AFAM Gregory Price <gourry@gourry.net> wr=
ote:
>
> On Tue, Jun 02, 2026 at 11:19:49AM +0200, David Hildenbrand (Arm) wrote:
> >
> > According to the report [1] syzkaller can trigger it. There is no repro=
ducer,
> > though.
> >
> > [1]
> > https://lore.kernel.org/all/CA+0ovCgxbZkXa+OU8w3s84R3KNPNxxRfmsNR-udh+a=
fQBbGNmw@mail.gmail.com/
> >
>
> The actual implication of this report is that there is a bug in cpuset,
> not mempolicy.
>
>   mpol_rebind_mm+0x3ab/0x680 mm/mempolicy.c:569
>       ^^^ should never receive a 0-node nodemask ^^^
>   ...snip...
>   cpuset_update_tasks_nodemask+0x22e/0x340 kernel/cgroup/cpuset.c:2777
>       ^^^ calls guarantee_online_mems ^^^
>   ...snip...
>   hotplug_update_tasks kernel/cgroup/cpuset.c:3882 [inline]
>   cpuset_hotplug_update_tasks kernel/cgroup/cpuset.c:3985 [inline]
>
> Relevant code:
>
> void cpuset_update_tasks_nodemask(struct cpuset *cs)
> {
> ... snip ...
>         guarantee_online_mems(cs, &newmems); <<< critical call
> ... snip ...
>         while ((task =3D css_task_iter_next(&it))) {
> ... snip ...
>                 mpol_rebind_mm(mm, &cs->mems_allowed);
>
> Seems like maybe mpol_rebind_mm should be called with newmems, not
> cs->mems_allowed, though cs->mems_allowed should never be allowed to be
> empty, because that makes no sense.
>
> Just eyeballing it, I can't say whether calling with newmems is the
> right thing, or if mems_allowed should not be allowed to be empty, would
> have to dig in a little further.
>
> ~Gregory

--0000000000005d93b306534695f4
Content-Type: application/octet-stream; name="reproducer.c"
Content-Disposition: attachment; filename="reproducer.c"
Content-Transfer-Encoding: base64
Content-ID: <f_mpwrc4p10>
X-Attachment-Id: f_mpwrc4p10

Ly8gUmVwcm9kdWNlciBmb3I6IGRpdmlkZSBlcnJvciBpbiBiaXRtYXBfZm9sZAovLyAgIChjcHVz
ZXQgaG90cGx1ZyByZWJpbmQgb2YgYSByZWxhdGl2ZS1ub2RlcyBtZW1wb2xpY3kgd2l0aCBhbiBl
bXB0eQovLyAgICBjcHVzZXQubWVtc19hbGxvd2VkKQovLwovLyBMb3JlIHJlcG9ydDoKLy8gICBo
dHRwczovL2xvcmUua2VybmVsLm9yZy9hbGwvQ0ErMG92Q2d4YlprWGErT1U4dzNzODRSM0tOUE54
eFJmbXNOUi11ZGgrYWZRQmJHTm13QG1haWwuZ21haWwuY29tLwovLwovLyBDcmFzaCBzaWduYXR1
cmUgKFBJRCBpcyBhIGNwdWhwL04ga3RocmVhZCk6Ci8vICAgT29wczogZGl2aWRlIGVycm9yOiAw
MDAwIFsjMV0gLi4uIFJJUDogYml0bWFwX2ZvbGQrMHg1ZS8weGIwIGxpYi9iaXRtYXAuYzo3MjgK
Ly8gICBfX25vZGVzX2ZvbGQgaW5jbHVkZS9saW51eC9ub2RlbWFzay5oCi8vICAgbXBvbF9yZWxh
dGl2ZV9ub2RlbWFzayBtbS9tZW1wb2xpY3kuYzozNzQKLy8gICBtcG9sX3JlYmluZF9ub2RlbWFz
ayAgbW0vbWVtcG9saWN5LmM6NTExCi8vICAgbXBvbF9yZWJpbmRfcG9saWN5ICAgIG1tL21lbXBv
bGljeS5jOjU0NQovLyAgIG1wb2xfcmViaW5kX21tICAgICAgICBtbS9tZW1wb2xpY3kuYzo1NzIK
Ly8gICBjcHVzZXRfdXBkYXRlX3Rhc2tzX25vZGVtYXNrIGtlcm5lbC9jZ3JvdXAvY3B1c2V0LmM6
MjY1MgovLyAgIGhvdHBsdWdfdXBkYXRlX3Rhc2tzIC8gY3B1c2V0X2hvdHBsdWdfdXBkYXRlX3Rh
c2tzIC8gY3B1c2V0X2hhbmRsZV9ob3RwbHVnCi8vICAgY3B1c2V0X2NwdV9hY3RpdmV8aW5hY3Rp
dmUgLT4gc2NoZWRfY3B1X2FjdGl2YXRlfGRlYWN0aXZhdGUgKENQVSBob3RwbHVnKQovLwovLyBN
ZWNoYW5pc206Ci8vICAgMS4gQSBmcmVzaGx5IGNyZWF0ZWQgY2dyb3VwLXYyIGNwdXNldCBjaGls
ZCBoYXMgY3B1c2V0Lm1lbXNfYWxsb3dlZCA9PSB7fQovLyAgICAgIChuZXZlciB3cml0dGVuKSB3
aGlsZSBpdHMgZWZmZWN0aXZlX21lbXMgaXMgaW5oZXJpdGVkIGZyb20gdGhlIHBhcmVudAovLyAg
ICAgIGFuZCBpcyBub24tZW1wdHkuICBPbiB0aGUgbGVnYWN5ICh2MSkgaGllcmFyY2h5LCBjaGFu
Z2luZyBhIHBvcHVsYXRlZAovLyAgICAgIGNwdXNldCdzIG5vbi1lbXB0eSBjcHVzZXQubWVtcyB0
byBlbXB0eSBpcyByZWplY3RlZCAoLUVOT1NQQykgYnkgdGhlCi8vICAgICAgZW1wdHktbWVtcyBj
aGVjayBpbiBjcHVzZXQxX3ZhbGlkYXRlX2NoYW5nZSgpOyBvbiB0aGUgZGVmYXVsdCAodjIpCi8v
ICAgICAgaGllcmFyY2h5IHRoZXJlIGlzIG5vIHN1Y2ggY2hlY2ssIGFuZCBhIGZyZXNoIGNoaWxk
IHNpbXBseSBuZXZlcgovLyAgICAgIHdyaXRlcyBtZW1zX2FsbG93ZWQgYXQgYWxsLgovLyAgIDIu
IEEgdGFzayBpbiB0aGF0IGNoaWxkIG93bnMgYSBWTUEgbWVtcG9saWN5IGNyZWF0ZWQgd2l0aAov
LyAgICAgIE1QT0xfRl9SRUxBVElWRV9OT0RFUyBhbmQgYSBub24tZW1wdHkgdXNlciBub2RlbWFz
ay4KLy8gICAzLiBBIENQVSBob3R7LHVufXBsdWcgZXZlbnQgbWFrZXMgY3B1c2V0X2hhbmRsZV9o
b3RwbHVnKCkgd2FsayBldmVyeQovLyAgICAgIGRlc2NlbmRhbnQgKHRoZSB3YWxrIGlzIGdhdGVk
IG9uIHRoZSBhY3RpdmUgQ1BVL21lbSBzZXQgYWN0dWFsbHkKLy8gICAgICBjaGFuZ2luZywgd2hp
Y2ggYSBjcHUgb24vb2ZmbGluZSBzYXRpc2ZpZXMgdmlhIGNwdXNfdXBkYXRlZCkuICBGb3IgdGhl
Ci8vICAgICAgY2hpbGQsIG5ldyBlZmZlY3RpdmUgbWVtcyA9PSBvbGQsIGJ1dCB0aGUgdjIgaG90
cGx1ZyBwYXRoIHN0aWxsIGNhbGxzCi8vICAgICAgY3B1c2V0X3VwZGF0ZV90YXNrc19ub2RlbWFz
aygpLCB3aGljaCByZWJpbmRzIFZNQSBwb2xpY2llcyB3aXRoCi8vICAgICAgJmNzLT5tZW1zX2Fs
bG93ZWQgLS0gdGhlICpjb25maWd1cmVkKiAoZW1wdHkpIG1hc2ssIE5PVCB0aGUgZWZmZWN0aXZl
Ci8vICAgICAgb25lLgovLyAgIDQuIG1wb2xfcmViaW5kX25vZGVtYXNrKCkgc2VlcyBNUE9MX0Zf
UkVMQVRJVkVfTk9ERVMgYW5kIGNhbGxzCi8vICAgICAgbXBvbF9yZWxhdGl2ZV9ub2RlbWFzayh0
bXAsIHVzZXJfbm9kZW1hc2ssIGNzLT5tZW1zX2FsbG93ZWQ9e30pLCBpLmUuCi8vICAgICAgbm9k
ZXNfZm9sZCh0bXAsIHVzZXJfbm9kZW1hc2ssIG5vZGVzX3dlaWdodCh7fSk9PTApIC0+IGJpdG1h
cF9mb2xkKCkKLy8gICAgICB3aXRoIHN6PT0wIC0+IGBvbGRiaXQgJSAwYCAtPiAjREUuCi8vCi8v
IFJ1biBhcyByb290IGluc2lkZSB0aGUgdGVzdCBWTSAoa2VybmVsIENPTkZJR19IT1RQTFVHX0NQ
VSwgQ09ORklHX0NQVVNFVFMsCi8vIENPTkZJR19OVU1BKS4gIFRoZSBWTSBpbiB0aGUgcmVwb3J0
IGhhcyAtc21wIDIsIHNvIGNwdTEgaXMgb2ZmbGluZWQuCi8vCi8vICAgZ2NjIC1PMiAtc3RhdGlj
IC1vIHJlcHJvZHVjZXIgcmVwcm9kdWNlci5jICYmIC4vcmVwcm9kdWNlcgoKI2RlZmluZSBfR05V
X1NPVVJDRQojaW5jbHVkZSA8ZXJybm8uaD4KI2luY2x1ZGUgPGZjbnRsLmg+CiNpbmNsdWRlIDxz
dGRpby5oPgojaW5jbHVkZSA8c3RyaW5nLmg+CiNpbmNsdWRlIDxzeXMvbW1hbi5oPgojaW5jbHVk
ZSA8c3lzL21vdW50Lmg+CiNpbmNsdWRlIDxzeXMvc3RhdC5oPgojaW5jbHVkZSA8c3lzL3N5c2Nh
bGwuaD4KI2luY2x1ZGUgPHVuaXN0ZC5oPgoKI2RlZmluZSBNUE9MX0JJTkQgMgojZGVmaW5lIE1Q
T0xfRl9SRUxBVElWRV9OT0RFUyAoMSA8PCAxNCkKCnN0YXRpYyBpbnQgd3JpdGVfZmlsZShjb25z
dCBjaGFyICpwYXRoLCBjb25zdCBjaGFyICp2YWwpCnsKCWludCBmZCA9IG9wZW4ocGF0aCwgT19X
Uk9OTFkpOwoJaWYgKGZkIDwgMCkgewoJCWZwcmludGYoc3RkZXJyLCAiWy1dIG9wZW4oJXMpOiAl
c1xuIiwgcGF0aCwgc3RyZXJyb3IoZXJybm8pKTsKCQlyZXR1cm4gLTE7Cgl9CglpbnQgbiA9IHdy
aXRlKGZkLCB2YWwsIHN0cmxlbih2YWwpKTsKCWlmIChuIDwgMCkKCQlmcHJpbnRmKHN0ZGVyciwg
IlstXSB3cml0ZSglcywgXCIlc1wiKTogJXNcbiIsIHBhdGgsIHZhbCwKCQkJc3RyZXJyb3IoZXJy
bm8pKTsKCWNsb3NlKGZkKTsKCXJldHVybiBuIDwgMCA/IC0xIDogMDsKfQoKLy8gRmluZCBhIHdy
aXRhYmxlIGNncm91cDIgcm9vdCwgbW91bnRpbmcgYSBmcmVzaCB2aWV3IGlmIG5lZWRlZC4Kc3Rh
dGljIGNvbnN0IGNoYXIgKmNncm91cDJfcm9vdCh2b2lkKQp7CglzdGF0aWMgY2hhciByb290WzI1
Nl07CgoJLy8gQSBmcmVzaCBtb3VudCBvZiBjZ3JvdXAyIGlzIGp1c3QgYW5vdGhlciB2aWV3IG9m
IHRoZSBzaW5nbGUgdW5pZmllZAoJLy8gaGllcmFyY2h5LCBzbyBpdHMgcm9vdCBzdWJ0cmVlX2Nv
bnRyb2wgaXMgdGhlIHN5c3RlbSBvbmUuCglta2RpcigiL3RtcC9jZzIiLCAwNzU1KTsKCWlmICht
b3VudCgibm9uZSIsICIvdG1wL2NnMiIsICJjZ3JvdXAyIiwgMCwgTlVMTCkgPT0gMCB8fAoJICAg
IGVycm5vID09IEVCVVNZKSB7CgkJc3RyY3B5KHJvb3QsICIvdG1wL2NnMiIpOwoJCWlmIChhY2Nl
c3MoIi90bXAvY2cyL2Nncm91cC5zdWJ0cmVlX2NvbnRyb2wiLCBGX09LKSA9PSAwKQoJCQlyZXR1
cm4gcm9vdDsKCX0KCS8vIEZhbGwgYmFjayB0byB0aGUgY29udmVudGlvbmFsIGxvY2F0aW9uLgoJ
aWYgKGFjY2VzcygiL3N5cy9mcy9jZ3JvdXAvY2dyb3VwLnN1YnRyZWVfY29udHJvbCIsIEZfT0sp
ID09IDApIHsKCQlzdHJjcHkocm9vdCwgIi9zeXMvZnMvY2dyb3VwIik7CgkJcmV0dXJuIHJvb3Q7
Cgl9CglyZXR1cm4gTlVMTDsKfQoKaW50IG1haW4odm9pZCkKewoJY2hhciBwYXRoWzMyMF07CgoJ
Y29uc3QgY2hhciAqcm9vdCA9IGNncm91cDJfcm9vdCgpOwoJaWYgKCFyb290KSB7CgkJZnByaW50
ZihzdGRlcnIsICJbLV0gbm8gY2dyb3VwMiBoaWVyYXJjaHkgYXZhaWxhYmxlXG4iKTsKCQlyZXR1
cm4gMTsKCX0KCXByaW50ZigiWytdIGNncm91cDIgcm9vdDogJXNcbiIsIHJvb3QpOwoKCS8vIDEu
IEVuYWJsZSB0aGUgY3B1c2V0IGNvbnRyb2xsZXIgZm9yIGNoaWxkcmVuIG9mIHRoZSByb290LgoJ
c25wcmludGYocGF0aCwgc2l6ZW9mKHBhdGgpLCAiJXMvY2dyb3VwLnN1YnRyZWVfY29udHJvbCIs
IHJvb3QpOwoJd3JpdGVfZmlsZShwYXRoLCAiK2NwdXNldCIpOwoKCS8vIDIuIENyZWF0ZSBhIGNo
aWxkIGNwdXNldC4gIENydWNpYWxseSwgd2UgTkVWRVIgd3JpdGUgaXRzIGNwdXNldC5tZW1zLAoJ
Ly8gICAgc28gbWVtc19hbGxvd2VkIHN0YXlzIGVtcHR5IHdoaWxlIGVmZmVjdGl2ZV9tZW1zIGlu
aGVyaXRzIHswfS4KCXNucHJpbnRmKHBhdGgsIHNpemVvZihwYXRoKSwgIiVzL2tvb3BzIiwgcm9v
dCk7Cglta2RpcihwYXRoLCAwNzU1KTsKCgkvLyAzLiBNb3ZlIG91cnNlbHZlcyBpbnRvIHRoZSBj
aGlsZCAoYWxsb3dlZCBpbiB2MiBldmVuIHdpdGggZW1wdHkgbWVtcykuCglzbnByaW50ZihwYXRo
LCBzaXplb2YocGF0aCksICIlcy9rb29wcy9jZ3JvdXAucHJvY3MiLCByb290KTsKCWNoYXIgcGlk
WzMyXTsKCXNucHJpbnRmKHBpZCwgc2l6ZW9mKHBpZCksICIlZCIsIGdldHBpZCgpKTsKCWlmICh3
cml0ZV9maWxlKHBhdGgsIHBpZCkgPCAwKQoJCWZwcmludGYoc3RkZXJyLCAiWy1dIGNvdWxkIG5v
dCBqb2luIGNoaWxkIGNncm91cFxuIik7CgoJLy8gNC4gSW5zdGFsbCBhIFZNQSBtZW1wb2xpY3kg
d2l0aCBNUE9MX0ZfUkVMQVRJVkVfTk9ERVMgYW5kIGEgbm9uLWVtcHR5CgkvLyAgICB1c2VyIG5v
ZGVtYXNrIChub2RlIDApLiAgVGhpcyBpcyB0aGUgcG9saWN5IHdob3NlIGxhdGVyIHJlYmluZCB3
aXRoCgkvLyAgICBhbiBlbXB0eSBtYXNrIGZvbGRzIG1vZHVsbyB6ZXJvLgoJdm9pZCAqYXJlYSA9
IG1tYXAoTlVMTCwgMHg0MDAwLCBQUk9UX1JFQUQgfCBQUk9UX1dSSVRFLAoJCQkgIE1BUF9QUklW
QVRFIHwgTUFQX0FOT05ZTU9VUywgLTEsIDApOwoJaWYgKGFyZWEgPT0gTUFQX0ZBSUxFRCkgewoJ
CWZwcmludGYoc3RkZXJyLCAiWy1dIG1tYXA6ICVzXG4iLCBzdHJlcnJvcihlcnJubykpOwoJCXJl
dHVybiAxOwoJfQoJdW5zaWduZWQgbG9uZyBub2RlbWFza1sxNl0gPSB7IDAgfTsKCW5vZGVtYXNr
WzBdID0gMVVMOyAvLyBub2RlIDAKCWxvbmcgciA9IHN5c2NhbGwoX19OUl9tYmluZCwgYXJlYSwg
MHg0MDAwLAoJCQkgTVBPTF9CSU5EIHwgTVBPTF9GX1JFTEFUSVZFX05PREVTLCBub2RlbWFzaywK
CQkJIHNpemVvZihub2RlbWFzaykgKiA4LCAwKTsKCWlmIChyICE9IDApCgkJZnByaW50ZihzdGRl
cnIsICJbLV0gbWJpbmQ6ICVzXG4iLCBzdHJlcnJvcihlcnJubykpOwoJZWxzZQoJCXByaW50Zigi
WytdIGluc3RhbGxlZCBNUE9MX0ZfUkVMQVRJVkVfTk9ERVMgVk1BIHBvbGljeVxuIik7CgoJLy8g
NS4gVHJpZ2dlciBDUFUgaG90cGx1Zy4gIGNwdXNldF9oYW5kbGVfaG90cGx1ZygpIHRoZW4gd2Fs
a3MgZGVzY2VuZGFudHMKCS8vICAgIGFuZCByZWJpbmRzIG91ciBWTUEgcG9saWN5IHdpdGggdGhl
IGVtcHR5IG1lbXNfYWxsb3dlZCAtPiAjREUgaW4gdGhlCgkvLyAgICBjcHVocC9OIGt0aHJlYWQu
ICBMb29wIGEgZmV3IHRpbWVzIHRvIGNvdmVyIG9ubGluZS9vZmZsaW5lIHRpbWluZy4KCXByaW50
ZigiWytdIHRvZ2dsaW5nIGNwdTEgb25saW5lIHN0YXRlIHRvIHRyaWdnZXIgaG90cGx1ZyByZWJp
bmQuLi5cbiIpOwoJZm9yIChpbnQgaSA9IDA7IGkgPCA4OyBpKyspIHsKCQl3cml0ZV9maWxlKCIv
c3lzL2RldmljZXMvc3lzdGVtL2NwdS9jcHUxL29ubGluZSIsICIwIik7CgkJd3JpdGVfZmlsZSgi
L3N5cy9kZXZpY2VzL3N5c3RlbS9jcHUvY3B1MS9vbmxpbmUiLCAiMSIpOwoJfQoKCXByaW50Zigi
WytdIGRvbmUgKGlmIHRoZSBrZXJuZWwgZGlkIG5vdCBjcmFzaCwgY2hlY2sgTlVNQS9jcHVzZXQg
Y29uZmlnKVxuIik7CglyZXR1cm4gMDsKfQo=
--0000000000005d93b306534695f4--

