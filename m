Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CD04DCD4F54
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 07:55:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F1DF36B0005; Wed, 20 May 2026 03:55:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ECF036B0088; Wed, 20 May 2026 03:55:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DBDAE6B008A; Wed, 20 May 2026 03:55:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C7E276B0005
	for <linux-mm@kvack.org>; Wed, 20 May 2026 03:55:17 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 592558AAFF
	for <linux-mm@kvack.org>; Wed, 20 May 2026 07:55:17 +0000 (UTC)
X-FDA: 84787037874.21.B241481
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 584B540009
	for <linux-mm@kvack.org>; Wed, 20 May 2026 07:55:15 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Zz1pFE3y;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779263715;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wc/vvTgzveMBCa1VNMjtznDysK0tqOG3obOVDsPoPMo=;
	b=QxF/0ngZ0d63e3HzsFSkEH9/vj0AeZq0jrqynn/0D/B+cyskM0OQErSTsBAcsa8mp7seJx
	DaCJGNbxXnNUXNjn+NtUwe/qmxPoqimQw5XimvJ6M91c/z+c/ETsMBbsqq2REAN53SmwTO
	RptgwYx1wtP3kytxdKJ57xaz+IkDiLc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779263715; a=rsa-sha256;
	cv=none;
	b=fwg9ckoVGaQ2w4H5HTZ/dDPlR1JZmVCyk2Ors66m/KGTBeCJLjB8t90dt0SbKT1Jd3Nhmy
	IS6iWWf5Ga82TL+wK+f+gOkDRPQabjkmp60A/QjgQ3DqyzdN0sbVqX3VZRGYAzQ4qFT4Sg
	uSXkHxv78MRZxc8LCCzcWKv1F4iPzS0=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Zz1pFE3y;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 569D643CD1
	for <linux-mm@kvack.org>; Wed, 20 May 2026 07:55:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B1DD1F000E9
	for <linux-mm@kvack.org>; Wed, 20 May 2026 07:55:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779263714;
	bh=wc/vvTgzveMBCa1VNMjtznDysK0tqOG3obOVDsPoPMo=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=Zz1pFE3yLvx+kSeccOx00pKqBwSlpeal3D40KlqrSOuG07+i0w96ySbZ5bmuy6ij5
	 mT+GiADAQbvYZuNKIOB1eJDkKg+d6plaP83L80DwpH3JzaZ125mHkX6gRBITMUBBiV
	 DaTJRJNU5WJ0u/E6xT0bGashamig92usYxrkSBLubyXqr05Ptq1oyx8lAk3BL6GsM0
	 dx7OqDVwjOSGLqsopIHRLpVd9uSquojyudZMA+pnXhocnmQyn+ZL1kkhTwEGlMHqhO
	 QZ3ALhNICESebGXehlyX637Ce3rO18rdDwjAScUAW5nmLQv5mVxrKmISZJXPw6WW7d
	 pvQBP2Fomuz8g==
Received: by mail-qv1-f42.google.com with SMTP id 6a1803df08f44-8b74b460d77so59749136d6.3
        for <linux-mm@kvack.org>; Wed, 20 May 2026 00:55:14 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ8kTea8dl7cbE2Ekv6VZgs0hnQy6SUxF46TIAr70fTkpeQeS7YNmi4kjJlJtPJn5nWciBAl2yeo2Q==@kvack.org
X-Gm-Message-State: AOJu0YwZspOlk7ZZHuoueacjmcy07ZwSLt8KLPA9RSh2Yh7Ub84lugeq
	F/T/vVZlRUtx+R4xmoVs9QhbYGiMcXFP1ubqkcOWEU7Ri/JJ3D2IFbTr8a+7Ne1yGfHJXvPIVn1
	9Olxkm5RXAXEQ8VVP8O9MMSXreCbq8bE=
X-Received: by 2002:ad4:528a:0:b0:8bd:b850:6cf2 with SMTP id
 6a1803df08f44-8ca0f5c30a9mr269197456d6.1.1779263713639; Wed, 20 May 2026
 00:55:13 -0700 (PDT)
MIME-Version: 1.0
References: <20260514094108.2016201-1-jiangwen6@xiaomi.com>
 <20260514094108.2016201-7-jiangwen6@xiaomi.com> <ag1jhrWivbasi8Jq@milan>
In-Reply-To: <ag1jhrWivbasi8Jq@milan>
From: Barry Song <baohua@kernel.org>
Date: Wed, 20 May 2026 15:55:02 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4zjQDOXToau0xoWOTnoP9kODxRdzSeNX6n_b3wxguC4mw@mail.gmail.com>
X-Gm-Features: AVHnY4KqBVtojg2o196NOt2aq-W7HkKHoLZxSEfiF5jAr2g0RL7Axc0xtO1xgj4
Message-ID: <CAGsJ_4zjQDOXToau0xoWOTnoP9kODxRdzSeNX6n_b3wxguC4mw@mail.gmail.com>
Subject: Re: [PATCH v2 6/7] mm/vmalloc: align vm_area so vmap() can batch mappings
To: Uladzislau Rezki <urezki@gmail.com>
Cc: Wen Jiang <jiangwenxiaomi@gmail.com>, linux-mm@kvack.org, 
	linux-arm-kernel@lists.infradead.org, catalin.marinas@arm.com, 
	will@kernel.org, akpm@linux-foundation.org, Xueyuan.chen21@gmail.com, 
	dev.jain@arm.com, rppt@kernel.org, david@kernel.org, ryan.roberts@arm.com, 
	anshuman.khandual@arm.com, ajd@linux.ibm.com, linux-kernel@vger.kernel.org, 
	Wen Jiang <jiangwen6@xiaomi.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 584B540009
X-Stat-Signature: 8yjpy31yp13fm1ehk5erspb4ji4q93dx
X-Rspam-User: 
X-HE-Tag: 1779263715-81490
X-HE-Meta: U2FsdGVkX1/wPV6qzxLrefLyPgLoELdXp/on5urqxMp4pJGVU+weqZbqZVghgDxDDtl0DTEQItPCkVjudas8+95QBRt3mH82e4l8FwBQg1VAt/wvHEDomXh/HURGYtTqMxkX1V74pplxbvzbmsNl8qZTs28Xm0/L27SL0tKVgo0zzYq9gx3ietWal0fmeRvUQhIdAlOhA1LdC/cigIhnMYmql6Pzjxr36dVwOkGNQauxH+T7t4q6dZmGel3A3GsBE/njL/lWJaJfHMqHisOJh2Wxs6m7mpNmTd7EYTbiO6UOHg3cm+p/QXjzEFUl7AnLI4cuvgzSRfQXImShDpqoE7S37NoJU7ZfpXDB/RnACMU/3MEZRcoV9Nt0JYzVaoeY9NK+wH/boPIMcdzpBlt+8OvVgf62V5/nSbUkstC7Aiv6v34CXNFDJBe/QHJptE5J+yrZ0Au7SfgS+B0w5xR18fLr94LB4eIOUwPiAR+Q3nkBt1nnKYJg2OHHLjxcqfZFdBnt+fMu1/Dv9rpWLbqtXU3UmkdZOVEQlHngTK1nChLEy2fQuzp1nAflcvZLN3fNF4a1JobuChoSGi7HYOJWBptYdld4BvPG63H8uNYrXua4GaEgo9ZwVoEI9mZpWIEuANlGeNksGRm+umVlr36rVRbkWklXkozzXj+MRBEjjScrq5wxH2UxLhceu2Lbqdc666T32/0P5lcLxr2/Yxpd9S8rWm9VLFBYDMmOyxzyppm/CVygRPWTjzvP9WJSg7CEdUfKHnBJxqcH+G3gFOGvIOcvkJokHFHrEAf8FRZH7w0NIMlxpLTnH+0a86X7O2/H8CH/pCw3yM7U5sTGj0AXqbUPQ4dHb56V9V7zEhByMYm2voZMO7ak/MdprtD33nVeaWJeEJmcgk0A+Ag9PwI8GHc+KJc7JHKkBv16qZ4Qmn8tTqQWWbDei9SUVroJo+cL7tQyln7hpBsGYsqzjpK
 yzDqx1CL
 9vtRA3e5FBW3NQ1RNSFYwPMFlJ6YTPXX1qhIFUCv8cO3+CyU3WmrJ4P4uJgghkXga4nE7EHifg6GOaHC7WpAt4nICIs+Q3B40WnB46wHtTj5eRBHLs6LEeT3K8attJ1K573hrI8zWTMZ0YXowc8FBFzsj/TT/+lIhAMjS+SmQfABKmilnK2nRq8eReLLkFGoDfuA8SsCDLzJCBRVioDu09b41PShMhrzOEvjqF2+qQocSiTM5FmX44s9mtvFDShAOzKvPwyYqOZQbh1CzBj0nz+1ujFtRgmqw+jG6vuHdbQUVAoRzYG3KSlfz6qT1B6ixjfYUpcTMYbQInB4/Nrpu7IEpVGqZ4JoQ+j5/qcKf0dPMDcR+JSuJs1WYchMXzExBnBgCmD2nK4vy2zsdoVfYkzK7GuHFUkc978S+MbRn+s/1AKObJMrLOZeiKZn4FrltCSk2Nrxzj1dMqzM90NALVxAiYX9y/tCG6SD/
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, May 20, 2026 at 3:37=E2=80=AFPM Uladzislau Rezki <urezki@gmail.com>=
 wrote:
>
> On Thu, May 14, 2026 at 05:41:07PM +0800, Wen Jiang wrote:
> > From: "Barry Song (Xiaomi)" <baohua@kernel.org>
> >
> > Try to align the vmap virtual address to PMD_SHIFT or a
> > larger PTE mapping size hinted by the architecture, so
> > contiguous pages can be batch-mapped when setting PMD or
> > PTE entries.
> >
> > Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
> > Signed-off-by: Wen Jiang <jiangwen6@xiaomi.com>
> > Tested-by: Xueyuan Chen <xueyuan.chen21@gmail.com>
> > ---
> >  mm/vmalloc.c | 31 ++++++++++++++++++++++++++++++-
> >  1 file changed, 30 insertions(+), 1 deletion(-)
> >
> > diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> > index c30a7673e..b3389c8f1 100644
> > --- a/mm/vmalloc.c
> > +++ b/mm/vmalloc.c
> > @@ -3591,6 +3591,35 @@ static int __vmap_huge(unsigned long addr, unsig=
ned long end,
> >       return err;
> >  }
> >
> > +static struct vm_struct *get_aligned_vm_area(unsigned long size, unsig=
ned long flags)
> > +{
> > +     unsigned int shift =3D (size >=3D PMD_SIZE) ? PMD_SHIFT :
> > +                             arch_vmap_pte_supported_shift(size);
> > +     struct vm_struct *vm_area =3D NULL;
> > +
> > +     /*
> > +      * Try to allocate an aligned vm_area so contiguous pages can be
> > +      * mapped in batches.
> > +      */
> > +     while (1) {
> > +             unsigned long align =3D 1UL << shift;
> > +
> > +             vm_area =3D __get_vm_area_node(size, align, PAGE_SHIFT, f=
lags,
> > +                             VMALLOC_START, VMALLOC_END,
> > +                             NUMA_NO_NODE, GFP_KERNEL,
> > +                             __builtin_return_address(0));
> > +             if (vm_area || shift <=3D PAGE_SHIFT)
> > +                     goto out;
> > +             if (shift =3D=3D PMD_SHIFT)
> > +                     shift =3D arch_vmap_pte_supported_shift(size);
> > +             else if (shift > PAGE_SHIFT)
> > +                     shift =3D PAGE_SHIFT;
> > +     }
> > +
> > +out:
> > +     return vm_area;
> > +}
> > +
> IMO, we should get rid of this while(1) loop. It looks like you need to
> handle just few cases. 3?

Hi Uladzislau,

I don=E2=80=99t quite understand what you mean =E2=80=94 are you suggesting
calling __get_vm_area_node() three times? We try 2MB first,
then 64KB, and finally 4KB. If 2MB succeeds, there is no
reason to try 64KB. Likewise, if 64KB succeeds, there is no
need to fall back to 4KB.

>
>
> shift min value is PAGE_SHIFT, could you please clarify when it can be le=
ss?

I guess this should be changed to "=3D=3D" ?

Thanks
Barry

