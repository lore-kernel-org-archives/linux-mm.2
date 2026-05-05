Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4D43ACD342F
	for <linux-mm@archiver.kernel.org>; Tue,  5 May 2026 10:53:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6537A6B0005; Tue,  5 May 2026 06:53:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 604016B0088; Tue,  5 May 2026 06:53:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 51A2B6B008A; Tue,  5 May 2026 06:53:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3D6FE6B0005
	for <linux-mm@kvack.org>; Tue,  5 May 2026 06:53:48 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C84C41C0C12
	for <linux-mm@kvack.org>; Tue,  5 May 2026 10:53:47 +0000 (UTC)
X-FDA: 84733055694.01.BE41EFA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id 47850C0005
	for <linux-mm@kvack.org>; Tue,  5 May 2026 10:53:46 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=pVkmqhUb;
	spf=pass (imf22.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777978426;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0AJBFQC2H0kv4rSYMZwgyeybk1hcM5rMG5o5MQaRut8=;
	b=zbOPQW7qPW+IdEyJX/jQP1yJrzSLL/1EnFydA8kAL3aZLFjdJjCA2FgWjL9yjA3PQXOMn0
	2Hxa5MM+p4DAmac3IJjHeklKkYipMmFq/2i3pYvx/4eEdEZRN07fmPslUUFEPBqv405CXs
	UBx46eMu9ZF3eOSozLWF0HE2YLEU+bo=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=pVkmqhUb;
	spf=pass (imf22.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777978426; a=rsa-sha256;
	cv=none;
	b=F/WaoJb4k2yHqG7XrMlJRtbRlDkBYANBRgE9xlRP7bQJVCj8WCxULAkbfomTU6t5U6nSY4
	UPljJpgeIgWSStniELmiKaoSig7xqlJbnA5I1VzzNIaNMKGjjwCsqJ2jm18hhFyXfL5yNp
	BizVK6ngrkv8hOKEDRm6BeDKSBQINlI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id AD30E60142;
	Tue,  5 May 2026 10:53:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E0F8C2BCC9;
	Tue,  5 May 2026 10:53:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777978425;
	bh=vJDvDo0M4pNgzGnLn1Lls5KK9p0fm7SJYJkfYATAMsg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=pVkmqhUbdwd/0yjZI8oW6cR2A4rOXGkrmmA8fvRe4PacCQQiXlBTV/lnzjq0n3vCm
	 4KYvH+vu2iV2s7QLRk4JtY4MJ9BX145fCaFO+NzKfnuhjBkIns9k7deEIv679EciYW
	 2x8VzgMa/6m0Qyn6NMbvHw9/SCDgg9mN0IJOatA96F/cxw2Tx3940r6TM86j9lUgji
	 48WRp87KUAHL4OTJ5RGYnkg0rw4sdrAUY+T143Asrl58mSLe0CbJ2qpqHQVO6DJAvl
	 6sfUkbJcQv2amhvg/bWdfV1ZIoNzYdmacuxb/BgG+Ohn4mmklcsWHHpr+EKGLOonS/
	 HNXZBQK5WeBwg==
Date: Tue, 5 May 2026 11:53:40 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: pratmal@google.com
Cc: akpm@linux-foundation.org, shuah@kernel.org, yosryahmed@google.com, 
	david@kernel.org, Liam.Howlett@oracle.com, vbabka@kernel.org, rppt@kernel.org, 
	surenb@google.com, mhocko@suse.com, linux-mm@kvack.org, 
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] selftests/mm: use pattern matching in .gitignore
Message-ID: <afnMAaz1jY94db2n@lucifer>
References: <20260421183000.1541546-1-pratmal@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260421183000.1541546-1-pratmal@google.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: 47850C0005
X-Rspamd-Server: rspam06
X-Stat-Signature: pc5oj9hyucaktpfz1cu1jyhpawte6i9u
X-HE-Tag: 1777978426-130300
X-HE-Meta: U2FsdGVkX19sz7F9SH1b10AYtkfnzJsCGrbNHPpKZ3yH/LkgcvvMljhHoEcbK/0EtCwjezPGNhgtPekk4Kz5GG/0uR4kfWCc2QuueLZNEuph3LNsP1VzxMvOl3KPis2471TQU5dushgZCtNb+YweTRN1UnZOdyBTMGNQt/HtcHzs5hNKx6Hind+vYkDNlB6RlYsooSorgmfPXrBcgQj0kI30h2H9IR0C1dAYiSDhKaJimKmVp6wMxfzbWrUWEiFNKtSOOBTV08ebmickZXaRy8TBslJUa1BYyzc97jCIQg0+SKy34XOXWhTtkEPxJcw5SO/Kabgbm9X587ldEd0SmOd7wsWBB5WnC0BFJVVsm3HAu+C0rvx3u5z3RReEW8q7YgY9J4HF02eF9zCj8WwJQiud5gre5SM+hdRzoXu10P2fKWrx90CKUG/7TH3PX61Jkl+GImt68onoOzFXFP1UG6BwL/UkkVN+eB8vtw3C0tzCAwk18nADPovvAwn+0lBW4zwlek9FGIj2QA3XdDX7J6yX7EMLxXU2p/q+MvKXH3rQETwwyT9yGSo6Kz6fyjK17xxMjKBRH6b84VarVRdbLnCNU4AZ1FYo8BsVJtTLhsxv5qbgU1kszKLkltv97f1ORUQgMBIufB59UjX516CjZHeOrpqiuR8caktbbmkXONmtMZT2r121+b2syGDvXeUnjYJlhSid88JLlp9HCXCbV51rcQjZ4I/bj0KSxDPuucBVa7kBJQZzRi6UGLdv8tWSfFQZuJIxLaxWEDeHKF3Dloq8om8sTGUc1V/zu+T2TnXguCX9Ll/l5wF76IelgaJgxlModEpyqun5HrYR6rBwIyNaFnQ4fLOrImbZblUldcg69D8Pk6qJdbFj2Z4hJtM+BULKlFHkBFOONcQWuqFcLMM1ctO1VAcojX3cwvMSpRZezIW7cJ/I6LxBViBwp/n+H7r3M9j9PNx9R6vVnqk
 5CiuaJgN
 eHS8EaqxZCRMEgxU2ywfdx8lvoQy+uovzBSYwnB6CPAWZY4kFcjjqbX3cWkKGMYT6tT5wQCiIEULB4/gvarNEkhhAjgIrNWXNWhiKss2OEdyoPD85OlKZrLiJyyTj1PSES6FIAawMmuJrUkfRPfzMrRASy/evamU7Qm5FlFSb56A5utlNRBaAn/SEhYkzIwGlJLNKj+OG2RGvT1zByzK7KjoZw0iJD/pzJGaPKpILMnb6mxIrwKuFr4RpPTx/LyCKAvG9abfho9qfxsBbs0t9WIPLwUTYq0W73Hxn/+2Crq1bD5I=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Apr 21, 2026 at 06:30:00PM +0000, pratmal@google.com wrote:
> From: Pratyush Mallick <pratmal@google.com>
>
> The current .gitignore hardcodes each generated test binary by name,
> requiring updates every time a new test is added.
>
> Switch to the patten-matching approach similar to KVM:selftests.
> Ignore everything by default and then allow source extensions (.c, .h, .sh)
> and tracked non-source files.
>
> Signed-off-by: Pratyush Mallick <pratmal@google.com>

Niceee :) a lot of red, love it.

Assuming you have confirmed this is all working correctly, please un-RFC and
feel free to add:

Reviewed-by: Lorenzo Stoakes <ljs@kernel.org>

> ---
>  tools/testing/selftests/mm/.gitignore | 72 ++++-----------------------
>  1 file changed, 11 insertions(+), 61 deletions(-)
>
> diff --git a/tools/testing/selftests/mm/.gitignore b/tools/testing/selftests/mm/.gitignore
> index 83ad9454dd9d..92f9205d3996 100644
> --- a/tools/testing/selftests/mm/.gitignore
> +++ b/tools/testing/selftests/mm/.gitignore
> @@ -1,63 +1,13 @@
>  # SPDX-License-Identifier: GPL-2.0-only
> -cow
> -hugepage-mmap
> -hugepage-mremap
> -hugepage-shm
> -hugepage-vmemmap
> -hugetlb-madvise
> -hugetlb-read-hwpoison
> -hugetlb-soft-offline
> -khugepaged
> -map_hugetlb
> -map_populate
> -thuge-gen
> -compaction_test
> -memory-failure
> -migration
> -mlock2-tests
> -mrelease_test
> -mremap_dontunmap
> -mremap_test
> -on-fault-limit
> -transhuge-stress
> -pagemap_ioctl
> -pfnmap
> -process_madv
> -*.tmp*
> -protection_keys
> -protection_keys_32
> -protection_keys_64
> -madv_populate
> -uffd-stress
> -uffd-unit-tests
> -uffd-wp-mremap
> -mlock-intersect-test
> -mlock-random-test
> -virtual_address_range
> -gup_test
> -va_128TBswitch
> -map_fixed_noreplace
> -write_to_hugetlbfs
> -hmm-tests
> -memfd_secret
> -soft-dirty
> -split_huge_page_test
> -ksm_tests
> +*
> +!/**/
> +!*.c
> +!*.h
> +!*.sh
> +!.gitignore
> +!Makefile
> +!config
> +!settings
> +#Re-ignore generated files
>  local_config.h
> -local_config.mk
> -ksm_functional_tests
> -mdwe_test
> -gup_longterm
> -mkdirty
> -va_high_addr_switch
> -hugetlb_fault_after_madv
> -hugetlb_madv_vs_map
> -mseal_test
> -droppable
> -hugetlb_dio
> -pkey_sighandler_tests_32
> -pkey_sighandler_tests_64
> -guard-regions
> -merge
> -prctl_thp_disable
> -rmap
> +*.mod.c
> --
> 2.54.0.rc1.555.g9c883467ad-goog
>

