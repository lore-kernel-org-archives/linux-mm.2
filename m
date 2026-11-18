Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CDE90606A31C
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 14:45:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NMPDfHgm
Received: by kanga.kvack.org (Postfix)
	id C4E8B6B05B8; Wed, 18 Nov 2026 09:45:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C26816B05BC; Wed, 18 Nov 2026 09:45:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B66BD6B05BD; Wed, 18 Nov 2026 09:45:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 8A7946B05B8
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 09:45:48 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id F11F11204F7
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 14:45:47 +0000 (UTC)
X-FDA: 85448513934.17.E37F88C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 447701C0011
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 14:45:46 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NMPDfHgm;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795013146;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=H+t6Gd5bomKS909lh+zZ1F3vPRIjFwGS1W/nocK0gok=;
	b=tYGg7EjYEgEtoG/2NtxnKiBj+LT1pU5xVwXRdWQXbbh4qABIlO1wTz5gFVDLGFGYb8Grhw
	YZzs1mULrr3Mt2aDrl/hEFHH0xxZtGfQ1d2oDOWStTkLJnTphbsQTu0Cs6gTunNXtJS2lV
	vEtSFJKdboyQHRpPukAwy29psgFwajc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795013146;
	b=6Up0wMNQVeGRshr9laTthBgT6awOf2XE5YLKADGGoWDUOEJnCACyUHMGugwgab5xSiYEwR
	FLwetHEFYJVOVEjawQT9NVg1w2pD0X4D2RT5dIepD/Y6exCtnI0EferlAdm+68x/i81v/D
	o9TP/2wNWqjN/Lvubf/u96WL1oQMhYs=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NMPDfHgm;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6A9AC41320;
	Wed, 18 Nov 2026 14:45:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D50511F000C4;
	Wed, 18 Nov 2026 14:45:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795013145;
	bh=H+t6Gd5bomKS909lh+zZ1F3vPRIjFwGS1W/nocK0gok=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=NMPDfHgmY+uSMczQKD1BE6YA9AbocjbU4ogaeEvRQE6W55j2x45eDUe8jrDaoo8+7
	 RIf4F88dsxmKoRbaCzGAFRnxzWBPyCO2cHg9x9UwglLfqJmmAh3dN//zbCTUeGo432
	 W3eT9rO5d71EVoBuqstHISg9lhxD3Q/OFW+sDGiGn8rMZbdEvIasuz6IKnhJ1/CgEe
	 QujN7uCwwbD4CJXkhO8WtDK7taVJQmtltCXvZ8rQ5xE5germZg4iGTJ6tjum8f3TW1
	 k8lPrZmefm+/OwW/UujjlV8d7FdhQKtP8f7vkaaQp/ieEqUIvneL3FpjBnBuoSFPab
	 L7ex+YoAV2hnA==
Date: Wed, 18 Nov 2026 16:45:29 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Tal Zussman <tz2294@columbia.edu>
Cc: Andrew Morton <akpm@linux-foundation.org>, Peter Xu <peterx@redhat.com>,
	James Houghton <jthoughton@google.com>,
	Andrea Arcangeli <aarcange@redhat.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Balbir Singh <balbirs@nvidia.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	=?utf-8?B?TWljaGHFgiBNaXJvc8WCYXc=?= <mirq-linux@rere.qmqm.pl>,
	Andrei Vagin <avagin@gmail.com>,
	Muhammad Usama Anjum <usama.anjum@arm.com>,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	Arnd Bergmann <arnd@arndb.de>, Zi Yan <ziy@nvidia.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>,
	Byungchul Park <byungchul@sk.com>,
	Gregory Price <gourry@gourry.net>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Nico Pache <nico.pache@linux.dev>,
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
	Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	=?utf-8?Q?Miko=C5=82aj?= Lenczewski <miko.lenczewski@arm.com>,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v3 7/9] mm/mremap: resolve uffd state when the context is
 dropped, not during the move
Message-ID: <av26CdCIWuexSi90@kernel.org>
References: <20261117-uffd-state-fixes-v3-0-b617009d1a4a@columbia.edu>
 <20261117-uffd-state-fixes-v3-7-b617009d1a4a@columbia.edu>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261117-uffd-state-fixes-v3-7-b617009d1a4a@columbia.edu>
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 447701C0011
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: ztp3319x19rghy7e5pk76cin6ett1max
X-Rspam-User: 
X-HE-Tag: 1795013146-108970
X-HE-Meta: U2FsdGVkX18fp5swI93bcl94aN577vw8G8pc6lJ6HFfcbK/0K6XvYVoyhJ9cQCt5BRIhEJUduf8SK7zKPsZZcsq87nRmLCjVDNPVDzfGIZ+o9PIzxg5kbY39W9ZEWK2PxyRlNMToCNw9MAYeQRFGp5dO6idv8N/uAoFBC4aEL/TM/OYh/UMl44r5Nt7qyBxxxxjdBxPIkaJP8mSfLS2HhzDMhqfxxZ12eH0h+YRcBgkIRFuBLHHqPiWoam02UXm6Ok/9gdprLALQ8iw46tbiUfrcozJA3xmPBMPMCF1O5cW/IGOwJTM9f8JDORs+IXbaaikSbWfJsTDA+9pJS0rsD7aH5jLtWgHQtO21QfrasAC/vpOuM5a/8VcZpvMyc5SyMAw0a7HAZDuarB3CmWgyzE5wCLjceuvhDfOpzlZKHuUbA4/wPIfNm9CuSS9oIU2x4ezmBT5rm22NO6lGjgZuosMMqESOiKkd5gLvEX2l19r73Z5/WktZ4t1xapglZkP2DUlR3/z9N4EsQxXBoyJdLpwtHSBbvc02eNDiQakAXOEbiRaMrgfqdQHlTELImWlTGEBuhUpJk1mZaPwo5Wa5wenVQPuLAOAC4wq0tRR9BYUxUHTxaGmM4+fxjMdL63gbfLC4dGbcJER4vmJe0LXP8BnVRPj79WBulHnH6tjlhz3DGIufGrQNrmFU4rT9/4Y+seyc6E8aCn7SF78fyIxidUWVVnuv37tIm5GRhHq9pbIs2JPsNzzhB2neErXRCXTh6hTisZIyhqUjYZoiHKDjtgIKF5iR0oc3yT+ipFE5L7TIpnK+uvR3CiKN4NO0nIfsSjNTzXl2xfs0524K1Nu6hf+84oXdY6o+0+WeKXlfTtXmqPEWlXrqa1yObU0KMEmdtCvkGxbjY4GULvRzeNKcwJX/kQsHWMXbJLDxBP7f4itfJJXKx8Vl8SKckSQ7S1g7C3tu/N6drhDYBftyMGM
 9Ii8c6+1
 SPiDqUCtgJ0B5dd4dTeaDaw3ISE52593fagGKOeVvjUcX/E4ZIRbJuUfEYiPPcwPHfm3BF8AHqsGtcQuj6OQUvBJXe90u2YRmQDigJaEbH8OZgIdtgu1QdvnOoUKo2xcIbVExrQdOS7e5ohXwfcUSwjryn42ejkxRC3bUvFBc4NbaqUkBWLjGS3SiLbYxmU0mB2S9eI9tOKkhcuVKx2v20fE4EidG30E5ETx4NNZMgZMGwrW80xi//2PyzL8jCAQxljEYyasR1Rhitx5W5/yhJNpHvdkAi5I09EfAzYK011iSILpuav++2f+VFSVWFIk9qoY58QjUQEi0WYLvrwR9my3h3MTloLButa4cpj/mepdV6sWxM64i5uw3JPJ8COnv6lO9vbSpDDUmawY8jIo3tcPls+xOe3eWHfl4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 17, 2026 at 11:28:47PM -0500, Tal Zussman wrote:
> Without UFFD_FEATURE_EVENT_REMAP, the new VMA of an mremap() is not
> registered with userfaultfd, so the uffd state of its entries is cleared
> while they are moved. If the move fails halfway, the entries are moved
> back into the old VMA, which is still registered, without their uffd
> state. Writes and accesses to them are then no longer reported.
> 
> To fix it, leave the entries alone during the move and clear the uffd
> state of the new VMA in mremap_userfaultfd_prep(), right before dropping
> the context, like unregistering does. This walks the page tables of the
> new VMA a second time.
> 
> This is done with userfaultfd_clear_ptes(), which also makes the PTEs
> writable again where that is safe. That removes a spurious write fault
> per protected page on private anonymous memory, but adds spurious write
> faults on shmem and hugetlb, as change_protection() makes writable pages
> that were never protected read-only. UFFDIO_UNREGISTER and
> UFFDIO_WRITEPROTECT already behave this way. This will be fixed in
> change_protection() separately.
> 
> The entries no longer need per-entry handling during the move, so drop
> uffd_supports_page_table_move() and clear_uffd_wp_pmd(). Whole page
> tables of these VMAs can be moved again.
> 
> Fixes: 0cef0bb836e3 ("mm: clear uffd-wp PTE/PMD state on mremap()")
> Fixes: 763f43865fc4 ("mm: preserve RWP marker across PTE rewrites")
> Reviewed-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
> Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> Tested-by: Gregory Price (Meta) <gourry@gourry.net>
> Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
> Signed-off-by: Tal Zussman <tz2294@columbia.edu>

Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

> ---
>  mm/huge_memory.c | 25 -------------------------
>  mm/hugetlb.c     | 27 +--------------------------
>  mm/mremap.c      | 46 +---------------------------------------------
>  mm/userfaultfd.c |  1 +
>  4 files changed, 3 insertions(+), 96 deletions(-)

-- 
Sincerely yours,
Mike.

