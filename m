Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E2C46CA101F
	for <linux-mm@archiver.kernel.org>; Fri, 12 Sep 2025 06:22:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 45C068E000B; Fri, 12 Sep 2025 02:22:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 40C518E0001; Fri, 12 Sep 2025 02:22:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2D4AA8E000B; Fri, 12 Sep 2025 02:22:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 1C3CE8E0001
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 02:22:05 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A9115160460
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 06:22:04 +0000 (UTC)
X-FDA: 83879602968.05.82B641D
Received: from mail-qv1-f50.google.com (mail-qv1-f50.google.com [209.85.219.50])
	by imf02.hostedemail.com (Postfix) with ESMTP id C943680005
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 06:22:02 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=dR3UMh8U;
	spf=pass (imf02.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.219.50 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757658122;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=13UhwBOCgZAJG+PHaCo5zun9R1eUs+koRa2xLgL1H/E=;
	b=mlchKN4quVpKxzCCZet3UwVPdd42J+Udrr5J3QLODn3ZzcAeyNSOuhaIpXlHaXR8MSgWcG
	VHugX6EHNsWjVqjUSE1a/Qtj7pzSAmNEOa0kZlLTC6MF8R9xvtEN/PaIUhhWRs7V0yj9ei
	uYDtKyTESwpB8W8L5iSS2e8gexApRJI=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=dR3UMh8U;
	spf=pass (imf02.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.219.50 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757658122; a=rsa-sha256;
	cv=none;
	b=0RLQvLXZnfZjuO/IKRCcBc5IhXru0qSyQ/Tj0EKbWNaTvAITukOtgQ0BQQ91emIu5gIZ+1
	sYbyJOqpwRoQmyIHHL8HN8ypLmTwlHj/7Edty3vQhymgmwCXtDKjaADwFkVJQBpODGFV1C
	wvYhKf7PCWe8mHNPnT3EUbR8ovGE004=
Received: by mail-qv1-f50.google.com with SMTP id 6a1803df08f44-76b8fd4ba2cso1309726d6.3
        for <linux-mm@kvack.org>; Thu, 11 Sep 2025 23:22:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757658122; x=1758262922; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=13UhwBOCgZAJG+PHaCo5zun9R1eUs+koRa2xLgL1H/E=;
        b=dR3UMh8UHMYzeunwsFU0jktpzMFxfd6SBFezDbqXh+EoOIaXG8i9xqj5ldhfftZZw9
         aoeM225azw23ubkbchjjVd4gQ4X8fFI3SYerTHpGdCZNWnWtXkpppPxk/mXhvWSJdUh1
         vMAbHslWKAUfNF9zjWpBjoX2DhblHYy+DRp+xQmD+xjxyxobnfBekTnOy9idIrIpeGzw
         5c/M9at5Duu8z/HY+j+B+HZplThOq8hdLoPFeZoQqkbyVUnqAAhMTXGk+x449cMJVhR1
         h/4Jn/IBnwrFlBsNaNEDOVzASdu06VPNfNqlDokXPDxSKIhq9YyPYfPtmvSmrXgUFpnr
         s/hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757658122; x=1758262922;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=13UhwBOCgZAJG+PHaCo5zun9R1eUs+koRa2xLgL1H/E=;
        b=GToGzx8Lqlkk6VoGL4YGNwqvc7YSkntWyG/S+cK1zRwdqdCqVOyEEVOi6NxETWaptM
         P9+WzOTEfEJfOzyiHSOh6kMwFRqbCpRZzCZUwXgoJGpplycwJ+oXgJh1D6fKQwIqYABv
         aZuORvxZ4d2aE/PB4GeN7L8OeOHlUJ43dfDXmuZKRC5Sa8SkjcNaQ9MVu69Pat70Bmxo
         DV9A1fizSg2tCroNcDPqDoENY3el2uvjPYRWQa5QhmEzHCx6zi4SWSZvf+5Yq+euJE1l
         TDvaA9h0evrXwwxeT7ETtmaC0frDWa4gaiedAlqgDVI8ur0YSY1jbQ+PsUXxPuJQgYfV
         oe7Q==
X-Forwarded-Encrypted: i=1; AJvYcCVfkjQy8iTdw7PtKpwJEKMlbkLZOfGP5LtKggkviRFTf75UsVTa2GCWz6tgoTRGfu8xhhrzNjb6Kw==@kvack.org
X-Gm-Message-State: AOJu0Yxs5tOSDO4FcV2FmfuNzqixGmmIT9o94vh1zPjkvIyXNC3dV0Y/
	p3Kj8vUaJ0Zf+fTo/JEELUYG2lDJSTOfO/Pfqw8SYV8hvYygiGkhosj2F/i7KhjruUtMLxO/Oft
	RgiC5FLF9eeJjEiUvRdZvz8IfNM7ncns=
X-Gm-Gg: ASbGncsLQo8q3RmSsTO2o7gOTDxkslIy/xJjiMOjPk86VYpwLPY83fMra0atQFA4w8c
	szf/bz4nAOBwFaSeYVNCsmw0uixozV8+50mYcJYkFjNdbKIA+Hl14Jmpzxc2y1xM8OEuGyc1lsq
	PecS9VuVKXPilE6l4vSs+mCQi8EQCyvbSs8tG/3KN5eS43Yvoehra+gBs1SDI2jpv3zPKeZNvji
	fMFtiRxbztUwW7rWxpqF49V5j0Bo2324S2ihnrTHtzhyacoXRs=
X-Google-Smtp-Source: AGHT+IFjPHWXtmC2N2XMC4kkjOR+ZHCdE67Dx4ptP+o4Gr0YwDr6+Gpi3AO9G8ouJBTJcBcxrEKztnxzkezUahDPmaE=
X-Received: by 2002:ad4:5fc7:0:b0:72c:3676:cfde with SMTP id
 6a1803df08f44-767bb87f286mr22196826d6.9.1757658121862; Thu, 11 Sep 2025
 23:22:01 -0700 (PDT)
MIME-Version: 1.0
References: <20250910024447.64788-1-laoar.shao@gmail.com> <20250910024447.64788-5-laoar.shao@gmail.com>
 <CABzRoyZQMDodwBEJwNOoJNASJBP50xMhLdvo+kKENyDKWcRAfw@mail.gmail.com>
In-Reply-To: <CABzRoyZQMDodwBEJwNOoJNASJBP50xMhLdvo+kKENyDKWcRAfw@mail.gmail.com>
From: Yafang Shao <laoar.shao@gmail.com>
Date: Fri, 12 Sep 2025 14:21:25 +0800
X-Gm-Features: AS18NWDgNlviB90497XwhehyjdnC0mbss2uvTJ6B4snySt0rWu9vzBh6IpQFiW4
Message-ID: <CALOAHbDUYYunZObchkpr1L78dhfP-dmVNgKz3mBf3xAi+cDOCg@mail.gmail.com>
Subject: Re: [PATCH v7 mm-new 04/10] mm: thp: enable THP allocation
 exclusively through khugepaged
To: Lance Yang <lance.yang@linux.dev>
Cc: akpm@linux-foundation.org, david@redhat.com, ziy@nvidia.com, 
	baolin.wang@linux.alibaba.com, lorenzo.stoakes@oracle.com, 
	Liam.Howlett@oracle.com, npache@redhat.com, ryan.roberts@arm.com, 
	dev.jain@arm.com, hannes@cmpxchg.org, usamaarif642@gmail.com, 
	gutierrez.asier@huawei-partners.com, willy@infradead.org, ast@kernel.org, 
	daniel@iogearbox.net, andrii@kernel.org, ameryhung@gmail.com, 
	rientjes@google.com, corbet@lwn.net, 21cnbao@gmail.com, 
	shakeel.butt@linux.dev, bpf@vger.kernel.org, linux-mm@kvack.org, 
	linux-doc@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: C943680005
X-Stat-Signature: n7szjawzdzog5uxdzwdm4f1qqpqemou9
X-HE-Tag: 1757658122-564898
X-HE-Meta: U2FsdGVkX189tz75R+RP/IilyyQnVSiKJtB2Oi8IuVYh6aQJfPuzc2nbVQhPbia/tgI1el81xCGehLIr/uEJQ86bQ2I5VyDkS4IL0sUWMLDK6pWxY5tpKoBkzHUqKgBvPsZslQV0EwyB7icU1aGR+vatdvl7TPSiCs7RVoxHFMfAcPkLz9Z4zUmWcMh+4vYKdmeieg9b5jv7Yv7EtaV8wpxiBSjdO3g6VKIFNKUgvhnPm0Z3QZcueyBB9ujuBUsN664ZJpqjKLQIeuf67mfV0kil4w+PXtEHijEyBnzDa+Vyx3yJESZvbQVHt3ah7ZuPnN3vJMqChZDLfIpyRqnweR2X47q4T+fnzTgRj4x6N6eNjjbvNcl3lgSFeuvuySGHP26rBAnKjWxKP9+Fw1zdH4IkJRITIRab8QOpOzDjc5BBeBCdQ9z4H7F1gRtr5zwKZE/S2kEqlKrdzlLTfhNpOXWX9tMBr0YpPodRZ3ySdRw14Eh8Y40lv3XJUAhrF3dVRVbv0bMvEelE113vehhqrytndypu70lKQIJPM3wDblKRHuiW5EiBT/7xf2Vlg9yY8m1nmqDxqPM0RejK8SscGrcb+grEwDsp4Qbh/1ELXnSRlDk84kkeJYGgXDAJxrouGMsewSUv32C/8E0RfhmhfKCyQ22lwmwLkjTo12+MWSAWB7t3bu38KdegPVAuegK7hS/8aSsOd8REYspDBqquUWejRn+voKmnY1u0BLz9Vy+wMOK+17t0OoPCOg/PCaQAqwUCLH36M4Ddmsb0g4p+L7fbWoVm5q0l/09esa+5NV4rR3s/0vu+mWIu74yXrPNFruBUzODRY51DBbarDJE6J4yT98WMvsp3oqqhRymtQ4oWCc6QAYUZ2nVEMU4c/8nNle02pzOBUT47G5drCvdwgC7CU1RDxcbPuQN1QjCZVVGHeBqDnV/6EZBhYW7yttY1wgCR3PCQ3c6T8bCoHeA
 to+sJzLU
 1awTQx8MOb2Ek7Bs5YmFVni5c7Uqs37z7wJs0p7fbqLkglFZ3uev4LU+ld8DxWmz3jrLRNlgoQoJsgcDAm5/irMqa1e9M8Dz12cqJUMmTDLVUF9+yPu2+mtOS1A1bHDliNc3kjmhudxmXPVgYRqmFGfQi+zDM2QONxwsDthgX6Cl9d4XSzvDHexzUba45hC/VdYSxaAdpy6K3FOMekHDPe45yYrTd9Ts1wzg+Q5LoIRChD1VkKSn53smOlZCLGITsVsWmkMbCBT768xFy6wCZHxL91UStLccSZJ9h1PoXcXo+zFD1F1MFs2OPgLhjRFiUW4gF5zERuUSxT+gnzgWfeUVMEp0QmxtHMGwOXVtwTqGN9iPbGHOo0uJh0cWXyM+b7O4EbvnOjZDSl/ukZgGr6vUCQa0fa24dR56aLQcV9rBPjFEdl1KGUoqJw+f9s2qo3ZTU
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 11, 2025 at 11:54=E2=80=AFPM Lance Yang <lance.yang@linux.dev> =
wrote:
>
> On Wed, Sep 10, 2025 at 11:00=E2=80=AFAM Yafang Shao <laoar.shao@gmail.co=
m> wrote:
> >
> > Currently, THP allocation cannot be restricted to khugepaged alone whil=
e
> > being disabled in the page fault path. This limitation exists because
> > disabling THP allocation during page faults also prevents the execution=
 of
> > khugepaged_enter_vma() in that path.
> >
> > With the introduction of BPF, we can now implement THP policies based o=
n
> > different TVA types. This patch adjusts the logic to support this new
> > capability.
> >
> > While we could also extend prtcl() to utilize this new policy, such a
> > change would require a uAPI modification.
> >
> > Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
> > ---
> >  mm/huge_memory.c |  1 -
> >  mm/memory.c      | 13 ++++++++-----
> >  2 files changed, 8 insertions(+), 6 deletions(-)
> >
> > diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> > index 523153d21a41..1e9e7b32e2cf 100644
> > --- a/mm/huge_memory.c
> > +++ b/mm/huge_memory.c
> > @@ -1346,7 +1346,6 @@ vm_fault_t do_huge_pmd_anonymous_page(struct vm_f=
ault *vmf)
> >         ret =3D vmf_anon_prepare(vmf);
> >         if (ret)
> >                 return ret;
> > -       khugepaged_enter_vma(vma, vma->vm_flags);
> >
> >         if (!(vmf->flags & FAULT_FLAG_WRITE) &&
> >                         !mm_forbids_zeropage(vma->vm_mm) &&
> > diff --git a/mm/memory.c b/mm/memory.c
> > index d8819cac7930..d0609dc1e371 100644
> > --- a/mm/memory.c
> > +++ b/mm/memory.c
> > @@ -6289,11 +6289,14 @@ static vm_fault_t __handle_mm_fault(struct vm_a=
rea_struct *vma,
> >         if (pud_trans_unstable(vmf.pud))
> >                 goto retry_pud;
> >
> > -       if (pmd_none(*vmf.pmd) &&
> > -           thp_vma_allowable_order(vma, vm_flags, TVA_PAGEFAULT, PMD_O=
RDER)) {
> > -               ret =3D create_huge_pmd(&vmf);
> > -               if (!(ret & VM_FAULT_FALLBACK))
> > -                       return ret;
> > +       if (pmd_none(*vmf.pmd)) {
> > +               if (vma_is_anonymous(vma))
> > +                       khugepaged_enter_vma(vma, vm_flags);
>
> Hmm... I'm a bit confused about the different conditions for calling
> khugepaged_enter_vma(). It's sometimes called for anonymous VMAs, other
> times ONLY for non-anonymous, and sometimes unconditionally ;)

Right, it is really confusing.

>
> Anyway, this isn't a blocker, just something I noticed. I might try to
> simplify that down the road.

please do it when you have a moment.

>
> Acked-by: Lance Yang <lance.yang@linux.dev>

Thanks for the review.

--=20
Regards
Yafang

