Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C4107C61DBD
	for <linux-mm@archiver.kernel.org>; Fri, 28 Aug 2026 15:22:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7C1B56B0088; Fri, 28 Aug 2026 11:22:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 772806B008A; Fri, 28 Aug 2026 11:22:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6892E6B008C; Fri, 28 Aug 2026 11:22:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 440056B0088
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 11:22:28 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id CDAB71603DA
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 15:22:27 +0000 (UTC)
X-FDA: 85151044734.12.ECF5F8E
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf10.hostedemail.com (Postfix) with ESMTP id F338FC0008
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 15:22:25 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=iP1lnHdg;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf10.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787930546;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kNGMDjL56BsDpLui7jUlzaOLxDFLXDrj8CZ+FT0IdGc=;
	b=WiMQcIG7BDAhGyIM+ytNLC8LWOgEksBhnLDYhmZMHrg7RxL+6bntri+UujNlS8oYdu7u5V
	dtPbFoj7p8c+ESTkdj/V87ec6M2t+3T/Mqnr7oI25nSAQu06s5gvPPJIw9osaViOwiL7pE
	x3KOf0y27WSDbJdwBfKFVFFP4cUeqLI=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=iP1lnHdg;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf10.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787930546;
	b=OoUY7XCfKwbwBUfzgR3EFUa+X0aq5zh4TGVEwni0NkW8wT0qfzS5O7oK3kFyaI7GoiMq2l
	bKhrlun9nV52mB6VrdICeSAVCFQ0mHNzUJ1Fep86iT6lRfQ6hhbimpVKoEbuH4rnRPAzvt
	2gXgoQ1M1D2P7hQIqHBVD5aHEq11J/c=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 44F541570;
	Fri, 28 Aug 2026 08:22:21 -0700 (PDT)
Received: from e129823.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id F01223F7D8;
	Fri, 28 Aug 2026 08:22:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1787930545; bh=DeoGFjBx4QLJFcn9hvDThwnNjY7LxUiYB4ZZ9ewETl0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=iP1lnHdg/9SHv+4JNCQ7rQjXirwsx40DhHTEyr7I0/55vHHoe6LgJqGsGDhKr/jfK
	 M2pOWxa4Us+u+fR0QBf0ZVWt0rXfJ4osSoW5Mi9gWwYfixqt/7/SHTyz/MBbck2n6u
	 5hGNxmUuwR53Rq+/Zkld5N+Ru3N2Db8y+AjqDaE0=
Date: Fri, 28 Aug 2026 16:22:19 +0100
From: Yeoreum Yun <yeoreum.yun@arm.com>
To: Zi Yan <ziy@nvidia.com>
Cc: Yeoreum Yun <yeoreum.yun@arm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
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
Message-ID: <apGnq7HNAbPOQhLO@e129823.arm.com>
References: <20260828-fix_split-v3-0-374022586a4b@arm.com>
 <20260828-fix_split-v3-2-374022586a4b@arm.com>
 <DL0OA5ZF6VX2.33NA9XE20959G@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <DL0OA5ZF6VX2.33NA9XE20959G@nvidia.com>
X-Stat-Signature: pu9mchew33irwkm66qaohkxxaf3uz75q
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: F338FC0008
X-Rspam-User: 
X-HE-Tag: 1787930545-840024
X-HE-Meta: U2FsdGVkX1/3LWbarPQfjmE96Xi41GbxY/dhEmZHJE29HXch8+d/t3lxTQS3zL1aPJTqaZMMSfK88dXMJYs0jDBrwcGGY0WCWeGbG/7dD2vf1K/keCEzmbO/MyKG5sGuZAWuZG7wseADVy9XjRrPvDCe+/j9XbaM+IOz4oAjEOxo22C+5z4AN2ALEPxkkdg0YgSD7cafoukxmm4g5vWPdbzoVghT/cTRic/eUVftEHffqrIQ2aKUr+0f6LVV9WoAbhoRhqHJVqgTLAeSEAmY9GW7VzvLdLnuMtJ58UdqKFLj5R+bFdAgfCMV9zIZSLuOtzh7MXpm40pDZpzLS5SQSMEou7a+B8sHu2sqzMvyKxk8G81zTRSgxIoy85NifR2QIpFfA3zTMsbjdS6w6FrFWzsSNfvzcMF3JuY7c8VJGOO4dFtzeFfv+igJQX8Ny3uCsqo2TmwbqlwHgMnqE8XYseenqk1tdMyF/0aRht2gkcIEjIIhN3u5eZOHcZPjsLHDcAKHLlGsuq6LOQhDHvp9rFbTOojyaKqLya04LiPOlITJsAtIcL9C27ikv8bT7+4nZgpPMkt3k3K0XV2wy01k3mUVNd2ghOi5pMJe0k9Lba6AbhA0zvdsPZoTXXVayHquDpmvT2NFeheHbF5Ojyu4vyevu1JNqo59OuKfnUqmYeQ0XvMBNa3agrSM2OLg4KpqLk2OZGM7PiXaRKl3+PhlHC1F76KGZj7JIv/yLzvSI2HptlUGLOJXgUFNUfZHdnPcSP8efuO6YZZyXK4KM1PHVnoDCawvdRSeJhNwLLBfzG+K2JnMsEC6ET2ZQgy62U+HNKg9cfkO7F294z9Q95/hIqow5BmQ1vhulM5/V0jz/xS9EJUtEdbPtJe4Goapjd/D8LBdkm9ou9X3rXmkEDvsC1L3y8FQfqLu9rGJyr4elzIUC6xFF5lTan7RgGvWJHEYl1ha8AMutMxGghFrwK/
 ZvsnHWKW
 gF7j1ewf9F8rxCE+nyrxTJsaFcRknRZ05C8FBPnnXPGsTuu/3QP75CLJEExG2Yg6BXk/Sxn+QUzWwDTWwsjl7miH+sLe7fI+etCDUqHPq8bB8/aZ8gIyATSK/g/DJGDQSqZVwZH4mA6dDDzP/RQTWbHjjkXRXz43rhlMn+ymXnCWDBd1kSg1P6i+CVNAuqdSf9ublqSrCXLbpTJDWrzI8b6lcjEkuc4kGwpYc+MS9so9HJXMNhyQJZ9aOKGncRUGt1nsowuU/TF4M159bVUESoExDSfaoHPYOCQIbNCfNxukdRTMAszrL0Lj0sS6q/HXwRdhp6b9/fP9sQR9ZE0QIVVGaweYjs3NJdHJIfUOOgB8P4dFhp9lENWPf9hw4win8IPZ0ah3AIStFh9Sls67/i7q/e/gqnSS6Swsy
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 28, 2026 at 11:13:00AM -0400, Zi Yan wrote:
> On Fri Aug 28, 2026 at 4:11 AM EDT, Yeoreum Yun wrote:
> > Since glibc commit 321e1fc73f (“malloc: Enable 2MB THP by default on AArch64”),
> > glibc may call madvise(MADV_HUGEPAGE) for sufficiently large allocations
> > made by memalign().
> >
> > The underlying VMA may start at a different address from the aligned
> > address returned by memalign(). Furthermore, a subsequent
> > madvise(MADV_HUGEPAGE) call does not split the VMA because the flag is
> > already set.
> >
> > This causes split_huge_page_test to fail because the check_huge_xxx()
> > helpers incorrectly require the address returned by memalign() to
> > match the VMA start address reported in /proc/self/smaps.
> >
> > Fix this by using /proc/self/pagemap and /proc/kpageflags instead of
> > /proc/self/smaps to detect huge pages.
> >
> > Reported-by: David Hildenbrand (Arm) <david@kernel.org>
> > Suggested-by: Zi Yan <ziy@nvidia.com>
> > Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
> > ---
> >  tools/testing/selftests/mm/vm_util.c | 145 ++++++++++++++++++++++-------------
> >  tools/testing/selftests/mm/vm_util.h |   1 +
> >  2 files changed, 92 insertions(+), 54 deletions(-)
> >
> > diff --git a/tools/testing/selftests/mm/vm_util.c b/tools/testing/selftests/mm/vm_util.c
> > index 4821a3563036..083b72d92b14 100644
> > --- a/tools/testing/selftests/mm/vm_util.c
> > +++ b/tools/testing/selftests/mm/vm_util.c
> > @@ -351,31 +351,13 @@ char *__get_smap_entry(void *addr, const char *pattern, char *buf, size_t len)
> >  	return entry;
> >  }
> >  
> 
> <snip>
> 
> > +	for (; start < end; start += scan_mapping_size) {
> > +		categories = pagemap_scan_get_categories(pagemap_fd, start);
> > +		pfn = pagemap_get_pfn(pagemap_fd, start);
> > +		if (pfn == -1UL) {
> > +			if (!allow_nonpresent)
> > +				goto out;
> > +			else
> > +				continue;
> > +		}
> > +		if (pageflags_get(pfn, kpageflags_fd, &kpf))
> > +			ksft_exit_fail_msg("read kpageflags: %s\n", strerror(errno));
> > +		if (check_pmd_mapping && (categories & PAGE_IS_HUGE))
> > +			nr_pmd_mappings++;
> > +		if (kpf & KPF_COMPOUND_TAIL)
> > +			continue;
> > +		if (!check_huge_type(categories, kpf, type))
> > +			goto out;
> > +	}
> > +	
> 
> There is a trailing tab.
> 
> > +	if (check_pmd_mapping && (nr_pmd_mappings != nr_hpages))
> > +		goto out;
> > +	ret = true;
> > +
> > +out:
> > +	close(pagemap_fd);
> > +	close(kpageflags_fd);
> > +	return ret;
> >  }
> >  
> 
> Otherwise, LGTM. I assume the replacement of memalign(), from the
> discussion between you and Lorenzo, will be added in a separate patch.
> For this patch,

Yeap. I'll post with the separated one.

> 
> Reviewed-by: Zi Yan <ziy@nvidia.com>

Thanks!

-- 
Sincerely,
Yeoreum Yun

