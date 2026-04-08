Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 48ACD10FC440
	for <linux-mm@archiver.kernel.org>; Wed,  8 Apr 2026 21:29:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6D5226B0005; Wed,  8 Apr 2026 17:29:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 685DD6B0088; Wed,  8 Apr 2026 17:29:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 59BC46B0089; Wed,  8 Apr 2026 17:29:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 495216B0005
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 17:29:41 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E6203B7460
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 21:29:40 +0000 (UTC)
X-FDA: 84636680520.28.D9ECED4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id E0E75140006
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 21:29:38 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="mShnAkf/";
	spf=pass (imf09.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="mShnAkf/";
	spf=pass (imf09.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775683779; a=rsa-sha256;
	cv=none;
	b=EkCALHzFeDfeOZxVinTScvshzQIjKrsPmvALEQrwx103yzo2UQEsopZYa6cUvX0IdeF7MP
	UoVrOrv+kLSkRiYUlcT7EgkU3QZ+WcJFBL9hxphiML62ioIyx5nD6fmKRrixtnoM7/QG2w
	G1lEITPCJ9v48txDHPuHcCW/QIjrF18=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775683779;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hQX7iZU1sLRdwZhoYb3R3nLptKkjtedR7BZxMeedyD4=;
	b=H8g3nocpcC8K1NG3HZOYicgPFSg19i2pJQARDextc4bry9UA9bx6p6sw6NgpgpnOhiLmEl
	3aRCppjZPX15wcAmtQBqQ0eyk5DJ1Y+Y7E+fy37lw5hhrC3+3soybaUsxONlIvUniUW1rP
	2Suf+IeGt018S/XOtBzHTO6fa9OThi4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 974444451C
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 21:29:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D953C2BC9E
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 21:29:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775683777;
	bh=Y/lmxQXbhWG5INKynpR7jdhH5uj4BdkuJqvEO5FdF8Y=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=mShnAkf/k0d/LPFZwfdKiBYhDDRse6tKDagf1kPr0oc2h9w/psRVyY/VbUi3fNrb/
	 UwejrwtODpxGK4z79tPZavt95SOnbd9sQLRlk39P65hH7VVNgNbtEk/e5DbB/+7/bP
	 5B1vSYWraZaEkPnl8p2FqY/yFJPFQwjm9t9YWKptwjSJFVpG65JiB+ZDSD1GSyxYHm
	 xfrrdmbqoXEBePOAjVHkqhnlYkckawhDLioIf+F6YK0jJTGJ2OKAppfEQDJOnhw7xM
	 N678+2fkcGmpwmOX8M7g5QP1A2k0MROxHaQA2BcOtjrzzDO/BD8NZq4JkLEC3Lb2Fq
	 4WwEwNJCm7Zrw==
Received: by mail-qv1-f43.google.com with SMTP id 6a1803df08f44-8a23f802e0cso3916956d6.1
        for <linux-mm@kvack.org>; Wed, 08 Apr 2026 14:29:37 -0700 (PDT)
X-Gm-Message-State: AOJu0Yw+ES/vBhhUJN24+Y/HEQnzxZ2gDJAaY7nA45lciuQN4EFBP05U
	1W1SS4fkq2bzZXBofdJWjF0/A9G7Gs1zJx1mkb9I9koeFje4bpUga5+ldrjZI/vfZ6OIABDV5+/
	8q4rsNV9yLetVlfYJ82KN5sgiy8vs2s4=
X-Received: by 2002:a05:6214:1d0a:b0:8ac:74d7:dd14 with SMTP id
 6a1803df08f44-8ac74d7debcmr15884866d6.34.1775683776598; Wed, 08 Apr 2026
 14:29:36 -0700 (PDT)
MIME-Version: 1.0
References: <20260408025115.27368-1-baohua@kernel.org> <20260408025115.27368-4-baohua@kernel.org>
 <f661064f-269c-4e1d-8d6c-a9a2e50cd82c@arm.com>
In-Reply-To: <f661064f-269c-4e1d-8d6c-a9a2e50cd82c@arm.com>
From: Barry Song <baohua@kernel.org>
Date: Thu, 9 Apr 2026 05:29:25 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4x-7tk6FPM5eN+o2=1ewbbCvrGYSG-qk1FybnhYAqU0xg@mail.gmail.com>
X-Gm-Features: AQROBzDD8xzlg0Uj1HRs0Wqi-s5iSaX2fFmsZNIkL6fa0v5sA5A7gsWqrrxGDtU
Message-ID: <CAGsJ_4x-7tk6FPM5eN+o2=1ewbbCvrGYSG-qk1FybnhYAqU0xg@mail.gmail.com>
Subject: Re: [RFC PATCH 3/8] mm/vmalloc: Extend vmap_small_pages_range_noflush()
 to support larger page_shift sizes
To: Dev Jain <dev.jain@arm.com>
Cc: linux-mm@kvack.org, linux-arm-kernel@lists.infradead.org, 
	catalin.marinas@arm.com, will@kernel.org, akpm@linux-foundation.org, 
	urezki@gmail.com, linux-kernel@vger.kernel.org, anshuman.khandual@arm.com, 
	ryan.roberts@arm.com, ajd@linux.ibm.com, rppt@kernel.org, david@kernel.org, 
	Xueyuan.chen21@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: E0E75140006
X-Stat-Signature: i4tk6sf84uidj9cwkwwyfc9uwtygs7pp
X-Rspam-User: 
X-HE-Tag: 1775683778-142236
X-HE-Meta: U2FsdGVkX1803Yh4aFOS1xYIa0F3g953Reaf01g5oiGmWlVHQbfqGEGa+t7qya93iigV0ZaVDGyYuUr8y+bbXcB4K79oLJB0k1dx07xehLqRonQaRgbxxNHzUj78mAc+GTspz+NavW72b1hDF8InIBrfoETTz6vRt9AWOY+Vy25IgBjveUqFnTnjtRvhK+dPSlnmaVwA3pYFivkJPqe6MzdHD76cchiWZLvZwoNMtU56RrvT9cyAYrm/gBufwB81d7Hdx858bmqto2V+8dNJvgEkItThI+nW5uGuRJD/8t24LtOftG647p4qG7NfiouFhOniP9zL3zs8hT4BjBKWaF3SZvyA1ZT9yljCV0D0dirqDrVQ7V0ITZ4RWx1ozTdphrChBu6fRqfeGcjwqNXQLR8mZjMrU2Lh9e4el4vwgJOYWCtmAa4Gq5c/ijMLqwk3NwqbpDhqsfceXI89+Tq4uzm5lfLH++WWJdYdJfUN+yUuERm9vABd0OwxKARM2bSLoQilao1sJYNxSWbff8v8o5AnV2xrumTAlzGZHPJp7Cb4cSvdfdJFz6Bzlz/NxwivzeSJYR7XUBLs3gm6g47pMBm99fnNVqF1IamJYdhtX8yg+/wGc3TEnW4d1gPFtTKKelARK0PxgxsRj1YT+GUX9J/8vjWQAykKxKdgM+0AbhTlrS1O/zGOLTGdD1AaQlpw4M6PuW8XgI9KmwQXI1TnTuHS0SeX3aplujQK2k+lximXYLk40Yn3SN4fdUp2Os8+hahs6fpIsrPkx3BLHmGBSjEaNU0PGJcs2+H4/SOU1oZiVNXLgyQt0DscO4xagKWwiJwSjzH5D0MOZKA9AYayZ6hgg/BSrzSTwm5/IlMHU9fE6L4YdMAjN/S6vCxUAawrn3Q2Qjw90dGjwfRnU7bhhCm7wAIHq5gYsOjJFf4nWBMc0pKsH0kySGfKRcPQDfzbBBxpPsFXT8xlVRw5VoK
 jTL8OoJz
 bZlqP8up3nQ0NBHsWgVduRzre6nGq9I5FuF92dkiXpG54ny2mQAAV7ax+XJKmA2K89voPGsyQgXqydBoL9/A1fw0dNsVPLNOVBQCwMw1t6AH8nmEKSicpTDV5hfHtXHoV9ogJq5vvvq/ceVnfe9lhFTHuqwocLfJ/mD3OUIn5iqpMtgM9bAEllV5pGOqdunCQvPdzClKuts8Hsfe8TQIvs9ralVi565iB1gFye8SY+iuZRtkqt5t0r2ntEwKa0KSY6Te/YjYj/APyft/9M24seVJKTQzQGeqLejIX4goeI4FJhWMyKWgfd4OU6s+xn108Uhgf65aIS1WhUA8HXkKeiCCY4tHYjvHPd08PnRTWHEaI+3fLfdVwssI0NiAWhFKDLfu5htEqNiP2NdHPl9Jnw920DAJAjZ+6xiDIUAJBBPPrSQhtS2u1SC0jWN1NMdKn8r8JeQL1lRu1/RA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Apr 8, 2026 at 7:08=E2=80=AFPM Dev Jain <dev.jain@arm.com> wrote:
>
>
>
> On 08/04/26 8:21 am, Barry Song (Xiaomi) wrote:
> > vmap_small_pages_range_noflush() provides a clean interface by taking
> > struct page **pages and mapping them via direct PTE iteration. This
> > avoids the page table zigzag seen when using
>
> "Zigzag" is ambiguous. Just say "page table rewalk". Also please
> elaborate on why the rewalk is happening currently.

Sure=E2=80=94I=E2=80=99m not a native speaker, but =E2=80=9Czigzag=E2=80=9D=
 feels like
=E2=80=9Crepeatedly walking the page tables back and forth=E2=80=9D to me.
That=E2=80=99s exactly what I want to express.

>
> > vmap_range_noflush() for page_shift values other than PAGE_SHIFT.
> >
> > Extend it to support larger page_shift values, and add PMD- and
> > contiguous-PTE mappings as well.
>
> So we can drop the "small" here since now it supports larger chunks
> as well.

I=E2=80=99m still struggling with the name, since we already have a
function without =E2=80=9Csmall=E2=80=9D here:

int vmap_pages_range_noflush(unsigned long addr, unsigned long end,
                pgprot_t prot, struct page **pages, unsigned int page_shift=
,
                gfp_t gfp_mask)

>
> Also at this point the code you add is a no-op since you pass PAGE_SHIFT.
> Let us just squash patch 4 into this. This patch looks weird retaining
> the pagetable-rewalk algorithm when it literally adds functionality
> to avoid that.

Sure. will do.

Thanks
Barry

