Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D5996CCD183
	for <linux-mm@archiver.kernel.org>; Thu,  9 Oct 2025 23:50:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BFCE68E0056; Thu,  9 Oct 2025 19:50:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BAD098E0002; Thu,  9 Oct 2025 19:50:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A9C188E0056; Thu,  9 Oct 2025 19:50:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 964388E0002
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 19:50:53 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D6F661A08A3
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 23:50:52 +0000 (UTC)
X-FDA: 83980223544.06.C41DC4E
Received: from mail-qt1-f169.google.com (mail-qt1-f169.google.com [209.85.160.169])
	by imf03.hostedemail.com (Postfix) with ESMTP id EDC1120008
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 23:50:50 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=YUiWhZCM;
	spf=pass (imf03.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.169 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760053851; a=rsa-sha256;
	cv=none;
	b=Y2Ew9MUQ6aL9pZKguR2MaAYrXgOZq8sOyPGmN5dw0JBBg6cv6Q+/kD4XoHX02aPKYZLTtB
	l/DXynn8cl2sRo8laG/k1NR7QdAGty9nYJf9xRmfHupTPh/hsoDt7YMNG8Rr9tjuxNyZML
	r/wV4ud4366ILzXIEO280JNiu1yjj6s=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=YUiWhZCM;
	spf=pass (imf03.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.169 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760053851;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=duqVUT7go4ZxqESg3UfMQLseHStSvb4cyv2AmihGRqU=;
	b=EjEvlFysDXGeR69TA5Ff2/hmzM27D/qTC9c5vNYl9xVYpRSFyMIc646CYZ+LWU1jmpWEEN
	j45ymRZigDOaEgwmxkS66jehUtFdyw5QhKYBRtObpCqO2h+tqM4APC9c6O8yGNKZCuBpyd
	tOkTez/9pTvkicyAYnQ5YzTeVYX4DCQ=
Received: by mail-qt1-f169.google.com with SMTP id d75a77b69052e-4df2911ac5aso8491971cf.2
        for <linux-mm@kvack.org>; Thu, 09 Oct 2025 16:50:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1760053850; x=1760658650; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=duqVUT7go4ZxqESg3UfMQLseHStSvb4cyv2AmihGRqU=;
        b=YUiWhZCMenkRPRiL/LsPiA0SEnUDBShAOfmjqbGLiPxfFrnYjn5G+QkMGbadVd4/XJ
         ZvD55772E6pUJXIUP640BbPg57P0T6GcLiMusKHC/X/GKHsKd8qdfar3kqunrhp9EnaB
         r2iQe+2fRIq9wVZiFEcpUGk0b+FvZwdUPhAxDBFI1Z67VvSwol3z+EVG9nNGaSWXs9SJ
         KZuPnsO1KxVLvEjZeDZ8atKhrrH4u8rRmIYVnps7ZZUMUpoZUBuD2xQCkNhMJgT0tkZf
         YrYzeBqNNxFHBYNPsoTHub+7uiKx9Yk4Lwe35x7ok7ElQy1tlYrr0ZCrXetzQ7jTiYcx
         an+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760053850; x=1760658650;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=duqVUT7go4ZxqESg3UfMQLseHStSvb4cyv2AmihGRqU=;
        b=lpGzuw4h/FeJS0OPGFafPoQUqKmpVpCr1OhqTScUM5Ef84MsQCrMKysqT+J2KBeEGZ
         QmMJCnKq70Ms+WUJUcMSbv5tqMiLKA6Pl8a2NZNGuDa9CNptzJSyLAijLQm25rPD3VE9
         Z6ZWjUf2HPMw7OUCoApHkpSAUqocQdCsBkQzmZR9uhdnzPJxlVxPjF6EdUv36oK5qrNr
         PWxWsjMop/O8NQ/Z+hWXBytFmPjeEb82dsHsbPi61y3qZ7Fdq/g9kKV2gsowis8tMdHm
         nM/GZJnaZp20ZqG3l3XY6+w+ZmMYECVBU1g/Q0wLdKMVSTuBZTg7ESjvEud4pRezQ1+/
         NcTA==
X-Forwarded-Encrypted: i=1; AJvYcCUCAzi8VOe5EGzJWW9nBILDm+YW+ljR3Hax0iAboTeoCGMPjv+FIj+uJzQdLfBzWWHoLpD2EVx15A==@kvack.org
X-Gm-Message-State: AOJu0YxOo+RUC9obMvCbz9Xd/3swiiYOMSS1YOEpiO6vPuXOwi0v1DMM
	PLosCt470FYPBayFpl0A9OloT/Dy7hS9HAefqjBt1KBS9C99NLQnB8HHWEmSxzA5xm3hn6zy2F4
	6cClJo7FQ4BdH5WTiuA4iSlHiM6qZEB1jOLx7XaOwJA==
X-Gm-Gg: ASbGnctCX5mGol+O7NcC1B3oO/7Pck5+DVOm/G+YH01lXpiIzQeuSJq851SpI7IpATn
	ywsU7glgFViteUsnc4lvv8Wvi92PRUfVV5KbkAoJdCMVHkUV5sM6IyTzUuFbKf4cbhg2lzp4Ekf
	oQ2xJeOJDxbzwz3XFXmXYcqtY8Sqo5f3m2WSsT9hZTvd+BcqQeMV2OZZxC4OdNid8yekUbqbzx0
	uMR1gZf4Tff4u56o/tVTjq+OOh2
X-Google-Smtp-Source: AGHT+IGzqqa1G0zf+VY5jF5o2/K3FQsYskXGylhSVDPQarH8ovd8yjaXj+2lxEhldlKlDevfO9Pxw709v3uWNVO/hiM=
X-Received: by 2002:a05:622a:1144:b0:4d2:1a1f:135b with SMTP id
 d75a77b69052e-4e6eaccc2d9mr144181361cf.3.1760053849859; Thu, 09 Oct 2025
 16:50:49 -0700 (PDT)
MIME-Version: 1.0
References: <20250929010321.3462457-1-pasha.tatashin@soleen.com>
 <CA+CK2bB+RdapsozPHe84MP4NVSPLo6vje5hji5MKSg8L6ViAbw@mail.gmail.com> <mafs0ms5zn0nm.fsf@kernel.org>
In-Reply-To: <mafs0ms5zn0nm.fsf@kernel.org>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Thu, 9 Oct 2025 19:50:12 -0400
X-Gm-Features: AS18NWA4BkWoWx107a5jn9RdQA3zHB-3kx_1Bn3qMWWFPgKkAAD4CNjnYqMlYPA
Message-ID: <CA+CK2bB6F634HCw_N5z9E5r_LpbGJrucuFb_5fL4da5_W99e4Q@mail.gmail.com>
Subject: Re: [PATCH v4 00/30] Live Update Orchestrator
To: Pratyush Yadav <pratyush@kernel.org>
Cc: jasonmiu@google.com, graf@amazon.com, changyuanl@google.com, 
	rppt@kernel.org, dmatlack@google.com, rientjes@google.com, corbet@lwn.net, 
	rdunlap@infradead.org, ilpo.jarvinen@linux.intel.com, kanie@linux.alibaba.com, 
	ojeda@kernel.org, aliceryhl@google.com, masahiroy@kernel.org, 
	akpm@linux-foundation.org, tj@kernel.org, yoann.congal@smile.fr, 
	mmaurer@google.com, roman.gushchin@linux.dev, chenridong@huawei.com, 
	axboe@kernel.dk, mark.rutland@arm.com, jannh@google.com, 
	vincent.guittot@linaro.org, hannes@cmpxchg.org, dan.j.williams@intel.com, 
	david@redhat.com, joel.granados@kernel.org, rostedt@goodmis.org, 
	anna.schumaker@oracle.com, song@kernel.org, zhangguopeng@kylinos.cn, 
	linux@weissschuh.net, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-mm@kvack.org, gregkh@linuxfoundation.org, tglx@linutronix.de, 
	mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org, 
	hpa@zytor.com, rafael@kernel.org, dakr@kernel.org, 
	bartosz.golaszewski@linaro.org, cw00.choi@samsung.com, 
	myungjoo.ham@samsung.com, yesanishhere@gmail.com, Jonathan.Cameron@huawei.com, 
	quic_zijuhu@quicinc.com, aleksander.lobakin@intel.com, ira.weiny@intel.com, 
	andriy.shevchenko@linux.intel.com, leon@kernel.org, lukas@wunner.de, 
	bhelgaas@google.com, wagi@kernel.org, djeffery@redhat.com, 
	stuart.w.hayes@gmail.com, lennart@poettering.net, brauner@kernel.org, 
	linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, saeedm@nvidia.com, 
	ajayachandra@nvidia.com, jgg@nvidia.com, parav@nvidia.com, leonro@nvidia.com, 
	witu@nvidia.com, hughd@google.com, skhawaja@google.com, chrisl@kernel.org, 
	steven.sistare@oracle.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Stat-Signature: gwt4jw9xid5kiaasoh1bsid4f77y3zit
X-Rspamd-Queue-Id: EDC1120008
X-Rspamd-Server: rspam09
X-HE-Tag: 1760053850-164410
X-HE-Meta: U2FsdGVkX1+3JZuWepSFx0Ubys8HEG0SShG21N/2UqpkCATjyfXfiTh3iU3THGGUHE7l2xAMc2vUt1cBOMHCuz4/Qu5LhReNDqoohEpDcgdTrKAbmawfwP2wtrRA3Nr4N2pvWBTCJAlFbozHTFeRN27whaMt1LbKf3WfHSzAZWpk7dhCxqcu7KZNS5/XPstGMhzApm7PMOyzVlzTFAWIvG8CTw2yWLzBaIyOeijzLnPle+sp172/lQjJwumhqhXgXFPyjmG7TEN9KrKO1fT3JdA1gYpq/Kljo0VF2uPTJFRbRj09EvgyGeqOyDhXICdKYyaECCWA2nJ56fk4NAcjI8PcxzZThtDA/6woD+Ew8sMKUoOutJuOPc4npsN5rgyIsK8zm5ziSbs1XnzmvmiULdd7jCzaYil8ZFqyFjRrEc0bbd1GifwdzhwJBPrt/XbWGabKWEHafmAatPFTbmBG2WDH0GVc40fat5urnztWp0c+gHpvvFu3PkJdhB9ArVLkrEnzPrbJpW0N5Th1E5RyszkM/uLcffSbmtId5pdR4F2F/XUJG9umw/+TLDj3MitwLJZoGuFVBQTTPZGGWfRlRu0m18o8qdBpY9SQ2kPa03RzcGX8Wnq7jVN5MRMTujO4HtvWLbuGOwsLLE8QmQJqi4gTLSNZLxO92appr5xIzs1vG4MSgJUcwO8zVgCxNK6MvU+OvB3H+iN66XXMkSMFC1QHmVO+4OM7x9PMiRb/OdBhDrcbtaeulUHiEH3yRDI3XJKdmYmC4HgJupcp3uAHtMkYOlC2MNEOccj+9aT7q0G7k7RkdqZIkgGMcU//64ZRfBGExpONO5IPWDDazTGQSQLtYNpTPPQ+R3FLGZQDaD405S+TBQlhKFimQCiMnVsluZw3giNqCjafg/GlbD0DE2w+dAx8oacpZvJluGHBljsb+XymRERWofiWaju/A7rPnWv4oD2EWdcQfo9c1SW
 Tfplk4Ta
 GM9vuGd0rJRqqtzPwObW5BvsZ7WehMwpXl6LxaRrZ14QptC4hgfeRJMhrRGI9TvDz2gRQI7vLfU+m7J/wbtw8+J53ZqOqqFIFEzQLs4thwERmhYc8gq10z0mkaAFmaaT8cnSWye05iaqLeW9GHFEJ78E8mz0ea1AHvF5cMQQMt1byWZV2E61T8CrNgqVuSVT7J5uAngNGAdDAZdYfk8SoFrkRZhHN1FXOeDTWiYVWRWqu3P8iUT/QeLX8FoPSaHBXOgbLobffJ6pZquOxiG/P/BHDwkH5c35LvBQN5MJ1Q4FZKE9YOpCt2pEE1Z2XuYF1OzA92gDUQdfYkb1EVtC4jk0xmnrE5RaqA0juty9FoDKWceQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Oct 9, 2025 at 6:58=E2=80=AFPM Pratyush Yadav <pratyush@kernel.org>=
 wrote:
>
> On Tue, Oct 07 2025, Pasha Tatashin wrote:
>
> > On Sun, Sep 28, 2025 at 9:03=E2=80=AFPM Pasha Tatashin
> > <pasha.tatashin@soleen.com> wrote:
> >>
> [...]
> > 4. New File-Lifecycle-Bound Global State
> > ----------------------------------------
> > A new mechanism for managing global state was proposed, designed to be
> > tied to the lifecycle of the preserved files themselves. This would
> > allow a file owner (e.g., the IOMMU subsystem) to save and retrieve
> > global state that is only relevant when one or more of its FDs are
> > being managed by LUO.
>
> Is this going to replace LUO subsystems? If yes, then why? The global
> state will likely need to have its own lifecycle just like the FDs, and
> subsystems are a simple and clean abstraction to control that. I get the
> idea of only "activating" a subsystem when one or more of its FDs are
> participating in LUO, but we can do that while keeping subsystems
> around.

Thanks for the feedback. The FLB Global State is not replacing the LUO
subsystems. On the contrary, it's a higher-level abstraction that is
itself implemented as a LUO subsystem. The goal is to provide a
solution for a pattern that emerged during the PCI and IOMMU
discussions.

You can see the WIP implementation here, which shows it registering as
a subsystem named "luo-fh-states-v1-struct":
https://github.com/soleen/linux/commit/94e191aab6b355d83633718bc4a1d27dda39=
0001

The existing subsystem API is a low-level tool that provides for the
preservation of a raw 8-byte handle. It doesn't provide locking, nor
is it explicitly tied to the lifecycle of any higher-level object like
a file handler. The new API is designed to solve a more specific
problem: allowing global components (like IOMMU or PCI) to
automatically track when resources relevant to them are added to or
removed from preservation. If HugeTLB requires a subsystem, it can
still use it, but I suspect it might benefit from FLB Global State as
well.

> Here is how I imagine the proposed API would compare against subsystems
> with hugetlb as an example (hugetlb support is still WIP, so I'm still
> not clear on specifics, but this is how I imagine it will work):
>
> - Hugetlb subsystem needs to track its huge page pools and which pages
>   are allocated and free. This is its global state. The pools get
>   reconstructed after kexec. Post-kexec, the free pages are ready for
>   allocation from other "regular" files and the pages used in LUO files
>   are reserved.
>
> - Pre-kexec, when a hugetlb FD is preserved, it marks that as preserved
>   in hugetlb's global data structure tracking this. This is runtime data
>   (say xarray), and _not_ serialized data. Reason being, there are
>   likely more FDs to come so no point in wasting time serializing just
>   yet.
>
>   This can look something like:
>
>   hugetlb_luo_preserve_folio(folio, ...);
>
>   Nice and simple.
>
>   Compare this with the new proposed API:
>
>   liveupdate_fh_global_state_get(h, &hugetlb_data);
>   // This will have update serialized state now.
>   hugetlb_luo_preserve_folio(hugetlb_data, folio, ...);
>   liveupdate_fh_global_state_put(h);
>
>   We do the same thing but in a very complicated way.
>
> - When the system-wide preserve happens, the hugetlb subsystem gets a
>   callback to serialize. It converts its runtime global state to
>   serialized state since now it knows no more FDs will be added.
>
>   With the new API, this doesn't need to be done since each FD prepare
>   already updates serialized state.
>
> - If there are no hugetlb FDs, then the hugetlb subsystem doesn't put
>   anything in LUO. This is same as new API.
>
> - If some hugetlb FDs are not restored after liveupdate and the finish
>   event is triggered, the subsystem gets its finish() handler called and
>   it can free things up.
>
>   I don't get how that would work with the new API.

The new API isn't more complicated; It codifies the common pattern of
"create on first use, destroy on last use" into a reusable helper,
saving each file handler from having to reinvent the same reference
counting and locking scheme. But, as you point out, subsystems provide
more control, specifically they handle full creation/free instead of
relying on file-handlers for that.

> My point is, I see subsystems working perfectly fine here and I don't
> get how the proposed API is any better.
>
> Am I missing something?

No, I don't think you are. Your analysis is correct that this is
achievable with subsystems. The goal of the new API is to make that
specific, common use case simpler.

Pasha

