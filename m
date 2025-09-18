Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 57FF1CAC59A
	for <linux-mm@archiver.kernel.org>; Thu, 18 Sep 2025 07:03:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 873B78E00C2; Thu, 18 Sep 2025 03:03:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 84B918E0093; Thu, 18 Sep 2025 03:03:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 788608E00C2; Thu, 18 Sep 2025 03:03:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6869B8E0093
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 03:03:38 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 0A8C359F17
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 07:03:38 +0000 (UTC)
X-FDA: 83901480516.05.2E4C325
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id E84E1A000D
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 07:03:35 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="p/jPoKA6";
	spf=pass (imf15.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758179016;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=w+ErpBRL1l1AWMxlK8Kv80OYxkNODRdorjcQzFTx4Vw=;
	b=lRFVu5Ipmdm0syXHD6OLJMb7eLNuqT0ibkkYn0pv3na4E0LqKOB8wmHR7bW1J3wPT4rReN
	k2cqNHcT90xmuyKZ9MRUc/cUe8l5GCxk/Hi8pAWscX8vlxhtYkPDlGF86mlpkrvMz06y/E
	fU66WJ+G19huTtkPNtsO+o0YnprdAvA=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="p/jPoKA6";
	spf=pass (imf15.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758179016; a=rsa-sha256;
	cv=none;
	b=eu/RzmhGHvzLyhfp7DfKn2v9K/Peqgq3PoPOegpDRmr/GsEPpbd1o661NC6XwO9/YoOkj2
	qC9EgMI6w+6ATEVOCdzIiiZyn/sagGZ/K0BGPuKc4xQhEhNeurTEirXPhEU6EgKOoZUauS
	RrA7IbC5kJ3YS/ujUTYAU+Igsff73Ow=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 75593448A4
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 07:03:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5608BC4CEFB
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 07:03:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758179014;
	bh=w+ErpBRL1l1AWMxlK8Kv80OYxkNODRdorjcQzFTx4Vw=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=p/jPoKA6AhiIzCBP61Nuqy1q6G1Fl792+ptGL7xQCo7KrkYrD5FfEW/MQOWUz6cMD
	 H4Yil1LNC3vThRtVziWcCCxN3OzaQuoL9Z32NE3S907ZmcOqRz0EotVjsr/T84qkN3
	 WqH0sgW4yjmYKbageMFD3Am5BITisMQrCQw5xlTsAE9XQ/eEv1CR8N2CH/oU6w5TAu
	 g7VKmnwg0Lhjv+Rjfxl/wKybdHc+0dgKRZczTtYRZIlvRgZK6bKUZLSqoQ0XKyvmSM
	 KMIrkxEdiP6XV7M5e8WiZWVrg38ADigKta8ypu4iVxAiY9CQj5DJgEwEfoFDZ6scS+
	 NJ1RK7r8TA/3g==
Received: by mail-lf1-f54.google.com with SMTP id 2adb3069b0e04-5679dbcf9d8so628590e87.0
        for <linux-mm@kvack.org>; Thu, 18 Sep 2025 00:03:34 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCXQLe5QmZLYYL6t239x99REJzT/qauheIXQoDHu5HzHrS6TKu0M8/cBZZsVzDK7oRq8sESceQ/Lhw==@kvack.org
X-Gm-Message-State: AOJu0YyEQQx0Wuc5fxbywXEMkFmHh+5YNtaQoTdXO4XQ2O7h3FwptSzL
	ieuvgDTHNkMKLl4MVRM4/8DjkgCcjMwIVzq/svtZP3gqtoeyXazg5qBjsdhqH3oMk5MXKQGWu47
	u25xGp1W5xN3gCscTsvrDftMJSGsL6A==
X-Google-Smtp-Source: AGHT+IGJs/PcXCDxOEGAiTcDcrXuGdiFMqjgrLIi1+1jjccVhq9MjHPWG23k6+kfQ5dKqi7auT6HU1FGc+Nq4YAKaiY=
X-Received: by 2002:a05:6512:3b2b:b0:55f:3faa:7c2b with SMTP id
 2adb3069b0e04-5779bdc6d10mr1368887e87.39.1758179012976; Thu, 18 Sep 2025
 00:03:32 -0700 (PDT)
MIME-Version: 1.0
References: <20250916160100.31545-1-ryncsn@gmail.com> <20250916160100.31545-2-ryncsn@gmail.com>
 <CAGsJ_4w2GqGj8HZMfwndsWu7qkORqsnaw9WwhmQS=pW4gR7nEA@mail.gmail.com>
 <CAF8kJuNbUyDWcJ13ZLi-xsiYcbY30w7=cFs7wdxszkc7TC4K2Q@mail.gmail.com>
 <CAGsJ_4wKWem-STYAnh_0EgSFKzzs1M1c7wz6K82wLt6T6JEw9A@mail.gmail.com>
 <CACePvbU8cUs-wwPsXkZ24EWga5bXxxUGSCT18rKAWFYn5w9rpw@mail.gmail.com>
 <CAGsJ_4yhDU_WVfEybDhGE-WF5+w-fak1-F8jqbAQ-Qw1+qWkaw@mail.gmail.com>
 <CACePvbUabb+L6Z9Nb-41fLR-FMhj--cDWSbnXtCj3rpqXModiQ@mail.gmail.com>
 <CAGsJ_4y8yTX48ESHKgLNCvM1M1_gY9uGnD4qiz8n+gD47Zd1Hg@mail.gmail.com> <CANeU7QkZBWFO6SeVHtmm73oLu7r0zavePQEYmQfH8opKPH1QWw@mail.gmail.com>
In-Reply-To: <CANeU7QkZBWFO6SeVHtmm73oLu7r0zavePQEYmQfH8opKPH1QWw@mail.gmail.com>
From: Chris Li <chrisl@kernel.org>
Date: Thu, 18 Sep 2025 00:03:20 -0700
X-Gmail-Original-Message-ID: <CANeU7QmcC=-CTmJ7i8R77SQ_WArBvjP3VrmpLOy-b7QhCfMRYA@mail.gmail.com>
X-Gm-Features: AS18NWC9pu8B5pH4dlv8MuU8SxVN9kdKP9S1B5I9Sg97ymUY5ImXVEPfBbPThSs
Message-ID: <CANeU7QmcC=-CTmJ7i8R77SQ_WArBvjP3VrmpLOy-b7QhCfMRYA@mail.gmail.com>
Subject: Re: [PATCH v4 01/15] docs/mm: add document for swap table
To: Barry Song <21cnbao@gmail.com>
Cc: Kairui Song <ryncsn@gmail.com>, linux-mm@kvack.org, 
	Andrew Morton <akpm@linux-foundation.org>, Matthew Wilcox <willy@infradead.org>, 
	Hugh Dickins <hughd@google.com>, Baoquan He <bhe@redhat.com>, Nhat Pham <nphamcs@gmail.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	David Hildenbrand <david@redhat.com>, Yosry Ahmed <yosryahmed@google.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>, 
	linux-kernel@vger.kernel.org, Kairui Song <kasong@tencent.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: E84E1A000D
X-Stat-Signature: wgfq8nuqdgsothrk3gi9be7wo3i96yt1
X-HE-Tag: 1758179015-851091
X-HE-Meta: U2FsdGVkX18+zEX6X0kVBoTT0uZM8bgr908wqqukyinVnt2rdbLhMF3SUkW7k5wElVoDKnnvSNYeTZ0fX5WQ6lu7JPBG9pEk9aJgeZizpV7ftuMBAIbvt5l+jrrQfc0oQSXS5HyxkazrMKuMuRaxGwv9tvDorO1JvSFn92h4cyH7lTWbpuOC9T34Jrb1vqINVzNNPSuCa2sQXgJe6GSjyz6dUL6kUD6kvtXeXTQqRqxhxn6e5FJZ5KPe7FMPuvp1bzYHg/anbX7TCgM1lszUPo1+0bewBGN5ycHRlrzq/O7lKJgAZycAgG7lBlcMFoQtwB//nmzGr/9uWGW1Y9XuwsZPRlKvv7mRaJ6Z/wnNQb1U+UyvOhRBytQlRQ6Sp6hvY1TJCUA8uLIRVhwCPNa8D2qQUYnb222/AEgM3h+jx6AOZPhiD3ixkhsIwLaUQVG0UqVmUNeWNn+tiQJOInuGJ/VwxfOSwRoKM1yv3WwS8NrPcYvocja3ECBoTGo4gdS+/QjvypJSitzEu35pnAvLt9RF1q8Gsb/k9hhxegs8PtwYLhZWuKXL6U7/wiKcJYuBUQlUVUcCrDkB6NZwoKWtLjSB4lz7078ipvJu0lIIg0Yw1zOggC8yxtU/sMCdv++e9+H8hvNNAWNDUqbRkzHqjmaL+RB7IoA1kXXeEr7bXQq/jraVMRADIC5ZSmiNxi3NrjL7/vwtLMikq3dOrTyemjTax6ftg6uoR6MQQQY2QhMGWwiOL5f+ETJHVIRcisJY92r0f4j0mpOocCI+Y0HbuLnOTTihVDGyv4ZC/IR+/J14iPoA4pZweN3w6oGah/APtz7vu07BYdUCjqJ2eWvgLfVC/rO/DxgXvlP9fEKKO7n+Fk3hf/wPFRnhSXoe8HJaTTTWMIOEFIIOrIgAdeX1iBaNtNoYs9exzoHHMxM4yspXc41a+E1sE7IlxoqYkfO1JveMOPtrEabd+pX1PkE
 7Asar6YB
 2c+l2zKoe4g17o2m8EcuIlEJt0+lqpQ0LEH4/AXOzQh4mqh0bTUDrL/ZkuBRJVDLlWoczrPzR9TjIfTkSyA6iWZ2MXhu/6n+1N9+Kmh2EHmhfyq9IZlKPydypthfUXGiUFqvR8XmkiwixybBde9Q2rk2Zo+wMy8uLBlOns0GRDXidv3zVE/ALRqDOzymV86kQiX0DZEDfaIABj6bU+GfX2aKFwEtzNifmDnuXc0cpzbqYk9qeQMtlIiu70nOLQSO0dE3uMTVmoAWQMBSDb/HZKtv3n4bRog5DIDAWZaaDNXvCI8HA9SY+8LxMSj+DrUBe8Zr/g3H4pqMJXlFJRcaa5R1IlEdJnz2I/DsDu+JIWx8VfrE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Barry,

How about this:

A swap table stores one cluster worth of swap cache values, which is
exactly one page table page on most morden 64 bit systems. This is not
coincidental because the cluster size is determined by the huge page size.
The swap table is holding an array of pointers, which have the same
size as the PTE. The size of the swap table should match the page table
page.

If that sounds OK, I will send an incremental patch to Andrew.

Chris

On Wed, Sep 17, 2025 at 10:03=E2=80=AFPM Chris Li <chrisl@kernel.org> wrote=
:
>
> On Wed, Sep 17, 2025 at 4:38=E2=80=AFPM Barry Song <21cnbao@gmail.com> wr=
ote:
> >
> > > > This approach still seems to work, so the 32-bit system appears to =
be
> > > > the only exception. However, I=E2=80=99m not entirely sure that you=
r description
> > > > of =E2=80=9Cthe second last level=E2=80=9D is correct. I believe it=
 refers to the PTE,
> > > > which corresponds to the last level, not the second-to-last.
> > > > In other words, how do you define the second-to-last level page tab=
le?
> > >
> > > The second-to-last level page table page holds the PMD. The last leve=
l
> > > page table holds PTE.
> > > Cluster size is HPAGE_PMD_NR =3D 1<<HPAGE_PMD_ORDER
> > > I was thinking of a PMD entry but the actual page table page it point=
s
> > > to is the last level.
> > > That is a good catch. Let me see how to fix it.
> > >
> > > What I am trying to say is that, swap table size should match to the
> > > PTE page table page size which determines the cluster size. An
> > > alternative to understanding the swap table is that swap table is a
> > > shadow PTE page table containing the shadow PTE matching to the page
> > > that gets swapped out to the swapfile. It is arranged in the swapfile
> > > swap offset order. The intuition is simple once you find the right
> > > angle to view it. However it might be a mouthful to explain.
> > >
> > > I am fine with removing it, on the other hand it removes the only bit
> > > of secret sauce which I try to give the reader a glimpse of my
> > > intuition of the swap table.
> >
> > Perhaps you could describe the swap table as similar to a PTE page tabl=
e
> > representing the swap cache mapping.
>
> Hard to qualify what is "similar", in what way it is similar.
> Different readers will have different interpretations of what similar
> means to them.
>
> > That is correct for most 32-bit and 64-bit systems,
> > but not for every machine.
>
> I think I will leave it as for most 64 bit systems, the swap table
> size is exactly one page table page size and that is not coincidental.
>
> > The only exception is a 32-bit system with a 64-bit physical address
> > (Large Physical Address Extension, LPAE), which uses a 4 KB PTE table
> > but a 2 KB swap table because the pointer is 32 bit while each page
> > table entry is 64 bit.
>
> I feel that is a very corner case. I will leave it out of the
> document. I want to present a simplified abstracted view. There is
> always more detail to distract the simple abstracted view. That is why
> we have physics.
>
> > Maybe we can simply say that the number of entries in the swap table
> > is the same as in a PTE page table?
>
> Yes, that is what I want to say, for most modern 64 bit systems.
>
> Chris

