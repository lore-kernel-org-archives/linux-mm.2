Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BEC68C55184
	for <linux-mm@archiver.kernel.org>; Tue,  4 Aug 2026 00:48:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DA83B6B0092; Mon,  3 Aug 2026 20:48:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D59936B0093; Mon,  3 Aug 2026 20:48:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C6F9E6B0095; Mon,  3 Aug 2026 20:48:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A06B36B0092
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 20:48:51 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id AC7CFA232D
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 00:48:49 +0000 (UTC)
X-FDA: 85061751978.19.5C3C61F
Received: from mail-qv1-f43.google.com (mail-qv1-f43.google.com [209.85.219.43])
	by imf24.hostedemail.com (Postfix) with ESMTP id 50E9A180009
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 00:48:47 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=VbNm8KMC;
	dmarc=pass (policy=none) header.from=cmpxchg.org;
	spf=pass (imf24.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.219.43 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785804527;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fhCGCaK49uagUD7imDkxOfoEL3Kga3MWTIAM0kr2GOE=;
	b=HUHB3oZNHssnAT0ffBh6agBkf97Q2YtRN1KvNkHU+dGYED0QdHLBuaGVxq2FQb5Z0lEYtW
	Ww0+z8HuWHdUAZNLoLJZs+0/OVlaTSzgLUyPxkq8mOMhEoRcoccYgDL4/8Si/R/MRCUVHf
	kYWuo7rx+qBy7qUn4h0oKkSmT5RW0bs=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=VbNm8KMC;
	dmarc=pass (policy=none) header.from=cmpxchg.org;
	spf=pass (imf24.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.219.43 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785804527;
	b=2Vr390sozpHA9+4+Ppcuw347V3iuQb0hyrVb1b7s6o9jijNeS6Rlczw591K8o/Z6ei3LDm
	iQEGskup6IQZavNykvB/SHh/ij4Ri6BJDw+lMLSo13we1YpOjTRaOrympp/1DC3mzc28ft
	RbXG1Kc8QfA7GTG4xPfKPdH1f5uTnEQ=
Received: by mail-qv1-f43.google.com with SMTP id 6a1803df08f44-8eeb4508f29so27783136d6.0
        for <linux-mm@kvack.org>; Mon, 03 Aug 2026 17:48:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1785804526; x=1786409326; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=fhCGCaK49uagUD7imDkxOfoEL3Kga3MWTIAM0kr2GOE=;
        b=VbNm8KMC16+w6fwFsIEy04o9WBXlvVguKDwanBei18wFqECNNoMuFlEFXmm3BQR/Zr
         Sq89ZC9Wou0bE1C8i+a3dIvV1QqHKHj0nWzuR0RPeKjF+SpH1Rk9h1rh7EBoFdIwA2by
         Ub1gU5gFESAG0NV0FbrabYbf3rP8pioqqEqv0k7U+S5obLmbZfBKtvammTvffNIZfsBJ
         MDCirmtfVBKdlGfndMvTHjldpbbyIV3mWkmx59XmZHzQEuhErCSnooMcpOL6FAEwxYXa
         WFkNuC1Rwwj+RZSWd5t9gfdFQe8MBiUG8sktj55LD59ARK2kpFJPiReeYG7N+M7bzsJy
         XbBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785804526; x=1786409326;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=fhCGCaK49uagUD7imDkxOfoEL3Kga3MWTIAM0kr2GOE=;
        b=DEpxRdra+FHEAFLGuaqiwDkqzcLdZc4M0Fh05tIROlB2v4jfldgIzHWFD8oow0FwCw
         fOvLP9SQ8kU2KNCoFs+h+5z0wWZZ7t97fH7fuhEhYZmv6oHHe8Dd3dBWz2sMuVY1xj43
         9kp9rVCsrc202Y0DZpdiBdn9wdGksWKvWtwpYHMNtbV2hNnt0r+xXDW5bfriLSXgVORL
         EnCpuJLcwwr24rlFjhgIpfm83ikcUHNOZqYn0ug/0OzXfW+odPHLktEAk8Eqxi+skZQr
         8W0kNz935eEScL7H0WSemiMlhWpxNGIrMzOK9HfUkT9xRMkwiPoSiu4GCHCCxAIpSosH
         GT1g==
X-Forwarded-Encrypted: i=1; AHgh+RpuWyUmtjjpD7GMxTxjWxeIpKjPPLiaKWvY+aPh8tN7QsDXItpXM/m2DcDKhr3ll1JQ6j1tT7ZtbQ==@kvack.org
X-Gm-Message-State: AOJu0YwFg7i51ftUC49gHu2eKRG+Xq+lISqL9nLYKGuK4cr/s5uT9LvU
	OUYQ70trpzdETH5PVHmuu5MhX/QkuIGpp9731IuNbKklBydVs1WZLvVzkoPLKZpPzJI=
X-Gm-Gg: AR+sD10whfQ18IHszxTs8I5lWZNU3m3exiMq9xZKEr6QFuLciUdP7ZbrOm3kG1gbkNH
	79MTX6c5KgszSmbLYAk4y5tEoiWI/CszJwoHc8ikuIMO44gY8B0JeyfRjSewFUZGhEISGjWL3B5
	6hSzPl/I83G0XKX3j4p+GMu494C1QMl7gxT0HtTp7TqqHOzxqNRauKtvrWqlIyHSoJULFLYrZAZ
	ZOmyVZe9/Qhc2GUtKDKYKYSTlHSa45QW3Mf5RlSF+oKqH4tDK2Hfe+GoJ9ltD4jvacw5fny10Zl
	+xnki3UENwxo7A07lSLOlH5evb5n5ITd6qlTJJJu2Oi0SZ3gGXIFENGfS6u3HmEC8r8se0QljaT
	WNN0dSfkpPgJcokK5gvmYCrz7upIF5F4CcFHWlB6MpKkZAVEAwmlviRtHvN2HQBrRjTBdk3R5dT
	L6qUOT0pJSPsoMJSmse51RYOzNGdjqR/8BuKPUYBRiZxoUWa1vAvMIEgFEH9/3VAncPhbmCwM=
X-Received: by 2002:a05:6214:3f8e:b0:907:82de:4309 with SMTP id 6a1803df08f44-9084955465cmr283053076d6.2.1785804526092;
        Mon, 03 Aug 2026 17:48:46 -0700 (PDT)
Received: from localhost ([2603:7001:f100:500:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-908434a2bedsm87692976d6.17.2026.08.03.17.48.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Aug 2026 17:48:45 -0700 (PDT)
Date: Mon, 3 Aug 2026 20:48:44 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Barry Song <baohua@kernel.org>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>,
	Joanne Koong <joannelkoong@gmail.com>, akpm@linux-foundation.org,
	ljs@kernel.org, usama.arif@linux.dev, alex@ghiti.fr, ziy@nvidia.com,
	baolin.wang@linux.alibaba.com, liam@infradead.org,
	npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com,
	lance.yang@linux.dev, vbabka@kernel.org, rppt@kernel.org,
	surenb@google.com, mhocko@suse.com, willy@infradead.org,
	linux-mm@kvack.org
Subject: Re: [PATCH v1 2/2] mm/memory: add anonymous mTHP folios to deferred
 split list
Message-ID: <anE27CtvCFx7sAuO@cmpxchg.org>
References: <CAJnrk1Zc1cZa5edmb6Z18nO3xfLBww-7wobxkOe2OJmWE9qzpA@mail.gmail.com>
 <7da62e60-6ce2-411b-acaf-f9f77ef34752@kernel.org>
 <amoWjOnPayHVQU9v@cmpxchg.org>
 <b93cde83-0ce3-4db2-8e53-29864027d655@kernel.org>
 <amtv0YRbSrN6iUEo@cmpxchg.org>
 <CAGsJ_4yWAUcXmVr7Oe1V42szqi2Od-0MhDBspNKURZcBnub9+Q@mail.gmail.com>
 <amy5ZKC2Kc7RX94Q@cmpxchg.org>
 <CAGsJ_4xhbEAiLFt-3N7738zJDoJ=hPRYLpP3tpU2sGOz=ORiaQ@mail.gmail.com>
 <anCpdjEoDNgVbfzP@cmpxchg.org>
 <CAGsJ_4x86EYsMz_n2NKDwTqeiv2pi4AcZb1RuZoBeUBR1iFqOA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAGsJ_4x86EYsMz_n2NKDwTqeiv2pi4AcZb1RuZoBeUBR1iFqOA@mail.gmail.com>
X-Stat-Signature: 8ytojxnrc7i1s6u1dwbzpo9gtnfqnbfg
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 50E9A180009
X-Rspam-User: 
X-HE-Tag: 1785804527-804035
X-HE-Meta: U2FsdGVkX1/GikblynSkCxJcgiXKpzjVh0OPliieta790Sz7tNfjvAcepqKxFQl2wx+TmCjBuV80QI1hEm98M7lU9nMNjuKz01Ghf3b1wWH3R2aj5/72/TxvtQMjFoyVnEl1CPFgUQ4+IDzm+ppn14Sjea5ZCqv68i9L4dSIWqzccqPA7KDEYFDM9eOKCBWTO+PXC5Cob0Xf3TN2r0sC+shMfL1myvOufXSDnyDqzkO/wsjOQRcseC7eYfCqkNdS+aRVq4w72r2wPtTzLCs0qotVSd89xVkrPoSrOVXkJkYvc+oOi79bw8yWwB99avOUa5JFt4HMZdPQsAKtAu3KWtvrDsHy9YIwmjsWk754DAJThPx/OHlMKxFsuKFdwzOM8H1tH6xCZ0EjBHG8vFabxM/Y5PKYrLhAwyBNBfPc5XsaMfAOoiTbN8lmrTOfBUQK02yPmlCDHrX8XrwsOMuzHXO/63vxVKLpKDejknd6LUemzmx6BMp56m9xTnejwO0n9DutEUL4TeL6oL4KhMe/UKXzS1wyT1cdfYBhSyaib2uGZ1l75VFmxNroD2gCfpGeIgcGPSFnEaIGPaDWH4wg8aYr6BAfQ9Z0iIFpqfb5e/kUBRtEI0Fgh/E2syXpQi3w2yjV6JnxQczHfKvuj3xzONMoyQj6HjSjynhBhLkon0PPrfQgj1j8AGHaG8MZ+s6UTKPnSi+bw87DbyJgNuFLqNe4BfUxlcL0ujtcG4cU+Z7T4MzgNbZu3HwaTydLcez27xCC4su7HlmHJW9KHvueGblqovHZ5GmAh1gpBVt6cSitsA6xyAF6+Pn5lnntQfyTeC+VaodCQ8npP/35OKJr7gGfSDcDKFUkAcQhhGdx/tmq3MgjyfVqLKE+AbQvYpwo9nRMh4rOt/iNoCbc3cDbWy5mpXPTNhxLaJoA2TUyr72YxVLhU8FL8+U2aZhuX5xCLt2UEBo3CZiX2ktUzPt
 lZx8TWAf
 q33BYIyX8btj0QfGU0ZAMZiEm9i4vicYroKx4FvRWGYMV7F0onYH/o8sOCjGeM+o/HfqLIbEvJlg30cBVet1sOtfIaVaw/2MKB5ZBTQFGdNdBGq12SfdTR5kRSZ7BcLVJbL4bbE2dlmModfcu7mQ2NNM6qXdheoQsWoYAVjrC7+etra6san7CFcFTUKUjDVZkVp1s5OzjBkR4qmzn1fja0zlTC871Wy6bQFcFxH/+jpWzt5kAE+Gt6qgma7fr5BjNV5hzzuPpFcRg/803N07XZMybjHGKC0qIc/2iMV4+6KoAKdBbKl+ZN/rAnSUconkRLNfu4VF7OzJXywIwWBRAgj/M/SRlHXbMBbDO8RLx/gs5UTp6h/PJi+10i8/IommphvvrIbaauGdi0zhGD3JBAezhOmPyR3etMAxCuHWPD3fYwk5qKZpkoY0hJEk4jN/YZ36BC3ras8nzy+s=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello Barry,

On Tue, Aug 04, 2026 at 05:20:00AM +0800, Barry Song wrote:
> On Mon, Aug 3, 2026 at 10:45 PM Johannes Weiner <hannes@cmpxchg.org> wrote:
> > On Sat, Aug 01, 2026 at 03:33:42PM +0800, Barry Song wrote:
> > > On Fri, Jul 31, 2026 at 11:04 PM Johannes Weiner <hannes@cmpxchg.org> wrote:
> > > > Here is an idea: the THP shrinker will not consider anything unused
> > > > that has <= max_ptes_none zero pages. See thp_underused(). Joanne was
> > > > proposing to scale this knob down relative to the folio size for mTHP
> > > > shrinking. What if instead we kept the meaning absolute?
> > > >
> > > > The knob is an expression of how much waste the user is willing to
> > > > tolerate per folio. If the folio order in question couldn't possibly
> > > > have that much waste in the first place, we don't have to queue it?
> > > >
> > > > Something like this:
> > > >
> > > > diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> > > > index 2bccb0a53a0a..1670e9869bd3 100644
> > > > --- a/mm/huge_memory.c
> > > > +++ b/mm/huge_memory.c
> > > > @@ -4364,6 +4364,9 @@ void deferred_split_folio(struct folio *folio, bool partially_mapped)
> > > >         if (!partially_mapped && !split_underused_thp)
> > > >                 return;
> > > >
> > > > +       if (!partially_mapped && folio_nr_pages(folio) <= khugepaged_max_ptes_none)
> > > > +               return;
> > > > +
> > > >         /*
> > > >          * Exclude swapcache: originally to avoid a corrupt deferred split
> > > >          * queue. Nowadays that is fully prevented by __memcg1_swapout();
> > > >
> > > > The setting defaults to the PMD-1, so out of the box we wouldn't queue
> > > > any new orders. It would allow that 2MB on 64k ARM usecase, without
> > > > jeopardizing smaller mTHP usecases like Barry's.

^^^

> > > My understanding is that adding smaller folios to the deferred split
> > > list is not the right approach. We could end up with a very large list
> > > where we cannot distinguish partially unmapped folios from fully mapped
> > > ones. For example, the deferred split list could contain 100 fully mapped
> > > folios but only a single partially mapped folio.
> > > Moreover, for smaller large folios, the number of zero subpages
> > > is likely to be small and short-lived.
> > >
> > > However, this is probably fine for larger large folios, since it is
> > > unlikely to significantly increase the size of the deferred split
> > > list. In other words, the deferred split list should remain manageable.
> > > For the same reason, larger large folios may not benefit much from the
> > > LRU cache either.
> > >
> > > So if we have some mechanism to prevent users from doing things that
> > > are not beneficial, such as adding smaller large folios to the list, it
> > > seems reasonable to me.
> >
> > Just to clarify, we're on the same page, right? I was proposing a
> > mechanism to do just that.
> 
> For example, with smaller folios, the distribution might look
> something like this:
> 
> Smaller large folios
> 
> +------------------------------------------------------------+
> | F | F | F | F | F | F | F | F | F | F | F | F | F | P | Z |
> +------------------------------------------------------------+
> 
> F: Fully mapped      (dominant)
> P: Partially mapped  (rare)
> Z: Zero subpages mapped (rare)
> 
> So it doesn't make much sense to add them to the list, because we
> would rarely find P, and even the few Z entries we do find would
> soon be filled with non-zero data anyway.
> 
> For larger folios, the list becomes much shorter. As folio size
> increases, they are more likely to contain zero-filled subpages:
> 
> Larger large folios:
> 
> +------------------------------------------------------------+
> | F | P | Z | F | P | Z | P | F | Z | F | P | Z | F | P | Z |
> +------------------------------------------------------------+
> 
> F, P and Z become much more evenly distributed.
> 
> So if the folio is large enough, this seems acceptable. I know a
> sysctl knob may not be well received, as it adds to the user's
> configuration burden. Perhaps we could just hard-code a
> sufficiently large value instead? for example,
> 
> #define LARGE_FOLIO_ZERO_SCAN_MIN_SIZE SZ_2M
> 
> if (folio_size(folio) >= LARGE_FOLIO_ZERO_SCAN_MIN_SIZE)
>      deferred_split_folio(folio, false);
> 
> If, someday, people find that 1 MiB also helps, they can provide
> data to support it.

I am very confused. Did you not see my proposal above?

Why not this?

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 2bccb0a53a0a..1670e9869bd3 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -4364,6 +4364,9 @@ void deferred_split_folio(struct folio *folio, bool partially_mapped)
 	if (!partially_mapped && !split_underused_thp)
 		return;
 
+	if (!partially_mapped && folio_nr_pages(folio) <= khugepaged_max_ptes_none)
+		return;
+
 	/*
 	 * Exclude swapcache: originally to avoid a corrupt deferred split
 	 * queue. Nowadays that is fully prevented by __memcg1_swapout();

