Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F3846CCA471
	for <linux-mm@archiver.kernel.org>; Mon,  6 Oct 2025 06:49:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 611628E000C; Mon,  6 Oct 2025 02:49:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5E8B18E0002; Mon,  6 Oct 2025 02:49:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5262C8E000C; Mon,  6 Oct 2025 02:49:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 3F06A8E0002
	for <linux-mm@kvack.org>; Mon,  6 Oct 2025 02:49:19 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D24D413B1C9
	for <linux-mm@kvack.org>; Mon,  6 Oct 2025 06:49:18 +0000 (UTC)
X-FDA: 83966762796.17.EC0F0E3
Received: from out-171.mta1.migadu.com (out-171.mta1.migadu.com [95.215.58.171])
	by imf04.hostedemail.com (Postfix) with ESMTP id C8EBF4000C
	for <linux-mm@kvack.org>; Mon,  6 Oct 2025 06:49:16 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Sdv2jzyS;
	spf=pass (imf04.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.171 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759733357;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zsEsH22kDW1H5QvOcVfkUjtWSR98Rm+2/OnZ+CB+v1A=;
	b=yCpR0Nw59ZQU6w70eO4NZzFRWcSpivUghqxo6Rci9vce5QtH63TnXqrHK3DWhK4jqcwj2M
	o6EVTv9CC8iP8W+QjU5PbYshYrXDPtrlLzGhAOWW2lCNuutfJYcAe1GvZ52Bg8/x4H1ZGR
	qdhbnZJ9bT7pHkkXOY3Rbete4Vw7JKU=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Sdv2jzyS;
	spf=pass (imf04.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.171 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759733357; a=rsa-sha256;
	cv=none;
	b=U0eFGFZ+RicO+aJaMN/x2wuvXsNMj1d758sHY3ssc77E8d0dBCXoPXbh+xrkCm0+G7sKu5
	Kws6avvk9Ip+/YhapiwD/U5967oQPCy/z7eO8HorWJKD1H4m0zVTI4hRwxIR5+QY0FtxPv
	vomSLAGCp3RE63OiC15pa6FrPozzNwY=
X-Forwarded-Encrypted: i=1; AJvYcCV3GKBCBlWzo70wfopkG/hyyIerKbgWK/bHENIrl2yAkU0rZHY48YNFlc2QbHNdNWybHwrBsUIa+Q==@kvack.org
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1759733354;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zsEsH22kDW1H5QvOcVfkUjtWSR98Rm+2/OnZ+CB+v1A=;
	b=Sdv2jzySDkyhcXu40a3FFoK/fvsL1rmwp0YqG0e0M8zzoq0/+QOjjm5OAJdDbASTlJPjPv
	kC4UyTcJ/1fPjgmr7+5XATCWP5SRE0yF/3DqtfTUHlwaXWXZKh1p8AN67FcCuADKr3a7kY
	sBDzyATGlAjIlGGB+aA3jDLl5p986jg=
X-Gm-Message-State: AOJu0YzN/wTJ4G15MjRCWf7ad3frD3pLnwvubLYHcyvcuaQU0n2Ksr92
	OchxCTAUoOKzShOAknLNoIQaZlI+5hIY52zOLSL0vu6h179UHapzVOIZfU7yNKLX36tQK/P7PuT
	S2JFNzz32y2FFh/SWtxGNabRK8ccXQeI=
X-Google-Smtp-Source: AGHT+IH/gcahtyi1+R28TzwhM8PtxJZhWF/lZo0FhkNkmq0aCBod7bfx+312g6qjLNTYUImX2DAPVoxzuZOqqLk7Rho=
X-Received: by 2002:a05:6214:301b:b0:800:8e83:17ed with SMTP id
 6a1803df08f44-879dc77b870mr146020836d6.2.1759733351884; Sun, 05 Oct 2025
 23:49:11 -0700 (PDT)
MIME-Version: 1.0
References: <20251006055214.1845342-1-anshuman.khandual@arm.com>
 <4b513d32-7795-4998-98df-d398c3d5462a@arm.com> <1c948262-e201-4473-b156-8b90fedc9ce7@arm.com>
In-Reply-To: <1c948262-e201-4473-b156-8b90fedc9ce7@arm.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
Date: Mon, 6 Oct 2025 14:48:35 +0800
X-Gmail-Original-Message-ID: <CABzRoya4kGWCFL95B2NEoLk4Qk9c3Vs1694NSWPFhiQiFHyomg@mail.gmail.com>
X-Gm-Features: AS18NWC1StCtK5OBsLdKS2Uo36btm8pgGL6VfozmsZHbDnUVCBhw4W8BmS1RLoQ
Message-ID: <CABzRoya4kGWCFL95B2NEoLk4Qk9c3Vs1694NSWPFhiQiFHyomg@mail.gmail.com>
Subject: Re: [PATCH] mm/dirty: Replace READ_ONCE() with pudp_get()
To: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Dev Jain <dev.jain@arm.com>, linux-mm@kvack.org, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@redhat.com>, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: C8EBF4000C
X-Stat-Signature: oxwzm513d4audo4cer1jqhrtxt39muyc
X-HE-Tag: 1759733356-75702
X-HE-Meta: U2FsdGVkX1+kAln8GzMTLCmk/O7fI6vLhZVqtNzE40T+Pf2uinFPQ3JrsADy0R7HfYs0FPMbr4MDW64pdTa2E/sByafYSrwJRsumXOL07iq+uXYyQeL6ZlmKbkyO8vQP67UW236d64aT9CtvbPjWdOdMOC0kc9JEO3O77qWGNA1c0wymdxH9DIgv2xztmEg8Tb5Lz2nY6EIS9WkN2uhrNl6eaNwqo5bx3wqLLevlqCQfFJmVQnpEYXe/SqSkNMH75XlOLhdCCRQr8jzI4BFPz0o7k8g9bpxSocN8m13BfvnpJFxS2xnPN77yy5VP7Oyr7R+R4XIMvTKVTpw8xZEcA+PRFtz6iMI1pLz2uYGRGE+tf3I+0Coy+r28PDhAZcLGdc8onzEcW9XJSH/yejO09dfSrpDTsO1GS7InCF3lsLXyVJwhyVcIsmRgpdxp6nAzkvYGZTShbJOeUxwBPemeRRMAz13Qw7g5P6hjbxgtCR6/5AKnPOSp4LBuL49O9SgEQM8sAd4hNnkQ4YkTCNUuqVDgDPoJmXL9jCLCYS03XB2ppSAs2OqAibiymImBwnhNt9yIbkmh5X0h/3XmnHVznS6fr7k6MFiO3rjan/1N/R/ZkUFk8Gx/ZjwqFfXCuhozNcYyqsbPQAJvhPkveCrKBPbi5fMZizm4ardHeHmxsLIl+6Ld9ThRLhaldmNN1RQli3Xt+6ZOgJLdJwvhRGap9fZo72+hfV6cwbjnOsn+jcqCfyIcn9IlA3byvSKUJjwF4HF0wMxs/G3iIbj0Yb3Jji/2mhQrm4PQBNvQjOTNN738VnnjuC+FdnrMixrw00enPkudR659l3M=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Oct 6, 2025 at 2:28=E2=80=AFPM Anshuman Khandual
<anshuman.khandual@arm.com> wrote:
>
>
>
> On 06/10/25 11:37 AM, Dev Jain wrote:
> >
> > On 06/10/25 11:22 am, Anshuman Khandual wrote:
> >> Replace READ_ONCE() with a standard page table accessor i.e pudp_get()=
 that
> >> anyways defaults into READ_ONCE() in cases where platform does not ove=
rride

Nice cleanup!

> >>
> >> Cc: Andrew Morton <akpm@linux-foundation.org>
> >> Cc: David Hildenbrand <david@redhat.com>
> >> Cc: linux-mm@kvack.org
> >> Cc: linux-kernel@vger.kernel.org
> >> Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
> >> ---
> >>   mm/mapping_dirty_helpers.c | 2 +-
> >>   1 file changed, 1 insertion(+), 1 deletion(-)
> >>
> >> diff --git a/mm/mapping_dirty_helpers.c b/mm/mapping_dirty_helpers.c
> >> index c193de6cb23a..737c407f4081 100644
> >> --- a/mm/mapping_dirty_helpers.c
> >> +++ b/mm/mapping_dirty_helpers.c
> >> @@ -149,7 +149,7 @@ static int wp_clean_pud_entry(pud_t *pud, unsigned=
 long addr, unsigned long end,
> >>                     struct mm_walk *walk)
> >>   {
> >>   #ifdef CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD
> >> -    pud_t pudval =3D READ_ONCE(*pud);
> >> +    pud_t pudval =3D pudp_get(pud);
> >>         /* Do not split a huge pud */
> >>       if (pud_trans_huge(pudval)) {
> >
> > Talking about mm, why not also make changes for these READ_ONCE accesse=
s
> > in gup, hmm, memory, mprotect, sparse-vmemmap?

Yep, I agree with Dev on that one. Because the change is assumed to be a
no-op on all architectures for now, right?

> >
>
> Right, could replace all mm/ READ_ONCE() for pxdp pointers with the pgtab=
le helpers
> but that will create too much code churn in a single patch. Thought of do=
ing these
> replacements per file will be much more contained which is easy both for =
review and
> testing.

Emm... as pointed out by Dev, it would get the entire cleanup done in one
go, avoiding the churn of multiple small patches ;)

Cheers,
Lance

