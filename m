Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 08E03CD4855
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 09:51:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 70F716B0096; Tue, 12 May 2026 05:51:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6E6D36B009B; Tue, 12 May 2026 05:51:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5FC8B6B009D; Tue, 12 May 2026 05:51:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 4D0746B0096
	for <linux-mm@kvack.org>; Tue, 12 May 2026 05:51:57 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 0FCED1C0308
	for <linux-mm@kvack.org>; Tue, 12 May 2026 09:51:57 +0000 (UTC)
X-FDA: 84758301474.21.DBEEF61
Received: from mail-dl1-f52.google.com (mail-dl1-f52.google.com [74.125.82.52])
	by imf10.hostedemail.com (Postfix) with ESMTP id 19AA1C000D
	for <linux-mm@kvack.org>; Tue, 12 May 2026 09:51:54 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=VaogugFK;
	spf=pass (imf10.hostedemail.com: domain of elver@google.com designates 74.125.82.52 as permitted sender) smtp.mailfrom=elver@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778579515;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+ec8Gp9KIgloqxfI4Ah9RgcAxU70GC5qHU2EuM04KDM=;
	b=XRURF8qSlUYMSXAt3wwvZvy02kPspIR3GrIlbwvczJI79xM2Hm3g/RzWgHxDEQmMrHoNbk
	LQCyr6XtqJ2iziABxuo1h8Ntffcka8anxLMVz7PJVVUEDBqlbsQdw1Jx99vwNup8wZY4R+
	AD/Hztp7pvOLolAZyXn6oQ3fqgW5Gs0=
ARC-Authentication-Results: i=2;
	imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=VaogugFK;
	spf=pass (imf10.hostedemail.com: domain of elver@google.com designates 74.125.82.52 as permitted sender) smtp.mailfrom=elver@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1778579515; a=rsa-sha256;
	cv=pass;
	b=0jvhrzM5ASi6dcuqvSRIBySLMuh5OzLS6hxF6A7UIxW2UrhdvWm/BmFaqTT7p8DoZJJ2PY
	q69zUExLtKRTR1MHK6qWGigezTAnXTguhVWGE1ocFSSkFFPocdzzyCnWymn1Vab49jpR19
	XIfqXMdlqVtGKcIA+K0xvBxjL7zd1Cw=
Received: by mail-dl1-f52.google.com with SMTP id a92af1059eb24-12ddbe104ccso4848512c88.0
        for <linux-mm@kvack.org>; Tue, 12 May 2026 02:51:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1778579514; cv=none;
        d=google.com; s=arc-20240605;
        b=XAZGFXqe3NSgLZ2QJMlEf0rVzlnFgCc2mr2OjMBwju1QEWuvvJa5jBtZD92B+C3G6E
         XYVPyA1q5fv5O5q8T1ZuHAdtVvLufsmLB3YQFs3yd+dq4k4fjP0iH93Q8vSzGPN4R251
         wAVBVoKCpPi6Y3yb/etReD8eLIzJW31Q8kaFIUgONdD+AnBbM06EUgMBgLV9eGprGeFA
         djoZKjuih6+92v3KlvvFHuiOkuMscTnDRCix92BgXlCMTvsUgkds5pKXmgWjhP0MDR+y
         KYKoki7l5/mKPhRTPwsGZAB8rChvE7AJ4m+QSqoYsSREWAAhE+WpRDvMwqV0QD4IX8JW
         yRhg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=+ec8Gp9KIgloqxfI4Ah9RgcAxU70GC5qHU2EuM04KDM=;
        fh=e3Ri2ZQqQo2zn0VPB86RHhnX/niEuOsNhUNtPpI0B8c=;
        b=kmIos2LSxMiiwt3cVk5EAZWcx9SrSPBNGuy4DaSMy0iu4QKer+FAF9wnGC9OB7TnY7
         1NdCBatAeX3EayDC+i9veRXT9mVcTvjjaQJXba4eGYcPVcs5idb8KJuoz/+g6eS4S5TB
         cCD6WN+HkahJGrclm+tPENAixqf++s1z2E00ecWiHpzMwmG1IwEvNeNGeFuDGJD78pif
         wnzZA/pabCe8m0cJEUsMaAXP/9JxGRR1UfCtNb7NMo0N5x8IasSiWtOegxdBNiPdEVYI
         2u78ymqj1jrykvwg8zM0jYD5i+mnekFY99JJgsN6kmNxuOSSoViTVBzhZRNszpHDs4W7
         CFqQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1778579514; x=1779184314; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=+ec8Gp9KIgloqxfI4Ah9RgcAxU70GC5qHU2EuM04KDM=;
        b=VaogugFKcuIKDhurkJWRB2kzhEjBUiwTM4F0TPMmPNoxm75GAdpKMXNps9gEKGaZs5
         qkwM7imIQBb1LtXjkSFEjpn1cnVEJz5yQhQWoKpYe2bpG9NQF1pmgN+pEt2rF+xtAyu2
         YjtmnE7sD9AEZUKH9A0kL4mioh4Xc/Zj6hqLnksw2VxlM1Dc6Bj6BHOrhoqVMxhBxb0x
         nz2o1foUBBnte7XPM+t68lLi2RZEfiPZho3PeHCL5jjUhHcC7Xn/yjhHR/AtkuvmWyhy
         84i5MzQ2sKD1gJ+EpPlbI6KGkPqXWSCFH6tVI8kEzbIL2nr2k5XJqwUhlW6ryQ1OYqHn
         cREA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778579514; x=1779184314;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+ec8Gp9KIgloqxfI4Ah9RgcAxU70GC5qHU2EuM04KDM=;
        b=sDuLq/hELCds+MfvUC1aBI9sG2XgUHiYoN/NOdK2v0deqyh55yunC7rwFMxyF9gSME
         7MouMq6osjQ9+hG27VXvVye7ACMzQ8umWUx3D+0cvXfvnEK5rzQCXJED3556IgRByapE
         Hxl8f3V5DztuW+B3n9znuBpkMPahx0g8xSsDPwUubimKOgt55JmLt2MZg8MbnQ2j/ems
         9f/BJ9jNJACf4K0fghvPFBswLSVnzudOvqSCgMwfMqOBuo6VnDJH5ToRwKFMK3eHMZr1
         8O9nhlD6H5Dj7yVjywDQuRytoPr/bsAfpXzcoBpQGw+jmjadpB4JID6DrxFc4htxf7WY
         LK9A==
X-Forwarded-Encrypted: i=1; AFNElJ9GlCH6uh1HdNWmOuscXJp17ZP/bkB9rkZwZ+VnL8Ibp2tSoOPtpcBMMRja/NskvHaw4mVio6kIzw==@kvack.org
X-Gm-Message-State: AOJu0YxqYuSVobDMwlJlDZJ5F6m14iaoYSsk7uCndDTj6MNZ5CD3LNLM
	DXwy6SDVqEPRNIwMg4aA1b9/ktxCAlv9B41aTKeWcakAhF9AdJGVFWRyCFK1KY9WnVXBzx6KJjx
	B8VpoJ7tPm9KuxVhyVup1P7iFiyY3M7abW4vXrk4h
X-Gm-Gg: Acq92OHSjoa5sP45navD98udufOMMPMYo6OMQ/hboydZiWZ/BWqFLQALxPxVP2BB+iA
	Dbgovvu+HvsKtcJP86iXZZ15YM70LbvMDFhBPrpHSx46sIuW7/gn8jZBaGDFAPFY6ZTjBv5G0vb
	QqM1UvPAdp5sxn7q/X2xxNET2SkGwH7OfmGD/kpwq34i4HOKLTVaqQHCzIkL8tiiysT8NHbfkuA
	hlavGPvrx4VqvYvs4P/Boyl0pxs41W40H2TDPeH4tbmkd+GCIuWcmJOHz1vvnaItvFAro7aMTYC
	ZVDtAP3aFTu3hLYKrjSjVJwKhLTIwZh7oXIOc53f0oLcTIYR
X-Received: by 2002:a05:7022:38c:b0:128:d20a:2f40 with SMTP id
 a92af1059eb24-13344c4307bmr1461470c88.8.1778579513098; Tue, 12 May 2026
 02:51:53 -0700 (PDT)
MIME-Version: 1.0
References: <20260511200136.3201646-1-elver@google.com> <20260511200136.3201646-2-elver@google.com>
 <3z5unwqxty4qq2siingxdijbk642te7kf26ba4ff2xsmyptgq5@i6bxrvkfbve4>
In-Reply-To: <3z5unwqxty4qq2siingxdijbk642te7kf26ba4ff2xsmyptgq5@i6bxrvkfbve4>
From: Marco Elver <elver@google.com>
Date: Tue, 12 May 2026 11:51:15 +0200
X-Gm-Features: AVHnY4J9rWhb6ZrnXllLEE_U0YQh3r6D8w8ra1G0CJOzHs8wrDs9DHipy-uAw-w
Message-ID: <CANpmjNN-rPHMOGxyfcAGiJKDdDixiB70uYOa0UVCs92QgMNGYQ@mail.gmail.com>
Subject: Re: [PATCH v4 2/3] slab: improve KMALLOC_PARTITION_RANDOM randomness
To: "Harry Yoo (Oracle)" <harry@kernel.org>
Cc: Vlastimil Babka <vbabka@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	"Gustavo A. R. Silva" <gustavoars@kernel.org>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Andrey Konovalov <andreyknvl@gmail.com>, Bill Wendling <morbo@google.com>, 
	David Hildenbrand <david@kernel.org>, David Rientjes <rientjes@google.com>, 
	Dmitry Vyukov <dvyukov@google.com>, Jann Horn <jannh@google.com>, 
	Justin Stitt <justinstitt@google.com>, KP Singh <kpsingh@kernel.org>, Kees Cook <kees@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, Matteo Rizzo <matteorizzo@google.com>, Michal Hocko <mhocko@suse.com>, 
	Mike Rapoport <rppt@kernel.org>, Nathan Chancellor <nathan@kernel.org>, 
	Nick Desaulniers <nick.desaulniers+lkml@gmail.com>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Suren Baghdasaryan <surenb@google.com>, linux-hardening@vger.kernel.org, 
	Nicolas Schier <nsc@kernel.org>, Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>, 
	Christoph Lameter <cl@gentwo.org>, Hao Li <hao.li@linux.dev>, "Liam R. Howlett" <liam@infradead.org>, 
	Alexander Potapenko <glider@google.com>, Miguel Ojeda <ojeda@kernel.org>, linux-kbuild@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, kasan-dev@googlegroups.com, 
	llvm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 19AA1C000D
X-Stat-Signature: 9ycmf9qwgy9b1wiboxnhpfhnrbr9ddws
X-HE-Tag: 1778579514-98266
X-HE-Meta: U2FsdGVkX19oi0fbhKQS3d7GPnO7mu+Ssyx8l0CUEl+dd0HFOEtaFqAjC4HJmN32RdjSNvmzVhz166k86Hg1O9MFb7SZTO6i8seZJXelajoI9RZASF/6vcIbt7AKZBHnXeswxSzRY6oQlcfJDB0PMSeAUGta7aZgVv1a+4nFMxwobu5e3uFl+he7Ned3mzJxfewbWHc/yVx95lmcWL464l72GNQboGkV89/k34nEwPeiOYTCdZcsq6RxnsoqNFbH3MkYhBV5dRSSWPTw0HuD9WZH/GR/m5KMjSU5FhqUlPcaXpT8BVhP/6BIHca2b85pYGdpO4nQCUHaEkePAmid3YRZr8U+NexqztLdNZ7ywyyLXIxjGAVGedlmbf/njDFdAjbHXlWi/b55Zttw7wnJI7z/qM14cHWCbhkgbM3g0AMnMMJlVDpZyNIO/uWfI8xYqVgobHJXjQ2rDQwYWhVACw/7mbok/Us6AI499xuTk/gj+neKwWodrBbYtOjFifLs7GpVvkMA4Fs1igeNlM2GfzFReO42pwhlxbXGUjl1tO1MCK372HFuE3q8Hrb7jPYqa4AmCUtTfRrg74dfMO+GD0/hjN6W58GCWkzITx1WM2d5IEgAjfqmxZQyICkiOUiJRXMFg/JuHT6+l62WpQ+U+GM0hc0aF1QRiulHSXvPGhcPtHTgEwwFlo7nMyQMHWrI0ODdf+xsEvSzOr5k8xEn3gxqUe2qNQfbRlnvos4o0Bos2TT9sdMhvP4Xp29Krk79S+id5hD8yPPtSmM/xv6Cp8PnB4vfw3K2YmjM6+1qNDuRh4xuRhk/U7vGqIMBUkSSMrDw8nbj+nKtar+Zx2X9UxgcPG0YDNa1f54DnI50FEZlYMybZwTUDGhKLk6eiaFZm77DBPFN6sp9QJMrGM83eEKoMuBJWd3hvZIMCGtQaCA3oXe7XtXzvLSa8yMTzsWM5Cce7NvUSYmUksOUqKg
 DZHGTIOP
 LVKyqFMokverYdG0NZaSPcS/D7ZTLS8cqkuJIviXziWFIUvMsfsGRYGeUWlZqtZr9aqUks/CG3QgpHWq69G0ps9a78odBPpYTSUQBPP+nGJ28axH+iPzlMpQnj3mMe8iuzxMMGx9c2cLHtwMIGZdBH8hN4i51ADZXLXA23+aJp3y8NFWpUMTQSSgcRwxnxKWNvP+ZN5/HWOkfFdqKcxX+OxNWO5B+8HgU2qHQMWeOzMRysKCjuKWKc47Fj6ZAqHj6CDSAPHREjReKRUk6QssIkjVxkM/I4cnhwGQrimHHaL/kC1EFV5iUtRZtCXI59mxA5N/jL59aQ1JKmBtD+kX2Z1EDc6QH87KhHVevjhrjRQJgbMgMBmr2lkwFuBDYC8bSKPZXV1rJGqULeEanqF8OLexow01/5bRiMvFLcn3wIOwk6luU7WAWa81vlrPpO07iNYnxXRvSqGSE19PhfMhvNrxMudRtu8RkrfE2znZpe60e9znVwQg/yAOjHpHPY31vtGh/
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 12 May 2026 at 07:13, 'Harry Yoo (Oracle)' via kasan-dev
<kasan-dev@googlegroups.com> wrote:
>
> On Mon, May 11, 2026 at 10:00:49PM +0200, Marco Elver wrote:
> > When using CONFIG_KMALLOC_PARTITION_RANDOM, _RET_IP_ was previously used
> > to identify the allocation site. _RET_IP_, however, evaluates to the
> > caller's parent's instruction pointer rather than the actual allocation
> > site; this would lead to collisions where a function performs multiple
> > allocations.
> >
> > With the generalization to kmalloc_token_t, we now generate the token at
> > the outermost macro, and using _THIS_IP_ would fix this for all cases.
> >
> > Unfortunately, the generic implementation of _THIS_IP_ relies on taking
> > the address of a local label, which is considered broken by both GCC [1]
> > and Clang [2] because label addresses are only expected to be used with
> > computed gotos. While the generic version more or less works today, it
> > is known to be brittle. For example, Clang -O2 always returns 1 when
> > this function is inlined:
> >
> >         static inline unsigned long get_ip(void)
> >         { return ({ __label__ __here; __here: (unsigned long)&&__here; }); }
> >
> > To provide a reliable unique identifier without breaking architectures
> > relying on the generic _THIS_IP_, introduce _CODE_LOCATION_: it resolves
> > to _THIS_IP_ where architectures provide a safe implementation, and
> > falls back to a zero-cost static marker where _THIS_IP_ is broken.
> >
> > Link: https://gcc.gnu.org/bugzilla/show_bug.cgi?id=120071 [1]
> > Link: https://github.com/llvm/llvm-project/issues/138272 [2]
> > Signed-off-by: Marco Elver <elver@google.com>
> > ---
>
> Looks good to me,
> Reviewed-by: Harry Yoo (Oracle) <harry@kernel.org>

Thanks!

> with one suggestion below.
>
> > ---
> >  include/linux/instruction_pointer.h | 24 ++++++++++++++++++++++++
> >  include/linux/slab.h                |  2 +-
> >  2 files changed, 25 insertions(+), 1 deletion(-)
> >
> > diff --git a/include/linux/instruction_pointer.h b/include/linux/instruction_pointer.h
> > index aa0b3ffea935..ea5bc756bd99 100644
> > --- a/include/linux/instruction_pointer.h
> > +++ b/include/linux/instruction_pointer.h
> > @@ -8,6 +8,30 @@
> >
> >  #ifndef _THIS_IP_
> >  #define _THIS_IP_  ({ __label__ __here; __here: (unsigned long)&&__here; })
> > +/*
> > + * The current generic definition of _THIS_IP_ is considered broken by GCC [1]
> > + * and Clang [2]. In particular, the address of a label is only expected to be
> > + * used with a computed goto.
> > + *
> > + *   [1] https://gcc.gnu.org/bugzilla/show_bug.cgi?id=120071
> > + *   [2] https://github.com/llvm/llvm-project/issues/138272
> > + *
> > + * Mark it as broken, so that appropriate fallback options can be implemented
> > + * for architectures that do not define their own _THIS_IP_.
> > + */
> > +#define HAS_BROKEN_THIS_IP
> > +#endif
> > +
> > +/*
> > + * _CODE_LOCATION_ provides a unique identifier for the current code location.
> > + * When _THIS_IP_ is broken (generic version), we fall back to a static marker
> > + * which guarantees uniqueness and resolves to a constant address at link time,
> > + * avoiding runtime overhead and compiler optimizations breaking it.
> > + */
> > +#ifdef HAS_BROKEN_THIS_IP
> > +#define _CODE_LOCATION_ ({ static const char __here; (unsigned long)&__here; })
>
> nit: perhaps it can be __initdata to free these after boot?
> ... if we want to save actual memory allocated rather than the
> vmlinux size.
>
> apparently ".init.bss" is a not thing :(

Not sure - it might cause CONFIG_DEBUG_SECTION_MISMATCH warnings.
Also, if this memory is reclaimed, it may be reused for kernel
modules, at which point there's a chance for collisions.

