Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BD96ED26283
	for <linux-mm@archiver.kernel.org>; Tue, 20 Jan 2026 18:35:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AD1E56B0483; Tue, 20 Jan 2026 13:35:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AAA976B0484; Tue, 20 Jan 2026 13:35:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9D6C26B0485; Tue, 20 Jan 2026 13:35:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8BD5E6B0483
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 13:35:35 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 4D3E81AF657
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 18:35:35 +0000 (UTC)
X-FDA: 84353195430.29.4F39418
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 6337E1C0009
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 18:35:33 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=TXaAldEp;
	spf=pass (imf18.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768934133;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OJD5vU4OQnbGEmFpWt9NVYFsiNiyrO4DhhwC2rYlt28=;
	b=OxDGOMkDAiXV6CmfadAb+FUDyxBfO+TX18BNYEsBfBxWhzQ+OyTKhg08XNGDGXV2mC6JgV
	UOI7LSSORGuMN2Ddn3oHy1hxe42vcK6da1/xj54dZpZpkWk6EJsDo0ItTKvC0fBJO1W05A
	F3+PG9itpQiEeRUnKB59YpVulFa4gBU=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=TXaAldEp;
	spf=pass (imf18.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768934133; a=rsa-sha256;
	cv=none;
	b=2KAqY+jaTtyQ5npC/2o3NqRJAJCQ98ynwOMM2y3GvHQTkzrKGWu6wzKd4q2PCWKV7FQsc5
	ERMcKS8gQwwLFfKjImdcX0ItObuyGbEd/OwnX8aD0cvMNdMo/TsfDWcknNDGJ4NhFYF72E
	/YQLax13dAr505t5xX+7jGVKDKzmEl0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 2AB4A42DE4;
	Tue, 20 Jan 2026 18:35:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23C45C19421;
	Tue, 20 Jan 2026 18:35:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768934132;
	bh=5UuViMOKhctbPjtTzY+cSAg4SjcGuC20Kuka59xeaLM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=TXaAldEp6bxXie0YRh1TMKfNcAPUEx+KFCDkPBtoCwDUSKc93CWcWhlEKk1WlmRYW
	 6hw2SnPfGVkECqWVl1OcTViy+DIMqB732m365bSaSIJVALxo2duCYdBLS5C2NKP1Wd
	 FFCBY4FU8Sx7YXbcFyU+dH+xbIEQD4l+h2q5bwp9QLdUvkUM5wds+QWAgdjuPaKnve
	 XGFu+o10G1KWf6+kc/fo1PNZzNDpeQ3BOeNI4vs82YxE5utw0WJ3St3LYB53M8gUZk
	 jDqVrvWWiTV0UstjDqvHgrnleljxubi8Z3sQ/OkovclSYNLvR+sBjq3m3GZPGBnFD/
	 P0r7tp1Yfrlng==
Date: Tue, 20 Jan 2026 20:35:25 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Pratyush Yadav <pratyush@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Alexander Graf <graf@amazon.com>, Jason Miu <jasonmiu@google.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	kexec@lists.infradead.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 3/6] kho: docs: combine concepts and FDT documentation
Message-ID: <aW_K7QZj8HYzA00t@kernel.org>
References: <20260105165839.285270-1-rppt@kernel.org>
 <20260105165839.285270-4-rppt@kernel.org>
 <2vxz7btce06f.fsf@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2vxz7btce06f.fsf@kernel.org>
X-Stat-Signature: ptjqbsudu4uuhs89a9nhaubq5mfodb7w
X-Rspamd-Queue-Id: 6337E1C0009
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1768934133-924353
X-HE-Meta: U2FsdGVkX19b6D0sDre/8sIB7tqqxFv+7yKImyph93alaPkUXlBgdz7elps62Phutlvny3qwbkFlWgsFXYRjRNxxmJQBbyeS9juuOqP0qNdXdJAjiPy9hj4Ce0szer+dUFRwyvcRqfCjs2rUKaY4ADO9ziweMI2jZo0Spb9PyJfzx1o83eMI7QvHlayILvC2jG/tBjniK+Lj+Z0LSPufifHPFYWD+veNFmE4n/UuCspXFGsUsrlogKYNzE12zqQ3TRN/xzIVOlozwFUIHkYTiSGdqOI8TE+nldpY/gcBXhJWP/eH6/RbJG/22Y9FP8xnsX2NNgcscOiOfahcm0FgCwDMJyT8aczhaofk2ek7bek93kyZlaMBXwXiHxConhOOP+1h3t1f1zOym4R1G8J7cT+QYGh8IFNMtM50MtEMedqTtFMHp1Q1jOUqK5O08oE8EZmtnMQdNCUR2uR8lUsU18R/a1ew3njR/ltSmDBZFr4gmKflWPmO1WRWwFe8pFvi5DLvyIaZPg0tDCjRbTljQkB19F/TXCat25+utykt/otvHit6O9EDtc2oUs28MPjUMcyjms/qxd7ksTw7dkmisx49UMh/a/qgvmEDCrj3+eSR4t0DelGEr2iMNmBiGyDXY53UrXRakk2V7408WZqrWvs55SdOJU66H1aJQnTooxoxPCcL/wwcBYLeKkBTB/lvdZ9RQRWdmBbQf0b966mEbpmk443zyxV238nHR8s8dpabilGDMcT1jndnMNEmzbiQuGbT/HP8BO1RR8wwb+UErgbyHGjM8DGRbbncNTyLISdlrPZZ0wFbXmj2kPcJrAw5uo5tXbLAeBRiC1SGrKXMALA19iA7YpMrDczazspbYYu1mwF26q8a2WJDfAY9FkgP3cREQDJWFPRmDcZG+tErmY2VH+8XAfYIPsroDKvUujHL4ECz8ZWqtbsAb96A/JmUmPaN2Wk8RNDdPq7CurW
 eNjQE7qK
 OckJKciD6ulvJCiJn2XMEOpl3Rvdq/DV7ZnaT75yxaS/eAZXyu2tBiZhkYc4KD+19+sU5LnR4FAj1TIEDCFa6M4tzdAgWLFdO/NVxhpfdrdG2jQgDDyZimn15191lYqmxaStQpjPe8ruLatWjQpnX3NxyKZW6dsbFYGacBg30x4MtDegqv7oik2EIyj6oxVQHnV5NG+j6GLbqt+dnu8qG2sP3emTHWDmmNW6+WfkfNi9CmQxx/e0hCH3q3tPbImQI5SDsg5dLKfw8FYwAXxdIjJNNpg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jan 20, 2026 at 04:08:56PM +0000, Pratyush Yadav wrote:
> On Mon, Jan 05 2026, Mike Rapoport wrote:
> 
> > From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
> >
> > Currently index.rst in KHO documentation looks empty and sad as it only
> > contains links to "Kexec Handover Concepts" and "KHO FDT" chapters.
> >
> > Inline contents of these chapters into index.rst to provide a single
> > coherent chapter describing KHO.
> >
> > While on it, drop parts of the KHO FDT description that will be superseded
> > by addition of KHO ABI documentation.
> >
> > Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> [...]
> > diff --git a/Documentation/core-api/kho/index.rst b/Documentation/core-api/kho/index.rst
> > index 0c63b0c5c143..03cd9afbdb2e 100644
> > --- a/Documentation/core-api/kho/index.rst
> > +++ b/Documentation/core-api/kho/index.rst
> > @@ -4,10 +4,73 @@
> >  Kexec Handover Subsystem
> >  ========================
> >  
> > -.. toctree::
> > -   :maxdepth: 1
> > +Overview
> > +========
> 
> I ran a test build and Sphinx complains about:
> 
>     Documentation/admin-guide/mm/kho.rst:10: WARNING: undefined label: 'kho-concepts' [ref.ref]
>     Documentation/admin-guide/mm/kho.rst:31: WARNING: undefined label: 'kho-finalization-phase' [ref.ref]
> 
> I suppose you should add these labels here.

It's already in Andrew's tree:
https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git/commit/?h=mm-nonmm-unstable&id=bc1a060da2a76161ba65f1badc551de15056e398
 
> Otherwise LGTM.
> 
> >  
> > -   concepts
> > -   fdt
> > +Kexec HandOver (KHO) is a mechanism that allows Linux to preserve memory
> > +regions, which could contain serialized system states, across kexec.
> >  
> > -.. only::  subproject and html
> > +KHO uses :ref:`flattened device tree (FDT) <kho_fdt>` to pass information about
> > +the preserved state from pre-exec kernel to post-kexec kernel and :ref:`scratch
> > +memory regions <kho_scratch>` to ensure integrity of the preserved memory.
> > +
> > +.. _kho_fdt:
> > +
> > +KHO FDT
> > +=======
> > +Every KHO kexec carries a KHO specific flattened device tree (FDT) blob that
> > +describes the preserved state. The FDT includes properties describing preserved
> > +memory regions and nodes that hold subsystem specific state.
> > +
> > +The preserved memory regions contain either serialized subsystem states, or
> > +in-memory data that shall not be touched across kexec. After KHO, subsystems
> > +can retrieve and restore the preserved state from KHO FDT.
> > +
> > +Subsystems participating in KHO can define their own format for state
> > +serialization and preservation.
> > +
> > +.. _kho_scratch:
> > +
> > +Scratch Regions
> > +===============
> > +
> > +To boot into kexec, we need to have a physically contiguous memory range that
> > +contains no handed over memory. Kexec then places the target kernel and initrd
> > +into that region. The new kernel exclusively uses this region for memory
> > +allocations before during boot up to the initialization of the page allocator.
> > +
> > +We guarantee that we always have such regions through the scratch regions: On
> > +first boot KHO allocates several physically contiguous memory regions. Since
> > +after kexec these regions will be used by early memory allocations, there is a
> > +scratch region per NUMA node plus a scratch region to satisfy allocations
> > +requests that do not require particular NUMA node assignment.
> > +By default, size of the scratch region is calculated based on amount of memory
> > +allocated during boot. The ``kho_scratch`` kernel command line option may be
> > +used to explicitly define size of the scratch regions.
> > +The scratch regions are declared as CMA when page allocator is initialized so
> > +that their memory can be used during system lifetime. CMA gives us the
> > +guarantee that no handover pages land in that region, because handover pages
> > +must be at a static physical memory location and CMA enforces that only
> > +movable pages can be located inside.
> > +
> > +After KHO kexec, we ignore the ``kho_scratch`` kernel command line option and
> > +instead reuse the exact same region that was originally allocated. This allows
> > +us to recursively execute any amount of KHO kexecs. Because we used this region
> > +for boot memory allocations and as target memory for kexec blobs, some parts
> > +of that memory region may be reserved. These reservations are irrelevant for
> > +the next KHO, because kexec can overwrite even the original kernel.
> > +
> > +KHO finalization phase
> > +======================
> > +
> > +To enable user space based kexec file loader, the kernel needs to be able to
> > +provide the FDT that describes the current kernel's state before
> > +performing the actual kexec. The process of generating that FDT is
> > +called serialization. When the FDT is generated, some properties
> > +of the system may become immutable because they are already written down
> > +in the FDT. That state is called the KHO finalization phase.
> > +
> > +See Also
> > +========
> > +
> > +- :doc:`/admin-guide/mm/kho`
> > diff --git a/Documentation/core-api/liveupdate.rst b/Documentation/core-api/liveupdate.rst
> > index 7960eb15a81f..e2aba13494cf 100644
> > --- a/Documentation/core-api/liveupdate.rst
> > +++ b/Documentation/core-api/liveupdate.rst
> > @@ -58,4 +58,4 @@ See Also
> >  ========
> >  
> >  - :doc:`Live Update uAPI </userspace-api/liveupdate>`
> > -- :doc:`/core-api/kho/concepts`
> >
> > +- :doc:`/core-api/kho/index`
> >
> > diff --git a/Documentation/mm/memfd_preservation.rst b/Documentation/mm/memfd_preservation.rst
> > index 66e0fb6d5ef0..a8a5b476afd3 100644
> > --- a/Documentation/mm/memfd_preservation.rst
> > +++ b/Documentation/mm/memfd_preservation.rst
> > @@ -20,4 +20,4 @@ See Also
> >  ========
> >  
> >  - :doc:`/core-api/liveupdate`
> > -- :doc:`/core-api/kho/concepts`
> >
> > +- :doc:`/core-api/kho/index`
> 
> -- 
> Regards,
> Pratyush Yadav

-- 
Sincerely yours,
Mike.

