Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 22481C79FA0
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 08:23:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 13E146B0095; Tue,  8 Sep 2026 04:23:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0F7436B0096; Tue,  8 Sep 2026 04:23:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0073D6B0098; Tue,  8 Sep 2026 04:23:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C6E496B0095
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 04:23:41 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 377F640491
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 08:23:41 +0000 (UTC)
X-FDA: 85189906242.29.4211808
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf05.hostedemail.com (Postfix) with ESMTP id 7E333100002
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 08:23:39 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=MVQe8hDh;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf05.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788855819;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QAeFVTcvUJziK4VZgwcgg2e7VPqTP07F7DWRWoYMU18=;
	b=oddYw6CEFLYDg6OrQnVL5lNgG1wXZ3NUt+poLfOCDhF03kCCOBz7IyeOvQSaghI8HI32UF
	ZZfubiOA6DPEgwE20A1vzKNNCFgHuL2c0gCc9QuZg/XEYT/+HttN7VjV3+N3xm2ECatzMv
	Bk4w39iT/zR26HnGep1GaSqiegBbvPI=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=MVQe8hDh;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf05.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788855819;
	b=bec5gFdglIPOh0jJJaT3AUsb1zURLaSeVVzhYJ0cOa/KGTPoK59B+widGxyrQcudVP2PPr
	rLQz/ueNTUNmksPVfQW1p0Y5WbrenWjER/BJ+UPS1VLvpPC0X4iEgvpAuu6Qb7tj5SIVRy
	pBivwD5TzWEXlhzyQTlgYZoPXJKVZKk=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C4D541476;
	Tue,  8 Sep 2026 01:23:34 -0700 (PDT)
Received: from e129823.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C92EC3F528;
	Tue,  8 Sep 2026 01:23:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1788855818; bh=1cshaF9KXvhKzHME6ySEbcQXIVVb85vLyjPK5BazCe0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=MVQe8hDhvHDJEfbmH6OxwpGF7JrA+cKvf+eM5DA98nWOwzCUZt6oBa0ssa+ju3Mkm
	 PCZGEsWp8AR9FtSmK+Qo2N+uilBWdwAAIOaMTQ9mz6x/Am4CuQBfjAZSq+dk3mEqXS
	 bUqpSqAhr05lk48Y+WIvAfdG0HJ0Z8TvGxFO8IFU=
Date: Tue, 8 Sep 2026 09:23:33 +0100
From: Yeoreum Yun <yeoreum.yun@arm.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Yeoreum Yun <yeoreum.yun@arm.com>, linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org, akpm@linux-foundation.org,
	ljs@kernel.org, liam@infradead.org, vbabka@kernel.org,
	rppt@kernel.org, surenb@google.com, mhocko@suse.com,
	shuah@kernel.org, ziy@nvidia.com, baolin.wang@linux.alibaba.com,
	nico.pache@linux.dev, ryan.roberts@arm.com, dev.jain@arm.com,
	baohua@kernel.org, lance.yang@linux.dev, usama.arif@linux.dev,
	kas@kernel.org, sarthak.sharma@arm.com
Subject: Re: [PATCH v2] kselftest: mm: remove HPAGE_SIZE and HPAGE_SHIFT macro
Message-ID: <ap_GBdbMIkasmVO4@e129823.arm.com>
References: <20260907081509.924979-1-yeoreum.yun@arm.com>
 <9f8c6e91-c1c8-4ec5-96a9-9d6d4ab571cc@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9f8c6e91-c1c8-4ec5-96a9-9d6d4ab571cc@kernel.org>
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: g375p6x8faemj3975xbu1rb9emu5t4xg
X-Rspamd-Queue-Id: 7E333100002
X-HE-Tag: 1788855819-14133
X-HE-Meta: U2FsdGVkX19XxKOdgMooAwK/bxsqeYa8SOEfPbYb//qTMLsrHVJHIadmabuYndqA9/Bd2+ug4izS+LKrEZkFzc9hYO0LOYz2wlajm9oIhTaBa1ov3b1iWCDIM5nlMl4Em5ohbrJ8yUm8WCRKwbyPpeXwD1hndt6314lAt9ai0MoFqUADdjkbx6/PCIo469Ov9H5aXrlMWLXNFp1DKDsyu+3LRbZ7VuR7Ayq+vhVBQSRMOVFBgdvfuNraEhUqceH6Qw2Iu3YuozXiWXHaKaOz9cYhd6GPMcRJ6WnzUPX/Col+wnsfE1Jhw1OWhwRkCs3dWEYtgxeoveYkPytQfUBnBCxh6E/DlnUsybtUlvjKiFH6s8uE5Gmn2pGNGgANO7Ga/LPs6q/0fI6HBRsWueXEo8O+r8QW3fgixBcC9ENKI2+L2PblJyBrhKmoWbmjBaOjA5wOil7fPRS6QwfqsZP8sAK3qqvxI9RUfDMFQqFu8K+4umhTOsJvoVdW8z0aW9EqTlcGsXQtBV5O2jqkWgY7jZg+nMJ2VypBmenCkpw5cDJYZLxdrtHAl9txPMQ9aO5ibxyVwEdgfdGEKdc9OONL1zK5vnueL+uB2gueRip+DQeuKQbrVDcMqDfRbjguTCIV2c+jlpCRHwUnuyq7W8eWiR6LwKzpE2I7w5u6fqOCA0PkXj0aKBBSF2olHMlxP3QcyPRPty8OGkUobBTzOg2XZUz3Z4KX1vHgpKb+xnDx8JDP2yQ2AEr66spJOozoEyyYi7x8+/9MiWOHsF4cfAN4ZIZSrBoUMWYlhiKBXZNNY2qEV+ctPpNoNmcRfawt0pMXfvDsZ3wIpkkA/JDSYemjZiO35EmAkc/ub+FRUsnB2d5NSFQRI/wH8KN5G1tfKc6j8Jll3FGQqHU8NMtcrKZK/63jvA36NYT3vv+hTk4Ot5TdkeeRcaEVqP4LaHmMITHhTwdr6JTevvHbYOGPRcf
 0Mq9diQf
 f8dXQGoJX+oHQ1G2TT43tUPDUVdKpeRfoo4k+LwEpPCeGMSOjJ7u1hQBr17Yv7zmMzU/J7vRnWU6dyzzMjyh1fqnB+8svagCcMrXSaj7qmKcOu67cYNtEpc8DmfBGCwCVIEQuD7F8lEvgFcucvnSZQXUf95RyskvmTZeGmrOd7J/a6bY54cLiCC+yGZWQ/Mx8s56kzMCedqDlEPN+jhtkyaUOk3d7gka88YbUghOHXIOnZINMIJ9fc+dBX3TBMxEpHGwY7ZWo6oO6jRRYRY4Hmw0o6L1i0oUGGFgr4/LRWGDb4YpLWTRbZiPJ7A2oaa1HjLF1DAzBsH9J4BMUEU5udzQl+4aZQ/hIXDrRvCiHhqfOA6esJtLLdtlMkQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 07, 2026 at 04:36:56PM +0200, David Hildenbrand (Arm) wrote:
> On 9/7/26 10:15, Yeoreum Yun wrote:
> > HPAGE_SIZE and HPAGE_SHIFT macro is written based on the 4KB PAGE_SIZE.
> > When this macro is used in some test, test result would be strange in
> > the system where PAGE_SIZE is more then 4KB.
> > 
> > Here is the example with transhuge-stress test with 16KB PAGE_SIZE:
> > 
> >   transhuge-stress: allocate 61073 transhuge pages, using 122146 MiB virtual memory and 1908 MiB of ram
> >     3.292 s/loop, 0.054 ms/page,  37106.002 MiB/s	2566 succeed, 58507 failed, 2566 different pages
> >     0.591 s/loop, 0.010 ms/page, 206850.792 MiB/s	   0 succeed, 61073 failed,    0 different pages
> >     0.527 s/loop, 0.009 ms/page, 231895.107 MiB/s	   0 succeed, 61073 failed,    0 different pages
> >     0.527 s/loop, 0.009 ms/page, 231839.704 MiB/s	   0 succeed, 61073 failed,    0 different pages
> >     0.528 s/loop, 0.009 ms/page, 231544.782 MiB/s	   0 succeed, 61073 failed,    0 different pages
> >     0.528 s/loop, 0.009 ms/page, 231462.074 MiB/s	   0 succeed, 61073 failed,    0 different pages
> >     0.527 s/loop, 0.009 ms/page, 231770.300 MiB/s	   0 succeed, 61073 failed,    0 different pages
> >     ...
> >   ok 1 Completed
> > 
> > Remove the HPAGE_SIZE and HPAGE_SHIFT macros and introduce pmd_page_shift()
> > helper to get the HPAGE_SHIFT properly. For HPAGE_SIZE, use pre-existing
> > helper, read_pmd_pagesize().
> > 
> > Also, run the KSM_MERGE_TIME_HUGE_PAGES test with a size of 512 MiB,
> > which is the least common multiple of the PMD sizes for 4 KiB, 16 KiB,
> > and 64 KiB base pages. Since allocate_transhuge() allocates mappings in
> > PMD-sized units, the test may fail with the previous size of 100 MiB,
> > which is not a multiple of the PMD size when the base page size is
> > 16 KiB or 64 KiB.
> > 
> > After this patch, output of transhuge-stress:
> > 
> >   transhuge-stress: allocate 3817 transhuge pages, using 122146 MiB virtual memory and 119 MiB of ram
> >     2.558 s/loop, 0.670 ms/page,  47755.759 MiB/s	2585 succeed, 1232 failed, 2585 different pages
> >     2.640 s/loop, 0.692 ms/page,  46268.432 MiB/s	2585 succeed, 1232 failed, 2585 different pages
> >     2.635 s/loop, 0.690 ms/page,  46360.298 MiB/s	2585 succeed, 1232 failed, 2585 different pages
> >     2.782 s/loop, 0.729 ms/page,  43899.795 MiB/s	2616 succeed, 1201 failed, 2616 different pages
> >     2.692 s/loop, 0.705 ms/page,  45380.876 MiB/s	2627 succeed, 1190 failed, 2627 different pages
> >     2.612 s/loop, 0.684 ms/page,  46765.812 MiB/s	2628 succeed, 1189 failed, 2628 different pages
> >     2.683 s/loop, 0.703 ms/page,  45520.990 MiB/s	2630 succeed, 1187 failed, 2630 different pages
> >     2.727 s/loop, 0.714 ms/page,  44789.321 MiB/s	2631 succeed, 1186 failed, 2631 different pages
> >     ...
> >   ok 1 Completed
> > 
> > Suggested-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> > Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
> > ---
> 
> 
> [...]
> 
> > diff --git a/tools/testing/selftests/mm/run_vmtests.sh b/tools/testing/selftests/mm/run_vmtests.sh
> > index d09f9f6a384e..24aa1de27c25 100755
> > --- a/tools/testing/selftests/mm/run_vmtests.sh
> > +++ b/tools/testing/selftests/mm/run_vmtests.sh
> > @@ -360,8 +360,8 @@ fi
> >  CATEGORY="memfd_secret" run_test ./memfd_secret
> >  fi
> >  
> > -# KSM KSM_MERGE_TIME_HUGE_PAGES test with size of 100
> > -CATEGORY="ksm" run_test ./ksm_tests -H -s 100
> > +# KSM KSM_MERGE_TIME_HUGE_PAGES test with size of 512
> > +CATEGORY="ksm" run_test ./ksm_tests -H -s 512
> 
> 
> Why the magic value 512? (desrves a comment)
> 
> A clear sign that the ksm tests must be rewritten to be standalone and just
> handle this internally. @Sarthak

Acked. I thought it's enough to spell out in commit message but
I'll spell out into comment too in this round not refactorying by me
for ksm test.

> 
> >  # KSM KSM_MERGE_TIME test with size of 100
> >  CATEGORY="ksm" run_test ./ksm_tests -P -s 100
> >  # KSM MADV_MERGEABLE test with 10 identical pages
> 
> [...]
> 
> > index 4821a3563036..f75bf0bacd18 100644
> > --- a/tools/testing/selftests/mm/vm_util.c
> > +++ b/tools/testing/selftests/mm/vm_util.c
> > @@ -21,6 +21,8 @@
> >  
> >  unsigned int __page_size;
> >  unsigned int __page_shift;
> > +uint64_t __pmd_page_size;
> > +uint64_t __pmd_page_shift;
> >  
> >  uint64_t pagemap_get_entry(int fd, char *start)
> >  {
> > @@ -161,6 +163,9 @@ uint64_t read_pmd_pagesize(void)
> >  	char buf[20];
> >  	ssize_t num_read;
> >  
> > +	if (__pmd_page_size)
> > +		return __pmd_page_size;
> > +
> >  	fd = open(PMD_SIZE_FILE_PATH, O_RDONLY);
> >  	if (fd == -1)
> >  		return 0;
> > @@ -173,7 +178,25 @@ uint64_t read_pmd_pagesize(void)
> >  	buf[num_read] = '\0';
> >  	close(fd);
> >  
> > -	return strtoul(buf, NULL, 10);
> > +	__pmd_page_size = strtoul(buf, NULL, 10);
> > +
> > +	return __pmd_page_size;
> > +}
> > +
> > +uint64_t pmd_page_shift(void)
> > +{
> > +	if (__pmd_page_shift)
> > +		return __pmd_page_shift;
> > +
> > +	if (!__pmd_page_size)
> > +		__pmd_page_size = read_pmd_pagesize();
> > +
> > +	if (!__pmd_page_size)
> > +		return 0;
> > +
> > +	__pmd_page_shift = (ffsl(__pmd_page_size) - 1);
> > +
> > +	return __pmd_page_shift;
> >  }
> The interface is a bit inconsistent.
> 
> read_pmd_pagesize() vs. pmd_page_shift().
> 
> Consider renaming read_pmd_pagesize() to pmd_pagesize() in a cleanup patch.

Okay.

> ... or (better?) adding a size_to_shift() helper instead?
> 
> I think most places that want the shift also want the size.
> 
> So this can just be
> 
> const uint64_t hpage_size = read_pmd_pagesize();
> const uint64_t hpage_shift = size_to_shift(hpage_size);
> 
> 
> In size_to_shift(), you can just handle
> 
> if (size == 0)
> 	return 0;

Hmm, most of tests care mainly two sizes and shiftes --
psize()/pshift() and pmd_pagesize() and pmd_pageshift().

Would it be better to keep both kinda of helpers and
add size_to_shift() helper for nother hpage size then?

-- 
Sincerely,
Yeoreum Yun

