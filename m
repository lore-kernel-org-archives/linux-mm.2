Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 57C23F33829
	for <linux-mm@archiver.kernel.org>; Tue, 17 Mar 2026 09:37:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A88F66B0088; Tue, 17 Mar 2026 05:37:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A12D76B0089; Tue, 17 Mar 2026 05:37:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8DB396B008A; Tue, 17 Mar 2026 05:37:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 7B8606B0088
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 05:37:50 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 41F5F5977F
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 09:37:50 +0000 (UTC)
X-FDA: 84555053100.02.78503B8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 832C810000B
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 09:37:48 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ID4VjXHp;
	spf=pass (imf14.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773740268;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6lv+QlfAmvz8ULPA8N3IV0L31NrfpUQoIkLYWeyK4h4=;
	b=BIyJNIegFGaZ7V11/PNVYrTGe9e92yVEI151E1dA9UB8qMuZmbWJXkKP5GuFYqLOkb78fA
	IqSsQWbrcfvTrdMajK1GJM19EH9In6q/iNcdBxQ4kj9WJxwwALYzlZFF6NbgzSpkEhwS6c
	XwnCE4OpYZjO9C5YOXx7hK2fQ6sdgRc=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ID4VjXHp;
	spf=pass (imf14.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773740268; a=rsa-sha256;
	cv=none;
	b=6loZ13U6ra3RSM0wPKQCkRZGqBMFk055sZJ1GvwbpmbwEJ84MfTpgS1GJ4yWaj/DcyqKd3
	gUF3d5IVRMDIUuGW73g1ULs5/zbRvQ5Olatg5iVEyAWBVM4mYJm529IY6tRtnZUxSih0Om
	5Qx3iYrDZLMqpC0hXRiTm2OeeqTqhqM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 5047E403DB;
	Tue, 17 Mar 2026 09:37:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 683A1C4CEF7;
	Tue, 17 Mar 2026 09:37:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773740267;
	bh=3908OmCkPwPpavgQLfiWA7d+Y76sSzivYABpXZDKedU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ID4VjXHpTAT1SyuqsuYtdSP8PqxsJf6Ik/YXiROwmdjgJoJyGAKM+NUEj9VlRMrHL
	 cn0tHf+PB4Mw74GlOpNKA1iSnuFMPbMNLsMVK2VnqvT86Qb8FhRW8GUBXSUaakgS4T
	 G92uznoQYNWb8Asz/4FhSNJktgF4Mh0H750nj6XpMGA5XYr5TNgJXqeLbcfFpmsBkI
	 2MwrzN4OeCnEm3VPpe5qMP2cgzZncu5aObz5L/6StWNfNT8MuPPE+tXnwXlr7XSGaL
	 1BtIaRaK4uWC4wnrgDGyhdZjxMUqHyD1hE42yCJBK5j7t6yea8ZztUjF/irNJRCVTl
	 7A9kTOE1hn96Q==
Date: Tue, 17 Mar 2026 09:37:39 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Sohil Mehta <sohil.mehta@intel.com>
Cc: Breno Leitao <leitao@debian.org>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
	Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Brendan Jackman <jackmanb@google.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Mike Rapoport <rppt@kernel.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, usamaarif642@gmail.com, kas@kernel.org, kernel-team@meta.com, 
	Wei Yang <richard.weiyang@gmail.com>, "Accardi, Kristen C" <kristen.c.accardi@intel.com>
Subject: Re: [PATCH v6 3/4] mm: huge_memory: refactor enabled_store() with
 change_enabled()
Message-ID: <1b7d1bdf-c002-4543-b858-09fd2b1b73f9@lucifer.local>
References: <20260311-thp_logs-v6-0-421e30d881e0@debian.org>
 <20260311-thp_logs-v6-3-421e30d881e0@debian.org>
 <322f6f2f-840e-462f-96b0-b603b9c88582@intel.com>
 <abfVLky1zanZyEx8@gmail.com>
 <a503cbfc-e7d9-40f0-99ef-d640a0b5d78e@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a503cbfc-e7d9-40f0-99ef-d640a0b5d78e@intel.com>
X-Stat-Signature: ugfdeadg1c43szp4a534eymrnhdzm8zx
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: 832C810000B
X-HE-Tag: 1773740268-640327
X-HE-Meta: U2FsdGVkX1+PE7h4BT+vY45VvSXxB1/a1ZNnGHpSaRC1wTDiPKBHyBe6QLLgkKHUUv2AgFenIV01MqaEbgipILr4ZAsn/6+Y0gftNshKdfO0Cih5sJnFjhO/hUNsM6NHn5zf2B/QAjNt0l0rCD6jvTwViFxVl06qDM5XbJWMoOriGpevBGuy2/G2meC1kN+9Dc1wCW9HMemzcv1yZcGAtdu3wvkZBgucVQWjV/QdLaOoJmkJ783sRlyV+40yFXBhYECR4EQUOYtfRK051BbISDk75oxpA9PrZqiCT1xdkb2zx/bHRjI3zE1ATn/ZyQdMijrHFswtUIcjDdk2hp9aMFM/wu0H5SF0++qLlcDCXm2wu0pqH+ev1PO8hDiQzOm12PSJujbIs+0fe46Z8PNVhLpl/y7Lj6XPngw6atmgXQhvXYBuHhClJ5FjL/pu/tVZnBO60sqzc4Lqv9ol89S057X0gRW1HJ/sA2yLjWy6SCKtl9yMKkhnpYQLUum0rzMu3PuqqFQdJxZCIlmk8O7P3oX+YImIRzItR3GprCGrCVXy2rJfD75LTeSig7bdmJUJ8RUMdwYJ8o+X8+Ye7sS2jQ9KWYykoHzsWFO+60wltIlGvWl35Lp1ZH+Pqw+Ef/towYPulkBi6NjbVzvg8TLxEDW7fHld7OmBONU7BrH/+Ui/qtfiut3Mc86bpIQGocqoaLYYNn+2M/kCuQC1iUt2774XN5oMHDp5U6RI4axjHqcHHHjW6/k329kVffQo/vAwpTZDJ21Xv0khWh2BD0zqPqdTZmLiITzzWL79hAj1kE0sXpQQISjNOikXPAl6mg70f1H2XMfrPRutZi0oqLHaizCSSiGiqlvY1PXOsXeu2JckcP0TXKGMg6jOZp0V35A6BdN/A5dpHh4/LS2YjCO7G0XNFcntPezCL9DMuOOPUPOMFiI1ceTmnWf/yLywNuujxhAFQ6NdBHM3V7S8rZu
 Kntm9g81
 5DJODQiVclkBOGf3xf8vnECp87s2n/KxYptdkrp6u6aXu13wQRsZwiIaQXxiDyrbQrz9PW16ixlAsNnLMYT6RTAKE438+inXZU77OMnsynpi79419lnbOJMVadxKhdjqsQPvYgzk/foSiCX2nZ/mcwkky/iWV6P6Me1h6bw3pIUA4HU3HA1gwR14snCPXJ26af5Xy4OYdtplnxVjQCVrt7aLdlFy3APyKrDHMmyK+jrUYHeJ3sY7Yoac00R3WnXIEhEMyRbbFY6U62Vl8uUjoU+efzHE3w4YBmUA3KrJ9dZWb4+ecWKJeUDh1Zctc0+f3dQdj83ukeNHWM0w=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 16, 2026 at 04:26:30PM -0700, Sohil Mehta wrote:
> On 3/16/2026 3:12 AM, Breno Leitao wrote:
>
> >> I am not a mm expert and typically do not follow the mm list. Is there
> >> an issue with the usage of non-atomic variants here? The commit message
> >> says this uses the same pattern as set_anon_enabled_mode().
> >>
> >> However, set_anon_enabled_mode() has a spinlock=>huge_anon_orders_lock
> >> protecting the access. But, transparent_hugepage_flags seems to be
> >> unprotected in that regard.
> >
> > I don't think that the atomic vs non-atomic will not help much, given
> > this is a compoud operation. Independently if this is atomic or not, it
> > is racy with anyone changing these fields (transparent_hugepage_flags).
> > In other words, Atomic ops make each individual bit flip safe, but
> > set_global_enabled_mode() and defrag_store() need to flip multiple bits
> > as a group. With atomic ops, two concurrent writers can still interleave
> > and leave the flags in an invalid state.
>
> You are right it is a compound operation. So, there is an existing issue
> with two concurrent writers which can leave the flags in an invalid state.
>
> But, I was wondering if there is a slightly different issue now due to
> the non-atomic part. Some updates could be lost depending on the timing
> of the operation.
>
> For example,
>
> CPU1 does:				CPU2 does:
> set_global_enabled_mode("always")	defrag_store("always")
>
> ___test_and_set_bit():
> // Trying to set bit 1
>
> old = *p
> // reads flags, sees defrag bit=0
>
> 					set_bit(DEFRAG_DIRECT_FLAG)
> 					// atomic: sets bit 3
>
>
> *p = old | TRANSPARENT_HUGEPAGE_FLAG;

> // writes back old value with bit 1 set
> // DEFRAG_DIRECT_FLAG is lost (reverted to 0)
>
> IIUC, this issue didn't exist before. I think it might be safer to use
> the atomic test_and_set_bit() to be compatible with the older code.
> Though, I'll leave it up to you as I don't have expertise here.

No, it's up to the maintainers :)

Given the above I think we should switch back to the atomic accessors.

We can address the broader issues with this horrible code in a separate
series.

>
> Overall, as you mentioned below, protecting transparent_hugepage_flags
> with a spinlock seems like a better, long-term solution to me as well.

Yeah, let's look at doing a follow up that cleans this up in general and
address that then.

>
> >
> > That said, Although I don't think this patch is making it worse, I think
> > the is a racy issue here that we can make better.
> >
> > My suggestion is to move the rest of the helpers (defrag_store()) to use
> > sysfs_match_string(), and then create a thp_flags_lock spinlock to
> > protect operations against transparent_hugepage_flags. Any concern about
> > this approach?
> >
>
>

Cheers, Lorenzo

