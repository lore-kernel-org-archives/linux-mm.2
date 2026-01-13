Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 86AC3D2F32D
	for <linux-mm@archiver.kernel.org>; Tue, 13 Jan 2026 19:31:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DA9D96B0089; Tue, 13 Jan 2026 14:31:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D57606B008A; Tue, 13 Jan 2026 14:31:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C63786B008C; Tue, 13 Jan 2026 14:31:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B614A6B0089
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 14:31:28 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 7C1BC160285
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 19:31:28 +0000 (UTC)
X-FDA: 84327934656.06.5690640
Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	by imf30.hostedemail.com (Postfix) with ESMTP id 6348180019
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 19:31:26 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=A8kOQcdy;
	spf=pass (imf30.hostedemail.com: domain of aliceryhl@google.com designates 209.85.221.41 as permitted sender) smtp.mailfrom=aliceryhl@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768332686;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=e8NmhJSqiWlvWOSbMuKunlzIFlo/O2hOznQMiuzwn84=;
	b=corqisM/7A89Br07Qyyy8kJWBboATnWRbdkFqJybjrEs9jSDDAXiUFTlqxbDzUrgs2L7ds
	h4w5BxJ3v/v/qSKgqYjMDTbF10NUqnaWY0JCghnd5DX2v6mdahiI5X9/mQWKHcmOgC98XS
	JDnd7mrxtQfyIw8WiHCFHxKp9qbZzVU=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=A8kOQcdy;
	spf=pass (imf30.hostedemail.com: domain of aliceryhl@google.com designates 209.85.221.41 as permitted sender) smtp.mailfrom=aliceryhl@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768332686; a=rsa-sha256;
	cv=none;
	b=we+LPWvEBQPEBvk2ZmMaTwDB3rnnhdsIFbOGr5+IdWT3LcBEwLvDC0zxPRXNr+UBbSm7fP
	Wk6jo2zQ/xIiEEOc01piwkrX0AitUQk5/TNgBC32ZEic4bfP7gmQ5RzZNtY5i3JSx9sV6m
	tGDidNkbbOsjOu2bZU+VU5+VsDLz+H0=
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-432d256c2e6so4294887f8f.3
        for <linux-mm@kvack.org>; Tue, 13 Jan 2026 11:31:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768332685; x=1768937485; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=e8NmhJSqiWlvWOSbMuKunlzIFlo/O2hOznQMiuzwn84=;
        b=A8kOQcdyawEZyLEaSDrPUyKAl/QUfPdjjUhBhVuPEA91/50wdJp5q5A/kdyT2l69tJ
         WiDPDI/nl/nZBeTbwmcyBCkwKOsySMiRdkKevFClvy5i3DFRNg5fmU7SoTlI5euO1qom
         4Ap2AYQbRvG7Mzbzce8LXkql8rE+yf8qRLY4GzhoQ26dG1s9Iju/EO7MVSaGmqYre1G4
         UzM7S49JkB3TkoTyKhzNaHlHmrZJ+8kWDZN863LHIVSlbg3kJmFM+6u187Qir4dCOraI
         R44cNiIlC6GWnR5KHkbmq+B8UV9a1SAcPP96lEOhBs2KRWDoLF4lo3TRqHtJXIHtB1cX
         ePWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768332685; x=1768937485;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=e8NmhJSqiWlvWOSbMuKunlzIFlo/O2hOznQMiuzwn84=;
        b=SouwIta02dFMjJBa7I+64jbN3m0LhbFTZ/UKWjZOus2IlaC+S/nO1Rq+KQ/SG9SiR+
         cuFNmBPs6c8x5bt/5+rjHhwmBP628FLy2ZmzFDvG/ZSU1EnGB/jy+CWuAdps7Lc3zqEW
         Mn8GjZwikO/OPWk7FW7nkLZY/+TKSCxx4Hbgp/1MlLgCGAZdvt/tkZy4Aq02G+gzgE0e
         dE3G0ehGjt2heR/rul2GlGqvYtPNUzItZ+xqAOpCdETwp8iQROLjmOZeKzV5vB0bTWg5
         FrvhysLsXOAmOpTr/KQiCi7j77uejsUuGDm5nZ302dAuMJZMZPCVi0MM2fzzwDxHvwj8
         FIWw==
X-Forwarded-Encrypted: i=1; AJvYcCWlZxc0US7syuhRCfUntLtyPD3DEPZkEANt/LXbYB8SAstlIMg3pWv9MilWjZSyvPYn4xiwXKYUJw==@kvack.org
X-Gm-Message-State: AOJu0Yzfp42wCK/Ko++PugDS2OEGfw9XCflapqu0fYJ28WuneILVWqXu
	/OiVAoAEZAb30Oi/y0VK6Zo7LYQW0jdGRgnB7kilDRWXS4PLbvGNd2GTJSH5PT/2VEPBK0dcTke
	bSYx+yYKFNNYCuw0NtFi+VXffXvypt3jfC0WS8K6N
X-Gm-Gg: AY/fxX5qOak12hvtSO4WDZgvJNSVWIO/nrA8FMavSF/IDGWiTC5LrtYSscQRvi18Wgx
	0n+hVh/JNTd/2lFsUtArfjuD4x2ZkWEXXHNWGN9oAHzbc6gOExNTtAoFTHvDn9cbJYcTx9L7lHE
	o9/pQMfOCis3SrDDfRvLhCAi5ten//g5X6UFt1wASNSeqy/Fy0RmxizarsF8fpzY8Pev8TyT1lJ
	Urj6TxtmLL4CvH2D7xI1c0r5K303zM4KeQ2eNP8iDYWacmi9k2HQi+ep8Pix42MSA7yqhO6pd2d
	f8/cXHD38d/QWoz+1kKwVST+rIDcfWYUKzmt
X-Received: by 2002:a05:6000:1843:b0:42f:bad7:af76 with SMTP id
 ffacd0b85a97d-4342c5011ecmr58277f8f.15.1768332684204; Tue, 13 Jan 2026
 11:31:24 -0800 (PST)
MIME-Version: 1.0
References: <3a35e5a0bcfa00e84af24cbafc0653e74deda64a.1764064556.git.lorenzo.stoakes@oracle.com>
 <20260113185142.254821-1-clm@meta.com> <CAH5fLgidETM3aSVvLRxnA4oaaYWH_KN+qGMkQQf_GpWsjHkpXw@mail.gmail.com>
 <070b76bf-0d18-450c-a1a1-29f3a8b4925a@lucifer.local>
In-Reply-To: <070b76bf-0d18-450c-a1a1-29f3a8b4925a@lucifer.local>
From: Alice Ryhl <aliceryhl@google.com>
Date: Tue, 13 Jan 2026 20:31:11 +0100
X-Gm-Features: AZwV_Qi6YpsOIS766x38_eMGva8u3MAQ2J7-LTNUdm_KuxBa4ITTN06VU3-8A0Y
Message-ID: <CAH5fLggUzj532WOuHjx0Uz97eiRVSpJ-xtCwiP6h1g_Rg3WoPQ@mail.gmail.com>
Subject: Re: [PATCH v3 1/4] mm: declare VMA flags by bit
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Chris Mason <clm@meta.com>, Andrew Morton <akpm@linux-foundation.org>, 
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
X-Stat-Signature: w94m1b7go3iw1ar9tujfw9rsgufogc33
X-Rspamd-Queue-Id: 6348180019
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1768332686-483254
X-HE-Meta: U2FsdGVkX18FycConDVOOVyGDGea4SQatbN2P5g+U6s/8lkehqlqzmAT250rGUfbaQL+wCb/eqbOopJxQl7UyeCwLnc9ym/8JtFaEetuxnx1kIHkB21biEGHIZvS0PjNns7W8pBOongMl/7XarrXzQpzp3Y/4iKg8zsrkWnfpF9ggtrvHOZBA66Cs4OzX/KEX2JjvmIIUyZp+AEBdhbSPRVp8aZNkKpRrJwPezAV71l62U5rWco/F2g1nvDU8jCHEhUEy7tgIb3RFQMdHKx8hVHyz7HFaJNYDxIDyjLnM1C/Ro7bexDz8yp4TJgRY2JGyhTCfB+KE/CvfsvJLiH5ccsUcHkZs9OSk0ieTifoHtHzItcp0swrqRnnG9fosukxojjTOeG8wYZyKEHPB87NWhNEtH/PKk3g0TryEmBMlDFNfMP3nvaKSsLs73R0FnUDXbUQFzVeD3bRUT9isr8sgtOV2t2qnYNHYsHq4tNyEyQ6HVDvnE9gFPreWcDuGEcMcjh8UsM65apjj7a13vtnD6g6tRl8jQxiq2uV6QnOepfIZHg3FPbQexINfiov/GNxCIjAkYR7D/BAIbH1/luN8L40a5R74gTk+4Hv22gGy3hokkxK0welHo1P/Ojm5rQyM/iwM5KBGkVhlNT1qRLOOqLAyOO3L/MarnYrVp15ASz+a0JzFKANbJ19nnrS/06NjRW3B6HZLlXV6PSUl3sDJtGCXxYFgZ0rZy5Yvz1QnFZGKBCWjtCC9AvWfjh94oVz0xQukRiIe4FFDM/MtmNksW8zbaJX5jGQGH6yhzBzQVt0hVgvDX8pLfJoGmGQiEQdTXzRiwbKF3sz9GzOuQ2B5Rydd1MpD9ajNbb/W74OLMus0tEwKJMR1FCkHPRyFfKpOiWwV+Ko2FUxzor1JpnAJZQcLghTkjAl/NLCIowPEikL+j4Exdv6P3ltZve5lmZvJybr5ptiHGyHwlFvd+Z
 KwR45FCX
 qQ9K59GJKmMx1XhtAXff8kRPgs6d4D7XMkvR5eQY6+8jmpIG45UdBXRz0lDH2blJ+CLH4mVNetdrmBY0hlbvCSMzjeNTQvqfeuXSGK9tY4I3muU8sQLQDfyChXgbXatZ0x2rKtlRyTJ4ZV/sfzv5UNkjlXcEfzgOR1r4cwvsRn8ZF2rqZWH4RsBGHi3to+4CNLx5ZuQOKxMZHkdJkES3CCOEQBhpfPGh3jWE0pYLNmkg1NRHCwiFKGJqmQhjf2VGgWPUFc9zI7xBYFxLaedWK/LqgDJl4GapKhjF2Q4X+vjQFboZFngtb+Ru6oQklzRwvj89YRYmkAx2IRlWmEgGBXY+5Ag==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jan 13, 2026 at 8:14=E2=80=AFPM Lorenzo Stoakes
<lorenzo.stoakes@oracle.com> wrote:
>
> On Tue, Jan 13, 2026 at 08:02:17PM +0100, Alice Ryhl wrote:
> > On Tue, Jan 13, 2026 at 7:52=E2=80=AFPM Chris Mason <clm@meta.com> wrot=
e:
> > >
> > > On Tue, 25 Nov 2025 10:00:59 +0000 Lorenzo Stoakes <lorenzo.stoakes@o=
racle.com> wrote:
> > >
> > > [ ... ]
> > > >
> > > > Finally, we update the rust binding helper as now it cannot auto-de=
tect the
> > > > flags at all.
> > > >
> > >
> > > I did a run of all the MM commits from 6.18 to today's linus, and thi=
s one
> > > had a copy/paste error.   I'd normally just send a patch for this, bu=
t in
> > > terms of showing the review output:
> > >
> > > > diff --git a/rust/bindings/bindings_helper.h b/rust/bindings/bindin=
gs_helper.h
> > > > index 2e43c66635a2c..4c327db01ca03 100644
> > > > --- a/rust/bindings/bindings_helper.h
> > > > +++ b/rust/bindings/bindings_helper.h
> > > > @@ -108,7 +108,32 @@ const xa_mark_t RUST_CONST_HELPER_XA_PRESENT =
=3D XA_PRESENT;
> > >
> > > [ ... ]
> > >
> > > > +const vm_flags_t RUST_CONST_HELPER_VM_MAYREAD =3D VM_MAYREAD;
> > > > +const vm_flags_t RUST_CONST_HELPER_VM_MAYWRITE =3D VM_MAYWRITE;
> > > > +const vm_flags_t RUST_CONST_HELPER_VM_MAYEXEC =3D VM_MAYEXEC;
> > > > +const vm_flags_t RUST_CONST_HELPER_VM_MAYSHARE =3D VM_MAYEXEC;
> > >                                                    ^^^^^^^^^^
> > >
> > > Should this be VM_MAYSHARE instead of VM_MAYEXEC? This appears to be =
a
> > > copy-paste error that would cause Rust code using VmFlags::MAYSHARE t=
o
> > > get bit 6 (VM_MAYEXEC) instead of bit 7 (VM_MAYSHARE).
> > >
> > > The pattern of the preceding lines shows each constant should referen=
ce
> > > its matching flag:
> > >
> > >     RUST_CONST_HELPER_VM_MAYREAD  =3D VM_MAYREAD
> > >     RUST_CONST_HELPER_VM_MAYWRITE =3D VM_MAYWRITE
> > >     RUST_CONST_HELPER_VM_MAYEXEC  =3D VM_MAYEXEC
> > >     RUST_CONST_HELPER_VM_MAYSHARE =3D VM_MAYSHARE  <- expected
> > >
> > > > +const vm_flags_t RUST_CONST_HELPER_VM_PFNMAP =3D VM_PFNMAP;
> >
> > Uh, good catch. Do you want to send a fix patch?
>
> It's in 6.18 so would need to be a Cc: stable patch with a Fixes etc. rat=
her
> than a fix-patch, unless that's what you meant?

That's what I meant, yeah.

Alice

