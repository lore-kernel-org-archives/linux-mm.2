Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B225EEB594B
	for <linux-mm@archiver.kernel.org>; Wed, 11 Feb 2026 01:59:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C8EF56B0005; Tue, 10 Feb 2026 20:59:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C3CBB6B0089; Tue, 10 Feb 2026 20:59:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B3FAA6B008A; Tue, 10 Feb 2026 20:59:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id A49046B0005
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 20:59:38 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 4F351160131
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 01:59:38 +0000 (UTC)
X-FDA: 84430519236.13.64DF766
Received: from mail-yx1-f43.google.com (mail-yx1-f43.google.com [74.125.224.43])
	by imf10.hostedemail.com (Postfix) with ESMTP id 4EEB1C0008
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 01:59:36 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Bb6fXYBy;
	spf=pass (imf10.hostedemail.com: domain of kartikey406@gmail.com designates 74.125.224.43 as permitted sender) smtp.mailfrom=kartikey406@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770775176;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jcJDMNR9Tn0ilBGLdQTOxUQSH3ZRsLWx9Xgt9aF0KKA=;
	b=l5geldcxOYuLDjE+iWlU+vdEVtM9engeY4hfGFLJ1AVOtZcNLxXzg5DIF8fSZ5pj5icNGl
	0dwYO5R4X1NKCI2xEQQs/RcO1QQn2ZXumg4bl00IkrcQUU8k8bhYr/yBR38jSUAt2Fcb/+
	JcLUBjj7y2TckybV3+zu1jj9WJvRAQQ=
ARC-Authentication-Results: i=2;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Bb6fXYBy;
	spf=pass (imf10.hostedemail.com: domain of kartikey406@gmail.com designates 74.125.224.43 as permitted sender) smtp.mailfrom=kartikey406@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770775176; a=rsa-sha256;
	cv=pass;
	b=NSpZ9x71WGzQ1t5s4ZpOD0AKdKRkLYBH6meK5l1wOYEP6gGNnVkXji0Vgd3upF/6o4EXmy
	WY6BW34fzebMDipv3qLhcFlERtChoFnm7lAudLa27mZJd8p+eS1917O5381Fjj0vVAFwOb
	1OV9a26NThV/3AdG7OSKyrPwHz/xoTY=
Received: by mail-yx1-f43.google.com with SMTP id 956f58d0204a3-649df3c22d4so4221325d50.3
        for <linux-mm@kvack.org>; Tue, 10 Feb 2026 17:59:36 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770775175; cv=none;
        d=google.com; s=arc-20240605;
        b=E4c4cviqOmqkrRLPtH/61EDKztV1tylHyA24M5NuuDmac3t5fPm7YPoa0DuCesyixp
         b3jduOA8QhrLi+xCGl1JEpcQOqZSML6mjw+E6f0shD/UnKt6x4IkK2diKMH24AITMqeJ
         eEWCFy2QXAqcLffxMsHI33VjDo91wXJ9ai0xJ1gP7gD6sG2Rf/B+RTrvIwPMVPdW3DoD
         o5eWqgxneyy6/e3UFQgN1HUWPw3JbcEpvdAJkZ307778AyliX1e2vD8ok8UbCVTVGI26
         IzxbQzhC1vqbTbd7vfkK9p+55pC+B291Tz5adUJXrt1/WUOG0ZutKJjmBbORpILDAH8a
         jdOA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=jcJDMNR9Tn0ilBGLdQTOxUQSH3ZRsLWx9Xgt9aF0KKA=;
        fh=uVrwb4zI4sWcQkSYkrmKn3YnapFsFJObLAEHpg8qYtE=;
        b=Oitr/e4OeEsPn/i3BtV8Me7y9HSRka7ruOBHSIX4Le25d4pt1CLgN/TLOpY1S5MI6P
         TCm1YnYfM+k3cAwRZy/VB4o8/STX4Ia3D/fQ759E4l/7hJy9JHsLAm7o72SDxZverNvQ
         qD6aZiB6ZKpCKzhg7LWYB2Q+TDs6T5kvwko3m1FWAERV92Op5TRzhBRfd/jLbuGoho7G
         zuaSFKOeCTbjZbK+nDEfOet1+0EZULtQ5Cez/F2lQ/05Muz93wjdC4HXFL66wRUfR7g0
         Xr7pyMakrWqqOcF5PNG6nzoKzs8vlXv9am+fIzcTDLwk+CKuVBoUktj6rVa9h01weVIc
         F+BQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770775175; x=1771379975; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jcJDMNR9Tn0ilBGLdQTOxUQSH3ZRsLWx9Xgt9aF0KKA=;
        b=Bb6fXYBySB0+7OkoG+9mZf8Bvx2JJoD0Rf2zZ0sp4fVJ0yMZ8VIgnyGxUm9iSWjmmQ
         80I8vJNhJF1WoJG4D56sw33UJo+j2dOf8eHq7mj45uvA5di1vmPLQQrjcENePJ3I3p+c
         F8vFMpvgrt9hNfaxysYGo8oceRcqDbO4UYNdVbcdBjqpHZfT1SgeuZnW0A4axNI4LPMm
         7rrBW2keHzOfyVPJDlVkjtyPaGNsDtOU2/LaRQtrSWItrV37AinuG/lgDZqQ503e2Sz7
         perdje0UNklWWBbAjsQBtWVJ4Nrtt1KyuFAJOm/grd55NvBZ6OulyOFmFNLelLw4RnTE
         zYCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770775175; x=1771379975;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=jcJDMNR9Tn0ilBGLdQTOxUQSH3ZRsLWx9Xgt9aF0KKA=;
        b=wXSxYyxIwkdwwXqr9o+VKoBXlch4df7irU8WE4iNvbZNCbd8XK4z+JVZlRQouGx9Jm
         u2lMkQGNpCLAOw03A8C5ZjX2GmwC95nAGl+9enojPe3A0jsD8Lh1+rpvxegQARZpGAm2
         s72oXfavTyphTLu35Hr4AiJDOAxDM8bLhP714raNKMbxRNS+sYTD2CWGhqBOTOBsJxDi
         LtkrqpdqYGCELGSEYaCEY3kQBQ0U0rZaK186hugZI4yrU671ouXR+IYOAEfrlLH+duRl
         b1aNcp0IJi1wOEKA9Mf2zvgfgYeTRxinBdAFM48z1E4c+KyNydQJAEqtAfyBRktT6R2d
         CCJg==
X-Forwarded-Encrypted: i=1; AJvYcCVs8U+/rS+bJbpzfygmXEBDF+01ZaYrpS2Zeh6a7F2YmGEUvwjt+nhCiealp7A9JlTjoeaoqUW0sg==@kvack.org
X-Gm-Message-State: AOJu0YyV7v2MSav8A583CoknUK93hQ/1Guyaxj0u+CpVUaNO5K30GHc6
	BT9Y/HF+fd0LDt/pi7dqbvOshdbYOb8oQ2Kq1W8hkdV55mUDGPPqqcbA9quVjxVnyhIcRexfFig
	JwysBIB5R9wmFo4fWjbn8ur78vcsMZsA=
X-Gm-Gg: AZuq6aKxDObv9Z/MsEM+uolQfp9PRgg70xm+fXYIaK06K0f/mj6yM67KIlmKMri/Qz0
	N1CQUVbk2NyO5srtbHpqz5e+5+J9ZWY+IIKXJ4vHUszaV3j8t3+O80sh1GUgP4nRzN27IxQX7ID
	/CJtYPRrqu71fbymZlonPMEdVZxp8ckbj8yMkw9HHNJLVsJzQVEhR+KgPb5rYIyjaDPe8zQqOxf
	AsKUK42d7ph1BP3EPOu9zrWy6irwtlb/G/0P97RteVHohF5tXZ9hIo4C1+JtHlQ98C/bG+hJufO
	mJGHuNBVcCTYZVtUGaRDqa3L4hhXuQTgAmQlP+MS7GKhIqSCCPorDqiVIdLL/qWL5tZvt9XgQo5
	qHkSu3wE=
X-Received: by 2002:a05:690e:16a0:b0:64a:de2a:e6e9 with SMTP id
 956f58d0204a3-64afb8dc562mr1007272d50.24.1770775175263; Tue, 10 Feb 2026
 17:59:35 -0800 (PST)
MIME-Version: 1.0
References: <20260209033558.22943-1-kartikey406@gmail.com> <0d9cada8-7148-4a5c-a09d-120ef54559d7@kernel.org>
 <cbf76e1d-6b5d-4072-9f46-027cea4c0478@kernel.org> <CADhLXY5nrTXmWMPeiLg37euyVeQsNDRUvKmQaPdxtE1YhPq_jQ@mail.gmail.com>
 <CAEvNRgEoPs5ia+u0ODra6N4BdOwpYa04j8nDxwfNVyfCOWnM6g@mail.gmail.com>
 <4ed1b111-f2f1-4f89-9308-fdd9d706ca37@kernel.org> <8f188d73-fc97-414b-bdaa-e72032b2bf82@kernel.org>
 <CAEvNRgFw_P-GZ=Z4irGheM4O-RnXkd_bdAd0AT7fUuwXEnSqHQ@mail.gmail.com>
 <c4c06a75-e50e-4530-80e3-13724c08a949@kernel.org> <CAEvNRgGg245-TQn2HFSadZ7gmz-FxsAQ6=N14BUgiYGHhZeLeQ@mail.gmail.com>
In-Reply-To: <CAEvNRgGg245-TQn2HFSadZ7gmz-FxsAQ6=N14BUgiYGHhZeLeQ@mail.gmail.com>
From: Deepanshu Kartikey <kartikey406@gmail.com>
Date: Wed, 11 Feb 2026 07:29:23 +0530
X-Gm-Features: AZwV_Qg3e3DLlPtLr0FMRkXA-24Zu6q8lzeHImpYKVgBS09u4-NVv29V3PEUAUE
Message-ID: <CADhLXY6PxJ3q5Q_aqMPSKcPQVA66T0+6Eud4ghv3AQH2ZdMV6g@mail.gmail.com>
Subject: Re: [PATCH] mm: thp: Deny THP for guest_memfd and secretmem in file_thp_enabled()
To: Ackerley Tng <ackerleytng@google.com>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, akpm@linux-foundation.org, lorenzo.stoakes@oracle.com, 
	baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, npache@redhat.com, 
	ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org, seanjc@google.com, 
	pbonzini@redhat.com, michael.roth@amd.com, vannapurve@google.com, 
	ziy@nvidia.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	syzbot+33a04338019ac7e43a44@syzkaller.appspotmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 4EEB1C0008
X-Stat-Signature: dcahc3gnda5p7hk6g1nmnfdtcwcw9m6o
X-Rspam-User: 
X-HE-Tag: 1770775176-91555
X-HE-Meta: U2FsdGVkX18juiG0EFQW7+vQDSMt2aMPm+u8E+d26UI9QzRwwG/RKuM/IjdrPetoWFDwmh+dkhtU7l3kvGowLA+xlwjCa+fuBlljS3mJ+mrukEUdTBh/75h5Nt1QFGmaFYya8FMKOM/BiPss0ROKgXjY1iBe7weauZK0NkBHBUTbG2r2dD94ggh8NJVMQ9DzJ6CKvU2FIGOnFATapSwc06DhpduZrvg8yU3k8gxIWKlMEl312nH3sVaQQNmxuZjBHeA/W2kWzoAt7r6gvKIGl1TAGu17oZ3wMmTpD0ybHjDIwt7RV26TjXmrbmeQs2tyzzuq8Ml2qqpgDnmJHuEf7lq//hCG4Tvxfi4/XO1oZHeHfcp7Qp8JHEQ61nvfJWUQCAGTiK4EWpdDQcD0U5QqOCWLXq4rIfpPOy1nNc/iIThILEPtO7Af7E/8AkMXO0D13TW0m9qeU4FfXWP24NXES5Kzh4fTwb3HyTQgqfaZBBM8t0gsvWJVFmX5h9Rn/EX2z0ve5xUBXxLQPDsD9rbn0HLKphRaSmELONrmTVrpuX1WgPXZORM8hy7+mH9PAi01B2NtUik7UspVJQMgZp+wvlhorYr/TjnYPzR89z0xjiNLMP9U/2muEWzkIKLTCrMjKOBqbvZcQ7Xp8CAHThuv9vpgBzdiRpqV4d89OK5SwWA73l3cTkG6BDfX1Z8BdCveZayoRPfIU1OmdJ94gztoYLgnIddrm1zzw1bRw89IA06KK685kxW0kV3YCOjGFekIcKZDWogfrEvGN2VHydKOOAPQAuZjHd61ZgTpvJUBfd68dZa0lVt+kBEbjKpxUknHfciyCJrv11McIbdNGxU17QUXTfMIps89Pviw7gcoazoLdi4TpAiyMC2BJoY9gsGf+l435VA+nIxj0gqEvKlXH+OJkxoQyVQiKnxiqD6iMWdLt9F9uCV2NdbfVYbTVyFAQspPa6hxmqTURL1VsV1
 Yr+f3FiP
 cZijBqCkqOSuOyKINDGFSbiaNyxqCOFa77j2l+3ZUnjvlyvUhlg1Y23AzFBL5QfEWJrO0dkdeL6Q+C6oVF7vByh+/eySrBrOI3MBr4H0+ZgcHFLmzQl6SolG0OgMFu1jbKEIftqzibdlJI6kdlxDPShznWh8ux9nl/RjQAWLM/EG50WepEwv9n2ZaL+EunRaN+GH/z5DaKa1QCfpNTVDuO8EUe3aWGoQDgXXuuKLsIga0KjbQ1mV+u92m+E1ogX/9H1DU10znra5Puz533CJn7mjPbF8lExjSfrPbZFC4TOSp4lNVJwe8Zrcj8EAyFE27NaoDmNjCdQwKiIDKg4rEQFZ7dzokAaCo673zC4P5n+KGAJmO0CLpfH3M6PzyjWlgLMzsEY+MoQi139SJnrj1cItFl8mqKTy0AoL5LL5dcB4CE5cioxhbNZ4jdtikdlgUwg7TWeFB1k54fKBaWfE/L0Udc9M/bw0/HQkqmqgFBQAjGFt4cMx+BgLbvM2DYcvXp3T8/kw8itOFz5APkm8qlUhiGDnexRHYN78Wv8C+lIErs0dqk70lNgg5bO73yrv8e/BhFSmTxo3Sb8XoMPS0C8Y+p87BQM0QXfypPQ39jspx2HU9p0OX0MgTc4VPuH8HhG0NP5NvNQAWu+M=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Feb 11, 2026 at 4:30=E2=80=AFAM Ackerley Tng <ackerleytng@google.co=
m> wrote:
>
> "David Hildenbrand (Arm)" <david@kernel.org> writes:
>
> >>> BUT, something just occurred to me.
> >>>
> >>> We added the mc-handling in
> >>>
> >>> commit 98c76c9f1ef7599b39bfd4bd99b8a760d4a8cd3b
> >>> Author: Jiaqi Yan <jiaqiyan@google.com>
> >>> Date:   Wed Mar 29 08:11:19 2023 -0700
> >>>
> >>>       mm/khugepaged: recover from poisoned anonymous memory
> >>>
> >>> ..
> >>>
> >>> So I assume kernels before that would crash when collapsing?
> >>>
> >>> Looking at 5.15.199, it does not contain 98c76c9f1e [1].
> >>>
> >>> So I suspect we need a fix+stable backport.
> >>>
> >>> Who volunteers to try a secretmem reproducer on a stable kernel? :)
> >>>
> >>
> >> I could give this a shot. 5.15.199 doesn't have AS_INACCESSIBLE. Shoul=
d
> >> we backport AS_INACCESSIBLE there or could the fix for 5.15.199 just b=
e
> >> special-casing secretmem like you suggested below?
> >
> > Yes. If there is no guest_memfd we wouldn't need it.
> >
>
> Seems like on 5.15.199 there's a hugepage_vma_check(), which will return
> false since secretmem has vma->vm_ops defined [1], so secretmem VMAs are
> skipped.
>
> [1] https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/tree=
/mm/khugepaged.c?h=3Dv5.15.199#n469
>
> >>
> >>>
> >>> The following is a bit nasty as well but should do the trick until we=
 rip
> >>> out the CONFIG_READ_ONLY_THP_FOR_FS stuff.
> >>>
> >>>
> >>> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> >>> index 03886d4ccecc..4ac1cb36b861 100644
> >>> --- a/mm/huge_memory.c
> >>> +++ b/mm/huge_memory.c
> >>> @@ -40,6 +40,7 @@
> >>>    #include <linux/pgalloc.h>
> >>>    #include <linux/pgalloc_tag.h>
> >>>    #include <linux/pagewalk.h>
> >>> +#include <linux/secretmem.h>
> >>>
> >>>    #include <asm/tlb.h>
> >>>    #include "internal.h"
> >>> @@ -94,6 +95,10 @@ static inline bool file_thp_enabled(struct vm_area=
_struct *vma)
> >>>
> >>>           inode =3D file_inode(vma->vm_file);
> >>>
> >>> +       if (mapping_inaccessible(inode->i_mapping) ||
> >>> +           secretmem_mapping(inode->i_mapping))
> >>> +               return false;
> >>> +
>
> Regarding checking mapping, is there any chance of racing with inode
> release? (Might the mapping be freed?)
>
> >>

I don't think so. file_thp_enabled() is called from
__thp_vma_allowable_orders(), which is reached via khugepaged,
MADV_COLLAPSE, or page faults. All these paths hold mmap_lock and
operate on a valid VMA. The VMA holds a reference to the file
(vma->vm_file), which holds a reference on the inode, so the inode
and its mapping cannot be freed while we are checking it..

