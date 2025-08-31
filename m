Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 80BA3CA0EFF
	for <linux-mm@archiver.kernel.org>; Sun, 31 Aug 2025 03:17:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A4FBD6B000C; Sat, 30 Aug 2025 23:17:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A011D6B000D; Sat, 30 Aug 2025 23:17:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9170B6B000E; Sat, 30 Aug 2025 23:17:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 803B96B000C
	for <linux-mm@kvack.org>; Sat, 30 Aug 2025 23:17:06 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E653B1A0310
	for <linux-mm@kvack.org>; Sun, 31 Aug 2025 03:17:05 +0000 (UTC)
X-FDA: 83835591210.02.5FA398A
Received: from mail-qt1-f178.google.com (mail-qt1-f178.google.com [209.85.160.178])
	by imf26.hostedemail.com (Postfix) with ESMTP id 44899140003
	for <linux-mm@kvack.org>; Sun, 31 Aug 2025 03:17:04 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=k9RLzxDY;
	spf=pass (imf26.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.160.178 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756610224;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5N7BdKrpgIpY9aSYUioHU5026fLiwEEjedpqQJ1T/KU=;
	b=JhqbYYf1pdcASSGxdLVfqN/rJUNPO+ZqeA+DWcViacdx4kf/bECLUrC9qUVvDO0MVSiFOa
	BpcZrqPMgmggEfaMpDlb/DatRJqDl4iHyjmuS81AdQK/UXwLm62JzjBemgEVAjF/MMihTa
	nVqBbtzCAZx9dN82Fs0dsQ9LqvlX2QE=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=k9RLzxDY;
	spf=pass (imf26.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.160.178 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756610224; a=rsa-sha256;
	cv=none;
	b=7KzsEOr0Z/FYrAfslBCLUoS+ZvkHZMie5gwwR2qtp8fxc7IMPSFiuw+BxfQyenzLXXix4k
	qmytN0ZCdnKP8n49b+iNoEqaq1bdRUeuIXy8hLeqkUybEnpgPtQZ071oZY+rxZSKqN1WkY
	sjCd0mpl8528cVmtSJdYHjDrhhZYuz0=
Received: by mail-qt1-f178.google.com with SMTP id d75a77b69052e-4b2f4ac4786so26375941cf.1
        for <linux-mm@kvack.org>; Sat, 30 Aug 2025 20:17:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756610223; x=1757215023; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5N7BdKrpgIpY9aSYUioHU5026fLiwEEjedpqQJ1T/KU=;
        b=k9RLzxDYOx32ElLBDSvQbGjMim0pMI54NgF1qrclGnX5XVvsmBm4cIsCwHav3wlYB2
         feot5Kxs8HO5jGaJIAIPt/456KV+sr1N+RyybuZonrf9HV/JRArKmqJMdt4zWI1hsb/e
         9/0sQgS2POmrtMJgB8/iT/NXJOomnxPXU9jEagzYzWTWGheFReo5ptAOmyjWnV67jfzf
         z07ObFM8cwXaX78InHibOSV0N603DDsU8yyBjGny/B3yNvGJqzSEVmQYsOOG1Jv3Tvs0
         bEXj/N7Sa0GsXe5IG8jiHGzcwSFw/vS1DgkVJ7nM/6SoNQX4vORkujzWfEt2eu+/GatR
         GuDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756610223; x=1757215023;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5N7BdKrpgIpY9aSYUioHU5026fLiwEEjedpqQJ1T/KU=;
        b=ACsDftcm2PLmuu94or0nkjbC0ROzLDWelUEaRiqJGmUdXU08DHbQAxVU8NGngxDC+S
         glqX8nTKbOv76bFuF8WS4+Ko7nvBps3S77oH9zHzYorEZWkHKGYr1jKVlRwyD915ouDL
         IH0yrywJN0dUt+A5ezFY0H5+huQ06nKQaJI3RI9tQ45Mh7hBBr7ljojor1pTEhSW1//F
         HMQ4y6KDGxxXlsn7hDr+H4qfKGDV2vC7NmGUQGUrC2LNXmer8Hj+3lDh2e4waNk6TPfH
         V4Bc4bmdNSzEGHlrsF+Ehp8hYHKh0+GSlmrAUWHnp71/PzH3QsWRbLLaHe/Nit+8G846
         kaIg==
X-Forwarded-Encrypted: i=1; AJvYcCVtpVZBJz8hmwGNPa0U9BrU4/a90HGtt2E5si6irgagj+9WqYT35/i0MXFtlUvQb9Xo4MjUKzkQ4w==@kvack.org
X-Gm-Message-State: AOJu0YxNnvDgRL2/epEIXdaDlzqwGmvnpPKTl1ogyxGRN/aHB1jn2w1G
	P1FcVtG4SikuFdxwBcf3MLv/LihaOE5C1kb8tHxfDIDKWhrEN8qzk++irMswrCmH1bFAuLrYVd6
	j5A/UhtRpA2MzoYnnNx7UQPHn25u/vzk=
X-Gm-Gg: ASbGncuYcAEnd1V2880VNKOVKM3tLUi84a/WTin1fIQhsMEi+h68Swya51OxUcGNn7l
	iBoitB1JJ9Zje8IuGAvBBWIfuQA722c3JXD77Q0qtB/gJvZcTUJjeTCvak9vQnRFsrPNen9R2W7
	VYiu9q1LEgPksF2g+I6Fp18Bg8bCeQYmtO26FIutF+b+Sf431Q1pQnWLBr+Zs3awQX+8xTN/g3J
	ih0coElTh0sgiG5bo6kmwcaoAS0gC1ouSdrFo0D
X-Google-Smtp-Source: AGHT+IHe94eMIWMY4dbrxy1YiHjHy0HuBEp+5ADPw2mSy4ygzqofX4QZ6gFssRpbt5INRd/s9w0eUBJOOA9RRs/hVCY=
X-Received: by 2002:a05:622a:592:b0:4b2:9830:197 with SMTP id
 d75a77b69052e-4b31da3cdadmr39861351cf.48.1756610223300; Sat, 30 Aug 2025
 20:17:03 -0700 (PDT)
MIME-Version: 1.0
References: <20250826071948.2618-1-laoar.shao@gmail.com> <20250826071948.2618-5-laoar.shao@gmail.com>
 <bca7698c-7617-4584-afaa-4c3d2c971a79@lucifer.local> <CALOAHbDxxN8CsGwAWQU4XRkG8NvU-chbiDv=oKW0mADSf1vaiQ@mail.gmail.com>
 <b335afe9-be7a-46bb-bf92-37abf806d164@lucifer.local> <CALOAHbApv0Sj25La7EQZg7UBxfvkfMXpGPtNrYKABSYpNV6ORA@mail.gmail.com>
 <a4d0857f-1520-49a2-a717-3e74325f2d6f@lucifer.local>
In-Reply-To: <a4d0857f-1520-49a2-a717-3e74325f2d6f@lucifer.local>
From: Yafang Shao <laoar.shao@gmail.com>
Date: Sun, 31 Aug 2025 11:16:27 +0800
X-Gm-Features: Ac12FXzUXlC_rm_aYklaAinmwNAfHTa64DZQJN2Q1d5F2Z14aWeMQl-5B-4ZRZM
Message-ID: <CALOAHbBaC2sd578CCT_15R64P75MAtYopm+pDrRqmOJpaOB-Dg@mail.gmail.com>
Subject: Re: [PATCH v6 mm-new 04/10] bpf: mark vma->vm_mm as trusted
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: akpm@linux-foundation.org, david@redhat.com, ziy@nvidia.com, 
	baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, npache@redhat.com, 
	ryan.roberts@arm.com, dev.jain@arm.com, hannes@cmpxchg.org, 
	usamaarif642@gmail.com, gutierrez.asier@huawei-partners.com, 
	willy@infradead.org, ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org, 
	ameryhung@gmail.com, rientjes@google.com, corbet@lwn.net, bpf@vger.kernel.org, 
	linux-mm@kvack.org, linux-doc@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 44899140003
X-Stat-Signature: isuz6ca8o5xs9yy8mty7rba1693fw53g
X-Rspam-User: 
X-HE-Tag: 1756610224-247184
X-HE-Meta: U2FsdGVkX1/dPBqjirYb70yBXU5h5ZglVMVJMKk7h0YGco31hJAGkieJJQ6ZGtgeJ8yGV4t3Iim7y+muCloXwM1LLu16fBeoTK4x0YifTk/1TY2CHWL+Cm+V2etw3okMiOZ5TawrPf63ZzuCH8QY5G51yCc+8XkgkM26O8j2JUUE5muTfs9qZhOD5flStm5FdSt6NfnBdrIU0vmV5IcusHv/N93KvKi2KtyIjW2vs4TFkJu/Uk2qND2V8HAxLAb0td9lZkPCGc/hEg9r2gS0teDNr0jT3MkHyFD7LGpHDm+5daCSxVFbAicEAjZg1yb9YL1Nngn1cgPEfwXJXp/u7Qw5FH4YwomDg7BvtihprY0CjsfCtEJA5rv5CjkY/e9Enuw7ZVzVuLQakLd5c0kzWLXf+yKk0ijVShOn65H68Ux6ONr5G0+0+HWBnZDCnM90//BYIbGAcCCr4p6cOXLS9TUZioAS6ov9LfA0m4sTXUiGeZhuIt6s1euRX+4h7xZkXUKE+S7z4XQKOsXq6s2uezJWYZ7e1AL14NqDQRWB549RHfIB2RDL6WTfULbpPIhaCYI9e+pMwNFvP0lO6x39qSk3QbrLX6G3c1GNz7cq5kNFraw88S7eFqXr43/vQrzvSDzWZm6c2Kcn0eEdePn5bpX4buRmQjdO7cJ6iH63XrCrZBUvdzfNMmg3ErwMFwxz307OZyU0kOUqfw5b0rG8hrtURF/u6h2Q6epKGgnSS1gXYqHKs4bxCSxU8K9ey1QRKWEGjXqiYqeSoXIuRyygfNga9OWi8khwH2scfIAP+AEW/rRsoMoXLmtPG+oBo/FL9TAygeEZqZjQyn52SY0lXOSCYhLjMkbk/+6MveWCxpASd7hHBfM0na6DYlSPRqUCnUv005HE/TpYhHLHMDbTZOPRzwS7zXykbJOGGjFX6f1drpaMIjzhDmol8HAeF2aKETYmomXXrNCLQnH7FSi
 ToJp7V4/
 Bv/7muKX8YRn4FKJQUF38LHKfQuyNUCYHrlZ+6Zyg4whx26I0IcMAIsnbfnxfXQNfKSJjesz0XjDuT6d+aV4cWMFVvwPaIYqNK1FB
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 29, 2025 at 6:49=E2=80=AFPM Lorenzo Stoakes
<lorenzo.stoakes@oracle.com> wrote:
>
> On Fri, Aug 29, 2025 at 11:05:01AM +0800, Yafang Shao wrote:
> > On Thu, Aug 28, 2025 at 7:11=E2=80=AFPM Lorenzo Stoakes
> > <lorenzo.stoakes@oracle.com> wrote:
> > >
> > > On Thu, Aug 28, 2025 at 02:12:12PM +0800, Yafang Shao wrote:
> > > > On Wed, Aug 27, 2025 at 11:46=E2=80=AFPM Lorenzo Stoakes
> > > > <lorenzo.stoakes@oracle.com> wrote:
> > > > >
> > > > > On Tue, Aug 26, 2025 at 03:19:42PM +0800, Yafang Shao wrote:
> > > > > > Every VMA must have an associated mm_struct, and it is safe to =
access
> > > > >
> > > > > Err this isn't true? Pretty sure special VMAs don't have that set=
.
> > > >
> > > > I=E2=80=99m not aware of any VMA that doesn=E2=80=99t belong to an =
mm_struct. If there
> > > > is such a case, it would be helpful if you could point it out. In a=
ny
> > > > case, I=E2=80=99ll remove the VMA-related code in the next version =
since it=E2=80=99s
> > > > unnecessary.
> > >
> > > If you lok at get_vma_name() in fs/proc/task_mmu.c you'll see:
> > >
> > >         if (!vma->vm_mm) {
> > >                 *name =3D "[vdso]";
> > >                 return;
> > >         }
> > >
> > > So a VDSO will have this condition.
> > >
> > > I did a quick drgn()/printk() test and didn't see any, but maybe my s=
ystem - but
> > > in any case this appears to be a valid situation that can arise, pres=
umably
> > > because it's a VMA somehow shared with multiple mm's or something tru=
ly god
> > > awful like that :)
> >
> > Thanks for clarifying that.
>
> No problem! These weird edge cases are... weird and hugely confusing. I s=
hould
> document some of this somewhere, as it's at the moment more 'oh yeah I
> remember...' then having to dig through to figure it out.
>
> The "/dev/zero file-backed but actually anon if MAP_PRIVATE'd" is another=
 fun
> unique case.

It would be immensely helpful if you could document these cases. We
truly appreciate your contribution and the time you've invested in
this.

--=20
Regards
Yafang

