Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BF5E7E9A76B
	for <linux-mm@archiver.kernel.org>; Tue, 24 Mar 2026 11:34:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2DAED6B009E; Tue, 24 Mar 2026 07:34:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 28A516B00A0; Tue, 24 Mar 2026 07:34:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 19F986B00A1; Tue, 24 Mar 2026 07:34:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 06CE76B009E
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 07:34:47 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A2B4B5FC77
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 11:34:46 +0000 (UTC)
X-FDA: 84580749372.30.0BF95C2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id F30A440011
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 11:34:44 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=aOGsAJsc;
	spf=pass (imf17.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774352085;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jbmPx+6JJxsD0naXCy8BM5cdJ95V6Dj1zulcySquhXk=;
	b=h1PSyiYtM5LjX26XfvLPNK77KzJd3724ZXEBMnvFY3jHyF+qtvPv5rH3GJ8P/cOzBRtyDI
	V/zWpkxfJjDyD3Oz2tySV7F3EmjHNKXV62m/sGm4AwaWywEwt+mECtIzFh2zHKJzDizTNa
	PBdJH+eam5Hr1f0TWbj0ejOmK6gr6IU=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=aOGsAJsc;
	spf=pass (imf17.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774352085; a=rsa-sha256;
	cv=none;
	b=zTzHjJvuJKrvxco3hjvjHPgB7YTMAtvubIEFON2E4GMR7XOatDauXQK0EXvdXaKotFMk/U
	y9uoCF1WYGItcQMC/MQDwwdUtBHjrrtivudSC0bEFgwCF/3iYfEk8LZ4AfLo0qjJ2bI/hJ
	ywDxykQJjQuthHfgJkzAYZfTdUwhKPQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id E66BD441BD;
	Tue, 24 Mar 2026 11:34:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CDF9C2BCB1;
	Tue, 24 Mar 2026 11:34:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774352083;
	bh=0zzhO0uLOjCsBTpsyzUIZ1Vry9zombxb0uEB5AAAy+Y=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=aOGsAJscG+0PMkc6z09jcB0OmTMcBlTR0J7Veu/kzfQuJjMW/GjqLubG9f4uyIhVb
	 zs9yEnRvDpgA+9I4xRRtkESueExLaP3573GS4hUFZKvGIQY63FCPjG5aZMeUzOmaWl
	 XEnjNtEdFlXxCvivQvKQaRhmCyKqzy3zwVvOQycDXs43epIjRKWgOPLvXF07UmIyUW
	 EZwn9HZqAYaqArZ/dH+o3mis9Cl2p1fybm/GxY42Yz3L+P+f42ZLA2g8mgu0wrLw2j
	 ZakbjgPcZlrtnLZ7CnWo/WmlcrN73LYZfTxD4MxUgzTV+fHLKe2yl11afRLs6YaJ3A
	 ajq0806Cvebcg==
Date: Tue, 24 Mar 2026 11:34:41 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Yosry Ahmed <yosry.ahmed@linux.dev>, Zi Yan <ziy@nvidia.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Usama Arif <usama.arif@linux.dev>, 
	Kiryl Shutsemau <kas@kernel.org>, Dave Chinner <david@fromorbit.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 3/7] mm: list_lru: move list dead check to
 lock_list_lru_of_memcg()
Message-ID: <23c223fb-b4be-4290-8831-1f015bb031f1@lucifer.local>
References: <20260318200352.1039011-1-hannes@cmpxchg.org>
 <20260318200352.1039011-4-hannes@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260318200352.1039011-4-hannes@cmpxchg.org>
X-Rspam-User: 
X-Stat-Signature: yzuna9an5oqty1ayg39scngtu7a4ixai
X-Rspamd-Queue-Id: F30A440011
X-Rspamd-Server: rspam09
X-HE-Tag: 1774352084-678723
X-HE-Meta: U2FsdGVkX18JyxQrRLDW3QAbcgFg2TDsvZxQguFDWpa5qraqsuSXpEpMskeZEOh3FL6/61alobVDymIxQKkp0wSsB9U3hYmKzwEprOm62CTJlzcr73oM65nE/1dOSkZWEtWHYos2rWmmHcVxD3ybbUG9JbS5jb5WhGkcfpZZqiESk6flYFH3nHuKuBQecXPlGEKrbsoLxQtBnplB9YD0iTkX4/YoL8Ix1Cbd2mo2xrIrQNKXTmQjlOzNittJh7du10CflzGKulx1b+9c+MpGS97hPwja/NtMAzeqZgtVi/+eN17M+bV+yZSKShXB36OoY6mEmUMLKd9eYuiTCRFaS4akRAG6qxcrqNmd/PVVuVyNmh4C5RWDNmeGNrSGnW7kqIiYf1vNxkbve4H3csoDVCOKapkekKwQcWfuPl+zaLffxAAF7x+wZwlP72hN5orNuNEwfYMfKlePeZu2VN95V6cmmHDsw8LQmULkmDCcUSom1XrWuQgPP0ze8ImqUXjydnGu5shA9wasY03eoxFilSGjXUq3k7RckDq/hvvdI/bFH5xBF2NlZUKm/+iBKMD0f2exEcA9BQNns01B6LW6TzqwqaOjl/NWiD9TvcVLZ9cSr0wU2Ufc+ifCM/2495Bf5eO/SANqAkl1DQasg5wQ7sZ3cvo744l9fbsxN3884xCN0wYqii8yXl+RqGL3djqDX5F8h4qAkZm4XSnswhB0iVnpb2r2+c7wVRkNf1pd7TjvM6x0NwpNXh/n/1s5mzWxrzK1moRhHUH4sue6Kp3fMopV4TtAbrJOMzErgVWP+/8+Sv2ivIX8w8Pzqudii9bEKU+EKQlKRR3ciB3vqtlFRcGfn5KWYMMJW0DVEs6nEYeqNX4nsLMjPEgXXYQxlX/77S7xynpoqnnQRw/Rmkg+sxjeUsyxxKzr1XjY7yHFBue4YTg3kj8UgedJWS/aD1/PMWa9zx11YYJvTOAX4g1
 c4LSfod7
 9mGyKZiSfp5ONIioYhloUQtgMCUaLkSHXpMEx5dYZpMhJ8PZIhkNb83nPTszP7dxxCCv3rRuFhp0xaqOVZkk2DbW3oJ1caNbLNPn8mrOPHfZNAjaPP5X8a7I5kwZ83cg6iJoLqXUBQ+GRPb3z0MoTrWY+mRRIV22FkcKM0BCzs2/ldRPhBq1RTh27TdYmEus3ouA0L5Gw52XbAWizhmHNh0V8u8E6y+Ut5AkJlwf1fC73mZ4hk6qgSxRGDcXTrrHmwnO7wJGf7XGpOXiKl5yGnUXbqdUQ0cXNtvcRKulNTb3IyOd24Rm41Bsbe/ZzL44LPEAWHftghBC+AqAvKWv0SfMGAaEA464iGF1X
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Mar 18, 2026 at 03:53:21PM -0400, Johannes Weiner wrote:
> Only the MEMCG variant of lock_list_lru() needs to check if there is a
> race with cgroup deletion and list reparenting. Move the check to the
> caller, so that the next patch can unify the lock_list_lru() variants.
>
> Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>

Logic looks correct so:

Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>

> ---
>  mm/list_lru.c | 17 ++++++++---------
>  1 file changed, 8 insertions(+), 9 deletions(-)
>
> diff --git a/mm/list_lru.c b/mm/list_lru.c
> index e873bc26a7ef..1a39ff490643 100644
> --- a/mm/list_lru.c
> +++ b/mm/list_lru.c
> @@ -68,17 +68,12 @@ list_lru_from_memcg_idx(struct list_lru *lru, int nid, int idx)
>  	return &lru->node[nid].lru;
>  }
>
> -static inline bool lock_list_lru(struct list_lru_one *l, bool irq)
> +static inline void lock_list_lru(struct list_lru_one *l, bool irq)
>  {
>  	if (irq)
>  		spin_lock_irq(&l->lock);
>  	else
>  		spin_lock(&l->lock);
> -	if (unlikely(READ_ONCE(l->nr_items) == LONG_MIN)) {
> -		unlock_list_lru(l, irq);
> -		return false;
> -	}
> -	return true;
>  }
>
>  static inline struct list_lru_one *
> @@ -90,9 +85,13 @@ lock_list_lru_of_memcg(struct list_lru *lru, int nid, struct mem_cgroup *memcg,
>  	rcu_read_lock();
>  again:
>  	l = list_lru_from_memcg_idx(lru, nid, memcg_kmem_id(memcg));
> -	if (likely(l) && lock_list_lru(l, irq)) {
> -		rcu_read_unlock();
> -		return l;
> +	if (likely(l)) {
> +		lock_list_lru(l, irq);
> +		if (likely(READ_ONCE(l->nr_items) != LONG_MIN)) {
> +			rcu_read_unlock();
> +			return l;
> +		}
> +		unlock_list_lru(l, irq);
>  	}
>  	/*
>  	 * Caller may simply bail out if raced with reparenting or
> --
> 2.53.0
>

