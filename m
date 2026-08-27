Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BB93EC61DB9
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 17:38:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C134F6B0096; Thu, 27 Aug 2026 13:38:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BEAED6B0098; Thu, 27 Aug 2026 13:38:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ADA196B0099; Thu, 27 Aug 2026 13:38:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 86F0A6B0096
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 13:38:02 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 248FC40148
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 17:38:02 +0000 (UTC)
X-FDA: 85147757604.25.EC2349E
Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	by imf08.hostedemail.com (Postfix) with ESMTP id 3A8B116000A
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 17:38:00 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=DldfnD15;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf08.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.51 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787852280;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kPHaEe57cuLcNj926FYE8F74J4KSg+lREB21aJh7hOA=;
	b=tFQ0wiAw5wNFLYhRgNLkMBKlrVBAq+WLtPbfjh7Sw01lOpIChT3jf+ECEqspicxpYKhr+8
	UoOtce3PnakPD2oylokBkf9rnEzvGh4vHRGDgR2F943ghzzmSijPaTuSCFfI/SoOWrHs+4
	gvvSXr5X8TmeOnvHVDewpVDOf5jdMoI=
ARC-Authentication-Results: i=2;
	imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=DldfnD15;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf08.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.51 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1787852280;
	b=3ZlN2CGSzt0oogASkVwdYDSeqKXBMhMP1qG+SR3GYiFpejfzoOM2WwHZYPl05IAPuiFCoZ
	3dX/td3QsCk/pB5vb/7s8Gi3pwP23RZ5ei+Q4ZaTmjhZb6lKTNHa0EFXU8L34eTxMNcpmP
	OHl8ZXgbeRyl1eTk3S14hXK3q4fI6n8=
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-c252e703fa3so14978166b.3
        for <linux-mm@kvack.org>; Thu, 27 Aug 2026 10:37:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787852279; cv=none;
        d=google.com; s=arc-20260327;
        b=p6OoKEHVeOJF+BqrhEWbWX1WOQVH348c/MhkOfE1jArqgLU0oLPagSqA0wwkUJWUHi
         RZmLt9q+KlVS4MUvWUqxtgnobc4MhZhmuNabyNC1xIdM5ZT3YrmgY9SykqI6V6Gw3R4R
         Vc/niK6nPFFMxzNgqnetzINxqXWgrfqLnd70d38q5i9uTcsy6qtFqfYjPilojG+Vc1XD
         15P9ZX5ycLdGYRKV3i8Fy31rFhm5gc8wCoSSXYSkXRnpX8XIimn2osob663UFWebPzqa
         +edEipWJ3imzvEujb5PC0akjfuiPo7b3zT5/NAgHsC0bL93JBqM1KqJfYfclL7bYj3Fb
         Scfg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=kPHaEe57cuLcNj926FYE8F74J4KSg+lREB21aJh7hOA=;
        fh=gW5ivs51vbjATpS7fTtCbsRWfHNWurt1lFXO5nnQLVM=;
        b=H0c/lJvFth6AawX2FcgVrK5pR1f5w5MK4ehewb6R+g6cDDcFJbn02wHugIBdRLpv8N
         8F3TrQ+EgTC+MU6wlQ3FfdJ44pmstzvCXj5naSatUbJxQ8c/L5497pfa2Cvtf6jjztZA
         sXldWOBq/RCxCR3bvyQ0kHMaNCg+UGY2TR4LrKP7WHQGKH3Ancn2MKyJATfFCnoSBVte
         uxzLLmP38Q7NGPLFT1Nanq9xCDkzhnZzeMME33WkIrTRQpdEi5mbM0VcWqKzMLsMxuja
         YP0dm9JZ0zz7pywmSf+eeQR1wG1I1sQF6gQDz2+XM3XPc15QIg3grOzbPj1ze2g36V5c
         Leig==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787852279; x=1788457079; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=kPHaEe57cuLcNj926FYE8F74J4KSg+lREB21aJh7hOA=;
        b=DldfnD158H1CbEzw5llWbP2Oxykg2BgIL++/+0ElbOoE36zufZktVoA0LhPucBt9Lj
         /yzGHNBuf8rd/06JFyhJmAfscOA0gZK5b/u/Kq2a6I65Pwn2k1aohoMRbDzBp3y4TjK3
         AJpFLcPE1FZi09sEjSmdU+JRDs0AttNYRz+ENRMlHPeWGnaXJ5dTBb9uXUIzuJTN4Ai3
         HMC6mFhIvsYDid0FdUSzOq/F5b0dJosvKXz8w3kPDt2FTecKDzWsLZnLgtSQY5KMg007
         64giyrPg7/vg1szN3dy/TzrsPAtsrsRwIMdO7sqUcFxMJ5cvbHSq1F7w8iZ8it5s2bmh
         g1nA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787852279; x=1788457079;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=kPHaEe57cuLcNj926FYE8F74J4KSg+lREB21aJh7hOA=;
        b=q9TVFF9ZsZWJ3DKKma0Eg+kJE1kExEEGaKKghZ2+oSKWJHy/7RrOlLGLX+gG/Uzp7j
         o19uGUZjNZVmuZhYcg/Rs218kJGOQcUqy6qjRTBsUwMcVyVB/keD/qTUNcSvWCaQC+OF
         2/E9LHyVXvMWJwjgCsZx+MU+v1IsKcke2L4TurERKqccazPbL7PiPre6bYzkxHtgSKsF
         +zuI8l1mSF85Fbc9sT2DP3PaPIAqtb6qq0dCBwEEKrzCPNm/sZiGGjlEmnslFRbLmosK
         QLxePeZtx+vK/i3zPu51zN/4wa4ZftbJ+Zl5NqEOzuXQah583iDRPKZUlS0nIfctzkLR
         0abg==
X-Gm-Message-State: AFuF++lBHqipeQdRCQyS33PqrLAwN3sVc2r1WMZQgB66dKILL2dli1ck
	T4hl6a+5gFqNL15GjoNsj8jZ6OdnmIMHLYXFstiW510L3CwoUy/wtFPf3O+LZ6sy4Gzq7HJoIQg
	MiKJJBzvneVzYiS/7i6+ruzrSR0cummw=
X-Gm-Gg: AR+sD11rXR3E2iEnY3jnWP0VxW+wl35vkz0dkIkz6X7bBaBcRBr21nCPjG7Gbwizr7c
	AVQnjoqv1ldRNNy3PoDEnCkk8e34BzSkfc59xLC3syIvoLRS6W+8FVJukZvL0z4s88TfEJqKGZV
	veBkc41Gv3DLMVU8Ygfj7ygV1fEI1lrqm+4CBDmeIW2xQ4oLIhmXhhwelo8NErF/IVlechrJg1A
	Kf4A3EOMcKAYr1lip8R1Iqp/UgPFuOCTxTHdq2lNwEMTx4vkwi2rVJlmvS8qqgyR4YOdqDCF9JS
	V+D60cJ4FIxe9SczObJGACReRqL/MPnvNvHPjrNjpJ07qLK+odLN+W3h12XQyv7x58jhmATaNRa
	v4SlJuSRZgOo=
X-Received: by 2002:a17:907:6d05:b0:c25:5a7:87f with SMTP id
 a640c23a62f3a-c25566499e8mr34430266b.0.1787852278645; Thu, 27 Aug 2026
 10:37:58 -0700 (PDT)
MIME-Version: 1.0
References: <20260821-swap-thp-cleanup-v3-0-9b43f5163238@tencent.com>
 <20260821-swap-thp-cleanup-v3-9-9b43f5163238@tencent.com> <acdfa561-0690-4c78-bc50-92d308f4dca0@kernel.org>
In-Reply-To: <acdfa561-0690-4c78-bc50-92d308f4dca0@kernel.org>
From: Kairui Song <ryncsn@gmail.com>
Date: Fri, 28 Aug 2026 01:37:20 +0800
X-Gm-Features: AcwNN1XusF7KPTBCbFIorg-MpoUYcu7AsrCOyjMNN0VFuVbYt9OK7HHTzHSMN6Q
Message-ID: <CAMgjq7BExecZ_Yo_ehoisUUDDMpvPxw2H0BWFocAMNMjMSMLLw@mail.gmail.com>
Subject: Re: [PATCH v3 09/18] mm/huge_memory: move anon_vma and filemap
 management into split helpers
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <liam@infradead.org>, 
	Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Chris Li <chrisl@kernel.org>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
	Baoquan He <baoquan.he@linux.dev>, Barry Song <baohua@kernel.org>, 
	Youngjun Park <youngjun.park@lge.com>, Shivam Kalra <shivamkalra98@zohomail.in>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: 8so8xbdn6i8gnp1c3yq583xtdru9dq3k
X-Rspamd-Queue-Id: 3A8B116000A
X-HE-Tag: 1787852280-485565
X-HE-Meta: U2FsdGVkX197CZYVQlyfCFKS0T2Q7T/IDpccZGNHxdtfBmwWqg7B4yJ9uylC2Z1aigugAPDCgWNUNOUJukWu4mW08bSbv/HN8oOgKJzx9q2CoxKNtz5oZUc9VEC4TNnVGd/A1rNF4lEMz5mJ4I0KmNZ+z+yvwUVVrfQHtHCuI+5+8KDMrc+v4UP1MUSVxi4zRgPBBsY/C+zsKc49WH5gRs+Q6YbfT+1os4abdjtlk6hcnxM+bjgqkeWg2XOk3QgtSqSxXGqYF0ALiAyyfaSzFcetrVoO5wWxp+5isM79iVUiFe6XxMw55m8gbB1tRDlGHuihnxIf0nu/8SXQ071izT2nkY9Mc9KnpcW9WowcbbHJ/EvxTlsioTB4Z76gJzeaIQ7aEcbGnCgXF7Bzq44K2zrF9CecGQMa9sNW8mfrPUXMjj6zbCUgreUGOQAjwIiV6bj5NdRo7j4PbZM47akqyYpAA8vMNIBs2Y8WFiGrbtYhnxeLnoP3ry2nuTTeDtmofKOybtteaG/3au5trn0kGygSRHeZrCctrLMEuP/W+vvmI6WXNmp/fNQatIjtACqek14mIhnMEgxsZMDUVabKZqZwVSV9cB8kLT77Ohs5yHg7eA9iQmasjGM+mAxda6EQc4jwoZ3uIFjXHWZDtWQB9ZtZ22zJiI2TC87rrv0rK6KOUxkfqNt157khmc4OP5d7S/QOxG9y2C4pb5zN4zy0Ft96n+Zvbop4RCVtNZ7A+oAG3hSC4xMP9D8FqRWJANBI2XgzdKy89AAKBMSeGmMo7gaI2BG2ENIorrdbUIJArcwaZbKugi+65c1oVgUzpnTPOI/6X57cxT8sdZYnwV3kGISspDk2ec86lNCi2hXEv+sMk63fZfW4LZS6MZUdHzck2con2jAxOh917/bl/wiHbe5pTbPLDDN+yEBF9zCWyUOClWm13LNLN1dfBEnBUmR9yJW0DGPEV3x4nLoS1cw
 ZhxENvld
 EXh8L3KFWFxb8HUa0YnGVl3Ei+Xro6DqTBWW1Y5EGDxtZrmlbRy+HokBo85jSjfzSrliSaFck+BBBfWVG2B8N9faZyZRKgtsvO2YE7ewTjK9MdBJB7lNPOc8my0ECrblRVWinwi1eGcI4pmgMWGQZToXs8mBZCkt+KMWbv+rjsjK2FwkeJWUhaGNVJpW06wXUhh/iN1HdAhCuMnZ+H9g+3NkRi+icRl1+i1oFWAqKlIU9UzPNhViyCjbazumIp0VITz+egSSPOLzJM2Zq9ufEwbJjH1OzADcs2IBDs+wc2Ku4Csos83mH+mdGc8zSASvoQKBQlLCXQx65YRM7bYcqlto7JwiU3bC4Stbf7760qPpo5Usk1wzawbtUEaYhUBEgHbOD6V2a1LMnzGAd9oEChSftjHjT2e/KxLDNEfuWCBlxvIFfxDzie4L7psiBM7E4LICnrQZaxcvh7TC5GnnP7muGCcXCG1HwqcSQmpGSFMTQprI+FiR8UkcJJ6pbkAw4uFb6g9M/pz7L0c0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 28, 2026 at 12:36=E2=80=AFAM David Hildenbrand (Arm)
<david@kernel.org> wrote:
>
> On 8/20/26 20:55, Kairui Song via B4 Relay wrote:
> > From: Kairui Song <kasong@tencent.com>
> >
> > Only anon split needs vma info, and only file split needs the filemap
> > handling. Move the related code into separate helpers so they are
> > genuinely more self-contained.
>
> This patch seems to do more than that, like relocating the
> folio_expected_ref_count check (and duplicating it, which is not so nice)=
.
>
> >
> > Reviewed-by: Zi Yan <ziy@nvidia.com>
> > Signed-off-by: Kairui Song <kasong@tencent.com>
> > ---
>
> [...]
>
> > -     /*
> > -      * Racy check if we can split the page, before unmap_folio() will
> > -      * split PMDs
> > -      */
> > -     if (folio_expected_ref_count(folio) !=3D folio_ref_count(folio) -=
 1) {
> > -             ret =3D -EAGAIN;
> > -             goto out_unlock;
> > -     }
> > -
> > -     if (!is_anon) {
> > -             ret =3D __folio_split_unmap_and_freeze_file(folio, new_or=
der, split_at, &xas, mapping,
> > -                                                       true, list, spl=
it_type);
> > -     } else {
> > +     if (is_anon)
> >               ret =3D __folio_split_unmap_and_freeze_anon(folio, new_or=
der, split_at, true,
> >                                                         true, list, spl=
it_type);
> > -     }
>
> Inverting the conditional seems to produce unnecessary noise in this patc=
h.

Will try to make this look nicer.

