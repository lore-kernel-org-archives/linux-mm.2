Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E032BCAC58F
	for <linux-mm@archiver.kernel.org>; Sun, 14 Sep 2025 02:20:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3268A6B0005; Sat, 13 Sep 2025 22:20:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2D7586B0007; Sat, 13 Sep 2025 22:20:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1C61D6B000D; Sat, 13 Sep 2025 22:20:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 07BFD6B0005
	for <linux-mm@kvack.org>; Sat, 13 Sep 2025 22:20:31 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 7EFA7B74CE
	for <linux-mm@kvack.org>; Sun, 14 Sep 2025 02:20:30 +0000 (UTC)
X-FDA: 83886251820.13.8114D77
Received: from mail-qv1-f44.google.com (mail-qv1-f44.google.com [209.85.219.44])
	by imf26.hostedemail.com (Postfix) with ESMTP id 9C742140002
	for <linux-mm@kvack.org>; Sun, 14 Sep 2025 02:20:28 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="bWfr/t+u";
	spf=pass (imf26.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.219.44 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757816428;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2FLLFKulJIRo/+/A7W+JN2XhQBYj1VMkK/MLnr9PzSo=;
	b=doRQAM7GLZ2psyiD3sAnMnjNZ2SO5HoIbp0XOBcl5OIW9R5gpQpeXAXzR+BQaVYwsG+55q
	Jbbf6QFgkdH8fwG9mtRwv6/neho5NI+7GUx+66PA2bxgA7sCTNwO3tSd/oO83k6WI/oo98
	nr8YNy8IgmHFwkDPsTDzF0YkBL1Fek4=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="bWfr/t+u";
	spf=pass (imf26.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.219.44 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757816428; a=rsa-sha256;
	cv=none;
	b=qUY1chD9f08jWMixNFXAfVdo6Ng4pC14OkTfhJle9n5Oh/4GMMFYu0BSPYaCYmoXO1PLhA
	7Uw1cNfeFoOfGn1UHrMmgS1NY4dMS5TNhqQC8L23dcrbpWGh7LyiEq/VyAu4tPUoGQmmT/
	s6OI1NTC0r23Wcg7DqjisA4nP7fth/g=
Received: by mail-qv1-f44.google.com with SMTP id 6a1803df08f44-70fa947a7acso9081876d6.2
        for <linux-mm@kvack.org>; Sat, 13 Sep 2025 19:20:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757816428; x=1758421228; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2FLLFKulJIRo/+/A7W+JN2XhQBYj1VMkK/MLnr9PzSo=;
        b=bWfr/t+uVcO+qawqxPfCV7Ws9ekdxyb7OhDCpZbwM3PAnYNaAzHiAuKOvGPT6rkCje
         GZOFTr8blJiR3pK12QkmlDx3J5e2MkUWECF1Pqu1WNhJOgrlm2HTLwP9Nox5OKGIsKqb
         wCZa4WsM0v7HzpRP1+NWd7ltBjUV1jO9rE64Is3ZQdhfZ88LpR3/TvyvSk1xJt2kcXkH
         qpn9qy3pWmZ6Fkn4qd7rbsxA1OBJmMJnthkibhMF1b2Iq5Q9cBpoQQ8bf+wwq7oW/Y0u
         LCHq9Cels+NNVYHwsI5vsTg40NYws8uYCtJrcBmFFFaxIpKthXfNcSrkLRZsikA8K9nY
         T4+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757816428; x=1758421228;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2FLLFKulJIRo/+/A7W+JN2XhQBYj1VMkK/MLnr9PzSo=;
        b=Rie7B7l1TSUzxEcWjj5i/b4UNFn00crrWOqEcz2YtwChYgcXHkNLM1Bs1UpNS6P8H8
         VZStp4xoGdvQz1+wghA/WqZWvVHjnYq3gH4VG0trtw9JH/+OjLnJE9jYYuS7YHdYasqD
         dxTQEPbXR2+zwQHq8t+JfG0S+jucbpZxho4JziC619Qug2VF5Sq1FOdssmOurcloJSqn
         5RDa5oj2MrewBMf9WLODZG+6yxi4DNT2c1uM4uD9qX3PbbMX7v4Y4vSddOHEcn4OBcLN
         BYmXYDxlg7BLoxBrDgF3bxQtGYYZkNlUaSFUwzgOJcTu3MG1kN3msFWhoS29cn1rAsSA
         uY5g==
X-Forwarded-Encrypted: i=1; AJvYcCVqGMYAKqo5MSdN5s9xuS3MndV8QLLUilKkHSJ5hhP6bpcbh/bVPth/eYLonzbj+zIMinf7Jpd21g==@kvack.org
X-Gm-Message-State: AOJu0YwThsevym2V2gnCqQv0AGIPOfqnpwOLkG3oLP2Siom0NPubqbSQ
	Fh/+0jWmKle99pw5CVIu3iRU9CPGQHJCqbPyI24+P57qu5kBkwUR9jwIwnNHqCJLsbwIDF0VKuV
	+Y8qg8bXJRkGuizoEH2GZHBliNGsV+Bg=
X-Gm-Gg: ASbGncvMID6AqVXrhBkmsHgSJ2rRvW3SrBVKvLYONbtcfiVU2sFRhaXspMpVDmBu3e0
	zeOOX/xE0tF3ev4+gPLQpIqFEr7xmi7JRQ39jc9o4pPlvQuweayahrB/tW8eWDlsTP6sDrETzP6
	NfkrTSDiVVcRV0fJ9vGlcddt151tK6ZHfDunaDx0fE5BApJsjY922ttdc9sTQ1VDChEVNJ9VeQv
	fJTyNzpSf8Z5x4MuZNHFFutoLp+kXS/d0glcHi+
X-Google-Smtp-Source: AGHT+IHq6u/4AIG+O1oq71Zy5dzM6cZoHuGdo1nSrFvwbC9QDSx6PwHNBUTam12RFvIzhBOryUKFBBcpe/eyu+MXbrU=
X-Received: by 2002:ad4:5ced:0:b0:77e:dd3e:a0c9 with SMTP id
 6a1803df08f44-77edd3ea3d1mr2130156d6.14.1757816427569; Sat, 13 Sep 2025
 19:20:27 -0700 (PDT)
MIME-Version: 1.0
References: <20250910024447.64788-1-laoar.shao@gmail.com> <20250910024447.64788-5-laoar.shao@gmail.com>
 <a2c122f5-ab6a-4242-9db8-e5175d5b27b3@lucifer.local> <CALOAHbCSudQ9y1UdD4YjuUFGae5bRu8_0bgThJV4WgwLwtcwew@mail.gmail.com>
 <42226608-bbb1-4d58-9de7-dfbb3a38d064@lucifer.local>
In-Reply-To: <42226608-bbb1-4d58-9de7-dfbb3a38d064@lucifer.local>
From: Yafang Shao <laoar.shao@gmail.com>
Date: Sun, 14 Sep 2025 10:19:51 +0800
X-Gm-Features: AS18NWBsv--35q_kcFfQDULeKAOuuY0Oif44eGzcMAx_dTI7CPLBxPfXjMJKB3Q
Message-ID: <CALOAHbAx_Qpt50Knr765Gp63C_ad8m1+kaTFveWkuybhaN3uBw@mail.gmail.com>
Subject: Re: [PATCH v7 mm-new 04/10] mm: thp: enable THP allocation
 exclusively through khugepaged
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: akpm@linux-foundation.org, david@redhat.com, ziy@nvidia.com, 
	baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, npache@redhat.com, 
	ryan.roberts@arm.com, dev.jain@arm.com, hannes@cmpxchg.org, 
	usamaarif642@gmail.com, gutierrez.asier@huawei-partners.com, 
	willy@infradead.org, ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org, 
	ameryhung@gmail.com, rientjes@google.com, corbet@lwn.net, 21cnbao@gmail.com, 
	shakeel.butt@linux.dev, bpf@vger.kernel.org, linux-mm@kvack.org, 
	linux-doc@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 9C742140002
X-Rspamd-Server: rspam05
X-Stat-Signature: jqq5aarakjf3cqhyhxcxs8ip7bdg1onm
X-Rspam-User: 
X-HE-Tag: 1757816428-572936
X-HE-Meta: U2FsdGVkX1/KRTF7DmH550iO9LCZPeSd1vQH0tyMh33yr7EIjUS/X3g/rhWb8UjbNTViVM2Zb+D+Y+Up4ObOeqinCG9SGbPHxagXqdZvpZvUuSsTUJCxmOfivnWn9UGrLCL4lWGfPXdnj8nOeamq2jV3PsiJY3KvufR4ZF8RyjJlyPPhtdc9z/K3qJjkWc6rU5GgwP1vy1BdwPm2gvrj187kN/AFRGwotyWRaGDjf0wiTVA3h542pb3YMdXkmSLPzkMWtaPyts9y99sI+sEcIbcARzkw952aGFlUtG2hFcF235DGeALIirYghg7oFSxst6L4XnUJb6BuK027ijWfEpJdxfVR9m2OgMZNxPCVElT84+UAuk1OJsZFYA/MPGLoIZBoxXQCBIQtO13a/4spSHbdhnBvLvCNN2dI6U4Ei1V5olnfl6NiqFC7BL1WUgTZrJoDz1jaJRRZakfEVZP4WrwqIYfMHTYYA8zk189EI7eWZDARgyE4aCo1HEoQyqZMN/48lHXb6p9Q6NpjrILXtmxR1qm4uOGUUHA76o1RpdD42JBAS1UGml9P7wBOXJBy85a4eJsDMSfbejLyTpskQjDiR+mjQGZB5PzyJuRCzndJ6JGAjJgDOuYamYDLmpN4Ev/1qEt3I331cDUw5IIQtrGqVqGlE7KJ2rRUky/d4PYPSovOlduBYvI502D2S98BavF/J2ZxisZFu/02q8oY/++1e8BTvwnON6NDKJetyvWEZCFMtRFlKeIwY5tVtbUMqeoHf2YrCE3rrCfOrX825KIYDNnIQplBcBY7pHNnwYnxQjk679vyJvv/Yy17W+RXK/0qAo1tK4LIHeykPOlW+gTktOQoaOj2RB23CUUbYCFp4mCk3dlYNlKcHM4H+fkEUpeP0jS4zAyGm5+0Cnrtn6f6DggogsEU4lE+cEITmSTfO2Dkr7A0oUGYtCQGs7fOKQWJg18H3RCCvcZ3CIv
 5WXR30BD
 PXRr+rayQDSgi5iaMCkIfZSJcrMbWNR9PQ70mePRezHe5re+Y8hY3Z5JH9vmRccOjFucwoA0vVVXeeoFcYDgZl74rJKLn/39ZdHV0InZg+rnj++/p+udziFLHh3LD/Aa6p9ETJTDLXi+v+s35+DpPP/pbiMSx00zuYsuFd/UX3a+kiX3eYvSurdYBIHWAxb4Ol+/PHXfp5K1PR2T6R6/rF0BK26VujUnRE6CPFGhzeV0vRm7Y99hlgGfJCa5eRVEzUK3W0RdIqKQQ4/L9LJTA6zMzksgT8yo5Fx3RiIXUoj6rXg0AxD+IkhmGibOZ2qSWOdT2bSnY6LAFuePg/xM1p1CMe0v1yvVx1iF4idvx/3xrGWwOd9mBO+q5K9C6rMr4a/c/HROlOUxjODIci3yDEVQpYUeEAxB0orck
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 12, 2025 at 9:48=E2=80=AFPM Lorenzo Stoakes
<lorenzo.stoakes@oracle.com> wrote:
>
> On Fri, Sep 12, 2025 at 02:17:01PM +0800, Yafang Shao wrote:
> > On Thu, Sep 11, 2025 at 11:58=E2=80=AFPM Lorenzo Stoakes
> > <lorenzo.stoakes@oracle.com> wrote:
> > >
> > > On Wed, Sep 10, 2025 at 10:44:41AM +0800, Yafang Shao wrote:
> > > > Currently, THP allocation cannot be restricted to khugepaged alone =
while
> > > > being disabled in the page fault path. This limitation exists becau=
se
> > > > disabling THP allocation during page faults also prevents the execu=
tion of
> > > > khugepaged_enter_vma() in that path.
> > >
> > > This is quite confusing, I see what you mean - you want to be able to=
 disable
> > > page fault THP but not khugepaged THP _at the point of possibly fault=
ing in a
> > > THP aligned VMA_.
> > >
> > > It seems this patch makes khugepaged_enter_vma() unconditional for an=
 anonymous
> > > VMA, rather than depending on the return value specified by
> > > thp_vma_allowable_order().
> >
> > The functions thp_vma_allowable_order(TVA_PAGEFAULT) and
> > thp_vma_allowable_order(TVA_KHUGEPAGED) are functionally equivalent
> > within the page fault handler; they always yield the same result.
> > Consequently, their execution order is irrelevant.
>
> It seems hard to definitely demonstrate that by checking !in_pf vs not in=
 this
> situation :) but it seems broadly true afaict.
>
> So they differ only in that one starts khugepaged, the other tries to
> establish a THP on fault via create_huge_pmd().

right

>
> >
> > The change reorders these two calls and, in doing so, also moves the
> > call to vmf_anon_prepare(vmf). This alters the control flow:
> > - before this change:  The logic checked the return value of
> > vmf_anon_prepare() between the two thp_vma_allowable_order() calls.
> >
> >     thp_vma_allowable_order(TVA_PAGEFAULT);
> >     ret =3D vmf_anon_prepare(vmf);
> >     if (ret)
> >         return ret;
> >     thp_vma_allowable_order(TVA_KHUGEPAGED);
>
> I mean it's also _only if_ the TVA_PAGEFAULT invocation succeeds that the
> TVA_KHUGEPAGED one happens.
>
> >
> >  - after this change: The logic now executes both
> > thp_vma_allowable_order() calls first and does not check the return
> > value of vmf_anon_prepare().
> >
> >     thp_vma_allowable_order(TVA_KHUGEPAGED);
> >     thp_vma_allowable_order(TVA_PAGEFAULT);
> >     ret =3D vmf_anon_prepare(vmf); // Return value 'ret' is ignored.
>
> Hm this is confusing, your code does:
>
> +       if (pmd_none(*vmf.pmd)) {
> +               if (vma_is_anonymous(vma))
> +                       khugepaged_enter_vma(vma, vm_flags);
> +               if (thp_vma_allowable_order(vma, vm_flags, TVA_PAGEFAULT,=
 PMD_ORDER)) {
> +                       ret =3D create_huge_pmd(&vmf);
> +                       if (!(ret & VM_FAULT_FALLBACK))
> +                               return ret;
> +               }
>
> So the ret is absolutely not ignored, but whether it succeeds or not, we =
still
> invoke khugepaged_enter_vma().
>
> Previously we would not have one this had vmf_anon_prepare() failed in
> do_huge_pmd_anonymous_page().
>
> Which I guess is what you mean?
>
> >
> > This change is safe because the return value of vmf_anon_prepare() can
> > be safely ignored. This function checks for transient system-level
> > conditions (e.g., memory pressure, THP availability) that might
> > prevent an immediate THP allocation. It does not guarantee that a
> > subsequent allocation will succeed.
> >
> > This behavior is consistent with the policy in hugepage_madvise(),
> > where a VMA is queued for khugepaged before a definitive allocation
> > check. If the system is under pressure, khugepaged will simply retry
> > the allocation at a more opportune time.
>
> OK. I do note though that the khugepaged being kicked off is at mm_struct=
 level.

The unit of operation for khugepaged is the mm_struct itself. It
processes the entire mm even when only a single VMA within it is a
candidate for a THP.

>
> So us trying to invoke khugepaged on the mm again is about.. something ha=
ving
> changed that would previously have prevented us but now doesn't?
>
> That is, a product of thp_vma_allowable_order() right?
>
> So probably a sysfs change or similar?
>
> But I guess it makes sense to hook in BPF whenever this is the case becau=
se this
> _could_ be the point at which khugepaged enters the mm, and we want to se=
lect
> the allowable order at this time.
>
> So on basis of the two checks being effectively equivalent (on assumption=
 this
> is always the case) then the change is fairly reasonable.

Yes, that is exactly what I mean.

>
> Though I would put this information, that the checks are equivalent, in t=
he
> commit message so it's really clear.

will add it.

--=20
Regards
Yafang

