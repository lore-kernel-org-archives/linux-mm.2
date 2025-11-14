Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EC4A4CE7B0E
	for <linux-mm@archiver.kernel.org>; Fri, 14 Nov 2025 14:08:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3CC518E0010; Fri, 14 Nov 2025 09:08:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3A4008E0002; Fri, 14 Nov 2025 09:08:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2BB038E0010; Fri, 14 Nov 2025 09:08:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 1AF7B8E0002
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 09:08:37 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D28A358C8B
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 14:08:36 +0000 (UTC)
X-FDA: 84109393032.04.8BA9833
Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	by imf28.hostedemail.com (Postfix) with ESMTP id E0499C0015
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 14:08:34 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=Lf48JFkm;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf28.hostedemail.com: domain of aliceryhl@google.com designates 209.85.221.54 as permitted sender) smtp.mailfrom=aliceryhl@google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763129315; a=rsa-sha256;
	cv=none;
	b=1wMb5g1CyZ8hNKKysIAbHnwOajYvDWmvIfW8qlYNkebd8MMy7+nOzHdMuDVyEZrXjD17aN
	AtypIiDr4gI1beNq/2ogqEmw5V4fIuQRbusrXVAuKUb0QEUjLOlN+s+KrJtBHgT7GQg9jU
	j0nDYHD5ndAzQF9LBdy78PYOeaZTDc4=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=Lf48JFkm;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf28.hostedemail.com: domain of aliceryhl@google.com designates 209.85.221.54 as permitted sender) smtp.mailfrom=aliceryhl@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763129315;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1IXxo8d8j8VJ21Y+Lzck+HpFvoDGSHFT7itc7J4IXHQ=;
	b=RNPYU7crYzytq6rxIpYJHzr6/d2f4ALRV8pVZZZLe3ELDXuxo/wpAJmObHPE5bEuyYWA61
	6t0M8JRxVWbUcGcHLjHQmXKQSk9IAnFw/88Q1pInFSqDB1c6BMuw/XuEUIgtyZR6p7iJb7
	8NDvYddDvwi+7D7daGpLzXUFXgHwD7s=
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-42b3d4d9ca6so1777117f8f.2
        for <linux-mm@kvack.org>; Fri, 14 Nov 2025 06:08:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763129313; x=1763734113; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1IXxo8d8j8VJ21Y+Lzck+HpFvoDGSHFT7itc7J4IXHQ=;
        b=Lf48JFkmv+UtXfLZUP5oC947vsGiYNaHeaObnFP2tvGQKiIYVOzu629Wpp4WnJafJs
         662IVY+15PadouT0xIOPcAKZJezIX2M4cVZcp+z2RpVrIU2UAgl395tq4vG4kY0Px8ZK
         4em7BD9HbMcGXveQ9euVK6D1oBy4x0WD+HXgviss+IGXhGaiC05nKjhboZenyzggNb3J
         1RHyCfSiZlB1u+IBZU3ocBTHUtHXXpuL2YZhLDlimXgdszKT4pJXtLrnkXiOuQVyC9iQ
         f8HuvN5MfxrERv3ZmBKoWKjtJoy56QHVjTLnIV6/x4ygcGpMzpadN3CGyUNZTJe6N7+1
         bdxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763129313; x=1763734113;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=1IXxo8d8j8VJ21Y+Lzck+HpFvoDGSHFT7itc7J4IXHQ=;
        b=uCMCKHMplax70hUSoHb9AO69nyY/2DoVNSG7yBhs2vGdQGE3DjdJAtYMRFYBBQNRsr
         ++Him9ZSl/gxD1zkHQxpDzJtiGYm8EEYANDUO2qgtBDElzmE+XEWZC0oNdkYOG2KBaIN
         Ak8IWfOfw0T4hjyMsUruJtLrgtSdATM+AJwPzQbLu421Ony1qovyjnogjzfRE4oxKWwO
         CyTa4pwS1W3Zn0pyAVlmwLmPDHl52Xl+NtKeZsd4gaVr5f710SUL/vm2OFE9bQFllp8L
         6rhWX3y6LHllq+DSXKrtOQSGTd3LbQJYN0n9tzKJpOWTn3Nd/3X6a4/LNTfw9NrLR+CA
         4s0g==
X-Forwarded-Encrypted: i=1; AJvYcCUIbYucFRZQ+U4YCweT1uBHHY2ess33jICYp7m/NZv0+jxzpsoja+hi2Kg49OURw6dyoUB3Qtmf/Q==@kvack.org
X-Gm-Message-State: AOJu0YwuEFS6jGxqOQ/rkhM5WUFrMcWCWGtOnY7ddYToYZDY5HHiBoNO
	N1Ly1ZxRi2m0VVDc8tENfEZ2+8XMMujQNr7wKquTCfswgr/h84jMErb0rc5ZyvxCLoiNv4YsCrW
	9rHUeq7qPM+lTBLvLkzvaRfq2W3aJPoNSUP4WWCRI
X-Gm-Gg: ASbGnctIlqhmsM5yGDzzqANZHLHVFk1sGy2KG8tm3ttb/s+gdaUb+FKmSHdoZICcNo1
	Pnr4fWnFeUPh0NTboLfLAoXoh6llOmVJjpcsL7WfkHut3xMDc/gz16vPGbl6yNzDUJk6T6jhW5R
	r6gjHaLW8vC+XpSu1xIKEGvnDF1ts3GtnqpvjmK5UdfHswlVPx5F+boN9EKlCJFVHD8KSDyxgKB
	exMaEZpP0HSQl3oR6+4kjB0Nwh0YMRQTUg5478ZuTZQ37yuYQfSbOZStbEUHSpU611wDjY8CQc0
	WWbR4ZW9/uIqtICWLDn6TRc0iQ==
X-Google-Smtp-Source: AGHT+IG4uRI0PEq0NpCoNDKGJg8OF/SBz8TfroxjeXZLoJ/rlBcIJ1dSo30wyhO9fuhyg8jXgMGwvEzpXnS5vWaUElc=
X-Received: by 2002:a05:6000:2dc9:b0:42b:3131:5436 with SMTP id
 ffacd0b85a97d-42b5934140fmr3150253f8f.16.1763129312876; Fri, 14 Nov 2025
 06:08:32 -0800 (PST)
MIME-Version: 1.0
References: <cover.1763126447.git.lorenzo.stoakes@oracle.com>
 <6289d60b6731ea7a111c87c87fb8486881151c25.1763126447.git.lorenzo.stoakes@oracle.com>
 <aRcztRaDVyiDO7aH@google.com> <e98d913e-71bc-4b58-95ec-8ae054c43120@lucifer.local>
In-Reply-To: <e98d913e-71bc-4b58-95ec-8ae054c43120@lucifer.local>
From: Alice Ryhl <aliceryhl@google.com>
Date: Fri, 14 Nov 2025 15:08:21 +0100
X-Gm-Features: AWmQ_blLOyoFop_bk6_FefgrlF5VT0ZZlbzlSQ-G0fF4lbhgUPVCotLgW7GR15A
Message-ID: <CAH5fLghqBxnXv_3uir6hD7=J-Xs=i8B-B7++7J2vCMwZ-5+wyA@mail.gmail.com>
Subject: Re: [PATCH v2 1/4] mm: declare VMA flags by bit
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Muchun Song <muchun.song@linux.dev>, 
	Oscar Salvador <osalvador@suse.de>, David Hildenbrand <david@redhat.com>, 
	"Liam R . Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Peter Xu <peterx@redhat.com>, Ingo Molnar <mingo@redhat.com>, 
	Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>, 
	Vincent Guittot <vincent.guittot@linaro.org>, Dietmar Eggemann <dietmar.eggemann@arm.com>, 
	Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>, 
	Valentin Schneider <vschneid@redhat.com>, Kees Cook <kees@kernel.org>, 
	Matthew Wilcox <willy@infradead.org>, Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>, 
	Leon Romanovsky <leon@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <npache@redhat.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, Xu Xin <xu.xin16@zte.com.cn>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Jann Horn <jannh@google.com>, 
	Matthew Brost <matthew.brost@intel.com>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
	Rakie Kim <rakie.kim@sk.com>, Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>, 
	Pedro Falcato <pfalcato@suse.de>, Shakeel Butt <shakeel.butt@linux.dev>, 
	David Rientjes <rientjes@google.com>, Rik van Riel <riel@surriel.com>, Harry Yoo <harry.yoo@oracle.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Kairui Song <kasong@tencent.com>, 
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, Chris Li <chrisl@kernel.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Qi Zheng <zhengqi.arch@bytedance.com>, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-mm@kvack.org, Miguel Ojeda <ojeda@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	Bjorn Roy Baron <bjorn3_gh@protonmail.com>, Benno Lossin <lossin@kernel.org>, 
	Andreas Hindborg <a.hindborg@kernel.org>, Trevor Gross <tmgross@umich.edu>, 
	Danilo Krummrich <dakr@kernel.org>, rust-for-linux@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: E0499C0015
X-Stat-Signature: 9dkqw8st871drecyt9rqdzw8rmpurazf
X-Rspam-User: 
X-HE-Tag: 1763129314-843424
X-HE-Meta: U2FsdGVkX18yV/bxrAw0SyRybcnIdf/YmCchmns4K7xHQgTmP5buEqgN66mraRq1aUuCCnB4T0fZX8xjQ8mpM3GopOE8i2v1sRxkeTEuE/USO2XFa1gUigzUZ5p89A8HisHoF35QIvlL0e3g4WfDWXYYHOixu2oyPLdstexp1Fer384KQVqZFS0HKF7W10Vi2KhI7/M/JEjUc7vMb9dZbTJ3AZM2j6veLKa59HhZlJDBfVRmqAMdtzBsTFCQLSVqTiODfKNVb7P8t2o2Us2R0Wkmn2p3kRdvXqP2yuLjlyxUOsh4xd0JwFeZP9bk/s40jaa2mZOY+H0cwoDqCqzC8e5hQuY8rFaZY5niK1NOXpFVi6H/rDm8BMHtyiKRi9jZ9TXwWh1FXrwRH+mNSgPUBpnlAnWjk5G4XjcXwdRvm8QbFMR7KN/jv8AUrkV4kyHG+HN8x5pN1fdFI8a9Bxo//Ml9OcE1zJjR0gw6F+70Mn9eDXvrx6USQmEqKWkyANrkR2NN9+WHMCGwGr8hNAW7P6yxCmxpMpFfr33+B8eMBCtCf9EPpSck2Q3PRNPPjmDwyFnM7eKtiBCRp7a6jU0sHeEFurn4753Qry1cbPKEmVa11Pex4V1yexqPcP7cbpNMBnn6DNqUL7qHh2YpmVnmgU5R892IPasWl2x6lBe+JBS4r4gF57oDk9tlGhLyGPLzS8rPLTab/cQq3C1T6ls7dm4ztfLs2kEyJSQVIm0EG3hmqRjYwJTRKDpdJ4nnyTLEnBDPDQZmuq2I7PNh2YaCLY5dp9dnUwPVGgm1G9aRqPftrPnStfxCXOWMO0yd9tz+1fYefAH2f5BYKrlhJhpexlu540SbyuToP9ZXORhcHCcMJKreoobs0ChQxqI8JwUTiTsg7bH0srBmtqu2wtkxs1lXidw8qRXnSkC8Fg1eJHywV+ugkzRfMbwwG+LZ63ugwG9na8T2J94F20M42Lv
 vnp+4ItV
 p9C6UOT221oel214cYaSZ0/QToxOElddyRStr7ofwkz4X0YPXg9Am/+fWte1w+FlnOH7XneJDqeEHymE6jwi+ec64icBcOjfjX44wbBkdwKr5f4qZPUpCiyyKCuFLTtxK1an2tf8xONGP6uKX2o6Kzju6tjY4G9B1/eZwwvSZMeDJjl3t1K/bX31FMi3aGt/TpJOiz2AFn9e2+/1x6QOgSSNeRjtcMqhr1akCzxBKBURcxXdhs+k9zgnExQKJ4dwWYkPYu93HJVjWAtboqGNfSFo+ghf1ZmbEQw1A
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Nov 14, 2025 at 3:02=E2=80=AFPM Lorenzo Stoakes
<lorenzo.stoakes@oracle.com> wrote:
>
> On Fri, Nov 14, 2025 at 01:50:45PM +0000, Alice Ryhl wrote:
> > On Fri, Nov 14, 2025 at 01:26:08PM +0000, Lorenzo Stoakes wrote:
> > > diff --git a/rust/bindings/bindings_helper.h b/rust/bindings/bindings=
_helper.h
> > > index 2e43c66635a2..4c327db01ca0 100644
> > > --- a/rust/bindings/bindings_helper.h
> > > +++ b/rust/bindings/bindings_helper.h
> > > @@ -108,7 +108,32 @@ const xa_mark_t RUST_CONST_HELPER_XA_PRESENT =3D=
 XA_PRESENT;
> > >
> > >  const gfp_t RUST_CONST_HELPER_XA_FLAGS_ALLOC =3D XA_FLAGS_ALLOC;
> > >  const gfp_t RUST_CONST_HELPER_XA_FLAGS_ALLOC1 =3D XA_FLAGS_ALLOC1;
> > > +
> > >  const vm_flags_t RUST_CONST_HELPER_VM_MERGEABLE =3D VM_MERGEABLE;
> > > +const vm_flags_t RUST_CONST_HELPER_VM_READ =3D VM_READ;
> > > +const vm_flags_t RUST_CONST_HELPER_VM_WRITE =3D VM_WRITE;
> > > +const vm_flags_t RUST_CONST_HELPER_VM_EXEC =3D VM_EXEC;
> > > +const vm_flags_t RUST_CONST_HELPER_VM_SHARED =3D VM_SHARED;
> > > +const vm_flags_t RUST_CONST_HELPER_VM_MAYREAD =3D VM_MAYREAD;
> > > +const vm_flags_t RUST_CONST_HELPER_VM_MAYWRITE =3D VM_MAYWRITE;
> > > +const vm_flags_t RUST_CONST_HELPER_VM_MAYEXEC =3D VM_MAYEXEC;
> > > +const vm_flags_t RUST_CONST_HELPER_VM_MAYSHARE =3D VM_MAYEXEC;
> > > +const vm_flags_t RUST_CONST_HELPER_VM_PFNMAP =3D VM_PFNMAP;
> > > +const vm_flags_t RUST_CONST_HELPER_VM_IO =3D VM_IO;
> > > +const vm_flags_t RUST_CONST_HELPER_VM_DONTCOPY =3D VM_DONTCOPY;
> > > +const vm_flags_t RUST_CONST_HELPER_VM_DONTEXPAND =3D VM_DONTEXPAND;
> > > +const vm_flags_t RUST_CONST_HELPER_VM_LOCKONFAULT =3D VM_LOCKONFAULT=
;
> > > +const vm_flags_t RUST_CONST_HELPER_VM_ACCOUNT =3D VM_ACCOUNT;
> > > +const vm_flags_t RUST_CONST_HELPER_VM_NORESERVE =3D VM_NORESERVE;
> > > +const vm_flags_t RUST_CONST_HELPER_VM_HUGETLB =3D VM_HUGETLB;
> > > +const vm_flags_t RUST_CONST_HELPER_VM_SYNC =3D VM_SYNC;
> > > +const vm_flags_t RUST_CONST_HELPER_VM_ARCH_1 =3D VM_ARCH_1;
> > > +const vm_flags_t RUST_CONST_HELPER_VM_WIPEONFORK =3D VM_WIPEONFORK;
> > > +const vm_flags_t RUST_CONST_HELPER_VM_DONTDUMP =3D VM_DONTDUMP;
> > > +const vm_flags_t RUST_CONST_HELPER_VM_SOFTDIRTY =3D VM_SOFTDIRTY;
> > > +const vm_flags_t RUST_CONST_HELPER_VM_MIXEDMAP =3D VM_MIXEDMAP;
> > > +const vm_flags_t RUST_CONST_HELPER_VM_HUGEPAGE =3D VM_HUGEPAGE;
> > > +const vm_flags_t RUST_CONST_HELPER_VM_NOHUGEPAGE =3D VM_NOHUGEPAGE;
> >
> > I got this error:
> >
> > error[E0428]: the name `VM_SOFTDIRTY` is defined multiple times
> >       --> rust/bindings/bindings_generated.rs:115967:1
> >        |
> > 13440  | pub const VM_SOFTDIRTY: u32 =3D 0;
> >        | -------------------------------- previous definition of the va=
lue `VM_SOFTDIRTY` here
> > ...
> > 115967 | pub const VM_SOFTDIRTY: vm_flags_t =3D 0;
> >        | ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ `VM_SOFTDIRTY` redefin=
ed here
> >        |
> >        =3D note: `VM_SOFTDIRTY` must be defined only once in the value =
namespace of this module
> >
>
> That's odd, obviously I build tested this and didn't get the same error.
>
> Be good to know what config options to enable for testing for rust. I rep=
ro'd
> the previously reported issues, and new ones since I'm now declaring thes=
e
> values consistently using BIT().
>
> But in my build locally, no errors with LLVM=3D1 and CONFIG_RUST=3Dy.

I got this error because my config defines VM_SOFTDIRTY as VM_NONE,
which bindgen can resolve to zero. You probably have a config where
it's defined using a function-like macro, so bindgen did not generate
a duplicate for you.

> > Please add the constants in rust/bindgen_parameters next to
> > ARCH_KMALLOC_MINALIGN to avoid this error. This ensures that only the
> > version from bindings_helper.h is generated.
>
> As in
>
> --block-list-item <VM_blah> for every flag?

Yes.

Alice

