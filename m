Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 79CD0109022E
	for <linux-mm@archiver.kernel.org>; Thu, 19 Mar 2026 14:07:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 66BC56B04C8; Thu, 19 Mar 2026 10:07:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 642316B04CA; Thu, 19 Mar 2026 10:07:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 57E986B04CB; Thu, 19 Mar 2026 10:07:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 47D476B04C8
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 10:07:41 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id CE43EB9940
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 14:07:40 +0000 (UTC)
X-FDA: 84562990680.13.9883C2B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 29D0C1C000F
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 14:07:38 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=SwIWMSqU;
	spf=pass (imf21.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773929259;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7lhlx6qZZDFIeuzW72rhfb3+V+ZYlCPrG5vKYn9WRqc=;
	b=yKuwZoHr3ascGcuN6xL7ShlGH2zdcNTuD2SsUaPs70cGTv/k85BjTL6pIAl2tuaoPwkLPt
	O9IO2yNmtiSyjvY1VcPRVRYZvw+4wsl/ydg1fNHtXba92eZ7LUTePItg+rLbyVYWr6pLlw
	PUPuViAe7QiVA9dy8TzIYp2v/10gHqs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773929259; a=rsa-sha256;
	cv=none;
	b=AZeJRzXqNI69smzK3rNurFVRFliDvXDP92UpCUHs0p5qs35C3rZ6Pi0MZoybfHWuuRiwJ0
	nL/o1xB3kfOG+OPYaSq1T6dyMqBdEfTq9Uz0c3DY8xMm3xII7ui7hgT0eLvGCIeuPIky4i
	Gm87u+862mLk6eB1hWlkwj1MHI+vieE=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=SwIWMSqU;
	spf=pass (imf21.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 07991408DD;
	Thu, 19 Mar 2026 14:07:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 800B5C2BCB1;
	Thu, 19 Mar 2026 14:07:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773929257;
	bh=HkZRbcYV9UKIWpRqai42smC0s83PraNFAAL7cCXl3Fo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=SwIWMSqUzmv/tchOI9fmLYCKdWPrNkgnYJtGz+/VxtnW6IvDJYatRbeB9+70C5rbG
	 Xlt+elf01mYggD7fU0fJzk8lrHHB0NFkYl6kl5o7ctONaCm3Hv4TOVROxUdBYf60iN
	 rIz41nrOcv+sUhuab5TOlEY/N7WDz6qLKDZB2R5fBRPSW31CP4Men6hgOajzU7bxhv
	 ytiRw31fVRCreO604swZZZ9D1lsA7+zVt1j4fKuCxCtkcbDfc3OhO0kUSz+D1sbDah
	 fBXrczmWekD0Bn+0RXBGWxYTgzXWJcXvE3jl2LEyE5BQ/JmNukOJbWIl3wSfY4jNPl
	 a0I3epxNPaEKA==
Date: Thu, 19 Mar 2026 14:07:35 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R . Howlett" <Liam.Howlett@oracle.com>, 
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/8] mm/huge_memory: simplify vma_is_specal_huge()
Message-ID: <e597ddf8-e834-4045-860b-0b6e6bee226b@lucifer.local>
References: <cover.1773865827.git.ljs@kernel.org>
 <84712e37721c557f887e4a405759be31a4961100.1773865827.git.ljs@kernel.org>
 <5ce0932d-e8d7-4f0b-acb2-12be43a035e1@kernel.org>
 <11293efc-8c97-476f-9b65-8576c63e3275@lucifer.local>
 <cb86a286-24de-421a-b14e-8d11d4e8e89e@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cb86a286-24de-421a-b14e-8d11d4e8e89e@kernel.org>
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 29D0C1C000F
X-Stat-Signature: jyp4ftkmh1897aznm9h3e3j6gj4raqgk
X-Rspam-User: 
X-HE-Tag: 1773929258-614545
X-HE-Meta: U2FsdGVkX18Ee0BuNwIvCtlpB4r+HHine1Y5TocYcbl0SzWdfKpSFsmPmBZwVbqau45ScEabj9dpbWOOQQPcqw1f+oiA6zgxShVSxT7flYkPpqQxl6Vkbp2xylbI5fyI4NfwS+8GDfrIic0lo0mi4Iq7D2XArmQ3Ba7BFNl1oOP6pXbj4kKB6CRaepoRvZGVKkVmfHRzfnzKi1tVWXqExZa3B+4jMX16P6786EJx/wb2cO6ljMcYaL14uMsmIPWhMtU/Kt29LElmG/yt29GqQIY1zlCf+7Pokbar6nyxNv91o4OeGKZbdkzbepttZqN393QlVHCFrBALpwMp4mVUFTaFRTi8xuGuFKJuld1jPPl4Mek/AZciYJBoFx8jlZDcTfvkGIirJEjFKtRdHnH0pWU7DTUOg4sqQZHxbOWXxXLwziXNbCctoDFW8b8DUh9e4VIrqeOroBH31bc6FAtfT3jAJD+SQ45QmniAU0kBmleszRupAU5Gzy+dmMEic4/oYItxxNL7D3Hyzq/fBYyzQYXFoi8j7NCA8ncIBBHjIvyKqH4gl1QJrkVCHY0gdxYpj1AA2Jx6pf4ZmcNV1kwclSUR4W0ci09Cog3t2MuJFYrV3OIz/AR0FiOpnZSx3cpo2wPZRxe0fB96ggf6uwIoNGaCeINT5/3xSkhZ8IDQ3qdAijOaZw48hrhBKewuwmw8hQLomqZscXbfeaR75klJhzS3W/b6M0TPfDcdWjbwyvSGQ3pPOEmq2amdP+RWkEvE77cSj3eyl5rNUunjvB5GYrcLOko1UO2F5PpPhZgBzqpQuNqiaVvw6PUrZXfPpiHnJUa+vPjV6Hvfclmlxhxk1mj6nO0kKdzbqleAtT7K+u4l9nuWfOjZ2be/a+6CD8HG2SIjyEk1Qe14T7RR4qoO3ypl4Epxt7OQ8mPGysGbYyzZKcueuKCmPtzuFG/hx1tVKiITMcceuviVPCuILes
 9CR3oxlJ
 CoD7fp42pppIQG0B7967fbWsrSIkbV4wDlqRRzk8AZERNpRhKblxr/dSigaAyF+cKck2Zhu1mUggQbTcubqWMpRSiWJ3RhHFFTKGYdcrg7bdiL6EgtYhitkKa0AsFZJ6CzQu4Bo/bgefDqF1WLkzTJT0TsODDfGwG+MX7wIIT7XgYnEaKnBkWjhY8Kem3cM3oP1OjvlUsQ1gQx9LcdOoAKzo7FsmwSYu053WyBiu6r/ZoU3c+sHCSVlHuYO7klqzX5FpbCXbiIATz9J8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Mar 19, 2026 at 02:03:04PM +0100, David Hildenbrand (Arm) wrote:
> On 3/19/26 11:34, Lorenzo Stoakes (Oracle) wrote:
> > On Wed, Mar 18, 2026 at 09:45:31PM +0100, David Hildenbrand (Arm) wrote:
> >>> +++ b/mm/huge_memory.c
> >>> @@ -100,6 +100,14 @@ static inline bool file_thp_enabled(struct vm_area_struct *vma)
> >>>  	return !inode_is_open_for_write(inode) && S_ISREG(inode->i_mode);
> >>>  }
> >>>
> >>> +/* If returns true, we are unable to access the VMA's folios. */
> >>> +static bool vma_is_special_huge(struct vm_area_struct *vma)
> >>> +{
> >>> +	if (vma_is_dax(vma))
> >>> +		return false;
> >>> +	return vma_test_any(vma, VMA_PFNMAP_BIT, VMA_MIXEDMAP_BIT);
> >>> +}
> >>
> >> I was hoping that we could make this whole code look more like PTE code
> >> by using vm_normal_page_pmd() ... :)
> >
> > Could that be a follow up?
>
> I guess so, but the code is so awful :(

well I udated the code to use vm_normal_folio_pmd() :) at least should get
us closer to common logic.

Cheers, Lorenzo

