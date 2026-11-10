Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D401A606A31C
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 17:08:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=k2lMMVu0
Received: by kanga.kvack.org (Postfix)
	id E40DA6B05C3; Tue, 10 Nov 2026 12:08:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E189D6B05C4; Tue, 10 Nov 2026 12:08:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D310E6B05C5; Tue, 10 Nov 2026 12:08:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B35186B05C3
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 12:08:28 -0500 (EST)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 519AD1A0A28
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 17:08:28 +0000 (UTC)
X-FDA: 85419843096.30.D39649E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id A451F10000D
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 17:08:26 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=k2lMMVu0;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794330506;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=W4toJnlwxo6gYnBNO7MZe8ejf7vNnhvthFCmzNs0KII=;
	b=ZXfdXBoXMDZSf+Po6NtshXxOybsVWjbhMUDikQqWaUCNp7rP1UlYaybHohiZ/01My+gwj4
	gmpRrOVBf8jpY/Vud2wUferyNbHwtaouFOqjZ7ji3D84yRzhKuq6HZgR61UVFd36vQ2n46
	h9GwpylfHl4zTbvcFl9POxppfG6zOcc=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=k2lMMVu0;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794330506;
	b=F66RR5mOUOWG3VHlrN5y6gd9lHbAMQNySbyUAjbCVW6dKX7MUtvAeGkAgnbSxYOWmNf46g
	OfjvwiaBBzLrXz0mC+Zvsb1IQJyrrqp9tDI1Xab+7np4Ls+KQx8AboI1w5ARjR6m/RFJ96
	mEKqITZe6ebBo6uzAh4JoWNYT+NtMJk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id DDE5E40884;
	Tue, 10 Nov 2026 17:08:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86DA21F0089F;
	Tue, 10 Nov 2026 17:08:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794330505;
	bh=W4toJnlwxo6gYnBNO7MZe8ejf7vNnhvthFCmzNs0KII=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=k2lMMVu0DXMibVy3EmJeXu1BBP9LzaZ+qFOkFKbiyyr7I71yF6EsgqCzDR8pdSBIo
	 qecPgaS/MhiunL7X1SEnw3lR2lTP6BwoqZk6uefjwRjRbQpIt3Utr6+IQq3CSj7pCQ
	 XuEgxQRvnh4tbyEQ9lTeLUeqX5tcFuGX7BoqIWr9+3bzH3FYABV5RskZjyVzl/TwRL
	 NC/8/5/TdYHyIGoySa9+EKyv2VRc5c3liUe3/jVGmom9XU6RvUbD5a3HLqd5U+224c
	 6gvIde6SvgNeiem1HcakWSaA3CtHngQNEUb1XPQY4lYKzm3SV68pAXSyJlGO0ENOi7
	 JSCCNvxWyTW+A==
Date: Tue, 10 Nov 2026 17:08:15 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: sashiko-reviews@lists.linux.dev, Jonathan Corbet <corbet@lwn.net>, 
	Shuah Khan <skhan@linuxfoundation.org>, Randy Dunlap <rdunlap@infradead.org>, 
	Andrew Morton <akpm@linux-foundation.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Peter Xu <peterx@redhat.com>, 
	Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu <mhiramat@kernel.org>, 
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <nico.pache@linux.dev>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
	Kiryl Shutsemau <kas@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>, linux-mm@kvack.org, 
	linux-trace-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] mm/khugepaged: check for empty PTE tables before
 retracting
Message-ID: <avNO1pvPuMYIdYTE@gremlin>
References: <20261107-b4-uffd_marker_loss-v1-0-82926b22704c@kernel.org>
 <20261107-b4-uffd_marker_loss-v1-2-82926b22704c@kernel.org>
 <sashiko-outbox-203403@kernel.org>
 <28b818cb-f038-43ce-a2e2-a9c97befba09@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <28b818cb-f038-43ce-a2e2-a9c97befba09@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: A451F10000D
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Stat-Signature: b4mtg9jrafoy4awx7uddstm9zx78okq3
X-HE-Tag: 1794330506-477680
X-HE-Meta: U2FsdGVkX1+87SBETMypjkai6LhdaetdghadtXpZn7hK/gQZog1mFm/K+hVPW/NGEigWPHhsplCx/goYx0qNVOL6Ft3Zxd3NOIAeNPh/0+enDieNzhoyZIU0k+MTkQiaCTD7WIC0PDAd3XHCo31V+I3D9Kalg2rG6u0wWF1ev/iv3wb6vlNEv7YU1VfSeOPjz0I64gLVXM6PW/v2fCb69aBzPtf73iHqT6nNZqoc3OBEyvziGYzf6K/A9rZCyIJ9gIywywbbou5ucVR64iTNz/XLfLlJvTsLMCKYm2jPSMGI1w3r6OwsjbxXvkTIHcA9SFP5EvaYaVZHVnn0yqQitYsmBqn8k5nP3GvgRmhX4iRtyskrN0TzqQ6GLuQj+c1ZADAcKVQGTDhj1jwssJLSSca3GDzcaxtCXJ8MdgSpkwrwosMJWIKCrVt0tQ7R3ksyQRxxYlAbyO2xSRG8qo23+f8gJGrv/8RzCF/7YkTak1XagSwyMXJ+vv2eu47G50jHovhONQPZu8lEGeKEmChjtxW5JLXGnf8uqHvTt+pJ7imbv1qBe7pgIryy/SriedaWOURAquhIGwmLMph1qpJwsfteMD+3T9usqsNBoItlrlfbqbjziO8EeFpGq/yn8Ib5CCkI7I0+lYQpBR32g6UMLoUTrgp+AC+1y3DqtuVUnPNvHj0TDyHL6rr9fG+fs5e3LPWSgvYY98S82uGlD4H8ixQjC6vdo6YQKDGsvbZUJ7h/HMHtaVcqNaMu7S7Sq/P1ypug3XkN5XOPg+YT7GEUnu4XcSG6uw7Pckd6x8BpvyEuHW7ecLCTkJ1hp54DWMroCqA3XMSwMHyjAQXMWULbPE7WsTizoQMFv1SYvHkxeJ5GUGuKNL2Fbbu/og4uzwSrUCr/pTCv2ynvnP9aZffDJPmduF+ZUzFReNdhWcsO1UBKRvptsD3TGSk+sdwQZn8GWJXd2pi/smBRoB+Hkdr
 0a98L9yd
 rYE5qaitjmKDgNS0YR/ip4vUIt+8aqFIyjMKitJf0GF62v9NbElH3D5Shbiw02mNINmPzyRxoaLmuJ4G0hNgaX+YSC9L5E4OF4ATt9NpeJ1tO36WZNq4o0yGr+17cMEfot4Nn6o3iZkafWY29mUZpVkUiM3B7Y58EDySOyD90d7Bzu3SyhvM3i14pRJAMgzahq/HvSdEipVziCQrGjXmfAYaTYXg8li9IQy2vcyBO8+7nGQyc01UY0akyiaAbL9vFNl+eT/8L2bj4Eew65UNgZz1TbQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Nov 09, 2026 at 04:08:23PM +0100, David Hildenbrand (Arm) wrote:
> On 11/8/26 00:51, sashiko-bot@kernel.org wrote:
> > [Severity: Medium]
> > Can removing the VM_COPY_ON_FORK flag checks here cause retract_page_tables()
> > to race with copy_page_range() during fork()?
> >
> > In dup_mmap(), the child VMA is linked into mapping->i_mmap and
> > i_mmap_unlock_write(mapping) is dropped before copy_page_range() runs.
> > vma_needs_copy() copies page tables not only when vma_has_anon_rmap() is set,
> > but also when VM_COPY_ON_FORK flags (VM_MAYBE_GUARD, VM_MAYBE_UFFD_POISON,
> > VM_UFFD_WP, or VM_UFFD_RWP) are set on a file or shmem VMA whose anon_vma is
> > still NULL.
>
> Ah, try_collapse_pte_mapped_thp() runs withe the mmap lock, whereby
> retract_page_tables() only holds the rmap lock.

[ ... ]

> > Once the PMD is pmd_none, the next fault in finish_fault() installs a huge
> > PMD before checking userfaultfd_armed(vma):
> >
> > mm/memory.c:finish_fault() {
> > 	if (pmd_none(*vmf->pmd)) {
> > 		if (!needs_fallback && folio_test_pmd_mappable(folio)) {
> > 			ret = do_set_pmd(vmf, folio, page);
> > 			if (ret != VM_FAULT_FALLBACK)
> > 				return ret;
> > 		}
> >     ...
> > 	/* Using per-page fault to maintain the uffd semantics */
> > 	if (unlikely(userfaultfd_armed(vma)) || unlikely(needs_fallback)) {
> > 		nr_pages = 1;
> > }
> >
> > When userspace later issues UFFDIO_RWPROTECT on that file or shmem VMA,
> > change_pmd_range() sees pgtable_split_needed() is true and calls
> > __split_huge_pmd(), which zaps the file huge PMD back to pmd_none without
> > populating a PTE table (since pgtable_populate_needed() is false for
> > MM_CP_UFFD_RWP), so RWP protection is lost and subsequent accesses fault the
> > unprotected huge PMD back in without delivering RWP faults.  Installing a
> > huge PMD also causes PAGEMAP_SCAN to report all 512 pages as accessed or
> > written after a single 4KB page fault.
>
> "Since pgtable_populate_needed() is false for MM_CP_UFFD_RWP" I think RWP also
> needs proper uffd marker support, independent of the change here.

Hey,

Wondered if you planned to do a respin on this? Want to know whether to delay
review for that or not, thanks!

--
Cheers, Lorenzo

