Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F3215CA9EBD
	for <linux-mm@archiver.kernel.org>; Sat, 10 Oct 2026 02:14:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CA3116B008A; Fri,  9 Oct 2026 22:14:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C534E6B008C; Fri,  9 Oct 2026 22:14:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B6C3F6B0095; Fri,  9 Oct 2026 22:14:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8CBE36B008A
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 22:14:31 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 018D0806D8
	for <linux-mm@kvack.org>; Sat, 10 Oct 2026 02:14:30 +0000 (UTC)
X-FDA: 85305097542.01.B13EEFE
Received: from mail-oi1-f171.google.com (mail-oi1-f171.google.com [209.85.167.171])
	by imf15.hostedemail.com (Postfix) with ESMTP id 2E5F6A0002
	for <linux-mm@kvack.org>; Sat, 10 Oct 2026 02:14:29 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=openai.com header.s=google header.b=OSm1lyPs;
	dmarc=pass (policy=reject) header.from=openai.com;
	spf=pass (imf15.hostedemail.com: domain of kylebot@openai.com designates 209.85.167.171 as permitted sender) smtp.mailfrom=kylebot@openai.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791598469;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ewsgbjqBMzM/54gVEY1eYtAsThNx/wBnYzgn18kV244=;
	b=Lminq8lMq/To7+ViqFKq7lApJxYbsOsmfiTrM3pr3W8cZQEk+dzQRL+5w882ZSHfKTjC7a
	y5O7WbNKwCsByQqPiUpN+Laeak6CYKugFAorxzftwJoa7OMeC8XScE2Hc+xOPWstmnGzgH
	AaLsgsxAD8xo0tYwXd4cnksnS43u6yM=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=openai.com header.s=google header.b=OSm1lyPs;
	dmarc=pass (policy=reject) header.from=openai.com;
	spf=pass (imf15.hostedemail.com: domain of kylebot@openai.com designates 209.85.167.171 as permitted sender) smtp.mailfrom=kylebot@openai.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791598469;
	b=CY/n7kSIzLsE2AzqJYJAbyql873yuuwHa8f1hNTtuKyqMxX2esM1BZg5YSYs71Tl5mQwnK
	0kxQp2+Wtvt2BYwJOkNnMfqceTK6qyTyyC8SA/58tN85TTGYPd/ZdA3nC4O/nDF9dtcZyR
	z6vcVaezD+jHho2YEmgYeXSKmyccigA=
Received: by mail-oi1-f171.google.com with SMTP id 5614622812f47-4f58dce2ad9so250217b6e.1
        for <linux-mm@kvack.org>; Fri, 09 Oct 2026 19:14:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=openai.com; s=google; t=1791598468; x=1792203268; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=ewsgbjqBMzM/54gVEY1eYtAsThNx/wBnYzgn18kV244=;
        b=OSm1lyPsOShORHZqljnxYQyrprBCLHIcBnVarAEIAM+WTtr98CDI7LvmlLHXw1zXO+
         8j+DurTrD98Awgb9bs8NyhMYUZkBQmw6GNW7FFtAI6bUqkGUz/rBjwPGfMe0qnedS/Jh
         3OXxRtPmMO4Kk32qnTqwJ5B89i80Pi/aI9i7s=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791598468; x=1792203268;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ewsgbjqBMzM/54gVEY1eYtAsThNx/wBnYzgn18kV244=;
        b=QYHQutlvveYmZhWYXsJWAS7f4cTnteZmDCqlx0ajWJrsOmGkH84Pu4zExPloxw+qGY
         7HdTqYs5gfEC1E8p4NuNM+bYPpiveCF8zKxiAQr7pORnjlICQmzET30adji6kmfIEy1B
         KQgn/f/CziYk98cpBsoUVe5qHEaALI0gg1wkIfWu7h4OieqageJ1l++j50XK8vtq8djy
         kB19y8H5wRTihWVTAj8yOQQvtx63ZjP0/41+mrsZN9DpHv7oUiguu5iX27uNIYoaOSXR
         QRThTFTxa/qKP/mHYq4RVrjebXlXr/5McptAEHNs5Q6k6mWYHREonl6JCf7HDThAhVwM
         SKiA==
X-Forwarded-Encrypted: i=1; AKwUvBxdeEUZzJ5JmnwBZbhP9gpskku0ofStylSVZW2ppDnklK5M+tnKJdEgQbAuNnNQiaw2Qwn3uAcf3g==@kvack.org
X-Gm-Message-State: AFq9FYJBagSGsCbMU52znGt91Jg6bqLe/VKZGB4oZCFL+b/l/iff4eTV
	yotOFLaRs8wJcGcJNI/rVuehV7RnxKew9B+c1ueI9BsjXgd0w91w9Jah3cBlbOpqQvU=
X-Gm-Gg: AYBFou1mDQYM9b5vdE8KKGWVdgl/jMan7eZ3/tJip1hnP6F/JC54AD4lEjWs+6yNLZS
	KgLu9f5IjBCb+IgzwCK//JAlH5DqPQ/yWQG75yg3HAyjdpLTwiXyUDdYINaegD/tFjeTWmYFGm2
	TXn9jGpMeWLBKcq6vTIwOLNOd/+jVr96FAQDEbfJsdlQ/MhrDnxNsYQMqnI+wfU0KVdz1ptdTTg
	h0eBG2zcMgbim7VXsOTpayIDwymS5CwXXpgInONWJDapuICJs4qrIKCB6rKUbTwhWo6ReJ9F9b2
	xp6pEAFseDiOC+Ya9BXayBwdQRlnNJo2rm9WfZwiA2lKZ/QnALBhCMDrzuYS9mQbamie3DFIxM+
	elJPokmRvxAnknDE1+I4vkXNI5oIFhYwGM/QQGGWuC08jM8jdOSypHOE6KuKLzdfaDsWt8s899o
	lZZbFPbuOkTQIRcwQbCDNJm5V7e6nDDigj/gVhQTciQp5/8NDiL0baP0ga3Ehi7+RPgGSJN98ts
	Zrb+tLMRHqrSi/OSsl2a00oN24x0WWfrU2FXbOfJ6WNWhISyvKe0g==
X-Received: by 2002:a05:6808:3384:b0:4b9:a8ac:489 with SMTP id 5614622812f47-50c52a4eb8cmr3292704b6e.39.1791598467997;
        Fri, 09 Oct 2026 19:14:27 -0700 (PDT)
Received: from com-75606 ([199.47.143.7])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-50c0c5fe916sm4211994b6e.1.2026.10.09.19.14.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Oct 2026 19:14:27 -0700 (PDT)
Date: Fri, 9 Oct 2026 19:14:22 -0700
From: Kyle Zeng <kylebot@openai.com>
To: Zi Yan <ziy@nvidia.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>, Rik van Riel <riel@surriel.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>, Harry Yoo <harry@kernel.org>,
	Jann Horn <jannh@google.com>, Lance Yang <lance.yang@linux.dev>,
	stable@vger.kernel.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/rmap: don't discard lazyfree THPs at PMD level
Message-ID: <asmffmSz9MSjxD04@com-75606>
References: <20261009-lazyfree-stable-fix-v1-1-70997958ef8d@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261009-lazyfree-stable-fix-v1-1-70997958ef8d@nvidia.com>
X-Stat-Signature: f1b4exxqgpdf9mau9shh7r85uqjjfz9o
X-Rspam-User: 
X-Rspamd-Queue-Id: 2E5F6A0002
X-Rspamd-Server: rspam08
X-HE-Tag: 1791598469-57119
X-HE-Meta: U2FsdGVkX1+YKCExSNXZrNmZdrajRvdmDQhyp2Cm8wNm2HtC6D8lAh53zSQ6w3phbDIZoOhWhGe+TUzO7rmLcN3jrqTwO4WmNCiUGfaCqUeIKz2BcvCgXaKoOIPuW1p/9kI1pE3WbAVRPl9iDpeP4LZutsEjjErKc+dTsYwERFyNOPDZzzUPjSmgvUiLLgkL41T1O/4NP1IPBgkVIoxZ74sTHJMrw/wiBdYL0FyW3irTIYl1yCzBXniTNlFcsc+NGZVUyAe4cM8xC0SFxBsoZM7Zq3AmK+bvSoCv1ntmMCgDa0w8PwN4U128w8W5lgyBwZDey9jkt6z4qVlLYL6Dzd8QxyeBkX7sxUVcdjK2DOwBlBZuVLTVheK7ZcuN/Uto/9NEF8JMNnirboTFSObC9vowS963xiEZ6lwb94FFxs3sRJ3Zo+hS/W1QjS4oDNAJ+F/exgi4E+g48w5yVsNv3yfsn1/p0dR5K1IaXMrHbywXI9eAE8D2ypgcIPl/TXImIL9OecI43r4Ht/efpbMvl4xVf2Sy7NYLPCyc/+2+ah9oWJfSRgUSWsFWmLuyHVVICoU1jUyam6oI62kKt6AU+nttcr6ZZ9H/EUJ8RgACQzXYUQWCZQ9Ls4tpmswaqSkE/4fC28Gr3NQgZ/hyc/Qpyqqo64n7ZIwRueh9ku78ZORZ/Y7GCmIMDX+9+NF0NFBJP87Lf48woKVPucUAjC91ko935dR0SAf+p1hPy3hU/NYMrWcg5LSF50mLA6eXBkIeJD4nqwbz5IG+rox0j/VzhoSEB29idFOotbS+J7ioZrBB2tcAceaXrNY5tgCwXELtlu0x9gJOJaQly1JMi0c/XO3WSBNW8GJcvkSawb9HtBaLnQYzkheMD/K4JNSF8Opk7uzVbVxNu0KZKj4DFmxBQA4mOTYvLojmvOf9BDHl9bTn6+C1P41ZRR8JkD4/Z5Rez2tAFTm4M73N0A4wIxb
 S0eizFoO
 3jfJJHPTd+McqE6t2fLXdvvU7nO0N7Ehs8zrODyApge/oM0sssk8zcoO5Bb2Y6mQqMR9Omio2dfAOxW4orrcvPw9IhS5SGGgpobFgCZZPNVxPmDFcVRIti/DQZqYzcTHlp+iE2t5yOoeS6nHq50qZow6P8wLs9P36b0Lid/luk0+W2mUzSgW3RG3DL+f6jjJ+ldsomoHYJmeK8rEh0V59d3SuXo9UKKH8PRbGzTaepDsdps47gtdv9pgzs6Krcaa96BX2exqh5gxQ48IY/1Km99nwlnZd8lKniJHj4+celqNWigh8JULKXpCwJfzZRHT2sLWSpZmngI7DZgZhX3QWHhcIwM0QDBqR5WaY1SHpPWwDdCmqc6i+6Z42AWDuS1JL2s+9
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 09, 2026 at 10:08:18PM -0400, Zi Yan wrote:
> __discard_anon_folio_pmd_locked() clears a lazyfree THP PMD before it knows
> whether the folio can be discarded, and restores it if the folio was
> redirtied or has extra references. A concurrent munmap() or
> MREMAP_DONTUNMAP skips the temporary none PMD and unlinks the VMA from its
> anon_vma, so the folio stays mapped after the anon_vma is freed and a later
> rmap walk uses the freed anon_vma.
> 
> Using an invalidated PMD instead of a cleared one requires additional arch
> code fixes. Instead, disable the PMD level discard of lazyfree THPs, as
> before commit 735ecdfaf4e8 ("mm/vmscan: avoid split lazyfree THP during
> shrink_folio_list()").
> 
> Fixes: 735ecdfaf4e8 ("mm/vmscan: avoid split lazyfree THP during shrink_folio_list()")
> Reported-by: Kyle Zeng <kylebot@openai.com>
> Closes: https://lore.kernel.org/r/20261009165214.40212-2-kylebot@openai.com
> Cc: stable@vger.kernel.org
> Assisted-by: LLM
> Signed-off-by: Zi Yan <ziy@nvidia.com>
> ---
> The proposed fix[1] requires additional arch code fixes[2]. Disable it
> first for stable fix. The function will be re-enabled along with arch code
> fixes.
> 
> Link: https://lore.kernel.org/all/20261009165214.40212-2-kylebot@openai.com/ [1]
> Link: https://lore.kernel.org/all/DM0II2QHWWS1.2RXEJXC8S0101@nvidia.com/ [2]
> ---
>  mm/rmap.c | 11 -----------
>  1 file changed, 11 deletions(-)
> 
> diff --git a/mm/rmap.c b/mm/rmap.c
> index 805db93fe0428..1131b76bbbc28 100644
> --- a/mm/rmap.c
> +++ b/mm/rmap.c
> @@ -2275,17 +2275,6 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
>  		}
>  
>  		if (!pvmw.pte) {
> -			if (folio_test_lazyfree(folio)) {
> -				if (unmap_huge_pmd_locked(vma, pvmw.address, pvmw.pmd, folio))
> -					goto walk_done;
> -				/*
> -				 * unmap_huge_pmd_locked has either already marked
> -				 * the folio as swap-backed or decided to retain it
> -				 * due to GUP or speculative references.
> -				 */
> -				goto walk_abort;
> -			}
> -
>  			if (flags & TTU_SPLIT_HUGE_PMD) {
>  				/*
>  				 * We temporarily have to drop the PTL and
> 
> ---
> base-commit: 8b38ed9ab5b09c8ba168cbcc49524e9b380ee5c4
> change-id: 20261009-lazyfree-stable-fix-67712b2049dd
> 
> Best regards,
> --  
> Yan, Zi
> 

Reviewed-by: Kyle Zeng <kylebot@openai.com>

