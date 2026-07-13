Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C278EC44501
	for <linux-mm@archiver.kernel.org>; Mon, 13 Jul 2026 04:10:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C65C06B0088; Mon, 13 Jul 2026 00:10:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C3D7E6B008A; Mon, 13 Jul 2026 00:10:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B2DA96B008C; Mon, 13 Jul 2026 00:10:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 91A196B0088
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 00:10:18 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 049C71A0A51
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 04:10:17 +0000 (UTC)
X-FDA: 84982426116.05.7A6373D
Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	by imf08.hostedemail.com (Postfix) with ESMTP id 180B4160003
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 04:10:15 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=jekvS33I;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf08.hostedemail.com: domain of jthoughton@google.com designates 209.85.218.47 as permitted sender) smtp.mailfrom=jthoughton@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783915816;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3tD+7MnOoTjJBs3fshzrrIZbo5/nTz8+RZZUhLw+smo=;
	b=EkmXGjqiQHV+QoXT6pRwkwxLtVR9JMsNCOwmq+mVC7AwzurY+FcuccCSmutZZjMv9e/I6W
	kYtkaepRDVmuqmC58F1alyO+93O2+DfXAaWp++jaEKkJ65as0IZUKCq0Utc9lshFqF2zep
	clwQtxcDlT8KOHluRhfvCYp6aExh1Rk=
ARC-Authentication-Results: i=2;
	imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=jekvS33I;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf08.hostedemail.com: domain of jthoughton@google.com designates 209.85.218.47 as permitted sender) smtp.mailfrom=jthoughton@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1783915816;
	b=NOLBCpbgz10D6E6Uu37O2X70CB+tbuuTaGUFe3XedtHzUNSoQg3Ah/FcJevwc2l9FCJsRN
	E2UI6RwzIYfWNwWA1AV6qTovvx0Oe/BIdRfylzLomOEse6J/XM/ch7r+YtSi6NMjD5O8Gk
	MXiJkqiyIRytc8HzjjYK7jgRo63QY/o=
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-c15f360851aso374915266b.2
        for <linux-mm@kvack.org>; Sun, 12 Jul 2026 21:10:15 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1783915815; cv=none;
        d=google.com; s=arc-20260327;
        b=JozVywdAQMdaccszbU/KTad+GKLTwnPS4x+3WGWjmYos7HWI3qJgT20FOdmnIEr7F4
         4Ttnin0QMNm3WGkZa2L/gzWhx01KBraF0zZpMS/JjLvGiN8LgNSVfQ9qW2bc8gsw2Bff
         R3Sn/Bn85wYPw6rz8D+WGihQDlcG8X82pcSPpx9fmN1GczmTqEnxTHpqS5/i0x1wXCYf
         BYWdZjrxfSExPo/xbdC2d2787ZBVCzZB+7+2MmAmRqGqHuHPdBCH74vXyprVi0DwXq4y
         CSNZVQHbwafkyRyFBchI/aaopEj8M5EjIx35w3GQa9ZQQR5IUInZT7W7bqPAQC/S7iiR
         qTCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=3tD+7MnOoTjJBs3fshzrrIZbo5/nTz8+RZZUhLw+smo=;
        fh=5piJ/yn4B+1lkwB0haQ84JDBmBIoFpCYMfHabqbNPaE=;
        b=PufXTFcMMMVQ5FTElH0v5ME5M+NjtCqQbVo8qPy83nLRNqXIiVusm11z8FQVq3vDkV
         vpYLUIQfNMkd2C+0BbdJB1R7MT0ULTKSnOjx2XLURKXBZBnwo+z/9HahipnXwX69djao
         6LMi0ZtlIRebmHlCiHxstaiEwP6tnW5VY1VrHnYZkjvxAGDDOHQYzzvXIsuSZqP8nwr/
         LpweNY0EzM2AdKtN2AKIE3MHee/BtVQobz11q5awCrsdld+S2haw4mV5whn7H9Z0ya/D
         YtR1b+98YrvZTeQKX1maa6vV/x+zJU97M+VL7OPU/PqR7i/carvKDqWaLp/15ScOC3v2
         zOZw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1783915815; x=1784520615; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=3tD+7MnOoTjJBs3fshzrrIZbo5/nTz8+RZZUhLw+smo=;
        b=jekvS33IDboRI9MpFFkQrh8+dn4yljO1RueOxAnpZwYxzP6farorfemo9d8/8cw7BX
         08Rw91p1TnKoxfO9s9RNZZuAaU1I11wR6+jj7RZP2b3iVDyBmMkqx6ejDonssUst1yee
         RIjPcelirlhmUhkhfVKJOVkteJNodraRsU3J2oojoYMflxFK3VRkzup5kfXRx22B2l2X
         WqS3B64h4TO/JmRyr3TpR2OVPMmCy/O4wztNX80RVGkR2KChAlYRDWTmJ9jZi0V2LN+d
         oD90xcTkHW9m+LNCjQhL+v1zrWB0RhGtWePkeWzOUxAPSudoLphDsJ/H2VkxfNCN+0jj
         Wjdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783915815; x=1784520615;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=3tD+7MnOoTjJBs3fshzrrIZbo5/nTz8+RZZUhLw+smo=;
        b=JI71Iu2j0rCba0hl/RK+puCJN3Gp8+Y6/vhg5RuJEzpaXsLqPf1befHYEyXQFOK+Zy
         CrPkLSfKe+CFxASC1pHilT2Aqz8EUGXSYGjLUGkjSZA24cMwxHgcN4Plx7lJSUpSokYm
         e5bWLDFH7RlZLlk6kERpCseuQevhcsASxtr8k7kN4tKL5aGh3zklNyvdiRawKFsNPC5O
         IOqiKLokZHwCh5LR7eby9de+rpWhjrD4jiRue9825ALXXgKWyJdZ+7GcFL9M1taJhyyU
         tfBEJHHa6zjuEpkgOZdtbU6RJVQEa+njE5ceXeou1abMpA8i53Y2Vn6vON84oKzWbpzo
         q4hQ==
X-Forwarded-Encrypted: i=1; AHgh+RqaP0ibRackE5RRFIGT5a0Pjf82tiV6UbKV+n5Wkaiu6h8HFnbdYyo/3QZacrkrwlvhNdgVungC9A==@kvack.org
X-Gm-Message-State: AOJu0YzwYm4oN/GHycIXWuFRioZ/ELz1DjS83/Q+YLY1fqkTNkztjJ/8
	vo1+kAqph7gCe3lGEetZnUP2IO+oHYa05XsBmoiZ1xu9N1Zsjll61x8VY58xzx4Dt7fS1eimbYR
	mL2RbK3pXwMdeQqA19SamBVmLDjxhbKalmvCFBpFD
X-Gm-Gg: AfdE7clkWqbZkn4O7ESynf0rQsim75ZsqliRJMvr10KZ0Zraq1vR8t5QPqAsk4zP4t0
	psm7vVbspD9nKyFi7tKSi0bWVwi/QOAiQ4NwKud1v4F8MlufAAvh0oQ8xhskhJrW+zdVhPKzzoj
	0vCdipqOOAXHmFEqHXytiGYU4d+MGkuibjI4OI2KuJY+2hA7eGull0XYyIsTpYdmAMSrv4xCQfT
	AsSoUSywHHmBivZPOIFaAQDnt09nZcaOWyErkkty+/ga6J+mtb9MeEH/0pBtEtgJqXFCQKf4cyA
	PQt7xtAOsWqOBBHU4IGzK3/PVvE=
X-Received: by 2002:a17:907:a785:b0:bed:9a7:5ed1 with SMTP id
 a640c23a62f3a-c161e956b92mr277921966b.5.1783915814340; Sun, 12 Jul 2026
 21:10:14 -0700 (PDT)
MIME-Version: 1.0
References: <20260708031129.3503195-1-jthoughton@google.com>
 <FC9E78F0-8FF7-44AF-A848-8401B4702488@linux.dev> <CADrL8HVkrojXbBuEX-W=UHBmyyFzqxdGBvtAoPP53SyYa10uag@mail.gmail.com>
 <ABB70C2A-316E-4C19-A855-C9920BE105E1@linux.dev> <CADrL8HUCqrzOQGXRDwnitintQHjHCw10n8wo6gChQ2tWvC2JBQ@mail.gmail.com>
 <674EC6D6-B1F7-447D-B462-861ECA5A99B7@linux.dev>
In-Reply-To: <674EC6D6-B1F7-447D-B462-861ECA5A99B7@linux.dev>
From: James Houghton <jthoughton@google.com>
Date: Sun, 12 Jul 2026 21:09:36 -0700
X-Gm-Features: AVVi8CeIAdsZ8vBj0o0oFzX9SAZHhNmejnZxvQk9nHEtMZWM7457PWKYqV0QjhM
Message-ID: <CADrL8HXeKSt0fRrevT7cuVJGhmJ=7LCkMnBahf5YLR-_90WePA@mail.gmail.com>
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
X-Stat-Signature: bcxxxso3nb9zzbqawud5758z9t5ox9h6
X-Rspamd-Queue-Id: 180B4160003
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1783915815-921570
X-HE-Meta: U2FsdGVkX19VXcpaer0zPRq+olHe7c8w8UnoLL4pkn5mWOkHbRp2TMlPhxOsM873b0pfziw2goIG3kn80ySPj0Tm6Y/qXW5H3ghQIUX0PkOpk4x5Te55ZNvpwttgrB/hB/dEhvdDf31ZzfclLn3Vo4bRzSqvx4fzLPsGhjK63Tqr/L9+FYVTDpFDv+KHQeg4bxKU57NdInXgtCx1t+OfsjlyO3nTg9J98+gph/0KMQZDgaN2qkW3AcPfKW41Wp2PbuN2GQH9COzaH06E4NrnZuFQjQHY4ZpJb12TKrkBkThOCqHcSpAAjSDfoYT4F/LlvvuYcSgAuuPzh3CYJ7hlIEbGpUGDSblPjqLej4jZYcH+V2hTL3YBgnyegGEcaauPYDBzIZp1SlbyC8R3rDHY5X2Xszq3cSPZ7J7xOjZdg41gAKYkUqkMTdFPAEInyHK7OPlDkBiOaqYft6jWUXiXpK/A3IzUQEEPW0hBgogbLfxHp0aJM/F0pvmHiYeogq6lUxWjbB3mzPW6fiaQok17VMKWkjPj+YVlZVZIVQOmIA3ZZwiaHDGIUgl9Tc0ojahO6k2q8zrNSM/MNRWMDrHZHoIV8FZ4oS3AceC0nX69FuS068lInWmQ6jOWj+DjbU6mZed2/uyp24xDCdJCBD541LKuUx2giOi+P+VZcquCandrQwiHm6OXiq4SiUAjOOzvqiLOZtX6FY59wddQ8GeE7GC/N9JgkAErOALV1lo4+Vaz9x7MxEskyQS3CLC3eOID59zozJlMt9bcZsIom6+VSo+U86EN7fyCvwguDsRIKDtpKByjawrEMcU4cxmNQc6n5uXir/lBPp7I/mzZHUDQy0xC76P/sylA8A8H91fzYdRvz2CSAhDHjeu/PvJt40lsuJN+6coRhf/Y7hsZq10Vr9MfftBGCw1saNrIkAN1qopLLsDmZX+UkwbVBQJBbRvGmPEB1Prl9aELGVSv9OO
 eE5y8hqG
 Y9PeIB+wURBczYGizLoqQoK3RrcdXT2vSgtlqJx1m5H1WcGq6+6Wszk9v9GNZVjCHlb63HWu+9jKSuYJGMy1AqZdKeDVn+enHk/s55Vs27t1Zt8oiAbzNBfROEB9AG7g8nJsnEl0nafOcVC3KHvILJxwrFpipUtrd/6iOrQ236ep/PKKs1LL5I/+nNa32JJDH+pHjn7bR48UFS/iV46wW2d+ZwNCHmC3NOXyJO1X9UGLkioIt7v1YAU8QFxCD/OgIDl2qJ88nVZ1RacRHK/TX8uH/rOTVWDbZ3lu8l2LHNRW3NkzXnyIz3wfjGcWCy+iS5odAkOGUqm+U3WMP86OaUKpBDw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 10, 2026 at 7:23=E2=80=AFPM Muchun Song <muchun.song@linux.dev>=
 wrote:
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
> >
> > Let's say for a moment that HVO cannot be toggled at run-time, then
> > the best we can do is:
> > - If a user does not specify hugetlb_free_vmemmap=3D1, we can always
> > allow onlining of late CPUs
> > - If a user specifies hugetlb_free_vmemmap=3D1 but not all boot CPUs
> > support HW AF, we can always allow onlining of late CPUs.
> > - If a user specifies hugetlb_free_vmemmap=3D1 and all boot CPUs suppor=
t
> > HW AF, we must not allow onlining incompatible late CPUs.
> >
> > HVO compatibility has to be modeled as an Arm system feature. To
> > support conditional onlining of late CPUs based on whether or not "HVO
> > is being used", we still need the extra cpufeature.c logic.
> >
> > So if HVO cannot be toggled at run-time, we can simplify the
> > definition of "is HVO being used?" (for the purposes of determining if
> > late CPUs can be onlined). We can simplify it from what it is now
> > ("are there any optimized pages?") to
> > "vmemmap_optimize_enabled=3D=3Dtrue?". That allows us to drop patch 15
>
> I believe this conversion logic is sound. If a user proactively enables
> HVO via the command line, it clearly indicates they intend to use it.
> Otherwise, there would be no reason for them to enable it and then leave
> it idle.
>
> > (which then needs a slight change to patch 17), but that's about it.
> > So this is a slight simplification, which is nice.
> >
> > If you (or the Arm folks) feel strongly, I'm happy to write this simpli=
fication.
>
> I really like the simplification here. To keep this series as simple as
> possible for the first step, we also could focus strictly on bringing HVO
> support to ARM64 by making it depend entirely on BBML2_NOABORT. This keep=
s
> the initial scope highly contained, which should make it much easier to r=
eview.

Okay I'll do this then. I'll probably still include the BBML2_NOABORT
patches anyway, as I don't have access to any systems that have both
HW AF and BBML2_NOABORT / BBML3 (even with the expanded list[1]). I'll
continue to structure it where the series can be partially applied and
still be useful; i.e., the patches to drop the BBML2_NOABORT
dependency can be ignored.

[1] https://lore.kernel.org/linux-arm-kernel/20260708144331.679816-4-linu.c=
herian@arm.com/

