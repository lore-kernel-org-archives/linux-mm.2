Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9817ACFA446
	for <linux-mm@archiver.kernel.org>; Thu, 20 Nov 2025 22:32:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B158F6B0008; Thu, 20 Nov 2025 17:32:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AC6346B000A; Thu, 20 Nov 2025 17:32:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 98DF16B0023; Thu, 20 Nov 2025 17:32:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 806826B0008
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 17:32:47 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 166CE1387D5
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 22:32:47 +0000 (UTC)
X-FDA: 84132436374.13.64630F1
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf11.hostedemail.com (Postfix) with ESMTP id BD71040018
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 22:32:44 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=RN4DK+oi;
	spf=pass (imf11.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763677965;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GeA/zAKZ/1z66T0o4lpHibqrnYkMZvfbiOk8G9lfRrE=;
	b=TL79wEfNa149N+vTngaHb4GrSclL1HKUdEHqHjL5dFS+EOCFGpcfI/Hvg656Qy5OuZ1Wsk
	NZq1PmO8AJ1MRHiB83RlesQtdeNlPErMJEICWfRfT7N8vka7DOEmFnDgZdjDYbaFJdcEcs
	ZPFPT5T/Qq4N8FRqC7qOTTmkvs5L9mI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763677965; a=rsa-sha256;
	cv=none;
	b=0MnCNB9hJ1ytX0boJ2/C+iTkGtty3UCCnHlDcuCg5wpY1kBesjng7AtRKa93yQ4DIArR/D
	fJdubvY8x7WCCcys70whiKRhjtra7Q2E148ZvBcfAICT/j/YVEpQb2+zw6oO/whK70P0qi
	wjAMjUAJyWiB9ZQSd5LRNqN33pETz/E=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=RN4DK+oi;
	spf=pass (imf11.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1763677964;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GeA/zAKZ/1z66T0o4lpHibqrnYkMZvfbiOk8G9lfRrE=;
	b=RN4DK+oivCurF1BYbTPzxXTwA0JJ9+7gerKANUsbpITBDObjG5dDOD4RMp9/SqV6+eT6EE
	KsR0YqYJzO7lU0FyVlBlyBXdJUAyTX+9sI1lGwe3vcmfODqeIFZ9kK45H7Aw9+tdMx/8Tt
	MO0Z0EsDJ31GY/FOIYlnrQcxNjbJTAI=
Received: from mail-yw1-f197.google.com (mail-yw1-f197.google.com
 [209.85.128.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-679-saVrpSWAOsi4ThREJN-B9Q-1; Thu, 20 Nov 2025 17:32:42 -0500
X-MC-Unique: saVrpSWAOsi4ThREJN-B9Q-1
X-Mimecast-MFC-AGG-ID: saVrpSWAOsi4ThREJN-B9Q_1763677962
Received: by mail-yw1-f197.google.com with SMTP id 00721157ae682-78817da4711so19815927b3.3
        for <linux-mm@kvack.org>; Thu, 20 Nov 2025 14:32:42 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763677962; x=1764282762;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=GeA/zAKZ/1z66T0o4lpHibqrnYkMZvfbiOk8G9lfRrE=;
        b=oMWxK+jScdlobiq6mTCzXaJO+RRl4Gtzr7Du3LM28RIypdzJThICK5nzvmkDJd5YOc
         qemH4aIQGVny5KCIuos8KoRK+h7WrfKzEqC+L2vIYkEf1xwHOT56unIyrjUEIQN0qJRc
         Tdlf799h0LQGinJXhp6bJ1PSeVUlFM7JhlNFuhh/mIghLhs5flSVICcpJoyzsyLz0Evd
         4BHdev6ZU7KGM8pX7GYGQNRtOcOfUhVUZDAImzaW19vTuI7F3CLhOo3xfbnYNmOzux0a
         GB1g/+jInmIE1Xc25bEq+Kl89sb2GaNI/TyUvtrvRXdDugB6sABgasU9pU60dEZt6oou
         i0+g==
X-Forwarded-Encrypted: i=1; AJvYcCV0xfwTd6+vbIfPKagwp6LD1fFj8nn+K5l3vP+FmX0HBLWxhN4m/UyMU9oUKPlEU5Y714e23mgZ+A==@kvack.org
X-Gm-Message-State: AOJu0YwFn4pV2ki6kCCyt7QM/rNfvp0WTLv8wDIFWvI5KN/OQ8QMd06e
	zfNnvbW7iec7JIUXufso6zU1dMlVck04JUlt/4NzPE6B3IcNzXFl4+gLpfvmgcNcM5RydYgG9gK
	5aLfeeXWWY/mVGQKAPQz2Gck6vZHTkK9XrerKH79RmCxjkQQTik7AnBWrsFKhEvWSpVZvT6Mgvz
	eghBgYF97yPWGm0AhbGFi49FK41Q4=
X-Gm-Gg: ASbGncufX7NYMhssI6rn3qQ+dM6lUemcEEtWNnuMsJJju4BC9703yQaDfCTiANQJRIx
	+HhuNvHn3Jzx6hHEsX3wIWeD9jCoabEC4s7ZAPPZakhobpLDaqF2JDiNwNDbQg8lVeW7CFFoekL
	xz6AlGMOnl/Lul4oJ/JcftnwtH207ra5xGjTcIa2LOUoB3bUJoqM4EcCzdzkFXsxS0Wl+Tlu4KP
	dPZrRmF
X-Received: by 2002:a05:690e:428a:20b0:636:149a:f54e with SMTP id 956f58d0204a3-64302a6b00amr27291d50.37.1763677961674;
        Thu, 20 Nov 2025 14:32:41 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGirU2vbNWZe8D1FkpfaBXgFAc9rqZ1VzDtWHWoob6EGF4pkntwkJUmbNanDvopt+AwZoljIUFVqOWeT6YOO7g=
X-Received: by 2002:a05:690e:428a:20b0:636:149a:f54e with SMTP id
 956f58d0204a3-64302a6b00amr27257d50.37.1763677960916; Thu, 20 Nov 2025
 14:32:40 -0800 (PST)
MIME-Version: 1.0
References: <20251022183717.70829-1-npache@redhat.com> <20251022183717.70829-13-npache@redhat.com>
 <d03e079f-35c0-4fc1-8856-44fe33fabb2f@lucifer.local>
In-Reply-To: <d03e079f-35c0-4fc1-8856-44fe33fabb2f@lucifer.local>
From: Nico Pache <npache@redhat.com>
Date: Thu, 20 Nov 2025 15:32:15 -0700
X-Gm-Features: AWmQ_bm8_9BuQ9L1d7aaqKoV23XDwXpJRMRJV4QkRX9MTV-OHhlvE930nuvVkqk
Message-ID: <CAA1CXcCJ+MS4U_ycT9hg4cK31cQrjFs2SoL8isf_mKfVbN5tJg@mail.gmail.com>
Subject: Re: [PATCH v12 mm-new 12/15] khugepaged: Introduce mTHP collapse support
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org, 
	linux-mm@kvack.org, linux-doc@vger.kernel.org, david@redhat.com, 
	ziy@nvidia.com, baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, 
	ryan.roberts@arm.com, dev.jain@arm.com, corbet@lwn.net, rostedt@goodmis.org, 
	mhiramat@kernel.org, mathieu.desnoyers@efficios.com, 
	akpm@linux-foundation.org, baohua@kernel.org, willy@infradead.org, 
	peterx@redhat.com, wangkefeng.wang@huawei.com, usamaarif642@gmail.com, 
	sunnanyong@huawei.com, vishal.moola@gmail.com, 
	thomas.hellstrom@linux.intel.com, yang@os.amperecomputing.com, kas@kernel.org, 
	aarcange@redhat.com, raquini@redhat.com, anshuman.khandual@arm.com, 
	catalin.marinas@arm.com, tiwai@suse.de, will@kernel.org, 
	dave.hansen@linux.intel.com, jack@suse.cz, cl@gentwo.org, jglisse@google.com, 
	surenb@google.com, zokeefe@google.com, hannes@cmpxchg.org, 
	rientjes@google.com, mhocko@suse.com, rdunlap@infradead.org, hughd@google.com, 
	richard.weiyang@gmail.com, lance.yang@linux.dev, vbabka@suse.cz, 
	rppt@kernel.org, jannh@google.com, pfalcato@suse.de
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: tnK2noMiMXAaRVbg2uZsliUGSU2urOTezmM4_wz4MSk_1763677962
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 1t16uf9gmixnyp57wq47s9wazom4spcs
X-Rspam-User: 
X-Rspamd-Queue-Id: BD71040018
X-Rspamd-Server: rspam01
X-HE-Tag: 1763677964-950863
X-HE-Meta: U2FsdGVkX18tKOQ7U95AeF+6KGnn6idHgaPM5T+mxHCiiDVol3NYG3AO4vB2ZEtjT5uSpomYYGOsCs0M+tP8UJIC2QSfQJRzkSDyYAD9gfRynTSEbAlgepdgZpxG9TPg/Dd64eJIH7qSaEU7iWQijy5FJ6MgORRbzlGOECSt1Fjx92OQXfK8bQ+U7vD5hA3gWCLH7asj2mUp7i5p8/znzfQ/IEOHs3x5Oy4/0wsGE1qClsibL0zGNNgEWlQYZ43T6n3vBAr+yaWkzKxQdludz1RrWqaNpp8B6LGPWoFzgHLsXy2/jjMbg62+NYIQwvNJhYpgBB5gC8XpvUdxejAekrckopG09ZEcpWuucaQStX4Pzkf3QeKerpa9pFlZsuNN2iC1q62+Zz5TMPLFlVDOwbSWfb06eiBiXlSvv0Y78oyDVZUzYhBe3z2IlvSayJbxHktdeYE92J+0U0Wzi5/pXFG8AV0DgSghGTNAVQyhx/RuPIUO/PaDthdqD2mNiBy0lgkFVPtT/AB2p+k1a4ul5rLwXsNv55teHom5z1GyRhKs+yA61VhjAJPKRzkmDRtdvftzg1Oszw14FcEtgFyfqWi59+GxcdPaBdvMomzpPeXN0t8WJhvXuLc64SfS9eZXX09cU18lxPDDfbehwo5FyQOzhDGi4kFLjgkv1+9QMVCTWcfiOzpz7JX5l2dnzjiEmLldLXrWxEfebZTsaJ6qZ1+KHPUQ+kUZiankBvRHSKAiyax2KdKpxhh8W4TiQZCViMbC0VDZ9wzdJ6+P+tTsYxitdemNFIO1f+AyX6HhibBKCqijT1DUwKnqK/kH0/qTftmHjtG3nSUHXTWmolb2iZqS/8qi+ZHsjNlDBKUmbWSlfB+cDSMNw0BAeEx904N4vZFUTLxhRSCV+v4uvtWysJNaqzqo2acastzjA9zi/+DO5zUwHQtYcjbjwqtbJ2UX9wNlwKCLtfkSctscuQW
 DOaZpL0/
 d1AAz/EB07VnRg/jK4kCdedlhjg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Nov 19, 2025 at 4:56=E2=80=AFAM Lorenzo Stoakes
<lorenzo.stoakes@oracle.com> wrote:
>
> On Wed, Oct 22, 2025 at 12:37:14PM -0600, Nico Pache wrote:
> > During PMD range scanning, track occupied pages in a bitmap. If mTHPs a=
re
> > enabled we remove the restriction of max_ptes_none during the scan phas=
e
> > to avoid missing potential mTHP candidates.
>
> It's a bit odd to open the commit message with a very specific
> implementation detail, I think we should instead open with a broad
> description of what we intend here, e.g. to permit mTHP collapse, before:
>
> - Discussing the algorithm used (in more detail than below!)
> - How and under what circumstances this algorithm is invoked
> - (Mention MADV_COLLAPSE not supporting mTHP as of yet)
> - THEN super-specific details like this
>
> >
> > Implement collapse_scan_bitmap() to perform binary recursion on the bit=
map
> > and determine the best eligible order for the collapse. A stack struct =
is
> > used instead of traditional recursion. The algorithm splits the bitmap
> > into smaller chunks to find the best fit mTHP.  max_ptes_none is scaled=
 by
> > the attempted collapse order to determine how "full" an order must be
> > before being considered for collapse.
>
> I feel this is a _very_ brief description of a complicated algorithm. I
> think we should go into a lot more detail here. 'Binary recursion' is pre=
tty
> hand-wavey, and you go from hand waving that to being super-specific abou=
t
> max_ptes_none before handwaving about 'fullness' of an order.
>
> All in all I find it super confusing - so I think you need to take a step
> back and 'explain it to me like I'm 5' here :)

Sounds good, I'll rework the commit message with your feedback in mind! Tha=
nks!

>
> >
> > Once we determine what mTHP sizes fits best in that PMD range a collaps=
e
> > is attempted. A minimum collapse order of 2 is used as this is the lowe=
st
> > order supported by anon memory.
>
> I don't know what 'lowest order supported by anon memory' means?
>
> I guess really this is the minimum order contptes support for arm64 right=
?

Anonymous memory supports mTHP sizes of order 2 or greater.

>
> >
> > mTHP collapses reject regions containing swapped out or shared pages.
> > This is because adding new entries can lead to new none pages, and thes=
e
> > may lead to constant promotion into a higher order (m)THP. A similar
> > issue can occur with "max_ptes_none > HPAGE_PMD_NR/2" due to a collapse
> > introducing at least 2x the number of pages, and on a future scan will
> > satisfy the promotion condition once again. This issue is prevented via
> > the collapse_allowable_orders() function.
>
> Obviously this has been discussed to death, but you should update this to
> reflect the decided upon course (0, 511 + warning, etc.).

Yeah I wasnt sure whether to reference collapse_allowable_orders()
which should now dictate this limitation, or directly reference the
limitations here. Ill do both.

>
> >
> > Currently madv_collapse is not supported and will only attempt PMD
> > collapse.
>
> Good to highlight this.
>
> >
> > We can also remove the check for is_khugepaged inside the PMD scan as
> > the collapse_max_ptes_none() function handles this logic now.
>
> Again we're kind of leaping from mega handwaving to super-specific detail=
s
> :) let's make it all a lot more specific + clear, and then put the really
> niche details like this at the end of the commit msg (I mean this one is
> fine where it is ofc as a result :)
>
> >
> > Signed-off-by: Nico Pache <npache@redhat.com>
> > ---
> >  include/linux/khugepaged.h |   2 +
> >  mm/khugepaged.c            | 128 ++++++++++++++++++++++++++++++++++---
> >  2 files changed, 122 insertions(+), 8 deletions(-)
> >
> > diff --git a/include/linux/khugepaged.h b/include/linux/khugepaged.h
> > index eb1946a70cff..179ce716e769 100644
> > --- a/include/linux/khugepaged.h
> > +++ b/include/linux/khugepaged.h
> > @@ -1,6 +1,8 @@
> >  /* SPDX-License-Identifier: GPL-2.0 */
> >  #ifndef _LINUX_KHUGEPAGED_H
> >  #define _LINUX_KHUGEPAGED_H
> > +#define KHUGEPAGED_MIN_MTHP_ORDER    2
> > +#define MAX_MTHP_BITMAP_STACK        (1UL << (ilog2(MAX_PTRS_PER_PTE) =
- KHUGEPAGED_MIN_MTHP_ORDER))
>
> This is an internal implementation detail, I don't think we need this in =
a
> header do we? I think this define should be in khugepaged.c.

sounds good!

>
> Also this is a really fiddly and confusing value, I don't think it's a go=
od idea
> to just put this here without explanation.

This is sadly an outcome of ppc64. HPAGE_PMD_ORDER cannot be used due
to ppc defining this at runtime, so instead we use
lg(MAX_PTRS_PER_PTE).

>
> It's not even clear what it is. I'd probably rename it to MTHP_STACK_SIZE=
?

Yeah MTHP_STACK_SIZE is better!

>
> We need a comment that explains how you're deriving this, something like:
>
> /*
>  * In order to determine mTHP order, we consider every possible mTHP size
>  * starting with MAX_PTRS_PER_PTE PTE entries and stopping at
>  * 2^KHUGEPAGED_MIN_THP_ORDER.
>  *
>  * We store (offset, order) pairs on the stack to do so, each describing =
a
>  * candidate mTHP collapse.
>  *
>  * For each (offset, order) candidate mTHP range that we consider, we mus=
t
>  * also consider candiate mTHPs at (offset, order - 1), and (offset + (1 =
<<
>  * order), order - 1).
>  *
>  *
>  * This is because each order can be split into two (an order expresses t=
he
>  * power-of-two size), so we examine each half of the next lower order
>  * mTHP:
>  *
>  *                offset   mid_offset
>  *                  .          |
>  *                  .          v
>  *  |---------------.-------------------|
>  *  |           PTE page table          |
>  *  |---------------.-------------------|
>  *                   <--------><-------->
>  *                     order-1   order-1
>  *
>  * Given we must consider the range of KHUGEPAGED_MIN_MTHP_ORDER to
>  * MAX_PTRS_PER_PTE number of PTE entries, this is the same as saying we
>  * must consider KHUGEPAGED_MIN_MTHP_ORDER to lg2(MAX_PTRS_PER_PTE) mTHP
>  * orders.
>  *
>  * As we must consider 2 possible mTHP ranges for each order, this requir=
es
>  * our stack to be 2^n, where n is the number of orders we must consider.
>  *
>  * And thus MTHP_STACK_SIZE is 2^(lg2(MAX_PTRS_PER_PTE) -
>  * KHUGEPAGED_MIN_MTHP_ORDER).
>  */
>
> This may seem (very) long-winded, but this is all really non-obvious.
>
> You can additionally rephrase this and utilise it in the commit message,
> description of the iterative recursion function and possibly elsewhere to
> describe the algorithm more clearly.
>
> In fact, since this should really be declared in khugepaged.c, and since
> you can place it just before the mthp collapse function, you could expand
> this to describe the algorithm as a whole and simply put the define and t=
he
> function immediately next to each other after the comment?

Sounds good ill break this down in more detail and try to group the
functions/comments into one section. It may not be fully possible to
keep the code together as some things are needed early in the code (ie
MAX_STACK_SIZE would be needed at scan_control definition)

>
> >
> >  #include <linux/mm.h>
> >
> > diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> > index 89a105124790..e2319bfd0065 100644
> > --- a/mm/khugepaged.c
> > +++ b/mm/khugepaged.c
> > @@ -93,6 +93,11 @@ static DEFINE_READ_MOSTLY_HASHTABLE(mm_slots_hash, M=
M_SLOTS_HASH_BITS);
> >
> >  static struct kmem_cache *mm_slot_cache __ro_after_init;
> >
> > +struct scan_bit_state {
>
> Scan bit state is a bit of a weird name. Scanning what? What bit? State i=
s
> kind of implied?
>
> struct order_offset_pair?
>
> struct mthp_range?

mthp_range sounds good to me!

>
> > +     u8 order;
> > +     u16 offset;
>
> Real mega nit, but feels more natural to put offset first here. As
> (position, size) seems more naturally the way to view this than (size,
> position).

ack!

>
> > +};
> > +
>
> Also needs comments...? Order of what? Offset in what?
>
> >  struct collapse_control {
> >       bool is_khugepaged;
> >
> > @@ -101,6 +106,13 @@ struct collapse_control {
> >
> >       /* nodemask for allocation fallback */
> >       nodemask_t alloc_nmask;
> > +
> > +     /*
> > +      * bitmap used to collapse mTHP sizes.
> > +      */
>
> Nit but this should be on one line /* Bitmap used to collapse mTHP sizes =
*/.

ACK, already handled this one!

>
> But we're not storing sizes though are we? And we're declaring two bitmap=
s?
>
> > +      DECLARE_BITMAP(mthp_bitmap, HPAGE_PMD_NR);
>
> Really this is more of a PTE table bitmap but probably fine to call it th=
is.
>
> > +      DECLARE_BITMAP(mthp_bitmap_mask, HPAGE_PMD_NR);
>
> You've added random whitespace after the tab twice here? [tab][space]DECL=
ARE_...
>
> > +     struct scan_bit_state mthp_bitmap_stack[MAX_MTHP_BITMAP_STACK];
> >  };
> >
> >  /**
> > @@ -1357,6 +1369,85 @@ static int collapse_huge_page(struct mm_struct *=
mm, unsigned long pmd_address,
> >       return result;
> >  }
> >
> > +static void push_mthp_bitmap_stack(struct collapse_control *cc, int *t=
op,
> > +                                u8 order, u16 offset)
>
> Not sure we need to say mthp_bitmap_stack everywhere. This is a local
> static function we can be a little more succinct.
>
> mthp_stack_push()?

looks good!

>
> > +{
> > +     cc->mthp_bitmap_stack[++*top] =3D (struct scan_bit_state)
> > +             { order, offset };
>
> This feels rather difficult to read, cc->mthp_bitmap_stack[++*top] in
> particular is rather too succinct.
>
> This would be better more broken out, e.g.:
>
> static void mthp_stack_push(struct collapse_control *cc, int *sizep,
>             u8 order, u16 offset)
> {
>         const int size =3D *sizep;
>         struct scan_bit_state *stack =3D &cc->mthp_bitmap_stack[size];
>
>         VM_WARN_ON_ONCE(idx >=3D MAX_MTHP_BITMAP_STACK);
>         stack->order =3D order;
>         stack->offset =3D offset;
>         *sizep++;
> }
>
> (Note this requires the change I suggest below re: not defaulting top to =
-1
> but instead renaming it to stack_size and starting at 0, see below).
>
> Re: below comment having pop as a helper too, that can be:
>
> static struct scan_bit_state mthp_stack_pop(struct collapse_control *cc,
>                 int *sizep)
> {
>         const int size =3D *sizep;
>
>         VM_WARN_ON_ONCE(size <=3D 0);
>         *sizep--;
>         return cc->mthp_bitmap_stack[size - 1];
> }

ack sounds good. I implemented these more verbosely!

>
> > +}
> > +
> > +/*
> > + * collapse_scan_bitmap() consumes the bitmap that is generated during
> > + * collapse_scan_pmd() to determine what regions and mTHP orders fit b=
est.
> > + *
> > + * Each bit in the bitmap represents a single occupied (!none/zero) pa=
ge.
>
> In which bitmap? There are 2 that are declared. Be specific - cc->mthp_bi=
tmap.
>
> > + * A stack structure cc->mthp_bitmap_stack is used to check different =
regions
>
> > + * of the bitmap for collapse eligibility. We start at the PMD order a=
nd
> > + * check if it is eligible for collapse; if not, we add two entries to=
 the
>
> I questioned this since you start at HPAGE_PMD_ORDER -
> KHUGEPAGED_MIN_MTHP_ORDER, but then realised you're intentionally
> offsetting like that.
>
> See comments below about changing this.
>
> > + * stack at a lower order to represent the left and right halves of th=
e region.
> > + *
> > + * For each region, we calculate the number of set bits and compare it
> > + * against a threshold derived from collapse_max_ptes_none(). A region=
 is
> > + * eligible if the number of set bits exceeds this threshold.
> > + */
>
> I think we could be clearer here. Something like:
>
> ...
>  * stack at a lower order to represent the left and right halves of the
>  * portion of the PTE page table we are examining.
>  *
>
>  * For each of these, we determine how many PTE entries are occupied in t=
he
>  * range of PTE entries we propose to collapse, then compare this to the
>  * number of PTE entries which would need to be set for a collapse to be
>  * permitted at that order (accounting for max_ptes_none).
>  *
>  * If a collapse is permissible, we attempt to perform one. We do so for
>  * every possible mTHP in the PTE page table.
>  */
>
> > +static int collapse_scan_bitmap(struct mm_struct *mm, unsigned long ad=
dress,
>
> Really inconsistent naming going on here, we're collapsing and scanning a=
nd
> what's the bitmap?
>
> How about mthp_collapse()?

ok sounds good

>
> > +             int referenced, int unmapped, struct collapse_control *cc=
,
> > +             bool *mmap_locked, unsigned long enabled_orders)
> > +{
> > +     u8 order, next_order;
> > +     u16 offset, mid_offset;
> > +     int num_chunks;
> > +     int bits_set, threshold_bits;
> > +     int top =3D -1;
>
> This seems unnecessary and confusing. Just start at 0 and treat this as t=
he
> exclusive end of the stack.
>
> You can rename this stack_size to make that clear. Have commented above
> about adjustments to push function and introducing pop helper.
>
>
> > +     int collapsed =3D 0;
> > +     int ret;
> > +     struct scan_bit_state state;
> > +     unsigned int max_none_ptes;
>
> Everywhere else we say max_ptes_none, let's maintain that convention here
> please.

ack, didn't realize it was different. Must have been tired eyes.

>
> > +
> > +     push_mthp_bitmap_stack(cc, &top, HPAGE_PMD_ORDER - KHUGEPAGED_MIN=
_MTHP_ORDER, 0);
>
> See below re: order here, we should change this.
>
> > +
> > +     while (top >=3D 0) {
> > +             state =3D cc->mthp_bitmap_stack[top--];
>
> I hate that we have a push helper but then do pop manually. See above.
>
> > +             order =3D state.order + KHUGEPAGED_MIN_MTHP_ORDER;
>
> OK so now the order isn't state.order but is instead state.order +
> KHUGEPAGED_MIN_MTHP_ORDER? :/ this is extremely confusing.
>
> We shouldn't call this field order if you're doing a hack where state.ord=
er
> isn't the order but instead is order - KHUGEPAGED_MIN_MTHP_ORDER.
>
> Just have state.order be the actual order? And change the below condition
> as mentioned there.

Sounds good, Wei already suggested something similar. This made more
sense when we were compressing the bitmap into 128 bits. Already
changed :)

>
> > +             offset =3D state.offset;
> > +             num_chunks =3D 1UL << order;
>
> What's a chunk? You do need to clarify these things. This is a new term n=
ot
> used elsewhere in THP code as far as I can tell?
>
> This is the number of pte entries no?
>
> nr_entries? nr_pte_entries?

Yeah that looks much cleaner. Some remnants from my RFC.

>
> > +
> > +             /* Skip mTHP orders that are not enabled */
>
> Note we're also considering PMD here :) Probably we can just delete this
> comment, the code below makes it clear what you're doing.
>
> > +             if (!test_bit(order, &enabled_orders))
> > +                     goto next_order;
> > +
> > +             max_none_ptes =3D collapse_max_ptes_none(order, !cc->is_k=
hugepaged);
>
> OK so this is going to be scaled to order.
>
> > +
> > +             /* Calculate weight of the range */
>
> What's the weight of a range? This isn't a very helpful comment. You're
> counting the Hamming weight or much more clearly - the number of set bits=
.
>
> So it seems you're simply counting the number of bits you have accumulate=
d
> so far in cc->mthp_bitmap, adding in the latest offset.
>
> So I'd say add a comment saying something like:
>
> /*
>  * Determine how many PTE entries are populated in the range in which we
>  * propose to collapse this mTHP.
>  */
>
> > +             bitmap_zero(cc->mthp_bitmap_mask, HPAGE_PMD_NR);
> > +             bitmap_set(cc->mthp_bitmap_mask, offset, num_chunks);
> > +             bits_set =3D bitmap_weight_and(cc->mthp_bitmap,
>
> I think this variable name is pretty horrible, we don't care that it's th=
e
> number of bits set, we care about what it _means_ - that is the number of
> PTE occupied entries.
>
> So nr_occupied_pte_entries? Or nr_occupied_ptes?

ack, looks better!

>
> > +                                          cc->mthp_bitmap_mask, HPAGE_=
PMD_NR);
>
> Frustrating there isn't a bitmap_weight_offset() or something, as you cou=
ld
> do that in one go then...

Yeah it's a shame, my previous implementation was much worse. I found
a better solution (this one) a few versions ago.

>
> I think this could be made clearer by separating out the gnarly bitmap
> stuff into a helper function:
>
> static int mthp_nr_occupied_pte_entries(struct collapse_control *cc,
>                 struct scan_bit_state state)
> {
>         const int nr_pte_entries =3D 1 << state.order;
>
>         /* Setup cc->mthp_bitmap_mask to contain mask for candidate mTHP.=
 */
>         bitmap_zero(cc->mthp_bitmap_mask, HPAGE_PMD_NR);
>         bitmap_set(cc->mthp_bitmap_mask, state.offset, nr_pte_entries);
>         /* Mask against actually occupied PTE entries in PTE table. */
>         return bitmap_weight_and(cc->mthp_bitmap,
>                                  cc->mthp_bitmap_mask, HPAGE_PMD_NR);
> }

Done, this fits well with all the other helpers!

>
> > +
> > +             threshold_bits =3D (1UL << order) - max_none_ptes - 1;
>
> We defined num_chunks to 1UL << order then don't use here? :)

Cleaned these up! thanks :)

>
> I'm not sure we need this to be a separate value, and I don't think we ne=
ed
> the -1 either, which only confuses matter more.
>
> How about just changing the below conditional to (assuming we've renamed
> num_chunks to something sensible like nr_pte_entries and bits_set to
> nr_occupied_pte_entries):
>
> if (nr_occupied_pte_entries >=3D nr_pte_entries - max_none_ptes) {
>         ...
> }
>
> > +
> > +             /* Check if the region is eligible based on the threshold=
 */
>
> Probalby don't need this comment with the change above.

ack, that does look cleaner. Although iirc there was some weird corner
case that required the -1. This was back when we were compressing the
bitmap. I reviewed the logic, I think we can go with this solution
now. Ill make sure to test the corner cases I have.

>
> > +             if (bits_set > threshold_bits) {
> > +                     ret =3D collapse_huge_page(mm, address, reference=
d,
> > +                                              unmapped, cc, mmap_locke=
d,
> > +                                              order, offset);
>
> We declare ret at the top of the function scope, then only use it
> here. That's confusing and unnecessary, just declare it in block scope
> here.
>
> > +                     if (ret =3D=3D SCAN_SUCCEED) {
> > +                             collapsed +=3D 1UL << order;
>
> Again we have defined num_chunks or rather nr_pte_entries but then
> open-code 1UL << order, let's just use the value we declared here.
>
> > +                             continue;
>
> This is kinda subtle, we don't bother considering lower orders any longer
> *in this range*, but do continue to consider mTHP collapse in other
> portions of the PTE page table.
>
> This shouldn't just be a 'continue' :) we need a comment here to explain
> that.

sounds good i'll separate and add more to the comments to help explain
the flow. (more applicable to patch 13)
>
> E.g.:
>
>         /*
>          * We have collapsed an mTHP in this range at the maximum order w=
e
>          * could, so we do not push lower orders on to the stack.
>          */
>          continue;
>
>
> > +                     }
> > +             }
> > +
> > +next_order:
> > +             if (state.order > 0) {
>
> This is a great example of how this is confusing by making state.order no=
t
> actually be the order but the order - KHUGEPAGED_MIN_MTHP_ORDER.
>
> Just make the order correct and change this to > KHUGEPAGED_MIN_MTHP_ORDE=
R.
>
> > +                     next_order =3D state.order - 1;
>
> Not sure we should have a label and a variable be the same thing.
>
> Also why are we decl'ing next_order at the top of the function but only u=
sing here?

ack.

>
> Just declare this here, like:
>
>         if (state.order > KHUGEPAGED_MIN_MTHP_ORDER) {
>                 const u16 new_order =3D state.order - 1;
>
>                 ...
>         }
>
> > +                     mid_offset =3D offset + (num_chunks / 2);
> > +                     push_mthp_bitmap_stack(cc, &top, next_order, mid_=
offset);
> > +                     push_mthp_bitmap_stack(cc, &top, next_order, offs=
et);
>
> I guess one subtlety that wouldn't be obvious at first glance is that
> num_chunks (oh so badly needs a rename :) is a power-of-2 so we never get
> weird 'what if num_chunks is odd' scenarios to worry about.
>
> Probably doesn't really need a comment though. But this _does_ badly need=
s
> an ASCII diagram :):
>
>         /*
>          * The next lowest mTHP order possesses half the number of PTE
>          * entries of the current one. We therefore must consider both
>          * halves of the current mTHP:
>          *
>          *                offset   mid_offset
>          *                  .          |
>          *                  .          v
>          *  |---------------.-------------------|
>          *  |           PTE page table          |
>          *  |---------------.-------------------|
>          *                   <--------><-------->
>          *                     order-1   order-1
>          */
>

yeah a diagram would help a lot!

> Since writing this I copied this above in another suggestion :P so you
> could always say 'see comment above for details' or something.
>
> > +             }
> > +     }
> > +     return collapsed;
> > +}
>
> I've commented this function to death here, but a few more things to note=
.
>
> (BTW - I'm sorry I personally _hate_ repeated iterations of review when
> there's stuff you could have commented in prior iterations BUT I think I
> may end up having to once we respin due to the subtleties here.)
>
> - I wonder if we could just use a helper struct to make this all a little
>   easier. Perhaps as it's realtively short code not so necesary, but a bi=
t
>   horrid to pass around all these paramters all the time. Maybe something
>   for later THP rework.
>
> - Could we exit early if it's obvious that we won't be able to collapse d=
ue
>   to max_ptes_none? I mean for one, we could at least check if the next
>   lowest order is empty. If max_ptes_none was 511, then we would have
>   already collapsed so can surely throw that out?
>
>   I was thinking we could go 'upwards', starting with the lowest order an=
d
>   increasing order (essentially reverse things) then not collapsing until
>   we can't collapse at a given order (so collapse at next lowest). That
>   might be less efficient though.
>
> - Given that we're going to be only permitting max_ptes_none of 0 and 511
>   for mTHP to start with, maybe things can be simplified - either all bit=
s
>   have to 1 or we don't care what they are we attempt colalpse anyway?
>
>   But then again, maybe it's worth having the generic algorithm in place
>   for future flexibility? Thoughts?

I'd prefer to leave the generic algorithm for future work. ie
eagerness, and Baolins shmem mthp collapse support.

>
> - How much have you tested this? This is pretty subtle stuff... it _seems=
_
>   correct to me logically, but this is crying out for some userland testi=
ng
>   that exhaustively throws every possible permutation of state at this
>   function and asserts it's all correct.

Lots! check out https://gitlab.com/npache/khugepaged_mthp_test I use
this to test a number of edge cases, gather statistics, etc.

We've also run a number of our internal CI on this including
performance testing.

>
> - Are we not missing a bunch of stat counts? Didn't we add a bunch but no=
w
>   are actually setting them? E.g. if we reject mTHP candidates due to
>   pte_max_none?

They should already be added in the generalization patches.

>
> > +
> >  static int collapse_scan_pmd(struct mm_struct *mm,
> >                            struct vm_area_struct *vma,
> >                            unsigned long start_addr, bool *mmap_locked,
> > @@ -1364,11 +1455,15 @@ static int collapse_scan_pmd(struct mm_struct *=
mm,
> >  {
> >       pmd_t *pmd;
> >       pte_t *pte, *_pte;
> > +     int i;
> >       int result =3D SCAN_FAIL, referenced =3D 0;
> > -     int none_or_zero =3D 0, shared =3D 0;
> > +     int none_or_zero =3D 0, shared =3D 0, nr_collapsed =3D 0;
> >       struct page *page =3D NULL;
> > +     unsigned int max_ptes_none;
>
> Correct spelling of this :)
>
> >       struct folio *folio =3D NULL;
> >       unsigned long addr;
> > +     unsigned long enabled_orders;
> > +     bool full_scan =3D true;
> >       spinlock_t *ptl;
> >       int node =3D NUMA_NO_NODE, unmapped =3D 0;
> >
> > @@ -1378,16 +1473,29 @@ static int collapse_scan_pmd(struct mm_struct *=
mm,
> >       if (result !=3D SCAN_SUCCEED)
> >               goto out;
> >
> > +     bitmap_zero(cc->mthp_bitmap, HPAGE_PMD_NR);
> >       memset(cc->node_load, 0, sizeof(cc->node_load));
> >       nodes_clear(cc->alloc_nmask);
> > +
> > +     enabled_orders =3D collapse_allowable_orders(vma, vma->vm_flags, =
cc->is_khugepaged);
> > +
> > +     /*
> > +      * If PMD is the only enabled order, enforce max_ptes_none, other=
wise
> > +      * scan all pages to populate the bitmap for mTHP collapse.
> > +      */
>
> Ugh this is quite ugly. I don't really love that we've converted this fro=
m
> doing the actual work to _mostly_ just populating the bitmap for the mthp
> logic.
>
> Then again it's only a couple places where this is checked, but it's pret=
ty
> horrible that what once was _the logic that determines what is being
> considered for THP collapse' is now turned into 'the logic that populates=
 a
> bitmap'.
>
> > +     if (cc->is_khugepaged && enabled_orders =3D=3D _BITUL(HPAGE_PMD_O=
RDER))
>
> I think this should be BIT(HPAGE_PMD_ORDER), I realise I reviewed the
> opposite before (or think I did) but as per David we prefer BIT() :)
>
> > +             full_scan =3D false;
> > +     max_ptes_none =3D collapse_max_ptes_none(HPAGE_PMD_ORDER, full_sc=
an);
>
> Again really quite nasty, this may as well be:
>
>         if (cc->is_khugepaged && enabled_orders =3D=3D BIT(HPAGE_PMD_ORDE=
R))
>                 max_ptes_none =3D khugepaged_max_ptes_none;
>         else
>                 max_ptes_none =3D HPAGE_PMD_NR - 1;
>
> It makes this hack a lot more obvious.

The point of collapse_max_ptes_none was to centralize all this logic
into a helper function.

This check/toggle is mostly to preserve the original khugepaged
behavior (aborting during scan phase), if only PMD is enabled. ie)
full scan vs abort early.

>
> But also, what if !cc->is_khugepaged? We're going to scan everything even
> if we only have PMD? I thought we only considered PMD size for MADV_COLLA=
PSE?

MADV_COLLAPSE also ignores sysfs tunables. So if !khugepaged we still
do the full scan.

>
> > +
> >       pte =3D pte_offset_map_lock(mm, pmd, start_addr, &ptl);
> >       if (!pte) {
> >               result =3D SCAN_PMD_NULL;
> >               goto out;
> >       }
> >
> > -     for (addr =3D start_addr, _pte =3D pte; _pte < pte + HPAGE_PMD_NR=
;
> > -          _pte++, addr +=3D PAGE_SIZE) {
> > +     for (i =3D 0; i < HPAGE_PMD_NR; i++) {
> > +             _pte =3D pte + i;
> > +             addr =3D start_addr + i * PAGE_SIZE;
>
> That's nicer. I still hate _pte...
>
> >               pte_t pteval =3D ptep_get(_pte);
> >               if (is_swap_pte(pteval)) {
> >                       ++unmapped;
> > @@ -1412,8 +1520,7 @@ static int collapse_scan_pmd(struct mm_struct *mm=
,
> >               if (pte_none_or_zero(pteval)) {
> >                       ++none_or_zero;
> >                       if (!userfaultfd_armed(vma) &&
> > -                         (!cc->is_khugepaged ||
> > -                          none_or_zero <=3D khugepaged_max_ptes_none))=
 {
> > +                         none_or_zero <=3D max_ptes_none) {
>
> Why are we dropping !cc->is_khugepaged?

One of the nice things about using the collapse_max_ptes_none helper
is we simplify the logic here. if !cc->is_khugepaged (ie
madv_collapse) we ignore the max_ptes_none value. But the helper
already does this by returning HPAGE_PMD_NR in the case of
madv_collapse.

>
> >                               continue;
> >                       } else {
> >                               result =3D SCAN_EXCEED_NONE_PTE;
> > @@ -1461,6 +1568,8 @@ static int collapse_scan_pmd(struct mm_struct *mm=
,
> >                       }
> >               }
> >
> > +             /* Set bit for occupied pages */
> > +             bitmap_set(cc->mthp_bitmap, i, 1);
>
> Maybe worth highlighting this is now _the entire point_ of the loop.
>
> I wonder if we shouldn't just separate this logic out and name it
> apppropriately? As we're into realms of real confusion here.

That is the clean up that conflicts with my series. We decided to wait
until after as with my changes the helper that was suggested needs to
be reworked.

>
> >               /*
> >                * Record which node the original page is from and save t=
his
> >                * information to cc->node_load[].
> > @@ -1517,9 +1626,12 @@ static int collapse_scan_pmd(struct mm_struct *m=
m,
> >  out_unmap:
> >       pte_unmap_unlock(pte, ptl);
> >       if (result =3D=3D SCAN_SUCCEED) {
> > -             result =3D collapse_huge_page(mm, start_addr, referenced,
> > -                                         unmapped, cc, mmap_locked,
> > -                                         HPAGE_PMD_ORDER, 0);
>
> Hmm... what's actually enforcing that MADV_COLLAPSE isn't using this?
> You've not done any cc->khugepaged checks afaict?

The collapse_allowable_orders helper function handles this.

>
> It seems that you _are_ enabling this for MADV_COLLAPSE unless I've misse=
d
> something?
>
> > +             nr_collapsed =3D collapse_scan_bitmap(mm, start_addr, ref=
erenced, unmapped,
> > +                                           cc, mmap_locked, enabled_or=
ders);
> > +             if (nr_collapsed > 0)
> > +                     result =3D SCAN_SUCCEED;
> > +             else
> > +                     result =3D SCAN_FAIL;
> >       }
> >  out:
> >       trace_mm_khugepaged_scan_pmd(mm, folio, referenced,
> > --
> > 2.51.0
> >
>
> Thanks, Lorenzo

Thanks for the very thorough review! Hopefully I didn't miss any of
your points. I'll get these changes in place before my next version :)

Cheers,
-- Nico

>


