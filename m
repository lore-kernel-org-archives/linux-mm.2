Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C0B2EC43458
	for <linux-mm@archiver.kernel.org>; Sun, 12 Jul 2026 08:47:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CF8C26B008A; Sun, 12 Jul 2026 04:47:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CD0936B008C; Sun, 12 Jul 2026 04:47:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BE6486B0092; Sun, 12 Jul 2026 04:47:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A1D9B6B008A
	for <linux-mm@kvack.org>; Sun, 12 Jul 2026 04:47:03 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 29257C48CC
	for <linux-mm@kvack.org>; Sun, 12 Jul 2026 08:47:03 +0000 (UTC)
X-FDA: 84979494726.05.A72C25B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id 8E722100006
	for <linux-mm@kvack.org>; Sun, 12 Jul 2026 08:47:01 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iKyVeFHG;
	spf=pass (imf05.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783846021;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=a1MWMA2QpYLFA5dD8C1zSTBdj0Wi20F5ZHok0IusreE=;
	b=NaG0mDdhQCg5xzRJOfd2MN3j/KVg/XTTum+JaHIR3kZFay6a/r9iReBjqNRnsjczvqNE9i
	d4Ck45d4BnXVt6QSbOLs1KTr8gPWG8NjONH65jCdQV/5LZpuDzpyLugPckmd3Cgpk3AugA
	zb4mQqBHmSVmbDWMJs7I5IXS3/rBXTk=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iKyVeFHG;
	spf=pass (imf05.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783846021;
	b=JYO5E+FgSsLstEbrhTMIq9mv7K1d0pw/MEQ6+e1HS2Rn2SN1GYhZSGLQUMmAxNqSxFZ4gb
	06RVA9qQ9TINb4eK2sbsPVfHIBD1kZjSHRJpgrZgQSOCFGekiDAuBKOboBOr4QRVkeCaIN
	Mu25uPh+O+hRxtSg/xbg/9lzFv5AIq8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 1004C6004E;
	Sun, 12 Jul 2026 08:47:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E1A11F000E9;
	Sun, 12 Jul 2026 08:46:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783846020;
	bh=a1MWMA2QpYLFA5dD8C1zSTBdj0Wi20F5ZHok0IusreE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=iKyVeFHGvqpi5tvmPTHPGcreoOC16jFVlSlDQXyYi1SCf5+0SfRuCjhBLrtFM2O2E
	 Sa0v5LZE7DyioTyLKUVTV5xpuHU12CrnsE8VkvmroSCZVXbH7nHLSyvjrCtxKPnv/z
	 Y0MomN8W5qRajdgD75Nm5Y0y+SDxuZ7BhuHzfh+iIKASoU1MpzDx6Ji2cOS8GsP3B7
	 kWCzpq8KN5YDpVRLQCgeW365JEGzXC1Ug07LOuiykc8/M4NK86NnLflZTf2py2PjGJ
	 CE/CA22uUsHHViqNcQniCekI4IYsZsZKMcbCc316PdzRyI5MLnEKNyvWJ09tVCbrw9
	 MYXy2UhrgakUQ==
Date: Sun, 12 Jul 2026 09:46:46 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Dev Jain <dev.jain@arm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Suren Baghdasaryan <surenb@google.com>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Shakeel Butt <shakeel.butt@linux.dev>, 
	David Hildenbrand <david@kernel.org>, Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>, 
	Uladzislau Rezki <urezki@gmail.com>, Toshi Kani <toshi.kani@hpe.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	David Carlier <devnexen@gmail.com>, Ryan Roberts <ryan.roberts@arm.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, stable@vger.kernel.org, 
	syzbot+fd95a72470f5a44e464c@syzkaller.appspotmail.com
Subject: Re: [PATCH 0/2] mm: fix UAF caused by race between ptdump and vmap
 pgtable freeing
Message-ID: <alNQccqtx5-QApup@lucifer>
References: <20260710-series-vmap-race-fix-v1-0-5b3794c113fe@kernel.org>
 <8e320b30-9658-4e9f-ac4c-f99dcf855944@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8e320b30-9658-4e9f-ac4c-f99dcf855944@arm.com>
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 8E722100006
X-Stat-Signature: 5yq1u9oehz1yxw17odtif6exgosw3qdj
X-HE-Tag: 1783846021-814197
X-HE-Meta: U2FsdGVkX18ehlQeioU5S8dpD3rFpc4X3O8PJOiu8zJqyqSvz6SUB4ETExSloL5YozjlxftgqaKblrwml+DvvRDZJny+jlQ7AOhWhWwOq+DeC7J5ah4baEBbX/PIRJCPAZTaXebvfZg/7XaQoszVZg0GDSCxE+EbW1KNqgU4sh9JE16OYgdzUmeaIK5t0j1V1kVmZj0Zjxys2GmlHSvA5Avon7x2zI54e7DZ2dT2lS7rnhkajJM5kw4LxgXAYnKrqLVuWIpqrlB+90S9x+2ljraCSMUaNYfI0Qg+s+JColoLIHwTlaVU3bR4vfcIqsOB24d2dtWAhvQRRAdVJj4bZSBYkJHPXqwe+BXrFy6iP+frRcg2SYok6ceaQLso2SaL3KldXZlf36FmdsiP2E7FhismJoruPLejPITcY8gV0pMrUNNTk91aUHwlpuxSKDd42aJaXVn4xMDZmoUZq1oDr9PAGV2tI49Y1AM/anBuamgNcuUlZh5MrEtvlAUTCbu68xmvW2qnHO52n/3byoMM7Upx7oPb5ZutnzKhH5QBXsc/eCMvQRWY8EHWcRpNhH1e5LL+bDnbAWe0J7zNgZW0sWP34DpvFiN3vLlSoMtR4lbbwlMJ9hP4MHegndf+zP1A2sSOg5EM4vKnaySk2GkzfJ1f10qO4YeraAvtS7a1zq1RYJN3ElGXZ9ZdntoM1NZsH14VjJmpgMKQrXJjlytXQFjCDO1WZKfYrDY23XCVTwQpAXd4tV0u7FJ+eHNwq4uJMa4f4vUKCPH2LPBZdda1TIyQD/sWeXU7ZZXIAYERVq7OOKQUKZ+BjlfjFJ6osaU1rya5tY5LLBcDEfEigcyb6/TizRoS44huG6CBEhk5k85t6HbsSgdjBUsZqb7pmAqj3PrFhInKje7DTtLNvGn9WUSQgtP/RfxuTn+7KUs0B+MSh6vAPx02IXAkEmEzVMwK73OFJkvoL/FS5ccMxIt
 RoU+P8Vn
 jtw/f3SfycVJNoYhXhu6RVxapP0yg9YHO+rrxD9I2y1PMLXeTcjyYVOvsFHxGRFh5LOcFNxTUnm48amYXkAnzhZqzRg/7vZgzcsPCr5ppx1z0ZTqyb4AHJj7GhimuOiVGbqPGFV9sLyHTb4ltOyut6zgNIfwZPhRuFCBqwsfLwyIzutGT2M+Scc6ZDSoFPaDJ8pWn/38efWHvGjwvEY8D8p+8t9+1r1m/xprdyKH7F8/FYl2jnuCE9jofWEZ5/UMJTW0NDA3LReI86i33iYtx/PQmHQNoTwGWMGkskfvrbmroCharnMjAzQg7F5E+F+aMtCsd3aW+eHjfOrkFhNU3xVm4sAqLowHOQ46qo7q9vtNLIkD2Wm7kT2/gr/RntUldt/UrAlFDu9dkUnyEJKCG2UpgAbKmxFs95jp/
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Jul 12, 2026 at 12:50:08PM +0530, Dev Jain wrote:
> Will Deacon had pushed back on a similar approach:
> https://lore.kernel.org/all/20250530123527.GA30463@willie-the-truck/
>
> Although now when I read back that thread, it feels more so like my
> incompetency to convince :) because:

No haha not so, I think more like this stuff is fiddly.

>
> 1. I don't think this pmd_free_pte_page() path is a hot path at all

Right, and we don't actually alter that path anyway

>
> 2. We are doing a try lock which is almost guaranteed to succeed,
>    so it's not like we are losing out on block mappings

Also it's specifically only on when vmap tries to make a mapping huge, and
this path is being inconsistent with a convention that already existed - if
you manipulate kernel page table mappings that can interact with other page
table walkers, you have to take the init_mm mmap lock.

>
> 3. Any overhead from the try lock will get dominated by the pgtable
>    page free/TLB flush

Yup.

>
> I guess you did not take the RCU approach because that would put code
> into the generic kernel pgtable freeing path.

Well a number of reasons:

* firstly yes it makes the code path always RCU only to suit a specific
  debug user as you say :)

* Importantly - we risk genuine RCU stall issues, because the ptdump then
  has to be RCU too over vast ranges.

  To work around that you have to shard the ptdump walk, make an assumption
  all callbacks are RCU-safe, and that the sharding suffices to avoid these
  stalls.

  It's a ton of complexity and assumptions to account for... vmalloc doing
  the wrong thing.

* It is an established precedent that we mmap lock init_mm for kernel page
  table walking as per mm/pagewalk.c. It'd require significant rework there
  and would disallow any future walkers like this if we were to require
  RCU.

* The mmap lock approach is simple, safe, and as you say is only actually
  required in code paths that manipulate page tables and thus are already
  not hotpaths.

* If there's future work to free vmalloc page tables upon vunmap()
  (currently it does not), we have a stable, established basis for doing so
  that again puts the weight of the work on the operation being performed
  rather than anything else.

>
> I liked the RCU approach because I hate the fact that ptdump takes
> an mmap_write_lock when it is literally only reading the pgtables.

Well you have to do that for the userland side, because there could be a
concurrent downgraded mmap read lock during an munmap, and the same goes
for non-VMA kernel ranges too, so it would have to keep doing that
regardless.

> But your approach is simpler and fixes the problem at the particular spot
> and not hammers the fix into a generic path. So overall, ACK.

Thanks!

>
>
> > Lorenzo Stoakes (2):
> >       mm/vmalloc: acquire init_mm read lock on huge vmap promotion
> >       Revert "arm64: Enable vmalloc-huge with ptdump"
> >
> >  arch/arm64/include/asm/ptdump.h |  2 --
> >  arch/arm64/mm/mmu.c             | 43 ++++-------------------------------------
> >  arch/arm64/mm/ptdump.c          | 11 ++---------
> >  include/linux/mmap_lock.h       |  1 +
> >  mm/pagewalk.c                   | 22 +++++++++++----------
> >  mm/vmalloc.c                    | 41 ++++++++++++++++++++++++++++++---------
> >  6 files changed, 51 insertions(+), 69 deletions(-)
> > ---
> > base-commit: a635d6748234582ea287c5ffeae28b9b23f91c7e
> > change-id: 20260710-series-vmap-race-fix-2a4cac988938
> >
> > Cheers,
>

Cheers, Lorenzo

