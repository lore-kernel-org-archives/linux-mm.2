Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 34253D58E73
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 08:00:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 280D86B0005; Mon,  2 Mar 2026 03:00:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 22ED76B0089; Mon,  2 Mar 2026 03:00:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 110F46B008A; Mon,  2 Mar 2026 03:00:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id F14AA6B0005
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 03:00:15 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 9A9E2BC1F5
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 08:00:15 +0000 (UTC)
X-FDA: 84500375190.03.B85166A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id B4FE54000F
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 08:00:13 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=t5NMGNEx;
	spf=pass (imf27.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772438413;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pie/Tc2TT8CjIEyfV6ntQK+F3bTsYKBHulbviu8CS04=;
	b=yvJenDa9FH0Y8urmIyg0ReZXLq7MKgsaoqFt+dG/nMBMVRRn149ZGA51IrV04x/l6b8Z6E
	10ngqzlmOewzBJUfhbGT61JBxjlMpAJzZQVWlIg9wp3H3ni8Jv843ftma6vFyOBx0aKO83
	N/1ZbKxQQNlklVGruK5lerQdHJAeyoo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772438413; a=rsa-sha256;
	cv=none;
	b=NPIssdJv0oXe6ubcgN+LPWfPQRBFom0eOyCvbTCGKqT6G7DEYFIiYKv6w7T0xkj9xvD1i3
	FU4/7jdc+kNs2lW7ksbaokb7C/AmNlD3ozUHGmNZRAD1UqWqgH+z94vesjZTarBrd8ZblL
	6wa56axqexjeSjnEYrup6oEF1wi5IuI=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=t5NMGNEx;
	spf=pass (imf27.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id C01814327E;
	Mon,  2 Mar 2026 08:00:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E225DC19423;
	Mon,  2 Mar 2026 08:00:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772438412;
	bh=cmG85q4RbxGqFpEaUSYdNicB6sCiTJz7vAbf0cPsPyQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=t5NMGNExCtSd54JUoQ3qnl7voa2g+twGcVcnFZU/PS9I2YOA4Id/TaHnMAKC+iN5M
	 wPhhPc0QPozR1jDPPikyTq09o6v0SWp2Mp7+ufJ+2YQgDOpOJ02dwWjIW9pcvHRabD
	 +Dqb+B3aq/0RCQfGwJeLKWgb83t/YH9Krned8rKGBxz7Kn1Prelotw28wszem76WHi
	 23S3wZ4CZaRq6FhF6OouBIIl2FaM1NXb+FRderwJ35YjB9PIWQY91i4HWJxHzK7oEY
	 CDOfjMc3xPVWbPHj/ll9LuYaP2CxFu7OROpM7tpjN7jsvhIM/tG77GdUiHIoKFnBg9
	 SbND62Ma8llSQ==
Message-ID: <98480065-e988-477f-ba37-f9521e4aecbb@kernel.org>
Date: Mon, 2 Mar 2026 09:00:07 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/vmscan: restore allowed mask in alloc_demote_folio()
To: Bing Jiao <bingjiao@google.com>, linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Qi Zheng <zhengqi.arch@bytedance.com>, Shakeel Butt
 <shakeel.butt@linux.dev>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, linux-kernel@vger.kernel.org
References: <20260302070351.3465439-1-bingjiao@google.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260302070351.3465439-1-bingjiao@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: B4FE54000F
X-Stat-Signature: a9zksyp7dfou75h6oaojs8a63aqma8an
X-Rspam-User: 
X-HE-Tag: 1772438413-922023
X-HE-Meta: U2FsdGVkX18oRV12rO+lEPI7+iP9ZYY5PFxlvyRJ5eecbevKvv3G8i9WFvkqJhyza3Nd/yqZMM5ixsCE9T3h20PqpLXZWioC9Hm3QA/EgxlenHCH8SHjTCeja4NPjpPc9u/WUjMDtFjLT+l7uZq0J8yD6EhL9saE3azx/UQ+5vhkdYt1UTh5Uaq3O2/YP7HehoX1UIrWVV3gPAHTFn6omxY2nmv4Oqm6EZu1Qwgc7TYEclWoT09wCS3JKI+fA6RWmLWCrXKtZRwh51pelClomRjK+iH9HODtLKeaKH/GBvKye0BCQHOUCF650EaRnDwx4/gaU82X8yCi1E9e41Eb+jTq1SisCcuk1/snKTCjK1sUAfJKvU9l8hfVcsKc2rLN1ws9wygLyP8ZfAYb02l6TBgrtBlbsIOxX0rrvKnLpSMArCEE2mz6hdneyvcFctEon7zjkRk3S2EJX2R2ANZ2CaY3avXwSTAFiH9LfEXGGezGVCP7sQQ4wG4BEzTDqMUwc9B/X1WWM89TTO1EEqSAebkKB+q03RSXNKeUe3dFvbrBBp9QtM60arOkSy9AJdUV/LQv6QEZF+9p1nn5xEJ/FlZ0RyjZ21kD9D72DOzJBvYj1V8dscAaoI8oae6ExNBswSq27VbcNCgZVGW0Yl9uJh+Rimq/ttmePdF5v491o5CsUPJzDjk4MBbNp1Z8z4dmjfBZfSB8nFmLvuHSrf6TUbvPvjXs4ju/yrIJZK2rRZq8SipL4HfxyeN/DcPJUZ/YuASs6UDoxCQOhZ6jEi4tiNCslj3oGw4n70FQdFZ/kInm15hLyqVi98Gqz7/V43M3XumFq6IfKkzdBkmtAnzb843HGgNGIB6p/94Oc2BLp8aY1v2Uw/81vzGQAFiHw6jNE47VVvYqY/bsDAg8vT7og/N0OVvAVDejAey/lrCTaX6d3QS6Fhhe6UJxacbpr9qZPQYDz1U5p2CllEzLwbB
 fgsmX716
 BeV0Wn0ydgNFc8hYycn7WD4p0Rb4iXWvyye83RTjar2DUakzzOY6FzWUTyKPbj0GfSB6iMChUOiLnVu67oSw4iZTSXtifS4P7roVFb0SozOp8PTgWF9VyB+1GyRNK8DMIn/vCkmkvCdDXkn6njvA1l1HNY/ZsiLYh43FfBDurHKQFJhRyClqMTPdbk3orz0ZM9l7aQMU1IjnoBaosi9Ar8ZbMVpqYXk9c+isrcVRLSRkZLz/36DOl0uu4SU6we3+Oazma4EmOOv3iwGU+whESDpiZ+PnIVEPBAKyLuNyirKeyZqM4IAYfQNNkeLE5LBAlJvda8B/Kuvj/Q2zRk2GB3TDJEkjZ/VFw3qTy5zkfPX7ViWk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/2/26 08:03, Bing Jiao wrote:
> In alloc_demote_folio(), mtc->nmask is set to NULL for the first
> allocation. If that succeeds, it returns without restoring mtc->nmask
> to allowed_mask. For subsequent allocations from the migrate_pages()
> batch, mtc->nmask will be NULL. If the target node then becomes full,
> the fallback allocation will use nmask = NULL, allocating from any
> node allowed by the task cpuset, which for kswapd is all nodes.
> 
> To address this issue, restore the mtc->nmask to its original allowed
> nodemask after the first allocation.
> 

That would be

Fixes: 320080272892 ("mm/demotion: demote pages according to allocation fallback order")

?

> Signed-off-by: Bing Jiao <bingjiao@google.com>
> ---
>  mm/vmscan.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index cbffc0a27824..b42abd17aee7 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -985,11 +985,11 @@ static struct folio *alloc_demote_folio(struct folio *src,
>  	mtc->nmask = NULL;
>  	mtc->gfp_mask |= __GFP_THISNODE;
>  	dst = alloc_migration_target(src, (unsigned long)mtc);
> +	mtc->nmask = allowed_mask;
>  	if (dst)
>  		return dst;
> 
>  	mtc->gfp_mask &= ~__GFP_THISNODE;
> -	mtc->nmask = allowed_mask;
> 
>  	return alloc_migration_target(src, (unsigned long)mtc);
>  }
> --
> 2.53.0.473.g4a7958ca14-goog
> 

Maybe we should just not touch the original mtc?

diff --git a/mm/vmscan.c b/mm/vmscan.c
index de62225b381a..f07716e5389e 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -985,9 +985,9 @@ static void folio_check_dirty_writeback(struct folio *folio,
 static struct folio *alloc_demote_folio(struct folio *src,
                unsigned long private)
 {
+       struct migration_target_control *mtc, target_nid_mtc;
        struct folio *dst;
        nodemask_t *allowed_mask;
-       struct migration_target_control *mtc;
 
        mtc = (struct migration_target_control *)private;
 
@@ -1001,15 +1001,12 @@ static struct folio *alloc_demote_folio(struct folio *src,
         * a demotion of cold pages from the target memtier. This can result
         * in the kernel placing hot pages in slower(lower) memory tiers.
         */
-       mtc->nmask = NULL;
-       mtc->gfp_mask |= __GFP_THISNODE;
-       dst = alloc_migration_target(src, (unsigned long)mtc);
+       target_nid_mtc = *mtc;
+       target_nid_mtc.nmask = NULL;
+       target_nid_mtc.gfp_mask |= __GFP_THISNODE;
+       dst = alloc_migration_target(src, (unsigned long)&target_nid_mtc);
        if (dst)
                return dst;
-
-       mtc->gfp_mask &= ~__GFP_THISNODE;
-       mtc->nmask = allowed_mask;
-
        return alloc_migration_target(src, (unsigned long)mtc);
 }
 


-- 
Cheers,

David

