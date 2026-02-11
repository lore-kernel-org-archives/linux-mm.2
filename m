Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A0595EB594B
	for <linux-mm@archiver.kernel.org>; Wed, 11 Feb 2026 02:02:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E76AD6B0005; Tue, 10 Feb 2026 21:02:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E24626B0089; Tue, 10 Feb 2026 21:02:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CDBD96B008A; Tue, 10 Feb 2026 21:02:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id BE7966B0005
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 21:02:03 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 2AF2EC10D6
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 02:02:03 +0000 (UTC)
X-FDA: 84430525326.16.729F802
Received: from mail-yx1-f43.google.com (mail-yx1-f43.google.com [74.125.224.43])
	by imf23.hostedemail.com (Postfix) with ESMTP id 5E42F14000A
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 02:02:01 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=XaX5f4rx;
	spf=pass (imf23.hostedemail.com: domain of kartikey406@gmail.com designates 74.125.224.43 as permitted sender) smtp.mailfrom=kartikey406@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770775321;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hmOGy4jd2wxLFmdyeB0GyxLBw+gAD2u1pij4Myx4/Ls=;
	b=7wsJKSa7o/oUv/tEZWoUYBe8dGq4yGz+IiBMnTuMMFrcKAHTnopIruEdQA9UxWMTsPR0xw
	h/6I+sJbgFHP4tug+4Jfq07PA+z+99Zu+sj4IialIDN6fNt9DMI+WVwZ0D7rlqj1N24RCc
	UR8qVuo2Kc0J6P8i6auCYlzs6rAfv8k=
ARC-Authentication-Results: i=2;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=XaX5f4rx;
	spf=pass (imf23.hostedemail.com: domain of kartikey406@gmail.com designates 74.125.224.43 as permitted sender) smtp.mailfrom=kartikey406@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770775321; a=rsa-sha256;
	cv=pass;
	b=J9GCI49MY3AWjoEVIOgkhNdiYktnMZa/6wSMOvJO0ApI0B1GG81MVIv99BTd/ONOpj21pP
	qEP9XJP4pq5zECc/KhqmZMoPxX28lE/TUZ2ACSxRCkbacKmDFv4FQEOtGfl1bOMZ4Ty2iv
	pYOXW2gz6PjEskfB4ZuqRvJClxUGG4g=
Received: by mail-yx1-f43.google.com with SMTP id 956f58d0204a3-649b5f5570fso697039d50.0
        for <linux-mm@kvack.org>; Tue, 10 Feb 2026 18:02:01 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770775320; cv=none;
        d=google.com; s=arc-20240605;
        b=Rw1VHblvvzGrcR3WMzhS1pPd0ED4xA20UnNP6nyenl+tUXlyfZBItiWCrJAnYk6fev
         zx5EFkTuskcK2EiDuixjlyduSEEUHkgPHSdwLWj2OZU8kExtal7Ar4rVHvOO+AMywX6Q
         cM5/xxUk4bhfFvCMcmVwfeHbr+buHWKYxStUE8nb3J4MLYQoA50YOj/+Ys4pr6e98eZF
         apuZzPkvDUAOm+9ilPYgE/J/xMJ0DmzOSxLTaLdnvooYGHlfYukeq2eHFO7PgleMVyUj
         4zUlV+ZYDxQnFhEuRk2ry7h1E9SUJSqr/GylMvkzgTlWOBpkdoYEmzTWBvI4XnFpw67S
         XwOw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=hmOGy4jd2wxLFmdyeB0GyxLBw+gAD2u1pij4Myx4/Ls=;
        fh=RlD2oRnwAutGhN22Nj3On1fpx67rEKDC4wSiZezzfxM=;
        b=FkIJhyJJX834joWQfDSTbjrpkOhpt4uKuQ93GzLReTpFbgABA1sFu9WflGLiy67Lrw
         4/JXsFGdFFCsoUNSVeqvFZUZrn4v73aYcHX1zo2z9k48sOjY1PUxnj/iOASb5TfSiyrI
         pzHyyNq1x1Ewbvs4Pri2Ad1Yi/0iSOSjLEBshm3xhmoL2Yi4g1gNXbl8Q9q5G3izIBdm
         FxOzHWP+nDU14B/LccY6Gp0tRqgHW69YiSbR9JdWInyk2LsyE4NwlWBMoXnCvGZ/4OuW
         AGIlggnGS5a+7tUEw2VYPzDYC5KEs/QwBvR2tbE0M2r6tTTVVOQ6SaXT5eV7H5/WSlpQ
         Q+Yw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770775320; x=1771380120; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hmOGy4jd2wxLFmdyeB0GyxLBw+gAD2u1pij4Myx4/Ls=;
        b=XaX5f4rxS+FOs6HGzFZKmDzrHS08CDlEtn9QGNpo6RBHO8U7ACg3gGAx764MINXHpL
         g6B0WHbqI7GDBSWMfjWKOF13hdo6kRJmjur2Mrn39NUYYmTfjxZeNhFcLC+w/nXANezr
         /eyBCXiWS0g2PFNuLjuz06i+dArfZyeWPh+mn0oDrIImI1FHrSBRE8mT9iBtkjiW7kSS
         S1Okz9EJmMuvHmssygHxShTj+KLjGiE8re2liVrg8eofmk84VnPq/TwKsu3gDRRC2MsE
         y6UxlAkNFUibERdkQzyhv3N1btbBKN6RAjMQZFR9h93PDs5TlsL1HS3m9a+E/VtoGpVo
         rQBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770775320; x=1771380120;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=hmOGy4jd2wxLFmdyeB0GyxLBw+gAD2u1pij4Myx4/Ls=;
        b=FLezkWBNNDaLhmqHHWKX7CUodmB6YYBFolRq1Hl/c+2/El2xUHrfmuUzrSDsYPyxOm
         eCgtebKsai6M5S8hlBLQHJn4Q4bFjWEOSrVX3diQHcIeakscLhue7LmHRKcs6e9MD4XX
         sG7WFi3DO6vZDLD8bWYSZXd5hNQ5Ysxt29hfZCD1md6N9qvTWeMQR55G/4G5cg7ybYYK
         tISinWp9oRwuYaI85FDgUGpspF7Tj04nuAHu/OYtuxZN85Ii5StYRLYQ7tvh/nUo6Mwc
         SAvaHwMCz1p/8PN3bNHuJwnwiE4IPPdgCJ2uoKodQ/1ToG6IPi7lCB4Az/FI4dRb+evT
         YslA==
X-Forwarded-Encrypted: i=1; AJvYcCUZLtKW48+dujxYMQUThEbyppCvvGBXqzXmzRlTyqzhiEy+c3Tww9yIu3160DQFfFJhnjUN4yX7ew==@kvack.org
X-Gm-Message-State: AOJu0YyOmQ+VK8tISddh+GqYKF+yC4Z5iD+9+P39TJ8oeZlztXyDHxxd
	Sq34OKv9ed2xn6l6BixApH4WBLTtelgcgpL97K2eBpFX0IWFHTZ29DYnkt67V45qtbsYejKzRvb
	5wxGnvyR+4gLEGV6Kg7/eCtFGt3I2BE0=
X-Gm-Gg: AZuq6aL8TYNBgN3hVf/2wM7bNFwtCrJo6TaKljWEUEmfxCubCANpq/4FJMDePvd+sVs
	ojFtuP7kqf+l7LR//UaOYYlI5Hob8LhE/RRwGqb6vUoSIvODCdZIIhc1OOAuGLKd40J/kM5cXqt
	lmUNZF+jMR3d0MR9yiAFKhBhbw0careOWPQe/hPbhRgh08mHKoYtJzvgoX55THNBwiaXO14b4w3
	hC2RS6ENnrLCjA893oBxuvzNzfnM2ibsaK7b/DFoR+sld+Q+DAYWxGQrXFnYFfEpewqhfiNZ/9V
	zpWW+zxxi47ZBPxrmb5F5Ck5EyBbH5x118I+OY4fdFULPkFf3RXxS2gyhP7HnHtEEw078k5B
X-Received: by 2002:a05:690e:4144:b0:64a:ec39:dd59 with SMTP id
 956f58d0204a3-64af1963701mr3846268d50.15.1770775320386; Tue, 10 Feb 2026
 18:02:00 -0800 (PST)
MIME-Version: 1.0
References: <20260209033558.22943-1-kartikey406@gmail.com> <0d9cada8-7148-4a5c-a09d-120ef54559d7@kernel.org>
 <cbf76e1d-6b5d-4072-9f46-027cea4c0478@kernel.org> <CADhLXY5nrTXmWMPeiLg37euyVeQsNDRUvKmQaPdxtE1YhPq_jQ@mail.gmail.com>
 <CAEvNRgEoPs5ia+u0ODra6N4BdOwpYa04j8nDxwfNVyfCOWnM6g@mail.gmail.com>
 <4ed1b111-f2f1-4f89-9308-fdd9d706ca37@kernel.org> <8f188d73-fc97-414b-bdaa-e72032b2bf82@kernel.org>
 <CAEvNRgFw_P-GZ=Z4irGheM4O-RnXkd_bdAd0AT7fUuwXEnSqHQ@mail.gmail.com>
 <c4c06a75-e50e-4530-80e3-13724c08a949@kernel.org> <CAEvNRgGg245-TQn2HFSadZ7gmz-FxsAQ6=N14BUgiYGHhZeLeQ@mail.gmail.com>
 <CAEvNRgGvZbRLcb4JbXjsLUX_V59EApHYTQc49X3Jq70GxovD2w@mail.gmail.com>
In-Reply-To: <CAEvNRgGvZbRLcb4JbXjsLUX_V59EApHYTQc49X3Jq70GxovD2w@mail.gmail.com>
From: Deepanshu Kartikey <kartikey406@gmail.com>
Date: Wed, 11 Feb 2026 07:31:48 +0530
X-Gm-Features: AZwV_QjXhIMFPf6jJ0SJ9mTsyFML5WJINl2nSTV_Le53QpuBO8uPBkMPoU2Q6Mw
Message-ID: <CADhLXY45F1uL2uVOz6gTqt2Ydoj-hPB3tFVK-syX-pMX+Kw6qw@mail.gmail.com>
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
X-Rspamd-Server: rspam12
X-Stat-Signature: gfe8cq5d8o8fet4awhqmsafqd1upntp7
X-Rspamd-Queue-Id: 5E42F14000A
X-Rspam-User: 
X-HE-Tag: 1770775321-875198
X-HE-Meta: U2FsdGVkX19U3AtCAWfu7xEut7mycJTQhazhYn8solbMPq/l/JYuUSivUSqzKaIx4vm6Z5gg9prVfuJktTOmmws0UCO6pyoBMBimMYnchkDeUsbDOBBf/SG6JXW+kD078akqMIzepHhoWMWhX/gpRNWE3o+v0jao7x5QxsBjYv6EYN7sxlLU5hXSU98sG+ol4+8u7vxLM5G4mUOuW8pX2Jw2eK1nPtF+UU4IjA6LehvgVv3OO4guiqQNnHfxcKnXaLkqM7PSBzgtxenkcQH1NB+0t8Rgd0W5NRYswOYOeqOIHqP4uWBQW7L0geU014j4Nplj1ForqFKaMlRhLoLscJfyUwfMJC7bwST8L+2ixQsFSjWAHNo84bxbbYYizQ8PvmuUCpaYKzUwD0aDJSlM6br7sAqEvfcngJQii5MUjzngEqxVkEkR7Uv/vNZrl3KXbskVHUZJrcV7kEe1r4OkwyJKMlkLpuJu+O4OJWdX/wvJKMEkiYM/uWFQfz/MVjah7WIJz+28TC07EsYIfWCdX9uOUrx4N0/dXap0K/PZY7ERqxKIiJvKXF0VNUISgMISirKhb9tt59lxqN1z7+ATR3M5OObC69SIGPMEYXN41cwqI3xYknlzc+vNlaIJwAOeaaQ5CyGxE245hN6fVG0ySxMZ9c9mDrrVBQtMT/mC0q3iiIaazDGBqQpfIYnzfI/rQBenZ2q7j7JB9Q6/95H+nm9+IbjM912Efos/pUabpOv4ZZiwAppicnHPP4WSYJgU5OKhwCx+yTSwMNW1hZh0Z4n5OlglCbRlqZRxk94gSL9eLEBugWFuHBNhGeP3xmu9iQFsPhGZp+udosYxebMERWqiet7g4JGqHU+EYVJ5ScsSxaY97lNIbCcBcF9HjA/gIkSuDqyBdF+bXX5r9X6QecEq3IFqh+UtxDFHKc2aVhjSMcMJvrqexQydCXJ+ZQdh0w2PM+I5q1s1nnoLIgv
 EJy65PFC
 t1SB3euGr+lPZGUXbvtAjbcXvZMkrxPoApZA9d+zoK1XOxA6LI5rLDpiME311UVGMNqz3DLYbMWpNsfz7G8dXBMcPqHUAAl1g8C333BhXSkKdQe+bsal1LyBQlriRBsOhP0iQ+1RW2gJEQnutEOv7GLFyuXXDXe1nZRm7t2o4YMrU+trJWLLNVKaeMbLvG73dqBuaVq/5+X9J0/o=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Feb 11, 2026 at 6:28=E2=80=AFAM Ackerley Tng <ackerleytng@google.co=
m> wrote:
>
> Ackerley Tng <ackerleytng@google.com> writes:
>
> > "David Hildenbrand (Arm)" <david@kernel.org> writes:
> >
> >>>> BUT, something just occurred to me.
> >>>>
> >>>> We added the mc-handling in
> >>>>
> >>>> commit 98c76c9f1ef7599b39bfd4bd99b8a760d4a8cd3b
> >>>> Author: Jiaqi Yan <jiaqiyan@google.com>
> >>>> Date:   Wed Mar 29 08:11:19 2023 -0700
> >>>>
> >>>>       mm/khugepaged: recover from poisoned anonymous memory
> >>>>
> >>>> ..
> >>>>
> >>>> So I assume kernels before that would crash when collapsing?
> >>>>
> >>>> Looking at 5.15.199, it does not contain 98c76c9f1e [1].
> >>>>
> >>>> So I suspect we need a fix+stable backport.
> >>>>
> >>>> Who volunteers to try a secretmem reproducer on a stable kernel? :)
> >>>>
> >>>
> >>> I could give this a shot. 5.15.199 doesn't have AS_INACCESSIBLE. Shou=
ld
> >>> we backport AS_INACCESSIBLE there or could the fix for 5.15.199 just =
be
> >>> special-casing secretmem like you suggested below?
> >>
> >> Yes. If there is no guest_memfd we wouldn't need it.
> >>
> >
> > Seems like on 5.15.199 there's a hugepage_vma_check(), which will retur=
n
> > false since secretmem has vma->vm_ops defined [1], so secretmem VMAs ar=
e
> > skipped.
> >
> > [1] https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/tr=
ee/mm/khugepaged.c?h=3Dv5.15.199#n469
> >
>
> On 6.1.162, secretmem VMAs are skipped since secretmem VMAs are not
> anonymous [2].
>
> [2] https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/tree=
/mm/huge_memory.c?h=3Dv6.1.162#n135
>
> Same for 6.6.123 [3].
>
> [3] https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/tree=
/mm/huge_memory.c?h=3Dv6.6.123#n125
>
> It breaks in 6.12.69 [4].
>
> [4] https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/tree=
/mm/huge_memory.c?h=3Dv6.12.69#n159
>
> IIUC the patch that enabled khugepaged for secretmem is
>
> commit 7a81751fcdeb833acc858e59082688e3020bfe12
> Author: Zach O'Keefe <zokeefe@google.com>
> Date:   Mon Sep 25 13:01:10 2023 -0700
>
>     mm/thp: fix "mm: thp: kill __transhuge_page_enabled()"
>
> ...
>
> @@ -132,12 +132,18 @@ bool hugepage_vma_check(struct vm_area_struct
> *vma, unsigned long vm_flags,
>                                            !hugepage_flags_always())))
>                 return false;
>
> -       /* Only regular file is valid */
> -       if (!in_pf && file_thp_enabled(vma))
> -               return true;
> -
> -       if (!vma_is_anonymous(vma))
> +       if (!vma_is_anonymous(vma)) {
> +               /*
> +                * Trust that ->huge_fault() handlers know what they are =
doing
> +                * in fault path.
> +                */
> +               if (((in_pf || smaps)) && vma->vm_ops->huge_fault)
> +                       return true;
> +               /* Only regular file is valid in collapse path */
> +               if (((!in_pf || smaps)) && file_thp_enabled(vma))
> +                       return true;
>                 return false;
> +       }
>
>         if (vma_is_temporary_stack(vma))
>                 return false;
>
> Because file_thp_enabled() would return true for secretmem.
>

Thanks for the analysis on stable kernels, Ackerley. So the fix only
needs to target 6.12+ since that's where 7a81751fcdeb ("mm/thp: fix
'mm: thp: kill __transhuge_page_enabled()'") started routing secretmem
through file_thp_enabled().

