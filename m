Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C95DBCA1005
	for <linux-mm@archiver.kernel.org>; Wed,  3 Sep 2025 02:11:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E9E798E0007; Tue,  2 Sep 2025 22:11:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E75EA8E0001; Tue,  2 Sep 2025 22:11:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D8CC38E0007; Tue,  2 Sep 2025 22:11:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id C587F8E0001
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 22:11:25 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 600BB11A0D4
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 02:11:25 +0000 (UTC)
X-FDA: 83846312130.16.F20A151
Received: from mail-qv1-f46.google.com (mail-qv1-f46.google.com [209.85.219.46])
	by imf20.hostedemail.com (Postfix) with ESMTP id 83B941C0005
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 02:11:23 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=DCdCRv7O;
	spf=pass (imf20.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.219.46 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756865483;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SdqNFNYALodzYVHsNSrlk7v0LMXjLfKbkcpRQgMAJzY=;
	b=TO9cDQYW39RHBf2F8EPZ/GRbYTffuQakx+WW8VNr/rOHw4VT9iSeYNt6pd86XeVOyKdpzS
	FX62juRBqb9/sVNvPhDnHp8nvYBlM+c0CBMv6qdZ8dPk3dxgSahbgf89DqSSAyGt2m0dox
	Jt0ecQHUQVmYnmEcNdnUuIGAPwFZptw=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=DCdCRv7O;
	spf=pass (imf20.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.219.46 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756865483; a=rsa-sha256;
	cv=none;
	b=cxKV0vDTGOP2Spl/5YO/0KbupUHH0QxNQ7fkscUJ7w9Eh5PjGR4TRJWoWTLsXTk7pQXPSK
	svubm9D2Cv1+1gQgRJiL7gqolv+m7LXoEuNaRtv+tmotm3JdRVyydM0NRgnURFhSxlDRUc
	jvTAhAkFdF4bQo99bJHIPAdkNq/oTTc=
Received: by mail-qv1-f46.google.com with SMTP id 6a1803df08f44-70de042246eso46787456d6.1
        for <linux-mm@kvack.org>; Tue, 02 Sep 2025 19:11:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756865482; x=1757470282; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SdqNFNYALodzYVHsNSrlk7v0LMXjLfKbkcpRQgMAJzY=;
        b=DCdCRv7ONsnGRYc8JTJtxFmEFqdTvHYW5FdUnDutkE9BFQO0xm1XFnR288RkRc3p3A
         X/FtKALgQBv9TxMxbrFww3utFBXXhIhm3WJU4icCExsBqw2JiILtmEwyFmADk4PtlcY9
         cOMPgULyAxy1LMVX/SBtLu47aUdBrYiZHx/e56C4/eQtWLFr9mjoMwhx1uYUxKeDyESi
         6TRBUeYIgnKhvtpSv0w5OXRvxzdkeyXLQeKcQCIBJlSYkBFZICgANB4yqYAtwMBDdcVA
         XqLxPsustH4DLzGBXb8p3Mx2/2VefQ88xhyc2DqMdYNrFqxxt8M5USVaqCnGoEEsXq4H
         GhoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756865482; x=1757470282;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SdqNFNYALodzYVHsNSrlk7v0LMXjLfKbkcpRQgMAJzY=;
        b=f4ocfx+FdIqTFK52y3Gti1YD1iqhjPKPkEjVpWsCUpdhQtzx7DwDAC7sTVC3koOUvf
         xvr12CxEZtPR1Foub4QsUFz3XkXfrI1Xc2HJ5blKONUlWiSIZlcAnt3c2N3chWICAKac
         8B5QTwmEpy7tZz+BTm4nCOjp26BQDJ4RAP6W/nG8FFcLAI5hcoYLpbABHVxQu0hVPwk0
         YNwYigfVepYJJrIoaD9f9wQ3lQ7vNViM2a7vCyIr6OCEtp2AL2wyZZh7bBgaEYHIJG7R
         Lf9FTrg+8c9IvP5Uw6s6Ut4J3TzFMabDXfVZbXdYNtwtIIl4fi88SUTh515bn68jLDgo
         7fuQ==
X-Forwarded-Encrypted: i=1; AJvYcCWmQ80v1aClvABycruIRv2lULA6PBvH58n6sBmd7tBOj0EBow+7smeUw9b4Wr78L4iifq5IixjQ7g==@kvack.org
X-Gm-Message-State: AOJu0Yz108Vf5R3ByPxKTc8wX4z3WGqROzIMEGOBwMIt5OFpY4keZ0Rw
	Hvie0rV1tVer9E/QQmK1qH9B6JvajRt158+r2pYIL9filxk2HRmwBUef+UcpqouCgBXcksGgoXI
	x+yV+hd54OwTGEJRyTS7CnkaiqCXYXcM=
X-Gm-Gg: ASbGncuUMBVATRjiuDbB0z5Eam/uv7UUN3KjbCuTZmPR0MeP5qxrchYj0lVO3w97mt4
	ryWrPT3imwxq9tfV+8oppmgmG4qwdn0WN3pBdaqrYF+9KKpAQAt7zWPURtT83WonPHsXvHhP3Mv
	iX7P7ku5YgQlv3A5JdKRyCvqbnZeldihTSm+adKwXk13D/YRcGzRUWRX6gxaahHTaMvQI3Z4ari
	4uE61nLhaNz1khfcyHc+QYNZTsixxfx4+2hVpe6
X-Google-Smtp-Source: AGHT+IGz2gBVy7MkvtGJ1h228Bg/OBFxRXDjUUk7x4EwH+bv0391gRJTsywXbH6IULWjrEHcWzM5SpX7ZwkmkyuZ2sw=
X-Received: by 2002:a05:6214:622:b0:70f:a460:c454 with SMTP id
 6a1803df08f44-70fac896f25mr173575846d6.34.1756865482399; Tue, 02 Sep 2025
 19:11:22 -0700 (PDT)
MIME-Version: 1.0
References: <20250826071948.2618-1-laoar.shao@gmail.com> <20250826071948.2618-2-laoar.shao@gmail.com>
 <f1bc20e0-9d39-4294-8f70-f51315a534d8@lucifer.local> <CALOAHbCd4vuZoot-Bt4y=4EMLB0UvX=5u8PjsW2Nz883sevT1g@mail.gmail.com>
 <80db932c-6d0d-43ef-9c80-386300cbeb64@lucifer.local> <CALOAHbCQucvD968pgmMzv0dcg1j5cJ+Nxz4FKaiGXajXXBcs0Q@mail.gmail.com>
 <95a32a87-5fa8-4919-8166-e9958d6d4e38@lucifer.local> <CALOAHbBRQf=QLqYgA9E8m6AKGmZxY6rFZsoXwTYCaiSqpTb=JQ@mail.gmail.com>
 <73ca819c-9a2b-4f12-853d-557a4e7399e9@lucifer.local> <CALOAHbDXBaumw0W=Ak=AQG+64jQb9Usy8_9m00vNaZ7SPKFayg@mail.gmail.com>
 <21b73d0f-c322-490b-8fb9-ef9f67f7393f@lucifer.local>
In-Reply-To: <21b73d0f-c322-490b-8fb9-ef9f67f7393f@lucifer.local>
From: Yafang Shao <laoar.shao@gmail.com>
Date: Wed, 3 Sep 2025 10:10:46 +0800
X-Gm-Features: Ac12FXw7pJ_LSeKo9cC58k0LnXweemYE9VcHAzJCfbisVZoecU7a9SJNAsKTIRQ
Message-ID: <CALOAHbCegJEHf+zaYuK6HFu_Y6KTwX_KSgsxaf_rvR1pF4aCMw@mail.gmail.com>
Subject: Re: [PATCH v6 mm-new 01/10] mm: thp: add support for BPF based THP
 order selection
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
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 83B941C0005
X-Stat-Signature: f1w18bx6ztpfrbkgfp8kaxa91biwhcrj
X-Rspam-User: 
X-HE-Tag: 1756865483-7398
X-HE-Meta: U2FsdGVkX1/0fCLGvsVAuv9mgUrj+j3S6V49VIf4BQoMzZWbCS0inhSYm72JPj95kCEnGX+1As1e0o8wcKT1e8vpP55wHDnoEcxAJwULhJOE964tgPuyg/CHO5RY1WWKISc2nLC+JLMMx6sTwp3kcRNbhq2PogUsku7EDOOl9/Nj3/FRddO4KLutPy9CohAv6OPhRYjUWrr+y1IWoYkrkIN91CDLVnRCp73naA1ym5yWhnlqXeCq4/wn1gfX1W7eVOrzNWne+NP9OCVUl4AeAbrCevM/ghJKHXyLp9WYDSbTE9qbExSsuCkCHxZsS4LVXOMTHoArVtDgE0BgnPfaK0+bgrDeul+BBfISvwhxOa1jij7g8wLBsNxFPrRmPXzYWVrhjTHYxFqd5x9uYgcJSPM66ftcWU6+V4IE2IzG8dKgSi/529Ke1WcDp23CuT0VRTBpuTvH3j3TBJcO5V+Kl2ftKnd2jWv/ya9sr2CNbNfKplQdvrRdkd6Lv54axAqhr5lRD7dx9WbYnAUrDuqI8qO4JgEjZ4rin34v3SxFDne3M5w/6O59mLKCSu7IMfga/SKJ8gPPDt46wC/kxSIRQx6uoQuBROwZNRlmL8iC4U22+EwnboNMTML26jx6fHPmbz+79Df7ogvn7pef8WI2OdiQfp1Pcrhtm6WI12JOMsRZDLyHEzC1jc4rDk9sJFKWbMH/bH8eJMUPHwRGmiONlIMGCFc0/N4u71FN89AiVVD/kt0VR2OujEuptcPQMpZW0zxwrR6nAvVkvLForwuNhO4epQpeSFXrnYkjv3MPxyj0tRbHtANHEjz2q63AKHlcySMZR+iN07qeyCuUi+u+WpDdOU8pH6c4jWTAOmcnWvLs/NtlAehTl9WiDNuTKCenAftUt4TXN6zNo4qqQhK/Qizf2v7KxLfI/LLVPEIYKObONJGgJmTx2yB55byHEc9TQEjZlYYWhO0bN4WHLJj
 aArpFcys
 1dwi2FVYVuqdY+2PErkBdxNteimJ6ooyM+lhS7FgrnEYqD9nj+FC0ApBv7DhPfrpTDG1Pp38PDIx9YxdX+l6IpLuuuor+w/ytuAXZWSNS+e0sku3LPICNtfSXgVotg5ZX8aukqt1ZFDcTEBDRR7LaFr0yUV8lf758C4a8DnzvvAh6G4UMyUJu09nOPsZsQX8nnod6UM6ST4GG61t6CeyWMCvZ7pXNji16Vf5tX7aDMQG+u3MQdZUOnTMHfSaobeEoFjY3+ek72xXKa+W/RZ0t9Wik6OXzyD5J8dEtRm2XaNs0k7WYc3BXp5BZtVOyGlCdWnxqFsxCgsUZ4QSNWtlRavkRjlg3DnNK/jg6j5U+0+p5mds1Wo+uEicuVEcVNFWp83PUyLnDRopk2OJ1bh5GDQG5XJAkw1T9ZMC2LanESFUN8dD5HsP7nlQYu7UIAFcVr6dr
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 2, 2025 at 3:50=E2=80=AFPM Lorenzo Stoakes
<lorenzo.stoakes@oracle.com> wrote:
>
> On Tue, Sep 02, 2025 at 10:48:47AM +0800, Yafang Shao wrote:
> > > >
> > > > >
> > > > > >
> > > > > > However, when you switch the THP mode to "never", tasks that st=
ill
> > > > > > have MMF_VM_HUGEPAGE remain on the khugepaged scan list. This i=
sn=E2=80=99t an
> > > > > > issue under the current global mode because khugepaged doesn=E2=
=80=99t run
> > > > > > when THP is set to "never".
> > > > > >
> > > > > > The problem arises when we move from a global mode to a per-tas=
k mode.
> > > > > > In that case, khugepaged may end up doing unnecessary work. For
> > > > > > example, if the THP mode is "always", but some tasks are not al=
lowed
> > > > > > to allocate THP while still having MMF_VM_HUGEPAGE set, khugepa=
ged
> > > > > > will continue scanning them unnecessarily.
> > > > >
> > > > > But this can change right?
> > > > >
> > > > > I really don't like the idea _at all_ of overriding this hook to =
do things
> > > > > other than what it says it does.
> > > > >
> > > > > It's 'set which order to use' except when it's this case then it'=
s 'will we
> > > > > do any work'.
> > > > >
> > > > > This should be a separate callback or we should drop this and liv=
e with the
> > > > > possible additional work.
> > > >
> > > > Perhaps we could reuse the MMF_DISABLE_THP flag by introducing a ne=
w
> > > > BPF helper to set it when we want to disable THP for a specific tas=
k.
> > >
> > > Interesting, yeah perhaps that could work, as long as we're in a sens=
ible
> > > context to be able to toggle this bit.
> >
> > Right, we can't set the mm->flags arbitrarily.
> > Perhaps we should add a generic BPF hook in dup_mmap().
> >
>
> Yeah perhaps that could be a way forward :)
>
> > diff --git a/mm/mmap.c b/mm/mmap.c
> > index 7a057e0e8da9..1b60bdb08de1 100644
> > --- a/mm/mmap.c
> > +++ b/mm/mmap.c
> > @@ -1843,6 +1843,8 @@ __latent_entropy int dup_mmap(struct mm_struct
> > *mm, struct mm_struct *oldmm)
> >  loop_out:
> >         vma_iter_free(&vmi);
> >         if (!retval) {
> > +               /* Allow a BPF program to modify the new mm_struct in f=
ork. */
> > +               bpf_hook_mm_fork(mm, oldmm);
> >                 mt_set_in_rcu(vmi.mas.tree);
> >                 ksm_fork(mm, oldmm);
> >                 khugepaged_fork(mm, oldmm);
> >
> > This provides a mechanism for BPF programs to configure the new
> > mm_struct on demand, acting as a modern, flexible replacement for
> > prctl() ;-)
>
> Hahaha that's obviously very appealing to me :)))
>
> >
> > >
> > > >
> > > > Separately from this patchset, I realized we can optimize khugepage=
d
> > > > handling for the MMF_DISABLE_THP case with the following changes:
> > > >
> > > > diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> > > > index 15203ea7d007..e9964edcee29 100644
> > > > --- a/mm/khugepaged.c
> > > > +++ b/mm/khugepaged.c
> > > > @@ -402,6 +402,11 @@ void __init khugepaged_destroy(void)
> > > >         kmem_cache_destroy(mm_slot_cache);
> > > >  }
> > > >
> > > > +static inline int hpage_collapse_test_disable(struct mm_struct *mm=
)
> > > > +{
> > > > +       return test_bit(MMF_DISABLE_THP, &mm->flags);
> > > > +}
> > > > +
> > > >  static inline int hpage_collapse_test_exit(struct mm_struct *mm)
> > > >  {
> > > >         return atomic_read(&mm->mm_users) =3D=3D 0;
> > > > @@ -1448,6 +1453,11 @@ static void collect_mm_slot(struct
> > > > khugepaged_mm_slot *mm_slot)
> > > >                 /* khugepaged_mm_lock actually not necessary for th=
e below */
> > > >                 mm_slot_free(mm_slot_cache, mm_slot);
> > > >                 mmdrop(mm);
> > > > +       } else if (hpage_collapse_test_disable(mm)) {
> > > > +               hash_del(&slot->hash);
> > > > +               list_del(&slot->mm_node);
> > > > +               mm_flags_clear(MMF_VM_HUGEPAGE, mm);
> > > > +               mm_slot_free(mm_slot_cache, mm_slot);
> > > >         }
> > > >  }
> > > >
> > > > Specifically, if MMF_DISABLE_THP is set, we should remove it from
> > > > mm_slot to prevent unnecessary khugepaged processing.
> > >
> > > Ohhh interesting, perhaps send as separate patch?
> >
> > sure, I will send it separately.
>
> Thanks!
>
> >
> > --
> > Regards
> > Yafang
>
> And overall - cheers for being an ABSOLUTE DELIGHT on review :) it's much
> appreciated. I shall buy you a beer (or whatever is your preferred
> beverage) at the next conference we are both at :)

Honestly, that's exactly what I wanted to say to you too! I learned so
much during your review process, and I owe you a beer (or your drink
of choice) as well!

--=20
Regards
Yafang

