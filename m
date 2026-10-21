Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 45F6A606A31A
	for <linux-mm@archiver.kernel.org>; Wed, 21 Oct 2026 10:44:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FvdgJD40
Received: by kanga.kvack.org (Postfix)
	id 6F7156B06AF; Wed, 21 Oct 2026 06:44:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6CF1F6B06B0; Wed, 21 Oct 2026 06:44:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5BDE26B06B1; Wed, 21 Oct 2026 06:44:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 378386B06AF
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 06:44:13 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id BBD2BA04BB
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 10:44:12 +0000 (UTC)
X-FDA: 85346298744.26.7F9FBAB
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id BF90CC0005
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 10:44:10 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FvdgJD40;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792579450;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Us9MblHdqheExL+x3XL9+16dU0fSlqkrDNwTx8ZinSI=;
	b=Moz7c7JIWZL9Hng4FfSoqgpLBgCXzcPlS9ruhNrZdbaHizsgYepN36XTKKF2E0ugGZOZ0S
	0OFlBEUvJ3US4v+z922ss1Q9wDwgjAWz1FcAp/Evj5kTiDbMkMoJww0N10Jh7W+JH8cH5w
	c8GLPBZg9rrQClh2vwVZZFgHyGyQLTI=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FvdgJD40;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792579450;
	b=ufie+5HNADXUS66DgIzVrwhhzS9Suqkaz64TQHgbfGOIeE1b14qv82/bFFuFJZngqzmxP7
	U/KglrbXiPW4VEKeKvflZM9WWeErVXwAWgW2TNPryeJcwtLcRQ3QEC1YUHUr8GY685VtQV
	wkGyyiWepLziQV4x1HlZBClT+R8w74o=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 2B1A560098;
	Wed, 21 Oct 2026 10:44:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF2661F000CD;
	Wed, 21 Oct 2026 10:44:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792579449;
	bh=Us9MblHdqheExL+x3XL9+16dU0fSlqkrDNwTx8ZinSI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=FvdgJD40INAzdN9f/tQXF9ktwbiBhZmGFjuEJVQEqJ8Vh51FOm4MGs4G4Yd5E0FN3
	 PQyn6wGXy3Awrbk2eyZOZml14B7n64UMRW6MjNpmBNq7R8YDoDIbpPPtw82qSffKZE
	 huRMKRekC5pU2IU1aDtzZkTtoz9obj3o69x22iDIPyz6E43QiqbCF/wFUnR1E67UvZ
	 hfCGAqWb7Ae6GRY/SSYm5X6uHk3Zbp45kw9y+C39wOQWrUr/g/Kk9rgnlg6UAOwpHb
	 WrLSAMq+UqhgJyakFlaOdK+mWy7gpYlMGvOPUDjQpPxRVxBBZdiXujJu1CFKmBu5aE
	 FTtozWAilOBZQ==
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfauth.ams.internal (Postfix) with ESMTP id 2AD67198004A;
	Wed, 21 Oct 2026 06:44:04 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-01.internal (MEProxy); Wed, 21 Oct 2026 06:44:07 -0400
X-ME-Sender: <xms:c5fYajUSghtNgFI70pcZQneEQiKH-7lS9ZiDirnB17TnEvHBNdbCoA>
    <xme:c5fYanAQyxuwZwdQplhyZWO5Bdi2T3DvThxLwzqn_3RnCTqpb-X4KPqEKjKDGlTZ7
    oKcZRIZfz-3S6jmsuUKK8xOpGS7tHrzX8oz-CmCJCmsjXvaBHq7Ui28>
X-ME-Received: <xmr:c5fYai81E17U72TQR6cBaVLxynEL8Mf3FphrFIRT7W66q-afIjHNwVhOSWI>
X-ME-Proxy-Cause: dmFkZTGjd0a96U9V2vCQJLOMnRP+wBw1u1T1zryEKh7wa0310J6MaOgUiIze5CmLw2GV9H
    W7t6mlprVd+kvbSxqwnutYrDRHFq9thzgxnKvzoOneg/m+7lBF9h6ytrT+iKjxIUuf+vvN
    y9Cq7W4xWk7YVHBR3ir9mF0JQz+UsddF9RY9ecD9IhTffHR77HlcEV22e07OPYPqpykR1c
    Wbn4lcV/ZHNQlUrw+hxoN3dRq3FexhKkQBbUB2wMoaOQaVWFZvvUIADdR6OZTcM2mOgGbt
    Bk1nFt8UG7lG7K1JW9O5KIcUOduE5+An5YPc7EUyj56sUKNTOHdIARZs+z4z7vm38NyPL+
    HMeJaBxs1tnJ0vyAx9C/DXs6nkO5W+SROu2gcLvgiyeg+rJm8DzqGFpZRqkGkzLHbSENiJ
    HBbb/QiPxtnII8Uk1Aw0fsQFr4bsOMXrpJpP4o9kQ6A6DpRyVen1lHrEEJ4L9yapznEJAj
    3PpKWlBNVcyf/NsutF0IPRW7//mfti3i/gbQX23xqmAqPmynlQt9p6EB2slaCusRSNwU2q
    TqhR1AuKmJ9+wlHfDyYPNRZ6p0We8D+oBsW/o3vn35BTXm8B9lt5J6jeuOcZJ/s43Qu9gD
    mjnUcWTYfxtc0HJnryuldPPfmsEjTZQJq09ZQ5pAmUiMVHNuJ4+1inCL5tDg
X-ME-Proxy: <xmx:c5fYanX-UOwD1UJMljja19LTZSvPp6QGcT0h-ll81DosJRWQO3Hp0w>
    <xmx:c5fYaqveaLErmdg4TlIzJ8FZHHZWWJWD8PxVjFCrfhuzfBv-JlBQhQ>
    <xmx:c5fYapwXBuSeNxn6ADFbdlYq0tTrchCfRfxXKfJJahhF3GaoUflqoA>
    <xmx:c5fYatQlMd7RbKCdCqBqcY3jcV_k3NMeVXticf3wiq0mfAzk1ElIMQ>
    <xmx:c5fYaj_ICU5Mn5lVmICEv_wySfwlt4Bp4UxwPMTYguEn6y9bPCJ8cNWj>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 21 Oct 2026 06:44:02 -0400 (EDT)
Date: Wed, 21 Oct 2026 11:44:01 +0100
From: Kiryl Shutsemau <kas@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
	Miaohe Lin <linmiaohe@huawei.com>, Naoya Horiguchi <nao.horiguchi@gmail.com>, 
	Adam Litke <agl@us.ibm.com>, Mel Gorman <mel@csn.ul.ie>, Rik van Riel <riel@surriel.com>, 
	Peter Xu <peterx@redhat.com>, "Mike Rapoport (Microsoft)" <rppt@kernel.org>, 
	Josef Bacik <josef@toxicpanda.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org
Subject: Re: [PATCH 07/10] mm/hugetlb: tolerate uffd bits set without uffd
 for PROT_NONE PTEs
Message-ID: <atiXUuyXM89u-XBV@thinkstation>
References: <20261015-urgent_fixes-v1-0-42796911043b@kernel.org>
 <20261015-urgent_fixes-v1-7-42796911043b@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261015-urgent_fixes-v1-7-42796911043b@kernel.org>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: BF90CC0005
X-Stat-Signature: shkoojazh64dn7gde9aqs6nsnqeda6zi
X-Spam-Status: No, score=-11.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792579450-25353
X-HE-Meta: U2FsdGVkX1+NCI0cqPshSgzcnjt9WVD6rMGoQpm5Baum9vx0MhH8jaotGL/gA196fprBN6GHcdaFmRDY1XXuWV4tkmOB7ZF2BnCp4OA9c2EA+nhqRM2idw1iiIMAvopdCoXZUcyhP9maPLMDDDuFctzCX9nnjOJjmo2LeA+Rsx6Vhaq/pR5uM1cYLN2U3Cn67KRChNvhCd6iQ8RG04uINNjoqYl7/PZ2+ErAxt/uvElE5tOasE/IoK7i87hlZdRZKuCKmM4KgDORi4/dmFIptYRgm3CAA+ua5RVyRDi5v2HGkv2L0+ixn7zyL79WeilL8nf45TinkAAOXE3xLCYALm67whHeHudIZkXUDoZ1mzXZvcUxkd4xyE25icYxPXms9SPxR0Fk1yBoPyVL8+LRG3ESNN3Xf/sNkKwSkZ6Q2b0jA6di9lNOa/gR3WWhUCWk7yNz0Rltz8B2QKwlrFplQfNW6esVFxgnjkJVtIPn/8tzyg7oTLIipk5K5AbqxgRnZSP3XfgjAnE7mLuhpCdmBKwfJKvuchUCxZjCcEtPC7aBCGWCBmG11Gd4YeAX2NWzITiChMR2yEukRs5pW5qLB/1sWdYkfz01k0NpljGlpnV8BlzRRasmPhJG+0Vx5Io/vZsRT8au70vHndLqD+vPwWQxVJ3DnYjzRFCP9/FuZop1cl7blxOrjuCCQtFuDLB/WUi40t9xKBEpmKcGa58l06kSpQ/FJZN6Y1YU93a+Gg0GA/lykmmy68b1edRHIOYVp1V1HkTwY91wlLId0uPcyzM3QpSipkI/+9RjvPOM1Ky/FeRzftg+rv2pVD9yu4+lkwk03H0lBm2PuZbRwupgmurAtC1ppcgkGlcmIcJlkiHAgqjrHhtJW83ieQEVKzSuhmpTdvPopUfZ/7mrWu/apvD2H1XQ9LGt3VmakPtS8ADCt8lr7fWPa9aOq78cOgD3iozBJW8SYVgchQYYTRO
 OdqTBHIh
 5PAWBt/Rv5kl3tR1CsPzjLfblUbEMvSXAqvSldmxmBhpQn6AgPAZ4NyFwpB1UW1Kg/P5Od5CP6SPtp0WV1OnUBn2kbqSx4Xgw6g5zp9RwhlPOVhz9axYiZhrP4Rl+TBZFrY3/JZFyE0EJsiHVFiNMPkzCHSutlXeUOYOHhiIZvXdTcEB6cfD4eRvcsw2uVUUU7uMgcXGD6Gx0NyhYGItjrOaMybh7lIBesLIm7DMySnMGTm9XXQzmRjRxznjXTbG4FUIf/ggimqHsbW5lZ9rHyJyDcv07K/5Bks6Wc3AhP4q6NICgNrfD0qKSVMoAzqxlpThMjLsIpWgg0khjUdFJ2LAs4x5bb0BIKxH+mO1TvvnbD+wv8CKR3QNDPa8iEERprsp23pe024ym6IeNYEAEuQaljMChZgLR3aoUd+loAb6UM1w=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Oct 15, 2026 at 06:07:13PM +0200, David Hildenbrand (Arm) wrote:
> The whole uffd handling when a VMA is unregistered from UFFD is shaky:
> there are still some scenarios where we might have stale uffd PTE bits
> in VMAs no longer registered for UFFD, which confuses other code.
> 
> Let's just tolerate that for now and simply clear the PTE bit. Add a
> TODO to really clean up any uffd leftovers when unregistering a VMA from
> userfaultfd.
> 
> The handling is now more similar to what we have in handle_pte_fault().
> 
> Fixes: 2d427bb01639 ("mm/userfaultfd: add RWP fault delivery and expose UFFDIO_REGISTER_MODE_RWP")
> Cc: stable@vger.kernel.org
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

Acked-by: Kiryl Shutsemau (Meta) <kas@kernel.org>

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

