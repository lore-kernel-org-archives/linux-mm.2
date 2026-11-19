Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AD34560A260B
	for <linux-mm@archiver.kernel.org>; Thu, 19 Nov 2026 18:32:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=I51Wzs14
Received: by kanga.kvack.org (Postfix)
	id 9D7FD6B064C; Thu, 19 Nov 2026 13:32:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9B5276B06AB; Thu, 19 Nov 2026 13:32:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8C51F6B06AD; Thu, 19 Nov 2026 13:32:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6D5EA6B064C
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 13:32:15 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id F37FCA0C1B
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 18:32:14 +0000 (UTC)
X-FDA: 85452713388.06.9B29690
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id 194DE14001C
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 18:32:12 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=I51Wzs14;
	spf=pass (imf23.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795113133;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rnpSKrnFQmYg+ietBlmwBi39cYR0OhHgd0OQTIatyVs=;
	b=v2Nj2nqErH0HE/uNsh1ZAcXqnfxc9Stt7r3fVWg4wyx72gAU5OrSaPpDawgoeQPSNd7l+q
	ucEttj9zWfeH5/0M/LSIaov1SUHbZ4pnU4hstB+FfucoBMCLOAmiaertXWvMeRy9bbOI7f
	Az0Ko6V6QV4JaujrqLR1NSP4oRiAtTA=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=I51Wzs14;
	spf=pass (imf23.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795113133;
	b=E5xDzX/RFqcIUNStnXBqe7n51ZJyv7obpGNxW9fN0VponhxUTUciJu9E6VZB/A7wNBntTg
	sSKi1iAfv23WQT3FLTS0HB8NDqX3z5s+vCF7bu9JiPrfNgVnHYn8m5rUGjrKDY4ykRJUPE
	BDJwsVE4C+jStFPo5FNwfhtjBwGlNTo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 8599E61810;
	Thu, 19 Nov 2026 18:32:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DB8F1F000C6;
	Thu, 19 Nov 2026 18:32:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795113132;
	bh=rnpSKrnFQmYg+ietBlmwBi39cYR0OhHgd0OQTIatyVs=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=I51Wzs14XbAG4qsckU/kwl6HJ858CxkZd8Rp3hB5PXisfTLMvM35ZoKvjH++juonX
	 AL35Xk4tz1hhVpn9MtlJe0CUC+dxBvx6wMLVyxPSbVNqCySeMu/oKGY6gfD+0PY32E
	 Ko4FR8GzYJBzLWe5QJX14zKR7S65A6HAY0c6Ypaw=
Date: Thu, 19 Nov 2026 10:32:10 -0800
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
 linux-kernel@vger.kernel.org, Jason Gunthorpe <jgg@ziepe.ca>, Yeoreum Yun
 <yeoreum.yun@arm.com>
Subject: Re: [PATCH v6 4/4] selftests/mm: test fork of PMD-mapped shmem THPs
Message-Id: <20261119103210.24a7612ee26c3ffc3db49451@linux-foundation.org>
In-Reply-To: <20261119-b4-prep-vstor-149847-copy_huge_pmd-recheck-special-pmd-v6-4-efa7817a2bb3@virtuozzo.com>
References: <20261119-b4-prep-vstor-149847-copy_huge_pmd-recheck-special-pmd-v6-0-efa7817a2bb3@virtuozzo.com>
	<20261119-b4-prep-vstor-149847-copy_huge_pmd-recheck-special-pmd-v6-4-efa7817a2bb3@virtuozzo.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: oqbch6taw8j66fhkzwju4m38q81tuumx
X-Rspam-User: 
X-Spam-Status: No, score=-12.5 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 194DE14001C
X-HE-Tag: 1795113132-548089
X-HE-Meta: U2FsdGVkX19QiWyJrkwA9uvt2XwulU9PuaVCVCkkSxNsYdJIat8fzgzHMDQqh0ahRDIsPxrVRtYKvn7vNQGIe+nxxfO1TR0mTIkLKAEQn/brsh+GXlG4c5focYJwazknsMqbsUKpNWClo4OZzlqaPozNIL9KFHsy7Bn518HTkLsB6KiPRLL4lGyWriOR6UFZZrnKWWNlluNtf4lSWZx1UWkG9JZLTYCkWmoUlpdmMz0uTnZ0npsgHaImqxZBcgfCrRwHLaRw0WIjkc6soMALOWtJ8fyuBpmpVhwiVS4RcwdR0YsiY2awanI3pzo7KrgtDupX7GFHopAG/9eR5O72lvjUZNvXdQ2NDpHxAh+5e7J/Yl/9By1PgU1FTg2A2SFRzHVveMnx8U13tttfky6ZuRLchLTygV9GfQmdQT0iEjjkfFocWb8Ta3otErZhoQbuzy9wjAdo3+3wA/2gMvaw4ekdmW9tz0h4X9rZbAr9XZlgrXPnhEl4Vl3IDp5wSPSp/MEH0zEKCqsizuLxyWuIAA9GqBORO5vwkhnlb7LZLsI44pKj2ttLp2N3ObnDZqVfV9JuIOEZcdg5sH+CCQxU4WHjBS/K2cw0pnftwvvWFKAhikxJm5M8duAD5vbPuhLsH8YC5Sgdk5rj1uu+3EA4NNhyibUHrdn4BkAmB0tXjYAehhtmqI8jUrjyiXYwdYioGN71StZT9y08gC2mnjsA+nZr2+jUfYToON9Ttw1N0AVKRwtzQWi+jO6luRDhn2/HHXhIDkskNkbF/rNJCpfRHO42cGsicChUug8uWedzLeA49wDpVvp7uB9m7vSicTc5fwENZ/HzJz6OlUXik05u+wsTkLqEPSzdn7tn3quiGm0RIo4wX+MsuiQqgDPKWk5CKMJqgPyYh+c062LW/hkuDMg8sSmh9/9HEbsUj/K3/ZMm4VSwnbuqhVqUJn3KCd0e2fmb5fH0WuC+D0C8hm6
 7a2WpA8L
 kr3tI1Z+V+oL8IGdSjdrEpZ9fSlXT+sm9SVnnPkPogwZIlhhi4+8jhsWq/4709PmyjMo8QU9gVkY1nOpLdau4Nhdj9jmPeTsOVX2eT2Q5IQsXN6NiCOFg6SzdrHaSCAlCwSlA16Iia5+lgImja39LH6o7YWWdAM/vibyJr89Ixp74j4T6cLkfc/jEyvCF0HDRGOJ30/HiM3ohnBUufvU7JrRGMZ+C1SmoxQnu9RAzrWxAse0iDm+NuBI3vwY2BwrwqT8vYzG6PD7fNlD8G20MbVi1rcZZPSxsP3KBYWC4+eiKBMBOM5ByARiCMEWUk/BH9ylVQVLj701PUScbupe+5+RNvbf1XCzrxI5xIMBQNvPXyMcKfMkp1Bj8eXvyylTLQPcc
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, 19 Nov 2026 14:44:05 +0100 Konstantin Khorenko <khorenko@virtuozzo.com> wrote:

> Fork a process that maps shmem THPs with PMDs, in a VMA whose page
> tables fork copies: a private mapping with an anon_vma, and a shared
> one with a guard region. The child must find the PMDs before it
> touches the mapping, and its exit must leave the parent's mapping and
> the system-wide ShmemPmdMapped counter as they were.
> 
> With folio_dup_file_rmap_pmd() adding PTE mappings, the child's exit
> takes the parent's share off ShmemPmdMapped while the parent still maps
> the folios. Unmapping them drops it once more, so every mapping stays
> until exit, where the kernel reports "Bad page cache", or hits a
> VM_BUG_ON with CONFIG_DEBUG_VM. A kernel that leaves file THPs to a
> refault in the child skips the test.
> 
> ShmemPmdMapped is system-wide, and reclaim or NUMA balancing can take a
> PMD from the parent while the test runs. So the test makes up to three
> attempts, each on a fresh file, and fails only if all of them see the
> counter drop by exactly the parent's share: the bug does that on every
> fork, other processes only by chance. It passes on the first clean
> attempt and skips when none is clean.
> 
> The test mounts a tmpfs with huge=always over /tmp in a private mount
> namespace, so it leaves the THP settings and the host's mounts and
> files alone.
> 
> ...
>
> +static void test_fork(bool shared)
> +{
> +	const char *desc = shared ? "shared mapping with a guard region" :
> +				    "private mapping with an anon_vma";
> +	long before = 0, after = 0;
> +	enum result res = NO_THP;
> +	int i, drops = 0;
> +	char *mem;
> +
> +	for (i = 0; i < ATTEMPTS; i++) {
> +		mem = map_file(shared);
> +		/* Make fork copy the page tables; the last PMD gets zapped. */
> +		if (shared) {
> +			if (madvise(mem + size - pagesize, pagesize,
> +				    MADV_GUARD_INSTALL)) {
> +				ksft_test_result_skip("%s: MADV_GUARD_INSTALL: %s\n",
> +						      desc, strerror(errno));
> +				return;
> +			}
> +		} else {
> +			mem[size - pagesize] = 'p';
> +		}
> +
> +		res = pmds_ok(mem) ? fork_once(mem, shared, &before, &after) :
> +				     res == NO_THP ? NO_THP : LOST_PMDS;
> +		/* Later children get only their own mapping. */
> +		madvise(mem, size, MADV_DONTFORK);

autobot want the return value checked:

: If this fails, the next child inherits an earlier test mapping too. 
: Its exit can then change ShmemPmdMapped by more than the expected
: amount, causing the test to skip a real failure.

which seems ignorable - MADV_DONTFORK failures are super unlikely at present.

>
> ...
>
> +int main(void)
> +{
> +	ksft_print_header();
> +	pagesize = getpagesize();
> +	pmdsize = read_pmd_pagesize();

This is going to ruin Mark's day again, thanks to "kselftest: mm:
rename read_pmd_pagesize() to pmd_psize()".

I think I'll alter Yeoreum's above patch like this (presently untested):

--- a/tools/testing/selftests/mm/vm_util.h~kselftest-mm-rename-read_pmd_pagesize-to-pmd_psize-fix
+++ a/tools/testing/selftests/mm/vm_util.h
@@ -93,6 +93,8 @@ unsigned long pagemap_get_pfn(int fd, ch
 void clear_softdirty(void);
 bool check_for_pattern(FILE *fp, const char *pattern, char *buf, size_t len);
 uint64_t pmd_psize(void);
+/* temporary cross-tree compatibility thing: */
+#define read_pmd_pagesize() pmd_psize()
 unsigned long rss_anon(void);
 bool check_huge_anon(void *addr, size_t len, int nr_hpages, uint64_t hpage_size);
 bool check_huge_file(void *addr, size_t len, int nr_hpages, uint64_t hpage_size);
_

and we can clean that up later.


