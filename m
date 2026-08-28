Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B09B2C61DBD
	for <linux-mm@archiver.kernel.org>; Fri, 28 Aug 2026 14:35:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AE8EE6B0092; Fri, 28 Aug 2026 10:35:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AC0516B0098; Fri, 28 Aug 2026 10:35:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9D60E6B0099; Fri, 28 Aug 2026 10:35:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7DC176B0092
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 10:35:48 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 129BE1603BD
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 14:35:48 +0000 (UTC)
X-FDA: 85150927176.29.8003E1B
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf25.hostedemail.com (Postfix) with ESMTP id EF535A0002
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 14:35:45 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=AGSQi1TR;
	spf=pass (imf25.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787927746;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xZuPhDlP4oiv70zC76MQUzWFx5+Le0BCoygOwCGw0us=;
	b=aCpFvQb0ov02gi5ojWnrq3c1pRcKsuHodw6jxMXmmtonzcxBlSexmo7rWvhl4DmQqCwaoo
	AU5kQekdSy+xTADBTLKUH/Oxh4bvxEtmm/LCMGl1k8WL4nXsOD1/PpxQq83lA5De79IQmR
	qCVeReFUfjv1c/h+HCZOSB1JXKAOjWA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787927746;
	b=hqeGxpkuytdzYD6w2mbDhKpQo85aLhKI42dy095YpWCtLpN4sRvtGmP4TcA4dshbPVcG6/
	jz2Zji4+dOdFr6xS/JdqmPucN4W/GPM7jFfpdMSZ73t7I/A0x467S0P1s7v/bBvIvBdVz2
	AaAJ04PC/WqKsO3eI9fYTIYFpLvxrYk=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=AGSQi1TR;
	spf=pass (imf25.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E222514BF;
	Fri, 28 Aug 2026 07:35:40 -0700 (PDT)
Received: from e129823.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 9E25A3F85F;
	Fri, 28 Aug 2026 07:35:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1787927744; bh=GEQqJb7ZJiF14KfX2zAfeBZ+4mYFVAPuL2qPuZG//aI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=AGSQi1TRSmfg1FbkdYNLZ5UNAIsnrubMGwlnDXd24eTlDAbdHp/EqlnBucndUmOEZ
	 Gpq1XJr3O0EurkEBuWYPt7LZ+ks20tqbTNqw4LhoGb61ZWGMpzqV88Hr0ylm+QmzL1
	 N8hpkSXNAAeKy6SQzzxdVpf+8f/6FTcNzHTYbCQA=
Date: Fri, 28 Aug 2026 15:35:39 +0100
From: Yeoreum Yun <yeoreum.yun@arm.com>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Yeoreum Yun <yeoreum.yun@arm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>,
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
Subject: Re: [PATCH v3 2/2] kselftest: mm: replace usage of /proc/self/smaps
 for check_huge_xxx() helper
Message-ID: <apGcu_haNc93cnzU@e129823.arm.com>
References: <20260828-fix_split-v3-0-374022586a4b@arm.com>
 <20260828-fix_split-v3-2-374022586a4b@arm.com>
 <apFMvo8pCzaGKope@gremlin>
 <apFgVvNMbdhYnu6p@e129823.arm.com>
 <apFhDA4e1sBfDOeh@gremlin>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <apFhDA4e1sBfDOeh@gremlin>
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: EF535A0002
X-Stat-Signature: pmxbi9f99ywx4r4dzdrk1y8yhzjswbb9
X-HE-Tag: 1787927745-314378
X-HE-Meta: U2FsdGVkX18P/wBvPloc81+5ZlTEWv9yL7Ea4nKe7wu1Z/QTi8QJlODE+B1f718l8duERxw7d6n95INiQ6j8rXvz8BT9upsM7H/06dIoOcEiqkyATuB6YekqoDsCtWR1/bcMOrNg3PqDqlw/TDrtZJOfqpzuka5DVViiO6c8Xk27n/P8PdesQeUJ768AZ+VsPtbbCLLz14qMi4pRNMKCNI4lKuZ+hzXfeRHEAdTMN4x2s6GH/ajEfjj7mETVEQf2AQGy3KYVsJa9vZ+7E4MwPAuidOR4F8E82AIQoZ8aNniASkQ2dM3Y/EKFd6dvr4HTgXuPYbPnb2ytbrGwLoGoqlyGBvuBhoNtYR8tVQedKRJP1361p8K03zJ7PVPeDRx4ootyOf9G5JuMYF6pOqSvKH6NdTH2ho+xEtdAnwyhPOooZggPJtVARUtQdcZ8dfr0jQaOXr5BGwvFPvZLfDD8Lsji+Aai8tnwQFaOaBmHRZgRXLbx8t1he7vCeZVuHmuZ9befplQYw3wB5dL4hrHk6aC7Nxfo/Xy+MiTIUyiKD5gUP7LrPRLB79Ytxj1doFJ3uMFtivnBM36ueu8K5DOUSYkv08dqme9e4gwzTaxl50rPM1kXg008LXs9uA0692hyuLkD1Mc5WrxAeAfTRzBGj6t/INYBj3U1iD7p98ICfhsp3ZM8bHkmUgYR82jSP9koxWNCD7fZlNtbbSnt1SA6lz/iJXE1jiK5uXd6QA65gaWPyrG7hRz8TNAplFg0ly7TlmRCbf0bLRYXxdAyX5431Xk+r2XduWyByRDmH+LklM9Rjxphc+DSLTOAvaZ3jF1JOMLVqvKL0/hTFPzrtwlmdx1igt4llcQZghJjbsX7Yg7rzhCGC6DPRZYtF9utWMrFh48GK5FNHY3opBZBMCbvnrN9z98hbHC8smWep3AtF/GO9x0D8KawDrd+nMj/APpwWouhthW7xeP1UB92cCn
 IKfwoOR0
 IedRgKyW85tcLeIp3JJQAyFTYEEl0hHRqNkRTPZAnZrY6yWU1+AqRKiem1faTegsLFYz0baqw6J4bbW4LFLm7JVEYYGtzlyi0GPIOhd7cUaqKxRK5jh58ZA20yAh3ZeDn4fv0PF2QcrlibQumk+ej73etZ0i9OXZHq55re71xi/iAHVjbxlb/R5JLX5yqCCkrMze9M4H7Ua5ZWSar6Iejz1h6U0LTPl1+jEH4x9b4hISw0IN2EPPk0mB+uREEomRz550UCKvQEICu/EtOKnuCe9y8/KLekQqhcs1LsSuz6ebpx72Ta4DB+ntg7T35Zj/G71HyYdiVD5KoiSc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> On Fri, Aug 28, 2026 at 11:17:58AM +0100, Yeoreum Yun wrote:
> > > On Fri, Aug 28, 2026 at 09:11:34AM +0100, Yeoreum Yun wrote:
> > > > Since glibc commit 321e1fc73f (“malloc: Enable 2MB THP by default on AArch64”),
> > > > glibc may call madvise(MADV_HUGEPAGE) for sufficiently large allocations
> > > > made by memalign().
> > > >
> > > > The underlying VMA may start at a different address from the aligned
> > > > address returned by memalign(). Furthermore, a subsequent
> > > > madvise(MADV_HUGEPAGE) call does not split the VMA because the flag is
> > > > already set.
> > > >
> > > > This causes split_huge_page_test to fail because the check_huge_xxx()
> > > > helpers incorrectly require the address returned by memalign() to
> > > > match the VMA start address reported in /proc/self/smaps.
> > >
> > > Hmm, is the test correctly putting sentinels either side of the VMA? Any test
> > > that doesn't risks flaking due to unwanted VMA merges.
> >
> > I believe that with this change, we don’t need to worry about unwanted
> > VMA merges when checking for huge pages, since the test no longer relies
> > on VMA sentinels but directly checks whether the mapping is huge or not.
> 
> We always need to worry about that though, anything that asserts stuff on a
> VMA level must prevent unwanted merges first.
> 
> I guess I'm asking you in a roundabout way to go check and if there isn't
> isolation like that (i.e. mapping PROT_NONE VMAs around the VMA you want)
> then to go do that :)

Oh. Sorry not to catch your intend. not for only this series but for
the future usage, might it sound reasonable to add some mem alloca
fucntion for the test which could replace memalign() with above concept.

> I think glibc going off and mapping a bigger VMA is possibly a symptom
> of this not being done.

TBH, what user would generally care whether VMAs are merged or not?
Anyway, it would be better to add a helper with some PROT_NONE guards
to prevent unwanted VMA merges while testing.

> 
> >
> > Also, this flaky failure was not caused by a VMA merge, but by a change
> > in glibc’s behavior that sets HUGEPAGE for sufficiently large areas.
> 
> Yep your change is worthwhile reagrdless! :)

Thanks :)

> 
> >
> > Might for the *NO_HUGEPAGE* setup, there would be a chance to merge
> > VMA area, But since it seraches the mapping directly, it's fine.
> 
> As above, generally we should put this protection in case, even if it's
> unlikely for a VMA with VMA_NOHUGEPAGE_BIT set!

Agree. let me add one for this and replace memalign() used in
khugepagd and split_huge_page_test at first.
> 
> >
> > >
> > > >
> > > > Fix this by using /proc/self/pagemap and /proc/kpageflags instead of
> > > > /proc/self/smaps to detect huge pages.
> > >
> > > You should probably call out the fact you're doing some refactoring here
> > > also!
> >
> > Okay. I'll spell out with some detail. Thanks!
> 
> Thnks!
> 
> >
> > >
> > > >
> > > > Reported-by: David Hildenbrand (Arm) <david@kernel.org>
> > >
> > > Should always have a Closes: tag if Reported-by: ideally.
> >
> > Yes. but talked with personally nothing to close. So Reported-by tag
> > only. Would it be better to remove?
> 
> Yeah or Suggested-by maybe? If he said it to you on-list then a Closes:
> <lore link> works also!

Okay. I'll drop the Reported-by: and change to Suggseted-by.

Thanks!

-- 
Sincerely,
Yeoreum Yun

