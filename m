Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4FFC4CCD199
	for <linux-mm@archiver.kernel.org>; Thu, 16 Oct 2025 20:26:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A52398E002F; Thu, 16 Oct 2025 16:26:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A22FF8E0002; Thu, 16 Oct 2025 16:26:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 938398E002F; Thu, 16 Oct 2025 16:26:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 827428E0002
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 16:26:12 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 47280B8317
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 20:26:12 +0000 (UTC)
X-FDA: 84005109384.17.65548DF
Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	by imf16.hostedemail.com (Postfix) with ESMTP id 61578180008
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 20:26:10 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=cwv8DTAR;
	spf=pass (imf16.hostedemail.com: domain of jannh@google.com designates 209.85.208.54 as permitted sender) smtp.mailfrom=jannh@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760646370;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=e04unfMcA+wl94OLQlNjKMIVqI1fY+KiZvebuibHwws=;
	b=d4IONkRl8JtynOuHCO9ixCAKV2eD2HJsCrIqj7cB/2ZTDd2X2BZy0fRnWv6cYCTLANmKDH
	jHAH0Shv1G+PsX18ekrBDwjOgh7zcxtJo87r57mJauu6LD8esBikYywQ/DeXb6Ba5qv7hW
	Ro944FRfP+dcx5L/B1kfg+As+NTZLH0=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=cwv8DTAR;
	spf=pass (imf16.hostedemail.com: domain of jannh@google.com designates 209.85.208.54 as permitted sender) smtp.mailfrom=jannh@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760646370; a=rsa-sha256;
	cv=none;
	b=C+d8O41htB8xtZVGm9iN50+wM23fwiMtcQYcIOoZZfy/p9GAk+csMShuQtDa+bmRPT96pd
	wL+ghReLDNdLQ5DKH8JghYnRcbYbp6fNTvtC8z8Wbl/nfjCHnhXAkZph/fvZAu+CmR5ouc
	3JQBy0NfnqNPOQznp1zB+cKvLzNfUjI=
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-62faa04afd9so844a12.1
        for <linux-mm@kvack.org>; Thu, 16 Oct 2025 13:26:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760646369; x=1761251169; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=e04unfMcA+wl94OLQlNjKMIVqI1fY+KiZvebuibHwws=;
        b=cwv8DTARnrKWVGua/TXQ0ul3tuxqVVKr0j9CSDrEkut2AydzXmPYyhlQOvaX7d32WS
         XXuv3RjDU6Eq8xuX8dz1/mjRl6T2hzDVNRpVn915lmr2Lyi1FyXbvZwrxLnE93ujhNdi
         kGkycY5KOor3yhhcwCrY5bn1xdpHEjxCp5Bs4y+MzQIz1J1VM4ZpQrpFt+O7+/NeHm3g
         kk04tYGp99mFmBo+imP7dOhnJs2FtDgQlWzR5iL2TnuvC1r7QXRalFOw+IaaXATpqLMQ
         DW7AdW2TnbCY05RGwdZwOTJuUe+YNwjFGgDLSe6VnK5J5gHsPaG1gC5KQ1pf7/R8Dm9I
         7ChQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760646369; x=1761251169;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=e04unfMcA+wl94OLQlNjKMIVqI1fY+KiZvebuibHwws=;
        b=EWU2gkze51csW8L8sXCszIaLzWlI72uTyz/OigeKwo2X0Xxm8x1qJpn6j2ej5VajZN
         H0Vwpy/PmPdwAoMcCBVGkC5+xsrFlqA44idD+KiFVqCQgDCSiTclNWL4RPkpkvtQfv7r
         iTgjgramZ708HNUERhegN1dOX4zH8WCeeShhszT6nwG7KEdIyI/QsAnDvCb3FQOUae8S
         6rp6C5gW1rnHkEgol8Sc5sPKYQgZAKj+MCfEic1Uh9q35Q/gg17NxSaIrbljF+Jsg4/L
         vmXlJeo2C2BDKDruEREw1MO4tQER2GrX3O5DUJXB8rtqJ5dIXEuP3Gia3Bn0njzuL+b8
         YGTg==
X-Forwarded-Encrypted: i=1; AJvYcCVG4C5WaHA/q48596kBEuIRjt1YolhiCl0bYVOHcTGFKntYKdIirmRcXKu+xl+jS0ar30Wn8pHSIw==@kvack.org
X-Gm-Message-State: AOJu0YxxS4y4Jp2rmQ78VSBM2HsxyIUzoCRtx+3kiKJpsfjWvjA8lpcD
	LVA4l0BBTpnMO50npYjsCsT2n/9t9mP6dNrTr9sC06VmF8xOUCqqO3Cu/AYzfEdfBil4STsJdEb
	CnCi15L9Qxu14yz/50kuVfGapcoorewY0ZjmOeiKQ
X-Gm-Gg: ASbGncsUuvy59SDIbvsNa7CmlwKcD62MD+8BgJsl3BMYvYP8LeP44DQCgzN9oBuYFXY
	LPFaghJ6Gm/qMqS40B9RGxiYw7ZX1KKId6sLlUTnT9yi9Zt5NvLFd39X6zDhtPQ+sc239RK5NoV
	oj33dlsn1TTyIuDgJfdOWX07yJwPgyqh0qDok2NiYjHW4eDP3gSTluxC968HXtsIh1SckluAwuR
	4bLZrcvqOdwBZc4Q4g/bG/8j8uxnN1F6sc8+g6ZlbRlXx4WwEpRvpxYOPSS/HH48bENL5o0SjyH
	csrt+l3ekK2QwOmohLleSKkOyw==
X-Google-Smtp-Source: AGHT+IH/u+FCKbAoouZGXJNTy6nZ13eBN9Yk1uXZGrSCfrKoknUB+Gt38BROwONPAKp2ZAt70A36LU2nCFlzOIYu7Lk=
X-Received: by 2002:aa7:d144:0:b0:634:90ba:2361 with SMTP id
 4fb4d7f45d1cf-63bee07418dmr245479a12.7.1760646368450; Thu, 16 Oct 2025
 13:26:08 -0700 (PDT)
MIME-Version: 1.0
References: <4d3878531c76479d9f8ca9789dc6485d@amazon.de> <CAG48ez2yrEtEUnG15nbK+hern0gL9W-9hTy3fVY+rdz8QBkSNA@mail.gmail.com>
 <c7fc5bd8-a738-4ad4-9c79-57e88e080b93@redhat.com> <CAG48ez2dqOF9mM2bAQv1uDGBPWndwOswB0VAkKG7LGkrTXzmzQ@mail.gmail.com>
 <e4277c1a-c8d4-429d-b455-8daa9f4bbd14@redhat.com> <CAG48ez0yz2DauOuJy=-CcpQpqReWhYH1dpW3QGHPSHQ1VbAf3g@mail.gmail.com>
 <9d9912fe-3b0b-4754-87f6-6efb49d92a7b@redhat.com>
In-Reply-To: <9d9912fe-3b0b-4754-87f6-6efb49d92a7b@redhat.com>
From: Jann Horn <jannh@google.com>
Date: Thu, 16 Oct 2025 22:25:31 +0200
X-Gm-Features: AS18NWDLSb8iiK3deIr5crIXEpUg4U0MpY6QS-BO0TbZ3uZrFMySHGIdBYHCiHQ
Message-ID: <CAG48ez3P6nH-NFTvihmZW1nS3Q7UCz_BxCBk-jzG82-zUdF2yQ@mail.gmail.com>
Subject: Re: Bug: Performance regression in 1013af4f585f: mm/hugetlb: fix
 huge_pmd_unshare() vs GUP-fast race
To: David Hildenbrand <david@redhat.com>
Cc: "Uschakow, Stanislav" <suschako@amazon.de>, "linux-mm@kvack.org" <linux-mm@kvack.org>, 
	"trix@redhat.com" <trix@redhat.com>, "ndesaulniers@google.com" <ndesaulniers@google.com>, 
	"nathan@kernel.org" <nathan@kernel.org>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>, 
	"muchun.song@linux.dev" <muchun.song@linux.dev>, "mike.kravetz@oracle.com" <mike.kravetz@oracle.com>, 
	"lorenzo.stoakes@oracle.com" <lorenzo.stoakes@oracle.com>, 
	"liam.howlett@oracle.com" <liam.howlett@oracle.com>, "osalvador@suse.de" <osalvador@suse.de>, 
	"vbabka@suse.cz" <vbabka@suse.cz>, "stable@vger.kernel.org" <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 414bmdqopmfueowei4p9f7c7ymntcwpo
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 61578180008
X-HE-Tag: 1760646370-293449
X-HE-Meta: U2FsdGVkX18M0xqDikSbnZvoU8muhnjVhx74im+rR8xlDtn4duAx8VinRUyfQosx01PT7z7RZz+wc39AnBdbXTsIH3J87pVK+Bd0ix7TAFmPk7srCGhlKO3By8+9+aF4iLr5ifkfxcEqRHvgRGO+0s1tv6gDJA5sFj0Vel3zAhqC4ygAqdqS9sfGTwRuLPzHjHmfWyKshP+xxLVUYPshwOwbkEXjX0mvYUdqWRjPXSjUcuLneYVmaR59HJLvQqUiUhY+e0POtlAhuhxVgTL2eURGwCKA/mssPAfJFf1B1l6YdFOo0axUMVZp1SD0gKmXKqgaaLBE+txfuqWDnBugasykStbTwropV6yP12hmJUAHOa17JR4hwl4LEIddvXt+E197fCd/9OsYfWmLvDPMrP/LxMw6TCVa1qqYxQDm6vOUl8LNj9Oj3/ctnULV+qgMNgdF8A6dbjpKuU4oNsk3verwbxm3W46sf/rmnMYkEoeqlMRhghM7bTBDQhWtGxbXADeETdwbYkun35Kqccq3EqiPzUZQO4pawCDwgpY41UQG4NWpPqBtAxoXaPhNK63OLo+yP5d8sG9leWqml2+axE+zc8hmbhLfeBwGM1QIBBS2h4PqZ+QCxo3unmmAidugLOx4pizI2Xrif59DCj5qiO+ubWiT29/pIjJQqZ0SefI86Q89zH6E6SFAFaFxjIF7UfRo5LAVoTtjYhp/VitpDWpBsLiMRy5vKqnFbrCI50ZrApsf3xLekZUWbzd/EfyWo7h6/cYISe8eCgaznM9yUcnWY1eh6Lzh5DDwV25DftcbJZSiwPSlDN8J+KfoviDXJn6XFgC2MEbDaBNm+LDHTme0HSC6T85pT4Ch4cj+pG7OI7Jf/5C15JwCPv6YMKM9UtyEJxVnaDofj+JrpqtEfjU+NY6QO4hn30Fcc83QnVz8AVoyEqts37FAOxIkfamsgGfHmqvfXPNTgye7EBB
 tQsjnCj0
 G8vewdo4wYaVFwY9O74fdQm+aRU9eoPxbUcdTLW25Bsdlq3sYiWhTJ5HfV9T/2iynGyaxYuvG3kQ5MKZ+LMQZOmcvM5PYgkBfxQ1GDhwGH/mf85B1K/Y9OfOANdOprmAj8KZYe5ZdHpdzk/p6oc0DnKbl90XrUylIJYzCR3+Vqd2WyRALz+877BHMuXE+5E4MEEZCaFiQA/TTfUgfaXpQ5WLIJwZuWyF99ymuKZvKiFaGxkHQn4cGtLbRLmmQSj9yUVNwCqOd4jbr7ZM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Oct 16, 2025 at 9:45=E2=80=AFPM David Hildenbrand <david@redhat.com=
> wrote:
> On 16.10.25 21:26, Jann Horn wrote:
> > On Thu, Oct 16, 2025 at 9:10=E2=80=AFPM David Hildenbrand <david@redhat=
.com> wrote:
> >>>> I'm currently looking at the fix and what sticks out is "Fix it with=
 an
> >>>> explicit broadcast IPI through tlb_remove_table_sync_one()".
> >>>>
> >>>> (I don't understand how the page table can be used for "normal,
> >>>> non-hugetlb". I could only see how it is used for the remaining user=
 for
> >>>> hugetlb stuff, but that's different question)
> >>>
> >>> If I remember correctly:
> >>> When a hugetlb shared page table drops to refcount 1, it turns into a
> >>> normal page table. If you then afterwards split the hugetlb VMA, unma=
p
> >>> one half of it, and place a new unrelated VMA in its place, the same
> >>> page table will be reused for PTEs of this new unrelated VMA.
> >>
> >> That makes sense.
> >>
> >>>
> >>> So the scenario would be:
> >>>
> >>> 1. Initially, we have a hugetlb shared page table covering 1G of
> >>> address space which maps hugetlb 2M pages, which is used by two
> >>> hugetlb VMAs in different processes (processes P1 and P2).
> >>> 2. A thread in P2 begins a gup_fast() walk in the hugetlb region, and
> >>> walks down through the PUD entry that points to the shared page table=
,
> >>> then when it reaches the loop in gup_fast_pmd_range() gets interrupte=
d
> >>> for a while by an NMI or preempted by the hypervisor or something.
> >>> 3. P2 removes its VMA, and the hugetlb shared page table effectively
> >>> becomes a normal page table in P1.
> >>> 4. Then P1 splits the hugetlb VMA in the middle (at a 2M boundary),
> >>> leaving two VMAs VMA1 and VMA2.
> >>> 5. P1 unmaps VMA1, and creates a new VMA (VMA3) in its place, for
> >>> example an anonymous private VMA.
> >>> 6. P1 populates VMA3 with page table entries.
> >>> 7. The gup_fast() walk in P2 continues, and gup_fast_pmd_range() now
> >>> uses the new PMD/PTE entries created for VMA3.
> >>
> >> Yeah, sounds possible. And nasty.
> >>
> >>>
> >>>> How does the fix work when an architecture does not issue IPIs for T=
LB
> >>>> shootdown? To handle gup-fast on these architectures, we use RCU.
> >>>
> >>> gup-fast disables interrupts, which synchronizes against both RCU and=
 IPI.
> >>
> >> Right, but RCU is only used for prevent walking a page table that has
> >> been freed+reused in the meantime (prevent us from de-referencing
> >> garbage entries).
> >>
> >> It does not prevent walking the now-unshared page table that has been
> >> modified by the other process.
> >
> > Hm, I'm a bit lost... which page table walk implementation are you
> > worried about that accesses page tables purely with RCU? I believe all
> > page table walks should be happening either with interrupts off (in
> > gup_fast()) or under the protection of higher-level locks; in
> > particular, hugetlb page walks take an extra hugetlb specific lock
> > (for hugetlb VMAs that are eligible for page table sharing, that is
> > the rw_sema in hugetlb_vma_lock).
>
> I'm only concerned about gup-fast, but your comment below explains why
> your fix works as it triggers an IPI in any case, not just during the
> TLB flush.
>
> Sorry for missing that detail.
>
> >
> > Regarding gup_fast():
> >
> > In the case where CONFIG_MMU_GATHER_RCU_TABLE_FREE is defined, the fix
> > commit 1013af4f585f uses a synchronous IPI with
> > tlb_remove_table_sync_one() to wait for any concurrent GUP-fast
> > software page table walks, and some time after the call to
> > huge_pmd_unshare() we will do a TLB flush that synchronizes against
> > hardware page table walks.
>
> Right, so we definetly issue an IPI.
>
> >
> > In the case where CONFIG_MMU_GATHER_RCU_TABLE_FREE is not defined, I
> > believe the expectation is that the TLB flush implicitly does an IPI
> > which synchronizes against both software and hardware page table
> > walks.
>
> Yes, that's what I had in mind, not an explicit sync.
>
>
> So the big question is whether we could avoid this IPI on every unsharing=
.
>
> Assume we would ever reuse a page table that was shared, we'd have to do
> this IPI only before freeing the page table I guess, or free the page
> table through RCU.

Yeah, that would make things a lot neater. Prevent hugetlb shared page
tables from ever being reused for normal mappings, perhaps by changing
huge_pmd_unshare() so that if the page table has a share count of 1,
we zap it instead of doing nothing. (Though that has to be restricted
to shared hugetlb mappings, which are the ones eligible for page table
sharing.)

I thiiiink doing it at huge_pmd_unshare() would probably be enough to
prevent formerly-shared page tables from being reused for new stuff,
but I haven't looked in detail.

