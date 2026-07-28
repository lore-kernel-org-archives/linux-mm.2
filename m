Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 399F4C54F4C
	for <linux-mm@archiver.kernel.org>; Tue, 28 Jul 2026 13:35:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B6FCD6B007B; Tue, 28 Jul 2026 09:35:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B20026B008C; Tue, 28 Jul 2026 09:35:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A115C6B0093; Tue, 28 Jul 2026 09:35:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6F6A26B007B
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 09:35:52 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id CCD69803AF
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 13:35:51 +0000 (UTC)
X-FDA: 85038283302.04.3593300
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id 2D78AA0011
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 13:35:49 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hJ6ZyGrX;
	spf=pass (imf25.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785245750;
	b=VEI2gN5AApI3UxWGtyFWUc47ElrC6xZSSDR4vUjm0W+ck/bDdEjcDWPyN9+y7qnfjqeKjA
	BoP46LOqDhGSB5/qXon0VrTOt77nLjn5Ai6FnEamRR4MWLzCzB/qrdRdEKoH7+J/Uw4lNH
	WVSRtL6H5nFO+TdHdYADOsjsffVbgB4=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hJ6ZyGrX;
	spf=pass (imf25.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785245750;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=F7E60EEGx3HhYQLCew9dec70QQpFr1JD3ItgZk/3IBg=;
	b=5ewMGgzhHXTP9T41rUzjuouLe8VtRLnSncwc/UaNylcewwFeRE5J5woSHZgsGb6z7jfdgd
	qgWiit0KTaF/IhKimkuXkeOD+ujAIm4zkBMG5//Exu9QfXNJBWOJXcJab80qvPrfaAd82q
	eH6iIfU8xAvzJWzB3S3FZTwPRbRJ7ls=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4579540DE8;
	Tue, 28 Jul 2026 13:35:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F6F61F000E9;
	Tue, 28 Jul 2026 13:35:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785245749;
	bh=F7E60EEGx3HhYQLCew9dec70QQpFr1JD3ItgZk/3IBg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=hJ6ZyGrXFohV282rb4DcBTZtLaXEm4DG4EzBSaAk21cm4cHuYoe24V2bP2A3XjLTX
	 7/D8dj15R5W/TNZgNi8iJNfMD6iu4ysPmFfd67MHL87sKSj/quy+1zpDftRPgID1md
	 W1Dg46CjtdpalY9SmavmC1shWHb2XACiP+0fjTLovQV4x9EzRnu4pwlZkM0prax1iI
	 IYZfhTDMOXUzqcjDzb79D/1mBLqK9/xMKVSgLT4zm79An4+G6SLphQoJHGp/ayHn7Y
	 NHm/DiPdusfbad3D4k8lq9K3yZREeduP64s/aoQP0iA/h7DLaYue/b4dvGjVmFeSuv
	 erXV/LxzbgXtA==
Date: Tue, 28 Jul 2026 16:35:41 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Pratyush Yadav <pratyush@kernel.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>,
	Alexander Graf <graf@amazon.com>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jason Miu <jasonmiu@google.com>,
	Jork Loeser <jloeser@linux.microsoft.com>,
	kexec@lists.infradead.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 00/21] kho: make boot time huge page allocation work
 nicely with KHO
Message-ID: <amiwLSEi8cczamP1@kernel.org>
References: <20260725172133.4018491-1-pratyush@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260725172133.4018491-1-pratyush@kernel.org>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 2D78AA0011
X-Stat-Signature: t888rqmn6jstnccs6xa1oaegud64hf3s
X-Rspam-User: 
X-HE-Tag: 1785245749-290090
X-HE-Meta: U2FsdGVkX19nV9mKXNBVQWfcOpxdRnLntSy124RYRQu2INlzHaYr7o6WeKekeJPH9hbBnhHKMSrpAGBbapvov+oGS2ZwWOhqksLFgoHIjgegFKWSFlffUQD5VuiUGKYWWL9F3wn0NCEWn1JzlDQfflU3PxRUHr/seOnhj4egHarsOKd4o5ZkePgPPT/kwAEf9tRN+gIwDRIhwUVYHvxzepSburYExWvsGs1Xxc63lV1mz7RNHmYkU649LvIVNvr05Hn7VX0a4aoVGel0K/caAt26Kici6k1OvZYOkmFhw7VivlbNjn8s40SJcVyVYPpUINLQz4bpt8F3RvwPsb+DxTEMWypD0NQtKRulZjqVhiEFCnTAD8ujehC4rcLzG/1ZvFuuV/3vf8X3HviNVgv3YOQ0LycSafQOV6L3aIU0IR0DVj/Hi/QDfykz3Sv5mFrTX/5RhtAzmXx3YEbhaa/Xteo9zNPit9wBJ+nCsWKHwYpFAJQ6qJTF10wEkvn+cDwK4nM8NHrxtqkmoOJWIG4qELyL2OD1+LcGw47DUyujP0WVMDAgYnbTTFNIea6b7cXS7hRKe/UehGK6ju/bpyh9JRaUnIGOnZBVPkmUNlpfWZL0zt8Pg+rew3nH7Dxi6ltWMs85YhffLbdKaNGqmRG5fqq1EZpd64wXXuF0JMHkH/EyV0LlR9xs91IBloyxnne5GWWwpMn4G18yKdz/v3Jwz4gIL9wsJYfkK0rwkNX878e5c8oK3H7AYgRR66yPUhq0Bn/QmLA6cUIGmQHiFl+1PksZjZRMFP9py0Csq3hsK8ujSJs+PH9+LtAd0/h9/Ou3jurtkt6CgVye7wQt7oXSB0x1dEbAyzx3gjYUOMdhroMYNOu4cOKL4O8JzyTUCdJ41w1oPyqTvzjSXgZjB5ojc6wpz55mvAoY8qGS8xMjRwNQemR4Xs8hOKZ2AdHeM+uvAzIl8b6RrmYzxvlXxtL
 uyHjPLJt
 SCiTAqbyrGcQ4zT29q+kyDvOwHnnXWlTvVkB74Yp187pLUp3XKV/tnPVZ3Ez9XUng89YZjXXCgXFLCh6Jc1noo1aqw2JavXlsKRh8y1E4nGN1CCN+G+lud2Ip+cYmmryZjnu8czD3paSkdgazS9zVKZilBlWqqn7eZa1pvX+HQO+eUKoU7G6d8+djz3TxIK0wO5sA6AAnjVhq3/XVJVls5jlXbSrpkSFcru61rQ9kwtJAxlM+AUcr1Jpbjwp7pBmWs1qSXcwMZcrXU8wELIXhkZoDdQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Jul 25, 2026 at 07:21:00PM +0200, Pratyush Yadav wrote:
> From: "Pratyush Yadav (Google)" <pratyush@kernel.org>
> 
> Hi,
> 
> Gigantic huge page allocation is somewhat broken currently with KHO.
> 
> First, they break scratch size accounting. Since they are allocated
> using the memblock alloc APIs, they count towards RSRV_KERN, and this
> scratch size when using scratch_scale. This means if huge pages take a
> large enough chunk of system memory scratch size will blow up and fail
> to allocate.
> 
> Second, scratch can not contain preserved memory, and if hugepages are
> allocated from scratch, they will fail to be preserved with the upcoming
> hugetlb preservation series [0].
> 
> Fix this by introducing the concept of extended scratch areas. They are
> areas that the kernel discovers on boot by walking the radix tree and
> finding free memory ranges. See patch 10 for more details.
> 
> Muchun Song (1):
>   mm/mm_init: simplify deferred_free_pages() migratetype init
> 
> Pratyush Yadav (Google) (20):
>   kho: generalize radix tree APIs
>   kho: make radix max key width more obvious
>   kho: disallow wide keys in radix tree
>   kho: return virtual address of mem_map from kho_get_mem_map()
>   kho: store incoming radix tree in kho_in
>   kho: move all memory retrieval logic to kho_mem_retrieve()
>   kho: add a struct for radix callbacks
>   kho: add callback for table pages
>   kho: add data argument to radix walk callback
>   kho: allow early-boot usage of the KHO radix tree
>   kho: allow destroying KHO radix tree
>   kho: add kho_radix_init_tree()
>   kho: expose kho_scratch_overlap() to kexec_handover.h
>   kho: initialize kho_scratch pointer earlier in boot
>   kho: initialize preserved memory map radix tree earlier
>   mm/mm_init: don't rely on memblock to get KHO scratch migratetype
>   kho: extend scratch
>   memblock: make HugeTLB bootmem allocation work with KHO
>   memblock: add memblock_reserved_hugetlb_size()
>   kho: exclude hugetlb memory from scratch size calculation

I added it to the liveupdate tree.

Please take a look at Sashiko comments, we might need v5 if it has valid
(not pre-existing) points.

-- 
Sincerely yours,
Mike.

