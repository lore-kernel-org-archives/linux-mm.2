Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EA2AAD2F35E
	for <linux-mm@archiver.kernel.org>; Tue, 13 Jan 2026 19:02:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5A3566B0089; Tue, 13 Jan 2026 14:02:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 578206B008C; Tue, 13 Jan 2026 14:02:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 47A106B0092; Tue, 13 Jan 2026 14:02:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 392876B0089
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 14:02:34 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E4ECCC059F
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 19:02:33 +0000 (UTC)
X-FDA: 84327861786.17.5990EB7
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	by imf27.hostedemail.com (Postfix) with ESMTP id 0467840015
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 19:02:31 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=b0qycn2U;
	spf=pass (imf27.hostedemail.com: domain of aliceryhl@google.com designates 209.85.128.45 as permitted sender) smtp.mailfrom=aliceryhl@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768330952; a=rsa-sha256;
	cv=none;
	b=Tj3qEtkPnSL07agYNNhfDkgb7JTTXMhRDg5Ccz8MkKzwj3Fte0VashiB1C2oB7GjKmCYa1
	M1sGIvUw6Po9hKKResnq/7agcjEyf/7wD95geet/rBoypKynWODxlI8pg5Uk3EPd8yjoCy
	QFIsj1JLPkpyP0KuWM1rIJKJ61upZes=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=b0qycn2U;
	spf=pass (imf27.hostedemail.com: domain of aliceryhl@google.com designates 209.85.128.45 as permitted sender) smtp.mailfrom=aliceryhl@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768330952;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZIS8Bi5jNE2DkmmZ5WwRSmIsst4XTLDDwGlWPY82bXM=;
	b=l4p7mC/DNq6X413q/BuXuK9+7Hl+XKEoDm15FCwwcYSEUN6opW2+sIoSaHPPRuU1AqZ/BL
	cY6rjoAratBRpsDD4EstvbULbLdiy3/maub0KHv58U7gJK0sqGCzyOB+7tWhuiy+trCw2e
	F3XAX/k+F6MVKVnGLTWL354igo4+8nw=
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-47774d3536dso1376605e9.0
        for <linux-mm@kvack.org>; Tue, 13 Jan 2026 11:02:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768330950; x=1768935750; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZIS8Bi5jNE2DkmmZ5WwRSmIsst4XTLDDwGlWPY82bXM=;
        b=b0qycn2U3c8L2c5Nurvm0wN4sfakLdGCVo3/pRWFtq30Iu98x/PNpkhWzLffoL81qD
         MVQJKKVKzyS8v3I0nbl2RSTxqNXLgl6BO3LR7JPrLwWFH0xgBcnR1ZQzc4DKftRxJk4z
         Ozx6cYJA/SDeIDjeBd/pA9mqmGru3uJeFpdoi0ePlASq3j1uw1ezkpf20zuhvMEVaujr
         NJHBaf9QAV6BazH3AXmcZqXSafaW8UujPp1Tw+juBoPFJOu92fVFG6I3FEbLsZpPkL0S
         0LtkrbRFyW8TtLH22lGVuBTx2qFTkToK7ZDqeqM2mRQ//iQi7XZLQNbrnjNe1YE62WMB
         4koA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768330950; x=1768935750;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ZIS8Bi5jNE2DkmmZ5WwRSmIsst4XTLDDwGlWPY82bXM=;
        b=HqhXGXOBgs72WrwMKvZH5TotkOb5IkhPewUu6nJm8fClMexr9Pb6r7TMdERmEFeIde
         HmyL0L7qL2VRrZZ24mPPPR5Qez20acZjVfSsYHhUl6F7cFTirFu7aCxAVEy7Du8MtunV
         X3z3g/AqWVFNqYRikUxH3FqDEXYBz4wQtejTlkPEXITbpg6euFvVqmKjrnmhblNUFfUk
         kzZX5q/Bgm1eaMePCOpwP92e6Iv6WnWjSkaowl6VAujfaPcHkouunDPdHnIcekacmqg2
         NQMRmhFyTMd3AcMwUEqfNhlTuSQ0ezh3FMeyqQaGa0fIuM691jDUHrbYwM8dzEfmjG/1
         qq0A==
X-Forwarded-Encrypted: i=1; AJvYcCVNv7SvwH7DNFJ0/y1362uFKg6QpPtsccTCVN8/eQK5ZySkbNDOaoDN/pbMaCuYGPzWgW9hSPfULg==@kvack.org
X-Gm-Message-State: AOJu0YxVkAtj2+my47GE/1TZ3/Bl+VeOyZfjMN1N8QExkCdtbDkZddmE
	CClBWI4skvNMNq+aZxYymjiZnLAnVTRtY/hO+2OUHVS1007wI2JLOL1cQ+urKo5Bm35fcLBzy8E
	s4oV8jtI8LqOQv+cHy6Oa1O80YBgC/mLZpjEpnNwD
X-Gm-Gg: AY/fxX4Pwj52rNpAdMQ+/b6Sggeb9Iw1U120U1t+tui1Q7P4LWzSnJjXgTFrCuyQ680
	1mUWH1WSv7XyriRmip/uP5eicfDGUm0+h0MDUfgt2MWQzaJt+FVxPq8HKsQEsJ8FTT38+2aGgCR
	9RCFSlmefHpZHCghoa4Qlsg5cEMt+jrmA7svhmNsf6NrCOC6nJzzDEd2QOB02pRcNenZE+knqZU
	RtLixgM0LbUCZhNFKitNBi4CVTfR7S1vcQa54RHNNrX7PD0TNFaSsU5gSAFNMgxs0g4VgU5YN+P
	Jz46tkfFDlTu1+I0P4odEX3AdA==
X-Received: by 2002:a05:600c:3d96:b0:46e:59bd:f7e2 with SMTP id
 5b1f17b1804b1-47ee37a442fmr654855e9.11.1768330950087; Tue, 13 Jan 2026
 11:02:30 -0800 (PST)
MIME-Version: 1.0
References: <3a35e5a0bcfa00e84af24cbafc0653e74deda64a.1764064556.git.lorenzo.stoakes@oracle.com>
 <20260113185142.254821-1-clm@meta.com>
In-Reply-To: <20260113185142.254821-1-clm@meta.com>
From: Alice Ryhl <aliceryhl@google.com>
Date: Tue, 13 Jan 2026 20:02:17 +0100
X-Gm-Features: AZwV_QinHrnB7GFUH7LdFq-Z9yTmo4373JOvDPLiYEMAAKIw7pSmxnIv0pV5FbQ
Message-ID: <CAH5fLgidETM3aSVvLRxnA4oaaYWH_KN+qGMkQQf_GpWsjHkpXw@mail.gmail.com>
Subject: Re: [PATCH v3 1/4] mm: declare VMA flags by bit
To: Chris Mason <clm@meta.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Andrew Morton <akpm@linux-foundation.org>, 
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
X-Stat-Signature: p6s6sdo6tu39637enhxp85uo5rjkymcw
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 0467840015
X-Rspam-User: 
X-HE-Tag: 1768330951-510512
X-HE-Meta: U2FsdGVkX1+UhfNacJ/5wzVqt0anSI6h4l/a26KNKBkt6F8TZsJ5FsqhCayo676JTW6Otu69FIavR8HeoyWZ0WWq9XFs+56Wgipuy0Ay0h+oh8Ai8I8p4IupRJ1/0zibY7Nq6JfHIMoWjLGHZHcs73Kv2WrK1qjGtzNJmJ2zNRX3oYWNAs1Izl9jSYSgpTS5pmlPHK1xnREGOaz3/QMEOkXhwkQsRyEt7uI/ZzpT3z8okMMMW6j4T4Bi1FcYycDkCpQgGk2WvojXNlEFrnky1HL9WDyREkssbbM4Hs6LyRhn/yapZNExt+2I6g/JMoVpmkDckd0IururrdmaEXgz8kj8lULGGG7YbLvfV9b4pnIeEv4DNXe/gHdqGTlAUNa+HZ/klbUGm3Osla7B5bglq4b8eL6w/SOsrtnK6znKf/0wWijB9ogoQKQHOawq8M4axLrhaQ3BLXZXLntUbqxzcTUHMwX4aoDFDxBInzfz5STr8bX1HBjZDSoGiOXtUvT74tzB0kVhTifUuZ7x5CfiSOO5XvemK7bLhRLSexL3Qx8vT4WjOGVCbcWur/lq0SVnati5s2QSAQf7b+A5bhRjq03divT9EOCvrlxg+zQK9nv6ERrcqx2XqsY2mv6ugfnbkxp9USyl2ORJTy6ghTvQiKdA5uXbijabtV626M0HJaeZ6GAtKVvg7poPoOAJLkDQbI/+ZupCVFBwSUU0Gzg5BrbMLUdYRXkiJJXtOMH7EGpD1bwbTUQH9orHYo977cPhotmqC8IVl9p5uGekJQfcitP0IF6aAHgWLmU4pggrm4u20z7u1x6mKLrzjvHXvm2LBA07mm7gZo+CtZfw207QCXpcbwo0tb2bfNXMTbV49ScuBR0W/DA8yye9X//nRx2oG9UtCFUjKGw/91NXfjBKVIQCTGFpUEzvtwxv1UfELIxanqvJNRF5uF6mc9H2v08eCW5gptUKj3QGB6G+KIQ
 7UGj9q8S
 N44LR
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jan 13, 2026 at 7:52=E2=80=AFPM Chris Mason <clm@meta.com> wrote:
>
> On Tue, 25 Nov 2025 10:00:59 +0000 Lorenzo Stoakes <lorenzo.stoakes@oracl=
e.com> wrote:
>
> [ ... ]
> >
> > Finally, we update the rust binding helper as now it cannot auto-detect=
 the
> > flags at all.
> >
>
> I did a run of all the MM commits from 6.18 to today's linus, and this on=
e
> had a copy/paste error.   I'd normally just send a patch for this, but in
> terms of showing the review output:
>
> > diff --git a/rust/bindings/bindings_helper.h b/rust/bindings/bindings_h=
elper.h
> > index 2e43c66635a2c..4c327db01ca03 100644
> > --- a/rust/bindings/bindings_helper.h
> > +++ b/rust/bindings/bindings_helper.h
> > @@ -108,7 +108,32 @@ const xa_mark_t RUST_CONST_HELPER_XA_PRESENT =3D X=
A_PRESENT;
>
> [ ... ]
>
> > +const vm_flags_t RUST_CONST_HELPER_VM_MAYREAD =3D VM_MAYREAD;
> > +const vm_flags_t RUST_CONST_HELPER_VM_MAYWRITE =3D VM_MAYWRITE;
> > +const vm_flags_t RUST_CONST_HELPER_VM_MAYEXEC =3D VM_MAYEXEC;
> > +const vm_flags_t RUST_CONST_HELPER_VM_MAYSHARE =3D VM_MAYEXEC;
>                                                    ^^^^^^^^^^
>
> Should this be VM_MAYSHARE instead of VM_MAYEXEC? This appears to be a
> copy-paste error that would cause Rust code using VmFlags::MAYSHARE to
> get bit 6 (VM_MAYEXEC) instead of bit 7 (VM_MAYSHARE).
>
> The pattern of the preceding lines shows each constant should reference
> its matching flag:
>
>     RUST_CONST_HELPER_VM_MAYREAD  =3D VM_MAYREAD
>     RUST_CONST_HELPER_VM_MAYWRITE =3D VM_MAYWRITE
>     RUST_CONST_HELPER_VM_MAYEXEC  =3D VM_MAYEXEC
>     RUST_CONST_HELPER_VM_MAYSHARE =3D VM_MAYSHARE  <- expected
>
> > +const vm_flags_t RUST_CONST_HELPER_VM_PFNMAP =3D VM_PFNMAP;

Uh, good catch. Do you want to send a fix patch?

Alice

