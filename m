Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D6638EE498B
	for <linux-mm@archiver.kernel.org>; Tue, 30 Dec 2025 16:38:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1E5396B0088; Tue, 30 Dec 2025 11:38:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 193B16B0089; Tue, 30 Dec 2025 11:38:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 095736B008A; Tue, 30 Dec 2025 11:38:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id EE2996B0088
	for <linux-mm@kvack.org>; Tue, 30 Dec 2025 11:38:00 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 909C356EB4
	for <linux-mm@kvack.org>; Tue, 30 Dec 2025 16:38:00 +0000 (UTC)
X-FDA: 84276694320.30.5A2376A
Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	by imf14.hostedemail.com (Postfix) with ESMTP id 830C5100003
	for <linux-mm@kvack.org>; Tue, 30 Dec 2025 16:37:58 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=Rn5uit59;
	spf=pass (imf14.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.54 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767112678;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KRg6CrcJkBXZs3BQb5XRdbXuKq3vmzU1zmho9EhETiQ=;
	b=vZK1qn2PwcGJMJod/4qSUKsQMyfLm9iUcr3nYay7F8ILjTRDx6VRifUTErl/WCstBhcbkN
	iFeuzox7qj0AOFHHTLh8ngtYsXXsi5WlDmnkgVPVhzXIAk39fPldDZjPaYMwyCMa/+995+
	hTN8JQvw22AfpnV8FNPZ/WRj/MNJXRI=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=Rn5uit59;
	spf=pass (imf14.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.54 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767112678; a=rsa-sha256;
	cv=none;
	b=DZ/3hzQiKEguskX2DAmegWy4XyscuDWZMTE/yH2aYhpAwR1sFxpqwE8sS9JDDynNTUMCz+
	iO6DFLk96qQOYyJL61BD1f1N2HxnoRxp7nRXY9pZT9sk5rc0E/hF5VQS7yOzyyw+mCw35s
	/E2uNWN+9Q66RJuKlgbh+X9XlD/BP0o=
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-64b61f82b5fso13543480a12.0
        for <linux-mm@kvack.org>; Tue, 30 Dec 2025 08:37:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1767112677; x=1767717477; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KRg6CrcJkBXZs3BQb5XRdbXuKq3vmzU1zmho9EhETiQ=;
        b=Rn5uit595dGC23SZnVAH+KNWQCrjIIlbxnKg3c9DNQbh7tho5UZiusHasYoBRruGpQ
         S2iGsMXdtE0o5VGz+JtXnn9EXgrQ/j+9eRA6s+MDozz135i57Vr/Z8AFyq3l4WHKCUoC
         pFE/Pe5j5pdThnlLw4evQV+f/hOqW3VX6O87Oos+IPb9ZQMYp1msml72i3vvVl5gPgYJ
         plLa40PFifIRysvTGeU9OvOADsZ6J6/bI4vyId45BIW1ijET1Yn/K0WthwgUOZnr1PbB
         544HxRUWHaaK1Qdhy7Qw13bxlaiXtD9NQrpsTrLQtgA9LxyIKBbO4C0uzBL3waE+b5YY
         ni8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767112677; x=1767717477;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=KRg6CrcJkBXZs3BQb5XRdbXuKq3vmzU1zmho9EhETiQ=;
        b=UWzen9acUpjji7WYC16emTHN3TEeRxMiUfRKfSkeJJxhzVxfMVyizqRAIX63y0VaVD
         RrzdikQOb53ezRjaVRJgnx6SsmFzbte4Uk5JgYx01E+P9eGyWdudb/etDBin8TGnKoyo
         l9qMwuhYzBQgAWoyQ8GmL9DMDqyGmyUPwuKRUe7f1PXc+VlPfVTEf2QQJaVlRst0jqGF
         NWAm9aiufywy3QdXu3zfWgH9DezNp2MBNq2tJsd4lPgfaUiY9lKv5VJmf4EAxLhSuDLe
         CKLV6Vi4CxdToc2YnevoMrRkcHP5X8p5Etduplhko2XiyacN/Cy/Rh3ioXtrSdRc4zqn
         xzzA==
X-Forwarded-Encrypted: i=1; AJvYcCWWiGnfVsAIszqserSIZH50YRqZA5ARkQLFZaPFT13By6RdFMDmKJW77zVpZ1xsghVBGwhdSTAiTg==@kvack.org
X-Gm-Message-State: AOJu0YxRyX7mRRcnUjXPwiyX96QgAbjpH3oWWTgibo73FgswPPxfi2TQ
	98n53wdePkSzitS5/yHkLTrDgCfCgt8DHDGLdVYXhM6T4g3LI3a8bp7rKcoWc1Z/Ly9EwuUPbnY
	ZAo1Yi2Bcr011DH/XneNwdS3dr10ZJR6BWIRcZMvtAg==
X-Gm-Gg: AY/fxX4P+h5oQma/5kXkL/KHirTkQwH06xFsmOIpbtCy1928VoUnRk2ePBKIOGk7UIL
	u7cmVLa8bzfyp0JTrgPF4wdtlitIaethyQJWDzlJesO1QYL1ng2jJo7H/jZ+7/zd54qwB7Ff8xU
	eYnnvYrDr5dVSYIEcF9B1ORyPAJ90tDDV4qHDBCPM82C38IHeImBvcbmDYmpHmieUoTGIwxcYoZ
	7wo9/BOj7d4t3+oDAv05dFW6tlWhe/kxb5iAxdcF6BkRL6kwb+157Ro+S8HXvhJH+FbW7J8s+9j
	qqxfjDqjsMuWGuRaIllKtVT9Tw==
X-Google-Smtp-Source: AGHT+IGt84JqyxLT4FVa1NK9x43gWi2TvpGddBi/ddcId92JOTd0e+vB9z2i06mYaiwFTk4rPI2jpbCaXF0BnPuhN5Q=
X-Received: by 2002:a05:6402:2713:b0:637:dfb1:33a8 with SMTP id
 4fb4d7f45d1cf-64b8e944eddmr31901439a12.3.1767112676868; Tue, 30 Dec 2025
 08:37:56 -0800 (PST)
MIME-Version: 1.0
References: <20251206230222.853493-1-pratyush@kernel.org> <20251206230222.853493-7-pratyush@kernel.org>
 <CA+CK2bAVuHG1cVPQz8Wafe8o2TtitrqJjqfHOT7Xun=zWMoo2Q@mail.gmail.com> <86qzsd7zmu.fsf@kernel.org>
In-Reply-To: <86qzsd7zmu.fsf@kernel.org>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Tue, 30 Dec 2025 11:37:19 -0500
X-Gm-Features: AQt7F2pvBnnd5fD8grNsYPQ7hitVBz_yujsMM_6ymMYxKOIzOHac-8gxUv2SYKE
Message-ID: <CA+CK2bDQDsjBkYabH5DVzSr_kuut-XHKb+JFTA=PLa+8gcCVLw@mail.gmail.com>
Subject: Re: [RFC PATCH 06/10] liveupdate: hugetlb subsystem FLB state preservation
To: Pratyush Yadav <pratyush@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Jonathan Corbet <corbet@lwn.net>, 
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Muchun Song <muchun.song@linux.dev>, 
	Oscar Salvador <osalvador@suse.de>, Alexander Graf <graf@amazon.com>, David Matlack <dmatlack@google.com>, 
	David Rientjes <rientjes@google.com>, Jason Gunthorpe <jgg@nvidia.com>, 
	Samiullah Khawaja <skhawaja@google.com>, Vipin Sharma <vipinsh@google.com>, 
	Zhu Yanjun <yanjun.zhu@linux.dev>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-doc@vger.kernel.org, kexec@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 830C5100003
X-Stat-Signature: xbunh4ajygq8paszx4nuwkpa9mxpeekh
X-HE-Tag: 1767112678-320364
X-HE-Meta: U2FsdGVkX1/fF6wYolnpU+OE/jpjI4lV7O3WvaLlmOuuBKqcUMVGzTpbBU/KckdUrvd5H/YbrzT3GT2vUuC66UiQiT9tiqSDY11nTtSCOaoTDltJYoGOQc2ztHUab14SRjWCHMNi/YkZ0mFp6oqDVkCwLZHLVCTv5o1bcXIMFBeVYaaUMIvve/otttJmq/nDB3fmWwj5kPlBWPL50drbyRJl6CP2jYgQGDkFEnfuAsZRtxdwlCPasYQsJoi24WSGQ/e+Q9V7vzL0LAziFYwEE/RdgIl4ZXhRJ9aoVuNjOr9+TdsssTgO/R5mFllVglfF3ljvwp9ZNt/op/qynKAAV6JMf2jx3P3ioyQPCn9t9ZtGGvNrSoBfdbsnZ1Qmordtr5mIUBZbbbRQXyLfhz9cBGiF4Noz2fBTR6luuwdUm8XWseqtSLgPe33x04NfmbJhF06bWaMOmk+984rSEC/RhXombEdQJN4Dm33yesc63wSXY5M5mTTGFqNUXFnzhLMwneQeaJIodHUuwPRgo3fs6A4kOWgC5A3x3OYWE04GkW52aVLX5Ps/syqTcHxbp3bt9Ilza9N5hyAynGdJDCMtRSctwhDUwv6wbmMFoC7/S/4FVyCCRfitHUyH1g281aEHBC9lDS/qrxnyz5+Ze1XGzhGfsf3sLFajxv3VYqk0GImiU+cKQB9OWmhWYOBXWbt62iSSqW7q2qLbY/7J89uzudqzXXYOFei1lS9tEBR2ZBDhCylVrnRLoEhCt4V1VYfXHrFUXOPTuwW7AfA7U6R1RhZhih/ae0oKIyKiL8pPcZyasfeacL3ujVksL2sT/KL2zqKcfoQllZUlU6nOPGZXKtjqzm77Sh60CFLjHwefadqjq0oa1H3NU0HvWhJukiABjmqfCaZW9szP8l0JCeBv9prlDX5QrMt3XMqhOPOZmRmsyjPkZO/TENk81xrgCViJppcZcVm30TEVvsI0jN2
 NQHkn9IF
 TO3MsbKKJLCu7LfbeX4mtUjegk9OTIHakFNJrbfA+Uo3wdK4mynpTh0f/qIeBgKE/MkHN3awTBEys/jU4Ti5Zo48ipQfVwStunCG6IX4mf8T4uduVIVAfghcn/dEy/oDRciNHynPz97ZSbjqWcEkSBmlCA2M4bFhvMRd0WCP3w3BbhRLF59Os8lL4AP+hGAQ1arsinC+KFfPSOqJUQOkUPo4VFA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Dec 29, 2025 at 4:21=E2=80=AFPM Pratyush Yadav <pratyush@kernel.org=
> wrote:
>
> On Tue, Dec 23 2025, Pasha Tatashin wrote:
>
> > On Sat, Dec 6, 2025 at 6:03=E2=80=AFPM Pratyush Yadav <pratyush@kernel.=
org> wrote:
> >>
> >> HugeTLB manages its own pages. It allocates them on boot and uses thos=
e
> >> to fulfill hugepage requests.
> >>
> >> To support live update for a hugetlb-backed memfd, it is necessary to
> >> track how many pages of each hstate are coming from live update. This =
is
> >> needed to ensure the boot time allocations don't over-allocate huge
> >> pages, causing the rest of the system unexpected memory pressure.
> >>
> >> For example, say the system has 100G memory and it uses 90 1G huge
> >> pages, with 10G put aside for other processes. Now say 5 of those page=
s
> >> are preserved via KHO for live updating a huge memfd.
> >>
> >> But during boot, the system will still see that it needs 90 huge pages=
,
> >> so it will attempt to allocate those. When the file is later retrieved=
,
> >> those 5 pages also get added to the huge page pool, resulting in 95
> >> total huge pages. This exceeds the original expectation of 90 pages, a=
nd
> >> ends up wasting memory.
> >>
> >> LUO has file-lifecycle-bound (FLB) data to keep track of global state =
of
> >> a subsystem. Use it to track how many huge pages are used up for each
> >> hstate. When a file is preserved, it will increment to the counter, an=
d
> >> when it is unpreserved, it will decrement it. During boot time
> >> allocations, this data can be used to calculate how many hugepages
> >> actually need to be allocated.
> >>
> >> Design note: another way of doing this would be to preserve the entire
> >> set of hugepages using the FLB, skip boot time allocation, and restore
> >> them all on FLB retrieve. The pain problem with that approach is that =
it
> >> would need to freeze all hstates after serializing them. This will nee=
d
> >> a lot more invasive changes in hugetlb since there are many ways folio=
s
> >> can be added to or removed from a hstate. Doing it this way is simpler
> >> and less invasive.
> >>
> >> Signed-off-by: Pratyush Yadav <pratyush@kernel.org>
> >> ---
> >>  Documentation/mm/memfd_preservation.rst |   9 ++
> >>  MAINTAINERS                             |   1 +
> >>  include/linux/kho/abi/hugetlb.h         |  66 +++++++++
> >>  kernel/liveupdate/Kconfig               |  12 ++
> >>  mm/Makefile                             |   1 +
> >>  mm/hugetlb.c                            |   1 +
> >>  mm/hugetlb_internal.h                   |  15 ++
> >>  mm/hugetlb_luo.c                        | 179 +++++++++++++++++++++++=
+
> >>  8 files changed, 284 insertions(+)
> >>  create mode 100644 include/linux/kho/abi/hugetlb.h
> >>  create mode 100644 mm/hugetlb_luo.c
> >>
> [...]
> >> +static int hugetlb_flb_retrieve(struct liveupdate_flb_op_args *args)
> >> +{
> >> +       /*
> >> +        * The FLB is only needed for boot-time calculation of how man=
y
> >> +        * hugepages are needed. This is done by early boot handlers a=
lready.
> >> +        * Free the serialized state now.
> >> +        */
> >
> > It should be done in this function.
>
> The calculations can't be done in retrieve. Retrieve happens only once
> and for the whole FLB. They will need to come from
> hugetlb_hstate_alloc_pages().
>
> Maybe you mean getting rid of liveupdate_flb_incoming_early()? Yeah,
> that I can do. It will make this function a no-op once we move the
> kho_restore_free() to finish().

Yeah, this is what I meant.

Thanks,
Pasha

>
> >
> >> +       kho_restore_free(phys_to_virt(args->data));
> >
> > This should be moved to finish() after blackout.
>
> Sure.
>
> >
> >> +
> >> +       /*
> >> +        * HACK: But since LUO FLB still needs an obj, use ZERO_SIZE_P=
TR to
> >> +        * satisfy it.
> >> +        */
> >> +       args->obj =3D ZERO_SIZE_PTR;
> >
> > Hopefully this is not needed any more with the updated FLB, please chec=
k :-)
>
> Yep. IIRC when I sent this series the older version of FLB was in
> mm-nonmm-unstable.
>
> >
> >> +       return 0;
> >> +}
> >> +
> [...]
>
> --
> Regards,
> Pratyush Yadav

