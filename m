Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DEECCC79FB6
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 16:40:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E43C26B0095; Wed,  9 Sep 2026 12:40:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DDE2B6B0096; Wed,  9 Sep 2026 12:40:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CF4076B0098; Wed,  9 Sep 2026 12:40:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6C8A06B0095
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 12:40:25 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 1633C1C1C9D
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 16:40:25 +0000 (UTC)
X-FDA: 85194786810.10.E0A3CFF
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf01.hostedemail.com (Postfix) with ESMTP id 29FD640009
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 16:40:23 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=W6YFOARK;
	spf=pass (imf01.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788972023;
	b=WA3SI8xit5QCLgYU4VS19ECfY2CdFx8yXQCUW0rrXlo3DMoYPKn5gz/zcHbqaP7Qs9UPPP
	9ubiqmdAFhs19j4NH1PBDo7/IVLknWmtWyCUPLjdY4dQ7f9QGA1iePf5it9C72btV+ZhGU
	dOrNjiJM6mbI3HR/cMTwUS63PRq+91Q=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=W6YFOARK;
	spf=pass (imf01.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788972023;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZL5Wc7hwYTNXCFHZl6ZQdsEDwRnNdqiMNd8KFoTNtlE=;
	b=mDjNdMWkp1xCRgdC8m0PSuHiRDZmGO69AciaYdZLWS4M/lOmF0UuQIbZ6dJ8Rc3WnNcgn9
	rCFwIaHl+TAzBwkYMkp6yMR5iNfN8lqGm4y8S9PrK1aQ+t5bJiswqSe93zWlFV/S/Fbgz+
	Z24r3pIDbluo8Zwahtvt+GhA+C+kv+s=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5E827143D;
	Wed,  9 Sep 2026 09:40:18 -0700 (PDT)
Received: from e129823.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 6DE4C3F7B4;
	Wed,  9 Sep 2026 09:40:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1788972022; bh=6XjnN978Dt1CGr6VQNju1YCJHuyGfu+F3SjjrJT35fM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=W6YFOARKZ3SJ0/2up84RYOHIhVCP6MpsBMruInjgerNed3lmW1q9joM1eA/CxSCqe
	 wY0GsZKbobnLgiOyd6MACJ/jJiq2vf8nG8SDdWQqBZNCkx8ddBlPOag4biABWFR2nn
	 skfUDv0tOnXnAJ0FriXbSTh2yNKHmpOLIpiP5UxI=
Date: Wed, 9 Sep 2026 17:40:17 +0100
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
Message-ID: <aqGL8X3OeGlsEnF8@e129823.arm.com>
References: <20260907081509.924979-1-yeoreum.yun@arm.com>
 <9f8c6e91-c1c8-4ec5-96a9-9d6d4ab571cc@kernel.org>
 <ap_GBdbMIkasmVO4@e129823.arm.com>
 <0d93cd99-e1b2-46cb-ae31-a2dc4ca63d2a@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0d93cd99-e1b2-46cb-ae31-a2dc4ca63d2a@kernel.org>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 29FD640009
X-Stat-Signature: rx1qgw9qedwswy3j3jf5ursesnq7gsm5
X-Rspam-User: 
X-HE-Tag: 1788972023-874612
X-HE-Meta: U2FsdGVkX1+mZ3yXdSTZN0eSzudspqFdaa+HxM2oP3Hu/1ehp9jLzIXeWT57mL7JrYVbhbyocObjcb6stKFMdZpCQ7JaXNE1E7nbg0x3BS0Z5aePam3ykZEg3dLo5Ca4aF3H2SdiLhRx3kYVVD8p2y+3xYmo9ZV/9bRb23mOJOz83yCPbICi7ICRlrKYWm74Caj+ZTikjuONBIz8kIlF6D+mBBP+zSrWWXXrN6Th1jB4V5teoLTlrJ4A7n3wgi9vu+Q9FB4s9Mn4tP5ug8Z+o8aOVCrtw+MNDVY9/QYwJnPF2JVb+bikP5afcSnM09jKHYYrp6Xcp7Q7VrwCUod201MxphvxGYAg23VzYX0OAFmZ4nPWS/i/LfHx+a1sxL/C6cDuIJhzBdsuYB/kVl6pK74Mz3DCx9VZtkAOWMkMnv5HjPzaCZnBHQXSTlpmpH9udkdJR901/OJMP8CK161OYD71UvFrZyezirlKIOGpgS5IjZeRX5zL69SjKF8BZhw3PPq0ROgOheJNYD071hON/cH6mZSsOfMbie7csz466t2pbezMvSXldpWYkJpwuQu5AYmaB3qHJBL4Gl0nYKXePOn+Ikj5DiivGv6SeHxuOCuRQWD3Jc6qJz0swuocKU0Z0GESMZt6GST3S9fzZgiJo7Nxnbj0AlYl1F2oiprteDWfdPqTP/CpqYDESf1ETCgzGgVjk/NT6NDbMeO+tmTkZ0GTNAnW90yuwC+sFREY7YCIuyMvfpSyacgoDfl1VZLvz+nW/I/Kzrwkuux2ka3g3jhZybZv9fTL3rRbL9Chzrc2zC1uJTvDUoHX83Atx8ymcm3fvp0Y0I6MAjPDd6eQHcSmbtI4UF6f9Lpwz/5kAIgJb7Ml0mx7JkbFv3RzOZ9m/nnD4VYQ949wiOkuoLJ38xoL3zujHHU6jEuXOVHpPZBMZrL+105cpm+dHWuj/Cjdkb4C50JPtlMtaFt8O9S
 TgUupA1m
 4rmgVm6i+VTwCEh+fxVuzS5bWe26L4bYINNzlW2SOFdpXP5e+gIy+FQqw5GoK/oErjEG5kYncOEDqcFMCwiaYFPAlkLKMy+N5Xw9EYca0iIfwLsV1C7Jd/5WM+CQtJPbLZvxZBRdijUIXltkBUQoNNbhvguTmBDydhM4vUhiV11XMgvuK2BKBakzVORyWr7O++0hruVzTrzNG+Q/TMc+aqvRc3o2/RYSt8okFlqATYj6f+4yeS/7HDrNGEszoJXC0kectI9FBgYjtPHReLhH/kE6E4QgIEo39u6NC64/htFOoo4gboun6UWW28fk70SEdjxljlTO2RCCqT8LxmhJPPwzxes2eWjLB+4hUzU6G6F6BRXNK6pRoGjN5Rw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 08, 2026 at 12:21:31PM +0200, David Hildenbrand (Arm) wrote:
> On 9/8/26 10:23, Yeoreum Yun wrote:
> > On Mon, Sep 07, 2026 at 04:36:56PM +0200, David Hildenbrand (Arm) wrote:
> >> On 9/7/26 10:15, Yeoreum Yun wrote:
> >>> HPAGE_SIZE and HPAGE_SHIFT macro is written based on the 4KB PAGE_SIZE.
> >>> When this macro is used in some test, test result would be strange in
> >>> the system where PAGE_SIZE is more then 4KB.
> >>>
> >>> Here is the example with transhuge-stress test with 16KB PAGE_SIZE:
> >>>
> >>>   transhuge-stress: allocate 61073 transhuge pages, using 122146 MiB virtual memory and 1908 MiB of ram
> >>>     3.292 s/loop, 0.054 ms/page,  37106.002 MiB/s	2566 succeed, 58507 failed, 2566 different pages
> >>>     0.591 s/loop, 0.010 ms/page, 206850.792 MiB/s	   0 succeed, 61073 failed,    0 different pages
> >>>     0.527 s/loop, 0.009 ms/page, 231895.107 MiB/s	   0 succeed, 61073 failed,    0 different pages
> >>>     0.527 s/loop, 0.009 ms/page, 231839.704 MiB/s	   0 succeed, 61073 failed,    0 different pages
> >>>     0.528 s/loop, 0.009 ms/page, 231544.782 MiB/s	   0 succeed, 61073 failed,    0 different pages
> >>>     0.528 s/loop, 0.009 ms/page, 231462.074 MiB/s	   0 succeed, 61073 failed,    0 different pages
> >>>     0.527 s/loop, 0.009 ms/page, 231770.300 MiB/s	   0 succeed, 61073 failed,    0 different pages
> >>>     ...
> >>>   ok 1 Completed
> >>>
> >>> Remove the HPAGE_SIZE and HPAGE_SHIFT macros and introduce pmd_page_shift()
> >>> helper to get the HPAGE_SHIFT properly. For HPAGE_SIZE, use pre-existing
> >>> helper, read_pmd_pagesize().
> >>>
> >>> Also, run the KSM_MERGE_TIME_HUGE_PAGES test with a size of 512 MiB,
> >>> which is the least common multiple of the PMD sizes for 4 KiB, 16 KiB,
> >>> and 64 KiB base pages. Since allocate_transhuge() allocates mappings in
> >>> PMD-sized units, the test may fail with the previous size of 100 MiB,
> >>> which is not a multiple of the PMD size when the base page size is
> >>> 16 KiB or 64 KiB.
> >>>
> >>> After this patch, output of transhuge-stress:
> >>>
> >>>   transhuge-stress: allocate 3817 transhuge pages, using 122146 MiB virtual memory and 119 MiB of ram
> >>>     2.558 s/loop, 0.670 ms/page,  47755.759 MiB/s	2585 succeed, 1232 failed, 2585 different pages
> >>>     2.640 s/loop, 0.692 ms/page,  46268.432 MiB/s	2585 succeed, 1232 failed, 2585 different pages
> >>>     2.635 s/loop, 0.690 ms/page,  46360.298 MiB/s	2585 succeed, 1232 failed, 2585 different pages
> >>>     2.782 s/loop, 0.729 ms/page,  43899.795 MiB/s	2616 succeed, 1201 failed, 2616 different pages
> >>>     2.692 s/loop, 0.705 ms/page,  45380.876 MiB/s	2627 succeed, 1190 failed, 2627 different pages
> >>>     2.612 s/loop, 0.684 ms/page,  46765.812 MiB/s	2628 succeed, 1189 failed, 2628 different pages
> >>>     2.683 s/loop, 0.703 ms/page,  45520.990 MiB/s	2630 succeed, 1187 failed, 2630 different pages
> >>>     2.727 s/loop, 0.714 ms/page,  44789.321 MiB/s	2631 succeed, 1186 failed, 2631 different pages
> >>>     ...
> >>>   ok 1 Completed
> >>>
> >>> Suggested-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> >>> Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
> >>> ---
> >>
> >>
> >> [...]
> >>
> >>> diff --git a/tools/testing/selftests/mm/run_vmtests.sh b/tools/testing/selftests/mm/run_vmtests.sh
> >>> index d09f9f6a384e..24aa1de27c25 100755
> >>> --- a/tools/testing/selftests/mm/run_vmtests.sh
> >>> +++ b/tools/testing/selftests/mm/run_vmtests.sh
> >>> @@ -360,8 +360,8 @@ fi
> >>>  CATEGORY="memfd_secret" run_test ./memfd_secret
> >>>  fi
> >>>  
> >>> -# KSM KSM_MERGE_TIME_HUGE_PAGES test with size of 100
> >>> -CATEGORY="ksm" run_test ./ksm_tests -H -s 100
> >>> +# KSM KSM_MERGE_TIME_HUGE_PAGES test with size of 512
> >>> +CATEGORY="ksm" run_test ./ksm_tests -H -s 512
> >>
> >>
> >> Why the magic value 512? (desrves a comment)
> >>
> >> A clear sign that the ksm tests must be rewritten to be standalone and just
> >> handle this internally. @Sarthak
> > 
> > Acked. I thought it's enough to spell out in commit message but
> > I'll spell out into comment too in this round not refactorying by me
> > for ksm test.
> > 
> >>
> >>>  # KSM KSM_MERGE_TIME test with size of 100
> >>>  CATEGORY="ksm" run_test ./ksm_tests -P -s 100
> >>>  # KSM MADV_MERGEABLE test with 10 identical pages
> >>
> >> [...]
> >>
> >>> index 4821a3563036..f75bf0bacd18 100644
> >>> --- a/tools/testing/selftests/mm/vm_util.c
> >>> +++ b/tools/testing/selftests/mm/vm_util.c
> >>> @@ -21,6 +21,8 @@
> >>>  
> >>>  unsigned int __page_size;
> >>>  unsigned int __page_shift;
> >>> +uint64_t __pmd_page_size;
> >>> +uint64_t __pmd_page_shift;
> >>>  
> >>>  uint64_t pagemap_get_entry(int fd, char *start)
> >>>  {
> >>> @@ -161,6 +163,9 @@ uint64_t read_pmd_pagesize(void)
> >>>  	char buf[20];
> >>>  	ssize_t num_read;
> >>>  
> >>> +	if (__pmd_page_size)
> >>> +		return __pmd_page_size;
> >>> +
> >>>  	fd = open(PMD_SIZE_FILE_PATH, O_RDONLY);
> >>>  	if (fd == -1)
> >>>  		return 0;
> >>> @@ -173,7 +178,25 @@ uint64_t read_pmd_pagesize(void)
> >>>  	buf[num_read] = '\0';
> >>>  	close(fd);
> >>>  
> >>> -	return strtoul(buf, NULL, 10);
> >>> +	__pmd_page_size = strtoul(buf, NULL, 10);
> >>> +
> >>> +	return __pmd_page_size;
> >>> +}
> >>> +
> >>> +uint64_t pmd_page_shift(void)
> >>> +{
> >>> +	if (__pmd_page_shift)
> >>> +		return __pmd_page_shift;
> >>> +
> >>> +	if (!__pmd_page_size)
> >>> +		__pmd_page_size = read_pmd_pagesize();
> >>> +
> >>> +	if (!__pmd_page_size)
> >>> +		return 0;
> >>> +
> >>> +	__pmd_page_shift = (ffsl(__pmd_page_size) - 1);
> >>> +
> >>> +	return __pmd_page_shift;
> >>>  }
> >> The interface is a bit inconsistent.
> >>
> >> read_pmd_pagesize() vs. pmd_page_shift().
> >>
> >> Consider renaming read_pmd_pagesize() to pmd_pagesize() in a cleanup patch.
> > 
> > Okay.
> > 
> >> ... or (better?) adding a size_to_shift() helper instead?
> >>
> >> I think most places that want the shift also want the size.
> >>
> >> So this can just be
> >>
> >> const uint64_t hpage_size = read_pmd_pagesize();
> >> const uint64_t hpage_shift = size_to_shift(hpage_size);
> >>
> >>
> >> In size_to_shift(), you can just handle
> >>
> >> if (size == 0)
> >> 	return 0;
> > 
> > Hmm, most of tests care mainly two sizes and shiftes --
> > psize()/pshift() and pmd_pagesize() and pmd_pageshift().
> > 
> > Would it be better to keep both kinda of helpers and
> > add size_to_shift() helper for nother hpage size then?
> 
> Works for me as well. As long as it's consistent.
> 
> Maybe even pmd_psize() and pmd_pshift() to match our custom psize() and pshift()?

Yeap. That would be better. I'll repsin soon.

-- 
Sincerely,
Yeoreum Yun

