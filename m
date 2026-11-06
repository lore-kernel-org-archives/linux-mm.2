Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D2B25606A32D
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 05:18:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=q0ovCD7x
Received: by kanga.kvack.org (Postfix)
	id BB9796B05B0; Fri,  6 Nov 2026 00:18:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B6A366B05B1; Fri,  6 Nov 2026 00:18:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A80286B05B2; Fri,  6 Nov 2026 00:18:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 7C68B6B05B0
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 00:18:24 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E8890120C6A
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 05:18:23 +0000 (UTC)
X-FDA: 85403538486.20.EA14E9A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id 15A3680002
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 05:18:21 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=q0ovCD7x;
	spf=pass (imf30.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793942302;
	b=FGjbPx5Qb7VRJAL9eMPJRoLq60anAIIgOz0fYF1sGquupa8hXexueu6fPK/GNIYvj4u3al
	7XbxID32a6ARGVN5QPm/PfdLgh5DtN6sRk1Ovz6VgmbmiR9pPzwR8MDeTtT8G5mvNwT1cY
	6eMonOSBiL4kilbbWmpwCGM8/endrAs=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=q0ovCD7x;
	spf=pass (imf30.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793942302;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=w/aL1sjxZAD4jPRBmObfPh4EoB+Er0nYqQkFKEvP8dI=;
	b=36b5Ruj1AiW/zhpdZMRgKEhrrqRJW3E+LdvUQhqWBtBEBaH79W2U+Z3ofFBcjnR/li75gI
	I/xN9B9f72PNxqXUT8qmQT8a4xssF56i3NgiJXUv5PnJv03EERarybpxqigyP2+HZnK5Xt
	3oqFFufDnh1/hWNKdJYpf/FJAs4HpC8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1E62443CC8;
	Fri,  6 Nov 2026 05:18:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A8BD1F0089F;
	Fri,  6 Nov 2026 05:18:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793942301;
	bh=w/aL1sjxZAD4jPRBmObfPh4EoB+Er0nYqQkFKEvP8dI=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=q0ovCD7xIiR0+ANf/raivI4OhRAQOY6dX6Pc57lH4HPcSvDIuQJ3knVapFQmGtx5L
	 RcTkRAX3SqUxY4Q6SCFu12gdGRAQ88bWqEZUPiRcnOFZFeJ928jqdsddLogK7ZrlCA
	 85oG4mh8tHfOEMRS42hc30LZfmiSJv2AgWPj1LD0=
Date: Thu, 5 Nov 2026 21:18:19 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Konstantin Khorenko <khorenko@virtuozzo.com>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R. Howlett"
 <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>, Ryan Roberts
 <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song
 <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, Usama Arif
 <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, Peter Xu
 <peterx@redhat.com>, Alex Williamson <alex@shazbot.org>,
 kvm@vger.kernel.org, =?ISO-8859-1?Q?Lo=EFc?= Molinari
 <loic.molinari@collabora.com>, Lorenzo Stoakes <ljs@kernel.org>, Shuah Khan
 <shuah@kernel.org>, linux-kselftest@vger.kernel.org,
 dri-devel@lists.freedesktop.org, Madhavan Srinivasan <maddy@linux.ibm.com>,
 "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
 linuxppc-dev@lists.ozlabs.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Jason Gunthorpe <jgg@ziepe.ca>,
 stable@vger.kernel.org, Sashiko <sashiko-bot@kernel.org>
Subject: Re: [PATCH v5 0/4] mm/huge_memory: copy PMDs at fork like the PTE
 path does
Message-Id: <20261105211819.2a6a349b2edc077784ca52f9@linux-foundation.org>
In-Reply-To: <20261104-b4-prep-vstor-149847-copy_huge_pmd-recheck-special-pmd-v5-0-c56d0d26f970@virtuozzo.com>
References: <20261104-b4-prep-vstor-149847-copy_huge_pmd-recheck-special-pmd-v5-0-c56d0d26f970@virtuozzo.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: suj6q3cr179s9zk9ugcgapq1a78uun6w
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 15A3680002
X-Spam-Status: No, score=-7.5 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793942301-516106
X-HE-Meta: U2FsdGVkX1+EbfRkqS1GL2MmlcwM4hCIS72JEayto04bwr77WzRtWO5RfE8oSNK4nl/YFEwShF3NRegb79NcNIAAyetQLxTdKgzvdXzwkuidc/dFer1RJbB3bpvSXl453D9+9rbztlRUiUQ20mqsXlYudtjOxNBzeaEmMQAlYlJl3yFbgDGxkmCp8Iq3rZqUgY9LTsffFQfmrlMwBMmuayUjRt9kHSW5SUV1Bsny+3J2zFDhejJIvCd7zLz9osqemWUCvR1MB/70rVSyfSwaMZaHsYgyfZdFUjDvcnG+EA/xIcaL1NiRrPhvARAqggQvXfijbE6qf6bPWehEUSk06Myhpp/qRd6cpdMc0bvNcirxpSiVpVnbMP8Cqbuq/zPAjq+tJWZWsEgQoNrZs2I44sTu0ceZ1OMHAlE4hGgo9YA9SodF5lcb3AHxOfRiltm1Wa9WUzOesInv9XoPP552YD3dkLMpEVeexa8Ud/9P5xQWBuKXp9ORUeXIP086lBZEXvn9TPGz3DCzqWtbHIjnc0v87UTm46LnPETMRrbAdwoH7TzytyLuO3mVhgJWU4qj3A8TGY7PNsxmFqamZMDOHCz4SP/oZsaUIsjRm2qeFEXL7RvgiLeoa++c0+MYNy9jQDhPC356rtsE1YO8qdGqvch1UmxDeNykCSlwyHd8ZQhMx6YZOSYr+v/IOroER3z4nUYm39PPv9H2jdIRY/R+eYBN9Id4lcB0v24rng4Ujh1cnKzmxVMhbBhlTP9zm8OnIn2MZa4mrS164nN/G8dnPMroQKT7o19c7k5E206qw+432YowmTsGyiMeMApgAL9ONX3JoWgxHgkXKh6lTCYyA+G/cgHii979U2I0rVRkDYLTCD3TAp/QBh9RaHpY8BCVo9vyst2HjPscuMPDOvsud23Sfc+BHPOmHmAAOTaqmjzHH1Ml/tJhRvhXOKlgG72Ji3Xm7Hzsl/wLr7TnCLM
 ce5Bgw6e
 U/jEg7pUfMYW6e99lkfHJopYscgjPqPr5qRh6uozqfnIurudmsNEcTq6Zdh1uILEf9MAhXyZRyUYFOqVNZbmbjNqpEkhREHgfQEVKrxaGeTV4HnkUX7/ue5DI6CiNvdxf8+3CsILb0d+rvtd4dG6Es9zDsnkX0P6MqHCqje8yeCQkBosdHYgnrMszfoZctbcNe7RQFB+R8VddQmnjZ+SDqpzoJ1lWLJtv6wai7EVYF+J7vRv7m8RMfVQsu35QPo9urO5asAYpKkkaTg83RKoMnnI2cGf+4VNfSqEMcg1F9Xg+nZc9fh47USAACxK069L6A9IvKwkCrMj5xSF3Q5ZlG4VBdYrJy4zIT7lm9zfXIueTA5V/p/8ccRVne2VNWK9/S9oVyNAwq8HMrV1NwSMSmI2pwlE2orw7bGW29xSeVZA+VFXIi3rCik6YVA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, 04 Nov 2026 21:40:54 +0100 Konstantin Khorenko <khorenko@virtuozzo.com> wrote:

> copy_huge_pmd() decides what to copy at fork by its own rules, apart
> from copy_present_ptes(): a lockless check for special PMDs, and a skip
> of every file THP. Following David's review of v3, this series makes it
> decide the way the PTE path does, under the page table lock, with
> vm_normal_page_pmd(). That fixes the two bugs v1-v3 were about. The
> patches:
> 
> 1. folio_dup_file_rmap_pmd() duplicated a PMD mapping as HPAGE_PMD_NR
>    PTE mappings. It had no caller until patch 2.
> 2. File THPs are copied at fork instead of being refaulted by the
>    child, as their PTEs would be.
> 3. The special-PMD read moves under the lock. That closes the race with
>    a driver zap (vfio-pci, panthor) and the missing page table deposit
>    on ppc64 hash that Sashiko found in v1.
> 4. A selftest for 1 and 2.
> 
> ...
> 
> Cost
> ====
> 
> fork() now copies file THPs instead of leaving them to a refault, which
> costs fork() a reference, an rmap update and a counter per huge PMD and
> saves the child a fault per huge PMD it touches. fork() of a process
> with 4 GB of shmem THPs mapped MAP_PRIVATE and an anon_vma on the VMA,
> medians of 2000 forks:
> 
>   +-----------------------+------------+-------------------------+
>   | kernel                | fork()     | fork(), child reads all |
>   +-----------------------+------------+-------------------------+
>   | 7.3-rc7               | 86-129 us  | 2380-2620 us            |
>   | 7.3-rc7 + this series | 230-355 us | 820-930 us              |
>   +-----------------------+------------+-------------------------+

The second column assumes that the child touches all the file THPs,
yes?  If the child touches only a small proportion of those mappings,
or just does fork+exec, that changes the "Cost" comparison?

And on ppc64 hash-mode setups this also allocates deposited page tables
for mappings which the child might never touch?  So a modest increase
in memory use is to be expected?  I can't say I care about this
(sorry!).

But I worry that this change is not an overall win for thp-file
mappings, which are the common case.

I'm not understanding why we need to mess with thp-file behavior at all
in order to address a special-PMD bug?

> Notes
> =====
> 
> - drm_gem_shmem and mshv_vtl map special PMDs with
>   vmf_insert_pfn_pmd() as well.
> - copy_huge_pud() still differs from the PMD tail in that it does not
>   mark a shared PUD clean in the child or handle uffd bits.
>
> ...
>
> Reproducer.

Changelog is soooo long.  I replaced this Reproducer section with simply

	- A reproducer is at the Link;

So interested people can still find it.


Anyway, bugfixes come first so I'll fix the selftest pmd_psize thing
and I'll toss this onto the pile, thanks.


I'm attempting to runtime test this on local LLM-driven live kernel
test setup, but it keeps on kicking me out and calling me a
cybercriminal.  Sigh.  Giving up.


