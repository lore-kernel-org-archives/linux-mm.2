Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B9267CA1012
	for <linux-mm@archiver.kernel.org>; Sat,  6 Sep 2025 08:00:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1040F8E0005; Sat,  6 Sep 2025 04:00:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0DC178E0001; Sat,  6 Sep 2025 04:00:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0189F8E0005; Sat,  6 Sep 2025 04:00:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E5A2F8E0001
	for <linux-mm@kvack.org>; Sat,  6 Sep 2025 04:00:46 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 72F0613AF95
	for <linux-mm@kvack.org>; Sat,  6 Sep 2025 08:00:46 +0000 (UTC)
X-FDA: 83858078892.10.F574A08
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id E0196160002
	for <linux-mm@kvack.org>; Sat,  6 Sep 2025 08:00:44 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Mfgbgrxj;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757145644; a=rsa-sha256;
	cv=none;
	b=vsVT8NJOpnu03DP5X8vGL977/mTW0j60h5ROYsyX/W2voKZUz01WR4R3wMlb4yxnau77Ty
	YRatWihnUJ2OBwvyU1ILNMXqcXlsJ33Jxv+hSwjYr+Rg8kpCSvmwpBK2gF72g50strnIQM
	LRkbKay249RJcUmu6xbQ8DqctkKItrA=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Mfgbgrxj;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757145644;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=02cnhVonm/O4IkPwEVbuli2JQLVOE0cQbBtK5D0Ka5I=;
	b=TFppbIDmqM/Xn5VxM1FMD1BoxW2i/lx4LLvozSDgkzUK5A/7vC+TKaFlNyhXlUnI/2ouoo
	TmLrhjnT30Pd8DuOxQ/BSCSLqen7w0d8jBzcMK1mIW6kHI/bGRcZyJ0LEHR0YKJIWZbmCg
	OBGKiTt1DDsIVD+T5p91RULvd0EzfP8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 17DA4601B8;
	Sat,  6 Sep 2025 08:00:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09034C4CEE7;
	Sat,  6 Sep 2025 08:00:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757145643;
	bh=4x0+31hirmJLFHqn1Gbe0i4lASpQFclhxfD/Z965jcM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=MfgbgrxjfUUGBQw34eWYTowBbHzbhcpGWKdpiWiSOIi2ZqMnBgb4YhZk8Fyu/wsEC
	 DGHBHCRddCy78RgseoO649PcLuY79falVTct9qfShmyh+VkD1WU5kUXPUIs04dZH7W
	 ncg93jZY9xo/UxEYesta0MZfFFYd8XfKvTBS1Wpyt8ws2US5QNGaLD0J5eqgiDPXRQ
	 cR/BCRyw8PMOkuKQj2tYAjjMCG5lS/qgpcR8R11aNMmFLZUcY/YsVtf3jbX9wEIwcE
	 GJi3nfww0zy+zas8F+a4+EhO4IpdK+OaRI8bJgOB8V/9z+oLnjCdqoOkwzaEMIaxE5
	 I8bBTIlanrIyQ==
Date: Sat, 6 Sep 2025 11:00:36 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Kiryl Shutsemau <kirill@shutemov.name>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@redhat.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org,
	Usama Arif <usamaarif642@gmail.com>
Subject: Re: [PATCH] tools/mm: Add madvise tool
Message-ID: <aLvqJKtOgGEZxPeN@kernel.org>
References: <20250904175729.1029735-1-kirill@shutemov.name>
 <aLrCfvlhWRCEmwXc@kernel.org>
 <txdm2edac7x6bfxcnjri5g4e5qoz4qhbtwi7bpdta6yqeseroo@iqspqwpo24i5>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <txdm2edac7x6bfxcnjri5g4e5qoz4qhbtwi7bpdta6yqeseroo@iqspqwpo24i5>
X-Rspamd-Queue-Id: E0196160002
X-Stat-Signature: x7ycxmkpdo8kjwgow6km5mxkifgbyfcg
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1757145644-318813
X-HE-Meta: U2FsdGVkX1/SqvnGLWjzacJegMb1UEczORJrgpLMS96Vyd/6lMukTwlPstUMywpIuT+f5dzd795vTYmRFT6CI+VF0CAOwmYqjHPavrrev55sA8i018th9nitMwA+nHaSIcVlFg2M8jKi5PM7SW96llDPpSGNNcRRHHv/EvVDi5EK4NpRXFvF59WGn0aYHhL6EWORHVtl8tROod7ko/pLF9nz76BRKyRZ03H9qMM8l77pNEbb+7cxnununps26nNBi8UXU3vXWBp2BUHc9/7eBM9oGCFY8Z3tVhSRuS0o1LjiE+383ntuHMdutkfF5MeV8HZhjdfHgCUBtGddf9aVQTOqX1oVO1DvOPyQKp11udX8XhjPhgo24zBF7CVXNjwqaPLiWk6xM5h2mbQ6Sl9992JQzdc5HRe7LonJ5z4h8z15aAzC+9hoPDeyXX5itcFiRvoZ+tOW94pvNKdTCWpj3nzW+nNrsozI3WlC9AHk6s6divcrKl6azZ0VOAUVoiujWh6LXdb02IsXRtqFRHhJZYRF0Q+SOJTCXWKX8yudCAqyZvppNHvVAL0V71ia405y8jCWeNkP3gFOTjlflQnvRXKz1iWhxTIkAP/fAr97ZqbrugyVqyTWFAIE3co+jIT3FnR+X1YG2AvbsOzNTSupYeIbm/d5YJ+8s2d7lNAfXEWhIqvZVitFd0xrzHm65cZFJbyZsf/m7mvm81kB8Ftf0C7vfSMInKGtM1SJmWmlgO2bSlRSIo8V+M6VVvPWJRU3oNXO+Bs1/8BPQ4CuuWZMxw7jD91dEa33xdWZT7qkxkUKpRPwVU5B+U21GruY1Dmmr/2+UdSXuG8Ic8juOUnb5X4bQ6wglqksKyfv7AWfrq6ZXHIXdgK+Fxffh3HF1c7yeGB2y0JvOGxxBoJ3YiZjtMurzvXznKwJJFyLvYw/W0DkrpHWYBqsd9FJpuoqNhpyezkLMjMfUwWAiORtuPX
 3ImiyEdS
 jyy8Bzi5O0S1/SiNHh5QOoI8Y6yXw1v0isKVhCQafhxlemNb9WMepf7560VDOXbqf87neVBg1Z+Avoir2IaaXkJCw6iKaVgjQlpZ+Xd6gqU1an/lhpNIDGflqqNsMNF4gswur3RxJOakoS4piYWTHNNz40A5C86zLh0cp58fmBgyRqWMW2yM2V9MW3OsC3Q1F05Ydhsyh3aFRJsGn0zRc7KEvpz73LddIYeYFYGqgh78oMJBPwhklXOwfXl/uljD/XlHOxL9L07rW7UubKz0bbGxsVg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 05, 2025 at 02:36:36PM +0100, Kiryl Shutsemau wrote:
> On Fri, Sep 05, 2025 at 01:59:10PM +0300, Mike Rapoport wrote:
> > On Thu, Sep 04, 2025 at 06:57:29PM +0100, kirill@shutemov.name wrote:
> > > From: Kiryl Shutsemau <kas@kernel.org>
> > > 
> > > Add a simple tool that allows to issue an advice on a process or a file.
> > > 
> > > It can be useful to experiment with effects of an advice on a workload
> > > without modifying the workload itself.
> > > 
> > > Only supports advices available for process_madvise().
> > > 
> > > Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
> > > ---
> > >  tools/mm/.gitignore |   4 +-
> > >  tools/mm/Makefile   |   2 +-
> > >  tools/mm/madvise.c  | 170 ++++++++++++++++++++++++++++++++++++++++++++
> > >  3 files changed, 174 insertions(+), 2 deletions(-)
> > >  create mode 100644 tools/mm/madvise.c
> > > 
> > 
> > ...
> > 
> > > +		unsigned long addr, hpage_pmd_size;
> > > +		void *p;
> > > +		int ret;
> > > +
> > > +		hpage_pmd_size = read_pmd_pagesize();
> > > +		if (!hpage_pmd_size) {
> > > +			printf("Reading PMD pagesize failed");
> > > +			exit(-1);
> > 
> > Shouldn't it fail only for collapse? Other advices don't depend on THP.
> 
> True. But aligning everybody wouldn't hurt.

Right, but this make the tool unusable for kernels built with !THP. 
 
> I would argue MADV_COLLAPSE shouldn't require this either. You don't
> need PMD to collapse page cache folio.
> 
> -- 
>   Kiryl Shutsemau / Kirill A. Shutemov

-- 
Sincerely yours,
Mike.

