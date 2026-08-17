Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8A2AAC5DF66
	for <linux-mm@archiver.kernel.org>; Mon, 17 Aug 2026 16:06:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7BBB76B02BC; Mon, 17 Aug 2026 12:06:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 76BE16B0466; Mon, 17 Aug 2026 12:06:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 634016B083F; Mon, 17 Aug 2026 12:06:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id ADA2F6B0466
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 12:06:44 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 42465A0812
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 16:06:44 +0000 (UTC)
X-FDA: 85111239528.11.4CEAB7A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id 6C4DC1C0011
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 16:06:42 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=UUPT5XDS;
	dmarc=none;
	spf=pass (imf18.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786982802;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MJyyJ9fN6w6afhM/ktA8g7Cdiq66qrNC49WmXOBpDc0=;
	b=oAL9y8b1CKB0OWlAfHbiF5TBG+CNNAGmPmfvgZmVptjNEzUfKaW5B+URgPm95+huI4zSTs
	VT5S9pQW0PDY00s5XKcW4f7XZ0g4u/X8A/oFJLSgS/a7cyuVaCYC7WvGp8aDt0XEhBx7Qj
	759XYp9+F8MEaBTbbFFieFojLX774yc=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=UUPT5XDS;
	dmarc=none;
	spf=pass (imf18.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786982802;
	b=LJw7PW2x7bVf50EPrc1+S+gt7MTN7TwcOxwtEovLE3KivWTbJAuMZZ2867iJcMGvQquKdf
	CRgnh7hRRVZE5CIuCNuYQeLDwboUCIbQRLBLXqBtWLvgN74UeOTHnRtgWzadUi8rXxyIxs
	VcaqYzp5Fp32JyTUy322tX3Nza+x3Qs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C4783600AE;
	Mon, 17 Aug 2026 16:06:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20C291F000E9;
	Mon, 17 Aug 2026 16:06:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786982801;
	bh=MJyyJ9fN6w6afhM/ktA8g7Cdiq66qrNC49WmXOBpDc0=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=UUPT5XDSTCCNzYpfsT3pvev+OnjAlzoPPMY3yvxjlKltV7G7q3N2tpH9WT0SMcHMj
	 JF7gRQ4JSWePCJ8SWr34Yjs1oqh/Z+k+KWSQVmuy0YkazTQAxXw1nVPfkxmwgxuCqx
	 xt2FUSu2w1+q3bfpYk8v1H+3SniSpH/69TYM+Z1A=
Date: Mon, 17 Aug 2026 09:06:40 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Balbir Singh <balbirs@nvidia.com>
Cc: Hui Su <sh_def@163.com>, David Hildenbrand <david@kernel.org>, Zi Yan
 <ziy@nvidia.com>, Matthew Brost <matthew.brost@intel.com>, Joshua Hahn
 <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>, Byungchul Park
 <byungchul@sk.com>, Gregory Price <gourry@gourry.net>, Ying Huang
 <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/migrate_device: fix cache flush when replacing huge
 zero PMD
Message-Id: <20260817090640.287a9a415da49e3974797aa4@linux-foundation.org>
In-Reply-To: <b93756df-143d-4463-9f88-5a9a8a92dbdb@nvidia.com>
References: <20260817060845.377800-2-sh_def@163.com>
	<b93756df-143d-4463-9f88-5a9a8a92dbdb@nvidia.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: ykwrsgctif1z9fqskyx3pzgatn9fk56j
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 6C4DC1C0011
X-HE-Tag: 1786982802-79674
X-HE-Meta: U2FsdGVkX19lj0HNS8uRBEisRG6LJOvooM+smv+3JkCE6uliZHAm6/LNjd/jTKJ6jBPRAcSB+8VvZVNWoK3R5bOfOdKrWXtRJQgzR+i9rx+51XlzS3Y6PkNojrDaJGusNDDJc1bRb701u8BqQE05bq3F8rAbWENhQ/YvKvaecKU3iK2B8zHUavu2uMvfMgBKYFQHuwvpsCQvw96ohI3ZrsTVIa5qRCpwsLGKzIa/wBs7kbCCxWO721WQ8Fgv2DMvKu/aEPzqRaPCdBAdnYNkZwRpEsfwbFAWjaFp5GxJCMEKtsN67CQcX+nCMNCEnOjZlDiaJacg9OobWZ49L+8kbtcraOr85OmcyDPHQtvIePJ/VzmA7BVRpc2zlvds/E7aioR9KtWQLKASpQemWOLxfJMBhL3F23zyP99ETEgSkfWcPxJmpaeCxMLVE4gB+y0b46FRh4xyvPI5Xyj4nAk5YoMFo/CzoClOnSL8FaHjJc6in6AYExESwjcH1rjCU3odBAH7pp3s/3tjvI8ojPDNM7O2jzGOaIOE2I+gFO5ovtypFqyzNJBw4emlQnlRjQI6yshHhs++bngWj3w4Qw3NrPK6YPLobTXHVVYt5UIkeQ6+tibtQEvN4NMmOuvptbW6x3vY3OZoA5hkkxNLFCSDRIo0oFIYsDyQPJx60c74L9lppb8HAWg7aM1dLzliflu0DRkTCgV0fvxWyuMf/K5MSRnIDJ03Ll9xxkXbMWLotyVmwyoUqD2IlUdTVJGA5C2RDjqF1/M0DdZsC/vh0+NTEGJAXzmI5PpEm8gFvC/HVFS7scIHhT+Mzgz47bgQGt52wfymCWTffuYqwtdrYNJR5fjoBfrZzUjfmF0e8Y28d5JHSEQFZf8ZUyShswoRKG5eNjXhklGXSu8Il6fkh0vw1cx5C12AW5tVUjDBk3mjp6oAVwN1kRiw2lkCENiwDJhLRH+0VG3HHI9wD3cOO4+
 uTTeSWcT
 PFWw5DcxyzZiFNDxh9ybo8M/IRHJF5pnk4GXBfyr5XSw7X6XuhDHDhwmrrjYvoSMlTPFQNOOILFKXMyO5XUXmLiv5KZM2Cv6ggOthHk96I83KmO+OgzVgJy/JGFwSqk0QnPeQobTP+A+HKLQhEjei2Oz7tsi8YvSrj0TqUdnNB91xsyLrjYDhXS0xFi28l23ZvG3Fsug2gtOtAgKDyzoBsOtlHc1ZcwsL+YEzOFJTn5CibShR4fX7gWGIhVMQSszip5sDM5BQ4e14TPwQxUTm78yEBdRINtptno8GVwHXL9RYznp5FPuP7xb4s/ZSSBYHqkp3AGLMfknuIqUOqVjR0z15sftBG6i71PB2qaRh3VXThT8HK0QsXILvnayecTaiJcxJSrWnc73tJVj5kgOgigoDEysf+WN7Fnd9
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 17 Aug 2026 17:35:53 +1000 Balbir Singh <balbirs@nvidia.com> wrote:

> On 8/17/26 4:08 PM, Hui Su wrote:
> > migrate_vma_insert_huge_pmd_page() calls flush_cache_page() before
> > replacing an existing huge zero PMD. However, the third argument to
> > flush_cache_page() is a PFN, while addr + HPAGE_PMD_SIZE is an end
> > virtual address.
> > 
> > More importantly, the mapping being invalidated is PMD-sized rather
> > than PAGE_SIZE-sized. Flush the whole PMD range with
> > flush_cache_range(), matching other huge PMD invalidation paths.
> > 
> > Fixes: a30b48bf1b24 ("mm/migrate_device: implement THP migration of zone device pages")
> > Signed-off-by: Hui Su <sh_def@163.com>
> > ---
> >  mm/migrate_device.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/mm/migrate_device.c b/mm/migrate_device.c
> > index 908d2d4ec43a..098c04c1b124 100644
> > --- a/mm/migrate_device.c
> > +++ b/mm/migrate_device.c
> > @@ -872,7 +872,7 @@ static int migrate_vma_insert_huge_pmd_page(struct migrate_vma *migrate,
> >  
> >  	if (flush) {
> >  		pte_free(vma->vm_mm, pgtable);
> > -		flush_cache_page(vma, addr, addr + HPAGE_PMD_SIZE);
> > +		flush_cache_range(vma, addr, addr + HPAGE_PMD_SIZE);
> >  		pmdp_invalidate(vma, addr, pmdp);
> >  	} else {
> >  		pgtable_trans_huge_deposit(vma->vm_mm, pmdp, pgtable);
> 
> Reviewed-by: Balbir Singh <balbirs@nvidia.com>

doh.  It's a shame this actually compiled...

Can we add some speculation about the userspace-visible effects of the
bug?

I'm assuming we should backport the fix?

