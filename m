Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 77D38C5DF97
	for <linux-mm@archiver.kernel.org>; Sat, 22 Aug 2026 14:29:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 430626B008C; Sat, 22 Aug 2026 10:29:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 408266B0095; Sat, 22 Aug 2026 10:29:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 346176B009B; Sat, 22 Aug 2026 10:29:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 13E7F6B008C
	for <linux-mm@kvack.org>; Sat, 22 Aug 2026 10:29:56 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 7D67F80151
	for <linux-mm@kvack.org>; Sat, 22 Aug 2026 14:29:56 +0000 (UTC)
X-FDA: 85129139592.23.939AE90
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id BDA5A1C0005
	for <linux-mm@kvack.org>; Sat, 22 Aug 2026 14:29:54 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LdYxZ8St;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787408994;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gq2M4Yp4LsrAbxCcb4OsdXRCxH2vxgvtkfvBcPe7rk4=;
	b=1JGRsgF1Wt7ESLfgh4RhPERL+25/1qHIn7i+cT17tPfz7xBWQTKWTqbjKEan2Zb1cXoJpq
	2x/q5VsAd0OGzLUXB2kDd04I8AicVaEM6B6u8aLwWsQnEbFY3Fyt8xtDRnUgdwmNzv5QXZ
	VfdZvFwHS1+QLmVyLQgv1bpK3MncS9c=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LdYxZ8St;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787408994;
	b=weZSjZb8aQI2NQb0/rzD/lsNrsUe84UAbnoraVAfffPsxT5O9rD5T/VXwoW3j0KtNJ3CmM
	6uB+x0hU1RY8aZiUoY27f0ucM+pUQTcjKcVj0XA1ZqKCeGJvswSZhQtMHTzLUcORQEZ99O
	fOW8pDDiAvxyiwYKb3aVSzGLsc3WlsY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 28EEB40F21;
	Sat, 22 Aug 2026 14:29:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D235C1F000E9;
	Sat, 22 Aug 2026 14:29:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787408993;
	bh=gq2M4Yp4LsrAbxCcb4OsdXRCxH2vxgvtkfvBcPe7rk4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=LdYxZ8StMjABIcT7GtcCWMLOJqwH1cWscypDLzD51I9TUkdn8V8YQaeIffjAoeOcW
	 dzcm7q/A9qUCL59SW35i6wvvom3EWABVutkaBxb6qtwQ8DumGk6FL2bRcsGGG9EveS
	 yxCQHkghOG1kajzcUXC0SJkq42uCbkaSCSKUY9h4WoYblQG3MHQpRWRQfkqACs0pwr
	 OMRnixZivZNW4DRGjnDHN0D1YeINBlEnByv0+W+xa+XybkfXPXGybkF0NHrFCIQCxW
	 nTw8R+wDjYzLT9ZFb6Xl7JuQ/eIc66Lgo6G71gTLNXWhkrdwhxoVC2yzuIv78Wmk5e
	 8qUFCJyA6EQDw==
Date: Sat, 22 Aug 2026 15:29:46 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Saravanan D <saravanand@crusoe.ai>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, 
	David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R . Howlett" <liam@infradead.org>, 
	Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
	Usama Arif <usama.arif@linux.dev>, Peter Xu <peterx@redhat.com>, 
	Alex Williamson <alex.williamson@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/huge_memory: allow huge pfnmaps regardless of THP mode
Message-ID: <aomyM47kVsW_v-Cm@gremlin>
References: <20260821070520.25759-1-saravanand@crusoe.ai>
 <aogCjEc9uyMjFP6S@gremlin>
 <20260821193220.91799-1-saravanand@crusoe.ai>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260821193220.91799-1-saravanand@crusoe.ai>
X-Rspam-User: 
X-Rspamd-Queue-Id: BDA5A1C0005
X-Rspamd-Server: rspam07
X-Stat-Signature: 1tna7g61i3exht198h78rh3jpq1buyst
X-HE-Tag: 1787408994-353438
X-HE-Meta: U2FsdGVkX1+ZqzUddZsYEFl70SEVY7bVIkV7f6+YmstvFoG70w37D7m/SGuf4+C+vw6PpXOH2ahcFtZiTVQWoE8g20TS1uq1Fheh0cqh3uxXaszoq489JDxhogTZTHPvcqZ19NLFB6KALGfIDDz6RJU++S1Fk9eLUcN357MjyHmIwOt3FrcqN4KTFflT1qBIEhx8D/5xDYg7hN8ITWFjZ+2RCiDwc/8nQ8H0CLQ3qApsS4LHXQiopQazCDB8p5ajr4ibs7dhrGsd7ON/AOqZb4wvvsSvsJF4pjGPeh5QdJCMS3UjpTsIa6sOn1I0ubROIFEfMQTE2nWhYtIUzouPBTF2sK6AMURRIn8LJw50+bXJGQszX4Mg9g8qoawUjPN5lkbt0xiBVsdj89a6UCQbcnWcqRynCLAqGSMpGfKIwXVhWr0ZHo7NUAHlUCfL3cyB1FEXdFrk4/cG1HpnCZd5d4UslcR2aTWJWK+a20q7YfiZ+8n1jz3mvEi4vBkK4GcDpClD1ZI9VeWFfXWwEFeVFljqDUzOwuETm4AMa493tzPXyLzXeKqOD+wHg+w53SuP0+9c3oioZOIamC9P9pH/XEK1SviLGC6ysVMEWpP2bqyCrhvbPrYVcerKOU/7pJeIYda3tM019O3kNBBabmd2h2RSMZRnGClqDC4KodmYDz3Jo+YKJ2TJiTyT0xb9oYxbdtFhaOh59PDSylXQxxw2uBRHJK1lAdO8eyZOlWZoGr1cop+zWmCLWB7uJqGVG2mqzihqMTdWzO9XPkAn9s/u80y5cavtzcSWlO/ucVNhxiKryH0DghtuQPtRLSGOwEGDBFxXfQOMWV5JJWZ0NL7m7qNCcTmP5puusR/HBhAQdOuzwEr8QcLwVbryq1F5+9Lnr6JBHWOtyIF4D6L+WlY5K3D2Sx0kQzJzRl3DQOYmasRTAlREyc6i7MS/ZTkXKY7zrRGW5yhV9opPMCHNM6C
 qOMXsfQS
 b9RDagQwXjCIyqWLyJM5t4fo+rDCRypgpk45ng+armvytasm1Qsfpf6kXCauRaBoV8d/9iubT9Till4UBHyD0/hjIE2u6xo51ry8XTrov0uBiK/MBwHwRad7TUnXNxZ2ui3I5YL/C1goRfdkiA6nL14exkleykoHqVaPHnvT9C0c3lI3ihrHRAcm3oSH8d4I3b86LrjO24pGEZbcB6FHvqWEoBsIYM5D8r20e5HiLlCkTu5mUTM7GFUTaFbcLif3tvRW7tWTM/nujmkGaPA50AxH5o07fdhiVc2/yqXqfkf29G7aaQWTIBBCaHktn7Gyae0pv2da2DLMmJKk3q3L2aATWihvzRgj+2h/1
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 21, 2026 at 12:32:20PM -0700, Saravanan D wrote:
> On Fri, Aug 21, 2026 at 09:03:15AM +0100, Lorenzo Stoakes (ARM) wrote:
> > In any case if you'd taken 5 minutes to search the mailing list you'd see
> > this was:
> >
> > a. Already submitted (so your patch reads like plagiarism).
> > b. Already rejected in favour of me doing an actually sensible solution.
> >
> > https://lore.kernel.org/linux-mm/anL-NZkNMSSxN0YN@lucifer/
>
> Apologies and please disregard my patch. I had not
> searched the list before sending and was unaware of Cédric's patch
> and your rework. Mine came from an independent observation of slow
> VM boot times on Ubuntu based hosts running cloud-hypervisor with H100
> GPUs. The patch was prepared with AI assistance and should have
> carried an Assisted-by tag. All of my future submissions will.
>
> I backported the diff you attached in your earlier response to
> a 6.17 based kernel and ran it on a HGX host with four H100 GPUs,
> each exposing a 128 GiB BAR1, with cloud-hypervisor. THP
> mode was the Ubuntu default - madvise in all runs.
>
>                        VFIO_IOMMU_MAP_DMA       4 GPU VM boot
>                        per 128 GiB BAR
>   6.17 unpatched             20.7s                   97s
>   6.17 + your diff            0.4s                   17s
>
> Each BAR mapped with 128 PUD faults. Your approach will definitely
> improve VM boot times in our production. Very grateful for your
> contribution.

Thanks, always appreciate real world data :)

I will send the actual patch at some point it's on my never ending TODO
list... :)

>
> Thanks,
> Saravanan D.

--
Cheers, Lorenzo

