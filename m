Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DA690CD5BB1
	for <linux-mm@archiver.kernel.org>; Mon, 25 May 2026 17:09:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 37C366B0098; Mon, 25 May 2026 13:09:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 305D56B009B; Mon, 25 May 2026 13:09:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 21C216B009D; Mon, 25 May 2026 13:09:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 114326B0098
	for <linux-mm@kvack.org>; Mon, 25 May 2026 13:09:02 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id CD2E18BFA7
	for <linux-mm@kvack.org>; Mon, 25 May 2026 17:09:01 +0000 (UTC)
X-FDA: 84806577282.26.8B1BD9D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id 41B141C000F
	for <linux-mm@kvack.org>; Mon, 25 May 2026 17:09:00 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jRjDshvC;
	spf=pass (imf18.hostedemail.com: domain of osalvador@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=osalvador@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779728940;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=U1fgZMD3fJTNAghOf0xJr1uHYb54/6TV0xW4BVaYFe0=;
	b=eR9RNBVSd8U756lzZffRXt61GeFyiVO8akd6PH743O0x8ZBEGbxcXH2b4m4XdRuGBNEyKb
	YYQFbn3UmKSiXiz3BnqkBzC73O4V2MuWseoTn9ui28DxwE6pBRKKnN0HNu/NV+xsaXE52q
	Mm8turh/CF2MSN5SjK5ads0jwIXO4N0=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jRjDshvC;
	spf=pass (imf18.hostedemail.com: domain of osalvador@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=osalvador@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779728940; a=rsa-sha256;
	cv=none;
	b=v21n4Sl+IVYfYwYduIaYiFJpHIHX9N70xyzKlEjI/nJILuejDqCObkVPlp8vmgEP8xr5VQ
	fs2M+lSSCVNCELqEAEVwDmWSqa+HpE2QtyLnATxWmuJJJkcE5CSefbqfHuvtaeyfnysmoG
	730xU0bgsgGJJzoZy80+FBO2JHKPrg4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id B378E6008A;
	Mon, 25 May 2026 17:08:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EA601F000E9;
	Mon, 25 May 2026 17:08:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779728939;
	bh=U1fgZMD3fJTNAghOf0xJr1uHYb54/6TV0xW4BVaYFe0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=jRjDshvCJuJBUTSjrWSgZwa3oyAjxYMnp9jMj7Zk1PtO7XWQSD943spa1Ydul96c5
	 hRjV98B+z6Q6Bj4K2qggydXo6oBllxOj7Vin6BTULdDHy0vhrmJ+QM8MYOiV3FAwkP
	 2Kq9vVZettTcSTHxbEUFdqVWNZlr26oqdazIb4Lb+5hKCVARpb7Az7cs7QS0CB9Wh4
	 ZzwmR6Sf4hJbhZG8cHQ4gIwn7G9sFZq7ls97UbuQaYTdVz0AwA0SKNShBkU4M9YWrf
	 F6mlXaWr94EO3oiyW6NRJuuJCHqo6Ux3DmOO/qGTtewIAiX/UHy5xNULWMuOvkkAwa
	 k7i0K3OtcgvrQ==
Date: Mon, 25 May 2026 19:08:49 +0200
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
Subject: Re: [PATCH v2 09/69] mm/mm_init: Defer hugetlb reservation until
 after zone initialization
Message-ID: <ahSCITkk9FkNyszC@localhost.localdomain>
References: <20260513130542.35604-1-songmuchun@bytedance.com>
 <20260513130542.35604-10-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260513130542.35604-10-songmuchun@bytedance.com>
X-Rspamd-Queue-Id: 41B141C000F
X-Stat-Signature: esh1fz7aejauxy1tntsw47mxtzcdp9sb
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1779728940-114871
X-HE-Meta: U2FsdGVkX1898VemY+GNem4qQwyjvK3RB9g61t05fCY83TAq7q0snbj5QzEW+NBE3mN9fS+s5wmhTV1L6QMLsxtjJ14rYHyS7Flv26L+f/uWb8/jWq+YLYJALN0VuRn4rqTxjsoh6A0f/pV1XoT+67UO/SSyiyG9pMYZt47gcoXgchVt8+tklfopsskBdVIyetFNvuC9gm9N33XXcL2mKlZjPx68SS8yVu6/I2/DVa5sD1btxgm7OlbigXbCBATnBZme8AOIkxOOhjKUyzt9nAGkGdPdAH7K12EdGJHSgxuw98+hvl1t1ObUHFbkjYmk8Gmn8eNUk/XhMcdaKMFfmDhJOxfM4jpQFMmjlwr6FjTLnxYZmI1erfM91AEBFUHUJqvSm3IGinL5uiR9Mlr3daVrTr2FNEJ4s1zs9o3pNoXnXXF/MIbNX+Cnb7Q5TZJLfwwnedlQMSrZ6bK2mGOCNkuLxlPwWjPlTC40Mz+JiqfOVujOfpHmuuKjbg2dz/QHt5l+W6BiGNgP1lWft7+edmIa9zuVw5RJ5YRKqzGGsqKOtrs94M1c5frv6zT/C39SHPGPy92WduP+KocHC7Lplvl8u2NYkQG2Ddvo8SQYzl3A22o/Rckbekr+MKSgVms9gG2Ln5/sFH8u3fa2U+K1KTehi3qXppJ7G9NgI5ax+dvzmtfzQBR4lCpE35jOpeS8JAlS7DWaRk/O+2zdVnimdcSlhy1d2gohfxdXR1FsMOsgudFxuNSS3duWo2nDDQ09M8m6RSSBJf+L27Pr083QbUrRfA9qJyz6kH++vkpqHGJh+noegnssEnAVNNuE1teDE5nCDJ8Px8ban3j1dVc3RgkzYseJiOEUJ6z3mPjtcLOmlwuJpA9DqlNwhx/TbzwFLXbiJpRHMays3cE/yRByb30Tv7g7QdYAheK9/R9K27jnaSnn0UYzV25oLjIcgrS/lW79mEFijnOcLHwYLCw
 rBDstt/O
 8cEl/EAlVmu8vY3+1gq8f80+9vJ+3DhLomRxwDrnVGhOKPsdgxwMjfu3qROF3MIQDFdyqiKaJMAF6J3/jn4X54+JCqXl53FrNASXywQ3vQKvU3dsbPY2W4+5Ua+O5gon4cSQJf+HUy/K9NRIcd/gSPPhTPVllN2PO3PfaZUDzlpVYGAxCHr6PXdBjWKv1wSWfS4U2GBnLl0tsxJNdVLRPclPHib7lWkNgwKbTMKxcrZ7izy8yiuMK6ILyg0V8/OF4tR6tktXF1byUqztweDVMlxIkP3wrX7NIQhXaa+XrtexBMGYY0FP16X8uQA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, May 13, 2026 at 09:04:37PM +0800, Muchun Song wrote:
> hugetlb_cma_reserve() and hugetlb_bootmem_alloc() currently run before
> free_area_init(), so HugeTLB reservation happens before zone state is
> initialized.
> 
> Move the reservation step after free_area_init() so the relevant zone
> information is available before HugeTLB reserves memory. This is needed
> for later hugetlb changes that validate boot-time HugeTLB reservations
> against zone boundaries.
> 
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>

Reviewed-by: Oscar Salvador (SUSE) <osalvador@kernel.org>

 

-- 
Oscar Salvador
SUSE Labs

