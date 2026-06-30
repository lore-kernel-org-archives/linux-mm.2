Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6B9A9C43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 22:59:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 464CC6B00A6; Tue, 30 Jun 2026 18:59:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 43C476B00A8; Tue, 30 Jun 2026 18:59:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 353126B00A9; Tue, 30 Jun 2026 18:59:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 102086B00A6
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 18:59:55 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 7F4AD1A0168
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 22:59:54 +0000 (UTC)
X-FDA: 84938098308.27.EF9B77B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id 906488000B
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 22:59:52 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cisf+Gl7;
	spf=pass (imf30.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782860392;
	b=q2hVQu8+DnFPw0ywLm4BfYbJ/tjoNaVcRWdFyenM0ZLQUvXzvSejGhZ4+PEffDy1O4s3vN
	BTJzfjZ+qsre/zHXCouK5x3y2Z2SzxXUdmEVk5MnJ0Wq6mhGQKDqG2tYjvWTLNF1+5LV2u
	AT12lGO1lbiU2V1o0ky2TOWhD07BDRA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782860392;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kOVmM4/AosQCiLN3ovF3qcI1V/16wuqJThXPx/aR+ag=;
	b=IkqT7hSwZEqPTks92BepTZayPkHiYaXc2c6xUofn2Vo0c/p6hm97ddXr7xzuzJOt3fEiet
	JZPMjS/HNWPJEq2qP2LrmPZrvRHteScgv5+aLbwKEqhaEPlWCal8Fucacj9GPXMc9YCnoh
	sI4ml56L6RuLpgpyqnF2Fthm4dZp1Jo=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cisf+Gl7;
	spf=pass (imf30.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C5F434402C
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 22:59:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5D6D1F00ADE
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 22:59:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782860391;
	bh=kOVmM4/AosQCiLN3ovF3qcI1V/16wuqJThXPx/aR+ag=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=cisf+Gl7E1MxtQBHSM2rD6/nc7+X6Y9favg46tG9cN9e1X52oPXNcJBUfbnlay80E
	 mK/rCmEfYfKdr6ujtBh9RBMJqroZQt1Kdl5s7lXMKC349bkPwfGb2vMW6O/rJnlAnI
	 nW4gHMuUpUcn7GYjNUQAbxydG3bGmNgzYTiOy02BJWRGjo3J6tLl5859iOOqYkd3HX
	 rSfDKw2gLpJeXGWnGRX28aJL1heqcmrQe/Y1IuTuap9iWduJATi+gPvre7aFeywFBu
	 1TMF+HpRO8WuzITYBp0tYIUF22iNyl8sc2Z7xTFD/e0KglREnYZQWWFJfgTccTlXfH
	 DZNl656aDAMSA==
Received: by mail-qt1-f179.google.com with SMTP id d75a77b69052e-519e7faecf1so19961cf.0
        for <linux-mm@kvack.org>; Tue, 30 Jun 2026 15:59:51 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ+Kwqvl39C6mwDEfWVzOlUPXAn6FhdUmRP9hPTuvdEp3Xt2ZkwcBQ4ME6iURiioN6nEZKWyKovSSg==@kvack.org
X-Gm-Message-State: AOJu0YyrNKYr2w9VWI/6v7Lp8ygcxmG/DvWsTp5H09BCxOjVu3F5gg67
	eiGThpGCTAkxlHPvqJ5MMhljIqk+wLWjc87A5HZbUYrFaw41E1vVwNuViArVki6iUWR2XhlSH9d
	bvtOoPmn+/6dHk05UaF03VyQXhkCz8lk=
X-Received: by 2002:a05:622a:153:b0:51c:61a:50fa with SMTP id
 d75a77b69052e-51c1cb70380mr38375681cf.39.1782860391043; Tue, 30 Jun 2026
 15:59:51 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1782538002.git.zhengqi.arch@bytedance.com> <e2bd33d5-4de5-49cd-970f-9e80eec91a3b@kernel.org>
In-Reply-To: <e2bd33d5-4de5-49cd-970f-9e80eec91a3b@kernel.org>
From: Barry Song <baohua@kernel.org>
Date: Wed, 1 Jul 2026 06:59:39 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4zuxaqXQgrg_SiGY4gV4t3FQHdeM91dH4Y3-RknE7mg-g@mail.gmail.com>
X-Gm-Features: AVVi8Cei-wYubj1t5SAceANtsYmDrIvjgeVTr0RqjNKD9Er8kCEVvz7bYg_kPPA
Message-ID: <CAGsJ_4zuxaqXQgrg_SiGY4gV4t3FQHdeM91dH4Y3-RknE7mg-g@mail.gmail.com>
Subject: Re: [RFC PATCH 0/8] Introducte Reserved THP
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Qi Zheng <qi.zheng@linux.dev>, akpm@linux-foundation.org, ljs@kernel.org, 
	ziy@nvidia.com, baolin.wang@linux.alibaba.com, liam@infradead.org, 
	npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com, 
	lance.yang@linux.dev, muchun.song@linux.dev, osalvador@suse.de, 
	chrisl@kernel.org, kasong@tencent.com, shikemeng@huaweicloud.com, 
	nphamcs@gmail.com, baoquan.he@linux.dev, youngjun.park@lge.com, 
	peterx@redhat.com, usama.arif@linux.dev, willy@infradead.org, 
	vbabka@kernel.org, surenb@google.com, mhocko@suse.com, jackmanb@google.com, 
	hannes@cmpxchg.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Qi Zheng <zhengqi.arch@bytedance.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 906488000B
X-Stat-Signature: 4ch7jbbuo5f16jwor4w3pq859tnfgs1q
X-HE-Tag: 1782860392-91435
X-HE-Meta: U2FsdGVkX1+6GZIBIaUcqhevd7znzDJZxy57/Za2lbRfx5IGdgSuXfew1MwlgMdMQd9qaXO/7TJo3MfgNGLgGBNAV6ioMh6/4FPTPvOostps441C+L9iKEhkNbbst3jkTrzxJzPX1LJmfyl+fmBzhYxhgRJknjYTNLWcSqpKOHFncfoJPip0FgfIPsPS06n2wimHs0IzKJbZhgZCIpzUElM0Xkaa31Jh3jyBuJWxZfTA2RXNv4Gw/QmgVCQDXVEWN9WuNN2xmVuPvnb8rYNWytJWOGR9h6isnfkRhAZWtx/N+WOOI1nHHfwkCMsuDRxDCQx2mm3lxXXbp0gWGxd6ESLMrsft8k0H3rfUefE71bcmWYE30hWkhR5DIauVK/zRo+IO5q/AT68Dp59DFKkNPLNfJtqiS3xZH8bvNpHGqKLZr0U4nAv+JBAUx+M0Mnc3Abv7sW5B8dNojwoXt9TMB3rsyzE7P76zhtG8dPr3nTShNbprf0DlYGTl/IyaHysd+lN0XElzWwWFmiPp+RSi6zEUxlQRN132L/i2nxiM7to0yplN8bRWWIa7Cn44y7uHnGsGUKgardxHQ0MO1ubbW3/6uGa8m2lLzow9XLM2jp27CvskQ5xknAcj0xw+fOYxMGZvDC8CKtrLbGfBgmz/OckQgr+d8+hzVyHQZyWIrcv0LLp7aRBp1F/qgyhPncswneEKiquUQ5KCO7cYqbyLdtOpMkfW31iO6tWXr6Xc43rFN7n8YAiL1kdm6eeMd+LWFDOncCukiMIWTDof+sP16AnRBcY/IB0t+xrox4Y1Fpx/sFioQ5NT41eOFiNvKNt+8UV3xaF6wjP+D71Jk2+qd942fZMSgYj3wB2SG8o+hd+lR++WcrClktn/ZEKQRV44zDHp8jjtJz2eycIkNzKI3nu8Ip5Hqk2Ly3J9T17vI0Wex9PNpdHF1y7bY74oZjJuoIy3j1X1lgbW6CVYmwC
 V79afGw+
 8mz3SJ5pXaiqKIFrWC540XeW56Ir2xUFLc5IjhEHm6Eag1mSjJ/g7+9FOAUM0215Lg0s8XhlyS81ItIOzApyZqidu+HN0LdINDkl3V5Xnt3JIL12XnJ/j4iwarOP/7aUUtO/o44xjWzUDdoD9EJQS9skQTW5F8WM6voNOsoFQEvnwf3lmaq/ysJIBRdPvN3mRFqR5lSHlJhhjvm8U23sNcmQd5NthbnAkm+7IHBfSHfZh0lR6q64UPvnT4GM29XPtwEo1RF/W86JdKsj4VqJ75eHQqX8xQbO2aCph356GN52RVqhvUeIDDgtl9MGN83KVNEG+tlBjADapXM0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 29, 2026 at 8:20=E2=80=AFPM David Hildenbrand (Arm)
<david@kernel.org> wrote:
[...]
> >
> > 2. Implementation
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> >
> > In 2024, Yu Zhao proposed a similar idea:
> >
> > Link: https://lore.kernel.org/all/20240229183436.4110845-2-yuzhao@googl=
e.com/
> >
> > The idea was to introduce two virt zones: ZONE_NOSPLIT and ZONE_NOMERGE=
 to
> > guarantee the allocation success rate of THP, achieving an effect simil=
ar to
> > reservation. However, it seems there was no further progress, perhaps b=
ecause of
> > reluctance to introduce more virt zones like ZONE_MOVABLE.
> >
> > This RFC wants to discuss another implementation:
> >
> > 1. Introduce a new migratetype: MIGRATE_RESERVED_THP.
> > 2. Introduce two new hugetlb-like kernel boot parameters: `thp_reserved=
_size`
> >    and `thp_reserved_nr`. When set, the required memory is marked as
> >    MIGRATE_RESERVED_THP and put back into the buddy allocator.
>
> I'm all for some mechanism to make runtime allocation of large chunks of =
memory
> easier, by adding a pool from where multiple consumers (THP, guest_memfd,
> hugetlb, whatever) can allocate memory.
>
> Call me very skeptical of getting the page allocator involved like this. =
(I hate it)

One thing we've been thinking about for a while is whether we can
introduce something at the pageblock level to let memory "remember"
which allocation order is preferred within that pageblock.

For example, if we ever allocate an order-0 page from pageblock 100,
that pageblock would later prefer order-0 allocations. Similarly, if
we allocate a large folio from pageblock 200, we would avoid using
pageblock 200 for order-0 allocations as long as there is still
memory available in pageblock 100 for order-0.

Since order-0 allocations are often the main source of fragmentation,
if we already have both pagecache and anonymous large folios, we may
care more about containing or quarantining order-0 allocations in
certain areas, rather than trying to maintain a large-folio pool or
similar strategy.

Chris=E2=80=99s de-fragmentation of swap slots[1] seems to be a big success
based on my observations, where he provides a similar memory-order
preference for swap clusters. There is no reservation mechanism, no
sysfs knob, and no need to split swap into two areas=E2=80=94everything
just works automatically.

I wonder if you would be interested in something similar at the
pageblock level. If so, I=E2=80=99d be happy to work on a prototype in
August. I=E2=80=99m completely booked in July.

[1] https://lore.kernel.org/all/20240730-swap-allocator-v5-0-cb9c148b9297@k=
ernel.org/

Best Regards
Barry

