Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 64F0ECAC5B0
	for <linux-mm@archiver.kernel.org>; Tue,  7 Oct 2025 04:33:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A3F538E000E; Tue,  7 Oct 2025 00:33:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9EFED8E000C; Tue,  7 Oct 2025 00:33:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 905B58E000E; Tue,  7 Oct 2025 00:33:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 802CE8E000C
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 00:33:56 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0BC1D1DFB34
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 04:33:56 +0000 (UTC)
X-FDA: 83970050472.19.A601434
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf04.hostedemail.com (Postfix) with ESMTP id 5358940004
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 04:33:54 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf04.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759811634;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=k0cu1a/3V1sQbgDG1X2qCiSxgFdnm2yfGrfZKSW0sjc=;
	b=Mvjej2uzGtGgav/07lxyJ/8BrqGthTRJKOheXKI5Xg+yUIu/z56Jirlt0Rr1msQVsVe6JZ
	lEaCoV4kq7Je0qxkHsEi7visuhF3/6eAEP3xKT+CeZg5nYL1oCbg5iYlMfp6OEJoBiEC3v
	lzuQgJ1OGQb+FizIrWRIsfS9/v/Tz8M=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf04.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759811634; a=rsa-sha256;
	cv=none;
	b=rfC5HiBelq+6sahqKupFTnFXocaylLK6lF/Th6l4fjJPYgKKNEWB0JRWW7NBPDZM69YWh3
	flLI7YvnVCv0WtqMrOfqWZs3dVXCxfBjTNUABMaV6fIqicFA0Qw2DRzRlrc7WDRaFICU/V
	i9AAm+8XxtGAGvO/xWKhvP/YsTPtTDs=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3801214BF;
	Mon,  6 Oct 2025 21:33:45 -0700 (PDT)
Received: from [10.163.65.24] (unknown [10.163.65.24])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id CF6B93F59E;
	Mon,  6 Oct 2025 21:33:50 -0700 (PDT)
Message-ID: <5053378f-8cf7-4cb6-bbab-f0c2f14db677@arm.com>
Date: Tue, 7 Oct 2025 10:03:47 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] mm: readahead: make thp readahead conditional to
 mmap_miss logic
To: Roman Gushchin <roman.gushchin@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>,
 linux-mm@kvack.org
References: <20251006175106.377411-1-roman.gushchin@linux.dev>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <20251006175106.377411-1-roman.gushchin@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 5358940004
X-Stat-Signature: esaqmd8fp4uz18zekkk3szc74x1krbp1
X-Rspam-User: 
X-HE-Tag: 1759811634-344128
X-HE-Meta: U2FsdGVkX19IRVQn+lMZNqh7zLrnEP64L+s5ZprtwUNf3jGhb1yKp3FItq/9ou76zAAdgESHJcpHb7++x70L2eSjWcBt1C+X1Ns1F/gDuPPZ5zzqpTMyKEeNdMJuYnGA3AWKsUaTYYILcJEtp1HdbrQqpZ6udyEAiJX9Z5MG+PQxHsFjs3QEuTX4fxGc0xyVJPlUhW8PQe1R3CrFoNOEVkxdTefP889dY7U4dpz10Wawg8DYX7E4FLGMMhGF5uGcH2OicxbPfG+/CLMb8pR0vbNF48iHrQTaeoP/qujMv+MztchhNJulccZ0sgLGTM7/+bQusbTWpyOx3bQjY8B4viW5DDrGNaosbITufQjtKe4pugXg3fDCB+LFLhRFojArcDPFAzy44xtYuBjwqjaGqt736HLuNNWzo9QLgrXF5a05GwKuolXEIrQS8UMnQNFZhwJ8xA4r96KqLm+q4Asj5YIxtx48+9uqLB5AJtNafoug+g5IuPwGr9bvV2j+hMWYVVnbaxYqLophpx4cZ2MUs6ZNbhL0l92E2loOqcem+77o8FXw+AEADq4OD9/wzjFSEgUPwURC01gs3OYjgc5cKTxTio6X4v1aVDpyPGWq/iQlOm7BDNKSAGKcb/fj6Ih6qM/1aCIhP3tc9ondQH+rBrkmf+I7AXqRCLhCsIkzyZfwxk3RibHtsJQ/x3RoByRxRs98sUrxWA1fzWT2qXBDaRcriE8rMrV9UWzMIFhr0yKE8bXF1EBnx4ylvsgngcbh+Trh+stN4T6orZTQV5cxTCz7d4dhshOeHP/Et9z3gxNID6v8XLp1mTLqxumQasURU3CjZ0n6v4UCUOMeYpxtVFgywAjxMc+faEHh0/ETelwsYiZdmzmthNhi5prX0wrsxytcMNQZPw0Yt8lJ+yN+6cMrPwcGpS2HSQJqLpOBjwrDVvHRD9xaHpRHdRDX/R8HIh5Ji9J3BGlEtsjQGM+
 0vMGV+gA
 S7ulsvVIF8LCLdlCiPP3L16B1P1MDGF3xNa0RfDSpWLYKYO0Ny1+VDevp7cQrIK5l8cQ5cprN0DcP0mT0nn4FgJqH1TFf1cEtQTYLc35n+3NldeqiAJeybrazRWpmBxTNf188OSL1KhMs/ThzelhkL5WUSKd4SbtKAgSAAJk1NBaB7m1P8sDZDIj5O58rZDt/7TkH8lEDtnA99ogQ8+eDbGhUM/tJahqbt29Q/lBWnQ0ZFlhXK0G5xBfD8cdG0wYLnb3+ROcsl5inOINUKLMoWyjutQFngoLhOYsiZPF+zUrvpV4rJ7agqlzVq1Bd+ObOrWOAU1Ab2kucm4IUjQmxfhHz+1C1lUIdy9a4gfvuXK1AXOk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 06/10/25 11:21 pm, Roman Gushchin wrote:
> Commit 4687fdbb805a ("mm/filemap: Support VM_HUGEPAGE for file mappings")
> introduced a special handling for VM_HUGEPAGE mappings: even if the
> readahead is disabled, 1 or 2 HPAGE_PMD_ORDER pages are
> allocated.
>
> This change causes a significant regression for containers with a
> tight memory.max limit, if VM_HUGEPAGE is widely used. Prior to this
> commit, mmap_miss logic would eventually lead to the readahead
> disablement, effectively reducing the memory pressure in the
> cgroup. With this change the kernel is trying to allocate 1-2 huge
> pages for each fault, no matter if these pages are used or not
> before being evicted, increasing the memory pressure multi-fold.
>
> To fix the regression, let's make the new VM_HUGEPAGE conditional
> to the mmap_miss check, but keep independent from the ra->ra_pages.
> This way the main intention of commit 4687fdbb805a ("mm/filemap:
> Support VM_HUGEPAGE for file mappings") stays intact, but the
> regression is resolved.
>
> The logic behind this changes is simple: even if a user explicitly
> requests using huge pages to back the file mapping (using VM_HUGEPAGE
> flag), under a very strong memory pressure it's better to fall back
> to ordinary pages.
>
> Signed-off-by: Roman Gushchin <roman.gushchin@linux.dev>
> Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
> Cc: Jan Kara <jack@suse.cz>
> Cc: Dev Jain <dev.jain@arm.com>
> Cc: linux-mm@kvack.org
>
> --
>
> v3: fixed VM_SEQ_READ handling for the THP case (by Jan Kara)
> v2: fixed VM_SEQ_READ handling (by Dev Jain)
>
>   

LGTM

Reviewed-by: Dev Jain <dev.jain@arm.com>


