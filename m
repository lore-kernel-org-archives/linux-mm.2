Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C33B4606A31E
	for <linux-mm@archiver.kernel.org>; Sat, 31 Oct 2026 09:20:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VRaEF/4D
Received: by kanga.kvack.org (Postfix)
	id DAFE76B00EF; Sat, 31 Oct 2026 05:20:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D882C6B05B1; Sat, 31 Oct 2026 05:20:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CC4B96B05B2; Sat, 31 Oct 2026 05:20:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AE0DA6B00EF
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 05:20:26 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 4006DA8614
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 09:20:26 +0000 (UTC)
X-FDA: 85382375652.18.B31F670
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 9FC64A0003
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 09:20:24 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="VRaEF/4D";
	spf=pass (imf15.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793438424;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dLwZlfqngcUMXWHHM0GFPkimZNPQuLtLOOkOpLsUjjg=;
	b=p2gTH2dcgT7wWWpyOY6c84FLZ5topNw5lg3kcHk7jfS1Gvjs7y/TB0fy7dFqAmwCJN1v/X
	q/qjlfkNlIdNncRcU+ZVpHSvVYo5me7P5zGdlZaQJ8CaoCr7vDEqxiBurOtTUuyXEs0JM3
	mCDaEIEaDaiOJUjd6uFT4VfINLVZ+Xc=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="VRaEF/4D";
	spf=pass (imf15.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793438424;
	b=y1i0L4imZ7JUnmqHziJhun8IGagZYQSyZtFdET9ZkaK8ttcpM7ui6uwrHNQs+CAncpjsFn
	jF6LnM9i4sowq8s0OAQJFdOLc1l13sq+OKMUhDtlUexQ74kwncn7j83mT6loErAN0stB2d
	CHBfg+krdDGp+HuG+6rkm10QyIW5hwM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7961941E47;
	Sat, 31 Oct 2026 09:20:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44E1A1F000C1;
	Sat, 31 Oct 2026 09:20:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793438423;
	bh=dLwZlfqngcUMXWHHM0GFPkimZNPQuLtLOOkOpLsUjjg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=VRaEF/4DeMBVRS71BuPehLobGcZjQr4lbt3Eg5H3r0+MSS/zy7bVsOkDYlcOX2x8t
	 ef/45OQj6sN9w7U1GRdYDZPpCYIPwBvWc93HADX7RFUBJsbXgkUt7juyplVQnOTmge
	 t5bjZ0D9tQed9CbbBroLcc7+hGf2dtFjrjkFWbZTUM8rwn4Ndux5b/2VQa/X648bNV
	 V220Z2PhgazW5bp+GQrfoq3zNnJuN7bx69Ix4qS1/HWYSuKtMWCS4Z++lGdcN91Glx
	 39nz0LpcCAVE/g8qhcslvcIR4JDwOHgF+iZeF7vyQZrQzFidDp8WaoS64i33vvXsG2
	 m3cFWvjbE+6TA==
Date: Sat, 31 Oct 2026 11:20:14 +0200
From: Mike Rapoport <rppt@kernel.org>
To: "Jose A. Perez de Azpillaga" <azpijr@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>, Shuah Khan <shuah@kernel.org>,
	Peter Xu <peterx@redhat.com>, Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>
Subject: Re: [PATCH 0/2] mm/userfaultfd: recheck WP registration in the
 hugetlb UFFDIO_COPY retry
Message-ID: <auWyzvThW5EAT_XQ@kernel.org>
References: <20261029221129.89068-1-azpijr@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261029221129.89068-1-azpijr@gmail.com>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 9FC64A0003
X-Stat-Signature: jpcd719hnjg7iyinthfjcgkhb45mab4e
X-Rspam-User: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793438424-241485
X-HE-Meta: U2FsdGVkX1+kCauXjPAd8r4txyxNXTtG8qffyVawh/gpx9dA7/sla/NG1Mru80FuERy80HKJxboKbZqsencaMG22+/jubIE4T49/p62CMp8YGs0afRUMhXQH258WIAA9JpnOasPp6YsJloFCtgO9VQq8XXS0lPgk3ixORPShKQoXjeFdYXDL1m93s+P4OgFi61uIpWSD7XsXq/k+Sw28qpfbM7bSxAcAXwyfLltFImj6S3eR3fp+S+Zc4LHZ8ClwArez9Sn/Gu5hNp57KQCDqDgb6/wUAOAhR2OZp/2FZYf1n9F6Y1PpM7pUMlHO97A6PBPug0b8wUTUgIDd0YoELNXnrigtxF2zicIlrF2PGm61rIhjnMmuFwSRd/B6aJe6DnMH6na8l7wul3Z+ygiJNSX6aaTswx71Dvj6m6jd2VddNqwYY6NRL0Kz2vhboOsypS+DOghIT9qRxhJLH8QKuQIlYPcN2rDFQFS+ISso0tcQ6y62z3SoDXzV+cZJisfNmh09Lj1tXJ8kmA9o4REDogL9OEfTy/z9CNPIVyS+IAGYR6tAJ7vUkAZYQ+Fl06lcd8W+IJGkWRwS0T17Pmeoe+UFT0Y4jVCcEr+Z34y2eRZ3v/0ieYhnPj4B+07PY9RWgrLC6qrvh4p/F/6438zdY1bHIGA4Yq+aDUNx74udUG+xM2gRXG1sPpQxFlQ10orM3dCsbD55nGbHQNot70gj1Udp4khjQ7P8DbmSllgmYXBFoJWtxaqzC8BsJsY7Kv+/9C8EuBT0ubLroDF0n8XKPC8VbAM1873akDRaqdcOcZ8o2YcXWvlHW70pwvAMJgFslJyt5kcA31hoMk1b+uLWIH8o+5kVumEiqyc98JfpOYFRuWpSVKa/2EHnv7M1ckXyPFJh/Nrv8QkMzVATtrLHoiQ4vPoM5H5Rrlm5O++Mdr9iO0p4OrkyQRLmWUob65iIlUqoXJ5pr5moVixtwZa
 PPOWC/x3
 z5DYpw3ZM+7hzYWPJGbEqOM9DjF39nlIkHHl/7oNRJUhCDGuTsY7VXm/nVdwJiTl2PHbJUkkVhhZk6rOlf/ORY2MdJhL9cda/UX3TKXof9Hxh0AFQSPX9sB1e2/N7rikCXBRN9u/4lw+owNX3CnbEeiiI9queWIohb0zj6zXz+9OzanuYG+zDta6hrr1sPds7B7BJpaIcGXy5VLyyT7fFCqQFWOnuxwsl1CgOyNoeD8las9NEIO7FK4U6qCJUY765G3LCFlQ8h7vj8JKSkxwDevNFOdEG3sN9f+el7Zf5ynGLUHZf9DHnAgY/t8IhY2GZ0KpFCuA/t8q+/4c=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Jose,

On Thu, Oct 29, 2026 at 11:11:00PM +0100, Jose A. Perez de Azpillaga wrote:
> The urgent fixes made hugetlb_fault() tolerate uffd bits left in VMAs
> that are no longer registered for them, and asked for follow-ups that
> remove the sources [1]. This is one: a hugetlb UFFDIO_COPY_MODE_WP copy
> that has to fault in its source page doesn't recheck the WP registration
> before retrying, so re-registering the range without WP in that window
> leaves a uffd-wp PTE behind.
> 
> Patch 1 adds the check the non-hugetlb retry already gets from
> mfill_get_vma(). Patch 2 adds a uffd-unit-tests case for it, which fails
> on hugetlb without patch 1.
> 
> Question:
> 
> - The non-hugetlb retry compares the whole mfill_retry_state. hugetlb
>   copies into a freshly allocated folio, so only WP seemed to matter
>   there. Mike, would you rather have the full comparison on both paths?

Let's keep things simple and easily backportable :)

Since hugetlb does not leave a folio from the original VMA behind there's
no inconsistency we need to worry about.
 
> The other source 6/10 of [1] mentions, UFFDIO_COPY in MODE_WP racing
> with UFFDIO_UNREGISTER [2], is closed by "mm/userfaultfd: write-lock the
> VMA before waking waiters when unregistering" [3].
> 
> Based on mm-unstable.
> 
> Tested on x86_64 in QEMU.
> 
> [1] https://lore.kernel.org/20261015-urgent_fixes-v1-0-42796911043b@kernel.org
> [2] https://lore.kernel.org/20261015-urgent_fixes-v1-6-42796911043b@kernel.org
> [3] https://lore.kernel.org/20261027-fixes_core-v1-23-6f74bec9a5bb@kernel.org (v1, now 23/47 in v2)
> 
> Jose A. Perez de Azpillaga (2):
>   mm/userfaultfd: recheck WP registration in the hugetlb UFFDIO_COPY
>     retry
>   selftests/mm: add a uffd test for re-registering during UFFDIO_COPY
> 
>  mm/userfaultfd.c                             |   4 +
>  tools/testing/selftests/mm/uffd-unit-tests.c | 105 +++++++++++++++++++
>  2 files changed, 109 insertions(+)
> 
> 
> base-commit: 24d45a1475dd4c671feb1df705f67ef2fc293969
> -- 
> 2.55.0
> 

-- 
Sincerely yours,
Mike.

