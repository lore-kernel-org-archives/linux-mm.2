Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 03F59CAC59A
	for <linux-mm@archiver.kernel.org>; Fri, 19 Sep 2025 21:19:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3CE3B8E0006; Fri, 19 Sep 2025 17:19:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3AD878E0001; Fri, 19 Sep 2025 17:19:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2E2F28E0006; Fri, 19 Sep 2025 17:19:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 211E48E0001
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 17:19:10 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id BF8F013BCCE
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 21:19:09 +0000 (UTC)
X-FDA: 83907265218.19.3270375
Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	by imf18.hostedemail.com (Postfix) with ESMTP id D87091C0006
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 21:19:07 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=nGJg7hTy;
	spf=pass (imf18.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.172 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758316748;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=p12cTL26ZHFVM4Qm9V+H+3b/qs9Q3cDSdyY4Ygtksps=;
	b=hdn88hwKRE8HfQQpYW52M8VAGlpH/5e+vN7Cmyfv9oGqqoWxJeeHb/8TAb+c4Evv058r5N
	0Vfb5GDMm0k49/tp6MyCic29p4Rp6M7ItGm8cotoWcOq2aX5sqnV306dodN2dNDdcV0HeC
	qj1YoTISA8cxhhTW8QwmLUOAZORBYno=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=nGJg7hTy;
	spf=pass (imf18.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.172 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758316748; a=rsa-sha256;
	cv=none;
	b=GSd6zbtgOsc46xA0GITSXGpccEDkJa/ilvO+lWVnJKzrUlP4vXo9v/U1vngzaSb8kNNxM/
	UQsh3ql+aGkdau8w7PCSuZHwNIKX2xtw5FivITpmtL2Mj3Cv1CXnHo3XKcwVEi4R+VEFfH
	2NutiyIEjDbwn+UTCtcF+Udr+BYn3pc=
Date: Fri, 19 Sep 2025 14:18:56 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1758316743;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=p12cTL26ZHFVM4Qm9V+H+3b/qs9Q3cDSdyY4Ygtksps=;
	b=nGJg7hTyy/6oFsvUnre0j5HvVRBGA2A/LqgWlsORgFlczoEBROH9HQMg62fACPXS1A7Nwh
	Gy1z3upufBIMiWNXB5t7yz4zdT7NdHcSq/AOuE9C0xGupOFO7BYLin6X2tiCp/zeiOEfL5
	YccEWsq/XtqO8eeMHeYqFnY/GoJr8f4=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Kiryl Shutsemau <kirill@shutemov.name>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@redhat.com>, Hugh Dickins <hughd@google.com>, 
	Matthew Wilcox <willy@infradead.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Rik van Riel <riel@surriel.com>, 
	Harry Yoo <harry.yoo@oracle.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Kiryl Shutsemau <kas@kernel.org>
Subject: Re: [PATCHv2 2/5] mm/rmap: Fix a mlock race condition in
 folio_referenced_one()
Message-ID: <vc7lycvsvehisjr5drbng2lupytme3grubxbtgavvvjknkgzd6@axgctxng4424>
References: <20250919124036.455709-1-kirill@shutemov.name>
 <20250919124036.455709-3-kirill@shutemov.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250919124036.455709-3-kirill@shutemov.name>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: D87091C0006
X-Stat-Signature: wef7ocoddd6rc18zubayena445o5cjyr
X-HE-Tag: 1758316747-158612
X-HE-Meta: U2FsdGVkX19f1RB46GeQJcvJNsapnCKC64PDVkzDSVKDmOEZe/3sfYJGTTEHsCLQUHEuiEcZ04wLG/4xRzSo0lS4NKr4ksbnUcyDs4D3TdNvT93Gy29dR7rbCotY2gHHwqyLeNAJHE92530U5hA1VpLZP9T7Fzzq0G+wlgwE83uDz8vMEZOgyZ3T9J5Qmel4EGGdgcO4oOTIuRV8TUatG5tS6TEHdbbq2SfAo3kxJVeOYi8WaBN8CndCzyqwc5pIrHJJ7LKRpWXl4Z3gCwO5jLaiULaZYN4qu/CKc26drtzV3SY2Sn3RAD2GbV8cnccZwCdxRydb4eDF6xtMNhb5+Xv+bwc9/jA7PgGHzWEwMnokukOZmyBgU5rj42He2GKpncUAZqrLBTLGhb/CX/P0wp2NL7VeIxeCcidmgFWt2MJOYHHn7ArQ7wsors19ca8fnHys215YHlUNbyYzS7coZVpFmdWbYvLLaHof92BlqlMeBPHB/ekcdhSQAixYdOhaKylvz+dPuot4U6ZV3D97R5eP/sfHRO1akytphZHSm+gGquU7uR/QPWQezby14o70YHO6IZ88eTqq+QbJvNMdHx24vIf4wi3185db27nG0dlB4x+T2oMEMBGFOHZ3aDnrb3E2qN1wHg6qthM5WKWMu1MiiD93lQLyFvNYYfKgcB984woC9/9p6N3lMj+Q7Sde7xGid68OmPrpt6U4yrA18GLzoo7aeFixUPmylg2b/H21iTUeAchZHnQ2L4KMmLtKRD6dvK6SQkGAn4EU16ORE/rOscwMTC7bSpNh68DwraKzY6YAvDuE4pPiXQsCOil+P+UFstPFojCMSqFt44JUXOuywQ/pnYfreKbk/NEVbN+WpTnNDxAj8TWv+D8HFQhwTqfuS+KXrNTnKf1h0E7rx9gA8FYOAgta52HtJWYuGg1CTyUkUXomhvV3nqwpudQo+NQjLHOyFB7dopxkEHa
 NvF5y8ta
 TGYeW10RD+NaItx7YbxbASU1Nf6SWDD4bhC266/v8SAq73b/zVqV0FvdOu8J2EyasLpmkUikf3Z22zAG8ERgQl2cCriEUBH0dW4qW1P8S6PmNzIBSdb/d46vua3hfj//WyrsgVjMIsU4dY8JYBmJk59T4T0hFf+gQKedCkt6abAABuHQAsBt7GEfipHnGj43PQx0UJ2/7FKvvEW6wEBRFluAJhL5Fi6Fvh+EM30YfpNopvEk3Td0WYmlk2gmCA3rI/aihlQjaC/8EiWDro+ZRaSpNQQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 19, 2025 at 01:40:33PM +0100, Kiryl Shutsemau wrote:
> From: Kiryl Shutsemau <kas@kernel.org>
> 
> The mlock_vma_folio() function requires the page table lock to be held
> in order to safely mlock the folio. However, folio_referenced_one()
> mlocks a large folios outside of the page_vma_mapped_walk() loop where
> the page table lock has already been dropped.
> 
> Rework the mlock logic to use the same code path inside the loop for
> both large and small folios.
> 
> Use PVMW_PGTABLE_CROSSED to detect when the folio is mapped across a
> page table boundary.
> 
> Signed-off-by: Kiryl Shutsemau <kas@kernel.org>

Nice, this simplifies the code.

Reviewed-by: Shakeel Butt <shakeel.butt@linux.dev>

