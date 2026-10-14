Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 21272CC6B2D
	for <linux-mm@archiver.kernel.org>; Wed, 14 Oct 2026 20:40:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3B68B6B009B; Wed, 14 Oct 2026 16:40:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 367C76B009D; Wed, 14 Oct 2026 16:40:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2592B6B009E; Wed, 14 Oct 2026 16:40:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0132E6B009B
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 16:40:47 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 8FB4780764
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 20:40:47 +0000 (UTC)
X-FDA: 85322400534.08.2A6186F
Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com [209.85.160.175])
	by imf01.hostedemail.com (Postfix) with ESMTP id 570B140007
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 20:40:45 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=i60MjBND;
	dmarc=pass (policy=none) header.from=cmpxchg.org;
	spf=pass (imf01.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.160.175 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792010445;
	b=qxioKdWpUuvU0WltTImr+l7k4wf/QyRk29BRBVK+cjQKQs9GVi78tvZgIxUr6XG5WXokVP
	37PVvP5vLBwIBkjONCItnVbTH2tZ829XhaVYQi2oZBJmY0dzfvpuA1e8LOH8b4TPVKFP1E
	iaVDcMqZEp79cEaEntyV735JDvJVwD4=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=i60MjBND;
	dmarc=pass (policy=none) header.from=cmpxchg.org;
	spf=pass (imf01.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.160.175 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792010445;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4ZzboJ+fBHb0sZhaDRiaNRbOcPWLCVijOqfXtCDwsFU=;
	b=6i5oTP6gUBIPPUIT6MykKf7vaLv6gTVmwozdrVw2LWB7+/1SnYBLr9uWbktar69mezXPvk
	el+nUz/7tIoRc1TKPsbrqjuDPYSb8OX5cxBJ6/q6lG60WxyGTlaS8sMqRkjsVpH4Wwk/Ky
	v0uggL0eCNVJhRoRE2glBuLLoH15P9g=
Received: by mail-qt1-f175.google.com with SMTP id d75a77b69052e-5339381b46eso46047301cf.1
        for <linux-mm@kvack.org>; Wed, 14 Oct 2026 13:40:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1792010444; x=1792615244; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=4ZzboJ+fBHb0sZhaDRiaNRbOcPWLCVijOqfXtCDwsFU=;
        b=i60MjBNDA+BoKISEEfgaKNqPYUy9oq8V+FRfZknfIOHFwgQXngYGsZdpgp9JMy0n+d
         XTuwMq+9gro74lrrvLUGjgDbgl382k3Eu0dtZWJv2qgIsyTmRDnivzu8eGRSUZT5YSpC
         zoIYF82ukctX97sq1G5ZjkckH0J/c2BqIXjVCF2SIrfwfElg53V5Efjaov6kzl07/0w6
         ySxFxnCx7Br3GOpQqo0rLqqVRZC2wzlZdAm73JPuQzH8ZBnh6eFhlImHap8O6zWJ01h/
         K6dpSebCZY1jQSiX3H6gD0uAsW9QNs8bfwkc1Mpd1IkenOvmGuYVB47owN5U9gnI0I7G
         IQMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792010444; x=1792615244;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=4ZzboJ+fBHb0sZhaDRiaNRbOcPWLCVijOqfXtCDwsFU=;
        b=ELW/bWC8gbSbq+cd0PJ/8p7/ykTDLNuqq5B/wzOUCxyBFLbNCpc3k936wTOGzyDjRi
         QCe4Jni55ty6FYsd+NvxLv75cEymvBy3UXfU8Z0ElSJiiZDXvRhvs+6QukGAeFocWzHS
         GTEObNLILJo5XVJwIcEnRHphBr7PjFc2C8IvQvwCHNmeTmmOwOnDnJSIbK/6yUYger2R
         y/oaW2jIUPz5vUbYYAJw9RbeTHce1YX2SJNQXP7fZ40rMz1pX01NZHH/+AFP6/Q6+YuU
         PyzGz4XO+8VLhKrTk9+Pzukw75K7YSYjTJwRW6CAm5BU81ptb3cdCnqsgAp/3l+iKu3l
         eWbQ==
X-Forwarded-Encrypted: i=1; AKwUvBxKiHuMwDcvIK50BS28Oczb5won16EXYVLWrGG0op9S/pKKhUkvXaei0mIrh9pysMJggfp2E2nqaQ==@kvack.org
X-Gm-Message-State: AFq9FYLqT9z3IxzH9t+OpJn2SL7FAxqfai2Cx7cxtxsDxCr6L4ohxeN0
	bTQG/a05OKoy5CaVFAOihK8gr9roQXmX592JVAfQxCQ9MWGucCnlzUWS/Bik2syJSL4=
X-Gm-Gg: AYBFou19DF6e1pV8jZGt7olOi54TeJMoGL+P+9MJ62Ee9S700JxC4sl874Y2rSm9MX3
	xCzlWpoHB5c//dy/16/YgAcYZAUlk93zicom0uyRy5Nv0LPDjYxY/BTHquCUZAjIlX13rAWOg/6
	gmtpGSZHs02kMZLQ335w5Gz0hO2uWx7aBJehYDSr3a8S+kDxeYZDotpfZKU0Xgg1tCrD/IhfBgt
	b+9sLZvlGUwdB7pikrvbsuan0XerQrZobwaU4j44/O6vi3k+S9xj94eiap5EbnAAN1HRs1ffzaD
	9w8IoR6Gzy+4wJoynng+2d/hFfEgl5y5KKPQ1pd/4eFDtk2JOISdXkkJTZLQWMhMfjeM7LlNw/n
	v84w/mQfApdn/E5Kp0yd4c3J/vOnQ7/NtRP69ZS2UTXPm6T294Kvtzr31hpGsvFFB01nQUp1olQ
	8KE33LNUb11f+EDeU0/JkRkCB+ZH52b606PMx4K7aKfEQNeCv6AL/hzXvIZ1f4NkLX1fjYJw==
X-Received: by 2002:a05:622a:251a:b0:532:f124:18dd with SMTP id d75a77b69052e-5359f49891emr274507121cf.11.1792010444315;
        Wed, 14 Oct 2026 13:40:44 -0700 (PDT)
Received: from localhost ([2603:7001:f100:5081:9526:3c0:45cc:5ac6])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-536127baba0sm6256231cf.13.2026.10.14.13.40.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Oct 2026 13:40:43 -0700 (PDT)
Date: Wed, 14 Oct 2026 22:40:42 +0200
From: Johannes Weiner <hannes@cmpxchg.org>
To: Rik van Riel <riel@surriel.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <brendan.jackman@linux.dev>,
	Zi Yan <ziy@nvidia.com>, Kairui Song <kasong@tencent.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	Baoquan He <baoquan.he@linux.dev>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Mike Rapoport <rppt@kernel.org>, linux-mm@kvack.org
Subject: Re: [RFC PATCH 2/5] mm/page_alloc: count a merged buddy's pages
 under the merged type
Message-ID: <20261014204042.GH371161@cmpxchg.org>
References: <20261007021250.1665929-1-riel@surriel.com>
 <20261007021250.1665929-3-riel@surriel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261007021250.1665929-3-riel@surriel.com>
X-Stat-Signature: 3texeq8o6x659w8nuhqkpppspdd3ugis
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 570B140007
X-HE-Tag: 1792010445-219178
X-HE-Meta: U2FsdGVkX1+DK2Kgy6hQHAAkioH+mnRlNp7hNhQEtMQpIqYPIFkPv4DY9kzE/SRmaHUN53Xjb7lXVvnL9Y/Eb2M7svCTgO0HTyJTPYgKIk2Uadzhf5stVlm2Qy1B9hSMeWrZl2HWd+mlTf35bWVARVgEglBOX65D3crDR7AE9kNiiUAwDte5VlGNAnAZs5YOjlx07YM5iyTYn+g9fY0HKsHr3S5o2zGFcGJ9EK2Mbo5FJ14krU/hYMlErAoviFqDV8SYFim2KgGSO3VNYzwL2QdAyZCBs3Gfv6hz/XZhT1YIPUy3cyoT9NmLK+/EgKWN3pbMAr9eKCMuczclVaHm+9a+Jb962W7CLOPOOpYvgE5yJX6ZfLtH9DmJHRlX43CEXx1rx5+gXkB9n40RHDqUNG2N/N+g42xEJ5ZgTJ+x9tJjWP6sQRcGYlzRCmTNdigG7LKaB1s0qsd+kDYJvOHdWh+4VQys4z8yIn7zqJ3G4XFKisG7fKiVn2cPy5UszMR+mAz7caZ+f/kDV6wZoZcDp3MeWZt7b0H/a5EMwoM6XDaqX9kxJA8Z+30uMkInt76Vf3WmVf9ZHvPoubJHJ0/88/8f8EU3vVoK0VzAOF/zkwUrqpc1HwSLhZ0WH49HdFqfKZfDM8CmBHDqRBcdkOkJICNsBBt+Cjmfy6Cite2/oeSH/OSZnrhGmGIVhSJV/OH/a3qSCxSrAE47SBPnzL+koTMw/ahGvCJZimk6Iz4sHAgw4oce9Rf/3WlCr0BBlISK3LaZ9j+A846w+qGNWQEk74wZF9EcpQ0LmJKRWMLuviaaMZawAHQhBPCmDoFi0X/9G9CKy/4NRdhVmB6e2kd7Iq/zzg1sE5+pEcqprJBUHAnhcwklCCdLcVbA6xaG0xmuSZlZ6vNpNBEDbI/VeaBl/Q5FH/tyfz/TEM5z4buPF3wnluNzK4WDe2O+OBpUdy6sWjt/Txvcs3ds2/NlqjH
 gbn7y9mU
 Yg039JJonC+4JSB4HWWWDbVJb/LI1oOsoq4Rb8MTI8z/madPG/oveSrRTuPj7kYbDOOgxPhwT6+AXCmzy5fxUMwM30ZrQqFPZMNbdCDc8HVgdjUy+RAWcJf4dufIoBuCNUhd3OkBufmtYAuECDTpM6N/2CkrBN2OfEWkHvNHaiu5Ai8tRsMyxPb5FQJpKJRMTcD4wDJjbCZLd9qsisniebapSPskoufsFtvQgSO/bOgqkvQ8t74Vj9zOrNsbsPyD0wpXv73y4DT2x39uNsnAfaaZQFc6/rFDuMo/D4unhmNH9aj8tzPw3O7dNFmlp+lW5/Bm16ka3XH0Az7S8is9ejGGP/Urhi410Pbhm+SzAgBuuRi8WGIDGA2c7LN1jyV9VUMKgAgB+Z30OeE9zz/iOX0Z3fo4rctk3+bfz0kuo6t8VKQ3lFd0BPdRs89Hu1jFaPxcZEi6NqwCcYJ0a5nTPGLHN/amLAovcBRJoujc6IJe5uNT09/xJKhDbEMByztCsaMxE1a42PFVO0O0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Oct 06, 2026 at 10:12:47PM -0400, Rik van Riel wrote:
> __free_one_page() merges a freed page with a free buddy of another
> mergeable type at pageblock order and above, and retypes the buddy to
> match. The buddy's pages stay counted under the old type: nothing moves
> them to the merged type in the free counts.
> 
> That is unobservable today. NR_FREE_PAGES does not separate types, so the
> missing move nets to zero there.  Any future per-type free count would
> undercount on a merge from the other side, and allocating the merged
> run later could wrap it.
> 
> Move the buddy's pages to the merged type in the count too.
> 
> Assisted-by: LLM
> Signed-off-by: Rik van Riel <riel@surriel.com>
> ---
>  mm/page_alloc.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 4658af97be010..ae38e25971559 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -993,6 +993,11 @@ static inline void __free_one_page(struct page *page,
>  			account_freepages(zone, 1 << order, migratetype);
>  		} else {
>  			__del_page_from_free_list(buddy, zone, order, buddy_mt);
> +			/* The buddy's free pages join the merged block's type. */
> +			if (unlikely(buddy_mt != migratetype)) {
> +				account_freepages(zone, -(1 << order), buddy_mt);
> +				account_freepages(zone, 1 << order, migratetype);

Reasonable on one hand, but I think at that point it would be simpler
and more robust to drop that 'single account_freepages() + __add/__del
operations' optimization, and just use the accounting add/del variants
directly instead.

