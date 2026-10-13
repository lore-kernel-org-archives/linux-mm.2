Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3D4F5CC6B12
	for <linux-mm@archiver.kernel.org>; Tue, 13 Oct 2026 15:37:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4801B6B0096; Tue, 13 Oct 2026 11:37:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 40A1B6B0098; Tue, 13 Oct 2026 11:37:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2F9076B00A7; Tue, 13 Oct 2026 11:37:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E3BFD6B0096
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 11:37:11 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 80A161C47D0
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 15:37:11 +0000 (UTC)
X-FDA: 85318006662.12.F88597A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id 85581120008
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 15:37:09 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=e2vfh155;
	spf=pass (imf29.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791905829;
	b=EtBG2eVFprBaa2uYMF47L0bklcZxnpG/is5epvq6wmWzR8Oks3S5eNVMfb78H0Fzt2cfkT
	wZo7Sqgbv4tWrBo/5L36zoXO5YvROBSbuCQWTcVSy2mlO6GocyI6SqBsvvFSQcs255NRWk
	lwkfeJZJppPASZGFVTQ1JkI++pl6IYI=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=e2vfh155;
	spf=pass (imf29.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791905829;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QYvG7iTN6X/wcWZUdqZr19eVWyZZhBJ5WBory4f4au8=;
	b=Q+M7UsI4foz/2BOu9cVjvCPo8dQlS2suJAzC9JYepJWBDTZ2prs71tA/oBROivm4oq5NoO
	1iNIHlvGpkccuHotdkrHjI8hpXCnXsLs5nLStq+lRo8euQQRYWHk6Y+JQ/nU2qPme1Skr3
	4HVgvqu7lwZpfLV4bYS2XSO0t0VEruk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id BE498412BE
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 15:37:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1A3D1F00893
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 15:37:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791905828;
	bh=QYvG7iTN6X/wcWZUdqZr19eVWyZZhBJ5WBory4f4au8=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=e2vfh155/VPsHaWZgcZhQogA6+0Ijpf92000/ox/Lbw56lN7A4SVNn/789Geb12Ur
	 H0facF2OKtc5Q0ncRS0hdjV15KANCuPbQCLcBI5Wq/pH2lhvbflXcVZIhZMxjXJK37
	 MDEI3V67nDeThfG2sFh6v1S7JZidQuEREhoCFMBozusmOCEpUMtcR6TJpDIr0Rt7ac
	 Cr/Tqe0gdCAt6L0zWiFVA/DkfRb6caekRbfSHEAfAPa/fzBw9fXm0a6q56s+CHuQWN
	 34JBaBP3KAuObrD02sgyzg7XpBXkshrvd2FZ5gLxGOsqsctzDPDbheUlJFQz9sqeIs
	 ZzY8EBvv21nlg==
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-c2a4e013a44so5611366b.2
        for <linux-mm@kvack.org>; Tue, 13 Oct 2026 08:37:08 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBz/ySTW+/rPWsn7L8JfHf6kpttQvzNtbKunKc5wILb/T3GUFF8hPjXP3BW7ZjxeAGcCkZB1QF36fw==@kvack.org
X-Gm-Message-State: AFq9FYIPPY+mNM3pt51NlioB/BPDe3i9xFmCAPKh7oXqJCWXOuNzGJKM
	cXcMtqMrbrpVxpaqBFjIVrNanEroTnkX8xBeKeJBhYYvfX60eTgD3JEV3pY18RLMzi8I4QJvHO4
	idk3Eob6WDnSyZHDk/2VYONgdRg0MDoc=
X-Received: by 2002:a17:907:7246:b0:c26:19de:9adb with SMTP id
 a640c23a62f3a-c31a9d56575mr1180906166b.26.1791905827546; Tue, 13 Oct 2026
 08:37:07 -0700 (PDT)
MIME-Version: 1.0
References: <CAO9r8zMxdg2BTFguwcRQn8n-2CPaEJJfg+T8dWcgO2eV4uNaHQ@mail.gmail.com>
 <20261013152553.39287-2-itazur@amazon.com>
In-Reply-To: <20261013152553.39287-2-itazur@amazon.com>
From: Yosry Ahmed <yosry@kernel.org>
Date: Tue, 13 Oct 2026 08:36:54 -0700
X-Gmail-Original-Message-ID: <CAO9r8zPOkuRGv0X=nBbAzTUjUyaB7zAJLUigetSXEVPxWpyGxw@mail.gmail.com>
X-Gm-Features: AclHuK-W6f4ZhQh9ueCOMp1_eyaIikFGHa4dIFgdih2WgfTC8_TU_5ph5Rmf9m0
Message-ID: <CAO9r8zPOkuRGv0X=nBbAzTUjUyaB7zAJLUigetSXEVPxWpyGxw@mail.gmail.com>
Subject: Re: [PATCH v3 03/26] mm: introduce AS_NO_DIRECT_MAP
To: Takahiro Itazuri <itazur@amazon.com>
Cc: Sean Christopherson <seanjc@google.com>, Brendan Jackman <brendan.jackman@linux.dev>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, 
	Peter Zijlstra <peterz@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Wei Xu <weixugc@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
	Lorenzo Stoakes <ljs@kernel.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	x86@kernel.org, Sumit Garg <sumit.garg@oss.qualcomm.com>, Will Deacon <will@kernel.org>, 
	rientjes@google.com, Roy Patrick <patrick.roy@linux.dev>, 
	Andy Lutomirski <luto@kernel.org>, David Kaplan <david.kaplan@amd.com>, 
	Thomas Gleixner <tglx@kernel.org>, Patrick Bellasi <derkling@google.com>, 
	Reiji Watanabe <reijiw@google.com>, Nikita Kalyazin <nikita.kalyazin@linux.dev>, 
	Ackerley Tng <ackerleytng@google.com>, Takahiro Itazuri <zulinx86@gmail.com>, cc-open-source@amazon.com, 
	Kevin Brodsky <kevin.brodsky@arm.com>, Gregory Price <gourry@gourry.net>, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 85581120008
X-Rspam-User: 
X-Stat-Signature: xix38idxksqgci33rtr68trfu8p8w65t
X-HE-Tag: 1791905829-742433
X-HE-Meta: U2FsdGVkX1+vKBQZMLuoF5hieHoY4xQhziaiouYY1eFZW/Jt+AHiADRFK2+qUN528+SNgjV/eLTWj+ag1KSSOsscN8ujeh/fu8cH9pnRNL1Uuvf+ohnznWbHjHLY3TfWwBiIJ0dkpt1hk0gByjGnCVwcpiCnjiujkJajsvp3BrM6s4hfzqL6U4uFgW8HhLpr23nLs0U7PX5ERDWMrWwsL8wyU9Fs9cSL0z6NG32kAe8jCji0CUSkYaD0M8DJOplzFf791DcajwGDCQIjLX8BnbnGbM8jUibL6aRtzuzqY6CvLuhotdwv79k8+6TmWsAUPe5Tw48Klr5Ue1Qa9cxMtiGSx8jBXhaqAd+y4yrg8z6g9XipAp0yF4S8Wm8UcS5IBID+B89HGWB8uZ6dnXKp8TFglmSPjWLTHUJq/gwJjSmr3igE/nOjZOhgXi79Rt5pgd96Sc2B+OAroXE6MXbWQeTsqmxR0PiJNQroHH7a6W/t9gsqxZVfsQ6RwQxumaGJRM7I0i2PSjO+qY6FDKSvW17OmaGXFTk0pRcPxIUAwGurpFW6cFqP+H/YpTGhQM47WAub0RpJN/Rj6Gbh7uQlj434rAndXp3GX5Ov46MLsQex4lDUYbaHRRIflIqF6Bbgjyl8IEYRrHett1fZPofQ6+1et79mQ9NwSOTj3kZ7oyi0ihLPzvf2gUGNxkaMBFCOSDopAXd6RDTlAiTve415zO9wqEtLI/XYXUxLIDK2jLEn/wXuYZ3wNCMu6DXXKmq0n0MRyiKrdFkO3WYskDS7AJnAYoUmvpo3FJ51RmD/+BqKmBnkvjwXbSl2HGNTJtHOqas0C6lh/wflSqq052NW9cDGDWffOuBPol9PiQrUz7SN4Wd09ateDLnKJVaRBGAISXlkaRCNI4XDD+8A2cN3qulPgNiOaCPV7o98VLyHktJImioWe4WBkVyFmm947IoauVzsv7KuQM+HfLdRtYZ
 MgQ25ysq
 wYgbm5/sz3i0dTtZjqIlPHf/stD8szAuC+RODWHvWDG1jTqAD+UwgOOx+eWy4VsaRyoEUciNoVUaAcYKZFRIfIiGaDpxpNUMOrN2XKdrf7IPoDL4paAkEgW0/l88U6zuRYrTl0NNR0qffZDFL3EIUgM+c1ZHAlT6R/6KdnSbFWLa358+Z2t4FhbrSFvESEfxk+q2TUV8j2WjTKu16UqYsZdz2SwSDiA/hsZmWy+a+h2c0+p7W2ZZAxSfTM7Qgv4atfNNqdZQb/NokmsQDR7xipcy6tsUgVVvDcG1zJu8fjxCPOlOh2DDjqmQIuN14qd+BFHmdxBUns+M7zyo8i4z6yDyvs7NOtUcOR7lllSVCI1mHWrwTr/ViER0FQXTCJ280R6/h
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Oct 13, 2026 at 8:26=E2=80=AFAM Takahiro Itazuri <itazur@amazon.com=
> wrote:
>
> On Thu, 3 Sep 2026 07:06:02 -0700, Yosry Ahmed <yosry@kernel.org> wrote:
> > > If that work is not already underway,
> > > I would like to respin the AS_NO_DIRECT_MAP introduction and secretme=
m
> > > adoption as a standalone MM series, separate from ALLOC_UNMAPPED and
> > > mermap.
> [...]
> > Perhaps wait until I send the new version, then we can discuss if we
> > want to split it based on how the feedback looks like. Does this work
> > for you?
>
> Following up on this with an update. Yosry let me know off-list that
> ALLOC_UNMAPPED is on hold for now (quoted with permission):
>
> > I wanted to give you an update. I was working on v4 of the
> > ALLOC_UNMAPPED series while our team was simultaneously working on
> > integrating that design without internal ASI implementation.
> > Unfortunately, there were multiple complications with that
> > integration, and we will be holding off on sending new versions of the
> > ALLOC_UNMAPPED series until we have higher confidence that this
> > approach will meet ASI's requirements (ideally in a production
> > experiment).
>
> Since the integration with Google's internal ASI implementation needs
> more time, Yosry also agreed that I pick up the AS_NO_DIRECT_MAP work
> for guest_memfd, separate from ALLOC_UNMAPPED. Here is how I plan to
> proceed. Feedback is very welcome, especially from Sean on section 2
> below.

Thanks for the update, Takahrio!

> 3. ALLOC_UNMAPPED and the mermap
>
> AS_NO_DIRECT_MAP itself works without them, by zapping the direct map
> of each folio. However, guest_memfd will eventually need a temporary
> kernel mapping to populate guest memory via write() [2], because
> folios are already unmapped once they are added to the page cache.
> The cost of TLB flushes and direct map fragmentation also matters for
> performance, so I'd like to keep discussing these with folks
> upstream, building on the direct map fragmentation discussion that
> Kevin led at LPC [3].

FWIW, I think the mermap can still be used without ALLOC_UNMAPPED, and
I did have a newer version of the x86 patches repurposing the LDT area
for the mermap, and simplifying the mermap implementation a bit. I can
share them privately if you want to take a look.

