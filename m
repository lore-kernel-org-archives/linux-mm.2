Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ED02F606A330
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 14:37:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GUbAtBQj
Received: by kanga.kvack.org (Postfix)
	id 141C26B00EF; Wed, 18 Nov 2026 09:37:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 119326B05B0; Wed, 18 Nov 2026 09:37:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 008546B05B4; Wed, 18 Nov 2026 09:37:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D91BD6B00EF
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 09:37:30 -0500 (EST)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 739A01C41D3
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 14:37:30 +0000 (UTC)
X-FDA: 85448493060.16.E82AE5B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id BB86E20006
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 14:37:28 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GUbAtBQj;
	spf=pass (imf03.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795012648;
	b=NT7E4UhGYXdWSkK4Y2LPfxlMtXl4hMKzV71WEA1cVD+BLexX6uH6NL54QrVXsw29HSqZqK
	3Xi+Udxig0SwZ9ra1W3DvaQO5M3pQz52wzrn0pL3F0P7z5I0283R0R5b9WXr09yAxSfrlw
	ue6baVhiXD3vp4JrjZHcMQZpkU5aIPs=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GUbAtBQj;
	spf=pass (imf03.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795012648;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hfq1+ahcbxyZo7gBB7LdlV/ONz7fUZdNHYr+ADwNbZA=;
	b=6m3dGwNwvbyFVLXDWqH+GfADwvK/yapfRStak/CEn58n1AoU0Iv748sJ6G++DH7tgNP7DM
	115AuT7D45d8cZQx/pfwdHE1e6kLzJr/1KOzMnQsQtwh5Y5IxIjctT1vpDM1Dc1ohnw+o0
	mIJNuOoqfFAxxiTQU6eYc1jWECsI7/k=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id DD4EF42BA9;
	Wed, 18 Nov 2026 14:37:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E6BE1F000C4;
	Wed, 18 Nov 2026 14:37:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795012647;
	bh=hfq1+ahcbxyZo7gBB7LdlV/ONz7fUZdNHYr+ADwNbZA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=GUbAtBQjbUK7eKEZptuCukI88BYQ6a2zlpxE8dOVumCTZcFxTXDYvE8WqxvMAxlF5
	 kMD5yj3pvpdnpQ7FehKmw/lGCsXkT1vwpoq3WcL1z+XXWPq0iHcvo1ilFwMg77g0v0
	 mAcn8uYSgZcHds62mbCV/INwzR8XxrMpygqEUqzMTMjKcmr2gNLoEbROzQ8izHHkSU
	 oowwOEXgkWcktcuAqazPIX0GhD61EiI6HuF2kjgVKNpx5N4JXDEnZfsnqS0F07vN23
	 2UppeXCANLXKYLWswD9+GPSMGav81pPL1bYroFnKETvyHZKRvQ66P5nlTqmGmPXxNJ
	 R7LaGUWyE4PDw==
Date: Wed, 18 Nov 2026 16:37:13 +0200
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
Subject: Re: [PATCH v3 4/9] mm/migrate: warn on a writable migration entry
 with the uffd bit set
Message-ID: <av24Gep_wmm8fib7@kernel.org>
References: <20261117-uffd-state-fixes-v3-0-b617009d1a4a@columbia.edu>
 <20261117-uffd-state-fixes-v3-4-b617009d1a4a@columbia.edu>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261117-uffd-state-fixes-v3-4-b617009d1a4a@columbia.edu>
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: BB86E20006
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: utw9kra5xnbom3xwnyfmnzoto74pggsa
X-Rspam-User: 
X-HE-Tag: 1795012648-484279
X-HE-Meta: U2FsdGVkX1++Gqi/bxhhml7Q7e+F2FWcpKkrYOr9xPnWI3ELjaxa3NgLak3yhKj09nX6zyVJoLXFg2HBnG8vEeZhGY23EdPsX6bJAzsEHB3Lhe8nI0NccRJbt2ukvquIkY/bpo4AXk2fOu05CCghwVsknzmevlMc5P+/eL/9A2my5XjcE5iYtmRBpzSshoXBY/NRXGdhdus1G3DqUm7gxxMK0nxiCcKRYoFENPMdOPeLn+zAw6uVt84rgwYozbgoftnlkVxoD4+mPJmGnpzmDT2xuny7v+dWPPfx8kUjK51gOq6D64q+Kw0C2EHpwAw+0ESk49fPOMIQmyYO0fvBJKpDgELqQERhNwmyEneXSJz4u61EyuqXuf4fbuUPpu5TnjS5orwujAmGECVt33yoa602t5OnZiWaMozOSv+PJ20mrLv+YVP6Bxzj7fITUg+w5yCih4FR18KMRjmloQkP+Atlp1su2r1Ln4IuQBxp4BWqvqT5SzEtPFco/jxyADhUJpXwrPTjFPdFjdnCGo29fOO+eaSyezZH4J4BU0169et185EnjS7UOXCYdVaS/OAi9lAg/NA/Pz2+yqW+TdT2/JzeSyYfR2QkcXk5tFlmnKwCHxkiQYSnO7xWMpyeP36/6dA4O19ZTHRJaNLaOqYOfmxqt5JkDyxk3s3JUk8UCd64KBQsLBwgfCbzE6OLKOwRLqTT/fR0tPeP6HPQBo9UA6D++OWmbp6KV0s50y2J24lsZa+7n8WNsc+V5RBKL3fY9XA44e9Gvd02995SN1135xwFXl1u2Hscaohkjp5M5jUDf79d3HHZ+NEj6MeM0THqQ/pIG2Ik4XTFzXtljUW9V2agyBLmZ7Engi9vd7JjJCKH0THieZPn+0q72Qt5BGrMCub8C+R94QDrcEqcecOiOzKL1XAD3emcuPLCI+Q5bujzatLCIa4iThwnG7rg0UyoAn9dXbyvskXtiP3QO+4
 oSilr4dS
 Yb2vvGl0VRo0J8p+Its7DOLi78TzDBdggFj9kzUKs6547hI8EjhVX7Jsl3VWS5UAS+LMHt24uryduRaG9xYkny/ruHeF+CsoI1SuFeEwvuXPcQKuCVj3t9Fr5/cw8iYiM/+H/m/uB483ng7sh8R3wTOVLVTShVF2HAHl71rZMrUmKTUR0u1hAWtcww9fGbHu61baMVCfXd5wrSBXAqam45wNh/wtmRPvHPWTBKAC+JXg0cKNuaa1zbdfaLb2xhgMXCXX6JKmNe6aaCPtH3uO48kk70wJg2W/67FATISW/Ln2IHXAY/C+hifn/skpiwmxNMbaq22fhak8UQb15G5OBAcwfExLE/oZIuIKBsxc9i1Zav0sZTtlEb6KBytR+rbzQYJNG
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 17, 2026 at 11:28:44PM -0500, Tal Zussman wrote:
> A writable migration entry must not have the uffd bit set. Every path
> that sets the bit on a migration entry makes the entry read-only first.
> PAGEMAP_SCAN was the one path that did not, and it now does as well.
> 
> remove_migration_pte() restores such an entry writable and drops the
> uffd bit, while remove_migration_pmd() sets the bit and write-protects
> the PMD.
> 
> Warn in both paths on a writable entry with the uffd bit set. Also make
> the PMD path only set the uffd bit for a read-only entry, like the PTE
> path, so that the two behave the same, as this should never happen.
> 
> Signed-off-by: Tal Zussman <tz2294@columbia.edu>

Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

> ---
>  mm/huge_memory.c | 7 +++++--
>  mm/migrate.c     | 7 +++++--
>  2 files changed, 10 insertions(+), 4 deletions(-)

-- 
Sincerely yours,
Mike.

