Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 57951109025A
	for <linux-mm@archiver.kernel.org>; Thu, 19 Mar 2026 17:03:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 725086B055C; Thu, 19 Mar 2026 13:03:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6FC766B055F; Thu, 19 Mar 2026 13:03:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5EAAE6B0560; Thu, 19 Mar 2026 13:03:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 48A5B6B055C
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 13:03:22 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E78025A2B6
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 17:03:21 +0000 (UTC)
X-FDA: 84563433402.08.B2F5DD1
Received: from fout-b8-smtp.messagingengine.com (fout-b8-smtp.messagingengine.com [202.12.124.151])
	by imf21.hostedemail.com (Postfix) with ESMTP id D9E4C1C0021
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 17:03:19 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="h L1bEO4";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=Rw7XgeXy;
	spf=pass (imf21.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.151 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773939800;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PJgFlTLVs0vAK6CUqcmjnq6XiC/gunSE5qOnxQgr0gk=;
	b=bkGQZxkp6kjIpqZmXgBbrn760ZNxYPrbrzDNfYxxshpzgVSepif8s9yuWlTwEPWpBX5jvr
	CXrRqA6i60lwyhg1p2wIHrgNok7pr4tW4HCS+1KZ1u1c6xU+U4s7OfZw3l+SJVM478q1LA
	X97mQyl4UfT0i7N03BEdz+dIsl8QPqk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773939800; a=rsa-sha256;
	cv=none;
	b=OFjumAMSVZcp08xP7NGrbe7N1RaEnQOChTp9zoe0WDHg2LDqj0x7uH2rxjvEgsHnRtM69S
	/3XcGsRHQlV5TfapRykSQ1YMXiUV+QAi32gwgM9iWKPJrL6EkZPKavSACMDNjNzsugADyx
	Omyh9IbyMeFUtOhy6bGE0nAh+0MNaqc=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="h L1bEO4";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=Rw7XgeXy;
	spf=pass (imf21.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.151 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailfout.stl.internal (Postfix) with ESMTP id 5A21E1D00065;
	Thu, 19 Mar 2026 13:03:18 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-06.internal (MEProxy); Thu, 19 Mar 2026 13:03:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-type:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm2; t=1773939798; x=
	1774026198; bh=PJgFlTLVs0vAK6CUqcmjnq6XiC/gunSE5qOnxQgr0gk=; b=h
	L1bEO4dD7Lx+gOY+yRwvvIyh2BnMJjb7bOSZY4mjoWoklHEKsxNzUotJLubzD++K
	bZMilB6WYniEfNeZI/gluac2B7gILmUVe2vRrnXxWKz4mol9KtmgIUUITHJkgkd6
	ICPkXR9pNel0lq7/r+2RTfYvpkUvIlaP/iRRGMF8G4ygDBZYi5MdhUMFbQoUqXoW
	c35T2Fu1LstcPwioEvcShQNsSKF1XApGXind4aVoqnfjrlqVOBi3H1nFqKmzhSFf
	HhQAyMUT8PU8lPOx8JnUhuJGxeDFNA42yuLDO/hAAVZHE0OO1QfvRQOJ1fsk1YuD
	PAtJISL59XCJw2GwIfwIg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=
	1773939798; x=1774026198; bh=PJgFlTLVs0vAK6CUqcmjnq6XiC/gunSE5qO
	nxQgr0gk=; b=Rw7XgeXyTStew4z7iif1EeWuQZ2xXTEVeFfIOvv7vaCDvcN6Nrq
	1yW7OoM2GKVpziJnLcsWrG4VRGzbU7h6jL0yr70CkKwMjUPpKbvPzk9YkspXbYeh
	uGD4V1DyPTkVv03oTbYPW93QPXEXqcgl4CLG4xYwTVFKD+YvV2YDusYg4PQx2qEm
	alfoYgGg+jkGtl3EaIc7+GChVOGoXotFBhKfszq6GCUPitSBT2FCCAv27epnUFFr
	vAmr7pLZOj5RktfJn9SIhmK12oj5zVuxtOLcWiTXD33PFm8jK25xPiE2lym4yogc
	qMs7MjwCdmQbYm6O/RYAlTrBJ+ILZUJyeHw==
X-ME-Sender: <xms:VSy8adWHjYoELCf5xwzuDp3oUqlCmKSWDewA75D837FZlOY8-ahi1g>
    <xme:VSy8abPuR2K5tc76-RmsEzTeb5nISj6J-4DckSxQ0bm8qu9Cu9n8hRcvts9d30AcG
    crETlTmcOmfc55i83EbzEnsWde3R6VOGbg3OHNBWLBUwuqakSOWQn0>
X-ME-Received: <xmr:VSy8aQwGUo8SNJhjt8U-Wv1HQUkCv8q7v_ZpFeD5oflZWxIneQM5UEJ0VHsFLg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgdeftdejheeiucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepfffhvfevuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepmfhirhihlhcu
    ufhhuhhtshgvmhgruhcuoehkihhrihhllhesshhhuhhtvghmohhvrdhnrghmvgeqnecugg
    ftrfgrthhtvghrnhepfeetheejudeujeeikeetudelvdevkeefuddtkedvtdehtdetieeu
    ieetjeeugedtnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrh
    homhepkhhirhhilhhlsehshhhuthgvmhhovhdrnhgrmhgvpdhnsggprhgtphhtthhopeef
    gedpmhhouggvpehsmhhtphhouhhtpdhrtghpthhtoheplhhjsheskhgvrhhnvghlrdhorh
    hgpdhrtghpthhtoheprghkphhmsehlihhnuhigqdhfohhunhgurghtihhonhdrohhrghdp
    rhgtphhtthhopegurghvihgusehkvghrnhgvlhdrohhrghdprhgtphhtthhopeiiihihse
    hnvhhiughirgdrtghomhdprhgtphhtthhopegsrgholhhinhdrfigrnhhgsehlihhnuhig
    rdgrlhhisggrsggrrdgtohhmpdhrtghpthhtoheplhhirghmrdhhohiflhgvthhtsehorh
    grtghlvgdrtghomhdprhgtphhtthhopehnphgrtghhvgesrhgvughhrghtrdgtohhmpdhr
    tghpthhtoheprhihrghnrdhrohgsvghrthhssegrrhhmrdgtohhmpdhrtghpthhtohepug
    gvvhdrjhgrihhnsegrrhhmrdgtohhm
X-ME-Proxy: <xmx:VSy8aYgnk4RJ-EQjMDCDorieYgyj7w6vDcKtUdcCokfigKtIUSCEeQ>
    <xmx:VSy8afS8cxM7iRYjve0OnX5OQhSrBv1ZvWrCGuOr-tcNtjVzmrRhog>
    <xmx:VSy8adMsivCWPviLWROIXQmSAVv81dn87v0z4PgIcNoOcwz8mYZoGg>
    <xmx:VSy8acHyfOal0TgxS7llI5RFQ0vbAOGQrtXn3QXMuhM_sfOXbsPKqg>
    <xmx:Viy8afWNZ-oVCGMYSFrOmKsnzx6qH1A3kJuSUUcXcYht67cyF223UagL>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 19 Mar 2026 13:03:15 -0400 (EDT)
Date: Thu, 19 Mar 2026 17:03:10 +0000
From: Kiryl Shutsemau <kirill@shutemov.name>
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R . Howlett" <Liam.Howlett@oracle.com>, 
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 7/9] mm/huge_memory: deduplicate zap deposited table
 call
Message-ID: <abwr3EmhNZVwOkR3@thinkstation>
References: <cover.1773924928.git.ljs@kernel.org>
 <29fa4129cd560681c67433b4c344b2c9a027d1b4.1773924928.git.ljs@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <29fa4129cd560681c67433b4c344b2c9a027d1b4.1773924928.git.ljs@kernel.org>
X-Stat-Signature: wtcgoagoac6genri1q83kxcohem6fmh7
X-Rspam-User: 
X-Rspamd-Queue-Id: D9E4C1C0021
X-Rspamd-Server: rspam12
X-HE-Tag: 1773939799-116428
X-HE-Meta: U2FsdGVkX1+SUzfFU3sz5blHZlbZTJ53/ofAu9H5CUFhrTkdOnKPB8a59geBbL9Fmzd9qBuAxWbu3EU+t0ZWU2wBngXZqJB3rAQUXIo1bxQ93mWssyfaKzt89+Tg7PuqkRKVjbb3XdJJJG0S1GGAXt7qvdCCgMnb1PQcsOpamYDlJFmehSTKyNWLyhkxwzCnAk2rGndqYZh8+rwF+o4S71CbRD1YFhWpJdwDVfq369uB6XM54HkIiYG5c5MRtg4LB928v7a7T/MqIaB63kVr8DFE5VPv6Yrbtbyd/FX4ou5yBnl5MAlkZWEm8O4VVlSPcGDq8GwI0CE0BXDO6rgPk/O79rtKkYABBGm4/xwzZiyrBwFoWesM+fb/YgolZmqnjUt6K41idGoZiBlW9ps0zBU1wI8G6wVnjXttlg2CnVccXcuIm0BnpiAqqRoLuuQ9g66IaRvE+ylR+Ms7yfEoEGliRhJDdvywAG87rwgR2rMs/vIha4JXN3wdFDBDIoiwRnJPKTLd+goyzXWysmozj2UUmL5lgie/BRml2PEcwSu9dreEkVuAw4He3TzKvoRPjpfMuuXrvQ25qQE2Rgj9k+lL+p6M3IN/b7YYpPwwoazfdeoj5mLp6TYPS6QwsPMhkHOBChB/TswZCcmvtu6hMAxhqz7o4AwHvGRaASP/iIcT5ob2JQFVrclOYlNCbvuYd8kLmTvQm98H+pe/M908kuCYX/OI6BD0hjPe/YpfxsU87k6Y9yjwxwqHhrbrf7U2WZ5OR1PWQBQBUDQQFxkRFlX3NxlUb8FP+WB0gJlEPo2zoCGAt4h3ESnG8Ikn/1PS/q8su2ms4rEWg3OFivL/M5TzWO1p+0fMm3DmieYWr54+g2YCtt9xCZoig2ajnxS+5Y9kqKjVkGueCCVPwksBluzxckcSo217uu7ZkezC9lsCkSAqLQRgL8TY+S94Q9LZ5Q5T4I7qODpSSupsHF5
 VRGYM3WR
 5Vvlv52geMwgRQwquUReH+q4AJm8BN//cu68Bi7IIBcNOCtu2Zbp4oWIJ/7IpQbZdgItY+WJ3IqLZDBqAA77t3pKA1nOK7sdzCnnVtBVm6QfHtMvQhj1vzx7u06g4puw6JyVLOCewMFFQFYdmu4CusNtQRembm4lSWvASjwhBFyr6nYLu5XY26F+Cla4wrX07EMqbFvebRRs1yZVeszpy2JmNMI+Xs62XWetmxQ5Gg9AB76vGrtwGfx4kEoKREnliknN3NQvWfuQ50BwPCro+ICf829S1xuL+rYa5uXejr/rSoEWGVO9pn7v1OvOCb9kuM/63KDvFJVsPU9VtC66QPzSxL5BiSIu1xRq3QC6utVhz8RLdgGSElbB3zYKUzi75EKaHSBP8UrBRs9ChGEQoZeWqpNOh1fUGwLJo81YOZ7mKb1HuWTOQqp8Xt09EqyJi6M7/oht9kHv351c3lAIn8EmshT380WdRdz5eD4LNTPRz09g=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Mar 19, 2026 at 01:00:13PM +0000, Lorenzo Stoakes (Oracle) wrote:
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 499c31bf8f83..c4e00c645e58 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -2431,6 +2431,7 @@ bool zap_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
>  		 pmd_t *pmd, unsigned long addr)
>  {
>  	struct folio *folio = NULL;
> +	bool needs_deposit = false;

I think 'has_deposit' is a better name here.

And initialize it to arch_needs_pgtable_deposit().

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

