Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 69AB5CD37B6
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 08:27:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C405B6B0092; Wed, 13 May 2026 04:27:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BF1B86B0093; Wed, 13 May 2026 04:27:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B2E586B0095; Wed, 13 May 2026 04:27:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A1A9D6B0092
	for <linux-mm@kvack.org>; Wed, 13 May 2026 04:27:54 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 515FCC27D6
	for <linux-mm@kvack.org>; Wed, 13 May 2026 08:27:54 +0000 (UTC)
X-FDA: 84761718468.10.EB01E98
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 9A46640004
	for <linux-mm@kvack.org>; Wed, 13 May 2026 08:27:52 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=RDVBvJWx;
	spf=pass (imf12.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778660872;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bBxpQgvAzoJYCqFESYm/jq9o9rPQyCc4q8HLNSw0TCM=;
	b=8ZzEyF0Hm04f9sT+sW+c9xJBprmzc4/znDgIRxDKw+uCMg0M9b8OUA2CGxkokv7Aa9B3fO
	6TYGLqG2JxsYIBJBew7Y8PyirC/ROxiNfwiBIA0NAjSSv7VpJbiIAs5Z5jW+o0uStPLCeV
	B0lQy7cxSlHOg7LuEO5CguHxiwzEHec=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778660872; a=rsa-sha256;
	cv=none;
	b=rqwCyqM6reXi5b8XuLz58eljdTaXHMpiHuIAA5zXt0B+Zohw51qsKxZEYqI5YFuh62jlcM
	6FPd3LY2OyQ3QzbM+RFLG/HVCKfsqZ0N2+5TOXyvkOD14aqZm+AAHcAX3LvAlUG+EIVAUy
	vpNOMYOfc5JVj4umW369RbGaVVVjYbY=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=RDVBvJWx;
	spf=pass (imf12.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 618E343AEF;
	Wed, 13 May 2026 08:27:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1415EC2BCC6;
	Wed, 13 May 2026 08:27:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778660871;
	bh=BFNiTiF/fmalzC6zsySYqjiBYoFoZn/VA1kMh/SGay4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=RDVBvJWx9At9GYymZiTlO41qMOkSSKg3BboX/CVnFiIv0SuGpInRHEAvhGMxiyigy
	 XYxY2QFNHsiM/Kz6qb5NfpYB+1dXscvNM3WsLoOGc6QHMmkIQMh572x12weyGPWoYH
	 vHOryRtbOWtZJ68xh++I/5IQOucJ2dlC2eMdo3MQy9H691yqC0Lj11nXwLpOCAE3aS
	 KhDIBcOu0yW33BDLsOG8B9VSmd3sJ8VVXgKFCHYGt4NsVHGDVW/asy6XiNs4qyNwom
	 OXjzJ7LMX26VkGqcr9MOhhtZsLzcVib+okPrxWlYGMY16gAJAI/YzgvweX2k+RnwnR
	 FkFjWcg1j/ROg==
Date: Wed, 13 May 2026 11:27:40 +0300
From: Mike Rapoport <rppt@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: "David S. Miller" <davem@davemloft.net>,
	Andreas Larsson <andreas@gaisler.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, sparclinux@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	linux-s390@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH 2/8] mm/bootmem_info: drop initialization of page->lru
Message-ID: <agQ1_Bl6obF1bpT0@kernel.org>
References: <20260511-bootmem_info_prep-v1-0-3fb0be6fc688@kernel.org>
 <20260511-bootmem_info_prep-v1-2-3fb0be6fc688@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260511-bootmem_info_prep-v1-2-3fb0be6fc688@kernel.org>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 9A46640004
X-Stat-Signature: iqtcdifoyftrny4s85j7pnym7hdfhyf1
X-Rspam-User: 
X-HE-Tag: 1778660872-161254
X-HE-Meta: U2FsdGVkX19dukcl16pLHp895x3MRLK1q7yX/u5nzB53NRr5Wbbpb8r9m/Wk7smwcMesfaF9h0HaFA1JpP/uaDuRKaCw1A+ALY0mPbQnvvcXcDBmYnXWLz0M5KyqLHCg5VzaDse3ELcKaVdPRLN6v1Z413i3eRMW7Inxz8vnMysd+3f4mZLvLjWPQLvsNaU1L0winnaB4Jy2wXJjRoO1gdzQuSAucsGjSivHAJGlSWU5iOPJA8s9vg6UuTLPJ89SKM7ony8o7ASeHroNeUmsFvpmYKBefJr+CbfZtzanXb4o3ypFLhYs41xUJMBNDmpe5E1NWkyg6p8oXYb9HDX3103dkWQrtn6t6FzLJzBfO6C9P4YT6o9BjEldxU1MZqx5ElrpTLOCIx+KfaaR8JzVGrLW65/88mK+oIhKHIYHDXzWzU4vrW1Q9EZfzqPc3hii1I0kXp5W4DsMZJKl1rcEVYJo2Ba+8FOzltVLg30+WW+9tpTjBIgZravp4Z7uaA/73W2KMZWO6aplcBmQpz7gmvkbijHekPrvVIV+XqFs2uI/k58K3S1zuV3jjum4DkFImdpF5WCmTGJSIsOQyw0B6+3D5UTEXDMCa473NikKrcZpzqV87rxmNUfIou7QZtCVkrmNAdwXn+BCMJi46xdq1WGfBq2y499kilclVcJksyyJYKZDHDqAklRlVW6MtouHc6bIrjy3Ay9muFiQK0vNs8yW30QVoi22HoXroJ1moW6k6zHUTWYK/R63DbhLYJk8f/Z9Z+yX8wTNmd0jIKnXFZkPnfFzzPwzj91/H9cDeQG9kjqGkoQPS8KVhLO60hOX3FG6AgY+9TF4FlItiIF0CKZbcjScOA9x+MqK8smC5iQKHArdyKrz2nIka/VEXZpsRROQUIMrl30KjF/E9Swzxs5E6DLFOfPf9wp5WKZIbQG4+CCQTZr2d1l/t3ZB23eZTOL1LXofNpGGflBNCX5
 42M45xST
 ACqOABHfl7wszOYK+solgC90BjlRUXscPiee40mUM8PQNOmR3+vNe7v3HvrqsAtgVOpLCvVXyFrig8TfG0na8i9tvgTpd03x/ahWo71QLaxvl3UdWsxYZvjSmQOspd54zrRjy3+Zxk/O4U/itii8S+nkz7qP19/12xzkoV+ITjbMARMK7OeXMZURvKBMbZ0kjKbNHWLw2caaabFtRjo5YnUa45nHfWnuC9KFFeoKjbBe4gwyAvuS4O7ojrsLkOPmUHj8/xnfD+CzbmLJ/hLyob7SOqxorJ6+K0wzWrrWqYzFk0tWxM18dzIrDqSSP6uQMBE2wD9VipKnDBA0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, May 11, 2026 at 04:05:30PM +0200, David Hildenbrand (Arm) wrote:
> In the past, we used to store the type in page->lru.next, introduced by
> commit 5f24ce5fd34c ("thp: remove PG_buddy"). The location changed over
> the years; ever since commit 0386aaa6e9c8 ("bootmem: stop using
> page->index"), we store it alongside the info in page->private.
> 
> Consequently, there is no need to reset page->lru anymore.
> 
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

> ---
>  mm/bootmem_info.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/mm/bootmem_info.c b/mm/bootmem_info.c
> index 3d7675a3ae04..a0a1ecdec8d0 100644
> --- a/mm/bootmem_info.c
> +++ b/mm/bootmem_info.c
> @@ -34,7 +34,6 @@ void put_page_bootmem(struct page *page)
>  	if (page_ref_dec_return(page) == 1) {
>  		ClearPagePrivate(page);
>  		set_page_private(page, 0);
> -		INIT_LIST_HEAD(&page->lru);
>  		kmemleak_free_part_phys(PFN_PHYS(page_to_pfn(page)), PAGE_SIZE);
>  		free_reserved_page(page);
>  	}
> 
> -- 
> 2.43.0
> 

-- 
Sincerely yours,
Mike.

