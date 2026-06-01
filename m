Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6CDD4CD6E57
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 15:01:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3D2FB6B03FD; Mon,  1 Jun 2026 11:01:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3A9D86B03FF; Mon,  1 Jun 2026 11:01:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 299876B0400; Mon,  1 Jun 2026 11:01:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 10C376B03FD
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 11:01:05 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id CD046A03B8
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 15:01:04 +0000 (UTC)
X-FDA: 84831656448.11.4EB7660
Received: from mail-yw1-f176.google.com (mail-yw1-f176.google.com [209.85.128.176])
	by imf07.hostedemail.com (Postfix) with ESMTP id 9FE534001E
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 15:01:02 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=IceOY7uP;
	spf=pass (imf07.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.128.176 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780326062;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YjouT4r9OqoZMrQ0tTNPIpsZn3OGl8wc9VmtokceP+I=;
	b=h+HdNM3n2YxhtpymP2gAI5CKGOgWMdsD2boaFldisl+DS1lIw0RXKTXLzj6oAGfFXYv30S
	2YcWWbjMSsgK/pNPxiLAnbeAFi0WcK7GqsRUS6TiMd4upudgNR6Nx36XNDjUN4HyZbl4b9
	1ijG/geOnKkNDvTaLGYXrXtrgfK1j+4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780326062;
	b=fPF7nqgNaL7/44E85NpmyygAZ9ovar++qZUO1AimzwxxoDMpIzvXuGYtCk67anWdZ14kNP
	T5VPG2+JGA2lWNukTcvV9JtQZrqv7c5r/jq1s33xo9sT0U/WK3aNV7JQ+DAM3sHdq3ld0h
	or+3RDtBSqbrsVtlRaLExddilEFeTL8=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=IceOY7uP;
	spf=pass (imf07.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.128.176 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
Received: by mail-yw1-f176.google.com with SMTP id 00721157ae682-7e1916922b9so17561107b3.1
        for <linux-mm@kvack.org>; Mon, 01 Jun 2026 08:01:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1780326061; x=1780930861; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=YjouT4r9OqoZMrQ0tTNPIpsZn3OGl8wc9VmtokceP+I=;
        b=IceOY7uPbszYc+6VE1f8ppWprRyLHCOut4UbeB9WR/72G5gM2x1nZIcCLTnfkQN1PY
         uTD5f61TbPoC6ZC15RT57KThORoZnLIfZZjh9tYrFRR5qV51rP1KWxjYiDGxIJWT59Up
         8n6ocyvYjTcRZwGxRsnYhrhmSRdLlnDh0SFGYuUTaDZ5W6u7ama71jce+Ns8PK//puxe
         u86gxl6alUh9G23T/+u2+1+PBMafo/68nfC1wS1j/rRWBsOGa60GxKIs4l51f+iZawjl
         iJJ0uw0Q/sgxFHN7v5eyj9FOzu9kvjdgKwD8pNhVeUEGS048jgQYUVLRh612O1uIwSZA
         BO/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780326061; x=1780930861;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YjouT4r9OqoZMrQ0tTNPIpsZn3OGl8wc9VmtokceP+I=;
        b=coSADIC06kRsShvL6B4yb5fuvOw5tifuSnyVXMUr51ZsR/Lad/5jUh6fEOk2qAqptJ
         QyoJ8p+oASjuEytK2wBvqW7EZBKq7A9OMn9Cc7WRlzcYufjiiqPno46NumqpY93fXQQb
         X8OURXRIQJwH4YNsF/XN5RpzDhALAxUUUzn7F3pcFhtEG+LIzdJAlkfJQ63oOl4WyZoc
         RLSr0aTnyaFcMpSKKiNgUp2cz3Jdff5XfROmezTGBDTnR4xgJreJ4xL4fxOCck69p+gL
         TjP91CN/NwKrrFG9kJ5HO2DNrNBGCbZAENuF2ufca82Uh7qw1FEIIopYJD8QxX2NuEMY
         LA2A==
X-Forwarded-Encrypted: i=1; AFNElJ87Bn4sDxr1X0PTMaa80uKvyP+gGvsfO4AtBUk7V0NvSTBd1w3pjCj915w0Ld157euSZa2tEhRXGw==@kvack.org
X-Gm-Message-State: AOJu0YzO6odbreqWq+1fxdRmu0JSoefAH0Xvcgph+nwQYsmk9oxOjPwj
	PyZimlr8O8MX9KDT2uwOP3YuZBhKLQcptHgCAdzNzgMiGD/OrVmbNdaWOtc7Cdqv3kU=
X-Gm-Gg: Acq92OEJFCr+RSp7FrK9H4tNGllztEyXnp8Q+mtWuCYX9Yu1jcDQ9cw/68I3X6hgXgf
	a7wXaPfUP5l7OtRXbMzs/bfQNEZbLnFnHkmF9DyKPhaR45c4KYz2+5QE9RNXGwft3vPplSSvZ9w
	VygkFgyqY5Ll858HsqHpLaH0y8NWwJ98cCdfujkCQPbCF3WI7O4NJME/KcRcg/WVNFGUbsrq+b9
	d83JsEe9OBa2hnxBa980h3OBYfK9mpljCLlDpUdKt+7VVG0a1/NycUSsC4nsziKRoIk2ZLQQZ3h
	XMuzbBF4kKOLcqGK56oXQ/M9WLZGrhRY7hY2nwyHAyn2CP2h1h/HMf9aINBNEiZPIAULklwySnK
	4Iak8N7kly7500ZUjVAycwMhQpW2GQ1X21ciRmE/BtLx5tNYGq7vP5LZUosIDEybCmafSvF+V+q
	hmLbKGMud5WrNwa/pnp8eMNI9a02G8zjnF7Qbp2RhqzZtFGCB7Y0CeyVOyNDqI1E9SQAIpRgrVG
	TYsUa4YvUzQEf+Blg6358SZX9nosBIxRBMOvApw8o+NuC1xtBug6w==
X-Received: by 2002:a05:690c:88b:b0:7a2:3d38:337c with SMTP id 00721157ae682-7e05d5e4ec2mr97204177b3.32.1780326061363;
        Mon, 01 Jun 2026 08:01:01 -0700 (PDT)
Received: from google.com (138.200.150.34.bc.googleusercontent.com. [34.150.200.138])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-7e175de02fdsm41868227b3.7.2026.06.01.08.00.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Jun 2026 08:01:00 -0700 (PDT)
Date: Mon, 1 Jun 2026 11:00:59 -0400
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: Mike Rapoport <rppt@kernel.org>
Cc: Jork Loeser <jloeser@linux.microsoft.com>, 
	linux-hyperv@vger.kernel.org, linux-mm@kvack.org, kexec@lists.infradead.org, 
	"K. Y. Srinivasan" <kys@microsoft.com>, Haiyang Zhang <haiyangz@microsoft.com>, 
	Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>, Long Li <longli@microsoft.com>, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, Pratyush Yadav <pratyush@kernel.org>, 
	Alexander Graf <graf@amazon.com>, Jason Miu <jasonmiu@google.com>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, Baoquan He <bhe@redhat.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, Thomas Gleixner <tglx@kernel.org>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>, Kees Cook <kees@kernel.org>, 
	Ran Xiaokai <ran.xiaokai@zte.com.cn>, Justinien Bouron <jbouron@amazon.com>, 
	Sourabh Jain <sourabhjain@linux.ibm.com>, Pingfan Liu <piliu@redhat.com>, 
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>, Mario Limonciello <mario.limonciello@amd.com>, 
	linux-arm-kernel@lists.infradead.org, x86@kernel.org, linux-kernel@vger.kernel.org, 
	Michael Kelley <mhklinux@outlook.com>
Subject: Re: [RFC PATCH 00/20] mshv: enable kexec with Hyper-V donated pages
 and partitions
Message-ID: <ah2eBxaBnVs_1j5n@google.com>
References: <20260528004204.1484584-1-jloeser@linux.microsoft.com>
 <ahxrc4pTvVU20RTX@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ahxrc4pTvVU20RTX@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 9FE534001E
X-Stat-Signature: dedkt7i3omqmg545o6665993r7749h4z
X-HE-Tag: 1780326062-544372
X-HE-Meta: U2FsdGVkX1+hhHXYtsiEfTzrezwbMrdGRtK9Pe6SL73g7DCT9Hq4lzRIQ8+GsnYt7PWFjFyf6aIIEWtqhmYd0/UorGdqWf5I4W6bWKbk8faCfZYZGq7LjQbyPx21C3WVDoyNBj+Z/uaD847HCK32AiACNh5C4lku+hgOZUO+N2zMmEhLsb14amVkIxx8e5LRlTtY6hV7AN6GCzwEOu/ENmwDjNiGTpmnotWtstKP6BqbOjUOvkwmo5fvrqA+vj7APfZOGd1ZgT+uxMF/a01jHDA4EsUF/f6d01wmZT1pg1R+RV92a/+pzCYh5DLQ/3a3SbPHOomAAmJJ/evlw6Q67K0pdPV85v48YeVaDwqftJjgMml7z8my/XFdq4SFXIBsfe9gCa2hRsFwQbo0PbO1Dto/1F6fMdOzqY3+E23k1khEigRKRQQdrlDDOgQZ8wnJjvl+hQeMK5GGHClJWx+nI2HHo9filIafuX5Ig37wtzhxo/lMxFOSW2tuPAV86dLUO37sQ7Jt5p6wxgxoJqH0jgcgvbb3+fG15KFkE6WIaQYmlgQn2RoxLOidI5F7bsOezboPxbp+ndOspBFwCKTNV1Z/F8GdAn5xO27O6riN/MHu1FewN3kHY15PFREXle+2/MzBWzeCxONLQu3pLNZ5IzeMoerot/fyOrpKZeqvbN+77yyJaBTav+MEb0KynpyErovfB7MD5S5adc5s1XohlxZOMgXQC3NeHZdchvobxRf7Hmrs3iMzbZ5OEHL2Av17OycCsd/zRFN/25T4c7aDo4YSGq7fhpk6X3eqwCGqm4vvgNKxNrYBF5Mg6MAf343pUZ3vlG6Zhgavd2HIotI4sc3TX/aqqE5eGlwzLzw16MdM6zVJzRyQk5fcXwkrR/eOdniA9nGOVS5m1+YdyjlvFlQrvH+QpalFh9kPT+QPm/ZF4/XMJsCIEVpWctxhvL7vbJy6rpitBfJF+DWuBV5
 jDwgvxnY
 16U1JH4LfWcz2Frca110gynIWY67TynVrpiXZfntsNaoq74au7odZwnQHuZLx6225pqapxAAbajpG27ipnQkRoAgLvyS8dDjAST3tcTqSyVL2S1fytEqts8U9eOoVMXH55yL1i75fk0momXUo1QbS+xahNck7f3EiSg72AJV8rQKK/zHmwvEHG6iryXkT4E8huMqaaAPFxln+U9knsI7IAX6jo690QIq94dJXrbqdUSoQWFXrhelM9R8DgHCohlW1uwMaKbDBmMjHqt+dG/ZirwWQr72e6PuJfQ7kh4T8+xhgkhMMgjIRQOGpb+kC02JJ729jLz+ZoJn0Fh2jiH76Se29l4XLzXOVHi1m+mfHbEV+O6NgR3P1gDlb+w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 05-31 20:10, Mike Rapoport wrote:
> Hi Jork,
> 
> Only had time to skim through the patches.
> I have a couple of high level questions for now.
> 
> On Wed, May 27, 2026 at 05:41:42PM -0700, Jork Loeser wrote:
> > When Linux runs as an L1 Virtual Host (L1VH) under Hyper-V, the MSHV
> > root partition driver deposits pages to the hypervisor and creates
> > partitions for guest VMs. Prior patches enabled kexec for L1VH, but
> > only when no partitions had been created and no memory had been donated.
> > 
> > This series lifts that limitation. It uses KHO (Kexec Handover) to:
> > 
> >  - Track all pages deposited to the hypervisor in a KHO radix tree
> >    and preserve them across kexec so the new kernel knows which pages
> >    are owned by the hypervisor.
> > 
> >  - Freeze running partitions before kexec, record their IDs in the
> >    KHO FDT, and vacuum (tear down + reclaim memory) stale partitions
> >    after kexec.
> > 
> >  - In case of a crash, exclude hypervisor-owned pages from crash
> >    dump collection by passing the radix tree root PA via Hyper-V
> >    crash MSR P2 to the crash kernel.
> > 
> > Dependency on Pratyush's KHO series
> > ===================================
> > 
> > Patches 1-12 are cherry-picked from Pratyush Yadav's v1 series
> > "kho: make boot time huge page allocation work nicely with KHO" [1],
> > which is still under discussion. This series uses functionality from
> > those patches -- specifically the meta-data page enumeration via table
> > callbacks and the restructured radix tree API. It also extends the
> > KHO radix tree with:
> > 
> >  - A freeze mechanism to lock the tree before serializing for kexec
> >    (patch 13).
> 
> There were a lot of effort to make KHO stateless and drop the requirement
> for finalization/freeze.

Yes, using KHO directly here is incorrect. The state machine is provided 
by LUO, so we should use LUO here. MSHV should provide a file that 
userspace adds to LUO, and all state machine management would be the 
same as for all other clients participating in LU.

> 
> Why is this necessary to add a freeze mechanism to kho_radix_tree?
> If it's a hard requirement of mshv maybe the freeze part should be handled
> there?
j  
> >  - A crash-kernel-safe variant that memremaps radix nodes for use
> >    outside the direct map (patch 14).
> > 
> > Patch overview
> > ==============
> > 
> > Patches 1-12:  KHO radix tree and memblock changes (from [1])
> > Patch 13:      Radix tree freeze and del_key() error reporting
> 
> del_key() error reporting sounds like something we'd want to avoid.
> del_key() is called on "freeing" path and during error handling, it would
> be hard if at all possible to deal with errors from del_key().
> 
> > Patch 14:      Crash-kernel-safe radix tree presence check
> > Patch 15:      Page tracker using KHO radix tree for deposited pages
> > Patch 16:      Debugfs interface for page tracker
> > Patches 17-18: Crash MSR reshuffling + crash dump page exclusion
> > Patch 19:      Export kexec_in_progress for modules
> 
> Isn't there another way to differentiate kexec reboot?
> 
> > Patch 20:      Freeze and vacuum partitions across kexec
> > 
> > Feedback
> > ========
> > 
> > This is an RFC. I am looking for feedback on the overall approach as
> > well as the KHO changes (patches 13-14).
> > 
> > [1] https://lore.kernel.org/linux-mm/20260429133928.850721-1-pratyush@kernel.org/
> > 
> > Based-on: linux-next/master (next-20260527)
> 
> -- 
> Sincerely yours,
> Mike.

