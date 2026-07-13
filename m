Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CB79FC43458
	for <linux-mm@archiver.kernel.org>; Mon, 13 Jul 2026 04:09:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6BF116B0005; Mon, 13 Jul 2026 00:09:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 670976B0088; Mon, 13 Jul 2026 00:09:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 538756B008A; Mon, 13 Jul 2026 00:09:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 23C646B0005
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 00:09:51 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 9F3671C40E5
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 04:09:50 +0000 (UTC)
X-FDA: 84982424940.26.2E98B2A
Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	by imf29.hostedemail.com (Postfix) with ESMTP id AF19D120005
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 04:09:48 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=LVADMwIl;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf29.hostedemail.com: domain of jthoughton@google.com designates 209.85.218.44 as permitted sender) smtp.mailfrom=jthoughton@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783915788;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SwRmwa12BAzmniM/qfe3fdrZEb8WNeId/0JrKyEwP6k=;
	b=Xzt9KFTom2P7aFRqF28BDjIG9+lLlwK8peONT3LwRhEJKXy6k7qC3htKGOWpxl8K3Ot1aE
	grws2oEKXN2gIhRURcBTUZmXY7Ifo3tyfbvrOWQQH4G82MK/DfmRmbOVF0Zet+JJPEMZ1C
	UZQSlCvAqqvZl+fWmQg7pZPsnsqjuKw=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=LVADMwIl;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf29.hostedemail.com: domain of jthoughton@google.com designates 209.85.218.44 as permitted sender) smtp.mailfrom=jthoughton@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1783915788;
	b=n9PEPNcMDhMxuJOD3alSDr2/x5Fo10IBGPLIzDXvdrcim4R2QyEMD4GBIYCQVirKOd5xgW
	maeb5+O2/Ei27B8sF44bQCc9RDrGKCWBfnQ1Z139/KysDSBa31YPBprnkymc1Th57MX/Py
	rRoQVOh4a/H7CfLJBPVkia74l1TfG3o=
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-c15f360851aso374883366b.2
        for <linux-mm@kvack.org>; Sun, 12 Jul 2026 21:09:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1783915787; cv=none;
        d=google.com; s=arc-20260327;
        b=kZHNu86KAJx/DBUhx4PtZBeFOU7Qtmg8xAPRBU5Q9igNuHh7FL5Axk4bkPfMc/EaiY
         FPx7lOzNiZGuEv+0cbQIp41EvRen816t2r+J/CV1uKabBx6/os1PWu+/hXLAioCtPO3q
         RMRLJP0CotSSuqNefuVasN/L741uKbZeUeyqL/M+8tnf9CcLERvEka/W+/h/AVf6cIo4
         MNSGLjkNKV5oItWOEDbMpAfg9U0rKJgN4C+GkwgnaMsF2R+TZAHXXhCd0AakUEyXtTK9
         C3aa9V0Kch9VvJq/fZ6U755s8oJJE8sAk9KX1I7im51lNhpRmlK6McChIqps0gLVEBHk
         icrg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=SwRmwa12BAzmniM/qfe3fdrZEb8WNeId/0JrKyEwP6k=;
        fh=d64vLnVizlwL0AVNqHtZKNdCiaxfXF0X9jn1ePPsq1w=;
        b=f1ssxVClSVJz5gcsXlgYPWZ68DYqSxWukap/slvZnAh1wPDw8Jvm2cAZV7nzXpgIht
         bH6+4vl/wAcQDfJO3PXFxWWYZyjo/v8/74SXrEoWUfpjgoaPtUfJF/5zmScqR9R/dos7
         0KjYLJ+HERyx7D5yCkiEVx3ejUiEFbOYBZJcXpsCsQcDZOw6VhYVp4LHDKtfRWLwpfsx
         /1KBoFZpfUr3FA8BSQJemYlvug/LIR5nRmyie8KQJbAvSK4NcvyAdCR8a7kAies9gSBk
         tGbC/HVO0CesB2976VdrUJO515AxBGo7AjX1RcfzxwDWCkdIEiIU6uzQjIpIX/IA6KQC
         LyfA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1783915787; x=1784520587; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=SwRmwa12BAzmniM/qfe3fdrZEb8WNeId/0JrKyEwP6k=;
        b=LVADMwIl0W2tZa5pGg4vM4fHLCh8MmG0uXDPZehSX1vrCAvw+HxrVAujLlCSEoliUL
         KcAQ9RuARNYKn3u5IHFTr/RNQJpIWbGRDLtLlns2BaZiptjaPDiFNzfd+r2iBp359pna
         oRaifMVaqM71haANyqHqeBnFgxW0qL3XG0GsxEdURdn8LVxQtlVrKz9zsi7qhoxDvCq/
         DAK3JgGvb4mF7mcz6+WFAGIcWIpf1ZX8zWTtABcW7jkNb3TXuBhh9KG1dHE0XhaMgtDd
         Q9wqpleBShjVlrmuMrEFtPiEt3ySF0WJoSKn5DfcLs8Drks5GSJ/JYH3v4u+gkx2j0e7
         Isqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783915787; x=1784520587;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=SwRmwa12BAzmniM/qfe3fdrZEb8WNeId/0JrKyEwP6k=;
        b=PVN5k/sXZ+2Ybs8py/jKBBB4w2uAq3JVA4P/EqfvjoviGXoa1i05JlE/asqxFvjk72
         2x3MO4tOGwzQzol3ZPpjAoEsZKyjEHGnAACPeLaAJaIQykUP2wwBX37GSIEPA5t9iP53
         W+X1wlC2yRtPzmKfi2xwYUO2IOopda/hAMOx7tusyjBjZz0pTRznPS4tOP6WMnMRdD5J
         Gp9TfSsD94bNseHDWchwUyMEIYQPpqXIdIEZ8MTw01Qr8dBqapeK0odBwyNrVb8Ljkwg
         /yhytUWyH/vDr5K/movBxrZDblyBlPMDddWY/6UQXqfmWURAf19f+tXVhR2Q0Noy8ECF
         VOiw==
X-Forwarded-Encrypted: i=1; AHgh+RobBMfhTyQGmZSYAQHjLaiSLktmcbeD0noD4JftSyDMl+2g16xfzAoqzvtwkZ3+W/PIkMJiaoqpxw==@kvack.org
X-Gm-Message-State: AOJu0Yx67j6A2jmyG3vlunMxVQq5YJ1I9EwY3lUXhIKsGcgOQCAPIq/l
	1zc79/78a/0/+rXls0s80w65sy5d0hZmrMFB/zthJkGxRquogLBSEHArRFjzritq+CXU4AqaC6u
	Yhw9hFEzaWx4xxqPcSG3u3ZrvJgKZaL6w7tWPemNX
X-Gm-Gg: AfdE7cnmAvBacZf0NrjF0cVCT6Eq9WkEIt5UEHOybf8quJ3FJR0PrZaOM7ujlX+iMYL
	CVgIiVw2L18jUHKjsU8RdIGTeNRYrXw/dwnmPuHs5LtsumWf/cuQWnXYJk78oOEjrER4Cz+TttV
	fdzWmI3A4aypdnuDOUrlooU6mRLTwUY7ao8NC9mM9bNefHFPLb9LyG44iP/3xbMOnfULtb7UFlo
	vXAhfRoR6yE3SK/gnunM+GOFfTkQdeQAAqlQI3QgVWFTvPGtcJ904SeZNi0IqWhTiLHUt9t+Coi
	RSSKrVnfRz1408Gg8HckCaCDEgM=
X-Received: by 2002:a17:907:a01:b0:c12:e4c6:c4d4 with SMTP id
 a640c23a62f3a-c161f4713bemr317449966b.63.1783915786759; Sun, 12 Jul 2026
 21:09:46 -0700 (PDT)
MIME-Version: 1.0
References: <20260708031129.3503195-1-jthoughton@google.com>
 <FC9E78F0-8FF7-44AF-A848-8401B4702488@linux.dev> <CADrL8HVkrojXbBuEX-W=UHBmyyFzqxdGBvtAoPP53SyYa10uag@mail.gmail.com>
 <ABB70C2A-316E-4C19-A855-C9920BE105E1@linux.dev> <CADrL8HUCqrzOQGXRDwnitintQHjHCw10n8wo6gChQ2tWvC2JBQ@mail.gmail.com>
 <F2693104-180B-44CF-9F3D-CBDE26151EA3@linux.dev>
In-Reply-To: <F2693104-180B-44CF-9F3D-CBDE26151EA3@linux.dev>
From: James Houghton <jthoughton@google.com>
Date: Sun, 12 Jul 2026 21:09:09 -0700
X-Gm-Features: AVVi8Cfs1p19kyiJ6G4WadWRtHDTpqre4c38UKODVk6g8mKbqnO6JMtYH9gjlzo
Message-ID: <CADrL8HXZiHcwYR8Hcoje4c9HZBNSCmQcG-3y2f6AhJksYQRvhg@mail.gmail.com>
Subject: Re: [PATCH 00/18] Another attempt at HVO support on arm64
To: Muchun Song <muchun.song@linux.dev>
Cc: Will Deacon <will@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	Oscar Salvador <osalvador@suse.de>, Nikos Nikoleris <nikos.nikoleris@arm.com>, 
	Linu Cherian <linu.cherian@arm.com>, Mark Rutland <mark.rutland@arm.com>, 
	David Hildenbrand <david@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Ryan Roberts <ryan.roberts@arm.com>, Nanyong Sun <sunnanyong@huawei.com>, 
	Yu Zhao <yuzhao@google.com>, Frank van der Linden <fvdl@google.com>, 
	David Rientjes <rientjes@google.com>, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 9uhsi4bspzqo6uxdzzo7jikphspwhint
X-Rspamd-Queue-Id: AF19D120005
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1783915788-383867
X-HE-Meta: U2FsdGVkX19nOXSy5478grjklUL2CGgl0wr5rSdwAJkHjGz6qinNuEneg3n513yp+gboht0JAbmafv7wtdNKsqTFNzUwYH14mTKUDjWSY3pBn1edkfSobdWwkBxQfxiptdlb0Ajc+hkFAQTc9J9Lzn95zKjxB9k5Xnu7YpOoaxOTFHTnYS1IUK8sHNVW0oBW3OsOwBpn2FwGZgNIC5IYNHJw8/KQ69ap6ISQvJEt5Th1JLw7xfrlGF+3nYX2s9ZJOl468n3yVLCS2zz/KG4akGfMdai5pvXdhDkR3QpkkgTm94CpNIO1aSbOgSYZeMBA5utZBdQC1yWEY3zWrDdtPw6WTB4vqeCcEuDJKCF1dp9ijylvoXVUAET2MFfzj43p+4HbJKQLlu5giuCDPqLp9K1LHZdiLRtyoapVyKo8nKx1JexzmU7m0w/IOR4nW+EGNE2Oe3mpbdVh28DYwdh6cITN0WaqwgnRbbnvY9lWdrVAxl5acp7IRDbTPIhVD8MaIQ8kE/trXT/YQcvqk+autJXll7xEvLbGUXkurSAjnxP5fYIWZsHMVHGFwRKZvdDf4v7O2cmPL3IrbThONlT4A3lz+6V5+yOppU4sTtGAgAzbXIqk7KTgXk0vOSp+/Y7HzYa+ptguQ6fDpvsUYcf/N35NIPf4yHJhaGb2+F9KsPGFsKCWa4tBNbt+KFQe0uvXLi/VQdZluP0frwoJOVrw+kg1y4i0/XlxTvv33CIMw3wrbwPQgAqSpTf/0WC0OBn0Tm77pGyhgi94Pa0OIT0IKukaEQJxgq8H99lZenpJkLtZ+RcIZGvlhO2zuiGTkt7cPTN9aax99cB4x9d9530zcHsEQh4ffcN50juR850zEDke44RZfwSX+rdxeu8PlruZCL6jd7QpxOr6Ghz51SiIJsvrqs1GzL2BL+MmadVC7j6xoOfMkC1YqR/aOJ896Rf5c59I5i6kAXKaHHANr0i
 GzxPQWqC
 fc6zJQxFBXaK8fx08mCTF+ph1k9z+RBtiUU2JnC1d5ijuEhW6mrjlnhQjhgVhdMfN/43d50fmnFwGsjEiGLzrjTxtqLou4eoFejzsYGEYnxe9RskUIIO2Q6bHYoj+V5k0g75bNhYr4DYFLX3pPNvWUoR4U7xP2/ZJCgzxpwe5qt2G+RxBDlN8J/jZO2tIqpyYqiaylKS5o6nvv84NlJa4MPBrhjIv1GAmjwRsQvIomegqwkYo7gzUFpDSQMPdP7ckIN6XpBXf0CHLxtrQ35tayDHLpdvmlByydYlY
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 9, 2026 at 8:41=E2=80=AFPM Muchun Song <muchun.song@linux.dev> =
wrote:
>
> > On Jul 10, 2026, at 03:04, James Houghton <jthoughton@google.com> wrote=
:
> >
> > On Thu, Jul 9, 2026 at 2:55=E2=80=AFAM Muchun Song <muchun.song@linux.d=
ev> wrote:
> >>> On Jul 9, 2026, at 00:49, James Houghton <jthoughton@google.com> wrot=
e:
> >>>
> >>> On Wed, Jul 8, 2026 at 1:41=E2=80=AFAM Muchun Song <muchun.song@linux=
.dev> wrote:
> >>>> Do you mean that the support for AF might vary across different CPUs=
?
> >>>> I'm not that familiar with arm64, so it seems a bit strange to me th=
at
> >>>> such basic hardware features can differ so much from one CPU to anot=
her.
> >>>
> >>> Yes, hardware updates of the Access Flag is a per-CPU feature. It is
> >>> available for a CPU to use if TCR_EL1.HA is set. TCR_EL1 is a system
> >>> register; each CPU has its own. (Linux will always enable HW AF for a
> >>> CPU when it is onlined[1] if support is advertised, so we simply need
> >>> to check if support is advertised to know that it is in fact enabled.=
)
> >>>
> >>> These days it is not uncommon for a system to have two (or more?)
> >>> different core implementations, like with "fast" cores and "efficient=
"
> >>> cores.
> >>>
> >>> [1] See the CONFIG_ARM64_HW_AFDBM bits in arch/arm64/mm/proc.S
> >>
> >> Thanks for your detailed explanation. When enabling HVO via the cmdlin=
e,
> >> can we simply prevent CPUs that do not support AF from coming online?
> >> Would implementing it this way be much simpler? In practice, developer=
s
> >> definitely know whether the current system is suitable for enabling HV=
O.
> >> If some CPUs do not support AF, they would just need to evaluate the
> >> trade-off between memory savings and having fewer online CPUs than exp=
ected.
> >>
> >> For scenarios where HVO is enabled via sysctl, we simply need to check
> >> if all CPUs support AF. If any do not, the system should return an err=
or.
> >>
> >> Then, we can proceed with the Pre-HVO.
> >
> > I don't think it makes sense to try to implement pre-HVO.
> >
> > We cannot do HVO if any boot CPUs do not support HW AF, as HW AF will
> > be required to free the HugeTLB pages later, which we should continue
> > to support. Pre-HVO (today anyway) happens before all boot CPUs are
> > onlined. IMO it is not okay to prevent boot CPUs from onlining.
>
> When the boot CPU starts, it first checks if the hardware (the current
> boot CPU) supports AF (The selection of the Boot CPU is critical here
> If the user really wants to enable HVO). If AF is supported and HVO is
> enabled via cmdline, we perform a Pre-HVO. Subsequently, any CPUs that
> do not support AF will be prevented from coming online.

I understand. I don't think we should do this. I think it's much
better to always be able to start all boot CPUs[1] and simply rely on
"normal" HVO.

[1] Just to be clear on terminology, I'm using "boot CPUs" to refer to
all CPUs that are onlined at boot-time, not just to *the* boot CPU
that starts the kernel.

>
> If the boot CPU does not support AF, enabling HVO is not permitted=E2=80=
=94neither
> via cmdline nor sysctl. All CPUs are allowed to be online.
>
> Once the system has started, there is only one way to enable HVO, and
> that is through sysctl. 1) If the current system includes any CPUs that d=
o
> not support AF, enabling HVO is not permitted (unless the user chooses to
> take these CPUs that don't support AF offline). 2) If all online CPUs in =
the
> current system support AF, then HVO can be enabled. In this case, the
> system must also block any CPUs that do not support AF from coming online
> in the future.

An approach similar to this is implemented in this series: if there
are (or were) any HVOed folios, onlining a CPU without HW AF is not
allowed. If HW AF is not supported by any onlined CPU, HVO cannot
proceed (though it will appear to be enabled).

I probably should have integrated
`arch_hugetlb_vmemmap_optimization_supported()` and a `hvo_status`
check into the sysctl handler for HVO. I'll do this if it is still
relevant in v2.

> Of course, if a user specifically wants those CPUs to be
> allowed to come online, they can choose to disable HVO first (At the same=
 time,
> this means that the HVO-optimized HugeTLB must be freed first as well).

I could make it so that, if there are no HVOed pages anymore, onlining
incompatible CPUs becomes permitted again. I don't really see the need
to do this.

> My proposal assumes that even though the system supports different types =
of
> CPUs, their support for AF (I suppose this is a very basic feature nowada=
ys)
> is generally the same. I believe that for servers (Only servers stand to
> benefit more from HVO), there shouldn't be a mix of those that support AF
> and those that don't. At the very least, such a situation would be extrem=
ely
> uncommon. I believe this may be acceptable. That said, if we go this rout=
e,
> is there a way to simplify the code implementation even further?. Of cour=
se,
> this is just my personal speculation. Please let me know if I've missed
> anything.

I agree that systems where HVO is relevant are very unlikely to have
mixed support for HW AF.

I don't think the approach you're suggesting in this email (as I've
understood it) simplifies this series.

I don't want to mess with the arm64 cpufeature bits more than I've
done here; preventing boot CPUs from onlining will certainly be more
work. :) And then your other suggestions seem to be quite similar to
what is already in these patches.

I am happy to get rid of the "disable HVO if it is unused and a CPU
without support is onlined" part though and replace it with something
similar (the simplification from the other thread[2]).

[2] https://lore.kernel.org/linux-mm/674EC6D6-B1F7-447D-B462-861ECA5A99B7@l=
inux.dev/

