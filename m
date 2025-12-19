Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5245BD711CC
	for <linux-mm@archiver.kernel.org>; Fri, 19 Dec 2025 00:05:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BB2BF6B0088; Thu, 18 Dec 2025 19:05:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B86D46B008C; Thu, 18 Dec 2025 19:05:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AC0F06B0092; Thu, 18 Dec 2025 19:05:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 97D8B6B0088
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 19:05:04 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 50A88B8A64
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 00:05:04 +0000 (UTC)
X-FDA: 84234275328.21.EA652B4
Received: from out-181.mta0.migadu.com (out-181.mta0.migadu.com [91.218.175.181])
	by imf08.hostedemail.com (Postfix) with ESMTP id ACBE416000E
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 00:05:02 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=moTIZwTz;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf08.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.181 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766102702; a=rsa-sha256;
	cv=none;
	b=Da6fCeAyoXe//ckyzmrlStvmNBT4WwJyS3JzEAfRL+ZRFAcmQZgWqT1lBtSz+y9pIbC9dO
	9QM8A9n4PtnGzaKZ2cdmzK+16a9TM54WNHXpZp+nsbndKZE1dN1rndag2M231l7eYqOaUo
	UP29dkh8JiYcFLAhOCCb2L+yvGY+tB4=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=moTIZwTz;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf08.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.181 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766102702;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4Jwlmy1SAVfkkaQh6QwvtSm4Bu3pmworf1DAnFfYKr4=;
	b=Uo+ReVvjVnMxGQio53aS0erx8+wAEqbB+tK83iagvZn2M2o8djfVDARAY3thyGpUZtlhNJ
	M/yS/4VYMutDmp+JUD80XbVrlRn8SohrZnxasiqTtHkLTiC+KKqZU2b/hLtCc4giJG3frC
	duN+/zMZuqY1V9njajE9OoZB7hsGqPw=
Date: Thu, 18 Dec 2025 16:04:48 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1766102695;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=4Jwlmy1SAVfkkaQh6QwvtSm4Bu3pmworf1DAnFfYKr4=;
	b=moTIZwTz5ct4IM1pJ0e6HSkvLU0nEMjKL59Va44sjCRiGzlnuVzZl+uL8fAr+J8t00RZ2i
	/bxq7AhbigKsXJxRaZzpIIcaKLPV0wvNsw73dthXd5bZPxqbK/IevCPmxXPzr4rCXUS+gJ
	g4vdCdJHuJBFYznZabIC8ttbBlGqwnQ=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Qi Zheng <qi.zheng@linux.dev>
Cc: hannes@cmpxchg.org, hughd@google.com, mhocko@suse.com, 
	roman.gushchin@linux.dev, muchun.song@linux.dev, david@kernel.org, 
	lorenzo.stoakes@oracle.com, ziy@nvidia.com, harry.yoo@oracle.com, imran.f.khan@oracle.com, 
	kamalesh.babulal@oracle.com, axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com, 
	chenridong@huaweicloud.com, mkoutny@suse.com, akpm@linux-foundation.org, 
	hamzamahfooz@linux.microsoft.com, apais@linux.microsoft.com, lance.yang@linux.dev, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, 
	Muchun Song <songmuchun@bytedance.com>, Qi Zheng <zhengqi.arch@bytedance.com>
Subject: Re: [PATCH v2 05/28] mm: vmscan: refactor move_folios_to_lru()
Message-ID: <hhrgup42tntpjj5vomztn7lztwqveu25n2vcq4h255dnipadrc@gelesqdlk5c6>
References: <cover.1765956025.git.zhengqi.arch@bytedance.com>
 <0140f3b290fd259d58e11f86f1f04f732e8096f1.1765956025.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0140f3b290fd259d58e11f86f1f04f732e8096f1.1765956025.git.zhengqi.arch@bytedance.com>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: ACBE416000E
X-Stat-Signature: 11jdb1m33uec1oihptto6nscf5ctzdep
X-HE-Tag: 1766102702-550864
X-HE-Meta: U2FsdGVkX1/QucF/64amqQJiZsWhMZkq/kNBsE/FFS8H43n8DF/GN14CpPwPxRcDN0+Lmo85VHRS3Jl+HTgvGUfegTKcz6YFqWlFsd3EVE2K+u+oW4jK0HX/TzLI2KBJ+mMGUh7DRGdGFxdefOx3PVRKeJKWkAmjYy9YcDEru49d52Bro9S9rM8Oju7Hrs2ze1pAXRkD05FEMCNsaWta3VnlBcvWYKMIa4pown5sotrnDEcjYNmL/zc7y1dnaqpLEYgkVSjal0VU+FNEa9f18LzNbLt1KNRNIwkL7DV16BlIK0omScu6CL+aSxnB/gH644ogE3CcYtoEkHW8qQFgWhaecxfwwJPRJI2w3nj1MwefysXtsyRtDX56psgw4V5r15IXBwbAoAxW7JFXUZdDBW3slv1ZZ2i8G4Z/z9OzXFgrNXxj1XyFYJ1HIQVVF5sJB+gvSc8mEjuKnVFHDKzWDbxkWcy6ESY34K7zpWshC77eHxj9GRQVz/EcaOqDeX2p0SeLrYo3wY5/rUoMcmVGYcTLZV+/i8e7k3Wipc8wnGZpYsOgi+X8bMMC6XpWlidkAvUt5wvFngJziyERz5R4IWOBY8+0RHLPCRjNAXbF6sNuMrguOy9f+Pt4LMPL4Dqxg4z41slk8lbNwGL4Ba1SD5wMUB2d2NM68rLxdIn/NU/QTlOAMim0UvtNAg+vHpIscGWTLcqZlyjcHdChXsxX/MpzrnXBoCUD8rbrMQTbTeQHxjvPXsKvfZgKuKELTatvtLooIqMZ+wZ7ABpPSeU6pvQF97KxREIN9YLBs1KBSaVRspzBIQr0ZIzcW7iF49hOxd5brStu/NbnahsK/XtBBNN4aZSpoF+zKPkfm0XoFRgwWd0HR3+6mNOM05eCf3rthUCKgcoFbBbzkNXLZ6+9O1Z8u/pus2hJ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Dec 17, 2025 at 03:27:29PM +0800, Qi Zheng wrote:
> From: Muchun Song <songmuchun@bytedance.com>
> 
> In a subsequent patch, we'll reparent the LRU folios. The folios that are
> moved to the appropriate LRU list can undergo reparenting during the
> move_folios_to_lru() process. Hence, it's incorrect for the caller to hold
> a lruvec lock. Instead, we should utilize the more general interface of
> folio_lruvec_relock_irq() to obtain the correct lruvec lock.
> 
> This patch involves only code refactoring and doesn't introduce any
> functional changes.
> 
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> Acked-by: Johannes Weiner <hannes@cmpxchg.org>
> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
> ---

[...]
> +	spin_lock_irq(&lruvec->lru_lock);
>  	lru_note_cost_unlock_irq(lruvec, file, stat.nr_pageout,
>  					nr_scanned - nr_reclaimed);

I know that this patch is not changing any functionality but it is
undoing the optimization done by the commit 3865301dc58ae ("mm: optimize
lru_note_cost() by adding lru_note_cost_unlock_irq()"). I think it is
fine as a transient state and I haven't checked the final state of the
code after this series but I think we should do something to restore the
optimization after the series.

Anyways, it's a nit and if no one comes to it, I will take a stab at
restoring the optimization.

For now, LGTM.

Acked-by: Shakeel Butt <shakeel.butt@linux.dev>


