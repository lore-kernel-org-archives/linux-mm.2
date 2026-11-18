Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0B155606A33A
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 15:21:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=AhFelVEj
Received: by kanga.kvack.org (Postfix)
	id 0D2996B05C0; Wed, 18 Nov 2026 10:21:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0AA406B05C1; Wed, 18 Nov 2026 10:21:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F03696B05C2; Wed, 18 Nov 2026 10:21:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C9E4E6B05C0
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 10:21:12 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5D3A9807EC
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 15:21:12 +0000 (UTC)
X-FDA: 85448603184.08.DA2683E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id 8DD1380003
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 15:21:10 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AhFelVEj;
	spf=pass (imf30.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795015270;
	b=i20LuNf7TK2IHgl6RUHF9NuW1dUh7glwGwmM2GyDPy1yn0tZXf7ATfoAZ7taxK9ymQBI/5
	vD4M70MFAwxCG/3tZMESw8OfmgrsOu30yX3ocjh2W7hvlViRvh9J7GsdRoywVFfsMO/kLW
	Y0ckFnmYNXOANmiyKUv+UhhnU06T8Z8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795015270;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1shZqnP71Ukitlfj99kedJcZBJQFJWYHeZCXEuiVk/I=;
	b=8OHlNLJl3x1ZKCedCH/EzUpxFmrTOUTWyk4bWIWbST9R40MMey5R5EHk4DXoXG0N5ERBgk
	5OM28yNTj411jS2FOuh37jV0UfhrAznVP0jVCexYgBO+2Jmg3bYfqWhHAv7y22wrBy3MaX
	FTwO/tdiOFbPT4gFSARkQowJXuZzSy0=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AhFelVEj;
	spf=pass (imf30.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C75DF4387A;
	Wed, 18 Nov 2026 15:21:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE1F51F000C5;
	Wed, 18 Nov 2026 15:20:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795015269;
	bh=1shZqnP71Ukitlfj99kedJcZBJQFJWYHeZCXEuiVk/I=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=AhFelVEjfmme1YPI9SS+ALRaQvFt+2IMeiCSN+WgOjeEnv+/SuTNf01cZy6ptDUYR
	 qv/tiHy46NDQyvohLFArJuLSsfy6vAVfAjVqoLBPTlszEbf04FN8CMxzRsJ9d1yi7R
	 brtXqyu94yBnimenwmhETIFopB0rebgPYtlPWVNdluMDvPyVu17HWeotXEe7kmazyQ
	 HNRJ/F03FfU1PSeSYm1vlKEpMz6j4DKS/RCdxpK0FURFwbqKlYl3v8M1e9YzI023ra
	 ifwZgVYhoaeH5afzbCuCVdd7EprCvOeqhwy3A/kfibbP3cMGU1Y7oDipu3gRnSFzLC
	 3i7iv0Q6NGlsg==
From: David Hildenbrand <david@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
 Mike Rapoport <rppt@kernel.org>, Peter Xu <peterx@redhat.com>, 
 James Houghton <jthoughton@google.com>, 
 Andrea Arcangeli <aarcange@redhat.com>, 
 Suren Baghdasaryan <surenb@google.com>, Balbir Singh <balbirs@nvidia.com>, 
 "Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>, 
 Pedro Falcato <pfalcato@suse.de>, David Hildenbrand <david@kernel.org>, 
 Michal Hocko <mhocko@suse.com>, 
 =?utf-8?q?Micha=C5=82_Miros=C5=82aw?= <mirq-linux@rere.qmqm.pl>, 
 Andrei Vagin <avagin@gmail.com>, Muhammad Usama Anjum <usama.anjum@arm.com>, 
 Stephen Rothwell <sfr@canb.auug.org.au>, Arnd Bergmann <arnd@arndb.de>, 
 Zi Yan <ziy@nvidia.com>, Matthew Brost <matthew.brost@intel.com>, 
 Joshua Hahn <joshua.hahnjy@gmail.com>, Byungchul Park <byungchul@sk.com>, 
 Gregory Price <gourry@gourry.net>, 
 Ying Huang <ying.huang@linux.alibaba.com>, 
 Alistair Popple <apopple@nvidia.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, 
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
 Kiryl Shutsemau <kas@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
 Oscar Salvador <osalvador@suse.de>, 
 =?utf-8?q?Miko=C5=82aj_Lenczewski?= <miko.lenczewski@arm.com>, 
 Tal Zussman <tz2294@columbia.edu>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 linux-fsdevel@vger.kernel.org, stable@vger.kernel.org, 
 Breno Leitao <leitao@debian.org>, 
 =?utf-8?q?Thomas_Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>, 
 Lyude Paul <lyude@redhat.com>, Danilo Krummrich <dakr@kernel.org>, 
 Felix Kuehling <Felix.Kuehling@amd.com>, Jason Gunthorpe <jgg@ziepe.ca>, 
 Leon Romanovsky <leon@kernel.org>, dri-devel@lists.freedesktop.org, 
 intel-xe@lists.freedesktop.org, nouveau@lists.freedesktop.org, 
 amd-gfx@lists.freedesktop.org
In-Reply-To: <20261117-uffd-state-fixes-v3-0-b617009d1a4a@columbia.edu>
References: <20261117-uffd-state-fixes-v3-0-b617009d1a4a@columbia.edu>
Subject: Re: (subset) [PATCH v3 0/9] userfaultfd: assorted fixes (part 1)
Message-Id: <179501525761.13527.5348420494097607881.b4-ty@b4>
Date: Wed, 18 Nov 2026 16:20:57 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.16.0
X-Rspamd-Queue-Id: 8DD1380003
X-Rspam-User:
X-Stat-Signature: ywwdzx4irer4rfyg439rs58eitd3hi3p
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam12
X-HE-Tag: 1795015270-598952
X-HE-Meta: U2FsdGVkX1/6JfRmR9hMvMJ/BQ7FUnt3TJnN8U5tTDBM0d6QqP+peuicEy7dQWEU26xg9ZFIIHn2YDcEQjGJAmu6AXQqj1Y8d0pYdgLELyaKppXf7ZyrKWAn01dc/aQJcpdWDpVZTYdT6xfFIo87SLxOjyjW7IX8HeAkjKNdiQZm2SVG+Ro12qRmXzZQkOCotGTM27/PQ+3ru2n0gWdNJohyKCxVW/ohCqKqsPhABJ5wf43Lac4bviW0cOvjFH0HHORAqptz9No518t7yIXpKsHH+tPDZNIKrDtHq+hoXW+5WgkeqmvQytp93z/WLVx5Betpd7RPooE2yqLI7LCyXHD220V3S6KQKYss3aRZl7VCLDz7x+neQ+0TJo/7N7/XfZa7SpSWZ4KaUAHzuA24KevI8OiSb98lqGcX/kmAqgH+L5HgoFnq1LclYeZ+LHLwEcw3HgCPYWMeRnSZ45jd06T4lHhvGwgmsizb4CP5d9XKQS8jxhqO9Nfaody8rNBX219KOHSiq9qlLZT5T5G8YWuhoG5GNDzhQeprRicUHSAH8AZUwBc1tmWsbrscUfOiOXIfvR/BfI4RwVjmBnMFlLDGa2NmzFaURWDH+i/C6LRCfduRnsaiFeXuEq8zkxdZ4QK/Pq/jt/bd4+F/gNaRPHWtqV1a50sfmGoyYri8ZD7B5b7KUL6rF4AXbMehI814q1v2t/LSJSyOd3tx9vf4SasYtp2nvePdWyaSKdHh7Las4QUZ1FY4czTAX3shPHGV/eRNXRvdR3pp+cZQMD9qcmydSz1y4BieOa1ZcZggplrFmMlSqNH98Bh6RIC+2gl5GBzjDFqBabbQE4S/uSsHwYxH0mZbm+0kZCc+3a6rDJeoMVhJ7LL8IWt9NYY7V2eQMuSqz0FdHwPNUvJ8iyp6MN6St+CstLvYApetEzGPrkWmUJD4FqY+I8edPbWKPJptkUTsb8L9tGP8IctSkiS
 VyrpoQ7O
 PXZcTwr/FNWb95/XEgBBhxrLITwP8FRPXZt52C6VrQPpnaE/ybrpl5Qyi1F263U69G2d6PA8iZJb9sRSa8BT4WCARJF6vfN42G17qJiHzMsf/zIZbJCHCC+/9zItFWhJKmyjSFN+WSIf3+3L76iL1uwmSaZvlluuJ7UrUBbKYEqcg6uS8OnLyZy/fHCtqjzmoLT7kwomrZnsByIAqoVgw2GE8kq+yHT94LmUn99pRc6AgDwz/6LhPI8i+eUsDDY2jnPZfS9JaK3gjP2J1AVnnyEFak9Oby1EcVixUzrZq/HapG0i+9I0/qx7Uua0Nk8tgCDnsPBsAeNVM4v0EBqzGpWIh4ovFS4ElrUt15Xum+KZlv+9Osn34dBU5EtQVljJc9i9OyWL79z1l+DlBHJXHKy2NY/xxcE06M9o6KXQuG3Hcsbw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, 17 Nov 2026 23:28:40 -0500, Tal Zussman wrote:
> This is a first batch of userfaultfd fixes, with more to come.
> 
> These were found by a mix of regular old LLM review and by having an LLM
> write a TLA+ model of uffd interactions with PTE bits and other state
> and seeing what issues fell out.
> 
> Most of these fix places where mm code loses uffd-wp or RWP protection
> while moving or migrating an entry. Userspace then either misses writes
> and accesses, or gets pages reported that nobody touched.
> There is also a hang in UFFDIO_MOVE, and UFFDIO_ZEROPAGE modifying a
> file through a private mapping.
> 
> [...]

Applied, thanks!

tree: mm/core.git
branch: thp-7.5.misc

Applied patches will appear soon in mm-next, followed by linux-next.

Please report any outstanding bugs that were missed during review, so we
can either drop the patch series or decide how to fix it up.

It is encouraged to provide Acked-bys, Reviewed-bys, and Tested-bys even
though the patches have already been applied. If possible, patch trailers
will be updated.

Note that commit hashes shown below are subject to change due to rebase,
trailer updates or similar. Further, this is not a guarantee that the
patches will go upstream. If in doubt, please check the listed branch.

[6/9] mm/huge_memory: build the moved huge zero PMD from the destination VMA
      https://git.kernel.org/mm/core/c/ec36bf72

-- 
Cheers,

David


