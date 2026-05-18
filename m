Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C5384CD4F3C
	for <linux-mm@archiver.kernel.org>; Mon, 18 May 2026 06:32:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2F4256B0088; Mon, 18 May 2026 02:32:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 27D546B008C; Mon, 18 May 2026 02:32:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 144AE6B0092; Mon, 18 May 2026 02:32:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 027776B0088
	for <linux-mm@kvack.org>; Mon, 18 May 2026 02:32:21 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 7F2E41607E9
	for <linux-mm@kvack.org>; Mon, 18 May 2026 06:32:21 +0000 (UTC)
X-FDA: 84779571282.05.C1977DA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id D16C2C0005
	for <linux-mm@kvack.org>; Mon, 18 May 2026 06:32:19 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=dWhipG0O;
	spf=pass (imf22.hostedemail.com: domain of osalvador@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=osalvador@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779085940;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iAJlNxr/IKeDG/LJ1nw0blOP94g2w/wIOP76Kg2DJJw=;
	b=orBh/DH4+1TS14SwQ7HdNS1nPLasSOT3mkCFlNaUuWrHVk61YVTkyENdOIGVy19eKkm2y+
	zxdVyy6UinLH1xrUt9tvplTNi1iXWf/40qT4zgGl989Xzyy3vuW5IaWfnFN/OZVlA1bAhf
	410s0dQst7dfkiUW+SUPbPdq0XC9WeA=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=dWhipG0O;
	spf=pass (imf22.hostedemail.com: domain of osalvador@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=osalvador@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779085940; a=rsa-sha256;
	cv=none;
	b=a4iKbSzahD4ZVNsTR1ApouQ2fNeukkHKhHbbK/sc6i00mICsUxS3kz670IQ61/RTE9vkzi
	98pbRioDk6u8tig+4UDWkEv1tRVXjI3VRRCF6WeX+SUuUXKqnWrKKQfjQ4hrIb2OESSbx/
	Mz7AnRmIQpEMK46taarGAwiKk5inqFk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id ADBDD42A6B;
	Mon, 18 May 2026 06:32:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D750C2BCB7;
	Mon, 18 May 2026 06:32:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779085938;
	bh=/4HjBH+vAOnnqBO0QRSTltroD0Fs684VyTY2lkm/ndI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=dWhipG0OKFjQXNg7FkzE3XUnINSnZYONNmPsmlJSf29XR6GyBdPA3zqKBvpBMEHRQ
	 pR5uMp9WaorOy9wK+kZWKsJLZ8eEjbKj7NRsykGQNrIP68nyLDUipJ7AY2iDs7aIWC
	 WTX2BOJQG4oaQCSOS7L/Ko0Tx7Kn9vL48CKbByqTzn93VfBlf79o1vav5tXGiP8yi7
	 pj0gHkJALulY7DdgUCaWv3GaQMVB3qOPKn4YrRTpNWpYhvbo++AE9Mh+DeY9QNM8jy
	 6+JJKPaAZNCTCQ3ftGGF/ujWsUNRSQL6dmnodg3pepeJfq++rREkBW/EBXs28+P0Sz
	 Y3RLctNR3M4Pw==
Date: Mon, 18 May 2026 08:32:07 +0200
From: "Oscar Salvador (SUSE)" <osalvador@kernel.org>
To: Muchun Song <songmuchun@bytedance.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <chleroy@kernel.org>,
	Ackerley Tng <ackerleytng@google.com>,
	Frank van der Linden <fvdl@google.com>, aneesh.kumar@linux.ibm.com,
	joao.m.martins@oracle.com, linux-mm@kvack.org,
	linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 08/69] mm/mm_init: Defer sparse_init() until after
 zone initialization
Message-ID: <agqyZ2g-EA8Wl_WM@localhost.localdomain>
References: <20260513130542.35604-1-songmuchun@bytedance.com>
 <20260513130542.35604-9-songmuchun@bytedance.com>
 <agqxs2-EQ06mFKun@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <agqxs2-EQ06mFKun@localhost.localdomain>
X-Rspam-User: 
X-Rspamd-Queue-Id: D16C2C0005
X-Rspamd-Server: rspam06
X-Stat-Signature: r6pruyu9iogbeay64ga8trh7tdrogyu7
X-HE-Tag: 1779085939-347993
X-HE-Meta: U2FsdGVkX1/L8F+x+lTvbZeJtEwbLPTxGYNGMnFR+Gu4ErRctswo7yVH+emTNxAU+QVS0H0o4etduUxRYYugFkRjETqeVH3UNhK2BLDyJ+T8LDkGh4xooApELHL9DRJ2An3pQddHI8looWxlAux2sKMD9T+RQ/U+HC6uJI4Ql7UXfphXx0BMINgcX9+UNF/RJiQ3xv9//3e94wNQ3JwXibtHIsSI9MqBL0sdJOUdEs30c87IbFrbqULOC3o5oQSP5Hhfcl+p0DTAizKMI7dc0dopnX3ExE+5vUwyJ7qLTVFyVGF5PLE7YakEC3JDKrPkB18a2i8kxQVEr4QGCUTnhJRd/RuTurGONVz6f04Vdro4bbYZPAyP/MBX5Wgy3FwKSnBcZWJXmKMQF7uG5b7zqkEtYR9xNjk4lzw71VNYPFLii7KQimfX4ipvlMTB6I45U+yHayGB5S7cs/0prfJ7eVZwkwAN1O26MKv/QJ6i7uLuxvr2Y5wpsYgTOPrXp6kDqE0JshDA6FGm19jwY58Y+DErxKqwC7dorZLK5x63vP38rowkxu0QNE/Nme+2SKH+rXxrxIh4Gws5f7zDeLxIcJpuG4u8OivGznaxCA035DK/lfX5jIhVKa6sONy4+qr0mS9H5DOBgw6dwlrTHh8CPQaTv2DWRzETSM9s68mhwsTBEC5sThzQ6jWHhQ4rgxaajfOZ8+EEG+22Yvrj0x931DBLStRTxyZ5eD7VRmCSLnzSmbK1KKIxvNERmfgfBznP4J3Q55qR8DpowQ5amNSwn29SziyyWHjAHKJouTA4gKiSAhAWI60lsQ3AnpBsV909sQBoZWQBFO/fQR3iXslc/aqZXyQKqiurxUr512ZQY5CMH3iuYfOn2fI/E9+DGHm+c+qw1T7UZ2JjpF9Sy7H05BMUeFIokXfxe5mRwcceKgLPS3fJnNEdXWxvlaND5U7TldAfSh315OJwGtem5A6
 l2VY0iO7
 2vDx2LPT5AIcubTsbiVS79A89TI/5vSCtmUOM+MA3V6CjsH2cpcsjL6lVczcGM+eaEMWqMT9ayWIvUjBIEC2ndmHSHH4XBEc8tprMQIJhQk6c+icYCK/9qDdvp5GwH661uKjNHvmNzUzE7QzndmUxH5oNgiIbhLFFNfnd/YlfKyDo12ezpPjJxqvAKOze0eg3CmyQTWG+8b5YJvH7SQmbc2KXOpDJdzQ25r779FLeL1FviPFiTms0kjquG2EEVoGlgaYgKokboPVP2Nw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, May 18, 2026 at 08:29:07AM +0200, Oscar Salvador (SUSE) wrote:
> On Wed, May 13, 2026 at 09:04:36PM +0800, Muchun Song wrote:
> >  void __init mm_core_init_early(void)
> >  {
> > +	int nid;
> > +
> >  	hugetlb_cma_reserve();
> >  	hugetlb_bootmem_alloc();
> >  
> >  	free_area_init();
> > +
> > +	sparse_init();
> > +	for_each_node_state(nid, N_MEMORY)
> > +		sparse_vmemmap_init_nid_late(nid);
> 
> Would it not make more sense to hide sparse_vmemmap_init_nid_late()
> within sparse_init() and have it called at the end of the function?
> 
> The flow would be:
> 
>  sparse_init()
>   sparse_init_nid
>    sparse_vmemmap_init_nid_early
>    ...
>   sparse_vmemmap_init_nid_late
> 
> I think it is better to have sparse stuff all together in one place instead of scattered.

Ah, I see that you later remove this stuff, so disregard this please.



-- 
Oscar Salvador
SUSE Labs

