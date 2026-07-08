Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 03B7FC43458
	for <linux-mm@archiver.kernel.org>; Wed,  8 Jul 2026 07:53:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EAF386B0092; Wed,  8 Jul 2026 03:53:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E5E506B0095; Wed,  8 Jul 2026 03:53:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D50116B0096; Wed,  8 Jul 2026 03:53:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A68466B0092
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 03:53:53 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 272ABC1B8D
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 07:53:53 +0000 (UTC)
X-FDA: 84964845546.13.68BBCD3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id 6D95280002
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 07:53:51 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PSXkx+AD;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783497231;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Kz17m858MwgmWF0pwgeoxvWnX7L23Knguhas3J0CszA=;
	b=tx6NVnQ4uPGiD+Cl2lQ8gq9I5V2wkRyBoLHtHP5UAu5bS3zUbjCNVql6du7WVz75oQl8sG
	wW8gKZN2Dm0Tcf0Z62i2g9qnsteLT68+1Bs1tmDC+PiamFUs+lZX8CvVcSoyg93DtvMuoZ
	RvFslxRj28I9SDOwDYuB0vCLy8Qz72w=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PSXkx+AD;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783497231;
	b=Y6nENIlvs/Mo0cLPgh7cG35m7kvySWf/7b3CZ/u7mUR514rSWmj4zFTGOG7GcNuUrdcOXa
	SseFt3ACi46/+dEf8eD9S41im6oC14+Hxl+rT6b4Bi0s9HZL4L+nHfKqt8EpgVit0/gWlk
	D71R6buUFY35ypxDGuvmXgxFkOQZWC0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 051F56001A;
	Wed,  8 Jul 2026 07:53:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E00D1F00A3A;
	Wed,  8 Jul 2026 07:53:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783497230;
	bh=Kz17m858MwgmWF0pwgeoxvWnX7L23Knguhas3J0CszA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=PSXkx+ADZfW3APdL8Mcv3m10d6qta0/K0OCwLF8sTK6GVdKLsDTDR9oB7raWgQ0zs
	 BC34mH5WyyCkbdi0QS63qH82iF1si5BWu1ADcxa/rr/62PEx0+qm5nVLUzSk12Ck/1
	 mA5Woi6fdPI2b/DDfuP0elY1sY1UxwCG1Prid+/m8fDrMas+hiSsOJkAqD99N6yN3P
	 Uy8es6zRdjoVIsq5u0tK8FpQYs5DkeJScw8GFAodtHmnmR3tnqVNj0HnuJAkX+7guQ
	 /PVD7RV6x9KllwmT6DTcdtkilMZMB5a6RblqzK6MM13EwVn11Gqe0ZC3hoY5DFfWDo
	 N67YHdLZs2nwg==
Message-ID: <38ad90d8-0887-4cb9-b874-53ce35b6dbfe@kernel.org>
Date: Wed, 8 Jul 2026 09:53:47 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] mm/ksm: Initialize the addr only once in
 collect_procs_ksm
To: xu.xin16@zte.com.cn, akpm@linux-foundation.org, chengming.zhou@linux.dev
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <202607081219094603lvrfl0HWd-31cAGrp79l@zte.com.cn>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <202607081219094603lvrfl0HWd-31cAGrp79l@zte.com.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 6D95280002
X-Stat-Signature: wt1n7nczzq3j6gfus7msfahst6jbgr39
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1783497231-908671
X-HE-Meta: U2FsdGVkX18vA+Z1M4CNc124tI4XNCWvHSttOHfLrrfne2veGVpRmTsvdkhWVCKom/ZUjbn9cb5PfFMCGKM14pk7v070F7QP/rlSAfF4QAUYh+1LNU7tLkPD+Xh6LudrMKuiI4s+LjGHLZiWrFwoOqTAGWtHW36X6I7r6yE26Zre9GJrMqyD2LS/rsIFqkJylgkUyuaYwQuCWInuCdGxwajHu1CnFtLar5tyctJ09GyOhLxILUwDy6GkRwMFgByl9sCiuAze32fQ2iq8f5VWyJb3kg+/qQ+8N+RBJfXnNHRV3yaiLT0zbh7Tv0Jj3qNHd549Sb/7GPIxrEiWedLtJsgXCEbOa3N9MRSxMHs87qKHBR97zGSpWuGpwOZiHVqAe7LxuMy5GNqzJjj1hM1Sa+r0hRFU7BgAtlrhvU9XKmulEp7k1WDowN5u2TjncgZjHxatIVVkYrlPvUV9M1/nheEroDnCI68gG5BIzkTC7lpODDSNW0HDtkTezyaOKxnk5APOhA+spc7k6znYssWP9cBzycRXXBfXnHGDoHSkn4F8glg7zYdK5iQGQeh5FZEhF/lAv6FVnpR6hLmyUkT2A9mWvetD89NeWPdF23rmmCJ5N7G2ZG1yPLiC2F7dfqzBYNtw2dgTkPImkyzXzsnUoLhAgOLSs3OnhAkQGDVBrsEfLjqR5d6c4Mb0U2ysPXZe91iIN7vzfFlMrLvbmuZ6S1BeX7vhvXzvZ3LO3yuba9ZCMN91W2/AuSziMAVHBYg+d8VwrUwUoyKEH71Y4vX412rzxurlSFHSTUefJM9nxA+T8vWZgyANluwEMcT2XyiOy+4mxrUvlgY353Cwy7KQ2V2ivzi8m/X/Uut2KIDOPfasv8I9ZxTR6oksPuU1We9noGjPmE3xaM6LukJW/tig6T480WuBx7TyXOlQgU2wwwZEykHIxiGuS+/Knr8lxifqi6/1JtYN3x9xxw+/cRq
 p4pAGGYQ
 1YtsWYhrRyGm2tR2g9uVhAG/qhqEZtSNO158d8PkflCAozyMM2rguAEgQ8hrRWJqkbSm8q2v6n0bANNlLMxe0HUWJxKfr1tb0t59QHSbdbQDulQZl/NA/OfnKJc4D3qZv9bsq53dn7g7Ozg2j4ErevoUTWrWfwQ4sLTWJ0FLJafyn0tnLHh02P9RaBdk2Q+LSPzkZtN1mRUt8SscS1/78JMVgnE+/X9aVUDJfSKMO8lzgVDbAARgd896ITqy/EsR0h1vvQbmlDw36TqVHnVWLbgIqOWnbT3EaF8x/i1pPujUtoUm2d1vsDotJgR8WSV1hTIRK1v5kPOTSqOY31MkrDwiViTsUMOYQ12W/A6lnvMLjKt+EekonLVVYb4kLYB8B6ym5q/qFYhM8va2kIKhk2uRX/NOktELRP6ENBDnW7LHTL6g=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/8/26 06:19, xu.xin16@zte.com.cn wrote:
> From: xu xin <xu.xin16@zte.com.cn>
> 
> Similar with 318d87b8fa7 ("ksm: initialize the addr only once in rmap_walk_ksm"),

checkpatch.pl should complain here

"Similar as commit 318d87b8fa7 ("ksm: initialize the addr only once in
rmap_walk_ksm")," ...

> Only initialize the addr only once in rmap_walk_ksm because the addr variable

s/Only/only/, but you une one "only" too much here.

> doesn't change across iterations.
> 
> Signed-off-by: Xu Xin <xu.xin16@zte.com>
> ---
>  mm/ksm.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/mm/ksm.c b/mm/ksm.c
> index c1dcc3cb4831..337eb04a9340 100644
> --- a/mm/ksm.c
> +++ b/mm/ksm.c
> @@ -3289,7 +3289,7 @@ void collect_procs_ksm(const struct folio *folio, const struct page *page,
>  		rcu_read_lock();
>  		for_each_process(tsk) {
>  			struct anon_vma_chain *vmac;
> -			unsigned long addr;
> +			const unsigned long addr = rmap_item->address & PAGE_MASK;
>  			struct task_struct *t =
>  				task_early_kill(tsk, force_early);
>  			if (!t)
> @@ -3299,7 +3299,6 @@ void collect_procs_ksm(const struct folio *folio, const struct page *page,
>  			{
>  				vma = vmac->vma;
>  				if (vma->vm_mm == t->mm) {
> -					addr = rmap_item->address & PAGE_MASK;
>  					add_to_kill_ksm(t, page, vma, to_kill,
>  							addr);
>  				}


-- 
Cheers,

David

