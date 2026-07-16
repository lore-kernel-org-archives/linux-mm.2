Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5C500C44511
	for <linux-mm@archiver.kernel.org>; Thu, 16 Jul 2026 15:39:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0F0FB6B0144; Thu, 16 Jul 2026 11:39:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0A1B66B0148; Thu, 16 Jul 2026 11:39:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EAD3B6B0149; Thu, 16 Jul 2026 11:39:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B6A3D6B0144
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 11:39:02 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 2F7B5A0038
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 10:52:17 +0000 (UTC)
X-FDA: 84994325514.26.DD97700
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 85A874000C
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 10:52:15 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EwMfacw+;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784199135;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=N1dZhaci75OOFUtgLVVRnN9/6lCyWljyWs7u1S9B35o=;
	b=ZsJByFHO3WQmd4nkrjH7SrueLTRZBNwsdbJTrTmyP2DyufAj3RuXrr9r6WGi2y1oVRt39a
	6LP7q1NGA6bbupP5QJ8t4NJLgpMouG0iMHEcsZMAt8nODPgyqnDJl4aC0xu3Bk72h6ZHiV
	K2HscKnEJTkYYIjm6pBeFcalingk5JQ=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EwMfacw+;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784199135;
	b=EU/RVOtJEAQhkd4ceTBmIB0RqvKwq1Ge1JkvszaUNhUjUoeL8bm0do0e2ZzltLoyUkbEiR
	gkEPgnFmpyWBK0fAvhTOwlVy/t78T1UH/1+XICToLOOwL5W3ZE1Tguz0a3wR8SE/vekX/6
	x3c4UBtMreesOTbG7B/l/5ahtsSvAAM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B2EB541433;
	Thu, 16 Jul 2026 10:52:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CC871F000E9;
	Thu, 16 Jul 2026 10:52:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784199134;
	bh=N1dZhaci75OOFUtgLVVRnN9/6lCyWljyWs7u1S9B35o=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=EwMfacw+t3M1nVnMvXcSkTLhb7ECqpM6mrFlUioo6asDz+YjPbKC1ub+NtAfrx7u8
	 1ynT0ekjL/5ik3NX/uJAZFcHZuhtWm0AVgOcotWUw2ELLAvKpwlaE8S4ldzeuLDyPM
	 9j3nP6Ejf1OsM1+aYkRk9sUBMJUWVjQ6Cbt/HmmTPjdjKgE5zyTsvCvifvUxgZysKT
	 LoQXziTmY9uIneobZMg1mnweASBTi0DiYJAIOXH4KH4v8atBYnYlQd/uJ2QwsGbIoS
	 8It1wYZVBvLYY662ntSp+foyJ73CA9Yg27Eqx60KpvRT9f7g0KLI+QcgOGq5mlPOl0
	 ZUy8BGcy2RwCw==
Date: Thu, 16 Jul 2026 13:52:07 +0300
From: Mike Rapoport <rppt@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Brendan Jackman <brendan.jackman@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Brendan Jackman <jackmanb@google.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/secretmem: disable under HIGHMEM
Message-ID: <ali3162voYNVFl0p@kernel.org>
References: <DJQKSKCN9KIB.25WIOU9KF9CNV@linux.dev>
 <akpBWmnujSnj1ZEE@kernel.org>
 <503aee9e-97fc-4889-a379-3c0a5d140554@kernel.org>
 <DJZ3TQV3GPDO.6AN321FGTTX@linux.dev>
 <aldv8U-lzCn0SCBL@kernel.org>
 <7e7f20de-c43d-40f7-82d3-8d05ceb3656b@kernel.org>
 <aleOvBtB3WCSsqEd@kernel.org>
 <21e7746b-9bc2-4643-b0ca-c59e0c77f810@kernel.org>
 <alef-_LMykiBQ2qP@kernel.org>
 <5653474e-6692-4353-b5d6-e57b6ab76eaf@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5653474e-6692-4353-b5d6-e57b6ab76eaf@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 85A874000C
X-Stat-Signature: i7o7cjf7ogji8rx8kinuh4jnoz7zjstg
X-HE-Tag: 1784199135-430401
X-HE-Meta: U2FsdGVkX1/D8W27iOWxSXg0Ye5ioqMtpJBMvkCSHV+RSaPfcesenSdJM1MN8w1FsNOMZr6OzcJPSvdwBZa3wVWCXtjzPWrB8ZO4r8tXkYY+GRn6mBWx8i2+htWK0L0lrofG6WSCea9oPYCAnXug8HRwcAR0xPnQan8tQOIJn2+SCLqc7m5Lt6KMb3dUtofcgi4k4ReVP1jB2OLdmF4s92BijrpgzfztFq5NUZmn2OhcKkUGB7gbisvISqDzOwE+RG6grL7W6WBOwgNGFYX24v2IkA6gMVwgRkphnqjvg1hspO/Hrrl7bPVu/KFvbB/HrFFnXYrd2xp7SJ9YDYJPRmPDF5mSrNSOJM4GNWkhoWAher5845MV6hWIJ8GZDG+KO+M4H9Ol83rIcXncAlXVtHdTXBkXOU+lonW01cQgXiQtuhLxuR38NRbLjpsB0uYNejfd9AR4paRMwMyCxMp5xGCiBGj2V7gAMZcXHrmH2Nsi112R/HqhGzgIRZ/mOYrZfRMceCelsChKh5gTfS7z7LQ9K5UiD265WjZR2eshanXNh7S9o3KNMUqw7eB9F8iirAE64HLxns/VOVAI3wc0+ZeNIEpfsis2kGui54zIHO3GszL57qhJQZkbzq5JqQBguGvzg7HpXtUBtOjPMNXcSY5CMM4JpncUrmYxcCK+2lMzY+kfXw1AP52DAG7cbYtOVgNqzl/bOzLn/Vo/IkhEDTzUgZh+2NF8kJ5cgByPhBdGB4BJUsJpFuVzcNhhOQ1OJMjwGxVBBjWb7ToeYNMKdmI+RijdaEEiOPXLyrFlzTFibk/Dmf16Ssgu9LV6YDLVMWMOOaKXbsZ1FvSXuA7uouG29yc6yH+4AJo7QXdvf6Ouq1OFOvhvcjcGXOMp/JXtdqlOk4rNBQUd4DzjyeH7Ehp+DPs4VIvJAmytVliQalVCPb6VpwYN6z3BHIeaC8byxhJOfjDPOxSo00Ho+Ug
 H/+KoqOD
 BVJO6dLeHv8VuCMvfySeAbfYgh1FN+UI9b1Vzma47Pw2IyUMEDgo9u+ZVSaB4iY5A3KvrkLNVHcvXFr24PNz5lVZnuCOsTbHH+Wwyk54lyf/KrttqwbezSzOgqSJnCsJ0eeN97Isci31G8T3Tdz4AYQcyP4YwPagGdCTAKc4c2iTClyebVhO0wZBSUBsg6P5JlWIYIl6h4h1GnCdpSqFmowd3l1QscgrNVAmSpcirFijM/x7WHxo4dwmM9UgcL5MnRHmO
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 16, 2026 at 12:08:07PM +0200, David Hildenbrand (Arm) wrote:
> On 7/15/26 16:58, Mike Rapoport wrote:
> > On Wed, Jul 15, 2026 at 03:49:39PM +0200, David Hildenbrand (Arm) wrote:
> >> On 7/15/26 15:44, Mike Rapoport wrote:
> >>>
> >>> No, I mean what Brendan's patch did:
> >>>
> >>>  config SECRETMEM
> >>>         default y
> >>>         bool "Enable memfd_secret() system call" if EXPERT
> >>> -       depends on ARCH_HAS_SET_DIRECT_MAP
> >>> +       depends on ARCH_HAS_SET_DIRECT_MAP && !HIGHMEM
> >>>
> >>> We can change gfp_mask as well for the sake of pedancy
> >>
> >> Why not change the gfp mask only then?
> > 
> > Citing myself from a few emails back: 
> > 
> >>> But still with kmap() and friends not being an NOP the promise "kernel does
> >>> not map this memory" does not hold.
> 
> So you're saying that kmap() would perform a mapping for a non-highmem page?
> 
> static inline void *kmap(struct page *page)
> {
> 	void *addr;
> 
> 	might_sleep();
> 	if (!PageHighMem(page))
> 		addr = page_address(page);
> 	else
> 		addr = kmap_high(page);
> 	kmap_flush_tlb((unsigned long)addr);
> 	return addr;
> }
> 
> I'm missing something important.

Yeah, you are right, GFP_USER should do.
 
> -- 
> Cheers,
> 
> David

-- 
Sincerely yours,
Mike.

