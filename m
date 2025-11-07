Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DDFC8CCF9E3
	for <linux-mm@archiver.kernel.org>; Fri,  7 Nov 2025 09:13:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3B8AF8E000B; Fri,  7 Nov 2025 04:13:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 38FF78E0002; Fri,  7 Nov 2025 04:13:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2A6938E000B; Fri,  7 Nov 2025 04:13:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 18DB28E0002
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 04:13:05 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C38008883D
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 09:13:04 +0000 (UTC)
X-FDA: 84083246688.17.87E9DE7
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	by imf25.hostedemail.com (Postfix) with ESMTP id D2621A0006
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 09:13:02 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=P9IpE1yW;
	spf=pass (imf25.hostedemail.com: domain of 3HbgNaQkKCBQu52wyBI1508805y.w86527EH-664Fuw4.8B0@flex--aliceryhl.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3HbgNaQkKCBQu52wyBI1508805y.w86527EH-664Fuw4.8B0@flex--aliceryhl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762506783;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=h6hr5KyHBQ4i3KpvRUNSLwzvnbvgDhJcoWyAtNcMbQg=;
	b=3sOvWSJl4RgGqMCHqtvt6pWR1ro3kjzs9F5LyWZfVh8J6AtKxsJYx+xclqK/gdPlEvmOZb
	vzUnOhJ/qepbVHo0gXpsW49mJ+4+Gpq4Xoi/9BSf0Oj8vxsuzn4vL3ksDHl1aBV+RFjQXt
	Z+5lG/nDagF3foQIYcPeQ5nanz9MV4E=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762506783; a=rsa-sha256;
	cv=none;
	b=DV4BtkILOw+2tNHhHwHsxKMo3DshHK+23yRSZ3JcIcewtLJHspSlJZMeOdjHBoZk9YH2d4
	6p8eFlwRxVEfgmMGHLQaWwyGzgFXecIjJYh/3DB2mjKpcRxez9ME0NlV046m4N4abTmtx2
	Knh+2mZUnCdbS0VdXxpsI2Tgpn+eP14=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=P9IpE1yW;
	spf=pass (imf25.hostedemail.com: domain of 3HbgNaQkKCBQu52wyBI1508805y.w86527EH-664Fuw4.8B0@flex--aliceryhl.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3HbgNaQkKCBQu52wyBI1508805y.w86527EH-664Fuw4.8B0@flex--aliceryhl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-471201dc0e9so3681835e9.2
        for <linux-mm@kvack.org>; Fri, 07 Nov 2025 01:13:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762506781; x=1763111581; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=h6hr5KyHBQ4i3KpvRUNSLwzvnbvgDhJcoWyAtNcMbQg=;
        b=P9IpE1yWQY4/rHdvwnM1qpTILl/TkVvJNWyi89RJNLm5YxMhLIN8RK/yDu1GP6kVqw
         ZqYpOFQQooYbvFVQS+aPVDXFNyX8JqKrhmcAkm7V7iirsWfgebctvqVm6oV3/kcTBTAb
         QSbcqssGy6u+Qcq85T2LDreFHuvNB5l0f0SEzEZDUUfLQc2xXTOHUPRYA8fk9TRKQj+K
         y5qWo3skuFWisw/MNrdDI/y5OmCSN2P6QywgdHK85m4GFXN5TAKwJdR6d4H62wmDez47
         a/p0vCRp8axv2DZSeU5hgjAeOK2eiTgiwEEcte5bFcui0nlojEjKfZtr08rSZAUOOTeJ
         BPIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762506781; x=1763111581;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=h6hr5KyHBQ4i3KpvRUNSLwzvnbvgDhJcoWyAtNcMbQg=;
        b=UPnkSvfiJL8Or/jyn3KLmKWu9Dw5n6wqbZpcROE0DqKQgS+Hc0Y5M00JT21qry++Ss
         oAe264jhLSNDvOFb2b024F0kyRrPnPHesOc5uORz6f0reXicTEpHA4E/KZs7H8qhA4E4
         DcPE7pl5WwhcUdk1ZrIoxs4KP9UWDRU+iXKHGLdg9VmTHyccpPNkIMpp0A+52Mw71Dkb
         HETq2HyPhNnGxDRnfJzKPBKcLDTpDfLtbScES7LF/HwkdrNI5/mfDFMpIuFGWNR/foFB
         oB6g0PxcR62eHT108WvUXiZ43jomjDgiMC8ARJbeWawiS9rlwKVxk3bb3vKhmLEYP68C
         /GqQ==
X-Forwarded-Encrypted: i=1; AJvYcCU6vqCEKtca8dGbJ/nyk0JDEadGHrBaMvWBjJv5KRpIf99p1ZV8+n7ViqGwMQ+i5B0ECYZDtmLyVw==@kvack.org
X-Gm-Message-State: AOJu0YybJaShOzcL1HO65sFPl2vEle3u+UPt7WGAfkX+E6f4TiqNCpPV
	kDgrYBoFpGw7ufUTgPwqaXIWcoAVUsmapxsOpBKIbRFLPBuXxCV8JUd7cBddW/S03ZzKhii/PG6
	CR6D1QyUiftUh58u9dw==
X-Google-Smtp-Source: AGHT+IHUZEz+bT2nDPlYtV/C/QNEpv2U8khomuJk8Z2Iy1Z4Tlg4ge5tYPMjbGtCECv4gTvvdLMJU3QqC9ERcYo=
X-Received: from wmcu6.prod.google.com ([2002:a7b:c046:0:b0:476:4b14:2edf])
 (user=aliceryhl job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:4592:b0:477:3e07:217a with SMTP id 5b1f17b1804b1-4776bcc9c7emr20623525e9.36.1762506781268;
 Fri, 07 Nov 2025 01:13:01 -0800 (PST)
Date: Fri, 7 Nov 2025 09:13:00 +0000
In-Reply-To: <043dcbdb-e069-46e7-8f79-8fdaf354fb44@lucifer.local>
Mime-Version: 1.0
References: <cover.1762422915.git.lorenzo.stoakes@oracle.com>
 <fe38b1a43364f72d1ce7a6217e53a33c9c0bb0c5.1762422915.git.lorenzo.stoakes@oracle.com>
 <yja2mhwa4bzatbthjjq5rolqlkfgcbmppic3caaiwi6jc63rbc@cims6rqnotvj> <043dcbdb-e069-46e7-8f79-8fdaf354fb44@lucifer.local>
Message-ID: <aQ24HAAxYLhIvV5U@google.com>
Subject: Re: [PATCH v2 1/5] mm: introduce VM_MAYBE_GUARD and make visible in /proc/$pid/smaps
From: Alice Ryhl <aliceryhl@google.com>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Pedro Falcato <pfalcato@suse.de>, Andrew Morton <akpm@linux-foundation.org>, 
	Jonathan Corbet <corbet@lwn.net>, David Hildenbrand <david@redhat.com>, 
	"Liam R . Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu <mhiramat@kernel.org>, 
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Jann Horn <jannh@google.com>, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-mm@kvack.org, 
	linux-trace-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	Andrei Vagin <avagin@gmail.com>
Content-Type: text/plain; charset="utf-8"
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: D2621A0006
X-Stat-Signature: iejogi6sctmtqn31bntwymaj1sywhpfb
X-Rspam-User: 
X-HE-Tag: 1762506782-869759
X-HE-Meta: U2FsdGVkX1/t0Dj1dhgqGqOqa9Mg8YWCsOuuzARosufKp8IBzUDTWslVDNMmPSheHG3GKX5kT9dfG7hGPAOUf2QmtKA17HGvqyQz9aomaWBi/E36QaziqO9SSriPctKixt8BE/kWxsX7lTeYw45r+FfjZMbwP4BR8Y13K8nVBGTQrgUVJMyuRRixvoQCjIX8svgndbVuIdruXsUvME5hq0frkdR4O3oiG+ElB902piwxv0jBkB4vqFgSu8S7Fgmka6Ihj3xqLwuUtd2SXGl1xlIGR40JOX6V20XT2APFmomylCr/Vl1Ub/e057JANuywPDKDk2mvCm3mpFjgb88gyxGVPKtP+rL/Uj2kgh3JhVfGAbNQeLF6a1ji2pIxtPPhieXyfQIkgSkbZASRRFVNXAF4HQbzjf1JFuUbkeA/3el9ShzUYdGeqLSCxl7EPOJTGvhzT0oXdKHjXPgpDq7/onds/wZjkjeo45OO36KhJhVyTeIA2G1fVoaeQXzZ+o4PJh5WiqFKjKZQUPO2eIAqcrCvvN+3JhrLDpzzlHLA0vpbkYXsqfZUYDShquptkEmn2ZTUNCRMzdfQeuaYr+KeWhWFCmjGu4Zws+Eu/2MJZEq9w3TfrW/RHw3kTl4Zf8GetEOpWAZK6a+SAaVBmoEhymW7jELtx0HElT1+rTEjoELgOIae0Lz04XtWpp1O2Ob6n3ZvUpN0SUmLOf7YXsDFgiRynhzT3ot7gMUTCkyatNr1wgcXT+IkyzmTXgf7XKIB0fsJp1VV141CcqVLRFoGrXvYMbiEdeMdZqk5IR9gp3PFQlTijOp2gt1yFXyWghq1eqq75kz0KSyfhtBDZ5KSrSYOv1z86m1d/Vu9ZBfBKd2mM/7BGIMsldAiUFDRfABFflgxf41AQ8k4uuviKPCCdD82hyL1pSGLtMuPYeuv+XaGp4rrziAUi11ICeWYJlBGEycsh3HoLE0QO/0ePLL
 3Rd5HKju
 i1DOHOxGt2tVR4B4/7XRvRa/AeUivJsExOl2km+fBvNd6+5wS6tHuyDp7iWjHs8cYUxUBaq6FqaKG5RJIeRLq0q4XVHRmXOTSv2GHMzcdLiMtfPZa0Cd7M/KKiOzfe6e7FWYDqjmLhHnC7YOtmv2PEoZlMSs6SYyUNTE5kFlUC0pWyXYTdndh/GGazpRfh8HJhYuIuQ/hq2FlcD4PfAQO3Z3MtL9IdaAHOb/6rBLVmE5eAhcrE4usM5iaGbMN1p09dRfhjjRulhrHiTRzZZlMEqYiYPK1MkYnxHIHKkW94y0kOEdFTgCmzDd3HRt+I6jzPp/64895iCffNhe99txcTIY/CTDXR1uYmaLzqVU2qVQgOm+uf99XhH3T/KEbgaJJFKsBsU7/wPDr9efixE4kvFNZ+7MS5nc5TZmDahMkxIHcSxlqsFk+tmxiB4JYEVUaHPvQYSXaAQ6VMVBCEWDFNFX+1HYTE/zcrV7ZqGrU6SMIj6+2wm3BMbiEN5idttJriB7XLe8EVDAeYVOc6kHXce7sDAsIz1nWbM+PFuCMTO5iPF1TV/pIZ8xM96dffJ+Bd41RrK73qT1ihkbYhQpOJaoNp5SNKiOZT4ypiEdpIxE0zB9DFXj7k2/2so9qHRi0c1zBZ9JMbPJER4k7yy7krwtO0HE0KZ+u6CFvKPJ4qGvB3oEPHG5qkYP9CRUezlBB+/Frrw0X+IADoxVmFSEf1t+rWT5iSDDAApkWbDm9XTGZLrMMcCYUXF8W7fv++8Qx5zlGJ9kURLGsVLBJY1RZwtTI2sMhi9dpwrKLHDgLP41n2fmd0PBFQpCH7ubSaq6NsStwzKp3Nu4mtN5unEPBji11HTJylWcZCLzKY+ey1ImHAIVOLmv/8vXDYMqMaeokJkSK
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Nov 06, 2025 at 02:54:33PM +0000, Lorenzo Stoakes wrote:
> +cc Alice for rust stuff
> 
> On Thu, Nov 06, 2025 at 02:27:56PM +0000, Pedro Falcato wrote:
> > On Thu, Nov 06, 2025 at 10:46:12AM +0000, Lorenzo Stoakes wrote:
> > > Currently, if a user needs to determine if guard regions are present in a
> > > range, they have to scan all VMAs (or have knowledge of which ones might
> > > have guard regions).
> > >
> > > Since commit 8e2f2aeb8b48 ("fs/proc/task_mmu: add guard region bit to
> > > pagemap") and the related commit a516403787e0 ("fs/proc: extend the
> > > PAGEMAP_SCAN ioctl to report guard regions"), users can use either
> > > /proc/$pid/pagemap or the PAGEMAP_SCAN functionality to perform this
> > > operation at a virtual address level.
> > >
> > > This is not ideal, and it gives no visibility at a /proc/$pid/smaps level
> > > that guard regions exist in ranges.
> > >
> > > This patch remedies the situation by establishing a new VMA flag,
> > > VM_MAYBE_GUARD, to indicate that a VMA may contain guard regions (it is
> > > uncertain because we cannot reasonably determine whether a
> > > MADV_GUARD_REMOVE call has removed all of the guard regions in a VMA, and
> > > additionally VMAs may change across merge/split).
> > >
> > > We utilise 0x800 for this flag which makes it available to 32-bit
> > > architectures also, a flag that was previously used by VM_DENYWRITE, which
> > > was removed in commit 8d0920bde5eb ("mm: remove VM_DENYWRITE") and hasn't
> > > bee reused yet.
> > >
> > > We also update the smaps logic and documentation to identify these VMAs.
> > >
> > > Another major use of this functionality is that we can use it to identify
> > > that we ought to copy page tables on fork.
> > >
> > > We do not actually implement usage of this flag in mm/madvise.c yet as we
> > > need to allow some VMA flags to be applied atomically under mmap/VMA read
> > > lock in order to avoid the need to acquire a write lock for this purpose.
> > >
> > > Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> > > ---
> > >  Documentation/filesystems/proc.rst | 1 +
> > >  fs/proc/task_mmu.c                 | 1 +
> > >  include/linux/mm.h                 | 3 +++
> > >  include/trace/events/mmflags.h     | 1 +
> > >  mm/memory.c                        | 4 ++++
> > >  tools/testing/vma/vma_internal.h   | 3 +++
> > >  6 files changed, 13 insertions(+)
> > >
> > > diff --git a/Documentation/filesystems/proc.rst b/Documentation/filesystems/proc.rst
> > > index 0b86a8022fa1..b8a423ca590a 100644
> > > --- a/Documentation/filesystems/proc.rst
> > > +++ b/Documentation/filesystems/proc.rst
> > > @@ -591,6 +591,7 @@ encoded manner. The codes are the following:
> > >      sl    sealed
> > >      lf    lock on fault pages
> > >      dp    always lazily freeable mapping
> > > +    gu    maybe contains guard regions (if not set, definitely doesn't)
> > >      ==    =======================================
> >
> > The nittiest
> > of nits:     =============================================================
> 
> Sigh :) OK will fix.
> 
> >
> >
> > >
> > >  Note that there is no guarantee that every flag and associated mnemonic will
> > > diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
> > > index 8a9894aefbca..a420dcf9ffbb 100644
> > > --- a/fs/proc/task_mmu.c
> > > +++ b/fs/proc/task_mmu.c
> > > @@ -1147,6 +1147,7 @@ static void show_smap_vma_flags(struct seq_file *m, struct vm_area_struct *vma)
> > >  		[ilog2(VM_MAYSHARE)]	= "ms",
> > >  		[ilog2(VM_GROWSDOWN)]	= "gd",
> > >  		[ilog2(VM_PFNMAP)]	= "pf",
> > > +		[ilog2(VM_MAYBE_GUARD)]	= "gu",
> > >  		[ilog2(VM_LOCKED)]	= "lo",
> > >  		[ilog2(VM_IO)]		= "io",
> > >  		[ilog2(VM_SEQ_READ)]	= "sr",
> > > diff --git a/include/linux/mm.h b/include/linux/mm.h
> > > index 6e5ca5287e21..2a5516bff75a 100644
> > > --- a/include/linux/mm.h
> > > +++ b/include/linux/mm.h
> > > @@ -271,6 +271,8 @@ extern struct rw_semaphore nommu_region_sem;
> > >  extern unsigned int kobjsize(const void *objp);
> > >  #endif
> > >
> > > +#define VM_MAYBE_GUARD_BIT 11
> > > +
> > >  /*
> > >   * vm_flags in vm_area_struct, see mm_types.h.
> > >   * When changing, update also include/trace/events/mmflags.h
> > > @@ -296,6 +298,7 @@ extern unsigned int kobjsize(const void *objp);
> > >  #define VM_UFFD_MISSING	0
> > >  #endif /* CONFIG_MMU */
> > >  #define VM_PFNMAP	0x00000400	/* Page-ranges managed without "struct page", just pure PFN */
> > > +#define VM_MAYBE_GUARD	BIT(VM_MAYBE_GUARD_BIT)	/* The VMA maybe contains guard regions. */
> >
> > Don't we also need an adjustment on the rust side for this BIT()? Like we
> > for f04aad36a07c ("mm/ksm: fix flag-dropping behavior in ksm_madvise").
> 
> That's a bit unhelpful if rust can't cope with extremely basic assignments like
> that and we just have to know to add helpers :/
> 
> We do BIT() stuff for e.g. VM_HIGH_ARCH_n, VM_UFFD_MINOR_BIT,
> VM_ALLOW_ANY_UNCACHED_BIT, VM_DROPPABLE_BIT and VM_SEALED_BIT too and no such
> helpers there, So not sure if this is required?
> 
> Alice - why is it these 'non-trivial' defines were fine but VM_MERGEABLE was
> problematic? That seems strange.
> 
> I see [0], so let me build rust here and see if it moans, if it moans I'll add
> it.
> 
> [0]:https://lore.kernel.org/oe-kbuild-all/CANiq72kOhRdGtQe2UVYmDLdbw6VNkiMtdFzkQizsfQV0gLY1Hg@mail.gmail.com/

When you use #define to declare a constant whose right-hand-side
contains a function-like macro such as BIT(), bindgen does not define a
Rust version of that constant. However, VM_MAYBE_GUARD is not referenced
in Rust anywhere, so that isn't a problem.

It was a problem with VM_MERGEABLE because rust/kernel/mm/virt.rs
references it.

Note that it's only the combination of #define and function-like macro
that triggers this condition. If the constant is defined using another
mechanism such as enum {}, then bindgen will generate the constant no
matter how complex the right-hand-side is. The problem is that bindgen
can't tell whether a #define is just a constant or not.

Alice

