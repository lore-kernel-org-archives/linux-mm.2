Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 18B37CA9ED1
	for <linux-mm@archiver.kernel.org>; Mon, 12 Oct 2026 17:11:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D95BD6B0092; Mon, 12 Oct 2026 13:11:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D47066B0095; Mon, 12 Oct 2026 13:11:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C5CA36B0096; Mon, 12 Oct 2026 13:11:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 9962F6B0092
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 13:11:26 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 284AEC11E9
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 17:11:26 +0000 (UTC)
X-FDA: 85314615372.11.EFB9FEA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id 8D053140008
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 17:11:24 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=i9yb8Aru;
	spf=pass (imf09.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791825084;
	b=sEnIzPUHgdojtMbLsYOiNRQ6hs2RO7NRfbgZULmKoom64puBF+Ja1WiLyACSb79L/FLxO/
	Vd3wCJgIV+yIZvJR19R80vtnv4MwX330hsUAtnCpwLNcoailxOcSZyObz9sYRlqxXHo8UN
	aO5XydYONJ6oNQ43+dh9wT3TKhF5Rwc=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=i9yb8Aru;
	spf=pass (imf09.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791825084;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eIpXBxc1Zh+5tYOYTOcIg/Ba6/+mSunX8M4pzhxilnw=;
	b=om0UpDgCkdkqxOeguP80Jtkm53Sgcz4LR0i5rgVRd/BqBorXAaapjvzDPL411Ncl9h2sj2
	0HJcYOAXthSkWtVH/r8P53/NWDTIthdmVXybL838FBckBLBmMZNyWz5+cWhER2co3PTLGl
	zkfwXExBpjFPQbNyF8j815SI6AzCsZw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 17BFE601F1;
	Mon, 12 Oct 2026 17:11:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 452741F0089C;
	Mon, 12 Oct 2026 17:11:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791825082;
	bh=eIpXBxc1Zh+5tYOYTOcIg/Ba6/+mSunX8M4pzhxilnw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=i9yb8AruVWhFnaBylkZ3cCIq17GgdHNPTtRN/iIoerfLgW5ZLo57/VPpwKXuTXpX9
	 Rxqv6XA8bqubOEVIZ66EY4jsNKQP6dsMn5011o4a9WCImjqbGvlBj4xK5AaVrf9Dw5
	 L4ZbFwjbTLxhk9coLPjuPVFKyMMLSNCGbA+zXpkbdeW5YeRe7GVGiArf1Sad+EA5dw
	 N1gI/wrGWHCZFNKNzRFGKqQkuyrK80Fu14ktFl9La2Bv5kRdsKUQQOoSps/8oaxzWn
	 COJjN6dXrswLvINJaSw35/yg/vS+E9oOkIE58zsgJLAGfsPBYTdfctD/24yKKPFym2
	 WN/sATU+rv9bw==
Date: Mon, 12 Oct 2026 20:11:10 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Pratyush Yadav <pratyush@kernel.org>
Cc: Sourabh Jain <sourabhjain@linux.ibm.com>, kexec@lists.infradead.org,
	Alexander Graf <graf@amazon.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	George Guo <guodongtai@kylinos.cn>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] kho: fix global scratch size calculation
Message-ID: <as0UrrAvqjvUPyQx@kernel.org>
References: <20260922131217.698809-1-sourabhjain@linux.ibm.com>
 <asC3-4WNiTF3n7l1@kernel.org>
 <2vxzo6czjaa9.fsf@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2vxzo6czjaa9.fsf@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 8D053140008
X-Stat-Signature: du33tbas9qau6ijbnmk4h69m55fj3bmy
X-HE-Tag: 1791825084-474584
X-HE-Meta: U2FsdGVkX1/0bp9535ZqhfuGE8P2FQ5DlXE9vhY8vcLI6yoaqxJlTg5HQwtNELkUk9ftOrLdmCByRdy563vrojNKhtpP0xeXQdq/xZx1nmNj2iCz6cv7i9xwQu+GZEP8XzP7UcNDPgCuV9V1XRoBbWASgPmchSs/Jt5cK8lF0GnxLDIISaI8WNUmK3h9reXp/IHt3ulVwhQcx50YcM0zdlbmB0SmTMrFEZ4kUQ71JU4OfhGCxs4I11ZiEEzL19gGjiRFo4sGU6K4sivWImcJK83zr/jEuoX47lXdz6QU/mNJ5KHvurfpa5W8T+oDp4h9SoGomjllbglTBjxq5CFIMbslSSiAold371NsjT1mSnXrwjSlrSOfnGs/f/OFPmeQmwHQ000jvmNh0sDQeRSsIh+Y7t5ppohBkGoXsYcSFyRBXlf4Ro9QtwRH9GOR/1jwAM97jdkndrM8fMrjRij1DtEDVqlgK7RoI6UiwVQO+aPUar4s4AZY3zF4qbYi4oB/P87dlj9VxuJlUUbH0FqV5fYONY8ydWXv4LFxx2ti2ae2UI7IOii4VJW2SEU5Lr6INhUu792Ltyu9cGse6VPfzyfFYfmtC6IktMC9tgG/YqLxwg4nlvX+4NH42eCcoz3Vl8xz6akVDW8tzeYYPhJWbRcrwl0orR6/M4np0d0rev+noEIdwXmJ3IjHLsWb/g0nUxWFwOiNODCB2S8oXYpXlduUytKTAUCq+/nTiPYaokokBFthVcKU/G4xP0dRjXwFxBWkRgtBMV0UW+RvpvqroGzheBOKsw+v5bog3tFBmTSmI/V4sEGTCaArHE7tTGKhKxssZw1v8Ep4ZELDQ3Nhk7+nd223Z5aptaiZrh1b6KcuLdU1fIEJYRerBgn4O51UtqyWR3aOaiSbbCSVIMaykQdejdYhEgj8i/TOozAlE/jEhleeEFVgzJTT9bPTbMaT1h6K0igcCwHtLY4Zr0G
 G/LUi7so
 aGZWbB3hYQ76fymRIPfkIqHIHs86uYKUkQPnMYjazke+t05DMWMIL8esjzwo3iWSPNQmZSr15EX0zC0Jc6Z6Hlij7IeirkEetjbhcLN8NN/DYKqpqsQs/B9Z82lIoa9cTY25THwBiit48A6tOYMWwcJmPbZn2ihL/feK8xVbD2dQK0TnOq5byhbMIMkc7+iOjn2whXKNZUSb5qYbfPrCk9eSBloyYonYnD6okCOoh88/ria1J9KtZ8lnY6ThT2WxBHVP80vQ3fBjcOPZR3d1QGckdsLUaKgJ99HUoti90rlHGFij8hBCCqCysmPnT89nzIiQAC+4vRGRp8BdgppD0VikwrlwUqALbtA/aigfhP1KGFeg1hTE8khWr+lglCNv5derGgiuuYxfwQEAoObCk2awME4keXCzWQSs9uCPqmv5hBuoDhxoXags6vp54wxfLmkwFEXeS0YhPL3ixYzYOqVIsOf8c8owQ/mXtIVU/ZnGGtiW61oRPC0viD/bDoPf0FiQ4hOIjpV1qlSanZWJKCpxzqaorSZ+QSOW+7gQtL6b8qEeFwUjF9sR78zOCLXxLHoDRhgp5ngUsjIFmuJ7+m3GY3SVbBvXxKumy
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Oct 12, 2026 at 03:52:46PM +0200, Pratyush Yadav wrote:
> On Sat, Oct 03 2026, Mike Rapoport wrote:
> 
> > On Tue, Sep 22, 2026 at 06:42:16PM +0530, Sourabh Jain wrote:
> >> KHO calculates the global scratch size based on memblock-reserved kernel
> >> memory. It passes NUMA_NO_NODE to memblock_reserved_kern_size() for
> >> this calculation.
> >> 
> >> When memblock_reserved_kern_size() is called with NUMA_NO_NODE, it
> >> counts both:
> >> 
> >> - memory reserved for a specific NUMA node
> >> - memory reserved with NUMA_NO_NODE
> >> 
> >> KHO needs to distinguish between these two types of reservations.
> >> When calculating the size of global scratch memory, KHO only needs to
> >> account for reservations made with NUMA_NO_NODE. Reservations made for
> >> a specific NUMA node must not be included in the global scratch size.
> >> 
> >> Add memblock_reserved_size_nid() to calculate reserved memory for a
> >> given reservation type and NUMA node. When NUMA_NO_NODE is passed, it
> >> counts only memory reserved with NUMA_NO_NODE.
> >> 
> >> Use the new API for lowmem, global, and per-node KHO scratch size
> >> calculations. For lowmem and global scratch, count only memory
> >> reservations that were made with NUMA_NO_NODE. For per-node scratch,
> >> count only memory reservations that were made with the corresponding
> >> NUMA node ID.
> >> 
> >> Remove memblock_reserved_hugetlb_size() since it has the same
> >> implementation as the new API and differs only in the memblock
> >> reservation flag being checked. The new API handles both kernel and
> >> HugeTLB reservations through its reservation type argument.
> >> 
> >> Define the new helper as a static function in the KHO implementation,
> >> since it is only used by KHO and has no users outside
> >> kernel/liveupdate/kexec_handover.c.
> >
> > I looked again and this feels like a band-aid to me.
> >
> > I think we need to step back and rethink the order of the
> > scratch/kho-bootmem sizing and consider how NUMA and lowmem are involved
> > there.
> 
> Could you elaborate? How else would you calculate the sizes?
> 
> To me, the idea sounds fine (although I also share your comments on the
> code style). This is what the global scratch size should have been doing
> from the get-go. Today it over-allocates by counting both global
> allocations and _all_ per-node allocations.
 
> There is a separate problem with CONFIG_NUMA=n, but for that I think we
> should just have a different allocation path where we only do lowmem and
> global scratch.

I mean more fundamental code refactoring that takes into the account all
cases (and I could miss some)

- NUMA vs no-NUMA
- systems that have global scratch containing lowmem scratch vs those that
  don't
- and of course fix global scratch over-allocation
 
> >> On powerpc, the difference can be seen in the scratch_len values
> >> reported by:
> >> 
> >> cat /sys/kernel/debug/kho/out/scratch_len
> >> 
> >> Before this change, the global scratch allocation was 0x12000000
> >> (288 MB):
> >> 
> >> 0x1000000   (16 MB)
> >> 0x12000000  (288 MB)  <- global allocation
> >> 0x5000000   (80 MB)
> >> 
> >> After this change, the global scratch allocation is 0xd000000
> >> (208 MB):
> >> 
> >> 0x1000000   (16 MB)
> >> 0xd000000   (208 MB)  <- global allocation
> >> 0x5000000   (80 MB)
> >> 
> >> The 80 MB difference is the per-node reservation that was previously
> >> being included in the global allocation.
> >> 
> >> The same issue also affects lowmem scratch memory, but its impact is
> >> limited because the lowmem scratch memory calculation is restricted to
> >> the first 4G of memory. The changes also cover the lowmem scratch
> >> memory case.
> >> 
> >> Cc: Alexander Graf <graf@amazon.com>
> >> Cc: Andrew Morton <akpm@linux-foundation.org>
> >> Cc: George Guo <guodongtai@kylinos.cn>
> >> Cc: Mike Rapoport <rppt@kernel.org>
> >> Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
> >> Cc: Pratyush Yadav <pratyush@kernel.org>
> >> Cc: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
> >> Cc: linux-kernel@vger.kernel.org
> >> Cc: linux-mm@kvack.org
> >> Signed-off-by: Sourabh Jain <sourabhjain@linux.ibm.com>
> [...]
> 
> -- 
> Regards,
> Pratyush Yadav

-- 
Sincerely yours,
Mike.

