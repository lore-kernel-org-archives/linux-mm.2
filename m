Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ECCB0C53200
	for <linux-mm@archiver.kernel.org>; Wed, 29 Jul 2026 04:39:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 64E836B0088; Wed, 29 Jul 2026 00:39:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6265B6B008A; Wed, 29 Jul 2026 00:39:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 52D656B008C; Wed, 29 Jul 2026 00:39:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 319486B0088
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 00:39:09 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B790B1405BC
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 04:39:08 +0000 (UTC)
X-FDA: 85040559576.11.8C415F8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id D291820009
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 04:39:06 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fTGpAqT8;
	spf=pass (imf13.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785299946;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nmixZEfyJshPgnbSdLOJ6mmAwvFWMoeYmvzBr3qbCRs=;
	b=bfraLqMK/JIamDEkRSnp8eLi8mfGJz4QSjSnTlwFEfR8nw/oES6f41UrzQLiOXa+/gvEWj
	xGFe+htqBQRdHNWiT3DD5/lYtFnn6vWcInp8L8Ss5J8ADi+OseuXNq3uEfFMoT9HqSdvfx
	RW76OifQZdMZ2oJdPhXNeZDs+WOFxXk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785299946;
	b=ft0pRPPCcwTfEwZFfvRX6FS064xXQL1sp5XW3f7OK94AabdSg8KM9w8tTowht0LH4pNWft
	glC7CmGiJMOaajLzutC1cTaI834PHW8EhV4E6ekrJOrvR/LC2b9zyeQWSae+2T8CYw/eGD
	3OCz2kbdVJ5g1I4G1wq0M89e4inmjbA=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fTGpAqT8;
	spf=pass (imf13.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 33EFA60A9D
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 04:39:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADF601F00ADB
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 04:39:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785299945;
	bh=nmixZEfyJshPgnbSdLOJ6mmAwvFWMoeYmvzBr3qbCRs=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=fTGpAqT894sz7e6Fd7jtewE7MzSr4V0SC3/lU+F0oI206vIx3Qp0xMHoVM/AKefEh
	 N9gr5Yer27N2YVlNrW3QMIq5l0OSRydMDIhMCQNymwHWhoOgeskMC2Ouud8f1JssSW
	 jRB812CzlQ1wlIfuzMX7soE+J1SgY/VH/xK2Gl4QaUXWq/Pex/52M5vAtyc9/s/F+y
	 yncIOaOKZEwZrG+wcYOc4qFo26gtQyp59az9HMR8gJZzXYwoWewZYjEpppWviSQB5t
	 cr4iDuEaI+nw9rlt7YGsa7zqhj6UV++i1NnLsf2iZJGD2N8Gsq7LsI6Aq6ASgLZKSN
	 uYEz/yQ6mlGfg==
Received: by mail-qk1-f173.google.com with SMTP id af79cd13be357-92e50979c71so54748685a.3
        for <linux-mm@kvack.org>; Tue, 28 Jul 2026 21:39:05 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RpQfSmG13Ct0FYLOTK/WB2+lS/4DhCgEvBPA7Ol2n0ICP6YacFRF2d4NeGDIfPerOvl+HeomUaCHQ==@kvack.org
X-Gm-Message-State: AOJu0YyKN7LorMBV62DI2dkpLTHUGacrpwue73Sdnn+4jQomdBivHhfl
	vI/mfY/u5yJcHNfPlxWam4bURQhQaSI7Xd/3F6jdIL1cps57SjndwFnv/+Z16zXXqC7V8JUBhwi
	idhGKV4IC0QDJ78iJvaPV/7iJAHkFr8E=
X-Received: by 2002:a05:620a:839a:b0:92e:694a:77b1 with SMTP id
 af79cd13be357-9330267b394mr478027485a.4.1785299944999; Tue, 28 Jul 2026
 21:39:04 -0700 (PDT)
MIME-Version: 1.0
References: <20260715120813.3609949-1-jiangwen6@xiaomi.com>
 <20260715120813.3609949-3-jiangwen6@xiaomi.com> <amib2d8um2ZwsMDU@willie-the-truck>
In-Reply-To: <amib2d8um2ZwsMDU@willie-the-truck>
From: Barry Song <baohua@kernel.org>
Date: Wed, 29 Jul 2026 12:38:52 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4wCPLZQbrgDnujxGDSyDQ8YeaPhuNP89yK-o1exe6kZfw@mail.gmail.com>
X-Gm-Features: AUfX_mxSl7FmCTPLbPin_HsGwEEMq7LdYhi94gKpfCRIekDy_TsQI9q2ZPSHUT4
Message-ID: <CAGsJ_4wCPLZQbrgDnujxGDSyDQ8YeaPhuNP89yK-o1exe6kZfw@mail.gmail.com>
Subject: Re: [PATCH v7 2/7] arm64/vmalloc: Allow arch_vmap_pte_range_map_size
 to batch multiple CONT_PTE
To: Will Deacon <will@kernel.org>
Cc: Wen Jiang <jiangwenxiaomi@gmail.com>, akpm@linux-foundation.org, 
	catalin.marinas@arm.com, linux-mm@kvack.org, urezki@gmail.com, 
	Xueyuan.chen21@gmail.com, ajd@linux.ibm.com, anshuman.khandual@arm.com, 
	david@kernel.org, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, rppt@kernel.org, ryan.roberts@arm.com, 
	dev.jain@arm.com, Wen Jiang <jiangwen6@xiaomi.com>, Leo Yan <leo.yan@arm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: D291820009
X-Stat-Signature: 8d3qxh8nxy3wja3g7jqs6r6qkcp51zi4
X-HE-Tag: 1785299946-568863
X-HE-Meta: U2FsdGVkX1+IqQuq5j3+7jRP4ybwLt/MUpCe+0Eo5w7l7aIbRp7CwjY7MPBGGdcVRA/ZqT8CTRCUPxr358b/zEcuSKH13u9BU8ZXYdGRu8g3zJhwhNarFdbRw+R9l7eU94LSm+qxSWOiFANsTEmkxSO4yeKL8MzXTvNcRp5FGR/gBZU5ig5E00rzP+0hxUPeL6CE64EC37OJlklNiPpc2k3Yciie5osPlllQnnqvPngXXXFCDbAj7L2y7MlGfVxeObcmeiiq5TR5xgYzaWB2QxlJLS7UnZiy7S1OFfTEYbM7BtYPBeiW5I52ywIiC1l/ytlX4Mb1Xku/GqB8XhjlHcJpJt3exNRNzUHveLiDlBOWrQe4eiV38oiL5JtaQFflRU+BNgVcPO4QeDpyH+1Tnewfl/z/B/jXD0FFnu/Xm6EDWyIyiRbb3p9Iqdd48Wuc4lh7HdIxtj3MEIgSLSHoOkpb1PzolJHB2r2QUOSo3jH2YxkskK/V8l8c/dUm3oW0aQgzylo7OBe0fmZdIzFgW0Cc243oKeh7AgmmWOXjYMHtm+8c3pNvq899Mocs0cOu63lIImGIH5hV7YUhgez2Wpahxuu+BMyCQCPF7s/6FBTHUu+bxIjZOPtf9RvkNX+O13T3eCoYx9P2PCNrxgqHj/2LOazSCZ/D7vVwYulEOtBrnPo4H+gGvCkur8AJb+XeZfmWxjeUrQWVvi2kOFdyTsHcnXLUZdhEBuyEe5Um1fe8qh8WMlZYpv+P2QbwIs24psiK44fkrxA6emwkPe1ma0/9p29E5byrapvkxhbvEiOqSN015iLqTtboQlLdXt4bIl2u1lQBVZ540z8+V+ToVaw79yuW8TvGny8pY9/lcEbFSd3VLRfPEXsb5/35LXOlnz+UwhbKxobO4mNp66gZnXFzpo7c/vbhIdM750utMCPSyM/v79svcXMRJTzIu7fxepV7EWpidVjUTSR9ltd
 wPagB09N
 je5C/5zzQUj+XnjKO+hwRqA9UQjhIASzrb8oANfTTdyCGUynlJkhALG5p1ZmkKUVZCUEUuKQiKdDjAtSQjUhmeXfKwnwXovco4TWajZK72IQHg0X3lvT12X7bQntel+yvbcKUib/AEzyW3Xa2DShgzDjgIB/Pz5e7qY7co4OtaNLwlAAupi9PMVsde0ldDDaDO5GwFYKGOzBREuQtcr2UkXqZBCdfSXcvT2O6fZPrl9cTDnPeBCB/ATBaKUBkLjjx3K3VOVS2/UKSxrZjZZChO1us53etGSgRDXTxzC1COFYyIxiI0DM8vzrPbXKHB6mJdZQ/3PfluwsEiyCU12GCquIHZTNL/om30Xjx5zUK2g3RItdjFQmX3fQ8yvUaeDODf6WAiIgH4t7pxLhS/SPWqwoCkZqv2TJEpf5z15v7xu3D/CE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 28, 2026 at 8:09=E2=80=AFPM Will Deacon <will@kernel.org> wrote=
:
>
[...]
> > @@ -40,7 +44,9 @@ static inline unsigned long arch_vmap_pte_range_map_s=
ize(unsigned long addr,
> >       if (!IS_ALIGNED(PFN_PHYS(pfn), CONT_PTE_SIZE))
> >               return PAGE_SIZE;
> >
> > -     return CONT_PTE_SIZE;
> > +     size =3D min3(end - addr, 1UL << max_page_shift, PMD_SIZE >> 1);
> > +     size =3D rounddown_pow_of_two(size);
> > +     return size;
>
> Why does this have to be a power of two? We should be able to work with
> regions where the start and end are suitably aligned. Is it because the
> hugetlb code works in terms of shifts?

Yep. For `vmap`, `vmalloc`, and `hugetlb`, this is all about
the page size shift, since their memory is typically backed by
the buddy allocator. However, after taking another look, I
think `ioremap()` could benefit. For example, if someone calls
`ioremap()` on a 576 KB region (64 KB * 9), we currently have
to map it as 512 KB + 64 KB. Without our patch, it would
require nine 64 KB mappings. If we allowed non-power-of-two
sizes, it could be mapped with single time.

So supporting non-power-of-two sizes might provide a small
performance benefit for `ioremap()`, although I suspect the
gain would be limited. I can investigate this as a follow-up
task, and if it turns out to provide a measurable improvement,
I can send an incremental patch.

Thanks
Barry

