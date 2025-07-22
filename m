Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9463C83F27
	for <linux-mm@archiver.kernel.org>; Tue, 22 Jul 2025 11:47:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 522B76B00A8; Tue, 22 Jul 2025 07:47:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4FA4E6B00A9; Tue, 22 Jul 2025 07:47:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 436DC6B00AA; Tue, 22 Jul 2025 07:47:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 347CB6B00A8
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 07:47:37 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E760F1A0337
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 11:47:36 +0000 (UTC)
X-FDA: 83691725712.19.658737C
Received: from mail-qt1-f178.google.com (mail-qt1-f178.google.com [209.85.160.178])
	by imf20.hostedemail.com (Postfix) with ESMTP id 1B1661C0015
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 11:47:34 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=eZBG5EzQ;
	spf=pass (imf20.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.160.178 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753184855; a=rsa-sha256;
	cv=none;
	b=sEapgadva7wngo7FxxBy03RkERAmTQlh1WoZKXMmZM6L6+q4dgWoOQdS2izd8C0CQYV822
	+gAkmVEkrbNnV86rdCIm8j9NsNKvVKXwoSW4casgrfcr/i2ELQoZdDLOcZ+11bkQquLkis
	jgVYFLCN+sx4hES6bADAkitvFPYsg5o=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=eZBG5EzQ;
	spf=pass (imf20.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.160.178 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753184855;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vHMdnk+Wpd6f3kSGFKIIMTs7gzct/9V5bz3hnN7QYxg=;
	b=c055KsfxfAHFkf9Tv1w61pF1qlLnrEFhuDoVnGRrZmr5kD4zKWSYE+wkgsoVW+JBN66PB7
	1aA4ecuuv1jVwhPVtzOhzUN2jFolWtOSpn9iFvq1+jsgREk0bY4Lntm1koKjgGBn5pvOPK
	BuLTC29DW5rHVtagILHDQcOO+f/1fuA=
Received: by mail-qt1-f178.google.com with SMTP id d75a77b69052e-4ab61ecc1e8so40077511cf.1
        for <linux-mm@kvack.org>; Tue, 22 Jul 2025 04:47:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1753184854; x=1753789654; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vHMdnk+Wpd6f3kSGFKIIMTs7gzct/9V5bz3hnN7QYxg=;
        b=eZBG5EzQ+v+qvjlzG/oRgABMqUxvXeq9KTGxvGaEhzknm9d/BUuTGVS3vMhUWZBbCL
         a5ofqgrrsHcb9D9xWl6lRoVN2YV89m/ToIVsqhWae+QWxyVa9wqZ4Yml1ddwfoMgKEM0
         hTVKxYp4nxSunRpP3mu0hbFDwlCk/wznImGYidNCXPoHznU5rHyEi+lWlffvCEIRnTEw
         Qp4xi8BAyX8wphoegL3BvolNrNEvyI088SHL1vViVCuGF6O28+SOcSWtfGmI66f5WlGc
         I/6VpFr5baN89+tzQAMpXlQRwxBTmgpGadLKO+hGCITVQTqwdc/9k0ZwNWQ7lRKN/wgu
         ymGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753184854; x=1753789654;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vHMdnk+Wpd6f3kSGFKIIMTs7gzct/9V5bz3hnN7QYxg=;
        b=bPUV3xcHoxwUgJ/BKzLtopHaJCOxKobFfUmMLN9/aQAhqjWdDb+xsd0JJlGwZhVohv
         WIS9AsLvXXMp9Ye9lwjrc7m+L5h5WfT79U18AZppCynG9FBy48Oxr9IKepiwXrdbVcGi
         fUsDEctSMHO3YzwUTjBLOyC+lNyqwxJs2iLeJr0+L1PvdXhwbEI012j0e4fjtU5QvQvu
         PV2P3SFI/oI5oOS/2Q/LpubSP1DeXpOKqkNyoa9QqnSyjkskPfcLumlN6+TDLiFQFKpW
         nICb+OiEuSIFbCZzEBkVXzjBqJAJgtcUghGq+8JeZcMoIynuA0YkPipm0jCPUbMWUJ1W
         nmEA==
X-Forwarded-Encrypted: i=1; AJvYcCU0dJoSyaGvff8KVunPqiTnERYtMwiSY20VoRGF9kngOxfWNYQ1/N4x35kD1nzTzwsFIqSHxmyhKA==@kvack.org
X-Gm-Message-State: AOJu0YxE/1yZGV7pJg99N2lZjr2Lap9JcQ/mWCgCfcsaxI55nQYrdFfy
	hyIXzlOzyNpdSY3gpRJyWQYyyi4ZpucRIrTVetn0NC7aOz4ucqret11s1bEn1Nd+DhOX1bqBqqU
	Wluw8bajQy+19kMlH2fCzTn2RjaZEZqk=
X-Gm-Gg: ASbGncv+YONd3p2bnCJOGvAzQex5pWBjmDoR/H8eep+i51EFTLPAqsEocUAeg20B0+p
	P9fHn5v/R+vl2F2R1RheFBGT7Br4tZ/Ko796hqlS5eQMzm93rX5yvVMdP3gMzD1X+6JeqyQ5LHr
	kKYn2ojxs6lrhfn68WLsBtb0YD759Cvt9CpGjei4ztMOLa3VqrBjwroKUraTMZ8/HFJ3nsaRMXd
	mjBkM2d225JD5YNpy0=
X-Google-Smtp-Source: AGHT+IHMsfJpOeMbShkuBIEq7YspBbQUww6KaCi2GGNbFFrWA5JDg3RbIc56D8Yebt1J1J2lKqY2ZNgLOPy5QC3Dtzg=
X-Received: by 2002:a05:6214:248f:b0:700:c179:f57c with SMTP id
 6a1803df08f44-704f6aebc0cmr396330066d6.38.1753184853948; Tue, 22 Jul 2025
 04:47:33 -0700 (PDT)
MIME-Version: 1.0
References: <20250608073516.22415-1-laoar.shao@gmail.com> <b2fc85fb-1c7b-40ab-922b-9351114aa994@redhat.com>
 <CALOAHbD2-f5CRXJy6wpXuCC5P9gqqsbVbjBzgAF4e+PqWv0xNg@mail.gmail.com>
 <9bc57721-5287-416c-aa30-46932d605f63@redhat.com> <CALOAHbBoZpAartkb-HEwxJZ90Zgn+u6G4fCC0_Wq-shKqnb6iQ@mail.gmail.com>
 <87a54cdb-1e13-4f6f-9603-14fb1210ae8a@redhat.com> <CALOAHbA5NUHXPs+DbQWaKUfMeMWY3SLCxHWK_dda9K1Orqi=WA@mail.gmail.com>
 <404de270-6d00-4bb7-b84b-ae3b1be1dba8@redhat.com>
In-Reply-To: <404de270-6d00-4bb7-b84b-ae3b1be1dba8@redhat.com>
From: Yafang Shao <laoar.shao@gmail.com>
Date: Tue, 22 Jul 2025 19:46:57 +0800
X-Gm-Features: Ac12FXxSR7-gHde2KyZLRLKo9WLpXSMnnby4hUqghVR5k92W9pAaQcWWQqjIMEY
Message-ID: <CALOAHbDMxVe6Q1iadqDnxrXaMbh8OG7rFTg0G7R8nP+BKZ9v6g@mail.gmail.com>
Subject: Re: [RFC PATCH v3 0/5] mm, bpf: BPF based THP adjustment
To: David Hildenbrand <david@redhat.com>
Cc: Alexei Starovoitov <alexei.starovoitov@gmail.com>, Matthew Wilcox <willy@infradead.org>, 
	akpm@linux-foundation.org, ziy@nvidia.com, baolin.wang@linux.alibaba.com, 
	lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, npache@redhat.com, 
	ryan.roberts@arm.com, dev.jain@arm.com, hannes@cmpxchg.org, 
	usamaarif642@gmail.com, gutierrez.asier@huawei-partners.com, ast@kernel.org, 
	daniel@iogearbox.net, andrii@kernel.org, bpf@vger.kernel.org, 
	linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 1B1661C0015
X-Stat-Signature: 3p5aaco4jgibegu7zwh3ge1c3hpy164a
X-HE-Tag: 1753184854-44232
X-HE-Meta: U2FsdGVkX191shXAI9BcnhgQPXUOeEyj6ZLesRZo41hMBVaojvQyM2dSqqS4AGMNm1d+DK5ZF4k4mIdWZxmBIejD1IF8R4MW6uvcKDrYAi55rcMJLnmtcU3Z0zM+Nk2jcF3zSB9cXJ/6VUW+nwD1J44o2ZxTYuUgxnVCPlCZwrol1JkYWFzkzLQAJ4nMCV30CLsbf0tFjUgwCRJAvA8DRd2aM9sR5sEwd9+cHYsgY4LnxTSViGFVgyium2Wz83d1cS0Df7uD6E7W+HK8eheIzGYXJvz2YLZHpiv/CrpCi5aM3erQRs4wyfwVyPO17e79Z9b9j1YmpfoOq/fFv7/6EAI7wYktd/XPvf6WcSufCv1PojNijFSbPR+YQ7TbK4A8qg98f61azVy1J/2+w97eneUsMsZU8tjpjWLkhtuT4S5AR7uDtENkYfbRnYnEmKRWSVdKmjtE4ybus5oVVmrObPfiobOIIga5IkA0E/e7wcH3WQhOIPBBSH/sS7Y4rfyRuBV77FLGhnn9P+1LCStaquwD/3+8a+HqP7Azre/CtEq7O94QPKtIA0XSUiW9V6hnHlUmA6FNMgNvq6DYnbT6/G/8rWnQWnj481owzcAasqM/5UOF2F2HXKDgxxkHerQJuKHhEuFbYkN8lvzqNScf76UOzYbp/5hsRtDyvC49KLCk09fptQEYP3+tJ8AAANboNj9sWl84DSpkiogN5xo5C9UtfXQCQQWjsvgRKxO45BeOPsuKvsIGNBR6t13hMaov8gUpMUUhYsmWXoWzZGFLIPCsSUzRchbhMpbULUcDSQj0Cd4FrfdOOE/p2KEH39Wsq+cAeQmgCnYfI4kDtISm6lHt40DGDHtAETFvjxR9cHH0iu9gVd3VrRXL6NB7TzS88JS1ISyvezReqzxxHg71nZsthaqu9c+Ltsa+xRSV/l8lvQu39f/VxCOJzETkxmsCagzRQP07BBQiOOXzGqy
 ltw5Jd84
 eqsz6WAWVlqbexQ1CQ2RLKMveShNDl5HyvRSX69AtDhBZg2hT27KwHpikyVmfdEOp9U7rjjP+9J1OMcMxZVk0lsl076dnmQHr5SOqMNmOvlx3Hc+3ydY+WqOY6dFhXWTY5QJfDfCXxt42IG/ITM5QdBTHsERY7JS+rXm9QewdP3vbzr2+HcKKhFQRRu7YRV6aA6QZw3nNGPIGl95E1VWZMszeyngNja+mMrRlzVVGtKpMLZRfTzyOoaIBjusqlXUn5fPjZC0AGM1R64QcrKpuE4c7mNHYYDjrKMmmb/r87CERgQjmloQ41p12PDD6C3J8cIqgGwPY3WXz9A2GBPHDnugoX9tAYPx4qjEgTF/UlogpcoZxQhJeCKvvtfVkgmE23sb7srd6lkytPZLdf5xgl1OwpU7+04zYh5YhA4UD0d1LcwuxKyvMoW6WWfrDuokoYmo/Rhaz8GUEl8FnO9IhlWyd0YTsbM5HiTFR9gNpqP3D606eC/bUic2yQYrKFjEQur8bz5q6P3FiQQvlg52YwSMrnw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 22, 2025 at 3:28=E2=80=AFPM David Hildenbrand <david@redhat.com=
> wrote:
>
> On 22.07.25 04:40, Yafang Shao wrote:
> > On Sun, Jul 20, 2025 at 11:56=E2=80=AFPM David Hildenbrand <david@redha=
t.com> wrote:
> >>
> >>>>
> >>>> We discussed this yesterday at a THP upstream meeting, and what we
> >>>> should look into is:
> >>>>
> >>>> (1) Having a callback like
> >>>>
> >>>> unsigned int (*get_suggested_order)(.., bool in_pagefault);
> >>>
> >>> This interface meets our needs precisely, enabling allocation orders
> >>> of either 0 or 9 as required by our workloads.
> >>>
> >>>>
> >>>> Where we can provide some information about the fault (vma
> >>>> size/flags/anon_name), and whether we are in the page fault (or in
> >>>> khugepaged).
> >>>>
> >>>> Maybe we want a bitmap of orders to try (fallback), not sure yet.
> >>>>
> >>>> (2) Having some way to tag these callbacks as "this is absolutely
> >>>> unstable for now and can be changed as we please.".
> >>>
> >>> BPF has already helped us complete this, so we don=E2=80=99t need to =
implement
> >>> this restriction.
> >>> Note that all BPF kfuncs (including struct_ops) are currently unstabl=
e
> >>> and may change in the future.
> >>   > > Alexei, could you confirm this understanding?
> >>
> >> Every MM person I talked to about this was like "as soon as it's
> >> actively used out there (e.g., a distro supports it), there is no way
> >> you can easily change these callbacks ever again - it will just silent=
ly
> >> become stable."
> >>
> >> That is actually the biggest concern from the MM side: being stuck wit=
h
> >> an interface that was promised to be "unstable" but suddenly it's
> >> not-so-unstable anymore, and we have to support something that is very
> >> likely to be changed in the future.
> >>
> >> Which guarantees do we have in the regard?
> >>
> >> How can we make it clear to anybody using this specific interface that
> >> "if you depend on this being stable, you should learn how to read and
> >> you are to blame, not the MM people" ?
> >
> > As explained in the kernel document [0]:
> >
> > kfuncs provide a kernel <-> kernel API, and thus are not bound by any
> > of the strict stability restrictions associated with kernel <-> user
> > UAPIs. This means they can be thought of as similar to
> > EXPORT_SYMBOL_GPL, and can therefore be modified or removed by a
> > maintainer of the subsystem they=E2=80=99re defined in when it=E2=80=99=
s deemed
> > necessary.
> >
> > [0] https://docs.kernel.org/bpf/kfuncs.html#bpf-kfunc-lifecycle-expecta=
tions
> >
> > That said, users of BPF kfuncs should treat them as inherently
> > unstable and take responsibility for verifying their compatibility
> > when switching kernel versions. However, this does not imply that BPF
> > kfuncs can be modified arbitrarily.
> >
> > For widely adopted kfuncs that deliver substantial value, changes
> > should be made cautiously=E2=80=94preferably through backward-compatibl=
e
> > extensions to ensure continued functionality across new kernel
> > versions. Removal should only be considered in exceptional cases, such
> > as:
> > - Severe, unfixable issues within the kernel
> > - Maintenance burdens that block new features or critical improvements.
>
> And that is exactly what we are worried about.
>
> You don't know beforehand whether something will be "widely adopted".
>
> Even if there is the "A kfunc will never have any hard stability
> guarantees." in there.
>
> The concerning bit is:
>
> "kfuncs that are widely used or have been in the kernel for a long time
> will be more difficult to justify being changed or removed by a
> maintainer. "
>
> Just no. Not going to happen for the kfuncs we know upfront (like here)
> will stand in our way in the future at some point and *will* be changed
> one way or another.
>
>
> So for these kfuncs I want a clear way of expressing "whatever the
> kfuncs doc says, this here is completely unstable even if widely used"

This statement does not conflict with the BPF kfuncs documentation, as
it explicitly states:
"This means they can be thought of as similar to EXPORT_SYMBOL_GPL,
and can therefore be modified or removed by a maintainer of the
subsystem they're defined in when deemed necessary."

There is no question that subsystem maintainers have the authority to
remove kfuncs. However, the reason I raised the issue of removing
widely used kfuncs is to highlight the recommended practice:
- First mark the kfunc as KF_DEPRECATED.
- Remove it in the next development cycle.

While this is not a strict requirement=E2=80=94maintainers can remove kfunc=
s
immediately without deprecation=E2=80=94following this guideline helps avoi=
d
unnecessary disruptions for users.

--=20
Regards
Yafang

