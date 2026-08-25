Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ACC15C61DB9
	for <linux-mm@archiver.kernel.org>; Tue, 25 Aug 2026 16:53:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AEF2E6B0088; Tue, 25 Aug 2026 12:52:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AC7866B008A; Tue, 25 Aug 2026 12:52:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 98E146B008C; Tue, 25 Aug 2026 12:52:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6BEE36B0088
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 12:52:59 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 0A1D0A09F1
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 16:52:59 +0000 (UTC)
X-FDA: 85140386478.03.2A19414
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	by imf19.hostedemail.com (Postfix) with ESMTP id 1515A1A000D
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 16:52:56 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=T3rPBcWK;
	spf=pass (imf19.hostedemail.com: domain of jannh@google.com designates 209.85.214.181 as permitted sender) smtp.mailfrom=jannh@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787676777;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ImkuahcqiET0r0yh2i1x0Wqcf5zuafLmEw6TOE3oMq4=;
	b=Vnx03EdckkJy5r5DjKUnysIZsJ6l+gOS3IJrUSUTyBu5Jf05MrA0gkNR2iE5dbtvFm2YVZ
	ZIlDGUCyBXPDujrvO9nrngqtzG8tmYUJMxRXrhKrKO4YnoBQYCEInPV5RbI1xzmqS7ZSXf
	/iw1a6Qtyek5NMDt9oXxi2qaR/dIxb0=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1787676777;
	b=ja0cd369/EMXUYT3XtDEpGy29WWvET+g1DRX7eXanb3tuCMQJRXeW9l5iTufsIoKk8pV+d
	4XFrlptlIf6PmDdL83nza8/dOFKxiAf/AVSywedYyzdbYWRaxRegXX7gS7sUc9q0nZHeFI
	yrJqgaplJqHFMgKjam6p7NQQsjiUMjc=
ARC-Authentication-Results: i=2;
	imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=T3rPBcWK;
	spf=pass (imf19.hostedemail.com: domain of jannh@google.com designates 209.85.214.181 as permitted sender) smtp.mailfrom=jannh@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-2d3b445a84fso128945ad.1
        for <linux-mm@kvack.org>; Tue, 25 Aug 2026 09:52:56 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787676776; cv=none;
        d=google.com; s=arc-20260327;
        b=UimNYz6lsciZaiLAuf3/yWjWQlAgXBAzijA+uQE+HlK+9zSEP0EqfYsAEpTvCvVs2r
         drg95pNfd5vR3NisESeujY45AbtAjBU+Yt6vtGeao6iGa0mYDrwhlnopLwqf0pGFWiGy
         3oubeEbUhgytQ5brb0Rtnz77UIdre12MpMol1G9JOorujw8AlCTbwIrVlNQWwjSWHKn3
         InonnpqQJ0bAPg9cTXHGMcBX/BWRB6MCjp85ZF0SHLd1tF3yya5mL8Whxduhd4mMVjIU
         kAE/SDBb3XTrJ0JrIBTEUrt+1elFF5barL4mi7AM/EcaMTc3DqycAVYFf9y89Iqvdalf
         WUkQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=ImkuahcqiET0r0yh2i1x0Wqcf5zuafLmEw6TOE3oMq4=;
        fh=dO8bIUIb+nVw51Jq6x6tpS68JHT9T3/wIULPAHckqEw=;
        b=P8vCs6FHs0fi7beW7jxpNEIzTdVbITI/8hISILgwnsmnO1zHgpbf6rfb27hpxBddDY
         4SwzJfLVLsRYtFa3d8wsXaT3GsRavOnUupWQBOtd2rRYgir3609HeLHvtygPX8/hUkVx
         4N8QRr/qZXaR/bH67tskJ8v62xoL8eQVHf+00BQzcmRaZ917FRSgL0fDReueyPKPmp0v
         gdzE11j/yV+NSM50wOTMKqmQu7d7vsLMVSfKfl/+emRhfUo40rRiQkoZSrrTP+AlLKU5
         kADCnTU16BIvVITSiZBxIvHnL1FM4a662AaBSw1kHbw5uHGV2Rpoc0Nf1WrAF5c/fJgk
         XCNA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787676776; x=1788281576; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=ImkuahcqiET0r0yh2i1x0Wqcf5zuafLmEw6TOE3oMq4=;
        b=T3rPBcWK5GQSkDGWEHvSiQ0C8u1w5ULYSbdocfxF1qUn3IH9U9L/DflTb9ftI+JNos
         KhzgI2iCsejYeaiKmFa8U7KAgpDElqXsKnQVN3keYPkULJGdUpfAVl7NiOIryY2ce6n6
         46ScUXMaVoXajZpykEDUiOr1GUqLbqER6PCFFDLdf0s/Qow8DZEgB7641/bPS70zM4Nv
         hQWO7JX1iDGFgdRZPqT2JiJqIxMJKRlM6UVpAZNv7nBxq0YC5463lbSic9ZzmwwDKTZD
         48KkeKuR7r84nl+b0Uf1odPxklfQ8XOlAj9rKn/QbAswAZzRRQimfmYNaDYa78PjL5IA
         9pjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787676776; x=1788281576;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ImkuahcqiET0r0yh2i1x0Wqcf5zuafLmEw6TOE3oMq4=;
        b=XyGahVTis/RWjF0nc7GWGjDOZ4UtmtbOjpOAGJR8w//pkZwQmc0bipt39ChsJj9hZ3
         5fMSLVdTbplA4mrleERYyHrRgDz/c2gHgJZx3GhVjJ3t03oSbU3uC7SL8Cq2FfN9xBng
         dQacy2Pq8cp5P7j6CmkKIEw5ZbgiAmp0T0xS6Jr01KYnV1VHSUC1kHeXtteoMmtXToSk
         0dTc5AG4IDF8TEd202v0qgdUNZthLgeE8xJphzVPucYna11yiVl37iQ1OjZio7Y5hQpn
         GbUO2lE3ru0WRM3li9H475uvoKgLOnWBSv8rfJ8prxi8w3qaNC+dR3kvTjrEQd/eUe5N
         Zofw==
X-Forwarded-Encrypted: i=1; AHgh+Rr4Z5uXGi7SaBrLnFdTSIfwQvtRtV4/OVrK6l8MOFmBVyi9nUzL8gxih0adPYZNtznhOkh7CPe2JQ==@kvack.org
X-Gm-Message-State: AFuF++l6OYctdSIJDd+Oinsg4rHXCwEMSmS5XYzjhD9QK/XefXImlTE9
	J2iA6V/GI0V+mFHWhRiruLucY3eAT3G/g2xiUtn/Cjxa7DVRhOY6SVGoK0ZVav5BDK0wyQPzbSF
	+Cs2PlvtONxDfDSkuKYv7JmKKbE00v+03DAXgpGnl
X-Gm-Gg: AR+sD12HxKdru4Y0Idi3SwY0TU8I3AoSaQmTnCWVZQIg3vLp8BEQbylMc/qBdtMbsct
	pXCqumfCMka0anVw7kqwZDNVAbgEc5LGXqGs1DoejInkry6HOZazOwJzP5UFNBbdcTX/d6V9tcx
	EH9EeR5xyEPZuA6o4lPE+uQJrfggbE083LV42ATj5D+vjuV4fBrOxKi5u11CWdFIRIcBThh+o0P
	qT/wyhjuh3v0H129SoPCfkw4HmsF8zqH9RG8i6JHUrrzXGCz6lArKGvnjWbjid2Rm9MJ1VqYufj
	ZK8tAvEe7agpimmrBznPwfKBmRHugaDoT6UubU1CuVAWro8zcBSjYyDxB1AjA7NPccmgwPyjbsu
	0D2hjuTdaA/QerV5t4l71XBQw2AUq1IeRyCDd0h34
X-Received: by 2002:a17:902:f705:b0:2d5:db3d:1a41 with SMTP id
 d9443c01a7336-2d6e0757d7amr9055105ad.14.1787676775185; Tue, 25 Aug 2026
 09:52:55 -0700 (PDT)
MIME-Version: 1.0
References: <20260816224609.308019-1-kirill@shutemov.name> <20260816224609.308019-20-kirill@shutemov.name>
In-Reply-To: <20260816224609.308019-20-kirill@shutemov.name>
From: Jann Horn <jannh@google.com>
Date: Tue, 25 Aug 2026 18:52:17 +0200
X-Gm-Features: AcwNN1Vvom-LUSAxEjMWXrQR9qZrcTO8aY2l_-w47SQrAcC9eH4E9yF2js957ac
Message-ID: <CAG48ez1fiCzTMATN07HHfzvUGFuZ5gELNpZXdXx=ySa7nihxmA@mail.gmail.com>
Subject: Re: [RFC PATCH 19/57] mm/collapse: install a PMD leaf as the terminal layer
To: Kiryl Shutsemau <kirill@shutemov.name>
Cc: akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org, 
	nico.pache@linux.dev, baolin.wang@linux.alibaba.com, baohua@kernel.org, 
	dev.jain@arm.com, hughd@google.com, lance.yang@linux.dev, liam@infradead.org, 
	mhocko@suse.com, rppt@kernel.org, ryan.roberts@arm.com, shuah@kernel.org, 
	surenb@google.com, usama.arif@linux.dev, vbabka@kernel.org, ziy@nvidia.com, 
	usama.anjum@arm.com, agordeev@linux.ibm.com, linux-mm@kvack.org, 
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org, kas@kernel.org, 
	willy@infradead.org, pfalcato@suse.de, rostedt@goodmis.org, 
	mhiramat@kernel.org, linux-trace-kernel@vger.kernel.org, bpf@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: syiwi11g5obhw6qdxdffxxfxysjr873m
X-Rspamd-Queue-Id: 1515A1A000D
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1787676776-310129
X-HE-Meta: U2FsdGVkX18amzAVFTkWRlJ/trRMO957+C2QpO91AfZYgiDRJsBDLeg/ikMAL9mVMyDbNA5mGAXCxctzWLZSh1FgbOG8y9h9acJJ97Poh6HKI0V9m7MFBYFXK3TtEHp3Xt14NT3q4a6dLrReSmdjCzOuAGDlqhfEx1LUPeqYp5RxezpqWD6zx4oAr9jqHVwKH3ZDw2RNRjCl0jV8Br+Y04mZnyQpA/GvuW1mB+urvd7Cd8AlknOW27E4/UHYcdRlaQ0GTrklA4dRh1h/uxRvuSisFqsFfuAgqPUMqbAHFdYYKjK6/fMMwHWcGgkxNnf1Xf/H8B5eU60VWOTQTPSDC7bhMlHqqoG8YYml+ET8Fjy+fZiOI6wBa3baYEDsNYL0dU74s5NY5rKIHGOWWF6jG9g8GGUk4a8jSZT45w6VxFKIKxkA1CzIvcHLKvtKUJZXV9VeVyiGBEn7JM8uqhJ+MblFSLWS3HnPjCZfHmoYMiOwOtJ3iFeUJXrOB7ugtE4ELZm5pRztjY3CQImGoXAIZy6yE3umojAsNWzJe1nPUUTfsybOzcFqBnsPBM/9NR+heP9FUBxi4T0pvqT0Ifv/i+T3zphJbdJmPeVMDn/kM6lcINoWIzS7twa2uAyBxuhyxVbq0kjM4VbSvW0LJJ+ozWZQkV/BRde411KaUwY9T0mAOYe+uhZotCO5ItFJk2IGV7UVrJ15LeiV9NaqKfoU6/QPQV2ET2BbBTW1s8dKB5hx6id/aeyP6yIsP5VTigSbtdz/W5GNb7g0NuCs7R655r8R1IjeqVhNYc8DkTiczcreX4CCIdwDvWXqEonqyL2OrnlwLR+xKR2aFjwz6wWft9mP9T5Ducr5Dg66aHakFFHajJ2QlcONKA2C5cpt7BaMkXq1TjB1N7+VYthKISHjLkecUWFI9KogQaVT6O7lZ+2O83uZkjkWbGEiy2UiuKFZpzTohy67YGPw6f7IJyY
 V3pUOHKF
 Ag8TjiXI5j4z5GFtBEIYUzz/GRF20ifJjzPrCK/wL643s1gWNYzn9t9JZfNovoVqdOBHnD6CSIqNkv9xzcOjm63yCIUxtXkk/Kq086rUM9spwZHmgPu0AcsVzNG6wM4A2i50FGg8RnFEm0tocTCN/BlXf4aOC9X4BP1XywBuFibn6s5l8y/G16uGUtazS8Bc6N7u6QRxAXEG7EIeQV325DzzkAbrlKODX6o1+4r/ZtVKOVvyxFuLD7O2sGA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 17, 2026 at 12:46=E2=80=AFAM Kiryl Shutsemau <kirill@shutemov.n=
ame> wrote:
> Fill in the PMD install.  Under the pmd lock, with the pte ptl nested
> inside it: verify, detach the table with pmdp_collapse_flush(), deposit a
> fresh one and map the leaf.
>
> That is one atomic section, so no pmd_none() window ever exists: faults

What do you mean by "atomic" and "no pmd_none() window ever exists"?
Is that supposed to be with respect to a subset of readers?

While the PMD table spinlock is held, you clear the PMD entry
(pmdp_collapse_flush) and set it to a new value
(map_anon_folio_pmd_nopf). But codepaths that walk page tables don't
take that spinlock unless they already know they're in a THP case.

zap_pmd_range() does not lock the PMD table before checking
pmd_none(), and if that is true, it skips over the PMD. I think this
means that THP collapse can race with MADV_DONTNEED or zap_vma_range()
such that the zap wrongly has no effect?

> stay held down at pte level by the migration entries throughout.  It is

But you don't have a migration entry at the PMD level, right?

> what lets PMD collapse run under mmap_read like everything else here.
>
> Two things force that nesting, which is the one the tree already uses to

I'm lost, what is "the tree"?

> reinstall a table.  A racing zap of a frozen entry takes the pte ptl, so
> the verify has to hold it.  And the table must not come apart between
> verify and detach, which is the pmd lock's job.
>
> Nothing leaves the section early, aborts included.  An abort only
> restores PTEs and would need no pmd-level exclusion of its own, except
> that its pte pointer came from pte_offset_map_rw_nolock(), whose caller
> must establish that the pmd is stable.
>
> The deposited table is the freshly allocated one, never the table just
> detached.  A deposited table has to be quiescent, because whoever
> withdraws it frees it immediately with nothing to hold a lockless walker
> off first, and a table that has never been reachable is quiescent by
> construction.
>
> The detached one is not: GUP-fast and RCU pte walks that read the old PMD
> may still be inside it, and on broadcast-TLBI architectures the flush
> expels nobody.  Quiescing it would need an IPI, which has nowhere to go
> here -- outside the pmd lock it opens the pmd_none() window this design
> does not have, inside it is a broadcast under a spinlock.  So the
> detached table goes to pte_free_defer(), which holds the free until those
> walkers finish.  One transient table page per PMD collapse is the cost.
>
> No anon_vma_lock_write() is taken, unlike the mechanism being replaced:
>
>  - rmap walks on the sources are unreachable, their refcounts frozen and
>    their folio locks held from freeze to putback;

To be clear, we can concurrently rmap-walk into the PMD, right?
Because we might be looking at a different folio which was created in
the parent process or something like that? And so a
page_vma_mapped_walk() without PVMW_SYNC might look at stale PTEs?
(Which may or may not be fine, but would not be what this commit
message claims.)

>  - non-rmap pte walkers see migration entries;
>  - pmd-level observers see either the old table or the leaf, never an
>    intermediate;

(or pmd_none(), see above)

> +       old_pmd =3D pmdp_collapse_flush(vma, cand->addr, pmd);
> +       old_table =3D pmd_pgtable(old_pmd);
[...]
> +       pgtable_trans_huge_deposit(mm, pmd, cand->deposit);
> +       map_anon_folio_pmd_nopf(cand->new_folio, pmd, vma, cand->addr);
[...]
> +out_unlock:
> +       if (pte_ptl !=3D pmd_ptl)
> +               spin_unlock(pte_ptl);
> +       pte_unmap(pte);
> +       spin_unlock(pmd_ptl);
> +
> +       /* The deposit balanced the detached table, so the count is alrea=
dy right */
> +       if (old_table)
> +               pte_free_defer(mm, old_table);

What does old_table contain at this point - migration entries? I
wonder if we should zero all the PTEs inside it before dropping its
spinlock and scheduling its freeing, so that a concurrent
pte_offset_map_rw_nolock()+spin_lock() wouldn't see dangling migration
entries. (I'm not sure if we actually have a codepath that does that,
but even if not, this seems like it might cause problems later.)

