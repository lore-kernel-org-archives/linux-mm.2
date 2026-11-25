Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D1E27606A31E
	for <linux-mm@archiver.kernel.org>; Wed, 25 Nov 2026 02:21:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=DJIvbgF/
Received: by kanga.kvack.org (Postfix)
	id 004276B08CF; Tue, 24 Nov 2026 21:21:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EF7406B08D1; Tue, 24 Nov 2026 21:21:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E346F6B08D2; Tue, 24 Nov 2026 21:21:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C38586B08CF
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 21:21:07 -0500 (EST)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 0ED57C0AD2
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 02:21:07 +0000 (UTC)
X-FDA: 85472038974.02.719C59C
Received: from mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	by imf24.hostedemail.com (Postfix) with ESMTP id 01B73180004
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 02:21:04 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="DJIvbgF/";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf24.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.180 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795573265;
	b=i5eL4DAfxC+meXY3tUHNXhfpXGghJK7O/Ul6q1SjT2/0bp1ttjFrnzAObUe2yNMQvRBGSO
	PBV92GiA7jAmFiu+Q1YBYsXRDSyMPMcwMIgWMGH6Q1X+VNTv1VXKaWHJzBCjj6gN9oTCsZ
	0BzY1FHUeXEYfHvi+I90nxmKEjkYYuQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795573265;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QF5/RGbnB3uL9g0t8XxmYvir5OZryV7dSCn4MoFaEOI=;
	b=Jh23aBlLrWiYPTccAFbQhrvxTVmZk5zd/zc51Hf0RR6f/n35cPUVBY935VB8MjkiFdF4/l
	8/WuuHlCjuP1kIT0IoW+wjVkXRqDpGkkS3SaZMpG2nvMOWVTq1Vdnw0rsEWrCp5lwur/eq
	hGHp6hyVtog9Gs+EyuUcLymC10QzCQ8=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="DJIvbgF/";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf24.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.180 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=/sb51Ln2/DAI8sXzQH621GIGu1e1U5fVvk32++uJAWs=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795573261; v=1; x=1796178061;
 b=DJIvbgF/lkI1c0D9mGRcGoR4nDYwZYyFt7Ye+ecDYC6JI7mORUgKkFVbI33ibpa19z9NJDnu
 rqAqTYmY5PFJMzheBtcubGqzq0POAYBivK0hL0VOVBu7+sWqkPJb10s9e1PMtlfTnrY9g5xoVgG
 BXBiBXJ3fwPgQGnCTIJPgbmY=
X-Envelope-To: linux-mm@kvack.org
Received: by mta12.migadu.com with ESMTPS id 51e415cf3d358a92;
	Wed, 25 Nov 2026 02:21:01 +0000
X-Mizu-Trace-ID: 51e415cf3d358a92
X-Migadu-Flow: FLOW_OUT
Date: Wed, 25 Nov 2026 10:20:57 +0800
From: Baoquan He <baoquan.he@linux.dev>
To: sashiko-reviews@lists.linux.dev
Cc: linux-mm@kvack.org, david@kernel.org, akpm@linux-foundation.org,
	kasong@tencent.com, baohua@kernel.org, qi.zheng@linux.dev,
	shakeel.butt@linux.dev, axelrasmussen@google.com,
	yuanchu@google.com, weixugc@google.com,
	baolin.wang@linux.alibaba.com, Baoquan He <hebaoquan@kylinos.cn>,
	Kairui Song <ryncsn@gmail.com>
Subject: Re: [PATCH v5 3/4] mm/mglru: skip cold PUD subtrees during aging
Message-ID: <awZGCeFosH5myoXM@bogon>
References: <20261123085800.981256-1-baoquan.he@linux.dev>
 <20261123085800.981256-4-baoquan.he@linux.dev>
 <sashiko-outbox-230766@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <sashiko-outbox-230766@kernel.org>
X-Rspamd-Queue-Id: 01B73180004
X-Stat-Signature: hnpejxw8as4w3tp9apqy359ee7bj781b
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User:
X-HE-Tag: 1795573264-855185
X-HE-Meta: U2FsdGVkX185uAvpPBH5PzBwPxzvyJ0B9WF+AOV5N9Dj0lwInIMCkFSSYU/rHgZitzRCj2crRwSS5z7R0Dppptav8ao184S7DzMbf1OoPatLmBLLUV6xlU7YNzqaSEnLSxsKOlUKEqrLn7+NaFL5xAMTgoxxrUj8k/Woqz/RiC/Z5WLS5qlK0ogBB4ePrbwHmp2pIaKGaNReon6vIuc81LQFIFuBtmwOpRk/BKHt0gtOIVQh7VvEGl2DasGnvnX71vR//E27W8gqZqkmJzwqjxFbgZvG46w2CJK1OeWekpwVwfkOgKF2K66gFWK+EslbbjNq/+rGq3AvHPwuZUuxGyrkmfM6WRZfgZFeZqRdoMQqJa/fZ4uUPo+jnaKfsmCIUqHBAupvx9YsPbKgDUdSgnoNZVeM5V3c1/a4t880xskXLftSt7hVlE5cxsSA2njK6UmRLjBc3roMaRiYBd0D78XOCZtIB40rJx0ynjTdaEnuZ18lR0Mu2v33TV3hBT1tjT5E6aeAXrlDvbAVOBG0gZ/+ilVNvY7lWqmcnmVuuCiA0mBu5pdNQHOqN+zP9FW0Vwt8+OL1w6iOy2Zv3y4Z72+BVgKUfwzBFFYSOVJ9hPmAhYcbMJb7PmkvAG9EYT4aokvb0UBUi8kV8alaAzSlH2IJrOiFYsmMB0/TJb9vhrvs1Fc7hmukHyllNDLVvEg4iI20I5DP1BBFGJuCwUyo+QEUmPa6WJY6TJ7tIr+Q8QUPuvoW/xSnM0K2KyoeR6bQAUNI/pVzWPuSiEaJCvGWbjuGzYfEP1ocQpIeSI9M76d3F/cQB4lScr/z23xtpX3AWP50vjwVNkzy7VEbWHzEVu7j2b3ZxjMkng5hJPrAm/PRCQmNMVmcg5WwjAn3BaXf/9ZtDGiho+3os/0dJiM5xhf4IL/4Amx2EbTkK2ob2gfa+BAwm8BTRsZv5plveldnIuKUXveiB04NBwR0mKZ
 7g5X4KTI
 J6+z4q21xCQqZ1DdBWxpbRC47CEwAtapxu0wtimwRep2oo9ye/1wk0RBgU7l4YEcSd3/kZ6uNkH/Xwxj3XoP55G4xVZK64mjOrMqOUE0bFgSSlNydEge8Ofx5DMX8GXaP2PKcOlKmH7j8qnjroTF+blogMYymaLWeQlndR7cRkTs6rEf0QnVTcuMO4H7WudBlmQoFNeoX1RpoUX+SNMHC/ZpnmkhdQTwYnc+2cNswlQNj2aKCND/PfjCSq6zMF3DMwBvXANO8i3iMKLXbuMi16NNw/89lkkJPbNXyNRBzy2ou1Kir6s9d1+Svkw6x9LFuMPBMv00lRnOzCB2WitQk9jgxIr1/ihtiiQl756dnkfCn5N5YJ+s02Kg1FxFZHzlrt9kQU5S+9X72rkGn1lrKsYcp18zobbM4tHSCKCsQPgqr+zUiL0dJ1KGHpTXBkuQlXLFIbrMHD1+vSHkEVOzsiKFv6Ez46snRSDoSVwHC/tH45tJHxClkp55igQNghvcShxD4aBYk+1sAKncL8j04YfZOez6IjsKC/04rRA1g4QWVXx+NUKdJEmsHDo8LYOOpjBBHpEUZuyYvKwPKNolpjVI0nQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/24/26 at 08:59am, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential
> issue to consider:
> - [Medium] mm/mglru: lost young status in walk_pmd_range() when flushing
>   THP batch
> --
> 
> commit a67d5ce39733f49dd06a525e19b6621ddfe22558
> Author: Baoquan He <hebaoquan@kylinos.cn>
> 
> mm/mglru: skip cold PUD subtrees during aging
> 
> This commit introduces a PUD-level Bloom filter keyed by (mm, PUD-aligned
> address) to skip PUD subtrees that held no young entries during the previous
> MGLRU aging generation, and updates it from both the page table aging walk and
> the rmap feedback path.
> 
> > diff --git a/mm/vmscan.c b/mm/vmscan.c
> > index 7d20ee1b6c10a..517f5fbecdbf7 100644
> > --- a/mm/vmscan.c
> > +++ b/mm/vmscan.c
> [ ... ]
> > @@ -3750,7 +3766,8 @@ static void walk_pmd_range(pud_t *pud, unsigned long start, unsigned long end,
> >  			walk->mm_stats[MM_LEAF_TOTAL]++;
> >  
> >  			if (pfn != -1)
> > -				walk_pmd_range_locked(pud, addr, vma, args, bitmap, &first);
> > +				young |= walk_pmd_range_locked(pud, addr, vma, args,
> > +							       bitmap, &first);
> >  			continue;
> >  		}
> 
> [Severity: Medium]
> Does walk_pmd_range() lose the young return value when a queued THP batch
> is flushed by the second walk_pmd_range_locked() call on a non-leaf PMD?
> 
> mm/vmscan.c:walk_pmd_range() {
>     ...
> 		if (!walk->force_scan && should_clear_pmd_young() &&
> 		    !mm_has_notifiers(args->mm)) {
> 			if (!pmd_young(val))
> 				continue;
> 
> 			walk_pmd_range_locked(pud, addr, vma, args, bitmap, &first);

Yes, this is a corner case and could happen to lose the PMD-mapped young
leaf count. The detailed analysis has been replied to v4 patch 3:

https://lore.kernel.org/all/awVGycKHzXzW5OF1@bogon/T/#u

This will be fixed in v6.


> 		}
>     ...
> }
> 
> Both PMD-mapped THPs and young non-leaf PMDs share the same (first, bitmap)
> batch.  walk_pmd_range_locked() queues entries within MIN_LRU_BATCH of
> *first and returns false, only scanning the queued entries and returning
> whether any THP was young when a later call exceeds MIN_LRU_BATCH (or passes
> addr == -1).  If a young THP is queued first and a young non-leaf PMD more
> than MIN_LRU_BATCH entries later flushes that batch, the non-leaf call
> discards the return value; if no later PMD in the PUD sets young,
> walk_pmd_range() returns false and walk_pud_range() leaves the PUD out of
> BLOOM_FILTER_PUD for the next generation.
> 
> -- 
> Sashiko AI review · https://sashiko.dev/#/patchset/20261123085800.981256-1-baoquan.he@linux.dev?part=3

