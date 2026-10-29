Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B86BE606A322
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 15:03:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=K87jbF3Q
Received: by kanga.kvack.org (Postfix)
	id D20146B05B5; Thu, 29 Oct 2026 11:03:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CF8176B05B6; Thu, 29 Oct 2026 11:03:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C0DD36B05BA; Thu, 29 Oct 2026 11:03:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 9EC716B05B5
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 11:03:43 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 2EE0BA047B
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 15:03:43 +0000 (UTC)
X-FDA: 85375983126.16.C7B7543
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id 6D5E320002
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 15:03:41 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=K87jbF3Q;
	spf=pass (imf13.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793286221;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=c6CEhYs14U8U+JezWPAfQbVngV7jbZT+JjXbmGtNusc=;
	b=huu3CzfmXIVm6zS98mwH0+LViStyt/OEk67BDcOcfxfDfRCGUi+SDfWBw82TBWsZCFzoLM
	vwnHU1IZONZrdqXkv2NhiijXZ92iLAK4KuUIc/dZKKGQR+bX7fRrhMv2y5sKAv1Zz1R1pM
	x8f+sZr6Rluivka7sXxiEGB86SlPT5U=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793286221;
	b=svMLXAHFG2nBI3gCP1GndVcW0WMR7hqij5aaGZRhHZCY52ZR3mDMtscHPIMcRjLAjCDcbT
	ZeTgSBbDf78a7q+SV+lLHEg+Jt736rxui0G4W+vhYuapDRm4FlLMVA1CL3jJzMKs0KUMXF
	m0dxjVw8EoyvCV1RtTWjdYtLdSY/NrI=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=K87jbF3Q;
	spf=pass (imf13.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 04FBA6060E;
	Thu, 29 Oct 2026 15:03:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A3821F01825;
	Thu, 29 Oct 2026 15:03:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793286220;
	bh=c6CEhYs14U8U+JezWPAfQbVngV7jbZT+JjXbmGtNusc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=K87jbF3QgksMsvFlmThw/QGWsaljNclLuymOMt5wEkDnh8/EuqdfHKvslVlKVhA2S
	 eoyjkAX5BvgXvitcfznNi5xc/1kfcK8AInIiJfMi7D8i37m66Slhydl8sbMOmNSkcc
	 LF7jlLR4keBh/OD0Gzc0tBj9s67TsE8uZHxKbFOipg4oNdW4zj35JydofE93ABUEYu
	 SdGyW9vCE4YDt7jxl+uNCLL/6MQLfZvFOOn2VEv5fqTxq8i9/EJdvcYJmgTA2oJ5EZ
	 5WRyxneY/AC/P4kdebYsNu3M0BqstmK0vC/WJ5VDmqMbNnhaHHTZvrSbW5bMZZUvwk
	 8a/Q2Au4OT6Zg==
Date: Thu, 29 Oct 2026 17:03:33 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Kiryl Shutsemau <kas@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>, Michal Hocko <mhocko@suse.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, stable@vger.kernel.org
Subject: Re: [PATCH 0/2] mm/cma: accept memory of CMA areas reserved with
 memblock_reserve()
Message-ID: <auNgRT19droHmv3Y@kernel.org>
References: <20261029-cma-multi-v1-0-2cbced8b5cb7@kernel.org>
 <auM6lKGAeUI26jCj@thinkstation>
 <auM-tYrdV4TJgJ6K@kernel.org>
 <auNE2XEGreHRKoPO@thinkstation>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <auNE2XEGreHRKoPO@thinkstation>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 6D5E320002
X-Stat-Signature: 5yngr7d9ieatgb5djrnar8rgri4169cy
X-Rspam-User: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793286221-599856
X-HE-Meta: U2FsdGVkX1/hIDBo5n+P+8/5MUOE3HtEnekYsWp6r3CiNS2QNK57PLZ3S+yQZTJD0JDgm3Ro8adJbwL9oWRFZnj6W5534MBYHChrKv1QXJzL6G0BlvaCowmrMV0zuJHJCt4ODlvfopfB+574mHm1pJ5skKRdYtq4XsB+SW/PJMv2HMDqiQnWPttdn8TVPI7PFe7fMzzCSrtGT/Tf4ryeL3WL3F9jAEuc8qK/sH5RRxVis4g1K53338jPOOlI08ORKLFIytKLJpbj57t4WevtaKWrN46gfHKm2Q4UpAHtmGuSsKPjiDmvRyQU2s6uScGk6dI0yZS4lzf1saoIM19N9skmUnKO4ijQ7IsZmUwgHgTN3XAr8AppCAtR9plf05apPo74WpQETad2y6fj71g+JOelrBJxdLIHoPaRFUnuZYf7JFkAwQtzTqyVOqZHyeXhdu7dmNz57GE2PrYZRRlq8QbizcMPMwRPQnRpbIRep1Z9hIoYZjGFuj3QZoI3RoAVRdfFmIW0MKWfAOoUDh7aSYUuuZpzbaw6pM61S/tGcogSW2duWnQCiKCb9faijVc+5x/rDUieuh/0PCIZCqqzQTw7UyZ3U1etQjx/x4MX5NyK+F0e+J37kwZxrzthO+OhbvCow+u52TB2DYuJLj8+G3zTJhYeJdiuQtvB4fsthjNnwsh5YnulwbuMjOPOe0QoF0TQeslTN56W80mpY7QUKuECTjrajyAhZcobO7dk2RJnGqDQHpCkyPRbzbCd54cZKTfWy8xaj7YS7e5B+KSSzIHbgDQXrfVuY6hBpWcMyqthm6q5Fs3MR3cD4myZEayeJUeqz/rTcqcP6eLhEuplNKkCKAH3x5jSwxwSDDWCxGTGPmIWkK4omHb1Wx1y8AHky5cagyB0U8onynNUmeMcvS1yEI70GfydZXZLsNoin8P67Opu/4aRsA5UYelCS0rPXc748XJSYff3tyKE6dM
 UPV07Zai
 Y8Z496cbWn40NhHAl7yh/Oyw7E1qkXz/35zj9vL8LZzP2a/E833JICzSDlHMX25CpKjraFFnuj6aGbhCu4MisLbpCecS8HFR95jzR5yD8FPdVk5gaFhaxE6W0RrDh40HQvYj623gsi2Bi+3qTxxAGhtQFhg5p8JI+hyq+gRbQDXVW5nxmM1u8DDo3f8FuJV2SvRIXCi5lSmHJ1nyjQgRo0HLLOyqWbxDXQ6E5wfCYonPuwaSpnYc3CJrnUQ1lr3eDctIfpnYjtVx8Y1Nt8+jda6htEFOxT2bj5nqqyK2C+ZSUPRk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Oct 29, 2026 at 01:17:06PM +0000, Kiryl Shutsemau wrote:
> On Thu, Oct 29, 2026 at 02:40:21PM +0200, Mike Rapoport wrote:
> > On Thu, Oct 29, 2026 at 12:27:23PM +0000, Kiryl Shutsemau wrote:
> > > On Thu, Oct 29, 2026 at 12:18:36PM +0200, Mike Rapoport (Microsoft) wrote:
> > > > Pages of allocated CMA areas are released to the buddy allocator with
> > > > __free_pages(), which does not check for unaccepted memory.
> > > > 
> > > > This usually works because memblock accepts the memory it allocates.
> > > > 
> > > > However, multi-range CMA areas, used by hugetlb_cma, and fixed CMA areas
> > > > requested with cma=<size>@<base> are reserved with memblock_reserve() and
> > > > their memory is never accepted.
> > > 
> > > It feels like memblock_reserve() abuse, no?
> > > 
> > > crashkernel=size@base already uses memblock_phys_alloc_range() for this.
> > > Should the fixed and multi-range CMA paths go through the allocation API
> > > as well.
> > 
> > Fixed path already has the range, why would it use allocation APIs?
> 
> Having the range doesn't make it a reservation. Both paths take free
> memory for the kernel's use, which is an allocation, and an allocation
> has to be accepted. memblock_reserve() is for memory that is already in
> use: kernel image, initrd, firmware tables. Using it for allocations
> leaves acceptance to every caller, and both CMA paths missed it.

memblock_reserve() predates any allocation APIs and it is used to say "I
know this memory is free, I'm taking it". So memory acceptance should have
take it into account.

> If memblock_phys_alloc_range() is the wrong tool, let's add a
> memblock_*alloc*() helper that takes the exact range and does the reserve
> plus memblock_prep_allocation(), the way memblock_alloc_hugetlb() finishes
> its own search. There is no search, so the multi-range path doesn't get
> slower, and accept_memory() stays inside memblock.

A new helper that does reserve and accept makes sense, but let's do it on
top and also audit other callers of memblock_reserve(). I believe we may
also hit some curious corner cases with memmap=, although this is less
likely.

These two are really simple and easily backportable and I don't see an
issue with calling accept_memory in low level cma code.

cma_declare_contiguous_multi() has other issues and I'm reworking it right
now. But again, that does not mean a simple addition of accept_memory to
CMA contradicts it.
 
> -- 
>   Kiryl Shutsemau / Kirill A. Shutemov

-- 
Sincerely yours,
Mike.

