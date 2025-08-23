Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 19AACCA0EE4
	for <linux-mm@archiver.kernel.org>; Sat, 23 Aug 2025 14:40:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 08B9E6B00B1; Sat, 23 Aug 2025 10:40:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 015126B00B2; Sat, 23 Aug 2025 10:40:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E1EE86B00B3; Sat, 23 Aug 2025 10:40:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id CAD836B00B1
	for <linux-mm@kvack.org>; Sat, 23 Aug 2025 10:40:28 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 788BE1185CF
	for <linux-mm@kvack.org>; Sat, 23 Aug 2025 14:40:28 +0000 (UTC)
X-FDA: 83808282936.02.7E807B5
Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	by imf30.hostedemail.com (Postfix) with ESMTP id A421380011
	for <linux-mm@kvack.org>; Sat, 23 Aug 2025 14:40:26 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=RgTpSXzV;
	spf=pass (imf30.hostedemail.com: domain of aha310510@gmail.com designates 209.85.216.54 as permitted sender) smtp.mailfrom=aha310510@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755960026;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OXTmM8WbRUxy55QD29FRQw973UJ9zMubKoRh6IKSvDM=;
	b=D+F8WGhrGApBCmM4ue3HJ3QjjSDqyyBlp4zqYicEjM7N8sRlHLZBZ9MAbBeVOQOoe/fVqp
	SgNOFzyA0Iep/oPOUSzVXoYfOMQLXDGQNJNNFXGZPfsDwfWv5VeK6xFsPH7FOP8+nqDD+w
	37FQUbE4d1unj416MPo5L8vPBjrHSrc=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=RgTpSXzV;
	spf=pass (imf30.hostedemail.com: domain of aha310510@gmail.com designates 209.85.216.54 as permitted sender) smtp.mailfrom=aha310510@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755960026; a=rsa-sha256;
	cv=none;
	b=1E6P9gfdsK6zk2jS9KIhjLEedeZPok5bsys5M+jaS6sDZEdahcYb2K2BEyi1jhfy/ydMx9
	nXTmretLNMVAPG9CXu5W1P809XTQA1d6kGZOUUm1FMz9wL7rCrJ0Twb+JyRBMeZDp+sf0O
	XvyGRgpPUjBmvIj1vBXnyTRl0/PCesY=
Received: by mail-pj1-f54.google.com with SMTP id 98e67ed59e1d1-3254e80ba08so967159a91.1
        for <linux-mm@kvack.org>; Sat, 23 Aug 2025 07:40:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755960025; x=1756564825; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=OXTmM8WbRUxy55QD29FRQw973UJ9zMubKoRh6IKSvDM=;
        b=RgTpSXzV8cPX79YAFk51Cz5JbP7/6K6kqB64R+aQ0TRCVGFCcJXvwHVi6O8nEFKW2H
         l2Tfeqo8NrjeFKxe6jtqYI+0XExLzwJA1wYxeUbFUWNE+ddJEPUFfDDjkG8QyujVAC+5
         XA6v0NqZTrBGxSrx1B4hOmGLN0DFlwDq4LxVY1Dka97NsxDJ0NWMHW/W680WJwH+33vW
         PbrZ5XqPXM6oEclpq6H9UuHEd64v/DarfyPG/3+GEJKjdmtj9H3X8BygJXuPNTvtSojZ
         GOId92asYiBoRW6hFSyiXS1YkPRVIcQb47nijL80PPlg30e7deLQ5SpguqEcsholP4gI
         8OZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755960025; x=1756564825;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=OXTmM8WbRUxy55QD29FRQw973UJ9zMubKoRh6IKSvDM=;
        b=cAPkpCGslJB9jk3BHnqHY0gYc0Mu1yuKpklHdSyzWmKegUabYvpZ/d6nHi1GQYcPJZ
         +A1Htrqqjkc/F7Rqb2QcxwozhcSiJZLbKhZZGjhotinzrNiePgCmy5WGY0eeUqRsgliG
         YHlCEHEXkbHjjPTOzAxArBPdq/q5BKC4jivZM/S8PSFEuDxCq44sbyP9KzSaslJLu7w4
         ZI+QAOP5A0sv2qHuRJpLxOUjq3TUU7KDNKeN1gCCDxhfxsZGEB9Hwaa/RsECc1TIgfPL
         5MwdHLVmkdZGVO0uenaottgJrRJNtoKwWo4mQmGgUI2mtUB6zrVjs2II0TEYWd0/CBUW
         asvg==
X-Forwarded-Encrypted: i=1; AJvYcCUfpUHg2xKzcmQXkC+nK/MVeQh/m5RfGelNcomdpDMg74rCvGXD/94rpRbZcKjo4i7j/sjatTMQZA==@kvack.org
X-Gm-Message-State: AOJu0Yxe1B3aiX7yNkZ9JZQ+maI5G4OGi1F0M8dBV8Xe1ucxrhkawMaG
	Q5jN5u+rNZXGyR9YRnhzVSj9kinWgb9cqhtvvlDcgGtVL2eYI/MiK9/THBhJCUP2MzY9dczkh71
	3Cs++Thp1iWt0jvdq6k/Qa9rjxTNuGSg=
X-Gm-Gg: ASbGnctqVbB9EmeldGHPHExxiLAlKRluA7eMlFbuasufYrSQ18qtfvP7lfvawxcySs9
	Zs5UQHywCxfJPcEbG9EvqjUD0c4v+ARqwPFlX5oiWVYiNOfrtD5FseaOgD8pIeb4B/10gHUk3yA
	2KmWm+gitQHAoqupAOPrwk39wOz4H2gY1LnWc00PoJhjwN48chw506QtFVnC6Pg8f11/BtQcICG
	BHjRqULaw==
X-Google-Smtp-Source: AGHT+IGc/SHtlRux5/7a430WDOIBX1I2izxIcoeV52lF/P4sb+/2zBfwOo+crSqj7W7bw303LxUrH54S8elfD8oTOPY=
X-Received: by 2002:a17:902:e84d:b0:242:d0c9:f08a with SMTP id
 d9443c01a7336-2462ee54c5bmr85587745ad.20.1755960025422; Sat, 23 Aug 2025
 07:40:25 -0700 (PDT)
MIME-Version: 1.0
References: <20250822180708.86e79941d7e47e3bb759b193@linux-foundation.org> <1757f780-0228-476c-a5a0-ed980209852d@gmail.com>
In-Reply-To: <1757f780-0228-476c-a5a0-ed980209852d@gmail.com>
From: Jeongjun Park <aha310510@gmail.com>
Date: Sat, 23 Aug 2025 23:40:13 +0900
X-Gm-Features: Ac12FXz2zs8kTDdt8Rbe1nTLMLdadJ6bdQycanM4Z2NyQ8xBX2zy3f6pxKsXVCg
Message-ID: <CAO9qdTECQWV6E-sor-5o8xp56knF5LpReszsG4WpFbDKTiyY1Q@mail.gmail.com>
Subject: Re: [PATCH] mm/hugetlb: add missing hugetlb_lock in __unmap_hugepage_range()
To: Giorgi Tchankvetadze <giorgitchankvetadze1997@gmail.com>
Cc: akpm@linux-foundation.org, david@redhat.com, leitao@debian.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, muchun.song@linux.dev, 
	osalvador@suse.de, syzbot+417aeb05fd190f3a6da9@syzkaller.appspotmail.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: A421380011
X-Stat-Signature: uikq5q1mr6mjzbhpw5pwu9uebp3gokkx
X-Rspam-User: 
X-HE-Tag: 1755960026-5547
X-HE-Meta: U2FsdGVkX1/aMBDtE/5DWcj6TmPb/qRi3KCSLvdc/1ohrfandtJg6QaBAi6uHAelfWDwCSGoOezGNQKjiGIeDeSDtV9orxLSXmQrSCoKTPPzHL5h7bJx2sLMyMLQhyq95izp3NasFrj3fB/A33DfB9fB2NubRe6oq9krb9Q54BFHFPUhGt6IDXmKrjCEjrDxXAomfG82Nd7v2qhJ7RyEP7oRqRmkG6y0pD78IwEw9INRctaBW0WSBlb+xbgMS5dXriu+i5LDgeiGFvEN96+SrYlVBHcr8HylouTxbsLp6uYXuEVkBJdwvZ0vKimbw/MJDbO+c5yK1K6VVx18EqNPN+nPDZlf5MgODcjy+5lPt1z9dnPM04A3i6VZ5b7zHizyPbWcIe+trQe6V2RbOfo5ttXIHuMsyfIXkkJtJIpfxW0yvkHGJ9FEJV5pJ1rcfLBb2gP0bJn/5sSmW2mpth3r3S5TqPFNUImPv26lgQxx6ytR0c1UL3zshtZqKQTq4ckzcf7eFZMiB1bXz0gDRlxtRdV2PnrgAVBWl93byLYwgobxq3eygVud4A9D6mln9fnUdAMLe2S2hbduUBwIeIos0vHC25KOC+eKGGIiXykIV22zMQy5/ZjFIXg1u4H3eptq08OPV2RFaNC4a0oMRdYq9AYGVx9jRYQO0u/SSGyWi0qm3bc5RSV/rw09XQjo2iEe+cR+cpZnoCmQZw9NypqjDLNqTNyUDyw4N05IwfxXqTy3OGUHkrclKKwqciqCRp0lSA09elSA1TTftKYjEwad/gP2CpXX3VaaMJuc3kQF1H6z4hRdnq15VA5MLHUHG1YE/5Nk78fo1o9LcAhWBT2LbWvkVnooUeN3RtpwMN4ACLIrOoc7+o9jnC7ap/0QEXsL+909KiOpFvR1gjzGODHRfsM5yMMkL1/vtgMg3d3EBeJZ1Bk/A6knegUd/CSwxJmp4hOVhoAiMPp8QBfS9D+
 KGQo7hcX
 va2mQVSgU9JpJ/5vulbAeQqUUo1/J5+485lq2+UAc7Y0jDy2QQqOQSmRhlU30fTs05ybi98B9WVWx7KmzGY079c1dQ9nyRmIrVYYlWkwf69AypGbLMWoIIandJHw86fBKEzYSqEUsQmEP6IFdpBxwDcFZjDUkI7ME21HWnqXovjhssF7ytMiRFWMtAwr6pqisK1MGMTuOsbaJfdrmvV8YtdMhwWZE86PAAD2zcLbNA2QUf2+HcS8zguk28MqA2AHkkDT2TQFzoiNujLfKHvtNPiJ3VQuQ+6CoqdBcwbYsJ4gf3x18TrN9S44h/p4Vdo2Cuehhi3D+I6+fh8ZbQ0lo9TCtTA3W9pl7pjDZUgnxsMEaDcEOrs8edrpd3yCjo96M2W637Qm59I2LDcfvk0l8I7Ij8N1DQTSOU0vINPGRZdANvm0uoQ5MhhaY2zLhBaORdbfdf5cw+h+G3NVskeCL6ys+eM2PY2OKI6kC2SUu4bCKHqVrfwvE+EE8znkWneRIV3iMZxRZ7SIjUkg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello Giorgi,

Giorgi Tchankvetadze <giorgitchankvetadze1997@gmail.com> wrote:
>
> +               /*
> +                * Check surplus_huge_pages without taking hugetlb_lock.
> +                * A race here is okay:
> +                *   - If surplus goes 0 -> nonzero, we skip restore.
> +                *   - If surplus goes nonzero -> 0, we also skip.
> +                * In both cases we just miss a restore, which is safe.
> +                */
> +               {
> +                       unsigned long surplus = READ_ONCE(h->surplus_huge_pages);
> +
> +                       if (!surplus &&
> +                           __vma_private_lock(vma) &&
> +                           folio_test_anon(folio) &&
> +                           READ_ONCE(h->surplus_huge_pages) == surplus) {
> +                               folio_set_hugetlb_restore_reserve(folio);
> +                               adjust_reservation = true;
> +                       }
> +               }
>
>                 spin_unlock(ptl);
>
>

Why do you think skipping restoration is safe?

As specified in the comments, if scheduled restoration of anonymous pages
isn't performed in a timely manner, the backup page can be stolen.

And If the original owner tries to fault in the stolen page, it causes a
page fault, resulting in a SIGBUS error.

Of course, this phenomenon is a rare occurrence due to a race condition,
but in workloads that frequently use hugetlb, surplus_huge_pages increases
and decreases frequently, and backup pages that are not restored in time
due to this race continue to accumulate, so this is not a race that can be
ignored.

>
>
> On 8/23/2025 5:07 AM, Andrew Morton wrote:
> > On Fri, 22 Aug 2025 14:58:57 +0900 Jeongjun Park <aha310510@gmail.com> wrote:
> >
> >> When restoring a reservation for an anonymous page, we need to check to > freeing a surplus. However, __unmap_hugepage_range() causes data
> > race > because it reads h->surplus_huge_pages without the protection of
> >  > hugetlb_lock. > > Therefore, we need to add missing hugetlb_lock. >
> >  > ... > > --- a/mm/hugetlb.c > +++ b/mm/hugetlb.c > @@ -5951,6 +5951,8
> > @@ void __unmap_hugepage_range(struct mmu_gather *tlb, struct
> > vm_area_struct *vma, > * If there we are freeing a surplus, do not set
> > the restore > * reservation bit. > */ > + spin_lock_irq(&hugetlb_lock);
> >  > + > if (!h->surplus_huge_pages && __vma_private_lock(vma) && >
> > folio_test_anon(folio)) { > folio_set_hugetlb_restore_reserve(folio); >
> > @@ -5958,6 +5960,7 @@ void __unmap_hugepage_range(struct mmu_gather
> > *tlb, struct vm_area_struct *vma, > adjust_reservation = true; > } > > +
> > spin_unlock_irq(&hugetlb_lock); > spin_unlock(ptl); >
> > Does hugetlb_lock nest inside page_table_lock?
> >
> > It's a bit sad to be taking a global lock just to defend against some
> > alleged data race which probably never happens.  Doing it once per
> > hugepage probably won't matter but still, is there something more
> > proportionate that we can do here?
> >
>
>

Regards,
Jeongjun Park

