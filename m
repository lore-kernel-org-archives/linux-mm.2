Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E0FC7C5AC82
	for <linux-mm@archiver.kernel.org>; Sat,  8 Aug 2026 00:19:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 787BB6B00A3; Fri,  7 Aug 2026 20:19:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 737A46B00AB; Fri,  7 Aug 2026 20:19:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 64E1D6B00AC; Fri,  7 Aug 2026 20:19:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 32A5F6B00A3
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 20:19:22 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 8CBF2A0BF1
	for <linux-mm@kvack.org>; Sat,  8 Aug 2026 00:19:21 +0000 (UTC)
X-FDA: 85076192922.22.208C26D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id D69C2C0002
	for <linux-mm@kvack.org>; Sat,  8 Aug 2026 00:19:19 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AEcamcDg;
	spf=pass (imf10.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786148360;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fTh+tlr+MLwVhLjQqoQiJDfHy6vLLNfFF0nfrsGeNks=;
	b=2nUCUA8o8x7PLkksOmTye99tAF868PKNYhxIVD53rc5EAjITzOGkYleFABZzqKPTueofRB
	rFK7oWFw/PWvmPjjVi+xQF9god9lLZWS+p2D1Tj1L8Gf5VPtI0iBL8mDkhbHwdnChi3h6T
	AlKw3DibcFW58VEMnI0+98lgNIq9PQA=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AEcamcDg;
	spf=pass (imf10.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786148360;
	b=NDQkFLPBcJTbwdzRHB+wH0K5jjyKQc7LxWRZDtrIW1bAM9jxBvogSeZmPOnwPL2DKdmdLh
	YaWzqI4xniC/HIY/40q9hSAxxsgATLCTT5id33GLojBu/NPEL+WBOli0G3PcIV7Jn8pH9T
	DKsWaiePtbgoq50Du7tA60TZncHmNT8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 121EC43B53;
	Sat,  8 Aug 2026 00:19:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5DA11F000E9;
	Sat,  8 Aug 2026 00:19:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786148358;
	bh=fTh+tlr+MLwVhLjQqoQiJDfHy6vLLNfFF0nfrsGeNks=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=AEcamcDgQI/AsYPr1XCKo5dgYxuYDyLUh8ZtZaIZ3eW9VTnIuvHyym6sFow+V+EmJ
	 BF/EC2CPLtBSLgmPX6/6yjyEdHeoRDl/w577EI29kncY8HueOnXAfUDmLNu1ATrBK0
	 9ZHnpUTzm6ZDI+IUC2S3qusrId8dd939bIuBbpV6wqmH5toMuH+v5IRoDmAAIC8NJa
	 ZnCIe/9qy7oR0D+Vma5F7lQV9JJQ/WHEISQwrjawugi+3KAdfa5HZJkwWNdtB4zmLK
	 6Oj6DMWXxTgkA/N+f109WJn8XhQmPW/lxnxAfz2oaKrLa+dwH1XPSgkyKAkdJZ4FlO
	 V0E1EDno6R1YQ==
Date: Sat, 8 Aug 2026 00:19:15 +0000
From: Yosry Ahmed <yosry@kernel.org>
To: Brendan Jackman <jackmanb@google.com>, 
	Brendan Jackman <brendan.jackman@linux.dev>
Cc: Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, Peter Zijlstra <peterz@infradead.org>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, Wei Xu <weixugc@google.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, Lorenzo Stoakes <ljs@kernel.org>, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, x86@kernel.org, 
	Sumit Garg <sumit.garg@oss.qualcomm.com>, Will Deacon <will@kernel.org>, rientjes@google.com, 
	"Kalyazin, Nikita" <kalyazin@amazon.co.uk>, patrick.roy@linux.dev, "Itazuri, Takahiro" <itazur@amazon.co.uk>, 
	Andy Lutomirski <luto@kernel.org>, David Kaplan <david.kaplan@amd.com>, 
	Thomas Gleixner <tglx@kernel.org>, Patrick Bellasi <derkling@google.com>, 
	Reiji Watanabe <reijiw@google.com>, Sean Christopherson <seanjc@google.com>, 
	Nikita Kalyazin <nikita.kalyazin@linux.dev>
Subject: Re: [PATCH v3 03/26] mm: introduce AS_NO_DIRECT_MAP
Message-ID: <anZ0vPCi-yq_n4IA@google.com>
References: <20260726-page_alloc-unmapped-v3-0-6f5729aa9832@google.com>
 <20260726-page_alloc-unmapped-v3-3-6f5729aa9832@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260726-page_alloc-unmapped-v3-3-6f5729aa9832@google.com>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: D69C2C0002
X-Stat-Signature: 3ej59ptchz15mspp9dor8mpjjrw9hs8a
X-HE-Tag: 1786148359-234840
X-HE-Meta: U2FsdGVkX188G4LSZ8xK7isDh8vO8CPcrbq3DFVPG2Vx7ehkDktp/DFkkdXaQwVlysG0SAxyVdZIpwFxX8sE00qPGgOvedxgfZ5QjpTghsQTeBh0hddbFCrFDDsm8Hb/yY9VhwvHR8YWasCGXe+Z+3Ns8zbVzY0QSBq2zjkVCRTtDKX7b+3eKwi6Wd3LTXGiZGNQOFRW2Kar4bEpoq8WXc+/kBOjcVx8Q3ozA5Kavndia+whv8R5K6WzqyF3QMCgzS5ThsasVyvd1oHm/o3qUUc1RCR0s+np7IYGGfZiuJoTHAmS2LOlnLExG848dpjnlpP21h2JjKjtZFktvHWP4FR/d1Q/p5ubwVNg9ReFrBFr5aaQ9iCkvaAqZrScsgs5HrpStppp0dKpI8xCDumSobpQbXiMVFC6Ze9bM28s1OQPByZkkqQHfynrygsjTeSJ6Lhubt6UaWspil+vsTyJWy/YrRFEpTu0KTpl+tcCuJ5DVp9p2Qsp4bTeeUPEGK4cP30cKrmmZbzsyd2hlhOB5t2MEYg5Eg4RgV1kl0f0gDFOT/WN1+BnoiD3CHR+P+GlfmYOWo12HArCh+ZUfX/lV/yvXkf0JLE+3Eu1Lh4lLyptQrMavrJr/c9S7dBC/e5JsALaLScH3rbhauH+78/icAbjwmsVAZD2pR10wnzCxIUP1YDv3c53U9kaSZrxoSDXygNVDAzB5c2CTKFSsmQI7HD+OATdFHoY3+9MMzdM4/CgCBco27wYOeehSjod6ObPvaJ97/d1k69ZBLrUpNaI7TAs21QJ2Q9UZMqtO/6wLAUdX/AHL5A/Gd/W1SUhX712gpGEmm0RF7XJsJgfZVR98//GD+2A9VgMFFjb4fdrC8lUggqd3UTVCfYyFeWb1mRMh7l41KQt7rpl1KBbQfbC4WU3/BYq6qW+jX3VIIXLff7mTjoYJ/dkz4e5U0hUpq6V6Q9UWdUQN/u7S1537+W
 hyl+yn93
 GOp7nPJzGdeDBx58cGipdvaZxjh1ZgbW4+pSW7ko1lwyW0CyjWekqdU/FSVWmCY7xEaC6CjOXLxSpqtr7c3XBK5N2YV+oaJONLoCtvtRVrP7bp8h+av38EEAI8xIO2hx89f2M23pE3Q9hyNpuENLC9QHALbC8nGwcV8pq6M7208JAsfUUtRCJj1PTfkbTylRQTnK3SX9xqY+dmfztcp7IDyT0z++LLDc+Q1lAsQrjGX5X8bv06/K2q9dAHwg1r/SXynGI7R8rRvprt/+obPaTh3w8lrYfMAxZ8UVIf/OvgRFyUj3fAaZL57/uB9Q3pmIbbIDAUI23MFIXwXYaoIgHNIOuaTLM2+oF3syxPD8nbikKY4iXuyIOFSGBhwmneIkpAxSbmm7fSsyws4Q=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Jul 26, 2026 at 10:22:36PM +0000, Brendan Jackman wrote:
> From: Patrick Roy <patrick.roy@linux.dev>
> 
> Add AS_NO_DIRECT_MAP for mappings where direct map entries of folios are
> set to not present. Currently, mappings that match this description are
> secretmem mappings (memfd_secret()). Later, some guest_memfd
> configurations will also fall into this category.
> 
> Reject this new type of mappings in all locations that currently reject
> secretmem mappings, on the assumption that if secretmem mappings are
> rejected somewhere, it is precisely because of an inability to deal with
> folios without direct map entries, and then make memfd_secret() use
> AS_NO_DIRECT_MAP on its address_space to drop its special
> vma_is_secretmem()/secretmem_mapping() checks.
> 
> Use a new flag instead of overloading AS_INACCESSIBLE (which is already
> set by guest_memfd) because not all guest_memfd mappings will end up
> being direct map removed (e.g. in pKVM setups, parts of guest_memfd that
> can be mapped to userspace should also be GUP-able, and generally not
> have restrictions on who can access it).
> 
> Signed-off-by: Patrick Roy <patrick.roy@linux.dev>
> Signed-off-by: Nikita Kalyazin <nikita.kalyazin@linux.dev>
> [Moved zapping to page cache; removed review tags]
> Signed-off-by: Brendan Jackman <jackmanb@google.com>
> ---
[..]
>  /**
>   * filemap_remove_folio - Remove folio from page cache.
>   * @folio: The folio.
> @@ -260,6 +309,8 @@ void filemap_remove_folio(struct folio *folio)
>  		inode_lru_list_add(mapping->host);
>  	spin_unlock(&mapping->host->i_lock);
>  
> +	prep_remove_unmapped_folio(mapping, folio);

Does this miss callers that call __filemap_remove_folio() directly?

We can't just move the call into __filemap_remove_folio() as it will
later include a TLB shootdown and (at least) some of the callers have
IRQs disabled.

> +
>  	filemap_free_folio(mapping, folio);
>  }

