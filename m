Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C4DE7C55184
	for <linux-mm@archiver.kernel.org>; Mon,  3 Aug 2026 14:45:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B84B56B0098; Mon,  3 Aug 2026 10:45:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B35876B009B; Mon,  3 Aug 2026 10:45:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A25AC6B009D; Mon,  3 Aug 2026 10:45:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 779CE6B0098
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 10:45:19 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 13720A20FE
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 14:45:19 +0000 (UTC)
X-FDA: 85060231158.04.8405C12
Received: from mail-qt1-f169.google.com (mail-qt1-f169.google.com [209.85.160.169])
	by imf29.hostedemail.com (Postfix) with ESMTP id EA18C120016
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 14:45:16 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=dt4GVxv1;
	spf=pass (imf29.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.160.169 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785768317;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PaeMHIJaycn1HEDpr/OGJqFqNwGvvmZQ0c3Zz58w9Vs=;
	b=v8Uyu3UJTmhX8EDvgslhnsR938dXnT7zKiYJ/AIQxg+YzAhEYxNrGpW3h0hnyR1+o/TjWw
	UuEo0t9GXhVUwtEd3bJyylMPV04ndIHgeA19kuSicFIPNy81p0xg+jEXb7acIAsnkpAFyS
	3aHIoxY+C/3iEMQKqTCceHyzPiI0z+k=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785768317;
	b=BKK4L8nXYx27vmnWgmxN9qzCSwFSQ3S4Y2/Ar/r0gSpSqvNAD6IOY+gBb0jKykRVbjCQrf
	Oo0FJS0a4qTAWGm5vBbZnSnzRd6w0hKS2oM8nNIGLZaXXtrdWGXphvHSEWvlsaa0vtCuMs
	Z1R7Ih1+/ijCNOoXBBHjQm27Ee+44yM=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=dt4GVxv1;
	spf=pass (imf29.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.160.169 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
Received: by mail-qt1-f169.google.com with SMTP id d75a77b69052e-51c1372f84dso19455921cf.2
        for <linux-mm@kvack.org>; Mon, 03 Aug 2026 07:45:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1785768316; x=1786373116; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=PaeMHIJaycn1HEDpr/OGJqFqNwGvvmZQ0c3Zz58w9Vs=;
        b=dt4GVxv1KrkuZGkR69CgrENuQco0MmhKsmUYSjSD3rEJsQCkBPfZ++0L1Rp3CerhE0
         vfv27z4buatGiayqpY4CcPTtXXBTn3lhyWhCvnqMMzZhSfDTFT2FkffnG4Q2dLoG1gTp
         7BmR5t0kIhMIZyQcH/VANFO74xsz6CzhZLsiBM7TB/DH+1PXqT5Jw3UdCE7T8FqAJbgo
         C/FxFELoVWy9zzLvTOP9bYiXWHEz/54nq4m3sNRTmE0H6Xp0Fwiz+LFv1YQxOLF7hq3m
         +DZsyAcYl07iL0moG0NcYr9WZfijUc1EBB1Gxbb1/tLXinFf2wjhQ/Anu8Hqe+ZQ+Gil
         rnYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785768316; x=1786373116;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=PaeMHIJaycn1HEDpr/OGJqFqNwGvvmZQ0c3Zz58w9Vs=;
        b=eEDT3UIJjbtTMYzWV9a1g3xvkGrhpBauhV6GUoXZDEa9LUWG7BOjKDev79ejqzsjIl
         oNWSJ3gUXtYI7WybMtkZbzWfuB7/ejefmVvMHdcbsin/SjGKBy4f8ggR9oVYeT6zD5wP
         ssTr06SzGualrBUXOy2JFFrINHW0nC9WMACygKjEcNuuP/LJ4nriMO8Ietf1m4fBBbZi
         LwT3stzcJpJzAnVn82PCbR4qTR/bX8pBwvRXW9D3Av54V5U51e659EfRU3z9JktdAaza
         Satb0ZM46+JNFhc3tM+WpmAHPZCprSjKizHDcc7WLMggW/cID2fu7cPCp8ZxLgDTz7ka
         S/tw==
X-Forwarded-Encrypted: i=1; AHgh+Rowg5lLZAZAOV8MNZWCH/8gn5G0k3PZHXz0cVe4IZ5cVqxtTavXOarp3OJG7cVK4H8vgfuRHAZJ2g==@kvack.org
X-Gm-Message-State: AOJu0YyC3R/XT5de6U6lBfL93vvbCh1dVtq1YQXb6HQgSkRauxN7Lf9i
	h85eWE4zI1O3S3c7l37xkBOYPxaC8U5QCZfR5n8OJS5awUEcKUkfekb1hVyM4tYKBTI=
X-Gm-Gg: AR+sD13Iv4smhpFdS8+c6hXkQYM9Wyq9wrOFjxK3rS63A4Zp57tDB56sZJJuk7SbyM4
	rd++eQ8h1yc/26GOv6rH96ZEWEMCWOEDNk4eKEiQFWPm7vnY+8Xw3+48kL4Jpoe/P1+VUM6C7mM
	8jPQu8EJr4dgsLoy31bQwRo+fw2/mOejwQ1qz6ZMfCerAqWAzqqnDSpOLSYarOedlHerY5hvjIH
	nbFUsjHol+S/+dXeRpCnWm6k6rpEhwm5KRTzf+H4MZ976ZjYK59hBamFXZ4v5JavE83vNEXGq5f
	Or9dQGNrIjw6xDe2LscR95TN/9LhAmwmsIMg50dVMmo00hrEX/jULu3JjzE/1yVh5hYP5zNCbWo
	SN1WrK1SEUDLONbmdcvr4uiWBOKlYE3Gtz3gvRPGaTULF17O4EW/LLJyV/9VBPIuqmNw6Y5vsAN
	B1VVwVmkhym5pXrXIQbN5kHaEdl2+U9xsj5Msyy2avtZKOMDD7h3Q89WX9ioGP
X-Received: by 2002:ac8:5d54:0:b0:527:6d4a:1970 with SMTP id d75a77b69052e-52b567d9fbamr180182431cf.38.1785768315103;
        Mon, 03 Aug 2026 07:45:15 -0700 (PDT)
Received: from localhost ([2603:7001:f100:500:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-52b4eb6a862sm63659371cf.16.2026.08.03.07.45.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Aug 2026 07:45:13 -0700 (PDT)
Date: Mon, 3 Aug 2026 10:45:10 -0400
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
Message-ID: <anCpdjEoDNgVbfzP@cmpxchg.org>
References: <20260707201735.4113107-3-joannelkoong@gmail.com>
 <584098de-dd48-4004-8e7e-3d826e60c860@kernel.org>
 <CAJnrk1Zc1cZa5edmb6Z18nO3xfLBww-7wobxkOe2OJmWE9qzpA@mail.gmail.com>
 <7da62e60-6ce2-411b-acaf-f9f77ef34752@kernel.org>
 <amoWjOnPayHVQU9v@cmpxchg.org>
 <b93cde83-0ce3-4db2-8e53-29864027d655@kernel.org>
 <amtv0YRbSrN6iUEo@cmpxchg.org>
 <CAGsJ_4yWAUcXmVr7Oe1V42szqi2Od-0MhDBspNKURZcBnub9+Q@mail.gmail.com>
 <amy5ZKC2Kc7RX94Q@cmpxchg.org>
 <CAGsJ_4xhbEAiLFt-3N7738zJDoJ=hPRYLpP3tpU2sGOz=ORiaQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAGsJ_4xhbEAiLFt-3N7738zJDoJ=hPRYLpP3tpU2sGOz=ORiaQ@mail.gmail.com>
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: EA18C120016
X-Stat-Signature: d36mry8w346m9y7fwckcusof56c3edpz
X-Rspam-User: 
X-HE-Tag: 1785768316-281816
X-HE-Meta: U2FsdGVkX1/iX8lYdZTYz79J0sUmP8YEGb8QQL6DaymBRLibLWtbTMuZYJjAIiiybuHXqyg2lxthMn6H6HvjdIIBh8SJaIcPe3GjD+u4ZcaRUQsJ0NKlXqxnvTTEXcXQc92x47CFe1paDIr1bqdgC83Cg1ecjL8oWrfWjPxiVhl7IC2Zc848SzlQo79xY/TrbZVbkmmn5bm8QsDRpUZYk+Nzs7KSkJRwkDCqECfyJ7ZeqDAiJdla9ANmFzBCPtOR2wPEMItf5ccYAGuEht/m60a6wMrHaNKt7iwwwlRApMBMnNzVgqvM50pKveZ6jbKMski1uO2AHM6j5no1LiSCXtEcTeotW3zfkAlvHbJNhcpukOZn2nqYk9dzyohdTjtFeQ0uqu0YBXfos9w27m+8//9u0aHkla4iNWb/TItikWRvmk0GbVlcfSrPhtIIZ5BQyGzGxNzuZ5lapTH/LZkjTg3nqDKxr1bfq3Qo9q88SPWbyNeBKCmkp/hvY5jea0sshP1qnZPsLiKOCnV2LZOfi7sarP6YSEdNDL6rgazgFmfnaEaGH1ZlxfY56ycUhVy1mtBzIGSRE7M9+lB8LXg/3ZOPBaJoQF9WdG3SYoGYMsmVDX5yNZrl8kZecMZs0nLRUs4xEqPn5uN4g2hYgVDKddoKcrBKsyLHRFQqgK+4A4Uib5KgD3zsRNwl9JXdz+1lHiKImwbjV87L5Rt2TwOCHrCNoANAcykXxZqPN5Y/ZbZHlWt8ez8PTK/gKCbyOBuuPJsvkIYYgdzYiY9iQWG7VNsktOXlykQTHTwZ0Oy4bv2erBOItMQWfevdJJrpLt/lvNnR4j3/OYFSALbRAdQknjo5w3fah+NGP5BO83wsfeI8ghu863gOAsQkdLcUh9zmBlUEUxrsWy2ea7R8d7aDciHO4v4+WeYlPm3NO4wUPAYo1qEzABkxmWcAovbiR+xTnmLlzWbbp88RI4hKgPu
 bwRyL31X
 n2W1ihQQr6TyqdXtB9VsrWgD//kIH8QpGDWUco2Pp5vzOK5/Lzl16BXlc5LvAlXONivZI828NfaIzpSGd0hJTzyIpnW+19WMZs7i2dT+/+uEw9pBZ/a3iSeV/ppNzaxDZPbWRVnJRlTuF9Vk+frg1HbhmtwrGg7YnnV1/ME5wryy8iajfF+zIPd+yypqqpxxgBE+LvbWOWKfS2o7Nf9uxUA2sfGIbWsaOd3cfRcDleXhWLcFiY6QMDiLy7O9+t6TrHQltkAQvyVbLe73g1J47NTHdemgnUojfa+sJaJPAw/bgR6GLxw0QJmoPcdEwo86TutiXeDoQutle/BpCDP/z2dpk12p4cKrNOj1VVOlWNw0qkaKavl2Gg6sOw2QWzL3gZImgh3Z/8RuOYdJMTftH4L3d03M3uXGN+0bHO8Ol6Lz2m8J2E/Zo2n7DbBMfsv4jvFLvTbMetLQFZHU2aqmiuxDYGgkD+yjbFx1f8cnnA9gVfGVyxQixby8Kmg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Aug 01, 2026 at 03:33:42PM +0800, Barry Song wrote:
> On Fri, Jul 31, 2026 at 11:04 PM Johannes Weiner <hannes@cmpxchg.org> wrote:
> > This is kind of tangential, but I'm curious if you would have
> > experimented with larger folios AND the THP shrinker?
> >
> 
> Haven't tried it yet.
> 
> A key difference between Android and server workloads is that Android
> typically has many applications running with frequent
> foreground/background transitions. When an app moves to the
> background, much of its memory may be compressed. When it returns to
> the foreground, it often allocates a large amount of new memory,
> creating significant memory pressure.
> 
> If we need around 200 ms to cold/warm start an app, allocating 2 MB
> folios and later splitting them into smaller ones via the THP shrinker
> could cause us to hit this shrinker path directly during the app launch
> process. For example, we may spend the first 100 ms allocating 2 MB
> folios and then the next 100 ms shrinking them back under memory
> pressure. This would be quite ironic for Android :-)
> 
> Since Android app launches can demand a large amount of memory on
> devices with limited RAM, keeping burst allocations small is also
> important.

Makes sense, thanks for the insight.

It works for many DC services because it's just a bit of extra startup
cost, while then getting predictable THP coverage for exactly those
areas where it makes sense, and the TLB benefits pay off over long
service runtimes.

> > In Meta, 2M thp=always without the shrinker would also not have been
> > tolerable. It OOMed immediately on a large number of services. The
> > shrinker *is* what allowed us to use such large folios to begin with,
> > without the internal memory waste problem.
> 
> My understanding is that Meta's use case is a service that is already
> running with 2 MB pages, and later additional services start and
> require more memory. In that case, shrinking THPs from the existing
> service to free memory for the new services makes sense to me.

It's simpler than that. We had existing services, scaled to machine
capacity, running with basepages. When we enabled 2M pages, they
started thrashing and OOMing from areas with poor virtual packing.

The shrinker makes it possible to run with THPs enabled, period. This
is why I'm concerned about making the search for waste less
efficient. It would likely regress things in production immediately.

> > Here is an idea: the THP shrinker will not consider anything unused
> > that has <= max_ptes_none zero pages. See thp_underused(). Joanne was
> > proposing to scale this knob down relative to the folio size for mTHP
> > shrinking. What if instead we kept the meaning absolute?
> >
> > The knob is an expression of how much waste the user is willing to
> > tolerate per folio. If the folio order in question couldn't possibly
> > have that much waste in the first place, we don't have to queue it?
> >
> > Something like this:
> >
> > diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> > index 2bccb0a53a0a..1670e9869bd3 100644
> > --- a/mm/huge_memory.c
> > +++ b/mm/huge_memory.c
> > @@ -4364,6 +4364,9 @@ void deferred_split_folio(struct folio *folio, bool partially_mapped)
> >         if (!partially_mapped && !split_underused_thp)
> >                 return;
> >
> > +       if (!partially_mapped && folio_nr_pages(folio) <= khugepaged_max_ptes_none)
> > +               return;
> > +
> >         /*
> >          * Exclude swapcache: originally to avoid a corrupt deferred split
> >          * queue. Nowadays that is fully prevented by __memcg1_swapout();
> >
> > The setting defaults to the PMD-1, so out of the box we wouldn't queue
> > any new orders. It would allow that 2MB on 64k ARM usecase, without
> > jeopardizing smaller mTHP usecases like Barry's.
> >
> > Thoughts?
> 
> My understanding is that adding smaller folios to the deferred split
> list is not the right approach. We could end up with a very large list
> where we cannot distinguish partially unmapped folios from fully mapped
> ones. For example, the deferred split list could contain 100 fully mapped
> folios but only a single partially mapped folio.
> Moreover, for smaller large folios, the number of zero subpages
> is likely to be small and short-lived.
> 
> However, this is probably fine for larger large folios, since it is
> unlikely to significantly increase the size of the deferred split
> list. In other words, the deferred split list should remain manageable.
> For the same reason, larger large folios may not benefit much from the
> LRU cache either.
> 
> So if we have some mechanism to prevent users from doing things that
> are not beneficial, such as adding smaller large folios to the list, it
> seems reasonable to me.

Just to clarify, we're on the same page, right? I was proposing a
mechanism to do just that.

> As a side note (I'm not quite sure whether this is relevant to this
> discussion), one thing we tried previously as an out-of-tree proof of
> concept was:
> 
> for (pfn = start_phys_pfn; pfn < end_phys_pfn;) {
>      folio = get_folio_from_pfn();
>      if (folio_is_zero_fill(folio))
>             swap_out(folio);
>      pfn += folio_nr_pages();
> }
>
> Then I was using my previous patch to remap it to zero-pfn if someone
> reads it:
> https://lore.kernel.org/linux-mm/20241212073711.82300-1-21cnbao@gmail.com/
> 
> This does not depend on any list-related logic. We can scan all PFNs
> within a short time.

Hm there are 268 million PFNs on a 1TB host. I don't think that can
scale?

Compaction used to be linear scans, but needed to grow the freelist
search and a whole bunch of position hinting to stay ahead of scaling
bottlenecks.

