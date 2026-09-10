Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D5900C79F9F
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 11:16:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EB6526B0093; Thu, 10 Sep 2026 07:16:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E8EB76B0098; Thu, 10 Sep 2026 07:16:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DCB266B00A1; Thu, 10 Sep 2026 07:16:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B61546B0093
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 07:16:12 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 5AC8314048F
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 11:16:12 +0000 (UTC)
X-FDA: 85197598584.17.32416C6
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf11.hostedemail.com (Postfix) with ESMTP id 736FF40005
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 11:16:10 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=IpQKBy3P;
	spf=pass (imf11.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789038970;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2wpTpY3kwjAvihsk8TkHnRkghnVUwK2OYNZl4VSBk1o=;
	b=h1qWnNnsTHQTXcR85uWCSnhRD2AP9/om29H2ols3hh+G/Dtztypniqck1yReavuz15M9ie
	GIryLiw6BX3sm4hdcYs/1bKx77X54oCrvjzm4zRLi0zeICyaWm856m3Qr8KuSYhShfe3w5
	npHma3A4ItACl6RIp69arfVE9W6kOks=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=IpQKBy3P;
	spf=pass (imf11.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789038970;
	b=YYf7ErwrSg48U5ShCyTJ1AYIVviBLSBrp2ekRXuvSdzgmXuv1aiZH75pcFWlyEfW2XtGtg
	P1L6kslvZQFLGpm3FMrTWGu3iPGzr2J6ANZB1Rek+rSITx8c7t4eCDDZX86vrhTnOr0Sb9
	tafO5a84GxqpPnd9gUVwujv7fNrbWvM=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D780C153B;
	Thu, 10 Sep 2026 04:16:05 -0700 (PDT)
Received: from e129823.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 11AAE3F528;
	Thu, 10 Sep 2026 04:16:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1789038969; bh=hVGs1Tj7kpc4YncSVFe0orcF4b5ZciBzk2QmqTOTL1g=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=IpQKBy3P0wIZcjof1RRrgg2w+Zjdva4zQH7AyZLrz7g+fjfIlWrx5ZMYV/yR/L91q
	 H9rkuSYiqw/m5gZVtM3RfvD7IkdW3x48VdMM1F/7nEPsKuz9CAb0nHC3Fxo76Ah0Bq
	 DqA3PUPjOCVrQenLOMhXnt6Wf+NAeNEcd3CPRgps=
Date: Thu, 10 Sep 2026 12:16:04 +0100
From: Yeoreum Yun <yeoreum.yun@arm.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Yeoreum Yun <yeoreum.yun@arm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <ljs@kernel.org>, Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Nico Pache <nico.pache@linux.dev>,
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
	Usama Arif <usama.arif@linux.dev>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>,
	Kevin Brodsky <kevin.brodsky@arm.com>, linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 0/3] kselftest: mm: fix some failure of
 split_huge_page_test
Message-ID: <aqKRdIjAYB2PEwRN@e129823.arm.com>
References: <20260907-fix_split-v5-0-822b810458bc@arm.com>
 <b923f63c-db7c-4ecb-949d-368bc6311626@kernel.org>
 <aqKHHWKvOonYZPy0@e129823.arm.com>
 <21e0a933-63b6-42b4-8cd7-df05b0c9acfc@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <21e0a933-63b6-42b4-8cd7-df05b0c9acfc@kernel.org>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 736FF40005
X-Stat-Signature: xej1osqmmicd119iwgw3tenx7nrwfcpm
X-Rspam-User: 
X-HE-Tag: 1789038970-460738
X-HE-Meta: U2FsdGVkX18GG1GFG4eU0GqEMMJbV9MhfA+1QMsVRbnRyqH6f5Rf1OEio6+XCokyt4JXcrl8rJUvKXH7/kZWSbUStliV8KoY6irZPhG0HkLBKB6bgOz77NDT+y8dsxcFbbW8Bcj8EgylD8VsgO8VnZ4RKf3WAQ0uLEZ/FnjG0LZgQaNL99mF1+RSQkKUrLi4QDUABNvPHf6a6ugNzDmRYXVV+tlMGD9eo5QHmRRAMHo7fyqr7/9bJsBMtrXy6XoLa8/r9L2YSdBuKbV0AzbxG4zkifqcZwvLjzuGBEoSf1dlynlT5bhtVhK5NfPmEPmdjHtUDmggVPL5Il0uvo+5ENWUT5o8queilrvpoU62ESaxALuiU+Gzuma80YQYYmCgWZg8gi7E1J4QtBJB9D//7HUp1xjXYYCT/CNWa2fnJw/W6WtiyKR+U8nPws9WubtZe/SLg9CuX5pIRdSTdufI0fNjLCu5sMl7L8qb3qM/PJ5Z4ry8gMjcy7aLcWFQk4ue+KYFrCYbce8jKS7t6b+UvOjdwurOK0ebYfAeOCHG5ndL1PbE1HkJiEq6RtpDWs14f+Bx3jb+N+Er3eFTzveynuCBBvCYnvdYdaxQ2ppiUxXGT8Jspkh7I6YQR0LRGh+urzmGQ61kAqAN7srQUM0DBujyzxS76Emoj1PyPtENtHdln27WXLIKXmYES6vaAV4mAOofVbl1TQ72yxKLQtiYdwi6GriIpOwNCwiu+U75BjVNMfhKnhqTdv0oLpMwSp4MkyFkT3rAEh9DOhdaUR8UHfoBJh4WmTmykqMgVJ97oe/R2sbAGmGi5iE3GxetESoR32rNpROH3SlXwza2qIzO7x8Dqt497hIMEN3YG89oulBRK4i0oKV5VGYeD6s2Xsg9EVWfOeZKbLBQT69CNHF7PhIDEu1GoHDCc/8VfkJMG5TPVhJS27MEKIWbCgBDPwzSYn4NOy3pMmI0C/Lmgvn
 8U3G47rB
 N+tOUNJo90c37RMqkAgH8dg8hqnptg5ZIs/PX2idSOMVHX6ptHhMyLmvlCfC1suHvO0jlHHKNBs5yeXn8r8wfujBWogJXEGURZghzmMMnssbA3Yd35mRwERrA+qTysjFUbzYrEiK9aig81RhqK/WCkKS2zk6dgCao0cCWYMe0wByMHJCgtJgRGqxDQUIHyjPu/ngZ6X1jOKqKs9VDjUv7brWxWOcui7n741KCEQzvW5inxQg80yTlLGLTVwi0DQ4im2DozHSITpYyfF4YlFRI7AUefa4hw4Nok6tByquigkOGPpFfTKw6jkuCtA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 10, 2026 at 12:45:39PM +0200, David Hildenbrand (Arm) wrote:
> On 9/10/26 12:31, Yeoreum Yun wrote:
> >> On 9/7/26 10:19, Yeoreum Yun wrote:
> >>> split_huge_page_test can fail for the following reasons:
> >>>
> >>>   1. During the test, khugepaged may collapse previously split pages again,
> >>>      causing intermittent failures.
> >>>
> >>>   2. Since glibc commit 321e1fc73f (“malloc: Enable 2MB THP by default on AArch64”),
> >>>      glibc may call madvise(MADV_HUGEPAGE) for sufficiently large allocations
> >>>      made by memalign(). The underlying VMA may start at a different address
> >>>      from the aligned address returned by memalign(). Moreover, a subsequent
> >>>      madvise(MADV_HUGEPAGE) call does not split the VMA because it already
> >>>      has the same advice.
> >>>
> >>>      This causes the test to fail because the check_huge_xxx() helpers
> >>>      incorrectly require the address returned by memalign() to match the
> >>>      VMA start address reported in /proc/self/smaps.
> >>>
> >>> Address these issues by applying MADV_NOHUGEPAGE after faulting in the
> >>> huge page, preventing khugepaged from collapsing it again, and instead of
> >>> relying on /proc/self/smaps, use /proc/self/pagemap and
> >>> /proc/kpageflags to detect huge-page mappings and large folios:
> >>>
> >>>   1. If hpage_size == pmd_pagesize, check PAGE_IS_HUGE instead of
> >>>      using check_large_folios(), since only the mapping type matters.
> >>>      This identifies PMD-mapped huge pages.
> >>>   2. Otherwise, use check_large_folios() to detect large folios. This
> >>>      covers mTHP cases.
> >>>   3. Check the folio flags according to the type of huge page.
> >>>
> >>> Also, current usage of memalign() would result memory area may
> >>> unexpectedly merge with an adjacent VMA, causing tests
> >>> that inspect it through /proc/self/smaps to fail.
> >> I'm not particularly happy about this.
> >>
> >> Relying on VMA merging details rather hints that we shouldn't be using smaps to
> >> query some stats/properties.
> >>
> >> Which exact things are test querying through /proc/self/smaps? Could we convert
> >> the code to just query that stuff through different interfaces?
> > 
> > Well, users currently for using /proc/self/smaps are for check vm-flags:
> >   - guard-regions where using check_vmflags_guard()
> >   - pfnmap test where uses check_vmflag_pfnmap()
> 
> Most vm-flags should not be an issue when it comes to merging. The only
> exception are vmflags that do not prevent VMA merging.
> 
> So it's VM_SOFTDIRTY and VM_MAYBE_GUARD. And I agree that for guard-regions.c we
> likely have to care such that we don't merge by accident with other VMAs (guard
> regions).
> 
> But that's independent of memalign.
> 
> ptr = mmap_(self, variant, NULL, 10 * page_size, PROT_READ | PROT_WRITE, 0, 0);
> ASSERT_FALSE(check_vmflag_guard(ptr));
> 
> could be problematic on its own (unlikely but possible).

Yes. That's why I'm think it would be good to use alloc_isolated_mem()
in case of ANON mapping for this case.

> 
> For other flags, you really only have to find the smaps area that covers the
> given address and look at the vm-flags.
> 
> Or am I missing something important?
> 
> (merging vnas with VM_PFNMAP is impossible right now IIRC)

No. what I want to say including the patch #3 is for the above case
where you point out -- ASSERT_FALSE(check_vmflag_guard(ptr)).

Since we don't have any interface to check vm_flags execpt smap
and for memory mmaped with anon would have a chance to merge,
We need something to replace memalign() with preventing unexpected VMA
merge. (But I forgot to change the those case in guard test case).

-- 
Sincerely,
Yeoreum Yun

