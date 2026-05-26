Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D7320CD5BC8
	for <linux-mm@archiver.kernel.org>; Tue, 26 May 2026 14:38:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4A30A6B00CB; Tue, 26 May 2026 10:38:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 47AC36B00CC; Tue, 26 May 2026 10:38:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3B7966B00CF; Tue, 26 May 2026 10:38:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2BDAA6B00CB
	for <linux-mm@kvack.org>; Tue, 26 May 2026 10:38:34 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E2BA61C1786
	for <linux-mm@kvack.org>; Tue, 26 May 2026 14:38:33 +0000 (UTC)
X-FDA: 84809826906.27.E3BEEF6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 50F4920011
	for <linux-mm@kvack.org>; Tue, 26 May 2026 14:38:32 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=InvYwEai;
	spf=pass (imf03.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779806312;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=L4CDmwaP8XGp4TRqjaoMu7IDWtjRrbz8fDYCZt9wbT4=;
	b=u55iLyUvEaN/LIaFpJnawANItDmpAtjPFePmgkMrVfbngstmDE9h4Q0rz07pOqvrVQyr3a
	/A6mhv8kcwtHa6PH+sLT+HipVDW6t20HCZsZmxoLC3vzAdpRzCiuoz+ZkUHFneIEoqUdtL
	E/D4cvTm7pwphDKSqxHkC9qXS/sifRU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779806312; a=rsa-sha256;
	cv=none;
	b=rDmj5B79MI0c16UVUkl1BESktZ9weElOPlXAfZIjaXrCZP6EwNgoCpZrZhkiq+P9ynbRtC
	d0eo/RNmBVuDQ+HyPWGPtvM7prvxh4qoW2/yVc439r/L6K//QPAmkrDE/5at+zksVGL5cG
	K62ksvwAlNHDkhnxxs2A2HFi+835Kks=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=InvYwEai;
	spf=pass (imf03.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 55972408D2;
	Tue, 26 May 2026 14:38:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49F531F00A3A;
	Tue, 26 May 2026 14:38:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779806311;
	bh=L4CDmwaP8XGp4TRqjaoMu7IDWtjRrbz8fDYCZt9wbT4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=InvYwEaia1IxbLmUgiGxnrWQRZ/rw2K4n0gteTimX4S4DUqQW627G5DkgcDXlU6et
	 cEDQUQTNrDyjZif+fbxy0WDKsYJntWW/sBg1lzxTTYmMtMsV6b7/pX8jSvLqEC2L/b
	 JxVtBmf3ejggShlMihKUo531xnJtIBknzfbaK9h5fec6uu2ni++CO8k3kV80JohozP
	 J1UA6nLVlZeVkAqiqnJwClVZWd7Y3rd0kIF3jayLNAj2SzDGiSXmj91UuhTnVjJ54t
	 7bvZG1Oz7RkNLPtZFq5PKyXeZ+GGq4IP3fkQsdJUj00BfvLzIZigLnPRiyE0KtqEcG
	 xxx+qhItT4rUQ==
Date: Tue, 26 May 2026 17:38:24 +0300
From: Mike Rapoport <rppt@kernel.org>
To: David Laight <david.laight.linux@gmail.com>
Cc: Song Liu <song@kernel.org>, Yu Kuai <yukuai@fnnas.com>,
	Li Nan <linan122@huawei.com>, Xiao Ni <xiao@kernel.org>,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	linux-raid@vger.kernel.org
Subject: Re: [PATCH 2/2] lib/raid6: use kmalloc() in raid6_select_algo()
Message-ID: <ahWwYIOycuWZnETn@kernel.org>
References: <20260520-lib-v1-0-cb3045bef2d8@kernel.org>
 <20260520-lib-v1-2-cb3045bef2d8@kernel.org>
 <20260520140657.2b5b5f3b@pumpkin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260520140657.2b5b5f3b@pumpkin>
X-Rspamd-Server: rspam11
X-Stat-Signature: 6ag8hdkboq9oz8fhkdg679mb6bi716gk
X-Rspamd-Queue-Id: 50F4920011
X-Rspam-User: 
X-HE-Tag: 1779806312-501564
X-HE-Meta: U2FsdGVkX1+ADwx+5PAYZJkoU0/MwwPz+DfkOP4I1G/cD0WnbprvtMS7yQWDr08ckuQYhC5E3p2XwosfgDY+Hwv2WHM5OfZhBgRfLqDyOGzn4JBQ/NUYAZhNy12zzGNp0NLhR2MUFhyeao7IZZFGCtKCIX9jysfayM0JrkvmENKkk7w+VHQHyg22fSAyyQutYHkBz51sieEab+wUKTgn9lKzlf6eT4tBZwJW1VvfusWvyyojLQ9gimbVwjSsNQQCi7VDKzftlJjp8q9kaNBGuPwZMik0Kz+vtb9hNm2M6tL7e6/fZF5OuzDTAP3gijKKpSLMRDKwEA0TmEYj0moJsh9H0HqK+pSegiSZUVMPPHuX0CUI+yX6K7vnFucL9NA7uOK/E9U1gCboLYMkr6iO9mrD2+8ivIvV49u89Nm3Ipvq7AjO0L5TbUruAYLNYLuiQq+MAN3nWNnl3jmsUkr8VuIMqucTaMNn4wPOnSs1nMUlr1BQ9wYyy0+TWmsgcsXbbFslS8mlaTVsRGK7c7xpKZMmbfAy04QttIQhOrEh5TdpDqoB03VRJM8mKII2cSgn2xSPS7lrCRI1kAKnqfqB8iJXWwxJRZLizPmpmYLqiX+XZqsCQ7ZS/6EkqFFG/xDNc/oMrcIMizDvhsdZ3k7T2UtyC6uCWHWego8Ea6eG6rmTvaGaPaWxYKwu2Ac+7p1P3DWUTfWVcX3K0fOh7LHB6stXR+0hKGSQN+CwHTbncLju+w5mztE8jxMkLD/pJc3m1UryzKGePbizyzIJ5CdrEaPPpnTO/2O4K3WUGibrwY5ChIBx9vP19WPCC2fwUXpe8LQgSyj1y1O+2Pr+flgGtTn7n7P6FEDO8HW5J96qAQLSaaOoVzhaB3K4GGID2kk+DXWdkO+aMoN3iImhxeMjI2DIvKHHFEMVk8q12dMPd0zECVCMHiSlwN1rfUhCWwRVd+xRMbxECSEgmWGwBvW
 VDvWkblk
 uZqQaDknG2XOclZtBJitrwUNrfh6CK0CvAOu0symXT1kCRTIb+T3F2NazVHWSbIfZ+Vs24y37ZWVBsPMwPGu5/bKohbRIKDmTlANV32/4EKll4PwhSzwRbI481zaKQS20cs5BTzlMIq8yUsdy/VIunCZOtlDNRJg1jiEnsZ0dX9QATGIqzcK2/hWVBJZriVOk2cnBCqo0oxS6v2GKpf0IMSq31fPjLGpI1ERGy67j0n8VdDliorlNZVehyS/vqPhsZQusMvDJs456rv/qR3iG/HXpafB0rnO4w7758BozvrTJNtYUQwgAbrgeYMaec3hgKXElAcEeYBzoxiJagXR33M+nCQty9tRN6lzDen8Wm7mYUzJnIQT7iC9n0/o7ak/nKXhHgSvb/vk4BVTyxO0+ejCT8eVBj5bjwD1z
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, May 20, 2026 at 02:06:57PM +0100, David Laight wrote:
> On Wed, 20 May 2026 11:17:52 +0300
> "Mike Rapoport (Microsoft)" <rppt@kernel.org> wrote:
> 
> > raid6_select_algo() allocates an order 3 (8 pages) buffer that is used
> > as a scratch area for selection of the best algorithm.
> 
> Should this code really be using a 4k buffer rather than a PAGE_SIZE one?

Why?
 
> -- David
> 
> > 
> > For such large allocations kmalloc() would fall back to alloc_pages() but
> > still kmalloc() is a better API as it does not require unnecessary
> > castings and may provide more debugging possibilities.
> > 
> > Replace __get_free_pages() call with kmalloc().
> > 
> > Link: https://lore.kernel.org/all/635405e4-9423-4a25-a6e7-e03c8ea0bcbe@redhat.com
> > Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> > ---
> >  lib/raid6/algos.c | 6 +++---
> >  1 file changed, 3 insertions(+), 3 deletions(-)
> > 
> > diff --git a/lib/raid6/algos.c b/lib/raid6/algos.c
> > index 799e0e5eac26..89e627c62e30 100644
> > --- a/lib/raid6/algos.c
> > +++ b/lib/raid6/algos.c
> > @@ -12,6 +12,7 @@
> >   */
> >  
> >  #include <linux/raid/pq.h>
> > +#include <linux/slab.h>
> >  #ifndef __KERNEL__
> >  #include <sys/mman.h>
> >  #include <stdio.h>
> > @@ -129,7 +130,6 @@ const struct raid6_recov_calls *const raid6_recov_algos[] = {
> >  #endif
> >  
> >  #define RAID6_TEST_DISKS	8
> > -#define RAID6_TEST_DISKS_ORDER	3
> >  
> >  static inline const struct raid6_recov_calls *raid6_choose_recov(void)
> >  {
> > @@ -250,7 +250,7 @@ int __init raid6_select_algo(void)
> >  	int i, cycle;
> >  
> >  	/* prepare the buffer and fill it circularly with gfmul table */
> > -	disk_ptr = (char *)__get_free_pages(GFP_KERNEL, RAID6_TEST_DISKS_ORDER);
> > +	disk_ptr = kmalloc(PAGE_SIZE * RAID6_TEST_DISKS, GFP_KERNEL);
> >  	if (!disk_ptr) {
> >  		pr_err("raid6: Yikes!  No memory available.\n");
> >  		return -ENOMEM;
> > @@ -275,7 +275,7 @@ int __init raid6_select_algo(void)
> >  	/* select raid recover functions */
> >  	rec_best = raid6_choose_recov();
> >  
> > -	free_pages((unsigned long)disk_ptr, RAID6_TEST_DISKS_ORDER);
> > +	kfree(disk_ptr);
> >  
> >  	return gen_best && rec_best ? 0 : -EINVAL;
> >  }
> > 
> 
> 

-- 
Sincerely yours,
Mike.

