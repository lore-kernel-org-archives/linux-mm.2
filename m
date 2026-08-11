Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 54B9AC5AD7B
	for <linux-mm@archiver.kernel.org>; Tue, 11 Aug 2026 02:31:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E1E7A6B007B; Mon, 10 Aug 2026 22:31:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DCEF36B008A; Mon, 10 Aug 2026 22:31:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CBE016B0092; Mon, 10 Aug 2026 22:31:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 922AE6B007B
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 22:31:40 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 7132B16032B
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 02:31:38 +0000 (UTC)
X-FDA: 85087412676.06.0F01FCB
Received: from mail-oo1-f42.google.com (mail-oo1-f42.google.com [209.85.161.42])
	by imf17.hostedemail.com (Postfix) with ESMTP id A73B340006
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 02:31:35 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=UrsBdXiZ;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf17.hostedemail.com: domain of cuiyunhui@bytedance.com designates 209.85.161.42 as permitted sender) smtp.mailfrom=cuiyunhui@bytedance.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786415496;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JgxUsn6bXXlTXTzE9w1hjUQJ+4UQHLS+g00NWeF1hYk=;
	b=xAbkgN/nfUq0I3bLcPGesDa/Hg2hdw4sbgELTzElWWn0kaJ84SQcNfWndss6Leex9mmRPF
	OP0QoBja3BGANMNa+M0LHqC8S5KE+wvGIB+0Nz3izYY8NkKnfj4VlYStar7OfNaD8Oo6S7
	V2z2pS//LY5oUmywIZBM4YDZ1cOVZs8=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=UrsBdXiZ;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf17.hostedemail.com: domain of cuiyunhui@bytedance.com designates 209.85.161.42 as permitted sender) smtp.mailfrom=cuiyunhui@bytedance.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1786415496;
	b=k6ipjI6NXc71DZ4hXIH5DUmnPTQOD1VeEoDCxG3sc2BZOoujE+EgSPpd74PS2UjzsOPpXY
	G/O5aCQuuDKU3ONWkw7jZL/oVku9+qrIkE0EISImA/4i2Lao/f4SwO7Zl11Ba3wngbwMDY
	WPBlCOsKLkCzXnJoa33K5qB8D+KPIdc=
Received: by mail-oo1-f42.google.com with SMTP id 006d021491bc7-6acc74fee76so1137549eaf.3
        for <linux-mm@kvack.org>; Mon, 10 Aug 2026 19:31:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1786415494; cv=none;
        d=google.com; s=arc-20260327;
        b=ldn2KWKn9f7dtigAAE4Z8CZ0U1VaPJ+HKUY6Q+qOBCP+rAPEDxGuqGgsvm1/SCo5ci
         XIMYJIGjVW8mY8lDtPSpVz7PrHtSpWIUhOyl/sCUSXoX6A6NmfxbHsaKq6mU5RNiIXpj
         pf0jqU4OloxrcixwmKSa7+QSHafAM7d9+TfrU4dNJdAgIg9javuebGeuxpbl64EJQsew
         vGa4bcZk/n9H/moefekRzrHvwB/E/moKnK1NEu4O8b1e0LuTZ+G5g2Z9prFhcXhftpBW
         vhZ2EpHqo10zSQ/dLqZcSytfxFPIumYTRy32/R5X2S733JzGcgOc5MPHbhqILQSob3ZO
         pUwA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=JgxUsn6bXXlTXTzE9w1hjUQJ+4UQHLS+g00NWeF1hYk=;
        fh=ddRjLPxiKB6keWZvGbeTpy6MLDp/U/F4/HgPEVsz+XY=;
        b=kxIKkuRTZfb2+BRBS25MCsC3Y+RW49SMy8GLak1phgOngUlB1NjiifTuUyRSPfAxjD
         U+JkKZ8SmTGhMPTiBr3wWBoK449W8Pl/nQiyvIZXijaJfx45VlopFEitf86QX0jGyXxO
         RdQ/ezDEzmbsYqe0vVPtPeFlQyEsABPTam0p4/S7BAyDFAxjeTNhPJ19paZR88iLtfbZ
         sft1cA7EF2U+TBcMpmnGvVo++h0sSvwwgFsYsKliTXYlTOVUn/ArHzTnb6iuvjB4OlXd
         15M4XjzCBXGrbNQ6GcDscZyRtKuvs6kVLUpL8fou4j9MBvzP0D19Pwx/qcIUazEATSq3
         H9vw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1786415494; x=1787020294; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=JgxUsn6bXXlTXTzE9w1hjUQJ+4UQHLS+g00NWeF1hYk=;
        b=UrsBdXiZ2fZNOkiUk1qTN2GEIJsfKBH7OB8GB1kUBoucREP+gba/KrniN3LQip1Ths
         0bHWRt6V5niTTuB0YLbtooIT1DkRwzjBz5QVsXmk2O/dX0SVhmOwiNHWtSe2XDaOyT74
         g1fMZ5H0K93aVExEmRVAfgGbCWD/9isf89kDZkfvz1Md5Nc6QFoJNZCMzFqp9jrFsexe
         xis8iwfwhYKwtUW4LJL1jAFCIEQlbN6SGuvDDsxnwjPrFP8DCEkZrqadEp0zbuLFlbpU
         XVN4bLBjVe1yrU+orr/YIXCBJZrKTx631W24O/lMpEPzI8azlBH1PChVROsuC+bjRMXo
         SKQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786415494; x=1787020294;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=JgxUsn6bXXlTXTzE9w1hjUQJ+4UQHLS+g00NWeF1hYk=;
        b=n6Z0XUqXyTUxGZYjH9k4H+qEUmWeymytenEUDmjDyYSu+OJc+33/qqkU/tHV/zxBet
         WGZisujeydYjYHiAECBRB4ZWskcarVuUY/BCJtiZXXUlA1MGm94bZkk+F7VAiytnHkYi
         wka/J6tVC3glYRR7t3oyECXCcxb1rDY0IbbT26ZwCeL98K/I+Zg1CWMvs9iE5knsGhKC
         aNYBib+7TDbi1K0JlZcTUSH9aQlDiT70O95eC0mk20AR74LWYqXSuukcBBia9AYdsDDC
         b3Tv2B15sSjkCDpwbY5O9i5Mjb9RpUlioFledVdVgCznMn9OcG8n5YfK3AHC5RElgImn
         +9aQ==
X-Forwarded-Encrypted: i=1; AHgh+RpzAFbpJHtCBVOYo0Ip7Es7OGBbgI9ZV1aCwLjee4B3LAYFnGTlgoLvlfp9Wh5gRJhD1qnrmSl1LA==@kvack.org
X-Gm-Message-State: AOJu0YwxNEqXWiaGryNGBPu4COlFeeuzkPZFGBXdQJZgdA/iIA2JtRSc
	5+FpqaHZ5ib+f+0hRZ+vjDyfyjS4smG8S65jmcxNoVNOPue9o1UoRKZUETMBKcuc3nJYgTKWBE1
	gOhB34v2nsRO9KRoW1KvOqjikW50M58rGbi0MlaONig==
X-Gm-Gg: AR+sD138t2joAJeoTFJ/KSbp7aDqV0p9bmoKAkq7E95GsVIUBcfjA6jmwBR0RaY3jnM
	ZJhZuQ1SbVGLZGNWjHjoSGg6CdAFggXURT6FsC/IrQ1jMvFLg7HLbXMS/IFcw7tcCv5ViPOFxi1
	Zi/SgqxlVPGzRID12aQeCTiz8xhz+4DF0FnR05RJL1WyQAuHmnZrzmX45y75oaN5VdTpfWv1RYE
	HITIRexRJVPFS3y25b+6AY6ygoj9T+G4bpL7bPLqPgk36cHFA6z0XGERUC9Klyoj/BYC0H0FEe3
	OyIU0CEKFBIrlzdG1L/aWjQeO7kmSVY3U6lov6Nj8KNuMF8=
X-Received: by 2002:a4a:e911:0:b0:6ab:f90:1da6 with SMTP id
 006d021491bc7-6b041eb0f97mr13666641eaf.2.1786415494199; Mon, 10 Aug 2026
 19:31:34 -0700 (PDT)
MIME-Version: 1.0
References: <20260806055501.56761-1-cuiyunhui@bytedance.com>
 <anQyoZgi5Urnvvjw@lucifer> <919b804b-6f1d-417e-9c0c-d06f50d765d8@kernel.org>
 <anSar_i8UjniSbML@lucifer> <a6a9e0cc-e6cf-4f83-b6be-7d64058b8fa6@kernel.org> <anSqbW1w2bDDHpAx@lucifer>
In-Reply-To: <anSqbW1w2bDDHpAx@lucifer>
From: yunhui cui <cuiyunhui@bytedance.com>
Date: Tue, 11 Aug 2026 10:31:21 +0800
X-Gm-Features: AUfX_mwbnD7l5DBw46pgAlHGrER4CbOSHy1IXkZ3P9w15OLF8_3zuFbcxsU8T3Q
Message-ID: <CAEEQ3wmJoUF5TDQDfMU_dUHnY+gg7MYG=OmmdB3Ynpdu9gJ7-g@mail.gmail.com>
Subject: Re: [External] Re: [PATCH v2] mm/madvise: avoid skipping pages after
 splitting large folios
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, akpm@linux-foundation.org, liam@infradead.org, 
	vbabka@kernel.org, jannh@google.com, 00moses.alexander00@gmail.com, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Stat-Signature: hjsqcteuoratw46nfk81nxf176sa7xuw
X-Rspamd-Queue-Id: A73B340006
X-HE-Tag: 1786415495-109356
X-HE-Meta: U2FsdGVkX1/FaouF7HFygDuSwbpc/QKSGSiQkZ3I5SGLOc8p6gvGWPswlxgKKNfJu3ZjXZdHi60DMzyNXXkSCX6FuWzki/ZdlgJIGZ/cAltnzt6yxjWC3mWL3xr2V5OaoJcEUB/uD/D+laxDzmjDCUD+xaDjEeB3j7uWuJbeEmXO8nmSoL1gj5V/4G0+h+CBdbdXKIOZaBNPIB92pRy/tjKOKMdQjR5s9RPIq+WEs3ImSD1pYp7NT38tQTMP0rG+/oKxTiSdyX55WzJ2bKUQlkvZSh7v0c9afg162mzjqymFuFOUfhDKkZmrwTWI4+86mns+cufEKIb++w6OYzs6KeLByEe3/kQtGj0K3dg8Lnb2Hl1GAODMC9aoH6egVvGAIKbSxj61BAEbEGzc/rDI2IjFay8d2oNqXcrnbJM8zpYXXrHz8o2n6ECh9yBBT84qzcE+MSrEggqQRWHEWFGX/wAflCnIUXw4T61IbJ7+n3V+hGjy5HDnvQOrcPGX7ugzAAMtVinMLgoFBHWjaiVtpQQHjTgbJlTQ1C8TlI/Nju5f/t5NPVbVzvp1J9B1XCCHXeX9SNbEadUoC48dLeW3SNeOOt7/f1T+hZZR8ZobS74K9hHDbfKzZZStJ+Qi7w6CSUF3PkOFXL3I272CephFuk3Mg4pC91XKGdI4OaHOXhDBBnenk8inw6VqobaK4UdF5uEkAxC1DdnTdf0Gn2UxCkAxscNX/mpbUdFpy+8nD418z8miHUh2w4e9vpLIrvEDn/4PLzVyKwC34gKn6HESzYEvVixpIkDpEQcS6hBD3tR4SX8FKJfCPo4J1oBUXPVOwfuyvJORbg6146Ytzwjk9rWUQvbLQTPV85CWQvym29HzAjdirz+mT89Cg1e6kTUEC1N7V+cgD20E8wF3mZLUnx1pKT+UBCbZSJg1MnzvEu2DiU1OGfnreRRxzmmKiQtBECypLFs8GNN5l405+M0
 nMxev5xa
 RcYO7oA5OXHxZvPgMNlYnWuZsLKoVbrjg1WkAC+YGgtaOuVxWOaEz4Ijy19VUl846W9EVt5aOn/LmonG5ZFj5Q+gXZkM07jXERRlh5PuJXq2rt3cIi5XtdwedlegX7pheA8xGWmzjzd1UIBcC0SS463+XPUtOsxwhgeXTbMM/TJIfT/r8eq4YHp4K4WQc6Q20RsBHMDifr8VhNALyiKp4KXeFFAEqoT/rL5TQ+n8OXI293BdNbQbM3Nf6dQR5RdsHtthLUq8jvUQXP7hsZhFxDwfdFlxF4MlgY8MJDsDAQx+UDrF43q+Hipl6Hz2eknK6EK3666k1Xo6decyqMIZ3UPPFzaKq64l9o0YL
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Andrew, David, Lorenzo,

On Thu, Aug 6, 2026 at 11:40=E2=80=AFPM Lorenzo Stoakes (ARM) <ljs@kernel.o=
rg> wrote:
>
> On Thu, Aug 06, 2026 at 04:46:10PM +0200, David Hildenbrand (Arm) wrote:
> > On 8/6/26 16:34, Lorenzo Stoakes (ARM) wrote:
> > > On Thu, Aug 06, 2026 at 01:35:30PM +0200, David Hildenbrand (Arm) wro=
te:
> > >>>
> > >>> Let's at least split out the folio check into a helper to make thin=
gs
> > >>> clearer:
> > >>>
> > >>> static bool poison_splits_folio(const struct folio *folio)
> > >>> {
> > >>>   /* Hugetlb is, as always, a world unto itself. */
> > >>>   if (folio_test_hugetlb(folio))
> > >>>           return false;
> > >>>   /* Soft-offline errors out, hwpoison traverse DAX intact. */
> > >>>   if (folio_is_zone_device(folio))
> > >>>           return false;
> > >>>   return true;
> > >>> }
> > >>>
> > >>> Then for your patch:
> > >>>
> > >>> -         size =3D PAGE_SIZE;
> > >>> -         if (folio_test_hugetlb(folio) || folio_is_zone_device(fol=
io))
> > >>> -                 size =3D folio_size(folio);
> > >>> +         size =3D poison_splits_folio(folio) ? PAGE_SIZE : folio_s=
ize(folio);
> > >>>
> > >>> I tried writing something that was neater and nicer but AI kept poi=
nting
> > >>> out how it was totally broken and I really really hate this code (n=
ot your
> > >>> fault :).
> > >>
> > >> No, I don't think any such special casing on folios is the right way=
 to handle it.
> > >
> > > I mean the issue here is the stride varies depending on whether the t=
hing is
> > > hugetlb or not (and some weird DAX thing), and the poisoning causes a=
 split
> > > otherwise so if you want to poison a range you have to account for th=
at.
> >
> > We GUP'ed a single page and now try to be smart about which other pages=
 we'd GUP
> > next.
> >
> > That's just wrong, and hugetlb special-casing is just ugly.
> >
> > The problem here is that, if we GUP'ed a page and poisoned it, the GUP'=
ing the
> > next page might fail and we'd return an error.
> >
> > But maybe that error can simply be handled? We have FOLL_HWPOISON.
> >
> > So maybe we can just use FOLL_HWPOISON and skip over the entries that a=
lready
> > return -EHWPOISON?
>
> Yup this is ugly debug code so that works for me.

Thank you for the review. Based on your feedback, I went back through the
madvise, GUP, soft-offline, and memory-failure paths and outlined the
changes I plan to make for the next revision.

The issue is that using a page obtained for one address to infer how far
the range walker can advance is the wrong abstraction.

For an anonymous large folio, soft_offline_page() splits the folio to
order-0 and handles only the supplied base-page PFN. Advancing by the
pre-split folio size can therefore skip the remaining base pages while
madvise() still returns success.

Lorenzo also raised the semantics of a range that covers only part of a
hugetlb page. Looking at a range that crosses a hugetlb boundary exposes
another problem. For example, with two 2 MiB hugepages:

hugepage A: [0, 2 MiB)
hugepage B: [2 MiB, 4 MiB)
requested range: [2 MiB - 4 KiB, 2 MiB + 4 KiB)

The first GUP resolves the last base page in hugepage A. Adding the full
2 MiB hugepage size to that unaligned address produces the next address
at 4 MiB - 4 KiB. That is already beyond the requested end at
2 MiB + 4 KiB, so the loop terminates without ever visiting hugepage B.

For MADV_SOFT_OFFLINE:

- ordinary pages and large folios advance by PAGE_SIZE because
  soft_offline_page() handles the supplied base-page PFN after any split;

- hugetlb advances to the end of the current hugepage because successful
  soft-offline migrates the complete hugepage and leaves a healthy
  replacement mapped. If the walker advanced by PAGE_SIZE, its next GUP
  would resolve that healthy replacement and soft-offline the same virtual
  hugepage again;

- ZONE_DEVICE does not need a stride case because soft_offline_page()
  rejects it.

Advancing to the current hugepage boundary, rather than adding the hugepage
size to the original unaligned address, lets the next iteration start
exactly at hugepage B.

For MADV_HWPOISON, I plan to follow David's suggestion and walk at
PAGE_SIZE using:

get_user_pages_unlocked(start, 1, &page,
FOLL_GET | FOLL_HWPOISON)

get_user_pages_unlocked() is the appropriate interface here because the
current gup_fast_fallback() flag mask rejects FOLL_HWPOISON, while the
memory-failure madvise path enters madvise_inject_error() without
mmap_lock held. get_user_pages_unlocked() acquires and releases mmap_lock
internally, handles fault retries, and propagates -EHWPOISON from the
fault path. FOLL_GET makes the page-reference ownership consumed by
MF_COUNT_INCREASED explicit.

A successful GUP is followed by memory_failure(). If GUP returns
-EHWPOISON, the address was already covered by an earlier larger-granularit=
y
injection, so the walker continues with the next base-page address. Other
errors are returned. This avoids hugetlb, DAX, and folio-size inference in
the MADV_HWPOISON caller.

Device DAX is relevant only to MADV_HWPOISON because
MADV_SOFT_OFFLINE rejects ZONE_DEVICE pages. Since the proposed
MADV_HWPOISON walker advances by PAGE_SIZE and uses each GUP result as
feedback rather than inferring the handled range from folio_size(), it
should also avoid the same granularity problem for Device DAX. A
successful GUP is passed to memory_failure(), while -EHWPOISON indicates
that the address was already covered by an earlier injection. Advancing
by PAGE_SIZE should therefore also work for Device DAX in principle. I do
not currently have a suitable Device DAX setup, so this remains untested
at runtime.

Because MADV_SOFT_OFFLINE must advance past a hugetlb replacement while
MADV_HWPOISON can use FOLL_HWPOISON feedback during a PAGE_SIZE walk, I
plan to use separate walking models for the two operations.

Before posting another revision, I plan to split the work into:

1. the MADV_SOFT_OFFLINE range-walk fix;
2. MADV_SOFT_OFFLINE large-folio and hugetlb selftests;
3. the PAGE_SIZE + FOLL_HWPOISON MADV_HWPOISON walker;
4. MADV_HWPOISON large-folio and hugetlb selftests.

Does this separation of the SOFT_OFFLINE and HWPOISON walking models look
reasonable?

For stable, would you agree that I should omit the explicit stable Cc from
the next revision?

>
> >
> > --
> > Cheers,
> >
> > David
>
> --
> Cheers, Lorenzo

Thanks=EF=BC=8C
Yunhui

