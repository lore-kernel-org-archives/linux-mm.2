Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DD92CC79FB6
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 17:36:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 018526B008C; Wed,  9 Sep 2026 13:36:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F0B0C6B0098; Wed,  9 Sep 2026 13:36:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DABEF6B0099; Wed,  9 Sep 2026 13:36:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A93656B008C
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 13:36:24 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E7E9D802CA
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 17:36:23 +0000 (UTC)
X-FDA: 85194927846.23.4D941C1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id 415EA20006
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 17:36:22 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IAmI6yFy;
	spf=pass (imf13.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788975382;
	b=YsEBh3dstKqxUEkG/gQBBAQsZb59UyTU68UxAd2/+dvlHq/gPOyKgnG2dKJ6l+1rYSV/pn
	2bgEkQw+9CFZLijpMxrFcNbPwj1VNk0cB7rlvVUFx6/n7aG0p89QpkKXsN2bVE7w6+5KsW
	bQ4cdlnY10O7QCXCPTJYZ3wGgxvJprE=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IAmI6yFy;
	spf=pass (imf13.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788975382;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=grjJ7grimxd6jw67NHOyREHJUzRBSzDoROKCTALsAeg=;
	b=gxd9IiKOv1lr1a6Zavk69iqGyWpDK0FC7oZioyagfhK/ipk9xLetS9etgWarNYMl2p6+Q6
	hgEkkrRqC6p++4ChjBJQORNvWCrrIR7Lx+IIuZCNhxmuEH0QvOWNV5NGqDmR7/8WLFx2RP
	laUAXecEyeM9QvY23pZervNXQtdfWzA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 767636022D;
	Wed,  9 Sep 2026 17:36:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50DCE1F000FF;
	Wed,  9 Sep 2026 17:36:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788975381;
	bh=grjJ7grimxd6jw67NHOyREHJUzRBSzDoROKCTALsAeg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=IAmI6yFyEPLM+P5N668skF6zwF7RfjLhUU4MvBXfQHkN+wL7U0NSAGtNEJNvK5fF3
	 bGcu2oesBanp5aeMVmn8gDxbsQC4hdk7It+7RKpkF94SV652zgJCTQbis6Va4bkydQ
	 BDWCH4TB42LnxQDRN7rKiJearh94wvyDhDD6KUP9Ok6YlyA63uQc5FKy3y7/ZZ6k5K
	 gwPVLZNP6dYh4v34X9qObFvba04SOjuc376hBiOl+hv+9zwY1366D0kQeMIOkYarhv
	 x80Wzfkmi9PwgvqmoKTASqrkeme6cfp5L+dAEILmsMHmk1GsjASQ4zDmewxVIeRuG1
	 7tlcXOBZqofzQ==
Message-ID: <be6376f5-a2dc-4350-b03e-192e4e6b0b21@kernel.org>
Date: Wed, 9 Sep 2026 19:36:11 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 05/17] mm/huge_memory: rename __split_unmapped_folio()
 to __split_frozen_folio()
To: kasong@tencent.com, linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <ljs@kernel.org>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Chris Li <chrisl@kernel.org>, Kemeng Shi <shikemeng@huaweicloud.com>,
 Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>,
 Barry Song <baohua@kernel.org>, Youngjun Park <youngjun.park@lge.com>,
 Yeoreum Yun <yeoreum.yun@arm.com>, "Kiryl Shutsemau (Meta)"
 <kas@kernel.org>, Shivam Kalra <shivamkalra98@zohomail.in>,
 Kairui Song <ryncsn@gmail.com>
References: <20260908-swap-thp-cleanup-v4-0-b532a3f20e71@tencent.com>
 <20260908-swap-thp-cleanup-v4-5-b532a3f20e71@tencent.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260908-swap-thp-cleanup-v4-5-b532a3f20e71@tencent.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 415EA20006
X-Stat-Signature: yo7h3q9xidp1myonhf74yfausemqay6h
X-Rspam-User: 
X-HE-Tag: 1788975382-217123
X-HE-Meta: U2FsdGVkX1+f1BhI3FkMlQplemVfjCJE5h8ewZVET/GOGDUoIwAOUTTXkrYR2hV0HqgZX981sM9O/YRwjowOHH+8ZuE9MWu+0atzRpmlsvF3JcT+koLjjYemuKNkOMBHrKbHdigLcuQt2k2FsjXb88UqV3IVJnVj/hkotFLOKKQYRGqR7o5BAKXDsRORhxYFX7U+8fz5a80pl6ewQHNZMKihPY60GrSTGMAzL98XpIMhfxkoQfMJOprd8+OI0ybGVfzWpX46Gx9Q5Dp+leXXo7IuOLSvgqCijzUQfOtT/ruv02tJ5em9ZcdGfig9teC0ANm9za9qDb1m1OCE2KuWZiqKS3ghlcV9SSTuw0FdOvbXnMVxBQ+tVOREyDi0qEhF6DuSUZNUblbirPlzovX2+CaGvvhYGdB4a7vkUrWJx5qM3puQ/TJRkTyZXPs11MgLF2c3zFgycZdlqFci5TXaE33VPRaaesGGwgUAO13vNjf/9qOKsjxJtMwPpTtuynceuU5u3T8IfITW1X3A41lhbZFxDj9v+xzicpW0uwm/rC38K+gV233GUCODTz7WIqX73MUULP6f7eyV36ILUK34sjK9rjf5ZJo1yTKN6jZH6ujbMjptdi9R6jK+xQdkkIB92axkUQOH8T2hGmUsmhy8ujFxSkUoiaR8Gj+9pszxS+6SXkQSnKlxQr8GLYNVq+3iR0tLt35bIKwbllRjtJhcxSwUfTL21cFizXxdknAyiJb+PIQnZHHF/mHGULzk4iXmnX3/aWfBszE8HShYZLEEk4EiIh5WViEfGFwrMdk2ubApr/cOG7W+NUpkN66QGtNkNC6qdHSX3jzIzZM7TlGqRh0rK/f5oxTAtFDz85Sl7o1B7svVXwqmvtJqiWxVx+0ojb2H0YsTqrj1k0oUr/aEe3i6UICWPhA2n+PCxj0EmZpteywKtHj5LllbbCfvBIvYRm9E6GpGDh9a6jAx/nJ
 WtnYl723
 mm7WN+y+O8XUhVD3OMm4CC5P6v4pDMI9J/uKVmWj736GVUZXbLEx02JI6+U7/ydb6CTQR6Tv5g9R1YIQvTZcR06g+GhE87E6sY3r0wKTPjoxB836YjzGPRQ0qTbZbVCcLNrnXSaBf1IxSKWyAfxsuZ8npLvM+hQfvgO/z3+qmhAwGGfEXlsYPOvfKl6HeYUbzWp9b9kH1iEzAT5nj7yZzoINBXn11V3GDqlp91UgddFjuu/RtXELT5UBRSB7hEJHSdHnZFfctVuiAG22lt5xL6FVClYatHVnWShcIkha+20/OiKMTD2USQkQm/6nRb3M2uqCLcicJ8q5DgNskv5H5OsABPS7HtqX0w8BQMvpW8sEI1DKDj69tzWpaoi3nWO3oivwKnZohIRDOwLk9ChWCTtOitYO74IFj/6ebhStmL4kpHUsH3aD5ZaR8Kg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/7/26 20:12, Kairui Song via B4 Relay wrote:
> From: Kairui Song <kasong@tencent.com>
> 
> The helper splits a folio whose refcount is frozen: the frozen refcount
> is the state it relies on, while unmapping is arranged by the caller
> beforehand. The old name caused confusion and people may try to call the
> helper on non-frozen folios.
> 
> Also add a VM_WARN_ON_ONCE_FOLIO(folio_mapped(folio)) to self document
> that frozen implies unmapped.
> 
> Suggested-by: Zi Yan <ziy@nvidia.com>
> Reviewed-by: Zi Yan <ziy@nvidia.com>
> Reviewed-by: Yeoreum Yun <yeoreum.yun@arm.com>
> Reviewed-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
> Signed-off-by: Kairui Song <kasong@tencent.com>
> ---
Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

