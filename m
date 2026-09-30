Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6A4F5CA5FBE
	for <linux-mm@archiver.kernel.org>; Wed, 30 Sep 2026 10:03:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5B6626B008A; Wed, 30 Sep 2026 06:03:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 566016B008C; Wed, 30 Sep 2026 06:03:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 45A9F6B0095; Wed, 30 Sep 2026 06:03:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1936B6B008A
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 06:03:44 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id AC8131406FF
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 10:03:43 +0000 (UTC)
X-FDA: 85269991926.03.98C5030
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id F23B780008
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 10:03:41 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=c39Xhitk;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790762622;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ml0DuYlmFa9hQaDKnLTS0bQy6dNO9ILQKsOk1hfaR/Q=;
	b=KPBeOcvtgA2SPNnyuv+QOp1Ws4O9DjKVr9XdKCNtaRYCKGi5bR6ZO7LOwE2a3qjCccTu46
	OvkmSwlwCvcTGio9IXVbfXENM9M3tpHguDnQUpsc0Pwg2j1qvdr9qczRcLWRZ+CxCsZ4sT
	3K0u8qFPTBm0qu4h5DZhb6gADr4t+yg=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=c39Xhitk;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790762622;
	b=s0GzW4RrzKo62KdbEKVjJC2eF7YUB3v4BLZAgGiWkW6I7LVwGrsj2CmTETi0sTuHNctys5
	ZKpuIpcr9tno62VJfBv5xe+cHmqS94j6tOzyD1NAxaplziQINfuWyZFKXeEnduRRgDVOCk
	H7cPX0n48ENL4OoPpuemw6JSKF/Su5k=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 661A660239;
	Wed, 30 Sep 2026 10:03:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23E321F00893;
	Wed, 30 Sep 2026 10:03:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790762621;
	bh=Ml0DuYlmFa9hQaDKnLTS0bQy6dNO9ILQKsOk1hfaR/Q=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=c39XhitkGKdQ/yXBH5DDEEOWKDiqpWzdQvRaLfGE0PbANlGxw3t6EWIwyiiGPY6/a
	 5iONMk1hgoZFGooMXpm2iSxvYrW0gbGPkpbdkYU5fqNalHrPKmOoWDIZtqT2KEUvm6
	 98c61JZfXQ9uNRxkzSIwvdIuqK/HkIE77N6mNBd7f92BX1xqAneUSTjBz+FDf0wj6Q
	 RhCqBYOIinjgtNh8N7msgGmQse1xAwbAG+hKZng0Iz6lUaSRLIIwhQ7Krg4q1roAH2
	 OOuL/d6430Qpme+7Mrcvis+5vRvFxhm4MwV+lY/wRDF9JcEB7ZEcEoExcOe4aMl3sz
	 kZqp+4Vb1nOiQ==
Message-ID: <8f509b48-db3e-44ff-8423-1e43a35daa01@kernel.org>
Date: Wed, 30 Sep 2026 12:03:36 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/hugetlb: avoid recursive i_mmap_rwsem in PMD sharing
To: Li Zhe <lizhe.67@bytedance.com>, akpm@linux-foundation.org,
 muchun.song@linux.dev, osalvador@suse.de
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Oscar Salvador <osalvador@suse.de>, "Lorenzo Stoakes (Arm)" <ljs@kernel.org>
References: <20260930064308.58159-1-lizhe.67@bytedance.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260930064308.58159-1-lizhe.67@bytedance.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: a4okrz9x8k4wyu93w6sm8owhtdoqcp8i
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: F23B780008
X-HE-Tag: 1790762621-811196
X-HE-Meta: U2FsdGVkX18d9iZ7jf8NNS7PmQ2mSAXV8xKH0t4abvnAGJebhYYjxI3EJe9TpoBqCFNEogd9ze+9NexFTgx8NzTFmyzkON2jWKcraNpcE/cjBM7UIZH/CQDWHc+2R78LJI8wq+OgpnW0IVTSrtnl6ucOog6Wp+NRTp9MjNMJQGXQ6sMEGt1mInuk8wbK+cFLigrgfe6QUDrlTTKGOQ31QFu79RDWg3K//xh0RMIaTyZEWD8u154uh2ai9us8SxSfyluz27ngMGFuqfedf5AmTIm6ScvYjE5ZNbSBtnH7vq2uq4Ztqm1VX3HuItZbOtGe2XvMhsyTgQNr8Cn8z0uIDNDR5TPiqoVALt0CuqtZu/TldzKR8D+xr2ikB3Ub1BjMCu6OHWqrKCM2fcmBrTx7eGzebacDOdEtPSXVMrLaHj5fslsp5BQUEqP3VGEJsvUPrpMnoeqk4zAbQxedMDiJhSMyKdnhXmOy7HIhk4jUYqazwouJKj0Zm+nQPbYZo0I0HG3dwQOp2ezo28VUL1igSp22tTW/1/Ci5spwkUY4JHOTav8YOuM/ThjbuYRUhQIb3qcPFQ4yyWDYGm932AVcJ8lCowvue6wFYAIgDCRHjGPbBja+wIwklmOY7zjn4VejdQDqJ2/3bFc9WOYEt2TO1ppJd3pqDvRcLLilr6mwLOx6Dg/BFpVCwmc51yUTJEghTByMSZN8Tg4KbcHLmZ/HchnnHOG3+pV5De4D+WcFhj6wyrbMbWTkspP8rTtrze1Jd237NwOTDHIMWMzzNfQBmZeBlNC+6Jwv8a6Xj+/Trbbr0EjB/hdS8zHQvZIa5uiHG6MsrK7qmIH6obV/rsDVoKPDV9ByAvh/jRIKM0wYRf2lsimRdvPMbnhW4WCZx8SxcgcadDubfDVtYAa9aSIh9mfeWJv2ADzLycNmpUzjibA4VpTjKj+xxx2DtkNx/cV0xDbY3gZA23aCAku7uHD
 aFQqG99t
 V2ktXVRjEJu/8YnZ9NvY73rrckUzukicdJbaSvhGTBa41GouWYQTdedK/CF8YaBMrnGZGX2nvIx9+iJxjhmm/6Dzj6TKQVwjeuYzyymQWtQUeSzgbVkOyqogRWasd4udMGG9jVeJuWxWKXcLmR6FuCfEXSaEajtooss+RxyTTv6JAfxeVZy7fQWPsMTyf6YOHmFKrVFGI/RIj9be0K6NCH3grMmlDnOVMHFiu4pGiIc92RMMOHu0FzxwrnGa4hG8g1EGODJmtOlwDkG5fJPm+gOLtwX0glk1TR7nOrd7cjiNBTXRtdKXaftjpVlsRdCIhxIYz9Vg+xoi2+mA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/30/26 08:43, Li Zhe wrote:
> huge_pmd_share() always takes i_mmap_rwsem for read before looking for a
> shareable PMD page table.
> 
> That is unsafe for callers that already hold the same mapping lock for
> write.  In particular, move_hugetlb_page_tables() takes i_mmap_rwsem for
> write to prevent truncation races, then calls huge_pte_alloc() for the
> destination address.  If the destination PUD is empty and PMD sharing is
> possible, huge_pte_alloc() can call huge_pmd_share(), which then tries to
> take the same rwsem for read and can deadlock on itself.
> 
> PMD sharing is only an optimization.  If the read side of i_mmap_rwsem
> cannot be acquired immediately, fall back to allocating a private PMD
> table instead of blocking in the sharing path.
> 
> Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
> ---
>  mm/hugetlb.c | 14 ++++++++++++--
>  1 file changed, 12 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index cea25773a6c95..75631101a6807 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -6995,7 +6995,15 @@ pte_t *huge_pmd_share(struct mm_struct *mm, struct vm_area_struct *vma,
>  	pte_t *spte = NULL;
>  	pte_t *pte;
>  
> -	i_mmap_lock_read(mapping);
> +	/*
> +	 * Some callers already hold i_mmap_rwsem for write, for example
> +	 * move_hugetlb_page_tables(). PMD sharing is only an optimization, so
> +	 * fall back to a private PMD table instead of blocking on the same
> +	 * rwsem in read mode.
> +	 */

"just an optimization" is not entirely true. There are workloads that depend on
huge pmd sharing to work. So I don't think this is acceptable.

There was a private discussion on this issue recently (for some weird reason the
deadlock was reported as a security issue), 2 months ago I think.

Oscar, I recall that you wanted to send a proper patch?

-- 
Cheers,

David

