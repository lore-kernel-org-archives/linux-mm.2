Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 631E1CD5BDF
	for <linux-mm@archiver.kernel.org>; Tue, 26 May 2026 11:34:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 81A546B0088; Tue, 26 May 2026 07:34:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7F2556B00C3; Tue, 26 May 2026 07:34:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7082A6B00C5; Tue, 26 May 2026 07:34:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5D6FC6B0088
	for <linux-mm@kvack.org>; Tue, 26 May 2026 07:34:55 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id F06011203E1
	for <linux-mm@kvack.org>; Tue, 26 May 2026 11:34:54 +0000 (UTC)
X-FDA: 84809364108.19.1706CF6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 4C008A0002
	for <linux-mm@kvack.org>; Tue, 26 May 2026 11:34:53 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AuC8Ormn;
	spf=pass (imf15.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779795293;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CYlCxqGn9eyAHsyJU/x1r418fe4eHyS6ad58vkdZw5c=;
	b=yy/EeKy0V9+h+gQj1RoezhwzsYYCUSULVsJogCwd2DKWfZek0j4qZpdYwaBXQIKogLhQiu
	jVp9HLcTGYRc+wLGr9N+HFohHWwk3TDffAEYkoD7ky13WXz8fZcGkwTWhh/ge2NyGbeM2N
	KQJRTN0c+e60zPYkwjOOH8uJpFioqC0=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AuC8Ormn;
	spf=pass (imf15.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779795293; a=rsa-sha256;
	cv=none;
	b=5d+9r6sEAJ/cF2cavGdDRD8QB12BuYoiQOtKUd3OjKmy5garVEbjSgxiaz/wR2ctK/THrJ
	0hrcz/3s/xFej9kiC9ItSJn5pUkj9n3JORhj0IJZBQ8rFVLvG2umsH6gt8Pw6G2ojEnEJs
	C/2kxpBfdx+9AsuRZ8KzSUrC4gMlhZo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8702E44434;
	Tue, 26 May 2026 11:34:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAFB71F00A3E;
	Tue, 26 May 2026 11:34:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779795292;
	bh=CYlCxqGn9eyAHsyJU/x1r418fe4eHyS6ad58vkdZw5c=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=AuC8OrmnkCS5GBts4i+afa7uSm8tobKvKBFSaLJnZqsdc6fnoquQIyLqzSyDqD9mL
	 z9oQ5une4pGQforxy2zsV6Jl2QbjlCkmAmejphngaHc8VPBu+D/j/JhG6mRgR0fJ2U
	 cTeAJzaBKhWMY7R+TmFkvjdix3Yf/h/1WKgl+FpwKgRbn4Wng7ZmdXetuvIGFr9ZPP
	 odA/d4n9RB9HMVlQtPL7xXeRlcJv7W/onG//mAvvpTs7DZ6uILnQrCLVFV2fdEi8k2
	 Yfe4vAAFAnMGIydKy7orC/h8UcWKCgWyQ/Z49nmv7yAG6tovEzWBzzpCPkgmypITG2
	 DGeNrEbQtRhPA==
Message-ID: <da9700c1-1d28-4c6e-a57c-a236f7ca5a4c@kernel.org>
Date: Tue, 26 May 2026 13:34:48 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm/page_alloc: remove VM_BUG_ON()s from pindex helpers
To: Brendan Jackman <jackmanb@google.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260526-page_alloc-unmapped-prep-v2-1-412f4d486115@google.com>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Content-Language: en-US
In-Reply-To: <20260526-page_alloc-unmapped-prep-v2-1-412f4d486115@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 4C008A0002
X-Stat-Signature: 3q1xff6hr4utsn8zxt5pbcir14skcxk6
X-HE-Tag: 1779795293-60731
X-HE-Meta: U2FsdGVkX180LioEzzMtNFww4gJT8o04MzTt/O1HIn79x83FO4AZIZYJ1/boAEOXItowzZCTC3nKHqTh794N/Lb6b5oiuIscuomsjKlrClhoQBqTNJ0USl0KFXanVFnBppPGcuOGI+HwYcWXmWlJDOcEAWgRqWee329pws5pm2dd1HnnPCbKONdgsM0rgDZ4L2/QSzJ7kMSvfwtVn7EIPdpwTHZqkldd1fc+lbGBRCBhSJ4cOtzZlEm3r+YvJ9uHs6BPoJzaPBe6h0/2POXX7twE5Ezjxbshff0tslKlbGXx3aruhd+ciaEj9AAjBcLORUrr/NpJ1L6lUzdJnMPV4QsM/leTKLmL9d14j8ul93LRqW40yqvZoCKQjImGvw0RkyVmwrCxf9QkmcTVVSmqm2U3m91ryyzvSnSEvcBW+1V4Jw5YGfTY2zFK8aJHJDz7QkswMm25VVah+U9SIPi/P/Mm558PvCI/yI8KCbsHAR/9PR2JkGyB4TFxQZ3p5P/uvwOylILxf8qgMb5cdzNd5k0Y53ijMn/jXiALtXYHwR1dKqxU8lc5HiGfUkrSCxipO8QZ0BVouZfgiL1YD+1ZkPuysdQkX8iMYYg8KorGXJAI1P07n8n2nXw79uH0O6obsl5TyXdPUBJqoIBPmCkeFLiQwbTzEf+76yRfO6BbwCh/D4/5DoaerhK3kFqjq9dvM6yxfewf66hXhgBgnTnjYvcDZ4KOU67uqfnV97x/ACUVweLTzYzXLn62i18QnvJ+AL9GQn8YBzBu1U4KrPpOUPBIMXfs61lhAXitQ7nEQzC14rr+adyIxz0somIbwhisnL8hjlX7Dz63/MmPpNJb1XrnzFMxqh9+KMyrOkSJKt/4MFmBckbQ7TyfBm2/x9FtVWVEq7OXaE0jV5l7rrFn3FIKwtZG0AJFsA3iAbDt6wRPliEvdrVaq0Ao9u3IgNh9ElWE+/pdjH2grduA/s8
 STF22fdg
 Y44PfK0FPBvcnFhSeifROtNg7M2RcfrM8Gi3h67LMnW/wZENgYc51C7UkIQEEpbAgdB5EGsYMXg+31cBVcI35MXPMiRG6NMb5D6S4CkVzKkUS5Yso+trEhYZU1jfLLe/GeIH5Kv+pkWP+1ikt3EGDSVdeN9YO+2P7szIX3y4mD+TF/waP2tKuewaM9YqJ3wcXbXer8j2h/V40rRR30+hpPAclrJxUa+8w/giZY4DsVjO16pCU5ONqN/O2jf/mx/q3t5y72G9avWreZAIkLErzXYx81haZER19mEXTtefmvKcYs/2ET9Ey7HWpwQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/26/26 1:28 PM, Brendan Jackman wrote:
> Vlastimil pointed out that the VM_BUG_ON()s have fallen out of
> favour, so remove them.
> 
> Suggested-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
> Link: https://lore.kernel.org/all/4074a816-9e75-45a6-8141-25459bcc106b@kernel.org/
> Signed-off-by: Brendan Jackman <jackmanb@google.com>

Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>

Thanks.

> ---
> Changes in v2:
> - Rebased onto mm-new, removed VM_BUG_ON()s
> - Link to v1: https://lore.kernel.org/r/20260513-page_alloc-unmapped-prep-v1-0-dacdf5402be8@google.com
> ---
>  mm/page_alloc.c | 9 +--------
>  1 file changed, 1 insertion(+), 8 deletions(-)
> 
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 1b5b1e556f76feadf21f3f44a9440fe883fb7651..e47679e7a9dbc772aa27f550a10aa8c0e95af55a 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -653,13 +653,8 @@ static inline unsigned int order_to_pindex(int migratetype, int order)
>  	if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE)) {
>  		bool movable = migratetype == MIGRATE_MOVABLE;
>  
> -		if (order > PAGE_ALLOC_COSTLY_ORDER) {
> -			VM_BUG_ON(!is_pmd_order(order));
> -
> +		if (order > PAGE_ALLOC_COSTLY_ORDER)
>  			return NR_LOWORDER_PCP_LISTS + movable;
> -		}
> -	} else {
> -		VM_BUG_ON(order > PAGE_ALLOC_COSTLY_ORDER);
>  	}
>  
>  	return (MIGRATE_PCPTYPES * order) + migratetype;
> @@ -672,8 +667,6 @@ static inline int pindex_to_order(unsigned int pindex)
>  	if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE)) {
>  		if (pindex >= NR_LOWORDER_PCP_LISTS)
>  			order = HPAGE_PMD_ORDER;
> -	} else {
> -		VM_BUG_ON(order > PAGE_ALLOC_COSTLY_ORDER);
>  	}
>  
>  	return order;
> 
> ---
> base-commit: da0a06486ac3ce47c6ffb603d2fd332229d41592
> change-id: 20260512-page_alloc-unmapped-prep-c3ae0381d58b
> 
> Best regards,


