Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F3678C4450A
	for <linux-mm@archiver.kernel.org>; Wed, 15 Jul 2026 03:31:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D2D1E6B0005; Tue, 14 Jul 2026 23:31:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D045C6B0088; Tue, 14 Jul 2026 23:31:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C1A806B0095; Tue, 14 Jul 2026 23:31:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8F5A56B0005
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 23:31:43 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 15FE81A0526
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 03:31:43 +0000 (UTC)
X-FDA: 84989586486.14.7F04222
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	by imf29.hostedemail.com (Postfix) with ESMTP id 37CE6120005
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 03:31:41 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=AKvQC+bg;
	spf=pass (imf29.hostedemail.com: domain of jiangwenxiaomi@gmail.com designates 209.85.128.45 as permitted sender) smtp.mailfrom=jiangwenxiaomi@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1784086301;
	b=CAM9ni9p1nsJVPWhFloQ1RopX/Jam3nHKHRaJKveiV/fzHTyHdEi6a8FPyW8AGAL/0kN8W
	WWTcdrSJBEIyhSFqXbCkIGFuAIwj40yfkfN0fJ5nxJePi0ov817gOgHlE+RDNtAIx38WaE
	6hHvGhw1HjGEv5Xxv56VKG2kJ2Y03bY=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=AKvQC+bg;
	spf=pass (imf29.hostedemail.com: domain of jiangwenxiaomi@gmail.com designates 209.85.128.45 as permitted sender) smtp.mailfrom=jiangwenxiaomi@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784086301;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GtP7mqdwbcbBQ3dE4FdyL7JubqoEeAIm5NkObJNd6ps=;
	b=M+KO469D0crV5bjkRR37SwTShjU2+TWFBlix/d8O+ULDGuJZHNiBklFz6WqbEUmOJas5Sk
	VMQ3f+Kwyy8EJ16zyJHE8bLkFVMUck/bvXFMctGDmtRXDpn49E0IKB2d6vWX7TAmUZstLn
	N0mhh5iO/+O1DoeWEt4VDNedmneHD6k=
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-493ec555a26so31570935e9.0
        for <linux-mm@kvack.org>; Tue, 14 Jul 2026 20:31:41 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784086300; cv=none;
        d=google.com; s=arc-20260327;
        b=ZRmFwTqHHlzha+R1DTimGg3ekhf/FlcJYgOqhSe9SgeyBOPm6naxqeFarMClfakSm1
         s8i0bT+jnTmA978deZREGjRQa9IrQsWiWljK3maQz5LeFfyfW7ba7fZHm9C7QvTgweX9
         f6bayaKKVh+GZ34W0rFlK/bshXrG2/ls+smdIvsuATnYlnYS18YyCUMOfn0nZsfe+/ea
         uLaA3xI23GDez1fB+UTn0MiQfF8KYeeji2wZ5vl5UhGk64upZt/kts4SzCZYklSBF6Gw
         acs7TXm3DsnfyGcKog5Wth19/yn/13kkIscxfy7ebUsSKoDKYzNMwDlRBP/A4UB1Io+D
         haKQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=GtP7mqdwbcbBQ3dE4FdyL7JubqoEeAIm5NkObJNd6ps=;
        fh=cWukv+syTsgWOy3FOFyJjKq0HjjtMqdBW0Q8D6kOlAA=;
        b=f0WZNuWy5modX4Quid1m/GnS7DwYqc9iW7OhnVh8KdOuhlDcIJ2PCftuojq/HZVCvJ
         4qMOozKL4E/lc4ba0nrgMN9eXRe54zC6klqtLSqONvFO865KPDrVOktBTEJEJ5QzyDjf
         D/QS0ZXj0zHkcolxoI29DkG5rb5ZrH8G7ub37883xysR9+N8z9o1d/piAtaRbuutC49y
         KUs5n1AYaPxfljaNA4f2VT0AVBa7TJJ0zhQwhMjBcu2zQHKycL0Ni1qwPTVVO4Zay7CQ
         2zGmi2DZpmA3kP2saEDXvpYsNII4bYmaGSEvhI2v/15rTscveqWqg30hRrH6MjpZQEHV
         Ptkw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784086300; x=1784691100; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=GtP7mqdwbcbBQ3dE4FdyL7JubqoEeAIm5NkObJNd6ps=;
        b=AKvQC+bgA59u6/c3Fo1PScMyoCZ4jrEbTBhM3mlTqowjNtHbtlJEPPIVHcO6Sdg9Fm
         +PMKl0mdEDnwDMPqSJjlw9LkMFkEAYE1/0WJIDhEF5eymLh3QeuMPQg5h5qMdFbGQcd6
         CicEKbEinqkl1L4WMcLC5x9exUvnvW0w4xqwCvmHAWM53W9mou0CmU5DcWygXQVIrmOu
         tKNeUnffSU05DGwVRemBPVgdevGEshYiWV3IGbpyGCfDrYY44/B53jhXmW3xrC2SEwBZ
         xkvf7n10lhfthFKI/ZaLSD37Z0YYw9k/JTWJzcHHSJgjjlyh3MpR8voM45TXP7h8vagl
         tF2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784086300; x=1784691100;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=GtP7mqdwbcbBQ3dE4FdyL7JubqoEeAIm5NkObJNd6ps=;
        b=QQ1P8SyhTfA5aH2ISenyJSRsj9KBSVA/nolMxbbge71oeXtpy/2BD1/oL18uGt6vn3
         RCT79x9jpbUe0nkRz4N0AEjnKWuY22FIVkYoZTzcvpAWEaLaQwyy5R2mAS65E6A2rxvU
         thqC2Qb4h3H/dPb72sEYw5uCA2k06hpqEmMnn0KvYd/gthb4cTNdYpzN83sR4u/o82wK
         PGvw7m9jXWGHgp+WCl5Fgj61pjzmVgN+YuedGM4k/p/gYWDBN0ft3wJzSLq3iBniIAhi
         ybnc3Ohrr9WFoZYiETKCwkOavPSQ+78SeOvPeAIJXgZP+CdW6ELApXz9pR6iefTh3Td/
         O+wA==
X-Forwarded-Encrypted: i=1; AHgh+RofWnP95c0bvwH7n1URuiljPvpIEIfmQsXjrAoMlV8x5f3I0sCWnGheV910pC5/5OSUoaLIJ0mp5g==@kvack.org
X-Gm-Message-State: AOJu0YxwQAnWddKESO5yf7BaDmPVH4yHlTDYpGmhkwNbsXsb/cXE6DHZ
	7KGsIrF2XR4HDcvORc9BGP42fNsDmFW6EEnqsoRGvz48pNlovODLAQLW0cdBSzSO/CGXXMNNVAj
	GIbjasvKdOgHJ/dB6JKu/tRwzDUrGaVo=
X-Gm-Gg: AfdE7ckOqYpecT6AvShU5TxjrlHmAEKAB+ZH5hujdy6uf1q4Gp8GGxo7tXubiWH48Dd
	Di9f6AnIGL/ox8OX+PQEldWC17ERCv4mLWNhzC2XnMXZ4mynyWfMw9z39cH7A/W2FtfoVeziSkl
	cHDw05APjG1TA6hb2/52udjZG7UjA6eTgfhvnBHiL+5jarody4GxYTWBOcfNFC3lJSO8JjTyA7a
	Yb701my+OHewWyPR0kH5od4D1/QcXUCtsbfv4dT81h0zLS9o6Myt6ZrbZfEDlqV3BJOifALug==
X-Received: by 2002:a05:600c:4ba4:b0:495:3af9:4cfe with SMTP id
 5b1f17b1804b1-4953c27b2fdmr6872935e9.20.1784086299564; Tue, 14 Jul 2026
 20:31:39 -0700 (PDT)
MIME-Version: 1.0
References: <20260709073823.6643-1-jiangwen6@xiaomi.com> <20260709160805.26e63bae89dd03cf2951104e@linux-foundation.org>
 <CAHKocdH5kp5kTtZht+v5j-4-Thh40TGvif3=kRMgErRXr+Q+RQ@mail.gmail.com>
 <929dedc2-eea3-4153-be6d-d2dd727fed89@arm.com> <a08e2a7b-2ab8-4429-8d4d-9c13b6a2a77b@arm.com>
In-Reply-To: <a08e2a7b-2ab8-4429-8d4d-9c13b6a2a77b@arm.com>
From: Wen Jiang <jiangwenxiaomi@gmail.com>
Date: Wed, 15 Jul 2026 11:31:27 +0800
X-Gm-Features: AUfX_mzMWyMfwUSgcUr2LDzdSwpL1lZmN1GS12WSAWlTo3L5vUmb6NstvZeybe0
Message-ID: <CAHKocdEJHF-33ExyBHJEvr6hTWZ2xmTXPqmZaC67TyLmwNnp5w@mail.gmail.com>
Subject: Re: [PATCH v6 0/6] mm/vmalloc: Speed up ioremap, vmalloc and vmap
 with contiguous memory
To: Dev Jain <dev.jain@arm.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>, Andrew Morton <akpm@linux-foundation.org>, 
	catalin.marinas@arm.com, linux-mm@kvack.org, urezki@gmail.com, 
	will@kernel.org, Xueyuan.chen21@gmail.com, ajd@linux.ibm.com, 
	david@kernel.org, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, rppt@kernel.org, ryan.roberts@arm.com, 
	Wen Jiang <jiangwen6@xiaomi.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 37CE6120005
X-Stat-Signature: cmm7s8jdhxpshpsi6tm6pxxrtzybr7on
X-HE-Tag: 1784086301-502292
X-HE-Meta: U2FsdGVkX1/AaGt64uklyq0vA9eSZgCutAm4X6WvXXQozHDM0bZMf8mEcogqxvSM5G1UxHQPP7c/gIPvD7z3s1CmiUa3++s5DuoFiLa6eg6kHNW/eVEjRxoGhMVqAVdPcY9L570jJAfhWolm9gYjScEjuStFw6U4+TyoB97wCB1TBIs51zOmdo5SQjSBaOXH1A9cGfInge5hPMB9gbQUBqrSiLx99m1FgZsYQ1XSn31W62wlEN1W+E2XKUK3sv6LejaeaVC92BsElE5hZEuSdMeWPwRnlAtIHFL3HN9hufCpAQalCfDD5UZjycdtRQBY4uIukIIkz+Qb0QzVN1Fl9PsGIjZ0EllBvpFRhdA/OLwxs0LHMvfefxwI06FO4pkwE0IE6gMwAaAQ00I9Q0BVC/9sm9Un7bXPwKWtdAcZu9OhTgCbyA50TQONDis6o+Ggk2swc8rvappb83/Q1OTOZx+qsabigscTzcgzK3pzDY808in5U5Pj2I3yU/ggovzurvC31zoJBzjUe14qNGgXtpye+ntM9s1abfgZh0vWiOM5bZaOMKuV7OIDwsp02B66BitDqnJEN6D4UfRnv3lsLg2w28P6H7/rZorJGHGhk/07YgSpttYvUv6Cv5m0dns476vJr79E44m4GrpkV27OnOfxCoVxOsPecCORkXPRPLBQX+kgrlsSWV+edDuPvmJqOHmwevtgtvjiXx32Yos5JQFm22sRJ9GCqu/8XcIvIoxawzgjkdHHaN+p+NsFPdhviASsq0q6IxBHg6sylo1ErLZlhLcSntYR0NM7kSvmk1gVSnmPAplPZolVSPi80WPdPzguNH4r6VIiVctuu0VO3A5HOj+yTO23PIlqQjTpg/4C153OV/YmhNBjqDBUrn37qudvVc9lp7kqfsnTP4OHnj+ESjFZYzONtd19wWLJTwR+LWHrrDAQ606cM4VUq/rZZDjmVrkAu0E4DjlWHvf
 TudbxwEC
 pyDcB2VJRCtOnEdyAtHcHoBlaZaNU7k6SgIpoxiy3mUtCehNPfn0RfWGNTMnBJk9Zjs2T34xoPxTOUIXYVBAjP3//qOWlg3Qs+Nq0s3XiLeVzeu5g8zGmPPA49LhaUYMeo8LhLYQ2JoGdbGr5mD6lHMIC9CNZuVn8tnFCbGY2++aOibxcMr85Wgrkrs2uCJW88/XhHBkxzcdPD0nXJgkK6Q9FveAlO93aPilWYJgmhzkTs2EkwJswroALyWYaG7l9MkOxyYPboNf6K+oZ4djU+2AgeN8LiKOcB+FmqyxyXYC11NVjbDBeaLf7dCOyfDOQzL498kmZqa/Y4su36aJmqRaRqgLFoRzzcyoBte6uYFjZCr5VBcNJO4e3G27Cm0/1mPLr2re6n4Rs91PZBQrSWO1Gkn5Tx8zG6G0GagBGMrO3+bxO1xrK7czU0LllBZtnr6y9Apx5NwyavZOKpZqS1ykoQuncgk6gATmSG8G3k+u+cPj/axkMlOdyyGKyF6FXf5TqYvAZfDYw2zsJkWP5MGaqBhqQahP5vJiuHXEsAU32lKkhWfpkU/P8BTZW34bxdbPcIcizkp3Qy5mhrfRAfs9BFcqCwptr9DGDj6CZBMSZLtu/54RMlHn5c+oc2roqAJdMpX1v07dTi4hoXpjIfHbKgCKIrTIOiRmpdx7BljVTE5xfgFSqq4D5FYQglSvevy8p
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 14 Jul 2026 at 19:17, Dev Jain <dev.jain@arm.com> wrote:
>
>
>
> On 14/07/26 2:06 pm, Anshuman Khandual wrote:
> >
> >
> > On 10/07/26 2:24 PM, Wen Jiang wrote:
> >> On Fri, 10 Jul 2026 at 07:08, Andrew Morton <akpm@linux-foundation.org> wrote:
> >>>
> >>> On Thu,  9 Jul 2026 15:38:17 +0800 Wen Jiang <jiangwenxiaomi@gmail.com> wrote:
> >>>
> >>>> This patchset accelerates ioremap, vmalloc, and vmap when the memory
> >>>> is physically fully or partially contiguous.
> >>>
> >>> Thanks, I added this to mm.git's mm-new branch for wider testing.
> >>>
> >>> AI review asked some questions, and some of them are new since the v5
> >>> series:
> >>>         https://sashiko.dev/#/patchset/20260709073823.6643-1-jiangwen6@xiaomi.com
> >>
> >> Hi Andrew,
> >>
> >> I've gone through the Sashiko findings:
> >>
> >> - Patch 1 (find_num_contig): Over-interpretation. No new hugetlbfs hstate
> >>   is added. The extra sizes are only used by init_mm kernel mappings via.
> >
> > But not sure if that is a right approach. If these multi CONT_PTE
> > sized mappings need to be supported in vmalloc() but without adding
> > corresponding HugeTLB sizes, probably these required helpers could
> > just be factored outside HugeTLB.
>
> The problem is that the existing vmalloc-huge code reuses the hugetlb helpers
> because it is easier that way.
>
> If you really look at it, num_contig_ptes(), set_huge_pte_at() and arch_make_huge_pte()
> do not have anything to do with hugetlbfs, but with huge mappings. It is unfortunate
> that these helpers are sitting in hugetlbpage.c . Really these functions should be
> pulled out of CONFIG_HUGETLBFS and put into some common header - but I can't think
> of a clean solution to this.
>
> So I think for this series, the least we can do is add a comment to clarify that these
> helpers can be used by non-hugetlbfs mm code to set multiple huge mappings at the PTE level.
>

Hi Dev,

I tried to add a comment, but it feels awkward to place it cleanly around
these helpers. Since the change is mainly about vmalloc reusing the existing
huge-mapping helpers, I left the code as-is for now. Do you have a suggestion
for a better place to add a short comment?

Thanks,
Wen

>
> >>
> >> - Patch 5/6 (NULL page): Invalid input. vmap() expects a fully populated
> >>     array of valid struct page pointers.
> >>
> >> - Patch 6 (32-bit count << PAGE_SHIFT overflow): Pre-existing. This was
> >>     already discussed in the V3 thread, and a separate fix was proposed
> >>     there.
> >>
> >> Thanks,
> >> Wen
> >
>

