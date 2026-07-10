Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9CC46C44506
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 17:05:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 861C46B008A; Fri, 10 Jul 2026 13:05:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 813416B008C; Fri, 10 Jul 2026 13:05:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 729976B0092; Fri, 10 Jul 2026 13:05:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 51FBF6B008A
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 13:05:07 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D19F11C8BEF
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 17:05:06 +0000 (UTC)
X-FDA: 84973492212.02.691F8B9
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf31.hostedemail.com (Postfix) with ESMTP id 3417720007
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 17:05:05 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aMzYH3zA;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783703105;
	b=gRQVIPKRd8Bu9dr7T+lO8owmNKsmACWEZ2NOssRGgRe8jlM7g6KNY51RN3wg4FWPMd8Kbo
	FzsS9T6/ISsv3zIGWI/BRYaQb7Ji4FTa91rkv6GcaN9UinPl+txBJt9XYAKHowKuh5OTMd
	8YZFZJb7IcDLXp5qmpHOvLeYLcOm1aw=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aMzYH3zA;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783703105;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AocXZFV/CIOSccLXI++7lB4dXB4UTMCcsgt6vDZC+bM=;
	b=3V5V7Op6zw2NOh6Pun5ci2DlJTnAN3FuMxbU8LCmrCyCjM1HvZAnCufngFRATYo2GQtnEv
	P0V6NIn4gBjpf53p2JWWTt0hq7rm4KqrIo/xsCZsor2VyLMi31toMQK4UlxO4PGwAuys/a
	Y50XtVNuDPL7fv++4o1UQFuXFHAiNUQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 92A2F60052;
	Fri, 10 Jul 2026 17:05:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC7681F00A3D;
	Fri, 10 Jul 2026 17:05:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783703104;
	bh=AocXZFV/CIOSccLXI++7lB4dXB4UTMCcsgt6vDZC+bM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=aMzYH3zAs+3wbAFnWqVBM8apCrSSsiS01IPD2V5K8Xaqpc8N8eLR6N8BpPAU+vWbG
	 Jbd1yXeOVf0RBf4q2k/l4ax9ZZwknfhDboCj1MZyC+8Dhon9aVRH4T6Pg1k534ycXs
	 BDTxGVtJkuO+qlxgA6NcWvVXEW7LWWwNt66lFdPLuSdQ8MhSUr+Gr+URw9zRON3c5P
	 9LXljskJkDHa7kwbxaJROwDk2IYdhFq5L+VRu9ybYNrLM8PINQHkbgfbGvbyYPhG5J
	 m2su8QQ6OG66nUrJRBDrmhCJOjQrbgPQ3qaBQSukd0P9QSJL0sazp/CLRlAyWN2Eil
	 shuKbiMUH8jJQ==
Date: Fri, 10 Jul 2026 18:04:53 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Hao Zhang <hao_zhang_kdev@163.com>
Cc: Kiryl Shutsemau <kirill@shutemov.name>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, linux-mm@kvack.org
Subject: Re: [PATCH] mm: thp: unlock i_mmap before releasing split folios
Message-ID: <alElCvx17Zg9FQzM@lucifer>
References: <20260710071344.GA106129@zh-pc>
 <alDSekC_5t-29vJS@thinkstation>
 <alEWEColDdwQboYX@192.168.1.215>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alEWEColDdwQboYX@192.168.1.215>
X-Rspamd-Queue-Id: 3417720007
X-Rspam-User: 
X-Stat-Signature: od4zn9eot8n7uttmpp16q3cmbm77bzb8
X-Rspamd-Server: rspam03
X-HE-Tag: 1783703105-85806
X-HE-Meta: U2FsdGVkX19vx64AMHLU4+CB4yeTqDnhH2mMYStT1Gg7bAqATYAPFAefb9bE6jYN7n+mwNTy3IZb7AFl4NSgQdDgRNZsBkzZRDDef9glDQW4ZHQOSDG3KG6YB5T3Qe/qNlgecYi49BTOZFlspIzj3g6Flw089VpGRfS4xHSF7vcGkUOj5MkuzVymCdYqkK1RTZvv3I3D43toGG1C6e6hxcysISWFK7MIieMo6Ms+fNZGJOws3Icn5EqUEV/rzM4aBlNXBFfTlLhjUqZ52sMJ5b05jc+/a1KAIE4QF0YUwxCu8POMBBHd3hZdsDkosgr+Bu/PZHIS/9MIIbo4GDJOCZaoUNXVwboVpeHGGHw4ycTJ7KmmRsG4/ci13NrMgI6ILDwO+lMk7pJgtUyKKXq7fAd6c5IiA/UXyDa0+wYvYgKo9XDF4BPluNzgJCwJvlpzvovGw/YiUY1xKk+zdN62I1PhyFQ2f0MySKhOhrYUi/cJeXPv8iy4UaaG+WfLoZK/MW2yxfMHfau298et1ic35Bix9u41KRJB2TTbAtxDj0k7cG8FKT+qrSmPP7YLbfwAJ7ZdVn3XF8XvOBNl/ef6KjlQl+yX821KinhD2XiKgCnPTdXZyolUZut+dDD+D011iaIwX3hzUQjleoYl26pKQHw3QzFoaDcNVw3QgP2+J+zspF8987l8e0SzCjG3fb8loJWVcpirYTAQbyPtBAzwWORCJlwjT2rtCdmYcyyYa3RigKsQaYMPa/K6KiYM44uCbtwHKJbca69HapfgmOmnOsrGjWe3c0qu28BY1knfR8va3809/TEm+X/v7fJ/8yIbR748tzw/W98wiXPJ8i9ZsmpmLQ/4BcxZ22SO3H1LR5ao9n31Zdl/Zvcsl+GdWobkzrbXpNcQ4wpe8i9V+kJ9GQQ3optB4FLsbkAN+AzwkA+do0Ux/Tlxr0gVI1sJHA2YKbmB6TTEDif6bD8WFXP
 EMeSoSvZ
 PJD764Gd/lgsbRlymSDHOJN/cped/33TaCT/6Tu3xQGGGdW1QtK01X3gyFw33FbWe1R0RWTKFvciJivetq86ZLD84ghMJRsy1/oeErVsSAYCH5PbHKtgNjfqFm9Osn1958+NrdV9OG3pUvQVaZ9ty/l//jsz073uGvsTsZUxt22sXn0OTm2DJ9ud4RdCjMPVpKqo+Jt+vRJ7qFEel3woAY/9fph9Zhej03Omhfk4hwJRvqou8Ry5F/nTpfcQ5mFS+cLH1dG9LYQB4H73k6VLIWM+mF2GCJc9a6fsYdvFXGPg608pjsp1PQsLqnLsaTuyscTnNua9pSwiqPhHTxz7lFEJmtcdJH/0AaszeiBmVfe6LD2rWJzHOTiozM+wh8d0fo6NluVauMbDmfa2YsjatbsyWvlEBpYcJpRQWYxwygF4RcbJpsLIKRdjTm2AQXk2vklBxQOD74evnnXlLCID9UUmhWM4gV1i4OZd6DbfmbUNfdQygvectC7UAztQlMocX0xu1LbiqDy+2l6k+C+nwCp786mVUNSvEmlAC+fowfMQnZDO0hq8HZW2cO2HaHkRQqg+jxNYZ+ubmiU+vHD326LF04jAMjAGL55O+KxksQxIImbyP6Eqs7Ohh8Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

I hate to have to keep pointing this out to people and maybe you were trying to
limit the mailing list rather to maintainers only buuuut :)

$ scripts/get_maintainer.pl mm/huge_memory.c
Andrew Morton <akpm@linux-foundation.org> (maintainer:MEMORY MANAGEMENT - THP (TRANSPARENT HUGE PAGE))
David Hildenbrand <david@kernel.org> (maintainer:MEMORY MANAGEMENT - THP (TRANSPARENT HUGE PAGE))
Lorenzo Stoakes <ljs@kernel.org> (maintainer:MEMORY MANAGEMENT - THP (TRANSPARENT HUGE PAGE))
Zi Yan <ziy@nvidia.com> (reviewer:MEMORY MANAGEMENT - THP (TRANSPARENT HUGE PAGE))
Baolin Wang <baolin.wang@linux.alibaba.com> (reviewer:MEMORY MANAGEMENT - THP (TRANSPARENT HUGE PAGE))
"Liam R. Howlett" <liam@infradead.org> (reviewer:MEMORY MANAGEMENT - THP (TRANSPARENT HUGE PAGE))
Nico Pache <npache@redhat.com> (reviewer:MEMORY MANAGEMENT - THP (TRANSPARENT HUGE PAGE))
Ryan Roberts <ryan.roberts@arm.com> (reviewer:MEMORY MANAGEMENT - THP (TRANSPARENT HUGE PAGE))
Dev Jain <dev.jain@arm.com> (reviewer:MEMORY MANAGEMENT - THP (TRANSPARENT HUGE PAGE))
Barry Song <baohua@kernel.org> (reviewer:MEMORY MANAGEMENT - THP (TRANSPARENT HUGE PAGE))
Lance Yang <lance.yang@linux.dev> (reviewer:MEMORY MANAGEMENT - THP (TRANSPARENT HUGE PAGE))
Usama Arif <usama.arif@linux.dev> (reviewer:MEMORY MANAGEMENT - THP (TRANSPARENT HUGE PAGE))
linux-mm@kvack.org (open list:MEMORY MANAGEMENT - THP (TRANSPARENT HUGE PAGE))
linux-kernel@vger.kernel.org (open list)

It definitely helps to cc everybody relevant when it comes to getting review.

On Fri, Jul 10, 2026 at 11:56:00PM +0800, Hao Zhang wrote:
> Memory failure: 0x5a6a7: recovery action for clean LRU page: Recovered
> Injecting memory failure for pfn 0x81bfe at process virtual address 0x200000ffe000
> ==================================================================
> BUG: KASAN: slab-use-after-free in __up_read+0x634/0x790 data/linux/kernel/locking/rwsem.c:1353
> Read of size 8 at addr ffff88800b81c5e8 by task syz.2.11034/45874
>
> ...
>
> <<<<<<<<<<<<<<< tail report >>>>>>>>>>>>>>>
>
> This is the crash report, please review.
>

Thanks but do you have any of the other pieces around this to help? Like a
reproducer, .config, the arch you ran it on, etc. etc.?

In general please do ensure you evidence things like this without needing to be
asked for it, we can't just take your word for it and the more you do to make
our lives easier the quicker we can get the review done.

We've had real issues in the past with private syzbot reports where it's turned
out on more than one occasion to not actually be a genuine issue.

So your help at a time where mm review is _totally_ overwhelmed would be much
appreciated :)

Thanks, Lorenzo

