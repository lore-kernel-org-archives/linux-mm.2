Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CA64FC5DF97
	for <linux-mm@archiver.kernel.org>; Wed, 26 Aug 2026 09:11:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8F4356B009B; Wed, 26 Aug 2026 05:10:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8CBEE6B009D; Wed, 26 Aug 2026 05:10:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 808936B009E; Wed, 26 Aug 2026 05:10:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5AFEC6B009B
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 05:10:59 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A7DC0A02E4
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 09:10:58 +0000 (UTC)
X-FDA: 85142850996.09.63943BC
Received: from mta1.migadu.com (out-150.mta1.migadu.com [95.215.58.150])
	by imf18.hostedemail.com (Postfix) with ESMTP id CBD531C0005
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 09:10:55 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=XZSGheTd;
	spf=pass (imf18.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.150 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787735456;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=V3RKY53ckag46sUzaoW1YvvHSln3E7DZ8EMt/2OhZNc=;
	b=vhhvoIR1FBJxY1g1fSlVuVPA/sE62TUyJ6veLJEKgwNO/PNgcncgCxZyb42mU37IOch+wm
	lvKsVgTjjg4AL20E0Z8JoAmlSf20yMeznptFuQU6BJKtjfTwhB4QlLhXzpaT8684hpofRY
	+tWyJVISJ4yxvIKeo0Xy2OvqGPOmhLg=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=XZSGheTd;
	spf=pass (imf18.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.150 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787735456;
	b=p6JIjs8qJbFBcvIsCMiem2v8zNesiW0NTcSlOnp6rTOafJRoEDqi0rVb672eSR4NltMpjB
	Ej9znfT+KsKRsUEpL1GeB7JqitmQrfB0KZqXzt5TyjqYlwxeKAaNFp6NzGoa+pHGj8rHMF
	57lWsMyg435NYnay2Bf/cixo4yGVR9U=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=LpyoEPH8E0Gsq814oLQU/XuDIOiTR9inNMFtgsjW038=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787735454; v=1; x=1788340254;
 b=XZSGheTd7/73ZHpOCk+8l9mSbuxwGDEsVP50czQPk0YPXgLNak3Vzb9sv3P8YSYmekwivozM
 VQfFlQq9HjLZFwP/ijQ8Cb99zTC3GBcu1xZJLidjJbX531EXV6c7l8XJnet9Pl4eg8ODeJJ7DkF
 A1DAV4ILa3zoscivJApJpOAU=
X-Envelope-To: linux-mm@kvack.org
Received: from localhost (223.70.159.239)
	by mta10.migadu.com with ESMTPS id e9f1f6d0c26bd38a;
	Wed, 26 Aug 2026 09:10:54 +0000
X-Mizu-Trace-ID: e9f1f6d0c26bd38a
X-Migadu-Flow: FLOW_OUT
Date: Wed, 26 Aug 2026 17:10:47 +0800
From: Baoquan He <baoquan.he@linux.dev>
To: "Barry Song (Xiaomi)" <baohua@kernel.org>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, axelrasmussen@google.com,
	baolin.wang@linux.alibaba.com, chenridong@xiaomi.com,
	david@kernel.org, hannes@cmpxchg.org, kasong@tencent.com,
	lianux.mm@gmail.com, linux-kernel@vger.kernel.org, ljs@kernel.org,
	lyugaofei@xiaomi.com, mhocko@kernel.org, qi.zheng@linux.dev,
	shakeel.butt@linux.dev, stevensd@chromium.org,
	wangzicheng@honor.com, weixugc@google.com, yuanchu@google.com,
	zhangbo56@xiaomi.com
Subject: Re: [PATCH 2/6] mm/mglru: batch update lrugen->protected in
 inc_min_seq()
Message-ID: <ao6tlwWNN1MH29w7@fedora>
References: <20260821102538.22642-1-baohua@kernel.org>
 <20260821102538.22642-3-baohua@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260821102538.22642-3-baohua@kernel.org>
X-Stat-Signature: usbwqxat6rzhbfmr9x39e5uq7nknkcj9
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: CBD531C0005
X-Rspam-User: 
X-HE-Tag: 1787735455-197516
X-HE-Meta: U2FsdGVkX1+8tSZyqUZX/a2obVWppK6zkcLFgfpF09vz2/sXo6go4C0Qq/VbPUL+7lA3RXY1nXR1/tyk3fcJFgezzNbecaJGXE6tIYlTG4lfRHJSObZBc14lohubx7FxRKVY1rvKaaA0/RDbbe7Enc8uXi423K4zzYnLBL6qv9+9h9el7BtRhX8m/oDwQdLT65nOydclfxf/2zqGeFq0VupyXc6yZFzXpDhJ5h9GGgGPjSP5Ww/2a8ra/+JJHtR+5CEQuK4wW7mnUnbh/NfGU9TUrlFnfxXABoT0bqZuItp5Z5fh07H/Psn0i7NEdxN/8c4CM/t83uzo0Ef5jLNdQmVl9fPPE1dyOopPZZi8tgWTEqLkNSawbJ4LDn91fP16nnqac56OaG4oljsoXF8Q0SmRgqfT4eutFmHwQj26Q2F+ZxGRE17tSh/OSfQyThPkhnIU9ZE4oU1CajvW1T55qF/3ODnQGHPTNk7ml8JgObsoGLfqBAkFWlEQ2B7+mu4XQ9Sw+I0qC6LFpvuF1ExHqo5HORI7JEoI4Dr0aswYOVesFnfiLpiFK4eGN9JPfEXsmdq8GU+chKlJrEfIQZqBM2OROR494InUt3CEtomW97nYWxOCueTNpH01xCgwRfcoKhOOnGRUI0MewMwViI8DRBardfqn62POhObaPLBRBnE00foOYuemCpaWtJpwkuCG8ASfC7nX8D5s4yOqiBeZk/iBCkX0tcLYeI7fa9NvcqKGFqj+wA9MusFYOVIjJWC/4ueZdUgU7johWS+JXodAEr5fjRSD2vewDvhiskt7e+2LjxnNPpYKqRQdtmGBvlnPPBFX1KFMZiWaacKHtUv19uAkHqjNS+cPzHP4/gGklFQ1DQVGPeGJcWt/WsW58iQlMQTgp5NV+CW3iL+dygryLmt2WTOxzadEjLSHironOD3lQ54qG1ZARiSOMmdX156nDiy0sJlazAg+hxfrWJ6
 L9K2lTKF
 W9cWECtAw2CsA/qK5OH8Up+2x5AGfnv4nNo7CQx8eQPFZPhKtFYgFLZHNDbItYFElSMDbIUYF+7+pUjcN0clwiJXKziscikfQRXm0JhDZvwS6F0pcL/Qw8+p9ry+RXgK42cCtDVmOTEvwMPurUpAV0jNABa1N/Px0+xAw0PrPzNVjamq/1hVpx9SbzUDDv7YGEv4oIEJ1syO4BA78yAvb545vWg782Qco4yQT0b0dNUIP/b6CA9Qbfz4pYCu2d4ZYfwaVGvUL4x9KtY+sye8Tz6X6zdNUjvj8mlBwp82EfUoptFttLrXKCbwxzUnoga958ZLJ+YiXSdb1MBw7JSWR4j87CdDrEBazKMO8hTLYWc93O4tRhA3lQVJEGZNMWDUoDf5KCgv4vGrKf/Y9O3Gva4dY9FTLJ/Y3mHAqL+fKoY8aWypTYtLl14D8lLVwXZBYGCuzb/1udH3Hp1cJn07kA/Kxaw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 08/21/26 at 06:25pm, Barry Song (Xiaomi) wrote:
> Avoid updating lrugen->protected with WRITE_ONCE() for each folio,
> which may prevent potential compiler optimizations. Accumulate the
> updates locally and apply them in a batch instead.

Wondering how much efficiency this can bring, is there a number for this
standalone patch?

> 
> Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
> ---
>  mm/vmscan.c | 8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)
> 
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 0d74fc00abd3..99ee3c833d54 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -3931,7 +3931,7 @@ static bool inc_min_seq(struct lruvec *lruvec, int type, int swappiness)
>  	/* prevent cold/hot inversion if the type is evictable */
>  	for (zone = 0; zone < MAX_NR_ZONES; zone++) {
>  		struct list_head *head = &lrugen->folios[old_gen][type][zone];
> -		unsigned long delta = 0;
> +		unsigned long protected[MAX_NR_TIERS] = {}, delta = 0;
>  
>  		while (!list_empty(head)) {
>  			struct folio *folio = lru_to_folio(head);
> @@ -3953,8 +3953,7 @@ static bool inc_min_seq(struct lruvec *lruvec, int type, int swappiness)
>  			if (refs + workingset != BIT(LRU_REFS_WIDTH) + 1) {
>  				int tier = lru_tier_from_refs(refs, workingset);
>  
> -				WRITE_ONCE(lrugen->protected[hist][type][tier],
> -					   lrugen->protected[hist][type][tier] + nr_pages);
> +				protected[tier] += nr_pages;
>  			}
>  
>  			if (!--remaining)
> @@ -3964,6 +3963,9 @@ static bool inc_min_seq(struct lruvec *lruvec, int type, int swappiness)
>  			   lrugen->nr_pages[old_gen][type][zone] - delta);
>  		WRITE_ONCE(lrugen->nr_pages[target_gen][type][zone],
>  			   lrugen->nr_pages[target_gen][type][zone] + delta);
> +		for (int tier = 0; tier < MAX_NR_TIERS; tier++)
> +			WRITE_ONCE(lrugen->protected[hist][type][tier],
> +				   lrugen->protected[hist][type][tier] + protected[tier]);
>  		if (!remaining)
>  			return false;
>  	}
> -- 
> 2.34.1
> 

